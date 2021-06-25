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

---

## Lesson 8

Выполненны все задания.
Добавлен балансировщик и используется `count` для создания нескольких инстансов VM.
Балансировщик работал при отключение одной из машин.

---
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

---

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

---

## Lesson 12

Сделано:
 + Плейбуки разбиты по ролям c помощью `Ansible Galaxy`;
 + Созданы окружения `prod` и `stage`;
 + Использована роль Nginx для обратного проксирования;
 + Использовали `Ansible Vault` для шифрования переменных в `ansible/environments/stagecredentials.yml`

<details open>
<summary>Структура каталога "./ansible"</summary>
<br>

```
 ansible/
├── ansible.cfg
├── environments
│   ├── prod
│   │   ├── credentials.yml
│   │   ├── group_vars
│   │   │   ├── all
│   │   │   ├── app
│   │   │   └── db
│   │   └── requirements.yml
│   └── stage
│       ├── credentials.yml
│       ├── group_vars
│       │   ├── all
│       │   ├── app
│       │   └── db
│       ├── inventory
│       └── requirements.yml
├── old
│   ├── files
│   │   └── puma.service
│   ├── inventory.json
│   ├── inventory.yml
│   └── templates
│       ├── db_config.j2
│       └── mongod.conf.j2
├── playbooks
│   ├── app.yml
│   ├── clone.yml
│   ├── db.yml
│   ├── deploy.yml
│   ├── packer_app.yml
│   ├── packer_db.yml
│   ├── reddit_app_multiple_plays.yml
│   ├── reddit_app_one_play.yml
│   ├── site.yml
│   └── users.yml
├── requirements.txt
├── roles
│   ├── app
│   │   ├── defaults
│   │   │   └── main.yml
│   │   ├── files
│   │   │   └── puma.service
│   │   ├── handlers
│   │   │   └── main.yml
│   │   ├── meta
│   │   │   └── main.yml
│   │   ├── README.md
│   │   ├── tasks
│   │   │   └── main.yml
│   │   ├── templates
│   │   │   └── db_config.j2
│   │   ├── tests
│   │   │   ├── inventory
│   │   │   └── test.yml
│   │   └── vars
│   │       └── main.yml
│   ├── db
│   │   ├── defaults
│   │   │   └── main.yml
│   │   ├── files
│   │   ├── handlers
│   │   │   └── main.yml
│   │   ├── meta
│   │   │   └── main.yml
│   │   ├── README.md
│   │   ├── tasks
│   │   │   └── main.yml
│   │   ├── templates
│   │   │   └── mongod.conf.j2
│   │   ├── tests
│   │   │   ├── inventory
│   │   │   └── test.yml
│   │   └── vars
│   │       └── main.yml
│   └── jdauphant.nginx
│       ├── ansible.cfg
│       ├── defaults
│       │   └── main.yml
│       ├── handlers
│       │   └── main.yml
│       ├── meta
│       │   └── main.yml
│       ├── README.md
│       ├── tasks
│       │   ├── amplify.yml
│       │   ├── cloudflare_configuration.yml
│       │   ├── configuration.yml
│       │   ├── ensure-dirs.yml
│       │   ├── installation.packages.yml
│       │   ├── main.yml
│       │   ├── nginx-official-repo.yml
│       │   ├── remove-defaults.yml
│       │   ├── remove-extras.yml
│       │   ├── remove-unwanted.yml
│       │   └── selinux.yml
│       ├── templates
│       │   ├── auth_basic.j2
│       │   ├── config_cloudflare.conf.j2
│       │   ├── config.conf.j2
│       │   ├── config_stream.conf.j2
│       │   ├── module.conf.j2
│       │   ├── nginx.conf.j2
│       │   ├── nginx.repo.j2
│       │   └── site.conf.j2
│       ├── test
│       │   ├── custom_bar.conf.j2
│       │   ├── example-vars.yml
│       │   └── test.yml
│       ├── Vagrantfile
│       └── vars
│           ├── Debian.yml
│           ├── empty.yml
│           ├── FreeBSD.yml
│           ├── main.yml
│           ├── RedHat.yml
│           └── Solaris.yml
└── vault.key

36 directories, 82 files
 ```
</details>

---

## Lesson 13

Сделано:
 + Настроен `Vagrant`
 + Проверка `Vagrant`


Проверям статус машин с помощью команды `vagrant status`

```
Current machine states:

dbserver                  running (virtualbox)
appserver                 running (virtualbox)
```
Проверям статус рабочих машин с помощью команды `VBoxManage list runningvms`

```
"ansible_dbserver_1624561417103_68155" {2a1c4cb2-9d1b-4ed7-9f82-8c40ea9c51c9}
"ansible_appserver_1624561544168_4424" {7aa689b0-d4b2-46fd-ab7b-edae499d71cc}
```

---
## Lesson 14

Сделанно:
 + Доработка ролей для провижининга в Vagrant
 + Тестирование ролей при помощи Molecule и Testinfra
 + Переключение сбора образов пакером на использование ролей

Для корректной работы molecule понадобится пакет `molecule-vagrant`, установим:
`pip install molecule-vagrant`

Вместо команды:
` molecule init scenario --scenario-name default -r db -d vagrant`

используем команду:
`molecule init scenario -r db -d vagrant --verifier-name testinfra`

В tesk'ax роли "db" нужно все команды исполнять от рута `become: true`, иначе команда `molecule converge` не исполнит плейбуки. Результат успешного выполнения `molecule converge`:

<details open>
<summary>Результат команды `molecule converge` </summary>
<br>

```
INFO     default scenario test matrix: dependency, create, prepare, converge
INFO     Performing prerun...
WARNING  Computed fully qualified role name of db does not follow current galaxy requirements.
Please edit meta/main.yml and assure we can correctly determine full role name:

galaxy_info:
role_name: my_name  # if absent directory name hosting role is used instead
namespace: my_galaxy_namespace  # if absent, author is used instead

Namespace: https://galaxy.ansible.com/docs/contributing/namespaces.html#galaxy-namespace-limitations
Role: https://galaxy.ansible.com/docs/contributing/creating_role.html#role-names

As an alternative, you can add 'role-name' to either skip_list or warn_list.

INFO     Using /home/ansible-main/.cache/ansible-lint/a258fd/roles/db symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Added ANSIBLE_ROLES_PATH=~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/home/ansible-main/.cache/ansible-lint/a258fd/roles
INFO     Running default > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running default > create
WARNING  Skipping, instances already created.
INFO     Running default > prepare
WARNING  Skipping, instances already prepared.
INFO     Running default > converge
[DEPRECATION WARNING]: Ansible will require Python 3.8 or newer on the
controller starting with Ansible 2.12. Current version: 3.6.9 (default, Jan 26
2021, 15:33:00) [GCC 8.4.0]. This feature will be removed from ansible-core in
version 2.12. Deprecation warnings can be disabled by setting
deprecation_warnings=False in ansible.cfg.

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [instance]

TASK [Include db] **************************************************************

TASK [db : Show info about the env this host belongs to] ***********************
ok: [instance] => {
    "msg": "This host is in local environment!!!"
}

TASK [db : Add an apt signing key for MongoDB] *********************************
ok: [instance]

TASK [db : Add MongoDB repositry] **********************************************
ok: [instance]

TASK [db : Install required packages] ******************************************
ok: [instance] => (item=apt-transport-https)
ok: [instance] => (item=mongodb-org)

TASK [db : Start and enable MongoDB service] ***********************************
ok: [instance]

TASK [db : Change mongo config file] *******************************************
ok: [instance]

PLAY RECAP *********************************************************************
instance                   : ok=7    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
</details>


Выполнение теста:
```
============================= test session starts ==============================
platform linux -- Python 3.6.9, pytest-6.2.4, py-1.10.0, pluggy-0.13.1
rootdir: /home/ansible-main
plugins: testinfra-6.0.0, testinfra-6.4.0
collected 3 items

molecule/default/tests/test_default.py ...                               [100%]

============================== 3 passed in 7.89s ===============================
/home/ansible-main/.local/lib/python3.6/site-packages/_testinfra_renamed.py:10: DeprecationWarning: testinfra package has been renamed to pytest-testinfra. Please `pip install pytest-testinfra` and `pip uninstall testinfra` and update your package requirements to avoid this message
  ), DeprecationWarning)
INFO     Verifier completed successfully.
```

Фрагмент кода тестирование порта:
```
def test_http(host):
    mongod = host.addr("0.0.0.0")
    assert mongod.port(27017).is_reachable
```
