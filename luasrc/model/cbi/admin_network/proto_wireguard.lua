local map, section, net = ...
local ifname = net:get_interface():name()
local private_key, local_public_key, listen_port
local metric, mtu, preshared_key
local peers, public_key, allowed_ips, endpoint, persistent_keepalive

-- general --

local_private_key = section:taboption("general", Value, "private_key", translate("本地私钥"))
local_private_key.datatype = "and(base64,rangelength(44,44))"
local_private_key.optional = false

local_public_key = section:taboption("general", Value, "local_public_key", translate("本地公钥"))
local_public_key.datatype = "and(base64,rangelength(44,44))"
local_public_key.optional = false

listen_port = section:taboption("general", Value, "listen_port", translate("监听端口"), translate("可选"))
listen_port.datatype = "port"
listen_port.placeholder = translate("random")
listen_port.optional = true

addresses = section:taboption("general", DynamicList, "addresses", translate("IP 地址(段)"), translate("推荐"))
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

peers = map:section(TypedSection, "wireguard_" .. ifname, translate("节点"))
peers.template = "cbi/tsection"
peers.anonymous = true
peers.addremove = true

public_key = peers:option(Value, "public_key", translate("节点公钥"), translate("必填"))
public_key.datatype = "and(base64,rangelength(44,44))"
public_key.optional = false

preshared_key = peers:option(Value, "preshared_key", translate("预共享密钥"), translate("可选"))
preshared_key.password = true
preshared_key.datatype = "and(base64,rangelength(44,44))"
preshared_key.optional = true

allowed_ips = peers:option(DynamicList, "allowed_ips", translate("允许的 IP 地址(段)"), translate("必填"))
allowed_ips.datatype = "ipaddr"
allowed_ips.optional = false

route_allowed_ips = peers:option(Flag, "route_allowed_ips", translate("路由允许的 IP 地址(段)"), translate("可选"))

endpoint_host = peers:option(Value, "endpoint_host", translate("对端主机"), translate("可选"))
endpoint_host.datatype = "host"

endpoint_port = peers:option(Value, "endpoint_port", translate("对端端口"), translate("可选"))
endpoint_port.datatype = "port"

persistent_keepalive = peers:option(Value, "persistent_keepalive", translate("连接保活间隔"), translate("可选。单位秒。范围是 0 ~ 65535。0 表示禁用。建议 25"))
persistent_keepalive.datatype = "range(0,65535)"
