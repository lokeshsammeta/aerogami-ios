platform :ios, '11.0'
use_frameworks!
inhibit_all_warnings!

deployment_target = '11.0'

workspace 'TravelApplication.xcworkspace'

#Versions
$swinjectVersion =                    '~> 2.4'
$rxSwiftVersion =                     '~> 4.2'
$swiftDateVersion =                   '~> 5.0'
$rxAlamofireVersion =                 '~> 4.2'
$alamofireVersion =                   '~> 4.7'
$rSwiftVersion =                      '~> 4.0.0'
$snapKitVersion =                     '~> 4.0.0'
$sdWebImageVersion =                  '~> 4.0'

pod 'Sourcery',                       '~> 0.10.1'

def shared_testing_pods
    pod 'RxBlocking',                 $rSwiftVersion
end

# ############################################################
# TravelKit
# ############################################################

def shared_TravelKit_pods
    pod 'RxSwift',                    $rxSwiftVersion
    pod 'SwiftDate',                  $swiftDateVersion
end

target 'TravelKit' do
    project 'TravelKit.xcodeproj'
    platform :ios, deployment_target

    pod 'CocoaLumberjack/Swift'
    shared_TravelKit_pods

  target 'TravelKitTests' do
    project 'TravelKit.xcodeproj'
    inherit! :search_paths

    shared_testing_pods
  end
end

# #############################################################################
# TravelAPIKit
# #############################################################################

def shared_TravelAPIKit_pods
    pod 'RxSwift',                        $rxSwiftVersion
    pod 'Alamofire',                      $alamofireVersion
    pod 'RxAlamofire',                    $rxAlamofireVersion
end

target 'TravelAPIKit' do
  project 'TravelAPIKit.xcodeproj'
  platform :ios, deployment_target

  shared_TravelAPIKit_pods

  target 'TravelAPIKitTests' do
    project 'TravelAPIKit.xcodeproj'

    shared_testing_pods
  end
end

# #############################################################################
# TravelDataKit
# #############################################################################

def shared_TravelDataKit_pods
    pod 'RxSwift',                    $rxSwiftVersion
    pod 'SwiftDate',                  $swiftDateVersion
    pod 'Swinject',                   $swinjectVersion

  shared_TravelKit_pods
  shared_TravelAPIKit_pods
end

target 'TravelDataKit' do
  project 'TravelDataKit.xcodeproj'
  platform :ios, deployment_target

  shared_TravelDataKit_pods

  target 'TravelDataKitTests' do
    project 'TravelDataKit.xcodeproj'

    shared_testing_pods
    pod 'CocoaLumberjack/Swift'
  end
end

# #############################################################################
# TravelFeatureKit
# #############################################################################

def shared_TravelFeatureKit_pods
    pod 'Swinject',                   $swinjectVersion
    pod 'SnapKit',                    $snapKitVersion
    pod 'R.swift'
    pod 'SDWebImage',                 $sdWebImageVersion
    pod 'RxCocoa',                    $rxSwiftVersion

  shared_TravelDataKit_pods
end

target 'TravelFeatureKit' do
  project 'TravelFeatureKit.xcodeproj'
  platform :ios, deployment_target

  shared_TravelFeatureKit_pods
  pod 'CocoaLumberjack/Swift'

  target 'TravelFeatureKitTests' do
    project 'TravelFeatureKit.xcodeproj'
    pod 'CocoaLumberjack/Swift'
  end
end

# #############################################################################
# Application
# #############################################################################

def shared_Apps_pods
  shared_TravelFeatureKit_pods
end

target 'TravelApplication' do
    project 'TravelApplication.xcodeproj'
    platform :ios, deployment_target
    shared_Apps_pods
end

target 'TravelApplication Dev' do
    project 'TravelApplication.xcodeproj'
    platform :ios, deployment_target
    shared_Apps_pods
end

# #############################################################################
# Customisation
# #############################################################################

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'YES'

            if config.name == 'Debug'
              config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
              config.build_settings['OTHER_SWIFT_FLAGS'] = ['$(inherited)', '-Onone']
              config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Owholemodule'
              config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = 'YES'
            else
              config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf-with-dsym'
              config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Owholemodule'
            end

            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = deployment_target
        end
    end
end