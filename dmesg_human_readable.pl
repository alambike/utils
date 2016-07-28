#!/usr/bin/perl
 
use strict;
use warnings;
use POSIX qw(strftime);
 
my @dmesg_new = ();
my $dmesg = "/bin/dmesg";
my @dmesg_old = `$dmesg`;
my $now = time();
my $uptime = `cat /proc/uptime | cut -d"." -f1`;
my $t_now = $now - $uptime;
 
sub format_time {
 return strftime "%Y-%m-%d %H:%M:%S",  localtime $_[0];
}
 
foreach my $line ( @dmesg_old )
{
 chomp( $line );
 if( $line =~ m/\[\s*(\d+)\.(\d+)\](.*)/i )
 {
 # now - uptime + sekunden
 my $t_time = format_time( $t_now + $1 );
 push( @dmesg_new , "[$t_time] $3" );
 }
}
 
print join( "\n", @dmesg_new );
print "\n";
