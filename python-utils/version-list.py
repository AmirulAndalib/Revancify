from bs4 import BeautifulSoup
import re
import sys
import json
from requests import get, Session

versionlist=[]

def fetchurl(url):
    return BeautifulSoup(Session().get(url, headers={'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; Win64; x64)'}).content, 'html.parser')


if sys.argv[1] == "YouTube":
    with open("remotepatches.json", "r") as remotepatches:
        remotejson = json.load(remotepatches)
    for json in remotejson:
        if json['name'] == 'general-ads':
            supportedvers = (((json['compatiblePackages'])[0])['versions'])
    for a in fetchurl("https://www.apkmirror.com/uploads/?appcategory=youtube").find_all(text = re.compile(".*variants")):
        appver = ((a.parent).parent).parent.find(["a"], class_="fontBlack").string
        if appver.replace("YouTube ", "") in supportedvers:
            print(appver.replace("YouTube ", "") + " [Supported]")
        else:
            print(appver.replace("YouTube ", "").replace(" beta", " [Beta]"))
elif sys.argv[1] == "YTMusic":
    with open("remotepatches.json", "r") as remotepatches:
        remotejson = json.load(remotepatches)
    for json in remotejson:
        if json['name'] == 'compact-header':
            supportedvers = (((json['compatiblePackages'])[0])['versions'])
    for a in fetchurl("https://www.apkmirror.com/uploads/?appcategory=youtube-music").find_all(text = re.compile(".*variants")):
        appver = ((a.parent).parent).parent.find(["a"], class_="fontBlack").string
        if appver.replace("YouTube Music ", "") in supportedvers:
            print(appver.replace("YouTube Music ", "") + " [Supported]")
        else:
            print(appver.replace("YouTube Music ", ""))
elif sys.argv[1] == "Twitter":
    for a in fetchurl("https://www.apkmirror.com/uploads/?appcategory=twitter").find_all(text = re.compile(".*variants")):
        appver = ((a.parent).parent).parent.find(["a"], class_="fontBlack").string
        print(appver.replace("Twitter ", ""))
elif sys.argv[1] == "Reddit":
    for a in fetchurl("https://www.apkmirror.com/uploads/?appcategory=reddit").find_all(text = re.compile(".*variants")):
        appver = ((a.parent).parent).parent.find(["a"], class_="fontBlack").string
        print(appver.replace("Reddit ", ""))
elif sys.argv[1] == "TikTok":
    for a in fetchurl("https://www.apkmirror.com/uploads/?appcategory=tik-tok").find_all(text = re.compile(".*variants")):
        appver = ((a.parent).parent).parent.find(["a"], class_="fontBlack")
        print(appver.string.replace("TikTok ", ""))