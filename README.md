## Lesson 20
В этом репозитории будет выполняться задание по GitLab CI.  

Cделанно:
 + Подготовленно инсталляция Gitlab CI
 + Развернута новая VM на YC
 + Определенны окружения и созданы пайплайны.


После создания инстанса в `YC`, поднимаем `Docker` с помощью `docker-machine`.  

```
docker-machine create  --driver generic \ 
    --generic-ip-address=178.154.252.33 \ 
    --generic-ssh-user foxy \ 
    --generic-ssh-key ~/.ssh/yandex-cloud docker-host-ci
```
 
Поднимаем докер. Создаем директории и файл `docker-compose.yml` где прописываем:  

```
web:
  image: 'gitlab/gitlab-ce:latest'
  restart: always
  hostname: 'gitlab.example.com'
  environment:
    GITLAB_OMNIBUS_CONFIG: |
      external_url 'http://178.154.252.33'
  ports:
    - '80:80'
    - '443:443'
    - '2222:22'
  volumes:
    - '/srv/gitlab/config:/etc/gitlab'
    - '/srv/gitlab/logs:/var/log/gitlab'
    - '/srv/gitlab/data:/var/opt/gitlab'
```

Выполнение сборки:  

```
Pulling web (gitlab/gitlab-ce:latest)...
latest: Pulling from gitlab/gitlab-ce
c549ccf8d472: Pull complete
41ae71c8423a: Pull complete
c5d53ba99c3d: Pull complete
069a53bf4f3e: Pull complete
025b4ff80869: Pull complete
ea5ed1ec865a: Pull complete
259bd22bd080: Pull complete
0e9c412940b1: Pull complete
Digest: sha256:3689c780a6a621298911992a5a475a35e44ea2215cc5b4498272cab9e5c206b2
Status: Downloaded newer image for gitlab/gitlab-ce:latest
Creating gitlab_web_1 ... done
```

- Работа с GitLab
- Expose Раннера
- Поднятие контейнера для тестов.
- Прогон тестов.
