Pod::Spec.new do |s|

  s.name                  = 'IBMWatsonPersonalityInsightsV3'
  s.version               = '3.3.0'
  s.summary               = 'Client framework for the IBM Watson Personality Insights service'
  s.description           = <<-DESC
IBM Watson™ Personality Insights uses linguistic analytics to infer individuals' intrinsic personality characteristics
from digital communications such as email, text messages, tweets, and forum posts.
                            DESC
  s.homepage              = 'https://www.ibm.com/watson/services/personality-insights/'
  s.license               = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.authors               = { 'Jeff Arn' => 'jtarn@us.ibm.com',
                              'Mike Kistler'    => 'mkistler@us.ibm.com' }

  s.module_name           = 'PersonalityInsights'
  s.ios.deployment_target = '10.0'
  s.source                = { :git => 'https://github.com/watson-developer-cloud/swift-sdk.git', :tag => "v#{s.version}" }

  s.source_files          = 'Source/PersonalityInsightsV3/**/*.swift',
                            'Source/SupportingFiles/InsecureConnection.swift',
                            'Source/SupportingFiles/Shared.swift'
  s.exclude_files         = 'Source/PersonalityInsightsV3/Shared.swift'

  s.swift_version         = ['4.2', '5.0', '5.1']
  s.dependency              'IBMSwiftSDKCore', '~> 1.0.0'

end
