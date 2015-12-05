Pod::Spec.new do |s|
  s.name = 'Watson-iOS-SDK'
  s.version = '0.0.1'
  s.license = 'Apache-2.0'
  s.summary = 'IBM Watson cognitive service mobile SDK'
  s.homepage = 'https://github.com/IBM-MIL/Watson-iOS-SDK'
  s.social_media_url = 'https://twitter.com/IBM_MIL'
  s.authors = { 'IBM Mobile Innovation Lab' => 'mil-austin@us.ibm.com' }
  s.source = { :git => 'https://github.com/IBM-MIL/Watson-iOS-SDK', :tag => s.version }

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.9'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.source_files = 'WatsonSDK/*.swift'

  s.requires_arc = true
end
