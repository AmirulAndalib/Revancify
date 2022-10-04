import requests
import json



with open('sources.json', 'r') as sourcesfile:
    sourcesjson = json.load(sourcesfile)

patchesrepo = sourcesjson[0]['patches']['repo']
integrationsrepo = sourcesjson[1]['integrations']['repo']

patchesurl = "".join(["https://api.github.com/repos/", patchesrepo, "/revanced-patches/releases/latest"])
integrationsurl = "".join(["https://api.github.com/repos/", integrationsrepo, "/revanced-integrations/releases/latest"])


requests_session = requests.Session()
patches_version = (((requests_session.get(patchesurl)).json())['name']).replace("v", "")
cli_version = (((requests_session.get('https://api.github.com/repos/revanced/revanced-cli/releases/latest')).json())['name']).replace("v", "")
integrations_version = (((requests_session.get(integrationsurl)).json())['name']).replace("v", "")

print(patches_version)
print(cli_version)
print(integrations_version)