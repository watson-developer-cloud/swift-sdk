Pod::Spec.new do |s|

  s.name                  = 'IBMWatsonTextToSpeechV1'
  s.version               = '0.33.0'
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
  s.source                = { :git => 'https://github.com/watson-developer-cloud/swift-sdk.git', :tag => "v#{s.version.to_s}" }

  s.source_files          = 'Source/TextToSpeechV1/**/*.swift',
                            'Source/SupportingFiles/Dependencies/Source/**/*'
  s.exclude_files         = '**/config_types.h'

  s.dependency              'IBMWatsonRestKit', '1.0.0'
  s.vendored_libraries    = 'Source/SupportingFiles/Dependencies/Libraries/*.a'

  s.prepare_command = <<-CMD
                        cd Source/SupportingFiles/Dependencies/Libraries
                        mv libogg.a libogg_tts.a
                        mv libopus.a libopus_tts.a
                        cd ../Source
                        mv ogg/* .
                        mv opus/* .
                        rm -rf ogg
                        rm -rf opus
                      CMD

end
