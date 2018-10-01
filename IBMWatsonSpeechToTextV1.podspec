Pod::Spec.new do |s|

  s.name                  = 'IBMWatsonSpeechToTextV1'
  s.version               = '0.35.0'
  s.summary               = 'Client framework for the IBM Watson Speech to Text service'
  s.description           = <<-DESC
The IBM® Speech to Text leverages machine intelligence to transcribe the human voice accurately. 
The service combines information about grammar and language structure with knowledge of the composition 
of the audio signal. It continuously returns and retroactively updates a transcription as more speech is heard.
                            DESC
  s.homepage              = 'https://www.ibm.com/watson/services/speech-to-text/'
  s.license               = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.authors               = { 'Anthony Oliveri' => 'oliveri@us.ibm.com',
                              'Mike Kistler'    => 'mkistler@us.ibm.com' }

  s.module_name           = 'SpeechToText'
  s.ios.deployment_target = '8.0'
  s.source                = { :git => 'https://github.com/watson-developer-cloud/swift-sdk.git', :tag => s.version.to_s }
  
  s.source_files          = 'Source/SpeechToTextV1/**/*.swift',
                            'Source/SupportingFiles/Shared.swift',
                            'Source/SupportingFiles/Dependencies/Source/**/*'
  s.exclude_files         = 'Source/SpeechToTextV1/Shared.swift',
                            '**/config_types.h',
                            '**/opus_header.h',
                            '**/opus_header.c'

  s.dependency              'IBMWatsonRestKit', '1.2.0'
  s.dependency              'Starscream', '~> 3.0'
  s.vendored_libraries    = 'Source/SupportingFiles/Dependencies/Libraries/*.a'

  # The renaming of libogg.a and libopus.a is done to avoid duplicate library name errors
  # in case TextToSpeech is being installed in the same app (which also includes libogg and libopus) 
  # The ogg/ and opus/ files are flattened to the same directory so that all #include statements work
  s.prepare_command = <<-CMD
                        cd Source/SupportingFiles/Dependencies/Libraries
                        mv libogg.a libogg_stt.a
                        mv libopus.a libopus_stt.a
                        cd ../Source
                        mv ogg/* .
                        mv opus/* .
                        rm -rf ogg
                        rm -rf opus
                      CMD

end
