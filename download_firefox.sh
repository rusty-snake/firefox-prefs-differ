#!/bin/bash

set -e

FIREFOX_VERSION="$1"
FIREFOX_URL="https://releases.mozilla.org/pub/firefox/releases/$FIREFOX_VERSION/linux-x86_64/en-US/firefox-$FIREFOX_VERSION.tar.xz"

if [[ -z "$FIREFOX_VERSION" ]]; then
	printf 'USAGE: %s <FIREFOX-VERSION>\n' "$0"
	exit 1
fi

if command -v curl; then
	curl --tlsv1.3 --proto '=https' -L -O "$FIREFOX_URL"
elif command -v wget; then
	wget --secure-protocol=TLSv1_3 --https-enforce=hard "$FIREFOX_URL" 
else
	printf 'Please install curl or wget.\n'
	exit 1
fi

tar -xvf "firefox-$FIREFOX_VERSION.tar.xz"
mv "firefox" "firefox-$FIREFOX_VERSION"
touch "firefox-$FIREFOX_VERSION/.nobackup"
