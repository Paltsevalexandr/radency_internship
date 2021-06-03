#!/bin/sh

# --batch to prevent interactive command
# --yes to assume "yes" for questions
gpg --quiet --batch --yes --decrypt --passphrase="$ANDROID_KEYS_SECRET_PASSPHRASE" \
--output android/keys/android_keys.zip android/keys/android_keys.zip.gpg && cd android/keys && jar xvf android_keys.zip && cd -