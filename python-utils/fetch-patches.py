import requests
import json

localjson = None

with open('sources.json', 'r') as sourcesfile:
    sourcesjson = json.load(sourcesfile)

for source in sourcesjson:
    if source['sourceStatus'] == "on":
        patchesrepo = source['sourceMaintainer']
        patchesbranch = source['jsonBranch']

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
obsoletepatches = []
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
        newkey['description'] = remotejson[patchindex]['description']
        if remotejson[patchindex]['excluded'] == True:
            newkey['status'] = "off"
        elif remotejson[patchindex]['excluded'] == False:
            newkey['status'] = "on"

        localjson.append(newkey)
    else:
        patchindex = remotepatches.index(patchname)
        localjson[localpatches.index(patchname)]['patchname'] = remotejson[patchindex]['name']
        localjson[localpatches.index(patchname)]['description'] = remotejson[patchindex]['description']
        localjson[localpatches.index(patchname)]['appname'] = remotejson[patchindex]['compatiblePackages'][0]['name']


for patchname in localpatches:
    if patchname not in remotepatches:
        obsoletepatches.append(localpatches.index(patchname))

for index in sorted(obsoletepatches, reverse=True):
    del localjson[index]

with open("patches.json", "w") as patchesfile:
    json.dump(localjson, patchesfile, indent=4)