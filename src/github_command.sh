inspect_args
set -a

git clone -b ${GITOPS_REPO_BRANCH} https://${GITHUB_TOKEN}@github.com/${GITOPS_REPO_OWNER}/${GITOPS_REPO_NAME} /tmp/${GITOPS_REPO_NAME}
git config --global user.email ${GIT_BOT_EMAIL}                                                                  │
git config --global user.name ${GIT_BOT_NAME}

cd /tmp/${GITOPS_REPO_NAME}
if [ ! -f "${TEMPLATE_PATH}" ]; then
    echo "Template does not exist"
    rm -rf /tmp/${GITOPS_REPO_NAME}
    exit 1
fi

if [[ ! -z "${ENV_HELPER_SCRIPT}" ]]; then
    # extract the protocol
    proto="$(echo $ENV_HELPER_SCRIPT | grep :// | sed -e's,^\(.*://\).*,\1,g')"
    # remove the protocol
    url="$(echo ${ENV_HELPER_SCRIPT/$proto/})"
    # extract the host and port
    hostport="$(echo ${url/$user@/} | cut -d/ -f1)"
    # by request host without port    
    host="$(echo $hostport | sed -e 's,:.*,,g')"
    # extract the path (if any)
    path="$(echo $url | grep / | cut -d/ -f2-)"
    curl $proto${GITHUB_TOKEN}@$host/$path --output /tmp/env_helper.sh
    chmod +x /tmp/env_helper.sh
    sh /tmp/env_helper.sh
fi
if [[ ! -z "${ENV_CONFIG_FILE_PATH}" ]]; then
    source $ENV_CONFIG_FILE_PATH
fi

gomplate --file ${TEMPLATE_PATH} --out ${TEMPLATE_PATH}.tmp
mv ${TEMPLATE_PATH}.tmp ${TEMPLATE_PATH}

git add ${TEMPLATE_PATH}
git commit -m "Updating variables"
git push

rm -rf /tmp/${GITOPS_REPO_NAME}