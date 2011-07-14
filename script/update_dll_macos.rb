#!/usr/bin/env ruby
require 'fileutils'

deployment_build_path = "/tmp/GoIO_DLL.dst@executable_path"
artifact_path = File.expand_path('../../dll/macosx',  __FILE__)
dylib_name = 'libGoIO_DLL.dylib'

deployment_build = "#{deployment_build_path}/#{dylib_name}"

unless File.exists?(deployment_build)
  raise <<-HEREDOC

*** file #{deployment_build} does not exist
*** run: script/xcodebuild.rb first"

  HEREDOC
end

architectures = %w{ppc7400 i386 x86_64}

architectures.each do |arch|
  FileUtils.mkdir_p("artifact_path/#{arch}")
end
FileUtils.cp(Dir["#{deployment_build_path}/libGoIO_DLL.*"], artifact_path)

puts
architectures.each do |arch|
  cmd = "lipo -extract #{arch} #{deployment_build} -output #{artifact_path}/#{arch}/#{dylib_name}"
  puts cmd
  system(cmd)
end

cmd = "find #{artifact_path} -name *.dylib | xargs ls -lh "
puts cmd
puts
puts system(cmd)