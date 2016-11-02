OPTION _EXPLICIT

$EXEICON:'.\InForm\InForm Preview.ico'
_ICON

CONST OffsetEditorPID = 1
CONST OffsetPreviewPID = 5
CONST OffsetWindowLeft = 9
CONST OffsetWindowTop = 11
CONST OffsetNewControl = 13
CONST OffsetNewDataFromEditor = 15
CONST OffsetNewDataFromPreview = 17
CONST OffsetTotalControlsSelected = 19
CONST OffsetFormID = 23
CONST OffsetFirstSelectedID = 27
CONST OffsetPropertyChanged = 31
CONST OffsetPropertyValue = 33

DIM SHARED UiPreviewPID AS LONG
DIM SHARED ExeIcon AS LONG

$IF WIN THEN
    DECLARE DYNAMIC LIBRARY "kernel32"
        FUNCTION OpenProcess& (BYVAL dwDesiredAccess AS LONG, BYVAL bInheritHandle AS LONG, BYVAL dwProcessId AS LONG)
        FUNCTION CloseHandle& (BYVAL hObject AS LONG)
        FUNCTION GetExitCodeProcess& (BYVAL hProcess AS LONG, lpExitCode AS LONG)
    END DECLARE
$ELSE
    DECLARE LIBRARY
    FUNCTION PROCESS_CLOSED& ALIAS kill (BYVAL pid AS INTEGER, BYVAL signal AS INTEGER)
    END DECLARE
$END IF
'$include:'InForm.ui'
'$include:'UiEditorPreview.frm'
'$include:'xp.uitheme'

'Event procedures: ---------------------------------------------------------------
SUB __UI_Click (id AS LONG)
    DIM b$
    b$ = MKI$(-1)
    SendData b$, OffsetNewDataFromPreview
END SUB

SUB __UI_MouseEnter (id AS LONG)
    DIM b$
    b$ = MKI$(-1)
    SendData b$, OffsetNewDataFromPreview
END SUB

SUB __UI_MouseLeave (id AS LONG)
END SUB

SUB __UI_FocusIn (id AS LONG)
END SUB

SUB __UI_FocusOut (id AS LONG)
END SUB

SUB __UI_MouseDown (id AS LONG)
    DIM b$
    b$ = MKI$(-1)
    SendData b$, OffsetNewDataFromPreview
END SUB

SUB __UI_MouseUp (id AS LONG)
    DIM b$
    b$ = MKI$(-1)
    SendData b$, OffsetNewDataFromPreview
END SUB

SUB __UI_BeforeUpdateDisplay
    DIM NewWindowTop AS INTEGER, NewWindowLeft AS INTEGER
    DIM b$, TempValue AS LONG, i AS LONG, UiEditorPID AS LONG
    STATIC MidRead AS _BYTE, UiEditorFile AS INTEGER

    SavePreview

    b$ = MKL$(UiPreviewPID)
    SendData b$, OffsetPreviewPID

    UiEditorFile = FREEFILE
    OPEN "UiEditor.dat" FOR BINARY AS #UiEditorFile

    IF NOT MidRead THEN
        MidRead = __UI_True
        b$ = SPACE$(4): GET #UiEditorFile, OffsetEditorPID, b$
        UiEditorPID = CVL(b$)

        $IF WIN THEN
            b$ = SPACE$(2): GET #UiEditorFile, OffsetWindowLeft, b$
            NewWindowLeft = CVI(b$)
            b$ = SPACE$(2): GET #UiEditorFile, OffsetWindowTop, b$
            NewWindowTop = CVI(b$)

            IF NewWindowLeft >= 0 AND NewWindowTop >= 0 AND (NewWindowLeft <> _SCREENX OR NewWindowTop <> _SCREENY) THEN
                _SCREENMOVE NewWindowLeft + 610, NewWindowTop
            END IF
        $END IF

        'Check if the editor is still alive
        $IF WIN THEN
            DIM hnd&, b&, ExitCode&
            hnd& = OpenProcess(&H400, 0, UiEditorPID)
            b& = GetExitCodeProcess(hnd&, ExitCode&)
            IF b& = 1 AND ExitCode& = 259 THEN
                'Editor is active.
            ELSE
                'Editor was closed.
                SYSTEM
            END IF
            b& = CloseHandle(hnd&)
        $ELSE
            IF PROCESS_CLOSED(UiEditorPID, 0) THEN SYSTEM
        $END IF

        'New control:
        DIM ThisContainer AS LONG, TempWidth AS INTEGER, TempHeight AS INTEGER
        b$ = SPACE$(2): GET #UiEditorFile, OffsetNewControl, b$
        TempValue = CVI(b$)
        b$ = MKI$(0): PUT #UiEditorFile, OffsetNewControl, b$
        IF TempValue > 0 THEN
            IF __UI_Controls(__UI_Controls(__UI_FirstSelectedID).ParentID).Type = __UI_Type_Frame THEN
                ThisContainer = __UI_Controls(__UI_FirstSelectedID).ParentID
                TempWidth = __UI_Controls(__UI_Controls(__UI_FirstSelectedID).ParentID).Width
                TempHeight = __UI_Controls(__UI_Controls(__UI_FirstSelectedID).ParentID).Height
            ELSEIF __UI_Controls(__UI_FirstSelectedID).Type = __UI_Type_Frame THEN
                ThisContainer = __UI_Controls(__UI_FirstSelectedID).ID
                TempWidth = __UI_Controls(__UI_FirstSelectedID).Width
                TempHeight = __UI_Controls(__UI_FirstSelectedID).Height
            ELSE
                TempWidth = __UI_Controls(__UI_FormID).Width
                TempHeight = __UI_Controls(__UI_FormID).Height
            END IF
            SELECT CASE TempValue
                CASE __UI_Type_Button
                    TempValue = __UI_NewControl(__UI_Type_Button, "", 80, 23, TempWidth \ 2 - 40, TempHeight \ 2 - 12, ThisContainer)
                CASE __UI_Type_Label, __UI_Type_CheckBox, __UI_Type_RadioButton
                    TempValue = __UI_NewControl(TempValue, "", 150, 23, TempWidth \ 2 - 75, TempHeight \ 2 - 12, ThisContainer)
                    __UI_SetCaption __UI_Controls(TempValue).Name, RTRIM$(__UI_Controls(TempValue).Name)
                CASE __UI_Type_TextBox
                    TempValue = __UI_NewControl(__UI_Type_TextBox, "", 120, 23, TempWidth \ 2 - 60, TempHeight \ 2 - 12, ThisContainer)
                    IF _FONTWIDTH(__UI_Controls(TempValue).Font) = 0 THEN __UI_Controls(TempValue).Font = __UI_Font("", 16, "")
                    __UI_Controls(TempValue).FieldArea = __UI_Controls(TempValue).Width \ _FONTWIDTH(__UI_Controls(TempValue).Font) - 1
                    __UI_SetCaption __UI_Controls(TempValue).Name, RTRIM$(__UI_Controls(TempValue).Name)
                CASE __UI_Type_ListBox
                    TempValue = __UI_NewControl(__UI_Type_ListBox, "", 200, 200, TempWidth \ 2 - 100, TempHeight \ 2 - 100, ThisContainer)
                    __UI_Controls(TempValue).HasBorder = __UI_True
                CASE __UI_Type_DropdownList
                    TempValue = __UI_NewControl(__UI_Type_DropdownList, "", 200, 23, TempWidth \ 2 - 100, TempHeight \ 2 - 12, ThisContainer)
                CASE __UI_Type_TrackBar
                    TempValue = __UI_NewControl(__UI_Type_TrackBar, "", 300, 45, TempWidth \ 2 - 150, TempHeight \ 2 - 23, ThisContainer)
                CASE __UI_Type_ProgressBar
                    TempValue = __UI_NewControl(__UI_Type_ProgressBar, "", 300, 23, TempWidth \ 2 - 150, TempHeight \ 2 - 12, ThisContainer)
                CASE __UI_Type_PictureBox
                    TempValue = __UI_NewControl(TempValue, "", 230, 150, TempWidth \ 2 - 115, TempHeight \ 2 - 75, ThisContainer)
                CASE __UI_Type_Frame
                    TempValue = __UI_NewControl(TempValue, "", 230, 150, TempWidth \ 2 - 115, TempHeight \ 2 - 75, 0)
                    __UI_SetCaption __UI_Controls(TempValue).Name, RTRIM$(__UI_Controls(TempValue).Name)
            END SELECT
            FOR i = 1 TO UBOUND(__UI_Controls)
                __UI_Controls(i).ControlIsSelected = __UI_False
            NEXT
            __UI_Controls(TempValue).ControlIsSelected = __UI_True
            __UI_TotalSelectedControls = 1
            __UI_FirstSelectedID = TempValue
            __UI_ForceRedraw = __UI_True
        END IF

        b$ = SPACE$(2): GET #UiEditorFile, OffsetNewDataFromEditor, b$
        TempValue = CVI(b$)
        b$ = MKI$(0): PUT #UiEditorFile, OffsetNewDataFromEditor, b$
        IF TempValue = -1 THEN
            DIM FloatValue AS _FLOAT
            'Editor sent property value
            b$ = SPACE$(2): GET #UiEditorFile, OffsetPropertyChanged, b$
            TempValue = CVI(b$)
            SELECT CASE TempValue
                CASE 1 'Name
                    b$ = SPACE$(4): GET #UiEditorFile, OffsetPropertyValue, b$
                    b$ = SPACE$(CVL(b$)): GET #UiEditorFile, , b$
                    IF __UI_TotalSelectedControls = 1 THEN
                        IF __UI_GetID(b$) > 0 AND __UI_GetID(b$) <> __UI_FirstSelectedID THEN
                            DO
                                b$ = b$ + "_"
                                IF __UI_GetID(b$) = 0 THEN EXIT DO
                            LOOP
                        END IF
                        __UI_Controls(__UI_FirstSelectedID).Name = b$
                    ELSE
                        IF __UI_GetID(b$) > 0 AND __UI_GetID(b$) <> __UI_FormID THEN
                            DO
                                b$ = b$ + "_"
                                IF __UI_GetID(b$) = 0 THEN EXIT DO
                            LOOP
                        END IF
                        __UI_Controls(__UI_FormID).Name = b$
                    END IF
                CASE 2 'Caption
                    b$ = SPACE$(4): GET #UiEditorFile, OffsetPropertyValue, b$
                    b$ = SPACE$(CVL(b$)): GET #UiEditorFile, , b$
                    IF __UI_TotalSelectedControls > 0 THEN
                        FOR i = 1 TO UBOUND(__UI_Controls)
                            IF __UI_Controls(i).ControlIsSelected THEN
                                __UI_SetCaption RTRIM$(__UI_Controls(i).Name), b$
                            END IF
                        NEXT
                    ELSE
                        __UI_Captions(__UI_FormID) = b$
                    END IF
                CASE 3 'Text
                    DIM TotalReplacements AS LONG
                    b$ = SPACE$(4): GET #UiEditorFile, OffsetPropertyValue, b$
                    b$ = SPACE$(CVL(b$)): GET #UiEditorFile, , b$
                    IF __UI_TotalSelectedControls > 0 THEN
                        FOR i = 1 TO UBOUND(__UI_Controls)
                            IF __UI_Controls(i).ControlIsSelected THEN
                                __UI_Texts(i) = b$
                                IF __UI_Controls(i).Type = __UI_Type_Button OR __UI_Controls(i).Type = __UI_Type_PictureBox THEN
                                    __UI_LoadImage __UI_Controls(i), b$
                                ELSEIF __UI_Controls(i).Type = __UI_Type_ListBox OR __UI_Controls(i).Type = __UI_Type_DropdownList THEN
                                    __UI_Texts(i) = __UI_ReplaceText(b$, "\n", CHR$(13), __UI_False, TotalReplacements)
                                    IF __UI_Controls(i).Max < TotalReplacements + 1 THEN __UI_Controls(i).Max = TotalReplacements + 1
                                    __UI_Controls(i).LastVisibleItem = 0 'Reset it so it's recalculated
                                END IF
                            END IF
                        NEXT
                    ELSE
                        IF ExeIcon <> 0 THEN _FREEIMAGE ExeIcon: ExeIcon = 0
                        ExeIcon = IconPreview&(b$)
                        IF ExeIcon < -1 THEN
                            _ICON ExeIcon
                            __UI_Texts(__UI_FormID) = b$
                        ELSE
                            _ICON
                            __UI_Texts(__UI_FormID) = ""
                        END IF
                    END IF
                CASE 4 'Top
                    b$ = SPACE$(2): GET #UiEditorFile, OffsetPropertyValue, b$
                    TempValue = CVI(b$)
                    FOR i = 1 TO UBOUND(__UI_Controls)
                        IF __UI_Controls(i).ControlIsSelected THEN
                            __UI_Controls(i).Top = TempValue
                        END IF
                    NEXT
                CASE 5 'Left
                    b$ = SPACE$(2): GET #UiEditorFile, OffsetPropertyValue, b$
                    TempValue = CVI(b$)
                    FOR i = 1 TO UBOUND(__UI_Controls)
                        IF __UI_Controls(i).ControlIsSelected THEN
                            __UI_Controls(i).Left = TempValue
                        END IF
                    NEXT
                CASE 6 'Width
                    b$ = SPACE$(2): GET #UiEditorFile, OffsetPropertyValue, b$
                    TempValue = CVI(b$)
                    IF TempValue < 1 THEN TempValue = 1
                    IF __UI_TotalSelectedControls > 0 THEN
                        FOR i = 1 TO UBOUND(__UI_Controls)
                            IF __UI_Controls(i).ControlIsSelected THEN
                                __UI_Controls(i).Width = TempValue
                            END IF
                        NEXT
                    ELSE
                        IF TempValue < 20 THEN TempValue = 20
                        __UI_Controls(__UI_FormID).Width = TempValue
                    END IF
                CASE 7 'Height
                    b$ = SPACE$(2): GET #UiEditorFile, OffsetPropertyValue, b$
                    TempValue = CVI(b$)
                    IF TempValue < 1 THEN TempValue = 1
                    IF __UI_TotalSelectedControls > 0 THEN
                        FOR i = 1 TO UBOUND(__UI_Controls)
                            IF __UI_Controls(i).ControlIsSelected THEN
                                __UI_Controls(i).Height = TempValue
                            END IF
                        NEXT
                    ELSE
                        IF TempValue < 20 THEN TempValue = 20
                        __UI_Controls(__UI_FormID).Height = TempValue
                    END IF
                CASE 8 'Font
                    b$ = SPACE$(4): GET #UiEditorFile, OffsetPropertyValue, b$
                    b$ = SPACE$(CVL(b$)): GET #UiEditorFile, , b$
                    DIM NewFontFile AS STRING
                    DIM NewFontSize AS INTEGER, NewFontParameters AS STRING
                    DIM FindSep AS INTEGER, TotalSep AS INTEGER

                    'Parse b$ into Font data
                    FindSep = INSTR(b$, "*")
                    IF FindSep THEN TotalSep = TotalSep + 1
                    NewFontFile = LEFT$(b$, FindSep - 1)
                    b$ = MID$(b$, FindSep + 1)

                    FindSep = INSTR(b$, "*")
                    IF FindSep THEN TotalSep = TotalSep + 1
                    NewFontParameters = LEFT$(b$, FindSep - 1)
                    b$ = MID$(b$, FindSep + 1)

                    NewFontSize = VAL(b$)

                    IF TotalSep = 2 AND NewFontSize > 0 THEN
                        IF __UI_TotalSelectedControls > 0 THEN
                            FOR i = 1 TO UBOUND(__UI_Controls)
                                IF __UI_Controls(i).ControlIsSelected THEN
                                    __UI_Controls(i).Font = __UI_Font(NewFontFile, NewFontSize, NewFontParameters)
                                END IF
                            NEXT
                        ELSE
                            __UI_Controls(__UI_FormID).Font = __UI_Font(NewFontFile, NewFontSize, NewFontParameters)
                        END IF
                    END IF
                CASE 9 'Tooltip
                    b$ = SPACE$(4): GET #UiEditorFile, OffsetPropertyValue, b$
                    b$ = SPACE$(CVL(b$)): GET #UiEditorFile, , b$
                    FOR i = 1 TO UBOUND(__UI_Controls)
                        IF __UI_Controls(i).ControlIsSelected THEN
                            __UI_Tips(i) = b$
                        END IF
                    NEXT
                CASE 10 'Value
                    b$ = SPACE$(LEN(FloatValue)): GET #UiEditorFile, OffsetPropertyValue, b$
                    FOR i = 1 TO UBOUND(__UI_Controls)
                        IF __UI_Controls(i).ControlIsSelected THEN
                            __UI_Controls(i).Value = _CV(_FLOAT, b$)
                        END IF
                    NEXT
                CASE 11 'Min
                    b$ = SPACE$(LEN(FloatValue)): GET #UiEditorFile, OffsetPropertyValue, b$
                    FOR i = 1 TO UBOUND(__UI_Controls)
                        IF __UI_Controls(i).ControlIsSelected THEN
                            __UI_Controls(i).Min = _CV(_FLOAT, b$)
                        END IF
                    NEXT
                CASE 12 'Max
                    b$ = SPACE$(LEN(FloatValue)): GET #UiEditorFile, OffsetPropertyValue, b$
                    FOR i = 1 TO UBOUND(__UI_Controls)
                        IF __UI_Controls(i).ControlIsSelected THEN
                            __UI_Controls(i).Max = _CV(_FLOAT, b$)
                        END IF
                    NEXT
                CASE 13 'Interval
                    b$ = SPACE$(LEN(FloatValue)): GET #UiEditorFile, OffsetPropertyValue, b$
                    FOR i = 1 TO UBOUND(__UI_Controls)
                        IF __UI_Controls(i).ControlIsSelected THEN
                            __UI_Controls(i).Interval = _CV(_FLOAT, b$)
                        END IF
                    NEXT
                CASE 14 'Stretch
                    b$ = SPACE$(2): GET #UiEditorFile, OffsetPropertyValue, b$
                    FOR i = 1 TO UBOUND(__UI_Controls)
                        IF __UI_Controls(i).ControlIsSelected THEN
                            __UI_Controls(i).Stretch = CVI(b$)
                        END IF
                    NEXT
                CASE 15 'Has border
                    b$ = SPACE$(2): GET #UiEditorFile, OffsetPropertyValue, b$
                    FOR i = 1 TO UBOUND(__UI_Controls)
                        IF __UI_Controls(i).ControlIsSelected THEN
                            __UI_Controls(i).HasBorder = CVI(b$)
                        END IF
                    NEXT
                CASE 16 'Show percentage
                    b$ = SPACE$(2): GET #UiEditorFile, OffsetPropertyValue, b$
                    FOR i = 1 TO UBOUND(__UI_Controls)
                        IF __UI_Controls(i).ControlIsSelected THEN
                            __UI_Controls(i).ShowPercentage = CVI(b$)
                        END IF
                    NEXT
                CASE 17 'Word wrap
                    b$ = SPACE$(2): GET #UiEditorFile, OffsetPropertyValue, b$
                    FOR i = 1 TO UBOUND(__UI_Controls)
                        IF __UI_Controls(i).ControlIsSelected THEN
                            __UI_Controls(i).WordWrap = CVI(b$)
                        END IF
                    NEXT
                CASE 18 'Can have focus
                    b$ = SPACE$(2): GET #UiEditorFile, OffsetPropertyValue, b$
                    FOR i = 1 TO UBOUND(__UI_Controls)
                        IF __UI_Controls(i).ControlIsSelected THEN
                            __UI_Controls(i).CanHaveFocus = CVI(b$)
                        END IF
                    NEXT
                CASE 19 'Disabled
                    b$ = SPACE$(2): GET #UiEditorFile, OffsetPropertyValue, b$
                    FOR i = 1 TO UBOUND(__UI_Controls)
                        IF __UI_Controls(i).ControlIsSelected THEN
                            __UI_Controls(i).Disabled = CVI(b$)
                        END IF
                    NEXT
                CASE 20 'Hidden
                    b$ = SPACE$(2): GET #UiEditorFile, OffsetPropertyValue, b$
                    FOR i = 1 TO UBOUND(__UI_Controls)
                        IF __UI_Controls(i).ControlIsSelected THEN
                            __UI_Controls(i).Hidden = CVI(b$)
                        END IF
                    NEXT
                CASE 21 'CenteredWindow
                    b$ = SPACE$(2): GET #UiEditorFile, OffsetPropertyValue, b$
                    TempValue = CVI(b$)
                    IF __UI_TotalSelectedControls = 0 THEN
                        __UI_Controls(__UI_FormID).CenteredWindow = TempValue
                    END IF
                CASE 22 'Alignment
                    b$ = SPACE$(2): GET #UiEditorFile, OffsetPropertyValue, b$
                    FOR i = 1 TO UBOUND(__UI_Controls)
                        IF __UI_Controls(i).ControlIsSelected THEN
                            __UI_Controls(i).Align = CVI(b$)
                        END IF
                    NEXT
                CASE 23 'ForeColor
                    b$ = SPACE$(4): GET #UiEditorFile, OffsetPropertyValue, b$
                    IF __UI_TotalSelectedControls > 0 THEN
                        FOR i = 1 TO UBOUND(__UI_Controls)
                            IF __UI_Controls(i).ControlIsSelected THEN
                                __UI_Controls(i).ForeColor = _CV(_UNSIGNED LONG, b$)
                            END IF
                        NEXT
                    ELSE
                        __UI_Controls(__UI_FormID).ForeColor = _CV(_UNSIGNED LONG, b$)
                    END IF
                CASE 24 'BackColor
                    b$ = SPACE$(4): GET #UiEditorFile, OffsetPropertyValue, b$
                    IF __UI_TotalSelectedControls > 0 THEN
                        FOR i = 1 TO UBOUND(__UI_Controls)
                            IF __UI_Controls(i).ControlIsSelected THEN
                                __UI_Controls(i).BackColor = _CV(_UNSIGNED LONG, b$)
                            END IF
                        NEXT
                    ELSE
                        __UI_Controls(__UI_FormID).BackColor = _CV(_UNSIGNED LONG, b$)
                    END IF
                CASE 25 'SelectedForeColor
                    b$ = SPACE$(4): GET #UiEditorFile, OffsetPropertyValue, b$
                    IF __UI_TotalSelectedControls > 0 THEN
                        FOR i = 1 TO UBOUND(__UI_Controls)
                            IF __UI_Controls(i).ControlIsSelected THEN
                                __UI_Controls(i).SelectedForeColor = _CV(_UNSIGNED LONG, b$)
                            END IF
                        NEXT
                    ELSE
                        __UI_Controls(__UI_FormID).SelectedForeColor = _CV(_UNSIGNED LONG, b$)
                    END IF
                CASE 26 'SelectedBackColor
                    b$ = SPACE$(4): GET #UiEditorFile, OffsetPropertyValue, b$
                    IF __UI_TotalSelectedControls > 0 THEN
                        FOR i = 1 TO UBOUND(__UI_Controls)
                            IF __UI_Controls(i).ControlIsSelected THEN
                                __UI_Controls(i).SelectedBackColor = _CV(_UNSIGNED LONG, b$)
                            END IF
                        NEXT
                    ELSE
                        __UI_Controls(__UI_FormID).SelectedBackColor = _CV(_UNSIGNED LONG, b$)
                    END IF
                CASE 27 'BorderColor
                    b$ = SPACE$(4): GET #UiEditorFile, OffsetPropertyValue, b$
                    IF __UI_TotalSelectedControls > 0 THEN
                        FOR i = 1 TO UBOUND(__UI_Controls)
                            IF __UI_Controls(i).ControlIsSelected THEN
                                __UI_Controls(i).BorderColor = _CV(_UNSIGNED LONG, b$)
                            END IF
                        NEXT
                    ELSE
                        __UI_Controls(__UI_FormID).BorderColor = _CV(_UNSIGNED LONG, b$)
                    END IF
                CASE 28 'BackStyle
                    b$ = SPACE$(2): GET #UiEditorFile, OffsetPropertyValue, b$
                    FOR i = 1 TO UBOUND(__UI_Controls)
                        IF __UI_Controls(i).ControlIsSelected THEN
                            __UI_Controls(i).BackStyle = CVI(b$)
                        END IF
                    NEXT
                CASE 29 'CanResize
                    b$ = SPACE$(2): GET #UiEditorFile, OffsetPropertyValue, b$
                    TempValue = CVI(b$)
                    IF __UI_TotalSelectedControls = 0 THEN
                        __UI_Controls(__UI_FormID).CanResize = TempValue
                    END IF
                CASE 31 'Padding
                    b$ = SPACE$(2): GET #UiEditorFile, OffsetPropertyValue, b$
                    TempValue = CVI(b$)
                    IF __UI_TotalSelectedControls > 0 THEN
                        FOR i = 1 TO UBOUND(__UI_Controls)
                            IF __UI_Controls(i).ControlIsSelected THEN
                                __UI_Controls(i).Padding = TempValue
                            END IF
                        NEXT
                    END IF
            END SELECT
            __UI_ForceRedraw = __UI_True
        END IF

        b$ = MKL$(__UI_TotalSelectedControls)
        PUT #UiEditorFile, OffsetTotalControlsSelected, b$
        b$ = MKL$(__UI_FirstSelectedID)
        PUT #UiEditorFile, OffsetFirstSelectedID, b$
        b$ = MKL$(__UI_FormID)
        PUT #UiEditorFile, OffsetFormID, b$

        MidRead = __UI_False
        CLOSE #UiEditorFile
    END IF
END SUB

SUB __UI_BeforeUnload
    'DIM Answer AS _BYTE
    'Answer = __UI_MessageBox("Leaving UI", "Copy current form data to clipboard?", __UI_MsgBox_YesNoCancel + __UI_MsgBox_Question)
    'IF Answer = __UI_MsgBox_Cancel THEN
    '    __UI_UnloadSignal = __UI_False
    'ELSEIF Answer = __UI_MsgBox_Yes THEN
    '    Answer = __UI_MessageBox("Leaving UI", "Not yet implemented", __UI_MsgBox_OkOnly + __UI_MsgBox_Information)
    'END IF
END SUB

SUB __UI_OnLoad
    DIM b$
    __UI_DesignMode = __UI_True

    UiPreviewPID = __UI_GetPID

    LoadPreview
END SUB

SUB __UI_KeyPress (id AS LONG)
END SUB

SUB __UI_ValueChanged (id AS LONG)
END SUB

SUB LoadPreview
    DIM a$, b$, i AS LONG, __UI_EOF AS _BYTE, Answer AS _BYTE
    DIM NewType AS INTEGER, NewWidth AS INTEGER, NewHeight AS INTEGER
    DIM NewLeft AS INTEGER, NewTop AS INTEGER, NewName AS STRING
    DIM NewParentID AS STRING, FloatValue AS _FLOAT, TempValue AS LONG
    DIM BinaryFileNum AS INTEGER, LogFileNum AS INTEGER

    CONST LogFileLoad = __UI_False

    IF _FILEEXISTS("UiEditorPreview.frmbin") = 0 THEN
        EXIT SUB
    ELSE
        BinaryFileNum = FREEFILE
        OPEN "UiEditorPreview.frmbin" FOR BINARY AS #BinaryFileNum

        LogFileNum = FREEFILE
        IF LogFileLoad THEN OPEN "ui_log.txt" FOR OUTPUT AS #LogFileNum
        b$ = SPACE$(7): GET #BinaryFileNum, 1, b$
        IF b$ <> "InForm" + CHR$(1) THEN
            GOTO LoadError
            EXIT SUB
        END IF
        IF LogFileLoad THEN PRINT #LogFileNum, "FOUND INFORM+1"
        __UI_AutoRefresh = __UI_False
        FOR i = 1 TO UBOUND(__UI_Controls)
            __UI_DestroyControl __UI_Controls(i)
        NEXT
        IF LogFileLoad THEN PRINT #LogFileNum, "DESTROYED CONTROLS"

        b$ = SPACE$(4): GET #BinaryFileNum, , b$
        IF LogFileLoad THEN PRINT #LogFileNum, "READ NEW ARRAYS:" + STR$(CVL(b$))

        REDIM _PRESERVE __UI_Captions(1 TO CVL(b$)) AS STRING
        REDIM _PRESERVE __UI_TempCaptions(1 TO CVL(b$)) AS STRING
        REDIM _PRESERVE __UI_Texts(1 TO CVL(b$)) AS STRING
        REDIM _PRESERVE __UI_TempTexts(1 TO CVL(b$)) AS STRING
        REDIM _PRESERVE __UI_Tips(1 TO CVL(b$)) AS STRING
        REDIM _PRESERVE __UI_Controls(0 TO CVL(b$)) AS __UI_ControlTYPE
        b$ = SPACE$(2): GET #BinaryFileNum, , b$
        IF LogFileLoad THEN PRINT #LogFileNum, "READ NEW CONTROL:" + STR$(CVI(b$))
        IF CVI(b$) <> -1 THEN GOTO LoadError
        DO
            b$ = SPACE$(4): GET #BinaryFileNum, , b$ 'skip id number
            b$ = SPACE$(2): GET #BinaryFileNum, , b$
            NewType = CVI(b$)
            IF LogFileLoad THEN PRINT #LogFileNum, "TYPE:" + STR$(CVI(b$))
            b$ = SPACE$(2): GET #BinaryFileNum, , b$
            b$ = SPACE$(CVI(b$)): GET #BinaryFileNum, , b$
            NewName = b$
            IF LogFileLoad THEN PRINT #LogFileNum, "NAME:" + NewName
            b$ = SPACE$(2): GET #BinaryFileNum, , b$
            NewWidth = CVI(b$)
            IF LogFileLoad THEN PRINT #LogFileNum, "WIDTH:" + STR$(CVI(b$))
            b$ = SPACE$(2): GET #BinaryFileNum, , b$
            NewHeight = CVI(b$)
            IF LogFileLoad THEN PRINT #LogFileNum, "HEIGHT:" + STR$(CVI(b$))
            b$ = SPACE$(2): GET #BinaryFileNum, , b$
            NewLeft = CVI(b$)
            IF LogFileLoad THEN PRINT #LogFileNum, "LEFT:" + STR$(CVI(b$))
            b$ = SPACE$(2): GET #BinaryFileNum, , b$
            NewTop = CVI(b$)
            IF LogFileLoad THEN PRINT #LogFileNum, "TOP:" + STR$(CVI(b$))
            b$ = SPACE$(2): GET #BinaryFileNum, , b$
            NewParentID = SPACE$(CVI(b$)): GET #BinaryFileNum, , NewParentID
            IF LogFileLoad THEN PRINT #LogFileNum, "PARENT:" + NewParentID

            IF NewType = __UI_Type_Form THEN
                IF NewWidth <> _WIDTH OR NewHeight <> _HEIGHT THEN
                    DIM OldScreen&
                    OldScreen& = _DEST
                    SCREEN _NEWIMAGE(NewWidth, NewHeight, 32)
                    _FREEIMAGE OldScreen&
                END IF
            END IF

            TempValue = __UI_NewControl(NewType, NewName, NewWidth, NewHeight, NewLeft, NewTop, __UI_GetID(NewParentID))

            DO 'read properties
                b$ = SPACE$(2): GET #BinaryFileNum, , b$
                IF LogFileLoad THEN PRINT #LogFileNum, "PROPERTY:" + STR$(CVI(b$)) + " :";
                SELECT CASE CVI(b$)
                    CASE -2 'Caption
                        b$ = SPACE$(4): GET #BinaryFileNum, , b$
                        b$ = SPACE$(CVL(b$))
                        GET #BinaryFileNum, , b$
                        __UI_SetCaption RTRIM$(__UI_Controls(TempValue).Name), b$
                        IF LogFileLoad THEN PRINT #LogFileNum, "CAPTION:" + __UI_Captions(TempValue)
                    CASE -3 'Text
                        b$ = SPACE$(4): GET #BinaryFileNum, , b$
                        b$ = SPACE$(CVL(b$))
                        GET #BinaryFileNum, , b$
                        __UI_Texts(TempValue) = b$
                        IF __UI_Controls(TempValue).Type = __UI_Type_PictureBox OR __UI_Controls(TempValue).Type = __UI_Type_Button THEN
                            __UI_LoadImage __UI_Controls(TempValue), __UI_Texts(TempValue)
                        ELSEIF __UI_Controls(TempValue).Type = __UI_Type_Form THEN
                            IF ExeIcon <> 0 THEN _FREEIMAGE ExeIcon: ExeIcon = 0
                            ExeIcon = IconPreview&(b$)
                            IF ExeIcon < -1 THEN
                                _ICON ExeIcon
                            END IF
                        END IF
                        IF LogFileLoad THEN PRINT #LogFileNum, "TEXT:" + __UI_Texts(TempValue)
                    CASE -4 'Stretch
                        __UI_Controls(TempValue).Stretch = __UI_True
                        IF LogFileLoad THEN PRINT #LogFileNum, "STRETCH"
                    CASE -5 'Font
                        IF LogFileLoad THEN PRINT #LogFileNum, "FONT:";
                        DIM FontSetup$, FindSep AS INTEGER
                        DIM NewFontName AS STRING, NewFontFile AS STRING
                        DIM NewFontSize AS INTEGER, NewFontAttributes AS STRING
                        b$ = SPACE$(2): GET #BinaryFileNum, , b$
                        FontSetup$ = SPACE$(CVI(b$)): GET #BinaryFileNum, , FontSetup$
                        IF LogFileLoad THEN PRINT #LogFileNum, FontSetup$

                        FindSep = INSTR(FontSetup$, "*")
                        NewFontFile = LEFT$(FontSetup$, FindSep - 1): FontSetup$ = MID$(FontSetup$, FindSep + 1)

                        FindSep = INSTR(FontSetup$, "*")
                        NewFontAttributes = LEFT$(FontSetup$, FindSep - 1): FontSetup$ = MID$(FontSetup$, FindSep + 1)

                        NewFontSize = VAL(FontSetup$)

                        __UI_Controls(TempValue).Font = __UI_Font(NewFontFile, NewFontSize, NewFontAttributes)
                    CASE -6 'ForeColor
                        b$ = SPACE$(4): GET #BinaryFileNum, , b$
                        __UI_Controls(TempValue).ForeColor = _CV(_UNSIGNED LONG, b$)
                        IF LogFileLoad THEN PRINT #LogFileNum, "FORECOLOR"
                    CASE -7 'BackColor
                        b$ = SPACE$(4): GET #BinaryFileNum, , b$
                        __UI_Controls(TempValue).BackColor = _CV(_UNSIGNED LONG, b$)
                        IF LogFileLoad THEN PRINT #LogFileNum, "BACKCOLOR"
                    CASE -8 'SelectedForeColor
                        b$ = SPACE$(4): GET #BinaryFileNum, , b$
                        __UI_Controls(TempValue).SelectedForeColor = _CV(_UNSIGNED LONG, b$)
                        IF LogFileLoad THEN PRINT #LogFileNum, "SELECTEDFORECOLOR"
                    CASE -9 'SelectedBackColor
                        b$ = SPACE$(4): GET #BinaryFileNum, , b$
                        __UI_Controls(TempValue).SelectedBackColor = _CV(_UNSIGNED LONG, b$)
                        IF LogFileLoad THEN PRINT #LogFileNum, "SELECTEDBACKCOLOR"
                    CASE -10 'BorderColor
                        b$ = SPACE$(4): GET #BinaryFileNum, , b$
                        __UI_Controls(TempValue).BorderColor = _CV(_UNSIGNED LONG, b$)
                        IF LogFileLoad THEN PRINT #LogFileNum, "BORDERCOLOR"
                    CASE -11
                        __UI_Controls(TempValue).BackStyle = __UI_Transparent
                        IF LogFileLoad THEN PRINT #LogFileNum, "BACKSTYLE:TRANSPARENT"
                    CASE -12
                        __UI_Controls(TempValue).HasBorder = __UI_True
                        IF LogFileLoad THEN PRINT #LogFileNum, "HASBORDER"
                    CASE -13
                        b$ = SPACE$(1): GET #BinaryFileNum, , b$
                        __UI_Controls(TempValue).Align = _CV(_BYTE, b$)
                        IF LogFileLoad THEN PRINT #LogFileNum, "ALIGN="; __UI_Controls(TempValue).Align
                    CASE -14
                        b$ = SPACE$(LEN(FloatValue)): GET #BinaryFileNum, , b$
                        __UI_Controls(TempValue).Value = _CV(_FLOAT, b$)
                        IF LogFileLoad THEN PRINT #LogFileNum, "VALUE="; __UI_Controls(TempValue).Value
                    CASE -15
                        b$ = SPACE$(LEN(FloatValue)): GET #BinaryFileNum, , b$
                        __UI_Controls(TempValue).Min = _CV(_FLOAT, b$)
                        IF LogFileLoad THEN PRINT #LogFileNum, "MIN="; __UI_Controls(TempValue).Min
                    CASE -16
                        b$ = SPACE$(LEN(FloatValue)): GET #BinaryFileNum, , b$
                        __UI_Controls(TempValue).Max = _CV(_FLOAT, b$)
                        IF LogFileLoad THEN PRINT #LogFileNum, "MAX="; __UI_Controls(TempValue).Max
                    CASE -17
                        b$ = SPACE$(2): GET #BinaryFileNum, , b$
                        __UI_Controls(TempValue).HotKey = CVI(b$)
                        IF LogFileLoad THEN PRINT #LogFileNum, "HOTKEY="; __UI_Controls(TempValue).HotKey; "("; CHR$(__UI_Controls(TempValue).HotKey); ")"
                    CASE -18
                        b$ = SPACE$(2): GET #BinaryFileNum, , b$
                        __UI_Controls(TempValue).HotKeyOffset = CVI(b$)
                        IF LogFileLoad THEN PRINT #LogFileNum, "HOTKEYOFFSET="; __UI_Controls(TempValue).HotKeyOffset
                    CASE -19
                        __UI_Controls(TempValue).ShowPercentage = __UI_True
                        IF LogFileLoad THEN PRINT #LogFileNum, "SHOWPERCENTAGE"
                    CASE -20
                        __UI_Controls(TempValue).CanHaveFocus = __UI_True
                        IF LogFileLoad THEN PRINT #LogFileNum, "CANHAVEFOCUS"
                    CASE -21
                        __UI_Controls(TempValue).Disabled = __UI_True
                        IF LogFileLoad THEN PRINT #LogFileNum, "DISABLED"
                    CASE -22
                        __UI_Controls(TempValue).Hidden = __UI_True
                        IF LogFileLoad THEN PRINT #LogFileNum, "HIDDEN"
                    CASE -23
                        __UI_Controls(TempValue).CenteredWindow = __UI_True
                        IF LogFileLoad THEN PRINT #LogFileNum, "CENTEREDWINDOW"
                    CASE -24 'Tips
                        b$ = SPACE$(4): GET #BinaryFileNum, , b$
                        b$ = SPACE$(CVL(b$))
                        GET #BinaryFileNum, , b$
                        __UI_Tips(TempValue) = b$
                        IF LogFileLoad THEN PRINT #LogFileNum, "TIP: "; __UI_Tips(TempValue)
                    CASE -25
                        DIM ContextMenuName AS STRING
                        b$ = SPACE$(2): GET #BinaryFileNum, , b$
                        ContextMenuName = SPACE$(CVI(b$)): GET #BinaryFileNum, , ContextMenuName
                        __UI_Controls(TempValue).ContextMenuID = __UI_GetID(ContextMenuName)
                        IF LogFileLoad THEN PRINT #LogFileNum, "CONTEXTMENU:"; ContextMenuName
                    CASE -26
                        b$ = SPACE$(LEN(FloatValue)): GET #BinaryFileNum, , b$
                        __UI_Controls(TempValue).Interval = _CV(_FLOAT, b$)
                        IF LogFileLoad THEN PRINT #LogFileNum, "INTERVAL="; __UI_Controls(TempValue).Interval
                    CASE -27
                        __UI_Controls(TempValue).WordWrap = __UI_True
                        IF LogFileLoad THEN PRINT #LogFileNum, "WORDWRAP"
                    CASE -28
                        b$ = SPACE$(4): GET #BinaryFileNum, , b$
                        __UI_Controls(TempValue).TransparentColor = _CV(_UNSIGNED LONG, b$)
                        IF LogFileLoad THEN PRINT #LogFileNum, "TRANSPARENTCOLOR"
                        __UI_ClearColor __UI_Controls(TempValue).HelperCanvas, __UI_Controls(TempValue).TransparentColor, -1
                    CASE -29
                        __UI_Controls(TempValue).CanResize = __UI_True
                        IF LogFileLoad THEN PRINT #LogFileNum, "CANRESIZE"
                    CASE -31
                        b$ = SPACE$(2): GET #BinaryFileNum, , b$
                        __UI_Controls(TempValue).Padding = CVI(b$)
                        IF LogFileLoad THEN PRINT #LogFileNum, "PADDING" + STR$(CVI(b$))
                    CASE -1 'new control
                        IF LogFileLoad THEN PRINT #LogFileNum, "READ NEW CONTROL:-1"
                        EXIT DO
                    CASE -1024
                        IF LogFileLoad THEN PRINT #LogFileNum, "READ END OF FILE:-1024"
                        __UI_EOF = __UI_True
                        EXIT DO
                    CASE ELSE
                        IF LogFileLoad THEN PRINT #LogFileNum, "UNKNOWN DATA="; CVI(b$)
                        EXIT DO
                END SELECT
            LOOP
        LOOP UNTIL __UI_EOF
        CLOSE #BinaryFileNum
        IF LogFileLoad THEN CLOSE #LogFileNum
        __UI_AutoRefresh = __UI_True
        EXIT SUB

        LoadError:
        __UI_AutoRefresh = __UI_True
        CLOSE #BinaryFileNum
        EXIT SUB
    END IF
END SUB

SUB SavePreview
    DIM b$, i AS LONG, a$, FontSetup$, TempValue AS LONG
    DIM BinFileNum AS INTEGER, TxtFileNum AS INTEGER

    CONST Debug = __UI_False

    BinFileNum = FREEFILE
    OPEN "UiEditorPreview.frmbin" FOR BINARY AS #BinFileNum

    IF Debug THEN
        TxtFileNum = FREEFILE
        OPEN "UiEditorPreview.txt" FOR OUTPUT AS #TxtFileNum
    END IF

    b$ = "InForm" + CHR$(1)
    PUT #BinFileNum, 1, b$
    b$ = MKL$(UBOUND(__UI_Controls))
    PUT #BinFileNum, , b$
    FOR i = 1 TO UBOUND(__UI_Controls)
        IF Debug THEN
            PRINT #TxtFileNum, __UI_Controls(i).ID,
            PRINT #TxtFileNum, RTRIM$(__UI_Controls(i).Name)
        END IF
        IF __UI_Controls(i).ID > 0 AND __UI_Controls(i).Type <> __UI_Type_MenuPanel AND __UI_Controls(i).Type <> __UI_Type_Font AND LEN(RTRIM$(__UI_Controls(i).Name)) > 0 THEN
            b$ = MKI$(-1) + MKL$(i) + MKI$(__UI_Controls(i).Type) '-1 indicates a new control
            b$ = b$ + MKI$(LEN(RTRIM$(__UI_Controls(i).Name)))
            b$ = b$ + RTRIM$(__UI_Controls(i).Name)
            b$ = b$ + MKI$(__UI_Controls(i).Width) + MKI$(__UI_Controls(i).Height) + MKI$(__UI_Controls(i).Left) + MKI$(__UI_Controls(i).Top)
            IF __UI_Controls(i).ParentID > 0 THEN
                b$ = b$ + MKI$(LEN(RTRIM$(__UI_Controls(__UI_Controls(i).ParentID).Name))) + RTRIM$(__UI_Controls(__UI_Controls(i).ParentID).Name)
            ELSE
                b$ = b$ + MKI$(0)
            END IF
            PUT #BinFileNum, , b$

            IF LEN(__UI_Captions(i)) > 0 THEN
                IF __UI_Controls(i).HotKeyPosition > 0 THEN
                    a$ = LEFT$(__UI_Captions(i), __UI_Controls(i).HotKeyPosition - 1) + "&" + MID$(__UI_Captions(i), __UI_Controls(i).HotKeyPosition)
                ELSE
                    a$ = __UI_Captions(i)
                END IF
                b$ = MKI$(-2) + MKL$(LEN(a$)) '-2 indicates a caption
                PUT #BinFileNum, , b$
                PUT #BinFileNum, , a$
            END IF

            IF LEN(__UI_Tips(i)) > 0 THEN
                b$ = MKI$(-24) + MKL$(LEN(__UI_Tips(i))) '-24 indicates a tip
                PUT #BinFileNum, , b$
                PUT #BinFileNum, , __UI_Tips(i)
            END IF

            IF LEN(__UI_Texts(i)) > 0 THEN
                b$ = MKI$(-3) + MKL$(LEN(__UI_Texts(i))) '-3 indicates a text
                PUT #BinFileNum, , b$
                PUT #BinFileNum, , __UI_Texts(i)
            END IF
            IF __UI_Controls(i).TransparentColor > 0 THEN
                b$ = MKI$(-28) + _MK$(_UNSIGNED LONG, __UI_Controls(i).TransparentColor)
                PUT #BinFileNum, , b$
            END IF
            IF __UI_Controls(i).Stretch THEN
                b$ = MKI$(-4)
                PUT #BinFileNum, , b$
            END IF
            'Inheritable properties won't be saved if they are the same as the parent's
            IF __UI_Controls(i).Type = __UI_Type_Form THEN
                IF __UI_Controls(i).Font = 8 OR __UI_Controls(i).Font = 16 THEN
                    'Internal fonts
                    SaveInternalFont:
                    FontSetup$ = "**" + LTRIM$(STR$(__UI_Controls(__UI_GetFontID(__UI_Controls(i).Font)).Max))
                    b$ = MKI$(-5) + MKI$(LEN(FontSetup$)) + FontSetup$
                    PUT #BinFileNum, , b$
                ELSE
                    SaveExternalFont:
                    FontSetup$ = __UI_Texts(__UI_GetFontID(__UI_Controls(i).Font)) + "*" + __UI_Captions(__UI_GetFontID(__UI_Controls(i).Font)) + "*" + LTRIM$(STR$(__UI_Controls(__UI_GetFontID(__UI_Controls(i).Font)).Max))
                    b$ = MKI$(-5) + MKI$(LEN(FontSetup$)) + FontSetup$
                    PUT #BinFileNum, , b$
                END IF
            ELSE
                IF __UI_Controls(i).ParentID > 0 THEN
                    IF __UI_Controls(i).Font > 0 AND __UI_Controls(i).Font <> __UI_Controls(__UI_Controls(i).ParentID).Font THEN
                        IF __UI_Controls(i).Font = 8 OR __UI_Controls(i).Font = 167 THEN
                            GOTO SaveInternalFont
                        ELSE
                            GOTO SaveExternalFont
                        END IF
                    END IF
                ELSE
                    IF __UI_Controls(i).Font > 0 AND __UI_Controls(i).Font <> __UI_Controls(__UI_FormID).Font THEN
                        IF __UI_Controls(i).Font = 8 OR __UI_Controls(i).Font = 167 THEN
                            GOTO SaveInternalFont
                        ELSE
                            GOTO SaveExternalFont
                        END IF
                    END IF
                END IF
            END IF
            'Colors are saved only if they differ from the theme's defaults
            IF __UI_Controls(i).ForeColor <> __UI_DefaultColor(__UI_Controls(i).Type, 1) THEN
                b$ = MKI$(-6) + _MK$(_UNSIGNED LONG, __UI_Controls(i).ForeColor)
                PUT #BinFileNum, , b$
            END IF
            IF __UI_Controls(i).BackColor <> __UI_DefaultColor(__UI_Controls(i).Type, 2) THEN
                b$ = MKI$(-7) + _MK$(_UNSIGNED LONG, __UI_Controls(i).BackColor)
                PUT #BinFileNum, , b$
            END IF
            IF __UI_Controls(i).SelectedForeColor <> __UI_DefaultColor(__UI_Controls(i).Type, 3) THEN
                b$ = MKI$(-8) + _MK$(_UNSIGNED LONG, __UI_Controls(i).SelectedForeColor)
                PUT #BinFileNum, , b$
            END IF
            IF __UI_Controls(i).SelectedBackColor <> __UI_DefaultColor(__UI_Controls(i).Type, 4) THEN
                b$ = MKI$(-9) + _MK$(_UNSIGNED LONG, __UI_Controls(i).SelectedBackColor)
                PUT #BinFileNum, , b$
            END IF
            IF __UI_Controls(i).BorderColor <> __UI_DefaultColor(__UI_Controls(i).Type, 5) THEN
                b$ = MKI$(-10) + _MK$(_UNSIGNED LONG, __UI_Controls(i).BorderColor)
                PUT #BinFileNum, , b$
            END IF
            IF __UI_Controls(i).BackStyle = __UI_Transparent THEN
                b$ = MKI$(-11): PUT #BinFileNum, , b$
            END IF
            IF __UI_Controls(i).HasBorder THEN
                b$ = MKI$(-12): PUT #BinFileNum, , b$
            END IF
            IF __UI_Controls(i).Align = __UI_Center THEN
                b$ = MKI$(-13) + _MK$(_BYTE, __UI_Controls(i).Align): PUT #BinFileNum, , b$
            ELSEIF __UI_Controls(i).Align = __UI_Right THEN
                b$ = MKI$(-13) + _MK$(_BYTE, __UI_Controls(i).Align): PUT #BinFileNum, , b$
            END IF
            IF __UI_Controls(i).Value <> 0 THEN
                b$ = MKI$(-14) + _MK$(_FLOAT, __UI_Controls(i).Value): PUT #BinFileNum, , b$
            END IF
            IF __UI_Controls(i).Min <> 0 THEN
                b$ = MKI$(-15) + _MK$(_FLOAT, __UI_Controls(i).Min): PUT #BinFileNum, , b$
            END IF
            IF __UI_Controls(i).Max <> 0 THEN
                b$ = MKI$(-16) + _MK$(_FLOAT, __UI_Controls(i).Max): PUT #BinFileNum, , b$
            END IF
            'IF __UI_Controls(i).HotKey <> 0 THEN
            '    b$ = MKI$(-17) + MKI$(__UI_Controls(i).HotKey): PUT #BinFileNum, , b$
            'END IF
            'IF __UI_Controls(i).HotKeyOffset <> 0 THEN
            '    b$ = MKI$(-18) + MKI$(__UI_Controls(i).HotKeyOffset): PUT #BinFileNum, , b$
            'END IF
            IF __UI_Controls(i).ShowPercentage THEN
                b$ = MKI$(-19): PUT #BinFileNum, , b$
            END IF
            IF __UI_Controls(i).CanHaveFocus THEN
                b$ = MKI$(-20): PUT #BinFileNum, , b$
            END IF
            IF __UI_Controls(i).Disabled THEN
                b$ = MKI$(-21): PUT #BinFileNum, , b$
            END IF
            IF __UI_Controls(i).Hidden THEN
                b$ = MKI$(-22): PUT #BinFileNum, , b$
            END IF
            IF __UI_Controls(i).CenteredWindow THEN
                b$ = MKI$(-23): PUT #BinFileNum, , b$
            END IF
            IF __UI_Controls(i).ContextMenuID THEN
                b$ = MKI$(-25) + MKI$(LEN(RTRIM$(__UI_Controls(__UI_Controls(i).ContextMenuID).Name))) + RTRIM$(__UI_Controls(__UI_Controls(i).ContextMenuID).Name): PUT #BinFileNum, , b$
            END IF
            IF __UI_Controls(i).Interval THEN
                b$ = MKI$(-26) + _MK$(_FLOAT, __UI_Controls(i).Interval): PUT #BinFileNum, , b$
            END IF
            IF __UI_Controls(i).WordWrap THEN
                b$ = MKI$(-27): PUT #BinFileNum, , b$
            END IF
            IF __UI_Controls(i).CanResize AND __UI_Controls(i).Type = __UI_Type_Form THEN
                b$ = MKI$(-29): PUT #BinFileNum, , b$
            END IF
            IF __UI_Controls(i).HotKey > 0 THEN
                b$ = MKI$(-30) + MKI$(__UI_Controls(i).HotKeyPosition): PUT #BinFileNum, , b$
            END IF
            IF __UI_Controls(i).Padding > 0 THEN
                b$ = MKI$(-31) + MKI$(__UI_Controls(i).Padding): PUT #BinFileNum, , b$
            END IF

        END IF
    NEXT
    b$ = MKI$(-1024): PUT #BinFileNum, , b$ 'end of file
    CLOSE #BinFileNum
    IF Debug THEN CLOSE #TxtFileNum
END SUB

SUB SendData (b$, Offset AS LONG)
    DIM FileNum AS INTEGER
    FileNum = FREEFILE
    OPEN "UiEditor.dat" FOR BINARY AS #FileNum

    PUT #FileNum, Offset, b$
    CLOSE #FileNum
END SUB

FUNCTION IconPreview& (IconFile$)
    DIM IconFileNum AS INTEGER
    DIM Preferred AS INTEGER, Largest AS INTEGER
    DIM i AS LONG, a$

    TYPE ICONTYPE
        Reserved AS INTEGER: ID AS INTEGER: Count AS INTEGER
    END TYPE

    TYPE ICONENTRY
        PWidth AS _UNSIGNED _BYTE: PDepth AS _UNSIGNED _BYTE
        NumColors AS _BYTE: RES2 AS _BYTE
        NumberPlanes AS INTEGER: BitsPerPixel AS INTEGER
        DataSize AS LONG: DataOffset AS LONG
    END TYPE

    TYPE BMPENTRY
        ID AS STRING * 2: Size AS LONG: Res1 AS INTEGER: Res2 AS INTEGER: Offset AS LONG
    END TYPE

    TYPE BMPHeader
        Hsize AS LONG: PWidth AS LONG: PDepth AS LONG
        Planes AS INTEGER: BPP AS INTEGER
        Compression AS LONG: ImageBytes AS LONG
        Xres AS LONG: Yres AS LONG: NumColors AS LONG: SigColors AS LONG
    END TYPE

    DIM ICO AS ICONTYPE
    DIM BMP AS BMPENTRY
    DIM BMPHeader AS BMPHeader

    IF _FILEEXISTS(IconFile$) = 0 THEN EXIT FUNCTION

    IconFileNum = FREEFILE
    OPEN IconFile$ FOR BINARY AS #IconFileNum
    GET #IconFileNum, 1, ICO
    IF ICO.ID <> 1 THEN CLOSE #IconFileNum: EXIT FUNCTION

    DIM Entry(ICO.Count) AS ICONENTRY
    Preferred = 0
    Largest = 0

    FOR i = 1 TO ICO.Count
        GET #IconFileNum, , Entry(i)
        IF Entry(i).BitsPerPixel = 32 THEN
            IF Entry(i).PWidth = 0 THEN Entry(i).PWidth = 256
            IF Entry(i).PWidth > Largest THEN Largest = Entry(i).PWidth: Preferred = i
        END IF
    NEXT

    IF Preferred = 0 THEN EXIT FUNCTION

    a$ = SPACE$(Entry(Preferred).DataSize)
    GET #IconFileNum, Entry(Preferred).DataOffset + 1, a$
    CLOSE #IconFileNum

    IF LEFT$(a$, 4) = CHR$(137) + "PNG" THEN
        'PNG data can be dumped to the disk directly
        OPEN IconFile$ + ".preview.png" FOR BINARY AS #IconFileNum
        PUT #IconFileNum, 1, a$
        CLOSE #IconFileNum
        i = _LOADIMAGE(IconFile$ + ".preview.png", 32)
        IF i = -1 THEN i = 0
        IconPreview& = i
        KILL IconFile$ + ".preview.png"
        EXIT FUNCTION
    ELSE
        'BMP data requires a header to be added
        BMP.ID = "BM"
        BMP.Size = LEN(BMP) + LEN(BMPHeader) + LEN(a$)
        BMP.Offset = LEN(BMP) + LEN(BMPHeader)
        BMPHeader.Hsize = 40
        BMPHeader.PWidth = Entry(Preferred).PWidth
        BMPHeader.PDepth = Entry(Preferred).PDepth: IF BMPHeader.PDepth = 0 THEN BMPHeader.PDepth = 256
        BMPHeader.Planes = 1
        BMPHeader.BPP = 32
        OPEN IconFile$ + ".preview.bmp" FOR BINARY AS #IconFileNum
        PUT #IconFileNum, 1, BMP
        PUT #IconFileNum, , BMPHeader
        a$ = MID$(a$, 41)
        PUT #IconFileNum, , a$
        CLOSE #IconFileNum
        i = _LOADIMAGE(IconFile$ + ".preview.bmp", 32)
        IF i < -1 THEN 'Loaded properly
            _SOURCE i
            IF POINT(0, 0) = _RGB32(0, 0, 0) THEN _CLEARCOLOR _RGB32(0, 0, 0), i
            _SOURCE 0
        ELSE
            i = 0
        END IF
        IconPreview& = i
        KILL IconFile$ + ".preview.bmp"
        EXIT FUNCTION
    END IF
END FUNCTION
