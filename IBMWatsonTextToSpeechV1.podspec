Pod::Spec.new do |s|

  s.name                  = 'IBMWatsonTextToSpeechV1'
  s.version               = '0.35.0'
  s.summary               = 'Client framework for the IBM Watson Text to Speech service'
  s.description           = <<-DESC
IBM® Text to Speech uses IBM's speech-synthesis capabilities to convert written text to natural-sounding speech. 
The service streams the results back to the client with minimal delay.
                            DESC
  s.homepage              = 'https://www.ibm.com/watson/services/text-to-speech/'
  s.license               = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.authors               = { 'Anthony Oliveri' => 'oliveri@us.ibm.com',
                              'Mike Kistler'    => 'mkistler@us.ibm.com' }

  s.module_name           = 'TextToSpeech'
  s.ios.deployment_target = '8.0'
  s.source                = { :git => 'https://github.com/watson-developer-cloud/swift-sdk.git', :tag => s.version.to_s }

  s.source_files          = 'Source/TextToSpeechV1/**/*.swift',
                            'Source/SupportingFiles/Shared.swift',
                            'Source/SupportingFiles/Dependencies/Source/**/*'
  s.exclude_files         = 'Source/TextToSpeechV1/Shared.swift',
                            '**/config_types.h'

  s.dependency              'IBMWatsonRestKit', '1.2.0'
  s.vendored_libraries    = 'Source/SupportingFiles/Dependencies/Libraries/*.a'

  # The renaming of libogg.a and libopus.a is done to avoid duplicate library name errors
  # in case SpeechToText is being installed in the same app (which also includes libogg and libopus) 
  # The ogg/ and opus/ files are flattened to the same directory so that all #include statements work
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
