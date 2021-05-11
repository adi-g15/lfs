#  Creating a limited directory layout in LFS filesystem
mkdir -pv $LFS/{bin,etc,lib,sbin,usr,var}
case $(uname -m) in
    x86_64) mkdir -pv $LFS/lib64 ;;
esac

# Programs in Chapter 6 will be compiled with a cross-compiler (more details in section Toolchain Technical Notes).
# In order to separate this cross-compiler from the other programs, it will be installed in a special directory. Create this
# directory with:
mkdir -pv $LFS/tools

# ADDING THE `lfs` user

groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs

# To log in as lfs (as opposed to switching to user lfs when logged in as root, which does not require the lfs user
# to have a password), give lfs a password:
passwd lfs

chown -v lfs $LFS/{usr,lib,var,etc,bin,sbin,tools,sources}
case $(uname -m) in
    x86_64) chown -v lfs $LFS/lib64 ;;
esac

su - lfs

cat > ~/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1=
EOF
