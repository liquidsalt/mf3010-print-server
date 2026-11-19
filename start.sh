#!/bin/sh
(
  until [ -S /run/cups/cups.sock ]; do sleep 1; done
  cupsctl --share-printers
  until lpstat -p MF3010 >/dev/null 2>&1; do
    uri=$(lpinfo --include-schemes usb -v | grep -o 'usb://Canon/MF3010[^ ]*')
    if [ -n "$uri" ]; then
      lpadmin -p MF3010 -D "Canon MF3010" -E -v "$uri" -m CNRCUPSMF3010ZK.ppd -o printer-is-shared=true
    else
      sleep 10
    fi
  done
) &
exec cupsd -f
