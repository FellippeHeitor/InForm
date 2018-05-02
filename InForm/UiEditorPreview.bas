OPTION _EXPLICIT

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
CONST OffsetMenuPanelIsON = 31
CONST OffsetAutoName = 33
CONST OffsetShowPosSize = 35
CONST OffsetSnapLines = 37
CONST OffsetPropertyChanged = 39
CONST OffsetMouseSwapped = 41
CONST OffsetDefaultButtonID = 43
CONST OffsetPropertyValue = 47

DIM SHARED UiPreviewPID AS LONG
DIM SHARED ExeIcon AS LONG
DIM SHARED AutoNameControls AS _BYTE
DIM SHARED UndoPointer AS INTEGER, TotalUndoImages AS INTEGER, MidUndo AS _BYTE
DIM SHARED IsCreating AS _BYTE

REDIM SHARED QB64KEYWORDS(0) AS STRING
READ_KEYWORDS

CHDIR ".."

CONST EmptyForm$ = "9iVA_9GK1P<000`ooO7000@00D006mVL]53;1`B000000000noO100006mVL]5cno760cEfI_EFMYi2MdIf?Q9GJQaV;dAWIol2CY9VLQ9GN_HdK^AgL_4TLY56K^@7MVmCB^IdKbef;bEfL_EWLSEfL_hdKdmFC_ifK]8EIWE7KQ9W;dAWIo<fKe9W;dAWIZXB<b00o%%%0"

DIM i AS LONG
DIM SHARED AlphaNumeric(255)
FOR i = 48 TO 57: AlphaNumeric(i) = -1: NEXT
FOR i = 65 TO 90: AlphaNumeric(i) = -1: NEXT
FOR i = 97 TO 122: AlphaNumeric(i) = -1: NEXT
AlphaNumeric(95) = -1

DIM SHARED Alpha(255)
FOR i = 65 TO 90: Alpha(i) = -1: NEXT
FOR i = 97 TO 122: Alpha(i) = -1: NEXT
Alpha(95) = -1

DIM SHARED Numeric(255)
FOR i = 48 TO 57: Numeric(i) = -1: NEXT

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
'$include:'xp.uitheme'
'$include:'UiEditorPreview.frm'

'Event procedures: ---------------------------------------------------------------
SUB __UI_Click (id AS LONG)
    SendSignal -1
END SUB

SUB __UI_MouseEnter (id AS LONG)
    SendSignal -3
END SUB

SUB __UI_MouseLeave (id AS LONG)
END SUB

SUB __UI_FocusIn (id AS LONG)
END SUB

SUB __UI_FocusOut (id AS LONG)
END SUB

SUB __UI_MouseDown (id AS LONG)
END SUB

SUB __UI_MouseUp (id AS LONG)
END SUB

SUB AutoSizeLabel (this AS __UI_ControlTYPE)
    DIM tempFont AS LONG, tempCenter AS INTEGER
    tempFont = _FONT
    _FONT this.Font
    IF this.WordWrap = False AND (this.Height = 23 OR this.Height = uheight) THEN
        this.Width = __UI_PrintWidth(Caption(this.ID))
        IF this.Height <> uheight THEN
            tempCenter = this.Top + this.Height / 2
            this.Height = uheight
            this.Top = tempCenter - this.Height / 2
        END IF
        this.Redraw = True
    END IF
    _FONT tempFont
END SUB

SUB __UI_BeforeUpdateDisplay
    DIM NewWindowTop AS INTEGER, NewWindowLeft AS INTEGER
    DIM a$, b$, TempValue AS LONG, i AS LONG, j AS LONG, UiEditorPID AS LONG
    STATIC MidRead AS _BYTE, UiEditorFile AS INTEGER, EditorWasActive AS _BYTE
    STATIC WasDragging AS _BYTE, WasResizing AS _BYTE

    SavePreview

    b$ = MKL$(UiPreviewPID)
    SendData b$, OffsetPreviewPID

    b$ = MKL$(__UI_DefaultButtonID)
    SendData b$, OffsetDefaultButtonID

    IF __UI_ActiveMenu > 0 AND LEFT$(Control(__UI_ParentMenu).Name, 5) <> "__UI_" THEN b$ = MKI$(-1) ELSE b$ = MKI$(0)
    SendData b$, OffsetMenuPanelIsON

    UiEditorFile = FREEFILE
    OPEN "InForm/UiEditor.dat" FOR BINARY AS #UiEditorFile

    IF NOT MidRead THEN
        MidRead = True
        b$ = SPACE$(4): GET #UiEditorFile, OffsetEditorPID, b$
        UiEditorPID = CVL(b$)

        $IF WIN THEN
            b$ = SPACE$(2): GET #UiEditorFile, OffsetWindowLeft, b$
            NewWindowLeft = CVI(b$)
            b$ = SPACE$(2): GET #UiEditorFile, OffsetWindowTop, b$
            NewWindowTop = CVI(b$)

            IF NewWindowLeft <> -32001 AND NewWindowTop <> -32001 AND (NewWindowLeft <> _SCREENX OR NewWindowTop <> _SCREENY) THEN
                _SCREENMOVE NewWindowLeft + 612, NewWindowTop
            END IF
        $END IF

        GET #UiEditorFile, OffsetAutoName, b$
        AutoNameControls = CVI(b$)

        GET #UiEditorFile, OffsetMouseSwapped, b$
        __UI_MouseButtonsSwap = CVI(b$)

        GET #UiEditorFile, OffsetShowPosSize, b$
        __UI_ShowPositionAndSize = CVI(b$)

        GET #UiEditorFile, OffsetSnapLines, b$
        __UI_SnapLines = CVI(b$)

        'Check if the editor is still alive
        $IF WIN THEN
            DIM hnd&, b&, ExitCode&
            hnd& = OpenProcess(&H400, 0, UiEditorPID)
            b& = GetExitCodeProcess(hnd&, ExitCode&)
            IF b& = 1 AND ExitCode& = 259 THEN
                'Editor is active.
                EditorWasActive = True
            ELSE
                'Editor was closed.
                IF EditorWasActive = False THEN
                    'Preview was launched by user
                    DIM Answer AS LONG
                    _SCREENHIDE
                    Answer = MessageBox("InForm Designer is not running. Please run the main program.", "InForm Preview", 0)
                END IF
                SYSTEM
            END IF
            b& = CloseHandle(hnd&)
        $ELSE
            IF PROCESS_CLOSED(UiEditorPID, 0) THEN SYSTEM
        $END IF

        IF __UI_IsDragging THEN
            WasDragging = True
        ELSE
            IF WasDragging THEN
                WasDragging = False
                SaveUndoImage
            END IF
        END IF

        IF __UI_IsResizing THEN
            WasResizing = True
        ELSE
            IF WasResizing THEN
                WasResizing = False
                SaveUndoImage
            END IF
        END IF

        'New control:
        DIM ThisContainer AS LONG, TempWidth AS INTEGER, TempHeight AS INTEGER
        b$ = SPACE$(2): GET #UiEditorFile, OffsetNewControl, b$
        TempValue = CVI(b$)
        b$ = MKI$(0): PUT #UiEditorFile, OffsetNewControl, b$
        IF TempValue > 0 THEN
            SaveUndoImage
            IF Control(Control(__UI_FirstSelectedID).ParentID).Type = __UI_Type_Frame THEN
                ThisContainer = Control(__UI_FirstSelectedID).ParentID
                TempWidth = Control(Control(__UI_FirstSelectedID).ParentID).Width
                TempHeight = Control(Control(__UI_FirstSelectedID).ParentID).Height
            ELSEIF Control(__UI_FirstSelectedID).Type = __UI_Type_Frame THEN
                ThisContainer = Control(__UI_FirstSelectedID).ID
                TempWidth = Control(__UI_FirstSelectedID).Width
                TempHeight = Control(__UI_FirstSelectedID).Height
            ELSE
                TempWidth = Control(__UI_FormID).Width
                TempHeight = Control(__UI_FormID).Height
            END IF
            SELECT CASE TempValue
                CASE __UI_Type_Button
                    TempValue = __UI_NewControl(__UI_Type_Button, "", 80, 23, TempWidth \ 2 - 40, TempHeight \ 2 - 12, ThisContainer)
                    SetCaption TempValue, RTRIM$(Control(TempValue).Name)
                CASE __UI_Type_Label
                    TempValue = __UI_NewControl(TempValue, "", 150, 23, TempWidth \ 2 - 75, TempHeight \ 2 - 12, ThisContainer)
                    SetCaption TempValue, RTRIM$(Control(TempValue).Name)
                    AutoSizeLabel Control(TempValue)
                CASE __UI_Type_CheckBox, __UI_Type_RadioButton
                    TempValue = __UI_NewControl(TempValue, "", 150, 23, TempWidth \ 2 - 75, TempHeight \ 2 - 12, ThisContainer)
                    SetCaption TempValue, RTRIM$(Control(TempValue).Name)
                CASE __UI_Type_TextBox
                    TempValue = __UI_NewControl(__UI_Type_TextBox, "", 120, 23, TempWidth \ 2 - 60, TempHeight \ 2 - 12, ThisContainer)
                    SetCaption TempValue, RTRIM$(Control(TempValue).Name)
                CASE __UI_Type_ListBox
                    TempValue = __UI_NewControl(__UI_Type_ListBox, "", 200, 200, TempWidth \ 2 - 100, TempHeight \ 2 - 100, ThisContainer)
                    Control(TempValue).HasBorder = True
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
                    SetCaption TempValue, RTRIM$(Control(TempValue).Name)
                CASE __UI_Type_MenuBar
                    'Before adding a menu bar item, reset all other menu bar items' alignment
                    FOR i = 1 TO UBOUND(Control)
                        IF Control(i).Type = __UI_Type_MenuBar THEN
                            Control(i).Align = __UI_Left
                        END IF
                    NEXT
                    TempValue = __UI_NewControl(TempValue, "", 0, 0, 0, 0, 0)
                    SetCaption TempValue, RTRIM$(Control(TempValue).Name)
                    __UI_RefreshMenuBar
                    __UI_ActivateMenu Control(TempValue), False
                CASE __UI_Type_MenuItem
                    IF __UI_ActiveMenu > 0 AND LEFT$(Control(__UI_ParentMenu).Name, 5) <> "__UI_" THEN
                        TempValue = __UI_NewControl(TempValue, "", 0, 0, 0, 0, __UI_ParentMenu)
                        SetCaption TempValue, RTRIM$(Control(TempValue).Name)
                        __UI_ActivateMenu Control(__UI_ParentMenu), False
                    END IF
                CASE __UI_Type_ToggleSwitch
                    TempValue = __UI_NewControl(TempValue, "", 40, 17, TempWidth \ 2 - 20, TempHeight \ 2 - 8, ThisContainer)
            END SELECT
            IF __UI_ActiveMenu > 0 AND (Control(TempValue).Type <> __UI_Type_MenuBar AND Control(TempValue).Type <> __UI_Type_MenuItem) THEN
                __UI_DestroyControl Control(__UI_ActiveMenu)
            END IF
            FOR i = 1 TO UBOUND(Control)
                Control(i).ControlIsSelected = False
            NEXT
            Control(TempValue).ControlIsSelected = True
            __UI_TotalSelectedControls = 1
            __UI_FirstSelectedID = TempValue
            __UI_ForceRedraw = True
        END IF

        IF __UI_FirstSelectedID > 0 THEN
            IF Control(__UI_FirstSelectedID).Type = __UI_Type_PictureBox AND LEN(Text(__UI_FirstSelectedID)) > 0 THEN
                IF Control(__UI_FirstSelectedID).Height <> _HEIGHT(Control(__UI_FirstSelectedID).HelperCanvas) OR _
                   Control(__UI_FirstSelectedID).Width <> _WIDTH(Control(__UI_FirstSelectedID).HelperCanvas) THEN
                    SendSignal -10
                    b$ = LTRIM$(STR$(_WIDTH(Control(__UI_FirstSelectedID).HelperCanvas))) + "x" + LTRIM$(STR$(_HEIGHT(Control(__UI_FirstSelectedID).HelperCanvas)))
                    b$ = MKL$(LEN(b$)) + b$
                    SendData b$, OffsetPropertyValue
                ELSE
                    SendSignal -11
                END IF
            ELSE
                SendSignal -11
            END IF
        ELSE
            SendSignal -11
        END IF

        b$ = SPACE$(2): GET #UiEditorFile, OffsetNewDataFromEditor, b$
        TempValue = CVI(b$)
        b$ = MKI$(0): PUT #UiEditorFile, OffsetNewDataFromEditor, b$
        IF TempValue = -2 THEN
            'Hide the preview
            _SCREENHIDE
        ELSEIF TempValue = -3 THEN
            'Show the preview
            _SCREENSHOW
        ELSEIF TempValue = -4 THEN
            'Load an existing file
            IsCreating = True
            b$ = SPACE$(2): GET #UiEditorFile, OffsetPropertyValue, b$
            b$ = SPACE$(CVI(b$)): GET #UiEditorFile, , b$
            DIM FileToLoad AS INTEGER
            FileToLoad = FREEFILE
            OPEN b$ FOR BINARY AS #FileToLoad
            a$ = SPACE$(LOF(FileToLoad))
            GET #FileToLoad, 1, a$
            CLOSE #FileToLoad

            FileToLoad = FREEFILE
            OPEN "InForm/UiEditorPreview.frmbin" FOR BINARY AS #FileToLoad
            PUT #FileToLoad, 1, a$
            CLOSE #FileToLoad

            _SCREENSHOW
            IF INSTR(a$, "SUB __UI_LoadForm") > 0 THEN
                LoadPreviewText
            ELSE
                LoadPreview
            END IF
            UndoPointer = 0
            TotalUndoImages = 0
            SendSignal -7 'Form just loaded
        ELSEIF TempValue = -5 THEN
            'Reset request (new form)
            IsCreating = True
            a$ = Unpack$(EmptyForm$)

            FileToLoad = FREEFILE
            OPEN "InForm/UiEditorPreview.frmbin" FOR BINARY AS #FileToLoad
            PUT #FileToLoad, 1, a$
            CLOSE #FileToLoad

            LoadPreview
            UndoPointer = 0
            TotalUndoImages = 0
            SendSignal -7 'New form created
        ELSEIF TempValue = -6 THEN
            'Set current button as default
            __UI_DefaultButtonID = __UI_FirstSelectedID
        ELSEIF TempValue = -7 THEN
            __UI_RestoreImageOriginalSize
        ELSEIF TempValue = -1 THEN
            DIM FloatValue AS _FLOAT
            'Editor sent property value
            b$ = SPACE$(2): GET #UiEditorFile, OffsetPropertyChanged, b$
            TempValue = CVI(b$)
            IF TempValue <> 213 AND TempValue <> 214 AND TempValue <> 215 THEN SaveUndoImage 'Select, undo, redo signals
            SELECT CASE TempValue
                CASE 1 'Name
                    b$ = SPACE$(4): GET #UiEditorFile, OffsetPropertyValue, b$
                    b$ = SPACE$(CVL(b$)): GET #UiEditorFile, , b$
                    IF __UI_TotalSelectedControls = 1 THEN
                        Control(__UI_FirstSelectedID).Name = AdaptName$(b$, __UI_FirstSelectedID)
                    ELSEIF __UI_TotalSelectedControls = 0 THEN
                        'IF __UI_GetID(b$) > 0 AND __UI_GetID(b$) <> __UI_FormID THEN
                        '    DO
                        '        b$ = b$ + "_"
                        '        IF __UI_GetID(b$) = 0 THEN EXIT DO
                        '    LOOP
                        'END IF
                        Control(__UI_FormID).Name = AdaptName$(b$, __UI_FormID)
                    END IF
                CASE 2 'Caption
                    b$ = SPACE$(4): GET #UiEditorFile, OffsetPropertyValue, b$
                    b$ = SPACE$(CVL(b$)): GET #UiEditorFile, , b$
                    IF __UI_TotalSelectedControls > 0 THEN
                        FOR i = 1 TO UBOUND(Control)
                            IF Control(i).ControlIsSelected THEN
                                IF Control(i).Type = __UI_Type_Label THEN
                                    DIM TotalReplacements AS LONG
                                    b$ = Replace(b$, "\n", CHR$(10), False, TotalReplacements)
                                END IF
                                SetCaption i, b$
                                IF Control(i).Type = __UI_Type_Label THEN AutoSizeLabel Control(i)
                                IF LEN(b$) > 0 AND b$ <> "&" THEN GOSUB AutoName
                                IF Control(i).Type = __UI_Type_MenuItem THEN
                                    __UI_ActivateMenu Control(Control(i).ParentID), False
                                END IF
                            END IF
                        NEXT
                    ELSE
                        Caption(__UI_FormID) = b$
                        i = __UI_FormID
                        IF LEN(b$) > 0 AND b$ <> "&" THEN GOSUB AutoName
                    END IF

                    GOTO SkipAutoName

                    AutoName:
                    IF AutoNameControls THEN
                        DIM NewName$

                        NewName$ = RTRIM$(b$)

                        IF Control(i).Type = __UI_Type_MenuBar THEN
                            IF LEN(NewName$) > 36 THEN NewName$ = LEFT$(NewName$, 36)
                        ELSEIF Control(i).Type <> __UI_Type_Form AND Control(i).Type <> __UI_Type_MenuItem AND Control(i).Type <> __UI_Type_ListBox AND Control(i).Type <> __UI_Type_TrackBar AND Control(i).Type <> __UI_Type_DropdownList THEN
                            IF LEN(NewName$) > 38 THEN NewName$ = LEFT$(NewName$, 38)
                        END IF
                        SELECT CASE Control(i).Type
                            CASE __UI_Type_Button: NewName$ = NewName$ + "BT"
                            CASE __UI_Type_Label: NewName$ = NewName$ + "LB"
                            CASE __UI_Type_CheckBox: NewName$ = NewName$ + "CB"
                            CASE __UI_Type_RadioButton: NewName$ = NewName$ + "RB"
                            CASE __UI_Type_TextBox: NewName$ = NewName$ + "TB"
                            CASE __UI_Type_ProgressBar: NewName$ = NewName$ + "PB"
                            CASE __UI_Type_MenuBar: NewName$ = NewName$ + "Menu"
                            CASE __UI_Type_MenuItem
                                NewName$ = RTRIM$(Control(Control(i).ParentID).Name) + NewName$
                            CASE __UI_Type_PictureBox: NewName$ = NewName$ + "PX"
                        END SELECT

                        Control(i).Name = AdaptName$(NewName$, i)
                    END IF
                    RETURN

                    SkipAutoName:
                CASE 3 'Text
                    b$ = SPACE$(4): GET #UiEditorFile, OffsetPropertyValue, b$
                    b$ = SPACE$(CVL(b$)): GET #UiEditorFile, , b$
                    IF __UI_TotalSelectedControls > 0 THEN
                        FOR i = 1 TO UBOUND(Control)
                            IF Control(i).ControlIsSelected THEN
                                Text(i) = b$
                                IF Control(i).Type = __UI_Type_TextBox AND Control(i).Max > 0 THEN
                                    Text(i) = LEFT$(b$, Control(i).Max)
                                END IF
                                IF Control(i).Type = __UI_Type_Button OR Control(i).Type = __UI_Type_MenuItem THEN
                                    LoadImage Control(i), b$
                                ELSEIF Control(i).Type = __UI_Type_PictureBox THEN
                                    LoadImage Control(i), b$
                                    IF LEN(Text(i)) > 0 THEN 'Load successful
                                        'Keep aspect ratio at load
                                        Control(i).Height = (_HEIGHT(Control(i).HelperCanvas) / _WIDTH(Control(i).HelperCanvas)) * Control(i).Width
                                    END IF
                                    IF LEN(b$) > 0 AND b$ <> "&" THEN GOSUB AutoName
                                ELSEIF Control(i).Type = __UI_Type_ListBox OR Control(i).Type = __UI_Type_DropdownList THEN
                                    Text(i) = Replace(b$, "\n", CHR$(13), False, TotalReplacements)
                                    IF Control(i).Max < TotalReplacements + 1 THEN Control(i).Max = TotalReplacements + 1
                                    Control(i).LastVisibleItem = 0 'Reset it so it's recalculated
                                END IF
                            END IF
                        NEXT
                    ELSE
                        IF ExeIcon <> 0 THEN _FREEIMAGE ExeIcon: ExeIcon = 0
                        ExeIcon = IconPreview&(b$)
                        IF ExeIcon < -1 THEN
                            _ICON ExeIcon
                            Text(__UI_FormID) = b$
                        ELSE
                            _ICON
                            IF _FILEEXISTS(b$) THEN
                                IF LCASE$(RIGHT$(b$, 4)) <> ".ico" THEN
                                    SendSignal -6
                                    Text(__UI_FormID) = ""
                                ELSE
                                    SendSignal -4
                                    Text(__UI_FormID) = b$
                                END IF
                            ELSE
                                Text(__UI_FormID) = ""
                            END IF
                        END IF
                    END IF
                CASE 4 'Top
                    b$ = SPACE$(2): GET #UiEditorFile, OffsetPropertyValue, b$
                    TempValue = CVI(b$)
                    FOR i = 1 TO UBOUND(Control)
                        IF Control(i).ControlIsSelected THEN
                            Control(i).Top = TempValue
                        END IF
                    NEXT
                CASE 5 'Left
                    b$ = SPACE$(2): GET #UiEditorFile, OffsetPropertyValue, b$
                    TempValue = CVI(b$)
                    FOR i = 1 TO UBOUND(Control)
                        IF Control(i).ControlIsSelected THEN
                            Control(i).Left = TempValue
                        END IF
                    NEXT
                CASE 6 'Width
                    b$ = SPACE$(2): GET #UiEditorFile, OffsetPropertyValue, b$
                    TempValue = CVI(b$)
                    IF TempValue < 1 THEN TempValue = 1
                    IF __UI_TotalSelectedControls > 0 THEN
                        FOR i = 1 TO UBOUND(Control)
                            IF Control(i).ControlIsSelected THEN
                                Control(i).Width = TempValue
                            END IF
                        NEXT
                    ELSE
                        IF TempValue < 20 THEN TempValue = 20
                        Control(__UI_FormID).Width = TempValue
                    END IF
                CASE 7 'Height
                    b$ = SPACE$(2): GET #UiEditorFile, OffsetPropertyValue, b$
                    TempValue = CVI(b$)
                    IF TempValue < 1 THEN TempValue = 1
                    IF __UI_TotalSelectedControls > 0 THEN
                        FOR i = 1 TO UBOUND(Control)
                            IF Control(i).ControlIsSelected THEN
                                Control(i).Height = TempValue
                            END IF
                        NEXT
                    ELSE
                        IF TempValue < 20 THEN TempValue = 20
                        Control(__UI_FormID).Height = TempValue
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
                            FOR i = 1 TO UBOUND(Control)
                                IF Control(i).ControlIsSelected THEN
                                    Control(i).Font = SetFont(NewFontFile, NewFontSize, NewFontParameters)
                                END IF
                            NEXT
                        ELSE
                            Control(__UI_FormID).Font = SetFont(NewFontFile, NewFontSize, NewFontParameters)
                            DIM MustRedrawMenus AS _BYTE
                            FOR i = 1 TO UBOUND(Control)
                                IF Control(i).Type = __UI_Type_MenuBar OR Control(i).Type = __UI_Type_MenuItem OR Control(i).Type = __UI_Type_MenuPanel OR Control(i).Type = __UI_Type_ContextMenu THEN
                                    Control(i).Font = SetFont(NewFontFile, NewFontSize, NewFontParameters)
                                    MustRedrawMenus = True
                                END IF
                            NEXT
                            IF MustRedrawMenus THEN __UI_RefreshMenuBar
                        END IF
                    END IF
                CASE 9 'Tooltip
                    b$ = SPACE$(4): GET #UiEditorFile, OffsetPropertyValue, b$
                    b$ = SPACE$(CVL(b$)): GET #UiEditorFile, , b$
                    FOR i = 1 TO UBOUND(Control)
                        IF Control(i).ControlIsSelected THEN
                            ToolTip(i) = Replace(b$, "\n", CHR$(10), False, 0)
                        END IF
                    NEXT
                CASE 10 'Value
                    b$ = SPACE$(LEN(FloatValue)): GET #UiEditorFile, OffsetPropertyValue, b$
                    FOR i = 1 TO UBOUND(Control)
                        IF Control(i).ControlIsSelected THEN
                            IF Control(i).Type = __UI_Type_CheckBox OR Control(i).Type = __UI_Type_MenuItem THEN
                                IF _CV(_FLOAT, b$) <> 0 THEN
                                    Control(i).Value = True
                                ELSE
                                    Control(i).Value = False
                                END IF
                            ELSEIF Control(i).Type = __UI_Type_RadioButton THEN
                                IF _CV(_FLOAT, b$) <> 0 THEN
                                    SetRadioButtonValue i
                                ELSE
                                    Control(i).Value = False
                                END IF
                            ELSE
                                Control(i).Value = _CV(_FLOAT, b$)
                            END IF
                        END IF
                    NEXT
                CASE 11 'Min
                    b$ = SPACE$(LEN(FloatValue)): GET #UiEditorFile, OffsetPropertyValue, b$
                    FOR i = 1 TO UBOUND(Control)
                        IF Control(i).ControlIsSelected THEN
                            Control(i).Min = _CV(_FLOAT, b$)
                        END IF
                    NEXT
                CASE 12 'Max
                    b$ = SPACE$(LEN(FloatValue)): GET #UiEditorFile, OffsetPropertyValue, b$
                    FOR i = 1 TO UBOUND(Control)
                        IF Control(i).ControlIsSelected THEN
                            Control(i).Max = _CV(_FLOAT, b$)
                            IF Control(i).Type = __UI_Type_TextBox THEN
                                Text(i) = LEFT$(Text(i), INT(Control(i).Max))
                            END IF
                        END IF
                    NEXT
                CASE 13 'Interval
                    b$ = SPACE$(LEN(FloatValue)): GET #UiEditorFile, OffsetPropertyValue, b$
                    FOR i = 1 TO UBOUND(Control)
                        IF Control(i).ControlIsSelected THEN
                            Control(i).Interval = _CV(_FLOAT, b$)
                        END IF
                    NEXT
                CASE 14 'Stretch
                    b$ = SPACE$(2): GET #UiEditorFile, OffsetPropertyValue, b$
                    FOR i = 1 TO UBOUND(Control)
                        IF Control(i).ControlIsSelected THEN
                            Control(i).Stretch = CVI(b$)
                        END IF
                    NEXT
                CASE 15 'Has border
                    b$ = SPACE$(2): GET #UiEditorFile, OffsetPropertyValue, b$
                    FOR i = 1 TO UBOUND(Control)
                        IF Control(i).ControlIsSelected THEN
                            Control(i).HasBorder = CVI(b$)
                        END IF
                    NEXT
                CASE 16 'Show percentage
                    b$ = SPACE$(2): GET #UiEditorFile, OffsetPropertyValue, b$
                    FOR i = 1 TO UBOUND(Control)
                        IF Control(i).ControlIsSelected THEN
                            Control(i).ShowPercentage = CVI(b$)
                        END IF
                    NEXT
                CASE 17 'Word wrap
                    b$ = SPACE$(2): GET #UiEditorFile, OffsetPropertyValue, b$
                    FOR i = 1 TO UBOUND(Control)
                        IF Control(i).ControlIsSelected THEN
                            Control(i).WordWrap = CVI(b$)
                        END IF
                    NEXT
                CASE 18 'Can have focus
                    b$ = SPACE$(2): GET #UiEditorFile, OffsetPropertyValue, b$
                    FOR i = 1 TO UBOUND(Control)
                        IF Control(i).ControlIsSelected THEN
                            Control(i).CanHaveFocus = CVI(b$)
                        END IF
                    NEXT
                CASE 19 'Disabled
                    b$ = SPACE$(2): GET #UiEditorFile, OffsetPropertyValue, b$
                    FOR i = 1 TO UBOUND(Control)
                        IF Control(i).ControlIsSelected THEN
                            Control(i).Disabled = CVI(b$)
                        END IF
                    NEXT
                CASE 20 'Hidden
                    b$ = SPACE$(2): GET #UiEditorFile, OffsetPropertyValue, b$
                    FOR i = 1 TO UBOUND(Control)
                        IF Control(i).ControlIsSelected THEN
                            Control(i).Hidden = CVI(b$)
                            IF Control(i).Type = __UI_Type_MenuItem AND __UI_ParentMenu = Control(i).ParentID THEN
                                __UI_ActivateMenu Control(Control(i).ParentID), False
                            END IF
                        END IF
                    NEXT
                CASE 21 'CenteredWindow
                    b$ = SPACE$(2): GET #UiEditorFile, OffsetPropertyValue, b$
                    TempValue = CVI(b$)
                    IF __UI_TotalSelectedControls = 0 THEN
                        Control(__UI_FormID).CenteredWindow = TempValue
                    END IF
                CASE 22 'Alignment
                    b$ = SPACE$(2): GET #UiEditorFile, OffsetPropertyValue, b$
                    FOR i = 1 TO UBOUND(Control)
                        IF Control(i).ControlIsSelected THEN
                            Control(i).Align = CVI(b$)
                            IF Control(i).Type = __UI_Type_MenuBar THEN
                                IF Control(i).Align <> __UI_Left THEN Control(i).Align = __UI_Right
                                IF __UI_ActiveMenu > 0 THEN __UI_DestroyControl Control(__UI_ActiveMenu)
                                __UI_RefreshMenuBar
                            END IF
                        END IF
                    NEXT
                CASE 23 'ForeColor
                    b$ = SPACE$(4): GET #UiEditorFile, OffsetPropertyValue, b$
                    IF __UI_TotalSelectedControls > 0 THEN
                        FOR i = 1 TO UBOUND(Control)
                            IF Control(i).ControlIsSelected THEN
                                Control(i).ForeColor = _CV(_UNSIGNED LONG, b$)
                            END IF
                        NEXT
                    ELSE
                        Control(__UI_FormID).ForeColor = _CV(_UNSIGNED LONG, b$)
                        FOR i = 1 TO UBOUND(Control)
                            IF Control(i).Type = __UI_Type_MenuBar THEN
                                Control(i).ForeColor = _CV(_UNSIGNED LONG, b$)
                            END IF
                        NEXT
                    END IF
                CASE 24 'BackColor
                    b$ = SPACE$(4): GET #UiEditorFile, OffsetPropertyValue, b$
                    IF __UI_TotalSelectedControls > 0 THEN
                        FOR i = 1 TO UBOUND(Control)
                            IF Control(i).ControlIsSelected THEN
                                Control(i).BackColor = _CV(_UNSIGNED LONG, b$)
                            END IF
                        NEXT
                    ELSE
                        Control(__UI_FormID).BackColor = _CV(_UNSIGNED LONG, b$)
                        FOR i = 1 TO UBOUND(Control)
                            IF Control(i).Type = __UI_Type_MenuBar THEN
                                Control(i).BackColor = _CV(_UNSIGNED LONG, b$)
                            END IF
                        NEXT
                    END IF
                CASE 25 'SelectedForeColor
                    b$ = SPACE$(4): GET #UiEditorFile, OffsetPropertyValue, b$
                    IF __UI_TotalSelectedControls > 0 THEN
                        FOR i = 1 TO UBOUND(Control)
                            IF Control(i).ControlIsSelected THEN
                                Control(i).SelectedForeColor = _CV(_UNSIGNED LONG, b$)
                            END IF
                        NEXT
                    ELSE
                        Control(__UI_FormID).SelectedForeColor = _CV(_UNSIGNED LONG, b$)
                        FOR i = 1 TO UBOUND(Control)
                            IF Control(i).Type = __UI_Type_MenuBar OR Control(i).Type = __UI_Type_MenuItem OR Control(i).Type = __UI_Type_MenuPanel OR Control(i).Type = __UI_Type_ContextMenu THEN
                                Control(i).SelectedForeColor = _CV(_UNSIGNED LONG, b$)
                            END IF
                        NEXT
                    END IF
                CASE 26 'SelectedBackColor
                    b$ = SPACE$(4): GET #UiEditorFile, OffsetPropertyValue, b$
                    IF __UI_TotalSelectedControls > 0 THEN
                        FOR i = 1 TO UBOUND(Control)
                            IF Control(i).ControlIsSelected THEN
                                Control(i).SelectedBackColor = _CV(_UNSIGNED LONG, b$)
                            END IF
                        NEXT
                    ELSE
                        Control(__UI_FormID).SelectedBackColor = _CV(_UNSIGNED LONG, b$)
                        FOR i = 1 TO UBOUND(Control)
                            IF Control(i).Type = __UI_Type_MenuBar OR Control(i).Type = __UI_Type_MenuItem OR Control(i).Type = __UI_Type_MenuPanel OR Control(i).Type = __UI_Type_ContextMenu THEN
                                Control(i).SelectedBackColor = _CV(_UNSIGNED LONG, b$)
                            END IF
                        NEXT
                    END IF
                CASE 27 'BorderColor
                    b$ = SPACE$(4): GET #UiEditorFile, OffsetPropertyValue, b$
                    IF __UI_TotalSelectedControls > 0 THEN
                        FOR i = 1 TO UBOUND(Control)
                            IF Control(i).ControlIsSelected THEN
                                Control(i).BorderColor = _CV(_UNSIGNED LONG, b$)
                            END IF
                        NEXT
                    ELSE
                        Control(__UI_FormID).BorderColor = _CV(_UNSIGNED LONG, b$)
                    END IF
                CASE 28 'BackStyle
                    b$ = SPACE$(2): GET #UiEditorFile, OffsetPropertyValue, b$
                    FOR i = 1 TO UBOUND(Control)
                        IF Control(i).ControlIsSelected THEN
                            Control(i).BackStyle = CVI(b$)
                        END IF
                    NEXT
                CASE 29 'CanResize
                    b$ = SPACE$(2): GET #UiEditorFile, OffsetPropertyValue, b$
                    TempValue = CVI(b$)
                    IF __UI_TotalSelectedControls = 0 THEN
                        Control(__UI_FormID).CanResize = TempValue
                    END IF
                CASE 31 'Padding
                    b$ = SPACE$(2): GET #UiEditorFile, OffsetPropertyValue, b$
                    TempValue = CVI(b$)
                    IF __UI_TotalSelectedControls > 0 THEN
                        FOR i = 1 TO UBOUND(Control)
                            IF Control(i).ControlIsSelected THEN
                                Control(i).Padding = TempValue
                            END IF
                        NEXT
                    END IF
                CASE 32 'Vertical Alignment
                    b$ = SPACE$(2): GET #UiEditorFile, OffsetPropertyValue, b$
                    FOR i = 1 TO UBOUND(Control)
                        IF Control(i).ControlIsSelected THEN
                            Control(i).VAlign = CVI(b$)
                        END IF
                    NEXT
                CASE 33 'Password field
                    b$ = SPACE$(2): GET #UiEditorFile, OffsetPropertyValue, b$
                    FOR i = 1 TO UBOUND(Control)
                        IF Control(i).ControlIsSelected AND Control(i).Type = __UI_Type_TextBox THEN
                            Control(i).PasswordField = CVI(b$)
                        END IF
                    NEXT
                CASE 34 'Encoding
                    b$ = SPACE$(4): GET #UiEditorFile, OffsetPropertyValue, b$
                    Control(__UI_FormID).Encoding = CVL(b$)
                CASE 35 'Mask
                    b$ = SPACE$(4): GET #UiEditorFile, OffsetPropertyValue, b$
                    b$ = SPACE$(CVL(b$)): GET #UiEditorFile, , b$
                    FOR i = 1 TO UBOUND(Control)
                        IF Control(i).ControlIsSelected THEN
                            Mask(i) = b$
                        END IF
                    NEXT
                CASE 201 TO 210
                    'Alignment commands
                    __UI_DesignModeAlignCommand = TempValue
                    __UI_HasInput = True
                CASE 211, 212 'Z-Ordering -> Move up/down
                    DIM tID1 AS LONG, tID2 AS LONG
                    a$ = SPACE$(4): GET #UiEditorFile, OffsetPropertyValue, a$
                    b$ = SPACE$(4): GET #UiEditorFile, , b$
                    tID1 = Control(CVL(a$)).ID
                    tID2 = Control(CVL(b$)).ID
                    SWAP Control(CVL(b$)), Control(CVL(a$))
                    SWAP Caption(CVL(b$)), Caption(CVL(a$))
                    SWAP Text(CVL(b$)), Text(CVL(a$))
                    SWAP ToolTip(CVL(b$)), ToolTip(CVL(a$))
                    Control(CVL(a$)).ID = tID1
                    Control(CVL(b$)).ID = tID2

                    'Restore ParentIDs based on ParentName
                    FOR i = 1 TO UBOUND(Control)
                        Control(i).ParentID = __UI_GetID(Control(i).ParentName)
                    NEXT

                    IF __UI_ActiveMenu > 0 AND LEFT$(Control(__UI_ParentMenu).Name, 5) <> "__UI_" THEN
                        IF Control(CVL(a$)).Type = __UI_Type_MenuItem OR Control(CVL(b$)).Type = __UI_Type_MenuItem THEN
                            __UI_ActivateMenu Control(__UI_ParentMenu), False
                        ELSE
                            __UI_DestroyControl Control(__UI_ActiveMenu)
                        END IF
                    END IF
                CASE 213
                    'Select control
                    b$ = SPACE$(4): GET #UiEditorFile, OffsetPropertyValue, b$

                    'Desselect all first:
                    FOR i = 1 TO UBOUND(Control)
                        Control(i).ControlIsSelected = False
                    NEXT

                    IF CVL(b$) > 0 THEN Control(CVL(b$)).ControlIsSelected = True
                CASE 214
                    'Undo
                    RestoreUndoImage
                CASE 215
                    'Redo
                    RestoreRedoImage
            END SELECT
            __UI_ForceRedraw = True
        END IF

        IF __UI_ActiveMenu > 0 AND LEFT$(Control(__UI_ParentMenu).Name, 5) = "__UI_" AND __UI_CantShowContextMenu THEN
            __UI_DestroyControl Control(__UI_ActiveMenu)
            b$ = MKI$(-2) 'Signal to the editor that the preview can't show the context menu
            PUT #UiEditorFile, OffsetNewDataFromPreview, b$
        ELSEIF __UI_ActiveMenu > 0 AND LEFT$(Control(__UI_ParentMenu).Name, 5) = "__UI_" THEN
            b$ = MKI$(-5) 'Signal to the editor that a context menu is successfully shown
            PUT #UiEditorFile, OffsetNewDataFromPreview, b$
        END IF

        b$ = MKL$(__UI_TotalSelectedControls)
        PUT #UiEditorFile, OffsetTotalControlsSelected, b$
        IF Control(__UI_FirstSelectedID).ID = 0 THEN __UI_FirstSelectedID = 0
        b$ = MKL$(__UI_FirstSelectedID)
        PUT #UiEditorFile, OffsetFirstSelectedID, b$
        b$ = MKL$(__UI_FormID)
        PUT #UiEditorFile, OffsetFormID, b$

        MidRead = False
        CLOSE #UiEditorFile
    END IF
END SUB

SUB __UI_BeforeUnload
    __UI_UnloadSignal = False
    SendSignal -9
END SUB

SUB __UI_BeforeInit
    __UI_DesignMode = True
    UiPreviewPID = __UI_GetPID

    IF _FILEEXISTS("InForm/UiEditorPreview.frmbin") THEN
        DIM FileToLoad AS INTEGER, a$
        FileToLoad = FREEFILE
        OPEN "InForm/UiEditorPreview.frmbin" FOR BINARY AS #FileToLoad
        a$ = SPACE$(LOF(FileToLoad))
        GET #FileToLoad, 1, a$
        CLOSE #FileToLoad

        IF INSTR(a$, "SUB __UI_LoadForm") > 0 THEN
            LoadPreviewText
        ELSE
            LoadPreview
        END IF
    END IF
END SUB

SUB __UI_FormResized
    STATIC TimesResized AS INTEGER

    IF IsCreating THEN TimesResized = 0: IsCreating = False

    TimesResized = TimesResized + 1

    IF TimesResized > 5 THEN
        'Manually resizing a form triggers this event a few times;
        'Loading a form triggers it 2 or three times usually.
        TimesResized = 0
        SendSignal -8
    END IF
END SUB

SUB __UI_OnLoad

END SUB

SUB __UI_KeyPress (id AS LONG)
    SELECT CASE id
        CASE 214
            RestoreUndoImage
        CASE 215
            RestoreRedoImage
        CASE 216
            SaveUndoImage
    END SELECT
END SUB

SUB __UI_TextChanged (id AS LONG)
END SUB

SUB __UI_ValueChanged (id AS LONG)
END SUB

FUNCTION Unpack$ (PackedData$)
    'Adapted from Dav's BIN2BAS
    'http://www.qbasicnews.com/dav/qb64.php
    DIM A$, i&, B$, C%, F$, C$, t%, B&, X$, btemp$, BASFILE$

    A$ = PackedData$

    FOR i& = 1 TO LEN(A$) STEP 4: B$ = MID$(A$, i&, 4)
        IF INSTR(1, B$, "%") THEN
            FOR C% = 1 TO LEN(B$): F$ = MID$(B$, C%, 1)
                IF F$ <> "%" THEN C$ = C$ + F$
            NEXT: B$ = C$
            END IF: FOR t% = LEN(B$) TO 1 STEP -1
            B& = B& * 64 + ASC(MID$(B$, t%)) - 48
            NEXT: X$ = "": FOR t% = 1 TO LEN(B$) - 1
            X$ = X$ + CHR$(B& AND 255): B& = B& \ 256
    NEXT: btemp$ = btemp$ + X$: NEXT

    Unpack$ = btemp$
END FUNCTION

SUB LoadPreview
    DIM a$, b$, i AS LONG, __UI_EOF AS _BYTE, Answer AS _BYTE
    DIM NewType AS INTEGER, NewWidth AS INTEGER, NewHeight AS INTEGER
    DIM NewLeft AS INTEGER, NewTop AS INTEGER, NewName AS STRING
    DIM NewParentID AS STRING, FloatValue AS _FLOAT, TempValue AS LONG
    DIM Dummy AS LONG
    DIM BinaryFileNum AS INTEGER, LogFileNum AS INTEGER

    CONST LogFileLoad = False

    IF _FILEEXISTS("InForm/UiEditorPreview.frmbin") = 0 THEN
        EXIT SUB
    ELSE
        BinaryFileNum = FREEFILE
        OPEN "InForm/UiEditorPreview.frmbin" FOR BINARY AS #BinaryFileNum

        LogFileNum = FREEFILE
        IF LogFileLoad THEN OPEN "ui_log.txt" FOR OUTPUT AS #LogFileNum
        b$ = SPACE$(7): GET #BinaryFileNum, 1, b$
        IF b$ <> "InForm" + CHR$(1) THEN
            GOTO LoadError
            EXIT SUB
        END IF
        IF LogFileLoad THEN PRINT #LogFileNum, "FOUND INFORM+1"
        __UI_AutoRefresh = False
        FOR i = UBOUND(Control) TO 1 STEP -1
            IF LEFT$(Control(i).Name, 5) <> "__UI_" THEN
                __UI_DestroyControl Control(i)
            END IF
        NEXT
        IF LogFileLoad THEN PRINT #LogFileNum, "DESTROYED CONTROLS"

        b$ = SPACE$(4): GET #BinaryFileNum, , b$
        IF LogFileLoad THEN PRINT #LogFileNum, "READ NEW ARRAYS:" + STR$(CVL(b$))

        REDIM _PRESERVE Caption(1 TO CVL(b$)) AS STRING
        REDIM __UI_TempCaptions(1 TO CVL(b$)) AS STRING
        REDIM Text(1 TO CVL(b$)) AS STRING
        REDIM __UI_TempTexts(1 TO CVL(b$)) AS STRING
        REDIM ToolTip(1 TO CVL(b$)) AS STRING
        REDIM __UI_TempTips(1 TO CVL(b$)) AS STRING
        REDIM _PRESERVE Control(0 TO CVL(b$)) AS __UI_ControlTYPE
        b$ = SPACE$(2): GET #BinaryFileNum, , b$
        IF LogFileLoad THEN PRINT #LogFileNum, "READ NEW CONTROL:" + STR$(CVI(b$))
        IF CVI(b$) <> -1 THEN GOTO LoadError
        DO
            b$ = SPACE$(4): GET #BinaryFileNum, , b$
            Dummy = CVL(b$)
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
            IF CVI(b$) > 0 THEN
                NewParentID = SPACE$(CVI(b$)): GET #BinaryFileNum, , NewParentID
                IF LogFileLoad THEN PRINT #LogFileNum, "PARENT:" + NewParentID
            ELSE
                NewParentID = ""
                IF LogFileLoad THEN PRINT #LogFileNum, "PARENT: ORPHAN/CONTAINER"
            END IF

            TempValue = __UI_NewControl(NewType, NewName, NewWidth, NewHeight, NewLeft, NewTop, __UI_GetID(NewParentID))
            IF NewType = __UI_Type_PictureBox THEN Control(TempValue).HasBorder = False

            DO 'read properties
                b$ = SPACE$(2): GET #BinaryFileNum, , b$
                IF LogFileLoad THEN PRINT #LogFileNum, "PROPERTY:" + STR$(CVI(b$)) + " :";
                SELECT CASE CVI(b$)
                    CASE -2 'Caption
                        b$ = SPACE$(4): GET #BinaryFileNum, , b$
                        b$ = SPACE$(CVL(b$))
                        GET #BinaryFileNum, , b$
                        SetCaption TempValue, b$
                        IF LogFileLoad THEN PRINT #LogFileNum, "CAPTION:" + Caption(TempValue)
                    CASE -3 'Text
                        b$ = SPACE$(4): GET #BinaryFileNum, , b$
                        b$ = SPACE$(CVL(b$))
                        GET #BinaryFileNum, , b$
                        Text(TempValue) = b$
                        IF Control(TempValue).Type = __UI_Type_PictureBox OR Control(TempValue).Type = __UI_Type_Button THEN
                            LoadImage Control(TempValue), Text(TempValue)
                        ELSEIF Control(TempValue).Type = __UI_Type_Form THEN
                            IF ExeIcon <> 0 THEN _FREEIMAGE ExeIcon: ExeIcon = 0
                            ExeIcon = IconPreview&(b$)
                            IF ExeIcon < -1 THEN
                                _ICON ExeIcon
                            END IF
                        END IF
                        IF LogFileLoad THEN PRINT #LogFileNum, "TEXT:" + Text(TempValue)
                    CASE -4 'Stretch
                        Control(TempValue).Stretch = True
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

                        Control(TempValue).Font = SetFont(NewFontFile, NewFontSize, NewFontAttributes)
                    CASE -6 'ForeColor
                        b$ = SPACE$(4): GET #BinaryFileNum, , b$
                        Control(TempValue).ForeColor = _CV(_UNSIGNED LONG, b$)
                        IF LogFileLoad THEN PRINT #LogFileNum, "FORECOLOR"
                    CASE -7 'BackColor
                        b$ = SPACE$(4): GET #BinaryFileNum, , b$
                        Control(TempValue).BackColor = _CV(_UNSIGNED LONG, b$)
                        IF LogFileLoad THEN PRINT #LogFileNum, "BACKCOLOR"
                    CASE -8 'SelectedForeColor
                        b$ = SPACE$(4): GET #BinaryFileNum, , b$
                        Control(TempValue).SelectedForeColor = _CV(_UNSIGNED LONG, b$)
                        IF LogFileLoad THEN PRINT #LogFileNum, "SELECTEDFORECOLOR"
                    CASE -9 'SelectedBackColor
                        b$ = SPACE$(4): GET #BinaryFileNum, , b$
                        Control(TempValue).SelectedBackColor = _CV(_UNSIGNED LONG, b$)
                        IF LogFileLoad THEN PRINT #LogFileNum, "SELECTEDBACKCOLOR"
                    CASE -10 'BorderColor
                        b$ = SPACE$(4): GET #BinaryFileNum, , b$
                        Control(TempValue).BorderColor = _CV(_UNSIGNED LONG, b$)
                        IF LogFileLoad THEN PRINT #LogFileNum, "BORDERCOLOR"
                    CASE -11
                        Control(TempValue).BackStyle = __UI_Transparent
                        IF LogFileLoad THEN PRINT #LogFileNum, "BACKSTYLE:TRANSPARENT"
                    CASE -12
                        Control(TempValue).HasBorder = True
                        IF LogFileLoad THEN PRINT #LogFileNum, "HASBORDER"
                    CASE -13
                        b$ = SPACE$(1): GET #BinaryFileNum, , b$
                        Control(TempValue).Align = _CV(_BYTE, b$)
                        IF LogFileLoad THEN PRINT #LogFileNum, "ALIGN="; Control(TempValue).Align
                    CASE -14
                        b$ = SPACE$(LEN(FloatValue)): GET #BinaryFileNum, , b$
                        Control(TempValue).Value = _CV(_FLOAT, b$)
                        IF LogFileLoad THEN PRINT #LogFileNum, "VALUE="; Control(TempValue).Value
                    CASE -15
                        b$ = SPACE$(LEN(FloatValue)): GET #BinaryFileNum, , b$
                        Control(TempValue).Min = _CV(_FLOAT, b$)
                        IF LogFileLoad THEN PRINT #LogFileNum, "MIN="; Control(TempValue).Min
                    CASE -16
                        b$ = SPACE$(LEN(FloatValue)): GET #BinaryFileNum, , b$
                        Control(TempValue).Max = _CV(_FLOAT, b$)
                        IF LogFileLoad THEN PRINT #LogFileNum, "MAX="; Control(TempValue).Max
                    CASE -17
                        b$ = SPACE$(2): GET #BinaryFileNum, , b$
                        Control(TempValue).HotKey = CVI(b$)
                        IF LogFileLoad THEN PRINT #LogFileNum, "HOTKEY="; Control(TempValue).HotKey; "("; CHR$(Control(TempValue).HotKey); ")"
                    CASE -18
                        b$ = SPACE$(2): GET #BinaryFileNum, , b$
                        Control(TempValue).HotKeyOffset = CVI(b$)
                        IF LogFileLoad THEN PRINT #LogFileNum, "HOTKEYOFFSET="; Control(TempValue).HotKeyOffset
                    CASE -19
                        Control(TempValue).ShowPercentage = True
                        IF LogFileLoad THEN PRINT #LogFileNum, "SHOWPERCENTAGE"
                    CASE -20
                        Control(TempValue).CanHaveFocus = True
                        IF LogFileLoad THEN PRINT #LogFileNum, "CANHAVEFOCUS"
                    CASE -21
                        Control(TempValue).Disabled = True
                        IF LogFileLoad THEN PRINT #LogFileNum, "DISABLED"
                    CASE -22
                        Control(TempValue).Hidden = True
                        IF LogFileLoad THEN PRINT #LogFileNum, "HIDDEN"
                    CASE -23
                        Control(TempValue).CenteredWindow = True
                        IF LogFileLoad THEN PRINT #LogFileNum, "CENTEREDWINDOW"
                    CASE -24 'Tips
                        b$ = SPACE$(4): GET #BinaryFileNum, , b$
                        b$ = SPACE$(CVL(b$))
                        GET #BinaryFileNum, , b$
                        ToolTip(TempValue) = b$
                        IF LogFileLoad THEN PRINT #LogFileNum, "TIP: "; ToolTip(TempValue)
                    CASE -25
                        DIM ContextMenuName AS STRING
                        b$ = SPACE$(2): GET #BinaryFileNum, , b$
                        ContextMenuName = SPACE$(CVI(b$)): GET #BinaryFileNum, , ContextMenuName
                        Control(TempValue).ContextMenuID = __UI_GetID(ContextMenuName)
                        IF LogFileLoad THEN PRINT #LogFileNum, "CONTEXTMENU:"; ContextMenuName
                    CASE -26
                        b$ = SPACE$(LEN(FloatValue)): GET #BinaryFileNum, , b$
                        Control(TempValue).Interval = _CV(_FLOAT, b$)
                        IF LogFileLoad THEN PRINT #LogFileNum, "INTERVAL="; Control(TempValue).Interval
                    CASE -27
                        Control(TempValue).WordWrap = True
                        IF LogFileLoad THEN PRINT #LogFileNum, "WORDWRAP"
                    CASE -28
                        b$ = SPACE$(4): GET #BinaryFileNum, , b$
                        Control(TempValue).TransparentColor = _CV(_UNSIGNED LONG, b$)
                        IF LogFileLoad THEN PRINT #LogFileNum, "TRANSPARENTCOLOR"
                        __UI_ClearColor Control(TempValue).HelperCanvas, Control(TempValue).TransparentColor, -1
                    CASE -29
                        Control(TempValue).CanResize = True
                        IF LogFileLoad THEN PRINT #LogFileNum, "CANRESIZE"
                    CASE -31
                        b$ = SPACE$(2): GET #BinaryFileNum, , b$
                        Control(TempValue).Padding = CVI(b$)
                        IF LogFileLoad THEN PRINT #LogFileNum, "PADDING" + STR$(CVI(b$))
                    CASE -32
                        b$ = SPACE$(1): GET #BinaryFileNum, , b$
                        Control(TempValue).VAlign = _CV(_BYTE, b$)
                        IF LogFileLoad THEN PRINT #LogFileNum, "VALIGN="; Control(TempValue).VAlign
                    CASE -33
                        Control(TempValue).PasswordField = True
                        IF LogFileLoad THEN PRINT #LogFileNum, "PASSWORDFIELD"
                    CASE -34
                        b$ = SPACE$(4): GET #BinaryFileNum, , b$
                        Control(TempValue).Encoding = CVL(b$)
                        IF LogFileLoad THEN PRINT #LogFileNum, "ENCODING="; Control(TempValue).Encoding
                    CASE -35
                        __UI_DefaultButtonID = TempValue
                        IF LogFileLoad THEN PRINT #LogFileNum, "DEFAULT BUTTON"
                    CASE -36
                        b$ = SPACE$(4): GET #BinaryFileNum, , b$
                        b$ = SPACE$(CVL(b$))
                        GET #BinaryFileNum, , b$
                        Mask(TempValue) = b$
                        IF LogFileLoad THEN PRINT #LogFileNum, "MASK:" + Mask(TempValue)
                    CASE -1 'new control
                        IF LogFileLoad THEN PRINT #LogFileNum, "READ NEW CONTROL: -1"
                        EXIT DO
                    CASE -1024
                        IF LogFileLoad THEN PRINT #LogFileNum, "READ END OF FILE: -1024"
                        __UI_EOF = True
                        EXIT DO
                    CASE ELSE
                        IF LogFileLoad THEN PRINT #LogFileNum, "UNKNOWN PROPERTY ="; CVI(b$)
                        EXIT DO
                END SELECT
            LOOP
        LOOP UNTIL __UI_EOF
        CLOSE #BinaryFileNum
        IF LogFileLoad THEN CLOSE #LogFileNum
        __UI_AutoRefresh = True
        EXIT SUB

        LoadError:
        CLOSE #BinaryFileNum
        KILL "InForm/UiEditorPreview.frmbin"
        __UI_AutoRefresh = True
        EXIT SUB
    END IF
END SUB

SUB LoadPreviewText
    DIM a$, b$, i AS LONG, __UI_EOF AS _BYTE, Answer AS _BYTE
    DIM NewType AS INTEGER, NewWidth AS INTEGER, NewHeight AS INTEGER
    DIM NewLeft AS INTEGER, NewTop AS INTEGER, NewName AS STRING
    DIM NewParentID AS STRING, FloatValue AS _FLOAT, TempValue AS LONG
    DIM Dummy AS LONG, DummyText$, TotalNewControls AS LONG
    DIM BinaryFileNum AS INTEGER, LogFileNum AS INTEGER
    DIM NewRed AS _UNSIGNED _BYTE, NewGreen AS _UNSIGNED _BYTE, NewBlue AS _UNSIGNED _BYTE

    CONST LogFileLoad = False

    IF _FILEEXISTS("InForm/UiEditorPreview.frmbin") = 0 THEN
        EXIT SUB
    ELSE
        BinaryFileNum = FREEFILE
        OPEN "InForm/UiEditorPreview.frmbin" FOR BINARY AS #BinaryFileNum

        LogFileNum = FREEFILE
        IF LogFileLoad THEN OPEN "ui_log.txt" FOR OUTPUT AS #LogFileNum
        DO
            LINE INPUT #BinaryFileNum, b$
        LOOP UNTIL b$ = "SUB __UI_LoadForm"
        IF LogFileLoad THEN PRINT #LogFileNum, "FOUND SUB __UI_LOADFORM"

        __UI_AutoRefresh = False
        FOR i = UBOUND(Control) TO 1 STEP -1
            IF LEFT$(Control(i).Name, 5) <> "__UI_" THEN
                __UI_DestroyControl Control(i)
            END IF
        NEXT
        IF LogFileLoad THEN PRINT #LogFileNum, "DESTROYED CONTROLS"

        DO
            LINE INPUT #BinaryFileNum, b$
        LOOP UNTIL INSTR(b$, "__UI_NewControl") > 0
        IF LogFileLoad THEN PRINT #LogFileNum, "READ NEW CONTROL"
        DO
            DummyText$ = nextParameter(b$)
            SELECT CASE DummyText$
                CASE "__UI_Type_Form": NewType = 1
                CASE "__UI_Type_Frame": NewType = 2
                CASE "__UI_Type_Button": NewType = 3
                CASE "__UI_Type_Label": NewType = 4
                CASE "__UI_Type_CheckBox": NewType = 5
                CASE "__UI_Type_RadioButton": NewType = 6
                CASE "__UI_Type_TextBox": NewType = 7
                CASE "__UI_Type_ProgressBar": NewType = 8
                CASE "__UI_Type_ListBox": NewType = 9
                CASE "__UI_Type_DropdownList": NewType = 10
                CASE "__UI_Type_MenuBar": NewType = 11
                CASE "__UI_Type_MenuItem": NewType = 12
                CASE "__UI_Type_MenuPanel": NewType = 13
                CASE "__UI_Type_PictureBox": NewType = 14
                CASE "__UI_Type_TrackBar": NewType = 15
                CASE "__UI_Type_ContextMenu": NewType = 16
                CASE "__UI_Type_Font": NewType = 17
                CASE "__UI_Type_ToggleSwitch": NewType = 18
            END SELECT
            IF LogFileLoad THEN PRINT #LogFileNum, "TYPE:" + DummyText$

            NewName = nextParameter(b$)
            IF LogFileLoad THEN PRINT #LogFileNum, "NAME:" + NewName

            NewWidth = VAL(nextParameter(b$))
            IF LogFileLoad THEN PRINT #LogFileNum, "WIDTH:" + STR$(NewWidth)

            NewHeight = VAL(nextParameter(b$))
            IF LogFileLoad THEN PRINT #LogFileNum, "HEIGHT:" + STR$(NewHeight)

            NewLeft = VAL(nextParameter(b$))
            IF LogFileLoad THEN PRINT #LogFileNum, "LEFT:" + STR$(NewLeft)

            NewTop = VAL(nextParameter(b$))
            IF LogFileLoad THEN PRINT #LogFileNum, "TOP:" + STR$(NewTop)

            DummyText$ = nextParameter(b$)
            IF DummyText$ = "0" THEN
                NewParentID = ""
                IF LogFileLoad THEN PRINT #LogFileNum, "PARENT: ORPHAN/CONTAINER"
            ELSE
                NewParentID = MID$(DummyText$, 13)
                IF LogFileLoad THEN PRINT #LogFileNum, "PARENT:" + NewParentID
            END IF

            TempValue = __UI_NewControl(NewType, NewName, NewWidth, NewHeight, NewLeft, NewTop, __UI_GetID(NewParentID))
            IF NewType = __UI_Type_PictureBox THEN Control(TempValue).HasBorder = False

            DO 'read properties
                DO
                    LINE INPUT #BinaryFileNum, b$
                    b$ = LTRIM$(RTRIM$(b$))
                    IF LEN(b$) > 0 THEN EXIT DO
                LOOP
                IF LEFT$(b$, 20) = "Control(__UI_NewID)." THEN
                    'Property
                    DummyText$ = MID$(b$, INSTR(21, b$, " = ") + 3)
                    SELECT CASE MID$(b$, 21, INSTR(21, b$, " =") - 21)
                        CASE "Stretch"
                            Control(TempValue).Stretch = (DummyText$ = "True")
                        CASE "Font"
                            DIM NewFontFile AS STRING
                            DIM NewFontSize AS INTEGER, NewFontAttributes AS STRING

                            IF LEFT$(DummyText$, 8) = "SetFont(" THEN
                                NewFontFile = nextParameter(DummyText$)
                                NewFontSize = VAL(nextParameter(DummyText$))
                                NewFontAttributes = nextParameter(DummyText$)
                                Control(TempValue).Font = SetFont(NewFontFile, NewFontSize, NewFontAttributes)
                            END IF
                        CASE "ForeColor"
                            IF LEFT$(DummyText$, 6) = "_RGB32" THEN
                                NewRed = VAL(nextParameter(DummyText$))
                                NewGreen = VAL(nextParameter(DummyText$))
                                NewBlue = VAL(nextParameter(DummyText$))
                                Control(TempValue).ForeColor = _RGB32(NewRed, NewGreen, NewBlue)
                            ELSEIF LEFT$(DummyText$, 2) = "&H" THEN
                                Control(TempValue).ForeColor = VAL(DummyText$)
                            END IF
                        CASE "BackColor"
                            IF LEFT$(DummyText$, 6) = "_RGB32" THEN
                                NewRed = VAL(nextParameter(DummyText$))
                                NewGreen = VAL(nextParameter(DummyText$))
                                NewBlue = VAL(nextParameter(DummyText$))
                                Control(TempValue).BackColor = _RGB32(NewRed, NewGreen, NewBlue)
                            ELSEIF LEFT$(DummyText$, 2) = "&H" THEN
                                Control(TempValue).BackColor = VAL(DummyText$)
                            END IF
                        CASE "SelectedForeColor"
                            IF LEFT$(DummyText$, 6) = "_RGB32" THEN
                                NewRed = VAL(nextParameter(DummyText$))
                                NewGreen = VAL(nextParameter(DummyText$))
                                NewBlue = VAL(nextParameter(DummyText$))
                                Control(TempValue).SelectedForeColor = _RGB32(NewRed, NewGreen, NewBlue)
                            ELSEIF LEFT$(DummyText$, 2) = "&H" THEN
                                Control(TempValue).SelectedForeColor = VAL(DummyText$)
                            END IF
                        CASE "SelectedBackColor"
                            IF LEFT$(DummyText$, 6) = "_RGB32" THEN
                                NewRed = VAL(nextParameter(DummyText$))
                                NewGreen = VAL(nextParameter(DummyText$))
                                NewBlue = VAL(nextParameter(DummyText$))
                                Control(TempValue).SelectedBackColor = _RGB32(NewRed, NewGreen, NewBlue)
                            ELSEIF LEFT$(DummyText$, 2) = "&H" THEN
                                Control(TempValue).SelectedBackColor = VAL(DummyText$)
                            END IF
                        CASE "BorderColor"
                            IF LEFT$(DummyText$, 6) = "_RGB32" THEN
                                NewRed = VAL(nextParameter(DummyText$))
                                NewGreen = VAL(nextParameter(DummyText$))
                                NewBlue = VAL(nextParameter(DummyText$))
                                Control(TempValue).BorderColor = _RGB32(NewRed, NewGreen, NewBlue)
                            ELSEIF LEFT$(DummyText$, 2) = "&H" THEN
                                Control(TempValue).BorderColor = VAL(DummyText$)
                            END IF
                        CASE "BackStyle"
                            IF DummyText$ = "__UI_Transparent" THEN
                                Control(TempValue).BackStyle = __UI_Transparent
                            END IF
                        CASE "HasBorder"
                            Control(TempValue).HasBorder = (DummyText$ = "True")
                        CASE "Align"
                            SELECT CASE DummyText$
                                CASE "__UI_Center": Control(TempValue).Align = __UI_Center
                                CASE "__UI_Right": Control(TempValue).Align = __UI_Right
                            END SELECT
                        CASE "Value"
                            Control(TempValue).Value = VAL(DummyText$)
                        CASE "Min"
                            Control(TempValue).Min = VAL(DummyText$)
                        CASE "Max"
                            Control(TempValue).Max = VAL(DummyText$)
                        CASE "ShowPercentage"
                            Control(TempValue).ShowPercentage = (DummyText$ = "True")
                        CASE "CanHaveFocus"
                            Control(TempValue).CanHaveFocus = (DummyText$ = "True")
                        CASE "Disabled"
                            Control(TempValue).Disabled = (DummyText$ = "True")
                        CASE "Hidden"
                            Control(TempValue).Hidden = (DummyText$ = "True")
                        CASE "CenteredWindow"
                            Control(TempValue).CenteredWindow = (DummyText$ = "True")
                        CASE "ContextMenuID"
                        CASE "Interval"
                        CASE "WordWrap"
                            Control(TempValue).WordWrap = (DummyText$ = "True")
                        CASE "TransparentColor"
                            IF LEFT$(DummyText$, 6) = "_RGB32" THEN
                                NewRed = VAL(nextParameter(DummyText$))
                                NewGreen = VAL(nextParameter(DummyText$))
                                NewBlue = VAL(nextParameter(DummyText$))
                                Control(TempValue).TransparentColor = _RGB32(NewRed, NewGreen, NewBlue)
                                __UI_ClearColor Control(TempValue).HelperCanvas, Control(TempValue).TransparentColor, -1
                            ELSEIF LEFT$(DummyText$, 2) = "&H" THEN
                                Control(TempValue).TransparentColor = VAL(DummyText$)
                                __UI_ClearColor Control(TempValue).HelperCanvas, Control(TempValue).TransparentColor, -1
                            END IF
                        CASE "CanResize"
                            Control(TempValue).CanResize = (DummyText$ = "True")
                        CASE "Padding"
                            Control(TempValue).Padding = VAL(DummyText$)
                        CASE "VAlign"
                            SELECT CASE DummyText$
                                CASE "__UI_Middle": Control(TempValue).VAlign = __UI_Middle
                                CASE "__UI_Bottom": Control(TempValue).VAlign = __UI_Bottom
                            END SELECT
                        CASE "PasswordField"
                            Control(TempValue).PasswordField = (DummyText$ = "True")
                        CASE "Encoding"
                            Control(TempValue).Encoding = VAL(DummyText$)
                    END SELECT
                ELSEIF b$ = "__UI_DefaultButtonID = __UI_NewID" THEN
                    __UI_DefaultButtonID = TempValue
                ELSEIF LEFT$(b$, 11) = "SetCaption " THEN
                    'Caption
                    DummyText$ = nextParameter(b$) 'discard first parameter
                    DummyText$ = nextParameter(b$)
                    'Replace CHR$(10) with \n:
                    DummyText$ = Replace$(DummyText$, CHR$(34) + " + CHR$(10) + " + CHR$(34), "\n", False, 0)
                    SetCaption TempValue, DummyText$
                ELSEIF LEFT$(b$, 8) = "AddItem " THEN
                    'Caption
                    DummyText$ = nextParameter(b$) 'discard first parameter
                    DummyText$ = nextParameter(b$)
                    AddItem TempValue, DummyText$
                ELSEIF LEFT$(b$, 10) = "LoadImage " THEN
                    'Image
                    DummyText$ = nextParameter(b$) 'discard first parameter
                    DummyText$ = nextParameter(b$)
                    LoadImage Control(TempValue), DummyText$
                ELSEIF LEFT$(b$, 22) = "ToolTip(__UI_NewID) = " THEN
                    'Tooltip
                    DummyText$ = MID$(b$, INSTR(b$, " = ") + 3)
                    DummyText$ = Replace$(DummyText$, CHR$(34) + " + CHR$(10) + " + CHR$(34), CHR$(10), False, 0)
                    ToolTip(TempValue) = removeQuotation$(DummyText$)
                ELSEIF LEFT$(b$, 19) = "Text(__UI_NewID) = " THEN
                    'Text
                    DummyText$ = MID$(b$, INSTR(b$, " = ") + 3)
                    DummyText$ = Replace$(DummyText$, CHR$(34) + " + CHR$(10) + " + CHR$(34), CHR$(10), False, 0)
                    Text(TempValue) = removeQuotation$(DummyText$)

                    IF Control(TempValue).Type = __UI_Type_PictureBox OR Control(TempValue).Type = __UI_Type_Button THEN
                        LoadImage Control(TempValue), Text(TempValue)
                    ELSEIF Control(TempValue).Type = __UI_Type_Form THEN
                        IF ExeIcon <> 0 THEN _FREEIMAGE ExeIcon: ExeIcon = 0
                        ExeIcon = IconPreview&(b$)
                        IF ExeIcon < -1 THEN
                            _ICON ExeIcon
                        END IF
                    END IF
                ELSEIF INSTR(b$, "__UI_NewControl") > 0 THEN
                    'New Control
                    EXIT DO
                ELSEIF b$ = "END SUB" THEN
                    __UI_EOF = True
                    EXIT DO
                END IF
            LOOP
        LOOP UNTIL __UI_EOF
        CLOSE #BinaryFileNum
        IF LogFileLoad THEN CLOSE #LogFileNum
        __UI_AutoRefresh = True
        EXIT SUB

        LoadError:
        CLOSE #BinaryFileNum
        KILL "InForm/UiEditorPreview.frmbin"
        __UI_AutoRefresh = True
        EXIT SUB
    END IF
    EXIT SUB
END SUB

FUNCTION nextParameter$ (__text$)
    STATIC lastText$
    STATIC position1 AS LONG, position2 AS LONG
    DIM text$, thisParameter$

    text$ = LTRIM$(RTRIM$(__text$))
    IF text$ <> lastText$ THEN
        lastText$ = text$
        position1 = INSTR(text$, "(")
        IF position1 > 0 THEN
            'check that this bracket is outside quotation marks
            DIM quote AS _BYTE, i AS LONG
            FOR i = 1 TO position1
                IF ASC(text$, i) = 34 THEN quote = NOT quote
            NEXT
            IF quote THEN position1 = 0
        END IF

        IF position1 = 0 THEN
            'no opening bracket; must be a sub call
            position1 = INSTR(text$, " ")
            IF position1 = 0 THEN EXIT FUNCTION
            position1 = position1 + 1 'skip space
        ELSE
            position1 = position1 + 1 'skip bracket
        END IF
    END IF

    position2 = INSTR(position1, text$, ",")
    IF position2 = 0 THEN position2 = INSTR(position1, text$, ")")
    IF position2 > 0 THEN
        'check that this bracket is outside quotation marks
        quote = False
        FOR i = 1 TO position2
            IF ASC(text$, i) = 34 THEN quote = NOT quote
        NEXT
        IF quote THEN position2 = 0
    END IF
    IF position2 = 0 THEN position2 = LEN(text$) + 1
    thisParameter$ = LTRIM$(RTRIM$(MID$(text$, position1, position2 - position1)))
    nextParameter$ = removeQuotation$(thisParameter$)
    position1 = position2 + 1
END FUNCTION

FUNCTION removeQuotation$ (__text$)
    DIM text$
    text$ = __text$
    IF LEFT$(text$, 1) = CHR$(34) THEN text$ = MID$(text$, 2)
    IF RIGHT$(text$, 1) = CHR$(34) THEN text$ = LEFT$(text$, LEN(text$) - 1)
    removeQuotation$ = text$
END FUNCTION

SUB SavePreview
    DIM b$, i AS LONG, a$, FontSetup$, TempValue AS LONG
    DIM BinFileNum AS INTEGER, TxtFileNum AS INTEGER

    CONST Debug = False

    BinFileNum = FREEFILE
    OPEN "InForm/UiEditorPreview.frmbin" FOR BINARY AS #BinFileNum

    IF Debug THEN
        TxtFileNum = FREEFILE
        OPEN "UiEditorPreview.txt" FOR OUTPUT AS #TxtFileNum
    END IF

    b$ = "InForm" + CHR$(1)
    PUT #BinFileNum, 1, b$
    b$ = MKL$(UBOUND(Control))
    PUT #BinFileNum, , b$
    FOR i = 1 TO UBOUND(Control)
        IF Control(i).ID > 0 AND Control(i).Type <> __UI_Type_MenuPanel AND Control(i).Type <> __UI_Type_Font AND LEN(RTRIM$(Control(i).Name)) > 0 AND LEFT$(RTRIM$(Control(i).Name), 5) <> "__UI_" THEN
            IF Debug THEN
                PRINT #TxtFileNum, Control(i).ID,
                PRINT #TxtFileNum, RTRIM$(Control(i).Name)
            END IF
            b$ = MKI$(-1) + MKL$(i) + MKI$(Control(i).Type) '-1 indicates a new control
            b$ = b$ + MKI$(LEN(RTRIM$(Control(i).Name)))
            b$ = b$ + RTRIM$(Control(i).Name)
            b$ = b$ + MKI$(Control(i).Width) + MKI$(Control(i).Height) + MKI$(Control(i).Left) + MKI$(Control(i).Top)
            IF Control(i).ParentID > 0 THEN
                b$ = b$ + MKI$(LEN(RTRIM$(Control(Control(i).ParentID).Name))) + RTRIM$(Control(Control(i).ParentID).Name)
            ELSE
                b$ = b$ + MKI$(0)
            END IF
            PUT #BinFileNum, , b$

            IF LEN(Caption(i)) > 0 THEN
                IF Control(i).HotKeyPosition > 0 THEN
                    a$ = LEFT$(Caption(i), Control(i).HotKeyPosition - 1) + "&" + MID$(Caption(i), Control(i).HotKeyPosition)
                ELSE
                    a$ = Caption(i)
                END IF
                b$ = MKI$(-2) + MKL$(LEN(a$)) '-2 indicates a caption
                PUT #BinFileNum, , b$
                PUT #BinFileNum, , a$
            END IF

            IF LEN(ToolTip(i)) > 0 THEN
                b$ = MKI$(-24) + MKL$(LEN(ToolTip(i))) '-24 indicates a tip
                PUT #BinFileNum, , b$
                PUT #BinFileNum, , ToolTip(i)
            END IF

            IF LEN(Text(i)) > 0 THEN
                b$ = MKI$(-3) + MKL$(LEN(Text(i))) '-3 indicates a text
                PUT #BinFileNum, , b$
                PUT #BinFileNum, , Text(i)
            END IF

            IF LEN(Mask(i)) > 0 THEN
                b$ = MKI$(-36) + MKL$(LEN(Text(i))) '-3 indicates a text
                PUT #BinFileNum, , b$
                PUT #BinFileNum, , Text(i)
            END IF

            IF Control(i).TransparentColor > 0 THEN
                b$ = MKI$(-28) + _MK$(_UNSIGNED LONG, Control(i).TransparentColor)
                PUT #BinFileNum, , b$
            END IF
            IF Control(i).Stretch THEN
                b$ = MKI$(-4)
                PUT #BinFileNum, , b$
            END IF
            'Inheritable properties won't be saved if they are the same as the parent's
            IF Control(i).Type = __UI_Type_Form THEN
                IF Control(i).Font = 8 OR Control(i).Font = 16 THEN
                    'Internal fonts
                    SaveInternalFont:
                    FontSetup$ = "**" + LTRIM$(STR$(Control(__UI_GetFontID(Control(i).Font)).Max))
                    b$ = MKI$(-5) + MKI$(LEN(FontSetup$)) + FontSetup$
                    PUT #BinFileNum, , b$
                ELSE
                    SaveExternalFont:
                    FontSetup$ = ToolTip(__UI_GetFontID(Control(i).Font)) + "*" + Caption(__UI_GetFontID(Control(i).Font)) + "*" + LTRIM$(STR$(Control(__UI_GetFontID(Control(i).Font)).Max))
                    b$ = MKI$(-5) + MKI$(LEN(FontSetup$)) + FontSetup$
                    PUT #BinFileNum, , b$
                END IF
            ELSE
                IF Control(i).ParentID > 0 THEN
                    IF Control(i).Font > 0 AND Control(i).Font <> Control(Control(i).ParentID).Font THEN
                        IF Control(i).Font = 8 OR Control(i).Font = 16 THEN
                            GOTO SaveInternalFont
                        ELSE
                            GOTO SaveExternalFont
                        END IF
                    END IF
                ELSE
                    IF Control(i).Font > 0 AND Control(i).Font <> Control(__UI_FormID).Font THEN
                        IF Control(i).Font = 8 OR Control(i).Font = 16 THEN
                            GOTO SaveInternalFont
                        ELSE
                            GOTO SaveExternalFont
                        END IF
                    END IF
                END IF
            END IF
            'Colors are saved only if they differ from the theme's defaults
            IF Control(i).ForeColor <> __UI_DefaultColor(Control(i).Type, 1) THEN
                b$ = MKI$(-6) + _MK$(_UNSIGNED LONG, Control(i).ForeColor)
                PUT #BinFileNum, , b$
            END IF
            IF Control(i).BackColor <> __UI_DefaultColor(Control(i).Type, 2) THEN
                b$ = MKI$(-7) + _MK$(_UNSIGNED LONG, Control(i).BackColor)
                PUT #BinFileNum, , b$
            END IF
            IF Control(i).SelectedForeColor <> __UI_DefaultColor(Control(i).Type, 3) THEN
                b$ = MKI$(-8) + _MK$(_UNSIGNED LONG, Control(i).SelectedForeColor)
                PUT #BinFileNum, , b$
            END IF
            IF Control(i).SelectedBackColor <> __UI_DefaultColor(Control(i).Type, 4) THEN
                b$ = MKI$(-9) + _MK$(_UNSIGNED LONG, Control(i).SelectedBackColor)
                PUT #BinFileNum, , b$
            END IF
            IF Control(i).BorderColor <> __UI_DefaultColor(Control(i).Type, 5) THEN
                b$ = MKI$(-10) + _MK$(_UNSIGNED LONG, Control(i).BorderColor)
                PUT #BinFileNum, , b$
            END IF
            IF Control(i).BackStyle = __UI_Transparent THEN
                b$ = MKI$(-11): PUT #BinFileNum, , b$
            END IF
            IF Control(i).HasBorder THEN
                b$ = MKI$(-12): PUT #BinFileNum, , b$
            END IF
            IF Control(i).Align = __UI_Center THEN
                b$ = MKI$(-13) + _MK$(_BYTE, Control(i).Align): PUT #BinFileNum, , b$
            ELSEIF Control(i).Align = __UI_Right THEN
                b$ = MKI$(-13) + _MK$(_BYTE, Control(i).Align): PUT #BinFileNum, , b$
            END IF
            IF Control(i).VAlign = __UI_Middle THEN
                b$ = MKI$(-32) + _MK$(_BYTE, Control(i).VAlign): PUT #BinFileNum, , b$
            ELSEIF Control(i).VAlign = __UI_Bottom THEN
                b$ = MKI$(-32) + _MK$(_BYTE, Control(i).VAlign): PUT #BinFileNum, , b$
            END IF
            IF Control(i).PasswordField = True THEN
                b$ = MKI$(-33): PUT #BinFileNum, , b$
            END IF
            IF Control(i).Encoding > 0 THEN
                b$ = MKI$(-34) + MKL$(Control(i).Encoding): PUT #BinFileNum, , b$
            END IF
            IF Control(i).Value <> 0 THEN
                b$ = MKI$(-14) + _MK$(_FLOAT, Control(i).Value): PUT #BinFileNum, , b$
            END IF
            IF Control(i).Min <> 0 THEN
                b$ = MKI$(-15) + _MK$(_FLOAT, Control(i).Min): PUT #BinFileNum, , b$
            END IF
            IF Control(i).Max <> 0 THEN
                b$ = MKI$(-16) + _MK$(_FLOAT, Control(i).Max): PUT #BinFileNum, , b$
            END IF
            'IF Control(i).HotKey <> 0 THEN
            '    b$ = MKI$(-17) + MKI$(Control(i).HotKey): PUT #BinFileNum, , b$
            'END IF
            'IF Control(i).HotKeyOffset <> 0 THEN
            '    b$ = MKI$(-18) + MKI$(Control(i).HotKeyOffset): PUT #BinFileNum, , b$
            'END IF
            IF Control(i).ShowPercentage THEN
                b$ = MKI$(-19): PUT #BinFileNum, , b$
            END IF
            IF Control(i).CanHaveFocus THEN
                b$ = MKI$(-20): PUT #BinFileNum, , b$
            END IF
            IF Control(i).Disabled THEN
                b$ = MKI$(-21): PUT #BinFileNum, , b$
            END IF
            IF Control(i).Hidden THEN
                b$ = MKI$(-22): PUT #BinFileNum, , b$
            END IF
            IF Control(i).CenteredWindow THEN
                b$ = MKI$(-23): PUT #BinFileNum, , b$
            END IF
            IF Control(i).ContextMenuID THEN
                IF LEFT$(Control(Control(i).ContextMenuID).Name, 9) <> "__UI_Text" AND LEFT$(Control(Control(i).ContextMenuID).Name, 16) <> "__UI_PreviewMenu" THEN
                    b$ = MKI$(-25) + MKI$(LEN(RTRIM$(Control(Control(i).ContextMenuID).Name))) + RTRIM$(Control(Control(i).ContextMenuID).Name): PUT #BinFileNum, , b$
                END IF
            END IF
            IF Control(i).Interval THEN
                b$ = MKI$(-26) + _MK$(_FLOAT, Control(i).Interval): PUT #BinFileNum, , b$
            END IF
            IF Control(i).WordWrap THEN
                b$ = MKI$(-27): PUT #BinFileNum, , b$
            END IF
            IF Control(i).CanResize AND Control(i).Type = __UI_Type_Form THEN
                b$ = MKI$(-29): PUT #BinFileNum, , b$
            END IF
            'IF Control(i).HotKey > 0 THEN
            '    b$ = MKI$(-30) + MKI$(Control(i).HotKeyPosition): PUT #BinFileNum, , b$
            'END IF
            IF Control(i).Padding > 0 THEN
                b$ = MKI$(-31) + MKI$(Control(i).Padding): PUT #BinFileNum, , b$
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
    OPEN "InForm/UiEditor.dat" FOR BINARY AS #FileNum

    PUT #FileNum, Offset, b$
    CLOSE #FileNum
END SUB

SUB SendSignal (Value AS INTEGER)
    DIM FileNum AS INTEGER, b$
    FileNum = FREEFILE
    OPEN "InForm/UiEditor.dat" FOR BINARY AS #FileNum

    b$ = MKI$(Value): PUT #FileNum, OffsetNewDataFromPreview, b$
    CLOSE #FileNum
END SUB

FUNCTION AdaptName$ (tName$, TargetID AS LONG)
    DIM Name$, NewName$, i AS LONG, c$, NextIsCapital AS _BYTE, CheckID AS LONG
    Name$ = RTRIM$(tName$)

    IF LEN(Name$) = 0 THEN EXIT FUNCTION

    DO
        IF Alpha(ASC(Name$, 1)) OR ASC(Name$, 1) = 38 THEN
            IF LEFT$(Name$, 1) = "_" AND MID$(Name$, 2, 1) <> "_" THEN Name$ = "_" + Name$
            EXIT DO
        END IF
        Name$ = MID$(Name$, 2)
        IF LEN(Name$) = 0 THEN Name$ = Control(TargetID).Name: EXIT DO
    LOOP

    FOR i = 1 TO LEN(Name$)
        IF AlphaNumeric(ASC(Name$, i)) THEN
            IF NextIsCapital THEN
                NewName$ = NewName$ + UCASE$(CHR$(ASC(Name$, i)))
                IF ASC(RIGHT$(NewName$, 1)) >= 65 AND ASC(RIGHT$(NewName$, 1)) <= 90 THEN NextIsCapital = False
            ELSE
                NewName$ = NewName$ + CHR$(ASC(Name$, i))
            END IF
        ELSE
            IF ASC(Name$, i) = 32 THEN NextIsCapital = True
        END IF
    NEXT

    IF LEN(NewName$) > 40 THEN NewName$ = LEFT$(NewName$, 40)
    Name$ = NewName$

    i = 1
    DO
        CheckID = __UI_GetID(NewName$)
        IF CheckID = 0 THEN EXIT DO
        IF CheckID = TargetID THEN EXIT DO
        i = i + 1
        c$ = LTRIM$(STR$(i))
        IF LEN(Name$) + LEN(c$) <= 40 THEN
            NewName$ = Name$ + c$
        ELSE
            Name$ = MID$(Name$, 1, 40 - LEN(c$))
            NewName$ = Name$ + c$
        END IF
    LOOP

    IF IS_KEYWORD(NewName$) THEN NewName$ = "__" + NewName$

    AdaptName$ = NewName$
END FUNCTION

'READ_KEYWORDS and IS_KEYWORD come from vWATCH64:
SUB READ_KEYWORDS
    DIM ThisKeyword$, TotalKeywords AS INTEGER

    RESTORE QB64KeywordsDATA
    'Populate QB64KEYWORDS():
    DO
        READ ThisKeyword$
        IF ThisKeyword$ = "**END**" THEN
            EXIT DO
        END IF
        TotalKeywords = TotalKeywords + 1
        REDIM _PRESERVE QB64KEYWORDS(1 TO TotalKeywords) AS STRING
        QB64KEYWORDS(TotalKeywords) = ThisKeyword$
    LOOP

    QB64KeywordsDATA:
    DATA $CHECKING,$CONSOLE,$DYNAMIC,$ELSE,$ELSEIF,$END,$ENDIF,$EXEICON,$IF,$INCLUDE
    DATA $LET,$RESIZE,$SCREENHIDE,$SCREENSHOW,$STATIC,$VERSIONINFO,$VIRTUALKEYBOARD,ABS
    DATA ABSOLUTE,ACCESS,ALIAS,AND,APPEND,AS,ASC,ATN,BASE,BEEP,BINARY,BLOAD,BSAVE,BYVAL
    DATA CALL,CALLS,CASE,IS,CDBL,CDECL,CHAIN,CHDIR,CHR$,CINT,CIRCLE,CLEAR,CLNG,CLOSE
    DATA CLS,COLOR,COM,COMMAND$,COMMON,CONST,COS,CSNG,CSRLIN,CUSTOMTYPE,CVD,CVDMBF,CVI
    DATA CVL,CVS,CVSMBF,DATA,DATE$,DECLARE,DEF,DEFDBL,DEFINT,DEFLNG,DEFSNG,DEFSTR,DIM
    DATA DO,DOUBLE,DRAW,DYNAMIC,ELSE,ELSEIF,END,ENDIF,ENVIRON,ENVIRON$,EOF,EQV,ERASE
    DATA ERDEV,ERDEV$,ERL,ERR,ERROR,EVERYCASE,EXIT,EXP,FIELD,FILEATTR,FILES,FIX,FN,FOR
    DATA FRE,FREE,FREEFILE,FUNCTION,GET,GOSUB,GOTO,HEX$,IF,IMP,INKEY$,INP,INPUT,INPUT$
    DATA INSTR,INT,INTEGER,INTERRUPT,INTERRUPTX,IOCTL,IOCTL$,KEY,KILL,LBOUND,LCASE$,LEFT$
    DATA LEN,LET,LIBRARY,LINE,LIST,LOC,LOCATE,LOCK,LOF,LOG,LONG,LOOP,LPOS,LPRINT,LSET
    DATA LTRIM$,MID$,MKD$,MKDIR,MKDMBF$,MKI$,MKL$,MKS$,MKSMBF$,MOD,NAME,NEXT,NOT,OCT$
    DATA OFF,ON,OPEN,OPTION,OR,OUT,OUTPUT,PAINT,PALETTE,PCOPY,PEEK,PEN,PLAY,PMAP,POINT
    DATA POKE,POS,PRESET,PRINT,PSET,PUT,RANDOM,RANDOMIZE,READ,REDIM,REM,RESET,RESTORE
    DATA RESUME,RETURN,RIGHT$,RMDIR,RND,RSET,RTRIM$,RUN,SADD,SCREEN,SEEK,SEG,SELECT,SETMEM
    DATA SGN,SHARED,SHELL,SIGNAL,SIN,SINGLE,SLEEP,SOUND,SPACE$,SPC,SQR,STATIC,STEP,STICK
    DATA STOP,STR$,STRIG,STRING,STRING$,SUB,SWAP,SYSTEM,TAB,TAN,THEN,TIME$,TIMER,TO,TROFF
    DATA TRON,TYPE,UBOUND,UCASE$,UEVENT,UNLOCK,UNTIL,USING,VAL,VARPTR,VARPTR$,VARSEG
    DATA VIEW,WAIT,WEND,WHILE,WIDTH,WINDOW,WRITE,XOR,_ACOS,_ACOSH,_ALPHA,_ALPHA32,_ARCCOT
    DATA _ARCCSC,_ARCSEC,_ASIN,_ASINH,_ATAN2,_ATANH,_AUTODISPLAY,_AXIS,_BACKGROUNDCOLOR
    DATA _BIT,_BLEND,_BLINK,_BLUE,_BLUE32,_BUTTON,_BUTTONCHANGE,_BYTE,_CEIL,_CLEARCOLOR
    DATA _CLIP,_CLIPBOARD$,_CLIPBOARDIMAGE,_COMMANDCOUNT,_CONNECTED,_CONNECTIONADDRESS$
    DATA _CONSOLE,_CONSOLETITLE,_CONTINUE,_CONTROLCHR,_COPYIMAGE,_COPYPALETTE,_COSH,_COT
    DATA _COTH,_CSC,_CSCH,_CV,_CWD$,_D2G,_D2R,_DEFAULTCOLOR,_DEFINE,_DELAY,_DEPTHBUFFER
    DATA _DESKTOPHEIGHT,_DESKTOPWIDTH,_DEST,_DEVICE$,_DEVICEINPUT,_DEVICES,_DIR$,_DIREXISTS
    DATA _DISPLAY,_DISPLAYORDER,_DONTBLEND,_DONTWAIT,_ERRORLINE,_EXIT,_EXPLICIT,_FILEEXISTS
    DATA _FLOAT,_FONT,_FONTHEIGHT,_FONTWIDTH,_FREEFONT,_FREEIMAGE,_FREETIMER,_FULLSCREEN
    DATA _G2D,_G2R,_GLRENDER,_GREEN,_GREEN32,_HEIGHT,_HIDE,_HYPOT,_ICON,_INCLERRORFILE$
    DATA _INCLERRORLINE,_INTEGER64,_KEYCLEAR,_KEYDOWN,_KEYHIT,_LASTAXIS,_LASTBUTTON,_LASTWHEEL
    DATA _LIMIT,_LOADFONT,_LOADIMAGE,_MAPTRIANGLE,_MAPUNICODE,_MEM,_MEMCOPY,_MEMELEMENT
    DATA _MEMEXISTS,_MEMFILL,_MEMFREE,_MEMGET,_MEMIMAGE,_MEMNEW,_MEMPUT,_MIDDLE,_MK$
    DATA _MOUSEBUTTON,_MOUSEHIDE,_MOUSEINPUT,_MOUSEMOVE,_MOUSEMOVEMENTX,_MOUSEMOVEMENTY
    DATA _MOUSEPIPEOPEN,_MOUSESHOW,_MOUSEWHEEL,_MOUSEX,_MOUSEY,_NEWIMAGE,_OFFSET,_OPENCLIENT
    DATA _OPENCONNECTION,_OPENHOST,_OS$,_PALETTECOLOR,_PI,_PIXELSIZE,_PRESERVE,_PRINTIMAGE
    DATA _PRINTMODE,_PRINTSTRING,_PRINTWIDTH,_PUTIMAGE,_R2D,_R2G,_RED,_RED32,_RESIZE
    DATA _RESIZEHEIGHT,_RESIZEWIDTH,_RGB,_RGB32,_RGBA,_RGBA32,_ROUND,_SCREENCLICK,_SCREENEXISTS
    DATA _SCREENHIDE,_SCREENICON,_SCREENIMAGE,_SCREENMOVE,_SCREENPRINT,_SCREENSHOW,_SCREENX
    DATA _SCREENY,_SEC,_SECH,_SETALPHA,_SHELLHIDE,_SINH,_SNDBAL,_SNDCLOSE,_SNDCOPY,_SNDGETPOS
    DATA _SNDLEN,_SNDLIMIT,_SNDLOOP,_SNDOPEN,_SNDOPENRAW,_SNDPAUSE,_SNDPAUSED,_SNDPLAY
    DATA _SNDPLAYCOPY,_SNDPLAYFILE,_SNDPLAYING,_SNDRATE,_SNDRAW,_SNDRAWDONE,_SNDRAWLEN
    DATA _SNDSETPOS,_SNDSTOP,_SNDVOL,_SOURCE,_STARTDIR$,_STRCMP,_STRICMP,_TANH,_TITLE
    DATA _TITLE$,_UNSIGNED,_WHEEL,_WIDTH,_WINDOWHANDLE,_WINDOWHASFOCUS,_GLACCUM,_GLALPHAFUNC
    DATA _GLARETEXTURESRESIDENT,_GLARRAYELEMENT,_GLBEGIN,_GLBINDTEXTURE,_GLBITMAP,_GLBLENDFUNC
    DATA _GLCALLLIST,_GLCALLLISTS,_GLCLEAR,_GLCLEARACCUM,_GLCLEARCOLOR,_GLCLEARDEPTH
    DATA _GLCLEARINDEX,_GLCLEARSTENCIL,_GLCLIPPLANE,_GLCOLOR3B,_GLCOLOR3BV,_GLCOLOR3D
    DATA _GLCOLOR3DV,_GLCOLOR3F,_GLCOLOR3FV,_GLCOLOR3I,_GLCOLOR3IV,_GLCOLOR3S,_GLCOLOR3SV
    DATA _GLCOLOR3UB,_GLCOLOR3UBV,_GLCOLOR3UI,_GLCOLOR3UIV,_GLCOLOR3US,_GLCOLOR3USV,_GLCOLOR4B
    DATA _GLCOLOR4BV,_GLCOLOR4D,_GLCOLOR4DV,_GLCOLOR4F,_GLCOLOR4FV,_GLCOLOR4I,_GLCOLOR4IV
    DATA _GLCOLOR4S,_GLCOLOR4SV,_GLCOLOR4UB,_GLCOLOR4UBV,_GLCOLOR4UI,_GLCOLOR4UIV,_GLCOLOR4US
    DATA _GLCOLOR4USV,_GLCOLORMASK,_GLCOLORMATERIAL,_GLCOLORPOINTER,_GLCOPYPIXELS,_GLCOPYTEXIMAGE1D
    DATA _GLCOPYTEXIMAGE2D,_GLCOPYTEXSUBIMAGE1D,_GLCOPYTEXSUBIMAGE2D,_GLCULLFACE,_GLDELETELISTS
    DATA _GLDELETETEXTURES,_GLDEPTHFUNC,_GLDEPTHMASK,_GLDEPTHRANGE,_GLDISABLE,_GLDISABLECLIENTSTATE
    DATA _GLDRAWARRAYS,_GLDRAWBUFFER,_GLDRAWELEMENTS,_GLDRAWPIXELS,_GLEDGEFLAG,_GLEDGEFLAGPOINTER
    DATA _GLEDGEFLAGV,_GLENABLE,_GLENABLECLIENTSTATE,_GLEND,_GLENDLIST,_GLEVALCOORD1D
    DATA _GLEVALCOORD1DV,_GLEVALCOORD1F,_GLEVALCOORD1FV,_GLEVALCOORD2D,_GLEVALCOORD2DV
    DATA _GLEVALCOORD2F,_GLEVALCOORD2FV,_GLEVALMESH1,_GLEVALMESH2,_GLEVALPOINT1,_GLEVALPOINT2
    DATA _GLFEEDBACKBUFFER,_GLFINISH,_GLFLUSH,_GLFOGF,_GLFOGFV,_GLFOGI,_GLFOGIV,_GLFRONTFACE
    DATA _GLFRUSTUM,_GLGENLISTS,_GLGENTEXTURES,_GLGETBOOLEANV,_GLGETCLIPPLANE,_GLGETDOUBLEV
    DATA _GLGETERROR,_GLGETFLOATV,_GLGETINTEGERV,_GLGETLIGHTFV,_GLGETLIGHTIV,_GLGETMAPDV
    DATA _GLGETMAPFV,_GLGETMAPIV,_GLGETMATERIALFV,_GLGETMATERIALIV,_GLGETPIXELMAPFV,_GLGETPIXELMAPUIV
    DATA _GLGETPIXELMAPUSV,_GLGETPOINTERV,_GLGETPOLYGONSTIPPLE,_GLGETSTRING,_GLGETTEXENVFV
    DATA _GLGETTEXENVIV,_GLGETTEXGENDV,_GLGETTEXGENFV,_GLGETTEXGENIV,_GLGETTEXIMAGE,_GLGETTEXLEVELPARAMETERFV
    DATA _GLGETTEXLEVELPARAMETERIV,_GLGETTEXPARAMETERFV,_GLGETTEXPARAMETERIV,_GLHINT
    DATA _GLINDEXMASK,_GLINDEXPOINTER,_GLINDEXD,_GLINDEXDV,_GLINDEXF,_GLINDEXFV,_GLINDEXI
    DATA _GLINDEXIV,_GLINDEXS,_GLINDEXSV,_GLINDEXUB,_GLINDEXUBV,_GLINITNAMES,_GLINTERLEAVEDARRAYS
    DATA _GLISENABLED,_GLISLIST,_GLISTEXTURE,_GLLIGHTMODELF,_GLLIGHTMODELFV,_GLLIGHTMODELI
    DATA _GLLIGHTMODELIV,_GLLIGHTF,_GLLIGHTFV,_GLLIGHTI,_GLLIGHTIV,_GLLINESTIPPLE,_GLLINEWIDTH
    DATA _GLLISTBASE,_GLLOADIDENTITY,_GLLOADMATRIXD,_GLLOADMATRIXF,_GLLOADNAME,_GLLOGICOP
    DATA _GLMAP1D,_GLMAP1F,_GLMAP2D,_GLMAP2F,_GLMAPGRID1D,_GLMAPGRID1F,_GLMAPGRID2D,_GLMAPGRID2F
    DATA _GLMATERIALF,_GLMATERIALFV,_GLMATERIALI,_GLMATERIALIV,_GLMATRIXMODE,_GLMULTMATRIXD
    DATA _GLMULTMATRIXF,_GLNEWLIST,_GLNORMAL3B,_GLNORMAL3BV,_GLNORMAL3D,_GLNORMAL3DV
    DATA _GLNORMAL3F,_GLNORMAL3FV,_GLNORMAL3I,_GLNORMAL3IV,_GLNORMAL3S,_GLNORMAL3SV,_GLNORMALPOINTER
    DATA _GLORTHO,_GLPASSTHROUGH,_GLPIXELMAPFV,_GLPIXELMAPUIV,_GLPIXELMAPUSV,_GLPIXELSTOREF
    DATA _GLPIXELSTOREI,_GLPIXELTRANSFERF,_GLPIXELTRANSFERI,_GLPIXELZOOM,_GLPOINTSIZE
    DATA _GLPOLYGONMODE,_GLPOLYGONOFFSET,_GLPOLYGONSTIPPLE,_GLPOPATTRIB,_GLPOPCLIENTATTRIB
    DATA _GLPOPMATRIX,_GLPOPNAME,_GLPRIORITIZETEXTURES,_GLPUSHATTRIB,_GLPUSHCLIENTATTRIB
    DATA _GLPUSHMATRIX,_GLPUSHNAME,_GLRASTERPOS2D,_GLRASTERPOS2DV,_GLRASTERPOS2F,_GLRASTERPOS2FV
    DATA _GLRASTERPOS2I,_GLRASTERPOS2IV,_GLRASTERPOS2S,_GLRASTERPOS2SV,_GLRASTERPOS3D
    DATA _GLRASTERPOS3DV,_GLRASTERPOS3F,_GLRASTERPOS3FV,_GLRASTERPOS3I,_GLRASTERPOS3IV
    DATA _GLRASTERPOS3S,_GLRASTERPOS3SV,_GLRASTERPOS4D,_GLRASTERPOS4DV,_GLRASTERPOS4F
    DATA _GLRASTERPOS4FV,_GLRASTERPOS4I,_GLRASTERPOS4IV,_GLRASTERPOS4S,_GLRASTERPOS4SV
    DATA _GLREADBUFFER,_GLREADPIXELS,_GLRECTD,_GLRECTDV,_GLRECTF,_GLRECTFV,_GLRECTI,_GLRECTIV
    DATA _GLRECTS,_GLRECTSV,_GLRENDERMODE,_GLROTATED,_GLROTATEF,_GLSCALED,_GLSCALEF,_GLSCISSOR
    DATA _GLSELECTBUFFER,_GLSHADEMODEL,_GLSTENCILFUNC,_GLSTENCILMASK,_GLSTENCILOP,_GLTEXCOORD1D
    DATA _GLTEXCOORD1DV,_GLTEXCOORD1F,_GLTEXCOORD1FV,_GLTEXCOORD1I,_GLTEXCOORD1IV,_GLTEXCOORD1S
    DATA _GLTEXCOORD1SV,_GLTEXCOORD2D,_GLTEXCOORD2DV,_GLTEXCOORD2F,_GLTEXCOORD2FV,_GLTEXCOORD2I
    DATA _GLTEXCOORD2IV,_GLTEXCOORD2S,_GLTEXCOORD2SV,_GLTEXCOORD3D,_GLTEXCOORD3DV,_GLTEXCOORD3F
    DATA _GLTEXCOORD3FV,_GLTEXCOORD3I,_GLTEXCOORD3IV,_GLTEXCOORD3S,_GLTEXCOORD3SV,_GLTEXCOORD4D
    DATA _GLTEXCOORD4DV,_GLTEXCOORD4F,_GLTEXCOORD4FV,_GLTEXCOORD4I,_GLTEXCOORD4IV,_GLTEXCOORD4S
    DATA _GLTEXCOORD4SV,_GLTEXCOORDPOINTER,_GLTEXENVF,_GLTEXENVFV,_GLTEXENVI,_GLTEXENVIV
    DATA _GLTEXGEND,_GLTEXGENDV,_GLTEXGENF,_GLTEXGENFV,_GLTEXGENI,_GLTEXGENIV,_GLTEXIMAGE1D
    DATA _GLTEXIMAGE2D,_GLTEXPARAMETERF,_GLTEXPARAMETERFV,_GLTEXPARAMETERI,_GLTEXPARAMETERIV
    DATA _GLTEXSUBIMAGE1D,_GLTEXSUBIMAGE2D,_GLTRANSLATED,_GLTRANSLATEF,_GLVERTEX2D,_GLVERTEX2DV
    DATA _GLVERTEX2F,_GLVERTEX2FV,_GLVERTEX2I,_GLVERTEX2IV,_GLVERTEX2S,_GLVERTEX2SV,_GLVERTEX3D
    DATA _GLVERTEX3DV,_GLVERTEX3F,_GLVERTEX3FV,_GLVERTEX3I,_GLVERTEX3IV,_GLVERTEX3S,_GLVERTEX3SV
    DATA _GLVERTEX4D,_GLVERTEX4DV,_GLVERTEX4F,_GLVERTEX4FV,_GLVERTEX4I,_GLVERTEX4IV,_GLVERTEX4S
    DATA _GLVERTEX4SV,_GLVERTEXPOINTER,_GLVIEWPORT,_ANTICLOCKWISE,_BEHIND,_CLEAR,_FILLBACKGROUND
    DATA _GLUPERSPECTIVE,_HARDWARE,_HARDWARE1,_KEEPBACKGROUND,_NONE,_OFF,_ONLY,_ONLYBACKGROUND
    DATA _ONTOP,_SEAMLESS,_SMOOTH,_SMOOTHSHRUNK,_SMOOTHSTRETCHED,_SOFTWARE,_SQUAREPIXELS
    DATA _STRETCH
    DATA **END**
END SUB

FUNCTION IS_KEYWORD (Text$)
    DIM uText$, i AS INTEGER
    uText$ = UCASE$(RTRIM$(LTRIM$(Text$)))
    FOR i = 1 TO UBOUND(QB64KEYWORDS)
        IF QB64KEYWORDS(i) = uText$ THEN IS_KEYWORD = True: EXIT FUNCTION
    NEXT i
END FUNCTION

SUB SaveUndoImage
    DIM BinFileNum AS INTEGER, b$, a$, i AS INTEGER
    STATIC LastForm$

    BinFileNum = FREEFILE
    OPEN "InForm/UiEditorPreview.frmbin" FOR BINARY AS #BinFileNum
    a$ = SPACE$(LOF(BinFileNum))
    GET #BinFileNum, 1, a$
    CLOSE #BinFileNum

    IF LastForm$ = a$ AND UndoPointer > 1 AND TotalUndoImages > 1 THEN EXIT SUB 'Identical states don't get saved consecutively

    UndoPointer = UndoPointer + 1
    IF UndoPointer < TotalUndoImages THEN TotalUndoImages = UndoPointer
    IF UndoPointer > TotalUndoImages THEN TotalUndoImages = TotalUndoImages + 1

    LastForm$ = a$

    BinFileNum = FREEFILE
    OPEN "InForm/UiEditorUndo.dat" FOR BINARY AS #BinFileNum
    b$ = MKI$(UndoPointer): PUT #BinFileNum, 1, b$
    b$ = MKI$(TotalUndoImages): PUT #BinFileNum, 3, b$

    FOR i = 1 TO UndoPointer - 1
        b$ = SPACE$(4): GET #BinFileNum, , b$
        SEEK #BinFileNum, SEEK(BinFileNum) + CVL(b$)
    NEXT

    b$ = MKL$(LEN(a$))
    PUT #BinFileNum, , b$
    PUT #BinFileNum, , a$
    CLOSE #BinFileNum
END SUB

SUB RestoreUndoImage
    DIM i AS INTEGER, b$, a$, BinFileNum AS INTEGER

    IF UndoPointer < 2 THEN EXIT SUB

    UndoPointer = UndoPointer - 1

    BinFileNum = FREEFILE
    OPEN "InForm/UiEditorUndo.dat" FOR BINARY AS #BinFileNum
    b$ = MKI$(UndoPointer): PUT #BinFileNum, 1, b$
    b$ = MKI$(TotalUndoImages): PUT #BinFileNum, 3, b$

    FOR i = 1 TO UndoPointer - 1
        b$ = SPACE$(4): GET #BinFileNum, , b$
        SEEK #BinFileNum, SEEK(BinFileNum) + CVL(b$)
    NEXT

    b$ = SPACE$(4)
    GET #BinFileNum, , b$
    a$ = SPACE$(CVL(b$))
    GET #BinFileNum, , a$
    CLOSE #BinFileNum

    BinFileNum = FREEFILE
    OPEN "InForm/UiEditorPreview.frmbin" FOR BINARY AS #BinFileNum
    PUT #BinFileNum, 1, a$
    CLOSE #BinFileNum

    LoadPreview
END SUB

SUB RestoreRedoImage
    DIM i AS INTEGER, b$, a$, BinFileNum AS INTEGER

    IF UndoPointer >= TotalUndoImages THEN EXIT SUB

    UndoPointer = UndoPointer + 1

    BinFileNum = FREEFILE
    OPEN "InForm/UiEditorUndo.dat" FOR BINARY AS #BinFileNum
    b$ = MKI$(UndoPointer): PUT #BinFileNum, 1, b$
    b$ = MKI$(TotalUndoImages): PUT #BinFileNum, 3, b$

    FOR i = 1 TO UndoPointer - 1
        b$ = SPACE$(4): GET #BinFileNum, , b$
        SEEK #BinFileNum, SEEK(BinFileNum) + CVL(b$)
    NEXT

    b$ = SPACE$(4)
    GET #BinFileNum, , b$
    a$ = SPACE$(CVL(b$))
    GET #BinFileNum, , a$
    CLOSE #BinFileNum

    BinFileNum = FREEFILE
    OPEN "InForm/UiEditorPreview.frmbin" FOR BINARY AS #BinFileNum
    PUT #BinFileNum, 1, a$
    CLOSE #BinFileNum

    LoadPreview
END SUB

