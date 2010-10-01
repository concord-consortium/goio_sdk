notes from Johan, 2010-10-01

To build and check 64-bit Windows DLL:

  cd ../dll/winos/win64
  run cpdll.bat

Open the project: GoIO_DeviceCheck.sln.
Build (is set to 64).

I did not get it to launch the program in MSVC ( path to .dll problem)
So to run:

  cd GoIO_DeviceCheck/Win32

run once:
  setpathwin64.bat

run from cmd line
