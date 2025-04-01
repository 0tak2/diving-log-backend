# Notion-to-md

```sh
node -v # 설치 확인
npm install

cp .env.example .env
vim .env # 환경 변수 설정

node notion-to-md.js 추출할-페이지-ID
# 해당 페이지는 .env에 입력한 노션 통합 키에 연결되어 있어야 합니다
```
