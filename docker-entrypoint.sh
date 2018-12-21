#!/bin/sh

chroot /32bit /usr/local/bin/trafr -s | suricata -c /etc/suricata/suricata.yaml -r -
