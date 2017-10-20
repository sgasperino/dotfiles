# railroad v0.1.2

## Who:
Tool created for the Telemetry team. Though it is written in such a way that it could be agnostic and apply to any other tools or teams in the future.

## What:
This tool will query the current location of a given alias and then move the given alias to the OPPOSITE CoreLB instance.

IE. If your alias is found in st05 (corelb.st05.siri.apple.com), then it will be removed and added to the rd13 (rd13p05si-corelb.siri.apple.com) instance.

## Where:
The tool can be run from any of the batch hosts. Currently I have tested and confirmed it on st05.

## Why:
Having failover abilities outside of Infoblox has become a priority. If these instance of these apps goes down, we need a reliable way to swap to a different one without having to physically log into infoblox.

## How:
````
NAME:
	railroad -
		Railroad is a command-line interface for changing the endpoint of our web interfaces.
		(splunk.siri.apple.com and graphite.siri.apple.com) This allows the changing of the endpoints in a safe and fast manner.

USAGE:
  railroad [options] [arguments]

VERSION:
	[0.1.2]

AUTHOR(S):
	Sean Gasperino <sgasperino@apple.com>

=====================================================

Options: -f -p -n

-f: Finder:
	Locates the current corelb entry and the endpoints associated with app <foo>


-p: Prediction:
	Shows all the possible corelb endpoints from all possible AZs.


-n: Noop:
	Runs the main function in noop mode, making no changes but showing the actions that would have been taken on a full run.
````

## Caveats:

- This does require you type in your password, and even though a second 'password' prompt will show up, you don't need to type anything. This is the voyager commands getting information from the script. Once you type your password the first time, it does the rest. Including a sleep command in between the deletion and the addition, to prevent any errors of multi-tenancy.

- The tool is currently set up for only st05 and rd13. In the future if we find ourselves with apps in other locations (Such as the planned pv05 splunk instances) I will need to add more location options for this. I would like to do so in a way that doesn't add a lot more code, just a simple switch somewhere else in the code. (see goals below)

- The first argument after the flags, is the app name that it is going search for. So you will need to type out the FQDN (graphite.siri.apple.com).

- I have created a test alias (graphite-test.siri.apple.com) that has backings in both corelb instances. So you can test this tool using that alias and see it change from one location to the other. Obviously testing with the production instance is not the best idea at the moment.

- The script does automatic checking of the endpoints, but I don't have a failout option. So once you are committed to the full run, there is no changing it mid stream. I strongly recommend running the noop mode first to make sure you can see where the alias is going to be moved to and if that is your intended location.

- Currently the app doesn't have a notion of what is production and what isn't. I do want to add at some point some way for it to double check if it senses a production instance being pointed at. For the time being, it is relying on the user to type in a real and correct FQDN.

## Version 1.0 Goals:

- Migrate to python
- Remove the erroneous second 'password' prompt
- Add safety features for production FQDNs.
- Add logging
- Work towards making this robust enough to be run without our intervention. (This is going to require a lot of edge case testing)
- Add alternative corelb instances that can be used (pv05)
- Add way to skip the current check and add a completely new alias
