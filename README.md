# cloud9-ec2dockercontainer-ubuntu18
Docker sample(ubuntu18) for AWS Cloud9

# 概要

下記ドキュメントのubuntu、puthon版

https://docs.aws.amazon.com/ja_jp/cloud9/latest/user-guide/sample-docker.html

# 前提

・EC2作成済みであること。

・EC2のSGインバウントについてポート8080,9090,22、アドレス帯13.250.186.160/27,13.250.186.128/27で開放していること。

※Cloud9はap-southeast-1(シンガポール)で作る必要がありEC2に接続を許可する必要がある。

# 簡易手順

## 1 AWS Cloud9のSSHパブリックキー設定

Dockerfileと同じ階層にをauthorized_keysファイルを作成し。

こちらに、Cloud9のCopy key to clipboard (キーをクリップボードにコピー)

でコピーされた文字列を貼り付ける。

## 2 Dockerfileビルド

Dockerfileディレクトリに移動し以下実行

```shell
docker build -t cloud9python:latest .
```

## 3 コンテナ起動

※8080はサンプルアプリ公開用

```shell
docker run -d -it --expose=9090 --expose=8080 -p 0.0.0.0:9090:22 -p 0.0.0.0:8080:8080 --name cloud9python cloud9python:latest
```

## 4　Cloud9での接続設定

・Environment type：Create and run in remote server (SSH connection)

・SSH Server connection - User：ubuntu

・SSH Server connection - Host：EC2のホスト(IP)

・SSH Server connection - Port：9090

・Advanced settings - Environment path：/home/ubuntu

・Advanced settings - Node.js binary path：/usr/bin/node

