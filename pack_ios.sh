#!/usr/bin/env bash
echo "开始打包ipa"
flutter build ios --release #--no-codesign

if [ -d build/ios/iphoneos/Runner.app ]
    then

    cd build/ios/iphoneos
    mkdir Payload

    cp -r build/ios/iphoneos/Runner.app Payload

    cp -r Runner.app Payload
    zip -r -m funds-ios-$(date "+%Y%m%d%H%M").ipa Payload

    echo "打包很顺利😄"
else
    echo "遇到报错了😭, 打开Xcode查找错误原因"
fi
