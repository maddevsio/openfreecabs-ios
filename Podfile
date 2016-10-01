platform :ios, '9.0'
use_frameworks!

target 'OpenFreeCabs' do
    pod 'Alamofire', '~> 4.0'
    pod 'KeychainSwift', '~> 6.0'
    pod 'MBProgressHUD', '~> 1.0.0'
    pod 'Firebase', '~> 3.6'
    pod 'FirebaseMessaging', '~> 1.2'
    pod 'FirebaseCrash', '~> 1.0'
    pod 'Kingfisher', '~> 3.0'
    pod 'GoogleMaps', '~> 2.0.1'
end


post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
