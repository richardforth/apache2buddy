#!/usr/bin/perl

eval "use diagnostics; 1"  or die("\n[ FATAL ] Could not load the Diagnostics module.\n\nTry:\n\n      sudo apt-get install perl-modules\n\nThen try running this script again.\n\n");
use Getopt::Long qw(:config no_ignore_case bundling pass_through);
use POSIX;
use strict;
use File::Find;
############################################################################################################
#                            __        ___   __              __    __              __
#    ____  ____  ____ ______/ /_  ___ |__ \ / /_  __  ______/ /___/ /_  __  ____  / /
#   / __ `/ __ \/ __ `/ ___/ __ \/ _ \__/ // __ \/ / / / __  / __  / / / / / __ \/ / 
#  / /_/ / /_/ / /_/ / /__/ / / /  __/ __// /_/ / /_/ / /_/ / /_/ / /_/ / / /_/ / /  
#  \__,_/ .___/\__,_/\___/_/ /_/\___/____/_.___/\__,_/\__,_/\__,_/\__, (_) .___/_/   
#      /_/                                                       /____/ /_/          
#
############################################################################################################
# author: richard forth
# description: apache2buddy, a fork of apachebuddy that caters for apache2, obviously.
#
#  Github Page: https://github.com/richardforth/apache2buddy
#  Please only make pull requests from staging branch.
#
# [ INFO     ] apache2buddy.pl is a fork of apachebuddy.pl.
# [ INFO     ] MD5SUMs now availiable at https://raw.githubusercontent.com/richardforth/apache2buddy/master/md5sums.txt
# [ INFO     ] SHA256SUMs now availiable at https://raw.githubusercontent.com/richardforth/apache2buddy/master/sha256sums.txt
# [ INFO     ] apache2buddy.pl is now released under the Apache 2.0 License. See https://raw.githubusercontent.com/richardforth/apache2buddy/master/LICENSE
# [ INFO     ] apache2buddy.pl is now hosted from github. See https://github.com/richardforth/apache2buddy
# [ INFO     ] Changelogs and updates in github. See https://raw.githubusercontent.com/richardforth/apache2buddy/master/changelog
#
###########################################################################################################
#
#                                           L I C E N S E
#
###########################################################################################################
#
#   Copyright 2016 Richard Forth
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#    
#   The copyright line reads as my name, because I did a lot of work in making
#   this fork a whole new beast, and the previous project was never distributed
#   under any official license, I did get the blessing from Gus Maskowitz to
#   publish it under the Apache License 2.0.
#   
#   The purpose of the license is to ensure that free software remains free, not
#   as in "free beer" but in "freedom". The freedom to derive new software from
#   this and to keep that software "free" too. 
#   
#   But it is important to acknowldege too, that this is a derivative work from 
#   apachebuddy.pl. Even though it is not being maintained any more, I would like 
#   to acknowledge the talents of a few people:
#   
#     Major Hayden - for his inspiring work on MySQLTuner.pl
#     Jacob Walcik - who is the credited author of apache2buddy.pl (see the first
#                    few lines of the original script code at http:// apachebuddy.pl)
#     Gus Maskowitz - for his work on the script, though it is no longer maintained
#     Will Parsons - for hosting the original script at http://apachebuddy.pl
#   
#   Here I note that I also do not maintain the old project, this is a complete
#   fork and revamp of the original code, and is maintained separately.
#   
#  Please keep any and all credits in the source code, and if you derive a new
#  software from it, by all means add your own credits.
#
#
############################################################################################################
#                                           D I S C L A I M E R  
############################################################################################################
#
#  PLEASE NOTE THAT THIS IS DESIGNED AS A REPORTING TOOL ONLY
#  ==============================================================
#
#  There are no plans to make this script automatically change any apache configuration settings, as this 
#  could prove disasterous in production environments.
#
#  Needless to say this script comes without any warranty or fitness for a particular use and you run it
#  at your own risk. 
#
#  * * * * USE THIS SCRIPT AT YOUR OWN RISK * * * * 
#
#  Every care has been taken to make sure this does nothing bad, it should only be reading configuration
#  files, and doing a bit of maths, and printing out a shiny report.
#
#  Nothing more nothing less. 
#
#  Please pay special attention and review the source code before deciding whether you should run this on 
#  your systems. 
#
#  I am not responsible for any damage caused to your data, systems or hardware, loss of business, your 
#  marriage breaking down, getting your car or house reposessed, or ending up in prison or losing your job
#  and drug habits developing , insolvency, bankruptcy, personal hygiene issues, disease  or death that may 
#  stem as  a direct result of running this script.
#
#  YOU HAVE BEEN WARNED!
#
#
###########################################################################################################
#
#  Note:
#
#  If you really want to read all of the source code, I suggest that you start from the comment:
#
#  ########################
#  # BEGIN MAIN EXECUTION #
#  ########################
#
#  Because everything from this point to that, is just a bunch of subroutines that the script needs in order
#  to be able to run, and it won't flow or make any sense until you start from the "start".
#
##########################################################################################################

## print usage
sub usage {
	our $usage_output = <<'END_USAGE';

Usage: apache2buddy.pl [OPTIONS]
If no options are specified, the basic tests will be run.

	-h, --help		Print this help message
	-p, --port=PORT		Specify an alternate port to check (default: 80)
	    --pid=PID		Specify a PID to bypass the "Multiple PIDS listening on port 80" error.
	-v, --verbose		Use verbose output (this is very noisy, only useful for debugging)
	-n, --nocolor		Use default terminal color, dont try to be all fancy! 
	-H, --noheader		Do not show header title bar.
	-N, --noinfo		Do not show informational messages.
	-K, --no-ok		Do not show OK messages.
	-W, --nowarn		Do not show warning messages.
	-L, --light-term	Show colours for a light background terminal.
	-r, --report		Implies -HNWK or --noinfo --nowarn --no-ok --noheader --skip-maxclients --skip-php-fatal --skip-updates
	-P, --no-check-pid	DON'T Check the Parent Pid File Size (only use if desperate for more info, results may be skewed).
	    --skip-maxclients	Skip checking in maxclients was hit recently, can be slow, especialy if you have large log files.
            --skip-php-fatal    Skip checking for PHP FATAL errors, can be slow, especialy if you have large log files.
            --skip-updates      Skip checking for package updates, can be slow or problematic, causing the script to hang.


Key:

    [ -- ]  = Information
    [ @@ ]  = Advisory
    [ >> ]  = Warning
    [ !! ]  = Critical


END_USAGE

	print $usage_output;
}
########################
# GATHER CMD LINE ARGS #
########################

# if help is not asked for, we do not give it
my $help = "";

# by default, assume the terminal has dark background, eg putty 
my $LIGHTBG = 0;

# if no port is specified, we default to 80
my $port = 80;

# if no pid is specified, we default to 0
our $pid = 0;

# by default, do not use verbose output
our $VERBOSE = "";

# by default, use color output
our $NOCOLOR = 0;

# by default, show news messages 
our $NONEWS = 0;

# by default, show informational messages 
our $NOINFO = 0;

# by default, show ok messages 
our $NOOK = 0;

# by default, show warnings 
our $NOWARN = 0;

# by default, show full output 
our $REPORT = 0;

# by default, show header 
our $NOHEADER = 0;

# by default, check pid size 
our $NOCHKPID = 0;

# add 'skip section' options...

# by default, do not skip maxclients check
our $SKIPMAXCLIENTS = 0;

# by default, do not skip php fatal errors check 
our $SKIPPHPFATAL = 0;

# by default, do not skip updates check 
our $SKIPUPDATES = 0;


# grab the command line arguments
GetOptions(
	'help|h' => \$help,
	'port|p:i' => \$port,
	'pid:i' => \$pid,
	'verbose|v' => \$VERBOSE,
	'nocolor|n' => \$main::NOCOLOR,
	'noinfo|N' => \$NOINFO,
	'nowarn|W' => \$NOWARN,
	'report|r' => \$REPORT,
	'light-term|L' => \$LIGHTBG,
	'no-ok|K' => \$NOOK,
	'noheader|H' => \$NOHEADER,
	'no-check-pid|P' => \$NOCHKPID,
	'skip-maxclients' => \$SKIPMAXCLIENTS,
	'skip-php-fatal' => \$SKIPPHPFATAL,
	'skip-updates' => \$SKIPUPDATES,
	'nonews' => \$NONEWS
);

# check for invalid options, bail if we find any and print the usage output
if ( @ARGV > 0 ) {
	print "Invalid option: ";
	foreach (@ARGV) {
		print $_." ";
	}
	print "\n";
	usage;
	exit;
}

if ( $REPORT ) {
	$NOHEADER = 1;
	$NOINFO = 1;
	$NONEWS = 1;
	$NOWARN = 1;
	$NOOK = 1;
	$SKIPMAXCLIENTS = 1;
	$SKIPPHPFATAL = 1;
	$SKIPUPDATES = 1;
}

# Declare constants such as ANSI COLOR schemes.
# TO SAVE CODE and thus also massively cut down on the file size, Ive decided to handle NOCOLOR here, 
# instead of on every single line where I need to print something. it seems much simpler and cleaner
# to print an empty string rather than an escape sequence, rather than doubling up on print() statements.
our $RED;
our $GREEN;
our $YELLOW;
our $BLUE;
our $PURPLE;
our $CYAN;
our $ENDC;
our $BOLD;
our $UNDERLINE;
if ( ! $NOCOLOR ) {
	if ( ! $LIGHTBG ) {
		$RED = "\033[91m";
		$GREEN = "\033[92m"; # Like a light green color, not good for light terminals, but perfect for dark, eg PuTTY, terminals.
		$YELLOW = "\033[93m"; # Like a yellow color, not good for light terminals, but perfect for dark, eg PuTTY, terminals.
		$BLUE = "\033[94m";
		$PURPLE = "\033[95m"; # technically its Magento... 
		$CYAN = "\033[96m"; # Like a light blue color, not good for light terminals, but perfect for dark, eg PuTTY, terminals.
	} else {
		$RED = "\033[1m"; # bold all the things!
		$GREEN = "\033[1m"; # bold all the things!
		$YELLOW = "\033[1m"; # bold all the things!
		$BLUE = "\033[1m"; # bold all the things!
		$PURPLE = "\033[1m"; # bold all the things!
		$CYAN = "\033[1m";  # bold all the things!
	}
	$ENDC = "\033[0m"; # reset the terminal color
	$BOLD = "\033[1m"; # what it says on the tin, you can double up eg make a bold red: ${BOLD}${RED}Something${ENDC}
	$UNDERLINE = "\033[4m"; # again you can double this one up.
} else {
	$RED = ""; # SUPPRESS COLORS
	$GREEN = ""; # SUPPRESS COLORS
	$YELLOW = ""; # SUPPRESS COLORS
	$BLUE = ""; # SUPPRESS COLORS
	$PURPLE = ""; # SUPPRESS COLORS
	$CYAN = ""; # SUPPRESS COLORS
	$ENDC = ""; # SUPPRESS COLORS
	$BOLD = ""; # SUPPRESS COLORS
	$UNDERLINE = ""; # SUPPRESS COLORS
}

sub get_os_platform_older {
	our $python;
	my $raw_platform = `$python -c 'import platform ; print (platform.dist())'`;
	# ('CentOS Linux', '7.3.1611', 'Core')
	$raw_platform =~ s/[()']//g;
	my @platform = split(", ", $raw_platform);
	my $distro =  @platform[0];
	my $version = @platform[1];
	my $codename = @platform[2];
	return ($distro, $version, $codename);
}

sub get_os_platform {
	our $python;
	my $raw_platform = `$python -c 'import platform ; print (platform.linux_distribution())'`;
	# ('CentOS Linux', '7.3.1611', 'Core')
	$raw_platform =~ s/[()']//g;
	my @platform = split(", ", $raw_platform);
	my $distro =  @platform[0];
	my $version = @platform[1];
	my $codename = @platform[2];
	return ($distro, $version, $codename);
}

sub check_os_support {
	my ($distro, $version, $codename) = @_;
	# Please dont make pull requests to add your distro to this list, that doesnt make it supported.
	# The following distros are what I use to test and deploy apache2buddy and only these distro's are supported.
	my @supported_os_list = ('Ubuntu',
				'ubuntu',
				'Debian',
				'debian',
				'Red Hat Enterprise Linux',
				'Red Hat Enterprise Linux Server',
				'redhat',
				'CentOS Linux',
				'CentOS',
				'centos',
				'Scientific Linux');
	my %sol = map { $_ => 1 } @supported_os_list;
	
	my @ubuntu_os_list = ('Ubuntu', 'ubuntu');
	my %uol = map { $_ => 1 } @ubuntu_os_list;
	
	my @debian_os_list = ('Debian', 'debian');
	my %dol = map { $_ => 1 } @debian_os_list;
	
	my @redhat_os_list = ('Red Hat Enterprise Linux', 'redhat', 'CentOS Linux', 'Scientific Linux');
	my %rol = map { $_ => 1 } @redhat_os_list;

	# https://wiki.debian.org/DebianReleases
	my @debian_supported_versions = ('8','9');
	my %dsv = map { $_ => 1 } @debian_supported_versions;

	# https://www.ubuntu.com/info/release-end-of-life
	my @ubuntu_supported_versions = ('14.04','16.04','18.04');
	my %usv = map { $_ => 1 } @ubuntu_supported_versions;

	if (exists($sol{$distro})) {
		if ( ! $NOOK ) { show_ok_box(); print "This distro is supported by apache2buddy.pl.\n" }	
		# If the OS is deemed unsupported, we still run, but you may get errors, however any github issues raised will not
		# be entertained for unsupported or EOL OS releaases.
		if (exists($dol{$distro})) {
			my @debian_version = split('\.', $version);
                        if ( $VERBOSE ) {
                                foreach my $item (@debian_version) {
                                        print "VERBOSE: ".  $item . "\n";
                                }
                        }
			my $major_debian_version = $debian_version[0];
			if (exists($dsv{$major_debian_version})) {
				if ( ! $NOOK ) { show_ok_box(); print "This distro version is supported by apache2buddy.pl.\n" }
			} else {
				show_crit_box(); print "${RED}This distro version (${CYAN}$version${ENDC}${RED}) is not supported by apache2buddy.pl.${ENDC}\n";
				# list supported debian versions
				if ( ! $NOINFO ) { show_advisory_box(); print "${YELLOW}Supported Debian versions:${ENDC} '${CYAN}" . join("${ENDC}', '${CYAN}", @debian_supported_versions) . "${ENDC}'.\n"}
				exit;
			}
		} elsif  (exists($uol{$distro})) {
			if (exists($usv{$version})) {
				if ( ! $NOOK ) { show_ok_box(); print "This distro version is supported by apache2buddy.pl.\n" }
			} else {
				show_crit_box(); print "${RED}This distro version (${CYAN}$version${ENDC}${RED}) is not supported by apache2buddy.pl.${ENDC}\n";
				# list supported debian versions
				if ( ! $NOINFO ) { show_advisory_box(); print "${YELLOW}Supported Ubuntu (LTS ONLY) versions:${ENDC} '${CYAN}" . join("${ENDC}', '${CYAN}", @ubuntu_supported_versions) . "${ENDC}'.\n"}
				exit;
			}
		} elsif (exists($rol{$distro})) {
			# for red hat versions is not so clinical regarding the specific versions, however we need to be mindful of EOL versions eg RHEL 3, 4, 5
			# get mavjor version from version string. note that redhatm centos and scientifc are al rebuilds of the same sources, variables therefore
			# use the generic 'redhat' reference.
			if ( $VERBOSE ) { print "VERBOSE -> RedHat Version: ". $version . "\n"}
			my @redhat_version = split('\.', $version);
			if ( $VERBOSE ) {
				foreach my $item (@redhat_version) {
					print "VERBOSE: ".  $item . "\n";
				}
       			}
			my $major_redhat_version = $redhat_version[0];
			if ( $VERBOSE ) { print "VERBOSE -> Major RedHat Version Detected ". $major_redhat_version . "\n"}
			if ($major_redhat_version lt 6 ) {
				show_crit_box(); print "${RED}This distro version (${CYAN}$version${ENDC}${RED}) is not supported by apache2buddy.pl.${ENDC}\n";
				exit;
			} else {
				if ( ! $NOOK ) { show_ok_box(); print "This distro version is supported by apache2buddy.pl.\n" }
			}
		}
	} else {
		show_crit_box(); print "${RED}This distro is not supported by apache2buddy.pl.${ENDC}\n";
		# list supported OS distros
		if ( ! $NOINFO ) { show_advisory_box(); print "${YELLOW}Supported Distro's:${ENDC} '${CYAN}" . join("${ENDC}', '${CYAN}", @supported_os_list) . "${ENDC}'.\n"}
		exit;
       }
}

sub systemcheck_large_logs {
	my ($logdir) = @_;
	if ( -d $logdir ) {
		my @logs;
		my $logfiles_raw = find(sub {push @logs, $File::Find::name  if -s >= 1024000000;},  $logdir);
		foreach my $log (@logs) {
			chomp($log);
			my $size = -s $log;
			my $humansize = sprintf "%.2f", $size/1024/1024/1024;
			show_crit_box(); print $log . " --> " . $humansize . "GB\b\n";
		}
		if (@logs == 0) {
			if ( ! $NOOK ) { show_ok_box(); print "${GREEN}No large logs files were found in ${CYAN}$logdir${ENDC}.\n"; }
		} else {
			show_advisory_box(); print "${YELLOW}Consider setting up a log rotation policy.${ENDC}\n";
			show_advisory_box(); print "${YELLOW}Note: Log rotation should already be set up under normal circumstances, so very${ENDC}\n";
			show_advisory_box(); print "${YELLOW}Large error logs can indicate a fundmental issue with the website / web application.${ENDC}\n";
		}
	} 
	# silently proceed if the folder doesnt exist
}

# here we're going to build a list of the files included by the Apache 
# configuration
sub build_list_of_files {
	my ($base_apache_config,$apache_root) = @_;

	# these to arrays will contain lists of Apache configuration files
	# this is going to be the ultimate list of files that will be parsed 
	# searching for arguments
	my @master_list;
	# this will be a "scratch" space to store a list of files that 
	# currently need to be searched for more "include" lines
	my @find_includes_in;

	# put the main configuration file into the list of files we're going
	# to include
	push(@master_list,$base_apache_config);

	# put the main configuratino file into the list of files we need to 
	# search for include lines
	push(@find_includes_in,$base_apache_config);
	
	#get the Include lines from the main apache config
	@master_list = find_included_files(\@master_list,\@find_includes_in,$apache_root);
}

# here we're going to build an array holding the content of all of the 
# available configuration files
sub build_config_array {
	my ($base_apache_config,$apache_root) = @_;

	# these to arrays will contain lists of Apache configuration files
	# this is going to be the ultimate list of files that will be parsed 
	# searching for arguments
	my @master_list;

	# this will be a "scratch" space to store a list of files that 
	# currently need to be searched for more "include" lines
	my @find_includes_in;

	# put the main configuration file into the list of files we're going
	# to include
	push(@master_list,$base_apache_config);

	# put the main configuratino file into the list of files we need to 
	# search for include lines
	push(@find_includes_in,$base_apache_config);

	#get the Include lines from the main apache config
	@master_list = find_included_files(\@master_list,\@find_includes_in,$apache_root);
}

# this will find all of the files that need to be included
sub find_included_files {
	my ($master_list, $find_includes_in, $apache_root) = @_; 

	# get the number of elements in the array
	my $count = @$find_includes_in;

	# this array will eventually hold the entire apache configuration
	my @master_config_array;

	# while there are still entries in this array, keep processing
	while ( $count > 0 ) {
		my $file = $$find_includes_in[0];
		
		print "VERBOSE: Processing ".$file."\n" if $main::VERBOSE;

		if(-d $file && $file !~ /\*$/) {
			print "VERBOSE: Adding glob to ".$file.", is a directory\n" if $main::VERBOSE;
			$file .= "/" if($file !~ /\/$/);
			$file .= "*";
		}

		# open the file
		open(FILE,$file) || die("Unable to open file: ".$file."\n");
		
		# push the file into an array
		my @file = <FILE>;

		# put the file in the master configuration array
		push(@master_config_array,@file);

		# close the file
		close(FILE);

		# search the file for includes
		foreach (@file) {
			
			# this will be used to store a list of any new include
			# lines found
			# my @new_includes; 

			# if the line looks like an include, then we want to examine it
			if ( $_ =~ m/^\s*include\s+/i ) {
				# grab the included file name or file glob
				$_ =~ s/\s*include\s+(.+)\s*/$1/i;

				# strip out any quoting
				$_ =~ s/['"]+//g;

				# prepend the Apache root for files or
				# globs that are relative
				if ( $_ !~ m/^\// ) {
					$_ = $apache_root."/".$_;
				}

				# check for file globbing
				if(-d $_ && $_ !~ /\*$/) {
					print "VERBOSE: Adding glob to ".$_.", is a directory\n" if $main::VERBOSE;
					$_ .= "/" if($_ !~ /\/$/);
					$_ .= "*";
				}

				if ( $_ =~ m/.*\*.*/ ) {
					my $glob = $_;
					my @include_files;
					chomp($glob);

					# if the include is a file glob,
					# expand it and add the files
					# to the list
					my @new_includes = expand_included_files(\@include_files, $glob, $apache_root);
					push(@$master_list,@new_includes);
					push(@$find_includes_in,@new_includes);
				}
				else {
					# if it is not a glob, push the 
					# line into the configuration 
					# array
					push(@$master_list,$_);
					push(@$find_includes_in,$_);
				}
			}
			# This extra bit of code is required for apache 2.4's new directive "IncludeOptional"
			if ( $_ =~ m/^\s*includeoptional\s+/i ) {
				# grab the included file name or file glob
				$_ =~ s/\s*includeoptional\s+(.+)\s*/$1/i;

				# strip out any quoting
				$_ =~ s/['"]+//g;

				# prepend the Apache root for files or
				# globs that are relative
				if ( $_ !~ m/^\// ) {
					$_ = $apache_root."/".$_;
				}

				# check for file globbing
				if(-d $_ && $_ !~ /\*$/) {
					print "VERBOSE: Adding glob to ".$_.", is a directory\n" if $main::VERBOSE;
					$_ .= "/" if($_ !~ /\/$/);
					$_ .= "*";
				}

				if ( $_ =~ m/.*\*.*/ ) {
					my $glob = $_;
					my @include_files;
					chomp($glob);

					# if the include is a file glob,
					# expand it and add the files
					# to the list
					my @new_includes = expand_included_files(\@include_files, $glob, $apache_root);
					push(@$master_list,@new_includes);
					push(@$find_includes_in,@new_includes);
				}
				else {
					# if it is not a glob, push the 
					# line into the configuration 
					# array
					push(@$master_list,$_);
					push(@$find_includes_in,$_);
				}
			}
		}
		# trim the first entry off the array now that we have 
		# processed it
		shift(@$find_includes_in);

		# get the new count of files left to look at
		$count = @$find_includes_in;
	}

	# return the config array with the included files attached
	return @master_config_array;
}

# this will expand a glob into a list of individual files
sub expand_included_files {
	my ($include_files, $glob, $apache_root) = @_;

	# use a call to ls to get a list of the files from the glob
	my @files = `ls $glob 2> /dev/null`;

	# add the files from the glob to the array we're going to pass back
	foreach(@files) {
		chomp($_);
		push(@$include_files,$_);
		print "VERBOSE: Adding ".$_." to list of files for processing\n" if $main::VERBOSE;
	}

	# return the include_files array with the files from the glob attached
	return @$include_files;
}

# search the configuration array for a defined value that is not inside of a 
# virtual host
sub find_master_value {
	my ($config_array, $model, $config_element) = @_;

	# store our results in an array
	my @results;

	# used to control whether or not we are currently ignoring elements 
	# while searching the array
	my $ignore = 0;

	my $ignore_by_model = 0;
	my $ifmodule_count = 0;

	# apache has four available models - prefork, worker, event, and itk. only one can be
	# in use at a time. we have already determined which model is being used. We also only
	# support PreFork, any any one time three MPM's will need to be ignored.
	my $ignore_model1;
	my $ignore_model2;
	my $ignore_model3; # always ignore MPM ITK
	
	if ( $model =~ m/.*worker.*/i ) {
		$ignore_model1 = "prefork";
		$ignore_model2 = "event";
		$ignore_model3 = "itk";
	} elsif ( $model =~ m/.*event.*/i )  {
		$ignore_model1 = "worker";
		$ignore_model2 = "prefork";
		$ignore_model3 = "itk";
	} else {
		# default to prefork
		$ignore_model1 = "worker";
		$ignore_model2 = "event";
		$ignore_model3 = "itk";
	}

	print "VERBOSE: Searching Apache configuration for the ".$config_element." directive\n" if $main::VERBOSE;

	# search for the string in the configuration array
	foreach (@$config_array) {
		# ignore lines that are comments
		if ( $_ !~ m/^\s*#/ ) {
			chomp($_);

			# we ignore lines that are within a Directory, Location, 
			# File, or Virtualhost block
		
			# check to see if we have an opening tag for one of the 
			# block types listed above
			if ( $_ =~ m/^\s*<(directory|location|files|virtualhost|ifmodule\s.*$ignore_model1|ifmodule\s.*$ignore_model2|ifmodule\s.*$ignore_model3)/i ) {
				#print "Starting to ignore lines: ".$_."\n";
				$ignore = 1;
			}
			# check for a closing block to stop ignoring lines
			if ( $_ =~ m/^\s*<\/(directory|location|files|virtualhost|ifmodule)/i ) {
				#print "Starting to watch lines: ".$_."\n";
				$ignore = 0;
			}

			# if we're not ignoring lines, check and see if we've 
			# found the configuration element we're looking for
			if ( $ignore != 1 ) {		
				# if we find a match
				if ( $_ =~ m/^\s*$config_element\s+.*/i ) {
					chomp($_);
					$_ =~ s/^\s*$config_element\s+(.*)/$1/i;
					$_ =~ s/\r//g;
					push(@results,$_);
				}
			}
		}
	}

	# if we find multiple definitions for the same element, we should 
	# return the last one
	my $result;

	if ( @results > 1 ) {
		$result = $results[@results - 1];
	}
	else {
		$result = $results[0];
	}

	#Result not found
	if (@results == 0) {
		$result = "CONFIG NOT FOUND";
	}

	print "VERBOSE: $result \n" if $main::VERBOSE;
	# Ubuntu does not store the Apache user, group, or pidfile definitions 
	# in the apache2.conf file. instead, variables are in the configuration 
	# file and the real values are in /etc/apache2/envvars. this is a 
	# workaround for that behavior.
	if ( $config_element =~ m/[users|group|pidfile]/i && $result =~ m/^\$/i ) {
		if ( -e "/etc/debian_version" && -e "/etc/apache2/envvars") {
			print "VERBOSE: Using Ubuntu workaround for: ".$config_element."\n" if $main::VERBOSE;
			print "VERBOSE: Processing /etc/apache2/envvars\n" if $main::VERBOSE;

			open(ENVVARS,"/etc/apache2/envvars") || die "Could not open file: /etc/apache2/envvars\n";	
			my @envvars = <ENVVARS>;
			close(ENVVARS);

			# change "pidfile" to match Ubuntu's "pid_file" 
			# definition
			if ( $config_element =~ m/pidfile/i ) {
				$config_element = "pid_file";
			}

			foreach (@envvars) {
				if ( $_ =~ m/.*$config_element.*/i ) {
					chomp($_);
					$_ =~ s/^.*=(.*)\s*$/$1/i;
					$result = $_;
				}
			}
		}
	}

	# return the value to the main program
	return $result;
}

# this will examine the memory usage of the apache processes and return one of
# three different outputs: average usage across all processes, the memory usage
# by the largest process, or the memory usage by the smallest process
sub get_memory_usage {
	my ($process_name, $apache_user, $search_type) = @_;
	
	my (@proc_mem_usages, $result);

	# get a list of the pid's for apache running as the appropriate user
	my @pids = `ps aux | grep $process_name | grep -v root | grep $apache_user | awk \'{ print \$2 }\'`;

        # if length of @pids is still zero then die with an error.
	if (@pids == 0) {
                show_crit_box(); print ("Error getting a list of PIDs\n");
		print ("DEBUG -> Process Name: ".$process_name."\nDEBUG -> Apache_user: ".$apache_user."\nDEBUG -> Search Type: ".$search_type."\n\n");
		exit 1;
	} 
	# figure out how much memory each process is using
	foreach (@pids) {
		chomp($_);
		# pmap -d is used to determine the memory usage for the 
		# individual processes
		my $pid_mem_usage = `LANGUAGE=en_GB.UTF-8 pmap -d $_ | egrep "writeable/private" | awk \'{ print \$4 }\'`;
		$pid_mem_usage =~ s/K//;
		chomp($pid_mem_usage);

		print "VERBOSE: Memory usage by PID ".$_." is ".$pid_mem_usage."K\n" if $main::VERBOSE;
		
		# on a busy system, the grep output will return the pid for the
		# grep process itself, which will be gone by the time we get 
		# around to running pmap
		if ( $pid_mem_usage ne "" ) {
			push(@proc_mem_usages, $pid_mem_usage);
		}
	}

	# examine the array 
	if ( $search_type eq "high" ) {
		# to find the largest process, sort the values from largest to
		# smallest and take the first one
		@proc_mem_usages = sort { $b <=> $a } @proc_mem_usages;
		$result = $proc_mem_usages[0] / 1024;
	}
	if ( $search_type eq "low" ) {
		# to find the smallest process, sort the values from smallest to
		# largest and take the first one
		@proc_mem_usages = sort { $a <=> $b } @proc_mem_usages;
		$result = $proc_mem_usages[0] / 1024;
	}
	if ( $search_type eq "average" ) {
		# to get the average, add up the total amount of memory used by
		# each process, and then divide by the number of processes
		my $sum = 0; 
		my $count;
		foreach (@proc_mem_usages) {
			$sum = $sum + $_;
			$count++;
		} 

		# our result is in kilobytes, convert it to megabytes before 
		# returning it
		$result = $sum / $count / 1024;
	}
	
	# round off the result
	$result = round($result);

	return $result;
}

# this function accepts the path to a file and then tests to see whether the 
# item at that path is an Apache binary
sub test_process {
	my ($process_name) = @_;
	# THIS SUBROUTINE WORKS FINE WITH httpd4u EXECUTABLES TOO.
        # Reduce to only aphanumerics, to deal with "nginx: master process" or any newlnes
        $process_name = `echo -n $process_name | sed 's/://g'`;

	# the first line of output from "httpd -V" should tell us whether or
	# not this is Apache
	our @output;
	if ( $process_name eq '/usr/sbin/httpd' ) {
		@output = `LANGUAGE=en_GB.UTF-8 $process_name -V 2>&1 | grep "Server version"`;
		print "VERBOSE: First line of output from \"$process_name -V\": $output[0]\n" if $main::VERBOSE;
	} elsif ( $process_name eq '/usr/sbin/httpd.worker' ) {
		# Handle Worker processes better
		# BUGFIX, first identified by C. Piper Balta 
		@output = `LANGUAGE=en_GB.UTF-8 $process_name -V 2>&1 | grep "Server version"`;
		print "VERBOSE: First line of output from \"$process_name -V\": $output[0]\n" if $main::VERBOSE;
	} elsif ( $process_name eq '/usr/sbin/apache2' ) {
		@output = `LANGUAGE=en_GB.UTF-8 /usr/sbin/apache2ctl -V 2>&1 | grep "Server version"`;
		print "VERBOSE: First line of output from \"/usr/sbin/apache2ctl -V\": $output[0]\n" if $main::VERBOSE;
	} elsif ( $process_name eq '/usr/local/apache/bin/httpd' ) {
		if ( ! $NOWARN ) { show_warn_box(); print "${RED}Apache seems to have been installed from source, its technically unsupported, we may get errors${ENDC}\n" }
		@output = `LANGUAGE=en_GB.UTF-8 $process_name -V 2>&1 | grep "Server version"`;
		print "VERBOSE: First line of output from \"/usr/local/apache/bin/httpd -V\": $output[0]\n" if $main::VERBOSE;
	} else {
		# this catchall should cover all other possibilities, such as
		# nginx, varnish, etc. 
		# BUGFIX, first identified by C. Piper Balta.
		my $return_val = 0;
		return $return_val;
	}


	my $return_val = 0;
        #if ( $output eq '' ) {
        #    $return_val = 0;
        #}

	# check for output matching Apache'
        if ( $output[0] =~ m/^Server version.*Apache\/[0-9].*/ ) {
		$return_val = 1;
	} 

	return $return_val;
}

# this will return the pid for the process listening on the port specified
sub get_pid {
	my ( $port ) = @_;

	# find the pid for the software listening on the specified port. this
	# might return multiple values depending on Apache's listen directives
	my @pids = `LANGUAGE=en_GB.UTF-8 netstat -ntap | egrep "LISTEN" | grep \":$port \" | awk \'{ print \$7 }\' | cut -d / -f 1`;

	print "VERBOSE: ".@pids." found listening on port 80\n" if $main::VERBOSE;

	# set an initial, invalid PID. 
	my $pid = 0;;
	foreach (@pids) {
		chomp($_);
		$_ =~ s/(.*)\/.*/$1/;
		if ( $pid == 0 ) {
			$pid = $_;
		}
		elsif ( $pid != $_ ) {
			print "There are multiple PIDs listening on port $port.";
			exit;
		}
		else { 
			$pid = $_;
		}
	}

	# return the pid, or 0 if there is no process found
	if ( $pid eq '' ) {
		$pid = 0;
	}

	print "VERBOSE: Returning a PID of ".$pid."\n" if $main::VERBOSE;

	return $pid;
}

# this will return the path to the application running with the specified pid
sub get_process_name {
	my ( $pid ) = @_;

	print "VERBOSE: Finding process running with a PID of ".$pid."\n" if $main::VERBOSE;

	# based on the process name, we can figure out where the binary lives
	my $process_name = `ps ax | grep "\^[[:space:]]*$pid\[[:space:]]" | awk \'{print \$5 }\'`;
	chomp($process_name);

	print "VERBOSE: Found process ".$process_name."\n" if $main::VERBOSE;

	# return the process name, or 0 if there is no name found
	if ( $process_name eq '' ) {
		$process_name = 0;
	}

	return $process_name;
}

# this will return the apache root directory when given the full path to an
# Apache binary
sub get_apache_root {
	our ( $process_name ) = @_;
	our $apache_root;
	# use the identified Apache binary to figure out where the root directory is 
	# for the Apache instance
	if ( $process_name eq "/usr/sbin/apache2") {
		# use apache2ctl instead ...
		$apache_root = `apache2ctl -V 2>&1 | grep \"HTTPD_ROOT\"`;
		$apache_root =~ s/.*=\"(.*)\"/$1/;
		chomp($apache_root);
	} else {
		$apache_root = `$process_name -V 2>&1 | grep \"HTTPD_ROOT\"`;
		$apache_root =~ s/.*=\"(.*)\"/$1/;
		chomp($apache_root);
	}
	if ( $apache_root eq '' ) {
		$apache_root = 0;
	}

	return $apache_root;
}

# this will return the apache configuration file, relative to the apache root
# for the provided apache binary
sub get_apache_conf_file {
	our $apache_conf_file;
	my ( $process_name ) = @_;
	if ( $process_name eq "/usr/sbin/apache2") {
		# use apache2ctl instead ...
		$apache_conf_file = `apache2ctl -V 2>&1 | grep \"SERVER_CONFIG_FILE\"`;
		$apache_conf_file =~ s/.*=\"(.*)\"/$1/;
		chomp($apache_conf_file);
	} else {
		$apache_conf_file = `$process_name -V 2>&1 | grep \"SERVER_CONFIG_FILE\"`;
		$apache_conf_file =~ s/.*=\"(.*)\"/$1/;
		chomp($apache_conf_file);
	}
	# return the apache configuration file, or 0 if there is no result
	if ( $apache_conf_file eq '' ) {
		$apache_conf_file = 0;
	}

	return $apache_conf_file;
}


sub itk_detect {
	my ($model) = @_;
	if ( $model  =~ /(.*)itk(.*)/)  {
		show_crit_box(); print "MPM ITK was detected, apache2buddy.pl does odd things so we quit. Sorry.\n";
		show_advisory_box(); print "MPM ITK is not supported. Unload the module and try again.\n\n";
		exit;
	}
}

# this will determine whether this apache is using the worker or the prefork
# model based on the way the binary was built
sub get_apache_model {
        our $model;
        my ( $process_name ) = @_;
        if ( $process_name eq "/usr/sbin/apache2") {
                # In apache2, worker / prefork / event are no longer compiled-in.
                # Instead, with is a loaded in module
                # differing from httpd / httpd24u's process directly, in ubuntu we need to run apache2ctl.
                $model = `apache2ctl -M 2>&1 | egrep "worker|prefork|event|itk"`;
                # if we detect itk module, we need to stop immediately:
                if ($VERBOSE) { print "VERBOSE: $model" }
                if ($VERBOSE) { print "VERBOSE: ITK DETECTTOR STARTED\n" }
                itk_detect($model);
                if ($VERBOSE) { print "VERBOSE: ITK DETECTTOR PASSED\n" }
                if ($VERBOSE) { print "VERBOSE: $model" }
                chomp($model);
                if ($VERBOSE) { print "VERBOSE: $model\n" }
                if ($VERBOSE) { print "VERBOSE: REGEX Filter started.\n" }
                $model =~ s/\s*mpm_(.*)_module\s*\S*/$1/;
                if ($VERBOSE) { print "VERBOSE: REGEX Filter finished.\n" }
                if ($VERBOSE) { print "VERBOSE: $model\n" }
                if ($VERBOSE) { print "VERBOSE: Return Value: $model\n" }
                return $model;
        } else {
                $model = `apachectl -M 2>&1 | egrep "worker|prefork|event|itk"`;
                if ($VERBOSE) { print "VERBOSE: $model" }
                if ($VERBOSE) { print "VERBOSE: ITK DETECTOR STARTED\n" }
                itk_detect($model);
                if ($VERBOSE) { print "VERBOSE: ITK DETECTOR PASSED\n" }
                chomp($model);
                if ($VERBOSE) { print "VERBOSE: $model\n" }
                if ($VERBOSE) { print "VERBOSE: REGEX Filter started.\n" }
                $model =~ s/\s*mpm_(.*)_module\s*\S*/$1/;
                if ($VERBOSE) { print "VERBOSE: REGEX Filter finished.\n" }
                if ($VERBOSE) { print "VERBOSE: $model\n" }
                if ($VERBOSE) { print "VERBOSE: Return Value: $model\n" }
                return $model;
        }
}

# this will get the Apache version string
sub get_apache_version {
	my ( $process_name ) = @_;
	# set a default value
	our $version = 0;
	
	# check for red hat style spache installs
	if ( $process_name eq '/usr/sbin/httpd' || $process_name eq '/usr/sbin/httpd.worker' ) {
		$version = `LANGUAGE=en_GB.UTF-8 $process_name -V 2>&1 | grep "Server version"`;
		chomp($version);
		$version =~ s/.*:\s(.*)$/$1/;
	} elsif ( $process_name eq '/usr/sbin/apache2' ) { 
		# ubuntu has to be different, so...
                $version = `LANGUAGE=en_GB.UTF-8 /usr/sbin/apache2ctl -V 2>&1 | grep "Server version"`;
                chomp($version);
                $version =~ s/.*:\s(.*)$/$1/;
        } else {
		# check for compiled from source versions
		$version = `LANGUAGE=en_GB.UTF-8 $process_name -V 2>&1 | grep "Server version"`;
                chomp($version);
                $version =~ s/.*:\s(.*)$/$1/;
        }

	return $version;
}

# this will us ps to determine the Apache uptime. it returns an array 
sub get_apache_uptime {
	my ( $pid ) = @_;

	# this will return the running time for the given pid in the format 
	# "days-hours:minutes:seconds"
	my $uptime = `ps -eo \"\%p \%t\" | grep $pid | grep -v grep | awk \'{ print \$2 }\'`;
	chomp($uptime);

	print "VERBOSE: PID passed to uptime function: $pid\n" if $main::VERBOSE;
	print "VERBOSE: Raw uptime: $uptime\n" if $main::VERBOSE;

	# check to see if we've been running for multiple days
	my ($days, $hours, $minutes, $seconds);
	if ( $uptime =~ m/^.*-.*:.*:.*$/ ) {	
		$days = $uptime;
		$days =~ s/([0-9]*)-.*/$1/;

		# trim the days off of our uptime value
		$uptime =~ s/.*-(.*)/$1/;
	
		($hours, $minutes, $seconds) = split(':', $uptime);
	}
	elsif ( $uptime =~ m/^.*:.*:.*/ ) {
		$days = 0;
		($hours, $minutes, $seconds) = split(':', $uptime);
	}
	elsif ( $uptime =~ m/^.*:.*/) {
		$days = 0;
		$hours = 0;
		($minutes, $seconds) = split(':', $uptime);	
	}
	else {
		$days = 0;
		$hours = 0;
		$minutes = 00;
		$seconds = 00;
	}

	# push everything into an array to pass back
	my @apache_uptime = ( $days, $hours, $minutes, $seconds );

	

	return @apache_uptime;
}

# return the global value for a PHP setting
sub get_php_setting {
	my ( $php_bin, $element ) = @_;	

	# this will return an array with all of the local and global PHP 
	# settings
	
	# code to address bug raised in issue #197 (cli memory limits on debian / ubuntu)
	# sanity check if we are using cli or apache 
	my $config = `php -r "phpinfo(1);" | grep -i config | grep -i loaded`;
	chomp ($config);
	if ($VERBOSE) { print "VERBOSE: PHP: $config\n" }

	if ( $config =~ /cli/ ) {
		if ($VERBOSE) { print "VERBOSE: PHP: Attempting to find real apache php.ini file...\n" }
		# try to find the apache2 one
		if ( -f "/etc/php5/apache2/php.ini" ) {
			our $real_config = "/etc/php5/apache2/php.ini";
		} elsif ( -f "/etc/php/7.0/apache2/php.ini") {
			our $real_config = "/etc/php/7.0/apache2/php.ini";
		} elsif ( -f "/etc/php/7.0/fpm/php.ini") {
			our $real_config = "/etc/php/7.0/fpm/php.ini";
		} elsif ( -f "/etc/php/7.1/apache2/php.ini") {
                        our $real_config = "/etc/php/7.1/apache2/php.ini";
		} elsif ( -f "/etc/php/7.1/fpm/php.ini") {
			our $real_config = "/etc/php/7.1/fpm/php.ini";
                } elsif ( -f "/etc/php/7.2/apache2/php.ini") {
                        our $real_config = "/etc/php/7.2/apache2/php.ini";
		} elsif ( -f "/etc/php/7.2/fpm/php.ini") {
			our $real_config = "/etc/php/7.2/fpm/php.ini";
		}

		our $real_config;
		if ($VERBOSE) { print "VERBOSE: PHP: Real apache php.ini file is $real_config, using that...\n" }
		our @php_config_array = `php -c $real_config -r "phpinfo(4);"`;
	} else {
		our @php_config_array = `php -r "phpinfo(4);"`;
	}

	my @results;

	# search the array for our desired setting
	our @php_config_array;
	foreach (@php_config_array) {
		chomp($_);
		if ( $_ =~ m/^\s*$element\s*/ ) {
			chomp($_);
			$_ =~ s/.*=>\s+(.*)\s+=>.*/$1/;
			push(@results, $_);
		}
	}

        # if we find multiple definitions for the same element, we should 
        # return the last one (just in case)
        my $result;

        if ( @results > 1 ) {
                $result = $results[@results - 1];
        }
        else {
                $result = $results[0];
        }

	# some PHP directives are measured in MB. we want to trim the "M" off
	# here for those that are
	$result =~ s/^(.*)M$/$1/;

        # return the value to the main program
        return $result;
}

sub generate_standard_report {
	my ( $available_mem,
		$maxclients,
		$apache_proc_smallest,
		$apache_proc_average,
		$apache_proc_highest,
		$model,
		$threadsperchild,
		$mysql_memory_usage_mbytes,
		$java_memory_usage_mbytes,
		$redis_memory_usage_mbytes,
		$memcache_memory_usage_mbytes,
		$varnish_memory_usage_mbytes,
		$phpfpm_memory_usage_mbytes,
		$gluster_memory_usage_mbytes) = @_;


	our @apache_uptime;
	
	# print a report header
	print "\n\n";
	insert_hrule();
	print "${BOLD}### GENERAL FINDINGS & RECOMMENDATIONS ###${ENDC}\n"; 
	insert_hrule();
 	our $servername;
	our $public_ip_address;

	print "Apache2buddy.pl report for server: ${CYAN}$servername${ENDC} \(${CYAN}$public_ip_address${ENDC}\):\n";
	# show what we're going to use to generate our numbers
	print "\nSettings considered for this report:\n"; # exempt from NOINFO directive. 
	if ( $apache_uptime[0] == "0" ) { 
		if ( ! $NOWARN ) {
			show_crit_box(); print "${RED}*** LOW UPTIME ***${ENDC}.\n"; 
			show_advisory_box(); print "${YELLOW}The following recommendations may be misleading - apache has been restarted within the last 24 hours.${ENDC}\n\n";
		}
	}

	printf ("%-62s ${CYAN}%d %2s${CYAN}\n",   "\tYour server's physical RAM:", $available_mem, "MB"); # exempt from NOINFO directive.
	my $memory_remaining = $available_mem - $mysql_memory_usage_mbytes - $java_memory_usage_mbytes - $redis_memory_usage_mbytes - $memcache_memory_usage_mbytes - $varnish_memory_usage_mbytes - $phpfpm_memory_usage_mbytes- $gluster_memory_usage_mbytes;
	printf ("${BOLD}%-62s${ENDC} ${CYAN}%d %2s${ENDC}\n",   "\tRemaining Memory after other services considered:", $memory_remaining, "MB"); # exempt from NOINFO directive.
	if ( our $apache_version =~ m/.*\s*\/2.4.*/) {
		printf ("%-62s ${CYAN}%-8d${ENDC} %-30s\n",   "\tApache's MaxRequestWorkers directive:", $maxclients, "<--------- Current Setting"); # exempt from NOINFO directive.
	} else {	
		printf ("%-62s ${CYAN}%-8d${ENDC} %-30s\n",   "\tApache's MaxClients directive:", $maxclients, "<--------- Current Setting"); # exempt from NOINFO directive.
	}
	printf ("%-62s ${CYAN}%s${ENDC}\n",   "\tApache MPM Model:", $model); # exempt from NOINFO directive.
	if ( ! $NOINFO ) { printf ("%-62s ${CYAN}%d %2s${ENDC}\n", "\tLargest Apache process (by memory):", $apache_proc_highest, "MB") }

	if ($model eq "prefork") {
		# based on the Apache memory usage (size of the largest process, 
		# check to see if the maxclients setting for Apache is sane
		our $max_rec_maxclients = $memory_remaining / $apache_proc_highest;
		$max_rec_maxclients = floor($max_rec_maxclients);
		our $tolerance = 0.90; 
		our $min_rec_maxclients = floor($max_rec_maxclients*$tolerance);

		# determine the maximum potential memory usage by Apache
		my $max_potential_usage = $maxclients * $apache_proc_highest;
		our $max_potential_usage_pct_avail = round(($max_potential_usage/$available_mem)*100);
		our $max_potential_usage_pct_remain = round(($max_potential_usage/$memory_remaining)*100);
		if ( $maxclients >= $min_rec_maxclients and  $maxclients <= $max_rec_maxclients ) {
			if ( our $apache_version =~ m/.*\s*\/2.4.*/) {
				if ( ! $NOOK ) { show_shortok_box(); print "\t${GREEN}Your MaxRequestWorkers setting is within an acceptable range.${ENDC}\n" }
			} else {
				if ( ! $NOOK ) { show_shortok_box(); print "\t${GREEN}Your MaxClients setting is within an acceptable range.${ENDC}\n" } 
			}
			if ( our $apache_version =~ m/.*\s*\/2.4.*/) {
				printf ("${YELLOW}%-75s${ENDC} %-38s\n", "\tYour recommended MaxRequestWorkers setting is between $min_rec_maxclients and $max_rec_maxclients${ENDC}.", "<------- Acceptable Range (10% of MAX)");
			} else {
				printf ("${YELLOW}%-75s${ENDC} %-38s\n", "\tYour recommended MaxClients setting is between $min_rec_maxclients and $max_rec_maxclients${ENDC}.", "<------- Acceptable Range (10% of MAX)");
			}
			printf ("%-62s ${CYAN}%d %2s${ENDC}\n", "\tMax potential memory usage:", $max_potential_usage, "MB");  # exempt from NOINFO directive.
			printf  ("%-62s ${CYAN}%3.2f %2s${ENDC}\n", "\tPercentage of TOTAL RAM allocated to Apache:", $max_potential_usage_pct_avail, "%");  # exempt from NOINFO directive.
			printf  ("%-62s ${CYAN}%3.2f %2s${ENDC}\n", "\tPercentage of REMAINING RAM allocated to Apache:", $max_potential_usage_pct_remain, "%");  # exempt from NOINFO directive.
		} elsif ( $maxclients < $min_rec_maxclients ) {
			if ( our $apache_version =~ m/.*\s*\/2.4.*/) {
				show_crit_box(); print "\t${RED}Your MaxRequestWorkers setting is too low.${ENDC}\n"; # exempt from NOINFO directive.
			} else {
				show_crit_box(); print "\t${RED}Your MaxClients setting is too low.${ENDC}\n"; # exempt from NOINFO directive.
			}
			if ( our $apache_version =~ m/.*\s*\/2.4.*/) {
				printf ("${YELLOW}%-75s${ENDC} %-38s\n", "\tYour recommended MaxRequestWorkers setting is between $min_rec_maxclients and $max_rec_maxclients${ENDC}.", "<------- Acceptable Range (10% of MAX)");
			} else {
				printf ("${YELLOW}%-75s${ENDC} %-38s\n", "\tYour recommended MaxClients setting is between $min_rec_maxclients and $max_rec_maxclients${ENDC}.", "<------- Acceptable Range (10% of MAX)");
			}
			printf ("%-62s ${CYAN}%d %2s${ENDC}\n", "\tMax potential memory usage:", $max_potential_usage, "MB");  # exempt from NOINFO directive.
			printf  ("%-62s ${CYAN}%3.2f %2s${ENDC}\n", "\tPercentage of TOTAL RAM allocated to Apache:", $max_potential_usage_pct_avail, "%");  # exempt from NOINFO directive.
			printf  ("%-62s ${CYAN}%3.2f %2s${ENDC}\n", "\tPercentage of REMAINING RAM allocated to Apache:", $max_potential_usage_pct_remain, "%");  # exempt from NOINFO directive.
		} else {
			if ( our $apache_version =~ m/.*\s*\/2.4.*/) {
				show_crit_box(); print "\t${RED}Your MaxRequestWorkers setting is too high.${ENDC}\n"; # exempt from NOINFO directive.
			} else {
				show_crit_box(); print "\t${RED}Your MaxClients setting is too high.${ENDC}\n"; # exempt from NOINFO directive.
			}
			if ( our $apache_version =~ m/.*\s*\/2.4.*/) {
				printf ("${YELLOW}%-75s${ENDC} %-38s\n", "\tYour recommended MaxRequestWorkers setting is between $min_rec_maxclients and $max_rec_maxclients${ENDC}.", "<------- Acceptable Range (10% of MAX)");
			} else {
				printf ("${YELLOW}%-75s${ENDC} %-38s\n", "\tYour recommended MaxClients setting is between $min_rec_maxclients and $max_rec_maxclients${ENDC}.", "<------- Acceptable Range (10% of MAX)");
			}
			printf ("%-62s ${RED}%d %2s${ENDC}\n", "\tMax potential memory usage:", $max_potential_usage, "MB");  # exempt from NOINFO directive.
			printf ("%-62s ${RED}%3.2f %2s${ENDC}\n", "\tPercentage of TOTAL RAM allocated to Apache:", $max_potential_usage_pct_avail, "%");  # exempt from NOINFO directive.
			printf ("%-62s ${RED}%3.2f %2s${ENDC}\n", "\tPercentage of REMAINING RAM allocated to Apache:", $max_potential_usage_pct_remain, "%");  # exempt from NOINFO directive.
		}
		# make a logfile entry at /var/log/apache2buddy.log
		open (LOGFILE, ">>/var/log/apache2buddy.log");
		sub date {
	        	my $current_date = `date +"%Y/%m/%d %H:%M:%S"`;
       			$current_date = substr($current_date,0,-1);
       			return $current_date;
        	}
	
		if ( our $apache_version =~ m/.*\s*\/2.4.*/) {
        		print LOGFILE (date()." Model: \"Prefork\" Memory: \"$available_mem MB\" MaxRequestWorkers: \"$maxclients\" Recommended: \"$max_rec_maxclients\" Smallest: \"$apache_proc_smallest MB\" Avg: \"$apache_proc_average MB\" Largest: \"$apache_proc_highest MB\" Highest Pct Remaining RAM: \"$max_potential_usage_pct_remain%\" \($max_potential_usage_pct_avail% TOTAL RAM)\n");
		} else {
        		print LOGFILE (date()." Model: \"Prefork\" Memory: \"$available_mem MB\" Maxclients: \"$maxclients\" Recommended: \"$max_rec_maxclients\" Smallest: \"$apache_proc_smallest MB\" Avg: \"$apache_proc_average MB\" Largest: \"$apache_proc_highest MB\" Highest Pct Remaining RAM: \"$max_potential_usage_pct_remain%\" \($max_potential_usage_pct_avail% TOTAL RAM)\n");
		}
        	close(LOGFILE);
	
	}
	if ($model eq "worker") {
			print "\t${CYAN}Apache appears to be running in worker mode.\n";
			print "\tPlease check manually for backend processes such as PHP-FPM and pm.max_children.\n";
			print "\tApache2buddy does not calculate maxclients for worker model.${ENDC}\n";
			# make a logfile entry at /var/log/apache2buddy.log
			open (LOGFILE, ">>/var/log/apache2buddy.log");
			sub date {
	        		my $current_date = `date +"%Y/%m/%d %H:%M:%S"`;
       				$current_date = substr($current_date,0,-1);
       				return $current_date;
        		}
        		print LOGFILE (date()." Model: \"Worker\" Memory: \"$available_mem MB\" Maxclients: \"$maxclients\" Recommended: \"N\\A\" Smallest: \"$apache_proc_smallest MB\" Avg: \"$apache_proc_average MB\" Largest: \"$apache_proc_highest MB\"\n");
        		close(LOGFILE);
	}	
	if ($model eq "event") {
			print "\t${CYAN}Apache appears to be running in event mode.\n";
			print "\tPlease check manually for backend processes such as PHP-FPM and pm.max_children.\n";
			print "\tApache2buddy does not calculate maxclients for worker model.${ENDC}\n";
			# make a logfile entry at /var/log/apache2buddy.log
			open (LOGFILE, ">>/var/log/apache2buddy.log");
			sub date {
	        		my $current_date = `date +"%Y/%m/%d %H:%M:%S"`;
       				$current_date = substr($current_date,0,-1);
       				return $current_date;
        		}
        		print LOGFILE (date()." Model: \"Event\" Memory: \"$available_mem MB\" Maxclients: \"$maxclients\" Recommended: \"N\\A\" Smallest: \"$apache_proc_smallest MB\" Avg: \"$apache_proc_average MB\" Largest: \"$apache_proc_highest MB\"\n");
        		close(LOGFILE);
	}
	our $phpfpm_detected;
	if ( $phpfpm_detected ) {
		insert_hrule();
		print "${RED}PHP-FPM DETECTED: The results shown may be skewed, check /etc/php-fpm.d/<pool>.conf\nfor and calculate pm.max_children separately.${ENDC}\n";
		print "${RED}Check out Pieter's PHP-FPMPAL (at your own risk) at:\n\n https://github.com/pksteyn/php-fpmpal/\n\nFor advice on your PHP-FPM Pools.${ENDC}\n";
	}

	insert_hrule();
	if ( ! $NOINFO ) { 
		print "A log file entry has been made in: /var/log/apache2buddy.log for future reference.\n\n";
		print "Last 5 entries:\n\n";
		my $entries = `tail -5 /var/log/apache2buddy.log`;
		print $entries."\n";
	}
}

# this rounds a value to the nearest hundreth
sub round {
	my ( $value ) = @_;

	# add five thousandths
	$value = $value + 0.005;

	# truncat the result
	$value = sprintf("%.2f", $value);

	return $value;
}	

# print a header
sub print_header {
	my ($servername, $ipaddr) = @_;
	if ( ! $NOHEADER ) {
		my $headerstring = "apache2buddy.pl report for $servername ($ipaddr)";
		my $hrline = "#" x length($headerstring);
		print ${GREEN} . $hrline . ${ENDC} . "\n";
		print $headerstring . "\n";
		print ${GREEN} . $hrline . ${ENDC} . "\n";
	}
}

sub show_debug_box {
	print "[ ${BOLD}${BLUE}??${ENDC} ] "; 
}

sub show_advisory_box {
	print "[ $BOLD${YELLOW}\@\@${ENDC} ] "; 
}

sub show_info_box {
	print "[ ${BOLD}${BLUE}--${ENDC} ] ";
}

sub show_ok_box {
	print "[ ${BOLD}${GREEN}OK${ENDC} ] ";
}

sub show_warn_box {
	print "[ ${BOLD}${YELLOW}>>${ENDC} ] ";
}

sub show_crit_box {
	print "[ ${BOLD}${RED}!!${ENDC} ] ";
}

sub show_shortok_box {
	print "[ ${GREEN}OK${ENDC} ]";
}

sub show_important_message {
	if ( ! $NOINFO ) {
		print "\n${YELLOW}** IMPORTANT MESSAGE **\nImportant messages go here.${ENDC}\n";
	}
}

sub insert_hrule() {
	print "-" x 80;
	print "\n";
}

sub preflight_checks {
	# There will be other showstoppers that become apparent as the script develops in execution,
	# however we can capture the common "basic errors" here, and gracefully exit with useful errors.
	
	# Check 1
	# make sure the script is being run as root.
	# we need to run as root to ensure that we can access all of the appropriate
	# files
	my $uid = `id -u`;
	chomp($uid);

	print "VERBOSE: UID of user is: ".$uid."\n" if $VERBOSE;

	if ( $uid ne '0' ) {
		show_crit_box();
 	      	print "This script must be run as root.\n";
        	exit;
	} else {
		if ( ! $NOOK ) { show_ok_box(); print "This script is being run as root.\n" }
	}

	# Check 2
	# this script uses pmap to determine the memory mapped to each apache 
	# process. make sure that pmap is available.
	our $pmap = `which pmap`;
	chomp($pmap);

	# make sure that pmap is available within our path
	if ( $pmap !~ m/.*\/pmap/ ) { 
		show_crit_box(); 
		print "Unable to locate the pmap utility. This script requires pmap to analyze Apache's memory consumption.\n";
		exit;
	} else {
		if ( ! $NOOK ) { show_ok_box(); print "The utility 'pmap' exists and is available for use: ${CYAN}$pmap${ENDC}\n" }
	}

	# Check 2.1
	# this script uses netstat to determine the port that apache is listening on
	# process. make sure that netstat is available.
	our $netstat = `which netstat`;
	chomp($netstat);

	# make sure that netstat is available within our path
	if ( $netstat !~ m/.*\/netstat/ ) { 
		show_crit_box(); 
		print "Unable to locate the netstat utility. This script requires netstat to determine the port that apache is listening on.\n";
		show_info_box(); print "${YELLOW}To fix this make sure the net-tools package is installed.${ENDC}\n";
		exit;
	} else {
		if ( ! $NOOK ) { show_ok_box(); print "The utility 'netstat' exists and is available for use: ${CYAN}$netstat${ENDC}\n" }
        }

	# Check 3
	# make sure PHP is available before we proceed
	# check to see if there is a binary called "php" in our path
	my $check = `which php`;
	chomp ($check);
	if ( $check !~ m/.*\/php/ ) {
		if ( ! $NOWARN ) {
			show_advisory_box();
			print "${YELLOW}Unable to locate the PHP binary. PHP specific checks will be skipped.${ENDC}\n";
		}
		our $PHP = 0;
		my $path = `echo \$PATH`;
		chomp($path);
		print "VERBOSE: Path: $path\n" if $VERBOSE;
	} else {	
		if ( ! $NOOK ) { show_ok_box(); print "'php' exists and is available for use: ${CYAN}$check${ENDC}\n" }
		our $PHP = 1; 
	}

	# check 3.1 
	# Check for which apachectl we are to use
	# check to see if there is a binary called "apachectl" in our path
	our $apachectl= `which apachectl`;
	chomp($apachectl);

	if ( $apachectl !~ m/.*\/apachectl/ ) {
                show_info_box();
                print "Unable to locate the apachectl utility. This script requires apachectl to analyze Apache's vhost configurations.\n";
                show_info_box();
                print "Not fatal yet, trying to locate the apache2ctl utility instead.\n";
		# check to see if there is a binary called "apache2ctl" in our path
		our $apachectl= `which apache2ctl`;
		chomp($apachectl);
	
		if ( $apachectl !~ m/.*\/apache2ctl/ ) {
       		        show_crit_box();
              		print "Unable to locate the apache2ctl utility. This script now requires apache2ctl to analyze Apache's vhost configurations.\n";
       		        show_info_box();
              		print "It looks like you might be running something else, other than apache..\n";
			exit;
        	} else {
                	if ( ! $NOOK ) { show_ok_box(); print "The utility 'apache2ctl' exists and is available for use: ${CYAN}$apachectl${ENDC}\n" }
        	}

        } else {
                if ( ! $NOOK ) { show_ok_box(); print "The utility 'apachectl' exists and is available for use: ${CYAN}$apachectl${ENDC}\n" }
        }

	# check 3.2 
	# Check for python (new in Debian 9  as it doesnt come with it out of the box)
	our $python = `which python`;
	chomp($python);


	if ( $python !~ m/.*\/python/ ) {
		show_crit_box(); 
		print "Unable to locate the python binary.\n";
                print "Trying for python3...\n";
                our $python = `which python3`;
                chomp($python);


                if ( $python !~ m/.*\/python3/ ) {
                        show_crit_box();
                        print "Unable to locate the python3 binary. This script requires python to determine the Operating and Version.\n";
                        show_info_box(); print "${YELLOW}To fix this make sure the python or python3 package is installed.${ENDC}\n";
                        exit;
                } else {
                        if ( ! $NOOK ) { show_ok_box(); print "The 'python' binary exists and is available for use: ${CYAN}$python${ENDC}\n" }
                }
	} else {
		if ( ! $NOOK ) { show_ok_box(); print "The 'python' binary exists and is available for use: ${CYAN}$python${ENDC}\n" }
	}

	

	# Check 4
	# Check for valid port
	if ( $port < 0 || $port > 65534 ) {
		show_crit_box();
		print "INVALID PORT: $port. ";
		print "Valid port numbers are 1-65534.\n";
		exit;
	} else {
		if ( ! $NOOK ) { show_ok_box(); print "The port \(port ${CYAN}$port${ENDC}\) is a valid port.\n" }
	}
	
	# Check 5
	# Get OS Name and Version
	if ( ! $NOINFO ) { show_info_box(); print "We are attempting to discover the operating system type and version number ...\n" }
	my ($distro, $version, $codename) = get_os_platform();
	if ( $distro ) { 
		chomp($distro);
		chomp($version);
		chomp($codename);
		if ( ! $NOINFO ) { show_info_box(); print "Distro: ${CYAN}" . $distro . "${ENDC}\n"}	
		if ( ! $NOINFO ) { show_info_box(); print "Version: ${CYAN}" . $version . "${ENDC}\n"}	
		if ( ! $NOINFO ) { show_info_box(); print "Codename: ${CYAN}" . $codename . "${ENDC}\n"}	
		check_os_support($distro, $version, $codename);
	} else {
		# fallback when python fails to deliver - eg on CentOS5 which is EOL anyway, we get:
		# Traceback (most recent call last):
		#   File "<string>", line 1, in ?
		#   AttributeError: 'module' object has no attribute 'linux_distribution'
		#
		# This is dues to Python 2.4.3 being used, which is too old.
		if ( ! $NOINFO ) { print "${YELLOW}Couldnt determine OS version as your python version is too old, trying older python code...${ENDC}\n" }
		my ($distro, $version, $codename) = get_os_platform_older();
		if ( $distro ) { 
			chomp($distro);
			chomp($version);
			chomp($codename);
			if ( ! $NOINFO ) { show_info_box(); print "Distro: ${CYAN}" . $distro . "${ENDC}\n"}	
			if ( ! $NOINFO ) { show_info_box(); print "Version: ${CYAN}" . $version . "${ENDC}\n"}	
			if ( ! $NOINFO ) { show_info_box(); print "Codename: ${CYAN}" . $codename . "${ENDC}\n"}	
			check_os_support($distro, $version, $codename);
		}
	}		 

	# get our hostname
	our $servername = get_hostname();
	if ( ! $NOINFO ) { show_info_box(); print "Hostname: ${CYAN}$servername${ENDC}\n" }

	# get our ip address
	our $public_ip_address = get_ip();
	if ( ! $NOINFO ) { show_info_box();  print "Primary IP: ${CYAN}$public_ip_address${ENDC}\n" }

	
	# Check 6
	# first thing we do is get the pid of the process listening on the 
	# specified port
	if ( ! $NOINFO ) { show_info_box(); print "We are checking the service running on port ${CYAN}$port${ENDC}...\n" }

	our $pid;
	if (! $pid ) {  
		our $pid = get_pid($port);
	}
	
	print "VERBOSE: PID is ".$pid."\n" if $VERBOSE;
	
	if ( $pid eq 0 ) {
		if ( ! $NOWARN ) {
			show_warn_box; print "${YELLOW}Nothing seems to be listening on port $port.${ENDC} Falling back to process list...\n";
		}
		my @process_info = split(' ', `ps -C 'httpd httpd.worker apache apache2' -f | grep '^root'`);
		$pid = $process_info[1];
		if ( not $pid ) {
                        show_crit_box; print "apache process not found.\n";
                        exit;
                } else {
                        my $command = `netstat -plnt | egrep "httpd|apache2"`;
                        if ( $command =~ /:+(\d+)/ ) { our $real_port = $1 }
                        our $real_port;
                        our $process_name = get_process_name($pid);
                        our $apache_version = get_apache_version($process_name);
                        if ( ! $NOINFO ) { show_info_box; print "Apache is actually listening on port ${CYAN}$real_port${ENDC}\n" }
                        if ( ! $NOINFO ) { show_info_box; print "The process running on port ${CYAN}$real_port${ENDC} is ${CYAN}$apache_version${ENDC}.\n" }
                }
	} else {	
		# now we get the name of the process running with the specified pid
		our $process_name = get_process_name($pid);
		if ( ! $NOINFO ) { show_info_box; print "The process listening on port ${CYAN}$port${ENDC} is ${CYAN}$process_name${ENDC}\n" }
		
		if ( $process_name eq 0 ) {
			show_crit_box();
			print "Unable to determine the name of the process. Is apache running on this server?\n";
			exit;
		}
	
		# Check 7
		# check to see if the process we have identified is Apache
		our $is_it_apache = test_process($process_name);
	
		if ( $is_it_apache == 1 ) {
			our $apache_version = get_apache_version($process_name);
		
			print "VERBOSE: Apache version: $apache_version\n" if $VERBOSE;
		
			# if we received a "0", just print "Apache"
			if ( $apache_version eq 0 ) {
				$apache_version = "Apache";	
			}
			if ( ! $NOINFO ) { show_info_box; print "The process running on port ${CYAN}$port${ENDC} is ${CYAN}$apache_version${ENDC}.\n" }
		}  else {
			if ( ! $NOINFO ) { show_info_box; print "The process running on port $port is not Apache. Falling back to process list...\n" }
			my @process_info = split(' ', `ps -C 'httpd httpd.worker apache apache2' -f | grep '^root'`);
			$pid = $process_info[1];
	
			if ( !$pid ) {
				show_crit_box();
		                print "Could not find Apache process. Exiting...\n";
				exit;
		        } else {
				# If we found it, then reset the proces_name, and version.
				$process_name = get_process_name($pid);
				our $apache_version = get_apache_version($process_name);
				# also report what port apache is actually listening on.
				my $command = `netstat -plnt | egrep "httpd|apache2"`;
				if ( $command =~ /:+(\d+)/ ) { our $real_port = $1 }
				our $real_port;
				if ( ! $NOINFO ) { show_info_box; print "Apache is actually listening on port ${CYAN}$real_port${ENDC}\n" }
				if ( ! $NOINFO ) { show_info_box; print "The process running on port ${CYAN}$real_port${ENDC} is ${CYAN}$apache_version${ENDC}.\n" }
			}
		}
	}
	

	# Check 8
	# Due to logic error, moved this check to 13.2
	# Check apache uptime needs parent PID not a child pid.

	# Check 9
	# find the apache root	
	our $process_name;
	our $apache_root = get_apache_root($process_name);
	print "VERBOSE: The Apache root is: ".$apache_root."\n" if $VERBOSE;
	
	# check 10
	# find the apache configuration file (relative to the apache root)
	our $apache_conf_file = get_apache_conf_file($process_name);
	print "VERBOSE: The Apache config file is: ".$apache_conf_file."\n" if $VERBOSE;
	
	# check 11
	# piece together the full path to the configuration file, if a server 
	# does not have the HTTPD_ROOT value defined in its apache build, then
	# try just using the path to the configuration file
	our $full_apache_conf_file_path;
	if ( -e $apache_conf_file ) {
		$full_apache_conf_file_path = $apache_conf_file;
		if ( ! $NOINFO ) { show_info_box(); print "The full path to the Apache config file is: ${CYAN}$full_apache_conf_file_path${ENDC}\n" }
	} elsif ( -e $apache_root."/".$apache_conf_file ) {
		$full_apache_conf_file_path = $apache_root."/".$apache_conf_file;
		if ( ! $NOINFO ) { show_info_box(); print "The full path to the Apache config file is: ${CYAN}$full_apache_conf_file_path${ENDC}\n" }
	} else {
		show_crit_box();
		print "Apache configuration file does not exist: ".$full_apache_conf_file_path."\n";
		exit;
	}
	
	# check 12
	# find out what model we are running
	our $model = get_apache_model($process_name);	
	if ( $model eq 0 ) {
		show_crit_box();
		print "Unable to determine whether Apache is using worker or prefork\n";
		exit;
	} else {
                # account for '\x{d}' strangeness
                $model =~ s/\x{d}//;
                if ( ! $NOINFO ) { show_info_box(); print "Apache is using ${CYAN}$model${ENDC} model.\n" }
	}
	
	# Check 13	
	# get the entire config, including included files, into an array
	our @config_array = build_config_array($full_apache_conf_file_path,$apache_root);
	# determine what user apache runs as 
	our $apache_user = find_master_value(\@config_array, $model, 'user');
        # account for 'apache\x{d}' strangeness
        $apache_user =~ s/\x{d}//;
        $apache_user =~ s/^\s*(.*?)\s*$/$1/;; # address issue #19, strip whitespace from both sides.
	unless ($apache_user eq "apache" or $apache_user eq "www-data") {
                my $apache_userid = `id -u $apache_user`;
                chomp($apache_userid);
                # account for 'apache\x{d}' strangeness
                $apache_user =~ s/\x{d}//;
                show_warn_box(); print ("${RED}Non-standard apache set-up, apache is running as UID: ${CYAN}$apache_userid${RED} (${CYAN}$apache_user${RED}). Expecting UID 48 ('apache' or 'www-data').${ENDC}\n");
		if ( ! $NOINFO ) { show_info_box(); print "Apache runs as ${CYAN}$apache_user${ENDC}.\n" }
        }	
	
	if (length($apache_user) > 8) {
		# Now we have to keep the first 7 characters and change the 8th character to a + sign, eg 'developer' becomes 'develop+'
		my $original_user = $apache_user;
		$apache_user = substr($original_user, 0, 7)."+";
	}

	# Check 13.1
	# Determine the size of the parent process
	# Bug Out if greater than 50MB
	if ( ! $NOCHKPID) {
		our $pidfile_cfv = find_master_value(\@config_array, $model, 'pidfile');
		if ( ! $NOINFO ) { show_info_box; print "pidfile setting is ${CYAN}$pidfile_cfv${ENDC}.\n" } 
		# addressing issue #84, I realised this whole block of code is guessing, I inderstand why, but its not sane.
		# for example what we need to do is first check if the path is a relative path or absolute path.
		# If it is an absolute path, lets check that first, which will cut out a lot of unnescesary code, 
		# otherwise we can start guessing based on common relative paths.
		#  Fix for Issue #222 strip any quotes from returned string
		#  "/var/run/httpd.pid" becomes /var/run/httpd.pid
		if ($VERBOSE) { print "VERBOSE: Stripping any quotes from string ...\n" }
		if ($VERBOSE) { print "VERBOSE: BEFORE ($pidfile_cfv).\n" }
		$pidfile_cfv =~ s/^"(.*)"$/$1/;
		$pidfile_cfv =~ s/^'(.*)'$/$1/;
		if ($VERBOSE) { print "VERBOSE: AFTER ($pidfile_cfv).\n" }
		if ( -f $pidfile_cfv ) {
			our $pidfile =$pidfile_cfv;
		} else {
			if ($pidfile_cfv eq "run/httpd.pid") {
				# it could be in a couple of places, so lets test!
				if (-f "/var/run/httpd/httpd.pid") {
					our $pidfile = "/var/run/httpd/httpd.pid";
				} elsif (-f "/run/httpd/httpd.pid") {
					our $pidfile = "/run/httpd/httpd.pid";
				} elsif (-f "/var/run/httpd.pid") {
					our $pidfile = "/var/run/httpd.pid";
				} else {
					if ( ! $NOINFO ) { show_crit_box; print "${RED}Unable to locate pid file${ENDC}. Exiting.\n" } 
					exit;
				}
			} elsif ($pidfile_cfv eq "/var/run/apache2/apache2\$SUFFIX.pid") {
				our $pidfile = "/var/run/apache2/apache2.pid";
			} elsif ($pidfile_cfv eq "/var/run/apache2\$SUFFIX.pid") {
				our $pidfile = "/var/run/apache2.pid";
			} elsif ($pidfile_cfv eq "/var/run/apache2\$SUFFIX/apache2.pid") {
				our $pidfile = "/var/run/apache2/apache2.pid";
			} else {
				# revert to a find command as a last ditch effort to find the pid
				if ($VERBOSE) { print "VERBOSE: Looking for pid file ...\n" }
                                if ( -d "/var/run/apache2") {
                                        our $pidguess = `find /var/run/apache2 | grep pid`;
                                } elsif ( -d "/run/httpd") {
                                        our $pidguess = `find /run/httpd | grep pid`;
                                } elsif ( -d "/var/run/httpd") {
                                        our $pidguess = `find /var/run/httpd | grep pid`;
                                } else {
                                        show_crit_box; print "${RED}Unable to locate pid file${ENDC}. Exiting.\n";
                                        exit;
                                }
                                our $pidguess;
                                chomp($pidguess);
                                if ( -f $pidguess ) {
                                        our $pidfile = $pidguess;
                                        if ($VERBOSE) { print "VERBOSE: Located pidfile at $pidfile.\n" }
                                } else {
                                        show_crit_box; print "${RED}Unable to locate pid file${ENDC}. Exiting.\n";
                                        exit;
                                }
			}
		}
	
		our $pidfile;
		if (-f $pidfile) {
			if ( ! $NOINFO ) { show_info_box; print "Actual pidfile is ${CYAN}$pidfile${ENDC}.\n" } 
		} else {
			if ( ! $NOINFO ) { show_crit_box; print "${RED}Unable to open pid file $pidfile${ENDC}. Exiting.\n" } 
			exit;
		}
		# get pid
		our $pidfile;
		our $parent_pid = `cat $pidfile`;
		chomp($parent_pid);
		if ( ! $NOINFO ) { show_info_box; print "Parent PID: ${CYAN}$parent_pid${ENDC}.\n" }
		my $ppid_mem_usage = `LANGUAGE=en_GB.UTF-8 pmap -d $parent_pid | egrep "writeable/private" | awk \'{ print \$4 }\'`;
		$ppid_mem_usage =~ s/K//;
		chomp($ppid_mem_usage);
		if ($ppid_mem_usage > 50000) {
			show_crit_box; print "${RED}Memory usage of parent PID is greater than 50MB: $ppid_mem_usage Kilobytes${ENDC}.\n";
			show_info_box; print "For more information, see https://github.com/richardforth/apache2buddy/wiki/50MB-Parent-PID-Issue\n";
			show_advisory_box; print "If you are desperate, try -P or --no-check-pid.\n";
			show_info_box; print "Exiting.\n";
			exit;
		} else {
			if ( ! $NOOK ) { show_ok_box; print "Memory usage of parent PID is less than 50MB: ${CYAN}$ppid_mem_usage Kilobytes${ENDC}.\n" }
		}
	}

	# Check 13.2
	# determine the Apache uptime
	our $parent_pid;
	our @apache_uptime = get_apache_uptime($parent_pid);
	
	if ( ! $NOINFO ) { show_info_box(); print "Apache has been running ${CYAN}$apache_uptime[0]${ENDC}d ${CYAN}$apache_uptime[1]${ENDC}h ${CYAN}$apache_uptime[2]${ENDC}m ${CYAN}$apache_uptime[3]${ENDC}s.\n" }
	if ( $apache_uptime[0] == "0" ) { 
		if ( ! $NOWARN ) { 
			show_crit_box(); print "${RED}*** LOW UPTIME ***${ENDC}.\n"; 
			show_advisory_box(); print "${YELLOW}The following recommendations may be misleading - apache has been restarted within the last 24 hours.${ENDC}\n";
		}
	}

	# check 13.3
	# figure out how much RAM is in the server
	our $available_mem = `LANGUAGE=en_GB.UTF-8 free | grep \"Mem:\" | awk \'{ print \$2 }\'` / 1024;
	$available_mem = floor($available_mem);

	if ( ! $NOINFO ) { show_info_box(); print "Your server has ${CYAN}$available_mem MB${ENDC} of PHYSICAL memory.\n" }

	# Check 14
	# Get serverlimit value
	our $serverlimit = find_master_value(\@config_array, $model, 'serverlimit');
	if($serverlimit eq 'CONFIG NOT FOUND') {
		if ( ! $NOWARN ) { show_warn_box; print "ServerLimit directive not found, assuming default values.\n" }
			our $model;
			if ( $model eq "prefork") {
				# Default for prefork - see http://httpd.apache.org/docs/current/mod/mpm_common.html#serverlimit
				$serverlimit = 256; # yes, yes I know, but keeping the variable name saves a whole bunch of code just for semantics.
			} else {
				# Default for Worker
				$serverlimit = 16; # yes, yes I know, but keeping the variable name saves a whole bunch of code just for semantics.
			}
	}
	# account for '\x{d}' strangeness
	$serverlimit =~ s/\x{d}//;
	if ( ! $NOINFO ) { show_info_box();  print "Your ServerLimit setting is ${CYAN}$serverlimit${ENDC}.\n" }

	# Check 15
	# calculate ThreadsPerChild. This is useful for the worker MPM calculations
	if ( $model eq "worker" || $model eq "event" ) {
		our $threadsperchild = find_master_value(\@config_array, $model, 'threadsperchild');
		if($threadsperchild eq 'CONFIG NOT FOUND') {
			if ( ! $NOWARN ) { show_warn_box; print "ThreadsPerChild directive not found, assuming default values.\n" }
			$threadsperchild = 25;
		}
		if ( ! $NOINFO ) { show_info_box();  print "Your ThreadsPerChild setting is ${CYAN}$threadsperchild${ENDC}.\n" }
	}
	our $threadsperchild;
	if ($model eq "worker" || $model eq "event" ) {
		if ( ! $NOINFO ) { show_info_box(); print "Your ThreadsPerChild setting for worker MPM is  ".$threadsperchild."\n" }
		if ( ! $NOINFO ) { show_info_box(); print "Your ServerLimit setting for worker MPM is  ".$serverlimit."\n" }
	}

	# Check 16
	# determine what the max clients setting is 
	# if apache2.4 get maxrequestworkers 
	if ( our $apache_version =~ m/.*\s*\/2.4.*/) {
		our $maxclients = find_master_value(\@config_array, $model, 'maxrequestworkers');
		if($maxclients eq 'CONFIG NOT FOUND') {
			if ( ! $NOWARN ) { show_warn_box; print "MaxRequestWorkers directive not found, assuming default values.\n" }
			if ( $model eq "prefork") {
				# Default for prefork - see http://httpd.apache.org/docs/2.4/mod/mpm_common.html#maxrequestworkers
				$maxclients = 256; # yes, yes I know, but keeping the variable name saves a whole bunch of code just for semantics.
			} else {
				# Default for Worker
				$maxclients = $serverlimit * $threadsperchild; # yes, yes I know, but keeping the variable name saves a whole bunch of code just for semantics.
			}
				
		}
		# account for '\x{d}' strangeness
		$maxclients =~ s/\x{d}//;
		$maxclients =~ s/\s//;
		if ( ! $NOINFO ) { show_info_box();  print "Your MaxRequestWorkers setting is ${CYAN}$maxclients${ENDC}.\n" }
	} else {
		# otherwise, assume 2.2 and get maxclients
		our $maxclients = find_master_value(\@config_array, $model, 'maxclients');
		if($maxclients eq 'CONFIG NOT FOUND') {
			if ( ! $NOWARN ) { show_warn_box; print "MaxClients directive not found, assuming default values.\n" }
			if ( $model eq "prefork") {
				# Default for prefork - see https://httpd.apache.org/docs/2.2/en/mod/mpm_common.html#maxclients
				$maxclients = 256; # yes, yes I know, but keeping the variable name saves a whole bunch of code just for semantics.
			} else {
				# Default for Worker
				$maxclients = $serverlimit * $threadsperchild; # yes, yes I know, but keeping the variable name saves a whole bunch of code just for semantics.
			}
		}
		# account for '\x{d}' strangeness
		$maxclients =~ s/\x{d}//;
		$maxclients =~ s/\s//;
		if ( ! $NOINFO ) { show_info_box();  print "Your MaxClients setting is ${CYAN}$maxclients${ENDC}.\n" }
	}

	# Check 16.01
	# Check if maxclients is more than ServerLimit
	# Then set maxclients to serverlimit if serverlimit is LESS than MaxClients
	our $maxclients;
	our $serverlimit;
	if ($maxclients > $serverlimit) {
		$maxclients = $serverlimit;
		 if ( ! $NOWARN ) { show_warn_box; print "MaxClients directive is higher than ServerLimit, using ServerLimit ($serverlimit) to apply calculations.\n" }
	}


	# Check 16.1
	# Get current number of running apache processes
	# This resolves Issue #15: https://github.com/richardforth/apache2buddy/issues/15
	our $maxclients;
	our $current_proc_count = `ps aux | egrep "httpd|apache2" | grep -v apache2buddy | grep -v grep | wc -l`;
	chomp ($current_proc_count);
	if ($current_proc_count >= $maxclients) {
		if ( ! $NOWARN ) { show_warn_box(); print "Current Apache Process Count is ${RED}$current_proc_count${ENDC}, including the parent PID.\n" }
	} else {
		if ( ! $NOOK ) { show_ok_box(); print "Current Apache Process Count is ${CYAN}$current_proc_count${ENDC}, including the parent PID.\n"} 
	}

	# Check 16.2
	# Get current number of vhosts
	# This addresses issue #5 'count of vhosts': https://github.com/richardforth/apache2buddy/issues/5 
	# address https://github.com/richardforth/apache2buddy/issues/239 Plesk vhost counts always out
	our $vhost_count = `LANGUAGE=en_GB.UTF-8 $apachectl -S 2>&1 | egrep -v "lists|default|webmail" | grep -c "[ ]\\{1,\\}port [0-9]\\{1,\\}"`;
	# split this total into port 80 and 443 vhosts respectively: https://github.com/richardforth/apache2buddy/issues/142
	our $port80vhost_count = `LANGUAGE=en_GB.UTF-8 $apachectl -S 2>&1 | egrep -v "lists|default|webmail" | grep -c "port 80 "`;
	our $port443vhost_count = `LANGUAGE=en_GB.UTF-8 $apachectl -S 2>&1 | egrep -v "lists|default|webmail" | grep -c "port 443 "`;
	our $port7080vhost_count = `LANGUAGE=en_GB.UTF-8 $apachectl -S 2>&1 | egrep -v "lists|default|webmail" | grep -c "port 7080 "`;
	our $port7081vhost_count = `LANGUAGE=en_GB.UTF-8 $apachectl -S 2>&1 | egrep -v "lists|default|webmail" | grep -c "port 7081 "`;
	# in case apache2ctl not working, try apachectl
	chomp ($vhost_count);
	chomp ($port80vhost_count);
	chomp ($port443vhost_count);
	chomp ($port7080vhost_count);
	chomp ($port7081vhost_count);
	if ( ! $NOINFO ) { show_info_box(); print "Number of vhosts detected: ${CYAN}$vhost_count${ENDC}.\n" }
	if ($port80vhost_count gt 0 ) {
		if ( ! $NOINFO ) { show_info_box(); print "            |________ of which ${CYAN}$port80vhost_count${ENDC} are HTTP (specifically, port 80).\n" }
	}
	if ($port443vhost_count gt 0 ) {
		if ( ! $NOINFO ) { show_info_box(); print "            |________ of which ${CYAN}$port443vhost_count${ENDC} are HTTPS (specifically, port 443).\n" }
	}
	if ($port7080vhost_count gt 0 ) {
		if ( ! $NOINFO ) { show_info_box(); print "            |________ of which ${CYAN}$port7080vhost_count${ENDC} are HTTP (specifically, port 7080).\n" }
	}
	if ($port7081vhost_count gt 0 ) {
		if ( ! $NOINFO ) { show_info_box(); print "            |________ of which ${CYAN}$port7081vhost_count${ENDC} are HTTPS (specifically, port 7081).\n" }
	}
	our $real_port;
	if ($real_port) {
		if ( not( $real_port =~ /^(80|443|7080|7081)$/ )) {
			our $portXvhost_count = `LANGUAGE=en_GB.UTF-8 $apachectl -S 2>&1 | egrep -v "lists|default|webmail" | grep -c "port $real_port "`;
			chomp ($portXvhost_count);
			if ($portXvhost_count gt 0 ) {
				if ( ! $NOINFO ) { show_info_box(); print "            |________ of which ${CYAN}$portXvhost_count${ENDC} are listening on nonstandard port ${CYAN}$real_port${ENDC}.\n" }
			}
		}
	}
	if ($vhost_count >= $maxclients) {
		if ( our $apache_version =~ m/.*\s*\/2.4.*/) {
			if ( ! $NOWARN ) { show_advisory_box(); print "${YELLOW}Current Apache vHost Count is greater than maxrequestworkers, which is unusual, but can be valid in some scenarios.${ENDC}\n" }
		} else {
			if ( ! $NOWARN ) { show_advisory_box(); print "${YELLOW}Current Apache vHost Count is greater than maxclients, which is unusual, but can be valid in some scenarios.${ENDC}\n" }
		}
	} else {
		if ( our $apache_version =~ m/.*\s*\/2.4.*/) {
			if ( ! $NOOK ) { show_ok_box(); print "Current Apache vHost Count is ${CYAN}less than maxrequestworkers${ENDC}.\n" } 
		} else {
			if ( ! $NOOK ) { show_ok_box(); print "Current Apache vHost Count is ${CYAN}less than maxclients${ENDC}.\n" }
		}
	}
	if ( $vhost_count == 0 ) {
		if ( ! $NOWARN ) { show_advisory_box(); print "${YELLOW}vHost Count works only when we have NameVirtualHosting enabled, check config manually, they may only have the default vhost.${ENDC}\n" }
	}

	# Check 17 
	# show MaxRequestsPerChild (applies only to PreFork model)
	if ( $model eq "prefork") {
		our $maxrequestsperchild = find_master_value(\@config_array, $model, 'MaxRequestsPerChild');
		if($maxrequestsperchild eq 'CONFIG NOT FOUND') {
			if ( ! $NOWARN ) { show_warn_box; print "MaxRequestsPerChild directive not found.\n" }
		} else {
			if ( ! $NOINFO ) { show_info_box();  print "Your MaxRequestsPerChild setting is ${CYAN}$maxrequestsperchild${ENDC}.\n" }
		}
	}		

	# check #17a-1 detect control panels 
	detect_plesk_version();
	detect_cpanel_version();
	detect_virtualmin_version();

	# Check 17b
	# Display the php memory limit
	# Note that we do nothing with this in terms of calculations
	# Use it as a conversation starter, esp if memory_limit is 3GB! as this is a per-process setting!
	# get the PHP memory limit
	# This has been abstracted to a separate subroutine
	our $PHP;
	if ($PHP) {
		detect_php_memory_limit();
	}

	# Check 17c : Other Services
	# This has been abstracted out into a separate subroutine
	detect_additional_services();

	# Check 17d : Large Logs in /var/log
	systemcheck_large_logs("/var/log/httpd");
	systemcheck_large_logs("/var/log/apache2");
	systemcheck_large_logs("/var/log/php-fpm");
	systemcheck_large_logs("/usr/local/apache/logs");
	systemcheck_large_logs("/usr/local/apache2/logs");
	systemcheck_large_logs("/usr/local/httpd/logs");

	# Check 19 : Maxclients Hits
	# This has been abstracted out into a separate subroutine
	if ( ! $SKIPMAXCLIENTS ) { 
		detect_maxclients_hits($model, $process_name) 
	} else {
		if ( ! $NOINFO ) { show_advisory_box(); print "Skipping Maxclients Hits check.\n" }
	}

	# Check 20 : PHP Fatal Errors
	# This has been abstracted out into a separate subroutine
	# This addresses issue #6 'Check for and report on PHP Fatal Errors in the logs'
	if ( ! $SKIPPHPFATAL ) {
		if ($PHP) {
			detect_php_fatal_errors($model, $process_name);
		}
	} else {
		if ( ! $NOINFO ) { show_advisory_box(); print "Skipping PHP FATAL Errors check.\n" }
	}

	# Check 21 : Apache updates
	if ( ! $SKIPUPDATES ) {
		detect_package_updates() 
	} else {
		if ( ! $NOINFO ) { show_advisory_box(); print "Skipping Package Updates check.\n" }
	}
}

sub detect_package_updates {
	my ($distro, $version, $codename) = get_os_platform();
	our $package_update = 0;
	if (ucfirst($distro) eq "Ubuntu" or ucfirst($distro) eq "Debian" ) {
		$package_update = `apt-get update 2>&1 >/dev/null && dpkg --get-selections | xargs apt-cache policy | grep -1 Installed | sed -r 's/(:|Installed: |Candidate: )//' | uniq -u | tac | sed '/--/I,+1 d' | tac | sed '\$d' | sed -n 1~2p | egrep "^php|^apache2"`;
	} else {
		$package_update = `yum check-update | egrep "^httpd|^php"`;
	}
	if ($package_update) {
		if ( ! $NOWARN ) {
			show_crit_box(); print "${RED}Apache and / or PHP has a pending package update available.${ENDC}\n";
			print "${YELLOW}$package_update${ENDC}";
		}
	} else {
		if (-d "/usr/local/httpd" or -d "/usr/local/apache" or -d "/usr/local/apache2") {
			if ( ! $NOWARN ) { show_warn_box(); print "${RED}It looks like apache was installed from sources. Skipping update checks.${ENDC}\n" }
		} else {
			if ( ! $NOOK ) { show_ok_box(); print "${GREEN}No package updates found.${ENDC}\n" }
		}
	}

}

sub detect_cpanel_version {
	our $cpanel = 0;
	our $cpanel = 1 if -d "/usr/local/cpanel";
	if ($cpanel) {
		my $cpanel_version = 0;
		$cpanel_version = `cat /usr/local/cpanel/version` if (-f "/usr/local/cpanel/version");
		chomp($cpanel_version);
		if ($cpanel_version) {
			if ( ! $NOINFO ) { show_info_box(); print "cPanel Version: ${CYAN}$cpanel_version${ENDC}\n" }
		} else {
			if ( ! $NOINFO ) { show_info_box(); print "cPanel Version: ${CYAN}NOT FOUND${ENDC}\n" }
		}
			
	} else {
		if ( ! $NOINFO ) { show_info_box(); print "This server is NOT running cPanel.\n" }
	}
}

sub detect_plesk_version {
	our $plesk = 0;
	our $plesk = 1 if -d "/usr/local/psa";
	if ($plesk) {
		my $plesk_version = 0;
		$plesk_version = `cat /usr/local/psa/version` if (-f "/usr/local/psa/version");
		chomp($plesk_version);
		if ($plesk_version) {
			if ( ! $NOINFO ) { show_info_box(); print "Plesk Version: ${CYAN}$plesk_version${ENDC}\n" }
		} else {
			if ( ! $NOINFO ) { show_info_box(); print "Plesk Version: ${CYAN}NOT FOUND${ENDC}\n" }
		}
			
	} else {
		if ( ! $NOINFO ) { show_info_box(); print "This server is NOT running Plesk.\n" }
	}
}

sub detect_virtualmin_version {
	our $vmin = 0;
	our $vmin = 1 if -f "/usr/sbin/virtualmin";
	if ($vmin) {
		my $vmin_version = 0;
		$vmin_version = `/usr/sbin/virtualmin info | grep "virtualmin version" | awk -F":" '{ print \$2}'`;
		chomp($vmin_version);
		my $wmin_version = 0;
		$wmin_version = `/usr/sbin/virtualmin info | grep "webmin version" | awk -F":" '{ print \$2}'`;
		chomp($wmin_version);
		if ( ! $NOINFO ) { show_info_box(); print "Virtualmin Version: ${CYAN}$vmin_version${ENDC}\n" }
		if ( ! $NOINFO ) { show_info_box(); print "Webmin Version: ${CYAN}$wmin_version${ENDC}\n" }
	} else {
		if ( ! $NOINFO ) { show_info_box(); print "This server is NOT running Virtualmin.\n" }
	}
}

sub detect_php_fatal_errors {
	print "VERBOSE: Checking logs for PHP Fatal Errors, this can take some time...\n" if $main::VERBOSE;
	our $phpfpm_detected;
	our ($model, $process_name) = @_;
	if ($model eq "worker") {
		return;
	}

	if ($process_name eq "/usr/sbin/httpd" ) {
		our $SCANDIR = "/var/log/httpd/";
        } elsif ($process_name eq "/usr/local/apache/bin/httpd" ) {
		our $SCANDIR = "/usr/local/apache/logs/";
        } else {
		our $SCANDIR = "/var/log/apache2/";
        }
	our $SCANDIR;
	our %logfile_counts;
	grep_php_fatal($SCANDIR);

	if ($phpfpm_detected) {
		our $SCANDIR = "/var/log/php-fpm/";
		our %logfile_counts;
		grep_php_fatal($SCANDIR);
	}
	our %logfile_counts;
	if (%logfile_counts) {
		if ( ! $NOWARN ) {
			show_crit_box();
			print "${RED}PHP Fatal errors were found, see summaries below.${ENDC}\n";
			show_advisory_box(); print "${YELLOW}Check the logs manually.${ENDC}\n";
			while( my( $key, $value ) = each %logfile_counts ){
				show_advisory_box(); print " - ${YELLOW}$key${ENDC}: ${CYAN}$value${ENDC}\n";
			}
			our $plesk;
			if ($plesk) {
				print "\n";
				show_warn_box(); print "${YELLOW}Note: Plesk logs are NOT checked, as 100+ domains would generate 500+ lines of output, this is too much, so please check this manually:${ENDC}\n";
				show_advisory_box(); print "Use this command to check ALL domains: ${CYAN}grep -Hi fatal /var/www/vhosts/*/statistics/logs/*${ENDC}\n";
				show_advisory_box(); print "Use this command to check ONLY \"example.com\": ${CYAN}grep -Hi fatal /var/www/vhosts/example.com/statistics/logs/*${ENDC}\n";
			}
		}
	} else {
		if ( ! $NOOK ) {
			show_ok_box();
			print "${GREEN}No PHP Fatal Errors were found.${ENDC}\n";
			return;
		}
	}
}


sub grep_php_fatal {
	my ($SCANDIR) = @_;
	our %logfile_counts;
        my @logfile_list;
	find(sub {push @logfile_list, $File::Find::name  if ( -f $_ ) },  $SCANDIR);
        foreach my $file (@logfile_list) {
                our $phpfatalerror_hits = 0;
                open(FILE, $file);
                while (<FILE>) {
                        $phpfatalerror_hits++ if $_ =~ /php fatal/i;
                }
                close(FILE);
                if ($phpfatalerror_hits) {  $logfile_counts{ $file } =  $phpfatalerror_hits }
        }
}	


sub detect_maxclients_hits {
	our ($model, $process_name) = @_;
	if ($model eq "worker") {
		return;
	}
	our $hit = 0;
	if ($process_name eq "/usr/sbin/httpd") {
		our $maxclients_hits = `grep -i reached /var/log/httpd/error_log | egrep -v "mod" | tail -5`;
	} elsif ($process_name eq "/usr/local/apache/bin/httpd") {
		our $maxclients_hits = `grep -i reached /usr/local/apache/logs/error_log | egrep -v "mod" | tail -5`;
	} else {
		our $maxclients_hits = `grep -i reached /var/log/apache2/error.log | egrep -v "mod" | tail -5`;
	}
	our $maxclients_hits;
	if ($maxclients_hits) {
		$hit = 1;
	}
	our $hit;
	if ($hit) {
		if ( ! $NOWARN ) {
			show_warn_box();
			print "${YELLOW}MaxClients has been hit recently (maximum of 5 results shown), consider the dates and times below:${ENDC}\n";
			print $maxclients_hits;
		}
	} else {
		if ( ! $NOOK ) {
			show_ok_box();
			print "${GREEN}MaxClients has not been hit recently.${ENDC}\n";
			return;
		}
	}
		
}	


sub detect_php_memory_limit {
	if ( ! $NOINFO) {
		our $apache_proc_php = get_php_setting('/usr/bin/php', 'memory_limit');
		show_info_box(); print "Your PHP Memory Limit (Per-Process) is ${CYAN}".$apache_proc_php." MB${ENDC}.\n";
		if ($apache_proc_php eq "-1") {
			show_advisory_box(); print "You should set a PHP Memory Limit (-1 is ${CYAN}UNLIMITED${ENDC}) which is not recommended.\n";
		}
	}
}

sub get_service_memory_usage_mbytes {
	my ( $svc )  = @_;
	my @usage_by_pids = `ps -C $svc -o rss | grep -v RSS`;
	our $usage_mbytes = 0;
	foreach my $proc (@usage_by_pids) {
		our $usage_mbytes += $proc / 1024;
	}
	our $usage_mbytes = round($usage_mbytes);
	return $usage_mbytes;
}


sub detect_additional_services {
	if ($VERBOSE) { print "VERBOSE: Begin detecting additional services...\n" }
	our $servicefound_flag = 0; # we need this to give a message  if nothing was found, otherwise it looks silly.
	# Detect Mysql
	our $mysql_detected = 0;
	our $mysql_detected = `ps -C mysqld -o rss | grep -v RSS`;
	if ( $mysql_detected ) {
		if ($VERBOSE) { print "VERBOSE: MySQL Detected\n" }
		our $servicefound_flag = 1;
		if ( ! $NOINFO ) { show_info_box(); print "${CYAN}MySQL${ENDC} Detected => " } 
		# Get MySQL Memory Usage
		our $mysql_memory_usage_mbytes = get_service_memory_usage_mbytes("mysqld");
		if ( ! $NOINFO ) { print "Using ${CYAN}$mysql_memory_usage_mbytes MB${ENDC} of memory.\n" }
	} else {
		if ($VERBOSE) { print "VERBOSE: MySQL NOT Detected\n" }
		our $mysql_memory_usage_mbytes = 0;
	}
	
	# Detect Java
	our $java_detected = 0;
	$java_detected = `ps -C java -o rss | grep -v RSS`;
	if ( $java_detected ) {
		if ($VERBOSE) { print "VERBOSE: Java Detected\n" }
		our $servicefound_flag = 1;
		if ( ! $NOINFO ) { show_info_box(); print "${CYAN}Java${ENDC} Detected => " } 
		our $java_memory_usage_mbytes = get_service_memory_usage_mbytes("java");
		if ( ! $NOINFO ) { print "Using ${CYAN}$java_memory_usage_mbytes MB${ENDC} of memory.\n" }
	} else {
		if ($VERBOSE) { print "VERBOSE: Java NOT Detected\n" }
		our $java_memory_usage_mbytes = 0;
	}

	# Detect Varnish
	our $varnish_detected = 0;
	$varnish_detected = `ps -C varnishd -o rss | grep -v RSS`;
	if ( $varnish_detected ) { 
		if ($VERBOSE) { print "VERBOSE: Varnish Detected\n" }
		our $servicefound_flag = 1;
		if ( ! $NOINFO ) { show_info_box(); print "${CYAN}Varnish${ENDC} Detected => " }
		# Get varnish Memory Usage
		our $varnish_memory_usage_mbytes = get_service_memory_usage_mbytes("varnishd");
		if ( ! $NOINFO ) { print "Using ${CYAN}$varnish_memory_usage_mbytes MB${ENDC} of memory.\n" }
	} else {
		if ($VERBOSE) { print "VERBOSE: Varnish NOT Detected\n" }
		our $varnish_memory_usage_mbytes = 0;
	}

	# Detect Redis
	our $redis_detected = 0;
	$redis_detected = `ps -C redis-server -o rss | grep -v RSS`;
	if ( $redis_detected ) { 
		if ($VERBOSE) { print "VERBOSE: Redis Detected\n" }
		our $servicefound_flag = 1;
		if ( ! $NOINFO ) { show_info_box(); print "${CYAN}Redis${ENDC} Detected => " }
		# Get Redis Memory Usage
		our $redis_memory_usage_mbytes = get_service_memory_usage_mbytes("redis-server");
		if ( ! $NOINFO ) { print "Using ${CYAN}$redis_memory_usage_mbytes MB${ENDC} of memory.\n" }
	} else {
		if ($VERBOSE) { print "VERBOSE: Redis NOT Detected\n" }
		our $redis_memory_usage_mbytes = 0;
	}

	# Detect Memcache
	our $memcache_detected = 0;
	$memcache_detected = `ps -C memcached -o rss | grep -v RSS`;
	if ( $memcache_detected ) { 
		if ($VERBOSE) { print "VERBOSE: Memcache Detected\n" }
		our $servicefound_flag = 1;
		if ( ! $NOINFO ) { show_info_box(); print "${CYAN}Memcache${ENDC} Detected => " }
		# Get Memcache Memory Usage
		our $memcache_memory_usage_mbytes = get_service_memory_usage_mbytes("memcached");
		if ( ! $NOINFO ) { print "Using ${CYAN}$memcache_memory_usage_mbytes MB${ENDC} of memory.\n" }
	} else {
		if ($VERBOSE) { print "VERBOSE: Memcache NOT Detected\n" }
		our $memcache_memory_usage_mbytes = 0;
	}

	# Detect PHP-FPM
	our $phpfpm_detected = 0;
	# Get PHP-FPM Memory Usage
	$phpfpm_detected = `ps -C php-fpm -o rss | grep -v RSS` || `ps -C php5-fpm -o rss | grep -v RSS` || 0;
	if ( $phpfpm_detected ) { 
		if ($VERBOSE) { print "VERBOSE: PHP-FPM Detected\n" }
		our $servicefound_flag = 1;
		# Get PHP-FPM Memory Usage
		our $phpfpm = 0;
		our $phpfpm = `ps -C php-fpm -o rss | grep -v RSS`; 
		our $php5fpm = 0;
		our $php5fpm = `ps -C php5-fpm -o rss | grep -v RSS`; 
		if ( $phpfpm ) {
			if ( ! $NOINFO ) { show_info_box(); print "${CYAN}PHP-FPM${ENDC} Detected => " }
			our $phpfpm_memory_usage_mbytes = get_service_memory_usage_mbytes("php-fpm");
		} elsif ( $php5fpm ) {
			if ( ! $NOINFO ) { show_info_box(); print "${CYAN}PHP5-FPM${ENDC} Detected => " }
			our $phpfpm_memory_usage_mbytes = get_service_memory_usage_mbytes("php5-fpm");
		}
		our $phpfpm_memory_usage_mbytes;
		if ( ! $NOINFO ) { print "Using ${CYAN}$phpfpm_memory_usage_mbytes MB${ENDC} of memory.\n" }
	} else {
		if ($VERBOSE) { print "VERBOSE: PHP-FPM NOT Detected\n" }
		our $phpfpm_memory_usage_mbytes = 0;
	}

	# Detect Gluster
	our $gluster_detected = 0;
	$gluster_detected = `ps -C glusterd -o rss | grep -v RSS`;
	if ( $gluster_detected ) { 
		if ($VERBOSE) { print "VERBOSE: Gluster Detected\n" }
		our $servicefound_flag = 1;
		if ( ! $NOINFO ) { show_info_box(); print "${CYAN}Gluster${ENDC} Detected => " }
		# Get Gluster Memory Usage
		our $glusterd_memory_usage_mbytes = get_service_memory_usage_mbytes("glusterd");
		our $glusterfs_memory_usage_mbytes = get_service_memory_usage_mbytes("glusterfs");
		our $glusterfsd_memory_usage_mbytes = get_service_memory_usage_mbytes("glusterfsd");
		our $gluster_memory_usage_mbytes = $glusterd_memory_usage_mbytes + $glusterfs_memory_usage_mbytes + $glusterfsd_memory_usage_mbytes;
		if ( ! $NOINFO ) { print "Using ${CYAN}$gluster_memory_usage_mbytes MB${ENDC} of memory.\n" }
	} else {
		if ($VERBOSE) { print "VERBOSE: Gluster NOT Detected\n" }
		our $gluster_memory_usage_mbytes = 0;
	}
	if ( $servicefound_flag == 0 ) {
		if ( ! $NOOK ) { show_ok_box(); print "${GREEN}No additional services were detected.${ENDC}\n" }
	} else {
		print "\n"; # add a aseparator before the next section
	}
	if ($VERBOSE) { print "VERBOSE: End detecting additional services...\n" }
}


sub get_hostname {
	our $hostname = `which hostname`;
        chomp($hostname);
        if ( $hostname eq '' ) {
                show_crit_box();
                print "Cannot find the 'hostname' executable.";
                exit;
        } else {
                our $servername = `$hostname -f`;
                chomp($servername);
		return $servername;
        }
}


sub get_ip {
	our $curl = `which curl`;
	chomp ($curl);
	if ( $curl eq '' ) {
	 	show_crit_box;
		print "Cannot find the 'curl' executable.";
		exit;
	} else {
		our $ip = `$curl -s myip.dnsomatic.com`;
		return $ip;
	}
}

########################
# BEGIN MAIN EXECUTION #
########################

# if the user has added the help flag, or if they have defined a port  
if ( $help eq 1 || $port eq 0 ) {
	usage();
	exit;
}

# print the header
my $hn = get_hostname();
my $ip = get_ip();
print_header($hn, $ip);

# do the preflight checks
preflight_checks();

our $hostname;
our $public_ip_address;
our @config_array;
our $apache_user;
our $model;
our $process_name;
our $available_mem;
our $maxclients;
our $flag_trigger = 0;
our $threadsperchild;
our $serverlimit;
our $mysql_detected;
our $mysql_memory_usage_mbytes;
our $java_detected;
our $java_memory_usage_mbytes;
our $redis_detected;
our $redis_memory_usage_mbytes;
our $memcache_detected;
our $memcache_memory_usage_mbytes;
our $varnish_detected;
our $varnish_memory_usage_mbytes;
our $phpfpm_detected;
our $phpfpm_memory_usage_mbytes;
our $gluster_memory_usage_mbytes;

# Detect httpd
our $httpd_detected = 0;
our $httpd_detected = `ps -C httpd -o rss | grep -v RSS`;
if ( $httpd_detected ) {
if ( ! $NOINFO ) { show_info_box(); print "${CYAN}httpd${ENDC} " }
        # Get httpd Memory Usage
        our $httpd_memory_usage_mbytes = get_service_memory_usage_mbytes("httpd");
        if ( ! $NOINFO ) { print "is currently using ${CYAN}$httpd_memory_usage_mbytes MB${ENDC} of memory.\n" }
} else {
        our $httpd_memory_usage_mbytes = 0;
}
# Detect apache2 
our $apache2_detected = 0;
our $apache2_detected = `ps -C apache2 -o rss | grep -v RSS`;
if ( $apache2_detected ) {
if ( ! $NOINFO ) { show_info_box(); print "${CYAN}apache2${ENDC} " }
        # Get apache2 Memory Usage
        our $apache2_memory_usage_mbytes = get_service_memory_usage_mbytes("apache2");
        if ( ! $NOINFO ) { print "is currently using ${CYAN}$apache2_memory_usage_mbytes MB${ENDC} of memory.\n" }
} else {
        our $apache2_memory_usage_mbytes = 0;
}

my $apache_proc_highest = get_memory_usage($process_name, $apache_user, 'high');
my $apache_proc_lowest = get_memory_usage($process_name, $apache_user, 'low');
my $apache_proc_average = get_memory_usage($process_name, $apache_user, 'average');


if ( $model eq "prefork") {
	if ( ! $NOINFO ) { show_info_box(); print "The smallest apache process is using ${CYAN}$apache_proc_lowest MB${ENDC} of memory\n" }
	if ( ! $NOINFO ) { show_info_box(); print "The average apache process is using ${CYAN}$apache_proc_average MB${ENDC} of memory\n" }
	if ( ! $NOINFO ) { show_info_box(); print "The largest apache process is using ${CYAN}$apache_proc_highest MB${ENDC} of memory\n" }

	my $average_potential_use = $maxclients * $apache_proc_average;
	$average_potential_use = round($average_potential_use);
	my $average_potential_use_pct = round(($average_potential_use/$available_mem)*100);
	# Calculate percentages of remaining RAM, after services considered:
	print "VERBOSE: Available Mem: $available_mem\n" if $main::VERBOSE;
	print "VERBOSE: Mysql Mem: $mysql_memory_usage_mbytes\n" if $main::VERBOSE;
	print "VERBOSE: Java Mem: $java_memory_usage_mbytes\n" if $main::VERBOSE;
	print "VERBOSE: Redis Mem: $redis_memory_usage_mbytes\n" if $main::VERBOSE;
	print "VERBOSE: Memcache Mem: $memcache_memory_usage_mbytes\n" if $main::VERBOSE;
	print "VERBOSE: Varnish Mem: $varnish_memory_usage_mbytes\n" if $main::VERBOSE;
	print "VERBOSE: PHP-FPM Mem: $phpfpm_memory_usage_mbytes\n" if $main::VERBOSE;
	print "VERBOSE: Gluster Mem: $gluster_memory_usage_mbytes\n" if $main::VERBOSE;	
	my $memory_remaining = $available_mem - $mysql_memory_usage_mbytes - $java_memory_usage_mbytes - $redis_memory_usage_mbytes - 
	$memcache_memory_usage_mbytes - $varnish_memory_usage_mbytes - $phpfpm_memory_usage_mbytes - $gluster_memory_usage_mbytes;
	print "VERBOSE: Average Potential Use : $average_potential_use\n" if $main::VERBOSE;
	print "VERBOSE: Mem Remaining: $memory_remaining\n" if $main::VERBOSE;	
	if ($memory_remaining < 0) {
		show_crit_box(); print "${RED}ERROR: Memory Overload Error: Remaining RAM in negative numbers! Dumping memory report, and exiting...${ENDC}\n";
		print "Available Mem: $available_mem\n";
		print "----------------------------------------------\n";
		print "Mysql Mem: $mysql_memory_usage_mbytes\n";
		print "Java Mem: $java_memory_usage_mbytes\n";
		print "Redis Mem: $redis_memory_usage_mbytes\n";
		print "Memcache Mem: $memcache_memory_usage_mbytes\n";
		print "Varnish Mem: $varnish_memory_usage_mbytes\n";
		print "PHP-FPM Mem: $phpfpm_memory_usage_mbytes\n";
		print "Gluster Mem: $gluster_memory_usage_mbytes\n";	
		print "----------------------------------------------\n";
		print "Remaining Mem: $memory_remaining\n";	
		exit;
	}		
	my $average_potential_use_pct_remain = round(($average_potential_use/$memory_remaining)*100);
	if ( $average_potential_use_pct > 100  or $average_potential_use_pct_remain > 100 ) {
		show_crit_box();
		print "Going by the average Apache process, Apache can potentially use ${RED}$average_potential_use MB${ENDC} RAM:\n";
		if ( $average_potential_use_pct > 100 ) {
			print "\t\tWithout considering services: ${RED}$average_potential_use_pct \%${ENDC} of total installed RAM\n";
		} else {
			print "\t\tWithout considering services: ${CYAN}$average_potential_use_pct \%${ENDC} of total installed RAM\n";
		}
		if ( $average_potential_use_pct_remain > 100 ) {
			print "\t\tConsidering extra services: ${RED}$average_potential_use_pct_remain \%${ENDC} of remaining RAM\n";
		} else {
			print "\t\tConsidering extra services: ${CYAN}$average_potential_use_pct_remain \%${ENDC} of remaining RAM\n";
		}
	} else {
       		if ( ! $NOOK ) {
			show_ok_box();
			print "Going by the average Apache process, Apache can potentially use ${CYAN}$average_potential_use MB${ENDC} RAM:\n" .
				"\t\tWithout considering services: ${CYAN}$average_potential_use_pct \%${ENDC} of total installed RAM\n" .
				"\t\tConsidering extra services: ${CYAN}$average_potential_use_pct_remain \%${ENDC} of remaining RAM\n";
		 }
	}

	my $highest_potential_use = $maxclients * $apache_proc_highest;
	$highest_potential_use = round($highest_potential_use);
	my $highest_potential_use_pct = round(($highest_potential_use/$available_mem)*100);
	# Calculate percentages of remaining RAM, after services considered:
	print "VERBOSE: Highest Potential Use : $highest_potential_use\n" if $main::VERBOSE;
	print "VERBOSE: Mem Remaining: $memory_remaining\n" if $main::VERBOSE;	
	
	my $highest_potential_use_pct_remain = round(($highest_potential_use/$memory_remaining)*100);
	if ( $highest_potential_use_pct > 100  or $highest_potential_use_pct_remain > 100 ) {
		show_crit_box();
		print "Going by the largest Apache process, Apache can potentially use ${RED}$highest_potential_use MB${ENDC} RAM:\n";
		if ( $highest_potential_use_pct > 100 ) {
			print "\t\tWithout considering services: ${RED}$highest_potential_use_pct \%${ENDC} of total installed RAM\n";
		} else {
			print "\t\tWithout considering services: ${CYAN}$highest_potential_use_pct \%${ENDC} of total installed RAM\n";
		}
		if ( $highest_potential_use_pct_remain > 100 ) {
			print "\t\tConsidering extra services: ${RED}$highest_potential_use_pct_remain \%${ENDC} of remaining RAM\n";
		} else {
			print "\t\tConsidering extra services: ${CYAN}$highest_potential_use_pct_remain \%${ENDC} of remaining RAM\n";
		}
	} else {
	       	if ( ! $NOOK ) { 
			show_ok_box();
			print "Going by the largest Apache process, Apache can potentially use ${CYAN}$highest_potential_use MB${ENDC} RAM:\n" .
				"\t\tWithout considering services: ${CYAN}$highest_potential_use_pct %${ENDC} of total installed RAM\n" . 
				"\t\tConsidering extra services: ${CYAN}$highest_potential_use_pct_remain %${ENDC} of remaining RAM\n"; 
		}
	}
}
if ( $model eq "worker") {
	if ( ! $NOINFO ) { show_info_box(); print "The largest apache process is using ${CYAN}$apache_proc_highest MB${ENDC} of memory\n" }
	if ( ! $NOINFO ) { show_info_box(); print "The smallest apache process is using ${CYAN}$apache_proc_lowest MB${ENDC} of memory\n" }
	if ( ! $NOINFO ) { show_info_box(); print "The average apache process is using ${CYAN}$apache_proc_average MB${ENDC} of memory\n" }
}

generate_standard_report($available_mem, $maxclients, $apache_proc_lowest, $apache_proc_average, $apache_proc_highest, $model, $threadsperchild, $mysql_memory_usage_mbytes, $java_memory_usage_mbytes, $redis_memory_usage_mbytes, $memcache_memory_usage_mbytes, $varnish_memory_usage_mbytes, $phpfpm_memory_usage_mbytes, $gluster_memory_usage_mbytes);

#show_important_message();
