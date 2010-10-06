#!/usr/bin/env ruby
require 'fileutils'

goio_dll_include_path = File.expand_path('../../src/GoIO_DLL',  __FILE__)
goio_cpp_include_path = File.expand_path('../../src/GoIO_cpp',  __FILE__)
include_path = File.expand_path('../../dll/include',  __FILE__)

FileUtils.mkdir_p(include_path)
FileUtils.cp(Dir["#{goio_dll_include_path}/*.h"], include_path)
