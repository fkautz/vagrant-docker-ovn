cd /home/vagrant/ovs
#sudo make sandbox SANDBOXFLAGS="--ovn"
sudo /usr/local/share/openvswitch/scripts/ovs-ctl --system-id=random start
sudo /usr/local/share/openvswitch/scripts/ovn-ctl start_northd
sudo /usr/local/share/openvswitch/scripts/ovn-ctl start_controller

sudo /usr/local/bin/ovs-vsctl add-br br-int
sudo /usr/local/bin/ovn-nbctl lswitch-add sw0
