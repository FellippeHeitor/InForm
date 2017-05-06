OPTION _EXPLICIT

$EXEICON:'.\resources\InForm.ico'

DIM SHARED RedTrackID AS LONG, GreenTrackID AS LONG, BlueTrackID AS LONG
DIM SHARED RedTextBoxID AS LONG, GreenTextBoxID AS LONG, BlueTextBoxID AS LONG
DIM SHARED ColorPropertiesListID AS LONG, PropertyValueID AS LONG
DIM SHARED UiPreviewPID AS LONG, TotalSelected AS LONG, FirstSelected AS LONG
DIM SHARED PreviewFormID AS LONG, ColorPreviewID AS LONG
DIM SHARED PropertyUpdateStatusID AS LONG
DIM SHARED CheckPreviewTimer AS INTEGER, PreviewAttached AS _BYTE, AutoNameControls AS _BYTE
DIM SHARED PropertyUpdateStatusImage AS LONG, LastKeyPress AS DOUBLE
DIM SHARED UiEditorTitle$, Edited AS _BYTE, ZOrderingDialogOpen AS _BYTE
DIM SHARED OpenDialogOpen AS _BYTE, OverwriteOldFiles AS _BYTE
DIM SHARED OptionsMenuSwapButtons AS LONG

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
CONST OffsetPropertyValue = 43

REDIM SHARED PreviewCaptions(0) AS STRING
REDIM SHARED PreviewTexts(0) AS STRING
REDIM SHARED PreviewTips(0) AS STRING
REDIM SHARED PreviewFonts(0) AS STRING
REDIM SHARED PreviewControls(0) AS __UI_ControlTYPE
REDIM SHARED PreviewParentIDS(0) AS STRING
REDIM SHARED zOrderIDs(0) AS LONG

DIM SHARED FontList.Names AS STRING
REDIM SHARED FontList.FileNames(0) AS STRING

$IF WIN THEN
    CONST PathSep$ = "\"
$ELSE
    CONST PathSep$ = "/"
$END IF

IF _FILEEXISTS("falcon.h") = 0 THEN RestoreFalcon

DIM SHARED CurrentPath$
DIM SHARED DialogBG AS LONG
DIM SHARED OpenDialog AS LONG
DIM SHARED OpenFrame AS LONG
DIM SHARED FileNameLB AS LONG
DIM SHARED FileNameTextBox AS LONG
DIM SHARED PathLB AS LONG
DIM SHARED FilesLB AS LONG
DIM SHARED FileList AS LONG
DIM SHARED PathsLB AS LONG
DIM SHARED DirList AS LONG
DIM SHARED OpenBT AS LONG
DIM SHARED CancelBT AS LONG
DIM SHARED ShowOnlyFrmbinFilesCB AS LONG
DIM SHARED ZOrdering AS LONG, CloseZOrderingBT AS LONG
DIM SHARED UpBT AS LONG, DownBT AS LONG, ControlList AS LONG
DIM SHARED EditMenuUndo AS LONG, EditMenuRedo AS LONG

CheckPreviewTimer = _FREETIMER
ON TIMER(CheckPreviewTimer, .003) CheckPreview

UiEditorTitle$ = "InForm Designer"

$IF WIN THEN
    DECLARE DYNAMIC LIBRARY "kernel32"
        FUNCTION OpenProcess& (BYVAL dwDesiredAccess AS LONG, BYVAL bInheritHandle AS LONG, BYVAL dwProcessId AS LONG)
        FUNCTION CloseHandle& (BYVAL hObject AS LONG)
        FUNCTION GetExitCodeProcess& (BYVAL hProcess AS LONG, lpExitCode AS LONG)
    END DECLARE

    ''Registry routines taken from the Wiki: http://www.qb64.net/wiki/index.php/Windows_Libraries#Registered_Fonts
    ''Code courtesy of Michael Calkins
    ''winreg.h
    'CONST HKEY_CLASSES_ROOT = &H80000000~&
    'CONST HKEY_CURRENT_USER = &H80000001~&
    'CONST HKEY_LOCAL_MACHINE = &H80000002~&
    'CONST HKEY_USERS = &H80000003~&
    'CONST HKEY_PERFORMANCE_DATA = &H80000004~&
    'CONST HKEY_CURRENT_CONFIG = &H80000005~&
    'CONST HKEY_DYN_DATA = &H80000006~&
    'CONST REG_OPTION_VOLATILE = 1
    'CONST REG_OPTION_NON_VOLATILE = 0
    'CONST REG_CREATED_NEW_KEY = 1
    'CONST REG_OPENED_EXISTING_KEY = 2

    ''http://msdn.microsoft.com/en-us/library/ms724884(v=VS.85).aspx
    'CONST REG_NONE = 0
    'CONST REG_SZ = 1
    'CONST REG_EXPAND_SZ = 2
    'CONST REG_BINARY = 3
    'CONST REG_DWORD_LITTLE_ENDIAN = 4
    'CONST REG_DWORD = 4
    'CONST REG_DWORD_BIG_ENDIAN = 5
    'CONST REG_LINK = 6
    'CONST REG_MULTI_SZ = 7
    'CONST REG_RESOURCE_LIST = 8
    'CONST REG_FULL_RESOURCE_DESCRIPTOR = 9
    'CONST REG_RESOURCE_REQUIREMENTS_LIST = 10
    'CONST REG_QWORD_LITTLE_ENDIAN = 11
    'CONST REG_QWORD = 11
    'CONST REG_NOTIFY_CHANGE_NAME = 1
    'CONST REG_NOTIFY_CHANGE_ATTRIBUTES = 2
    'CONST REG_NOTIFY_CHANGE_LAST_SET = 4
    'CONST REG_NOTIFY_CHANGE_SECURITY = 8

    ''http://msdn.microsoft.com/en-us/library/ms724878(v=VS.85).aspx
    'CONST KEY_ALL_ACCESS = &HF003F&
    'CONST KEY_CREATE_LINK = &H0020&
    'CONST KEY_CREATE_SUB_KEY = &H0004&
    'CONST KEY_ENUMERATE_SUB_KEYS = &H0008&
    'CONST KEY_EXECUTE = &H20019&
    'CONST KEY_NOTIFY = &H0010&
    'CONST KEY_QUERY_VALUE = &H0001&
    'CONST KEY_READ = &H20019&
    'CONST KEY_SET_VALUE = &H0002&
    'CONST KEY_WOW64_32KEY = &H0200&
    'CONST KEY_WOW64_64KEY = &H0100&
    'CONST KEY_WRITE = &H20006&

    ''winerror.h
    ''http://msdn.microsoft.com/en-us/library/ms681382(v=VS.85).aspx
    'CONST ERROR_SUCCESS = 0
    'CONST ERROR_FILE_NOT_FOUND = &H2&
    'CONST ERROR_INVALID_HANDLE = &H6&
    'CONST ERROR_MORE_DATA = &HEA&
    'CONST ERROR_NO_MORE_ITEMS = &H103&

    'DECLARE DYNAMIC LIBRARY "advapi32"
    '    FUNCTION RegOpenKeyExA& (BYVAL hKey AS _OFFSET, BYVAL lpSubKey AS _OFFSET, BYVAL ulOptions AS _UNSIGNED LONG, BYVAL samDesired AS _UNSIGNED LONG, BYVAL phkResult AS _OFFSET)
    '    FUNCTION RegCloseKey& (BYVAL hKey AS _OFFSET)
    '    FUNCTION RegEnumValueA& (BYVAL hKey AS _OFFSET, BYVAL dwIndex AS _UNSIGNED LONG, BYVAL lpValueName AS _OFFSET, BYVAL lpcchValueName AS _OFFSET, BYVAL lpReserved AS _OFFSET, BYVAL lpType AS _OFFSET, BYVAL lpData AS _OFFSET, BYVAL lpcbData AS _OFFSET)
    'END DECLARE
$ELSE
    DECLARE LIBRARY
    FUNCTION PROCESS_CLOSED& ALIAS kill (BYVAL pid AS INTEGER, BYVAL signal AS INTEGER)
    END DECLARE
$END IF

'$include:'InForm.ui'
'$include:'xp.uitheme'
'$include:'UiEditor.frm'

'Event procedures: ---------------------------------------------------------------
SUB __UI_Click (id AS LONG)
    DIM Answer AS _BYTE, Dummy AS LONG, b$, UiEditorFile AS INTEGER
    STATIC LastClick#, LastClickedID AS LONG

    SELECT EVERYCASE UCASE$(RTRIM$(Control(id).Name))
        CASE "ALIGNMENUALIGNLEFT": Dummy = 201
        CASE "ALIGNMENUALIGNRIGHT": Dummy = 202
        CASE "ALIGNMENUALIGNTOPS": Dummy = 203
        CASE "ALIGNMENUALIGNBOTTOMS": Dummy = 204
        CASE "ALIGNMENUALIGNCENTERSV": Dummy = 205
        CASE "ALIGNMENUALIGNCENTERSH": Dummy = 206
        CASE "ALIGNMENUALIGNCENTERV": Dummy = 207
        CASE "ALIGNMENUALIGNCENTERH": Dummy = 208
        CASE "ALIGNMENUDISTRIBUTEV": Dummy = 209
        CASE "ALIGNMENUDISTRIBUTEH": Dummy = 210
        CASE "ALIGNMENUALIGNLEFT", "ALIGNMENUALIGNRIGHT", "ALIGNMENUALIGNTOPS", _
        "ALIGNMENUALIGNBOTTOMS", "ALIGNMENUALIGNCENTERSV", "ALIGNMENUALIGNCENTERSH", _
        "ALIGNMENUALIGNCENTERV", "ALIGNMENUALIGNCENTERH", "ALIGNMENUDISTRIBUTEV", _
        "ALIGNMENUDISTRIBUTEH"
            b$ = MKI$(0)
            SendData b$, Dummy
        CASE "OPTIONSMENUAUTONAME"
            AutoNameControls = NOT AutoNameControls
            Control(id).Value = AutoNameControls
            SaveSettings
        CASE "OPTIONSMENUSWAPBUTTONS"
            __UI_MouseButtonsSwap = NOT __UI_MouseButtonsSwap
            Control(id).Value = __UI_MouseButtonsSwap
            SaveSettings
        CASE "OPTIONSMENUSNAPLINES"
            __UI_SnapLines = NOT __UI_SnapLines
            Control(id).Value = __UI_SnapLines
            SaveSettings
        CASE "INSERTMENUMENUBAR"
            UiEditorFile = FREEFILE
            OPEN "InForm/UiEditor.dat" FOR BINARY AS #UiEditorFile
            b$ = MKI$(__UI_Type_MenuBar)
            PUT #UiEditorFile, OffsetNewControl, b$
            CLOSE #UiEditorFile
            Edited = True
        CASE "INSERTMENUMENUITEM"
            UiEditorFile = FREEFILE
            OPEN "InForm/UiEditor.dat" FOR BINARY AS #UiEditorFile
            b$ = MKI$(__UI_Type_MenuItem)
            PUT #UiEditorFile, OffsetNewControl, b$
            CLOSE #UiEditorFile
            Edited = True
        CASE "VIEWMENUPREVIEWDETACH"
            PreviewAttached = NOT PreviewAttached
            Control(id).Value = PreviewAttached
            SaveSettings
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
            OPEN "InForm/UiEditor.dat" FOR BINARY AS #UiEditorFile
            b$ = MKI$(Dummy)
            PUT #UiEditorFile, OffsetNewControl, b$
            CLOSE #UiEditorFile
            Edited = True
        CASE "STRETCH"
            b$ = MKI$(Control(id).Value)
            SendData b$, 14
        CASE "HASBORDER"
            b$ = MKI$(Control(id).Value)
            SendData b$, 15
        CASE "TRANSPARENT"
            b$ = MKI$(Control(__UI_GetID("TRANSPARENT")).Value)
            SendData b$, 28
        CASE "SHOWPERCENTAGE"
            b$ = MKI$(Control(id).Value)
            SendData b$, 16
        CASE "WORDWRAP"
            b$ = MKI$(Control(id).Value)
            SendData b$, 17
        CASE "CANHAVEFOCUS"
            b$ = MKI$(Control(id).Value)
            SendData b$, 18
        CASE "DISABLED"
            b$ = MKI$(Control(id).Value)
            SendData b$, 19
        CASE "HIDDEN"
            b$ = MKI$(Control(id).Value)
            SendData b$, 20
        CASE "CENTEREDWINDOW"
            b$ = MKI$(Control(id).Value)
            SendData b$, 21
        CASE "RESIZABLE"
            b$ = MKI$(Control(id).Value)
            SendData b$, 29
        CASE "PASSWORDMASKCB"
            b$ = MKI$(Control(id).Value)
            SendData b$, 33
        CASE "VIEWMENUPREVIEW"
            $IF WIN THEN
                SHELL _DONTWAIT ".\InForm\UiEditorPreview.exe"
            $ELSE
                SHELL _DONTWAIT "./InForm/UiEditorPreview"
            $END IF
        CASE "VIEWMENULOADEDFONTS"
            DIM Temp$
            FOR Dummy = 1 TO UBOUND(PreviewFonts)
                IF LEN(PreviewFonts(Dummy)) THEN
                    IF LEN(Temp$) THEN Temp$ = Temp$ + CHR$(10)
                    Temp$ = Temp$ + PreviewFonts(Dummy)
                END IF
            NEXT
            IF LEN(Temp$) THEN
                Answer = MessageBox(Temp$, "Loaded fonts", MsgBox_OkOnly + MsgBox_Information)
            ELSE
                Answer = MessageBox("There are no fonts loaded.", "", MsgBox_OkOnly + MsgBox_Critical)
            END IF
        CASE "FILEMENUNEW"
            IF Edited THEN
                $IF WIN THEN
                    Answer = MessageBox("Save the current form?", "", MsgBox_YesNoCancel + MsgBox_Question)
                $ELSE
                    Answer = MessageBox("Save the current form?", "", MsgBox_YesNo + MsgBox_Question)
                $END IF
                IF Answer = MsgBox_Cancel THEN
                    EXIT SUB
                ELSEIF Answer = MsgBox_Yes THEN
                    SaveForm False, False
                END IF
            END IF

            SendSignal -5
        CASE "FILEMENUSAVEFRM"
            SaveForm True, True
        CASE "FILEMENUSAVE"
            SaveForm True, False
        CASE "HELPMENUABOUT"
            Answer = MessageBox(UiEditorTitle$ + " " + __UI_Version + CHR$(10) + "by Fellippe Heitor" + CHR$(10) + CHR$(10) + "Twitter: @fellippeheitor" + CHR$(10) + "e-mail: fellippe@qb64.org", "About", MsgBox_OkOnly + MsgBox_Information)
        CASE "HELPMENUHELP"
            Answer = MessageBox("Design a form and export the resulting code to generate an event-driven QB64 program.", "What's all this?", MsgBox_OkOnly + MsgBox_Information)
        CASE "FILEMENUEXIT"
            IF Edited THEN
                $IF WIN THEN
                    Answer = MessageBox("Save the current form before leaving?", "", MsgBox_YesNoCancel + MsgBox_Question)
                $ELSE
                    Answer = MessageBox("Save the current form before leaving?", "", MsgBox_YesNo + MsgBox_Question)
                $END IF
                IF Answer = MsgBox_Cancel THEN
                    EXIT SUB
                ELSEIF Answer = MsgBox_Yes THEN
                    SaveForm False, False
                END IF
            END IF
            SYSTEM
        CASE "EDITMENUZORDERING"
            'Fill the list:
            DIM j AS LONG, i AS LONG
            STATIC Moving AS _BYTE
            REDIM _PRESERVE zOrderIDs(1 TO UBOUND(PreviewControls)) AS LONG
            ReloadZList:
            ResetList ControlList
            FOR i = 1 TO UBOUND(PreviewControls)
                SELECT CASE PreviewControls(i).Type
                    CASE 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 14, 15
                        j = j + 1
                        zOrderIDs(j) = i
                        AddItem ControlList, __UI_Type(PreviewControls(i).Type).Name + RTRIM$(PreviewControls(i).Name)
                END SELECT
            NEXT
            IF Moving THEN RETURN
            Control(DialogBG).Left = 0: Control(DialogBG).Top = 0
            Control(ZOrdering).Left = 68: Control(ZOrdering).Top = 70
            __UI_Focus = ControlList
            ZOrderingDialogOpen = True
        CASE "CLOSEZORDERINGBT"
            Control(DialogBG).Left = -500: Control(DialogBG).Top = -600
            Control(ZOrdering).Left = -500: Control(ZOrdering).Top = -600
            __UI_Focus = 0
            ZOrderingDialogOpen = False
        CASE "UPBT"
            DIM PrevListValue AS LONG
            PrevListValue = Control(ControlList).Value
            b$ = MKL$(zOrderIDs(Control(ControlList).Value)) + MKL$(zOrderIDs(Control(ControlList).Value - 1))
            SendData b$, 211
            _DELAY .1
            LoadPreview
            Moving = True: GOSUB ReloadZList
            Moving = False
            Control(ControlList).Value = PrevListValue - 1
            __UI_Focus = ControlList
            __UI_ValueChanged ControlList
        CASE "DOWNBT"
            PrevListValue = Control(ControlList).Value
            b$ = MKL$(zOrderIDs(Control(ControlList).Value)) + MKL$(zOrderIDs(Control(ControlList).Value + 1))
            SendData b$, 212
            _DELAY .1
            LoadPreview
            Moving = True: GOSUB ReloadZList
            Moving = False
            Control(ControlList).Value = PrevListValue + 1
            __UI_Focus = ControlList
            __UI_ValueChanged ControlList
        CASE "FILEMENUOPEN"
            IF Edited THEN
                $IF WIN THEN
                    Answer = MessageBox("Save the current form?", "", MsgBox_YesNoCancel + MsgBox_Question)
                $ELSE
                    Answer = MessageBox("Save the current form?", "", MsgBox_YesNo + MsgBox_Question)
                $END IF
                IF Answer = MsgBox_Cancel THEN
                    EXIT SUB
                ELSEIF Answer = MsgBox_Yes THEN
                    SaveForm False, False
                END IF
            END IF

            'Hide the preview
            SendSignal -2

            'Refresh the file list control's contents
            DIM TotalFiles%
            IF CurrentPath$ = "" THEN CurrentPath$ = _CWD$
            Text(FileList) = idezfilelist$(CurrentPath$, 0, TotalFiles%)
            Control(FileList).Max = TotalFiles%
            Control(FileList).LastVisibleItem = 0 'Reset it so it's recalculated

            Control(DialogBG).Left = 0: Control(DialogBG).Top = 0
            Control(OpenFrame).Left = 68: Control(OpenFrame).Top = 70
            OpenDialogOpen = True
            __UI_Focus = FileNameTextBox
            IF LEN(Text(FileNameTextBox)) > 0 THEN
                Control(FileNameTextBox).SelectionStart = 0
                Control(FileNameTextBox).Cursor = LEN(Text(FileNameTextBox))
                Control(FileNameTextBox).TextIsSelected = True
            END IF
            __UI_ForceRedraw = True
        CASE "CANCELBT"
            Text(FileNameTextBox) = ""
            Control(DialogBG).Left = -500: Control(DialogBG).Top = -600
            Control(OpenFrame).Left = -500: Control(OpenFrame).Top = -600
            OpenDialogOpen = False
            'Show the preview
            SendSignal -3

            __UI_Focus = 0
            __UI_ForceRedraw = True
        CASE "OPENBT"
            OpenFile:
            DIM FileToOpen$, FreeFileNum AS INTEGER
            FileToOpen$ = CurrentPath$ + PathSep$ + Text(FileNameTextBox)
            IF _FILEEXISTS(FileToOpen$) THEN
                FreeFileNum = FREEFILE
                OPEN "InForm/UiEditor.dat" FOR BINARY AS #FreeFileNum
                'Send the data first, then the signal
                b$ = MKI$(LEN(FileToOpen$)) + FileToOpen$
                PUT #FreeFileNum, OffsetPropertyValue, b$
                CLOSE #FreeFileNum

                SendSignal -4

                Control(DialogBG).Left = -500: Control(DialogBG).Top = -600
                Control(OpenFrame).Left = -500: Control(OpenFrame).Top = -600
                OpenDialogOpen = False
                __UI_Focus = 0
            ELSE
                Answer = MessageBox("File not found.", "", MsgBox_OkOnly + MsgBox_Critical)
            END IF
        CASE "FILELIST"
            Text(FileNameTextBox) = GetItem(FileList, Control(FileList).Value)
            IF Control(FileList).HoveringVScrollbarButton = 0 AND LastClickedID = id AND TIMER - LastClick# < .3 THEN 'Double click
                GOTO OpenFile
            END IF
        CASE "DIRLIST"
            Text(FileNameTextBox) = GetItem(DirList, Control(DirList).Value)
            IF LastClickedID = id AND TIMER - LastClick# < .3 THEN 'Double click
                CurrentPath$ = idezchangepath(CurrentPath$, Text(FileNameTextBox))
                Caption(PathLB) = "Path: " + CurrentPath$
                Text(DirList) = idezpathlist$(CurrentPath$, TotalFiles%)
                Control(DirList).Max = TotalFiles%
                Control(DirList).LastVisibleItem = 0 'Reset it so it's recalculated
                GOTO ReloadList
            END IF
        CASE "SHOWONLYFRMBINFILESCB"
            ReloadList:
            IF Control(ShowOnlyFrmbinFilesCB).Value THEN
                Text(FileList) = idezfilelist$(CurrentPath$, 0, TotalFiles%)
                Control(FileList).Max = TotalFiles%
                Control(FileList).LastVisibleItem = 0 'Reset it so it's recalculated
            ELSE
                Text(FileList) = idezfilelist$(CurrentPath$, 1, TotalFiles%)
                Control(FileList).Max = TotalFiles%
                Control(FileList).LastVisibleItem = 0 'Reset it so it's recalculated
            END IF
        CASE "EDITMENUUNDO"
            b$ = MKI$(0)
            SendData b$, 214
        CASE "EDITMENUREDO"
            b$ = MKI$(0)
            SendData b$, 215
        CASE "EDITMENUCP437"
            b$ = MKL$(437)
            SendData b$, 34 'Encoding
        CASE "EDITMENUCP1252"
            b$ = MKL$(1252)
            SendData b$, 34 'Encoding
        CASE "VIEWMENUSHOWPOSITIONANDSIZE"
            __UI_ShowPositionAndSize = NOT __UI_ShowPositionAndSize
            Control(id).Value = __UI_ShowPositionAndSize
            SaveSettings
    END SELECT

    LastClickedID = id
    LastClick# = TIMER
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
    SELECT CASE UCASE$(RTRIM$(Control(id).Name))
        CASE "RED", "GREEN", "BLUE"
            'Compose a new color and send it to the preview
            DIM NewColor AS _UNSIGNED LONG
            NewColor = _RGB32(Control(RedTrackID).Value, Control(GreenTrackID).Value, Control(BlueTrackID).Value)
            b$ = _MK$(_UNSIGNED LONG, NewColor)
            SendData b$, Control(ColorPropertiesListID).Value + 22
    END SELECT
END SUB

SUB __UI_BeforeUpdateDisplay
    DIM b$, PreviewChanged AS _BYTE, SelectedProperty AS INTEGER, UiEditorFile AS INTEGER
    DIM PreviewHasMenuActive AS INTEGER, i AS LONG, j AS LONG, Answer AS _BYTE
    STATIC MidRead AS _BYTE, PrevFirstSelected AS LONG

    IF NOT MidRead THEN
        MidRead = True
        UiEditorFile = FREEFILE
        OPEN "InForm/UiEditor.dat" FOR BINARY AS #UiEditorFile

        Reload:
        LoadPreview

        $IF WIN THEN
            IF PreviewAttached THEN
                b$ = MKI$(_SCREENX)
                PUT #UiEditorFile, OffsetWindowLeft, b$

                b$ = MKI$(_SCREENY)
                PUT #UiEditorFile, OffsetWindowTop, b$
            ELSE
                b$ = MKI$(-32001)
                PUT #UiEditorFile, OffsetWindowLeft, b$
                PUT #UiEditorFile, OffsetWindowTop, b$
            END IF
        $ELSE
            IF PreviewAttached = True THEN
            PreviewAttached = False
            SaveSettings
            END IF
            Control(__UI_GetID("VIEWMENUPREVIEWDETACH")).Disabled = True
            Control(__UI_GetID("VIEWMENUPREVIEWDETACH")).Value = False
        $END IF

        b$ = MKI$(AutoNameControls)
        PUT #UiEditorFile, OffsetAutoName, b$

        b$ = MKI$(__UI_MouseButtonsSwap)
        PUT #UiEditorFile, OffsetMouseSwapped, b$

        b$ = MKI$(__UI_ShowPositionAndSize)
        PUT #UiEditorFile, OffsetShowPosSize, b$

        b$ = MKI$(__UI_SnapLines)
        PUT #UiEditorFile, OffsetSnapLines, b$

        b$ = SPACE$(2): GET #UiEditorFile, OffsetNewDataFromPreview, b$
        IF CVI(b$) = -1 OR CVI(b$) = -3 THEN
            'Controls in the editor lose focus when the preview is manipulated
            IF CVI(b$) = -1 THEN Edited = True
            IF __UI_ActiveDropdownList > 0 THEN __UI_DestroyControl Control(__UI_ActiveDropdownList)
            IF __UI_ActiveMenu = 0 THEN __UI_Focus = 0
            __UI_ForceRedraw = True
        ELSEIF CVI(b$) = -2 THEN
            'User attempted to right-click a control but the preview
            'form is smaller than the menu panel. In such case the "Align"
            'menu is shown in the editor.
            IF ZOrderingDialogOpen THEN __UI_Click CloseZOrderingBT
            __UI_ActivateMenu Control(__UI_GetID("AlignMenu")), False
            __UI_ForceRedraw = True
        ELSEIF CVI(b$) = -4 THEN
            'User attempted to load an icon file that couldn't be previewed
            Answer = MessageBox("Icon couldn't be previewed. Make sure it's a valid icon file.", "", MsgBox_OkOnly + MsgBox_Exclamation)
        ELSEIF CVI(b$) = -5 THEN
            'Context menu was successfully shown on the preview
            IF __UI_ActiveMenu > 0 THEN __UI_DestroyControl Control(__UI_ActiveMenu)
            __UI_Focus = 0
            __UI_ForceRedraw = True
        ELSEIF CVI(b$) = -6 THEN
            'User attempted to load an invalid icon file
            Answer = MessageBox("Only .ico files are accepted.", "", MsgBox_OkOnly + MsgBox_Exclamation)
        END IF
        b$ = MKI$(0): PUT #UiEditorFile, OffsetNewDataFromPreview, b$

        b$ = SPACE$(4): GET #UiEditorFile, OffsetTotalControlsSelected, b$
        TotalSelected = CVL(b$)
        b$ = SPACE$(4): GET #UiEditorFile, OffsetFormID, b$
        PreviewFormID = CVL(b$)
        b$ = SPACE$(4): GET #UiEditorFile, OffsetFirstSelectedID, b$
        FirstSelected = CVL(b$)

        IF FirstSelected > UBOUND(PreviewCaptions) THEN GOTO Reload

        IF PrevFirstSelected <> FirstSelected THEN
            PrevFirstSelected = FirstSelected
            __UI_ForceRedraw = True

            IF ZOrderingDialogOpen AND FirstSelected <> PreviewFormID THEN
                FOR j = 1 TO UBOUND(zOrderIDs)
                    IF zOrderIDs(j) = FirstSelected THEN Control(ControlList).Value = j: __UI_ValueChanged ControlList: EXIT FOR
                NEXT
            END IF
        END IF
        b$ = SPACE$(2): GET #UiEditorFile, OffsetMenuPanelIsON, b$
        PreviewHasMenuActive = CVI(b$)

        IF LEN(RTRIM$(__UI_TrimAt0$(PreviewControls(PreviewFormID).Name))) > 0 THEN
            Caption(__UI_FormID) = UiEditorTitle$ + " - " + RTRIM$(PreviewControls(PreviewFormID).Name) + ".frmbin"
            SetCaption __UI_GetID("FileMenuSaveFrm"), "&Save form only ('" + RTRIM$(PreviewControls(PreviewFormID).Name) + ".frmbin')-"
        END IF

        IF Edited THEN
            IF RIGHT$(Caption(__UI_FormID), 1) <> "*" THEN Caption(__UI_FormID) = Caption(__UI_FormID) + "*"
        END IF

        SelectedProperty = Control(__UI_GetID("PropertiesList")).Value

        'Ctrl+Z? Ctrl+Y?
        Control(EditMenuUndo).Disabled = True
        Control(EditMenuRedo).Disabled = True
        DIM BinFileNum AS INTEGER, UndoPointer AS INTEGER, TotalUndoImages AS INTEGER
        BinFileNum = FREEFILE
        OPEN "InForm/UiEditorUndo.dat" FOR BINARY AS #BinFileNum
        IF LOF(BinFileNum) > 0 THEN
            b$ = SPACE$(2): GET #BinFileNum, 1, b$: UndoPointer = CVI(b$)
            b$ = SPACE$(2): GET #BinFileNum, 3, b$: TotalUndoImages = CVI(b$)
        END IF
        CLOSE #BinFileNum
        IF UndoPointer > 2 THEN Control(EditMenuUndo).Disabled = False
        IF UndoPointer < TotalUndoImages THEN Control(EditMenuRedo).Disabled = False

        IF (__UI_KeyHit = ASC("z") OR __UI_KeyHit = ASC("Z")) AND __UI_CtrlIsDown THEN
            b$ = MKI$(0)
            SendData b$, 214
        ELSEIF (__UI_KeyHit = ASC("y") OR __UI_KeyHit = ASC("Y")) AND __UI_CtrlIsDown THEN
            b$ = MKI$(0)
            SendData b$, 215
        END IF

        'Make ZOrdering menu enabled/disabled according to control list
        Control(__UI_GetID("EditMenuZOrdering")).Disabled = True
        FOR i = 1 TO UBOUND(PreviewControls)
            SELECT CASE PreviewControls(i).Type
                CASE 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 14, 15
                    j = j + 1
                    IF j > 1 THEN
                        Control(__UI_GetID("EditMenuZOrdering")).Disabled = False
                        EXIT FOR
                    END IF
            END SELECT
        NEXT

        Control(__UI_GetID("EDITMENUCP1252")).Value = False
        Control(__UI_GetID("EDITMENUCP437")).Value = False
        SELECT CASE PreviewControls(PreviewFormID).Encoding
            CASE 0, 437
                Control(__UI_GetID("EDITMENUCP437")).Value = True
            CASE 1252
                Control(__UI_GetID("EDITMENUCP1252")).Value = True
        END SELECT

        IF PreviewHasMenuActive THEN
            Control(__UI_GetID("InsertMenuMenuItem")).Disabled = False
        ELSE
            Control(__UI_GetID("InsertMenuMenuItem")).Disabled = True
        END IF

        IF TotalSelected = 0 THEN
            SetCaption __UI_GetID("PropertiesFrame"), "Control properties: " + RTRIM$(PreviewControls(PreviewFormID).Name)
            FirstSelected = PreviewFormID

            Control(__UI_GetID("AlignMenuAlignLeft")).Disabled = True
            Control(__UI_GetID("AlignMenuAlignRight")).Disabled = True
            Control(__UI_GetID("AlignMenuAlignTops")).Disabled = True
            Control(__UI_GetID("AlignMenuAlignBottoms")).Disabled = True
            Control(__UI_GetID("AlignMenuAlignCenterV")).Disabled = True
            Control(__UI_GetID("AlignMenuAlignCenterH")).Disabled = True
            Control(__UI_GetID("AlignMenuAlignCentersV")).Disabled = True
            Control(__UI_GetID("AlignMenuAlignCentersH")).Disabled = True
            Control(__UI_GetID("AlignMenuDistributeV")).Disabled = True
            Control(__UI_GetID("AlignMenuDistributeH")).Disabled = True

        ELSEIF TotalSelected = 1 THEN
            IF FirstSelected > 0 AND FirstSelected <= UBOUND(PreviewControls) THEN
                SetCaption __UI_GetID("PropertiesFrame"), "Control properties: " + RTRIM$(PreviewControls(FirstSelected).Name)

                Control(__UI_GetID("AlignMenuAlignLeft")).Disabled = True
                Control(__UI_GetID("AlignMenuAlignRight")).Disabled = True
                Control(__UI_GetID("AlignMenuAlignTops")).Disabled = True
                Control(__UI_GetID("AlignMenuAlignBottoms")).Disabled = True
                IF PreviewControls(FirstSelected).Type <> __UI_Type_MenuBar AND PreviewControls(FirstSelected).Type <> __UI_Type_MenuItem THEN
                    Control(__UI_GetID("AlignMenuAlignCenterV")).Disabled = False
                    Control(__UI_GetID("AlignMenuAlignCenterH")).Disabled = False
                ELSE
                    Control(__UI_GetID("AlignMenuAlignCenterV")).Disabled = True
                    Control(__UI_GetID("AlignMenuAlignCenterH")).Disabled = True
                END IF
                Control(__UI_GetID("AlignMenuAlignCentersV")).Disabled = True
                Control(__UI_GetID("AlignMenuAlignCentersH")).Disabled = True
                Control(__UI_GetID("AlignMenuDistributeV")).Disabled = True
                Control(__UI_GetID("AlignMenuDistributeH")).Disabled = True

            END IF

        ELSEIF TotalSelected = 2 THEN
            SetCaption __UI_GetID("PropertiesFrame"), "Control properties: (multiple selection)"

            Control(__UI_GetID("AlignMenuAlignLeft")).Disabled = False
            Control(__UI_GetID("AlignMenuAlignRight")).Disabled = False
            Control(__UI_GetID("AlignMenuAlignTops")).Disabled = False
            Control(__UI_GetID("AlignMenuAlignBottoms")).Disabled = False
            Control(__UI_GetID("AlignMenuAlignCenterV")).Disabled = False
            Control(__UI_GetID("AlignMenuAlignCenterH")).Disabled = False
            Control(__UI_GetID("AlignMenuAlignCentersV")).Disabled = False
            Control(__UI_GetID("AlignMenuAlignCentersH")).Disabled = False
            Control(__UI_GetID("AlignMenuDistributeV")).Disabled = True
            Control(__UI_GetID("AlignMenuDistributeH")).Disabled = True

        ELSE
            SetCaption __UI_GetID("PropertiesFrame"), "Control properties: (multiple selection)"

            Control(__UI_GetID("AlignMenuAlignLeft")).Disabled = False
            Control(__UI_GetID("AlignMenuAlignRight")).Disabled = False
            Control(__UI_GetID("AlignMenuAlignTops")).Disabled = False
            Control(__UI_GetID("AlignMenuAlignBottoms")).Disabled = False
            Control(__UI_GetID("AlignMenuAlignCenterV")).Disabled = False
            Control(__UI_GetID("AlignMenuAlignCenterH")).Disabled = False
            Control(__UI_GetID("AlignMenuAlignCentersV")).Disabled = False
            Control(__UI_GetID("AlignMenuAlignCentersH")).Disabled = False
            Control(__UI_GetID("AlignMenuDistributeV")).Disabled = False
            Control(__UI_GetID("AlignMenuDistributeH")).Disabled = False

        END IF

        IF FirstSelected = 0 THEN FirstSelected = PreviewFormID

        Control(PropertyValueID).Max = 0 '0 means the length won't be capped.

        IF __UI_Focus <> PropertyValueID AND FirstSelected > 0 THEN
            Control(PropertyValueID).Width = 250

            SELECT CASE SelectedProperty
                CASE 1 'Name
                    Text(PropertyValueID) = RTRIM$(PreviewControls(FirstSelected).Name)
                CASE 2 'Caption
                    Text(PropertyValueID) = Replace(__UI_TrimAt0$(PreviewCaptions(FirstSelected)), CHR$(10), "\n", False, 0)
                CASE 3 'Text
                    IF PreviewControls(FirstSelected).Type = __UI_Type_ListBox OR PreviewControls(FirstSelected).Type = __UI_Type_DropdownList THEN
                        Text(PropertyValueID) = Replace(PreviewTexts(FirstSelected), CHR$(13), "\n", False, 0)
                    ELSE
                        Text(PropertyValueID) = PreviewTexts(FirstSelected)
                    END IF
                CASE 4 'Top
                    Text(PropertyValueID) = LTRIM$(STR$(PreviewControls(FirstSelected).Top))
                CASE 5 'Left
                    Text(PropertyValueID) = LTRIM$(STR$(PreviewControls(FirstSelected).Left))
                CASE 6 'Width
                    Text(PropertyValueID) = LTRIM$(STR$(PreviewControls(FirstSelected).Width))
                CASE 7 'Height
                    Text(PropertyValueID) = LTRIM$(STR$(PreviewControls(FirstSelected).Height))
                CASE 8 'Font
                    IF LEN(PreviewFonts(FirstSelected)) > 0 THEN
                        Text(PropertyValueID) = PreviewFonts(FirstSelected)
                    ELSE
                        Text(PropertyValueID) = PreviewFonts(PreviewFormID)
                    END IF
                CASE 9 'Tooltip
                    Text(PropertyValueID) = Replace(PreviewTips(FirstSelected), CHR$(10), "\n", False, 0)
                CASE 10 'Value
                    Text(PropertyValueID) = LTRIM$(STR$(PreviewControls(FirstSelected).Value))
                CASE 11 'Min
                    Text(PropertyValueID) = LTRIM$(STR$(PreviewControls(FirstSelected).Min))
                CASE 12 'Max
                    Text(PropertyValueID) = LTRIM$(STR$(PreviewControls(FirstSelected).Max))
                CASE 13 'Interval
                    Text(PropertyValueID) = LTRIM$(STR$(PreviewControls(FirstSelected).Interval))
                CASE 14 'Padding
                    Text(PropertyValueID) = LTRIM$(STR$(PreviewControls(FirstSelected).Padding))
            END SELECT
            Control(PropertyUpdateStatusID).Hidden = True
        ELSEIF FirstSelected > 0 THEN
            __UI_CursorAdjustments PropertyValueID
            DIM PropertyAccept AS _BYTE
            SELECT CASE SelectedProperty
                CASE 1 'Name
                    IF LCASE$(Text(PropertyValueID)) = LCASE$(RTRIM$(PreviewControls(FirstSelected).Name)) THEN PropertyAccept = True
                CASE 2 'Caption
                    IF Replace(Text(PropertyValueID), "\n", CHR$(10), False, 0) = PreviewCaptions(FirstSelected) THEN PropertyAccept = True
                CASE 3 'Text
                    IF PreviewControls(FirstSelected).Type = __UI_Type_ListBox OR PreviewControls(FirstSelected).Type = __UI_Type_DropdownList THEN
                        IF Replace(Text(PropertyValueID), "\n", CHR$(13), False, 0) = PreviewTexts(FirstSelected) THEN PropertyAccept = True
                    ELSE
                        IF Text(PropertyValueID) = PreviewTexts(FirstSelected) THEN PropertyAccept = True
                    END IF
                CASE 4 'Top
                    IF Text(PropertyValueID) = LTRIM$(STR$(PreviewControls(FirstSelected).Top)) THEN PropertyAccept = True
                CASE 5 'Left
                    IF Text(PropertyValueID) = LTRIM$(STR$(PreviewControls(FirstSelected).Left)) THEN PropertyAccept = True
                CASE 6 'Width
                    IF Text(PropertyValueID) = LTRIM$(STR$(PreviewControls(FirstSelected).Width)) THEN PropertyAccept = True
                CASE 7 'Height
                    IF Text(PropertyValueID) = LTRIM$(STR$(PreviewControls(FirstSelected).Height)) THEN PropertyAccept = True
                CASE 8 'Font
                    IF LEN(PreviewFonts(FirstSelected)) > 0 THEN
                        IF LCASE$(Text(PropertyValueID)) = LCASE$(PreviewFonts(FirstSelected)) THEN PropertyAccept = True
                    ELSE
                        IF LCASE$(Text(PropertyValueID)) = LCASE$(PreviewFonts(PreviewFormID)) THEN PropertyAccept = True
                    END IF
                CASE 9 'Tooltip
                    IF Replace(Text(PropertyValueID), "\n", CHR$(10), False, 0) = PreviewTips(FirstSelected) THEN PropertyAccept = True
                CASE 10 'Value
                    IF Text(PropertyValueID) = LTRIM$(STR$(PreviewControls(FirstSelected).Value)) THEN PropertyAccept = True
                CASE 11 'Min
                    IF Text(PropertyValueID) = LTRIM$(STR$(PreviewControls(FirstSelected).Min)) THEN PropertyAccept = True
                CASE 12 'Max
                    IF Text(PropertyValueID) = LTRIM$(STR$(PreviewControls(FirstSelected).Max)) THEN PropertyAccept = True
                CASE 13 'Interval
                    IF Text(PropertyValueID) = LTRIM$(STR$(PreviewControls(FirstSelected).Interval)) THEN PropertyAccept = True
                CASE 14 'Padding
                    IF Text(PropertyValueID) = LTRIM$(STR$(PreviewControls(FirstSelected).Padding)) THEN PropertyAccept = True
            END SELECT
            Control(PropertyValueID).Width = 225
            Control(PropertyUpdateStatusID).Hidden = False
            _DEST Control(PropertyUpdateStatusID).HelperCanvas
            CLS , _RGBA32(0, 0, 0, 0)
            IF PropertyAccept AND LEN(RTRIM$(Text(PropertyValueID))) > 0 THEN
                _PUTIMAGE (0, 0), PropertyUpdateStatusImage, , (0, 0)-STEP(15, 15)
                ToolTip(__UI_GetID("PropertyUpdateStatus")) = "The property value entered was accepted"
            ELSEIF LEN(RTRIM$(Text(PropertyValueID))) > 0 THEN
                IF TIMER - LastKeyPress > .5 THEN
                    _PUTIMAGE (0, 0), PropertyUpdateStatusImage, , (0, 16)-STEP(15, 15)
                    ToolTip(__UI_GetID("PropertyUpdateStatus")) = "Property value not accepted"
                ELSE
                    _PUTIMAGE (0, 0), PropertyUpdateStatusImage, , (0, 32)-STEP(15, 15)
                    ToolTip(__UI_GetID("PropertyUpdateStatus")) = ""
                END IF
            END IF
            _DEST 0
            Control(PropertyUpdateStatusID).PreviousValue = 0 'Force update
        END IF

        IF PreviewControls(FirstSelected).Type = __UI_Type_TextBox AND SelectedProperty = 3 THEN
            Control(PropertyValueID).Max = PreviewControls(FirstSelected).Max
        END IF

        'Update checkboxes:
        Control(__UI_GetID("Stretch")).Value = PreviewControls(FirstSelected).Stretch
        Control(__UI_GetID("HasBorder")).Value = PreviewControls(FirstSelected).HasBorder
        Control(__UI_GetID("ShowPercentage")).Value = PreviewControls(FirstSelected).ShowPercentage
        Control(__UI_GetID("WordWrap")).Value = PreviewControls(FirstSelected).WordWrap
        Control(__UI_GetID("CanHaveFocus")).Value = PreviewControls(FirstSelected).CanHaveFocus
        Control(__UI_GetID("Disabled")).Value = PreviewControls(FirstSelected).Disabled
        Control(__UI_GetID("Hidden")).Value = PreviewControls(FirstSelected).Hidden
        Control(__UI_GetID("CenteredWindow")).Value = PreviewControls(FirstSelected).CenteredWindow
        Control(__UI_GetID("PasswordMaskCB")).Value = PreviewControls(FirstSelected).PasswordField
        Control(__UI_GetID("AlignOptions")).Value = PreviewControls(FirstSelected).Align + 1
        Control(__UI_GetID("VAlignOptions")).Value = PreviewControls(FirstSelected).VAlign + 1
        Control(__UI_GetID("Transparent")).Value = PreviewControls(FirstSelected).BackStyle
        Control(__UI_GetID("Resizable")).Value = PreviewControls(FirstSelected).CanResize

        'Disable properties that don't apply
        Control(__UI_GetID("Stretch")).Disabled = True
        Control(__UI_GetID("HasBorder")).Disabled = True
        Control(__UI_GetID("ShowPercentage")).Disabled = True
        Control(__UI_GetID("WordWrap")).Disabled = True
        Control(__UI_GetID("CanHaveFocus")).Disabled = True
        Control(__UI_GetID("Disabled")).Disabled = True
        Control(__UI_GetID("Hidden")).Disabled = True
        Control(__UI_GetID("CenteredWindow")).Disabled = True
        Control(__UI_GetID("PasswordMaskCB")).Disabled = True
        Control(__UI_GetID("AlignOptions")).Disabled = True
        Control(__UI_GetID("VAlignOptions")).Disabled = True
        Control(__UI_GetID("Transparent")).Disabled = True
        ReplaceItem __UI_GetID("PropertiesList"), 3, "Text"
        Control(__UI_GetID("Resizable")).Disabled = True
        Caption(PropertyValueID) = ""
        IF TotalSelected > 0 THEN
            SELECT EVERYCASE PreviewControls(FirstSelected).Type
                CASE __UI_Type_MenuBar, __UI_Type_MenuItem
                    Control(__UI_GetID("Disabled")).Disabled = False
                    Control(__UI_GetID("Hidden")).Disabled = False
                CASE __UI_Type_MenuBar
                    'Check if this is the last menu bar item so that Align options can be enabled
                    FOR i = UBOUND(PreviewControls) TO 1 STEP -1
                        IF PreviewControls(i).ID > 0 AND PreviewControls(i).Type = __UI_Type_MenuBar THEN
                            EXIT FOR
                        END IF
                    NEXT
                    IF i = FirstSelected THEN
                        Control(__UI_GetID("AlignOptions")).Disabled = False
                    END IF
                    SELECT CASE SelectedProperty
                        CASE 1, 2, 9
                            Control(PropertyValueID).Disabled = False
                        CASE ELSE
                            Control(PropertyValueID).Disabled = True
                    END SELECT
                CASE __UI_Type_MenuItem
                    SELECT CASE SelectedProperty
                        CASE 1, 2, 3, 9, 10
                            Control(PropertyValueID).Disabled = False
                        CASE ELSE
                            Control(PropertyValueID).Disabled = True
                    END SELECT
                CASE __UI_Type_PictureBox
                    ReplaceItem __UI_GetID("PropertiesList"), 3, "Image file"
                    Control(__UI_GetID("AlignOptions")).Disabled = False
                    Control(__UI_GetID("VAlignOptions")).Disabled = False
                    Control(__UI_GetID("Stretch")).Disabled = False
                    Control(__UI_GetID("Transparent")).Disabled = False
                    SELECT CASE SelectedProperty
                        CASE 1, 3, 4, 5, 6, 7, 9
                            Control(PropertyValueID).Disabled = False
                        CASE ELSE
                            Control(PropertyValueID).Disabled = True
                    END SELECT
                CASE __UI_Type_Frame, __UI_Type_Label
                    Control(__UI_GetID("Transparent")).Disabled = False
                    SELECT CASE SelectedProperty
                        CASE 1, 2, 4, 5, 6, 7, 8, 9, 14
                            Control(PropertyValueID).Disabled = False
                        CASE ELSE
                            Control(PropertyValueID).Disabled = True
                    END SELECT
                CASE __UI_Type_TextBox
                    Control(__UI_GetID("Transparent")).Disabled = False
                    Control(__UI_GetID("PasswordMaskCB")).Disabled = False
                    SELECT CASE SelectedProperty
                        CASE 1, 2, 3, 4, 5, 6, 7, 8, 9, 12
                            Control(PropertyValueID).Disabled = False
                        CASE ELSE
                            Control(PropertyValueID).Disabled = True
                    END SELECT
                CASE __UI_Type_Button, __UI_Type_MenuItem
                    ReplaceItem __UI_GetID("PropertiesList"), 3, "Image file"
                CASE __UI_Type_Button
                    SELECT CASE SelectedProperty
                        CASE 1, 2, 3, 4, 5, 6, 7, 8, 9
                            Control(PropertyValueID).Disabled = False
                        CASE ELSE
                            Control(PropertyValueID).Disabled = True
                    END SELECT
                CASE __UI_Type_CheckBox, __UI_Type_RadioButton
                    Control(__UI_GetID("Transparent")).Disabled = False
                    SELECT CASE SelectedProperty
                        CASE 1, 2, 4, 5, 6, 7, 8, 9, 10
                            Control(PropertyValueID).Disabled = False
                        CASE ELSE
                            Control(PropertyValueID).Disabled = True
                    END SELECT
                CASE __UI_Type_ProgressBar
                    SELECT CASE SelectedProperty
                        CASE 1, 2, 4, 5, 6, 7, 8, 9, 10, 11, 12
                            Control(PropertyValueID).Disabled = False
                        CASE ELSE
                            Control(PropertyValueID).Disabled = True
                    END SELECT
                CASE __UI_Type_TrackBar
                    SELECT CASE SelectedProperty
                        CASE 1, 4, 5, 6, 7, 9, 10, 11, 12, 13
                            Control(PropertyValueID).Disabled = False
                        CASE ELSE
                            Control(PropertyValueID).Disabled = True
                    END SELECT
                CASE __UI_Type_ListBox, __UI_Type_DropdownList
                    ReplaceItem __UI_GetID("PropertiesList"), 3, "List items"
                    Control(__UI_GetID("Transparent")).Disabled = False
                    SELECT CASE SelectedProperty
                        CASE 1, 3, 4, 5, 6, 7, 8, 9, 10, 12
                            Control(PropertyValueID).Disabled = False
                        CASE ELSE
                            Control(PropertyValueID).Disabled = True
                    END SELECT
                CASE __UI_Type_Frame, __UI_Type_Label, __UI_Type_TextBox, __UI_Type_ListBox, __UI_Type_DropdownList, __UI_Type_PictureBox
                    Control(__UI_GetID("HasBorder")).Disabled = False
                CASE __UI_Type_ProgressBar
                    Control(__UI_GetID("ShowPercentage")).Disabled = False
                CASE __UI_Type_Label
                    Control(__UI_GetID("WordWrap")).Disabled = False
                CASE __UI_Type_Button, __UI_Type_CheckBox, __UI_Type_RadioButton, __UI_Type_TextBox, __UI_Type_ListBox, __UI_Type_DropdownList, __UI_Type_TrackBar
                    Control(__UI_GetID("CanHaveFocus")).Disabled = False
                CASE __UI_Type_Button, __UI_Type_CheckBox, __UI_Type_RadioButton, __UI_Type_TextBox, __UI_Type_ListBox, __UI_Type_DropdownList, __UI_Type_TrackBar, __UI_Type_Label, __UI_Type_ProgressBar
                    Control(__UI_GetID("Disabled")).Disabled = False
                CASE __UI_Type_Frame, __UI_Type_Button, __UI_Type_CheckBox, __UI_Type_RadioButton, __UI_Type_TextBox, __UI_Type_ListBox, __UI_Type_DropdownList, __UI_Type_TrackBar, __UI_Type_Label, __UI_Type_ProgressBar, __UI_Type_PictureBox
                    Control(__UI_GetID("Hidden")).Disabled = False
                CASE __UI_Type_Label
                    Control(__UI_GetID("AlignOptions")).Disabled = False
                    Control(__UI_GetID("VAlignOptions")).Disabled = False
            END SELECT
        ELSE
            'Properties relative to the form
            Control(__UI_GetID("CenteredWindow")).Disabled = False
            Control(__UI_GetID("Resizable")).Disabled = False
            ReplaceItem __UI_GetID("PropertiesList"), 3, "Icon"

            SELECT CASE SelectedProperty
                CASE 1, 2, 3, 6, 7, 8 'Name, Caption, Width, Height, Font
                    Control(PropertyValueID).Disabled = False
                CASE ELSE
                    Control(PropertyValueID).Disabled = True
            END SELECT
        END IF

        IF Control(PropertyValueID).Disabled THEN
            Text(PropertyValueID) = ""
            Caption(PropertyValueID) = "Property not available"
        END IF

        'Update the color mixer
        DIM ThisColor AS _UNSIGNED LONG, ThisBackColor AS _UNSIGNED LONG

        SELECT EVERYCASE Control(ColorPropertiesListID).Value
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
                    Control(RedTrackID).Value = _RED32(ThisColor)
                    Text(RedTextBoxID) = LTRIM$(STR$(Control(RedTrackID).Value))
                END IF
                IF __UI_Focus <> GreenTrackID AND __UI_Focus <> GreenTextBoxID THEN
                    Control(GreenTrackID).Value = _GREEN32(ThisColor)
                    Text(GreenTextBoxID) = LTRIM$(STR$(Control(GreenTrackID).Value))
                END IF
                IF __UI_Focus <> BlueTrackID AND __UI_Focus <> BlueTextBoxID THEN
                    Control(BlueTrackID).Value = _BLUE32(ThisColor)
                    Text(BlueTextBoxID) = LTRIM$(STR$(Control(BlueTrackID).Value))
                END IF
            CASE 2, 4
                IF __UI_Focus <> RedTrackID AND __UI_Focus <> RedTextBoxID THEN
                    Control(RedTrackID).Value = _RED32(ThisBackColor)
                    Text(RedTextBoxID) = LTRIM$(STR$(Control(RedTrackID).Value))
                END IF
                IF __UI_Focus <> GreenTrackID AND __UI_Focus <> GreenTextBoxID THEN
                    Control(GreenTrackID).Value = _GREEN32(ThisBackColor)
                    Text(GreenTextBoxID) = LTRIM$(STR$(Control(GreenTrackID).Value))
                END IF
                IF __UI_Focus <> BlueTrackID AND __UI_Focus <> BlueTextBoxID THEN
                    Control(BlueTrackID).Value = _BLUE32(ThisBackColor)
                    Text(BlueTextBoxID) = LTRIM$(STR$(Control(BlueTrackID).Value))
                END IF
        END SELECT

        IF Control(__UI_GetID("ColorPreview")).HelperCanvas = 0 THEN
            Control(__UI_GetID("ColorPreview")).HelperCanvas = _NEWIMAGE(Control(__UI_GetID("ColorPreview")).Width, Control(__UI_GetID("ColorPreview")).Height, 32)
        END IF
        STATIC PrevPreviewForeColor AS _UNSIGNED LONG, PrevPreviewBackColor AS _UNSIGNED LONG
        IF PrevPreviewForeColor <> ThisColor OR PrevPreviewBackColor <> ThisBackColor THEN
            PrevPreviewForeColor = ThisColor
            PrevPreviewBackColor = ThisBackColor
            UpdateColorPreview Control(ColorPropertiesListID).Value, ThisColor, ThisBackColor
        END IF

        MidRead = False
        CLOSE #UiEditorFile
    END IF

END SUB

SUB __UI_BeforeUnload
    DIM Answer AS _BYTE
    IF Edited THEN
        $IF WIN THEN
            Answer = MessageBox("Save the current form before leaving?", "", MsgBox_YesNoCancel + MsgBox_Question)
        $ELSE
            Answer = MessageBox("Save the current form before leaving?", "", MsgBox_YesNo + MsgBox_Question)
        $END IF
        IF Answer = MsgBox_Cancel THEN
            __UI_UnloadSignal = False
        ELSEIF Answer = MsgBox_Yes THEN
            SaveForm False, False
        END IF
    END IF
    SaveSettings
END SUB

SUB SaveSettings
    DIM FreeFileNum AS INTEGER, b$

    FreeFileNum = FREEFILE
    IF _DIREXISTS("InForm") = 0 THEN EXIT SUB
    OPEN "InForm/InForm.ini" FOR OUTPUT AS #FreeFileNum
    PRINT #FreeFileNum, "[InForm Settings]"
    PRINT #FreeFileNum, "'This file will be recreated everytime the editor is closed."

    PRINT #FreeFileNum, "Keep preview window attached = ";
    IF PreviewAttached THEN PRINT #FreeFileNum, "True" ELSE PRINT #FreeFileNum, "False"

    PRINT #FreeFileNum, "Auto-name controls = ";
    IF AutoNameControls THEN PRINT #FreeFileNum, "True" ELSE PRINT #FreeFileNum, "False"

    PRINT #FreeFileNum, "Snap to edges = ";
    IF __UI_SnapLines THEN PRINT #FreeFileNum, "True" ELSE PRINT #FreeFileNum, "False"

    PRINT #FreeFileNum, "Show position and size = ";
    IF __UI_ShowPositionAndSize THEN PRINT #FreeFileNum, "True" ELSE PRINT #FreeFileNum, "False"

    $IF WIN THEN
    $ELSE
        PRINT #FreeFileNum, "Swap mouse buttons = ";
        IF __UI_MouseButtonsSwap THEN PRINT #FreeFileNum, "True" ELSE PRINT #FreeFileNum, "False"
    $END IF
    CLOSE #FreeFileNum
END SUB

SUB __UI_BeforeInit
END SUB

SUB __UI_OnLoad
    DIM i AS LONG, b$, UiEditorFile AS INTEGER

    'LoadFontList

    'Load toolbox images:
    DIM CommControls AS LONG
    CommControls = LoadEditorImage("commoncontrols.bmp")
    __UI_ClearColor CommControls, 0, 0

    Control(__UI_GetID("AddButton")).HelperCanvas = _NEWIMAGE(16, 16, 32)
    i = i + 1: _PUTIMAGE (0, 0), CommControls, Control(__UI_GetID("AddButton")).HelperCanvas, (0, i * 16 - 16)-STEP(15, 15)
    Control(__UI_GetID("AddLabel")).HelperCanvas = _NEWIMAGE(16, 16, 32)
    i = i + 1: _PUTIMAGE (0, 0), CommControls, Control(__UI_GetID("AddLabel")).HelperCanvas, (0, i * 16 - 16)-STEP(15, 15)
    Control(__UI_GetID("AddTextBox")).HelperCanvas = _NEWIMAGE(16, 16, 32)
    i = i + 1: _PUTIMAGE (0, 0), CommControls, Control(__UI_GetID("AddTextBox")).HelperCanvas, (0, i * 16 - 16)-STEP(15, 15)
    Control(__UI_GetID("AddCheckBox")).HelperCanvas = _NEWIMAGE(16, 16, 32)
    i = i + 1: _PUTIMAGE (0, 0), CommControls, Control(__UI_GetID("AddCheckBox")).HelperCanvas, (0, i * 16 - 16)-STEP(15, 15)
    Control(__UI_GetID("AddRadioButton")).HelperCanvas = _NEWIMAGE(16, 16, 32)
    i = i + 1: _PUTIMAGE (0, 0), CommControls, Control(__UI_GetID("AddRadioButton")).HelperCanvas, (0, i * 16 - 16)-STEP(15, 15)
    Control(__UI_GetID("AddListBox")).HelperCanvas = _NEWIMAGE(16, 16, 32)
    i = i + 1: _PUTIMAGE (0, 0), CommControls, Control(__UI_GetID("AddListBox")).HelperCanvas, (0, i * 16 - 16)-STEP(15, 15)
    Control(__UI_GetID("AddDropdownList")).HelperCanvas = _NEWIMAGE(16, 16, 32)
    i = i + 1: _PUTIMAGE (0, 0), CommControls, Control(__UI_GetID("AddDropdownList")).HelperCanvas, (0, i * 16 - 16)-STEP(15, 15)
    Control(__UI_GetID("AddTrackBar")).HelperCanvas = _NEWIMAGE(16, 16, 32)
    i = i + 1: _PUTIMAGE (0, 0), CommControls, Control(__UI_GetID("AddTrackBar")).HelperCanvas, (0, i * 16 - 16)-STEP(15, 15)
    Control(__UI_GetID("AddProgressBar")).HelperCanvas = _NEWIMAGE(16, 16, 32)
    i = i + 1: _PUTIMAGE (0, 0), CommControls, Control(__UI_GetID("AddProgressBar")).HelperCanvas, (0, i * 16 - 16)-STEP(15, 15)
    Control(__UI_GetID("AddPictureBox")).HelperCanvas = _NEWIMAGE(16, 16, 32)
    i = i + 1: _PUTIMAGE (0, 0), CommControls, Control(__UI_GetID("AddPictureBox")).HelperCanvas, (0, i * 16 - 16)-STEP(15, 15)
    Control(__UI_GetID("AddFrame")).HelperCanvas = _NEWIMAGE(16, 16, 32)
    i = i + 1: _PUTIMAGE (0, 0), CommControls, Control(__UI_GetID("AddFrame")).HelperCanvas, (0, i * 16 - 16)-STEP(15, 15)

    PropertyUpdateStatusImage = LoadEditorImage("oknowait.bmp")
    __UI_ClearColor PropertyUpdateStatusImage, 0, 0

    Control(__UI_GetID("FileMenuSave")).HelperCanvas = LoadEditorImage("disk.png")

    'Properly loaded helper images assign a file name to the control's text property.
    'Any text will do for internallly stored images:
    Text(__UI_GetID("AddButton")) = "."
    Text(__UI_GetID("AddLabel")) = "."
    Text(__UI_GetID("AddTextBox")) = "."
    Text(__UI_GetID("AddCheckBox")) = "."
    Text(__UI_GetID("AddRadioButton")) = "."
    Text(__UI_GetID("AddListBox")) = "."
    Text(__UI_GetID("AddDropdownList")) = "."
    Text(__UI_GetID("AddTrackBar")) = "."
    Text(__UI_GetID("AddProgressBar")) = "."
    Text(__UI_GetID("AddPictureBox")) = "."
    Text(__UI_GetID("AddFrame")) = "."
    Text(__UI_GetID("FileMenuSave")) = "."

    _FREEIMAGE CommControls

    __UI_ForceRedraw = True

    'Read controls' IDs to avoid repeated calls to __UI_GetID later on
    RedTrackID = __UI_GetID("Red"): RedTextBoxID = __UI_GetID("RedValue")
    GreenTrackID = __UI_GetID("Green"): GreenTextBoxID = __UI_GetID("GreenValue")
    BlueTrackID = __UI_GetID("Blue"): BlueTextBoxID = __UI_GetID("BlueValue")
    ColorPropertiesListID = __UI_GetID("ColorPropertiesList")
    ColorPreviewID = __UI_GetID("ColorPreview")
    PropertyValueID = __UI_GetID("PropertyValue")
    PropertyUpdateStatusID = __UI_GetID("PropertyUpdateStatus")

    Control(__UI_GetID("PropertiesList")).Value = 2

    PreviewAttached = True
    AutoNameControls = True
    __UI_ShowPositionAndSize = True
    __UI_SnapLines = True

    DIM FileToOpen$, FreeFileNum AS INTEGER

    IF _DIREXISTS("InForm") = 0 THEN MKDIR "InForm"

    IF _FILEEXISTS("InForm/InForm.ini") THEN
        'Load settings
        FreeFileNum = FREEFILE
        OPEN "InForm/InForm.ini" FOR BINARY AS #FreeFileNum
        LINE INPUT #FreeFileNum, b$
        IF b$ = "[InForm Settings]" THEN
            DIM EqualSign AS INTEGER, IniProperty$, IniValue$
            DO
                IF EOF(FreeFileNum) THEN EXIT DO
                LINE INPUT #FreeFileNum, b$
                b$ = UCASE$(b$)
                EqualSign = INSTR(b$, "=")
                IF EqualSign > 0 AND LEFT$(LTRIM$(b$), 1) <> "'" THEN
                    IniProperty$ = LTRIM$(RTRIM$(LEFT$(b$, EqualSign - 1)))
                    IniValue$ = LTRIM$(RTRIM$(MID$(b$, EqualSign + 1)))
                    SELECT CASE IniProperty$
                        CASE "KEEP PREVIEW WINDOW ATTACHED"
                            IF IniValue$ = "FALSE" THEN PreviewAttached = False
                        CASE "AUTO-NAME CONTROLS"
                            IF IniValue$ = "FALSE" THEN AutoNameControls = False
                        CASE "SHOW POSITION AND SIZE"
                            IF IniValue$ = "FALSE" THEN __UI_ShowPositionAndSize = False
                        CASE "SNAP TO EDGES"
                            IF IniValue$ = "FALSE" THEN __UI_SnapLines = False
                        CASE "SWAP MOUSE BUTTONS"
                            $IF WIN THEN
                            $ELSE
                                IF IniValue$ = "TRUE" THEN __UI_MouseButtonsSwap = True
                            $END IF
                    END SELECT
                END IF
            LOOP
        END IF
        CLOSE #FreeFileNum
        Control(__UI_GetID("VIEWMENUPREVIEWDETACH")).Value = PreviewAttached
        Control(__UI_GetID("OPTIONSMENUAUTONAME")).Value = AutoNameControls
        Control(__UI_GetID("OPTIONSMENUSNAPLINES")).Value = __UI_SnapLines
        Control(__UI_GetID("VIEWMENUSHOWPOSITIONANDSIZE")).Value = __UI_ShowPositionAndSize
        $IF WIN THEN
        $ELSE
            Control(__UI_GetID("OPTIONSMENUSWAPBUTTONS")).Value = __UI_MouseButtonsSwap
        $END IF
    END IF

    IF _FILEEXISTS("InForm/UiEditorPreview.frmbin") THEN KILL "InForm/UiEditorPreview.frmbin"
    IF _FILEEXISTS("InForm/UiEditorUndo.dat") THEN KILL "InForm/UiEditorUndo.dat"

    IF _FILEEXISTS(COMMAND$) THEN
        SELECT CASE LCASE$(RIGHT$(COMMAND$, 4))
            CASE ".bas", ".frm"
                IF _FILEEXISTS(LEFT$(COMMAND$, LEN(COMMAND$) - 4) + ".frmbin") THEN
                    FileToOpen$ = LEFT$(COMMAND$, LEN(COMMAND$) - 4) + ".frmbin"
                END IF
            CASE ELSE
                IF LCASE$(RIGHT$(COMMAND$, 7)) = ".frmbin" THEN
                    FileToOpen$ = COMMAND$
                END IF
        END SELECT

        IF LEN(FileToOpen$) > 0 THEN
            FreeFileNum = FREEFILE
            OPEN FileToOpen$ FOR BINARY AS #FreeFileNum
            b$ = SPACE$(LOF(FreeFileNum))
            GET #FreeFileNum, 1, b$
            CLOSE #FreeFileNum

            OPEN "InForm/UiEditorPreview.frmbin" FOR BINARY AS #FreeFileNum
            PUT #FreeFileNum, 1, b$
            CLOSE #FreeFileNum
        END IF
    END IF

    IF _FILEEXISTS("InForm/UiEditor.dat") THEN KILL "InForm/UiEditor.dat"

    $IF WIN THEN
        IF _FILEEXISTS("InForm/UiEditorPreview.exe") = 0 THEN
            IF _FILEEXISTS("InForm/UiEditorPreview.bas") = 0 THEN
                GOTO UiEditorPreviewNotFound
            ELSE
                b$ = "Compiling Preview component..."
                GOSUB ShowMessage
                SHELL "qb64.exe -x .\InForm\UiEditorPreview.bas -o .\InForm\UiEditorPreview.exe"
                IF _FILEEXISTS("InForm/UiEditorPreview.exe") = 0 THEN GOTO UiEditorPreviewNotFound
            END IF
        END IF
        b$ = "Launching..."
        GOSUB ShowMessage
        SHELL _DONTWAIT ".\InForm\UiEditorPreview.exe"
    $ELSE
        IF _FILEEXISTS("InForm/UiEditorPreview") = 0 THEN
        IF _FILEEXISTS("./InForm/UiEditorPreview.bas") = 0 THEN
        GOTO UiEditorPreviewNotFound
        ELSE
        b$ = "Compiling Preview component..."
        GOSUB ShowMessage
        SHELL "./qb64 -x ./InForm/UiEditorPreview.bas -o ./InForm/UiEditorPreview"
        IF _FILEEXISTS("InForm/UiEditorPreview") = 0 THEN GOTO UiEditorPreviewNotFound
        END IF
        END IF
        b$ = "Launching..."
        GOSUB ShowMessage
        SHELL _DONTWAIT "./InForm/UiEditorPreview"
    $END IF

    UiEditorFile = FREEFILE
    OPEN "InForm/UiEditor.dat" FOR BINARY AS #UiEditorFile
    b$ = MKL$(__UI_GetPID)
    PUT #UiEditorFile, OffsetEditorPID, b$
    CLOSE #UiEditorFile

    'Fill "open dialog" listboxes:
    '-------------------------------------------------
    DIM TotalFiles%
    CurrentPath$ = _CWD$
    Text(FileList) = idezfilelist$(CurrentPath$, 0, TotalFiles%)
    Control(FileList).Max = TotalFiles%
    Control(FileList).LastVisibleItem = 0 'Reset it so it's recalculated

    Text(DirList) = idezpathlist$(CurrentPath$, TotalFiles%)
    Control(DirList).Max = TotalFiles%
    Control(DirList).LastVisibleItem = 0 'Reset it so it's recalculated

    Caption(PathLB) = "Path: " + CurrentPath$
    '-------------------------------------------------

    TIMER(CheckPreviewTimer) ON

    EXIT SUB
    UiEditorPreviewNotFound:
    i = MessageBox("UiEditorPreview component not found or failed to load.", "UiEditor", MsgBox_OkOnly + MsgBox_Critical)
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
    LastKeyPress = TIMER
    SELECT CASE id
        CASE FileNameTextBox
            IF OpenDialogOpen THEN
                IF Control(FileList).Max > 0 THEN __UI_ListBoxSearchItem Control(FileList)
            END IF
    END SELECT
END SUB

SUB __UI_TextChanged (id AS LONG)
    SELECT EVERYCASE UCASE$(RTRIM$(Control(id).Name))
        CASE "PROPERTYVALUE"
            IF __UI_Focus = id THEN
                'Send the preview the new property value
                DIM FloatValue AS _FLOAT, b$, TempValue AS LONG, i AS LONG
                STATIC PreviousValue$, PreviousControl AS LONG, PreviousProperty AS INTEGER

                TempValue = Control(__UI_GetID("PropertiesList")).Value
                IF PreviousValue$ <> Text(PropertyValueID) OR PreviousControl <> FirstSelected OR PreviousProperty <> TempValue THEN
                    PreviousValue$ = Text(PropertyValueID)
                    PreviousControl = FirstSelected
                    PreviousProperty = TempValue
                    SELECT CASE TempValue
                        CASE 1, 2, 3, 9 'Name, caption, text, tooltips
                            b$ = MKL$(LEN(Text(PropertyValueID))) + Text(PropertyValueID)
                        CASE 4, 5, 6, 7, 14 'Top, left, width, height, padding
                            b$ = MKI$(VAL(Text(PropertyValueID)))
                            IF TempValue = 14 THEN TempValue = 31
                        CASE 8 'Font
                            b$ = MKL$(LEN(Text(PropertyValueID))) + Text(PropertyValueID)
                        CASE 10, 11, 12, 13 'Value, min, max, interval
                            b$ = _MK$(_FLOAT, VAL(Text(PropertyValueID)))
                    END SELECT
                    SendData b$, TempValue
                END IF
            END IF
        CASE "REDVALUE", "GREENVALUE", "BLUEVALUE"
            IF VAL(Text(id)) > 255 THEN Text(id) = "255"
            DIM TempID AS LONG
            TempID = __UI_GetID(LEFT$(UCASE$(RTRIM$(Control(id).Name)), LEN(UCASE$(RTRIM$(Control(id).Name))) - 5))
            Control(TempID).Value = VAL(Text(id))
            __UI_MouseUp TempID
    END SELECT
END SUB

SUB __UI_ValueChanged (id AS LONG)
    DIM b$
    SELECT EVERYCASE UCASE$(RTRIM$(Control(id).Name))
        CASE "PROPERTIESLIST"
            _DELAY .1 'Give the screen update routine time to finish
            IF Control(PropertyValueID).Disabled = False THEN
                __UI_Focus = PropertyValueID
                IF LEN(Text(__UI_Focus)) > 0 THEN
                    Control(__UI_Focus).Cursor = LEN(Text(__UI_Focus))
                    Control(__UI_Focus).SelectionStart = 0
                    Control(__UI_Focus).TextIsSelected = True
                END IF
            END IF
        CASE "ALIGNOPTIONS"
            b$ = MKI$(Control(__UI_GetID("AlignOptions")).Value - 1)
            SendData b$, 22
        CASE "VALIGNOPTIONS"
            b$ = MKI$(Control(__UI_GetID("VAlignOptions")).Value - 1)
            SendData b$, 32
        CASE "RED"
            Text(RedTextBoxID) = LTRIM$(STR$(Control(RedTrackID).Value))
        CASE "GREEN"
            Text(GreenTextBoxID) = LTRIM$(STR$(Control(GreenTrackID).Value))
        CASE "BLUE"
            Text(BlueTextBoxID) = LTRIM$(STR$(Control(BlueTrackID).Value))
        CASE "RED", "GREEN", "BLUE"
            'Compose a new color and send it to the preview
            DIM NewColor AS _UNSIGNED LONG
            NewColor = _RGB32(Control(RedTrackID).Value, Control(GreenTrackID).Value, Control(BlueTrackID).Value)
            QuickColorPreview NewColor
        CASE "CONTROLLIST"
            Control(UpBT).Disabled = False
            Control(DownBT).Disabled = False
            IF Control(ControlList).Value = 1 THEN
                Control(UpBT).Disabled = True
            ELSEIF Control(ControlList).Value = 0 THEN
                Control(UpBT).Disabled = True
                Control(DownBT).Disabled = True
            ELSEIF Control(ControlList).Value = Control(ControlList).Max THEN
                Control(DownBT).Disabled = True
            END IF
            IF Control(ControlList).Value > 0 THEN
                b$ = MKL$(zOrderIDs(Control(ControlList).Value))
            ELSE
                b$ = MKL$(0)
            END IF
            SendData b$, 213
    END SELECT
END SUB

FUNCTION EditorImageData$ (FileName$)
    DIM A$

    SELECT CASE LCASE$(FileName$)
        CASE "disk.png"
            A$ = MKI$(256) + MKI$(256)
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000@9UDRDUDB9QEB9U0F9UD2HUDB9PEB9U0F9UD2HUDB9PEB9U069T@2HWLb9QAd@3U200000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000000000000000000000000000000000000000000000000@<a438a4C<P9S<b0V<b83H"
            A$ = A$ + "b8S<P9S<b0V<b83Hb8S<P9S<b0V<b83Hc<c<PA3=d0V=fH3HgLc=PQ3>h0V>jX3Hk\c>Pa3?l0V?nh3Holc?P14@01V@294H3=d@"
            A$ = A$ + "PA4A41VA6I4H7MdAPQ4B85VB:YTF<a4Cc0000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000000000000000000000000000000000000000000000000@9UDbFUDB9_GB9UPO9UD2n"
            A$ = A$ + "UDB9hGB9UPO9UD2nUDB9hGB9UPO9UD2nS<b8hob;_P_FJUeJ0000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000000000a4C<B6C<aP_<b83nb8S<h;S<bP_<b83nb8S<h;S<bP_<b83nb8S<h?c<"
            A$ = A$ + "cPO=eD3nfHS=hOc=gPO>iT3njXS>h_c>kPO?md3nnhS?hoc?oPO@154n29T@h?d@3QOA5E4n6ITAhOdA7QOB9U4n:YTBfc4C<a=B"
            A$ = A$ + "8Q4Ql`3?B0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000@9UDbFUDB9iGB9UlO9UDboUDB9oGB9UlO9UDboUDB9oGB9UlO9UDboT@29o?b8"
            A$ = A$ + "SloB:YdoP16HV100000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000LIEE28GK\Q0L[Yf1aafJ7PfHSQ0GHME2NU5F9hEFHUPGIQE2NU5F9hEFHUPGIQE2NU5F9hEFHUPGIQE2"
            A$ = A$ + "NU5F9hEFHUPGIQE2NU5F9hEFHUPGIQE2NU5F9hEFHUPGIQE2NU5F9hEFHUPGIQE2NU5F9hEFHUPGIQE2NU5F9hEFHUPGIQE2NU5F"
            A$ = A$ + "9hEFHUPGIUE2NUEF9hEFIUPGIUE2NUEF9hEFIUPGIUE2NUEF9hEFIUPGIUE2NUEF9hEFIUPGIUE2NUEF9hEFIUPGIUE2NUEF9hEF"
            A$ = A$ + "IUPGIUE2NUEF9hEFIUPGIUE2NUEF9hEFIUPGIUE2NUEF9hEFIUPGIUE2NUEF9hEFIUPGIUE2NUEF9hEFIUPGIUE2NUEF9hEFIUPG"
            A$ = A$ + "IUE2NUEF9hEFIUPGIUE2NUEF9hEFIUPGIUE2NUEF9hEFIUPGIUE2NUEF9hEFIUPGIUE2NUEF9hEFIUPGIUE2NUEF9hEFIUPGIUE2"
            A$ = A$ + "NUEF9hEFIU`GJUE2OYEF9lUFIU`GJUE2OYEF9lUFIU`GJUE2OYEF9lUFIU`GJUE2OYEF9lUFIU`GJUE2OYEF9lUFJU`GJYE2OYUF"
            A$ = A$ + "9lUFJU`GJYE2OYUF9lUFJU`GJYE2OYUF9lUFJU`GJYE2OYUF9lUFJU@GIUE2T16H88HP1B`MgMG0000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000a4C<c4C<aTO<a4cob8S<o;S<bl_<b8cob8S<o;S<bl_<b8cob8S<o?c<cl?=d@coeDC=oOc=gl?>hPcoiTC>o_c>kl??l`co"
            A$ = A$ + "mdC?ooc?ol?@01do15D@o?d@3m?A4Ado5EDAoOdA7m?B8Qdo9UDBo[TB:m?C<ado5EDAo[S>j\l<c<S500000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000@9"
            A$ = A$ + "UDbFUDB9iGB9UlO9UDboUDB9oGB9UlO9UDboUDB9oGB9UlO9UDboUDB9o;R8Rl?=d@coQ56Ho;D@1MK8Q42PVHR90JR9V0X9VH2P"
            A$ = A$ + "VHR90JR9V0X9VH2PVHR90JR9V0X9VH2PVHR90Nb9W0h9WL2PWLb90Nb9W0h9WL2PWLb90Nb9W0HB21dW?MDAjN5D>ALHKUEePY5F"
            A$ = A$ + "D7VFI=MGFEeeG5eCKSED@]=FA1efH55DKSED@]=FA1efH55DKSED@]=FA1efH55DKSED@]=FA1efH55DKSED@]=FA1efH55DKSED"
            A$ = A$ + "@]=FA1efH55DKSED@]=FA1efH55DKSED@]=FA1efH55DKSED@]=FA1efH55DKSED@]=FA1efH55DKSED@]=FA1efH55DKSED@]=F"
            A$ = A$ + "A1efH55DKSED@]=FA1efH55DKSED@]=FA1efH55DKSED@]=FA1efH55DKSED@]=FA1efH55DKSED@]=FA1efH55DKSED@]=FA1ef"
            A$ = A$ + "H55DKSED@]=FA1efH55DKSED@]=FA1efH55DKSED@]=FA1efH55DKSED@]=FA1efH55DKSED@]=FA1efH55DKSED@]=FA1efH55D"
            A$ = A$ + "KSED@]=FA1efH55DKSED@]=FA1efH55DKSED@]=FA1efH55DKSED@]=FA1efH55DKSED@]=FA1efH95DKSUD@]=FB1efH95DKSUD"
            A$ = A$ + "@]=FB1efH95DKSUD@]=FB1efH95DKSUD@]=FB1efH95DKSUD@]=FB5efH9EDKSUDA]=FB5efH9EDKSUDA]=FB5efH9EDKSUDA]=F"
            A$ = A$ + "B5efH9EDKSUDA]=FB5efI=UDK?UC>MMC=e4b;]dBn:S<bd9<`0cV`03<L23<``9<`03W`03<L23<``9<`03W`03<L23<``9<`03W"
            A$ = A$ + "`03<L6C<a`I<a43Wa4C<L6C<a`I<a43Wa4C<L6C<a`I<a43Wa4C<L6C<a`I<a43Wa4C<G6C<a<M<a4cob8S<o;S<bl_<b8cob8S<"
            A$ = A$ + "o;S<bl_<b8cob8S<o;S<blo<c<cod@3=oGC=elo=gLcohP3>oWC>ilo>k\col`3?ogC?mlo?olco014@o7D@1mo@3=do4A4AoGDA"
            A$ = A$ + "5moA7Mdo8Q4BoWDB9m?C<ado;]dBo7D@1mo=gLco]dB;=2000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000@9UDbFS<b8j7R8RlO8R8boQ8R8o7R8RlO8R8boQ8R8"
            A$ = A$ + "o7R8RlO8R8boQ8R8o7B8QlO9UDboC9UDo[UFIm?;\`boT@29oKR9Vl_9VHboVHR9oKR9Vl_9VHboVHR9oKR9Vl_9VHboVHR9oKR9"
            A$ = A$ + "Vlo9WLboWLb9oOb9Wlo9WLboWLb9oCB9TlO=c8coNMEEo36FFm_GFAeoMEeDogEECmOGE=eoME5EokUEDm_GFAeoNI5EokUEDm_G"
            A$ = A$ + "FAeoNI5EokUEDm_GFAeoNI5EokUEDm_GFAeoNI5EokUEDm_GFAeoNI5EokUEDm_GFAeoNI5EokUEDm_GFAeoNI5EokUEDm_GFAeo"
            A$ = A$ + "NI5EokUEDm_GFAeoNI5EokUEDm_GFAeoNI5EokUEDm_GFAeoNI5EokUEDm_GFAeoNI5EokUEDm_GFAeoNI5EokUEDm_GFAeoNI5E"
            A$ = A$ + "okUEDm_GFAeoNI5EokUEDm_GFAeoNI5EokUEDm_GFAeoNI5EokUEDm_GFAeoNI5EokUEDm_GFAeoNI5EokUEDm_GFAeoNI5EokUE"
            A$ = A$ + "Dm_GFAeoNI5EokUEDm_GFAeoNI5EokUEDm_GFAeoNI5EokUEDm_GFAeoNI5EokUEDm_GFAeoNI5EokUEDm_GFAeoNI5EokUEDm_G"
            A$ = A$ + "FAeoNI5EokUEDm_GFAeoNI5EokUEDm_GFAeoNI5EokUEDm_GFAeoNI5EokUEDm_GFAeoNI5EokUEDm_GFAeoNI5EokUEDm_GFAeo"
            A$ = A$ + "NI5EokUEDm_GFAeoNI5EokUEDm_GFAeoNI5EokUEDm_GFAeoNI5EokUEDm_GFAeoNI5EokUEDm_GFAeoNI5Eo7FFGmo=d<coGLa5"
            A$ = A$ + "o?b8SlO<a4co`03<o33<`l?<`0co`03<o33<`l?<`0co`03<o33<`l?<`0co`03<o33<`lO<a4coa4C<o7C<alO<a4coa4C<o7C<"
            A$ = A$ + "alO<a4coa4C<o7C<alO<a4coa4C<oob;_l_;^hbo^hR;oob;_lo;_lbo_lb;oob;_lo;_lbo_lb;oob;_lo;_0co`4C<o;S<clo<"
            A$ = A$ + "d@coeDC=oKS=glo=hPcoiTC>o[c>kl??l`comdS?okc?ol?@01do19T@o?d@3m?A4Ado5ITAoS4B8m_B:Ydo<a4CoOdA7mO?mdco"
            A$ = A$ + "c<c<oWB:Y@n9WLB2000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000@9UDbFQ8R8joR;]`??kT3lkT3>a_C>h4o>iPClkT3>a_C>h4o>iPClkT3>a_C>h4_>hH3l6EDAf76HPm_?"
            A$ = A$ + "ndcoS<b8oKR9Vl_9VHboVHR9oKR9Vl_9VHboVHR9oKR9Vl_9VHboVHR9oKR9Vl_9VHboWLb9oOb9Wlo9WLboWLb9oKR9Vl_9VHbo"
            A$ = A$ + "OQeEoCgJYmOLXIfoaQVIo77JVmOLXIfoaQVIo77JVmOLXIfoaQVIo77JVmOLXIfoaQVIo77JVmOLXIfoaQVIo77JVmOLXIfoaQVI"
            A$ = A$ + "o77JVmOLXIfoaQVIo77JVmOLXIfoaQVIo77JVmOLXIfoaQVIo77JVmOLXIfoaQVIo77JVmOLXIfoaQVIo77JVmOLXIfoaQVIo77J"
            A$ = A$ + "VmOLXIfoaQVIo77JVmOLXIfoaQVIo77JVmOLXIfoaQVIo77JVmOLXIfoaQVIo77JVmOLXIfoaQVIo77JVmOLXIfoaQVIo77JVmOL"
            A$ = A$ + "XIfoaQVIo77JVmOLXIfoaQVIo77JVmOLXIfoaQVIo77JVmOLXIfoaQVIo77JVmOLXIfoaQVIo77JVmOLXIfoaQVIo77JVmOLXIfo"
            A$ = A$ + "aQVIo77JVmOLXIfoaQVIo77JVmOLXIfoaQVIo77JVmOLXIfoaQVIo77JVmOLXIfoaQVIo77JVmOLXIfoaQVIo77JVmOLXIfoaQVI"
            A$ = A$ + "o77JVmOLXIfoaQVIo77JVmOLXIfoaQVIo77JVmOLXIfoaQVIo77JVmOLXIfoaQVIo77JVmOLXIfoaQVIo77JVmOLXIfoaQVIo77J"
            A$ = A$ + "VmOLXIfoaQVIo77JVmOLXIfoaQVIo77JVmOLXIfoaQVIo?gJXmoIOeeoVDB9o3B8Ql_;^hboa4C<o33<`l?<`0co`03<o33<`l?<"
            A$ = A$ + "`0co`03<o33<`l?<`0co`03<o33<`lO<a4coa4C<o7C<alO<a4coa4C<o7C<alO<a4coa4C<o7C<alO<a4coa4C<o7C<ah_?l`Sl"
            A$ = A$ + "5=D@aGT@15OA39Dl5=T@aGd@25OA39Dl5=T@aGd@25OA39Dl6=T@aO4A35?B5ADl9MDAa[4B65_B9MDl<U4BagdB95_C;YDl?edB"
            A$ = A$ + "a3EC<5OD>eDlB1eCa?5D?5?EA1ElE=EDaK5EB1oC>e4n9UDBn[TB;mo@3=dojXS>o33<`l_9VHBmNhQ7H0000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000000000000000000000000000000000000000000000000@9UDbFP4B8jGc<bl?M\Mfn"
            A$ = A$ + "1RgLkoWMa]oOf5gnoIGLkoWMa]oOf5gnoIGLkoWMa]oOf5gn1RWLkCgK\E?DA1UoVHR9oGB9UlO9UDboUDB9oGB9UlO9UDboUDB9"
            A$ = A$ + "oGB9UlO9UDboUDB9oGB9UlO9UDboVHR9oKR9Vl_9VHboVHR9oKR9Vl_7Olao7=d@oGhNim_PhIgo1RGMo78NemOPhEgo1RGMo78N"
            A$ = A$ + "emOPhEgo1RGMo78NemOPhEgo1RGMo78NemOPhEgo1RGMo78NemOPhEgo1RGMo78NemOPhEgo1RGMo78NemOPhEgo1RGMo78NemOP"
            A$ = A$ + "hEgo1RGMo78NemOPhEgo1RGMo78NemOPhEgo1RGMo78NemOPhEgo1RGMo78NemOPhEgo1RGMo78NemOPhEgo1RGMo78NemOPhEgo"
            A$ = A$ + "1RGMo78NemOPhEgo1RGMo78NemOPhEgo1RGMo78NemOPhEgo1RGMo78NemOPhEgo1RGMo78NemOPhEgo1RGMo78NemOPhEgo1RGM"
            A$ = A$ + "o78NemOPhEgo1RGMo78NemOPhEgo1RGMo78NemOPhEgo1RGMo78NemOPhEgo1RGMo78NemOPhEgo1RGMo78NemOPhEgo1RGMo78N"
            A$ = A$ + "emOPhEgo1RGMo78NemOPhEgo1RGMo78NemOPhEgo1RGMo78NemOPhEgo1RGMo78NemOPhEgo1RGMo78NemOPhEgo1RGMo78NemOP"
            A$ = A$ + "hEgo1RGMo78NemOPhEgo1RGMo78NemOPhEgo1RGMo78NemOPhEgo1RGMo78NemOPhEgo1RGMo78NemOPhEgo1RGMo78NemOPhEgo"
            A$ = A$ + "1RGMo78NemoQm]go@]TBoSA6Il?9T@bo]hR;ogB;]lO;]dbo]dB;ogB;]lO;]dbo]dB;ogR;^l_;^hbo^hR;okR;^l_;^hbo_lb;"
            A$ = A$ + "oob;_lo;_lbo_lb;oob;_lo;`0co`03<o33<`l?<`0co`03<oob;`lo;_lbnVm5G^?HNd]oOf5gnoIGLkoWMa]oOf5gnoIGLkoWM"
            A$ = A$ + "a]oOf5gnoIGLkoWMa]oOf5gnoIGLkoWMa]oOf5gnoIGLkoWMa]oOf5gnoIGLkoWMa]oOf5gnoIGLkoWMa]oOf5gnoIGLkoWMa]?P"
            A$ = A$ + "f5gnmAgKm_FIS]?C<]TnmdC?oKS=fl?;\`boR8R8h_a6K`200000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000@9UDbFQ4B8jCc<bl?M\Q6o2V7MooWMamoOf5gooIGLooWMamoOf5gooIGLooWM"
            A$ = A$ + "amoOf5gooIGLo78NbmOL\Ufmc@c<i;R8R\O9UDbnUDB9kGB9U\O9UDbnUDB9kGB9U\O9UDbnUDB9kKR9V\o9WLbnXP2:m_b:[lo:"
            A$ = A$ + "[\RoZXR:nc2;\hO:YTRo29T@nc8Q2n_V@fhoGfXRoOIS;noU=^hoGfhRoOIS;noU=^hoGfhRoOIS;noU=^hoGfhRoOIS;noU=^ho"
            A$ = A$ + "GfhRoOIS;noU=^hoGfhRoOIS;noU=^hoGfhRoOIS;noU=^hoGfhRoOIS;noU=^hoGfhRoOIS;noU=^hoGfhRoOIS;noU=^hoGfhR"
            A$ = A$ + "oOIS;noU=^hoGfhRoOIS;noU=^hoGfhRoOIS;noU=^hoGfhRoOIS;noU=^hoGfhRoOIS;noU=^hoGfhRoOIS;noU=^hoGfhRoOIS"
            A$ = A$ + ";noU=^hoGfhRoOIS;noU=^hoGfhRoOIS;noU=^hoGfhRoOIS;noU=^hoGfhRoOIS;noU=^hoGfhRoOIS;noU=^hoGfhRoOIS;noU"
            A$ = A$ + "=^hoGfhRoOIS;noU=^hoGfhRoOIS;noU=^hoGfhRoOIS;noU=^hoGfhRoOIS;noU=^hoGfhRoOIS;noU=^hoGfhRoOIS;noU=^ho"
            A$ = A$ + "GfhRoOIS;noU=^hoGfhRoOIS;noU=^hoGfhRoOIS;noU=^hoGfhRoOIS;noU=^hoGfhRoOIS;noU=^hoGfhRoOIS;noU=^hoGfhR"
            A$ = A$ + "oOIS;noU=^hoGfhRoOIS;noU=^hoGfhRoOIS;noU=^hoGfhRoOIS;noU=^hoGfhRoOIS;nOV?fho@J8Qo3d?nlo;`0co2=d@nKdA"
            A$ = A$ + "6i?A5ETo4A4An?d@3i_@39To29T@n7D@1i?@01Toolc?nkS?nh_?nhSomdC?ngC?mh??l`Sok`3?n[c>khO>jXSohTC>nS3>hho="
            A$ = A$ + "hPSofHS=nGC=eh?=d@Soc<c<jSVHO9oPjEgooIGLokWMam_Of5gonIGLokWMam_Of5gonIGLokWMam_Of5gonIGLokWMam_Of5go"
            A$ = A$ + "nIGLokWMam_Of5gonIGLokWMam_Of5gonIGLokWMam_Of5gonIGLokWMam_Oe5gonE7LooWMam_Pi=gob]fIioS?oX?<`4coXP2:"
            A$ = A$ + "okQ7NPO6IT1;0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000@9"
            A$ = A$ + "UDbFQ4R8j?S<al_KW=6ok9WKoOgK[moM_]fogmfJoOgK[moM_]fogmfJoOgK[moM_]fogmfJoOgK[m?N_]fob]6JkgeEE5OGGAEl"
            A$ = A$ + "MQEEag5FE5OGHEElMQEEag5FE5OGHEElMQEEag5FE5oGJMElQaEFa?EC<YoA01doEeDCm76FG]OHHMenJ55Dk39R8f_la3oo^g>k"
            A$ = A$ + "ok>k\o_k\cno^c>kok>k\o_k\cno^c>kok>k\o_k\cno^c>kok>k\o_k\cno^c>kok>k\o_k\cno^c>kok>k\o_k\cno^c>kok>k"
            A$ = A$ + "\o_k\cno^c>kok>k\o_k\cno^cnjok>k[o_k\_no^cnjok>k[o_k\cno^c>kok>k\o_k\cno^c>kok>k\o_k\cno^c>kok>k\o_k"
            A$ = A$ + "\cno^c>kok>k\o_k\cno^c>kok>k\o_k\cno^c>kok>k\o_k\cno^c>kok>k\o_k\cno^c>kok>k\o_k\cno^c>kok>k\o_k\cno"
            A$ = A$ + "^c>kok>k\o_k\cno^c>kok>k\o_k\cno^c>kok>k\o_k\cno^c>kok>k\o_k\cno^c>kok>k\o_k\cno^c>kok>k\o_k\cno^c>k"
            A$ = A$ + "ok>k\o_k\cno^c>kok>k\o_k\cno^c>kok>k\o_k\cno^c>kok>k\o_k\cno^c>kok>k\o_k\cno^c>kok>k\o_k\cno^c>kok>k"
            A$ = A$ + "\o_k\_no^cnjok>k[o_k\_no^c>kok>k\o_k\cno^c>kok>k\o_k\cno^c>kok>k\o_k\cno^c>kok>k\o_k\cno^c>kok>k\o_k"
            A$ = A$ + "\cno^c>kok>k\o_k\cno^c>kok>k\ook]cnoaonko?YS>n_AolcoI9UDo37JWaoKWM6o_MVIlkVIVa_KUE6o]E6Ilg6ITa?KT=6o"
            A$ = A$ + "[=VHl_VHRa_JR56oZ5FHlW6HPaOJP16oXmeGlSfGOaoINi5oVeEGkK6GL]OILaenTa5GkCfFK]oHJYenRUEFk;VFI]OM]YFok9WK"
            A$ = A$ + "oS7L\moM_]fogmfJoOgK[moM_]fogmfJoOgK[moM_]fogmfJoOgK[moM_]fogmfJoOgK[moM_]fogmfJoOgK[moM_]fogmfJoOgK"
            A$ = A$ + "[moM_]fogmfJoOgK[moM_]fogmfJoOgK[moM_]fogmfJocgL^m?GGAEn\`2;nC29Tlo6K\1nITA6\00000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000@9UDbFQ8R8j;C<`l?JQi5odafIo37JTm?LXAfo`QFI"
            A$ = A$ + "o37JUm?LXEfo`QFIo37JUm?LXEfo`QFIo37JUm?LXEfo`Q6Io7GJUm?M\Qfoda6JoC7KXm?M\Qfoda6JoC7KXm?M\Qfoda6JoC7K"
            A$ = A$ + "Xm?M\QfofiVJoS7L\mOHHIeo<=4Ao?6FHmoMZYfoeMfIoo6HPm?WB:iooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooo?U?nho4YS>o;VEFmOMWMfocEFIo?GIVmoLVIfocIVIo?WIVmoLVIfocIVIoCWIVm?MVIfodIVIoCWIVm?MVIfodIVIoCWI"
            A$ = A$ + "Vm?MVIfodMfIoCgIWm?MWMfodMfIoCgIWm?MWMfoeMfIoGgIWmOMXMfoeeVJo?gJWmOLYIfo`QFIo37JUm?LXEfo`QFIo37JUm?L"
            A$ = A$ + "XEfo`QFIo37JUm?LXEfo`QFIo37JUm?LXEfo`QFIo37JUm?LXEfo`QFIo37JUm?LXEfo`QFIo37JUm?LXEfo`QFIo37JUm?LXEfo"
            A$ = A$ + "`QFIo37JTm_LZIfo\EFHmoR;^\o7OlaoJXQ6hWA6I`2000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000@9UDbFR8R8j7c;_lOHLQ5o[EFHoSVHNm?JSmeoX=fGoSfHOm?JSmeoX=fGoSfHOm?JSmeoX=fGoSfHOm?J"
            A$ = A$ + "SmeoX=fGoSfHOm?JSmeoX=fGoSfHOm?JSmeoX=fGoSfHOm?JSmeoX=fGoSfHOm?JSmeoX=fGo[FIQm?KW=foI55DoSd?ol?GB9eo"
            A$ = A$ + "^9VHoc6HPm_IIUeoEb8So_?oloonlcook_ono_onkoonk_ook_ono_onkoonk_ook_ono_onkoonk_ook_ono_onkoonk_ook_on"
            A$ = A$ + "o_onkoonk_ook_ono_onkoonk_ook_ono_onkoonk_ook_ono_onkoonk_ook_ono_onkoonk_ook_ono_onkoonk_ook_ono_on"
            A$ = A$ + "koonk_ook_ono_onkoonk_ook_ono_onkoonk_ook_ono_onkoonk_ook_ono_onkoonk_ook_ono_onkoonk_ook_ono_onkoon"
            A$ = A$ + "k_ook_ono_onkoonk_ook_ono_onkoonk_ook_ono_onkoonk_ook_ono_onkoonk_ook_ono_onkoonk_ook_ono_onkoonk_oo"
            A$ = A$ + "k_ono_onkoonk_ook_ono_onkoonk_ook_ono_onkoonk_ook_ono_onkoonk_ook_ono_onkoonk_ook_ono_onkoonk_ook_on"
            A$ = A$ + "o_onkoonk_ook_ono_onkoonk_ook_ono_onkoonk_ook_ono_onkoonk_ook_ono_onkoonk_ook_ono_onkoonk_ook_ono_on"
            A$ = A$ + "koonk_ook_ono_onkoonk_ook_ono_onkoonk_ook_ono_onkoonk_ook_onoc?olooooooo@b8So3T=fl?GB9eo^9VHoc6HPm?K"
            A$ = A$ + "P1fo\16Hoc6HPm?KP1fo\16Hoc6HPm?KP1fo\16Hoc6HPm?KP1fo\16Hoc6HPm?KP1fo\16Hoc6HPm?KP1fo\16Hoc6HPm?KP1fo"
            A$ = A$ + "\16Hoc6HPm?KP1fo\16HogfISmoJV9foYA6HoSfHOm?JSmeoX=fGoSfHOm?JSmeoX=fGoSfHOm?JSmeoX=fGoSfHOm?JSmeoX=fG"
            A$ = A$ + "oSfHOm?JSmeoX=fGoSfHOm?JSmeoX=fGoSfHOm?JSmeoX=fGoSfHOm?JSmeoX=fGoSfHOm?JSmeoYA6HoOVHN]?=b8ClK\a6oWA6"
            A$ = A$ + "IPO6IT1;00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000000000000000000000000000000000000000000000000@9UDbFR8R8joR;]loFF=5o"
            A$ = A$ + "TmeFo76GHmOHLQeoQa5Fo76GHmOHLQeoQa5Fo76GHmOHLQeoQa5Fo76GHmOHLQeoQa5Fo76GHmOHLQeoQa5Fo76GHmOHLQeoQa5F"
            A$ = A$ + "o76GHmOHLQeoQa5Fo76GHmOHLQeoQa5Fo76GHmoHNYeoU16Go;eB9m_@jTcoE]dBoKVFJm?IHQeoM5EDokXQ6n_niWoojWOnoWOn"
            A$ = A$ + "ioOniWooiWOnoWOnioOniWooiWOnoWOnioOniWooiWOnoWOnioOniWooiWOnoWOnioOniWooiWOnoWOnioOniWooiWOnoWOnioOn"
            A$ = A$ + "iWooiWOnoWOnioOniWoohS?noS?nho?nhSoohS?noS?nho?nhSoohS?noS?nho?nhSoohS?noS?nho?nhSoohS?noS?nho?nhSoo"
            A$ = A$ + "hS?noS?nho?nhSoohS?noS?nho?nhSoohS?noS?nho?nhSoohS?noS?nho?nhSoohS?noS?nho?nhSoohS?noS?nho?nhSoohS?n"
            A$ = A$ + "oS?nho?nhSoohS?noS?nho?nhSoohS?noS?nho?nhSoohS?noS?nho?nhSoohS?noS?nho?nhSoohS?noS?nho?nhSoohS?noS?n"
            A$ = A$ + "ho?nhSoohS?noS?nho?nhSoohS?noS?nho?nhSoohS?noS?nho?nhSoohS?noS?nho?nhSoohS?noS?nho?nhSoohS?noS?nho?n"
            A$ = A$ + "hSoohS?noS?nho?nhSooiWOnoWOnioOniWooiWOnoWOnioOniWooiWOnoWOnioOniWooiWOnoWOnioOniWooiWOnoWOnioOniWoo"
            A$ = A$ + "iWOnoWOnioOniWooiWOnoWOnioOniWooooooochQ7n_>a4coE]dBoKVFJm?IHQeoTQ5FoC6FHm?IHQeoTQ5FoC6FHm?IHQeoTQ5F"
            A$ = A$ + "oC6FHm?IHQeoTQ5FoC6FHm?IHQeoTQ5FoC6FHm?IHQeoTQ5FoC6FHm?IHQeoTQ5FoC6FHm?IHQeoTQ5FoC6FHm_IPeeoT1FGo;FG"
            A$ = A$ + "ImOHLQeoQa5Fo76GHmOHLQeoQa5Fo76GHmOHLQeoQa5Fo76GHmOHLQeoQa5Fo76GHmOHLQeoQa5Fo76GHmOHLQeoQa5Fo76GHmOH"
            A$ = A$ + "LQeoQa5Fo76GHmOHLQeoQa5Fo76GHmOHLQeoQa5Fo;FGImOHLUenb43<aS16HlO6IT1nITA6\000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000@9UDbFR8R8jkB;]l?E@i4oLQEEo[EEBm_FE9eoJEUDo[EEBm_FE9eoJEUDo[EE"
            A$ = A$ + "Bm_FE9eoJEUDo[EEBm_FE9eoJEUDo[EEBm_FE9eoJEUDo[EEBm_FE9eoJEUDo[EEBm_FE9eoJEUDo[EEBm_FE9eoJEUDo[EEBm_F"
            A$ = A$ + "E9eoLM5EokEFFmoB4=dok<3=og4A4m?GB9eoJ15Do?EB9moQ02hohS?noS?nho_mgOoofOomoKomgo_mgOoofOomoKomgo_mgOoo"
            A$ = A$ + "fOomoKomgo_mgOoofOomoKomgo_mgOoofOomoKomgo_mgOoofOomoKomgo_mgOoofOomoKomgo_mgOoofOomoKomgo_mgOoofOom"
            A$ = A$ + "oKomgo_mgOoofOomoKomgo_mgOoofOomoKomgo_mgOoofOomoKomgo_mgOoofOomoKomgo_mgOoofOomoKomgo_mgOoofOomoKom"
            A$ = A$ + "go_mgOoofOomoKomgo_mgOoofOomoKomgo_mgOoofOomoKomgo_mgOoofOomoKomgo_mgOoofOomoKomgo_mgOoofOomoKomgo_m"
            A$ = A$ + "gOoofOomoKomgo_mgOoofOomoKomgo_mgOoofOomoKomgo_mgOoofOomoKomgo_mgOoofOomoKomgo_mgOoofOomoKomgo_mgOoo"
            A$ = A$ + "fOomoKomgo_mgOoofOomoKomgo_mgOoofOomoKomgo_mgOoofOomoKomgo_mgOoofOomoKomgo_mgOoofOomoKomgo_mgOoofOom"
            A$ = A$ + "oKomgo_mgOoofOomoKomgo_mgOoofOomoKomgo_mgOoofOomoKomgo_mgOoofOomoKomgo_mgOoofOomoKomgo_mgOoohS?nokoo"
            A$ = A$ + "oo?R3>hocXR:og4A4m?GB9eoJ15Do[5D@m_F@1eoJ15Do[5D@m_F@1eoJ15Do[5D@m_F@1eoJ15Do[5D@m_F@1eoJ15Do[5D@m_F"
            A$ = A$ + "@1eoJ15Do[5D@m_F@1eoJ15Do[5D@m_F@1eoJ15Do[5D@m_F@1eoNUUEokEFFmoFF=eoJEUDo[EEBm_FE9eoJEUDo[EEBm_FE9eo"
            A$ = A$ + "JEUDo[EEBm_FE9eoJEUDo[EEBm_FE9eoJEUDo[EEBm_FE9eoJEUDo[EEBm_FE9eoJEUDo[EEBm_FE9eoJEUDo[EEBm_FE9eoJEUD"
            A$ = A$ + "o[EEBmoFF=eoJEUDkg2;[4o5GLaoITA6hWA6I`20000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000@9"
            A$ = A$ + "UDbFR8b8jkB;]loD?e4oJIeDoO5EAm?FD5eoHAEDoS5EAm?FD5eoHAEDoS5EAm?FD5eoHAEDoS5EAm?FD5eoHAEDoS5EAm?FD5eo"
            A$ = A$ + "HAEDoS5EAm?FD5eoHAEDoS5EAm?FD5eoHAEDoS5EAm?FD5eoHAEDoS5EAm?FD5eoHAEDo[UECm?GIEeo754@oGc;`l_AnhcoDYTB"
            A$ = A$ + "o;EB9moB15do0^gNoOomgoomgOooeGOmoGOmeoOmeGooeGOmoGOmeoOmeGooeGOmoGOmeoOmeGooeGOmoGOmeoOmeGooeGOmoGOm"
            A$ = A$ + "eoOmeGooeGOmoGOmeoOmeGooeGOmoGOmeoOmeGooeGOmoGOmeoOmeGooeGOmoGOmeoOmeGooeGOmoGOmeoOmeGooeGOmoGOmeoOm"
            A$ = A$ + "eGooeGOmoGOmeoOmeGooeGOmoGOmeoOmeGooeGOmoGOmeoOmeGooeGOmoGOmeoOmeGooeGOmoGOmeoOmeGooeGOmoGOmeoOmeGoo"
            A$ = A$ + "eGOmoGOmeoOmeGooeGOmoGOmeoOmeGooeGOmoGOmeoOmeGooeGOmoGOmeoOmeGooeGOmoGOmeoOmeGooeGOmoGOmeoOmeGooeGOm"
            A$ = A$ + "oGOmeoOmeGooeGOmoGOmeoOmeGooeGOmoGOmeoOmeGooeGOmoGOmeoOmeGooeGOmoGOmeoOmeGooeGOmoGOmeoOmeGooeGOmoGOm"
            A$ = A$ + "eoOmeGooeGOmoGOmeoOmeGooeGOmoGOmeoOmeGooeGOmoGOmeoOmeGooeGOmoGOmeoOmeGooeGOmoGOmeoOmeGooeGOmoGOmeoOm"
            A$ = A$ + "eGooeGOmoGOmeoOmeGooeGOmoGOmeoOmeGooeGOmoGOmeoOmeGooeGOmoO_mfo_onkoo4ngOocR9Vl_AnhcoDYTBo;EB9m_D9Udo"
            A$ = A$ + "BUDBo;EB9m_D9UdoBUDBo;EB9m_D9UdoBUDBo;EB9m_D9UdoBUDBo;EB9m_D9UdoBUDBo;EB9m_D9UdoBUDBo;EB9m_D9UdoBUDB"
            A$ = A$ + "o;EB9m_D9UdoBYDBo_eEDm?GHEeoIEUDoS5EAm?FD5eoHAEDoS5EAm?FD5eoHAEDoS5EAm?FD5eoHAEDoS5EAm?FD5eoHAEDoS5E"
            A$ = A$ + "Am?FD5eoHAEDoS5EAm?FD5eoHAEDoS5EAm?FD5eoHAEDoS5EAm?FD5eoHAEDoS5EAm?FD5eoIEUDoS5EA]_:YPBlFLa5oWA6IPO6"
            A$ = A$ + "IT1;000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000@9UDbFR<b8jgB;\l_D>a4oIEUDoOeD@moEC1eoG=5D"
            A$ = A$ + "oOeD@moEC1eoG=5DoOeD@moEC1eoG=5DoOeD@moEC1eoG=5DoOeD@moEC1eoG=5DoOeD@moEC1eoG=5DoOeD@moEC1eoG=5DoOeD"
            A$ = A$ + "@moEC1eoG=5DoOeD@moEC1eoG=5DoOeD@mOFE9eoLQEEo?T?mlo;YXbonLc=o[T@2mOB15do1UC>o[7Mdm_meGoofC?moColco?m"
            A$ = A$ + "c?ood?oloColco?mc?ood?oloColco?mc?ood?oloColco?mc?ood?olo?_lboolb;ooc;_lo?_lboolb;ooc;_lo?_lboolb;oo"
            A$ = A$ + "c;_lo?_lboolb;ooc;_lo?_lboolb;ooc;_lo?_lboolb;ooc;_lo?_lboolb;ooc;_lo?_lboolb;ooc;_lo?_lboolb;ooc;_l"
            A$ = A$ + "o?_lbo?mb;ood?oloColco?mc?ood?oloColco?mc?ood?oloColco?mc?ood?oloColco?mc?ood?oloColco?mc?ood?oloCol"
            A$ = A$ + "co?mc?ood?oloColco?mc?ood?oloColco?mc?ood?oloColco?mc?ood?oloColco?mc?ood?oloColco?mc?ood?oloColco?m"
            A$ = A$ + "c?ood?oloColco?mc?ood?oloColco?mc?ood?oloColco?mc?ood?oloColco?mc?ood?oloColco?mc?ood?oloColco?mc?oo"
            A$ = A$ + "d?oloColco?mc?ood?oloColco?mc?ood?oloColco?mc?ood?oloColco?mc?ood?oloColco?mc?ood?oloColco?mc?ood?ol"
            A$ = A$ + "oColco?mc?ood?oloColco_meGoomc?ooogNkm_9P0bonLc=o[T@2mOB15do95D@oWD@1mOB15do95D@oWD@1mOB15do95D@oWD@"
            A$ = A$ + "1mOB15do95D@oWD@1mOB15do95D@oWD@1mOB15do95D@oWD@1mOB15do95D@oWD@1mOB15do95D@o[T@2mOFE=eoKM5EoS5EAmoE"
            A$ = A$ + "C1eoG=5DoOeD@moEC1eoG=5DoOeD@moEC1eoG=5DoOeD@moEC1eoG=5DoOeD@moEC1eoG=5DoOeD@moEC1eoG=5DoOeD@moEC1eo"
            A$ = A$ + "G=5DoOeD@moEC1eoG=5DoOeD@moEC1eoG=5DoS5EAmoEC1enYLb9aKa5GlO6IT1nITA6\0000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000@9UDbFR<b8jgB;\lOD>a4oIEUDoKeD@m_EC1eoF=5DoKeD@m_EC1eoF=5DoKeD@m_EC1eoF=5DoKeD@m_E"
            A$ = A$ + "C1eoF=5DoKeD@m_EC1eoF=5DoKeD@m_EC1eoF=5DoKeD@m_EC1eoF=5DoKeD@m_EC1eoF=5DoKeD@m_EC1eoF=5DoKeD@m_EC1eo"
            A$ = A$ + "HEUDoc5FEmo?jTcoZ@29oSC<al_@jXco1UC>oWC<al?M^ifod?oloColco_la7oob7Olo;Olao_la7oob7Olo;Olao_la7oob7Ol"
            A$ = A$ + "o;Olao_la7oob7Olo;Olaoolb;ood?oloColco?mc?ood?oloColco?mc?ood?oloColco?mc?ood?oloColco?mc?ood?oloCol"
            A$ = A$ + "co?mc?ood?oloColco?mc?ood?oloColco?mc?ood?oloColco?mc?ood?oloColco?mc?oob7Olo;Olao_la7oob7Olo;Olao_l"
            A$ = A$ + "a7oob7Olo;Olao_la7oob7Olo;Olao_la7oob7Olo;Olao_la7oob7Olo;Olao_la7oob7Olo;Olao_la7oob7Olo;Olao_la7oo"
            A$ = A$ + "b7Olo;Olao_la7oob7Olo;Olao_la7oob7Olo;Olao_la7oob7Olo;Olao_la7oob7Olo;Olao_la7oob7Olo;Olao_la7oob7Ol"
            A$ = A$ + "o;Olao_la7oob7Olo;Olao_la7oob7Olo;Olao_la7oob7Olo;Olao_la7oob7Olo;Olao_la7oob7Olo;Olao_la7oob7Olo;Ol"
            A$ = A$ + "ao_la7oob7Olo;Olao_la7oob7Olo;Olao_la7oob7Olo;Olao_la7oob7Olo;Olao_la7oob7Olo;Olao_la7ood?olo__njooN"
            A$ = A$ + "gMgoQ\a6oSC<al_@jXco1UC>o7D>ilO@iTco1UC>o7D>ilO@iTco1UC>o7D>ilO@iTco1UC>o7D>ilO@iTco1UC>o7D>ilO@iTco"
            A$ = A$ + "1UC>o7D>ilO@iTco1UC>o7D>ilO@iTco1UC>o7D>il_@jXcoG=EDo[eEDmoED5eoF=5DoKeD@m_EC1eoF=5DoKeD@m_EC1eoF=5D"
            A$ = A$ + "oKeD@m_EC1eoF=5DoKeD@m_EC1eoF=5DoKeD@m_EC1eoF=5DoKeD@m_EC1eoF=5DoKeD@m_EC1eoF=5DoKeD@m_EC1eoF=5DoKeD"
            A$ = A$ + "@moED5eoF=5DkSb9W4o5GLaoITA6hWA6I`200000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000000000000000000000000000000000000000000000000@9UDbFR<b8jgB;\lOD=]4o"
            A$ = A$ + "HAEDoKUD?m_EBmdoF9eCoKUD?m_EBmdoF9eCoKUD?m_EBmdoF9eCoKUD?m_EBmdoF9eCoKUD?m_EBmdoF9eCoKUD?m_EBmdoF9eC"
            A$ = A$ + "oKUD?m_EBmdoF9eCoKUD?m_EBmdoF9eCoKUD?m_EBmdoF9eCoKUD?m_EBmdoF9eCoS5EAmoFGAeomT3>oOb8SlO=`0cooTC>ok3>"
            A$ = A$ + "hl_=`0coaa6Ko;Olao_la7oo`onko3ok_o?l_ono`onko3ok_o?l_ono`onko3ok_o?l_ono`onko3ok_o?l_onoc;_loColcoom"
            A$ = A$ + "gOoooooooooooooonkoook_ooo_onooonkoook_ooo_onooonkoook_ooo_onooonkoook_ooo_onooonkoook_ooo_onooonkoo"
            A$ = A$ + "ok_ooo_onooonkoook_ookOomoOmdCooeC?mo7?l`o?l_ono`onko3ok_o?l_ono`onko3ok_o?l_ono`onko3ok_o?l_ono`onk"
            A$ = A$ + "o3ok_o?l_ono`onko3ok_o?l_ono`onko3ok_o?l_ono`onko3ok_o?l_ono`onko3ok_o?l_ono`onko3ok_o?l_ono`onko3ok"
            A$ = A$ + "_o?l_ono`onko3ok_o?l_ono`onko3ok_o?l_ono`onko3ok_o?l_ono`onko3ok_o?l_ono`onko3ok_o?l_ono`onko3ok_o?l"
            A$ = A$ + "_ono`onko3ok_o?l_ono`onko3ok_o?l_ono`onko3ok_o?l_ono`onko3ok_o?l_ono`onko3ok_o?l_ono`onko3ok_o?l_ono"
            A$ = A$ + "`onko3ok_o?l_ono`onko3ok_o?l_ono`onko3ok_o?l_ono`onko;OlaoOnhSooiIWMokQ6JlO=`0cooTC>ok3>hl_?hPconP3>"
            A$ = A$ + "ok3>hl_?hPconP3>ok3>hl_?hPconP3>ok3>hl_?hPconP3>ok3>hl_?hPconP3>ok3>hl_?hPconP3>ok3>hl_?hPconP3>ok3>"
            A$ = A$ + "hl_?hPcooTC>oOeD@m_FF=eoG=5DoKUD?m_EBmdoF9eCoKUD?m_EBmdoF9eCoKUD?m_EBmdoF9eCoKUD?m_EBmdoF9eCoKUD?m_E"
            A$ = A$ + "BmdoF9eCoKUD?m_EBmdoF9eCoKUD?m_EBmdoF9eCoKUD?m_EBmdoF9eCoKUD?m_EBmdoG=5DoKUD?]?:WHBlGLa5oWA6IPO6IT1;"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000@9UDbFR<b8jgB;\lOD=]4oHAEDoGUD?m_EBmdoF9eCoKUD?m_EBmdoF9eCoKUD"
            A$ = A$ + "?m_EBmdoF9eCoKUD?m_EBmdoF9eCoKUD?m_EBmdoF9eCoKUD?m_EBmdoF9eCoKUD?m_EBmdoF9eCoKUD?m_EBmdoF9eCoKUD?m_E"
            A$ = A$ + "BmdoF9eCoKUD?m_EBmdoF9eCoKUD?m?FD5eoKM5Eog3>glo9R8boelb;oo3>hl_?gLcoflb;o7gJ[m?l^kno`k^kok>k\o_k\cno"
            A$ = A$ + "^c>kok>k\o_k\cno^c>kok>k\o_k\cno^c>kok>k\o_k\cno^c>ko7ok_o_meGooPomgoWZYVnOZWNjo_b:[ok:[\n_[\bjo^b:["
            A$ = A$ + "ok:[\n_[\bjo^b:[ok:[\n_[\bjo^b:[ok:[\n_[\bjo^b:[ok:[\n_[\bjo^b:[ok:[\n_[\bjo^b:[ogjZ[no\`2ko^k^koCol"
            A$ = A$ + "cook_ono^c>kok>k\o_k\cno^c>kok>k\o_k\cno^c>kok>k\o_k\cno^c>kok>k\o_k\cno^c>kok>k\o_k\cno^c>kok>k\o_k"
            A$ = A$ + "\cno^c>kok>k\o_k\cno^c>kok>k\o_k\cno^c>kok>k\o_k\cno^c>kok>k\o_k\cno^c>kok>k\o_k\cno^c>kok>k\o_k\cno"
            A$ = A$ + "^c>kok>k\o_k\cno^c>kok>k\o_k\cno^c>kok>k\o_k\cno^c>kok>k\o_k\cno^c>kok>k\o_k\cno^c>kok>k\o_k\cno^c>k"
            A$ = A$ + "ok>k\o_k\cno^c>kok>k\o_k\cno^c>kok>k\o_k\cno^c>kok>k\o_k\cno^c>kok>k\o_k\cno^c>kok>k\o_k\cno^c>kok>k"
            A$ = A$ + "\o_k\cno^c>kok>k\o?l^knogGOmoSGMem_7ITaoelb;oo3>hl_?gLconLc=okc=gl_?gLconLc=okc=gl_?gLconLc=okc=gl_?"
            A$ = A$ + "gLconLc=okc=gl_?gLconLc=okc=gl_?gLconLc=okc=gl_?gLconLc=okc=gl_?gLconLc=oo3>hloEB1eoJIeDoOeD@m_EBmdo"
            A$ = A$ + "F9eCoKUD?m_EBmdoF9eCoKUD?m_EBmdoF9eCoKUD?m_EBmdoF9eCoKUD?m_EBmdoF9eCoKUD?m_EBmdoF9eCoKUD?m_EBmdoF9eC"
            A$ = A$ + "oKUD?m_EBmdoF9eCoKUD?m_EBmdoF9eCoOeD@m_EBmdnXLR9aOa5GlO6IT1nITA6\00000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000@9"
            A$ = A$ + "UDbFR<b8igB;\l?D=Y4oG=5DoGED>mOEAidoE5UCoGED>mOEAidoE5UCoGED>mOEAidoE5UCoGED>mOEAidoE5UCoGED>mOEAido"
            A$ = A$ + "E5UCoGED>mOEAidoE5UCoGED>mOEAidoE5UCoGED>mOEAidoE5UCoGED>mOEAidoE5UCoGED>mOEAidoE5UCoGED>mOEAidoG=5D"
            A$ = A$ + "o[UECmO?hLcoW8R8oGc;_lo?hPconLc=oKc;_loK[]fo]gNkogNk]o?k[_no\_njocnj[o?k[_no\_njocnj[o?k[_no\_njocnj"
            A$ = A$ + "[o?k[_no\_njocnj[o_k]gnojWOnok;_lnO9P0boV4B8oO3<`l?>a4coh4C<oSC<al?>a4coh4C<oSC<al?>a4coh4C<oSC<al?>"
            A$ = A$ + "a4coh4C<oSC<al?>a4coh4C<oSC<al?>a4coh4C<oSC<al?=^hbo3a3?oKNiUo?mdCoo^gNkocnj[o?k[_no\_njocnj[o?k[_no"
            A$ = A$ + "\_njocnj[o?k[_no\_njocnj[o?k[_no\_njocnj[o?k[_no\_njocnj[o?k[_no\_njocnj[o?k[_no\_njocnj[o?k[_no\_nj"
            A$ = A$ + "ocnj[o?k[_no\_njocnj[o?k[_no\_njocnj[o?k[_no\_njocnj[o?k[_no\_njocnj[o?k[_no\_njocnj[o?k[_no\_njocnj"
            A$ = A$ + "[o?k[_no\_njocnj[o?k[_no\_njocnj[o?k[_no\_njocnj[o?k[_no\_njocnj[o?k[_no\_njocnj[o?k[_no\_njocnj[o?k"
            A$ = A$ + "[_no\_njocnj[o?k[_no\_njocnj[o?k[_no\_njocnj[o?k[_no\_njocnj[o?k[_no\_njocnj[o?k[_no^gNkoC?mdo?NdAgo"
            A$ = A$ + "OTA6oGc;_lo?hPconLc=okc=gl_?gLconLc=okc=gl_?gLconLc=okc=gl_?gLconLc=okc=gl_?gLconLc=okc=gl_?gLconLc="
            A$ = A$ + "okc=gl_?gLconLc=okc=gl_?gLconLc=okc=glo?hPcoF9eCoWEEBm_EBmdoE5UCoGED>mOEAidoE5UCoGED>mOEAidoE5UCoGED"
            A$ = A$ + ">mOEAidoE5UCoGED>mOEAidoE5UCoGED>mOEAidoE5UCoGED>mOEAidoE5UCoGED>mOEAidoE5UCoGED>mOEAidoE5UCoGED>m_E"
            A$ = A$ + "BmdoE5UCkSb9V4o5GLaoITA6hWA6I`2000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000@9UDR=R<b8hgB;\l?D=Y4oG=5DoCED>mOEAidoE5UC"
            A$ = A$ + "oGED>mOEAidoE5UCoGED>mOEAidoE5UCoGED>mOEAidoE5UCoGED>mOEAidoE5UCoGED>mOEAidoE5UCoGED>mOEAidoE5UCoGED"
            A$ = A$ + ">mOEAidoE5UCoGED>mOEAidoE5UCoGED>mOEAidoE5UCoGED>mOEAidoE5UCoOeD@m_FF=eomPc=oOR8Rl?=^hbonLc=ogS=flO="
            A$ = A$ + "^hbo_UFJocnj[o?k[_noZWNjo[NjYo_jYWnoZWNjo[NjYo_jYWnoZWNjo[NjYo_jYWnoZWNjo[NjYo_jYWno]gNkoS?nhoo_mfko"
            A$ = A$ + "ZHR9o_B9Ulo>d@colDC=ocC=el??eDcolDC=ocC=el??eDcolDC=ocC=el??eDcolDC=ocC=el??eDcolDC=ocC=el??eDcolDC="
            A$ = A$ + "ocC=el??eDcoi8S<oO4@0mOiUGnoc?olocnj[o_jYWnoZWNjo[NjYo_jYWnoZWNjo[NjYo_jYWnoZWNjo[NjYo_jYWnoZWNjo[Nj"
            A$ = A$ + "Yo_jYWnoZWNjo[NjYo_jYWnoZWNjo[NjYo_jYWnoZWNjo[NjYo_jYWnoZWNjo[NjYo_jYWnoZWNjo[NjYo_jYWnoZWNjo[NjYo_j"
            A$ = A$ + "YWnoZWNjo[NjYo_jYWnoZWNjo[NjYo_jYWnoZWNjo[NjYo_jYWnoZWNjo[NjYo_jYWnoZWNjo[NjYo_jYWnoZWNjo[NjYo_jYWno"
            A$ = A$ + "ZWNjo[NjYo_jYWnoZWNjo[NjYo_jYWnoZWNjo[NjYo_jYWnoZWNjo[NjYo_jYWnoZWNjo[NjYo_jYWnoZWNjo[NjYo_jYWnoZWNj"
            A$ = A$ + "o[NjYo_jYWnoZWNjo[NjYo_jYWnoZWNjo[NjYo_jYWnoZWNjocnj[oolb;oogA7MooQ6Jl?=^hbonLc=ogS=flO?fHcomHS=ogS="
            A$ = A$ + "flO?fHcomHS=ogS=flO?fHcomHS=ogS=flO?fHcomHS=ogS=flO?fHcomHS=ogS=flO?fHcomHS=ogS=flO?fHcomHS=ogS=flO?"
            A$ = A$ + "fHconLc=oKED?mOFE9eoF9eCoGED>mOEAidoE5UCoGED>mOEAidoE5UCoGED>mOEAidoE5UCoGED>mOEAidoE5UCoGED>mOEAido"
            A$ = A$ + "E5UCoGED>mOEAidoE5UCoGED>mOEAidoE5UCoGED>mOEAidoE5UCoGED>mOEAidoF9eCoGED>]?:WHBlGLa5oWA6IPO6IT1;0000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000R<b8Sf2;\loC<UDoF95DoC5D=m?E@idoD1UCoC5D>m?E@idoD1UCoC5D>m?E@idoD1UCoC5D>m?E"
            A$ = A$ + "@idoD1UCoC5D>m?E@idoD1UCoC5D>m?E@idoD1UCoC5D>m?E@idoD1UCoC5D>m?E@idoD1UCoC5D>m?E@idoD1UCoC5D>m?E@ido"
            A$ = A$ + "D1UCoC5D>m?E@idoD1UCoC5D>m_EB1eoIEeDocc=glo9R8bodhR;okc=glO?fHcoehR;okFJYm_jZ[no[[^joS>jXo?jXSnoXS>j"
            A$ = A$ + "oS>jXo?jXSnoXS>joS>jXo?jXSnoXS>joS>jXo?jXSnoWOnioc>k\oomgOoonfK_o[R9Vl?;VHbolDC=ogS=flO?fHcomHS=ogS="
            A$ = A$ + "flO?fHcomHS=ogS=flO?fHcomHS=ogS=flO?fHcomHS=ogS=flO?fHcomHS=ogS=flO?fHcomHS=o[c<cl?B15doTC>io;_lbo_j"
            A$ = A$ + "Z[noXS>joS>jXo?jXSnoXS>joS>jXo?jXSnoXS>joS>jXo?jXSnoXS>joS>jXo?jXSnoXS>joS>jXo?jXSnoXS>joS>jXo?jXSno"
            A$ = A$ + "XS>joS>jXo?jXSnoXS>joS>jXo?jXSnoXS>joS>jXo?jXSnoXS>joS>jXo?jXSnoXS>joS>jXo?jXSnoXS>joS>jXo?jXSnoXS>j"
            A$ = A$ + "oS>jXo?jXSnoXS>joS>jXo?jXSnoXS>joS>jXo?jXSnoXS>joS>jXo?jXSnoXS>joS>jXo?jXSnoXS>joS>jXo?jXSnoXS>joS>j"
            A$ = A$ + "Xo?jXSnoXS>joS>jXo?jXSnoXS>joS>jXo?jXSnoXS>joS>jXo?jXSnoXS>joS>jXo?jXSnoXS>joS>jXo?jXSnoXS>joS>jXo?j"
            A$ = A$ + "XSnoXS>joS>jXoOjZ[noa7OloKgLcmo7JXaodhR;okc=glO?fHcomHS=ogS=flO?fHcomHS=ogS=flO?fHcomHS=ogS=flO?fHco"
            A$ = A$ + "mHS=ogS=flO?fHcomHS=ogS=flO?fHcomHS=ogS=flO?fHcomHS=ogS=flO?fHcomHS=okc=glOEAmdoHAUDoGED?m?E@idoD1UC"
            A$ = A$ + "oC5D>m?E@idoD1UCoC5D>m?E@idoD1UCoC5D>m?E@idoD1UCoC5D>m?E@idoD1UCoC5D>m?E@idoD1UCoC5D>m?E@idoD1UCoC5D"
            A$ = A$ + ">m?E@idoD1UCoC5D>m?E@idoD1UCoGED?m?E@idnXLR9aOa5GlO6IT1nITA6\000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000000000000000000000000000000000000000000000000000000S<b8Xd2;\@oC<Udo"
            A$ = A$ + "F9eCo?5D=m?E@edoD1ECoC5D=m?E@edoD1ECoC5D=m?E@edoD1ECoC5D=m?E@edoD1ECoC5D=m?E@edoD1ECoC5D=m?E@edoD1EC"
            A$ = A$ + "oC5D=m?E@edoD1ECoC5D=m?E@edoD1ECoC5D=m?E@edoD1ECoC5D=m?E@edoD1ECoC5D=m?E@edoD1ECoC5D=m?E@edoF9eCoWEE"
            A$ = A$ + "Bm??gHcoV4B8o?C;]lO?fHcolDC=oCC;]lOKXQfoYS>joWNjYo_iVKnoVK^ioK^iVo_iVKnoVK^ioK^iVo_iVKnoVK^ioK^iVo_i"
            A$ = A$ + "VKnoVK^ioGNiUoOjYWnoeK_mock^kn_:VHbo[HR9o_C=el??eDcolDC=ocC=el??eDcolDC=ocC=el??eDcolDC=ocC=el??eDco"
            A$ = A$ + "lDC=ocC=el??eDcolDC=ocC=el??eDcolDC=ocC=elO>b8co714@o;^hRo?l`3ooXS>joK^iVo_iVKnoVK^ioK^iVo_iVKnoVK^i"
            A$ = A$ + "oK^iVo_iVKnoVK^ioK^iVo_iVKnoVK^ioK^iVo_iVKnoVK^ioK^iVo_iVKnoVK^ioK^iVo_iVKnoVK^ioK^iVo_iVKnoVK^ioK^i"
            A$ = A$ + "Vo_iVKnoVK^ioK^iVo_iVKnoVK^ioK^iVo_iVKnoVK^ioK^iVo_iVKnoVK^ioK^iVo_iVKnoVK^ioK^iVo_iVKnoVK^ioK^iVo_i"
            A$ = A$ + "VKnoVK^ioK^iVo_iVKnoVK^ioK^iVo_iVKnoVK^ioK^iVo_iVKnoVK^ioK^iVo_iVKnoVK^ioK^iVo_iVKnoVK^ioK^iVo_iVKno"
            A$ = A$ + "VK^ioK^iVo_iVKnoVK^ioK^iVo_iVKnoVK^ioK^iVo_iVKnoVK^ioK^iVo_iVKnoVK^ioK^iVo_iVKnoXOnioonk_oOMb9goNTA6"
            A$ = A$ + "o?C;]lO?fHcolDC=ocC=el??eDcolDC=ocC=el??eDcolDC=ocC=el??eDcolDC=ocC=el??eDcolDC=ocC=el??eDcolDC=ocC="
            A$ = A$ + "el??eDcolDC=ocC=el??eDcolDC=ocC=elO?fHcoE1UCoS5EAmOEAidoD1ECoC5D=m?E@edoD1ECoC5D=m?E@edoD1ECoC5D=m?E"
            A$ = A$ + "@edoD1ECoC5D=m?E@edoD1ECoC5D=m?E@edoD1ECoC5D=m?E@edoD1ECoC5D=m?E@edoD1ECoC5D=m?E@edoD1ECoC5D=mOEAido"
            A$ = A$ + "D1ECkSb9V4o5GLaoITA6hWA6I`20000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000<S<a@IC:MdoE5UCo?eC<moD?edoCmDCo?eC=moD?edoCmDCo?eC"
            A$ = A$ + "=moD?edoCmDCo?eC=moD?edoCmDCo?eC=moD?edoCmDCo?eC=moD?edoCmDCo?eC=moD?edoCmDCo?eC=moD?edoCmDCo?eC=moD"
            A$ = A$ + "?edoCmDCo?eC=moD?edoCmDCo?eC=moD?edoCmDCo?eC=moD?edoCmDCoGED?m?FD9eokHS=oKB8Qlo<]dbomHS=ocC=el?=]dbo"
            A$ = A$ + "\MfIoOniWooiWOnoTC>ioC>iTo?iTCnoTC>ioC>iTo?iTCnoTC>ioC>iTo?iTCnoTC>ioC>iTo_hR;noXS>joC?mdoo^jZkoZHR9"
            A$ = A$ + "o_R9Vlo>eDcolDC=ocC=el??eDcolDC=ocC=el??eDcolDC=ocC=el??eDcolDC=ocC=el??eDcolDC=ocC=el??eDcolDC=ocC="
            A$ = A$ + "el??eDcoi8S<oO4@0mOhQ7no_onkoGNiUo?iTCnoTC>ioC>iTo?iTCnoTC>ioC>iTo?iTCnoTC>ioC>iTo?iTCnoTC>ioC>iTo?i"
            A$ = A$ + "TCnoTC>ioC>iTo?iTCnoTC>ioC>iTo?iTCnoTC>ioC>iTo?iTCnoTC>ioC>iTo?iTCnoTC>ioC>iTo?iTCnoTC>ioC>iTo?iTCno"
            A$ = A$ + "TC>ioC>iTo?iTCnoTC>ioC>iTo?iTCnoTC>ioC>iTo?iTCnoTC>ioC>iTo?iTCnoTC>ioC>iTo?iTCnoTC>ioC>iTo?iTCnoTC>i"
            A$ = A$ + "oC>iTo?iTCnoTC>ioC>iTo?iTCnoTC>ioC>iTo?iTCnoTC>ioC>iTo?iTCnoTC>ioC>iTo?iTCnoTC>ioC>iTo?iTCnoTC>ioC>i"
            A$ = A$ + "To?iTCnoTC>ioC>iTo?iTCnoTC>ioC>iTo?iTCnoTC>ioO^iVo?k]gnoc17LokA6Ilo<]dbomHS=ocC=el??eDcolDC=ocC=el??"
            A$ = A$ + "eDcolDC=ocC=el??eDcolDC=ocC=el??eDcolDC=ocC=el??eDcolDC=ocC=el??eDcolDC=ocC=el??eDcolDC=ocC=el??eDco"
            A$ = A$ + "mHS=oC5D>moEC5eoD1UCo?eC=moD?edoCmDCo?eC=moD?edoCmDCo?eC=moD?edoCmDCo?eC=moD?edoCmDCo?eC=moD?edoCmDC"
            A$ = A$ + "o?eC=moD?edoCmDCo?eC=moD?edoCmDCo?eC=moD?edoCmDCo?eC=moD?edoD1UCo?eC=]o9VHBlGLa5oWA6IPO6IT1;00000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000@D>]T_D1ECo;eC<moD?adoCm4Co?eC<moD?adoCm4Co?eC<moD?adoCm4Co?eC<moD?adoCm4Co?eC<moD?ado"
            A$ = A$ + "Cm4Co?eC<moD?adoCm4Co?eC<moD?adoCm4Co?eC<moD?adoCm4Co?eC<moD?adoCm4Co?eC<moD?adoCm4Co?eC<moD?adoCm4C"
            A$ = A$ + "o?eC<moD?adoCm4Co?eC<mOEAidoHAEDo_S=flO9Q4bobdB;ocS=flo>eDcoddB;o_fIWmOiUGnoUGNio;^hRo_hR;noR;^ho;^h"
            A$ = A$ + "Ro_hR;noR;^ho;^hRo_hR;noR;^ho;^hRo_hR;noQ7NhoK^iVo_lc?oojVK^oWB9Ul_:VHbojDC=o_C=elo>eDcokDC=o_C=elo>"
            A$ = A$ + "eDcokDC=o_C=elo>eDcokDC=o_C=elo>eDcokDC=o_C=elo>eDcokDC=o_C=elo>eDcokDC=oSS<bl_A01doPomgogNk]o?iTCno"
            A$ = A$ + "R;^ho;^hRo_hR;noR;^ho;^hRo_hR;noR;^ho;^hRo_hR;noR;^ho;^hRo_hR;noR;^ho;^hRo_hR;noR;^ho;^hRo_hR;noR;^h"
            A$ = A$ + "o;^hRo_hR;noR;^ho;^hRo_hR;noR;^ho;^hRo_hR;noR;^ho;^hRo_hR;noR;^ho;^hRo_hR;noR;^ho;^hRo_hR;noR;^ho;^h"
            A$ = A$ + "Ro_hR;noR;^ho;^hRo_hR;noR;^ho;^hRo_hR;noR;^ho;^hRo_hR;noR;^ho;^hRo_hR;noR;^ho;^hRo_hR;noR;^ho;^hRo_h"
            A$ = A$ + "R;noR;^ho;^hRo_hR;noR;^ho;^hRo_hR;noR;^ho;^hRo_hR;noR;^ho;^hRo_hR;noR;^ho;^hRo_hR;noR;^ho;^hRo_hR;no"
            A$ = A$ + "R;^ho;^hRoOiTCno[_njo?7L`mO7ITaobdB;ocS=flo>eDcokDC=o_C=elo>eDcokDC=o_C=elo>eDcokDC=o_C=elo>eDcokDC="
            A$ = A$ + "o_C=elo>eDcokDC=o_C=elo>eDcokDC=o_C=elo>eDcokDC=o_C=elo>eDcokDC=ocS=fl?E@edoG=5DoC5D=moD?adoCm4Co?eC"
            A$ = A$ + "<moD?adoCm4Co?eC<moD?adoCm4Co?eC<moD?adoCm4Co?eC<moD?adoCm4Co?eC<moD?adoCm4Co?eC<moD?adoCm4Co?eC<moD"
            A$ = A$ + "?adoCm4Co?eC<moD?adoCm4CoC5D=moD?adnWHR9aOa5GlO6IT1nITA6\0000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000000000000000000000000000000000000000000000Cm4Ch:UC<m_D>adoBi4C"
            A$ = A$ + "o;UC<m_D>adoBi4Co;UC<m_D>adoBi4Co;UC<m_D>adoBi4Co;UC<m_D>adoBi4Co;UC<m_D>adoBi4Co;UC<m_D>adoBi4Co;UC"
            A$ = A$ + "<m_D>adoBi4Co;UC<m_D>adoBi4Co;UC<m_D>adoBi4Co;UC<m_D>adoBi4Co;UC<m_D>adoBi4Co;UC<m_D>adoD1UCoOeDAm_>"
            A$ = A$ + "fDcoU028o;3;\l??eDcok@3=oC3;\loJVIfoS?nho?nhSo?hP3noP3>ho3>hPo?hP3noP3>ho3>hPo?hP3noP3>ho3>hPo?hP3no"
            A$ = A$ + "P3>hoomgOoOiUGnoa;_loWk]gnO:T@boZDB9o[3=dlo>d@cok@3=o_3=dlo>d@cok@3=o_3=dlo>d@cok@3=o_3=dlo>d@cok@3="
            A$ = A$ + "o_3=dlo>d@cok@3=o_3=dlo>d@cok@3=o_3=dl?>a4co5mc?oo]gNo?k\cnoS?nho3>hPo?hP3noP3>ho3>hPo?hP3noP3>ho3>h"
            A$ = A$ + "Po?hP3noP3>ho3>hPo?hP3noP3>ho3>hPo?hP3noP3>ho3>hPo?hP3noP3>ho3>hPo?hP3noP3>ho3>hPo?hP3noP3>ho3>hPo?h"
            A$ = A$ + "P3noP3>ho3>hPo?hP3noP3>ho3>hPo?hP3noP3>ho3>hPo?hP3noP3>ho3>hPo?hP3noP3>ho3>hPo?hP3noP3>ho3>hPo?hP3no"
            A$ = A$ + "P3>ho3>hPo?hP3noP3>ho3>hPo?hP3noP3>ho3>hPo?hP3noP3>ho3>hPo?hP3noP3>ho3>hPo?hP3noP3>ho3>hPo?hP3noP3>h"
            A$ = A$ + "o3>hPo?hP3noP3>ho3>hPo?hP3noP3>ho3>hPo?hP3noP3>ho3>hPo?hP3noP3>ho3>hPo?hP3noS?nhoWNjYo_L^ifoMP16o;3;"
            A$ = A$ + "\l??eDcok@3=o_3=dlo>d@cok@3=o_3=dlo>d@cok@3=o_3=dlo>d@cok@3=o_3=dlo>d@cok@3=o_3=dlo>d@cok@3=o_3=dlo>"
            A$ = A$ + "d@cok@3=o_3=dlo>d@cok@3=o_3=dl??eDcoCmDCoKUD@moD?edoBi4Co;UC<m_D>adoBi4Co;UC<m_D>adoBi4Co;UC<m_D>ado"
            A$ = A$ + "Bi4Co;UC<m_D>adoBi4Co;UC<m_D>adoBi4Co;UC<m_D>adoBi4Co;UC<m_D>adoBi4Co;UC<m_D>adoBi4Co;UC<moD?edoBi4C"
            A$ = A$ + "kOR9V4o5GLaoITA6hWA6I`200000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000008UC;Q[D>]doBidBo;UC;m_D>]doBidBo;UC;m_D>]doBidBo;UC;m_D"
            A$ = A$ + ">]doBidBo;UC;m_D>]doBidBo;UC;m_D>]doBidBo;UC;m_D>]doBidBo;UC;m_D>]doBidBo;UC;m_D>]doBidBo;UC;m_D>]do"
            A$ = A$ + "BidBo;UC;m_D>]doBidBo;UC;m_D>]doBidBo;UC;m_D>]doBidBoC5D=moEC1eojHC=oC28QlO<\`bokDC=o[3=dlo<[\boZEFI"
            A$ = A$ + "o7NhQo?hQ7noNk]gok]gNo_gNkmoNk]gok]gNo_gNkmoNk]gok]gNo_gNkmoNk]gok]gNoOgMgmoS?nho3?l`o?^gNkoX@29oWB9"
            A$ = A$ + "UlO>d@coj@3=o[3=dl_>d@coj@3=o[3=dl_>d@coj@3=o[3=dl_>d@coj@3=o[3=dl_>d@coj@3=o[3=dl_>d@coj@3=o[3=dl_>"
            A$ = A$ + "d@cog4C<oCd?ol_gMgmo[_njo7NhQo_gNkmoNk]gok]gNo_gNkmoNk]gok]gNo_gNkmoNk]gok]gNo_gNkmoNk]gok]gNo_gNkmo"
            A$ = A$ + "Nk]gok]gNo_gNkmoNk]gok]gNo_gNkmoNk]gok]gNo_gNkmoNk]gok]gNo_gNkmoNk]gok]gNo_gNkmoNk]gok]gNo_gNkmoNk]g"
            A$ = A$ + "ok]gNo_gNkmoNk]gok]gNo_gNkmoNk]gok]gNo_gNkmoNk]gok]gNo_gNkmoNk]gok]gNo_gNkmoNk]gok]gNo_gNkmoNk]gok]g"
            A$ = A$ + "No_gNkmoNk]gok]gNo_gNkmoNk]gok]gNo_gNkmoNk]gok]gNo_gNkmoNk]gok]gNo_gNkmoNk]gok]gNo_gNkmoNk]gok]gNo_g"
            A$ = A$ + "NkmoNk]gok]gNo_gNkmoNk]gok]gNo_gNkmoNk]go7NhQo_iVKnoaiVKoc16HlO<\`bokDC=o[3=dl_>d@coj@3=o[3=dl_>d@co"
            A$ = A$ + "j@3=o[3=dl_>d@coj@3=o[3=dl_>d@coj@3=o[3=dl_>d@coj@3=o[3=dl_>d@coj@3=o[3=dl_>d@coj@3=o[3=dl_>d@cokDC="
            A$ = A$ + "o?eC<m_EBmdoCm4Co;UC;m_D>]doBidBo;UC;m_D>]doBidBo;UC;m_D>]doBidBo;UC;m_D>]doBidBo;UC;m_D>]doBidBo;UC"
            A$ = A$ + ";m_D>]doBidBo;UC;m_D>]doBidBo;UC;m_D>]doBidBo;UC;m_D>]doCm4Co;UC;]o9VDBlGLa5oWA6IPO6IT1;000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000@D=]4^AedBo7EC;mOD=]doAedBo7EC;mOD=]doAedBo7EC;mOD=]doAedBo7EC;mOD=]doAedBo7EC;mOD=]doAedB"
            A$ = A$ + "o7EC;mOD=]doAedBo7EC;mOD=]doAedBo7EC;mOD=]doAedBo7EC;mOD=]doAedBo7EC;mOD=]doAedBo7EC;mOD=]doAedBo7EC"
            A$ = A$ + ";mOD=]doAedBo7EC;moD?edoF95DoWC=el?9P4boa`2;o_3=dl_>c<coc\b:oSfHSm_gOomoOomgo_=gLoofLcmoKc=go_=gLoof"
            A$ = A$ + "LcmoKc=go_=gLoofLcmoKc=go_=gLoofLcmoJ_mfo7NhQo_k_onofFK]oS29TlO:UDboi<c<o[c<cl_>c<coj<c<o[c<cl_>c<co"
            A$ = A$ + "j<c<o[c<cl_>c<coj<c<o[c<cl_>c<coj<c<o[c<cl_>c<coj<c<o[c<cl_>c<coj<c<oO3<`lo@nhcoL_mfoWNjYo_gOomoK_mf"
            A$ = A$ + "o_=gLoofLcmoKc=go_=gLoofLcmoKc=go_=gLoofLcmoKc=go_=gLoofLcmoKc=go_=gLoofLcmoKc=go_=gLoofLcmoKc=go_=g"
            A$ = A$ + "LoofLcmoKc=go_=gLoofLcmoKc=go_=gLoofLcmoKc=go_=gLoofLcmoKc=go_=gLoofLcmoKc=go_=gLoofLcmoKc=go_=gLoof"
            A$ = A$ + "LcmoKc=go_=gLoofLcmoKc=go_=gLoofLcmoKc=go_=gLoofLcmoKc=go_=gLoofLcmoKc=go_=gLoofLcmoKc=go_=gLoofLcmo"
            A$ = A$ + "Kc=go_=gLoofLcmoKc=go_=gLoofLcmoKc=go_=gLoofLcmoKc=go_=gLoofLcmoKc=go_=gLoofLcmoKc=go_=gLoofLcmoKc=g"
            A$ = A$ + "o_=gLo_gOomoUGNio3GK]m?7HPaoa`2;o_3=dl_>c<coj<c<o[c<cl_>c<coj<c<o[c<cl_>c<coj<c<o[c<cl_>c<coj<c<o[c<"
            A$ = A$ + "cl_>c<coj<c<o[c<cl_>c<coj<c<o[c<cl_>c<coj<c<o[c<cl_>c<coj<c<o_3=dl_D>adoE5eCo;UC<mOD=]doAedBo7EC;mOD"
            A$ = A$ + "=]doAedBo7EC;mOD=]doAedBo7EC;mOD=]doAedBo7EC;mOD=]doAedBo7EC;mOD=]doAedBo7EC;mOD=]doAedBo7EC;mOD=]do"
            A$ = A$ + "AedBo7EC;mOD=]doAedBo;UC;mOD=]dnWHB9aOa5GlO6IT1nITA6\00000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000AeTBh6EC:mOD=YdoAeTBo7EC"
            A$ = A$ + ":mOD=YdoAeTBo7EC:mOD=YdoAeTBo7EC:mOD=YdoAeTBo7EC:mOD=YdoAeTBo7EC:mOD=YdoAeTBo7EC:mOD=YdoAeTBo7EC:mOD"
            A$ = A$ + "=YdoAeTBo7EC:mOD=YdoAeTBo7EC:mOD=YdoAeTBo7EC:mOD=YdoAeTBo7EC:mOD=YdoAeTBo7EC:mOD=YdoCm4CoKUD?mO>e@co"
            A$ = A$ + "T0B8o73;\l_>d@coi<c<o;3;\l?JS=foMgMgok=gLo_fJ[moJ[]fo[]fJo_fJ[moJ[]fo[]fJo_fJ[moJ[]fo[]fJo_fJ[moJ[]f"
            A$ = A$ + "oWMfIo?hP3no]gNkoG;]dn?:T@boXDB9oSc<clO>c<coi<c<oWc<clO>c<coi<c<oWc<clO>c<coi<c<oWc<clO>c<coi<c<oWc<"
            A$ = A$ + "clO>c<coi<c<oWc<clO>c<coi<c<oWc<cl_=`0co3iS?o_]fJo?jXSnoMgMgoW=fHo_fJ[moJ[]fo[]fJo_fJ[moJ[]fo[]fJo_f"
            A$ = A$ + "J[moJ[]fo[]fJo_fJ[moJ[]fo[]fJo_fJ[moJ[]fo[]fJo_fJ[moJ[]fo[]fJo_fJ[moJ[]fo[]fJo_fJ[moJ[]fo[]fJo_fJ[mo"
            A$ = A$ + "J[]fo[]fJo_fJ[moJ[]fo[]fJo_fJ[moJ[]fo[]fJo_fJ[moJ[]fo[]fJo_fJ[moJ[]fo[]fJo_fJ[moJ[]fo[]fJo_fJ[moJ[]f"
            A$ = A$ + "o[]fJo_fJ[moJ[]fo[]fJo_fJ[moJ[]fo[]fJo_fJ[moJ[]fo[]fJo_fJ[moJ[]fo[]fJo_fJ[moJ[]fo[]fJo_fJ[moJ[]fo[]f"
            A$ = A$ + "Jo_fJ[moJ[]fo[]fJo_fJ[moJ[]fo[]fJo_fJ[moJ[]fo[]fJo_fJ[moJ[]fo[]fJo_fJ[moMgMgoC^hRooK\afoLP16o73;\l_>"
            A$ = A$ + "d@coi<c<oWc<clO>c<coi<c<oWc<clO>c<coi<c<oWc<clO>c<coi<c<oWc<clO>c<coi<c<oWc<clO>c<coi<c<oWc<clO>c<co"
            A$ = A$ + "i<c<oWc<clO>c<coi<c<oWc<cl_>d@coBidBoGED>m_D>]doAeTBo7EC:mOD=YdoAeTBo7EC:mOD=YdoAeTBo7EC:mOD=YdoAeTB"
            A$ = A$ + "o7EC:mOD=YdoAeTBo7EC:mOD=YdoAeTBo7EC:mOD=YdoAeTBo7EC:mOD=YdoAeTBo7EC:mOD=YdoAeTBo7EC:m_D>YdoAeTBkOR9"
            A$ = A$ + "U4o5GLaoITA6hWA6I`2000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000005C:Q;D<Ydo@aTBo35C:m?D<Ydo@aTBo35C:m?D<Ydo@aTBo35C:m?D<Ydo"
            A$ = A$ + "@aTBo35C:m?D<Ydo@aTBo35C:m?D<Ydo@aTBo35C:m?D<Ydo@aTBo35C:m?D<Ydo@aTBo35C:m?D<Ydo@aTBo35C:m?D<Ydo@aTB"
            A$ = A$ + "o35C:m?D<Ydo@aTBo35C:m?D<Ydo@aTBo35C:m?D<Ydo@aTBo;UC<mOEAmdoi@3=oCb7PlO<[\boj<c<oWS<bl_<[\boW9VHog]f"
            A$ = A$ + "JoOgK_moIS=foW=fHoOfHSmoIS=foW=fHoOfHSmoIS=foW=fHoOfHSmoIS=foW=fHo?fGOmoOgMgoc>k\oO]c>koX<b8oS29Tl?>"
            A$ = A$ + "b8coi8S<oWS<blO>b8coi8S<oWS<blO>b8coi8S<oWS<blO>b8coi8S<oWS<blO>b8coi8S<oWS<blO>b8coi8S<oWS<blO>b8co"
            A$ = A$ + "flb;o?D?ml_fHSmoWK^ioc]fJo?fGOmoIS=foW=fHoOfHSmoIS=foW=fHoOfHSmoIS=foW=fHoOfHSmoIS=foW=fHoOfHSmoIS=f"
            A$ = A$ + "oW=fHoOfHSmoIS=foW=fHoOfHSmoIS=foW=fHoOfHSmoIS=foW=fHoOfHSmoIS=foW=fHoOfHSmoIS=foW=fHoOfHSmoIS=foW=f"
            A$ = A$ + "HoOfHSmoIS=foW=fHoOfHSmoIS=foW=fHoOfHSmoIS=foW=fHoOfHSmoIS=foW=fHoOfHSmoIS=foW=fHoOfHSmoIS=foW=fHoOf"
            A$ = A$ + "HSmoIS=foW=fHoOfHSmoIS=foW=fHoOfHSmoIS=foW=fHoOfHSmoIS=foW=fHoOfHSmoIS=foW=fHoOfHSmoIS=foW=fHoOfHSmo"
            A$ = A$ + "IS=foW=fHoOfHSmoIS=foW=fHoOfHSmoIS=focmfKoohQ7no_]fJoca5GlO<[\boj<c<oWS<blO>b8coi8S<oWS<blO>b8coi8S<"
            A$ = A$ + "oWS<blO>b8coi8S<oWS<blO>b8coi8S<oWS<blO>b8coi8S<oWS<blO>b8coi8S<oWS<blO>b8coi8S<oWS<blO>b8coj<c<o7EC"
            A$ = A$ + ";m?E@idoAedBo35C:m?D<Ydo@aTBo35C:m?D<Ydo@aTBo35C:m?D<Ydo@aTBo35C:m?D<Ydo@aTBo35C:m?D<Ydo@aTBo35C:m?D"
            A$ = A$ + "<Ydo@aTBo35C:m?D<Ydo@aTBo35C:m?D<Ydo@aTBo35C:m?D<YdoAeTBo35C:]o9VDBlGLa5oWA6IPO6IT1;0000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000D<U4^@aDBo35C9m?D<Udo@aDBo35C9m?D<Udo@aDBo35C9m?D<Udo@aDBo35C9m?D<Udo@aDBo35C9m?D<Udo@aDBo35C"
            A$ = A$ + "9m?D<Udo@aDBo35C9m?D<Udo@aDBo35C9m?D<Udo@aDBo35C9m?D<Udo@aDBo35C9m?D<Udo@aDBo35C9m?D<Udo@aDBo35C9m?D"
            A$ = A$ + "<Udo@aDBo35C9m_D>]doE5UCoS3=clo8O0bo`\b:oWc<cl?>b8coa\b:oKFHQmofIWmoK[]foO]eFooeFKmoGK]eoO]eFooeFKmo"
            A$ = A$ + "GK]eoO]eFooeFKmoGK]eoO]eFooeFKmoFGMeog=gLoojZ[nod:[\oOb8Sl?:T@bog8S<oSS<bl?>b8coh8S<oSS<bl?>b8coh8S<"
            A$ = A$ + "oSS<bl?>b8coh8S<oSS<bl?>b8coh8S<oSS<bl?>b8coh8S<oSS<bl?>b8coh8S<oGc;_l_@mdcoIS=foKNiUoOfIWmoFGMeoO]e"
            A$ = A$ + "FooeFKmoGK]eoO]eFooeFKmoGK]eoO]eFooeFKmoGK]eoO]eFooeFKmoGK]eoO]eFooeFKmoGK]eoO]eFooeFKmoGK]eoO]eFooe"
            A$ = A$ + "FKmoGK]eoO]eFooeFKmoGK]eoO]eFooeFKmoGK]eoO]eFooeFKmoGK]eoO]eFooeFKmoGK]eoO]eFooeFKmoGK]eoO]eFooeFKmo"
            A$ = A$ + "GK]eoO]eFooeFKmoGK]eoO]eFooeFKmoGK]eoO]eFooeFKmoGK]eoO]eFooeFKmoGK]eoO]eFooeFKmoGK]eoO]eFooeFKmoGK]e"
            A$ = A$ + "oO]eFooeFKmoGK]eoO]eFooeFKmoGK]eoO]eFooeFKmoGK]eoO]eFooeFKmoGK]eoO]eFooeFKmoGK]eoO]eFooeFKmoGK]eoO]e"
            A$ = A$ + "FoOfIWmoQ3>hokVJZm?7HPao`\b:oWc<cl?>b8coh8S<oSS<bl?>b8coh8S<oSS<bl?>b8coh8S<oSS<bl?>b8coh8S<oSS<bl?>"
            A$ = A$ + "b8coh8S<oSS<bl?>b8coh8S<oSS<bl?>b8coh8S<oSS<bl?>b8coh8S<oWc<clOD=YdoD1ECo7EC:m?D<Udo@aDBo35C9m?D<Udo"
            A$ = A$ + "@aDBo35C9m?D<Udo@aDBo35C9m?D<Udo@aDBo35C9m?D<Udo@aDBo35C9m?D<Udo@aDBo35C9m?D<Udo@aDBo35C9m?D<Udo@aDB"
            A$ = A$ + "o35C9m?D<Udo@aDBo7EC9m?D<UdnWHB9aOa5GlO6IT1nITA6\000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000000000000000000000000000000000000000000?]DBhndB9moC;Udo?]DBoodB9moC"
            A$ = A$ + ";Udo?]DBoodB9moC;Udo?]DBoodB9moC;Udo?]DBoodB9moC;Udo?]DBoodB9moC;Udo?]DBoodB9moC;Udo?]DBoodB9moC;Udo"
            A$ = A$ + "?]DBoodB9moC;Udo?]DBoodB9moC;Udo?]DBoodB9moC;Udo?]DBoodB9moC;Udo?]DBoodB9moC;UdoAedBoC5D>m?>c<coSha7"
            A$ = A$ + "o3S:ZlO>b8coh4C<o7S:Zl_IP1foIS=foW=fHoOeDCmoEC=eoG=eDoOeDCmoEC=eoG=eDoOeDCmoEC=eoG=eDoOeDCmoEC=eoCmd"
            A$ = A$ + "CoofK_moY[^jo;K\ano9R8boX<b8oOC<al?>a4coh4C<oSC<al?>a4coh4C<oSC<al?>a4coh4C<oSC<al?>a4coh4C<oSC<al?>"
            A$ = A$ + "a4coh4C<oSC<al?>a4coh4C<oSC<alO=^hbo2a3?oOmeGo?iTCnoHOmeoCmdCoOeDCmoEC=eoG=eDoOeDCmoEC=eoG=eDoOeDCmo"
            A$ = A$ + "EC=eoG=eDoOeDCmoEC=eoG=eDoOeDCmoEC=eoG=eDoOeDCmoEC=eoG=eDoOeDCmoEC=eoG=eDoOeDCmoEC=eoG=eDoOeDCmoEC=e"
            A$ = A$ + "oG=eDoOeDCmoEC=eoG=eDoOeDCmoEC=eoG=eDoOeDCmoEC=eoG=eDoOeDCmoEC=eoG=eDoOeDCmoEC=eoG=eDoOeDCmoEC=eoG=e"
            A$ = A$ + "DoOeDCmoEC=eoG=eDoOeDCmoEC=eoG=eDoOeDCmoEC=eoG=eDoOeDCmoEC=eoG=eDoOeDCmoEC=eoG=eDoOeDCmoEC=eoG=eDoOe"
            A$ = A$ + "DCmoEC=eoG=eDoOeDCmoEC=eoG=eDoOeDCmoEC=eoG=eDoOeDCmoEC=eoG=eDoOeDCmoHOmeoo]gNo?KYUfoLLa5o3S:ZlO>b8co"
            A$ = A$ + "h4C<oSC<al?>a4coh4C<oSC<al?>a4coh4C<oSC<al?>a4coh4C<oSC<al?>a4coh4C<oSC<al?>a4coh4C<oSC<al?>a4coh4C<"
            A$ = A$ + "oSC<al?>a4coh4C<oSC<alO>b8co@aTBo?eC=m?D<Ydo?]DBoodB9moC;Udo?]DBoodB9moC;Udo?]DBoodB9moC;Udo?]DBoodB"
            A$ = A$ + "9moC;Udo?]DBoodB9moC;Udo?]DBoodB9moC;Udo?]DBoodB9moC;Udo?]DBoodB9moC;Udo?]DBoodB9m?D<Udo?]DBkKB9U4o5"
            A$ = A$ + "GLaoITA6hWA6I`20000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000ldB8QkC;Qdo?]4BoodB8moC;Qdo?]4BoodB8moC;Qdo?]4BoodB8moC;Qdo?]4B"
            A$ = A$ + "oodB8moC;Qdo?]4BoodB8moC;Qdo?]4BoodB8moC;Qdo?]4BoodB8moC;Qdo?]4BoodB8moC;Qdo?]4BoodB8moC;Qdo?]4BoodB"
            A$ = A$ + "8moC;Qdo?]4BoodB8moC;Qdo?]4BoodB8moC;Qdo?]4Bo7EC:m?E@edog<S<o;R7Olo;ZXboh8S<oOC<al?<ZXboU16HoO]eFooe"
            A$ = A$ + "FKmoC;]do?]dBoodB;moC;]do?]dBoodB;moC;]do?]dBoodB;moC;]do?]dBo_dA7moJS=foS>jXoO\_njoV8R8oOb8Sl_=a4co"
            A$ = A$ + "g4C<oOC<alo=a4cog4C<oOC<alo=a4cog4C<oOC<alo=a4cog4C<oOC<alo=a4cog4C<oOC<alo=a4cog4C<oOC<alo=a4codhR;"
            A$ = A$ + "o7d>kl_eEGmoS;^hoO]eFo_dA7moC;]do?]dBoodB;moC;]do?]dBoodB;moC;]do?]dBoodB;moC;]do?]dBoodB;moC;]do?]d"
            A$ = A$ + "BoodB;moC;]do?]dBoodB;moC;]do?]dBoodB;moC;]do?]dBoodB;moC;]do?]dBoodB;moC;]do?]dBoodB;moC;]do?]dBood"
            A$ = A$ + "B;moC;]do?]dBoodB;moC;]do?]dBoodB;moC;]do?]dBoodB;moC;]do?]dBoodB;moC;]do?]dBoodB;moC;]do?]dBoodB;mo"
            A$ = A$ + "C;]do?]dBoodB;moC;]do?]dBoodB;moC;]do?]dBoodB;moC;]do?]dBoodB;moC;]do?]dBoodB;moC;]do?]dBoodB;moC;]d"
            A$ = A$ + "o?]dBoodB;moC;]do?]dBoodB;moC;]doO=eDoOgLcmo[Q6Jo_a5Glo;ZXboh8S<oOC<alo=a4cog4C<oOC<alo=a4cog4C<oOC<"
            A$ = A$ + "alo=a4cog4C<oOC<alo=a4cog4C<oOC<alo=a4cog4C<oOC<alo=a4cog4C<oOC<alo=a4cog4C<oOC<alo=a4coh8S<o35C9moD"
            A$ = A$ + "?ado@aDBoodB8moC;Qdo?]4BoodB8moC;Qdo?]4BoodB8moC;Qdo?]4BoodB8moC;Qdo?]4BoodB8moC;Qdo?]4BoodB8moC;Qdo"
            A$ = A$ + "?]4BoodB8moC;Qdo?]4BoodB8moC;Qdo?]4BoodB8moC;Qdo@a4BoodB8]_9UDBlGLa5oWA6IPO6IT1;00000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00PC:Q4^>Y4BokTB8m_C:Qdo>Y4BokTB8m_C:Qdo>Y4BokTB8m_C:Qdo>Y4BokTB8m_C:Qdo>Y4BokTB8m_C:Qdo>Y4BokTB8m_C"
            A$ = A$ + ":Qdo>Y4BokTB8m_C:Qdo>Y4BokTB8m_C:Qdo>Y4BokTB8m_C:Qdo>Y4BokTB8m_C:Qdo>Y4BokTB8m_C:Qdo>Y4BokTB8m_C:Qdo"
            A$ = A$ + ">Y4BokTB8m?D<YdoCmDCoOS<bl_8Mhao_TB:oSC<alo=`0co`TB:oCfGOmOeDCmoDC=eo7=d@oOd@3moA3=do7=d@oOd@3moA3=d"
            A$ = A$ + "o7=d@oOd@3moA3=do7=d@oOd@3mo@olcoOmeGooiVKno`jZ[oKB8Qlo9R8bof03<oO3<`lo=`0cog03<oO3<`lo=`0cog03<oO3<"
            A$ = A$ + "`lo=`0cog03<oO3<`lo=`0cog03<oO3<`lo=`0cog03<oO3<`lo=`0cog03<oCC;]lO@jXcoEC=eo;NhQoOeDCmo@olco7=d@oOd"
            A$ = A$ + "@3moA3=do7=d@oOd@3moA3=do7=d@oOd@3moA3=do7=d@oOd@3moA3=do7=d@oOd@3moA3=do7=d@oOd@3moA3=do7=d@oOd@3mo"
            A$ = A$ + "A3=do7=d@oOd@3moA3=do7=d@oOd@3moA3=do7=d@oOd@3moA3=do7=d@oOd@3moA3=do7=d@oOd@3moA3=do7=d@oOd@3moA3=d"
            A$ = A$ + "o7=d@oOd@3moA3=do7=d@oOd@3moA3=do7=d@oOd@3moA3=do7=d@oOd@3moA3=do7=d@oOd@3moA3=do7=d@oOd@3moA3=do7=d"
            A$ = A$ + "@oOd@3moA3=do7=d@oOd@3moA3=do7=d@oOd@3moA3=do7=d@oOd@3moA3=do7=d@oOd@3moA3=do7=d@oOd@3moA3=do7=d@oOe"
            A$ = A$ + "C?moK[]fo[fIWmo6FHao_TB:oSC<alo=`0cog03<oO3<`lo=`0cog03<oO3<`lo=`0cog03<oO3<`lo=`0cog03<oO3<`lo=`0co"
            A$ = A$ + "g03<oO3<`lo=`0cog03<oO3<`lo=`0cog03<oO3<`lo=`0cog03<oSC<aloC;UdoBi4CoodB9m_C:Qdo>Y4BokTB8m_C:Qdo>Y4B"
            A$ = A$ + "okTB8m_C:Qdo>Y4BokTB8m_C:Qdo>Y4BokTB8m_C:Qdo>Y4BokTB8m_C:Qdo>Y4BokTB8m_C:Qdo>Y4BokTB8m_C:Qdo>Y4BokTB"
            A$ = A$ + "8m_C:Qdo>Y4BooTB8m_C:QdnVDB9aOa5GlO6IT1nITA6\0000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000000000000000000000000000000000>YdAhjTB7m_C:Mdo>YdAokTB7m_C:Mdo"
            A$ = A$ + ">YdAokTB7m_C:Mdo>YdAokTB7m_C:Mdo>YdAokTB7m_C:Mdo>YdAokTB7m_C:Mdo>YdAokTB7m_C:Mdo>YdAokTB7m_C:Mdo>YdA"
            A$ = A$ + "okTB7m_C:Mdo>YdAokTB7m_C:Mdo>YdAokTB7m_C:Mdo>YdAokTB7m_C:Mdo>YdAokTB7m_C:Mdo@aDBo?eC<mo=b4coRdQ7okB:"
            A$ = A$ + "Ylo=a4cof03<ooB:YloHNieoC;]do?]dBooc>klo?k\coo\c>ooc>klo?k\coo\c>ooc>klo?k\coo\c>ooc>klo?k\cokLc=o_e"
            A$ = A$ + "EGmoUGNiooJ[]n_9Q4boV8R8oG3<`l_=`0cof03<oK3<`l_=`0cof03<oK3<`l_=`0cof03<oK3<`l_=`0cof03<oK3<`l_=`0co"
            A$ = A$ + "f03<oK3<`l_=`0cof03<oK3<`lo<]dbo0YS>o?]dBo?hOomoC;]dokLc=ooc>klo?k\coo\c>ooc>klo?k\coo\c>ooc>klo?k\c"
            A$ = A$ + "oo\c>ooc>klo?k\coo\c>ooc>klo?k\coo\c>ooc>klo?k\coo\c>ooc>klo?k\coo\c>ooc>klo?k\coo\c>ooc>klo?k\coo\c"
            A$ = A$ + ">ooc>klo?k\coo\c>ooc>klo?k\coo\c>ooc>klo?k\coo\c>ooc>klo?k\coo\c>ooc>klo?k\coo\c>ooc>klo?k\coo\c>ooc"
            A$ = A$ + ">klo?k\coo\c>ooc>klo?k\coo\c>ooc>klo?k\coo\c>ooc>klo?k\coo\c>ooc>klo?k\coo\c>ooc>klo?k\coo\c>ooc>klo"
            A$ = A$ + "?k\coo\c>ooc>klo?k\coo\c>ooc>klo?k\coo\c>ooc>klo?k\coo\c>ooc>kloC;]doW=fHoOJVIfoKHQ5okB:Ylo=a4cof03<"
            A$ = A$ + "oK3<`l_=`0cof03<oK3<`l_=`0cof03<oK3<`l_=`0cof03<oK3<`l_=`0cof03<oK3<`l_=`0cof03<oK3<`l_=`0cof03<oK3<"
            A$ = A$ + "`l_=`0cof03<oK3<`lo=a4co?]4Bo;UC;moC;Qdo>YdAokTB7m_C:Mdo>YdAokTB7m_C:Mdo>YdAokTB7m_C:Mdo>YdAokTB7m_C"
            A$ = A$ + ":Mdo>YdAokTB7m_C:Mdo>YdAokTB7m_C:Mdo>YdAokTB7m_C:Mdo>YdAokTB7m_C:Mdo>YdAokTB7moC:Mdo>YdAkKB9U4o5GLao"
            A$ = A$ + "ITA6hWA6I`200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000dDB7QKC9Mdo=UdAogDB7mOC9Mdo=UdAogDB7mOC9Mdo=UdAogDB7mOC9Mdo=UdAogDB"
            A$ = A$ + "7mOC9Mdo=UdAogDB7mOC9Mdo=UdAogDB7mOC9Mdo=UdAogDB7mOC9Mdo=UdAogDB7mOC9Mdo=UdAogDB7mOC9Mdo=UdAogDB7mOC"
            A$ = A$ + "9Mdo=UdAogDB7mOC9Mdo=UdAogDB7mOC9Mdo=UdAoodB9m_D>adog8C<o;R7Nl_;YTbog4C<oK3<`lo;YTboReEGo3=d@oOd@3mo"
            A$ = A$ + "=c<cog<c<oOc<clo=c<cog<c<oOc<clo=c<cog<c<oOc<clo=c<cog<c<o?c;_loEC=eoC>iTo_[\bjoV4B8oKR8RlO=`0cof03<"
            A$ = A$ + "oK3<`l_=`0cof03<oK3<`l_=`0cof03<oK3<`l_=`0cof03<oK3<`l_=`0cof03<oK3<`l_=`0cof03<oK3<`l_=`0cocdB;o3T>"
            A$ = A$ + "jl_dA7moOk]go7mc?o?c;_lo=c<cog<c<oOc<clo=c<cog<c<oOc<clo=c<cog<c<oOc<clo=c<cog<c<oOc<clo=c<cog<c<oOc"
            A$ = A$ + "<clo=c<cog<c<oOc<clo=c<cog<c<oOc<clo=c<cog<c<oOc<clo=c<cog<c<oOc<clo=c<cog<c<oOc<clo=c<cog<c<oOc<clo"
            A$ = A$ + "=c<cog<c<oOc<clo=c<cog<c<oOc<clo=c<cog<c<oOc<clo=c<cog<c<oOc<clo=c<cog<c<oOc<clo=c<cog<c<oOc<clo=c<c"
            A$ = A$ + "og<c<oOc<clo=c<cog<c<oOc<clo=c<cog<c<oOc<clo=c<cog<c<oOc<clo=c<cog<c<oOc<clo=c<cog<c<oOc<clo=c<cog<c"
            A$ = A$ + "<oOc<clo=c<cog<c<oOc<clo=c<co7=d@o_eFKmoXEFIo_Q5Fl_;YTbog4C<oK3<`l_=`0cof03<oK3<`l_=`0cof03<oK3<`l_="
            A$ = A$ + "`0cof03<oK3<`l_=`0cof03<oK3<`l_=`0cof03<oK3<`l_=`0cof03<oK3<`l_=`0cof03<oK3<`l_=`0cog4C<okTB8mOD=]do"
            A$ = A$ + ">Y4BogDB7mOC9Mdo=UdAogDB7mOC9Mdo=UdAogDB7mOC9Mdo=UdAogDB7mOC9Mdo=UdAogDB7mOC9Mdo=UdAogDB7mOC9Mdo=UdA"
            A$ = A$ + "ogDB7mOC9Mdo=UdAogDB7mOC9Mdo=UdAogDB7mOC9Mdo>UdAogDB7]_9UDBlGLa5oWA6IPO6IT1;000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000@C"
            A$ = A$ + "9I4^=UTAogDB6mOC9Ido=UTAogDB6mOC9Ido=UTAogDB6mOC9Ido=UTAogDB6mOC9Ido=UTAogDB6mOC9Ido=UTAogDB6mOC9Ido"
            A$ = A$ + "=UTAogDB6mOC9Ido=UTAogDB6mOC9Ido=UTAogDB6mOC9Ido=UTAogDB6mOC9Ido=UTAogDB6mOC9Ido=UTAogDB6mOC9Ido=UTA"
            A$ = A$ + "ogDB6moC;QdoBidBoKS<alO8Nhao]P2:oK3<`lO=_lbo^P2:o76GLmoc>klo@gLco_\b:oob:[lo;[\bo_\b:oob:[lo;[\bo_\b"
            A$ = A$ + ":oob:[lo;[\bo_\b:oob:[lo:WLbo;]dBo_hR;no]^jZoGB8Ql_9Q4boelb;oGc;_lO=_lboelb;oGc;_lO=_lboelb;oGc;_lO="
            A$ = A$ + "_lboelb;oGc;_lO=_lboelb;oGc;_lO=_lboelb;oGc;_lO=_lboelb;o;3;\lo?iTco@3=dogMgMo_c>klo:WLbo_\b:oob:[lo"
            A$ = A$ + ";[\bo_\b:oob:[lo;[\bo_\b:oob:[lo;[\bo_\b:oob:[lo;[\bo_\b:oob:[lo;[\bo_\b:oob:[lo;[\bo_\b:oob:[lo;[\b"
            A$ = A$ + "o_\b:oob:[lo;[\bo_\b:oob:[lo;[\bo_\b:oob:[lo;[\bo_\b:oob:[lo;[\bo_\b:oob:[lo;[\bo_\b:oob:[lo;[\bo_\b"
            A$ = A$ + ":oob:[lo;[\bo_\b:oob:[lo;[\bo_\b:oob:[lo;[\bo_\b:oob:[lo;[\bo_\b:oob:[lo;[\bo_\b:oob:[lo;[\bo_\b:oob"
            A$ = A$ + ":[lo;[\bo_\b:oob:[lo;[\bo_\b:oob:[lo;[\bo_\b:oob:[lo;[\bo_\b:oob:[lo;[\bo_\b:oob:[lo;[\bo_\b:ooc>klo"
            A$ = A$ + "EC=eoO6ITm_6FHao]P2:oK3<`lO=_lboelb;oGc;_lO=_lboelb;oGc;_lO=_lboelb;oGc;_lO=_lboelb;oGc;_lO=_lboelb;"
            A$ = A$ + "oGc;_lO=_lboelb;oGc;_lO=_lboelb;oGc;_lO=_lboelb;oK3<`l_C:MdoAeTBokTB7mOC9Ido=UTAogDB6mOC9Ido=UTAogDB"
            A$ = A$ + "6mOC9Ido=UTAogDB6mOC9Ido=UTAogDB6mOC9Ido=UTAogDB6mOC9Ido=UTAogDB6mOC9Ido=UTAogDB6mOC9Ido=UTAogDB6mOC"
            A$ = A$ + "9Ido=UTAokDB6mOC9IdnVD29aOa5GlO6IT1nITA6\00000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000<QTAhb4B6m?C8Ido<QTAoc4B6m?C8Ido<QTA"
            A$ = A$ + "oc4B6m?C8Ido<QTAoc4B6m?C8Ido<QTAoc4B6m?C8Ido<QTAoc4B6m?C8Ido<QTAoc4B6m?C8Ido<QTAoc4B6m?C8Ido<QTAoc4B"
            A$ = A$ + "6m?C8Ido<QTAoc4B6m?C8Ido<QTAoc4B6m?C8Ido<QTAoc4B6m?C8Ido<QTAoc4B6m?C8Ido>Y4Bo7EC;m_=b4coQhQ7og2:Xl_="
            A$ = A$ + "`0coelb;ok2:XloGK]eo=_lbok<c<oOb8Slo9S<boW<b8oOb8Slo9S<boW<b8oOb8Slo9S<boW<b8oOb8Slo9S<boSla7oOd@3mo"
            A$ = A$ + "Q7Nho_ZZZnO9Q4boV4B8oGc;_lO=_lboelb;oGc;_lO=_lboelb;oGc;_lO=_lboelb;oGc;_lO=_lboelb;oGc;_lO=_lboelb;"
            A$ = A$ + "oGc;_lO=_lboelb;oGc;_l_<\`booTC>oo\c>o?gK_mo=c<coSla7oOb8Slo9S<boW<b8oOb8Slo9S<boW<b8oOb8Slo9S<boW<b"
            A$ = A$ + "8oOb8Slo9S<boW<b8oOb8Slo9S<boW<b8oOb8Slo9S<boW<b8oOb8Slo9S<boW<b8oOb8Slo9S<boW<b8oOb8Slo9S<boW<b8oOb"
            A$ = A$ + "8Slo9S<boW<b8oOb8Slo9S<boW<b8oOb8Slo9S<boW<b8oOb8Slo9S<boW<b8oOb8Slo9S<boW<b8oOb8Slo9S<boW<b8oOb8Slo"
            A$ = A$ + "9S<boW<b8oOb8Slo9S<boW<b8oOb8Slo9S<boW<b8oOb8Slo9S<boW<b8oOb8Slo9S<boW<b8oOb8Slo9S<boW<b8oOb8Slo9S<b"
            A$ = A$ + "oW<b8oOb8Slo9S<boW<b8oOb8Slo9S<boW<b8oOb8Slo9S<boW<b8oOb8Slo=c<coCMdAooIS=foJHQ5og2:Xl_=`0coelb;oGc;"
            A$ = A$ + "_lO=_lboelb;oGc;_lO=_lboelb;oGc;_lO=_lboelb;oGc;_lO=_lboelb;oGc;_lO=_lboelb;oGc;_lO=_lboelb;oGc;_lO="
            A$ = A$ + "_lboelb;oGc;_l_=`0co=UdAo35C:mOC9Mdo<QTAoc4B6m?C8Ido<QTAoc4B6m?C8Ido<QTAoc4B6m?C8Ido<QTAoc4B6m?C8Ido"
            A$ = A$ + "<QTAoc4B6m?C8Ido<QTAoc4B6m?C8Ido<QTAoc4B6m?C8Ido<QTAoc4B6m?C8Ido<QTAoc4B6mOC8Ido<QTAkKB9T4o5GLaoITA6"
            A$ = A$ + "hWA6I`2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000`4B6Q;C8Ido<QTAoc4B6m?C8Ido<QTAoc4B6m?C8Ido<QTAoc4B6m?C8Ido<QTAoc4B6m?C"
            A$ = A$ + "8Ido<QTAoc4B6m?C8Ido<QTAoc4B6m?C8Ido<QTAoc4B6m?C8Ido<QTAoc4B6m?C8Ido<QTAoc4B6m?C8Ido<QTAoc4B6m?C8Ido"
            A$ = A$ + "<QTAoc4B6m?C8Ido<QTAoc4B6m?C8Ido<QTAokTB8mOD=]doe43<o3B7Ml?;WLboelb;oCS;^lO;WLboOYUFoc\b:o?c;_lo7GLa"
            A$ = A$ + "oOLa5ooa5Glo7GLaoOLa5ooa5Glo7GLaoOLa5ooa5Glo7GLaoOLa5oOa4Clo@olco3>hPo_ZYVjoT028oG28Pl?=^hbodhR;oCS;"
            A$ = A$ + "^l?=^hbodhR;oCS;^l?=^hbodhR;oCS;^l?=^hbodhR;oCS;^l?=^hbodhR;oCS;^l?=^hbodhR;oCS;^l?=^hboa\b:ok3>hl_c"
            A$ = A$ + "=gloK[]foclb;oOa4Clo7GLaoOLa5ooa5Glo7GLaoOLa5ooa5Glo7GLaoOLa5ooa5Glo7GLaoOLa5ooa5Glo7GLaoOLa5ooa5Glo"
            A$ = A$ + "7GLaoOLa5ooa5Glo7GLaoOLa5ooa5Glo7GLaoOLa5ooa5Glo7GLaoOLa5ooa5Glo7GLaoOLa5ooa5Glo7GLaoOLa5ooa5Glo7GLa"
            A$ = A$ + "oOLa5ooa5Glo7GLaoOLa5ooa5Glo7GLaoOLa5ooa5Glo7GLaoOLa5ooa5Glo7GLaoOLa5ooa5Glo7GLaoOLa5ooa5Glo7GLaoOLa"
            A$ = A$ + "5ooa5Glo7GLaoOLa5ooa5Glo7GLaoOLa5ooa5Glo7GLaoOLa5ooa5Glo7GLaoOLa5ooa5Glo7GLaoOLa5ooa5Glo7GLaoOLa5ooa"
            A$ = A$ + "5Glo7GLaoOLa5ooa5Glo7GLao_\b:o_d@3moU9VHoWA5El?;WLboelb;oCS;^l?=^hbodhR;oCS;^l?=^hbodhR;oCS;^l?=^hbo"
            A$ = A$ + "dhR;oCS;^l?=^hbodhR;oCS;^l?=^hbodhR;oCS;^l?=^hbodhR;oCS;^l?=^hbodhR;oCS;^l?=^hboelb;ogDB7m?D<Ydo=UdA"
            A$ = A$ + "oc4B6m?C8Ido<QTAoc4B6m?C8Ido<QTAoc4B6m?C8Ido<QTAoc4B6m?C8Ido<QTAoc4B6m?C8Ido<QTAoc4B6m?C8Ido<QTAoc4B"
            A$ = A$ + "6m?C8Ido<QTAoc4B6m?C8Ido<QTAoc4B6m?C8Ido=QTAoc4B6]_9U@BlGLa5oWA6IPO6IT1;0000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000`B7E4^"
            A$ = A$ + ";MDAo_dA5moB7Edo;MDAo_dA5moB7Edo;MDAo_dA5moB7Edo;MDAo_dA5moB7Edo;MDAo_dA5moB7Edo;MDAo_dA5moB7Edo;MDA"
            A$ = A$ + "o_dA5moB7Edo;MDAo_dA5moB7Edo;MDAo_dA5moB7Edo;MDAo_dA5moB7Edo;MDAo_dA5moB7Edo;MDAo_dA5moB7Edo;MDAo_dA"
            A$ = A$ + "5mOC9Mdo@aTBoGC<`lO8Mdao\Lb9oGc;_l?=^hbo\Lb9okEFIm_b9Wlo:WLboCl`3o?a3?lo4?l`oCl`3o?a3?lo4?l`oCl`3o?a"
            A$ = A$ + "3?lo4?l`oCl`3o?a3?lo3;\`okLc=o_gNkmoYNjYoC28PlO9P0bodhR;oCS;^l?=^hbodhR;oCS;^l?=^hbodhR;oCS;^l?=^hbo"
            A$ = A$ + "dhR;oCS;^l?=^hbodhR;oCS;^l?=^hbodhR;oCS;^l?=^hbodhR;o7c:[l_?hPco<c<coWMfIo_b9Wlo3;\`oCl`3o?a3?lo4?l`"
            A$ = A$ + "oCl`3o?a3?lo4?l`oCl`3o?a3?lo4?l`oCl`3o?a3?lo4?l`oCl`3o?a3?lo4?l`oCl`3o?a3?lo4?l`oCl`3o?a3?lo4?l`oCl`"
            A$ = A$ + "3o?a3?lo4?l`oCl`3o?a3?lo4?l`oCl`3o?a3?lo4?l`oCl`3o?a3?lo4?l`oCl`3o?a3?lo4?l`oCl`3o?a3?lo4?l`oCl`3o?a"
            A$ = A$ + "3?lo4?l`oCl`3o?a3?lo4?l`oCl`3o?a3?lo4?l`oCl`3o?a3?lo4?l`oCl`3o?a3?lo4?l`oCl`3o?a3?lo4?l`oCl`3o?a3?lo"
            A$ = A$ + "4?l`oCl`3o?a3?lo4?l`oCl`3o?a3?lo4?l`oCl`3o?a3?lo4?l`oCl`3o?a3?lo4?l`oCl`3o?a3?lo4?l`oCl`3oOb8Slo?olc"
            A$ = A$ + "oGFHQmO6EDao\Lb9oGc;_l?=^hbodhR;oCS;^l?=^hbodhR;oCS;^l?=^hbodhR;oCS;^l?=^hbodhR;oCS;^l?=^hbodhR;oCS;"
            A$ = A$ + "^l?=^hbodhR;oCS;^l?=^hbodhR;oCS;^l?=^hbodhR;oGc;_l?C8Ido?]DBoc4B6moB7Edo;MDAo_dA5moB7Edo;MDAo_dA5moB"
            A$ = A$ + "7Edo;MDAo_dA5moB7Edo;MDAo_dA5moB7Edo;MDAo_dA5moB7Edo;MDAo_dA5moB7Edo;MDAo_dA5moB7Edo;MDAo_dA5moB7Edo"
            A$ = A$ + ";MDAocdA5moB7EdnUD29aOa5GlO6IT1nITA6\000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000000000000000000000000000000;MDAh^dA5moB7Edo;MDAo_dA5moB7Edo;MDAo_dA"
            A$ = A$ + "5moB7Edo;MDAo_dA5moB7Edo;MDAo_dA5moB7Edo;MDAo_dA5moB7Edo;MDAo_dA5moB7Edo;MDAo_dA5moB7Edo;MDAo_dA5moB"
            A$ = A$ + "7Edo;MDAo_dA5moB7Edo;MDAo_dA5moB7Edo;MDAo_dA5moB7Edo;MDAo_dA5moB7Edo=UdAo35C:mO=`0coQ`17ocR9Vl?=^hbo"
            A$ = A$ + "cdB;ocR9VlOGHQeo7GLaoOLa5oO`03lo13<`o7<`0oO`03lo13<`o7<`0oO`03lo13<`o7<`0oO`03lo13<`o3l_on?c;_loMc=g"
            A$ = A$ + "oSZYVn?9OlaoUla7o?C;]lo<]dbocdB;o?C;]lo<]dbocdB;o?C;]lo<]dbocdB;o?C;]lo<]dbocdB;o?C;]lo<]dbocdB;o?C;"
            A$ = A$ + "]lo<]dbocdB;o?C;]l?<ZXbomLc=o_Lb9o?fFKmo7Olao3l_onO`03lo13<`o7<`0oO`03lo13<`o7<`0oO`03lo13<`o7<`0oO`"
            A$ = A$ + "03lo13<`o7<`0oO`03lo13<`o7<`0oO`03lo13<`o7<`0oO`03lo13<`o7<`0oO`03lo13<`o7<`0oO`03lo13<`o7<`0oO`03lo"
            A$ = A$ + "13<`o7<`0oO`03lo13<`o7<`0oO`03lo13<`o7<`0oO`03lo13<`o7<`0oO`03lo13<`o7<`0oO`03lo13<`o7<`0oO`03lo13<`"
            A$ = A$ + "o7<`0oO`03lo13<`o7<`0oO`03lo13<`o7<`0oO`03lo13<`o7<`0oO`03lo13<`o7<`0oO`03lo13<`o7<`0oO`03lo13<`o7<`"
            A$ = A$ + "0oO`03lo13<`o7<`0oO`03lo13<`o7<`0oO`03lo13<`o7<`0oO`03lo7C<aoc<c<o?IOmeoJDA5ocR9Vl?=^hbocdB;o?C;]lo<"
            A$ = A$ + "]dbocdB;o?C;]lo<]dbocdB;o?C;]lo<]dbocdB;o?C;]lo<]dbocdB;o?C;]lo<]dbocdB;o?C;]lo<]dbocdB;o?C;]lo<]dbo"
            A$ = A$ + "cdB;o?C;]l?=^hbo<QTAoodB9m?C8Ido;MDAo_dA5moB7Edo;MDAo_dA5moB7Edo;MDAo_dA5moB7Edo;MDAo_dA5moB7Edo;MDA"
            A$ = A$ + "o_dA5moB7Edo;MDAo_dA5moB7Edo;MDAo_dA5moB7Edo;MDAo_dA5moB7Edo;MDAo_dA5moB7Edo;MDAkGB9T4o5GLaoITA6hWA6"
            A$ = A$ + "I`20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000XTA4Q[B6Ado:I4Ao[TA4m_B6Ado:I4Ao[TA4m_B6Ado:I4Ao[TA4m_B6Ado:I4Ao[TA4m_B6Ado"
            A$ = A$ + ":I4Ao[TA4m_B6Ado:I4Ao[TA4m_B6Ado:I4Ao[TA4m_B6Ado:I4Ao[TA4m_B6Ado:I4Ao[TA4m_B6Ado:I4Ao[TA4m_B6Ado:I4A"
            A$ = A$ + "o[TA4m_B6Ado:I4Ao[TA4m_B6Ado:I4Aoc4B6moC;Udod0c;o727Ll?;VHbodhR;o?C;]l?;VHboLMeEo?\`2oo`2;lonfK_okK_"
            A$ = A$ + "mn__mfkonfK_okK_mn__mfkonfK_okK_mn__mfkonfK_okK_mnO_lbko:S<bo_mfKooYTBjoTla7oGb7Olo<]dbocdB;o?C;]lo<"
            A$ = A$ + "]dbocdB;o?C;]lo<]dbocdB;o?C;]lo<]dbocdB;o?C;]lo<]dbocdB;o?C;]lo<]dbocdB;o?C;]lo<]dbo`XR:ogc=gl_b8Slo"
            A$ = A$ + "FGMeoC<a4oO_lbkonfK_okK_mn__mfkonfK_okK_mn__mfkonfK_okK_mn__mfkonfK_okK_mn__mfkonfK_okK_mn__mfkonfK_"
            A$ = A$ + "okK_mn__mfkonfK_okK_mn__mfkonfK_okK_mn__mfkonfK_okK_mn__mfkonfK_okK_mn__mfkonfK_okK_mn__mfkonfK_okK_"
            A$ = A$ + "mn__mfkonfK_okK_mn__mfkonfK_okK_mn__mfkonfK_okK_mn__mfkonfK_okK_mn__mfkonfK_okK_mn__mfkonfK_okK_mn__"
            A$ = A$ + "mfkonfK_okK_mn__mfkonfK_okK_mn__mfkonfK_okK_mn__mfkonfK_okK_mn__mfkonfK_okK_mn__mfkonfK_okK_mn__mfko"
            A$ = A$ + "nfK_okK_mn__mfkonfK_oCL`1o_b8SloSmeGo[A5El?;VHbodhR;o?C;]lo<]dbocdB;o?C;]lo<]dbocdB;o?C;]lo<]dbocdB;"
            A$ = A$ + "o?C;]lo<]dbocdB;o?C;]lo<]dbocdB;o?C;]lo<]dbocdB;o?C;]lo<]dbocdB;o?C;]lo<]dbodhR;o_dA5m_C:Qdo;MDAo[TA"
            A$ = A$ + "4m_B6Ado:I4Ao[TA4m_B6Ado:I4Ao[TA4m_B6Ado:I4Ao[TA4m_B6Ado:I4Ao[TA4m_B6Ado:I4Ao[TA4m_B6Ado:I4Ao[TA4m_B"
            A$ = A$ + "6Ado:I4Ao[TA4m_B6Ado:I4Ao[TA4m_B6Ado:I4Ao[TA4]O9T@BlGLa5oWA6IPO6IT1;00000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000PB6A4^:I4A"
            A$ = A$ + "o[TA4m_B6Ado:I4Ao[TA4m_B6Ado:I4Ao[TA4m_B6Ado:I4Ao[TA4m_B6Ado:I4Ao[TA4m_B6Ado:I4Ao[TA4m_B6Ado:I4Ao[TA"
            A$ = A$ + "4m_B6Ado:I4Ao[TA4m_B6Ado:I4Ao[TA4m_B6Ado:I4Ao[TA4m_B6Ado:I4Ao[TA4m_B6Ado:I4Ao[TA4m_B6Ado:I4Ao[TA4m?C"
            A$ = A$ + "8Ido?]DBoC3<_l?8L`ao[HR9o?C;]l_<\`bo\DB9o_UEFmO`17lo17L`og;_lnO_lbkomb;_og;_lnO_lbkomb;_og;_lnO_lbko"
            A$ = A$ + "mb;_og;_lnO_lbkol^k^oOla7oOfJ[moUB:Yo?b7Ol?9Olaob`2;o;3;\l_<\`bob`2;o;3;\l_<\`bob`2;o;3;\l_<\`bob`2;"
            A$ = A$ + "o;3;\l_<\`bob`2;o;3;\l_<\`bob`2;o;3;\l_<\`bob`2;ooB:Yl??fHco8OlaoC=eDoo`2;lol^k^og;_lnO_lbkomb;_og;_"
            A$ = A$ + "lnO_lbkomb;_og;_lnO_lbkomb;_og;_lnO_lbkomb;_og;_lnO_lbkomb;_og;_lnO_lbkomb;_og;_lnO_lbkomb;_og;_lnO_"
            A$ = A$ + "lbkomb;_og;_lnO_lbkomb;_og;_lnO_lbkomb;_og;_lnO_lbkomb;_og;_lnO_lbkomb;_og;_lnO_lbkomb;_og;_lnO_lbko"
            A$ = A$ + "mb;_og;_lnO_lbkomb;_og;_lnO_lbkomb;_og;_lnO_lbkomb;_og;_lnO_lbkomb;_og;_lnO_lbkomb;_og;_lnO_lbkomb;_"
            A$ = A$ + "og;_lnO_lbkomb;_og;_lnO_lbkomb;_og;_lnO_lbkomb;_og;_lnO_lbkomb;_og;_lnO_lbkomb;_og;_ln_`03lo9Olao7fG"
            A$ = A$ + "OmO6EDao[HR9o?C;]l_<\`bob`2;o;3;\l_<\`bob`2;o;3;\l_<\`bob`2;o;3;\l_<\`bob`2;o;3;\l_<\`bob`2;o;3;\l_<"
            A$ = A$ + "\`bob`2;o;3;\l_<\`bob`2;o;3;\l_<\`bob`2;o?C;]loB7Edo>Y4Bo_dA5m_B6Ado:I4Ao[TA4m_B6Ado:I4Ao[TA4m_B6Ado"
            A$ = A$ + ":I4Ao[TA4m_B6Ado:I4Ao[TA4m_B6Ado:I4Ao[TA4m_B6Ado:I4Ao[TA4m_B6Ado:I4Ao[TA4m_B6Ado:I4Ao[TA4m_B6Ado:I4A"
            A$ = A$ + "o[TA4m_B6AdnU@29aOa5GlO6IT1nITA6\0000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000000000000000000000000009Ed@hVDA3mOB5=do9Ed@oWDA3mOB5=do9Ed@oWDA3mOB"
            A$ = A$ + "5=do9Ed@oWDA3mOB5=do9Ed@oWDA3mOB5=do9Ed@oWDA3mOB5=do9Ed@oWDA3mOB5=do9Ed@oWDA3mOB5=do9Ed@oWDA3mOB5=do"
            A$ = A$ + "9Ed@oWDA3mOB5=do9Ed@oWDA3mOB5=do9Ed@oWDA3mOB5=do9Ed@oWDA3mOB5=do;MDAokTB8mo<`lboO`17o[R9Vl_<]dboa`2;"
            A$ = A$ + "o_B9Ul_FFIeo0ok_o3l_ono^jZkokZ[^o_[^jno^jZkokZ[^o_[^jno^jZkokZ[^o_[^jno^jZkokZ[^o[K^inOa4CloHS=foCZX"
            A$ = A$ + "Rn_8OlaoSla7o73;\lO<\`boa`2;o73;\lO<\`boa`2;o73;\lO<\`boa`2;o73;\lO<\`boa`2;o73;\lO<\`boa`2;o73;\lO<"
            A$ = A$ + "\`boa`2;o73;\l_;YTbokHS=oO<a4oodB;mo13<`o[K^ino^jZkokZ[^o_[^jno^jZkokZ[^o_[^jno^jZkokZ[^o_[^jno^jZko"
            A$ = A$ + "kZ[^o_[^jno^jZkokZ[^o_[^jno^jZkokZ[^o_[^jno^jZkokZ[^o_[^jno^jZkokZ[^o_[^jno^jZkokZ[^o_[^jno^jZkokZ[^"
            A$ = A$ + "o_[^jno^jZkokZ[^o_[^jno^jZkokZ[^o_[^jno^jZkokZ[^o_[^jno^jZkokZ[^o_[^jno^jZkokZ[^o_[^jno^jZkokZ[^o_[^"
            A$ = A$ + "jno^jZkokZ[^o_[^jno^jZkokZ[^o_[^jno^jZkokZ[^o_[^jno^jZkokZ[^o_[^jno^jZkokZ[^o_[^jno^jZkokZ[^o_[^jno^"
            A$ = A$ + "jZkokZ[^o_[^jno^jZkokZ[^o_[^jno^jZkokZ[^o_[^jno^jZko0k[_oO<a4o?HNieoHDA5o[R9Vl_<]dboa`2;o73;\lO<\`bo"
            A$ = A$ + "a`2;o73;\lO<\`boa`2;o73;\lO<\`boa`2;o73;\lO<\`boa`2;o73;\lO<\`boa`2;o73;\lO<\`boa`2;o73;\lO<\`boa`2;"
            A$ = A$ + "o73;\l_<]dbo:I4AogDB7m_B6Ado9Ed@oWDA3mOB5=do9Ed@oWDA3mOB5=do9Ed@oWDA3mOB5=do9Ed@oWDA3mOB5=do9Ed@oWDA"
            A$ = A$ + "3mOB5=do9Ed@oWDA3mOB5=do9Ed@oWDA3mOB5=do9Ed@oWDA3mOB5=do9Ed@oWDA3mOB5=do9Ed@kG29S4o5GLaoITA6hWA6I`20"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000PDA3Q;B5=do8Ed@oSDA3m?B5=do8Ed@oSDA3m?B5=do8Ed@oSDA3m?B5=do8Ed@oSDA3m?B5=do8Ed@"
            A$ = A$ + "oSDA3m?B5=do8Ed@oSDA3m?B5=do8Ed@oSDA3m?B5=do8Ed@oSDA3m?B5=do8Ed@oSDA3m?B5=do8Ed@oSDA3m?B5=do8Ed@oSDA"
            A$ = A$ + "3m?B5=do8Ed@oSDA3m?B5=do8Ed@o[dA5mOC:QdoblR;ooa6Kl_:UDbob`2;o7c:[lo:UDboIEEEooK_mno_mfkoiR;^oW;^hnO^"
            A$ = A$ + "hRkoiR;^oW;^hnO^hRkoiR;^oW;^hnO^hRkoiR;^oW;^hn?^fJko4?l`oO]eFooXQ6joRhQ7o?R7NlO<[\boa\b:o7c:[lO<[\bo"
            A$ = A$ + "a\b:o7c:[lO<[\boa\b:o7c:[lO<[\boa\b:o7c:[lO<[\boa\b:o7c:[lO<[\boa\b:o7c:[lO<[\bo^P2:o[C=elOa3?loB7Md"
            A$ = A$ + "oo[_nn?^gNkoiR;^oW;^hnO^hRkoiR;^oW;^hnO^hRkoiR;^oW;^hnO^hRkoiR;^oW;^hnO^hRkoiR;^oW;^hnO^hRkoiR;^oW;^"
            A$ = A$ + "hnO^hRkoiR;^oW;^hnO^hRkoiR;^oW;^hnO^hRkoiR;^oW;^hnO^hRkoiR;^oW;^hnO^hRkoiR;^oW;^hnO^hRkoiR;^oW;^hnO^"
            A$ = A$ + "hRkoiR;^oW;^hnO^hRkoiR;^oW;^hnO^hRkoiR;^oW;^hnO^hRkoiR;^oW;^hnO^hRkoiR;^oW;^hnO^hRkoiR;^oW;^hnO^hRko"
            A$ = A$ + "iR;^oW;^hnO^hRkoiR;^oW;^hnO^hRkoiR;^oW;^hnO^hRkoiR;^oW;^hnO^hRkoiR;^oW;^hnO^hRkoiR;^oW;^hnO^hRkoiR;^"
            A$ = A$ + "oW;^hnO^hRkoiR;^okK_mn?a2;loOeEGoS15Dl_:UDbob`2;o7c:[lO<[\boa\b:o7c:[lO<[\boa\b:o7c:[lO<[\boa\b:o7c:"
            A$ = A$ + "[lO<[\boa\b:o7c:[lO<[\boa\b:o7c:[lO<[\boa\b:o7c:[lO<[\boa\b:o7c:[lO<[\bob`2;oWTA4m?C9Mdo9I4AoSDA3m?B"
            A$ = A$ + "5=do8Ed@oSDA3m?B5=do8Ed@oSDA3m?B5=do8Ed@oSDA3m?B5=do8Ed@oSDA3m?B5=do8Ed@oSDA3m?B5=do8Ed@oSDA3m?B5=do"
            A$ = A$ + "8Ed@oSDA3m?B5=do8Ed@oSDA3m?B5=do8Ed@oSDA3]O9T<BlGLa5oWA6IPO6HP1;000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000B494^8AT@oS4A"
            A$ = A$ + "2m?B49do8AT@oS4A2m?B49do8AT@oS4A2m?B49do8AT@oS4A2m?B49do8AT@oS4A2m?B49do8AT@oS4A2m?B49do8AT@oS4A2m?B"
            A$ = A$ + "49do8AT@oS4A2m?B49do8AT@oS4A2m?B49do8AT@oS4A2m?B49do8AT@oS4A2m?B49do8AT@oS4A2m?B49do8AT@oS4A2m_B6Ado"
            A$ = A$ + "=UdAo;c;^l_7K\aoYDB9o73;\l?<[\boZDB9oS5EDm?_jZkolZ[^oKK]en_]eFkofFK]oKK]en_]eFkofFK]oKK]en_]eFkofFK]"
            A$ = A$ + "oKK]en_]eFkoeB;]o7<`0oOeEGmoQ2:Xo7R7Nl_8Nhao`\b:o3c:[l?<[\bo`\b:o3c:[l?<[\bo`\b:o3c:[l?<[\bo`\b:o3c:"
            A$ = A$ + "[l?<[\bo`\b:o3c:[l?<[\bo`\b:o3c:[l?<[\bo`\b:og2:XlO>eDco3;\`o3mc?o?_k^koeB;]oKK]en_]eFkofFK]oKK]en_]"
            A$ = A$ + "eFkofFK]oKK]en_]eFkofFK]oKK]en_]eFkofFK]oKK]en_]eFkofFK]oKK]en_]eFkofFK]oKK]en_]eFkofFK]oKK]en_]eFko"
            A$ = A$ + "fFK]oKK]en_]eFkofFK]oKK]en_]eFkofFK]oKK]en_]eFkofFK]oKK]en_]eFkofFK]oKK]en_]eFkofFK]oKK]en_]eFkofFK]"
            A$ = A$ + "oKK]en_]eFkofFK]oKK]en_]eFkofFK]oKK]en_]eFkofFK]oKK]en_]eFkofFK]oKK]en_]eFkofFK]oKK]en_]eFkofFK]oKK]"
            A$ = A$ + "en_]eFkofFK]oKK]en_]eFkofFK]oKK]en_]eFkofFK]oKK]en_]eFkofFK]oKK]en_]eFkofFK]oKK]eno^jZko17L`ok5GLmo5"
            A$ = A$ + "D@aoYDB9o73;\l?<[\bo`\b:o3c:[l?<[\bo`\b:o3c:[l?<[\bo`\b:o3c:[l?<[\bo`\b:o3c:[l?<[\bo`\b:o3c:[l?<[\bo"
            A$ = A$ + "`\b:o3c:[l?<[\bo`\b:o3c:[l?<[\bo`\b:o73;\lOB5=do<QTAoWDA3m?B49do8AT@oS4A2m?B49do8AT@oS4A2m?B49do8AT@"
            A$ = A$ + "oS4A2m?B49do8AT@oS4A2m?B49do8AT@oS4A2m?B49do8AT@oS4A2m?B49do8AT@oS4A2m?B49do8AT@oS4A2m?B49do8AT@oS4A"
            A$ = A$ + "2m?B49dnU@b8aOa5GlO6IT1nIP16\00000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000000000000000007AT@hN4A2moA49do7AT@oO4A2moA49do7AT@oO4A2moA49do"
            A$ = A$ + "7AT@oO4A2moA49do7AT@oO4A2moA49do7AT@oO4A2moA49do7AT@oO4A2moA49do7AT@oO4A2moA49do7AT@oO4A2moA49do7AT@"
            A$ = A$ + "oO4A2moA49do7AT@oO4A2moA49do7AT@oO4A2moA49do7AT@oO4A2moA49do9I4AocDB7mO<_hboN\a6oWB9UlO<\`bo`\b:o[B9"
            A$ = A$ + "UloEDAeojR;^o[K^in?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\o;K\ano_onkoDC=eo3jWOnO8"
            A$ = A$ + "NhaoRhQ7o3c:[l?<[\bo`\b:o3c:[l?<[\bo`\b:o3c:[l?<[\bo`\b:o3c:[l?<[\bo`\b:o3c:[l?<[\bo`\b:o3c:[l?<[\bo"
            A$ = A$ + "`\b:o3c:[lO;XPboiDC=o;L`1ooc>klojVK^o?[\bn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\"
            A$ = A$ + "oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\"
            A$ = A$ + "cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]"
            A$ = A$ + "c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>ko"
            A$ = A$ + "d>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>koiR;^oo[_nnOGK]eoG@15oWB9UlO<\`bo`\b:o3c:[l?<[\bo`\b:"
            A$ = A$ + "o3c:[l?<[\bo`\b:o3c:[l?<[\bo`\b:o3c:[l?<[\bo`\b:o3c:[l?<[\bo`\b:o3c:[l?<[\bo`\b:o3c:[l?<[\bo`\b:o3c:"
            A$ = A$ + "[lO<\`bo8Ed@o_4B6m?B5=do7AT@oO4A2moA49do7AT@oO4A2moA49do7AT@oO4A2moA49do7AT@oO4A2moA49do7AT@oO4A2moA"
            A$ = A$ + "49do7AT@oO4A2moA49do7AT@oO4A2moA49do7AT@oO4A2moA49do7AT@oO4A2moA49do7AT@kG29S4o5GLaoIP16hW16H`200000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000Ld@1QkA35do7=D@oOd@1moA35do7=D@oOd@1moA35do7=D@oOd@1moA35do7=D@oOd@1moA35do7=D@oOd@"
            A$ = A$ + "1moA35do7=D@oOd@1moA35do7=D@oOd@1moA35do7=D@oOd@1moA35do7=D@oOd@1moA35do7=D@oOd@1moA35do7=D@oOd@1moA"
            A$ = A$ + "35do7=D@oOd@1moA35do7=D@oWDA3m?C8IdoahB;okQ6Jl?:T@bo`\b:ooR:ZlO:T@boG=eDo[;^hn_^iVkod>k\oCk\cn?]c>ko"
            A$ = A$ + "d>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn_\a6koonk_o?=eDo?XOnioQdA7o7B7Mlo;ZXbo_XR:ooR:Zlo;ZXbo_XR:"
            A$ = A$ + "ooR:Zlo;ZXbo_XR:ooR:Zlo;ZXbo_XR:ooR:Zlo;ZXbo_XR:ooR:Zlo;ZXbo_XR:ooR:Zlo;ZXbo\Lb9oS3=dlO`17lo>k\co[K^"
            A$ = A$ + "ino\b:kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]"
            A$ = A$ + "c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>ko"
            A$ = A$ + "d>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\"
            A$ = A$ + "oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\"
            A$ = A$ + "cn?]c>kod>k\oW;^hno_njkoMYUFoOa4Cl?:T@bo`\b:ooR:Zlo;ZXbo_XR:ooR:Zlo;ZXbo_XR:ooR:Zlo;ZXbo_XR:ooR:Zlo;"
            A$ = A$ + "ZXbo_XR:ooR:Zlo;ZXbo_XR:ooR:Zlo;ZXbo_XR:ooR:Zlo;ZXbo_XR:ooR:Zlo;ZXbo`\b:oS4A2moB7Edo8AT@oOd@1moA35do"
            A$ = A$ + "7=D@oOd@1moA35do7=D@oOd@1moA35do7=D@oOd@1moA35do7=D@oOd@1moA35do7=D@oOd@1moA35do7=D@oOd@1moA35do7=D@"
            A$ = A$ + "oOd@1moA35do7=D@oOd@1moA35do7=D@oOd@1]O9T<BlGLa5oW16HPO6HP1;0000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000PA354^6=D@oKd@1m_A"
            A$ = A$ + "35do6=D@oKd@1m_A35do6=D@oKd@1m_A35do6=D@oKd@1m_A35do6=D@oKd@1m_A35do6=D@oKd@1m_A35do6=D@oKd@1m_A35do"
            A$ = A$ + "6=D@oKd@1m_A35do6=D@oKd@1m_A35do6=D@oKd@1m_A35do6=D@oKd@1m_A35do6=D@oKd@1m_A35do6=D@oKd@1m?B5=do;QTA"
            A$ = A$ + "o7S;]l_7JXaoX@29o3c:[lo;ZXboY@29oOeDCm_^hRkojVK^oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\"
            A$ = A$ + "cn?]c>kob6K\ook_onodDCmoPniWo7B7MlO8Mdao_XR:ooR:Zlo;ZXbo_XR:ooR:Zlo;ZXbo_XR:ooR:Zlo;ZXbo_XR:ooR:Zlo;"
            A$ = A$ + "ZXbo_XR:ooR:Zlo;ZXbo_XR:ooR:Zlo;ZXbo_XR:ocb9Wl?>d@co17L`ok\c>o_^iVkoc:[\oCk\cn?]c>kod>k\oCk\cn?]c>ko"
            A$ = A$ + "d>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\"
            A$ = A$ + "oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\"
            A$ = A$ + "cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]"
            A$ = A$ + "c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cnO^hRkooj[_ogUFJmo5C<ao"
            A$ = A$ + "X@29o3c:[lo;ZXbo_XR:ooR:Zlo;ZXbo_XR:ooR:Zlo;ZXbo_XR:ooR:Zlo;ZXbo_XR:ooR:Zlo;ZXbo_XR:ooR:Zlo;ZXbo_XR:"
            A$ = A$ + "ooR:Zlo;ZXbo_XR:ooR:Zlo;ZXbo_XR:o3c:[loA49do:MDAoO4A2m_A35do6=D@oKd@1m_A35do6=D@oKd@1m_A35do6=D@oKd@"
            A$ = A$ + "1m_A35do6=D@oKd@1m_A35do6=D@oKd@1m_A35do6=D@oKd@1m_A35do6=D@oKd@1m_A35do6=D@oKd@1m_A35do6=D@oKd@1m_A"
            A$ = A$ + "35dnT@b8aOa5GlO6HP1nIP16\000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000000000000000000694@hJT@0m_A21do694@oKT@0m_A21do694@oKT@0m_A21do694@"
            A$ = A$ + "oKT@0m_A21do694@oKT@0m_A21do694@oKT@0m_A21do694@oKT@0m_A21do694@oKT@0m_A21do694@oKT@0m_A21do694@oKT@"
            A$ = A$ + "0m_A21do694@oKT@0m_A21do694@oKT@0m_A21do694@oKT@0m_A21do8AT@o_dA5m?<]`boMTA6oOb8Slo;ZXbo^TB:oSb8Sl_E"
            A$ = A$ + "B9eojR;^o[K^in?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\o;K\ano_onkoCC=eooiWOn?8L`ao"
            A$ = A$ + "P`17okB:Yl_;YTbo^TB:okB:Yl_;YTbo^TB:okB:Yl_;YTbo^TB:okB:Yl_;YTbo^TB:okB:Yl_;YTbo^TB:okB:Yl_;YTbo^TB:"
            A$ = A$ + "okB:Ylo:VHbog<c<o7<`0o_c>klojVK^o?[\bn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\"
            A$ = A$ + "cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]"
            A$ = A$ + "c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>ko"
            A$ = A$ + "d>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\"
            A$ = A$ + "oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>koiR;^oo[_nn?GJYeoF<a4oOb8Slo;ZXbo^TB:okB:Yl_;YTbo^TB:okB:"
            A$ = A$ + "Yl_;YTbo^TB:okB:Yl_;YTbo^TB:okB:Yl_;YTbo^TB:okB:Yl_;YTbo^TB:okB:Yl_;YTbo^TB:okB:Yl_;YTbo^TB:okB:Ylo;"
            A$ = A$ + "ZXbo7=D@o[TA4moA35do694@oKT@0m_A21do694@oKT@0m_A21do694@oKT@0m_A21do694@oKT@0m_A21do694@oKT@0m_A21do"
            A$ = A$ + "694@oKT@0m_A21do694@oKT@0m_A21do694@oKT@0m_A21do694@oKT@0m_A21do694@kCb8S4o5FHaoIP16hW16H`2000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000DT@0QKA21do594@oGT@0mOA21do594@oGT@0mOA21do594@oGT@0mOA21do594@oGT@0mOA21do594@oGT@0mOA"
            A$ = A$ + "21do594@oGT@0mOA21do594@oGT@0mOA21do594@oGT@0mOA21do594@oGT@0mOA21do594@oGT@0mOA21do594@oGT@0mOA21do"
            A$ = A$ + "594@oGT@0mOA21do594@oO4A2m_B7Edo`d2;ogA6Ilo9S<bo_XR:okB:Yl?:S<boF9UDo[;^hn_^iVkod>k\oCk\cn?]c>kod>k\"
            A$ = A$ + "oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn_\a6koonk_o?=eDooWOnioP`17o327Ll_;YTbo^TB:okB:Yl_;YTbo^TB:okB:"
            A$ = A$ + "Yl_;YTbo^TB:okB:Yl_;YTbo^TB:okB:Yl_;YTbo^TB:okB:Yl_;YTbo^TB:okB:Yl_;YTbo[HR9oOc<clO`03lo>k\co[K^ino\"
            A$ = A$ + "b:kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>ko"
            A$ = A$ + "d>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\"
            A$ = A$ + "oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\"
            A$ = A$ + "cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]"
            A$ = A$ + "c>kod>k\oW;^hno_njkoLYUFoKa4Clo9S<bo_XR:okB:Yl_;YTbo^TB:okB:Yl_;YTbo^TB:okB:Yl_;YTbo^TB:okB:Yl_;YTbo"
            A$ = A$ + "^TB:okB:Yl_;YTbo^TB:okB:Yl_;YTbo^TB:okB:Yl_;YTbo^TB:okB:Yl_;YTbo_XR:oKd@1mOB6Ado6=D@oGT@0mOA21do594@"
            A$ = A$ + "oGT@0mOA21do594@oGT@0mOA21do594@oGT@0mOA21do594@oGT@0mOA21do594@oGT@0mOA21do594@oGT@0mOA21do594@oGT@"
            A$ = A$ + "0mOA21do594@oGT@0mOA21do594@oGT@0]?9S8BlGHQ5oW16HPO6HP1;00000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000000000000000000000000000000000000000000000000@A1m3^55d?oGD@olOA1mco"
            A$ = A$ + "55d?oGD@olOA1mco55d?oGD@olOA1mco55d?oGD@olOA1mco55d?oGD@olOA1mco55d?oGD@olOA1mco55d?oGD@olOA1mco55d?"
            A$ = A$ + "oGD@olOA1mco55d?oGD@olOA1mco55d?oGD@olOA1mco55d?oGD@olOA1mco55d?oGD@olOA1mco55d?oGD@oloA35do:I4Ao33;"
            A$ = A$ + "\l?7ITaoV8R8okB:YlO;XPboW8R8oGEDAm_^hRkojVK^oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]"
            A$ = A$ + "c>kob6K\ook_onodDCmoOniWoo17Llo7L`ao]P2:og2:XlO;XPbo]P2:og2:XlO;XPbo]P2:og2:XlO;XPbo]P2:og2:XlO;XPbo"
            A$ = A$ + "]P2:og2:XlO;XPbo]P2:og2:XlO;XPbo]P2:o[B9Ulo=b8co13<`ok\c>o_^iVkoc:[\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\"
            A$ = A$ + "oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\"
            A$ = A$ + "cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]"
            A$ = A$ + "c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>ko"
            A$ = A$ + "d>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cnO^hRkooj[_ocUFJmO5C<aoV8R8"
            A$ = A$ + "okB:YlO;XPbo]P2:og2:XlO;XPbo]P2:og2:XlO;XPbo]P2:og2:XlO;XPbo]P2:og2:XlO;XPbo]P2:og2:XlO;XPbo]P2:og2:"
            A$ = A$ + "XlO;XPbo]P2:og2:XlO;XPbo]P2:okB:Yl_A21do9Ed@oKT@0mOA1mco55d?oGD@olOA1mco55d?oGD@olOA1mco55d?oGD@olOA"
            A$ = A$ + "1mco55d?oGD@olOA1mco55d?oGD@olOA1mco55d?oGD@olOA1mco55d?oGD@olOA1mco55d?oGD@olOA1mco55d?oGD@olOA1mcn"
            A$ = A$ + "T8R8aOQ5FlO6HP1nIP16\0000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000045d?hBD@ol?A1mco45d?oCD@ol?A1mco45d?oCD@ol?A1mco45d?oCD@"
            A$ = A$ + "ol?A1mco45d?oCD@ol?A1mco45d?oCD@ol?A1mco45d?oCD@ol?A1mco45d?oCD@ol?A1mco45d?oCD@ol?A1mco45d?oCD@ol?A"
            A$ = A$ + "1mco45d?oCD@ol?A1mco45d?oCD@ol?A1mco45d?oCD@ol?A1mco6=D@oWTA4mo;\`boLTA6oKR8Rl_;YTbo]P2:oOR8RlOEA5eo"
            A$ = A$ + "jR;^o[K^in?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\o;K\ano_onkoCC=eooiWOno7L`aoO`17"
            A$ = A$ + "og2:XlO;XPbo]P2:og2:XlO;XPbo]P2:og2:XlO;XPbo]P2:og2:XlO;XPbo]P2:og2:XlO;XPbo]P2:og2:XlO;XPbo]P2:og2:"
            A$ = A$ + "Xl_:UDbog8S<o7<`0o_c>klojVK^o?[\bn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]"
            A$ = A$ + "c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>ko"
            A$ = A$ + "d>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\"
            A$ = A$ + "oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\"
            A$ = A$ + "cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>koiR;^oo[_nn?GJYeoE<a4oKR8Rl_;YTbo]P2:og2:XlO;XPbo]P2:og2:XlO;"
            A$ = A$ + "XPbo]P2:og2:XlO;XPbo]P2:og2:XlO;XPbo]P2:og2:XlO;XPbo]P2:og2:XlO;XPbo]P2:og2:XlO;XPbo]P2:og2:Xl_;YTbo"
            A$ = A$ + "594@oSDA3mOA21do45d?oCD@ol?A1mco45d?oCD@ol?A1mco45d?oCD@ol?A1mco45d?oCD@ol?A1mco45d?oCD@ol?A1mco45d?"
            A$ = A$ + "oCD@ol?A1mco45d?oCD@ol?A1mco45d?oCD@ol?A1mco45d?oCD@ol?A1mco45d?kCR8R4o5FHaoIP16hW16H`20000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000@4@nP;A0ico41T?oC4@nl?A0ico41T?oC4@nl?A0ico41T?oC4@nl?A0ico41T?oC4@nl?A0ico41T?oC4@nl?A0ico"
            A$ = A$ + "41T?oC4@nl?A0ico41T?oC4@nl?A0ico41T?oC4@nl?A0ico41T?oC4@nl?A0ico41T?oC4@nl?A0ico41T?oC4@nl?A0ico41T?"
            A$ = A$ + "oC4@nl?A0ico41T?oKT@0mOB5=do_\b:oc16Hl_9Q4bo]P2:ocb9Wl_9Q4boD15Do[;^hn_^iVkod>k\oCk\cn?]c>kod>k\oCk\"
            A$ = A$ + "cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn_\a6koonk_o?=eDooWNjioO\a6ooa6Kl?;WLbo\Lb9ocb9Wl?;WLbo\Lb9ocb9Wl?;"
            A$ = A$ + "WLbo\Lb9ocb9Wl?;WLbo\Lb9ocb9Wl?;WLbo\Lb9ocb9Wl?;WLbo\Lb9ocb9Wl?;WLboY@29oKC<alO`03lo>k\co[K^ino\b:ko"
            A$ = A$ + "d>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\"
            A$ = A$ + "oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\"
            A$ = A$ + "cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]"
            A$ = A$ + "c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>ko"
            A$ = A$ + "d>k\oW;^hno_njkoLUEFoGQ4Bl_9Q4bo]P2:ocb9Wl?;WLbo\Lb9ocb9Wl?;WLbo\Lb9ocb9Wl?;WLbo\Lb9ocb9Wl?;WLbo\Lb9"
            A$ = A$ + "ocb9Wl?;WLbo\Lb9ocb9Wl?;WLbo\Lb9ocb9Wl?;WLbo\Lb9ocb9Wl?;WLbo]P2:oGD@ol?B4=do554@oC4@nl?A0ico41T?oC4@"
            A$ = A$ + "nl?A0ico41T?oC4@nl?A0ico41T?oC4@nl?A0ico41T?oC4@nl?A0ico41T?oC4@nl?A0ico41T?oC4@nl?A0ico41T?oC4@nl?A"
            A$ = A$ + "0ico41T?oC4@nl?A0ico41T?oC4@n\?9R4BlGHQ5oW16HPO6HP1;000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000000000000000000000000000000000000000`@0i3^31T?o?4@nlo@0ico31T?"
            A$ = A$ + "o?4@nlo@0ico31T?o?4@nlo@0ico31T?o?4@nlo@0ico31T?o?4@nlo@0ico31T?o?4@nlo@0ico31T?o?4@nlo@0ico31T?o?4@"
            A$ = A$ + "nlo@0ico31T?o?4@nlo@0ico31T?o?4@nlo@0ico31T?o?4@nlo@0ico31T?o?4@nlo@0ico31T?o?4@nlOA21do8Ed@oob:[l?7"
            A$ = A$ + "HPaoV4B8og2:Xl?;WLboV4B8oC5D@m_^hRkojVK^oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>ko"
            A$ = A$ + "b6K\ook_onodDCmoOjYWooa6Klo7K\ao\Lb9ocb9Wl?;WLbo\Lb9ocb9Wl?;WLbo\Lb9ocb9Wl?;WLbo\Lb9ocb9Wl?;WLbo\Lb9"
            A$ = A$ + "ocb9Wl?;WLbo\Lb9ocb9Wl?;WLbo\Lb9oW29Tl_=a4co13<`ok\c>o_^iVkoc:[\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\"
            A$ = A$ + "cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]"
            A$ = A$ + "c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>ko"
            A$ = A$ + "d>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\"
            A$ = A$ + "oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cnO^hRkooj[_ocEFImO5B8aoV4B8og2:"
            A$ = A$ + "Xl?;WLbo\Lb9ocb9Wl?;WLbo\Lb9ocb9Wl?;WLbo\Lb9ocb9Wl?;WLbo\Lb9ocb9Wl?;WLbo\Lb9ocb9Wl?;WLbo\Lb9ocb9Wl?;"
            A$ = A$ + "WLbo\Lb9ocb9Wl?;WLbo\Lb9og2:Xl?A1mco7Ad@oCD@0mo@0ico31T?o?4@nlo@0ico31T?o?4@nlo@0ico31T?o?4@nlo@0ico"
            A$ = A$ + "31T?o?4@nlo@0ico31T?o?4@nlo@0ico31T?o?4@nlo@0ico31T?o?4@nlo@0ico31T?o?4@nlo@0ico31T?o?4@nlo@0icnS8B8"
            A$ = A$ + "aOQ5FlO6HP1nIP16\00000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000003mS?h>d?nlo@ohco3mS?o?d?nlo@ohco3mS?o?d?nlo@ohco3mS?o?d?nlo@"
            A$ = A$ + "ohco3mS?o?d?nlo@ohco3mS?o?d?nlo@ohco3mS?o?d?nlo@ohco3mS?o?d?nlo@ohco3mS?o?d?nlo@ohco3mS?o?d?nlo@ohco"
            A$ = A$ + "3mS?o?d?nlo@ohco3mS?o?d?nlo@ohco3mS?o?d?nlo@ohco554@oS4A3m_;[XboKLa5oG28Pl?;WLbo[HR9oGb7Ol?E@1eojR;^"
            A$ = A$ + "o[K^in?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\o;K\ano_onkoCC=eooYWNn_7JXaoNXQ6o_R9"
            A$ = A$ + "Vlo:VHbo[HR9o_R9Vlo:VHbo[HR9o_R9Vlo:VHbo[HR9o_R9Vlo:VHbo[HR9o_R9Vlo:VHbo[HR9o_R9Vlo:VHbo[HR9o_R9Vl?:"
            A$ = A$ + "S<boe03<o7<`0o_c>klojVK^o?[\bn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>ko"
            A$ = A$ + "d>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\"
            A$ = A$ + "oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\"
            A$ = A$ + "cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]"
            A$ = A$ + "c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>koiR;^oo[_nnoFHQeoD4A4oG28Pl?;WLbo[HR9o_R9Vlo:VHbo[HR9o_R9Vlo:VHbo"
            A$ = A$ + "[HR9o_R9Vlo:VHbo[HR9o_R9Vlo:VHbo[HR9o_R9Vlo:VHbo[HR9o_R9Vlo:VHbo[HR9o_R9Vlo:VHbo[HR9o_R9Vl?;WLbo41d?"
            A$ = A$ + "oOd@3m?A01do3mS?o?d?nlo@ohco3mS?o?d?nlo@ohco3mS?o?d?nlo@ohco3mS?o?d?nlo@ohco3mS?o?d?nlo@ohco3mS?o?d?"
            A$ = A$ + "nlo@ohco3mS?o?d?nlo@ohco3mS?o?d?nlo@ohco3mS?o?d?nlo@ohco3mS?k?R8Q4o5FLaoIP16hW16H`200000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000008d?mP[@odco2mC?o;d?ml_@odco2mC?o;d?ml_@odco2mC?o;d?ml_@odco2mC?o;d?ml_@odco2mC?o;d?ml_@odco2mC?"
            A$ = A$ + "o;d?ml_@odco2mC?o;d?ml_@odco2mC?o;d?ml_@odco2mC?o;d?ml_@odco2mC?o;d?ml_@odco2mC?o;d?ml_@odco2mC?o;d?"
            A$ = A$ + "ml_@odco2mC?oCD@oloA49do^\R:o_a5GlO9P0bo\Lb9o_R9VlO9OlaoD15Do[;^hn_^iVkod>k\oCk\cn?]c>kod>k\oCk\cn?]"
            A$ = A$ + "c>kod>k\oCk\cn?]c>kod>k\oCk\cn_\a6koonk_o?=eDooWNjioNXQ6okQ6Jlo:VHbo[HR9o_R9Vlo:VHbo[HR9o_R9Vlo:VHbo"
            A$ = A$ + "[HR9o_R9Vlo:VHbo[HR9o_R9Vlo:VHbo[HR9o_R9Vlo:VHbo[HR9o_R9Vlo:VHboX<b8oG3<`lO`03lo>k\co[K^ino\b:kod>k\"
            A$ = A$ + "oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\"
            A$ = A$ + "cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]"
            A$ = A$ + "c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>ko"
            A$ = A$ + "d>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\"
            A$ = A$ + "oW;^hno_njkoKQ5FoCA4AlO9P0bo\Lb9o_R9Vlo:VHbo[HR9o_R9Vlo:VHbo[HR9o_R9Vlo:VHbo[HR9o_R9Vlo:VHbo[HR9o_R9"
            A$ = A$ + "Vlo:VHbo[HR9o_R9Vlo:VHbo[HR9o_R9Vlo:VHbo[HR9o_R9Vlo:VHbo\Lb9o?4@nl_A39do31d?o;d?ml_@odco2mC?o;d?ml_@"
            A$ = A$ + "odco2mC?o;d?ml_@odco2mC?o;d?ml_@odco2mC?o;d?ml_@odco2mC?o;d?ml_@odco2mC?o;d?ml_@odco2mC?o;d?ml_@odco"
            A$ = A$ + "2mC?o;d?ml_@odco2mC?o;d?m\o8R4BlGHa5oW16HPO6HP1;0000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000P@nd3^2iC?o;T?ml_@ndco2iC?o;T?"
            A$ = A$ + "ml_@ndco2iC?o;T?ml_@ndco2iC?o;T?ml_@ndco2iC?o;T?ml_@ndco2iC?o;T?ml_@ndco2iC?o;T?ml_@ndco2iC?o;T?ml_@"
            A$ = A$ + "ndco2iC?o;T?ml_@ndco2iC?o;T?ml_@ndco2iC?o;T?ml_@ndco2iC?o;T?ml_@ndco2iC?o;T?ml?A0mco7=T@ogR:Zl_6GLao"
            A$ = A$ + "T028o_b9Wl_:VHboTla7o?5D@m_^hRkojVK^oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kob6K\"
            A$ = A$ + "ook_onodDCmoOjYWogQ6JlO7JXaoZHR9o[R9Vl_:VHboZHR9o[R9Vl_:VHboZHR9o[R9Vl_:VHboZHR9o[R9Vl_:VHboZHR9o[R9"
            A$ = A$ + "Vl_:VHboZHR9o[R9Vl_:VHboZHR9oOb8Sl?=`0co13<`ok\c>o_^iVkoc:[\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]"
            A$ = A$ + "c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>ko"
            A$ = A$ + "d>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\"
            A$ = A$ + "oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\"
            A$ = A$ + "cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cnO^hRkooj[_o_5FHmo4A4aoT028o_b9Wl_:"
            A$ = A$ + "VHboZHR9o[R9Vl_:VHboZHR9o[R9Vl_:VHboZHR9o[R9Vl_:VHboZHR9o[R9Vl_:VHboZHR9o[R9Vl_:VHboZHR9o[R9Vl_:VHbo"
            A$ = A$ + "ZHR9o[R9Vl_:VHboZHR9o_b9Wlo@ohco6=T@o?4@ol_@ndco2iC?o;T?ml_@ndco2iC?o;T?ml_@ndco2iC?o;T?ml_@ndco2iC?"
            A$ = A$ + "o;T?ml_@ndco2iC?o;T?ml_@ndco2iC?o;T?ml_@ndco2iC?o;T?ml_@ndco2iC?o;T?ml_@ndco2iC?o;T?ml_@ndcnS4B8aOQ5"
            A$ = A$ + "GlO6HP1nIP16\000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000001i3?h6T?llO@n`co1i3?o7T?llO@n`co1i3?o7T?llO@n`co1i3?o7T?llO@n`co"
            A$ = A$ + "1i3?o7T?llO@n`co1i3?o7T?llO@n`co1i3?o7T?llO@n`co1i3?o7T?llO@n`co1i3?o7T?llO@n`co1i3?o7T?llO@n`co1i3?"
            A$ = A$ + "o7T?llO@n`co1i3?o7T?llO@n`co1i3?o7T?llO@ndco31T?oKd@1mO;ZTboJLa5oC28Plo:VHboZDB9oCR7NloD?mdojR;^o[K^"
            A$ = A$ + "in?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\o;K\ano_onkoCC=eooYWNnO7JXaoMXQ6o[B9Ul_:"
            A$ = A$ + "UDboZDB9o[B9Ul_:UDboZDB9o[B9Ul_:UDboZDB9o[B9Ul_:UDboZDB9o[B9Ul_:UDboZDB9o[B9Ul_:UDboZDB9o[B9Ulo9R8bo"
            A$ = A$ + "dlb;o7<`0o_c>klojVK^o?[\bn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\"
            A$ = A$ + "oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\"
            A$ = A$ + "cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]"
            A$ = A$ + "c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>ko"
            A$ = A$ + "d>k\oCk\cn?]c>kod>k\oCk\cn?]c>koiR;^oo[_nnoFHQeoC4A4oC28Plo:VHboZDB9o[B9Ul_:UDboZDB9o[B9Ul_:UDboZDB9"
            A$ = A$ + "o[B9Ul_:UDboZDB9o[B9Ul_:UDboZDB9o[B9Ul_:UDboZDB9o[B9Ul_:UDboZDB9o[B9Ul_:UDboZDB9o[B9Ulo:VHbo2mC?oGd@"
            A$ = A$ + "1m_@0ico1i3?o7T?llO@n`co1i3?o7T?llO@n`co1i3?o7T?llO@n`co1i3?o7T?llO@n`co1i3?o7T?llO@n`co1i3?o7T?llO@"
            A$ = A$ + "n`co1i3?o7T?llO@n`co1i3?o7T?llO@n`co1i3?o7T?llO@n`co1i3?k?B8Q4o5FLaoIP16hW16H`2000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "04D?lPK@m`co1e3?o7D?llO@m`co1e3?o7D?llO@m`co1e3?o7D?llO@m`co1e3?o7D?llO@m`co1e3?o7D?llO@m`co1e3?o7D?"
            A$ = A$ + "llO@m`co1e3?o7D?llO@m`co1e3?o7D?llO@m`co1e3?o7D?llO@m`co1e3?o7D?llO@m`co1e3?o7D?llO@m`co1e3?o7D?llO@"
            A$ = A$ + "m`co1eC?o?d?nl_A25do\XB:oWa5Glo8P0boZHR9oWB9Ulo8NhaoBmdCo[K^in_^iVkod>k\oCk\cn?]c>kod>k\oCk\cn?]c>ko"
            A$ = A$ + "d>k\oCk\cn?]c>kod>k\oCk\cn_\a6koonk_oC=eDooWNjioLXQ6ocQ6JlO:UDboYDB9oWB9UlO:UDboYDB9oWB9UlO:UDboYDB9"
            A$ = A$ + "oWB9UlO:UDboYDB9oWB9UlO:UDboYDB9oWB9UlO:UDboYDB9oWB9UlO:UDboV8R8o?c;_l?`03lo>k\co[K^ino\b:kod>k\oCk\"
            A$ = A$ + "cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]"
            A$ = A$ + "c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>ko"
            A$ = A$ + "d>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\"
            A$ = A$ + "oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oW;^"
            A$ = A$ + "hno_njkoJQ5Fo?A4Alo8P0boZHR9oWB9UlO:UDboYDB9oWB9UlO:UDboYDB9oWB9UlO:UDboYDB9oWB9UlO:UDboYDB9oWB9UlO:"
            A$ = A$ + "UDboYDB9oWB9UlO:UDboYDB9oWB9UlO:UDboYDB9oWB9UlO:UDboZHR9o;T?mlOA25do2mS?o7D?llO@m`co1e3?o7D?llO@m`co"
            A$ = A$ + "1e3?o7D?llO@m`co1e3?o7D?llO@m`co1e3?o7D?llO@m`co1e3?o7D?llO@m`co1e3?o7D?llO@m`co1e3?o7D?llO@m`co1e3?"
            A$ = A$ + "o7D?llO@m`co1e3?o7D?l\o8Q4BlGLa5oW16HPO6HP1;00000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000@m\3^0ec>o3D?kl?@m\co0ec>o3D?kl?@"
            A$ = A$ + "m\co0ec>o3D?kl?@m\co0ec>o3D?kl?@m\co0ec>o3D?kl?@m\co0ec>o3D?kl?@m\co0ec>o3D?kl?@m\co0ec>o3D?kl?@m\co"
            A$ = A$ + "0ec>o3D?kl?@m\co0ec>o3D?kl?@m\co0ec>o3D?kl?@m\co0ec>o3D?kl?@m\co0ec>o3D?ll_@odco594@ocB:XlO6FHaoSla7"
            A$ = A$ + "o[B9UlO:T@boSdA7o;UC>m_^iVkojVK^oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kob6K\ook_"
            A$ = A$ + "on?eDCmoOfIWocA6Il?7ITaoY@29oW29TlO:T@boY@29oW29TlO:T@boY@29oW29TlO:T@boY@29oW29TlO:T@boY@29oW29TlO:"
            A$ = A$ + "T@boY@29oW29TlO:T@boY@29oKB8Qlo<^hbo03<`ok\c>o_^iVkoc:[\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>ko"
            A$ = A$ + "d>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\"
            A$ = A$ + "oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\"
            A$ = A$ + "cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]"
            A$ = A$ + "c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cnO^hRkooj[_o[5FHmo4@0aoSla7o[B9UlO:T@bo"
            A$ = A$ + "Y@29oW29TlO:T@boY@29oW29TlO:T@boY@29oW29TlO:T@boY@29oW29TlO:T@boY@29oW29TlO:T@boY@29oW29TlO:T@boY@29"
            A$ = A$ + "oW29TlO:T@boY@29o[B9UlO@n`co494@o7d?ml?@m\co0ec>o3D?kl?@m\co0ec>o3D?kl?@m\co0ec>o3D?kl?@m\co0ec>o3D?"
            A$ = A$ + "kl?@m\co0ec>o3D?kl?@m\co0ec>o3D?kl?@m\co0ec>o3D?kl?@m\co0ec>o3D?kl?@m\co0ec>o3D?kl?@m\cnS4B8aOa5GlO6"
            A$ = A$ + "HP1nIP16\0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000ac>h24?kl?@l\co0ac>o34?kl?@l\co0ac>o34?kl?@l\co0ac>o34?kl?@l\co0ac>"
            A$ = A$ + "o34?kl?@l\co0ac>o34?kl?@l\co0ac>o34?kl?@l\co0ac>o34?kl?@l\co0ac>o34?kl?@l\co0ac>o34?kl?@l\co0ac>o34?"
            A$ = A$ + "kl?@l\co0ac>o34?kl?@l\co0ac>o34?kl?@m`co2iC?oGD@0m?;YPboIHQ5o;b7OlO:UDboX@29o7B7Ml_D>idojVK^o[K^in?]"
            A$ = A$ + "c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\o;K\ano_onkoDC=eooIWMn?7ITaoLTA6oS29Tl?:T@bo"
            A$ = A$ + "X@29oS29Tl?:T@boX@29oS29Tl?:T@boX@29oS29Tl?:T@boX@29oS29Tl?:T@boX@29oS29Tl?:T@boX@29oS29TlO9Q4bobhR;"
            A$ = A$ + "o3<`0o_c>klojVK^o?[\bn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\"
            A$ = A$ + "cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]"
            A$ = A$ + "c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>ko"
            A$ = A$ + "d>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\"
            A$ = A$ + "oCk\cn?]c>kod>k\oCk\cn?]c>koiR;^oo[_nn_FHQeoC014o;b7OlO:UDboX@29oS29Tl?:T@boX@29oS29Tl?:T@boX@29oS29"
            A$ = A$ + "Tl?:T@boX@29oS29Tl?:T@boX@29oS29Tl?:T@boX@29oS29Tl?:T@boX@29oS29Tl?:T@boX@29oS29TlO:UDbo1e3?oCD@0mO@"
            A$ = A$ + "ndco0ac>o34?kl?@l\co0ac>o34?kl?@l\co0ac>o34?kl?@l\co0ac>o34?kl?@l\co0ac>o34?kl?@l\co0ac>o34?kl?@l\co"
            A$ = A$ + "0ac>o34?kl?@l\co0ac>o34?kl?@l\co0ac>o34?kl?@l\co0ac>k?B8Q4o5GLaoIP16hW16H`20000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000l3?"
            A$ = A$ + "jPk?lXcoo`S>oo3?jlo?lXcoo`S>oo3?jlo?lXcoo`S>oo3?jlo?lXcoo`S>oo3?jlo?lXcoo`S>oo3?jlo?lXcoo`S>oo3?jlo?"
            A$ = A$ + "lXcoo`S>oo3?jlo?lXcoo`S>oo3?jlo?lXcoo`S>oo3?jlo?lXcoo`S>oo3?jlo?lXcoo`S>oo3?jlo?lXcoo`S>oo3?jlo?lXco"
            A$ = A$ + "odc>o7T?ll?A1mco\Pb9oWA5El_8NhaoY@29oSb8SlO8L`aoBeDCo[;^hn_^iVkod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\"
            A$ = A$ + "oCk\cn?]c>kod>k\oCk\cn_\a6koonk_oC=eDooWMfioLP16oc16Hl?:S<boX<b8oSb8Sl?:S<boX<b8oSb8Sl?:S<boX<b8oSb8"
            A$ = A$ + "Sl?:S<boX<b8oSb8Sl?:S<boX<b8oSb8Sl?:S<boX<b8oSb8Sl?:S<boU028o;C;]l?`03lo>k\co[K^ino\b:kod>k\oCk\cn?]"
            A$ = A$ + "c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>ko"
            A$ = A$ + "d>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\"
            A$ = A$ + "oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\"
            A$ = A$ + "cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oW;^hno_"
            A$ = A$ + "njkoJMeEo?a3?l_8NhaoY@29oSb8Sl?:S<boX<b8oSb8Sl?:S<boX<b8oSb8Sl?:S<boX<b8oSb8Sl?:S<boX<b8oSb8Sl?:S<bo"
            A$ = A$ + "X<b8oSb8Sl?:S<boX<b8oSb8Sl?:S<boX<b8oSb8Sl?:S<boY@29o3D?klo@1mco0i3?oo3?jlo?lXcoo`S>oo3?jlo?lXcoo`S>"
            A$ = A$ + "oo3?jlo?lXcoo`S>oo3?jlo?lXcoo`S>oo3?jlo?lXcoo`S>oo3?jlo?lXcoo`S>oo3?jlo?lXcoo`S>oo3?jlo?lXcoo`S>oo3?"
            A$ = A$ + "jlo?lXcoo`S>oo3?j\_8Q4BlGLa5oW16HPO6HP1;000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000000000000000000000000000`?kX3^o\S>ooc>jlo?kXcoo\S>ooc>jlo?kXco"
            A$ = A$ + "o\S>ooc>jlo?kXcoo\S>ooc>jlo?kXcoo\S>ooc>jlo?kXcoo\S>ooc>jlo?kXcoo\S>ooc>jlo?kXcoo\S>ooc>jlo?kXcoo\S>"
            A$ = A$ + "ooc>jlo?kXcoo\S>ooc>jlo?kXcoo\S>ooc>jlo?kXcoo\S>ooc>jlo?kXcoo\S>oo3?klO@m`co41d?o_2:Wl?6EDaoQhQ7oS29"
            A$ = A$ + "Tlo9S<boP`17o7EC=m_^hRkojVK^oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kob6K\ook_on?e"
            A$ = A$ + "DCmoNfIWo_16Hlo6HPaoW<b8oOb8Slo9S<boW<b8oOb8Slo9S<boW<b8oOb8Slo9S<boW<b8oOb8Slo9S<boW<b8oOb8Slo9S<bo"
            A$ = A$ + "W<b8oOb8Slo9S<boW<b8oC28PlO<]dbo03<`ok\c>o_^iVkoc:[\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\"
            A$ = A$ + "oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\"
            A$ = A$ + "cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]"
            A$ = A$ + "c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>ko"
            A$ = A$ + "d>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cnO^hRkooj[_oWeEGm_4?l`oQhQ7oS29Tlo9S<boW<b8"
            A$ = A$ + "oOb8Slo9S<boW<b8oOb8Slo9S<boW<b8oOb8Slo9S<boW<b8oOb8Slo9S<boW<b8oOb8Slo9S<boW<b8oOb8Slo9S<boW<b8oOb8"
            A$ = A$ + "Slo9S<boW<b8oS29Tl?@l\co31d?o3D?llo?kXcoo\S>ooc>jlo?kXcoo\S>ooc>jlo?kXcoo\S>ooc>jlo?kXcoo\S>ooc>jlo?"
            A$ = A$ + "kXcoo\S>ooc>jlo?kXcoo\S>ooc>jlo?kXcoo\S>ooc>jlo?kXcoo\S>ooc>jlo?kXcoo\S>ooc>jlo?kXcnR4B8aOa5GlO6HP1n"
            A$ = A$ + "IP16\00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000n\C>hjc>il_?kTcon\C>okc>il_?kTcon\C>okc>il_?kTcon\C>okc>il_?kTcon\C>okc>"
            A$ = A$ + "il_?kTcon\C>okc>il_?kTcon\C>okc>il_?kTcon\C>okc>il_?kTcon\C>okc>il_?kTcon\C>okc>il_?kTcon\C>okc>il_?"
            A$ = A$ + "kTcon\C>okc>il_?kTcon\C>okc>il_?lXco0ec>o?4@nlo:XLboHDA5o7B7Ml?:S<boW8R8o3b6KlOD=edojVK^o[K^in?]c>ko"
            A$ = A$ + "d>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\o;K\ano_onkoDC=eokIWMno6HPaoKP16oOR8Rlo9R8boW8R8"
            A$ = A$ + "oOR8Rlo9R8boW8R8oOR8Rlo9R8boW8R8oOR8Rlo9R8boW8R8oOR8Rlo9R8boW8R8oOR8Rlo9R8boW8R8oOR8Rl?9Olaoa`2;o3<`"
            A$ = A$ + "0o_c>klojVK^o?[\bn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]"
            A$ = A$ + "c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>ko"
            A$ = A$ + "d>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\"
            A$ = A$ + "oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\"
            A$ = A$ + "cn?]c>kod>k\oCk\cn?]c>koiR;^oo[_nnOFGMeoBl`3o7B7Ml?:S<boW8R8oOR8Rlo9R8boW8R8oOR8Rlo9R8boW8R8oOR8Rlo9"
            A$ = A$ + "R8boW8R8oOR8Rlo9R8boW8R8oOR8Rlo9R8boW8R8oOR8Rlo9R8boW8R8oOR8Rlo9R8boW8R8oOR8Rl?:S<boo`S>o?4@nl?@m\co"
            A$ = A$ + "n\C>okc>il_?kTcon\C>okc>il_?kTcon\C>okc>il_?kTcon\C>okc>il_?kTcon\C>okc>il_?kTcon\C>okc>il_?kTcon\C>"
            A$ = A$ + "okc>il_?kTcon\C>okc>il_?kTcon\C>okc>il_?kTcon\C>k;B8P4?6GLaoIP16hW16H`200000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000hS>iP[?"
            A$ = A$ + "jTconXC>okS>il_?jTconXC>okS>il_?jTconXC>okS>il_?jTconXC>okS>il_?jTconXC>okS>il_?jTconXC>okS>il_?jTco"
            A$ = A$ + "nXC>okS>il_?jTconXC>okS>il_?jTconXC>okS>il_?jTconXC>okS>il_?jTconXC>okS>il_?jTconXC>okS>il_?jTcon\S>"
            A$ = A$ + "o34?klo@ohcoZLb9oOA5El?8MdaoW<b8oKR8Rlo7K\ao@eDCo[K^in_^iVkod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\"
            A$ = A$ + "cn?]c>kod>k\oCk\cn_\a6koonk_oC=eDo_WMfioJP16o[16Hl_9R8boV8R8oKR8Rl_9R8boV8R8oKR8Rl_9R8boV8R8oKR8Rl_9"
            A$ = A$ + "R8boV8R8oKR8Rl_9R8boV8R8oKR8Rl_9R8boV8R8oKR8Rl_9R8boSla7o33;\l?`03lo>k\co[K^ino\b:kod>k\oCk\cn?]c>ko"
            A$ = A$ + "d>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\"
            A$ = A$ + "oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\"
            A$ = A$ + "cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]"
            A$ = A$ + "c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oW;^hno_njko"
            A$ = A$ + "IMeEo7a3?l?8MdaoW<b8oKR8Rl_9R8boV8R8oKR8Rl_9R8boV8R8oKR8Rl_9R8boV8R8oKR8Rl_9R8boV8R8oKR8Rl_9R8boV8R8"
            A$ = A$ + "oKR8Rl_9R8boV8R8oKR8Rl_9R8boV8R8oKR8Rl_9R8boW<b8ooc>jlo@ohco0ac>okS>il_?jTconXC>okS>il_?jTconXC>okS>"
            A$ = A$ + "il_?jTconXC>okS>il_?jTconXC>okS>il_?jTconXC>okS>il_?jTconXC>okS>il_?jTconXC>okS>il_?jTconXC>okS>il_?"
            A$ = A$ + "jTconXC>okS>i\_8Q0BlHLa5oW16HPO6HP1;0000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000@?jP3^mX3>ogS>hlO?jPcomX3>ogS>hlO?jPcomX3>"
            A$ = A$ + "ogS>hlO?jPcomX3>ogS>hlO?jPcomX3>ogS>hlO?jPcomX3>ogS>hlO?jPcomX3>ogS>hlO?jPcomX3>ogS>hlO?jPcomX3>ogS>"
            A$ = A$ + "hlO?jPcomX3>ogS>hlO?jPcomX3>ogS>hlO?jPcomX3>ogS>hlO?jPcomX3>ogc>ilo?lXco2mC?o[b9Vlo5D@aoP`17oOR8Rl_9"
            A$ = A$ + "Q4boOXQ6o35C<m_^hRkojVK^oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kob6K\ook_on?eDCmo"
            A$ = A$ + "NfIWo[a5Gl_6GLaoV4B8oKB8Ql_9Q4boV4B8oKB8Ql_9Q4boV4B8oKB8Ql_9Q4boV4B8oKB8Ql_9Q4boV4B8oKB8Ql_9Q4boV4B8"
            A$ = A$ + "oKB8Ql_9Q4boV4B8o?R7Nl?<[\bo03<`ok\c>o_^iVkoc:[\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\"
            A$ = A$ + "cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]"
            A$ = A$ + "c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>ko"
            A$ = A$ + "d>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\"
            A$ = A$ + "oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cnO^hRkooj[_oWUEFmO4>h`oP`17oOR8Rl_9Q4boV4B8oKB8"
            A$ = A$ + "Ql_9Q4boV4B8oKB8Ql_9Q4boV4B8oKB8Ql_9Q4boV4B8oKB8Ql_9Q4boV4B8oKB8Ql_9Q4boV4B8oKB8Ql_9Q4boV4B8oKB8Ql_9"
            A$ = A$ + "Q4boV4B8oOR8Rl_?kTco2mC?oo3?jlO?jPcomX3>ogS>hlO?jPcomX3>ogS>hlO?jPcomX3>ogS>hlO?jPcomX3>ogS>hlO?jPco"
            A$ = A$ + "mX3>ogS>hlO?jPcomX3>ogS>hlO?jPcomX3>ogS>hlO?jPcomX3>ogS>hlO?jPcomX3>ogS>hlO?jPcnR428aSa5GlO6HP1nIP16"
            A$ = A$ + "\000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000mT3>hfC>hlO?iPcomT3>ogC>hlO?iPcomT3>ogC>hlO?iPcomT3>ogC>hlO?iPcomT3>ogC>hlO?"
            A$ = A$ + "iPcomT3>ogC>hlO?iPcomT3>ogC>hlO?iPcomT3>ogC>hlO?iPcomT3>ogC>hlO?iPcomT3>ogC>hlO?iPcomT3>ogC>hlO?iPco"
            A$ = A$ + "mT3>ogC>hlO?iPcomT3>ogC>hlO?jTcoo\S>o;T?ml_:VHboG@15o327Ll_9R8boU4B8okQ6Jl?D<adojR;^o[K^in?]c>kod>k\"
            A$ = A$ + "oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\o;K\ano_onkoDC=eokIWMn_6GLaoJLa5oGB8QlO9Q4boU4B8oGB8"
            A$ = A$ + "QlO9Q4boU4B8oGB8QlO9Q4boU4B8oGB8QlO9Q4boU4B8oGB8QlO9Q4boU4B8oGB8QlO9Q4boU4B8oGB8Ql_8Nhao_\b:o3<`0o_c"
            A$ = A$ + ">klojVK^o?[\bn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>ko"
            A$ = A$ + "d>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\"
            A$ = A$ + "oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\"
            A$ = A$ + "cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]"
            A$ = A$ + "c>kod>k\oCk\cn?]c>koiR;^oo[_nnOFFIeoAhP3o327Ll_9R8boU4B8oGB8QlO9Q4boU4B8oGB8QlO9Q4boU4B8oGB8QlO9Q4bo"
            A$ = A$ + "U4B8oGB8QlO9Q4boU4B8oGB8QlO9Q4boU4B8oGB8QlO9Q4boU4B8oGB8QlO9Q4boU4B8oGB8Ql_9R8bonXC>o;T?mlo?kXcomT3>"
            A$ = A$ + "ogC>hlO?iPcomT3>ogC>hlO?iPcomT3>ogC>hlO?iPcomT3>ogC>hlO?iPcomT3>ogC>hlO?iPcomT3>ogC>hlO?iPcomT3>ogC>"
            A$ = A$ + "hlO?iPcomT3>ogC>hlO?iPcomT3>ogC>hlO?iPcomT3>k;28P4?6GLaoIP16hW16H`2000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000`C>gP;?iLco"
            A$ = A$ + "lTc=ocC>gl??iLcolTc=ocC>gl??iLcolTc=ocC>gl??iLcolTc=ocC>gl??iLcolTc=ocC>gl??iLcolTc=ocC>gl??iLcolTc="
            A$ = A$ + "ocC>gl??iLcolTc=ocC>gl??iLcolTc=ocC>gl??iLcolTc=ocC>gl??iLcolTc=ocC>gl??iLcolTc=ocC>gl??iLcomX3>okc>"
            A$ = A$ + "ilO@n`coYHB9oO15Dl?8L`aoV8R8oGB8Ql_7JXao@a4Co[K^in_^iVkod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]"
            A$ = A$ + "c>kod>k\oCk\cn_\a6koonk_oC=eDo_WMfioJLa5o[a5GlO9Q4boU4B8oGB8QlO9Q4boU4B8oGB8QlO9Q4boU4B8oGB8QlO9Q4bo"
            A$ = A$ + "U4B8oGB8QlO9Q4boU4B8oGB8QlO9Q4boU4B8oGB8QlO9Q4boRhQ7oob:[l?`03lo>k\co[K^ino\b:kod>k\oCk\cn?]c>kod>k\"
            A$ = A$ + "oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\"
            A$ = A$ + "cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]"
            A$ = A$ + "c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>ko"
            A$ = A$ + "d>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oW;^hno_njkoIIUE"
            A$ = A$ + "o7Q3>l?8L`aoV8R8oGB8QlO9Q4boU4B8oGB8QlO9Q4boU4B8oGB8QlO9Q4boU4B8oGB8QlO9Q4boU4B8oGB8QlO9Q4boU4B8oGB8"
            A$ = A$ + "QlO9Q4boU4B8oGB8QlO9Q4boU4B8oGB8QlO9Q4boV8R8ogS>hlO@n`con\C>ocC>gl??iLcolTc=ocC>gl??iLcolTc=ocC>gl??"
            A$ = A$ + "iLcolTc=ocC>gl??iLcolTc=ocC>gl??iLcolTc=ocC>gl??iLcolTc=ocC>gl??iLcolTc=ocC>gl??iLcolTc=ocC>gl??iLco"
            A$ = A$ + "lTc=ocC>g\_8P0BlHLa5oW16HPO6HP1;00000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000?iL3^lTc=ocC>gl??iLcolTc=ocC>gl??iLcolTc=ocC>"
            A$ = A$ + "gl??iLcolTc=ocC>gl??iLcolTc=ocC>gl??iLcolTc=ocC>gl??iLcolTc=ocC>gl??iLcolTc=ocC>gl??iLcolTc=ocC>gl??"
            A$ = A$ + "iLcolTc=ocC>gl??iLcolTc=ocC>gl??iLcolTc=ocC>gl??iLcolTc=ogS>hl_?kTco1i3?oWR9Ul_5C<aoO\a6oGB8Ql?9P0bo"
            A$ = A$ + "MTA6oodB;m_^iVkojVK^oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kob6K\ook_on?eDCmoNfIW"
            A$ = A$ + "oWQ5FlO6FHaoT028oC28Pl?9P0boT028oC28Pl?9P0boT028oC28Pl?9P0boT028oC28Pl?9P0boT028oC28Pl?9P0boT028oC28"
            A$ = A$ + "Pl?9P0boT028o7B7Ml_;ZXbo03<`ok\c>o_^iVkoc:[\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]"
            A$ = A$ + "c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>ko"
            A$ = A$ + "d>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\"
            A$ = A$ + "oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\"
            A$ = A$ + "cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cnO^hRko0k[_oSUEFm?4=d`oO\a6oGB8Ql?9P0boT028oC28Pl?9"
            A$ = A$ + "P0boT028oC28Pl?9P0boT028oC28Pl?9P0boT028oC28Pl?9P0boT028oC28Pl?9P0boT028oC28Pl?9P0boT028oC28Pl?9P0bo"
            A$ = A$ + "T028oGB8QlO?jPco1i3?okc>il??iLcolTc=ocC>gl??iLcolTc=ocC>gl??iLcolTc=ocC>gl??iLcolTc=ocC>gl??iLcolTc="
            A$ = A$ + "ocC>gl??iLcolTc=ocC>gl??iLcolTc=ocC>gl??iLcolTc=ocC>gl??iLcolTc=ocC>gl??iLcnR028aSa5GlO6HP1nIP16\000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000kPc=h^3>glo>hLcokPc=o_3>glo>hLcokPc=o_3>glo>hLcokPc=o_3>glo>hLcokPc=o_3>glo>hLco"
            A$ = A$ + "kPc=o_3>glo>hLcokPc=o_3>glo>hLcokPc=o_3>glo>hLcokPc=o_3>glo>hLcokPc=o_3>glo>hLcokPc=o_3>glo>hLcokPc="
            A$ = A$ + "o_3>glo>hLcokPc=o_3>gl??iPcomXC>o3D?ll?:UDboF<a4ooa6KlO9Q4boT028ogA6IloC;]dojVK^o[K^in?]c>kod>k\oCk\"
            A$ = A$ + "cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\o;K\ano_onkoDC=eokIWMnO6FHaoIHQ5oC28Pl?9P0boT028oC28Pl?9"
            A$ = A$ + "P0boT028oC28Pl?9P0boT028oC28Pl?9P0boT028oC28Pl?9P0boT028oC28Pl?9P0boT028oC28PlO8Mdao^XR:o3<`0o_c>klo"
            A$ = A$ + "jVK^o?[\bn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\"
            A$ = A$ + "oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\"
            A$ = A$ + "cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]"
            A$ = A$ + "c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>ko"
            A$ = A$ + "d>k\oCk\cn?]c>koiR;^o3\_nn?FFIeo@d@3ooa6KlO9Q4boT028oC28Pl?9P0boT028oC28Pl?9P0boT028oC28Pl?9P0boT028"
            A$ = A$ + "oC28Pl?9P0boT028oC28Pl?9P0boT028oC28Pl?9P0boT028oC28Pl?9P0boT028oC28PlO9Q4bolT3>o3D?llO?jTcokPc=o_3>"
            A$ = A$ + "glo>hLcokPc=o_3>glo>hLcokPc=o_3>glo>hLcokPc=o_3>glo>hLcokPc=o_3>glo>hLcokPc=o_3>glo>hLcokPc=o_3>glo>"
            A$ = A$ + "hLcokPc=o_3>glo>hLcokPc=o_3>glo>hLcokPc=k;28P4?6GLaoIP16hW16H`20000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000Xc=fP[>gHcojLS="
            A$ = A$ + "o[c=fl_>gHcojLS=o[c=fl_>gHcojLS=o[c=fl_>gHcojLS=o[c=fl_>gHcojLS=o[c=fl_>gHcojLS=o[c=fl_>gHcojLS=o[c="
            A$ = A$ + "fl_>gHcojLS=o[c=fl_>gHcojLS=o[c=fl_>gHcojLS=o[c=fl_>gHcojLS=o[c=fl_>gHcojLS=o[c=fl_>gHcokPc=ocC>hlo?"
            A$ = A$ + "l\coW@29oGa4Cl_7JXaoT028o?b7Ol?7HPao>YTBo[;^hn_^iVkod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>ko"
            A$ = A$ + "d>k\oCk\cn_\a6koonk_oC=eDoOWLbioHDA5oSA5Elo8OlaoSla7o?b7Olo8OlaoSla7o?b7Olo8OlaoSla7o?b7Olo8OlaoSla7"
            A$ = A$ + "o?b7Olo8OlaoSla7o?b7Olo8OlaoSla7o?b7Olo8OlaoP`17ogB:Yl?`03lo>k\co[K^ino\b:kod>k\oCk\cn?]c>kod>k\oCk\"
            A$ = A$ + "cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]"
            A$ = A$ + "c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>ko"
            A$ = A$ + "d>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\"
            A$ = A$ + "oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oW;^hno_njkoGEEEoo03"
            A$ = A$ + "<l_7JXaoT028o?b7Olo8OlaoSla7o?b7Olo8OlaoSla7o?b7Olo8OlaoSla7o?b7Olo8OlaoSla7o?b7Olo8OlaoSla7o?b7Olo8"
            A$ = A$ + "OlaoSla7o?b7Olo8OlaoSla7o?b7Olo8OlaoT028o_3>glo?l\colT3>o[c=fl_>gHcojLS=o[c=fl_>gHcojLS=o[c=fl_>gHco"
            A$ = A$ + "jLS=o[c=fl_>gHcojLS=o[c=fl_>gHcojLS=o[c=fl_>gHcojLS=o[c=fl_>gHcojLS=o[c=fl_>gHcojLS=o[c=fl_>gHcojLS="
            A$ = A$ + "o[c=f\_8P0BlHLa5oW16HPO6HP1;000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000000000000000P>gH3^jLS=o[c=fl_>gHcojLS=o[c=fl_>gHcojLS=o[c=fl_>"
            A$ = A$ + "gHcojLS=o[c=fl_>gHcojLS=o[c=fl_>gHcojLS=o[c=fl_>gHcojLS=o[c=fl_>gHcojLS=o[c=fl_>gHcojLS=o[c=fl_>gHco"
            A$ = A$ + "jLS=o[c=fl_>gHcojLS=o[c=fl_>gHcojLS=o[c=fl_>gHcojLS=o_3>gl??iPcoo`c>oO29TlO5C<aoNXQ6oC28Plo8OlaoLP16"
            A$ = A$ + "okTB:m_^hRkojVK^oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kob6K\ook_on?eDCmoMb9WoSA5"
            A$ = A$ + "El?6EDaoSla7o?b7Olo8OlaoSla7o?b7Olo8OlaoSla7o?b7Olo8OlaoSla7o?b7Olo8OlaoSla7o?b7Olo8OlaoSla7o?b7Olo8"
            A$ = A$ + "OlaoSla7o327LlO;YTbo03<`ok\c>o_^iVkoc:[\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>ko"
            A$ = A$ + "d>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\"
            A$ = A$ + "oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\"
            A$ = A$ + "cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]"
            A$ = A$ + "c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cnO^hRkooj[_oOEEEmo3<``oNXQ6oC28Plo8OlaoSla7o?b7Olo8Olao"
            A$ = A$ + "Sla7o?b7Olo8OlaoSla7o?b7Olo8OlaoSla7o?b7Olo8OlaoSla7o?b7Olo8OlaoSla7o?b7Olo8OlaoSla7o?b7Olo8OlaoSla7"
            A$ = A$ + "oC28Plo>hLcoo`c>ocC>hl_>gHcojLS=o[c=fl_>gHcojLS=o[c=fl_>gHcojLS=o[c=fl_>gHcojLS=o[c=fl_>gHcojLS=o[c="
            A$ = A$ + "fl_>gHcojLS=o[c=fl_>gHcojLS=o[c=fl_>gHcojLS=o[c=fl_>gHcojLS=o[c=fl_>gHcnQ028aSa5GlO6HP1nIP16\0000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000jLC=hZc=el_>gDcojLC=o[c=el_>gDcojLC=o[c=el_>gDcojLC=o[c=el_>gDcojLC=o[c=el_>gDcojLC="
            A$ = A$ + "o[c=el_>gDcojLC=o[c=el_>gDcojLC=o[c=el_>gDcojLC=o[c=el_>gDcojLC=o[c=el_>gDcojLC=o[c=el_>gDcojLC=o[c="
            A$ = A$ + "el_>gDcojLC=o[c=elo>hHcolTc=oo3?jlo9T<boE<a4ogQ6Jlo8OlaoRhQ7o_a5GlOC:YdojVK^o[K^in?]c>kod>k\oCk\cn?]"
            A$ = A$ + "c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\o;K\ano_onkoDC=eog9WLn?6EDaoHDA5o;R7Nl_8NhaoRhQ7o;R7Nl_8Nhao"
            A$ = A$ + "RhQ7o;R7Nl_8NhaoRhQ7o;R7Nl_8NhaoRhQ7o;R7Nl_8NhaoRhQ7o;R7Nl_8NhaoRhQ7o;R7Nlo7K\ao\P2:o3<`0o_c>klojVK^"
            A$ = A$ + "o?[\bn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\"
            A$ = A$ + "cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]"
            A$ = A$ + "c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>ko"
            A$ = A$ + "d>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\"
            A$ = A$ + "oCk\cn?]c>koiR;^oo[_nnoEEEeo?`03ogQ6Jlo8OlaoRhQ7o;R7Nl_8NhaoRhQ7o;R7Nl_8NhaoRhQ7o;R7Nl_8NhaoRhQ7o;R7"
            A$ = A$ + "Nl_8NhaoRhQ7o;R7Nl_8NhaoRhQ7o;R7Nl_8NhaoRhQ7o;R7Nl_8NhaoRhQ7o;R7Nlo8OlaokPS=oo3?jl??iLcojLC=o[c=el_>"
            A$ = A$ + "gDcojLC=o[c=el_>gDcojLC=o[c=el_>gDcojLC=o[c=el_>gDcojLC=o[c=el_>gDcojLC=o[c=el_>gDcojLC=o[c=el_>gDco"
            A$ = A$ + "jLC=o[c=el_>gDcojLC=o[c=el_>gDcojLC=k728O4?6GLaoIP16hW16H`200000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000000000000000000000000000000000000000000000000000TS=ePK>fDcoiHC=oWS="
            A$ = A$ + "elO>fDcoiHC=oWS=elO>fDcoiHC=oWS=elO>fDcoiHC=oWS=elO>fDcoiHC=oWS=elO>fDcoiHC=oWS=elO>fDcoiHC=oWS=elO>"
            A$ = A$ + "fDcoiHC=oWS=elO>fDcoiHC=oWS=elO>fDcoiHC=oWS=elO>fDcoiHC=oWS=elO>fDcoiHC=oWS=elO>fDcojLS=o_3>gl_?kXco"
            A$ = A$ + "W@b8oGa4Cl?7JXaoRla7o7R7Nl_6GLao=YTBo[K^in_^iVkod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\"
            A$ = A$ + "oCk\cn_\a6koonk_oC=eDoOWLbioHDA5oSA5ElO8NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7"
            A$ = A$ + "NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7NlO8NhaoN\a6o_2:Xl?`03lo>k\co[K^ino\b:kod>k\oCk\cn?]c>kod>k\oCk\cn?]"
            A$ = A$ + "c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>ko"
            A$ = A$ + "d>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\"
            A$ = A$ + "oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\"
            A$ = A$ + "cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oW;^hn?`njkoGEEEoo03<l?7"
            A$ = A$ + "JXaoRla7o7R7NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7NlO8Nhao"
            A$ = A$ + "QhQ7o7R7NlO8NhaoQhQ7o7R7NlO8NhaoRla7o[c=fl_?kXcokPc=oWS=elO>fDcoiHC=oWS=elO>fDcoiHC=oWS=elO>fDcoiHC="
            A$ = A$ + "oWS=elO>fDcoiHC=oWS=elO>fDcoiHC=oWS=elO>fDcoiHC=oWS=elO>fDcoiHC=oWS=elO>fDcoiHC=oWS=elO>fDcoiHC=oWS="
            A$ = A$ + "e\O8PlAlHLa5oW16HPO6HP1;0000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000@>f@3^iH3=oWS=dlO>f@coiH3=oWS=dlO>f@coiH3=oWS=dlO>f@co"
            A$ = A$ + "iH3=oWS=dlO>f@coiH3=oWS=dlO>f@coiH3=oWS=dlO>f@coiH3=oWS=dlO>f@coiH3=oWS=dlO>f@coiH3=oWS=dlO>f@coiH3="
            A$ = A$ + "oWS=dlO>f@coiH3=oWS=dlO>f@coiH3=oWS=dlO>f@coiH3=o[c=elo>hHcon\C>oKb8Rl?5B8aoLTA6o;R7NlO8MdaoJHQ5ogDB"
            A$ = A$ + "9m_^hRkojVK^oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kob6K\ook_on?eDCmoMb9WoO15Dlo5"
            A$ = A$ + "D@aoQdA7o7B7MlO8MdaoQdA7o7B7MlO8MdaoQdA7o7B7MlO8MdaoQdA7o7B7MlO8MdaoQdA7o7B7MlO8MdaoQdA7o7B7MlO8Mdao"
            A$ = A$ + "QdA7okQ6Jlo:WLbo03<`ok\c>o_^iVkoc:[\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\"
            A$ = A$ + "oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\"
            A$ = A$ + "cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]"
            A$ = A$ + "c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>ko"
            A$ = A$ + "d>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cnO^hRko0ok_oOEEEm_3;\`oLTA6o;R7NlO8MdaoQdA7o7B7MlO8MdaoQdA7"
            A$ = A$ + "o7B7MlO8MdaoQdA7o7B7MlO8MdaoQdA7o7B7MlO8MdaoQdA7o7B7MlO8MdaoQdA7o7B7MlO8MdaoQdA7o7B7MlO8MdaoQdA7o;R7"
            A$ = A$ + "Nl_>gDcon\C>o_3>flO>f@coiH3=oWS=dlO>f@coiH3=oWS=dlO>f@coiH3=oWS=dlO>f@coiH3=oWS=dlO>f@coiH3=oWS=dlO>"
            A$ = A$ + "f@coiH3=oWS=dlO>f@coiH3=oWS=dlO>f@coiH3=oWS=dlO>f@coiH3=oWS=dlO>f@cnQ0b7aSa5GlO6HP1nIP16\00000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000hD3=hRC=dl?>e@cohD3=oSC=dl?>e@cohD3=oSC=dl?>e@cohD3=oSC=dl?>e@cohD3=oSC=dl?>e@cohD3=oSC="
            A$ = A$ + "dl?>e@cohD3=oSC=dl?>e@cohD3=oSC=dl?>e@cohD3=oSC=dl?>e@cohD3=oSC=dl?>e@cohD3=oSC=dl?>e@cohD3=oSC=dl?>"
            A$ = A$ + "e@cohD3=oSC=dlO>fDcojLS=ogS>il_9S8boD8Q4ocA6Il_8NhaoQdA7o[Q5FlOC9UdojR;^o[K^in?]c>kod>k\oCk\cn?]c>ko"
            A$ = A$ + "d>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\o;K\ano_onkoDC=eog9WLno5D@aoG@15o7B7MlO8MdaoQdA7o7B7MlO8MdaoQdA7"
            A$ = A$ + "o7B7MlO8MdaoQdA7o7B7MlO8MdaoQdA7o7B7MlO8MdaoQdA7o7B7MlO8MdaoQdA7o7B7Ml_7JXao[Lb9o3<`0o_c>klojVK^o?[\"
            A$ = A$ + "bn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]"
            A$ = A$ + "c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>ko"
            A$ = A$ + "d>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\"
            A$ = A$ + "oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\"
            A$ = A$ + "cn?]c>koiR;^o3l_onoEEEeo>\`2ocA6Il_8NhaoQdA7o7B7MlO8MdaoQdA7o7B7MlO8MdaoQdA7o7B7MlO8MdaoQdA7o7B7MlO8"
            A$ = A$ + "MdaoQdA7o7B7MlO8MdaoQdA7o7B7MlO8MdaoQdA7o7B7MlO8MdaoQdA7o7B7Ml_8NhaoiHC=ogS>il_>gHcohD3=oSC=dl?>e@co"
            A$ = A$ + "hD3=oSC=dl?>e@cohD3=oSC=dl?>e@cohD3=oSC=dl?>e@cohD3=oSC=dl?>e@cohD3=oSC=dl?>e@cohD3=oSC=dl?>e@cohD3="
            A$ = A$ + "oSC=dl?>e@cohD3=oSC=dl?>e@cohD3=k7b7O4?6GLaoIP16hW16H`2000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000000000000000000000000000000000000000000PC=cP;>e<cohDc<oSC=cl?>"
            A$ = A$ + "e<cohDc<oSC=cl?>e<cohDc<oSC=cl?>e<cohDc<oSC=cl?>e<cohDc<oSC=cl?>e<cohDc<oSC=cl?>e<cohDc<oSC=cl?>e<co"
            A$ = A$ + "hDc<oSC=cl?>e<cohDc<oSC=cl?>e<cohDc<oSC=cl?>e<cohDc<oSC=cl?>e<cohDc<oSC=cl?>e<coiH3=o[c=elO?jPcoU8B8"
            A$ = A$ + "o?A4Alo6HPaoQdA7o327LlO6EDao<Q4Bo[K^in_^iVkod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\"
            A$ = A$ + "cn_\a6koonk_oC=eDo?WK^ioC4A4o?A4AlO7ITaoMTA6ogA6IlO7ITaoMTA6ogA6IlO7ITaoMTA6ogA6IlO7ITaoMTA6ogA6IlO7"
            A$ = A$ + "ITaoMTA6ogA6IlO7ITaoMTA6ogA6IlO7ITaoJHQ5oO29Tl?`03lo>k\co[K^ino\b:kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>ko"
            A$ = A$ + "d>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\"
            A$ = A$ + "oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\"
            A$ = A$ + "cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]"
            A$ = A$ + "c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oW;^hn?`onkoFA5EogP2:lo6HPao"
            A$ = A$ + "QdA7o327Ll?8L`aoP`17o327Ll?8L`aoP`17o327Ll?8L`aoP`17o327Ll?8L`aoP`17o327Ll?8L`aoP`17o327Ll?8L`aoP`17"
            A$ = A$ + "o327Ll?8L`aoP`17o327Ll?8L`aoQdA7oWS=dlO?jPcojLC=oSC=cl?>e<cohDc<oSC=cl?>e<cohDc<oSC=cl?>e<cohDc<oSC="
            A$ = A$ + "cl?>e<cohDc<oSC=cl?>e<cohDc<oSC=cl?>e<cohDc<oSC=cl?>e<cohDc<oSC=cl?>e<cohDc<oSC=cl?>e<cohDc<oSC=c\O8"
            A$ = A$ + "OlAlHLa5oW16HPO6HP1;00000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000000000000`=d<3^g@c<oO3=clo=d<cog@c<oO3=clo=d<cog@c<oO3=clo=d<cog@c<"
            A$ = A$ + "oO3=clo=d<cog@c<oO3=clo=d<cog@c<oO3=clo=d<cog@c<oO3=clo=d<cog@c<oO3=clo=d<cog@c<oO3=clo=d<cog@c<oO3="
            A$ = A$ + "clo=d<cog@c<oO3=clo=d<cog@c<oO3=clo=d<cog@c<oSC=dlO>fDcolT3>oGR8Qlo4A4aoKP16o7B7Ml?8L`aoIDA5oc4B8m_^"
            A$ = A$ + "iVkojVK^oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kob6K\ook_on?eDCmoPniWo3R7Nl?8Nhao"
            A$ = A$ + "ZLb9o[b9Wl_:WLboZLb9o[b9Wl_:WLboZLb9o[b9Wl_:WLboZLb9o[b9Wl_:WLboZLb9o[b9Wl_:WLboZLb9o[b9Wl_:WLboZLb9"
            A$ = A$ + "oO29Tlo<a4co17L`ok\c>o_^iVkoc:[\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\"
            A$ = A$ + "cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]"
            A$ = A$ + "c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>ko"
            A$ = A$ + "d>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\"
            A$ = A$ + "oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cnO^hRko0ok_oK5EDmO3:X`oKP16o7B7Ml?8L`aoP`17o327Ll?8L`aoP`17o327"
            A$ = A$ + "Ll?8L`aoP`17o327Ll?8L`aoP`17o327Ll?8L`aoP`17o327Ll?8L`aoP`17o327Ll?8L`aoP`17o327Ll?8L`aoP`17o7B7Ml?>"
            A$ = A$ + "e@colT3>oWS=elo=d<cog@c<oO3=clo=d<cog@c<oO3=clo=d<cog@c<oO3=clo=d<cog@c<oO3=clo=d<cog@c<oO3=clo=d<co"
            A$ = A$ + "g@c<oO3=clo=d<cog@c<oO3=clo=d<cog@c<oO3=clo=d<cog@c<oO3=clo=d<cnQla7aSa5GlO6HP1nIP16\000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000g@S<hN3=blo=d8cog@S<oO3=blo=d8cog@S<oO3=blo=d8cog@S<oO3=blo=d8cog@S<oO3=blo=d8cog@S<oO3=blo="
            A$ = A$ + "d8cog@S<oO3=blo=d8cog@S<oO3=blo=d8cog@S<oO3=blo=d8cog@S<oO3=blo=d8cog@S<oO3=blo=d8cog@S<oO3=blo=d8co"
            A$ = A$ + "g@S<oO3=bl?>e<coiH3=ocC>gl?9R4boC4A4o[16Hl?8MdaoO`17oS15DloB8QdojVK^o[K^in?]c>kod>k\oCk\cn?]c>kod>k\"
            A$ = A$ + "oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\o;K\ano_onko>k\coS<b8oo_onkoonk_o3<`0o?`03lo03<`o3<`0o?`03lo03<`o3<`"
            A$ = A$ + "0o?`03lo03<`o3<`0o?`03lo03<`o3<`0o?`03lo03<`o3<`0o?`03lo03<`o3<`0o?`onko03<`o_lb;oob;_lojVK^o?[\bn?]"
            A$ = A$ + "c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>ko"
            A$ = A$ + "d>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\"
            A$ = A$ + "oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\"
            A$ = A$ + "cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]"
            A$ = A$ + "c>koiR;^o3l_on_EDAeo<XP2o[16Hl?8MdaoO`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`ao"
            A$ = A$ + "O`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17oo17Ll?8MdaohDc<ocC>glO>f@cog@S<oO3=blo=d8cog@S<"
            A$ = A$ + "oO3=blo=d8cog@S<oO3=blo=d8cog@S<oO3=blo=d8cog@S<oO3=blo=d8cog@S<oO3=blo=d8cog@S<oO3=blo=d8cog@S<oO3="
            A$ = A$ + "blo=d8cog@S<oO3=blo=d8cog@S<k7b7N4?6GLaoIP16hW16H`20000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000Hc<bP[=c8cof<S<oKc<bl_=c8co"
            A$ = A$ + "f<S<oKc<bl_=c8cof<S<oKc<bl_=c8cof<S<oKc<bl_=c8cof<S<oKc<bl_=c8cof<S<oKc<bl_=c8cof<S<oKc<bl_=c8cof<S<"
            A$ = A$ + "oKc<bl_=c8cof<S<oKc<bl_=c8cof<S<oKc<bl_=c8cof<S<oKc<bl_=c8cof<S<oKc<bl_=c8cog@c<oSC=dlo>hLcoT4B8o?A4"
            A$ = A$ + "Al_6GLaoP`17ooa6Kl?6D@ao;Q4Bo[;^hn_^iVkod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn_\"
            A$ = A$ + "a6koonk_ogLc=o?c<clo>k\cok\c>o_c>klo>k\cok\c>o_c>klo>k\cok\c>o_c>klo>k\cok\c>o_c>klo>k\cok\c>o_c>klo"
            A$ = A$ + ">k\cok\c>o_c>klo>k\cok\c>o_c>klo>k\cok\c>oob;_lo;_lbo[K^ino\b:kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\"
            A$ = A$ + "oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\"
            A$ = A$ + "cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]"
            A$ = A$ + "c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>ko"
            A$ = A$ + "d>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oW;^hn?`onkoFA5EocP2:l_6GLaoP`17"
            A$ = A$ + "ooa6Klo7K\aoO\a6ooa6Klo7K\aoO\a6ooa6Klo7K\aoO\a6ooa6Klo7K\aoO\a6ooa6Klo7K\aoO\a6ooa6Klo7K\aoO\a6ooa6"
            A$ = A$ + "Klo7K\aoO\a6ooa6Klo7K\aoP`17oO3=clo>hLcohD3=oKc<bl_=c8cof<S<oKc<bl_=c8cof<S<oKc<bl_=c8cof<S<oKc<bl_="
            A$ = A$ + "c8cof<S<oKc<bl_=c8cof<S<oKc<bl_=c8cof<S<oKc<bl_=c8cof<S<oKc<bl_=c8cof<S<oKc<bl_=c8cof<S<oKc<b\?8OhAl"
            A$ = A$ + "HLa5oW16HPO6HP1;000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000P=c43^f<C<oKc<al_=c4cof<C<oKc<al_=c4cof<C<oKc<al_=c4cof<C<oKc<"
            A$ = A$ + "al_=c4cof<C<oKc<al_=c4cof<C<oKc<al_=c4cof<C<oKc<al_=c4cof<C<oKc<al_=c4cof<C<oKc<al_=c4cof<C<oKc<al_="
            A$ = A$ + "c4cof<C<oKc<al_=c4cof<C<oKc<al_=c4cof<C<oO3=bl?>e<cokPS=oCB8Qlo4A0aoJLa5oo17Ll_7K\aoIHQ5o[S=flo]eFko"
            A$ = A$ + "kVK^oG;]dn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>koc:[\oO[]fno^jZkojVK^o[K^in_^iVkojVK^"
            A$ = A$ + "o[K^in_^iVkojVK^o[K^in_^iVkojVK^o[K^in_^iVkojVK^o[K^in_^iVkojVK^o[K^in_^iVkojVK^o[K^in_^iVkojVK^o[K^"
            A$ = A$ + "in_^iVkojVK^o_[^jno]fJkod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]"
            A$ = A$ + "c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>ko"
            A$ = A$ + "d>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\"
            A$ = A$ + "oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\"
            A$ = A$ + "cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn_^iVkomb;_o[dA7mO3;\`oKLa5ooa6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7"
            A$ = A$ + "K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oo17Llo=d8co"
            A$ = A$ + "kPS=oSC=cl_=c4cof<C<oKc<al_=c4cof<C<oKc<al_=c4cof<C<oKc<al_=c4cof<C<oKc<al_=c4cof<C<oKc<al_=c4cof<C<"
            A$ = A$ + "oKc<al_=c4cof<C<oKc<al_=c4cof<C<oKc<al_=c4cof<C<oKc<al_=c4cnPlQ7aSa5GlO6HP1nIP16\0000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000e8C<hFS<alO=b4coe8C<oGS<alO=b4coe8C<oGS<alO=b4coe8C<oGS<alO=b4coe8C<oGS<alO=b4coe8C<oGS<alO=b4co"
            A$ = A$ + "e8C<oGS<alO=b4coe8C<oGS<alO=b4coe8C<oGS<alO=b4coe8C<oGS<alO=b4coe8C<oGS<alO=b4coe8C<oGS<alO=b4coe8C<"
            A$ = A$ + "oGS<al_=c8cog@c<o[c=flo8Q0boC014oWQ5Flo7K\aoNXQ6o_a5Gl_8OlaoS6JXokK_mno]eFkod>k\oCk\cn?]c>kod>k\oCk\"
            A$ = A$ + "cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>koc:[\o?[\bno\b:koc:[\o?[\bno\b:koc:[\o?[\bno\b:koc:[\o?[\bno\"
            A$ = A$ + "b:koc:[\o?[\bno\b:koc:[\o?[\bno\b:koc:[\o?[\bno\b:koc:[\o?[\bno\b:koc:[\o?[\bno\b:kod>k\oCk\cn?]c>ko"
            A$ = A$ + "d>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\"
            A$ = A$ + "oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\"
            A$ = A$ + "cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]"
            A$ = A$ + "c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cn?]c>kod>k\oCk\cno]fJko"
            A$ = A$ + "m^k^o;K\an?:UDboBl`3ocA6IlO7JXaoNXQ6okQ6Jl_7JXaoNXQ6okQ6Jl_7JXaoNXQ6okQ6Jl_7JXaoNXQ6okQ6Jl_7JXaoNXQ6"
            A$ = A$ + "okQ6Jl_7JXaoNXQ6okQ6Jl_7JXaoNXQ6okQ6Jl_7JXaoNXQ6okQ6Jl_7K\aof<S<o[c=flo=d<coe8C<oGS<alO=b4coe8C<oGS<"
            A$ = A$ + "alO=b4coe8C<oGS<alO=b4coe8C<oGS<alO=b4coe8C<oGS<alO=b4coe8C<oGS<alO=b4coe8C<oGS<alO=b4coe8C<oGS<alO="
            A$ = A$ + "b4coe8C<oGS<alO=b4coe8C<k3R7N4?6GLaoIP16hW16H`200000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000000000000000000000000000000000000000DS<`PK=b0coe83<oGS<`lO=b0coe83<"
            A$ = A$ + "oGS<`lO=b0coe83<oGS<`lO=b0coe83<oGS<`lO=b0coe83<oGS<`lO=b0coe83<oGS<`lO=b0coe83<oGS<`lO=b0coe83<oGS<"
            A$ = A$ + "`lO=b0coe83<oGS<`lO=b0coe83<oGS<`lO=b0coe83<oGS<`lO=b0coe83<oGS<`lO=b0cof<C<oO3=blO>fDcoR028o;14Al?6"
            A$ = A$ + "FHaoNXQ6ogQ6JlO7ITaoE<a4ogfJ[m?a3?lojVK^oKK]en?]c>koeB;]oG;]dnO]dBkoeB;]oG;]dnO]dBkoeB;]oG;]dnO]dBko"
            A$ = A$ + "eB;]oG;]dnO]dBkoeB;]oG;]dnO]dBkoeB;]oG;]dnO]dBkoeB;]oG;]dnO]dBkoeB;]oG;]dnO]dBkoeB;]oG;]dnO]dBkoeB;]"
            A$ = A$ + "oG;]dnO]dBkoeB;]oG;]dnO]dBkoeB;]oG;]dnO]dBkoeB;]oG;]dnO]dBkoeB;]oG;]dnO]dBkoeB;]oG;]dnO]dBkoeB;]oG;]"
            A$ = A$ + "dnO]dBkoeB;]oG;]dnO]dBkoeB;]oG;]dnO]dBkoeB;]oG;]dnO]dBkoeB;]oG;]dnO]dBkoeB;]oG;]dnO]dBkoeB;]oG;]dnO]"
            A$ = A$ + "dBkoeB;]oG;]dnO]dBkoeB;]oG;]dnO]dBkoeB;]oG;]dnO]dBkoeB;]oG;]dnO]dBkoeB;]oG;]dnO]dBkoeB;]oG;]dnO]dBko"
            A$ = A$ + "eB;]oG;]dnO]dBkoeB;]oG;]dnO]dBkoeB;]oG;]dnO]dBkoeB;]oG;]dnO]dBkoeB;]oG;]dnO]dBkoeB;]oG;]dnO]dBkoeB;]"
            A$ = A$ + "oG;]dnO]dBkoeB;]oG;]dnO]dBkoeB;]oG;]dnO]dBkoeB;]oCk\cnO]dBkojVK^oGl`3oOPomgo?d@3oK15DlO7JXaoMXQ6ogQ6"
            A$ = A$ + "JlO7JXaoMXQ6ogQ6JlO7JXaoMXQ6ogQ6JlO7JXaoMXQ6ogQ6JlO7JXaoMXQ6ogQ6JlO7JXaoMXQ6ogQ6JlO7JXaoMXQ6ogQ6JlO7"
            A$ = A$ + "JXaoMXQ6ogQ6JlO7JXaoN\a6oKc<blO>fDcog@S<oGS<`lO=b0coe83<oGS<`lO=b0coe83<oGS<`lO=b0coe83<oGS<`lO=b0co"
            A$ = A$ + "e83<oGS<`lO=b0coe83<oGS<`lO=b0coe83<oGS<`lO=b0coe83<oGS<`lO=b0coe83<oGS<`lO=b0coe83<oGS<`\?8NhAlHLa5"
            A$ = A$ + "oW16HPO6HP1;0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000=a03^d43<oCC<`l?=a0cod43<oCC<`l?=a0cod43<oCC<`l?=a0cod43<oCC<`l?="
            A$ = A$ + "a0cod43<oCC<`l?=a0cod43<oCC<`l?=a0cod43<oCC<`l?=a0cod43<oCC<`l?=a0cod43<oCC<`l?=a0cod43<oCC<`l?=a0co"
            A$ = A$ + "d43<oCC<`l?=a0cod43<oCC<`l?=a0cod43<oGS<al_=c8coiHC=oKb8Rl_4@l`oF@15ogA6Il?7ITaoMTA6oSA5ElO:WLboM^iV"
            A$ = A$ + "o?[\bnO[\bjoYR:ZoOZYVn_YVJjoVJZYoKZYVn_YVJjoVJZYoKZYVn_YUFjoVFJYoKJYUn_YUFjoVFJYoKJYUn_YUFjoVFJYoKJY"
            A$ = A$ + "Un_YUFjoVFJYoKJYUn_YUFjoVFJYoKJYUnOYUFjoUFJYoGJYUnOYUFjoUFJYoGJYUnOYUFjoUFJYoGJYUnOYUFjoUFJYoGJYUnOY"
            A$ = A$ + "UFjoUFJYoGJYUnOYUFjoUFJYoGJYUnOYUFjoUFJYoGJYUnOYUFjoUFJYoGJYUnOYUFjoUFJYoGJYUnOYUFjoUFJYoGJYUnOYUFjo"
            A$ = A$ + "UFJYoGJYUnOYUFjoUFJYoGJYUnOYUFjoUFJYoGJYUnOYUFjoUFJYoGJYUnOYUFjoUFJYoGJYUnOYUFjoUFJYoGJYUnOYUFjoUFJY"
            A$ = A$ + "oGJYUnOYUFjoUFJYoGJYUnOYUFjoUFJYoGJYUnOYUFjoUFJYoGJYUnOYUFjoUFJYoGJYUnOYUFjoUFJYoGJYUnOYUFjoUFJYoGJY"
            A$ = A$ + "UnOYUFjoUFJYoGJYUn_YUFjoVFJYoKJYUn_YUFjoVFJYoKJYUn_YUFjoVFJYoKJYUn_YUFjoVFJYoKJYUn_YUFjoVFJYoKZYVn_Y"
            A$ = A$ + "VJjoVJZYoOZYVn?ZXRjo]b:[o?[\bn_YUFjo^`2;oo03<l_6GLaoMTA6ogA6IlO7ITaoMTA6ogA6IlO7ITaoMTA6ogA6IlO7ITao"
            A$ = A$ + "MTA6ogA6IlO7ITaoMTA6ogA6IlO7ITaoMTA6ogA6IlO7ITaoMTA6ogA6IlO7ITaoMTA6ogA6IlO7ITaoLP16o3B7Ml?>eDcohD3="
            A$ = A$ + "oKc<bl?=a0cod43<oCC<`l?=a0cod43<oCC<`l?=a0cod43<oCC<`l?=a0cod43<oCC<`l?=a0cod43<oCC<`l?=a0cod43<oCC<"
            A$ = A$ + "`l?=a0cod43<oCC<`l?=a0cod43<oCC<`l?=a0cod43<oCC<`l?=a0cnPhQ7aSa5GlO6HP1nIP16\00000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "d4c;hBC<_l?=albod4c;oCC<_l?=albod4c;oCC<_l?=albod4c;oCC<_l?=albod4c;oCC<_l?=albod4c;oCC<_l?=albod4c;"
            A$ = A$ + "oCC<_l?=albod4c;oCC<_l?=albod4c;oCC<_l?=albod4c;oCC<_l?=albod4c;oCC<_l?=albod4c;oCC<_l?=albod4c;oCC<"
            A$ = A$ + "_l?=a0cof<C<oWS=dlo;\`boC4Q4o?Q4Blo6HPaoLTA6ocA6Il?7ITaoF<a4o_C>il_S=fhoIR9VoCiTCn_TA6ioA29To7ITAn_T"
            A$ = A$ + "A6ioB6ITo?YTBnoTB:ioD>iToCiTCn?UDBioEB9UoK9UDn_UEFioGFIUoOYUFn?VFJioHNiUoWiUGnOVGNioJR9Vo[9VHn_VHRio"
            A$ = A$ + "KVIVo_IVIn?WJZioLZYVogiVKnOWK^ioNb9Wok9WLnoWMfioOfIWo3JWMn?XNjioPjYWo3ZWNn?XNjioPjYWo3ZWNn?XNjioPjYW"
            A$ = A$ + "o3ZWNn?XNjioPjYWo3ZWNn?XNjioPjYWo3ZWNn?XNjioPjYWo3ZWNn?XNjioPjYWo3ZWNn?XNjioPjYWo3ZWNn?XNjioPjYWo3ZW"
            A$ = A$ + "Nn?XNjioPjYWo3ZWNn?XNjioPjYWo3ZWNn?XNjioPjYWo3ZWNn?XNjioPjYWo3ZWNn?XNjioPjYWo3ZWNn?XNjioPjYWo3ZWNn?X"
            A$ = A$ + "NjioPjYWo3ZWNn?XNjioPjYWo3JWMnoWMfioOfIWok9WLn_WLbioM^iVogiVKn?WJZioLVIVo[IVIn_VIVioJR9Vo[9VHnOVGNio"
            A$ = A$ + "INiUoSiUGnoUFJioGFIUoKIUEn_UEFioEB9UoG9UDn?UC>ioD>iTo?YTBn_TA6ioB6ITo;ITAnoTB:ioEB9UoWIVIn?UC>io0iS?"
            A$ = A$ + "og`2;l?6EDaoLTA6ocA6Il?7ITaoLTA6ocA6Il?7ITaoLTA6ocA6Il?7ITaoLTA6ocA6Il?7ITaoLTA6ocA6Il?7ITaoLTA6ocA6"
            A$ = A$ + "Il?7ITaoLTA6ocA6Il?7ITaoLTA6ocA6Il?7ITaoLTA6o[a5Glo9T@bojPc=oO3=clO=b4cod4c;oCC<_l?=albod4c;oCC<_l?="
            A$ = A$ + "albod4c;oCC<_l?=albod4c;oCC<_l?=albod4c;oCC<_l?=albod4c;oCC<_l?=albod4c;oCC<_l?=albod4c;oCC<_l?=albo"
            A$ = A$ + "d4c;oCC<_l?=albod4c;k3R7N4?6GLaoIP16hW16H`2000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000000000000000000000000000000<3<_Pk<`lboc0c;o?3<_lo<`lboc0c;o?3<"
            A$ = A$ + "_lo<`lboc0c;o?3<_lo<`lboc0c;o?3<_lo<`lboc0c;o?3<_lo<`lboc0c;o?3<_lo<`lboc0c;o?3<_lo<`lboc0c;o?3<_lo<"
            A$ = A$ + "`lboc0c;o?3<_lo<`lboc0c;o?3<_lo<`lboc0c;o?3<_lo<`lboc0c;o?3<_lo<`lboc0c;oGS<alo=d<cohD3=ocQ6Il_4@0ao"
            A$ = A$ + "GDA5oc16Hl?7HPaoLP16oc16HlO5C<aoalb;o77L`mOS;^hoB6ITo79T@noTB:ioC:YToCYTBn_UEFioFFIUoSYUFn?VGNioIR9V"
            A$ = A$ + "o[9VHn_VHRioLZYVogiVKnOWK^ioNb9WooIWMn?XMfioQniWo;:XPnoXP2joS2:XoGZXRnOYR:joV>jXoO:YTn?ZUFjoYFJYoWZY"
            A$ = A$ + "Vn_ZVJjo\R:Zog:ZXn_[ZZjo^^jZokjZ[n_[[^jo^^jZokjZ[n_[[^jo^^jZokjZ[n_[[^jo^^jZokjZ[n_[[^jo^^jZokjZ[n_["
            A$ = A$ + "[^jo^^jZokjZ[n_[[^jo^^jZokjZ[n_[[^jo^^jZokjZ[n_[[^jo^^jZokjZ[n_[[^jo^^jZokjZ[n_[[^jo^^jZokjZ[n_[[^jo"
            A$ = A$ + "^^jZokjZ[n_[[^jo^^jZokjZ[n_[[^jo^^jZokjZ[n_[[^jo^^jZokjZ[n_[[^jo^^jZokjZ[n_[[^jo^^jZokjZ[n_[ZZjo]VJZ"
            A$ = A$ + "ocjYWn_ZWNjoYJZYoSJYUn?ZUFjoWB:YoKZXRn?YR:joT6JXo?:XPn_XP2joQniWo3JWMnoWMfioNb9WogiVKnoVIVioKVIVo[9V"
            A$ = A$ + "HnOVHRioHJYUoSYUFnoUEFioE>iToCYTBn_TB:ioC>iTooXS>noMeEgod<c<ok03<l?6EDaoLP16oc16Hl?7HPaoLP16oc16Hl?7"
            A$ = A$ + "HPaoLP16oc16Hl?7HPaoLP16oc16Hl?7HPaoLP16oc16Hl?7HPaoLP16oc16Hl?7HPaoLP16oc16Hl?7HPaoLP16oc16Hl?7HPao"
            A$ = A$ + "LP16o_a5Glo6HPaod43<o[3>glo=d<cod43<o?3<_lo<`lboc0c;o?3<_lo<`lboc0c;o?3<_lo<`lboc0c;o?3<_lo<`lboc0c;"
            A$ = A$ + "o?3<_lo<`lboc0c;o?3<_lo<`lboc0c;o?3<_lo<`lboc0c;o?3<_lo<`lboc0c;o?3<_lo<`lboc0c;o?3<_\o7NhAlHLa5oW16"
            A$ = A$ + "HPO6HP1;00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000`<`l2^c0c;o?3<_lo<`lboc0c;o?3<_lo<`lboc0c;o?3<_lo<`lboc0c;o?3<_lo<`lbo"
            A$ = A$ + "c0c;o?3<_lo<`lboc0c;o?3<_lo<`lboc0c;o?3<_lo<`lboc0c;o?3<_lo<`lboc0c;o?3<_lo<`lboc0c;o?3<_lo<`lboc0c;"
            A$ = A$ + "o?3<_lo<`lboc0c;o?3<_lo<`lboc0c;o;c;^l?=a0cof<S<o[c=elO<^dboD<a4o?A4AlO6GLaoKP16o_16Hlo6HPaoKP16oKa4"
            A$ = A$ + "Cl?7ITaolTC>oK5EDmOHOmeoQ16Ho7fGOm_HOmeoR16Ho;6HPm?IQ5foT5FHoGVHRmOIR9foV9VHoOfHSmoITAfoWA6IoSFIUm?J"
            A$ = A$ + "VIfoYIVIoWVIVm_JWMfoZMfIo[fIWm?KXQfo\Q6JogFJYmOKZYfo^YVJooVJZmoK[]fo_]fJo37K\mOL]efoaeFKo7WK^mOL^ifo"
            A$ = A$ + "aiVKo7WK^mOL^ifoaiVKo7WK^mOL^ifoaiVKo7WK^mOL^ifoaiVKo7WK^mOL^ifoaiVKo7WK^mOL^ifoaiVKo7WK^mOL^ifoaiVK"
            A$ = A$ + "o7WK^mOL^ifoaiVKo7WK^mOL^ifoaiVKo7WK^mOL^ifoaiVKo7WK^mOL^ifoaiVKo7WK^mOL^ifoaiVKo7WK^mOL^ifoaiVKo7WK"
            A$ = A$ + "^mOL^ifoaiVKo7WK^mOL^ifoaiVKo7WK^mOL^ifoaiVKo7WK^mOL^ifoaeFKo7GK]m?L\afo_a6KoofJ[m_KZYfo^YVJogVJZmOK"
            A$ = A$ + "YUfo[Q6Jo_6JXm_JWMfoZMfIoWVIVmOJVIfoXEFIoSFIUmoITAfoV=fHoKfHSmOIR9foU9VHoCFHQm?IQ5foS16Ho;6HPm_HOmeo"
            A$ = A$ + "RmeGoWeEGmo?l`coKP16o?A4Al_6GLaoKP16o_16Hlo6HPaoKP16o_16Hlo6HPaoKP16o_16Hlo6HPaoKP16o_16Hlo6HPaoKP16"
            A$ = A$ + "o_16Hlo6HPaoKP16o_16Hlo6HPaoKP16o_16Hlo6HPaoKP16o_16Hlo6HPaoKP16o_16HlO6FHaoZLb9ocC>hlO>e@cog@c<o?3<"
            A$ = A$ + "_lo<`lboc0c;o?3<_lo<`lboc0c;o?3<_lo<`lboc0c;o?3<_lo<`lboc0c;o?3<_lo<`lboc0c;o?3<_lo<`lboc0c;o?3<_lo<"
            A$ = A$ + "`lboc0c;o?3<_lo<`lboc0c;o?3<_lo<`lboc0c;o?3<_lo<`lbnOhQ7aSa5GlO6HP1nIP16\000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000blR;"
            A$ = A$ + "h:c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;"
            A$ = A$ + "^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<"
            A$ = A$ + "_hboc0c;oKc<blo=d<cokPS=ogb:Zlo4B8aoB014oWQ5Flo6GLaoKLa5o_a5Glo6GLaoIHQ5oGa4Cl?5A4aoF<a4oKa4Cl_5C<ao"
            A$ = A$ + "F<a4oKa4Cl_5C<aoF<a4oKa4Cl_5C<aoF<a4oKa4Cl_5C<aoF<a4oKa4Cl_5C<aoF<a4oKa4Cl_5C<aoF<a4oKa4Cl_5C<aoF<a4"
            A$ = A$ + "oKa4Cl_5C<aoF<a4oKa4Cl_5C<aoF<a4oKa4Cl_5C<aoF<a4oKa4Cl_5C<aoF<a4oKa4Cl_5C<aoF<a4oKa4Cl_5C<aoF<a4oKa4"
            A$ = A$ + "Cl_5C<aoF<a4oKa4Cl_5C<aoF<a4oKa4Cl_5C<aoF<a4oKa4Cl_5C<aoF<a4oKa4Cl_5C<aoF<a4oKa4Cl_5C<aoF<a4oKa4Cl_5"
            A$ = A$ + "C<aoF<a4oKa4Cl_5C<aoF<a4oKa4Cl_5C<aoF<a4oKa4Cl_5C<aoF<a4oKa4Cl_5C<aoF<a4oKa4Cl_5C<aoF<a4oKa4Cl_5C<ao"
            A$ = A$ + "F<a4oKa4Cl_5C<aoF<a4oKa4Cl_5C<aoF<a4oKa4Cl_5C<aoF<a4oKa4Cl_5C<aoF<a4oKa4Cl_5C<aoF<a4oKa4Cl_5C<aoF<a4"
            A$ = A$ + "oKa4Cl_5C<aoF<a4oKa4Cl_5C<aoF<a4oKa4Cl_5C<aoF<a4oKa4Cl_5C<aoF<a4oOa4Cl?5A4aoD8Q4oWQ5Flo6GLaoKLa5o_a5"
            A$ = A$ + "Glo6GLaoKLa5o_a5Glo6GLaoKLa5o_a5Glo6GLaoKLa5o_a5Glo6GLaoKLa5o_a5Glo6GLaoKLa5o_a5Glo6GLaoKLa5o_a5Glo6"
            A$ = A$ + "GLaoKLa5o_a5Glo6GLaoKLa5o[Q5Fl?6EDaoV<b8ocC>hlo>hLcohD3=oGS<al_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hbo"
            A$ = A$ + "blR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;"
            A$ = A$ + "o;c;^l_<_hboblR;koQ7M4?6GLaoIP16hW16H`20000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000000000000000000000000008c;^P[<_hboblR;o;c;^l_<_hboblR;o;c;^l_<"
            A$ = A$ + "_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hbo"
            A$ = A$ + "blR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l?=a0cohD3=oWS=el??iPco`hR;"
            A$ = A$ + "oWa5GlO4?l`oD<a4oWQ5Fl_6GLaoJLa5oWQ5FlO6FHaoIHQ5oWQ5FlO6FHaoIHQ5oWQ5FlO6FHaoHHQ5oSQ5Fl?6EDaoHDA5oSA5"
            A$ = A$ + "El?6EDaoHDA5oSA5El?6EDaoHDA5oSA5El?6EDaoHDA5oSA5El?6EDaoHDA5oSA5El?6EDaoHDA5oSA5El?6EDaoHDA5oSA5El?6"
            A$ = A$ + "EDaoHDA5oSA5El?6EDaoHDA5oSA5El?6EDaoHDA5oSA5El?6EDaoHDA5oSA5El?6EDaoHDA5oSA5El?6EDaoHDA5oSA5El?6EDao"
            A$ = A$ + "HDA5oSA5El?6EDaoHDA5oSA5El?6EDaoHDA5oSA5El?6EDaoHDA5oSA5El?6EDaoHDA5oSA5El?6EDaoHDA5oSA5El?6EDaoHDA5"
            A$ = A$ + "oSA5El?6EDaoHDA5oSA5El?6EDaoHDA5oSA5El?6EDaoHDA5oSA5El?6EDaoHDA5oSA5El?6EDaoHDA5oSA5El?6EDaoHDA5oSA5"
            A$ = A$ + "El?6EDaoHDA5oSA5El?6EDaoHDA5oSA5El?6EDaoHDA5oSA5El?6EDaoHDA5oSA5El?6EDaoHDA5oSA5El?6EDaoHDA5oSA5El?6"
            A$ = A$ + "EDaoHDA5oSA5El?6EDaoHDA5oSA5El?6EDaoHDA5oSA5El?6EDaoHDA5oSA5El?6FHaoIHQ5oWQ5FlO6FHaoIHQ5oWQ5FlO6FHao"
            A$ = A$ + "IHQ5oWQ5FlO6FHaoIHQ5oWQ5FlO6FHaoIHQ5oWQ5FlO6FHaoIHQ5oWQ5FlO6FHaoIHQ5oWQ5FlO6FHaoHDA5oO15Dl?7ITao^\R:"
            A$ = A$ + "okc>kl_?kXcokPc=oOC=dlo<`lboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;"
            A$ = A$ + "^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^\o7NdAlHLa5oW16HPO6"
            A$ = A$ + "HP1;000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000P<_h2^blR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;"
            A$ = A$ + "o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;"
            A$ = A$ + "^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboc0c;oKc<blO>fDcokPc=oo3?klO?jTco_`2;o3R7Nl_6HLaoIHQ5o[a5Glo6"
            A$ = A$ + "HPaoLTA6ocA6Il?7ITaoLTA6ocA6Il?7ITaoLXA6ogQ6JlO7JXaoMXQ6ogQ6JlO7JXaoMXQ6ogQ6JlO7JXaoN\Q6oka6Kl_7K\ao"
            A$ = A$ + "N\a6oka6Kl_7K\aoN\a6oka6Kl_7L\aoN\17oo17Llo7L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`aoOdA7o3B7Ml?8MdaoPdA7"
            A$ = A$ + "o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7"
            A$ = A$ + "Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8"
            A$ = A$ + "MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8Mdao"
            A$ = A$ + "PdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Mlo7M`aoO`17"
            A$ = A$ + "oo17Llo7L`aoO`17oo17Llo7L`aoO\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6KlO7KXaoMXQ6ogQ6JlO7JXaoMXQ6ogQ6"
            A$ = A$ + "JlO7JXaoMXQ6ocA6Il?7ITaoLTA6ocA6Il?7ITaoN\a6oCB8Ql_;[\bolT3>o?4@ol?@m`comXC>o_3>gl?=a0coblR;o;c;^l_<"
            A$ = A$ + "_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hbo"
            A$ = A$ + "blR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hbnOhA7aSa5GlO6HP1nIP16\0000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000blR;h:c;"
            A$ = A$ + "^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<"
            A$ = A$ + "_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hbo"
            A$ = A$ + "blR;o7S;]l_<_hbof<S<o_3>glO?jTcoo`c>o;d?nlO@ohco0i3?ogc>jlo?l\co1mS?oCD@0m_A39do8EDAoWdA6m_B8Mdo=YDB"
            A$ = A$ + "ok4C;m?D=edoAmTCo?ED@mOEB5eoFAeDoSEEEmOFGIeoKU5FogeFJm_GLaeoPiEGo;fGNm?IQ5foV=fHoOFITm?JVEfoZQfIo_VJ"
            A$ = A$ + "Ym_K[]fo_e6Ko7gK^m_L`1god9GLoKgLcmoMeAgohIWMo[7NhmoNiUgokUGNo_GNimoNiUgokUGNo_GNimoNiUgokUGNo_GNimoN"
            A$ = A$ + "iUgokUGNo_GNimoNiUgokUGNo_GNimoNiUgokUGNo_GNimoNiUgokUGNo_GNimoNiUgokUGNo_GNimoNiUgokUGNo_GNimoNiUgo"
            A$ = A$ + "kUGNo_GNimoNiUgokUGNo_GNimoNiUgokUGNo_GNimoNiUgokUGNo_GNimoNiUgokUGNo_GNimoNiUgokUGNo_GNimoNiUgokUGN"
            A$ = A$ + "o_GNimoNiUgokUGNo_GNimoNiUgokUGNo_GNimoNiUgokUGNo_GNimoNiUgokUGNo_GNimoNiUgokUGNo_GNimoNiUgokUGNo_GN"
            A$ = A$ + "imoNiUgokUGNo_GNimoNiUgokUGNo_GNimoNiUgokUGNo_GNimoNiUgojQgMoSWMem_Md=god9WLo;7L`m?L^ifo^afJocVJZm_J"
            A$ = A$ + "XMfoXEFIoK6ISm?IR9foR16Ho3VGNmoGLaeoM]UFo_EFHmOFFIeoFAeDoGUDBmoD@mdoAiDCooDC<mOC:Udo;U4BoWTA6moA5Ado"
            A$ = A$ + "59D@oCT@1m_A39do7=d@oC4@0mO@ndcoo`c>o_3>gl?=a0coahB;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;"
            A$ = A$ + "o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;^l_<_hboblR;o;c;"
            A$ = A$ + "^l_<_hboblR;koQ7M4?6GLaoIP16hW16H`200000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000004S;]PK<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dbo"
            A$ = A$ + "ahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;"
            A$ = A$ + "o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO=b4cojLc=okc>"
            A$ = A$ + "jl?@mdco0mS?o?D@olOA25do7Ad@oSTA5m_B7Ido<U4BokdB;moC=adoAiDCo?5D?m_EC9eoGE5EoWeEFm_FHMeoMYEFok5GKm?H"
            A$ = A$ + "MeeoQmUGo?FHQmOIS9foVE6IoSVIUm_JXMfo\YFJokfJ[m?L^efoamVKo?7L`m?Mc9gogA7MoSWMem_NhUgomUWNok7Olm?Pnego"
            A$ = A$ + "22hOo?HP1nOQ3>ho6B8QoK8Q4n_Q4Bho6B8QoK8Q4n_Q4Bho6B8QoK8Q4n_Q4Bho6B8QoK8Q4n_Q4Bho6B8QoK8Q4n_Q4Bho6B8Q"
            A$ = A$ + "oK8Q4n_Q4Bho6B8QoK8Q4n_Q4Bho6B8QoK8Q4n_Q4Bho6B8QoK8Q4n_Q4Bho6B8QoK8Q4n_Q4Bho6B8QoK8Q4n_Q4Bho6B8QoK8Q"
            A$ = A$ + "4n_Q4Bho6B8QoK8Q4n_Q4Bho6B8QoK8Q4n_Q4Bho6B8QoK8Q4n_Q4Bho6B8QoK8Q4n_Q4Bho6B8QoK8Q4n_Q4Bho6B8QoK8Q4n_Q"
            A$ = A$ + "4Bho6B8QoK8Q4n_Q4Bho6B8QoK8Q4n_Q4Bho6B8QoK8Q4n_Q4Bho6B8QoK8Q4n_Q4Bho6B8QoK8Q4n_Q4Bho6B8QoK8Q4n_Q4Bho"
            A$ = A$ + "6B8QoK8Q4n_Q4Bho6B8QoGhP2noP12ho1nWOooGOlmOOiYgokMgMoOGMdmOMc=goc57Lo7WK^m_K]afo]]VJo_FJXmOJWIfoWA6I"
            A$ = A$ + "oGfHRmoHQ1foQiUGok5GKmOGJUeoJQeEoSUEEm_ED=eoC9EDo7eC>moC<ado=]TBo_4B7m?B6Edo7Ad@oGT@1mo@0mco0e3?oWS="
            A$ = A$ + "elo<`lboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<"
            A$ = A$ + "^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]\o7MdAlHLa5oW16HPO6HP1;"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000@<^d2^ahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;"
            A$ = A$ + "]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<"
            A$ = A$ + "^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o;c;^l_=c8cokT3>ooC?ll_@0ico454@oKd@2moA5Ado"
            A$ = A$ + "9IDAo_4B7mOC:Ydo>adBo3EC<m_D?idoD55DoGeDBmoEEAeoHIEEo_5FGm?GJUeoN]eFooEGLmOHOmeoS56HoCfHRm_IT=foXIFI"
            A$ = A$ + "o[6JWm?KYUfo^afJooFK\mOL^ifob57LoGWLbm_Md=gohIWMo[gMgmoNiYgom]WNooGOlm?Poigo268Po?HP1noP16ho36HPo?HP"
            A$ = A$ + "1noP16ho36HPo?HP1noP16ho36HPo?HP1noP16ho36HPo?HP1noP16ho36HPo?HP1noP16ho36HPo?HP1noP16ho36HPo?HP1noP"
            A$ = A$ + "16ho36HPo?HP1noP16ho36HPo?HP1noP16ho36HPo?HP1noP16ho36HPo?HP1noP16ho36HPo?HP1noP16ho36HPo?HP1noP16ho"
            A$ = A$ + "36HPo?HP1noP16ho36HPo?HP1noP16ho36HPo?HP1noP16ho36HPo?HP1noP16ho36HPo?HP1noP16ho36HPo?HP1noP16ho36HP"
            A$ = A$ + "o?HP1noP16ho36HPo?HP1noP16ho36HPo?HP1noP16ho36HPo?HP1noP16ho36HPo?HP1noP16ho36HPo?HP1n_P0ngo0jGOok7O"
            A$ = A$ + "km?OjYgojMgMoSGMemOMc9goc5GLo7gK^moK\afo\]VJo_FJXmOJWIfoWE6IoGVHRmoHQ1foQmUGoo5GLm?GJUeoKQeEoSUEEm_E"
            A$ = A$ + "D=eoD9EDo;5D?m?D>edo>]dBocTB9m_B7Ido7E4AoGT@1mO@odcojLc=oGS<`l?<]`boahB;o7S;]lO<^dboahB;o7S;]lO<^dbo"
            A$ = A$ + "ahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;"
            A$ = A$ + "o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dbnOdA7aSa5GlO6HP1nIP16\00000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ahB;h6S;]lO<"
            A$ = A$ + "^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dbo"
            A$ = A$ + "ahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;"
            A$ = A$ + "o7S;]lO<^dboahB;o7S;]lO<^dbo`d2;o7S;]l_<_hboe8C<oO3=clo=d<cog@c<oSC=dl?>e@coiHC=oWS=el_>fHcojLS=o_3>"
            A$ = A$ + "glo>iPcolT3>ocC>hlO?jTcomXC>ogc>jl_?kXcon`c>oo3?kl?@m`co0iC?o3T?mlO@nhco2mS?o;d?nl_@0mco31d?o?D@0m?A"
            A$ = A$ + "11do59D@oGT@1mOA39do6=d@oKd@3moA4=do7E4AoSDA4m?B5Edo8EDAoSDA5m?B5Edo8EDAoSDA5m?B5Edo8EDAoSDA5m?B5Edo"
            A$ = A$ + "8EDAoSDA5m?B5Edo8EDAoSDA5m?B5Edo8EDAoSDA5m?B5Edo8EDAoSDA5m?B5Edo8EDAoSDA5m?B5Edo8EDAoSDA5m?B5Edo8EDA"
            A$ = A$ + "oSDA5m?B5Edo8EDAoSDA5m?B5Edo8EDAoSDA5m?B5Edo8EDAoSDA5m?B5Edo8EDAoSDA5m?B5Edo8EDAoSDA5m?B5Edo8EDAoSDA"
            A$ = A$ + "5m?B5Edo8EDAoSDA5m?B5Edo8EDAoSDA5m?B5Edo8EDAoSDA5m?B5Edo8EDAoSDA5m?B5Edo8EDAoSDA5m?B5Edo8EDAoSDA5m?B"
            A$ = A$ + "5Edo8EDAoSDA5m?B5Edo8EDAoSDA5m?B5Edo8EDAoSDA5m?B5Edo7E4AoO4A3moA4=do6=d@oGd@2mOA25do49D@o?D@0mo@0mco"
            A$ = A$ + "21d?o;d?nlO@nhco1iC?o3T?ml?@m`coo`c>ok3?kl_?kXcomXC>ogS>il??iPcokT3>o_3>gl_>hLcoiLS=oWS=elO>fDcohD3="
            A$ = A$ + "oO3=cl?=a0coblR;o3C;\l?<]`boahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;"
            A$ = A$ + "]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<"
            A$ = A$ + "^dboahB;koA7M4?6GLaoIP16hW16H`2000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000000000000000000000004S;]PK<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;"
            A$ = A$ + "o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;"
            A$ = A$ + "]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<"
            A$ = A$ + "^dboahB;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo"
            A$ = A$ + "_`b:oo2;[lo;\\bo_`b:oo2;[lo;\Xbo_\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:"
            A$ = A$ + "okR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:"
            A$ = A$ + "YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;"
            A$ = A$ + "ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo"
            A$ = A$ + "]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:"
            A$ = A$ + "ogR:YlO;ZTbo]XB:ogR:Yl_;[Tbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:oob:Zlo;\\bo_`b:oo2;"
            A$ = A$ + "[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o7S;]lO<^dboahB;o7S;]lO<"
            A$ = A$ + "^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dbo"
            A$ = A$ + "ahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]\o7MdAlHLa5oW16HPO6HP1;0000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000@<^d2^ahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<"
            A$ = A$ + "^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dbo"
            A$ = A$ + "ahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;"
            A$ = A$ + "o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;"
            A$ = A$ + "]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<"
            A$ = A$ + "^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dbo"
            A$ = A$ + "ahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;"
            A$ = A$ + "o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;"
            A$ = A$ + "]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<"
            A$ = A$ + "^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dbo"
            A$ = A$ + "ahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;"
            A$ = A$ + "o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dboahB;o7S;"
            A$ = A$ + "]lO<^dboahB;o7S;]lO<^dboahB;o7S;]lO<^dbnOdA7aSa5GlO6HP1nIP16\000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000000000000000000000000000000000000000000000000000000`dB;h2C;]l?<]dbo"
            A$ = A$ + "`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;"
            A$ = A$ + "o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;"
            A$ = A$ + "]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<"
            A$ = A$ + "]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo"
            A$ = A$ + "`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;"
            A$ = A$ + "o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;"
            A$ = A$ + "]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<"
            A$ = A$ + "]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo"
            A$ = A$ + "`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;"
            A$ = A$ + "o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;"
            A$ = A$ + "]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<"
            A$ = A$ + "]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo`dB;o3C;]l?<]dbo"
            A$ = A$ + "`dB;koA7M4?6GLaoIP16hW16H`20000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000000000000000C;\P;<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;"
            A$ = A$ + "\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<"
            A$ = A$ + "]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo"
            A$ = A$ + "`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;"
            A$ = A$ + "o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;"
            A$ = A$ + "\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<"
            A$ = A$ + "]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo"
            A$ = A$ + "`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;"
            A$ = A$ + "o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;"
            A$ = A$ + "\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<"
            A$ = A$ + "]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo"
            A$ = A$ + "`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;"
            A$ = A$ + "o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\\o7MdAlHLa5oW16HPO6HP1;00000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000<]`2^`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo"
            A$ = A$ + "`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;"
            A$ = A$ + "o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;"
            A$ = A$ + "\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<"
            A$ = A$ + "]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo"
            A$ = A$ + "`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;"
            A$ = A$ + "o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;"
            A$ = A$ + "\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<"
            A$ = A$ + "]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo"
            A$ = A$ + "`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;"
            A$ = A$ + "o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;"
            A$ = A$ + "\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<"
            A$ = A$ + "]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bnOdA7aSa5GlO6HP1nIP16\0000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000000000000000000000000000000000000000000000`d2;h2C;\l?<]`bo`d2;"
            A$ = A$ + "o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;"
            A$ = A$ + "\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<"
            A$ = A$ + "]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo"
            A$ = A$ + "`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;"
            A$ = A$ + "o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;"
            A$ = A$ + "\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<"
            A$ = A$ + "]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo"
            A$ = A$ + "`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;"
            A$ = A$ + "o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;"
            A$ = A$ + "\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<"
            A$ = A$ + "]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo"
            A$ = A$ + "`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;"
            A$ = A$ + "koA7M4?6GLaoIP16hW16H`200000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000C;\P;<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<"
            A$ = A$ + "]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo"
            A$ = A$ + "`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;"
            A$ = A$ + "o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;"
            A$ = A$ + "\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<"
            A$ = A$ + "]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo"
            A$ = A$ + "`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;"
            A$ = A$ + "o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;"
            A$ = A$ + "\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<"
            A$ = A$ + "]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo"
            A$ = A$ + "`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;"
            A$ = A$ + "o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;"
            A$ = A$ + "\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\\o7MdAlHLa5oW16HPO6HP1;000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000<]`2^`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;"
            A$ = A$ + "o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;"
            A$ = A$ + "\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<"
            A$ = A$ + "]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo"
            A$ = A$ + "`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;"
            A$ = A$ + "o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;"
            A$ = A$ + "\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<"
            A$ = A$ + "]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo"
            A$ = A$ + "`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;"
            A$ = A$ + "o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;"
            A$ = A$ + "\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<"
            A$ = A$ + "]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bo"
            A$ = A$ + "`d2;o3C;\l?<]`bo`d2;o3C;\l?<]`bnOdA7aSa5GlO6HP1nIP16\00000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000_`2;hn2;\lo;\`bo_`2;oo2;"
            A$ = A$ + "\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;"
            A$ = A$ + "\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo"
            A$ = A$ + "_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;"
            A$ = A$ + "oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;"
            A$ = A$ + "\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;"
            A$ = A$ + "\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo"
            A$ = A$ + "_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;"
            A$ = A$ + "oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;"
            A$ = A$ + "\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;"
            A$ = A$ + "\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo"
            A$ = A$ + "_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;"
            A$ = A$ + "oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;oo2;\lo;\`bo_`2;kkA7"
            A$ = A$ + "M4?6GLaoIP16hW16H`2000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000000l2;[Pk;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo"
            A$ = A$ + "_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:"
            A$ = A$ + "oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;"
            A$ = A$ + "[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;"
            A$ = A$ + "\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo"
            A$ = A$ + "_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:"
            A$ = A$ + "oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;"
            A$ = A$ + "[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;"
            A$ = A$ + "\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo"
            A$ = A$ + "_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:"
            A$ = A$ + "oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;"
            A$ = A$ + "[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;"
            A$ = A$ + "\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[\_7MdAlHLa5oW16HPO6HP1;0000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000`;\\2^_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;"
            A$ = A$ + "[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;"
            A$ = A$ + "\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo"
            A$ = A$ + "_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:"
            A$ = A$ + "oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;"
            A$ = A$ + "[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;"
            A$ = A$ + "\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo"
            A$ = A$ + "_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:"
            A$ = A$ + "oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;"
            A$ = A$ + "[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;"
            A$ = A$ + "\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo"
            A$ = A$ + "_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:"
            A$ = A$ + "oo2;[lo;\\bo_`b:oo2;[lo;\\bnNdA7aSa5GlO6HP1nIP16\000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000000000000000000000000000000000000000000_`b:hn2;[lo;\\bo_`b:oo2;[lo;"
            A$ = A$ + "\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo"
            A$ = A$ + "_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:"
            A$ = A$ + "oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;"
            A$ = A$ + "[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;"
            A$ = A$ + "\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo"
            A$ = A$ + "_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:"
            A$ = A$ + "oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;"
            A$ = A$ + "[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;"
            A$ = A$ + "\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo"
            A$ = A$ + "_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:"
            A$ = A$ + "oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;"
            A$ = A$ + "[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:kkA7M4?6"
            A$ = A$ + "GLaoIP16hW16H`20000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000l2;[Pk;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:"
            A$ = A$ + "oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;"
            A$ = A$ + "[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;"
            A$ = A$ + "\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo"
            A$ = A$ + "_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:"
            A$ = A$ + "oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;"
            A$ = A$ + "[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;"
            A$ = A$ + "\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo"
            A$ = A$ + "_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:"
            A$ = A$ + "oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;"
            A$ = A$ + "[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;"
            A$ = A$ + "\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo"
            A$ = A$ + "_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[\_7MdAlHLa5oW16HPO6HP1;00000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00`;\\2^_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;"
            A$ = A$ + "\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo"
            A$ = A$ + "_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:"
            A$ = A$ + "oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;"
            A$ = A$ + "[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;"
            A$ = A$ + "\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo"
            A$ = A$ + "_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:"
            A$ = A$ + "oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;"
            A$ = A$ + "[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;"
            A$ = A$ + "\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo"
            A$ = A$ + "_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:"
            A$ = A$ + "oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;[lo;\\bo_`b:oo2;"
            A$ = A$ + "[lo;\\bo_`b:oo2;[lo;\\bnNdA7aSa5GlO6HP1nIP16\0000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000000000000000000000000000000000^\b:hjb:[l_;[\bo^\b:okb:[l_;[\bo"
            A$ = A$ + "^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:"
            A$ = A$ + "okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:"
            A$ = A$ + "[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;"
            A$ = A$ + "[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo"
            A$ = A$ + "^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:"
            A$ = A$ + "okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:"
            A$ = A$ + "[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;"
            A$ = A$ + "[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo"
            A$ = A$ + "^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:"
            A$ = A$ + "okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:"
            A$ = A$ + "[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;"
            A$ = A$ + "[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:okb:[l_;[\bo^\b:kkA7M4?6GLao"
            A$ = A$ + "IP16hW16H`200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000hb:ZP[;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:"
            A$ = A$ + "Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;"
            A$ = A$ + "[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo"
            A$ = A$ + "^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:"
            A$ = A$ + "okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:"
            A$ = A$ + "Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;"
            A$ = A$ + "[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo"
            A$ = A$ + "^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:"
            A$ = A$ + "okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:"
            A$ = A$ + "Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;"
            A$ = A$ + "[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo"
            A$ = A$ + "^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:"
            A$ = A$ + "okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Z\_7MdAlHLa5oW16HPO6HP1;000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000P;"
            A$ = A$ + "[X2^^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo"
            A$ = A$ + "^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:ogR:Yl_;[Xbo]XB:"
            A$ = A$ + "okb:Zl_;[Xbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:"
            A$ = A$ + "YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]T2:ocB:XlO;"
            A$ = A$ + "ZPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo"
            A$ = A$ + "\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:"
            A$ = A$ + "ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:"
            A$ = A$ + "Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;"
            A$ = A$ + "YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo]T2:ocB:XlO;YPbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo"
            A$ = A$ + "]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:"
            A$ = A$ + "ogR:YlO;ZTbo^\R:okb:ZlO;ZTbo]XB:ogR:Yl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:"
            A$ = A$ + "Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;"
            A$ = A$ + "[Xbo^\R:okb:Zl_;[XbnNdA7aSa5GlO6HP1nIP16\00000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000^\R:hjb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:"
            A$ = A$ + "okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:"
            A$ = A$ + "Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo_`b:o7S;]lo<`lbod43<oCC<`lO=b4coe8C<oKc<bl_=c8cog@c<oOC=dlo="
            A$ = A$ + "e@cohD3=oWS=el_>gHcojLS=o[3>glo>hPcolT3>ocC>hlO?jTcomXC>ogc>jl_?kXcon\c>oo3?kl?@m`co0e3?o3D?mlO@mdco"
            A$ = A$ + "2mS?o;d?nl_@0mco21d?o?4@0m?A11do454@oCD@0mOA25do5=T@oKd@2m_A4=do7A4AoSDA4m?B5Ado8E4AoSDA4m?B5Ado8E4A"
            A$ = A$ + "oSDA4m?B5Ado8E4AoSDA4m?B5Ado8E4AoSDA4m?B5Ado8E4AoSDA4m?B5Ado8E4AoSDA4m?B5Ado8E4AoSDA4m?B5Ado8E4AoSDA"
            A$ = A$ + "4m?B5Ado8E4AoSDA4m?B5Ado8E4AoSDA4m?B5Ado8E4AoSDA4m?B5Ado8E4AoSDA4m?B5Ado8E4AoSDA4m?B5Ado8E4AoSDA4m?B"
            A$ = A$ + "5Ado8E4AoSDA4m?B5Ado8E4AoSDA4m?B5Ado8E4AoSDA4m?B5Ado8E4AoSDA4m?B5Ado8E4AoSDA4m?B5Ado8E4AoSDA4m?B5Ado"
            A$ = A$ + "8E4AoSDA4m?B5Ado8E4AoSDA4m?B5Ado8E4AoSDA4m?B5Ado8E4AoSDA4m?B5Ado8E4AoSDA4m?B5Ado8E4AoSDA4m?B5Ado8E4A"
            A$ = A$ + "oSDA4m?B5Ado8E4AoODA4m_A4=do6=T@oGd@2mOA25do454@oCD@0mo@0mco21d?o;d?nl_@ohco1iC?o3D?llo?m`coo`c>ok3?"
            A$ = A$ + "kl_?k\con\S>ogS>il??iPcolT3>o_C>hl_>hLcojLS=o[c=fl?>e@cohD3=oOC=dlo=d<cof<S<oGS<alO=b4cod43<o?3<_l_<"
            A$ = A$ + "_hbo_`b:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo"
            A$ = A$ + "^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:kkA7M4?6GLaoIP16"
            A$ = A$ + "hW16H`2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000hb:ZP[;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;"
            A$ = A$ + "[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl?<]`bo"
            A$ = A$ + "c0c;oGS<al_=c8cohD3=oWS=el_>gHcojPc=o_3>gl??iPcomXC>okc>jl_?l\con`3?o3D?llO@m`co2mS?o?4@olo@11do35D@"
            A$ = A$ + "oGT@1m_A25do7Ad@oOTA4moA7Edo:MDAo_TA7m?C9Mdo=YDBogdB:mOC;]do?]dBo3EC<m?D>adoAmTCo75D?moD@1eoD55DoGUD"
            A$ = A$ + "AmOEB5eoE=UDoK5ECmoEEAeoHIEEoWUEFm_FGIeoJMUEo[eEFm_FGIeoJMUEo[eEFm_FGIeoJMUEo[eEFm_FGIeoJMUEo[eEFm_F"
            A$ = A$ + "GIeoJMUEo[eEFm_FGIeoJMUEo[eEFm_FGIeoJMUEo[eEFm_FGIeoJMUEo[eEFm_FGIeoJMUEo[eEFm_FGIeoJMUEo[eEFm_FGIeo"
            A$ = A$ + "JMUEo[eEFm_FGIeoJMUEo[eEFm_FGIeoJMUEo[eEFm_FGIeoJMUEo[eEFm_FGIeoJMUEo[eEFm_FGIeoJMUEo[eEFm_FGIeoJMUE"
            A$ = A$ + "o[eEFm_FGIeoJMUEo[eEFm_FGIeoJMUEo[eEFm_FGIeoJMUEo[eEFm_FGIeoJMUEo[eEFm_FGIeoJMUEo[eEFm_FGIeoJMUEo[eE"
            A$ = A$ + "Fm_FGIeoJMUEo[eEFm_FGIeoJMUEo[eEFm_FGIeoJMUEo[eEFm_FGIeoJMUEo[eEFm_FGIeoJMUEo[eEFmOFGIeoHIEEoOEEDm_E"
            A$ = A$ + "D=eoF=UDoGEDAm?EA1eoB1eCo7eC>mOD>edo@e4Coo4C;mOC;Ydo<YDBocDB8moB8Mdo:IdAoSdA5moA6Ado6=T@oGT@1m?A25do"
            A$ = A$ + "354@o;d?nl_@ohco0e3?oo3?ll_?l\con\S>ogC>hlo>hLcojPc=o[c=flO>fDcog@c<oGS<alo<`lbo`d2;okb:Zl_;[Xbo^\R:"
            A$ = A$ + "okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:"
            A$ = A$ + "Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Z\_7MdAlHLa5oW16HPO6HP1;0000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000P;[X2^"
            A$ = A$ + "^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:"
            A$ = A$ + "okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo]XR:okb:Zl?<]dbod43<oGS<alO=b4cof<S<oO3=dlO>fDcojLS=o[3>"
            A$ = A$ + "glo>hLcolT3>ogS>il_?kXcon`c>ok3?mlo?mdco1e3?o;d?olo@01do35D@o?T@2mOA29do69T@oO4A4moA5Edo8ITAoWTA6moB"
            A$ = A$ + "7Mdo<QdAogTB9mOC;Ydo=]dBokdB;m?D=ado@e4Co7eC>mOD@1eoC5EDoCEDAmOEB9eoE9UDoKeDCmoEDAeoGEEEoSUEFmOFGMeo"
            A$ = A$ + "JMeEo[eEGm_FGMeoJMeEo[eEGm_FGMeoJMeEo[eEGm_FGMeoJMeEo[eEGm_FGMeoJMeEo[eEGm_FGMeoJMeEo[eEGm_FGMeoJMeE"
            A$ = A$ + "o[eEGm_FGMeoJMeEo[eEGm_FGMeoJMeEo[eEGm_FGMeoJMeEo[eEGm_FGMeoJMeEo[eEGm_FGMeoJMeEo[eEGm_FGMeoJMeEo[eE"
            A$ = A$ + "Gm_FGMeoJMeEo[eEGm_FGMeoJMeEo[eEGm_FGMeoJMeEo[eEGm_FGMeoJMeEo[eEGm_FGMeoJMeEo[eEGm_FGMeoJMeEo[eEGm_F"
            A$ = A$ + "GMeoJMeEo[eEGm_FGMeoJMeEo[eEGm_FGMeoJMeEo[eEGm_FGMeoJMeEo[eEGm_FGMeoJMeEo[eEGm_FGMeoJMeEo[eEGm_FGMeo"
            A$ = A$ + "JMeEo[eEGm_FGMeoJMeEo[eEGm_FGMeoJMeEo[eEGm_FGMeoJMeEoSUEFmoEEEeoGA5EoKeDCmOEB9eoD5EDo;5D@mOD?idoAiDC"
            A$ = A$ + "o3EC<m_C<]do=]TBocTB9m?C9Qdo;QdAoWdA7m?B6Ido7EDAoKd@3mOA29do49T@o?D@1mo@olco2mc?o3D?mlo?ldcon`c>okc>"
            A$ = A$ + "jlO?iPcokPc=o[3>gl_>gHcohDC=oO3=dlO=b4coe8C<oCC<`lO<^hbo^\b:ogR:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;"
            A$ = A$ + "[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo^\R:okb:Zl_;[Xbo"
            A$ = A$ + "^\R:okb:Zl_;[XbnNdA7aSa5GlO6HP1nIP16\000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000000000000000000000000000000]XR:hfR:ZlO;ZXbo]XR:ogR:ZlO;ZXbo]XR:ogR:"
            A$ = A$ + "ZlO;ZXbo]XR:ogR:ZlO;ZXbo]XR:ogR:ZlO;ZXbo]XR:ogR:ZlO;ZXbo]XR:ogR:ZlO;ZXbo]XR:ogR:ZlO;ZXbo]XR:ogR:ZlO;"
            A$ = A$ + "ZXbo]XB:ogR:Zl?<]dboblb;o?3<`l?=a4cod8S<oCC<alO<^hbo_`2;ok2;[l_;\`bo_`2;o3C;\l?<]dboahR;o;c;^l_<_lbo"
            A$ = A$ + "alb;o?c;_lo<`0cod4C<oCC<al?=b8coe8S<oKS<bl_=c<cof@c<oOC=dlo=e@cohDC=oWC=el_>gHcojLc=o[3>gl_>hLcokT3>"
            A$ = A$ + "ocC>hl??jTcolXS>ogc>jl_?kXcon\c>okc>klo?l`co0e3?o3D?ml?@ndco1mS?o;d?nl_@ohco2mS?o;d?nl_@ohco2mS?o;d?"
            A$ = A$ + "nl_@ohco2mS?o;d?nl_@ohco2mS?o;d?nl_@ohco2mS?o;d?nl_@ohco2mS?o;d?nl_@ohco2mS?o;d?nl_@ohco2mS?o;d?nl_@"
            A$ = A$ + "ohco2mS?o;d?nl_@ohco2mS?o;d?nl_@ohco2mS?o;d?nl_@ohco2mS?o;d?nl_@ohco2mS?o;d?nl_@ohco2mS?o;d?nl_@ohco"
            A$ = A$ + "2mS?o;d?nl_@ohco2mS?o;d?nl_@ohco2mS?o;d?nl_@ohco2mS?o;d?nl_@ohco2mS?o;d?nl_@ohco2mS?o;d?nl_@ohco2mS?"
            A$ = A$ + "o;d?nl_@ohco2mS?o;d?nl_@ohco2mS?o;d?nl_@ohco2mS?o;d?nl_@ohco2mS?o;d?nl_@ohco2mS?o;d?nl_@ohco2mS?o;d?"
            A$ = A$ + "nl_@ohco2mS?o;d?nl?@ndco0eC?o3D?llo?l`con\c>okc>jlO?jXcolXC>ocC>ilo>iPcojPc=o[c=gl_>gHcoiHS=oSC=el?>"
            A$ = A$ + "eDcogD3=oK3=cl_=c8coe8S<oGS<bl?=a4cod03<o?3<`l_<_lboblb;o;c;^lO<^hbo`d2;oo2;\l_;\`bo_`2;o7S;^l?=a0co"
            A$ = A$ + "e8C<oCC<alo<`0coblb;o3C;]lO;ZXbo]XB:ogR:ZlO;ZXbo]XR:ogR:ZlO;ZXbo]XR:ogR:ZlO;ZXbo]XR:ogR:ZlO;ZXbo]XR:"
            A$ = A$ + "ogR:ZlO;ZXbo]XR:ogR:ZlO;ZXbo]XR:ogR:ZlO;ZXbo]XR:ogR:ZlO;ZXbo]XR:ogR:ZlO;ZXbo]XR:kkA7M4?6GLaoIP16hWa5"
            A$ = A$ + "G`20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000dR:YPK;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo"
            A$ = A$ + "]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:Yl?<]\boahB;o;c;^lo<`lbob0S;"
            A$ = A$ + "ocR:Ylo9T<boQhA7o;b7Nl?:VDbo[Pb9o_2:Wlo:XLbo[Pb9o_2:Wlo:XLbo[PR9o_2:Vlo:XLbo[PR9o[b9Vl_:WHbo[LR9o[b9"
            A$ = A$ + "Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:"
            A$ = A$ + "WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHbo"
            A$ = A$ + "ZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9"
            A$ = A$ + "o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9"
            A$ = A$ + "Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:"
            A$ = A$ + "WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHbo"
            A$ = A$ + "ZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vlo:WHboZLR9"
            A$ = A$ + "o[2:Vlo:XHbo[PR9o_2:Vlo:XLbo[Pb9o_2:Wlo:XLboYHB9oCB8Pl?8M`aoU8B8o_2:WlO<^dbod43<o;c;^lO<^dbo`d2;ogR:"
            A$ = A$ + "YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;"
            A$ = A$ + "ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:Y\_7M`AlHLa5oW16HPO6GL1;00000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000@;ZT2^]XB:"
            A$ = A$ + "ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:"
            A$ = A$ + "YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:Ylo;\\bo`d2;o7S;]l_<_hbo_`b:oO29SlO8NdaoV<R8oGT@1moHPmeogAgLoo7Okm_O"
            A$ = A$ + "kYgon]WNokgNjm_OkYgon]WNokgNjm_OkYgon]WNokgNjm_OkYgon]WNokgNjm_OkYgon]WNokgNjm_OkYgon]WNokgNjm_OkYgo"
            A$ = A$ + "n]WNokgNjm_OkYgon]WNokgNjm_OkYgon]WNokgNjm_OkYgon]WNokgNjm_OkYgon]WNokgNjm_OkYgon]WNokgNjm_OkYgon]WN"
            A$ = A$ + "okgNjm_OkYgon]WNokgNjm_OkYgon]WNokgNjm_OkYgon]WNokgNjm_OkYgon]WNokgNjm_OkYgon]WNokgNjm_OkYgon]WNokgN"
            A$ = A$ + "jm_OkYgon]WNokgNjm_OkYgon]WNokgNjm_OkYgon]WNokgNjm_OkYgon]WNokgNjm_OkYgon]WNokgNjm_OkYgon]WNokgNjm_O"
            A$ = A$ + "kYgon]WNokgNjm_OkYgon]WNokgNjm_OkYgon]WNokgNjm_OkYgon]WNokgNjm_OkYgon]WNokgNjm_OkYgon]WNokgNjm_OkYgo"
            A$ = A$ + "n]WNokgNjm_OkYgon]WNokgNjm_OkYgon]WNokgNjm_OkYgon]WNokgNjm_OkYgon]WNokgNjm_OkYgon]WNokgNjm_OkYgon]WN"
            A$ = A$ + "okgNjm_OkYgon]WNokgNjm_OkYgon]WNokgNjm_OkYgon]WNokgNjm_OkYgon]WNokgNjm_OkYgon]WNokgNjm_OkYgon]WNokgN"
            A$ = A$ + "jm_OkYgon]WNokgNjm_OkYgon]WNokgNjm_OkYgon]WNokgNjm_OkYgon]WNokgNjm_OkYgon]WNokgNjm_OkYgon]WNokgNjm_O"
            A$ = A$ + "kYgooagNo[gMfm_JWIfo?adBogb:ZlO8NdaoV<R8ogR:Ylo<`lboahB;o3C;\lo;\\bo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo"
            A$ = A$ + "]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:"
            A$ = A$ + "ogR:YlO;ZTbnNd17aSa5GlO6GL1nILa5\0000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000000000000000000000]XB:hfR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;"
            A$ = A$ + "ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:Yl_;[Xbo"
            A$ = A$ + "_`2;o3C;\lO<^dbo]\R:oKb8RlO8NdaoiHC=okfJZm?R5Bho9JHQoOhP3n_Q3:ho6>XPoKhP2n_Q3:ho6>XPoKhP2n_Q3:ho6>XP"
            A$ = A$ + "oKhP2n_Q3:ho6>XPoKhP2n_Q3:ho6>XPoKhP2n_Q3:ho6>XPoKhP2n_Q3:ho6>XPoKhP2n_Q3:ho6>XPoKhP2n_Q3:ho6>XPoKhP"
            A$ = A$ + "2n_Q3:ho6>XPoKhP2n_Q3:ho6>XPoKhP2n_Q3:ho6>XPoKhP2n_Q3:ho6>XPoKhP2n_Q3:ho6>XPoKhP2n_Q3:ho6>XPoKhP2n_Q"
            A$ = A$ + "3:ho6>XPoKhP2n_Q3:ho6>XPoKhP2n_Q3:ho6>XPoKhP2n_Q3:ho6>XPoKhP2n_Q3:ho6>XPoKhP2n_Q3:ho6>XPoKhP2n_Q3:ho"
            A$ = A$ + "6>XPoKhP2n_Q3:ho6>XPoKhP2n_Q3:ho6>XPoKhP2n_Q3:ho6>XPoKhP2n_Q3:ho6>XPoKhP2n_Q3:ho6>XPoKhP2n_Q3:ho6>XP"
            A$ = A$ + "oKhP2n_Q3:ho6>XPoKhP2n_Q3:ho6>XPoKhP2n_Q3:ho6>XPoKhP2n_Q3:ho6>XPoKhP2n_Q3:ho6>XPoKhP2n_Q3:ho6>XPoKhP"
            A$ = A$ + "2n_Q3:ho6>XPoKhP2n_Q3:ho6>XPoKhP2n_Q3:ho6>XPoKhP2n_Q3:ho6>XPoKhP2n_Q3:ho6>XPoKhP2n_Q3:ho6>XPoKhP2n_Q"
            A$ = A$ + "3:ho6>XPoKhP2n_Q3:ho6>XPoKhP2n_Q3:ho6>XPoKhP2n_Q3:ho6>XPoKhP2n_Q3:ho6>XPoKhP2n_Q3:ho6>XPoKhP2n_Q3:ho"
            A$ = A$ + "6>XPoKhP2n_Q3:ho6>XPoKhP2n_Q3:ho6>XPoKhP2n_Q3:ho6>XPoKhP2n_Q3:ho6>XPoKXP2n_Q3:ho9JHQoWXQ5n_NgIgo8E4A"
            A$ = A$ + "o;b7Nl?9Q0bo[T2:o7S;]lo;\`bo_`b:okb:ZlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:"
            A$ = A$ + "YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:kkA7L4?6GLaoILa5hWa5G`20"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000dR:YPK;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:"
            A$ = A$ + "ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo_`b:oo2;\lO<^`bo_`b:oK29SlO8N`ao354@o3XO"
            A$ = A$ + "mmOR6Jho5:HPoCHP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q"
            A$ = A$ + "26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho"
            A$ = A$ + "4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HP"
            A$ = A$ + "oCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP"
            A$ = A$ + "1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q"
            A$ = A$ + "26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho"
            A$ = A$ + "4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HP"
            A$ = A$ + "oCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP"
            A$ = A$ + "1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCHP1n?Q26ho7F8QoOHQ5n?FFEeoS0b7oCR8Pl?;YPbo`d2;oo2;[l_;"
            A$ = A$ + "[Xbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo"
            A$ = A$ + "]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:Y\_7M`AlHLa5oWa5GPO6GL1;000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000@;ZT2^]XB:ogR:"
            A$ = A$ + "YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;"
            A$ = A$ + "ZTbo]XB:ogR:YlO;ZTbo]XR:oo2;[l_;\`bo`d2;oWR9UlO8NhaoiHC=o7hOnm?R6Fho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho"
            A$ = A$ + "4:HPo?XP1noP12ho368Po?HP0noP12ho368Po?HP0noP12ho368Po?HP0noP12ho368Po?HP0noP12ho368Po?HP0noP12ho368P"
            A$ = A$ + "o?HP0noP12ho368Po?HP0noP12ho368Po?HP0noP12ho368Po?HP0noP12ho368Po?HP0noP12ho368Po?HP0noP12ho368Po?HP"
            A$ = A$ + "0noP12ho368Po?HP0noP12ho368Po?HP0noP12ho368Po?HP0noP12ho368Po?HP0noP12ho368Po?HP0noP12ho368Po?HP0noP"
            A$ = A$ + "12ho368Po?HP0noP12ho368Po?HP0noP12ho368Po?HP0noP12ho368Po?HP0noP12ho368Po?HP0noP12ho368Po?HP0noP12ho"
            A$ = A$ + "368Po?HP0noP12ho368Po?HP0noP12ho368Po?HP0noP12ho368Po?HP0noP12ho368Po?HP0noP12ho368Po?HP0noP12ho368P"
            A$ = A$ + "o?HP0noP12ho368Po?HP0noP12ho368Po?HP0noP12ho368Po?HP0noP12ho368Po?HP0noP12ho368Po?HP0noP12ho368Po?HP"
            A$ = A$ + "0noP12ho368Po?HP0noP12ho368Po?HP0noP12ho368Po?HP0noP12ho368Po?HP0noP12ho368Po?HP0noP12ho368Po?HP0noP"
            A$ = A$ + "12ho368Po?HP0noP12ho368Po?HP0noP12ho368Po?HP0noP12ho368Po?HP0noP12ho368Po?HP0noP12ho368PoCXP1n?Q26ho"
            A$ = A$ + "4:HPoCXP1n?Q26ho4:HPoCXP1nOQ4>ho9NXQok4C;m?8MdaoV<b8okb:Zlo;\`bo]\R:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:"
            A$ = A$ + "ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:YlO;ZTbo]XB:ogR:"
            A$ = A$ + "YlO;ZTbnNd17aSQ5FlO6GL1nILa5\00000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000\TB:hbB:Yl?;YTbo\TB:ocB:Yl?;YTbo\TB:ocB:Yl?;YTbo"
            A$ = A$ + "\TB:ocB:Yl?;YTbo\TB:ocB:Yl?;YTbo\TB:ocB:Yl?;YTbo\TB:ocB:Yl?;YTbo\TB:ocB:Yl?;YTbo\TB:ogR:Zl_;[\bo_`2;"
            A$ = A$ + "ocR:Yl?9Q4boW@29o7gK^mOR7Jho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho12hOok7OkmOPoigo4:HPoCXP1n?Q26ho4:HPoCXP"
            A$ = A$ + "1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q"
            A$ = A$ + "26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho"
            A$ = A$ + "4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HP"
            A$ = A$ + "oCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP"
            A$ = A$ + "1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q"
            A$ = A$ + "26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho"
            A$ = A$ + "4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HP"
            A$ = A$ + "oCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoCXP1n?Q26ho4:HPo;8Pom_Olago0nWOo?XP1n?Q26ho4:HPoCXP1n?Q26ho4:HPoK8Q"
            A$ = A$ + "3nOPoigoe8S<o7R7NlO:WLbo^`2;ogR:Yl?;YTbo\TB:ocB:Yl?;YTbo\TB:ocB:Yl?;YTbo\TB:ocB:Yl?;YTbo\TB:ocB:Yl?;"
            A$ = A$ + "YTbo\TB:ocB:Yl?;YTbo\TB:ocB:Yl?;YTbo\TB:ocB:Yl?;YTbo\TB:ocB:Yl?;YTbo\TB:kk17L4?6FHaoILa5hWa5G`200000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000`B:XP;;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:"
            A$ = A$ + "Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:XlO;ZTbo^\R:oo2;[lO:WHboO`17oSDA5mOR6Jho4:HPoCXP1n?Q"
            A$ = A$ + "26ho4:HPoCXP1n_P0ngooeGOo7YS=no[ZVjo3gK_o_<a4oob4?lo;Cl`o_<a3oob4?lo;Cl`o_<a3oob4?lo;Cl`o_<a3oob4?lo"
            A$ = A$ + ";Cl`o_<a3oob4?lo;Cl`o_<a3oob4?lo;Cl`o_<a3oob4?lo;Cl`o_<a3oob4?lo;Cl`o_<a3oob4?lo;Cl`o_<a3oob4?lo;Cl`"
            A$ = A$ + "o_<a3oob4?lo;Cl`o_<a3oob4?lo;Cl`o_<a3oob4?lo;Cl`o_<a3oob4?lo;Cl`o_<a3oob4?lo;Cl`o_<a3oob4?lo;Cl`o_<a"
            A$ = A$ + "3oob4?lo;Cl`o_<a3oob4?lo;Cl`o_<a3oob4?lo;Cl`o_<a3oob4?lo;Cl`o_<a3oob4?lo;Cl`o_<a3oob4?lo;Cl`o_<a3oob"
            A$ = A$ + "4?lo;Cl`o_<a3oob4?lo;Cl`o_<a3oob4?lo;Cl`o_<a3oob4?lo;Cl`o_<a3oob4?lo;Cl`o_<a3oob4?lo;Cl`o_<a3oob4?lo"
            A$ = A$ + ";Cl`o_<a3oob4?lo;Cl`o_<a3oob4?lo;Cl`o_<a3oob4?lo;Cl`o_<a3oob4?lo;Cl`o_<a3oob4?lo;Cl`o_<a3oob4?lo;Cl`"
            A$ = A$ + "o_<a3oob4?lo;Cl`o_<a3oob4?lo;Cl`o_<a3oob4?lo;Cl`o_<a3oob4?lo;Cl`o_<a3oob4?lo;Cl`o_<a3oob4?lo;Cl`o_<a"
            A$ = A$ + "3oob4?lo;Cl`o_<a3oob4?lo;Cl`o_<a3oob4?lo;Cl`o_<a3oob4?lo;Cl`o_<a3oob4?lo;Cl`o_<a3oob4?lo;Cl`o_<a3oob"
            A$ = A$ + "4?lo;Cl`ocLa4ooa03loe2;\oSIUDnOPoigo1nWOoCXP1n?Q26ho4:HPoCXP1n?Q26ho:RhQok5GKmO8MhaoW@b8ok2;[l_;[Tbo"
            A$ = A$ + "\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:"
            A$ = A$ + "ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:X\_7L`AlHHQ5oWa5GPO6GL1;0000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000000000000000000000000000000000000000000000000;YP2^\T2:ocB:Xl?;"
            A$ = A$ + "YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo"
            A$ = A$ + "\T2:ocB:Xl?;YPbo]XB:okb:Zl_;\\boW@29o?28Pl?JUAfo9NXQoCXP1nOQ26ho5:HPoGXP1n_Poigo6>XPoO[\anOhJWmo\C>i"
            A$ = A$ + "oc>iSo_jR;noZ;^ho[^hRo_jR;noZ;^ho[^hRo_jR;noZ;^ho[^hRo_jR;noZ;^ho[^hRo_jR;noZ;^ho[^hRo_jR;noZ;^ho[^h"
            A$ = A$ + "Ro_jR;noZ;^ho[^hRo_jR;noZ;^ho[^hRo_jR;noZ;^ho[^hRo_jR;noZ;^ho[^hRo_jR;noZ;^ho[^hRo_jR;noZ;^ho[^hRo_j"
            A$ = A$ + "R;noZ;^ho[^hRo_jR;noZ;^ho[^hRo_jR;noZ;^ho[^hRo_jR;noZ;^ho[^hRo_jR;noZ;^ho[^hRo_jR;noZ;^ho[^hRo_jR;no"
            A$ = A$ + "Z;^ho[^hRo_jR;noZ;^ho[^hRo_jR;noZ;^ho[^hRo_jR;noZ;^ho[^hRo_jR;noZ;^ho[^hRo_jR;noZ;^ho[^hRo_jR;noZ;^h"
            A$ = A$ + "o[^hRo_jR;noZ;^ho[^hRo_jR;noZ;^ho[^hRo_jR;noZ;^ho[^hRo_jR;noZ;^ho[^hRo_jR;noZ;^ho[^hRo_jR;noZ;^ho[^h"
            A$ = A$ + "Ro_jR;noZ;^ho[^hRo_jR;noZ;^ho[^hRo_jR;noZ;^ho[^hRo_jR;noZ;^ho[^hRo_jR;noZ;^ho[^hRo_jR;noZ;^ho[^hRo_j"
            A$ = A$ + "R;noZ;^ho[^hRo_jR;noZ;^ho[^hRo_jR;noZ;^ho[^hRo_jR;noZ;^ho[^hRo_jR;noZ;^ho[^hRo_jR;noZ;^ho[^hRo_jR;no"
            A$ = A$ + "Z;^ho[^hRo_jR;noZ;^ho[^hRo_jR;noZ;^ho[^hRo_jR;noZ;^ho[^hRo_jR;noZ;^ho[^hRo_jR;no[?nhocNiToOiNkmo4k[_"
            A$ = A$ + "o3IS<n?Pmego5:HPoGXP1nOQ26ho4:HPoO8Q3n?OjUgo\TB:oCB8Ql_;ZTbo^\R:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:"
            A$ = A$ + "Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;"
            A$ = A$ + "YPbnN`a6aSQ5FlO6GL1nILa5\000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000000000000000000\T2:hbB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:"
            A$ = A$ + "ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ogR:Yl_;[Xbo^\R:oKb8"
            A$ = A$ + "Rl?:UDbojQgMoSHQ5nOQ3:ho5>XPoGhP2n_P02ho9JXQogla5oOkVKnoY7NhoOngOo_iOomoWomgoOngOooiOomoWomgoOngOooi"
            A$ = A$ + "OomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomo"
            A$ = A$ + "WomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomg"
            A$ = A$ + "oOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOng"
            A$ = A$ + "OooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooi"
            A$ = A$ + "OomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomo"
            A$ = A$ + "WomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomg"
            A$ = A$ + "oOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOng"
            A$ = A$ + "OooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoKngOooiOomoX3>hogNiUo?gDCmoF>YTo7XOnmOQ3:ho5>XPoGhP2n_Q"
            A$ = A$ + "3>ho5:XPocC>ilO8Nhao]XB:okb:Zl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo"
            A$ = A$ + "\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:kk17K4?6FHaoILa5hWa5G`2000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000`B:XP;;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;"
            A$ = A$ + "YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:XlO;ZTbo^\R:okb:ZlO9R4bo`dB;o7hOnm_Q4>ho5>XPoGhP2n?Q26ho"
            A$ = A$ + "4:HPoS\`1o_kUKnoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomg"
            A$ = A$ + "oOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOng"
            A$ = A$ + "OooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooi"
            A$ = A$ + "OomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomo"
            A$ = A$ + "WomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomg"
            A$ = A$ + "oOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOng"
            A$ = A$ + "OooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooi"
            A$ = A$ + "OomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomo"
            A$ = A$ + "WomgoOngOooiOomoWomgoOngOooiOomo\?nhocMeDooS<bho22hOoGhP2nOQ3:ho6BhPoShQ6nOB7IdoPdA7ogR:Yl_;[Xbo\T2:"
            A$ = A$ + "ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:"
            A$ = A$ + "Xl?;YPbo\T2:ocB:Xl?;YPbo\T2:ocB:X\_7L\AlHHQ5oWa5GPO6GL1;00000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000000000000000000000000000000000000000000000000`:XP2^[P2:o_2:Xlo:XPbo"
            A$ = A$ + "[P2:o_2:Xlo:XPbo[P2:o_2:Xlo:XPbo[P2:o_2:Xlo:XPbo[P2:o_2:Xlo:XPbo[P2:o_2:Xlo:XPbo[P2:o_2:Xlo:XPbo[P2:"
            A$ = A$ + "o_2:Xlo:XPbo\TB:ogR:ZlO;ZXboS4B8oGc<cl_P0ngo6BhPoGhP2nOQ3:ho0jGOo[ZYUnOkTCnoX3>hoOngOooiOomoWomgoOng"
            A$ = A$ + "OooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooi"
            A$ = A$ + "OomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomo"
            A$ = A$ + "WomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomg"
            A$ = A$ + "oOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOng"
            A$ = A$ + "OooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooi"
            A$ = A$ + "OomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomo"
            A$ = A$ + "WomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomg"
            A$ = A$ + "oOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOng"
            A$ = A$ + "Oo_kUGno4kK_o;8PomOQ3:ho5>XPoGhP2nOR7Jho:QdAooA7Ml?;YTbo]XR:o_2:Xlo:XPbo[P2:o_2:Xlo:XPbo[P2:o_2:Xlo:"
            A$ = A$ + "XPbo[P2:o_2:Xlo:XPbo[P2:o_2:Xlo:XPbo[P2:o_2:Xlo:XPbo[P2:o_2:Xlo:XPbo[P2:o_2:Xlo:XPbo[P2:o_2:Xlo:XPbn"
            A$ = A$ + "N\a6aSQ5FlO6GL1nILa5\0000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000000000[P2:h^2:Xlo:XPbo[P2:o_2:Xlo:XPbo[P2:o_2:Xlo:XPbo[P2:o_2:"
            A$ = A$ + "Xlo:XPbo[P2:o_2:Xlo:XPbo[P2:o_2:Xlo:XPbo[P2:o_2:Xlo:XPbo[P2:o_2:Xlo:XPbo[P2:ocB:YlO;ZXbo]XR:o?B8Ql?="
            A$ = A$ + "b8co22hOoK8Q3nOQ3:ho4:HPoK8Q3nOe>klo[?nhoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomo"
            A$ = A$ + "WomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomg"
            A$ = A$ + "oOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOng"
            A$ = A$ + "OooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooi"
            A$ = A$ + "OomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomo"
            A$ = A$ + "WomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomg"
            A$ = A$ + "oOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOng"
            A$ = A$ + "OooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooi"
            A$ = A$ + "OomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoY3>hoK^gNo_UB6io22hOoGhP2nOQ3:ho"
            A$ = A$ + "9NXQo[4B7mo7Mdao\TB:ogR:Zlo:XPbo[P2:o_2:Xlo:XPbo[P2:o_2:Xlo:XPbo[P2:o_2:Xlo:XPbo[P2:o_2:Xlo:XPbo[P2:"
            A$ = A$ + "o_2:Xlo:XPbo[P2:o_2:Xlo:XPbo[P2:o_2:Xlo:XPbo[P2:o_2:Xlo:XPbo[P2:kka6K4?6FHaoILa5hWa5G`20000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000\2:WPk:XLbo[Pb9o_2:Wlo:XLbo[Pb9o_2:Wlo:XLbo[Pb9o_2:Wlo:XLbo[Pb9o_2:Wlo:XLbo[Pb9o_2:Wlo:XLbo"
            A$ = A$ + "[Pb9o_2:Wlo:XLbo[Pb9o_2:Wlo:XLbo[Pb9o_2:Wl?;YPbo]XB:ogR:Ylo8Q0bod8C<o;8Pom_Q4>ho5>XPo;8Pnm?VEBioVkmg"
            A$ = A$ + "oS>hPooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOng"
            A$ = A$ + "OooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooi"
            A$ = A$ + "OomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomo"
            A$ = A$ + "WomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomg"
            A$ = A$ + "oOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOng"
            A$ = A$ + "OooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooi"
            A$ = A$ + "OomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomo"
            A$ = A$ + "WomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomgoOngOooiOomoWomg"
            A$ = A$ + "oOngOooiOomoWomgoOngOooiOomoWomgoOngOoOkTCnoaf:[ooGOlmOQ3:ho5>XPoWhQ6n_B8MdoOd17ocB:XlO;ZTbo[Pb9o_2:"
            A$ = A$ + "Wlo:XLbo[Pb9o_2:Wlo:XLbo[Pb9o_2:Wlo:XLbo[Pb9o_2:Wlo:XLbo[Pb9o_2:Wlo:XLbo[Pb9o_2:Wlo:XLbo[Pb9o_2:Wlo:"
            A$ = A$ + "XLbo[Pb9o_2:Wlo:XLbo[Pb9o_2:W\_7K\AlHHQ5oWa5GPO6GL1;000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000000000000000000000000000000000000000`:XL2^[Pb9o_2:Wlo:XLbo[Pb9"
            A$ = A$ + "o_2:Wlo:XLbo[Pb9o_2:Wlo:XLbo[Pb9o_2:Wlo:XLbo[Pb9o_2:Wlo:XLbo[Pb9o_2:Wlo:XLbo[Pb9o_2:Wlo:XLbo[Pb9o_2:"
            A$ = A$ + "Wlo:XLbo\T2:ogR:YlO;ZTboS428oCS<aloP02ho7B8QoKhP3nOPnegoYF:Yo[^hRooiP3noW3ngoO>hOooiPomoW3ngoO>hOooi"
            A$ = A$ + "PomoW3ngoO>hOooiPomoW3ngoO>hOooiPomoW3ngoO>hOooiPomoW3ngoO>hOooiPomoW3ngoO>hOooiPomoW3ngoO>hOooiPomo"
            A$ = A$ + "W3ngoO>hOooiPomoW3ngoO>hOooiPomoW3ngoO>hOooiPomoW3ngoO>hOooiPomoW3ngoO>hOooiPomoW3ngoO>hOooiPomoW3ng"
            A$ = A$ + "oO>hOooiPomoW3ngoO>hOooiPomoW3ngoO>hOooiPomoW3ngoO>hOooiPomoW3ngoO>hOooiPomoW3ngoO>hOooiPomoW3ngoO>h"
            A$ = A$ + "OooiPomoW3ngoO>hOooiPomoW3ngoO>hOooiPomoW3ngoO>hOooiPomoW3ngoO>hOooiPomoW3ngoO>hOooiPomoW3ngoO>hOooi"
            A$ = A$ + "PomoW3ngoO>hOooiPomoW3ngoO>hOooiPomoW3ngoO>hOooiPomoW3ngoO>hOooiPomoW3ngoO>hOooiPomoW3ngoO>hOooiPomo"
            A$ = A$ + "W3ngoO>hOooiPomoW3ngoO>hOooiPomoW3ngoO>hOooiPomoW3ngoO>hOooiPomoW3ngoO>hOooiPomoW3ngoO>hOooiPomoW3ng"
            A$ = A$ + "oO>hOooiPomoW3ngoO>hOooiPomoW3ngoO>hOooiPomoW3ngoO>hOooiPomoW3ngoO>hOooiPomoW3ngoO>hOooiPomoW3ngoO>h"
            A$ = A$ + "OooiPomoW3ngoO>hOooiPomoW3ngoO>hOooiPomoW3ngoO>hOooiPomoW3ngoO>hOooiPomoW3ngoO>hOooiPomoW3ngoO>hOooi"
            A$ = A$ + "Oomo]GNio3\^jn_Pomgo6>hPoKhP3n_R7Nho:QdAooA7Ll?;YPbo]XB:o_2:Wlo:XLbo[Pb9o_2:Wlo:XLbo[Pb9o_2:Wlo:XLbo"
            A$ = A$ + "[Pb9o_2:Wlo:XLbo[Pb9o_2:Wlo:XLbo[Pb9o_2:Wlo:XLbo[Pb9o_2:Wlo:XLbo[Pb9o_2:Wlo:XLbo[Pb9o_2:Wlo:XLbnN\a6"
            A$ = A$ + "aSQ5FlO6GL1nILa5\00000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000[Pb9h^2:Wlo:XLbo[Pb9o_2:Wlo:XLbo[Pb9o_2:Wlo:XLbo[Pb9o_2:Wlo:"
            A$ = A$ + "XLbo[Pb9o_2:Wlo:XLbo[Pb9o_2:Wlo:XLbo[Pb9o_2:Wlo:XLbo[Pb9o_2:Wlo:XLbo[Pb9ocB:XlO;ZTbo]XB:o?B8Pl?=b4co"
            A$ = A$ + "368PoOHQ4n_Q4>ho1nWOo_:ZXnojT?noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>h"
            A$ = A$ + "oO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>h"
            A$ = A$ + "PooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooi"
            A$ = A$ + "P3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3no"
            A$ = A$ + "W3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>h"
            A$ = A$ + "oO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>h"
            A$ = A$ + "PooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooi"
            A$ = A$ + "P3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3no"
            A$ = A$ + "W3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hocNiUoO`l^ko268PoK8Q3n_Q4>ho:RhQ"
            A$ = A$ + "o[4B7mo7M`ao\T2:ogR:Ylo:XLbo[Pb9o_2:Wlo:XLbo[Pb9o_2:Wlo:XLbo[Pb9o_2:Wlo:XLbo[Pb9o_2:Wlo:XLbo[Pb9o_2:"
            A$ = A$ + "Wlo:XLbo[Pb9o_2:Wlo:XLbo[Pb9o_2:Wlo:XLbo[Pb9o_2:Wlo:XLbo[Pb9kka6K4?6FHaoILa5hWa5G`200000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000\2:WPk:XLbo[Pb9o_2:Wlo:XLbo[Pb9o_2:Wlo:XLbo[Pb9o_2:Wlo:XLbo[Pb9o_2:Wlo:XLbo[Pb9o_2:Wlo:XLbo[Pb9"
            A$ = A$ + "o_2:Wlo:XLbo[Pb9o_2:Wlo:XLbo[Pb9o_2:Wl?;YPbo]XB:ogR:Ylo8Q0bod8C<o?HP0noQ5Bho6BhPo7hOnmoZXNjo[CnhoO>h"
            A$ = A$ + "PooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooi"
            A$ = A$ + "P3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3no"
            A$ = A$ + "W3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>h"
            A$ = A$ + "oO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>h"
            A$ = A$ + "PooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooi"
            A$ = A$ + "P3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3no"
            A$ = A$ + "W3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>h"
            A$ = A$ + "oO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>h"
            A$ = A$ + "PooiP3noW3>hoO>hPooiP3noW3>hoO>hPo?kUGno1ck^o;HP0n_Q4>ho6BhPo[8R7n_B8MdoOd17ocB:XlO;ZTbo[Pb9o_2:Wlo:"
            A$ = A$ + "XLbo[Pb9o_2:Wlo:XLbo[Pb9o_2:Wlo:XLbo[Pb9o_2:Wlo:XLbo[Pb9o_2:Wlo:XLbo[Pb9o_2:Wlo:XLbo[Pb9o_2:Wlo:XLbo"
            A$ = A$ + "[Pb9o_2:Wlo:XLbo[Pb9o_2:W\_7K\AlHHQ5oWa5GPO6GL1;0000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000P:WL2^ZLb9o[b9Wl_:WLboZLb9o[b9"
            A$ = A$ + "Wl_:WLboZLb9o[b9Wl_:WLboZLb9o[b9Wl_:WLboZLb9o[b9Wl_:WLboZLb9o[b9Wl_:WLboZLb9o[b9Wl_:WLboZLb9o[b9Wl_:"
            A$ = A$ + "WLbo[P2:ocB:Yl?;YTboR028oCS<al_P02ho6B8QoGhP3noOnigo[NjYocnhSo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3no"
            A$ = A$ + "X3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>h"
            A$ = A$ + "oS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>h"
            A$ = A$ + "Po?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?j"
            A$ = A$ + "P3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3no"
            A$ = A$ + "X3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>h"
            A$ = A$ + "oS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>h"
            A$ = A$ + "Po?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?j"
            A$ = A$ + "P3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3no"
            A$ = A$ + "^GNio7l^knOP02ho5>hPoGhP3nOR7Nho9MdAok17Llo:XPbo\TB:o[b9Wl_:WLboZLb9o[b9Wl_:WLboZLb9o[b9Wl_:WLboZLb9"
            A$ = A$ + "o[b9Wl_:WLboZLb9o[b9Wl_:WLboZLb9o[b9Wl_:WLboZLb9o[b9Wl_:WLboZLb9o[b9Wl_:WLboZLb9o[b9Wl_:WLbnM\a6aSQ5"
            A$ = A$ + "FlO6GL1nILa5\000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000000ZLb9hZb9Wl_:WLboZLb9o[b9Wl_:WLboZLb9o[b9Wl_:WLboZLb9o[b9Wl_:WLbo"
            A$ = A$ + "ZLb9o[b9Wl_:WLboZLb9o[b9Wl_:WLboZLb9o[b9Wl_:WLboZLb9o[b9Wl_:WLboZLb9o_2:Xl?;YTbo\TB:o;28Pl?=b4co228P"
            A$ = A$ + "oK8Q4nOQ3>hooiWOo_jYWn?kS?noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>h"
            A$ = A$ + "Po?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?j"
            A$ = A$ + "P3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3no"
            A$ = A$ + "X3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>h"
            A$ = A$ + "oS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>h"
            A$ = A$ + "Po?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?j"
            A$ = A$ + "P3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3no"
            A$ = A$ + "X3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>h"
            A$ = A$ + "oS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hokNiUoO`k^ko128PoGhP3nOQ3>ho9NhQoWdA"
            A$ = A$ + "7m_7L`ao[P2:ocB:Yl_:WLboZLb9o[b9Wl_:WLboZLb9o[b9Wl_:WLboZLb9o[b9Wl_:WLboZLb9o[b9Wl_:WLboZLb9o[b9Wl_:"
            A$ = A$ + "WLboZLb9o[b9Wl_:WLboZLb9o[b9Wl_:WLboZLb9o[b9Wl_:WLboZLb9kga6K4?6FHaoILa5hWa5G`2000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0Xb9VP[:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9"
            A$ = A$ + "Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vlo:XLbo\T2:ocB:Xl_8Plaod8C<o?8PomoQ4>ho6>XPo3XOmm?[WJjo\?>ioS>hPo?j"
            A$ = A$ + "P3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3no"
            A$ = A$ + "X3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>h"
            A$ = A$ + "oS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>h"
            A$ = A$ + "Po?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?j"
            A$ = A$ + "P3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3no"
            A$ = A$ + "X3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>h"
            A$ = A$ + "oS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>h"
            A$ = A$ + "Po?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?jP3noX3>hoS>hPo?j"
            A$ = A$ + "P3noX3>hoS>hPo?jP3noX3>hoS>hPo_kUGno1_k^o;8Pnm_Q3:ho6>XPo[hQ6n_B7IdoN`a6o_2:Wl?;YPboZLR9o[b9Vl_:WHbo"
            A$ = A$ + "ZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9"
            A$ = A$ + "o[b9Vl_:WHboZLR9o[b9V\O7K\AlHHQ5oWa5GPO6GL1;00000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000000000000000000000000000000000000P:WH2^ZLR9o[b9Vl_:WHboZLR9o[b9Vl_:"
            A$ = A$ + "WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHbo"
            A$ = A$ + "[Pb9ocB:Xl?;YPboR0b7oCS<aloP02ho7B8QoKhP3n?Pnigo\NjYocNiSo?jQ3noX7>hoSNhPo?jQ3noX7>hoSNhPo?jQ3noX7>h"
            A$ = A$ + "oSNhPo?jQ3noX7>hoSNhPo?jQ3noX7>hoSNhPo?jQ3noX7>hoSNhPo?jQ3noX7>hoSNhPo?jQ3noX7>hoSNhPo?jQ3noX7>hoSNh"
            A$ = A$ + "Po?jQ3noX7>hoSNhPo?jQ3noX7>hoSNhPo?jQ3noX7>hoSNhPo?jQ3noX7>hoSNhPo?jQ3noX7>hoSNhPo?jQ3noX7>hoSNhPo?j"
            A$ = A$ + "Q3noX7>hoSNhPo?jQ3noX7>hoSNhPo?jQ3noX7>hoSNhPo?jQ3noX7>hoSNhPo?jQ3noX7>hoSNhPo?jQ3noX7>hoSNhPo?jQ3no"
            A$ = A$ + "X7>hoSNhPo?jQ3noX7>hoSNhPo?jQ3noX7>hoSNhPo?jQ3noX7>hoSNhPo?jQ3noX7>hoSNhPo?jQ3noX7>hoSNhPo?jQ3noX7>h"
            A$ = A$ + "oSNhPo?jQ3noX7>hoSNhPo?jQ3noX7>hoSNhPo?jQ3noX7>hoSNhPo?jQ3noX7>hoSNhPo?jQ3noX7>hoSNhPo?jQ3noX7>hoSNh"
            A$ = A$ + "Po?jQ3noX7>hoSNhPo?jQ3noX7>hoSNhPo?jQ3noX7>hoSNhPo?jQ3noX7>hoSNhPo?jQ3noX7>hoSNhPo?jQ3noX7>hoSNhPo?j"
            A$ = A$ + "Q3noX7>hoSNhPo?jQ3noX7>hoSNhPo?jQ3noX7>hoSNhPo?jQ3noX7>hoSNhPo?jQ3noX7>hoSNhPo?jQ3noX7>hoSNhPo?jQ3no"
            A$ = A$ + "X7>hoSNhPo?jQ3noX7>hoSNhPo?jQ3noX7>hoSNhPo?jQ3noX7>hoSNhPo?jQ3noX7>hoSNhPo?jQ3noX7>hoSNhPo?jQ3no^KNi"
            A$ = A$ + "o7<_kn_Po1ho6>hPoKhP3n_R7Nho:MdAok17Klo:XLbo\T2:o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9"
            A$ = A$ + "Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHbnM\a6aSQ5FlO6"
            A$ = A$ + "GL1nILa5\0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000ZLR9hZb9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9"
            A$ = A$ + "o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o_2:Wl?;YPbo\T2:o;28Ol?=b4co368PoOHQ"
            A$ = A$ + "4n_Q4>ho0nWOoc:ZWn?kTGnoX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?j"
            A$ = A$ + "Q7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7no"
            A$ = A$ + "X7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7Nh"
            A$ = A$ + "oSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNh"
            A$ = A$ + "Qo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?j"
            A$ = A$ + "Q7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7no"
            A$ = A$ + "X7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7Nh"
            A$ = A$ + "oSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNh"
            A$ = A$ + "Qo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7Nhok^iVoO`lbko26hOoK8Q3n_Q4>ho:RhQo[4B7m_7"
            A$ = A$ + "L\ao[Pb9ocB:Xl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHbo"
            A$ = A$ + "ZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9kga6K4?6FHaoILa5hWa5G`20000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000Xb9"
            A$ = A$ + "VP[:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:"
            A$ = A$ + "WHboZLR9o[b9Vl_:WHboZLR9o[b9Vlo:XLbo\T2:ocB:Xl_8Plaod8C<o?HP0noQ5Bho6BhPo3hOnm?[XNjo\CNioSNhQo?jQ7no"
            A$ = A$ + "X7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7Nh"
            A$ = A$ + "oSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNh"
            A$ = A$ + "Qo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?j"
            A$ = A$ + "Q7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7no"
            A$ = A$ + "X7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7Nh"
            A$ = A$ + "oSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNh"
            A$ = A$ + "Qo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?j"
            A$ = A$ + "Q7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7noX7NhoSNhQo?jQ7no"
            A$ = A$ + "X7NhoSNhQo?jQ7noX7NhoSNhQo_kVKno1c;_o;HPom_Q4>ho6BhPo[8R7n_B8MdoN`a6o_2:Wl?;YPboZLR9o[b9Vl_:WHboZLR9"
            A$ = A$ + "o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9Vl_:WHboZLR9o[b9"
            A$ = A$ + "Vl_:WHboZLR9o[b9V\O7K\AlHHQ5oWa5GPO6GL1;000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000000000000000000000000000@:VH2^YHR9oWR9VlO:VHboYHR9oWR9VlO:VHbo"
            A$ = A$ + "YHR9oWR9VlO:VHboYHR9oWR9VlO:VHboYHR9oWR9VlO:VHboYHR9oWR9VlO:VHboYHR9oWR9VlO:VHboYHR9oWR9VlO:VHboZLb9"
            A$ = A$ + "o_2:Xlo:XPboRla7oCC<aloP12ho7F8QoK8Q3n?Poigo\RjYoc>iUo?jQ7noX7NhoSNhQo?jQ7noX7Nho[nhSo?kUGno\GNiocNi"
            A$ = A$ + "Uo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?k"
            A$ = A$ + "UGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno"
            A$ = A$ + "\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNi"
            A$ = A$ + "ocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNi"
            A$ = A$ + "Uo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?k"
            A$ = A$ + "UGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno"
            A$ = A$ + "\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNi"
            A$ = A$ + "ocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNio[nhSo?jQ7noX7NhoSNhQo?jQ7no^K^io7<_"
            A$ = A$ + "ln_P1ngo6BhPoK8Q3n_R8Nho:MdAoka6Kl_:WLbo[P2:oWR9VlO:VHboYHR9oWR9VlO:VHboYHR9oWR9VlO:VHboYHR9oWR9VlO:"
            A$ = A$ + "VHboYHR9oWR9VlO:VHboYHR9oWR9VlO:VHboYHR9oWR9VlO:VHboYHR9oWR9VlO:VHboYHR9oWR9VlO:VHbnM\a6aSQ5FlO6GL1n"
            A$ = A$ + "ILa5\00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000YHR9hVR9VlO:VHboYHR9oWR9VlO:VHboYHR9oWR9VlO:VHboYHR9oWR9VlO:VHboYHR9oWR9"
            A$ = A$ + "VlO:VHboYHR9oWR9VlO:VHboYHR9oWR9VlO:VHboYHR9oWR9VlO:VHboYHR9o[b9Wlo:XPbo[P2:o;b7Ol?=a4co468PoSHQ4noQ"
            A$ = A$ + "4>ho2nWOoc:ZWn?kTGnoX7NhoSNhQo?jQ7noX7Nho[nhSoofDCmo;C<aogla7oOc7Olo=Olaogla7oOc7Olo=Olaogla7oOc7Olo"
            A$ = A$ + "=Olaogla7oOc7Olo=Olaogla7oOc7Olo=Olaogla7oOc7Olo=Olaogla7oOc7Olo=Olaogla7oOc7Olo=Olaogla7oOc7Olo=Ola"
            A$ = A$ + "ogla7oOc7Olo=Olaogla7oOc7Olo=Olaogla7oOc7Olo=Olaogla7oOc7Olo=Olaogla7oOc7Olo=Olaogla7oOc7Olo=Olaogla"
            A$ = A$ + "7oOc7Olo=Olaogla7oOc7Olo=Olaogla7oOc7Olo=Olaogla7oOc7Olo=Olaogla7oOc7Olo=Olaogla7oOc7Olo=Olaogla7oOc"
            A$ = A$ + "7Olo=Olaogla7oOc7Olo=Olaogla7oOc7Olo=Olaogla7oOc7Olo=Olaogla7oOc7Olo=Olaogla7oOc7Olo=Olaogla7oOc7Olo"
            A$ = A$ + "=Olaogla7oOc7Olo=Olaogla7oOc7Olo=Olaogla7oOc7Olo=Olaogla7oOc7Olo=Olaogla7oOc7Olo=Olaogla7oOc7Olo=Ola"
            A$ = A$ + "ogla7oOc7Olo=Olaogla7oOc7Olo=Olaogla7oOc7Olo=Olaogla7oOc7Olo=Olaogla7oOc7Olo=Olaogla7oOc7Olo=Olaogla"
            A$ = A$ + "7oOc7Olo=Olaogla7oOc7Olo=Olaogla7oOc7Olo=Olaogla7oOc7Olo=Olaogla7oOc7Olo=Olaogla7oOc7Olo=Olaogla7oOc"
            A$ = A$ + "7Olo=Olaogla7oOc7Olo=Olao_<a4ooeA7moY;^hoSNhQo?jQ7noX7Nhog^iVo_`lbko36hOoO8Q3noQ4>ho;RhQo[dA7m_7K\ao"
            A$ = A$ + "ZLb9o_2:XlO:VHboYHR9oWR9VlO:VHboYHR9oWR9VlO:VHboYHR9oWR9VlO:VHboYHR9oWR9VlO:VHboYHR9oWR9VlO:VHboYHR9"
            A$ = A$ + "oWR9VlO:VHboYHR9oWR9VlO:VHboYHR9oWR9VlO:VHboYHR9kga6K4?6FHaoILa5hWa5G`200000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000TR9UPK:"
            A$ = A$ + "VDboYHB9oWR9UlO:VDboYHB9oWR9UlO:VDboYHB9oWR9UlO:VDboYHB9oWR9UlO:VDboYHB9oWR9UlO:VDboYHB9oWR9UlO:VDbo"
            A$ = A$ + "YHB9oWR9UlO:VDboYHB9oWR9Ul_:WHbo[Pb9o_2:Wl_8Ohaod43<oCHP1n?R5Fho7B8Qo7hOomO[XRjo]C>ioWNhQoOjQ7noY7Nh"
            A$ = A$ + "oWNhQo_kVKno4gK_oWiTCn_WIRioNV9VokIVHn_WIRioNV9VokIVHn_WIRioNV9VokIVHn_WIRioNV9VokIVHn_WIRioNV9VokIV"
            A$ = A$ + "Hn_WIRioNV9VokIVHn_WIRioNV9VokIVHn_WIRioNV9VokIVHn_WIRioNV9VokIVHn_WIRioNV9VokIVHn_WIRioNV9VokIVHn_W"
            A$ = A$ + "IRioNV9VokIVHn_WIRioNV9VokIVHn_WIRioNV9VokIVHn_WIRioNV9VokIVHn_WIRioNV9VokIVHn_WIRioNV9VokIVHn_WIRio"
            A$ = A$ + "NV9VokIVHn_WIRioNV9VokIVHn_WIRioNV9VokIVHn_WIRioNV9VokIVHn_WIRioNV9VokIVHn_WIRioNV9VokIVHn_WIRioNV9V"
            A$ = A$ + "okIVHn_WIRioNV9VokIVHn_WIRioNV9VokIVHn_WIRioNV9VokIVHn_WIRioNV9VokIVHn_WIRioNV9VokIVHn_WIRioNV9VokIV"
            A$ = A$ + "Hn_WIRioNV9VokIVHn_WIRioNV9VokIVHn_WIRioNV9VokIVHn_WIRioNV9VokIVHn_WIRioNV9VokIVHn_WIRioNV9VokIVHn_W"
            A$ = A$ + "IRioNV9VokIVHn_WIRioNV9VokIVHn_WIRioNV9VokIVHn_WIRioNV9VokIVHn_WIRioNV9VokIVHn_WIRioNV9VokIVHn_WIRio"
            A$ = A$ + "NV9VokIVHn_WIRioNV9VokIVHn_WIRioNV9VokIVHn_WIRioNV9VokIVHn_WIRioNV9VokIVHn_WIRioNV9VokIVHn_VDBiokB;]"
            A$ = A$ + "ocnhSoOjQ7noY7NhoWNhQookVKno2c;_o?HP1noQ4Bho7B8Qo_8R8n_B7IdoN\Q6o[b9Vlo:XLboYHB9oWR9UlO:VDboYHB9oWR9"
            A$ = A$ + "UlO:VDboYHB9oWR9UlO:VDboYHB9oWR9UlO:VDboYHB9oWR9UlO:VDboYHB9oWR9UlO:VDboYHB9oWR9UlO:VDboYHB9oWR9UlO:"
            A$ = A$ + "VDboYHB9oWR9U\O7KXAlHHQ5oWa5GPO6GL1;0000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000@:VD2^YHB9oWR9UlO:VDboYHB9oWR9UlO:VDboYHB9"
            A$ = A$ + "oWR9UlO:VDboYHB9oWR9UlO:VDboYHB9oWR9UlO:VDboYHB9oWR9UlO:VDboYHB9oWR9UlO:VDboYHB9oWR9UlO:VDboZLR9o_2:"
            A$ = A$ + "Wlo:XLboRlQ7oCC<`l?Q26ho8JHQoOHQ4nOP0ngo]V:ZogNiToOjR7noY;NhoW^hQoOjR7no]KNiocLa4o_ZUBjo^V:ZokJZXn_["
            A$ = A$ + "YRjo^V:ZokJZXn_[YRjo^V:ZokJZXn_[YRjo^V:ZokJZXn_[YRjo^V:ZokJZXn_[YRjo^V:ZokJZXn_[YRjo^V:ZokJZXn_[YRjo"
            A$ = A$ + "^V:ZokJZXn_[YRjo^V:ZokJZXn_[YRjo^V:ZokJZXn_[YRjo^V:ZokJZXn_[YRjo^V:ZokJZXn_[YRjo^V:ZokJZXn_[YRjo^V:Z"
            A$ = A$ + "okJZXn_[YRjo^V:ZokJZXn_[YRjo^V:ZokJZXn_[YRjo^V:ZokJZXn_[YRjo^V:ZokJZXn_[YRjo^V:ZokJZXn_[YRjo^V:ZokJZ"
            A$ = A$ + "Xn_[YRjo^V:ZokJZXn_[YRjo^V:ZokJZXn_[YRjo^V:ZokJZXn_[YRjo^V:ZokJZXn_[YRjo^V:ZokJZXn_[YRjo^V:ZokJZXn_["
            A$ = A$ + "YRjo^V:ZokJZXn_[YRjo^V:ZokJZXn_[YRjo^V:ZokJZXn_[YRjo^V:ZokJZXn_[YRjo^V:ZokJZXn_[YRjo^V:ZokJZXn_[YRjo"
            A$ = A$ + "^V:ZokJZXn_[YRjo^V:ZokJZXn_[YRjo^V:ZokJZXn_[YRjo^V:ZokJZXn_[YRjo^V:ZokJZXn_[YRjo^V:ZokJZXn_[YRjo^V:Z"
            A$ = A$ + "okJZXn_[YRjo^V:ZokJZXn_[YRjo^V:ZokJZXn_[YRjo^V:ZokJZXn_[YRjo^V:ZokJZXn_[YRjo^V:ZokJZXn_[YRjo^V:ZokJZ"
            A$ = A$ + "Xn_[YRjo^V:ZokJZXn_[YRjo^V:ZokJZXn_[YRjo^V:ZokJZXn_[YRjo[JJYoGl_nnojT?noY;NhoW^hQoOjR7no_O^io;L_lnoP"
            A$ = A$ + "16ho7F8QoOHQ4noR9Rho:MTAoka6Jl_:WHbo[Pb9oWR9UlO:VDboYHB9oWR9UlO:VDboYHB9oWR9UlO:VDboYHB9oWR9UlO:VDbo"
            A$ = A$ + "YHB9oWR9UlO:VDboYHB9oWR9UlO:VDboYHB9oWR9UlO:VDboYHB9oWR9UlO:VDboYHB9oWR9UlO:VDbnM\Q6aSQ5FlO6GL1nILa5"
            A$ = A$ + "\000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000YHB9hVR9UlO:VDboYHB9oWR9UlO:VDboYHB9oWR9UlO:VDboYHB9oWR9UlO:VDboYHB9oWR9UlO:"
            A$ = A$ + "VDboYHB9oWR9UlO:VDboYHB9oWR9UlO:VDboYHB9oWR9UlO:VDboYHB9o[b9Vlo:XLbo[Pb9o;b7Nl?=a0co4:HPoSXQ5noQ5Bho"
            A$ = A$ + "12hOogJZXnOkUGnoY;^hoW^hRoOjR;noY;^hoW^hRo?jQ7noW3ngoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>h"
            A$ = A$ + "oO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>h"
            A$ = A$ + "PooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooi"
            A$ = A$ + "P3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3no"
            A$ = A$ + "W3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>h"
            A$ = A$ + "oO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>h"
            A$ = A$ + "PooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooi"
            A$ = A$ + "P3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3noW3>hoO>hPooiP3no"
            A$ = A$ + "W3>hoO>hPooiP3noW3>hoO>hPo?jQ3noY;^hoW^hRoOjR;noY;^hooniWo_`mfko3:HPoOHQ4noQ5Bho;V8Ro[dA6m_7KXaoZLR9"
            A$ = A$ + "o_2:WlO:VDboYHB9oWR9UlO:VDboYHB9oWR9UlO:VDboYHB9oWR9UlO:VDboYHB9oWR9UlO:VDboYHB9oWR9UlO:VDboYHB9oWR9"
            A$ = A$ + "UlO:VDboYHB9oWR9UlO:VDboYHB9oWR9UlO:VDboYHB9kga6J4?6FHaoILa5hWa5G`2000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000TR9UPK:VDbo"
            A$ = A$ + "YHB9oWR9UlO:VDboYHB9oWR9UlO:VDboYHB9oWR9UlO:VDboYHB9oWR9UlO:VDboYHB9oWR9UlO:VDboYHB9oWR9UlO:VDboYHB9"
            A$ = A$ + "oWR9UlO:VDboYHB9oWR9Ul_:WHbo[Pb9o_2:Wl_8Ohaod43<oCXP1n?R6Fho7F8Qo78PomO[YRjo]G^ioW^hRoOjR;noY;^hoW^h"
            A$ = A$ + "RoOjR;noY;nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_j"
            A$ = A$ + "S?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?no"
            A$ = A$ + "Z?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nh"
            A$ = A$ + "o[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nh"
            A$ = A$ + "So_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_j"
            A$ = A$ + "S?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?no"
            A$ = A$ + "Z?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nh"
            A$ = A$ + "o[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nhoW^h"
            A$ = A$ + "RoOjR;noY;^hoW^hRookWOno2gK_o?XP0noQ5Bho7F8Qo_HR8nOB7IdoN\Q6o[b9Vlo:XLboYHB9oWR9UlO:VDboYHB9oWR9UlO:"
            A$ = A$ + "VDboYHB9oWR9UlO:VDboYHB9oWR9UlO:VDboYHB9oWR9UlO:VDboYHB9oWR9UlO:VDboYHB9oWR9UlO:VDboYHB9oWR9UlO:VDbo"
            A$ = A$ + "YHB9oWR9U\O7KXAlHHQ5oWa5GPO6GL1;00000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000:UD2^XDB9oSB9Ul?:UDboXDB9oSB9Ul?:UDboXDB9oSB9"
            A$ = A$ + "Ul?:UDboXDB9oSB9Ul?:UDboXDB9oSB9Ul?:UDboXDB9oSB9Ul?:UDboXDB9oSB9Ul?:UDboXDB9oSB9Ul?:UDboYHR9o[b9Wl_:"
            A$ = A$ + "WLboQhQ7o?3<`lOQ26ho9JHQoSHQ4n_P0ngo]V:ZogNiVoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;no"
            A$ = A$ + "Y;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^h"
            A$ = A$ + "oW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^h"
            A$ = A$ + "RoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOj"
            A$ = A$ + "R;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;no"
            A$ = A$ + "Y;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^h"
            A$ = A$ + "oW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^h"
            A$ = A$ + "RoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOj"
            A$ = A$ + "R;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;no_Onio?L_mn?Q22ho"
            A$ = A$ + "8F8QoSHQ4n?S9Rho9MTAogQ6JlO:VHboZLb9oSB9Ul?:UDboXDB9oSB9Ul?:UDboXDB9oSB9Ul?:UDboXDB9oSB9Ul?:UDboXDB9"
            A$ = A$ + "oSB9Ul?:UDboXDB9oSB9Ul?:UDboXDB9oSB9Ul?:UDboXDB9oSB9Ul?:UDboXDB9oSB9Ul?:UDbnMXQ6aSQ5FlO6GL1nILa5\000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000XDB9hRB9Ul?:UDboXDB9oSB9Ul?:UDboXDB9oSB9Ul?:UDboXDB9oSB9Ul?:UDboXDB9oSB9Ul?:UDbo"
            A$ = A$ + "XDB9oSB9Ul?:UDboXDB9oSB9Ul?:UDboXDB9oSB9Ul?:UDboXDB9oWR9Vl_:WLboZLb9o7R7Nlo<`0co5:HPoWXQ5n?R5Bho32hO"
            A$ = A$ + "ogJZXnOkUKnoY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^h"
            A$ = A$ + "RoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOj"
            A$ = A$ + "R;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;no"
            A$ = A$ + "Y;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^h"
            A$ = A$ + "oW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^h"
            A$ = A$ + "RoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOj"
            A$ = A$ + "R;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;no"
            A$ = A$ + "Y;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^h"
            A$ = A$ + "oW^hRoOjR;noY;^hoW^hRoOjR;noY;^hoW^hRoOjR;noY;^hokniWoo`mfko4:8PoSHQ4n?R5Bho<V8Ro[dA6mO7JXaoYHR9o[b9"
            A$ = A$ + "Wl?:UDboXDB9oSB9Ul?:UDboXDB9oSB9Ul?:UDboXDB9oSB9Ul?:UDboXDB9oSB9Ul?:UDboXDB9oSB9Ul?:UDboXDB9oSB9Ul?:"
            A$ = A$ + "UDboXDB9oSB9Ul?:UDboXDB9oSB9Ul?:UDboXDB9kgQ6J4?6FHaoILa5hWa5G`20000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000PB9TP;:U@boXD29"
            A$ = A$ + "oSB9Tl?:U@boXD29oSB9Tl?:U@boXD29oSB9Tl?:U@boXD29oSB9Tl?:U@boXD29oSB9Tl?:U@boXD29oSB9Tl?:U@boXD29oSB9"
            A$ = A$ + "Tl?:U@boXD29oSB9TlO:VDboZLR9o[b9WlO8Ndaoc0c;oGXP1nOR6Fho8F8Qo?8PomO[YRjo]K^ioWnhRoOjS;noY?^hoWnhRoOj"
            A$ = A$ + "S;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;no"
            A$ = A$ + "Y?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^h"
            A$ = A$ + "oWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnh"
            A$ = A$ + "RoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOj"
            A$ = A$ + "S;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;no"
            A$ = A$ + "Y?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^h"
            A$ = A$ + "oWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnh"
            A$ = A$ + "RoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOj"
            A$ = A$ + "S;noY?^hoWnhRo_kXOno3kK_oCXP0n?R5Bho8F8QocHR8n_B7IdoMXA6oWR9Vl_:WHboXD29oSB9Tl?:U@boXD29oSB9Tl?:U@bo"
            A$ = A$ + "XD29oSB9Tl?:U@boXD29oSB9Tl?:U@boXD29oSB9Tl?:U@boXD29oSB9Tl?:U@boXD29oSB9Tl?:U@boXD29oSB9Tl?:U@boXD29"
            A$ = A$ + "oSB9T\O7JXAlHHQ5oWa5GPO6GL1;000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000000000000000000000:U@2^XD29oSB9Tl?:U@boXD29oSB9Tl?:U@boXD29oSB9Tl?:"
            A$ = A$ + "U@boXD29oSB9Tl?:U@boXD29oSB9Tl?:U@boXD29oSB9Tl?:U@boXD29oSB9Tl?:U@boXD29oSB9Tl?:U@boYHB9o[b9Vl_:WLbo"
            A$ = A$ + "QhA7o?3<_lOQ26ho9JHQoSHQ4noP0ngo]V:ZogniVoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^h"
            A$ = A$ + "oWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnh"
            A$ = A$ + "RoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOj"
            A$ = A$ + "S;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;no"
            A$ = A$ + "Y?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^h"
            A$ = A$ + "oWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnh"
            A$ = A$ + "RoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOj"
            A$ = A$ + "S;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;no"
            A$ = A$ + "Y?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;noY?^hoWnhRoOjS;no^Snio?\_mn?Q12ho8F8Q"
            A$ = A$ + "oSHQ4n?S9Rho:MTAogQ6IlO:VHboZLR9oSB9Tl?:U@boXD29oSB9Tl?:U@boXD29oSB9Tl?:U@boXD29oSB9Tl?:U@boXD29oSB9"
            A$ = A$ + "Tl?:U@boXD29oSB9Tl?:U@boXD29oSB9Tl?:U@boXD29oSB9Tl?:U@boXD29oSB9Tl?:U@bnMXQ6aSQ5FlO6GL1nILa5\0000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000XD29hRB9Tl?:U@boXD29oSB9Tl?:U@boXD29oSB9Tl?:U@boXD29oSB9Tl?:U@boXD29oSB9Tl?:U@boXD29"
            A$ = A$ + "oSB9Tl?:U@boXD29oSB9Tl?:U@boXD29oSB9Tl?:U@boXD29oWR9Ul_:WHboZLb9o7R7Mlo<`lbo5:HPoWXQ5n?R5Bho22hOokJZ"
            A$ = A$ + "Yn_kWOnoZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_j"
            A$ = A$ + "S?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?no"
            A$ = A$ + "Z?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nh"
            A$ = A$ + "o[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nh"
            A$ = A$ + "So_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_j"
            A$ = A$ + "S?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?no"
            A$ = A$ + "Z?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nh"
            A$ = A$ + "o[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nh"
            A$ = A$ + "So_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho3?jXoo`njko46HPoSHQ4n?R5Bho<V8Ro[dA6mO7JTaoYHR9o[b9Vl?:"
            A$ = A$ + "U@boXD29oSB9Tl?:U@boXD29oSB9Tl?:U@boXD29oSB9Tl?:U@boXD29oSB9Tl?:U@boXD29oSB9Tl?:U@boXD29oSB9Tl?:U@bo"
            A$ = A$ + "XD29oSB9Tl?:U@boXD29oSB9Tl?:U@boXD29kgQ6J4?6FHaoILa5hWa5G`200000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000000000000000000000000000000000000000000000000000PB9TP;:U@boXD29oSB9"
            A$ = A$ + "Tl?:U@boXD29oSB9Tl?:U@boXD29oSB9Tl?:U@boXD29oSB9Tl?:U@boXD29oSB9Tl?:U@boXD29oSB9Tl?:U@boXD29oSB9Tl?:"
            A$ = A$ + "U@boXD29oSB9TlO:VDboZLR9o[b9WlO8Ndaoc0c;oGXP1nOR6Fho8F8Qo;8Pom_[YVjo^Onio[nhSo_jS?noZ?nho[nhSo_jS?no"
            A$ = A$ + "Z?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nh"
            A$ = A$ + "o[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nh"
            A$ = A$ + "So_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_j"
            A$ = A$ + "S?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?no"
            A$ = A$ + "Z?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nh"
            A$ = A$ + "o[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nh"
            A$ = A$ + "So_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_j"
            A$ = A$ + "S?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?no"
            A$ = A$ + "Z?nho[nhSo?lXSno3k[_oCHP1n?R5Bho8F8QocHR8n_B7IdoLXA6oWR9Vl_:WHboXD29oSB9Tl?:U@boXD29oSB9Tl?:U@boXD29"
            A$ = A$ + "oSB9Tl?:U@boXD29oSB9Tl?:U@boXD29oSB9Tl?:U@boXD29oSB9Tl?:U@boXD29oSB9Tl?:U@boXD29oSB9Tl?:U@boXD29oSB9"
            A$ = A$ + "T\O7JXAlHHQ5oWa5GPO6GL1;0000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000`9T@2^W@29oO29Tlo9T@boW@29oO29Tlo9T@boW@29oO29Tlo9T@bo"
            A$ = A$ + "W@29oO29Tlo9T@boW@29oO29Tlo9T@boW@29oO29Tlo9T@boW@29oO29Tlo9T@boW@29oO29Tlo9T@boXDB9oWR9VlO:WLboPdA7"
            A$ = A$ + "o;c;_lOQ26ho9JHQoSHQ4n_P0ngo^VJZokniWo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nh"
            A$ = A$ + "So_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_j"
            A$ = A$ + "S?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?no"
            A$ = A$ + "Z?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nh"
            A$ = A$ + "o[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nh"
            A$ = A$ + "So_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_j"
            A$ = A$ + "S?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?no"
            A$ = A$ + "Z?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nh"
            A$ = A$ + "o[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?no`S>jo?\_nn?Q16ho8F8QoSHQ"
            A$ = A$ + "4n?S9Rho9ITAo_A6Il?:VHboYHR9oO29Tlo9T@boW@29oO29Tlo9T@boW@29oO29Tlo9T@boW@29oO29Tlo9T@boW@29oO29Tlo9"
            A$ = A$ + "T@boW@29oO29Tlo9T@boW@29oO29Tlo9T@boW@29oO29Tlo9T@boW@29oO29Tlo9T@bnLXQ6aSQ5FlO6GL1nILa5\00000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000W@29hN29Tlo9T@boW@29oO29Tlo9T@boW@29oO29Tlo9T@boW@29oO29Tlo9T@boW@29oO29Tlo9T@boW@29oO29"
            A$ = A$ + "Tlo9T@boW@29oO29Tlo9T@boW@29oO29Tlo9T@boW@29oSB9UlO:VHboYLb9o3B7Ml_<_lbo5:XPoWXQ6n?R5Fho228PokJZYn_k"
            A$ = A$ + "WOnoZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?no"
            A$ = A$ + "Z?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nh"
            A$ = A$ + "o[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nh"
            A$ = A$ + "So_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_j"
            A$ = A$ + "S?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?no"
            A$ = A$ + "Z?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nh"
            A$ = A$ + "o[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nh"
            A$ = A$ + "So_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho[nhSo_j"
            A$ = A$ + "S?noZ?nho[nhSo_jS?noZ?nho[nhSo_jS?noZ?nho3?jXoo`njko46HPoSHQ5n?R5Fho<VHRoWTA6mo6ITaoXHR9oWR9Vlo9T@bo"
            A$ = A$ + "W@29oO29Tlo9T@boW@29oO29Tlo9T@boW@29oO29Tlo9T@boW@29oO29Tlo9T@boW@29oO29Tlo9T@boW@29oO29Tlo9T@boW@29"
            A$ = A$ + "oO29Tlo9T@boW@29oO29Tlo9T@boW@29kcQ6J4?6FHaoILa5hWa5G`2000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000000000000000000000000000000000000000000L29SPk9T<boW@b8oO29Slo9"
            A$ = A$ + "T<boW@b8oO29Slo9T<boW@b8oO29Slo9T<boW@b8oO29Slo9T<boW@b8oO29Slo9T<boW@b8oO29Slo9T<boW@b8oO29Slo9T<bo"
            A$ = A$ + "W@b8oO29Sl?:U@boYHB9oWb9Vl?8M`aoblR;oGhP2nOR7Jho8JHQo;HP0n_[ZVjo^Snio[>iSo_jT?noZCnho[>iSo_jT?noZCnh"
            A$ = A$ + "o[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>i"
            A$ = A$ + "So_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_j"
            A$ = A$ + "T?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?no"
            A$ = A$ + "ZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnh"
            A$ = A$ + "o[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>i"
            A$ = A$ + "So_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_j"
            A$ = A$ + "T?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?no"
            A$ = A$ + "ZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnh"
            A$ = A$ + "o[>iSo?lYSno3o[_oCXP1n?R6Fho8JHQocXR9nOB7IdoKTa5oSR9UlO:VDboW@b8oO29Slo9T<boW@b8oO29Slo9T<boW@b8oO29"
            A$ = A$ + "Slo9T<boW@b8oO29Slo9T<boW@b8oO29Slo9T<boW@b8oO29Slo9T<boW@b8oO29Slo9T<boW@b8oO29Slo9T<boW@b8oO29S\?7"
            A$ = A$ + "JXAlHHa5oWa5GPO6GL1;00000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000000000000`9T<2^W@b8oO29Slo9T<boW@b8oO29Slo9T<boW@b8oO29Slo9T<boW@b8"
            A$ = A$ + "oO29Slo9T<boW@b8oO29Slo9T<boW@b8oO29Slo9T<boW@b8oO29Slo9T<boW@b8oO29Slo9T<boXD29oWR9UlO:WHboPd17o;c;"
            A$ = A$ + "^lOQ3:ho9NXQoSXQ5n_P12ho^ZJZok>jWo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_j"
            A$ = A$ + "T?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?no"
            A$ = A$ + "ZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnh"
            A$ = A$ + "o[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>i"
            A$ = A$ + "So_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_j"
            A$ = A$ + "T?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?no"
            A$ = A$ + "ZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnh"
            A$ = A$ + "o[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>i"
            A$ = A$ + "So_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?noZCnho[>iSo_jT?no`W>jo?l_nn?Q26ho8JHQoSXQ5n?S"
            A$ = A$ + ":Vho9MTAo_16Gl?:VDboYHB9oO29Slo9T<boW@b8oO29Slo9T<boW@b8oO29Slo9T<boW@b8oO29Slo9T<boW@b8oO29Slo9T<bo"
            A$ = A$ + "W@b8oO29Slo9T<boW@b8oO29Slo9T<boW@b8oO29Slo9T<boW@b8oO29Slo9T<bnLXQ6aSQ5GlO6GL1nILa5\000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000W@b8hN29Slo9T<boW@b8oO29Slo9T<boW@b8oO29Slo9T<boW@b8oO29Slo9T<boW@b8oO29Slo9T<boW@b8oO29Slo9"
            A$ = A$ + "T<boW@b8oO29Slo9T<boW@b8oO29Slo9T<boW@b8oSB9TlO:VDboYLR9o3B7Ll_<_hbo6>XPo[hQ6nOR6Fho368PokZZZn_kXSno"
            A$ = A$ + "ZC>io[>iTo_jTCnoZC>io[>iTo_jTCnoZC>io[>iTo_jTCnoZC>io[>iTo_jTCnoZC>io[>iTo_jTCnoZC>io[>iTo_jTCnoZC>i"
            A$ = A$ + "o[>iTo_jTCnoZC>io[>iTo_jTCnoZC>io[>iTo_jTCnoZC>io[>iTo_jTCnoZC>io[>iTo_jTCnoZC>io[>iTo_jTCnoZC>io[>i"
            A$ = A$ + "To_jTCnoZC>io[>iTo_jTCnoZC>io[>iTo_jTCnoZC>io[>iTo_jTCnoZC>io[>iTo_jTCnoZC>io[>iTo_jTCnoZC>io[>iTo_j"
            A$ = A$ + "TCnoZC>io[>iTo_jTCnoZC>io[>iTo_jTCnoZC>io[>iTo_jTCnoZC>io[>iTo_jTCnoZC>io[>iTo_jTCnoZC>io[>iTo_jTCno"
            A$ = A$ + "ZC>io[>iTo_jTCnoZC>io[>iTo_jTCnoZC>io[>iTo_jTCnoZC>io[>iTo_jTCnoZC>io[>iTo_jTCnoZC>io[>iTo_jTCnoZC>i"
            A$ = A$ + "o[>iTo_jTCnoZC>io[>iTo_jTCnoZC>io[>iTo_jTCnoZC>io[>iTo_jTCnoZC>io[>iTo_jTCnoZC>io[>iTo_jTCnoZC>io[>i"
            A$ = A$ + "To_jTCnoZC>io[>iTo_jTCnoZC>io[>iTo_jTCnoZC>io[>iTo_jTCnoZC>io[>iTo_jTCnoZC>io[>iTo_jTCnoZC>io[>iTo_j"
            A$ = A$ + "TCnoZC>io[>iTo_jTCnoZC>io[>iTo_jTCnoZC>io[>iTo_jTCnoZC>io[>iTo_jTCnoZC>io[>iTo_jTCnoZC>io[>iTo_jTCno"
            A$ = A$ + "ZC>io[>iTo_jTCnoZC>io[>iTo_jTCnoZC>iooNjYo?aonko5:XPoWXQ5nOR6Fho=ZHRoWdA6mo6HLaoXHB9oWR9Ulo9T<boW@b8"
            A$ = A$ + "oO29Slo9T<boW@b8oO29Slo9T<boW@b8oO29Slo9T<boW@b8oO29Slo9T<boW@b8oO29Slo9T<boW@b8oO29Slo9T<boW@b8oO29"
            A$ = A$ + "Slo9T<boW@b8oO29Slo9T<boW@b8kcQ6J4?6FLaoILa5hWa5G`20000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000Hb8SP[9S<boV<b8oKb8Sl_9S<bo"
            A$ = A$ + "V<b8oKb8Sl_9S<boV<b8oKb8Sl_9S<boV<b8oKb8Sl_9S<boV<b8oKb8Sl_9S<boV<b8oKb8Sl_9S<boV<b8oKb8Sl_9S<boV<b8"
            A$ = A$ + "oKb8Slo9T@boXDB9oSR9Vlo7L`aoahR;oKhP2n_R7Jho9JHQoCHP0no[ZZjo_S>jo_>iToojTCno[C>io_>iToojTCno[C>io_>i"
            A$ = A$ + "ToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iTooj"
            A$ = A$ + "TCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno"
            A$ = A$ + "[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>i"
            A$ = A$ + "o_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>i"
            A$ = A$ + "ToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iTooj"
            A$ = A$ + "TCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno"
            A$ = A$ + "[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>i"
            A$ = A$ + "o_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>i"
            A$ = A$ + "To?lYWno4ok_oGXP2nOR6Fho9JHQogXR9nOB6IdoJLa5oOB9Ul?:UDboV<b8oKb8Sl_9S<boV<b8oKb8Sl_9S<boV<b8oKb8Sl_9"
            A$ = A$ + "S<boV<b8oKb8Sl_9S<boV<b8oKb8Sl_9S<boV<b8oKb8Sl_9S<boV<b8oKb8Sl_9S<boV<b8oKb8Sl_9S<boV<b8oKb8S\?7JXAl"
            A$ = A$ + "HLa5oWa5GPO6GL1;000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000P9S<2^V<b8oKb8Sl_9S<boV<b8oKb8Sl_9S<boV<b8oKb8Sl_9S<boV<b8oKb8"
            A$ = A$ + "Sl_9S<boV<b8oKb8Sl_9S<boV<b8oKb8Sl_9S<boV<b8oKb8Sl_9S<boV<b8oKb8Sl_9S<boW@29oSB9Ul?:VHboO`17o7S;^l_Q"
            A$ = A$ + "3>ho:NhQoWXQ6noP16ho_ZZZoo>jXoojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno"
            A$ = A$ + "[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>i"
            A$ = A$ + "o_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>i"
            A$ = A$ + "ToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iTooj"
            A$ = A$ + "TCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno"
            A$ = A$ + "[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>i"
            A$ = A$ + "o_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>i"
            A$ = A$ + "ToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iTooj"
            A$ = A$ + "TCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCno[C>io_>iToojTCnoaWNjoCl_onOQ2:ho9JXQoWXQ6nOS:Zho"
            A$ = A$ + "9ITAo[a5Glo9UDboXDB9oKb8Sl_9S<boV<b8oKb8Sl_9S<boV<b8oKb8Sl_9S<boV<b8oKb8Sl_9S<boV<b8oKb8Sl_9S<boV<b8"
            A$ = A$ + "oKb8Sl_9S<boV<b8oKb8Sl_9S<boV<b8oKb8Sl_9S<boV<b8oKb8Sl_9S<bnLXQ6aSa5GlO6GL1nILa5\0000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000V<b8hJb8Sl_9S<boV<b8oKb8Sl_9S<boV<b8oKb8Sl_9S<boV<b8oKb8Sl_9S<boV<b8oKb8Sl_9S<boV<b8oKb8Sl_9S<bo"
            A$ = A$ + "V<b8oKb8Sl_9S<boV<b8oKb8Sl_9S<boV<b8oO29Tl?:UDboXHR9oo17LlO<^hbo6>hPo[hQ7nOR6Jho36HPooZZZnokXSno[C>i"
            A$ = A$ + "o_>iToojTCno[C>io_>iToOkVKno`WNjo3OjYo?lYWno`WNjo3OjYo?lYWno`WNjo3OjYo?lYWno`WNjo3OjYo?lYWno`WNjo3Oj"
            A$ = A$ + "Yo?lYWno`WNjo3OjYo?lYWno`WNjo3OjYo?lYWno`WNjo3OjYo?lYWno`WNjo3OjYo?lYWno`WNjo3OjYo?lYWno`WNjo3OjYo?l"
            A$ = A$ + "YWno`WNjo3OjYo?lYWno`WNjo3OjYo?lYWno`WNjo3OjYo?lYWno`WNjo3OjYo?lYWno`WNjo3OjYo?lYWno`WNjo3OjYo?lYWno"
            A$ = A$ + "`WNjo3OjYo?lYWno`WNjo3OjYo?lYWno`WNjo3OjYo?lYWno`WNjo3OjYo?lYWno`WNjo3OjYo?lYWno`WNjo3OjYo?lYWno`WNj"
            A$ = A$ + "o3OjYo?lYWno`WNjo3OjYo?lYWno`WNjo3OjYo?lYWno`WNjo3OjYo?lYWno`WNjo3OjYo?lYWno`WNjo3OjYo?lYWno`WNjo3Oj"
            A$ = A$ + "Yo?lYWno`WNjo3OjYo?lYWno`WNjo3OjYo?lYWno`WNjo3OjYo?lYWno`WNjo3OjYo?lYWno`WNjo3OjYo?lYWno`WNjo3OjYo?l"
            A$ = A$ + "YWno`WNjo3OjYo?lYWno`WNjo3OjYo?lYWno`WNjo3OjYo?lYWno`WNjo3OjYo?lYWno`WNjo3OjYo?lYWno`WNjo3OjYo?lYWno"
            A$ = A$ + "`WNjo3OjYo?lYWno`WNjo3OjYo?lYWno`WNjo3OjYo?lYWno`WNjo3OjYo?lYWno`WNjo3OjYo?lYWno`WNjo3OjYo?lYWno`WNj"
            A$ = A$ + "o3OjYo_kWOno[C>io_>iToojTCno[C>io7OjYo?aonko5:XPoWXQ6nOR6Jho=ZXRoWTA6m_6GLaoWDB9oSB9Ul_9S<boV<b8oKb8"
            A$ = A$ + "Sl_9S<boV<b8oKb8Sl_9S<boV<b8oKb8Sl_9S<boV<b8oKb8Sl_9S<boV<b8oKb8Sl_9S<boV<b8oKb8Sl_9S<boV<b8oKb8Sl_9"
            A$ = A$ + "S<boV<b8oKb8Sl_9S<boV<b8kcQ6J4?6GLaoILa5hWa5G`200000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000000000000000000000000000000000000000Hb8RP[9S8boV<R8oKb8Rl_9S8boV<R8"
            A$ = A$ + "oKb8Rl_9S8boV<R8oKb8Rl_9S8boV<R8oKb8Rl_9S8boV<R8oKb8Rl_9S8boV<R8oKb8Rl_9S8boV<R8oKb8Rl_9S8boV<R8oKb8"
            A$ = A$ + "Rlo9T<boXD29oSR9Ulo7L\aoahB;oK8Q3n_R8Nho9NXQo?XP1no[[Zjo_W>jo_NiToojUCno[G>io_NiTo_kWOnoJCmdoGl_on?b"
            A$ = A$ + "27lo8;L`oS\`1o?b27lo8;L`oS\`1o?b27lo8;L`oS\`1o?b27lo8;L`oS\`1o?b27lo8;L`oS\`1o?b27lo8;L`oS\`1o?b27lo"
            A$ = A$ + "8;L`oS\`1o?b27lo8;L`oS\`1o?b27lo8;L`oS\`1o?b27lo8;L`oS\`1o?b27lo8;L`oS\`1o?b27lo8;L`oS\`1o?b27lo8;L`"
            A$ = A$ + "oS\`1o?b27lo8;L`oS\`1o?b27lo8;L`oS\`1o?b27lo8;L`oS\`1o?b27lo8;L`oS\`1o?b27lo8;L`oS\`1o?b27lo8;L`oS\`"
            A$ = A$ + "1o?b27lo8;L`oS\`1o?b27lo8;L`oS\`1o?b27lo8;L`oS\`1o?b27lo8;L`oS\`1o?b27lo8;L`oS\`1o?b27lo8;L`oS\`1o?b"
            A$ = A$ + "27lo8;L`oS\`1o?b27lo8;L`oS\`1o?b27lo8;L`oS\`1o?b27lo8;L`oS\`1o?b27lo8;L`oS\`1o?b27lo8;L`oS\`1o?b27lo"
            A$ = A$ + "8;L`oS\`1o?b27lo8;L`oS\`1o?b27lo8;L`oS\`1o?b27lo8;L`oS\`1o?b27lo8;L`oS\`1o?b27lo8;L`oS\`1o?b27lo8;L`"
            A$ = A$ + "oS\`1o?b27lo8;L`oS\`1o?b27lo8;L`oS\`1o?b27lo8;L`oS\`1o?b27lo8;L`oS\`1o?b27lo8;L`oS\`1o?b27lo8;L`oS\`"
            A$ = A$ + "1o?b27lo8;L`oS\`1o?b27lo8;L`oS\`1o?b27lo8;L`oS\`1o?b27lo8;L`oS\`1oOa0okoF3=dog^iVoojUCno[G>io_NiToOl"
            A$ = A$ + "ZWno43l_oGhP2nOR7Jho9NXQoghR:nOB6EdoJLQ5oOB9Tl?:U@boV<R8oKb8Rl_9S8boV<R8oKb8Rl_9S8boV<R8oKb8Rl_9S8bo"
            A$ = A$ + "V<R8oKb8Rl_9S8boV<R8oKb8Rl_9S8boV<R8oKb8Rl_9S8boV<R8oKb8Rl_9S8boV<R8oKb8Rl_9S8boV<R8oKb8R\?7JXAlHLa5"
            A$ = A$ + "oWa5GPO6GL1;0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000P9S82^V<R8oKb8Rl_9S8boV<R8oKb8Rl_9S8boV<R8oKb8Rl_9S8boV<R8oKb8Rl_9"
            A$ = A$ + "S8boV<R8oKb8Rl_9S8boV<R8oKb8Rl_9S8boV<R8oKb8Rl_9S8boV<R8oKb8Rl_9S8boW@b8oSB9Tl?:VDboO`a6o7S;]loQ4>ho"
            A$ = A$ + ";RhQo[hQ6n?Q26ho_^ZZooNjXoojUCno[G>io_NiToojUCnoa_^jo?\_mn_UC:ioLRiUoc9VGn?WHNioLRiUoc9VGn?WHNioLRiU"
            A$ = A$ + "oc9VGn?WHNioLRiUoc9VGn?WHNioLRiUoc9VGn?WHNioLRiUoc9VGn?WHNioLRiUoc9VGn?WHNioLRiUoc9VGn?WHNioLRiUoc9V"
            A$ = A$ + "Gn?WHNioLRiUoc9VGn?WHNioLRiUoc9VGn?WHNioLRiUoc9VGn?WHNioLRiUoc9VGn?WHNioLRiUoc9VGn?WHNioLRiUoc9VGn?W"
            A$ = A$ + "HNioLRiUoc9VGn?WHNioLRiUoc9VGn?WHNioLRiUoc9VGn?WHNioLRiUoc9VGn?WHNioLRiUoc9VGn?WHNioLRiUoc9VGn?WHNio"
            A$ = A$ + "LRiUoc9VGn?WHNioLRiUoc9VGn?WHNioLRiUoc9VGn?WHNioLRiUoc9VGn?WHNioLRiUoc9VGn?WHNioLRiUoc9VGn?WHNioLRiU"
            A$ = A$ + "oc9VGn?WHNioLRiUoc9VGn?WHNioLRiUoc9VGn?WHNioLRiUoc9VGn?WHNioLRiUoc9VGn?WHNioLRiUoc9VGn?WHNioLRiUoc9V"
            A$ = A$ + "Gn?WHNioLRiUoc9VGn?WHNioLRiUoc9VGn?WHNioLRiUoc9VGn?WHNioLRiUoc9VGn?WHNioLRiUoc9VGn?WHNioLRiUoc9VGn?W"
            A$ = A$ + "HNioLRiUoc9VGn?WHNioLRiUoc9VGn?WHNioLRiUoc9VGn?WHNioLRiUoc9VGn?WHNioLRiUoc9VGn?WHNioLRiUoc9VGn?WHNio"
            A$ = A$ + "LRiUoc9VGn?WHNioLRiUoc9VGn?WHNioHBiTo[[]en_kXOno[G>io_NiToojUCno`[NjoG<`on_Q3:ho:NXQo[hQ6n_S;Zho9IDA"
            A$ = A$ + "o[a5Flo9U@boXD29oKb8Rl_9S8boV<R8oKb8Rl_9S8boV<R8oKb8Rl_9S8boV<R8oKb8Rl_9S8boV<R8oKb8Rl_9S8boV<R8oKb8"
            A$ = A$ + "Rl_9S8boV<R8oKb8Rl_9S8boV<R8oKb8Rl_9S8boV<R8oKb8Rl_9S8bnLXQ6aSa5GlO6GL1nILa5\00000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "V<R8hJb8Rl_9S8boV<R8oKb8Rl_9S8boV<R8oKb8Rl_9S8boV<R8oKb8Rl_9S8boV<R8oKb8Rl_9S8boV<R8oKb8Rl_9S8boV<R8"
            A$ = A$ + "oKb8Rl_9S8boV<R8oKb8Rl_9S8boV<R8oO29Sl?:U@boXHB9oo17KlO<^dbo7BhPo_8R7n_R7Jho5:HPoojZZnokYSno[G>io_Ni"
            A$ = A$ + "ToojUCno[G>iok>jWo_d=clod2k[oSk\bn?^c:koh>[\oSk\bn?^c:koh>[\oSk\bn?^c:koh>[\oSk\bn?^c:koh>[\oSk\bn?^"
            A$ = A$ + "c:koh>[\oSk\bn?^c:koh>[\oSk\bn?^c:koh>[\oSk\bn?^c:koh>[\oSk\bn?^c:koh>[\oSk\bn?^c:koh>[\oSk\bn?^c:ko"
            A$ = A$ + "h>[\oSk\bn?^c:koh>[\oSk\bn?^c:koh>[\oSk\bn?^c:koh>[\oSk\bn?^c:koh>[\oSk\bn?^c:koh>[\oSk\bn?^c:koh>[\"
            A$ = A$ + "oSk\bn?^c:koh>[\oSk\bn?^c:koh>[\oSk\bn?^c:koh>[\oSk\bn?^c:koh>[\oSk\bn?^c:koh>[\oSk\bn?^c:koh>[\oSk\"
            A$ = A$ + "bn?^c:koh>[\oSk\bn?^c:koh>[\oSk\bn?^c:koh>[\oSk\bn?^c:koh>[\oSk\bn?^c:koh>[\oSk\bn?^c:koh>[\oSk\bn?^"
            A$ = A$ + "c:koh>[\oSk\bn?^c:koh>[\oSk\bn?^c:koh>[\oSk\bn?^c:koh>[\oSk\bn?^c:koh>[\oSk\bn?^c:koh>[\oSk\bn?^c:ko"
            A$ = A$ + "h>[\oSk\bn?^c:koh>[\oSk\bn?^c:koh>[\oSk\bn?^c:koh>[\oSk\bn?^c:koh>[\oSk\bn?^c:koh>[\oSk\bn?^c:koh>[\"
            A$ = A$ + "oSk\bn?^c:koh>[\oSk\bn?^c:koh>[\oSk\bn?^c:koh>[\oSk\bn?^c:koh>[\oSk\bn?^c:koh>[\oSk\bn?^c:koh>[\oG;\"
            A$ = A$ + "_n?c7Glo]O^io_NiToojUCno[G>io3_jYoOa0oko6>XPo[hQ6n_R7Jho>^XRoWTA5m_6GHaoWD29oSB9Tl_9S8boV<R8oKb8Rl_9"
            A$ = A$ + "S8boV<R8oKb8Rl_9S8boV<R8oKb8Rl_9S8boV<R8oKb8Rl_9S8boV<R8oKb8Rl_9S8boV<R8oKb8Rl_9S8boV<R8oKb8Rl_9S8bo"
            A$ = A$ + "V<R8oKb8Rl_9S8boV<R8kcQ6J4?6GLaoILa5hWa5G`2000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000000000000000000000000000000DR8RPK9R8boU8R8oGR8RlO9R8boU8R8oGR8"
            A$ = A$ + "RlO9R8boU8R8oGR8RlO9R8boU8R8oGR8RlO9R8boU8R8oGR8RlO9R8boU8R8oGR8RlO9R8boU8R8oGR8RlO9R8boU8R8oGR8Rl_9"
            A$ = A$ + "S<boW@29oOB9Ul_7K\aoahR;oKhP3n_R7Nho9JXQo?HP1no[[^jo_WNjo_NiUoojUGno[GNio_NiUoojUGno[GNio_NiUoojUGno"
            A$ = A$ + "[GNio_NiUoojUGno[GNio_NiUoojUGno[GNio_NiUoojUGno[GNio_NiUoojUGno[GNio_NiUoojUGno[GNio_NiUoojUGno[GNi"
            A$ = A$ + "o_NiUoojUGno[GNio_NiUoojUGno[GNio_NiUoojUGno[GNio_NiUoojUGno[GNio_NiUoojUGno[GNio_NiUoojUGno[GNio_Ni"
            A$ = A$ + "UoojUGno[GNio_NiUoojUGno[GNio_NiUoojUGno[GNio_NiUoojUGno[GNio_NiUoojUGno[GNio_NiUoojUGno[GNio_NiUooj"
            A$ = A$ + "UGno[GNio_NiUoojUGno[GNio_NiUoojUGno[GNio_NiUoojUGno[GNio_NiUoojUGno[GNio_NiUoojUGno[GNio_NiUoojUGno"
            A$ = A$ + "[GNio_NiUoojUGno[GNio_NiUoojUGno[GNio_NiUoojUGno[GNio_NiUoojUGno[GNio_NiUoojUGno[GNio_NiUoojUGno[GNi"
            A$ = A$ + "o_NiUoojUGno[GNio_NiUoojUGno[GNio_NiUoojUGno[GNio_NiUoojUGno[GNio_NiUoojUGno[GNio_NiUoojUGno[GNio_Ni"
            A$ = A$ + "UoojUGno[GNio_NiUoojUGno[GNio_NiUoojUGno[GNio_NiUoojUGno[GNio_NiUoojUGno[GNio_NiUoojUGno[GNio_NiUooj"
            A$ = A$ + "UGno[GNio_NiUoojUGno[GNio_NiUoojUGno[GNio_NiUoojUGno[GNio_NiUoojUGno[GNio_NiUoojUGno[GNio_NiUoOlZ[no"
            A$ = A$ + "43<`oGhP3nOR6Jho9JXQogXR:n?B5EdoIHQ5oO29Tlo9T@boU8R8oGR8RlO9R8boU8R8oGR8RlO9R8boU8R8oGR8RlO9R8boU8R8"
            A$ = A$ + "oGR8RlO9R8boU8R8oGR8RlO9R8boU8R8oGR8RlO9R8boU8R8oGR8RlO9R8boU8R8oGR8RlO9R8boU8R8oGR8R\?7JXAlILa5oWa5"
            A$ = A$ + "GPO6GL1;00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000@9R82^U8R8oGR8RlO9R8boU8R8oGR8RlO9R8boU8R8oGR8RlO9R8boU8R8oGR8RlO9R8bo"
            A$ = A$ + "U8R8oGR8RlO9R8boU8R8oGR8RlO9R8boU8R8oGR8RlO9R8boU8R8oGR8RlO9R8boV<b8oO29Tlo9UDboN\a6o7S;^l_Q3>ho:NhQ"
            A$ = A$ + "oWXQ6noP16ho_^jZooNjYoojUGno[GNio_NiUoojUGno[GNio_NiUo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^i"
            A$ = A$ + "Vo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?k"
            A$ = A$ + "VKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno"
            A$ = A$ + "\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^i"
            A$ = A$ + "oc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^i"
            A$ = A$ + "Vo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?k"
            A$ = A$ + "VKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno"
            A$ = A$ + "\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^i"
            A$ = A$ + "oc^iVo?kVKno\K^ioc^iVo?kVKno\K^io_NiUoojUGno[GNio_NiUoojUGnoa[^joC<`0oOQ3>ho9JXQoWXQ6nOS:Zho8EDAoWQ5"
            A$ = A$ + "Flo9T@boW@29oGR8RlO9R8boU8R8oGR8RlO9R8boU8R8oGR8RlO9R8boU8R8oGR8RlO9R8boU8R8oGR8RlO9R8boU8R8oGR8RlO9"
            A$ = A$ + "R8boU8R8oGR8RlO9R8boU8R8oGR8RlO9R8boU8R8oGR8RlO9R8bnLXQ6aWa5GlO6GL1nILa5\000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000U8R8"
            A$ = A$ + "hFR8RlO9R8boU8R8oGR8RlO9R8boU8R8oGR8RlO9R8boU8R8oGR8RlO9R8boU8R8oGR8RlO9R8boU8R8oGR8RlO9R8boU8R8oGR8"
            A$ = A$ + "RlO9R8boU8R8oGR8RlO9R8boU8R8oKb8Slo9T@boWDB9oka6KlO<^hbo6>hPo[hQ7nOR6Jho36HPoojZ[n?lYWno\GNiocNiUo?k"
            A$ = A$ + "UGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno"
            A$ = A$ + "\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNi"
            A$ = A$ + "ocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNi"
            A$ = A$ + "Uo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?k"
            A$ = A$ + "UGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno"
            A$ = A$ + "\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNi"
            A$ = A$ + "ocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNi"
            A$ = A$ + "Uo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?kUGno\GNiocNiUo?k"
            A$ = A$ + "UGno\GNiocNiUo?kUGno\GNio;_jZoOa03lo5>hPoWXQ6nOR6Jho=ZXRoSDA5mO6FHaoW@29oO29TlO9R8boU8R8oGR8RlO9R8bo"
            A$ = A$ + "U8R8oGR8RlO9R8boU8R8oGR8RlO9R8boU8R8oGR8RlO9R8boU8R8oGR8RlO9R8boU8R8oGR8RlO9R8boU8R8oGR8RlO9R8boU8R8"
            A$ = A$ + "oGR8RlO9R8boU8R8kcQ6J4O6GLaoILa5hWa5G`20000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000DR8QPK9R4boU8B8oGR8QlO9R4boU8B8oGR8QlO9"
            A$ = A$ + "R4boU8B8oGR8QlO9R4boU8B8oGR8QlO9R4boU8B8oGR8QlO9R4boU8B8oGR8QlO9R4boU8B8oGR8QlO9R4boU8B8oGR8Ql_9S8bo"
            A$ = A$ + "W@b8oOB9Tl_7K\aoahR;oO8Q3noR8Nho:NXQoCXP1n?\\^jo`[Njoc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNi"
            A$ = A$ + "oc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^i"
            A$ = A$ + "Uo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?k"
            A$ = A$ + "VGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno"
            A$ = A$ + "\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNi"
            A$ = A$ + "oc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^i"
            A$ = A$ + "Uo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?k"
            A$ = A$ + "VGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno"
            A$ = A$ + "\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo_l[[no57<`"
            A$ = A$ + "oK8Q3n_R7Jho:NXQokhR:nOB6EdoIHQ5oO29Slo9T<boU8B8oGR8QlO9R4boU8B8oGR8QlO9R4boU8B8oGR8QlO9R4boU8B8oGR8"
            A$ = A$ + "QlO9R4boU8B8oGR8QlO9R4boU8B8oGR8QlO9R4boU8B8oGR8QlO9R4boU8B8oGR8QlO9R4boU8B8oGR8Q\?7JTAlILa5oWa5GPO6"
            A$ = A$ + "GL1;000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000@9R42^U8B8oGR8QlO9R4boU8B8oGR8QlO9R4boU8B8oGR8QlO9R4boU8B8oGR8QlO9R4boU8B8"
            A$ = A$ + "oGR8QlO9R4boU8B8oGR8QlO9R4boU8B8oGR8QlO9R4boU8B8oGR8QlO9R4boV<R8oO29Slo9U@boN\a6o7S;^loQ4>ho;RhQo[hQ"
            A$ = A$ + "6n?Q26ho`bjZo3_jYo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?k"
            A$ = A$ + "VGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno"
            A$ = A$ + "\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNi"
            A$ = A$ + "oc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^i"
            A$ = A$ + "Uo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?k"
            A$ = A$ + "VGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno"
            A$ = A$ + "\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNi"
            A$ = A$ + "oc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^i"
            A$ = A$ + "Uo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGnob_^joGL`0o_Q4>ho:NXQo[hQ6n_S;Zho9IDAoWQ5Flo9"
            A$ = A$ + "T<boW@b8oGR8QlO9R4boU8B8oGR8QlO9R4boU8B8oGR8QlO9R4boU8B8oGR8QlO9R4boU8B8oGR8QlO9R4boU8B8oGR8QlO9R4bo"
            A$ = A$ + "U8B8oGR8QlO9R4boU8B8oGR8QlO9R4boU8B8oGR8QlO9R4bnLXA6aWa5GlO6GL1nILa5\0000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000U8B8hFR8"
            A$ = A$ + "QlO9R4boU8B8oGR8QlO9R4boU8B8oGR8QlO9R4boU8B8oGR8QlO9R4boU8B8oGR8QlO9R4boU8B8oGR8QlO9R4boU8B8oGR8QlO9"
            A$ = A$ + "R4boU8B8oGR8QlO9R4boU8B8oKb8Rlo9T<boWD29oka6KlO<^hbo7BhPo_8R7n_R7Jho4:HPo3;[[n?lZWno\KNioc^iUo?kVGno"
            A$ = A$ + "\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNi"
            A$ = A$ + "oc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^i"
            A$ = A$ + "Uo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?k"
            A$ = A$ + "VGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno"
            A$ = A$ + "\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNi"
            A$ = A$ + "oc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^i"
            A$ = A$ + "Uo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?k"
            A$ = A$ + "VGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno\KNioc^iUo?kVGno"
            A$ = A$ + "\KNioc^iUo?kVGno\KNio;ojZoOa13lo6BhPo[hQ6n_R7Jho>^XRoWTA5mO6FHaoW@b8oO29SlO9R4boU8B8oGR8QlO9R4boU8B8"
            A$ = A$ + "oGR8QlO9R4boU8B8oGR8QlO9R4boU8B8oGR8QlO9R4boU8B8oGR8QlO9R4boU8B8oGR8QlO9R4boU8B8oGR8QlO9R4boU8B8oGR8"
            A$ = A$ + "QlO9R4boU8B8kcQ6I4O6GLaoILa5hWa5G`200000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000000000000000000000000000@B8QP;9Q4boT4B8oCB8Ql?9Q4boT4B8oCB8Ql?9Q4bo"
            A$ = A$ + "T4B8oCB8Ql?9Q4boT4B8oCB8Ql?9Q4boT4B8oCB8Ql?9Q4boT4B8oCB8Ql?9Q4boT4B8oCB8Ql?9Q4boT4B8oCB8QlO9R8boV<b8"
            A$ = A$ + "oO29TlO7K\ao`hR;oO8Q4noR8Rho:NhQoCXP2n?\\bjo`[^joc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^i"
            A$ = A$ + "Vo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?k"
            A$ = A$ + "VKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno"
            A$ = A$ + "\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^i"
            A$ = A$ + "oc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^i"
            A$ = A$ + "Vo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?k"
            A$ = A$ + "VKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno"
            A$ = A$ + "\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^i"
            A$ = A$ + "oc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo_l[_no57L`oK8Q"
            A$ = A$ + "4n_R7Nho:NhQokhR;n?B6IdoHHQ5oKb8Sl_9S<boT4B8oCB8Ql?9Q4boT4B8oCB8Ql?9Q4boT4B8oCB8Ql?9Q4boT4B8oCB8Ql?9"
            A$ = A$ + "Q4boT4B8oCB8Ql?9Q4boT4B8oCB8Ql?9Q4boT4B8oCB8Ql?9Q4boT4B8oCB8Ql?9Q4boT4B8oCB8Q\?7ITAlILa5oWa5GPO6GL1;"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000009Q42^T4B8oCB8Ql?9Q4boT4B8oCB8Ql?9Q4boT4B8oCB8Ql?9Q4boT4B8oCB8Ql?9Q4boT4B8oCB8"
            A$ = A$ + "Ql?9Q4boT4B8oCB8Ql?9Q4boT4B8oCB8Ql?9Q4boT4B8oCB8Ql?9Q4boU8R8oKb8Slo9T@boM\a6o3S;^loQ4Bho;R8Ro[hQ7n?Q"
            A$ = A$ + "2:ho`b:[o3_jZo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno"
            A$ = A$ + "\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^i"
            A$ = A$ + "oc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^i"
            A$ = A$ + "Vo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?k"
            A$ = A$ + "VKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno"
            A$ = A$ + "\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^i"
            A$ = A$ + "oc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^i"
            A$ = A$ + "Vo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?k"
            A$ = A$ + "VKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKnob_njoGL`1o_Q4Bho:NhQo[hQ7n_S;^ho8ITAoSQ5Fl_9S<bo"
            A$ = A$ + "V<b8oCB8Ql?9Q4boT4B8oCB8Ql?9Q4boT4B8oCB8Ql?9Q4boT4B8oCB8Ql?9Q4boT4B8oCB8Ql?9Q4boT4B8oCB8Ql?9Q4boT4B8"
            A$ = A$ + "oCB8Ql?9Q4boT4B8oCB8Ql?9Q4boT4B8oCB8Ql?9Q4bnLTA6aWa5GlO6GL1nILa5\00000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000T4B8hBB8Ql?9"
            A$ = A$ + "Q4boT4B8oCB8Ql?9Q4boT4B8oCB8Ql?9Q4boT4B8oCB8Ql?9Q4boT4B8oCB8Ql?9Q4boT4B8oCB8Ql?9Q4boT4B8oCB8Ql?9Q4bo"
            A$ = A$ + "T4B8oCB8Ql?9Q4boT4B8oGR8Rl_9S<boW@29oga6Kl?<^hbo7F8Qo_HR8n_R8Nho4>XPo3;[\n?lZ[no\K^ioc^iVo?kVKno\K^i"
            A$ = A$ + "oc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^i"
            A$ = A$ + "Vo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?k"
            A$ = A$ + "VKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno"
            A$ = A$ + "\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^i"
            A$ = A$ + "oc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^i"
            A$ = A$ + "Vo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?k"
            A$ = A$ + "VKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno"
            A$ = A$ + "\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^ioc^iVo?kVKno\K^i"
            A$ = A$ + "oc^iVo?kVKno\K^io;oj[oOa17lo6B8Qo[8R7n_R8Nho>bhRoSTA6m?6FHaoV<b8oKb8Sl?9Q4boT4B8oCB8Ql?9Q4boT4B8oCB8"
            A$ = A$ + "Ql?9Q4boT4B8oCB8Ql?9Q4boT4B8oCB8Ql?9Q4boT4B8oCB8Ql?9Q4boT4B8oCB8Ql?9Q4boT4B8oCB8Ql?9Q4boT4B8oCB8Ql?9"
            A$ = A$ + "Q4boT4B8kcA6I4O6GLaoILa5hWa5G`2000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000000000000000000@B8PP;9Q0boT428oCB8Pl?9Q0boT428oCB8Pl?9Q0boT428"
            A$ = A$ + "oCB8Pl?9Q0boT428oCB8Pl?9Q0boT428oCB8Pl?9Q0boT428oCB8Pl?9Q0boT428oCB8Pl?9Q0boT428oCB8PlO9R4boV<R8oO29"
            A$ = A$ + "SlO7JTao`hB;oSHQ4n?S9Rho;RhQoKhP2n?\]bjo`_^jocniVo?kWKno\O^iocniVo?kWKno\O^iocniVo?kWKno\O^iocniVo?k"
            A$ = A$ + "WKno\O^iocniVo?kWKno\O^iocniVo?kWKno\O^iocniVo?kWKno\O^iocniVo?kWKno\O^iocniVo?kWKno\O^iocniVo?kWKno"
            A$ = A$ + "\O^iocniVo?kWKno\O^iocniVo?kWKno\O^iocniVo?kWKno\O^iocniVo?kWKno\O^iocniVo?kWKno\O^iocniVo?kWKno\O^i"
            A$ = A$ + "ocniVo?kWKno\O^iocniVo?kWKno\O^iocniVo?kWKno\O^iocniVo?kWKno\O^iocniVo?kWKno\O^iocniVo?kWKno\O^iocni"
            A$ = A$ + "Vo?kWKno\O^iocniVo?kWKno\O^iocniVo?kWKno\O^iocniVo?kWKno\O^iocniVo?kWKno\O^iocniVo?kWKno\O^iocniVo?k"
            A$ = A$ + "WKno\O^iocniVo?kWKno\O^iocniVo?kWKno\O^iocniVo?kWKno\O^iocniVo?kWKno\O^iocniVo?kWKno\O^iocniVo?kWKno"
            A$ = A$ + "\O^iocniVo?kWKno\O^iocniVo?kWKno\O^iocniVo?kWKno\O^iocniVo?kWKno\O^iocniVo?kWKno\O^iocniVo?kWKno\O^i"
            A$ = A$ + "ocniVo?kWKno\O^iocniVo?kWKno\O^iocniVo?kWKno\O^iocniVo?kWKno\O^iocniVo?kWKno\O^iocniVo?kWKno\O^iocni"
            A$ = A$ + "Vo?kWKno\O^iocniVo?kWKno\O^iocniVo?kWKno\O^iocniVo?kWKno\O^iocniVo?kWKno\O^iocniVoOl\_no7;L`oOHQ4noR"
            A$ = A$ + "8Nho;RhQoo8S;n?B6EdoHHA5oKb8Rl_9S8boT428oCB8Pl?9Q0boT428oCB8Pl?9Q0boT428oCB8Pl?9Q0boT428oCB8Pl?9Q0bo"
            A$ = A$ + "T428oCB8Pl?9Q0boT428oCB8Pl?9Q0boT428oCB8Pl?9Q0boT428oCB8Pl?9Q0boT428oCB8P\?7ITAlILa5oWa5GPO6GL1;0000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000009Q02^T428oCB8Pl?9Q0boT428oCB8Pl?9Q0boT428oCB8Pl?9Q0boT428oCB8Pl?9Q0boT428oCB8Pl?9"
            A$ = A$ + "Q0boT428oCB8Pl?9Q0boT428oCB8Pl?9Q0boT428oCB8Pl?9Q0boU8B8oKb8Rlo9T<boMXA6o3S;]l?R5Bho<V8Ro_8R7nOQ3:ho"
            A$ = A$ + "af:[o7ojZoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^i"
            A$ = A$ + "ogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogni"
            A$ = A$ + "VoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOk"
            A$ = A$ + "WKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno"
            A$ = A$ + "]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^i"
            A$ = A$ + "ogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogni"
            A$ = A$ + "VoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOk"
            A$ = A$ + "WKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno"
            A$ = A$ + "]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKnoccnjoO\`1ooQ5Bho;RhQo_8R7noS<^ho8IDAoSQ5El_9S8boV<R8"
            A$ = A$ + "oCB8Pl?9Q0boT428oCB8Pl?9Q0boT428oCB8Pl?9Q0boT428oCB8Pl?9Q0boT428oCB8Pl?9Q0boT428oCB8Pl?9Q0boT428oCB8"
            A$ = A$ + "Pl?9Q0boT428oCB8Pl?9Q0boT428oCB8Pl?9Q0bnLTA6aWa5GlO6GL1nILa5\000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000000000000000000000000000000000000000000000000000000T428hBB8Pl?9Q0bo"
            A$ = A$ + "T428oCB8Pl?9Q0boT428oCB8Pl?9Q0boT428oCB8Pl?9Q0boT428oCB8Pl?9Q0boT428oCB8Pl?9Q0boT428oCB8Pl?9Q0boT428"
            A$ = A$ + "oCB8Pl?9Q0boT428oGR8Ql_9S8boW@b8ogQ6Il?<^dbo8FHQocHR9noR8Rho5>hPo7K[\nOl[[no]O^iogniVoOkWKno]O^iogni"
            A$ = A$ + "VoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOk"
            A$ = A$ + "WKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno"
            A$ = A$ + "]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^i"
            A$ = A$ + "ogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogni"
            A$ = A$ + "VoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOk"
            A$ = A$ + "WKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno"
            A$ = A$ + "]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^i"
            A$ = A$ + "ogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogniVoOkWKno]O^iogni"
            A$ = A$ + "VoOkWKno]O^io??k[ooa27lo7F8Qo_8R8noR8Rho?b8SoSTA6m?6FDaoV<R8oKb8Rl?9Q0boT428oCB8Pl?9Q0boT428oCB8Pl?9"
            A$ = A$ + "Q0boT428oCB8Pl?9Q0boT428oCB8Pl?9Q0boT428oCB8Pl?9Q0boT428oCB8Pl?9Q0boT428oCB8Pl?9Q0boT428oCB8Pl?9Q0bo"
            A$ = A$ + "T428kcA6I4O6GLaoILa5hWa5G`20000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000<28PPk8P0boS028o?28Plo8P0boS028o?28Plo8P0boS028o?28"
            A$ = A$ + "Plo8P0boS028o?28Plo8P0boS028o?28Plo8P0boS028o?28Plo8P0boS028o?28Plo8P0boS028o?28Pl?9Q4boU8R8oKb8Sl?7"
            A$ = A$ + "ITao_dB;oSHQ5n?S9Vho;R8RoGhP3nO\]fjoa_njogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno"
            A$ = A$ + "]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]Oni"
            A$ = A$ + "ogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]Oniogni"
            A$ = A$ + "WoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOk"
            A$ = A$ + "WOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno"
            A$ = A$ + "]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]Oni"
            A$ = A$ + "ogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]Oniogni"
            A$ = A$ + "WoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOk"
            A$ = A$ + "WOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWool\cno7;\`oOHQ5noR8Rho"
            A$ = A$ + ";R8Roo8S<n?B6IdoGDA5oGR8RlO9R8boS028o?28Plo8P0boS028o?28Plo8P0boS028o?28Plo8P0boS028o?28Plo8P0boS028"
            A$ = A$ + "o?28Plo8P0boS028o?28Plo8P0boS028o?28Plo8P0boS028o?28Plo8P0boS028o?28P\o6ITAlILa5oWa5GPO6GL1;00000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000`8P02^S028o?28Plo8P0boS028o?28Plo8P0boS028o?28Plo8P0boS028o?28Plo8P0boS028o?28Plo8P0bo"
            A$ = A$ + "S028o?28Plo8P0boS028o?28Plo8P0boS028o?28Plo8P0boT4B8oGR8Rl_9S<boLTA6o3C;]l?R5Fho<VHRo_8R8nOQ3>hoafJ["
            A$ = A$ + "o7oj[oOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]Oniogni"
            A$ = A$ + "WoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOk"
            A$ = A$ + "WOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno"
            A$ = A$ + "]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]Oni"
            A$ = A$ + "ogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]Oniogni"
            A$ = A$ + "WoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOk"
            A$ = A$ + "WOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno"
            A$ = A$ + "]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOno]Oni"
            A$ = A$ + "ogniWoOkWOno]OniogniWoOkWOno]OniogniWoOkWOnocc>koO\`2ooQ5Fho;R8Ro_8R8noS<bho8ITAoOA5ElO9R8boU8R8o?28"
            A$ = A$ + "Plo8P0boS028o?28Plo8P0boS028o?28Plo8P0boS028o?28Plo8P0boS028o?28Plo8P0boS028o?28Plo8P0boS028o?28Plo8"
            A$ = A$ + "P0boS028o?28Plo8P0boS028o?28Plo8P0bnKTA6aWa5GlO6GL1nILa5\0000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000000000000000000000000000000000000000000000S028h>28Plo8P0boS028"
            A$ = A$ + "o?28Plo8P0boS028o?28Plo8P0boS028o?28Plo8P0boS028o?28Plo8P0boS028o?28Plo8P0boS028o?28Plo8P0boS028o?28"
            A$ = A$ + "Plo8P0boS028oCB8QlO9R8boV<b8ocA6Il?<]dbo8JHQocXR9noR9Rho5BhPo7[[]nOl\_no]Sniog>jWoOkXOno]SniogniWoOk"
            A$ = A$ + "XOno]Sniog>jWoOkXOno]Sniog>jWoOkXOno]Sniog>jWoOkXOno]Sniog>jWoOkXOno]Sniog>jWoOkXOno]Sniog>jWoOkXOno"
            A$ = A$ + "]Sniog>jWoOkXOno]Sniog>jWoOkXOno]Sniog>jWoOkXOno]Sniog>jWoOkXOno]Sniog>jWoOkXOno]Sniog>jWoOkXOno]Sni"
            A$ = A$ + "og>jWoOkXOno]Sniog>jWoOkXOno]Sniog>jWoOkXOno]Sniog>jWoOkXOno]Sniog>jWoOkXOno]Sniog>jWoOkXOno]Sniog>j"
            A$ = A$ + "WoOkXOno]Sniog>jWoOkXOno]Sniog>jWoOkXOno]Sniog>jWoOkXOno]Sniog>jWoOkXOno]Sniog>jWoOkXOno]Sniog>jWoOk"
            A$ = A$ + "XOno]Sniog>jWoOkXOno]Sniog>jWoOkXOno]Sniog>jWoOkXOno]Sniog>jWoOkXOno]Sniog>jWoOkXOno]Sniog>jWoOkXOno"
            A$ = A$ + "]Sniog>jWoOkXOno]Sniog>jWoOkXOno]Sniog>jWoOkXOno]Sniog>jWoOkXOno]Sniog>jWoOkXOno]Sniog>jWoOkXOno]Sni"
            A$ = A$ + "og>jWoOkXOno]Sniog>jWoOkXOno]Sniog>jWoOkXOno]Sniog>jWoOkXOno]Sniog>jWoOkXOno]Sniog>jWoOkXOno]Sniog>j"
            A$ = A$ + "WoOkXOno]Sniog>jWoOkXOno]Sniog>jWoOkXOno]Sniog>jWoOkXOno]Sniog>jWoOkXOno]Sniog>jWoOkXOno]Oniog>jWoOk"
            A$ = A$ + "XOno]Snio?Ok\ooa3;lo7JHQo_HR8noR9Rho?f8SoSTA6mo5EDaoU8R8oGR8Rlo8P0boS028o?28Plo8P0boS028o?28Plo8P0bo"
            A$ = A$ + "S028o?28Plo8P0boS028o?28Plo8P0boS028o?28Plo8P0boS028o?28Plo8P0boS028o?28Plo8P0boS028o?28Plo8P0boS028"
            A$ = A$ + "k_A6I4O6GLaoILa5hWa5G`200000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000000000000000<28OPk8PlaoS0b7o?28Olo8PlaoS0b7o?28Olo8PlaoS0b7o?28Olo8"
            A$ = A$ + "PlaoS0b7o?28Olo8PlaoS0b7o?28Olo8PlaoS0b7o?28Olo8PlaoS0b7o?28Olo8PlaoS0b7o?28Ol?9Q0boU8B8oKb8Rl?7IPao"
            A$ = A$ + "`d2;oSXQ5n?S:Vho;V8RoG8Q3nO\^fjoacnjog>jWoOkXOno]Sniog>jWoOkXOno^W>jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^j"
            A$ = A$ + "o3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3oj"
            A$ = A$ + "Zo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l"
            A$ = A$ + "[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no"
            A$ = A$ + "`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^j"
            A$ = A$ + "o3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3oj"
            A$ = A$ + "Zo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l"
            A$ = A$ + "[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no"
            A$ = A$ + "`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no_[Njog>jWoOkXOno]Sniog>jWool]cno7?\`oOXQ5noR9Rho;V8R"
            A$ = A$ + "ooHS<n?B6EdoGD15oGR8QlO9R4boS0b7o?28Olo8PlaoS0b7o?28Olo8PlaoS0b7o?28Olo8PlaoS0b7o?28Olo8PlaoS0b7o?28"
            A$ = A$ + "Olo8PlaoS0b7o?28Olo8PlaoS0b7o?28Olo8PlaoS0b7o?28Olo8PlaoS0b7o?28O\o6ITAlILa5oWa5GPO6GL1;000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000`8Pl1^S0b7o?28Olo8PlaoS0b7o?28Olo8PlaoS0b7o?28Olo8PlaoS0b7o?28Olo8PlaoS0b7o?28Olo8PlaoS0b7"
            A$ = A$ + "o?28Olo8PlaoS0b7o?28Olo8PlaoS0b7o?28Olo8PlaoT428oGR8Ql_9S8boLT16o3C;\l?R6Fho<ZHRo_HR8nOQ4>hoajJ[o7?k"
            A$ = A$ + "[oOkXOno]Sniog>jWoOkXOno`_^joOmdBo__jVko1g;_o7L_lnO`mbko1g;_o7L_lnO`mbko1g;_o7L_lnO`mbko1g;_o7L_lnO`"
            A$ = A$ + "mbko1g;_o7L_lnO`mbko1g;_o7L_lnO`mbko1g;_o7L_lnO`mbko1g;_o7L_lnO`mbko1g;_o7L_lnO`mbko1g;_o7L_lnO`mbko"
            A$ = A$ + "1g;_o7L_lnO`mbko1g;_o7L_lnO`mbko1g;_o7L_lnO`mbko1g;_o7L_lnO`mbko1g;_o7L_lnO`mbko1g;_o7L_lnO`mbko1g;_"
            A$ = A$ + "o7L_lnO`mbko1g;_o7L_lnO`mbko1g;_o7L_lnO`mbko1g;_o7L_lnO`mbko1g;_o7L_lnO`mbko1g;_o7L_lnO`mbko1g;_o7L_"
            A$ = A$ + "lnO`mbko1g;_o7L_lnO`mbko1g;_o7L_lnO`mbko1g;_o7L_lnO`mbko1g;_o7L_lnO`mbko1g;_o7L_lnO`mbko1g;_o7L_lnO`"
            A$ = A$ + "mbko1g;_o7L_lnO`mbko1g;_o7L_lnO`mbko1g;_o7L_lnO`mbko1g;_o7L_lnO`mbko1g;_o7L_lnO`mbko1g;_o7L_lnO`mbko"
            A$ = A$ + "1g;_o7L_lnO`mbko1g;_o7L_lnO`mbko1g;_o7L_lnO`mbko1g;_o7L_lnO`mbko1g;_o7L_lnO`mbko1g;_o7L_lnO`mbko1g;_"
            A$ = A$ + "o7L_lnO`mbko1g;_o7L_lnO`mbko1g;_o7L_lnO`mbko1g;_o7L_lnO`mbko1g;_o7L_lnO`mbko1g;_o7L_lnO`mbko1g;_o7L_"
            A$ = A$ + "lnO`mbkon^[^o?mc>ookZWno]Sniog>jWoOkXOnocg>koOl`2ooQ6Fho;V8Ro_HR8noS=bho8IDAoOA5DlO9R4boU8B8o?28Olo8"
            A$ = A$ + "PlaoS0b7o?28Olo8PlaoS0b7o?28Olo8PlaoS0b7o?28Olo8PlaoS0b7o?28Olo8PlaoS0b7o?28Olo8PlaoS0b7o?28Olo8Plao"
            A$ = A$ + "S0b7o?28Olo8PlaoS0b7o?28Olo8PlanKTA6aWa5GlO6GL1nILa5\00000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000S0b7h>28Olo8PlaoS0b7o?28"
            A$ = A$ + "Olo8PlaoS0b7o?28Olo8PlaoS0b7o?28Olo8PlaoS0b7o?28Olo8PlaoS0b7o?28Olo8PlaoS0b7o?28Olo8PlaoS0b7o?28Olo8"
            A$ = A$ + "PlaoS0b7oCB8PlO9R4boV<R8ocA6Hl?<]dbo8JHQocXR9noR9Rho5BhPo7[[]n_l\_no^Sniok>jWo_kXOno^Snio?_k]ooa13lo"
            A$ = A$ + "HB9UogYVInOWJVioMZIVogYVInOWJVioMZIVogYVInOWJVioMZIVogYVInOWJVioMZIVogYVInOWJVioMZIVogYVInOWJVioMZIV"
            A$ = A$ + "ogYVInOWJVioMZIVogYVInOWJVioMZIVogYVInOWJVioMZIVogYVInOWJVioMZIVogYVInOWJVioMZIVogYVInOWJVioMZIVogYV"
            A$ = A$ + "InOWJVioMZIVogYVInOWJVioMZIVogYVInOWJVioMZIVogYVInOWJVioMZIVogYVInOWJVioMZIVogYVInOWJVioMZIVogYVInOW"
            A$ = A$ + "JVioMZIVogYVInOWJVioMZIVogYVInOWJVioMZIVogYVInOWJVioMZIVogYVInOWJVioMZIVogYVInOWJVioMZIVogYVInOWJVio"
            A$ = A$ + "MZIVogYVInOWJVioMZIVogYVInOWJVioMZIVogYVInOWJVioMZIVogYVInOWJVioMZIVogYVInOWJVioMZIVogYVInOWJVioMZIV"
            A$ = A$ + "ogYVInOWJVioMZIVogYVInOWJVioMZIVogYVInOWJVioMZIVogYVInOWJVioMZIVogYVInOWJVioMZIVogYVInOWJVioMZIVogYV"
            A$ = A$ + "InOWJVioMZIVogYVInOWJVioMZIVogYVInOWJVioMZIVogYVInOWJVioMZIVogYVInOWJVioMZIVogYVInOWJVioMZIVogYVInOW"
            A$ = A$ + "JVioMZIVogYVInOWJVioMZIVogYVInOWJVioMZIVogYVInOWJVioMZIVogYVInOWJVioMZIVoWYUEnO_hNkoa_^jok>jWo_kXOno"
            A$ = A$ + "^SnioCOk\o?b3;lo7FHQo_HR8noR9Rho?f8SoSTA5mo5E@aoU8B8oGR8Qlo8PlaoS0b7o?28Olo8PlaoS0b7o?28Olo8PlaoS0b7"
            A$ = A$ + "o?28Olo8PlaoS0b7o?28Olo8PlaoS0b7o?28Olo8PlaoS0b7o?28Olo8PlaoS0b7o?28Olo8PlaoS0b7o?28Olo8PlaoS0b7k_A6"
            A$ = A$ + "I4O6GLaoILa5hWa5G`2000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000000000008b7OP[8OlaoRla7o;b7Ol_8OlaoRla7o;b7Ol_8OlaoRla7o;b7Ol_8Olao"
            A$ = A$ + "Rla7o;b7Ol_8OlaoRla7o;b7Ol_8OlaoRla7o;b7Ol_8OlaoRla7o;b7Ol_8OlaoRla7o;b7Olo8P0boT4B8oGR8Rlo6HPao`dB;"
            A$ = A$ + "oSHQ5n?S9Vho;R8RoGhP3nO\]fjobc>kok>jXo_kXSno^S>jok>jXoOl[_noI?mdoo[^jn_`mfko2gK_o;L_mn_`mfko2gK_o;L_"
            A$ = A$ + "mn_`mfko2gK_o;L_mn_`mfko2gK_o;L_mn_`mfko2gK_o;L_mn_`mfko2gK_o;L_mn_`mfko2gK_o;L_mn_`mfko2gK_o;L_mn_`"
            A$ = A$ + "mfko2gK_o;L_mn_`mfko2gK_o;L_mn_`mfko2gK_o;L_mn_`mfko2gK_o;L_mn_`mfko2gK_o;L_mn_`mfko2gK_o;L_mn_`mfko"
            A$ = A$ + "2gK_o;L_mn_`mfko2gK_o;L_mn_`mfko2gK_o;L_mn_`mfko2gK_o;L_mn_`mfko2gK_o;L_mn_`mfko2gK_o;L_mn_`mfko2gK_"
            A$ = A$ + "o;L_mn_`mfko2gK_o;L_mn_`mfko2gK_o;L_mn_`mfko2gK_o;L_mn_`mfko2gK_o;L_mn_`mfko2gK_o;L_mn_`mfko2gK_o;L_"
            A$ = A$ + "mn_`mfko2gK_o;L_mn_`mfko2gK_o;L_mn_`mfko2gK_o;L_mn_`mfko2gK_o;L_mn_`mfko2gK_o;L_mn_`mfko2gK_o;L_mn_`"
            A$ = A$ + "mfko2gK_o;L_mn_`mfko2gK_o;L_mn_`mfko2gK_o;L_mn_`mfko2gK_o;L_mn_`mfko2gK_o;L_mn_`mfko2gK_o;L_mn_`mfko"
            A$ = A$ + "2gK_o;L_mn_`mfko2gK_o;L_mn_`mfko2gK_o;L_mn_`mfko2gK_o;L_mn_`mfko2gK_o;L_mn_`mfko2gK_o;L_mn_`mfko2gK_"
            A$ = A$ + "o;L_mn_`mfko2gK_o;L_mn_`mfko2gK_o;L_mno_k^koDolco3_jZo_kXSno^S>jok>jXo?m]gno8;\`oO8Q4noR8Rho;R8Roo8S"
            A$ = A$ + "<n?B5EdoG@15oCB8Ql?9Q4boRla7o;b7Ol_8OlaoRla7o;b7Ol_8OlaoRla7o;b7Ol_8OlaoRla7o;b7Ol_8OlaoRla7o;b7Ol_8"
            A$ = A$ + "OlaoRla7o;b7Ol_8OlaoRla7o;b7Ol_8OlaoRla7o;b7Ol_8OlaoRla7o;b7O\o6ITAlILa5oWa5GPO6GL1;0000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000P8Ol1^Rla7o;b7Ol_8OlaoRla7o;b7Ol_8OlaoRla7o;b7Ol_8OlaoRla7o;b7Ol_8OlaoRla7o;b7Ol_8OlaoRla7o;b7"
            A$ = A$ + "Ol_8OlaoRla7o;b7Ol_8OlaoRla7o;b7Ol_8OlaoS028oCB8QlO9R8boKP16o3C;]lOR6Fho=ZHRocHR8n_Q4>hobjJ[o;?k\o_k"
            A$ = A$ + "XSno^S>jok>jXo_kXSno^S>jooNjYoOl[_noa_njo7oj[oOl[_noa_njo7oj[oOl[_noa_njo7oj[oOl[_noa_njo7oj[oOl[_no"
            A$ = A$ + "a_njo7oj[oOl[_noa_njo7oj[oOl[_noa_njo7oj[oOl[_noa_njo7oj[oOl[_noa_njo7oj[oOl[_noa_njo7oj[oOl[_noa_nj"
            A$ = A$ + "o7oj[oOl[_noa_njo7oj[oOl[_noa_njo7oj[oOl[_noa_njo7oj[oOl[_noa_njo7oj[oOl[_noa_njo7oj[oOl[_noa_njo7oj"
            A$ = A$ + "[oOl[_noa_njo7oj[oOl[_noa_njo7oj[oOl[_noa_njo7oj[oOl[_noa_njo7oj[oOl[_noa_njo7oj[oOl[_noa_njo7oj[oOl"
            A$ = A$ + "[_noa_njo7oj[oOl[_noa_njo7oj[oOl[_noa_njo7oj[oOl[_noa_njo7oj[oOl[_noa_njo7oj[oOl[_noa_njo7oj[oOl[_no"
            A$ = A$ + "a_njo7oj[oOl[_noa_njo7oj[oOl[_noa_njo7oj[oOl[_noa_njo7oj[oOl[_noa_njo7oj[oOl[_noa_njo7oj[oOl[_noa_nj"
            A$ = A$ + "o7oj[oOl[_noa_njo7oj[oOl[_noa_njo7oj[oOl[_noa_njo7oj[oOl[_noa_njo7oj[oOl[_noa_njo7oj[oOl[_noa_njo7oj"
            A$ = A$ + "[oOl[_noa_njo7oj[oOl[_noa_njo7oj[oOl[_noa_njo7oj[oOl[_noa_njo7oj[oOl[_noa_njo7oj[oOl[_noa_njo7oj[oOl"
            A$ = A$ + "[_noa_njo3_jZo_kXSno^S>jok>jXo_kXSnodgNkoSl`2o?R5Bho<V8RocHR8n?T=bho9IDAoO15Dl?9Q4boT4B8o;b7Ol_8Olao"
            A$ = A$ + "Rla7o;b7Ol_8OlaoRla7o;b7Ol_8OlaoRla7o;b7Ol_8OlaoRla7o;b7Ol_8OlaoRla7o;b7Ol_8OlaoRla7o;b7Ol_8OlaoRla7"
            A$ = A$ + "o;b7Ol_8OlaoRla7o;b7Ol_8OlanKTA6aWa5GlO6GL1nILa5\000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000000000000000000000000000000000000000000Rla7h:b7Ol_8OlaoRla7o;b7Ol_8"
            A$ = A$ + "OlaoRla7o;b7Ol_8OlaoRla7o;b7Ol_8OlaoRla7o;b7Ol_8OlaoRla7o;b7Ol_8OlaoRla7o;b7Ol_8OlaoRla7o;b7Ol_8Olao"
            A$ = A$ + "Rla7o?28Pl?9Q4boU8R8o_16Hl?<]dbo9JHQogXR9n?S9Rho6BhPo;[[]n_l]cno^W>jokNjXo_kYSno^W>jok>jXo_kYSno^W>j"
            A$ = A$ + "okNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNj"
            A$ = A$ + "Xo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_k"
            A$ = A$ + "YSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno"
            A$ = A$ + "^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>j"
            A$ = A$ + "okNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNj"
            A$ = A$ + "Xo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_k"
            A$ = A$ + "YSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno"
            A$ = A$ + "^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^S>jokNjXo_kYSno^W>j"
            A$ = A$ + "oC_k]o?b3;lo8J8QocHR8n?S9Rho@f8SoWTA5mo5D@aoT4B8oCB8Ql_8OlaoRla7o;b7Ol_8OlaoRla7o;b7Ol_8OlaoRla7o;b7"
            A$ = A$ + "Ol_8OlaoRla7o;b7Ol_8OlaoRla7o;b7Ol_8OlaoRla7o;b7Ol_8OlaoRla7o;b7Ol_8OlaoRla7o;b7Ol_8OlaoRla7k_A6I4O6"
            A$ = A$ + "GLaoILa5hWa5G`20000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000008b7NP[8OhaoRlQ7o;b7Nl_8OhaoRlQ7o;b7Nl_8OhaoRlQ7o;b7Nl_8OhaoRlQ7"
            A$ = A$ + "o;b7Nl_8OhaoRlQ7o;b7Nl_8OhaoRlQ7o;b7Nl_8OhaoRlQ7o;b7Nl_8OhaoRlQ7o;b7Nlo8PlaoT428oGR8Qlo6HLao`d2;oWXQ"
            A$ = A$ + "5nOS:Vho<V8RoK8Q3n_\^fjobg>kokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_k"
            A$ = A$ + "YSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno"
            A$ = A$ + "^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>j"
            A$ = A$ + "okNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNj"
            A$ = A$ + "Xo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_k"
            A$ = A$ + "YSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno"
            A$ = A$ + "^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>j"
            A$ = A$ + "okNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNj"
            A$ = A$ + "Xo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo?m^gno8?\`oSHQ4n?S9Rho<V8Ro3IS<nOB"
            A$ = A$ + "6EdoG@a4oCB8Pl?9Q0boRlQ7o;b7Nl_8OhaoRlQ7o;b7Nl_8OhaoRlQ7o;b7Nl_8OhaoRlQ7o;b7Nl_8OhaoRlQ7o;b7Nl_8Ohao"
            A$ = A$ + "RlQ7o;b7Nl_8OhaoRlQ7o;b7Nl_8OhaoRlQ7o;b7Nl_8OhaoRlQ7o;b7N\o6ITAlILa5oWa5GPO6GL1;00000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00P8Oh1^RlQ7o;b7Nl_8OhaoRlQ7o;b7Nl_8OhaoRlQ7o;b7Nl_8OhaoRlQ7o;b7Nl_8OhaoRlQ7o;b7Nl_8OhaoRlQ7o;b7Nl_8"
            A$ = A$ + "OhaoRlQ7o;b7Nl_8OhaoRlQ7o;b7Nl_8OhaoS0b7oCB8PlO9R4boKPa5o3C;\lOR6Jho=ZXRocHR9n_Q4BhobjZ[o;Ok\o_kYSno"
            A$ = A$ + "^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>j"
            A$ = A$ + "okNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNj"
            A$ = A$ + "Xo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_k"
            A$ = A$ + "YSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno"
            A$ = A$ + "^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>j"
            A$ = A$ + "okNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNj"
            A$ = A$ + "Xo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_k"
            A$ = A$ + "YSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno"
            A$ = A$ + "^W>jokNjXo_kYSno^W>jokNjXo_kYSnodkNkoSl`3o?R5Jho<VHRocHR9n?T=fho9IDAoO15Cl?9Q0boT428o;b7Nl_8OhaoRlQ7"
            A$ = A$ + "o;b7Nl_8OhaoRlQ7o;b7Nl_8OhaoRlQ7o;b7Nl_8OhaoRlQ7o;b7Nl_8OhaoRlQ7o;b7Nl_8OhaoRlQ7o;b7Nl_8OhaoRlQ7o;b7"
            A$ = A$ + "Nl_8OhaoRlQ7o;b7Nl_8OhanKTA6aWa5GlO6GL1nILa5\0000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000000000000000000000000000000000QhQ7h6R7NlO8NhaoQhQ7o7R7NlO8Nhao"
            A$ = A$ + "QhQ7o7R7NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7"
            A$ = A$ + "o;b7Olo8P0boT4B8o[a5Glo;\`bo9JXQogXR:n?S9Vho6B8Qo;[[^n_l]cno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNj"
            A$ = A$ + "Xo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_k"
            A$ = A$ + "YSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno"
            A$ = A$ + "^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>j"
            A$ = A$ + "okNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNj"
            A$ = A$ + "Xo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_k"
            A$ = A$ + "YSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno"
            A$ = A$ + "^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>j"
            A$ = A$ + "okNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>jokNjXo_kYSno^W>joC_k"
            A$ = A$ + "]o?b3?lo8FXQocHR9n?S9Vho@fHSoSDA5m_5C<aoS028o?28PlO8NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7NlO8"
            A$ = A$ + "NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7k_A6I4O6GLao"
            A$ = A$ + "ILa5hWa5G`200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000004R7NPK8NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7"
            A$ = A$ + "NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7Nl_8OlaoS028oCB8Ql_6GLao_`2;o[XQ6n_S"
            A$ = A$ + ":Zho=VHRoO8Q4n_\^jjobgNkokNjYo_kYWno^WNjokNjYo_kYWno^WNjokNjYo_kYWno^WNjokNjYo_kYWno^WNjokNjYo_kYWno"
            A$ = A$ + "^WNjokNjYo_kYWno^WNjokNjYo_kYWno^WNjokNjYo_kYWno^WNjokNjYo_kYWno^WNjokNjYo_kYWno^WNjokNjYo_kYWno^WNj"
            A$ = A$ + "okNjYo_kYWno^WNjokNjYo_kYWno^WNjokNjYo_kYWno^WNjokNjYo_kYWno^WNjokNjYo_kYWno^WNjokNjYo_kYWno^WNjokNj"
            A$ = A$ + "Yo_kYWno^WNjokNjYo_kYWno^WNjokNjYo_kYWno^WNjokNjYo_kYWno^WNjokNjYo_kYWno^WNjokNjYo_kYWno^WNjokNjYo_k"
            A$ = A$ + "YWno^WNjokNjYo_kYWno^WNjokNjYo_kYWno^WNjokNjYo_kYWno^WNjokNjYo_kYWno^WNjokNjYo_kYWno^WNjokNjYo_kYWno"
            A$ = A$ + "^WNjokNjYo_kYWno^WNjokNjYo_kYWno^WNjokNjYo_kYWno^WNjokNjYo_kYWno^WNjokNjYo_kYWno^WNjokNjYo_kYWno^WNj"
            A$ = A$ + "okNjYo_kYWno^WNjokNjYo_kYWno^WNjokNjYo_kYWno^WNjokNjYo_kYWno^WNjokNjYo_kYWno^WNjokNjYo_kYWno^WNjokNj"
            A$ = A$ + "Yo_kYWno^WNjokNjYo_kYWno^WNjokNjYo_kYWno^WNjokNjYo_kYWno^WNjokNjYo_kYWno^WNjokNjYo_kYWno^WNjokNjYo_k"
            A$ = A$ + "YWno^WNjokNjYo_kYWno^WNjokNjYo_kYWno^WNjokNjYo_kYWno^WNjokNjYo?m^kno9?l`oWHQ6nOS9Vho=VHRo7IS=n?B5Edo"
            A$ = A$ + "F<a4o?28Plo8P0boQhQ7o7R7NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7"
            A$ = A$ + "o7R7NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7N\o6ITAlILa5oWa5GPO6GL1;000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000@8"
            A$ = A$ + "Nh1^QhQ7o7R7NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7NlO8Nhao"
            A$ = A$ + "QhQ7o7R7NlO8NhaoQhQ7o7R7NlO8NhaoRla7o?28Pl?9Q4boJLa5oo2;\l_R7Jho>^XRogXR9noQ5BhocnZ[o?Ok]ookYWno_WNj"
            A$ = A$ + "ooNjYookYWno_WNjooNjYookYWno_WNjooNjYookYWno_WNjooNjYookYWno_WNjooNjYookYWno_WNjooNjYookYWno_WNjooNj"
            A$ = A$ + "YookYWno_WNjooNjYookYWno_WNjooNjYookYWno_WNjooNjYookYWno_WNjooNjYookYWno_WNjooNjYookYWno_WNjooNjYook"
            A$ = A$ + "YWno_WNjooNjYookYWno_WNjooNjYookYWno_WNjooNjYookYWno_WNjooNjYookYWno_WNjooNjYookYWno_WNjooNjYookYWno"
            A$ = A$ + "_WNjooNjYookYWno_WNjooNjYookYWno_WNjooNjYookYWno_WNjooNjYookYWno_WNjooNjYookYWno_WNjooNjYookYWno_WNj"
            A$ = A$ + "ooNjYookYWno_WNjooNjYookYWno_WNjooNjYookYWno_WNjooNjYookYWno_WNjooNjYookYWno_WNjooNjYookYWno_WNjooNj"
            A$ = A$ + "YookYWno_WNjooNjYookYWno_WNjooNjYookYWno_WNjooNjYookYWno_WNjooNjYookYWno_WNjooNjYookYWno_WNjooNjYook"
            A$ = A$ + "YWno_WNjooNjYookYWno_WNjooNjYookYWno_WNjooNjYookYWno_WNjooNjYookYWno_WNjooNjYookYWno_WNjooNjYookYWno"
            A$ = A$ + "_WNjooNjYookYWno_WNjooNjYookYWno_WNjooNjYookYWno_WNjooNjYookYWno_WNjooNjYookYWno_WNjooNjYookYWno_WNj"
            A$ = A$ + "ooNjYookYWno_WNjooNjYookYWnoek^koW<a3oOR6Fho=ZHRogXR9nOT>fho8EDAoKa4Clo8P0boS028o7R7NlO8NhaoQhQ7o7R7"
            A$ = A$ + "NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7NlO8"
            A$ = A$ + "NhaoQhQ7o7R7NlO8NhanKTA6aWa5GlO6GL1nIHQ5\00000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000QhQ7h6R7NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7"
            A$ = A$ + "o7R7NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7o;b7"
            A$ = A$ + "Olo8P0boT4B8o[a5Glo;\`bo:NXQokhR:nOS:Vho7F8Qo?k[^nol^gno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYook"
            A$ = A$ + "ZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno"
            A$ = A$ + "_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Nj"
            A$ = A$ + "oo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^j"
            A$ = A$ + "YookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYook"
            A$ = A$ + "ZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno"
            A$ = A$ + "_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Nj"
            A$ = A$ + "oo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^j"
            A$ = A$ + "YookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[NjoGok^oOb"
            A$ = A$ + "4?lo9JHQogXR9nOS:VhoAjHSoSDA5m_5C<aoS028o?28PlO8NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7NlO8Nhao"
            A$ = A$ + "QhQ7o7R7NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7o7R7NlO8NhaoQhQ7k_A6I4O6GLaoILa5"
            A$ = A$ + "hWQ5F`2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000004R7MPK8NdaoQhA7o7R7MlO8NdaoQhA7o7R7MlO8NdaoQhA7o7R7MlO8NdaoQhA7o7R7MlO8"
            A$ = A$ + "NdaoQhA7o7R7MlO8NdaoQhA7o7R7MlO8NdaoQhA7o7R7MlO8NdaoQhA7o7R7Ml_8OhaoS0b7oCB8Pl_6GHao_`b:o[hQ7n_S;bho"
            A$ = A$ + "=ZXRoOHQ5no\_njockNkoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Nj"
            A$ = A$ + "oo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^j"
            A$ = A$ + "YookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYook"
            A$ = A$ + "ZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno"
            A$ = A$ + "_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Nj"
            A$ = A$ + "oo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^j"
            A$ = A$ + "YookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYook"
            A$ = A$ + "ZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno"
            A$ = A$ + "_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYoOm_kno9C<aoWXQ7nOS:Zho=ZXRo7YS>n?B5EdoF<a4"
            A$ = A$ + "o?28Olo8PlaoQhA7o7R7MlO8NdaoQhA7o7R7MlO8NdaoQhA7o7R7MlO8NdaoQhA7o7R7MlO8NdaoQhA7o7R7MlO8NdaoQhA7o7R7"
            A$ = A$ + "MlO8NdaoQhA7o7R7MlO8NdaoQhA7o7R7MlO8NdaoQhA7o7R7M\o6ITAlILa5oWQ5FPO6FH1;0000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000@8Nd1^"
            A$ = A$ + "QhA7o7R7MlO8NdaoQhA7o7R7MlO8NdaoQhA7o7R7MlO8NdaoQhA7o7R7MlO8NdaoQhA7o7R7MlO8NdaoQhA7o7R7MlO8NdaoQhA7"
            A$ = A$ + "o7R7MlO8NdaoQhA7o7R7MlO8NdaoRlQ7o?28Ol?9Q0boJLQ5oo2;[l_R7Nho>^8SogXR:noQ5Fhocnj[o?_k]ookZWno_[Njoo^j"
            A$ = A$ + "YookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYook"
            A$ = A$ + "ZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno"
            A$ = A$ + "_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Nj"
            A$ = A$ + "oo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^j"
            A$ = A$ + "YookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYook"
            A$ = A$ + "ZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno"
            A$ = A$ + "_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Nj"
            A$ = A$ + "oo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^j"
            A$ = A$ + "YookZWno_[Njoo^jYookZWnoeo^koW<a4oOR6Nho=ZXRogXR:nOT>jho8EDAoKa4Clo8PlaoS0b7o7R7MlO8NdaoQhA7o7R7MlO8"
            A$ = A$ + "NdaoQhA7o7R7MlO8NdaoQhA7o7R7MlO8NdaoQhA7o7R7MlO8NdaoQhA7o7R7MlO8NdaoQhA7o7R7MlO8NdaoQhA7o7R7MlO8Ndao"
            A$ = A$ + "QhA7o7R7MlO8NdanKTA6aWa5GlO6FH1nIHQ5\000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000000000000000000000000000000PdA7h2B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7"
            A$ = A$ + "Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o7R7Nl_8"
            A$ = A$ + "OlaoS028oWQ5Fl_;[\bo:NhQok8S<nOS:Zho7FHQo?k[_nol^gno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno"
            A$ = A$ + "_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Nj"
            A$ = A$ + "oo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^j"
            A$ = A$ + "YookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYook"
            A$ = A$ + "ZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno"
            A$ = A$ + "_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Nj"
            A$ = A$ + "oo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^j"
            A$ = A$ + "YookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYook"
            A$ = A$ + "ZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[Njoo^jYookZWno_[NjoGok^oOb4Clo"
            A$ = A$ + "9JhQogXR:nOS:ZhoAjXSoSDA5mO5C<aoRla7o;b7Ol?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7"
            A$ = A$ + "o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7k_A6I4O6FHaoIHQ5hWQ5"
            A$ = A$ + "F`20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000B7MP;8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8Mdao"
            A$ = A$ + "PdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7MlO8NhaoRla7o?28PlO6FHao^\b:o[hQ7n_S<bho=ZXR"
            A$ = A$ + "oOHQ5no\_njock^koo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^j"
            A$ = A$ + "ZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZook"
            A$ = A$ + "Z[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no"
            A$ = A$ + "_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^j"
            A$ = A$ + "oo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^j"
            A$ = A$ + "ZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZook"
            A$ = A$ + "Z[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no"
            A$ = A$ + "_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^j"
            A$ = A$ + "oo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZoOm_ono9C<aoWXQ7nOS:Zho=ZXRo7YS>n?B5EdoE<a4o;b7"
            A$ = A$ + "Ol_8OlaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8"
            A$ = A$ + "MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7M\o6ITAlIHQ5oWQ5FPO6FH1;00000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008Md1^PdA7"
            A$ = A$ + "o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7"
            A$ = A$ + "Ml?8MdaoPdA7o3B7Ml?8MdaoQhQ7o;b7Olo8P0boIHQ5okb:[l_R7Nho>^8SogXR:noQ5Fhocnj[o?_k^ookZ[no_[^joo^jZook"
            A$ = A$ + "Z[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no"
            A$ = A$ + "_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^j"
            A$ = A$ + "oo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^j"
            A$ = A$ + "ZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZook"
            A$ = A$ + "Z[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no"
            A$ = A$ + "_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^j"
            A$ = A$ + "oo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^j"
            A$ = A$ + "ZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZookZ[no_[^joo^jZook"
            A$ = A$ + "Z[no_[^joo^jZookZ[noeonkoW<a4oOR6Jho=ZXRogXR:nOT>jho8EDAoGa4Cl_8OlaoRla7o3B7Ml?8MdaoPdA7o3B7Ml?8Mdao"
            A$ = A$ + "PdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7"
            A$ = A$ + "o3B7Ml?8MdanKP16aWQ5FlO6FH1nIHQ5\0000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000000000000000000000PdA7h2B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8"
            A$ = A$ + "MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o7R7Nl_8Olao"
            A$ = A$ + "S028oWQ5Fl_;[\bo:NhQokhR;nOS:Zho7FHQo?k[_n?m_kno`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^j"
            A$ = A$ + "o3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3oj"
            A$ = A$ + "Zo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l"
            A$ = A$ + "[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no"
            A$ = A$ + "`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^j"
            A$ = A$ + "o3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3oj"
            A$ = A$ + "Zo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l"
            A$ = A$ + "[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no"
            A$ = A$ + "`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^jo3ojZo?l[[no`_^joK?l_o_b5Clo9JXQ"
            A$ = A$ + "ogXR:nOS:ZhoAjXSoSDA5mO5C<aoRla7o;b7Ol?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7"
            A$ = A$ + "Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7k_16H4O6FHaoIHQ5hWQ5F`20"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000B7MP;8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7"
            A$ = A$ + "o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7MlO8NhaoRla7o?28PlO6FHao^\b:o[hQ7n_S;^ho=ZXRoOHQ"
            A$ = A$ + "5no\_njodo^ko3ojZo?l[[no`_^jo3ojZo?l[[noacnjo;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l"
            A$ = A$ + "]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cno"
            A$ = A$ + "bg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>k"
            A$ = A$ + "o;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok"
            A$ = A$ + "\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l"
            A$ = A$ + "]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cno"
            A$ = A$ + "bg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>k"
            A$ = A$ + "o;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok"
            A$ = A$ + "\o_l]cnobg>ko;Ok\o_l]cnoacnjo3ojZo?l[[no`_^jo3ojZo_m`ono:G<aoWXQ6nOS:Zho=ZXRo7YS>n?B5EdoE<a4o;b7Ol_8"
            A$ = A$ + "OlaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7Ml?8Mdao"
            A$ = A$ + "PdA7o3B7Ml?8MdaoPdA7o3B7Ml?8MdaoPdA7o3B7M\o6HPAlIHQ5oWQ5FPO6FH1;000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000008M`1^Pd17o3B7"
            A$ = A$ + "Ll?8M`aoPd17o3B7Ll?8M`aoPd17o3B7Ll?8M`aoPd17o3B7Ll?8M`aoPd17o3B7Ll?8M`aoPd17o3B7Ll?8M`aoPd17o3B7Ll?8"
            A$ = A$ + "M`aoPd17o3B7Ll?8M`aoQhA7o;b7Nlo8PlaoIHQ5okb:ZloR7Nho?^8SokXR:n?R5Fhodnj[oCok^o?l[[no`_^jo3ojZo?l[[no"
            A$ = A$ + "acnjo[NiToohNgmoTo]goCngNo?iOkmoTo]goCngNo?iOkmoTo]goCngNo?iOkmoTo]goCngNo?iOkmoTo]goCngNo?iOkmoTo]g"
            A$ = A$ + "oCngNo?iOkmoTo]goCngNo?iOkmoTo]goCngNo?iOkmoTo]goCngNo?iOkmoTo]goCngNo?iOkmoTo]goCngNo?iOkmoTo]goCng"
            A$ = A$ + "No?iOkmoTo]goCngNo?iOkmoTo]goCngNo?iOkmoTo]goCngNo?iOkmoTo]goCngNo?iOkmoTo]goCngNo?iOkmoTo]goCngNo?i"
            A$ = A$ + "OkmoTo]goCngNo?iOkmoTo]goCngNo?iOkmoTo]goCngNo?iOkmoTo]goCngNo?iOkmoTo]goCngNo?iOkmoTo]goCngNo?iOkmo"
            A$ = A$ + "To]goCngNo?iOkmoTo]goCngNo?iOkmoTo]goCngNo?iOkmoTo]goCngNo?iOkmoTo]goCngNo?iOkmoTo]goCngNo?iOkmoTo]g"
            A$ = A$ + "oCngNo?iOkmoTo]goCngNo?iOkmoTo]goCngNo?iOkmoTo]goCngNo?iOkmoTo]goCngNo?iOkmoTo]goCngNo?iOkmoTo]goCng"
            A$ = A$ + "No?iOkmoTo]goCngNo?iOkmoTo]goCngNo?iOkmoTo]goCngNo?iOkmoTo]goCngNo?iOkmoTo]goCngNo?iOkmoTo]goCngNo?i"
            A$ = A$ + "OkmoTo]goCngNo?iOkmoTo]goCngNo?iOkmoTo]goCngNo?iOkmoTo]goCngNo?iOkmoTo]goCngNo?iOkmoSkMgoW>iSoOl\_no"
            A$ = A$ + "`_^jo3ojZo?l[[nof3oko[La4o_R6Jho>ZXRokXR:n_T>jho8E4AoGa4Bl_8OhaoRlQ7o3B7Ll?8M`aoPd17o3B7Ll?8M`aoPd17"
            A$ = A$ + "o3B7Ll?8M`aoPd17o3B7Ll?8M`aoPd17o3B7Ll?8M`aoPd17o3B7Ll?8M`aoPd17o3B7Ll?8M`aoPd17o3B7Ll?8M`aoPd17o3B7"
            A$ = A$ + "Ll?8M`anKP16aWQ5FlO6FH1nIHQ5\00000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000O`17hn17Llo7L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`ao"
            A$ = A$ + "O`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17o3B7MlO8NhaoRla7"
            A$ = A$ + "oSQ5FlO;ZXbo;NhQo39S<n_S:Zho8FHQoCk[_n?m_kno`_^jo3ojZo?l[[no`_^joG?l_oOc8OloS2jWoSJYTn?ZUBjoXF:YoSJY"
            A$ = A$ + "Tn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?Z"
            A$ = A$ + "UBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjo"
            A$ = A$ + "XF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:Y"
            A$ = A$ + "oSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJY"
            A$ = A$ + "Tn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?Z"
            A$ = A$ + "UBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjo"
            A$ = A$ + "XF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:Y"
            A$ = A$ + "oSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoCJXPn?a0okockNko3ojZo?l[[no`_^joK?l_o_b5Clo:JXQokXR"
            A$ = A$ + ":n_S:ZhoBjXSoS4A4m?5B8aoQhQ7o7R7Nlo7L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17oo17Llo7"
            A$ = A$ + "L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17k_16H4O6FHaoIHQ5hWQ5F`200000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000l17LPk7L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17oo17"
            A$ = A$ + "Llo7L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17oo17Ll?8MdaoQhQ7o;b7Ol?6FHao]XR:o_8R7n?T=bho>^XRoSXQ5n?]"
            A$ = A$ + "`njodonko3oj[o?l[_no`_njo3oj[oOm`ono=S<bo?:XPn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjo"
            A$ = A$ + "XF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:Y"
            A$ = A$ + "oSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJY"
            A$ = A$ + "Tn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?Z"
            A$ = A$ + "UBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjo"
            A$ = A$ + "XF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:Y"
            A$ = A$ + "oSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJY"
            A$ = A$ + "Tn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?ZUBjoXF:YoSJYTn?Z"
            A$ = A$ + "UBjoXF:YoSJYTn?YQ6jo43l_o?_k]o?l[_no`_njo3oj[o_m`3oo:GLao[hQ6n_S;Zho>^XRo;iS>n?B4AdoD8Q4o7R7NlO8Nhao"
            A$ = A$ + "O`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17"
            A$ = A$ + "oo17Llo7L`aoO`17oo17Llo7L`aoO`17oo17L\o6HPAlIHQ5oWQ5FPO6FH1;0000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000`7L`1^O`17oo17Llo7"
            A$ = A$ + "L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`ao"
            A$ = A$ + "O`17oo17Llo7L`aoPdA7o7R7Nl_8OlaoHHQ5ogR:ZloR8Nho@f8SokhR:n?R6Fhod2k[oC?l_o?l\_no`cnjo3?k[o?l\_noac>k"
            A$ = A$ + "o[NiUoohOkmoTomgoCngOo?iOomoTomgoCngOo?iOomoTomgoCngOo?iOomoTomgoCngOo?iOomoTomgoCngOo?iOomoTomgoCng"
            A$ = A$ + "Oo?iOomoTomgoCngOo?iOomoTomgoCngOo?iOomoTomgoCngOo?iOomoTomgoCngOo?iOomoTomgoCngOo?iOomoTomgoCngOo?i"
            A$ = A$ + "OomoTomgoCngOo?iOomoTomgoCngOo?iOomoTomgoCngOo?iOomoTomgoCngOo?iOomoTomgoCngOo?iOomoTomgoCngOo?iOomo"
            A$ = A$ + "TomgoCngOo?iOomoTomgoCngOo?iOomoTomgoCngOo?iOomoTomgoCngOo?iOomoTomgoCngOo?iOomoTomgoCngOo?iOomoTomg"
            A$ = A$ + "oCngOo?iOomoTomgoCngOo?iOomoTomgoCngOo?iOomoTomgoCngOo?iOomoTomgoCngOo?iOomoTomgoCngOo?iOomoTomgoCng"
            A$ = A$ + "Oo?iOomoTomgoCngOo?iOomoTomgoCngOo?iOomoTomgoCngOo?iOomoTomgoCngOo?iOomoTomgoCngOo?iOomoTomgoCngOo?i"
            A$ = A$ + "OomoTomgoCngOo?iOomoTomgoCngOo?iOomoTomgoCngOo?iOomoTomgoCngOo?iOomoTomgoCngOo?iOomoTomgoCngOo?iOomo"
            A$ = A$ + "TomgoCngOo?iOomoTomgoCngOo?iOomoTomgoCngOo?iOomoTomgoCngOo?iOomoTomgoCngOo?iOomoSo]goW>iToOl\cno`cnj"
            A$ = A$ + "o3?k[o?l\_nof7?lo[la5o_R7Jho>^XRokhR:n_T?jho8E4AoCQ4BlO8NhaoQhQ7oo17Llo7L`aoO`17oo17Llo7L`aoO`17oo17"
            A$ = A$ + "Llo7L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17oo17Llo7"
            A$ = A$ + "L`anKP16aWQ5FlO6FH1nIHQ5\000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000000000000000000O`17hn17Llo7L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17"
            A$ = A$ + "oo17Llo7L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17o3B7MlO8NhaoRla7oSQ5"
            A$ = A$ + "FlO;ZXbo;R8Ro3IS=n_S;^ho8JXQoC;\`n?m`ono`cnjo3?k[o?l\_no`cnjo3?k[oOl]cnobkNko;_k]o_l^gnobkNko;_k]o_l"
            A$ = A$ + "^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gno"
            A$ = A$ + "bkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNk"
            A$ = A$ + "o;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k"
            A$ = A$ + "]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l"
            A$ = A$ + "^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gno"
            A$ = A$ + "bkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNk"
            A$ = A$ + "o;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k"
            A$ = A$ + "]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]oOl]cno`cnjo3?k[o?l\_no`cnjoKOl`o_b7Glo:NhQokhR;n_S"
            A$ = A$ + ";^hoBnhSoSDA5m?5B8aoQhQ7o7R7Nlo7L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`ao"
            A$ = A$ + "O`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17k_16H4O6FHaoIHQ5hWQ5F`2000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000l17LPk7L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17oo17Llo7"
            A$ = A$ + "L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17oo17Ll?8MdaoQhQ7o;b7Ol?6FHao^XR:oc8R8nOT=fho?^hRo[XQ6n?]`2ko"
            A$ = A$ + "d3oko3?k[o?l\_no`cnjo3?k[o?l\_no`cnjo3?k[o?l\_no`cnjo3?k[o?l\_no`cnjo3?k[o?l\_no`cnjo3?k[o?l\_no`cnj"
            A$ = A$ + "o3?k[o?l\_no`cnjo3?k[o?l\_no`cnjo3?k[o?l\_no`cnjo3?k[o?l\_no`cnjo3?k[o?l\_no`cnjo3?k[o?l\_no`cnjo3?k"
            A$ = A$ + "[o?l\_no`cnjo3?k[o?l\_no`cnjo3?k[o?l\_no`cnjo3?k[o?l\_no`cnjo3?k[o?l\_no`cnjo3?k[o?l\_no`cnjo3?k[o?l"
            A$ = A$ + "\_no`cnjo3?k[o?l\_no`cnjo3?k[o?l\_no`cnjo3?k[o?l\_no`cnjo3?k[o?l\_no`cnjo3?k[o?l\_no`cnjo3?k[o?l\_no"
            A$ = A$ + "`cnjo3?k[o?l\_no`cnjo3?k[o?l\_no`cnjo3?k[o?l\_no`cnjo3?k[o?l\_no`cnjo3?k[o?l\_no`cnjo3?k[o?l\_no`cnj"
            A$ = A$ + "o3?k[o?l\_no`cnjo3?k[o?l\_no`cnjo3?k[o?l\_no`cnjo3?k[o?l\_no`cnjo3?k[o?l\_no`cnjo3?k[o?l\_no`cnjo3?k"
            A$ = A$ + "[o?l\_no`cnjo3?k[o?l\_no`cnjo3?k[o?l\_no`cnjo3?k[o?l\_no`cnjo3?k[o?l\_no`cnjo3?k[o?l\_no`cnjo3?k[o?l"
            A$ = A$ + "\_no`cnjo3?k[o?l\_no`cnjo3?k[o?l\_no`cnjo3?k[o?l\_no`cnjo3?k[o?l\_no`cnjo3?k[o?l\_no`cnjo3?k[o?l\_no"
            A$ = A$ + "`cnjo3?k[o?l\_no`cnjo3?k[o?l\_no`cnjo3?k[oOma3oo;OLao_hQ7noS;^ho@^hRo?iS?n?B5EdoD8Q4o7R7NlO8NhaoO`17"
            A$ = A$ + "oo17Llo7L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17oo17Llo7L`aoO`17oo17"
            A$ = A$ + "Llo7L`aoO`17oo17Llo7L`aoO`17oo17L\o6HPAlIHQ5oWQ5FPO6FH1;00000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000000000000000000000000000000000000000000000000`7L\1^O`a6oo17Klo7L\ao"
            A$ = A$ + "O`a6oo17Klo7L\aoO`a6oo17Klo7L\aoO`a6oo17Klo7L\aoO`a6oo17Klo7L\aoO`a6oo17Klo7L\aoO`a6oo17Klo7L\aoO`a6"
            A$ = A$ + "oo17Klo7L\aoPd17o7R7Ml_8OhaoHHA5okR:Zl?S8RhoAfHSoohR;n_R6Jhoe2;\oG?l_oOl\_noacnjo7?k[oOl\_noacnjo7?k"
            A$ = A$ + "[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl"
            A$ = A$ + "\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_no"
            A$ = A$ + "acnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnj"
            A$ = A$ + "o7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k"
            A$ = A$ + "[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl"
            A$ = A$ + "\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_no"
            A$ = A$ + "acnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnj"
            A$ = A$ + "o7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k"
            A$ = A$ + "[oOl\_nof7?lo_la5ooR7Nho?^hRo3iR;n?U?nho8EDAoCQ4BlO8NdaoQhA7oo17Klo7L\aoO`a6oo17Klo7L\aoO`a6oo17Klo7"
            A$ = A$ + "L\aoO`a6oo17Klo7L\aoO`a6oo17Klo7L\aoO`a6oo17Klo7L\aoO`a6oo17Klo7L\aoO`a6oo17Klo7L\aoO`a6oo17Klo7L\an"
            A$ = A$ + "KPa5aWQ5FlO6FH1nIHQ5\0000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000000000N\a6hja6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6"
            A$ = A$ + "Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oo17Ll?8MdaoQhQ7oOA5ElO;"
            A$ = A$ + "ZXbo<R8Ro7IS=noS;^ho9JXQoG;\`nOm`onoacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_no"
            A$ = A$ + "acnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnj"
            A$ = A$ + "o7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k"
            A$ = A$ + "[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl"
            A$ = A$ + "\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_no"
            A$ = A$ + "acnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnj"
            A$ = A$ + "o7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k"
            A$ = A$ + "[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl"
            A$ = A$ + "\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjo7?k[oOl\_noacnjoOOl`oob7Glo;NhQoohR;n?T;^ho"
            A$ = A$ + "DnhSoODA5mo4B8aoPdA7o3B7Ml_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6"
            A$ = A$ + "oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6k[a5G4O6FHaoIHQ5hWQ5F`20000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000ha6KP[7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\ao"
            A$ = A$ + "N\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Klo7L`aoPdA7o7R7Nlo5EDao]\R:ocHR8nOT>fho?bhRoWhQ6nO]a2koe3?l"
            A$ = A$ + "o7?k\oOl\cnoac>ko7?k\oOl\cnoac>ko7?k\oOl\cnoac>ko7?k\oOl\cnoac>ko7?k\oOl\cnoac>ko7?k\oOl\cnoac>ko7?k"
            A$ = A$ + "\oOl\cnoac>ko7?k\oOl\cnoac>ko7?k\oOl\cnoac>ko7?k\oOl\cnoac>ko7?k\oOl\cnoac>ko7?k\oOl\cnoac>ko7?k\oOl"
            A$ = A$ + "\cnoac>ko7?k\oOl\cnoac>ko7?k\oOl\cnoac>ko7?k\oOl\cnoac>ko7?k\oOl\cnoac>ko7?k\oOl\cnoac>ko7?k\oOl\cno"
            A$ = A$ + "ac>ko7?k\oOl\cnoac>ko7?k\oOl\cnoac>ko7?k\oOl\cnoac>ko7?k\oOl\cnoac>ko7?k\oOl\cnoac>ko7?k\oOl\cnoac>k"
            A$ = A$ + "o7?k\oOl\cnoac>ko7?k\oOl\cnoac>ko7?k\oOl\cnoac>ko7?k\oOl\cnoac>ko7?k\oOl\cnoac>ko7?k\oOl\cnoac>ko7?k"
            A$ = A$ + "\oOl\cnoac>ko7?k\oOl\cnoac>ko7?k\oOl\cnoac>ko7?k\oOl\cnoac>ko7?k\oOl\cnoac>ko7?k\oOl\cnoac>ko7?k\oOl"
            A$ = A$ + "\cnoac>ko7?k\oOl\cnoac>ko7?k\oOl\cnoac>ko7?k\oOl\cnoac>ko7?k\oOl\cnoac>ko7?k\oOl\cnoac>ko7?k\oOl\cno"
            A$ = A$ + "ac>ko7?k\oOl\cnoac>ko7?k\oOl\cnoac>ko7?k\oOl\cnoac>ko7?k\oOl\cnoac>ko7?k\oOl\cnoac>ko7?k\oOl\cnoac>k"
            A$ = A$ + "o7?k\oOl\cnoac>ko7?k\oOl\cnoac>ko7?k\ooma7oo;Olao_8R7noS<^ho@fhRoC9T?noA5EdoC8Q4o3B7Ml?8MdaoN\a6oka6"
            A$ = A$ + "Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7"
            A$ = A$ + "K\aoN\a6oka6Kl_7K\aoN\a6oka6K\_6GLAlIHQ5oWQ5FPO6FH1;000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000000000000000000000000000000000000000P7K\1^N\a6oka6Kl_7K\aoN\a6"
            A$ = A$ + "oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6"
            A$ = A$ + "Kl_7K\aoO`17o3B7MlO8NhaoGDA5ogb:[l?S9VhoAjXSoo8S<nOR7Nhoe6K\oGOl`oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl"
            A$ = A$ + "]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cno"
            A$ = A$ + "ag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>k"
            A$ = A$ + "o7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok"
            A$ = A$ + "\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl"
            A$ = A$ + "]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cno"
            A$ = A$ + "ag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>k"
            A$ = A$ + "o7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok"
            A$ = A$ + "\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl"
            A$ = A$ + "]cnog;Olo_<b7ooR8Rho?b8So3IS<n?U@2io7EDAo?Q4Bl?8MdaoPdA7oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\ao"
            A$ = A$ + "N\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\anJLa5"
            A$ = A$ + "aWQ5FlO6FH1nIHQ5\00000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000N\a6hja6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7"
            A$ = A$ + "K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oo17Ll?8MdaoQhQ7oOA5ElO;[\bo"
            A$ = A$ + "<VHRo7YS>noS<bho9NhQoGK\anOma3ooag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>k"
            A$ = A$ + "o7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok"
            A$ = A$ + "\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl"
            A$ = A$ + "]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cno"
            A$ = A$ + "ag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>k"
            A$ = A$ + "o7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok"
            A$ = A$ + "\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl"
            A$ = A$ + "]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cno"
            A$ = A$ + "ag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>koO_laoob8Olo;R8Roo8S<n?T=fhoD29T"
            A$ = A$ + "oODA5mo4B8aoPdA7o3B7Ml_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6"
            A$ = A$ + "Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6k[a5G4O6FHaoIHQ5hWQ5F`200000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000ha6KP[7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6"
            A$ = A$ + "oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Klo7L`aoPdA7o7R7Nlo5EDao]\b:ocHR9nOT>jho?b8SoWhQ7nO]a6koe7?lo7Ok"
            A$ = A$ + "\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl"
            A$ = A$ + "]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cno"
            A$ = A$ + "ag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>k"
            A$ = A$ + "o7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok"
            A$ = A$ + "\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl"
            A$ = A$ + "]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cno"
            A$ = A$ + "ag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>k"
            A$ = A$ + "o7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok"
            A$ = A$ + "\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oomb7oo;Slao_8R8noS<bho@fHSoC9TAnoA5EdoC8Q4o3B7Ml?8MdaoN\a6oka6Kl_7"
            A$ = A$ + "K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\aoN\a6oka6Kl_7K\ao"
            A$ = A$ + "N\a6oka6Kl_7K\aoN\a6oka6K\_6GLAlIHQ5oWQ5FPO6FH1;0000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000P7KX1^N\Q6oka6Jl_7KXaoN\Q6oka6"
            A$ = A$ + "Jl_7KXaoN\Q6oka6Jl_7KXaoN\Q6oka6Jl_7KXaoN\Q6oka6Jl_7KXaoN\Q6oka6Jl_7KXaoN\Q6oka6Jl_7KXaoN\Q6oka6Jl_7"
            A$ = A$ + "KXaoO`a6o3B7LlO8NdaoGD15ogb:Zl?S9VhoAjXSoo8S<nOR7Nhoe6K\oGOl`oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cno"
            A$ = A$ + "ag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>k"
            A$ = A$ + "o7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok"
            A$ = A$ + "\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl"
            A$ = A$ + "]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cno"
            A$ = A$ + "ag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>k"
            A$ = A$ + "o7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok"
            A$ = A$ + "\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl"
            A$ = A$ + "]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cno"
            A$ = A$ + "g;Olo_<b7ooR8Rho?b8So3IS=n?UA6io7E4Ao?Q4Al?8M`aoPd17oka6Jl_7KXaoN\Q6oka6Jl_7KXaoN\Q6oka6Jl_7KXaoN\Q6"
            A$ = A$ + "oka6Jl_7KXaoN\Q6oka6Jl_7KXaoN\Q6oka6Jl_7KXaoN\Q6oka6Jl_7KXaoN\Q6oka6Jl_7KXaoN\Q6oka6Jl_7KXanJLa5aWQ5"
            A$ = A$ + "FlO6FH1nIHQ5\000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000000MXQ6hfQ6JlO7JXaoMXQ6ogQ6JlO7JXaoMXQ6ogQ6JlO7JXaoMXQ6ogQ6JlO7JXao"
            A$ = A$ + "MXQ6ogQ6JlO7JXaoMXQ6ogQ6JlO7JXaoMXQ6ogQ6JlO7JXaoMXQ6ogQ6JlO7JXaoMXQ6oka6Klo7L`aoPdA7oK15Dl?;ZXbo<VHR"
            A$ = A$ + "o7YS>noS<bho9NhQoGK\anOma3ooag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok"
            A$ = A$ + "\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl"
            A$ = A$ + "]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cno"
            A$ = A$ + "ag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>k"
            A$ = A$ + "o7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok"
            A$ = A$ + "\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl"
            A$ = A$ + "]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cno"
            A$ = A$ + "ag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>k"
            A$ = A$ + "o7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>ko7Ok\oOl]cnoag>koO_laoob8Olo;R8Roo8S<n?T=fhoD6IToO4A"
            A$ = A$ + "4mo4A4aoO`17oo17LlO7JXaoMXQ6ogQ6JlO7JXaoMXQ6ogQ6JlO7JXaoMXQ6ogQ6JlO7JXaoMXQ6ogQ6JlO7JXaoMXQ6ogQ6JlO7"
            A$ = A$ + "JXaoMXQ6ogQ6JlO7JXaoMXQ6ogQ6JlO7JXaoMXQ6ogQ6JlO7JXaoMXQ6k[a5G4O6FHaoIHQ5hWQ5F`2000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0dQ6JPK7JXaoMXQ6ogQ6JlO7JXaoMXQ6ogQ6JlO7JXaoMXQ6ogQ6JlO7JXaoMXQ6ogQ6JlO7JXaoMXQ6ogQ6JlO7JXaoMXQ6ogQ6"
            A$ = A$ + "JlO7JXaoMXQ6ogQ6JlO7JXaoMXQ6ogQ6Jl_7K\aoO`17o3B7Ml_5D@ao\XR:ocHR9nOT>jho?b8SoWhQ7nO]a6kof7?lo;Ok\o_l"
            A$ = A$ + "]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cno"
            A$ = A$ + "bg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>k"
            A$ = A$ + "o;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok"
            A$ = A$ + "\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l"
            A$ = A$ + "]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cno"
            A$ = A$ + "bg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>k"
            A$ = A$ + "o;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok"
            A$ = A$ + "\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o_l"
            A$ = A$ + "]cnobg>ko;Ok\o_l]cnobg>ko;Ok\o?nb7oo<Slao_8R8noS<bho@fHSoCITAnoA4AdoC4A4oo17Llo7L`aoMXQ6ogQ6JlO7JXao"
            A$ = A$ + "MXQ6ogQ6JlO7JXaoMXQ6ogQ6JlO7JXaoMXQ6ogQ6JlO7JXaoMXQ6ogQ6JlO7JXaoMXQ6ogQ6JlO7JXaoMXQ6ogQ6JlO7JXaoMXQ6"
            A$ = A$ + "ogQ6JlO7JXaoMXQ6ogQ6J\_6GLAlIHQ5oWQ5FPO6FH1;00000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000000000000000000000000000000000000@7JX1^MXQ6ogQ6JlO7JXaoMXQ6ogQ6JlO7"
            A$ = A$ + "JXaoMXQ6ogQ6JlO7JXaoMXQ6ogQ6JlO7JXaoMXQ6ogQ6JlO7JXaoMXQ6ogQ6JlO7JXaoMXQ6ogQ6JlO7JXaoMXQ6ogQ6JlO7JXao"
            A$ = A$ + "N\a6oo17Ll?8MdaoF@15ocR:Zl?S9VhoAjXSoo8S<nOR6Nhoe:K\oK_lao_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNk"
            A$ = A$ + "o;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k"
            A$ = A$ + "]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l"
            A$ = A$ + "^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gno"
            A$ = A$ + "bkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNk"
            A$ = A$ + "o;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k"
            A$ = A$ + "]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l"
            A$ = A$ + "^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gno"
            A$ = A$ + "bkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnohC_l"
            A$ = A$ + "oc<b8ooR8Rho?b8So3IS=n?UA6io7A4Ao?A4Alo7L`aoO`17ogQ6JlO7JXaoMXQ6ogQ6JlO7JXaoMXQ6ogQ6JlO7JXaoMXQ6ogQ6"
            A$ = A$ + "JlO7JXaoMXQ6ogQ6JlO7JXaoMXQ6ogQ6JlO7JXaoMXQ6ogQ6JlO7JXaoMXQ6ogQ6JlO7JXaoMXQ6ogQ6JlO7JXanJLa5aWQ5FlO6"
            A$ = A$ + "FH1nIHQ5\0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000MXQ6hfQ6JlO7JXaoMXQ6ogQ6Jl?7ITaoLTA6ogQ6J@O7JX1lMXQ6`gQ6J0O7JX1lMXQ6"
            A$ = A$ + "`gQ6J0O7JX1lMXQ6`gQ6J0O7JX1lMXQ6igQ6JlO7JXaoMXQ6ogQ6JlO7JXaoMXQ6oka6Klo7L`aoPdA7oK15Dl?;ZXbo=VHRo;YS"
            A$ = A$ + ">n?T<bho:JhQoK[\an_mb7oobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l"
            A$ = A$ + "^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gno"
            A$ = A$ + "bkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNk"
            A$ = A$ + "o;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k"
            A$ = A$ + "]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l"
            A$ = A$ + "^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gno"
            A$ = A$ + "bkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNk"
            A$ = A$ + "o;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k"
            A$ = A$ + "]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNko;_k]o_l^gnobkNkoS?mbo?c8Slo<R8Ro39S<nOT=fhoE6IToO4A4mo4"
            A$ = A$ + "A4aoO`17oo17LlO7JXaoMXQ6ogQ6JlO7JXaoMXQ6ogQ6JlO7JXaoLTA6ocA6IlO7JX1mMXQ6`gQ6J0O7JX1lMXQ6`gQ6J0O7JX1l"
            A$ = A$ + "MXQ6`gQ6J0O7JX1lMXQ6`gQ6JTO7JXaoMXQ6ogQ6JlO7JXaoMXQ6k[a5G4O6FHaoIHQ5hWQ5F`20000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000dQ6"
            A$ = A$ + "JPK7JXaoMXQ6ogQ6Jl?7ITao?h@3og03;l_4A0aDLTA6?`A6Il07ITa3LTA6?`A6Il07ITa3LTA6?`A6Il07ITa3MXQ6?dQ6J8J7"
            A$ = A$ + "JXaoMXQ6ogQ6JlO7JXaoMXQ6ogQ6Jl_7K\aoO`17o3B7Ml_5D@ao\XR:ogHR9n_T>jho@b8So[XQ7no]c:kohColoC?l_o?m`ono"
            A$ = A$ + "d3okoC?l_o?m`onod3okoC?l_o?m`onod3okoC?l_o?m`onod3okoC?l_o?m`onod3okoC?l_o?m`onod3okoC?l_o?m`onod3ok"
            A$ = A$ + "oC?l_o?m`onod3okoC?l_o?m`onod3okoC?l_o?m`onod3okoC?l_o?m`onod3okoC?l_o?m`onod3okoC?l_o?m`onod3okoC?l"
            A$ = A$ + "_o?m`onod3okoC?l_o?m`onod3okoC?l_o?m`onod3okoC?l_o?m`onod3okoC?l_o?m`onod3okoC?l_o?m`onod3okoC?l_o?m"
            A$ = A$ + "`onod3okoC?l_o?m`onod3okoC?l_o?m`onod3okoC?l_o?m`onod3okoC?l_o?m`onod3okoC?l_o?m`onod3okoC?l_o?m`ono"
            A$ = A$ + "d3okoC?l_o?m`onod3okoC?l_o?m`onod3okoC?l_o?m`onod3okoC?l_o?m`onod3okoC?l_o?m`onod3okoC?l_o?m`onod3ok"
            A$ = A$ + "oC?l_o?m`onod3okoC?l_o?m`onod3okoC?l_o?m`onod3okoC?l_o?m`onod3okoC?l_o?m`onod3okoC?l_o?m`onod3okoC?l"
            A$ = A$ + "_o?m`onod3okoC?l_o?m`onod3okoC?l_o?m`onod3okoC?l_o?m`onod3okoC?l_o?m`onod3okoC?l_o?m`onod3okoC?l_o?m"
            A$ = A$ + "`onod3okoC?l_o?m`onod3okoC?l_o?m`onod3okoC?l_o?m`onod3okoC?l_o?m`onod3okoC?l_o?m`onod3okoC?l_o?m`ono"
            A$ = A$ + "d3okoC?l_o?m`onod3okoC?l_o_nfCoo=WLboc8R8n?T<bhoAfHSoGITAnoA4AdoC4A4oo17Llo7L`aoMXQ6ogQ6JlO7JXaoMXQ6"
            A$ = A$ + "ogQ6JlO7JXaoLXQ6o714?lO3<\`oB414CaA6Il07ITa3LTA6?`A6Il07ITa3LTA6?`A6Il07ITa3LTA6?dQ6Jl@7JXQXMXQ6ogQ6"
            A$ = A$ + "JlO7JXaoMXQ6ogQ6J\_6GLAlIHQ5oWQ5FPO6FH1;000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000007IT1^LTA6ocA6Il?7ITaoKP16ok@3<lO3<\`o"
            A$ = A$ + ":T0251000000000000000000000000000000000000000000000000000007ITQVLTA6ocA6Il?7ITaoLTA6ocA6Il?7ITaoMXQ6"
            A$ = A$ + "oka6Klo7L`aoF<a4o_B:YlOS9VhoBjXSo39S<n_R6Nhod2k[o3?k[o?kXOno\Snioc>jWo?kXOno\Snioc>jWo?kXOno\Snioc>j"
            A$ = A$ + "Wo?kXOno\Snioc>jWo?kXOno\Snioc>jWo?kXOno\Snioc>jWo?kXOno\Snioc>jWo?kXOno\Snioc>jWo?kXOno\Snioc>jWo?k"
            A$ = A$ + "XOno\Snioc>jWo?kXOno\Snioc>jWo?kXOno\Snioc>jWo?kXOno\Snioc>jWo?kXOno\Snioc>jWo?kXOno\Snioc>jWo?kXOno"
            A$ = A$ + "\Snioc>jWo?kXOno\Snioc>jWo?kXOno\Snioc>jWo?kXOno\Snioc>jWo?kXOno\Snioc>jWo?kXOno\Snioc>jWo?kXOno\Sni"
            A$ = A$ + "oc>jWo?kXOno\Snioc>jWo?kXOno\Snioc>jWo?kXOno\Snioc>jWo?kXOno\Snioc>jWo?kXOno\Snioc>jWo?kXOno\Snioc>j"
            A$ = A$ + "Wo?kXOno\Snioc>jWo?kXOno\Snioc>jWo?kXOno\Snioc>jWo?kXOno\Snioc>jWo?kXOno\Snioc>jWo?kXOno\Snioc>jWo?k"
            A$ = A$ + "XOno\Snioc>jWo?kXOno\Snioc>jWo?kXOno\Snioc>jWo?kXOno\Snioc>jWo?kXOno\Snioc>jWo?kXOno\Snioc>jWo?kXOno"
            A$ = A$ + "\Snioc>jWo?kXOno\Snioc>jWo?kXOno\Snioc>jWo?kXOno\Snioc>jWo?kXOno\Snioc>jWo?kXOno\Snioc>jWo?kXOno\Sni"
            A$ = A$ + "oc>jWo?kXOno\Snioc>jWo?kXOno\Snioc>jWo?kXOno\Snioc>jWo?kXOno\Snioc>jWo?kXOno\Snioc>jWo?kXOnobk>koSl`"
            A$ = A$ + "3o?S8Rho@b8So7IS=nOUA6io6A4Ao714@l_7K\aoN\a6ocA6Il?7ITaoLTA6ocA6Il?7ITaoLTA6ocA6Il?4?h`o=``2o[@28D40"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000LTA6JbA6Il?7ITaoLTA6ocA6Il?7ITanJLa5aWQ5FlO6FH1n"
            A$ = A$ + "HDA5\00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000LTA6hbA6Il?7ITaoLTA6o_16Hl_3=``o;X@2oG15CP400000000000000000000000000000"
            A$ = A$ + "000000000000000000000000LTA6LbA6Il?7ITaoLTA6ocA6Il?7ITaoLTA6ogQ6Jl_7K\aoO`17oKa4Clo:YTbo=ZHRo;iS>n?T"
            A$ = A$ + "=bho@f8So;iS>n_UC:ioF>YToKiTBn_UC:ioF>YToKiTBn_UC:ioF>YToKiTBn_UC:ioF>YToKiTBn_UC:ioF>YToKiTBn_UC:io"
            A$ = A$ + "F>YToKiTBn_UC:ioF>YToKiTBn_UC:ioF>YToKiTBn_UC:ioF>YToKiTBn_UC:ioF>YToKiTBn_UC:ioF>YToKiTBn_UC:ioF>YT"
            A$ = A$ + "oKiTBn_UC:ioF>YToKiTBn_UC:ioF>YToKiTBn_UC:ioF>YToKiTBn_UC:ioF>YToKiTBn_UC:ioF>YToKiTBn_UC:ioF>YToKiT"
            A$ = A$ + "Bn_UC:ioF>YToKiTBn_UC:ioF>YToKiTBn_UC:ioF>YToKiTBn_UC:ioF>YToKiTBn_UC:ioF>YToKiTBn_UC:ioF>YToKiTBn_U"
            A$ = A$ + "C:ioF>YToKiTBn_UC:ioF>YToKiTBn_UC:ioF>YToKiTBn_UC:ioF>YToKiTBn_UC:ioF>YToKiTBn_UC:ioF>YToKiTBn_UC:io"
            A$ = A$ + "F>YToKiTBn_UC:ioF>YToKiTBn_UC:ioF>YToKiTBn_UC:ioF>YToKiTBn_UC:ioF>YToKiTBn_UC:ioF>YToKiTBn_UC:ioF>YT"
            A$ = A$ + "oKiTBn_UC:ioF>YToKiTBn_UC:ioF>YToKiTBn_UC:ioF>YToKiTBn_UC:ioF>YToKiTBn_UC:ioF>YToKiTBn_UC:ioF>YToKiT"
            A$ = A$ + "Bn_UC:ioF>YToKiTBn_UC:ioF>YToKiTBn_UC:ioF>YToKiTBn_UC:ioF>YToKiTBn_UC:ioF>YToKiTBn_UC:ioF>YToKiTBn_U"
            A$ = A$ + "C:ioF>YToKiTBn_UC:ioF>YToKiTBn_UC:ioF>YToKiTBn_UC:ioF>YToKiTBn?UA2io@f8So3IS<nOT>fhoE:IToK4A4mO4?0ao"
            A$ = A$ + "N\a6oka6Kl?7ITaoLTA6ocA6Il?7ITaoLTA6ocA6Il?7ITao@lP3o_P29lO5D<1B000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000`A6I`97ITaoLTA6ocA6Il?7ITaoLTA6k[a5G4O6FHaoIDA5hk17L`200000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000`A6IP;7"
            A$ = A$ + "ITaoLTA6ocA6Ilo6HPao>d03o_P28lO7M`QC^hR;1\b:[T0;\`B2\`2;9`2;\T0;\`B2\`2;9`2;\T0;\`22[\b:2ha6Kl97ITao"
            A$ = A$ + "LTA6ocA6Il?7ITaoLTA6ocA6IlO7JXaoN\a6oo17Ll_5C<ao[TB:okXR:noT?nhoAfHSo7IS=n?T<bho?^hRoohR;noS;^ho?^hR"
            A$ = A$ + "oohR;noS;^ho?^hRoohR;noS;^ho?^hRoohR;noS;^ho?^hRoohR;noS;^ho?^hRoohR;noS;^ho?^hRoohR;noS;^ho?^hRoohR"
            A$ = A$ + ";noS;^ho?^hRoohR;noS;^ho?^hRoohR;noS;^ho?^hRoohR;noS;^ho?^hRoohR;noS;^ho?^hRoohR;noS;^ho?^hRoohR;noS"
            A$ = A$ + ";^ho?^hRoohR;noS;^ho?^hRoohR;noS;^ho?^hRoohR;noS;^ho?^hRoohR;noS;^ho?^hRoohR;noS;^ho?^hRoohR;noS;^ho"
            A$ = A$ + "?^hRoohR;noS;^ho?^hRoohR;noS;^ho?^hRoohR;noS;^ho?^hRoohR;noS;^ho?^hRoohR;noS;^ho?^hRoohR;noS;^ho?^hR"
            A$ = A$ + "oohR;noS;^ho?^hRoohR;noS;^ho?^hRoohR;noS;^ho?^hRoohR;noS;^ho?^hRoohR;noS;^ho?^hRoohR;noS;^ho?^hRoohR"
            A$ = A$ + ";noS;^ho?^hRoohR;noS;^ho?^hRoohR;noS;^ho?^hRoohR;noS;^ho?^hRoohR;noS;^ho?^hRoohR;noS;^ho?^hRoohR;noS"
            A$ = A$ + ";^ho?^hRoohR;noS;^ho?^hRoohR;noS;^ho?^hRoohR;noS;^ho?^hRoohR;noS;^ho?^hRoohR;noS;^ho?^hRoohR;noS;^ho"
            A$ = A$ + "?^hRoohR;noS;^ho?^hRoohR;noS;^ho?^hRoohR;noS;^ho?^hRoohR;noS;^ho?^hRoohR;noS;^ho?^hRoohR;noS;^ho?^hR"
            A$ = A$ + "oohR;noS;^ho?^hRoohR;noS;^ho?b8So7IS=nOT=fhoBjXSoKYTBnoA4AdoAl`3oka6Kl_7K\aoLTA6ocA6Il?7ITaoLTA6ocA6"
            A$ = A$ + "Il?7ITaoLTA6o3a3>l_29P`oMd17>iR;^4`:[\B2\`2;9`2;\T0;\`B2\`2;9`2;\T0;\`B2\`2;8\b:[8P7K\aWLTA6ocA6Il?7"
            A$ = A$ + "ITaoLTA6ocA6I\_6GLQlIHQ5oSA5EP?9R8b<\`2;2XR:Z<000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000000000000000000Pb9WL@7JXA_LTA6ocA6Il?7ITaoKP16ok@3<lo29T`oK\a6"
            A$ = A$ + "MYR:Z<1:XPR7XP2:NP2:Xh1:XPR7XP2:NP2:Xh1:XPR7XP2:MP2:XDQ7L`aYLTA6ocA6Il?7ITaoLTA6ocA6Il?7ITaoMXQ6oka6"
            A$ = A$ + "Klo7L`aoF<a4o_B:Yl_S:ZhoCnhSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT"
            A$ = A$ + "=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fho"
            A$ = A$ + "AfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHS"
            A$ = A$ + "o7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS"
            A$ = A$ + "=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT"
            A$ = A$ + "=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fho"
            A$ = A$ + "AfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHS"
            A$ = A$ + "o7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS"
            A$ = A$ + "=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT"
            A$ = A$ + "=fhoAfHSo;YS>n_UB:io7A4Ao7a3?l_7K\aoN\a6ocA6Il?7ITaoLTA6ocA6Il?7ITaoLTA6ocA6Il?4?h`o;T@2o_a6KdU:ZXb4"
            A$ = A$ + "XP2:NP2:Xh1:XPR7XP2:NP2:Xh1:XPR7XP2:NP2:Xd1:XPB5N`17WbA6Il?7ITaoLTA6ocA6Il?7ITanJLa5cWQ5FlO6EDAnR4B8"
            A$ = A$ + "4UB:YH1:XPR5XP2:700000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000HR9V8P9UDb5MXa63cA6Il?7ITaoLTA6o_16Hl_3<``o;T@2o[A6IHf9WLR8UDB9[DB9U\B9UDb:UDB9[DB9U\B9"
            A$ = A$ + "UDb:UDB9[DB9UXB9UDb8N`17\bA6Il?7ITaoLTA6ocA6Il?7ITaoLTA6ogQ6Jl_7K\aoO`17oKa4Clo:YTbo>ZXRo?iS?nOT=fho"
            A$ = A$ + "AfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHS"
            A$ = A$ + "o7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS"
            A$ = A$ + "=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT"
            A$ = A$ + "=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fho"
            A$ = A$ + "AfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHS"
            A$ = A$ + "o7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS"
            A$ = A$ + "=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT"
            A$ = A$ + "=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fho"
            A$ = A$ + "AfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=n_T>jhoF:YToO4A4mO4?l`oN\a6"
            A$ = A$ + "oka6Kl?7ITaoLTA6ocA6Il?7ITaoLTA6ocA6Il?7ITao@hP3o_@29l_6ITQIWLb9RDB9U\B9UDb:UDB9[DB9U\B9UDb:UDB9[DB9"
            A$ = A$ + "U\B9UDR:UDB9Sh17L`:7ITaoLTA6ocA6Il?7ITaoLTA6l[a5G@O6FHaoIHQ5i728PlT9VH29UDB9VDB9U4A9UDb0000000000000"
            A$ = A$ + "000000000000000000000000000000000000000000000000000000000000000000000000000000`8S<R2S<b8VdQ6JH<7ITao"
            A$ = A$ + "LTA6ocA6Ilo6HPao>`03ocP2:lO6HP1KT@29Z<b8S<c8S<b<S<b8c<b8S<c8S<b<S<b8c<b8S<c8S<R<S<b8[da6J0;7ITaoLTA6"
            A$ = A$ + "ocA6Il?7ITaoLTA6ocA6IlO7JXaoN\a6oo17Ll_5C<ao[TB:okXR:noT?nhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS"
            A$ = A$ + "=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT"
            A$ = A$ + "=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fho"
            A$ = A$ + "AfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHS"
            A$ = A$ + "o7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS"
            A$ = A$ + "=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT"
            A$ = A$ + "=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fho"
            A$ = A$ + "AfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHS"
            A$ = A$ + "o7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS"
            A$ = A$ + "=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoBjXSoKYTBnoA4AdoAl`3oka6Kl_7K\aoLTA6ocA6Il?7ITaoLTA6ocA6Il?7"
            A$ = A$ + "ITaoLTA6o3Q3>lo29T`oIP16\A29TXb8S<b<S<b8c<b8S<c8S<b<S<b8c<b8S<c8S<b<S<b8b<b8S\B7KX1\LTA6ocA6Il?7ITao"
            A$ = A$ + "LTA6ocA6I`_6GL1mIHQ5oWQ5FT?8OlQES@29]<b8S0c8S<26S<b8600000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000008P0R0P028B028P837ITAbKP16o_16Hlo6HPaoJLa5ok03<l?3:X`oHLa5`5B8"
            A$ = A$ + "Q038P0B>P028i028PT38P0B>P028i028PT38P0B>P028h028P837JXQ\KP16o_16Hlo6HPaoKP16o_16Hlo6HPaoLTA6ogQ6Jl_7"
            A$ = A$ + "K\aoE<a4o_2:Xl_S:ZhoCnhSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fho"
            A$ = A$ + "AfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHS"
            A$ = A$ + "o7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS"
            A$ = A$ + "=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT"
            A$ = A$ + "=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fho"
            A$ = A$ + "AfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHS"
            A$ = A$ + "o7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS"
            A$ = A$ + "=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT"
            A$ = A$ + "=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fhoAfHSo7IS=nOT=fho"
            A$ = A$ + "AfHSo;YS>n_UB:io7=d@o7Q3>lO7JXaoMXQ6o_16Hlo6HPaoKP16o_16Hlo6HPaoKP16o_16Hl?4>h`o<XP2oSa5G0G8Q42<P028"
            A$ = A$ + "i028PT38P0B>P028i028PT38P0B>P028i028PP38P0R<LXQ6b^16Hlo6HPaoKP16o_16Hlo6HP1oJLa5dWQ5FlO6FHQnNdA7N1B8"
            A$ = A$ + "QH38P0b=P028K028PH0000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000NhQ74hQ7NLQ7Nha>KTA6<_16Hlo6HPaoKP16o[a5Gl_3<``o;TP2oKA5E8h7OlABNhQ7@iQ7N0U7Nh1DNhQ7@iQ7N0U7Nh1D"
            A$ = A$ + "NhQ7@iQ7NlT7NhQBLXQ6k^16Hlo6HPaoKP16o_16Hlo6HPaoKP16ocA6IlO7JXaoN\a6oGa4Clo:XPbo>^hRo?9T@nOT>jhoAjXS"
            A$ = A$ + "o7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS"
            A$ = A$ + ">nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT"
            A$ = A$ + ">jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jho"
            A$ = A$ + "AjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXS"
            A$ = A$ + "o7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS"
            A$ = A$ + ">nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT"
            A$ = A$ + ">jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jho"
            A$ = A$ + "AjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXS"
            A$ = A$ + "o7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>n_T?nhoF>iToO4A4mO4>h`oMXQ6ogQ6"
            A$ = A$ + "Jlo6HPaoKP16o_16Hlo6HPaoKP16o_16Hlo6HPao@hP3ocP2:lO5DDQPOla79iQ7N0U7Nh1DNhQ7@iQ7N0U7Nh1DNhQ7@iQ7N0U7"
            A$ = A$ + "NhaCNhQ7:aQ6J\k6HPaoKP16o_16Hlo6HPaoKP16l[a5GDO6FHaoIHQ5jc17LDV7Nh1@NhQ7mhQ7NXQ7Nh110000000000000000"
            A$ = A$ + "000000000000000000000000000000000000000000000000000000000000000000000\a6K@`6K\Q6K\a63]A6Ihl6HPaoKP16"
            A$ = A$ + "o_16Hl_6GLao=\`2oo@3<lo7LXamT4b7dCR8P@O9S42mV<B8dO29R@o9U<2mYDb8d[R9T@_:WD2m\PR9d;b7N\_6GLaoKP16o_16"
            A$ = A$ + "Hlo6HPaoKP16o_16Hl?7ITaoMXQ6oka6KlO5C<ao\P2:okhR;noT@2ioAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT"
            A$ = A$ + ">jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jho"
            A$ = A$ + "AjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXS"
            A$ = A$ + "o7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS"
            A$ = A$ + ">nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT"
            A$ = A$ + ">jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jho"
            A$ = A$ + "AjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXS"
            A$ = A$ + "o7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS"
            A$ = A$ + ">nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT"
            A$ = A$ + ">jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoBnhSoKiTCnoA4AdoAhP3ogQ6JlO7JXaoKP16o_16Hlo6HPaoKP16o_16Hlo6HPao"
            A$ = A$ + "KP16oo@3=l?3:X`oIHA5gCB8O@?9Ql1mT828dKR8Q@o9S42mX@b8dSB9S@O:U<2mZLB9d_2:V@_8NdanJLa5o_16Hlo6HPaoKP16"
            A$ = A$ + "o_16H`_6GLQmIHQ5oWQ5FXo6ITAKK\a69]a6Klc6K\Q5K\a63000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000@6ITA1ITA6MTA6I\d6HPAdKP16o_16Hlo6HPaoIHQ5ooP3=l_7KTaoU828oGR8Pl_9"
            A$ = A$ + "S4boW<B8oS29Rl?:V@boZH29o_b9Ul?;XHbo]Tb9okR:Xl_8OhaoJLa5o_16Hlo6HPaoKP16o_16Hlo6HPaoLTA6ogQ6Jl_7K\ao"
            A$ = A$ + "E<a4oc2:Xl_S;^hoC29To7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXS"
            A$ = A$ + "o7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS"
            A$ = A$ + ">nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT"
            A$ = A$ + ">jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jho"
            A$ = A$ + "AjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXS"
            A$ = A$ + "o7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS"
            A$ = A$ + ">nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT"
            A$ = A$ + ">jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jho"
            A$ = A$ + "AjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXS"
            A$ = A$ + "o;iS?n_UC>io7A4Ao7Q3>lO7JXaoMXQ6o_16Hlo6HPaoKP16o_16Hlo6HPaoKP16o[a5Glo3=d`oHH15oGR8PlO9QlaoU<28oOb8"
            A$ = A$ + "Ql?:T8boYDb8oWR9Tl_:V@bo[PR9oc2:Vl_;ZPboRlQ7o[a5Glo6HPaoKP16o_16Hlo6HP1oJLa5fWQ5FlO6FHQnIP16dUA6I4E6"
            A$ = A$ + "ITQ?ITA6A0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "FHQ55HQ5F0R5FHaDJP16D_16Hlo6HPaoKP16o[a5Glo7LXaoU828oGR8Pl_9S4boW<B8oS29Rl?:V@boYH29o_b9Ul?;XHbo]PR9"
            A$ = A$ + "ogR:Xlo;[TboSla7o[a5Glo6HPaoKP16o_16Hlo6HPaoKP16ocA6IlO7JXaoN\a6oGa4Cl?;XPbo>^hRo?9T@nOT>jhoAjXSo7YS"
            A$ = A$ + ">nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT"
            A$ = A$ + ">jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jho"
            A$ = A$ + "AjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXS"
            A$ = A$ + "o7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS"
            A$ = A$ + ">nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT"
            A$ = A$ + ">jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jho"
            A$ = A$ + "AjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXS"
            A$ = A$ + "o7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS"
            A$ = A$ + ">nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>nOT>jhoAjXSo7YS>n_T?nhoF>iToO4A4mO4>h`oMXQ6ogQ6Jlo6"
            A$ = A$ + "HPaoKP16o_16Hlo6HPaoKP16o_16Hl_6GLaoJPa5oGB8OlO9QlaoU828oKb8Ql?:T8boYDb8oWR9Tl_:V@bo[PR9oc2:VlO;YLbo"
            A$ = A$ + "^\B:o;b7Ol_6GLaoKP16o_16Hlo6HPaoKP16m[a5GHO6FHaoIHQ5kOQ5F`W5FHaEFHQ5fHQ5FT00000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000000000000000000000000000000<a4CD`4C<19C<a4KYa5FHm6HPaoKP16o_16"
            A$ = A$ + "Hl?7HPaoT4b7oGR8Plo9S4boW@B8oSB9SlO:V@boZLB9o_b9Ul?;YLbo]Tb9okR:Xlo;[Tbo`db:o?28Ol_6GHaoKP16o_16Hlo6"
            A$ = A$ + "HPaoKP16o_16Hl?7ITaoMXQ6oka6KlO5C<ao\P2:okhR:noT@nhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fho"
            A$ = A$ + "AjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHS"
            A$ = A$ + "o7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS"
            A$ = A$ + "=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT"
            A$ = A$ + ">fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fho"
            A$ = A$ + "AjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHS"
            A$ = A$ + "o7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS"
            A$ = A$ + "=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT"
            A$ = A$ + ">fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fho"
            A$ = A$ + "AjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoBnXSoKiTBnoA4AdoAhP3ogQ6JlO7JXaoKP16o_16Hlo6HPaoKP16o_16Hlo6HPaoKPa5"
            A$ = A$ + "o?28Nl_9R0boV<B8oO29Ql?:T8boYD29o[R9Tl_:WDbo\PR9ogB:Wl_;YLbo^\B:o33;Zlo8OlaoJLQ5o_16Hlo6HPaoKP16o_16"
            A$ = A$ + "HdO6GLamIHQ5oWQ5F\O5D@1QC<a4G=a4CT25D@Q0000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000P4B8Q1B8Q4X8Q4B866FHAfJLa5o[a5Gl_6GLaoJLa5oka6Jlo7L\aoO`a6oo17Klo7L`ao"
            A$ = A$ + "Pd17o3B7LlO8N`aoQhA7o7R7MlO8NhaoRlQ7o?b7NlO7JXaoJLQ5o[a5Gl_6GLaoJLa5o[a5Gl_6GLaoKP16ocA6IlO7JXaoD8Q4"
            A$ = A$ + "o_2:Xl_S;ZhoC2iSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS"
            A$ = A$ + "=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT"
            A$ = A$ + ">fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fho"
            A$ = A$ + "AjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHS"
            A$ = A$ + "o7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS"
            A$ = A$ + "=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT"
            A$ = A$ + ">fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fho"
            A$ = A$ + "AjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHS"
            A$ = A$ + "o7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo7YS=nOT>fhoAjHSo;iS"
            A$ = A$ + ">n_UC:io6=d@o3A3=l?7ITaoLTA6o[a5Gl_6GLaoJLa5o[a5Gl_6GLaoJLa5o[a5Gl_7JXaoN\a6oo17Klo7L\aoO`17o327Ll?8"
            A$ = A$ + "M`aoQd17o7R7MlO8NdaoQhQ7o;b7Nlo8OhaoMXQ6o[a5Fl_6GLaoJLa5o[a5Gl_6GLAoIHQ5hWQ5FlO6FHAnC8Q4o9Q4B8U4B8A6"
            A$ = A$ + "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000?l`3"
            A$ = A$ + "7l`3?Xb3?lPJGDA5L[a5Gl_6GLaoJLa5o[a5GlO6FLaoIHQ5oWQ5FlO6FHaoIHQ5oWQ5FlO6FHaoIHQ5oWQ5FlO6FHaoIHQ5oWQ5"
            A$ = A$ + "FlO6FHaoJLa5o[a5Gl_6GLaoJLa5o[a5Gl_6GLaoJLa5o_16Hl?7ITaoMXQ6oCQ4Bl?;YTboD29ToWYUEnoUC>ioG>iToOiTCnoU"
            A$ = A$ + "C>ioG>iToOiTCnoUC>ioG>iToOiTCnoUC>ioG>iToOiTCnoUC>ioG>iToOiTCnoUC>ioG>iToOiTCnoUC>ioG>iToOiTCnoUC>io"
            A$ = A$ + "G>iToOiTCnoUC>ioG>iToOiTCnoUC>ioG>iToOiTCnoUC>ioG>iToOiTCnoUC>ioG>iToOiTCnoUC>ioG>iToOiTCnoUC>ioG>iT"
            A$ = A$ + "oOiTCnoUC>ioG>iToOiTCnoUC>ioG>iToOiTCnoUC>ioG>iToOiTCnoUC>ioG>iToOiTCnoUC>ioG>iToOiTCnoUC>ioG>iToOiT"
            A$ = A$ + "CnoUC>ioG>iToOiTCnoUC>ioG>iToOiTCnoUC>ioG>iToOiTCnoUC>ioG>iToOiTCnoUC>ioG>iToOiTCnoUC>ioG>iToOiTCnoU"
            A$ = A$ + "C>ioG>iToOiTCnoUC>ioG>iToOiTCnoUC>ioG>iToOiTCnoUC>ioG>iToOiTCnoUC>ioG>iToOiTCnoUC>ioG>iToOiTCnoUC>io"
            A$ = A$ + "G>iToOiTCnoUC>ioG>iToOiTCnoUC>ioG>iToOiTCnoUC>ioG>iToOiTCnoUC>ioG>iToOiTCnoUC>ioG>iToOiTCnoUC>ioG>iT"
            A$ = A$ + "oOiTCnoUC>ioG>iToOiTCnoUC>ioG>iToOiTCnoUC>ioG>iToOiTCnoUC>ioG>iToOiTCnoUC>ioG>iToOiTCnoUC>ioG>iToOiT"
            A$ = A$ + "CnoUC>ioG>iToOiTCnoUC>ioG>iToOiTCnoUC>ioG>iToOiTCnoUC>ioG>iToOiTCnoUC>ioG>iToOiTCnoUC>ioG>iToOiTCnoU"
            A$ = A$ + "C>ioG>iToOiTCnoUC>ioG>iToOiTCnoUC>ioG>iToOiTCnoUC>ioG>iToOiTCn?VEBioMVIVoWDA5m?4=d`oLTA6ocA6Il_6GLao"
            A$ = A$ + "JLa5o[a5Gl_6GLaoJLa5o[a5Gl_6GLaoILa5oWQ5FlO6FHaoIHQ5oWQ5FlO6FHaoIHQ5oWQ5FlO6FHaoIHQ5oWQ5FlO6FHaoIHQ5"
            A$ = A$ + "o[a5Gl_6GLaoJLa5o[a5Gl_6GLaoJLa5mWQ5FPO6FHaoHDA5Wo`3?Pg3?l@A?l`3<00000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000d@3=P@3=dP;=d@3bMA5Ehm6GLaoJLa5o[a5Gl_6"
            A$ = A$ + "GLaoJLa5o[a5Gl_6GLaoJLa5o[a5Gl_6GLaoJLa5o[a5Gl_6GLaoJLa5o[a5Gl_6GLaoJLa5o[a5Gl_6GLaoJLa5o[a5Gl_6GLao"
            A$ = A$ + "JLa5o[a5Glo6HPaoLTA6ogQ6JlO5C<aoU8R8ogFJYmOL]efo_a6Koo6K\moK\afo_a6Koo6K\moK\afo_a6Koo6K\moK\afo_a6K"
            A$ = A$ + "oo6K\moK\afo_a6Koo6K\moK\afo_a6Koo6K\moK\afo_a6Koo6K\moK\afo_a6Koo6K\moK\afo_a6Koo6K\moK\afo_a6Koo6K"
            A$ = A$ + "\moK\afo_a6Koo6K\moK\afo_a6Koo6K\moK\afo_a6Koo6K\moK\afo_a6Koo6K\moK\afo_a6Koo6K\moK\afo_a6Koo6K\moK"
            A$ = A$ + "\afo_a6Koo6K\moK\afo_a6Koo6K\moK\afo_a6Koo6K\moK\afo_a6Koo6K\moK\afo_a6Koo6K\moK\afo_a6Koo6K\moK\afo"
            A$ = A$ + "_a6Koo6K\moK\afo_a6Koo6K\moK\afo_a6Koo6K\moK\afo_a6Koo6K\moK\afo_a6Koo6K\moK\afo_a6Koo6K\moK\afo_a6K"
            A$ = A$ + "oo6K\moK\afo_a6Koo6K\moK\afo_a6Koo6K\moK\afo_a6Koo6K\moK\afo_a6Koo6K\moK\afo_a6Koo6K\moK\afo_a6Koo6K"
            A$ = A$ + "\moK\afo_a6Koo6K\moK\afo_a6Koo6K\moK\afo_a6Koo6K\moK\afo_a6Koo6K\moK\afo_a6Koo6K\moK\afo_a6Koo6K\moK"
            A$ = A$ + "\afo_a6Koo6K\moK\afo_a6Koo6K\moK\afo_a6Koo6K\moK\afo_a6Koo6K\moK\afo_a6Koo6K\moK\afo_a6Koo6K\moK\afo"
            A$ = A$ + "_a6Koo6K\moK\afo_a6Koo6K\moK\afo_a6Koo6K\moK\afo_a6Koo6K\moK\afo_a6Koo6K\moK\afo_a6Koo6K\moK\afo_a6K"
            A$ = A$ + "oo6K\moK\afo_a6Koo6K\moK\afo`a6Ko?gK_mO>fHcoBl`3ocA6Il?7ITaoJLa5o[a5Gl_6GLaoJLa5o[a5Gl_6GLaoJLa5o[a5"
            A$ = A$ + "Gl_6GLaoJLa5o[a5Gl_6GLaoJLa5o[a5Gl_6GLaoJLa5o[a5Gl_6GLaoJLa5o[a5Gl_6GLaoJLa5o[a5Gl_6GLaoJLa5o[a5GdO6"
            A$ = A$ + "FH1nJLa5o?Q4B\;3<`PK=d@3dd@3=@0000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000P2:X02:XP2aXP2:XW5D@AhKP16o[a5Gl_6GLaoJLa5o[a5Gl_6GLaoJLa5o[a5Gl_6GLaoJLa5"
            A$ = A$ + "o[a5Gl_6GLaoJLa5o[a5Gl_6GLaoJLa5o[a5Gl_6GLaoJLa5o[a5Gl_6GLaoJLa5o[a5Gl_6GLaoKP16ocA6IlO7JXaoHDA5oKa4"
            A$ = A$ + "ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5"
            A$ = A$ + "C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<ao"
            A$ = A$ + "E<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4"
            A$ = A$ + "oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4"
            A$ = A$ + "ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5"
            A$ = A$ + "C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<ao"
            A$ = A$ + "E<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4"
            A$ = A$ + "oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4"
            A$ = A$ + "ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5"
            A$ = A$ + "C<aoF<a4oKa4Cl?7ITaoLTA6o[a5Gl_6GLaoJLa5o[a5Gl_6GLaoJLa5o[a5Gl_6GLaoJLa5o[a5Gl_6GLaoJLa5o[a5Gl_6GLao"
            A$ = A$ + "JLa5o[a5Gl_6GLaoJLa5o[a5Gl_6GLaoJLa5o[a5Gl_6GLaoJLa5o[a5Gl_6GLAoILa5mO15Ddn2:X0T:XP2XYP2:02000000000"
            A$ = A$ + "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007L`18L`1"
            A$ = A$ + "7Dc17LPPF<a4S_16Hl_6GLaoJLa5o[a5Gl_6GLaoJLa5o[a5Gl_6GLaoJLa5o[a5Gl_6GLaoJLa5o[a5Gl_6GLaoJLa5o[a5Gl_6"
            A$ = A$ + "GLaoJLa5o[a5Gl_6GLaoJLa5o[a5Gl_6GLaoJLa5o_16Hl?7ITaoMXQ6oSA5El_5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<ao"
            A$ = A$ + "E<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4"
            A$ = A$ + "oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4"
            A$ = A$ + "ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5"
            A$ = A$ + "C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<ao"
            A$ = A$ + "E<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4"
            A$ = A$ + "oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4"
            A$ = A$ + "ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5"
            A$ = A$ + "C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<ao"
            A$ = A$ + "E<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oKa4Cl_5C<aoLTA6ocA6Il_6GLaoJLa5"
            A$ = A$ + "o[a5Gl_6GLaoJLa5o[a5Gl_6GLaoJLa5o[a5Gl_6GLaoJLa5o[a5Gl_6GLaoJLa5o[a5Gl_6GLaoJLa5o[a5Gl_6GLaoJLa5o[a5"
            A$ = A$ + "Gl_6GLaoJLa5o[a5Gl_6GLaoJLa5nWQ5F`_3=d0^6HP1;N`17Le17L`300000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000000000000000000000000000D@15P@15DP=5D@1:>A4AXN5C<aoE<a4oGa4ClO5C<ao"
            A$ = A$ + "E<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4"
            A$ = A$ + "oGa4ClO5C<aoF@15oOA5Elo4A4aoB014o;14@l_4@0aoB014o;14@l_4@0aoB014o;14@l_4@0aoB014o;14@l_4@0aoB014o;14"
            A$ = A$ + "@l_4@0aoB014o;14@l_4@0aoB014o;14@l_4@0aoB014o;14@l_4@0aoB014o;14@l_4@0aoB014o;14@l_4@0aoB014o;14@l_4"
            A$ = A$ + "@0aoB014o;14@l_4@0aoB014o;14@l_4@0aoB014o;14@l_4@0aoB014o;14@l_4@0aoB014o;14@l_4@0aoB014o;14@l_4@0ao"
            A$ = A$ + "B014o;14@l_4@0aoB014o;14@l_4@0aoB014o;14@l_4@0aoB014o;14@l_4@0aoB014o;14@l_4@0aoB014o;14@l_4@0aoB014"
            A$ = A$ + "o;14@l_4@0aoB014o;14@l_4@0aoB014o;14@l_4@0aoB014o;14@l_4@0aoB014o;14@l_4@0aoB014o;14@l_4@0aoB014o;14"
            A$ = A$ + "@l_4@0aoB014o;14@l_4@0aoB014o;14@l_4@0aoB014o;14@l_4@0aoB014o;14@l_4@0aoB014o;14@l_4@0aoB014o;14@l_4"
            A$ = A$ + "@0aoB014o;14@l_4@0aoB014o;14@l_4@0aoB014o;14@l_4@0aoB014o;14@l_4@0aoB014o;14@l_4@0aoB014o;14@l_4@0ao"
            A$ = A$ + "B014o;14@l_4@0aoB014o;14@l_4@0aoB014o;14@l_4@0aoB014o;14@l_4@0aoB014o;14@l_4@0aoB014o;14@l_4@0aoB014"
            A$ = A$ + "o;14@l_4@0aoB014o;14@l_4@0aoB014o;14@l_4@0aoB014o;14@l_4@0aoB014o;14@l_4@0aoB014o;14@l_4@0aoB014o;14"
            A$ = A$ + "@l_4@0aoB014o;14@l_4@0aoB014o;14@l_4@0aoB014oK15Dl_5D@aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5"
            A$ = A$ + "C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4ClO5C<aoE<a4oGa4Clo4A4Ah"
            A$ = A$ + "4D@1NF@15\H15DP?5D@140000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000P028@128P0_8@02LX3<`@iB014o;14@l_4@0aoB014o;14@l_4@0aoB014o;14@l_4@0aoB014o;14"
            A$ = A$ + "@l_4@0aoB014o;14@l_4@0aoB014o;14@l_4@0aoB014o;14@l_4@0aoB014o;14@l_4@0aoB014o?A4Alo4B8ao@hP3oo@3=lo3"
            A$ = A$ + "=d`o?d@3oo@3=lo3=d`o?d@3oo@3=lo3=d`o?d@3oo@3=lo3=d`o?d@3oo@3=lo3=d`o?d@3oo@3=lo3=d`o?d@3oo@3=lo3=d`o"
            A$ = A$ + "?d@3oo@3=lo3=d`o?d@3oo@3=lo3=d`o?d@3oo@3=lo3=d`o?d@3oo@3=lo3=d`o?d@3oo@3=lo3=d`o?d@3oo@3=lo3=d`o?d@3"
            A$ = A$ + "oo@3=lo3=d`o?d@3oo@3=lo3=d`o?d@3oo@3=lo3=d`o?d@3oo@3=lo3=d`o?d@3oo@3=lo3=d`o?d@3oo@3=lo3=d`o?d@3oo@3"
            A$ = A$ + "=lo3=d`o?d@3oo@3=lo3=d`o?d@3oo@3=lo3=d`o?d@3oo@3=lo3=d`o?d@3oo@3=lo3=d`o?d@3oo@3=lo3=d`o?d@3oo@3=lo3"
            A$ = A$ + "=d`o?d@3oo@3=lo3=d`o?d@3oo@3=lo3=d`o?d@3oo@3=lo3=d`o?d@3oo@3=lo3=d`o?d@3oo@3=lo3=d`o?d@3oo@3=lo3=d`o"
            A$ = A$ + "?d@3oo@3=lo3=d`o?d@3oo@3=lo3=d`o?d@3oo@3=lo3=d`o?d@3oo@3=lo3=d`o?d@3oo@3=lo3=d`o?d@3oo@3=lo3=d`o?d@3"
            A$ = A$ + "oo@3=lo3=d`o?d@3oo@3=lo3=d`o?d@3oo@3=lo3=d`o?d@3oo@3=lo3=d`o?d@3oo@3=lo3=d`o?d@3oo@3=lo3=d`o?d@3oo@3"
            A$ = A$ + "=lo3=d`o?d@3oo@3=lo3=d`o?d@3oo@3=lo3=d`o?d@3oo@3=lo3=d`o?d@3oo@3=lo3=d`o?d@3oo@3=lo3=d`o?d@3oo@3=lo3"
            A$ = A$ + "=d`o?d@3oo@3=lo3=d`o?d@3oo@3=lo3=d`o?d@3oo@3=lo3=d`o?d@3oo@3=lo3=d`o?d@3oo@3=lo3=d`o?d@3oo@3=lo3=d`o"
            A$ = A$ + "?d@3oo@3=lo4A4aoC4A4o;14@l_4@0aoB014o;14@l_4@0aoB014o;14@l_4@0aoB014o;14@l_4@0aoB014o;14@l_4@0aoB014"
            A$ = A$ + "o;14@l_4@0aoB014o;14@l_4@0aoB014o;14@l_4@0aoB014o;14@l_4@0Qo7HP1l6@01@Z028@O28P0U0000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000020"
            A$ = A$ + "00`M4@01n6a3?dO4?l`oAl`3o7a3?lO4?l`oAl`3o7a3?lO4?l`oAl`3o7a3?lO4?l`oAl`3o7a3?lO4?l`oAl`3o7a3?lO4?l`o"
            A$ = A$ + "Al`3o7a3?lO4?l`oAl`3o7a3?lO4?l`oAl`3o;14@l_4@0aoC4A4o3Q3>lo3<d`o?`@3oo03=lo3<d`o?`@3oo03=lo3<d`o?`@3"
            A$ = A$ + "oo03=lo3<d`o?`@3oo03=lo3<d`o?`@3oo03=lo3<d`o?`@3oo03=lo3<d`o?`@3oo03=lo3<d`o?`@3oo03=lo3<d`o?`@3oo03"
            A$ = A$ + "=lo3<d`o?`@3oo03=lo3<d`o?`@3oo03=lo3<d`o?`@3oo03=lo3<d`o?`@3oo03=lo3<d`o?`@3oo03=lo3<d`o?`@3oo03=lo3"
            A$ = A$ + "<d`o?`@3oo03=lo3<d`o?`@3oo03=lo3<d`o?`@3oo03=lo3<d`o?`@3oo03=lo3<d`o?`@3oo03=lo3<d`o?`@3oo03=lo3<d`o"
            A$ = A$ + "?`@3oo03=lo3<d`o?`@3oo03=lo3<d`o?`@3oo03=lo3<d`o?`@3oo03=lo3<d`o?`@3oo03=lo3<d`o?`@3oo03=lo3<d`o?`@3"
            A$ = A$ + "oo03=lo3<d`o?`@3oo03=lo3<d`o?`@3oo03=lo3<d`o?`@3oo03=lo3<d`o?`@3oo03=lo3<d`o?`@3oo03=lo3<d`o?`@3oo03"
            A$ = A$ + "=lo3<d`o?`@3oo03=lo3<d`o?`@3oo03=lo3<d`o?`@3oo03=lo3<d`o?`@3oo03=lo3<d`o?`@3oo03=lo3<d`o?`@3oo03=lo3"
            A$ = A$ + "<d`o?`@3oo03=lo3<d`o?`@3oo03=lo3<d`o?`@3oo03=lo3<d`o?`@3oo03=lo3<d`o?`@3oo03=lo3<d`o?`@3oo03=lo3<d`o"
            A$ = A$ + "?`@3oo03=lo3<d`o?`@3oo03=lo3<d`o?`@3oo03=lo3<d`o?`@3oo03=lo3<d`o?`@3oo03=lo3<d`o?`@3oo03=lo3<d`o?`@3"
            A$ = A$ + "oo03=lo3<d`o?`@3oo03=lo3<d`o?`@3oo03=lo3<d`o?`@3oo03=lo3<d`o?`@3oo03=lo3<d`oB014o;14@lO4?l`oAl`3o7a3"
            A$ = A$ + "?lO4?l`oAl`3o7a3?lO4?l`oAl`3o7a3?lO4?l`oAl`3o7a3?lO4?l`oAl`3o7a3?lO4?l`oAl`3o7a3?lO4?l`oAl`3o7a3?lO4"
            A$ = A$ + "?l`oAl`3o7a3?l_4@0ao<\`2U3000d:000@V0000C1000h000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "00000000000000000000000000000000000000000000000000000000000000030000D1000dI15DPb>d@3eo@3=ho3=dPo?d@3"
            A$ = A$ + "no@3=ho3=dPo?d@3no@3=ho3=dPo?d@3no@3=ho3=dPo?d@3no@3=ho3=dPo?d@3no@3=ho3=dPo?d@3no@3=ho3=dPo?d@3no@3"
            A$ = A$ + "=ho3>hPo@hP3n7a3?h_3<`Po=X`2ngP2;hO3:\Po=X`2ngP2;hO3:\Po=X`2ngP2;hO3:\Po=X`2ngP2;hO3:\Po=X`2ngP2;hO3"
            A$ = A$ + ":\Po=X`2ngP2;hO3:\Po=X`2ngP2;hO3:\Po=X`2ngP2;hO3:\Po=X`2ngP2;hO3:\Po=X`2ngP2;hO3:\Po=X`2ngP2;hO3:\Po"
            A$ = A$ + "=X`2ngP2;hO3:\Po=X`2ngP2;hO3:\Po=X`2ngP2;hO3:\Po=X`2ngP2;hO3:\Po=X`2ngP2;hO3:\Po=X`2ngP2;hO3:\Po=X`2"
            A$ = A$ + "ngP2;hO3:\Po=X`2ngP2;hO3:\Po=X`2ngP2;hO3:\Po=X`2ngP2;hO3:\Po=X`2ngP2;hO3:\Po=X`2ngP2;hO3:\Po=X`2ngP2"
            A$ = A$ + ";hO3:\Po=X`2ngP2;hO3:\Po=X`2ngP2;hO3:\Po=X`2ngP2;hO3:\Po=X`2ngP2;hO3:\Po=X`2ngP2;hO3:\Po=X`2ngP2;hO3"
            A$ = A$ + ":\Po=X`2ngP2;hO3:\Po=X`2ngP2;hO3:\Po=X`2ngP2;hO3:\Po=X`2ngP2;hO3:\Po=X`2ngP2;hO3:\Po=X`2ngP2;hO3:\Po"
            A$ = A$ + "=X`2ngP2;hO3:\Po=X`2ngP2;hO3:\Po=X`2ngP2;hO3:\Po=X`2ngP2;hO3:\Po=X`2ngP2;hO3:\Po=X`2ngP2;hO3:\Po=X`2"
            A$ = A$ + "ngP2;hO3:\Po=X`2ngP2;hO3:\Po=X`2ngP2;hO3:\Po=X`2ngP2;hO3:\Po=X`2ngP2;hO3:\Po=X`2ngP2;hO3:\Po=X`2ngP2"
            A$ = A$ + ";hO3:\Po=X`2ngP2;hO3:\Po=X`2ngP2;hO3:\Po=X`2ngP2;hO3:\Po=X`2ngP2;hO3:\Po=X`2ngP2;hO3:\Po=X`2ngP2;hO3"
            A$ = A$ + ":\Po=X`2ngP2;hO3:\Po=X`2ngP2;hO3:\Po=X`2n3Q3>h?4>hPo?d@3no@3=ho3=dPo?d@3no@3=ho3=dPo?d@3no@3=ho3=dPo"
            A$ = A$ + "?d@3no@3=ho3=dPo?d@3no@3=ho3=dPo?d@3no@3=ho3=dPo?d@3no@3=ho3=dPo?d@3no@3=ho3=h@o<XP2W;@01P;0000V0000"
            A$ = A$ + "L1000X1000@00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000000010000`1000PF000066@01dI0140Y14@0T6@01@J0140Y14@0T6@01@J0140Y14@0T6@01@J0"
            A$ = A$ + "140Y14@0T6@01@J0140Y14@0T6@01@J0140Y14@0T6@01@J0140Y14@0T6@01@J0140Y14@0T6@01@J0140Y14@0T6@01@J0140Y"
            A$ = A$ + "14@0T6@01@J0140Y14@0T6@01@J0140Y14@0T6@01@J0140Y14@0T6@01@J0140Y14@0T6@01@J0140Y14@0T6@01@J0140Y14@0"
            A$ = A$ + "T6@01@J0140Y14@0T6@01@J0140Y14@0T6@01@J0140Y14@0T6@01@J0140Y14@0T6@01@J0140Y14@0T6@01@J0140Y14@0T6@0"
            A$ = A$ + "1@J0140Y14@0T6@01@J0140Y14@0T6@01@J0140Y14@0T6@01@J0140Y14@0T6@01@J0140Y14@0T6@01@J0140Y14@0T6@01@J0"
            A$ = A$ + "140Y14@0T6@01@J0140Y14@0T6@01@J0140Y14@0T6@01@J0140Y14@0T6@01@J0140Y14@0T6@01@J0140Y14@0T6@01@J0140Y"
            A$ = A$ + "14@0T6@01@J0140Y14@0T6@01@J0140Y14@0T6@01@J0140Y14@0T6@01@J0140Y14@0T6@01@J0140Y14@0T6@01@J0140Y14@0"
            A$ = A$ + "T6@01@J0140Y14@0T6@01@J0140Y14@0T6@01@J0140Y14@0T6@01@J0140Y14@0T6@01@J0140Y14@0T6@01@J0140Y14@0T6@0"
            A$ = A$ + "1@J0140Y14@0T6@01@J0140Y14@0T6@01@J0140Y14@0T6@01@J0140Y14@0T6@01@J0140Y14@0T6@01@J0140Y14@0T6@01@J0"
            A$ = A$ + "140Y14@0T6@01@J0140Y14@0T6@01@J0140Y14@0T6@01@J0140Y14@0T6@01@J0140Y14@0T6@01@J0140Y14@0T6@01@J0140Y"
            A$ = A$ + "14@0T6@01@J0140Y14@0T6@01@J0140Y14@0T6@01@J0140Y14@0T6@01@J0140Y14@0T6@01@J0140Y14@0T6@01@J0140Y14@0"
            A$ = A$ + "T6@01@J0140Y14@0T6@01@J0140Y14@0T6@01@J0140Y14@0T6@01@J0140Y14@0T6@01@J0140Y14@0T6@01@J0140Y14@0T6@0"
            A$ = A$ + "1@J0140Y14@0T6@01@J0140Y14@0T6@01@J0140Y14@0R2000H9000`N000031000@1000@00000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000070000\1000@;0000c0000@30000=0000d0000@30000=0000d0000@30000=0000d0000@30000=0000d0000@30000=0000"
            A$ = A$ + "d0000@30000=0000d0000@30000=0000d0000@30000=0000d0000@30000=0000d0000@30000=0000d0000@30000=0000d000"
            A$ = A$ + "0@30000=0000d0000@30000=0000d0000@30000=0000d0000@30000=0000d0000@30000=0000d0000@30000=0000d0000@30"
            A$ = A$ + "000=0000d0000@30000=0000d0000@30000=0000d0000@30000=0000d0000@30000=0000d0000@30000=0000d0000@30000="
            A$ = A$ + "0000d0000@30000=0000d0000@30000=0000d0000@30000=0000d0000@30000=0000d0000@30000=0000d0000@30000=0000"
            A$ = A$ + "d0000@30000=0000d0000@30000=0000d0000@30000=0000d0000@30000=0000d0000@30000=0000d0000@30000=0000d000"
            A$ = A$ + "0@30000=0000d0000@30000=0000d0000@30000=0000d0000@30000=0000d0000@30000=0000d0000@30000=0000d0000@30"
            A$ = A$ + "000=0000d0000@30000=0000d0000@30000=0000d0000@30000=0000d0000@30000=0000d0000@30000=0000d0000@30000="
            A$ = A$ + "0000d0000@30000=0000d0000@30000=0000d0000@30000=0000d0000@30000=0000d0000@30000=0000d0000@30000=0000"
            A$ = A$ + "d0000@30000=0000d0000@30000=0000d0000@30000=0000d0000@30000=0000d0000@30000=0000d0000@30000=0000d000"
            A$ = A$ + "0@30000=0000d0000@30000=0000d0000@30000=0000d0000@30000=0000d0000@30000=0000d0000@30000=0000d0000@30"
            A$ = A$ + "000=0000d0000@30000=0000d0000@30000=0000d0000@30000=0000d0000@30000=0000d0000@30000=0000d0000@30000="
            A$ = A$ + "0000d000043000`90000C0000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000030000D0000@100005000"
            A$ = A$ + "0D0000@1000050000D0000@1000050000D0000@1000050000D0000@1000050000D0000@1000050000D0000@1000050000D00"
            A$ = A$ + "00@1000050000D0000@1000050000D0000@1000050000D0000@1000050000D0000@1000050000D0000@1000050000D0000@1"
            A$ = A$ + "000050000D0000@1000050000D0000@1000050000D0000@1000050000D0000@1000050000D0000@1000050000D0000@10000"
            A$ = A$ + "50000D0000@1000050000D0000@1000050000D0000@1000050000D0000@1000050000D0000@1000050000D0000@100005000"
            A$ = A$ + "0D0000@1000050000D0000@1000050000D0000@1000050000D0000@1000050000D0000@1000050000D0000@1000050000D00"
            A$ = A$ + "00@1000050000D0000@1000050000D0000@1000050000D0000@1000050000D0000@1000050000D0000@1000050000D0000@1"
            A$ = A$ + "000050000D0000@1000050000D0000@1000050000D0000@1000050000D0000@1000050000D0000@1000050000D0000@10000"
            A$ = A$ + "50000D0000@1000050000D0000@1000050000D0000@1000050000D0000@1000050000D0000@1000050000D0000@100005000"
            A$ = A$ + "0D0000@1000050000D0000@1000050000D0000@1000050000D0000@1000050000D0000@1000050000D0000@1000050000D00"
            A$ = A$ + "00@1000050000D0000@1000050000D0000@1000050000D0000@1000050000D0000@1000050000D0000@1000050000D0000@1"
            A$ = A$ + "000050000D0000@1000050000D0000@1000050000D0000@1000050000D0000@1000050000D0000@1000050000D0000@10000"
            A$ = A$ + "50000D0000@1000050000D0000@1000050000D0000@1000050000D0000@1000050000D000001000010000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            A$ = A$ + "000000000000000000000000%%00"
        CASE "oknowait.bmp"
            A$ = MKI$(16) + MKI$(48)
            A$ = A$ + "0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000"
            A$ = A$ + "o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o7013l?000`o0000o3000l?000`o0000o3000l?000`o0000o300"
            A$ = A$ + "0l?000`o0000o3000l?000`o0000o[`7Gl??OJgoB@D<o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o3000l?0"
            A$ = A$ + "00`o0000oWP7Fl_?PNgoN1LUoK5_@n?40ibo0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000oS@7ElO>I>go"
            A$ = A$ + "GUkSoKe]>n_Egjho<5kQoS09Il?000`o0000oC05>l?2[hao0000o3000l?000`o0000oO`6Clo<Dffo>5;Rok4\6n_C`Jho=mJQ"
            A$ = A$ + "ocAJ;m_07D`o0000oG`5@lO:9>fooTZOo_`>Yl?000`o0000oKP6Cl?;>Nfo5U:PoG4ZnmOAXjgo4MZOo[QI9m_07D`o0000oC`5"
            A$ = A$ + "@l?95neol4jMo_cWfm_=OBgo;\C:oGP6Bl_98:fol0jMo_cWfmo>OJgojhIMoOaH5m_07D`o0000o3000lO2c<bo^8iJo7CU^mO<"
            A$ = A$ + "EjfoaDYKokRU]mO84jeobHiKo7CU^mO<Ejfoa@IKo?1H2m_07D`o0000o3000l?000`o0000o_`?\lO99:foX`HIoS2SUm?:<Ffo"
            A$ = A$ + "X`HIoS2SUm?:<FfoW\8Io3AGolO06@`o0000o3000l?000`o0000o3000l?000`o9dC:ocAPKmo74feoO@HGoo1QMmo74feoN<HG"
            A$ = A$ + "og@FmlO06@`o0000o3000l?000`o0000o3000l?000`o0000o3000lo1kLboEX7EoK1OFm_5lIeoF`GEoW`EklO06@`o0000o300"
            A$ = A$ + "0l?000`o0000o3000l?000`o0000o3000l?000`o0000oG@>Vlo3dmdo?DgCoO@Ehl?06@`o0000o3000l?000`o0000o3000l?0"
            A$ = A$ + "00`o0000o3000l?000`o0000o3000l?000`o3Dc8oG`Cdl?05<`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o"
            A$ = A$ + "0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000"
            A$ = A$ + "o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o300"
            A$ = A$ + "0l?000`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o00`0o300:m?06`io0XPao3P28o?0"
            A$ = A$ + "6hio000Co3003l?000`o0000o3000l?000`o0000o3000l?000`o00P9o3@2mn?0:\no0<@ko300Zo?00Pno0<0jo3P2Vo?09dko"
            A$ = A$ + "000:o3000l?000`o0000o3000l?000`o000:o3P2Go?00hno00@ko300]o?00hno00@ko300[o?00Dno000ho3P2@o?00Tbo0000"
            A$ = A$ + "o3000l?000`o00@1o3`13o?00hno000ko300\o?00`no000ko300\o?00`no000ko300Wo?00dmo0L`^o3005l?000`o0000o3`0"
            A$ = A$ + "Bm?01hno00Pjo300Xo?00Pno000jo300Xo?00Pno000jo300Xo?00Pno00`ho3@0Io?030eo0000o3000l?030jo00`jo300To?0"
            A$ = A$ + "0@no000io300To?00@no000io300To?00@no000io300To?00Tmo0<PTo3000l?000`o04`_o300Uo?000noC>YloWJZeoOZYFoo"
            A$ = A$ + "YVJmoWJZeoOZYFooYVJmo?iTbo?000no00Pfo3@0[n?000`o0000o3000o?004no000goc=gjooooooooooooooooooooooooooo"
            A$ = A$ + "oooooo?gL[oo000go300Ho?00\jo0000o3000l?00Ljo000ho300HoOXQ2oojZ;mo[[^do_^jBoojZ;mo[[^do_^jBooQ6:lo300"
            A$ = A$ + "Ho?00@mo000Uo3000l?000`o00PHo300Ro?00@mo000eo300Do?00@mo000eo300Do?00@mo000eo300Do?00@mo00`co300Fm?0"
            A$ = A$ + "00`o0000o3007l?00hlo000fo300@o?000mo000do300@o?000mo000do300@o?000mo00`co300in?00H`o0000o3000l?000`o"
            A$ = A$ + "000=o300Io?00@mo00@co300<o?00`lo000co300<o?00`lo00@co3007o?00dbo0000o3000l?000`o0000o3000l?00lbo000`"
            A$ = A$ + "o300Fo?000mo00@co300<o?00dlo00Pco300cn?00Tbo0000o3000l?000`o0000o3000l?000`o0000o3003l?00`do00`So300"
            A$ = A$ + "Zn?00Tjo00PRo3006m?00<`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o3000l?0"
            A$ = A$ + "00`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o"
            A$ = A$ + "0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000"
            A$ = A$ + "o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o300"
            A$ = A$ + "0l?000`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o3000l?0"
            A$ = A$ + "00`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o"
            A$ = A$ + "0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o[ZYWn_ZVNjo0000o3000l?000`oZJjYo[ZYWn?000`o0000"
            A$ = A$ + "o3000l_ZVNjoZJjYo3000l?000`o0000o[ZYWn_ZVNjoZJjYo[ZYWn?000`oZJjYo[ZYWn_ZVNjoZJjYo3000l_ZVNjoZJjYo[ZY"
            A$ = A$ + "Wn_ZVNjo0000o3000l_ZVNjoZJjYo[ZYWn_ZVNjo0000o[ZYWn_ZVNjoZJjYo[ZYWn?000`oZJjYo[ZYWn_ZVNjoZJjYo3000l?0"
            A$ = A$ + "00`o0000o[ZYWn_ZVNjo0000o3000l?000`oZJjYo[ZYWn?000`o0000o3000l_ZVNjoZJjYo3000l?000`o0000o3000l?000`o"
            A$ = A$ + "0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000"
            A$ = A$ + "o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o300"
            A$ = A$ + "0l?000`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o3000l?0"
            A$ = A$ + "00`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o"
            A$ = A$ + "0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o0000o3000l?000`o%%%0"
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
    DIM MemoryBlock AS _MEM, TempImage AS LONG, NextSlot AS LONG
    DIM NewWidth AS INTEGER, NewHeight AS INTEGER, A$, BASFILE$

    A$ = EditorImageData$(FileName$)
    IF LEN(A$) = 0 THEN EXIT FUNCTION

    NewWidth = CVI(LEFT$(A$, 2))
    NewHeight = CVI(MID$(A$, 3, 2))
    A$ = MID$(A$, 5)

    BASFILE$ = Unpack$(A$)

    TempImage = _NEWIMAGE(NewWidth, NewHeight, 32)
    MemoryBlock = _MEMIMAGE(TempImage)

    __UI_MemCopy MemoryBlock.OFFSET, _OFFSET(BASFILE$), LEN(BASFILE$)
    _MEMFREE MemoryBlock

    LoadEditorImage& = TempImage
END FUNCTION

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
    DIM NewParentID AS STRING, FloatValue AS _FLOAT, Dummy AS LONG
    DIM BinaryFileNum AS INTEGER

    IF _FILEEXISTS("InForm/UiEditorPreview.frmbin") = 0 THEN
        EXIT SUB
    ELSE
        TIMER(__UI_EventsTimer) OFF
        TIMER(__UI_RefreshTimer) OFF

        BinaryFileNum = FREEFILE
        OPEN "InForm/UiEditorPreview.frmbin" FOR BINARY AS #BinaryFileNum

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
        REDIM PreviewParentIDS(0 TO CVL(b$)) AS STRING

        b$ = SPACE$(2): GET #BinaryFileNum, , b$
        IF CVI(b$) <> -1 THEN GOTO LoadError
        DO
            b$ = SPACE$(4): GET #BinaryFileNum, , b$
            Dummy = CVL(b$)
            IF Dummy <= 0 OR Dummy > UBOUND(PreviewControls) THEN EXIT DO 'Corrupted exchange file.
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
            IF CVI(b$) > 0 THEN
                NewParentID = SPACE$(CVI(b$)): GET #BinaryFileNum, , NewParentID
            ELSE
                NewParentID = ""
            END IF

            PreviewControls(Dummy).ID = Dummy
            PreviewParentIDS(Dummy) = RTRIM$(NewParentID)
            PreviewControls(Dummy).Type = NewType
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
                        PreviewControls(Dummy).Stretch = True
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
                        PreviewControls(Dummy).HasBorder = True
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
                        PreviewControls(Dummy).ShowPercentage = True
                    CASE -20
                        PreviewControls(Dummy).CanHaveFocus = True
                    CASE -21
                        PreviewControls(Dummy).Disabled = True
                    CASE -22
                        PreviewControls(Dummy).Hidden = True
                    CASE -23
                        PreviewControls(Dummy).CenteredWindow = True
                    CASE -24 'Tips
                        b$ = SPACE$(4): GET #BinaryFileNum, , b$
                        b$ = SPACE$(CVL(b$))
                        GET #BinaryFileNum, , b$
                        PreviewTips(Dummy) = b$
                    CASE -26
                        b$ = SPACE$(LEN(FloatValue)): GET #BinaryFileNum, , b$
                        PreviewControls(Dummy).Interval = _CV(_FLOAT, b$)
                    CASE -27
                        PreviewControls(Dummy).WordWrap = True
                    CASE -29
                        PreviewControls(Dummy).CanResize = True
                    CASE -30
                        b$ = SPACE$(2): GET #BinaryFileNum, , b$
                        PreviewControls(Dummy).HotKeyPosition = CVI(b$)
                    CASE -31
                        b$ = SPACE$(2): GET #BinaryFileNum, , b$
                        PreviewControls(Dummy).Padding = CVI(b$)
                    CASE -32
                        b$ = SPACE$(1): GET #BinaryFileNum, , b$
                        PreviewControls(Dummy).VAlign = _CV(_BYTE, b$)
                    CASE -33
                        PreviewControls(Dummy).PasswordField = True
                    CASE -34
                        b$ = SPACE$(4): GET #BinaryFileNum, , b$
                        PreviewControls(Dummy).Encoding = CVL(b$)
                    CASE -1 'new control
                        EXIT DO
                    CASE -1024
                        __UI_EOF = True
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
    OPEN "InForm/UiEditor.dat" FOR BINARY AS #FileNum

    'Send the data first, then the signal
    PUT #FileNum, OffsetPropertyValue, b$
    b$ = MKI$(Property): PUT #FileNum, OffsetPropertyChanged, b$
    b$ = MKI$(-1): PUT #FileNum, OffsetNewDataFromEditor, b$
    CLOSE #FileNum
    Edited = True
END SUB

SUB SendSignal (Value AS INTEGER)
    DIM FileNum AS INTEGER, b$
    FileNum = FREEFILE
    OPEN "InForm/UiEditor.dat" FOR BINARY AS #FileNum

    b$ = MKI$(Value): PUT #FileNum, OffsetNewDataFromEditor, b$
    CLOSE #FileNum
END SUB

SUB UpdateColorPreview (Attribute AS _BYTE, ForeColor AS _UNSIGNED LONG, BackColor AS _UNSIGNED LONG)
    DIM PreviewWord$
    _DEST Control(ColorPreviewID).HelperCanvas
    _FONT Control(ColorPreviewID).Font
    PreviewWord$ = "Preview"
    IF Control(ColorPropertiesListID).Value = 5 THEN
        CLS , BackColor
        LINE (20, 20)-STEP(_WIDTH - 41, _HEIGHT - 41), ForeColor, B
    ELSE
        CLS , BackColor
        COLOR ForeColor, BackColor
        _PRINTSTRING (_WIDTH \ 2 - _PRINTWIDTH(PreviewWord$) \ 2, _HEIGHT \ 2 - _FONTHEIGHT \ 2), PreviewWord$
    END IF
    _DEST 0
    Control(ColorPreviewID).PreviousValue = 0 'Force update
END SUB

SUB QuickColorPreview (ThisColor AS _UNSIGNED LONG)
    _DEST Control(ColorPreviewID).HelperCanvas
    CLS , ThisColor
    _DEST 0
    Control(ColorPreviewID).PreviousValue = 0 'Force update
END SUB

SUB CheckPreview
    'Check if the preview window is still alive
    DIM b$, UiEditorFile AS INTEGER

    IF OpenDialogOpen THEN EXIT SUB

    UiEditorFile = FREEFILE
    OPEN "InForm/UiEditor.dat" FOR BINARY AS #UiEditorFile
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
                Control(__UI_GetID("ViewMenuPreview")).Disabled = True
            ELSE
                'Preview was closed.
                TIMER(__UI_EventsTimer) OFF
                Control(__UI_GetID("ViewMenuPreview")).Disabled = False
                __UI_WaitMessage = "Reloading preview window..."
                OPEN "InForm/UiEditor.dat" FOR BINARY AS #UiEditorFile
                b$ = MKL$(0): PUT #UiEditorFile, OffsetPreviewPID, b$
                CLOSE #UiEditorFile
                UiPreviewPID = 0
                SHELL _DONTWAIT ".\InForm\UiEditorPreview.exe"
                __UI_LastInputReceived = 0 'Make the "Please wait" message show up immediataly
                DO
                    _LIMIT 10
                    OPEN "InForm/UiEditor.dat" FOR BINARY AS #UiEditorFile
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
        Control(__UI_GetID("ViewMenuPreview")).Disabled = False
        __UI_WaitMessage = "Reloading preview window..."
        OPEN "InForm/UiEditor.dat" FOR BINARY AS #UiEditorFile
        b$ = MKL$(0): PUT #UiEditorFile, OffsetPreviewPID, b$
        CLOSE #UiEditorFile
        UiPreviewPID = 0
        SHELL _DONTWAIT "./InForm/UiEditorPreview"
        __UI_LastInputReceived = 0 'Make the "Please wait" message show up immediataly
        DO
        _LIMIT 10
        OPEN "InForm/UiEditor.dat" FOR BINARY AS #UiEditorFile
        b$ = SPACE$(4)
        GET #UiEditorFile, OffsetPreviewPID, b$
        CLOSE #UiEditorFile
        LOOP UNTIL CVL(b$) > 0

        UiPreviewPID = CVL(b$)

        TIMER(__UI_EventsTimer) ON
        ELSE
        'Preview is active.
        Control(__UI_GetID("ViewMenuPreview")).Disabled = True
        END IF
        END IF
    $END IF
END SUB

SUB SaveForm (ExitToQB64 AS _BYTE, SaveOnlyFrm AS _BYTE)
    DIM BaseOutputFileName AS STRING, BinaryFileNum AS INTEGER
    DIM TextFileNum AS INTEGER, Answer AS _BYTE, b$, i AS LONG
    DIM a$, FontSetup$, FindSep AS INTEGER, NewFontFile AS STRING
    DIM NewFontSize AS INTEGER, Dummy AS LONG, BackupFile$

    BaseOutputFileName = RTRIM$(PreviewControls(PreviewFormID).Name)
    IF _FILEEXISTS(BaseOutputFileName + ".bas") OR _FILEEXISTS(BaseOutputFileName + ".frmbin") OR _FILEEXISTS(BaseOutputFileName + ".bas") THEN
        Answer = MessageBox("Some files will be overwritten. Proceed?", "", MsgBox_YesNo + MsgBox_Question)
        IF Answer = MsgBox_No THEN EXIT SUB
    END IF

    'Backup existing files
    FOR i = 1 TO 3
        IF i = 1 THEN
            IF SaveOnlyFrm THEN
                GOTO SkipSavingBas
            ELSE
                BackupFile$ = BaseOutputFileName + ".bas"
            END IF
        END IF
        IF i = 2 THEN BackupFile$ = BaseOutputFileName + ".frmbin"
        IF i = 3 THEN BackupFile$ = BaseOutputFileName + ".frm"

        IF _FILEEXISTS(BackupFile$) THEN
            TextFileNum = FREEFILE
            OPEN BackupFile$ FOR BINARY AS #TextFileNum
            b$ = SPACE$(LOF(TextFileNum))
            GET #TextFileNum, 1, b$
            CLOSE #TextFileNum

            TextFileNum = FREEFILE
            OPEN BackupFile$ + "-backup" FOR BINARY AS #TextFileNum
            PUT #TextFileNum, 1, b$
            CLOSE #TextFileNum
        END IF
        SkipSavingBas:
    NEXT

    TextFileNum = FREEFILE
    OPEN BaseOutputFileName + ".frm" FOR OUTPUT AS #TextFileNum
    IF _FILEEXISTS(BaseOutputFileName + ".frmbin") THEN KILL BaseOutputFileName + ".frmbin"
    BinaryFileNum = FREEFILE
    OPEN BaseOutputFileName + ".frmbin" FOR BINARY AS #BinaryFileNum
    PRINT #TextFileNum, "': This form was generated by"
    PRINT #TextFileNum, "': InForm - GUI system for QB64 - "; __UI_Version
    PRINT #TextFileNum, "': Fellippe Heitor, 2016 - fellippe@qb64.org - @fellippeheitor"
    PRINT #TextFileNum, "'-----------------------------------------------------------"
    PRINT #TextFileNum, "SUB __UI_LoadForm"
    PRINT #TextFileNum,
    IF LEN(PreviewTexts(PreviewFormID)) > 0 THEN
        PRINT #TextFileNum, "    $EXEICON:'" + PreviewTexts(PreviewFormID) + "'"
        PRINT #TextFileNum, "    _ICON"
    END IF
    IF PreviewControls(PreviewFormID).CanResize THEN
        PRINT #TextFileNum, "    $RESIZE:ON"
    END IF
    PRINT #TextFileNum, "    DIM __UI_NewID AS LONG"
    PRINT #TextFileNum,
    b$ = "InForm" + CHR$(1)
    PUT #BinaryFileNum, 1, b$
    b$ = MKL$(UBOUND(PreviewControls))
    PUT #BinaryFileNum, , b$

    'First pass is for the main form and containers (frames and menubars).
    'Second pass is for the rest of controls.
    'Controls named __UI_+anything are ignored, as they are automatically created.
    DIM ThisPass AS _BYTE
    FOR ThisPass = 1 TO 2
        FOR i = 1 TO UBOUND(PreviewControls)
            IF PreviewControls(i).ID > 0 AND PreviewControls(i).Type <> __UI_Type_MenuPanel AND PreviewControls(i).Type <> __UI_Type_Font AND LEN(RTRIM$(PreviewControls(i).Name)) > 0 THEN
                IF UCASE$(LEFT$(PreviewControls(i).Name, 5)) = "__UI_" THEN GOTO EndOfThisPass 'Internal controls
                a$ = "    __UI_NewID = __UI_NewControl("
                SELECT CASE PreviewControls(i).Type
                    CASE __UI_Type_Form: a$ = a$ + "__UI_Type_Form, ": IF ThisPass = 2 THEN GOTO EndOfThisPass
                    CASE __UI_Type_Frame: a$ = a$ + "__UI_Type_Frame, ": IF ThisPass = 2 THEN GOTO EndOfThisPass
                    CASE __UI_Type_Button: a$ = a$ + "__UI_Type_Button, ": IF ThisPass = 1 THEN GOTO EndOfThisPass
                    CASE __UI_Type_Label: a$ = a$ + "__UI_Type_Label, ": IF ThisPass = 1 THEN GOTO EndOfThisPass
                    CASE __UI_Type_CheckBox: a$ = a$ + "__UI_Type_CheckBox, ": IF ThisPass = 1 THEN GOTO EndOfThisPass
                    CASE __UI_Type_RadioButton: a$ = a$ + "__UI_Type_RadioButton, ": IF ThisPass = 1 THEN GOTO EndOfThisPass
                    CASE __UI_Type_TextBox: a$ = a$ + "__UI_Type_TextBox, ": IF ThisPass = 1 THEN GOTO EndOfThisPass
                    CASE __UI_Type_ProgressBar: a$ = a$ + "__UI_Type_ProgressBar, ": IF ThisPass = 1 THEN GOTO EndOfThisPass
                    CASE __UI_Type_ListBox: a$ = a$ + "__UI_Type_ListBox, ": IF ThisPass = 1 THEN GOTO EndOfThisPass
                    CASE __UI_Type_DropdownList: a$ = a$ + "__UI_Type_DropdownList, ": IF ThisPass = 1 THEN GOTO EndOfThisPass
                    CASE __UI_Type_MenuBar: a$ = a$ + "__UI_Type_MenuBar, ": IF ThisPass = 2 THEN GOTO EndOfThisPass
                    CASE __UI_Type_MenuItem: a$ = a$ + "__UI_Type_MenuItem, ": IF ThisPass = 1 THEN GOTO EndOfThisPass
                    CASE __UI_Type_PictureBox: a$ = a$ + "__UI_Type_PictureBox, ": IF ThisPass = 1 THEN GOTO EndOfThisPass
                    CASE __UI_Type_TrackBar: a$ = a$ + "__UI_Type_TrackBar, ": IF ThisPass = 1 THEN GOTO EndOfThisPass
                    CASE __UI_Type_ContextMenu: a$ = a$ + "__UI_Type_ContextMenu, ": IF ThisPass = 1 THEN GOTO EndOfThisPass
                END SELECT
                a$ = a$ + CHR$(34) + RTRIM$(PreviewControls(i).Name) + CHR$(34) + ","
                a$ = a$ + STR$(PreviewControls(i).Width) + ","
                a$ = a$ + STR$(PreviewControls(i).Height) + ","
                a$ = a$ + STR$(PreviewControls(i).Left) + ","
                a$ = a$ + STR$(PreviewControls(i).Top) + ","
                IF LEN(PreviewParentIDS(i)) > 0 THEN
                    a$ = a$ + " __UI_GetID(" + CHR$(34) + PreviewParentIDS(i) + CHR$(34) + "))"
                ELSE
                    a$ = a$ + " 0)"
                END IF
                PRINT #TextFileNum, a$
                b$ = MKI$(-1) + MKL$(0) + MKI$(PreviewControls(i).Type) '-1 indicates a new control
                b$ = b$ + MKI$(LEN(RTRIM$(PreviewControls(i).Name)))
                b$ = b$ + RTRIM$(PreviewControls(i).Name)
                b$ = b$ + MKI$(PreviewControls(i).Width) + MKI$(PreviewControls(i).Height) + MKI$(PreviewControls(i).Left) + MKI$(PreviewControls(i).Top) + MKI$(LEN(PreviewParentIDS(i))) + PreviewParentIDS(i)
                PUT #BinaryFileNum, , b$

                IF LEN(PreviewCaptions(i)) > 0 THEN
                    'IF PreviewControls(i).HotKeyPosition > 0 THEN
                    '    a$ = LEFT$(PreviewCaptions(i), PreviewControls(i).HotKeyPosition - 1) + "&" + MID$(PreviewCaptions(i), PreviewControls(i).HotKeyPosition)
                    'ELSE
                    '    a$ = PreviewCaptions(i)
                    'END IF
                    a$ = "    SetCaption __UI_NewID, " + __UI_SpecialCharsToCHR$(PreviewCaptions(i))
                    b$ = MKI$(-2) + MKL$(LEN(PreviewCaptions(i))) '-2 indicates a caption
                    PUT #BinaryFileNum, , b$
                    PUT #BinaryFileNum, , PreviewCaptions(i)
                    PRINT #TextFileNum, a$
                END IF

                IF LEN(PreviewTips(i)) > 0 THEN
                    a$ = "    ToolTip(__UI_NewID) = " + __UI_SpecialCharsToCHR$(PreviewTips(i))
                    b$ = MKI$(-24) + MKL$(LEN(PreviewTips(i))) '-24 indicates a tip
                    PUT #BinaryFileNum, , b$
                    PUT #BinaryFileNum, , PreviewTips(i)
                    PRINT #TextFileNum, a$
                END IF

                IF LEN(PreviewTexts(i)) > 0 THEN
                    SELECT CASE PreviewControls(i).Type
                        CASE __UI_Type_ListBox, __UI_Type_DropdownList
                            DIM TempCaption$, TempText$, FindLF&, ThisItem%, ThisItemTop%
                            DIM LastVisibleItem AS INTEGER

                            TempText$ = PreviewTexts(i)
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
                                a$ = "    AddItem __UI_NewID, " + CHR$(34) + TempCaption$ + CHR$(34)
                                PRINT #TextFileNum, a$
                            LOOP
                        CASE __UI_Type_PictureBox, __UI_Type_Button
                            a$ = "    LoadImage Control(__UI_NewID), " + CHR$(34) + PreviewTexts(i) + CHR$(34)
                            PRINT #TextFileNum, a$
                        CASE ELSE
                            a$ = "    Text(__UI_NewID) = " + __UI_SpecialCharsToCHR$(PreviewTexts(i))
                            PRINT #TextFileNum, a$
                    END SELECT
                    b$ = MKI$(-3) + MKL$(LEN(PreviewTexts(i))) '-3 indicates a text
                    PUT #BinaryFileNum, , b$
                    PUT #BinaryFileNum, , PreviewTexts(i)
                END IF
                IF PreviewControls(i).TransparentColor > 0 THEN
                    PRINT #TextFileNum, "    __UI_ClearColor Control(__UI_NewID).HelperCanvas, " + LTRIM$(STR$(PreviewControls(i).TransparentColor)) + ", -1"
                    b$ = MKI$(-28) + _MK$(_UNSIGNED LONG, PreviewControls(i).TransparentColor)
                    PUT #BinaryFileNum, , b$
                END IF
                IF PreviewControls(i).Stretch THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).Stretch = True"
                    b$ = MKI$(-4)
                    PUT #BinaryFileNum, , b$
                END IF
                'Fonts
                IF LEN(PreviewFonts(i)) > 0 THEN
                    DIM NewFontParameters AS STRING
                    FontSetup$ = PreviewFonts(i)
                    b$ = MKI$(-5) + MKI$(LEN(FontSetup$)) + FontSetup$
                    PUT #BinaryFileNum, , b$

                    'Parse FontSetup$ into Font variables
                    FindSep = INSTR(FontSetup$, "*")
                    NewFontFile = LEFT$(FontSetup$, FindSep - 1)
                    FontSetup$ = MID$(FontSetup$, FindSep + 1)

                    FindSep = INSTR(FontSetup$, "*")
                    NewFontParameters = LEFT$(FontSetup$, FindSep - 1)
                    FontSetup$ = MID$(FontSetup$, FindSep + 1)

                    FontSetup$ = "SetFont(" + CHR$(34) + NewFontFile + CHR$(34) + ", " + FontSetup$ + ", " + CHR$(34) + NewFontParameters + CHR$(34) + ")"
                    PRINT #TextFileNum, "    Control(__UI_NewID).Font = " + FontSetup$
                END IF
                'Colors are saved only if they differ from the theme's defaults
                IF PreviewControls(i).ForeColor > 0 AND PreviewControls(i).ForeColor <> __UI_DefaultColor(PreviewControls(i).Type, 1) THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).ForeColor = _RGB32(" + LTRIM$(STR$(_RED32(PreviewControls(i).ForeColor))) + ", " + LTRIM$(STR$(_GREEN32(PreviewControls(i).ForeColor))) + ", " + LTRIM$(STR$(_BLUE32(PreviewControls(i).ForeColor))) + ")"
                    b$ = MKI$(-6) + _MK$(_UNSIGNED LONG, PreviewControls(i).ForeColor)
                    PUT #BinaryFileNum, , b$
                END IF
                IF PreviewControls(i).BackColor > 0 AND PreviewControls(i).BackColor <> __UI_DefaultColor(PreviewControls(i).Type, 2) THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).BackColor = _RGB32(" + LTRIM$(STR$(_RED32(PreviewControls(i).BackColor))) + ", " + LTRIM$(STR$(_GREEN32(PreviewControls(i).BackColor))) + ", " + LTRIM$(STR$(_BLUE32(PreviewControls(i).BackColor))) + ")"
                    b$ = MKI$(-7) + _MK$(_UNSIGNED LONG, PreviewControls(i).BackColor)
                    PUT #BinaryFileNum, , b$
                END IF
                IF PreviewControls(i).SelectedForeColor > 0 AND PreviewControls(i).SelectedForeColor <> __UI_DefaultColor(PreviewControls(i).Type, 3) THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).SelectedForeColor = _RGB32(" + LTRIM$(STR$(_RED32(PreviewControls(i).SelectedForeColor))) + ", " + LTRIM$(STR$(_GREEN32(PreviewControls(i).SelectedForeColor))) + ", " + LTRIM$(STR$(_BLUE32(PreviewControls(i).SelectedForeColor))) + ")"
                    b$ = MKI$(-8) + _MK$(_UNSIGNED LONG, PreviewControls(i).SelectedForeColor)
                    PUT #BinaryFileNum, , b$
                END IF
                IF PreviewControls(i).SelectedBackColor > 0 AND PreviewControls(i).SelectedBackColor <> __UI_DefaultColor(PreviewControls(i).Type, 4) THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).SelectedBackColor = _RGB32(" + LTRIM$(STR$(_RED32(PreviewControls(i).SelectedBackColor))) + ", " + LTRIM$(STR$(_GREEN32(PreviewControls(i).SelectedBackColor))) + ", " + LTRIM$(STR$(_BLUE32(PreviewControls(i).SelectedBackColor))) + ")"
                    b$ = MKI$(-9) + _MK$(_UNSIGNED LONG, PreviewControls(i).SelectedBackColor)
                    PUT #BinaryFileNum, , b$
                END IF
                IF PreviewControls(i).BorderColor > 0 AND PreviewControls(i).BorderColor <> __UI_DefaultColor(PreviewControls(i).Type, 5) THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).BorderColor = _RGB32(" + LTRIM$(STR$(_RED32(PreviewControls(i).BorderColor))) + ", " + LTRIM$(STR$(_GREEN32(PreviewControls(i).BorderColor))) + ", " + LTRIM$(STR$(_BLUE32(PreviewControls(i).BorderColor))) + ")"
                    b$ = MKI$(-10) + _MK$(_UNSIGNED LONG, PreviewControls(i).BorderColor)
                    PUT #BinaryFileNum, , b$
                END IF
                IF PreviewControls(i).BackStyle = __UI_Transparent THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).BackStyle = __UI_Transparent"
                    b$ = MKI$(-11): PUT #BinaryFileNum, , b$
                END IF
                IF PreviewControls(i).HasBorder THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).HasBorder = True"
                    b$ = MKI$(-12): PUT #BinaryFileNum, , b$
                END IF
                IF PreviewControls(i).Align = __UI_Center THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).Align = __UI_Center"
                    b$ = MKI$(-13) + _MK$(_BYTE, PreviewControls(i).Align): PUT #BinaryFileNum, , b$
                ELSEIF PreviewControls(i).Align = __UI_Right THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).Align = __UI_Right"
                    b$ = MKI$(-13) + _MK$(_BYTE, PreviewControls(i).Align): PUT #BinaryFileNum, , b$
                END IF
                IF PreviewControls(i).VAlign = __UI_Middle THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).VAlign = __UI_Middle"
                    b$ = MKI$(-32) + _MK$(_BYTE, PreviewControls(i).VAlign): PUT #BinaryFileNum, , b$
                ELSEIF PreviewControls(i).VAlign = __UI_Bottom THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).VAlign = __UI_Bottom"
                    b$ = MKI$(-32) + _MK$(_BYTE, PreviewControls(i).VAlign): PUT #BinaryFileNum, , b$
                END IF
                IF PreviewControls(i).PasswordField = True AND PreviewControls(i).Type = __UI_Type_TextBox THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).PasswordField = True"
                    b$ = MKI$(-33): PUT #BinaryFileNum, , b$
                END IF
                IF PreviewControls(i).Value <> 0 THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).Value = " + LTRIM$(STR$(PreviewControls(i).Value))
                    b$ = MKI$(-14) + _MK$(_FLOAT, PreviewControls(i).Value): PUT #BinaryFileNum, , b$
                END IF
                IF PreviewControls(i).Min <> 0 THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).Min = " + LTRIM$(STR$(PreviewControls(i).Min))
                    b$ = MKI$(-15) + _MK$(_FLOAT, PreviewControls(i).Min): PUT #BinaryFileNum, , b$
                END IF
                IF PreviewControls(i).Max <> 0 THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).Max = " + LTRIM$(STR$(PreviewControls(i).Max))
                    b$ = MKI$(-16) + _MK$(_FLOAT, PreviewControls(i).Max): PUT #BinaryFileNum, , b$
                END IF
                IF PreviewControls(i).ShowPercentage THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).ShowPercentage = True"
                    b$ = MKI$(-19): PUT #BinaryFileNum, , b$
                END IF
                IF PreviewControls(i).CanHaveFocus THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).CanHaveFocus = True"
                    b$ = MKI$(-20): PUT #BinaryFileNum, , b$
                END IF
                IF PreviewControls(i).Disabled THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).Disabled = True"
                    b$ = MKI$(-21): PUT #BinaryFileNum, , b$
                END IF
                IF PreviewControls(i).Hidden THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).Hidden = True"
                    b$ = MKI$(-22): PUT #BinaryFileNum, , b$
                END IF
                IF PreviewControls(i).CenteredWindow THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).CenteredWindow = True"
                    b$ = MKI$(-23): PUT #BinaryFileNum, , b$
                END IF
                IF PreviewControls(i).ContextMenuID THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).ContextMenuID = __UI_GetID(" + CHR$(34) + RTRIM$(PreviewControls(PreviewControls(i).ContextMenuID).Name) + CHR$(34) + ")"
                    b$ = MKI$(-25) + MKI$(LEN(RTRIM$(PreviewControls(PreviewControls(i).ContextMenuID).Name))) + RTRIM$(PreviewControls(PreviewControls(i).ContextMenuID).Name): PUT #BinaryFileNum, , b$
                END IF
                IF PreviewControls(i).Interval THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).Interval = " + LTRIM$(STR$(PreviewControls(i).Interval))
                    b$ = MKI$(-26) + _MK$(_FLOAT, PreviewControls(i).Interval): PUT #BinaryFileNum, , b$
                END IF
                IF PreviewControls(i).WordWrap THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).WordWrap = True"
                    b$ = MKI$(-27): PUT #BinaryFileNum, , b$
                END IF
                IF PreviewControls(i).CanResize AND PreviewControls(i).Type = __UI_Type_Form THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).CanResize = True"
                    b$ = MKI$(-29): PUT #BinaryFileNum, , b$
                END IF
                IF PreviewControls(i).Padding > 0 THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).Padding = " + LTRIM$(STR$(PreviewControls(i).Padding))
                    b$ = MKI$(-31) + MKI$(PreviewControls(i).Padding): PUT #BinaryFileNum, , b$
                END IF
                IF PreviewControls(i).Encoding > 0 THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).Encoding = " + LTRIM$(STR$(PreviewControls(i).Encoding))
                    b$ = MKI$(-34) + MKL$(PreviewControls(i).Encoding): PUT #BinaryFileNum, , b$
                END IF
                PRINT #TextFileNum,
            END IF
            EndOfThisPass:
        NEXT
    NEXT ThisPass

    b$ = MKI$(-1024): PUT #BinaryFileNum, , b$ 'end of file
    PRINT #TextFileNum, "END SUB"
    PRINT #TextFileNum,
    PRINT #TextFileNum, "SUB __UI_AssignIDs"
    FOR i = 1 TO UBOUND(PreviewControls)
        IF PreviewControls(i).ID > 0 AND PreviewControls(i).Type <> __UI_Type_Font AND PreviewControls(i).Type <> __UI_Type_MenuPanel AND PreviewControls(i).Type <> __UI_Type_ContextMenu THEN
            PRINT #TextFileNum, "    " + RTRIM$(__UI_TrimAt0$(PreviewControls(i).Name)) + " = __UI_GetID(" + CHR$(34) + RTRIM$(__UI_TrimAt0$(PreviewControls(i).Name)) + CHR$(34) + ")"
        END IF
    NEXT
    PRINT #TextFileNum, "END SUB"
    CLOSE #TextFileNum, #BinaryFileNum
    IF NOT SaveOnlyFrm THEN
        OPEN BaseOutputFileName + ".bas" FOR OUTPUT AS #TextFileNum
        PRINT #TextFileNum, "': This program was generated by"
        PRINT #TextFileNum, "': InForm - GUI system for QB64 - "; __UI_Version
        PRINT #TextFileNum, "': Fellippe Heitor, 2016 - fellippe@qb64.org - @fellippeheitor"
        PRINT #TextFileNum, "'-----------------------------------------------------------"
        PRINT #TextFileNum,
        PRINT #TextFileNum, "': Controls' IDs: ------------------------------------------------------------------"
        FOR i = 1 TO UBOUND(PreviewControls)
            IF PreviewControls(i).ID > 0 AND PreviewControls(i).Type <> __UI_Type_Font AND PreviewControls(i).Type <> __UI_Type_MenuPanel AND PreviewControls(i).Type <> __UI_Type_ContextMenu THEN
                PRINT #TextFileNum, "DIM SHARED " + RTRIM$(__UI_TrimAt0$(PreviewControls(i).Name)) + " AS LONG"
            END IF
        NEXT
        PRINT #TextFileNum,
        PRINT #TextFileNum, "': External modules: ---------------------------------------------------------------"
        PRINT #TextFileNum, "'$INCLUDE:'InForm\InForm.ui'"
        PRINT #TextFileNum, "'$INCLUDE:'InForm\xp.uitheme'"
        PRINT #TextFileNum, "'$INCLUDE:'" + BaseOutputFileName + ".frm'"
        PRINT #TextFileNum,
        PRINT #TextFileNum, "': Event procedures: ---------------------------------------------------------------"
        FOR i = 0 TO 13
            SELECT EVERYCASE i
                CASE 0: PRINT #TextFileNum, "SUB __UI_BeforeInit"
                CASE 1: PRINT #TextFileNum, "SUB __UI_OnLoad"
                CASE 2: PRINT #TextFileNum, "SUB __UI_BeforeUpdateDisplay"
                CASE 3: PRINT #TextFileNum, "SUB __UI_BeforeUnload"
                CASE 4: PRINT #TextFileNum, "SUB __UI_Click (id AS LONG)"
                CASE 5: PRINT #TextFileNum, "SUB __UI_MouseEnter (id AS LONG)"
                CASE 6: PRINT #TextFileNum, "SUB __UI_MouseLeave (id AS LONG)"
                CASE 7: PRINT #TextFileNum, "SUB __UI_FocusIn (id AS LONG)"
                CASE 8: PRINT #TextFileNum, "SUB __UI_FocusOut (id AS LONG)"
                CASE 9: PRINT #TextFileNum, "SUB __UI_MouseDown (id AS LONG)"
                CASE 10: PRINT #TextFileNum, "SUB __UI_MouseUp (id AS LONG)"
                CASE 11: PRINT #TextFileNum, "SUB __UI_KeyPress (id AS LONG)"
                CASE 12: PRINT #TextFileNum, "SUB __UI_TextChanged (id AS LONG)"
                CASE 13: PRINT #TextFileNum, "SUB __UI_ValueChanged (id AS LONG)"

                CASE 0 TO 3
                    PRINT #TextFileNum,

                CASE 4 TO 6, 9, 10 'All controls except for Menu panels, and internal context menus
                    PRINT #TextFileNum, "    SELECT CASE id"
                    FOR Dummy = 1 TO UBOUND(PreviewControls)
                        IF PreviewControls(Dummy).ID > 0 AND PreviewControls(Dummy).Type <> __UI_Type_Font AND PreviewControls(Dummy).Type <> __UI_Type_ContextMenu THEN
                            PRINT #TextFileNum, "        CASE " + RTRIM$(PreviewControls(Dummy).Name)
                            PRINT #TextFileNum,
                        END IF
                    NEXT
                    PRINT #TextFileNum, "    END SELECT"

                CASE 7, 8, 11 'Controls that can have focus only
                    PRINT #TextFileNum, "    SELECT CASE id"
                    FOR Dummy = 1 TO UBOUND(PreviewControls)
                        IF PreviewControls(Dummy).ID > 0 AND PreviewControls(Dummy).CanHaveFocus THEN
                            PRINT #TextFileNum, "        CASE " + RTRIM$(PreviewControls(Dummy).Name)
                            PRINT #TextFileNum,
                        END IF
                    NEXT
                    PRINT #TextFileNum, "    END SELECT"

                CASE 12 'Text boxes
                    PRINT #TextFileNum, "    SELECT CASE id"
                    FOR Dummy = 1 TO UBOUND(PreviewControls)
                        IF PreviewControls(Dummy).ID > 0 AND (PreviewControls(Dummy).Type = __UI_Type_TextBox) THEN
                            PRINT #TextFileNum, "        CASE " + RTRIM$(PreviewControls(Dummy).Name)
                            PRINT #TextFileNum,
                        END IF
                    NEXT
                    PRINT #TextFileNum, "    END SELECT"

                CASE 13 'Dropdown list, List box and Track bar
                    PRINT #TextFileNum, "    SELECT CASE id"
                    FOR Dummy = 1 TO UBOUND(PreviewControls)
                        IF PreviewControls(Dummy).ID > 0 AND (PreviewControls(Dummy).Type = __UI_Type_ListBox OR PreviewControls(Dummy).Type = __UI_Type_DropdownList OR PreviewControls(Dummy).Type = __UI_Type_TrackBar) THEN
                            PRINT #TextFileNum, "        CASE " + RTRIM$(PreviewControls(Dummy).Name)
                            PRINT #TextFileNum,
                        END IF
                    NEXT
                    PRINT #TextFileNum, "    END SELECT"
            END SELECT
            PRINT #TextFileNum, "END SUB"
            PRINT #TextFileNum,
        NEXT
        CLOSE #TextFileNum
    END IF

    b$ = "Exporting successful. Files output:" + CHR$(10)
    IF NOT SaveOnlyFrm THEN b$ = b$ + "    " + BaseOutputFileName + ".bas" + CHR$(10)
    b$ = b$ + "    " + BaseOutputFileName + ".frm" + CHR$(10) + "    " + BaseOutputFileName + ".frmbin"

    IF ExitToQB64 THEN
        $IF WIN THEN
            IF _FILEEXISTS("qb64.exe") THEN
                b$ = b$ + CHR$(10) + CHR$(10) + "Exit to QB64?"
            ELSE
                b$ = b$ + CHR$(10) + CHR$(10) + "Close the editor?"
            END IF
        $ELSE
            IF _FILEEXISTS("qb64") THEN
            b$ = b$ + CHR$(10) + CHR$(10) + "Exit to QB64?"
            ELSE
            b$ = b$ + CHR$(10) + CHR$(10) + "Close the editor?"
            END IF
        $END IF
        Answer = MessageBox(b$, "", MsgBox_YesNo + MsgBox_Question)
        IF Answer = MsgBox_No THEN Edited = False: EXIT SUB
        $IF WIN THEN
            IF _FILEEXISTS("qb64.exe") THEN SHELL _DONTWAIT "qb64.exe " + BaseOutputFileName + ".bas"
        $ELSE
            IF _FILEEXISTS("qb64") THEN SHELL _DONTWAIT "./qb64 " + BaseOutputFileName + ".bas"
        $END IF
        SYSTEM
    ELSE
        Answer = MessageBox(b$, "", MsgBox_OkOnly + MsgBox_Information)
    END IF
END SUB

'$IF WIN THEN
'    SUB LoadFontList
'        DIM hKey AS _OFFSET
'        DIM Ky AS _OFFSET
'        DIM SubKey AS STRING
'        DIM Value AS STRING
'        DIM bData AS STRING
'        DIM t AS STRING
'        DIM dwType AS _UNSIGNED LONG
'        DIM numBytes AS _UNSIGNED LONG
'        DIM numTchars AS _UNSIGNED LONG
'        DIM l AS LONG
'        DIM dwIndex AS _UNSIGNED LONG

'        Ky = HKEY_LOCAL_MACHINE
'        SubKey = "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" + CHR$(0)
'        Value = SPACE$(261) 'ANSI Value name limit 260 chars + 1 null
'        bData = SPACE$(&H7FFF) 'arbitrary

'        l = RegOpenKeyExA(Ky, _OFFSET(SubKey), 0, KEY_READ, _OFFSET(hKey))
'        IF l THEN
'            AddItem __UI_GetID("FontList"), "Access to fonts failed."
'            EXIT SUB
'        ELSE
'            dwIndex = 0
'            DO
'                numBytes = LEN(bData)
'                numTchars = LEN(Value)
'                l = RegEnumValueA(hKey, dwIndex, _OFFSET(Value), _OFFSET(numTchars), 0, _OFFSET(dwType), _OFFSET(bData), _OFFSET(numBytes))
'                IF l THEN
'                    IF l <> ERROR_NO_MORE_ITEMS THEN
'                        AddItem __UI_GetID("FontList"), "Access to fonts failed."
'                    END IF
'                    EXIT DO
'                ELSE
'                    IF UCASE$(RIGHT$(formatData(dwType, numBytes, bData), 4)) = ".TTF" THEN
'                        AddItem __UI_GetID("FontList"), LEFT$(Value, numTchars) + " = " + formatData(dwType, numBytes, bData)
'                    END IF
'                END IF
'                dwIndex = dwIndex + 1
'            LOOP
'            l = RegCloseKey(hKey)
'        END IF
'    END SUB

'    FUNCTION whatType$ (dwType AS _UNSIGNED LONG)
'        SELECT CASE dwType
'            CASE REG_SZ: whatType = "REG_SZ"
'            CASE REG_EXPAND_SZ: whatType = "REG_EXPAND_SZ"
'            CASE REG_BINARY: whatType = "REG_BINARY"
'            CASE REG_DWORD: whatType = "REG_DWORD"
'            CASE REG_DWORD_BIG_ENDIAN: whatType = "REG_DWORD_BIG_ENDIAN"
'            CASE REG_LINK: whatType = "REG_LINK"
'            CASE REG_MULTI_SZ: whatType = "REG_MULTI_SZ"
'            CASE REG_RESOURCE_LIST: whatType = "REG_RESOURCE_LIST"
'            CASE REG_FULL_RESOURCE_DESCRIPTOR: whatType = "REG_FULL_RESOURCE_DESCRIPTOR"
'            CASE REG_RESOURCE_REQUIREMENTS_LIST: whatType = "REG_RESOURCE_REQUIREMENTS_LIST"
'            CASE REG_QWORD: whatType = "REG_QWORD"
'            CASE ELSE: whatType = "unknown"
'        END SELECT
'    END FUNCTION

'    FUNCTION whatKey$ (hKey AS _OFFSET)
'        SELECT CASE hKey
'            CASE HKEY_CLASSES_ROOT: whatKey = "HKEY_CLASSES_ROOT"
'            CASE HKEY_CURRENT_USER: whatKey = "HKEY_CURRENT_USER"
'            CASE HKEY_LOCAL_MACHINE: whatKey = "HKEY_LOCAL_MACHINE"
'            CASE HKEY_USERS: whatKey = "HKEY_USERS"
'            CASE HKEY_PERFORMANCE_DATA: whatKey = "HKEY_PERFORMANCE_DATA"
'            CASE HKEY_CURRENT_CONFIG: whatKey = "HKEY_CURRENT_CONFIG"
'            CASE HKEY_DYN_DATA: whatKey = "HKEY_DYN_DATA"
'        END SELECT
'    END FUNCTION

'    FUNCTION formatData$ (dwType AS _UNSIGNED LONG, numBytes AS _UNSIGNED LONG, bData AS STRING)
'        DIM t AS STRING
'        DIM ul AS _UNSIGNED LONG
'        DIM b AS _UNSIGNED _BYTE
'        SELECT CASE dwType
'            CASE REG_SZ, REG_EXPAND_SZ, REG_MULTI_SZ
'                formatData = LEFT$(bData, numBytes - 1)
'            CASE REG_DWORD
'                t = LCASE$(HEX$(CVL(LEFT$(bData, 4))))
'                formatData = "0x" + STRING$(8 - LEN(t), &H30) + t
'            CASE ELSE
'                IF numBytes THEN
'                    b = ASC(LEFT$(bData, 1))
'                    IF b < &H10 THEN
'                        t = t + "0" + LCASE$(HEX$(b))
'                    ELSE
'                        t = t + LCASE$(HEX$(b))
'                    END IF
'                END IF
'                FOR ul = 2 TO numBytes
'                    b = ASC(MID$(bData, ul, 1))
'                    IF b < &H10 THEN
'                        t = t + " 0" + LCASE$(HEX$(b))
'                    ELSE
'                        t = t + " " + LCASE$(HEX$(b))
'                    END IF
'                NEXT
'                formatData = t
'        END SELECT
'    END FUNCTION
'$END IF

SUB RestoreFalcon
    DIM A$, B$, FileNum AS INTEGER
    A$ = ""
    A$ = A$ + "STVKSaFMTE68RTVKdEVL^56K_<f;`5VLd=g;fU6IUmf;VmVKdm2MdIf;c9gH_HVLUE6Mi1GIQeFH\MFH]i2JRdP2_l2EXE68Vm6K"
    A$ = A$ + "\mfMYifIP`FJSEVKcE68Q17L\UFIc12M_1BMdI6>TEfH_AFIXT28Qi6IP4fLcmfHY56MUA68T56MQ1bK^aFN=X`;_0b@_1GNbUfI"
    A$ = A$ + "XA78X<F:P83<`PC;b0C<`0R@ZmFIbi688mFIX9GKQiVKP`SHZmFIbi6@XmFIX9GKQiVK^@FIndP2_l28CEFIPP6Md1W>_lRHZmFI"
    A$ = A$ + "biV;XmFIX9GKQiVK^@FI_D7MVe2>_@FISm6IU9g;TIFH_0RI_978TE6MQU6KciB3:lR:P0EIbeFJc=GJ_i68Y=78XEVLU9FNPLVL"
    A$ = A$ + "Qi6MUA6;PHVLUE68_I68SQFHbMFI\02M_1BH^U78`EVLcmVKPlVHd5FJ^UVKW1BHP<fK`U78_I68dQFJc1bL_I6Mg5VLU1BH^A68"
    A$ = A$ + "Q=gL_=FJQAGIT12I_=FM]EVKd56MYmVKPHFJ\EfLPP2MXE68R<eKVAgMQ9GIRT2;P@gKP@FIQa68Yi68dQFIP<eKVAgMQ9GIPLGJ"
    A$ = A$ + "dQfKeA78bEfLd9GJSAGJ_i6;PTVKSaFMTUVKW1bMYA7J_E7MP`FJ]U6MQAGJ_i68dQFIP8GJWQ6Mc12M_1BMcE6;P<fK`U7;PdfK"
    A$ = A$ + "TUVIia28]EVLWE6;P0GMRaFJcQ6;P@FJcAWLY9FMdE6;P<GMRaFJSEVKcE6;P4VKTmbKb1bLUa6KP<fK`UFIc1bKV12MXE68CmVI"
    A$ = A$ + "dMGHbE6;P4VKT12M_12LU9GKYA78`EVLcmVKc12M_1bMXmFKP@7JU1bD_I6Mg5VLU1BJc1RIe9WKY=7JUA68dm68Tm68cm6;P<GM"
    A$ = A$ + "RYFISA78dm68dQFIPHfK\afKgUVKW1bH_i6IYAGJ_ifLjdP2=X0EXE68Q9fKfE68Sm6Li9GJWQ6MPhfKdUfHU1BH^A68dQFJc12L"
    A$ = A$ + "U9GKY=gLYmVKPhfKdUfHU1bLX56K\1RHU1BJ^=6KeAFIT1BJ^1BH\a68Sm6LYEfLPlVLP<GMR=7MQi6MY56KP0gKbAGJ_ifLPlVI"
    A$ = A$ + "P@7JU1bD_I6Mg5VLUiB3:dP2DQDAP<eC6AeE19EAPTdDP0UD?IEB4E4AP8B@C1BBC92;PLEBDQdCEA58G5TDB5TCDU58?I481iDF"
    A$ = A$ + "P\DB>A4;PD4F@9EAC=58?9589e4D<UDA4a289id@<E5A9idAP8DED1RC?A58<UDC9AEA412E?12E8E48G5TDB5TCDUDAC1bC61BC"
    A$ = A$ + "59e@85TCD5T@9aDBDU5;PHDBDiDAC=586mTDP448@5TDDUd@EaD@B12DE95D?=EAP4TC41RC?iDB>ITD9idA5eDA>AU;PTTCPhdC"
    A$ = A$ + "PDTE5i4EP<5B1a4CP@5B51B@EA5B?9eDPlTDP<dC@UUD9M4BD12B?a4A59eDP8DAP`DB194C51RA?9581iDFP<4C1UDC\02A1eD@"
    A$ = A$ + "7EdDPlTDPl4E8ETDP`DB19DB<U4EIa28GQDADQDAB1BB>1B@>1B@3AEB?i48?I483mTCD9E@3A5;P@eCBA58?958?A5B59eE9=EA"
    A$ = A$ + "\0B@BUdD9idAPHTD?e4;PlDED1bC61bCB1BB>1b@?iTC5=4E9mTCPLEBDQ48DQDAP<eC6AeE19EAPlTDP@5B51BECE48?958?A5B"
    A$ = A$ + "59584ED@<UTC7=589i48DQDAP<eC6AeE19EA^0R:_dP2=X`8TEVIYiFIPD5E6QcG1=d@515EP0C3:<2IUIFJ^E68EAUAhlUD5YDA"
    A$ = A$ + "3A58adP2cAGHdUfHP<fK^=7MPDGJ^A7>OA78eAWIh@fFM1B?P\G3:028``2<\03;``2<\03;``2<\03;``2<\03;``2<\03;``2<"
    A$ = A$ + "\03;``2<\03;``2<\03;``2<\03;``2<\03;``2<\0b;_02<`hR;aHF3:028``2<\03;``2<\03;``2<\03;``2<\03;``2<\03;"
    A$ = A$ + "``2<\03;``2<\03;``2<\03;``2<\03;``2<\03;``2<\0b;_0R<`hR;cHF3:028``2<\03;``2<\03;``2<\03;``2<\03;``2<"
    A$ = A$ + "\03;``2<\03;``2<\03;``2<\03;``2<\03;``2<\03;``2<\0b;_02=`hR;eHF3:028``2<\03;``2<\03;``2<\03;``2<\03;"
    A$ = A$ + "``2<\03;``2<\03;``2<\03;``2<\03;``2<\03;``2<\03;``2<\0b;_0R=`hR;gHF3:028a`B<\43;a`B<\43;a`B<\43;a`B<"
    A$ = A$ + "\43;a`B<\43;a`B>\T3;i`B>\T3;i`B>\T3;i`B>\T3;i`B>\T3;i`B>\0b;_02>`hR;iHF3:028g`b=\L3;g`b=\L3;g`b=\L3;"
    A$ = A$ + "g`b=\L3;g`b=\L3;g`b=\L3;g`b=\L3;g`b=\L3;g`b=\L3;g`b=\L3;g`b=\0b;_0BH`hR;RIF3:028h`2>\83;b`R<\83;b`R<"
    A$ = A$ + "\83;b`R<\83;b`R<\83;b`R<\83;b`R<\83;b`R<\83;b`R<\83;b`R<\83;b`R<\0b;_0bH`hR;TIF3:028`PGH\03Nc`2<h=3;"
    A$ = A$ + "`Pg<\03Nc`2<h=3;`Pg<\03Nc`2<h=3;`Pg<\03Nc`2<h=3;`Pg<\03Nd`2<h=3;`Pg<\0b;_0BI`hR;UIF3:028`PWH\03Nf`2<"
    A$ = A$ + "hI3;`PW=\03Ne`2<hQ3;`P7>\03Nh`2<hQ3;`P7>\03Nh`2<hQ3;`P7>\03Nh`2<hQ3;`P7>\0b;_0RI`hR;VIF3:028`P7<\03N"
    A$ = A$ + "a`2<h93;`Pg<\03Ne`2<hQ3;`Pg=\03Na`2<h53;`PG<\03Nd`2<hI3;`PG<\03Na`2<h53;`PG<\0b;_0bL`hR;c1C3:028a`B<"
    A$ = A$ + "\43;a`B<\43;a`B<\43;a`B<\43;a`B<\43;a`B<\03;a`B<\43;a`B<\03;a`2<\43;a`B<\43;a`B<\0b;_0bLahR;c9C3:028"
    A$ = A$ + "a`R<\43;a`B<\43;a`R<\43;b`B<\43;a`B<\43;a`B<\43;a`B<\43;a`B<\83;a`B<\43;a`B<\43;a`B<\0b;_0bLchR;cAC3"
    A$ = A$ + ":028a`R<\43;a`B<\43;a`B<\43;b`B<\43;a`B<\43;a`B<\43;a`B<\43;a`B<\<3;a`b<\43;a`B<\43;a`B<\0b;_0bLehR;"
    A$ = A$ + "cIC3:028a`b<\43;a`B<\43;a`b<\43;c`B<\43;a`B<\43;a`B<\<3;a`B<\43;a`B<\43;a`B<\43;a`B<\43;a`B<\0b;_0bL"
    A$ = A$ + "ghR;cQC3:dg>=X@3:DGJ^Ag<bl5MPTVK\UVKUeP2eAWIh@FISm6IUQBMYi6Mc8cGdY28cAGHdE6;PDGJ^Ag<bl5MZ0bH_AFI`a28"
    A$ = A$ + "eUVKd=S<OA78RU7MUU28keP2P0BMYi6Mc8cGd12Mi1GIPd38eAWIh@fFRU7MUee>=X@3:028Z<fKTE6LPd38XXbLd56MU1B8m0BE"
    A$ = A$ + "DI4>O5d@3E4DDU28odP2P028PPRHiAGIPH28`Pg<VEG:P`78XXbH_AFI`12?l0R=Y0R>=X08P028X03NVI68nh38dU7LUU28V02:"
    A$ = A$ + "RU7MUUb>=X@3:028Z<7MQAGIPd38eAWIh@fFbDS=P\28Z<7MQAGIZ4S=P\28dU7LUee>=X08P8GIdEWL^1R:cAGHdEf>=X@O=X`;"
    A$ = A$ + "ZXR:ZXR:ZXR:ZXR:ZXR:ZXR:ZXR:ZXR:ZXR:ZXR:ZXR:ZXR:ZXR:ZXR:ZXR:ZXR:ZXR:ZXR:ZXR:ZXR:ZXb;=X@3:<7MbEgHd1RI"
    A$ = A$ + "_i6McmeLd9GMSA78k1b;_<fK`UFIT1RIbmFKP0GHbAgL_HGJTEfK_HfK^Ag;dAWI_<WLSibH=X08PDGJ^A7>PTVKOEgLU]C3:028"
    A$ = A$ + "eUVKdQ38Z@7MVm5IQAGHkdP2P0BJ^Ag<b02IUIFHea6MO1GJhE6KOQFIYM6Jd]C3:028eUVKdQ38Rm6KT]C3:028eUVKdQ38YAGH"
    A$ = A$ + "\UfHkdP2P0BMYi6Mh0BM^AFIbaFJ^Ef>=X08PDGJ^A7>PdfK^mfL`5fHU]C3:028Yi6Mc838]mVK_=7LQ=FIOMGJTA7JkdP2P0BM"
    A$ = A$ + "Yi6Mh0BM^UfH_AFIkdP2P0b;_dB;]dB;]dB;]dB;]dB;]dB;]dB;]dB;]dB;]dB;]dB;]dP2P0RADmUAQ=FIPPFH^A6KU]C3:028"
    A$ = A$ + "Yi6Mc838R5fLUaFJ^Ef>=X08PH6K_56MP@FIV5FM\AgG`U6NUafGXEFJWQ6MO=gHQaFIkdP2m]C3:D6NdEVL^1BJ]MfGcAWLe=6M"
    A$ = A$ + "PXbMbU6MUm5LQMFIkdP2UQ7MU9WKPTVKd=S<PXRI_i6MkdP2UQ7MU9WKPHfK^AgLO=7MbEgHd1R:VmVKd=g>=X@3:H4EOIDHSE68"
    A$ = A$ + "WE6MOI6JQi6I\E6:Y0bN=X08P8GIdEWL^1RI_i6Mc]UI_i6MKMWLYAGIO1GHWEF;nHfK^AGGMi2JQi6I\Ef>=X@O=X@3:TVKd1bI"
    A$ = A$ + "UAgGTEVIXEFJWQ6MXT28keP2P0RLUAGMbi68VmVKd=gFVmVKd]eMbU6MUm5LQMFI]hSI_i6MMeU;TEVIQE7Kdm5LYQGI\m5JUUfI"
    A$ = A$ + "XAg>=X@O=X@3:TVKd1bI`93LhQBJ^A78W1G:P\G3:028bE6Me9WKPPRI\mFHdUbI`1b;PLFIdmUIX5VKTaFIXTB;nDWKYAgLO1GI"
    A$ = A$ + "bmEA=1R:PLFIdm5IUI6JUUfIXA7:Y\C3:dG3:dP2Yi6MPD7JUUfIXA7:Y0bN=X08P<gMYAgHX12:g9GJdEfG`5fIUeR?VmVKdU28"
    A$ = A$ + "keP2P028P<FHcE68hX38bE6Me9WKPTc>=X08P028S5fLU1B<dX38bE6Me9WKP4C=kdP2P028P<FHcE68aHS>P8GIdEWL^1B<g\C3"
    A$ = A$ + ":028meP2P0RLUAGMbi68W1W<`Q7:WE6MOI6JQi6I\E6:YdR?Q=gHUi6IU978]0bIUAgGVQFH^A6KUQB:]h3IU=gHUi6IU9G:kdP2"
    A$ = A$ + "meP2=X@J^A78e5fLSEVKcUfK^QB:P\G3:028cMGJd=6JPPbMbU6MUm5LQMFI]hSI_i6MY0bN=X08P028S5fLU12>j0RLUAGMbi68"
    A$ = A$ + "i\C3:028P0bHQ=GIP43=j0RLUAGMbi68a<c>=X08P028S5fLU1B<fX38bE6Me9WKP43=kdP2P0BO=X08P8GIdEWL^1bI`93LhQbI"
    A$ = A$ + "UAgGVQFH^A6KUQB:]hCHc=FI^AFIbUb>=X@O=X@3:TVKd1BMc1GHSUVKWQB:P\G3:028YI68XLWLYAGIO1GHWEF;nHfK^A78l0b<"
    A$ = A$ + "bT28bE6Me9WKPLWLYAGIO1GHWEF;nHfK^Ag>=X08P8GIdEWL^1bI`93LhQbIUAgGVQFH^A6KUQB:]h3JUUfIXAG:P\28b\C3:dG3"
    A$ = A$ + ":dP2UQ7MU9WKPDGJ^A7>P<6JQ9gLUA7>hQcFbDS=M]5>M]5>M]C3:D6NdEVL^1BMYi6Mh0bHX5VLcE6MhPG<f\U<eHCGK5S=M]5>"
    A$ = A$ + "M]C3:dP2STVITEVIP4U@f@cGf@C3:HgKYA68e1WLYi6MOE6Nd9GHXTVKd=S<P<7MQ97Mha28Yi6Mc838cAGHbAGN\0BJ^AW=d0bL"
    A$ = A$ + "d9gGYi6;PTVKdI3=P8FNdE6KUi6;PTVKd=S<P\FIbifGg5VKdE6I\0BJ^Ag<b02I_mULUi6IU97;PTVKd=S<PX2MhAgMYA6MXa28"
    A$ = A$ + "Yi6Mf@38SQFHb1gKca28Yi6Mc838Z<6JQ9gL\0BMYi6Mc838Sm6K_EWL\0BJ^Ag<b0BKQQgGgU6IdQF:P\G3:<BI\=GI=XPM_U6I"
    A$ = A$ + "PD7LbUVKdmEIhAWLQQBJ^Ag<b0bLd5VLdQ7;PTVKd=S<P<7MQ97Mia28Yi6Mc838cAWLOUVK\0BJ^AW=d0RHiAGI\EVK\0BJ^Ag<"
    A$ = A$ + "b0bJU9WKOMGH^AGITa28Yi6Mc838TmfGbEVKTEVL\0BJ^Ag<b0R:dQ7MgU6IdQ6;PTVKdI3=P<6JQ97L_=7;PTVKd=S<PXbHX5VL"
    A$ = A$ + "ca28eUVKd=S<P<fK\mFMba28Yi6Mc838]56NOMGJTA7JY0bN=X`8Ui6IYIF3:028Yi6MP8FMYa6MYi68m02<kdP2P0BJV12:g9GJ"
    A$ = A$ + "dEfG`5fIUeR?VmVKd12?P<S<Y0bN=X08P028REGJ\AGJ^1B?P4c>=X08PdG3:0B3:028eUVKdQ38Z<7Mb1B?PPBMYi6Mh0R:Y<7M"
    A$ = A$ + "bmEJ^]C3:028eUVKd=S<P<6LYi6IUQ7;P0WLUIgGcAGHdE68m02<\0bHe9gGcAGHdE68m02<\0bH`]C3:028eUVKdQ38Z8FMYa6M"
    A$ = A$ + "YifGcAGHbAg>=X08PTVKd1bHe9gGS1GJ^AFIh1B?P0c>=X08PH4EOIDHSE68VQFH^A6KU]C3:028Yi6MP0WLUIgGWaFN`Q68m02<"
    A$ = A$ + "\0bI\U7LXmEJ^AFIha28U9WL_97;P\FIbif>=X08PH4EOIEISAgKb1bJU9WKOAFI\AGHkdP2P0BJ^A78`EVKOQ7;P0GI^mEN\02I"
    A$ = A$ + "b5fMOQ7;P@VLQMgGia28`U6N]56LOQ7;P0GJheFH`mENkdP2P0RI\mFHd1BH\17JQ]C3:028eifLYMVKUA68Yi6MP8gIR]C3:dP2"
    A$ = A$ + "P02LUifGh1B?P<7MQ97Mh]C3:028`EVKOU78m0bLd5VLdUg>=X08PTVIPPRHeU6KdUVKY0bN=X08P028`EVKOU78[d38b\C3:028"
    A$ = A$ + "meP2P0BI\=GIP\78P0B3:028P0RIX5VKTaFIPd38WE6MOI6JQi6I\E6:Y\C3:028P02LUifGi1b:m0BMQ=gHUifLYmVKXTb>=X08"
    A$ = A$ + "P028YI68XH4EOQD@CmeB59UC9idAXH6JQi6I\EF:PHR9P\FIbifGg5VKdE6IY0bJU9WKPd38a\38UafLU1bJU9WKPd38`\C3:028"
    A$ = A$ + "meP2PdP2P0BH\17JQ1B?PPbH_afKe978nh38b@C:Pl28bDC=^0c>=X08P8gIR1B?P<fK\mFMb1R9P03NVIVIVIVIkdP2=X08PHfK"
    A$ = A$ + "b12:S1GJ^AFIh1B?P0c>P<6LYi6IUQ78l0RHiAGI\EVKk02LbEVMO=7MQAGIPd38SEWLO=7MQAGI\0bH`UVKTE6N[\B:P\G3:028"
    A$ = A$ + "P0b;_TVIPP2LUifGh1R?PTFK]hcMYA6MX12Ol12LUifGi1R?PTFK]h3JUUfIXAG:P8VLU5fJkdP2P028PTVIPPBKQQgGgU6IdQ68"
    A$ = A$ + "VH28X0GI^m5NPh38cAGHbA7NP\28]56NOMGJTA7JYT28R9GIQ]f>=X08P028YI68X<6JQ97L_=G:PP2:Yi6Mc8S:Y<6JQ97L_=G:"
    A$ = A$ + "K=FMbmeH`UVKTE6NM1B?P0GI^m5NPd28cAGHbA7NkdP2P028=X08P028cMGJd=6JPPBMdI6>TEfH_AFIXHbHe9gGcAGHdE6;PHbH"
    A$ = A$ + "`a28cAWLK=6LYi6IUQGGYT28keP2P028P<FHcE68EAUAhlE@3=DA@AU>=X08P028P0b;_LfK_A68Sm6IU1gKYi6M=X08P028P0bH"
    A$ = A$ + "e9gGS1GJ^AFIh]b:kdP2P028P028R9GIQ]f>=X08P028S5fLU1BEDI4>O9EA:Ed@DYC3:028P028Plb;Sm6IU1gKYi6MPLgKea6I"
    A$ = A$ + "P8FIPDe:6ITA412:bE6L\5fHUeFI^A78SQFHb5fHdEVLYdP2P028P028S178m02<hIVIVAf>=X08P028P0bHe9gGcAGHdE68m0BE"
    A$ = A$ + "DI4>O5d@3E4DD]C3:028P028PTVIPP2LbEVMO=7MQAGIP4B?PD5E6QcG1=d@515EY0bH`UVKTE6N]db>=X08P028P0bHe9gGS1GJ"
    A$ = A$ + "^AFIh]b:kdP2P028P028R9GIQ]f>=X08P028TEVIQE7KdYC3:028P028Plb;^EFIT12M_1RLU56IP<fK^AGJ^EGHdUfK^1RHiAGI"
    A$ = A$ + "ceP2P028P028SmVKdUVKeEf>=X08P028P0RHbEFH[]C3:028P0BO=X08P0B3:028P0BJV12:REGJ\AGJ^U28keP2P028P028YI68"
    A$ = A$ + "XdFHhmeMYA6MX1R9V02:`EVKOQ78[02>Ph38cAGHbA7NP\28]56NOMGJTA7JYT28R9GIQ]f>=X08P028P0BJV12:S178n0R<eDC:"
    A$ = A$ + "P<fK^AGJ^EGIkdP2P028P028cMGJd=6JPPbMbU6MUm5LQMFI]hSI_i6MY0bN=X@2S5fLU12>j0RHeU6KdUVKO=7MQ97MPd38V<6J"
    A$ = A$ + "Q9gLUA7>hQcFS1GGK1CGK1CGk0RHbEFH[]C3:T`HQ=GIP43=j0RHeU6KdUVKO=7MQ97MPd38V<6JQ9gLUA7>h5S=K=6LM]E<M]5<"
    A$ = A$ + "M]38R9GIQ]f>=X@2S5fLU1B<fX38REGJ\AGJ^meLd5VLd1B?PHbHX5VLcE6MhPG<f\eH`eeF`deF`de>P8VLU5fJkdP2P028P028"
    A$ = A$ + "meP2P028P028YI68X@fKO9GI^AFIbU28keP29HfKb12:T9GHgmENPd38`EVKOU7;P0GJheFH`mENPd38`\38`U6N]56LOU78l0bM"
    A$ = A$ + "bU6MUm5LQMFI]hSI_i6Mk02Ib5fMOUg:[`28`U6N]56LOUg:[T28keP29028VmVLPP2Ib5fMOQ78m02LUifGha28`U6N]56LOQ78"
    A$ = A$ + "m02<k02LYQGKQ1gGh12?PPc>P@VLQMgGh]b:\02LYQGKQ1gGh]b:Y0bN=X@2P028PTVIPPR:REGJ\AGJ^meLd5VLd]b:Y02LcE6M"
    A$ = A$ + "O5VKTmeH\U6LX@VLQMgGha28T9GHgmEN\0bH_afKe9G:kdP29028meP29dG3:028P028PdG3:028P028P0GI^m5NP\B?PPc>=X08"
    A$ = A$ + "P028meP2P028PD6KcE68keP2P028P028WaFN`QfGYi6IUQ78m0RADmeAUAgG3QFHbmEB^AFIhQRIX5VKTaFI\0bH`Ub>=X@3:028"
    A$ = A$ + "P028PTVIPPbJU9WKPHR9P0WLUIgGWaFN`Q68VH28WaFN`QfGYi6IUQG:P\G3:028P028P0286AeG7E6MO]DIbiFJ^M6:VQFH^A6K"
    A$ = A$ + "Ua28`9GIfmeI\U7LXa28WaFN`QfGYi6IUQ7;PH4EO]DABiDB>MdG4ETA1E5CDa28V\FIbifGTE6Kd5F:kdP2P028P028P02LUifG"
    A$ = A$ + "h1b:m0bI`93LhQbJU9WKOAFI\AGH^PG:kdP2P028P028meP2PdP2P028P028U9WL_978m0RADm5C_56IOM4Ki17JXH6JQi6I\E6;"
    A$ = A$ + "PL6Ki17JOUVKTE6N\0RADm5C?54AOADA65DE<AE:kdP2P028P028YI68XDVLbmVLY0bH_i6MYiFMU]C3:028P028PDVLbmVLPd38"
    A$ = A$ + "6AeGBEVKTEVLOM4Ki17JXH6JQi6I\EF;nL6Ki17J\0RADmUD5i4A59eG=m4A5mUC?9EC1aD:kdP2P028P028YI68XDVLbmVLY0bH"
    A$ = A$ + "_i6MYiFMU]C3:dP2P028P028YI68XdFHhmeMYA6MX1R9V02:`EVKOQ78[0RIX5VKTaFI]hcI\U7LXeR?RU6M]56L^LGJTA7JPh38"
    A$ = A$ + "cAGHbA7NP\28]56NOMGJTA7JYT28R9GIQ]f>=X08P028P0BJV12:TmfGbEVKTEVLY0bN=X@2VmVLPP2Ib5fMOU78m02LUifGi1B;"
    A$ = A$ + "PH6JQi6I\EF;nL6Ki17J]hSHYAGKQ1gGdm6L\02LYQGKQ1gGi1B?P0c>P0GJheFH`mENP`38VQFH^A6KUeR?WaFN`QF;n8FJdeFH"
    A$ = A$ + "`iRL_MgLk02Ib5fMOUg:[`28`U6N]56LOUg:[T28keP29028VmVLPP2Ib5fMOQ78m02LUifGh1b:PH6JQi6I\EF;nL6Ki17J]hSH"
    A$ = A$ + "YAGKQ1gG\EVIda28`U6N]56LOQ78m02<k02LYQGKQ1gGh12?PH6JQi6I\EF;nL6Ki17J]hSHYAGKQ1W;gU6IdQf>P@VLQMgGh]b:"
    A$ = A$ + "\02LYQGKQ1gGh]b:Y0bN=X@2P028P0gLUAgGQi6IO=6KY17:T9GHgm5N\02Ib5fMOU7;PP2:Yi6MYPRIX5VKTaFI]hcI\U7LXeR?"
    A$ = A$ + "RU6M]56L^8FMVIFIb]5LYQGKQ1gGi1R:PH6JQi6I\EF;nL6Ki17J]hSHYAGKQ1W;gU6IdQ68[02LYQGKQ1gGhe58Z0BH\17JQU28"
    A$ = A$ + "l`38b@C:P`78bMVHY\C3:T08PdG3:T@O=X08P028P0BO=X08P028P02LUifGh1b:m0RIX5VKTaFI]hcI\U7LXeR?QAVMQifHUi2N"
    A$ = A$ + "Pl28f@c>=X08P028P02LbEVMOM6Ki17JPd38WaFN`QfGYi6IUQg>=X08P028meP2P028=X08P028YI68X@7NdMGJTA7JY0R:dQ7M"
    A$ = A$ + "gU6IdQ68m02LUifGh1B;P<7MQ97Mh]C3:028P0BJV12:SQFHb=G:PXbHX5VLc1B?P<FMbmeH`UVKTE6NkdP2P0BO=X08PTVIPPbH"
    A$ = A$ + "X5VL`mfLY02:XTVKd=S<ZTbHX5VL`mfLY\eHe9gGS1GJ^AFIhe58m02LUifGh1B;P<7MQ97Mh]C3:dG3:dP2Yi6Mc838e1WLYi6M"
    A$ = A$ + "XTVKd=S<P<7MQ97Mha28Yi6Mc838cAGHbAGN\0bHX5VLPXbLd9gGYi6;PTVKdI3=P8FNdE6KUi6;PDGJ^Ag<b0bH_afKe97;PTVK"
    A$ = A$ + "d=S<PdFHhmeMYA6MXU28keP2P0BJ^Ag<b02MhAgMYA6MX]C3:<BJVAFIV1BD2I3=OI3==X08PD7LbUVKdmEIhAWLQQbLd5VLdQ7;"
    A$ = A$ + "P<7MQ97Mia28XTVKdI3=Y<7MbmEJ^a28RU7MUaFI^a28]43;P43;PH2MhAgMYA6MXa28``28``28Sm6K_EWL\0BKQQgGgU6IdQF:"
    A$ = A$ + "kdP2SD6KcEF3:028e1WLYi6MOE6Nd9GHX<7MQ97Mha28cAGHbAGN\02:Yi6Mc8C:cAWLOUVK\0RHiAGI\EVK\0B;a`28a`28V@7N"
    A$ = A$ + "dMGJTA7J\02<\02<\0bH_afKe97;PdFHhmeMYA6MXUb>=X`8Ui6IYIF3:028bE6Me9WKP@7NdMGJTA7JkdP2meP2=X@J^Ag<b0BM"
    A$ = A$ + "`9GJ^AgMYA6MXQbHX5VLPXbLd9gGYi6;PTVKdI3=P8FNdE6KUi6;PTVKd=S<PdFHhmeMYA6MXU28keP2P0BJ^Ag<b02MhAgMYA6M"
    A$ = A$ + "X]C3:<BJVAFIV1BD2I3=OI3==X08PD7LbUVKdmEIhAWLQQ2<\02<\02:Yi6Mf@C:cAWLOUVK\0RHiAGI\EVK\0B;a`28``28V@7N"
    A$ = A$ + "dMGJTA7J\02<\02<\02<\0BKQQgGgU6IdQF:kdP2SD6KcEF3:028e1WLYi6MOE6Nd9GHX03;P03;PPBJ^Ag<bTbLd9gGYi6;P8FN"
    A$ = A$ + "dE6KUi6;PdB<\02<\0R9dQ7MgU6IdQ6;P03;P03;P03;PdFHhmeMYA6MXUb>=X`8Ui6IYIF3:028bE6Me9WKP@7NdMGJTA7JkdP2"
    A$ = A$ + "meP2%%%0"

    B$ = Unpack$(A$)
    FileNum = FREEFILE
    OPEN "falcon.h" FOR BINARY AS #FileNum
    PUT #FileNum, 1, B$
    CLOSE #FileNum
END SUB

'FUNCTION idezfilelist$ and idezpathlist$ (and helper functions) were
'adapted from ide_methods.bas (QB64):
FUNCTION idezfilelist$ (path$, method, TotalFound AS INTEGER) 'method0=*.bas, method1=*.*
    DIM sep AS STRING * 1, filelist$, a$
    sep = CHR$(13)

    TotalFound = 0
    $IF WIN THEN
        OPEN "opendlgfiles.dat" FOR OUTPUT AS #150: CLOSE #150
        IF method = 0 THEN SHELL _HIDE "dir /b /ON /A-D " + QuotedFilename$(path$) + "\*.frmbin >opendlgfiles.dat"
        IF method = 1 THEN SHELL _HIDE "dir /b /ON /A-D " + QuotedFilename$(path$) + "\*.* >opendlgfiles.dat"
        filelist$ = ""
        OPEN "opendlgfiles.dat" FOR INPUT AS #150
        DO UNTIL EOF(150)
            LINE INPUT #150, a$
            IF LEN(a$) THEN 'skip blank entries
                IF filelist$ = "" THEN filelist$ = a$ ELSE filelist$ = filelist$ + sep + a$
                TotalFound = TotalFound + 1
            END IF
        LOOP
        CLOSE #150
        KILL "opendlgfiles.dat"
        idezfilelist$ = filelist$
        EXIT FUNCTION
    $ELSE
        filelist$ = ""
        DIM i AS INTEGER, x AS INTEGER, a2$
        FOR i = 1 TO 2 - method
        OPEN "opendlgfiles.dat" FOR OUTPUT AS #150: CLOSE #150
        IF method = 0 THEN
        IF i = 1 THEN SHELL _HIDE "find " + QuotedFilename$(path$) + " -maxdepth 1 -type f -name " + CHR$(34) + "*.frmbin" + CHR$(34) + " >opendlgfiles.dat"
        IF i = 2 THEN SHELL _HIDE "find " + QuotedFilename$(path$) + " -maxdepth 1 -type f -name " + CHR$(34) + "*.FRMBIN" + CHR$(34) + " >opendlgfiles.dat"
        END IF
        IF method = 1 THEN
        IF i = 1 THEN SHELL _HIDE "find " + QuotedFilename$(path$) + " -maxdepth 1 -type f -name " + CHR$(34) + "*" + CHR$(34) + " >opendlgfiles.dat"
        END IF
        OPEN "opendlgfiles.dat" FOR INPUT AS #150
        DO UNTIL EOF(150)
        LINE INPUT #150, a$
        IF LEN(a$) = 0 THEN EXIT DO
        FOR x = LEN(a$) TO 1 STEP -1
        a2$ = MID$(a$, x, 1)
        IF a2$ = "/" THEN
        a$ = RIGHT$(a$, LEN(a$) - x)
        EXIT FOR
        END IF
        NEXT
        IF filelist$ = "" THEN filelist$ = a$ ELSE filelist$ = filelist$ + sep + a$
        TotalFound = TotalFound + 1
        LOOP
        CLOSE #150
        NEXT
        KILL "opendlgfiles.dat"
        idezfilelist$ = filelist$
        EXIT FUNCTION
    $END IF
END FUNCTION

FUNCTION idezpathlist$ (path$, TotalFound%)
    DIM sep AS STRING * 1, a$, pathlist$, c AS INTEGER, x AS INTEGER, b$
    DIM i AS INTEGER
    sep = CHR$(13)

    TotalFound% = 0
    $IF WIN THEN
        OPEN "opendlgfiles.dat" FOR OUTPUT AS #150: CLOSE #150
        a$ = "": IF RIGHT$(path$, 1) = ":" THEN a$ = "\" 'use a \ after a drive letter
        SHELL _HIDE "dir /b /ON /AD " + QuotedFilename$(path$ + a$) + " >opendlgfiles.dat"
        pathlist$ = ""
        OPEN "opendlgfiles.dat" FOR INPUT AS #150
        DO UNTIL EOF(150)
            LINE INPUT #150, a$
            IF pathlist$ = "" THEN pathlist$ = a$ ELSE pathlist$ = pathlist$ + sep + a$
            TotalFound% = TotalFound% + 1
        LOOP
        CLOSE #150
        KILL "opendlgfiles.dat"
        'count instances of / or \
        c = 0
        FOR x = 1 TO LEN(path$)
            b$ = MID$(path$, x, 1)
            IF b$ = PathSep$ THEN c = c + 1
        NEXT
        IF c >= 1 THEN
            IF LEN(pathlist$) THEN pathlist$ = ".." + sep + pathlist$ ELSE pathlist$ = ".."
            TotalFound% = TotalFound% + 1
        END IF
        'add drive paths
        FOR i = 0 TO 25
            IF LEN(pathlist$) THEN pathlist$ = pathlist$ + sep
            pathlist$ = pathlist$ + CHR$(65 + i) + ":"
            TotalFound% = TotalFound% + 1
        NEXT
        idezpathlist$ = pathlist$
        EXIT FUNCTION
    $ELSE
        pathlist$ = ""
        DIM a2$
        OPEN "opendlgfiles.dat" FOR OUTPUT AS #150: CLOSE #150
        SHELL _HIDE "find " + QuotedFilename$(path$) + " -maxdepth 1 -mindepth 1 -type d >opendlgfiles.dat"
        OPEN "opendlgfiles.dat" FOR INPUT AS #150
        DO UNTIL EOF(150)
        LINE INPUT #150, a$
        IF LEN(a$) = 0 THEN EXIT DO
        FOR x = LEN(a$) TO 1 STEP -1
        a2$ = MID$(a$, x, 1)
        IF a2$ = "/" THEN
        a$ = RIGHT$(a$, LEN(a$) - x)
        EXIT FOR
        END IF
        NEXT
        IF pathlist$ = "" THEN pathlist$ = a$ ELSE pathlist$ = pathlist$ + sep + a$
        TotalFound% = TotalFound% + 1
        LOOP
        CLOSE #150
        KILL "opendlgfiles.dat"

        IF path$ <> "/" THEN
        a$ = ".."

        IF pathlist$ = "" THEN pathlist$ = a$ ELSE pathlist$ = a$ + sep + pathlist$
        TotalFound% = TotalFound% + 1
        END IF

        idezpathlist$ = pathlist$
        EXIT FUNCTION
    $END IF
END FUNCTION

FUNCTION idezchangepath$ (path$, newpath$)
    DIM x AS INTEGER, a$

    idezchangepath$ = path$ 'default (for unsuccessful cases)

    $IF WIN THEN
        'go back a path
        IF newpath$ = ".." THEN
            FOR x = LEN(path$) TO 1 STEP -1
                a$ = MID$(path$, x, 1)
                IF a$ = "\" THEN
                    idezchangepath$ = LEFT$(path$, x - 1)
                    EXIT FOR
                END IF
            NEXT
            EXIT FUNCTION
        END IF
        'change drive
        IF LEN(newpath$) = 2 AND RIGHT$(newpath$, 1) = ":" THEN
            idezchangepath$ = newpath$
            EXIT FUNCTION
        END IF
        idezchangepath$ = path$ + "\" + newpath$
        EXIT FUNCTION
    $ELSE
        'go back a path
        IF newpath$ = ".." THEN
        FOR x = LEN(path$) TO 1 STEP -1
        a$ = MID$(path$, x, 1)
        IF a$ = "/" THEN
        idezchangepath$ = LEFT$(path$, x - 1)
        IF x = 1 THEN idezchangepath$ = "/" 'root path cannot be ""
        EXIT FOR
        END IF
        NEXT
        EXIT FUNCTION
        END IF
        IF path$ = "/" THEN idezchangepath$ = "/" + newpath$ ELSE idezchangepath$ = path$ + "/" + newpath$
        EXIT FUNCTION
    $END IF

END FUNCTION

FUNCTION QuotedFilename$ (f$)
    $IF WIN THEN
        QuotedFilename$ = CHR$(34) + f$ + CHR$(34)
    $ELSE
        QuotedFilename$ = "'" + f$ + "'"
    $END IF
END FUNCTION
