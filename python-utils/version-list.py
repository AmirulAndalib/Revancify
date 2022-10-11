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
    for a in bsurl("https://www.apkmirror.com/uploads/?appcategory=youtube").find_all(text = re.compile(".*variants")):
        appver = ((a.parent).parent).parent.find(["a"], class_="fontBlack").string
        print(appver.replace("YouTube ", "").replace(" beta", ""))
elif sys.argv[1] == "YTMusic":
    for a in bsurl("https://www.apkmirror.com/uploads/?appcategory=youtube-music").find_all(text = re.compile(".*variants")):
        appver = ((a.parent).parent).parent.find(["a"], class_="fontBlack").string
        print(appver.replace("YouTube Music ", ""))
elif sys.argv[1] == "Twitter":
    for a in bsurl("https://www.apkmirror.com/uploads/?appcategory=twitter").find_all(text = re.compile(".*variants")):
        appver = ((a.parent).parent).parent.find(["a"], class_="fontBlack").string
        print(appver.replace("Twitter ", ""))
elif sys.argv[1] == "Reddit":
    for a in bsurl("https://www.apkmirror.com/uploads/?appcategory=reddit").find_all(text = re.compile(".*variants")):
        appver = ((a.parent).parent).parent.find(["a"], class_="fontBlack").string
        print(appver.replace("Reddit ", ""))
elif sys.argv[1] == "TikTok":
    for a in bsurl("https://www.apkmirror.com/uploads/?appcategory=tik-tok").find_all(text = re.compile(".*variants")):
        appver = ((a.parent).parent).parent.find(["a"], class_="fontBlack")
        print(appver.string.replace("TikTok ", ""))