#!/bin/bash

##############################
##  Written by hyx0329      ##
##  E-mail:hyx0329@163.com  ##
##############################



get_main_gif()
{
    
    # The code is not so pretty though
    # Any improvements are welcome
    
    if test ! -d mainPageGif; then
        mkdir mainPageGif
    fi
    cd mainPageGif
    
    
    # input list
    wget -O index-icon.json https://www.bilibili.com/index/index-icon.json
    
    # processing list
    i=0
    NAME=0
    
    # loop for download
    while true ; do
    
        ((i++))
        
        #jq command
        NCOMAND='jq '.fix[$i].title''
        ACOMAND='jq '.fix[$i].icon''
        NAME=`cat index-icon.json | $NCOMAND | iconv -f utf8 -t utf8 | sed 's/\"//g' | sed 's/\ /\_/g' `
        ADDR=`cat index-icon.json | $ACOMAND | iconv -f utf8 -t utf8 | sed 's/\"//g' `
        ORIGIN=${ADDR##*/}
        
        # Ban "null"
        if [ "$NAME" != "null" ]; then
            wget -O $NAME-$ORIGIN http:$ADDR
        else
            break
        fi
        
        # sleep is required due to unknown problems
        sleep 0.1
    # Finish
    done
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

get_errorpage_manga()
{
if test ! -d errorManga; then
        mkdir errorManga
    fi
cd errorManga
i=0
while [ $? -eq 0 ] ; do
    ((i++))
    sleep 0.1
    wget "http://activity.hdslb.com/zzjs/cartoon/errorPage-manga-$i.png" 
done
cd ..
}

get_main_gif
#get_live_presents
#get_errorpage_manga

exit 0