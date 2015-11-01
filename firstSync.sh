#!bin/bash

#Created by ManuelLR <manloprui1@alum.us.es>
#Last modified 01/11/2015 20:00

# Script for first configure and first Update GitHub repo to SVN
# Packages needed:
#       subversion
#       git-svn
#       git

## References:
# + http://stackoverflow.com/questions/661018/pushing-an-existing-git-repository-to-svn
# + http://www.codeography.com/2010/03/17/howto-mirror-git-to-subversion.html
# + 


## Create generic Folder
mkdir -p ~/gitToSVN
cd ~/gitToSVN

# -p -> create Only if not exist

# Request the necessary data:
echo 'Enter the repo name (only for create the folder):'
read repoName

echo 'Enter the GitHub repository URL:'
read gitHubUrl

echo 'Enter the SVN repository URL:'
read svnUrl

## Correct Data?
echo
echo 'Selected Folder: /gitToSVN/'$repoName
echo 'GitHub repository URL:' $gitHubUrl
echo 'SVN repository URL:' $svnUrl
echo 'Are that information correct? (y/n)'
read tmpf

if [ "$tmpf" = "n" ]; then
        exit 1
elif [ "$tmpf" = "y" ];then
        echo
else
        echo
        echo "I don't understand you !"
        exit 1
fi

## Create the repoFolder
mkdir $repoName
cd $repoName

## Clone repo from GitHub
git clone $gitHubUrl

#Acces to the create directory
cd */

## Activate if you want to import into a folder (default 'trunk')
svn mkdir --parents $svnUrl/trunk -m "Crete 'trunk'"

##Init repo
git svn init $svnUrl -s


##Continue?
echo
echo "Do you want to continue?(y/n):"
read tmps

if [ "$tmps" = "n" ]; then
        exit 1
elif [ "$tmps" = "y" ];then
        echo
else
        echo
        echo "I don't understand you !"
        exit 1
fi

##
git svn fetch

git merge master

#If you define a folder change origin to origin/FolderName
git rebase origin/trunk


##Continue?
echo
echo "It's normal see some errors above"
echo "Do you want to continue?(y/n):"
read tmps

if [ "$tmps" = "n" ]; then
        exit 1
elif [ "$tmps" = "y" ];then
        echo
else
        echo
        echo "I don't understand you !"
        exit 1
fi

##
exitf=0;

while [ $exitf -eq 0 ]; do
        #Check failed archive
        errorPath="$(git status | grep 'both modified:' | sed 's/both modified://g' | tr -d '[[:space:]]')"
        if [ "$errorPath" = "" ]; then
                echo "No errors"
                exitf=1
        else
                echo "Fail to commit: "$errorPath
                echo "Resolving ..."
                git add $errorPath
                git rebase --continue
        fi
done

##Commit to SVN
echo
echo "Initialize commit SVN to "$svnUrl
echo "This process can take a long time"
git svn dcommit | grep "Committed r"

## Fin
echo
echo "Script Finished !!!"

