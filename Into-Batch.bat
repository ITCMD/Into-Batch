@echo off
if "%1"=="" goto help
if /i "%1"=="/s" echo /S cannot be before file name. & echo. & goto help
if /i "%1"=="/h" goto help
if /i "%1"=="/help" goto help
if /i "%1"=="/F" shift & goto force
if /i "%2"=="/F" goto force
set num=%random%%random%%random%%random%%random%%random%
set var=%1
echo %var%| findstr /c:" " >nul
if %errorlevel%==0 set input=%File%.temp & goto nt
set input=%File%.temp
:nt
set file=%var:"=%
if not exist "%file%" echo FILE NOT FOUND. Use /h for help & exit /b
set output="%file%.txt"
echo.
setlocal
set maxbytesize=20000
FOR /F "usebackq" %%A IN ('"%file%"') DO set size=%%~zA

if %size% LSS %maxbytesize% (
    echo Begining Conversion.
) ELSE (
    echo Begining Conversion. This file is over 20KB large so it may take a minute or two.
)


certutil -encode "%file%" "%input%" >nul
echo if exist "%1" goto %num% >"%output%"
setlocal EnableDelayedExpansion
for /f "tokens=*" %%A in (%input%) do (echo echo %%A ^>temp.txt>> "%output%" & goto s)
:s
echo ( >> "%output%"
for /f "tokens=* skip=1" %%A in (%input%) do ( echo echo %%A>> "%output%" )
echo )^>^>temp.txt >> "%output%"
echo certutil -decode "temp.txt" "%file%" ^>nul >> "%output%"
echo del /f /q "temp.txt" >> "%output%"
echo :%num% >> "%output%"
echo.
echo Completed. Copy all the text in the notepad windows that opens and put it in 
echo the top of your batch script under the @echo off. (You can have multiples of these in one file, one after the other.)
del /f /q "%input%"
if /i "%2"=="/S" exit /b
if /i "%3"=="/S" exit /b
notepad %output%
exit /b





:force
if /i "%2"=="/S" goto yf
if /i "%3"=="/S" goto yf
echo Are you sure you want to make the script force a new file every time?
choice /c "YN"
if %errorlevel%==2 echo Canceled. & exit /b
:yf
set var=%1
echo %var%| findstr /c:" " >nul
if %errorlevel%==0 set input=%File%.temp & goto nt2
set input=%File%.temp
:nt2
set file=%var:"=%
if not exist "%file%" echo FILE NOT FOUND. Use /h for help & exit /b
set output="%file%.txt"
echo.
setlocal
set maxbytesize=20000
FOR /F "usebackq" %%A IN ('"%file%"') DO set size=%%~zA

if %size% LSS %maxbytesize% (
    echo Begining Conversion.
) ELSE (
    echo Begining Conversion. This file is over 20KB large so it may take a minute or two.
)


certutil -encode "%file%" "%input%" >nul
echo ::This WILL REPLACE %1 EVERY TIME. >"%output%"
echo del /f /q %1 >>"%output%"
setlocal EnableDelayedExpansion
for /f "tokens=*" %%A in (%input%) do (echo echo %%A ^>temp.txt>> "%output%" & goto s2)
:s2
echo ( >> "%output%"
for /f "tokens=* skip=1" %%A in (%input%) do ( echo echo %%A>> "%output%" )
echo )^>^>temp.txt >> "%output%"
echo certutil -decode "temp.txt" "%file%" ^>nul >> "%output%"
echo del /f /q "temp.txt" >> "%output%"
echo :%num% >> "%output%"
echo.
echo Completed. Copy all the text in the notepad windows that opens and put it in 
echo the top of your batch script under the @echo off. (You can have multiples of these in one file, one after the other.)
del /f /q "%input%"
if /i "%2"=="/S" exit /b
if /i "%3"=="/S" exit /b
notepad %output%
exit /b



:help
dir /b >dir.txt
setlocal EnableDelayedExpansion
for /f "tokens=*" %%A in (dir.txt) do (
	if exist "%%A\*.*" (
	 set Filler=Yes
	 ) ELSE (
		find "134323456654323456534t54567y4ert545tyt54rtrfertrrtrerITCOMMANDUNIQUEID-DONOTUSEINOTHERFILES" "%%A" >nul
		if !errorlevel!==0 set ThisFile=%%A
	)
)
echo %ThisFile%| findstr /c:" " >nul
set ThisFile=%ThisFile:~0,-4%
if %errorlevel%==0 set ThisFile="%ThisFile%"


echo This tool allows you to store any type of file inside your batch code.
echo the Syntax is:  %ThisFile%  FileName [/F] [/S]
echo.
echo Example: %ThisFile% Icon.png
echo          This example will create a text document with a batch script in it (and will open said text document)
echo          copy that script into the top of your file (after '@echo off' if you have it), and when the batch file
echo          starts, if Icon.png does not exist it will create it!
echo.
echo the /F option makes a script that will replace the file you convert every time it runs. wether it exists or not.
echo the /S option does not open the file at the end of the conversion, and does not prompt for force.
echo.
echo Questions or problems? Contact us at Support@ITCommand.tech!
echo script written by Lucas Elliott with IT Command www.itcommand.tech
if "%1"=="" pause
endlocal
exit /b
