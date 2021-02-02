Pod::Spec.new do |s|

  s.name                  = 'IBMWatsonTextToSpeechV1'
  s.version               = '4.1.0'
  s.summary               = 'Client framework for the IBM Watson Text to Speech service'
  s.description           = <<-DESC
IBM® Text to Speech uses IBM's speech-synthesis capabilities to convert written text to natural-sounding speech.
The service streams the results back to the client with minimal delay.
                            DESC
  s.homepage              = 'https://www.ibm.com/watson/services/text-to-speech/'
  s.license               = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.authors               = { 'Jeff Arn' => 'jtarn@us.ibm.com',
                              'Mike Kistler'    => 'mkistler@us.ibm.com' }

  s.module_name           = 'TextToSpeech'
  s.ios.deployment_target = '10.0'
  s.source                = { :git => 'https://github.com/watson-developer-cloud/swift-sdk.git', :tag => "v#{s.version}" }

  s.source_files          = 'Sources/TextToSpeechV1/**/*.swift',
                            'Sources/SupportingFiles/InsecureConnection.swift',
                            'Sources/SupportingFiles/Shared.swift',
                            'Sources/SupportingFiles/Dependencies/Source/**/*'
  s.exclude_files         = 'Sources/TextToSpeechV1/Shared.swift',
                            'Sources/TextToSpeechV1/InsecureConnection.swift',
                            '**/config_types.h'

  s.swift_version         = ['4.2', '5.0', '5.1']
  s.dependency              'IBMSwiftSDKCore', '~> 1.0.0'
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
  # in case SpeechToText is being installed in the same app (which also includes libogg and libopus)
  # The ogg/ and opus/ files are flattened to the same directory so that all #include statements work
  s.prepare_command = <<-CMD
                        cd Sources/SupportingFiles/Dependencies/Libraries
                        mv libogg.a libogg_tts.a
                        mv libopus.a libopus_tts.a
                        cd ../Source
                        mv ogg/* .
                        mv opus/* .
                        rm -rf ogg
                        rm -rf opus
                      CMD

end
