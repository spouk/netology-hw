locals {
  test_list = ["develop", "staging", "production"]

  test_map = {
    admin = "John"
    user  = "Alex"
  }

  servers = {
    develop = {
      cpu   = 1
      ram   = 4
      image = "ubuntu-20-04"
    },
    stage = {
      cpu   = 1
      ram   = 4
      image = "ubuntu-20-04"
    },
    production = {
      cpu   = 1
      ram   = 4
      image = "ubuntu-20-04"
    }
  }
}

