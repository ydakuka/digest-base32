Digest::Base32
==============

![Travis Build](https://travis-ci.com/ydakuka/digest-base32.svg?branch=master)

Digest::Base32 is a Ruby native extension that wraps the base32 library found
in [tpmtotop](https://github.com/mjg59/tpmtotp/blob/master/base32.h)

Usage
-----

```ruby
require 'digest/base32'

encoded = Digest::Base32.encode('My string')
decoded = Digest::Base32.decode(encoded)
```

Benchmark
---------

From Core i7 Macbook Pro (2014). Ruby 2.5.3
```
                                     user     system      total        real
     base32 pure ruby (encode)   1.348343   0.000489   1.348832 (  1.349179)
   base32 c extension (encode)   0.001638   0.000002   0.001640 (  0.001629)
     base32 pure ruby (decode)   1.334840   0.000574   1.335414 (  1.335513)
   base32 c extension (decode)   0.003613   0.000331   0.003944 (  0.003933)
```

Requirements
------------

* Ruby 2.3+
* gcc/clang

Running the test suite
----------------------

Run the test suite as follows:

```
rake test
```
