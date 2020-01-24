#!/bin/bash
USER=brooswit
FREQUENCY=60

pushd .
mkdir repositories
cd repositories
curl -s https://api.github.com/users/$USER/repos?per_page=200 | grep \"clone_url\" | awk '{print $2}' | sed -e 's/"//g' -e 's/,//g' | xargs -n1 git clone

for D in `find . -type d`
do
    pushd .
    cd $D
    UPSTREAM=${1:-'@{u}'}
    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse "$UPSTREAM")
    BASE=$(git merge-base @ "$UPSTREAM")

    if [ $LOCAL = $REMOTE ]; then
        echo "Up-to-date"
    elif [ $LOCAL = $BASE ]; then
        echo "Need to pull"
        git pull
        bash clown.sh
    elif [ $REMOTE = $BASE ]; then
        echo "Need to push"
    else
        echo "Diverged"
    fi
    popd
done
popd

sleep $FREQUENCY
git pull
bash start.sh
