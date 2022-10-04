import requests
import json



with open('sources.json', 'r') as sourcesfile:
    sourcesjson = json.load(sourcesfile)

patchesrepo = sourcesjson[0]['patches']['repo']
integrationsrepo = sourcesjson[1]['integrations']['repo']

patchesurl = sourcesjson[0][ "https://api.github.com/repos/", patchesrepo, "/revanced-patches/releases/latest" ]
integrationsurl = sourcesjson[0][ "https://api.github.com/repos/", patchesrepo, "/revanced-patches/releases/latest" ]


requests_session = requests.Session()
patches_version = (((requests_session.get(patchesurl)).json())['name'])
cli_version = (((requests_session.get('https://api.github.com/repos/revanced/revanced-cli/releases/latest')).json())['name'])
integrations_version = (((requests_session.get(integrationsurl)).json())['name'])

print(patches_version)
print(cli_version)
print(integrations_version)