#!/bin/sh
killall pbss.pl
cd /home/cod4/.callofduty4/pb/svss
./delpbss.pl
sleep 5
screen -A -d -m -s /home/cod4/.callofduty4/pb/svss/pbss.pl
