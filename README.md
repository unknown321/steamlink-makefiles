# steamlink-makefiles

Makefiles for building utilites for steamlink.

You can also get compiled binaries from http://packages.debian.org for 
`armhf` arch if you are feeling lazy.

# Requrements

Debian-like system, I am using debian 9.

# HOWTO

```
apt-get update && apt-get install build-essentials g++ python git
git clone https://github.com/ValveSoftware/steamlink-sdk.git && cd steamlink-sdk
```

Copy whatever catches your eye from this repo into `examples` directory.

## bash

bash 4.4, debian 9.1 version

## cups

cups 2.2.6, see [README.md](cups/README.md) - a lot of dependencies

# Notes

### Why?

Why not archlinux (https://github.com/lukas2511/steamlink-sdk) ?

Because I don't like arch, that's it. Also this is a nice way to practice building stuff from source.
