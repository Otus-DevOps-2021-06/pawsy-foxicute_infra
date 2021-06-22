## Denis Yusupov Inf_Repository

### Подключение по ssh через PrivetVM.
`ssh -J appuser@178.154.203.129 appuser@10.128.0.29`
> С учетом того что ключи добавлены в агенты.

### Информация о OpenVM и ClosedVM
bastion_IP = 178.154.203.129
someinternalhost_IP = 10.128.0.29

### Инфомация о Reddit Monolith
testapp_IP = 178.154.207.66
testapp_port = 9292

### Запуск CLI
```
--name test-reddit-app \
--hostname test-reddit-app \
--memory=4 \
--create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
--network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
--metadata serial-port-enable=1 \
--metadata-from-file user-data=./metadata.yml
```

## Lesson 8
Выполненны все задания.
Добавлен балансировщик и используется `count` для создания нескольких инстансов VM.
Балансировщик работал при отключение одной из машин.

## Lesson 9
Через Яндекс Cloud был ручками создан Obj Storage.
По пути `/terraform/stage/backend.tf` можно увидеть конфиг незамысловатый.
Переменные в этом конфиге s3 использовать нельзя.  Поэтому все открыто :_)
Файлы `terraform.tfstate` успешно сохранятся в облаке.

Задание с переменной выполненно так:
```
provisioner "remote-exec" {
    inline = [
    "echo \"DATABASE_URL=\" ${module.db.network_interface.0.ip_address} \"\" | sudo tee -a /etc/environment",
    "cat /etc/environment",
   ]
  }
```
Так как у меня образы ставятся уже с установленными приложениями. То я добавляю переменную
окружения модуля db. Тем самым указывая адрес БД.
