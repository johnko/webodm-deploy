WebODM / OpenDroneMap
=====================


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
