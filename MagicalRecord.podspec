Pod::Spec.new do |s|
  s.name     = 'MagicalRecord'
  s.version  = '2.2'
  s.license  = 'MIT'
  s.summary  = 'Super Awesome Easy Fetching for Core Data 1!!!11!!!!1!.'
  s.homepage = 'http://github.com/magicalpanda/MagicalRecord'
  s.author   = { 'Saul Mora' => 'saul@magicalpanda.com' }
  s.source   = { :git => 'https://github.com/joergsimon/MagicalRecord.git',:branch=>'2_FIX_merge_only_paralell_contexts_in_default'}
  s.description  = 'Handy fetching, threading and data import helpers to make Core Data a little easier to use.'
  s.source_files = 'MagicalRecord/**/*.{h,m}'
  s.framework    = 'CoreData'
  s.requires_arc = true
  s.prefix_header_contents = <<-EOS
#ifdef __OBJC__
#define MR_SHORTHAND
#define MR_ENABLE_ACTIVE_RECORD_LOGGING 0
#import "CoreData+MagicalRecord.h"
#endif
EOS
end