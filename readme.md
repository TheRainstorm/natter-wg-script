## intro

[Natter](https://github.com/MikeWang000000/Natter) is a tool to expose your port behind full-cone NAT to the Internet. It support run custom script after get mapped address with `-e <path>`. Wireguard is a common VPN protocal used in site to site networking. This script help you to update your wireguard endpoint automatically with one line command. 

Since we are behind NAT, we can't notify the remote node to update the endpoint.

> The only built-in way for a WireGuard client to detect a change to an endpoint’s IP address is if the endpoint proactively initiates a connection to the client from its new IP address (which NAT or other firewall rules make impossible in a typical client-server scenario) — so normally you’d have to restart the client in order to force it to look up the new IP address of the server. [DNS Updates to WireGuard Endpoints | Pro Custodibus](https://www.procustodibus.com/blog/2021/06/dns-updates-to-wireguard-endpoints/)

Wireguard only resolve endpoint domain when it startup, so saving new ip and port to a DNS record is not helpful.

Therefore, the only way is ssh to the remote node and update the endpoint manually. Since IPv6 is common nowadays, we can use it to connect to the remote node.

## Usage

replace the variables in `env-template.sh` and save it as `env.sh`

- `REMOTE`: the remote openwrt node, use ssh to connect. It's ok to specify port. e.g `REMOTE="root@xxx -p xxx"`
- `WG_IF`: the wireguard interface name on the remote node
- `HOST_WG_IF`: the wireguard interface name on the local node
- `HOST_WG_PUB_KEY`: the public key of the wireguard interface on the local node

run natter with `-e` option to specify the script path, a sample command is:

```shell
ifconfig wg_s2s down && python natter.py -i pppoe-wan -u -b 51821 -e ~/natter-wg-script/wg-update.sh
```

## reference

- [feat: combine cloudflare script and introduce POT port record method by jdjingdian · Pull Request #106 · MikeWang000000/Natter (github.com)](https://github.com/MikeWang000000/Natter/pull/106)
- [DNS Updates to WireGuard Endpoints | Pro Custodibus](https://www.procustodibus.com/blog/2021/06/dns-updates-to-wireguard-endpoints/)
