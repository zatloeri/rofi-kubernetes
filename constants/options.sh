DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
declare -A OPTIONS
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