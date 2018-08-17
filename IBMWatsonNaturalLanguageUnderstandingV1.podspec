Pod::Spec.new do |s|

  s.name             = 'IBMWatsonNaturalLanguageUnderstandingV1'
  s.version          = '0.32.0'
  s.summary          = 'Client framework for the IBM Watson Natural Language Understanding service'
  s.description      = <<-DESC
Natural language processing for advanced text analysis.
                       DESC
  s.homepage         = 'https://www.ibm.com/watson/services/natural-language-understanding/'
  s.license          = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.authors          = { 'Anthony Oliveri' => 'oliveri@us.ibm.com',
                         'Mike Kistler'    => 'mkistler@us.ibm.com' }

  s.module_name      = 'NaturalLanguageUnderstanding'
  s.ios.deployment_target = '8.0'

  s.source           = { :git => 'https://github.com/watson-developer-cloud/swift-sdk.git', :tag => s.version.to_s }
  s.source_files = 'Source/NaturalLanguageUnderstandingV1/**/*.swift'
  
end
