//-----------------------------------------------------------------------
// service  account for kubernetes cluster
// ----------------------------------------------------------------------
// link: list roles https://cloud.yandex.ru/ru/docs/iam/concepts/access-control/roles

// - make new service account
resource "yandex_iam_service_account" "sakc" {
  name        = "sakubercluster"
  description = "service account for manipulate kubernetes cluster"
  folder_id   = var.stockvars.folder_id
}

// - grant roles for service account for manipulate kubernetes cluster
resource "yandex_resourcemanager_folder_iam_member" "kuber-k8sclustereditor" {
  folder_id = var.stockvars.folder_id
  role      = "k8s.cluster-api.editor"
  member    = format("%s:%s", "serviceAccount", yandex_iam_service_account.sakc.id)
}
resource "yandex_resourcemanager_folder_iam_member" "kuber-vpcpublicadmin" {
  folder_id = var.stockvars.folder_id
  role      = "vpc.publicAdmin"
  member    = format("%s:%s", "serviceAccount", yandex_iam_service_account.sakc.id)
}
resource "yandex_resourcemanager_folder_iam_member" "kuber-vpcuser" {
  folder_id = var.stockvars.folder_id
  role      = "vpc.user"
  member    = format("%s:%s", "serviceAccount", yandex_iam_service_account.sakc.id)
}
resource "yandex_resourcemanager_folder_iam_member" "kuber-editor" {
  folder_id = var.stockvars.folder_id
  role      = "editor"
  member    = format("%s:%s", "serviceAccount", yandex_iam_service_account.sakc.id)
}
resource "yandex_resourcemanager_folder_iam_member" "kuber-containerpuller" {
  folder_id = var.stockvars.folder_id
  role      = "container-registry.images.puller"
  member    = format("%s:%s", "serviceAccount", yandex_iam_service_account.sakc.id)
}
resource "yandex_resourcemanager_folder_iam_member" "kuber-kms" {
  folder_id = var.stockvars.folder_id
  role      = "kms.keys.encrypterDecrypter"
  member    = format("%s:%s", "serviceAccount", yandex_iam_service_account.sakc.id)
}
