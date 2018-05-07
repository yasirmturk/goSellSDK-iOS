Pod::Spec.new do |goSellSDK|
    
    goSellSDK.platform = :ios
    goSellSDK.ios.deployment_target = '8.0'
    goSellSDK.swift_version = '4.1'
    goSellSDK.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.1' }
    goSellSDK.name = 'goSellSDK'
    goSellSDK.summary = 'goSell SDK for iOS'
    goSellSDK.requires_arc = true
    goSellSDK.version = '2.0'
    goSellSDK.license = { :type => 'MIT', :file => 'LICENSE' }
    goSellSDK.author = { 'Tap Payments' => 'hello@tap.company' }
    goSellSDK.homepage = 'https://github.com/Tap-Payments/goSellSDK-iOS'
    goSellSDK.source = { :git => 'https://github.com/Tap-Payments/goSellSDK-iOS.git', :tag => goSellSDK.version.to_s }
    goSellSDK.source_files = 'goSellSDK/**/*.{swift}'
    goSellSDK.ios.resource_bundle = { 'goSellSDKResources' => 'goSellSDK/Resources/*.{xcassets,storyboard,xib}' }
    
    goSellSDK.dependency 'EditableTextInsetsTextField'
    goSellSDK.dependency 'TapAdditionsKit/Foundation/Bundle'
    goSellSDK.dependency 'TapAdditionsKit/Foundation/Locale'
    goSellSDK.dependency 'TapAdditionsKit/SwiftStandartLibrary/Dictionary'
    goSellSDK.dependency 'TapAdditionsKit/SwiftStandartLibrary/OptionSet'
    goSellSDK.dependency 'TapAdditionsKit/SwiftStandartLibrary/String'
    goSellSDK.dependency 'TapAdditionsKit/UIKit/UIResponder'
    goSellSDK.dependency 'TapAdditionsKit/UIKit/UIScreen'
    goSellSDK.dependency 'TapAdditionsKit/UIKit/UIView'
    goSellSDK.dependency 'TapApplication'
    goSellSDK.dependency 'TapCardValidator'
    goSellSDK.dependency 'TapEditableView'
    goSellSDK.dependency 'TapGLKit/TapActivityIndicatorView'
    goSellSDK.dependency 'TapNetworkManager/Core'
    goSellSDK.dependency 'TapNetworkManager/ImageLoading'
    goSellSDK.dependency 'TapNibView'
    goSellSDK.dependency 'TapResponderChainInputView'
    goSellSDK.dependency 'TapSwiftFixes/Threading'
    goSellSDK.dependency 'TapVisualEffectView'
    
end