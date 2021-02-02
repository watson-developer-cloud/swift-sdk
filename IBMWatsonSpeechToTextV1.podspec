Pod::Spec.new do |s|

  s.name                  = 'IBMWatsonSpeechToTextV1'
  s.version               = '4.1.0'
  s.summary               = 'Client framework for the IBM Watson Speech to Text service'
  s.description           = <<-DESC
The IBM® Speech to Text leverages machine intelligence to transcribe the human voice accurately.
The service combines information about grammar and language structure with knowledge of the composition
of the audio signal. It continuously returns and retroactively updates a transcription as more speech is heard.
                            DESC
  s.homepage              = 'https://www.ibm.com/watson/services/speech-to-text/'
  s.license               = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.authors               = { 'Jeff Arn' => 'jtarn@us.ibm.com',
                              'Mike Kistler'    => 'mkistler@us.ibm.com' }

  s.module_name           = 'SpeechToText'
  s.ios.deployment_target = '10.0'
  s.source                = { :git => 'https://github.com/watson-developer-cloud/swift-sdk.git', :tag => "v#{s.version}" }

  s.source_files          = 'Sources/SpeechToTextV1/**/*.swift',
                            'Sources/SupportingFiles/InsecureConnection.swift',
                            'Sources/SupportingFiles/Shared.swift',
                            'Sources/SupportingFiles/Dependencies/Source/**/*'
  s.exclude_files         = 'Sources/SpeechToTextV1/Shared.swift',
                            'Sources/SpeechToTextV1/InsecureConnection.swift',
                            '**/config_types.h',
                            '**/opus_header.h',
                            '**/opus_header.c'

  s.swift_version         = ['4.2', '5.0', '5.1']
  s.dependency              'IBMSwiftSDKCore', '~> 1.0.0'
  s.dependency              'Starscream', '~> 4.0.0'
  s.vendored_libraries    = 'Sources/SupportingFiles/Dependencies/Libraries/*.a'

  # This is necessary for the time being as we do not support the
  # XCFramework binary solution that can be bundled for all
  # architectures (thus supporting Apple Silicon)
  s.pod_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
  }
  s.user_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
  }

  # The renaming of libogg.a and libopus.a is done to avoid duplicate library name errors
  # in case TextToSpeech is being installed in the same app (which also includes libogg and libopus)
  # The ogg/ and opus/ files are flattened to the same directory so that all #include statements work
  s.prepare_command = <<-CMD
                        cd Sources/SupportingFiles/Dependencies/Libraries
                        mv libogg.a libogg_stt.a
                        mv libopus.a libopus_stt.a
                        cd ../Source
                        mv ogg/* .
                        mv opus/* .
                        rm -rf ogg
                        rm -rf opus
                      CMD

end
