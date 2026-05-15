@echo off
echo ========================================
echo   TakeTop Project Publish Script
echo ========================================
echo.

REM === Update these paths to match your Windows environment ===
set SOURCE_PATH=D:\WorkBuddy\TakeTopDECMPWinPGSolutionENCore\Source\Web
set OUTPUT_PATH=D:\CompilingPackages\TakeTopECMPEN
set ASPNET_COMPILER=C:\Windows\Microsoft.NET\Framework64\v4.0.30319\aspnet_compiler.exe
REM ========================================

echo Source: %SOURCE_PATH%
echo Output: %OUTPUT_PATH%
echo.

if not exist "%SOURCE_PATH%" (
    echo ERROR: Source path not found!
    echo Please update SOURCE_PATH in this script.
    pause
    exit /b 1
)

if not exist "%ASPNET_COMPILER%" (
    set ASPNET_COMPILER=aspnet_compiler.exe
)

echo [1/2] Cleaning old publish data...
if exist "%OUTPUT_PATH%" (
    rmdir /s /q "%OUTPUT_PATH%"
    echo Clean done.
) else (
    echo Target dir not exist, skip.
)
echo.

echo [2/2] Compiling and publishing...
"%ASPNET_COMPILER%" -v / -p "%SOURCE_PATH%" "%OUTPUT_PATH%" -u -f

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo   Publish SUCCESS!
    echo   Output: %OUTPUT_PATH%
    echo ========================================
) else (
    echo.
    echo ========================================
    echo   Publish FAILED!
    echo ========================================
)

pause
