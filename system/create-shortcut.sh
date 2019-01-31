function create-shortcut {
	if [ "$#" != "3" ]; then
        echo "Arguments: shortcut-name execution-file icon-file"
        return
    fi

    shortcut_name=$1
    execution_file=$2
    icon_file=$3
    
    file=/home/yankov/Desktop/$shortcut_name.desktop

    echo "[Desktop Entry]" >> $file
    echo "Name="$shortcut_name >> $file
    echo "Comment=" >> $file
    echo "Exec="$execution_file >> $file
    echo "Icon="$icon_file >> $file
    echo "Terminal=false" >> $file
    echo "Type=Application" >> $file

    chmod +x $file
    chown yankov $file
}