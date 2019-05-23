[![graalvm-ce-additions - Stars](https://img.shields.io/docker/stars/wernerw/graalvm-ce-additions.svg)](https://hub.docker.com/r/wernerw/graalvm-ce-additions/)
[![graalvm-ce-additions - Pulls](https://img.shields.io/docker/pulls/wernerw/graalvm-ce-additions.svg)](https://hub.docker.com/r/wernerw/graalvm-ce-additions/)
[![graalvm-ce-additions - Size](https://img.shields.io/microbadger/image-size/wernerw/graalvm-ce-additions.svg)](https://microbadger.com/images/wernerw/graalvm-ce-additions)
[![graalvm-ce-additions - Layers](https://img.shields.io/microbadger/layers/wernerw/graalvm-ce-additions.svg)](https://microbadger.com/images/wernerw/graalvm-ce-additions)

## graalvm-ce-additions

Official GraalVM image w/ the following additions
* `native-image`

### Usage Example

In a multistage build, you can use this image as an intermediate step to build a native image.

Example `Dockerfile`:
```
# Stage 1: Build application jar
FROM gradle:5.4.1-jdk11-slim as builder
RUN gradle assemble

# Stage 2: Build native GraalVM image
FROM wernerw/graalvm-ce-additions:latest as imager
COPY --from=builder app.jar /app.jar
RUN native-image --no-server -cp /app.jar

# Stage 3: The actual application container
FROM frolvlad/alpine-glibc
COPY --from=imager /app /app
ENTRYPOINT ["/app"]
```