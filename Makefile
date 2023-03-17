#
# Copyright (C) 2023 Bobby
#

include $(TOPDIR)/rules.mk

LUCI_TITLE:=Support for WireGuard VPN
LUCI_DEPENDS:=+kmod-wireguard +wireguard-tools
LUCI_PKGARCH:=all

include ../../luci.mk

# call BuildPackage - OpenWrt buildroot signature
