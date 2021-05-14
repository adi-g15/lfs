#!/bin/bash

if [ "${LFS}" = "" ]
then
	echo "LFS variable not set !!"
	exit 1
fi

if [ "${HOME}" != "/home/lfs" ]
then
	echo "Not logged in as lfs user. Make sure to execute 'su - lfs'"
	exit 1
fi

if ! type basename > /dev/null
then
	# It has been used by the extract_n_cd function only, to move to newly extracted directory, modify only that part needed
	echo "'basename' command not found. Please install it"
	exit 1
fi

extract_n_cd() {
	archive_name=$1

	tar -xf $archive_name
	directory_name=
	cd $archive_name
}
