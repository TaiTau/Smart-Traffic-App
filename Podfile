# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
source "https://github.com/vtmaps/pod_control.git"
target 'Smart Traffic' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for English
pod 'TCPClient'
  pod 'ViettelMapSDK', '~> 1.0.3'
  pod 'ViettelMapGeocoder', '~> 1.0.19'
  pod 'ViettelMapDirections', '~> 1.0.3'
  pod 'Polyline',:git =>    'https://github.com/raphaelmor/Polyline.git', :tag =>   'v4.2.1'

  post_install do |installer|
    installer.generated_projects.each do |project|
      project.targets.each do |target|
        target.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
        end
      end
    end
  end
end
