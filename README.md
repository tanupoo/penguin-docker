penguin-docker
==============

## installation

```
git clone https://github.com/tanupoo/penguin-docker
cd penguin-docker
cp -i docker-compose.yml.template docker-compose.yml
cp -i pendb/etc/pendb.conf.json.template pendb/etc/pendb.conf.json
cp -i penmm/etc/penmm.conf.json.template penmm/etc/penmm.conf.json
cp -i penfe/etc/penfe.conf.json.template penfe/etc/penfe.conf.json
cp -i penadm/etc/penadm.conf.json.template penadm/etc/penadm.conf.json
```

特に下記3つのファイルを環境に合わせて編集する。

```
docker-compose.yml
penen.conf.json
penmm.conf.json
penfe.conf.json
penadm.conf.json
```

## docker-compose.yml

```
    :
    : 省略
    :
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

例えば 443 で公開するならば

```
     - "443:8443"
```

証明書は penfe.conf.json で定義する。

## penmm.conf.json

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
    "mail_body_text_path": "/opt/penmm/etc/mm_body_template.txt",
    "mail_body_html_path": "/opt/penmm/etc/mm_body_template.html",
    "public_fe_url": "https://__PUBLIB_FE_NAME__",
    "server_cert": "",
    "server_address": "penmm",
    "server_port": 8083,
    "log_file": "/opt/penmm/log/penmm.log",
    "log_stdout": true,
    "enable_debug": true,
    "tz": "Asia/Tokyo"
}
```

- STARTTLSをサポートしているメールサーバにだけ対応している。
- gmail.com は検証済み。

下記、文字列を適切に置き換える。

```
__SMTP_WITH_TLS_SERVER__
__SMTP_USER_NAME__
__SMTP_USER_PASSWORD__
__MAIL_FROM__
__PUBLIB_SERVER_NAME__
```

__PUBLIB_SERVER_NAME__: 公開するサーバのホスト部
    全体では、https://www.example.com:8433 などどする。

必要であれば、下記を変更する。

```
mail_subject
mail_reference
```

GMAILの場合は、

__SMTP_WITH_TLS_SERVER__: smtp.gmail.com
__SMTP_USER_NAME__: gmailのアカウント名
__SMTP_USER_PASSWORD__: gmailのパスワード
__MAIL_FROM__: 通知メールのメールFromに入るメールアドレス

メールのテキストを変更したければ、下記のファイルを編集する。

```
penmm/etc/mm_body_template.txt
penmm/etc/mm_body_template.html
```

## penfe.conf.json

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
    "server_port": "__PUBLIC_PORT__",
    "server_cert": "__STRONGLY_RECOMMEND_TO_SET_YOUR_CERT__",
    "status_report_interval": 600,
    "google_apikey": "2e0390eb024a52963db7b95e84a9c2b12c00405"
}
```

証明書と秘密鍵をPEM形式で保存したファイルを penfe/etc/ にコピーする。
証明書ファイルを server.crt とすると、

```
cp server.crt penfe/etc/

vi penfe/etc/penfe.conf.json

    "server_cert": "/opt/penfe/etc/server.crt",
```

上記、/opt/penfe/etc は固定。ファイル名だけコピーしたファイル名に置き換える。

## penadm.conf.json

```
{
    "log_file": "/opt/penadm/log/penadm.log",
    "log_stdout": true,
    "enable_debug": true,
    "tz": "Asia/Tokyo",
    "db_api_url": "http://pendb:8082",
    "mm_api_url": "http://penmm:8083",
    "fe_api_url": "http://penfe:8084",
    "server_address": "",
    "server_port": "8444",
    "server_cert": "__STRONGLY_RECOMMEND_TO_SET_YOUR_CERT__",
    "allow_ip_addrs": [
        "__IP_ADDRESS_OF_HEALTH_CENTER__",
        "127.0.0.1",
        "::1"
            ],
    "lab_copy_interval": 86400
}
```

証明書と秘密鍵をPEM形式で保存したファイルを penadm/etc/ にコピーする。
証明書ファイルを server.crt とすると、

```
cp server.crt penadm/etc/

vi penadm/etc/penadm.conf.json

    "server_cert": "/opt/penadm/etc/server.crt",
```

上記、/opt/penadm/etc は固定。ファイル名だけコピーしたファイル名に置き換える。

allow_ip_addrsは、接続を許可するIPアドレスを列挙する。
空の場合は、チェックしない。

```
    "allow_ip_addrs": [ ],
```

ここを空にして、iptablesで絞ることを推奨する。

## 起動と終了

[docker-compose](https://docs.docker.jp/compose/reference/overview.html)で操作する。

起動する。

```
docker-compose up -d
```

終了する。

```
docker-compose down
```

ログを確認する。

```
docker-compose logs -f
```

## mongo-express

ssh -L 8091:127.0.0.1:8091 server

