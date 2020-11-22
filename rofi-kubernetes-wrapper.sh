#!/bin/bash

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

fetch_namespace_list() {
    kubectl get namespaces | awk 'NR>1'
}

option=$( gen_options_list | rofi -p option -dmenu -mesg "Choose an <b>option</b>" -no-custom)

if [[ -z "$option" ]]; then
    exit
fi

if [[ -z ${CUSTOM_NONRESOURCE_OPTIONS[$option]} ]]; then
    resource=$( gen_resource_list | rofi -dmenu -p resource -mesg "Choose a <b>resource</b>" -no-custom)
    if [[ -z "$resource" ]]; then
        exit
    fi  
fi

NAMESPACE_LIST=$( fetch_namespace_list ) 

if [[ $? == 1 ]]; then
    rofi -e "kubectl failed to get namespaces. Check if kubectl is setup correctly."
    exit
fi

namespace=$(  echo -e -n "$NAMESPACE_LIST" | awk '{print $1;}' | rofi -kb-custom-1 "Control+c" -dmenu -p namespace -mesg "Choose a <b>namespace</b>" -no-custom)

LAST_EXIT_CODE=$?
echo "Exit code was $?";

if [[ -z "$namespace" ]]; then
    exit
fi

COMMAND_TO_EXEC="${OPTIONS[$option]} ${RESOURCES[$resource]} -n $namespace"

if [[ "$option" == "$CUSTOM_DELETE_ALL" ]]; then
    COMMAND_TO_EXEC="echo \"deleteing everything in $namespace\""
    for i in "${!RESOURCES[@]}"
    do
        COMMAND_TO_EXEC="$COMMAND_TO_EXEC && ${CUSTOM_NONRESOURCE_OPTIONS[$option]} $i -n $namespace"
    done
fi

if [[ $LAST_EXIT_CODE == 10 ]]; then
    echo "$COMMAND_TO_EXEC" | xclip -selection c
    exit
fi

gnome-terminal -- bash -i -c "export HISTFILE=~/.bash_history\
 && set -o history\
 && history -s \"$COMMAND_TO_EXEC\"\
 && history -a\
 && $COMMAND_TO_EXEC\
 ;exec bash"  

