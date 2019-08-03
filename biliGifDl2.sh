#!/bin/bash

##############################
##  Written by hyx0329      ##
##  E-mail:hyx0329@163.com  ##
##############################

## NEVER use "set -e" !!! | we need wget's return value to decide what to do
# set -x
DATE=$(date +%Y%m%d)
VERBOSE=0

get_main_gif() {

    # The code is not so pretty though
    # Any improvement is welcome

    if test ! -d "mainPageGif-$DATE"; then
        mkdir "mainPageGif-$DATE"
    fi
    cd "mainPageGif-$DATE"

    # input list
    echo
    echo "Downloading List"
    echo

    wget -O "index-icon-$DATE.json" --append-output info.log https://www.bilibili.com/index/index-icon.json

    # loop for download
    for ((i = 0; ; i++)); do

        #jq command
        NCOMAND='jq '.fix[$i].title''
        ACOMAND='jq '.fix[$i].icon''
        UCOMAND='jq '.fix[$i].links''

        # Well, some gifs have no title($NAME), it's bilibili's problem, to be fixed
        NAME=$($NCOMAND <"index-icon-$DATE.json" | iconv -f utf-8 -t utf-8 | sed 's/\ /\_/g;s/\"//g')
        ADDR=$($ACOMAND <"index-icon-$DATE.json" | iconv -f utf-8 -t utf-8 | sed 's/\"//g')
        URLS=$($UCOMAND <"index-icon-$DATE.json" | sed -r 's/\ \ //g;s/\"//g;s/\]//g;s/\[//g')
        # URLS=$($UCOMAND <"index-icon-$DATE.json" | sed -r 's/\"//g;/^[*./d;/*.]$/d')

        # The solution to the missing name issue mentioned above
        if [ ! "$NAME" ]; then
            # NAME=$(echo ${URLS##*=}" | sed 's/%20/\_/g')
            NAME=${URLS##*=}
            NAME=${NAME//%20/_}
        fi

        ORIGIN=${ADDR##*/} # means original name

        # Ban "null"
        if [ "$NAME" != "null" ]; then

            # Create a gif-url list
            {
                echo "$NAME-$ORIGIN"
                echo "$URLS"
                echo
            } >>"list-$DATE.txt"
            # Output
            if [ $VERBOSE = 1 ]; then
                echo "$NAME-$ORIGIN"
                echo "$URLS"
                echo
            fi
            wget -O "$NAME-$ORIGIN" -a info.log "http:$ADDR" &
        else
            break
        fi

        # sleep is required due to unconfirmed issue
        sleep 0.1
        # Finish
    done

    # Remove log
    #rm index-icon.json
    sleep 2s # to make sure info.log is free to remove
    rm info.log

    cd ..
}

function get_live_presents() {
    if test ! -d liveRoomGif; then
        mkdir liveRoomGif
    fi
    cd liveRoomGif
    i=0
    while [ $? -eq 0 ]; do
        ((i++))
        sleep 0.1
        wget "http://static.hdslb.com/live-static/live-room/images/gift-section/gift-$i.png" &
        sleep 0.1
        wget "http://static.hdslb.com/live-static/live-room/images/gift-section/gift-$i.gif" &

    done
    cd ..
}

function get_404_manga() {
    if test ! -d 404-manga; then
        mkdir 404-manga
    fi
    cd 404-manga
    i=0
    while [ $? -eq 0 ]; do
        ((i++))
        sleep 0.1
        wget "http://activity.hdslb.com/zzjs/cartoon/errorPage-manga-$i.png" &
    done
    cd ..
}

# The code below is applied to "https://www.bilibili.com/activity/web/view/data/"+NUM
# Currently it is used to download mangas in group(vid-31)
function get_vid31_data() {

    if test ! -d vid-31; then
        mkdir vid-31
    fi
    cd vid-31

    # input list
    echo
    echo "Downloading List"
    echo

    # Download and extract data
    wget -O - -a info.log https://www.bilibili.com/activity/web/view/data/31 | gzip -d > "index-31-$DATE.json"

    echo "Downloading images"
    # loop for download
    for ((i = 0; ; i++)); do

        #jq command
        NCOMAND='jq '.data.list[$i].name''
        ACOMAND='jq '.data.list[$i].data.img''

        #
        NAME=$($NCOMAND <"index-31-$DATE.json" | iconv -f utf-8 -t utf-8 | sed 's/\"//g')
        ADDR=$($ACOMAND <"index-31-$DATE.json" | sed 's/\"//g')

        ORIGIN=${ADDR##*/}

        # Ban "null"
        if [ "$NAME" != "null" ]; then

            # Create a gif-url list
            {
                echo "$NAME-$ORIGIN"
                echo "$URLS"
                echo
            } >>"list$DATE.txt"
            # Output
            if [ $VERBOSE = 1 ]; then
                echo "$NAME-$ORIGIN"
                echo "$URLS"
                echo
            fi
            wget -O "$NAME-$ORIGIN" -a info.log "http:$ADDR"
        else
            break
        fi

        # sleep is required due to unconfirmed issue
        sleep 0.1
        # Finish
    done

    # Remove log
    #rm index-31-$DATE.json
    rm info.log

    cd ..
}

function merge_existing() {
    # Wait for improvement
    echo "Not functional yet!"
}

while [ $# -gt 0 ]; do
    case "$1" in
    --verbose | -v)
        echo Now infomation will be printed to screen.
        VERBOSE=1
        ;;
    --mainpage-gif)
        echo Downloading Mainpage Gifs ...
        get_main_gif
        ;;
    --live-presents)
        echo Downloading Live Room Presents ...
        get_live_presents
        ;;
    --404)
        echo Downloading 404 Mangas
        get_404_manga
        ;;
    --extra-manga)
        echo Downloading Extra Mangas
        get_vid31_data
        ;;
    *)
        echo "This is a simple tool to download pictures from bilibili.com "
        echo ""
        echo "Usage:"
        echo ""
        echo "--mainpage-gif                  Download main gifs"
        echo "--live-presents                 Download live room presents"
        echo "--404                           Download mangas"
        echo "--extra-manga                   Download extra mangas"
        echo "--verbose|-v                    Print info on screen"
        echo ""
        echo "e.g. ./biliGifDl2 --mainpage-gif"
        exit 0
        ;;
    esac
    shift
done

#get_main_gif
#get_live_presents
#get_404_manga
#get_vid31_data
exit 0
