FROM debian:12 AS build
RUN apt-get update
RUN apt-get install -y gcc libssl-dev zlib1g-dev git ca-certificates make wget tar
WORKDIR /srv/compilation
RUN wget https://github.com/rbsec/sslscan/archive/refs/tags/2.1.3.tar.gz
RUN tar fx 2.1.3.tar.gz
WORKDIR /srv/compilation/sslscan-2.1.3
RUN make static

FROM scratch
COPY --from=build /lib/x86_64-linux-gnu/libz.so.1 /lib/x86_64-linux-gnu/libz.so.1
COPY --from=build /lib/x86_64-linux-gnu/libc.so.6 /lib/x86_64-linux-gnu/libc.so.6
COPY --from=build /lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2
COPY --from=build /srv/compilation/sslscan-2.1.3/sslscan /usr/local/bin/sslscan
ENTRYPOINT ["/usr/local/bin/sslscan"]
CMD ["-h"]
