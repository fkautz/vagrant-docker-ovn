# vagrant-docker-ovn

Initialize and run the VM:
```sh
vagrant up --provider libvirt
vagrant ssh
/docker-ovn/ovn.sh
/docker-ovn/docker.sh
```

To update the scripts, reboots VM in the process:
```sh
vagrant reload
vagrant ssh
```
