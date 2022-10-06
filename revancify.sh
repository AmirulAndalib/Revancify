#!/data/data/com.termux/files/usr/bin/bash

revive(){
    clear && echo "Script terminated" && rm -rf /data/data/com.termux/files/home/storage/Revancify/*cache ; tput cnorm ; cd ~; exit
}
trap revive SIGINT

# For update change this sentence here ...

internet()
{
    if ping -c 1 google.com > /dev/null 2>&1
    then
        return 0
    else
        clear
        intro
        echo "Oops! No Internet Connection available."
        echo "Connect to Internet and try again..."
        sleep 3s
        mainmenu
    fi
}

intro()
{
    tput civis
    tput cs 5 $LINES
    leave1=$(($(($(tput cols) - 34)) / 2))
    tput cm 1 $leave1
    echo "█▀█ █▀▀ █░█ ▄▀█ █▄░█ █▀▀ █ █▀▀ █▄█"
    tput cm 2 $leave1
    echo "█▀▄ ██▄ ▀▄▀ █▀█ █░▀█ █▄▄ █ █▀░ ░█░"
    tput cm 5 0
    tput sc
}

leavecols=$(($(($(tput cols) - 38)) / 2))
fullpagewidth=$(tput cols )
fullpageheight=$(($(tput lines) - 5 ))
get_components()
{
    internet
    clear
    intro
    if ls ./sources* > /dev/null 2>&1
    then
        :
    else
        echo '[{"patches" : {"repo" : "revanced", "branch" : "main"}}, {"cli" : {"repo" : "revanced", "branch" : "main"}}, {"integrations" : {"repo" : "revanced", "branch" : "main"}}]' | jq '.' > sources.json
    fi
    
    mapfile -t revanced_latest < <(python3 ./python-utils/revanced-latest.py)
    
    #get patches version
    patches_latest="${revanced_latest[0]}"

    #get cli version
    cli_latest="${revanced_latest[1]}"

    #get patches version
    int_latest="${revanced_latest[2]}"


    patchesrepo=$(jq -r '.[0].patches.repo' sources.json)

    clirepo=$(jq -r '.[1].cli.repo' sources.json)
    
    integrationsrepo=$(jq -r '.[2].integrations.repo' sources.json)
    #check patch
    if ls ./revanced-patches-* > /dev/null 2>&1
    then
        patches_available=$(basename revanced-patches* .jar | cut -d '-' -f 3) #get version
        if [ "$patches_latest" = "$patches_available" ]
        then
            echo "Latest Patches already exixts."
            echo ""
            wget -q -c https://github.com/"$patchesrepo"/revanced-patches/releases/download/v"$patches_latest"/revanced-patches-"$patches_latest".jar --show-progress --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
            echo ""
        else
            echo "Patches update available !!"
            rm revanced-patches*
            echo ""
            echo "Downloading latest Patches..."
            echo ""
            wget -q -c https://github.com/"$patchesrepo"/revanced-patches/releases/download/v"$patches_latest"/revanced-patches-"$patches_latest".jar --show-progress --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
            echo ""
        fi
    else
        echo "Downloading latest patches file..."
        echo ""
        wget -q -c https://github.com/"$patchesrepo"/revanced-patches/releases/download/v"$patches_latest"/revanced-patches-"$patches_latest".jar --show-progress --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
        echo ""
    fi

    #check cli
    if ls -l ./revanced-cli-* > /dev/null 2>&1
    then
        cli_available=$(basename revanced-cli* .jar | cut -d '-' -f 3) #get version
        if [ "$cli_latest" = "$cli_available" ]
        then
            echo "Latest CLI already exists."
            echo ""
            wget -q -c https://github.com/"$clirepo"/revanced-cli/releases/download/v"$cli_latest"/revanced-cli-"$cli_latest"-all.jar -O revanced-cli-"$cli_latest".jar --show-progress --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
            echo ""
        else
            echo "CLI update available !!"
            rm revanced-cli*
            echo ""
            echo "Downloading latest CLI..."
            echo ""
            wget -q -c https://github.com/"$clirepo"/revanced-cli/releases/download/v"$cli_latest"/revanced-cli-"$cli_latest"-all.jar -O revanced-cli-"$cli_latest".jar --show-progress --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
            echo ""
        fi
    else
        echo "Downloading latest CLI..."
        echo ""
        wget -q -c https://github.com/"$clirepo"/revanced-cli/releases/download/v"$cli_latest"/revanced-cli-"$cli_latest"-all.jar -O revanced-cli-"$cli_latest".jar --show-progress --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
        echo ""
    fi

    #check integrations
    if ls ./revanced-integrations-* > /dev/null 2>&1
    then
        int_available=$(basename revanced-integrations* .apk | cut -d '-' -f 3) #get version
        if [ "$int_latest" = "$int_available" ]
        then
            echo "Latest Integrations already exists."
            echo ""
            wget -q -c https://github.com/"$integrationsrepo"/revanced-integrations/releases/download/v"$int_latest"/app-release-unsigned.apk -O revanced-integrations-"$int_latest".apk --show-progress --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
            echo ""
        else
            echo "Integrations update available !!"
            rm revanced-integrations*
            echo ""
            echo "Downloading latest Integrations apk..."
            echo ""
            wget -q -c https://github.com/"$integrationsrepo"/revanced-integrations/releases/download/v"$int_latest"/app-release-unsigned.apk -O revanced-integrations-"$int_latest".apk --show-progress --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
            echo ""
            echo ""
        fi
    else
        echo "Downloading latest Integrations apk..."
        echo ""
        wget -q -c https://github.com/"$integrationsrepo"/revanced-integrations/releases/download/v"$int_latest"/app-release-unsigned.apk -O revanced-integrations-"$int_latest".apk --show-progress --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
        echo ""
        sleep 0.5s
        tput rc; tput ed
    fi
    mainmenu
}


sourcesedit()
{
    internet
    if ls ./sources* > /dev/null 2>&1
    then
        :
    else
        echo '[{"patches" : {"repo" : "revanced", "branch" : "main"}}, {"cli" : {"repo" : "revanced", "branch" : "main"}}, {"integrations" : {"repo" : "revanced", "branch" : "main"}}]' | jq '.' > sources.json
    fi
    patchesrepo=$(jq -r '.[0].patches.repo' sources.json)
    selectsource=$(dialog --begin 0 $leavecols --no-lines --infobox "█▀█ █▀▀ █░█ ▄▀█ █▄░█ █▀▀ █ █▀▀ █▄█\n█▀▄ ██▄ ▀▄▀ █▀█ █░▀█ █▄▄ █ █▀░ ░█░" 4 38 --and-widget --begin 5 0 --title 'Source Selection Menu' --no-lines --no-cancel --ok-label "Select" --menu "Select Source" $fullpageheight $fullpagewidth 10 1 "Official: Revanced" 2 "Custom: Inotia00" 2>&1> /dev/tty)
    if [ "$selectsource" -eq "1" ]
    then
        if [ "$patchesrepo" = "revanced" ]
        then
            echo '[{"patches" : {"repo" : "revanced", "branch" : "main"}}, {"cli" : {"repo" : "revanced", "branch" : "main"}}, {"integrations" : {"repo" : "revanced", "branch" : "main"}}]' | jq '.' > sources.json
        else
            echo '[{"patches" : {"repo" : "revanced", "branch" : "main"}}, {"cli" : {"repo" : "revanced", "branch" : "main"}}, {"integrations" : {"repo" : "revanced", "branch" : "main"}}]' | jq '.' > sources.json
            rm revanced-patches* && rm revanced-integrations* && rm revanced-cli* > /dev/null 2>&1
            get_components
        fi
    elif [ "$selectsource" -eq "2" ]
    then
        if [ "$patchesrepo" = "inotia00" ]
        then
            echo '[{"patches" : {"repo" : "inotia00", "branch" : "revanced-extended"}}, {"cli" : {"repo" : "inotia00", "branch" : "riplib"}}, {"integrations" : {"repo" : "inotia00", "branch" : "revanced-extended"}}]' | jq '.' > sources.json
        else
            echo '[{"patches" : {"repo" : "inotia00", "branch" : "revanced-extended"}}, {"cli" : {"repo" : "inotia00", "branch" : "riplib"}}, {"integrations" : {"repo" : "inotia00", "branch" : "revanced-extended"}}]' | jq '.' > sources.json
            rm revanced-patches* && rm revanced-integrations* && rm revanced-cli* > /dev/null 2>&1
            get_components
        fi
    fi
    mainmenu
}

selectapp()
{
    patchesrepo=$(jq -r '.[0].patches.repo' sources.json)
    if [ "$patchesrepo" = "revanced" ]
    then
        apps=(1 "YouTube" 2 "YouTube Music" 3 "Twitter" 4 "Reddit" 5 "TikTok")
    elif [ "$patchesrepo" = "inotia00" ]
    then
        apps=(1 "YouTube" 2 "YouTube Music")
    fi
    selectapp=$(dialog --begin 0 no$leavecols --no-lines --infobox "█▀█ █▀▀ █░█ ▄▀█ █▄░█ █▀▀ █ █▀▀ █▄█\n█▀▄ ██▄ ▀▄▀ █▀█ █░▀█ █▄▄ █ █▀░ ░█░" 4 38 --and-widget --begin 5 0 --title 'App Selection Menu' --no-lines --ok-label "Select" --menu "Select App" $fullpageheight $fullpagewidth 10 "${apps[@]}" 2>&1> /dev/tty)
    exitstatus=$?
    if [ "$exitstatus" -eq "0" ]
    then
        if [ "$selectapp" -eq "1" ]
        then
            appname=YouTube
            pkgname=com.google.android.youtube
        elif [ "$selectapp" -eq "2" ]
        then
            appname=YouTubeMusic
            pkgname=com.google.android.apps.youtube.music
        elif [ "$selectapp" -eq "3" ]
        then
            appname=Twitter
            pkgname=com.twitter.android
        elif [ "$selectapp" -eq "4" ]
        then
            appname=Reddit
            pkgname=com.reddit.frontpage
        elif [ "$selectapp" -eq "5" ]
        then
            appname=TikTok
            pkgname=com.ss.android.ugc.trill

        fi
    elif [ "$exitstatus" -ne "0" ]
    then
        mainmenu
    fi
}

selectpatches()
{  
    selectapp
    if ls ./patches* > /dev/null 2>&1
    then
        :
    else
        internet
        python3 ./python-utils/fetch-patches.py
    fi
    declare -a patches
    while read -r line
    do
        read -r -a eachline <<< "$line"
        patches+=("${eachline[@]}")
    done < <(jq -r --arg pkgname "$pkgname" 'map(select(.appname == $pkgname))[] | "\(.patchname) \(.status)"' patches.json)
    mapfile -t choices < <(dialog --begin 0 $leavecols --no-lines --infobox "█▀█ █▀▀ █░█ ▄▀█ █▄░█ █▀▀ █ █▀▀ █▄█\n█▀▄ ██▄ ▀▄▀ █▀█ █░▀█ █▄▄ █ █▀░ ░█░" 4 38 --and-widget --begin 5 0 --title 'Patch Selection Menu' --no-items --no-lines --ok-label "Save" --no-cancel --separate-output --checklist "Select patches to include" $fullpageheight $fullpagewidth 10 "${patches[@]}" 2>&1 >/dev/tty)
    tmp=$(mktemp)
    jq --arg pkgname "$pkgname" 'map(select(.appname == $pkgname).status = "off")' patches.json | jq 'map(select(IN(.patchname; $ARGS.positional[])).status = "on")' --args "${choices[@]}" > "$tmp" && mv "$tmp" ./patches.json
    mainmenu
}


patchoptions()
{
    if ls ./revanced-patches* > /dev/null 2>&1 && ls ./revanced-cli* > /dev/null 2>&1 && ls ./revanced-integrations* > /dev/null 2>&1
    then
        :
    else
        get_components
    fi
    java -jar ./revanced-cli*.jar -b ./revanced-patches*.jar -m ./revanced-integrations*.apk -c -a ./noinput.apk -o nooutput.apk > /dev/null 2>&1
    tput cnorm
    tmp=$(mktemp)
    dialog --begin 0 $leavecols --no-lines --infobox "█▀█ █▀▀ █░█ ▄▀█ █▄░█ █▀▀ █ █▀▀ █▄█\n█▀▄ ██▄ ▀▄▀ █▀█ █░▀█ █▄▄ █ █▀░ ░█░" 4 38 --and-widget --begin 5 0 --no-lines --title "Options File Editor" --editbox options.toml $fullpageheight $fullpagewidth 2> "$tmp" && mv "$tmp" ./options.toml
    tput civis
    mainmenu
}

mountapk()
{
    if [ "$pkgname" = "com.google.android.youtube" ]
    then
        echo "Unmounting YouTube..."
        echo "Please wait..."
        echo "This may take some time."
        su -c 'grep com.google.android.youtube /proc/mounts | while read -r line; do echo $line | cut -d " " -f 2 | sed "s/apk.*/apk/" | xargs -r umount -l > /dev/null 2>&1; done && am force-stop com.google.android.youtube'
        su -c "pm install ./$appname-$appver.apk"
        su -c "cp /data/data/com.termux/files/home/storage/Revancify/"$appname"Revanced-"$appver".apk /data/local/tmp/revanced.delete && mv /data/local/tmp/revanced.delete /data/adb/revanced/com.google.android.youtube.apk"
        echo "Mounting YouTube Revanced ..."
        su -mm -c 'stockapp=$(pm path com.google.android.youtube | grep base | sed 's/package://g') && revancedapp=/data/adb/revanced/com.google.android.youtube.apk && chmod 644 "$revancedapp" && chown system:system "$revancedapp" && chcon u:object_r:apk_data_file:s0 "$revancedapp" && mount -o bind "$revancedapp" "$stockapp" && am force-stop com.google.android.youtube && exit' > /dev/null 2>&1
        su -c 'monkey -p com.google.android.youtube 1' > /dev/null 2>&1
        sleep 2
        tput cnorm && cd ~
        pidof com.termux | xargs kill -9
    elif [ "$pkgname" = "com.google.android.apps.youtube.music" ]
    then
        echo "Unmounting YouTube Music..."
        echo "Please wait..."
        echo "This may take some time."
        su -c "pm install ./$appname-$appver.apk"
        su -c 'grep com.google.android.apps.youtube.music /proc/mounts | while read -r line; do echo $line | cut -d " " -f 2 | sed "s/apk.*/apk/" | xargs -r umount -l > /dev/null 2>&1; done'
        su -c "cp /data/data/com.termux/files/home/storage/Revancify/"$appname"Revanced-"$appver".apk /data/local/tmp/revanced.delete && mv /data/local/tmp/revanced.delete /data/adb/revanced/com.google.android.apps.youtube.music.apk"
        echo "Mounting YouTube Music Revanced ..."
        su -mm -c 'stockapp=$(pm path com.google.android.apps.youtube.music | grep base | sed 's/package://g') && revancedapp=/data/adb/revanced/com.google.android.apps.youtube.music.apk && chmod 644 "$revancedapp" && chown system:system "$revancedapp" && chcon u:object_r:apk_data_file:s0 "$revancedapp" && mount -o bind "$revancedapp" "$stockapp" && am force-stop com.google.android.apps.youtube.music && exit' > /dev/null 2>&1
        sleep 2
        su -c 'monkey -p com.google.android.apps.youtube.music 1' > /dev/null 2>&1
        tput cnorm && cd ~
        pidof com.termux | xargs kill -9
    fi
    tput cnorm
    rm -rf ./*cache
    cd ~ || exit
    exit
}

moveapk()
{
    mkdir -p /storage/emulated/0/Revancify
    mv "$appname"Revanced* /storage/emulated/0/Revancify/ &&
    echo "$appname App saved to Revancify folder." &&
    echo "Thanks for using Revancify..." &&
    [[ -f Vanced_MicroG.apk ]] && termux-open /storage/emulated/0/Revancify/Vanced_MicroG.apk
    termux-open /storage/emulated/0/Revancify/"$appname"Revanced-"$appver".apk
    pidof com.termux | xargs kill -9
}


dlmicrog()
{
    if dialog --begin 0 $leavecols --no-lines --infobox "█▀█ █▀▀ █░█ ▄▀█ █▄░█ █▀▀ █ █▀▀ █▄█\n█▀▄ ██▄ ▀▄▀ █▀█ █░▀█ █▄▄ █ █▀░ ░█░" 4 38 --and-widget --begin 5 0 --title 'MicroG Prompt' --no-items --defaultno --no-lines --yesno "Vanced MicroG is used to run MicroG services without root.\nYouTube and YouTube Music won't work without it.\nIf you already have MicroG, You don't need to download it.\n\n\n\n\n\nDo you want to download Vanced MicroG app?" $fullpageheight $fullpagewidth
        then
            clear
            intro
            wget -q -c "https://github.com/TeamVanced/VancedMicroG/releases/download/v0.2.24.220220-220220001/microg.apk" -O "Vanced_MicroG.apk" --show-progress --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
            echo ""
            mv "Vanced_MicroG.apk" /storage/emulated/0/Revancify
            echo MicroG App saved to Revancify folder.
            sleep 1s
    fi
}

checkresource()
{
    if ls ./revanced-patches* > /dev/null 2>&1 && ls ./revanced-cli* > /dev/null 2>&1 && ls ./revanced-integrations* > /dev/null 2>&1
    then
        return 0
    else
        get_components
    fi
}


checkpatched()
{
    if su -c exit > /dev/null 2>&1
    then
        if ls ./"$appname"Revanced-"$appver"* > /dev/null 2>&1
        then
            if dialog --begin 0 $leavecols --no-lines --infobox "█▀█ █▀▀ █░█ ▄▀█ █▄░█ █▀▀ █ █▀▀ █▄█\n█▀▄ ██▄ ▀▄▀ █▀█ █░▀█ █▄▄ █ █▀░ ░█░" 4 38 --and-widget --begin 5 0 --title 'Patched APK found' --no-items --defaultno --no-lines --yesno "Current directory already contains $appname Revanced version $appver. \n\n\nDo you want to patch $appname again?" $fullpageheight $fullpagewidth
            then
                rm ./"$appname"Revanced-"$appver"*
            else
                clear
                intro
                mountapk
            fi
        else
            rm ./"$appname"Revanced-* > /dev/null 2>&1
        fi
    else
        if ls /storage/emulated/0/Revancify/"$appname"Revanced-"$appver"* > /dev/null 2>&1
        then
            if dialog --begin 0 $leavecols --no-lines --infobox "█▀█ █▀▀ █░█ ▄▀█ █▄░█ █▀▀ █ █▀▀ █▄█\n█▀▄ ██▄ ▀▄▀ █▀█ █░▀█ █▄▄ █ █▀░ ░█░" 4 38 --and-widget --begin 5 0 --title 'Patched APK found' --no-items --defaultno --no-lines --yesno "Patched $appname with version $appver already exists. \n\n\nDo you want to patch $appname again?" $fullpageheight $fullpagewidth
            then
                :
            else
                clear
                intro
                termux-open /storage/emulated/0/Revancify/"$appname"Revanced-"$appver".apk
                tput cnorm
                rm -rf ./*cache
                cd ~ || exit
                exit
            fi
        fi
    fi

}

arch=$(getprop ro.product.cpu.abi | cut -d "-" -f 1)

sucheck()
{
    if su -c exit > /dev/null 2>&1
    then
        su -c "mkdir -p /data/adb/revanced"
        if su -c "ls /data/adb/service.d/mount_revanced*" > /dev/null 2>&1
        then
            :
        else
            su -c "cp mount_revanced_com.google.android.youtube.sh /data/adb/service.d/ && chmod +x /data/adb/service.d/mount_revanced_com.google.android.youtube.sh"
            su -c "cp mount_revanced_com.google.android.apps.youtube.music.sh /data/adb/service.d/ && chmod +x /data/adb/service.d/mount_revanced_com.google.android.apps.youtube.music.sh"
        fi
        if su -c "dumpsys package $pkgname" | grep -q path
        then
            :
        else
            sleep 0.5s
            echo "Oh No, $appname is not installed"
            echo ""
            sleep 0.5s
            echo "Install $appname from PlayStore and run this script again."
            tput cnorm
            cd ~ || exit
            exit
        fi
    else
        sed -i '/allow_external_apps/s/"# "//' ~/.termux/termux.properties
        dlmicrog
    fi
}

# App Downloader
app_dl()
{
    internet
    if ls ./"$appname"-* > /dev/null 2>&1
    then
        app_available=$(basename "$appname"-* .apk | cut -d '-' -f 2) #get version
        if [ "$appver" = "$app_available" ]
        then
            echo "Latest $appname apk already exists."
            echo ""
            sleep 0.5s
            wget -q -c "$applink" -O "$appname"-"$appver".apk --show-progress --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
            sleep 0.5s
            tput rc; tput ed
        else
            echo "$appname update available !!"
            sleep 0.5s
            tput rc; tput ed
            echo "Removing previous $appname apk..."
            rm $appname-*.apk
            sleep 0.5s
            tput rc; tput ed
            echo "Downloading latest $appname apk..."
            echo " "
            wget -q -c "$applink" -O "$appname"-"$appver".apk --show-progress --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
            sleep 0.5s
            tput rc; tput ed
        fi
    else
        echo "No $appname apk found in Current Directory"
        echo " "
        echo "Downloading latest $appname apk..."
        echo " "
        wget -q -c "$applink" -O "$appname"-"$appver".apk --show-progress --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
        sleep 0.5s
        tput rc; tput ed
    fi
}

patchinclusion()
{
    includepatches=$(while read -r line; do printf %s"$line" " "; done < <(jq -r --arg pkgname "$pkgname" 'map(select(.appname == $pkgname and .status == "on"))[].patchname' patches.json | sed "s/^/-i /g"))
}

versionselector()
{
    if su -c exit > /dev/null 2>&1
    then
        if [ "$pkgname" = "com.google.android.youtube" ] || [ "$pkgname" = "com.google.android.apps.youtube.music" ]
        then
            appver=$(su -c dumpsys package $pkgname | grep versionName | cut -d= -f 2 )
        fi
    else
        internet
        mapfile -t appverlist < <(python3 ./python-utils/version-list.py "$appname")
        appver=$(dialog --begin 0 $leavecols --no-lines --infobox "█▀█ █▀▀ █░█ ▄▀█ █▄░█ █▀▀ █ █▀▀ █▄█\n█▀▄ ██▄ ▀▄▀ █▀█ █░▀█ █▄▄ █ █▀░ ░█░" 4 38 --and-widget --begin 5 0 --title "Version Selection Menu" --no-items --no-cancel --no-lines --ok-label "Select" --menu "Choose App Version" $fullpageheight $fullpagewidth 10 "${appverlist[@]}" 2>&1> /dev/tty)
    fi
}

fetchapk()
{
    internet
    clear
    intro
    echo "Please wait while the link is being fetched..."
    applink=$(python3 ./python-utils/fetch-link.py "$appname" "$appver" "$arch")
    tput rc; tput ed
    app_dl
}

patchapp()
{
    echo "Patching $appname..."
    patchinclusion
    java -jar ./revanced-cli*.jar -b ./revanced-patches*.jar -m ./revanced-integrations*.apk -c -a ./"$appname"-"$appver".apk $includepatches --keystore ./revanced.keystore -o ./"$appname"Revanced-"$appver".apk --custom-aapt2-binary ./aapt2_"$arch" --options options.toml --experimental --exclusive &&
    sleep 3
}

#Build apps
buildapp()
{
    selectapp
    checkresource
    if ls ./patches* > /dev/null 2>&1
    then
        :
    else
        internet
        python3 ./python-utils/fetch-patches.py
    fi
    if [ "$pkgname" = "com.google.android.youtube" ] || [ "$pkgname" = "com.google.android.apps.youtube.music" ]
    then
        sucheck
        versionselector
        checkpatched
        fetchapk
        patchapp
        if su -c exit > /dev/null 2>&1
        then
            mountapk
        else
            moveapk
        fi

    else
        versionselector
        checkpatched
        fetchapk
        patchapp
        moveapk
    fi
}



mainmenu()
{
    tput rc; tput ed
    patchesrepo=$(jq -r '.[0].patches.repo' sources.json)
    if [ "$patchesrepo" = "revanced" ]
    then
        menuoptions=(1 "Patch App" 2 "Select Patches" 3 "Edit Sources" 4 "Update Resources" 5 "Edit Patch Options")
    elif [ "$patchesrepo" = "inotia00" ]
    then
        menuoptions=(1 "Patch App" 2 "Select Patches" 3 "Edit Sources" 4 "Update Resources")
    fi
    mainmenu=$(dialog --begin 0 $leavecols --no-lines --infobox "█▀█ █▀▀ █░█ ▄▀█ █▄░█ █▀▀ █ █▀▀ █▄█\n█▀▄ ██▄ ▀▄▀ █▀█ █░▀█ █▄▄ █ █▀░ ░█░" 4 38 --and-widget --begin 5 0 --title 'Select App' --no-lines --ok-label "Select" --cancel-label "Exit" --menu "Select Option" $fullpageheight $fullpagewidth 10 "${menuoptions[@]}" 2>&1> /dev/tty)
    exitstatus=$?
    if [ "$exitstatus" -eq "0" ]
    then
        if [ "$mainmenu" -eq "1" ]
        then
            buildapp
        elif [ "$mainmenu" -eq "2" ]
        then
            selectpatches
        elif [ "$mainmenu" -eq "3" ]
        then
            sourcesedit
        elif [ "$mainmenu" -eq "4" ]
        then
            get_components
        elif [ "$mainmenu" -eq "5" ]
        then
            patchoptions
        fi
    elif [ "$exitstatus" -ne "0" ]
    then
        revive
    fi
}

mainmenu