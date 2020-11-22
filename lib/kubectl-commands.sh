function fetch_namespace_list() {
    kubectl get namespaces | awk 'NR>1'
}