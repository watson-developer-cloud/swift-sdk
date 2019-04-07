Pod::Spec.new do |s|

  s.name                  = 'IBMWatsonCompareComplyV1'
  s.version               = '2.0.1'
  s.summary               = 'Client framework for the IBM Watson Compare & Comply service'
  s.description           = <<-DESC
IBM Watson™ Compare and Comply analyzes governing documents to provide details about critical aspects of the documents.
                            DESC
  s.homepage              = 'https://www.ibm.com/blogs/watson/2018/02/watson-compare-comply/'
  s.license               = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.authors               = { 'Anthony Oliveri' => 'oliveri@us.ibm.com' }

  s.module_name           = 'CompareComply'
  s.ios.deployment_target = '10.0'
  s.source                = { :git => 'https://github.com/watson-developer-cloud/swift-sdk.git', :tag => s.version.to_s }

  s.source_files          = 'Source/CompareComplyV1/**/*.swift',
                            'Source/SupportingFiles/Shared.swift'
  s.exclude_files         = 'Source/CompareComplyV1/Shared.swift'

  s.swift_version         = '4.2'
  s.dependency              'IBMWatsonRestKit', '~> 3.0.0'

end
