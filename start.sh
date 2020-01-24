#!/bin/bash
USER=brooswit
FREQUENCY=60

while true
do
    pushd
    mkdir repositories
    cd repositories
    curl -s https://api.github.com/users/$USER/repos?per_page=200 | grep \"clone_url\" | awk '{print $2}' | sed -e 's/"//g' -e 's/,//g' | xargs -n1 git clone

    for D in `find . -type d`
    do
        pushd .
        cd $d
        bash clown.sh
        popd
    done
    popd

    sleep $FREQUENCY
done
