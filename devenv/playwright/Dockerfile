# system spec 用のブラウザサーバー
# web イメージ（Alpine）では Playwright のブラウザが動かないため、別コンテナで起動して接続する
# playwright-ruby-client の COMPATIBLE_PLAYWRIGHT_VERSION と揃えること
ARG PLAYWRIGHT_VERSION=1.63.0
FROM mcr.microsoft.com/playwright:v${PLAYWRIGHT_VERSION}-noble
ARG PLAYWRIGHT_VERSION
RUN npm install -g playwright@${PLAYWRIGHT_VERSION}
COPY devenv/playwright/launch-server.json /etc/playwright/launch-server.json
EXPOSE 3333
CMD ["playwright", "launch-server", "--browser", "chromium", "--config", "/etc/playwright/launch-server.json"]
