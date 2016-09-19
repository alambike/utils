#!/usr/bin/perl
use strict;

my $opts = &parse_command_line;

my $path = $opts->{path} || die("Falta la ruta del repositorio que chequear");
my $pattern = $opts->{pattern} || '\.php$';
my $telegram_bot_auth = $opts->{telegram_bot_auth} || die("Falta la autenticacion del bot de telegram");

my $pattern = qr/$pattern/m;

my $status = &git_status($path);

if(&match_status($status, $pattern)){

	&notify($status,$telegram_bot_auth);
}


sub parse_command_line{

	my $res = {};

	foreach my $argv (@ARGV){

		my($k, $v) = split /\=/, $argv,2;

		$res->{$k} = $v;
	}

	$res;


}

sub git_status{

	`cd $path && git status`
}

sub match_status {
	my ($status, $pattern) = @_;

	return $status =~ $pattern
}

sub notify{
	my ($status, $bot_auth) = @_;

	$status =~ s/\"/\\"/g;

my $cmd = 'curl -X POST https://api.telegram.org/'.$bot_auth.'/sendMessage \
-H "Content-Type: application/json" \
-d \'{"chat_id":"2129731","text":"Alerta!!!\n Archivos sospeitosos en mukhas.com\n '.$status.'"}\'';

print `$cmd`;
}
