Pod::Spec.new do |s|

  s.name                  = 'IBMWatsonConversationV1'
  s.version               = '0.35.0'
  s.summary               = 'Client framework for the IBM Watson Conversation service'
  s.description           = <<-DESC
With the IBM Watson™ Assistant service, you can build a solution that understands 
natural-language input and uses machine learning to respond to customers in a way that simulates a conversation between humans.
IMPORTANT: The Conversation service is deprecated, and will be removed in the near future.
                            DESC
  s.homepage              = 'https://www.ibm.com/watson/ai-assistant/'
  s.license               = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.authors               = { 'Anthony Oliveri' => 'oliveri@us.ibm.com',
                              'Mike Kistler'    => 'mkistler@us.ibm.com' }

  s.module_name           = 'Conversation'
  s.ios.deployment_target = '8.0'
  s.source                = { :git => 'https://github.com/watson-developer-cloud/swift-sdk.git', :tag => s.version.to_s }
  
  s.source_files          = 'Source/ConversationV1/**/*.swift',
                            'Source/SupportingFiles/Shared.swift'
  s.exclude_files         = 'Source/ConversationV1/Shared.swift'

  s.dependency              'IBMWatsonRestKit', '1.2.0'
  
end
