Pod::Spec.new do |s|

  s.name                  = 'IBMWatsonLanguageTranslatorV3'
  s.version               = '3.3.0'
  s.summary               = 'Client framework for the IBM Watson Language Translator service'
  s.description           = <<-DESC
IBM Watson™ Language Translator can identify the language of text and translate it into different languages programmatically.
                            DESC
  s.homepage              = 'https://www.ibm.com/cloud/watson-language-translator'
  s.license               = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.authors               = { 'Jeff Arn' => 'jtarn@us.ibm.com',
                              'Mike Kistler'    => 'mkistler@us.ibm.com' }

  s.module_name           = 'LanguageTranslator'
  s.ios.deployment_target = '10.0'
  s.source                = { :git => 'https://github.com/watson-developer-cloud/swift-sdk.git', :tag => "v#{s.version}" }

  s.source_files          = 'Source/LanguageTranslatorV3/**/*.swift',
                            'Source/SupportingFiles/InsecureConnection.swift',
                            'Source/SupportingFiles/Shared.swift'
  s.exclude_files         = 'Source/LanguageTranslatorV3/Shared.swift'

  s.swift_version         = ['4.2', '5.0', '5.1']
  s.dependency              'IBMSwiftSDKCore', '~> 1.0.0'

end
