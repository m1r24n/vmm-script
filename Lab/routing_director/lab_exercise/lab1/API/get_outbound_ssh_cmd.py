#!/usr/bin/env python3
import requests, json, os
RD_IP=os.getenv('RD_IP')
TOKEN_API=os.getenv('TOKEN_API')
ORG_ID=os.getenv('ORG_ID')
if not RD_IP:
    print("RD_IP is not defined")
    exit()
if not TOKEN_API:
    print("TOKEN_API is not defined")
    exit()
if not ORG_ID:
    print("ORG_ID is not defined")
    exit()
headers={'Authorization':f"Token {TOKEN_API}"}
API_EP=f"/api/v1/orgs/{ORG_ID}/ocdevices/outbound_ssh_cmd"
url = f"https://{RD_IP}{API_EP}"
x = requests.get(url, headers=headers,verify=False)
# print(json.loads(x.text)['cmd'].split("\n"))
d1 = json.loads(x.text)['cmd'].split("\n")
d2 = [ i for i in d1 if "delete" not in i]
d3 = "\n".join(d2)
with open("../ansible/onboarding.set","w") as f1:
    print(d3)
    f1.write(d3)