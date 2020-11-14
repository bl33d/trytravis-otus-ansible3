resource "yandex_compute_instance" "db" {
    name = "reddit-db"
    zone = var.yandex_compute_instance_zone
    labels = {
        tags = "reddit-db"
    }

    resources {
    cores  = 2
    memory = 2
    }

    metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
    }

    boot_disk {
        initialize_params {
        image_id = var.db_disk_image
        }
    }

    network_interface {
        subnet_id = var.subnet_id
        nat       = true
    }

  # connection {
  #   type        = "ssh"
  #   host        = self.network_interface.0.nat_ip_address
  #   user        = "ubuntu"
  #   agent       = false
  #   private_key = file(var.private_key)
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo sed -i 's/bindIp: 127.0.0.1/bindIp: ${self.network_interface.0.ip_address}/' /etc/mongod.conf",
  #     "sudo systemctl restart mongod"
  #   ]
  # }

}
