#!/bin/sh

if [ $# -ne 1 ]; then
    echo "Argument error" 1>&2
    exit 1
fi

echo "$CLOUDFLARE_CREDENTIALS_CONFIG" > ./cloudflare-credentials.ini

if [ -e "./config/live/$1" ]; then
    certbot \
        --agree-tos \
        --config-dir ./config \
        --dns-cloudflare \
        --dns-cloudflare-credentials ./cloudflare-credentials.ini \
        --email "$CERTBOT_EMAIL" \
        --logs-dir ./logs \
        --non-interactive \
        --work-dir ./ \
        renew
else
    certbot \
        --agree-tos \
        --config-dir ./config \
        --dns-cloudflare \
        --dns-cloudflare-credentials ./cloudflare-credentials.ini \
        --email "$CERTBOT_EMAIL"\
        --logs-dir ./logs \
        --non-interactive \
        --work-dir ./ \
        certonly \
            --domain "$1" \
            --domain "*.$1"
fi
