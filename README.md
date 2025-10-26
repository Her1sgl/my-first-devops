# my-first-devops
в тестовом задание не был указан конкретный пример текста поэтому тут kappa

### Часть 1-2: Установка и настройка Git

Для установки git была использована команда sudo apt install git, чтобы установить его через стандартный пакетный 
менеджер дистрибутивов Ubuntu и Debian. Аккаунт на Github у меня уже был, после чего был создан репозиторий, а в нем 
по средствам web интерфейса создан файл Readme.md. 
Так как в тестовом задание не было примера как текст надо разместить в файле Readme.md, я на свое усмотрение решил написать вот это "в тестовом задание не был указан конкретный пример текста поэтому тут kappa". 
Для клонирования репозитория и комитов я указал свое имя и адресс почты через git config --global user.name и  git config --global user.email. После чего сгенерировал пару SSH ключей через ssh-keygen, публичный ключ добавил в настройки к своему аккаунта, а приватный в агент. После чего скопировал репозиторий через команду git clone git@github.com:Her1sgl/my-first-devops.git.

![Клонированный репозиторий](./screenshots/clone%20repository.png)

### Часть 3: Установка Docker

# Для установки Docker были сначало установлены ca-certificates curl и gnupg.

ca-certificates: Позволяет системе проверять сертификаты безопасности.

curl: Утилита для скачивания файлов по URL.

gnupg: Программа для работы с GPG-ключами шифрования.

# Потом был добавлен gpg ключ, для проверки пакетов. Через следующие команды:

sudo install -m 0755 -d /etc/apt/keyrings это создание директории под ключ

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg скачиваем ключ

sudo chmod a+r /etc/apt/keyrings/docker.gpg  добавляем право на чтение для всех пользователе 

# Добавляем репозиторий Docker в наш менеджер пакетов

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Устанавливаем движок cli и все остальные плагины 
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Проверка установки docker и git
![Установленный docker и git](./screenshots/Git%20and%20docker%20install.png)

# Запуск контейнера hello from docker
![Hello from docker](./screenshots/Hello%20from%20docekr.png)

### Часть 4  Расширение работы с Docker

# Написание Dockerfiel и скрипта  
В дириктории репозитория был создан Dockerfile 
FROM python:3.11-slim

WORKDIR /app

COPY script.py .

CMD ["python", "script.py"] 

И также был написан просто скрипт который выводит на экран Hello, DevOps World!

print("Hello, DevOps World!")

# Сборка образа и ошибки 

Для сборки образа была использованна команада docker build -t devops-hello .
Но во время скачивания образа python были вот такие ошибки 
 failed to solve: DeadlineExceeded: DeadlineExceeded: DeadlineExceeded: python:3.11-slim: failed to do request: Head "https://c.163.com/v2/library/python/manifests/3.15-slim?ns=docker.io": dial tcp 106.2.45.239:443: i/o timeout
Для их решение было принято добавить зеркала в /etc/docker/daemon.json с которых можно скачивать образы
вот финальный Json-файл
```json
{
  "insecure-registries": [
    "127.0.0.0/8"
  ],
  "registry-mirrors": [
    "https://docker.m.daocloud.io/",
    "https://docker.nju.edu.cn/",
    "https://dockerproxy.com/",
    "https://docker.mirrors.sjtug.sjtu.edu.cn/",
    "https://mirror.baidubce.com/"
  ]
}
```
После этих изменений образ собрался 

![Собранный образ](./screenshots/build%20my%20image.png)

Чтобы поднять контейнер была использована команда docker run devops-hello
#Контейнер DevOps World
![Поднятый контейнер](./screenshots/Hello%20from%20DevOps.png)
    
