#!/bin/bash

##############################
##  Written by hyx0329      ##
##  E-mail:hyx0329@163.com  ##
##############################

## NEVER use "set -e" !!! | unknown issue
# set -x
DATE=$(date +%Y%m%d)

get_main_gif()
{
    
    # The code is not so pretty though
    # Any improvement is welcome
    
    if test ! -d mainPageGif-$DATE; then
        mkdir mainPageGif-$DATE
    fi
    cd mainPageGif-$DATE
    
    
    # input list
    echo
    echo "Downloading List"
    echo
    
    wget -O index-icon-$DATE.json --append-output info.log https://www.bilibili.com/index/index-icon.json
    

    # loop for download
    for (( i=0 ; ; i++ )); do
        
        #jq command
        NCOMAND='jq '.fix[$i].title''
        ACOMAND='jq '.fix[$i].icon''
        UCOMAND='jq '.fix[$i].links''
        
		# Well, some gifs have no title($NAME), it's bilibili's problem, to be fixed
        NAME=`cat index-icon-$DATE.json | $NCOMAND | iconv -f utf-8 -t utf-8 | sed 's/\"//g' | sed 's/\ /\_/g' `
        ADDR=`cat index-icon-$DATE.json | $ACOMAND | iconv -f utf-8 -t utf-8 | sed 's/\"//g' `
        URLS=`cat index-icon-$DATE.json | $UCOMAND | sed 's/\"//g' `
        
        ORIGIN=${ADDR##*/}
        
        
        
        # Ban "null"
        if [ "$NAME" != "null" ]; then
            
            # Create a gif-url list
            echo $NAME-$ORIGIN >> list$DATE.txt
            echo $URLS >> list$DATE.txt
            echo >> list$DATE.txt
            # Output
            echo $NAME-$ORIGIN
            echo $URLS
            echo 
            
            wget -O $NAME-$ORIGIN --append-output info.log http:$ADDR
        else
            break
        fi

        # sleep is required due to unknown problems
        sleep 0.1
    # Finish
    done

# Remove log
#rm index-icon.json
rm info.log

cd ..
}


get_live_presents()
{
if test ! -d liveRoomGif; then
        mkdir liveRoomGif
    fi
cd liveRoomGif
i=0
while [ $? -eq 0 ] ; do
    ((i++))
    sleep 0.1
    wget "http://static.hdslb.com/live-static/live-room/images/gift-section/gift-$i.png"
    sleep 0.1
    wget "http://static.hdslb.com/live-static/live-room/images/gift-section/gift-$i.gif"

done
cd ..
}

get_404_manga()
{
if test ! -d 404-manga; then
        mkdir 404-manga
    fi
cd 404-manga
i=0
while [ $? -eq 0 ] ; do
    ((i++))
    sleep 0.1
    wget "http://activity.hdslb.com/zzjs/cartoon/errorPage-manga-$i.png" 
done
cd ..
}

merge_existing()
{
# Wait for improvement
echo "Not functional yet!"
}

#get_main_gif
#get_live_presents
#get_404_manga

exit 0
