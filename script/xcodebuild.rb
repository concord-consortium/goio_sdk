#!/usr/bin/env ruby
Dir.chdir(File.expand_path('../../src/GoIO_DLL/MacOSX', __FILE__)) do
  puts system("xcodebuild -configuration Deployment clean")
  puts system("xcodebuild -configuration Deployment STRIP_STYLE='non-global' STRIP_INSTALLED_PRODUCT=YES DEAD_CODE_STRIPPING=YES install")
  puts system("lipo -detailed_info /tmp/GoIO_DLL.dst@executable_path/libGoIO_DLL.dylib")
end