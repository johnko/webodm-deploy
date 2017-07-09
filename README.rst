terraform-deploy
================


Running Things
--------------

Run terraform::

    CHECKPOINT_DISABLE=1 \
    AWS_PROFILE=foo \
    terraform apply \
        -var 'key_name=terraform' \
        -var 'public_key_path=/home/bubba/terraform.pub'


First Time Setup
----------------

Set up your AWS config and credentials files::

    mkdir -p ~/.aws/ ; chmod 0700 ~/.aws/
    touch ~/.aws/config ; chmod 0644 ~/.aws/config
    touch ~/.aws/credentials ; chmod 0600 ~/.aws/credentials

Contents of ~/.aws/config::

    [default]
    region=ca-central-1
    output=json

    # [profile foo]
    # ...

Contents of ~/.aws/credentials::

    [default]
    aws_access_key_id=AKIAXXXXXXXXXXXXXXXX
    aws_secret_access_key=asdfasdfasdfasdfasdfasdfasdfasdfasdfasdf

    # [foo]
    # ...


Prepare Workstation
-------------------

Install Terraform::

    # Get core binary
    tf_version='0.9.11'
    wget https://releases.hashicorp.com/terraform/${tf_version}/terraform_${tf_version}_linux_amd64.zip
    wget https://releases.hashicorp.com/terraform/${tf_version}/terraform_${tf_version}_SHA256SUMS.sig
    wget https://releases.hashicorp.com/terraform/${tf_version}/terraform_${tf_version}_SHA256SUMS

    # Verify and extract stuff
    gpg --verify terraform_${tf_version}_SHA256SUMS.sig terraform_${tf_version}_SHA256SUMS
    sha256 -c <(grep terraform_${tf_version}_linux_amd64.zip terraform_${tf_version}_SHA256SUMS)
    unzip terraform_${tf_version}_linux_amd64.zip
    sudo cp terraform /usr/local/bin


    # Get AWS provider binary
    tf_aws_version='0.1.2'
    wget https://releases.hashicorp.com/terraform-provider-aws/${tf_aws_version}/terraform-provider-aws_${tf_aws_version}_linux_amd64.zip
    wget https://releases.hashicorp.com/terraform-provider-aws/${tf_aws_version}/terraform-provider-aws_${tf_aws_version}_SHA256SUMS.sig
    wget https://releases.hashicorp.com/terraform-provider-aws/${tf_aws_version}/terraform-provider-aws_${tf_aws_version}_SHA256SUMS

    # Verify and extract stuff
    gpg --verify terraform-provider-aws_${tf_aws_version}_SHA256SUMS.sig \
        terraform-provider-aws_${tf_aws_version}_SHA256SUMS
    sha256 -c <(grep terraform-provider-aws_${tf_aws_version}_linux_amd64.zip \
        terraform-provider-aws_${tf_aws_version}_SHA256SUMS)
    unzip terraform-provider-aws_${tf_aws_version}_linux_amd64.zip
    sudo cp terraform-provider-aws_v${tf_aws_version}_x4 /usr/local/bin

* https://terraform.io/
* https://releases.hashicorp.com/terraform/
* https://releases.hashicorp.com/terraform-provider-aws/


Getting IPv6 Working
--------------------

* http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/vpc-migrate-ipv6.html


AMIs
----

* http://ec2instances.info
* https://wiki.debian.org/Cloud/AmazonEC2Image
* https://noah.meyerhans.us/blog/2017/04/20/stretch-images-for-aws/
* http://cloud-images.ubuntu.com/locator/ec2/
