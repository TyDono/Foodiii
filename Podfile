# Uncomment the next line to define a global platform for your project
# platform :ios, '14..0'
use_frameworks!

target 'Foodiii' do
    pod 'Firebase/Analytics'
    pod 'Firebase/Auth'
    pod 'GoogleSignIn'
    pod 'Firebase/Firestore'
    pod 'Firebase/Storage'
    pod 'FirebaseFirestoreSwift'
    pod 'Firebase/Messaging'
    pod 'SDWebImageSwiftUI'
    pod 'Firebase/DynamicLinks'

    pod 'FirebaseUI/Auth'
    pod 'FirebaseUI/Google'
    pod 'FirebaseUI/Facebook'
    pod 'FirebaseUI/OAuth'
    pod 'FirebaseUI/Phone'

  target 'FoodiiiTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'FoodiiiUITests' do
    # Pods for testing
  end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end

end
