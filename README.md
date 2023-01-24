# docker-ghidra-local

## Dependencies

- [eclipse-temurin](https://hub.docker.com/_/eclipse-temurin)

<!-- ## Image Tags

```bash
REPOSITORY               TAG                 SIZE
blacktop/ghidra          latest              1.41GB
``` -->

## Getting Started

### Client

#### On macOS

1. Install XQuartz `brew install xquartz`
2. Install socat `brew install socat`
3. `open -a XQuartz` and make sure you **"Allow connections from network clients"** (in XQuartz > Preferences... > Security)
4. Now add the IP using Xhost with: `xhost + 127.0.0.1` or `xhost + $(ipconfig getifaddr en0)`
5. Start socat `socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"`
6. Start up Ghidra

```console
$ make all
$ make run
```

<!--
```bash
$ docker run --init -it --rm \
             --name ghidra \
             --cpus 2 \
             --memory 4g \
             -e MAXMEM=4G \
             -e DISPLAY=host.docker.internal:0 \
             -v /path/to/samples:/samples \
             -v /path/to/projects:/root \
             blacktop/ghidra
```
-->

<!--
### Headless

```bash
$ docker run --init -it --rm \
             --name ghidra-headless \
             --cpus 2 \
             --memory 4g \
             -e MAXMEM=4G \
             -v `pwd`:/samples \
             --link ghidra-server \
             blacktop/ghidra:beta support/analyzeHeadless ghidra://ghidra-server:13100/Apple/12.4.1/ -import /samples/dyld_shared_cache -connect blacktop -p -commit "Loading Dyld."
```
-->

## Known Issues

### Black Background Issue

If the Ghidra opens in XQuartz with a black background, try closing XQuartz, executing `defaults write org.xquartz.X11 enable_render_extension 0` in terminal. See [issue #31](https://github.com/XQuartz/XQuartz/issues/31) on XQuartz GitHub repo for more information.

### Socat "Address already in use"

Per [this nice blog post](https://bitsanddragons.wordpress.com/2020/06/05/address-already-in-use-socat-not-working-on-osx/), OSX doesn't close byte streams when they stop responding, so ports will stay open. They need to be killed forcibly like so:

```console
$ lsof -n -i | grep 6000
X11.bin   10540 me  12u  IPv6 0xcddXX  0t0  TCP *:6000 (LISTEN)
X11.bin   10540 me  13u  IPv4 0xcddXX  0t0  TCP *:6000 (LISTEN)
$ kill -9 10540
```

## Credits

- NSA Research Directorate [https://github.com/NationalSecurityAgency/ghidra](https://github.com/NationalSecurityAgency/ghidra)
- [blacktop/docker-ghidra](https://github.com/blacktop/docker-ghidra)

### License

Apache License (Version 2.0)
