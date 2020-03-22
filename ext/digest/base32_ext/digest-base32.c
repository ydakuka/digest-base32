#include <stdlib.h>
#include <ruby.h>
#include <ruby/encoding.h>
#include "base32.h"
#include <ctype.h>

static VALUE mDigest;
static VALUE mDigest_cBase32;
static VALUE eDecodeError;

static VALUE
digest_base32_encode(int argc, VALUE* argv, VALUE self)
{
  VALUE input;
  const unsigned char* src;
  size_t srclen;
  rb_scan_args(argc, argv, "1", &input);

  if (TYPE(input) != T_STRING) {
    rb_raise(rb_eTypeError, "expected a String");
  }

  src = (unsigned char*) StringValuePtr(input);
  srclen = BASE32_LEN(RSTRING_LEN(input));

  unsigned char dest[srclen];
  base32_encode(src, RSTRING_LEN(input), dest);

  return rb_str_new((const char*) dest, srclen);
}

static VALUE
digest_base32_decode(int argc, VALUE *argv, VALUE self)
{
  VALUE input;
  const unsigned char* src;
  size_t estimate_len;
  rb_scan_args(argc, argv, "1", &input);

  if (TYPE(input) != T_STRING) {
    rb_raise(rb_eTypeError, "expected a String");
  }

  src = (unsigned char*) StringValuePtr(input);
  estimate_len = UNBASE32_LEN(RSTRING_LEN(input));

  unsigned char out[estimate_len];
  base32_decode(src, out);

  return rb_str_new_cstr((const char*) out);
}

void
Init_base32_ext() {
  mDigest = rb_define_module("Digest");
  mDigest_cBase32 = rb_define_class_under(mDigest, "Base32", rb_cObject);

  eDecodeError = rb_define_class_under(mDigest_cBase32, "DecodeError", rb_eStandardError);

  rb_define_module_function(mDigest_cBase32, "encode", digest_base32_encode, -1);
  rb_define_module_function(mDigest_cBase32, "decode", digest_base32_decode, -1);
}
