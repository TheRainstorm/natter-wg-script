#!/usr/bin/env sh
PROT=$1
LOCAL_IP=$2
LOCAL_PORT=$3
PUBLIC_IP=$4
PUBLIC_PORT=$5

echo "$PROT://$LOCAL_IP:$LOCAL_PORT <--Natter--> $PROT://$PUBLIC_IP:$PUBLIC_PORT"

script_dir=$(dirname "$0")
. $script_dir/env.sh

if [ $PROT != "udp" ]; then
    echo "Wireguard only supports udp"
    exit 1
fi

echo "run remote commands"
ssh $REMOTE "bash -s" <<EOF
sed -i "/$HOST_WG_PUB_KEY/,/^config/{
    s/option endpoint_port.*/option endpoint_port '$PUBLIC_PORT'/
    s/option endpoint_host.*/option endpoint_host '$PUBLIC_IP'/
}" "/etc/config/network"

#wg set $WG_IF peer $HOST_WG_PUB_KEY endpoint $PUBLIC_IP:$PUBLIC_PORT

ifconfig $WG_IF down && ifup $WG_IF
EOF

echo "restart host wg interface"
ifconfig $HOST_WG_IF down && ifup $HOST_WG_IF

echo "Finished"
