cd /home/vagrant/ovs
#sudo make sandbox SANDBOXFLAGS="--ovn"
sudo /usr/local/share/openvswitch/scripts/ovs-ctl --system-id=random start
sudo /usr/local/share/openvswitch/scripts/ovn-ctl start_northd
sudo /usr/local/share/openvswitch/scripts/ovn-ctl start_controller

sudo /usr/local/bin/ovs-vsctl set open . external-ids:ovn-remote=unix:/usr/local/var/run/openvswitch/db.sock
sudo /usr/local/bin/ovs-vsctl set open . external-ids:ovn-encap-type=geneve
sudo /usr/local/bin/ovs-vsctl set open . external-ids:ovn-encap-ip=127.0.0.1

sudo /usr/local/bin/ovn-nbctl lswitch-add sw0
