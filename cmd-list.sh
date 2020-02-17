function cmd-list {
    echo "Commands:"
    echo "---------"
    for dir in $BASH_SCRIPTS/*/
    do
        for file in $dir*
        do
            if [ ${file: -3} == ".sh" ]; then
                filename_without_extension=${file%.*}
                echo ${filename_without_extension##*/}
            fi
        done
    done

    aliases_file=$BASH_SCRIPTS/aliases.sh
    if [ -f "$aliases_file" ]; then
        echo
        echo "Aliases:"
        echo "--------"
        cat $aliases_file
    fi

    local_aliases_file=$BASH_SCRIPTS/local-aliases.sh
    if [ -f "$local_aliases_file" ]; then
        echo
        echo "Local aliases:"
        echo "--------------"
        cat $local_aliases_file
    fi
}
