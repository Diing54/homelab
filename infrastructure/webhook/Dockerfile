FROM alpine:latest

RUN apk add --no-cache webhook git docker-cli docker-cli-compose bash gettext openssh-client

RUN mkdir -p /root/.ssh && ssh-keyscan github.com >> /root/.ssh/known_hosts

EXPOSE 9000

CMD envsubst < /etc/webhook/hooks.json.template > /tmp/hooks.json && webhook -hooks /tmp/hooks.json -verbose
