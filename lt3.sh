#!/bin/bash
incrementDay=$DAYS
#incrementDay=-2 

#date of acces log file and name of test folder 
accessLogDate="$(date -d "$incrementDay day" +"%Y%m%d")" 
          
#name of reportFolder
reportFolderNname="$(date +%Y-%m-%d-%H-%M-%S)"  
                   
#dir of reportFolder
reportFolderDir=/home/qateam/Reports/publo-mel/   
                 
#fullname of accesslog file
nameOfAccessLogFile=pablo-mel-main_$accessLogDate.access.log

#fullname of accesslog file2
nameOfAccessLogFile2=pablo-mel-main_$accessLogDate.access2.log

#fullname of accesslog archive
nameOfAccessLogArchive=$nameOfAccessLogFile.gz 

#directory of accesslog archive
dirOfAccessLogFrom=/mnt/logs/nginx/nginx/$nameOfAccessLogArchive
   
##dir of test
dirOfLoadTest=/home/qateam/workspace/TestLoadLan/general-master  
 
copy_accesslog() { 
mkdir -p "$dirOfLoadTest"
cp $dirOfAccessLogFrom $dirOfLoadTest
gunzip -f "$dirOfLoadTest/$nameOfAccessLogArchive"
}


copyresults(){ 
mkdir -p "$reportFolderDir/$reportFolderNname" 
find $dirOfLoadTest -iname '*.html' -and -type f -mmin -1 -exec cp '{}' $reportFolderDir/$reportFolderNname \; # Search and copy new results file
}


#copy access.log file from publo dir
copy_accesslog  

# Delete requests with 400 & 500 code 
awk '$9 < 400' "$dirOfLoadTest/$nameOfAccessLogFile" | grep GET > "$dirOfLoadTest/$nameOfAccessLogFile2"

# mixing queries
shuf "$dirOfLoadTest/$nameOfAccessLogFile2" --output="$dirOfLoadTest/access.log"
# start load test
##yandex-tank -c "conf.ini"
#copy results from test dir to publoc results dir
##copyresults
