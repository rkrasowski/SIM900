#!/usr/bin/perl

########################## serialTxRx.pl#########################
#								#
# Send and receive messages cia SIM900 modem and BB controller	#
# by Robert J. Krasowski					#
# 10/14/2013							#
#								#
#################################################################


use warnings;
use strict;
use Device::SerialPort;



my $debug = 1;			# 1 = debug on , 0 no debug 
my $messageWaiting;
my $rx;
my $rxType;
my $sender;
my $date;
my $time;
my $text;
my $sendMessage = "I have received your SMS\n";
my $LOGFILE;
my $logFile =  '/home/ubuntu/Perl/rxSMS.log';


debug("Program starts\n");

# set pins in appropriate modes to communicate with  modem:
# Set UART 2
# Set Tx pin
`echo 1 > /sys/kernel/debug/omap_mux/spi0_d0`;
# set Rx pin
`echo 21 > /sys/kernel/debug/omap_mux/spi0_sclk`;


# Activate serial connection:
my $PORT = "/dev/ttyO2";
my $ob = Device::SerialPort->new($PORT) || die "Can't Open $PORT: $!";

$ob->baudrate(19200) || die "failed setting baudrate";
$ob->parity("none") || die "failed setting parity";
$ob->databits(8) || die "failed setting databits";
$ob->handshake("none") || die "failed setting handshake";
$ob->write_settings || die "no settings";
$| = 1;

debug ("Opening port for modem\n");

debug("Setup completed, starting main subroutine\n##############################################################\n");
debug("Check if modem is connected and available\n");
		 
		
		$ob->write("ATE0\r");		# Command to turn echo off
                sleep(1);
                $rx = $ob->read(255);
		if ($rx =~ m/OK/)
			{
				debug("Modem responded and echo is off\n");
			#	goto START;
                	}
		else 	{
				debug("No response from modem or wrong response: $rx\n");
			#	exit();
			}
	
############################################################################################################

debug("I am READY and waiting for instruction.......\n");




###############################################  Subroutines ###########################



#command('AT+GSV');


#command('AT+SAPBR=4,1');
#sleep(1);
#print "Writting connection type\n";
#command('AT+SAPBR=3,1,"CONTYPE","GPRS"');
#sleep(1);
#print "Entering APN\n";
#command('AT+SAPBR=3,1,"APN","epc.tmobile.com"');
#print "Entering user\n";
#command('AT+SAPBR=3,1,"USER","3369299002"');
#print "entering password\n";
#command('AT+SAPBR=3,1,"PWD","ironfish29"');
#print "Password entered\n";
#command('AT+SAPBR=1,1');
#print "Checking if connected\n";
#command('AT+SAPBR=2,1');
command('AT+FTPPORT?');
print "Set port ID";
command('AT+FTPCID=1');
print "Set ftp server\n";
command('AT+FTPSERV="75.101.155.12"');

print "Set user\n";
command('AT+FTPUN="rkrasowski@yahoo.com"');

print"Set password\n";
command('AT+FTPPW="przyjechali"');
 print"Ok, I am connected to FTP server!\n";

print"Setting file to be downloaded name:\n";
command('AT+FTPGETNAME="test.pl"');

print"Setting path to the file:\n";
command('AT+FTPGETPATH="/home/ubuntu/Perl/"');

print"Starting FTP:\n";
command('AT+FTPGET=1');

 while(1)
                        {
                                sleep(1);
                                $rx = $ob->read(255);
                                print "received: $rx\n";
                     #           if ($rx =~ m/OK/)
                        }






exit();

command('AT+FTPGETNAME="test.pl"');

print"Setting path to the file:\n";
command('AT+FTPGETPATH="/home/ubuntu/Perl/"');

command('AT+CIPSTART=?');
                debug("Start Up Multi-IP Connection\n");
                command('AT+CIPMUX=1');

                debug("Let's check if it's setup into 1?\n");
                command('AT+CIPMUX?');


print "Starting connection:\n";

command('AT+CIPSTART="TCP","75.101.155.12",21');

 while(1)
                        {
                                sleep(1);
                                $rx = $ob->read(255);
                                print "received: $rx\n";
                     #           if ($rx =~ m/OK/)
                        }

exit();


command('AT+SAPBR=3,1,"CONTYPE","GPRS"');

command('AT+FTPCID=1');
command('AT+FTPSERV="75.101.155.12"');
command('AT+FTPUN="rkrasowski@yahoo.com"');
command('AT+FTPPW="przyjechali"');
 print"Ok, I am connected to FTP server!\n";

print"Setting file to be downloaded name:\n";
command('AT+FTPGETNAME="test.pl"');

print"Setting path to the file:\n";
command('AT+FTPGETPATH="/home/ubuntu/Perl/"');


print"Starting FTP:\n";
command('AT+FTPGET=1<< start ftp');

 while(1)
                        {
                                sleep(1);
                                $rx = $ob->read(255);
                                print "received: $rx\n";
                     #           if ($rx =~ m/OK/)
			}









exit();
command('AT+CSQ');
command('AT+CGATT? ');
command('AT+CSTT');
command('AT+CIICR');

command('AT+SAPBR=3,1,"CONTYPE","GPRS"');

print"Will writte APGR:\n";
command('APBR=3,1,"APN","epc.tmobile.com"');









exit();



		command('AT+FTPCID=1');
		command('AT+FTPSERV="75.101.155.12"');
		command('AT+FTPPORT=21');
		command('AT+FTPUN="rkrasowski@yahoo.com"');
		command('AT+FTPPW="przyjechali"');
		print"Ok, I am connected to FTP server!\n";
	
		print"Setting file to be downloaded name:\n";
		command('AT+FTPPUTNAME="test.pl"');

		print"Setting up path:\n";
		command('AT+FTPPUTPATH="/home/ubuntu/Perl/"');

		print"Open FTPPUT session:\n";
		command('AT+FTPPUT=1');



		print"Getting ready to upload it:\n";
		command('AT+FTPPUT=`1,230');
	

		while(1)
                        {
                                sleep(1);
                                $rx = $ob->read(255);
                                print "received: $rx\n";
                                if ($rx =~ m/OK/)
                                        {
                                                goto FIN;
                                        }
                        }

                FIN:



		exit();

		print"Enter file name to be downloaded\n";
		command('AT+FTPGETNAME="LINKS"');

		print" Enter path tp the file :\n";
		command('AT+FTPGETPATH="/"');

		print"Try to get that file:\n";
	#	command('AT+FTPGET=1,231');
		command('AT+FTPGET=?');	

		exit();




                debug("Start Up Multi-IP Connection\n");
 		command('AT+CIPMUX=1');

		debug("Let's check if it's setup into 1?\n");               
                command('AT+CIPMUX?');

		command('AT+CSTT="wap.voicestream.com ","guest","guest"');
		command('AT+CIICR');
	#	command('AT+CIFSR');
		 $ob->write("AT+CIFSR\r");
         #       select(undef,undef,undef,0.1);
                sleep(5);
                $rx = $ob->read(255);
                print "Should show ip: $rx\n";



		command('AT+CIPSTART=0,"TCP","75.101.155.12",21');


		while(1)
			{
				sleep(1);
				$rx = $ob->read(255);
                                print "received: $rx\n";
				if ($rx =~ m/OK/)
					{
						goto FIN;
					}
			}

		FIN:


		
		command('AT+CIPSEND=0');

		print "Waiting to put user id";
		sleep(1);

		command('user rkrasowski@yahoo.com');
		
exit();
                $ob->write("AT+C\r");
         #       select(undef,undef,undef,0.1);
                sleep(2);
                $rx = $ob->read(255);
                print "Received $rx\n";
                





sub command
	{
		my $command = shift;
		$ob->write("$command\r");
		while(1)
			{
				select(undef,undef,undef,0.25);
				$rx = $ob->read(255);
				print "received: $rx\n";
				if ($rx =~ m/OK/)
					{
						goto END;
					}
			}
		END:
	}




















sub sigQuality
	{
		  debug("Checking signal quality\n");

		while(1)
		{
                $ob->write("AT+CSQ\r");
         #       select(undef,undef,undef,0.1);
		sleep(2);
		$rx = $ob->read(255);
		print "Received $rx\n";
		}

	}

#####################################################################################################################################

sub debug 
        {
                my $text = shift;
                if ($debug == 2)
                        {
                                open LOG, '>>/home/ubuntu/Log/main.log' or die "Can't write to /home/ubuntu/Log/main.log: $!";
                                select LOG;
                                my $time = gmtime();
                                my @arrayTime = split(/ /,$time);
                                my $arrayTime;
                                $time = "$arrayTime[1]"."$arrayTime[2]"." "."$arrayTime[3]";

                                print "$time: $text\n";
                                select STDOUT;
                                close (LOG);
                        }
                if ($debug == 1)
                        {
                                my $time = gmtime();
                                my @arrayTime = split(/ /,$time);
                                my $arrayTime;
                                $time = "$arrayTime[1]"."$arrayTime[2]"." "."$arrayTime[3]";

                                print "$time: $text\n";
                        }

        }



