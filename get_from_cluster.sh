#!/bin/bash

# Set ENV variables
DATAPATH=$(head -n 1 _datapath_.txt)
PROJECTSPATH=$(head -n 1 _projectspath_.txt)

my_name=$(head -n 1 _username_.txt)
password=$(head -n 1 _password_.txt)
project=$1
if [ -z "$2" ]
then
  savepath="outfiles"
else
  savepath=$2
fi

echo "Copying $project outfiles..."

directories=$(sshpass -p "$password" ssh "$my_name@agave.asu.edu" ls .)

for directory in $directories
do
  if [[ $directory = $project* ]]
  then
    echo "$directory"
    path_agave="$my_name@agave.asu.edu:/home/$my_name/$directory/$savepath/*"
    path_local="$PROJECTSPATH$project/$savepath/."
    sshpass -p "$password" rsync -rv "$path_agave" "$path_local"
  fi
done
