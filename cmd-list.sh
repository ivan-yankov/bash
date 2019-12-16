function cmd-list {
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
}