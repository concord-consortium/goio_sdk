#!/usr/bin/env ruby
require 'fileutils'

goio_dll_include_path = File.expand_path('../src/GoIO_DLL',  __FILE__)
goio_cpp_include_path = File.expand_path('../src/GoIO_cpp',  __FILE__)
include_copy_path = File.expand_path('../../include2',  __FILE__)
include_path = File.expand_path('../../dll/include',  __FILE__)

# delete and populate a temporary directory
`rm -rf #{include_copy_path}`
`mkdir -p #{include_copy_path}`
`cp #{goio_dll_include_path}/*.h #{include_copy_path}`
# `cp #{goio_cpp_include_path}/*.h #{include_copy_path}`

# replace the original include artifact dir with the temporary dir
`rm -rf #{include_path}`
`mv #{include_copy_path} #{include_path}`
