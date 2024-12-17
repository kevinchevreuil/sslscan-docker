FROM debian:12 AS build
RUN apt-get update && apt-get install -y gcc libssl-dev zlib1g-dev git ca-certificates make wget tar
WORKDIR /srv/compilation
RUN wget https://github.com/rbsec/sslscan/archive/refs/tags/2.1.3.tar.gz && tar fx 2.1.3.tar.gz
WORKDIR /srv/compilation/sslscan-2.1.3
RUN make static

FROM debian:12
COPY --from=build /srv/compilation/sslscan-2.1.3/sslscan /usr/local/bin/sslscan
ENTRYPOINT ["/usr/local/bin/sslscan"]
CMD ["-h"]
