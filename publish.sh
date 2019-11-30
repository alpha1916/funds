#!/usr/bin/env bash
echo "开始打包apk"
flutter build apk --target-platform android-arm --split-per-abi

echo "开始打包ipa"
flutter build ios --release #--no-codesign

if [ -d build/ios/iphoneos/Runner.app ]
    then

    cd build/ios/iphoneos
    mkdir Payload

    cp -r build/ios/iphoneos/Runner.app Payload

    cp -r Runner.app Payload
#    zip -r -m funds-ios-$(date "+%Y%m%d%H%M").ipa Payload
    zip -r -m funds-ios.ipa Payload

    echo "打包很顺利😄"
else
    echo "ios打包报错了😭, 打开Xcode查找错误原因"
fi

sleep 1m
mv ./build/ios/iphoneos/funds-ios.ipa ./publish/funds-ios.ipa
mv ./build/app/outputs/apk/release/app-armeabi-v7a-release.apk ./publish/app-armeabi-v7a-release.apk