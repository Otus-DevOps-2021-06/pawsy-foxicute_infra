terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

# Чтобы запустить и проверить конф. файды terraform, нужно или
# раскоменнтировать строки выше (1-8) или выполнить команду
# в директории terraform terraform 0.13upgrade .
