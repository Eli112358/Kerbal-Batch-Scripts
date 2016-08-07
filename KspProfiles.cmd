@echo off
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
if defined kspInstall goto setupFolders
set "search=C:\Program Files"
reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" >nul && echo.>nul || set "search=%search%;C:\Program Files (x86)"
for "delims=;" %%I in (%search%) do pushd "%%I" & call :setupEnv "%%I" & popd
set search=
setx kspInstall "%kspInstall%"
path %path%;%kspProfiles%
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
mklink/d "%kspProfiles%\Profiles\%%I\GameData\Squad" "%kspProfiles%\GameData\Squad" 2>>"%kspProfilesLogs%"
for %%J in (senarios training) do mklink/d "%kspProfiles%\Profiles\%1\saves\%%J" "%kspProfiles%\saves\%%J" 2>>"%kspProfilesLogs%"
exit/b
:addMod
mklink/d "%kspProfiles%\Profiles\%1\GameData\%2" "%kspProfiles%\GameData\%2" 2>>"%kspProfilesLogs%"
exit/b
:addModuleManager
if not exist "%kspProfiles%\GameData\ModuleManager.*.dll" exit/b
for /f %%I in ('dir/b/a:-d "%kspProfiles%\GameData\ModuleManager.*.dll" 2^>^>"%kspProfilesLogs%"') do set MMVersion=%%I
mklink/h "%kspProfiles%\Profiles\%1\GameData\%MMVersion%" "%kspProfiles%\GameData\%MMVersion%" 2>>"%kspProfilesLogs%"
exit/b
:activate
pushd "%kspInstall%"
for %%I in (GameData saves) do rd %%I 2>>"%kspProfilesLogs%" &mklink/d %%I "%kspProfiles%\%*\%%I" 2>>"%kspProfilesLogs%"
popd
exit/b
:help
echo Usage:
echo.  %~n0 activate ^<profile^>             make KSP use this profile
echo.  %~n0 create ^<profile^>               create new profile
echo.  %~n0 addMod ^<profile^> ^<mod^>         add a mod to a profile
echo.  %~n0 addModuleManager ^<profile^>     add the ModuleManager mod to a profile
echo.  %~n0 help                           display this help message
