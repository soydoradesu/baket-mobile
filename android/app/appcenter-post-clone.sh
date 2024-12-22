#!/usr/bin/env bash
# Place this script in project/android/app/

cd ..

# fail if any command fails
set -e
# debug log
set -x

cd ..
git clone -b beta https://github.com/flutter/flutter.git
export PATH=`pwd`/flutter/bin:$PATH

flutter channel stable
flutter doctor

echo "Installed flutter to `pwd`/flutter"

# export keystore for release
echo "$KEY_JKS" | base64 --decode > release-keystore.jks

echo "BASE_URL_LOCAL_WEB=http://127.0.0.1:8000" > .env
echo "BASE_URL_LOCAL_HP=http://10.0.2.2:8000" >> .env
echo "BASE_URL_PROD=$BASE_URL_PROD" >> .env

flutter pub run build_runner build --delete-conflicting-outputs

# build APK
# if you get "Execution failed for task ':app:lintVitalRelease'." error, uncomment next two lines
# flutter build apk --debug
# flutter build apk --profile
flutter build apk --release

# copy the APK where AppCenter will find it
mkdir -p android/app/build/outputs/apk/; mv build/app/outputs/apk/release/app-release.apk $_