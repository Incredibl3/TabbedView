-------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------
include "../../premake/common/"
local lProjectName = "InGameBrowser"

local extern_path = path.getabsolute(_SCRIPT) .. "/../../../"

-------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------
solution ( lProjectName )

	math.randomseed(string.hash(solution().name))

	startproject "test"

	addCommonConfig( {
		noexceptionsConfiguration = true,
		exceptionsConfiguration = false
	})

-------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------	
project ( lProjectName )
	files 
	{ 
		"../src/**.cpp",
		"../src/**.h",
		"../src/**.mm",
		"../src/**.m",
		"../include/**.h",
	}

	includedirs 
	{ 	
		"../include/",
		"../../iOSCorePackage/include",		
	}

	kind "StaticLib"
	uuid "7BCEE634-51CD-40EA-9923-6BAF2FFEC8FE"
	
	defines {"IPHONE"}
	defines {"OS_IPHONE"}	
	
	buildoptions { "-std=c++11 -stdlib=libc++ -x objective-c++ -Wno-error -Wno-switch" }
	
	addCommonXcodeBuildSettings()
	xcodebuildsettings 
	{			
	}
	
	generatexcconfigs "YES"		
	configurationfiles
	{
		extern_path .. "InGameBrowser_config/" .. _OPTIONS["to"] .. "/user-debug-project.xcconfig",
		extern_path .. "InGameBrowser_config/" .. _OPTIONS["to"] .. "/user-release-project.xcconfig",
		extern_path .. "InGameBrowser_config/" .. _OPTIONS["to"] .. "/user-debug-target.xcconfig",
		extern_path .. "InGameBrowser_config/" .. _OPTIONS["to"] .. "/user-release-target.xcconfig"
	}		

	targetdir ("../lib/" .. GetLibOutPathForAction())
	objdir ("obj/" .. GetLibOutPathForAction())
	
	configuration "Debug"
		targetsuffix( "_d" )

project "test"

	kind "WindowedApp"

	files 
	{
		 "../tests/**",
		 GetPathFromPlatform() .. "/Info.plist",
	}

	includedirs
	{
		"../include/",
	}

	defines { "IPHONE" }
	defines {"OS_IPHONE"}
	buildoptions { "-std=c++11 -stdlib=libc++ -x objective-c++ -Wno-error" }	

	addCommonXcodeBuildSettings()	
	xcodebuildsettings 
	{
		["CODE_SIGN_IDENTITY"] = "iPhone Developer: Valeri Vuchov (WDTMDP2J2J)",
	}

	xcodebuildresources
	{
	}
			

	targetdir ("../build/" .. GetPathFromPlatform())	
	debugdir ("../data/")

	linkoptions 
	{
		"-framework CoreFoundation",
		"-framework Foundation",
		"-framework OpenGLES",
		"-framework UIKit",
		"-framework QuartzCore",
		"-framework CoreMotion",
		"-framework CoreTelephony",
		"-framework CoreLocation", 
		"-framework Security",
		"-framework AdSupport",
		"-framework GameKit",
		"-framework CFNetwork",
		"-framework MobileCoreServices",
		"-framework Accounts",
		"-framework Social",
		"-framework SystemConfiguration",
		"-framework MessageUI",
		"-framework CoreGraphics",
		"-framework CoreAudio",
		"-framework AudioToolbox",
		"-framework AddressBook",
		"-framework MediaPlayer",
	}

	links {"InGameBrowser"}

	configuration "Debug"
		targetsuffix( "_d" )

	configuration "Release"

-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------