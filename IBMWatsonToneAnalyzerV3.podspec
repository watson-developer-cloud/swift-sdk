Pod::Spec.new do |s|
  
  s.name             = 'IBMWatsonToneAnalyzerV3'
  s.version          = '0.32.0'
  s.summary          = 'Client framework for the IBM Watson Tone Analyzer service'
  s.description      = <<-DESC
Understand emotions and communication style in text.
                       DESC
  s.homepage         = 'https://www.ibm.com/watson/services/tone-analyzer/'
  s.license          = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.authors          = { 'Anthony Oliveri' => 'oliveri@us.ibm.com',
                         'Mike Kistler'    => 'mkistler@us.ibm.com' }

  s.module_name      = 'ToneAnalyzer'
  s.ios.deployment_target = '8.0'

  s.source           = { :git => 'https://github.com/watson-developer-cloud/swift-sdk.git', :tag => s.version.to_s }
  s.source_files = 'Source/ToneAnalyzerV3/**/*.swift'

end
