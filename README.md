
# &#128246; `raspberrypi-access-point`

This [repository][repository] contains documentation and scripts to setup a RaspberryPi as a WiFi access point, including
DHCP and DNS services.

A corresponding subnet is created for connected devices; by default the subnet is based on the host IP address.

+ Host IP: `192.168.1.93`
+ Subnet `192.168.93.1/24`
+ Range `(2-254)`
+ Duration `24h`

TCP/IP version 4 traffic is routed between the primary and subnet.

The [MIT Man-in-the-Middle](https://mitmproxy.org/) proxy may be enabled to intercept `HTTP/S` traffic (i.e. ports `80` and `443`).

# 1. Status

[arm64-shield]: https://img.shields.io/badge/aarch64-no-red.svg
[amd64-shield]: https://img.shields.io/badge/amd64-no-red.svg
[arm-shield]: https://img.shields.io/badge/armhf-yes-green.svg

## 1. Introduction

Setting up a RaspberryPi as a WiFi access point is documented in many places, including the [ThePi](https://thepi.io/how-to-use-your-raspberry-pi-as-a-wireless-access-point/) and [official](https://www.raspberrypi.org/documentation/configuration/wireless/access-point.md) specifications.

Your device will require both an Ethernet cable connection as well as WiFi adapter.

## Requirements

You will need to install the latest Raspbian Buster release on the RaspberryPi; [documentation](doc/RPI.md) is provided in this repository; other sources include the [official](https://www.raspberrypi.org/documentation/installation/) specification.

Depending on the age of the device you may need to update; for example:

```
rpi-update
```

## Use

After successfully installing Raspbian and accessing the device, the `rpi-bridge.sh` script will configure the system to provide 
a WiFi access point.  The access point has the following options:

+ `SSID` - The identifier used for the WiFi network; default: `TEST`
+ `WPA_PASSPHRASE` - The password for access to the WiFi network **minimum of eight (8) characters**; default: `0123456789`
+ `HW_MODE` - The type of WiFi network; options are `g` and `a` _mode `a` may not work on all devices_; default: `g`
+ `CHANNEL` - The network channel used for the WiFi network; default: `8`

These values may be changed using the _bash_ command-line, for example:

```
export SSID="MyNetwork"
export WPA_PASSPHRASE="MyNetworkPassword"
export CHANNEL=6
```

Executing the script configures the WiFi adapter (n.b. `wlan0` by default) to provide a subnet of the parent network with both a DNS and DHCP server.

Devices connecting to the WiFi network using the specified `SSID` and `WPA_PASSPHRASE` will be assigned IP addresses on the subnet and have traffic routed from the WiFi network to the Ethernet network.

&#9995; **For example**, from a _bash_ command prompt:

```
sudo -s
export SSID="TEST" WPA_PASSPHRASE="0123456789" CHANNEL=8
./sh/rpi-bridge
exit
```

If the script successfully executes it outputs a JSON structure with the configuration applied; record that information for review.

```
USAGE: ./sh/rpi-bridge.sh [ br0 ]
SSID: TEST, WPA_PASSPHRASE: 0123456789, CHANNEL: 8, HW_MODE: g; DNS_NAMESERVERS: 9.9.9.9 1.1.1.1
--- INFO ./sh/rpi-bridge.sh 27414 -- DNSMASQ version: 2.80
Synchronizing state of dnsmasq.service with SysV service script with /lib/systemd/systemd-sysv-install.
Executing: /lib/systemd/systemd-sysv-install enable dnsmasq
Synchronizing state of dhcpcd.service with SysV service script with /lib/systemd/systemd-sysv-install.
Executing: /lib/systemd/systemd-sysv-install enable dhcpcd
Synchronizing state of hostapd.service with SysV service script with /lib/systemd/systemd-sysv-install.
Executing: /lib/systemd/systemd-sysv-install enable hostapd
{
  "date": "2020-01-31T17:52:35Z",
  "interface": "wlan0",
  "dnsmasq": {
    "version": "2.80",
    "dhcp": {
      "ip": "192.168.93.1",
      "netsize": 24,
      "netmask": "255.255.255.0",
      "start": "192.168.93.2",
      "finish": "192.168.93.254",
      "duration": "24h"
    },
    "options": [
      "bind-dynamic",
      "domain-needed",
      "bogus-priv"
    ]
  },
  "iptables": {
    "script": "/etc/iptables.sh",
    "service": "/etc/systemd/system/iptables.service"
  },
  "hostapd": {
    "interface": "wlan0",
    "channel": 8,
    "bridge": "null",
    "hw_mode": "g",
    "wpa": 2,
    "ssid": "TEST",
    "wpa_passphrase": "0123456789"
  }
}
```

&#9989; After success, reboot the device.

```
sudo reboot
```

#  Further Information 

See [`HASSIO.md`](doc/HASSIO.md) for information on installing [Home Assistant](http://home-assistant.io)

# Changelog & Releases

Releases are based on Semantic Versioning, and use the format
of ``MAJOR.MINOR.PATCH``. In a nutshell, the version will be incremented
based on the following:

- ``MAJOR``: Incompatible or major changes.
- ``MINOR``: Backwards-compatible new features and enhancements.
- ``PATCH``: Backwards-compatible bugfixes and package updates.

## Authors & contributors

David C Martin (github@dcmartin.com)

[commits]: https://github.com/dcmartin/raspberrypi-access-point/commits/master
[contributors]: https://github.com/dcmartin/raspberrypi-access-point/graphs/contributors
[dcmartin]: https://github.com/dcmartin
[issue]: https://github.com/dcmartin/raspberrypi-access-point/issues
[repository]: https://github.com/dcmartin/raspberrypi-access-point
