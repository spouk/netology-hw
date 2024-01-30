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
variable "zonelist" {
  type        = list(string)
  description = "list zones for make subnets in cluster use"
  default     = ["ru-central1-a", "ru-central1-b", "ru-central1-c"]
}
#variable "zonelistmap" {
#  type        = map(string)
#  description = "map zones for make subnets in cluster use"
#  default     = {
#    "ru-central1-a" = "10.1.0.0/16"
#    "ru-central1-b" = "10.2.0.0/16"
#    "ru-central1-c" = "10.3.0.0/16"
#  }
#}
variable "zonelistmap" {
  type        = map(list(string))
  description = "map zones for make subnets in cluster use"
  default     = {
    "a" = ["ru-central1-a", "10.1.0.0/16"]
    "b" = ["ru-central1-b", "10.2.0.0/16"]
    "c" = ["ru-central1-c", "10.3.0.0/16"]
  }
}

variable "clusterstockvars" {
  type = object({
    userdbname     = string
    userdbpassword = string
    namedbs        = string
    clustername    = string
    clusterenv     = string
    mysqlversion   = string
    protectdelete  = bool
    publicaccess   = bool
    setuphost      = map(string)
    maintance      = map(string)
    backuptime     = map(any)
  })
  default = {
    clustername    = "clustermysql"
    clusterenv     = "PRESTABLE"
    mysqlversion   = "8.0"
    protectdelete  = true
    publicaccess   = false
    userdbname     = "userdb"
    userdbpassword = "12345678"
    namedbs        = "netology_db"
    setuphost      = {
      "resource_preset_id" = "b1.medium"
      "disk_type_id"       = "network-ssd"
      "disk_size"          = "20"
    }
    maintance = {
      "type" = "WEEKLY"
      "day"  = "MON"
      "hour" = "00"
    }
    backuptime = {
      "hours"   = 23
      "minutes" = 59
    }
  }
}