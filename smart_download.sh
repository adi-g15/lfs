export source_directory="./"

fn() {
    url=$1
    name=$(echo ${url} | rev | awk -F '/' '{print $1}' | rev)

    if [ -e $source_directory$name ]
    then
        # This has one problem: THere maybe an incomplete file existing
        echo $source_directory$name" exists"
    else
        echo "Downloading "$source_directory$name
        wget --continue $url -P $source_directory -q
    fi

    # echo $name
}

export -f fn
awk '{print}' urls.txt | xargs -P 0 -I {} bash -c 'fn "$@"' _ {}

unset source_directory
