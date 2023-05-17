#!/bin/bash

# Get variables
my_name=$(head -n 1 _username_.txt)
password=$(head -n 1 _password_.txt)
project=$1
path_local="$DATAPATH$project"
path_agave="$my_name@agave.asu.edu:/scratch/$my_name/Data/"

# Copy data to cluster
echo "Copying data from $path_local to $path_agave"
sshpass -p "$password" rsync -av --exclude=.* --exclude=*/old --exclude=*/Raw --exclude=*/raw $path_local $path_agave
echo "Done."

