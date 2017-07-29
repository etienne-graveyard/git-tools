#!/bin/bash

# Takes one parameter: a remote git repository URL.
# Clone tha repo in the correct folder


if [ "$1" = "" ]
then
  echo -e "Usage: bash $0 <git repositiry clone URL>" 1>&2
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
echo -e " ➜ git clone $GITURL $FOLDERNAME"
git clone --recursive $GITURL $FOLDERNAME

# onpen in VSCode
code-insiders $FOLDERNAME