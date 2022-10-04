import requests
import json



with open('sources.json', 'r') as sourcesfile:
    sourcesjson = json.load(sourcesfile)

patchesrepo = sourcesjson[0]['patches']['repo']
clirepo = sourcesjson[1]['cli']['repo']
integrationsrepo = sourcesjson[2]['integrations']['repo']


patchesurl = "".join(["https://api.github.com/repos/", patchesrepo, "/revanced-patches/releases/latest"])
cliurl = "".join(["https://api.github.com/repos/", clirepo, "/revanced-cli/releases/latest"])
integrationsurl = "".join(["https://api.github.com/repos/", integrationsrepo, "/revanced-integrations/releases/latest"])


requests_session = requests.Session()
patches_version = (((requests_session.get(patchesurl)).json())['name']).replace("v", "")
cli_version = (((requests_session.get(cliurl)).json())['name']).replace("v", "")
integrations_version = (((requests_session.get(integrationsurl)).json())['name']).replace("v", "")

print(patches_version)
print(cli_version)
print(integrations_version)