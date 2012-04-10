#!/usr/bin/perl

use strict;
use XML::Simple;
use Data::Dumper;

#&daemonize;

my $branch = 'rc-200909';
my $g15_fifo = '/home/tlittle/run/g15';
my $size = 'M';

while (1) {
    my $xml = `svn log --limit 10 --verbose --xml svn+ssh://tlittle\@svn/home/svnroot/webassign/branches/$branch 2>/dev/null`;
    my $log = XMLin($xml, ForceArray => ['path']);

    #print Dumper $log;

    open G15, '>', $g15_fifo;
    print G15 qq[T$size "Branch: $branch"];
    #print qq[T$size Branch: $branch];
    for my $entry (@{$log->{logentry}}) {

        for my $path (@{$entry->{paths}{path}}) {
            $path->{content} =~ s/.*\///;
            print G15 qq[ "$entry->{revision}: $path->{action} $path->{content}"];
            #print qq[ "$entry->{revision}: $path->{action} $path->{content}"];
        }
    }
    print G15 "\n";
    #print "\n";
    close G15;
    sleep 300;
}

use POSIX 'setsid';
sub daemonize {
    chdir '/'                 or die "Can't chdir to /: $!";
    open STDIN, '/dev/null'   or die "Can't read /dev/null: $!";
    open STDOUT, '>/dev/null' or die "Can't write to /dev/null: $!";
    defined(my $pid = fork)   or die "Can't fork: $!";
    exit if $pid;
    setsid                  or die "Can't start a new session: $!";
    open STDERR, '>&STDOUT' or die "Can't dup stdout: $!";
}
