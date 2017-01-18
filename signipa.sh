#!/bin/sh

#set -e -x

USAGE="$0 dev.ipa release.mobileprovision \"Full name of the certificate\""
test -z "$1" && echo $USAGE && exit 0

IPA="$1"

PROVISION="$2" # ~/Documents/release.mobileprovision
CERTIFICATE="$3" # must be in keychain

# unzip the ipa
unzip -q "$IPA"

# remove the signature
rm -rf Payload/*.app/_CodeSignature Payload/*.app/CodeResources

# replace the provision
cp "$PROVISION" Payload/*.app/embedded.mobileprovision

# sign with the new certificate
/usr/bin/codesign -f -s "$CERTIFICATE" --resource-rules Payload/*.app/ResourceRules.plist Payload/*.app

# zip it back up
zip -qr resigned.ipa Payload

# offer to itunes connect
open -a Safari "https://itunesconnect.apple.com/itc/static/login?view=1&path=%2FWebObjects%2FiTunesConnect.woa%3F"