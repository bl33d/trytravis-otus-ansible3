provider "yandex" {
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

variable cloud_id {
  description = "Cloud"
}

variable folder_id {
  description = "Folder"
}

variable zone {
  description = "Zone"
  # Значение по умолчанию
  default = "ru-central1-a"
}
resource "yandex_storage_bucket" "test" {
  bucket = "tf-test-bucket"
}
