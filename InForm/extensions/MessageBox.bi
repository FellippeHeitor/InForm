' MessageBox compatibility functions
' These basically emulate the legacy InForm MessageBox routines
' All it does is calls the new QB64-PE _MESSAGEBOX$ function

$IF MESSAGEBOX_BI = UNDEFINED THEN
    $LET MESSAGEBOX_BI = TRUE

    'Messagebox constants
    CONST MsgBox_OkOnly = 1
    CONST MsgBox_OkCancel = 2
    CONST MsgBox_AbortRetryIgnore = 4
    CONST MsgBox_YesNoCancel = 8
    CONST MsgBox_YesNo = 16
    CONST MsgBox_RetryCancel = 32
    CONST MsgBox_CancelTryagainContinue = 64

    CONST MsgBox_Critical = 128
    CONST MsgBox_Question = 256
    CONST MsgBox_Exclamation = 512
    CONST MsgBox_Information = 1024

    CONST MsgBox_DefaultButton1 = 2048
    CONST MsgBox_DefaultButton2 = 4096
    CONST MsgBox_DefaultButton3 = 8192
    CONST MsgBox_Defaultbutton4 = 16384

    CONST MsgBox_AppModal = 32768
    CONST MsgBox_SystemModal = 65536
    CONST MsgBox_SetForeground = 131072

    CONST MsgBox_Ok = 1
    CONST MsgBox_Yes = 2
    CONST MsgBox_No = 3
    CONST MsgBox_Cancel = 4
    CONST MsgBox_Abort = 5
    CONST MsgBox_Retry = 6
    CONST MsgBox_Ignore = 7
    CONST MsgBox_Tryagain = 8
    CONST MsgBox_Continue = 9
$END IF
