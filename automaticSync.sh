#!bin/bash

#Created by ManuelLR <manloprui1@alum.us.es>

# Script to add to cron for continuos sync Git to SVN
# Packages needed:
#       subversion
#       git-svn
#       git

# Remove when fuse the two script
repoFolder="/root/gitToSVN/test18/GitToSVN/"
refreshRateMinutes=2

#Navigate to the repoFolder
cd $repoFolder


# Information about the script
actTimeStart=`date +"%Y/%m/%d-%H:%M:%S"`



## Update the local repo with the last Git Changes
git fetch origin master

statusRepo=`git merge master -m "Merge from Master"`

git pull origin master

exitf=0;

while [ $exitf -eq 0 ]; do
        #Check failed archive
        errorPath="$(git status | grep 'both added:' | sed 's/both added://g' | tr -d '[[:space:]]')"
        if [ "$errorPath" = "" ]; then
                echo "No errors"
                exitf=1
        else
                echo "Fail to commit: "$errorPath
                echo "Resolving ..."
                #git add $errorPath
                git commit -a -m "Resolving conflict"
        fi
done

## Updating to SVN
commits="$(git svn dcommit | grep 'Committed r')"


# Information about the script
actTimeFinish=`date +"%Y/%m/%d-%H:%M:%S"`
echo $actTimeStart "<->" $actTimeFinish "-->" $statusRepo $commits >> ../automaticUpdate.log
