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
  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.9'

  s.subspec "Core" do |sp|
    sp.framework    = 'CoreData'
    sp.header_dir   = 'MagicalRecord'
    sp.source_files = 'Library/**/*.{h,m}'
    sp.prefix_header_contents = <<-EOS
#import <CoreData/CoreData.h>
#import "MagicalRecord.h"
EOS
  end

  s.subspec "Core+Logging" do |sp|
    sp.framework    = 'CoreData'
    sp.header_dir   = 'MagicalRecord'
    sp.source_files = 'Library/**/*.{h,m}'
    sp.prefix_header_contents = <<-EOS
#import <CoreData/CoreData.h>
#if defined(COCOAPODS_POD_AVAILABLE_CocoaLumberjack)
  #import "DDLog.h"
#endif
#define MR_LOGGING_ENABLED 1
#import "MagicalRecord.h"
EOS
  end

  s.subspec "Shorthand" do |sp|
    sp.framework    = 'CoreData'
    sp.header_dir   = 'MagicalRecord'
    sp.source_files = 'Library/**/*.{h,m}'
    sp.prefix_header_contents = <<-EOS
#import <CoreData/CoreData.h>
#define MR_SHORTHAND 1
#import "MagicalRecord.h"
EOS
  end

  s.subspec "Shorthand+Logging" do |sp|
    sp.framework    = 'CoreData'
    sp.header_dir   = 'MagicalRecord'
    sp.source_files = 'Library/**/*.{h,m}'
    sp.prefix_header_contents = <<-EOS
#import <CoreData/CoreData.h>
#if defined(COCOAPODS_POD_AVAILABLE_CocoaLumberjack)
  #import "DDLog.h"
#endif
#define MR_LOGGING_ENABLED 1
#define MR_SHORTHAND 1
#import "MagicalRecord.h"
EOS
  end

end
