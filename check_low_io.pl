#!/usr/bin/perl
use strict;
use POSIX qw(strftime);

my $opts = &parse_command_line;

my $telegram_bot_auth = $opts->{telegram_bot_auth} || die("Falta la autenticacion del bot de telegram");

my ($todo, $io) = &get_io;


if($io < 15){

	&notify($todo,$telegram_bot_auth);
}

sub get_io{
	my @res =  `dd if=/dev/zero of=/root/testfile bs=1G count=1 oflag=direct 2>&1`;
	my $write_status_line = @res[-1];

	$write_status_line =~ /\, ([^,]+)$/;
	
	my $write_io = $1;
	print strftime("%F %T",localtime(time)),' WRITE: ', $1;

	my @read_io = `hdparm -Tt /dev/sda 2>&1`;
	chomp(@read_io);
	print strftime("%F %T",localtime(time)),' READ: ', join (",", @read_io), "\n";
	
	if($write_io =~ /([\d.]+) MB\/s/i){
		$write_io = $1;
	}
	else {
		$write_io = 0;
	}

	return join ("\n", @res,@read_io), $1;
}


sub parse_command_line{

	my $res = {};

	foreach my $argv (@ARGV){

		my($k, $v) = split /\=/, $argv,2;

		$res->{$k} = $v;
	}

	$res;


}
sub notify{
	my ($status, $bot_auth) = @_;

	$status =~ s/\"/\\"/g;

	my $short_status = substr( $status, 0, 100 ); 

my $cmd = 'curl -X POST https://api.telegram.org/'.$bot_auth.'/sendMessage \
-H "Content-Type: application/json" \
-d \'{"chat_id":"2129731","text":"Alerta!!!\n prefapp.es ten un io moi baixo!\n '.$short_status.'"}\'';

print `$cmd`;
}
