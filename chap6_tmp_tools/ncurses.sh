# Use gawk (MUST be available in PATH)
sed -i s/mawk// configure

mkdir build
pushd build
 ../configure
 make -C include
 make -C progs tic
popd

./configure --prefix=/usr \
 --host=$LFS_TGT \
 --build=$(./config.guess) \
 --mandir=/usr/share/man \
 --with-manpage-format=normal \
 --with-shared \
 --without-debug \
 --without-ada \
 --without-normal \
 --enable-widec     # This switch causes wide-character libraries (e.g., libncursesw.so.6.2) to be built instead of normal ones
                    #(e.g., libncurses.so.6.2). These wide-character libraries are usable in both multibyte and traditional 8-bit
                    #locales, while normal libraries work properly only in 8-bit locales. Wide-character and normal libraries are sourcecompatible, but not binary-compatible.

make -j$(nproc)

make DESTDIR=$LFS TIC_PATH=$(pwd)/build/progs/tic install
echo "INPUT(-lncursesw)" > $LFS/usr/lib/libncurses.so

mv -v $LFS/usr/lib/libncursesw.so.6* $LFS/lib
