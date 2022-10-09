import requests
import json



with open('sources.json', 'r') as sourcesfile:
    sourcesjson = json.load(sourcesfile)

for source in sourcesjson:
    if source['source_status'] == "on":
        patchesrepo = source['source_maintainer']
        clirepo = source['source_maintainer']
        integrationsrepo = source['source_maintainer']


patchesurl = "".join(["https://api.github.com/repos/", patchesrepo, "/revanced-patches/releases/latest"])
cliurl = "".join(["https://api.github.com/repos/", clirepo, "/revanced-cli/releases/latest"])
integrationsurl = "".join(["https://api.github.com/repos/", integrationsrepo, "/revanced-integrations/releases/latest"])


requests_session = requests.Session()
patches_version = (((requests_session.get(patchesurl)).json())['tag_name']).replace("v", "")
cli_version = (((requests_session.get(cliurl)).json())['tag_name']).replace("v", "")
integrations_version = (((requests_session.get(integrationsurl)).json())['tag_name']).replace("v", "")

print(patches_version)
print(cli_version)
print(integrations_version)