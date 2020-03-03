FROM alpine:3.11

RUN apk add abuild
# abuild requirements
RUN apk add build-base expat-dev openssl-dev zlib-dev ncurses-dev bzip2-dev xz-dev sqlite-dev libffi-dev tcl-dev linux-headers gdbm-dev readline-dev bluez-dev

WORKDIR /aports/community/openjdk8
COPY APKBUILD APKBUILD
COPY fix-paxmark.patch fix-paxmark.patch
COPY icedtea* ./

# add user for build
RUN adduser -S abuild -G abuild sudo
RUN chown -R abuild /aports/community/openjdk8
USER abuild

# build
RUN abuild-keygen -a -n
RUN abuild -r

# test
USER root
RUN apk add --allow-untrusted /home/abuild/packages/community/x86_64/openjdk8-jre-lib-8.232.09-r0.apk
RUN apk add --allow-untrusted /home/abuild/packages/community/x86_64/openjdk8-8.232.09-r0.apk
