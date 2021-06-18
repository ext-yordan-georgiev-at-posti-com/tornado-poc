# referece from: https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04
do_check_install_docker() {

   # Install dependencies.
   sudo apt update
   sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

   # Add docker GPG key.
   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

   # Install docker.
   sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
   sudo apt update
   apt-cache policy docker-ce
   sudo apt install -y docker-ce

   # Show service status.
   sudo systemctl status --no-pager --full docker

   # Add user to docker group
   sudo groupadd docker
   sudo usermod -aG docker ${USER}
   sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
   sudo chmod g+rwx "$HOME/.docker" -R
   sudo chmod 777 /var/run/docker.sock

   # Test docker with hello-world image.
   sudo docker run --rm hello-world
   sleep 2
   sudo docker rmi hello-world

   # Install docker-compose for current os.
   sudo curl -L "https://github.com/docker/compose/releases/download/1.28.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
   sudo chmod +x /usr/local/bin/docker-compose

   # Install docker-machine.
   curl -L https://github.com/docker/machine/releases/download/v0.16.2/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine
   chmod +x /tmp/docker-machine
   sudo mv /tmp/docker-machine /usr/local/bin/docker-machine

   # Validate docker-compose installation.
   docker-compose --version
   sleep 2

}
