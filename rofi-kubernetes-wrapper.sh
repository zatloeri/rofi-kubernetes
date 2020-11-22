#!/bin/bash
source constants/options.sh

gen_options_list() {
    for i in "${!OPTIONS[@]}"
    do
        echo "$i"
    done
    for a in "${!CUSTOM_NONRESOURCE_OPTIONS[@]}"
    do
        echo "$a"
    done
}

option=$( gen_options_list | rofi -p option -dmenu -mesg "Choose an <b>option</b>" -no-custom)

if [[ -z "$option" ]]; then
    exit
fi

if [[ -n ${CUSTOM_NONRESOURCE_OPTIONS[$option]} ]]; then
    COMMAND_TO_EXEC=$( ./modules/nonresource-module.sh "$option" )
else
    COMMAND_TO_EXEC=$( ./modules/resource-module.sh "$option" )
fi

if [[ $? == 10 ]]; then
    echo "$COMMAND_TO_EXEC" | xclip -selection c
    exit
fi

gnome-terminal -- bash -i -c "export HISTFILE=~/.bash_history\
 && set -o history\
 && history -s \"$COMMAND_TO_EXEC\"\
 && history -a\
 && $COMMAND_TO_EXEC\
 ;exec bash"  

