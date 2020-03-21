# frozen_string_literal: true

require 'mkmf'

dir_config('digest/base32')

raise 'Could not find base32.h' unless find_header 'base32.h', __dir__

create_makefile('digest/base32_ext')
