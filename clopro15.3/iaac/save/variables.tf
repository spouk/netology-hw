//-----------------------------------------------------------------------
// variables
// ----------------------------------------------------------------------
variable "stockvars" {
  type = object({
    folder_id          = string
    service_account_id = string
    image_id           = string
    zone               = string
    bucket_image       = string
  })
  default = {
    folder_id          = "b1g6jkfnul7b3vp4jegm"
    service_account_id = "ajes3frpfc5989q8mesr"
    image_id           = "fd827b91d99psvq5fjit"
    zone               = "ru-central1-a"
    bucket_image       = "aleksey.martynenko.13012024"
  }
}