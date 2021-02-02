Pod::Spec.new do |s|

  s.name                  = 'IBMWatsonPersonalityInsightsV3'
  s.version               = '4.1.0'
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

  s.source_files          = 'Sources/PersonalityInsightsV3/**/*.swift',
                            'Sources/SupportingFiles/InsecureConnection.swift',
                            'Sources/SupportingFiles/Shared.swift'
  s.exclude_files         = 'Sources/PersonalityInsightsV3/Shared.swift',
                            'Sources/PersonalityInsightsV3/InsecureConnection.swift'

  s.swift_version         = ['4.2', '5.0', '5.1']
  s.dependency              'IBMSwiftSDKCore', '~> 1.0.0'

end
