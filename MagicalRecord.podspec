Pod::Spec.new do |s|
  s.name     = 'MagicalRecord'
  s.version  = '2.3.0-beta.2'
  s.license  = 'MIT'
  s.summary  = 'Super Awesome Easy Fetching for Core Data 1!!!11!!!!1!.'
  s.homepage = 'http://github.com/magicalpanda/MagicalRecord'
  s.author   = { 'Saul Mora' => 'saul@magicalpanda.com' }
  s.source   = { :git => 'https://github.com/magicalpanda/MagicalRecord.git', :tag => "v#{s.version}" }
  s.description  = 'Handy fetching, threading and data import helpers to make Core Data a little easier to use.'
  s.requires_arc = true
  s.default_subspec = 'Core'
  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.8'

  s.subspec "Core" do |sp|
    sp.framework    = 'CoreData'
    sp.source_files = 'MagicalRecord/**/*.{h,m}'
    sp.prefix_header_contents = <<-EOS
#ifdef __OBJC__
#if defined(COCOAPODS_POD_AVAILABLE_CocoaLumberjack)
  #import "DDLog.h"
#endif

#import <CoreData/CoreData.h>
#import "CoreData+MagicalRecord.h"
#endif
EOS
  end

  s.subspec "Shorthand" do |sp|
    sp.framework    = 'CoreData'
    sp.source_files = 'MagicalRecord/**/*.{h,m}'
    sp.prefix_header_contents = <<-EOS
#ifdef __OBJC__
#if defined(COCOAPODS_POD_AVAILABLE_CocoaLumberjack)
  #import "DDLog.h"
#endif

#import <CoreData/CoreData.h>
#define MR_SHORTHAND 0
#import "CoreData+MagicalRecord.h"
#endif
EOS
  end

end
