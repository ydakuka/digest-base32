require 'mkmf'

dir_config('digest/base32')
if find_header 'base32.h', File.expand_path(File.dirname(__FILE__))
  create_makefile('digest/base32')
else
  raise "Could not find base32.h"
end
