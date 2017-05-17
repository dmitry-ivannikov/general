#!/bin/bash

inkrementDay=$DAYS #либо так
#inkrementDay=-2 

#date of acces log file and name of test folder 
accessLogDate="$(date -d "$inkrementDay day" +"%Y%m%d")"           

#name of reportFolder
reportFolderNname="$(date +%Y-%m-%d-%H-%M-%S)"                     

#dir of reportFolder
reportFolderDir=/home/qateam/Reports/publo-mel/                    

#project filder
dirOfProjectTest=/home/qateam/melloadtest                          

#fullname of accesslog file
nameOfAccessLogFile=pablo-mel-main_$accessLogDate.access.log       

#fullname of accesslog archive
nameOfAccessLogArchive=$nameOfAccessLogFile.gz 

#directory of accesslog archive
dirOfAccessLogFrom=/mnt/logs/nginx/nginx/$nameOfAccessLogArchive   

#dir of test
dirOfLoadTest=$dirOfProjectTest/$accessLogDate                     

#url for download conf.ini
urlofIniFile=https://raw.githubusercontent.com/qateam2/general/master/conf.ini 


copy_accesslog() { 
mkdir -p "$dirOfLoadTest"
cp $dirOfAccessLogFrom $dirOfLoadTest
gunzip -f "$dirOfLoadTest/$nameOfAccessLogArchive"
}



delete_lines() { 
sed -i '/HTTP\/1.[0,1]\" [4,5]/d' "$dirOfLoadTest/$nameOfAccessLogFile"
sed -i '/300\] \"[HEAD,POST]/d' "$dirOfLoadTest/$nameOfAccessLogFile"
}


copyresults(){ 
mkdir -p "$reportFolderDir/$reportFolderNname" 
find $dirOfLoadTest -iname '*.html' -and -type f -mmin -1 -exec cp '{}' $reportFolderDir/$reportFolderNname \; # Search and copy new results file
}


deletefiles(){
rm -rf $dirOfProjectTest/$accessLogDate
}

#copy access.log file from publo dir
copy_accesslog  

# download conf.ini file for yandex-tank  
curl -o "$dirOfLoadTest/conf.ini" $urlofIniFile

# Delete requests with 400 & 500 code
delete_lines  

# mixing queries
shuf "$dirOfLoadTest/$nameOfAccessLogFile" --output="$dirOfLoadTest/$nameOfAccessLogFile"

# now fullname if accessLogFile is access.log its for cofig ini file
mv -f "$dirOfLoadTest/$nameOfAccessLogFile" "$dirOfLoadTest/access.log"

# start load test
cd $dirOfLoadTest
yandex-tank -c "conf.ini"

#copy results from test dir to publoc results dir
copyresults
#deletefiles
