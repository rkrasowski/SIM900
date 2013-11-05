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

debug("Waiting for message.......\n");










sigQuality();
exit();


while (1)
	{
		
		#  Check for any missing messages
		my @numSMS1 = smsNumber();
               	shift@numSMS1;
               	#print "Number of SMS: @numSMS1\n";
			if(@numSMS1)
				{

                                  	debug("There is missed new message\n");
                                        my @numSMS = smsNumber();
                                        shift@numSMS;
                                        #print "Number of SMS: @numSMS\n";
                                        foreach (@numSMS)
                                           	{
							my $message = readThatSMS($_);
							delayThatSMS($_);
                                                      #  messageAna($message);
                                                      #  delayThatSMS($_);
                                                        select(undef,undef,undef,0.1);
							debug("Waiting for new message.........\n");
                                            	}


                                        }


		sleep(1);
                $rx = $ob->read(255);
		if ($rx =~ m/CMTI/)
			{
				my @CMTIArray = split(/,/,$rx);
				my $CMTIArray;
				$messageWaiting = $CMTIArray[1];
				if ($messageWaiting != 0)
					{					
						debug("New message is waiting an ready to be retrieved\n");
						my @numSMS = smsNumber();
						shift@numSMS;
						#print "Number of SMS: @numSMS\n";
						foreach (@numSMS)
       		 					{						
                						my $message = readThatSMS($_);
								delayThatSMS($_);
							#	messageAna($message);
								#delayThatSMS($_);
								select(undef,undef,undef,0.1);
	                                                        debug("Waiting for new message.............\n");

        						}
						
					}		

			}

	}



###############################################  Subroutines ###########################

sub messageAna
	{
		my $message = shift;
		if ($message =~ m/FMEM/)
			{
				my $message = FMEM();
				sendSMS($message);
			}
	
		 if ($message =~ m/sysTIME/)
                        {
                                my $message = FMEM();
                                sendSMS($message);
                        }



	}








sub readThatSMS
        {
                my $num = shift;
                my $rxType;
                my $sender;
                my $date;
                my $time;
                my $text="";
		my $string= "";
                $ob->write("AT+CMGR=$num\r");
                

				select(undef,undef,undef,0.25);
                		$rx = $ob->read(255);
				$string = "$string"."$rx";
               			#print "String : $string\n";

                            	my @crArray = split(/\n/,$string);
                                my $crArray;

             		  	my @cuatArray = split(/\"/,$crArray[1]);
                                my $cuatArray;
                        	$rxType = $cuatArray[1];
                          	$sender = $cuatArray[3];
                       		my $dateTime = $cuatArray[7];
                      		my @dateTime = split(/,/,$dateTime);
                           	$date = $dateTime[0];
                          	$time = $dateTime[1];

				shift @crArray;
				shift @crArray;
				foreach (@crArray)
					{
						$text = $text.$_."\n";
					}
				$text =~ s/\nOK//;
				
        			unless (-e $logFile) 
					{
						debug("Log file doen't exist, will create it.\n");
						(open $LOGFILE, '>>'."rxSMS.log");
						my $logData = $sender.",".$date.",".$time.",".$text;
						$logData =~ tr/\cM//d;
						print $LOGFILE $logData;
						close $LOGFILE;
						debug("Message transfered into the log\n");
						goto FOLLOWING;
					} 
				open $LOGFILE, '>>'."rxSMS.log";
				my $logData = $sender.",".$date.",".$time.",".$text;
				$logData =~ tr/\cM//d;
				chomp $logData;
                                 print $LOGFILE $logData;
                                 close $LOGFILE;
				 debug("Message transfered into the log\n");
				FOLLOWING:



	                   #   print "RxType: $rxType\n";                             
                           #  print "Sender: $sender\n";
                          #  print "Date: $date\n";
                          #  print "Time: $time\n";
                             debug("Text: $text\n");
				return $text;

        }






sub isThereNewMessage
	{
		 $ob->write("AT+CNMI?\r");
                     	while(1)
				{
				sleep(1);
                                $rx = $ob->read(255);
                                print "Received: $rx\n";
				}

	}


sub delayThatSMS
	{
		my $numSMS = shift;
		$ob->write("AT+CMGD=$numSMS\r");
                sleep(1);
                $rx = $ob->read(255);
  #              print "Received: $rx\n";
	}


sub readTotal
	{


		 $ob->write("AT+CMGL=\"ALL\"\r");
		while(1)
			{
				sleep(1);
				
                                $rx = $ob->read(255);
                                print "Received: $rx\n";
			}



	}




sub smsNumber
		# Find out SMS numbers 			
	{
		$ob->write("AT+CMGL=\"ALL\"\r");
		my $string = "";
		my @numberArray;
		TRAIN: while(1)
			{
				select(undef,undef,undef,0.25);
				$rx = $ob->read(255);
				#print "Received: $rx\n";
				$string = "$string"."$rx"; 
				if ($rx =~ m/\nOK/)
					{
						last TRAIN;
					}		
			
			}
		
		my @stringArray = split(/\+CMGL\:/,$string);
		foreach (@stringArray)
			{
				my @comaArray = split(/,/,$_);
				my $comaArray;
				#print "Number is: $comaArray[0]\n";
				@numberArray;
				push(@numberArray, $comaArray[0]);
			
			}
		return @numberArray;

	}


sub sendSMS 
        {

                my $message = shift;

                debug("Let's send SMS\n");

                $ob->write("AT+CMGS=\"\+13366886336\"\r");
                select(undef,undef,undef,0.1);

                $ob->write("$message");
                select(undef,undef,undef,0.1);

                $ob->write("\cZ");
                select(undef,undef,undef,0.1);

                while(1)
                        {
                                sleep(1);
                                $rx = $ob->read(255);
                                chomp $rx;
                                if ($rx ne "")
                                        {
                                                debug("$rx\n");
						goto END;
                                        }
                                if ($rx =~ m/OK/)
                                        {
                                                debug("Message sent\n");
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






sub FMEM {

        	debug("Checking free memory  !!\n");
        	my $memory;
                	{
                        	local(*PS, $/);
                       	 	open(PS,"free -t -m |");
                        	$memory = <PS>;
                	}

		my @arrMemory = split (/\n/,$memory);
		my $arrMemory;

		my @freeMemory = split (/ /,$arrMemory[4]);

		my $freememory;
		my $totMem = $freeMemory[9];
		my $usedMem = $freeMemory[18];
		my $freeMem = $freeMemory[26];
		my $memMessage = "TM:$totMem UM:$usedMem FM:$freeMem";
		debug("Mem data: $memMessage\n");
		return $memMessage;
	}	



sub sysTIME 
        {
                my $time = gmtime();
                debug("System time is $time\n");
                return $time;
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



