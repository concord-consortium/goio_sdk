#!/usr/bin/env ruby
require 'fileutils'

deployment_build_path = File.expand_path('../../src/GoIO_DLL/MacOSX/build/Deployment',  __FILE__)
artifact_copy_path = File.expand_path('../macosx2',  __FILE__)
artifact_path = File.expand_path('../macosx',  __FILE__)
dylib_name = 'libGoIO_DLL.dylib'

# delete an populate a tempoorary directory
`rm -rf #{artifact_copy_path}`
%w{ppc7400 i386 x86_64}.each do |arch|
  `mkdir -p #{artifact_copy_path}/#{arch}`
end
`cp #{deployment_build_path}/libGoIO_DLL.* #{artifact_copy_path}`

%w{ppc7400 i386 x86_64}.each do |arch|
  `lipo -extract #{arch} #{deployment_build_path}/#{dylib_name} -output #{artifact_copy_path}/#{dylib_name}`
end

# replace the original macosx artifact dir with the temporary dir
`rm -rf #{artifact_path}`
`mv #{artifact_copy_path} #{artifact_path}`
