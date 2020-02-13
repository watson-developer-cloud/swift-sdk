Pod::Spec.new do |s|

  s.name                  = 'IBMWatsonCompareComplyV1'
  s.version               = '3.3.0'
  s.summary               = 'Client framework for the IBM Watson Compare & Comply service'
  s.description           = <<-DESC
IBM Watson™ Compare and Comply analyzes governing documents to provide details about critical aspects of the documents.
                            DESC
  s.homepage              = 'https://www.ibm.com/cloud/compare-and-comply'
  s.license               = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.authors               = { 'Jeff Arn' => 'jtarn@us.ibm.com',
                              'Mike Kistler'    => 'mkistler@us.ibm.com' }

  s.module_name           = 'CompareComply'
  s.ios.deployment_target = '10.0'
  s.source                = { :git => 'https://github.com/watson-developer-cloud/swift-sdk.git', :tag => "v#{s.version}" }

  s.source_files          = 'Source/CompareComplyV1/**/*.swift',
                            'Source/SupportingFiles/InsecureConnection.swift',
                            'Source/SupportingFiles/Shared.swift'
  s.exclude_files         = 'Source/CompareComplyV1/Shared.swift'

  s.swift_version         = ['4.2', '5.0', '5.1']
  s.dependency              'IBMSwiftSDKCore', '~> 1.0.0'

end
