#!/bin/bash
# example of testing md5sums prior to execution

scriptmd5sum=`curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/master/apache2buddy.pl | md5sum | cut -d " " -f1`
originmd5sum=`curl -s https://raw.githubusercontent.com/richardforth/apache2buddy/master/md5sums.txt | cut -d " " -f1`
echo $scriptmd5sum
echo $originmd5sum
if [ $scriptmd5sum == $originmd5sum ]
then
        scriptsha256sum=`curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/master/apache2buddy.pl | sha256sum | cut -d " " -f1`
        originsha256sum=`curl -s https://raw.githubusercontent.com/richardforth/apache2buddy/master/sha256sums.txt | cut -d " " -f1`
        echo $scriptsha256sum
        echo $originsha256sum
        if [ $scriptsha256sum == $originsha256sum ]
        then
                # execute the code, its safe - we can assume
                curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/master/apache2buddy.pl | perl
		if [[ $? != 0 ]]; then
			exit 1
		fi
        else
                echo "Error: SHA256SUM mismatch, execution aborted."
		exit 1
        fi
else
        echo "Error: MD5SUM mismatch, execution aborted."
	exit 1
fi
