# Kerbal-Batch-Scripts
Some useful Batch scripts for Kerbal Space Program (WIP)

## Progress
Kcli.cmd can only load and display data; modify and save are planned future features.
SetProfile.cmd does NOT ensure anything exists (planned future feature), so please create the profile(s) and set the environtment variables first.

## Setting up
I might create a script to do most or all of this automaticlly.

It might work fine to do this in the game's install location, but I haven't tested it myself. I recommend creating a folder somewhere in your user profile (C:\Users\user_name) and name it something relating to KSP.

1. Move the "GameData" folder from the KSP install folder to the root of this new folder (refered to as "KSP Files" from now on); this usually takes a while.
2. Also in "KSP Files", create a folder named "Profiles" or something similar (this folder's path will be the value for the `kspProfiles` environment variable).
3. I'd also recommend creating a folder named "saves" and moving the "senarios" and "training" folders into it, or just move them to the "KSP Files" folder (you'll see why later).
4. In the "Profiles" folder, I'd recommend creating a profile (folder) needed "Vanilla", "Classic" or "Original" (or similar), and a seperate one for modded play.
5. Now in each profile, create two folders named "GameData" and "saves".
6. In each profile's "GameData" folder, create a symbolic link to the "Squad" folder in the "KSP Files\GameData" folder: `mklink/d Squad ..\..\..\GameData\Squad`
7. In the "Modded" profile's "GameData", create a symbolic link for each mod's folder: `for /f %I in ('dir/b/a:d ..\..\..\GameData') do @mklink/d %I ..\..\..\GameData\%I`
8. If you use the "ModuleManager.[version].dll", you'll want to make a hard link to that: `mklink/h ModuleManager.[version].dll ..\..\..\GameData\ModuleManager.[version].dll` and move the generated files to the profile's "GameData" folder
9. In each profile's "saves" folder, create symbolic links for "senarios" and "training", respectively: `for /f %I in (senarios training) do @mklink/d %I ..\..\..\saves\%I`
10. Last manual folder interaction: move all your saved games to their respactive profile's "saves" folder.
11. Now open the control panel and goto "System and Security" > "System" > (left panel) "Advenced system settings" > (at the bottom) "Environment variables".
12. I'd recommend setting these for the current user only: `kspInstall=C:\Program Files (x86)\Steam\steamapps\common\Kerbal Space Program` and `kspProfiles=C:\Users\user_name\KSP Files\Profiles`

Now all you have to do is simply run `SetProfile.cmd [profile_name]` from an elevated command prompt (cmd > run as admin).
When you want to play without mods, just `SetProfile Vanilla`. Always use an elevated command prompt for `SetProfile.cmd`, otherwise it won't work.
