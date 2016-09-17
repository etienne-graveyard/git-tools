#!/bin/bash

# Takes one parameter: a remote git repository URL.
#
# This is the stuff this script does:
#
# 1. Clones the repository
# 2. Fetches all remote branches
# 3. Compresses the folder
# 4. Deletes the cloned folder.
#
# Your remote repository is left untouched by this script.


if [ "$1" = "" ]
then
  echo -e "\e[33mUsage: bash $0 <git repositiry clone URL>\e[39m" 1>&2
  exit 1
fi

# Variable definitions
GITURL=$1
GITNAME=${GITURL##*/}
GIT=${GITURL#*@}
PLATFORM=${GIT%:*}
USERREPO=${GIT#*:}
USERREPO=${USERREPO%.git}
USER=${USERREPO%/*}
REPO=${USERREPO#*/}

FOLDERNAME=${GITNAME%.git}
TARNAME="$(date +%Y%m%d)/${PLATFORM}/${USER}/${REPO}.tgz"

# create folder
mkdir -p "$(date +%Y%m%d)/${PLATFORM}/${USER}"

# Set chmod
sudo chmod -R 777 .

# If file exist, exit
if [ -e "./$TARNAME" ]
then
  echo -e "\e[94m➼ $TARNAME already exist.\e[39m"
  exit 1
else
  echo -e "\e[95m➼ Start backup of \e[92m$GITNAME\e[39m"
fi

# Clone the repos and go into the folder
echo -e "\e[90m ➜ git clone --recursive $GITURL $FOLDERNAME\e[39m"
git clone --recursive $GITURL $FOLDERNAME

# If folder not exist, exit
if [ -e "./$FOLDERNAME" ]
then
  cd $FOLDERNAME
else
  echo -e "\e[31m➼ ***************************************************\e[39m"
  echo -e "\e[31m➼ $FOLDERNAME does not exist, clone probably failed !\e[39m"
  echo -e "\e[31m➼ ***************************************************\e[39m"
  exit 1
fi

# Pull all branches
git branch -r | grep -v HEAD | grep -v master | while read branch; do
  git branch --track ${branch##*/} $branch
done

#Pull all remote data and tags
git fetch --all
git fetch --tags
git pull --all
git gc # Cleanup unnecessary files and optimize the local repository

# Create an archive of the directory
cd ../
tar cfz "$TARNAME" "$FOLDERNAME/"

# Remove the git clone
rm -rf "./$FOLDERNAME"

echo -e "\e[95mYour archived git repository is named \e[92m$TARNAME\e[39m"
echo -e "\e[95m➼ Done!\e[39m"
