Pod::Spec.new do |s|

  s.name                  = 'IBMWatsonAssistantV1'
  s.version               = '3.0.0'
  s.summary               = 'Client framework for the IBM Watson Assistant service'
  s.description           = <<-DESC
With the IBM Watson™ Assistant service, you can build a solution that understands
natural-language input and uses machine learning to respond to customers in a way that simulates a conversation between humans.
                            DESC
  s.homepage              = 'https://www.ibm.com/watson/ai-assistant/'
  s.license               = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.authors               = { 'Jeff Arn' => 'jtarn@us.ibm.com',
                              'Mike Kistler'    => 'mkistler@us.ibm.com' }

  s.module_name           = 'Assistant'
  s.ios.deployment_target = '10.0'
  s.source                = { :git => 'https://github.com/watson-developer-cloud/swift-sdk.git', :tag => s.version.to_s }

  s.source_files          = 'Source/AssistantV1/**/*.swift',
                            'Source/SupportingFiles/InsecureConnection.swift',
                            'Source/SupportingFiles/Shared.swift'
  s.exclude_files         = 'Source/AssistantV1/Shared.swift'

  s.swift_version         = ['4.2', '5.0', '5.1']
  s.dependency              'IBMSwiftSDKCore', '~> 1.0.0'

end
