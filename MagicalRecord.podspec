Pod::Spec.new do |s|
  s.name     = 'MagicalRecord'
  s.version  = '2.3.0'
  s.license  = 'MIT'
  s.summary  = 'Super Awesome Easy Fetching for Core Data 1!!!11!!!!1!.'
  s.homepage = 'http://github.com/magicalpanda/MagicalRecord'
  s.author   = { 'Saul Mora' => 'saul@magicalpanda.com', 'Tony Arnold' => 'tony@thecocoabots.com' }
  s.source   = { :git => 'https://github.com/magicalpanda/MagicalRecord.git', :tag => "v#{s.version}" }
  s.description  = 'Handy fetching, threading and data import helpers to make Core Data a little easier to use.'
  s.requires_arc = true
  s.ios.deployment_target = '6.1'
  s.osx.deployment_target = '10.8'

  s.framework    = 'CoreData'
  s.header_dir   = 'MagicalRecord'
  s.source_files = 'MagicalRecord/**/*.{h,m}'
  s.prefix_header_contents = <<-EOS
#import <CoreData/CoreData.h>
#import <MagicalRecord/MagicalRecord.h>
EOS

end
