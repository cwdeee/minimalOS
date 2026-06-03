sudo apt install syslinux-utils genisoimage
bash create-deb.sh

bash download-debian-amd64.sh

sudo apt install cpio
chmod -R u+rwX,go+rX deb

sudo apt install dpkg-dev

mkdir NEWISO
sudo chmod -R u+w NEWISO
sudo bash build.sh amd
