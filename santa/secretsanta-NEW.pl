#!/usr/athena/bin/perl
#
#
#

my @names =();

sub CreateFile {
    print "Adding people to secret santa list:\n";
    print "Type one Athena username per line.  When you're done\n";
    print "type \".\"  on a line by itself and hit return.\n";
    print "DO NOT LEAVE ANY SPACES AFTER THE USERNAME, OTHERWISE MAIL WILL BOUNCE!\n";
    chomp($uname=<STDIN>);
    while ($uname ne ".") {
	push @names, $uname;
	chomp($uname=<STDIN>);
    }
    my $numread = $#names + 1;
    print "\n\nOK, read $numread names.\n";
    print "Would you like to proceed with selection? (y/n) ";
    chomp($response=<STDIN>);
    if (uc($response) ne "Y") {
	print "OK, quitting...\n";
	exit 0;
    }
    open(NAMEFILE, ">secretsanta.txt") || die "Can't create file.";
    foreach $name (@names) {
	print NAMEFILE $name;
	print NAMEFILE "\n";
    }
    close(NAMEFILE);
}

sub Randomize {
    my $numread = $#names + 1;
    print "Now randomizing $numread people...\n"; 
    @partners = ();
    my $j=1;
    while ($j < $numread) {
	$x = $j-1;
	if ($partners[$x] eq "") {
	    $partners[$x] = $names[$j];
	    $j++;
	}
    }
}

sub CheckErrors {
    my $numread = $#names + 1;
    my $error = 0;
    for ($i=0; $i < $numread; $i++) {
	if ($names[$i] eq $partners[$i]) {
	    $error=1;
	}
    }
    return $error;
}    

sub PrintOut {
    my $numread = $#names + 1;
    open(OUTFILE, ">results.txt");
    for ($i=0; $i < $numread; $i++) {
	print $names[$i];
	print "-->";
	print $partners[$i];
	print "\n";
	print OUTFILE $names[$i];
	print OUTFILE "-->";
	print OUTFILE $partners[$i];
	print OUTFILE "\n";
    }
    close(OUTFILE);
    print "***Saved to results.txt***\n";
}

sub SendMail {
    print "Enter the date that gifts must be given by (ie: the\n";
    print "date of the hall feed when identities are revealed: ";
    chomp($date=<STDIN>);
    my $numread = $#names + 1;
    for ($i=0; $i < $numread; $i++) {
#	open(MAILTO, "|mhmail jdreed\@mit.edu");
	open(MAILTO, "|mhmail -from Santa -subject Secret_Santa $names[$i]\@mit.edu");
	print MAILTO "Hi! \n";
	print MAILTO "Your secret santee is $partners[$i] (look them up if you don't know athena names)\n";
	print MAILTO "Please make sure they receive their gift by $date.\n";
	print MAILTO "We'll go around revealing the identities at 9pm\n";
	print MAILTO "Sincerely, Santa (or Satan?)!\n\n";
	print "Sending mail to $names[$i]\n";
	close(MAILTO);
    }
}
    

CreateFile;
if ($#names < 1) {
    print "Need minimum of two names to proceed!\n";
    exit 1;
}
$iter = 0;
print "Iteration $iter ...\n";
Randomize;
while (CheckErrors()) {
    $iter++;
    print "Running next iteration.\n";
    print "Iteration $iter ...\n";
    Randomize;
}
print "Success!  Results:\n";
PrintOut;
print "Do you want to send mail now? (y/n) ";
chomp($mailyes=<STDIN>);
if (uc($mailyes) eq "Y") {
    SendMail;
} else {
    print "No mail was sent!\n";
}
print "\n\n************\n";
print "Copy results.txt to your /mit/$ENV{'USER'}/Private directory.\n";
print "Confirm that it was copied.\n";
print "Then delete it from this locker using the \"rm\" command.\n";
print "That will prevent others from seeing the secret santa results.\n";
print "\n\n************\n";
exit 0;


    
    












