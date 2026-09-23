FROM alpine:latest@sha256:294b683cb724975bec92580e1e685676bd4b50bda910ddb8c51d4cabeaec77e6

RUN apk add --no-cache webhook git docker-cli docker-cli-compose bash gettext openssh-client

RUN mkdir -p /root/.ssh && ssh-keyscan github.com >> /root/.ssh/known_hosts

EXPOSE 9000

CMD envsubst < /etc/webhook/hooks.json.template > /tmp/hooks.json && webhook -hooks /tmp/hooks.json -verbose
