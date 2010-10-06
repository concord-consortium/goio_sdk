#!/usr/bin/env ruby
require 'fileutils'

deployment_build_path = File.expand_path('../../src/GoIO_DLL/Windows/Release',  __FILE__)
artifact_path = File.expand_path('../../dll/windows',  __FILE__)
dylib_name = 'GoIO_DLL'

# delete and populate a temporary directory
%w{x86 x64}.each do |arch|
  FileUtils.mkdir_p("#{artifact_path}/#{arch}")
end

%w{x86 x64}.each do |arch|
  FileUtils.mkdir_p("#{artifact_path}/#{arch}")
  %w{dll lib}.each do |kind|
    arch_path = "#{arch}/#{dylib_name}.#{kind}"
    src  = "#{deployment_build_path}/#{arch_path}"
    dest = "#{artifact_path}/#{arch_path}"
    FileUtils.cp(src, dest) if File.exists?(src)
  end
end
