#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo "=================== Starting packer tests ==================="

for packer_template in app db immutable ubuntu16
do
    if packer validate -var-file=packer/variables.json.example packer/$packer_template.json ; then
    echo -e "${GREEN}packer/$packer_template.json validate succeeded${NC}"
else
    echo -e "${RED}packer/$packer_template.json validate failed"
    exit 1
fi
done

echo "=================== Starting terraform tests ==================="

for terraform_environment in stage prod
do
    pushd terraform/$terraform_environment &>/dev/null
    echo "$terraform_environment environment validation"
    terraform 0.13upgrade -yes . &>/dev/null
    terraform 0.13upgrade -yes ../modules/app &>/dev/null
    terraform 0.13upgrade -yes ../modules/db &>/dev/null
    terraform init &>/dev/null
    mv terraform-bot-key.json.example terraform-bot-key.json
    if terraform validate && tflint ; then
    echo -e "${GREEN}$terraform_environment validate succeeded${NC}"
else
    echo -e "${RED}terraform $terraform_environment environment validate failed${NC}"
    exit 1
fi
popd &>/dev/null
done

echo "=================== Starting ansible tests ==================="
if ansible-lint -v ansible/playbooks/*.yml ; then
    echo -e "${GREEN}ansible validate succeeded${NC}"
else
    echo -e "${RED}ansible validate failed"
    exit 1
fi
