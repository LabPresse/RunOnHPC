#!/bin/bash

# Load variables
my_name=$(head -n 1 _username_.txt)
password=$(head -n 1 _password_.txt)
project=$1
if [ -z "$2" ]
then
  savepath="outfiles"
else
  savepath=$2
fi

# Parse directories
echo "Copying $project outfiles..."
directories=$(sshpass -p "$password" ssh "$my_name@agave.asu.edu" ls .)

# Loop through directories
for directory in $directories
do
  # If directory is a project directory copy files to local
  if [[ $directory = $project* ]]
  then
    echo "$directory"
    path_agave="$my_name@agave.asu.edu:/home/$my_name/$directory/$savepath/*"
    path_local="$PROJECTSPATH$project/$savepath/."
    sshpass -p "$password" rsync -rv "$path_agave" "$path_local"
  fi
done
echo "Done."
