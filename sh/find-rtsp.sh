#!/bin/bash

eth0=$(ip addr | egrep -A 2 'eth0' | egrep 'inet ' | awk '{ print $2 }' | awk -F/ '{ print $1 }')
wlan=$(ip addr | egrep -A 2 'wlan' | egrep 'inet ' | awk '{ print $2 }' | awk -F/ '{ print $1 }')
wnet=${wlan%.*}.0/24

if [ -z "$(command -v nmap)" ]; then
  echo "Please install nmap; sudo apt install -qq -y nmap"
  exit 1
fi

if [ "${USER:-null}" != 'root' ]; then
  echo "Please run as root; sudo ${0} ${*}"
  exit 1
fi

echo "Searching ${wnet} for devices.." &> /dev/stderr
ip=$(nmap -sn -T5 ${wnet} | egrep -v ${wlan} | egrep '^Nmap scan' | awk '{ print $5 }' )

if [ "${ip:-null}" != 'null' ]; then
  echo "Located device at ${ip}; attempting RTSP connection.." &> /dev/stderr
  code=$(curl -sSL -w '%{http_code}' "rtsp://${ip}/")
  if [ "${code:-null}" = '200' ]; then
    echo "Found RTSP camera at: ${ip}" &> /dev/stderr
  fi
fi
