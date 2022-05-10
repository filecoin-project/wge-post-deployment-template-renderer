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
# ENTRYPOINT ["tail", "-f","/dev/null"]  


docker run \
    --env GITOPS_REPO_BRANCH="nonprod" \
    --env TEMPLATE_PATH="clusters/wge-nonprod-capi-configs/test-01.yaml" \
    --env GITOPS_REPO_OWNER="filecoin-project" \
    --env GITOPS_REPO_NAME="gitops-root" \
    --env CLUSTER_NAME="test-01" \
    --env ENV_CONFIG_FILE_PATH="/tmp/env_config" \
    --env GITHUB_TOKEN="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" \
    --env ENV_HELPER_SCRIPT="https://${GITHUB_TOKEN}@raw.githubusercontent.com/steve-fraser/wge-post-deployment-template-renderer/main/aws/get-cluster-id.sh" \
    wge-render:latest
