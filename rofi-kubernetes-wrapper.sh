#!/bin/bash
ROFI_KUBERNETES_PATH="/home/erik/.config/rofi/libs/rofi-kubernetes.sh"
CUSTOM_THEME_PATH="/home/erik/.config/rofi/themes/search-slate.rasi"

declare -A OPTIONS
declare -A RESOURCES
declare -A CUSTOM_NONRESOURCE_OPTIONS

CUSTOM_DELETE_ALL="[custom] delete everything";

OPTIONS=(
    ["get"]="kubectl get"
    ["watch"]="watch kubectl get"
    ["delete all"]="kubectl delete --all"
)

CUSTOM_NONRESOURCE_OPTIONS=(
    [$CUSTOM_DELETE_ALL]="kubectl delete --all"
)

RESOURCES=(
    ["all"]="all"
    ["pod"]="pod"
    ["deployment"]="deployment"
    ["service"]="service"
    ["mongodb"]="mongodb"
    ['configmap']="configmap"
    ['secret']="secret"
    ['statefulsets']="statefulsets"
)

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

gen_resource_list() {
    for i in "${!RESOURCES[@]}"
    do
        echo "$i"
    done
}

gen_namespace_list() {
    kubectl get namespaces | awk 'NR>1' | awk '{print $1;}'
}

option=$( gen_options_list | rofi -p option -dmenu -mesg "Choose an <b>option</b>" -no-custom -theme $CUSTOM_THEME_PATH)

if [[ -z "$option" ]]; then
    exit
fi

if [[ -z ${CUSTOM_NONRESOURCE_OPTIONS[$option]} ]]; then
    resource=$( gen_resource_list | rofi -dmenu -p resource -mesg "Choose a <b>resource</b>" -no-custom -theme $CUSTOM_THEME_PATH)
    if [[ -z "$resource" ]]; then
        exit
    fi  
fi

namespace=$( gen_namespace_list | rofi -dmenu -p namespace -mesg "Choose a <b>namespace</b>" -no-custom -theme $CUSTOM_THEME_PATH)

if [[ -z "$namespace" ]]; then
    exit
fi

if [[ "$option" == "$CUSTOM_DELETE_ALL" ]]; then
    COMMAND_TO_EXEC="echo \"deleteing everything in $namespace\""
    for i in "${!RESOURCES[@]}"
    do
        COMMAND_TO_EXEC="$COMMAND_TO_EXEC && ${CUSTOM_NONRESOURCE_OPTIONS[$option]} $i -n $namespace"
    done
    gnome-terminal -- bash -i -c "export HISTFILE=~/.bash_history\
        && set -o history\
        && history -s \"${COMMAND_TO_EXEC}\"\
        && history -a\
        && ${COMMAND_TO_EXEC}\
        ;exec bash"  
    exit 0
fi

gnome-terminal -- bash -i -c "export HISTFILE=~/.bash_history\
 && set -o history\
 && history -s \"${OPTIONS[$option]} ${RESOURCES[$resource]} -n $namespace\"\
 && history -a\
 && ${OPTIONS[$option]} ${RESOURCES[$resource]} -n $namespace\
 ;exec bash"  

