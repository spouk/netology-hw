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

variable "zonelistpublicsubnet" {
  description = "definitions objects subnet"
  type        = object({
    a = object({
      name = string
      zone = string
      cidr = string
    }),
    b = object({
      name = string
      zone = string
      cidr = string
    }),
    c = object({
      name = string
      zone = string
      cidr = string
    })

  })
  default = {
    a = {
      name = "public-a"
      zone = "ru-central1-a"
      cidr = "192.168.10.0/24"
    },
    b = {
      name = "public-b"
      zone = "ru-central1-b"
      cidr = "192.168.20.0/24"
    },
    c = {
      name = "public-c"
      zone = "ru-central1-c"
      cidr = "192.168.30.0/24"
    },
  }
}
variable "zonelistsubnet" {
  description = "definitions objects subnet"
  type        = object({
    a = object({
      name = string
      zone = string
      cidr = string
    }),
    b = object({
      name = string
      zone = string
      cidr = string
    })
    c = object({
      name = string
      zone = string
      cidr = string
    })
  })
  default = {
    a = {
      name = "private-a"
      zone = "ru-central1-a"
      cidr = "10.1.0.0/16"
    },
    b = {
      name = "private-b"
      zone = "ru-central1-b"
      cidr = "10.2.0.0/16"
    },
    c = {
      name = "private-c"
      zone = "ru-central1-c"
      cidr = "10.3.0.0/16"
    },

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
