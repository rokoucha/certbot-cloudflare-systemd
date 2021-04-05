FROM certbot/dns-cloudflare:v1.13.0

VOLUME [ "/opt/certbot/config", "/opt/certbot/logs" ]

WORKDIR /opt/certbot

COPY getcert.sh /opt/certbot

ENTRYPOINT ["/bin/sh", "/opt/certbot/getcert.sh"]
