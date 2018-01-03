# CUPS

Ok, you want to print from your steamlink because it's small, always powered on and available on your 
network - a perfect machine to become a print server.

In order to achiveve this, you will need to compile a lot of stuff, such as: 

  - libjpeg
  - libpng
  - libopenjpeg
  - libtiff
  - libqpdf
  - lcms
  - freetype
  - fontconfig
  - foo2xqx
  - poppler
  - cups
  - cups-filters
  - ghostscript

All of these have their own `build_steamlink.sh` scripts in corresponding directories. 

# HOWTO

Clone steamlink-sdk from `https://github.com/ValveSoftware/steamlink-sdk`, move directories with libs mentioned above into `examples`  directory.

Go into each directory (in same order as in the list above) and run `build-steamlink.sh` script. This will build the lib 
and put it into `packagename-build` directory along with the script. You will need to copy the results to the _local_ rootfs first 
so you'll be able to compile everything. Example: 

```
cd steamlink-sdk/examples/libpng
cp -r libpng-build/* ../../rootfs
```

After you finish compiling everything, go into `examples` dir and gather the results:

```
find -type d -name *-build -exec rsync -av {}/ /tmp/cups-build \;
tar -cvf cups-build.tar /tmp/cups-build
```

Copy the archive to steamlink, unpack it, remount the filesystem with rw option and copy the files:

```
root@steamlink:~# tar -xvf cups-build.tar
mount -o remount,rw / 
cp -r cups-build/* /
```

By doing so you may overwrite some systemfiles which can break your steamlink 5ever - you've been warned.

# Post-install

Enable remote administration:

```
cupsd -f
cupsctl --remote-admin
```

Enable CGI scripts ( `PID 5892 (/usr/lib/cups/cgi-bin/admin.cgi) stopped with status 113 (Permission denied)` ):

https://www.cups.org/doc/cgi.html - create `/etc/cups/cgi.types` with following content:
```
application/x-httpd-cgi cgi
application/x-httpd-java class
application/x-httpd-perl pl
application/x-httpd-php php
application/x-httpd-python py
```

## Add printer

Add udev rule on steamlink, idVendor and idProduct are taken from `lsusb` output - use your own instead of abcd and 0123.
You can also get them from dmesg output - just reattach the printer.

```
vi /etc/udev/rules.d/10-printer.rules

ATTR{idVendor}=="abcd", ATTR{idProduct}=="0123", MODE:="0666", GROUP:="lp"
```
Reboot the steamlink, remount filesystem with rw option. 

Add printer via webinterface (`http://<steamlink_ip>:631`, login `root`, password `steamlink` or whatever you set it to). 
If printer is not available on `Add printer` page - I am really sorry for you. You can enable debug with `cupsctl --debug-logs`, 
restart cups and google the errors.

Add printer manually, may not work (I cheated and scpd drivers in ppd format from system where that printer 
was already working (see `/etc/cups/ppd/` on your computer where that printer works)):

```
/usr/lib/cups/backend/usb
lpadmin -E -p 'HP_LaserJet_M1120_MFP' -v 'usb://HP/LaserJet%20M1120%20MFP?serial=MF326NK&interface=1' -P /etc/cups/ppd/HP_LaserJet_M1120_MFP.ppd
```

## Print

```
lp -d HP_LaserJet_M1120_MFP /usr/share/cups/data/default-testpage.pdf
```

# Notes

Build scripts are ugly and I am pretty sure I left hardcoded paths in some of them. Please report issues.

Network printing is not working yet - not sure what to do yet.
