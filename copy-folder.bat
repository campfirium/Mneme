@echo off
setlocal

:: 定义源目录和目标目录
set "SRC=teste"
set "DST=test"

:: 创建目标目录（如果不存在）
if not exist "%DST%" (
    mkdir "%DST%"
)

:: 复制所有内容，覆盖已存在的文件
xcopy "%SRC%\*" "%DST%\" /Y /E /Q

echo 完成复制：%SRC% → %DST%
endlocal
