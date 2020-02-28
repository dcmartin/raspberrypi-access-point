
# &#128246; `raspberrypi-access-point`

This [repository][repository] contains documentation and scripts to setup a RaspberryPi as a WiFi access point, including
DHCP and DNS services.

A corresponding subnet is created for connected devices; by default the subnet is based on the host IP address.

+ Host IP: `192.168.1.93`
+ Subnet `192.168.93.1/24`
+ Range `(1-3)`
+ Duration `24h`

**Only TCP/IP version 4** traffic is routed on the host to and from the subnet.

The [MIT Man-in-the-Middle](https://mitmproxy.org/) proxy may be enabled to intercept `HTTP/S` traffic (i.e. ports `80` and `443`).

## Further Information

+ [`RPI.md`](doc/RPI.md) to setup a RaspberryPi
+ [`HASSIO.md`](doc/HASSIO.md) to optionally install [Home Assistant](http://home-assistant.io)
+ [`uhubctl/README.md`](uhubctl/README.md) to optionally install [`uhubctl`](https://github.com/mvp/uhubctl)

## Introduction

Setting up a RaspberryPi as a WiFi access point is documented in many places, including the [ThePi](https://thepi.io/how-to-use-your-raspberry-pi-as-a-wireless-access-point/) and [official](https://www.raspberrypi.org/documentation/configuration/wireless/access-point.md) specifications.  IMHO the existing instructions were insufficient for successful replication.

## Requirements

Your device will require both an Ethernet cable connection as well as WiFi adapter.  You will need to install the latest Raspbian Buster release; [documentation](doc/RPI.md) is provided in this repository.

Other sources include the [official](https://www.raspberrypi.org/documentation/installation/) specification.

### &#9937;`rpi-update`
Depending on the age of the device you may need to update the firmware.  The `rpi-update` program will update the firmware for your RaspberryPi; for example:

```
sudo rpi-update
```

The download is often large (e.g. > 100 MB) and sometimes fails; to avoid failures when attempting to update, include the update on the flashed SD card prior to installation in the device (see [RPI.md](doc/RPI.md)); for example:

```
curl -sSL https://github.com/Hexxeh/rpi-firmware/archive/master.tar.gz -o master.tar.gz
sudo cp master.tar.gz /Volumes/boot
```

After the machine has booted, use `sudo -s` to become root and

+ make the directory
+ move the included archive
+ unpack the archive
+  run `rpi-update`-- skipping the download
+  `reboot` the device

For example:

```
sudo -s
mkdir -p /root/.rpi-firmware
cd /root/.rpi-firmware
tar xzf /master.tar.gz .
SKIP_DOWNLOAD=1 rpi-update
reboot
```
When `rpi-update` is complete, reboot the device and update the system again; invariably the device will require another `reboot` command; for example:

```
sudo apt update -qq -y
sudo apt full-upgrade -qq -y
sudo reboot
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

# Finding `RTSP` cameras

To find **RTSP** camera(s) attached to the WiFi access point, use the [sh/find-rtsp.sh](sh/find-rtsp.sh) 
shell script to find devices on the subnet and attempt `RTSP` connections; for example:

```
./sh/find-rtsp.sh
```

# Further information
The WiFi network and TCP/IP subnetwork may be used in conjunction with other systems.  Please see below for further information.

## [Home Assistant](http://home-assistant.io) `motion` _add-on_
For devices running Home Assistant and the [`motion`](http://github.com/dcmartin/motion) _add-on_, when using WiFi as the primary network, the configuration is completed by generating a **QR code** which is displayed to the device's camera to provide setup information.  The QR code may be generated [on-line](https://zxing.appspot.com/generator) using the provided `Wifi network` template.

For testing purposes, using the WiFi `SSID=TEST` and the `WPA_PASSPHRASE=0123456789` the following QR code may be used:

<img width="50%" src="doc/samples/wifi-TEST-0123456789.png">

## WyzeCam `RTSP` cameras
For WyzeCam devices whether being used as an `RTSP` [source](https://support.wyzecam.com/hc/en-us/articles/360026245231-Wyze-Cam-RTSP) by the [`motion`](http://github.com/dcmartin/motion) _add-on_ or not,  the configuration is completed by connecting a mobile device (e.g. iOS or Android) to the RaspberryPi provided WiFi SSID (and TCP/IP subnet) and running the Wyze application to add a device.  The application generates a **QR code** which is then displayed to the camera to provide setup information.

For testing purposes, using the WiFi `SSID=TEST` and the `WPA_PASSPHRASE=0123456789` the following QR code may be used:

<img width="50%" src="doc/samples/wyze-TEST-0123456789.png">

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
