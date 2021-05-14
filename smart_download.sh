# TODO- Add support for incompletely downloaded files, by veryfing the MD5 hash

echo "LFS is "$LFS

if [ "${LFS}" != "" ]
then
export source_directory=$LFS"/sources/"
else
export source_directory="sources/"
fi

echo "Source directory is "$source_directory

# This function takes the download url for a package as argument
# Then, it extracts the filename from download url, storing it in `name`
# Then, it checks if a file with that name exists in the source_directory
# If exists, then skip
# Else download the file
fn() {
    url=$1
    name=$(echo ${url} | rev | awk -F '/' '{print $1}' | rev)

    if [ -e $source_directory$name ]
    then
        # This has one problem: There maybe an incomplete file existing
        echo $source_directory$name" exists"
    else
        echo "Downloading "$source_directory$name
        wget --continue $url -P $source_directory -q --show-progress || exit 1
    fi

    # echo $name
}

export -f fn
mkdir -pv $source_directory     # create the source directory if doesn't exist yet (wget would automatically create either way)

# This line first extracts all download urls from lfs_packages.txt, then executes `fn` parallely for each download url
# The `sed 's/\r$//'` part removes line feeds, that may be there, if you created the txt file on Windows
awk '/Download: / {print $2}' lfs_packages.txt | sed 's/\r$//' | xargs -P 0 -I {} bash -c 'fn "$@"' _ {}

echo ""
echo "Downloads Completed... Verifying MD5 Hashes"

curr_path=$(pwd)
pushd $LFS/sources
    md5sum -c $curr_path"/md5sums.txt"
popd

unset source_directory
unset fn
