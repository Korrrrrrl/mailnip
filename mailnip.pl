#!/usr/bin/perl

my $copyright = "Copyright (c) 2008-2013, Karl Kernaghan";
my $ver = "0.5.0"; # Version number

#use strict;
use IO::Socket::INET;
use Getopt::Std;

# This package is free software and is released under the Perl Artistic License.
# You are free to modify and redistribute this package under these terms. If these
# are your intentions please read and understand the terms of the Perl Artistic License,
# you should have received a copy along with this package, if not, you may view it with 
# one of the following commands; man perlartistic  or  perldoc perlartistic

# THIS PACKAGE WAS RELEASED AS THE STANDARD VERSION BY THE COPYRIGHT HOLDER AND IS PROVIDED
# "AS IS" WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE 
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. 


# The info on the program

print "\n";
my $name = "mailnipulator"; #A possibly naughty program for sending email.
my $version = "$ver";
my $author = "$copyright";
my $email = "email: kkernaghan7\@gmail.com \n";


# Actual program


&getopts('nv');
use vars qw($opt_n $opt_v);
if (!$opt_n && !$opt_v && !$ARGV[1]) {

print "$name $version \n\n";
print "$author \n";
print "$email \n";
print "Usage: ./mailnip$version.pl <option>\n\n";
print "Options: \n\n";
print "\t-n  Normal mode (Default SMTP port is set to 25) \n";
print "\t-v  Verbose mode (You need to set the SMTP port in this mode) \n";
exit(0);
}

###############
# Normal mode #
###############

if ($opt_n) {

# Gather the information needed to send the email

print "\n";
print "malnip running in normal mode \n \n";

# Collect the servers IP Address, should be a relay server

print "Type in the mail servers IP Address and press enter (relays are best): ";
$mail_srv = <STDIN>;
print "\n";

# Collect the domain name that will be used after the @ e.g. microsoft.net

print "What domain name do you want to use? ";
$domain = <STDIN>;
print "\n";

# Collect the "senders name" that will be put before the @ e.g. Bill_Gates

print "Who would you like the email to be from? ";
$mail_from = <STDIN>;
print "\n";

# Collect the persons email address where the email will be sent

print "Who do you want to send this email to? ";
$mail_to = <STDIN>;
print "\n";

# Collect the body of the message, not a pretty output but it works for now. I am in no way an email client writer.

print "Now type your message. DON'T press enter until you are done or else it will be sent before you are! \n\n";
$msg = <STDIN>;
print "\n";

# Now we see if we can send it through the selected email relay

print "Let's see what we can do.... \n\n";

# Trying to connect to the specified mail server

$socket = IO::Socket::INET -> new (PeerAddr => $mail_srv,
					PeerPort => "25",
					Proto    => "tcp",
					Timeout  => "7")
		or die "Couldn't connect to host $mail_srv\n";
print "Waiting for server to respond.... \n";
#sleep(5); #used in older versions

# Server response

$answer = <$socket>;
print "Response: $answer";

# Sending the email

print "Attempting to send the emai, please wait........ \n";

print $socket "helo $domain";
#sleep(4) #old code

print $socket "mail from: $mail_from";
#sleep(7) #old code

print $socket "RCPT TO: $mail_to";
#sleep(7) #old code

print $socket "data\r\n";
#sleep(5) #old code

print $socket "$msg\r\n";
print $socket ".\r\n";

print $socket "quit\r\n";
#sleep(2) #old code

close ($socket);
print "It is finished. \n";

}

################
# Verbose mode #
################

elsif ($opt_v) {

# Gather info needed to send the email

print "\n";
print "mailnip running in verbose mode \n\n";

# Collect the mail servers IP address

print "Type in the mail servers IP Address and press enter (relays are best): ";
$mail_srv = <STDIN>;
print "\n";

# Collect the port number

print "What port is this server using? ";
$port = <STDIN>;
print "\n";

# Collect the domain name that will be used after the @ e.g. microsoft.net

print "What domain name do you want to use? ";
$domain = <STDIN>;
print "\n";

# Collect the "senders name" that will be put before the @ e.g. Bill_Gates

print "Who would you like the email to be from? ";
$mail_from = <STDIN>;
print "\n";

# Collect the persons email address where the email will be sent

print "Who do you want to send this email to? ";
$mail_to = <STDIN>;
print "\n";

# Collect the body of the message, not a prety output but it works for now. I am in no way an email client writer.

print "Now type your message. DON'T press enter untill you are done or else it will be sent before you are! \n\n";
$msg = <STDIN>;
print "\n";

# Now we see if we can send it through the selected email relay

print "Let's see what we can do.... \n\n";

# Trying to connect to the specified mail server

$socket = IO::Socket::INET -> new (PeerAddr => $mail_srv,
					PeerPort => $port,
					Proto    => "tcp",
					Timeout  => "7")
		or die "Couldn't connect to host $mail_srv\n";
print "Waiting for server to respond.... \n";
#sleep(5); #used in older versions

# Server response

$answer = <$socket>;
print "Response: $answer";

# Try to send email

print "Attempting to send email, please wait........ \n";

# sending commands to email server

print "Sending helo $domain";
print $socket "helo $domain";
#sleep(4);
    
# Server response
$answer = <$socket>;
print "\rCommand.... $answer";

print "Sending mail from: $mail_from";
print $socket "mail from: $mail_from";
#sleep(7);
    
# Server response
$answer = <$socket>;
print "\rcommand.... $answer";

print "Sending RCPT TO: $mail_to";
print $socket "RCPT TO: $mail_to";
#sleep(7);
    
# Server response
$answer = <#socket>;
print "\rCommand.... $answer";

print "Sending data";
print $socket "data\r\n";
#sleep(5);
    
# Server response
$answer = <$socket>;
print "\rCommand.... $answer";
#sleep(2);

print "\rSending $msg";
print $socket "$msg\r\n";
print "Sending .";
print $socket ".\r\n";
    
# Server response
$answer = <$socket>;
print "\rCommand.... $answer";

print "\rQuitting....";
print $socket "quit\r\n";
#sleep(2);
    
# Server response
$answer = <$socket>;
print "\rCommand.... $answer";

close ($socket);

print "It is finished. \n";
}

__END__
