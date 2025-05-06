@echo off
setlocal enabledelayedexpansion

set "script_path=%~dp0"

:: Move up one directory to get the project root
cd /d "%script_path%\.."
set "project_dir=%cd%"

:: Get the name of the project folder
for %%F in ("%project_dir%") do set "parent_name=%%~nF"

:: Define old and new folder paths
set "old_folder=%project_dir%\PROJECT-TEMPLATE documents"
set "new_folder=%project_dir%\%parent_name% documents"

:: Rename the folder if needed
if exist "%old_folder%" (
    echo Renaming "%old_folder%" to "%new_folder%"
    ren "%old_folder%" "%parent_name% documents"
) else (
    echo Folder "PROJECT-TEMPLATE documents" not found in "%project_dir%"
)

endlocal
:: pause
