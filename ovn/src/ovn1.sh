cd /home/vagrant/ovs
#sudo make sandbox SANDBOXFLAGS="--ovn"

OVN_SB_DB=tcp:192.168.10.2:6640

sudo /usr/local/share/openvswitch/scripts/ovs-ctl --system-id=random start
sudo /usr/local/share/openvswitch/scripts/ovn-ctl start_northd
sudo /usr/local/share/openvswitch/scripts/ovn-ctl start_controller
sudo /usr/local/bin/ovs-appctl -t ovsdb-server ovsdb-server/add-remote ptcp:6640:192.168.10.2

sudo /usr/local/bin/ovs-vsctl set open . external-ids:ovn-remote=tcp:192.168.10.2:6640
sudo /usr/local/bin/ovs-vsctl set open . external-ids:ovn-encap-type=geneve
sudo /usr/local/bin/ovs-vsctl set open . external-ids:ovn-encap-ip=192.168.10.2

sudo /usr/local/bin/ovn-nbctl lswitch-add sw0
