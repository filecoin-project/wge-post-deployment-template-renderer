echo "# this file is located in 'src/template_command.sh'"
echo "# code for 'cli template' goes here"
echo "# you can edit it freely and regenerate (it will not be overwritten)"
inspect_args
set -a

git clone -b ${GITOPS_REPO_BRANCH} https://${GIT_USERNAME}:${GITHUB_TOKEN}@github.com/${GITOPS_REPO_OWNER}/${GITOPS_REPO_NAME} /tmp/${GITOPS_REPO_NAME}
cd /tmp/${GITOPS_REPO_NAME}
if [ ! -f "${TEMPLATE_PATH}" ]; then
    echo "Template does not exist"
    rm -rf /tmp/${GITOPS_REPO_NAME}
    exit 1
fi

if [[ ! -z "${ENV_HELPER_SCRIPT}" ]]; then
    curl ${ENV_HELPER_SCRIPT} --output /tmp/env_helper.sh
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
