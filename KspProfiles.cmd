@echo off
set tst=C:\deleteMe.tmp
(type nul>%tst%) 2>nul && (del %tst% & set isElevated=t) || (set isElevated=)
if not defined isElevated (echo Please run this from an elevated command prompt. &exit/b)
set tst=
set "kspProfilesLogs=%cd%\kspProfiles.log"
(type nul>%kspProfilesLogs%) 2>nul
if not defined kspInstall call :setup
if not defined kspProfiles call :setup
rem This is only temporary:
call :activate %*
exit/b
:setup
set "kspProfiles=%~0dp"
if defined kspInstall goto setupFolders
for "delims=;" %%I in (\Program Files;\Program Files (x86)) do if exist %%I (pushd %%I & call :setupEnv %%I & popd)
setx kspInstall "%kspInstall%"
setx kspProfiles "%kspProfiles%"
path %path%;%kspProfiles%
:setupFolders
for %%I in (GameData saves) do move "%kspInstall%\%%I" 2>>%kspProfilesLogs%
md Profiles\Vanilla 2>>%kspProfilesLogs%
for /f %%I in ('dir/b GameData ^2>>%kspProfilesLogs%') do if not %%I==Squad md Profiles\Modded 2>>%kspProfilesLogs%
for /f %%I in ('dir/b Profiles ^2>>%kspProfilesLogs%') do call :setupProfile %%I
if exist Profiles\Modded ((for /f %%I in ('dir/b/a:d GameData ^2>>%kspProfilesLogs%') do call :addMod Modded %%I) & (if exist GameData\ModuleManager*.dll for /f %%I in ('dir/b/a:-d GameData\ModuleManager* ^2>>%kspProfilesLogs%') do mklink/h Profiles\Modded\GameData\%%I GameData\%%I 2>>%kspProfilesLogs%))
exit/b
:setupProfile
for %%J in (GameData saves) do md Profiles\%1\%%J 2>>%kspProfilesLogs%
mklink/d Profiles\%%I\GameData\Squad 2>>%kspProfilesLogs%
for %%J in (senarios training) do mklink/d Profiles\%1\saves\%%J saves\%%J 2>>%kspProfilesLogs%
exit/b
:setupEnv
pushd %1
for /f "delims=" %%I in ('dir/b/s/a:d "Kerbal Space Program" 2^>>%kspProfilesLogs%') do set "kspInstall=%%~I"
popd
exit/b
:addMod
mklink/d Profiles\%1\GameData\%2 GameData\%2 2>>%kspProfilesLogs%
exit/b
:activate
pushd "%kspInstall%"
for %%I in (GameData saves) do rd %%I 2>>%kspProfilesLogs% &mklink/d %%I "%kspProfiles%\%*\%%I" 2>>%kspProfilesLogs%
popd
