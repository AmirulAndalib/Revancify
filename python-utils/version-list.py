import requests
from fetcher import fetch
from bs4 import BeautifulSoup
import re
import sys
import json

versionlist=[]

def bsurl(url):
    return fetch(url).bsurl()



if sys.argv[1] == "YouTube":
    with open("remotepatches.json", "r") as remotepatches:
        remotejson = json.load(remotepatches)
    for json in remotejson:
        if json['name'] == 'general-ads':
            for appver in (((json['compatiblePackages'])[0])['versions'])[-1:-11:-1]:
                print(appver)
elif sys.argv[1] == "YTMusic":
    with open("remotepatches.json", "r") as remotepatches:
        remotejson = json.load(remotepatches)
    for json in remotejson:
        if json['name'] == 'compact-header':
            for appver in (((json['compatiblePackages'])[0])['versions'])[-1:-11:-1]:
                print(appver)
elif sys.argv[1] == "Twitter":
    for a in bsurl("https://www.apkmirror.com/uploads/?devcategory=twitter-inc").find_all(text = re.compile(".*variants")):
        appver = ((a.parent).parent).parent.find(["a"], class_="fontBlack").string
        print(appver.replace("Twitter ", ""))
elif sys.argv[1] == "Reddit":
    for a in bsurl("https://www.apkmirror.com/uploads/?devcategory=redditinc").find_all(text = re.compile(".*variants")):
        appver = ((a.parent).parent).parent.find(["a"], class_="fontBlack").string
        print(appver.replace("Reddit ", ""))
elif sys.argv[1] == "TikTok":
    for a in bsurl("https://www.apkmirror.com/uploads/?appcategory=tik-tok").find_all(text = re.compile(".*variants")):
        appver = ((a.parent).parent).parent.find(["a"], class_="fontBlack")
        print(appver.string.replace("TikTok ", ""))