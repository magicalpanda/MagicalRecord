Pod::Spec.new do |s|
  s.default_subspec = 'Core'
  s.name     = 'MagicalRecord'
  s.version  = '2.4.0'
  s.license  = 'MIT'
  s.summary  = 'Super Awesome Easy Fetching for Core Data!'
  s.homepage = 'https://github.com/magicalpanda/MagicalRecord'
  s.author   = { 'Saul Mora' => 'saul@magicalpanda.com', 'Tony Arnold' => 'tony@thecocoabots.com' }
  s.source   = { :git => 'https://github.com/magicalpanda/MagicalRecord.git', :tag => "v#{s.version}" }
  s.description  = 'Handy fetching, threading and data import helpers to make Core Data a little easier to use.'
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.8'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.subspec 'Core' do |sp|
    sp.framework    = 'CoreData'
    sp.header_dir   = 'MagicalRecord'
    sp.source_files = 'MagicalRecord/**/*.{h,m}'
    sp.exclude_files = '**/MagicalRecordShorthandMethodAliases.h'
    sp.prefix_header_contents = <<-EOS
    #import <CoreData/CoreData.h>
    #import <MagicalRecord/MagicalRecord.h>
    EOS
  end

  s.subspec 'ShorthandMethodAliases' do |sp|
    sp.source_files = '**/MagicalRecordShorthandMethodAliases.h'
  end

  s.subspec 'CocoaLumberjack' do |sp|
    sp.dependency 'CocoaLumberjack', '~> 3.0'
    sp.dependency 'MagicalRecord/Core'
  end

end
