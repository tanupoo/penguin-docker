penguin-docker
==============

症例候補の初期入力支援システムの[バックエンド](https://github.com/tanupoo/penguin)と[フロントエンド](https://github.com/tanupoo/penguin-ui)のDockerたち。

## 動作の流れ

- 患者にエントリサーバ*penen*のURLをQRやメールなどで知らせる。
    + 患者が最初に1回だけアクセスする。
        * 例. *https://penguin.m-crisis.wide.ad.jp:8442*
    + 患者のメールアドレスを入力してもらう。
    + *penmm*からメールが送られる。
- メールに含まれる情報。
    + 患者の情報を入力するためのエンドポイント(*URL-B*)。
    + 3つの数字
    + 3つの単語
    + *URL-B*のQRコード
- 以降、患者はURL-Bにアクセスして情報を入力する。
    + *URL-B*は*penfe*で処理される。
- *penadm*からデータをダウンロードすると*URL-B*が無効になる。
        * 例. https://penguin.m-crisis.wide.ad.jp:8444/dl/%E3%81%82%E3%81%8B-%E3%81%8D%E3%81%84%E3%82%8D-%E3%81%82%E3%81%8A%0A
- 詳細は、https://github.com/tanupoo/penguin/blob/main/IMPLEMENTATION.md を参照のこと。

## 準備

- docker-composeが必要になる。
- Debian系であれば`apt install docker-compose`などでインストールする。

## インストール

```
git clone https://github.com/tanupoo/penguin-docker
cd penguin-docker
cp -i docker-compose.yml.template docker-compose.yml
cp -i pendb/etc/pendb.conf.json.template pendb/etc/pendb.conf.json
cp -i penen/etc/penen.conf.json.template penen/etc/penen.conf.json
cp -i penmm/etc/penmm.conf.json.template penmm/etc/penmm.conf.json
cp -i penfe/etc/penfe.conf.json.template penfe/etc/penfe.conf.json
cp -i penadm/etc/penadm.conf.json.template penadm/etc/penadm.conf.json
```

最初に必要なファイルを作るスクリプトを実行する。

```
sh init.sh
```

スクリプトは難しいことはやっていない。
単に、penguinのcloneと、uiへのシンボリックリンクを作る。

次に、特に下記6つのファイルを環境に合わせて編集する。

```
docker-compose.yml
pendb.conf.json
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

penen,penfe,penadmの__PUBLIC_PORT__を、それぞれ異なるポートに変更する。
これはそれぞれのサーバを外部に公開するポートになる。

例えば 443 で公開するならば

```
     - "443:8443"
```

## penen.conf.json

- 患者UIサーバへ誘導するためのエントリサーバの設定。

```
{
    "origins": [
            ],
    "log_file": "/opt/penen/log/penen.log",
    "log_stdout": true,
    "enable_debug": true,
    "tz": "Asia/Tokyo",
    "db_api_url": "http://pendb:8082",
    "mm_api_url": "http://penmm:8083",
    "public_fe_url": "__PUBLIB_FE_URL__",
    "server_address": "",
    "server_port": 8442,
    "server_cert": "__STRONGLY_RECOMMEND_TO_SET_YOUR_CERT__",
    "status_report_interval": 600,
    "ui_step1_path": "/opt/penen/ui"
}
```

デバッグなどの目的で証明書を使わない場合は*server_cert*を空文字にする。

証明書と秘密鍵をPEM形式で保存したファイルを penen/etc/ にコピーする。
ファイルへのパスを*server_cert*にセットする。
証明書ファイルを server.crt とすると、

```
cp server.crt penen/etc/

vi penen/etc/penen.conf.json

    "server_cert": "/opt/penen/etc/server.crt",
```

上記、/opt/penen/etc は固定。ファイル名だけコピーしたファイル名に置き換える。

## penmm.conf.json

患者UIへのアクセスの案内メールを送信するサーバの設定。

```
{
    "smtp_server": "__SMTP_WITH_TLS_SERVER__",
    "smtp_port": 587,
    "mail_username": "__SMTP_USER_NAME__",
    "mail_password": "__SMTP_USER_PASSWORD__",
    "mail_from": "__MAIL_FROM__",
    "mail_bcc": "",
    "mail_subject": "新型コロナの調査について",
    "mail_reference": "__CALL_ADDR__",
    "mail_body_text_path": "/opt/penmm/etc/mm_body_template.txt",
    "mail_body_html_path": "/opt/penmm/etc/mm_body_template.html",
    "public_fe_url": "__PUBLIC_FE_URL__",
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
__CALL_ADDR__
__PUBLIC_FE_URL__
```

*public_fe_url*: 公開するサーバのURLを*__PUBLIC_FE_URL__*にセットする。
例えば、*https://www.example.com:8433*などどする。

必要であれば、*mail_subject*, *mail_reference*を変更する。

GMAILの場合は、

```
__SMTP_WITH_TLS_SERVER__: smtp.gmail.com
__SMTP_USER_NAME__: gmailのアカウント名
__SMTP_USER_PASSWORD__: gmailのパスワード
__MAIL_FROM__: 通知メールのメールFromに入るメールアドレス
```

メールのテキストを変更したければ、下記のファイルを編集する。

```
penmm/etc/mm_body_template.txt
penmm/etc/mm_body_template.html
```

## penfe.conf.json

患者UIサーバの設定。

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
    "google_apikey": "__SET_YOUR_GOOGLE_MAPS_APIKEY__"
}
```

デバッグなどの目的で証明書を使わない場合は*server_cert*を空文字にする。

証明書と秘密鍵をPEM形式で保存したファイルを penfe/etc/ にコピーする。
ファイルへのパスを*server_cert*にセットする。
証明書ファイルを server.crt とすると、

```
cp server.crt penfe/etc/

vi penfe/etc/penfe.conf.json

    "server_cert": "/opt/penfe/etc/server.crt",
```

上記、/opt/penfe/etc は固定。ファイル名だけコピーしたファイル名に置き換える。

## penadm.conf.json

管理I/Fの設定。

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

デバッグなどの目的で証明書を使わない場合は*server_cert*を空文字にする。

証明書と秘密鍵をPEM形式で保存したファイルを penadm/etc/ にコピーする。
ファイルへのパスを*server_cert*にセットする。
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

個別にログを見る。

例: penmmのログを見る。

```
docker-compose logs -f penmm
```

## 個別に再起動する。

例: penmmを再起動する。

```
docker-compose restart penmm
```


## mongo-express

ssh -L 8091:127.0.0.1:8091 server

