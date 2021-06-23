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
    "echo \"DATABASE_URL=\" ${var.int_db_address} \"\" | sudo tee -a /etc/environment",
    "cat /etc/environment",
   ]
  }
```

Так как у меня образы ставятся уже с установленными приложениями. То я добавляю переменную
окружения модуля db. Тем самым указывая адрес БД.

## Lesson 10

После выполнения плейбука `ansible-playbook clone.yml` вывод:
```
PLAY RECAP *********************************************************************
178.154.252.59         : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
После выполнения команды `ansible app -m command -a 'rm -rf ~/reddit' && ansible-playbook clone.yml` вывод:
```
PLAY RECAP *********************************************************************
178.154.252.59         : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
Вывод: было выполненно изменение связаннное со скачиванием репозитория. Правда бывали и фейлы.

Использование в качестве инвентаря `inventory.json` с командой
`ansible -i inventory.json all -m ping` выводит положительный результат
```
178.154.252.59 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
178.154.200.19 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
```

Объяснение почему `inventory.json` должен выглядить именно так сказанно [тут](https://stackoverflow.com/questions/48680425/how-to-use-json-file-consisting-of-host-info-as-input-to-ansible-inventory).

> Those nulls are odd-looking but in the YAML example you'll see the trailing colon which does indeed mean each of those hosts are effectively dictionary/hash keys.

> Эти nulls выглядят странно, но в примере с YAML вы увидите конечное двоеточие, что действительно означает, что каждый из этих хостов фактически является dictionary/hash ключами.

Динамически получать инвентарь типа json не получается, но написал команду которая будет формировать файл `hosts`, в котором будут храниться имя и ip vm'ов, и уже из этого файла можно создавать инвентарь. Команда:
`yc compute instance list | awk '{print $4 "\t" $12}' | sed '/[0-9]/!d' | tee hosts`
