FROM debian:trixie-slim AS driver
ADD --checksum=sha256:e9025a68006e6c46844692717d51b182107cc886f6a4269067af95a2a8e662b9 \
    https://gdlp01.c-wss.com/gds/8/0100007658/47/linux-UFRII-drv-v620-m17n-20.tar.gz /driver.tar.gz
RUN tar xzf /driver.tar.gz && dpkg-deb -x linux-UFRII-drv-v620-m17n/x64/Debian/*.deb /out # unpacked, not installed: the .deb pulls in GTK for GUI tools we don't use

FROM debian:trixie-slim
RUN apt-get update \
 && apt-get install -y --no-install-recommends cups libcupsimage2t64 libxml2 libjbig0 libjpeg62-turbo \
 && rm -rf /var/lib/apt/lists/*
COPY --from=driver /out/ /
RUN ldconfig && sed -i 's|^ErrorLog .*|ErrorLog stderr|' /etc/cups/cups-files.conf
COPY start.sh /
CMD ["/start.sh"]
