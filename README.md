# steamlink-makefiles

Makefiles for building utilites for steamlink.

You can also get compiled binaries from http://packages.debian.org for 
`armhf` arch if you are feeling lazy.

# howto

I am using docker image debian:stretch-slim (9.1) for building. Sources are also pulled from debian pools.

```docker run -dt debian:stretch-slim```

Get into the container:

```docker run -it `docker ps -q` bash```

Install essentials:

```apt-get update && apt-get install build-essentials g++ python git```

Clone the sdk repo (better build the custom image instead of cloning every time):

```git clone https://github.com/ValveSoftware/steamlink-sdk.git && cd steamlink-sdk```

Add buildfile to the running container and execute it.

# howto2

You can also build on steamlink itself. Get a `make` package 
from https://packages.debian.org/stretch/make (building is hard), put it to ```/home/steam/bin```
on steamlink. 

Get 16+ Gb ext4 flashdrive (or nfs share), 
```git clone https://github.com/ValveSoftware/steamlink-sdk.git``` to the drive.

Mount the drive:

```
mkdir /home/steam/flashdrive
mount -t ext4 /dev/block/sda /home/steamlink/flashdrive
cd /home/steamlink/flashdrive/steamlink-sdk/examples
```

Build whatever example you want.

# bash

bash 4.4, debian 9.1 version
