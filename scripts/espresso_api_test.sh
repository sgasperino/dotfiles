#!/bin/bash

#$1 = number of events returned
#$2 = search terms
#$3 = fully qualified search string
#$4 = name of the saved search
#$5 = the reason the action/script was triggered (for example, the number of events returned was >1)
#$6 = a link to the saved search in Splunk +
#$7 = a list of the tags belonging to this saved search (this option was removed starting in Splunk 3.6)
#$8 = path to a file where raw results of this search are located (as opposed to passing the actual results into the ticket--this could be a lot of data).
read sessionKey

## Set some defaults:
espresso_server="https://espressoapi.siri.apple.com/tickets.json"
result=`zcat ${8} | sed '1d'`
searchlink=$6

IFS=$'\n'

## Parse results to form espresso_API call.

for ret in ${result}
do

    ## Grabbing host name and count.

    host_name=$(echo "${ret}" | cut -d ',' -f1|cut -d '.' -f1|cut -d "\"" -f2)
    host_prefix=$(echo "${host_name}" | cut -d '-' -f1)
    host_group=$(echo "${host_name}" | cut -d '-' -f2 | sed 's/[^a-z]*//g')
    host_number=$(echo "${host_name}" | cut -d '-' -f2 | sed 's/[^0-9]*//g')
    parsed_number=$(echo "${host_number}" | sed -e 's/\(.\)/\1./g')
    count=$(echo "${ret}" | cut -d ',' -f2)
    graphite_string="production.hosts.${host_prefix}.${host_group}.${parsed_number}net.rx.crc_errors"

    ## Forming ticket body.

    summary="${host_name} has experienced ${count} crc errors for at least 100 minutes in the last 24 hours. Link: ${searchlink} Graph: https://graphite.siri.apple.com/render/?target=${graphite_string}"

    ## Calling espressoAPI

curl \
 -d "ticket[espresso_category]=Hardware Failure" \
 -d "ticket[escalated_workgroup]=Siri Support" \
 -d "ticket[espresso_product]=Siri Infrastructure" \
 -d "ticket[subject]=${host_name} - crc errors" \
 -d "ticket[hostname]="${host_name}".siri.apple.com" \
 -d "ticket[description]=${summary}" \
 -d "ticket[priority]=2" \
 -d "ticket[reportedBy]=Splunk" \
 -d "ticket[dedup_columns]=hostname" \
 "${espresso_server}"

done