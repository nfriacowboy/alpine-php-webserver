#!/usr/bin/env sh
apk --no-cache add curl
body="$(curl --silent --fail http://app:8080)"
echo "$body" | grep 'PHP 8.4'
# The app serves phpinfo(); extract "PHP Version X.Y.Z" from the HTTP body and
# fail if it is below the patched version, so the check runs against the app image,
# not against this (sut) container which has no PHP installed.
php_version="$(printf '%s\n' "$body" | sed -n 's/.*PHP Version \([0-9.]\+\).*/\1/p' | head -n1)"
[ -n "$php_version" ] || {
	echo "could not find PHP version in the page" >&2
	exit 1
}
echo "PHP version detected: $php_version"
if [ "$(printf '%s\n%s\n' "$php_version" "8.4.27" | sort -V | head -n1)" != "8.4.27" ]; then
	echo "PHP $php_version is below 8.4.27" >&2
	exit 1
fi
