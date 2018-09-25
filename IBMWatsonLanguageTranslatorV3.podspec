Pod::Spec.new do |s|

  s.name                  = 'IBMWatsonLanguageTranslatorV3'
  s.version               = '0.35.0'
  s.summary               = 'Client framework for the IBM Watson Language Translator service'
  s.description           = <<-DESC
IBM Watson™ Language Translator can identify the language of text and translate it into different languages programmatically.
                            DESC
  s.homepage              = 'https://www.ibm.com/watson/services/language-translator/'
  s.license               = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.authors               = { 'Anthony Oliveri' => 'oliveri@us.ibm.com',
                              'Mike Kistler'    => 'mkistler@us.ibm.com' }

  s.module_name           = 'LanguageTranslator'
  s.ios.deployment_target = '8.0'
  s.source                = { :git => 'https://github.com/watson-developer-cloud/swift-sdk.git', :tag => s.version.to_s }

  s.source_files          = 'Source/LanguageTranslatorV3/**/*.swift',
                            'Source/SupportingFiles/Shared.swift'
  s.exclude_files         = 'Source/LanguageTranslatorV3/Shared.swift'

  s.dependency              'IBMWatsonRestKit', '1.2.0'

end
