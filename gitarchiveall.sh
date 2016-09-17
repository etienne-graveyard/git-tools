BASEDIR=$(dirname "$0")

file="${BASEDIR}/repos.sh"
while read -r line; do
  if [[ "$line" =~ ^#.* ]];
  then
    echo -e "\e[92m$line\e[39m"
  else
    bash ${BASEDIR}/gitarchive.sh "$line"
  fi
done < $file
