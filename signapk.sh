#!/bin/bash

#set -e -x

# Sample usage is as follows;
# ./signapk myapp.apk debug.keystore android androiddebugkey
# 
# param1, APK file: Calculator_debug.apk
# param2, keystore location: ~/.android/debug.keystore
# param3, key storepass: android
# param4, key alias: androiddebugkey

USAGE="$0 myapp.apk debug.keystore android androiddebugkey"
test -z "$1" && echo $USAGE && exit 0

# use my debug key default
APK=$1
KEYSTORE="${2:-$HOME/.android/debug.keystore}"
STOREPASS="${3:-android}"
ALIAS="${4:-androiddebugkey}"

# get the filename
APK_BASENAME=$(basename $APK)
SIGNED_APK="signed_"$APK_BASENAME

# delete META-INF folder
zip -d $APK META-INF/\*

# sign APK
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore $KEYSTORE -storepass $STOREPASS $APK $ALIAS
#verify
jarsigner -verify $APK

#zipalign
ZIPALIGN=$(find $ANDROID_HOME -name zipalign)
$ANDROID_HOME/$ZIPALIGN -v 4 $APK $SIGNED_APK 
