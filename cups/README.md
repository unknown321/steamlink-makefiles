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
