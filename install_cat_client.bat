@echo off
setlocal enabledelayedexpansion

:: Checking administrator permissions
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo 请以管理员权限运行此脚本!
    pause
    exit /b 1
)

:: Set variable
set "URL=https://safeis-nas.oss-cn-beijing.aliyuncs.com/CS4.5/cat_client.tar"
set "TEMP_DIR=%TEMP%\cat_client_temp"
set "INSTALL_DIR=C:\Program Files\cat_client"
set "TAR_FILE=%TEMP_DIR%\cat_client.tar"

:: Create a temporary directory
if not exist "%TEMP_DIR%" mkdir "%TEMP_DIR%"

:: Download the file
echo 正在下载 cat_client.tar ...
powershell -Command "(New-Object Net.WebClient).DownloadFile('%URL%', '%TAR_FILE%')"
if %errorlevel% neq 0 (
    echo 下载失败,请检查网络连接或链接是否有效。
    goto :cleanup
)

:: 解压文件
echo 正在解压文件...
powershell -Command "Expand-Archive -Path '%TAR_FILE%' -DestinationPath '%TEMP_DIR%' -Force"
if %errorlevel% neq 0 (
    echo 解压失败。
    goto :cleanup
)

:: 创建安装目录
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

:: 复制文件到安装目录
echo 正在安装到 %INSTALL_DIR% ...
xcopy /E /I /Y "%TEMP_DIR%\*" "%INSTALL_DIR%"

:: 清理
:cleanup
echo 正在清理临时文件...
rd /S /Q "%TEMP_DIR%"

echo 安装完成。
pause
