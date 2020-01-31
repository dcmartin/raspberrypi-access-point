# &#9968; `raspberrypi-access-point`

This [repository][repository] contains documentation and scripts to setup a RaspberryPi as a WiFi access point.

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

These values may be changed using the LINUX command-line, for example:

```
export SSID="MyNetwork"
export WPA_PASSPHRASE="MyNetworkPassword"
export CHANNEL=6
```

Executing the script configures the WiFi adapter (n.b. `wlan0` by default) to provide a subnet of the parent network with both a DNS and DHCP server.

Devices connecting to the WiFi network using the specified `SSID` and `WPA_PASSPHRASE` will be assigned IP addresses on the subnet and have traffic routed from the WiFi network to the Ethernet network.


```
sudo ./sh/rpi-bridge
```

If the script successfully executes it outputs a JSON structure with the configuration applied; record that information for review.

After success, reboot the device.

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
