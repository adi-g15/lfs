# Cross-compiling TEMPORARY TOOLS, these will be used in the chroot environment

# M4
x_n_c("m4")

sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' lib/*.c
echo "#define _IO_IN_BACKUP 0x100" >> lib/stdio-impl.h

./configure --prefix=/usr \
	--host=$LFS_TGT \
	--build=$(build-aux/config.guess)

make

make DESTDIR=$LFS install

cleanup()

# NCurses
x_n_c("ncurses")

sed -i 's/mawk//' configure

mkdir -v build
pushd build
	# Build `tic` program
	../configure
	make -C include
	make -C progs tic
popd

# Preparing NCurses for compilation
./configure --prefix=/usr \
	--host=$LFS_TGT \
	--build=$(./config.guess) \
	--mandir=/usr/share/man \
	--with-manpage-format=normal \
	--with-shared \
	--without-debug \
	--without-ada \
	--without-normal \
	--enable-widec

make
make DESTDIR=$LFS TIC_PATH=$(pwd)/build/progs/tic install
echo "INPUT(-lncursesw)" > $LFS/usr/lib/libncurses.so

mv -v $LFS/usr/lib/libncursesw.so.6* $LFS/lib

ln -sfv ../../lib/$(readlink $LFS/usr/lib/libncursesw.so) $LFS/usr/lib/libncursesw.so

# bash

x_n_c("bash")

./configure --prefix=/usr \
	--build=$(support/config.guess) \
	--host=$LFS_TGT \
	--without-bash-malloc

make
make DESTDIR=$LFS install

mv $LFS/usr/bin/bash $LFS/bin/bash

ln -sv bash $LFS/bin/sh

cleanup()

# Coreutils

x_n_c("coreutils")

./configure --prefix=/usr \
	--host=$LFS_TGT \
	--build=$(build-aux/config.guess) \
	--enable-install-program=hostname \
	--enable-no-install-program=kill,uptime

make

make DESTDIR=$LFS install

cleanup()


mv -v $LFS/usr/bin/{cat,chgrp,chmod,chown,cp,date,dd,df,echo,false,ln,ls,mkdir,mknod,mv,pwd,rm}	$LFS/bin
mv -v $LFS/usr/bin{rmdir,stty,sync,true,uname,head,nice,sleep,touch}				$LFS/bin
mv -v $LFS/usr/bin/chroot	$LFS/usr/sbin

mkdir -pv $LFS/usr/share/man/man8
mv -v $LFS/usr/share/man/man1/chroot.1	$LFS/usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/'			$LFS/usr/share/man/man8/chroot.8



# diffutils

x_n_c("diffutils")

./configure --prefix=/usr --host=$LFS_TGT

make
make DESTDIR=$LFS install

cleanup()


# file

x_n_c("file")

mkdir build
pushd build

	../configure --disable-bzlib \
		--disable-libseccomp \
		--disable-xzlib \
		--disable-zlib

	make
popd

./configure --prefix=/usr --host=$LFS_TGT --build=$(./config.guess)

make FILE_COMPILE=$(pwd)/build/src/file

make DESTDIR=$LFS install

cleanup()


# findutils

x_n_c("findutils")

./configre --prefix=/usr \
	--host=$LFS_TGT \
	--build=$(build-aux/config.guess)

make

make DESTDIR=$LFS install

mv -v $LFS/usr/bin/find $LFS/bin

sed -i 's|find:=${BINDIR}|find:=/bin' $LFS/usr/bin/updatedb


cleanup()


# gawk

x_n_c("gawk")

sed -i 's/extras//' Makefile.in

./configure --prefix=/usr \
	--host=$LFS_TGT \
	--build=$(./config.guess)

make

make DESTDIR=$LFS install

cleanup()


# grep

x_n_c("grep")

./configure --prefix=/usr \
	--host=$LFS_TGT \
	--bindir=/bin

make
make DESTDIR=$LFS install

cleanup()


# gzip

x_n_c("gzip")

./configure --prefix=/usr --host=$LFS_TGT

make
make DESTDIR=$LFS install

mv -v $LFS/usr/bin/gzip $LFS/bin

cleanup()


# make

x_n_c("make")

./configure --prefix=/usr --host=$LFS_TGT --without-guile --build=$(build-aux/config.guess)

make
make DESTDIR=$LFS install

cleanup()


# patch

x_n_c("patch")
./configure --prefix=/usr --host=$LFS_TGT --build=$(build-auc/config.guess)

make
make DESTDIR=$LFS install

cleanup()


# sed

x_n_c("sed")

./configure --prefix=/usr --host=$LFS_TGT --bindir=/bin

make
make DESTDIR=$LFS install

cleanup()


# tar

x_n_c("tar")

./configure --prefix=/usr --host=$LFS_TGT --build=$(build-aux/config.guess) --bindir=/bin

make
make DESTDIR=$LFS install

cleanup()


# xz

x_n_c("xz")

./configure --prefix=/usr --host=$LFS_TGT --build=$(build-aux/config.guess) --disable-static --docdir=/usr/share/doc/xz-5.2.5

make
make DESTDIR=$LFS install

cleanup()



mv -v $LFS/usr/bin/{lzma,unlzma,lzcat,xz,unxz,xzcat}	$LFS/bin
mv -v $LFS/usr/lib/liblzma.so.*				$LFS/lib
ln -svf ../../lib/$(readlink $LFS/usr/lib/liblzma.so)	$LFS/usr/lib/liblzma.so




# binutils

x_n_c("binutils")

mkdir -v build
pushd build

../configure --prefix=/usr \
	--build=$(../config.guess) \
	--host=$LFS_TGT \
	--disable-nls \
	--enable-shared \
	--disable-werror \
	--enable-64-bit-bfd

make

make DESTDIR=$LFS install
install -vm755 libctf/.libs/libctf.so.0.0.0 $LFS/usr/lib

popd

cleanup()


# GCC pass 2

x_n_c("gcc")

tar -xf ../mpfr-4.1.0.tar.xz
mv -v mpfr-4.1.0 mpfr
tar -xf ../gmp-6.2.1.tar.xz
mv -v  gmp-6.2.1 gmp
tar -xf ../mpc-1.2.1.tar.gz
mv -v mpc-1.2.1 mpc

case $(uname -m) in
	x86_64)
		sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64
		;;
esac

mkdir -v build
pushd build

mkdir -pv $LFS_TGT/libgcc
ln -s ../../../libgcc/gthr-posix.h $LFS_TGT/libgcc/gthr-default.h
../configure --build=$(../config.guess) \
	--host=$LFS_TGT \
	--prefix=/usr \
	CC_FOR_TARGET=$LFS_TGT-gcc \
	--with-build-sysroot=$LFS \
	--enable-initfini-array \
	--disable-nls \
	--disable-multilib \
	--disable-decimal-float \
	--disable-libatomic \
	--disable-libgomp \
	--disable-libquadmath \
	--disable-libssp \
	--disable-libvtv \
	--disable-libstdcxx \
	--enable-languages=c,c++

make
make DESTDIR=$LFS install

ln -sv gcc $LFS/usr/bin/cc

popd

