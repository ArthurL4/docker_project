NODES = {
  "manager1" => "192.168.99.100",
  "worker1" => "192.168.99.101",
  "worker2" => "192.168.99.102",
}

Vagrant.configure("2") do |config|
  NODES.each do |(node_name, ip_address)|
    config.vm.define node_name do |node|
      node.vm.box = "bento/ubuntu-24.04"
      node.vm.hostname = node_name
      node.vm.network "private_network", ip: ip_address

      node.vm.provider "virtualbox" do |v|
        v.name = node_name
        v.memory = "1024"
        v.cpus = "1"
      end

      node.vm.provision "shell", inline: <<-SHELL
        # Faire en sorte que les machines puissent communiquer entre elles via leur hostnames (exemple: ping worker1 depuis manager1)
        #{NODES.map{ |n_name, ip| "echo '#{ip} #{n_name}' | sudo tee -a /etc/hosts\n"}.join}



#POUR RAJOUTER LE REPO DE DOCKER ENGINE -> https://docs.docker.com/engine/install/ubuntu/
#PERMET D INSTALLER DOCKER ENGINE donc pas la version desktop, sur les VM directement, ça installer docker, docker-cli et docker-compose et docker-buildx

      # Add Docker's official GPG key:
        sudo apt remove $(dpkg --get-selections docker.io docker-compose docker-compose-v2 docker-doc docker-buildx podman-docker containerd runc | cut -f1)
        sudo apt update
        sudo apt install -y ca-certificates curl
        sudo install -m 0755 -d /etc/apt/keyrings
        sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
        sudo chmod a+r /etc/apt/keyrings/docker.asc


## Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

        sudo apt update
        sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        sudo usermod -aG docker vagrant
      SHELL
      end
    end
  end

