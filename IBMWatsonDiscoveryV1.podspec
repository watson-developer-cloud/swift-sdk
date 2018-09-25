Pod::Spec.new do |s|

  s.name                  = 'IBMWatsonDiscoveryV1'
  s.version               = '0.35.0'
  s.summary               = 'Client framework for the IBM Watson Discovery service'
  s.description           = <<-DESC
IBM Watson™ Discovery makes it possible to rapidly build cognitive, cloud-based exploration applications 
that unlock actionable insights hidden in unstructured data — including your own proprietary data, 
as well as public and third-party data.
                            DESC
  s.homepage              = 'https://www.ibm.com/watson/services/discovery/'
  s.license               = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.authors               = { 'Anthony Oliveri' => 'oliveri@us.ibm.com',
                              'Mike Kistler'    => 'mkistler@us.ibm.com' }

  s.module_name           = 'Discovery'
  s.ios.deployment_target = '8.0'
  s.source                = { :git => 'https://github.com/watson-developer-cloud/swift-sdk.git', :tag => s.version.to_s }
  
  s.source_files          = 'Source/DiscoveryV1/**/*.swift',
                            'Source/SupportingFiles/Shared.swift'
  s.exclude_files         = 'Source/DiscoveryV1/Shared.swift'

  s.dependency              'IBMWatsonRestKit', '1.2.0'
  
end
