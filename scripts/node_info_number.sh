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

node_array=("nk32p01sa-hbase047"
"st14p05sp-nss196"
"st14p04sp-zkapp002"
"st14p06sp-ec002"
"st11s01sp-hbase018"
"st14p04sp-zkapp004"
"st13p02sp-nss414"
"st14p01sp-nss118"
"st14p06sp-nss401"
"st14p01sp-nss205"
"st13g01sa-node063"
"st13p01sp-nss228"
"st14p02sp-apg003"
"st14p02sp-nss273"
"st14p06sp-nss396"
"st14p01sp-nss328"
"st13p02sp-nss372"
"st14p02sp-nss122"
"st13p01sp-nss261"
"st11s02sp-hbase001"
"st11s02sp-hbase005"
"st11s02sp-hbase007"
"st11s01sp-hbase024"
"st14p05sp-nss040"
"st14p01sp-nss047"
"st14p01sp-nss212"
"st14p01sp-nss338"
"st13p02sp-nss182"
"st13p02sp-lc010"
"st13g01sa-node053"
"st14p01sp-nss197"
"st14p04sp-nss418"
"st14p03sp-nss251"
"st14p05sp-nss175"
"st14p01sp-nss186"
"st14p02sp-nss379"
"st14p06sp-nss033"
"st14p06sp-nss406"
"st14p05sp-nss089"
"st14p03sp-nss312"
"st14p06sp-ec033"
"st14p06sp-nss402"
"st14p06sp-ec012"
"st14p01sp-nss249"
"st14p05sp-nss170"
"st14p01sp-nss387"
"st13p02sp-nmas015"
"st14p05sp-nss294"
"st14p01sp-nss050"
"st14p05sp-nss317"
"st14p01sp-nss103"
"st14p01sp-nss181"
"st14p06sp-nss391"
"st13g01sa-node008"
"st14p02sp-nss180"
"st14p03sp-nss396"
"st14p01sp-nss329"
"st13p01sp-lc007"
"st11s02sp-hbase006"
"st14p02sp-nss237"
"st13p02sp-nss390"
"st13p01sp-nss375"
"st13p01sp-nss014"
"st13p02sp-gw012"
"rd13p05si-dstore003"
"st14p02sp-nss213"
"st13p02sp-nss307"
"st14p03sp-nss050"
"st13p02sp-nss215"
"st13p02sp-pmng001"
"st14p03sp-nss178"
"st14p03sp-nss055"
"st13p02sp-nss145"
"st14p03sp-nss039"
"st14p02sp-nss226"
"st14p03sp-nss230"
"st13g01sa-node062"
"st14p01sp-nmas015"
"st14p02sp-nmas009"
"st14p01sp-nss188"
"st13p02sp-gw001"
"st14p02sp-gw015"
"st14p05sp-nss323"
"st13p02sp-nss038"
"st14p02sp-nss263"
"st14p03sp-nss097"
"st14p02sp-lc010"
"st13g01sa-node066"
"st13p02sp-nss322"
"st14p01sp-nss163"
"st14p01sp-nss230"
"st14p02sp-nss268"
"st13g01sa-node001"
"st14p05sp-nss036"
"st13g01sa-node011"
"st13p01sp-nss330"
"st14p05sp-nss338"
"st14p05sp-nss029"
"st14p03sp-nss405"
"st13p02sp-nss040"
"st14p03sp-nss100"
"st13p01sp-nss308"
"st14p01sp-nss032"
"st14p01sp-nss388"
"st14p02sp-gw005"
"st14p05sp-nss318"
"st14p02sp-ec034"
"st14p01sp-nss305"
"st14p01sp-nss165"
"st14p04sp-nss147"
"st14p03sp-nss156"
"st14p01sp-nss072"
"st14p01sp-ec015"
"st14p05sp-nss310"
"st14p02sp-nss385"
"st14p01sp-nmas002"
"st14p02sp-ec035"
"st13p02sp-nss313"
"st13g01sa-node024"
"st13p02sp-nss308"
"st14p04sp-nss203"
"st14p04sp-nss203"
"st14p03sp-nss041"
"st14p01sp-nss407"
"st14p01sp-nss407"
"st14p01sp-nss092"
"st14p01sp-nss145"
"st14p01sp-nss422"
"st14p01sp-nss074"
"st13p02sp-splunk001"
"st13p02sp-nss177"
"st14p05sp-nss200"
"st14p01sp-nss179"
"st14p01sp-nss214"
"st14p02sp-nss224"
"st14p05sp-nss166"
"st14p01sp-nss078"
"st14p01sp-nss349"
"st14p01sp-nss073"
"st14p01sp-nss099"
"st13p02sp-lc007"
"st14p03sp-nss047"
"st14p01sp-splunk001"
"st14p01sp-nss022"
"st14p01sp-nss303"
"st14p01sp-nss082"
"st14p01sp-nss146"
"st13p02sp-nss233"
"st11s01sp-lmis002"
"st14p03sp-nss310"
"st13g01sa-node023"
"st14p02sp-ec027"
"st14p01sp-nss053"
"st14p02sp-nss182"
"st13p01sp-gw010"
"st14p04sp-gw012"
"st13p01sp-nss393"
"st13g01sa-node052"
"st13g01sa-node043"
"st13p02sp-nss345"
"st14p05sp-nss250"
"st14p03sp-nss110"
"st13p01sp-nss333"
"st13p02sp-lc004"
"st13p02sp-nmas008"
"st14p05sp-nss204"
"st14p05sp-nss204"
"st14p03sp-nss034"
"st14p06sp-nss018"
"st14p01sp-nss003"
"st14p01sp-nss235"
"st14p02sp-nss302"
"st13p01sp-nss427"
"st14p03sp-nss034"
"st13p01sp-nss227"
"st13p01sp-nss285"
"st14p02sp-nss425"
"st14p01sp-nss087"
"st14p01sp-nss202"
"st13g01sa-node067"
"st13p01sp-nmas004"
"st14p01sp-nss039"
"st14p01sp-nss039"
"st14p03sp-nss020"
"st13p02sp-nss413"
"st14p01sp-nss084"
"st14p03sp-nss020"
"st14p03sp-nss291"
"st14p01sp-nss408"
"st13g01sa-node034"
"st14p01sp-lc008"
"st13p02sp-nss100"
"st14p02sp-nss057"
"st14p06sp-nss051"
"st14p02sp-nss167"
"st14p01sp-nss415"
"st14p01sp-nss220"
"st13p02sp-nss201"
"st14p01sp-nss091"
"st13p01sp-nss256"
"st14p02sp-nss127"
"st13p02sp-nss094"
"st13p02sp-nss045"
"st14p02sp-nmas015"
"st14p05sp-nss212"
"st14p01sp-nss156"
"st14p03sp-nss095"
"st14p01sp-nss058"
"st14p01sp-nss224"
"st13p02sp-nss415"
"st14p05sp-nss187"
"st13p01sp-nss223"
"st14p03sp-nss402"
"st13g01sa-node022"
"st13p01sp-nss080"
"st14p03sp-nss075"
"st13p02sp-lc003"
"st13p02sp-nss224"
"st14p06sp-nss403"
"st13g01sa-node071"
"st14p05sp-nss384"
"st14p01sp-nss203"
"st14p05sp-nss215"
"st14p01sp-nss046"
"st13p02sp-nss056"
"st14p01sp-nss337"
"st14p01sp-nss101"
"st14p01sp-ec017"
"st14p02sp-nss356"
"st14p05sp-ec043"
"st13p02sp-nss304"
"st14p02sp-nss409"
"st13p01sp-nss224"
"st14p04sp-nss132"
"st14p06sp-nss346"
"st14p02sp-nss019"
"st14p01sp-nss096"
"st14p02sp-nss037"
"st14p01sp-nss097"
"st13g01sa-node035"
"st14p04sp-nss132"
"st14p06sp-nss346"
"st14p02sp-nss197"
"st14p02sp-nss404"
"st14p05sp-nss291"
"st14p04sp-nss231"
"st14p06sp-ec013"
"st13p02sp-nss099"
"st14p02sp-nss410"
"st13g01sa-node036"
"st13p01sp-nss161"
"st11s02sp-lmis001"
"st14p01sp-nss419"
"st13p01sp-apg004"
"st13g01sa-node047"
"st14p01sp-nss060"
"st13p02sp-nss297"
"st14p01sp-nss061"
"st13p01sp-nss129"
"st13p01sp-nmas008"
"st14p02sp-nss384"
"st13p01sp-nss394"
"st13g01sa-node050"
"st14p02sp-nss253"
"st13p02sp-gw009"
"pv11p03si-flume007"
"st14p01sp-nss034"
"st14p01sp-nss174"
"st14p05sp-nss190"
"st14p02sp-nss399"
"st14p03sp-nss246"
"nk32p01si-flume021"
"rd13p00sp-splunk001"
"st14p01sp-gw014"
"st13p02sp-nss324"
"st14p02sp-lc005"
"st13p01sp-nss077"
"st14p01sp-nss255"
"st14p06sp-rmng004"
"st14p01sp-nss126"
"st14p04sp-nss062"
"st14p02sp-nss408"
"st14p01sp-nss416"
"st14p03sp-nss403"
"st14p01sp-nss417")

for node in "${node_array[@]}"; do
	siri_query_vdctadv $node |grep -m 1 serial_number: >> nodeinfo_serial.txt

done

