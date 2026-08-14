# Core library for the command package.
#
# A command is a bash function living in a file named after it. It declares
# what it takes with a few calls at the top of its own body, and cmd-parse
# turns those declarations into help text, parsing and validation. The
# declaration is executable code inside the function, so nothing ever has to
# read the source file to find out what a command does.
#
#   function convert-video {
#     cmd-dsc  "Convert video to mp4 format for archiving."
#     cmd-arg  input file                                 "Video file to convert"
#     cmd-arg  target dir =.                              "Directory to write into"
#     cmd-opt  --vq "enum(lossless|high|medium|low)" =medium "Video quality"
#     cmd-flag -r --replace                               "Replace the original file"
#     cmd-env  FFMPEG_BIN                                 "ffmpeg binary to use"
#     cmd-example "convert-video a.mkv --vq high --replace"
#     cmd-parse "$@" || return $CMD_RC
#
#     ffmpeg -i "$ARG_input" ...
#   }
#
# Declarations:
#   cmd-dsc     <text>                              description line, repeatable
#   cmd-arg     <name> <type> [=default] <text>     positional parameter
#   cmd-opt     <flag>... <type> [=default] <text>  option taking a value
#   cmd-flag    <flag>... <text>                    option taking no value
#   cmd-env     <NAME> <text>                       environment variable read
#   cmd-example <text>                              example invocation, repeatable
#
# A positional with a default is optional; one without is required. A type
# ending in '...' collects the remaining arguments into an array. Types
# containing '(' or '|' must be quoted, because bash would otherwise treat
# them as syntax.
#
# Types: string int file dir path newpath enum(a|b|c)
#
# cmd-parse binds every declared parameter to ARG_<name>, with '-' replaced by
# '_', and sets CMD_RC to the value the command should return. It returns
# non-zero whenever the command body must not run, either because help was
# shown or because validation failed. Hence the single-line contract:
#
#   cmd-parse "$@" || return $CMD_RC

# Source file for every loaded command, keyed by command name. Used by cmds
# to know what exists; nothing reads these files to find a spec.
declare -gA CMD_FILE=()

# Set by cmd-parse to the value the calling command should return.
declare -g CMD_RC=0

# Declarations accumulate here between the first cmd-* call and cmd-parse.
# __CMD_OWNER names the command they belong to, so a stale set left behind by
# a command that returned before parsing is never read by the next one.
declare -g __CMD_OWNER=""
declare -ga __CMD_DSC=()
declare -ga __CMD_ARGS=()
declare -ga __CMD_OPTS=()
declare -ga __CMD_ENVS=()
declare -ga __CMD_EXAMPLES=()

# Field separator inside a packed declaration. Unit separator never appears in
# help text.
__CMD_FS=$'\x1f'

# ------------------------------------------------------------------ internals

function __cmd_reset {
  __CMD_OWNER=""
  __CMD_DSC=()
  __CMD_ARGS=()
  __CMD_OPTS=()
  __CMD_ENVS=()
  __CMD_EXAMPLES=()
}

# Start a fresh declaration set when the calling command differs from the one
# that owns the current set. Called from each cmd-* declaration, so FUNCNAME[2]
# is the command itself.
function __cmd_begin {
  local owner=${FUNCNAME[2]:-}
  [ "$__CMD_OWNER" == "$owner" ] && return 0
  __cmd_reset
  __CMD_OWNER=$owner
}

# Turn a parameter or flag name into the variable suffix used for ARG_*.
function __cmd_var_name {
  local n=$1
  n="${n#--}"
  n="${n#-}"
  printf '%s' "${n//-/_}"
}

# Colour for output on the given file descriptor, or nothing when that
# descriptor is not a terminal. Keeping escape codes out of pipes is what lets
# `cmds -d` read a description straight out of `<cmd> -h`.
function __cmd_color {
  local fd=${2:-1}
  [ -t "$fd" ] || return 0
  # Colours hold real escape characters, so they work as %s arguments. The
  # library must still work when sourced on its own, hence the default.
  printf '%s' "${!1:-}"
}

# Extra wording for an unknown option when the command has a varargs
# parameter. Such a command exists to hand options to something else, and the
# only thing standing between the user and that is the '--' separator, so the
# error says which one to use rather than leaving them to read the help.
function __cmd_passthrough_hint {
  [ -n "${1:-}" ] || return 0
  printf ' (options for <%s> must come after --)' "$1"
}

function __cmd_error {
  local name=$1 msg=$2
  printf '%s%s: %s%s\n' \
    "$(__cmd_color COLOR_RED 2)" "$name" "$msg" "$(__cmd_color COLOR_RESET 2)" >&2
}

# Split a packed declaration into __f_* fields.
function __cmd_unpack {
  local packed=$1
  local parts=()
  local old_ifs=$IFS
  IFS=$__CMD_FS read -r -a parts <<<"$packed"
  IFS=$old_ifs
  __f_name=${parts[0]:-}
  __f_type=${parts[1]:-string}
  __f_default=${parts[2]:-}
  __f_has_default=${parts[3]:-0}
  __f_desc=${parts[4]:-}
}

# Pull an optional '=default' out of the argument list. Sets __d_default and
# __d_has, and reports how many arguments were consumed.
function __cmd_take_default {
  __d_default=""
  __d_has=0
  if [[ ${1:-} == "="* ]]; then
    __d_default=${1#=}
    __d_has=1
    return 0
  fi
  return 1
}

# Validate one value against a type. Prints the reason on failure.
function __cmd_validate {
  local type=$1 value=$2 label=$3

  case $type in
    string|"") return 0 ;;
    int)
      [[ $value =~ ^-?[0-9]+$ ]] && return 0
      echo "$label must be an integer, got [$value]"
      return 1
      ;;
    file)
      [ -f "$value" ] && return 0
      echo "$label must be an existing file, got [$value]"
      return 1
      ;;
    dir)
      [ -d "$value" ] && return 0
      echo "$label must be an existing directory, got [$value]"
      return 1
      ;;
    path)
      [ -e "$value" ] && return 0
      echo "$label must be an existing path, got [$value]"
      return 1
      ;;
    newpath)
      local parent
      parent=$(dirname -- "$value")
      [ -d "$parent" ] && return 0
      echo "$label must be inside an existing directory, got [$value]"
      return 1
      ;;
    enum\(*\))
      local allowed=${type#enum(}
      allowed=${allowed%)}
      local choice
      # Split without touching IFS: `local IFS` would stay in effect for
      # everything this function goes on to call.
      for choice in ${allowed//|/ }; do
        [ "$value" == "$choice" ] && return 0
      done
      echo "$label must be one of: ${allowed//|/, } (got [$value])"
      return 1
      ;;
    *)
      echo "$label has an unknown type [$type]"
      return 1
      ;;
  esac
}

# --------------------------------------------------------------- declarations

# dsc:Add a description line to the calling command.
function cmd-dsc {
  __cmd_begin
  __CMD_DSC+=("$1")
}

# dsc:Declare a positional parameter: cmd-arg <name> <type> [=default] <text>
function cmd-arg {
  __cmd_begin
  local name=$1
  local type=${2:-string}
  shift $(( $# >= 2 ? 2 : $# ))
  if __cmd_take_default "${1:-}"; then shift; fi
  __CMD_ARGS+=("$name$__CMD_FS$type$__CMD_FS$__d_default$__CMD_FS$__d_has$__CMD_FS${1:-}")
}

# dsc:Declare an option taking a value:
# dsc:cmd-opt <flag>... <type> [=default] <text>
function cmd-opt {
  __cmd_begin
  local flags=()
  while [[ ${1:-} == -* ]]; do
    flags+=("$1")
    shift
  done
  local type=${1:-string}
  [ $# -gt 0 ] && shift
  if __cmd_take_default "${1:-}"; then shift; fi
  local packed
  packed=$(IFS='|'; printf '%s' "${flags[*]}")
  __CMD_OPTS+=("$packed$__CMD_FS$type$__CMD_FS$__d_default$__CMD_FS$__d_has$__CMD_FS${1:-}")
}

# dsc:Declare an option taking no value: cmd-flag <flag>... <text>
function cmd-flag {
  __cmd_begin
  local flags=()
  while [[ ${1:-} == -* ]]; do
    flags+=("$1")
    shift
  done
  local packed
  packed=$(IFS='|'; printf '%s' "${flags[*]}")
  __CMD_OPTS+=("$packed${__CMD_FS}flag${__CMD_FS}false${__CMD_FS}1$__CMD_FS${1:-}")
}

# dsc:Declare an environment variable the command reads.
function cmd-env {
  __cmd_begin
  __CMD_ENVS+=("$1$__CMD_FS${2:-}")
}

# dsc:Add an example invocation.
function cmd-example {
  __cmd_begin
  __CMD_EXAMPLES+=("$1")
}

# ---------------------------------------------------------------------- help

# Build the one-line usage string from unpacked declarations.
function __cmd_usage_line {
  local name=$1
  shift
  local -n _args=$1
  local -n _opts=$2

  local usage="$name"
  local item primary bare

  for item in ${_opts[@]+"${_opts[@]}"}; do
    __cmd_unpack "$item"
    primary=${__f_name##*|}
    if [ "$__f_type" == "flag" ]; then
      usage+=" [$primary]"
    elif [[ $__f_type == enum\(* ]]; then
      bare=${__f_type#enum(}
      usage+=" [$primary <${bare%)}>]"
    else
      usage+=" [$primary <$__f_type>]"
    fi
  done

  for item in ${_args[@]+"${_args[@]}"}; do
    __cmd_unpack "$item"
    bare=${__f_type%...}
    if [ "$__f_type" != "$bare" ]; then
      usage+=" [$__f_name...]"
    elif [ "$__f_has_default" -eq 1 ]; then
      usage+=" [$__f_name]"
    else
      usage+=" <$__f_name>"
    fi
  done

  printf '%s' "$usage"
}

# Render help from the declarations passed by name.
function __cmd_render_help {
  local name=$1
  local -n _dsc=$2
  local -n _args=$3
  local -n _opts=$4
  local -n _envs=$5
  local -n _examples=$6

  local c_name c_dsc c_arg c_env c_dim c_reset
  c_name=$(__cmd_color COLOR_MAGENTA)
  c_dsc=$(__cmd_color COLOR_LIGHT_YELLOW)
  c_arg=$(__cmd_color COLOR_YELLOW)
  c_env=$(__cmd_color COLOR_CYAN)
  c_dim=$(__cmd_color COLOR_DARK_GRAY)
  c_reset=$(__cmd_color COLOR_RESET)

  printf '%s%s%s\n' "$c_name" "$name" "$c_reset"

  local item
  for item in ${_dsc[@]+"${_dsc[@]}"}; do
    printf '%s%s%s\n' "$c_dsc" "$item" "$c_reset"
  done

  echo
  printf '%sUsage: %s%s\n' \
    "$c_arg" "$(__cmd_usage_line "$name" "$3" "$4")" "$c_reset"

  local suffix
  if [ ${#_args[@]} -gt 0 ]; then
    echo
    printf '%sArguments:%s\n' "$c_arg" "$c_reset"
    for item in "${_args[@]}"; do
      __cmd_unpack "$item"
      suffix=""
      [ "$__f_has_default" -eq 1 ] && [ -n "$__f_default" ] && \
        suffix=" ${c_dim}(default: $__f_default)"
      printf '%s  %-14s %-24s %s%s%s\n' \
        "$c_arg" "$__f_name" "$__f_type" "$__f_desc" "$suffix" "$c_reset"
    done
  fi

  if [ ${#_opts[@]} -gt 0 ]; then
    echo
    printf '%sOptions:%s\n' "$c_arg" "$c_reset"
    for item in "${_opts[@]}"; do
      __cmd_unpack "$item"
      suffix=""
      [ "$__f_type" != "flag" ] && [ "$__f_has_default" -eq 1 ] && [ -n "$__f_default" ] && \
        suffix=" ${c_dim}(default: $__f_default)"
      printf '%s  %-14s %-24s %s%s%s\n' \
        "$c_arg" "${__f_name//|/, }" "$__f_type" "$__f_desc" "$suffix" "$c_reset"
    done
  fi

  if [ ${#_envs[@]} -gt 0 ]; then
    echo
    printf '%sEnvironment:%s\n' "$c_env" "$c_reset"
    for item in "${_envs[@]}"; do
      __cmd_unpack "$item"
      printf '%s  %-14s %s%s\n' "$c_env" "$__f_name" "$__f_type" "$c_reset"
    done
  fi

  if [ ${#_examples[@]} -gt 0 ]; then
    echo
    printf '%sExamples:%s\n' "$c_dsc" "$c_reset"
    for item in "${_examples[@]}"; do
      printf '%s  %s%s\n' "$c_dsc" "$item" "$c_reset"
    done
  fi
}

# --------------------------------------------------------------------- parsing

# dsc:Parse and validate the calling command's arguments against the
# dsc:declarations made above it. Binds ARG_<name> for each parameter and sets
# dsc:CMD_RC. Returns non-zero when the command body must not run.
function cmd-parse {
  local name=${FUNCNAME[1]}
  CMD_RC=0

  # Take a private copy of the declarations, then clear the shared set so the
  # next command starts clean even if this one returns early.
  local dsc=() args=() opts=() envs=() examples=()
  if [ "$__CMD_OWNER" == "$name" ]; then
    dsc=(${__CMD_DSC[@]+"${__CMD_DSC[@]}"})
    args=(${__CMD_ARGS[@]+"${__CMD_ARGS[@]}"})
    opts=(${__CMD_OPTS[@]+"${__CMD_OPTS[@]}"})
    envs=(${__CMD_ENVS[@]+"${__CMD_ENVS[@]}"})
    examples=(${__CMD_EXAMPLES[@]+"${__CMD_EXAMPLES[@]}"})
  fi
  __cmd_reset

  # Index the declarations.
  local p_names=() p_types=() p_defaults=() p_required=()
  local varargs_name="" varargs_type=""
  declare -A o_type=() o_default=() o_target=()

  local item
  for item in ${args[@]+"${args[@]}"}; do
    __cmd_unpack "$item"
    local bare=${__f_type%...}
    if [ "$__f_type" != "$bare" ]; then
      varargs_name=$__f_name
      varargs_type=$bare
    else
      p_names+=("$__f_name")
      p_types+=("$__f_type")
      p_defaults+=("$__f_default")
      p_required+=("$((1 - __f_has_default))")
    fi
  done

  local flag target
  for item in ${opts[@]+"${opts[@]}"}; do
    __cmd_unpack "$item"
    target=$(__cmd_var_name "${__f_name##*|}")
    for flag in ${__f_name//|/ }; do
      o_type[$flag]=$__f_type
      o_target[$flag]=$target
      o_default[$flag]=$__f_default
    done
  done

  # Seed every declared variable, clearing anything a previous call left.
  local i var
  for ((i = 0; i < ${#p_names[@]}; i++)); do
    var="ARG_$(__cmd_var_name "${p_names[i]}")"
    printf -v "$var" '%s' "${p_defaults[i]}"
    declare -g "$var"
  done
  if [ -n "$varargs_name" ]; then
    var="ARG_$(__cmd_var_name "$varargs_name")"
    declare -ga "$var=()"
  fi
  for flag in "${!o_target[@]}"; do
    var="ARG_${o_target[$flag]}"
    printf -v "$var" '%s' "${o_default[$flag]}"
    declare -g "$var"
  done

  # Walk the arguments.
  local positionals=()
  local only_positional=0
  local errors=()
  local token err

  while [ $# -gt 0 ]; do
    token=$1

    if [ "$only_positional" -eq 0 ]; then
      if [ "$token" == "--" ]; then
        only_positional=1
        shift
        continue
      fi

      if [ "$token" == "-h" ] || [ "$token" == "--help" ]; then
        __cmd_render_help "$name" dsc args opts envs examples
        CMD_RC=0
        return 1
      fi

      if [[ $token == --*=* ]]; then
        local key_part=${token%%=*}
        local value_part=${token#*=}
        if [ -n "${o_type[$key_part]:-}" ]; then
          if err=$(__cmd_validate "${o_type[$key_part]}" "$value_part" "$key_part"); then
            printf -v "ARG_${o_target[$key_part]}" '%s' "$value_part"
            declare -g "ARG_${o_target[$key_part]}"
          else
            errors+=("$err")
          fi
        else
          errors+=("unknown option [$key_part]$(__cmd_passthrough_hint "$varargs_name")")
        fi
        shift
        continue
      fi

      if [ -n "${o_type[$token]:-}" ]; then
        if [ "${o_type[$token]}" == "flag" ]; then
          printf -v "ARG_${o_target[$token]}" '%s' "true"
          declare -g "ARG_${o_target[$token]}"
          shift
          continue
        fi
        if [ $# -lt 2 ]; then
          errors+=("option [$token] requires a value")
          shift
          continue
        fi
        if err=$(__cmd_validate "${o_type[$token]}" "$2" "$token"); then
          printf -v "ARG_${o_target[$token]}" '%s' "$2"
          declare -g "ARG_${o_target[$token]}"
        else
          errors+=("$err")
        fi
        shift 2
        continue
      fi

      if [[ $token == -* ]] && [ ${#token} -gt 1 ]; then
        errors+=("unknown option [$token]$(__cmd_passthrough_hint "$varargs_name")")
        shift
        continue
      fi
    fi

    positionals+=("$token")
    shift
  done

  # Bind positionals.
  local count=${#positionals[@]}
  local value
  for ((i = 0; i < ${#p_names[@]}; i++)); do
    if [ "$i" -lt "$count" ]; then
      value=${positionals[i]}
      if err=$(__cmd_validate "${p_types[i]}" "$value" "<${p_names[i]}>"); then
        var="ARG_$(__cmd_var_name "${p_names[i]}")"
        printf -v "$var" '%s' "$value"
        declare -g "$var"
      else
        errors+=("$err")
      fi
    elif [ "${p_required[i]}" -eq 1 ]; then
      errors+=("missing required argument <${p_names[i]}>")
    fi
  done

  # Anything left over goes to the varargs parameter, or is an error.
  if [ "$count" -gt "${#p_names[@]}" ]; then
    if [ -n "$varargs_name" ]; then
      var="ARG_$(__cmd_var_name "$varargs_name")"
      for value in "${positionals[@]:${#p_names[@]}}"; do
        if err=$(__cmd_validate "$varargs_type" "$value" "<$varargs_name>"); then
          eval "$var+=(\"\$value\")"
        else
          errors+=("$err")
        fi
      done
    else
      errors+=("too many arguments (expected ${#p_names[@]}, got $count)")
    fi
  fi

  if [ ${#errors[@]} -gt 0 ]; then
    for err in "${errors[@]}"; do
      __cmd_error "$name" "$err"
    done
    printf '%sUsage: %s%s\n' \
      "$(__cmd_color COLOR_YELLOW 2)" \
      "$(__cmd_usage_line "$name" args opts)" \
      "$(__cmd_color COLOR_RESET 2)" >&2
    CMD_RC=1
    return 1
  fi

  return 0
}

# ------------------------------------------------------------------ registry

# Record the file a command was loaded from. Called by load.
function cmd-register-file {
  local file=$1
  local base=${file##*/}
  base=${base%.sh}
  CMD_FILE[$base]=$file
}
