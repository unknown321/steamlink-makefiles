# ghostscript

needed to render your text/pdf/whatever so you can print it

there is a problem with building: it uses `genarch` utility, which produces headers so you can build ghostscript for your arch

the issue with `genarch`: it is compiled with `/lib/ld-linux-armhf.so.3` as interpreter (`file ghostscript-9.22/obj/aux/genarch`). Since we are using rootfs with dynamic paths, this won't work - path to interpreter is static. Solution - run genarch on steamlink or just make your own arch.h.
