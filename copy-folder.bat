@echo off
setlocal

:: ����ԴĿ¼��Ŀ��Ŀ¼
set "SRC=teste"
set "DST=test"

:: ����Ŀ��Ŀ¼����������ڣ�
if not exist "%DST%" (
    mkdir "%DST%"
)

:: �����������ݣ������Ѵ��ڵ��ļ�
xcopy "%SRC%\*" "%DST%\" /Y /E /Q

echo ��ɸ��ƣ�%SRC% �� %DST%
endlocal
