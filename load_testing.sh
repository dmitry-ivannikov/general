#!/bin/bash
#=)




#inkrementDay="$paramday"
#****************************************
inkrementDay=$DAYS

date="$(date -d "$inkrementDay day" +"%Y%m%d")"

#date="$(date -d "-2 day" +"%Y%m%d")"

download_accesslog() {
cd /home/qateam/melloadtest
mkdir -p "$date"
FULLNAME=pablo-mel-main_$date.access.log.gz
cp /mnt/logs/nginx/nginx/$FULLNAME /home/qateam/melloadtest/$date
cd $date
gunzip -f $FULLNAME
mv -f pablo-mel-main_$date.access.log ammo.txt
}

download_testini(){
wget /home/qateam/melloadtest/$date https://github.com/Estendr/Load-testing/archive/master.zip
unzip -j -o master.zip
rm master.zip
}

delete_lines() {
sed -i '/HTTP\/1.[0,1]\" [4,5]/d' ammo.txt
sed -i '/300\] \"[HEAD,POST]/d' ammo.txt
}

shuffle_lines() {
shuf ammo.txt --output=ammo.txt
}

replace_text() {
sed -i '496s/test.txt/ammo.txt/' /home/qateam/melloadtest/$date/test.ini
}

yandex_tank_start() {
yandex-tank "test.ini"
}

#replace_result_test(){
#cp /home/qateam/melloadtest/$d   /../../
#}

download_accesslog
download_testini
delete_lines
shuffle_lines
replace_text
#yandex_tank_start
#replace_result_test

exit 0
