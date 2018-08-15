Pod::Spec.new do |s|

  s.name             = 'IBMWatsonVisualRecognitionV3'
  s.version          = '0.31.0'
  s.summary          = 'Client framework for the IBM Watson Visual Recognition service'
  s.description      = <<-DESC
Quickly and accurately tag, classify and train visual content using machine learning.
                       DESC
  s.homepage         = 'https://www.ibm.com/watson/services/visual-recognition/'
  s.license          = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.authors          = { 'Anthony Oliveri' => 'oliveri@us.ibm.com',
                         'Mike Kistler'    => 'mkistler@us.ibm.com' }

  s.module_name      = 'VisualRecognition'
  s.ios.deployment_target = '8.0'

  s.source           = { :git => 'https://github.com/watson-developer-cloud/swift-sdk.git', :tag => s.version.to_s }
  s.source_files = 'Source/VisualRecognitionV3/**/*.swift'
  
end
