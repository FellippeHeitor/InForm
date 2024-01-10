'-----------------------------------------------------------------------------------------------------------------------
' InForm MessageBox compatibility functions. These basically emulates the legacy InForm MessageBox routines
' Copyright (c) 2024 Samuel Gomes
' Copyright (c) 2022 Fellippe Heitor
'-----------------------------------------------------------------------------------------------------------------------

$IF MESSAGEBOX_BAS = UNDEFINED THEN
    $LET MESSAGEBOX_BAS = TRUE

    '$INCLUDE:'MessageBox.bi'

    FUNCTION MessageBox& (message AS STRING, caption AS STRING, setup AS LONG)
        DIM dialogType AS STRING

        IF setup AND MsgBox_YesNo THEN
            dialogType = "yesno"
        ELSEIF setup AND MsgBox_YesNoCancel THEN
            dialogType = "yesnocancel"
        ELSEIF setup AND MsgBox_OkCancel THEN
            dialogType = "okcancel"
        ELSEIF setup AND MsgBox_OkOnly THEN
            dialogType = "ok"
        END IF

        DIM iconType AS STRING

        IF setup AND MsgBox_Critical THEN
            iconType = "error"
        ELSEIF setup AND MsgBox_Question THEN
            iconType = "question"
        ELSEIF setup AND MsgBox_Exclamation THEN
            iconType = "warning"
        ELSEIF setup AND MsgBox_Information THEN
            iconType = "info"
        END IF

        DIM defaultButton AS LONG

        IF setup AND MsgBox_DefaultButton3 THEN
            SELECT CASE dialogType
                CASE "yesnocancel"
                    defaultButton = 0
                CASE "yesno"
                    defaultButton = 0
                CASE "okcancel"
                    defaultButton = 0
                CASE "ok"
                    defaultButton = 1
            END SELECT
        ELSEIF setup AND MsgBox_DefaultButton2 THEN
            SELECT CASE dialogType
                CASE "yesnocancel"
                    defaultButton = 2
                CASE "yesno"
                    defaultButton = 0
                CASE "okcancel"
                    defaultButton = 0
                CASE "ok"
                    defaultButton = 1
            END SELECT
        ELSEIF setup AND MsgBox_DefaultButton1 THEN
            SELECT CASE dialogType
                CASE "yesnocancel"
                    defaultButton = 1
                CASE "yesno"
                    defaultButton = 1
                CASE "okcancel"
                    defaultButton = 1
                CASE "ok"
                    defaultButton = 1
            END SELECT
        END IF

        DIM __caption AS STRING: __caption = caption

        $IF INFORM_BI = DEFINED THEN
                IF LEN(__UI_CurrentTitle) > 0 THEN
                __caption = __UI_CurrentTitle
                ELSEIF LEN(_TITLE$) > 0 THEN
                __caption = _TITLE$
                ELSE
                __caption = COMMAND$(0)
                END IF
        $ELSE
            IF LEN(_TITLE$) > 0 THEN
                __caption = _TITLE$
            ELSE
                __caption = COMMAND$(0)
            END IF
        $END IF

        _DELAY 0.2 ' delay a bit so that the interface can redraw before the messagebox kicks in
        DIM returnValue AS LONG: returnValue = _MESSAGEBOX(__caption, message, dialogType, iconType, defaultButton)

        SELECT CASE returnValue
            CASE 0
                SELECT CASE dialogType
                    CASE "yesnocancel"
                        MessageBox = MsgBox_Cancel
                    CASE "yesno"
                        MessageBox = MsgBox_No
                    CASE "okcancel"
                        MessageBox = MsgBox_Cancel
                    CASE "ok"
                        MessageBox = MsgBox_Ok
                END SELECT
            CASE 1
                SELECT CASE dialogType
                    CASE "yesnocancel"
                        MessageBox = MsgBox_Yes
                    CASE "yesno"
                        MessageBox = MsgBox_Yes
                    CASE "okcancel"
                        MessageBox = MsgBox_Ok
                    CASE "ok"
                        MessageBox = MsgBox_Ok
                END SELECT
            CASE 2
                SELECT CASE dialogType
                    CASE "yesnocancel"
                        MessageBox = MsgBox_No
                    CASE "yesno"
                        MessageBox = MsgBox_No
                    CASE "okcancel"
                        MessageBox = MsgBox_Cancel
                    CASE "ok"
                        MessageBox = MsgBox_Ok
                END SELECT
        END SELECT
    END FUNCTION


    SUB MessageBox (message AS STRING, caption AS STRING, setup AS LONG)
        DIM returnValue AS LONG: returnValue = MessageBox(message, caption, setup)
    END SUB

$END IF
