============================================
BUILD MONITOR FOR JENKINS (using cc.xml)
============================================



+-------------+
 index.html 
+-------------+
Open this file in FIREFOX browser to see the status of the build. This HTML parses the cc.xml file in the local directory and shows the status of the build.


+---------------------+
 ccFileDownloader.sh
+---------------------+
Run this script in a command window to download the "cc.xml" file from Jenkins server. The cc.xml file contains details of the latest JENKINS build.
This script runs in an infinite loop and downloads the build status XML file. This cc.xml file is referred by the status.html page for showing the status.

Note: The URL of the JENKINS server cc.xml is mentioned in the ccFileDownloader.sh. Modify this shell script file if you wish to change the URL.


+---------------------+
page_1.htm
+---------------------+
Contains the name of the build to be shown on the top left corner. Edit the name of the build to reflect the one you wish to show (check cc.xml for exact name).
Similarly.. edit page_2, page_3, page_4.html.






