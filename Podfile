source "https://github.com/CocoaPods/Specs.git"

platform :ios, '13.0'

use_frameworks!
inhibit_all_warnings!

def pods
	pod 'Kanna', '~> 5'
	pod 'Kingfisher', '~> 6'
	pod 'SnapKit', '~> 5'
end

target 'menuol' do
	pods
end

target 'unittests' do
	pods
end

post_install do |installer|
	installer.pods_project.targets.each do |target|
		target.build_configurations.each do |config|
			if config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"].to_f < 9.0
				config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "9.0"
			end
		end
	end
end
