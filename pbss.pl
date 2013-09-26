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
use DBI;
use Date::Parse;
use Fcntl;
#Setting $_dirr - directory,$_fname - file name,$_maxid - maximum id.
$_dirr = "/home/cod4/.callofduty4/pb/svss";
$_logname = "pbss.log";
$_fname = "pbsvss.htm";
$_maxid = "pb002000";
#open data base
$db = DBI->connect("DBI:mysql:bb3_main:","","");
#Open file
open FILE , $_dirr."/".$_fname;
sysopen LOG , $_dirr."/".$_logname,O_WRONLY | O_CREAT | O_TRUNC;
print LOG "#>> Start pbss parser: ".localtime()."\n";
#an endless cycle of reading
while(1){
#check the file size
 $size = -s $_dirr."/".$_fname;
 if ($pos < $size){
 if (!defined($db)){
 print LOG "#>> Нет подключения к бд!".localtime()."\n";
 die();
 }
#the strings of its length and translated into the following
#$str - file string, $len length of string(byte) 
  $str = <FILE>;
  $len = length($str);
  seek(FILE,$pos+$len,0);
  $pos = tell(FILE);
#processing line, $1 - id(pb...), $2 - name, $3 - guid, $4 -  date,$date - unix time.  
  $str =~ /.*href=(.*).htm.*<\/a>.\"(.*)\".\(W\).GUID=(.*)\(VALID\).\[(.*)\]/;
  print LOG "#>> Найдена строка. Id=".$1." name=".$2." guid=".$3." date=".$4."\n";
  #clearing the list, with overflow  
  $date = str2time($4);$id = quotemeta($1);$name = quotemeta($2);$guid = quotemeta($3);
#checking the existence of id, protection from mixing information  
  $count = $db->prepare("SELECT * FROM pbss_general WHERE `id`='$id'");
  $count->execute();
  @co = $count->fetchrow_array();
  if (scalar(@co) == 0){
#id like if not, create 
   $indb = $db->prepare("INSERT INTO `pbss_general` (`id`,`name`,`guid`,`date`) VALUES ('$id', '$name', '$guid', '$date')");
   $indb->execute;
    print LOG "#>> Найден новый скриншот! Id=".$id."\n";
  }else{
#id like if there is, replace  
   $updb = $db->prepare("UPDATE `pbss_general` SET `id`='$id',`name`='$name',`guid`='$guid',`date`='$date' WHERE `id`='$id'");
   $updb->execute;
   print LOG "#>> Перезаписываю старый скриншот. Id=".$id."\n";
  }
  if ($id =~/pb002000/){
  close FILE;
  sysopen SFILE, $_dirr."/".$_fname,O_WRONLY | O_CREAT | O_TRUNC;
  print SFILE "#>> Last time list was cleared: ".localtime()."\n";
  close SFILE;
  print LOG "#>> Обнаружен последний скриншот, переоткрываю ".$_fname." ,очищаю и записываю дату очищения.\n";
  sleep(30);
  open FILE , $_dirr."/".$_fname;
  if (!defined(<FILE>)){
 print LOG "#>> Не открылся файл!!!".localtime()."\n";
 die();
 }
 } 
 }else{
#if no new rows, then sleep for 15 seconds
 sleep(15);
 }
}
close FILE;
$db->disconnect;
