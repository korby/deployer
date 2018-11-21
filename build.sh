#!/bin/sh
cwd=`pwd`
mkdir -p debian_package/usr/share/deployer/
cp deployer.sh debian_package/usr/share/deployer/
cp -R lib debian_package/usr/share/deployer/
cp -R tasks-common debian_package/usr/share/deployer/
cp -R tasks-native debian_package/usr/share/deployer/
cd debian_package/usr/bin/;
ln -s ../share/deployer/deployer.sh deployer
chmod +x deployer;
cd $cwd;
dpkg --build debian_package deployer.deb

rm -rf debian_package/usr/share/deployer/*
rm debian_package/usr/bin/*
