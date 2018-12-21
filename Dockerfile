FROM alpine:latest

RUN apk add --no-cache suricata gzip wget apk-tools-static

ARG chroot_dir 
ENV chroot_dir /32bit

# Exit 0 is to handle weird signature failure
RUN apk.static --arch x86 -X http://dl-cdn.alpinelinux.org/alpine/latest-stable/main -U --allow-untrusted --root ${chroot_dir} --initdb add alpine-base libc6-compat || exit 0
RUN mknod -m 666 ${chroot_dir}/dev/full c 1 7 		&& \
	mknod -m 666 ${chroot_dir}/dev/ptmx c 5 2 	&& \
	mknod -m 644 ${chroot_dir}/dev/random c 1 8	&& \
	mknod -m 644 ${chroot_dir}/dev/urandom c 1 9	&& \
	mknod -m 666 ${chroot_dir}/dev/zero c 1 5	&& \
	mknod -m 666 ${chroot_dir}/dev/tty c 5 0	&& \
	cp /etc/resolv.conf ${chroot_dir}/etc/		&& \
	mkdir -p ${chroot_dir}/root

RUN wget http://www.mikrotik.com/download/trafr.tgz && \
	tar xvfz trafr.tgz && \
	rm trafr.tgz && \
	mv trafr ${chroot_dir}/usr/local/bin/trafr

ADD docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 37008/udp

VOLUME ["/var/log/suricata", "/var/log/suricata"]

CMD [ "/docker-entrypoint.sh" ]
