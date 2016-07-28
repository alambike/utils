#!/usr/bin/perl
use strict;
use Data::Dumper;

my $pid = $ARGV[0];
my @pids = ();

if($pid =~ /^\d+$/){
    @pids = ($pid);
}
else{
    @pids = `pgrep $pid`;
    chomp(@pids);
}

foreach my $pid (@pids){
    print '-'x80, "\n";
    print "Environment for pid $pid (cmdline='".&getcmdline($pid)."'):\n";
    print '-'x80, "\n";
    print_pid_env($pid);
}


sub getcmdline{
    my $pid = shift;
    return join ' ', __getProcFileContents($pid, 'cmdline');
}

sub print_pid_env{
    my $pid = shift;

    map {
        my ($var, $value) = (split /\=/, $_);
        print "$var = $value \n";
    } sort {
        $a cmp $b
    }
    __getProcFileContents($pid, 'environ');
}

sub __getProcFileContents{
    my ($pid,$file) = @_;

    open my $f, "/proc/$pid/$file" || die($!);

    my $linea = <$f>;

    chomp($linea);

    return split(/\0/, $linea);
}
