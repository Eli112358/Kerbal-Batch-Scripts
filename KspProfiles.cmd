@echo off
if not defined kspInstall call :setup
if not defined kspProfiles call :setup
rem This is only temporary:
call :set %*
exit/b
:setup
set "kspProfiles=%~0dp"
if defined kspInstall goto setupFolders
for "delims=;" %%I in (\Program Files;\Program Files (x86)) do if exist %%I (pushd %%I & call :setupEnv %%I & popd)
setx kspInstall "%kspInstall%"
setx kspProfiles "%kspProfiles%"
:setupFolders
for %%I in (GameData saves) do move "%kspInstall%\%%I"
md Profiles\Vanilla
for /f %%I in ('dir/b GameData') do if not %%I==Squad md Profiles\Modded 2>nul
for /f %%I in ('dir/b Profiles') do for %%J in (GameData saves) do md Profiles\%%I\%%J
for /f %%I in ('dir/b Profiles') do mklink/d Profiles\%%I\GameData\Squad
if exist Profiles\Modded for /f %%I in ('dir/b/a:d GameData') do mklink/d Profiles\Modded\GameData\%%I %%I
if exist Profiles\Modded if exist GameData\ModuleManager*.dll for /f %%I in ('dir/b/a:-d GameData\ModuleManager*') do mklink/h Profiles\Modded\GameData\%%I %%I
for /f %%I in ('dir/b Profiles') do for %%J in (senarios training) do mklink/d Profiles\%%I\saves\%%J saves\%%J
exit/b
:setupEnv
pushd %1
for /f "delims=" %%I in ('dir/b/s/a:d "Kerbal Space Program" 2^>nul') do set "kspInstall=%%~I"
popd
exit/b
:set
pushd "%kspInstall%"
for %%I in (GameData saves) do rd %%I &mklink/d %%I "%kspProfiles%\%*\%%I"
popd
