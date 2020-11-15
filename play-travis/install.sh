#!/bin/bash

packer_ver=1.6.5
ansible_ver=2.9.15
terraform_ver=0.13.5
tflint_ver=0.20.3
ansible_lint_ver=4.2.0


# Install Packer
curl -O https://releases.hashicorp.com/packer/${packer_ver}/packer_${packer_ver}_linux_amd64.zip
unzip packer_${packer_ver}_linux_amd64.zip -d ~/bin
rm packer_${packer_ver}_linux_amd64.zip

# Install Ansible and Ansible lint
sudo pip install ansible==${ansible_ver}
sudo pip install ansible-lint==${ansible_lint_ver}

# Install Terraform and Terraform lint
curl -O https://releases.hashicorp.com/terraform/${terraform_ver}/terraform_${terraform_ver}_linux_amd64.zip
unzip terraform_${terraform_ver}_linux_amd64.zip -d ~/bin
rm terraform_${terraform_ver}_linux_amd64.zip
# chmod +x /usr/bin/terraform
curl -OL https://github.com/wata727/tflint/releases/download/v${tflint_ver}/tflint_linux_amd64.zip
unzip tflint_linux_amd64.zip -d ~/bin
rm tflint_linux_amd64.zip
# chmod +x /usr/bin/tflint
