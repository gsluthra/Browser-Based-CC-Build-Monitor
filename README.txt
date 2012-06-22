============================================
BUILD MONITOR FOR JENKINS (using cc.xml)
============================================

+---------------------+
 settings.json
+---------------------+
This file contains all the external settings required for Build Monitor, ex. URL, report directory, etc.
Changes in this file will require a restart of FailedTestCount.rb script.

+---------------------+
 FailedTestCount.rb
+---------------------+
This file is ruby script which does following in infinite loop:
1) Fetches cc.xml from jenkins with latest build information of all the builds.
2) Fetches build reports of the builds mentioned in the settings.json ("builds" property)
3) Calculate failed tests, total tests and JIRA count for each build.
4) Update these counts in respective text files mentioned at settings.json ("builds" property)

+---------------------+
 index.html
+---------------------+
This file is Build Monitor view. It
1) Show div for each build from "html_build_lists" property of settings.json
2) Display failed tests, total tests and JIRA count for each build from respective text report file (calculated by FailedTestCount.rb)
3) Refresh page every single minute

+---------------------+
 buildmonitor.sh
+---------------------+
This is a wrapper bash shell script to start Build Monitor. This internally:
1) Determines the OS on which the application has to run (required to get browser path)
2) Starts Firefox browser in background
3) Starts FailedTestCount.rb which updates the reports in infinite loop.


- A project by Pooja Akshantal and Shirish Padalkar based on Gurpreet's original. Any feedback is appreciated. :)