local map, section, net = ...
local ifname = net:get_interface():name()
local private_key, listen_port
local metric, mtu, preshared_key
local peers, public_key, allowed_ips, endpoint, persistent_keepalive

-- general --

private_key = section:taboption("general", Value, "private_key", translate("Private Key"), translate("Required"))
private_key.password = true
private_key.datatype = "and(base64,rangelength(44,44))"
private_key.optional = false

listen_port = section:taboption("general", Value, "listen_port", translate("Listen Port"), translate("Optional"))
listen_port.datatype = "port"
listen_port.placeholder = translate("random")
listen_port.optional = true

addresses = section:taboption("general", DynamicList, "addresses", translate("IP Addresses"), translate("Recommended"))
addresses.datatype = "ipaddr"
addresses.optional = true

-- advanced --

metric = section:taboption("advanced", Value, "metric", translate("Metric"), translate("Optional"))
metric.datatype = "uinteger"
metric.placeholder = "0"
metric.optional = true

mtu = section:taboption("advanced", Value, "mtu", translate("MTU"), translate("Optional. Maximum Transmission Unit of tunnel interface."))
mtu.datatype = "range(1280,1420)"
mtu.placeholder = "1420"
mtu.optional = true

fwmark = section:taboption("advanced", Value, "fwmark", translate("Firewall Mark"), translate("Optional. 32-bit mark for outgoing encrypted packets. " .. "Enter value in hex, starting with <code>0x</code>."))
fwmark.datatype = "hex(4)"
fwmark.optional = true

-- peers --

peers = map:section(TypedSection, "wireguard_" .. ifname, translate("Peers"))
peers.template = "cbi/tsection"
peers.anonymous = true
peers.addremove = true

public_key = peers:option(Value, "public_key", translate("Public Key"), translate("Required"))
public_key.datatype = "and(base64,rangelength(44,44))"
public_key.optional = false

preshared_key = peers:option(Value, "preshared_key", translate("Preshared Key"), translate("Optional"))
preshared_key.password = true
preshared_key.datatype = "and(base64,rangelength(44,44))"
preshared_key.optional = true

allowed_ips = peers:option(DynamicList, "allowed_ips", translate("Allowed IPs"), translate("Required"))
allowed_ips.datatype = "ipaddr"
allowed_ips.optional = false

route_allowed_ips = peers:option(Flag, "route_allowed_ips", translate("Route Allowed IPs"), translate("Optional"))

endpoint_host = peers:option(Value, "endpoint_host", translate("Endpoint Host"), translate("Optional"))
endpoint_host.datatype = "host"

endpoint_port = peers:option(Value, "endpoint_port", translate("Endpoint Port"), translate("Optional"))
endpoint_port.datatype = "port"

persistent_keepalive = peers:option(Value, "persistent_keepalive", translate("Persistent Keep Alive"), translate("Optional. Seconds between keep alive messages. " .. "Default is 0 (disabled). Recommended value if " .. "this device is behind a NAT is 25."))
persistent_keepalive.datatype = "range(0,65535)"
persistent_keepalive.placeholder = "0"
