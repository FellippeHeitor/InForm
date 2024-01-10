'-----------------------------------------------------------------------------------------------------------------------
' InForm-PE GUI engine for QB64-PE
' Copyright (c) 2024 Samuel Gomes
' Copyright (c) 2023 George McGinn
' Copyright (c) 2022 Fellippe Heitor
'-----------------------------------------------------------------------------------------------------------------------

OPTION _EXPLICIT

$EXEICON:'./resources/InForm.ico'

'Controls: --------------------------------------------------------------------
'Main form
DIM SHARED UiEditor AS LONG
DIM SHARED StatusBar AS LONG

'Menus
DIM SHARED FileMenu AS LONG, EditMenu AS LONG, ViewMenu AS LONG
DIM SHARED InsertMenu AS LONG, AlignMenu AS LONG, OptionsMenu AS LONG
DIM SHARED HelpMenu AS LONG, FontSwitchMenu AS LONG

'Frames
DIM SHARED Toolbox AS LONG, ColorMixer AS LONG
DIM SHARED OpenFrame AS LONG, ZOrdering AS LONG
DIM SHARED ControlProperties AS LONG, ControlToggles AS LONG
DIM SHARED SetControlBinding AS LONG

'Menu items
DIM SHARED FileMenuNew AS LONG, FileMenuOpen AS LONG
DIM SHARED FileMenuSave AS LONG, FileMenuSaveAs AS LONG
DIM SHARED FileMenuExit AS LONG

DIM SHARED FileMenuRecent AS LONG
DIM SHARED FileMenuRecent1 AS LONG
DIM SHARED FileMenuRecent2 AS LONG
DIM SHARED FileMenuRecent3 AS LONG
DIM SHARED FileMenuRecent4 AS LONG
DIM SHARED FileMenuRecent5 AS LONG
DIM SHARED FileMenuRecent6 AS LONG
DIM SHARED FileMenuRecent7 AS LONG
DIM SHARED FileMenuRecent8 AS LONG
DIM SHARED FileMenuRecent9 AS LONG

DIM SHARED EditMenuUndo AS LONG, EditMenuRedo AS LONG, EditMenuCut AS LONG
DIM SHARED EditMenuCopy AS LONG, EditMenuPaste AS LONG
DIM SHARED EditMenuDelete AS LONG, EditMenuSelectAll AS LONG
DIM SHARED EditMenuCP437 AS LONG, EditMenuCP1252 AS LONG
DIM SHARED EditMenuConvertType AS LONG, EditMenuSetDefaultButton AS LONG
DIM SHARED EditMenuRestoreDimensions AS LONG, EditMenuBindControls AS LONG
DIM SHARED EditMenuAllowMinMax AS LONG, EditMenuZOrdering AS LONG

DIM SHARED ViewMenuPreviewDetach AS LONG
DIM SHARED ViewMenuShowPositionAndSize AS LONG
DIM SHARED ViewMenuShowInvisibleControls AS LONG
DIM SHARED ViewMenuPreview AS LONG, ViewMenuLoadedFonts AS LONG

DIM SHARED InsertMenuMenuBar AS LONG, InsertMenuContextMenu AS LONG
DIM SHARED InsertMenuMenuItem AS LONG

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

DIM SHARED HelpMenuHelp AS LONG, HelpMenuAbout AS LONG

DIM SHARED FontSwitchMenuSwitch AS LONG

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
DIM SHARED Resizable AS LONG, AutoScroll AS LONG
DIM SHARED AutoSize AS LONG, SizeTB AS LONG
DIM SHARED HideTicks AS LONG, AutoPlayGif AS LONG
DIM SHARED AddGifExtensionToggle AS LONG

'Open/Save dialog
DIM SHARED DialogBG AS LONG, FileNameLB AS LONG
DIM SHARED FileNameTextBox AS LONG, PathLB AS LONG
DIM SHARED FilesLB AS LONG, FileList AS LONG
DIM SHARED PathsLB AS LONG, DirList AS LONG
DIM SHARED OpenBT AS LONG, SaveBT AS LONG, CancelBT AS LONG
DIM SHARED ShowOnlyFrmbinFilesCB AS LONG, SaveFrmOnlyCB AS LONG

'Z-ordering dialog
DIM SHARED ControlList AS LONG, UpBT AS LONG
DIM SHARED DownBT AS LONG, CloseZOrderingBT AS LONG

'Set binding dialog
DIM SHARED SourceControlLB AS LONG
DIM SHARED SourceControlNameLB AS LONG
DIM SHARED TargetControlLB AS LONG
DIM SHARED TargetControlNameLB AS LONG
'DIM SHARED SwapBT AS LONG
DIM SHARED SourcePropertyLB AS LONG
DIM SHARED SourcePropertyList AS LONG
DIM SHARED TargetPropertyLB AS LONG
DIM SHARED TargetPropertyList AS LONG
DIM SHARED BindBT AS LONG
DIM SHARED CancelBindBT AS LONG

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
DIM SHARED PasteListBT AS LONG, ContextMenuLB AS LONG
DIM SHARED ContextMenuControlsList AS LONG
DIM SHARED KeyboardComboLB AS LONG, KeyboardComboBT AS LONG
'------------------------------------------------------------------------------

'Other shared variables:
DIM SHARED UiPreviewPID AS LONG, TotalSelected AS LONG, FirstSelected AS LONG
DIM SHARED PreviewFormID AS LONG, PreviewSelectionRectangle AS INTEGER
DIM SHARED PreviewAttached AS _BYTE, AutoNameControls AS _BYTE
DIM SHARED LastKeyPress AS DOUBLE
DIM SHARED UiEditorTitle$, Edited AS _BYTE, ZOrderingDialogOpen AS _BYTE
DIM SHARED OpenDialogOpen AS _BYTE
DIM SHARED PropertySent AS _BYTE, RevertEdit AS _BYTE, OldColor AS _UNSIGNED LONG
DIM SHARED ColorPreviewWord$, BlinkStatusBar AS SINGLE, StatusBarBackColor AS _UNSIGNED LONG
DIM SHARED InstanceHost AS LONG, InstanceClient AS LONG
DIM SHARED HostPort AS STRING, Host AS LONG, Client AS LONG
DIM SHARED Stream$, FormDataReceived AS _BYTE, LastFormData$
DIM SHARED prevScreenX AS INTEGER, prevScreenY AS INTEGER
DIM SHARED UndoPointer AS INTEGER, TotalUndoImages AS INTEGER
DIM SHARED totalBytesSent AS _UNSIGNED _INTEGER64
DIM SHARED RecentMenuItem(1 TO 9) AS LONG, RecentListBuilt AS _BYTE
DIM SHARED LoadedWithGifExtension AS _BYTE, AddGifExtension AS _BYTE
DIM SHARED TotalGifLoaded AS LONG, SetBindingDialogOpen AS _BYTE
DIM SHARED InitialControlSet AS STRING
DIM SHARED Answer AS LONG

TYPE newInputBox
    ID AS LONG
    LabelID AS LONG
    Signal AS INTEGER
    LastEdited AS SINGLE
    DataType AS INTEGER
    Sent AS _BYTE
END TYPE

CONST DT_Text = 1
CONST DT_Integer = 2
CONST DT_Float = 3

REDIM SHARED PreviewCaptions(0) AS STRING
REDIM SHARED PreviewTexts(0) AS STRING
REDIM SHARED PreviewMasks(0) AS STRING
REDIM SHARED PreviewTips(0) AS STRING
REDIM SHARED PreviewFonts(0) AS STRING
REDIM SHARED PreviewActualFonts(0) AS STRING
REDIM SHARED PreviewControls(0) AS __UI_ControlTYPE
REDIM SHARED PreviewParentIDS(0) AS STRING
REDIM SHARED PreviewContextMenu(0) AS STRING
REDIM SHARED PreviewBoundTo(0) AS STRING
REDIM SHARED PreviewBoundProperty(0) AS STRING
REDIM SHARED PreviewKeyCombos(0) AS STRING
REDIM SHARED PreviewAnimatedGif(0) AS _BYTE
REDIM SHARED PreviewAutoPlayGif(0) AS _BYTE
REDIM SHARED zOrderIDs(0) AS LONG
REDIM SHARED InputBox(1 TO 100) AS newInputBox
REDIM SHARED Toggles(1 TO 100) AS LONG
REDIM SHARED InputBoxText(1 TO 100) AS STRING
DIM SHARED PreviewDefaultButtonID AS LONG

DIM SHARED HasFontList AS _BYTE, ShowFontList AS _BYTE
DIM SHARED AttemptToShowFontList AS _BYTE, BypassShowFontList AS _BYTE
DIM SHARED TotalFontsFound AS LONG
REDIM SHARED FontFile(0) AS STRING

CONST QB64_DISPLAY = "QB64-PE"
DIM SHARED AS STRING QB64_EXE_PATH

$IF WIN THEN
    CONST PathSep$ = "\"
    CONST QB64_EXE_NAME = "qb64pe.exe"
$ELSE
        CONST PathSep$ = "/"
        CONST QB64_EXE_NAME = "qb64pe"
$END IF

UiEditorTitle$ = "InForm Designer"

QB64_EXE_PATH = ReadSetting("InForm/InForm.ini", "InForm Settings", "QB64PE path") ' read the compiler path name from the INI

IF NOT _FILEEXISTS(QB64_EXE_PATH) THEN ' if the compiler is missing then look for it in obvious places
    IF _FILEEXISTS("." + PathSep$ + QB64_EXE_NAME) THEN
        QB64_EXE_PATH = "." + PathSep$ + QB64_EXE_NAME
    ELSEIF _FILEEXISTS(".." + PathSep$ + QB64_EXE_NAME) THEN
        QB64_EXE_PATH = ".." + PathSep$ + QB64_EXE_NAME
    ELSEIF _FILEEXISTS(".." + PathSep$ + "QB64pe" + PathSep$ + QB64_EXE_NAME) THEN
        QB64_EXE_PATH = ".." + PathSep$ + "QB64pe" + PathSep$ + QB64_EXE_NAME
    ELSEIF _FILEEXISTS(".." + PathSep$ + "qb64pe" + PathSep$ + QB64_EXE_NAME) THEN
        QB64_EXE_PATH = ".." + PathSep$ + "qb64pe" + PathSep$ + QB64_EXE_NAME
    ELSE
        QB64_EXE_PATH = _SELECTFOLDERDIALOG$("Select QB64-PE directory:")

        IF _FILEEXISTS(QB64_EXE_PATH + PathSep$ + QB64_EXE_NAME) THEN
            QB64_EXE_PATH = QB64_EXE_PATH + PathSep$ + QB64_EXE_NAME
        ELSE
            _MESSAGEBOX UiEditorTitle$, QB64_DISPLAY + " executable not found.", "error"

            SYSTEM 1
        END IF

        WriteSetting "InForm/InForm.ini", "InForm Settings", "QB64PE path", QB64_EXE_PATH ' save the complete path name to the INI
    END IF
END IF

DIM SHARED CurrentPath$, ThisFileName$

CONST EDITOR_IMAGE_COMMONCONTROLS~%% = 1~%%
CONST EDITOR_IMAGE_DISK~%% = 2~%%

'CheckPreviewTimer = _FREETIMER
'ON TIMER(CheckPreviewTimer, .003) CheckPreview

$IF WIN THEN
    DECLARE DYNAMIC LIBRARY "kernel32"
        FUNCTION OpenProcess& (BYVAL dwDesiredAccess AS LONG, BYVAL bInheritHandle AS LONG, BYVAL dwProcessId AS LONG)
        FUNCTION CloseHandle& (BYVAL hObject AS LONG)
        FUNCTION GetExitCodeProcess& (BYVAL hProcess AS LONG, lpExitCode AS LONG)
    END DECLARE

    DECLARE DYNAMIC LIBRARY "user32"
        FUNCTION SetForegroundWindow& (BYVAL hWnd AS LONG)
    END DECLARE

    ''Registry routines taken from the Wiki: http://www.qb64.org/wiki/Windows_Libraries#Registered_Fonts
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

'$INCLUDE:'extensions/Ini.bi'
'$INCLUDE:'InForm.bi'
'$INCLUDE:'UiEditor.frm'
'$INCLUDE:'InForm.ui'
'$INCLUDE:'extensions/Ini.bas'

'Event procedures: ---------------------------------------------------------------
SUB __UI_Click (id AS LONG)
    DIM Answer AS _BYTE, Dummy AS LONG, b$
    STATIC LastClick#, LastClickedID AS LONG

    SendSignal -8

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
        CASE AlignMenuAlignLeft, AlignMenuAlignRight, AlignMenuAlignTops, AlignMenuAlignBottoms, AlignMenuAlignCentersV, AlignMenuAlignCentersH, AlignMenuAlignCenterV, AlignMenuAlignCenterH, AlignMenuDistributeV, AlignMenuDistributeH
            b$ = MKI$(0)
            SendData b$, Dummy
        CASE OptionsMenuAutoName
            AutoNameControls = NOT AutoNameControls
            Control(id).Value = AutoNameControls
            SaveSettings
        CASE EditMenuConvertType
            b$ = MKI$(0)
            SendData b$, 225
        CASE EditMenuSetDefaultButton
            SendSignal -6
        CASE EditMenuRestoreDimensions
            SendSignal -7
        CASE OptionsMenuSwapButtons
            __UI_MouseButtonsSwap = NOT __UI_MouseButtonsSwap
            Control(id).Value = __UI_MouseButtonsSwap
            SaveSettings
        CASE OptionsMenuSnapLines
            __UI_SnapLines = NOT __UI_SnapLines
            Control(id).Value = __UI_SnapLines
            SaveSettings
        CASE InsertMenuMenuBar
            b$ = "NEWCONTROL>" + MKI$(__UI_Type_MenuBar) + "<END>"
            Send Client, b$
        CASE InsertMenuMenuItem
            b$ = "NEWCONTROL>" + MKI$(__UI_Type_MenuItem) + "<END>"
            Send Client, b$
        CASE InsertMenuContextMenu
            b$ = "NEWCONTROL>" + MKI$(__UI_Type_ContextMenu) + "<END>"
            Send Client, b$
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
        CASE AddButton, AddLabel, AddTextBox, AddCheckBox, AddRadioButton, AddListBox, AddDropdownList, AddTrackBar, AddProgressBar, AddPictureBox, AddFrame, AddToggleSwitch
            b$ = "NEWCONTROL>" + MKI$(Dummy) + "<END>"
            Send Client, b$
        CASE AddNumericBox
            b$ = MKI$(0)
            SendData b$, 222
        CASE Stretch
            b$ = MKI$(Control(id).Value)
            SendData b$, 14
        CASE HasBorder
            b$ = MKI$(Control(id).Value)
            SendData b$, 15
        CASE Transparent
            b$ = MKI$(Control(Transparent).Value)
            SendData b$, 28
        CASE ShowPercentage
            b$ = MKI$(Control(id).Value)
            SendData b$, 16
        CASE WordWrap
            b$ = MKI$(Control(id).Value)
            SendData b$, 17

            'Also: disable autosize
            IF Control(id).Value THEN
                b$ = MKI$(0)
                SendData b$, 39
            END IF
        CASE CanHaveFocus
            b$ = MKI$(Control(id).Value)
            SendData b$, 18
        CASE ColorPreview
            _CLIPBOARD$ = ColorPreviewWord$
        CASE Disabled
            b$ = MKI$(Control(id).Value)
            SendData b$, 19
        CASE Hidden
            b$ = MKI$(Control(id).Value)
            SendData b$, 20
        CASE CenteredWindow
            b$ = MKI$(Control(id).Value)
            SendData b$, 21
        CASE Resizable
            b$ = MKI$(Control(id).Value)
            SendData b$, 29
        CASE PasswordMaskCB
            b$ = MKI$(Control(id).Value)
            SendData b$, 33
        CASE AutoScroll
            b$ = MKI$(Control(id).Value)
            SendData b$, 38
        CASE AutoSize
            b$ = MKI$(Control(id).Value)
            SendData b$, 39
        CASE HideTicks
            b$ = MKI$(Control(id).Value)
            SendData b$, 42
        CASE AutoPlayGif
            b$ = MKI$(Control(id).Value)
            SendData b$, 44
        CASE AddGifExtensionToggle
            IF Control(AddGifExtensionToggle).Value = FALSE AND TotalGifLoaded > 0 THEN
                _DELAY 0.2: Answer = _MESSAGEBOX(UiEditorTitle$, "Removing the GIF extension will load the existing animations as static frames. Proceed?", "yesno", "question", 0)
                IF Answer = 0 THEN
                    Control(AddGifExtensionToggle).Value = TRUE
                ELSE
                    b$ = "PAUSEALLGIF>" + "<END>"
                    Send Client, b$
                END IF
            END IF
        CASE ViewMenuPreview
            $IF WIN THEN
                SHELL _DONTWAIT ".\InForm\UiEditorPreview.exe " + HostPort
            $ELSE
                    SHELL _DONTWAIT "./InForm/UiEditorPreview " + HostPort
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
                MessageBox Temp$, UiEditorTitle$ + " - Loaded fonts", MsgBox_Information
            ELSE
                MessageBox "There are no fonts loaded.", UiEditorTitle$, MsgBox_Exclamation
            END IF
        CASE FileMenuNew
            IF Edited THEN
                _DELAY 0.2: Answer = _MESSAGEBOX(UiEditorTitle$, "Save the current form?", "yesnocancel", "question", 1)
                IF Answer = 0 THEN
                    EXIT SUB
                ELSEIF Answer = 1 THEN
                    SaveForm FALSE, FALSE
                END IF
            END IF

            __UI_Focus = 0
            LastFormData$ = ""
            ThisFileName$ = ""
            Stream$ = ""
            FormDataReceived = FALSE
            AddGifExtension = FALSE
            Control(AddGifExtensionToggle).Value = FALSE
            LoadedWithGifExtension = FALSE
            Edited = FALSE
            SendSignal -5
        CASE FileMenuSave
            IF LEN(ThisFileName$) THEN
                SaveForm TRUE, FALSE
            ELSE
                GOTO SaveAs
            END IF
        CASE FileMenuSaveAs
            SaveAs:
            'Refresh the file list control's contents
            DIM TotalFiles%
            IF CurrentPath$ = "" THEN CurrentPath$ = _STARTDIR$
            Text(FileList) = idezfilelist$(CurrentPath$, Control(ShowOnlyFrmbinFilesCB).Value + 1, 1, TotalFiles%)
            Control(FileList).Max = TotalFiles%
            Control(FileList).LastVisibleItem = 0 'Reset it so it's recalculated

            Control(DialogBG).Left = 0: Control(DialogBG).Top = 0
            Control(OpenFrame).Left = 18: Control(OpenFrame).Top = 40
            Caption(OpenFrame) = "Save as"
            Control(SaveBT).Hidden = FALSE
            Control(OpenBT).Hidden = TRUE
            Control(SaveFrmOnlyCB).Hidden = FALSE
            Control(ShowOnlyFrmbinFilesCB).Hidden = TRUE
            Control(SaveFrmOnlyCB).Value = FALSE
            OpenDialogOpen = TRUE
            Caption(StatusBar) = "Specify the name under which to save the current form..."
            __UI_Focus = FileNameTextBox
            IF LEN(ThisFileName$) THEN
                Text(FileNameTextBox) = ThisFileName$
            ELSE
                Text(FileNameTextBox) = ""
            END IF
            IF LEN(Text(FileNameTextBox)) THEN
                Control(FileNameTextBox).SelectionStart = 0
                Control(FileNameTextBox).Cursor = LEN(Text(FileNameTextBox))
                Control(FileNameTextBox).TextIsSelected = TRUE
            END IF
            __UI_ForceRedraw = TRUE
        CASE SaveBT
            SaveFile:
            IF OpenDialogOpen THEN
                DIM FileToOpen$, FreeFileNum AS INTEGER
                FileToOpen$ = CurrentPath$ + PathSep$ + Text(FileNameTextBox)
                ThisFileName$ = LTRIM$(RTRIM$(Text(FileNameTextBox)))
                IF ThisFileName$ = "" THEN EXIT SUB
                IF UCASE$(RIGHT$(ThisFileName$, 4)) <> ".FRM" THEN
                    ThisFileName$ = ThisFileName$ + ".frm"
                END IF
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
                OpenDialogOpen = FALSE
                Caption(StatusBar) = "Ready."
                __UI_Focus = 0
                SaveForm TRUE, Control(SaveFrmOnlyCB).Value
            END IF
        CASE HelpMenuAbout
            MessageBox "InForm GUI engine for QB64-PE" + CHR$(13) + "Fellippe Heitor, (2016 - 2022) - @FellippeHeitor" + CHR$(13) + "George McGinn, 2023 - gbytes58@gmail.com" + CHR$(13) + "Samuel Gomes, (2023 - 2024) - @a740g" + STRING$(2, 13) + UiEditorTitle$ + " v" + __UI_Version + STRING$(2, 13) + "https://github.com/a740g/InForm-PE", UiEditorTitle$ + " - About", MsgBox_Information
        CASE HelpMenuHelp
            MessageBox "Design a form and export the resulting code to generate an event-driven QB64-PE program.", UiEditorTitle$ + " - What's all this?", MsgBox_Information
        CASE FileMenuExit
            IF Edited THEN
                _DELAY 0.2: Answer = _MESSAGEBOX(UiEditorTitle$, "Save the current form before leaving?", "yesnocancel", "question", 1)
                IF Answer = 0 THEN
                    EXIT SUB
                ELSEIF Answer = 1 THEN
                    SaveForm FALSE, FALSE
                END IF
            END IF
            IF _FILEEXISTS("InForm/UiEditorPreview.frmbin") THEN KILL "InForm/UiEditorPreview.frmbin"
            SYSTEM
        CASE EditMenuZOrdering
            'Fill the list:
            Caption(StatusBar) = "Editing z-ordering/tab ordering"
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
            ZOrderingDialogOpen = TRUE
        CASE EditMenuBindControls
            'Get controls' names and bound properties
            DIM CurrentSource$
            j = 0
            FOR i = 1 TO UBOUND(PreviewControls)
                IF PreviewControls(i).ControlIsSelected THEN
                    j = j + 1
                    IF j = 1 THEN
                        Caption(SourceControlNameLB) = RTRIM$(PreviewControls(i).Name)
                        CurrentSource$ = PreviewBoundTo(i)
                        IF LEN(PreviewBoundProperty(i)) = 0 THEN
                            Dummy = SelectItem(SourcePropertyList, "Value")
                        ELSE
                            Dummy = SelectItem(SourcePropertyList, PreviewBoundProperty(i))
                        END IF
                    END IF
                    IF j = 2 THEN
                        Caption(TargetControlNameLB) = RTRIM$(PreviewControls(i).Name)
                        IF LEN(PreviewBoundProperty(i)) = 0 THEN
                            Dummy = SelectItem(TargetPropertyList, "Value")
                        ELSE
                            Dummy = SelectItem(TargetPropertyList, PreviewBoundProperty(i))
                        END IF
                        EXIT FOR
                    END IF
                END IF
            NEXT

            IF CurrentSource$ = Caption(TargetControlNameLB) THEN
                Caption(BindBT) = "Rebind"
                Caption(CancelBindBT) = "Unbind"
            ELSE
                Caption(BindBT) = "Bind"
                Caption(CancelBindBT) = "Cancel"
            END IF

            Caption(StatusBar) = "Defining control bindings"
            Control(DialogBG).Left = 0: Control(DialogBG).Top = 0
            Control(SetControlBinding).Left = 83: Control(SetControlBinding).Top = 169
            __UI_Focus = SourcePropertyList
            SetBindingDialogOpen = TRUE
            'CASE SwapBT
            '    SWAP Caption(SourceControlNameLB), Caption(TargetControlNameLB)
            '    SWAP Control(SourcePropertyList).Value, Control(TargetPropertyList).Value
        CASE BindBT
            Control(DialogBG).Left = -600: Control(DialogBG).Top = -600
            Control(SetControlBinding).Left = -600: Control(SetControlBinding).Top = -600
            SetBindingDialogOpen = FALSE
            b$ = "BINDCONTROLS>"
            b$ = b$ + MKL$(LEN(Caption(SourceControlNameLB))) + Caption(SourceControlNameLB)
            b$ = b$ + MKL$(LEN(Caption(TargetControlNameLB))) + Caption(TargetControlNameLB)
            b$ = b$ + MKL$(LEN(GetItem(SourcePropertyList, Control(SourcePropertyList).Value)))
            b$ = b$ + GetItem(SourcePropertyList, Control(SourcePropertyList).Value)
            b$ = b$ + MKL$(LEN(GetItem(TargetPropertyList, Control(TargetPropertyList).Value)))
            b$ = b$ + GetItem(TargetPropertyList, Control(TargetPropertyList).Value)
            b$ = b$ + "<END>"
            Send Client, b$
        CASE CancelBindBT
            Control(DialogBG).Left = -600: Control(DialogBG).Top = -600
            Control(SetControlBinding).Left = -600: Control(SetControlBinding).Top = -600
            SetBindingDialogOpen = FALSE
            IF Caption(CancelBindBT) = "Unbind" THEN
                b$ = "UNBINDCONTROLS>"
                b$ = b$ + Caption(SourceControlNameLB)
                b$ = b$ + "<END>"
                Send Client, b$
            END IF
        CASE CloseZOrderingBT
            Caption(StatusBar) = "Ready."
            Control(DialogBG).Left = -600: Control(DialogBG).Top = -600
            Control(ZOrdering).Left = -600: Control(ZOrdering).Top = -600
            __UI_Focus = 0
            ZOrderingDialogOpen = FALSE
        CASE UpBT
            DIM PrevListValue AS LONG
            PrevListValue = Control(ControlList).Value
            b$ = MKL$(zOrderIDs(Control(ControlList).Value)) + MKL$(zOrderIDs(Control(ControlList).Value - 1))
            SendData b$, 211
            _DELAY .1
            Moving = TRUE: GOSUB ReloadZList
            Moving = FALSE
            Control(ControlList).Value = PrevListValue - 1
            __UI_Focus = ControlList
            __UI_ValueChanged ControlList
        CASE DownBT
            PrevListValue = Control(ControlList).Value
            b$ = MKL$(zOrderIDs(Control(ControlList).Value)) + MKL$(zOrderIDs(Control(ControlList).Value + 1))
            SendData b$, 212
            _DELAY .1
            Moving = TRUE: GOSUB ReloadZList
            Moving = FALSE
            Control(ControlList).Value = PrevListValue + 1
            __UI_Focus = ControlList
            __UI_ValueChanged ControlList
        CASE FileMenuOpen
            IF Edited THEN
                _DELAY 0.2: Answer = _MESSAGEBOX(UiEditorTitle$, "Save the current form?", "yesnocancel", "question", 1)
                IF Answer = 0 THEN
                    EXIT SUB
                ELSEIF Answer = 1 THEN
                    SaveForm FALSE, FALSE
                END IF
            END IF

            'Hide the preview
            SendSignal -2

            'Refresh the file list control's contents
            IF CurrentPath$ = "" THEN CurrentPath$ = _STARTDIR$
            Text(FileList) = idezfilelist$(CurrentPath$, Control(ShowOnlyFrmbinFilesCB).Value + 1, 1, TotalFiles%)
            Control(FileList).Max = TotalFiles%
            Control(FileList).LastVisibleItem = 0 'Reset it so it's recalculated

            Control(DialogBG).Left = 0: Control(DialogBG).Top = 0
            Control(OpenFrame).Left = 18: Control(OpenFrame).Top = 40
            Caption(OpenFrame) = "Open"
            Control(SaveBT).Hidden = TRUE
            Control(OpenBT).Hidden = FALSE
            Control(SaveFrmOnlyCB).Hidden = TRUE
            Control(ShowOnlyFrmbinFilesCB).Hidden = FALSE
            OpenDialogOpen = TRUE
            Caption(StatusBar) = "Select a form file to load..."
            __UI_Focus = FileNameTextBox
            IF LEN(Text(FileNameTextBox)) > 0 THEN
                Control(FileNameTextBox).SelectionStart = 0
                Control(FileNameTextBox).Cursor = LEN(Text(FileNameTextBox))
                Control(FileNameTextBox).TextIsSelected = TRUE
            END IF
            __UI_ForceRedraw = TRUE
        CASE CancelBT
            Text(FileNameTextBox) = ""
            Control(DialogBG).Left = -600: Control(DialogBG).Top = -600
            Control(OpenFrame).Left = -600: Control(OpenFrame).Top = -600
            OpenDialogOpen = FALSE
            Caption(StatusBar) = "Ready."
            'Show the preview
            SendSignal -3

            __UI_Focus = 0
            __UI_ForceRedraw = TRUE
        CASE FileMenuRecent1, FileMenuRecent2, FileMenuRecent3, FileMenuRecent4, FileMenuRecent5, FileMenuRecent6, FileMenuRecent7, FileMenuRecent8, FileMenuRecent9
            DIM RecentToOpen$
            RecentToOpen$ = ToolTip(id)
            IF _FILEEXISTS(RecentToOpen$) THEN
                IF INSTR(RecentToOpen$, "/") > 0 OR INSTR(RecentToOpen$, "\") > 0 THEN
                    FOR i = LEN(RecentToOpen$) TO 1 STEP -1
                        IF ASC(RecentToOpen$, i) = 92 OR ASC(RecentToOpen$, i) = 47 THEN
                            CurrentPath$ = LEFT$(RecentToOpen$, i - 1)
                            RecentToOpen$ = MID$(RecentToOpen$, i + 1)
                            EXIT FOR
                        END IF
                    NEXT
                END IF

                IF Edited THEN
                    _DELAY 0.2: Answer = _MESSAGEBOX(UiEditorTitle$, "Save the current form?", "yesnocancel", "question", 1)
                    IF Answer = 0 THEN
                        EXIT SUB
                    ELSEIF Answer = 1 THEN
                        SaveForm FALSE, FALSE
                    END IF
                END IF

                Text(FileNameTextBox) = RecentToOpen$
                OpenDialogOpen = TRUE
                __UI_Click OpenBT
            ELSE
                MessageBox "File not found.", UiEditorTitle$, MsgBox_Critical
                RemoveFromRecentList RecentToOpen$
            END IF
        CASE OpenBT
            OpenFile:
            IF OpenDialogOpen THEN
                FileToOpen$ = CurrentPath$ + PathSep$ + Text(FileNameTextBox)
                IF _FILEEXISTS(FileToOpen$) THEN
                    LoadedWithGifExtension = FALSE
                    IF _FILEEXISTS(LEFT$(FileToOpen$, LEN(FileToOpen$) - 4) + ".bas") THEN
                        FreeFileNum = FREEFILE
                        OPEN LEFT$(FileToOpen$, LEN(FileToOpen$) - 4) + ".bas" FOR BINARY AS #FreeFileNum
                        b$ = SPACE$(LOF(FreeFileNum))
                        GET #FreeFileNum, 1, b$
                        CLOSE #FreeFileNum
                        IF INSTR(b$, CHR$(10) + "'$INCLUDE:'InForm/extensions/GIFPlay.bas'") > 0 THEN
                            LoadedWithGifExtension = TRUE
                        END IF
                    END IF

                    AddToRecentList FileToOpen$
                    ThisFileName$ = Text(FileNameTextBox)

                    'Send open command
                    IF LoadedWithGifExtension = FALSE THEN
                        LoadedWithGifExtension = 1 'Set to 1 to check whether a loaded file already had the gif extension
                        Control(AddGifExtensionToggle).Value = FALSE
                    ELSE
                        Control(AddGifExtensionToggle).Value = TRUE
                    END IF
                    AddGifExtension = FALSE
                    b$ = "OPENFILE>" + FileToOpen$ + "<END>"
                    Send Client, b$

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
                    OpenDialogOpen = FALSE
                    Caption(StatusBar) = "Ready."
                    __UI_Focus = 0
                    Edited = FALSE
                    LastFormData$ = ""
                    Stream$ = ""
                    FormDataReceived = FALSE
                    InitialControlSet = ""
                ELSE
                    MessageBox "File not found.", UiEditorTitle$, MsgBox_Critical
                    Control(FileList).Value = 0
                END IF
            END IF
        CASE FileList
            Text(FileNameTextBox) = GetItem(FileList, Control(FileList).Value)
            Control(DirList).Value = 0
            IF Control(FileList).HoveringVScrollbarButton = 0 AND LastClickedID = id AND TIMER - LastClick# < .3 THEN 'Double click
                IF LEN(Text(FileNameTextBox)) > 0 THEN
                    IF Caption(OpenFrame) = "Open" THEN
                        GOTO OpenFile
                    ELSE
                        GOTO SaveFile
                    END IF
                END IF
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
            Text(FileList) = idezfilelist$(CurrentPath$, Control(ShowOnlyFrmbinFilesCB).Value + 1, 1, TotalFiles%)
            Control(FileList).Max = TotalFiles%
            Control(FileList).FirstVisibleLine = 1
            Control(FileList).InputViewStart = 1
            Control(FileList).Value = 0
            Control(FileList).LastVisibleItem = 0 'Reset it so it's recalculated
        CASE EditMenuUndo
            SendSignal 214
        CASE EditMenuRedo
            SendSignal 215
        CASE EditMenuCopy
            b$ = MKI$(0)
            SendData b$, 217
        CASE EditMenuPaste
            b$ = MKI$(0)
            SendData b$, 218
        CASE EditMenuCut
            b$ = MKI$(0)
            SendData b$, 219
        CASE EditMenuDelete
            b$ = MKI$(0)
            SendData b$, 220
        CASE EditMenuSelectAll
            b$ = MKI$(0)
            SendData b$, 221
        CASE EditMenuAllowMinMax
            b$ = MKI$(0)
            SendData b$, 223
        CASE EditMenuCP437
            b$ = MKL$(437)
            SendData b$, 34 'Encoding
        CASE EditMenuCP1252
            b$ = MKL$(1252)
            SendData b$, 34 'Encoding
        CASE ViewMenuShowPositionAndSize
            __UI_ShowPositionAndSize = NOT __UI_ShowPositionAndSize
            Control(id).Value = __UI_ShowPositionAndSize
            SaveSettings
        CASE ViewMenuShowInvisibleControls
            __UI_ShowInvisibleControls = NOT __UI_ShowInvisibleControls
            Control(id).Value = __UI_ShowInvisibleControls
            SaveSettings
        CASE FontSwitchMenuSwitch, FontLB, FontListLB
            AttemptToShowFontList = (ShowFontList = FALSE OR BypassShowFontList = TRUE)
            ShowFontList = NOT ShowFontList
            IF id <> FontSwitchMenuSwitch THEN __UI_MouseEnter FontLB
            SaveSettings
            __UI_ForceRedraw = TRUE
        CASE PasteListBT
            DIM Clip$
            Clip$ = _CLIPBOARD$
            Clip$ = Replace$(Clip$, CHR$(13) + CHR$(10), CHR$(10), 0, 0)
            Clip$ = Replace$(Clip$, CHR$(10), "\n", 0, 0)

            IF PreviewControls(FirstSelected).Type = __UI_Type_ListBox OR PreviewControls(FirstSelected).Type = __UI_Type_DropdownList THEN
                Dummy = TextTB
            ELSEIF (PreviewControls(FirstSelected).Type = __UI_Type_Label AND PreviewControls(FirstSelected).WordWrap = TRUE) THEN
                Dummy = CaptionTB
            END IF

            Text(Dummy) = Clip$
            __UI_Focus = Dummy
            Control(Dummy).Cursor = LEN(Text(Dummy))
            Control(Dummy).TextIsSelected = FALSE
        CASE KeyboardComboBT
            __UI_BypassKeyCombos = TRUE
            Caption(KeyboardComboBT) = CHR$(7) + " hit a key combo... (ESC to clear)"
            ToolTip(KeyboardComboBT) = "Press a key combination to assign to the selected control"
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
        CASE FileMenuSaveAs
            Caption(StatusBar) = "Saves a copy of the current project to disk."
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
        CASE EditMenuConvertType
            Caption(StatusBar) = "Converts this control's type into another similar in functionality."
        CASE EditMenuSetDefaultButton
            Caption(StatusBar) = "Makes the currently selected button the default button."
        CASE EditMenuRestoreDimensions
            Caption(StatusBar) = "Makes this control have the same dimensions as the loaded image."
        CASE EditMenuAllowMinMax
            Caption(StatusBar) = "Enables and validates the .Min and .Max properties for NumericTextBox controls."
        CASE EditMenuZOrdering
            Caption(StatusBar) = "Allows you to change tab-order/z-ordering of controls."
        CASE ViewMenuPreviewDetach
            Caption(StatusBar) = "Toggles whether the preview form will be moved with the editor."
        CASE ViewMenuShowPositionAndSize
            Caption(StatusBar) = "Toggles whether size and position indicators will be shown in the preview."
        CASE ViewMenuShowInvisibleControls
            Caption(StatusBar) = "Show or hide invisible controls and binding indicators in the preview dialog."
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
        CASE FontLB, FontListLB
            Control(FontLB).BackColor = Darken(__UI_DefaultColor(__UI_Type_Form, 2), 90)
            Control(FontListLB).BackColor = Darken(__UI_DefaultColor(__UI_Type_Form, 2), 90)
            Caption(FontLB) = "Font (toggle)"
            Caption(FontListLB) = "Font (toggle)"
        CASE ELSE
            IF Control(id).Type = __UI_Type_MenuItem OR Control(id).Type = __UI_Type_MenuBar THEN
                Caption(StatusBar) = ""
            END IF
    END SELECT
END SUB

SUB __UI_MouseLeave (id AS LONG)
    SELECT CASE id
        CASE FontLB, FontListLB
            Control(FontLB).BackColor = __UI_DefaultColor(__UI_Type_Form, 2)
            Control(FontListLB).BackColor = __UI_DefaultColor(__UI_Type_Form, 2)
            Caption(FontLB) = "Font"
            Caption(FontListLB) = "Font"
    END SELECT
END SUB

SUB __UI_FocusIn (id AS LONG)
    SELECT CASE id
        CASE NameTB, CaptionTB, TextTB, MaskTB, TopTB, LeftTB, WidthTB, HeightTB, FontTB, TooltipTB, ValueTB, MinTB, MaxTB, IntervalTB, PaddingTB, MinIntervalTB, SizeTB
            DIM ThisInputBox AS LONG
            ThisInputBox = GetInputBoxFromID(id)
            InputBoxText(ThisInputBox) = Text(id)
            InputBox(ThisInputBox).Sent = FALSE
            Caption(StatusBar) = "Editing property"
        CASE FileNameTextBox
            IF OpenDialogOpen = FALSE THEN __UI_Focus = AddButton
        CASE ControlList
            IF OpenDialogOpen THEN __UI_Focus = FileNameTextBox
        CASE BlueValue
            IF OpenDialogOpen THEN __UI_Focus = CancelBT
        CASE CloseZOrderingBT
            IF ZOrderingDialogOpen = FALSE THEN __UI_Focus = BlueValue
        CASE AddButton
            IF ZOrderingDialogOpen THEN __UI_Focus = ControlList
        CASE CancelBT
            IF ZOrderingDialogOpen THEN __UI_Focus = CloseZOrderingBT
        CASE KeyboardComboBT
            __UI_BypassKeyCombos = TRUE
            Caption(KeyboardComboBT) = CHR$(7) + " hit a key combo... (ESC to clear)"
            ToolTip(KeyboardComboBT) = "Press a key combination to assign to the selected control"
    END SELECT
END SUB

SUB __UI_FocusOut (id AS LONG)
    SELECT CASE id
        CASE NameTB, CaptionTB, TextTB, MaskTB, TopTB, LeftTB, WidthTB, HeightTB, FontTB, TooltipTB, ValueTB, MinTB, MaxTB, IntervalTB, PaddingTB, MinIntervalTB, SizeTB
            ConfirmEdits id
        CASE KeyboardComboBT
            __UI_BypassKeyCombos = FALSE
            Caption(KeyboardComboBT) = "Click to assign"
    END SELECT
END SUB

SUB __UI_MouseDown (id AS LONG)
    SELECT CASE id
        CASE Red, Green, Blue
            Caption(StatusBar) = "Color picker active. Release to apply the new values..."
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
    END SELECT
END SUB

SUB AddToRecentList (FileName$)
    DIM i AS LONG, j AS LONG, b$

    'Check if this FileName$ is already in the list; if so, delete it.
    FOR i = 1 TO 9
        b$ = ReadSetting("InForm/InForm.ini", "Recent Projects", STR$(i))
        IF b$ = FileName$ THEN
            FOR j = i + 1 TO 9
                b$ = ReadSetting("InForm/InForm.ini", "Recent Projects", STR$(j))
                WriteSetting "InForm/InForm.ini", "Recent Projects", STR$(j - 1), b$
            NEXT
            EXIT FOR
        END IF
    NEXT

    'Make room for FileName$ by shifting existing list by one;
    '1 is the most recent, 9 is the oldest;
    FOR i = 8 TO 1 STEP -1
        b$ = ReadSetting("InForm/InForm.ini", "Recent Projects", STR$(i))
        WriteSetting "InForm/InForm.ini", "Recent Projects", STR$(i + 1), b$
    NEXT

    WriteSetting "InForm/InForm.ini", "Recent Projects", "1", FileName$
    RecentListBuilt = FALSE
END SUB

SUB RemoveFromRecentList (FileName$)
    DIM i AS LONG, j AS LONG, b$

    'Check if this FileName$ is already in the list; if so, delete it.
    FOR i = 1 TO 9
        b$ = ReadSetting("InForm/InForm.ini", "Recent Projects", STR$(i))
        IF b$ = FileName$ THEN
            FOR j = i + 1 TO 9
                b$ = ReadSetting("InForm/InForm.ini", "Recent Projects", STR$(j))
                WriteSetting "InForm/InForm.ini", "Recent Projects", STR$(j - 1), b$
            NEXT
            WriteSetting "InForm/InForm.ini", "Recent Projects", "9", ""
            EXIT FOR
        END IF
    NEXT
    RecentListBuilt = FALSE
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
    Control(id).TextIsSelected = TRUE
    Control(id).SelectionStart = 0
    Control(id).Cursor = LEN(Text(id))
END SUB

SUB SelectFontInList (FontSetup$)
    DIM i AS LONG, thisFile$, thisSize%

    IF FontSetup$ = "" THEN EXIT SUB

    thisFile$ = UCASE$(LEFT$(FontSetup$, INSTR(FontSetup$, ",") - 1))
    thisSize% = VAL(MID$(FontSetup$, INSTR(FontSetup$, ",") + 1))

    ResetList FontSizeList
    FOR i = 8 TO 120
        AddItem FontSizeList, LTRIM$(STR$(i))
    NEXT
    i = SelectItem(FontSizeList, LTRIM$(STR$(thisSize%)))

    IF LEN(thisFile$) > 0 THEN
        FOR i = 1 TO UBOUND(FontFile)
            IF UCASE$(RIGHT$(FontFile(i), LEN(thisFile$))) = thisFile$ THEN
                Control(FontList).Value = i
                BypassShowFontList = FALSE
                AttemptToShowFontList = FALSE
                EXIT SUB
            END IF
        NEXT
    ELSE
        IF thisSize% > 8 THEN thisSize% = 16 ELSE thisSize% = 8
        ResetList FontSizeList
        AddItem FontSizeList, "8"
        AddItem FontSizeList, "16"
        i = SelectItem(FontSizeList, LTRIM$(STR$(thisSize%)))
        Control(FontList).Value = 1 'Built-in VGA font
        BypassShowFontList = FALSE
        AttemptToShowFontList = FALSE
        EXIT SUB
    END IF

    'If this line is reached, the currently open form
    'uses a non-system font. In that case we must
    'disable the list.
    BypassShowFontList = TRUE
    IF AttemptToShowFontList THEN
        AttemptToShowFontList = FALSE
        _DELAY 0.2: i = _MESSAGEBOX(UiEditorTitle$, "The current font isn't a system font.\nReset this control to the built-in font?", "yesno", "question", 1)
        IF i = 1 THEN
            thisFile$ = ",16"
            thisFile$ = MKL$(LEN(thisFile$)) + thisFile$
            SendData thisFile$, 8
            BypassShowFontList = FALSE
            ShowFontList = TRUE
        END IF
    END IF
END SUB

SUB LoseFocus
    IF __UI_TotalActiveMenus > 0 THEN __UI_CloseAllMenus
    IF __UI_ActiveDropdownList > 0 THEN __UI_DestroyControl Control(__UI_ActiveDropdownList)
    IF __UI_Focus > 0 THEN __UI_FocusOut __UI_Focus
    __UI_Focus = 0
    __UI_ForceRedraw = TRUE
END SUB

SUB __UI_BeforeUpdateDisplay
    DIM b$
    DIM i AS LONG, j AS LONG, Answer AS _BYTE
    DIM incomingData$, Signal$
    DIM thisData$, thisCommand$
    STATIC OriginalImageWidth AS INTEGER, OriginalImageHeight AS INTEGER
    STATIC PrevFirstSelected AS LONG, PreviewHasMenuActive AS INTEGER
    STATIC ThisControlTurnsInto AS INTEGER
    STATIC LastChange AS SINGLE

    IF TIMER - BlinkStatusBar < 1 THEN
        IF TIMER - LastChange > .2 THEN
            IF Control(StatusBar).BackColor = StatusBarBackColor THEN
                Control(StatusBar).BackColor = _RGB32(222, 194, 127)
            ELSE
                Control(StatusBar).BackColor = StatusBarBackColor
            END IF
            Control(StatusBar).Redraw = TRUE
            LastChange = TIMER
        END IF
    ELSE
        Control(StatusBar).BackColor = StatusBarBackColor
        Control(StatusBar).Redraw = TRUE
    END IF

    IF __UI_BypassKeyCombos THEN
        'Blink KeyCombo button
        IF TIMER - LastChange > .4 THEN
            IF Control(KeyboardComboBT).ForeColor = __UI_DefaultColor(__UI_Type_Button, 1) THEN
                Control(KeyboardComboBT).ForeColor = _RGB32(255, 0, 0)
            ELSE
                Control(KeyboardComboBT).ForeColor = __UI_DefaultColor(__UI_Type_Button, 1)
            END IF
            Control(KeyboardComboBT).Redraw = TRUE
            LastChange = TIMER
        END IF
    ELSE
        Control(KeyboardComboBT).ForeColor = __UI_DefaultColor(__UI_Type_Button, 1)
        Control(KeyboardComboBT).Redraw = TRUE
    END IF

    IF OpenDialogOpen THEN
        IF LEN(RTRIM$(LTRIM$(Text(FileNameTextBox)))) = 0 THEN
            Control(OpenBT).Disabled = TRUE
            Control(SaveBT).Disabled = TRUE
        ELSE
            Control(OpenBT).Disabled = FALSE
            Control(SaveBT).Disabled = FALSE
        END IF
    END IF

    IF RecentListBuilt = FALSE THEN
        'Build list of recent projects
        RecentListBuilt = TRUE
        FOR i = 1 TO 9
            b$ = ReadSetting("InForm/InForm.ini", "Recent Projects", STR$(i))
            IF LEN(b$) THEN
                ToolTip(RecentMenuItem(i)) = b$
                IF INSTR(b$, PathSep$) > 0 THEN
                    FOR j = LEN(b$) TO 1 STEP -1
                        IF MID$(b$, j, 1) = PathSep$ THEN
                            SetCaption RecentMenuItem(i), "&" + LTRIM$(STR$(i)) + " " + MID$(b$, j + 1)
                            EXIT FOR
                        END IF
                    NEXT
                ELSE
                    SetCaption RecentMenuItem(i), "&" + LTRIM$(STR$(i)) + " " + b$
                END IF
                Control(RecentMenuItem(i)).Disabled = FALSE
                Control(RecentMenuItem(i)).Hidden = FALSE
            ELSE
                IF i = 1 THEN
                    SetCaption RecentMenuItem(i), "No recent projects"
                    ToolTip(RecentMenuItem(i)) = ""
                    Control(RecentMenuItem(i)).Disabled = TRUE
                ELSE
                    Control(RecentMenuItem(i)).Hidden = TRUE
                END IF
            END IF
        NEXT
    END IF

    IF __UI_Focus = 0 THEN
        IF Caption(StatusBar) = "" THEN Caption(StatusBar) = "Ready."
    END IF

IF __UI_MouseDownOnID = Red OR __UI_MouseDownOnID = Green OR __UI_MouseDownOnID = Blue OR _
__UI_PreviousMouseDownOnID = Red OR __UI_PreviousMouseDownOnID = Green OR __UI_PreviousMouseDownOnID = Blue THEN

        SELECT CASE __UI_MouseDownOnID + __UI_PreviousMouseDownOnID
            CASE Red
                Text(RedValue) = LTRIM$(STR$(FIX(Control(Red).Value)))
            CASE Green
                Text(GreenValue) = LTRIM$(STR$(FIX(Control(Green).Value)))
            CASE Blue
                Text(BlueValue) = LTRIM$(STR$(FIX(Control(Blue).Value)))
        END SELECT

        'Compose a new color and preview it
        DIM NewColor AS _UNSIGNED LONG
        NewColor = _RGB32(Control(Red).Value, Control(Green).Value, Control(Blue).Value)
        QuickColorPreview NewColor
    END IF

    'Check if another instance was launched and is passing
    'parameters:
    STATIC BringToFront AS _BYTE, InstanceStream$
    IF InstanceClient THEN
        IF BringToFront = FALSE THEN
            $IF WIN THEN
                i = SetForegroundWindow&(_WINDOWHANDLE)
            $END IF
            BringToFront = TRUE
        END IF

        GET #InstanceClient, , incomingData$
        InstanceStream$ = InstanceStream$ + incomingData$

        IF INSTR(InstanceStream$, "<END>") THEN
            IF LEFT$(InstanceStream$, 12) = "NEWINSTANCE>" THEN
                InstanceStream$ = MID$(InstanceStream$, 13)
                InstanceStream$ = LEFT$(InstanceStream$, INSTR(InstanceStream$, "<END>") - 1)
                IF _FILEEXISTS(InstanceStream$) THEN
                    LoadNewInstanceForm:
                    IF INSTR(InstanceStream$, "/") > 0 OR INSTR(InstanceStream$, "\") > 0 THEN
                        FOR i = LEN(InstanceStream$) TO 1 STEP -1
                            IF ASC(InstanceStream$, i) = 92 OR ASC(InstanceStream$, i) = 47 THEN
                                CurrentPath$ = LEFT$(InstanceStream$, i - 1)
                                InstanceStream$ = MID$(InstanceStream$, i + 1)
                                EXIT FOR
                            END IF
                        NEXT
                    END IF

                    IF Edited THEN
                        _DELAY 0.2: Answer = _MESSAGEBOX(UiEditorTitle$, "Save the current form?", "yesnocancel", "question", 1)
                        IF Answer = 0 THEN
                            CLOSE InstanceClient
                            InstanceClient = 0
                            EXIT SUB
                        ELSEIF Answer = 1 THEN
                            SaveForm FALSE, FALSE
                        END IF
                    END IF

                    Text(FileNameTextBox) = InstanceStream$
                    OpenDialogOpen = TRUE
                    __UI_Click OpenBT
                END IF
            END IF
            CLOSE InstanceClient
            InstanceClient = 0
        END IF
    ELSE
        InstanceClient = _OPENCONNECTION(InstanceHost)
        BringToFront = FALSE
        InstanceStream$ = ""
    END IF

    'Check if a form file was dropped onto the Editor for loading
    FOR i = 1 TO _TOTALDROPPEDFILES
        IF _FILEEXISTS(_DROPPEDFILE(i)) THEN
            InstanceStream$ = _DROPPEDFILE(i)
            _FINISHDROP
            GOTO LoadNewInstanceForm
        END IF
    NEXT

    CheckPreview

    GET #Client, , incomingData$
    Stream$ = Stream$ + incomingData$
    'STATIC bytesIn~&&, refreshes~&
    'refreshes~& = refreshes~& + 1
    'bytesIn~&& = bytesIn~&& + LEN(incomingData$)
    'Caption(StatusBar) = "Received:" + STR$(bytesIn~&&) + " bytes | Sent:" + STR$(totalBytesSent) + " bytes"

    $IF WIN THEN
        IF PreviewAttached THEN
            IF prevScreenX <> _SCREENX OR prevScreenY <> _SCREENY THEN
                prevScreenX = _SCREENX
                prevScreenY = _SCREENY
                b$ = "WINDOWPOSITION>" + MKI$(_SCREENX) + MKI$(_SCREENY) + "<END>"
                Send Client, b$
            END IF
        ELSE
            IF prevScreenX <> -32001 OR prevScreenY <> -32001 THEN
                prevScreenX = -32001
                prevScreenY = -32001
                b$ = "WINDOWPOSITION>" + MKI$(-32001) + MKI$(-32001) + "<END>"
                Send Client, b$
            END IF
        END IF
    $ELSE
            IF PreviewAttached = True THEN
            PreviewAttached = False
            SaveSettings
            END IF
            Control(ViewMenuPreviewDetach).Disabled = True
            Control(ViewMenuPreviewDetach).Value = False
    $END IF

    STATIC prevAutoName AS _BYTE, prevMouseSwap AS _BYTE
    STATIC prevShowPos AS _BYTE, prevSnapLines AS _BYTE
    STATIC prevShowInvisible AS _BYTE, SignalsFirstSent AS _BYTE

    IF prevAutoName <> AutoNameControls OR SignalsFirstSent = FALSE THEN
        prevAutoName = AutoNameControls
        b$ = "AUTONAME>" + MKI$(AutoNameControls) + "<END>"
        Send Client, b$
    END IF

    IF prevMouseSwap <> __UI_MouseButtonsSwap OR SignalsFirstSent = FALSE THEN
        prevMouseSwap = __UI_MouseButtonsSwap
        b$ = "MOUSESWAP>" + MKI$(__UI_MouseButtonsSwap) + "<END>"
        Send Client, b$
    END IF

    IF prevShowPos <> __UI_ShowPositionAndSize OR SignalsFirstSent = FALSE THEN
        prevShowPos = __UI_ShowPositionAndSize
        b$ = "SHOWPOSSIZE>" + MKI$(__UI_ShowPositionAndSize) + "<END>"
        Send Client, b$
    END IF

    IF prevShowInvisible <> __UI_ShowInvisibleControls OR SignalsFirstSent = FALSE THEN
        prevShowInvisible = __UI_ShowInvisibleControls
        b$ = "SHOWINVISIBLECONTROLS>" + MKI$(__UI_ShowInvisibleControls) + "<END>"
        Send Client, b$
    END IF

    IF prevSnapLines <> __UI_SnapLines OR SignalsFirstSent = FALSE THEN
        prevSnapLines = __UI_SnapLines
        b$ = "SNAPLINES>" + MKI$(__UI_SnapLines) + "<END>"
        Send Client, b$
    END IF
    SignalsFirstSent = TRUE

    DO WHILE INSTR(Stream$, "<END>") > 0
        thisData$ = LEFT$(Stream$, INSTR(Stream$, "<END>") - 1)
        Stream$ = MID$(Stream$, INSTR(Stream$, "<END>") + 5)
        thisCommand$ = LEFT$(thisData$, INSTR(thisData$, ">") - 1)
        thisData$ = MID$(thisData$, LEN(thisCommand$) + 2)
        SELECT CASE UCASE$(thisCommand$)
            CASE "TOTALSELECTEDCONTROLS"
                TotalSelected = CVL(thisData$)
                IF SetBindingDialogOpen THEN
                    Caption(CancelBindBT) = "Cancel"
                    __UI_Click CancelBindBT
                END IF
            CASE "FORMID"
                PreviewFormID = CVL(thisData$)
            CASE "FIRSTSELECTED"
                FirstSelected = CVL(thisData$)
                IF SetBindingDialogOpen THEN
                    Caption(CancelBindBT) = "Cancel"
                    __UI_Click CancelBindBT
                END IF
            CASE "DEFAULTBUTTONID"
                PreviewDefaultButtonID = CVL(thisData$)
            CASE "SHOWINVISIBLECONTROLS"
                __UI_ShowInvisibleControls = CVI(thisData$)
                Control(ViewMenuShowInvisibleControls).Value = __UI_ShowInvisibleControls
            CASE "CONTROLRENAMED"
                IF LEN(InitialControlSet) THEN
                    DIM insertionPoint AS LONG, endPoint
                    insertionPoint = INSTR(InitialControlSet, CHR$(10) + LEFT$(thisData$, INSTR(thisData$, CHR$(10))))
                    IF insertionPoint THEN
                        endPoint = INSTR(insertionPoint + 1, InitialControlSet, CHR$(10))
                        InitialControlSet = LEFT$(InitialControlSet, endPoint - 1) + CHR$(11) + MID$(thisData$, INSTR(thisData$, CHR$(10)) + 1) + MID$(InitialControlSet, endPoint)
                    ELSE
                        'not found... maybe renamed previously in this session?
                        insertionPoint = INSTR(InitialControlSet, CHR$(11) + LEFT$(thisData$, INSTR(thisData$, CHR$(10)) - 1) + CHR$(10))
                        IF insertionPoint THEN
                            insertionPoint = INSTR(insertionPoint, InitialControlSet, CHR$(11))
                            endPoint = INSTR(insertionPoint + 1, InitialControlSet, CHR$(10))
                            InitialControlSet = LEFT$(InitialControlSet, insertionPoint) + MID$(thisData$, INSTR(thisData$, CHR$(10)) + 1) + MID$(InitialControlSet, endPoint)
                        END IF
                    END IF
                END IF
            CASE "SHOWBINDCONTROLDIALOG"
                __UI_Click EditMenuBindControls
            CASE "ORIGINALIMAGEWIDTH"
                OriginalImageWidth = CVI(thisData$)
            CASE "ORIGINALIMAGEHEIGHT"
                OriginalImageHeight = CVI(thisData$)
            CASE "TURNSINTO"
                ThisControlTurnsInto = CVI(thisData$)
            CASE "SELECTIONRECTANGLE"
                PreviewSelectionRectangle = CVI(thisData$)
                LoseFocus
            CASE "MENUPANELACTIVE"
                PreviewHasMenuActive = CVI(thisData$)
            CASE "SIGNAL"
                Signal$ = Signal$ + thisData$
            CASE "FORMDATA"
                LastFormData$ = thisData$
                LoadPreview
                IF NOT FormDataReceived THEN
                    FormDataReceived = TRUE
                ELSE
                    Edited = TRUE
                    IF __UI_Focus > 0 THEN
                        IF PropertySent THEN PropertySent = FALSE ELSE LoseFocus
                    END IF
                END IF
            CASE "UNDOPOINTER"
                UndoPointer = CVI(thisData$)
            CASE "TOTALUNDOIMAGES"
                TotalUndoImages = CVI(thisData$)
        END SELECT
    LOOP

    IF NOT FormDataReceived THEN EXIT SUB

    IF InitialControlSet = "" THEN
        InitialControlSet = CHR$(1)
        FOR i = 1 TO UBOUND(PreviewControls)
            IF PreviewControls(i).ID > 0 AND PreviewControls(i).Type <> __UI_Type_Font AND PreviewControls(i).Type <> __UI_Type_MenuPanel THEN
                InitialControlSet = InitialControlSet + CHR$(10) + RTRIM$(PreviewControls(i).Name) + CHR$(10)
            END IF
        NEXT
    END IF

    Control(EditMenuRestoreDimensions).Disabled = TRUE
    SetCaption EditMenuRestoreDimensions, "Restore &image dimensions"
    IF TotalSelected = 1 AND PreviewControls(FirstSelected).Type = __UI_Type_PictureBox AND OriginalImageWidth > 0 AND OriginalImageHeight > 0 THEN
IF PreviewControls(FirstSelected).Height - (PreviewControls(FirstSelected).BorderSize * ABS(PreviewControls(FirstSelected).HasBorder)) <> OriginalImageHeight OR _
PreviewControls(FirstSelected).Width - (PreviewControls(FirstSelected).BorderSize * ABS(PreviewControls(FirstSelected).HasBorder)) <> OriginalImageWidth THEN
            Control(EditMenuRestoreDimensions).Disabled = FALSE
            SetCaption EditMenuRestoreDimensions, "Restore &image dimensions (" + LTRIM$(STR$(OriginalImageWidth)) + "x" + LTRIM$(STR$(OriginalImageHeight)) + ")"
        END IF
    END IF

    IF ThisControlTurnsInto > 0 THEN
        Control(EditMenuConvertType).Disabled = FALSE
        SetCaption EditMenuConvertType, "Co&nvert to " + RTRIM$(__UI_Type(ThisControlTurnsInto).Name)
    ELSEIF ThisControlTurnsInto = -1 THEN
        'Offer to turn text to numeric-only TextBox
        Control(EditMenuConvertType).Disabled = FALSE
        SetCaption EditMenuConvertType, "Co&nvert to NumericTextBox"
    ELSEIF ThisControlTurnsInto = -2 THEN
        'Offer to turn numeric-only to text TextBox
        Control(EditMenuConvertType).Disabled = FALSE
        SetCaption EditMenuConvertType, "Co&nvert to TextBox"
    ELSE
        Control(EditMenuConvertType).Disabled = TRUE
        SetCaption EditMenuConvertType, "Co&nvert type"
    END IF

    DO WHILE LEN(Signal$)
        'signals -1 and -3 deprecated for now
        b$ = LEFT$(Signal$, 2)
        Signal$ = MID$(Signal$, 3)
        IF CVI(b$) = -2 THEN
            'User attempted to right-click a control but the preview
            'form is smaller than the menu panel. In such case the "Align"
            'menu is shown in the editor.
            IF ZOrderingDialogOpen THEN __UI_Click CloseZOrderingBT
            __UI_ActivateMenu Control(AlignMenu), FALSE
            __UI_ForceRedraw = TRUE
        ELSEIF CVI(b$) = -4 THEN
            'User attempted to load an icon file that couldn't be previewed
            MessageBox "Icon couldn't be previewed. Make sure it's a valid icon file.", UiEditorTitle$, MsgBox_Exclamation
        ELSEIF CVI(b$) = -5 THEN
            'Context menu was successfully shown on the preview
            IF __UI_TotalActiveMenus > 0 THEN __UI_CloseAllMenus
            __UI_Focus = 0
            __UI_ForceRedraw = TRUE
        ELSEIF CVI(b$) = -6 THEN
            'User attempted to load an invalid icon file
            MessageBox "Only .ico files are accepted.", UiEditorTitle$, MsgBox_Exclamation
        ELSEIF CVI(b$) = -7 THEN
            'A new empty form has just been created or a file has just finished loading from disk
            Edited = FALSE
        ELSEIF CVI(b$) = -9 THEN
            'User attempted to close the preview form
            __UI_Click FileMenuNew
            EXIT SUB
        END IF
    LOOP

    IF PrevFirstSelected <> FirstSelected THEN
        LoseFocus
        PrevFirstSelected = FirstSelected
        __UI_ForceRedraw = TRUE
        IF ZOrderingDialogOpen AND FirstSelected <> PreviewFormID THEN
            FOR j = 1 TO UBOUND(zOrderIDs)
                IF zOrderIDs(j) = FirstSelected THEN Control(ControlList).Value = j: __UI_ValueChanged ControlList: EXIT FOR
            NEXT
        END IF
    END IF

    IF LEN(ThisFileName$) THEN
        Caption(__UI_FormID) = UiEditorTitle$ + " - " + ThisFileName$
    ELSE
        IF LEN(RTRIM$(__UI_TrimAt0$(PreviewControls(PreviewFormID).Name))) > 0 THEN
            Caption(__UI_FormID) = UiEditorTitle$ + " - Untitled.frm"
        END IF
    END IF

    IF Edited THEN
        IF RIGHT$(Caption(__UI_FormID), 1) <> "*" THEN Caption(__UI_FormID) = Caption(__UI_FormID) + "*"
    END IF

    'Ctrl+Z? Ctrl+Y?
    Control(EditMenuUndo).Disabled = TRUE
    Control(EditMenuRedo).Disabled = TRUE
    IF UndoPointer > 0 THEN Control(EditMenuUndo).Disabled = FALSE
    IF UndoPointer < TotalUndoImages THEN Control(EditMenuRedo).Disabled = FALSE

    IF (__UI_KeyHit = ASC("z") OR __UI_KeyHit = ASC("Z")) AND __UI_CtrlIsDown THEN
        SendSignal 214
    ELSEIF (__UI_KeyHit = ASC("y") OR __UI_KeyHit = ASC("Y")) AND __UI_CtrlIsDown THEN
        SendSignal 215
    END IF

    'Make ZOrdering menu enabled/disabled according to control list
    Control(EditMenuZOrdering).Disabled = TRUE
    FOR i = 1 TO UBOUND(PreviewControls)
        SELECT CASE PreviewControls(i).Type
            CASE 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 14, 15, 18
                j = j + 1
                IF j > 1 THEN
                    Control(EditMenuZOrdering).Disabled = FALSE
                    EXIT FOR
                END IF
        END SELECT
    NEXT

    Control(EditMenuCP1252).Value = FALSE
    Control(EditMenuCP437).Value = FALSE
    Control(FontSwitchMenuSwitch).Value = ShowFontList
    IF BypassShowFontList THEN
        Control(FontSwitchMenuSwitch).Disabled = TRUE
    ELSE
        Control(FontSwitchMenuSwitch).Disabled = FALSE
    END IF
    SELECT CASE PreviewControls(PreviewFormID).Encoding
        CASE 0, 437
            Control(EditMenuCP437).Value = TRUE
        CASE 1252
            Control(EditMenuCP1252).Value = TRUE
    END SELECT

    IF PreviewHasMenuActive THEN
        Control(InsertMenuMenuItem).Disabled = FALSE
    ELSE
        Control(InsertMenuMenuItem).Disabled = TRUE
    END IF

    Control(EditMenuSetDefaultButton).Disabled = TRUE
    Control(EditMenuSetDefaultButton).Value = FALSE
    Control(EditMenuBindControls).Disabled = TRUE
    Control(EditMenuAllowMinMax).Disabled = TRUE
    Control(EditMenuAllowMinMax).Value = FALSE
    IF INSTR(LCASE$(PreviewControls(PreviewFormID).Name), "form") = 0 THEN
        Caption(ControlProperties) = "Control properties (Form):"
    ELSE
        Caption(ControlProperties) = "Control properties:"
    END IF
    Caption(AlignMenuAlignCenterV) = "Center Vertically (group)"
    Caption(AlignMenuAlignCenterH) = "Center Horizontally (group)-"

    Control(EditMenuPaste).Disabled = TRUE
    IF LEFT$(_CLIPBOARD$, LEN(__UI_ClipboardCheck$)) = __UI_ClipboardCheck$ THEN
        Control(EditMenuPaste).Disabled = FALSE
    END IF

    IF TotalSelected = 0 THEN
        FirstSelected = PreviewFormID

        Control(EditMenuCut).Disabled = TRUE
        Control(EditMenuCopy).Disabled = TRUE
        Control(EditMenuDelete).Disabled = TRUE

        Control(AlignMenuAlignLeft).Disabled = TRUE
        Control(AlignMenuAlignRight).Disabled = TRUE
        Control(AlignMenuAlignTops).Disabled = TRUE
        Control(AlignMenuAlignBottoms).Disabled = TRUE
        Control(AlignMenuAlignCenterV).Disabled = TRUE
        Control(AlignMenuAlignCenterH).Disabled = TRUE
        Control(AlignMenuAlignCentersV).Disabled = TRUE
        Control(AlignMenuAlignCentersH).Disabled = TRUE
        Control(AlignMenuDistributeV).Disabled = TRUE
        Control(AlignMenuDistributeH).Disabled = TRUE

    ELSEIF TotalSelected = 1 THEN
        IF FirstSelected > 0 AND FirstSelected <= UBOUND(PreviewControls) THEN
            Control(EditMenuCut).Disabled = FALSE
            Control(EditMenuCopy).Disabled = FALSE
            Control(EditMenuDelete).Disabled = FALSE

            IF INSTR(LCASE$(PreviewControls(FirstSelected).Name), LCASE$(RTRIM$(__UI_Type(PreviewControls(FirstSelected).Type).Name))) = 0 THEN
                Caption(ControlProperties) = "Control properties (Type = " + RTRIM$(__UI_Type(PreviewControls(FirstSelected).Type).Name) + "):"
            ELSE
                Caption(ControlProperties) = "Control properties:"
            END IF
            Control(AlignMenuAlignLeft).Disabled = TRUE
            Control(AlignMenuAlignRight).Disabled = TRUE
            Control(AlignMenuAlignTops).Disabled = TRUE
            Control(AlignMenuAlignBottoms).Disabled = TRUE
            IF PreviewControls(FirstSelected).Type <> __UI_Type_MenuBar AND PreviewControls(FirstSelected).Type <> __UI_Type_MenuItem THEN
                Control(AlignMenuAlignCenterV).Disabled = FALSE
                Control(AlignMenuAlignCenterH).Disabled = FALSE
                Caption(AlignMenuAlignCenterV) = "Center Vertically"
                Caption(AlignMenuAlignCenterH) = "Center Horizontally-"
            ELSE
                Control(AlignMenuAlignCenterV).Disabled = TRUE
                Control(AlignMenuAlignCenterH).Disabled = TRUE
            END IF
            Control(AlignMenuAlignCentersV).Disabled = TRUE
            Control(AlignMenuAlignCentersH).Disabled = TRUE
            Control(AlignMenuDistributeV).Disabled = TRUE
            Control(AlignMenuDistributeH).Disabled = TRUE

            IF PreviewControls(FirstSelected).Type = __UI_Type_Button THEN
                Control(EditMenuSetDefaultButton).Disabled = FALSE
                IF PreviewDefaultButtonID <> FirstSelected THEN
                    Control(EditMenuSetDefaultButton).Value = FALSE
                ELSE
                    Control(EditMenuSetDefaultButton).Value = TRUE
                END IF
            ELSEIF PreviewControls(FirstSelected).Type = __UI_Type_TextBox THEN
                IF PreviewControls(FirstSelected).NumericOnly = TRUE THEN
                    Control(EditMenuAllowMinMax).Disabled = FALSE
                    Control(EditMenuAllowMinMax).Value = FALSE
                    IF INSTR(PreviewControls(FirstSelected).Name, "NumericTextBox") = 0 THEN Caption(ControlProperties) = "Control properties (Type = NumericTextBox):"
                ELSEIF PreviewControls(FirstSelected).NumericOnly = __UI_NumericWithBounds THEN
                    Control(EditMenuAllowMinMax).Disabled = FALSE
                    Control(EditMenuAllowMinMax).Value = TRUE
                    IF INSTR(PreviewControls(FirstSelected).Name, "NumericTextBox") = 0 THEN Caption(ControlProperties) = "Control properties (Type = NumericTextBox):"
                END IF
            END IF
        END IF
    ELSEIF TotalSelected = 2 THEN
        Control(EditMenuBindControls).Disabled = FALSE

        Caption(ControlProperties) = "Control properties: (multiple selection)"

        Control(EditMenuCut).Disabled = FALSE
        Control(EditMenuCopy).Disabled = FALSE
        Control(EditMenuDelete).Disabled = FALSE

        Control(AlignMenuAlignLeft).Disabled = FALSE
        Control(AlignMenuAlignRight).Disabled = FALSE
        Control(AlignMenuAlignTops).Disabled = FALSE
        Control(AlignMenuAlignBottoms).Disabled = FALSE
        Control(AlignMenuAlignCenterV).Disabled = FALSE
        Control(AlignMenuAlignCenterH).Disabled = FALSE
        Control(AlignMenuAlignCentersV).Disabled = FALSE
        Control(AlignMenuAlignCentersH).Disabled = FALSE
        Control(AlignMenuDistributeV).Disabled = TRUE
        Control(AlignMenuDistributeH).Disabled = TRUE
    ELSE
        SetCaption ControlProperties, "Control properties: (multiple selection)"

        Control(EditMenuCut).Disabled = FALSE
        Control(EditMenuCopy).Disabled = FALSE
        Control(EditMenuDelete).Disabled = FALSE

        Control(AlignMenuAlignLeft).Disabled = FALSE
        Control(AlignMenuAlignRight).Disabled = FALSE
        Control(AlignMenuAlignTops).Disabled = FALSE
        Control(AlignMenuAlignBottoms).Disabled = FALSE
        Control(AlignMenuAlignCenterV).Disabled = FALSE
        Control(AlignMenuAlignCenterH).Disabled = FALSE
        Control(AlignMenuAlignCentersV).Disabled = FALSE
        Control(AlignMenuAlignCentersH).Disabled = FALSE
        Control(AlignMenuDistributeV).Disabled = FALSE
        Control(AlignMenuDistributeH).Disabled = FALSE
    END IF

    IF FirstSelected = 0 THEN FirstSelected = PreviewFormID

    FOR i = 1 TO UBOUND(InputBox)
        Control(InputBox(i).ID).Disabled = FALSE
        Control(InputBox(i).ID).Hidden = FALSE
        Control(InputBox(i).LabelID).Hidden = FALSE
        IF __UI_Focus = InputBox(i).ID THEN
            Control(InputBox(i).ID).Height = 22
            Control(InputBox(i).ID).BorderColor = _RGB32(0, 0, 0)
            Control(InputBox(i).ID).BorderSize = 2
        ELSE
            Control(InputBox(i).ID).Height = 23
            Control(InputBox(i).ID).BorderColor = __UI_DefaultColor(__UI_Type_TextBox, 5)
            Control(InputBox(i).ID).BorderSize = 1
        END IF
    NEXT
    Control(FontSizeList).Hidden = TRUE

    FOR i = 1 TO UBOUND(Toggles)
        Control(Toggles(i)).Disabled = TRUE
        Control(Toggles(i)).Hidden = FALSE
    NEXT

    DIM ShadeOfGreen AS _UNSIGNED LONG, ShadeOfRed AS _UNSIGNED LONG
    ShadeOfGreen = _RGB32(28, 150, 50)
    ShadeOfRed = _RGB32(233, 44, 0)

    CONST PropertyUpdateDelay = .1

    IF FirstSelected > 0 THEN
        DIM ThisInputBox AS LONG
        ThisInputBox = GetInputBoxFromID(__UI_Focus)

        IF __UI_Focus <> NameTB OR (__UI_Focus = NameTB AND RevertEdit = TRUE) THEN
            Text(NameTB) = RTRIM$(PreviewControls(FirstSelected).Name)
            IF (__UI_Focus = NameTB AND RevertEdit = TRUE) THEN RevertEdit = FALSE: SelectPropertyFully __UI_Focus
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
        IF __UI_Focus <> CaptionTB OR (__UI_Focus = CaptionTB AND RevertEdit = TRUE) THEN
            Text(CaptionTB) = Replace(__UI_TrimAt0$(PreviewCaptions(FirstSelected)), CHR$(10), "\n", FALSE, 0)
            IF (__UI_Focus = CaptionTB AND RevertEdit = TRUE) THEN RevertEdit = FALSE: SelectPropertyFully __UI_Focus
        ELSEIF __UI_Focus = CaptionTB THEN
            IF PropertyFullySelected(CaptionTB) THEN
                IF Text(CaptionTB) = Replace(__UI_TrimAt0$(PreviewCaptions(FirstSelected)), CHR$(10), "\n", FALSE, 0) THEN
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
        IF __UI_Focus <> TextTB OR (__UI_Focus = TextTB AND RevertEdit = TRUE) THEN
            IF PreviewControls(FirstSelected).Type = __UI_Type_ListBox OR PreviewControls(FirstSelected).Type = __UI_Type_DropdownList THEN
                Text(TextTB) = Replace(PreviewTexts(FirstSelected), CHR$(10), "\n", FALSE, 0)
            ELSE
                Text(TextTB) = PreviewTexts(FirstSelected)
                IF LEN(PreviewMasks(FirstSelected)) > 0 AND PreviewControls(FirstSelected).Type = __UI_Type_TextBox THEN
                    Mask(TextTB) = PreviewMasks(FirstSelected)
                ELSE
                    Mask(TextTB) = ""
                END IF
            END IF
            IF (__UI_Focus = TextTB AND RevertEdit = TRUE) THEN RevertEdit = FALSE: SelectPropertyFully __UI_Focus
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
        IF __UI_Focus <> MaskTB OR (__UI_Focus = MaskTB AND RevertEdit = TRUE) THEN
            Text(MaskTB) = PreviewMasks(FirstSelected)
            IF (__UI_Focus = MaskTB AND RevertEdit = TRUE) THEN RevertEdit = FALSE: SelectPropertyFully __UI_Focus
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
        IF __UI_Focus <> TopTB OR (__UI_Focus = TopTB AND RevertEdit = TRUE) THEN
            Text(TopTB) = LTRIM$(STR$(PreviewControls(FirstSelected).Top))
            IF (__UI_Focus = TopTB AND RevertEdit = TRUE) THEN RevertEdit = FALSE: SelectPropertyFully __UI_Focus
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
        IF __UI_Focus <> LeftTB OR (__UI_Focus = LeftTB AND RevertEdit = TRUE) THEN
            Text(LeftTB) = LTRIM$(STR$(PreviewControls(FirstSelected).Left))
            IF (__UI_Focus = LeftTB AND RevertEdit = TRUE) THEN RevertEdit = FALSE: SelectPropertyFully __UI_Focus
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
        IF __UI_Focus <> WidthTB OR (__UI_Focus = WidthTB AND RevertEdit = TRUE) THEN
            Text(WidthTB) = LTRIM$(STR$(PreviewControls(FirstSelected).Width))
            IF (__UI_Focus = WidthTB AND RevertEdit = TRUE) THEN RevertEdit = FALSE: SelectPropertyFully __UI_Focus
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
        IF __UI_Focus <> HeightTB OR (__UI_Focus = HeightTB AND RevertEdit = TRUE) THEN
            Text(HeightTB) = LTRIM$(STR$(PreviewControls(FirstSelected).Height))
            IF (__UI_Focus = HeightTB AND RevertEdit = TRUE) THEN RevertEdit = FALSE: SelectPropertyFully __UI_Focus
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
        IF __UI_Focus <> FontTB OR (__UI_Focus = FontTB AND RevertEdit = TRUE) THEN
            IF LEN(PreviewFonts(FirstSelected)) > 0 THEN
                Text(FontTB) = PreviewFonts(FirstSelected)
            ELSE
                Text(FontTB) = PreviewFonts(PreviewFormID)
            END IF
            IF (__UI_Focus = FontTB AND RevertEdit = TRUE) THEN RevertEdit = FALSE: SelectPropertyFully __UI_Focus
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
        IF LEN(PreviewFonts(FirstSelected)) > 0 THEN
            SelectFontInList PreviewActualFonts(FirstSelected)
        ELSE
            SelectFontInList PreviewActualFonts(PreviewFormID)
        END IF
        IF __UI_Focus <> TooltipTB OR (__UI_Focus = TooltipTB AND RevertEdit = TRUE) THEN
            Text(TooltipTB) = Replace(PreviewTips(FirstSelected), CHR$(10), "\n", FALSE, 0)
            IF (__UI_Focus = TooltipTB AND RevertEdit = TRUE) THEN RevertEdit = FALSE: SelectPropertyFully __UI_Focus
        ELSEIF __UI_Focus = TooltipTB THEN
            IF PropertyFullySelected(FontTB) THEN
                IF Text(TooltipTB) = Replace(PreviewTips(FirstSelected), CHR$(10), "\n", FALSE, 0) THEN
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
        IF __UI_Focus <> ValueTB OR (__UI_Focus = ValueTB AND RevertEdit = TRUE) THEN
            Text(ValueTB) = LTRIM$(STR$(PreviewControls(FirstSelected).Value))
            IF (__UI_Focus = ValueTB AND RevertEdit = TRUE) THEN RevertEdit = FALSE: SelectPropertyFully __UI_Focus
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
        IF __UI_Focus <> MinTB OR (__UI_Focus = MinTB AND RevertEdit = TRUE) THEN
            Text(MinTB) = LTRIM$(STR$(PreviewControls(FirstSelected).Min))
            IF (__UI_Focus = MinTB AND RevertEdit = TRUE) THEN RevertEdit = FALSE: SelectPropertyFully __UI_Focus
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
        IF __UI_Focus <> MaxTB OR (__UI_Focus = MaxTB AND RevertEdit = TRUE) THEN
            Text(MaxTB) = LTRIM$(STR$(PreviewControls(FirstSelected).Max))
            IF (__UI_Focus = MaxTB AND RevertEdit = TRUE) THEN RevertEdit = FALSE: SelectPropertyFully __UI_Focus
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
        IF __UI_Focus <> IntervalTB OR (__UI_Focus = IntervalTB AND RevertEdit = TRUE) THEN
            Text(IntervalTB) = LTRIM$(STR$(PreviewControls(FirstSelected).Interval))
            IF (__UI_Focus = IntervalTB AND RevertEdit = TRUE) THEN RevertEdit = FALSE: SelectPropertyFully __UI_Focus
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
        IF __UI_Focus <> MinIntervalTB OR (__UI_Focus = MinIntervalTB AND RevertEdit = TRUE) THEN
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
        IF __UI_Focus <> PaddingTB OR (__UI_Focus = PaddingTB AND RevertEdit = TRUE) THEN
            Text(PaddingTB) = LTRIM$(STR$(PreviewControls(FirstSelected).Padding))
            IF (__UI_Focus = PaddingTB AND RevertEdit = TRUE) THEN RevertEdit = FALSE: SelectPropertyFully __UI_Focus
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
        IF __UI_Focus <> SizeTB OR (__UI_Focus = SizeTB AND RevertEdit = TRUE) THEN
            Text(SizeTB) = LTRIM$(STR$(PreviewControls(FirstSelected).BorderSize))
            IF (__UI_Focus = SizeTB AND RevertEdit = TRUE) THEN RevertEdit = FALSE: SelectPropertyFully __UI_Focus
        ELSEIF __UI_Focus = SizeTB THEN
            IF PropertyFullySelected(SizeTB) THEN
                IF Text(SizeTB) = LTRIM$(STR$(PreviewControls(FirstSelected).BorderSize)) THEN
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
    Caption(HasBorder) = "Has border"
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
    Control(AutoScroll).Value = PreviewControls(FirstSelected).AutoScroll
    Control(AutoSize).Value = PreviewControls(FirstSelected).AutoSize
    Control(HideTicks).Value = (PreviewControls(FirstSelected).Height = __UI_Type(__UI_Type_TrackBar).MinimumHeight)
    Control(AutoPlayGif).Value = PreviewAutoPlayGif(FirstSelected)

    IF LEN(PreviewContextMenu(FirstSelected)) THEN
        DIM ItemFound AS _BYTE
        ItemFound = SelectItem(ContextMenuControlsList, PreviewContextMenu(FirstSelected))
    ELSE
        Control(ContextMenuControlsList).Value = 1
    END IF
    IF __UI_BypassKeyCombos = FALSE THEN
        IF TotalSelected = 1 AND LEN(PreviewKeyCombos(FirstSelected)) THEN
            Caption(KeyboardComboBT) = PreviewKeyCombos(FirstSelected)
        ELSE
            Caption(KeyboardComboBT) = "Click to assign"
        END IF
    END IF

    STATIC ShowInvalidValueWarning AS _BYTE
    IF Control(__UI_Focus).BorderColor = ShadeOfRed THEN
        IF ShowInvalidValueWarning = FALSE THEN
            ShowInvalidValueWarning = TRUE
            Caption(StatusBar) = "Invalid value; ESC for previous or adjusted value"
            BlinkStatusBar = TIMER
        END IF
    ELSE
        ShowInvalidValueWarning = FALSE
    END IF

    'Disable properties that don't apply
    Control(AlignOptions).Disabled = TRUE
    Control(BooleanOptions).Disabled = TRUE
    Control(VAlignOptions).Disabled = TRUE
    Control(BulletOptions).Disabled = TRUE
    Caption(TextLB) = "Text"
    Caption(ValueLB) = "Value"
    Caption(MaxLB) = "Max"
    Control(SizeTB).Disabled = TRUE
    Control(SizeTB).Hidden = TRUE
    IF TotalSelected > 0 THEN
        SELECT EVERYCASE PreviewControls(FirstSelected).Type
            CASE __UI_Type_ToggleSwitch
                Control(CanHaveFocus).Disabled = FALSE
                Control(Disabled).Disabled = FALSE
                Control(Hidden).Disabled = FALSE
                Control(CaptionTB).Disabled = TRUE
                Control(BooleanOptions).Disabled = FALSE
                Control(TextTB).Disabled = TRUE
                Control(FontTB).Disabled = TRUE
                Control(FontList).Disabled = TRUE
                Control(MinTB).Disabled = TRUE
                Control(MaxTB).Disabled = TRUE
                Control(IntervalTB).Disabled = TRUE
                Control(MinIntervalTB).Disabled = TRUE
                Control(PaddingTB).Disabled = TRUE
                Control(BulletOptions).Disabled = TRUE
            CASE __UI_Type_MenuBar, __UI_Type_MenuItem
                Control(Disabled).Disabled = FALSE
                Control(Hidden).Disabled = FALSE
            CASE __UI_Type_MenuBar
                'Check if this is the last menu bar item so that Align options can be enabled
                FOR i = UBOUND(PreviewControls) TO 1 STEP -1
                    IF PreviewControls(i).ID > 0 AND PreviewControls(i).Type = __UI_Type_MenuBar THEN
                        EXIT FOR
                    END IF
                NEXT
                IF i = FirstSelected THEN
                    Control(AlignOptions).Disabled = FALSE
                END IF

                FOR i = 1 TO UBOUND(InputBox)
                    SELECT CASE InputBox(i).ID
                        CASE NameTB, CaptionTB, TooltipTB, AlignOptions
                            Control(InputBox(i).ID).Disabled = FALSE
                        CASE ELSE
                            Control(InputBox(i).ID).Disabled = TRUE
                    END SELECT
                NEXT
            CASE __UI_Type_ContextMenu
                FOR i = 1 TO UBOUND(InputBox)
                    SELECT CASE InputBox(i).ID
                        CASE NameTB
                            Control(InputBox(i).ID).Disabled = FALSE
                        CASE ELSE
                            Control(InputBox(i).ID).Disabled = TRUE
                    END SELECT
                NEXT
            CASE __UI_Type_MenuItem
                FOR i = 1 TO UBOUND(InputBox)
                    SELECT CASE InputBox(i).ID
                        CASE NameTB, CaptionTB, TextTB, TooltipTB, BulletOptions, BooleanOptions, KeyboardComboBT
                            Control(InputBox(i).ID).Disabled = FALSE
                        CASE ELSE
                            Control(InputBox(i).ID).Disabled = TRUE
                    END SELECT
                NEXT
            CASE __UI_Type_PictureBox
                Caption(TextLB) = "Image file"
                Control(AlignOptions).Disabled = FALSE
                Control(VAlignOptions).Disabled = FALSE
                Control(Stretch).Disabled = FALSE
                Control(Transparent).Disabled = FALSE
                IF PreviewAnimatedGif(FirstSelected) THEN
                    Control(AutoPlayGif).Disabled = FALSE
                END IF
                FOR i = 1 TO UBOUND(InputBox)
                    SELECT CASE InputBox(i).ID
                        CASE NameTB, TextTB, TopTB, LeftTB, WidthTB, HeightTB, TooltipTB, AlignOptions, VAlignOptions
                            Control(InputBox(i).ID).Disabled = FALSE
                        CASE ELSE
                            Control(InputBox(i).ID).Disabled = TRUE
                    END SELECT
                NEXT
            CASE __UI_Type_Label
                Control(Transparent).Disabled = FALSE
                Control(AutoSize).Disabled = FALSE
                FOR i = 1 TO UBOUND(InputBox)
                    SELECT CASE InputBox(i).ID
                        CASE NameTB, CaptionTB, TopTB, LeftTB, WidthTB, HeightTB, FontTB, TooltipTB, PaddingTB, AlignOptions, VAlignOptions, FontList
                            Control(InputBox(i).ID).Disabled = FALSE
                        CASE ELSE
                            Control(InputBox(i).ID).Disabled = TRUE
                    END SELECT
                NEXT
            CASE __UI_Type_Frame
                Control(Transparent).Disabled = TRUE
                FOR i = 1 TO UBOUND(InputBox)
                    SELECT CASE InputBox(i).ID
                        CASE NameTB, CaptionTB, TopTB, LeftTB, WidthTB, HeightTB, FontTB, TooltipTB, FontList
                            Control(InputBox(i).ID).Disabled = FALSE
                        CASE ELSE
                            Control(InputBox(i).ID).Disabled = TRUE
                    END SELECT
                NEXT
            CASE __UI_Type_TextBox
                STATIC PreviousNumericState AS _BYTE
                Control(Transparent).Disabled = FALSE
                Control(PasswordMaskCB).Disabled = (PreviewControls(FirstSelected).NumericOnly <> FALSE)
                IF PreviousNumericState <> PreviewControls(FirstSelected).NumericOnly THEN
                    PreviousNumericState = PreviewControls(FirstSelected).NumericOnly
                    __UI_ForceRedraw = TRUE
                END IF
                IF PreviewControls(FirstSelected).NumericOnly = TRUE THEN
                    FOR i = 1 TO UBOUND(InputBox)
                        SELECT CASE InputBox(i).ID
                            CASE ValueTB, MinTB, MaxTB, MaskTB, IntervalTB, PaddingTB, AlignOptions, VAlignOptions, MinIntervalTB, BulletOptions, BooleanOptions, KeyboardComboBT
                                Control(InputBox(i).ID).Disabled = TRUE
                            CASE ELSE
                                Control(InputBox(i).ID).Disabled = FALSE
                        END SELECT
                    NEXT
                ELSEIF PreviewControls(FirstSelected).NumericOnly = __UI_NumericWithBounds THEN
                    FOR i = 1 TO UBOUND(InputBox)
                        SELECT CASE InputBox(i).ID
                            CASE ValueTB, MaskTB, IntervalTB, PaddingTB, AlignOptions, VAlignOptions, MinIntervalTB, BulletOptions, BooleanOptions, KeyboardComboBT
                                Control(InputBox(i).ID).Disabled = TRUE
                            CASE ELSE
                                Control(InputBox(i).ID).Disabled = FALSE
                        END SELECT
                    NEXT
                ELSE
                    Caption(MaxLB) = "Max length"
                    FOR i = 1 TO UBOUND(InputBox)
                        SELECT CASE InputBox(i).ID
                            CASE ValueTB, MinTB, IntervalTB, PaddingTB, AlignOptions, VAlignOptions, MinIntervalTB, BulletOptions, BooleanOptions, KeyboardComboBT
                                Control(InputBox(i).ID).Disabled = TRUE
                            CASE ELSE
                                Control(InputBox(i).ID).Disabled = FALSE
                        END SELECT
                    NEXT
                END IF
            CASE __UI_Type_Button, __UI_Type_MenuItem
                Caption(TextLB) = "Image file"
            CASE __UI_Type_Button
                FOR i = 1 TO UBOUND(InputBox)
                    SELECT CASE InputBox(i).ID
                        CASE ValueTB, MinTB, MaxTB, IntervalTB, PaddingTB, MaskTB, AlignOptions, VAlignOptions, MinIntervalTB, BulletOptions, BooleanOptions
                            Control(InputBox(i).ID).Disabled = TRUE
                        CASE ELSE
                            Control(InputBox(i).ID).Disabled = FALSE
                    END SELECT
                NEXT
            CASE __UI_Type_CheckBox, __UI_Type_RadioButton
                Control(Transparent).Disabled = FALSE
                FOR i = 1 TO UBOUND(InputBox)
                    SELECT CASE InputBox(i).ID
                        CASE TextTB, MinTB, MaxTB, IntervalTB, PaddingTB, MaskTB, AlignOptions, VAlignOptions, MinIntervalTB, BulletOptions, ValueTB
                            Control(InputBox(i).ID).Disabled = TRUE
                        CASE ELSE
                            Control(InputBox(i).ID).Disabled = FALSE
                    END SELECT
                NEXT
            CASE __UI_Type_ToggleSwitch
                Control(Transparent).Disabled = TRUE
                FOR i = 1 TO UBOUND(InputBox)
                    SELECT CASE InputBox(i).ID
                        CASE WidthTB, HeightTB, TextTB, MinTB, MaxTB, IntervalTB, PaddingTB, MaskTB, AlignOptions, VAlignOptions, MinIntervalTB, BulletOptions, ValueTB, FontTB, FontList
                            Control(InputBox(i).ID).Disabled = TRUE
                        CASE ELSE
                            Control(InputBox(i).ID).Disabled = FALSE
                    END SELECT
                NEXT
            CASE __UI_Type_ProgressBar
                FOR i = 1 TO UBOUND(InputBox)
                    SELECT CASE InputBox(i).ID
                        CASE TextTB, IntervalTB, PaddingTB, MaskTB, AlignOptions, VAlignOptions, MinIntervalTB, BulletOptions, BooleanOptions, KeyboardComboBT
                            Control(InputBox(i).ID).Disabled = TRUE
                        CASE ELSE
                            Control(InputBox(i).ID).Disabled = FALSE
                    END SELECT
                NEXT
            CASE __UI_Type_TrackBar
                Control(HideTicks).Disabled = FALSE
                FOR i = 1 TO UBOUND(InputBox)
                    SELECT CASE InputBox(i).ID
                        CASE CaptionTB, TextTB, FontTB, PaddingTB, MaskTB, AlignOptions, VAlignOptions, BulletOptions, BooleanOptions, FontList, KeyboardComboBT
                            Control(InputBox(i).ID).Disabled = TRUE
                        CASE ELSE
                            Control(InputBox(i).ID).Disabled = FALSE
                    END SELECT
                NEXT
            CASE __UI_Type_ListBox, __UI_Type_DropdownList
                Caption(TextLB) = "List items"
                Caption(ValueLB) = "Selected item"
                Control(Transparent).Disabled = FALSE
                FOR i = 1 TO UBOUND(InputBox)
                    SELECT CASE InputBox(i).ID
                        CASE CaptionTB, MinTB, MaxTB, IntervalTB, PaddingTB, MaskTB, AlignOptions, VAlignOptions, MinIntervalTB, BulletOptions, BooleanOptions, KeyboardComboBT
                            Control(InputBox(i).ID).Disabled = TRUE
                        CASE ELSE
                            Control(InputBox(i).ID).Disabled = FALSE
                    END SELECT
                NEXT
            CASE __UI_Type_ListBox
                Control(AutoScroll).Disabled = FALSE
            CASE __UI_Type_Frame, __UI_Type_Label, __UI_Type_TextBox, __UI_Type_ListBox, __UI_Type_DropdownList, __UI_Type_PictureBox
                Control(HasBorder).Disabled = FALSE
            CASE __UI_Type_ProgressBar
                Control(ShowPercentage).Disabled = FALSE
            CASE __UI_Type_Label
                Control(WordWrap).Disabled = FALSE
            CASE __UI_Type_Button, __UI_Type_CheckBox, __UI_Type_RadioButton, __UI_Type_TextBox, __UI_Type_ListBox, __UI_Type_DropdownList, __UI_Type_TrackBar
                Control(CanHaveFocus).Disabled = FALSE
            CASE __UI_Type_Button, __UI_Type_CheckBox, __UI_Type_RadioButton, __UI_Type_TextBox, __UI_Type_ListBox, __UI_Type_DropdownList, __UI_Type_TrackBar, __UI_Type_Label, __UI_Type_ProgressBar
                Control(Disabled).Disabled = FALSE
            CASE __UI_Type_Frame, __UI_Type_Button, __UI_Type_CheckBox, __UI_Type_RadioButton, __UI_Type_TextBox, __UI_Type_ListBox, __UI_Type_DropdownList, __UI_Type_TrackBar, __UI_Type_Label, __UI_Type_ProgressBar, __UI_Type_PictureBox
                Control(Hidden).Disabled = FALSE
            CASE __UI_Type_Label
                Control(AlignOptions).Disabled = FALSE
                Control(VAlignOptions).Disabled = FALSE
        END SELECT
    ELSE
        'Properties relative to the form
        Control(CenteredWindow).Disabled = FALSE
        Control(Resizable).Disabled = FALSE
        Control(AddGifExtensionToggle).Disabled = FALSE
        Caption(TextLB) = "Icon file"

        FOR i = 1 TO UBOUND(InputBox)
            SELECT CASE InputBox(i).ID
                CASE NameTB, CaptionTB, TextTB, WidthTB, HeightTB, FontTB, FontList
                    Control(InputBox(i).ID).Disabled = FALSE
                CASE ELSE
                    Control(InputBox(i).ID).Disabled = TRUE
            END SELECT
        NEXT
    END IF

    IF TotalSelected > 1 THEN Control(NameTB).Disabled = TRUE

    IF HasFontList AND (ShowFontList = TRUE AND BypassShowFontList = FALSE) THEN
        Control(FontTB).Disabled = TRUE
    ELSE
        Control(FontList).Disabled = TRUE
    END IF

IF PreviewControls(FirstSelected).Type = __UI_Type_ContextMenu OR _
PreviewControls(FirstSelected).Type = __UI_Type_MenuBar OR _
PreviewControls(FirstSelected).Type = __UI_Type_MenuItem THEN
        Control(ContextMenuControlsList).Disabled = TRUE
    ELSE
        Control(ContextMenuControlsList).Disabled = FALSE
    END IF

    DIM LastTopForInputBox AS INTEGER
    LastTopForInputBox = -12
    CONST TopIncrementForInputBox = 22
    FOR i = 1 TO UBOUND(InputBox)
        'Exception for SizeTB:
        IF InputBox(i).ID = SizeTB THEN _CONTINUE

        IF Control(InputBox(i).ID).Disabled THEN
            Control(InputBox(i).ID).Hidden = TRUE
            Control(InputBox(i).LabelID).Hidden = TRUE
        ELSE
            LastTopForInputBox = LastTopForInputBox + TopIncrementForInputBox
            Control(InputBox(i).ID).Top = LastTopForInputBox
            Control(InputBox(i).LabelID).Top = LastTopForInputBox
        END IF
    NEXT

    LastTopForInputBox = -12
    FOR i = 1 TO UBOUND(Toggles)
        IF Control(Toggles(i)).Disabled THEN
            Control(Toggles(i)).Hidden = TRUE
        ELSE
            LastTopForInputBox = LastTopForInputBox + TopIncrementForInputBox
            Control(Toggles(i)).Top = LastTopForInputBox
        END IF
    NEXT

    'Custom cases
    Control(AutoPlayGif).Disabled = NOT Control(AddGifExtensionToggle).Value
    Control(AutoSize).Disabled = Control(WordWrap).Value
    IF Control(HasBorder).Value = TRUE AND PreviewControls(FirstSelected).Type <> __UI_Type_Frame THEN
        Control(SizeTB).Disabled = FALSE
        Control(SizeTB).Hidden = FALSE
        Control(SizeTB).Height = 22
        Control(SizeTB).Top = Control(HasBorder).Top
        Caption(HasBorder) = "Has border     Size"
    END IF

    Control(FontSizeList).Disabled = Control(FontList).Disabled
    Control(FontSizeList).Hidden = Control(FontList).Hidden
    Control(FontSizeList).Top = Control(FontList).Top
    Control(PasteListBT).Hidden = TRUE

    IF PreviewControls(FirstSelected).Type = __UI_Type_ListBox OR PreviewControls(FirstSelected).Type = __UI_Type_DropdownList THEN
        IF INSTR(_CLIPBOARD$, CHR$(10)) THEN
            Control(PasteListBT).Top = Control(TextTB).Top
            Control(PasteListBT).Hidden = FALSE
        END IF
    ELSEIF (PreviewControls(FirstSelected).Type = __UI_Type_Label AND PreviewControls(FirstSelected).WordWrap = TRUE) THEN
        IF INSTR(_CLIPBOARD$, CHR$(10)) THEN
            Control(PasteListBT).Top = Control(CaptionTB).Top
            Control(PasteListBT).Hidden = FALSE
        END IF
    END IF

    'Update the color mixer
    DIM ThisColor AS _UNSIGNED LONG, ThisBackColor AS _UNSIGNED LONG

    SELECT EVERYCASE Control(ColorPropertiesList).Value
        CASE 0
            Control(ColorPropertiesList).Value = 1
        CASE IS > 5
            Control(ColorPropertiesList).Value = 5
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
END SUB

SUB __UI_BeforeUnload
    DIM Answer AS _BYTE
    IF Edited THEN
        _DELAY 0.2: Answer = _MESSAGEBOX(UiEditorTitle$, "Save the current form before leaving?", "yesnocancel", "question", 1)
        IF Answer = 0 THEN
            __UI_UnloadSignal = FALSE
        ELSEIF Answer = 1 THEN
            IF ThisFileName$ = "" THEN
                ThisFileName$ = "untitled"
            END IF
            SaveForm FALSE, FALSE
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

    IF __UI_ShowInvisibleControls THEN value$ = "True" ELSE value$ = "False"
    WriteSetting "InForm/InForm.ini", "InForm Settings", "Show invisible controls", value$

    IF ShowFontList THEN value$ = "True" ELSE value$ = "False"
    WriteSetting "InForm/InForm.ini", "InForm Settings", "Show font list", value$

    $IF WIN THEN
    $ELSE
            IF __UI_MouseButtonsSwap THEN value$ = "True" ELSE value$ = "False"
            WriteSetting "InForm/InForm.ini", "InForm Settings", "Swap mouse buttons", value$
    $END IF
END SUB

SUB __UI_BeforeInit
    __UI_KeepScreenHidden = TRUE
    __UI_EditorMode = TRUE
END SUB

SUB __UI_FormResized
END SUB

SUB Handshake
    'Handshake: each module sends the other their PID:

    DIM b$

    Stream$ = "" 'clear buffer

    b$ = "EDITORPID>" + MKL$(__UI_GetPID) + "<END>"
    Send Client, b$

    $IF WIN THEN
        CONST TIMEOUT = 10
    $ELSE
            CONST TIMEOUT = 120
    $END IF

    DIM start!, incomingData$, thisData$
    start! = TIMER
    DO
        incomingData$ = ""
        GET #Client, , incomingData$
        Stream$ = Stream$ + incomingData$
        IF INSTR(Stream$, "<END>") THEN
            thisData$ = LEFT$(Stream$, INSTR(Stream$, "<END>") - 1)
            Stream$ = MID$(Stream$, LEN(thisData$) + 6)
            IF LEFT$(thisData$, 11) = "PREVIEWPID>" THEN
                UiPreviewPID = CVL(MID$(thisData$, 12))
            END IF
            EXIT DO
        END IF
    LOOP UNTIL TIMER - start! > TIMEOUT

    IF UiPreviewPID = 0 THEN
        MessageBox "UiEditorPreview component not found or failed to load.", UiEditorTitle$, MsgBox_Critical
        SYSTEM
    END IF
END SUB

SUB __UI_OnLoad
    DIM i AS LONG, b$
    DIM prevDest AS LONG

    b$ = "Starting..."
    GOSUB ShowMessage

    'Load splash image:
    DIM tempIcon AS LONG
    tempIcon = _LOADIMAGE("InForm/resources/Application-icon-128.png", 32)

    GOSUB ShowMessage

    b$ = "Opening communication port (click 'unblock' if your Operating System asks)..."
    GOSUB ShowMessage
    DIM HostAttempts AS INTEGER
    DO
        HostAttempts = HostAttempts + 1
        InstanceHost = _OPENHOST("TCP/IP:60680") '60680 = #ED08, as the functionality was implemented in Beta 8 of the EDitor ;-)
    LOOP UNTIL InstanceHost <> 0 OR HostAttempts > 1000

    IF InstanceHost = 0 THEN
        'There is probably another instance of InForm Designer running.
        '(i) attempt to communicate and pass parameters and
        '(ii) bring it to the front.

        HostAttempts = 0
        DO
            HostAttempts = HostAttempts + 1
            Host = _OPENCLIENT("TCP/IP:60680:localhost")
        LOOP UNTIL Host <> 0 OR HostAttempts > 1000

        IF Host THEN
            b$ = "NEWINSTANCE>" + COMMAND$ + "<END>"
            Send Host, b$
            _DELAY 1
            CLOSE Host
        END IF
        SYSTEM
    END IF

    _SCREENSHOW
    _ICON

    RANDOMIZE TIMER
    HostAttempts = 0
    DO
        HostAttempts = HostAttempts + 1
        HostPort = LTRIM$(STR$(INT(RND * 5000 + 60000)))
        Host = _OPENHOST("TCP/IP:" + HostPort)
    LOOP UNTIL Host <> 0 OR HostAttempts > 1000

    IF Host = 0 THEN
        MessageBox "Unable to open communication port.", UiEditorTitle$, MsgBox_Critical
        SYSTEM
    END IF

    PreviewAttached = TRUE
    AutoNameControls = TRUE
    __UI_ShowPositionAndSize = TRUE
    __UI_ShowInvisibleControls = TRUE
    __UI_SnapLines = TRUE

    i = RegisterKeyCombo("ctrl+n", FileMenuNew)
    i = RegisterKeyCombo("ctrl+o", FileMenuOpen)
    i = RegisterKeyCombo("ctrl+s", FileMenuSave)
    i = RegisterKeyCombo("ctrl+z", EditMenuUndo)
    i = RegisterKeyCombo("ctrl+y", EditMenuRedo)
    i = RegisterKeyCombo("f1", HelpMenuHelp)

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
        PreviewAttached = TRUE
    END IF

    value$ = ReadSetting("InForm/InForm.ini", "InForm Settings", "Auto-name controls")
    IF LEN(value$) THEN
        AutoNameControls = (value$ = "True")
    ELSE
        WriteSetting "InForm/InForm.ini", "InForm Settings", "Auto-name controls", "True"
        AutoNameControls = TRUE
    END IF

    value$ = ReadSetting("InForm/InForm.ini", "InForm Settings", "Snap to edges")
    IF LEN(value$) THEN
        __UI_SnapLines = (value$ = "True")
    ELSE
        WriteSetting "InForm/InForm.ini", "InForm Settings", "Snap to edges", "True"
        __UI_SnapLines = TRUE
    END IF

    value$ = ReadSetting("InForm/InForm.ini", "InForm Settings", "Show position and size")
    IF LEN(value$) THEN
        __UI_ShowPositionAndSize = (value$ = "True")
    ELSE
        WriteSetting "InForm/InForm.ini", "InForm Settings", "Show position and size", "True"
        __UI_ShowPositionAndSize = TRUE
    END IF

    value$ = ReadSetting("InForm/InForm.ini", "InForm Settings", "Show invisible controls")
    IF LEN(value$) THEN
        __UI_ShowInvisibleControls = (value$ = "True")
    ELSE
        WriteSetting "InForm/InForm.ini", "InForm Settings", "Show invisible controls", "True"
        __UI_ShowInvisibleControls = TRUE
    END IF

    value$ = ReadSetting("InForm/InForm.ini", "InForm Settings", "Show font list")
    IF LEN(value$) THEN
        ShowFontList = (value$ = "True")
    ELSE
        WriteSetting "InForm/InForm.ini", "InForm Settings", "Show font list", "True"
        ShowFontList = TRUE
    END IF

    $IF WIN THEN
    $ELSE
            value$ = ReadSetting("InForm/InForm.ini", "InForm Settings", "Swap mouse buttons")
            __UI_MouseButtonsSwap = (value$ = "True")
            Control(OptionsMenuSwapButtons).Value = __UI_MouseButtonsSwap
    $END IF

    Control(ViewMenuPreviewDetach).Value = PreviewAttached
    Control(OptionsMenuAutoName).Value = AutoNameControls
    Control(OptionsMenuSnapLines).Value = __UI_SnapLines
    Control(ViewMenuShowPositionAndSize).Value = __UI_ShowPositionAndSize
    Control(ViewMenuShowInvisibleControls).Value = __UI_ShowInvisibleControls

    IF _FILEEXISTS("InForm/UiEditorPreview.frmbin") THEN KILL "InForm/UiEditorPreview.frmbin"

    b$ = "Parsing command line..."
    GOSUB ShowMessage

    IF _FILEEXISTS(COMMAND$) THEN
        SELECT CASE LCASE$(RIGHT$(COMMAND$, 4))
            CASE ".bas"
                'Does this .bas $include a .frm?
                FreeFileNum = FREEFILE
                DIM uB$
                OPEN COMMAND$ FOR BINARY AS #FreeFileNum
                b$ = SPACE$(LOF(FreeFileNum))
                GET #FreeFileNum, 1, b$
                SEEK #FreeFileNum, 1
                IF INSTR(b$, CHR$(10) + "'$INCLUDE:'InForm/extensions/GIFPlay.bas'") > 0 THEN
                    LoadedWithGifExtension = TRUE
                END IF
                DO
                    IF EOF(FreeFileNum) THEN EXIT DO
                    LINE INPUT #FreeFileNum, b$
                    b$ = LTRIM$(RTRIM$(b$))
                    uB$ = UCASE$(b$)
                    IF (LEFT$(b$, 1) = "'" OR LEFT$(uB$, 4) = "REM ") AND INSTR(uB$, "$INCLUDE") > 0 THEN
                        DIM FirstMark AS INTEGER, SecondMark AS INTEGER
                        FirstMark = INSTR(INSTR(uB$, "$INCLUDE") + 8, uB$, "'")
                        IF FirstMark > 0 THEN
                            SecondMark = INSTR(FirstMark + 1, uB$, "'")
                            IF SecondMark > 0 THEN
                                uB$ = MID$(uB$, FirstMark + 1, SecondMark - FirstMark - 1)
                                IF RIGHT$(uB$, 4) = ".FRM" THEN
                                    FileToOpen$ = MID$(b$, FirstMark + 1, SecondMark - FirstMark - 1)

                                    IF INSTR(COMMAND$, "/") > 0 OR INSTR(COMMAND$, "\") > 0 THEN
                                        FOR i = LEN(COMMAND$) TO 1 STEP -1
                                            IF ASC(COMMAND$, i) = 92 OR ASC(COMMAND$, i) = 47 THEN
                                                FileToOpen$ = LEFT$(COMMAND$, i - 1) + PathSep$ + FileToOpen$
                                                EXIT FOR
                                            END IF
                                        NEXT
                                    END IF

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
                    IF _FILEEXISTS(LEFT$(FileToOpen$, LEN(FileToOpen$) - 4) + ".bas") THEN
                        FreeFileNum = FREEFILE
                        OPEN LEFT$(FileToOpen$, LEN(FileToOpen$) - 4) + ".bas" FOR BINARY AS #FreeFileNum
                        b$ = SPACE$(LOF(FreeFileNum))
                        GET #FreeFileNum, 1, b$
                        CLOSE #FreeFileNum
                        IF INSTR(b$, CHR$(10) + "'$INCLUDE:'InForm/extensions/GIFPlay.bas'") > 0 THEN
                            LoadedWithGifExtension = TRUE
                        END IF
                    END IF
                END IF
        END SELECT

        IF LEN(FileToOpen$) > 0 THEN
            IF INSTR(FileToOpen$, "/") > 0 OR INSTR(FileToOpen$, "\") > 0 THEN
                FOR i = LEN(FileToOpen$) TO 1 STEP -1
                    IF ASC(FileToOpen$, i) = 92 OR ASC(FileToOpen$, i) = 47 THEN
                        CurrentPath$ = LEFT$(FileToOpen$, i - 1)
                        ThisFileName$ = MID$(FileToOpen$, i + 1)
                        EXIT FOR
                    END IF
                NEXT
            ELSE
                ThisFileName$ = FileToOpen$
            END IF
            FreeFileNum = FREEFILE
            OPEN FileToOpen$ FOR BINARY AS #FreeFileNum
            b$ = SPACE$(LOF(FreeFileNum))
            GET #FreeFileNum, 1, b$
            CLOSE #FreeFileNum

            OPEN "InForm/UiEditorPreview.frmbin" FOR BINARY AS #FreeFileNum
            PUT #FreeFileNum, 1, b$
            CLOSE #FreeFileNum
            IF LoadedWithGifExtension = FALSE THEN
                LoadedWithGifExtension = 1 'Query whether this file contains the gif extension
                Control(AddGifExtensionToggle).Value = FALSE
            ELSE
                Control(AddGifExtensionToggle).Value = TRUE
            END IF
            AddToRecentList FileToOpen$
        END IF
    END IF

    b$ = "Checking Preview component..."
    GOSUB ShowMessage
    $IF WIN THEN
        IF _FILEEXISTS("InForm/UiEditorPreview.exe") = 0 THEN GOTO UiEditorPreviewNotFound
    $ELSE
            IF _FILEEXISTS("InForm/UiEditorPreview") = 0 THEN GOTO UiEditorPreviewNotFound
    $END IF

    b$ = "Reading directory..."
    GOSUB ShowMessage
    'Fill "open dialog" listboxes:
    '-------------------------------------------------
    DIM TotalFiles%
    IF CurrentPath$ = "" THEN CurrentPath$ = _STARTDIR$
    Text(FileList) = idezfilelist$(CurrentPath$, 0, 1, TotalFiles%)
    Control(FileList).Max = TotalFiles%
    Control(FileList).LastVisibleItem = 0 'Reset it so it's recalculated

    Text(DirList) = idezpathlist$(CurrentPath$, TotalFiles%)
    Control(DirList).Max = TotalFiles%
    Control(DirList).LastVisibleItem = 0 'Reset it so it's recalculated

    Caption(PathLB) = "Path: " + CurrentPath$
    '-------------------------------------------------

    'Load font list
    b$ = "Loading font list..."
    GOSUB ShowMessage
    LoadFontList

    'Assign InputBox IDs:
    i = 0
    i = i + 1: InputBox(i).ID = NameTB: InputBox(i).LabelID = NameLB: InputBox(i).Signal = 1: InputBox(i).DataType = DT_Text
    i = i + 1: InputBox(i).ID = CaptionTB: InputBox(i).LabelID = CaptionLB: InputBox(i).Signal = 2: InputBox(i).DataType = DT_Text
    i = i + 1: InputBox(i).ID = TextTB: InputBox(i).LabelID = TextLB: InputBox(i).Signal = 3: InputBox(i).DataType = DT_Text
    i = i + 1: InputBox(i).ID = MaskTB: InputBox(i).LabelID = MaskLB: InputBox(i).Signal = 35: InputBox(i).DataType = DT_Text
    i = i + 1: InputBox(i).ID = TopTB: InputBox(i).LabelID = TopLB: InputBox(i).Signal = 4: InputBox(i).DataType = DT_Integer
    i = i + 1: InputBox(i).ID = LeftTB: InputBox(i).LabelID = LeftLB: InputBox(i).Signal = 5: InputBox(i).DataType = DT_Integer
    i = i + 1: InputBox(i).ID = WidthTB: InputBox(i).LabelID = WidthLB: InputBox(i).Signal = 6: InputBox(i).DataType = DT_Integer
    i = i + 1: InputBox(i).ID = HeightTB: InputBox(i).LabelID = HeightLB: InputBox(i).Signal = 7: InputBox(i).DataType = DT_Integer
    i = i + 1: InputBox(i).ID = FontTB: InputBox(i).LabelID = FontLB: InputBox(i).Signal = 8: InputBox(i).DataType = DT_Text
    i = i + 1: InputBox(i).ID = FontList: InputBox(i).LabelID = FontListLB: InputBox(i).Signal = 8: InputBox(i).DataType = DT_Text
    i = i + 1: InputBox(i).ID = TooltipTB: InputBox(i).LabelID = TooltipLB: InputBox(i).Signal = 9: InputBox(i).DataType = DT_Text
    i = i + 1: InputBox(i).ID = ValueTB: InputBox(i).LabelID = ValueLB: InputBox(i).Signal = 10: InputBox(i).DataType = DT_Float
    i = i + 1: InputBox(i).ID = BooleanOptions: InputBox(i).LabelID = BooleanLB: InputBox(i).Signal = 10: InputBox(i).DataType = DT_Float
    i = i + 1: InputBox(i).ID = MinTB: InputBox(i).LabelID = MinLB: InputBox(i).Signal = 11: InputBox(i).DataType = DT_Float
    i = i + 1: InputBox(i).ID = MaxTB: InputBox(i).LabelID = MaxLB: InputBox(i).Signal = 12: InputBox(i).DataType = DT_Float
    i = i + 1: InputBox(i).ID = IntervalTB: InputBox(i).LabelID = IntervalLB: InputBox(i).Signal = 13: InputBox(i).DataType = DT_Float
    i = i + 1: InputBox(i).ID = MinIntervalTB: InputBox(i).LabelID = MinIntervalLB: InputBox(i).Signal = 36: InputBox(i).DataType = DT_Float
    i = i + 1: InputBox(i).ID = PaddingTB: InputBox(i).LabelID = PaddingLeftrightLB: InputBox(i).Signal = 31: InputBox(i).DataType = DT_Integer
    i = i + 1: InputBox(i).ID = AlignOptions: InputBox(i).LabelID = TextAlignLB
    i = i + 1: InputBox(i).ID = VAlignOptions: InputBox(i).LabelID = VerticalAlignLB
    i = i + 1: InputBox(i).ID = BulletOptions: InputBox(i).LabelID = BulletOptionsLB
    i = i + 1: InputBox(i).ID = SizeTB: InputBox(i).Signal = 40: InputBox(i).DataType = DT_Integer
    i = i + 1: InputBox(i).ID = ContextMenuControlsList: InputBox(i).LabelID = ContextMenuLB: InputBox(i).DataType = DT_Text
    i = i + 1: InputBox(i).ID = KeyboardComboBT: InputBox(i).LabelID = KeyboardComboLB: InputBox(i).DataType = DT_Text

    REDIM _PRESERVE InputBox(1 TO i) AS newInputBox
    REDIM InputBoxText(1 TO i) AS STRING

    'Assign Toggles IDs:
    i = 0
    i = i + 1: Toggles(i) = Stretch
    i = i + 1: Toggles(i) = HasBorder
    i = i + 1: Toggles(i) = ShowPercentage
    i = i + 1: Toggles(i) = PasswordMaskCB
    i = i + 1: Toggles(i) = WordWrap
    i = i + 1: Toggles(i) = CanHaveFocus
    i = i + 1: Toggles(i) = Disabled
    i = i + 1: Toggles(i) = Transparent
    i = i + 1: Toggles(i) = Hidden
    i = i + 1: Toggles(i) = CenteredWindow
    i = i + 1: Toggles(i) = Resizable
    i = i + 1: Toggles(i) = AutoScroll
    i = i + 1: Toggles(i) = AutoSize
    i = i + 1: Toggles(i) = HideTicks
    i = i + 1: Toggles(i) = AutoPlayGif
    i = i + 1: Toggles(i) = AddGifExtensionToggle
    REDIM _PRESERVE Toggles(1 TO i) AS LONG

    ToolTip(FontTB) = "Multiple fonts can be specified by separating them with a question mark (?)." + CHR$(10) + "The first font that can be found/loaded is used."
    ToolTip(FontList) = "System fonts may not be available in all computers. To specify a local font file, right-click 'Font' to the left of this list and disable 'Show system fonts list'."
    ToolTip(ColorPreview) = "Click to copy the current color's hex value to the clipboard."
    ToolTip(KeyboardComboBT) = "Click to assign a key combination to the selected control"

    StatusBarBackColor = Darken(__UI_DefaultColor(__UI_Type_Form, 2), 90)
    Control(StatusBar).BackColor = StatusBarBackColor

    FOR i = 1 TO 9
        RecentMenuItem(i) = __UI_GetID("FileMenuRecent" + LTRIM$(STR$(i)))
    NEXT

    b$ = "Loading images..."
    GOSUB ShowMessage

    'Load toolbox images:
    DIM CommControls AS LONG
    CommControls = LoadEditorImage(EDITOR_IMAGE_COMMONCONTROLS)
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

    'Draw PasteListBT icon
    Control(PasteListBT).HelperCanvas = _NEWIMAGE(17, 17, 32)
    _DEST Control(PasteListBT).HelperCanvas
    _FONT 16
    FOR i = 4 TO 15 STEP 4
        LINE (3, i)-STEP(_WIDTH - 6, 1), _RGB32(122, 122, 122), BF
    NEXT

    'Import Align menu icons from InForm.ui
    Control(AlignMenuAlignLeft).HelperCanvas = Control(__UI_GetID("__UI_PreviewMenuAlignLeft")).HelperCanvas
    Control(AlignMenuAlignRight).HelperCanvas = Control(__UI_GetID("__UI_PreviewMenuAlignRight")).HelperCanvas
    Control(AlignMenuAlignTops).HelperCanvas = Control(__UI_GetID("__UI_PreviewMenuAlignTops")).HelperCanvas
    Control(AlignMenuAlignBottoms).HelperCanvas = Control(__UI_GetID("__UI_PreviewMenuAlignBottoms")).HelperCanvas
    Control(AlignMenuAlignCentersV).HelperCanvas = Control(__UI_GetID("__UI_PreviewMenuAlignCentersV")).HelperCanvas
    Control(AlignMenuAlignCentersH).HelperCanvas = Control(__UI_GetID("__UI_PreviewMenuAlignCentersH")).HelperCanvas

    _DEST prevDest

    Control(FileMenuSave).HelperCanvas = LoadEditorImage(EDITOR_IMAGE_DISK)

    _FREEIMAGE CommControls

    b$ = "Launching Preview component..."
    GOSUB ShowMessage

    $IF WIN THEN
        SHELL _DONTWAIT ".\InForm\UiEditorPreview.exe " + HostPort
    $ELSE
            Shell _DontWait "./InForm/UiEditorPreview " + HostPort
    $END IF

    b$ = "Connecting to preview component..."
    GOSUB ShowMessage
    DO
        Client = _OPENCONNECTION(Host)
        IF Client THEN EXIT DO
        IF _EXIT THEN SYSTEM 'Can't force user to wait...
        _DISPLAY
        _LIMIT 15
    LOOP

    b$ = "Connected! Handshaking..."
    GOSUB ShowMessage
    Handshake

    __UI_RefreshMenuBar
    __UI_ForceRedraw = TRUE
    _FREEIMAGE tempIcon

    _ACCEPTFILEDROP

    EXIT SUB
    UiEditorPreviewNotFound:
    MessageBox "UiEditorPreview component not found or failed to load.", UiEditorTitle$, MsgBox_Critical
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
    DIM i AS LONG
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
                    IF Caption(OpenFrame) = "Open" THEN
                        __UI_Click OpenBT
                    ELSE
                        __UI_Click SaveBT
                    END IF
                ELSEIF __UI_KeyHit = 18432 OR __UI_KeyHit = 20480 THEN
                    IF Control(FileList).Max > 0 THEN __UI_Focus = FileList
                ELSE
                    IF Control(FileList).Max > 0 THEN
                        SELECT CASE __UI_KeyHit
                            CASE 48 TO 57, 65 TO 90, 97 TO 122 'Alphanumeric
                                IF Caption(OpenFrame) = "Open" THEN
                                    __UI_ListBoxSearchItem Control(FileList)
                                END IF
                        END SELECT
                    END IF
                END IF
            END IF
        CASE FileList, DirList, CancelBT, OpenBT, SaveBT, ShowOnlyFrmbinFilesCB, SaveFrmOnlyCB
            IF __UI_KeyHit = 27 THEN
                __UI_Click CancelBT
            END IF
        CASE FileList
            IF __UI_KeyHit = 13 THEN
                __UI_KeyHit = 0
                IF Caption(OpenFrame) = "Open" THEN
                    __UI_Click OpenBT
                ELSE
                    __UI_Click SaveBT
                END IF
            END IF
        CASE ControlList, UpBT, DownBT, CloseZOrderingBT
            IF __UI_KeyHit = 27 THEN
                __UI_Click CloseZOrderingBT
            END IF
        CASE NameTB, CaptionTB, TextTB, MaskTB, TopTB, LeftTB, WidthTB, HeightTB, FontTB, TooltipTB, ValueTB, MinTB, MaxTB, IntervalTB, PaddingTB, MinIntervalTB, SizeTB
            IF __UI_KeyHit = 13 THEN
                'Send the preview the new property value
                ConfirmEdits id
            ELSEIF __UI_KeyHit = 32 THEN
                IF id = NameTB THEN
                    __UI_KeyHit = 0
                    Caption(StatusBar) = "Control names cannot contain spaces"
                    BlinkStatusBar = TIMER
                ELSE
                    InputBox(GetInputBoxFromID(id)).Sent = FALSE
                    Send Client, "LOCKCONTROLS><END>"
                END IF
            ELSEIF __UI_KeyHit = 27 THEN
                RevertEdit = TRUE
                Caption(StatusBar) = "Previous property value restored."
            ELSE
                InputBox(GetInputBoxFromID(id)).Sent = FALSE
                Send Client, "LOCKCONTROLS><END>"
            END IF
        CASE KeyboardComboBT
            DIM Combo$
            IF __UI_CtrlIsDown THEN Combo$ = "Ctrl+"
            IF __UI_ShiftIsDown THEN Combo$ = Combo$ + "Shift+"
            SELECT CASE __UI_KeyHit
                CASE 27
                    __UI_Focus = 0
                    __UI_BypassKeyCombos = FALSE
                    ToolTip(KeyboardComboBT) = "Click to assign a key combination to the selected control"
                    SendData MKI$(0), 43
                    __UI_ForceRedraw = TRUE
    CASE __UI_FKey(1), __UI_FKey(2), __UI_FKey(3), __UI_FKey(4), __UI_FKey(5), __UI_FKey(6), _
        __UI_FKey(7), __UI_FKey(8), __UI_FKey(9), __UI_FKey(10), __UI_FKey(11), __UI_FKey(12)
                    FOR i = 1 TO 12
                        IF __UI_FKey(i) = __UI_KeyHit THEN
                            Combo$ = Combo$ + "F" + LTRIM$(STR$(i))
                            SendData MKI$(LEN(Combo$)) + Combo$, 43
                            __UI_Focus = 0
                            __UI_BypassKeyCombos = FALSE
                            ToolTip(KeyboardComboBT) = "Click to assign a key combination to the selected control"
                            __UI_ForceRedraw = TRUE
                            EXIT FOR
                        END IF
                    NEXT
                CASE 65 TO 90, 97 TO 122 'Alphanumeric
                    Combo$ = Combo$ + UCASE$(CHR$(__UI_KeyHit))
                    IF INSTR(Combo$, "Ctrl+") > 0 THEN
                        SendData MKI$(LEN(Combo$)) + Combo$, 43
                        __UI_Focus = 0
                        __UI_BypassKeyCombos = FALSE
                        ToolTip(KeyboardComboBT) = "Click to assign a key combination to the selected control"
                        __UI_ForceRedraw = TRUE
                    END IF
            END SELECT
    END SELECT
END SUB

SUB ConfirmEdits (id AS LONG)
    DIM b$, TempValue AS LONG

    IF InputBoxText(GetInputBoxFromID(id)) <> Text(id) AND _
        InputBox(GetInputBoxFromID(id)).Sent = False THEN
        SELECT CASE InputBox(GetInputBoxFromID(id)).DataType
            CASE DT_Text
                b$ = MKL$(LEN(Text(id))) + Text(id)
            CASE DT_Integer
                b$ = MKI$(VAL(Text(id)))
            CASE DT_Float
                b$ = _MK$(_FLOAT, VAL(Text(id)))
        END SELECT
        TempValue = GetPropertySignal(id)
        SendData b$, TempValue
        PropertySent = TRUE
        Text(id) = RestoreCHR(Text(id))
        SelectPropertyFully id
        InputBoxText(GetInputBoxFromID(id)) = Text(id)
        InputBox(GetInputBoxFromID(id)).LastEdited = TIMER
        InputBox(GetInputBoxFromID(id)).Sent = TRUE
        Caption(StatusBar) = "Ready."
    END IF
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
    IF __UI_StateHasChanged THEN EXIT SUB 'skip values changed programmatically

    DIM b$, i AS LONG
    SELECT EVERYCASE id
        CASE AlignOptions
            IF __UI_Focus <> id THEN EXIT SUB
            b$ = MKI$(Control(AlignOptions).Value - 1)
            SendData b$, 22
            PropertySent = TRUE
        CASE VAlignOptions
            IF __UI_Focus <> id THEN EXIT SUB
            b$ = MKI$(Control(VAlignOptions).Value - 1)
            SendData b$, 32
            PropertySent = TRUE
        CASE BulletOptions
            IF __UI_Focus <> id THEN EXIT SUB
            b$ = MKI$(Control(BulletOptions).Value - 1)
            SendData b$, 37
            PropertySent = TRUE
        CASE BooleanOptions
            b$ = _MK$(_FLOAT, -(Control(BooleanOptions).Value - 1))
            SendData b$, GetPropertySignal(BooleanOptions)
            PropertySent = TRUE
        CASE ContextMenuControlsList
            i = Control(ContextMenuControlsList).Value
            IF i > 1 THEN
                b$ = GetItem(ContextMenuControlsList, i)
                b$ = MKI$(LEN(b$)) + b$
            ELSE
                b$ = MKI$(0)
            END IF
            SendData b$, 41
        CASE FontList, FontSizeList
            b$ = FontFile(Control(FontList).Value) + "," + GetItem$(FontSizeList, Control(FontSizeList).Value)
            b$ = MKL$(LEN(b$)) + b$
            SendData b$, 8
            PropertySent = TRUE
        CASE Red
            Text(RedValue) = LTRIM$(STR$(Control(Red).Value))
        CASE Green
            Text(GreenValue) = LTRIM$(STR$(Control(Green).Value))
        CASE Blue
            Text(BlueValue) = LTRIM$(STR$(Control(Blue).Value))
        CASE ControlList
            Control(UpBT).Disabled = FALSE
            Control(DownBT).Disabled = FALSE
            IF Control(ControlList).Value = 1 THEN
                Control(UpBT).Disabled = TRUE
            ELSEIF Control(ControlList).Value = 0 THEN
                Control(UpBT).Disabled = TRUE
                Control(DownBT).Disabled = TRUE
            ELSEIF Control(ControlList).Value = Control(ControlList).Max THEN
                Control(DownBT).Disabled = TRUE
            END IF
            IF Control(ControlList).Value > 0 THEN
                b$ = MKL$(zOrderIDs(Control(ControlList).Value))
            ELSE
                b$ = MKL$(0)
            END IF
            SendData b$, 213
        CASE FileList
            Text(FileNameTextBox) = GetItem(FileList, Control(FileList).Value)
        CASE NameTB, CaptionTB, TextTB, MaskTB, TopTB, LeftTB, WidthTB, HeightTB, FontTB, TooltipTB, ValueTB, MinTB, MaxTB, IntervalTB, PaddingTB, MinIntervalTB, SizeTB
            Send Client, "LOCKCONTROLS><END>"
    END SELECT
END SUB

SUB PreselectFile
    DIM b$
    b$ = GetItem(FileList, Control(FileList).Value)
    IF LCASE$(Text(FileNameTextBox)) = LCASE$(LEFT$(b$, LEN(Text(FileNameTextBox)))) THEN
        Text(FileNameTextBox) = Text(FileNameTextBox) + MID$(b$, LEN(Text(FileNameTextBox)) + 1)
        Control(FileNameTextBox).TextIsSelected = TRUE
        Control(FileNameTextBox).SelectionStart = LEN(Text(FileNameTextBox))
    END IF
END SUB

'---------------------------------------------------------------------------------
' Use this to store editor images and bitmaps
' Take care not to call multiple times for the same image as it will create a new _IMAGE everytime it is called!
FUNCTION LoadEditorImage& (id AS _UNSIGNED _BYTE)
    SELECT CASE id
        CASE EDITOR_IMAGE_COMMONCONTROLS
            CONST SIZE_COMMONCONTROLS_BMP_11386~& = 11386~&
            CONST COMP_COMMONCONTROLS_BMP_11386%% = -1%%
            CONST DATA_COMMONCONTROLS_BMP_11386 = _
                "eNpy8q3SYQC0W4UwsgJJdC5nRo4ceciRSCwSiRw7knO4wyKRyLZIkjNILBLZsi0S90e+q7x0SF96tj/MbvJ/NluZl6KYflVV3UWnKP8R/FtwEfxX" + _
                "8I/Tv07/PH0ksD9rvCG/Tr/wWXRdC6VadIp6t22578alD8Fn8haoPxdfuD/1f239Oj25mjDZ6UD9zvow3+1hPnvr/Xy8/n8VO6D/SnRljjq9oc4E" + _
                "aURU6RW1oEos4ovFmShvZ7j8Vis0gmpu8BhL5EOBWOW4tSmuTbLhViXIkht9bfzqjnGZ0C8D/dRzKz6qzUckPi6N8O4JinuGR54yB8tHXz3I1U8j" + _
                "ekTr5JH1BW4qQ54laKuSkGtTamJ8YmgKqK62PjS11IJyapjDQ+ob+w5D15I7tI3Ed/klnuvi+DDUUgcKyU2PA8w8kvscFQbVoE6uG39sa4iAPuqS" + _
                "3EHqKB4Z5l6hyFPWbAYFTB1G1aJy+JMin/JcDH10jeRkZmDRgJkgSQDzIOjFRcsztnzanjxXQk8a0V3jmk/Qw0AfkhP7w/LF9vjWxxPxw6CcgKwV" + _
                "P/nMPLTwpdccvsIHInyNcQXKEcxDEoIZOua/h28McyCkFu7HMnY74/v7gcUINL8Xl68HRT1Tt5i7lucyCqQ/COlTQr4XgvwffBpFUbyDjbssCw4K" + _
                "OdYP7cxkSE0KEWqx7fuU9itx+bG+ITaxfY5p2/e0f8dPTIJEx9uzwHsO8XOTCXL7nNN234f4xhgclXVdyf3s+f3g+0B13dvcxjS4dte3fDSaXLRz" + _
                "i2t7Rdf3h/iMqxXvhGZsUNcNdgr5ddPiCWBZV2itaa/PpwDUol7ZDp/xGF+T33AflFIh7cVfnfhH68/mDOmUUTd1eYgf9ZH4iKh5Dk11gP+Dsasx" + _
                "qsrq+pBNvrwLyXPm3Ec9d+1mWz51mL9xOQPTh8/nfw68+Hzn6FHti8/cJ+ZAWNurn3H9HPj/JGtHC2sfrd/LI1Q/5Yvrd/af9hecP/uoziPB9R3N" + _
                "fdwr5NyFM02bj1Ed4ZO7QWzvPAP2/+d+p/5G94dT8wGbfFUhJE7Ps39oO/077elf9/7oW9oH+5dceXa+n2rX/WPje/qd+sn16w/eP3iuwLp4+mD9" + _
                "Xh6h+ilfW797f/2R87d3oF//J/v/u2EeO/RtzTuubyvae3hmHnk/Dm0JLc8ifCc238tzkNvVd+pXYvSEvn585IP+9SRnbOdiat8H172ut+RMLTzR" + _
                "K5TucFM3qFlhdXxJLd5+dNyjnuvWdUWnhdvfEHU3XNoLfVhh/k2RuXzu87Is5Ep8ZFOOdM6QjAnoR/JwhOtdflvdMUn8ZV2JfumRa/ExZeQrrehX" + _
                "hOfSlNmr+sld6WMRHwPz6EzH/fDr9/df9oB12Dy4H7YmQtv+CJ3/PA1bHpZLP2NX8/9QD+l52PpvsrnMovu24PtD/d88uM+yt2693xXuTCOI9tje" + _
                "+fvfXnAW8+ILj9gjr+K7vSaCqIsOx18tX7j2G472xrc9T66HPfFtz29x/TzC8e23x7XOt+fmEYpP7otvz80jGN/Y+B/dATY+nz+ITx+BPIhgfMHv" + _
                "8rDxv7T/f+b/4+LPf4fEm/+8Gda3KfbZn3/9NcF3bv1+/DDfr/9o/HD9lIP1++LGp4TrP8j/+vM/JH/R/P+DaZoQxzecz2dE0ZW2+7/bx9fL5SMf" + _
                "/M/hbmjqitzo6vr2UT7ueOS5tf34j3senh3nmeuyNEESx0iTGJfLeePL/wE+QY6TI3MOxPagmhr3LHXzwVlAnzvP4nI+U0sd5Cfx7dg8WRaoiseR" + _
                "ur0cLJf1v9NTVcUzd+s+nIPthW8NPfWcaar0hDI5/U5z9pnHbuM2jxjj0GPWhpis/sgex4EcPfaosgvmecJqZ7Sdmj4kD+bkzIi7tOGMuLIWgfuf" + _
                "e8/4tl23CFd8MLaA70TANcDGc/Vz+x/kL6sT33IC84Pri1yBjU++J6H5YV1Zxxafsn9+YA7iY4sfEJfn8pmzjX+Yb30wdnO/wegJR2URjvQ8+7gt" + _
                "Eph5v491MWht/8o3QC157Ph2qNnzeiL30/gfg472/w=="

            LoadEditorImage = _LOADIMAGE(Base64_LoadResourceString(DATA_COMMONCONTROLS_BMP_11386, SIZE_COMMONCONTROLS_BMP_11386, COMP_COMMONCONTROLS_BMP_11386), 32, "memory")

        CASE EDITOR_IMAGE_DISK
            CONST SIZE_DISK_BMP_1146~& = 1146~&
            CONST COMP_DISK_BMP_1146%% = -1%%
            CONST DATA_DISK_BMP_1146 = _
                "eNpy8q1iYQCDKiDOAWIBKGZkUGBgZsAF/kMQjEMG4OHhERMXF/cDMu2B2IEIbA90qrOokJAHkM2urqISAqTvx0RF/u/v7v7f1d7+v7ujAxcGy9tY" + _
                "Wf7kZGW5paKg4AAgixwC64iDMJ5jbbtx8mxtbLO27V5q81j3Xtu2bTxbcW7Vvv06/dft4Rv/ZhYmk6mAePe61as/1odDkbDfx9cE/EwUf8sjP2K+" + _
                "LhTkHRYzsjMzm+mb2CSJiYY0jishHsTzDeEwQl4Pwj7vv6K6F7WBAFw2q5CZno6ObdpALBar0zmumHisWbmSrw344Xc5EXC7/pfLhTDtsL9/h6yM" + _
                "tEjXjh0gEok0P/nVy5bxYY8HXrsNPoed5PjlSVS3sx2W169B94Ve3boxPiud8VhL92tov4/m/DT/j9iuIPG2t2+Qm5UV6durJ+TEcwYD4+fNmsW/" + _
                "ff4Mb5/90PN/9OwpzC9f4t716zDqdUJCTDS7LxOLixUSCaQiEU91mAx6aNUq8jrQfwJHOXmkkNJSONaTJCcJUlEyoqOjNUqZuFgll0EhlfBUQ15O" + _
                "NkaPHIHB1VWoLC9HVUUF8+WlJWwPzYEkyCVixmuVyuJUkwF9u3fh58yahQP792PZ0qU4dPAgTh4/juPHjuHY0aM4dfIkpk+bBnpXGHXaiFatRDzx" + _
                "6ZyhODcrA9G9e/BLFy/G3r172cz+fftw4fx5nDl9munSxYuYP28e62WlpUTSTEaI4uM1edkZRaWF+VCKE/llSxYzrlvLljh44ADjz/7BL5w/Hy2j" + _
                "ooTCvJxIXlYG+/4VhYVlw4dUQ54Y83H71q24e+eOQDeE+/fvCw6HQzCbzYL5/XvB6XQKmzdtYr3K0uIvxQW5kMtFGsrbjBw6+FF+BofdO3cIwYAf" + _
                "d27dgtfjQU04jHAoiGAggMaGeuzavh2K6GhMHDMS40YNA6fX64iP+rqAgAABV0dHL193d+2e9nbj9atWGbc31RpXFOcZ1xYXGzeUlhrVVhQbJ8fF" + _
                "GXq5uOgG+/v4hgb5h3t6evIBAK70LyE="

            LoadEditorImage = _LOADIMAGE(Base64_LoadResourceString(DATA_DISK_BMP_1146, SIZE_DISK_BMP_1146, COMP_DISK_BMP_1146), 32, "memory")

        CASE ELSE
            ERROR 51
    END SELECT
END FUNCTION

FUNCTION ReadSequential$ (Txt$, Bytes%)
    ReadSequential$ = LEFT$(Txt$, Bytes%)
    Txt$ = MID$(Txt$, Bytes% + 1)
END FUNCTION

SUB LoadPreview
    DIM b$, __UI_EOF AS _BYTE, Answer AS _BYTE
    DIM NewType AS INTEGER, NewWidth AS INTEGER, NewHeight AS INTEGER
    DIM NewLeft AS INTEGER, NewTop AS INTEGER, NewName AS STRING
    DIM NewParentID AS STRING, FloatValue AS _FLOAT, Dummy AS LONG
    DIM FormData$
    STATIC PrevTotalGifLoaded AS LONG

    TIMER(__UI_EventsTimer) OFF
    TIMER(__UI_RefreshTimer) OFF

    FormData$ = LastFormData$

    AddGifExtension = FALSE
    TotalGifLoaded = 0
    IF LoadedWithGifExtension = 1 THEN PrevTotalGifLoaded = 0

    b$ = ReadSequential$(FormData$, 4)

    REDIM PreviewCaptions(0 TO CVL(b$)) AS STRING
    REDIM PreviewTexts(0 TO CVL(b$)) AS STRING
    REDIM PreviewMasks(0 TO CVL(b$)) AS STRING
    REDIM PreviewTips(0 TO CVL(b$)) AS STRING
    REDIM PreviewFonts(0 TO CVL(b$)) AS STRING
    REDIM PreviewActualFonts(0 TO CVL(b$)) AS STRING
    REDIM PreviewControls(0 TO CVL(b$)) AS __UI_ControlTYPE
    REDIM PreviewParentIDS(0 TO CVL(b$)) AS STRING
    REDIM PreviewContextMenu(0 TO CVL(b$)) AS STRING
    REDIM PreviewBoundTo(0 TO CVL(b$)) AS STRING
    REDIM PreviewBoundProperty(0 TO CVL(b$)) AS STRING
    REDIM PreviewKeyCombos(0 TO CVL(b$)) AS STRING
    REDIM PreviewAnimatedGif(0 TO CVL(b$)) AS _BYTE
    REDIM PreviewAutoPlayGif(0 TO CVL(b$)) AS _BYTE

    ResetList ContextMenuControlsList
    AddItem ContextMenuControlsList, "(none)"

    b$ = ReadSequential$(FormData$, 2)
    IF CVI(b$) <> -1 THEN GOTO LoadError
    DO
        b$ = ReadSequential$(FormData$, 4)
        Dummy = CVL(b$)
        IF Dummy <= 0 OR Dummy > UBOUND(PreviewControls) THEN EXIT DO 'Corrupted exchange file.
        b$ = ReadSequential$(FormData$, 2)
        NewType = CVI(b$)
        b$ = ReadSequential$(FormData$, 2)
        b$ = ReadSequential$(FormData$, CVI(b$))
        NewName = b$
        b$ = ReadSequential$(FormData$, 2)
        NewWidth = CVI(b$)
        b$ = ReadSequential$(FormData$, 2)
        NewHeight = CVI(b$)
        b$ = ReadSequential$(FormData$, 2)
        NewLeft = CVI(b$)
        b$ = ReadSequential$(FormData$, 2)
        NewTop = CVI(b$)
        b$ = ReadSequential$(FormData$, 2)
        IF CVI(b$) > 0 THEN
            NewParentID = ReadSequential$(FormData$, CVI(b$))
        ELSE
            NewParentID = ""
        END IF

        IF NewType = __UI_Type_ContextMenu THEN
            AddItem ContextMenuControlsList, NewName
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
            b$ = ReadSequential$(FormData$, 2)
            SELECT CASE CVI(b$)
                CASE -2 'Caption
                    b$ = ReadSequential$(FormData$, 4)
                    b$ = ReadSequential$(FormData$, CVL(b$))
                    PreviewCaptions(Dummy) = b$
                CASE -3 'Text
                    b$ = ReadSequential$(FormData$, 4)
                    b$ = ReadSequential$(FormData$, CVL(b$))
                    PreviewTexts(Dummy) = b$
                CASE -4 'Stretch
                    PreviewControls(Dummy).Stretch = TRUE
                CASE -5 'Font
                    DIM FontSetup$
                    DIM NewFontSize$
                    b$ = ReadSequential$(FormData$, 2)
                    FontSetup$ = ReadSequential$(FormData$, CVI(b$))
                    PreviewFonts(Dummy) = FontSetup$
                    NewFontSize$ = MID$(FontSetup$, INSTR(FontSetup$, ","))
                    b$ = ReadSequential$(FormData$, 2)
                    FontSetup$ = ReadSequential$(FormData$, CVI(b$))
                    PreviewActualFonts(Dummy) = FontSetup$ + NewFontSize$
                CASE -6 'ForeColor
                    b$ = ReadSequential$(FormData$, 4)
                    PreviewControls(Dummy).ForeColor = _CV(_UNSIGNED LONG, b$)
                CASE -7 'BackColor
                    b$ = ReadSequential$(FormData$, 4)
                    PreviewControls(Dummy).BackColor = _CV(_UNSIGNED LONG, b$)
                CASE -8 'SelectedForeColor
                    b$ = ReadSequential$(FormData$, 4)
                    PreviewControls(Dummy).SelectedForeColor = _CV(_UNSIGNED LONG, b$)
                CASE -9 'SelectedBackColor
                    b$ = ReadSequential$(FormData$, 4)
                    PreviewControls(Dummy).SelectedBackColor = _CV(_UNSIGNED LONG, b$)
                CASE -10 'BorderColor
                    b$ = ReadSequential$(FormData$, 4)
                    PreviewControls(Dummy).BorderColor = _CV(_UNSIGNED LONG, b$)
                CASE -11
                    PreviewControls(Dummy).BackStyle = __UI_Transparent
                CASE -12
                    PreviewControls(Dummy).HasBorder = TRUE
                CASE -13
                    b$ = ReadSequential$(FormData$, 1)
                    PreviewControls(Dummy).Align = _CV(_BYTE, b$)
                CASE -14
                    b$ = ReadSequential$(FormData$, LEN(FloatValue))
                    PreviewControls(Dummy).Value = _CV(_FLOAT, b$)
                CASE -15
                    b$ = ReadSequential$(FormData$, LEN(FloatValue))
                    PreviewControls(Dummy).Min = _CV(_FLOAT, b$)
                CASE -16
                    b$ = ReadSequential$(FormData$, LEN(FloatValue))
                    PreviewControls(Dummy).Max = _CV(_FLOAT, b$)
                CASE -19
                    PreviewControls(Dummy).ShowPercentage = TRUE
                CASE -20
                    PreviewControls(Dummy).CanHaveFocus = TRUE
                CASE -21
                    PreviewControls(Dummy).Disabled = TRUE
                CASE -22
                    PreviewControls(Dummy).Hidden = TRUE
                CASE -23
                    PreviewControls(Dummy).CenteredWindow = TRUE
                CASE -24 'Tips
                    b$ = ReadSequential$(FormData$, 4)
                    b$ = ReadSequential$(FormData$, CVL(b$))
                    PreviewTips(Dummy) = b$
                CASE -25 'ContextMenu
                    b$ = ReadSequential$(FormData$, 2)
                    b$ = ReadSequential$(FormData$, CVI(b$))
                    PreviewContextMenu(Dummy) = b$
                CASE -26
                    b$ = ReadSequential$(FormData$, LEN(FloatValue))
                    PreviewControls(Dummy).Interval = _CV(_FLOAT, b$)
                CASE -27
                    PreviewControls(Dummy).WordWrap = TRUE
                CASE -29
                    PreviewControls(Dummy).CanResize = TRUE
                CASE -31
                    b$ = ReadSequential$(FormData$, 2)
                    PreviewControls(Dummy).Padding = CVI(b$)
                CASE -32
                    b$ = ReadSequential$(FormData$, 1)
                    PreviewControls(Dummy).VAlign = _CV(_BYTE, b$)
                CASE -33
                    PreviewControls(Dummy).PasswordField = TRUE
                CASE -34
                    b$ = ReadSequential$(FormData$, 4)
                    PreviewControls(Dummy).Encoding = CVL(b$)
                CASE -35
                    PreviewDefaultButtonID = Dummy
                CASE -36 'Mask
                    b$ = ReadSequential$(FormData$, 4)
                    b$ = ReadSequential$(FormData$, CVL(b$))
                    PreviewMasks(Dummy) = b$
                CASE -37
                    b$ = ReadSequential$(FormData$, LEN(FloatValue))
                    PreviewControls(Dummy).MinInterval = _CV(_FLOAT, b$)
                CASE -38
                    PreviewControls(Dummy).NumericOnly = TRUE
                CASE -39
                    PreviewControls(Dummy).NumericOnly = __UI_NumericWithBounds
                CASE -40
                    PreviewControls(Dummy).BulletStyle = __UI_Bullet
                CASE -41
                    PreviewControls(Dummy).AutoScroll = TRUE
                CASE -42
                    PreviewControls(Dummy).AutoSize = TRUE
                CASE -43
                    b$ = ReadSequential$(FormData$, 2)
                    PreviewControls(Dummy).BorderSize = CVI(b$)
                CASE -44 'Key combo
                    b$ = ReadSequential$(FormData$, 2)
                    b$ = ReadSequential$(FormData$, CVI(b$))
                    PreviewKeyCombos(Dummy) = b$
                CASE -45 'Animated Gif
                    PreviewAnimatedGif(Dummy) = TRUE
                    TotalGifLoaded = TotalGifLoaded + 1
                    AddGifExtension = TRUE
                    IF LoadedWithGifExtension = 1 THEN
                        LoadedWithGifExtension = TRUE
                        Control(AddGifExtensionToggle).Value = TRUE
                    END IF
                CASE -46 'Auto-play Gif
                    PreviewAutoPlayGif(Dummy) = TRUE
                CASE -47 'ControlIsSelected
                    PreviewControls(Dummy).ControlIsSelected = TRUE
                CASE -48 'BoundTo
                    b$ = ReadSequential$(FormData$, 2)
                    b$ = ReadSequential$(FormData$, CVI(b$))
                    PreviewBoundTo(Dummy) = b$
                    b$ = ReadSequential$(FormData$, 2)
                    b$ = ReadSequential$(FormData$, CVI(b$))
                    PreviewBoundProperty(Dummy) = b$
                CASE -1 'new control
                    EXIT DO
                CASE -1024
                    __UI_EOF = TRUE
                    EXIT DO
                CASE ELSE
                    EXIT DO
            END SELECT
        LOOP
    LOOP UNTIL __UI_EOF
    LoadError:
    TIMER(__UI_EventsTimer) ON
    TIMER(__UI_RefreshTimer) ON
    IF LoadedWithGifExtension = 1 THEN LoadedWithGifExtension = FALSE
    IF PrevTotalGifLoaded <> TotalGifLoaded THEN
        IF PrevTotalGifLoaded = 0 AND LoadedWithGifExtension = FALSE THEN
            _DELAY 0.2: Answer = _MESSAGEBOX(UiEditorTitle$, "You loaded an animated GIF file.\nDo you want to include the GIF extension?", "yesno", "question", 1)
            IF Answer = 1 THEN
                Control(AddGifExtensionToggle).Value = TRUE
            ELSE
                b$ = "PAUSEALLGIF>" + "<END>"
                Send Client, b$
                Control(AddGifExtensionToggle).Value = FALSE
            END IF
        END IF
        PrevTotalGifLoaded = TotalGifLoaded
    END IF
END SUB

SUB SendData (b$, Property AS INTEGER)
    'IF PreviewSelectionRectangle THEN EXIT SUB
    b$ = "PROPERTY>" + MKI$(Property) + b$ + "<END>"
    Send Client, b$
END SUB

SUB Send (channel AS LONG, b$)
    totalBytesSent = totalBytesSent + LEN(b$)
    PUT #channel, , b$
END SUB

SUB SendSignal (Value AS INTEGER)
    DIM b$
    b$ = "SIGNAL>" + MKI$(Value) + "<END>"
    Send Client, b$
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
    Control(ColorPreview).Redraw = TRUE 'Force update
END SUB

SUB QuickColorPreview (ThisColor AS _UNSIGNED LONG)
    _DEST Control(ColorPreview).HelperCanvas
    CLS , __UI_DefaultColor(__UI_Type_Form, 2)
    LINE (0, 0)-STEP(_WIDTH, _HEIGHT / 2), ThisColor, BF
    LINE (0, _HEIGHT / 2)-STEP(_WIDTH, _HEIGHT / 2), OldColor, BF
    _DEST 0
    Control(ColorPreview).Redraw = TRUE 'Force update
END SUB

SUB CheckPreview
    'Check if the preview window is still alive
    DIM b$

    IF OpenDialogOpen THEN EXIT SUB

    $IF WIN THEN
        DIM hnd&, b&, c&, ExitCode&
        IF UiPreviewPID > 0 THEN
            hnd& = OpenProcess(&H400, 0, UiPreviewPID)
            b& = GetExitCodeProcess(hnd&, ExitCode&)
            c& = CloseHandle(hnd&)
            IF b& = 1 AND ExitCode& = 259 THEN
                'Preview is active.
                Control(ViewMenuPreview).Disabled = TRUE
            ELSE
                'Preview was closed.

                TIMER(__UI_EventsTimer) OFF

                __UI_WaitMessage = "Reloading preview window..."
                UiPreviewPID = 0
                __UI_ProcessInputTimer = 0 'Make the "Please wait" message show up immediataly

                CLOSE Client
                Client = 0

                __UI_UpdateDisplay

                SHELL _DONTWAIT ".\InForm\UiEditorPreview.exe " + HostPort

                DO
                    Client = _OPENCONNECTION(Host)
                    IF Client THEN EXIT DO
                    IF _EXIT THEN SYSTEM 'Can't force user to wait...
                    _DISPLAY
                    _LIMIT 15
                LOOP

                Handshake

                IF LEN(LastFormData$) THEN
                    b$ = "RESTORECRASH>" + LastFormData$ + "<END>"
                    Send Client, b$
                    prevScreenX = -1
                    prevScreenY = -1
                    UndoPointer = 0
                    TotalUndoImages = 0
                END IF

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
            UiPreviewPID = 0
            __UI_ProcessInputTimer = 0 'Make the "Please wait" message show up immediataly

            CLOSE Client
            Client = 0

            __UI_UpdateDisplay

            SHELL _DONTWAIT "./InForm/UiEditorPreview " + HostPort

            DO
            Client = _OPENCONNECTION(Host)
            IF Client THEN EXIT DO
            IF _EXIT THEN SYSTEM 'Can't force user to wait...
            _DISPLAY
            _LIMIT 15
            LOOP

            Handshake

            IF LEN(LastFormData$) THEN
            b$ = "RESTORECRASH>" + LastFormData$ + "<END>"
            Send Client, b$
            prevScreenX = -1
            prevScreenY = -1
            UndoPointer = 0
            TotalUndoImages = 0
            END IF

            TIMER(__UI_EventsTimer) ON
            ELSE
            'Preview is active.
            Control(ViewMenuPreview).Disabled = True
            END IF
            END IF
    $END IF
END SUB

SUB SaveForm (ExitToQB64 AS _BYTE, SaveOnlyFrm AS _BYTE)
    DIM BaseOutputFileName AS STRING, j AS LONG
    DIM TextFileNum AS INTEGER, Answer AS _BYTE, b$, i AS LONG
    DIM a$, FontSetup$, FindSep AS INTEGER, NewFontFile AS STRING
    DIM Dummy AS LONG, BackupFile$
    DIM PreserveBackup AS _BYTE, BackupCode$
    DIM tempThisFileName$

    tempThisFileName$ = ThisFileName$
    IF UCASE$(RIGHT$(tempThisFileName$, 4)) = ".FRM" OR UCASE$(RIGHT$(tempThisFileName$, 4)) = ".BAS" THEN
        tempThisFileName$ = LEFT$(tempThisFileName$, LEN(tempThisFileName$) - 4)
    END IF

    BaseOutputFileName = CurrentPath$ + PathSep$ + tempThisFileName$

    IF (_FILEEXISTS(BaseOutputFileName + ".bas") AND SaveOnlyFrm = FALSE) AND _FILEEXISTS(BaseOutputFileName + ".frm") THEN
        b$ = "These files will be overwritten:" + CHR$(10) + "    "
        b$ = b$ + tempThisFileName$ + ".bas" + CHR$(10) + "    "
        b$ = b$ + tempThisFileName$ + ".frm" + CHR$(10)
        b$ = b$ + "Proceed?"
    ELSEIF (_FILEEXISTS(BaseOutputFileName + ".bas") AND SaveOnlyFrm = FALSE) AND _FILEEXISTS(BaseOutputFileName + ".frm") = 0 THEN
        b$ = "'" + tempThisFileName$ + ".bas" + "' will be overwritten." + CHR$(10)
        b$ = b$ + "Proceed?"
    ELSEIF _FILEEXISTS(BaseOutputFileName + ".frm") THEN
        b$ = "'" + tempThisFileName$ + ".frm" + "' will be overwritten." + CHR$(10)
        b$ = b$ + "Proceed?"
    END IF

    IF LEN(b$) > 0 THEN
        _DELAY 0.2: Answer = _MESSAGEBOX(UiEditorTitle$, b$, "yesno", "question", 0)
        IF Answer = 0 THEN EXIT SUB
    END IF

    AddGifExtension = Control(AddGifExtensionToggle).Value

    IF (AddGifExtension OR Control(AddGifExtensionToggle).Value) AND LoadedWithGifExtension = FALSE AND TotalGifLoaded = 0 THEN
        _DELAY 0.2: Answer = _MESSAGEBOX(UiEditorTitle$, "Are you sure you want to include the GIF extension?\n(no animated GIFs have been added to this form)", "yesno", "question", 0)
        AddGifExtension = (Answer = 1)
    END IF

    AddToRecentList BaseOutputFileName + ".frm"

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
            OPEN BackupFile$ + "-backup" FOR OUTPUT AS #TextFileNum: CLOSE #TextFileNum
            OPEN BackupFile$ + "-backup" FOR BINARY AS #TextFileNum
            PUT #TextFileNum, 1, b$
            CLOSE #TextFileNum

            IF i = 1 THEN
                BackupCode$ = Replace$(b$, CHR$(13) + CHR$(10), CHR$(10), 0, 0)
                PreserveBackup = TRUE
            END IF
        END IF
    NEXT

    '.FRM file
    TextFileNum = FREEFILE
    OPEN BaseOutputFileName + ".frm" FOR OUTPUT AS #TextFileNum
    PRINT #TextFileNum, "': This form was generated by"
    PRINT #TextFileNum, "': InForm GUI engine for QB64-PE - v"; __UI_Version
    PRINT #TextFileNum, "': Fellippe Heitor, (2016 - 2022) - @FellippeHeitor"
    PRINT #TextFileNum, "': Samuel Gomes, (2023 - 2024) - @a740g"
    PRINT #TextFileNum, "': https://github.com/a740g/InForm-PE"
    PRINT #TextFileNum, "'-----------------------------------------------------------"
    PRINT #TextFileNum, "SUB __UI_LoadForm"
    PRINT #TextFileNum,
    IF LEN(PreviewTexts(PreviewFormID)) > 0 THEN
        PRINT #TextFileNum, "    $EXEICON:'" + PreviewTexts(PreviewFormID) + "'"
    END IF
    IF PreviewControls(PreviewFormID).CanResize THEN
        PRINT #TextFileNum, "    $RESIZE:ON"
    END IF
    PRINT #TextFileNum, "    DIM __UI_NewID AS LONG, __UI_RegisterResult AS LONG"
    PRINT #TextFileNum,

    'First pass is for the main form and containers (frames and menubars).
    'Second pass is for the rest of controls.
    'Controls named __UI_+anything are ignored, as they are automatically created.
    DIM ThisPass AS _BYTE, AddContextMenuToForm AS STRING
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
                    CASE __UI_Type_ContextMenu: a$ = a$ + "__UI_Type_ContextMenu, ": IF ThisPass = 2 THEN GOTO EndOfThisPass
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
                PRINT #TextFileNum, "    __UI_RegisterResult = 0"

                IF PreviewControls(i).Type = __UI_Type_ContextMenu THEN
                    PRINT #TextFileNum,
                    IF LEN(AddContextMenuToForm) > 0 AND RTRIM$(PreviewControls(i).Name) = AddContextMenuToForm THEN
                        PRINT #TextFileNum, "    Control(__UI_FormID).ContextMenuID = __UI_GetID(" + CHR$(34) + AddContextMenuToForm + CHR$(34) + ")"
                        PRINT #TextFileNum,
                        AddContextMenuToForm = ""
                    END IF
                    _CONTINUE
                END IF

                IF PreviewDefaultButtonID = i THEN
                    PRINT #TextFileNum, "    __UI_DefaultButtonID = __UI_NewID"
                END IF

                IF LEN(PreviewCaptions(i)) > 0 THEN
                    SELECT CASE PreviewControls(i).Type
    CASE __UI_Type_Form, __UI_Type_Frame, __UI_Type_Button, _
    __UI_Type_Label, __UI_Type_CheckBox, __UI_Type_RadioButton, _
        __UI_Type_TextBox, __UI_Type_ProgressBar, __UI_Type_MenuBar, _
        __UI_Type_MenuItem
                            a$ = "    SetCaption __UI_NewID, " + SpecialCharsToEscapeCode$(PreviewCaptions(i))
                            PRINT #TextFileNum, a$
                    END SELECT
                END IF

                IF LEN(PreviewTips(i)) > 0 THEN
                    a$ = "    ToolTip(__UI_NewID) = " + SpecialCharsToEscapeCode$(PreviewTips(i))
                    PRINT #TextFileNum, a$
                END IF

                IF LEN(PreviewTexts(i)) > 0 THEN
                    SELECT CASE PreviewControls(i).Type
                        CASE __UI_Type_ListBox, __UI_Type_DropdownList
                            DIM TempCaption$, TempText$, ThisItem%
                            DIM findLF&

                            TempText$ = PreviewTexts(i)
                            ThisItem% = 0
                            DO WHILE LEN(TempText$)
                                ThisItem% = ThisItem% + 1
                                findLF& = INSTR(TempText$, CHR$(10))
                                IF findLF& THEN
                                    TempCaption$ = LEFT$(TempText$, findLF& - 1)
                                    TempText$ = MID$(TempText$, findLF& + 1)
                                ELSE
                                    TempCaption$ = TempText$
                                    TempText$ = ""
                                END IF
                                a$ = "    AddItem __UI_NewID, " + CHR$(34) + TempCaption$ + CHR$(34)
                                PRINT #TextFileNum, a$
                            LOOP
                        CASE __UI_Type_PictureBox, __UI_Type_Button, __UI_Type_MenuItem
                            IF AddGifExtension AND PreviewAnimatedGif(i) THEN
                                a$ = "    __UI_RegisterResult = GIF_LoadFromFile(__UI_NewID, " + CHR$(34) + PreviewTexts(i) + CHR$(34) + ")"
                            ELSE
                                a$ = "    LoadImage Control(__UI_NewID), " + CHR$(34) + PreviewTexts(i) + CHR$(34)
                            END IF
                            PRINT #TextFileNum, a$

                            IF AddGifExtension AND PreviewAutoPlayGif(i) THEN
                                a$ = "    IF __UI_RegisterResult THEN GIF_Play __UI_NewID"
                                PRINT #TextFileNum, a$
                            END IF
                        CASE ELSE
                            IF PreviewControls(i).Type = __UI_Type_TextBox AND PreviewControls(i).NumericOnly <> 0 THEN
                                'skip saving Text() for NumericTextBox controls
                            ELSE
                                a$ = "    Text(__UI_NewID) = " + SpecialCharsToEscapeCode$(PreviewTexts(i))
                                PRINT #TextFileNum, a$
                            END IF
                    END SELECT
                END IF
                IF LEN(PreviewMasks(i)) > 0 THEN
                    a$ = "    Mask(__UI_NewID) = " + SpecialCharsToEscapeCode$(PreviewMasks(i))
                    PRINT #TextFileNum, a$
                END IF
                IF PreviewControls(i).TransparentColor > 0 THEN
                    PRINT #TextFileNum, "    __UI_ClearColor Control(__UI_NewID).HelperCanvas, " + LTRIM$(STR$(PreviewControls(i).TransparentColor)) + ", -1"
                END IF
                IF PreviewControls(i).Stretch = TRUE THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).Stretch = True"
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
                ELSE
                    PRINT #TextFileNum, "    Control(__UI_NewID).HasBorder = False"
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
                IF PreviewControls(i).PasswordField = TRUE AND PreviewControls(i).Type = __UI_Type_TextBox THEN
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
                IF LEN(PreviewContextMenu(i)) THEN
                    IF PreviewControls(i).Type = __UI_Type_Form THEN
                        AddContextMenuToForm = PreviewContextMenu(i)
                    ELSE
                        PRINT #TextFileNum, "    Control(__UI_NewID).ContextMenuID = __UI_GetID(" + CHR$(34) + PreviewContextMenu(i) + CHR$(34) + ")"
                    END IF
                END IF
                IF LEN(PreviewKeyCombos(i)) THEN
                    PRINT #TextFileNum, "    __UI_RegisterResult = RegisterKeyCombo(" + CHR$(34) + PreviewKeyCombos(i) + CHR$(34) + ", __UI_NewID)"
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
                IF PreviewControls(i).BorderSize > 0 THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).BorderSize = " + LTRIM$(STR$(PreviewControls(i).BorderSize))
                END IF
                IF PreviewControls(i).Encoding > 0 THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).Encoding = " + LTRIM$(STR$(PreviewControls(i).Encoding))
                END IF
                IF PreviewControls(i).NumericOnly = TRUE THEN
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
                IF PreviewControls(i).AutoScroll THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).AutoScroll = True"
                END IF
                IF PreviewControls(i).AutoSize THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).AutoSize = True"
                END IF
                PRINT #TextFileNum,
            END IF
            EndOfThisPass:
        NEXT
    NEXT ThisPass

    'Save control bindings
    DIM BindingsSection AS _BYTE
    DIM BindingDone(0 TO UBOUND(PreviewControls)) AS _BYTE
    FOR i = 1 TO UBOUND(PreviewControls)
        IF LEN(PreviewBoundTo(i)) > 0 AND BindingDone(i) = FALSE THEN
            IF BindingsSection = FALSE THEN
                PRINT #TextFileNum, "    'Control bindings:"
                BindingsSection = TRUE
            END IF
            BindingDone(i) = TRUE
            PRINT #TextFileNum, "    __UI_Bind __UI_GetID(" + CHR$(34);
            PRINT #TextFileNum, RTRIM$(__UI_TrimAt0$(PreviewControls(i).Name)) + CHR$(34) + "), ";
            PRINT #TextFileNum, "__UI_GetID(" + CHR$(34);
            PRINT #TextFileNum, PreviewBoundTo(i) + CHR$(34) + "), ";
            PRINT #TextFileNum, CHR$(34) + PreviewBoundProperty(i) + CHR$(34) + ", ";
            FOR j = 1 TO UBOUND(PreviewControls)
                IF PreviewBoundTo(j) = RTRIM$(__UI_TrimAt0$(PreviewControls(i).Name)) THEN
                    BindingDone(j) = TRUE
                    PRINT #TextFileNum, CHR$(34) + PreviewBoundProperty(j) + CHR$(34)
                    EXIT FOR
                END IF
            NEXT
        END IF
    NEXT

    PRINT #TextFileNum, "END SUB"
    PRINT #TextFileNum,
    PRINT #TextFileNum, "SUB __UI_AssignIDs"
    FOR i = 1 TO UBOUND(PreviewControls)
        IF PreviewControls(i).ID > 0 AND PreviewControls(i).Type <> __UI_Type_Font AND PreviewControls(i).Type <> __UI_Type_MenuPanel THEN
            PRINT #TextFileNum, "    " + RTRIM$(__UI_TrimAt0$(PreviewControls(i).Name)) + " = __UI_GetID(" + CHR$(34) + RTRIM$(__UI_TrimAt0$(PreviewControls(i).Name)) + CHR$(34) + ")"
        END IF
    NEXT
    PRINT #TextFileNum, "END SUB"
    CLOSE #TextFileNum

    '.BAS file
    IF NOT SaveOnlyFrm THEN
        IF PreserveBackup THEN
            DIM insertionPoint AS LONG, endPoint AS LONG, firstCASE AS LONG
            DIM insertionPoint2 AS LONG, endPoint2 AS LONG
            DIM temp$, thisBlock$, addedItems$, indenting AS LONG
            DIM checkConditionResult AS _BYTE, controlToRemove$, found AS _BYTE
            DIM charSep$

            charSep$ = " =<>+-/\^:;,*()'" + CHR$(10)

            'Check which controls got removed/renamed since this form was loaded
            IF LEN(InitialControlSet) THEN
                insertionPoint2 = INSTR(InitialControlSet, CHR$(10))
                DO
                    endPoint2 = INSTR(insertionPoint2 + 1, InitialControlSet, CHR$(10))
                    thisBlock$ = MID$(InitialControlSet, insertionPoint2 + 1, endPoint2 - insertionPoint2 - 1)
                    temp$ = thisBlock$
                    controlToRemove$ = ""

                    IF INSTR(temp$, CHR$(11)) THEN
                        'control was in the initial state but got renamed
                        controlToRemove$ = LEFT$(temp$, INSTR(temp$, CHR$(11)) - 1)
                        temp$ = MID$(temp$, INSTR(temp$, CHR$(11)) + 1)
                    ELSE
                        controlToRemove$ = temp$
                    END IF

                    found = FALSE
                    FOR i = 1 TO UBOUND(PreviewControls)
                        IF PreviewControls(i).ID > 0 AND PreviewControls(i).Type <> __UI_Type_Font AND PreviewControls(i).Type <> __UI_Type_MenuPanel THEN
                            IF LCASE$(RTRIM$(PreviewControls(i).Name)) = LCASE$(temp$) THEN
                                found = TRUE
                                EXIT FOR
                            END IF
                        END IF
                    NEXT

                    IF found THEN
                        IF INSTR(thisBlock$, CHR$(11)) THEN
                            'controlToRemove$ was in the initial state but got renamed to temp$
                            insertionPoint = INSTR(BackupCode$, controlToRemove$)
                            DO WHILE insertionPoint > 0
                                found = TRUE
                                IF OutsideQuotes(BackupCode$, insertionPoint) THEN
                                    a$ = MID$(BackupCode$, insertionPoint - 1, 1)
                                    b$ = MID$(BackupCode$, insertionPoint + LEN(controlToRemove$), 1)
                                    IF LEN(a$) > 0 AND INSTR(charSep$, a$) = 0 THEN found = FALSE
                                    IF LEN(b$) > 0 AND INSTR(charSep$, b$) = 0 THEN found = FALSE
                                    IF found THEN
                                        BackupCode$ = LEFT$(BackupCode$, insertionPoint - 1) + temp$ + MID$(BackupCode$, insertionPoint + LEN(controlToRemove$))
                                    END IF
                                END IF
                                insertionPoint = INSTR(insertionPoint + 1, BackupCode$, controlToRemove$)
                            LOOP
                        END IF
                    ELSE
                        'comment next controlToRemove$ occurrences, since the control no longer exists
                        insertionPoint = INSTR(BackupCode$, controlToRemove$)
                        DO WHILE insertionPoint > 0
                            found = TRUE
                            COLOR 8: PRINT insertionPoint, MID$(BackupCode$, insertionPoint, 30)
                            IF OutsideQuotes(BackupCode$, insertionPoint) THEN
                                a$ = MID$(BackupCode$, insertionPoint - 1, 1)
                                b$ = MID$(BackupCode$, insertionPoint + LEN(controlToRemove$), 1)
                                IF LEN(a$) > 0 AND INSTR(charSep$, a$) = 0 THEN found = FALSE
                                IF LEN(b$) > 0 AND INSTR(charSep$, b$) = 0 THEN found = FALSE
                                IF found THEN
                                    endPoint = INSTR(insertionPoint, BackupCode$, CHR$(10))
                                    IF endPoint = 0 THEN endPoint = LEN(BackupCode$)
                                    temp$ = " '<-- " + CHR$(34) + controlToRemove$ + CHR$(34) + " deleted from Form on " + DATE$
                                    BackupCode$ = LEFT$(BackupCode$, endPoint - 1) + temp$ + MID$(BackupCode$, endPoint)
                                    COLOR 14: PRINT insertionPoint, MID$(BackupCode$, insertionPoint, 30)
                                END IF
                            END IF
                            SLEEP
                            insertionPoint = INSTR(insertionPoint + 1, BackupCode$, controlToRemove$)
                        LOOP
                    END IF

                    insertionPoint2 = endPoint2 + 1
                LOOP WHILE insertionPoint2 < LEN(InitialControlSet)
            END IF

            'Find insertion points in BackupCode$ for eventual new controls
            '1- Controls' IDs
            addedItems$ = ""
            FOR i = 1 TO UBOUND(PreviewControls)
                IF PreviewControls(i).ID > 0 AND PreviewControls(i).Type <> __UI_Type_Font AND PreviewControls(i).Type <> __UI_Type_MenuPanel THEN
                    temp$ = "DIM SHARED " + RTRIM$(__UI_TrimAt0$(PreviewControls(i).Name)) + " AS LONG"
                    IF INSTR(BackupCode$, temp$) = 0 THEN
                        addedItems$ = addedItems$ + temp$ + CHR$(10)
                    END IF
                END IF
            NEXT

            insertionPoint = INSTR(BackupCode$, "DIM SHARED ")
            IF LEN(addedItems$) THEN
                BackupCode$ = LEFT$(BackupCode$, insertionPoint - 1) + addedItems$ + MID$(BackupCode$, insertionPoint)
            END IF

            '2- Remove "control deleted" comments, if any has been readded.
            FOR i = 1 TO UBOUND(PreviewControls)
                IF PreviewControls(i).ID > 0 AND PreviewControls(i).Type <> __UI_Type_Font AND PreviewControls(i).Type <> __UI_Type_MenuPanel THEN
                    temp$ = " '<-- " + CHR$(34) + RTRIM$(__UI_TrimAt0$(PreviewControls(i).Name)) + CHR$(34) + " deleted from Form on"
                    insertionPoint = INSTR(BackupCode$, temp$)
                    DO WHILE insertionPoint > 0
                        endPoint = INSTR(insertionPoint, BackupCode$, CHR$(10))
                        BackupCode$ = LEFT$(BackupCode$, insertionPoint - 1) + MID$(BackupCode$, endPoint)
                        insertionPoint = INSTR(BackupCode$, temp$)
                    LOOP
                END IF
            NEXT

            '3- Even procedures
            FOR i = 4 TO 13
                SELECT EVERYCASE i
                    CASE 4: temp$ = "SUB __UI_Click (id AS LONG)"
                    CASE 5: temp$ = "SUB __UI_MouseEnter (id AS LONG)"
                    CASE 6: temp$ = "SUB __UI_MouseLeave (id AS LONG)"
                    CASE 7: temp$ = "SUB __UI_FocusIn (id AS LONG)"
                    CASE 8: temp$ = "SUB __UI_FocusOut (id AS LONG)"
                    CASE 9: temp$ = "SUB __UI_MouseDown (id AS LONG)"
                    CASE 10: temp$ = "SUB __UI_MouseUp (id AS LONG)"
                    CASE 11: temp$ = "SUB __UI_KeyPress (id AS LONG)"
                    CASE 12: temp$ = "SUB __UI_TextChanged (id AS LONG)"
                    CASE 13: temp$ = "SUB __UI_ValueChanged (id AS LONG)"

                    CASE 4 TO 13
                        insertionPoint = INSTR(BackupCode$, temp$)
                        endPoint = INSTR(insertionPoint, BackupCode$, "END SUB" + CHR$(10)) + 8
                        thisBlock$ = MID$(BackupCode$, insertionPoint, endPoint - insertionPoint)

                        IF INSTR(thisBlock$, "SELECT CASE id") THEN
                            firstCASE = INSTR(thisBlock$, "    CASE ")
                            IF firstCASE THEN
                                firstCASE = _INSTRREV(firstCASE, thisBlock$, CHR$(10))
                                indenting = INSTR(firstCASE, thisBlock$, "CASE ") - firstCASE - 1
                            ELSE
                                indenting = 8
                                firstCASE = _INSTRREV(INSTR(thisBlock$, "END SELECT"), thisBlock$, CHR$(10))
                            END IF
                            addedItems$ = ""
                            FOR Dummy = 1 TO UBOUND(PreviewControls)
                                GOSUB checkCondition
                                IF checkConditionResult THEN
                                    IF INSTR(thisBlock$, " CASE " + RTRIM$(PreviewControls(Dummy).Name) + CHR$(10)) = 0 AND INSTR(thisBlock$, " CASE " + RTRIM$(PreviewControls(Dummy).Name) + " '<-- " + CHR$(34) + RTRIM$(PreviewControls(Dummy).Name) + CHR$(34) + " deleted from Form on ") = 0 THEN
                                        addedItems$ = addedItems$ + SPACE$(indenting) + "CASE " + RTRIM$(PreviewControls(Dummy).Name) + CHR$(10) + CHR$(10)
                                    ELSEIF INSTR(thisBlock$, " CASE " + RTRIM$(PreviewControls(Dummy).Name) + " '<-- " + CHR$(34) + RTRIM$(PreviewControls(Dummy).Name) + CHR$(34) + " deleted from Form on ") > 0 THEN
                                        thisBlock$ = LEFT$(thisBlock$, INSTR(thisBlock$, " CASE " + RTRIM$(PreviewControls(Dummy).Name) + " '<-- " + CHR$(34)) + 5 + LEN(RTRIM$(PreviewControls(Dummy).Name))) + MID$(thisBlock$, INSTR(INSTR(thisBlock$, " CASE " + RTRIM$(PreviewControls(Dummy).Name) + " '<-- " + CHR$(34) + RTRIM$(PreviewControls(Dummy).Name) + CHR$(34) + " deleted from Form on "), thisBlock$, CHR$(10)))
                                    END IF
                                END IF
                            NEXT

                            IF LEN(addedItems$) THEN
                                thisBlock$ = LEFT$(thisBlock$, firstCASE) + addedItems$ + MID$(thisBlock$, firstCASE + 1)
                            END IF

                            BackupCode$ = LEFT$(BackupCode$, insertionPoint - 1) + thisBlock$ + MID$(BackupCode$, endPoint)
                        END IF
                END SELECT
            NEXT

            OPEN BaseOutputFileName + ".bas" FOR OUTPUT AS #TextFileNum: CLOSE #TextFileNum
            OPEN BaseOutputFileName + ".bas" FOR BINARY AS #TextFileNum
            PUT #TextFileNum, , BackupCode$
        ELSE
            OPEN BaseOutputFileName + ".bas" FOR OUTPUT AS #TextFileNum
            PRINT #TextFileNum, "': This program uses"
            PRINT #TextFileNum, "': InForm GUI engine for QB64-PE - v"; __UI_Version
            PRINT #TextFileNum, "': Fellippe Heitor, (2016 - 2022) - @FellippeHeitor"
            PRINT #TextFileNum, "': Samuel Gomes, (2023 - 2024) - @a740g"
            PRINT #TextFileNum, "': https://github.com/a740g/InForm-PE"
            PRINT #TextFileNum, "'-----------------------------------------------------------"
            PRINT #TextFileNum,
            PRINT #TextFileNum, "': Controls' IDs: ------------------------------------------------------------------"
            FOR i = 1 TO UBOUND(PreviewControls)
                IF PreviewControls(i).ID > 0 AND PreviewControls(i).Type <> __UI_Type_Font AND PreviewControls(i).Type <> __UI_Type_MenuPanel THEN
                    PRINT #TextFileNum, "DIM SHARED " + RTRIM$(__UI_TrimAt0$(PreviewControls(i).Name)) + " AS LONG"
                END IF
            NEXT
            PRINT #TextFileNum,
            PRINT #TextFileNum, "': External modules: ---------------------------------------------------------------"
            IF AddGifExtension THEN
                PRINT #TextFileNum, "'$INCLUDE:'InForm/extensions/GIFPlay.bi'"
            END IF
            PRINT #TextFileNum, "'$INCLUDE:'InForm\InForm.bi'"
            PRINT #TextFileNum, "'$INCLUDE:'InForm\xp.uitheme'"
            PRINT #TextFileNum, "'$INCLUDE:'" + MID$(BaseOutputFileName, LEN(CurrentPath$) + 2) + ".frm'"
            IF AddGifExtension THEN
                PRINT #TextFileNum, "'$INCLUDE:'InForm/extensions/GIFPlay.bas'"
            END IF
            PRINT #TextFileNum,
            PRINT #TextFileNum, "': Event procedures: ---------------------------------------------------------------"
            FOR i = 0 TO 14
                SELECT EVERYCASE i
                    CASE 0: PRINT #TextFileNum, "SUB __UI_BeforeInit"
                    CASE 1: PRINT #TextFileNum, "SUB __UI_OnLoad"
                    CASE 2
                        PRINT #TextFileNum, "SUB __UI_BeforeUpdateDisplay"
                        PRINT #TextFileNum, "    'This event occurs at approximately 60 frames per second."
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

                    CASE 0, 3, 14
                        PRINT #TextFileNum,

                    CASE 1
                        IF PreviewDefaultButtonID > 0 THEN
                            PRINT #TextFileNum, "    __UI_DefaultButtonID = " + RTRIM$(__UI_TrimAt0$(PreviewControls(PreviewDefaultButtonID).Name))
                        ELSE
                            PRINT #TextFileNum,
                        END IF

                    CASE 2
                        IF AddGifExtension = TRUE AND TotalGifLoaded > 0 THEN
                            PRINT #TextFileNum,
                            PRINT #TextFileNum, "    'The lines below ensure your GIFs will display properly;"
                            PRINT #TextFileNum, "    'Please refer to the documentation in 'docs/GIFPlay.md'"
                            FOR Dummy = 1 TO UBOUND(PreviewControls)
                                IF PreviewAnimatedGif(Dummy) THEN
                                    PRINT #TextFileNum, "    GIF_Draw " + RTRIM$(PreviewControls(Dummy).Name)
                                END IF
                            NEXT
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
        END IF
        PRINT #TextFileNum, "'$INCLUDE:'InForm/InForm.ui'"
        CLOSE #TextFileNum
    END IF

    AddToRecentList BaseOutputFileName + ".frm"

    b$ = "Exporting successful. Files output:" + CHR$(10)
    IF NOT SaveOnlyFrm THEN b$ = b$ + "    " + MID$(BaseOutputFileName, LEN(CurrentPath$) + 2) + ".bas" + CHR$(10)
    b$ = b$ + "    " + MID$(BaseOutputFileName, LEN(CurrentPath$) + 2) + ".frm"

    IF ExitToQB64 AND NOT SaveOnlyFrm THEN
        IF _FILEEXISTS(QB64_EXE_PATH) THEN
            b$ = b$ + CHR$(10) + CHR$(10) + "Exit to " + QB64_DISPLAY + "?"
            _DELAY 0.2: Answer = _MESSAGEBOX(UiEditorTitle$, b$, "yesno", "question", 0)
            IF Answer = 0 THEN Edited = FALSE: EXIT SUB
            IF _FILEEXISTS("InForm/UiEditorPreview.frmbin") THEN KILL "InForm/UiEditorPreview.frmbin"
            SHELL _DONTWAIT QB64_EXE_PATH + " " + QuotedFilename$(BaseOutputFileName + ".bas")
            SYSTEM
        ELSE
            b$ = b$ + CHR$(10) + CHR$(10) + "Close the editor?"
            _DELAY 0.2: Answer = _MESSAGEBOX(UiEditorTitle$, b$, "yesno", "question", 0)
            IF Answer = 0 THEN Edited = FALSE: EXIT SUB
        END IF
    ELSE
        MessageBox b$, UiEditorTitle$, MsgBox_Information
        Edited = FALSE
    END IF

    EXIT SUB

    checkCondition:
    checkConditionResult = FALSE
    SELECT CASE i
        CASE 4 TO 6, 9, 10 'All controls except for Menu panels, and internal context menus
            IF PreviewControls(Dummy).ID > 0 AND PreviewControls(Dummy).Type <> __UI_Type_Font AND PreviewControls(Dummy).Type <> __UI_Type_ContextMenu THEN
                checkConditionResult = TRUE
            END IF

        CASE 7, 8, 11 'Controls that can have focus only
            IF PreviewControls(Dummy).ID > 0 AND PreviewControls(Dummy).CanHaveFocus THEN
                checkConditionResult = TRUE
            END IF

        CASE 12 'Text boxes
            IF PreviewControls(Dummy).ID > 0 AND (PreviewControls(Dummy).Type = __UI_Type_TextBox) THEN
                checkConditionResult = TRUE
            END IF

        CASE 13 'Dropdown list, List box, Track bar, ToggleSwitch, CheckBox
            IF PreviewControls(Dummy).ID > 0 AND (PreviewControls(Dummy).Type = __UI_Type_ListBox OR PreviewControls(Dummy).Type = __UI_Type_DropdownList OR PreviewControls(Dummy).Type = __UI_Type_TrackBar OR PreviewControls(Dummy).Type = __UI_Type_ToggleSwitch OR PreviewControls(Dummy).Type = __UI_Type_CheckBox OR PreviewControls(Dummy).Type = __UI_Type_RadioButton) THEN
                checkConditionResult = TRUE
            END IF
    END SELECT
    RETURN

END SUB

$IF WIN THEN
    SUB LoadFontList
        DIM hKey AS _OFFSET
        DIM Ky AS _OFFSET
        DIM SubKey AS STRING
        DIM Value AS STRING
        DIM bData AS STRING
        DIM dwType AS _UNSIGNED LONG
        DIM numBytes AS _UNSIGNED LONG
        DIM numTchars AS _UNSIGNED LONG
        DIM l AS LONG
        DIM dwIndex AS _UNSIGNED LONG

        hKey = hKey 'no warnings on my watch
        Ky = HKEY_LOCAL_MACHINE
        SubKey = "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" + CHR$(0)
        Value = SPACE$(261) 'ANSI Value name limit 260 chars + 1 null
        bData = SPACE$(&H7FFF) 'arbitrary

        HasFontList = TRUE
        AddItem FontList, "Built-in VGA font"
        TotalFontsFound = 1

        l = RegOpenKeyExA(Ky, _OFFSET(SubKey), 0, KEY_READ, _OFFSET(hKey))
        IF l THEN
            'HasFontList = False
            EXIT SUB
        ELSE
            dwIndex = 0
            DO
                numBytes = LEN(bData)
                numTchars = LEN(Value)
                l = RegEnumValueA(hKey, dwIndex, _OFFSET(Value), _OFFSET(numTchars), 0, _OFFSET(dwType), _OFFSET(bData), _OFFSET(numBytes))
                IF l THEN
                    IF l <> ERROR_NO_MORE_ITEMS THEN
                        'HasFontList = False
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
        hKey = hKey 'the lengths I'll go not to have warnings....
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
$ELSE
        SUB LoadFontList
        DIM TotalFiles%, FontPath$, i AS LONG, ThisFont$, depth%, x AS INTEGER

        FontPath$ = "/usr/share/fonts"
        depth% = 2
        IF INSTR(_OS$, "MAC") > 0 THEN
        FontPath$ = "/Library/Fonts"
        depth% = 1
        END IF
        Text(FontList) = idezfilelist$(FontPath$, 1, depth%, TotalFiles%)
        Control(FontList).Max = TotalFiles%
        Control(FontList).LastVisibleItem = 0 'Reset it so it's recalculated

        TotalFontsFound = TotalFiles%
        FOR i = TotalFiles% TO 1 STEP -1
        ThisFont$ = GetItem(FontList, i)
        IF UCASE$(RIGHT$(ThisFont$, 4)) = ".TTF" OR UCASE$(RIGHT$(ThisFont$, 4)) = ".TTC" OR UCASE$(RIGHT$(ThisFont$, 4)) = ".OTF" THEN
        'Valid font
        ELSE
        RemoveItem FontList, i
        TotalFontsFound = TotalFontsFound - 1
        END IF
        NEXT

        TotalFontsFound = TotalFontsFound + 1
        Text(FontList) = "Built-in VGA font" + CHR$(10) + Text(FontList)
        Control(FontList).Max = TotalFontsFound

        REDIM FontFile(TotalFontsFound) AS STRING
        IF INSTR(_OS$, "MAC") = 0 THEN FontPath$ = "" ELSE FontPath$ = FontPath$ + "/"
        FOR i = 3 TO TotalFontsFound
        ThisFont$ = GetItem(FontList, i)
        FontFile(i) = FontPath$ + GetItem(FontList, i)
        ThisFont$ = LEFT$(ThisFont$, LEN(ThisFont$) - 4) 'Remove extension from list

        FOR x = LEN(ThisFont$) TO 1 STEP -1
        IF ASC(ThisFont$, x) = 47 THEN '"/"
        ThisFont$ = MID$(ThisFont$, x + 1)
        EXIT FOR
        END IF
        NEXT

        ReplaceItem FontList, i, ThisFont$
        NEXT

        FOR i = 8 TO 120
        AddItem FontSizeList, LTRIM$(STR$(i))
        NEXT

        HasFontList = True
        END SUB
$END IF

'FUNCTION idezfilelist$ and idezpathlist$ (and helper functions) were
'adapted from ide_methods.bas (QB64):
FUNCTION idezfilelist$ (path$, method, depth%, TotalFound AS INTEGER) 'method0=*.frm and *.frmbin, method1=*.*
    DIM sep AS STRING * 1, filelist$, a$, dummy%
    sep = CHR$(10)

    TotalFound = 0
    dummy% = depth%
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
            IF i = 1 THEN SHELL _HIDE "find " + QuotedFilename$(path$) + " -maxdepth " + LTRIM$(STR$(depth%)) + " -type f -name " + CHR$(34) + "*.frm*" + CHR$(34) + " >opendlgfiles.dat"
            IF i = 2 THEN SHELL _HIDE "find " + QuotedFilename$(path$) + " -maxdepth " + LTRIM$(STR$(depth%)) + " -type f -name " + CHR$(34) + "*.FRM*" + CHR$(34) + " >opendlgfiles.dat"
            END IF
            IF method = 1 THEN
            IF i = 1 THEN SHELL _HIDE "find " + QuotedFilename$(path$) + " -maxdepth " + LTRIM$(STR$(depth%)) + " -type f -name " + CHR$(34) + "*" + CHR$(34) + " >opendlgfiles.dat"
            END IF
            OPEN "opendlgfiles.dat" FOR INPUT AS #150
            DO UNTIL EOF(150)
            LINE INPUT #150, a$
            IF LEN(a$) = 0 THEN EXIT DO
            IF depth% = 1 THEN
            FOR x = LEN(a$) TO 1 STEP -1
            a2$ = MID$(a$, x, 1)
            IF a2$ = "/" THEN
            a$ = RIGHT$(a$, LEN(a$) - x)
            EXIT FOR
            END IF
            NEXT
            END IF
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
    sep = CHR$(10)

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

'---------------------------------------------------------------------------------
FUNCTION SpecialCharsToEscapeCode$ (Text$)
    DIM i AS LONG, Temp$

    Temp$ = CHR$(34)
    FOR i = 1 TO LEN(Text$)
        IF ASC(Text$, i) < 32 OR ASC(Text$, i) = 34 OR ASC(Text$, i) = 92 THEN
            Temp$ = Temp$ + "\" + LTRIM$(STR$(ASC(Text$, i))) + ";"
        ELSE
            Temp$ = Temp$ + MID$(Text$, i, 1)
        END IF
    NEXT
    SpecialCharsToEscapeCode$ = Temp$ + CHR$(34)
END FUNCTION

'---------------------------------------------------------------------------------
FUNCTION OutsideQuotes%% (text$, position AS LONG)
    DIM quote%%
    DIM start AS LONG
    DIM i AS LONG

    start = _INSTRREV(position, text$, CHR$(10)) + 1
    quote%% = FALSE
    FOR i = start TO position
        IF ASC(text$, i) = 34 THEN quote%% = NOT quote%%
        IF ASC(text$, i) = 10 THEN EXIT FOR
    NEXT
    OutsideQuotes%% = NOT quote%%
END FUNCTION
