Pod::Spec.new do |s|

  s.name             = 'IBMWatsonAssistantV1'
  s.version          = '0.31.0'
  s.summary          = 'iOS framework for the IBM Watson Assistant service'
  s.description      = <<-DESC
Build an AI assistant for a variety of channels, including mobile devices, messaging platforms, and even robots.
                       DESC
  s.homepage         = 'https://www.ibm.com/watson/ai-assistant/'
  s.license          = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.authors          = { 'Anthony Oliveri' => 'oliveri@us.ibm.com',
                         'Mike Kistler'    => 'mkistler@us.ibm.com' }

  s.module_name      = 'Assistant'
  s.ios.deployment_target = '8.0'

  s.source           = { :git => 'https://github.com/watson-developer-cloud/swift-sdk.git', :tag => s.version.to_s }
  s.source_files = 'Source/AssistantV1/**/*.swift'
  
end
