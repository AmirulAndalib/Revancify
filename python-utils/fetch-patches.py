import requests
import json

localjson = None

with open('sources.json', 'r') as sourcesfile:
    sourcesjson = json.load(sourcesfile)

patchesrepo = sourcesjson[0]['patches']['repo']
patchesbranch = sourcesjson[0]['patches']['branch']

def openjson():
    global localjson
    try:
        with open("patches.json", "r") as patchesfile:
            localjson = json.load(patchesfile)
    except (json.decoder.JSONDecodeError, FileNotFoundError) as e:
        with open("patches.json", "w") as patchesfile:
            emptyjson = [{"patchname": None, "appname": None, "status": None}]
            json.dump(emptyjson, patchesfile, indent=4)
        openjson()

openjson()

patchesurl =  "".join(["https://raw.githubusercontent.com/", patchesrepo, "/revanced-patches/", patchesbranch,"/patches.json"])
remotejson = requests.get(patchesurl).json()

remotepatches = []
localpatches = []

for key in remotejson:
    remotepatches.append(key['name'])

for key in localjson:
    localpatches.append(key['patchname'])


for patchname in remotepatches:
    if patchname not in localpatches:
        newkey = {}
        patchindex = remotepatches.index(patchname)
        newkey['patchname'] = patchname
        newkey['appname'] = remotejson[patchindex]['compatiblePackages'][0]['name']
        newkey['status'] = "on"
        localjson.append(newkey)
    else:
        patchindex = remotepatches.index(patchname)
        localjson[localpatches.index(patchname)]['patchname'] = remotejson[patchindex]['name']
        localjson[localpatches.index(patchname)]['appname'] = remotejson[patchindex]['compatiblePackages'][0]['name']


for patchname in localpatches:
    if patchname not in remotepatches:
        del localjson[localpatches.index(patchname)]

with open("patches.json", "w") as patchesfile:
    json.dump(localjson, patchesfile, indent=4)