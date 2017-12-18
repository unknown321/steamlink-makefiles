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
