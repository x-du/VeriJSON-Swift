Pod::Spec.new do |s|
  s.name         = "VeriJSON-Swift"
  s.version      = "0.1.0"
  s.summary      = "A Swift library for verifying JSON against pattern-based rules."
  s.homepage     = "https://github.com/x-du/VeriJSON-Swift"
  s.social_media_url = 'http://twitter.com/xcdu'
  s.license      = "Apache"
  s.author       = { "Xiaochen Du" => "duxiaochen@yahoo.com" }
  s.source       = { :git => "https://github.com/x-du/VeriJSON-Swift", :revision => "0.1.0" }
  s.ios.deployment_target = "7.0"
  s.osx.deployment_target = "10.9"
  s.source_files = "VeriJSON/*.swift"
  s.requires_arc = true
end
