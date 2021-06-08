proto-pen-docker
================

## installation

git clone https://github.com/tanupoo/proto-pen-docker
cd proto-pen-docker

## penfe

```
{
    "origins": [ ],
    "log_file": "/opt/penfe/log/penfe.log",
    "log_stdout": true,
    "enable_debug": true,
    "tz": "Asia/Tokyo",
    "db_api_url": "http://pendb:8082",
    "mm_api_url": "http://penmm:8083",
    "server_address": "",
    "server_port": __PUBLIC_PORT__,
    "server_cert": "__STRONGLY_RECOMMEND_TO_SET_YOUR_CERT__",
    "status_report_interval": 600
}
```

証明書と秘密鍵をPEM形式で保存したファイルを penfe/etc/ にコピーする。
証明書ファイルを server.crt とすると、

cp server.crt penfe/etc/

vi penfe/etc/penfe.conf.json

    "server_cert": "/opt/penfe/etc/server.crt",

## penmm

vi penmm/etc/penmm.conf.json

```
{
    "smtp_server": "__SMTP_WITH_TLS_SERVER__",
    "smtp_port": 587,
    "mail_username": "__SMTP_USER_NAME__",
    "mail_password": "__SMTP_USER_PASSWORD__",
    "mail_from": "__MAIL_FROM__",
    "mail_bcc": "",
    "mail_subject": "新型コロナの調査について",
    "mail_reference": "連絡先: ○△□",
    "public_api_url": "https://__PUBLIB_SERVER_NAME__",
    "server_cert": "",
    "server_address": "penmm",
    "server_port": 8083,
    "log_file": "/opt/penmm/log/penmm.log",
    "log_stdout": true,
    "enable_debug": true,
    "tz": "Asia/Tokyo"
}
```

## server configuration

vi penmm/etc/penmm.conf.json
vi penfe/etc/penfe.conf.json

## docker configuration

cat docker-compose.yml

```
  penfe:
    image: tanupoo/penfe:a1
    hostname: penfe
    restart: always
    networks:
      - pen-local
    ports:
      - "__PUBLIC_PORT__:8443"
    volumes:
      - ./penfe/log:/opt/penfe/log
      - ./penfe/etc:/opt/penfe/etc
    command: /opt/penfe/etc/penfe.sh
```

__PUBLIC_PORT__ を公開するサーバのポートに変更する。

例えば

```
     - "443:8443"
```

