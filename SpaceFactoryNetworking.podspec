Pod::Spec.new do |s|

  s.name         = "SpaceFactoryNetworking"
  s.version      = "0.0.1"
  s.summary      = "A networking library on top of NSURLSession"

  s.description  = <<-DESC
                   A networking library on top of NSURLSession
                   DESC

  s.homepage     = "https://github.com/daltonclaybrook/SpaceFactoryNetworking"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Dalton Claybrook" => "daltonclaybrook@gmail.com" }
  s.social_media_url   = "http://twitter.com/daltonclaybrook"

  s.platform     = :ios
  s.ios.deployment_target = "7.0"
  s.source       = { :git => "https://github.com/daltonclaybrook/SpaceFactoryNetworking.git", :tag => s.version.to_s }

  s.source_files  = "SpaceFactoryNetworking/Core/**/*.{h,m}"
  s.public_header_files = "SpaceFactoryNetworking/Core/Public Headers/**/*.h"
  s.requires_arc = true

end
