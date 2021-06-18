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
