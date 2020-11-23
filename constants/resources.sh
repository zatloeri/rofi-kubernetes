DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
declare -A RESOURCES
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