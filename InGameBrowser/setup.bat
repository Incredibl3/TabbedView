@echo off

set configDir=%~dp0..\InGameBrowser_config

:: Create folder "InGameBrowser_config" to contain configuration files (if does not already exists)
IF NOT EXIST %configDir% md %configDir%

set copyConfigFile=y
IF (%1)==(overwrite) GOTO nocheck

:: Verify if InGameBrowserConfig.h already exists
IF EXIST "%configDir%\InGameBrowserConfig.h" (
set /p copyConfigFile="File 'InGameBrowserConfig.h' already exists. Do you want to overwrite it (y/n) ?"
)

:nocheck

:: Copy InGameBrowserConfig.h
IF  %copyConfigFile%==y (
echo Copying InGameBrowserConfig.h
copy "InGameBrowserConfig.h.template" "%configDir%\InGameBrowserConfig.h"
)

echo.

:: Copy xcconfig files
call prj\copy_config.bat prj\xcode4\ios\xcconfigs_InGameBrowser\user xcode4\ios

echo.

pause

