set SourceDir=%1
set TargetDir=%configDir%\%2

:: Verify if TargetDir already exists
IF EXIST %TargetDir% (
   echo Folder %2 already exists.
   set /p copyConfig="Overwrite its content (y/n) ?"
) ELSE (
md "%TargetDir%"
set copyConfig=y
)

:: Copy all user config files in SourceDir
IF %copyConfig%==y (
echo Copying %2 config files
FOR %%A IN (%SourceDir%\*.*) DO (
COPY %%A %TargetDir%
)
)
