# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure(2) do |config|
  config.vm.box = "fedora/23-cloud-base"
  config.vm.provision :shell, path: "bootstrap.sh"
  config.vm.synced_folder "src/", "/docker-ovn"
end
