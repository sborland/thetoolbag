
#Delete a bunch of deployments in bf. 

import json, argparse, requests, xmltodict
#Supress warnings with -W ignore
parser = argparse.ArgumentParser(description="Deletes all the actions/deployments in bf")
parser.add_argument('--address', action='store', type=str)
parser.add_argument('--user', action='store', type=str)
parser.add_argument('--pw', action='store', type=str)
args = parser.parse_args();

url = 'https://'+args.address+':52311/api/actions'

response = requests.get(url, auth=(args.user,args.pw), verify=False)
res = json.loads(json.dumps(xmltodict.parse(response.text)))

if "Action" in res["BESAPI"].keys():
	for item in res["BESAPI"]["Action"]:
		resDelete = requests.delete(item["@Resource"], auth=(args.user,args.pw), verify=False);
		print "deleting " + item["@Resource"] + " | status: " +str(resDelete.status_code)
else:
	print "no actions to delete!"
