#This requires ming or such --fix?
#Copy the currently built .dll 
#Note: It is up to you to build the 32 bit before copying.
cp  ../../../src/GoIO_DLL/Win32/Release/GoIO_DLL.dll .
cp  ../../../src/GoIO_DLL/Win32/Release/GoIO_DLL.lib .
cp  ../../../src/GoIO_DLL/Win32/*.h .
cp  ../../../src/GoIO_DLL/GoIO_DLL_interface.h .
cp  ../../../src/GoIO_cpp/*.h .