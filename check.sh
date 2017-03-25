#!/bin/bash
log=$( cat /home/martin/webcrawler/scriptconfig/check_log.txt)
while read I
do J="$(sqlite3 /home/martin/webcrawler/postliste_2 "SELECT *FROM avsender where avsender like '%$I%'")";
if  [ "$J" != "" ] && [ "$J" != " " ]
then
echo "$J"
echo "---------------------------------------------------------------------------"
sqlite3 /home/martin/webcrawler/postliste_2 <<EOS
.separator " "
.mode column
select dato, saksnr, tema from post where avsender ='$J';
EOS
echo " "
fi
K="$(sqlite3 /home/martin/webcrawler/postliste_2 "select hentet from post where avsender ='$J'and hentet > '$log'")"; 
if [ "$K" != "" ]
then
echo "$J" >> /home/martin/webcrawler/nypost.txt
echo "---------------------------------------------------------------------------" >> /home/martin/webcrawler/nypost.txt
sqlite3 /home/martin/webcrawler/postliste_2 >> /home/martin/webcrawler/nypost.txt <<EOS1
.separator " "
.mode column
select dato, saksnr, tema from post where avsender = '$J' and hentet > '$log';
EOS1
echo " " >> /home/martin/webcrawler/nypost.txt
fi
done < /home/martin/webcrawler/scriptconfig/venner.txt
python3 /home/martin/webcrawler/printtime.py > /home/martin/webcrawler/scriptconfig/check_log.txt
newmail=$( cat /home/martin/webcrawler/nypost.txt)
dato=$( cat /home/martin/webcrawler/scriptconfig/check_log.txt)

if [ "$newmail" != "" ]
then
mail -s "Postliste Sande kommune $dato" martgra@gmail.com < /home/martin/webcrawler/nypost.txt
#mail -s "Postliste Sande kommune $dato" o_fredriksen@hotmail.com < /home/martin/webcrawler/nypost.txt
mail -s "Postliste Sande kommune $dato" petterkgran@gmail.com < /home/martin/webcrawler/nypost.txt
mail -s "Postliste Sande kommune $dato" kristoffer.gran@gmail.com < /home/martin/webcrawler/nypost.txt
mail -s "Postliste Sande kommune $dato" tomas.gran@gmail.com < /home/martin/webcrawler/nypost.txt


mv /home/martin/webcrawler/nypost.txt /home/martin/webcrawler/_old/mail/"$dato"
fi

