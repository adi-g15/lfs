if [ "${LFS}" = "" ]
then
	echo "LFS variable not set !!"
	exit
fi

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

# Creating the .bash_profile for lfs user
cat > ~/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1="\[\033[44m\][\u \[\033[01;37m\] \W\[\033[44m\]]\$\[\033[00m\] " /bin/bash
EOF

# The last part in the .bash_profile (executed when created a login shell), ie. '/bin/bash' creates a new instance of the bash shell, which is a non-login shell, so it now goes on to execute another script (.bashrc)

# In a non-login shell, it exectues .bashrc

cat > ~/.bashrc << "EOF"
set +h
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
MAKEFLAGS='-j8'	# could have added to .bash_profile too, though added this, since it is run for BOTH login and non login according to our config
PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/binL$PATH; fi
PATH=$LFS/tools/bin:$PATH
CONFIG_SITE=$LFS/usr/share/config.site
export LFS LC_ALL LFS_TGT PATH CONFIG_SITE
EOF

# We don't want this initialisation to be used, as it may pollute our environment
[ ! -e /etc/bash.bashrc ] || sudo mv -v /etc/bash.bashrc /etc/bash.bashrc.NOUSE

source ~/.bash_profile

