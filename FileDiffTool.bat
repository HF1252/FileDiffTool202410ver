@echo off
setlocal enabledelayedexpansion

rem �t�H���_�I��p��PowerShell�X�N���v�g
set "folder1="
set "folder2="
for /f "delims=" %%i in ('powershell -command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.FolderBrowserDialog] | Out-Null; $dialog = New-Object System.Windows.Forms.FolderBrowserDialog; $dialog.ShowDialog() | Out-Null; $dialog.SelectedPath"') do set "folder1=%%i"
for /f "delims=" %%i in ('powershell -command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.FolderBrowserDialog] | Out-Null; $dialog = New-Object System.Windows.Forms.FolderBrowserDialog; $dialog.ShowDialog() | Out-Null; $dialog.SelectedPath"') do set "folder2=%%i"

if not defined folder1 (
    echo �t�H���_1���I������Ă��܂���B
    pause
    exit /b
)
if not defined folder2 (
    echo �t�H���_2���I������Ă��܂���B
    pause
    exit /b
)

rem ���O�t�@�C���̐ݒ�
set "logFile=DiffResults_log.txt"
echo ��r���ʃ��O > "%logFile%"
echo. >> "%logFile%"
echo �t�H���_1: %folder1% >> "%logFile%"
echo �t�H���_2: %folder2% >> "%logFile%"
echo. >> "%logFile%"

rem ���ʂ�ێ����邽�߂̕ϐ�
set "sameCount=0"
set "diffCount=0"
set "missingCount=0"

rem �t�H���_���̃t�@�C�����r
for /r "%folder1%" %%f in (*) do (
    set "file1=%%~nxf"
    set "fullPath1=%%f"
    set "fullPath2=%folder2%\!file1!"

    if exist "!fullPath2!" (
        fc "!fullPath1!" "!fullPath2!" >nul
        if errorlevel 1 (
            echo ��������t�@�C�����F!file1!
            echo ��������t�@�C���p�X�F!fullPath1!
            echo ��������t�@�C�����F!file1! >> "%logFile%"
            echo ��������t�@�C���p�X�F!fullPath1! >> "%logFile%"
            set /a diffCount+=1
        ) else (
            echo ����t�@�C�����F!file1!
            echo ����t�@�C���p�X�F!fullPath1!
            echo ����t�@�C�����F!file1! >> "%logFile%"
            echo ����t�@�C���p�X�F!fullPath1! >> "%logFile%"
            set /a sameCount+=1
        )
    ) else (
        echo ���݂��Ȃ��t�@�C�����F!file1!
        echo ���݂��Ȃ��t�@�C���p�X�F!fullPath1!
        echo ���݂��Ȃ��t�@�C�����F!file1! >> "%logFile%"
        echo ���݂��Ȃ��t�@�C���p�X�F!fullPath1! >> "%logFile%"
        set /a missingCount+=1
    )
)

rem ���ʂ�\��
echo.
echo ����t�@�C���̍��v�����F%sameCount%
echo �����t�@�C���̍��v�����F%diffCount%
echo ���݂��Ȃ��t�@�C���̍��v�����F%missingCount%

rem ���O�t�@�C���ɂ����ʂ�ǉ�
echo. >> "%logFile%"
echo ����t�@�C���̍��v�����F%sameCount% >> "%logFile%"
echo �����t�@�C���̍��v�����F%diffCount% >> "%logFile%"
echo ���݂��Ȃ��t�@�C���̍��v�����F%missingCount% >> "%logFile%"

endlocal
pause
