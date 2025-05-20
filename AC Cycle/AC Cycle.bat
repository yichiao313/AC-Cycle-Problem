ECHO OFF
setlocal enabledelayedexpansion

TIMEOUT 10
CD "C:\Users\Administrator\Desktop\Reboot_WMIC"
:START

SET CYCLE_COUNT=!CYCLE_COUNT!
FOR /F %%X IN ('TYPE TargetCount.txt') DO SET TARGET_COUNT=%%X
ECHO CYCLE_COUNT  [!CYCLE_COUNT!]
ECHO TARGET_COUNT [!TARGET_COUNT!]
IF !CYCLE_COUNT! GEQ !TARGET_COUNT! GOTO END

REM ::	DUMP HW Configuration
CD "C:\Users\Administrator\Desktop\Reboot_WMIC"
START /B /WAIT Config_Dump.bat

REM ::	DUMP BMC SEL LOG
CD "C:\Users\Administrator\Desktop\Reboot_WMIC"
START /B /WAIT BMC_Dump.bat

REM ::	DUMP AEP LOG
CD "C:\Users\Administrator\Desktop\Reboot_WMIC"
START /B /WAIT AEP_Dump.bat


CD "C:\Users\Administrator\Desktop\Reboot_WMIC"
REM ::  ##################################################
REM ::  ## COUNTER + 1					 #
REM ::  ##################################################
ECHO CYCLE_COUNT  [!CYCLE_COUNT!]
ECHO TARGET_COUNT [!TARGET_COUNT!]
SET /A CYCLE_COUNT+=1
ECHO !CYCLE_COUNT! > Counter.txt
SETX CYCLE_COUNT !CYCLE_COUNT!

ECHO CYCLE_COUNT  [!CYCLE_COUNT!]

TIMEOUT 30
REM ::  ##################################################
REM ::  ## REBOOT					 #
REM ::  ##################################################
	cd "C:\Users\Administrator\Desktop\Reboot_WMIC\ipmitool 1.8.11 wmi"
        
        ipmitool -I wmi raw 0x6 0x52 0xf 0x22 0 0xd9

pause

:END