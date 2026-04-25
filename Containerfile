FROM fedora:43

RUN <<END
dnf -y upgrade
dnf -y install gtk3
dnf -y clean all

useradd -u 1000 firefoxuser
mkdir -p /home/firefoxuser/.mozilla/firefox/default-release
cat >/home/firefoxuser/.mozilla/firefox/profiles.ini <<EOF
[General]
StartWithLastProfile=1

[Profile0]
Name=default-release
IsRelative=1
Path=default-release
Default=1
EOF
cat >/home/firefoxuser/.mozilla/firefox/default-release/prefs.js <<EOF
user_pref("devtools.selfxss.count", 5);
EOF
chown -R 1000:1000 /home/firefoxuser
END
