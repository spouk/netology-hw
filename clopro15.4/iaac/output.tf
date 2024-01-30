//-----------------------------------------------------------------------
// output results
// ----------------------------------------------------------------------
output "kubernetes_cluster_info" {
  value = format("\tid => %s\n\tipv4ext => %v\n\tipv4int => %v\n\tgetcredentialforusekubectl => %s\n",
    yandex_kubernetes_cluster.kubernetescluster.id,
    yandex_kubernetes_cluster.kubernetescluster.master[0].external_v4_address,
    yandex_kubernetes_cluster.kubernetescluster.master[0].internal_v4_address,
    "yc managed-kubernetes cluster get-credentials ${yandex_kubernetes_cluster.kubernetescluster.id}   --external"
  )
}
#output "kubernetes_work_nodes" {
#  value = yandex_kubernetes_node_group.kubernodegroup.
#}