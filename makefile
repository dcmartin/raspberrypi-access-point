default:
	@echo "This makefile downloads the rpi-update download; use make download"

download: master.tar.gz

master.tar.gz:
	curl -sSL https://github.com/Hexxeh/rpi-firmware/archive/master.tar.gz -o master.tar.gz
