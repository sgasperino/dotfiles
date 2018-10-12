#! /bin/bash

# Author: Sean Gasperino
# Date: 10/12/18
# -------------------------------
# Description: The purpose of this script is 
# to automatically update the master branches
# of the repos in my work directory.

git_directory=~/TiVO/git

cd ${git_directory}

find . -type d -depth 1 -exec git --git-dir={}/.git --work-tree=$PWD/{} pull origin master \;

echo ""
echo "-------------------------"
echo "All Repos are now updated"
echo "-------------------------"
