# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

use_frameworks!

def sharedPods 
  pod 'Moya'
  pod 'ObjectMapper', '~> 2.2.8'
  pod 'KeychainSwift'
end

target 'MatchPoint' do
  sharedPods
  pod 'SVProgressHUD'

  target 'MatchPointTests' do
    inherit! :search_paths
    # Pods for testing
  end
end

target 'MatchPointWidget' do
  sharedPods
end
