# Kerbal-Batch-Scripts
Some useful Batch scripts for [Kerbal Space Program](https://kerbalspaceprogram.com)

##Development
This project is due for deprecation, in favor of [Kerbal-Data-Manipulator
](https://github.com/Eli112358/Kerbal-Data-Manipulator) and [Kerbal-Profile-Manager
](https://github.com/Eli112358/Kerbal-Profile-Manager).

## Functionality
`KspDataCli` can load, display, modify and save data files; can also copy and paste entries<br>
`KspProfiles` sets up the necessary folders and variables on first run

## Setting up
Extract all scripts and VERSION file to a folder and run `KspProfiles.cmd` as admin.

## Requirements
Both require java runtime environment<br>
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
  - (if file name contains 'clip', will load as clipboard data, replacing any previously copied data)
- copy &lt;f|field|n|node&gt; &lt;index&gt; [&lt;count [c]&gt;|&lt;&lt;ending_index&gt; &lt;i|e&gt;&gt;]
  - ( **I** nclude or **E** xclude ending index)
- paste &lt;f|field|n|node&gt; &lt;index_to_paste_to&gt; &lt;index_to_paste_from&gt; [&lt;count [c]&gt;|&lt;&lt;ending_index&gt; &lt;i|e&gt;&gt;]
  - ( **I** nclude or **E** xclude ending index)
- eval &lt;text&gt;
- help [command]
- exit

Available sub-commands in `KspProfiles`:

- activate &lt;profile&gt;
- create &lt;profile&gt;
- addMod &lt;profile&gt; &lt;mod&gt;
- addModMgr &lt;profile&gt;
- ~~addModuleManager &lt;profile&gt;~~ (Deprecated)
- help
