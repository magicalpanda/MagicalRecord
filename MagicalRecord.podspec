Pod::Spec.new do |s|
  s.name     = 'MagicalRecord'
  s.version  = "3.0.0.dev.#{Time.now.to_i}"
  s.license  = { :type => 'MIT', :file => 'LICENSE' }
  s.summary  = 'Super Awesome Easy Fetching for Core Data 1!!!11!!!!1!.'
  s.homepage = 'http://github.com/magicalpanda/MagicalRecord'
  s.authors  = { 'Saul Mora' => 'saul@magicalpanda.com', 'Tony Arnold' => 'tony@thecocoabots.com' }
  s.source   = { :git => 'https://github.com/magicalpanda/MagicalRecord.git', :branch => 'release/3.0' }
  s.description  = 'Handy fetching, threading and data import helpers to make Core Data a little easier to use.'
  s.requires_arc = true
  s.default_subspec = 'Core'
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.subspec "Core" do |sp|
    sp.framework    = 'CoreData'
    sp.header_dir   = 'MagicalRecord'
    sp.source_files = 'Library/**/*.{h,m}'
    sp.prefix_header_contents = <<-EOS
#import <CoreData/CoreData.h>
#import <MagicalRecord/MagicalRecord.h>
EOS
  end

  s.subspec 'CocoaLumberjack' do |sp|
    sp.dependency 'CocoaLumberjack', '~> 2.0'
    sp.dependency 'MagicalRecord/Core'
  end

end
