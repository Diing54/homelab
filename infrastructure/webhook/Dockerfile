FROM alpine:latest@sha256:be2656061b536c1883c4034790e21d0a09c5aaaf51968b89368a3c0371ea2c9a

RUN apk add --no-cache webhook git docker-cli docker-cli-compose bash gettext openssh-client

RUN mkdir -p /root/.ssh && ssh-keyscan github.com >> /root/.ssh/known_hosts

EXPOSE 9000

CMD envsubst < /etc/webhook/hooks.json.template > /tmp/hooks.json && webhook -hooks /tmp/hooks.json -verbose
