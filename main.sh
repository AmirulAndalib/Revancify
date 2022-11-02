#!/data/data/com.termux/files/usr/bin/bash

terminatescript(){
    clear && echo "Script terminated" ; rm -rf ./*cache; tput cnorm ; cd ~ ; exit
}
trap terminatescript SIGINT

# For update change this sentence here ...

sourcesetup()
{
    if ! ls ./sources* > /dev/null 2>&1 || [ $(jq '.[0] | has("sourceMaintainer")' sources.json) = false ] > /dev/null 2>&1
    then
        echo '[{"sourceMaintainer" : "revanced", "sourceStatus" : "on", "availableApps": ["YouTube", "YTMusic", "Twitter", "Reddit", "TikTok"], "optionsCompatible" : true},{"sourceMaintainer" : "inotia00", "sourceStatus" : "off", "availableApps": ["YouTube", "YTMusic"], "optionsCompatible" : true}]' | jq '.' > sources.json
    else
        tmp=$(mktemp)
        jq '.[1].optionsCompatible = true' sources.json > "$tmp" && mv "$tmp" sources.json
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
fullpageheight=$(($(tput lines) - 4 ))
header=(dialog --begin 0 $leavecols --keep-window --no-lines --no-shadow --infobox "█▀█ █▀▀ █░█ ▄▀█ █▄░█ █▀▀ █ █▀▀ █▄█\n█▀▄ ██▄ ▀▄▀ █▀█ █░▀█ █▄▄ █ █▀░ ░█░" 4 38 --and-widget)

resourcemenu()
{
    internet

    mapfile -t revanced_latest < <(python3 ./python-utils/revanced-latest.py)
    
    patches_latest="${revanced_latest[0]}"

    cli_latest="${revanced_latest[1]}"

    integrations_latest="${revanced_latest[2]}"

    ls ./revanced-patches* > /dev/null 2>&1 && patches_available=$(basename revanced-patches* .jar | cut -d '-' -f 3) || patches_available="Not-found"
    ls ./revanced-cli* > /dev/null 2>&1 && cli_available=$(basename revanced-cli* .jar | cut -d '-' -f 3) || cli_available="Not-found"
    ls ./revanced-integrations* > /dev/null 2>&1 && integrations_available=$(basename revanced-integrations* .apk | cut -d '-' -f 3) || integrations_available="Not-found"
    readarray -t resourcefilelines < <(echo -e "Resource Latest Downloaded\nPatches v$patches_latest $patches_available\nCLI v$cli_latest $cli_available\nIntegrations v$integrations_latest $integrations_available" | column -t -s ' ')
    if "${header[@]}" --begin 4 0 --title ' Resources List ' --no-items --defaultno --yes-label "Fetch" --no-label "Cancel" --keep-window --no-shadow --yesno "Current Source: $source\n\n${resourcefilelines[0]}\n${resourcefilelines[1]}\n${resourcefilelines[2]}\n${resourcefilelines[3]}\n\nDo you want to fetch latest resources?" $fullpageheight $fullpagewidth
    then
        [ "v$patches_latest" != "$patches_available" ] && rm revanced-patches* > /dev/null 2>&1
        [ "v$cli_latest" != "$cli_available" ] && rm revanced-cli* > /dev/null 2>&1
        [ "v$integrations_latest" != "$integrations_available" ] && rm revanced-integrations* > /dev/null 2>&1
        rm patches.json > /dev/null 2>&1
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
    intro
    echo "Fetching resources..."
    echo ""
    wget -q -c https://github.com/"$source"/revanced-patches/releases/download/v"$patches_latest"/revanced-patches-"$patches_latest".jar -O revanced-patches-v"$patches_latest".jar --show-progress --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
    rm patches.json > /dev/null 2>&1
    wget -q -c https://github.com/"$source"/revanced-patches/releases/download/v"$patches_latest"/patches.json -O patches.json --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
    echo ""
    wget -q -c https://github.com/"$source"/revanced-cli/releases/download/v"$cli_latest"/revanced-cli-"$cli_latest"-all.jar -O revanced-cli-v"$cli_latest".jar --show-progress --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
    echo ""
    wget -q -c https://github.com/"$source"/revanced-integrations/releases/download/v"$integrations_latest"/app-release-unsigned.apk -O revanced-integrations-v"$integrations_latest".apk --show-progress --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
    python3 ./python-utils/sync-patches.py
    echo ""
}


changesource()
{
    internet
    source=$(jq -r 'map(select(.sourceStatus == "on"))[].sourceMaintainer' sources.json)
    allsources=($(jq -r '.[] | "\(.sourceMaintainer) \(.sourceStatus)"' sources.json))
    selectedsource=$("${header[@]}" --begin 4 0 --title ' Source Selection Menu ' --keep-window --no-items --no-shadow --no-cancel --ok-label "Done" --radiolist "Use arrow keys to navigate; Press Spacebar to select option" "$fullpageheight" "$fullpagewidth" 10 "${allsources[@]}" 2>&1> /dev/tty)
    tmp=$(mktemp)
    jq -r 'map(select(.).sourceStatus = "off")' sources.json | jq -r --arg selectedsource "$selectedsource" 'map(select(.sourceMaintainer == $selectedsource).sourceStatus = "on")' > "$tmp" && mv "$tmp" sources.json
    if [ "$source" != "$selectedsource" ]
    then
        source=$(jq -r 'map(select(.sourceStatus == "on"))[].sourceMaintainer' sources.json)
        availableapps=($(jq -r 'map(select(.sourceStatus == "on"))[].availableApps[]' sources.json))
        rm revanced-* > /dev/null 2>&1
        rm patches.json > /dev/null 2>&1
        mapfile -t revanced_latest < <(python3 ./python-utils/revanced-latest.py)
        patches_latest="${revanced_latest[0]}" && cli_latest="${revanced_latest[1]}" && integrations_latest="${revanced_latest[2]}"
        getresources
    fi
    mainmenu
}

selectapp()
{
    readarray -t availableapps < <(jq -r 'map(select(.sourceStatus == "on"))[].availableApps[]' sources.json)
    appname=$("${header[@]}" --begin 4 0 --title ' App Selection Menu ' --no-items --keep-window --no-shadow --ok-label "Select" --menu "Use arrow keys to navigate" "$fullpageheight" "$fullpagewidth" 10 "${availableapps[@]}" 2>&1> /dev/tty)
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
    if ! ls ./patches* > /dev/null 2>&1
    then
        "${header[@]}" --msgbox "No Json file found !!\nPlease update resources to edit patches." 10 35
        resourcemenu
        return 0
    fi
    if ! ls ./saved-patches* > /dev/null 2>&1
    then
        internet
        python3 ./python-utils/sync-patches.py
    fi
    patchselectionheight=$(($(tput lines) - 5))
    declare -a patchesinfo
    readarray -t patchesinfo < <(jq -r --arg pkgname "$pkgname" 'map(select(.appname == $pkgname))[] | "\(.patchname)\n\(.status)\n\(.description)"' saved-patches.json)
    choices=("$("${header[@]}" --begin 4 0 --title ' Patch Selection Menu ' --item-help --no-items --keep-window --no-shadow --help-button --help-label "Exclude all" --extra-button --extra-label "Include all" --ok-label "Save" --no-cancel --checklist "Use arrow keys to navigate; Press Spacebar to toogle patch" $patchselectionheight "$fullpagewidth" 10 "${patchesinfo[@]}" 2>&1 >/dev/tty)")
    selectpatchstatus=$?
    patchsaver
}

patchsaver()
{
    if [ $selectpatchstatus -eq 0 ]
    then
        tmp=$(mktemp)
        jq --arg pkgname "$pkgname" 'map(select(.appname == $pkgname).status = "off")' saved-patches.json | jq 'map(select(IN(.patchname; $ARGS.positional[])).status = "on")' --args "${choices[@]}" > "$tmp" && mv "$tmp" ./saved-patches.json
        mainmenu
    elif [ $selectpatchstatus -eq 2 ]
    then
        tmp=$(mktemp)
        jq --arg pkgname "$pkgname" 'map(select(.appname == $pkgname).status = "off")' saved-patches.json > "$tmp" && mv "$tmp" ./saved-patches.json
        selectpatches
    elif [ $selectpatchstatus -eq 3 ]
    then
        tmp=$(mktemp)
        jq --arg pkgname "$pkgname" 'map(select(.appname == $pkgname).status = "on")' saved-patches.json > "$tmp" && mv "$tmp" ./saved-patches.json
        selectpatches
    fi
}


patchoptions()
{
    checkresources
    java -jar ./revanced-cli*.jar -b ./revanced-patches*.jar -m ./revanced-integrations*.apk -c -a ./noinput.apk -o nooutput.apk > /dev/null 2>&1
    tput cnorm
    tmp=$(mktemp)
    "${header[@]}" --begin 4 0 --ok-label "Save" --cancel-label "Exit" --keep-window --no-shadow --title ' Options File Editor ' --editbox options.toml "$fullpageheight" "$fullpagewidth" 2> "$tmp" && mv "$tmp" ./options.toml
    tput civis
    mainmenu
}

mountapk()
{   
    "${header[@]}" --no-shadow --infobox "Unmounting and Mouting $appname...\nThis may take a while..." 10 35
    PKGNAME=$pkgname APPNAME=$appname APPVER=$appver su -mm -c 'grep $PKGNAME /proc/mounts | while read -r line; do echo $line | cut -d " " -f 2 | sed "s/apk.*/apk/" | xargs -r umount -l > /dev/null 2>&1; done &&\
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
    su -c "pm resolve-activity --brief $pkgname | tail -n 1 | xargs am start -n"
    su -c 'pidof com.termux | xargs kill -9'
}

moveapk()
{
    mkdir -p /storage/emulated/0/Revancify/
    mv "$appname"Revanced* /storage/emulated/0/Revancify/ > /dev/null 2>&1
    [[ -f Vanced-MicroG.apk ]] && mv Vanced-MicroG.apk /storage/emulated/0/Revancify/ && termux-open /storage/emulated/0/Revancify/Vanced-MicroG.apk
    termux-open /storage/emulated/0/Revancify/"$appname"Revanced-"$appver".apk
    mainmenu
    return 0
}

promptmicrog()
{
    "${header[@]}" --begin 4 0 --title ' MicroG Prompt ' --no-items --defaultno --keep-window --no-shadow --yesno "Vanced MicroG is used to run MicroG services without root.\nYouTube and YTMusic won't work without it.\nIf you already have MicroG, You don't need to download it.\n\n\n\n\n\nDo you want to download Vanced MicroG app?" "$fullpageheight" "$fullpagewidth"
    dlexit=$?
}

checkresources()
{
    if ls ./revanced-patches* > /dev/null 2>&1 && ls ./revanced-cli* > /dev/null 2>&1 && ls ./revanced-integrations* > /dev/null 2>&1 && ls ./patches* > /dev/null 2>&1
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
            if "${header[@]}" --begin 4 0 --title ' Patched APK found ' --no-items --defaultno --keep-window --no-shadow --yesno "Current directory already contains $appname Revanced version $appver. \n\n\nDo you want to patch $appname again?" $fullpageheight $fullpagewidth
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
            if ! "${header[@]}" --begin 4 0 --title ' Patched APK found ' --no-items --defaultno --keep-window --no-shadow --yesno "Patched $appname with version $appver already exists. \n\n\nDo you want to patch $appname again?" $fullpageheight $fullpagewidth
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
        echo -e "#!/system/bin/sh\nwhile [ \"\$(getprop sys.boot_completed | tr -d '\\\r')\" != \"1\" ]; do sleep 1; done\n\nbase_path=\"/data/adb/revanced/"$pkgname".apk\"\nstock_path=\$( pm path $pkgname | grep base | sed 's/package://g' )\n\nchcon u:object_r:apk_data_file:s0 \$base_path\nmount -o bind \$base_path \$stock_path" > ./mount_revanced_$pkgname.sh
        su -c 'mv mount_revanced* /data/adb/service.d/ && chmod +x /data/adb/service.d/mount*'
        if ! PKGNAME=$pkgname su -c 'dumpsys package $PKGNAME | grep path' > /dev/null 2>&1
        then 
            termux-open "https://play.google.com/store/apps/details?id="$pkgname
            mainmenu
        fi
    else
        variant=nonroot
    fi
}

app_dl()
{
    intro
    internet
    if ls ./"$appname"-"$appver"* > /dev/null 2>&1
    then
        echo "$appname-$appver.apk already exists."
        echo ""
        sleep 0.5s
        wget -q -c "$applink" -O ./"$appname"-"$appver".apk --show-progress --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
        sleep 0.5s
    else
        rm -rf ./"$appname"* > /dev/null 2>&1
        echo " "
        echo "Downloading $appname-$appver.apk..."
        echo " "
        wget -q -c "$applink" -O ./"$appname"-"$appver".apk --show-progress --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
        sleep 0.5s
    fi
}

dlmicrog()
{
    if [ "$dlexit" -eq 0 ] > /dev/null 2>&1
    then
        internet
        echo "Downloading Vanced-MicroG.apk"
        wget -q -c "https://github.com/inotia00/VancedMicroG/releases/download/v0.2.25.224113-224113002/microg.apk" -O "Vanced-MicroG.apk" --show-progress --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
    fi
    tput rc; tput ed
}

setargs()
{
    includepatches=$(while read -r line; do printf %s"$line" " "; done < <(jq -r --arg pkgname "$pkgname" 'map(select(.appname == $pkgname and .status == "on"))[].patchname' saved-patches.json | sed "s/^/-i /g"))
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
    if [ "$optionscompatible" = true ] && ls ./options* > /dev/null 2>&1
    then
        optionsarg="--options options.toml"
    fi
}

versionselector()
{
    checkresources
    internet
    readarray -t appverlist < <(python3 ./python-utils/fetch-versions.py "$appname")
    if [ "${appverlist[0]}" = "error" ]
    then
        "${header[@]}" --msgbox "Unable to fetch link !!\nThere is some problem with your internet connection. Disable VPN or Change your network." 10 35
        mainmenu
    fi
    verchoosed=$("${header[@]}" --begin 4 0 --title "Version Selection Menu" --no-items --keep-window --no-shadow --ok-label "Select" --menu "Choose App Version for $appname" "$fullpageheight" "$fullpagewidth" 10 "${appverlist[@]}" 2>&1> /dev/tty)
    exitstatus=$?
    appver=$(echo "$verchoosed" | cut -d " " -f 1)
    if [ $exitstatus -ne 0 ]
    then
        mainmenu
        return 0
    fi
}

fetchlink()
{
    checkpatched
    internet
    applink=$( ( python3 ./python-utils/fetch-link.py "$appname" "$appver" "$arch" 2>&3 | "${header[@]}" --gauge "App    : $appname\nVersion: $appver\n\nScraping Download Link..." 10 35 0 >&2 ) 3>&1 )
    if [ "$applink" = "error" ]
    then
        "${header[@]}" --msgbox "Unable to fetch link !!\nThere is some problem with your internet connection. Disable VPN or Change your network." 10 35
        mainmenu
        return 0
    else
        app_dl
    fi
    dlmicrog
}


patchapp()
{
    if ls ./saved-patches* > /dev/null 2>&1 && ls ./"$appname"-"$appver"* > /dev/null 2>&1
    then
        intro
        setargs
        echo "Patching $appname..."
        java -jar ./revanced-cli*.jar -b ./revanced-patches*.jar -m ./revanced-integrations*.apk -c $includepatches --keystore ./revanced.keystore $riplibs --custom-aapt2-binary ./binaries/aapt2 $optionsarg --experimental --exclusive 2>&1 | tee ./patchlog.txt
        patchstatus="${PIPESTATUS[0]}"
        sleep 2
        if [ "$patchstatus" = 1 ]
        then
            mv ./patchlog.txt /storage/emulated/0/Revancify/crashlog.txt
            "${header[@]}" --msgbox "Oops, Patching failed !!\nPatchlog saved to Revancify folder.Share the Patchlog to developer." 10 35
            mainmenu
        fi
    else
        ls > /storage/emulated/0/Revancify/crashlog.txt
        "${header[@]}" --msgbox "Oops, Patching failed !!\nPatchlog saved to Revancify folder.Share the Patchlog to developer." 10 35
        mainmenu
    fi
}

checkmicrogpatch()
{
    if [ "$pkgname" = "com.google.android.youtube" ] && [ "$variant" = "root" ]
    then
        microgstatus=$(jq -r 'map(select(.patchname == "microg-support"))[].status' patches.json)
        if [ "$microgstatus" = "on" ]
        then
            if "${header[@]}" --begin 4 0 --title ' MicroG warning ' --no-items --defaultno --keep-window --no-shadow --yes-label "Continue" --no-label "Exclude" --yesno "You have a rooted device and you have included a microg-support patch. This may result in YouTube app crash.\n\n\nDo you want to exclude it or continue?" $fullpageheight $fullpagewidth
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
            if "${header[@]}" --begin 4 0 --title ' MicroG warning ' --no-items --defaultno --keep-window --no-shadow --yes-label "Continue" --no-label "Exclude" --yesno "You have a rooted device and you have included a music-microg-support patch. This may result in YT Music app crash.\n\n\nDo you want to exclude it or continue?" $fullpageheight $fullpagewidth
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
        python3 ./python-utils/sync-patches.py
    fi
    if [ "$pkgname" = "com.google.android.youtube" ] || [ "$pkgname" = "com.google.android.apps.youtube.music" ]
    then
        sucheck
        if [ "$variant" = "root" ]
        then
            appver=$(su -c dumpsys package $pkgname | grep versionName | cut -d= -f 2 | sed -n '1p')
            checkmicrogpatch
        elif [ "$variant" = "nonroot" ]
        then
            versionselector
            dlmicrog
        fi
        checkpatched
        fetchlink
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
        fetchlink
        patchapp
        moveapk
    fi
}

sourcesetup
mainmenu()
{
    source=$(jq -r 'map(select(.sourceStatus == "on"))[].sourceMaintainer' sources.json)
    optionscompatible=$(jq -r 'map(select(.sourceStatus == "on"))[].optionsCompatible' sources.json)
    if [ "$optionscompatible" = true ]
    then
        optionseditor=(5 "Edit Patch Options")
    else
        unset optionseditor
    fi
    mainmenu=$("${header[@]}" --begin 4 0 --title ' Select App ' --keep-window --no-shadow --ok-label "Select" --cancel-label "Exit" --menu "Use arrow keys to navigate" "$fullpageheight" "$fullpagewidth" 10 1 "Patch App" 2 "Select Patches" 3 "Change Source" 4 "Check Resources" "${optionseditor[@]}" 2>&1> /dev/tty)
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