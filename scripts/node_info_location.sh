#! /bin/bash

function siri_query_vdctadv()  {
		export command="curl"
		export url="https://cartographer.siri.apple.com"
		export urlpath="/api/v2/"
		export hostname="${1}"


		echo "${command} ${url}${urlpath}assets?asset.hostname=${hostname}"
		${command} -s ${url}${urlpath}assets?asset.hostname=${hostname} | python -m json.tool | sed 's/\"//g' | tr -d "," | grep ":"
		${command} -s ${url}${urlpath}assets?asset.hostname=${hostname}.siri.apple.com | python -m json.tool | sed 's/\"//g' | tr -d "," | grep ":"

}

node_array=("st14p01si-bigip005"
"st14p04sp-nss001"
"st14p04sp-lc010"
"st14p04sp-nss005"
"st14p04sp-lc008"
"st14p04sp-lc007"
"st14p04sp-lc009"
"st14p04sp-lc006"
"st14p04sp-lc003"
"st14p04sp-gw014"
"st14p04sp-lc005"
"st14p04sp-lc001"
"st14p04sp-gw015"
"st14p04sp-gw013"
"st14p04sp-gw012"
"st14p04sp-gw010"
"st14p04sp-gw009"
"st14p04sp-gw011"
"st14p04sp-aistat001"
"st14p04sp-ec044"
"st14p04sp-ec043"
"st14p04sp-rmng004"
"st14p04sp-zkapp001"
"st14p04sp-nss398"
"st14p04sp-pmng001"
"st14p04sp-nss399"
"st14p04sp-cm001")

for node in "${node_array[@]}"; do
	siri_query_vdctadv $node |grep -m 1 location_in_building: >> node_location.txt

done

