# install once
# sudo apt update
# sudo apt install whois

echo "Enter ROOT password:"
read ROOTPASS
echo ""

echo "Enter USER password:"
read USERPASS
echo ""

echo "Enter HOSTNAME:"
read HOSTNM

# remove Chromium package install
sed -i 's/\bchromium-l10n\b//g; s/\bchromium\b//g; s/  */ /g; s/ $//' preseed.cfg


# remove Chromium autostart
sed -i 's|chromium --kiosk --temp-profile --noerrdialogs --enable-features=OverlayScrollbar --disable-restore-session-state https://linuxguides.de|# chromium --kiosk --temp-profile --noerrdialogs --enable-features=OverlayScrollbar --disable-restore-session-state https://linuxguides.de|' deb/usr/lib/minimal-os/openbox/autostart


# gui autostart
echo "\nexec openbox-session" >> deb/usr/lib/minimal-os/openbox/autostart



# add docker und nvidia
# sed -i '/pkgsel\/include/ s/$/ docker.io docker-compose-plugin containerd runc nvidia-container-toolkit nvidia-container-runtime/' preseed.cfg


# docker
sed -i '/pkgsel\/include/ s/$/ docker.io docker-compose-plugin containerd runc nvidia-container-toolkit nvidia-container-runtime libnvidia-container1 libnvidia-container-tools/' preseed.cfg

# hostname
#sed -i '/d-i netcfg\/hostname/ s/ .*/ $HOSTNM/' preseed.cfg
sed -i "/netcfg\/hostname/ s/.*/d-i netcfg\/hostname string $HOSTNM/" preseed.cfg

# passwd
USERHASH=$(echo "$USERPASS" | mkpasswd -s -m sha-512)
ROOTHASH=$(echo "$ROOTPASS" | mkpasswd -s -m sha-512)
sed -i '/passwd\/user-password/d' preseed.cfg
sed -i '/passwd\/root-password/d' preseed.cfg
echo "\nd-i passwd/user-password-crypted password $USERHASH" >> preseed.cfg
echo "\nd-i passwd/root-password-crypted password $ROOTHASH" >> preseed.cfg


cat <<EOF > install-summary.txt
=== OS INSTALL SUMMARY ===

Hostname:
$HOSTNM

User Password: 
$USERPASS

User password hash:
$USERHASH

Root Password:
$ROOTPASS

Root password hash:
$ROOTHASH

Generated at:
$(date)

=================================
EOF
