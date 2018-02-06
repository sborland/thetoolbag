#traverses a json file that contains various lists and dictionary objects without pattern
#and prints keys and their values. 

import json, argparse, requests

#options to either GET json data or use a file
parser = argparse.ArgumentParser(description='Recursively traverses a json file that contains various lists and dictionary objects without pattern and prints keys and their values.')
group = parser.add_mutually_exclusive_group()
group.add_argument('--file', action='store', help='Optional file location of json', type=str)
group.add_argument('--get', action='store', help='Optional REST call for json data', type=str)
args = parser.parse_args();

#Walk down a list and print it's values
#If the value is a dict, call traverseDict
#If the value is another list, recurse with the value 
def traverseList(listObj):
	for item in listObj:
		if type(item) is dict:
			traverseDict(item)
		elif type(item) is list:
			traverseList(item)
		else:
			print item

#Print the key value of every itme
#If the value of the key is a list, call traveseList(value)
#If the value of the key is another dict, recurse with the value
def traverseDict(dictObj):
	for key in dictObj:
		if type(dictObj[key]) is dict:
			traverseDict(dictObj[key])
		elif type(dictObj[key]) is list:
			print str(key)+" list:"
			traverseList(dictObj[key])
		else:
			print str(key) + ":" + str(dictObj[key])

#depending on what object type, it'll recursively 
#walk down a list or get the keys from a dictionary
#and read the values
def start(jsonObject):
	if type(jsonObject) is dict:
		traverseDict(jsonObject)
	elif type(jsonObject) is list:
		traverseList(jsonObject)

#Main
if args.file:
	file = open(args.file,'r')
	jsonObject = json.load(file)
elif args.get:
	response = requests.get(args.get)
	jsonObject = response.json()
start(jsonObject)

