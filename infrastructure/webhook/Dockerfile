FROM alpine:latest@sha256:3f4d6b32e26703c6082839234f43769d5046b3ac7c910033911d1e71d8cd630a

RUN apk add --no-cache webhook git docker-cli docker-cli-compose bash gettext openssh-client

RUN mkdir -p /root/.ssh && ssh-keyscan github.com >> /root/.ssh/known_hosts

EXPOSE 9000

CMD envsubst < /etc/webhook/hooks.json.template > /tmp/hooks.json && webhook -hooks /tmp/hooks.json -verbose
