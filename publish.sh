#!/usr/bin/env bash

rootPath=`pwd`

echo "开始打包apk"
flutter build apk --target-platform android-arm --split-per-abi

echo "开始打包ipa"
flutter build ios --release #--no-codesign

if [[ -d build/ios/iphoneos/Runner.app ]]
    then

    cd build/ios/iphoneos
    mkdir Payload

#    cp -r build/ios/iphoneos/Runner.app Payload

    cp -r Runner.app Payload
#    zip -r -m funds-ios-$(date "+%Y%m%d%H%M").ipa Payload
    zip -r -m funds-release.ipa Payload

    echo "打包很顺利😄"
else
    echo "ios打包报错了😭, 打开Xcode查找错误原因"
fi

cd ${rootPath}
mv ./build/ios/iphoneos/*.ipa ./publish/
mv ./build/app/outputs/apk/release/*.apk ./publish/