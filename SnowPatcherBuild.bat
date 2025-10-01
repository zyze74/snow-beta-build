@echo off
setlocal enableextensions
powershell -nop -c "& {$host.ui.rawui.windowtitle='Project Snow Beta v0.4 | Created by zyze74'}"

echo Copyright (C) 2025 @zyze74 [Version: Beta v0.4]
echo.

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

if '%errorlevel%' NEQ '0' (
    echo - Requesting admin 
    goto :UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
cls

:gotAdmin
:: Once admin is confimed, change text format to CHCP 65001 for functionality of UI
mode con cols=35 lines=3
setlocal disabledelayedexpansion
>nul chcp 65001
setlocal enabledelayedexpansion
color a

:: Loading bar for menu, does nothing, purely cosmetic, seems professional lol
set numSteps=10
set total=100

set /a remainingPercentage=%total%
set /a currentPercent=0
set step=0

:: Set bar to 0 then load 5 times randomly up to 100 before jumping to login
echo Loading 0%%
timeout /t 1 >nul

for /L %%i in (1, 1, %numSteps%) do (
    if %%i lss %numSteps% (
        set /a "randomPercentage=!random! %% 10 + 1"
        set /a "remainingPercentage -= !randomPercentage!"
        set "percentages[%%i]=!randomPercentage!"
    ) else (
        set "percentages[%%i]=!remainingPercentage!"
    )
)

set /a totalTime=10
set /a timePerStep=%totalTime% * 1000 / %numSteps%

for /L %%i in (1, 1, %numSteps%) do (
    set /a currentPercent+=!percentages[%%i]!
    cls
    echo Loading !currentPercent!%%
    timeout /t 1 >nul
)

cls
echo Loaded Scripts..
ping localhost -n 2 >nul
echo Awaiting Script..
ping localhost -n 1 >nul

endlocal
endlocal
color

:: Jump to MAIN after loading is done
goto :MAIN

:pre
cls
color c
mode con cols=60 lines=6
echo Do you want to create a system restore point? (recommended)
echo.
echo 1 - Yes
echo 2 - No
echo.
set /p option=

if "%option%"=="1" (
    cls
    color a
    echo You will now be prompted to create a restore point manually.
    echo.
    echo The System Restore window will open. Follow the instructions to create a restore point.
    echo.
    echo Press any key to open the System Restore window...
    pause >nul

    start ms-settings:recovery

    echo.
    echo After creating the restore point, press any key to return to the menu...
    pause >nul
    cls
    goto :MAIN
)

if "%option%"=="2" (
    cls
    color b
    echo Skipping system restore point creation.
    timeout /t 1 >nul
    cls
    goto :MAIN
)

cls
color c
echo Invalid selection.
timeout /t 1 >nul
cls
goto :error

:MAIN
setlocal enabledelayedexpansion
mode con cols=50 lines=6
cls
color b 

if not exist "userConfig.txt" (
    echo ┌───────────────────────────────┐
    echo │ Welcome to Project Snow v0.4  │
    echo └───────────────────────────────┘
    echo.
    set /p "user=Please enter your username: "
    (
        echo [USERDATA] Copyright @zyze74 
        echo.
        echo Username: %user%
    ) > "userConfig.txt"
    cls
    echo Your username is now %user%
    ping localhost -n 2 >nul
)

:: read username from file
for /f "tokens=2 delims=:" %%a in ('findstr /b "Username:" "userConfig.txt"') do (
    set "user=%%a"
)

:: trims leading space
set "user=%user:~1%"

:: fallback if username missing/corrupted
if not defined user (
    echo Error: Username not found in userConfig.txt
    del "userConfig.txt"
    endlocal
    goto :MAIN
)

endlocal & set "user=%user%"

cls
mode con cols=50 lines=4
echo Welcome back, %user%!
echo.
pause
cls
goto :MENU

:MENU
mode con cols=70 lines=17
color b
echo                       ┌────────────────────┐
echo                       │ Project Snow v0.4  │
echo                       └────────────────────┘
echo.
echo                        Logged in as %user%
echo. 
echo                      ┌──────────────────────┐
echo                      │ 1 - PC Cleaner       │   Created by @zyze74
echo                      │ 2 - Miscellaneous    │
echo                      │ 3 - Patch Notes      │
echo                      │ 4 - Power Options    │ 
echo                      │ 5 - Menu Controls    │
echo                      │ 6 - Exit Cleaner     │
echo                      └──────────────────────┘
echo.                        
set /p option=:
cls

if %option%==1 goto :MAINCLEANER
if %option%==2 goto :MIS
if %option%==3 goto :PTH
if %option%==4 goto :PWR 
if %option%==5 goto :Controls
if %option%==6 goto :EXT
goto :error1

:MAINCLEANER
mode con cols=75 lines=17
color b
echo                     ┌────────────────────────┐
echo                     │     PC Cleaner Menu    │
echo                     └────────────────────────┘
echo.
echo                     ┌────────────────────────┐
echo                     │ 1 - PC Clean           │  Created by @zyze74
echo                     │ 2 - Network Clean      │
echo                     │ 3 - Full PC Clean      │                  
echo                     │ 4 - Give Me Feedback   │
echo                     │ 5 - Back to Main Menu  │
echo                     └────────────────────────┘
echo.
set /p option=:
cls

if %option%==1 goto :cleaner
if %option%==2 goto :int
if %option%==3 goto :AUTOCLEAN
if %option%==4 goto :feedback
if %option%==5 goto :MENU
goto :error1
cls


:cleaner
mode con cols=75 lines=35
echo Please be patient, Snow is deleting ALOT of files in the background.
echo.
pause

:: --- Logging Setup ---
setlocal EnableDelayedExpansion
set "LOGDIR=%~dp0logs"
if not exist "%LOGDIR%" mkdir "%LOGDIR%"

:: Ensure the time format is valid for filenames
for /f "tokens=1-4 delims=:.," %%a in ("%TIME%") do (
    set "TIME=%%a%%b%%c%%d"
)

set "LOGFILE=%LOGDIR%\snow_log_%DATE:/=-%_%TIME%.log"
if exist "!LOGFILE!" del /f "!LOGFILE!" >nul 2>&1

echo Cleaning logs, please wait...
echo.

cd /d "%SystemDrive%\" || exit /b

:: --- Delete .log files ---
for /r %%f in (*.log) do (
    if exist "%%f" (
        del /f /q "%%f" 2> "%temp%\_tmp_error.log"
        if errorlevel 1 (
            for /f "delims=" %%e in (%temp%\_tmp_error.log) do (
                echo Failed to delete file: %%e >> "!LOGFILE!"
            )
        )
        del /f /q "%temp%\_tmp_error.log" >nul 2>&1
        echo Deleted: "%%f"
    )
)

cls
echo Log files cleaned successfully.
echo.

:: _____________________ DONT USE DOESNT WORK FOR NOW _______________________________
:: --- Delete files in %temp% ---
::echo Deleting Temp Files, please wait...
::for /f "delims=" %%f in ('dir /b /s "%temp%\*" 2^>nul') do (
::    if exist "%%f" (
::         del /f /q "%%f" 2>nul
::         if errorlevel 1 (
::             echo Failed to delete temp file: %%f >> "!LOGFILE!"
::        ) else (
::            echo Deleted: %%f
::        )
::        timeout /t 1 >nul
::    )
::)

:: --- Delete temp directories ---
:: for /d %%d in ("%temp%\*") do (
::     if exist "%%d" (
::         rmdir /s /q "%%d" 2>nul
::         if errorlevel 1 (
::             echo Failed to delete temp directory: %%d >> "!LOGFILE!"
::         ) else (
::             echo Deleted directory: %%d
::         )
::         timeout /t 1 >nul
::     )
:: )

:: ________ WORKS FROM HERE BELOW _________
:: --- Legacy cookie files ---
cls
echo Deleting Unused Cookies..
if exist "%userprofile%\cookies\" (
    for /f "delims=" %%f in ('dir /b /s "%userprofile%\cookies\*" 2^>nul') do (
        if exist "%%f" (
            del /f /q "%%f" 2>nul
            if errorlevel 1 (
                echo Failed to delete cookie file: %%f >> "!LOGFILE!"
            ) else (
                echo Deleted: %%f
            )
        )
    )
)

:: --- Windows Update files ---
cls
echo Deleting Windows Update Files, please wait...
if exist "C:\Windows\SoftwareDistribution\Download\" (
    for /f "delims=" %%f in ('dir /b /s "C:\Windows\SoftwareDistribution\Download\*" 2^>nul') do (
        if exist "%%f" (
            del /f /q "%%f" 2>nul
            if errorlevel 1 (
                echo Failed to delete Windows Update file: %%f >> "!LOGFILE!"
            ) else (
                echo Deleted: %%f
            )
        )
    )
)

:: --- Prefetch files ---
cls
echo Deleting Prefetch Files, please wait...
if exist "C:\Windows\Prefetch\" (
    for /f "delims=" %%f in ('dir /b /s "C:\Windows\Prefetch\*" 2^>nul') do (
        if exist "%%f" (
            del /f /q "%%f" 2>nul
            if errorlevel 1 (
                echo Failed to delete Prefetch file: %%f >> "!LOGFILE!"
            ) else (
                echo Deleted: %%f
            )
        )
    )
)

:: --- Windows Error Reporting files ---
cls
echo Deleting Windows Error Reporting Files, please wait...
if exist "C:\ProgramData\Microsoft\Windows\WER\" (
    for /f "delims=" %%f in ('dir /b /s "C:\ProgramData\Microsoft\Windows\WER\*" 2^>nul') do (
        if exist "%%f" (
            del /f /q "%%f" 2>nul
            if errorlevel 1 (
                echo Failed to delete WER file: %%f >> "!LOGFILE!"
            ) else (
                echo Deleted: %%f
            )
        )
    )
)

:: --- Crash Dump files ---
cls
echo Deleting Crash Dump Files, please wait...
if exist "C:\Windows\Minidump\" (
    for /f "delims=" %%f in ('dir /b /s "C:\Windows\Minidump\*" 2^>nul') do (
        if exist "%%f" (
            del /f /q "%%f" 2>nul
            if errorlevel 1 (
                echo Failed to delete Crash Dump file: %%f >> "!LOGFILE!"
            ) else (
                echo Deleted: %%f
            )
        )
    )
)

:: --- Windows Disk Cleanup via CleanMgr ---
cls
echo Launching Windows Disk Cleanup...
cleanmgr /sagerun:1
echo.
echo Disk Cleanup complete.
timeout /t 2 >nul

cls
echo Files deleted successfully.
echo.
if exist "%LOGFILE%" (
    echo Some of the files failed to delete: %LOGFILE%
) else (
    echo All Operations were completed with no errors!
)
timeout /t 2 >nul
echo.
echo Redirecting to Menu...
ping localhost -n 2 >nul
cls
goto :MAINCLEANER

:INT 
echo Preparing..
ping localhost -n 2 >nul 
cls

call :MsgBox "Would you like to optimise your network? This may temporarily disconnect you from your current network"  "VBYesNo+VBQuestion" "Click 'Yes' to continue"

    if errorlevel 7 (
        cls
        goto :MAINCLEANER
    ) 
    if errorlevel 6 (
        goto :RENEWAL
    )

cls
exit /b

:MsgBox prompt type title
    setlocal EnableExtensions
    set "tempFile=%temp%\%~nx0.%random%%random%%random%vbs.tmp"
    > "%tempFile%" echo WScript.Quit msgBox("%~1",%~2,"%~3") & cscript //nologo //e:vbscript "%tempFile%"
    cscript //nologo //e:vbscript "%tempFile%" 
    set "exitCode=%errorlevel%"
    del "%tempFile%" >nul 2>nul
    endlocal & exit /b %exitCode%
ping localhost -n 2 >nul
cls

:RENEWAL
echo Optimising network settings...
ping localhost -n 2 >nul 

ipconfig /release
cls
ipconfig /renew
cls 

echo Optimising ARP and NetBIOS settings...
ping localhost -n 2 >nul
arp -d *
cls
nbtstat -R
cls
nbtstat -RR
cls

echo Optimising DNS settings...
ping localhost -n 2 >nul
ipconfig /flushdns
ipconfig /registerdns  
cls

color a
echo Operation successfully completed...
ping localhost -n 2 >nul
color d
cls
GOTO :MAINCLEANER

:AUTOCLEAN
mode con cols=75 lines=35
echo Please be patient, Snow is deleting ALOT of files in the background.
echo.
pause

:: --- Logging Setup ---
setlocal EnableDelayedExpansion
set "LOGDIR=%~dp0logs"
if not exist "%LOGDIR%" mkdir "%LOGDIR%"

:: Ensure the time format is valid for filenames
for /f "tokens=1-4 delims=:.," %%a in ("%TIME%") do (
    set "TIME=%%a%%b%%c%%d"
)

set "LOGFILE=%LOGDIR%\snow_log_%DATE:/=-%_%TIME%.log"
if exist "!LOGFILE!" del /f "!LOGFILE!" >nul 2>&1

echo Cleaning logs, please wait...
echo.

cd /d "%SystemDrive%\" || exit /b

:: --- Delete .log files ---
for /r %%f in (*.log) do (
    if exist "%%f" (
        del /f /q "%%f" 2> "%temp%\_tmp_error.log"
        if errorlevel 1 (
            for /f "delims=" %%e in (%temp%\_tmp_error.log) do (
                echo Failed to delete file: %%e >> "!LOGFILE!"
            )
        )
        del /f /q "%temp%\_tmp_error.log" >nul 2>&1
        echo Deleted: "%%f"
    )
)

cls
echo Log files cleaned successfully.
echo.

:: _____________________ DONT USE DOESNT WORK FOR NOW _______________________________
:: --- Delete files in %temp% ---
::echo Deleting Temp Files, please wait...
::for /f "delims=" %%f in ('dir /b /s "%temp%\*" 2^>nul') do (
::    if exist "%%f" (
::         del /f /q "%%f" 2>nul
::         if errorlevel 1 (
::             echo Failed to delete temp file: %%f >> "!LOGFILE!"
::        ) else (
::            echo Deleted: %%f
::        )
::        timeout /t 1 >nul
::    )
::)

:: --- Delete temp directories ---
:: for /d %%d in ("%temp%\*") do (
::     if exist "%%d" (
::         rmdir /s /q "%%d" 2>nul
::         if errorlevel 1 (
::             echo Failed to delete temp directory: %%d >> "!LOGFILE!"
::         ) else (
::             echo Deleted directory: %%d
::         )
::         timeout /t 1 >nul
::     )
:: )

:: ________ WORKS FROM HERE BELOW _________
:: --- Legacy cookie files ---
cls
echo Deleting Unused Cookies..
if exist "%userprofile%\cookies\" (
    for /f "delims=" %%f in ('dir /b /s "%userprofile%\cookies\*" 2^>nul') do (
        if exist "%%f" (
            del /f /q "%%f" 2>nul
            if errorlevel 1 (
                echo Failed to delete cookie file: %%f >> "!LOGFILE!"
            ) else (
                echo Deleted: %%f
            )
        )
    )
)

:: --- Windows Update files ---
cls
echo Deleting Windows Update Files, please wait...
if exist "C:\Windows\SoftwareDistribution\Download\" (
    for /f "delims=" %%f in ('dir /b /s "C:\Windows\SoftwareDistribution\Download\*" 2^>nul') do (
        if exist "%%f" (
            del /f /q "%%f" 2>nul
            if errorlevel 1 (
                echo Failed to delete Windows Update file: %%f >> "!LOGFILE!"
            ) else (
                echo Deleted: %%f
            )
        )
    )
)

:: --- Prefetch files ---
cls
echo Deleting Prefetch Files, please wait...
if exist "C:\Windows\Prefetch\" (
    for /f "delims=" %%f in ('dir /b /s "C:\Windows\Prefetch\*" 2^>nul') do (
        if exist "%%f" (
            del /f /q "%%f" 2>nul
            if errorlevel 1 (
                echo Failed to delete Prefetch file: %%f >> "!LOGFILE!"
            ) else (
                echo Deleted: %%f
            )
        )
    )
)

:: --- Windows Error Reporting files ---
cls
echo Deleting Windows Error Reporting Files, please wait...
if exist "C:\ProgramData\Microsoft\Windows\WER\" (
    for /f "delims=" %%f in ('dir /b /s "C:\ProgramData\Microsoft\Windows\WER\*" 2^>nul') do (
        if exist "%%f" (
            del /f /q "%%f" 2>nul
            if errorlevel 1 (
                echo Failed to delete WER file: %%f >> "!LOGFILE!"
            ) else (
                echo Deleted: %%f
            )
        )
    )
)

:: --- Crash Dump files ---
cls
echo Deleting Crash Dump Files, please wait...
if exist "C:\Windows\Minidump\" (
    for /f "delims=" %%f in ('dir /b /s "C:\Windows\Minidump\*" 2^>nul') do (
        if exist "%%f" (
            del /f /q "%%f" 2>nul
            if errorlevel 1 (
                echo Failed to delete Crash Dump file: %%f >> "!LOGFILE!"
            ) else (
                echo Deleted: %%f
            )
        )
    )
)

:: --- Windows Disk Cleanup via CleanMgr ---
cls
echo Launching Windows Disk Cleanup...`
cleanmgr /sagerun:1
echo.
echo Disk Cleanup complete.
timeout /t 2 >nul

echo.
echo Files deleted successfully.
echo.
echo Redirecting to Menu...
ping localhost -n 2 >nul
cls
echo Starting Network Optimisations..
timeout /t 3 >nul

:: Network Optimisation section
cls 
echo Renewing Network Lease...
ipconfig /release 
ipconfig /renew
arp -d *
ping localhost -n 2 >nul
echo.

cls
echo Resetting Netstat...
nbtstat -R
nbtstat -RR
ping localhost -n 2 >nul
echo.

cls
echo Flushing DNS Cache...
ipconfig /flushdns
ping localhost -n 2 >nul
echo.

cls
echo Registering DNS...
ipconfig /registerdns
ping localhost -n 2 >nul

endlocal
cls 
color a 
echo Operation Completed Successfully!
echo. 

if exist "%LOGFILE%" (
    echo Some of the files failed to delete: %LOGFILE%
) else (
    echo All Operations were completed with no errors!
)
ping localhost -n 2 >nul
cls
goto :MAINCLEANER

:feedback
setlocal
set "DISCORD_WEBHOOK_URL=https://discord.com/api/webhooks/1276098309731254302/04jm7XVVequbW2nYEUzOJ3iUKUqjudxI4VgCxTTS07t7Do2Bl_3SqQA952AHb9BAwCol"

echo Thanks for wanting to give me some feedback.
echo. 
echo Please give honest feedback or it will be deleted.
pause
cls
echo Loading..

set "searchDir=%~dp0"
set "scriptPath="

for /r "%searchDir%" %%f in (requestHandler.ps1) do (
    set "scriptPath=%%f"
    goto :found
)

echo ERROR: Script not found.
echo If this persists please contact ze74s on Discord.
echo.
pause 
cls
goto :error1

:found
echo Loading Script found at %scriptPath%..
endlocal & set "scriptPath=%scriptPath%" & set "DISCORD_WEBHOOK_URL=%DISCORD_WEBHOOK_URL%"
echo.
cls
goto :startpowershell

:startpowershell
start "" powershell.exe -NoExit -ExecutionPolicy Bypass -Command "$env:DISCORD_WEBHOOK_URL = '%DISCORD_WEBHOOK_URL%'; & '%scriptPath%'"
pause
cls
goto :newfeatend

:newfeatend
set /p option= Thanks for leaving feeback, press enter to continue.
cls 
goto :MAINCLEANER
else goto :error1

:error1
color c
set /p option= An error occurred or a mis-input was made, press enter to continue.
cls
goto :MENU

:MIS
mode con cols=75 lines=17
color c
echo  - Logged in as %user%
echo.
echo          ┌───────────────────────────────────┐
echo          │ Miscellaneous Menu                │
echo          └───────────────────────────────────┘
echo. 
echo          ┌───────────────────────────────────┐
echo          │ 1 - Windows Performance Booster   │
echo          │ 2 - Windows %systemdrive% Clean-up           │
echo          │ 3 - Edit Power Plan               │
echo          │ 4 - Download CCleaner             │
echo          │ 5 - Back                          │
echo          └───────────────────────────────────┘
echo. 
set /p option=:
cls

if %option%==1 GOTO :winop
if %option%==2 GOTO :winclean
if %option%==3 GOTO :powerplan
if %option%==4 GOTO :DWN
if %option%==5 GOTO :MENU 
goto :error1

:winop
echo.
echo             PROCEED AT YOUR OWN RISK!
echo           ┌───────────────────────────┐
echo           │ 1 - Optimise Windows      │         
echo           │ 2 - Revert Settings       │                              
echo           │ 3 - Other Optimisations   │ 
echo           │ 4 - FAQ                   │
echo           │ 5 - Back                  │                 
echo           └───────────────────────────┘
echo. 
set /p option=:
cls 

if %option%==1 GOTO :winopOk
if %option%==2 GOTO :winopUndo
if %option%==3 GOTO :winOther
if %option%==4 GOTO :winopFAQ
if %option%==5 GOTO :MIS
goto :error1
cls

:winopOK
echo Cleaning Prefetch files...
del /s /q C:\Windows\Prefetch\*.* 2>nul

echo Disabling Windows Defender and Notifications...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 1 /f
sc stop "MsMpSvc" && sc config "MsMpSvc" start= disabled
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v "NOC_GLOBAL_SETTING_TOASTS_ENABLED" /t REG_DWORD /d 0 /f

echo Disabling Superfetch and Optimizing Network...
sc stop "SysMain" && sc config "SysMain" start= disabled
netsh int tcp set global autotuninglevel=normal
netsh int tcp set global chimney=enabled
netsh int tcp set global dca=enabled
netsh int tcp set global rss=enabled

echo Stopping and Deleting Windows Update files...
net stop wuauserv
del /s /q C:\Windows\SoftwareDistribution\Download\*.* 
net start wuauserv

echo Rebuilding Windows Search Index...
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\ContentIndex" /v StartupDelay /t REG_DWORD /d 0 /f

echo Disabling OneDrive and Xbox Services...
sc config onesyncsvc start=disabled
sc config XboxGipSvc start=disabled
sc config XblAuthManager start=disabled
sc config XblGameSave start=disabled
sc config XboxNetApiSvc start=disabled
sc config BcastDVRUserService start=disabled

echo Disabling Useless Services and Telemetry...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d 1 /f
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoRebootWithLoggedOnUsers" /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338388Enabled" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "CortanaEnabled" /t REG_DWORD /d 0 /f

echo Stopping DiagTrack Service...
sc stop "DiagTrack" && sc config "DiagTrack" start= disabled

echo Disabling GameDVR...
reg add "HKCU\Software\Microsoft\GameBar" /v "UseNexusForGameBarEnabled" /t REG_DWORD /d "0" /f
reg add "HKCU\Software\Microsoft\GameBar" /v "GameDVR_Enabled" /t REG_DWORD /d "0" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d "0" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v "AudioCaptureEnabled" /t REG_DWORD /d "0" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v "CursorCaptureEnabled" /t REG_DWORD /d "0" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v "HistoricalCaptureEnabled" /t REG_DWORD /d "0" /f
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\GameDVR" /v "AllowgameDVR" /t REG_DWORD /d "0" /f

echo Diabling Notifications...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v "NOC_GLOBAL_SETTING_ALLOW_NOTIFICATION_SOUND" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v "NOC_GLOBAL_SETTING_ALLOW_CRITICAL_TOASTS_ABOVE_LOCK" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\QuietHours" /v "Enabled" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\windows.immersivecontrolpanel_cw5n1h2txyewy!microsoft.windows.immersivecontrolpanel" /v "Enabled" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.AutoPlay" /v "Enabled" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.LowDisk" /v "Enabled" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.Print.Notification" /v "Enabled" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.SecurityAndMaintenance" /v "Enabled" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.WiFiNetworkManager" /v "Enabled" /t REG_DWORD /d "0" /f 
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "DisableNotificationCenter" /t REG_DWORD /d "1" /f

echo Disabling Copilot...
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" /v "TurnOffWindowsCopilot" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" /v "TurnOffWindowsCopilot" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{CB3B0003-8088-4EDE-8769-8B354AB2FF8C}" /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "HubsSidebarEnabled" /t REG_DWORD /d "0" /f

echo Disabling Unused Services...
:: Disables MS spam shit
schtasks /end /tn "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" > nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /disable > nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Customer Experience Improvement Program\BthSQM" > nul 2>&1 
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\BthSQM" /disable > nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" > nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" /disable > nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" > nul 2>&1 
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /disable > nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Customer Experience Improvement Program\Uploader" > nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\Uploader" /disable > nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" > nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /disable > nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Application Experience\ProgramDataUpdater" > nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Application Experience\ProgramDataUpdater" /disable > nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Application Experience\StartupAppTask" > nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Shell\FamilySafetyMonitor" > nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Shell\FamilySafetyMonitor" /disable > nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Shell\FamilySafetyRefresh" > nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Shell\FamilySafetyRefresh" /disable > nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Shell\FamilySafetyUpload" > nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Shell\FamilySafetyUpload" /disable > nul 2>&1
schtasks /end /tn "\Microsoft\Windows\Maintenance\WinSAT" > nul 2>&1

:: Disables Activity Feed
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" /v "EnableFeeds" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft" /v "AllowNewsAndInterests" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableActivityFeed" /t REG_DWORD /d "0" /f
reg add "HKCU\Control Panel\International\User Profile" /v "HttpAcceptLanguageOptOut" /t REG_DWORD /d "1" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\System" /v "EnableActivityFeed" /t REG_DWORD /d "0" /f

:: Disables Popups and Tips
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DisallowShaking" /t REG_DWORD /d "1" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "EnableBalloonTips" /t REG_DWORD /d "0" /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSyncProviderNotifications" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener" /v "Value" /t REG_SZ /d "Deny" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\AdvertisingInfo" /v "DisabledByGroupPolicy" /t REG_DWORD /d "1" /f

echo Operations Completed Successfully!
ping localhost -n 2 >nul
cls
goto :winop

:winopUndo
echo Undoing all changes...

echo Restoring Prefetch files...
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /f
sc config "MsMpSvc" start= auto
sc start "MsMpSvc"

echo Restoring Notifications...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v "NOC_GLOBAL_SETTING_TOASTS_ENABLED" /f

echo Re-enabling Superfetch...
sc config "SysMain" start= auto
sc start "SysMain"

echo Reverting Network Settings...
netsh int tcp set global autotuninglevel=normal
netsh int tcp set global chimney=enabled
netsh int tcp set global dca=enabled
netsh int tcp set global rss=enabled

echo Restarting Windows Update...
net start wuauserv

echo Restoring Windows Update files, but can't directly restore them. You may need to let Windows update automatically.

echo Reverting Search and Indexing settings...
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\ContentIndex" /v StartupDelay /f

echo Re-enabling OneDrive and Xbox Services...
sc config onesyncsvc start= auto
sc config XboxGipSvc start= auto
sc config XblAuthManager start= auto
sc config XblGameSave start= auto
sc config XboxNetApiSvc start= auto
sc config BcastDVRUserService start= auto

echo Restoring Background Applications and Data Collection settings...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /f
reg delete "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoRebootWithLoggedOnUsers" /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338388Enabled" /f
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "CortanaEnabled" /f

echo Re-enabling DiagTrack Service...
sc config "DiagTrack" start= auto
sc start "DiagTrack"
ping localhost -n 2 >nul
cls
goto :winop

:winOther
echo.
echo             PROCEED AT YOUR OWN RISK!
echo           ┌────────────────────────────────┐
echo           │ 1 - GPU Tweaks                 │         
echo           │ 2 - RAM Tweaks                 │                              
echo           │ 3 - PC Tweaks                  │ 
echo           │ 4 - Back                       │                 
echo           └────────────────────────────────┘
echo. 
set /p option=:
cls 

if %option%==1 GOTO :winopGPU
if %option%==2 GOTO :winopRAM 
if %option%==3 GOTO :winopPC
if %option%==4 GOTO :winop
goto :error1
cls

:winopGPU
echo.
echo           ┌────────────────────────────────┐
echo           │ 1 - NVIDIA GPU                 │         
echo           │ 2 - AMD GPU                    │                              
echo           │ 3 - INTEL GPU                  │ 
echo           │ 4 - Back                       │              
echo           └────────────────────────────────┘
echo. 
set /p option=:
cls 

if %option%==1 GOTO :gpuNVIDIA
if %option%==2 GOTO :gpuAMD
if %option%==3 GOTO :gpuINTEL
if %option%==4 GOTO :winOther
goto :error1
cls

:gpuNVIDIA
echo Enabling MSI Mode...
for /f %%g in ('wmic path win32_videocontroller get PNPDeviceID ^| findstr /L "VEN_"') do (
reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%g\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f  
reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%g\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /t REG_DWORD /d "0" /f 
)
timeout /t 1 /nobreak > NUL

echo Setting NVIDIA Latency Tolerance...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "D3PCLatency" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "F1TransitionLatency" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "LOWLATENCY" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "Node3DLowLatency" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PciLatencyTimerControl" /t REG_DWORD /d "20" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMDeepL1EntryLatencyUsec" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RmGspcMaxFtuS" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RmGspcMinFtuS" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RmGspcPerioduS" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMLpwrEiIdleThresholdUs" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMLpwrGrIdleThresholdUs" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMLpwrGrRgIdleThresholdUs" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMLpwrMsIdleThresholdUs" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "VRDirectFlipDPCDelayUs" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "VRDirectFlipTimingMarginUs" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "VRDirectJITFlipMsHybridFlipDelayUs" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "vrrCursorMarginUs" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "vrrDeflickerMarginUs" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "vrrDeflickerMaxUs" /t REG_DWORD /d "1" /f 
timeout /t 1 /nobreak > NUL

echo Disabling NVIDIA Telemetry...
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "NvBackend" /f 
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\FTS" /v "EnableRID66610" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\FTS" /v "EnableRID64640" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\FTS" /v "EnableRID44231" /t REG_DWORD /d "0" /f 
schtasks /change /disable /tn "NvTmRep_CrashReport1_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" 
schtasks /change /disable /tn "NvTmRep_CrashReport2_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" 
schtasks /change /disable /tn "NvTmRep_CrashReport3_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" 
schtasks /change /disable /tn "NvTmRep_CrashReport4_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" 
schtasks /change /disable /tn "NvDriverUpdateCheckDaily_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" 
schtasks /change /disable /tn "NVIDIA GeForce Experience SelfUpdate_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" 
schtasks /change /disable /tn "NvTmMon_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" 
timeout /t 1 /nobreak > NUL

echo Disabling Write Combining...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "DisableWriteCombining" /t REG_DWORD /d "1" /f 
timeout /t 1 /nobreak > NUL

echo Disabling Preemption...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "DisablePreemption" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "DisableCudaContextPreemption" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "EnableCEPreemption" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "DisablePreemptionOnS3S4" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "ComputePreemption" /t REG_DWORD /d "0" /f 
timeout /t 1 /nobreak > NUL

echo Operations Completed Successfully!
ping localhost -n 2 >nul
cls
goto :winOther

:gpuAMD
echo Enabling MSI Mode...
for /f %%g in ('wmic path win32_videocontroller get PNPDeviceID ^| findstr /L "VEN_"') do (
reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%g\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f  
reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%g\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /t REG_DWORD /d "0" /f 
)
timeout /t 1 /nobreak > NUL

echo Disabling Display Refresh Rate Override...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "3D_Refresh_Rate_Override_DEF" /t REG_DWORD /d "0" /f 
timeout /t 1 /nobreak > NUL

echo Disabling SnapShot...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AllowSnapshot" /t REG_DWORD /d "0" /f 
timeout /t 1 /nobreak > NUL

echo Disabling Anti Aliasing...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AAF_NA" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AntiAlias_NA" /t REG_SZ /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "ASTT_NA" /t REG_SZ /d "0" /f 
timeout /t 1 /nobreak > NUL

echo Disabling Subscriptions...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AllowSubscription" /t REG_DWORD /d "0" /f 
timeout /t 1 /nobreak > NUL

echo Disabling Anisotropic Filtering...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AreaAniso_NA" /t REG_SZ /d "0" /f 
timeout /t 1 /nobreak > NUL


echo Disabling Radeon Overlay...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AllowRSOverlay" /t REG_SZ /d "false" /f  
timeout /t 1 /nobreak > NUL

echo Enabling Adaptive DeInterlacing...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "Adaptive De-interlacing" /t REG_DWORD /d "1" /f 
timeout /t 1 /nobreak > NUL


echo Disabling Skins...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AllowSkins" /t REG_SZ /d "false" /f  
timeout /t 1 /nobreak > NUL

echo Disabling Automatic Color Depth Reduction...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AutoColorDepthReduction_NA" /t REG_DWORD /d "0" /f 
timeout /t 1 /nobreak > NUL


echo Disabling Power Gating...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableSAMUPowerGating" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableUVDPowerGatingDynamic" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableVCEPowerGating" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisablePowerGating" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableDrmdmaPowerGating" /t REG_DWORD /d "1" /f 
timeout /t 1 /nobreak > NUL


echo Disabling Clock Gating...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableVceSwClockGating" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableUvdClockGating" /t REG_DWORD /d "1" /f 
timeout /t 1 /nobreak > NUL

echo Disabling Active State Power Management...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableAspmL0s" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableAspmL1" /t REG_DWORD /d "0" /f 
timeout /t 1 /nobreak > NUL


echo Disabling Ultra Low Power States...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableUlps" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableUlps_NA" /t REG_SZ /d "0" /f 
timeout /t 1 /nobreak > NUL

echo Enabling De-Lag...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_DeLagEnabled" /t REG_DWORD /d "1" /f 
timeout /t 1 /nobreak > NUL

echo Disabling Frame Rate Target...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_FRTEnabled" /t REG_DWORD /d "0" /f 
timeout /t 1 /nobreak > NUL

echo Disabling DMA...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableDMACopy" /t REG_DWORD /d "1" /f 
timeout /t 1 /nobreak > NUL

echo Enable BlockWrite...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableBlockWrite" /t REG_DWORD /d "0" /f 
timeout /t 1 /nobreak > NUL

echo Disabling Stutter Mode...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "StutterMode" /t REG_DWORD /d "0" /f 
timeout /t 1 /nobreak > NUL

echo Disabling GPU Memory Clock Sleep State...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_SclkDeepSleepDisable" /t REG_DWORD /d "1" /f 
timeout /t 1 /nobreak > NUL

echo Disabling Thermal Throttling...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_ThermalAutoThrottlingEnable" /t REG_DWORD /d "0" /f 
timeout /t 1 /nobreak > NUL

echo Disabling Preemption...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_EnableComputePreemption" /t REG_DWORD /d "0" /f 
timeout /t 1 /nobreak > NUL

echo Setting Main3D...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "Main3D_DEF" /t REG_SZ /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "Main3D" /t REG_BINARY /d "3100" /f 
timeout /t 1 /nobreak > NUL

echo Setting FlipQueueSize...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "FlipQueueSize" /t REG_BINARY /d "3100" /f 
timeout /t 1 /nobreak > NUL

echo Setting Shader Cache Size...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "ShaderCache" /t REG_BINARY /d "3200" /f 
timeout /t 1 /nobreak > NUL

echo Configuring TFQ...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "TFQ" /t REG_BINARY /d "3200" /f 
timeout /t 1 /nobreak > NUL

echo Disabling High-Bandwidth Digital Content Protection...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\\DAL2_DATA__2_0\DisplayPath_4\EDID_D109_78E9\Option" /v "ProtectionControl" /t REG_BINARY /d "0100000001000000" /f 
timeout /t 1 /nobreak > NUL

echo Disabling GPU Power Down...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_GPUPowerDownEnabled" /t REG_DWORD /d "1" /f 
timeout /t 1 /nobreak > NUL

echo Disabling AMD Logging...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\amdlog" /v "Start" /t REG_DWORD /d "4" /f 
timeout /t 1 /nobreak > NUL

echo Operations Completed Successfully!
ping localhost -n 2 >nul
cls
goto :winOther

:gpuINTEL
for /f %%t in ('reg query "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}" /t REG_SZ /s /e /f "Intel" ^| findstr "HKEY"') do (

	reg add "%%t" /v "Disable_OverlayDSQualityEnhancement" /t REG_DWORD /d "1" /f
    reg add "%%t" /v "IncreaseFixedSegment" /t REG_DWORD /d "1" /f
    reg add "%%t" /v "AdaptiveVsyncEnable" /t REG_DWORD /d "0" /f
    reg add "%%t" /v "DisablePFonDP" /t REG_DWORD /d "1" /f
    reg add "%%t" /v "EnableCompensationForDVI" /t REG_DWORD /d "1" /f
    reg add "%%t" /v "NoFastLinkTrainingForeDP" /t REG_DWORD /d "0" /f
    reg add "%%t" /v "ACPowerPolicyVersion" /t REG_DWORD /d "16898" /f
    reg add "%%t" /v "DCPowerPolicyVersion" /t REG_DWORD /d "16642" /f
)
reg add "HKLM\Software\Intel\GMM" /v "DedicatedSegmentSize" /t REG_DWORD /d "512" /f

echo Operations Completed Successfully!
ping localhost -n 2 >nul
cls
goto :winOther

:winopRAM
echo Disabling Compression...
chcp 437 > nul
PowerShell -Command "Disable-MMAgent -MemoryCompression" > nul 2>&1
chcp 65001 > nul
timeout /t 1 /nobreak > NUL

echo Disabling Paging Executive...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DpiMapIommuContiguous" /t REG_DWORD /d "1" /f 
timeout /t 1 /nobreak > NUL

echo Disabling Prefetch and Superfetch...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnablePrefetcher" /t REG_DWORD /d "0" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnableSuperfetch" /t REG_DWORD /d "0" /f
timeout /t 1 /nobreak > NUL

echo RAM Managment Tweaks...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "ClearPageFileAtShutdown" /t REG_DWORD /d "0" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d "1" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d "0" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "NonPagedPoolQuota" /t REG_DWORD /d "0" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "NonPagedPoolSize" /t REG_DWORD /d "0" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "PagedPoolQuota" /t REG_DWORD /d "0" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "PagedPoolSize" /t REG_DWORD /d "192" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "SecondLevelDataCache" /t REG_DWORD /d "1024" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "SessionPoolSize" /t REG_DWORD /d "192" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "SessionViewSize" /t REG_DWORD /d "192" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "SystemPages" /t REG_DWORD /d "4294967295" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "PhysicalAddressExtension" /t REG_DWORD /d "1" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettings" /t REG_DWORD /d "1" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverride" /t REG_DWORD /d "3" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverrideMask" /t REG_DWORD /d "3" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "IoPageLockLimit" /t REG_DWORD /d "16710656" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "PoolUsageMaximum" /t REG_DWORD /d "96" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "Start" /t REG_DWORD /d "4" /f

echo Operations Completed Successfully!
ping localhost -n 2 >nul
cls
goto :winOther

:winopPC
echo Disable Idle Power Managment...
for /f "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum" /s /f "StorPort"^| findstr "StorPort"') do reg add "%%i" /v "EnableIdlePowerManagement" /t REG_DWORD /d "0" /f
    for %%i in (EnableHIPM EnableDIPM EnableHDDParking) do for /f %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services" /s /f "%%i" ^| findstr "HKEY"') do reg add "%%a" /v "%%i" /t REG_DWORD /d "0" /f

echo Disable Link State Power Managment...
FOR /F "eol=E" %%a in ('REG QUERY "HKLM\System\CurrentControlSet\Services" /s "EnableHIPM"^| FINDSTR /V "EnableHIPM"') DO (
reg add "%%a" /v "EnableHIPM" /t REG_DWORD /d "0" /f  > nul 
reg add "%%a" /v "EnableDIPM" /t REG_DWORD /d "0" /f > nul 
FOR /F "tokens=*" %%z IN ("%%a") DO (
SET STR=%%z
SET STR=!STR:HKLM\System\CurrentControlSet\Services\=!
) > nul 
)
	
echo  Disabling GPU Energy Driver...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\GpuEnergyDrv" /v "Start" /t REG_DWORD /d "4" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Services\GpuEnergyDr" /v "Start" /t REG_DWORD /d "4" /f 
timeout /t 1 /nobreak > NUL

echo Disabling Energy Logging...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "DisableTaggedEnergyLogging" /t REG_DWORD /d "1" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "TelemetryMaxApplication" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "TelemetryMaxTagPerApplication" /t REG_DWORD /d "0" /f 
timeout /t 1 /nobreak > NUL

echo Disabling CoalescingTimerInterval...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Executive" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\ModernSleep" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "PlatformAoAcOverride" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EnergyEstimationEnabled" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EventProcessorEnabled" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "CsEnabled" /t REG_DWORD /d "0" /f 
timeout /t 1 /nobreak > NUL

echo Disabling Power Throttling...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t REG_DWORD /d "1" /f 
timeout /t 1 /nobreak > NUL

echo Disabling USB PowerSavings...
for /f %%i in ('wmic path Win32_USBController get PNPDeviceID^| findstr /l "PCI\VEN_"') do (
reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "AllowIdleIrpInD3" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "D3ColdSupported" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "DeviceSelectiveSuspended" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "EnableSelectiveSuspend" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "EnhancedPowerManagementEnabled" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "SelectiveSuspendEnabled" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "SelectiveSuspendOn" /t REG_DWORD /d "0" /f 
)
timeout /t 1 /nobreak > NUL

echo Thread Priority...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\usbxhci\Parameters" /v "ThreadPriority" /t REG_DWORD /d "31" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\USBHUB3\Parameters" /v "ThreadPriority" /t REG_DWORD /d "31" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Parameters" /v "ThreadPriority" /t REG_DWORD /d "31" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NDIS\Parameters" /v "ThreadPriority" /t REG_DWORD /d "31" /f
timeout /t 1 /nobreak > NUL

echo Disabling USB Selective Suspend...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\USB" /v "DisableSelectiveSuspend" /t REG_DWORD /d "1" /f 
timeout /t 1 /nobreak > NUL

echo Operations Completed Successfully!
ping localhost -n 2 >nul
cls
goto :winOther

:winopFAQ
echo Q: What does this do? 
echo A: Enhances performance on your system by disabling
echo    services and applications that can degrade performance
echo. 
echo Q: Why should I use this?
echo A: Disables up to 80 processes on your system upon Restart.
echo    This ensures that your system is a lot more responsive 
echo    and better at handling your tasks especially when you
echo    use the Hardware and PC Tweak options.
echo.
echo Q: This broke my PC im gonna crash out!
echo A: I am not responsible for your own actions. Nor am I
echo liable for any damages/issues on your system.
echo.
set /p option=: Press "enter" to go back
cls
goto :winop

:winclean
echo Windows Disk Clean-up,
echo.
echo When %systemdrive% Disk Clean-up opens select everything and click 'Clean'.
echo.
echo This may take a while depending on how much is being removed.
echo.
ping localhost -n 2 >nul
c:\windows\system32\cleanmgr.exe /dc /sagerum: 1
cls

set /p= Press 'Enter' to return to the menu.
cls
color 7a
GOTO :MIS

:DWN
echo Please wait, redirecting to website...
start chrome "https://www.ccleaner.com/ccleaner/download"

echo set WshShell = WScript.CreateObject("WScript.Shell") > %tmp%\tmp.vbs
echo WScript.Quit (WshShell.Popup( "On CCleaner's website scroll down and click 'Free Download'." ,10 , "Snow Cleaner")) >> %tmp%\tmp.vbs

cscript //nologo %tmp%\tmp.vbs

if %errorlevel%==0 (
    cls
    goto :MIS
) else (
    echo Loading...
    cls
)

del %tmp%\tmp.vbs

set /p="Press Enter to be redirected to Menu.."
cls
color 7d
goto :MIS

:powerplan
echo              ┌─────────────────┐
echo              │ Edit Power Plan │
echo              └─────────────────┘
echo.
echo        ┌──────────────────────────────┐
echo        │ 1 - Ultimate Perf Power Plan │
echo        │ 2 - High Perf Power Plan     │
echo        │ 3 - Balanced Perf Power Plan │
echo        │ 4 - Low Perf Power Plan      │
echo        │ 5 - Back                     │
echo        └──────────────────────────────┘ 
echo.
set /p option=Choose an option: 

if %option%==1 goto :UltimatePerf
if %option%==2 goto :HighPerf
if %option%==3 goto :BalancedPerf
if %option%==4 goto :LowPerf
if %option%==5 goto :MIS
goto :error1
cls

:UltimatePerf
echo Setting Power Plan..
powercfg /setactive e9a42b02-d5df-448d-aa00-03f14749eb61
cls
echo Power Plan Set to Ultimate Performance
pause
cls
goto :powerplan

:HighPerf
echo Setting Power Plan..
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
cls
echo Power Plan Set to High Performance
pause
cls
goto :powerplan

:BalancedPerf
echo Setting Power Plan..
powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e
cls
echo Power Plan Set to Balanced Performance
pause
cls
goto :powerplan

:LowPerf
echo Setting Power Plan..
powercfg /setactive a1841308-3541-4fab-bc81-f71556f20b4a
cls
echo Power Plan Set to Low Performance
pause
cls
goto :powerplan

:PTH 
rem POTENTIALLY ADD A MODE VARIABLE TO RESIZE TO SCALE OF TEXT IF NEED BE 
color a
echo  - Latest Version - [v0.4] -
echo.  
echo  - Patch Notes:
echo.
echo    Updates:
echo  - Added new GPU RAM and PC optimisations
echo  - Added Restart option before closing
echo  - Added so many new tweaks in backend
echo.
echo    Press 'Enter' To be redirected to the Main Menu..
echo.
set /p= - Stay tuned for more updates - zyze74 - 
cls 
goto :MENU

:Controls
echo How to use Snow Cleaner:
echo. 
echo The numbers on each page refer to numbers on your keyboard.
echo.
echo Press the number thats allocated to where you want to go
echo and then press "enter" on your keyboard. 
echo.
echo This will then take you to that page/option you selected.
echo. 
echo Discord: zyze74 (if you need help)
echo. 
set /p= Press 'Enter' to be redirected to the Main Menu..
cls 
goto :MENU

:PWR 
color 0d
echo        ┌───────────────┐
echo        │ Power Options │
echo        └───────────────┘
echo. 
echo        ┌───────────────┐
echo        │ 1 - Shutdown  │
echo        │ 2 - Restart   │
echo        │ 3 - Back      │
echo        └───────────────┘ 
echo.
set /p option=: 
cls

if %option%==1 GOTO :SHU 
if %option%==2 GOTO :RES
if %option%==3 GOTO :MENU
goto :error1
cls

:SHU
echo Preparing Shutdown..
call :YesNoBox "Are you sure you want to Shutdown your PC?"
if "%YesNo%"=="7" (
cls
echo Redirecting...
  ping localhost -n 2 >nul
  cls
goto :MENU
)
 
if "%YesNo%"=="6" (
SHUTDOWN /s -t 0
ping localhost -n 3 >nul 
goto :EXTEND
)

exit /b
:YesNoBox
set YesNo=
set MsgType=4
set heading=%~2
set message=%~1
echo wscript.echo msgbox(WScript.Arguments(0),%MsgType%,WScript.Arguments(1)) >"%temp%\input.vbs"
for /f "tokens=* delims=" %%a in ('cscript //nologo "%temp%\input.vbs" "%message%" "%heading%"') do set YesNo=%%a
exit /b

:MessageBox
set heading=%~2
set message=%~1
echo msgbox WScript.Arguments(0),0,WScript.Arguments(1) >"%temp%\input.vbs"
cscript //nologo "%temp%\input.vbs" "%message%" "%heading%"
exit /b


:RES 
echo Preparing Restart..
call :YesNoBox "Are you sure you want to Restart your PC?"
if "%YesNo%"=="7" ( rem No
cls
echo Redirecting...
  ping localhost -n 2 >nul
  cls
goto :MENU
)
 
if "%YesNo%"=="6" ( rem Yes
SHUTDOWN -r -t 0
ping localhost -n 3 >nul 
GOTO :EXTEND
)

exit /b
:YesNoBox
set YesNo=
set MsgType=4
set heading=%~2
set message=%~1
echo wscript.echo msgbox(WScript.Arguments(0),%MsgType%,WScript.Arguments(1)) >"%temp%\input.vbs"
for /f "tokens=* delims=" %%a in ('cscript //nologo "%temp%\input.vbs" "%message%" "%heading%"') do set YesNo=%%a
exit /b

:MessageBox
set heading=%~2
set message=%~1
echo msgbox WScript.Arguments(0),0,WScript.Arguments(1) >"%temp%\input.vbs"
cscript //nologo "%temp%\input.vbs" "%message%" "%heading%"
exit /b


:EXT
echo ┌──────────────────────┐
echo │  Now closing Snow..  │
echo └──────────────────────┘
echo.
ping localhost -n 2 >nul
goto :EXTEND

:YesNoBox
set YesNo=
set MsgType=4
set heading=%~2
set message=%~1
echo wscript.echo msgbox(WScript.Arguments(0),%MsgType%,WScript.Arguments(1)) >"%temp%\input.vbs"
for /f "tokens=* delims=" %%a in ('cscript //nologo "%temp%\input.vbs" "%message%" "%heading%"') do set YesNo=%%a
exit /b

:MessageBox
set heading=%~2
set message=%~1
echo msgbox WScript.Arguments(0),0,WScript.Arguments(1) >"%temp%\input.vbs"
cscript //nologo "%temp%\input.vbs" "%message%" "%heading%"
exit /b

:EXTEND
echo msgbox "Thank you for using Snow!" > %tmp%\tmp.vbs
cscript /nologo %tmp%\tmp.vbs
del %tmp%\tmp.vbs
chcp %cp%>nul
exit /b

:: UNUSED GLOBAL VARIABLE may use in future
:error
color c
set /p= Your input was not recognised, press any key to try again.
cls
GOTO :MENU