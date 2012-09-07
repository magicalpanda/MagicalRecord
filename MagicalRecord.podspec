Pod::Spec.new do |s|
  s.name     = 'MagicalRecord'
  s.version  = '2.0'
  s.license  = 'MIT'
  s.summary  = 'Super Awesome Easy Fetching for Core Data 1!!!11!!!!1! '
  s.homepage = 'http://github.com/magicalpanda/MagicalRecord'
  s.author   = { 'Saul Mora' => 'saul@magicalpanda.com' }
  s.source   = { :git => 'http://github.com/blackgold9/MagicalRecord.git', :commit =>'6a45944c0fecbe6d93d3d6febaacab1bbecda71c' }
  s.description  = 'Handy fetching, threading and data import helpers to make Core Data a little easier to use.'
  s.source_files = 'MagicalRecord/**/*.{h,m}'
  s.framework    = 'CoreData'

  def s.post_install(target)
    prefix_header = config.project_pods_root + target.prefix_header_filename
    prefix_header.open('a') do |file|
      file.puts(%{#ifdef __OBJC__\n#define MR_SHORTHAND\n#import "CoreData+MagicalRecord.h"\n#endif})
    end
  end
end
