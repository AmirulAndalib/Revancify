#!/data/data/com.termux/files/usr/bin/bash

terminatescript(){
    clear && echo "Script terminated" ; rm -rf ./*cache; tput cnorm ; cd ~ ; exit
}
trap terminatescript SIGINT

# For update change this sentence here ...

internet()
{
    if ping -c 1 google.com > /dev/null 2>&1
    then
        return 0
    else
        dialog --begin 0 $leavecols --keep-window --no-lines --no-shadow --infobox "█▀█ █▀▀ █░█ ▄▀█ █▄░█ █▀▀ █ █▀▀ █▄█\n█▀▄ ██▄ ▀▄▀ █▀█ █░▀█ █▄▄ █ █▀░ ░█░" 4 38 --and-widget --msgbox "Oops! No Internet Connection available.\n\nConnect to Internet and try again later" 10 35
        mainmenu
    fi
}

intro()
{
    tput civis
    tput cs 4 $(tput lines)
    leave1=$(($(($(tput cols) - 34)) / 2))
    tput cm 1 $leave1
    echo "█▀█ █▀▀ █░█ ▄▀█ █▄░█ █▀▀ █ █▀▀ █▄█"
    tput cm 2 $leave1
    echo "█▀▄ ██▄ ▀▄▀ █▀█ █░▀█ █▄▄ █ █▀░ ░█░"
    tput cm 5 0
    tput sc
}

leavecols=$(($(($(tput cols) - 38)) / 2))
fullpagewidth=$(tput cols )
fullpageheight=$(($(tput lines) - 5 ))
header=(dialog --begin 0 $leavecols --keep-window --no-lines --no-shadow --infobox "█▀█ █▀▀ █░█ ▄▀█ █▄░█ █▀▀ █ █▀▀ █▄█\n█▀▄ ██▄ ▀▄▀ █▀█ █░▀█ █▄▄ █ █▀░ ░█░" 4 38 --and-widget --begin 5 0)

fetchresources()
{
    internet
    clear
    intro
    if ! ls ./sources* > /dev/null 2>&1
    then
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
            echo "Latest Patches already exists."
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
            echo "Latest CLI already exist."
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


changesource()
{
    internet
    patchesrepo=$(jq -r '.[0].patches.repo' sources.json)
    if [ "$patchesrepo" = "revanced" ]
    then
        selectedsolurce=(1 "Official: Revanced" on 2 "Custom: Inotia00" off)
    elif [ "$patchesrepo" = "inotia00" ]
    then
        selectedsolurce=(1 "Official: Revanced" off 2 "Custom: Inotia00" on)
    fi
    selectsource=$("${header[@]}" --title ' Source Selection Menu ' --keep-window --no-shadow --no-cancel --ok-label "Done" --radiolist "Use arrow keys to navigate; Press Spacebar to select option" $fullpageheight $fullpagewidth 10 "${selectedsolurce[@]}" 2>&1> /dev/tty)
    if [ "$selectsource" -eq "1" ]
    then
        if [ "$patchesrepo" = "revanced" ]
        then
            echo '[{"patches" : {"repo" : "revanced", "branch" : "main"}}, {"cli" : {"repo" : "revanced", "branch" : "main"}}, {"integrations" : {"repo" : "revanced", "branch" : "main"}}]' | jq '.' > sources.json
        else
            echo '[{"patches" : {"repo" : "revanced", "branch" : "main"}}, {"cli" : {"repo" : "revanced", "branch" : "main"}}, {"integrations" : {"repo" : "revanced", "branch" : "main"}}]' | jq '.' > sources.json
            rm revanced-patches* > /dev/null 2>&1
            rm revanced-integrations* > /dev/null 2>&1
            rm revanced-cli* > /dev/null 2>&1
            python3 ./python-utils/fetch-patches.py
            fetchresources
        fi
    elif [ "$selectsource" -eq "2" ]
    then
        if [ "$patchesrepo" = "inotia00" ]
        then
            echo '[{"patches" : {"repo" : "inotia00", "branch" : "revanced-extended"}}, {"cli" : {"repo" : "inotia00", "branch" : "riplib"}}, {"integrations" : {"repo" : "inotia00", "branch" : "revanced-extended"}}]' | jq '.' > sources.json
        else
            echo '[{"patches" : {"repo" : "inotia00", "branch" : "revanced-extended"}}, {"cli" : {"repo" : "inotia00", "branch" : "riplib"}}, {"integrations" : {"repo" : "inotia00", "branch" : "revanced-extended"}}]' | jq '.' > sources.json
            rm revanced-patches* && rm revanced-integrations* && rm revanced-cli* > /dev/null 2>&1
            python3 ./python-utils/fetch-patches.py
            fetchresources
        fi
    fi
    mainmenu
}

selectapp()
{
    patchesrepo=$(jq -r '.[0].patches.repo' sources.json)
    if [ "$patchesrepo" = "revanced" ]
    then
        apps=(1 "YouTube" 2 "YT Music" 3 "Twitter" 4 "Reddit" 5 "TikTok")
    elif [ "$patchesrepo" = "inotia00" ]
    then
        apps=(1 "YouTube" 2 "YT Music")
    fi
    selectapp=$("${header[@]}" --title ' App Selection Menu ' --keep-window --no-shadow --ok-label "Select" --menu "Use arrow keys to navigate" $fullpageheight $fullpagewidth 10 "${apps[@]}" 2>&1> /dev/tty)
    exitstatus=$?
    if [ $exitstatus -eq 0 ]
    then
        if [ "$selectapp" -eq "1" ]
        then
            appname=YouTube
            pkgname=com.google.android.youtube
        elif [ "$selectapp" -eq "2" ]
        then
            appname=YTMusic
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
    elif [ $exitstatus -ne 0 ]
    then
        mainmenu
    fi
}

selectpatches()
{  
    patchselectionheight=$(($(tput lines) - 6))
    if ! ls ./patches* > /dev/null 2>&1
    then
        internet
        python3 ./python-utils/fetch-patches.py
    fi
    declare -a patchesinfo
    readarray -t patchesinfo < <(jq -r --arg pkgname "$pkgname" 'map(select(.appname == $pkgname))[] | "\(.patchname)\n\(.status)\n\(.description)"' patches.json)
    choices=($("${header[@]}" --title ' Patch Selection Menu ' --item-help --no-items --keep-window --no-shadow --help-button --help-label "Exclude all" --extra-button --extra-label "Include all" --ok-label "Save" --no-cancel --checklist "Use arrow keys to navigate; Press Spacebar to toogle patch" $patchselectionheight $fullpagewidth 10 "${patchesinfo[@]}" 2>&1 >/dev/tty))
    selectpatchstatus=$?
    patchsaver
}

patchsaver()
{
    if [ $selectpatchstatus -eq 0 ]
    then
        tmp=$(mktemp)
        jq --arg pkgname "$pkgname" 'map(select(.appname == $pkgname).status = "off")' patches.json | jq 'map(select(IN(.patchname; $ARGS.positional[])).status = "on")' --args "${choices[@]}" > "$tmp" && mv "$tmp" ./patches.json
        mainmenu
    elif [ $selectpatchstatus -eq 2 ]
    then
        tmp=$(mktemp)
        jq --arg pkgname "$pkgname" 'map(select(.appname == $pkgname).status = "off")' patches.json > "$tmp" && mv "$tmp" ./patches.json
        selectpatches
    elif [ $selectpatchstatus -eq 3 ]
    then
        tmp=$(mktemp)
        jq --arg pkgname "$pkgname" 'map(select(.appname == $pkgname).status = "on")' patches.json > "$tmp" && mv "$tmp" ./patches.json
        selectpatches
    fi
}


patchoptions()
{
    if ls ./revanced-patches* > /dev/null 2>&1 && ls ./revanced-cli* > /dev/null 2>&1 && ls ./revanced-integrations* > /dev/null 2>&1
    then
        :
    else
        fetchresources
    fi
    java -jar ./revanced-cli*.jar -b ./revanced-patches*.jar -m ./revanced-integrations*.apk -c -a ./noinput.apk -o nooutput.apk > /dev/null 2>&1
    tput cnorm
    tmp=$(mktemp)
    "${header[@]}" --keep-window --no-shadow --title ' Options File Editor ' --editbox options.toml $fullpageheight $fullpagewidth 2> "$tmp" && mv "$tmp" ./options.toml
    tput civis
    mainmenu
}

mountapk()
{   
    clear
    intro
    echo "Unmounting and Mouting $appname..."
    echo "This may take a while..."
    PKGNAME=$pkgname APPNAME=$appname APPVER=$appver su -mm -c 'grep $PKGNAME /proc/mounts | while read -r line; do echo $line | cut -d " " -f 2 | sed "s/apk.*/apk/" | xargs -r umount -l > /dev/null 2>&1; done &&\
    pm install ./"$APPNAME"-"$APPVER".apk &&\
    cp /data/data/com.termux/files/home/storage/Revancify/"$APPNAME"Revanced-"$APPVER".apk /data/local/tmp/revanced.delete &&\
    mv /data/local/tmp/revanced.delete /data/adb/revanced/"$PKGNAME".apk &&\
    stockapp=$(pm path $PKGNAME | grep base | sed "s/package://g") &&\
    revancedapp=/data/adb/revanced/"$PKGNAME".apk &&\
    chmod 644 "$revancedapp" &&\
    chown system:system "$revancedapp" &&\
    chcon u:object_r:apk_data_file:s0 "$revancedapp" &&\
    mount -o bind "$revancedapp" "$stockapp" &&\
    am force-stop $PKGNAME'
    sleep 1
    if [ "$pkgname" = "com.google.android.youtube" ]
    then
        su -c 'am start -n com.google.android.youtube/com.google.android.apps.youtube.app.watchwhile.WatchWhileActivity' > /dev/null 2>&1
    elif [ "$pkgname" = "com.google.android.apps.youtube.music" ]
    then
        su -c 'am start -n com.google.android.apps.youtube.music/com.google.android.apps.youtube.music.activities.MusicActivity' > /dev/null 2>&1
    fi
    su -c 'pidof com.termux | xargs kill -9'
}

moveapk()
{
    mkdir -p /storage/emulated/0/Revancify/
    mv "$appname"Revanced* /storage/emulated/0/Revancify/ > /dev/null 2>&1
    [[ -f Vanced_MicroG.apk ]] && termux-open /storage/emulated/0/Revancify/Vanced_MicroG.apk
    termux-open /storage/emulated/0/Revancify/"$appname"Revanced-"$appver".apk
    mainmenu
    return 0
}


dlmicrog()
{
    if "${header[@]}" --title ' MicroG Prompt ' --no-items --defaultno --keep-window --no-shadow --yesno "Vanced MicroG is used to run MicroG services without root.\nYouTube and YTMusic won't work without it.\nIf you already have MicroG, You don't need to download it.\n\n\n\n\n\nDo you want to download Vanced MicroG app?" $fullpageheight $fullpagewidth
        then
            clear
            intro
            wget -q -c "https://github.com/TeamVanced/VancedMicroG/releases/download/v0.2.24.220220-220220001/microg.apk" -O "Vanced_MicroG.apk" --show-progress --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
            echo ""
            mkdir -p /storage/emulated/0/Revancify
            mv "Vanced_MicroG.apk" /storage/emulated/0/Revancify/
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
        fetchresources
    fi
}


checkpatched()
{
    if [ "$variant" = "root" ]
    then
        if ls ./"$appname"Revanced-"$appver"* > /dev/null 2>&1
        then
            if "${header[@]}" --title ' Patched APK found ' --no-items --defaultno --keep-window --no-shadow --yesno "Current directory already contains $appname Revanced version $appver. \n\n\nDo you want to patch $appname again?" $fullpageheight $fullpagewidth
            then
                rm ./"$appname"Revanced-"$appver"*
            else
                mountapk
            fi
        else
            rm ./"$appname"Revanced-* > /dev/null 2>&1
        fi
    elif [ "$variant" = "nonroot" ]
    then
        if ls /storage/emulated/0/Revancify/"$appname"Revanced-"$appver"* > /dev/null 2>&1
        then
            if ! "${header[@]}" --title ' Patched APK found ' --no-items --defaultno --keep-window --no-shadow --yesno "Patched $appname with version $appver already exists. \n\n\nDo you want to patch $appname again?" $fullpageheight $fullpagewidth
            then
                moveapk
            fi
        fi
    fi
}

arch=$(getprop ro.product.cpu.abi | cut -d "-" -f 1)

sucheck()
{
    if su -c exit > /dev/null 2>&1
    then
        variant=root
        su -c "mkdir -p /data/adb/revanced"
        if ! su -c "ls /data/adb/service.d/mount_revanced*" > /dev/null 2>&1
        then
            su -c "cp mount_revanced_com.google.android.youtube.sh /data/adb/service.d/ && chmod +x /data/adb/service.d/mount_revanced_com.google.android.youtube.sh"
            su -c "cp mount_revanced_com.google.android.apps.youtube.music.sh /data/adb/service.d/ && chmod +x /data/adb/service.d/mount_revanced_com.google.android.apps.youtube.music.sh"
        fi
        if ! su -c "dumpsys package $pkgname" | grep -q path
        then
            internet
            readarray -t appverlist < <(python3 ./python-utils/version-list.py "$appname")
            appver=$("${header[@]}" --title ' Version Selection Menu ' --no-items --keep-window --no-shadow --ok-label "Select" --menu "Use arrow keys to navigate" $fullpageheight $fullpagewidth 10 "${appverlist[@]}" 2>&1> /dev/tty)
            exitstatus=$?
            if [ $exitstatus -ne 0 ]
            then
                mainmenu
                return 0
            fi
            fetchapk
        fi
    else
        variant=nonroot
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
    if ls ./"$appname"* > /dev/null 2>&1
    then
        if ping -c 1 google.com > /dev/null 2>&1
        then
            readarray -t appverlist < <(python3 ./python-utils/version-list.py "$appname")
            appver=$("${header[@]}" --title "Version Selection Menu" --no-items --keep-window --no-shadow --ok-label "Select" --menu "Choose App Version for $appname" $fullpageheight $fullpagewidth 10 "${appverlist[@]}" 2>&1> /dev/tty)
            exitstatus=$?
            if [ $exitstatus -ne 0 ]
            then
                mainmenu
            fi
        else
            appver=$(basename "$appname"-* .apk | cut -d '-' -f 2)
            return 0
        fi
    else
        internet
        readarray -t appverlist < <(python3 ./python-utils/version-list.py "$appname")
        appver=$("${header[@]}" --title ' Version Selection Menu ' --no-items --keep-window --no-shadow --ok-label "Select" --menu "Use arrow keys to navigate" $fullpageheight $fullpagewidth 10 "${appverlist[@]}" 2>&1> /dev/tty)
        exitstatus=$?
        if [ $exitstatus -ne 0 ]
        then
            mainmenu
        fi
    fi

}

fetchapk()
{
    if ls ./"$appname"* > /dev/null 2>&1
    then
        if ping -c 1 google.com > /dev/null 2>&1
        then
            clear
            intro
            echo "Please wait while the link is being fetched..."
            applink=$(python3 ./python-utils/fetch-link.py "$appname" "$appver" "$arch")
            tput rc; tput ed
            app_dl
        else
            if ! "${header[@]}" --title ' APK file found ' --no-items --defaultno --keep-window --no-shadow --yesno "$appname apk file with version $appver already exists. It may be partially downloaded which can result in build error.\n\n\nDo you want to continue with this apk file?" $fullpageheight $fullpagewidth
            then
                internet
            else
                appver=$(basename "$appname"-* .apk | cut -d '-' -f 2)
                return 0
            fi
        fi

    else
        internet
        clear
        intro
        echo "Please wait while the link is being fetched..."
        applink=$(python3 ./python-utils/fetch-link.py "$appname" "$appver" "$arch")
        tput rc; tput ed
        app_dl
    fi
}

patchapp()
{
    echo "Patching $appname..."
    patchinclusion
    java -jar ./revanced-cli*.jar -b ./revanced-patches*.jar -m ./revanced-integrations*.apk -c -a ./"$appname"-"$appver".apk $includepatches --keystore ./revanced.keystore -o ./"$appname"Revanced-"$appver".apk --custom-aapt2-binary ./aapt2_"$arch" --options options.toml --experimental --exclusive &&
    sleep 3
}

checkmicrogpatch()
{
    if [ "$pkgname" = "com.google.android.youtube" ] && [ "$variant" = "root" ]
    then
        microgstatus=$(jq -r 'map(select(.patchname == "microg-support"))[].status' patches.json)
        if [ "$microgstatus" = "on" ]
        then
            if "${header[@]}" --title ' MicroG warning ' --no-items --defaultno --keep-window --no-shadow --yes-label "Continue" --no-label "Exclude" --yesno "You have a rooted device and you have included a microg-support patch. This may result in YouTube app crash.\n\n\nDo you want to exclude it or continue?" $fullpageheight $fullpagewidth
            then
                return 0
            else
                tmp=$(mktemp)
                jq -r 'map(select(.patchname == "microg-support").status = "off")' patches.json > "$tmp" && mv "$tmp" ./patches.json
                return 0
            fi
        fi
    elif [ "$pkgname" = "com.google.android.apps.youtube.music" ] && [ "$variant" = "root" ]
    then
        microgstatus=$(jq -r 'map(select(.patchname == "music-microg-support"))[].status' patches.json)
        if [ "$microgstatus" = "on" ]
        then
            if "${header[@]}" --title ' MicroG warning ' --no-items --defaultno --keep-window --no-shadow --yes-label "Continue" --no-label "Exclude" --yesno "You have a rooted device and you have included a music-microg-support patch. This may result in YT Music app crash.\n\n\nDo you want to exclude it or continue?" $fullpageheight $fullpagewidth
            then
                return 0
            else
                tmp=$(mktemp)
                jq -r 'map(select(.patchname == "music-microg-support").status = "off")' patches.json > "$tmp" && mv "$tmp" ./patches.json
                return 0
            fi
        fi
    fi
}

#Build apps
buildapp()
{
    selectapp
    checkresource
    if ! ls ./patches* > /dev/null 2>&1
    then
        internet
        python3 ./python-utils/fetch-patches.py
    fi
    if [ "$pkgname" = "com.google.android.youtube" ] || [ "$pkgname" = "com.google.android.apps.youtube.music" ]
    then
        sucheck
        if [ "$variant" = "root" ]
        then
            rootver=$(su -c dumpsys package $pkgname | grep versionName | cut -d= -f 2)
            appver=${rootver:=$appver}
            checkmicrogpatch
        elif [ "$variant" = "nonroot" ]
        then
            versionselector
        fi
        checkpatched
        fetchapk
        patchapp
        if [ "$variant" = "root" ]
        then
            mountapk
        elif [ "$variant" = "nonroot" ]
        then
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
    if ! ls ./sources* > /dev/null 2>&1
    then
        echo '[{"patches" : {"repo" : "revanced", "branch" : "main"}}, {"cli" : {"repo" : "revanced", "branch" : "main"}}, {"integrations" : {"repo" : "revanced", "branch" : "main"}}]' | jq '.' > sources.json
    fi
    patchesrepo=$(jq -r '.[0].patches.repo' sources.json)
    if [ "$patchesrepo" = "revanced" ]
    then
        menuoptions=(1 "Patch App" 2 "Select Patches" 3 "Change Source" 4 "Update Resources" 5 "Edit Patch Options")
    elif [ "$patchesrepo" = "inotia00" ]
    then
        menuoptions=(1 "Patch App" 2 "Select Patches" 3 "Change Source" 4 "Update Resources")
    fi
    mainmenu=$("${header[@]}" --title ' Select App ' --keep-window --no-shadow --ok-label "Select" --cancel-label "Exit" --menu "Use arrow keys to navigate" $fullpageheight $fullpagewidth 10 "${menuoptions[@]}" 2>&1> /dev/tty)
    exitstatus=$?
    if [ $exitstatus -eq 0 ]
    then
        if [ "$mainmenu" -eq "1" ]
        then
            buildapp
        elif [ "$mainmenu" -eq "2" ]
        then
            selectapp
            selectpatches
        elif [ "$mainmenu" -eq "3" ]
        then
            changesource
        elif [ "$mainmenu" -eq "4" ]
        then
            fetchresources
        elif [ "$mainmenu" -eq 5 ]
        then
            patchoptions
        fi
    elif [ $exitstatus -ne 0 ]
    then
        terminatescript
    fi
}


mainmenu