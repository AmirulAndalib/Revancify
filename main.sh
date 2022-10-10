#!/data/data/com.termux/files/usr/bin/bash

terminatescript(){
    clear && echo "Script terminated" ; rm -rf ./*cache; tput cnorm ; cd ~ ; exit
}
trap terminatescript SIGINT

# For update change this sentence here ...

setup()
{
    if ! ls ./sources* > /dev/null 2>&1 || [ $(jq '.[0] | has("sourceMaintainer")' sources.json) = false ] > /dev/null 2>&1
    then
        echo '[{"sourceMaintainer" : "revanced", "sourceStatus" : "on", "availableApps": ["YouTube", "YTMusic", "Twitter", "Reddit", "TikTok"], "optionsCompatible" : true},{"sourceMaintainer" : "inotia00", "sourceStatus" : "off", "availableApps": ["YouTube", "YTMusic"], "optionsCompatible" : false}]' | jq '.' > sources.json
    elif [ $(jq '.[0] | has("jsonBranch")' sources.json) = true ]
    then
        tmp=$(mktemp)
        jq 'map(del(.jsonBranch))' sources.json > "$tmp" && mv "$tmp" sources.json
    fi
    tmp=$(mktemp)
    jq 'map(del(.jsonBranch))' sources.json > "$tmp" && mv "$tmp" sources.json
    source=$(jq -r 'map(select(.sourceStatus == "on"))[].sourceMaintainer' sources.json)
    availableapps=($(jq -r 'map(select(.sourceStatus == "on"))[].availableApps[]' sources.json))
    optionscompatible=$(jq -r 'map(select(.sourceStatus == "on"))[].optionsCompatible' sources.json)
    if ! ls ./patches* > /dev/null 2>&1
    then
        internet
        python3 ./python-utils/fetch-patches.py
    fi
}

internet()
{
    if ping -c 1 google.com > /dev/null 2>&1
    then
        return 0
    else
        "${header[@]}" --msgbox "Oops! No Internet Connection available.\n\nConnect to Internet and try again later" 10 35
        mainmenu
    fi
}

intro()
{
    clear
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
fullpagewidth=$(tput cols)
fullpageheight=$(($(tput lines) - 5 ))
header=(dialog --begin 0 $leavecols --keep-window --no-lines --no-shadow --infobox "█▀█ █▀▀ █░█ ▄▀█ █▄░█ █▀▀ █ █▀▀ █▄█\n█▀▄ ██▄ ▀▄▀ █▀█ █░▀█ █▄▄ █ █▀░ ░█░" 4 38 --and-widget)

resourcemenu()
{
    internet

    mapfile -t revanced_latest < <(python3 ./python-utils/revanced-latest.py)
    
    patches_latest="${revanced_latest[0]}"

    cli_latest="${revanced_latest[1]}"

    integrations_latest="${revanced_latest[2]}"

    ls ./revanced-patches* > /dev/null 2>&1 && patches_available=$(basename revanced-patches* .jar | cut -d '-' -f 3) || patches_available="Not found"
    ls ./revanced-cli* > /dev/null 2>&1 && cli_available=$(basename revanced-cli* .jar | cut -d '-' -f 3) || cli_available="Not found"
    ls ./revanced-integrations* > /dev/null 2>&1 && integrations_available=$(basename revanced-integrations* .apk | cut -d '-' -f 3) || integrations_available="Not found"
    if "${header[@]}" --begin 5 0 --title ' Resources List ' --no-items --defaultno --yes-label "Fetch" --no-label "Cancel" --keep-window --no-shadow --yesno "Resource      Latest   Downloaded\n\nPatches       v$patches_latest  $patches_available\nCLI           v$cli_latest  $cli_available\nIntegrations  v$integrations_latest  $integrations_available\n\nDo you want to fetch latest resources?" $fullpageheight $fullpagewidth
    then
        [ "v$patches_latest" != "$patches_available" ] && rm revanced-patches* > /dev/null 2>&1
        [ "v$cli_latest" != "$cli_available" ] && rm revanced-cli* > /dev/null 2>&1
        [ "v$integrations_latest" != "$integrations_available" ] && rm revanced-integrations* > /dev/null 2>&1
        getresources
        mainmenu
        return 0
    else
        mainmenu
        return 0
    fi
}

getresources() 
{
    clear
    intro
    echo "Fetching resources..."
    echo ""
    wget -q -c https://github.com/"$source"/revanced-patches/releases/download/v"$patches_latest"/revanced-patches-"$patches_latest".jar -O revanced-patches-v"$patches_latest".jar --show-progress --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
    echo ""
    wget -q -c https://github.com/"$source"/revanced-patches/releases/download/v"$patches_latest"/patches.json -O remotepatches.json --show-progress --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
    echo ""
    wget -q -c https://github.com/"$source"/revanced-cli/releases/download/v"$cli_latest"/revanced-cli-"$cli_latest"-all.jar -O revanced-cli-v"$cli_latest".jar --show-progress --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
    echo ""
    wget -q -c https://github.com/"$source"/revanced-integrations/releases/download/v"$integrations_latest"/app-release-unsigned.apk -O revanced-integrations-v"$integrations_latest".apk --show-progress --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
    python3 ./python-utils/fetch-patches.py
    echo ""
}


changesource()
{
    internet
    source=$(jq -r 'map(select(.sourceStatus == "on"))[].sourceMaintainer' sources.json)
    allsources=($(jq -r '.[] | "\(.sourceMaintainer) \(.sourceStatus)"' sources.json))
    selectedsource=$("${header[@]}" --begin 5 0 --title ' Source Selection Menu ' --keep-window --no-items --no-shadow --no-cancel --ok-label "Done" --radiolist "Use arrow keys to navigate; Press Spacebar to select option" $fullpageheight $fullpagewidth 10 "${allsources[@]}" 2>&1> /dev/tty)
    tmp=$(mktemp)
    jq -r 'map(select(.).sourceStatus = "off")' sources.json | jq -r --arg selectedsource "$selectedsource" 'map(select(.sourceMaintainer == $selectedsource).sourceStatus = "on")' > "$tmp" && mv "$tmp" sources.json
    if [ "$source" != "$selectedsource" ]
    then
        source=$(jq -r 'map(select(.sourceStatus == "on"))[].sourceMaintainer' sources.json)
        availableapps=($(jq -r 'map(select(.sourceStatus == "on"))[].availableApps[]' sources.json))
        rm revanced-* > /dev/null 2>&1
        rm remotepatches.json > /dev/null 2>&1
        mapfile -t revanced_latest < <(python3 ./python-utils/revanced-latest.py)
        patches_latest="${revanced_latest[0]}" && cli_latest="${revanced_latest[1]}" && integrations_latest="${revanced_latest[2]}"
        getresources
    fi
    mainmenu
}

selectapp()
{
    appname=$("${header[@]}" --begin 5 0 --title ' App Selection Menu ' --no-items --keep-window --no-shadow --ok-label "Select" --menu "Use arrow keys to navigate" $fullpageheight $fullpagewidth 10 "${availableapps[@]}" 2>&1> /dev/tty)
    exitstatus=$?
    if [ $exitstatus -eq 0 ]
    then
        if [ "$appname" = "YouTube" ]
        then
            pkgname=com.google.android.youtube
        elif [ "$appname" = "YTMusic" ]
        then
            pkgname=com.google.android.apps.youtube.music
        elif [ "$appname" = "Twitter" ]
        then
            pkgname=com.twitter.android
        elif [ "$appname" = "Reddit" ]
        then
            pkgname=com.reddit.frontpage
        elif [ "$appname" = "TikTok" ]
        then
            pkgname=com.ss.android.ugc.trill
        fi
    elif [ $exitstatus -ne 0 ]
    then
        mainmenu
    fi
}

selectpatches()
{
    if ! ls ./revanced-patches* > /dev/null 2>&1
    then
        "${header[@]}" --msgbox "No Patches found !!\nPlease update resources to edit patches" 10 35
        resourcemenu
        return 0
    fi
    patchselectionheight=$(($(tput lines) - 6))
    declare -a patchesinfo
    readarray -t patchesinfo < <(jq -r --arg pkgname "$pkgname" 'map(select(.appname == $pkgname))[] | "\(.patchname)\n\(.status)\n\(.description)"' patches.json)
    choices=($("${header[@]}" --begin 5 0 --title ' Patch Selection Menu ' --item-help --no-items --keep-window --no-shadow --help-button --help-label "Exclude all" --extra-button --extra-label "Include all" --ok-label "Save" --no-cancel --checklist "Use arrow keys to navigate; Press Spacebar to toogle patch" $patchselectionheight $fullpagewidth 10 "${patchesinfo[@]}" 2>&1 >/dev/tty))
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
    checkresources
    java -jar ./revanced-cli*.jar -b ./revanced-patches*.jar -m ./revanced-integrations*.apk -c -a ./noinput.apk -o nooutput.apk > /dev/null 2>&1
    tput cnorm
    tmp=$(mktemp)
    "${header[@]}" --begin 5 0 --keep-window --no-shadow --title ' Options File Editor ' --editbox options.toml $fullpageheight $fullpagewidth 2> "$tmp" && mv "$tmp" ./options.toml
    tput civis
    mainmenu
}

mountapk()
{   
    "${header[@]}" --no-shadow --infobox "Unmounting and Mouting $appname...\nThis may take a while..." 10 35
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
    am force-stop $PKGNAME' > /dev/null 2>&1
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
    if "${header[@]}" --begin 5 0 --title ' MicroG Prompt ' --no-items --defaultno --keep-window --no-shadow --yesno "Vanced MicroG is used to run MicroG services without root.\nYouTube and YTMusic won't work without it.\nIf you already have MicroG, You don't need to download it.\n\n\n\n\n\nDo you want to download Vanced MicroG app?" $fullpageheight $fullpagewidth
        then
            intro
            wget -q -c "https://github.com/TeamVanced/VancedMicroG/releases/download/v0.2.24.220220-220220001/microg.apk" -O "Vanced_MicroG.apk" --show-progress --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
            echo ""
            mkdir -p /storage/emulated/0/Revancify
            mv "Vanced_MicroG.apk" /storage/emulated/0/Revancify/
            echo MicroG App saved to Revancify folder.
            sleep 1s
    fi
}

checkresources()
{
    if ls ./revanced-patches* > /dev/null 2>&1 && ls ./revanced-cli* > /dev/null 2>&1 && ls ./revanced-integrations* > /dev/null 2>&1
    then
        return 0
    else
        resourcemenu
    fi
}


checkpatched()
{
    if [ "$variant" = "root" ]
    then
        if ls ./"$appname"Revanced-"$appver"* > /dev/null 2>&1
        then
            if "${header[@]}" --begin 5 0 --title ' Patched APK found ' --no-items --defaultno --keep-window --no-shadow --yesno "Current directory already contains $appname Revanced version $appver. \n\n\nDo you want to patch $appname again?" $fullpageheight $fullpagewidth
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
            if ! "${header[@]}" --begin 5 0 --title ' Patched APK found ' --no-items --defaultno --keep-window --no-shadow --yesno "Patched $appname with version $appver already exists. \n\n\nDo you want to patch $appname again?" $fullpageheight $fullpagewidth
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
        echo -e "#!/system/bin/sh\nMAGISKTMP=\"\$(magisk --path)\" || MAGISKTMP=/sbin\nMIRROR=\"\$MAGISKTMP/.magisk/mirror\"\nwhile [ \"\$(getprop sys.boot_completed | tr -d '\\\r')\" != \"1\" ]; do sleep 1; done\n\nbase_path=\"/data/adb/revanced/"$pkgname".apk\"\nstock_path=\$( pm path $pkgname | grep base | sed 's/package://g' )\n\nchcon u:object_r:apk_data_file:s0 \$base_path\nmount -o bind \$MIRROR\$base_path \$stock_path" > ./mount_revanced_$pkgname.sh
        su -c 'mv mount_revanced* /data/adb/service.d/ && chmod +x /data/adb/service.d/mount*'
        if ! su -c "dumpsys package $pkgname" | grep -q path
        then
            internet
            readarray -t appverlist < <(python3 ./python-utils/version-list.py "$appname")
            appver=$("${header[@]}" --begin 5 0 --title ' Version Selection Menu ' --no-items --keep-window --no-shadow --ok-label "Select" --menu "Use arrow keys to navigate" $fullpageheight $fullpagewidth 10 "${appverlist[@]}" 2>&1> /dev/tty)
            exitstatus=$?
            if [ $exitstatus -ne 0 ]
            then
                mainmenu
                return 0
            fi
            fetchapk
            checkpatched
            patchapp
            moveapk
        fi
    else
        variant=nonroot
        dlmicrog
    fi
}

# App Downloader
app_dl()
{
    intro
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

setargs()
{
    includepatches=$(while read -r line; do printf %s"$line" " "; done < <(jq -r --arg pkgname "$pkgname" 'map(select(.appname == $pkgname and .status == "on"))[].patchname' patches.json | sed "s/^/-i /g"))
    if [ "$source" = "inotia00" ] && [ "$appname" = "YouTube" ]
    then
        if [ "$arch" = "arm64" ]
        then
            riplibs="--rip-lib armeabi-v7a --rip-lib x86_64 --rip-lib x86"
        elif [ "$arch" = "armeabi" ]
        then
            riplibs="--rip-lib arm64-v8a --rip-lib x86_64 --rip-lib x86"
        fi
    fi
    if [ "$optionscompatible" = true ]
    then
        optionsarg="--options options.toml"
    else
        unset optionsarg
    fi
}

versionselector()
{
    if ls ./"$appname"* > /dev/null 2>&1
    then
        if ping -c 1 google.com > /dev/null 2>&1
        then
            readarray -t appverlist < <(python3 ./python-utils/version-list.py "$appname")
            appver=$("${header[@]}" --begin 5 0 --title "Version Selection Menu" --no-items --keep-window --no-shadow --ok-label "Select" --menu "Choose App Version for $appname" $fullpageheight $fullpagewidth 10 "${appverlist[@]}" 2>&1> /dev/tty)
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
        appver=$("${header[@]}" --begin 5 0 --title ' Version Selection Menu ' --no-items --keep-window --no-shadow --ok-label "Select" --menu "Use arrow keys to navigate" $fullpageheight $fullpagewidth 10 "${appverlist[@]}" 2>&1> /dev/tty)
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
            python3 ./python-utils/fetch-link.py "$appname" "$appver" "$arch" | "${header[@]}" --gauge "Fetching $appname Download Link" 10 35 0
            applink=$(cat link.txt) && rm ./link.txt > /dev/null 2>&1
            app_dl
        else
            if ! "${header[@]}" --begin 5 0 --title ' APK file found ' --no-items --defaultno --keep-window --no-shadow --yesno "$appname apk file with version $appver already exists. It may be partially downloaded which can result in build error.\n\n\nDo you want to continue with this apk file?" $fullpageheight $fullpagewidth
            then
                internet
            else
                appver=$(basename "$appname"-* .apk | cut -d '-' -f 2)
                clear
                return 0
            fi
        fi
    else
        internet
        python3 ./python-utils/fetch-link.py "$appname" "$appver" "$arch" | "${header[@]}" --gauge "Fetching $appname Download Link" 10 35 0
        applink=$(cat link.txt) && rm link.txt
        app_dl
    fi
}

patchapp()
{
    setargs
    java -jar ./revanced-cli*.jar -b ./revanced-patches*.jar -m ./revanced-integrations*.apk -c -a ./"$appname"-"$appver".apk $includepatches --keystore ./revanced.keystore -o ./"$appname"Revanced-"$appver".apk $riplibs --custom-aapt2-binary ./binaries/aapt2_"$arch" $optionsarg --experimental --exclusive | "${header[@]}" --begin 5 0 --title " Patching $appname " --progressbox $fullpageheight $fullpagewidth &&
    sleep 3
}

checkmicrogpatch()
{
    if [ "$pkgname" = "com.google.android.youtube" ] && [ "$variant" = "root" ]
    then
        microgstatus=$(jq -r 'map(select(.patchname == "microg-support"))[].status' patches.json)
        if [ "$microgstatus" = "on" ]
        then
            if "${header[@]}" --begin 5 0 --title ' MicroG warning ' --no-items --defaultno --keep-window --no-shadow --yes-label "Continue" --no-label "Exclude" --yesno "You have a rooted device and you have included a microg-support patch. This may result in YouTube app crash.\n\n\nDo you want to exclude it or continue?" $fullpageheight $fullpagewidth
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
            if "${header[@]}" --begin 5 0 --title ' MicroG warning ' --no-items --defaultno --keep-window --no-shadow --yes-label "Continue" --no-label "Exclude" --yesno "You have a rooted device and you have included a music-microg-support patch. This may result in YT Music app crash.\n\n\nDo you want to exclude it or continue?" $fullpageheight $fullpagewidth
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
    checkresources
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
    setup
    if [ "$optionscompatible" = true ]
    then
        optionseditor=(5 "Edit Patch Options")
    else
        unset optionseditor
    fi
    mainmenu=$("${header[@]}" --begin 5 0 --title ' Select App ' --keep-window --no-shadow --ok-label "Select" --cancel-label "Exit" --menu "Use arrow keys to navigate" $fullpageheight $fullpagewidth 10 1 "Patch App" 2 "Select Patches" 3 "Change Source" 4 "Check Resources" "${optionseditor[@]}" 2>&1> /dev/tty)
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
            resourcemenu
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