# Kerbal-Batch-Scripts
Some useful Batch scripts for [Kerbal Space Program](https://kerbalspaceprogram.com)

## Progress
`KspDataCli` can load, display, modify and save data files<br>
`KspProfiles` sets up the necessary folders and variables on first run

## Setting up
Extract all scripts to a folder and run `KspProfiles.cmd` as admin.

## Requirements
`KspDataCli` requires java runtime environment<br>
`KspProfiles` must be called from an elevated command prompt<br>
**Each will check for their requirements and report if they're not found

## Usage
When you want to play without mods, just do `KspProfiles activate Vanilla`.

Current cammands in `KspDataCli`:

- select [..|number]
- list
- set &lt;number&gt; &lt;text&gt;
- save
- reload
- eval &lt;text&gt;
- help [command]
- exit
