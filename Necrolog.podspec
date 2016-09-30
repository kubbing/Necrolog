Pod::Spec.new do |s|
  s.name         = "Necrolog"
  s.version      = "0.9.7"
  s.license      = { :type => "Beerware", :file => 'LICENCE.txt' }
  s.summary      = "Killer Swift debug log library for iOS."
  s.homepage     = "https://github.com/kubbing/Necrolog"
  s.author             = { "Jakub Hladík" => "kubbing@me.com" }
  s.social_media_url   = "http://twitter.com/ku33ing"

  s.ios.deployment_target = "8.0"
  s.ios.framework = 'UIKit' 
  s.source       = { :git => "https://github.com/kubbing/Necrolog.git", :tag => s.version }
  s.source_files = 'Necrolog/*.swift'
  s.pod_target_xcconfig = { 'OTHER_SWIFT_FLAGS[config=Debug]' => '-DDEBUG' }
end
