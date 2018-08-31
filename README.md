# sparklyr-dev
A Docker image to build sparklyr's JARs.

```sh
cd /path/to/sparklyr.git
docker run \
  --mount "type=bind,source=$(pwd),target=/root/sparklyr" \
  --rm -it \
  yutannihilation/sparklyr-dev \
  ./configure.R
```
