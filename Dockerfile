FROM haproxy:1.6.1

RUN apt-get -qq -y update \
 && apt-get -qq -y install sudo iptables procps vim curl \
 && curl -L https://github.com/kelseyhightower/confd/releases/download/v0.10.0/confd-0.10.0-linux-amd64 -o /usr/local/bin/confd \
 && chmod +x /usr/local/bin/confd \
 && mkdir -p /etc/confd/conf.d \
 && mkdir -p /etc/confd/templates

COPY haproxy.toml /etc/confd/conf.d/
COPY haproxy.tmpl /etc/confd/templates/
COPY haproxy.cfg.INIT /usr/local/etc/haproxy/haproxy.cfg

COPY device.pem /etc/ssl/certs/

COPY confd-watch /usr/local/bin/
RUN chmod +x /usr/local/bin/confd-watch

EXPOSE 80 443 1936

CMD ["/usr/local/bin/confd-watch"]
