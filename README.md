# rebranding

You may notice the logo and tag line has been updated:
        	
                                     |           ___ \   |                 |      |                   |	
           _` |  __ \    _` |   __|  __ \    _ \    ) |  __ \   |   |   _` |   _` |  |   |     __ \   |
          (   |  |   |  (   |  (     | | |   __/   __/   |   |  |   |  (   |  (   |  |   |     |   |  |
         \__,_|  .__/  \__,_| \___| _| |_| \___| _____| _.__/  \__,_| \__,_| \__,_| \__, | _)  .__/  _|
                _| Apache Tuning and Advisories for Professional Administrators.    ____/     _|
        
        Welcome to apache2buddy...
        Stand by for launch...
	
This is to reflect the maturity of the project, and to give it a more professional look and feel.
I hope you find it as refreshing as the new features that have been added:

	 - Detecting cPanel version
	 - Detecting Plesk Version
	 - Detecting PHP and apache package updates that may be pending
	 - Large Log File detection in common locations
	 - Some major bug fixes and improvements to layout

# domain

apache2buddy.pl is a polish domain which happens to be the extension of perl scripts, so registered it and pointed it here:

apache2buddy.pl => https://raw.githubusercontent.com/richardforth/apache2buddy/master/apache2buddy.pl

This allows one to execute it on the server easily with

	# curl -sL apache2buddy.pl | perl

Notes on the curl & perl method:

	-s      silent (dont show the curl download header)
	-L      follow redirects (very important as you get a 301)

You can also wget it but this is frowned upon (especially by me) however you can do it like so:

	# cd
	# wget -O apache2buddy.pl apache2buddy.pl
	# perl apache2buddy.pl

Reasons I frown when you do this wget method:

	1. Youre downloading the file. This file is never going to get updated, unless you wget it again.
	2. I do regular bugfixes, feature requests and cleanups of code.
	3. With curl and perl, you always pull the latest version.

# apache2buddy

If any changes are made please update the md5sums and sha256sums or some automation fails:

        # md5sum apache2buddy.pl > md5sums.txt
        # sha256sum apache2buddy.pl > sha256sums.txt
        
# Best Practice
        
Best Practice is to check the code against either the md5sums or sha256sums (or both) before execution of the code.

Example:

        --- a2bchk.sh ---
        #!/bin/bash
        # example of testing md5sums prior to execution

        # apache has its own domain 'apache2buddy.pl' this saves typing out 'https://raw.githubusercontent.com/richardforth/apache2buddy/master/apache2buddy.pl'
        scriptmd5sum=`curl -sL apache2buddy.pl | md5sum | cut -d " " -f1`
        originmd5sum=`curl -s https://cdn.rawgit.com/richardforth/apache2buddy/master/md5sums.txt | cut -d " " -f1`
        echo $scriptmd5sum
        echo $originmd5sum
        if [ $scriptmd5sum == $originmd5sum ]
        then
                scriptsha256sum=`curl -sL apache2buddy.pl | sha256sum | cut -d " " -f1`
                originsha256sum=`curl -s https://cdn.rawgit.com/richardforth/apache2buddy/master/sha256sums.txt | cut -d " " -f1`
                echo $scriptsha256sum
                echo $originsha256sum
                if [ $scriptsha256sum == $originsha256sum ]
                then
                        # execute the code, its safe - we can assume
                        curl -sL apache2buddy.pl | perl
                else
                        echo "Error: SHA256SUM mismatch, execution aborted."
                fi
        else
                echo "Error: MD5SUM mismatch, execution aborted."
        fi
        --- end a2bchk.sh ---



If the md5sums or sha256sums do not match, then changes have been made and its untested, so do not proceed until they match.

# Special Note

Even if the md5sums and sha256sums match, remember youre still running arbitrary code on YOUR SERVER, AS ROOT, thats quite a dangerous proposition, so please do check the code, its YOUR responsibilty to make sure this doesnt break your systems, run it in a test environment first, sandbox it, test it thoroughly before you run it on your live systems, PLEASE!, I beg you!

# Risk Factors

- Running arbitrary code as root (Dangerous)
- Compromised script could result in root level compromise of your server
- Runaway processes doing not what they are supposed to (this actually happened in testing, thankfully all of the known exceptions have been caught)

# The apache2buddy.pl domain

This tool has its own domain, that redirects to the raw script in the master branch:

        apache2buddy.pl => https://raw.githubusercontent.com/richardforth/apache2buddy/master/apache2buddy.pl

Be sure to specify the -L switch when curling and perling.

# About, and heritage information

apache2buddy.pl is a reporting tool and onetime run dashboard for assisting with tuning and troubleshooting apache webservers.

        # curl -sL apache2buddy.pl | perl

It is a fork of the original project 'apachebuddy.pl'.

        # curl -sL apachebuddy.pl | perl

Its' continued development has included support for Debian and Ubuntu, wherease the original script only used to suport RedHat / CentOS Systems 

New features have been added and if you compared the two outputs above you will notice a vastly more intuitive and informational dash:


OLD:

        # curl -sL apachebuddy.pl | perl
        ########################################################################
        # Apache Buddy v 0.3 ###################################################
        ########################################################################
        Gathering information...
        We are checking the service running on port 80
        The process listening on port 80 is /usr/sbin/httpd
        The process running on port 80 is Apache/2.2.15 (Unix)
        Apache has been running 2d 06h 56m 40s
        The full path to the Apache config file is: /etc/httpd/conf/httpd.conf
        Apache is using prefork model

        Examining your Apache configuration...
        Apache runs as apache
        Your max clients setting is 50

        Analyzing memory use...
        Your server has 490 MB of memory
        The largest apache process is using 8.49 MB of memory
        The smallest apache process is using 8.49 MB of memory
        The average apache process is using 8.49 MB of memory
        Going by the average Apache process, Apache can potentially use 424.50 MB RAM (86.64 % of available RAM)
        Going by the largest Apache process, Apache can potentially use 424.50 MB RAM (86.64 % of available RAM)

        Generating reports...
        ### GENERAL REPORT ###

        Settings considered for this report:

                Your server's physical RAM:             490MB
                Apache's MaxClients directive:          50
                Apache MPM Model:                       prefork
                Largest Apache process (by memory):     8.49MB
        [ OK ]  Your MaxClients setting is within an acceptable range.
                Max potential memory usage:             424.5 MB

                Percentage of RAM allocated to Apache   86.64 %

        -----------------------------------------------------------------------
        -----------------------------------------------------------------------



NEW:

        root@debian:~# curl -sL apache2buddy.pl | perl - --light-term
        	
                                     |           ___ \   |                 |      |                   |	
           _` |  __ \    _` |   __|  __ \    _ \    ) |  __ \   |   |   _` |   _` |  |   |     __ \   |
          (   |  |   |  (   |  (     | | |   __/   __/   |   |  |   |  (   |  (   |  |   |     |   |  |
         \__,_|  .__/  \__,_| \___| _| |_| \___| _____| _.__/  \__,_| \__,_| \__,_| \__, | _)  .__/  _|
                _| Apache Tuning and Advisories for Professional Administrators.    ____/     _|
        
        Welcome to apache2buddy...
        Stand by for launch...
        
        About...
        [ INFO     ] apache2buddy.pl is a fork of apachebuddy.pl.
        [ INFO     ] MD5SUMs now availiable at https://raw.githubusercontent.com/richardforth/apache2buddy/master/md5sums.txt
        [ INFO     ] SHA256SUMs now availiable at https://raw.githubusercontent.com/richardforth/apache2buddy/master/sha256sums.txt
        [ INFO     ] apache2buddy.pl is now released under the Apache 2.0 License. See https://raw.githubusercontent.com/richardforth/apache2buddy/master/LICENSE
        [ INFO     ] apache2buddy.pl is now hosted from github. See https://github.com/richardforth/apache2buddy
        [ INFO     ] Changelogs and updates in github. See https://raw.githubusercontent.com/richardforth/apache2buddy/master/changelog
        
        Performing Auto-Discovery, and Pre-Flight Checks...
        [ OK       ] This script is being run as root.
        [ OK       ] The utility 'pmap' exists and is available for use: /usr/bin/pmap
        [ OK       ] The utility 'netstat' exists and is available for use: /bin/netstat
        [ OK       ] 'php' exists and is available for use: /usr/bin/php
        [ OK       ] The utility 'apachectl' exists and is available for use: /usr/sbin/apachectl
        [ OK       ] The port (port 80) is a valid port.
        [ INFO     ] We are attempting to discover the operating system type and version number ...
        [ INFO     ] OS Name: Debian
        [ INFO     ] OS Release: 8.6
        [ OK       ] The operating system is supported.
        [ INFO     ] Hostname: debian
        [ INFO     ] Primary IP: REDACTED
        [ INFO     ] We are checking the service running on port 80...
        [ INFO     ] The process listening on port 80 is /usr/sbin/apache2
        [ INFO     ] The process running on port 80 is Apache/2.4.10 (Debian).
        [ INFO     ] Apache has been running 0d 01h 17m 28s.
        [ WARNING  ] *** LOW UPTIME ***.
        [ ADVISORY ] The following recommendations may be misleading - apache has been restarted within the last 24 hours.
        [ INFO     ] The full path to the Apache config file is: /etc/apache2/apache2.conf
        [ INFO     ] Apache is using prefork model.
        [ INFO     ] pidfile setting is /var/run/apache2/apache2$SUFFIX.pid.
        [ INFO     ] Actual pidfile is /var/run/apache2/apache2.pid.
        [ INFO     ] Parent PID: 9733.
        [ OK       ] Memory usage of parent PID is less than 50MB: 5980 Kilobytes.
        [ INFO     ] Your server has 994 MB of PHYSICAL memory.
        [ WARNING  ] ServerLimit directive not found, assuming default values.
        [ INFO     ] Your ServerLimit setting is 256.
        [ INFO     ] Your MaxRequestWorkers setting is 150.
        [ OK       ] Current Apache Process Count is 6, including the parent PID.
        [ INFO     ] Number of vhosts detected: 0.
        [ OK       ] Current Apache vHost Count is less than maxrequestworkers.
        [ ADVISORY ] vHost Count works only when we have NameVirtualHosting enabled, check config manually, they may only have the default vhost.
        [ WARNING  ] MaxRequestsPerChild directive not found.
        
        Detecting Control Panels...
        [ INFO     ] This server is NOT running Plesk.
        [ INFO     ] This server is NOT running cPanel.
        
        Detecting PHP Memory Limits...
        [ INFO     ] Your PHP Memory Limit (Per-Process) is -1 MB.
        [ ADVISORY ] You should set a PHP Memory Limit (-1 is UNLIMITED) which is not recommended.
        
        Detecting additional services for consideration...
        [ OK       ] No additional services were detected.
        
        Detecting Large Log Files...
        PRO TIP: This is a precursor to the following  2 checks that may appear to hang if there are very large error logs.
        PRO TIP: If those process do appear to hang, press CTRL + c to exit the program, and then go check the logs we report below, if any.
        [ OK       ] No large logs files were found in /var/log/apache2.
        
        Detecting If Maxclients or MaxRequestWorkers has been hit recently....
        [ OK       ] MaxClients has not been hit recently.
        
        Detecting PHP Fatal Errors....
        [ OK       ] No PHP Fatal Errors were found.
        
        Detecting Package Updates for Apache or PHP...
        [ OK       ] No package updates found.
        [ ADVISORY ] I only checked for "apache specific" package updates (eg php, httpd, httpd24u, or apache2 packages only).
        
        Analyzing apache memory use...
        [ INFO     ] apache2 is currently using 55.76 MB of memory.
        [ INFO     ] The smallest apache process is using 5.87 MB of memory
        [ INFO     ] The average apache process is using 5.87 MB of memory
        [ INFO     ] The largest apache process is using 5.87 MB of memory
        
        Results...
        [ OK       ] Going by the average Apache process, Apache can potentially use 880.50 MB RAM:
                        Without considering services: 88.59 % of total installed RAM
                        Considering extra services: 88.59 % of remaining RAM
        [ OK       ] Going by the largest Apache process, Apache can potentially use 880.50 MB RAM:
                        Without considering services: 88.59 % of total installed RAM
                        Considering extra services: 88.59 % of remaining RAM
        
        Generating reports...
        ### GENERAL FINDINGS & RECOMMENDATIONS ###
        --------------------------------------------------------------------------------
        Apache2buddy.pl report for server: debian (REDACTED):
        
        Settings considered for this report:
        [ WARNING  ] *** LOW UPTIME ***.
        [ ADVISORY ] The following recommendations may be misleading - apache has been restarted within the last 24 hours.
        
        Your server's physical RAM:                                   994 MB
        Remaining Memory after other services considered:             994 MB
        Apache's MaxRequestWorkers directive:                         150       <--------- Current Setting
        Apache MPM Model:                                             prefork
        Largest Apache process (by memory):                           5 MB
        [ !! ]  Your MaxRequestWorkers setting is too low.
        Your recommended MaxRequestWorkers setting is between 152 and 169. <------- Acceptable Range (10% of MAX)
        Max potential memory usage:                                   880 MB
        Percentage of TOTAL RAM allocated to Apache:                  88.59  %
        Percentage of REMAINING RAM allocated to Apache:              88.59  %
        --------------------------------------------------------------------------------
        A log file entry has been made in: /var/log/apache2buddy.log for future reference.
        
        Last 5 entries:
        
        2017/01/13 23:43:07 Model: "Prefork" Memory: "994 MB" MaxRequestWorkers: "150" Recommended: "169" Smallest: "5.87 MB" Avg: "5.87 MB" Largest: "5.87 MB" Highest Pct Remaining RAM: "88.59%" (88.59% TOTAL RAM)
        2017/01/14 00:20:47 Model: "Prefork" Memory: "994 MB" MaxRequestWorkers: "150" Recommended: "169" Smallest: "5.87 MB" Avg: "5.87 MB" Largest: "5.87 MB" Highest Pct Remaining RAM: "88.59%" (88.59% TOTAL RAM)
        2017/01/14 00:24:09 Model: "Prefork" Memory: "994 MB" MaxRequestWorkers: "150" Recommended: "169" Smallest: "5.87 MB" Avg: "5.87 MB" Largest: "5.87 MB" Highest Pct Remaining RAM: "88.59%" (88.59% TOTAL RAM)
        2017/01/14 00:24:44 Model: "Prefork" Memory: "994 MB" MaxRequestWorkers: "150" Recommended: "169" Smallest: "5.87 MB" Avg: "5.87 MB" Largest: "5.87 MB" Highest Pct Remaining RAM: "88.59%" (88.59% TOTAL RAM)
        2017/01/14 00:25:07 Model: "Prefork" Memory: "994 MB" MaxRequestWorkers: "150" Recommended: "169" Smallest: "5.87 MB" Avg: "5.87 MB" Largest: "5.87 MB" Highest Pct Remaining RAM: "88.59%" (88.59% TOTAL RAM)

        root@debian:~#


So as you may see, there are some similarities between the new and the old, but the NEW has undergone some incerdible changes and is an entirely new beast, one of the most killer featues is that it nows takes into consideration a nuumber of services BEFORE calculating a maxcients value, this includes:

       - MySQL
       - Java
       - Varnish
       - Redis
       - Memcache
       - PHP-FPM
       - Gluster


# Logging

On every execution, an entry is made in a log file: /var/log/apache2buddy.log on your server.

Example log line:

        2016/05/24 10:14:15 Model: "Prefork" Memory: "490 MB" Maxclients: "50" Recommended: "54" Smallest: "8.49 MB" Avg: "8.49 MB" Largest: "8.49 MB" Highest Pct Remaining RAM: "91.84%" (86.64% TOTAL RAM)


This is to help you get an idea of changes over time to your apache tuning requirements. Maybe this will help you decide when you need more RAM, or when you need to start streamlining your code. Tracking when performace started degrading.

Remember it only puts a new entry in the log file on each new execution. Its not designed to be run as a cron job or anything.

# Log Rotation

Log rotation should not be necessary because this script is NOT designed to be run as a cron job so it should never really fill your disks, if you ran this on your server a year or six months ago, maybe its just nice to see what the results were from back then? You get the idea.

# Last but not least...

Please take note of the following service announcement:

        *********************************************************************
        * IMPORTANT SERVICE ANNOUNCEMENT NOTICE                             *
        *********************************************************************
        *                                                                   *
        * apache2buddy.pl HAS MOVED to github, this now introduces          *
        * a 301 redirect for the domain apache2buddy.pl.                    *
        *                                                                   *
        * Please make sure you update any processes to ensure that they     *
        * can follow redirects.                                             *
        *                                                                   *
        * If you use the curl and perl method, please add the -L switch:    *
        *                                                                   *
        *    # curl -sL apache2buddy.pl | perl                              *
        *                                                                   *
        * Thanks,                                                           *
        * Richard                                                           *
        *********************************************************************
