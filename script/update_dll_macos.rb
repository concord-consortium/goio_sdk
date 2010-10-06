#!/usr/bin/env ruby
require 'fileutils'

deployment_build_path = File.expand_path('../../src/GoIO_DLL/MacOSX/build/Deployment',  __FILE__)
artifact_path = File.expand_path('../../dll/macosx',  __FILE__)
dylib_name = 'libGoIO_DLL.dylib'

architectures = %w{ppc7400 i386 x86_64}

architectures.each do |arch|
  FileUtils.mkdir_p("artifact_path/#{arch}")
end
FileUtils.cp(Dir["#{deployment_build_path}/libGoIO_DLL.*"], artifact_path)

architectures.each do |arch|
  system("lipo -extract #{arch} #{deployment_build_path}/#{dylib_name} -output #{artifact_path}/#{arch}/#{dylib_name}")
end
