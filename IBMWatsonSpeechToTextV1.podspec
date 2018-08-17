Pod::Spec.new do |s|

  s.name             = 'IBMWatsonSpeechToTextV1'
  s.version          = '0.32.0'
  s.summary          = 'Client framework for the IBM Watson Speech to Text service'
  s.description      = <<-DESC
Easily convert audio and voice into written text for quick understanding of content.
                       DESC
  s.homepage         = 'https://www.ibm.com/watson/services/speech-to-text/'
  s.license          = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.authors          = { 'Anthony Oliveri' => 'oliveri@us.ibm.com',
                         'Mike Kistler'    => 'mkistler@us.ibm.com' }

  s.module_name      = 'SpeechToText'
  s.ios.deployment_target = '8.0'

  s.source           = { :git => 'https://github.com/watson-developer-cloud/swift-sdk.git', :tag => 'v#{s.version.to_s}' }
  s.source_files          = 'Source/SpeechToTextV1/**/*.swift',
                            'Source/SupportingFiles/Dependencies/**/*.{c,h}',
                            'Source/SupportingFiles/SpeechToTextV1.h'
  s.exclude_files         = 'Source/SupportingFiles/Dependencies/ogg/config_types.h',
                            'Source/SupportingFiles/Dependencies/opus/opus_header.{h,c}'

  s.dependency              'Starscream', '~> 3.0'
  s.vendored_libraries    = 'Source/SupportingFiles/Dependencies/lib/*.a'
  s.public_header_files   = 'Source/SupportingFiles/SpeechToTextV1.h', 
                            'Source/SupportingFiles/Dependencies/**/*.h'

end
