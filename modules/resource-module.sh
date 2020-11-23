#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/../lib/kubectl-commands.sh
source $DIR/../constants/options.sh
source $DIR/../constants/resources.sh
option=$1

gen_resource_list() {
    for i in "${!RESOURCES[@]}"
    do
        echo "$i"
    done
}

resource=$( gen_resource_list | rofi -dmenu -p resource -mesg "Choose a <b>resource</b>" -no-custom )

if [[ -z "$resource" ]]; then
    exit 402
fi  

NAMESPACE_LIST=$( fetch_namespace_list ) 

if [[ $? == 1 ]]; then
    rofi -e "kubectl failed to get namespaces. Check if kubectl is setup correctly."
    exit 1002
fi

namespace=$(  echo -e -n "$NAMESPACE_LIST" | awk '{print $1;}' | rofi -kb-custom-1 "Control+c" -dmenu -p namespace -mesg "Choose a <b>namespace</b>" -no-custom )

NAMESPACE_EXIT_CODE=$?

if [[ -z "$namespace" ]]; then
    exit 402
fi

COMMAND_TO_EXEC="${OPTIONS[$option]} ${RESOURCES[$resource]} -n $namespace"

echo $COMMAND_TO_EXEC
exit $NAMESPACE_EXIT_CODE