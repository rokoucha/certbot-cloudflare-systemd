#!/bin/sh

# Argument check
if [ $# -ne 1 ]; then
    echo "Argument error" 1>&2
    exit 1
fi

IMAGE_NAME_WITH_VERSION=$IMAGE_NAME:v$CERTBOT_VERSION

# Is docker image exist?
docker inspect --type=image $IMAGE_NAME_WITH_VERSION > /dev/null 2>&1
if [ 0 -ne $? ]; then
    docker build -t $IMAGE_NAME --build-arg CERTBOT_VERSION=$CERTBOT_VERSION .
    docker tag $IMAGE_NAME $IMAGE_NAME_WITH_VERSION
fi

if [ -e $(pwd)/config/live/$1 ]; then
    docker run \
	--mount type=bind,src=$(pwd)/config,dst=/workspace/config \
        --mount type=bind,src=$(pwd)/logs,dst=/workspace/logs \
        --mount type=bind,src=$(pwd)/cloudflare-credentials.ini,dst=/workspace/cloudflare-credentials.ini \
        -i --rm \
        --user "$(id --user):$(id --group)" \
        $IMAGE_NAME \
            --config-dir /workspace/config \
            --logs-dir /workspace/logs \
            --work-dir /tmp \
            --non-interactive \
            --agree-tos --email $CERTBOT_EMAIL\
            renew \
	        --dns-cloudflare \
                --dns-cloudflare-credentials /workspace/cloudflare-credentials.ini
else
    docker run \
	--mount type=bind,src=$(pwd)/config,dst=/workspace/config \
        --mount type=bind,src=$(pwd)/logs,dst=/workspace/logs \
        --mount type=bind,src=$(pwd)/cloudflare-credentials.ini,dst=/workspace/cloudflare-credentials.ini \
        -i --rm \
        --user "$(id --user):$(id --group)" \
        $IMAGE_NAME \
            --config-dir /workspace/config \
            --logs-dir /workspace/logs \
            --work-dir /tmp \
            --non-interactive \
            --agree-tos --email $CERTBOT_EMAIL\
            certonly \
                --dns-cloudflare \
                --dns-cloudflare-credentials /workspace/cloudflare-credentials.ini \
		--domain $1 \
                --domain *.$1
fi
