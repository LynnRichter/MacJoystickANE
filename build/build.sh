#!/bin/bash

# Set this to the location of your Flex SDK bin folder
flexsdkloc=/Applications/Adobe\ Flash\ Builder\ 4.6/sdks/4.6.0/bin

echo "Prepping SWC library.swf for build.."
cp -v MacJoystickANE.swc lib.zip

unzip lib.zip
cp -v library.swf release/library.swf
mv -fv library.swf debug/library.swf

echo "Packaging Debug..."
"$flexsdkloc/adt" -package -target ane MacJoyANE.ane extension.xml -swc MacJoystickANE.swc -platform iPhone-ARM -C debug .
echo "Cleaning up.."

rm lib.zip
rm catalog.xml

echo ""
echo "MacJoyANE.ane BUILD COMPLETE"
echo ""