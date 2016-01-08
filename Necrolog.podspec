Pod::Spec.new do |s|
  s.name         = "Necrolog"
  s.version      = "0.9.0"
  s.license      = "Beerware"
  s.summary      = "Simple Swift debug log library for iOS."
  s.homepage     = "https://github.com/kubbing/Necrolog"
  s.author             = { "Jakub Hladík" => "kubbing@me.com" }
  s.social_media_url   = "http://twitter.com/ku33ing"

  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/kubbing/Necrolog/Necrolog.podspec", :tag => "0.9.0" }
  s.source_files = 'Necrolog/*.swift'
end
