# Binutils
x_n_m("binutils")

mkdir build
pushd    build

../configure --prefix=$LFS/tools --with-sysroot=$LFS --target=$LFS_TGT --disable-nls --disable-werror

make
make install

popd

cleanup()
