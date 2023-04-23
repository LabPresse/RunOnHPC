#!/bin/bash

# Set ENV variables
DATAPATH=$(head -n 1 _datapath_.txt)
PROJECTSPATH=$(head -n 1 _projectspath_.txt)

my_name=$(head -n 1 _username_.txt)
password=$(head -n 1 _password_.txt)

project=$1

path_local="$DATAPATH$project"
path_agave="$my_name@agave.asu.edu:/home/$my_name/Data/"

echo "Copying data from $path_local to $path_agave"
sshpass -p "$password" rsync -av --exclude=.* --exclude=*/old --exclude=*/Raw --exclude=*/raw $path_local $path_agave

echo "..done"

