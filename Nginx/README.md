# 개발 환경에서 nginx 리버스 프록시 세팅

- localhost에서 HTTPS 서빙을 가능하게 해 OAuth 테스팅을 할 수 있다.

```sh
brew install mkcert
mkcert -key-file key.pem -cert-file cert.pem localhost 127.0.0.1 192.168.0.1 127.0.0.1.nip.io
mkcert -install
podman compose up nginx
```
