# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Rosovina' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Rosovina

  pod 'MOLH'
  pod 'BottomSheet', :git => 'https://github.com/joomcode/BottomSheet'
  pod 'CombineCocoa'
  pod 'Alamofire', '~> 5.6.4'
  pod 'IQKeyboardManagerSwift', '6.0.4'
  pod 'SDWebImage', '~> 5.0'
  pod 'SDWebImageSwiftUI'
  pod 'SDWebImageSVGCoder'
  pod 'Cosmos', '~> 20.0'
  pod 'ProgressHUD'
  pod 'Firebase/Core'
  pod 'Firebase/Storage'
  pod 'Firebase/Firestore'
  pod 'FirebaseUI/Firestore'
  pod 'Firebase/Messaging'
  pod 'GoogleMaps'
  pod 'GooglePlaces'
  pod 'SwiftyJSON', '~> 4.0'
  pod 'SwiftyCodeView'
  pod "WARangeSlider"

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
            end
        end
    end
end

end
