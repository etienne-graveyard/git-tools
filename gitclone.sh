#!/bin/bash

# Takes one parameter: a remote git repository URL.
# Clone tha repo in the correct folder


if [ "$1" = "" ]
then
  echo -e "\e[33mUsage: bash $0 <git repositiry clone URL>\e[39m" 1>&2
  exit 1
fi


# Variable definitions
BASEPATH="~/Workspace"
GITURL=$1
GITNAME=${GITURL##*/}
GIT=${GITURL#*@}
PLATFORM=${GIT%:*}
USERREPO=${GIT#*:}
USERREPO=${USERREPO%.git}
USER=${USERREPO%/*}
REPO=${USERREPO#*/}

FOLDER="${BASEPATH}/${PLATFORM}/${USER}"
FOLDERNAME="${FOLDER}/${REPO}"

# create folder
mkdir -p ${FOLDER}

# Clone the repos and go into the folder
echo -e "\e[90m ➜ git clone $GITURL $FOLDERNAME\e[39m"
git clone --recursive $GITURL $FOLDERNAME

# onpen in VSCode
code-insiders $FOLDERNAME