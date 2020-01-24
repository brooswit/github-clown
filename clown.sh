touch ./.clown.json
count = $(cat ./.clown.json | jq .count)
if count == null then
    count = 0
done
count = $count + 1
echo '{"count":${count}' > ./.clown.json
echo Honk honk! Clown ran ${count} times!
