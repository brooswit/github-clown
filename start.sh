#!/bin/bash
USER=brooswit
FREQUENCY=60

pushd . > /dev/null
mkdir repositories > /dev/null
cd repositories > /dev/null
curl -s https://api.github.com/users/$USER/repos?per_page=200 | grep \"clone_url\" | awk '{print $2}' | sed -e 's/"//g' -e 's/,//g' | xargs -n1 git clone

for D in `find . -type d`
do
    pushd . > /dev/null
    cd $D > /dev/null
    UPSTREAM=${1:-'@{u}'}
    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse "$UPSTREAM")
    BASE=$(git merge-base @ "$UPSTREAM")

    if [ $LOCAL = $REMOTE ]; then
        echo "$(pwd) Up-to-date"
    elif [ $LOCAL = $BASE ]; then
        echo "$(pwd) Need to pull"
        git pull
        bash clown.sh
    elif [ $REMOTE = $BASE ]; then
        echo "$(pwd) Need to push"
    else
        echo "$(pwd) Diverged"
    fi
    popd > /dev/null
done
popd > /dev/null

sleep $FREQUENCY
git pull
bash start.sh
