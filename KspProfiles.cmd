@echo off
rem This is only temporary:
call :set %*
exit/b
:set
pushd "%kspInstall%"
for %%I in (GameData saves) do rd %%I &mklink/d %%I "%kspProfiles%\%*\%%I"
popd
