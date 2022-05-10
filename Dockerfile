FROM dannyben/bashly
WORKDIR /home/
ADD . /home/
RUN bashly generate

FROM hairyhenderson/gomplate:v3.10.0-alpine
WORKDIR /root/
RUN apk update && apk upgrade && apk add git
RUN apk update && apk upgrade && apk add curl
RUN apk update && apk upgrade && apk add bash
COPY --from=0 /home/cli ./
ENTRYPOINT ["./cli", "template"]  