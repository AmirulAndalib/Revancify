import requests
import json

localjson = None

with open('sources.json', 'r') as sourcesfile:
    sourcesjson = json.load(sourcesfile)

for source in sourcesjson:
    if source['sourceStatus'] == "on":
        patchesrepo = source['sourceMaintainer']

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

with open("remotepatches.json", "r") as remotepatches:
    remotejson = json.load(remotepatches)

remotepatches = [key['name'] for key in remotejson]
localpatches = [key['patchname'] for key in localjson]
obsoletepatches = []


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