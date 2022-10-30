import re
import sys
from requests import get, Session
from bs4 import BeautifulSoup


def fetchurl(url):
    return BeautifulSoup(Session().get(url, headers={'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; Win64; x64)'}).content, 'html.parser')


try:

    if sys.argv[1] == "YouTube":

        appurl = "".join(["https://www.apkmirror.com/apk/google-inc/youtube/youtube-", sys.argv[2].replace(".","-"), "-release/"])

        apppage1= "".join(["https://apkmirror.com", fetchurl(appurl).find(["span"], text="APK").parent.find(["a"], class_="accent_color")['href']])



    elif sys.argv[1] == "YTMusic":

        appurl = "".join(["https://www.apkmirror.com/apk/google-inc/youtube-music/youtube-music-", sys.argv[2].replace(".","-"), "-release/"])

        if sys.argv[3] == "arm64":

            apppage1 = "".join(["https://www.apkmirror.com", fetchurl(appurl).find(["div"], text="arm64-v8a").parent.find(["a"], class_="accent_color")['href']])

        elif sys.argv[3] == "armeabi":

            apppage1 = "".join(["https://www.apkmirror.com", fetchurl(appurl).find(["div"], text="armeabi-v7a").parent.find(["a"], class_="accent_color")['href']])



    elif sys.argv[1] == "Twitter":

            appurl = "".join(["https://www.apkmirror.com/apk/twitter-inc/twitter/twitter-", sys.argv[2].replace(".","-"), "-release/"])

            apppage1= "".join(["https://apkmirror.com", fetchurl(appurl).find(["span"], text="APK").parent.find(["a"], class_="accent_color")['href']])


    elif sys.argv[1] == "Reddit":

        appurl = "".join(["https://www.apkmirror.com/apk/reddditinc/reddit/reddit-", sys.argv[2].replace(".","-"), "-release/"])

        apppage1= "".join(["https://apkmirror.com", fetchurl(appurl).find(["span"], text="APK").parent.find(["a"], class_="accent_color")['href']])

    elif sys.argv[1] == "TikTok":

        appurl = "".join(["https://www.apkmirror.com/apk/tiktok-pte-ltd/tik-tok/tik-tok-", sys.argv[2].replace(".","-"), "-release/"])

        apppage1= "".join(["https://apkmirror.com", fetchurl(appurl).find(["span"], text="APK").parent.find(["a"], class_="accent_color")['href']])


    print(33, flush=True)
    apppage2= "".join(["https://apkmirror.com", fetchurl(apppage1).find(["a"], { 'class' : re.compile("accent_bg btn btn-flat downloadButton")})['href']])
    print(66, flush=True)
    appdllink = "".join(["https://apkmirror.com", fetchurl(apppage2).find(rel="nofollow")['href']])
    print(100, flush=True)

    with open("link.txt", 'w') as link:
        link.write(appdllink)

except Exception as e:
    with open("link.txt", 'w') as link:
        link.write("error")