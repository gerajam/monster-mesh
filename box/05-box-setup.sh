cd `dirname $0`

echo " building monster-mesh.img from default raspbian img "

ssh-keygen -f "$HOME/.ssh/known_hosts" -R [localhost]:5522
cat ~/.ssh/id_rsa.pub | sshpass -p raspberry ssh -oStrictHostKeyChecking=no -p 5522 pi@localhost " mkdir -p .ssh ; cat >> .ssh/authorized_keys "

echo " apply final resize of partition "
./ssh " sudo resize2fs /dev/sda2 "

echo " updating apt info and sites "
./ssh " sudo apt-get -y update "
./ssh " sudo apt-get -y upgrade "

echo " installing lots of packages we will need later "
./ssh " sudo apt-get -y install aptitude sudo nano byobu git gcc build-essential cmake pkg-config libnl-genl-3-dev wireless-tools firmware-ralink kbd raspi-config lynx curl traceroute dbus consolekit input-utils wavemon dstat"

echo " remove some things that we really don't want to write to the sd card all the time "
./ssh " sudo apt-get -y remove --purge triggerhappy logrotate dbus dphys-swapfile "
./ssh " sudo apt-get -y autoremove --purge "

echo " replace log system "
./ssh " sudo apt-get -y install busybox-syslogd; sudo dpkg --purge rsyslog "

#systemd has removed this...
#echo " setting up KBD to disable screen blank "
#./ssh " sudo sed -i -e 's/getty 38400 tty1/getty --noclear 38400 tty1/g' /etc/inittab "

echo " preparing to build "
./ssh " sudo apt-get -y install git gcc build-essential cmake pkg-config libnl-genl-3-dev "

# this takes a couple of hours, maybe we can skip it now...
#echo " clone build install a newer version of cmake as the repo is out of date"
#./ssh " git clone git://cmake.org/cmake.git && cd cmake && cmake . && make && sudo make install "

#echo " clone build install olsrd2 "
#./ssh " git clone git://olsr.org/oonf.git && cd oonf/build && cmake -D OONF_NO_WERROR=true .. && make && sudo make install "


