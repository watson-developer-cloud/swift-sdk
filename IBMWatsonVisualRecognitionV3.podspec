Pod::Spec.new do |s|

  s.name                  = 'IBMWatsonVisualRecognitionV3'
  s.version               = '0.35.0'
  s.summary               = 'Client framework for the IBM Watson Visual Recognition service'
  s.description           = <<-DESC
IBM Watson™ Visual Recognition uses deep learning algorithms to analyze images for 
scenes, objects, faces, and other content. The response includes keywords that provide information about the content.
                            DESC
  s.homepage              = 'https://www.ibm.com/watson/services/visual-recognition/'
  s.license               = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.authors               = { 'Anthony Oliveri' => 'oliveri@us.ibm.com',
                              'Mike Kistler'    => 'mkistler@us.ibm.com' }

  s.module_name           = 'VisualRecognition'
  s.ios.deployment_target = '8.0'
  s.source                = { :git => 'https://github.com/watson-developer-cloud/swift-sdk.git', :tag => s.version.to_s }
  
  s.source_files          = 'Source/VisualRecognitionV3/**/*.swift',
                            'Source/SupportingFiles/Shared.swift'
  s.exclude_files         = 'Source/VisualRecognitionV3/Shared.swift'

  s.dependency              'IBMWatsonRestKit', '1.2.0'
  
end
