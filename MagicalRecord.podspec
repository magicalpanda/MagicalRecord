Pod::Spec.new do |s|
  s.name     = 'MagicalRecord'
  s.version  = '1.8'
  s.license  = 'MIT'
  s.summary  = 'Super Awesome Easy Fetching for Core Data 1!!!11!!!!1! '
  s.homepage = 'http://github.com/magicalpanda/MagicalRecord'
  s.author   = { 'Saul Mora' => 'saul@magicalpanda.com' }
  s.source   = { :git => 'http://github.com/magicalpanda/MagicalRecord.git', :tag => '1.8' }
  s.description  = 'Handy fetching, threading and data import helpers to make Core Data a little easier to use.'
  s.source_files = 'Source/**/*.{h,m}'
  s.framework    = 'CoreData'

  def s.post_install(target)
    prefix_header = config.project_pods_root + target.prefix_header_filename
    prefix_header.open('a') do |file|
      file.puts(%{#ifdef __OBJC__\n#define MR_SHORTHAND 1\n#import "CoreData+MagicalRecord.h"\n#endif})
    end
  end
end
