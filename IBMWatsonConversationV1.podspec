Pod::Spec.new do |s|

  s.name                  = 'IBMWatsonConversationV1'
  s.version               = '0.33.0'
  s.summary               = 'iOS framework for the IBM Watson Conversation service'
  s.description           = <<-DESC
Build an AI assistant for a variety of channels, including mobile devices, messaging platforms, and even robots.
IMPORTANT: The Conversation service is deprecated, and will be removed in the near future.
                            DESC
  s.homepage              = 'https://www.ibm.com/watson/ai-assistant/'
  s.license               = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.authors               = { 'Anthony Oliveri' => 'oliveri@us.ibm.com',
                              'Mike Kistler'    => 'mkistler@us.ibm.com' }

  s.module_name           = 'Conversation'
  s.ios.deployment_target = '8.0'
  s.source                = { :git => 'https://github.com/watson-developer-cloud/swift-sdk.git', :tag => "v#{s.version.to_s}" }
  
  s.source_files          = 'Source/ConversationV1/**/*.swift'

  s.dependency              'IBMWatsonRestKit', s.version.to_s
  
end
