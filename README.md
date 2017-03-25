# execution

## old method:

	# curl -sL http://apache2buddy.pl | perl

## new method:

	# curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/master/apache2buddy.pl | perl

# landing page

	########### MPORTANT SAFETY ANNOUNCEMENT #################
	
	This is the NEW landing page for apache2buddy.pl
	
	Please don't curl and perl the domain any more.
	
	For security reasons, the following 
	execution method will bring you to this page:
	
	  # curl -sL apache2buddy.pl | perl
	
	Instead please run / bookmark the following:
	
	  # curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/master/apache2buddy.pl | perl
	  
	This method is much safer.
	
	For more information on this change refer to the README.md:
	https://github.com/richardforth/apache2buddy/blob/master/README.md
	
	Pay specific attention to the "Security Concerns" and 
	"Typocamping is a thing and why you should be concerned" 
	sections.
	
	If you still don't understand the dangers of typocamping, remember,
	you just ran THIS script, on your server as root. Thankfully I am
	a good guy.
	
	The domain will slowly be phased out and will eventually be released.
	This landing page marks the start of that process. 
	
	############### END IMPORTANT SAFTEY ANNOUNCEMENT ##############

# Best Practice
        
Best Practice is to check the code against either the md5sums or sha256sums (or both) before execution of the code.

Example:

	--- a2bchk.sh ---
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
	        else
	                echo "Error: SHA256SUM mismatch, execution aborted."
	        fi
	else
	        echo "Error: MD5SUM mismatch, execution aborted."
	fi
	--- end a2bchk.sh ---

If the md5sums or sha256sums do not match, then changes have been made and its untested, so do not proceed until they match.

# Risk Factors

- Running arbitrary code as root (Dangerous)
- Compromised script could result in root level compromise of your server
- Runaway processes doing not what they are supposed to (this actually happened in testing, thankfully all of the known exceptions have been caught)

# Security concerns

While I do everything I can to ensure the code is clean and free from harmful bugs, there is a risk of malware being run,
 for example "typocamping", therefore if you do curl and perl the domain, be sure to type it absolutely correctly.

In order to mitigate the risks I am now urging you to curl and perl directly from github, like so:

	# curl -sL https://raw.githubusercontent.com/richardforth/apache2buddy/master/apache2buddy.pl | perl

This is a MUCH safer method than curling the domain, and making a typo and being left at the mercy of "typocampers".

Any attempts going forward to curl and perl the domain, will give you the landing page above.

# typo squatting  / camping is a thing, and why you should be concerned.

First of all I am just a dude, with a github acount and enough money to keep one domain going. I don't have infinite wealth,
so buying up all the different likely typo'ed versions of my domain, is impossible.  This is a concern if you are curling 
and perling a domain, as root. can you see the problem if you ran "curl -sL apach2buddy.pl | perl" ? 

Typo campers COULD take advantange of this and register a domain that is close to mine, in the vague hope of a typo that results
in you hitting their site istead of mine, and what if THAT site contained a very malicious perl script?

thats typocamping in a nutshell, and, for that reason, I want to stop using the domain, and phase it out.

Supporting links:

https://www.brandshield.com/typosquatting-ways-to-protect-your-brand/

https://arstechnica.com/security/2016/06/college-student-schools-govs-and-mils-on-perils-of-arbitrary-code-execution/

https://nakedsecurity.sophos.com/typosquatting/

# Logging

On every execution, an entry is made in a log file: /var/log/apache2buddy.log on your server.

Example log line:

        2016/05/24 10:14:15 Model: "Prefork" Memory: "490 MB" Maxclients: "50" Recommended: "54" Smallest: "8.49 MB" Avg: "8.49 MB" Largest: "8.49 MB" Highest Pct Remaining RAM: "91.84%" (86.64% TOTAL RAM)


This is to help you get an idea of changes over time to your apache tuning requirements. Maybe this will help you decide when you need more RAM, or when you need to start streamlining your code. Tracking when performace started degrading.

Remember it only puts a new entry in the log file on each new execution. Its not designed to be run as a cron job or anything.

# Log Rotation

Log rotation should not be necessary because this script is NOT designed to be run as a cron job so it should never really fill your disks, if you ran this on your server a year or six months ago, maybe its just nice to see what the results were from back then? You get the idea.

