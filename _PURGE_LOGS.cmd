@echo off
set working_dir=%cd%
set to_remove=\mods\logs
set path=%working_dir%%to_remove%
cd %path%
DEL *.txt