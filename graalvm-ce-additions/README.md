## graalvm-ce-additions

Official GraalVM image w/ the following additions
* `native-image`

### Usage Example

In a multistage build, you can use this image as an intermediate step to build a native image.

Example:
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