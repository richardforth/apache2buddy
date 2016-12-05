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

        # curl -sL apache2buddy.pl | perl
        ########################################################################################
        ##       ___                     __        ___      ____            __    __          ##
        ##      /   |  ____  ____ ______/ /_  ___ |__ \    / __ )__  ______/ /___/ /_  __     ##
        ##     / /| | / __ \/ __ `/ ___/ __ \/ _ \__/ /   / __  / / / / __  / __  / / / /     ##
        ##    / ___ |/ /_/ / /_/ / /__/ / / /  __/ __/   / /_/ / /_/ / /_/ / /_/ / /_/ /      ##
        ##   /_/  |_/ .___/\__,_/\___/_/ /_/\___/____/  /_____/\__,_/\__,_/\__,_/\__, /       ##
        ##         /_/ apache2buddy.pl                                          /____/        ##
        ##                                                                                    ##
        ########################################################################################

        About...
        [ INFO     ] apache2buddy.pl is a fork of apachebuddy.pl.
        [ INFO     ] Project status: STABLE. Please report bugs, if you find any, so I can fix them!
        [ INFO     ] Latest update: Tuesday, May 24th, 2016 @ 14:36. Check http://apache2buddy.pl/changelog for details.
        [ INFO     ] Send bug reports / feature requests to richard.forth AT gmail.com.
        [ INFO     ] Support for the following systems has been added:.
        [ INFO     ] Ubuntu 12.04 / 14.04, Debian 6 / 7 / 8, CentOS / Scientific Linux / RHEL versions 5.x, 6.x, 7.x.
        [ INFO     ] MD5SUMs now availiable at https://raw.githubusercontent.com/richardforth/apache2buddy/master/md5sums.txt
        [ INFO     ] SHA256SUMs now availiable at https://raw.githubusercontent.com/richardforth/apache2buddy/master/sha256sums.txt

        Performing Auto-Discovery, and Pre-Flight Checks...
        [ OK       ] This script is being run as root.
        [ OK       ] The utility 'pmap' exists and is available for use: /usr/bin/pmap
        [ OK       ] 'php' exists and is available for use: /usr/bin/php

        [ OK       ] The port (port 80) is a valid port.
        [ INFO     ] We are attempting to discover the operating system type and version number ...
        [ INFO     ] OS Name: CentOS
        [ INFO     ] OS Release: 6.6
        [ OK       ] Apache2buddy supports this OS Release/Version.
        [ INFO     ] Hostname: server.hostname.com
        [ INFO     ] Primary IP: X.X.X.X
        [ INFO     ] We are checking the service running on port 80...
        [ INFO     ] The process listening on port 80 is /usr/sbin/httpd
        [ INFO     ] The process running on port 80 is Apache/2.2.15 (Unix).
        [ INFO     ] Apache has been running 2d 06h 58m 12s.
        [ INFO     ] The full path to the Apache config file is: /etc/httpd/conf/httpd.conf
        [ INFO     ] Apache is using prefork model.
        [ INFO     ] pidfile setting is run/httpd.pid.
        [ INFO     ] Actual pidfile is /var/run/httpd/httpd.pid.
        [ INFO     ] Parent PID: 30534.
        [ OK       ] Memory usage of parent PID is less than 50MB: 8560 Kilobytes.
        [ INFO     ] Your server has 490 MB of PHYSICAL memory.
        [ INFO     ] Your MaxClients setting is 50.
        [ INFO     ] Your ServerLimit setting is 120.
        [ INFO     ] Your MaxRequestsPerChild setting is 4000.

        Detecting PHP Memory Limits...
        [ INFO     ] Your PHP Memory Limit (Per-Process) is 128 MB.

        Detecting additional services for consideration...
        [ INFO     ] MySQL Detected => Using 17.55 MB of memory.
        [ INFO     ] Varnish Detected => Using 9.33 MB of memory.
        [ INFO     ] Memcache Detected => Using 0.89 MB of memory.

        Detecting If Maxclients or MaxRequestWorkers has been hit recently....

        PRO TIP: If this process appears to hang, press CTRL + c to exit the program, and then
        go check for a large error log file in /var/log/httpd or /var/log/apache2.

        [ OK       ] MaxClients has not been hit recently.
        
        Analyzing apache memory use...
        [ INFO     ] httpd is currently using 80.43 MB of memory.
        [ INFO     ] The smallest apache process is using 8.49 MB of memory
        [ INFO     ] The average apache process is using 8.49 MB of memory
        [ INFO     ] The largest apache process is using 8.49 MB of memory

        Results...
        [ OK       ] Going by the average Apache process, Apache can potentially use 424.50 MB RAM:
                        Without considering services: 86.64 % of total installed RAM
                Considering extra services: 91.84 % of remaining RAM
        [ OK       ] Going by the largest Apache process, Apache can potentially use 424.50 MB RAM:
                      Without considering services: 86.64 % of total installed RAM
                      Considering extra services: 91.84 % of remaining RAM

        Generating reports...
        ### GENERAL FINDINGS & RECOMMENDATIONS ###
        --------------------------------------------------------------------------------
        Apache2buddy.pl report for server: server.hostname.com (X.X.X.X):

        Settings considered for this report:

                Your server's physical RAM:                                   490 MB
                Remaining Memory after other services considered:             462 MB
                Apache's MaxClients directive:                                50       <--------- Current Setting
                Apache MPM Model:                                             prefork
                Largest Apache process (by memory):                           8 MB
        [ OK ]  Your MaxClients setting is within an acceptable range.
                Your recommended MaxClients setting is between 48 and 54.               <------- Acceptable Range (10% of MAX)
                Max potential memory usage:                                   424 MB
                Percentage of TOTAL RAM allocated to Apache:                  86.64  %
                Percentage of REMAINING RAM allocated to Apache:              91.84  %
        --------------------------------------------------------------------------------
        A log file entry has been made in: /var/log/apache2buddy.log for future reference.

        Last 5 entries:

        2016/04/21 12:17:26 Model: "Prefork" Memory: "490 MB" Maxclients: "50" Recommended: "48" Smallest: "7.98 MB" Avg: "7.98 MB" Largest: "7.98 MB" Highest Pct Remaining RAM: "102.92%" (81.43% TOTAL RAM)
        2016/04/21 12:17:41 Model: "Prefork" Memory: "490 MB" Maxclients: "50" Recommended: "48" Smallest: "7.98 MB" Avg: "7.98 MB" Largest: "7.98 MB" Highest Pct Remaining RAM: "102.92%" (81.43% TOTAL RAM)
        2016/04/21 12:20:04 Model: "Prefork" Memory: "490 MB" Maxclients: "50" Recommended: "48" Smallest: "7.98 MB" Avg: "7.98 MB" Largest: "7.98 MB" Highest Pct Remaining RAM: "102.92%" (81.43% TOTAL RAM)
        2016/05/24 09:27:57 Model: "Prefork" Memory: "490 MB" Maxclients: "50" Recommended: "54" Smallest: "8.49 MB" Avg: "8.49 MB" Largest: "8.49 MB" Highest Pct Remaining RAM: "91.83%" (86.64% TOTAL RAM)
        2016/05/24 10:14:15 Model: "Prefork" Memory: "490 MB" Maxclients: "50" Recommended: "54" Smallest: "8.49 MB" Avg: "8.49 MB" Largest: "8.49 MB" Highest Pct Remaining RAM: "91.84%" (86.64% TOTAL RAM)

        #

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
