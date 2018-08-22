Pod::Spec.new do |s|

  s.name                  = 'IBMWatsonSpeechToTextV1'
  s.version               = '0.33.0'
  s.summary               = 'Client framework for the IBM Watson Speech to Text service'
  s.description           = <<-DESC
Easily convert audio and voice into written text for quick understanding of content.
                            DESC
  s.homepage              = 'https://www.ibm.com/watson/services/speech-to-text/'
  s.license               = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.authors               = { 'Anthony Oliveri' => 'oliveri@us.ibm.com',
                              'Mike Kistler'    => 'mkistler@us.ibm.com' }

  s.module_name           = 'SpeechToText'
  s.ios.deployment_target = '8.0'
  s.source                = { :git => 'https://github.com/watson-developer-cloud/swift-sdk.git', :tag => "v#{s.version.to_s}" }
  
  s.source_files          = 'Source/SpeechToTextV1/**/*.swift',
                            'Source/SupportingFiles/Dependencies/src/**/*'
  s.exclude_files         = 'Source/SupportingFiles/Dependencies/src/config_types.h',
                            'Source/SupportingFiles/Dependencies/src/opus_header.h',
                            'Source/SupportingFiles/Dependencies/src/opus_header.c'

  s.dependency              'IBMWatsonRestKit', s.version.to_s
  s.dependency              'Starscream', '~> 3.0'
  s.vendored_libraries    = 'Source/SpeechToTextV1/Dependencies/*.a'

end
