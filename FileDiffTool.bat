@echo off
setlocal enabledelayedexpansion

rem フォルダ選択用のPowerShellスクリプト
set "folder1="
set "folder2="
for /f "delims=" %%i in ('powershell -command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.FolderBrowserDialog] | Out-Null; $dialog = New-Object System.Windows.Forms.FolderBrowserDialog; $dialog.ShowDialog() | Out-Null; $dialog.SelectedPath"') do set "folder1=%%i"
for /f "delims=" %%i in ('powershell -command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.FolderBrowserDialog] | Out-Null; $dialog = New-Object System.Windows.Forms.FolderBrowserDialog; $dialog.ShowDialog() | Out-Null; $dialog.SelectedPath"') do set "folder2=%%i"

if not defined folder1 (
    echo フォルダ1が選択されていません。
    pause
    exit /b
)
if not defined folder2 (
    echo フォルダ2が選択されていません。
    pause
    exit /b
)

rem ログファイルの設定
set "logFile=DiffResults_log.txt"
echo 比較結果ログ > "%logFile%"
echo. >> "%logFile%"
echo フォルダ1: %folder1% >> "%logFile%"
echo フォルダ2: %folder2% >> "%logFile%"
echo. >> "%logFile%"

rem 結果を保持するための変数
set "sameCount=0"
set "diffCount=0"
set "missingCount=0"

rem フォルダ内のファイルを比較
for /r "%folder1%" %%f in (*) do (
    set "file1=%%~nxf"
    set "fullPath1=%%f"
    set "fullPath2=%folder2%\!file1!"

    if exist "!fullPath2!" (
        fc "!fullPath1!" "!fullPath2!" >nul
        if errorlevel 1 (
            echo 差分ありファイル名：!file1!
            echo 差分ありファイルパス：!fullPath1!
            echo 差分ありファイル名：!file1! >> "%logFile%"
            echo 差分ありファイルパス：!fullPath1! >> "%logFile%"
            set /a diffCount+=1
        ) else (
            echo 同一ファイル名：!file1!
            echo 同一ファイルパス：!fullPath1!
            echo 同一ファイル名：!file1! >> "%logFile%"
            echo 同一ファイルパス：!fullPath1! >> "%logFile%"
            set /a sameCount+=1
        )
    ) else (
        echo 存在しないファイル名：!file1!
        echo 存在しないファイルパス：!fullPath1!
        echo 存在しないファイル名：!file1! >> "%logFile%"
        echo 存在しないファイルパス：!fullPath1! >> "%logFile%"
        set /a missingCount+=1
    )
)

rem 結果を表示
echo.
echo 同一ファイルの合計件数：%sameCount%
echo 差分ファイルの合計件数：%diffCount%
echo 存在しないファイルの合計件数：%missingCount%

rem ログファイルにも結果を追加
echo. >> "%logFile%"
echo 同一ファイルの合計件数：%sameCount% >> "%logFile%"
echo 差分ファイルの合計件数：%diffCount% >> "%logFile%"
echo 存在しないファイルの合計件数：%missingCount% >> "%logFile%"

endlocal
pause
