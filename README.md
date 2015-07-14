# docker-haproxy

HAProxy for load balancing and reverse proxy

Based on library/haproxy docker image (HAProxy v.1.5.14) and enriched with sudo, iptables, procps, curl, vim and confd.

Confd automatically syncs between /etc/confd/templates/haproxy.tmpl template and /usr/local/etc/haproxy/haproxy.cfg based on current etcd configuration.
Template resource config is /etc/confd/conf.d/haproxy.toml. /usr/local/bin/confd-watch checks every 10 seconds that template and cfg file are synced and if they don't - run a sync.

HAProxy logs visible via journalctl on CoreOS host.

HAProxy configured to run with zero-downtime during the configuration reload after sync as described on [here] (https://medium.com/@Drew_Stokes/actual-zero-downtime-with-haproxy-18318578fde6)

See also flow.txt file for more details. [Gaia-fleet] (https://github.com/gaia-adm/gaia-fleet) repository contains haproxy.service for deploying the docker.

## Services support
Currently mgs and sts services supported. Two files must be updated, in order to add new service: **haproxy.tmpl** (the same way as you would update regular haproxy.cfg 
but also with what confd needs) and **haproxy.toml** (add skydns keys). Use mgs and sts configuration as the reference.

## SSL termination
HAProxy listen for both ports 80 and 443 to serve http and https traffic accordingly. Default certificate device.pem was issued for skydns.local domain.

See haproxy.tmpl comments if you need to:
- Close http traffic completely
- Redirect flow starting as http to https

In any SSL configuration /stats page is available over http on port 1936 with credentials admin/admin.

## TBD:
- Potential improvements of haproxy.toml (mostly permissions)
- HAProxy configuration (performance) tuning (haproxy.cfg)

