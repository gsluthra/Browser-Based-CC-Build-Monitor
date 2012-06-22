#!/bin/bash

echo "------------------------------------------------------"
echo "          Build monitor for Jenkins builds            "
echo "------------------------------------------------------"

echo "Determining platform..."
platform=`uname`
if [[ "$platform" == 'Linux' ]]; then
   echo "Linux platform detected. Starting Firefox in the background."
   firefox index.html &
   #chromium-browser --allow-file-access-from-files index.html &
elif [[ "$platform" == 'Darwin' ]]; then
   echo "Mac OS X platform detected. Starting Firefox in the background."
   /Applications/Firefox.app/Contents/MacOS/firefox index.html &
   #chrome --allow-file-access-from-files index.html &
fi

echo "Starting ruby script to generate failed test reports..."
ruby FailedTestCount.rb
