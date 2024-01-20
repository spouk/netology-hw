//-----------------------------------------------------------------------
// kms
// ----------------------------------------------------------------------
resource "yandex_kms_symmetric_key" "key-a" {
  name              = "simmetrickey"
  description       = "simmetrickey for crypt bucket object"
  default_algorithm = "AES_128"
#  rotation_period   = "8760h"
  lifecycle {
    prevent_destroy = false
  }
}
//-----------------------------------------------------------------------
// object storage
// ----------------------------------------------------------------------
// создание статического ключа доступа
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = var.stockvars.service_account_id
  description        = "static access key for object storage"
}
// создание бакета с использованием ключа
resource "yandex_storage_bucket" "test" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "aleksey.martynenko.13012024"
  anonymous_access_flags {
    read = true
    list = false
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.key-a.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
}
//загрузка объекта в бакет, в данном случае картинки
resource "yandex_storage_object" "test-object" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
#  bucket     = var.stockvars.bucket_image
  bucket     = yandex_storage_bucket.test.id
  key        = "helloworld.jpg"
  source     = "img/zerro.jpg"
}
