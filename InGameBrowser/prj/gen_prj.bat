@echo off 
SET MAKETOOL=..\..\premake\release\premake5.exe

%MAKETOOL% --arch=ios --to=xcode4\ios xcode4