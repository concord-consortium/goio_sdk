#!//usr/bin/env ruby

destination = File.expand_path('../dll', __FILE__)
`rm -rf #{destination}`
`mkdir -p #{destination}/macos`
`mkdir -p #{destination}/windows`
`cp src/GoIO_DLL/MacOSX/build/Deployment/libGoIO_DLL.dylib #{destination}/macos`

%w{ppc7400 i386 x86_64}.each do |arch|
  `mkdir -p #{destination}/macos/#{arch}`
  cmd = "lipo -extract #{arch} #{destination}/macos/libGoIO_DLL.dylib -output #{destination}/macos/#{arch}/libGoIO_DLL.dylib"
  system(cmd)
end

`cp redist/GoIO_DLL/Win32/GoIO_DLL.* #{destination}/windows`
