#!/usr/bin/perl
use strict;

my $EXCLUIR = qr/^\.+$/;

my $path = $ARGV[0] || '.';
print "Cleaning $path\n";

&delete($path) if($path);

sub delete{
        my $path=shift;

        if(-d $path){
                opendir my $d, $path;

                while(my $f = readdir($d)){
                        next if($f =~ $EXCLUIR);

                        my $file = "$path/$f";
                        if(-d $file){
                                &delete($file);
                        }
                        else{
                                unlink($file);
                                print "Removing file $file\n";
                        }

                }

                rmdir($path);
                print "Cleaning directory $path\n";
        }
        else{
                unlink($path);
        }
}
