# Libstdc++ - Pass 1
cd $LFS/sources/gcc-10.2.0 || exit 1
pushd build
rm -rf *	# Removing previous build files

../libstdc++-v3/configure --host=$LFS_TGT \
	--build=$(../config.guess) \
	--prefix=/usr \
	--disable-multilib \
	--disable-nls \
	--disable-libstdcxx-pch \
	--with-gxx-include-dir=/tools/$LFS_TGT/include/c++/10.2.0

make

make DESTDIR=$LFS install

cleanup()
