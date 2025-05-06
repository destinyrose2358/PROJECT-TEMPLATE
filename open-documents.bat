:: Modifies Obsidian Config and then opens the Project Vault
@echo off
setlocal enabledelayedexpansion
:: Get path to the folder where this script is located (i.e. the project root)
set "project_dir=%~dp0"
set "project_dir=%project_dir:~0,-1%"

:: Extract the project name from the folder name
for %%F in ("%project_dir%") do set "project_name=%%~nF"

:: enforce documents name
call ".commands\enforce-documents-name.bat"

:: initialize vault
powershell -ExecutionPolicy Bypass -File ".commands\enforce-obsidian-reference.ps1"

set "vault_path=%~dp0\%project_name% documents"
start "" obsidian "%vault_path%"

endlocal
:: pause
