file="./repos.sh"
while read -r line; do
  if [[ "$line" =~ ^#.* ]];
  then
    echo -e "\e[92m$line\e[39m"
  else
    bash ./gitarchive.sh "$line"
  fi
done < $file
