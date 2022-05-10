echo "# this file is located in 'src/github_command.sh'"
echo "# code for 'cli github' goes here"
echo "# you can edit it freely and regenerate (it will not be overwritten)"
inspect_args

echo "environment:"
echo "- GITOPS_REPO_NAME=${GITOPS_REPO_NAME:-}"
echo "- TEMPLATE_PATH=${TEMPLATE_PATH:-}"
echo "- GITOPS_REPO_OWNER=${GITOPS_REPO_OWNER:-}"
echo "- ENV_HELPER_SCRIPT=${ENV_HELPER_SCRIPT:-}"
echo "- GITOPS_REPO_BRANCH=${GITOPS_REPO_BRANCH:-}"


git clone -b ${GITOPS_REPO_BRANCH} https://github.com/${GITOPS_REPO_OWNER}/${GITOPS_REPO_NAME} /tmp/${GITOPS_REPO_NAME}
cd /tmp/${GITOPS_REPO_NAME}
if [ ! -f "${TEMPLATE_PATH}" ]; then
    echo "Template does not exist"
    rm -rf /tmp/${GITOPS_REPO_NAME}
    exit 1
fi

gomplate --file ${TEMPLATE_PATH} --out ${TEMPLATE_PATH}.tmp
mv ${TEMPLATE_PATH}.tmp ${TEMPLATE_PATH}

curl ${ENV_HELPER_SCRIPT} --output /tmp/env_helper.sh
bash /tmp/env_helper.sh
./tmp/env_helper.sh

echo env var in github command is $EKS_CLUSTER_ID
# git add ${TEMPLATE_PATH}
# git commit -m "Updating variables"
# git push

# rm -rf /tmp/${GITOPS_REPO_NAME}
