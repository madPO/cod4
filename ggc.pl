#!/usr/bin/perl
#
# Copyright (C) 2013 Simon "madPO" Zor'kin
#
# This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
use LWP 5.64; 
use Date::Parse;
#Abbreviated name of the game.Look it up yourself - http://www.ggc-stream.net/banlist/info/overview.
$_gname = "cod4";
$_pref = "by GGC-Stream";
$_white = "MD5TOOL";
$_fname = "cod4.dat";
$_dirr = "/root/shared/pb";
#Create a proper bot that will emulate the browser.Otherwise we do not get a list of.
$browser = LWP::UserAgent->new;
$url = 'http://extern.ggc-stream.net/feed/banlist/'.$_gname.'.xml';
@ns_headers = (
   'User-Agent' => 'Mozilla/4.76 [en] (Win98; U)',
   'Accept' => 'image/gif, image/x-xbitmap, image/jpeg,
        image/pjpeg, image/png, */*',
   'Accept-Charset' => 'iso-8859-1,*,utf-8',
   'Accept-Language' => 'en-US',
  );
$response = $browser->get( $url, @ns_headers );
#At $list is a complete list of.
$list = $response->content; 
#Parsing a string by arrays. The array starts at 0, an array of all the match.
@guid = ($list =~ m/<GUID>(.*)<\/GUID>/g); 
@name = ($list =~ m/<Alias>(.*)<\/Alias>/g); 
@ip = ($list =~ m/<UserIP>(.*)<\/UserIP>/g); 
@viol = ($list =~ m/<Violation>(.*)<\/Violation>/g);
#get today's date
($sec,$min,$hour,$day, $month, $year) = (localtime)[0,1,2,3,4,5];
$year =$year + 1900;
$date = "[".$year."-".$month."-".$day." ".$hour.":".$min.":".$sec."]";
#Open file
open FILE , ">>".$_dirr."/".$_fname;
#Print in file
for($i=0;$i< scalar(@ip);$i++){
if (@viol[$i]=~! /$_white/){
print FILE "\n".$date." ".@guid[$i]." \"".@name[$i]."\" \"".@ip[$i]."\" ".@viol[$i]." ".$_pref; 
}
}
close FILE;
