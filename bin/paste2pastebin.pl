#!/usr/bin/perl -w
#
#	Author:		Fred Blaise <chapeaurouge_at_madpenguin_dot_org>
#	Date:		21 Nov 2005
#	Purpose:	Make it easy to paste a file to pastebin.ca
#
#	Updated:	29 May 2007 by Stephen Olesen <admin at pastebin dot ca>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#  
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
use strict;
use WWW::Mechanize;
use Getopt::Long;

# Types of text, and their option number
# 
# [22/ASP|18/Action Script|19/Ada Source|20/Apache Configuration|21/Assembly (NASM)|2/Asterisk Configuration|23/BASH Script|3/C Source|9/C# Source|4/C++ Source|24/CSS|25/Delphi Source|26/HTML 4.0 Strict|7/Java Source|27/JavaScript|28/LISP Source|29/Lua Source|30/Microprocessor ASM|31/Objective C|5/PHP Source|14/PL/I Source|12/Pascal Source|6/Perl Source|11/Python Source|*1/Raw|10/Ruby Source|16/SQL Statement|17/Scheme Source|32/Visual Basic .NET|8/Visual Basic Source|15/XML Document|13/mIRC Script]

# Expiry options
#  [*/Never|5 minutes|10 minutes|15 minutes|30 minutes|45 minutes|1 hour|2 hours|4 hours|8 hours|12 hours|1 day|2 days|3 days|1 week|2 weeks|3 weeks|1 month|2 months|3 months|4 months|5 months|6 months|1 year]

# api_key is used for spam protection methods, do not adjust this or pastes may fail
my $api_key       = "Exzsm6iiGK8zDe6chLDZJDlHOmUtbb0L";
my $pastebin_url  = "http://pastebin.ca/quiet-paste.php?api=$api_key";
my $pastebin_root = "http://pastebin.ca";

my %f = (
	content		=>	'',
	description	=>	'',
	type		=>	'1',
	expiry		=>	'45 minutes',
	name		=>	'clipboard',
);

GetOptions ( \%f,
		"content=s",
		"description=s",
		"type=i",
		"expiry=s",
		"name=s"
) || die $!;

my $boy = WWW::Mechanize->new();

$boy->get($pastebin_url);

die $! unless ($boy->success());

unless ($f{content}) {
## -- Commented this out since it can be identified by API key
#	$f{description} = $ARGV[0];
#	$f{description} .= " -- automated paste by paste2pastebin.pl";
	$f{content} = join "", <>;
}

$boy->form_name('pasteform');
$boy->set_fields(%f);
$boy->submit_form( button => 's');

die unless ($boy->success);

my $content = $boy->content();
if($content =~ m/^SUCCESS:(.*)/) {
    print $pastebin_root . "/" . $1;
} else {
    print $content;
}