OPTION _EXPLICIT

$EXEICON:'.\InForm\InForm.ico'
_ICON

DIM SHARED RedTrackID AS LONG, GreenTrackID AS LONG, BlueTrackID AS LONG
DIM SHARED RedTextBoxID AS LONG, GreenTextBoxID AS LONG, BlueTextBoxID AS LONG
DIM SHARED ColorPropertiesListID AS LONG
DIM SHARED UiPreviewPID AS LONG, TotalSelected AS LONG, FirstSelected AS LONG
DIM SHARED PreviewFormID AS LONG, ColorPreviewID AS LONG
DIM SHARED CheckPreviewTimer AS INTEGER, PreviewAttached AS _BYTE

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

REDIM SHARED PreviewCaptions(0) AS STRING
REDIM SHARED PreviewTexts(0) AS STRING
REDIM SHARED PreviewTips(0) AS STRING
REDIM SHARED PreviewFonts(0) AS STRING
REDIM SHARED PreviewControls(0) AS __UI_ControlTYPE

CheckPreviewTimer = _FREETIMER
ON TIMER(CheckPreviewTimer, .003) CheckPreview

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
'$include:'UiEditor.frm'
'$include:'xp.uitheme'

'Event procedures: ---------------------------------------------------------------
SUB __UI_Click (id AS LONG)
    DIM Answer AS _BYTE, Dummy AS LONG, b$, UiEditorFile AS INTEGER

    SELECT EVERYCASE UCASE$(RTRIM$(__UI_Controls(id).Name))
        CASE "VIEWMENUPREVIEWDETACH"
            PreviewAttached = NOT PreviewAttached
            __UI_Controls(__UI_GetID("ViewMenuPreviewDetach")).Value = PreviewAttached
        CASE "ADDBUTTON": Dummy = __UI_Type_Button
        CASE "ADDLABEL": Dummy = __UI_Type_Label
        CASE "ADDTEXTBOX": Dummy = __UI_Type_TextBox
        CASE "ADDCHECKBOX": Dummy = __UI_Type_CheckBox
        CASE "ADDRADIOBUTTON": Dummy = __UI_Type_RadioButton
        CASE "ADDLISTBOX": Dummy = __UI_Type_ListBox
        CASE "ADDDROPDOWNLIST": Dummy = __UI_Type_DropdownList
        CASE "ADDTRACKBAR": Dummy = __UI_Type_TrackBar
        CASE "ADDPROGRESSBAR": Dummy = __UI_Type_ProgressBar
        CASE "ADDPICTUREBOX": Dummy = __UI_Type_PictureBox
        CASE "ADDFRAME": Dummy = __UI_Type_Frame
        CASE "ADDBUTTON", "ADDLABEL", "ADDTEXTBOX", "ADDCHECKBOX", _
             "ADDRADIOBUTTON", "ADDLISTBOX", "ADDDROPDOWNLIST", _
             "ADDTRACKBAR", "ADDPROGRESSBAR", "ADDPICTUREBOX", "ADDFRAME"
            UiEditorFile = FREEFILE
            OPEN "UiEditor.dat" FOR BINARY AS #UiEditorFile
            b$ = MKI$(Dummy)
            PUT #UiEditorFile, OffsetNewControl, b$
            CLOSE #UiEditorFile
        CASE "STRETCH"
            b$ = MKI$(__UI_Controls(__UI_GetID("Stretch")).Value)
            SendData b$, 14
        CASE "HASBORDER"
            b$ = MKI$(__UI_Controls(__UI_GetID("HasBorder")).Value)
            SendData b$, 15
        CASE "SHOWPERCENTAGE"
            b$ = MKI$(__UI_Controls(__UI_GetID("ShowPercentage")).Value)
            SendData b$, 16
        CASE "WORDWRAP"
            b$ = MKI$(__UI_Controls(__UI_GetID("WordWrap")).Value)
            SendData b$, 17
        CASE "CANHAVEFOCUS"
            b$ = MKI$(__UI_Controls(__UI_GetID("CanHaveFocus")).Value)
            SendData b$, 18
        CASE "DISABLED"
            b$ = MKI$(__UI_Controls(__UI_GetID("Disabled")).Value)
            SendData b$, 19
        CASE "HIDDEN"
            b$ = MKI$(__UI_Controls(__UI_GetID("Hidden")).Value)
            SendData b$, 20
        CASE "CENTEREDWINDOW"
            b$ = MKI$(__UI_Controls(__UI_GetID("CenteredWindow")).Value)
            SendData b$, 21
        CASE "VIEWMENUPREVIEW"
            $IF WIN THEN
                SHELL _DONTWAIT "UiEditorPreview.exe"
            $ELSE
                SHELL _DONTWAIT "./UiEditorPreview"
            $END IF
        CASE "LOADEDFONTS"
            DIM Temp$
            FOR Dummy = 1 TO UBOUND(__UI_Controls)
                IF __UI_Controls(Dummy).Type = __UI_Type_Font THEN
                    IF LEN(Temp$) THEN Temp$ = Temp$ + CHR$(10)
                    Temp$ = Temp$ + RTRIM$(__UI_Controls(Dummy).Name) + " (" + __UI_Texts(Dummy) + ")" + STR$(__UI_Controls(Dummy).Max) + "pt, " + __UI_Captions(Dummy)
                END IF
            NEXT
            IF LEN(Temp$) THEN
                Answer = __UI_MessageBox(Temp$, "Loaded fonts", __UI_MsgBox_OkOnly + __UI_MsgBox_Information)
            ELSE
                Answer = __UI_MessageBox("There are no fonts loaded.", "", __UI_MsgBox_OkOnly + __UI_MsgBox_Critical)
            END IF
        CASE "FILEMENULOAD"
            DIM a$, i AS LONG, __UI_EOF AS _BYTE
            DIM NewType AS INTEGER, NewWidth AS INTEGER, NewHeight AS INTEGER
            DIM NewLeft AS INTEGER, NewTop AS INTEGER, NewName AS STRING
            DIM NewParentID AS STRING, FloatValue AS _FLOAT

            CONST LogFileLoad = __UI_False

            IF _FILEEXISTS("form.frmbin") = 0 THEN
                Answer = __UI_MessageBox("File form.frmbin not found.", "", __UI_MsgBox_OkOnly + __UI_MsgBox_Critical)
            ELSE
                OPEN "form.frmbin" FOR BINARY AS #1
                IF LogFileLoad THEN OPEN "ui_log.txt" FOR OUTPUT AS #2
                b$ = SPACE$(7): GET #1, 1, b$
                IF b$ <> "InForm" + CHR$(1) THEN
                    GOTO LoadError
                    EXIT SUB
                END IF
                IF LogFileLoad THEN PRINT #2, "FOUND INFORM+1"
                __UI_AutoRefresh = __UI_False
                FOR i = 1 TO UBOUND(__UI_Controls)
                    __UI_DestroyControl __UI_Controls(i)
                NEXT
                IF LogFileLoad THEN PRINT #2, "DESTROYED CONTROLS"

                b$ = SPACE$(4): GET #1, , b$
                IF LogFileLoad THEN PRINT #2, "READ NEW ARRAYS:" + STR$(CVI(b$))

                REDIM __UI_Captions(1 TO CVL(b$)) AS STRING
                REDIM __UI_TempCaptions(1 TO CVL(b$)) AS STRING
                REDIM __UI_Texts(1 TO CVL(b$)) AS STRING
                REDIM __UI_TempTexts(1 TO CVL(b$)) AS STRING
                REDIM __UI_Tips(1 TO CVL(b$)) AS STRING
                REDIM __UI_Controls(0 TO CVL(b$)) AS __UI_ControlTYPE
                b$ = SPACE$(2): GET #1, , b$
                IF LogFileLoad THEN PRINT #2, "READ NEW CONTROL:" + STR$(CVI(b$))
                IF CVI(b$) <> -1 THEN GOTO LoadError
                DO
                    b$ = SPACE$(2): GET #1, , b$
                    NewType = CVI(b$)
                    IF LogFileLoad THEN PRINT #2, "TYPE:" + STR$(CVI(b$))
                    b$ = SPACE$(2): GET #1, , b$
                    b$ = SPACE$(CVI(b$)): GET #1, , b$
                    NewName = b$
                    IF LogFileLoad THEN PRINT #2, "NAME:" + NewName
                    b$ = SPACE$(2): GET #1, , b$
                    NewWidth = CVI(b$)
                    IF LogFileLoad THEN PRINT #2, "WIDTH:" + STR$(CVI(b$))
                    b$ = SPACE$(2): GET #1, , b$
                    NewHeight = CVI(b$)
                    IF LogFileLoad THEN PRINT #2, "HEIGHT:" + STR$(CVI(b$))
                    b$ = SPACE$(2): GET #1, , b$
                    NewLeft = CVI(b$)
                    IF LogFileLoad THEN PRINT #2, "LEFT:" + STR$(CVI(b$))
                    b$ = SPACE$(2): GET #1, , b$
                    NewTop = CVI(b$)
                    IF LogFileLoad THEN PRINT #2, "TOP:" + STR$(CVI(b$))
                    b$ = SPACE$(2): GET #1, , b$
                    NewParentID = SPACE$(CVI(b$)): GET #1, , NewParentID
                    IF LogFileLoad THEN PRINT #2, "PARENT:" + NewParentID

                    IF NewType = __UI_Type_Form THEN
                        DIM OldScreen&
                        OldScreen& = _DEST
                        SCREEN _NEWIMAGE(NewWidth, NewHeight, 32)
                        _FREEIMAGE OldScreen&
                    END IF

                    Dummy = __UI_NewControl(NewType, NewName, NewWidth, NewHeight, NewLeft, NewTop, __UI_GetID(NewParentID))

                    DO 'read properties
                        b$ = SPACE$(2): GET #1, , b$
                        IF LogFileLoad THEN PRINT #2, "PROPERTY:" + STR$(CVI(b$)) + " :";
                        SELECT CASE CVI(b$)
                            CASE -2 'Caption
                                b$ = SPACE$(4): GET #1, , b$
                                b$ = SPACE$(CVL(b$))
                                GET #1, , b$
                                __UI_Captions(Dummy) = b$
                                IF LogFileLoad THEN PRINT #2, "CAPTION:" + __UI_Captions(Dummy)
                            CASE -3 'Text
                                b$ = SPACE$(4): GET #1, , b$
                                b$ = SPACE$(CVL(b$))
                                GET #1, , b$
                                __UI_Texts(Dummy) = b$
                                IF __UI_Controls(Dummy).Type = __UI_Type_PictureBox OR __UI_Controls(Dummy).Type = __UI_Type_Button THEN
                                    __UI_LoadImage __UI_Controls(Dummy), __UI_Texts(Dummy)
                                END IF
                                IF LogFileLoad THEN PRINT #2, "TEXT:" + __UI_Texts(Dummy)
                            CASE -4 'Stretch
                                __UI_Controls(Dummy).Stretch = __UI_True
                                IF LogFileLoad THEN PRINT #2, "STRETCH"
                            CASE -5 'Font
                                IF LogFileLoad THEN PRINT #2, "FONT:";
                                DIM FontSetup$, FindSep AS INTEGER
                                DIM NewFontName AS STRING, NewFontFile AS STRING
                                DIM NewFontSize AS INTEGER, NewFontAttributes AS STRING
                                b$ = SPACE$(2): GET #1, , b$
                                FontSetup$ = SPACE$(CVI(b$)): GET #1, , FontSetup$
                                IF LogFileLoad THEN PRINT #2, FontSetup$

                                FindSep = INSTR(FontSetup$, "\")
                                NewFontName = LEFT$(FontSetup$, FindSep - 1): FontSetup$ = MID$(FontSetup$, FindSep + 1)

                                FindSep = INSTR(FontSetup$, "\")
                                NewFontFile = LEFT$(FontSetup$, FindSep - 1): FontSetup$ = MID$(FontSetup$, FindSep + 1)

                                FindSep = INSTR(FontSetup$, "\")
                                NewFontSize = VAL(LEFT$(FontSetup$, FindSep - 1)): FontSetup$ = MID$(FontSetup$, FindSep + 1)

                                NewFontAttributes = FontSetup$

                                __UI_Controls(Dummy).Font = __UI_Font(NewFontName, NewFontFile, NewFontSize, NewFontAttributes)
                            CASE -6 'ForeColor
                                b$ = SPACE$(4): GET #1, , b$
                                __UI_Controls(Dummy).ForeColor = _CV(_UNSIGNED LONG, b$)
                                IF LogFileLoad THEN PRINT #2, "FORECOLOR"
                            CASE -7 'BackColor
                                b$ = SPACE$(4): GET #1, , b$
                                __UI_Controls(Dummy).BackColor = _CV(_UNSIGNED LONG, b$)
                                IF LogFileLoad THEN PRINT #2, "BACKCOLOR"
                            CASE -8 'SelectedForeColor
                                b$ = SPACE$(4): GET #1, , b$
                                __UI_Controls(Dummy).SelectedForeColor = _CV(_UNSIGNED LONG, b$)
                                IF LogFileLoad THEN PRINT #2, "SELECTEDFORECOLOR"
                            CASE -9 'SelectedBackColor
                                b$ = SPACE$(4): GET #1, , b$
                                __UI_Controls(Dummy).SelectedBackColor = _CV(_UNSIGNED LONG, b$)
                                IF LogFileLoad THEN PRINT #2, "SELECTEDBACKCOLOR"
                            CASE -10 'BorderColor
                                b$ = SPACE$(4): GET #1, , b$
                                __UI_Controls(Dummy).BorderColor = _CV(_UNSIGNED LONG, b$)
                                IF LogFileLoad THEN PRINT #2, "BORDERCOLOR"
                            CASE -11
                                __UI_Controls(Dummy).BackStyle = __UI_Transparent
                                IF LogFileLoad THEN PRINT #2, "BACKSTYLE:TRANSPARENT"
                            CASE -12
                                __UI_Controls(Dummy).HasBorder = __UI_True
                                IF LogFileLoad THEN PRINT #2, "HASBORDER"
                            CASE -13
                                b$ = SPACE$(1): GET #1, , b$
                                __UI_Controls(Dummy).Align = _CV(_BYTE, b$)
                                IF LogFileLoad THEN PRINT #2, "ALIGN="; __UI_Controls(Dummy).Align
                            CASE -14
                                b$ = SPACE$(LEN(FloatValue)): GET #1, , b$
                                __UI_Controls(Dummy).Value = _CV(_FLOAT, b$)
                                IF LogFileLoad THEN PRINT #2, "VALUE="; __UI_Controls(Dummy).Value
                            CASE -15
                                b$ = SPACE$(LEN(FloatValue)): GET #1, , b$
                                __UI_Controls(Dummy).Min = _CV(_FLOAT, b$)
                                IF LogFileLoad THEN PRINT #2, "MIN="; __UI_Controls(Dummy).Min
                            CASE -16
                                b$ = SPACE$(LEN(FloatValue)): GET #1, , b$
                                __UI_Controls(Dummy).Max = _CV(_FLOAT, b$)
                                IF LogFileLoad THEN PRINT #2, "MAX="; __UI_Controls(Dummy).Max
                            CASE -17
                                b$ = SPACE$(2): GET #1, , b$
                                __UI_Controls(Dummy).HotKey = CVI(b$)
                                IF LogFileLoad THEN PRINT #2, "HOTKEY="; __UI_Controls(Dummy).HotKey; "("; CHR$(__UI_Controls(Dummy).HotKey); ")"
                            CASE -18
                                b$ = SPACE$(2): GET #1, , b$
                                __UI_Controls(Dummy).HotKeyOffset = CVI(b$)
                                IF LogFileLoad THEN PRINT #2, "HOTKEYOFFSET="; __UI_Controls(Dummy).HotKeyOffset
                            CASE -19
                                __UI_Controls(Dummy).ShowPercentage = __UI_True
                                IF LogFileLoad THEN PRINT #2, "SHOWPERCENTAGE"
                            CASE -20
                                __UI_Controls(Dummy).CanHaveFocus = __UI_True
                                IF LogFileLoad THEN PRINT #2, "CANHAVEFOCUS"
                            CASE -21
                                __UI_Controls(Dummy).Disabled = __UI_True
                                IF LogFileLoad THEN PRINT #2, "DISABLED"
                            CASE -22
                                __UI_Controls(Dummy).Hidden = __UI_True
                                IF LogFileLoad THEN PRINT #2, "HIDDEN"
                            CASE -23
                                __UI_Controls(Dummy).CenteredWindow = __UI_True
                                IF LogFileLoad THEN PRINT #2, "CENTEREDWINDOW"
                            CASE -24 'Tips
                                b$ = SPACE$(4): GET #1, , b$
                                b$ = SPACE$(CVL(b$))
                                GET #1, , b$
                                __UI_Tips(Dummy) = b$
                                IF LogFileLoad THEN PRINT #2, "TIP: "; __UI_Tips(Dummy)
                            CASE -25
                                DIM ContextMenuName AS STRING
                                b$ = SPACE$(2): GET #1, , b$
                                ContextMenuName = SPACE$(CVI(b$)): GET #1, , ContextMenuName
                                __UI_Controls(Dummy).ContextMenuID = __UI_GetID(ContextMenuName)
                                IF LogFileLoad THEN PRINT #2, "CONTEXTMENU:"; ContextMenuName
                            CASE -26
                                b$ = SPACE$(LEN(FloatValue)): GET #1, , b$
                                __UI_Controls(Dummy).Interval = _CV(_FLOAT, b$)
                                IF LogFileLoad THEN PRINT #2, "INTERVAL="; __UI_Controls(Dummy).Interval
                            CASE -27
                                __UI_Controls(Dummy).WordWrap = __UI_True
                                IF LogFileLoad THEN PRINT #2, "WORDWRAP"
                            CASE -28
                                b$ = SPACE$(4): GET #1, , b$
                                __UI_Controls(Dummy).TransparentColor = _CV(_UNSIGNED LONG, b$)
                                IF LogFileLoad THEN PRINT #2, "TRANSPARENTCOLOR"
                                __UI_ClearColor __UI_Controls(Dummy).HelperCanvas, __UI_Controls(Dummy).TransparentColor, -1
                            CASE -29
                                __UI_Controls(Dummy).CanResize = __UI_True
                                IF LogFileLoad THEN PRINT #2, "CANRESIZE"
                            CASE -1 'new control
                                IF LogFileLoad THEN PRINT #2, "READ NEW CONTROL:-1"
                                EXIT DO
                            CASE -1024
                                IF LogFileLoad THEN PRINT #2, "READ END OF FILE:-1024"
                                __UI_EOF = __UI_True
                                EXIT DO
                            CASE ELSE
                                IF LogFileLoad THEN PRINT #2, "UNKNOWN DATA="; CVI(b$)
                                EXIT DO
                        END SELECT
                    LOOP
                LOOP UNTIL __UI_EOF
                CLOSE #1
                IF LogFileLoad THEN CLOSE #2
                __UI_AutoRefresh = __UI_True
                EXIT SUB

                LoadError:
                __UI_AutoRefresh = __UI_True
                Answer = __UI_MessageBox("File form.frmbin is not valid.", "", __UI_MsgBox_OkOnly + __UI_MsgBox_Critical)
                CLOSE #1
            END IF
        CASE "FILEMENUSAVE"
            OPEN "form.frm" FOR OUTPUT AS #1
            IF _FILEEXISTS("form.frmbin") THEN KILL "form.frmbin"
            OPEN "form.frmbin" FOR BINARY AS #2
            PRINT #1, "'InForm - GUI system for QB64"
            PRINT #1, "'Fellippe Heitor, 2016 - fellippe@qb64.org - @fellippeheitor"
            PRINT #1, "'Beta version 1"
            PRINT #1, "SUB __UI_LoadForm"
            PRINT #1, "    DIM __UI_NewID AS LONG"
            PRINT #1,
            b$ = "InForm" + CHR$(1)
            PUT #2, 1, b$
            b$ = MKL$(UBOUND(__UI_Controls))
            PUT #2, , b$
            FOR i = 1 TO UBOUND(__UI_Controls)
                IF __UI_Controls(i).ID > 0 AND __UI_Controls(i).Type <> __UI_Type_MenuPanel AND __UI_Controls(i).Type <> __UI_Type_Font AND LEN(RTRIM$(__UI_Controls(i).Name)) > 0 THEN
                    a$ = "    __UI_NewID = __UI_NewControl("
                    SELECT CASE __UI_Controls(i).Type
                        CASE __UI_Type_Form: a$ = a$ + "__UI_Type_Form, "
                        CASE __UI_Type_Frame: a$ = a$ + "__UI_Type_Frame, "
                        CASE __UI_Type_Button: a$ = a$ + "__UI_Type_Button, "
                        CASE __UI_Type_Label: a$ = a$ + "__UI_Type_Label, "
                        CASE __UI_Type_CheckBox: a$ = a$ + "__UI_Type_CheckBox, "
                        CASE __UI_Type_RadioButton: a$ = a$ + "__UI_Type_RadioButton, "
                        CASE __UI_Type_TextBox: a$ = a$ + "__UI_Type_TextBox, "
                        CASE __UI_Type_ProgressBar: a$ = a$ + "__UI_Type_ProgressBar, "
                        CASE __UI_Type_ListBox: a$ = a$ + "__UI_Type_ListBox, "
                        CASE __UI_Type_DropdownList: a$ = a$ + "__UI_Type_DropdownList, "
                        CASE __UI_Type_MenuBar: a$ = a$ + "__UI_Type_MenuBar, "
                        CASE __UI_Type_MenuItem: a$ = a$ + "__UI_Type_MenuItem, "
                        CASE __UI_Type_PictureBox: a$ = a$ + "__UI_Type_PictureBox, "
                        CASE __UI_Type_TrackBar: a$ = a$ + "__UI_Type_TrackBar, "
                        CASE __UI_Type_ContextMenu: a$ = a$ + "__UI_Type_ContextMenu, "
                    END SELECT
                    a$ = a$ + CHR$(34) + RTRIM$(__UI_Controls(i).Name) + CHR$(34) + ","
                    a$ = a$ + STR$(__UI_Controls(i).Width) + ","
                    a$ = a$ + STR$(__UI_Controls(i).Height) + ","
                    a$ = a$ + STR$(__UI_Controls(i).Left) + ","
                    a$ = a$ + STR$(__UI_Controls(i).Top) + ","
                    IF __UI_Controls(i).ParentID > 0 THEN
                        a$ = a$ + " __UI_GetID(" + CHR$(34) + RTRIM$(__UI_Controls(__UI_Controls(i).ParentID).Name) + CHR$(34) + "))"
                    ELSE
                        a$ = a$ + " 0)"
                    END IF
                    PRINT #1, a$
                    b$ = MKI$(-1) + MKI$(__UI_Controls(i).Type) '-1 indicates a new control
                    b$ = b$ + MKI$(LEN(RTRIM$(__UI_Controls(i).Name)))
                    b$ = b$ + RTRIM$(__UI_Controls(i).Name)
                    b$ = b$ + MKI$(__UI_Controls(i).Width) + MKI$(__UI_Controls(i).Height) + MKI$(__UI_Controls(i).Left) + MKI$(__UI_Controls(i).Top) + MKI$(LEN(RTRIM$(__UI_Controls(__UI_Controls(i).ParentID).Name))) + RTRIM$(__UI_Controls(__UI_Controls(i).ParentID).Name)
                    PUT #2, , b$

                    IF LEN(__UI_Captions(i)) > 0 THEN
                        a$ = "    __UI_SetCaption " + CHR$(34) + RTRIM$(__UI_Controls(i).Name) + CHR$(34) + ", " + __UI_SpecialCharsToCHR$(__UI_Captions(i))
                        b$ = MKI$(-2) + MKL$(LEN(__UI_Captions(i))) '-2 indicates a caption
                        PUT #2, , b$
                        PUT #2, , __UI_Captions(i)
                        PRINT #1, a$
                    END IF

                    IF LEN(__UI_Tips(i)) > 0 THEN
                        a$ = "    __UI_SetTip " + CHR$(34) + RTRIM$(__UI_Controls(i).Name) + CHR$(34) + ", " + __UI_SpecialCharsToCHR$(__UI_Tips(i))
                        b$ = MKI$(-24) + MKL$(LEN(__UI_Tips(i))) '-24 indicates a tip
                        PUT #2, , b$
                        PUT #2, , __UI_Tips(i)
                        PRINT #1, a$
                    END IF

                    IF LEN(__UI_Texts(i)) > 0 THEN
                        SELECT CASE __UI_Controls(i).Type
                            CASE __UI_Type_ListBox, __UI_Type_DropdownList
                                DIM TempCaption$, TempText$, FindLF&, ThisItem%, ThisItemTop%
                                DIM LastVisibleItem AS INTEGER

                                TempText$ = __UI_Texts(i)
                                ThisItem% = 0
                                DO WHILE LEN(TempText$)
                                    ThisItem% = ThisItem% + 1
                                    FindLF& = INSTR(TempText$, CHR$(13))
                                    IF FindLF& THEN
                                        TempCaption$ = LEFT$(TempText$, FindLF& - 1)
                                        TempText$ = MID$(TempText$, FindLF& + 1)
                                    ELSE
                                        TempCaption$ = TempText$
                                        TempText$ = ""
                                    END IF
                                    a$ = "    __UI_AddListBoxItem " + CHR$(34) + RTRIM$(__UI_Controls(i).Name) + CHR$(34) + ", " + CHR$(34) + TempCaption$ + CHR$(34)
                                    PRINT #1, a$
                                LOOP
                            CASE __UI_Type_PictureBox, __UI_Type_Button
                                a$ = "    __UI_LoadImage __UI_Controls(__UI_NewID), " + CHR$(34) + __UI_Texts(i) + CHR$(34)
                                PRINT #1, a$
                            CASE ELSE
                                a$ = "    __UI_SetText " + CHR$(34) + RTRIM$(__UI_Controls(i).Name) + CHR$(34) + ", " + __UI_SpecialCharsToCHR$(__UI_Captions(i))
                                PRINT #1, a$
                        END SELECT
                        b$ = MKI$(-3) + MKL$(LEN(__UI_Texts(i))) '-3 indicates a text
                        PUT #2, , b$
                        PUT #2, , __UI_Texts(i)
                    END IF
                    IF __UI_Controls(i).TransparentColor > 0 THEN
                        PRINT #1, "    __UI_ClearColor __UI_Controls(__UI_NewID).HelperCanvas, " + LTRIM$(STR$(__UI_Controls(i).TransparentColor)) + ", -1"
                        b$ = MKI$(-28) + _MK$(_UNSIGNED LONG, __UI_Controls(i).TransparentColor)
                        PUT #2, , b$
                    END IF
                    IF __UI_Controls(i).Stretch THEN
                        PRINT #1, "    __UI_Controls(__UI_NewID).Stretch = __UI_True"
                        b$ = MKI$(-4)
                        PUT #2, , b$
                    END IF
                    'Inheritable properties won't be saved if they are the same as the parent's
                    IF __UI_Controls(i).Type = __UI_Type_Form THEN
                        IF __UI_Controls(i).Font = 8 OR __UI_Controls(i).Font = 16 THEN
                            'Internal fonts
                            SaveInternalFont:
                            FontSetup$ = "__UI_Font(" + CHR$(34) + "VGA Emulated" + CHR$(34) + ", " + CHR$(34) + CHR$(34) + "," + STR$(__UI_Controls(__UI_GetFontID(__UI_Controls(i).Font)).Max) + ", " + CHR$(34) + CHR$(34) + ")"
                            PRINT #1, "    __UI_Controls(__UI_NewID).Font = " + FontSetup$
                            FontSetup$ = "VGA Emulated\\" + LTRIM$(STR$(__UI_Controls(__UI_GetFontID(__UI_Controls(i).Font)).Max)) + "\"
                            b$ = MKI$(-5) + MKI$(LEN(FontSetup$)) + FontSetup$
                            PUT #2, , b$
                        ELSE
                            SaveExternalFont:
                            FontSetup$ = "__UI_Font(" + CHR$(34) + RTRIM$(__UI_Controls(__UI_GetFontID(__UI_Controls(i).Font)).Name) + CHR$(34) + ", " + CHR$(34) + __UI_Texts(__UI_GetFontID(__UI_Controls(i).Font)) + CHR$(34) + "," + STR$(__UI_Controls(__UI_GetFontID(__UI_Controls(i).Font)).Max) + ", " + CHR$(34) + __UI_Captions(__UI_GetFontID(__UI_Controls(i).Font)) + CHR$(34) + ")"
                            PRINT #1, "    __UI_Controls(__UI_NewID).Font = " + FontSetup$
                            FontSetup$ = RTRIM$(__UI_Controls(__UI_GetFontID(__UI_Controls(i).Font)).Name) + "\" + __UI_Texts(__UI_GetFontID(__UI_Controls(i).Font)) + "\" + LTRIM$(STR$(__UI_Controls(__UI_GetFontID(__UI_Controls(i).Font)).Max)) + "\" + __UI_Captions(__UI_GetFontID(__UI_Controls(i).Font))
                            b$ = MKI$(-5) + MKI$(LEN(FontSetup$)) + FontSetup$
                            PUT #2, , b$
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
                        PRINT #1, "    __UI_Controls(__UI_NewID).ForeColor = _RGB32(" + LTRIM$(STR$(_RED32(__UI_Controls(i).ForeColor))) + ", " + LTRIM$(STR$(_GREEN32(__UI_Controls(i).ForeColor))) + ", " + LTRIM$(STR$(_BLUE32(__UI_Controls(i).ForeColor))) + ")"
                        b$ = MKI$(-6) + _MK$(_UNSIGNED LONG, __UI_Controls(i).ForeColor)
                        PUT #2, , b$
                    END IF
                    IF __UI_Controls(i).BackColor <> __UI_DefaultColor(__UI_Controls(i).Type, 2) THEN
                        PRINT #1, "    __UI_Controls(__UI_NewID).BackColor = _RGB32(" + LTRIM$(STR$(_RED32(__UI_Controls(i).BackColor))) + ", " + LTRIM$(STR$(_GREEN32(__UI_Controls(i).BackColor))) + ", " + LTRIM$(STR$(_BLUE32(__UI_Controls(i).BackColor))) + ")"
                        b$ = MKI$(-7) + _MK$(_UNSIGNED LONG, __UI_Controls(i).BackColor)
                        PUT #2, , b$
                    END IF
                    IF __UI_Controls(i).SelectedForeColor <> __UI_DefaultColor(__UI_Controls(i).Type, 3) THEN
                        PRINT #1, "    __UI_Controls(__UI_NewID).SelectedForeColor = _RGB32(" + LTRIM$(STR$(_RED32(__UI_Controls(i).SelectedForeColor))) + ", " + LTRIM$(STR$(_GREEN32(__UI_Controls(i).SelectedForeColor))) + ", " + LTRIM$(STR$(_BLUE32(__UI_Controls(i).SelectedForeColor))) + ")"
                        b$ = MKI$(-8) + _MK$(_UNSIGNED LONG, __UI_Controls(i).SelectedForeColor)
                        PUT #2, , b$
                    END IF
                    IF __UI_Controls(i).SelectedBackColor <> __UI_DefaultColor(__UI_Controls(i).Type, 4) THEN
                        PRINT #1, "    __UI_Controls(__UI_NewID).SelectedBackColor = _RGB32(" + LTRIM$(STR$(_RED32(__UI_Controls(i).SelectedBackColor))) + ", " + LTRIM$(STR$(_GREEN32(__UI_Controls(i).SelectedBackColor))) + ", " + LTRIM$(STR$(_BLUE32(__UI_Controls(i).SelectedBackColor))) + ")"
                        b$ = MKI$(-9) + _MK$(_UNSIGNED LONG, __UI_Controls(i).SelectedBackColor)
                        PUT #2, , b$
                    END IF
                    IF __UI_Controls(i).BorderColor <> __UI_DefaultColor(__UI_Controls(i).Type, 5) THEN
                        PRINT #1, "    __UI_Controls(__UI_NewID).BorderColor = _RGB32(" + LTRIM$(STR$(_RED32(__UI_Controls(i).BorderColor))) + ", " + LTRIM$(STR$(_GREEN32(__UI_Controls(i).BorderColor))) + ", " + LTRIM$(STR$(_BLUE32(__UI_Controls(i).BorderColor))) + ")"
                        b$ = MKI$(-10) + _MK$(_UNSIGNED LONG, __UI_Controls(i).BorderColor)
                        PUT #2, , b$
                    END IF
                    IF __UI_Controls(i).BackStyle = __UI_Transparent THEN
                        PRINT #1, "    __UI_Controls(__UI_NewID).BackStyle = __UI_Transparent"
                        b$ = MKI$(-11): PUT #2, , b$
                    END IF
                    IF __UI_Controls(i).HasBorder THEN
                        PRINT #1, "    __UI_Controls(__UI_NewID).HasBorder = __UI_True"
                        b$ = MKI$(-12): PUT #2, , b$
                    END IF
                    IF __UI_Controls(i).Align = __UI_Center THEN
                        PRINT #1, "    __UI_Controls(__UI_NewID).Align = __UI_Center"
                        b$ = MKI$(-13) + _MK$(_BYTE, __UI_Controls(i).Align): PUT #2, , b$
                    ELSEIF __UI_Controls(i).Align = __UI_Right THEN
                        PRINT #1, "    __UI_Controls(__UI_NewID).Align = __UI_Right"
                        b$ = MKI$(-13) + _MK$(_BYTE, __UI_Controls(i).Align): PUT #2, , b$
                    END IF
                    IF __UI_Controls(i).Value <> 0 THEN
                        PRINT #1, "    __UI_Controls(__UI_NewID).Value = " + LTRIM$(STR$(__UI_Controls(i).Value))
                        b$ = MKI$(-14) + _MK$(_FLOAT, __UI_Controls(i).Value): PUT #2, , b$
                    END IF
                    IF __UI_Controls(i).Min <> 0 THEN
                        PRINT #1, "    __UI_Controls(__UI_NewID).Min = " + LTRIM$(STR$(__UI_Controls(i).Min))
                        b$ = MKI$(-15) + _MK$(_FLOAT, __UI_Controls(i).Min): PUT #2, , b$
                    END IF
                    IF __UI_Controls(i).Max <> 0 THEN
                        PRINT #1, "    __UI_Controls(__UI_NewID).Max = " + LTRIM$(STR$(__UI_Controls(i).Max))
                        b$ = MKI$(-16) + _MK$(_FLOAT, __UI_Controls(i).Max): PUT #2, , b$
                    END IF
                    IF __UI_Controls(i).HotKey <> 0 THEN
                        PRINT #1, "    __UI_Controls(__UI_NewID).HotKey = " + LTRIM$(STR$(__UI_Controls(i).HotKey))
                        b$ = MKI$(-17) + MKI$(__UI_Controls(i).HotKey): PUT #2, , b$
                    END IF
                    IF __UI_Controls(i).HotKeyOffset <> 0 THEN
                        PRINT #1, "    __UI_Controls(__UI_NewID).HotKeyOffset = " + LTRIM$(STR$(__UI_Controls(i).HotKeyOffset))
                        b$ = MKI$(-18) + MKI$(__UI_Controls(i).HotKeyOffset): PUT #2, , b$
                    END IF
                    IF __UI_Controls(i).ShowPercentage THEN
                        PRINT #1, "    __UI_Controls(__UI_NewID).ShowPercentage = __UI_True"
                        b$ = MKI$(-19): PUT #2, , b$
                    END IF
                    IF __UI_Controls(i).CanHaveFocus THEN
                        PRINT #1, "    __UI_Controls(__UI_NewID).CanHaveFocus = __UI_True"
                        b$ = MKI$(-20): PUT #2, , b$
                    END IF
                    IF __UI_Controls(i).Disabled THEN
                        PRINT #1, "    __UI_Controls(__UI_NewID).Disabled = __UI_True"
                        b$ = MKI$(-21): PUT #2, , b$
                    END IF
                    IF __UI_Controls(i).Hidden THEN
                        PRINT #1, "    __UI_Controls(__UI_NewID).Hidden = __UI_True"
                        b$ = MKI$(-22): PUT #2, , b$
                    END IF
                    IF __UI_Controls(i).CenteredWindow THEN
                        PRINT #1, "    __UI_Controls(__UI_NewID).CenteredWindow = __UI_True"
                        b$ = MKI$(-23): PUT #2, , b$
                    END IF
                    IF __UI_Controls(i).ContextMenuID THEN
                        PRINT #1, "    __UI_Controls(__UI_NewID).ContextMenuID = __UI_GetID(" + CHR$(34) + RTRIM$(__UI_Controls(__UI_Controls(i).ContextMenuID).Name) + CHR$(34) + ")"
                        b$ = MKI$(-25) + MKI$(LEN(RTRIM$(__UI_Controls(__UI_Controls(i).ContextMenuID).Name))) + RTRIM$(__UI_Controls(__UI_Controls(i).ContextMenuID).Name): PUT #2, , b$
                    END IF
                    IF __UI_Controls(i).Interval THEN
                        PRINT #1, "    __UI_Controls(__UI_NewID).Interval = " + LTRIM$(STR$(__UI_Controls(i).Interval))
                        b$ = MKI$(-26) + _MK$(_FLOAT, __UI_Controls(i).Interval): PUT #2, , b$
                    END IF
                    IF __UI_Controls(i).WordWrap THEN
                        PRINT #1, "    __UI_Controls(__UI_NewID).WordWrap = __UI_True"
                        b$ = MKI$(-27): PUT #2, , b$
                    END IF
                    IF __UI_Controls(i).CanResize AND __UI_Controls(i).Type = __UI_Type_Form THEN
                        PRINT #1, "    __UI_Controls(__UI_NewID).CanResize = __UI_True"
                        b$ = MKI$(-29): PUT #2, , b$
                    END IF
                    PRINT #1,
                END IF
            NEXT
            b$ = MKI$(-1024): PUT #2, , b$ 'end of file
            PRINT #1, "END SUB"
            CLOSE #1, #2
            OPEN "program.bas" FOR OUTPUT AS #1
            PRINT #1, "'$INCLUDE:'InForm.ui'"
            PRINT #1, "'$INCLUDE:'form.frm'"
            PRINT #1, "'$INCLUDE:'xp.uitheme'"
            PRINT #1,
            PRINT #1, "'Event procedures: ---------------------------------------------------------------"
            FOR i = 1 TO 12
                SELECT EVERYCASE i
                    CASE 1: PRINT #1, "SUB __UI_OnLoad"
                    CASE 2: PRINT #1, "SUB __UI_BeforeUpdateDisplay"
                    CASE 3: PRINT #1, "SUB __UI_BeforeUnload"
                    CASE 4: PRINT #1, "SUB __UI_Click (id AS LONG)"
                    CASE 5: PRINT #1, "SUB __UI_MouseEnter (id AS LONG)"
                    CASE 6: PRINT #1, "SUB __UI_MouseLeave (id AS LONG)"
                    CASE 7: PRINT #1, "SUB __UI_FocusIn (id AS LONG)"
                    CASE 8: PRINT #1, "SUB __UI_FocusOut (id AS LONG)"
                    CASE 9: PRINT #1, "SUB __UI_MouseDown (id AS LONG)"
                    CASE 10: PRINT #1, "SUB __UI_MouseUp (id AS LONG)"
                    CASE 11: PRINT #1, "SUB __UI_KeyPress (id AS LONG)"
                    CASE 12: PRINT #1, "SUB __UI_ValueChanged (id AS LONG)"

                    CASE 1 TO 3
                        PRINT #1,

                    CASE 4 TO 6, 9, 10 'All controls except for Menu panels, and internal context menus
                        PRINT #1, "    SELECT CASE UCASE$(RTRIM$(__UI_Controls(id).Name))"
                        FOR Dummy = 1 TO UBOUND(__UI_Controls)
                            IF __UI_Controls(Dummy).ID AND __UI_Controls(Dummy).Type <> __UI_Type_Font AND __UI_Controls(Dummy).Type <> __UI_Type_ContextMenu AND RTRIM$(__UI_Controls(Dummy).Name) <> "__UI_TextFieldMenu" AND __UI_Controls(Dummy).ParentID <> __UI_GetID("__UI_TextFieldMenu") THEN
                                PRINT #1, "        CASE " + CHR$(34) + UCASE$(RTRIM$(__UI_Controls(Dummy).Name)) + CHR$(34)
                                PRINT #1,
                            END IF
                        NEXT
                        PRINT #1, "    END SELECT"

                    CASE 7, 8, 11 'Controls that can have focus only
                        PRINT #1, "    SELECT CASE UCASE$(RTRIM$(__UI_Controls(id).Name))"
                        FOR Dummy = 1 TO UBOUND(__UI_Controls)
                            IF __UI_Controls(Dummy).ID AND __UI_Controls(Dummy).CanHaveFocus THEN
                                PRINT #1, "        CASE " + CHR$(34) + UCASE$(RTRIM$(__UI_Controls(Dummy).Name)) + CHR$(34)
                                PRINT #1,
                            END IF
                        NEXT
                        PRINT #1, "    END SELECT"

                    CASE 12 'Dropdown list, List box and Track bar
                        PRINT #1, "    SELECT CASE UCASE$(RTRIM$(__UI_Controls(id).Name))"
                        FOR Dummy = 1 TO UBOUND(__UI_Controls)
                            IF __UI_Controls(Dummy).ID AND (__UI_Controls(Dummy).Type = __UI_Type_ListBox OR __UI_Controls(Dummy).Type = __UI_Type_DropdownList OR __UI_Controls(Dummy).Type = __UI_Type_TrackBar) THEN
                                PRINT #1, "        CASE " + CHR$(34) + UCASE$(RTRIM$(__UI_Controls(Dummy).Name)) + CHR$(34)
                                PRINT #1,
                            END IF
                        NEXT
                        PRINT #1, "    END SELECT"
                END SELECT
                PRINT #1, "END SUB"
                PRINT #1,
            NEXT
            CLOSE #1
        CASE "HELPMENUABOUT"
            Answer = __UI_MessageBox("UI beta" + CHR$(10) + "by Fellippe Heitor" + CHR$(10) + CHR$(10) + "Twitter: @fellippeheitor" + CHR$(10) + "e-mail: fellippe@qb64.org", "About", __UI_MsgBox_OkOnly + __UI_MsgBox_Information)
        CASE "HELPMENUHELP"
            Answer = __UI_MessageBox("This will soon become a GUI editor, which will allow an event-driven approach to programs written in QB64.", "What's all this?", __UI_MsgBox_OkOnly + __UI_MsgBox_Information)
        CASE "FILEMENUEXIT"
            SYSTEM
    END SELECT
END SUB

SUB __UI_MouseEnter (id AS LONG)
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
    DIM b$
    SELECT CASE UCASE$(RTRIM$(__UI_Controls(id).Name))
        CASE "RED", "GREEN", "BLUE"
            'Compose a new color and send it to the preview
            DIM NewColor AS _UNSIGNED LONG
            NewColor = _RGB32(__UI_Controls(RedTrackID).Value, __UI_Controls(GreenTrackID).Value, __UI_Controls(BlueTrackID).Value)
            b$ = _MK$(_UNSIGNED LONG, NewColor)
            SendData b$, __UI_Controls(ColorPropertiesListID).Value + 22
    END SELECT
END SUB

SUB __UI_BeforeUpdateDisplay
    DIM b$, PreviewChanged AS _BYTE, SelectedProperty AS INTEGER, UiEditorFile AS INTEGER
    STATIC MidRead AS _BYTE

    IF NOT MidRead THEN
        MidRead = __UI_True
        UiEditorFile = FREEFILE
        OPEN "UiEditor.dat" FOR BINARY AS #UiEditorFile

        LoadPreview

        $IF WIN THEN
            IF PreviewAttached THEN
                b$ = MKI$(_SCREENX)
                PUT #UiEditorFile, OffsetWindowLeft, b$

                b$ = MKI$(_SCREENY)
                PUT #UiEditorFile, OffsetWindowTop, b$
            ELSE
                b$ = MKI$(-1)
                PUT #UiEditorFile, OffsetWindowLeft, b$
                PUT #UiEditorFile, OffsetWindowTop, b$
            END IF
        $END IF

        'Controls in the editor lose focus when the preview is manipulated
        b$ = SPACE$(2): GET #UiEditorFile, OffsetNewDataFromPreview, b$
        IF CVI(b$) = -1 THEN
            __UI_Focus = 0
            b$ = MKI$(0): PUT #UiEditorFile, OffsetNewDataFromPreview, b$
        END IF

        b$ = SPACE$(4): GET #UiEditorFile, OffsetTotalControlsSelected, b$
        TotalSelected = CVL(b$)
        b$ = SPACE$(4): GET #UiEditorFile, OffsetFormID, b$
        PreviewFormID = CVL(b$)
        b$ = SPACE$(4): GET #UiEditorFile, OffsetFirstSelectedID, b$
        FirstSelected = CVL(b$)

        SelectedProperty = __UI_Controls(__UI_GetID("PropertiesList")).Value

        IF TotalSelected = 0 THEN
            __UI_SetCaption "PropertiesFrame", "Control properties: " + RTRIM$(PreviewControls(PreviewFormID).Name)
            FirstSelected = PreviewFormID
        ELSEIF TotalSelected = 1 THEN
            IF FirstSelected > 0 AND FirstSelected <= UBOUND(PreviewControls) THEN
                __UI_SetCaption "PropertiesFrame", "Control properties: " + RTRIM$(PreviewControls(FirstSelected).Name)
            END IF
        ELSE
            __UI_SetCaption "PropertiesFrame", "Control properties: (multiple selection)"
        END IF

        IF FirstSelected = 0 THEN FirstSelected = PreviewFormID

        IF __UI_Focus <> __UI_GetID("PropertyValue") THEN
            SELECT CASE SelectedProperty
                CASE 1 'Name
                    __UI_Texts(__UI_GetID("PropertyValue")) = RTRIM$(PreviewControls(FirstSelected).Name)
                CASE 2 'Caption
                    __UI_Texts(__UI_GetID("PropertyValue")) = PreviewCaptions(FirstSelected)
                CASE 3 'Text
                    __UI_Texts(__UI_GetID("PropertyValue")) = PreviewTexts(FirstSelected)
                CASE 4 'Top
                    __UI_Texts(__UI_GetID("PropertyValue")) = LTRIM$(STR$(PreviewControls(FirstSelected).Top))
                CASE 5 'Left
                    __UI_Texts(__UI_GetID("PropertyValue")) = LTRIM$(STR$(PreviewControls(FirstSelected).Left))
                CASE 6 'Width
                    __UI_Texts(__UI_GetID("PropertyValue")) = LTRIM$(STR$(PreviewControls(FirstSelected).Width))
                CASE 7 'Height
                    __UI_Texts(__UI_GetID("PropertyValue")) = LTRIM$(STR$(PreviewControls(FirstSelected).Height))
                CASE 8 'Font
                    __UI_Texts(__UI_GetID("PropertyValue")) = PreviewFonts(FirstSelected)
                CASE 9 'BackStyle
                    __UI_Texts(__UI_GetID("PropertyValue")) = LTRIM$(STR$(PreviewControls(FirstSelected).BackStyle))
                CASE 10 'Value
                    __UI_Texts(__UI_GetID("PropertyValue")) = LTRIM$(STR$(PreviewControls(FirstSelected).Value))
                CASE 11 'Min
                    __UI_Texts(__UI_GetID("PropertyValue")) = LTRIM$(STR$(PreviewControls(FirstSelected).Min))
                CASE 12 'Max
                    __UI_Texts(__UI_GetID("PropertyValue")) = LTRIM$(STR$(PreviewControls(FirstSelected).Max))
                CASE 13 'Interval
                    __UI_Texts(__UI_GetID("PropertyValue")) = LTRIM$(STR$(PreviewControls(FirstSelected).Interval))
            END SELECT
        END IF

        'Update checkboxes:
        __UI_Controls(__UI_GetID("Stretch")).Value = PreviewControls(FirstSelected).Stretch
        __UI_Controls(__UI_GetID("HasBorder")).Value = PreviewControls(FirstSelected).HasBorder
        __UI_Controls(__UI_GetID("ShowPercentage")).Value = PreviewControls(FirstSelected).ShowPercentage
        __UI_Controls(__UI_GetID("WordWrap")).Value = PreviewControls(FirstSelected).WordWrap
        __UI_Controls(__UI_GetID("CanHaveFocus")).Value = PreviewControls(FirstSelected).CanHaveFocus
        __UI_Controls(__UI_GetID("Disabled")).Value = PreviewControls(FirstSelected).Disabled
        __UI_Controls(__UI_GetID("Hidden")).Value = PreviewControls(FirstSelected).Hidden
        __UI_Controls(__UI_GetID("CenteredWindow")).Value = PreviewControls(FirstSelected).CenteredWindow
        __UI_Controls(__UI_GetID("AlignOptions")).Value = PreviewControls(FirstSelected).Align + 1

        'Update the color mixer
        DIM ThisColor AS _UNSIGNED LONG, ThisBackColor AS _UNSIGNED LONG

        SELECT EVERYCASE __UI_Controls(ColorPropertiesListID).Value
            CASE 1, 2 'ForeColor, BackColor
                ThisColor = PreviewControls(FirstSelected).ForeColor
                IF ThisColor = 0 THEN ThisColor = PreviewControls(PreviewFormID).ForeColor
                IF ThisColor = 0 THEN ThisColor = __UI_DefaultColor(__UI_Type_Form, 1)
                ThisBackColor = PreviewControls(FirstSelected).BackColor
                IF ThisBackColor = 0 THEN ThisBackColor = PreviewControls(PreviewFormID).BackColor
                IF ThisBackColor = 0 THEN ThisBackColor = __UI_DefaultColor(__UI_Type_Form, 2)
            CASE 3, 4 'SelectedForeColor, SelectedBackColor
                ThisColor = PreviewControls(FirstSelected).SelectedForeColor
                IF ThisColor = 0 THEN ThisColor = PreviewControls(PreviewFormID).SelectedForeColor
                IF ThisColor = 0 THEN ThisColor = __UI_DefaultColor(__UI_Type_Form, 3)
                ThisBackColor = PreviewControls(FirstSelected).SelectedBackColor
                IF ThisBackColor = 0 THEN ThisBackColor = PreviewControls(PreviewFormID).SelectedBackColor
                IF ThisBackColor = 0 THEN ThisBackColor = __UI_DefaultColor(__UI_Type_Form, 4)
            CASE 5 'BorderColor
                ThisColor = PreviewControls(FirstSelected).BorderColor
                IF ThisColor = 0 THEN ThisColor = PreviewControls(PreviewFormID).BorderColor
                IF ThisColor = 0 THEN ThisColor = __UI_DefaultColor(__UI_Type_Form, 5)
                ThisBackColor = PreviewControls(FirstSelected).BackColor
                IF ThisBackColor = 0 THEN ThisBackColor = PreviewControls(PreviewFormID).BackColor
                IF ThisBackColor = 0 THEN ThisBackColor = __UI_DefaultColor(__UI_Type_Form, 2)
            CASE 1, 3, 5
                IF __UI_Focus <> RedTrackID AND __UI_Focus <> RedTextBoxID THEN
                    __UI_Controls(RedTrackID).Value = _RED32(ThisColor)
                    __UI_Texts(RedTextBoxID) = LTRIM$(STR$(__UI_Controls(RedTrackID).Value))
                END IF
                IF __UI_Focus <> GreenTrackID AND __UI_Focus <> GreenTextBoxID THEN
                    __UI_Controls(GreenTrackID).Value = _GREEN32(ThisColor)
                    __UI_Texts(GreenTextBoxID) = LTRIM$(STR$(__UI_Controls(GreenTrackID).Value))
                END IF
                IF __UI_Focus <> BlueTrackID AND __UI_Focus <> BlueTextBoxID THEN
                    __UI_Controls(BlueTrackID).Value = _BLUE32(ThisColor)
                    __UI_Texts(BlueTextBoxID) = LTRIM$(STR$(__UI_Controls(BlueTrackID).Value))
                END IF
            CASE 2, 4
                IF __UI_Focus <> RedTrackID AND __UI_Focus <> RedTextBoxID THEN
                    __UI_Controls(RedTrackID).Value = _RED32(ThisBackColor)
                    __UI_Texts(RedTextBoxID) = LTRIM$(STR$(__UI_Controls(RedTrackID).Value))
                END IF
                IF __UI_Focus <> GreenTrackID AND __UI_Focus <> GreenTextBoxID THEN
                    __UI_Controls(GreenTrackID).Value = _GREEN32(ThisBackColor)
                    __UI_Texts(GreenTextBoxID) = LTRIM$(STR$(__UI_Controls(GreenTrackID).Value))
                END IF
                IF __UI_Focus <> BlueTrackID AND __UI_Focus <> BlueTextBoxID THEN
                    __UI_Controls(BlueTrackID).Value = _BLUE32(ThisBackColor)
                    __UI_Texts(BlueTextBoxID) = LTRIM$(STR$(__UI_Controls(BlueTrackID).Value))
                END IF
        END SELECT

        IF __UI_Controls(__UI_GetID("ColorPreview")).HelperCanvas = 0 THEN
            __UI_Controls(__UI_GetID("ColorPreview")).HelperCanvas = _NEWIMAGE(__UI_Controls(__UI_GetID("ColorPreview")).Width, __UI_Controls(__UI_GetID("ColorPreview")).Height, 32)
        END IF
        STATIC PrevPreviewForeColor AS _UNSIGNED LONG, PrevPreviewBackColor AS _UNSIGNED LONG
        IF PrevPreviewForeColor <> ThisColor OR PrevPreviewBackColor <> ThisBackColor THEN
            PrevPreviewForeColor = ThisColor
            PrevPreviewBackColor = ThisBackColor
            UpdateColorPreview __UI_Controls(ColorPropertiesListID).Value, ThisColor, ThisBackColor
        END IF

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
    DIM i AS LONG, b$, UiEditorFile AS INTEGER

    'Load toolbox images:
    DIM CommControls AS LONG
    CommControls = LoadEditorImage("commoncontrols.bmp")
    __UI_ClearColor CommControls, 0, 0

    __UI_Controls(__UI_GetID("AddButton")).HelperCanvas = _NEWIMAGE(16, 16, 32)
    i = i + 1: _PUTIMAGE (0, 0), CommControls, __UI_Controls(__UI_GetID("AddButton")).HelperCanvas, (0, i * 16 - 16)-STEP(15, 15)
    __UI_Controls(__UI_GetID("AddLabel")).HelperCanvas = _NEWIMAGE(16, 16, 32)
    i = i + 1: _PUTIMAGE (0, 0), CommControls, __UI_Controls(__UI_GetID("AddLabel")).HelperCanvas, (0, i * 16 - 16)-STEP(15, 15)
    __UI_Controls(__UI_GetID("AddTextBox")).HelperCanvas = _NEWIMAGE(16, 16, 32)
    i = i + 1: _PUTIMAGE (0, 0), CommControls, __UI_Controls(__UI_GetID("AddTextBox")).HelperCanvas, (0, i * 16 - 16)-STEP(15, 15)
    __UI_Controls(__UI_GetID("AddCheckBox")).HelperCanvas = _NEWIMAGE(16, 16, 32)
    i = i + 1: _PUTIMAGE (0, 0), CommControls, __UI_Controls(__UI_GetID("AddCheckBox")).HelperCanvas, (0, i * 16 - 16)-STEP(15, 15)
    __UI_Controls(__UI_GetID("AddRadioButton")).HelperCanvas = _NEWIMAGE(16, 16, 32)
    i = i + 1: _PUTIMAGE (0, 0), CommControls, __UI_Controls(__UI_GetID("AddRadioButton")).HelperCanvas, (0, i * 16 - 16)-STEP(15, 15)
    __UI_Controls(__UI_GetID("AddListBox")).HelperCanvas = _NEWIMAGE(16, 16, 32)
    i = i + 1: _PUTIMAGE (0, 0), CommControls, __UI_Controls(__UI_GetID("AddListBox")).HelperCanvas, (0, i * 16 - 16)-STEP(15, 15)
    __UI_Controls(__UI_GetID("AddDropdownList")).HelperCanvas = _NEWIMAGE(16, 16, 32)
    i = i + 1: _PUTIMAGE (0, 0), CommControls, __UI_Controls(__UI_GetID("AddDropdownList")).HelperCanvas, (0, i * 16 - 16)-STEP(15, 15)
    __UI_Controls(__UI_GetID("AddTrackBar")).HelperCanvas = _NEWIMAGE(16, 16, 32)
    i = i + 1: _PUTIMAGE (0, 0), CommControls, __UI_Controls(__UI_GetID("AddTrackBar")).HelperCanvas, (0, i * 16 - 16)-STEP(15, 15)
    __UI_Controls(__UI_GetID("AddProgressBar")).HelperCanvas = _NEWIMAGE(16, 16, 32)
    i = i + 1: _PUTIMAGE (0, 0), CommControls, __UI_Controls(__UI_GetID("AddProgressBar")).HelperCanvas, (0, i * 16 - 16)-STEP(15, 15)
    __UI_Controls(__UI_GetID("AddPictureBox")).HelperCanvas = _NEWIMAGE(16, 16, 32)
    i = i + 1: _PUTIMAGE (0, 0), CommControls, __UI_Controls(__UI_GetID("AddPictureBox")).HelperCanvas, (0, i * 16 - 16)-STEP(15, 15)
    __UI_Controls(__UI_GetID("AddFrame")).HelperCanvas = _NEWIMAGE(16, 16, 32)
    i = i + 1: _PUTIMAGE (0, 0), CommControls, __UI_Controls(__UI_GetID("AddFrame")).HelperCanvas, (0, i * 16 - 16)-STEP(15, 15)

    _FREEIMAGE CommControls

    __UI_ForceRedraw = __UI_True

    'Read controls' IDs to avoid repeated calls to __UI_GetID later on
    RedTrackID = __UI_GetID("Red"): RedTextBoxID = __UI_GetID("RedValue")
    GreenTrackID = __UI_GetID("Green"): GreenTextBoxID = __UI_GetID("GreenValue")
    BlueTrackID = __UI_GetID("Blue"): BlueTextBoxID = __UI_GetID("BlueValue")
    ColorPropertiesListID = __UI_GetID("ColorPropertiesList")
    ColorPreviewID = __UI_GetID("ColorPreview")

    PreviewAttached = __UI_True

    IF _FILEEXISTS("UiEditorPreview.frmbin") THEN KILL "UiEditorPreview.frmbin"
    IF _FILEEXISTS("UiEditor.dat") THEN KILL "UiEditor.dat"

    $IF WIN THEN
        IF _FILEEXISTS("UiEditorPreview.exe") = 0 THEN
            IF _FILEEXISTS("UiEditorPreview.bas") = 0 THEN
                GOTO UiEditorPreviewNotFound
            ELSE
                b$ = "Compiling Preview component..."
                GOSUB ShowMessage
                SHELL "qb64.exe -x UiEditorPreview.bas"
                IF _FILEEXISTS("UiEditorPreview.exe") = 0 THEN GOTO UiEditorPreviewNotFound
            END IF
        END IF
        b$ = "Launching..."
        GOSUB ShowMessage
        SHELL _DONTWAIT "UiEditorPreview.exe"
    $ELSE
        IF _FILEEXISTS("UiEditorPreview") = 0 THEN
        IF _FILEEXISTS("UiEditorPreview.bas") = 0 THEN
        GOTO UiEditorPreviewNotFound
        ELSE
        b$ = "Compiling Preview component..."
        GOSUB ShowMessage
        SHELL "./qb64 -x UiEditorPreview.bas"
        IF _FILEEXISTS("UiEditorPreview") = 0 THEN GOTO UiEditorPreviewNotFound
        END IF
        END IF
        b$ = "Launching..."
        GOSUB ShowMessage
        SHELL _DONTWAIT "./UiEditorPreview"
    $END IF

    UiEditorFile = FREEFILE
    OPEN "UiEditor.dat" FOR BINARY AS #UiEditorFile
    b$ = MKL$(__UI_GetPID)
    PUT #UiEditorFile, OffsetEditorPID, b$
    CLOSE #UiEditorFile

    TIMER(CheckPreviewTimer) ON

    EXIT SUB
    UiEditorPreviewNotFound:
    i = __UI_MessageBox("UiEditorPreview component not found or failed to load.", "UiEditor", __UI_MsgBox_OkOnly + __UI_MsgBox_Critical)
    SYSTEM

    ShowMessage:
    _DEST 0
    CLS , __UI_DefaultColor(__UI_Type_Form, 2)
    COLOR __UI_DefaultColor(__UI_Type_Form, 1), _RGBA32(0, 0, 0, 0)
    _PRINTSTRING (_WIDTH \ 2 - _PRINTWIDTH(b$) \ 2, _HEIGHT \ 2 - _FONTHEIGHT \ 2), b$
    _DISPLAY
    RETURN
END SUB

SUB __UI_KeyPress (id AS LONG)
    SELECT CASE UCASE$(RTRIM$(__UI_Controls(id).Name))
        CASE "PROPERTYVALUE"
            'Send the preview the new property value
            DIM FloatValue AS _FLOAT, b$, TempValue AS LONG, i AS LONG
            DIM PropertyValueID AS LONG

            PropertyValueID = __UI_GetID("PropertyValue")
            TempValue = __UI_Controls(__UI_GetID("PropertiesList")).Value
            SELECT CASE TempValue
                CASE 1, 2, 3 'Name, caption, text
                    b$ = MKL$(LEN(__UI_Texts(PropertyValueID))) + __UI_Texts(PropertyValueID)
                CASE 4, 5, 6, 7 'Top, left, width, height
                    b$ = MKI$(VAL(__UI_Texts(PropertyValueID)))
                CASE 8 'Font
                CASE 9 'BackStyle
                CASE 10, 11, 12, 13 'Value, min, max, interval
                    b$ = _MK$(_FLOAT, VAL(__UI_Texts(PropertyValueID)))
            END SELECT
            SendData b$, TempValue
    END SELECT
END SUB

SUB __UI_ValueChanged (id AS LONG)
    SELECT EVERYCASE UCASE$(RTRIM$(__UI_Controls(id).Name))
        CASE "ALIGNOPTIONS"
            DIM b$
            b$ = MKI$(__UI_Controls(__UI_GetID("AlignOptions")).Value - 1)
            SendData b$, 22
        CASE "RED"
            __UI_Texts(RedTextBoxID) = LTRIM$(STR$(__UI_Controls(RedTrackID).Value))
        CASE "GREEN"
            __UI_Texts(GreenTextBoxID) = LTRIM$(STR$(__UI_Controls(GreenTrackID).Value))
        CASE "BLUE"
            __UI_Texts(BlueTextBoxID) = LTRIM$(STR$(__UI_Controls(BlueTrackID).Value))
        CASE "RED", "GREEN", "BLUE"
            'Compose a new color and send it to the preview
            DIM NewColor AS _UNSIGNED LONG
            NewColor = _RGB32(__UI_Controls(RedTrackID).Value, __UI_Controls(GreenTrackID).Value, __UI_Controls(BlueTrackID).Value)
            QuickColorPreview NewColor
    END SELECT
END SUB

SUB __UI_EndDrag
END SUB

SUB __UI_EndResize
END SUB

FUNCTION EditorImageData$ (FileName$)
    DIM A$

    SELECT CASE LCASE$(FileName$)
        CASE "commoncontrols.bmp"
            A$ = MKI$(16) + MKI$(176)
            A$ = A$ + "f3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_emfjo<ZE:"
            A$ = A$ + "o?G>0loN21`ocU30o_W@0loLi0`ok940o?G>0loN21`ocU30o_W@0loN:1aoFKL[oK?0fo_cmFjoD^F>ok]c6ooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooo_O^goCiHal_emfjo<ZE:ok]e6ooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooiFKlo4:E8o?G>0loooooooooooooooooooooooooooooooooooooo0000oooooooooooo"
            A$ = A$ + "oooooooooooooooogOomo_W@0loN21`oooooooooooooooooooooooooooooooooooooo3000loooooooooooooooooooooogOom"
            A$ = A$ + "oOoooooLi0`ocU30ooooooooooooooooo3000l?000`ooooooooooo?000`o0000o3000loooooooooooOomgook_Oook940o_W@"
            A$ = A$ + "0lomooooooooooooooooooooooooo3000loooooo0000oooooooooooo0000oooooook_Ooo_Oomo?G>0loLi0`ogooooOomgooo"
            A$ = A$ + "oooo0000o3000l?000`oooooo3000loooooogOomo3000lomgOooWonkoOnk_ooN21`ok940oonmgooooooo0000oOooooomgOoo"
            A$ = A$ + "0000oOomgo?000`ogOomoOoooo?000`ogooooOni_ooi_onocU30o?G>0lomgOoo_OomoOomgo?000`o0000o3000lomgOoo0000"
            A$ = A$ + "o3000l?000`ogOomoonmgooiWonoNOnio_W@0loN21`o_onkoOomgookgOoogOomoonmgoomgOoo_OomoOomgookgOoogOomoonm"
            A$ = A$ + "goomgOooNOniokmi_ooLi0`okY44ok\c6ook_ono_Oomoonk_ookgOoo_onkoonmgook_ono_Oomoonk_ookgOoo_onkoonmgoO_"
            A$ = A$ + "mFko4:56oK]a]n?SS5comFK[ok\eNo_cFkmo6K]gok\eNo_cFkmo>K]goK\eNo_cFkmo>K]gok\eNoO_mFko<>F<oKM_]n_m0Hoo"
            A$ = A$ + "FKL[oCXDQloN21`ocU30o_W@0loLi0`ok940o?G>0loN21`ocU30o_W@0loLi0`o4:56okL_Un_m0Hoof3PmoK?0fo_m0Hoof3Pm"
            A$ = A$ + "oK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0"
            A$ = A$ + "fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m"
            A$ = A$ + "0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK\a6ooHB9eof3PmoK?0fo_m0Hoo"
            A$ = A$ + "f3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fooNk]go0000oK\a6o_m0Hoof3PmoK?0fo_m0Hoof3Pm"
            A$ = A$ + "oK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_a6Klo0000o3000lO8HPaof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0"
            A$ = A$ + "fo_m0Hoof3PmoK?0fo_m0Hoo4>gJo_gJSm?000`o0000ok\c>o_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m"
            A$ = A$ + "0Hoo6K\ao3128l_a6Klo:9D>o3000lO>aTbof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3Pmoc9S4n_F:9do"
            A$ = A$ + "f3Pmok\c>o?000`o8000oK\a6o_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_@i4co6K\aoK?0fo_m0HooQP16"
            A$ = A$ + "o3000loHJ9eof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_c>klo0000o[T@ilO>a4co2UC<o3148l?000`o0000ok\c"
            A$ = A$ + ">o_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hooc=VFo?VDBm_m0Hoof3PmoK?0fo_m0Hoo0000o3000loHJ9eof3PmoK?0fo_m"
            A$ = A$ + "0Hoof3PmoK?0fo_m0Hoo6K\aoS14@l_a6Klof3PmoK?0fo_m0Hoof3Pmoc8Qkm?000`oQP16oK\a6o_m0Hoof3PmoK?0fo_m0Hoo"
            A$ = A$ + "6K\ao7C<Yl?28P`oQ426oK\a6o_m0Hoof3PmoK?0fo?000`o0000o3000l?6@0aof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3Pm"
            A$ = A$ + "oK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0"
            A$ = A$ + "fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m"
            A$ = A$ + "0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoo"
            A$ = A$ + "f3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3Pm"
            A$ = A$ + "oK?0foO_UBhomb9QoKLY4nO_UBhomF:Qog;W4n_aUBhomF:QogKY4nO_LBho6G:QogKY4nO_UBhomb9QoKLY4n_m0Hoomb9Qoooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooO_L^gof3PmoKLY4noooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooomF:QoK?0foO_L^gooooooooooooooooooooooooooooooooo"
            A$ = A$ + "0000oooooooooooooooooooooo?000`oooooog;W4n_m0HoomF:Qooooooooooooooooooooooooooooooooo3000loooooooooo"
            A$ = A$ + "oooooooooooo0000oooooo_aUBhof3Pmog;W4nooooooooooo3000l?000`ooooooooooo?000`o0000o3000looooooooooo300"
            A$ = A$ + "0loooooombiNoK?0fo_aUBhoooooo3000looooooooooo3000loooooo0000oooooooooooo0000oooooo?000`oooooogKY4n_m"
            A$ = A$ + "0HoombiNoooooooooooo0000o3000l?000`oooooo3000looooooooooo3000loooooo0000ooooooO_LBhof3PmogKY4noooooo"
            A$ = A$ + "0000oooooooooooo0000oooooo?000`ooooooooooo?000`oooooo3000loooooo6G:QoK?0foO_LBhooooooooooo?000`o0000"
            A$ = A$ + "o3000loooooo0000o3000l?000`ooooooooooo?000`oooooog;Wkm_m0Hoo6G:Qoooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooO_UBhof3Pmog;Wkmoooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooomb9QoK?0foO_UBhomb9QoKLY4nO_UBhomF:Qog;W4n_aUBhomF:QogKY4nO_LBho6G:QogKY4nO_UBho"
            A$ = A$ + "mb9QoKLY4n_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3Pm"
            A$ = A$ + "oK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0"
            A$ = A$ + "fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoCXDHl?QJ5bo4:56oCXDQl?Q"
            A$ = A$ + "BQao4ZE8oCXDHl?QB5bo4:56oCXFQl?QBQao4:E8oCXDHl_m0Hoof3PmoK?0fo?QB5boNOnioOniWo_gWOnoWonkoOniWooi_ono"
            A$ = A$ + "Wonkoonmgook_onogOomoOomgo?QB5bof3PmoK?0fo_m0Hoo4:56oOnk_o_gWOnoWonkoOnk_ook_ono_onkoOomgookgOoogOom"
            A$ = A$ + "oOomgooooooo4:56oK?0fo_m0Hoof3PmoCXDQl_gWOnoWonkoOniWooi_onoWonkoonmgook_onogOomo7BYQloooooogOomoCXD"
            A$ = A$ + "Ql_m0Hoof3PmoK?0fo?QBQaoWonkoOnk_ook_ono_onkoOomgookgOoogOomo7BYQlO:]Vbooooooooooo?QBQaof3PmoK?0fo_m"
            A$ = A$ + "0Hoo4:E8oOniWooi_onoQDJ8oonmgook_onogOomo7BYQlO8U6boQDJ8oooooooooooo4:E8oK?0fo_m0Hoof3PmoCXDHlok_ono"
            A$ = A$ + "_onkoWB[YlO8U6bogOomo7BYQlO:]VboQDJ8oooooooooooooooooCXDHl_m0Hoof3PmoK?0fo?QB5boWonkoonmgoO8U6boQDJ8"
            A$ = A$ + "o7BYQlO8U6boQDJ8oooooooooooooooooooooo?QB5bof3PmoK?0fo_m0Hoo4:56oOomgookgOoogOomo7BYQlO:]VboQDJ8oooo"
            A$ = A$ + "oooooooooooooooooooooooo4:56oK?0fo_m0Hoof3PmoCXDQlok_onogOomoOomgoooooooQDJ8oooooooooooooooooooooooo"
            A$ = A$ + "oooooooooCXDQl_m0Hoof3PmoK?0fo?QBQaogOomoOomgooooooooooooooooooooooooooooooooooooooooooooooooo?QBQao"
            A$ = A$ + "f3PmoK?0fo_m0Hoo4:E8oOomgooooooogOomoooooooooooooooooooooooooooooooooooooooooooo4:E8oK?0fo_m0Hoof3Pm"
            A$ = A$ + "oCXDHl?QJ5bo4:56oCXDQl?QBQao4ZE8oCXDHl?QB5bo4:56oCXFQl?QBQao4:E8oCXDHl_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0"
            A$ = A$ + "fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m"
            A$ = A$ + "0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoo"
            A$ = A$ + "f3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_cmFjo]bhHoCXFQl?UkYeo>gKYoK?0fo_m0Hoof3Pm"
            A$ = A$ + "oK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK]cen?QB5boeBiLoKL_]noiWOno>gK[og:U[m?QB5bof3PmoK?0fo_m0Hoof3PmoK?0"
            A$ = A$ + "fo_m0Hoof3Pmok]cmnOY4Zeo>KL]oOnk_ook_ono_onkoOomgookgOoomF:QoG:QJm_g>gkof3PmoK?0fo_m0Hoof3PmoK?0fo?Q"
            A$ = A$ + "B5bo>gK[oOniWooi_onoWonkoonmgook_onogOomoOomgo_e>gko4:E8oK?0fo_m0Hoof3PmoK?0fo_cmFjo]BiLoOnk_ook_ono"
            A$ = A$ + "Woniogjien_B6;eoUjMYoonm_ooooooooooooG;Ucm_cmFjof3PmoK?0fo_m0HooD^WFoKL_]noi_onoWonkogji]n_DF;eo2I\B"
            A$ = A$ + "oWB[Yl?WFciogOomoooooo_e>gko<>WBoK?0fo_m0Hoof3PmoCXFQloiWOno_onkoOomgo_B6;eo2i\BoWC_ilO:]VboQ`I:oooo"
            A$ = A$ + "oooooooooooooCXFQl_m0Hoof3PmoK?0foOYD^go>gK[oonmgook_onoUJMYoWB[YlO8UVbo@@94ocYcLnoooooooooook]cmn?S"
            A$ = A$ + "[Ydof3PmoK?0fo_m0Hoo>gKYog:UcmokgOoogOomoonm_o?WFGjoY`I:ocYcLnokgOooooooooooooO]D>go>gKYoK?0fo_m0Hoo"
            A$ = A$ + "f3PmoK?0fo?QB5boFKL]oOomgooooooogOomoooooooooooooooooooooo_gFKlo4:E8oK?0fo_m0Hoof3PmoK?0fo_m0HooNkL_"
            A$ = A$ + "oG:QJm_g>gkooooooooooooooooooooooooooo_gFKlo]BhHok]cmn_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_g>gko4:E8oG;U"
            A$ = A$ + "cm_e>gkooooook]cmnO]D>go4:E8ok]cmn_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_cmFjo]B9QoCXFQlO["
            A$ = A$ + "D^go>gKYoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoo"
            A$ = A$ + "f3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3Pm"
            A$ = A$ + "oK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0"
            A$ = A$ + "foO_UBhomb9QoKLY4nO_UBhomF:Qog;W4n_aUBhomF:QogKY4nO_LBho6G:QogKY4nO_UBhomb9QoKLY4n_m0Hoomb9Qoooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooom>GkookL]oO_aen_cUBiogkL]oo_cenO_L^gof3PmoKLY4noooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooookL]oO_cen_cUBio0000okL[Dnom>GkomF:QoK?0foO_L^gooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oO_aenom>Gko0000oo_cen?000`ogkL]og;W4n_m0HoomF:Qoooooo?000`o0000o3000loooooooooooooooooo>GkogkL]oo_c"
            A$ = A$ + "enom>GkookL]oO_cen_aUBhof3Pmog;W4noooooooooooooooooooooooooooooooooooooogkL]oo_cenom6GkogkL]oO_cenoo"
            A$ = A$ + ">GkombiNoK?0fo_aUBhoooooo3000l?000`o0000o3000l?000`oooooooom_ooo_OnooOokoookWooogonoooniogKY4n_m0Hoo"
            A$ = A$ + "mbiNooooooooooooooooooooooooooooooooooooooom6GkogkL]oO_cenoo>GkogKL]oO_cenO_LBhof3PmogKY4noooooo0000"
            A$ = A$ + "o3000l?000`o0000oooooooooooookL]oO_cenoo>GkogkL]oo_cenom>Gko6G:QoK?0foO_LBhooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooO_cenoo>Gko0000oO_cen?000`ookL]og;Wkm_m0Hoo6G:Qoooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + ">GkogkL]okLYDn?000`o>g:UoO_cenO_UBhof3Pmog;WkmoooooooooooooooooooooooooooooooooooooogKL]oO_cenom>Gko"
            A$ = A$ + ">G:UoO_aenom>Gkomb9QoK?0foO_UBhomb9QoKLY4nO_UBhomF:Qog;W4n_aUBhomF:QogKY4nO_LBho6G:QogKY4nO_UBhomb9Q"
            A$ = A$ + "oKLY4n_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0"
            A$ = A$ + "fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m"
            A$ = A$ + "0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0foO_UBhomb9QoKLY4nO_UBhomF:Qog;W4n_aUBho"
            A$ = A$ + "mF:QogKY4nO_LBho6G:QoCXDHl?QB5bo4:56oCXFQl?QBQaomb9Qoooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooo?QB5bo6K\aoK\a6o_a6Klo4:E8oKLY4noooooooooooooooooooooooooooooooooooooooooooooooooooooo4:56oCXF"
            A$ = A$ + "Ql_a6Klo4:E8oCXDHlO_L^go4:E8oCXDHl?QB5bo4:56oCXDQl?QBQao4:E8oCXDHl?QB5bo4:56oCXDQl?QBQao4:E8oCXDHl?Q"
            A$ = A$ + "B5bof3Pmog;W4noooooooooooooooooooooooooooooooooooooogkL]oo_cenom>Gko>G:UoO_cenoo>GkomF:QoK?0foO_UBho"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooo_cenom6Gko>G:Uo3000l_cUBiogKL]ogKY4n_m0HoomF:Qoooooo?000`o0000"
            A$ = A$ + "o3000looooooooooooooooom>GkookL]o3000loo>Gko0000oo_cenO_LBhof3PmogKY4noooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooogkL]oO_cenoo>GkogKL]oO_cenom>GkomF:QoK?0foO_LBhoooooo3000l?000`o0000o3000l?000`oooooog;W4n_a"
            A$ = A$ + "UBhomF:QogKY4nO_LBho6G:QogKY4n_m0HoomF:Qoooooooooooooooooooooooooooooooooooooooo>GkogKL]oO_cenom>Gko"
            A$ = A$ + "okL]oO_aenO_UBhof3PmogKY4noooooo0000o3000l?000`o0000oooooooooooogkL]oo_cen?000`ookL]o3000loo>Gkomb9Q"
            A$ = A$ + "oK?0foO_UBhooooooooooooooooooooooooooooooooooooooO_cenom>Gko>G:Uo3000l_cUBiogkL]ogKY4n_m0Hoomb9Qoooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooom>GkookL]oO_cen_cUBiogkL]oo_cenO_UBhof3PmogKY4nO_L^gomF:Qog;W4nO_"
            A$ = A$ + "UBhombiNogKY4nO_LBhomF:Qog;WkmO_UBhomb9QogKY4nO_L^gomF:QoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoo"
            A$ = A$ + "f3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3Pm"
            A$ = A$ + "oK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0"
            A$ = A$ + "fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m"
            A$ = A$ + "0HooQdJ8oSAYQlO8]6boHD:6oC9Skm_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoSAYHl_B>[do"
            A$ = A$ + "2I\Bo[Tc:m?S4>gof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo?Q<Biogooooonk_o_eFKmo4b8U"
            A$ = A$ + "oK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoo4b8SoooooooiWOnoFK]eoC8S<n?WUFjoLb9WocIY"
            A$ = A$ + "Un?WLbioLFJYoc9WLn?WUFjoLb9WocIYUnoooooof3PmoC8SDnomooooWonkoK]eFo?Q<Bio_OomoonmoookgOoogooooonmgook"
            A$ = A$ + "gooo_OomoOoooookgOoooooooK?0fo?6URaoLJ=WoOniWo?Smbho4B8Soooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooo_m0Hoo<J=SoSAYHl?U>CioH@96oGJ[]n_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3Pm"
            A$ = A$ + "oK?0fo?SNchoHD:6ocIYUn_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmocIY"
            A$ = A$ + "Un_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m"
            A$ = A$ + "0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoo"
            A$ = A$ + "f3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3Pm"
            A$ = A$ + "oK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0"
            A$ = A$ + "fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m"
            A$ = A$ + "0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoo"
            A$ = A$ + "f3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3Pmo_fJ[moJ[]fo[]fJo_fJ[moJ[]fo[]fJ"
            A$ = A$ + "o_fJ[moJ[]fo[]fJo_fJ[moJ[]fo[]fJo_fJ[moJ[]fof3Pmo_fJ[m_gNkmooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooo_onko_fJ[moJ[]foooooo;Ug:m_DN;eoooooo;UgBm_DN[doooooo;Ug:m_DN;eooooooooooooo"
            A$ = A$ + "oooooooooooooooJ[]fo[]fJooooooO>NWcoiHM<ooooooO>NWcoihM>ooooooO>NWcoihM>oooooooooooooooooooooooooooo"
            A$ = A$ + "[]fJo_fJ[mooooooaHM:o7SgalooooooaHM<o7SeYlooooooaHM:o7Sealooooooooooooooooooooooooooo_fJ[moJ[]fooooo"
            A$ = A$ + "o[Tg:m_@N;doooooo;Tg2m_BN[doooooo[Tg2m_@N;dooooooooooooooooooooooooooooJ[]fo[]fJoOniWooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooiWOno[]fJoK?0fooJ[]fo[]fJo_fJ[moJ[]fo[]fJo_fJ[moJ"
            A$ = A$ + "[]fo[]fJo_fJ[moJ[]fo[]fJo_fJ[moJ[]fo[]fJoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoo"
            A$ = A$ + "f3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3Pm"
            A$ = A$ + "oK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0"
            A$ = A$ + "fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m"
            A$ = A$ + "0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_c]bioFG;WokL[Ln_cebio"
            A$ = A$ + ">g:UokLYDn_aLBhomb9QoG;ScmO]<>go]^gHogjNSmOYc9eoU>WDoK?0fo_m0Hoo>g:Woooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooOokooom_oooWkmooO^eoCX@Yl_m0Hoof3PmokL[Lnoooooooooooooooooooooooooooooooo_gNOooa<Vgo7cH"
            A$ = A$ + "No_e6KmooO^eoON_Un?Q:Ubof3PmoK?0fo_c]bioooooooooooooooooooooooooooooooooa<VeogkkoooLmnooQXUeoo_e6o_g"
            A$ = A$ + "eFjo4:D8oK?0fo_m0Hoo>g:UoooooooooooooooooooooooooooooOomo7cHNooL6ooo:AYeo7RD>oooFgkoFg:WoCXBYl_m0Hoo"
            A$ = A$ + "f3PmoKLYDnoooooooooooooooooooooooOokooom_o_e6KmoQXUeoSQD6o_eeFkookL]okL[LnoN2Qaof3PmoK?0fo_aLBhooooo"
            A$ = A$ + "ooooooomWkmoLBhLoG:ScmomNklooO^eoo_g6oooFgkookL]oo_c]n_aUBio4:D8oK?0fo_m0HoomB9Qooooooom_OnoLBhLogji"
            A$ = A$ + "enO]Wgko[=VBokL[LnoJB9doS9U@okM]Lnoo6Gjomb9Uo_G>Hl_m0Hoof3PmoG;Scmom_OnoLF:Qogjien_egkmo]NN]oCXcDnoJ"
            A$ = A$ + "k=foFgK]ok]cmn?000`ogg;WoG;W<n?QiPaof3PmoK?0foO]<^foLF:Qogjien_egKmo]NN]ocXeLnoL6choBEkJo?fLBmO_]Fjo"
            A$ = A$ + "eF:Uo3000lO]Dbhok534oK?0fo_m0Hoo]^gHogjien_egkmo]NN_oCYeLnoN>choSekLo[D[[mO:LZdoBYD>oCiNcm?Uk=go0000"
            A$ = A$ + "o_G>@l_m0Hoof3PmoGjNJmO_WKlo]NN]oCYeLn?Q>CioSekNo;E][mO<L:eoQ@Y@o31Sil_BJUco[YUBo?VD2moNaP`of3PmoK?0"
            A$ = A$ + "foOYc9eoDJ=WocXeLnoN>choSekLo;E][mO<L:eoY@Y@oS1Sil?6<VcoH`H>oWbNil_BiTbok534oK?0fo_m0HooU>WDoCX@Yl?Q"
            A$ = A$ + ":Ubo4:D8oCX@QloN2Qao4:46o_G>HloNiPaok534o_G<@loNaP`ok532o?G:8l_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoo"
            A$ = A$ + "f3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3Pm"
            A$ = A$ + "oK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0HooN[40oK?0fo_g:1`of3Pmok]B0l_m0HooN[40oK?0"
            A$ = A$ + "fo_m0Hoof3PmoK?0fo_m0Hoof3PmoGJYDn?WLBiof3PmoK?0fo_g:1`of3PmoK?0fo_e21`of3PmoK]@0l_m0HooLb9UoGJYDn?W"
            A$ = A$ + "LBiof3PmoGJYLn_m0Hoof3PmoK?0fo_m0HooN[40oK?0fo_m0Hoof3Pmok]B0l_m0Hoof3PmoK?0fo_m0Hoof3Pmoc9WDn?WLBio"
            A$ = A$ + "f3PmoK?0fo_m0HooF;40oK?0fo_e21`of3PmoK?0fo_g:1`of3PmoK?0fo_m0Hoof3PmoK?0foOYUBioUF:UoK?0fo_m0Hoof3Pm"
            A$ = A$ + "oK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0HooLb9Uoc9WDn_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0"
            A$ = A$ + "fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoG:WDnOYUbiof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m"
            A$ = A$ + "0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo?WLBioLb9UoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoo"
            A$ = A$ + "f3PmoK?0fo_m0HooUF:UoGJYDn_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3Pm"
            A$ = A$ + "oc9WDn?WLBiof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0foOYLBioUF:WoK?0"
            A$ = A$ + "fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0HooLb9Uoc9WDn_m0Hoof3PmoK?0fo_m"
            A$ = A$ + "0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoGJYDnOYUBiof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoo"
            A$ = A$ + "f3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo?WLBiof3PmoGJYDn?WLBioUb9Uoc9WDnOYUBioLb9UoG:WDn?WLBioUF:U"
            A$ = A$ + "oc9WDnOYLBioLb9UoGJYDn?WLBiof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0fo_m0Hoof3PmoK?0"
            A$ = A$ + "fo_m0Hoof3PmoK?0%fo?"
    END SELECT

    EditorImageData$ = A$
END FUNCTION

'---------------------------------------------------------------------------------
FUNCTION LoadEditorImage& (FileName$)
    'Contains portions of Dav's BIN2BAS
    'http://www.qbasicnews.com/dav/qb64.php

    DIM A$, i&, B$, C%, F$, C$, t%, B&, X$, btemp$, BASFILE$
    DIM MemoryBlock AS _MEM, TempImage AS LONG, NextSlot AS LONG
    DIM NewWidth AS INTEGER, NewHeight AS INTEGER

    A$ = EditorImageData$(FileName$)
    IF LEN(A$) = 0 THEN EXIT FUNCTION

    NewWidth = CVI(LEFT$(A$, 2))
    NewHeight = CVI(MID$(A$, 3, 2))
    A$ = MID$(A$, 5)

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
    BASFILE$ = btemp$

    TempImage = _NEWIMAGE(NewWidth, NewHeight, 32)
    MemoryBlock = _MEMIMAGE(TempImage)

    __UI_MemCopy MemoryBlock.OFFSET, _OFFSET(BASFILE$), LEN(BASFILE$)
    _MEMFREE MemoryBlock

    LoadEditorImage& = TempImage
END FUNCTION

SUB LoadPreview
    DIM a$, b$, i AS LONG, __UI_EOF AS _BYTE, Answer AS _BYTE
    DIM NewType AS INTEGER, NewWidth AS INTEGER, NewHeight AS INTEGER
    DIM NewLeft AS INTEGER, NewTop AS INTEGER, NewName AS STRING
    DIM NewParentID AS STRING, FloatValue AS _FLOAT, Dummy AS LONG
    DIM BinaryFileNum AS INTEGER

    IF _FILEEXISTS("UiEditorPreview.frmbin") = 0 THEN
        EXIT SUB
    ELSE
        TIMER(__UI_EventsTimer) OFF
        TIMER(__UI_RefreshTimer) OFF

        BinaryFileNum = FREEFILE
        OPEN "UiEditorPreview.frmbin" FOR BINARY AS #BinaryFileNum

        b$ = SPACE$(7): GET #BinaryFileNum, 1, b$
        IF b$ <> "InForm" + CHR$(1) THEN
            GOTO LoadError
            EXIT SUB
        END IF

        b$ = SPACE$(4): GET #BinaryFileNum, , b$

        REDIM PreviewCaptions(1 TO CVL(b$)) AS STRING
        REDIM PreviewTexts(1 TO CVL(b$)) AS STRING
        REDIM PreviewTips(1 TO CVL(b$)) AS STRING
        REDIM PreviewFonts(1 TO CVL(b$)) AS STRING
        REDIM PreviewControls(0 TO CVL(b$)) AS __UI_ControlTYPE

        b$ = SPACE$(2): GET #BinaryFileNum, , b$
        IF CVI(b$) <> -1 THEN GOTO LoadError
        DO
            b$ = SPACE$(4): GET #BinaryFileNum, , b$
            Dummy = CVL(b$)
            IF Dummy < 0 OR Dummy > UBOUND(PreviewControls) THEN EXIT DO 'Corrupted exchange file.
            b$ = SPACE$(2): GET #BinaryFileNum, , b$
            NewType = CVI(b$)
            b$ = SPACE$(2): GET #BinaryFileNum, , b$
            b$ = SPACE$(CVI(b$)): GET #BinaryFileNum, , b$
            NewName = b$
            b$ = SPACE$(2): GET #BinaryFileNum, , b$
            NewWidth = CVI(b$)
            b$ = SPACE$(2): GET #BinaryFileNum, , b$
            NewHeight = CVI(b$)
            b$ = SPACE$(2): GET #BinaryFileNum, , b$
            NewLeft = CVI(b$)
            b$ = SPACE$(2): GET #BinaryFileNum, , b$
            NewTop = CVI(b$)
            b$ = SPACE$(2): GET #BinaryFileNum, , b$
            NewParentID = SPACE$(CVI(b$)): GET #BinaryFileNum, , NewParentID

            PreviewControls(Dummy).ID = Dummy
            PreviewControls(Dummy).Name = NewName
            PreviewControls(Dummy).Width = NewWidth
            PreviewControls(Dummy).Height = NewHeight
            PreviewControls(Dummy).Left = NewLeft
            PreviewControls(Dummy).Top = NewTop

            DO 'read properties
                b$ = SPACE$(2): GET #BinaryFileNum, , b$
                SELECT CASE CVI(b$)
                    CASE -2 'Caption
                        b$ = SPACE$(4): GET #BinaryFileNum, , b$
                        b$ = SPACE$(CVL(b$))
                        GET #BinaryFileNum, , b$
                        PreviewCaptions(Dummy) = b$
                    CASE -3 'Text
                        b$ = SPACE$(4): GET #BinaryFileNum, , b$
                        b$ = SPACE$(CVL(b$))
                        GET #BinaryFileNum, , b$
                        PreviewTexts(Dummy) = b$
                    CASE -4 'Stretch
                        PreviewControls(Dummy).Stretch = __UI_True
                    CASE -5 'Font
                        DIM FontSetup$, FindSep AS INTEGER
                        DIM NewFontName AS STRING, NewFontFile AS STRING
                        DIM NewFontSize AS INTEGER, NewFontAttributes AS STRING
                        b$ = SPACE$(2): GET #BinaryFileNum, , b$
                        FontSetup$ = SPACE$(CVI(b$)): GET #BinaryFileNum, , FontSetup$
                        PreviewFonts(Dummy) = FontSetup$
                    CASE -6 'ForeColor
                        b$ = SPACE$(4): GET #BinaryFileNum, , b$
                        PreviewControls(Dummy).ForeColor = _CV(_UNSIGNED LONG, b$)
                    CASE -7 'BackColor
                        b$ = SPACE$(4): GET #BinaryFileNum, , b$
                        PreviewControls(Dummy).BackColor = _CV(_UNSIGNED LONG, b$)
                    CASE -8 'SelectedForeColor
                        b$ = SPACE$(4): GET #BinaryFileNum, , b$
                        PreviewControls(Dummy).SelectedForeColor = _CV(_UNSIGNED LONG, b$)
                    CASE -9 'SelectedBackColor
                        b$ = SPACE$(4): GET #BinaryFileNum, , b$
                        PreviewControls(Dummy).SelectedBackColor = _CV(_UNSIGNED LONG, b$)
                    CASE -10 'BorderColor
                        b$ = SPACE$(4): GET #BinaryFileNum, , b$
                        PreviewControls(Dummy).BorderColor = _CV(_UNSIGNED LONG, b$)
                    CASE -11
                        PreviewControls(Dummy).BackStyle = __UI_Transparent
                    CASE -12
                        PreviewControls(Dummy).HasBorder = __UI_True
                    CASE -13
                        b$ = SPACE$(1): GET #BinaryFileNum, , b$
                        PreviewControls(Dummy).Align = _CV(_BYTE, b$)
                    CASE -14
                        b$ = SPACE$(LEN(FloatValue)): GET #BinaryFileNum, , b$
                        PreviewControls(Dummy).Value = _CV(_FLOAT, b$)
                    CASE -15
                        b$ = SPACE$(LEN(FloatValue)): GET #BinaryFileNum, , b$
                        PreviewControls(Dummy).Min = _CV(_FLOAT, b$)
                    CASE -16
                        b$ = SPACE$(LEN(FloatValue)): GET #BinaryFileNum, , b$
                        PreviewControls(Dummy).Max = _CV(_FLOAT, b$)
                    CASE -17
                        b$ = SPACE$(2): GET #BinaryFileNum, , b$
                        PreviewControls(Dummy).HotKey = CVI(b$)
                    CASE -18
                        b$ = SPACE$(2): GET #BinaryFileNum, , b$
                        PreviewControls(Dummy).HotKeyOffset = CVI(b$)
                    CASE -19
                        PreviewControls(Dummy).ShowPercentage = __UI_True
                    CASE -20
                        PreviewControls(Dummy).CanHaveFocus = __UI_True
                    CASE -21
                        PreviewControls(Dummy).Disabled = __UI_True
                    CASE -22
                        PreviewControls(Dummy).Hidden = __UI_True
                    CASE -23
                        PreviewControls(Dummy).CenteredWindow = __UI_True
                    CASE -24 'Tips
                        b$ = SPACE$(4): GET #BinaryFileNum, , b$
                        b$ = SPACE$(CVL(b$))
                        GET #BinaryFileNum, , b$
                        PreviewTips(Dummy) = b$
                    CASE -26
                        b$ = SPACE$(LEN(FloatValue)): GET #BinaryFileNum, , b$
                        PreviewControls(Dummy).Interval = _CV(_FLOAT, b$)
                    CASE -27
                        PreviewControls(Dummy).WordWrap = __UI_True
                    CASE -29
                        PreviewControls(Dummy).CanResize = __UI_True
                    CASE -1 'new control
                        EXIT DO
                    CASE -1024
                        __UI_EOF = __UI_True
                        EXIT DO
                    CASE ELSE
                        EXIT DO
                END SELECT
            LOOP
        LOOP UNTIL __UI_EOF
        LoadError:
        CLOSE #BinaryFileNum
        TIMER(__UI_EventsTimer) ON
        TIMER(__UI_RefreshTimer) ON
    END IF
END SUB

SUB SendData (b$, Property AS INTEGER)
    DIM FileNum AS INTEGER
    FileNum = FREEFILE
    OPEN "UiEditor.dat" FOR BINARY AS #FileNum

    'Send the data first, then the signal
    PUT #FileNum, OffsetPropertyValue, b$
    b$ = MKI$(Property): PUT #FileNum, OffsetPropertyChanged, b$
    b$ = MKI$(-1): PUT #FileNum, OffsetNewDataFromEditor, b$
    CLOSE #FileNum
END SUB

SUB UpdateColorPreview (Attribute AS _BYTE, ForeColor AS _UNSIGNED LONG, BackColor AS _UNSIGNED LONG)
    DIM PreviewWord$
    _DEST __UI_Controls(ColorPreviewID).HelperCanvas
    _FONT __UI_Controls(ColorPreviewID).Font
    PreviewWord$ = "Preview"
    IF __UI_Controls(ColorPropertiesListID).Value = 5 THEN
        CLS , BackColor
        LINE (20, 20)-STEP(_WIDTH - 41, _HEIGHT - 41), ForeColor, B
    ELSE
        CLS , BackColor
        COLOR ForeColor, BackColor
        _PRINTSTRING (_WIDTH \ 2 - _PRINTWIDTH(PreviewWord$) \ 2, _HEIGHT \ 2 - _FONTHEIGHT \ 2), PreviewWord$
    END IF
    _DEST 0
    __UI_Controls(ColorPreviewID).PreviousValue = 0 'Force update
END SUB

SUB QuickColorPreview (ThisColor AS _UNSIGNED LONG)
    _DEST __UI_Controls(ColorPreviewID).HelperCanvas
    CLS , ThisColor
    _DEST 0
    __UI_Controls(ColorPreviewID).PreviousValue = 0 'Force update
END SUB

SUB CheckPreview
    'Check if the preview window is still alive
    DIM b$, UiEditorFile AS INTEGER

    UiEditorFile = FREEFILE
    OPEN "UiEditor.dat" FOR BINARY AS #UiEditorFile
    b$ = SPACE$(4): GET #UiEditorFile, OffsetPreviewPID, b$
    CLOSE #UiEditorFile
    UiPreviewPID = CVL(b$)
    $IF WIN THEN
        DIM hnd&, b&, c&, ExitCode&
        IF UiPreviewPID > 0 THEN
            hnd& = OpenProcess(&H400, 0, UiPreviewPID)
            b& = GetExitCodeProcess(hnd&, ExitCode&)
            c& = CloseHandle(hnd&)
            IF b& = 1 AND ExitCode& = 259 THEN
                'Preview is active.
                __UI_Controls(__UI_GetID("ViewMenuPreview")).Disabled = __UI_True
            ELSE
                'Preview was closed.
                TIMER(__UI_EventsTimer) OFF
                __UI_Controls(__UI_GetID("ViewMenuPreview")).Disabled = __UI_False
                __UI_WaitMessage = "Reloading preview window..."
                OPEN "UiEditor.dat" FOR BINARY AS #UiEditorFile
                b$ = MKL$(0): PUT #UiEditorFile, OffsetPreviewPID, b$
                CLOSE #UiEditorFile
                UiPreviewPID = 0
                SHELL _DONTWAIT "UiEditorPreview.exe"
                __UI_LastInputReceived = 0 'Make the "Please wait" message show up immediataly
                DO
                    _LIMIT 10
                    OPEN "UiEditor.dat" FOR BINARY AS #UiEditorFile
                    b$ = SPACE$(4)
                    GET #UiEditorFile, OffsetPreviewPID, b$
                    CLOSE #UiEditorFile
                LOOP UNTIL CVL(b$) > 0

                UiPreviewPID = CVL(b$)

                TIMER(__UI_EventsTimer) ON
            END IF
        END IF
    $ELSE
        IF UiPreviewPID > 0 THEN
        IF PROCESS_CLOSED(UiPreviewPID, 0) THEN
        'Preview was closed.
        TIMER(__UI_EventsTimer) OFF
        __UI_Controls(__UI_GetID("ViewMenuPreview")).Disabled = __UI_False
        __UI_WaitMessage = "Reloading preview window..."
        OPEN "UiEditor.dat" FOR BINARY AS #UiEditorFile
        b$ = MKL$(0): PUT #UiEditorFile, OffsetPreviewPID, b$
        CLOSE #UiEditorFile
        UiPreviewPID = 0
        SHELL _DONTWAIT "./UiEditorPreview"
        __UI_LastInputReceived = 0 'Make the "Please wait" message show up immediataly
        DO
        _LIMIT 10
        OPEN "UiEditor.dat" FOR BINARY AS #UiEditorFile
        b$ = SPACE$(4)
        GET #UiEditorFile, OffsetPreviewPID, b$
        CLOSE #UiEditorFile
        LOOP UNTIL CVL(b$) > 0

        UiPreviewPID = CVL(b$)

        TIMER(__UI_EventsTimer) ON
        ELSE
        'Preview is active.
        __UI_Controls(__UI_GetID("ViewMenuPreview")).Disabled = __UI_True
        END IF
        END IF
    $END IF
END SUB
