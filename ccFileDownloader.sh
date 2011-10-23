#!/bin/bash

echo "Running script to download JENKINS file cc.xml"

# INFINTE LOOP
while true
do
	#Download the cc.xml file to temp_cc.xml file (no certificate check for SSL connections)
	wget https://some-jenkins-machine/view/All%20Builds/cc.xml --no-check-certificate -O temp_cc.xml
	rm cc.xml
	mv temp_cc.xml cc.xml
done


