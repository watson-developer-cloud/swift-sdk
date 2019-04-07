Pod::Spec.new do |s|

  s.name                  = 'IBMWatsonPersonalityInsightsV3'
  s.version               = '2.0.1'
  s.summary               = 'Client framework for the IBM Watson Personality Insights service'
  s.description           = <<-DESC
IBM Watson™ Personality Insights uses linguistic analytics to infer individuals' intrinsic personality characteristics
from digital communications such as email, text messages, tweets, and forum posts.
                            DESC
  s.homepage              = 'https://www.ibm.com/watson/services/personality-insights/'
  s.license               = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.authors               = { 'Anthony Oliveri' => 'oliveri@us.ibm.com',
                              'Mike Kistler'    => 'mkistler@us.ibm.com' }

  s.module_name           = 'PersonalityInsights'
  s.ios.deployment_target = '10.0'
  s.source                = { :git => 'https://github.com/watson-developer-cloud/swift-sdk.git', :tag => s.version.to_s }

  s.source_files          = 'Source/PersonalityInsightsV3/**/*.swift',
                            'Source/SupportingFiles/Shared.swift'
  s.exclude_files         = 'Source/PersonalityInsightsV3/Shared.swift'

  s.swift_version         = '4.2'
  s.dependency              'IBMWatsonRestKit', '~> 3.0.0'

end
