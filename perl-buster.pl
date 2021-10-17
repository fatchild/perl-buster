#! /usr/bin/perl

use strict;
use warnings;

use Getopt::Std;
use LWP 5.64;


print STDOUT <<HEAD;
#################################
#                               #
#         perl-buster           #
#                               #
#################################
HEAD

# FUNCTIONS
sub get_help {
    print STDOUT <<HELP;
USAGE:
    perl perl-buster.pl [args]

EXAMPLE: 
    perl perl-buster.pl -u [BASE_URL] -w [WORDLIST]
    perl perl-buster.pl -u [BASE_URL] -w [WORDLIST] -t [TIME_BETWEEN_REQUESTS]
    perl perl-buster.pl -u [BASE_URL] -w [WORDLIST] -o [OUTPUT_FILE_PATH]
    perl perl-buster.pl -u [BASE_URL] -w [WORDLIST] -q

FLAGS: 
    -h,     help me find what this program does
    -u,     base URL
    -w,     path to the wordlist file
    -t,     time between requests, make process quieter
    -o,     relative path to output file
    -q,     quiet mode, no responses printed to console
    -p,     specify the port number to make requests to, default is 80
    -e,     use HTTPS instead of the default HTTP protocol
    -r,     specify the reponse codes separated by commas, 
                e.g. 2,3,4 this will return all 200-499 response codes
                e.g. 202,3,404 this will return 202, 300-399 and 404
HELP

exit;
}

sub get_browser {
    return LWP::UserAgent->new || die $!;
}

sub read_wordlist {
    my ($filename) = @_;

    open my $fh, "<", $filename;
    return $fh;
}

sub get_response_code {
    my ($url, $browser, $method) = @_;

    my $response;
    if ( $method eq "HEAD" ) {
        $response = $browser->head($url);
    }
    elsif ( $method eq "GET" ) {
        $response = $browser->get($url);
    }
    
    return $response->{_rc};
}

sub get_absolute_URL {
    my ($url_arg) = @_;

    if ( $url_arg !~ m/^http:\/\/|^https:\/\// ) {
        $url_arg = "http://".$url_arg;
    }
    return $url_arg;
}

sub write_to_file {
    my ($location, $info) = @_;

    open my $fh, ">>", $location || die $!;
    print $fh $info;
    close($fh);
}

sub set_port {
    my ($port, $url_string) = @_;

    die "A port should be an integer. e.g. -p 80 is default -p 443 is https, -p 8080 may be a test size or API." if $port !~ m/^\d+$/ or $port > 65535;
    return $url_string.":".$port;
}

sub set_https {
    my ($url_string) = @_;

    substr($url_string, 4, 0) = 's';
    return $url_string;
}

sub set_response_codes {
    my ($user_defined_codes) = @_;

    $user_defined_codes =~ s/,$//;
    $user_defined_codes =~ s/(\d),/$1|^/g;
    substr($user_defined_codes, 0, 0) = "^";

    return $user_defined_codes;
}


# OPTIONS
my %options = ();
getopts("hu:w:t:o:qp:er:g", \%options);

get_help() if defined $options{h};
my $url             = get_absolute_URL($options{u}) if defined $options{u} || die "Please use the -u flag to pass in a URL. Use -h for help.\n";
my $wordlist        = read_wordlist($options{w}) if defined $options{w} || die "Please use the -w flag and pass in a path to a wordlist. Use -h for help.\n";
my $sleeptime       = defined $options{t} ? $options{t} : 1;
my $output_loc      = $options{o} if defined $options{o};
my $quiet_mode      = $options{q} if defined $options{q};
$url                = set_port($options{p}, $url) if defined $options{p};
$url                = set_https($url) if defined $options{e};
my $response_codes  = defined $options{r} ? set_response_codes($options{r}) : "^2";
my $method          = defined $options{g} ? "GET" : "HEAD";


# MAIN
my $browser     = get_browser();
my $startTime   = time;

while ( <$wordlist> ) {

    my $full_url = $url."/".$_;
    my $rc = get_response_code($full_url, $browser, $method);

    if ( $rc =~ /$response_codes/ ) {
        print STDOUT $rc, " -> ", $full_url if not defined $quiet_mode;
        write_to_file($output_loc, "[".$rc."] ".$full_url) if defined $output_loc;
    }

    sleep($sleeptime);
}

my $totalTime = time-$startTime;
print STDOUT <<END;
#################################
Time to execute: $totalTime(s)
#################################
END
