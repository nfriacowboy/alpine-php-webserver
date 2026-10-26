#!/usr/bin/env sh
apk --no-cache add curl
curl --silent --fail http://app:8080 | grep 'PHP 8.4'
apk version -t "$(apk info brotli-libs | sed -n 's/^brotli-libs-//p' | cut -d' ' -f1 | head -1)" 1.2.1-r0
php84 -r 'exit(version_compare(PHP_VERSION, "8.4.27", "<") ? 1 : 0);'
