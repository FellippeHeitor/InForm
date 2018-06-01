OPTION _EXPLICIT

$EXEICON:'.\resources\InForm.ico'

'Controls: --------------------------------------------------------------------
'Main form
DIM SHARED UiEditor AS LONG
DIM SHARED StatusBar AS LONG

'Menus
DIM SHARED FileMenu AS LONG, EditMenu AS LONG, ViewMenu AS LONG
DIM SHARED InsertMenu AS LONG, AlignMenu AS LONG, OptionsMenu AS LONG
DIM SHARED HelpMenu AS LONG

'Frames
DIM SHARED Toolbox AS LONG, ColorMixer AS LONG
DIM SHARED OpenFrame AS LONG, ZOrdering AS LONG
DIM SHARED ControlProperties AS LONG, ControlToggles AS LONG

'Menu items
DIM SHARED FileMenuNew AS LONG, FileMenuOpen AS LONG
DIM SHARED FileMenuSave AS LONG, FileMenuSaveFrm AS LONG
DIM SHARED FileMenuExit AS LONG

DIM SHARED EditMenuUndo AS LONG, EditMenuRedo AS LONG, EditMenuCut AS LONG
DIM SHARED EditMenuCopy AS LONG, EditMenuPaste AS LONG
DIM SHARED EditMenuDelete AS LONG, EditMenuSelectAll AS LONG
DIM SHARED EditMenuCP437 AS LONG, EditMenuCP1252 AS LONG
DIM SHARED EditMenuSetDefaultButton AS LONG
DIM SHARED EditMenuRestoreDimensions AS LONG
DIM SHARED EditMenuAllowMinMax AS LONG, EditMenuZOrdering AS LONG

DIM SHARED ViewMenuPreviewDetach AS LONG
DIM SHARED ViewMenuShowPositionAndSize AS LONG
DIM SHARED ViewMenuPreview AS LONG, ViewMenuLoadedFonts AS LONG

DIM SHARED InsertMenuMenuBar AS LONG, InsertMenuMenuItem AS LONG

DIM SHARED OptionsMenuSnapLines AS LONG
DIM SHARED AlignMenuAlignLeft AS LONG
DIM SHARED AlignMenuAlignRight AS LONG
DIM SHARED AlignMenuAlignTops AS LONG
DIM SHARED AlignMenuAlignBottoms AS LONG
DIM SHARED AlignMenuAlignCentersV AS LONG
DIM SHARED AlignMenuAlignCentersH AS LONG
DIM SHARED AlignMenuAlignCenterV AS LONG
DIM SHARED AlignMenuAlignCenterH AS LONG
DIM SHARED AlignMenuDistributeV AS LONG
DIM SHARED AlignMenuDistributeH AS LONG

DIM SHARED OptionsMenuAutoName AS LONG, OptionsMenuSwapButtons AS LONG
DIM SHARED OptionsMenuCheckUpdates AS LONG

DIM SHARED HelpMenuHelp AS LONG, HelpMenuAbout AS LONG

'Toolbox buttons
DIM SHARED AddButton AS LONG, AddLabel AS LONG
DIM SHARED AddTextBox AS LONG, AddNumericBox AS LONG
DIM SHARED AddCheckBox AS LONG, AddRadioButton AS LONG
DIM SHARED AddListBox AS LONG, AddDropdownList AS LONG
DIM SHARED AddTrackBar AS LONG, AddProgressBar AS LONG
DIM SHARED AddPictureBox AS LONG, AddFrame AS LONG
DIM SHARED AddToggleSwitch AS LONG

'Control toggles
DIM SHARED Stretch AS LONG, HasBorder AS LONG
DIM SHARED ShowPercentage AS LONG, PasswordMaskCB AS LONG
DIM SHARED WordWrap AS LONG, CanHaveFocus AS LONG
DIM SHARED Disabled AS LONG, Transparent AS LONG
DIM SHARED Hidden AS LONG, CenteredWindow AS LONG
DIM SHARED Resizable AS LONG

'Open dialog
DIM SHARED DialogBG AS LONG, FileNameLB AS LONG
DIM SHARED FileNameTextBox AS LONG, PathLB AS LONG
DIM SHARED FilesLB AS LONG, FileList AS LONG
DIM SHARED PathsLB AS LONG, DirList AS LONG
DIM SHARED OpenBT AS LONG, CancelBT AS LONG
DIM SHARED ShowOnlyFrmbinFilesCB AS LONG

'Z-ordering dialog
DIM SHARED ControlList AS LONG, UpBT AS LONG
DIM SHARED DownBT AS LONG, CloseZOrderingBT AS LONG

'Properties
DIM SHARED TextAlignLB AS LONG, AlignOptions AS LONG
DIM SHARED VerticalAlignLB AS LONG, VAlignOptions AS LONG
DIM SHARED ColorPropertiesList AS LONG, ColorPreview AS LONG
DIM SHARED Red AS LONG, RedValue AS LONG
DIM SHARED Green AS LONG, GreenValue AS LONG
DIM SHARED Blue AS LONG, BlueValue AS LONG
DIM SHARED NameLB AS LONG, CaptionLB AS LONG
DIM SHARED TextLB AS LONG, TopLB AS LONG
DIM SHARED LeftLB AS LONG, WidthLB AS LONG
DIM SHARED HeightLB AS LONG, FontLB AS LONG
DIM SHARED TooltipLB AS LONG, ValueLB AS LONG
DIM SHARED MinLB AS LONG, MaxLB AS LONG
DIM SHARED IntervalLB AS LONG, MinIntervalLB AS LONG
DIM SHARED PaddingLeftrightLB AS LONG, NameTB AS LONG
DIM SHARED CaptionTB AS LONG, TextTB AS LONG
DIM SHARED TopTB AS LONG, LeftTB AS LONG
DIM SHARED WidthTB AS LONG, HeightTB AS LONG
DIM SHARED FontTB AS LONG, TooltipTB AS LONG
DIM SHARED ValueTB AS LONG, MinTB AS LONG
DIM SHARED MaxTB AS LONG, IntervalTB AS LONG
DIM SHARED MinIntervalTB AS LONG, PaddingTB AS LONG
DIM SHARED MaskTB AS LONG, MaskLB AS LONG
DIM SHARED BulletOptions AS LONG, BulletOptionsLB AS LONG
DIM SHARED BooleanLB AS LONG, BooleanOptions AS LONG
DIM SHARED FontListLB AS LONG, FontList AS LONG, FontSizeList
'------------------------------------------------------------------------------

'Other shared variables:
DIM SHARED UiPreviewPID AS LONG, TotalSelected AS LONG, FirstSelected AS LONG
DIM SHARED PreviewFormID AS LONG, PreviewSelectionRectangle AS INTEGER
DIM SHARED CheckPreviewTimer AS INTEGER, PreviewAttached AS _BYTE, AutoNameControls AS _BYTE
DIM SHARED LastKeyPress AS DOUBLE, CheckUpdates AS _BYTE
DIM SHARED UiEditorTitle$, Edited AS _BYTE, ZOrderingDialogOpen AS _BYTE
DIM SHARED OpenDialogOpen AS _BYTE, OverwriteOldFiles AS _BYTE
DIM SHARED RevertEdit AS _BYTE, OldColor AS _UNSIGNED LONG
DIM SHARED ColorPreviewWord$, BlinkStatusBar AS SINGLE, StatusBarBackColor AS _UNSIGNED LONG

TYPE newInputBox
    ID AS LONG
    LabelID AS LONG
    Signal AS INTEGER
    LastEdited AS SINGLE
    Sent AS _BYTE
END TYPE

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
CONST OffsetOriginalImageWidth = 47
CONST OffsetOriginalImageHeight = 49
CONST OffsetSelectionRectangle = 51
CONST OffsetPropertyValue = 53

REDIM SHARED PreviewCaptions(0) AS STRING
REDIM SHARED PreviewTexts(0) AS STRING
REDIM SHARED PreviewMasks(0) AS STRING
REDIM SHARED PreviewTips(0) AS STRING
REDIM SHARED PreviewFonts(0) AS STRING
REDIM SHARED PreviewControls(0) AS __UI_ControlTYPE
REDIM SHARED PreviewParentIDS(0) AS STRING
REDIM SHARED zOrderIDs(0) AS LONG
REDIM SHARED InputBox(1 TO 100) AS newInputBox
REDIM SHARED InputBoxText(1 TO 100) AS STRING
DIM SHARED PreviewDefaultButtonID AS LONG

DIM SHARED HasFontList AS _BYTE

$IF WIN THEN
    REDIM SHARED FontFile(0) AS STRING
    DIM SHARED TotalFontsFound AS LONG

    CONST PathSep$ = "\"
$ELSE
    CONST PathSep$ = "/"
$END IF

IF _FILEEXISTS("falcon.h") = 0 THEN RestoreFalcon

DIM SHARED CurrentPath$
DIM SHARED OpenDialog AS LONG

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
    CONST HKEY_CLASSES_ROOT = &H80000000~&
    CONST HKEY_CURRENT_USER = &H80000001~&
    CONST HKEY_LOCAL_MACHINE = &H80000002~&
    CONST HKEY_USERS = &H80000003~&
    CONST HKEY_PERFORMANCE_DATA = &H80000004~&
    CONST HKEY_CURRENT_CONFIG = &H80000005~&
    CONST HKEY_DYN_DATA = &H80000006~&
    CONST REG_OPTION_VOLATILE = 1
    CONST REG_OPTION_NON_VOLATILE = 0
    CONST REG_CREATED_NEW_KEY = 1
    CONST REG_OPENED_EXISTING_KEY = 2

    ''http://msdn.microsoft.com/en-us/library/ms724884(v=VS.85).aspx
    CONST REG_NONE = 0
    CONST REG_SZ = 1
    CONST REG_EXPAND_SZ = 2
    CONST REG_BINARY = 3
    CONST REG_DWORD_LITTLE_ENDIAN = 4
    CONST REG_DWORD = 4
    CONST REG_DWORD_BIG_ENDIAN = 5
    CONST REG_LINK = 6
    CONST REG_MULTI_SZ = 7
    CONST REG_RESOURCE_LIST = 8
    CONST REG_FULL_RESOURCE_DESCRIPTOR = 9
    CONST REG_RESOURCE_REQUIREMENTS_LIST = 10
    CONST REG_QWORD_LITTLE_ENDIAN = 11
    CONST REG_QWORD = 11
    CONST REG_NOTIFY_CHANGE_NAME = 1
    CONST REG_NOTIFY_CHANGE_ATTRIBUTES = 2
    CONST REG_NOTIFY_CHANGE_LAST_SET = 4
    CONST REG_NOTIFY_CHANGE_SECURITY = 8

    ''http://msdn.microsoft.com/en-us/library/ms724878(v=VS.85).aspx
    CONST KEY_ALL_ACCESS = &HF003F&
    CONST KEY_CREATE_LINK = &H0020&
    CONST KEY_CREATE_SUB_KEY = &H0004&
    CONST KEY_ENUMERATE_SUB_KEYS = &H0008&
    CONST KEY_EXECUTE = &H20019&
    CONST KEY_NOTIFY = &H0010&
    CONST KEY_QUERY_VALUE = &H0001&
    CONST KEY_READ = &H20019&
    CONST KEY_SET_VALUE = &H0002&
    CONST KEY_WOW64_32KEY = &H0200&
    CONST KEY_WOW64_64KEY = &H0100&
    CONST KEY_WRITE = &H20006&

    ''winerror.h
    ''http://msdn.microsoft.com/en-us/library/ms681382(v=VS.85).aspx
    CONST ERROR_SUCCESS = 0
    CONST ERROR_FILE_NOT_FOUND = &H2&
    CONST ERROR_INVALID_HANDLE = &H6&
    CONST ERROR_MORE_DATA = &HEA&
    CONST ERROR_NO_MORE_ITEMS = &H103&

    DECLARE DYNAMIC LIBRARY "advapi32"
        FUNCTION RegOpenKeyExA& (BYVAL hKey AS _OFFSET, BYVAL lpSubKey AS _OFFSET, BYVAL ulOptions AS _UNSIGNED LONG, BYVAL samDesired AS _UNSIGNED LONG, BYVAL phkResult AS _OFFSET)
        FUNCTION RegCloseKey& (BYVAL hKey AS _OFFSET)
        FUNCTION RegEnumValueA& (BYVAL hKey AS _OFFSET, BYVAL dwIndex AS _UNSIGNED LONG, BYVAL lpValueName AS _OFFSET, BYVAL lpcchValueName AS _OFFSET, BYVAL lpReserved AS _OFFSET, BYVAL lpType AS _OFFSET, BYVAL lpData AS _OFFSET, BYVAL lpcbData AS _OFFSET)
    END DECLARE
$ELSE
    DECLARE LIBRARY
    FUNCTION PROCESS_CLOSED& ALIAS kill (BYVAL pid AS INTEGER, BYVAL signal AS INTEGER)
    END DECLARE
$END IF

'$include:'ini.bi'
'$include:'InForm.ui'
'$include:'xp.uitheme'
'$include:'UiEditor.frm'
'$include:'ini.bm'

'Event procedures: ---------------------------------------------------------------
SUB __UI_Click (id AS LONG)
    DIM Answer AS _BYTE, Dummy AS LONG, b$, UiEditorFile AS INTEGER
    STATIC LastClick#, LastClickedID AS LONG

    SELECT EVERYCASE id
        CASE AlignMenuAlignLeft: Dummy = 201
        CASE AlignMenuAlignRight: Dummy = 202
        CASE AlignMenuAlignTops: Dummy = 203
        CASE AlignMenuAlignBottoms: Dummy = 204
        CASE AlignMenuAlignCentersV: Dummy = 205
        CASE AlignMenuAlignCentersH: Dummy = 206
        CASE AlignMenuAlignCenterV: Dummy = 207
        CASE AlignMenuAlignCenterH: Dummy = 208
        CASE AlignMenuDistributeV: Dummy = 209
        CASE AlignMenuDistributeH: Dummy = 210
        CASE AlignMenuAlignLeft, AlignMenuAlignRight, AlignMenuAlignTops, _
             AlignMenuAlignBottoms, AlignMenuAlignCentersV, AlignMenuAlignCentersH, _
             AlignMenuAlignCenterV, AlignMenuAlignCenterH, AlignMenuDistributeV, _
             AlignMenuDistributeH
            b$ = MKI$(0)
            SendData b$, Dummy
            Edited = True
        CASE OptionsMenuAutoName
            AutoNameControls = NOT AutoNameControls
            Control(id).Value = AutoNameControls
            SaveSettings
        CASE OptionsMenuCheckUpdates
            CheckUpdates = NOT CheckUpdates
            Control(id).Value = CheckUpdates
            SaveSettings
        CASE EditMenuSetDefaultButton
            SendSignal -6
            Edited = True
        CASE EditMenuRestoreDimensions
            SendSignal -7
            Edited = True
        CASE OptionsMenuSwapButtons
            __UI_MouseButtonsSwap = NOT __UI_MouseButtonsSwap
            Control(id).Value = __UI_MouseButtonsSwap
            SaveSettings
        CASE OptionsMenuSnapLines
            __UI_SnapLines = NOT __UI_SnapLines
            Control(id).Value = __UI_SnapLines
            SaveSettings
        CASE InsertMenuMenuBar
            UiEditorFile = FREEFILE
            OPEN "InForm/UiEditor.dat" FOR BINARY AS #UiEditorFile
            b$ = MKI$(__UI_Type_MenuBar)
            PUT #UiEditorFile, OffsetNewControl, b$
            CLOSE #UiEditorFile
            Edited = True
        CASE InsertMenuMenuItem
            UiEditorFile = FREEFILE
            OPEN "InForm/UiEditor.dat" FOR BINARY AS #UiEditorFile
            b$ = MKI$(__UI_Type_MenuItem)
            PUT #UiEditorFile, OffsetNewControl, b$
            CLOSE #UiEditorFile
            Edited = True
        CASE ViewMenuPreviewDetach
            PreviewAttached = NOT PreviewAttached
            Control(id).Value = PreviewAttached
            SaveSettings
        CASE AddButton: Dummy = __UI_Type_Button
        CASE AddLabel: Dummy = __UI_Type_Label
        CASE AddTextBox: Dummy = __UI_Type_TextBox
        CASE AddCheckBox: Dummy = __UI_Type_CheckBox
        CASE AddRadioButton: Dummy = __UI_Type_RadioButton
        CASE AddListBox: Dummy = __UI_Type_ListBox
        CASE AddDropdownList: Dummy = __UI_Type_DropdownList
        CASE AddTrackBar: Dummy = __UI_Type_TrackBar
        CASE AddProgressBar: Dummy = __UI_Type_ProgressBar
        CASE AddPictureBox: Dummy = __UI_Type_PictureBox
        CASE AddFrame: Dummy = __UI_Type_Frame
        CASE AddToggleSwitch: Dummy = __UI_Type_ToggleSwitch
        CASE AddButton, AddLabel, AddTextBox, AddCheckBox, _
             AddRadioButton, AddListBox, AddDropdownList, _
             AddTrackBar, AddProgressBar, AddPictureBox, AddFrame, _
             AddToggleSwitch
            UiEditorFile = FREEFILE
            OPEN "InForm/UiEditor.dat" FOR BINARY AS #UiEditorFile
            b$ = MKI$(Dummy)
            PUT #UiEditorFile, OffsetNewControl, b$
            CLOSE #UiEditorFile
            Edited = True
        CASE AddNumericBox
            b$ = MKI$(0)
            SendData b$, 222
            Edited = True
        CASE Stretch
            b$ = MKI$(Control(id).Value)
            SendData b$, 14
            Edited = True
        CASE HasBorder
            b$ = MKI$(Control(id).Value)
            SendData b$, 15
            Edited = True
        CASE Transparent
            b$ = MKI$(Control(Transparent).Value)
            SendData b$, 28
            Edited = True
        CASE ShowPercentage
            b$ = MKI$(Control(id).Value)
            SendData b$, 16
            Edited = True
        CASE WordWrap
            b$ = MKI$(Control(id).Value)
            SendData b$, 17
            Edited = True
        CASE CanHaveFocus
            b$ = MKI$(Control(id).Value)
            SendData b$, 18
            Edited = True
        CASE ColorPreview
            _CLIPBOARD$ = ColorPreviewWord$
        CASE Disabled
            b$ = MKI$(Control(id).Value)
            SendData b$, 19
            Edited = True
        CASE Hidden
            b$ = MKI$(Control(id).Value)
            SendData b$, 20
            Edited = True
        CASE CenteredWindow
            b$ = MKI$(Control(id).Value)
            SendData b$, 21
            Edited = True
        CASE Resizable
            b$ = MKI$(Control(id).Value)
            SendData b$, 29
            Edited = True
        CASE PasswordMaskCB
            b$ = MKI$(Control(id).Value)
            SendData b$, 33
            Edited = True
        CASE ViewMenuPreview
            $IF WIN THEN
                SHELL _DONTWAIT ".\InForm\UiEditorPreview.exe"
            $ELSE
                SHELL _DONTWAIT "./InForm/UiEditorPreview"
            $END IF
        CASE ViewMenuLoadedFonts
            DIM Temp$
            Temp$ = "These fonts are currently in use in your form:" + CHR$(10)
            FOR Dummy = 1 TO UBOUND(PreviewFonts)
                IF LEN(PreviewFonts(Dummy)) THEN
                    Temp$ = Temp$ + CHR$(10)
                    Temp$ = Temp$ + PreviewFonts(Dummy)
                END IF
            NEXT
            IF LEN(Temp$) THEN
                Answer = MessageBox(Temp$, "Loaded fonts", MsgBox_OkOnly + MsgBox_Information)
            ELSE
                Answer = MessageBox("There are no fonts loaded.", "", MsgBox_OkOnly + MsgBox_Critical)
            END IF
        CASE FileMenuNew
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
            __UI_Focus = 0
            Edited = False
        CASE FileMenuSaveFrm
            SaveForm True, True
        CASE FileMenuSave
            SaveForm True, False
        CASE HelpMenuAbout
            Answer = MessageBox(UiEditorTitle$ + " " + __UI_Version + CHR$(10) + "by Fellippe Heitor" + CHR$(10) + CHR$(10) + "Twitter: @fellippeheitor" + CHR$(10) + "e-mail: fellippe@qb64.org", "About", MsgBox_OkOnly + MsgBox_Information)
        CASE HelpMenuHelp
            Answer = MessageBox("Design a form and export the resulting code to generate an event-driven QB64 program.", "What's all this?", MsgBox_OkOnly + MsgBox_Information)
        CASE FileMenuExit
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
        CASE EditMenuZOrdering
            'Fill the list:
            Caption(StatusBar) = "Editing z-ordering/tab ordering..."
            DIM j AS LONG, i AS LONG
            STATIC Moving AS _BYTE
            REDIM _PRESERVE zOrderIDs(1 TO UBOUND(PreviewControls)) AS LONG
            ReloadZList:
            ResetList ControlList
            FOR i = 1 TO UBOUND(PreviewControls)
                SELECT CASE PreviewControls(i).Type
                    CASE 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 14, 15, 18
                        j = j + 1
                        zOrderIDs(j) = i
                        AddItem ControlList, __UI_Type(PreviewControls(i).Type).Name + RTRIM$(PreviewControls(i).Name)
                END SELECT
            NEXT
            IF Moving THEN RETURN
            Control(DialogBG).Left = 0: Control(DialogBG).Top = 0
            Control(ZOrdering).Left = 18: Control(ZOrdering).Top = 40
            __UI_Focus = ControlList
            ZOrderingDialogOpen = True
        CASE CloseZOrderingBT
            Caption(StatusBar) = "Ready."
            Control(DialogBG).Left = -600: Control(DialogBG).Top = -600
            Control(ZOrdering).Left = -600: Control(ZOrdering).Top = -600
            __UI_Focus = 0
            ZOrderingDialogOpen = False
        CASE UpBT
            DIM PrevListValue AS LONG
            PrevListValue = Control(ControlList).Value
            b$ = MKL$(zOrderIDs(Control(ControlList).Value)) + MKL$(zOrderIDs(Control(ControlList).Value - 1))
            SendData b$, 211
            Edited = True
            _DELAY .1
            LoadPreview
            Moving = True: GOSUB ReloadZList
            Moving = False
            Control(ControlList).Value = PrevListValue - 1
            __UI_Focus = ControlList
            __UI_ValueChanged ControlList
        CASE DownBT
            PrevListValue = Control(ControlList).Value
            b$ = MKL$(zOrderIDs(Control(ControlList).Value)) + MKL$(zOrderIDs(Control(ControlList).Value + 1))
            SendData b$, 212
            Edited = True
            _DELAY .1
            LoadPreview
            Moving = True: GOSUB ReloadZList
            Moving = False
            Control(ControlList).Value = PrevListValue + 1
            __UI_Focus = ControlList
            __UI_ValueChanged ControlList
        CASE FileMenuOpen
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
            IF CurrentPath$ = "" THEN CurrentPath$ = _STARTDIR$
            Text(FileList) = idezfilelist$(CurrentPath$, Control(ShowOnlyFrmbinFilesCB).Value + 1, TotalFiles%)
            Control(FileList).Max = TotalFiles%
            Control(FileList).LastVisibleItem = 0 'Reset it so it's recalculated

            Control(DialogBG).Left = 0: Control(DialogBG).Top = 0
            Control(OpenFrame).Left = 18: Control(OpenFrame).Top = 40
            OpenDialogOpen = True
            Caption(StatusBar) = "Select a form file to load..."
            __UI_Focus = FileNameTextBox
            IF LEN(Text(FileNameTextBox)) > 0 THEN
                Control(FileNameTextBox).SelectionStart = 0
                Control(FileNameTextBox).Cursor = LEN(Text(FileNameTextBox))
                Control(FileNameTextBox).TextIsSelected = True
            END IF
            __UI_ForceRedraw = True
        CASE CancelBT
            Text(FileNameTextBox) = ""
            Control(DialogBG).Left = -600: Control(DialogBG).Top = -600
            Control(OpenFrame).Left = -600: Control(OpenFrame).Top = -600
            OpenDialogOpen = False
            Caption(StatusBar) = "Ready."
            'Show the preview
            SendSignal -3

            __UI_Focus = 0
            __UI_ForceRedraw = True
        CASE OpenBT
            OpenFile:
            IF OpenDialogOpen THEN
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

                    Control(DialogBG).Left = -600: Control(DialogBG).Top = -600
                    Control(OpenFrame).Left = -600: Control(OpenFrame).Top = -600
                    Control(FileList).FirstVisibleLine = 1
                    Control(FileList).InputViewStart = 1
                    Control(FileList).Value = 0
                    Control(FileList).LastVisibleItem = 0 'Reset it so it's recalculated
                    Control(DirList).FirstVisibleLine = 1
                    Control(DirList).InputViewStart = 1
                    Control(DirList).Value = 0
                    Control(DirList).LastVisibleItem = 0 'Reset it so it's recalculated
                    OpenDialogOpen = False
                    Caption(StatusBar) = "Ready."
                    __UI_Focus = 0
                ELSE
                    Answer = MessageBox("File not found.", "", MsgBox_OkOnly + MsgBox_Critical)
                    Control(FileList).Value = 0
                END IF
            END IF
        CASE FileList
            Text(FileNameTextBox) = GetItem(FileList, Control(FileList).Value)
            Control(DirList).Value = 0
            IF Control(FileList).HoveringVScrollbarButton = 0 AND LastClickedID = id AND TIMER - LastClick# < .3 THEN 'Double click
                IF LEN(Text(FileNameTextBox)) > 0 THEN GOTO OpenFile
            END IF
        CASE DirList
            Text(FileNameTextBox) = GetItem(DirList, Control(DirList).Value)
            Control(FileList).Value = 0
            IF LastClickedID = id AND TIMER - LastClick# < .3 THEN 'Double click
                CurrentPath$ = idezchangepath(CurrentPath$, Text(FileNameTextBox))
                Caption(PathLB) = "Path: " + CurrentPath$
                Text(DirList) = idezpathlist$(CurrentPath$, TotalFiles%)
                Control(DirList).Max = TotalFiles%
                Control(DirList).LastVisibleItem = 0 'Reset it so it's recalculated
                Control(DirList).Value = 0
                GOTO ReloadList
            END IF
        CASE ShowOnlyFrmbinFilesCB
            ReloadList:
            Text(FileList) = idezfilelist$(CurrentPath$, Control(ShowOnlyFrmbinFilesCB).Value + 1, TotalFiles%)
            Control(FileList).Max = TotalFiles%
            Control(FileList).FirstVisibleLine = 1
            Control(FileList).InputViewStart = 1
            Control(FileList).Value = 0
            Control(FileList).LastVisibleItem = 0 'Reset it so it's recalculated
        CASE EditMenuUndo
            b$ = MKI$(0)
            SendData b$, 214
            Edited = True
        CASE EditMenuRedo
            b$ = MKI$(0)
            SendData b$, 215
            Edited = True
        CASE EditMenuCopy
            b$ = MKI$(0)
            SendData b$, 217
        CASE EditMenuPaste
            b$ = MKI$(0)
            SendData b$, 218
            Edited = True
        CASE EditMenuCut
            b$ = MKI$(0)
            SendData b$, 219
            Edited = True
        CASE EditMenuDelete
            b$ = MKI$(0)
            SendData b$, 220
            Edited = True
        CASE EditMenuSelectAll
            b$ = MKI$(0)
            SendData b$, 221
        CASE EditMenuAllowMinMax
            b$ = MKI$(0)
            SendData b$, 223
        CASE EditMenuCP437
            b$ = MKL$(437)
            SendData b$, 34 'Encoding
            Edited = True
        CASE EditMenuCP1252
            b$ = MKL$(1252)
            SendData b$, 34 'Encoding
            Edited = True
        CASE ViewMenuShowPositionAndSize
            __UI_ShowPositionAndSize = NOT __UI_ShowPositionAndSize
            Control(id).Value = __UI_ShowPositionAndSize
            SaveSettings
    END SELECT

    LastClickedID = id
    LastClick# = TIMER
    IF Caption(StatusBar) = "" THEN Caption(StatusBar) = "Ready."
END SUB

SUB __UI_MouseEnter (id AS LONG)
    SELECT CASE id
        CASE FileMenuNew
            Caption(StatusBar) = "Creates a new project."
        CASE FileMenuOpen
            Caption(StatusBar) = "Loads an existing project from disk."
        CASE FileMenuExit
            Caption(StatusBar) = "Exits the editor."
        CASE FileMenuSave
            Caption(StatusBar) = "Saves the current project to disk."
        CASE FileMenuSaveFrm
            Caption(StatusBar) = "Saves only the current .frm file to disk."
        CASE FileMenuSave
            Caption(StatusBar) = "Saves the current project to disk."
        CASE EditMenuUndo
            Caption(StatusBar) = "Undoes the last edit."
        CASE EditMenuRedo
            Caption(StatusBar) = "Redoes the last undone edit."
        CASE EditMenuCut
            Caption(StatusBar) = "Removes the selected controls and copies them to the Clipboard."
        CASE EditMenuCopy
            Caption(StatusBar) = "Copies the selected controls to the Clipboard."
        CASE EditMenuPaste
            Caption(StatusBar) = "Inserts controls previously cut or copied from the Clipboard."
        CASE EditMenuDelete
            Caption(StatusBar) = "Removes the selected controls."
        CASE EditMenuSelectAll
            Caption(StatusBar) = "Selects all controls."
        CASE EditMenuCP437
            Caption(StatusBar) = "Applies code page 437 to the current form."
        CASE EditMenuCP1252
            Caption(StatusBar) = "Applies code page 1252 to the current form."
        CASE EditMenuSetDefaultButton
            Caption(StatusBar) = "Makes the currently selected button the default button."
        CASE EditMenuRestoreDimensions
            Caption(StatusBar) = "Makes this control have the same dimensions as the loaded image."
        CASE EditMenuAllowMinMax
            Caption(StatusBar) = "Enables the .Min and .Max properties for NumericTextBox controls."
        CASE EditMenuZOrdering
            Caption(StatusBar) = "Allows you to change tab-order/z-ordering of controls."
        CASE ViewMenuPreviewDetach
            Caption(StatusBar) = "Toggles whether the preview form will be moved with the editor."
        CASE ViewMenuShowPositionAndSize
            Caption(StatusBar) = "Toggles whether size and position indicators will be shown in the preview."
        CASE ViewMenuPreview
            Caption(StatusBar) = "Launches the preview window in case it's been closed accidentaly."
        CASE ViewMenuLoadedFonts
            Caption(StatusBar) = "Shows a list of all fonts in use in the current form."
        CASE InsertMenuMenuBar
            Caption(StatusBar) = "Inserts a new MenuBar control."
        CASE InsertMenuMenuItem
            Caption(StatusBar) = "Inserts a new MenuItem control in the currently selected menu panel."
        CASE OptionsMenuSnapLines
            Caption(StatusBar) = "Toggles whether controls edges are automatically snapped to others."
        CASE OptionsMenuAutoName
            Caption(StatusBar) = "Automatically sets control names based on caption and type"
        CASE OptionsMenuSwapButtons
            Caption(StatusBar) = "Toggles left/right mouse buttons."
        CASE ELSE
            IF Control(id).Type = __UI_Type_MenuItem OR Control(id).Type = __UI_Type_MenuBar THEN
                Caption(StatusBar) = ""
            END IF
    END SELECT
END SUB

SUB __UI_MouseLeave (id AS LONG)
END SUB

SUB __UI_FocusIn (id AS LONG)
    SELECT CASE id
        CASE NameTB, CaptionTB, TextTB, MaskTB, TopTB, LeftTB, WidthTB, HeightTB, FontTB, TooltipTB, ValueTB, MinTB, MaxTB, IntervalTB, PaddingTB, MinIntervalTB
            DIM ThisInputBox AS LONG
            ThisInputBox = GetInputBoxFromID(id)
            InputBoxText(ThisInputBox) = Text(id)
            InputBox(ThisInputBox).Sent = False
            Caption(StatusBar) = "Editing property"
        CASE FileNameTextBox
            IF OpenDialogOpen = False THEN __UI_Focus = AddButton
        CASE ControlList
            IF OpenDialogOpen THEN __UI_Focus = FileNameTextBox
        CASE BlueValue
            IF OpenDialogOpen THEN __UI_Focus = CancelBT
        CASE CloseZOrderingBT
            IF ZOrderingDialogOpen = False THEN __UI_Focus = BlueValue
        CASE AddButton
            IF ZOrderingDialogOpen THEN __UI_Focus = ControlList
        CASE CancelBT
            IF ZOrderingDialogOpen THEN __UI_Focus = CloseZOrderingBT
    END SELECT
END SUB

SUB __UI_FocusOut (id AS LONG)
    SELECT CASE id
        CASE NameTB, CaptionTB, TextTB, MaskTB, TopTB, LeftTB, WidthTB, HeightTB, FontTB, TooltipTB, ValueTB, MinTB, MaxTB, IntervalTB, PaddingTB, MinIntervalTB
            DIM ThisInputBox AS LONG
            ThisInputBox = GetInputBoxFromID(id)
            IF InputBoxText(ThisInputBox) <> Text(id) AND InputBox(ThisInputBox).Sent = False THEN
                __UI_KeepFocus = True
                Caption(StatusBar) = "Hit ENTER to confirm new property value or ESC to cancel changes..."
                BlinkStatusBar = TIMER
            ELSE
                Caption(StatusBar) = "Ready."
            END IF
    END SELECT
END SUB

SUB __UI_MouseDown (id AS LONG)
    SELECT CASE id
        CASE Red, Green, Blue
            Caption(StatusBar) = "Color picker active. Release to apply the new values..."
            DIM TempID AS LONG
            SELECT CASE Control(ColorPropertiesList).Value
                CASE 1
                    OldColor = PreviewControls(FirstSelected).ForeColor
                    IF OldColor = 0 THEN OldColor = PreviewControls(PreviewFormID).ForeColor
                    IF OldColor = 0 THEN OldColor = __UI_DefaultColor(__UI_Type_Form, 1)
                CASE 2
                    OldColor = PreviewControls(FirstSelected).BackColor
                    IF OldColor = 0 THEN OldColor = PreviewControls(PreviewFormID).BackColor
                    IF OldColor = 0 THEN OldColor = __UI_DefaultColor(__UI_Type_Form, 2)
                CASE 3
                    OldColor = PreviewControls(FirstSelected).SelectedForeColor
                    IF OldColor = 0 THEN OldColor = PreviewControls(PreviewFormID).SelectedForeColor
                    IF OldColor = 0 THEN OldColor = __UI_DefaultColor(__UI_Type_Form, 3)
                CASE 4
                    OldColor = PreviewControls(FirstSelected).SelectedBackColor
                    IF OldColor = 0 THEN OldColor = PreviewControls(PreviewFormID).SelectedBackColor
                    IF OldColor = 0 THEN OldColor = __UI_DefaultColor(__UI_Type_Form, 4)
                CASE 5
                    OldColor = PreviewControls(FirstSelected).BorderColor
                    IF OldColor = 0 THEN OldColor = PreviewControls(PreviewFormID).BorderColor
                    IF OldColor = 0 THEN OldColor = __UI_DefaultColor(__UI_Type_Form, 5)
            END SELECT
    END SELECT
END SUB

SUB __UI_MouseUp (id AS LONG)
    SELECT CASE id
        CASE Red, Green, Blue
            'Compose a new color and send it to the preview
            SendNewRGB
            Caption(StatusBar) = "Color changed."
            Edited = True
    END SELECT
END SUB

SUB SendNewRGB
    DIM b$, NewColor AS _UNSIGNED LONG
    NewColor = _RGB32(Control(Red).Value, Control(Green).Value, Control(Blue).Value)
    b$ = _MK$(_UNSIGNED LONG, NewColor)
    SendData b$, Control(ColorPropertiesList).Value + 22
END SUB

FUNCTION PropertyFullySelected%% (id AS LONG)
    PropertyFullySelected%% = Control(id).TextIsSelected AND _
                              Control(id).SelectionStart = 0 AND _
                              Control(id).Cursor = LEN(Text(id))
END FUNCTION

SUB SelectPropertyFully (id AS LONG)
    Control(id).TextIsSelected = True
    Control(id).SelectionStart = 0
    Control(id).Cursor = LEN(Text(id))
END SUB

SUB SelectFontInList (FontSetup$)
    DIM i AS LONG, thisFile$, thisSize%

    thisFile$ = UCASE$(LEFT$(FontSetup$, INSTR(FontSetup$, ",") - 1))
    thisSize% = VAL(MID$(FontSetup$, INSTR(FontSetup$, ",") + 1))
    IF thisFile$ = "" THEN EXIT SUB
    Control(FontSizeList).Value = thisSize% - 7
    FOR i = 1 TO UBOUND(FontFile)
        IF UCASE$(FontFile(i)) = thisFile$ THEN
            Control(FontList).Value = i
            EXIT FOR
        END IF
    NEXT
END SUB

SUB __UI_BeforeUpdateDisplay
    DIM b$, c$, PreviewChanged AS _BYTE, UiEditorFile AS INTEGER
    DIM PreviewHasMenuActive AS INTEGER, i AS LONG, j AS LONG, Answer AS _BYTE
    DIM OriginalImageWidth AS INTEGER, OriginalImageHeight AS INTEGER
    STATIC MidRead AS _BYTE, PrevFirstSelected AS LONG
    STATIC CheckUpdateDone AS _BYTE

    STATIC LastChange AS SINGLE
    IF TIMER - BlinkStatusBar < 1 THEN
        IF TIMER - LastChange > .2 THEN
            IF Control(StatusBar).BackColor = StatusBarBackColor THEN
                Control(StatusBar).BackColor = _RGB32(222, 194, 127)
            ELSE
                Control(StatusBar).BackColor = StatusBarBackColor
            END IF
            Control(StatusBar).Redraw = True
            LastChange = TIMER
        END IF
    ELSE
        Control(StatusBar).BackColor = StatusBarBackColor
        Control(StatusBar).Redraw = True
    END IF

    IF __UI_Focus = 0 THEN
        IF Caption(StatusBar) = "" THEN Caption(StatusBar) = "Ready."
    END IF

    IF CheckUpdates THEN
        IF CheckUpdateDone = False THEN
            STATIC ThisStep AS INTEGER
            DIM Result$
            IF ThisStep = 0 THEN ThisStep = 1

            SELECT EVERYCASE ThisStep
                CASE 1 'check availability
                    Result$ = Download$("www.qb64.org/inform/update/latest.ini", "InForm/InFormUpdate.ini", 30)
                    SELECT CASE CVI(LEFT$(Result$, 2))
                        CASE 1 'Success
                            ThisStep = 2
                        CASE 2, 3 'Can't reach server / Timeout
                            CheckUpdateDone = True
                    END SELECT
                CASE 2 'compare with current version
                    DIM localVersionNumber!, localVersionIsBeta%%
                    STATIC serverVersion$, isBeta$, serverBeta%%
                    STATIC updateDescription$

                    localVersionNumber! = VAL(ReadSetting("InForm/InFormVersion.bas", "", "CONST __UI_VersionNumber"))
                    localVersionIsBeta%% = ReadSetting("InForm/InFormVersion.bas", "", "CONST __UI_VersionIsBeta") = "True"

                    serverVersion$ = ReadSetting("InForm/InFormUpdate.ini", "", "version")
                    isBeta$ = ReadSetting("InForm/InFormUpdate.ini", "", "beta")
                    updateDescription$ = ReadSetting("InForm/InFormUpdate.ini", "", "description")
                    IF isBeta$ = "true" THEN isBeta$ = "Beta version " ELSE isBeta$ = ""
                    serverBeta%% = True

                    IF localVersionIsBeta%% THEN
                        IF serverBeta%% AND VAL(serverVersion$) <= localVersionNumber! THEN
                            CheckUpdateDone = True
                        END IF
                    ELSE
                        IF VAL(serverVersion$) <= localVersionNumber! THEN
                            CheckUpdateDone = True
                        END IF
                    END IF

                    ThisStep = 3
                    EXIT SUB
                CASE 3 'An update is available.
                    Result$ = Download$("", "", 30) 'close connection
                    CheckUpdateDone = True
                    DIM updaterPath$
                    $IF WIN THEN
                        updaterPath$ = ".\InForm\updater\InFormUpdater.exe"
                    $ELSE
                        updaterPath$ = "./InForm/updater/InFormUpdater"
                    $END IF
                    IF _FILEEXISTS(updaterPath$) THEN
                        _DELAY .2
                        IF LEN(updateDescription$) THEN
                            updateDescription$ = "\n" + CHR$(34) + updateDescription$ + CHR$(34) + "\n"
                        END IF
                        b$ = "A new version of InForm is available.\n\nCurrent version: " + __UI_Version + "\n" + "New version: " + isBeta$ + serverVersion$ + "\n" + updateDescription$ + "\n" + "Update now?"
                        Answer = MessageBox(b$, "", MsgBox_YesNo + MsgBox_Question)
                        IF Answer = MsgBox_Yes THEN
                            SHELL _DONTWAIT updaterPath$
                            SYSTEM
                        END IF
                    END IF
            END SELECT
        END IF
    END IF

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
            Control(VIEWMENUPREVIEWDETACH).Disabled = True
            Control(VIEWMENUPREVIEWDETACH).Value = False
        $END IF

        b$ = MKI$(AutoNameControls)
        PUT #UiEditorFile, OffsetAutoName, b$

        b$ = MKI$(__UI_MouseButtonsSwap)
        PUT #UiEditorFile, OffsetMouseSwapped, b$

        b$ = MKI$(__UI_ShowPositionAndSize)
        PUT #UiEditorFile, OffsetShowPosSize, b$

        b$ = MKI$(__UI_SnapLines)
        PUT #UiEditorFile, OffsetSnapLines, b$

        b$ = SPACE$(4): GET #UiEditorFile, OffsetTotalControlsSelected, b$
        TotalSelected = CVL(b$)
        b$ = SPACE$(4): GET #UiEditorFile, OffsetFormID, b$
        PreviewFormID = CVL(b$)
        b$ = SPACE$(4): GET #UiEditorFile, OffsetFirstSelectedID, b$
        FirstSelected = CVL(b$)
        b$ = SPACE$(4): GET #UiEditorFile, OffsetDefaultButtonID, b$
        PreviewDefaultButtonID = CVL(b$)
        b$ = SPACE$(2): GET #UiEditorFile, OffsetOriginalImageWidth, b$
        OriginalImageWidth = CVI(b$)
        b$ = SPACE$(2): GET #UiEditorFile, OffsetOriginalImageHeight, b$
        OriginalImageHeight = CVI(b$)
        b$ = SPACE$(2): GET #UiEditorFile, OffsetSelectionRectangle, b$
        PreviewSelectionRectangle = CVI(b$)

        Control(EditMenuRestoreDimensions).Disabled = True
        SetCaption EditMenuRestoreDimensions, "Restore &image dimensions"
        IF TotalSelected = 1 AND PreviewControls(FirstSelected).Type = __UI_Type_PictureBox AND OriginalImageWidth > 0 AND OriginalImageHeight > 0 THEN
            IF PreviewControls(FirstSelected).Height <> OriginalImageHeight OR _
               PreviewControls(FirstSelected).Width <> OriginalImageWidth THEN
                Control(EditMenuRestoreDimensions).Disabled = False
                SetCaption EditMenuRestoreDimensions, "Restore &image dimensions (" + LTRIM$(STR$(OriginalImageWidth)) + "x" + LTRIM$(STR$(OriginalImageHeight)) + ")"
            END IF
        END IF

        b$ = SPACE$(2): GET #UiEditorFile, OffsetNewDataFromPreview, b$
        IF CVI(b$) = -1 OR CVI(b$) = -3 THEN
            'Controls in the editor lose focus when the preview is manipulated
            IF CVI(b$) = -1 THEN Edited = True
            IF __UI_ActiveDropdownList > 0 THEN __UI_DestroyControl Control(__UI_ActiveDropdownList)
            IF CVI(b$) = -1 THEN
                IF __UI_ActiveMenu > 0 THEN __UI_DestroyControl Control(__UI_ActiveMenu)
            END IF
            IF __UI_ActiveMenu = 0 THEN __UI_Focus = 0
            __UI_ForceRedraw = True
        ELSEIF CVI(b$) = -2 THEN
            'User attempted to right-click a control but the preview
            'form is smaller than the menu panel. In such case the "Align"
            'menu is shown in the editor.
            IF ZOrderingDialogOpen THEN __UI_Click CloseZOrderingBT
            __UI_ActivateMenu Control(AlignMenu), False
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
        ELSEIF CVI(b$) = -7 THEN
            'A new empty form has just been created or a file has just finished loading from disk
            Edited = False
        ELSEIF CVI(b$) = -8 THEN
            'Preview form was resized
            Edited = True
        ELSEIF CVI(b$) = -9 THEN
            'User attempted to close the preview form
            __UI_Click FileMenuNew
        END IF
        b$ = MKI$(0): PUT #UiEditorFile, OffsetNewDataFromPreview, b$

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
            Caption(__UI_FormID) = UiEditorTitle$ + " - " + RTRIM$(PreviewControls(PreviewFormID).Name) + ".frm"
            SetCaption FileMenuSaveFrm, "Save &form only ('" + RTRIM$(PreviewControls(PreviewFormID).Name) + ".frm')-"
        END IF

        IF Edited THEN
            IF RIGHT$(Caption(__UI_FormID), 1) <> "*" THEN Caption(__UI_FormID) = Caption(__UI_FormID) + "*"
        END IF

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
            Edited = True
        ELSEIF (__UI_KeyHit = ASC("y") OR __UI_KeyHit = ASC("Y")) AND __UI_CtrlIsDown THEN
            b$ = MKI$(0)
            SendData b$, 215
            Edited = True
        END IF

        'Make ZOrdering menu enabled/disabled according to control list
        Control(EditMenuZOrdering).Disabled = True
        FOR i = 1 TO UBOUND(PreviewControls)
            SELECT CASE PreviewControls(i).Type
                CASE 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 14, 15, 18
                    j = j + 1
                    IF j > 1 THEN
                        Control(EditMenuZOrdering).Disabled = False
                        EXIT FOR
                    END IF
            END SELECT
        NEXT

        Control(EditMenuCP1252).Value = False
        Control(EditMenuCP437).Value = False
        SELECT CASE PreviewControls(PreviewFormID).Encoding
            CASE 0, 437
                Control(EditMenuCP437).Value = True
            CASE 1252
                Control(EditMenuCP1252).Value = True
        END SELECT

        IF PreviewHasMenuActive THEN
            Control(InsertMenuMenuItem).Disabled = False
        ELSE
            Control(InsertMenuMenuItem).Disabled = True
        END IF

        Control(EditMenuSetDefaultButton).Disabled = True
        Control(EditMenuSetDefaultButton).Value = False
        Control(EditMenuAllowMinMax).Disabled = True
        Control(EditMenuAllowMinMax).Value = False
        IF INSTR(LCASE$(PreviewControls(PreviewFormID).Name), "form") = 0 THEN
            Caption(ControlProperties) = "Control properties (Form):"
        ELSE
            Caption(ControlProperties) = "Control properties:"
        END IF
        Caption(AlignMenuAlignCenterV) = "Center Vertically (group)"
        Caption(AlignMenuAlignCenterH) = "Center Horizontally (group)-"

        Control(EditMenuPaste).Disabled = True
        IF LEFT$(_CLIPBOARD$, LEN(__UI_ClipboardCheck$)) = __UI_ClipboardCheck$ THEN
            Control(EditMenuPaste).Disabled = False
        END IF

        IF TotalSelected = 0 THEN
            FirstSelected = PreviewFormID

            Control(EditMenuCut).Disabled = True
            Control(EditMenuCopy).Disabled = True
            Control(EditMenuDelete).Disabled = True

            Control(AlignMenuAlignLeft).Disabled = True
            Control(AlignMenuAlignRight).Disabled = True
            Control(AlignMenuAlignTops).Disabled = True
            Control(AlignMenuAlignBottoms).Disabled = True
            Control(AlignMenuAlignCenterV).Disabled = True
            Control(AlignMenuAlignCenterH).Disabled = True
            Control(AlignMenuAlignCentersV).Disabled = True
            Control(AlignMenuAlignCentersH).Disabled = True
            Control(AlignMenuDistributeV).Disabled = True
            Control(AlignMenuDistributeH).Disabled = True

        ELSEIF TotalSelected = 1 THEN
            IF FirstSelected > 0 AND FirstSelected <= UBOUND(PreviewControls) THEN
                Control(EditMenuCut).Disabled = False
                Control(EditMenuCopy).Disabled = False
                Control(EditMenuDelete).Disabled = False

                IF INSTR(LCASE$(PreviewControls(FirstSelected).Name), LCASE$(RTRIM$(__UI_Type(PreviewControls(FirstSelected).Type).Name))) = 0 THEN
                    Caption(ControlProperties) = "Control properties (Type = " + RTRIM$(__UI_Type(PreviewControls(FirstSelected).Type).Name) + "):"
                ELSE
                    Caption(ControlProperties) = "Control properties:"
                END IF
                Control(AlignMenuAlignLeft).Disabled = True
                Control(AlignMenuAlignRight).Disabled = True
                Control(AlignMenuAlignTops).Disabled = True
                Control(AlignMenuAlignBottoms).Disabled = True
                IF PreviewControls(FirstSelected).Type <> __UI_Type_MenuBar AND PreviewControls(FirstSelected).Type <> __UI_Type_MenuItem THEN
                    Control(AlignMenuAlignCenterV).Disabled = False
                    Control(AlignMenuAlignCenterH).Disabled = False
                    Caption(AlignMenuAlignCenterV) = "Center Vertically"
                    Caption(AlignMenuAlignCenterH) = "Center Horizontally-"
                ELSE
                    Control(AlignMenuAlignCenterV).Disabled = True
                    Control(AlignMenuAlignCenterH).Disabled = True
                END IF
                Control(AlignMenuAlignCentersV).Disabled = True
                Control(AlignMenuAlignCentersH).Disabled = True
                Control(AlignMenuDistributeV).Disabled = True
                Control(AlignMenuDistributeH).Disabled = True

                IF PreviewControls(FirstSelected).Type = __UI_Type_Button THEN
                    Control(EditMenuSetDefaultButton).Disabled = False
                    IF PreviewDefaultButtonID <> FirstSelected THEN
                        Control(EditMenuSetDefaultButton).Value = False
                    ELSE
                        Control(EditMenuSetDefaultButton).Value = True
                    END IF
                ELSEIF PreviewControls(FirstSelected).Type = __UI_Type_TextBox THEN
                    IF PreviewControls(FirstSelected).NumericOnly = True THEN
                        Control(EditMenuAllowMinMax).Disabled = False
                        Control(EditMenuAllowMinMax).Value = False
                        IF INSTR(PreviewControls(FirstSelected).Name, "NumericTextBox") = 0 THEN Caption(ControlProperties) = "Control properties (Type = NumericTextBox):"
                    ELSEIF PreviewControls(FirstSelected).NumericOnly = __UI_NumericWithBounds THEN
                        Control(EditMenuAllowMinMax).Disabled = False
                        Control(EditMenuAllowMinMax).Value = True
                        IF INSTR(PreviewControls(FirstSelected).Name, "NumericTextBox") = 0 THEN Caption(ControlProperties) = "Control properties (Type = NumericTextBox):"
                    END IF
                END IF
            END IF

        ELSEIF TotalSelected = 2 THEN
            Caption(ControlProperties) = "Control properties: (multiple selection)"

            Control(EditMenuCut).Disabled = False
            Control(EditMenuCopy).Disabled = False
            Control(EditMenuDelete).Disabled = False

            Control(AlignMenuAlignLeft).Disabled = False
            Control(AlignMenuAlignRight).Disabled = False
            Control(AlignMenuAlignTops).Disabled = False
            Control(AlignMenuAlignBottoms).Disabled = False
            Control(AlignMenuAlignCenterV).Disabled = False
            Control(AlignMenuAlignCenterH).Disabled = False
            Control(AlignMenuAlignCentersV).Disabled = False
            Control(AlignMenuAlignCentersH).Disabled = False
            Control(AlignMenuDistributeV).Disabled = True
            Control(AlignMenuDistributeH).Disabled = True

        ELSE
            SetCaption ControlProperties, "Control properties: (multiple selection)"

            Control(EditMenuCut).Disabled = False
            Control(EditMenuCopy).Disabled = False
            Control(EditMenuDelete).Disabled = False

            Control(AlignMenuAlignLeft).Disabled = False
            Control(AlignMenuAlignRight).Disabled = False
            Control(AlignMenuAlignTops).Disabled = False
            Control(AlignMenuAlignBottoms).Disabled = False
            Control(AlignMenuAlignCenterV).Disabled = False
            Control(AlignMenuAlignCenterH).Disabled = False
            Control(AlignMenuAlignCentersV).Disabled = False
            Control(AlignMenuAlignCentersH).Disabled = False
            Control(AlignMenuDistributeV).Disabled = False
            Control(AlignMenuDistributeH).Disabled = False

        END IF

        IF FirstSelected = 0 THEN FirstSelected = PreviewFormID

        FOR i = 1 TO UBOUND(InputBox)
            Control(InputBox(i).ID).Disabled = False
            Control(InputBox(i).ID).Hidden = False
            Control(InputBox(i).LabelID).Hidden = False
            IF __UI_Focus = InputBox(i).ID THEN
                Control(InputBox(i).ID).Height = 22
                Control(InputBox(i).ID).BorderColor = _RGB32(0, 0, 0)
                Control(InputBox(i).ID).HasBorder = 1
            ELSE
                Control(InputBox(i).ID).Height = 23
                Control(InputBox(i).ID).BorderColor = __UI_DefaultColor(__UI_Type_TextBox, 5)
                Control(InputBox(i).ID).HasBorder = True
            END IF
        NEXT
        Control(FontSizeList).Hidden = True

        DIM ShadeOfGreen AS _UNSIGNED LONG, ShadeOfRed AS _UNSIGNED LONG
        ShadeOfGreen = _RGB32(28, 150, 50)
        ShadeOfRed = _RGB32(233, 44, 0)

        CONST PropertyUpdateDelay = .1

        IF FirstSelected > 0 THEN
            DIM ThisInputBox AS LONG
            ThisInputBox = GetInputBoxFromID(__UI_Focus)

            IF __UI_Focus <> NameTB OR (__UI_Focus = NameTB AND RevertEdit = True) THEN
                Text(NameTB) = RTRIM$(PreviewControls(FirstSelected).Name)
                IF (__UI_Focus = NameTB AND RevertEdit = True) THEN RevertEdit = False: SelectPropertyFully __UI_Focus
            ELSEIF __UI_Focus = NameTB THEN
                IF PropertyFullySelected(NameTB) THEN
                    IF Text(NameTB) = RTRIM$(PreviewControls(FirstSelected).Name) THEN
                        Control(__UI_Focus).BorderColor = ShadeOfGreen
                    ELSE
                        IF TIMER - InputBox(ThisInputBox).LastEdited < PropertyUpdateDelay THEN
                            Control(__UI_Focus).BorderColor = __UI_DefaultColor(__UI_Type_TextBox, 5)
                        ELSE
                            Control(__UI_Focus).BorderColor = ShadeOfRed
                        END IF
                    END IF
                END IF
            END IF
            IF __UI_Focus <> CaptionTB OR (__UI_Focus = CaptionTB AND RevertEdit = True) THEN
                Text(CaptionTB) = Replace(__UI_TrimAt0$(PreviewCaptions(FirstSelected)), CHR$(10), "\n", False, 0)
                IF (__UI_Focus = CaptionTB AND RevertEdit = True) THEN RevertEdit = False: SelectPropertyFully __UI_Focus
            ELSEIF __UI_Focus = CaptionTB THEN
                IF PropertyFullySelected(CaptionTB) THEN
                    IF Text(CaptionTB) = Replace(__UI_TrimAt0$(PreviewCaptions(FirstSelected)), CHR$(10), "\n", False, 0) THEN
                        Control(__UI_Focus).BorderColor = ShadeOfGreen
                    ELSE
                        IF TIMER - InputBox(ThisInputBox).LastEdited < PropertyUpdateDelay THEN
                            Control(__UI_Focus).BorderColor = __UI_DefaultColor(__UI_Type_TextBox, 5)
                        ELSE
                            Control(__UI_Focus).BorderColor = ShadeOfRed
                        END IF
                    END IF
                END IF
            END IF
            IF __UI_Focus <> TextTB OR (__UI_Focus = TextTB AND RevertEdit = True) THEN
                IF PreviewControls(FirstSelected).Type = __UI_Type_ListBox OR PreviewControls(FirstSelected).Type = __UI_Type_DropdownList THEN
                    Text(TextTB) = Replace(PreviewTexts(FirstSelected), CHR$(13), "\n", False, 0)
                ELSE
                    Text(TextTB) = PreviewTexts(FirstSelected)
                    IF LEN(PreviewMasks(FirstSelected)) > 0 AND PreviewControls(FirstSelected).Type = __UI_Type_TextBox THEN
                        Mask(TextTB) = PreviewMasks(FirstSelected)
                    ELSE
                        Mask(TextTB) = ""
                    END IF
                END IF
                IF (__UI_Focus = TextTB AND RevertEdit = True) THEN RevertEdit = False: SelectPropertyFully __UI_Focus
            ELSEIF __UI_Focus = TextTB THEN
                Control(TextTB).NumericOnly = PreviewControls(FirstSelected).NumericOnly
                IF PropertyFullySelected(TextTB) THEN
                    IF ((PreviewControls(FirstSelected).Type = __UI_Type_ListBox OR PreviewControls(FirstSelected).Type = __UI_Type_DropdownList) AND Text(TextTB) = Replace(PreviewTexts(FirstSelected), CHR$(13), "\n", False, 0)) OR _
                       ((PreviewControls(FirstSelected).Type <> __UI_Type_ListBox AND PreviewControls(FirstSelected).Type <> __UI_Type_DropdownList) AND Text(TextTB) = PreviewTexts(FirstSelected)) THEN
                        Control(__UI_Focus).BorderColor = ShadeOfGreen
                    ELSE
                        IF TIMER - InputBox(ThisInputBox).LastEdited < PropertyUpdateDelay THEN
                            Control(__UI_Focus).BorderColor = __UI_DefaultColor(__UI_Type_TextBox, 5)
                        ELSE
                            Control(__UI_Focus).BorderColor = ShadeOfRed
                        END IF
                    END IF
                END IF
            END IF
            IF __UI_Focus <> MaskTB OR (__UI_Focus = MaskTB AND RevertEdit = True) THEN
                Text(MaskTB) = PreviewMasks(FirstSelected)
                IF (__UI_Focus = MaskTB AND RevertEdit = True) THEN RevertEdit = False: SelectPropertyFully __UI_Focus
            ELSEIF __UI_Focus = MaskTB THEN
                IF PropertyFullySelected(MaskTB) THEN
                    IF Text(MaskTB) = PreviewMasks(FirstSelected) THEN
                        Control(__UI_Focus).BorderColor = ShadeOfGreen
                    ELSE
                        IF TIMER - InputBox(ThisInputBox).LastEdited < PropertyUpdateDelay THEN
                            Control(__UI_Focus).BorderColor = __UI_DefaultColor(__UI_Type_TextBox, 5)
                        ELSE
                            Control(__UI_Focus).BorderColor = ShadeOfRed
                        END IF
                    END IF
                END IF
            END IF
            IF __UI_Focus <> TopTB OR (__UI_Focus = TopTB AND RevertEdit = True) THEN
                Text(TopTB) = LTRIM$(STR$(PreviewControls(FirstSelected).Top))
                IF (__UI_Focus = TopTB AND RevertEdit = True) THEN RevertEdit = False: SelectPropertyFully __UI_Focus
            ELSEIF __UI_Focus = TopTB THEN
                IF PropertyFullySelected(TopTB) THEN
                    IF Text(TopTB) = LTRIM$(STR$(PreviewControls(FirstSelected).Top)) THEN
                        Control(__UI_Focus).BorderColor = ShadeOfGreen
                    ELSE
                        IF TIMER - InputBox(ThisInputBox).LastEdited < PropertyUpdateDelay THEN
                            Control(__UI_Focus).BorderColor = __UI_DefaultColor(__UI_Type_TextBox, 5)
                        ELSE
                            Control(__UI_Focus).BorderColor = ShadeOfRed
                        END IF
                    END IF
                END IF
            END IF
            IF __UI_Focus <> LeftTB OR (__UI_Focus = LeftTB AND RevertEdit = True) THEN
                Text(LeftTB) = LTRIM$(STR$(PreviewControls(FirstSelected).Left))
                IF (__UI_Focus = LeftTB AND RevertEdit = True) THEN RevertEdit = False: SelectPropertyFully __UI_Focus
            ELSEIF __UI_Focus = LeftTB THEN
                IF PropertyFullySelected(LeftTB) THEN
                    IF Text(LeftTB) = LTRIM$(STR$(PreviewControls(FirstSelected).Left)) THEN
                        Control(__UI_Focus).BorderColor = ShadeOfGreen
                    ELSE
                        IF TIMER - InputBox(ThisInputBox).LastEdited < PropertyUpdateDelay THEN
                            Control(__UI_Focus).BorderColor = __UI_DefaultColor(__UI_Type_TextBox, 5)
                        ELSE
                            Control(__UI_Focus).BorderColor = ShadeOfRed
                        END IF
                    END IF
                END IF
            END IF
            IF __UI_Focus <> WidthTB OR (__UI_Focus = WidthTB AND RevertEdit = True) THEN
                Text(WidthTB) = LTRIM$(STR$(PreviewControls(FirstSelected).Width))
                IF (__UI_Focus = WidthTB AND RevertEdit = True) THEN RevertEdit = False: SelectPropertyFully __UI_Focus
            ELSEIF __UI_Focus = WidthTB THEN
                IF PropertyFullySelected(WidthTB) THEN
                    IF Text(WidthTB) = LTRIM$(STR$(PreviewControls(FirstSelected).Width)) THEN
                        Control(__UI_Focus).BorderColor = ShadeOfGreen
                    ELSE
                        IF TIMER - InputBox(ThisInputBox).LastEdited < PropertyUpdateDelay THEN
                            Control(__UI_Focus).BorderColor = __UI_DefaultColor(__UI_Type_TextBox, 5)
                        ELSE
                            Control(__UI_Focus).BorderColor = ShadeOfRed
                        END IF
                    END IF
                END IF
            END IF
            IF __UI_Focus <> HeightTB OR (__UI_Focus = HeightTB AND RevertEdit = True) THEN
                Text(HeightTB) = LTRIM$(STR$(PreviewControls(FirstSelected).Height))
                IF (__UI_Focus = HeightTB AND RevertEdit = True) THEN RevertEdit = False: SelectPropertyFully __UI_Focus
            ELSEIF __UI_Focus = HeightTB THEN
                IF PropertyFullySelected(HeightTB) THEN
                    IF Text(HeightTB) = LTRIM$(STR$(PreviewControls(FirstSelected).Height)) THEN
                        Control(__UI_Focus).BorderColor = ShadeOfGreen
                    ELSE
                        IF TIMER - InputBox(ThisInputBox).LastEdited < PropertyUpdateDelay THEN
                            Control(__UI_Focus).BorderColor = __UI_DefaultColor(__UI_Type_TextBox, 5)
                        ELSE
                            Control(__UI_Focus).BorderColor = ShadeOfRed
                        END IF
                    END IF
                END IF
            END IF
            IF HasFontList = False THEN
                IF __UI_Focus <> FontTB OR (__UI_Focus = FontTB AND RevertEdit = True) THEN
                    IF LEN(PreviewFonts(FirstSelected)) > 0 THEN
                        Text(FontTB) = PreviewFonts(FirstSelected)
                    ELSE
                        Text(FontTB) = PreviewFonts(PreviewFormID)
                    END IF
                    IF (__UI_Focus = FontTB AND RevertEdit = True) THEN RevertEdit = False: SelectPropertyFully __UI_Focus
                ELSEIF __UI_Focus = FontTB THEN
                    IF PropertyFullySelected(FontTB) THEN
                        IF Text(FontTB) = PreviewFonts(FirstSelected) OR Text(FontTB) = PreviewFonts(PreviewFormID) THEN
                            Control(__UI_Focus).BorderColor = ShadeOfGreen
                        ELSE
                            IF TIMER - InputBox(ThisInputBox).LastEdited < PropertyUpdateDelay THEN
                                Control(__UI_Focus).BorderColor = __UI_DefaultColor(__UI_Type_TextBox, 5)
                            ELSE
                                Control(__UI_Focus).BorderColor = ShadeOfRed
                            END IF
                        END IF
                    END IF
                END IF
            ELSE
                IF LEN(PreviewFonts(FirstSelected)) > 0 THEN
                    SelectFontInList PreviewFonts(FirstSelected)
                ELSE
                    SelectFontInList PreviewFonts(PreviewFormID)
                END IF
            END IF
            IF __UI_Focus <> TooltipTB OR (__UI_Focus = TooltipTB AND RevertEdit = True) THEN
                Text(TooltipTB) = Replace(PreviewTips(FirstSelected), CHR$(10), "\n", False, 0)
                IF (__UI_Focus = TooltipTB AND RevertEdit = True) THEN RevertEdit = False: SelectPropertyFully __UI_Focus
            ELSEIF __UI_Focus = TooltipTB THEN
                IF PropertyFullySelected(FontTB) THEN
                    IF Text(TooltipTB) = Replace(PreviewTips(FirstSelected), CHR$(10), "\n", False, 0) THEN
                        Control(__UI_Focus).BorderColor = ShadeOfGreen
                    ELSE
                        IF TIMER - InputBox(ThisInputBox).LastEdited < PropertyUpdateDelay THEN
                            Control(__UI_Focus).BorderColor = __UI_DefaultColor(__UI_Type_TextBox, 5)
                        ELSE
                            Control(__UI_Focus).BorderColor = ShadeOfRed
                        END IF
                    END IF
                END IF
            END IF
            IF __UI_Focus <> ValueTB OR (__UI_Focus = ValueTB AND RevertEdit = True) THEN
                Text(ValueTB) = LTRIM$(STR$(PreviewControls(FirstSelected).Value))
                IF (__UI_Focus = ValueTB AND RevertEdit = True) THEN RevertEdit = False: SelectPropertyFully __UI_Focus
            ELSEIF __UI_Focus = ValueTB THEN
                IF PropertyFullySelected(ValueTB) THEN
                    IF Text(ValueTB) = LTRIM$(STR$(PreviewControls(FirstSelected).Value)) THEN
                        Control(__UI_Focus).BorderColor = ShadeOfGreen
                    ELSE
                        IF TIMER - InputBox(ThisInputBox).LastEdited < PropertyUpdateDelay THEN
                            Control(__UI_Focus).BorderColor = __UI_DefaultColor(__UI_Type_TextBox, 5)
                        ELSE
                            Control(__UI_Focus).BorderColor = ShadeOfRed
                        END IF
                    END IF
                END IF
            END IF
            IF __UI_Focus <> MinTB OR (__UI_Focus = MinTB AND RevertEdit = True) THEN
                Text(MinTB) = LTRIM$(STR$(PreviewControls(FirstSelected).Min))
                IF (__UI_Focus = MinTB AND RevertEdit = True) THEN RevertEdit = False: SelectPropertyFully __UI_Focus
            ELSEIF __UI_Focus = MinTB THEN
                IF PropertyFullySelected(MinTB) THEN
                    IF Text(MinTB) = LTRIM$(STR$(PreviewControls(FirstSelected).Min)) THEN
                        Control(__UI_Focus).BorderColor = ShadeOfGreen
                    ELSE
                        IF TIMER - InputBox(ThisInputBox).LastEdited < PropertyUpdateDelay THEN
                            Control(__UI_Focus).BorderColor = __UI_DefaultColor(__UI_Type_TextBox, 5)
                        ELSE
                            Control(__UI_Focus).BorderColor = ShadeOfRed
                        END IF
                    END IF
                END IF
            END IF
            IF __UI_Focus <> MaxTB OR (__UI_Focus = MaxTB AND RevertEdit = True) THEN
                Text(MaxTB) = LTRIM$(STR$(PreviewControls(FirstSelected).Max))
                IF (__UI_Focus = MaxTB AND RevertEdit = True) THEN RevertEdit = False: SelectPropertyFully __UI_Focus
            ELSEIF __UI_Focus = MaxTB THEN
                IF PropertyFullySelected(MaxTB) THEN
                    IF Text(MaxTB) = LTRIM$(STR$(PreviewControls(FirstSelected).Max)) THEN
                        Control(__UI_Focus).BorderColor = ShadeOfGreen
                    ELSE
                        IF TIMER - InputBox(ThisInputBox).LastEdited < PropertyUpdateDelay THEN
                            Control(__UI_Focus).BorderColor = __UI_DefaultColor(__UI_Type_TextBox, 5)
                        ELSE
                            Control(__UI_Focus).BorderColor = ShadeOfRed
                        END IF
                    END IF
                END IF
            END IF
            IF __UI_Focus <> IntervalTB OR (__UI_Focus = IntervalTB AND RevertEdit = True) THEN
                Text(IntervalTB) = LTRIM$(STR$(PreviewControls(FirstSelected).Interval))
                IF (__UI_Focus = IntervalTB AND RevertEdit = True) THEN RevertEdit = False: SelectPropertyFully __UI_Focus
            ELSEIF __UI_Focus = IntervalTB THEN
                IF PropertyFullySelected(IntervalTB) THEN
                    IF Text(IntervalTB) = LTRIM$(STR$(PreviewControls(FirstSelected).Interval)) THEN
                        Control(__UI_Focus).BorderColor = ShadeOfGreen
                    ELSE
                        IF TIMER - InputBox(ThisInputBox).LastEdited < PropertyUpdateDelay THEN
                            Control(__UI_Focus).BorderColor = __UI_DefaultColor(__UI_Type_TextBox, 5)
                        ELSE
                            Control(__UI_Focus).BorderColor = ShadeOfRed
                        END IF
                    END IF
                END IF
            END IF
            IF __UI_Focus <> MinIntervalTB OR (__UI_Focus = MinIntervalTB AND RevertEdit = True) THEN
                Text(MinIntervalTB) = LTRIM$(STR$(PreviewControls(FirstSelected).MinInterval))
            ELSEIF __UI_Focus = MinIntervalTB THEN
                IF PropertyFullySelected(MinIntervalTB) THEN
                    IF Text(MinIntervalTB) = LTRIM$(STR$(PreviewControls(FirstSelected).MinInterval)) THEN
                        Control(__UI_Focus).BorderColor = ShadeOfGreen
                    ELSE
                        IF TIMER - InputBox(ThisInputBox).LastEdited < PropertyUpdateDelay THEN
                            Control(__UI_Focus).BorderColor = __UI_DefaultColor(__UI_Type_TextBox, 5)
                        ELSE
                            Control(__UI_Focus).BorderColor = ShadeOfRed
                        END IF
                    END IF
                END IF
            END IF
            IF __UI_Focus <> PaddingTB OR (__UI_Focus = PaddingTB AND RevertEdit = True) THEN
                Text(PaddingTB) = LTRIM$(STR$(PreviewControls(FirstSelected).Padding))
                IF (__UI_Focus = PaddingTB AND RevertEdit = True) THEN RevertEdit = False: SelectPropertyFully __UI_Focus
            ELSEIF __UI_Focus = PaddingTB THEN
                IF PropertyFullySelected(PaddingTB) THEN
                    IF Text(PaddingTB) = LTRIM$(STR$(PreviewControls(FirstSelected).Padding)) THEN
                        Control(__UI_Focus).BorderColor = ShadeOfGreen
                    ELSE
                        IF TIMER - InputBox(ThisInputBox).LastEdited < PropertyUpdateDelay THEN
                            Control(__UI_Focus).BorderColor = __UI_DefaultColor(__UI_Type_TextBox, 5)
                        ELSE
                            Control(__UI_Focus).BorderColor = ShadeOfRed
                        END IF
                    END IF
                END IF
            END IF
        END IF

        Control(TextTB).Max = 0
        Control(TextTB).Min = 0
        IF PreviewControls(FirstSelected).Type = __UI_Type_TextBox AND __UI_Focus = TextTB THEN
            Control(TextTB).Max = PreviewControls(FirstSelected).Max
            Control(TextTB).Min = PreviewControls(FirstSelected).Min
        END IF

        'Update checkboxes:
        Control(Stretch).Value = PreviewControls(FirstSelected).Stretch
        Control(HasBorder).Value = PreviewControls(FirstSelected).HasBorder
        Control(ShowPercentage).Value = PreviewControls(FirstSelected).ShowPercentage
        Control(WordWrap).Value = PreviewControls(FirstSelected).WordWrap
        Control(CanHaveFocus).Value = PreviewControls(FirstSelected).CanHaveFocus
        Control(Disabled).Value = PreviewControls(FirstSelected).Disabled
        Control(Hidden).Value = PreviewControls(FirstSelected).Hidden
        Control(CenteredWindow).Value = PreviewControls(FirstSelected).CenteredWindow
        Control(PasswordMaskCB).Value = PreviewControls(FirstSelected).PasswordField
        Control(BooleanOptions).Value = ABS(PreviewControls(FirstSelected).Value <> 0) + 1
        Control(AlignOptions).Value = PreviewControls(FirstSelected).Align + 1
        Control(VAlignOptions).Value = PreviewControls(FirstSelected).VAlign + 1
        Control(BulletOptions).Value = PreviewControls(FirstSelected).BulletStyle + 1
        Control(Transparent).Value = PreviewControls(FirstSelected).BackStyle
        Control(Resizable).Value = PreviewControls(FirstSelected).CanResize

        'Disable properties that don't apply
        Control(Stretch).Disabled = True
        Control(HasBorder).Disabled = True
        Control(ShowPercentage).Disabled = True
        Control(WordWrap).Disabled = True
        Control(CanHaveFocus).Disabled = True
        Control(Disabled).Disabled = True
        Control(Hidden).Disabled = True
        Control(CenteredWindow).Disabled = True
        Control(PasswordMaskCB).Disabled = True
        Control(AlignOptions).Disabled = True
        Control(BooleanOptions).Disabled = True
        Control(VAlignOptions).Disabled = True
        Control(BulletOptions).Disabled = True
        Control(Transparent).Disabled = True
        Caption(TextLB) = "Text"
        Caption(ValueLB) = "Value"
        Control(Resizable).Disabled = True
        IF TotalSelected > 0 THEN
            SELECT EVERYCASE PreviewControls(FirstSelected).Type
                CASE __UI_Type_ToggleSwitch
                    Control(CanHaveFocus).Disabled = False
                    Control(Disabled).Disabled = False
                    Control(Hidden).Disabled = False
                    Control(CaptionTB).Disabled = True
                    Control(BooleanOptions).Disabled = False
                    Control(TextTB).Disabled = True
                    Control(FontTB).Disabled = True
                    Control(FontList).Disabled = True
                    Control(MinTB).Disabled = True
                    Control(MaxTB).Disabled = True
                    Control(IntervalTB).Disabled = True
                    Control(MinIntervalTB).Disabled = True
                    Control(PaddingTB).Disabled = True
                    Control(BulletOptions).Disabled = True
                CASE __UI_Type_MenuBar, __UI_Type_MenuItem
                    Control(Disabled).Disabled = False
                    Control(Hidden).Disabled = False
                CASE __UI_Type_MenuBar
                    'Check if this is the last menu bar item so that Align options can be enabled
                    FOR i = UBOUND(PreviewControls) TO 1 STEP -1
                        IF PreviewControls(i).ID > 0 AND PreviewControls(i).Type = __UI_Type_MenuBar THEN
                            EXIT FOR
                        END IF
                    NEXT
                    IF i = FirstSelected THEN
                        Control(AlignOptions).Disabled = False
                    END IF

                    FOR i = 1 TO UBOUND(InputBox)
                        SELECT CASE InputBox(i).ID
                            CASE NameTB, CaptionTB, TooltipTB, AlignOptions
                                Control(InputBox(i).ID).Disabled = False
                            CASE ELSE
                                Control(InputBox(i).ID).Disabled = True
                        END SELECT
                    NEXT
                CASE __UI_Type_MenuItem
                    FOR i = 1 TO UBOUND(InputBox)
                        SELECT CASE InputBox(i).ID
                            CASE NameTB, CaptionTB, TextTB, TooltipTB, BulletOptions, BooleanOptions
                                Control(InputBox(i).ID).Disabled = False
                            CASE ELSE
                                Control(InputBox(i).ID).Disabled = True
                        END SELECT
                    NEXT
                CASE __UI_Type_PictureBox
                    Caption(TextLB) = "Image file"
                    Control(AlignOptions).Disabled = False
                    Control(VAlignOptions).Disabled = False
                    Control(Stretch).Disabled = False
                    Control(Transparent).Disabled = False
                    FOR i = 1 TO UBOUND(InputBox)
                        SELECT CASE InputBox(i).ID
                            CASE NameTB, TextTB, TopTB, LeftTB, WidthTB, HeightTB, TooltipTB, AlignOptions, VAlignOptions
                                Control(InputBox(i).ID).Disabled = False
                            CASE ELSE
                                Control(InputBox(i).ID).Disabled = True
                        END SELECT
                    NEXT
                CASE __UI_Type_Label
                    Control(Transparent).Disabled = False
                    FOR i = 1 TO UBOUND(InputBox)
                        SELECT CASE InputBox(i).ID
                            CASE NameTB, CaptionTB, TopTB, LeftTB, WidthTB, HeightTB, FontTB, TooltipTB, PaddingTB, AlignOptions, VAlignOptions, FontList
                                Control(InputBox(i).ID).Disabled = False
                            CASE ELSE
                                Control(InputBox(i).ID).Disabled = True
                        END SELECT
                    NEXT
                CASE __UI_Type_Frame
                    Control(Transparent).Disabled = False
                    FOR i = 1 TO UBOUND(InputBox)
                        SELECT CASE InputBox(i).ID
                            CASE NameTB, CaptionTB, TopTB, LeftTB, WidthTB, HeightTB, FontTB, TooltipTB, FontList
                                Control(InputBox(i).ID).Disabled = False
                            CASE ELSE
                                Control(InputBox(i).ID).Disabled = True
                        END SELECT
                    NEXT
                CASE __UI_Type_TextBox
                    STATIC PreviousNumericState AS _BYTE
                    Control(Transparent).Disabled = False
                    Control(PasswordMaskCB).Disabled = (PreviewControls(FirstSelected).NumericOnly <> False)
                    Caption(MaxLB) = "Max"
                    IF PreviousNumericState <> PreviewControls(FirstSelected).NumericOnly THEN
                        PreviousNumericState = PreviewControls(FirstSelected).NumericOnly
                        __UI_ForceRedraw = True
                    END IF
                    IF PreviewControls(FirstSelected).NumericOnly = True THEN
                        FOR i = 1 TO UBOUND(InputBox)
                            SELECT CASE InputBox(i).ID
                                CASE ValueTB, MinTB, MaxTB, MaskTB, IntervalTB, PaddingTB, AlignOptions, VAlignOptions, MinIntervalTB, BulletOptions, BooleanOptions
                                    Control(InputBox(i).ID).Disabled = True
                                CASE ELSE
                                    Control(InputBox(i).ID).Disabled = False
                            END SELECT
                        NEXT
                    ELSEIF PreviewControls(FirstSelected).NumericOnly = __UI_NumericWithBounds THEN
                        FOR i = 1 TO UBOUND(InputBox)
                            SELECT CASE InputBox(i).ID
                                CASE ValueTB, MaskTB, IntervalTB, PaddingTB, AlignOptions, VAlignOptions, MinIntervalTB, BulletOptions, BooleanOptions
                                    Control(InputBox(i).ID).Disabled = True
                                CASE ELSE
                                    Control(InputBox(i).ID).Disabled = False
                            END SELECT
                        NEXT
                    ELSE
                        Caption(MaxLB) = "Max length"
                        FOR i = 1 TO UBOUND(InputBox)
                            SELECT CASE InputBox(i).ID
                                CASE ValueTB, MinTB, IntervalTB, PaddingTB, AlignOptions, VAlignOptions, MinIntervalTB, BulletOptions, BooleanOptions
                                    Control(InputBox(i).ID).Disabled = True
                                CASE ELSE
                                    Control(InputBox(i).ID).Disabled = False
                            END SELECT
                        NEXT
                    END IF
                CASE __UI_Type_Button, __UI_Type_MenuItem
                    Caption(TextLB) = "Image file"
                CASE __UI_Type_Button
                    FOR i = 1 TO UBOUND(InputBox)
                        SELECT CASE InputBox(i).ID
                            CASE ValueTB, MinTB, MaxTB, IntervalTB, PaddingTB, MaskTB, AlignOptions, VAlignOptions, MinIntervalTB, BulletOptions, BooleanOptions
                                Control(InputBox(i).ID).Disabled = True
                            CASE ELSE
                                Control(InputBox(i).ID).Disabled = False
                        END SELECT
                    NEXT
                CASE __UI_Type_CheckBox, __UI_Type_RadioButton
                    Control(Transparent).Disabled = False
                    FOR i = 1 TO UBOUND(InputBox)
                        SELECT CASE InputBox(i).ID
                            CASE TextTB, MinTB, MaxTB, IntervalTB, PaddingTB, MaskTB, AlignOptions, VAlignOptions, MinIntervalTB, BulletOptions, ValueTB
                                Control(InputBox(i).ID).Disabled = True
                            CASE ELSE
                                Control(InputBox(i).ID).Disabled = False
                        END SELECT
                    NEXT
                CASE __UI_Type_ToggleSwitch
                    Control(Transparent).Disabled = False
                    FOR i = 1 TO UBOUND(InputBox)
                        SELECT CASE InputBox(i).ID
                            CASE TextTB, MinTB, MaxTB, IntervalTB, PaddingTB, MaskTB, AlignOptions, VAlignOptions, MinIntervalTB, BulletOptions, ValueTB, FontTB, FontList
                                Control(InputBox(i).ID).Disabled = True
                            CASE ELSE
                                Control(InputBox(i).ID).Disabled = False
                        END SELECT
                    NEXT
                CASE __UI_Type_ProgressBar
                    FOR i = 1 TO UBOUND(InputBox)
                        SELECT CASE InputBox(i).ID
                            CASE TextTB, IntervalTB, PaddingTB, MaskTB, AlignOptions, VAlignOptions, MinIntervalTB, BulletOptions, BooleanOptions
                                Control(InputBox(i).ID).Disabled = True
                            CASE ELSE
                                Control(InputBox(i).ID).Disabled = False
                        END SELECT
                    NEXT
                CASE __UI_Type_TrackBar
                    FOR i = 1 TO UBOUND(InputBox)
                        SELECT CASE InputBox(i).ID
                            CASE CaptionTB, TextTB, FontTB, PaddingTB, MaskTB, AlignOptions, VAlignOptions, BulletOptions, BooleanOptions, FontList
                                Control(InputBox(i).ID).Disabled = True
                            CASE ELSE
                                Control(InputBox(i).ID).Disabled = False
                        END SELECT
                    NEXT
                CASE __UI_Type_ListBox, __UI_Type_DropdownList
                    Caption(TextLB) = "List items"
                    Caption(ValueLB) = "Selected item"
                    Control(Transparent).Disabled = False
                    FOR i = 1 TO UBOUND(InputBox)
                        SELECT CASE InputBox(i).ID
                            CASE CaptionTB, MinTB, MaxTB, IntervalTB, PaddingTB, MaskTB, AlignOptions, VAlignOptions, MinIntervalTB, BulletOptions, BooleanOptions
                                Control(InputBox(i).ID).Disabled = True
                            CASE ELSE
                                Control(InputBox(i).ID).Disabled = False
                        END SELECT
                    NEXT
                CASE __UI_Type_Frame, __UI_Type_Label, __UI_Type_TextBox, __UI_Type_ListBox, __UI_Type_DropdownList, __UI_Type_PictureBox
                    Control(HasBorder).Disabled = False
                CASE __UI_Type_ProgressBar
                    Control(ShowPercentage).Disabled = False
                CASE __UI_Type_Label
                    Control(WordWrap).Disabled = False
                CASE __UI_Type_Button, __UI_Type_CheckBox, __UI_Type_RadioButton, __UI_Type_TextBox, __UI_Type_ListBox, __UI_Type_DropdownList, __UI_Type_TrackBar
                    Control(CanHaveFocus).Disabled = False
                CASE __UI_Type_Button, __UI_Type_CheckBox, __UI_Type_RadioButton, __UI_Type_TextBox, __UI_Type_ListBox, __UI_Type_DropdownList, __UI_Type_TrackBar, __UI_Type_Label, __UI_Type_ProgressBar
                    Control(Disabled).Disabled = False
                CASE __UI_Type_Frame, __UI_Type_Button, __UI_Type_CheckBox, __UI_Type_RadioButton, __UI_Type_TextBox, __UI_Type_ListBox, __UI_Type_DropdownList, __UI_Type_TrackBar, __UI_Type_Label, __UI_Type_ProgressBar, __UI_Type_PictureBox
                    Control(Hidden).Disabled = False
                CASE __UI_Type_Label
                    Control(AlignOptions).Disabled = False
                    Control(VAlignOptions).Disabled = False
            END SELECT
        ELSE
            'Properties relative to the form
            Control(CenteredWindow).Disabled = False
            Control(Resizable).Disabled = False
            Caption(TextLB) = "Icon file"

            FOR i = 1 TO UBOUND(InputBox)
                SELECT CASE InputBox(i).ID
                    CASE NameTB, CaptionTB, TextTB, WidthTB, HeightTB, FontTB, FontList
                        Control(InputBox(i).ID).Disabled = False
                    CASE ELSE
                        Control(InputBox(i).ID).Disabled = True
                END SELECT
            NEXT
        END IF

        IF TotalSelected > 1 THEN Control(NameTB).Disabled = True

        DIM LastTopForInputBox AS INTEGER
        LastTopForInputBox = -12
        CONST TopIncrementForInputBox = 22
        FOR i = 1 TO UBOUND(InputBox)
            IF Control(InputBox(i).ID).Disabled THEN
                Control(InputBox(i).ID).Hidden = True
                Control(InputBox(i).LabelID).Hidden = True
            ELSE
                LastTopForInputBox = LastTopForInputBox + TopIncrementForInputBox
                Control(InputBox(i).ID).Top = LastTopForInputBox
                Control(InputBox(i).LabelID).Top = LastTopForInputBox
            END IF
        NEXT

        IF HasFontList THEN
            Control(FontSizeList).Disabled = Control(FontList).Disabled
            Control(FontSizeList).Hidden = Control(FontList).Hidden
            Control(FontSizeList).Top = Control(FontList).Top
        END IF

        'Update the color mixer
        DIM ThisColor AS _UNSIGNED LONG, ThisBackColor AS _UNSIGNED LONG

        SELECT EVERYCASE Control(ColorPropertiesList).Value
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
                IF __UI_Focus <> Red AND __UI_Focus <> RedValue THEN
                    Control(Red).Value = _RED32(ThisColor)
                    Text(RedValue) = LTRIM$(STR$(Control(Red).Value))
                END IF
                IF __UI_Focus <> Green AND __UI_Focus <> GreenValue THEN
                    Control(Green).Value = _GREEN32(ThisColor)
                    Text(GreenValue) = LTRIM$(STR$(Control(Green).Value))
                END IF
                IF __UI_Focus <> Blue AND __UI_Focus <> BlueValue THEN
                    Control(Blue).Value = _BLUE32(ThisColor)
                    Text(BlueValue) = LTRIM$(STR$(Control(Blue).Value))
                END IF
            CASE 2, 4
                IF __UI_Focus <> Red AND __UI_Focus <> RedValue THEN
                    Control(Red).Value = _RED32(ThisBackColor)
                    Text(RedValue) = LTRIM$(STR$(Control(Red).Value))
                END IF
                IF __UI_Focus <> Green AND __UI_Focus <> GreenValue THEN
                    Control(Green).Value = _GREEN32(ThisBackColor)
                    Text(GreenValue) = LTRIM$(STR$(Control(Green).Value))
                END IF
                IF __UI_Focus <> Blue AND __UI_Focus <> BlueValue THEN
                    Control(Blue).Value = _BLUE32(ThisBackColor)
                    Text(BlueValue) = LTRIM$(STR$(Control(Blue).Value))
                END IF
        END SELECT

        IF Control(ColorPreview).HelperCanvas = 0 THEN
            Control(ColorPreview).HelperCanvas = _NEWIMAGE(Control(ColorPreview).Width, Control(ColorPreview).Height, 32)
        END IF

        STATIC PrevPreviewForeColor AS _UNSIGNED LONG, PrevPreviewBackColor AS _UNSIGNED LONG
        STATIC PrevColorPropertiesListValue AS _BYTE
        IF PrevPreviewForeColor <> ThisColor OR PrevPreviewBackColor <> ThisBackColor OR PrevColorPropertiesListValue <> Control(ColorPropertiesList).Value THEN
            PrevPreviewForeColor = ThisColor
            PrevPreviewBackColor = ThisBackColor
            PrevColorPropertiesListValue = Control(ColorPropertiesList).Value
            UpdateColorPreview Control(ColorPropertiesList).Value, ThisColor, ThisBackColor
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
    DIM value$

    IF _DIREXISTS("InForm") = 0 THEN EXIT SUB

    IF PreviewAttached THEN value$ = "True" ELSE value$ = "False"
    WriteSetting "InForm/InForm.ini", "InForm Settings", "Keep preview window attached", value$

    IF AutoNameControls THEN value$ = "True" ELSE value$ = "False"
    WriteSetting "InForm/InForm.ini", "InForm Settings", "Auto-name controls", value$

    IF __UI_SnapLines THEN value$ = "True" ELSE value$ = "False"
    WriteSetting "InForm/InForm.ini", "InForm Settings", "Snap to edges", value$

    IF __UI_ShowPositionAndSize THEN value$ = "True" ELSE value$ = "False"
    WriteSetting "InForm/InForm.ini", "InForm Settings", "Show position and size", value$

    IF CheckUpdates THEN value$ = "True" ELSE value$ = "False"
    WriteSetting "InForm/InForm.ini", "InForm Settings", "Check for updates", value$

    $IF WIN THEN
    $ELSE
        IF __UI_MouseButtonsSwap THEN value$ = "True" ELSE value$ = "False"
        WriteSetting "InForm/InForm.ini", "InForm Settings", "Swap mouse buttons", value$
    $END IF
END SUB

SUB __UI_BeforeInit
END SUB

SUB __UI_FormResized
END SUB

SUB __UI_OnLoad
    DIM i AS LONG, b$, UiEditorFile AS INTEGER
    DIM prevDest AS LONG

    b$ = "Starting..."
    GOSUB ShowMessage

    'Load splash image:
    DIM tempIcon AS LONG
    tempIcon = _LOADIMAGE("./InForm/resources/Application-icon-128.png", 32)

    GOSUB ShowMessage

    PreviewAttached = True
    AutoNameControls = True
    CheckUpdates = True
    __UI_ShowPositionAndSize = True
    __UI_SnapLines = True

    DIM FileToOpen$, FreeFileNum AS INTEGER

    b$ = "Reading settings..."
    GOSUB ShowMessage

    IF _DIREXISTS("InForm") = 0 THEN MKDIR "InForm"

    DIM value$
    value$ = ReadSetting("InForm/InForm.ini", "InForm Settings", "Keep preview window attached")
    IF LEN(value$) THEN
        PreviewAttached = (value$ = "True")
    ELSE
        WriteSetting "InForm/InForm.ini", "InForm Settings", "Keep preview window attached", "True"
        PreviewAttached = True
    END IF

    value$ = ReadSetting("InForm/InForm.ini", "InForm Settings", "Auto-name controls")
    IF LEN(value$) THEN
        AutoNameControls = (value$ = "True")
    ELSE
        WriteSetting "InForm/InForm.ini", "InForm Settings", "Auto-name controls", "True"
        AutoNameControls = True
    END IF

    value$ = ReadSetting("InForm/InForm.ini", "InForm Settings", "Snap to edges")
    IF LEN(value$) THEN
        __UI_SnapLines = (value$ = "True")
    ELSE
        WriteSetting "InForm/InForm.ini", "InForm Settings", "Snap to edges", "True"
        __UI_SnapLines = True
    END IF

    value$ = ReadSetting("InForm/InForm.ini", "InForm Settings", "Show position and size")
    IF LEN(value$) THEN
        __UI_ShowPositionAndSize = (value$ = "True")
    ELSE
        WriteSetting "InForm/InForm.ini", "InForm Settings", "Show position and size", "True"
        __UI_ShowPositionAndSize = True
    END IF

    value$ = ReadSetting("InForm/InForm.ini", "InForm Settings", "Check for updates")
    IF LEN(value$) THEN
        CheckUpdates = (value$ = "True")
    ELSE
        WriteSetting "InForm/InForm.ini", "InForm Settings", "Check for updates", "True"
        CheckUpdates = True
    END IF

    value$ = ReadSetting("InForm/InForm.ini", "InForm Settings", "Recompile updater")
    IF value$ = "True" THEN
        $IF WIN THEN
            SHELL _HIDE _DONTWAIT "qb64.exe -x InForm/updater/InFormUpdater.bas -o InForm/updater/InFormUpdater.exe"
        $ELSE
            SHELL _HIDE _DONTWAIT "./qb64 -x InForm/updater/InFormUpdater.bas -o InForm/updater/InFormUpdater"
        $END IF
        WriteSetting "InForm/InForm.ini", "InForm Settings", "Recompile updater", "False"
    END IF

    $IF WIN THEN
    $ELSE
        value$ = ReadSetting("InForm/InForm.ini", "InForm Settings", "Swap mouse buttons")
        __UI_MouseButtonsSwap = (value$ = "True")
        Control(OptionsMenuSwapButtons).Value = __UI_MouseButtonsSwap
    $END IF

    Control(ViewMenuPreviewDetach).Value = PreviewAttached
    Control(OptionsMenuAutoName).Value = AutoNameControls
    Control(OptionsMenuCheckUpdates).Value = CheckUpdates
    Control(OptionsMenuSnapLines).Value = __UI_SnapLines
    Control(ViewMenuShowPositionAndSize).Value = __UI_ShowPositionAndSize

    IF _FILEEXISTS("InForm/UiEditorPreview.frmbin") THEN KILL "InForm/UiEditorPreview.frmbin"
    IF _FILEEXISTS("InForm/UiEditorUndo.dat") THEN KILL "InForm/UiEditorUndo.dat"
    IF _FILEEXISTS("InForm/UiEditor.dat") THEN KILL "InForm/UiEditor.dat"

    b$ = "Parsing command line..."
    GOSUB ShowMessage

    IF _FILEEXISTS(COMMAND$) THEN
        SELECT CASE LCASE$(RIGHT$(COMMAND$, 4))
            CASE ".bas"
                'Does this .bas $include a .frm?
                FreeFileNum = FREEFILE
                DIM uB$
                OPEN COMMAND$ FOR BINARY AS #FreeFileNum
                DO
                    IF EOF(FreeFileNum) THEN EXIT DO
                    LINE INPUT #FreeFileNum, b$
                    b$ = LTRIM$(RTRIM$(b$))
                    uB$ = UCASE$(b$)
                    IF (LEFT$(b$, 1) = "'" OR LEFT$(uB$, 4) = "REM ") AND _
                    INSTR(uB$, "$INCLUDE") > 0 THEN
                        DIM FirstMark AS INTEGER, SecondMark AS INTEGER
                        FirstMark = INSTR(INSTR(uB$, "$INCLUDE") + 8, uB$, "'")
                        IF FirstMark > 0 THEN
                            SecondMark = INSTR(FirstMark + 1, uB$, "'")
                            IF SecondMark > 0 THEN
                                uB$ = MID$(uB$, FirstMark + 1, SecondMark - FirstMark - 1)
                                IF RIGHT$(uB$, 4) = ".FRM" THEN
                                    FileToOpen$ = MID$(b$, FirstMark + 1, SecondMark - FirstMark - 1)
                                    EXIT DO
                                END IF
                            END IF
                        END IF
                    END IF
                LOOP
                CLOSE #FreeFileNum
            CASE ELSE
                IF LCASE$(RIGHT$(COMMAND$, 7)) = ".frmbin" OR LCASE$(RIGHT$(COMMAND$, 4)) = ".frm" THEN
                    FileToOpen$ = COMMAND$
                END IF
        END SELECT

        IF LEN(FileToOpen$) > 0 THEN
            IF INSTR(FileToOpen$, "/") > 0 OR INSTR(FileToOpen$, "\") > 0 THEN
                FOR i = LEN(FileToOpen$) TO 1 STEP -1
                    IF ASC(FileToOpen$, i) = 92 OR ASC(FileToOpen$, i) = 47 THEN
                        CurrentPath$ = LEFT$(FileToOpen$, i - 1)
                        EXIT FOR
                    END IF
                NEXT
            END IF
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

    b$ = "Checking Preview component..."
    GOSUB ShowMessage

    $IF WIN THEN
        IF _FILEEXISTS("InForm/UiEditorPreview.exe") = 0 THEN
            IF _FILEEXISTS("InForm/UiEditorPreview.bas") = 0 THEN
                GOTO UiEditorPreviewNotFound
            ELSE
                b$ = "Compiling Preview component..."
                GOSUB ShowMessage
                SHELL _HIDE "qb64.exe -x .\InForm\UiEditorPreview.bas -o .\InForm\UiEditorPreview.exe"
                IF _FILEEXISTS("InForm/UiEditorPreview.exe") = 0 THEN GOTO UiEditorPreviewNotFound
            END IF
        END IF
        b$ = "Launching Preview component..."
        GOSUB ShowMessage
        SHELL _DONTWAIT ".\InForm\UiEditorPreview.exe"
    $ELSE
        IF _FILEEXISTS("InForm/UiEditorPreview") = 0 THEN
        IF _FILEEXISTS("./InForm/UiEditorPreview.bas") = 0 THEN
        GOTO UiEditorPreviewNotFound
        ELSE
        b$ = "Compiling Preview component..."
        GOSUB ShowMessage
        SHELL _HIDE "./qb64 -x ./InForm/UiEditorPreview.bas -o ./InForm/UiEditorPreview"
        IF _FILEEXISTS("InForm/UiEditorPreview") = 0 THEN GOTO UiEditorPreviewNotFound
        END IF
        END IF
        b$ = "Launching Preview component..."
        GOSUB ShowMessage
        SHELL _DONTWAIT "./InForm/UiEditorPreview"
    $END IF

    UiEditorFile = FREEFILE
    OPEN "InForm/UiEditor.dat" FOR BINARY AS #UiEditorFile
    b$ = MKL$(__UI_GetPID)
    PUT #UiEditorFile, OffsetEditorPID, b$
    CLOSE #UiEditorFile

    b$ = "Reading directory..."
    GOSUB ShowMessage

    'Fill "open dialog" listboxes:
    '-------------------------------------------------
    DIM TotalFiles%
    IF CurrentPath$ = "" THEN CurrentPath$ = _STARTDIR$
    Text(FileList) = idezfilelist$(CurrentPath$, 0, TotalFiles%)
    Control(FileList).Max = TotalFiles%
    Control(FileList).LastVisibleItem = 0 'Reset it so it's recalculated

    Text(DirList) = idezpathlist$(CurrentPath$, TotalFiles%)
    Control(DirList).Max = TotalFiles%
    Control(DirList).LastVisibleItem = 0 'Reset it so it's recalculated

    Caption(PathLB) = "Path: " + CurrentPath$
    '-------------------------------------------------

    $IF WIN THEN
        'Load font list
        b$ = "Loading font list..."
        GOSUB ShowMessage
        LoadFontList
    $END IF

    'Assign InputBox IDs:
    i = 0
    i = i + 1: InputBox(i).ID = NameTB: InputBox(i).LabelID = NameLB: InputBox(i).Signal = 1
    i = i + 1: InputBox(i).ID = CaptionTB: InputBox(i).LabelID = CaptionLB: InputBox(i).Signal = 2
    i = i + 1: InputBox(i).ID = TextTB: InputBox(i).LabelID = TextLB: InputBox(i).Signal = 3
    i = i + 1: InputBox(i).ID = MaskTB: InputBox(i).LabelID = MaskLB: InputBox(i).Signal = 35
    i = i + 1: InputBox(i).ID = TopTB: InputBox(i).LabelID = TopLB: InputBox(i).Signal = 4
    i = i + 1: InputBox(i).ID = LeftTB: InputBox(i).LabelID = LeftLB: InputBox(i).Signal = 5
    i = i + 1: InputBox(i).ID = WidthTB: InputBox(i).LabelID = WidthLB: InputBox(i).Signal = 6
    i = i + 1: InputBox(i).ID = HeightTB: InputBox(i).LabelID = HeightLB: InputBox(i).Signal = 7
    IF HasFontList THEN
        i = i + 1: InputBox(i).ID = FontList: InputBox(i).LabelID = FontListLB: InputBox(i).Signal = 8
        Control(FontTB).Hidden = True
        Control(FontLB).Hidden = True
    ELSE
        i = i + 1: InputBox(i).ID = FontTB: InputBox(i).LabelID = FontLB: InputBox(i).Signal = 8
    END IF
    i = i + 1: InputBox(i).ID = TooltipTB: InputBox(i).LabelID = TooltipLB: InputBox(i).Signal = 9
    i = i + 1: InputBox(i).ID = ValueTB: InputBox(i).LabelID = ValueLB: InputBox(i).Signal = 10
    i = i + 1: InputBox(i).ID = BooleanOptions: InputBox(i).LabelID = BooleanLB: InputBox(i).Signal = 10
    i = i + 1: InputBox(i).ID = MinTB: InputBox(i).LabelID = MinLB: InputBox(i).Signal = 11
    i = i + 1: InputBox(i).ID = MaxTB: InputBox(i).LabelID = MaxLB: InputBox(i).Signal = 12
    i = i + 1: InputBox(i).ID = IntervalTB: InputBox(i).LabelID = IntervalLB: InputBox(i).Signal = 13
    i = i + 1: InputBox(i).ID = MinIntervalTB: InputBox(i).LabelID = MinIntervalLB: InputBox(i).Signal = 36
    i = i + 1: InputBox(i).ID = PaddingTB: InputBox(i).LabelID = PaddingLeftrightLB: InputBox(i).Signal = 31
    i = i + 1: InputBox(i).ID = AlignOptions: InputBox(i).LabelID = TextAlignLB
    i = i + 1: InputBox(i).ID = VAlignOptions: InputBox(i).LabelID = VerticalAlignLB
    i = i + 1: InputBox(i).ID = BulletOptions: InputBox(i).LabelID = BulletOptionsLB
    REDIM _PRESERVE InputBox(1 TO i) AS newInputBox
    REDIM InputBoxText(1 TO i) AS STRING

    ToolTip(FontTB) = "Multiple fonts can be specified by separating them with a question mark (?)." + CHR$(10) + "The first font that can be found/loaded is used."
    ToolTip(ColorPreview) = "Click to copy the current color's hex value to the clipboard."

    StatusBarBackColor = Darken(__UI_DefaultColor(__UI_Type_Form, 2), 90)
    Control(StatusBar).BackColor = StatusBarBackColor

    b$ = "Loading images..."
    GOSUB ShowMessage

    'Load toolbox images:
    DIM CommControls AS LONG
    CommControls = LoadEditorImage("commoncontrols.bmp")
    __UI_ClearColor CommControls, 0, 0

    i = 0
    Control(AddButton).HelperCanvas = _NEWIMAGE(16, 16, 32)
    i = i + 1: _PUTIMAGE (0, 0), CommControls, Control(AddButton).HelperCanvas, (0, i * 16 - 16)-STEP(15, 15)
    Control(AddLabel).HelperCanvas = _NEWIMAGE(16, 16, 32)
    i = i + 1: _PUTIMAGE (0, 0), CommControls, Control(AddLabel).HelperCanvas, (0, i * 16 - 16)-STEP(15, 15)
    Control(AddTextBox).HelperCanvas = _NEWIMAGE(16, 16, 32)
    i = i + 1: _PUTIMAGE (0, 0), CommControls, Control(AddTextBox).HelperCanvas, (0, i * 16 - 16)-STEP(15, 15)
    Control(AddCheckBox).HelperCanvas = _NEWIMAGE(16, 16, 32)
    i = i + 1: _PUTIMAGE (0, 0), CommControls, Control(AddCheckBox).HelperCanvas, (0, i * 16 - 16)-STEP(15, 15)
    Control(AddRadioButton).HelperCanvas = _NEWIMAGE(16, 16, 32)
    i = i + 1: _PUTIMAGE (0, 0), CommControls, Control(AddRadioButton).HelperCanvas, (0, i * 16 - 16)-STEP(15, 15)
    Control(AddListBox).HelperCanvas = _NEWIMAGE(16, 16, 32)
    i = i + 1: _PUTIMAGE (0, 0), CommControls, Control(AddListBox).HelperCanvas, (0, i * 16 - 16)-STEP(15, 15)
    Control(AddDropdownList).HelperCanvas = _NEWIMAGE(16, 16, 32)
    i = i + 1: _PUTIMAGE (0, 0), CommControls, Control(AddDropdownList).HelperCanvas, (0, i * 16 - 16)-STEP(15, 15)
    Control(AddTrackBar).HelperCanvas = _NEWIMAGE(16, 16, 32)
    i = i + 1: _PUTIMAGE (0, 0), CommControls, Control(AddTrackBar).HelperCanvas, (0, i * 16 - 16)-STEP(15, 15)
    Control(AddProgressBar).HelperCanvas = _NEWIMAGE(16, 16, 32)
    i = i + 1: _PUTIMAGE (0, 0), CommControls, Control(AddProgressBar).HelperCanvas, (0, i * 16 - 16)-STEP(15, 15)
    Control(AddPictureBox).HelperCanvas = _NEWIMAGE(16, 16, 32)
    i = i + 1: _PUTIMAGE (0, 0), CommControls, Control(AddPictureBox).HelperCanvas, (0, i * 16 - 16)-STEP(15, 15)
    Control(AddFrame).HelperCanvas = _NEWIMAGE(16, 16, 32)
    i = i + 1: _PUTIMAGE (0, 0), CommControls, Control(AddFrame).HelperCanvas, (0, i * 16 - 16)-STEP(15, 15)

    'Draw ToggleSwitch icon
    prevDest = _DEST
    Control(AddToggleSwitch).HelperCanvas = _NEWIMAGE(16, 16, 32)
    _DEST Control(AddToggleSwitch).HelperCanvas
    LINE (2, 4)-(13, 11), _RGB32(0, 128, 255), BF
    LINE (2, 4)-(13, 11), _RGB32(170, 170, 170), B
    LINE (8, 6)-(11, 9), _RGB32(255, 255, 255), BF

    'Draw AddNumericBox icon
    Control(AddNumericBox).HelperCanvas = _NEWIMAGE(16, 16, 32)
    _DEST Control(AddNumericBox).HelperCanvas
    _FONT 8
    LINE (1, 3)-(15, 13), _RGB32(255, 255, 255), BF
    LINE (1, 3)-(15, 13), _RGB32(132, 165, 189), B
    COLOR _RGB32(55, 55, 55), _RGBA32(0, 0, 0, 0)
    __UI_PrintString 5, 3, "#"

    'Import Align menu icons from InForm.ui
    Control(AlignMenuAlignLeft).HelperCanvas = Control(__UI_GetID("__UI_PreviewMenuAlignLeft")).HelperCanvas
    Control(AlignMenuAlignRight).HelperCanvas = Control(__UI_GetID("__UI_PreviewMenuAlignRight")).HelperCanvas
    Control(AlignMenuAlignTops).HelperCanvas = Control(__UI_GetID("__UI_PreviewMenuAlignTops")).HelperCanvas
    Control(AlignMenuAlignBottoms).HelperCanvas = Control(__UI_GetID("__UI_PreviewMenuAlignBottoms")).HelperCanvas
    Control(AlignMenuAlignCentersV).HelperCanvas = Control(__UI_GetID("__UI_PreviewMenuAlignCentersV")).HelperCanvas
    Control(AlignMenuAlignCentersH).HelperCanvas = Control(__UI_GetID("__UI_PreviewMenuAlignCentersH")).HelperCanvas

    _DEST prevDest

    Control(FileMenuSave).HelperCanvas = LoadEditorImage("disk.png")

    _FREEIMAGE CommControls

    b$ = "InForm Designer"
    GOSUB ShowMessage

    __UI_RefreshMenuBar
    __UI_ForceRedraw = True
    _FREEIMAGE tempIcon

    TIMER(CheckPreviewTimer) ON

    EXIT SUB
    UiEditorPreviewNotFound:
    i = MessageBox("UiEditorPreview component not found or failed to load.", "UiEditor", MsgBox_OkOnly + MsgBox_Critical)
    SYSTEM

    ShowMessage:
    DIM PreserveDestMessage AS LONG
    PreserveDestMessage = _DEST
    _DEST 0
    _FONT Control(__UI_FormID).Font
    IF tempIcon < -1 THEN
        CLS , _RGB32(255, 255, 255)
        _PUTIMAGE (_WIDTH / 2 - _WIDTH(tempIcon) / 2, _HEIGHT / 2 - _HEIGHT(tempIcon) / 2), tempIcon
        COLOR __UI_DefaultColor(__UI_Type_Form, 1), _RGBA32(0, 0, 0, 0)
        __UI_PrintString _WIDTH \ 2 - _PRINTWIDTH(b$) \ 2, _HEIGHT / 2 + _HEIGHT(tempIcon) / 2 + _FONTHEIGHT, b$
        _DISPLAY
    ELSE
        CLS , __UI_DefaultColor(__UI_Type_Form, 2)
        COLOR __UI_DefaultColor(__UI_Type_Form, 1), _RGBA32(0, 0, 0, 0)
        __UI_PrintString _WIDTH \ 2 - _PRINTWIDTH(b$) \ 2, _HEIGHT \ 2 - _FONTHEIGHT \ 2, b$
    END IF
    _DISPLAY
    _DEST PreserveDestMessage
    RETURN
END SUB

SUB __UI_KeyPress (id AS LONG)
    LastKeyPress = TIMER
    SELECT EVERYCASE id
        CASE RedValue, GreenValue, BlueValue
            DIM TempID AS LONG
            IF __UI_KeyHit = 18432 THEN
                IF VAL(Text(id)) < 255 THEN
                    Text(id) = LTRIM$(STR$(VAL(Text(id)) + 1))
                END IF
                SelectPropertyFully id
                TempID = __UI_GetID(LEFT$(UCASE$(RTRIM$(Control(id).Name)), LEN(UCASE$(RTRIM$(Control(id).Name))) - 5))
                Control(TempID).Value = VAL(Text(id))
                SendNewRGB
            ELSEIF __UI_KeyHit = 20480 THEN
                IF VAL(Text(id)) > 0 THEN
                    Text(id) = LTRIM$(STR$(VAL(Text(id)) - 1))
                END IF
                SelectPropertyFully id
                TempID = __UI_GetID(LEFT$(UCASE$(RTRIM$(Control(id).Name)), LEN(UCASE$(RTRIM$(Control(id).Name))) - 5))
                Control(TempID).Value = VAL(Text(id))
                SendNewRGB
            ELSEIF __UI_KeyHit = 13 THEN
                TempID = __UI_GetID(LEFT$(UCASE$(RTRIM$(Control(id).Name)), LEN(UCASE$(RTRIM$(Control(id).Name))) - 5))
                Control(TempID).Value = VAL(Text(id))
                SendNewRGB
                SelectPropertyFully id
            END IF
            Caption(StatusBar) = "Color changed."
        CASE FileNameTextBox
            IF OpenDialogOpen THEN
                IF __UI_KeyHit = 27 THEN
                    __UI_KeyHit = 0
                    __UI_Click CancelBT
                ELSEIF __UI_KeyHit = 13 THEN
                    __UI_KeyHit = 0
                    __UI_Click OpenBT
                ELSEIF __UI_KeyHit = 18432 OR __UI_KeyHit = 20480 THEN
                    IF Control(FileList).Max > 0 THEN __UI_Focus = FileList
                ELSE
                    IF Control(FileList).Max > 0 THEN
                        SELECT CASE __UI_KeyHit
                            CASE 48 TO 57, 65 TO 90, 97 TO 122 'Alphanumeric
                                __UI_ListBoxSearchItem Control(FileList)
                        END SELECT
                    END IF
                END IF
            END IF
        CASE FileList, DirList, CancelBT, OpenBT, ShowOnlyFrmbinFilesCB
            IF __UI_KeyHit = 27 THEN
                __UI_Click CancelBT
            END IF
        CASE FileList
            IF __UI_KeyHit = 13 THEN
                __UI_KeyHit = 0
                __UI_Click OpenBT
            END IF
        CASE ControlList, UpBT, DownBT, CloseZOrderingBT
            IF __UI_KeyHit = 27 THEN
                __UI_Click CloseZOrderingBT
            END IF
        CASE NameTB, CaptionTB, TextTB, MaskTB, TopTB, LeftTB, WidthTB, HeightTB, FontTB, TooltipTB, ValueTB, MinTB, MaxTB, IntervalTB, PaddingTB, MinIntervalTB
            IF __UI_KeyHit = 13 THEN
                IF __UI_Focus = id THEN
                    'Send the preview the new property value
                    DIM FloatValue AS _FLOAT, b$, TempValue AS LONG, i AS LONG
                    STATIC PreviousValue$, PreviousControl AS LONG, PreviousProperty AS INTEGER

                    IF PreviousValue$ <> Text(id) OR PreviousControl <> FirstSelected OR PreviousProperty <> id THEN
                        PreviousValue$ = Text(id)
                        PreviousControl = FirstSelected
                        PreviousProperty = id
                        TempValue = GetPropertySignal(id)
                        SELECT CASE TempValue
                            CASE 1, 2, 3, 8, 9, 35 'Name, caption, text, font, tooltips, mask
                                b$ = MKL$(LEN(Text(id))) + Text(id)
                            CASE 4, 5, 6, 7, 31 'Top, left, width, height, padding
                                b$ = MKI$(VAL(Text(id)))
                            CASE 10, 11, 12, 13, 36 'Value, min, max, interval, mininterval
                                b$ = _MK$(_FLOAT, VAL(Text(id)))
                        END SELECT
                        SendData b$, TempValue
                        SelectPropertyFully id
                        InputBoxText(GetInputBoxFromID(id)) = Text(id)
                        InputBox(GetInputBoxFromID(id)).LastEdited = TIMER
                        InputBox(GetInputBoxFromID(id)).Sent = True
                        Caption(StatusBar) = "Ready."
                    END IF
                END IF
                Edited = True
            ELSEIF __UI_KeyHit = 32 THEN
                IF id = NameTB THEN
                    __UI_KeyHit = 0
                    Caption(StatusBar) = "Control names cannot contain spaces"
                ELSE
                    InputBox(GetInputBoxFromID(id)).Sent = False
                END IF
            ELSEIF __UI_KeyHit = 27 THEN
                RevertEdit = True
                Caption(StatusBar) = "Previous property value restored."
            ELSE
                InputBox(GetInputBoxFromID(id)).Sent = False
            END IF
        CASE AlignOptions
            Edited = True
        CASE VAlignOptions
            Edited = True
    END SELECT
END SUB

FUNCTION GetPropertySignal& (id AS LONG)
    DIM i AS LONG
    FOR i = 1 TO UBOUND(InputBox)
        IF InputBox(i).ID = id THEN GetPropertySignal& = InputBox(i).Signal: EXIT FUNCTION
    NEXT
END FUNCTION

FUNCTION GetInputBoxFromID& (id AS LONG)
    DIM i AS LONG
    FOR i = 1 TO UBOUND(InputBox)
        IF InputBox(i).ID = id THEN GetInputBoxFromID& = i: EXIT FUNCTION
    NEXT
END FUNCTION

SUB __UI_TextChanged (id AS LONG)
    SELECT CASE id
        CASE RedValue, GreenValue, BlueValue
            DIM TempID AS LONG
            TempID = __UI_GetID(LEFT$(UCASE$(RTRIM$(Control(id).Name)), LEN(UCASE$(RTRIM$(Control(id).Name))) - 5))
            Control(TempID).Value = VAL(Text(id))
        CASE FileNameTextBox
            PreselectFile
    END SELECT
END SUB

SUB __UI_ValueChanged (id AS LONG)
    DIM b$
    SELECT EVERYCASE id
        CASE AlignOptions
            IF __UI_Focus <> id THEN EXIT SUB
            b$ = MKI$(Control(AlignOptions).Value - 1)
            SendData b$, 22
        CASE VAlignOptions
            IF __UI_Focus <> id THEN EXIT SUB
            b$ = MKI$(Control(VAlignOptions).Value - 1)
            SendData b$, 32
        CASE BulletOptions
            IF __UI_Focus <> id THEN EXIT SUB
            b$ = MKI$(Control(BulletOptions).Value - 1)
            SendData b$, 37
        CASE BooleanOptions
            b$ = _MK$(_FLOAT, -(Control(BooleanOptions).Value - 1))
            SendData b$, GetPropertySignal(BooleanOptions)
        CASE FontList, FontSizeList
            b$ = FontFile(Control(FontList).Value) + "," + LTRIM$(STR$(Control(FontSizeList).Value + 7))
            b$ = MKL$(LEN(b$)) + b$
            SendData b$, 8
        CASE Red
            Text(RedValue) = LTRIM$(STR$(Control(Red).Value))
        CASE Green
            Text(GreenValue) = LTRIM$(STR$(Control(Green).Value))
        CASE Blue
            Text(BlueValue) = LTRIM$(STR$(Control(Blue).Value))
        CASE Red, Green, Blue
            'Compose a new color and preview it
            DIM NewColor AS _UNSIGNED LONG
            NewColor = _RGB32(Control(Red).Value, Control(Green).Value, Control(Blue).Value)
            IF __UI_MouseDownOnID = id THEN QuickColorPreview NewColor
        CASE ControlList
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
        CASE FileList
            Text(FileNameTextBox) = GetItem(FileList, Control(FileList).Value)
    END SELECT
END SUB

SUB PreselectFile
    DIM b$
    b$ = GetItem(FileList, Control(FileList).Value)
    IF LCASE$(Text(FileNameTextBox)) = LCASE$(LEFT$(b$, LEN(Text(FileNameTextBox)))) THEN
        Text(FileNameTextBox) = Text(FileNameTextBox) + MID$(b$, LEN(Text(FileNameTextBox)) + 1)
        Control(FileNameTextBox).TextIsSelected = True
        Control(FileNameTextBox).SelectionStart = LEN(Text(FileNameTextBox))
    END IF
END SUB

FUNCTION EditorImageData$ (FileName$)
    DIM A$

    SELECT CASE LCASE$(FileName$)
        CASE "disk.png"
            A$ = MKI$(16) + MKI$(16)
            A$ = A$ + "0000005D@1AA15TB=MdA[`hQ7>c[ZZj<7:HOcPgL^=COc=g<0FGMbd7Nc=cH"
            A$ = A$ + "NiE<:A4A]<eC<eDEBmdE9UDB>0000`0GHIUb854?oWiUFj_iUCno4;\`o;Nh"
            A$ = A$ + "QoOjXSnoXO^ioKNiUo_k]cnoHFIUo7S8Rl?IOaeoQeEFoc3>hLCD:YdCJM5E"
            A$ = A$ + "o33:SPOUC>io5C<an3000hoa7O\oMgMgnS=fHk?fGO]oNk]gn[HR9j?000Po"
            A$ = A$ + "Bi4CkcDB6m?<`\B=7AD@;iTB8m_<\P2om]WNoOZYVn_59T`oYR:ZoSk]gnO]"
            A$ = A$ + "c>kod>k\o[K^in?Mb9go9000n[dA5eoA35do`\b:e04?i`TA35doR\16lcWN"
            A$ = A$ + "jmOYUFjo0000oOZYVn?^gNkod>k\oCk\cn_^iVkob5GLo3000lo@odCoo\S>"
            A$ = A$ + "o_R9VDS=b83Cn\C>oga5D`oK]efoXNjYog7Olm_ZYVjoanj[ooZ[^n_[]fjo"
            A$ = A$ + "b6K\o[FJYm?000`ojLS=mK3=bl_9R8B=bl2;<=3<_lO<^d2o^\R:oODA4m_G"
            A$ = A$ + "L]eoFAeDo;5D@moDA5eoB15Do3UC=m??jTcoahB;o7S;]h?<]`boR8R8el2;"
            A$ = A$ + "\`D<]dbo^\b:l[3>glo>iPcof@c<o_C>gl??jTcolT3>ocS>ilO?jTcood3?"
            A$ = A$ + "oK3=clO;ZTRo^\R:o;R8RD3?iT3C0000o7GK]aOe?kloEk\coG]c>oOe?klo"
            A$ = A$ + "Eo\coGmc>oOe?kloEkLcoSMdAo_aonkojPc=nOb8Rlo:[\B=314?<1000l?Q"
            A$ = A$ + "028oY;^ho?>gLo?iMgmoTgMgoCNgMo?iMgmoTgMgo?NgLo_iOomoKG=eoKd@"
            A$ = A$ + "3eO7JTao`\b:e04?l`4000`o2fGOlSNhQo_hL_moSg=go?NgMoohMcmoSgMg"
            A$ = A$ + "o?NgMo_hLcmoUomgoWmdCo_@01ToJHQ5o_b:[D3@l`3C0000o?8P0b_jUCno"
            A$ = A$ + "To]goG>hOoOiPomoU3ngoG>hOoOiPomoUomgoS^hRo?gGKmo35d?mGA4@lo:"
            A$ = A$ + "[\B=o`3?=1000lOQ2:8o]S>joO^hQo?jS;noX?^hoSnhRo?jS;noX?^hoO^h"
            A$ = A$ + "Ro_jUGnoO_]fn;4@0mO4<``o\`2;d\c>kT40000h5:XPhc>jWg?jT?>oYG>i"
            A$ = A$ + "lWNiTc?jT?NoXCnhmWNiTc?jT?>o[O^ilgMfHo?A294l3000Kg2:XTc9T@2E"
            A$ = A$ + "0000OcUFImoS;^ho:NhQo_8R8noR8Rho;R8Ro_8R8noR8Rho;R8Ro_8R8n_R"
            A$ = A$ + "7NholXC>iW@14X=9P02@<`03FLa5Gh4000`?000001000040000@00000100"
            A$ = A$ + "0040000@000001000040000@0000o@000<D5B81B0000%%70"
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
        REDIM PreviewMasks(1 TO CVL(b$)) AS STRING
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
                    CASE -35
                        PreviewDefaultButtonID = Dummy
                    CASE -36 'Mask
                        b$ = SPACE$(4): GET #BinaryFileNum, , b$
                        b$ = SPACE$(CVL(b$))
                        GET #BinaryFileNum, , b$
                        PreviewMasks(Dummy) = b$
                    CASE -37
                        b$ = SPACE$(LEN(FloatValue)): GET #BinaryFileNum, , b$
                        PreviewControls(Dummy).MinInterval = _CV(_FLOAT, b$)
                    CASE -38
                        PreviewControls(Dummy).NumericOnly = True
                    CASE -39
                        PreviewControls(Dummy).NumericOnly = __UI_NumericWithBounds
                    CASE -40
                        b$ = SPACE$(2)
                        GET #BinaryFileNum, , b$
                        PreviewControls(Dummy).BulletStyle = CVI(b$)
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
    IF PreviewSelectionRectangle THEN EXIT SUB

    FileNum = FREEFILE
    OPEN "InForm/UiEditor.dat" FOR BINARY AS #FileNum

    'Send the data first, then the signal
    PUT #FileNum, OffsetPropertyValue, b$
    b$ = MKI$(Property): PUT #FileNum, OffsetPropertyChanged, b$
    b$ = MKI$(-1): PUT #FileNum, OffsetNewDataFromEditor, b$
    CLOSE #FileNum
END SUB

SUB SendSignal (Value AS INTEGER)
    DIM FileNum AS INTEGER, b$
    FileNum = FREEFILE
    OPEN "InForm/UiEditor.dat" FOR BINARY AS #FileNum

    b$ = MKI$(Value): PUT #FileNum, OffsetNewDataFromEditor, b$
    CLOSE #FileNum
END SUB

SUB UpdateColorPreview (Attribute AS _BYTE, ForeColor AS _UNSIGNED LONG, BackColor AS _UNSIGNED LONG)
    _DEST Control(ColorPreview).HelperCanvas
    _FONT Control(ColorPreview).Font
    IF Attribute = 5 THEN
        CLS , BackColor
        LINE (20, 20)-STEP(_WIDTH - 41, _HEIGHT - 41), ForeColor, B
        LINE (21, 21)-STEP(_WIDTH - 43, _HEIGHT - 43), ForeColor, B
        ColorPreviewWord$ = "#" + MID$(HEX$(ForeColor), 3)
        COLOR ForeColor, BackColor
        __UI_PrintString _WIDTH \ 2 - _PRINTWIDTH(ColorPreviewWord$) \ 2, _HEIGHT \ 2 - _FONTHEIGHT \ 2, ColorPreviewWord$
    ELSE
        CLS , BackColor
        COLOR ForeColor, BackColor
        SELECT CASE Attribute
            CASE 1, 3
                ColorPreviewWord$ = "FG: #" + MID$(HEX$(ForeColor), 3)
            CASE 2, 4
                ColorPreviewWord$ = "BG: #" + MID$(HEX$(BackColor), 3)
        END SELECT
        __UI_PrintString _WIDTH \ 2 - _PRINTWIDTH(ColorPreviewWord$) \ 2, _HEIGHT \ 2 - _FONTHEIGHT \ 2, ColorPreviewWord$
        ColorPreviewWord$ = MID$(ColorPreviewWord$, 5)
    END IF
    _DEST 0
    Control(ColorPreview).Redraw = True 'Force update
END SUB

SUB QuickColorPreview (ThisColor AS _UNSIGNED LONG)
    _DEST Control(ColorPreview).HelperCanvas
    CLS , __UI_DefaultColor(__UI_Type_Form, 2)
    LINE (0, 0)-STEP(_WIDTH, _HEIGHT / 2), ThisColor, BF
    LINE (0, _HEIGHT / 2)-STEP(_WIDTH, _HEIGHT / 2), OldColor, BF
    _DEST 0
    Control(ColorPreview).Redraw = True 'Force update
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
                Control(ViewMenuPreview).Disabled = True
            ELSE
                'Preview was closed.
                TIMER(__UI_EventsTimer) OFF
                Control(ViewMenuPreview).Disabled = False
                __UI_WaitMessage = "Reloading preview window..."
                OPEN "InForm/UiEditor.dat" FOR BINARY AS #UiEditorFile
                b$ = MKL$(0): PUT #UiEditorFile, OffsetPreviewPID, b$
                CLOSE #UiEditorFile
                UiPreviewPID = 0
                SHELL _DONTWAIT ".\InForm\UiEditorPreview.exe"
                __UI_ProcessInputTimer = 0 'Make the "Please wait" message show up immediataly
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
        Control(ViewMenuPreview).Disabled = False
        __UI_WaitMessage = "Reloading preview window..."
        OPEN "InForm/UiEditor.dat" FOR BINARY AS #UiEditorFile
        b$ = MKL$(0): PUT #UiEditorFile, OffsetPreviewPID, b$
        CLOSE #UiEditorFile
        UiPreviewPID = 0
        SHELL _DONTWAIT "./InForm/UiEditorPreview"
        __UI_ProcessInputTimer = 0 'Make the "Please wait" message show up immediataly
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
        Control(ViewMenuPreview).Disabled = True
        END IF
        END IF
    $END IF
END SUB

SUB SaveForm (ExitToQB64 AS _BYTE, SaveOnlyFrm AS _BYTE)
    DIM BaseOutputFileName AS STRING
    DIM TextFileNum AS INTEGER, Answer AS _BYTE, b$, i AS LONG
    DIM a$, FontSetup$, FindSep AS INTEGER, NewFontFile AS STRING
    DIM NewFontSize AS INTEGER, Dummy AS LONG, BackupFile$
    DIM PreserveBackup AS _BYTE, BackupCode$

    BaseOutputFileName = CurrentPath$ + PathSep$ + RTRIM$(PreviewControls(PreviewFormID).Name)
    IF _FILEEXISTS(BaseOutputFileName + ".bas") OR _FILEEXISTS(BaseOutputFileName + ".frm") THEN
        Answer = MessageBox("Some files will be overwritten. Proceed?", "", MsgBox_YesNo + MsgBox_Question)
        IF Answer = MsgBox_No THEN EXIT SUB
    END IF

    'Backup existing files
    FOR i = 1 TO 2
        IF i = 1 THEN
            IF SaveOnlyFrm THEN
                _CONTINUE
            ELSE
                BackupFile$ = BaseOutputFileName + ".bas"
            END IF
        END IF
        IF i = 2 THEN BackupFile$ = BaseOutputFileName + ".frm"

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

            IF i = 1 THEN
                IF INSTR(b$, "': External modules: ---------------------------------------------------------------") > 0 THEN
                    BackupCode$ = MID$(b$, INSTR(b$, "': External modules: ---------------------------------------------------------------"))
                    PreserveBackup = True
                END IF
            END IF
        END IF
    NEXT

    TextFileNum = FREEFILE
    OPEN BaseOutputFileName + ".frm" FOR OUTPUT AS #TextFileNum
    PRINT #TextFileNum, "': This form was generated by"
    PRINT #TextFileNum, "': InForm - GUI library for QB64 - "; __UI_Version
    PRINT #TextFileNum, "': Fellippe Heitor, 2016-2018 - fellippe@qb64.org - @fellippeheitor"
    PRINT #TextFileNum, "': https://github.com/FellippeHeitor/InForm"
    PRINT #TextFileNum, "'-----------------------------------------------------------"
    PRINT #TextFileNum, "SUB __UI_LoadForm"
    PRINT #TextFileNum,
    IF LEN(PreviewTexts(PreviewFormID)) > 0 THEN
        PRINT #TextFileNum, "    $EXEICON:'" + PreviewTexts(PreviewFormID) + "'"
    END IF
    IF PreviewControls(PreviewFormID).CanResize THEN
        PRINT #TextFileNum, "    $RESIZE:ON"
    END IF
    PRINT #TextFileNum, "    DIM __UI_NewID AS LONG"
    PRINT #TextFileNum,

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
                    CASE __UI_Type_ToggleSwitch: a$ = a$ + "__UI_Type_ToggleSwitch, ": IF ThisPass = 1 THEN GOTO EndOfThisPass
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

                IF PreviewDefaultButtonID = i THEN
                    PRINT #TextFileNum, "    __UI_DefaultButtonID = __UI_NewID"
                END IF

                IF LEN(PreviewCaptions(i)) > 0 THEN
                    'IF PreviewControls(i).HotKeyPosition > 0 THEN
                    '    a$ = LEFT$(PreviewCaptions(i), PreviewControls(i).HotKeyPosition - 1) + "&" + MID$(PreviewCaptions(i), PreviewControls(i).HotKeyPosition)
                    'ELSE
                    '    a$ = PreviewCaptions(i)
                    'END IF
                    a$ = "    SetCaption __UI_NewID, " + __UI_SpecialCharsToCHR$(PreviewCaptions(i))
                    PRINT #TextFileNum, a$
                END IF

                IF LEN(PreviewTips(i)) > 0 THEN
                    a$ = "    ToolTip(__UI_NewID) = " + __UI_SpecialCharsToCHR$(PreviewTips(i))
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
                        CASE __UI_Type_PictureBox, __UI_Type_Button, __UI_Type_MenuItem
                            a$ = "    LoadImage Control(__UI_NewID), " + CHR$(34) + PreviewTexts(i) + CHR$(34)
                            PRINT #TextFileNum, a$
                        CASE ELSE
                            a$ = "    Text(__UI_NewID) = " + __UI_SpecialCharsToCHR$(PreviewTexts(i))
                            PRINT #TextFileNum, a$
                    END SELECT
                END IF
                IF LEN(PreviewMasks(i)) > 0 THEN
                    a$ = "    Mask(__UI_NewID) = " + __UI_SpecialCharsToCHR$(PreviewMasks(i))
                    PRINT #TextFileNum, a$
                END IF
                IF PreviewControls(i).TransparentColor > 0 THEN
                    PRINT #TextFileNum, "    __UI_ClearColor Control(__UI_NewID).HelperCanvas, " + LTRIM$(STR$(PreviewControls(i).TransparentColor)) + ", -1"
                END IF
                IF PreviewControls(i).Stretch = True THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).Stretch = True"
                ELSE
                    PRINT #TextFileNum, "    Control(__UI_NewID).Stretch = False"
                END IF
                'Fonts
                IF LEN(PreviewFonts(i)) > 0 THEN
                    FontSetup$ = PreviewFonts(i)

                    'Parse FontSetup$ into Font variables
                    FindSep = INSTR(FontSetup$, ",")
                    NewFontFile = LEFT$(FontSetup$, FindSep - 1)
                    FontSetup$ = MID$(FontSetup$, FindSep + 1)

                    FontSetup$ = "SetFont(" + CHR$(34) + NewFontFile + CHR$(34) + ", " + FontSetup$ + ")"
                    PRINT #TextFileNum, "    Control(__UI_NewID).Font = " + FontSetup$
                END IF
                'Colors are saved only if they differ from the theme's defaults
                IF PreviewControls(i).ForeColor > 0 AND PreviewControls(i).ForeColor <> __UI_DefaultColor(PreviewControls(i).Type, 1) THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).ForeColor = _RGB32(" + LTRIM$(STR$(_RED32(PreviewControls(i).ForeColor))) + ", " + LTRIM$(STR$(_GREEN32(PreviewControls(i).ForeColor))) + ", " + LTRIM$(STR$(_BLUE32(PreviewControls(i).ForeColor))) + ")"
                END IF
                IF PreviewControls(i).BackColor > 0 AND PreviewControls(i).BackColor <> __UI_DefaultColor(PreviewControls(i).Type, 2) THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).BackColor = _RGB32(" + LTRIM$(STR$(_RED32(PreviewControls(i).BackColor))) + ", " + LTRIM$(STR$(_GREEN32(PreviewControls(i).BackColor))) + ", " + LTRIM$(STR$(_BLUE32(PreviewControls(i).BackColor))) + ")"
                END IF
                IF PreviewControls(i).SelectedForeColor > 0 AND PreviewControls(i).SelectedForeColor <> __UI_DefaultColor(PreviewControls(i).Type, 3) THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).SelectedForeColor = _RGB32(" + LTRIM$(STR$(_RED32(PreviewControls(i).SelectedForeColor))) + ", " + LTRIM$(STR$(_GREEN32(PreviewControls(i).SelectedForeColor))) + ", " + LTRIM$(STR$(_BLUE32(PreviewControls(i).SelectedForeColor))) + ")"
                END IF
                IF PreviewControls(i).SelectedBackColor > 0 AND PreviewControls(i).SelectedBackColor <> __UI_DefaultColor(PreviewControls(i).Type, 4) THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).SelectedBackColor = _RGB32(" + LTRIM$(STR$(_RED32(PreviewControls(i).SelectedBackColor))) + ", " + LTRIM$(STR$(_GREEN32(PreviewControls(i).SelectedBackColor))) + ", " + LTRIM$(STR$(_BLUE32(PreviewControls(i).SelectedBackColor))) + ")"
                END IF
                IF PreviewControls(i).BorderColor > 0 AND PreviewControls(i).BorderColor <> __UI_DefaultColor(PreviewControls(i).Type, 5) THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).BorderColor = _RGB32(" + LTRIM$(STR$(_RED32(PreviewControls(i).BorderColor))) + ", " + LTRIM$(STR$(_GREEN32(PreviewControls(i).BorderColor))) + ", " + LTRIM$(STR$(_BLUE32(PreviewControls(i).BorderColor))) + ")"
                END IF
                IF PreviewControls(i).BackStyle = __UI_Transparent THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).BackStyle = __UI_Transparent"
                END IF
                IF PreviewControls(i).HasBorder THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).HasBorder = True"
                END IF
                IF PreviewControls(i).Align = __UI_Center THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).Align = __UI_Center"
                ELSEIF PreviewControls(i).Align = __UI_Right THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).Align = __UI_Right"
                END IF
                IF PreviewControls(i).VAlign = __UI_Middle THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).VAlign = __UI_Middle"
                ELSEIF PreviewControls(i).VAlign = __UI_Bottom THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).VAlign = __UI_Bottom"
                END IF
                IF PreviewControls(i).PasswordField = True AND PreviewControls(i).Type = __UI_Type_TextBox THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).PasswordField = True"
                END IF
                IF PreviewControls(i).Value <> 0 THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).Value = " + LTRIM$(STR$(PreviewControls(i).Value))
                END IF
                IF PreviewControls(i).Min <> 0 THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).Min = " + LTRIM$(STR$(PreviewControls(i).Min))
                END IF
                IF PreviewControls(i).Max <> 0 THEN
                    IF PreviewControls(i).Type <> __UI_Type_ListBox AND _
                    PreviewControls(i).Type <>  __UI_Type_DropdownList THEN
                        PRINT #TextFileNum, "    Control(__UI_NewID).Max = " + LTRIM$(STR$(PreviewControls(i).Max))
                    END IF
                END IF
                IF PreviewControls(i).ShowPercentage THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).ShowPercentage = True"
                END IF
                IF PreviewControls(i).CanHaveFocus THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).CanHaveFocus = True"
                END IF
                IF PreviewControls(i).Disabled THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).Disabled = True"
                END IF
                IF PreviewControls(i).Hidden THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).Hidden = True"
                END IF
                IF PreviewControls(i).CenteredWindow THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).CenteredWindow = True"
                END IF
                IF PreviewControls(i).ContextMenuID THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).ContextMenuID = __UI_GetID(" + CHR$(34) + RTRIM$(PreviewControls(PreviewControls(i).ContextMenuID).Name) + CHR$(34) + ")"
                END IF
                IF PreviewControls(i).Interval THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).Interval = " + LTRIM$(STR$(PreviewControls(i).Interval))
                END IF
                IF PreviewControls(i).MinInterval THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).MinInterval = " + LTRIM$(STR$(PreviewControls(i).MinInterval))
                END IF
                IF PreviewControls(i).WordWrap THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).WordWrap = True"
                END IF
                IF PreviewControls(i).CanResize AND PreviewControls(i).Type = __UI_Type_Form THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).CanResize = True"
                END IF
                IF PreviewControls(i).Padding > 0 THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).Padding = " + LTRIM$(STR$(PreviewControls(i).Padding))
                END IF
                IF PreviewControls(i).Encoding > 0 THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).Encoding = " + LTRIM$(STR$(PreviewControls(i).Encoding))
                END IF
                IF PreviewControls(i).NumericOnly = True THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).NumericOnly = True"
                ELSEIF PreviewControls(i).NumericOnly = __UI_NumericWithBounds THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).NumericOnly = __UI_NumericWithBounds"
                END IF
                IF PreviewControls(i).BulletStyle > 0 THEN
                    SELECT CASE PreviewControls(i).BulletStyle
                        CASE __UI_Bullet
                            PRINT #TextFileNum, "    Control(__UI_NewID).BulletStyle = __UI_Bullet"
                    END SELECT
                END IF
                PRINT #TextFileNum,
            END IF
            EndOfThisPass:
        NEXT
    NEXT ThisPass

    PRINT #TextFileNum, "END SUB"
    PRINT #TextFileNum,
    PRINT #TextFileNum, "SUB __UI_AssignIDs"
    FOR i = 1 TO UBOUND(PreviewControls)
        IF PreviewControls(i).ID > 0 AND PreviewControls(i).Type <> __UI_Type_Font AND PreviewControls(i).Type <> __UI_Type_MenuPanel AND PreviewControls(i).Type <> __UI_Type_ContextMenu THEN
            PRINT #TextFileNum, "    " + RTRIM$(__UI_TrimAt0$(PreviewControls(i).Name)) + " = __UI_GetID(" + CHR$(34) + RTRIM$(__UI_TrimAt0$(PreviewControls(i).Name)) + CHR$(34) + ")"
        END IF
    NEXT
    PRINT #TextFileNum, "END SUB"
    CLOSE #TextFileNum
    IF NOT SaveOnlyFrm THEN
        OPEN BaseOutputFileName + ".bas" FOR OUTPUT AS #TextFileNum
        PRINT #TextFileNum, "': This program uses"
        PRINT #TextFileNum, "': InForm - GUI library for QB64 - "; __UI_Version
        PRINT #TextFileNum, "': Fellippe Heitor, 2016-2018 - fellippe@qb64.org - @fellippeheitor"
        PRINT #TextFileNum, "': https://github.com/FellippeHeitor/InForm"
        PRINT #TextFileNum, "'-----------------------------------------------------------"
        PRINT #TextFileNum,
        PRINT #TextFileNum, "': Controls' IDs: ------------------------------------------------------------------"
        IF PreserveBackup THEN
            PRINT #TextFileNum, "REM NOTICE: THIS FORM HAS BEEN RECENTLY EDITED"
            PRINT #TextFileNum, "'>> The controls in the list below may have been added or renamed,"
            PRINT #TextFileNum, "'>> and previously existing controls may have been deleted since"
            PRINT #TextFileNum, "'>> this program's structure was first generated."
            PRINT #TextFileNum, "'>> Make sure to check your code in the events SUBs so that"
            PRINT #TextFileNum, "'>> you can take your recent edits into consideration."
            PRINT #TextFileNum, "': ---------------------------------------------------------------------------------"
        END IF
        FOR i = 1 TO UBOUND(PreviewControls)
            IF PreviewControls(i).ID > 0 AND PreviewControls(i).Type <> __UI_Type_Font AND PreviewControls(i).Type <> __UI_Type_MenuPanel AND PreviewControls(i).Type <> __UI_Type_ContextMenu THEN
                PRINT #TextFileNum, "DIM SHARED " + RTRIM$(__UI_TrimAt0$(PreviewControls(i).Name)) + " AS LONG"
            END IF
        NEXT
        PRINT #TextFileNum,
        IF PreserveBackup THEN
            PRINT #TextFileNum, BackupCode$
            GOTO BackupRestored
        END IF
        PRINT #TextFileNum, "': External modules: ---------------------------------------------------------------"
        PRINT #TextFileNum, "'$INCLUDE:'InForm\InForm.ui'"
        PRINT #TextFileNum, "'$INCLUDE:'InForm\xp.uitheme'"
        PRINT #TextFileNum, "'$INCLUDE:'" + MID$(BaseOutputFileName, LEN(CurrentPath$) + 2) + ".frm'"
        PRINT #TextFileNum,
        PRINT #TextFileNum, "': Event procedures: ---------------------------------------------------------------"
        FOR i = 0 TO 14
            SELECT EVERYCASE i
                CASE 0: PRINT #TextFileNum, "SUB __UI_BeforeInit"
                CASE 1: PRINT #TextFileNum, "SUB __UI_OnLoad"
                CASE 2
                    PRINT #TextFileNum, "SUB __UI_BeforeUpdateDisplay"
                    PRINT #TextFileNum, "    'This event occurs at approximately 30 frames per second."
                    PRINT #TextFileNum, "    'You can change the update frequency by calling SetFrameRate DesiredRate%"
                CASE 3
                    PRINT #TextFileNum, "SUB __UI_BeforeUnload"
                    PRINT #TextFileNum, "    'If you set __UI_UnloadSignal = False here you can"
                    PRINT #TextFileNum, "    'cancel the user's request to close."
                CASE 4: PRINT #TextFileNum, "SUB __UI_Click (id AS LONG)"
                CASE 5: PRINT #TextFileNum, "SUB __UI_MouseEnter (id AS LONG)"
                CASE 6: PRINT #TextFileNum, "SUB __UI_MouseLeave (id AS LONG)"
                CASE 7: PRINT #TextFileNum, "SUB __UI_FocusIn (id AS LONG)"
                CASE 8
                    PRINT #TextFileNum, "SUB __UI_FocusOut (id AS LONG)"
                    PRINT #TextFileNum, "    'This event occurs right before a control loses focus."
                    PRINT #TextFileNum, "    'To prevent a control from losing focus, set __UI_KeepFocus = True below."
                CASE 9: PRINT #TextFileNum, "SUB __UI_MouseDown (id AS LONG)"
                CASE 10: PRINT #TextFileNum, "SUB __UI_MouseUp (id AS LONG)"
                CASE 11
                    PRINT #TextFileNum, "SUB __UI_KeyPress (id AS LONG)"
                    PRINT #TextFileNum, "    'When this event is fired, __UI_KeyHit will contain the code of the key hit."
                    PRINT #TextFileNum, "    'You can change it and even cancel it by making it = 0"
                CASE 12: PRINT #TextFileNum, "SUB __UI_TextChanged (id AS LONG)"
                CASE 13: PRINT #TextFileNum, "SUB __UI_ValueChanged (id AS LONG)"
                CASE 14: PRINT #TextFileNum, "SUB __UI_FormResized"

                CASE 0, 2, 3, 14
                    PRINT #TextFileNum,

                CASE 1
                    IF PreviewDefaultButtonID > 0 THEN
                        PRINT #TextFileNum, "    __UI_DefaultButtonID = " + RTRIM$(__UI_TrimAt0$(PreviewControls(PreviewDefaultButtonID).Name))
                    ELSE
                        PRINT #TextFileNum,
                    END IF

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

                CASE 13 'Dropdown list, List box, Track bar, ToggleSwitch, CheckBox
                    PRINT #TextFileNum, "    SELECT CASE id"
                    FOR Dummy = 1 TO UBOUND(PreviewControls)
                        IF PreviewControls(Dummy).ID > 0 AND (PreviewControls(Dummy).Type = __UI_Type_ListBox OR PreviewControls(Dummy).Type = __UI_Type_DropdownList OR PreviewControls(Dummy).Type = __UI_Type_TrackBar OR PreviewControls(Dummy).Type = __UI_Type_ToggleSwitch OR PreviewControls(Dummy).Type = __UI_Type_CheckBox OR PreviewControls(Dummy).Type = __UI_Type_RadioButton) THEN
                            PRINT #TextFileNum, "        CASE " + RTRIM$(PreviewControls(Dummy).Name)
                            PRINT #TextFileNum,
                        END IF
                    NEXT
                    PRINT #TextFileNum, "    END SELECT"
            END SELECT
            PRINT #TextFileNum, "END SUB"
            PRINT #TextFileNum,
        NEXT
        BackupRestored:
        CLOSE #TextFileNum
    END IF

    b$ = "Exporting successful. Files output:" + CHR$(10)
    IF NOT SaveOnlyFrm THEN b$ = b$ + "    " + MID$(BaseOutputFileName, LEN(CurrentPath$) + 2) + ".bas" + CHR$(10)
    b$ = b$ + "    " + MID$(BaseOutputFileName, LEN(CurrentPath$) + 2) + ".frm"

    IF ExitToQB64 AND NOT SaveOnlyFrm THEN
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
            IF _FILEEXISTS("qb64.exe") THEN SHELL _DONTWAIT "qb64.exe " + QuotedFilename$(BaseOutputFileName + ".bas")
        $ELSE
            IF _FILEEXISTS("qb64") THEN SHELL _DONTWAIT "./qb64 " + QuotedFilename$(BaseOutputFileName + ".bas")
        $END IF
        SYSTEM
    ELSE
        Answer = MessageBox(b$, "", MsgBox_OkOnly + MsgBox_Information)
    END IF
END SUB

$IF WIN THEN
    SUB LoadFontList
        DIM hKey AS _OFFSET
        DIM Ky AS _OFFSET
        DIM SubKey AS STRING
        DIM Value AS STRING
        DIM bData AS STRING
        DIM t AS STRING
        DIM dwType AS _UNSIGNED LONG
        DIM numBytes AS _UNSIGNED LONG
        DIM numTchars AS _UNSIGNED LONG
        DIM l AS LONG
        DIM dwIndex AS _UNSIGNED LONG

        Ky = HKEY_LOCAL_MACHINE
        SubKey = "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" + CHR$(0)
        Value = SPACE$(261) 'ANSI Value name limit 260 chars + 1 null
        bData = SPACE$(&H7FFF) 'arbitrary

        HasFontList = True
        l = RegOpenKeyExA(Ky, _OFFSET(SubKey), 0, KEY_READ, _OFFSET(hKey))
        IF l THEN
            HasFontList = False
            EXIT SUB
        ELSE
            dwIndex = 0
            DO
                numBytes = LEN(bData)
                numTchars = LEN(Value)
                l = RegEnumValueA(hKey, dwIndex, _OFFSET(Value), _OFFSET(numTchars), 0, _OFFSET(dwType), _OFFSET(bData), _OFFSET(numBytes))
                IF l THEN
                    IF l <> ERROR_NO_MORE_ITEMS THEN
                        HasFontList = False
                        EXIT SUB
                    END IF
                    EXIT DO
                ELSE
                    IF UCASE$(RIGHT$(formatData(dwType, numBytes, bData), 4)) = ".TTF" OR UCASE$(RIGHT$(formatData(dwType, numBytes, bData), 4)) = ".OTF" THEN
                        TotalFontsFound = TotalFontsFound + 1
                        IF TotalFontsFound > UBOUND(FontFile) THEN
                            REDIM _PRESERVE FontFile(TotalFontsFound) AS STRING
                        END IF
                        DIM tempName$
                        tempName$ = LEFT$(Value, numTchars)
                        IF RIGHT$(tempName$, 11) = " (TrueType)" THEN
                            tempName$ = LEFT$(tempName$, LEN(tempName$) - 11)
                        END IF
                        AddItem FontList, tempName$
                        FontFile(TotalFontsFound) = formatData(dwType, numBytes, bData)
                    END IF
                END IF
                dwIndex = dwIndex + 1
            LOOP
            l = RegCloseKey(hKey)
        END IF

        FOR l = 8 TO 120
            AddItem FontSizeList, LTRIM$(STR$(l))
        NEXT
    END SUB

    FUNCTION whatType$ (dwType AS _UNSIGNED LONG)
        SELECT CASE dwType
            CASE REG_SZ: whatType = "REG_SZ"
            CASE REG_EXPAND_SZ: whatType = "REG_EXPAND_SZ"
            CASE REG_BINARY: whatType = "REG_BINARY"
            CASE REG_DWORD: whatType = "REG_DWORD"
            CASE REG_DWORD_BIG_ENDIAN: whatType = "REG_DWORD_BIG_ENDIAN"
            CASE REG_LINK: whatType = "REG_LINK"
            CASE REG_MULTI_SZ: whatType = "REG_MULTI_SZ"
            CASE REG_RESOURCE_LIST: whatType = "REG_RESOURCE_LIST"
            CASE REG_FULL_RESOURCE_DESCRIPTOR: whatType = "REG_FULL_RESOURCE_DESCRIPTOR"
            CASE REG_RESOURCE_REQUIREMENTS_LIST: whatType = "REG_RESOURCE_REQUIREMENTS_LIST"
            CASE REG_QWORD: whatType = "REG_QWORD"
            CASE ELSE: whatType = "unknown"
        END SELECT
    END FUNCTION

    FUNCTION whatKey$ (hKey AS _OFFSET)
        SELECT CASE hKey
            CASE HKEY_CLASSES_ROOT: whatKey = "HKEY_CLASSES_ROOT"
            CASE HKEY_CURRENT_USER: whatKey = "HKEY_CURRENT_USER"
            CASE HKEY_LOCAL_MACHINE: whatKey = "HKEY_LOCAL_MACHINE"
            CASE HKEY_USERS: whatKey = "HKEY_USERS"
            CASE HKEY_PERFORMANCE_DATA: whatKey = "HKEY_PERFORMANCE_DATA"
            CASE HKEY_CURRENT_CONFIG: whatKey = "HKEY_CURRENT_CONFIG"
            CASE HKEY_DYN_DATA: whatKey = "HKEY_DYN_DATA"
        END SELECT
    END FUNCTION

    FUNCTION formatData$ (dwType AS _UNSIGNED LONG, numBytes AS _UNSIGNED LONG, bData AS STRING)
        DIM t AS STRING
        DIM ul AS _UNSIGNED LONG
        DIM b AS _UNSIGNED _BYTE
        SELECT CASE dwType
            CASE REG_SZ, REG_EXPAND_SZ, REG_MULTI_SZ
                formatData = LEFT$(bData, numBytes - 1)
            CASE REG_DWORD
                t = LCASE$(HEX$(CVL(LEFT$(bData, 4))))
                formatData = "0x" + STRING$(8 - LEN(t), &H30) + t
            CASE ELSE
                IF numBytes THEN
                    b = ASC(LEFT$(bData, 1))
                    IF b < &H10 THEN
                        t = t + "0" + LCASE$(HEX$(b))
                    ELSE
                        t = t + LCASE$(HEX$(b))
                    END IF
                END IF
                FOR ul = 2 TO numBytes
                    b = ASC(MID$(bData, ul, 1))
                    IF b < &H10 THEN
                        t = t + " 0" + LCASE$(HEX$(b))
                    ELSE
                        t = t + " " + LCASE$(HEX$(b))
                    END IF
                NEXT
                formatData = t
        END SELECT
    END FUNCTION
$END IF

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
FUNCTION idezfilelist$ (path$, method, TotalFound AS INTEGER) 'method0=*.frm and *.frmbin, method1=*.*
    DIM sep AS STRING * 1, filelist$, a$
    sep = CHR$(13)

    TotalFound = 0
    $IF WIN THEN
        OPEN "opendlgfiles.dat" FOR OUTPUT AS #150: CLOSE #150
        IF method = 0 THEN SHELL _HIDE "dir /b /ON /A-D " + QuotedFilename$(path$) + "\*.frm >opendlgfiles.dat"
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
        IF i = 1 THEN SHELL _HIDE "find " + QuotedFilename$(path$) + " -maxdepth 1 -type f -name " + CHR$(34) + "*.frm*" + CHR$(34) + " >opendlgfiles.dat"
        IF i = 2 THEN SHELL _HIDE "find " + QuotedFilename$(path$) + " -maxdepth 1 -type f -name " + CHR$(34) + "*.FRM*" + CHR$(34) + " >opendlgfiles.dat"
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

FUNCTION Download$ (url$, file$, timelimit) STATIC
    'as seen on http://www.qb64.org/wiki/Downloading_Files
    'adapted for use with InForm

    DIM client AS LONG, l AS LONG
    DIM prevUrl$, prevUrl2$, url2$, x AS LONG
    DIM e$, url3$, x$, t!, a2$, a$, i AS LONG
    DIM i2 AS LONG, i3 AS LONG, d$, fh AS LONG

    IF url$ <> prevUrl$ THEN
        prevUrl$ = url$
        IF url$ = "" THEN
            IF client THEN CLOSE client: client = 0
            EXIT SUB
        END IF
        url2$ = url$
        x = INSTR(url2$, "/")
        IF x THEN url2$ = LEFT$(url$, x - 1)
        IF url2$ <> prevUrl2$ THEN
            prevUrl2$ = url2$
            IF client THEN CLOSE client: client = 0
            client = _OPENCLIENT("TCP/IP:80:" + url2$)
            IF client = 0 THEN Download = MKI$(2): prevUrl$ = "": EXIT FUNCTION
        END IF
        e$ = CHR$(13) + CHR$(10) ' end of line characters
        url3$ = RIGHT$(url$, LEN(url$) - x + 1)
        x$ = "GET " + url3$ + " HTTP/1.1" + e$
        x$ = x$ + "Host: " + url2$ + e$ + e$
        PUT #client, , x$
        t! = TIMER ' start time
    END IF

    GET #client, , a2$
    a$ = a$ + a2$
    i = INSTR(a$, "Content-Length:")
    IF i THEN
        i2 = INSTR(i, a$, e$)
        IF i2 THEN
            l = VAL(MID$(a$, i + 15, i2 - i - 14))
            i3 = INSTR(i2, a$, e$ + e$)
            IF i3 THEN
                i3 = i3 + 4 'move i3 to start of data
                IF (LEN(a$) - i3 + 1) = l THEN
                    d$ = MID$(a$, i3, l)
                    fh = FREEFILE
                    OPEN file$ FOR OUTPUT AS #fh: CLOSE #fh 'Warning! Clears data from existing file
                    OPEN file$ FOR BINARY AS #fh
                    PUT #fh, , d$
                    CLOSE #fh
                    Download = MKI$(1) + MKL$(l) 'indicates download was successful
                    prevUrl$ = ""
                    a$ = ""
                    EXIT FUNCTION
                END IF ' availabledata = l
            END IF ' i3
        END IF ' i2
    END IF ' i
    IF TIMER > t! + timelimit THEN CLOSE client: client = 0: Download = MKI$(3): prevUrl$ = "": EXIT FUNCTION
    Download = MKI$(0) 'still working
END FUNCTION

