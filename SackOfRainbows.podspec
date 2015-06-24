Pod::Spec.new do |s|
  s.name         = "SackOfRainbows"
  s.version      = "0.0.1"
  s.summary      = "A handy color generator with a fun interface."
  s.description  = <<-DESC
                   SackOfRainbows provides an expressive syntax to create color generators. Chain generators in serial or parallel to easily create gradients and complex patterns.
                   DESC
  s.homepage     = "https://github.com/sozorogami/SackOfRainbows"
  s.license      = "MIT"
  s.author             = { "Tyler Tape" => "tyler.tape@gmail.com" }
  s.social_media_url   = "http://twitter.com/sozorogami"
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/sozorogami/SackOfRainbows.git", :tag => "v#{s.version}"}
  s.source_files  = "SackOfRainbows/*.{swift,h}"
  s.public_header_files = "SackOfRainbows/*.h"
end
