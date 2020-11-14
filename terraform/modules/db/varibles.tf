variable yandex_compute_instance_zone {
    description =  "Zone for compute instance"
    default = "ru-central1-a"
}

variable public_key_path {
    description = "Path to public key used for ssh access"
}

variable db_disk_image {
    description = "Disk image for reddit db"
    default = "reddit-db-base"
}

variable subnet_id {
    description = "Subnet"
}

variable private_key {
  description = "Path to private key, used for connect via ssh"
  default = "~/.ssh/appuser"
}
