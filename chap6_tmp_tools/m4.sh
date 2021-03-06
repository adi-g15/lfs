# M4

# Fixes introduced by glibc-2.28
sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' lib/*.c
echo "#define _IO_IN_BACKUP 0x100" >> lib/stdio-impl.h

./configure --prefix=/usr \
 --host=$LFS_TGT \
 --build=$(build-aux/config.guess)

make -j$(nproc)

make DESTDIR=$LFS install
