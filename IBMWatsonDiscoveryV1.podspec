Pod::Spec.new do |s|

  s.name             = 'IBMWatsonDiscoveryV1'
  s.version          = '0.32.0'
  s.summary          = 'Client framework for the IBM Watson Discovery service'
  s.description      = <<-DESC
Unlock hidden value in data to find answers, monitor trends and surface patterns 
with the world’s most advanced cloud-native insight engine.
                       DESC
  s.homepage         = 'https://www.ibm.com/watson/services/discovery/'
  s.license          = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.authors          = { 'Anthony Oliveri' => 'oliveri@us.ibm.com',
                         'Mike Kistler'    => 'mkistler@us.ibm.com' }

  s.module_name      = 'Discovery'
  s.ios.deployment_target = '8.0'

  s.source           = { :git => 'https://github.com/watson-developer-cloud/swift-sdk.git', :tag => s.version.to_s }
  s.source_files = 'Source/DiscoveryV1/**/*.swift'
  
end
