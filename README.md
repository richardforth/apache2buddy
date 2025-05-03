# Status
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://GitHub.com/richardforth/apache2buddy/graphs/commit-activity) [![GitHub latest commit](https://badgen.net/github/last-commit/richardforth/apache2buddy)](https://GitHub.com/richardforth/apache2buddy/commit/) [![GitHub stars](https://badgen.net/github/stars/richardforth/apache2buddy)](https://GitHub.com/richardforth/apache2buddy/stargazers/) [![Generic badge](https://img.shields.io/badge/Tests-Passing-green.svg)](https://shields.io/)

# OS Support Staus

## RedHat Family

Red Hat is Licenced so I am unable to test it, but it is technically supported -  testing is done via OracleLinux, Rocky and Alma.
Note that CentOS is now removed from support and no longer tested against, as it is deprecated, but you  can try with -O to skip OS os checks.

 [![Generic badge](https://img.shields.io/badge/RHEL-Unable%20To%20Test-red.svg)](https://shields.io/)

 [![Generic badge](https://img.shields.io/badge/Centos-Removed-red.svg)](https://shields.io/)

 [![Generic badge](https://img.shields.io/badge/Oracle%20Linux%208-Passing-green.svg)](https://shields.io/)
 [![Generic badge](https://img.shields.io/badge/Oracle%20Linux%209-Passing-green.svg)](https://shields.io/)

 [![Generic badge](https://img.shields.io/badge/Rocky%20Linux%208-Passing-green.svg)](https://shields.io/)
 [![Generic badge](https://img.shields.io/badge/Rocky%20Linux%209-Passing-green.svg)](https://shields.io/)

 [![Generic badge](https://img.shields.io/badge/AlmaLinux%208-Passing-green.svg)](https://shields.io/)
 [![Generic badge](https://img.shields.io/badge/AlmaLinux%209-Passing-green.svg)](https://shields.io/)

 [![Generic badge](https://img.shields.io/badge/AmazonLinux%202-Passing-green.svg)](https://shields.io/)
 [![Generic badge](https://img.shields.io/badge/AmazonLinux%202023-Passing-green.svg)](https://shields.io/)

## Ubuntu

[![Generic badge](https://img.shields.io/badge/Ubuntu%2018.04-Passing-green.svg)](https://shields.io/) [![Generic badge](https://img.shields.io/badge/Ubuntu%2020.04-Passing-green.svg)](https://shields.io/) [![Generic badge](https://img.shields.io/badge/Ubuntu%2022.04-Passing-green.svg)](https://shields.io/)

## Debian

[![Generic badge](https://img.shields.io/badge/Debian%2012-Passing-green.svg)](https://shields.io/)

## Bitnami (apache)

[![Generic badge](https://img.shields.io/badge/Bitnami%20apache-Passing-green.svg)](https://shields.io/)

## Gentoo

[![Generic badge](https://img.shields.io/badge/Gentoo-Unable%20To%20Test-red.svg)](https://shields.io/)
[![Generic badge](https://img.shields.io/badge/Gentoo-Works%20with%20dash%20O%20Option-yellow.svg)](https://shields.io/)


The rule of thumb is if its not listed, its not supported.
Anything that says Unable To Test, means it  should work, but can't be dockerized and isnt included in the Jenkinsfile for licensing reasons, and needs field testing. Badges for those items will be updated to "Passing" if seen working in the wild.

# execution

	# curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/master/apache2buddy.pl | perl


# Best Practice
        
Best Practice is to check the code against either the md5sums or sha256sums (or both) before execution of the code.

Example:

```bash
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
```

If the md5sums or sha256sums do not match, then changes have been made and its untested, so do not proceed until they match.

# Risk Factors

- Running arbitrary code as root (Dangerous)
- Compromised script could result in root level compromise of your server
- Runaway processes doing not what they are supposed to (this actually happened in testing, thankfully all of the known exceptions have been caught)


# Logging

On every execution, an entry is made in a log file: /var/log/apache2buddy.log on your server.

Example log line:

        2016/05/24 10:14:15 Model: "Prefork" Memory: "490 MB" Maxclients: "50" Recommended: "54" Smallest: "8.49 MB" Avg: "8.49 MB" Largest: "8.49 MB" Highest Pct Remaining RAM: "91.84%" (86.64% TOTAL RAM)


This is to help you get an idea of changes over time to your apache tuning requirements. Maybe this will help you decide when you need more RAM, or when you need to start streamlining your code. Tracking when performace started degrading.

Remember it only puts a new entry in the log file on each new execution. Its not designed to be run as a cron job or anything.

# Log Rotation

Log rotation should not be necessary because this script is NOT designed to be run as a cron job so it should never really fill your disks, if you ran this on your server a year or six months ago, maybe its just nice to see what the results were from back then? You get the idea.

