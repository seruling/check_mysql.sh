#!/bin/bash

# mmmmmm.txt created in webroot. and newest entry goes to the 1st line. easier to view "log" from web browser
# mmmmmm.txt will keep the latest 100 entry. sed on line 35 will ensure this
# curl is use to "write" the log into web access log.
#

mysqlstatus=$(systemctl is-active mysql)
datetime=$(date)

if [ $mysqlstatus = "active" ];
then
        output="${datetime} ok";
        curl https://web/mmmmmm.txt?status=ok
        sed -i "1i$output" /var/www/web/mmmmmm.txt
else
        output="${datetime} KO";
        curl https://web/mmmmmm.txt?status=KO
        sed -i "1i$output" /var/www/web/mmmmmm.txt

        countko=$(head -n5 /var/www/web/mmmmmm.txt | grep "KO" | wc -l)
        echo $countko

        if [ $countko -ge 5 ];
        then
                sed -i "1i$datetime reboot" /var/www/web/mmmmmm.txt
                curl https://web/mmmmmm.txt?status=reboot
                echo $countko "reboot"
                reboot
        else
                service mysql stop
                sleep 8
                service mysql start
        fi
fi

#sed -i "1i$output" /var/www/web/mmmmmm.txt
sed -i -e "100,500000d" /var/www/web/mmmmmm.txt
