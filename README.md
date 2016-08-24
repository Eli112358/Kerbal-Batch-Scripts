# Kerbal-Batch-Scripts
Some useful Batch scripts for [Kerbal Space Program](https://kerbalspaceprogram.com)

## Progress
`KspDataCli` can load, display, modify and save data files; can also copy and paste entries<br>
`KspProfiles` sets up the necessary folders and variables on first run

## Setting up
Extract all scripts and VERSION file to a folder and run `KspProfiles.cmd` as admin.

## Requirements
`KspDataCli` requires java runtime environment<br>
`KspProfiles` must be called from an elevated command prompt<br>
**Each will check for their requirements and report if they're not found

## Usage
When you want to play without mods, just do `KspProfiles activate Vanilla`.

Available commands in `KspDataCli`:

- select [..|index]
- list [clip[board]]
- set &lt;index&gt; &lt;text&gt;
- save [clip[board]]
- reload [file]
- copy &lt;index&gt;
- paste &lt;index_from&gt; &lt;index_to&gt;
- eval &lt;text&gt;
- help [command]
- exit

Available sub-commands in `KspProfiles`:

- activate &lt;profile&gt;
- create &lt;profile&gt;
- addMod &lt;profile&gt; &lt;mod&gt;
- addModuleManager &lt;profile&gt;
- help
