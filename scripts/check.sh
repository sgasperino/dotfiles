#!/bin/bash
# 3/18	Added caching for HP servers
# 3/16  Removed trailing comma from RU output
# 3/12	Changed output order of hdinfo
# 3/11	Fixed incorrect asset tag parsing
# 3/11  Bug fixes with down hosts running hdscan and hdinfo
# 3/11	Removed duplicate and unnecessary code
# 3/10  Removed contact function
# 3/6   Added better flag handling
# 3/4 	Added drive info function
# 2/26  Added ability to query asset tag
# 2/20	Updated to include hdscan functionality
#-------------------------------------------------------------------------------------------------------#
#	Job Name  	:	check									#
#	Created by	:	Matthew Bartolomeo							#
#	Date		:	2/5/2015								#
#	Purpose		:	Script to get important host info					#
#	Info 		:	This script uses Cartographer APIs to output important host information # 
#				that we need in our tickets and vendor cases				#	
#-------------------------------------------------------------------------------------------------------#

if [[ ${1} == *.*  || ${2} == *.* || ${3} == *.* ]]; then
	echo "Error: Argument must be short-name only. Will not work with FQDN"
	exit
fi

if [[ -z ${1} ]]; then
	echo "Usage: check [hostname]"
	echo "Usage: check [-a assettag]"
	echo "Usage: check [-r hostname] Use -r flag to include HP RAID controller info"
	echo "Usage: check [-d drive_number] [hostname] Use -d to include specific drive information"
	exit
fi

cat /dev/null > ~/.tmpcheck.txt
cat /dev/null > ~/.tmpcheck2.txt
cat /dev/null > ~/.hpacucli_ld_output.txt
cat /dev/null > ~/.hpacucli_pd_output.txt
cat /dev/null > ~/.df_output.txt

# Sets HOST variable according to the flag entered
function host_asset {
case ${1} in
	-a)		
		ASSET=${2}
		HOST=$(curl -s https://cartographer.siri.apple.com/api/v2/assets?asset.tag=${2} | json_pp | tr -d '"' | grep -i "hostname" | egrep -v "null|${ASSET}" | tr -d "," | awk '{print $3}' | sort | uniq)
		HOST2=${HOST%%.*}
		;;
	-r)
		HOST=$(host ${2} | awk '{print $1}')
		HOST2=${HOST%%.*}
		if [[ ${HOST} == "Host" ]]; then
			echo "${2} is not in DNS"
			echo "Trying siri.apple.com domain"
			echo "If this doesn't work, do it the old fashioned way"
			HOST=${2}.siri.apple.com
		fi;;
	-d)
		if [ -n "$(echo "${2}" | sed 's/[0-9]//g')" ]; then
   	 		echo "Usage: check [hostname]"
			echo "Usage: check [-a assettag]"
			echo "Usage: check [-r hostname] Use -r flag to include HP RAID controller info"
			echo "Usage: check [-d drive_number] [hostname] Use -d to include specific drive information"
			exit
		fi
		HOST=$(host ${3} | awk '{print $1}')
		HOST2=${HOST%%.*}
		if [[ ${HOST} == "Host" ]]; then
			echo "${3} is not in DNS"
			echo "Trying siri.apple.com domain"
			echo "If this doesn't work, do it the old fashioned way"
			HOST=${3}.siri.apple.com
		fi
		;;
	*)
		HOST=$(host ${1} | awk '{print $1}')
		HOST2=${HOST%%.*}
		if [[ ${HOST} == "Host" ]]; then
			echo "${1} is not in DNS"
			echo "Trying siri.apple.com domain"
			echo "If this doesn't work, do it the old fashioned way"
			HOST=${1}.siri.apple.com
		fi;;
esac

if [[ ${1} != "-a" ]]; then
	ASSET=$(curl -s https://cartographer.siri.apple.com/api/v2/assets?asset.hostname=${HOST} | json_pp | tr -d '"' | grep tag | egrep -v "parent|rfid|null" | tr -d "," | awk '{print $3}')
fi

PAR_ASSET=$(curl -s https://cartographer.siri.apple.com/api/v2/assets?asset.hostname=${HOST} | json_pp | tr -d '"' | grep parent | egrep -v "rfid|null" | tr -d "," | awk '{print $3}')

if [[ -z ${ASSET} ]]; then
	ASSET=$(curl -s https://cartographer.siri.apple.com/api/v2/assets?asset.hostname=${HOST2} | json_pp | tr -d '"' | grep tag | egrep -v "rfid|null" | tr -d "," | awk '{print $3}')
fi

if [[ -z ${PAR_ASSET} ]]; then
	PAR_ASSET=$(curl -s https://cartographer.siri.apple.com/api/v2/assets?asset.hostname=${HOST2} | json_pp | tr -d '"' | grep parent | egrep -v "rfid|null" | tr -d "," | awk '{print $3}')
fi
}

# Cartographer API calls for hostname argument
function work {
echo -ne '   Retrieving Host Data                  (0%)\r'
curl -s https://cartographer.siri.apple.com/api/v2/assets?asset.hostname=${HOST} | json_pp | tr -d '"' | grep -v ru > ~/.tmpcheck.txt
echo >> ~/.tmpcheck.txt
curl -s https://cartographer.siri.apple.com/api/v2/hosts?asset.hostname=${HOST} | json_pp | tr -d '"' | grep -v ru >> ~/.tmpcheck.txt
echo >> ~/.tmpcheck.txt
echo -ne '   Retrieving Host Data  ####            (25%)\r'
curl -s https://cartographer.siri.apple.com/api/v2/networks?contains_host=${HOST} | json_pp | tr -d '"' | grep -v ru >> ~/.tmpcheck.txt
echo >> ~/.tmpcheck.txt

curl -s https://cartographer.siri.apple.com/api/v2/assets?asset.hostname=${HOST2} | json_pp | tr -d '"' | grep -v ru >> ~/.tmpcheck.txt
echo >> ~/.tmpcheck.txt
echo -ne '   Retrieving Host Data  ########        (50%)\r'
curl -s https://cartographer.siri.apple.com/api/v2/hosts?asset.hostname=${HOST2} | json_pp | tr -d '"' | grep -v ru >> ~/.tmpcheck.txt
echo >> ~/.tmpcheck.txt
curl -s https://cartographer.siri.apple.com/api/v2/networks?contains_host=${HOST2} | json_pp | tr -d '"' | grep -v ru >> ~/.tmpcheck.txt
echo >> ~/.tmpcheck.txt
echo -ne '   Retrieving Host Data  ############    (75%)\r'
curl -s https://cartographer.siri.apple.com/api/v2/assets?asset.tag=${ASSET} | json_pp | tr -d '"' | tr -d " " >> ~/.tmpcheck.txt
echo -ne '   Retrieving Host Data  ################(100%)\r'
sleep .2
}

# Sets variables used in output for hostname argument
function set_vars {
PARENT=$(grep parent ~/.tmpcheck.txt | tr -d " "| tr -d "," | grep -v null | sort | uniq)
SERIAL=$(grep serial ~/.tmpcheck.txt | tr -d " "| tr -d "," | grep -v null | sort | uniq)
RFID=($(grep rfid ~/.tmpcheck.txt | tr -d " "| tr -d "," | grep -v null | sort | uniq))
if [[ ${ASSET} ]]; then
	HOST_NAME=($(grep hostname ~/.tmpcheck.txt | tr -d " "| tr -d "," | egrep -v "null|${ASSET}" | sort | uniq))
fi

HOST_NAME2=($(grep hostname ~/.tmpcheck.txt | tr -d " "| tr -d "," | egrep -v "null|${HOST}" | sort | uniq | sed -E 's/^.{9}//'))
PREFIX=$(echo ${HOST:0:4})
ASSETTAG=($(grep tag ~/.tmpcheck.txt| tr -d " "| tr -d "," | egrep -v "null|rfid|parent|${PREFIX}" | sort | uniq))
MAN=$(grep manufacturer ~/.tmpcheck.txt | tr -d " "| tr -d "," | grep -v null | sort | uniq | sed -E 's/^.{13}//')
PRODUCT=$(grep product ~/.tmpcheck.txt | tr -d " "| tr -d "," | grep -v null | sort | uniq)
LOGICAL=$(grep logical ~/.tmpcheck.txt | tr -d " "| tr -d "," | grep -v null | sort | uniq)
LOCATION=($(grep location ~/.tmpcheck.txt | tr -d " "| tr -d "," | egrep -v "null|location:${PREFIX}" | sort | uniq))
RU=($(grep ru ~/.tmpcheck.txt | tr -d " "| grep -v null | sort | uniq))
DC=$(grep datacenter ~/.tmpcheck.txt | tr -d " "| tr -d "," | grep -v null | sort | uniq)
POD=$(grep pod ~/.tmpcheck.txt | tr -d " "| tr -d "," | grep -v null | sort | uniq)
VLAN=$(grep "vlan:" ~/.tmpcheck.txt | tr -d " "| tr -d "," | grep -v null | sort | uniq)
COMMENT=$(grep comment ~/.tmpcheck.txt | tr -d "," | grep -v null | sort | uniq |sed -e 's/ :\ /:\ /g')
OTHER=$(grep other ~/.tmpcheck.txt | sort | uniq | tr -d " "| tr -d "," | grep -v null | sort | uniq)
MAC=($(grep mac ~/.tmpcheck.txt | tr -d " "| tr -d "," | grep -v null | sort | uniq))
}

# Creates the output
function host_info {
echo
echo
echo "*********************************************************"
echo "*******************Host Information******************"
echo "*********************************************************"
echo
if [[ ${HOST_NAME} ]]; then
	printf '%s\n' "${HOST_NAME[@]}" | sed 's/:/: /'
fi
if [[ ${HOST_NAME2} ]]; then
	echo "oob_address:${HOST_NAME2}" | sed 's/:/: /'
fi
if [[ ${SERIAL} ]]; then
	echo ${SERIAL} | sed 's/:/: /'
fi
if [[ ${RFID} ]]; then
	echo ${RFID} | sed 's/:/: /'
fi
if [[ ${ASSETTAG} ]]; then
	echo ${ASSETTAG} | sed 's/:/: /'
fi
if [[ ${MAC} ]]; then
	printf '%s\n' "${MAC[@]}" | sed 's/:/: /'
fi
if [[ ${MAN} ]]; then
	echo "manufacturer:${MAN}" | sed 's/:/: /'
fi
if [[ ${PRODUCT} ]]; then
	printf '%s\n' "${PRODUCT[$i]}" | sed 's/:/: /'
fi
if [[ ${LOGICAL} ]]; then
	echo ${LOGICAL} | sed 's/:/: /'
fi
if [[ ${LOCATION} ]]; then
	printf '%s\n' "${LOCATION[@]}" | sed 's/:/: /'
fi
if [[ ${RU} ]]; then
	if [[ "${RU: -1}" == "," ]]; then
		printf '%s\n' "${RU[$i]}" | sed 's/:/: /' | sed 's/,$//'
	else
		printf '%s\n' "${RU[$i]}" | sed 's/:/: /'
	fi
fi
if [[ ${OTHER} ]]; then
	echo ${OTHER} | sed 's/:/: /'
fi
#if [[ ${DC} ]]; then
#	echo ${DC} | sed 's/:/: /'
#fi
#if [[ ${VLAN} ]]; then
#	echo ${VLAN} | sed 's/:/: /'
#fi
#if [[ ${COMMENT} ]]; then
#	echo ${COMMENT}
#fi
echo

if [[ ${PAR_ASSET} ]]; then
	curl -s https://cartographer.siri.apple.com/api/v2/assets?asset.tag=${PAR_ASSET} | json_pp | egrep "rfid|ru|serial|host" | tr -d '"' | tr -d " " > ~/.tmpcheck2.txt
	RU=$(grep ru ~/.tmpcheck2.txt | tr -d " " | grep -v null | sort | uniq)
	SERIAL=$(grep serial ~/.tmpcheck2.txt | tr -d " "| tr -d "," | grep -v null | sort | uniq)
	RFID=($(grep rfid ~/.tmpcheck2.txt | tr -d " "| tr -d "," | grep -v null | sort | uniq))
	CHASSIS=($(grep hostname ~/.tmpcheck2.txt | tr -d " "| tr -d "," | grep -v null | sort | uniq))
	echo
	echo "*********************************************************"
	echo "*****************Chassis Information****************"
	echo "*********************************************************"
	echo
	if [[ ${CHASSIS} ]]; then
		printf '%s\n' "${CHASSIS[@]}"| sed 's/:/: /'
	fi
	if [[ ${SERIAL} ]]; then
		echo ${SERIAL}| sed 's/:/: /'
	fi
	if [[ ${RFID} ]]; then
		printf '%s\n' "${RFID[@]}"| sed 's/:/: /'
	fi
	if [[ ${PARENT} ]]; then
		echo ${PARENT}| sed 's/:/: /'
	fi
	if [[ ${RU} ]]; then
		if [[ "${RU: -1}" == "," ]]; then
			echo ${RU} | sed 's/:/: /' | sed 's/,$//'
		else
			echo ${RU} | sed 's/:/: /'
		fi
	fi
fi
echo
}

# Ping host to determine if it is alive
function pingtest {
if ping -t 1 ${HOST} | grep "0 packets received" > /dev/null; then
    echo "Host is not responding"
  	echo -e "Cannot display raid info\n"
  	exit
else
	ALIVE=YES
fi
}

# Set variables for HP raid output
function get_hp_vars {
if [[ ${MAN} == *HP* ]]; then
	
	echo -ne '   Retrieving Controller Data                      (0%)\r'
	SLOT=$(ssh ${HOST} sudo /usr/sbin/hpacucli controller all show | grep -i slot | awk '{print $6}')
	echo -ne '   Retrieving Controller Data  #####               (25%)\r'
	ssh ${HOST} sudo /usr/sbin/hpacucli controller slot=${SLOT} ld all show | tr -s " " | grep -v '^$' >> ~/.hpacucli_ld_output.txt
	echo -ne '   Retrieving Controller Data  ##########          (50%)\r'
	ssh ${HOST} sudo /usr/sbin/hpacucli controller slot=${SLOT} pd all show | tr -s " " | grep -v '^$' >> ~/.hpacucli_pd_output.txt
	echo -ne '   Retrieving Controller Data  ###############     (75%)\r'
	ssh ${HOST} df -k >> ~/.df_output.txt
	echo -ne '   Retrieving Controller Data  ####################(100%)\r\n\n'
	sleep .2
	
	LD=$(grep logicaldrive ~/.hpacucli_ld_output.txt | wc -l )
	PD=$(grep physicaldrive ~/.hpacucli_pd_output.txt | wc -l )
	FLD=$(grep -i fail ~/.hpacucli_ld_output.txt | wc -l )
	FPD=$(grep -i fail ~/.hpacucli_pd_output.txt | wc -l )
	DF=$(grep "\-data" ~/.df_output.txt | wc -l )
	if [[ "${LD}" -eq "1" ]]; then
		LD_IS_OR_ARE=is
	else
		LD_S=s
		LD_IS_OR_ARE=are
	fi
			
	if [[ "${PD}" -eq "1" ]]; then
		PD_IS_OR_ARE=is
	else
		PD_S=s
		PD_IS_OR_ARE=are
	fi
else
	echo -e "\nThis is not an HP server, this is a(n) ${MAN}, raid info is unavailable\n"
	exit
fi 
}

# Check HP RAID controller
function hdscan {
if [[ ${ALIVE} == "YES" ]]; then
	if [[ ${MAN} == *HP* ]]; then
		if grep -qi fail ~/.hpacucli_pd_output.txt; then
	 		FAILED_ID=($(grep -i fail ~/.hpacucli_pd_output.txt | awk '{print $2}'))
			echo
			for i in "${FAILED_ID[@]}"; do
				echo -e "Failed Drive Info Below\n"
				ssh ${HOST} sudo /usr/sbin/hpacucli controller slot=${SLOT} pd ${i} show
			done	
		fi
		echo
		cat ~/.hpacucli_ld_output.txt
		echo
		echo
		cat ~/.hpacucli_pd_output.txt
		echo
		echo
		grep -A 1 "\-data" ~/.df_output.txt | tr -s " " | tr -d "-" | grep -v '^$'
		if [[ ${HOST} == *hbase* ]]; then
			echo
			echo "There "${LD_IS_OR_ARE}""$LD" logical drive"${LD_S}".  "$FLD"  failed "
			echo "There "${PD_IS_OR_ARE}""$PD" physical drive"${PD_S}". "$FPD"  failed"
			echo "There are"$DF" /data filesystems."
			echo 
			echo
		fi
	fi
fi


}

# Gets information for specified drive
function hdinfo {
if [[ ${ALIVE} == "YES" ]]; then
	if [[ ${MAN} == *HP* ]]; then
		if [[ ${PD} -ge ${2} ]]; then
			ID=$(egrep -vi "^$|array" ~/.hpacucli_pd_output.txt | sed -n ${2}p | awk '{print$2}')
			echo -e "\n\n************** Information for drive ${2} **************"
			ssh ${HOST} sudo /usr/sbin/hpacucli controller slot=${SLOT} pd ${ID} show
		else
			echo -e "\n\nDrive ${2} does not exist."
			echo -e "There "${PD_IS_OR_ARE}" only"$PD" physical drive"${PD_S}"."
		fi
	fi
fi
}

case ${1} in
	-a)		
		host_asset ${1} ${2}
		work
		set_vars
		host_info;;
	-r)
		host_asset ${1} ${2}
		work
		set_vars
		host_info
		pingtest
		get_hp_vars
		hdscan;;
	-d)
		host_asset ${1} ${2} ${3}
		work
		set_vars
		host_info
		pingtest
		get_hp_vars
		hdinfo ${1} ${2} ${3}
		hdscan;;
	*)
		host_asset ${1} ${2}
		work
		set_vars
		host_info;;
esac
