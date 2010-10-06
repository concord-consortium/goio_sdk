#!/usr/bin/env ruby
require 'fileutils'

deployment_build_path = File.expand_path('../../src/GoIO_DLL/Win32/Release',  __FILE__)
artifact_copy_path = File.expand_path('../windows2',  __FILE__)
artifact_path = File.expand_path('../windows',  __FILE__)
dylib_name = 'GoIO_DLL'

# delete and populate a tempoorary directory
`rm -rf #{artifact_copy_path}`
%w{x86 x64}.each do |arch|
  `mkdir -p #{artifact_copy_path}/#{arch}`
end

%w{x86 x64}.each do |arch|
  %w{dll lib}.each do |kind|
    `cp #{deployment_build_path}/#{arch}/#{dylib_name}.#{kind} #{artifact_copy_path}/#{arch}`
  end
end

# replace the original windows artifact dir with the temporary dir
`rm -rf #{artifact_path}`
`mv #{artifact_copy_path} #{artifact_path}`
