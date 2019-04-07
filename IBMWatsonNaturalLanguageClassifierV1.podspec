Pod::Spec.new do |s|

  s.name                  = 'IBMWatsonNaturalLanguageClassifierV1'
  s.version               = '2.0.1'
  s.summary               = 'Client framework for the IBM Watson Natural Language Classifier service'
  s.description           = <<-DESC
Natural Language Classifier can help your application understand the language of short texts and
make predictions about how to handle them. A classifier learns from your example data and then can
return information for texts that it is not trained on.
                            DESC
  s.homepage              = 'https://www.ibm.com/watson/services/natural-language-classifier/'
  s.license               = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.authors               = { 'Anthony Oliveri' => 'oliveri@us.ibm.com',
                              'Mike Kistler'    => 'mkistler@us.ibm.com' }

  s.module_name           = 'NaturalLanguageClassifier'
  s.ios.deployment_target = '10.0'
  s.source                = { :git => 'https://github.com/watson-developer-cloud/swift-sdk.git', :tag => s.version.to_s }

  s.source_files          = 'Source/NaturalLanguageClassifierV1/**/*.swift',
                            'Source/SupportingFiles/Shared.swift'
  s.exclude_files         = 'Source/NaturalLanguageClassifierV1/Shared.swift'

  s.swift_version         = '4.2'
  s.dependency              'IBMWatsonRestKit', '~> 3.0.0'

end
