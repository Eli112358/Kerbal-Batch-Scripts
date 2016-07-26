@echo off
set tst=C:\deleteMe.tmp
(type nul>%tst%) 2>nul && (del %tst% & set isElevated=t) || (set isElevated=)
if not defined isElevated (echo Please run this from an elevated command prompt. &exit/b)
set tst=
set "kspProfilesLogs=%cd%\kspProfiles.log"
(type nul>%kspProfilesLogs%) 2>nul
if not defined kspInstall call :setup
if not defined kspProfiles call :setup
set "tempVar=%~1"
if not "%tempVar%"=="%tempVar:setup=%" call :setup & exit/b
set tempVar=
call :%*
exit/b
:setup
set "kspProfiles=%~0dp"
setx kspProfiles "%kspProfiles%"
if defined kspInstall goto setupFolders
for "delims=;" %%I in (C:\Program Files;C:\Program Files (x86)) do if exist "%%I" (pushd "%%I" & call :setupEnv "%%I" & popd)
setx kspInstall "%kspInstall%"
path %path%;%kspProfiles%
:setupFolders
for %%I in (GameData saves) do move "%kspInstall%\%%I" 2>>%kspProfilesLogs%
call :create Vanilla
for /f %%I in ('dir/b "%kspProfiles%\GameData" ^2>>%kspProfilesLogs%') do if not %%I==Squad call :create Modded
if exist "%kspProfiles%\Profiles\Modded" (( for /f %%I in ('dir/b/a:d "%kspProfiles%\GameData" ^2>>%kspProfilesLogs%') do call :addMod Modded %%I) & call :addModuleManager Modded )
exit/b
:setupEnv
pushd %1
for /f "delims=" %%I in ('dir/b/s/a:d "Kerbal Space Program" 2^>>%kspProfilesLogs%') do set "kspInstall=%%~fI"
popd
exit/b
:create
md "%kspProfiles%\Profiles\%1" 2>>%kspProfilesLogs%
for %%J in (GameData saves) do md "%kspProfiles%\Profiles\%1\%%J" 2>>%kspProfilesLogs%
mklink/d "%kspProfiles%\Profiles\%%I\GameData\Squad" "%kspProfiles%\GameData\Squad" 2>>%kspProfilesLogs%
for %%J in (senarios training) do mklink/d "%kspProfiles%\Profiles\%1\saves\%%J" "%kspProfiles%\saves\%%J" 2>>%kspProfilesLogs%
exit/b
:addMod
mklink/d "%kspProfiles%\Profiles\%1\GameData\%2" "%kspProfiles%\GameData\%2" 2>>%kspProfilesLogs%
exit/b
:addModuleManager
if not exist "%kspProfiles%\GameData\ModuleManager.*.dll" exit/b
for /f %%I in ('dir/b/a:-d "%kspProfiles%\GameData\ModuleManager.*.dll" ^2>>%kspProfilesLogs%') do set MMVersion=%%I
mklink/h "%kspProfiles%\Profiles\%1\GameData\%MMVersion%" "%kspProfiles%\GameData\%MMVersion%" 2>>%kspProfilesLogs%
exit/b
:activate
pushd "%kspInstall%"
for %%I in (GameData saves) do rd %%I 2>>%kspProfilesLogs% &mklink/d %%I "%kspProfiles%\%*\%%I" 2>>%kspProfilesLogs%
popd
