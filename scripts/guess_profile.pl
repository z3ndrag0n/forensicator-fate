#!/usr/bin/perl
while(<>) {
    if (/Suggested Profile\(s\) \: (.*)$/) {
        $profiles = $1;
        @profiles = split / |,/, $profiles;
    }
    elsif (/Image Type \(Service Pack\) \: (.*)$/) {
        $profile = $1;
    }
}

open(my $fh, ">", "imageinfo.properties") or die "cannot open > imageinfo.properties: $!";
print $fh "VOLATILITY_PROFILE = ", grep(/SP$profile/,@profiles), "\n";
close $fh;
