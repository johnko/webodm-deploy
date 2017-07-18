WebODM / OpenDroneMap
=====================


Set up AWS Config/Credentials
-----------------------------

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


Install Local Build Tools
-------------------------

You will need the following build tools installed on your local workstation in
order to do everything from scratch:

* terraform
* packer (TBD;  for building AMIs from scratch;  amazon-import post-processor)
* (OPTIONAL) aws-cli

Install Terraform::

    # Get core binary
    tf_version='0.9.11'
    wget https://releases.hashicorp.com/terraform/${tf_version}/terraform_${tf_version}_linux_amd64.zip
    wget https://releases.hashicorp.com/terraform/${tf_version}/terraform_${tf_version}_SHA256SUMS.sig
    wget https://releases.hashicorp.com/terraform/${tf_version}/terraform_${tf_version}_SHA256SUMS

    # Verify and extract stuff
    gpg --verify terraform_${tf_version}_SHA256SUMS.sig \
        terraform_${tf_version}_SHA256SUMS
    sha256sum -c <(grep terraform_${tf_version}_linux_amd64.zip \
        terraform_${tf_version}_SHA256SUMS)
    unzip terraform_${tf_version}_linux_amd64.zip
    sudo cp terraform /usr/local/bin


    # Get provider binary
    tf_provider='terraform-provider-aws'
    tf_provider_version='0.1.2'
    wget https://releases.hashicorp.com/${tf_provider}/${tf_provider_version}/${tf_provider}_${tf_provider_version}_linux_amd64.zip
    wget https://releases.hashicorp.com/${tf_provider}/${tf_provider_version}/${tf_provider}_${tf_provider_version}_SHA256SUMS.sig
    wget https://releases.hashicorp.com/${tf_provider}/${tf_provider_version}/${tf_provider}_${tf_provider_version}_SHA256SUMS

    # Verify and extract stuff
    gpg --verify ${tf_provider}_${tf_provider_version}_SHA256SUMS.sig \
        ${tf_provider}_${tf_provider_version}_SHA256SUMS
    sha256sum -c <(grep ${tf_provider}_${tf_provider_version}_linux_amd64.zip \
        ${tf_provider}_${tf_provider_version}_SHA256SUMS)
    unzip ${tf_provider}_${tf_provider_version}_linux_amd64.zip
    sudo cp ${tf_provider}_v${tf_provider_version}_x4 /usr/local/bin


    # Get provider binary
    tf_provider='terraform-provider-terraform'
    tf_provider_version='0.1.0'
    wget https://releases.hashicorp.com/${tf_provider}/${tf_provider_version}/${tf_provider}_${tf_provider_version}_linux_amd64.zip
    wget https://releases.hashicorp.com/${tf_provider}/${tf_provider_version}/${tf_provider}_${tf_provider_version}_SHA256SUMS.sig
    wget https://releases.hashicorp.com/${tf_provider}/${tf_provider_version}/${tf_provider}_${tf_provider_version}_SHA256SUMS

    # Verify and extract stuff
    gpg --verify ${tf_provider}_${tf_provider_version}_SHA256SUMS.sig \
        ${tf_provider}_${tf_provider_version}_SHA256SUMS
    sha256sum -c <(grep ${tf_provider}_${tf_provider_version}_linux_amd64.zip \
        ${tf_provider}_${tf_provider_version}_SHA256SUMS)
    unzip ${tf_provider}_${tf_provider_version}_linux_amd64.zip
    sudo cp ${tf_provider}_v${tf_provider_version}_x4 /usr/local/bin

* https://terraform.io/
* https://releases.hashicorp.com/terraform/
* https://releases.hashicorp.com/terraform-provider-aws/
* https://releases.hashicorp.com/terraform-provider-terraform/

Install Packer::

    # Get core binary
    packer_version='1.0.3'
    wget https://releases.hashicorp.com/packer/${packer_version}/packer_${packer_version}_linux_amd64.zip
    wget https://releases.hashicorp.com/packer/${packer_version}/packer_${packer_version}_SHA256SUMS.sig
    wget https://releases.hashicorp.com/packer/${packer_version}/packer_${packer_version}_SHA256SUMS

    # Verify and extract stuff
    gpg --verify packer_${packer_version}_SHA256SUMS.sig \
        packer_${packer_version}_SHA256SUMS
    sha256sum -c <(grep packer_${packer_version}_linux_amd64.zip \
        packer_${packer_version}_SHA256SUMS)
    unzip packer_${packer_version}_linux_amd64.zip
    sudo cp packer /usr/local/bin

* https://packer.io/
* https://releases.hashicorp.com/packer/


Running Terraform
-----------------

Run terraform::

    CHECKPOINT_DISABLE=1 \
    AWS_PROFILE=foo \
    terraform plan \
        -var 'key_name=terraform' \
        -var 'public_key_path=/home/bubba/terraform.pub'

    CHECKPOINT_DISABLE=1 \
    AWS_PROFILE=foo \
    terraform apply \
        -var 'key_name=terraform' \
        -var 'public_key_path=/home/bubba/terraform.pub'


AMIs
----

* http://ec2instances.info
* https://wiki.debian.org/Cloud/AmazonEC2Image
* https://noah.meyerhans.us/blog/2017/04/20/stretch-images-for-aws/
* http://cloud-images.ubuntu.com/locator/ec2/


Installing Stuff
----------------

1.  Start the instance and ssh into it.

2.  Install docker::

    # Add new repo
    wget -O - https://download.docker.com/linux/$(lsb_release --id --short | tr [A-Z] [a-z])/gpg |\
        sudo apt-key add -
    sudo bash -c 'echo "deb [arch=amd64] https://download.docker.com/linux/$(lsb_release --id --short | tr [A-Z] [a-z])" \
        "$(lsb_release --codename --short) stable" > /etc/apt/sources.list.d/docker.list'
    sudo apt-get update

    # Add new package
    sudo apt-get --yes install docker-ce

    # Add user to the 'docker' group
    sudo usermod -a -G docker ${USER}

* https://docs.docker.com/engine/installation/linux/debian/
* https://docs.docker.com/engine/installation/linux/ubuntu/

3.  Install git and pip::

    sudo apt-get --yes install git python-pip python3-pip docker-compose

4.  Clone WebODM::

    git clone https://github.com/OpenDroneMap/WebODM.git --config core.autocrlf=input

* https://www.webodm.org/
* https://github.com/OpenDroneMap/WebODM
* https://github.com/OpenDroneMap/OpenDroneMap
* https://github.com/OpenDroneMap/node-OpenDroneMap


Running Stuff
-------------

1.  Start the instance and ssh into it.

2.  Start WebODM::

    ./webodm.sh start

3.  Connect to the web console at http://PUBLICIPADDRESSOFINSTANCE:8000


Tweaking Stuff
--------------

1.  Change the value of the setting "min-num-features" from 4000 to 10000
