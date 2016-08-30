@echo off
if "%~1"=="-github" start https://github.com/Eli112358/Kerbal-Batch-Scripts/releases/latest &exit/b
if not "%~1"=="-version" goto start
for /f %%I in ('type %~dp0VERSION') do set version=%%I
echo Kerbal Batch Scripts v%version% by Eli112358 on Github
exit/b
:start
set tst=C:\deleteMe.tmp
(type nul>%tst%) 2>nul && (del %tst% & set isElevated=t) || (set isElevated=)
if not defined isElevated (echo Please run this from an elevated command prompt. &exit/b)
set tst=
set "kspProfilesLogs=%cd%\kspProfiles.log"
(type nul>"%kspProfilesLogs%") 2>nul
if not defined kspInstall call :setup
if not defined kspProfiles call :setup
if "%~1"=="" goto help
set "tempVar=%~1"
if not "%tempVar%"=="%tempVar:setup=%" call :setup & exit/b
set tempVar=
call :%*
exit/b
:setup
set "kspProfiles=%~0dp"
setx kspProfiles "%kspProfiles%"
path %path%;%kspProfiles%
if defined kspInstall goto setupFolders
set "search=%ProgramFiles%"
if defined ProgramFiles(x86) set "search=%ProgramFiles(x86)%"
set "steamLibraryFolders=%search%\Steam\steamapps\libraryFolders.vdf"
if not exist "%steamLibraryFolders%" goto setupNoSteam
where jjs >nul 2>&1 && (for /f "delims=" %%I in ('jjs -scripting var lines=readFully("%steamLibraryFolders%").split("\r\n");for(var x in lines){var i=lines[x].indexOf(":");if(i>-1)print(lines[x].substring(i-2))}') do call :setupEnv %%I ) || echo Please install the Java Runtime Environment
if defined kspInstall goto setupKspInstallFound
:setupNoSteam
for /f %%I in ('dir/b/s/a:d %search%') do call :setupEnv %%I
if defined kspInstall goto setupKspInstallFound
echo Couldn't find installation of KSP. Please install Kerbal Space Program first.
exit/b
:setupKspInstallFound
set search=
setx kspInstall "%kspInstall%"
:setupFolders
for %%I in (GameData saves) do move "%kspInstall%\%%I" "%kspProfiles%" 2>>"%kspProfilesLogs%"
call :create Vanilla
for /f %%I in ('dir/b "%kspProfiles%\GameData" 2^>^>"%kspProfilesLogs%"') do if not %%I==Squad call :create Modded
if exist "%kspProfiles%\Profiles\Modded" (( for /f %%I in ('dir/b/a:d "%kspProfiles%\GameData" ^2>>"%kspProfilesLogs%"') do call :addMod Modded %%I) & call :addModuleManager Modded )
exit/b
:setupEnv
pushd %1
for /f "delims=" %%I in ('dir/b/s/a:d "Kerbal Space Program" 2^>^>"%kspProfilesLogs%"') do set "kspInstall=%%~fI"
popd
exit/b
:create
md "%kspProfiles%\Profiles\%1" 2>>"%kspProfilesLogs%"
for %%J in (GameData saves) do md "%kspProfiles%\Profiles\%1\%%J" 2>>"%kspProfilesLogs%"
call :symlink "%kspProfiles%\Profiles\%%I\GameData\Squad" "%kspProfiles%\GameData\Squad"
for %%J in (senarios training) do call :symlink "%kspProfiles%\Profiles\%1\saves\%%J" "%kspProfiles%\saves\%%J"
exit/b
:addMod
call :symlink "%kspProfiles%\Profiles\%1\GameData\%2" "%kspProfiles%\GameData\%2"
exit/b
:addModuleManager
if not exist "%kspProfiles%\GameData\ModuleManager.*.dll" exit/b
for /f %%I in ('dir/b/a:-d "%kspProfiles%\GameData\ModuleManager.*.dll" 2^>^>"%kspProfilesLogs%"') do set MMVersion=%%I
mklink/h "%kspProfiles%\Profiles\%1\GameData\%MMVersion%" "%kspProfiles%\GameData\%MMVersion%" 2>>"%kspProfilesLogs%"
exit/b
:activate
pushd "%kspInstall%"
for %%I in (GameData saves) do rd %%I 2>>"%kspProfilesLogs%" & call :symlink %%I "%kspProfiles%\%*\%%I"
popd
exit/b
:symlink
for /f %%I in (%1) do set "driveLink=%%~dI"
for /f %%I in (%2) do set "driveTarget=%%~dI"
set type=d
if not "%driveLink%"=="%driveTarget%" set type=j
mklink /%type% %1 %2 &2>>"%kspProfilesLogs%"
exit/b
:help
echo Usage:
echo.  %~n0 activate ^<profile^>             make KSP use this profile
echo.  %~n0 create ^<profile^>               create new profile
echo.  %~n0 addMod ^<profile^> ^<mod^>         add a mod to a profile
echo.  %~n0 addModuleManager ^<profile^>     add the ModuleManager mod to a profile
echo.  %~n0 help                           display this help message

