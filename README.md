# steamlink-makefiles

Makefiles for building utilites for steamlink

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

# bash

bash 4.4, debian 9.1 version
