#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/../lib/kubectl-commands.sh
source $DIR/../constants/options.sh
source $DIR/../constants/resources.sh
option=$1

NAMESPACE_LIST=$( fetch_namespace_list ) 

if [[ $? == 1 ]]; then
    rofi -e "kubectl failed to get namespaces. Check if kubectl is setup correctly."
    exit
fi

namespace=$(  echo -e -n "$NAMESPACE_LIST" | awk '{print $1;}' | rofi -kb-custom-1 "Control+c" -dmenu -p namespace -mesg "Choose a <b>namespace</b>" -no-custom )

NAMESPACE_EXIT_CODE=$?

if [[ -z "$namespace" ]]; then
    exit
fi

if [[ "$option" == "$CUSTOM_DELETE_ALL" ]]; then
    COMMAND_TO_EXEC="echo \"deleteing everything in $namespace\""
    for i in "${!RESOURCES[@]}"
    do
        COMMAND_TO_EXEC="$COMMAND_TO_EXEC && ${CUSTOM_NONRESOURCE_OPTIONS[$option]} $i -n $namespace"
    done
fi

echo "$COMMAND_TO_EXEC"
exit $NAMESPACE_EXIT_CODE