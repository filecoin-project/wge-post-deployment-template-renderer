FROM dannyben/bashly
WORKDIR /home/
ADD . /home/
RUN bashly generate

FROM hairyhenderson/gomplate:v3.10.0-alpine
WORKDIR /root/
RUN apk update && apk upgrade && apk add git
RUN apk update && apk upgrade && apk add curl
RUN apk update && apk upgrade && apk add bash
RUN apk update && apk upgrade && apk add github-cli
RUN apk update && apk upgrade && apk add github-cli
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/kubectl

COPY --from=0 /home/cli ./
ENTRYPOINT ["./cli", "github"]  