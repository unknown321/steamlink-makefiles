# Notes

Enable remote administration:

```
cupsd -f
cupsctl --remote-admin
```

Enable CGI scripts ( PID 5892 (/usr/lib/cups/cgi-bin/admin.cgi) stopped with status 113 (Permission denied) ):

https://www.cups.org/doc/cgi.html - create `/etc/cups/cgi.types` with following content:
```
application/x-httpd-cgi cgi
application/x-httpd-java class
application/x-httpd-perl pl
application/x-httpd-php php
application/x-httpd-python py
```

Get the drivers for your printer from here - https://www.openprinting.org, most likely you'll have to compile then.

Or get python3 and install https://packages.debian.org/stretch/foomatic-db-compressed-ppds.

I cheated and scpd drivers from main system

Add printer:

```
dmesg | grep -A1 -B1 "device strings"
lsusb
# here you find out the number of your printer by device id
lpadmin -v usb://dev/bus/usb/001/006 -p 'printer' -P /etc/cups/ppd/HP_LaserJet_M1120_MFP.ppd


/usr/lib/cups/backend/usb
lpadmin -p 'HP_LaserJet_M1120_MFP' -v 'usb://HP/LaserJet%20M1120%20MFP?serial=MF326NK&interface=1' -P /etc/cups/ppd/HP_LaserJet_M1120_MFP.ppd
cupsaccept  HP_LaserJet_M1120_MFP
cupsenable   HP_LaserJet_M1120_MFP

```

you also need ghostscript
