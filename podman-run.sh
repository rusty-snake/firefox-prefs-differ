#!/bin/bash

firefox_version="$1"
if [[ -z "$firefox_version" ]]; then
	printf 'USAGE: %s <FIREFOX-VERSION>\n' "$0"
	exit 1
fi

podman_run_args=(
	--init
	--log-driver=none
	--security-opt label=disable
	--userns "keep-id:uid=1000,gid=1000"
	--tmpfs "/home/firefoxuser:mode=1777"
	--tmpfs "/run/user/1000:mode=1777"
	-v "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:/run/user/1000/wayland-0:ro"
	--env "XDG_RUNTIME_DIR=/run/user/1000"
	--env "WAYLAND_DISPLAY=wayland-0"
	-v "$PWD/firefox-$firefox_version:/opt/mozilla/firefox:ro"
	--network=none
	--cap-drop=all
	--security-opt no-new-privileges
	--read-only
	--pull=never
)
podman run --rm "${podman_run_args[@]}" firefox-prefs-differ /opt/mozilla/firefox/firefox -P default-release about:config

# Alternative command if podman is not an option for you:
#bwrap_args=(
#	--cap-drop all
#	--unshare-net
#	--ro-bind /usr /usr
#	--symlink usr/bin /bin
#	--symlink usr/lib /lib
#	--symlink usr/lib64 /lib64
#	--symlink usr/sbin /sbin
#	--ro-bind /etc /etc
#	--ro-bind /run /run
#	--dir /tmp
#	--proc /proc
#	--dev /dev
#	--ro-bind "$PWD/firefox-$firefox_version" /opt/mozilla/firefox
#	--dir "$HOME"
#)
#bwrap "${bwrap_args[@]}" /opt/mozilla/firefox/firefox about:config
