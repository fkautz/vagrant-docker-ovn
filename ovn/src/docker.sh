#!/bin/sh -ex
echo "Hello Docker"

OVN_BRIDGE="br-int"

PATH=$PATH:/usr/local/bin

CONTAINER1_ID=$(sudo docker run -dit alpine sh)
CONTAINER1_NAME=$(sudo docker inspect --format '{{ .Name }}' $CONTAINER1_ID | sed s/\\///)
CONTAINER1_MAC_ADDR=$(sudo docker inspect --format '{{ .NetworkSettings.MacAddress }}' $CONTAINER1_ID)
CONTAINER1_IP4_ADDR=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' $CONTAINER1_ID)
CONTAINER1_CIDR_ADDR=$(sudo docker inspect --format '{{ .NetworkSettings.IPPrefixLen }}' $CONTAINER1_ID)
CONTAINER1_PID=$(sudo docker inspect --format '{{ .State.Pid }}' $CONTAINER1_ID)
echo "$CONTAINER1_NAME: $CONTAINER1_MAC_ADDR $CONTAINER1_IP4_ADDR $CONTAINER1_CIDR_ADDR $CONTAINER1_PID"

CONTAINER2_ID=$(sudo docker run -dit alpine sh)
CONTAINER2_NAME=$(sudo docker inspect --format '{{ .Name }}' $CONTAINER2_ID | sed s/\\///)
CONTAINER2_MAC_ADDR=$(sudo docker inspect --format '{{ .NetworkSettings.MacAddress }}' $CONTAINER2_ID)
CONTAINER2_IP4_ADDR=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' $CONTAINER2_ID)
CONTAINER2_CIDR_ADDR=$(sudo docker inspect --format '{{ .NetworkSettings.IPPrefixLen }}' $CONTAINER2_ID)
CONTAINER2_PID=$(sudo docker inspect --format '{{ .State.Pid }}' $CONTAINER2_ID)
echo "$CONTAINER2_NAME: $CONTAINER2_MAC_ADDR $CONTAINER2_IP4_ADDR $CONTAINER2_CIDR_ADDR $CONTAINER2_PID"

# set up flow for container 1
sudo nsenter --target $CONTAINER1_PID --net ip link del eth0
sudo ip link add vethe1 type veth peer name vethi1
sudo ip link set vethi1 netns $CONTAINER1_PID
sudo nsenter --target $CONTAINER1_PID --net ip link set dev vethi1 name eth0
sudo nsenter --target $CONTAINER1_PID --net ip link set dev eth0 mtu 1450
sudo nsenter --target $CONTAINER1_PID --net ip addr add $CONTAINER1_IP4_ADDR/$CONTAINER1_CIDR_ADDR dev eth0
sudo /usr/local/bin/ovn-nbctl lport-add sw0 $CONTAINER1_NAME
sudo /usr/local/bin/ovn-nbctl lport-set-addresses $CONTAINER1_NAME $CONTAINER1_MAC_ADDR $CONTAINER1_IP4_ADDR
#sudo /usr/local/bin/ovs-vsctl add-port br-int vethe1 -- set Interface vethe1 external_ids:attached-mac=$CONTAINER1_MAC_ADDR external_ids:iface-id=$CONTAINER1_ID external_ids:ip_address=$CONTAINER1_IP4_ADDR
#sudo /usr/local/bin/ovs-vsctl add-port br-int vethe1
sudo /usr/local/bin/ovs-vsctl add-port br-int vethe1 -- set Interface vethe1 external_ids:iface-id=$CONTAINER1_NAME
sudo nsenter --target $CONTAINER1_PID --net ip link set dev eth0 up
sudo ip link set vethe1 up

# set up flow for container 2
sudo nsenter --target $CONTAINER2_PID --net ip link del eth0
sudo ip link add vethe2 type veth peer name vethi2
sudo ip link set vethi2 netns $CONTAINER2_PID
sudo nsenter --target $CONTAINER2_PID --net ip link set dev vethi2 name eth0
sudo nsenter --target $CONTAINER2_PID --net ip link set dev eth0 mtu 1450
sudo nsenter --target $CONTAINER2_PID --net ip addr add $CONTAINER2_IP4_ADDR/$CONTAINER2_CIDR_ADDR dev eth0
sudo /usr/local/bin/ovn-nbctl lport-add sw0 $CONTAINER2_NAME
sudo /usr/local/bin/ovn-nbctl lport-set-addresses $CONTAINER2_NAME $CONTAINER2_MAC_ADDR $CONTAINER2_IP4_ADDR
#sudo /usr/local/bin/ovs-vsctl add-port br-int vethe2 -- set interface vethe2 external_ids:attached-mac=$CONTAINER2_MAC_ADDR external_ids:iface-id=$CONTAINER2_ID external_ids:ip_address=$CONTAINER2_IP4_ADDR
#sudo /usr/local/bin/ovs-vsctl add-port br-int vethe2
sudo /usr/local/bin/ovs-vsctl add-port br-int vethe2 -- set Interface vethe2 external_ids:iface-id=$CONTAINER2_NAME
sudo nsenter --target $CONTAINER2_PID --net ip link set dev eth0 up
sudo ip link set dev vethe2 up

# debug
#/usr/local/bin/ovn-nbctl show
#/usr/local/bin/ovs-ofctl dump-flows br-int
#/usr/local/bin/ovs-ofctl show br-int
#docker exec -it $CONTAINER1_NAME /bin/sh
