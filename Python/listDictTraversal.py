#traverses a file that contains various lists and dictionary objects without pattern
#and prints keys and their values. 

import json, argparse, requests


parser = argparse.ArgumentParser(description='Traverses a json file, that contains various lists and dictionary objects without pattern and prints keys and their values.')
group = parser.add_mutually_exclusive_group()
group.add_argument('--file', action='store', help='Optional file location of json', type=str)
group.add_argument('--get', action='store', help='Optional REST call for json data', type=str)
args = parser.parse_args();


if args.file:
	print(args.file)
	file = open(args.file,'r')
	jsonObject = json.load(file)
elif args.get:
	print(args.get)
	response = requests.get(args.get)
	jsonObject = response.json()

print jsonObject