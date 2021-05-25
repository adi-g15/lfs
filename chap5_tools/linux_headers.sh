# Linux Headers

x_n_m("linux")

# Make sure no stale files embedded in package
make mrproper

make headers
find usr/include -name '.*' -delete
rm usr/include/Makefile
cp -rv usr/include $LFS/usr

cleanup()
