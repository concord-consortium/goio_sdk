#!/usr/bin/env ruby
#
# Ruby FFI interface to the Vernier GoIO sensor interface products
#
# http://www.vernier.com/go/
# http://www.vernier.com/downloads/gosdk.html
#
# Tested with jruby 1.5.1 on MacOS X 10.6.4.
#
# First build libGoIO_DLL.dylib with xcode.
#
# For now if you are running on MacOS 10.6 you will need to build libGoIO_DLL.dylib
# using the xcode project in the xcode_3_2_macosx_10_6 branch of this git repository.
# 
# Install jruby easily by first installing rvm and then running:
#
#   rvm install jruby
#
# To run this prohram in jruby:
#
#   rvm use jruby
#   ruby goio_rubyffi.rb
#
# On MacOS X 10.6 jruby runs in 64-bit Java 1.6 so this will require 
# libGoIO_DLL.dylib to include a 64-bit architecture (x86_64).
#
# For example this shows that the libGoIO_DLL.dylib is compiled as
# a three-way universal artifact:
#
#   file ./GoIO_DLL/MacOSX/build/Development/libGoIO_DLL.dylib
#   ./GoIO_DLL/MacOSX/build/Development/libGoIO_DLL.dylib: Mach-O universal binary with 3 architectures
#   ./GoIO_DLL/MacOSX/build/Development/libGoIO_DLL.dylib (for architecture x86_64):  Mach-O 64-bit dynamically linked shared library x86_64
#   ./GoIO_DLL/MacOSX/build/Development/libGoIO_DLL.dylib (for architecture ppc7400): Mach-O dynamically linked shared library ppc
#   ./GoIO_DLL/MacOSX/build/Development/libGoIO_DLL.dylib (for architecture i386):  Mach-O dynamically linked shared library i386
#
# To force jruby on MacOS X 10.6.4 to run in 32-bit Java
#
#   ruby -J-d32 goio_rubyffi.rb
#
# Running this with a Vernier Go!LInk and a Surface Temperature Probe connected generates 
# the following console output:
# 
#   $ jruby -J-d32 goio_rubyffi.rb
#   This app is linked to GoIO lib version 2.28
#   no LabPros found
#   no GoTemps found
#   GoLink device found. Enumerated id: 0xfa140000
#   no GoMotions found
#   no LabQuests found
#   no CK Spectrometers found
#   no Mini Gas Chromatographs found
#   no Stand-alone DACs found
#   GoLink found. Enumerated id: 0xfa140000
#   Sensor id: 10: 
#   39 measurements received after about 1 second.
#   Average measurement: 2.748 Volts
#

require 'rubygems'
require 'ffi'

module GoIO
  extend FFI::Library
  ffi_lib 'GoIO_DLL/MacOSX/build/Development/libGoIO_DLL.dylib'

  GOIO_MAX_SIZE_DEVICE_NAME           = 255
  GOIO_MAX_BUFFER_DEVICE_NAME         = GOIO_MAX_SIZE_DEVICE_NAME+1
  SKIP_TIMEOUT_MS_DEFAULT             = 2000
  SKIP_TIMEOUT_MS_READ_DDSMEMBLOCK    = 2000
  SKIP_TIMEOUT_MS_WRITE_DDSMEMBLOCK   = 4000
  
  SKIP_CMD_ID_START_MEASUREMENTS      = 0x18
  
  
  VERNIER_DEFAULT_VENDOR_ID           = 0x08F7
  LABPRO_DEFAULT_PRODUCT_ID           = 0x0001
  USB_DIRECT_TEMP_DEFAULT_PRODUCT_ID  = 0x0002    # aka GoTemp
  SKIP_DEFAULT_PRODUCT_ID             = 0x0003    # aka GoLink
  CYCLOPS_DEFAULT_PRODUCT_ID          = 0x0004    # aka GoMotion
  NGI_DEFAULT_PRODUCT_ID              = 0x0005    # aka LabQuest
  LOWCOST_SPEC_DEFAULT_PRODUCT_ID     = 0x0006    # aka CK Spectrometer
  MINI_GC_DEFAULT_PRODUCT_ID          = 0x0007    # aka Vernier Mini Gas Chromatograph
  STANDALONE_DAQ_DEFAULT_PRODUCT_ID   = 0x0008

  K_EquationType_None                 = 0
  K_EquationType_Linear               = 1
  K_EquationType_ModifiedGeometric    = 10
  K_EquationType_ReciprocalLog        = 11
  K_EquationType_SteinhartHart        = 12
  K_EquationType_Motion               = 13
  K_EquationType_Rotary               = 14
  K_EquationType_HeatPulser           = 15
  K_EquationType_DropCounter          = 16
  K_EquationType_Quadratic            = 2
  K_EquationType_Power                = 3
  K_EquationType_ModifiedPower        = 4
  K_EquationType_Logarithmic          = 5
  K_EquationType_ModifiedLogarithmic  = 6
  K_EquationType_Exponential          = 7
  K_EquationType_ModifiedExponential  = 8
  K_EquationType_Geometric            = 9
  
  PRODUCT_IDS = {
    "LabPro"                 => GoIO::LABPRO_DEFAULT_PRODUCT_ID,
    "GoTemp"                 => GoIO::USB_DIRECT_TEMP_DEFAULT_PRODUCT_ID,
    "GoLink"                 => GoIO::SKIP_DEFAULT_PRODUCT_ID,
    "GoMotion"               => GoIO::CYCLOPS_DEFAULT_PRODUCT_ID,
    "LabQuest"               => GoIO::NGI_DEFAULT_PRODUCT_ID,
    "CK Spectrometer"        => GoIO::LOWCOST_SPEC_DEFAULT_PRODUCT_ID,
    "Mini Gas Chromatograph" => GoIO::MINI_GC_DEFAULT_PRODUCT_ID,
    "Stand-alone DAC"        => GoIO::STANDALONE_DAQ_DEFAULT_PRODUCT_ID
  }

  attach_function :GoIO_Init,   [], :int
  attach_function :GoIO_Uninit, [], :int
  attach_function :GoIO_GetDLLVersion, [:pointer, :pointer], :int
  attach_function :GoIO_UpdateListOfAvailableDevices, [:int, :int], :int
  attach_function :GoIO_GetNthAvailableDeviceName, [:pointer, :int, :int, :int, :int], :int
  
  attach_function :GoIO_Sensor_Open, [ :pointer, :int, :int, :int ], :pointer
  attach_function :GoIO_Sensor_Close, [ :pointer ], :int
  attach_function :GoIO_Sensor_DDSMem_GetSensorNumber, [ :pointer, :pointer, :int, :int ], :int
  attach_function :GoIO_Sensor_DDSMem_GetLongName, [ :pointer, :pointer, :ushort ], :int
  attach_function :GoIO_Sensor_SetMeasurementPeriod, [ :pointer, :double, :int ], :int
  attach_function :GoIO_Sensor_SendCmdAndGetResponse, [ :pointer, :uchar, :pointer, :int, :pointer, :pointer, :int ], :int
  attach_function :GoIO_Sensor_ReadRawMeasurements, [ :pointer, :pointer, :int ], :int
  attach_function :GoIO_Sensor_ConvertToVoltage, [ :pointer, :int ], :double
  attach_function :GoIO_Sensor_CalibrateData, [ :pointer, :double ], :double
  attach_function :GoIO_Sensor_DDSMem_GetCalibrationEquation, [ :pointer, :pointer ], :int
  attach_function :GoIO_Sensor_DDSMem_GetActiveCalPage, [ :pointer, :pointer ], :int
  attach_function :GoIO_Sensor_DDSMem_GetCalPage, [ :pointer, :uchar, :pointer, :pointer, :pointer, :pointer, :ushort ], :int
  
end

def goio_init
  status = GoIO.GoIO_Init

  major_version = FFI::MemoryPointer.new :short
  minor_version = FFI::MemoryPointer.new :short
  status = GoIO.GoIO_GetDLLVersion(major_version, minor_version)
  puts "This app is linked to GoIO lib version #{major_version.get_short(0)}.#{minor_version.get_short(0)}"
end

def list_devices
  device_name = FFI::MemoryPointer.new(GoIO::GOIO_MAX_BUFFER_DEVICE_NAME)
  GoIO::PRODUCT_IDS.each_pair do |name, id|
    devices = GoIO.GoIO_UpdateListOfAvailableDevices(GoIO::VERNIER_DEFAULT_VENDOR_ID, id)
    if devices > 0
      devices.times do |n|
        status = GoIO.GoIO_GetNthAvailableDeviceName(device_name, GoIO::GOIO_MAX_SIZE_DEVICE_NAME, GoIO::VERNIER_DEFAULT_VENDOR_ID, GoIO::SKIP_DEFAULT_PRODUCT_ID, n)
        puts "#{name} device found. Enumerated id: #{device_name.get_string(0)}"
      end
    else
      puts "no #{name}s found"
    end
  end
end

def go_link
  @product_id = GoIO::PRODUCT_IDS["GoLink"]
  devices = GoIO.GoIO_UpdateListOfAvailableDevices(GoIO::VERNIER_DEFAULT_VENDOR_ID, @product_id)
  
  @go_link_name = FFI::MemoryPointer.new(GoIO::GOIO_MAX_BUFFER_DEVICE_NAME)
  status = GoIO.GoIO_GetNthAvailableDeviceName(@go_link_name, GoIO::GOIO_MAX_SIZE_DEVICE_NAME, GoIO::VERNIER_DEFAULT_VENDOR_ID, @product_id, 0)
  puts "GoLink found. Enumerated id: #{@go_link_name.get_string(0)}"

  @h_device = GoIO::GoIO_Sensor_Open(@go_link_name, GoIO::VERNIER_DEFAULT_VENDOR_ID, @product_id, 0)
  
  @char_id = FFI::MemoryPointer.new :uchar
  GoIO::GoIO_Sensor_DDSMem_GetSensorNumber(@h_device, @char_id, 0, 0)
  print "Sensor id: #{@char_id.get_uchar(0)}: "
  
  @long_name = FFI::MemoryPointer.new(100)
  GoIO::GoIO_Sensor_DDSMem_GetLongName(@h_device, @long_name, @long_name.size)
  puts @long_name.get_string(0)
  
  
  GoIO.GoIO_Sensor_SetMeasurementPeriod(@h_device, 0.040, GoIO::SKIP_TIMEOUT_MS_DEFAULT)  # 40 milliseconds measurement period.
  GoIO.GoIO_Sensor_SendCmdAndGetResponse(@h_device, GoIO::SKIP_CMD_ID_START_MEASUREMENTS, nil, 0, nil, nil, GoIO::SKIP_TIMEOUT_MS_DEFAULT)
  
  sleep(1)
  
  @raw_measurements     = FFI::MemoryPointer.new(:int, 100)
  @volts                = FFI::MemoryPointer.new(:double, 100)
  @cal_measurements     = []
  
  @num_measurements = GoIO.GoIO_Sensor_ReadRawMeasurements(@h_device, @raw_measurements, 100)
  puts "#{@num_measurements} measurements received after about 1 second."
  
  @ave_cal_measurement = 0.0
  @num_measurements.times do |i|
    @volts[i].write_float(GoIO.GoIO_Sensor_ConvertToVoltage(@h_device, @raw_measurements[i].read_int))
    @cal_measurements[i] = GoIO.GoIO_Sensor_CalibrateData(@h_device, @volts[i].read_float)
    @ave_cal_measurement += @cal_measurements[i]
  end
  
  if @num_measurements > 1
    @ave_cal_measurement = @ave_cal_measurement/@num_measurements
  end
  
  @equation_type = FFI::MemoryPointer.new :char
  GoIO.GoIO_Sensor_DDSMem_GetCalibrationEquation(@h_device, @equation_type)
  
  print "Average measurement: "
  
  if @equation_type.get_char(0) != GoIO::K_EquationType_Linear
    puts "#{@ave_cal_measurement} volts"
  else
    @a = FFI::MemoryPointer.new :int
    @b = FFI::MemoryPointer.new :int
    @c = FFI::MemoryPointer.new :int
    @active_cal_page = FFI::MemoryPointer.new :uchar
    @units = FFI::MemoryPointer.new(:char, 21)
    GoIO.GoIO_Sensor_DDSMem_GetActiveCalPage(@h_device, @active_cal_page);
    GoIO.GoIO_Sensor_DDSMem_GetCalPage(@h_device, @active_cal_page.get_char(0), @a, @b, @c, @units, 20)
    puts "#{'%.3f' % @ave_cal_measurement} #{@units.get_string(0)}"
  end
  
  GoIO::GoIO_Sensor_Close(@h_device)
end

def goio_close
  status = GoIO.GoIO_Uninit
end

begin
  goio_init
  list_devices
  go_link
ensure
  goio_close
end
