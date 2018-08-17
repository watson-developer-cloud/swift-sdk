Pod::Spec.new do |s|

  s.name                  = 'IBMWatsonTextToSpeechV1'
  s.version               = '0.32.0'
  s.summary               = 'Client framework for the IBM Watson Text to Speech service'
  s.description           = <<-DESC
Convert written text into natural-sounding audio in a variety of languages and voices.
                            DESC
  s.homepage              = 'https://www.ibm.com/watson/services/text-to-speech/'
  s.license               = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.authors               = { 'Anthony Oliveri' => 'oliveri@us.ibm.com',
                              'Mike Kistler'    => 'mkistler@us.ibm.com' }

  s.module_name           = 'TextToSpeech'
  s.ios.deployment_target = '8.0'

  s.source                = { :git => 'https://github.com/watson-developer-cloud/swift-sdk.git', :tag => 'v#{s.version.to_s}' }
  s.source_files          = 'Source/TextToSpeechv1/**/*.swift',
                            'Source/SupportingFiles/Dependencies/**/*.{c,h}',
                            'Source/SupportingFiles/TextToSpeechv1.h'
  s.exclude_files         = 'Source/SupportingFiles/Dependencies/ogg/config_types.h'

  s.vendored_libraries    = 'Source/SupportingFiles/Dependencies/lib/*.a'
  s.public_header_files   = 'Source/SupportingFiles/TextToSpeechv1.h', 
                            'Source/SupportingFiles/Dependencies/**/*.h'

end
