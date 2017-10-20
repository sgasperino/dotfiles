#! /bin/bash
	
	
	
	pod_array=("mu21p01sa-hbase00" "nk31p01sa-hbase00" "nk32p01sa-hbase00" "nk33p01sa-hbase00" "pv11p02sa-hbase00" "pv11p03sa-hbase00" "pv11p04sa-hbase00" "rd13p01sa-hbase00" "rd13p02sa-hbase00" "rd13p03sa-hbase00" "rd13p04sa-hbase00" "st14p01sa-hbase00" "st14p02sa-hbase00" "st14p03sa-hbase00" "st14p04sa-hbase00" "sy21p01sa-hbase00")

	node=1
	
	while [  $node -lt 8 ]; do
	
		for host_name in "${pod_array[@]}"; do
			SLOT=$(ssh $host_name$node sudo /usr/sbin/hpacucli controller all show | grep -i slot | awk '{print $6}')
			if ssh $host_name$node sudo /usr/sbin/hpacucli ctrl slot=$SLOT pd all show |egrep -iq 'failure|failed'; then
				echo 
				 ssh $host_name$node sudo "echo && hostname && sudo /usr/sbin/hpacucli ctrl slot=$SLOT pd all show |egrep -i 'failure|failed'"
				echo
			fi		

		done
		let node=node+1 
	done