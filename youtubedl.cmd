@ECHO OFF & setLocal EnableDelayedExpansion

:: Copyright Conor McKnight
:: https://github.com/C0nw0nk/youtube-dl-concurrent
:: https://www.facebook.com/C0nw0nk

color 0A
%*
TITLE %window_titles%

SET "MESSAGE=%URL%"
SET "sFind=https://www.pornhub.com/view_video.php?viewkey^="
call set New=%%Message:%sFind%%%

%root_path%youtube-dl.exe -r 100m --format "(bestvideo[fps>60]/bestvideo)+bestaudio/best" --external-downloader aria2c -o %root_path%Downloads/%New%.mp4 -i --ignore-config --hls-prefer-native %URL%

rem %root_path%youtube-dl.exe -r 100m --format "(bestvideo[fps>60]/bestvideo)+bestaudio/best" --external-downloader aria2c -o %root_path%Downloads/%New%.mp4 -i --ignore-config --hls-prefer-native %URL% --postprocessor-args "-ss 00:01:00 -vf scale=-1:720 -c:v libx264 -c:a copy -x264opts opencl -movflags +faststart -analyzeduration 2147483647 -probesize 2147483647 -pix_fmt yuv420p"

ECHO Done downloading!

echo %New%

if /I %question%==y goto :start_convert
if /I %question%==Y goto :start_convert
if /I %question%==yes goto :start_convert
if /I %question%==YES goto :start_convert
EXIT

:start_convert
%root_path%ffmpeg.exe -y -i "%root_path%Downloads/%New%.mp4" -ss 00:01:00 -vf scale=-1:720 -c:v libx264 -c:a copy -x264opts opencl -movflags +faststart -analyzeduration 2147483647 -probesize 2147483647 -pix_fmt yuv420p "%root_path%Converted\%New%.mp4"


echo %root_path%Converted\%New%.mp4
set maxbytesize=1000000
FOR /F "usebackq" %%A IN ('%root_path%Converted\^%New%.mp4') DO set /a size=%%~zA 
echo size is %size%
echo size is !size!
IF %size% LSS %maxbytesize% ( 
echo.File is ^< %maxbytesize% bytes 
echo %root_path%Converted\%New%.mp4
del "%root_path%Converted\%New%.mp4"
) ELSE (
echo.File is ^> %maxbytesize% bytes 
) 

if /I %question6%==y goto :start_delete_original
if /I %question6%==Y goto :start_delete_original
if /I %question6%==yes goto :start_delete_original
if /I %question6%==YES goto :start_delete_original

if /I %question6%==n goto :stop_delete_original
if /I %question6%==N goto :stop_delete_original
if /I %question6%==no goto :stop_delete_original
if /I %question6%==NO goto :stop_delete_original

:start_delete_original
echo Deleting Original download file for disk space.
del "%root_path%Downloads\%New%.mp4"
:stop_delete_original

if /I %question3%==y goto :start_ftp
if /I %question3%==Y goto :start_ftp
if /I %question3%==yes goto :start_ftp
if /I %question3%==YES goto :start_ftp

if /I %question3%==n goto :stop_ftp
if /I %question3%==N goto :stop_ftp
if /I %question3%==no goto :stop_ftp
if /I %question3%==NO goto :stop_ftp

:start_ftp
echo "%ProgramFiles(x86)%\WinSCP\winscp.com"
mkdir %root_path%\lists\%question4%
IF EXIST "%ProgramFiles%\WinSCP\winscp.com" (
set ftp_install_path="%ProgramFiles%\WinSCP\winscp.com"
goto :ftp_install
)
IF EXIST "%ProgramFiles(x86)%\WinSCP\winscp.com" (
set ftp_install_path="%ProgramFiles(x86)%\WinSCP\winscp.com"
goto :ftp_install
)
IF EXIST "%LocalAppData%\Programs\WinSCP\winscp.com" (
set ftp_install_path="%LocalAppData%\Programs\WinSCP\winscp.com"
goto :ftp_install
)
echo Could not find FTP installation path...
goto :ftp_not_installed
:ftp_install
rem %ftp_install_path% /log="%root_path%log.txt" /command "open sftp://!ftp_user!:%ftp_password%@%ftp_server%/" "put %root_path%lists\%question4% %ftp_directory%" "exit"
%ftp_install_path% /command "open sftp://!ftp_user!:%ftp_password%@%ftp_server%/" "put %root_path%lists\%question4% %ftp_directory%" "exit"
%ftp_install_path% /command "open sftp://%ftp_user%:%ftp_password%@%ftp_server%/" "put %root_path%Converted\%New%.mp4 %ftp_directory%%question4%/" "exit"
rem del /F /Q "%root_path%lists/%question4%"

if /I %question7%==y goto :start_delete_converted
if /I %question7%==Y goto :start_delete_converted
if /I %question7%==yes goto :start_delete_converted
if /I %question7%==YES goto :start_delete_converted

if /I %question7%==n goto :stop_delete_converted
if /I %question7%==N goto :stop_delete_converted
if /I %question7%==no goto :stop_delete_converted
if /I %question7%==NO goto :stop_delete_converted

:start_delete_converted
del "%root_path%Converted\%New%.mp4"
:stop_delete_converted

echo done ftp
:stop_ftp
:ftp_not_installed
echo out of ftp contained
echo %root_path%Converted\^%New%.mp4

rem pause


EXIT