# bl33d_infra

TRYTRAVIS bl33d Infra repository
o


## ДЗ № 10

- Были добавлены плейбуки reddit_app_one_play.yml / reddit_app_multiple_plays.yml / site.yml (разный уровень декомпозиции) для разворачивания приложения Reddit
- Были добавлены плейбуки packer_db.yml и packer_app.yml, заменяющие собой ранее написанные bash скрипты
- Были пересобраны образы app и db

## ДЗ № 9

> Теперь выполните ansible app -m command -a 'rm -rf ~/reddit' и проверьте еще раз выполнение плейбука.
> Что изменилось и почему? Добавьте информацию в README.md

Когда мы запускали playbook clone.yml сразу после вызова модуля git, система уже находилась в заданном состоянии и ansible не произвел никаких изменений.
После удаления каталога ~/reddit ansible склонировал репозиторий и на выходе мы получили changed=1.

## ДЗ № 8

- Деплой Reddit вынесен в модуль app, а mongodb в модуль db
- Созданы два каталога: prod и stage
- Для prod окружения настроен S3 backend в бакете яндекса
- В модулях настроены провиженеры, которые донастраивают mongodb и reddit app

## ДЗ № 7

- Установлен Terraform
- Настроен провайдер Yandex.Cloud
- Описан ресурс Compute Instance, разворачивающий Reddit App
- Код параметризирован
- Внешний адрес вынесен в Outputs
- Описан load-balancer для одного инстанса
- Количество инстансов увеличено до двух, это сделано через мета-параментр count и динамический блок с использованием for_each

## ДЗ № 6

### Packer base

- Установлен пакер
- Создан сервисный аккаунт в YC
- Создан шаблон reddit-base образа
- Часть параметров шаблона параметризированы
- Создан шаблон для bake-образа reddit-full
- Написан скрипт запускающий создание ВМ с bake-образом

## ДЗ № 5

### Cloud Testapp

testapp_IP = 84.201.157.229
testapp_port = 9292

#### Вариант запуска с метаданными в формате User-Data Script

```bash
yc compute instance create \
--name reddit-app \
--hostname reddit-app \
--memory=4 \
--create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
--network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
--metadata serial-port-enable=1,ssh-keys="ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDmY1Y+TWSK5hjzZpda8w34c0CXPUYK7QPSpYavE0G02YGNp8XOx9/yWaCwcpTPYhDtoyvB1St4ANd+u3Dl7vaTaItMJb0KCIv5WC3qB0Av0tC7Ejv3eEJtKh29dWTwtwH/l5dHR0Lar8hU21vX4WUF6lnSMg6YKAiq4YZXHz4+EhcG+duY+UIYRuC/6x8bI6sD18A6zwNPGkm0mK2gY6wBzqGXN+qEyOt+tFlDzld4p2QYW28vhTEdDqeo/pSBBku83Ag2+sUiyNjJ2zVccX4g/p1hzw+/dgYuNVttDqTF/BrzFxpcd9+BmZaWUHP4ccHIl5EQzbINQbmQuFlSLga9 appuser" \
--metadata-from-file user-data=install_reddit_app.sh
```

#### Вариант запуска с метаданными в формате Cloud Config Data

```bash
yc compute instance create \
--name reddit-app \
--hostname reddit-app \
--memory=4 \
--create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
--network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
--metadata serial-port-enable=1 \
--metadata-from-file user-data=install_reddit_app.yaml
```

## ДЗ № 4

### Multi-hop ssh connection

bastion_IP = 84.201.133.173
someinternalhost_IP = 10.130.0.4

**localworksation** -> **bastion** -> **someinternalhost**

Несколько различных вариантов подключения по ssh с **localwokrstation** на **someinternalhost** в одну команду:

#### I. Использовать ключ -t

```bash
ssh -i ~/.ssh/appuser -At appuser@84.201.133.173 ssh appuser@10.130.0.4
```

> -t  Force pseudo-terminal allocation.

#### II. Использовать ключ -J

```bash
ssh -i ~/.ssh/appuser -J appuser@84.201.133.173 appuser@10.130.0.4
```

> -J Connect to the target host by first making a ssh connection to the jump host described by destination and then establishing a TCP forwarding to the ultimate destination from there.
Multiple jump hops may be specified separated by comma characters.
This is a shortcut to specify a ProxyJump configuration directive.

#### III. Включить настройки для конкретного хоста в ~/.ssh/config

```bash
Host bastion
    HostName 84.201.133.173
    User appuser
    IdentityFile ~/.ssh/appuser

Host someinternalhost
    HostName 10.130.0.4
    User appuser
    IdentityFile ~/.ssh/appuser
    ForwardAgent yes
    ProxyJump bastion
```

```bash
ssh someinternalhost
```
