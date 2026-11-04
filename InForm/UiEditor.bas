'-----------------------------------------------------------------------------------------------------------------------
' InForm-PE GUI engine for QB64-PE
' Copyright (c) 2026 QB64 Phoenix Edition Team
' Copyright (c) 2023 George McGinn
' Copyright (c) 2022 Fellippe Heitor
'-----------------------------------------------------------------------------------------------------------------------

OPTION _EXPLICIT

$VERSIONINFO:CompanyName='QB64 Phoenix Edition Team'
$VERSIONINFO:FileDescription='InForm-PE Form Designer executable'
$VERSIONINFO:InternalName='UiEditor'
$VERSIONINFO:LegalCopyright='Copyright (c) 2025 QB64 Phoenix Edition Team'
$VERSIONINFO:LegalTrademarks='All trademarks are property of their respective owners'
$VERSIONINFO:OriginalFilename='UiEditor.exe'
$VERSIONINFO:ProductName='InForm-PE Form Designer'
$VERSIONINFO:Web='https://github.com/QB64-Phoenix-Edition/InForm-PE'
$VERSIONINFO:Comments='https://github.com/QB64-Phoenix-Edition/InForm-PE'
$VERSIONINFO:FILEVERSION#=1,5,8,0
$VERSIONINFO:PRODUCTVERSION#=1,5,8,0
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
DIM SHARED DialogBG AS LONG
DIM SHARED Toolbox AS LONG, ColorMixer AS LONG, ZOrdering AS LONG
DIM SHARED ControlProperties AS LONG, ControlToggles AS LONG, SetControlBinding AS LONG

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
DIM SHARED FileMenuRecentRemoveMissing AS LONG

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
DIM SHARED ViewMenuThemeXP AS LONG, ViewMenuThemeLight AS LONG, ViewMenuThemeDark AS LONG, ViewMenuThemeFile AS LONG
DIM SHARED ViewMenuThemeEdit AS LONG
DIM SHARED PreviewTheme AS STRING ' theme of the form being edited ("" = default XP)

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

DIM SHARED OptionsMenuAutoName AS LONG
DIM SHARED OptionsMenuSwapButtons AS LONG
DIM SHARED OptionsMenuSaveFormOnly AS LONG
DIM SHARED OptionsMenuEditorThemeLight AS LONG, OptionsMenuEditorThemeDark AS LONG
DIM SHARED EditorTheme AS STRING
DIM SHARED RestoringSession AS _BYTE, RecoverySaved$, RecoverySavedAt AS DOUBLE
CONST RECOVERY_FILE = "InForm/UiEditor.recovery"

DIM SHARED HelpMenuHelp AS LONG, HelpMenuAbout AS LONG

DIM SHARED FontSwitchMenuSwitch AS LONG

'Toolbox buttons
DIM SHARED AddButton AS LONG, AddLabel AS LONG
DIM SHARED AddTextBox AS LONG, AddNumericBox AS LONG
DIM SHARED AddCheckBox AS LONG, AddRadioButton AS LONG
DIM SHARED AddListBox AS LONG, AddDropdownList AS LONG
DIM SHARED AddTrackBar AS LONG, AddProgressBar AS LONG
DIM SHARED AddPictureBox AS LONG, AddFrame AS LONG
DIM SHARED AddToggleSwitch AS LONG, AddTabControl AS LONG, AddDataGrid AS LONG, AddPropertyGrid AS LONG

'Control toggles
DIM SHARED Stretch AS LONG, HasBorder AS LONG
DIM SHARED ShowPercentage AS LONG, PasswordMaskCB AS LONG, MultilineCB AS LONG, SearchableCB AS LONG, FuzzyCB AS LONG
DIM SHARED ReorderableCB AS LONG
DIM SHARED AnchorLB AS LONG, AnchorPicker AS LONG, AnchorInfoLB AS LONG
DIM SHARED AnchorPickerFlags AS LONG ' anchor edges of the first selected control, as the picker shows them
CONST AnchorPickerBoxW = 40, AnchorPickerBoxH = 20 ' size of the control drawn in the anchor picker
DIM SHARED WordWrap AS LONG, CanHaveFocus AS LONG
DIM SHARED Disabled AS LONG, Transparent AS LONG
DIM SHARED Hidden AS LONG, CenteredWindow AS LONG
DIM SHARED Resizable AS LONG, AutoScroll AS LONG
DIM SHARED AutoSize AS LONG, SizeTB AS LONG
DIM SHARED HideTicks AS LONG, AutoPlayGif AS LONG
DIM SHARED AddGifExtensionToggle AS LONG

'Z-ordering dialog
DIM SHARED ControlList AS LONG, UpBT AS LONG
DIM SHARED DownBT AS LONG, CloseZOrderingBT AS LONG

'Property grid rows dialog, also used for a data grid's columns and rows
DIM SHARED ColumnsLB AS LONG, EditColumnsBT AS LONG
DIM SHARED RowsLB AS LONG, EditRowsBT AS LONG, EditRowsDialog AS LONG, RowsDescriptionLB AS LONG
DIM SHARED RowsFirstBT AS LONG, RowsPrevBT AS LONG, RowsPositionLB AS LONG, RowsNextBT AS LONG, RowsLastBT AS LONG
DIM SHARED RowsAddBT AS LONG, RowsDeleteBT AS LONG, RowsUpBT AS LONG, RowsDownBT AS LONG
DIM SHARED RowsHintLB AS LONG, RowsOKBT AS LONG, RowsCancelBT AS LONG, RowsGrid AS LONG
DIM SHARED RowsDialogOpen AS _BYTE
DIM SHARED RowsFrameName$ ' the frame whose rows are being edited
DIM SHARED RowsOriginal$, RowsShown$ ' its rows when the dialog opened, and as the preview shows them now
REDIM SHARED RowsHistory(0) AS STRING ' the table after each change, for undo (see RowsSnapshot$)
DIM SHARED RowsHistoryPos AS LONG, RowsHistoryCount AS LONG
CONST RowsModeProperties = 0 ' what the dialog's table holds: a property grid's rows,
CONST RowsModeColumns = 1 '    a data grid's columns,
CONST RowsModeGridRows = 2 '   or a data grid's rows
DIM SHARED RowsMode AS _BYTE
DIM SHARED RowsKeep$ ' the part of a data grid's definition the table doesn't hold (its rows, or its columns)

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
DIM SHARED InvertBindingCB AS LONG
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
DIM SHARED PasteListBT AS LONG, BrowseImageBT AS LONG, ContextMenuLB AS LONG
DIM SHARED ContextMenuControlsList AS LONG
DIM SHARED KeyboardComboLB AS LONG, KeyboardComboBT AS LONG
'------------------------------------------------------------------------------

'Other shared variables:
DIM SHARED UiPreviewPID AS LONG, TotalSelected AS LONG, FirstSelected AS LONG
DIM SHARED PreviewFormID AS LONG, PreviewSelectionRectangle AS INTEGER
DIM SHARED PreviewAttached AS _BYTE, AutoNameControls AS _BYTE
DIM SHARED LastKeyPress AS DOUBLE, SaveFrmOnly AS _BYTE
DIM SHARED UiEditorTitle$, Edited AS _BYTE, ZOrderingDialogOpen AS _BYTE
DIM SHARED PropertySent AS _BYTE, OldColor AS _UNSIGNED LONG
DIM SHARED ColorPreviewWord$, BlinkStatusBar AS SINGLE, StatusBarBackColor AS _UNSIGNED LONG
DIM SHARED InstanceHost AS LONG, InstanceClient AS LONG
DIM SHARED HostPort AS STRING, Host AS LONG, Client AS LONG
DIM SHARED Stream$, FormDataReceived AS _BYTE, LastFormData$
DIM SHARED prevScreenX AS INTEGER, prevScreenY AS INTEGER
DIM SHARED UndoPointer AS INTEGER, TotalUndoImages AS INTEGER
DIM SHARED totalBytesSent AS _UNSIGNED _INTEGER64
DIM SHARED RecentMenuItem(1 TO 9) AS LONG, RecentListBuilt AS _BYTE
DIM SHARED RecentFile(1 TO 9) AS STRING
DIM SHARED LoadedWithGifExtension AS _BYTE, AddGifExtension AS _BYTE
DIM SHARED TotalGifLoaded AS LONG, SetBindingDialogOpen AS _BYTE
DIM SHARED InitialControlSet AS STRING
DIM SHARED Answer AS LONG

CONST UIEDITOR_TCP_PORT = "49374" ' TCP port # used by UIEditor
CONST COMMDLG_DELAY! = 0.2! ' amount of time to wait to let the UI refresh before opening a common dialog window

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
'Bindings each control is part of, one record per binding:
'MKI$(LEN(other control's name)) + name + MKI$(LEN(this control's property)) + property
REDIM SHARED PreviewBindings(0) AS STRING
REDIM SHARED PreviewKeyCombos(0) AS STRING
REDIM SHARED PreviewAnimatedGif(0) AS _BYTE
REDIM SHARED PreviewAutoPlayGif(0) AS _BYTE
REDIM SHARED zOrderIDs(0) AS LONG
DIM SHARED ZOrderLastMove AS DOUBLE, ZOrderListDirty AS _BYTE
DIM SHARED PreviewDefaultButtonID AS LONG

DIM SHARED HasFontList AS _BYTE, ShowFontList AS _BYTE
DIM SHARED AttemptToShowFontList AS _BYTE, BypassShowFontList AS _BYTE
DIM SHARED TotalFontsFound AS LONG
REDIM SHARED FontFile(0) AS STRING

CONST QB64_DISPLAY = "QB64-PE"

$IF WINDOWS THEN
    CONST DIRECTORY_SEPARATOR = "\"
    CONST QB64_EXE_NAME = "qb64pe.exe"
$ELSE
    CONST DIRECTORY_SEPARATOR = "/"
    CONST QB64_EXE_NAME = "qb64pe"
$END IF

UiEditorTitle$ = "InForm Designer"

DIM SHARED QB64PEExePath AS STRING: QB64PEExePath = Ini_ReadSetting("InForm/InForm.ini", "InForm Settings", "QB64PE path") ' read the compiler path name from the INI

IF NOT _FILEEXISTS(QB64PEExePath) THEN ' if the compiler is missing then look for it in obvious places
    IF _FILEEXISTS("." + DIRECTORY_SEPARATOR + QB64_EXE_NAME) THEN
        QB64PEExePath = "." + DIRECTORY_SEPARATOR + QB64_EXE_NAME
    ELSEIF _FILEEXISTS(".." + DIRECTORY_SEPARATOR + QB64_EXE_NAME) THEN
        QB64PEExePath = ".." + DIRECTORY_SEPARATOR + QB64_EXE_NAME
    ELSEIF _FILEEXISTS(".." + DIRECTORY_SEPARATOR + "QB64pe" + DIRECTORY_SEPARATOR + QB64_EXE_NAME) THEN
        QB64PEExePath = ".." + DIRECTORY_SEPARATOR + "QB64pe" + DIRECTORY_SEPARATOR + QB64_EXE_NAME
    ELSEIF _FILEEXISTS(".." + DIRECTORY_SEPARATOR + "qb64pe" + DIRECTORY_SEPARATOR + QB64_EXE_NAME) THEN
        QB64PEExePath = ".." + DIRECTORY_SEPARATOR + "qb64pe" + DIRECTORY_SEPARATOR + QB64_EXE_NAME
    ELSE
        QB64PEExePath = _SELECTFOLDERDIALOG$("Select QB64-PE directory:")

        IF _FILEEXISTS(QB64PEExePath + DIRECTORY_SEPARATOR + QB64_EXE_NAME) THEN
            QB64PEExePath = QB64PEExePath + DIRECTORY_SEPARATOR + QB64_EXE_NAME
        ELSE
            _MESSAGEBOX UiEditorTitle$, QB64_DISPLAY + " executable not found.", "error"

            SYSTEM 1
        END IF

        Ini_WriteSetting "InForm/InForm.ini", "InForm Settings", "QB64PE path", QB64PEExePath ' save the complete path name to the INI
    END IF
END IF

DIM SHARED CurrentPath$, ThisFileName$

$IF WIN THEN
    DECLARE DYNAMIC LIBRARY "kernel32"
        FUNCTION OpenProcess& (BYVAL dwDesiredAccess AS LONG, BYVAL bInheritHandle AS LONG, BYVAL dwProcessId AS LONG)
        FUNCTION CloseHandle& (BYVAL hObject AS LONG)
        FUNCTION GetExitCodeProcess& (BYVAL hProcess AS LONG, lpExitCode AS LONG)
    END DECLARE

    DECLARE DYNAMIC LIBRARY "user32"
        FUNCTION SetForegroundWindow& (BYVAL hWnd AS LONG)
    END DECLARE
$ELSE
    DECLARE LIBRARY
        FUNCTION PROCESS_CLOSED& ALIAS kill (BYVAL pid AS INTEGER, BYVAL signal AS INTEGER)
    END DECLARE
$END IF

'$INCLUDE:'extensions/Pathname.bi'
'$INCLUDE:'extensions/Ini.bi'
'$INCLUDE:'extensions/FontMgr.bi'
'$INCLUDE:'InForm.bi'

'$INCLUDE:'UiEditor.frm'
'$INCLUDE:'InForm.ui'

'Event procedures: ---------------------------------------------------------------
SUB __UI_Click (id AS LONG)
    DIM Answer AS _BYTE, Dummy AS LONG, b$, i AS LONG
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

        CASE OptionsMenuSaveFormOnly
            SaveFrmOnly = NOT SaveFrmOnly
            Control(id).Value = SaveFrmOnly
        CASE OptionsMenuEditorThemeLight
            SetEditorTheme "light"
            SaveSettings
        CASE OptionsMenuEditorThemeDark
            SetEditorTheme "dark"
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
        CASE AddTabControl: Dummy = __UI_Type_TabControl
        CASE AddButton, AddLabel, AddTextBox, AddCheckBox, AddRadioButton, AddListBox, AddDropdownList, AddTrackBar, AddProgressBar, AddPictureBox, AddFrame, AddToggleSwitch, AddTabControl
            b$ = "NEWCONTROL>" + MKI$(Dummy) + "<END>"
            Send Client, b$
        CASE AddDataGrid
            'A frame with a data grid's columns and rows in its Text (see InFormDataGrid.bm)
            Send Client, "NEWDATAGRID><END>"
        CASE AddPropertyGrid
            'A frame with property grid rows in its Text (see InFormPropertyGrid.bm)
            Send Client, "NEWPROPERTYGRID><END>"
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
        CASE MultilineCB
            b$ = MKI$(Control(id).Value)
            SendData b$, 45
        CASE SearchableCB
            b$ = MKI$(Control(id).Value)
            SendData b$, 46
        CASE FuzzyCB
            b$ = MKI$(Control(id).Value)
            SendData b$, 47
        CASE ReorderableCB
            b$ = MKI$(Control(id).Value)
            SendData b$, 48
        CASE AnchorPicker
            ToggleAnchorEdge AnchorPickerEdge
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
            IF Control(AddGifExtensionToggle).Value = False AND TotalGifLoaded > 0 THEN
                __UI_Delay COMMDLG_DELAY: Answer = _MESSAGEBOX(UiEditorTitle$, "Removing the GIF extension will load the existing animations as static frames. Proceed?", "yesno", "question", 0)
                IF Answer = 0 THEN
                    Control(AddGifExtensionToggle).Value = True
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
                __UI_Delay COMMDLG_DELAY: Answer = _MESSAGEBOX(UiEditorTitle$, "Save the current form?", "yesnocancel", "question", 1)
                IF Answer = 0 THEN
                    EXIT SUB
                ELSEIF Answer = 1 THEN
                    SaveForm False, False
                END IF
            END IF

            __UI_Focus = 0
            LastFormData$ = ""
            ThisFileName$ = ""
            Stream$ = ""
            FormDataReceived = False
            AddGifExtension = False
            Control(AddGifExtensionToggle).Value = False
            LoadedWithGifExtension = False
            Edited = False
            SendSignal -5

        CASE FileMenuSave
            IF LEN(ThisFileName$) THEN
                SaveForm True, False
            ELSE
                GOTO SaveAs
            END IF

        CASE FileMenuSaveAs
            SaveAs:

            'Hide the preview
            SendSignal -2

            IF LEN(CurrentPath$) = 0 THEN CurrentPath$ = Pathname_AddDirectorySeparator(_STARTDIR$)

            Caption(StatusBar) = "Specify the name under which to save the current form..."

            __UI_Delay COMMDLG_DELAY
            DIM tmpFileName AS STRING: tmpFileName = _SAVEFILEDIALOG$(UiEditorTitle$ + ": Save As", CurrentPath$, "*.frm|*.FRM|*.Frm", "InForm form files")

            IF LEN(tmpFileName) THEN
                IF UCASE$(RIGHT$(tmpFileName, 4)) <> ".FRM" THEN
                    tmpFileName = tmpFileName + ".frm"
                END IF

                ThisFileName$ = Pathname_GetFileName(tmpFileName)
                CurrentPath$ = Pathname_GetPath(tmpFileName)
                SaveForm True, SaveFrmOnly
            END IF

            Caption(StatusBar) = "Ready."

            'Show the preview
            SendSignal -3

            __UI_ForceRedraw = True

        CASE HelpMenuAbout
            MessageBox "InForm GUI engine for QB64-PE\n\nCopyright (c) 2025 QB64 Phoenix Edition Team\nCopyright (c) 2023 George McGinn - gbytes58@gmail.com\nCopyright (c) 2022 Fellippe Heitor - @FellippeHeitor\n\n" + UiEditorTitle$ + " v" + __UI_Version + "\n\nhttps://github.com/QB64-Phoenix-Edition/InForm-PE", UiEditorTitle$ + " - About", MsgBox_Information
        CASE HelpMenuHelp
            MessageBox "Design a form and export the resulting code to generate an event-driven QB64-PE program.", UiEditorTitle$ + " - What's all this?", MsgBox_Information
        CASE FileMenuExit
            'Unsaved work is kept and restored the next time the editor starts
            IF Edited THEN SaveRecovery
            SaveSettings
            IF _FILEEXISTS("InForm/UiEditorPreview.frmbin") THEN KILL "InForm/UiEditorPreview.frmbin"
            SYSTEM
        CASE EditMenuZOrdering
            Caption(StatusBar) = "Editing z-ordering/tab ordering"
            ZOrderLastMove = 0
            ZOrderListDirty = False
            ZOrderRefreshList True
            Control(ControlList).InputViewStart = 1
            ZOrderSelectControl FirstSelected
            Control(DialogBG).Left = 0: Control(DialogBG).Top = 0
            Control(ZOrdering).Left = 18: Control(ZOrdering).Top = 40
            __UI_Focus = ControlList
            ZOrderingDialogOpen = True
        CASE EditMenuBindControls
            'Get controls' names and the properties bound between them, if any
            DIM BindSource AS LONG, BindTarget AS LONG, SourceProperty$, TargetProperty$
            BindSource = 0: BindTarget = 0
            FOR i = 1 TO UBOUND(PreviewControls)
                IF PreviewControls(i).ControlIsSelected THEN
                    IF BindSource = 0 THEN
                        BindSource = i
                    ELSE
                        BindTarget = i
                        EXIT FOR
                    END IF
                END IF
            NEXT
            IF BindTarget = 0 THEN EXIT SUB 'Bindings are set up between two controls

            Caption(SourceControlNameLB) = PreviewName$(BindSource)
            Caption(TargetControlNameLB) = PreviewName$(BindTarget)
            SourceProperty$ = PreviewBoundProperty$(BindSource, PreviewName$(BindTarget))
            TargetProperty$ = PreviewBoundProperty$(BindTarget, PreviewName$(BindSource))
            'An inverted binding has "NOT " in front of one of its properties
            Control(InvertBindingCB).Value = __UI_IsInvertedProperty(SourceProperty$) XOR __UI_IsInvertedProperty(TargetProperty$)
            IF __UI_IsInvertedProperty(SourceProperty$) THEN SourceProperty$ = MID$(LTRIM$(SourceProperty$), 5)
            IF __UI_IsInvertedProperty(TargetProperty$) THEN TargetProperty$ = MID$(LTRIM$(TargetProperty$), 5)
            IF LEN(SourceProperty$) = 0 THEN Dummy = SelectItem(SourcePropertyList, "Value") ELSE Dummy = SelectItem(SourcePropertyList, SourceProperty$)
            IF LEN(TargetProperty$) = 0 THEN Dummy = SelectItem(TargetPropertyList, "Value") ELSE Dummy = SelectItem(TargetPropertyList, TargetProperty$)

            IF LEN(SourceProperty$) > 0 THEN
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
            SetBindingDialogOpen = True
            'CASE SwapBT
            '    SWAP Caption(SourceControlNameLB), Caption(TargetControlNameLB)
            '    SWAP Control(SourcePropertyList).Value, Control(TargetPropertyList).Value
        CASE BindBT
            Control(DialogBG).Left = -600: Control(DialogBG).Top = -600
            Control(SetControlBinding).Left = -600: Control(SetControlBinding).Top = -600
            SetBindingDialogOpen = False
            b$ = "BINDCONTROLS>"
            b$ = b$ + MKL$(LEN(Caption(SourceControlNameLB))) + Caption(SourceControlNameLB)
            b$ = b$ + MKL$(LEN(Caption(TargetControlNameLB))) + Caption(TargetControlNameLB)
            b$ = b$ + MKL$(LEN(GetItem(SourcePropertyList, Control(SourcePropertyList).Value)))
            b$ = b$ + GetItem(SourcePropertyList, Control(SourcePropertyList).Value)
            TargetProperty$ = GetItem(TargetPropertyList, Control(TargetPropertyList).Value)
            IF Control(InvertBindingCB).Value THEN TargetProperty$ = "NOT " + TargetProperty$
            b$ = b$ + MKL$(LEN(TargetProperty$)) + TargetProperty$
            b$ = b$ + "<END>"
            Send Client, b$
        CASE CancelBindBT
            Control(DialogBG).Left = -600: Control(DialogBG).Top = -600
            Control(SetControlBinding).Left = -600: Control(SetControlBinding).Top = -600
            SetBindingDialogOpen = False
            IF Caption(CancelBindBT) = "Unbind" THEN
                b$ = "UNBINDCONTROLS>"
                b$ = b$ + Caption(SourceControlNameLB) + CHR$(10) + Caption(TargetControlNameLB)
                b$ = b$ + "<END>"
                Send Client, b$
            END IF
        CASE EditRowsBT
            OpenRowsDialog
        CASE EditColumnsBT
            OpenRowsDialogFor RowsModeColumns
        CASE RowsOKBT
            ApplyRowsDialog
        CASE RowsCancelBT
            CloseRowsDialog
        CASE RowsFirstBT
            RowsGoTo 1
        CASE RowsPrevBT
            RowsGoTo DataGrid_Row(RowsGrid) - 1
        CASE RowsNextBT
            RowsGoTo DataGrid_Row(RowsGrid) + 1
        CASE RowsLastBT
            RowsGoTo DataGrid_RowCount(RowsGrid)
        CASE RowsAddBT
            RowsAdd
        CASE RowsDeleteBT
            DataGrid_RemoveSelection RowsGrid
            RowsChanged
            __UI_Focus = RowsGrid
        CASE RowsUpBT
            DataGrid_MoveSelection RowsGrid, -1
            RowsChanged
            __UI_Focus = RowsGrid
        CASE RowsDownBT
            DataGrid_MoveSelection RowsGrid, 1
            RowsChanged
            __UI_Focus = RowsGrid
        CASE CloseZOrderingBT
            Caption(StatusBar) = "Ready."
            Control(DialogBG).Left = -600: Control(DialogBG).Top = -600
            Control(ZOrdering).Left = -600: Control(ZOrdering).Top = -600
            __UI_Focus = 0
            ZOrderingDialogOpen = False
        CASE UpBT
            ZOrderMove -1
            __UI_Focus = ControlList
        CASE DownBT
            ZOrderMove 1
            __UI_Focus = ControlList

        CASE FileMenuOpen
            IF Edited THEN
                __UI_Delay COMMDLG_DELAY: Answer = _MESSAGEBOX(UiEditorTitle$, "Save the current form?", "yesnocancel", "question", 1)
                IF Answer = 0 THEN
                    EXIT SUB
                ELSEIF Answer = 1 THEN
                    SaveForm False, False
                END IF
            END IF

            'Hide the preview
            SendSignal -2

            IF LEN(CurrentPath$) = 0 THEN CurrentPath$ = Pathname_AddDirectorySeparator(_STARTDIR$)

            Caption(StatusBar) = "Select a form file to load..."

            __UI_Delay COMMDLG_DELAY
            tmpFileName = _OPENFILEDIALOG$(UiEditorTitle$ + ": Open", CurrentPath$, "*.frm|*.FRM|*.Frm", "InForm form files")

            OpenForm tmpFileName

            Caption(StatusBar) = "Ready."

            'Show the preview
            SendSignal -3

            __UI_ForceRedraw = True

        CASE FileMenuRecentRemoveMissing
            RemoveMissingFromRecentList

        CASE FileMenuRecent1, FileMenuRecent2, FileMenuRecent3, FileMenuRecent4, FileMenuRecent5, FileMenuRecent6, FileMenuRecent7, FileMenuRecent8, FileMenuRecent9
            tmpFileName = ""
            FOR i = 1 TO 9
                IF RecentMenuItem(i) = id THEN tmpFileName = RecentFile(i): EXIT FOR
            NEXT
            IF _FILEEXISTS(tmpFileName) THEN
                IF Edited THEN
                    __UI_Delay COMMDLG_DELAY: Answer = _MESSAGEBOX(UiEditorTitle$, "Save the current form?", "yesnocancel", "question", 1)
                    IF Answer = 0 THEN
                        EXIT SUB
                    ELSEIF Answer = 1 THEN
                        SaveForm False, False
                    END IF
                END IF

                ' Check if GIFPlay library was used
                LoadedWithGifExtension = False

                IF _FILEEXISTS(LEFT$(tmpFileName, LEN(tmpFileName) - 4) + ".bas") THEN
                    b$ = LCASE$(_READFILE$(LEFT$(tmpFileName, LEN(tmpFileName) - 4) + ".bas"))
                    IF INSTR(b$, "'$include:'inform/extensions/gifplay.bi'") > 0 OR INSTR(b$, "'$include:'inform/extensions/gifplay.bm'") > 0 OR INSTR(b$, "'$include:'inform/extensions/gifplay.bas'") > 0 THEN
                        LoadedWithGifExtension = True
                    END IF
                END IF

                ThisFileName$ = Pathname_GetFileName(tmpFileName)
                CurrentPath$ = Pathname_GetPath(tmpFileName)

                'Send open command
                IF LoadedWithGifExtension = False THEN
                    LoadedWithGifExtension = 1 'Set to 1 to check whether a loaded file already had the gif extension
                    Control(AddGifExtensionToggle).Value = False
                ELSE
                    Control(AddGifExtensionToggle).Value = True
                END IF
                AddGifExtension = False
                b$ = "OPENFILE>" + tmpFileName + "<END>"
                Send Client, b$

                SendSignal -4

                __UI_Focus = 0
                Edited = False
                LastFormData$ = ""
                Stream$ = ""
                FormDataReceived = False
                InitialControlSet = ""
            ELSE
                MessageBox "File not found.", UiEditorTitle$, MsgBox_Critical
                RemoveFromRecentList tmpFileName
            END IF

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
        CASE ViewMenuThemeXP
            SetPreviewTheme "xp"
        CASE ViewMenuThemeLight
            SetPreviewTheme "light"
        CASE ViewMenuThemeDark
            SetPreviewTheme "dark"
        CASE ViewMenuThemeEdit
            OpenThemeEditor
        CASE ViewMenuThemeFile
            DIM ThemeFile$
            ThemeFile$ = _OPENFILEDIALOG$(UiEditorTitle$ + ": Open theme", CurrentPath$, "*.ini|*.INI", "InForm theme files")
            IF LEN(ThemeFile$) THEN SetPreviewTheme ThemeFile$
        CASE FontSwitchMenuSwitch, FontLB, FontListLB
            AttemptToShowFontList = (ShowFontList = False OR BypassShowFontList = True)
            ShowFontList = NOT ShowFontList
            IF id <> FontSwitchMenuSwitch THEN __UI_MouseEnter FontLB
            SaveSettings
            __UI_ForceRedraw = True
        CASE PasteListBT
            DIM Clip$
            Clip$ = _CLIPBOARD$
            Clip$ = Replace$(Clip$, CHR$(13) + CHR$(10), CHR$(10), 0, 0)
            Clip$ = Replace$(Clip$, CHR$(10), "\n", 0, 0)

            IF PreviewControls(FirstSelected).Type = __UI_Type_ListBox OR PreviewControls(FirstSelected).Type = __UI_Type_DropdownList THEN
                Dummy = TextTB
            ELSEIF (PreviewControls(FirstSelected).Type = __UI_Type_Label AND PreviewControls(FirstSelected).WordWrap = True) THEN
                Dummy = CaptionTB
            END IF

            Text(Dummy) = Clip$
            __UI_Focus = Dummy
            Control(Dummy).Cursor = LEN(Text(Dummy))
            Control(Dummy).TextIsSelected = False
        CASE BrowseImageBT
            DIM ImageFile$, ImagePath$
            ImagePath$ = Text(TextTB)
            IF LEN(ImagePath$) > 0 AND _FILEEXISTS(ImagePath$) THEN
                ImagePath$ = Pathname_GetPath(ImagePath$)
            ELSEIF LEN(CurrentPath$) > 0 THEN
                ImagePath$ = CurrentPath$
            ELSE
                ImagePath$ = Pathname_AddDirectorySeparator(_STARTDIR$)
            END IF
            __UI_Delay COMMDLG_DELAY
            IF PreviewControls(FirstSelected).Type = __UI_Type_Form THEN
                'The form icon becomes the executable icon, which must be an .ico file
                ImageFile$ = _OPENFILEDIALOG$(UiEditorTitle$ + ": Choose icon", ImagePath$, "*.ico|*.ICO", "Icon files")
            ELSE
                ImageFile$ = _OPENFILEDIALOG$(UiEditorTitle$ + ": Choose image", ImagePath$, "*.png|*.PNG|*.jpg|*.JPG|*.jpeg|*.JPEG|*.bmp|*.BMP|*.gif|*.GIF|*.tga|*.TGA|*.psd|*.PSD|*.pcx|*.PCX|*.pnm|*.PNM|*.qoi|*.QOI|*.svg|*.SVG|*.ico|*.ICO|*.cur|*.CUR", "Image files")
            END IF
            IF LEN(ImageFile$) THEN
                Text(TextTB) = ImageFile$
                PropertyGrid_Commit ControlProperties, "text"
                Caption(StatusBar) = "Image file set."
            END IF
        CASE KeyboardComboBT
            __UI_BypassKeyCombos = True
            Caption(KeyboardComboBT) = CHR$(7) + " hit a key combo... (ESC to clear)"
            ToolTip(KeyboardComboBT) = "Press a key combination to assign to the selected control"
    END SELECT

    LastClickedID = id
    LastClick# = TIMER
    IF LEN(Caption(StatusBar)) = 0 THEN Caption(StatusBar) = "Ready."
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
            Caption(StatusBar) = "Automatically sets control names based on caption and type."
        CASE OptionsMenuSaveFormOnly
            Caption(StatusBar) = "Saves only the .frm file."
        CASE OptionsMenuEditorThemeLight, OptionsMenuEditorThemeDark
            Caption(StatusBar) = "Changes the look of the editor (not of the form you're designing)."
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
    'Focus stays in the property grid rows dialog while it's open
    IF RowsDialogOpen THEN
        IF Control(id).ParentID <> EditRowsDialog AND DataGrid_GridOf(id) <> RowsGrid AND id <> __UI_ActiveDropdownList THEN
            __UI_Focus = RowsGrid
            EXIT SUB
        END IF
    END IF

    SELECT CASE id
        CASE NameTB, CaptionTB, TextTB, MaskTB, TopTB, LeftTB, WidthTB, HeightTB, FontTB, TooltipTB, ValueTB, MinTB, MaxTB, IntervalTB, PaddingTB, MinIntervalTB, SizeTB
            Caption(StatusBar) = "Editing property"

        CASE ControlList
            IF ZOrderingDialogOpen = False THEN __UI_Focus = AddButton

        CASE BlueValue

        CASE CloseZOrderingBT
            IF ZOrderingDialogOpen = False THEN __UI_Focus = BlueValue

        CASE AddButton
            IF ZOrderingDialogOpen THEN __UI_Focus = ControlList
            IF RowsDialogOpen THEN __UI_Focus = RowsGrid
            IF SetBindingDialogOpen THEN __UI_Focus = SourcePropertyList

        CASE KeyboardComboBT
            __UI_BypassKeyCombos = True
            Caption(KeyboardComboBT) = CHR$(7) + " hit a key combo... (ESC to clear)"
            ToolTip(KeyboardComboBT) = "Press a key combination to assign to the selected control"
    END SELECT
END SUB

SUB __UI_FocusOut (id AS LONG)
    'Property boxes commit their edits on their own (see InFormPropertyGrid.bm)
    SELECT CASE id
        CASE KeyboardComboBT
            __UI_BypassKeyCombos = False
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

SUB OpenForm (frmFileName AS STRING)
    IF LEN(frmFileName) THEN
        ' Check if GIFPlay library was used
        LoadedWithGifExtension = False

        IF _FILEEXISTS(LEFT$(frmFileName, LEN(frmFileName) - 4) + ".bas") THEN
            DIM b$: b$ = LCASE$(_READFILE$(LEFT$(frmFileName, LEN(frmFileName) - 4) + ".bas"))
            IF INSTR(b$, "'$include:'inform/extensions/gifplay.bi'") > 0 OR INSTR(b$, "'$include:'inform/extensions/gifplay.bm'") > 0 OR INSTR(b$, "'$include:'inform/extensions/gifplay.bas'") > 0 THEN
                LoadedWithGifExtension = True
            END IF
        END IF

        AddToRecentList frmFileName

        ThisFileName$ = Pathname_GetFileName(frmFileName)
        CurrentPath$ = Pathname_GetPath(frmFileName)

        'Send open command
        IF LoadedWithGifExtension = False THEN
            LoadedWithGifExtension = 1 'Set to 1 to check whether a loaded file already had the gif extension
            Control(AddGifExtensionToggle).Value = False
        ELSE
            Control(AddGifExtensionToggle).Value = True
        END IF
        AddGifExtension = False
        b$ = "OPENFILE>" + frmFileName + "<END>"
        Send Client, b$

        SendSignal -4

        __UI_Focus = 0
        Edited = False
        LastFormData$ = ""
        Stream$ = ""
        FormDataReceived = False
        InitialControlSet = ""
    END IF
END SUB

SUB AddToRecentList (FileName$)
    DIM i AS LONG, j AS LONG, b$

    'Check if this FileName$ is already in the list; if so, delete it.
    FOR i = 1 TO 9
        b$ = Ini_ReadSetting("InForm/InForm.ini", "Recent Projects", STR$(i))
        IF b$ = FileName$ THEN
            FOR j = i + 1 TO 9
                b$ = Ini_ReadSetting("InForm/InForm.ini", "Recent Projects", STR$(j))
                Ini_WriteSetting "InForm/InForm.ini", "Recent Projects", STR$(j - 1), b$
            NEXT
            EXIT FOR
        END IF
    NEXT

    'Make room for FileName$ by shifting existing list by one;
    '1 is the most recent, 9 is the oldest;
    FOR i = 8 TO 1 STEP -1
        b$ = Ini_ReadSetting("InForm/InForm.ini", "Recent Projects", STR$(i))
        Ini_WriteSetting "InForm/InForm.ini", "Recent Projects", STR$(i + 1), b$
    NEXT

    Ini_WriteSetting "InForm/InForm.ini", "Recent Projects", "1", FileName$
    RecentListBuilt = False
END SUB

SUB RemoveFromRecentList (FileName$)
    DIM i AS LONG, j AS LONG, b$

    'Check if this FileName$ is already in the list; if so, delete it.
    FOR i = 1 TO 9
        b$ = Ini_ReadSetting("InForm/InForm.ini", "Recent Projects", STR$(i))
        IF b$ = FileName$ THEN
            FOR j = i + 1 TO 9
                b$ = Ini_ReadSetting("InForm/InForm.ini", "Recent Projects", STR$(j))
                Ini_WriteSetting "InForm/InForm.ini", "Recent Projects", STR$(j - 1), b$
            NEXT
            Ini_WriteSetting "InForm/InForm.ini", "Recent Projects", "9", ""
            EXIT FOR
        END IF
    NEXT
    RecentListBuilt = False
END SUB

SUB RemoveMissingFromRecentList
    DIM i AS LONG, total AS LONG, b$
    DIM keep(1 TO 9) AS STRING

    'Keep the files that still exist, in their current order
    FOR i = 1 TO 9
        b$ = Ini_ReadSetting("InForm/InForm.ini", "Recent Projects", STR$(i))
        IF LEN(b$) THEN
            IF _FILEEXISTS(b$) THEN total = total + 1: keep(total) = b$
        END IF
    NEXT

    FOR i = 1 TO 9
        Ini_WriteSetting "InForm/InForm.ini", "Recent Projects", STR$(i), keep(i)
    NEXT
    RecentListBuilt = False
END SUB

SUB SendNewRGB
    DIM b$, NewColor AS _UNSIGNED LONG
    NewColor = _RGB32(Control(Red).Value, Control(Green).Value, Control(Blue).Value)
    b$ = _MK$(_UNSIGNED LONG, NewColor)
    SendData b$, Control(ColorPropertiesList).Value + 22
END SUB

SUB SelectPropertyFully (id AS LONG)
    Control(id).TextIsSelected = True
    Control(id).SelectionStart = 0
    Control(id).Cursor = LEN(Text(id))
END SUB

SUB SelectFontInList (FontSetup$)
    DIM i AS LONG, thisFile$, thisSize%

    IF LEN(FontSetup$) = 0 THEN EXIT SUB

    thisFile$ = UCASE$(LEFT$(FontSetup$, INSTR(FontSetup$, ",") - 1))
    thisSize% = VAL(MID$(FontSetup$, INSTR(FontSetup$, ",") + 1))

    IF LEN(thisFile$) > 0 THEN
        ResetList FontSizeList

        DIM AS _UNSIGNED _BYTE minSize, maxSize
        IF FontMgr_GetSizeRange(thisFile$, 0, minSize, maxSize) THEN
            FOR i = minSize TO maxSize
                AddItem FontSizeList, LTRIM$(STR$(i))
            NEXT
        ELSE
            FOR i = 8 TO 120
                AddItem FontSizeList, LTRIM$(STR$(i))
            NEXT
        END IF

        i = SelectItem(FontSizeList, LTRIM$(STR$(thisSize%)))

        FOR i = 1 TO UBOUND(FontFile)
            IF UCASE$(RIGHT$(FontFile(i), LEN(thisFile$))) = thisFile$ THEN
                Control(FontList).Value = i
                BypassShowFontList = False
                AttemptToShowFontList = False
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
        BypassShowFontList = False
        AttemptToShowFontList = False
        EXIT SUB
    END IF

    'If this line is reached, the currently open form
    'uses a non-system font. In that case we must
    'disable the list.
    BypassShowFontList = True
    IF AttemptToShowFontList THEN
        AttemptToShowFontList = False
        __UI_Delay COMMDLG_DELAY: i = _MESSAGEBOX(UiEditorTitle$, "The current font isn't a system font.\nReset this control to the built-in font?", "yesno", "question", 1)
        IF i = 1 THEN
            thisFile$ = ",16"
            thisFile$ = MKL$(LEN(thisFile$)) + thisFile$
            SendData thisFile$, 8
            BypassShowFontList = False
            ShowFontList = True
        END IF
    END IF
END SUB

SUB LoseFocus
    IF __UI_TotalActiveMenus > 0 THEN __UI_CloseAllMenus
    IF __UI_ActiveDropdownList > 0 THEN __UI_DestroyControl Control(__UI_ActiveDropdownList)
    IF __UI_Focus > 0 THEN __UI_FocusOut __UI_Focus
    __UI_Focus = 0
    __UI_ForceRedraw = True
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
    STATIC FileMenuWasOpen AS _BYTE
    DIM LastRecent AS LONG, MissingRecent AS LONG

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

    IF __UI_BypassKeyCombos THEN
        'Blink KeyCombo button
        IF TIMER - LastChange > .4 THEN
            IF Control(KeyboardComboBT).ForeColor = __UI_DefaultColor(__UI_Type_Button, 1) THEN
                Control(KeyboardComboBT).ForeColor = _RGB32(255, 0, 0)
            ELSE
                Control(KeyboardComboBT).ForeColor = __UI_DefaultColor(__UI_Type_Button, 1)
            END IF
            Control(KeyboardComboBT).Redraw = True
            LastChange = TIMER
        END IF
    ELSE
        Control(KeyboardComboBT).ForeColor = __UI_DefaultColor(__UI_Type_Button, 1)
        Control(KeyboardComboBT).Redraw = True
    END IF

    'Check the recent projects again every time the File menu opens,
    'so files that were moved or deleted show up as missing
    IF __UI_TotalActiveMenus > 0 AND __UI_ParentMenu(1) = FileMenu THEN
        IF NOT FileMenuWasOpen THEN FileMenuWasOpen = True: RecentListBuilt = False
    ELSE
        FileMenuWasOpen = False
    END IF

    IF RecentListBuilt = False THEN
        'Build list of recent projects
        RecentListBuilt = True
        LastRecent = 0
        MissingRecent = 0
        FOR i = 1 TO 9
            RecentFile(i) = Ini_ReadSetting("InForm/InForm.ini", "Recent Projects", STR$(i))
            IF LEN(RecentFile(i)) THEN
                LastRecent = i
                IF NOT _FILEEXISTS(RecentFile(i)) THEN MissingRecent = MissingRecent + 1
            END IF
        NEXT

        FOR i = 1 TO 9
            b$ = RecentFile(i)
            IF LEN(b$) THEN
                b$ = "&" + LTRIM$(STR$(i)) + " " + Pathname_GetFileName(b$)
                'A trailing - draws a separator above "Remove missing projects"
                IF i = LastRecent AND MissingRecent > 0 THEN b$ = b$ + "-"
                SetCaption RecentMenuItem(i), b$
                IF _FILEEXISTS(RecentFile(i)) THEN
                    ToolTip(RecentMenuItem(i)) = RecentFile(i)
                    Control(RecentMenuItem(i)).Disabled = False
                ELSE
                    ToolTip(RecentMenuItem(i)) = RecentFile(i) + CHR$(10) + "(file not found)"
                    Control(RecentMenuItem(i)).Disabled = True
                END IF
                Control(RecentMenuItem(i)).Hidden = False
            ELSE
                IF i = 1 THEN
                    SetCaption RecentMenuItem(i), "No recent projects"
                    ToolTip(RecentMenuItem(i)) = ""
                    Control(RecentMenuItem(i)).Disabled = True
                    Control(RecentMenuItem(i)).Hidden = False
                ELSE
                    Control(RecentMenuItem(i)).Hidden = True
                END IF
            END IF
        NEXT

        'Only offer to clean up the list when something is missing
        Control(FileMenuRecentRemoveMissing).Hidden = (MissingRecent = 0)
    END IF

    IF __UI_Focus = 0 THEN
        IF LEN(Caption(StatusBar)) = 0 THEN Caption(StatusBar) = "Ready."
    END IF

    IF __UI_MouseDownOnID = Red OR __UI_MouseDownOnID = Green OR __UI_MouseDownOnID = Blue OR __UI_PreviousMouseDownOnID = Red OR __UI_PreviousMouseDownOnID = Green OR __UI_PreviousMouseDownOnID = Blue THEN

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
        IF BringToFront = False THEN
            $IF WIN THEN
                i = SetForegroundWindow&(_WINDOWHANDLE)
            $END IF
            BringToFront = True
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
                        __UI_Delay COMMDLG_DELAY: Answer = _MESSAGEBOX(UiEditorTitle$, "Save the current form?", "yesnocancel", "question", 1)
                        IF Answer = 0 THEN
                            CLOSE InstanceClient
                            InstanceClient = 0
                            EXIT SUB
                        ELSEIF Answer = 1 THEN
                            SaveForm False, False
                        END IF
                    END IF

                    OpenForm InstanceStream$
                END IF
            END IF
            CLOSE InstanceClient
            InstanceClient = 0
        END IF
    ELSE
        InstanceClient = _OPENCONNECTION(InstanceHost)
        BringToFront = False
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

    STATIC prevAutoName AS _BYTE, prevMouseSwap AS _BYTE
    STATIC prevShowPos AS _BYTE, prevSnapLines AS _BYTE
    STATIC prevShowInvisible AS _BYTE, SignalsFirstSent AS _BYTE

    IF prevAutoName <> AutoNameControls OR SignalsFirstSent = False THEN
        prevAutoName = AutoNameControls
        b$ = "AUTONAME>" + MKI$(AutoNameControls) + "<END>"
        Send Client, b$
    END IF

    IF prevMouseSwap <> __UI_MouseButtonsSwap OR SignalsFirstSent = False THEN
        prevMouseSwap = __UI_MouseButtonsSwap
        b$ = "MOUSESWAP>" + MKI$(__UI_MouseButtonsSwap) + "<END>"
        Send Client, b$
    END IF

    IF prevShowPos <> __UI_ShowPositionAndSize OR SignalsFirstSent = False THEN
        prevShowPos = __UI_ShowPositionAndSize
        b$ = "SHOWPOSSIZE>" + MKI$(__UI_ShowPositionAndSize) + "<END>"
        Send Client, b$
    END IF

    IF prevShowInvisible <> __UI_ShowInvisibleControls OR SignalsFirstSent = False THEN
        prevShowInvisible = __UI_ShowInvisibleControls
        b$ = "SHOWINVISIBLECONTROLS>" + MKI$(__UI_ShowInvisibleControls) + "<END>"
        Send Client, b$
    END IF

    IF prevSnapLines <> __UI_SnapLines OR SignalsFirstSent = False THEN
        prevSnapLines = __UI_SnapLines
        b$ = "SNAPLINES>" + MKI$(__UI_SnapLines) + "<END>"
        Send Client, b$
    END IF
    SignalsFirstSent = True

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
                IF RowsDialogOpen AND FirstSelected <> CVL(thisData$) THEN CloseRowsDialog
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
            CASE "SHOWROWSDIALOG"
                'A frame with property grid rows was double-clicked in the preview
                IF NOT RowsDialogOpen AND NOT ZOrderingDialogOpen AND NOT SetBindingDialogOpen THEN OpenRowsDialog
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
                ZOrderListDirty = True
                IF NOT FormDataReceived THEN
                    FormDataReceived = True
                    IF RestoringSession THEN
                        RestoringSession = False
                        Edited = True
                        RecoverySaved$ = LastFormData$
                        Caption(StatusBar) = "Restored the unsaved changes from your last session."
                        BlinkStatusBar = TIMER
                    END IF
                ELSE
                    Edited = True
                    IF __UI_Focus > 0 THEN
                        'The rows dialog changes the preview as the user types: it keeps its focus
                        IF PropertySent THEN
                            PropertySent = False
                        ELSEIF NOT RowsDialogOpen THEN
                            LoseFocus
                        END IF
                    END IF
                END IF
            CASE "UNDOPOINTER"
                UndoPointer = CVI(thisData$)
            CASE "TOTALUNDOIMAGES"
                TotalUndoImages = CVI(thisData$)
        END SELECT
    LOOP

    IF NOT FormDataReceived THEN EXIT SUB

    'Keep a copy of unsaved work, so it can be restored if the editor closes
    IF Edited THEN
        IF LastFormData$ <> RecoverySaved$ THEN
            IF TIMER(.001) - RecoverySavedAt > 2 OR TIMER(.001) < RecoverySavedAt THEN SaveRecovery
        END IF
    ELSEIF LEN(RecoverySaved$) THEN
        DiscardRecovery
    END IF

    IF LEN(InitialControlSet) = 0 THEN
        InitialControlSet = CHR$(1)
        FOR i = 1 TO UBOUND(PreviewControls)
            IF PreviewControls(i).ID > 0 AND PreviewControls(i).Type <> __UI_Type_Font AND PreviewControls(i).Type <> __UI_Type_MenuPanel THEN
                InitialControlSet = InitialControlSet + CHR$(10) + RTRIM$(PreviewControls(i).Name) + CHR$(10)
            END IF
        NEXT
    END IF

    Control(EditMenuRestoreDimensions).Disabled = True
    SetCaption EditMenuRestoreDimensions, "Restore &image dimensions"
    IF TotalSelected = 1 AND PreviewControls(FirstSelected).Type = __UI_Type_PictureBox AND OriginalImageWidth > 0 AND OriginalImageHeight > 0 THEN
        IF PreviewControls(FirstSelected).Height - (PreviewControls(FirstSelected).BorderSize * ABS(PreviewControls(FirstSelected).HasBorder)) <> OriginalImageHeight OR PreviewControls(FirstSelected).Width - (PreviewControls(FirstSelected).BorderSize * ABS(PreviewControls(FirstSelected).HasBorder)) <> OriginalImageWidth THEN
            Control(EditMenuRestoreDimensions).Disabled = False
            SetCaption EditMenuRestoreDimensions, "Restore &image dimensions (" + LTRIM$(STR$(OriginalImageWidth)) + "x" + LTRIM$(STR$(OriginalImageHeight)) + ")"
        END IF
    END IF

    IF ThisControlTurnsInto > 0 THEN
        Control(EditMenuConvertType).Disabled = False
        SetCaption EditMenuConvertType, "Co&nvert to " + RTRIM$(__UI_Type(ThisControlTurnsInto).Name)
    ELSEIF ThisControlTurnsInto = -1 THEN
        'Offer to turn text to numeric-only TextBox
        Control(EditMenuConvertType).Disabled = False
        SetCaption EditMenuConvertType, "Co&nvert to NumericTextBox"
    ELSEIF ThisControlTurnsInto = -2 THEN
        'Offer to turn numeric-only to text TextBox
        Control(EditMenuConvertType).Disabled = False
        SetCaption EditMenuConvertType, "Co&nvert to TextBox"
    ELSE
        Control(EditMenuConvertType).Disabled = True
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
            __UI_ActivateMenu Control(AlignMenu), False
            __UI_ForceRedraw = True
        ELSEIF CVI(b$) = -4 THEN
            'User attempted to load an icon file that couldn't be previewed
            MessageBox "Icon couldn't be previewed. Make sure it's a valid icon file.", UiEditorTitle$, MsgBox_Exclamation
        ELSEIF CVI(b$) = -5 THEN
            'Context menu was successfully shown on the preview
            IF __UI_TotalActiveMenus > 0 THEN __UI_CloseAllMenus
            __UI_Focus = 0
            __UI_ForceRedraw = True
        ELSEIF CVI(b$) = -6 THEN
            'User attempted to load an invalid icon file
            MessageBox "Only .ico files are accepted.", UiEditorTitle$, MsgBox_Exclamation
        ELSEIF CVI(b$) = -7 THEN
            'A new empty form has just been created or a file has just finished loading from disk
            Edited = False
        ELSEIF CVI(b$) = -9 THEN
            'User attempted to close the preview form
            __UI_Click FileMenuNew
            EXIT SUB
        END IF
    LOOP

    IF PrevFirstSelected <> FirstSelected THEN
        LoseFocus
        PrevFirstSelected = FirstSelected
        __UI_ForceRedraw = True
        'Follow selections made in the preview, but not while our own moves are
        'still on their way there (the reported selection would be outdated)
        IF ZOrderingDialogOpen AND NOT ZOrderMovePending THEN ZOrderSelectControl FirstSelected
    END IF

    IF ZOrderingDialogOpen AND ZOrderListDirty THEN
        IF NOT ZOrderMovePending THEN
            ZOrderListDirty = False
            ZOrderRefreshList False
            ZOrderSelectControl FirstSelected
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
    Control(EditMenuUndo).Disabled = True
    Control(EditMenuRedo).Disabled = True
    IF UndoPointer > 0 THEN Control(EditMenuUndo).Disabled = False
    IF UndoPointer < TotalUndoImages THEN Control(EditMenuRedo).Disabled = False

    IF RowsDialogOpen THEN
        'Undo/redo change the table, not the form behind the dialog (a cell being edited keeps the keys)
        IF __UI_CtrlIsDown AND NOT DataGrid_IsEditing(RowsGrid) THEN
            IF __UI_KeyHit = ASC("z") OR __UI_KeyHit = ASC("Z") THEN
                RowsUndo -1
            ELSEIF __UI_KeyHit = ASC("y") OR __UI_KeyHit = ASC("Y") THEN
                RowsUndo 1
            END IF
        END IF
    ELSEIF (__UI_KeyHit = ASC("z") OR __UI_KeyHit = ASC("Z")) AND __UI_CtrlIsDown THEN
        SendSignal 214
    ELSEIF (__UI_KeyHit = ASC("y") OR __UI_KeyHit = ASC("Y")) AND __UI_CtrlIsDown THEN
        SendSignal 215
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
    Control(FontSwitchMenuSwitch).Value = ShowFontList
    IF BypassShowFontList THEN
        Control(FontSwitchMenuSwitch).Disabled = True
    ELSE
        Control(FontSwitchMenuSwitch).Disabled = False
    END IF
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
    Control(EditMenuBindControls).Disabled = True
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
        Control(EditMenuBindControls).Disabled = False

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

    'Every property row starts shown and every toggle hidden; what doesn't apply is sorted out below
    PropertyGrid_ShowAll ControlProperties, True
    PropertyGrid_ShowAll ControlToggles, False
    Control(AnchorPicker).Disabled = True

    'Pasting into the Text field keeps line breaks as \n for multiline textboxes,
    'and for list boxes and dropdowns, where each line becomes an item
    __UI_PasteLineBreakAs = ""
    IF __UI_Focus = TextTB AND FirstSelected > 0 THEN
        SELECT CASE PreviewControls(FirstSelected).Type
            CASE __UI_Type_ListBox, __UI_Type_DropdownList, __UI_Type_Frame
                __UI_PasteLineBreakAs = "\n"
            CASE __UI_Type_TextBox
                IF PreviewControls(FirstSelected).Multiline THEN __UI_PasteLineBreakAs = "\n"
        END SELECT
    END IF

    IF FirstSelected > 0 THEN
        'Values shown in the property boxes (a box being edited keeps its text until Enter, Esc or leaving it)
        PropertyGrid_SetValue ControlProperties, "name", RTRIM$(PreviewControls(FirstSelected).Name)
        PropertyGrid_SetValue ControlProperties, "caption", Replace(__UI_TrimAt0$(PreviewCaptions(FirstSelected)), CHR$(10), "\n", False, 0)

        IF PreviewControls(FirstSelected).Type = __UI_Type_ListBox OR PreviewControls(FirstSelected).Type = __UI_Type_DropdownList OR PreviewControls(FirstSelected).Type = __UI_Type_Frame OR (PreviewControls(FirstSelected).Type = __UI_Type_TextBox AND PreviewControls(FirstSelected).Multiline) THEN
            PropertyGrid_SetValue ControlProperties, "text", Replace(PreviewTexts(FirstSelected), CHR$(10), "\n", False, 0)
            IF __UI_Focus <> TextTB THEN Mask(TextTB) = ""
        ELSE
            PropertyGrid_SetValue ControlProperties, "text", PreviewTexts(FirstSelected)
            IF __UI_Focus <> TextTB THEN
                IF LEN(PreviewMasks(FirstSelected)) > 0 AND PreviewControls(FirstSelected).Type = __UI_Type_TextBox THEN
                    Mask(TextTB) = PreviewMasks(FirstSelected)
                ELSE
                    Mask(TextTB) = ""
                END IF
            END IF
        END IF
        IF __UI_Focus = TextTB THEN Control(TextTB).NumericOnly = PreviewControls(FirstSelected).NumericOnly

        PropertyGrid_SetValue ControlProperties, "mask", PreviewMasks(FirstSelected)
        PropertyGrid_SetValue ControlProperties, "top", LTRIM$(STR$(PreviewControls(FirstSelected).Top))
        PropertyGrid_SetValue ControlProperties, "left", LTRIM$(STR$(PreviewControls(FirstSelected).Left))
        PropertyGrid_SetValue ControlProperties, "width", LTRIM$(STR$(PreviewControls(FirstSelected).Width))
        PropertyGrid_SetValue ControlProperties, "height", LTRIM$(STR$(PreviewControls(FirstSelected).Height))

        IF LEN(PreviewFonts(FirstSelected)) > 0 THEN
            PropertyGrid_SetValue ControlProperties, "font", PreviewFonts(FirstSelected)
            SelectFontInList PreviewActualFonts(FirstSelected)
        ELSE
            PropertyGrid_SetValue ControlProperties, "font", PreviewFonts(PreviewFormID)
            SelectFontInList PreviewActualFonts(PreviewFormID)
        END IF

        PropertyGrid_SetValue ControlProperties, "tooltip", Replace(PreviewTips(FirstSelected), CHR$(10), "\n", False, 0)
        PropertyGrid_SetValue ControlProperties, "value", LTRIM$(STR$(PreviewControls(FirstSelected).Value))
        PropertyGrid_SetValue ControlProperties, "min", LTRIM$(STR$(PreviewControls(FirstSelected).Min))
        PropertyGrid_SetValue ControlProperties, "max", LTRIM$(STR$(PreviewControls(FirstSelected).Max))
        PropertyGrid_SetValue ControlProperties, "interval", LTRIM$(STR$(PreviewControls(FirstSelected).Interval))
        PropertyGrid_SetValue ControlProperties, "mininterval", LTRIM$(STR$(PreviewControls(FirstSelected).MinInterval))
        PropertyGrid_SetValue ControlProperties, "padding", LTRIM$(STR$(PreviewControls(FirstSelected).Padding))
        PropertyGrid_SetValue ControlToggles, "bordersize", LTRIM$(STR$(PreviewControls(FirstSelected).BorderSize))
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
    Control(MultilineCB).Value = PreviewControls(FirstSelected).Multiline
    Control(BooleanOptions).Value = ABS(PreviewControls(FirstSelected).Value <> 0) + 1
    Control(AlignOptions).Value = PreviewControls(FirstSelected).Align + 1
    Control(VAlignOptions).Value = PreviewControls(FirstSelected).VAlign + 1
    Control(BulletOptions).Value = PreviewControls(FirstSelected).BulletStyle + 1
    Control(Transparent).Value = PreviewControls(FirstSelected).BackStyle
    Control(Resizable).Value = PreviewControls(FirstSelected).CanResize
    Control(AutoScroll).Value = PreviewControls(FirstSelected).AutoScroll
    Control(SearchableCB).Value = PreviewControls(FirstSelected).Searchable
    Control(FuzzyCB).Value = PreviewControls(FirstSelected).Fuzzy
    Control(ReorderableCB).Value = PreviewControls(FirstSelected).Reorderable
    AnchorPickerFlags = PreviewControls(FirstSelected).Anchor
    IF AnchorPickerFlags = 0 THEN AnchorPickerFlags = __UI_Anchor_Left OR __UI_Anchor_Top
    Control(AutoSize).Value = PreviewControls(FirstSelected).AutoSize
    Control(HideTicks).Value = (PreviewControls(FirstSelected).Height = __UI_Type(__UI_Type_TrackBar).MinimumHeight)
    Control(AutoPlayGif).Value = PreviewAutoPlayGif(FirstSelected)

    IF LEN(PreviewContextMenu(FirstSelected)) THEN
        DIM ItemFound AS _BYTE
        ItemFound = SelectItem(ContextMenuControlsList, PreviewContextMenu(FirstSelected))
    ELSE
        Control(ContextMenuControlsList).Value = 1
    END IF
    IF __UI_BypassKeyCombos = False THEN
        IF TotalSelected = 1 AND LEN(PreviewKeyCombos(FirstSelected)) THEN
            Caption(KeyboardComboBT) = PreviewKeyCombos(FirstSelected)
        ELSE
            Caption(KeyboardComboBT) = "Click to assign"
        END IF
    END IF

    STATIC ShowInvalidValueWarning AS _BYTE
    IF PropertyGrid_RowState(PropertyGrid_GridOf(__UI_Focus), PropertyGrid_RowOf$(__UI_Focus)) = __UI_PropertyGrid_Rejected THEN
        IF ShowInvalidValueWarning = False THEN
            ShowInvalidValueWarning = True
            Caption(StatusBar) = "Invalid value; ESC for previous or adjusted value"
            BlinkStatusBar = TIMER
        END IF
    ELSE
        ShowInvalidValueWarning = False
    END IF

    IF PreviewControls(FirstSelected).Type = __UI_Type_Frame AND TotalSelected > 0 THEN
        'A frame's Text holds its property grid rows, or a data grid's columns and rows, edited in a table (see OpenRowsDialog)
        IF IsDataGridFrame(FirstSelected) THEN
            DIM GridColumns$, GridRows$
            __UI_DGSplitDefinition PreviewTexts(FirstSelected), GridColumns$, GridRows$
            Caption(EditColumnsBT) = CountCaption$(__UI_DGPartCount(GridColumns$, CHR$(10)) - 1, "column")
            Caption(EditRowsBT) = CountCaption$(__UI_DGPartCount(GridRows$, CHR$(10)) - 1, "row")
            ToolTip(EditColumnsBT) = "The data grid's columns: their captions, kinds and widths"
            ToolTip(EditRowsBT) = "The rows the data grid has when the program starts"
        ELSE
            Caption(EditRowsBT) = CountCaption$(__UI_DGPartCount(PropertyGridRowList$(FirstSelected), CHR$(10)) - 1, "row")
            ToolTip(EditRowsBT) = "Rows written here turn the frame into a property grid when the program runs"
        END IF
    END IF

    IF RowsDialogOpen THEN UpdateRowsDialog

    'Hide the properties that don't apply
    PropertyGrid_ShowRows ControlProperties, "align,boolean,valign,bullet,rows,columns", False
    PropertyGrid_SetLabel ControlProperties, "text", "Text"
    PropertyGrid_SetLabel ControlProperties, "value", "Value"
    PropertyGrid_SetLabel ControlProperties, "max", "Max"
    IF TotalSelected > 0 THEN
        SELECT EVERYCASE PreviewControls(FirstSelected).Type
            CASE __UI_Type_ToggleSwitch
                PropertyGrid_ShowRows ControlToggles, "canhavefocus,disabled,hidden", True
                PropertyGrid_ShowRows ControlProperties, "caption,text,font,fontlist,min,max,interval,mininterval,padding,bullet", False
                PropertyGrid_ShowRow ControlProperties, "boolean", True
            CASE __UI_Type_MenuBar, __UI_Type_MenuItem
                PropertyGrid_ShowRows ControlToggles, "disabled,hidden", True
            CASE __UI_Type_MenuBar
                PropertyGrid_ShowOnly ControlProperties, "name,caption,tooltip,align"
            CASE __UI_Type_ContextMenu
                PropertyGrid_ShowOnly ControlProperties, "name"
            CASE __UI_Type_MenuItem
                PropertyGrid_ShowOnly ControlProperties, "name,caption,text,tooltip,bullet,boolean,keycombo"
            CASE __UI_Type_PictureBox
                PropertyGrid_SetLabel ControlProperties, "text", "Image file"
                PropertyGrid_ShowRows ControlToggles, "stretch,transparent", True
                IF PreviewAnimatedGif(FirstSelected) THEN PropertyGrid_ShowRow ControlToggles, "autoplaygif", True
                PropertyGrid_ShowOnly ControlProperties, "name,text,top,left,width,height,tooltip,align,valign"
            CASE __UI_Type_Label
                PropertyGrid_ShowRows ControlToggles, "transparent,autosize", True
                PropertyGrid_ShowOnly ControlProperties, "name,caption,top,left,width,height,font,tooltip,padding,align,valign,fontlist"
            CASE __UI_Type_Frame
                'Its Text holds property grid rows, or a data grid's columns and rows, edited in a table
                PropertyGrid_ShowRow ControlToggles, "transparent", False
                IF IsDataGridFrame(FirstSelected) THEN
                    PropertyGrid_ShowOnly ControlProperties, "name,caption,columns,rows,top,left,width,height,font,tooltip,fontlist"
                ELSE
                    PropertyGrid_ShowOnly ControlProperties, "name,caption,rows,top,left,width,height,font,tooltip,fontlist"
                END IF
            CASE __UI_Type_TextBox
                STATIC PreviousNumericState AS _BYTE
                PropertyGrid_ShowRow ControlToggles, "transparent", True
                PropertyGrid_ShowRow ControlToggles, "password", NOT ((PreviewControls(FirstSelected).NumericOnly <> False) OR PreviewControls(FirstSelected).Multiline)
                PropertyGrid_ShowRow ControlToggles, "multiline", NOT ((PreviewControls(FirstSelected).NumericOnly <> False) OR PreviewControls(FirstSelected).PasswordField OR LEN(PreviewMasks(FirstSelected)) > 0)
                IF PreviousNumericState <> PreviewControls(FirstSelected).NumericOnly THEN
                    PreviousNumericState = PreviewControls(FirstSelected).NumericOnly
                    __UI_ForceRedraw = True
                END IF
                PropertyGrid_ShowAll ControlProperties, True
                IF PreviewControls(FirstSelected).NumericOnly = True THEN
                    PropertyGrid_ShowRows ControlProperties, "value,min,max,mask,interval,padding,align,valign,mininterval,bullet,boolean,keycombo", False
                ELSEIF PreviewControls(FirstSelected).NumericOnly = __UI_NumericWithBounds THEN
                    PropertyGrid_ShowRows ControlProperties, "value,mask,interval,padding,align,valign,mininterval,bullet,boolean,keycombo", False
                ELSE
                    PropertyGrid_SetLabel ControlProperties, "max", "Max length"
                    PropertyGrid_ShowRows ControlProperties, "value,min,interval,padding,align,valign,mininterval,bullet,boolean,keycombo", False
                END IF
            CASE __UI_Type_Button, __UI_Type_MenuItem
                PropertyGrid_SetLabel ControlProperties, "text", "Image file"
            CASE __UI_Type_Button
                PropertyGrid_ShowAll ControlProperties, True
                PropertyGrid_ShowRows ControlProperties, "value,min,max,interval,padding,mask,align,valign,mininterval,bullet,boolean", False
            CASE __UI_Type_CheckBox, __UI_Type_RadioButton
                PropertyGrid_ShowRow ControlToggles, "transparent", True
                PropertyGrid_ShowAll ControlProperties, True
                PropertyGrid_ShowRows ControlProperties, "text,min,max,interval,padding,mask,align,valign,mininterval,bullet,value", False
            CASE __UI_Type_ToggleSwitch
                PropertyGrid_ShowRow ControlToggles, "transparent", False
                PropertyGrid_ShowAll ControlProperties, True
                PropertyGrid_ShowRows ControlProperties, "width,height,text,min,max,interval,padding,mask,align,valign,mininterval,bullet,value,font,fontlist", False
            CASE __UI_Type_ProgressBar
                PropertyGrid_ShowAll ControlProperties, True
                PropertyGrid_ShowRows ControlProperties, "text,interval,padding,mask,align,valign,mininterval,bullet,boolean,keycombo", False
            CASE __UI_Type_TrackBar
                PropertyGrid_ShowRow ControlToggles, "hideticks", True
                PropertyGrid_ShowAll ControlProperties, True
                PropertyGrid_ShowRows ControlProperties, "caption,text,font,padding,mask,align,valign,bullet,boolean,fontlist,keycombo", False
            CASE __UI_Type_ListBox, __UI_Type_DropdownList
                PropertyGrid_SetLabel ControlProperties, "text", "List items"
                PropertyGrid_SetLabel ControlProperties, "value", "Selected item"
                PropertyGrid_ShowRow ControlToggles, "transparent", True
                PropertyGrid_ShowAll ControlProperties, True
                PropertyGrid_ShowRows ControlProperties, "caption,min,max,interval,padding,mask,align,valign,mininterval,bullet,boolean,keycombo", False
            CASE __UI_Type_ListBox
                PropertyGrid_ShowRows ControlToggles, "autoscroll,reorderable", True
            CASE __UI_Type_DropdownList
                PropertyGrid_ShowRow ControlToggles, "searchable", True
                PropertyGrid_ShowRow ControlToggles, "fuzzy", PreviewControls(FirstSelected).Searchable
            CASE __UI_Type_TabControl
                PropertyGrid_SetLabel ControlProperties, "text", "Tabs"
                PropertyGrid_SetLabel ControlProperties, "value", "Active tab"
                PropertyGrid_ShowRow ControlToggles, "transparent", False
                PropertyGrid_ShowOnly ControlProperties, "name,text,value,top,left,width,height,font,tooltip,fontlist"
            CASE __UI_Type_Frame, __UI_Type_Label, __UI_Type_TextBox, __UI_Type_ListBox, __UI_Type_DropdownList, __UI_Type_PictureBox
                PropertyGrid_ShowRow ControlToggles, "hasborder", True
            CASE __UI_Type_ProgressBar
                PropertyGrid_ShowRow ControlToggles, "showpercentage", True
            CASE __UI_Type_Label
                PropertyGrid_ShowRow ControlToggles, "wordwrap", True
            CASE __UI_Type_Button, __UI_Type_CheckBox, __UI_Type_RadioButton, __UI_Type_TextBox, __UI_Type_ListBox, __UI_Type_DropdownList, __UI_Type_TrackBar, __UI_Type_TabControl
                PropertyGrid_ShowRow ControlToggles, "canhavefocus", True
            CASE __UI_Type_Button, __UI_Type_CheckBox, __UI_Type_RadioButton, __UI_Type_TextBox, __UI_Type_ListBox, __UI_Type_DropdownList, __UI_Type_TrackBar, __UI_Type_Label, __UI_Type_ProgressBar, __UI_Type_TabControl
                PropertyGrid_ShowRow ControlToggles, "disabled", True
            CASE __UI_Type_Frame, __UI_Type_TabControl, __UI_Type_Button, __UI_Type_CheckBox, __UI_Type_RadioButton, __UI_Type_TextBox, __UI_Type_ListBox, __UI_Type_DropdownList, __UI_Type_TrackBar, __UI_Type_Label, __UI_Type_ProgressBar, __UI_Type_PictureBox
                PropertyGrid_ShowRow ControlToggles, "hidden", True
            CASE __UI_Type_Frame, __UI_Type_TabControl, __UI_Type_Button, __UI_Type_CheckBox, __UI_Type_RadioButton, __UI_Type_TextBox, __UI_Type_ListBox, __UI_Type_DropdownList, __UI_Type_TrackBar, __UI_Type_Label, __UI_Type_ProgressBar, __UI_Type_PictureBox, __UI_Type_ToggleSwitch
                Control(AnchorPicker).Disabled = False
            CASE __UI_Type_Label
                PropertyGrid_ShowRows ControlProperties, "align,valign", True
        END SELECT
    ELSE
        'Properties relative to the form
        PropertyGrid_ShowRows ControlToggles, "centered,resizable,addgifextension", True
        PropertyGrid_SetLabel ControlProperties, "text", "Icon file"
        PropertyGrid_ShowOnly ControlProperties, "name,caption,text,width,height,font,fontlist"
    END IF

    IF TotalSelected > 1 THEN PropertyGrid_ShowRow ControlProperties, "name", False

    IF HasFontList AND (ShowFontList = True AND BypassShowFontList = False) THEN
        PropertyGrid_ShowRow ControlProperties, "font", False
    ELSE
        PropertyGrid_ShowRow ControlProperties, "fontlist", False
    END IF

    SELECT CASE PreviewControls(FirstSelected).Type
        CASE __UI_Type_ContextMenu, __UI_Type_MenuBar, __UI_Type_MenuItem
            PropertyGrid_ShowRow ControlProperties, "contextmenu", False
        CASE ELSE
            PropertyGrid_ShowRow ControlProperties, "contextmenu", True
    END SELECT

    'Border size sits beside "Has border"
    IF Control(HasBorder).Value = True AND PreviewControls(FirstSelected).Type <> __UI_Type_Frame AND PreviewControls(FirstSelected).Type <> __UI_Type_TabControl THEN
        PropertyGrid_ShowRow ControlToggles, "bordersize", PropertyGrid_RowShown(ControlToggles, "hasborder")
        Caption(HasBorder) = "Has border     Size"
    END IF

    'Stack the rows now, so the controls placed next to them below get their final positions
    PropertyGrid_Layout ControlProperties
    PropertyGrid_Layout ControlToggles
    Control(SizeTB).Top = Control(HasBorder).Top

    'The anchor picker goes below the toggles, with its description under it
    Control(AnchorPicker).Hidden = Control(AnchorPicker).Disabled
    Control(AnchorLB).Hidden = Control(AnchorPicker).Hidden
    Control(AnchorInfoLB).Hidden = Control(AnchorPicker).Hidden
    IF NOT Control(AnchorPicker).Hidden THEN
        Control(AnchorPicker).Top = PropertyGrid_NextTop(ControlToggles) + 6
        Control(AnchorLB).Top = Control(AnchorPicker).Top
        Control(AnchorInfoLB).Top = Control(AnchorPicker).Top + Control(AnchorPicker).Height + 2
        UpdateAnchorPicker
    END IF

    'Custom cases
    Control(AutoPlayGif).Disabled = NOT Control(AddGifExtensionToggle).Value
    Control(AutoSize).Disabled = Control(WordWrap).Value

    Control(PasteListBT).Hidden = True
    Control(BrowseImageBT).Hidden = True

    SELECT CASE PreviewControls(FirstSelected).Type
        CASE __UI_Type_PictureBox, __UI_Type_Button, __UI_Type_MenuItem, __UI_Type_Form
            IF PropertyGrid_RowShown(ControlProperties, "text") THEN
                Control(BrowseImageBT).Top = Control(TextTB).Top
                Control(BrowseImageBT).Hidden = False
            END IF
    END SELECT

    IF PreviewControls(FirstSelected).Type = __UI_Type_ListBox OR PreviewControls(FirstSelected).Type = __UI_Type_DropdownList THEN
        IF INSTR(_CLIPBOARD$, CHR$(10)) THEN
            Control(PasteListBT).Top = Control(TextTB).Top
            Control(PasteListBT).Hidden = False
        END IF
    ELSEIF (PreviewControls(FirstSelected).Type = __UI_Type_Label AND PreviewControls(FirstSelected).WordWrap = True) THEN
        IF INSTR(_CLIPBOARD$, CHR$(10)) THEN
            Control(PasteListBT).Top = Control(CaptionTB).Top
            Control(PasteListBT).Hidden = False
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
    'Unsaved work is kept and restored the next time the editor starts
    IF Edited THEN SaveRecovery
    SaveSettings
END SUB

SUB SaveSettings
    DIM value$

    IF _DIREXISTS("InForm") = 0 THEN EXIT SUB

    IF PreviewAttached THEN value$ = "True" ELSE value$ = "False"
    Ini_WriteSetting "InForm/InForm.ini", "InForm Settings", "Keep preview window attached", value$

    IF AutoNameControls THEN value$ = "True" ELSE value$ = "False"
    Ini_WriteSetting "InForm/InForm.ini", "InForm Settings", "Auto-name controls", value$

    IF __UI_SnapLines THEN value$ = "True" ELSE value$ = "False"
    Ini_WriteSetting "InForm/InForm.ini", "InForm Settings", "Snap to edges", value$

    IF __UI_ShowPositionAndSize THEN value$ = "True" ELSE value$ = "False"
    Ini_WriteSetting "InForm/InForm.ini", "InForm Settings", "Show position and size", value$

    IF __UI_ShowInvisibleControls THEN value$ = "True" ELSE value$ = "False"
    Ini_WriteSetting "InForm/InForm.ini", "InForm Settings", "Show invisible controls", value$

    IF ShowFontList THEN value$ = "True" ELSE value$ = "False"
    Ini_WriteSetting "InForm/InForm.ini", "InForm Settings", "Show font list", value$

    IF __UI_MouseButtonsSwap THEN value$ = "True" ELSE value$ = "False"
    Ini_WriteSetting "InForm/InForm.ini", "InForm Settings", "Swap mouse buttons", value$

    IF LEN(EditorTheme) THEN Ini_WriteSetting "InForm/InForm.ini", "InForm Settings", "Editor theme", EditorTheme
END SUB

SUB __UI_BeforeInit
    __UI_KeepScreenHidden = True
    __UI_EditorMode = True
END SUB

SUB __UI_FormResized
END SUB

SUB Handshake
    'Handshake: each module sends the other their PID:

    DIM b$

    Stream$ = "" 'clear buffer

    b$ = "EDITORPID>" + MKL$(System_GetProcessID) + "<END>"
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

    'Editor theme (also draws the icons)
    b$ = LCASE$(Ini_ReadSetting("InForm/InForm.ini", "InForm Settings", "Editor theme"))
    IF b$ <> "dark" THEN b$ = "light"
    SetEditorTheme b$

    __UI_KeepScreenHidden = False
    _SCREENSHOW
    _ICON

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
        InstanceHost = _OPENHOST("TCP/IP:" + UIEDITOR_TCP_PORT)
    LOOP UNTIL InstanceHost <> 0 OR HostAttempts > 1000

    IF InstanceHost = 0 THEN
        'There is probably another instance of InForm Designer running.
        '(i) attempt to communicate and pass parameters and
        '(ii) bring it to the front.

        HostAttempts = 0
        DO
            HostAttempts = HostAttempts + 1
            Host = _OPENCLIENT("TCP/IP:" + UIEDITOR_TCP_PORT + ":localhost")
        LOOP UNTIL Host <> 0 OR HostAttempts > 1000

        IF Host THEN
            b$ = "NEWINSTANCE>" + COMMAND$ + "<END>"
            Send Host, b$
            _DELAY 1
            CLOSE Host
        END IF
        SYSTEM
    END IF

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

    PreviewAttached = True
    AutoNameControls = True
    __UI_ShowPositionAndSize = True
    __UI_ShowInvisibleControls = True
    __UI_SnapLines = True

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
    value$ = Ini_ReadSetting("InForm/InForm.ini", "InForm Settings", "Keep preview window attached")
    IF LEN(value$) THEN
        PreviewAttached = (value$ = "True")
    ELSE
        Ini_WriteSetting "InForm/InForm.ini", "InForm Settings", "Keep preview window attached", "True"
        PreviewAttached = True
    END IF

    value$ = Ini_ReadSetting("InForm/InForm.ini", "InForm Settings", "Auto-name controls")
    IF LEN(value$) THEN
        AutoNameControls = (value$ = "True")
    ELSE
        Ini_WriteSetting "InForm/InForm.ini", "InForm Settings", "Auto-name controls", "True"
        AutoNameControls = True
    END IF

    value$ = Ini_ReadSetting("InForm/InForm.ini", "InForm Settings", "Snap to edges")
    IF LEN(value$) THEN
        __UI_SnapLines = (value$ = "True")
    ELSE
        Ini_WriteSetting "InForm/InForm.ini", "InForm Settings", "Snap to edges", "True"
        __UI_SnapLines = True
    END IF

    value$ = Ini_ReadSetting("InForm/InForm.ini", "InForm Settings", "Show position and size")
    IF LEN(value$) THEN
        __UI_ShowPositionAndSize = (value$ = "True")
    ELSE
        Ini_WriteSetting "InForm/InForm.ini", "InForm Settings", "Show position and size", "True"
        __UI_ShowPositionAndSize = True
    END IF

    value$ = Ini_ReadSetting("InForm/InForm.ini", "InForm Settings", "Show invisible controls")
    IF LEN(value$) THEN
        __UI_ShowInvisibleControls = (value$ = "True")
    ELSE
        Ini_WriteSetting "InForm/InForm.ini", "InForm Settings", "Show invisible controls", "True"
        __UI_ShowInvisibleControls = True
    END IF

    value$ = Ini_ReadSetting("InForm/InForm.ini", "InForm Settings", "Show font list")
    IF LEN(value$) THEN
        ShowFontList = (value$ = "True")
    ELSE
        Ini_WriteSetting "InForm/InForm.ini", "InForm Settings", "Show font list", "True"
        ShowFontList = True
    END IF

    value$ = Ini_ReadSetting("InForm/InForm.ini", "InForm Settings", "Swap mouse buttons")
    __UI_MouseButtonsSwap = (value$ = "True")
    Control(OptionsMenuSwapButtons).Value = __UI_MouseButtonsSwap

    Control(ViewMenuPreviewDetach).Value = PreviewAttached
    Control(OptionsMenuAutoName).Value = AutoNameControls
    Control(OptionsMenuSnapLines).Value = __UI_SnapLines
    Control(ViewMenuShowPositionAndSize).Value = __UI_ShowPositionAndSize
    Control(ViewMenuShowInvisibleControls).Value = __UI_ShowInvisibleControls

    IF _FILEEXISTS("InForm/UiEditorPreview.frmbin") THEN KILL "InForm/UiEditorPreview.frmbin"

    b$ = "Parsing command line..."
    GOSUB ShowMessage

    'Unsaved work from the last session?
    IF _FILEEXISTS(RECOVERY_FILE) THEN
        DIM RestoreIt AS _BYTE
        RestoreIt = True
        IF _FILEEXISTS(COMMAND$) THEN
            __UI_Delay COMMDLG_DELAY
            RestoreIt = (_MESSAGEBOX(UiEditorTitle$, "There are unsaved changes from your last session. Restore them instead of opening " + COMMAND$ + "?", "yesno", "question", 1) = 1)
        END IF
        IF RestoreIt THEN RestoringSession = LoadRecovery
        IF NOT RestoringSession THEN DiscardRecovery
    END IF

    IF _FILEEXISTS(COMMAND$) AND NOT RestoringSession THEN
        SELECT CASE LCASE$(RIGHT$(COMMAND$, 4))
            CASE ".bas"
                'Does this .bas $include a .frm?
                FreeFileNum = FREEFILE
                DIM uB$
                OPEN COMMAND$ FOR BINARY AS #FreeFileNum
                b$ = SPACE$(LOF(FreeFileNum))
                GET #FreeFileNum, 1, b$
                SEEK #FreeFileNum, 1
                IF INSTR(LCASE$(b$), "'$include:'inform/extensions/gifplay.bi'") > 0 OR INSTR(LCASE$(b$), "'$include:'inform/extensions/gifplay.bm'") > 0 OR INSTR(LCASE$(b$), "'$include:'inform/extensions/gifplay.bas'") > 0 THEN
                    LoadedWithGifExtension = True
                END IF
                DO
                    IF EOF(FreeFileNum) THEN EXIT DO
                    LINE INPUT #FreeFileNum, b$
                    b$ = _TRIM$(b$)
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
                                                FileToOpen$ = LEFT$(COMMAND$, i - 1) + DIRECTORY_SEPARATOR + FileToOpen$
                                                IF _FILEEXISTS(FileToOpen$) THEN FileToOpen$ = _FULLPATH$(FileToOpen$) ' get absolute path name
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
                        IF INSTR(LCASE$(b$), "'$include:'inform/extensions/gifplay.bi'") > 0 OR INSTR(LCASE$(b$), "'$include:'inform/extensions/gifplay.bm'") > 0 OR INSTR(LCASE$(b$), "'$include:'inform/extensions/gifplay.bas'") > 0 THEN
                            LoadedWithGifExtension = True
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
            IF LoadedWithGifExtension = False THEN
                LoadedWithGifExtension = 1 'Query whether this file contains the gif extension
                Control(AddGifExtensionToggle).Value = False
            ELSE
                Control(AddGifExtensionToggle).Value = True
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

    'Load font list
    b$ = "Loading font list..."
    GOSUB ShowMessage
    LoadFontList

    'The Control properties frame is a property grid: rows are stacked in this order,
    'and only the ones that apply to the selected control are shown (see __UI_BeforeUpdateDisplay)
    PropertyGrid_AdoptRow ControlProperties, "name", NameLB, NameTB
    PropertyGrid_AdoptRow ControlProperties, "caption", CaptionLB, CaptionTB
    PropertyGrid_AdoptRow ControlProperties, "text", TextLB, TextTB
    PropertyGrid_AdoptRow ControlProperties, "columns", ColumnsLB, EditColumnsBT
    PropertyGrid_AdoptRow ControlProperties, "rows", RowsLB, EditRowsBT
    PropertyGrid_AdoptRow ControlProperties, "mask", MaskLB, MaskTB
    PropertyGrid_AdoptRow ControlProperties, "top", TopLB, TopTB
    PropertyGrid_AdoptRow ControlProperties, "left", LeftLB, LeftTB
    PropertyGrid_AdoptRow ControlProperties, "width", WidthLB, WidthTB
    PropertyGrid_AdoptRow ControlProperties, "height", HeightLB, HeightTB
    PropertyGrid_AdoptRow ControlProperties, "font", FontLB, FontTB
    PropertyGrid_AdoptRow ControlProperties, "fontlist", FontListLB, FontList
    PropertyGrid_AttachControl ControlProperties, "fontlist", FontSizeList
    PropertyGrid_AdoptRow ControlProperties, "tooltip", TooltipLB, TooltipTB
    PropertyGrid_AdoptRow ControlProperties, "value", ValueLB, ValueTB
    PropertyGrid_AdoptRow ControlProperties, "boolean", BooleanLB, BooleanOptions
    PropertyGrid_AdoptRow ControlProperties, "min", MinLB, MinTB
    PropertyGrid_AdoptRow ControlProperties, "max", MaxLB, MaxTB
    PropertyGrid_AdoptRow ControlProperties, "interval", IntervalLB, IntervalTB
    PropertyGrid_AdoptRow ControlProperties, "mininterval", MinIntervalLB, MinIntervalTB
    PropertyGrid_AdoptRow ControlProperties, "padding", PaddingLeftrightLB, PaddingTB
    PropertyGrid_AdoptRow ControlProperties, "align", TextAlignLB, AlignOptions
    PropertyGrid_AdoptRow ControlProperties, "valign", VerticalAlignLB, VAlignOptions
    PropertyGrid_AdoptRow ControlProperties, "bullet", BulletOptionsLB, BulletOptions
    PropertyGrid_AdoptRow ControlProperties, "contextmenu", ContextMenuLB, ContextMenuControlsList
    PropertyGrid_AdoptRow ControlProperties, "keycombo", KeyboardComboLB, KeyboardComboBT

    'The toggles frame is another one, with check boxes and no labels
    PropertyGrid_AdoptRow ControlToggles, "stretch", 0, Stretch
    PropertyGrid_AdoptRow ControlToggles, "hasborder", 0, HasBorder
    PropertyGrid_AdoptRow ControlToggles, "showpercentage", 0, ShowPercentage
    PropertyGrid_AdoptRow ControlToggles, "password", 0, PasswordMaskCB
    PropertyGrid_AdoptRow ControlToggles, "multiline", 0, MultilineCB
    PropertyGrid_AdoptRow ControlToggles, "wordwrap", 0, WordWrap
    PropertyGrid_AdoptRow ControlToggles, "canhavefocus", 0, CanHaveFocus
    PropertyGrid_AdoptRow ControlToggles, "disabled", 0, Disabled
    PropertyGrid_AdoptRow ControlToggles, "transparent", 0, Transparent
    PropertyGrid_AdoptRow ControlToggles, "hidden", 0, Hidden
    PropertyGrid_AdoptRow ControlToggles, "centered", 0, CenteredWindow
    PropertyGrid_AdoptRow ControlToggles, "resizable", 0, Resizable
    PropertyGrid_AdoptRow ControlToggles, "autoscroll", 0, AutoScroll
    PropertyGrid_AdoptRow ControlToggles, "searchable", 0, SearchableCB
    PropertyGrid_AdoptRow ControlToggles, "fuzzy", 0, FuzzyCB
    PropertyGrid_AdoptRow ControlToggles, "reorderable", 0, ReorderableCB
    PropertyGrid_AdoptRow ControlToggles, "autosize", 0, AutoSize
    PropertyGrid_AdoptRow ControlToggles, "hideticks", 0, HideTicks
    PropertyGrid_AdoptRow ControlToggles, "autoplaygif", 0, AutoPlayGif
    PropertyGrid_AdoptRow ControlToggles, "addgifextension", 0, AddGifExtensionToggle
    'The border size box sits next to "Has border", so it's left out of the stacking
    PropertyGrid_AdoptRow ControlToggles, "bordersize", 0, SizeTB
    PropertyGrid_SetFloating ControlToggles, "bordersize", True

    'The table in the property grid rows dialog (its columns are set when it opens, see SetRowsGridColumns)
    DataGrid_Attach RowsGrid
    Control(RowsGrid).HasBorder = False

    ToolTip(FontTB) = "Multiple fonts can be specified by separating them with a question mark (?)." + CHR$(10) + "The first font that can be found/loaded is used."
    ToolTip(FontList) = "System fonts may not be available in all computers. To specify a local font file, right-click 'Font' to the left of this list and disable 'Show system fonts list'."
    ToolTip(AnchorLB) = "The edges of the form (or of the frame/tab control it's in) that the control follows when that gets resized."
    ToolTip(AnchorPicker) = "Click a side to anchor the control to that edge of its parent, or to release it."
    ToolTip(ColorPreview) = "Click to copy the current color's hex value to the clipboard."
    ToolTip(KeyboardComboBT) = "Click to assign a key combination to the selected control"


    FOR i = 1 TO 9
        RecentMenuItem(i) = __UI_GetID("FileMenuRecent" + LTRIM$(STR$(i)))
    NEXT

    b$ = "Launching Preview component..."
    GOSUB ShowMessage

    $IF WIN THEN
        SHELL _DONTWAIT ".\InForm\UiEditorPreview.exe " + HostPort
    $ELSE
        SHELL _DONTWAIT "./InForm/UiEditorPreview " + HostPort
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
    __UI_ForceRedraw = True
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
        CLS , __UI_DefaultColor(__UI_Type_Form, 2)
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

        CASE ControlList, UpBT, DownBT, CloseZOrderingBT
            IF __UI_KeyHit = 27 THEN
                __UI_Click CloseZOrderingBT
            END IF
        CASE RowsGrid, RowsFirstBT, RowsPrevBT, RowsNextBT, RowsLastBT, RowsAddBT, RowsDeleteBT, RowsUpBT, RowsDownBT, RowsOKBT, RowsCancelBT
            'Esc while a cell is being edited only stops the editing (the grid takes the key)
            IF __UI_KeyHit = 27 THEN CloseRowsDialog
            'Delete clears a cell; with several rows selected, it removes them
            IF id = RowsGrid AND __UI_KeyHit = 21248 THEN
                IF DataGrid_SelectionLast(RowsGrid) > DataGrid_SelectionFirst(RowsGrid) THEN
                    DataGrid_RemoveSelection RowsGrid
                    RowsChanged
                END IF
            END IF
        CASE NameTB, CaptionTB, TextTB, MaskTB, TopTB, LeftTB, WidthTB, HeightTB, FontTB, TooltipTB, ValueTB, MinTB, MaxTB, IntervalTB, PaddingTB, MinIntervalTB, SizeTB
            'Enter and Esc were already handled by the property grid
            IF __UI_KeyHit = 13 THEN
                'The new value was sent to the preview (see SendPropertyEdit)
            ELSEIF __UI_KeyHit = 32 AND id = NameTB THEN
                __UI_KeyHit = 0
                Caption(StatusBar) = "Control names cannot contain spaces"
                BlinkStatusBar = TIMER
            ELSEIF __UI_KeyHit = 27 THEN
                Caption(StatusBar) = "Previous property value restored."
            ELSE
                Send Client, "LOCKCONTROLS><END>"
            END IF
        CASE KeyboardComboBT
            DIM Combo$
            IF __UI_CtrlIsDown THEN Combo$ = "Ctrl+"
            IF __UI_ShiftIsDown THEN Combo$ = Combo$ + "Shift+"
            SELECT CASE __UI_KeyHit
                CASE 27
                    __UI_Focus = 0
                    __UI_BypassKeyCombos = False
                    ToolTip(KeyboardComboBT) = "Click to assign a key combination to the selected control"
                    SendData MKI$(0), 43
                    __UI_ForceRedraw = True
                CASE __UI_FKey(1), __UI_FKey(2), __UI_FKey(3), __UI_FKey(4), __UI_FKey(5), __UI_FKey(6), __UI_FKey(7), __UI_FKey(8), __UI_FKey(9), __UI_FKey(10), __UI_FKey(11), __UI_FKey(12)
                    FOR i = 1 TO 12
                        IF __UI_FKey(i) = __UI_KeyHit THEN
                            Combo$ = Combo$ + "F" + LTRIM$(STR$(i))
                            SendData MKI$(LEN(Combo$)) + Combo$, 43
                            __UI_Focus = 0
                            __UI_BypassKeyCombos = False
                            ToolTip(KeyboardComboBT) = "Click to assign a key combination to the selected control"
                            __UI_ForceRedraw = True
                            EXIT FOR
                        END IF
                    NEXT
                CASE 65 TO 90, 97 TO 122 'Alphanumeric
                    Combo$ = Combo$ + UCASE$(CHR$(__UI_KeyHit))
                    IF INSTR(Combo$, "Ctrl+") > 0 THEN
                        SendData MKI$(LEN(Combo$)) + Combo$, 43
                        __UI_Focus = 0
                        __UI_BypassKeyCombos = False
                        ToolTip(KeyboardComboBT) = "Click to assign a key combination to the selected control"
                        __UI_ForceRedraw = True
                    END IF
            END SELECT
    END SELECT
END SUB

''' @brief Sends the preview a property that was just edited in the Control properties or toggles frame.
SUB SendPropertyEdit (GridID AS LONG)
    DIM b$, Key$, NewValue$, id AS LONG, Signal AS INTEGER, DataType AS INTEGER

    Key$ = PropertyGrid_ChangedRow$(GridID)
    SELECT CASE Key$
        CASE "name": Signal = 1: DataType = DT_Text
        CASE "caption": Signal = 2: DataType = DT_Text
        CASE "text": Signal = 3: DataType = DT_Text
        CASE "top": Signal = 4: DataType = DT_Integer
        CASE "left": Signal = 5: DataType = DT_Integer
        CASE "width": Signal = 6: DataType = DT_Integer
        CASE "height": Signal = 7: DataType = DT_Integer
        CASE "font": Signal = 8: DataType = DT_Text
        CASE "tooltip": Signal = 9: DataType = DT_Text
        CASE "value": Signal = 10: DataType = DT_Float
        CASE "min": Signal = 11: DataType = DT_Float
        CASE "max": Signal = 12: DataType = DT_Float
        CASE "interval": Signal = 13: DataType = DT_Float
        CASE "padding": Signal = 31: DataType = DT_Integer
        CASE "mask": Signal = 35: DataType = DT_Text
        CASE "mininterval": Signal = 36: DataType = DT_Float
        CASE "bordersize": Signal = 40: DataType = DT_Integer
        CASE ELSE: EXIT SUB
    END SELECT

    NewValue$ = PropertyGrid_Value$(GridID, Key$)
    SELECT CASE DataType
        CASE DT_Text
            b$ = MKL$(LEN(NewValue$)) + NewValue$
        CASE DT_Integer
            b$ = MKI$(VAL(NewValue$))
        CASE DT_Float
            b$ = _MK$(_FLOAT, VAL(NewValue$))
    END SELECT
    SendData b$, Signal
    PropertySent = True

    'Character codes typed as \65; become the characters themselves, the way the preview stores them
    id = PropertyGrid_Control(GridID, Key$)
    Text(id) = RestoreCHR(Text(id))
    Caption(StatusBar) = "Ready."
END SUB

SUB __UI_TextChanged (id AS LONG)
    SELECT CASE id
        CASE RedValue, GreenValue, BlueValue
            DIM TempID AS LONG
            TempID = __UI_GetID(LEFT$(UCASE$(RTRIM$(Control(id).Name)), LEN(UCASE$(RTRIM$(Control(id).Name))) - 5))
            Control(TempID).Value = VAL(Text(id))

    END SELECT
END SUB

SUB __UI_ValueChanged (id AS LONG)
    IF __UI_StateHasChanged THEN EXIT SUB 'skip values changed programmatically

    DIM b$, i AS LONG
    SELECT EVERYCASE id
        CASE ControlProperties, ControlToggles
            SendPropertyEdit id
        CASE RowsGrid
            'A cell was changed (column 0 means another cell became current)
            IF DataGrid_ChangedColumn(RowsGrid) = 2 THEN RowsKindChanged DataGrid_ChangedRow(RowsGrid)
            IF DataGrid_ChangedColumn(RowsGrid) > 0 THEN RowsChanged
        CASE AlignOptions
            IF __UI_Focus <> id THEN EXIT SUB
            b$ = MKI$(Control(AlignOptions).Value - 1)
            SendData b$, 22
            PropertySent = True
        CASE VAlignOptions
            IF __UI_Focus <> id THEN EXIT SUB
            b$ = MKI$(Control(VAlignOptions).Value - 1)
            SendData b$, 32
            PropertySent = True
        CASE BulletOptions
            IF __UI_Focus <> id THEN EXIT SUB
            b$ = MKI$(Control(BulletOptions).Value - 1)
            SendData b$, 37
            PropertySent = True
        CASE BooleanOptions
            b$ = _MK$(_FLOAT, -(Control(BooleanOptions).Value - 1))
            SendData b$, 10
            PropertySent = True
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
            PropertySent = True
        CASE Red
            Text(RedValue) = LTRIM$(STR$(Control(Red).Value))
        CASE Green
            Text(GreenValue) = LTRIM$(STR$(Control(Green).Value))
        CASE Blue
            Text(BlueValue) = LTRIM$(STR$(Control(Blue).Value))
        CASE ControlList
            'An item was dragged to a new position (the list is reorderable)
            IF __UI_MovedItemTo > 0 THEN
                ZOrderItemDropped __UI_MovedItemFrom, __UI_MovedItemTo
                EXIT SUB
            END IF

            'The user picked a control in the list: select it in the preview too
            ZOrderUpdateButtons
            IF Control(ControlList).Value > 0 THEN
                b$ = MKL$(zOrderIDs(Control(ControlList).Value))
            ELSE
                b$ = MKL$(0)
            END IF
            SendData b$, 213

        CASE NameTB, CaptionTB, TextTB, MaskTB, TopTB, LeftTB, WidthTB, HeightTB, FontTB, TooltipTB, ValueTB, MinTB, MaxTB, IntervalTB, PaddingTB, MinIntervalTB, SizeTB
            Send Client, "LOCKCONTROLS><END>"
    END SELECT
END SUB

'---------------------------------------------------------------------------------
'Editor icons
'
'The toolbox, menu and button icons are drawn in code with the colors of the
'editor's theme, so they suit both light and dark themes. Shapes are drawn with
'anti-aliased edges, in pixel coordinates (the pixel at 0,0 spans 0 to 1).
'Call DrawEditorIcons again after changing the editor's theme.

''' @brief Switches the editor's own theme ("light" or "dark") and redraws what depends on it.
SUB SetEditorTheme (themeName AS STRING)
    DIM blinking AS _BYTE, prevAutoRefresh AS _BYTE, i AS LONG

    'Pause the refresh timer so no frame is drawn halfway through the switch
    '(it would show a mix of both themes and could redirect the icon drawing)
    prevAutoRefresh = __UI_AutoRefresh
    __UI_AutoRefresh = False

    EditorTheme = LCASE$(themeName)
    blinking = (StatusBarBackColor <> 0 AND Control(StatusBar).BackColor <> StatusBarBackColor)
    IF LCASE$(GetTheme$) <> EditorTheme THEN SetTheme EditorTheme

    'The status bar is a shade darker than the form
    StatusBarBackColor = Darken(__UI_DefaultColor(__UI_Type_Form, 2), 90)
    IF NOT blinking THEN Control(StatusBar).BackColor = StatusBarBackColor

    DrawEditorIcons
    Control(OptionsMenuEditorThemeLight).Value = (EditorTheme = "light")
    Control(OptionsMenuEditorThemeDark).Value = (EditorTheme = "dark")

    'Repaint everything in the new theme on the next frame
    FOR i = 1 TO UBOUND(Control)
        IF Control(i).ID > 0 THEN Control(i).Redraw = True
    NEXT
    __UI_ForceRedraw = True
    __UI_AutoRefresh = prevAutoRefresh
END SUB

SUB DrawEditorIcons
    DIM prevDest AS LONG, i AS LONG, x AS SINGLE, ink AS _UNSIGNED LONG
    DIM fg AS _UNSIGNED LONG, soft AS _UNSIGNED LONG, acc AS _UNSIGNED LONG
    DIM accText AS _UNSIGNED LONG, paper AS _UNSIGNED LONG

    prevDest = _DEST
    fg = __UI_ThemeColor(__UI_ThemeColor_ButtonText)
    soft = IconMix(fg, __UI_ThemeColor(__UI_ThemeColor_ButtonFace), .6)
    acc = __UI_ThemeColor(__UI_ThemeColor_Accent)
    accText = __UI_ThemeColor(__UI_ThemeColor_AccentText)
    paper = __UI_ThemeColor(__UI_ThemeColor_InputBack)

    'Button
    EditorIconCanvas AddButton, 16
    IconRoundRect 1, 3, 15, 13, 2, 0, acc
    IconLine 5, 8, 11, 8, 2, accText

    'Label
    EditorIconCanvas AddLabel, 16
    IconLine 3.2, 13.5, 8, 2.5, 1.7, fg
    IconLine 8, 2.5, 12.8, 13.5, 1.7, fg
    IconLine 5.4, 9.8, 10.6, 9.8, 1.4, fg

    'Text box: a field with a caret and an accent underline
    EditorIconCanvas AddTextBox, 16
    IconRoundRect 0, 3, 16, 13, 2, 0, paper
    IconRoundRect 0, 3, 16, 13, 2, 1, fg
    IconLine 4.5, 6, 4.5, 10, 1.2, acc
    IconLine 2.5, 12.5, 13.5, 12.5, 1, acc

    'Numeric text box: a field with up/down arrows
    EditorIconCanvas AddNumericBox, 16
    IconRoundRect 0, 3, 16, 13, 2, 0, paper
    IconRoundRect 0, 3, 16, 13, 2, 1, fg
    IconLine 4.5, 6, 4.5, 10, 1.2, acc
    IconTriangle 9.5, 7.4, 11.75, 5, 14, 7.4, fg
    IconTriangle 9.5, 8.6, 11.75, 11, 14, 8.6, fg

    'Check box
    EditorIconCanvas AddCheckBox, 16
    IconRoundRect 1, 1, 15, 15, 2.5, 0, acc
    IconLine 4.6, 8.3, 7, 10.7, 1.6, accText
    IconLine 7, 10.7, 11.6, 5.6, 1.6, accText

    'Radio button
    EditorIconCanvas AddRadioButton, 16
    IconCircle 8, 8, 6.6, 0, acc
    IconCircle 8, 8, 2.6, 0, accText

    'List box: a few items, one of them selected
    EditorIconCanvas AddListBox, 16
    IconRoundRect 0, 0, 16, 16, 2, 0, paper
    IconRoundRect 0, 0, 16, 16, 2, 1, fg
    IconLine 4, 3.5, 11, 3.5, 1, soft
    IconRoundRect 2, 6, 14, 10, 1, 0, acc
    IconLine 4, 8, 10, 8, 2, accText
    IconLine 4, 12.5, 9, 12.5, 1, soft

    'Dropdown list
    EditorIconCanvas AddDropdownList, 16
    IconRoundRect 0, 3, 16, 13, 2, 0, paper
    IconRoundRect 0, 3, 16, 13, 2, 1, fg
    IconLine 3.5, 8, 7, 8, 2, soft
    IconLine 9.5, 6.75, 11.5, 8.75, 1.4, fg
    IconLine 11.5, 8.75, 13.5, 6.75, 1.4, fg

    'Track bar
    EditorIconCanvas AddTrackBar, 16
    IconLine 2, 8, 14, 8, 2, soft
    IconLine 2, 8, 7, 8, 2, acc
    IconCircle 7, 8, 3.8, 0, acc
    IconCircle 7, 8, 1.6, 0, paper

    'Progress bar
    EditorIconCanvas AddProgressBar, 16
    IconRoundRect 0, 4, 16, 12, 2, 1, fg
    IconRoundRect 2, 6, 10, 10, 1, 0, acc

    'Picture box: a framed landscape
    EditorIconCanvas AddPictureBox, 16
    IconRoundRect 0, 2, 16, 14, 2, 1, fg
    IconTriangle 6.5, 13, 10.5, 8.5, 14.5, 13, soft
    IconTriangle 1.5, 13, 6, 7, 10.5, 13, acc
    IconCircle 11.5, 6, 1.6, 0, acc

    'Frame: a box with a caption on its top edge
    EditorIconCanvas AddFrame, 16
    IconLine 1.5, 4.5, 2.5, 4.5, 1, fg
    IconLine 12.5, 4.5, 14.5, 4.5, 1, fg
    IconLine 1.5, 4.5, 1.5, 14.5, 1, fg
    IconLine 14.5, 4.5, 14.5, 14.5, 1, fg
    IconLine 1.5, 14.5, 14.5, 14.5, 1, fg
    IconLine 4.5, 4.5, 10.5, 4.5, 1.6, acc

    'Toggle switch
    EditorIconCanvas AddToggleSwitch, 16
    IconRoundRect 0, 4, 16, 12, 4, 0, acc
    IconCircle 11.5, 8, 2.3, 0, accText

    'Tab control: the selected tab and the page below it
    EditorIconCanvas AddTabControl, 16
    IconRoundRect 0, 5, 16, 16, 1.5, 1, fg
    IconRoundRect 1, 1, 8, 6, 1, 0, acc
    IconLine 9.5, 2.5, 13.5, 2.5, 1, soft
    IconLine 9.5, 2.5, 9.5, 5, 1, soft
    IconLine 13.5, 2.5, 13.5, 5, 1, soft

    'Property grid: label | value rows, one of them a box being edited
    EditorIconCanvas AddPropertyGrid, 16
    IconRoundRect 0.5, 1.5, 15.5, 14.5, 1.5, 1, fg
    IconLine 2.5, 5, 6, 5, 1.4, soft
    IconRoundRect 8, 3, 14, 7, 1, 0, acc
    IconLine 2.5, 11, 6, 11, 1.4, soft
    IconRoundRect 8, 9, 14, 13, 1, 1, fg

    'Data grid: a table with a header row and a current cell
    EditorIconCanvas AddDataGrid, 16
    IconRoundRect 0, 1, 16, 15, 1.5, 0, paper
    IconRoundRect 0.5, 1.5, 15.5, 5.5, 1, 0, soft
    IconRoundRect 6, 6, 11, 10, 0, 0, acc
    IconRoundRect 0.5, 1.5, 15.5, 14.5, 1.5, 1, fg
    IconLine 0.5, 10, 15.5, 10, 1, fg
    IconLine 5.5, 1.5, 5.5, 14.5, 1, fg
    IconLine 10.5, 1.5, 10.5, 14.5, 1, fg

    'Paste list button: lines of text
    EditorIconCanvas PasteListBT, 17
    FOR i = 0 TO 2
        IconLine 4, 4 + i * 4, 13 - i * 2, 4 + i * 4, 2, fg
    NEXT

    'Save menu item (a floppy disk) in normal, hovered and disabled states
    EditorIconCanvas FileMenuSave, 48
    FOR i = 0 TO 2
        SELECT CASE i
            CASE 0: ink = __UI_DefaultColor(__UI_Type_MenuItem, 1)
            CASE 1: ink = __UI_DefaultColor(__UI_Type_MenuItem, 3)
            CASE 2: ink = __UI_DisabledColor
        END SELECT
        x = i * 16
        IconRoundRect x + 1, 1, x + 15, 15, 1.5, 1, ink
        IconRoundRect x + 4, 1, x + 11, 6, .5, 0, ink
        IconRoundRect x + 4, 9, x + 12, 15, .5, 1, ink
    NEXT

    'The Align menu shares its icons with the preview's context menu
    Control(AlignMenuAlignLeft).HelperCanvas = Control(__UI_GetID("__UI_PreviewMenuAlignLeft")).HelperCanvas
    Control(AlignMenuAlignRight).HelperCanvas = Control(__UI_GetID("__UI_PreviewMenuAlignRight")).HelperCanvas
    Control(AlignMenuAlignTops).HelperCanvas = Control(__UI_GetID("__UI_PreviewMenuAlignTops")).HelperCanvas
    Control(AlignMenuAlignBottoms).HelperCanvas = Control(__UI_GetID("__UI_PreviewMenuAlignBottoms")).HelperCanvas
    Control(AlignMenuAlignCentersV).HelperCanvas = Control(__UI_GetID("__UI_PreviewMenuAlignCentersV")).HelperCanvas
    Control(AlignMenuAlignCentersH).HelperCanvas = Control(__UI_GetID("__UI_PreviewMenuAlignCentersH")).HelperCanvas

    _DEST prevDest
END SUB

'Makes Control(id).HelperCanvas a clear Wide x 16 image (17 x 17 for 17) and
'sets it as the drawing destination
SUB EditorIconCanvas (id AS LONG, Wide AS INTEGER)
    DIM h AS INTEGER
    h = 16: IF Wide = 17 THEN h = 17
    IF Control(id).HelperCanvas < -1 THEN
        IF _WIDTH(Control(id).HelperCanvas) <> Wide OR _HEIGHT(Control(id).HelperCanvas) <> h THEN
            _FREEIMAGE Control(id).HelperCanvas
            Control(id).HelperCanvas = 0
        END IF
    END IF
    IF Control(id).HelperCanvas >= -1 THEN Control(id).HelperCanvas = _NEWIMAGE(Wide, h, 32)
    _DEST Control(id).HelperCanvas
    CLS , _RGBA32(0, 0, 0, 0)
    Control(id).Redraw = True
END SUB

FUNCTION IconMix~& (c1 AS _UNSIGNED LONG, c2 AS _UNSIGNED LONG, t AS SINGLE)
    'Blends c1 into c2: t = 1 gives c1, t = 0 gives c2
    IconMix = _RGB32(_RED32(c1) * t + _RED32(c2) * (1 - t), _GREEN32(c1) * t + _GREEN32(c2) * (1 - t), _BLUE32(c1) * t + _BLUE32(c2) * (1 - t))
END FUNCTION

'Plots a pixel whose share covered by a shape is Coverage (0 to 1)
SUB IconPlot (x AS INTEGER, y AS INTEGER, Coverage AS SINGLE, c AS _UNSIGNED LONG)
    IF Coverage <= 0 THEN EXIT SUB
    IF x < 0 OR y < 0 OR x >= _WIDTH OR y >= _HEIGHT THEN EXIT SUB
    PSET (x, y), _RGBA32(_RED32(c), _GREEN32(c), _BLUE32(c), _ALPHA32(c) * Coverage)
END SUB

'Signed distance from (px, py) to a rounded rectangle (negative inside)
FUNCTION IconRoundRectDist! (px AS SINGLE, py AS SINGLE, x1 AS SINGLE, y1 AS SINGLE, x2 AS SINGLE, y2 AS SINGLE, Radius AS SINGLE)
    DIM qx AS SINGLE, qy AS SINGLE, ox AS SINGLE, oy AS SINGLE, inside AS SINGLE
    qx = ABS(px - (x1 + x2) / 2) - ((x2 - x1) / 2 - Radius)
    qy = ABS(py - (y1 + y2) / 2) - ((y2 - y1) / 2 - Radius)
    IF qx > 0 THEN ox = qx
    IF qy > 0 THEN oy = qy
    inside = qx: IF qy > inside THEN inside = qy
    IF inside > 0 THEN inside = 0
    IconRoundRectDist = SQR(ox * ox + oy * oy) + inside - Radius
END FUNCTION

'Rounded rectangle from (x1, y1) to (x2, y2): filled if Thickness is 0,
'otherwise just its outline, drawn inside the edges
SUB IconRoundRect (x1 AS SINGLE, y1 AS SINGLE, x2 AS SINGLE, y2 AS SINGLE, Radius AS SINGLE, Thickness AS SINGLE, c AS _UNSIGNED LONG)
    DIM x AS INTEGER, y AS INTEGER, sx AS INTEGER, sy AS INTEGER, hits AS INTEGER, d AS SINGLE
    FOR y = INT(y1) TO INT(y2)
        FOR x = INT(x1) TO INT(x2)
            hits = 0
            FOR sy = 0 TO 3
                FOR sx = 0 TO 3
                    d = IconRoundRectDist(x + (sx + .5) / 4, y + (sy + .5) / 4, x1, y1, x2, y2, Radius)
                    IF d <= 0 AND (Thickness = 0 OR d > -Thickness) THEN hits = hits + 1
                NEXT
            NEXT
            IconPlot x, y, hits / 16, c
        NEXT
    NEXT
END SUB

'Circle centered at (cx, cy): filled if Thickness is 0, otherwise a ring
SUB IconCircle (cx AS SINGLE, cy AS SINGLE, Radius AS SINGLE, Thickness AS SINGLE, c AS _UNSIGNED LONG)
    IconRoundRect cx - Radius, cy - Radius, cx + Radius, cy + Radius, Radius, Thickness, c
END SUB

'Line from (x1, y1) to (x2, y2) with rounded ends
SUB IconLine (x1 AS SINGLE, y1 AS SINGLE, x2 AS SINGLE, y2 AS SINGLE, Thickness AS SINGLE, c AS _UNSIGNED LONG)
    DIM x AS INTEGER, y AS INTEGER, sx AS INTEGER, sy AS INTEGER, hits AS INTEGER
    DIM px AS SINGLE, py AS SINGLE, dx AS SINGLE, dy AS SINGLE, t AS SINGLE, l2 AS SINGLE, r AS SINGLE
    DIM xa AS INTEGER, xb AS INTEGER, ya AS INTEGER, yb AS INTEGER

    r = Thickness / 2
    dx = x2 - x1: dy = y2 - y1
    l2 = dx * dx + dy * dy
    xa = INT(_MIN(x1, x2) - r): xb = INT(_MAX(x1, x2) + r)
    ya = INT(_MIN(y1, y2) - r): yb = INT(_MAX(y1, y2) + r)
    FOR y = ya TO yb
        FOR x = xa TO xb
            hits = 0
            FOR sy = 0 TO 3
                FOR sx = 0 TO 3
                    px = x + (sx + .5) / 4: py = y + (sy + .5) / 4
                    t = 0
                    IF l2 > 0 THEN t = ((px - x1) * dx + (py - y1) * dy) / l2
                    IF t < 0 THEN t = 0
                    IF t > 1 THEN t = 1
                    px = px - (x1 + t * dx): py = py - (y1 + t * dy)
                    IF px * px + py * py <= r * r THEN hits = hits + 1
                NEXT
            NEXT
            IconPlot x, y, hits / 16, c
        NEXT
    NEXT
END SUB

'Filled triangle
SUB IconTriangle (ax AS SINGLE, ay AS SINGLE, bx AS SINGLE, by AS SINGLE, cx AS SINGLE, cy AS SINGLE, c AS _UNSIGNED LONG)
    DIM x AS INTEGER, y AS INTEGER, sx AS INTEGER, sy AS INTEGER, hits AS INTEGER
    DIM px AS SINGLE, py AS SINGLE, d1 AS SINGLE, d2 AS SINGLE, d3 AS SINGLE
    FOR y = INT(_MIN(ay, _MIN(by, cy))) TO INT(_MAX(ay, _MAX(by, cy)))
        FOR x = INT(_MIN(ax, _MIN(bx, cx))) TO INT(_MAX(ax, _MAX(bx, cx)))
            hits = 0
            FOR sy = 0 TO 3
                FOR sx = 0 TO 3
                    px = x + (sx + .5) / 4: py = y + (sy + .5) / 4
                    d1 = (px - bx) * (ay - by) - (ax - bx) * (py - by)
                    d2 = (px - cx) * (by - cy) - (bx - cx) * (py - cy)
                    d3 = (px - ax) * (cy - ay) - (cx - ax) * (py - ay)
                    IF NOT ((d1 < 0 OR d2 < 0 OR d3 < 0) AND (d1 > 0 OR d2 > 0 OR d3 > 0)) THEN hits = hits + 1
                NEXT
            NEXT
            IconPlot x, y, hits / 16, c
        NEXT
    NEXT
END SUB

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


    FormData$ = LastFormData$

    AddGifExtension = False
    TotalGifLoaded = 0
    IF LoadedWithGifExtension = 1 THEN PrevTotalGifLoaded = 0

    b$ = ReadSequential$(FormData$, 4)

    REDIM PreviewCaptions(0 TO CVL(b$)) AS STRING
    REDIM PreviewTexts(0 TO CVL(b$)) AS STRING
    REDIM PreviewMasks(0 TO CVL(b$)) AS STRING
    REDIM PreviewTips(0 TO CVL(b$)) AS STRING
    REDIM PreviewFonts(0 TO CVL(b$)) AS STRING
    REDIM PreviewActualFonts(0 TO CVL(b$)) AS STRING
    PreviewTheme = "" 'sent again by the preview (-50) when the form uses a theme
    UpdateThemeMenu
    REDIM PreviewControls(0 TO CVL(b$)) AS __UI_ControlTYPE
    REDIM PreviewParentIDS(0 TO CVL(b$)) AS STRING
    REDIM PreviewContextMenu(0 TO CVL(b$)) AS STRING
    REDIM PreviewBindings(0 TO CVL(b$)) AS STRING
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
                    PreviewControls(Dummy).Stretch = True
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
                    PreviewControls(Dummy).HasBorder = True
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
                    PreviewControls(Dummy).WordWrap = True
                CASE -29
                    PreviewControls(Dummy).CanResize = True
                CASE -31
                    b$ = ReadSequential$(FormData$, 2)
                    PreviewControls(Dummy).Padding = CVI(b$)
                CASE -32
                    b$ = ReadSequential$(FormData$, 1)
                    PreviewControls(Dummy).VAlign = _CV(_BYTE, b$)
                CASE -33
                    PreviewControls(Dummy).PasswordField = True
                CASE -51
                    PreviewControls(Dummy).Multiline = True
                CASE -52
                    PreviewControls(Dummy).Searchable = True
                CASE -53
                    PreviewControls(Dummy).Fuzzy = True
                CASE -54
                    PreviewControls(Dummy).Reorderable = True
                CASE -55
                    b$ = ReadSequential$(FormData$, 2)
                    PreviewControls(Dummy).Anchor = CVI(b$)
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
                    PreviewControls(Dummy).NumericOnly = True
                CASE -39
                    PreviewControls(Dummy).NumericOnly = __UI_NumericWithBounds
                CASE -40
                    PreviewControls(Dummy).BulletStyle = __UI_Bullet
                CASE -41
                    PreviewControls(Dummy).AutoScroll = True
                CASE -42
                    PreviewControls(Dummy).AutoSize = True
                CASE -43
                    b$ = ReadSequential$(FormData$, 2)
                    PreviewControls(Dummy).BorderSize = CVI(b$)
                CASE -44 'Key combo
                    b$ = ReadSequential$(FormData$, 2)
                    b$ = ReadSequential$(FormData$, CVI(b$))
                    PreviewKeyCombos(Dummy) = b$
                CASE -45 'Animated Gif
                    PreviewAnimatedGif(Dummy) = True
                    TotalGifLoaded = TotalGifLoaded + 1
                    AddGifExtension = True
                    IF LoadedWithGifExtension = 1 THEN
                        LoadedWithGifExtension = True
                        Control(AddGifExtensionToggle).Value = True
                    END IF
                CASE -46 'Auto-play Gif
                    PreviewAutoPlayGif(Dummy) = True
                CASE -47 'ControlIsSelected
                    PreviewControls(Dummy).ControlIsSelected = True
                CASE -49 'TabPage
                    b$ = ReadSequential$(FormData$, 2)
                    PreviewControls(Dummy).TabPage = CVI(b$)
                CASE -50 'Theme (form only)
                    b$ = ReadSequential$(FormData$, 2)
                    PreviewTheme = ReadSequential$(FormData$, CVI(b$))
                    UpdateThemeMenu
                CASE -48 'Binding: other control's name + this control's property
                    b$ = ReadSequential$(FormData$, 2)
                    b$ = ReadSequential$(FormData$, CVI(b$))
                    PreviewBindings(Dummy) = PreviewBindings(Dummy) + MKI$(LEN(b$)) + b$
                    b$ = ReadSequential$(FormData$, 2)
                    b$ = ReadSequential$(FormData$, CVI(b$))
                    PreviewBindings(Dummy) = PreviewBindings(Dummy) + MKI$(LEN(b$)) + b$
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
    IF LoadedWithGifExtension = 1 THEN LoadedWithGifExtension = False
    IF PrevTotalGifLoaded <> TotalGifLoaded THEN
        IF PrevTotalGifLoaded = 0 AND LoadedWithGifExtension = False THEN
            __UI_Delay COMMDLG_DELAY: Answer = _MESSAGEBOX(UiEditorTitle$, "You loaded an animated GIF file.\nDo you want to include the GIF extension?", "yesno", "question", 1)
            IF Answer = 1 THEN
                Control(AddGifExtensionToggle).Value = True
            ELSE
                b$ = "PAUSEALLGIF>" + "<END>"
                Send Client, b$
                Control(AddGifExtensionToggle).Value = False
            END IF
        END IF
        PrevTotalGifLoaded = TotalGifLoaded
    END IF
END SUB

'---------------------------------------------------------------------------------
'Property grid rows dialog: a frame's Text holds rows (key|kind|label|items, one per line), edited here in a table.
'The same dialog edits a data grid's columns and rows (see InFormDataGrid.bm for how its Text holds them).
'---------------------------------------------------------------------------------

''' @brief The word a property grid row kind is written as.
FUNCTION RowKindName$ (Kind AS _BYTE)
    SELECT CASE Kind
        CASE __UI_PropertyGrid_Integer: RowKindName$ = "integer"
        CASE __UI_PropertyGrid_Float: RowKindName$ = "float"
        CASE __UI_PropertyGrid_Choice: RowKindName$ = "choice"
        CASE __UI_PropertyGrid_Toggle: RowKindName$ = "toggle"
        CASE __UI_PropertyGrid_Button: RowKindName$ = "button"
        CASE ELSE: RowKindName$ = "text"
    END SELECT
END FUNCTION

''' @brief Opens the dialog on the selected frame: a data grid's rows (its columns, when it has none yet),
''' or a property grid's rows.
SUB OpenRowsDialog
    DIM GridColumns$, GridRows$
    IF FirstSelected = 0 OR TotalSelected <> 1 THEN EXIT SUB
    IF IsDataGridFrame(FirstSelected) THEN
        __UI_DGSplitDefinition PreviewTexts(FirstSelected), GridColumns$, GridRows$
        IF LEN(GridColumns$) = 0 THEN OpenRowsDialogFor RowsModeColumns ELSE OpenRowsDialogFor RowsModeGridRows
    ELSE
        OpenRowsDialogFor RowsModeProperties
    END IF
END SUB

''' @brief Sets up the table's columns for what it holds (see RowsMode).
SUB SetRowsGridColumns
    DIM c AS LONG, Caption$, Kind AS _BYTE, ColumnWidth AS INTEGER, Items$

    DataGrid_Clear RowsGrid
    FOR c = DataGrid_ColumnCount(RowsGrid) TO 1 STEP -1
        DataGrid_RemoveColumn RowsGrid, c
    NEXT
    SELECT CASE RowsMode
        CASE RowsModeProperties
            DataGrid_AddTextColumn RowsGrid, "Key", 110
            DataGrid_AddChoiceColumn RowsGrid, "Kind", 80, "text|integer|float|choice|toggle|button"
            DataGrid_AddTextColumn RowsGrid, "Label", 140
            DataGrid_AddTextColumn RowsGrid, "Items / value", 0
        CASE RowsModeColumns
            DataGrid_AddTextColumn RowsGrid, "Caption", 150
            DataGrid_AddChoiceColumn RowsGrid, "Kind", 80, "text|integer|float|choice|toggle"
            DataGrid_AddIntegerColumn RowsGrid, "Width", 70
            DataGrid_AddTextColumn RowsGrid, "Items", 0
        CASE RowsModeGridRows
            'The data grid's own columns (RowsKeep$ holds them)
            FOR c = 1 TO __UI_DGPartCount(RowsKeep$, CHR$(10)) - 1
                __UI_DGParseColumn __UI_DGPart(RowsKeep$, c, CHR$(10)), Caption$, Kind, ColumnWidth, Items$
                Items$ = Replace$(Items$, ",", "|", False, 0)
                SELECT CASE Kind
                    CASE __UI_DataGrid_Integer: DataGrid_AddIntegerColumn RowsGrid, Caption$, ColumnWidth
                    CASE __UI_DataGrid_Float: DataGrid_AddFloatColumn RowsGrid, Caption$, ColumnWidth
                    CASE __UI_DataGrid_Choice: DataGrid_AddChoiceColumn RowsGrid, Caption$, ColumnWidth, Items$
                    CASE __UI_DataGrid_Toggle: DataGrid_AddToggleColumn RowsGrid, Caption$, ColumnWidth
                    CASE ELSE: DataGrid_AddTextColumn RowsGrid, Caption$, ColumnWidth
                END SELECT
            NEXT
    END SELECT
END SUB

''' @brief Fills the table with the selected frame's property grid rows, data grid columns or data grid rows
''' (Mode is one of the RowsMode constants) and shows the dialog.
SUB OpenRowsDialogFor (Mode AS _BYTE)
    DIM t$, l$, p AS LONG, k$, Kind AS _BYTE, Label$, Extra$, r AS LONG, i AS LONG
    DIM GridColumns$, GridRows$, ColumnWidth AS INTEGER, FrameName$

    IF FirstSelected = 0 OR TotalSelected <> 1 THEN EXIT SUB
    IF PreviewControls(FirstSelected).Type <> __UI_Type_Frame THEN EXIT SUB
    IF Mode <> RowsModeProperties AND NOT IsDataGridFrame(FirstSelected) THEN EXIT SUB

    RowsMode = Mode
    RowsKeep$ = ""
    IF Mode <> RowsModeProperties THEN
        __UI_DGSplitDefinition PreviewTexts(FirstSelected), GridColumns$, GridRows$
        IF Mode = RowsModeColumns THEN RowsKeep$ = GridRows$ ELSE RowsKeep$ = GridColumns$
    END IF
    SetRowsGridColumns

    SELECT CASE Mode
        CASE RowsModeProperties
            t$ = Replace(PreviewTexts(FirstSelected), "\n", CHR$(10), False, 0)
            t$ = Replace(t$, CHR$(13), "", False, 0) + CHR$(10)
            DO
                p = INSTR(t$, CHR$(10))
                IF p = 0 THEN EXIT DO
                l$ = LEFT$(t$, p - 1)
                t$ = MID$(t$, p + 1)
                IF __UI_PGParseLine(l$, k$, Kind, Label$, Extra$) THEN
                    r = DataGrid_AddRow(RowsGrid, "")
                    DataGrid_SetCell RowsGrid, r, 1, k$
                    DataGrid_SetCell RowsGrid, r, 2, RowKindName$(Kind)
                    DataGrid_SetCell RowsGrid, r, 3, Label$
                    DataGrid_SetCell RowsGrid, r, 4, Extra$
                    RowsValueKind r
                END IF
            LOOP
        CASE RowsModeColumns
            'Each line remembers which column it was, so the rows' cells can follow when columns move or go
            FOR i = 1 TO __UI_DGPartCount(GridColumns$, CHR$(10)) - 1
                __UI_DGParseColumn __UI_DGPart(GridColumns$, i, CHR$(10)), Label$, Kind, ColumnWidth, Extra$
                r = DataGrid_AddRow(RowsGrid, "")
                DataGrid_SetCell RowsGrid, r, 1, Label$
                DataGrid_SetCell RowsGrid, r, 2, __UI_DGKindName$(Kind)
                DataGrid_SetCell RowsGrid, r, 3, LTRIM$(STR$(ColumnWidth))
                DataGrid_SetCell RowsGrid, r, 4, Extra$
                DataGrid_SetRowTag RowsGrid, r, LTRIM$(STR$(i))
            NEXT
        CASE RowsModeGridRows
            FOR i = 1 TO __UI_DGPartCount(GridRows$, CHR$(10)) - 1
                r = DataGrid_AddRow(RowsGrid, __UI_DGPart(GridRows$, i, CHR$(10)))
            NEXT
    END SELECT
    IF DataGrid_RowCount(RowsGrid) > 0 THEN DataGrid_Select RowsGrid, 1, 1

    'Changes show in the preview as they're made; the frame's Text as it was is put back when the dialog closes
    FrameName$ = RTRIM$(__UI_TrimAt0$(PreviewControls(FirstSelected).Name))
    RowsFrameName$ = FrameName$
    RowsOriginal$ = PreviewTexts(FirstSelected)
    RowsShown$ = RowsOriginal$
    RowsHistoryCount = 1
    RowsHistoryPos = 1
    REDIM RowsHistory(1 TO 16) AS STRING
    RowsHistory(1) = RowsSnapshot$

    SELECT CASE Mode
        CASE RowsModeProperties
            Caption(EditRowsDialog) = "Property grid rows: " + FrameName$
            Caption(RowsDescriptionLB) = "Each line becomes a row of the frame's property grid, shown in the preview as you go. Click a cell twice, or press Enter or F2, to edit it. Shift or dragging selects rows; Ctrl+Z undoes."
            Caption(StatusBar) = "Editing property grid rows"
        CASE RowsModeColumns
            Caption(EditRowsDialog) = "Data grid columns: " + FrameName$
            Caption(RowsDescriptionLB) = "Each line becomes a column of the frame's data grid, shown in the preview as you go. Click a cell twice, or press Enter or F2, to edit it. Shift or dragging selects lines; Ctrl+Z undoes."
            Caption(StatusBar) = "Editing data grid columns"
        CASE RowsModeGridRows
            Caption(EditRowsDialog) = "Data grid rows: " + FrameName$
            Caption(RowsDescriptionLB) = "The rows the frame's data grid has when the program starts, shown in the preview as you go. Click a cell twice, or press Enter or F2, to edit it. Shift or dragging selects rows; Ctrl+Z undoes."
            Caption(StatusBar) = "Editing data grid rows"
    END SELECT
    Control(DialogBG).Left = 0: Control(DialogBG).Top = 0
    Control(EditRowsDialog).Left = 18: Control(EditRowsDialog).Top = 70
    Control(RowsGrid).Left = Control(EditRowsDialog).Left + 15
    Control(RowsGrid).Top = Control(EditRowsDialog).Top + 62
    RowsDialogOpen = True
    Send Client, "LOCKINPUT>" + MKI$(True) + "<END>" 'no editing in the preview while the dialog is open
    __UI_Focus = RowsGrid
    UpdateRowsDialog
    __UI_ForceRedraw = True
END SUB

''' @brief Hides the dialog without changing the frame.
SUB CloseRowsDialog
    IF NOT RowsDialogOpen THEN EXIT SUB
    RowsDialogOpen = False
    Send Client, "LOCKINPUT>" + MKI$(False) + "<END>"
    IF DataGrid_IsEditing(RowsGrid) THEN DataGrid_StopEditing RowsGrid
    IF RowsShown$ <> RowsOriginal$ THEN ShowRowsInPreview RowsOriginal$
    REDIM RowsHistory(0) AS STRING
    RowsHistoryCount = 0
    RowsHistoryPos = 0
    Control(DialogBG).Left = -600: Control(DialogBG).Top = -600
    Control(EditRowsDialog).Left = -600: Control(EditRowsDialog).Top = -600
    Control(RowsGrid).Left = -600: Control(RowsGrid).Top = -600
    __UI_Focus = 0
    Caption(StatusBar) = "Ready."
    __UI_ForceRedraw = True
END SUB

''' @brief Points at a cell the table can't keep as it is, and says why.
SUB RowsRefuse (r AS LONG, c AS LONG, Message$)
    DataGrid_Select RowsGrid, r, c
    __UI_Focus = RowsGrid
    MessageBox Message$, UiEditorTitle$, MsgBox_Exclamation
END SUB

''' @brief Writes the table back to the frame's Text (an edit that can be undone) and closes the dialog.
SUB ApplyRowsDialog
    DIM r AS LONG, c AS LONG, k$, Label$, t$, Keys$

    DataGrid_StopEditing RowsGrid
    SELECT CASE RowsMode
        CASE RowsModeProperties
            Keys$ = CHR$(10)
            FOR r = 1 TO DataGrid_RowCount(RowsGrid)
                k$ = _TRIM$(DataGrid_Cell(RowsGrid, r, 1))
                Label$ = _TRIM$(DataGrid_Cell(RowsGrid, r, 3))
                IF LEN(k$) = 0 AND LEN(Label$) = 0 THEN _CONTINUE 'blank rows are left out
                IF LEN(k$) = 0 THEN k$ = Label$

                IF INSTR(k$, "|") > 0 OR INSTR(Label$, "|") > 0 THEN
                    IF INSTR(k$, "|") > 0 THEN c = 1 ELSE c = 3
                    RowsRefuse r, c, "Keys and labels can't contain |."
                    EXIT SUB
                END IF
                IF INSTR(Keys$, CHR$(10) + LCASE$(k$) + CHR$(10)) THEN
                    RowsRefuse r, 1, "More than one row has the key '" + k$ + "'. Each row needs its own key."
                    EXIT SUB
                END IF
                Keys$ = Keys$ + LCASE$(k$) + CHR$(10)
            NEXT
        CASE RowsModeColumns
            FOR r = 1 TO DataGrid_RowCount(RowsGrid)
                IF INSTR(DataGrid_Cell(RowsGrid, r, 1), "|") THEN RowsRefuse r, 1, "Captions can't contain |.": EXIT SUB
                IF INSTR(DataGrid_Cell(RowsGrid, r, 4), "|") THEN RowsRefuse r, 4, "Separate a choice's items with commas: they can't contain |.": EXIT SUB
            NEXT
        CASE RowsModeGridRows
            FOR r = 1 TO DataGrid_RowCount(RowsGrid)
                FOR c = 1 TO DataGrid_ColumnCount(RowsGrid)
                    IF INSTR(DataGrid_Cell(RowsGrid, r, c), "|") THEN
                        RowsRefuse r, c, "Cells written here can't contain |. Your code can put it in a cell with DataGrid_SetCell."
                        EXIT SUB
                    END IF
                NEXT
            NEXT
    END SELECT

    'The preview gets the frame's Text back as it was, then the new one as a property: one step to undo
    t$ = RowsTableText$
    CloseRowsDialog
    IF t$ <> RowsOriginal$ THEN
        SendData MKL$(LEN(t$)) + t$, 3
        PropertySent = True
    END IF
END SUB

''' @brief What the frame's Text becomes with the table as it is: property grid rows (key|kind|label|items, one per
''' line, blank rows left out), or a data grid's definition with the table as its columns or rows.
FUNCTION RowsTableText$
    DIM r AS LONG, c AS LONG, i AS LONG, k$, Kind$, Label$, Extra$, t$, Row$, OldRow$, Tag AS LONG

    SELECT CASE RowsMode
        CASE RowsModeProperties
            FOR r = 1 TO DataGrid_RowCount(RowsGrid)
                k$ = _TRIM$(DataGrid_Cell(RowsGrid, r, 1))
                Kind$ = _TRIM$(DataGrid_Cell(RowsGrid, r, 2))
                Label$ = _TRIM$(DataGrid_Cell(RowsGrid, r, 3))
                Extra$ = _TRIM$(DataGrid_Cell(RowsGrid, r, 4))
                IF LEN(k$) = 0 AND LEN(Label$) = 0 THEN _CONTINUE
                IF LEN(k$) = 0 THEN k$ = Label$
                Row$ = k$ + "|" + Kind$ + "|" + Label$
                IF LEN(Extra$) THEN Row$ = Row$ + "|" + Extra$
                IF LEN(t$) THEN t$ = t$ + CHR$(10)
                t$ = t$ + Row$
            NEXT

        CASE RowsModeColumns
            t$ = "#columns" + CHR$(10)
            FOR r = 1 TO DataGrid_RowCount(RowsGrid)
                Row$ = _TRIM$(DataGrid_Cell(RowsGrid, r, 1)) + "|" + _TRIM$(DataGrid_Cell(RowsGrid, r, 2)) + "|" + LTRIM$(STR$(_MAX(0, VAL(DataGrid_Cell(RowsGrid, r, 3)))))
                Extra$ = _TRIM$(DataGrid_Cell(RowsGrid, r, 4))
                IF LEN(Extra$) THEN Row$ = Row$ + "|" + Extra$
                t$ = t$ + Row$ + CHR$(10)
            NEXT
            t$ = t$ + "#rows"
            'Each row's cells follow their columns; a new column's cells are left out (they get its default)
            FOR i = 1 TO __UI_DGPartCount(RowsKeep$, CHR$(10)) - 1
                OldRow$ = __UI_DGPart(RowsKeep$, i, CHR$(10))
                Row$ = ""
                FOR r = 1 TO DataGrid_RowCount(RowsGrid)
                    IF r > 1 THEN Row$ = Row$ + "|"
                    Tag = VAL(DataGrid_RowTag(RowsGrid, r))
                    IF Tag > 0 THEN Row$ = Row$ + __UI_DGPart(OldRow$, Tag, "|")
                NEXT
                DO WHILE RIGHT$(Row$, 1) = "|"
                    Row$ = LEFT$(Row$, LEN(Row$) - 1)
                LOOP
                t$ = t$ + CHR$(10) + Row$
            NEXT

        CASE RowsModeGridRows
            t$ = "#columns" + CHR$(10) + RowsKeep$ + "#rows"
            FOR r = 1 TO DataGrid_RowCount(RowsGrid)
                Row$ = ""
                FOR c = 1 TO DataGrid_ColumnCount(RowsGrid)
                    IF c > 1 THEN Row$ = Row$ + "|"
                    Row$ = Row$ + DataGrid_Cell(RowsGrid, r, c)
                NEXT
                t$ = t$ + CHR$(10) + Row$
            NEXT
    END SELECT
    RowsTableText$ = t$
END FUNCTION

''' @brief Shows the frame's Text as the table makes it, without an undo step (see ApplyRowsDialog).
SUB ShowRowsInPreview (t$)
    Send Client, "ROWSPREVIEW>" + MKL$(LEN(RowsFrameName$)) + RowsFrameName$ + t$ + "<END>"
    RowsShown$ = t$
END SUB

''' @brief The table's cells and row tags, and the current cell, to go back to with undo.
FUNCTION RowsSnapshot$
    DIM r AS LONG, c AS LONG, s$
    s$ = MKL$(DataGrid_Row(RowsGrid)) + MKL$(DataGrid_Column(RowsGrid))
    FOR r = 1 TO DataGrid_RowCount(RowsGrid)
        FOR c = 1 TO DataGrid_ColumnCount(RowsGrid)
            s$ = s$ + DataGrid_Cell(RowsGrid, r, c) + CHR$(1)
        NEXT
        s$ = s$ + DataGrid_RowTag(RowsGrid, r) + CHR$(1) + CHR$(2)
    NEXT
    RowsSnapshot$ = s$
END FUNCTION

''' @brief Property grid rows: makes a row's last cell a check box for a toggle and a number for an integer or float
''' (text otherwise).
SUB RowsValueKind (r AS LONG)
    IF RowsMode <> RowsModeProperties THEN EXIT SUB
    SELECT CASE _TRIM$(DataGrid_Cell(RowsGrid, r, 2))
        CASE "toggle": DataGrid_SetCellKind RowsGrid, r, 4, __UI_DataGrid_Toggle
        CASE "integer": DataGrid_SetCellKind RowsGrid, r, 4, __UI_DataGrid_Integer
        CASE "float": DataGrid_SetCellKind RowsGrid, r, 4, __UI_DataGrid_Float
        CASE ELSE: DataGrid_SetCellKind RowsGrid, r, 4, 0
    END SELECT
END SUB

''' @brief What a row's last cell holds for a kind: a starting value, a choice's items or a button's caption.
FUNCTION RowsExtraMeaning$ (Kind$)
    SELECT CASE Kind$
        CASE "choice", "button": RowsExtraMeaning$ = Kind$
        CASE ELSE: RowsExtraMeaning$ = "value"
    END SELECT
END FUNCTION

''' @brief A row's kind was changed in the table: its last cell changes kind with it, and its value is kept
''' only if it means the same thing for the new kind (e.g. a choice's items aren't a toggle's value).
''' For a data grid column, only a choice has items: a new choice gets some to start with.
SUB RowsKindChanged (r AS LONG)
    DIM s$, p AS LONG, i AS LONG, Row$, OldKind$, NewKind$, v$

    NewKind$ = _TRIM$(DataGrid_Cell(RowsGrid, r, 2))
    IF RowsMode = RowsModeColumns THEN
        IF NewKind$ = "choice" THEN
            IF LEN(_TRIM$(DataGrid_Cell(RowsGrid, r, 4))) = 0 THEN DataGrid_SetCell RowsGrid, r, 4, "Item 1,Item 2,Item 3"
        ELSE
            DataGrid_SetCell RowsGrid, r, 4, ""
        END IF
        EXIT SUB
    END IF
    IF RowsMode <> RowsModeProperties THEN EXIT SUB

    'The row's kind before the change, from the last snapshot kept for undo
    s$ = MID$(RowsHistory(RowsHistoryPos), 9)
    FOR i = 1 TO r
        p = INSTR(s$, CHR$(2))
        IF p = 0 THEN Row$ = "": EXIT FOR
        Row$ = LEFT$(s$, p - 1)
        s$ = MID$(s$, p + 1)
    NEXT
    p = INSTR(Row$, CHR$(1))
    IF p THEN OldKind$ = _TRIM$(MID$(Row$, p + 1, INSTR(p + 1, Row$, CHR$(1)) - p - 1))

    v$ = DataGrid_Cell(RowsGrid, r, 4)
    IF RowsExtraMeaning$(OldKind$) <> RowsExtraMeaning$(NewKind$) THEN v$ = ""
    IF LEN(_TRIM$(v$)) THEN
        SELECT CASE NewKind$
            CASE "toggle": IF VAL(v$) <> 0 THEN v$ = "-1" ELSE v$ = "0"
            CASE "integer": v$ = LTRIM$(STR$(_ROUND(VAL(v$))))
            CASE "float": v$ = LTRIM$(STR$(VAL(v$)))
        END SELECT
    END IF
    DataGrid_SetCell RowsGrid, r, 4, v$
    RowsValueKind r
END SUB

''' @brief Called after every change to the table: keeps it for undo and shows it in the preview.
SUB RowsChanged
    DIM s$
    IF NOT RowsDialogOpen THEN EXIT SUB
    s$ = RowsSnapshot$
    'Only the cells count: moving to another cell isn't a change
    IF MID$(s$, 9) <> MID$(RowsHistory(RowsHistoryPos), 9) THEN
        RowsHistoryPos = RowsHistoryPos + 1
        IF RowsHistoryPos > UBOUND(RowsHistory) THEN REDIM _PRESERVE RowsHistory(1 TO RowsHistoryPos + 15) AS STRING
        RowsHistoryCount = RowsHistoryPos 'what could be redone is gone
    END IF
    RowsHistory(RowsHistoryPos) = s$
    IF RowsTableText$ <> RowsShown$ THEN ShowRowsInPreview RowsTableText$
END SUB

''' @brief Goes back (-1) or forward (1) through the changes made to the table.
SUB RowsUndo (Direction AS LONG)
    DIM s$, p AS LONG, r AS LONG, c AS LONG, Cells$, Row$, CurRow AS LONG, CurCol AS LONG

    IF RowsHistoryPos + Direction < 1 OR RowsHistoryPos + Direction > RowsHistoryCount THEN EXIT SUB
    'An undone change takes its place in view (the current cell is kept with it)
    IF Direction < 0 THEN s$ = RowsHistory(RowsHistoryPos) ELSE s$ = RowsHistory(RowsHistoryPos + 1)
    CurRow = CVL(LEFT$(s$, 4)): CurCol = CVL(MID$(s$, 5, 4))
    RowsHistoryPos = RowsHistoryPos + Direction
    s$ = RowsHistory(RowsHistoryPos)

    DataGrid_Clear RowsGrid
    Cells$ = MID$(s$, 9)
    DO
        p = INSTR(Cells$, CHR$(2))
        IF p = 0 THEN EXIT DO
        Row$ = LEFT$(Cells$, p - 1)
        Cells$ = MID$(Cells$, p + 1)
        r = DataGrid_AddRow(RowsGrid, "")
        FOR c = 1 TO DataGrid_ColumnCount(RowsGrid)
            p = INSTR(Row$, CHR$(1))
            DataGrid_SetCell RowsGrid, r, c, LEFT$(Row$, p - 1)
            Row$ = MID$(Row$, p + 1)
        NEXT
        p = INSTR(Row$, CHR$(1))
        IF p THEN DataGrid_SetRowTag RowsGrid, r, LEFT$(Row$, p - 1)
        RowsValueKind r
    LOOP
    IF CurRow = 0 THEN CurRow = 1
    IF CurCol = 0 THEN CurCol = 1
    IF DataGrid_RowCount(RowsGrid) > 0 THEN DataGrid_Select RowsGrid, CurRow, CurCol

    IF RowsTableText$ <> RowsShown$ THEN ShowRowsInPreview RowsTableText$
    IF Direction < 0 THEN Caption(StatusBar) = "Undone." ELSE Caption(StatusBar) = "Redone."
END SUB

''' @brief Makes a row current, keeping the column.
SUB RowsGoTo (r AS LONG)
    DIM c AS LONG
    c = DataGrid_Column(RowsGrid)
    IF c = 0 THEN c = 1
    DataGrid_Select RowsGrid, r, c
    __UI_Focus = RowsGrid
END SUB

''' @brief Adds a line below the current one and starts editing its first cell: a text row with a key not used yet,
''' a text column with a caption not used yet, or a data grid row with its columns' defaults.
SUB RowsAdd
    DIM n AS LONG, r AS LONG, k$, Taken AS _BYTE, Base$, NewLine$

    SELECT CASE RowsMode
        CASE RowsModeProperties: Base$ = "text"
        CASE RowsModeColumns: Base$ = "Column "
    END SELECT
    IF LEN(Base$) THEN
        DO
            n = n + 1
            k$ = Base$ + LTRIM$(STR$(n))
            Taken = False
            FOR r = 1 TO DataGrid_RowCount(RowsGrid)
                IF LCASE$(_TRIM$(DataGrid_Cell(RowsGrid, r, 1))) = LCASE$(k$) THEN Taken = True: EXIT FOR
            NEXT
        LOOP WHILE Taken
    END IF
    SELECT CASE RowsMode
        CASE RowsModeProperties: NewLine$ = k$ + "|text|Text"
        CASE RowsModeColumns: NewLine$ = k$ + "|text|80"
    END SELECT

    r = DataGrid_InsertRow(RowsGrid, DataGrid_Row(RowsGrid) + 1, NewLine$)
    DataGrid_Select RowsGrid, r, 1
    RowsChanged
    __UI_Focus = RowsGrid
    'A check box or a list in the first cell isn't typed in
    SELECT CASE DataGrid_CellKind(RowsGrid, r, 1)
        CASE __UI_DataGrid_Text, __UI_DataGrid_Integer, __UI_DataGrid_Float: DataGrid_Edit RowsGrid
    END SELECT
END SUB

''' @brief Keeps the dialog's position, buttons and hint in step with the table.
SUB UpdateRowsDialog
    DIM r AS LONG, n AS LONG, First AS LONG, Last AS LONG, Noun$, Nouns$, c AS LONG, Caption$, Kind AS _BYTE
    DIM ColumnWidth AS INTEGER, Items$, Holds$

    r = DataGrid_Row(RowsGrid)
    n = DataGrid_RowCount(RowsGrid)
    First = DataGrid_SelectionFirst(RowsGrid)
    Last = DataGrid_SelectionLast(RowsGrid)
    IF RowsMode = RowsModeColumns THEN Noun$ = "Column": Nouns$ = "Columns" ELSE Noun$ = "Row": Nouns$ = "Rows"
    IF n = 0 THEN
        Caption(RowsPositionLB) = "No " + LCASE$(Nouns$)
    ELSEIF Last > First THEN
        Caption(RowsPositionLB) = Nouns$ + STR$(First) + "-" + LTRIM$(STR$(Last)) + " of" + STR$(n)
    ELSE
        Caption(RowsPositionLB) = Noun$ + STR$(r) + " of" + STR$(n)
    END IF
    Control(RowsFirstBT).Disabled = r <= 1
    Control(RowsPrevBT).Disabled = r <= 1
    Control(RowsNextBT).Disabled = r >= n
    Control(RowsLastBT).Disabled = r >= n
    Control(RowsDeleteBT).Disabled = r = 0
    Control(RowsUpBT).Disabled = First <= 1
    Control(RowsDownBT).Disabled = First = 0 OR Last >= n

    c = DataGrid_Column(RowsGrid)
    IF r = 0 THEN c = 0
    SELECT CASE RowsMode
        CASE RowsModeProperties
            SELECT CASE c
                CASE 1: Caption(RowsHintLB) = "Key: the name your code uses for the row, as in PropertyGrid_Value$(frame, " + CHR$(34) + "key" + CHR$(34) + "). Each row needs its own."
                CASE 2: Caption(RowsHintLB) = "Kind: a text, integer or float box, a choice (dropdown list), a toggle (check box) or a button. Space or a second click opens the list."
                CASE 3: Caption(RowsHintLB) = "Label: shown to the left of the row (a toggle's caption)."
                CASE 4
                    SELECT CASE _TRIM$(DataGrid_Cell(RowsGrid, r, 2))
                        CASE "choice": Caption(RowsHintLB) = "Items: the choice's items, separated by commas (Red,Green,Blue)."
                        CASE "button": Caption(RowsHintLB) = "Caption: the text on the button (the label when left empty)."
                        CASE "toggle": Caption(RowsHintLB) = "Value: whether the check box starts checked. A click or Space checks it."
                        CASE ELSE: Caption(RowsHintLB) = "Value: what the box starts with. Your code can change it with PropertyGrid_SetValue."
                    END SELECT
                CASE ELSE: Caption(RowsHintLB) = "Add a row to start."
            END SELECT
        CASE RowsModeColumns
            SELECT CASE c
                CASE 1: Caption(RowsHintLB) = "Caption: the column's header. Columns are numbered from 1 in this order, as in DataGrid_Cell$(frame, row, column)."
                CASE 2: Caption(RowsHintLB) = "Kind: text, integer or float cells, a choice (dropdown list) or a toggle (check box). Space or a second click opens the list."
                CASE 3: Caption(RowsHintLB) = "Width: in pixels. 0 shares the room the other columns leave. Columns that don't fit scroll sideways."
                CASE 4: Caption(RowsHintLB) = "Items: a choice column's items, separated by commas (Red,Green,Blue)."
                CASE ELSE: Caption(RowsHintLB) = "Add a column to start."
            END SELECT
        CASE RowsModeGridRows
            IF c = 0 THEN
                Caption(RowsHintLB) = "Add a row to start. Your code can also add rows with DataGrid_AddRow."
            ELSE
                __UI_DGParseColumn __UI_DGPart(RowsKeep$, c, CHR$(10)), Caption$, Kind, ColumnWidth, Items$
                SELECT CASE Kind
                    CASE __UI_DataGrid_Integer: Holds$ = "a whole number"
                    CASE __UI_DataGrid_Float: Holds$ = "a number"
                    CASE __UI_DataGrid_Choice: Holds$ = "one of its items (Space or a second click opens the list)"
                    CASE __UI_DataGrid_Toggle: Holds$ = "a check box (a click or Space checks it)"
                    CASE ELSE: Holds$ = "any text"
                END SELECT
                Caption(RowsHintLB) = Caption$ + ": " + Holds$ + ". Your code reads cells with DataGrid_Cell$ and changes them with DataGrid_SetCell."
            END IF
    END SELECT
END SUB

'---------------------------------------------------------------------------------
'Z-ordering dialog
'
'The list is kept in step with the preview locally: a move swaps the two rows
'right away and tells the preview to swap the same two control slots. Slot
'numbers don't change when controls are swapped, so moves can be sent back to
'back without waiting for the preview. The list is only rebuilt from the
'preview's data once it settles, and only if it actually differs (undo, etc.).

FUNCTION ZOrderable%% (i AS LONG)
    IF PreviewControls(i).ID = 0 THEN EXIT FUNCTION
    SELECT CASE PreviewControls(i).Type
        CASE 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 14, 15, 18
            ZOrderable = True
    END SELECT
END FUNCTION

FUNCTION ZOrderMovePending%%
    'True while dragging and for a short while after a move, until the preview has caught up
    DIM elapsed AS DOUBLE
    IF __UI_ReorderingID = ControlList THEN ZOrderMovePending = True: EXIT FUNCTION
    IF ZOrderLastMove = 0 THEN EXIT FUNCTION
    elapsed = TIMER(.001) - ZOrderLastMove
    IF elapsed >= 0 AND elapsed < .3 THEN ZOrderMovePending = True ELSE ZOrderLastMove = 0
END FUNCTION

SUB ZOrderRefreshList (Force AS _BYTE)
    'Fills zOrderIDs() from the latest preview data and reloads the list if it changed
    DIM i AS LONG, total AS LONG, items$, prevValue AS LONG, prevViewStart AS LONG

    IF UBOUND(zOrderIDs) < UBOUND(PreviewControls) THEN REDIM zOrderIDs(0 TO UBOUND(PreviewControls)) AS LONG
    FOR i = 1 TO UBOUND(PreviewControls)
        IF ZOrderable(i) THEN
            total = total + 1
            zOrderIDs(total) = i
            items$ = items$ + __UI_Type(PreviewControls(i).Type).Name + RTRIM$(PreviewControls(i).Name) + CHR$(10)
        END IF
    NEXT

    IF NOT Force AND items$ = Text(ControlList) AND total = Control(ControlList).Max THEN EXIT SUB

    prevValue = Control(ControlList).Value
    prevViewStart = Control(ControlList).InputViewStart
    ResetList ControlList
    Text(ControlList) = items$
    Control(ControlList).Max = total
    Control(ControlList).LastVisibleItem = 0
    IF prevValue > total THEN prevValue = total
    Control(ControlList).Value = prevValue
    Control(ControlList).PreviousValue = prevValue
    IF prevViewStart > total THEN prevViewStart = total
    IF prevViewStart < 1 THEN prevViewStart = 1
    Control(ControlList).InputViewStart = prevViewStart
    Control(ControlList).Redraw = True
    ZOrderUpdateButtons
END SUB

SUB ZOrderSelectControl (id AS LONG)
    'Highlights control slot id in the list without echoing it back to the preview
    DIM i AS LONG
    IF id = 0 OR id = PreviewFormID THEN EXIT SUB
    FOR i = 1 TO Control(ControlList).Max
        IF zOrderIDs(i) = id THEN
            ZOrderSetValue i
            EXIT SUB
        END IF
    NEXT
END SUB

SUB ZOrderSetValue (v AS LONG)
    DIM visible AS LONG
    Control(ControlList).Value = v
    Control(ControlList).PreviousValue = v
    visible = Control(ControlList).LastVisibleItem
    IF visible = 0 AND Control(ControlList).ItemHeight > 0 THEN 'not drawn yet
        visible = FIX((Control(ControlList).Height - ABS(Control(ControlList).HasBorder) * 5) / Control(ControlList).ItemHeight)
    END IF
    IF visible > 0 AND v > 0 THEN
        IF v < Control(ControlList).InputViewStart THEN
            Control(ControlList).InputViewStart = v
        ELSEIF v > Control(ControlList).InputViewStart + visible - 1 THEN
            Control(ControlList).InputViewStart = v - visible + 1
        END IF
    END IF
    Control(ControlList).Redraw = True
    ZOrderUpdateButtons
END SUB

SUB ZOrderUpdateButtons
    DIM v AS LONG
    v = Control(ControlList).Value
    Control(UpBT).Disabled = (v <= 1 OR v > Control(ControlList).Max)
    Control(DownBT).Disabled = (v < 1 OR v >= Control(ControlList).Max)
END SUB

SUB ZOrderMove (Direction AS LONG)
    DIM v AS LONG, t AS LONG, a AS LONG, b AS LONG, itemA$, itemB$, b$

    v = Control(ControlList).Value
    t = v + Direction
    IF v < 1 OR v > Control(ControlList).Max OR t < 1 OR t > Control(ControlList).Max THEN EXIT SUB
    a = zOrderIDs(v)
    b = zOrderIDs(t)

    b$ = MKL$(a) + MKL$(b)
    IF Direction < 0 THEN SendData b$, 211 ELSE SendData b$, 212

    'The moved control now lives in slot b: keep it selected
    b$ = MKL$(b)
    SendData b$, 213

    itemA$ = GetItem(ControlList, v)
    itemB$ = GetItem(ControlList, t)
    ReplaceItem ControlList, v, itemB$
    ReplaceItem ControlList, t, itemA$
    ZOrderSetValue t

    ZOrderLastMove = TIMER(.001)
    IF ZOrderLastMove = 0 THEN ZOrderLastMove = .001
    ZOrderListDirty = True 'check against the preview once it settles
END SUB

SUB ZOrderItemDropped (From AS LONG, Dest AS LONG)
    'The list has already moved the item; give the preview the whole new order
    'in one message (which also makes the drag a single undo step)
    DIM i AS LONG, n AS LONG, keepID AS LONG, b$

    n = Control(ControlList).Max
    IF From < 1 OR From > n OR Dest < 1 OR Dest > n THEN EXIT SUB
    DIM order(1 TO n) AS LONG
    FOR i = 1 TO n
        order(i) = zOrderIDs(i)
    NEXT
    keepID = order(From)
    IF Dest > From THEN
        FOR i = From TO Dest - 1
            order(i) = order(i + 1)
        NEXT
    ELSE
        FOR i = From TO Dest + 1 STEP -1
            order(i) = order(i - 1)
        NEXT
    END IF
    order(Dest) = keepID

    b$ = MKL$(n)
    FOR i = 1 TO n
        b$ = b$ + MKL$(zOrderIDs(i)) + MKL$(order(i))
    NEXT
    SendData b$, 229

    'The dropped control now lives in the slot of the row it was dropped on
    ZOrderSetValue Dest
    b$ = MKL$(zOrderIDs(Dest))
    SendData b$, 213

    ZOrderLastMove = TIMER(.001)
    IF ZOrderLastMove = 0 THEN ZOrderLastMove = .001
    ZOrderListDirty = True 'check against the preview once it settles
END SUB

'---------------------------------------------------------------------------------
'Session recovery
'
'While a form has unsaved changes, a copy is kept in RECOVERY_FILE. Closing the
'editor keeps it, and the next session starts with that work restored.
'File layout: "InFormRecovery" + CHR$(1), then length-prefixed (MKL$) fields:
'file name, path, initial control set, gif extension flags, form data.

SUB SaveRecovery
    DIM f AS INTEGER, b$
    IF LEN(LastFormData$) = 0 OR _DIREXISTS("InForm") = 0 THEN EXIT SUB
    b$ = "InFormRecovery" + CHR$(1)
    b$ = b$ + MKL$(LEN(ThisFileName$)) + ThisFileName$
    b$ = b$ + MKL$(LEN(CurrentPath$)) + CurrentPath$
    b$ = b$ + MKL$(LEN(InitialControlSet)) + InitialControlSet
    b$ = b$ + MKL$(4) + MKI$(AddGifExtension) + MKI$(LoadedWithGifExtension)
    b$ = b$ + MKL$(LEN(LastFormData$)) + LastFormData$
    IF _FILEEXISTS(RECOVERY_FILE) THEN KILL RECOVERY_FILE
    f = FREEFILE
    OPEN RECOVERY_FILE FOR BINARY AS #f
    PUT #f, 1, b$
    CLOSE #f
    RecoverySaved$ = LastFormData$
    RecoverySavedAt = TIMER(.001)
END SUB

SUB DiscardRecovery
    IF _FILEEXISTS(RECOVERY_FILE) THEN KILL RECOVERY_FILE
    RecoverySaved$ = ""
END SUB

FUNCTION RecoveryField$ (b$)
    'Reads the next length-prefixed field (b$ is consumed)
    DIM l AS LONG
    IF LEN(b$) < 4 THEN b$ = "": EXIT FUNCTION
    l = CVL(LEFT$(b$, 4))
    IF l < 0 OR l > LEN(b$) - 4 THEN b$ = "": EXIT FUNCTION
    RecoveryField$ = MID$(b$, 5, l)
    b$ = MID$(b$, 5 + l)
END FUNCTION

'Gets the preview ready to load the recovered form. Returns False if there's
'nothing usable to restore.
FUNCTION LoadRecovery%%
    DIM f AS INTEGER, b$, fileName$, filePath$, controlSet$, flags$, formData$

    f = FREEFILE
    OPEN RECOVERY_FILE FOR BINARY AS #f
    b$ = SPACE$(LOF(f))
    GET #f, 1, b$
    CLOSE #f

    IF LEFT$(b$, 15) <> "InFormRecovery" + CHR$(1) THEN EXIT FUNCTION
    b$ = MID$(b$, 16)
    fileName$ = RecoveryField$(b$)
    filePath$ = RecoveryField$(b$)
    controlSet$ = RecoveryField$(b$)
    flags$ = RecoveryField$(b$)
    formData$ = RecoveryField$(b$)
    IF LEN(formData$) = 0 OR LEN(flags$) <> 4 THEN EXIT FUNCTION

    'The preview loads this file when it starts
    f = FREEFILE
    OPEN "InForm/UiEditorPreview.frmbin" FOR BINARY AS #f
    b$ = "InForm" + CHR$(1) + formData$
    PUT #f, 1, b$
    CLOSE #f

    ThisFileName$ = fileName$
    CurrentPath$ = filePath$
    InitialControlSet = controlSet$
    AddGifExtension = CVI(LEFT$(flags$, 2))
    LoadedWithGifExtension = CVI(MID$(flags$, 3, 2))
    Control(AddGifExtensionToggle).Value = (AddGifExtension OR LoadedWithGifExtension = True)
    LoadRecovery = True
END FUNCTION

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
    DIM b$

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

            END IF
        END IF
    $ELSE
        IF UiPreviewPID > 0 THEN
            IF PROCESS_CLOSED(UiPreviewPID, 0) THEN
                'Preview was closed.
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

    ' Do not add more path seperators if it already exists
    IF RIGHT$(CurrentPath$, 1) = DIRECTORY_SEPARATOR THEN
        BaseOutputFileName = CurrentPath$ + tempThisFileName$
    ELSE
        BaseOutputFileName = CurrentPath$ + DIRECTORY_SEPARATOR + tempThisFileName$
    END IF

    IF (_FILEEXISTS(BaseOutputFileName + ".bas") AND SaveOnlyFrm = False) AND _FILEEXISTS(BaseOutputFileName + ".frm") THEN
        b$ = "These files will be overwritten:" + CHR$(10) + "    "
        b$ = b$ + tempThisFileName$ + ".bas" + CHR$(10) + "    "
        b$ = b$ + tempThisFileName$ + ".frm" + CHR$(10)
        b$ = b$ + "Proceed?"
    ELSEIF (_FILEEXISTS(BaseOutputFileName + ".bas") AND SaveOnlyFrm = False) AND _FILEEXISTS(BaseOutputFileName + ".frm") = 0 THEN
        b$ = "'" + tempThisFileName$ + ".bas" + "' will be overwritten." + CHR$(10)
        b$ = b$ + "Proceed?"
    ELSEIF _FILEEXISTS(BaseOutputFileName + ".frm") THEN
        b$ = "'" + tempThisFileName$ + ".frm" + "' will be overwritten." + CHR$(10)
        b$ = b$ + "Proceed?"
    END IF

    IF LEN(b$) > 0 THEN
        __UI_Delay COMMDLG_DELAY: Answer = _MESSAGEBOX(UiEditorTitle$, b$, "yesno", "question", 0)
        IF Answer = 0 THEN EXIT SUB
    END IF

    AddGifExtension = Control(AddGifExtensionToggle).Value

    IF (AddGifExtension OR Control(AddGifExtensionToggle).Value) AND LoadedWithGifExtension = False AND TotalGifLoaded = 0 THEN
        __UI_Delay COMMDLG_DELAY: Answer = _MESSAGEBOX(UiEditorTitle$, "Are you sure you want to include the GIF extension?\n(no animated GIFs have been added to this form)", "yesno", "question", 0)
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
                PreserveBackup = True
            END IF
        END IF
    NEXT

    '.FRM file
    TextFileNum = FREEFILE
    OPEN BaseOutputFileName + ".frm" FOR OUTPUT AS #TextFileNum
    PRINT #TextFileNum, "': This form was generated by"
    PRINT #TextFileNum, "': InForm-PE for QB64-PE - v"; __UI_Version
    PRINT #TextFileNum, "': Copyright (c) 2025 QB64 Phoenix Edition Team"
    PRINT #TextFileNum, "': https://github.com/QB64-Phoenix-Edition/InForm-PE"
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
                    CASE __UI_Type_TabControl: a$ = a$ + "__UI_Type_TabControl, ": IF ThisPass = 2 THEN GOTO EndOfThisPass
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

                IF PreviewControls(i).Type = __UI_Type_Form AND LEN(PreviewTheme) > 0 AND LCASE$(PreviewTheme) <> "xp" THEN
                    PRINT #TextFileNum, "    SetTheme " + CHR$(34) + PreviewTheme + CHR$(34)
                END IF

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
                        CASE __UI_Type_ListBox, __UI_Type_DropdownList, __UI_Type_TabControl
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
                IF PreviewControls(i).Stretch = True THEN
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
                'The preview only sends colors that differ from its theme's defaults, so every color here is custom.
                '(The editor can't check this itself: defaults depend on the designed form's theme and colors.)
                IF PreviewControls(i).ForeColor <> 0 THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).ForeColor = _RGB32(" + LTRIM$(STR$(_RED32(PreviewControls(i).ForeColor))) + ", " + LTRIM$(STR$(_GREEN32(PreviewControls(i).ForeColor))) + ", " + LTRIM$(STR$(_BLUE32(PreviewControls(i).ForeColor))) + ")"
                END IF
                IF PreviewControls(i).BackColor <> 0 THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).BackColor = _RGB32(" + LTRIM$(STR$(_RED32(PreviewControls(i).BackColor))) + ", " + LTRIM$(STR$(_GREEN32(PreviewControls(i).BackColor))) + ", " + LTRIM$(STR$(_BLUE32(PreviewControls(i).BackColor))) + ")"
                END IF
                IF PreviewControls(i).SelectedForeColor <> 0 THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).SelectedForeColor = _RGB32(" + LTRIM$(STR$(_RED32(PreviewControls(i).SelectedForeColor))) + ", " + LTRIM$(STR$(_GREEN32(PreviewControls(i).SelectedForeColor))) + ", " + LTRIM$(STR$(_BLUE32(PreviewControls(i).SelectedForeColor))) + ")"
                END IF
                IF PreviewControls(i).SelectedBackColor <> 0 THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).SelectedBackColor = _RGB32(" + LTRIM$(STR$(_RED32(PreviewControls(i).SelectedBackColor))) + ", " + LTRIM$(STR$(_GREEN32(PreviewControls(i).SelectedBackColor))) + ", " + LTRIM$(STR$(_BLUE32(PreviewControls(i).SelectedBackColor))) + ")"
                END IF
                IF PreviewControls(i).BorderColor <> 0 THEN
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
                IF PreviewControls(i).PasswordField = True AND PreviewControls(i).Type = __UI_Type_TextBox THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).PasswordField = True"
                END IF
                IF PreviewControls(i).Multiline AND PreviewControls(i).Type = __UI_Type_TextBox THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).Multiline = True"
                END IF
                IF PreviewControls(i).Value <> 0 THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).Value = " + LTRIM$(STR$(PreviewControls(i).Value))
                END IF
                IF PreviewIsTabChild(i) THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).TabPage = " + LTRIM$(STR$(PreviewControls(i).TabPage))
                END IF
                IF PreviewControls(i).Min <> 0 THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).Min = " + LTRIM$(STR$(PreviewControls(i).Min))
                END IF
                IF PreviewControls(i).Max <> 0 THEN
    IF PreviewControls(i).Type <> __UI_Type_ListBox AND _
        PreviewControls(i).Type <>  __UI_Type_DropdownList AND _
        PreviewControls(i).Type <> __UI_Type_TabControl THEN
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
                IF PreviewControls(i).AutoScroll THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).AutoScroll = True"
                END IF
                IF PreviewControls(i).Searchable AND PreviewControls(i).Type = __UI_Type_DropdownList THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).Searchable = True"
                    IF PreviewControls(i).Fuzzy THEN PRINT #TextFileNum, "    Control(__UI_NewID).Fuzzy = True"
                END IF
                IF PreviewControls(i).Reorderable AND PreviewControls(i).Type = __UI_Type_ListBox THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).Reorderable = True"
                END IF
                IF PreviewControls(i).Anchor <> 0 AND PreviewControls(i).Anchor <> (__UI_Anchor_Left OR __UI_Anchor_Top) THEN
                    PRINT #TextFileNum, "    Control(__UI_NewID).Anchor = " + AnchorFlagsCode$(PreviewControls(i).Anchor)
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
    'Each binding is listed by both of its controls; write it once, from the first one
    DIM BindingsSection AS _BYTE, OtherBound$, OtherProperty$, BindingRecord AS LONG
    FOR i = 1 TO UBOUND(PreviewControls)
        BindingRecord = 1
        DO WHILE BindingRecord < LEN(PreviewBindings(i))
            OtherBound$ = MID$(PreviewBindings(i), BindingRecord + 2, CVI(MID$(PreviewBindings(i), BindingRecord, 2)))
            BindingRecord = BindingRecord + 2 + LEN(OtherBound$)
            b$ = MID$(PreviewBindings(i), BindingRecord + 2, CVI(MID$(PreviewBindings(i), BindingRecord, 2)))
            BindingRecord = BindingRecord + 2 + LEN(b$)
            FOR j = i + 1 TO UBOUND(PreviewControls)
                IF PreviewName$(j) = OtherBound$ THEN
                    OtherProperty$ = PreviewBoundProperty$(j, PreviewName$(i))
                    IF LEN(OtherProperty$) THEN
                        IF BindingsSection = False THEN
                            PRINT #TextFileNum, "    'Control bindings:"
                            BindingsSection = True
                        END IF
                        PRINT #TextFileNum, "    __UI_Bind __UI_GetID(" + CHR$(34) + PreviewName$(i) + CHR$(34) + "), ";
                        PRINT #TextFileNum, "__UI_GetID(" + CHR$(34) + OtherBound$ + CHR$(34) + "), ";
                        PRINT #TextFileNum, CHR$(34) + b$ + CHR$(34) + ", " + CHR$(34) + OtherProperty$ + CHR$(34)
                    END IF
                    EXIT FOR
                END IF
            NEXT
        LOOP
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

                    found = False
                    FOR i = 1 TO UBOUND(PreviewControls)
                        IF PreviewControls(i).ID > 0 AND PreviewControls(i).Type <> __UI_Type_Font AND PreviewControls(i).Type <> __UI_Type_MenuPanel THEN
                            IF LCASE$(RTRIM$(PreviewControls(i).Name)) = LCASE$(temp$) THEN
                                found = True
                                EXIT FOR
                            END IF
                        END IF
                    NEXT

                    IF found THEN
                        IF INSTR(thisBlock$, CHR$(11)) THEN
                            'controlToRemove$ was in the initial state but got renamed to temp$
                            insertionPoint = INSTR(BackupCode$, controlToRemove$)
                            DO WHILE insertionPoint > 0
                                found = True
                                IF OutsideQuotes(BackupCode$, insertionPoint) THEN
                                    a$ = MID$(BackupCode$, insertionPoint - 1, 1)
                                    b$ = MID$(BackupCode$, insertionPoint + LEN(controlToRemove$), 1)
                                    IF LEN(a$) > 0 AND INSTR(charSep$, a$) = 0 THEN found = False
                                    IF LEN(b$) > 0 AND INSTR(charSep$, b$) = 0 THEN found = False
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
                            found = True
                            COLOR 8: PRINT insertionPoint, MID$(BackupCode$, insertionPoint, 30)
                            IF OutsideQuotes(BackupCode$, insertionPoint) THEN
                                a$ = MID$(BackupCode$, insertionPoint - 1, 1)
                                b$ = MID$(BackupCode$, insertionPoint + LEN(controlToRemove$), 1)
                                IF LEN(a$) > 0 AND INSTR(charSep$, a$) = 0 THEN found = False
                                IF LEN(b$) > 0 AND INSTR(charSep$, b$) = 0 THEN found = False
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
                                        IF i = 13 AND IsPropertyGridFrame(Dummy) THEN
                                            'A frame that became a property grid gets the explained CASE block
                                            addedItems$ = addedItems$ + PropertyGridValueChangedCase$(Dummy, indenting) + CHR$(10)
                                        ELSEIF i = 13 AND IsDataGridFrame(Dummy) THEN
                                            addedItems$ = addedItems$ + DataGridValueChangedCase$(Dummy, indenting) + CHR$(10)
                                        ELSE
                                            addedItems$ = addedItems$ + SPACE$(indenting) + "CASE " + RTRIM$(PreviewControls(Dummy).Name) + CHR$(10) + CHR$(10)
                                        END IF
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
            PRINT #TextFileNum, "': InForm-PE for QB64-PE - v"; __UI_Version
            PRINT #TextFileNum, "': Copyright (c) 2025 QB64 Phoenix Edition Team"
            PRINT #TextFileNum, "': https://github.com/QB64-Phoenix-Edition/InForm-PE"
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
            PRINT #TextFileNum, "'$INCLUDE:'InForm/InForm.bi'"
            PRINT #TextFileNum, "'$INCLUDE:'" + MID$(BaseOutputFileName, LEN(CurrentPath$) + 1) + ".frm'"
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
                        'Hints go right below the SUB line, each followed by an empty line
                        '(the empty body line is only needed when nothing else goes in)
                        DIM OnLoadHasCode AS _BYTE
                        OnLoadHasCode = False
                        IF PreviewDefaultButtonID > 0 THEN
                            PRINT #TextFileNum, "    __UI_DefaultButtonID = " + RTRIM$(__UI_TrimAt0$(PreviewControls(PreviewDefaultButtonID).Name))
                            OnLoadHasCode = True
                        END IF
                        FOR Dummy = 1 TO UBOUND(PreviewControls)
                            IF IsPropertyGridFrame(Dummy) THEN
                                PrintLines TextFileNum, PropertyGridOnLoadHint$(Dummy)
                                PRINT #TextFileNum,
                                OnLoadHasCode = True
                            ELSEIF IsDataGridFrame(Dummy) THEN
                                PrintLines TextFileNum, DataGridOnLoadHint$(Dummy)
                                PRINT #TextFileNum,
                                OnLoadHasCode = True
                            END IF
                        NEXT
                        IF NOT OnLoadHasCode THEN PRINT #TextFileNum,

                    CASE 2
                        IF AddGifExtension = True AND TotalGifLoaded > 0 THEN
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

                    CASE 4 'Buttons on property grid rows
                        PrintLines TextFileNum, PropertyGridClickBlock$

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

                    CASE 13 'Dropdown list, List box, Tab control, Track bar, ToggleSwitch, CheckBox
                        PRINT #TextFileNum, "    SELECT CASE id"
                        FOR Dummy = 1 TO UBOUND(PreviewControls)
                            IF PreviewControls(Dummy).ID > 0 AND (PreviewControls(Dummy).Type = __UI_Type_ListBox OR PreviewControls(Dummy).Type = __UI_Type_DropdownList OR PreviewControls(Dummy).Type = __UI_Type_TabControl OR PreviewControls(Dummy).Type = __UI_Type_TrackBar OR PreviewControls(Dummy).Type = __UI_Type_ToggleSwitch OR PreviewControls(Dummy).Type = __UI_Type_CheckBox OR PreviewControls(Dummy).Type = __UI_Type_RadioButton) THEN
                                PRINT #TextFileNum, "        CASE " + RTRIM$(PreviewControls(Dummy).Name)
                                PRINT #TextFileNum,
                            ELSEIF IsPropertyGridFrame(Dummy) THEN
                                PrintLines TextFileNum, PropertyGridValueChangedCase$(Dummy, 8)
                                PRINT #TextFileNum,
                            ELSEIF IsDataGridFrame(Dummy) THEN
                                PrintLines TextFileNum, DataGridValueChangedCase$(Dummy, 8)
                                PRINT #TextFileNum,
                            END IF
                        NEXT
                        PRINT #TextFileNum, "    END SELECT"
                END SELECT
                PRINT #TextFileNum, "END SUB"
                PRINT #TextFileNum,
            NEXT
            PRINT #TextFileNum, "'$INCLUDE:'InForm/InForm.ui'"
        END IF
        CLOSE #TextFileNum
    END IF

    AddToRecentList BaseOutputFileName + ".frm"
    Edited = False
    DiscardRecovery

    b$ = "Exporting successful. Files output:" + CHR$(10)
    IF NOT SaveOnlyFrm THEN b$ = b$ + "    " + MID$(BaseOutputFileName, LEN(CurrentPath$) + 1) + ".bas" + CHR$(10)
    b$ = b$ + "    " + MID$(BaseOutputFileName, LEN(CurrentPath$) + 1) + ".frm"

    IF ExitToQB64 AND NOT SaveOnlyFrm THEN
        IF _FILEEXISTS(QB64PEExePath) THEN
            b$ = b$ + CHR$(10) + CHR$(10) + "Exit to " + QB64_DISPLAY + "?"
            __UI_Delay COMMDLG_DELAY: Answer = _MESSAGEBOX(UiEditorTitle$, b$, "yesno", "question", 0)
            IF Answer = 0 THEN Edited = False: EXIT SUB
            IF _FILEEXISTS("InForm/UiEditorPreview.frmbin") THEN KILL "InForm/UiEditorPreview.frmbin"
            SHELL _DONTWAIT QB64PEExePath + " " + GetQuotedFileName(BaseOutputFileName + ".bas")
            SYSTEM
        ELSE
            b$ = b$ + CHR$(10) + CHR$(10) + "Close the editor?"
            __UI_Delay COMMDLG_DELAY: Answer = _MESSAGEBOX(UiEditorTitle$, b$, "yesno", "question", 0)
            IF Answer = 0 THEN Edited = False: EXIT SUB
            SaveSettings
            IF _FILEEXISTS("InForm/UiEditorPreview.frmbin") THEN KILL "InForm/UiEditorPreview.frmbin"
            SYSTEM
        END IF
    ELSE
        MessageBox b$, UiEditorTitle$, MsgBox_Information
        Edited = False
    END IF

    EXIT SUB

    checkCondition:
    checkConditionResult = False
    SELECT CASE i
        CASE 4 TO 6, 9, 10 'All controls except for Menu panels, and internal context menus
            IF PreviewControls(Dummy).ID > 0 AND PreviewControls(Dummy).Type <> __UI_Type_Font AND PreviewControls(Dummy).Type <> __UI_Type_ContextMenu THEN
                checkConditionResult = True
            END IF

        CASE 7, 8, 11 'Controls that can have focus only
            IF PreviewControls(Dummy).ID > 0 AND PreviewControls(Dummy).CanHaveFocus THEN
                checkConditionResult = True
            END IF

        CASE 12 'Text boxes
            IF PreviewControls(Dummy).ID > 0 AND (PreviewControls(Dummy).Type = __UI_Type_TextBox) THEN
                checkConditionResult = True
            END IF

        CASE 13 'Dropdown list, List box, Tab control, Track bar, ToggleSwitch, CheckBox, property grid frames
            IF IsPropertyGridFrame(Dummy) OR IsDataGridFrame(Dummy) THEN checkConditionResult = True
            IF PreviewControls(Dummy).ID > 0 AND (PreviewControls(Dummy).Type = __UI_Type_ListBox OR PreviewControls(Dummy).Type = __UI_Type_DropdownList OR PreviewControls(Dummy).Type = __UI_Type_TabControl OR PreviewControls(Dummy).Type = __UI_Type_TrackBar OR PreviewControls(Dummy).Type = __UI_Type_ToggleSwitch OR PreviewControls(Dummy).Type = __UI_Type_CheckBox OR PreviewControls(Dummy).Type = __UI_Type_RadioButton) THEN
                checkConditionResult = True
            END IF
    END SELECT
    RETURN

END SUB

SUB LoadFontList
    HasFontList = True
    TotalFontsFound = FontMgr_BuildList(FontFile())

    DIM i AS _UNSIGNED LONG: FOR i = 1 TO TotalFontsFound
        DIM fullFontName AS STRING: fullFontName = FontMgr_GetName(FontFile(i), 0, FONTMGR_NAME_FULL)
        IF LEN(fullFontName) = 0 THEN
            fullFontName = Pathname_RemoveFileExtension(Pathname_GetFileName(FontFile(i)))
        END IF

        AddItem FontList, fullFontName
    NEXT i

    FOR i = 8 TO 120
        AddItem FontSizeList, LTRIM$(STR$(i))
    NEXT
END SUB

FUNCTION GetQuotedFileName$ (fileName AS STRING)
    $IF WIN THEN
        GetQuotedFileName = CHR$(34) + fileName + CHR$(34)
    $ELSE
        GetQuotedFileName = "'" + fileName + "'"
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

''' @brief _TRUE for a frame that has property grid rows (see docs/PropertyGrid.md).
FUNCTION IsPropertyGridFrame%% (i AS LONG)
    IF PreviewControls(i).ID = 0 OR PreviewControls(i).Type <> __UI_Type_Frame THEN EXIT FUNCTION
    IF __UI_IsDataGridDefinition(PreviewTexts(i)) THEN EXIT FUNCTION
    IsPropertyGridFrame = LEN(_TRIM$(Replace$(PreviewTexts(i), CHR$(10), "", False, 0))) > 0
END FUNCTION

''' @brief _TRUE for a frame whose Text holds a data grid's columns and rows (see docs/DataGrid.md).
FUNCTION IsDataGridFrame%% (i AS LONG)
    IF i <= 0 OR i > UBOUND(PreviewControls) THEN EXIT FUNCTION
    IF PreviewControls(i).ID = 0 OR PreviewControls(i).Type <> __UI_Type_Frame THEN EXIT FUNCTION
    IsDataGridFrame = __UI_IsDataGridDefinition(PreviewTexts(i))
END FUNCTION

''' @brief A button caption that counts things: "None - add rows...", "1 row - edit...", "3 rows - edit...".
FUNCTION CountCaption$ (n AS LONG, Noun$)
    SELECT CASE n
        CASE IS <= 0: CountCaption$ = "None - add " + Noun$ + "s..."
        CASE 1: CountCaption$ = "1 " + Noun$ + " - edit..."
        CASE ELSE: CountCaption$ = LTRIM$(STR$(n)) + " " + Noun$ + "s - edit..."
    END SELECT
END FUNCTION

''' @brief The CASE block written in __UI_ValueChanged for a data grid frame, explaining how to use it.
FUNCTION DataGridValueChangedCase$ (i AS LONG, Indent AS INTEGER)
    DIM n$, p$, r$, LF$, GridColumns$, GridRows$, c AS LONG, Caption$, Kind AS _BYTE, ColumnWidth AS INTEGER, Items$

    n$ = RTRIM$(PreviewControls(i).Name)
    p$ = SPACE$(Indent)
    LF$ = CHR$(10)
    __UI_DGSplitDefinition PreviewTexts(i), GridColumns$, GridRows$
    r$ = p$ + "CASE " + n$ + LF$
    r$ = r$ + p$ + "    '" + n$ + " is a data grid. This runs when a cell is changed (Enter was pressed in it, an" + LF$
    r$ = r$ + p$ + "    'item was picked or a box was checked) and when another cell becomes current." + LF$
    r$ = r$ + p$ + "    'Cells are text: use VAL() for numbers. A toggle is " + CHR$(34) + "-1" + CHR$(34) + " when checked." + LF$
    r$ = r$ + p$ + "    IF DataGrid_ChangedColumn(" + n$ + ") > 0 THEN" + LF$
    r$ = r$ + p$ + "        SELECT CASE DataGrid_ChangedColumn(" + n$ + ")" + LF$
    FOR c = 1 TO __UI_DGPartCount(GridColumns$, LF$) - 1
        __UI_DGParseColumn __UI_DGPart(GridColumns$, c, LF$), Caption$, Kind, ColumnWidth, Items$
        r$ = r$ + p$ + "            CASE" + STR$(c) + " '" + Caption$ + LF$
        r$ = r$ + p$ + "                'The new value: DataGrid_Cell$(" + n$ + ", DataGrid_ChangedRow(" + n$ + ")," + STR$(c) + ")" + LF$
        r$ = r$ + LF$
    NEXT
    r$ = r$ + p$ + "        END SELECT" + LF$
    r$ = r$ + p$ + "    ELSE" + LF$
    r$ = r$ + p$ + "        'Another cell became current: DataGrid_Row(" + n$ + "), DataGrid_Column(" + n$ + ")" + LF$
    r$ = r$ + p$ + "    END IF" + LF$
    DataGridValueChangedCase$ = r$
END FUNCTION

''' @brief Comments written in __UI_OnLoad for a data grid frame.
FUNCTION DataGridOnLoadHint$ (i AS LONG)
    DIM n$, r$, q$, LF$
    n$ = RTRIM$(PreviewControls(i).Name)
    q$ = CHR$(34)
    LF$ = CHR$(10)
    r$ = "    '" + n$ + " is a data grid: its columns and rows were built from the designer just before" + LF$
    r$ = r$ + "    'this event, so you can add rows or change cells here, for example:" + LF$
    r$ = r$ + "    'r = DataGrid_AddRow(" + n$ + ", " + q$ + "first cell|second cell" + q$ + ")" + LF$
    r$ = r$ + "    'See docs/DataGrid.md for everything a data grid can do." + LF$
    DataGridOnLoadHint$ = r$
END FUNCTION

''' @brief The rows of a property grid frame, one "key|kind" per line (kind as a __UI_PropertyGrid_* number).
FUNCTION PropertyGridRowList$ (i AS LONG)
    DIM t$, l$, p AS LONG, r$, k$, kind AS _BYTE, label$, extra$
    t$ = Replace$(PreviewTexts(i), CHR$(13), "", False, 0) + CHR$(10)
    DO
        p = INSTR(t$, CHR$(10))
        IF p = 0 THEN EXIT DO
        l$ = LEFT$(t$, p - 1)
        t$ = MID$(t$, p + 1)
        IF __UI_PGParseLine(l$, k$, kind, label$, extra$) THEN
            IF kind = __UI_PropertyGrid_Choice THEN
                p = INSTR(extra$, ",")
                IF p THEN extra$ = LEFT$(extra$, p - 1)
            END IF
            r$ = r$ + k$ + "|" + LTRIM$(STR$(kind)) + "|" + extra$ + CHR$(10)
        END IF
    LOOP
    PropertyGridRowList$ = r$
END FUNCTION

''' @brief Splits one entry of PropertyGridRowList$.
SUB PropertyGridRowFields (Entry$, Key$, Kind AS INTEGER, FirstItem$)
    DIM p1 AS LONG, p2 AS LONG
    p1 = INSTR(Entry$, "|")
    p2 = INSTR(p1 + 1, Entry$, "|")
    Key$ = LEFT$(Entry$, p1 - 1)
    Kind = VAL(MID$(Entry$, p1 + 1, p2 - p1 - 1))
    FirstItem$ = MID$(Entry$, p2 + 1)
END SUB

''' @brief The CASE block written in __UI_ValueChanged for a property grid frame, explaining how to use it.
FUNCTION PropertyGridValueChangedCase$ (i AS LONG, Indent AS INTEGER)
    DIM n$, p$, r$, rows$, entry$, k$, item$, kind AS INTEGER, q$, LF$, pos1 AS LONG

    n$ = RTRIM$(PreviewControls(i).Name)
    p$ = SPACE$(Indent)
    q$ = CHR$(34)
    LF$ = CHR$(10)
    r$ = p$ + "CASE " + n$ + LF$
    r$ = r$ + p$ + "    '" + n$ + " is a property grid. This runs when one of its rows changes: Enter was" + LF$
    r$ = r$ + p$ + "    'pressed in a box (or the box lost focus), an item was picked or a box was checked." + LF$
    r$ = r$ + p$ + "    'PropertyGrid_Value$ reads the new value; PropertyGrid_SetValue here replaces it" + LF$
    r$ = r$ + p$ + "    '(for example, to keep a number in range: the box then turns red until Esc)." + LF$
    r$ = r$ + p$ + "    SELECT CASE PropertyGrid_ChangedRow$(" + n$ + ")" + LF$

    rows$ = PropertyGridRowList$(i)
    DO
        pos1 = INSTR(rows$, LF$)
        IF pos1 = 0 THEN EXIT DO
        entry$ = LEFT$(rows$, pos1 - 1)
        rows$ = MID$(rows$, pos1 + 1)
        PropertyGridRowFields entry$, k$, kind, item$
        IF kind = __UI_PropertyGrid_Button THEN _CONTINUE 'clicks go to __UI_Click
        r$ = r$ + p$ + "        CASE " + q$ + k$ + q$ + LF$
        SELECT CASE kind
            CASE __UI_PropertyGrid_Integer, __UI_PropertyGrid_Float
                r$ = r$ + p$ + "            'The number entered: VAL(PropertyGrid_Value$(" + n$ + ", " + q$ + k$ + q$ + "))" + LF$
            CASE __UI_PropertyGrid_Choice
                r$ = r$ + p$ + "            'The item picked (1 = " + item$ + "): VAL(PropertyGrid_Value$(" + n$ + ", " + q$ + k$ + q$ + "))" + LF$
            CASE __UI_PropertyGrid_Toggle
                r$ = r$ + p$ + "            'Checked: PropertyGrid_Value$(" + n$ + ", " + q$ + k$ + q$ + ") <> " + q$ + "0" + q$ + LF$
            CASE ELSE
                r$ = r$ + p$ + "            'The text entered: PropertyGrid_Value$(" + n$ + ", " + q$ + k$ + q$ + ")" + LF$
        END SELECT
        r$ = r$ + LF$
    LOOP
    r$ = r$ + p$ + "    END SELECT" + LF$
    PropertyGridValueChangedCase$ = r$
END FUNCTION

''' @brief Comments written in __UI_OnLoad for a property grid frame.
FUNCTION PropertyGridOnLoadHint$ (i AS LONG)
    DIM n$, r$, rows$, entry$, k$, item$, kind AS INTEGER, q$, LF$, pos1 AS LONG, example$

    n$ = RTRIM$(PreviewControls(i).Name)
    q$ = CHR$(34)
    LF$ = CHR$(10)
    rows$ = PropertyGridRowList$(i)
    DO
        pos1 = INSTR(rows$, LF$)
        IF pos1 = 0 THEN EXIT DO
        entry$ = LEFT$(rows$, pos1 - 1)
        rows$ = MID$(rows$, pos1 + 1)
        PropertyGridRowFields entry$, k$, kind, item$
        SELECT CASE kind
            CASE __UI_PropertyGrid_Integer, __UI_PropertyGrid_Float: example$ = "10"
            CASE __UI_PropertyGrid_Choice: example$ = "1"
            CASE __UI_PropertyGrid_Toggle: example$ = "-1"
            CASE __UI_PropertyGrid_Button: _CONTINUE
            CASE ELSE: example$ = "some text"
        END SELECT
        EXIT DO
    LOOP

    r$ = "    '" + n$ + " is a property grid: its rows were built from the Rows property just before" + LF$
    r$ = r$ + "    'this event, so you can set their starting values here. Values are always text." + LF$
    IF LEN(example$) THEN
        r$ = r$ + "    'PropertyGrid_SetValue " + n$ + ", " + q$ + k$ + q$ + ", " + q$ + example$ + q$ + LF$
    END IF
    r$ = r$ + "    'See docs/PropertyGrid.md for everything a property grid can do." + LF$
    PropertyGridOnLoadHint$ = r$
END FUNCTION

''' @brief The block written in __UI_Click for buttons on property grid rows (empty when there are none).
FUNCTION PropertyGridClickBlock$
    DIM i AS LONG, r$, rows$, entry$, k$, item$, kind AS INTEGER, q$, LF$, pos1 AS LONG

    q$ = CHR$(34)
    LF$ = CHR$(10)
    FOR i = 1 TO UBOUND(PreviewControls)
        IF NOT IsPropertyGridFrame(i) THEN _CONTINUE
        rows$ = PropertyGridRowList$(i)
        DO
            pos1 = INSTR(rows$, LF$)
            IF pos1 = 0 THEN EXIT DO
            entry$ = LEFT$(rows$, pos1 - 1)
            rows$ = MID$(rows$, pos1 + 1)
            PropertyGridRowFields entry$, k$, kind, item$
            IF kind = __UI_PropertyGrid_Button THEN
                r$ = r$ + "        CASE " + q$ + k$ + q$ + " '" + RTRIM$(PreviewControls(i).Name) + LF$ + LF$
            END IF
        LOOP
    NEXT
    IF LEN(r$) = 0 THEN EXIT FUNCTION

    PropertyGridClickBlock$ = LF$ + "    'Buttons on property grid rows aren't listed above: the grid creates them when the" + LF$ + _
        "    'program starts. PropertyGrid_RowOf$(id) tells which row a clicked button is on." + LF$ + _
        "    SELECT CASE PropertyGrid_RowOf$(id)" + LF$ + r$ + "    END SELECT" + LF$
END FUNCTION

''' @brief Writes text to a file one line at a time, so line endings suit the system.
SUB PrintLines (FileNum AS INTEGER, Block$)
    DIM t$, p AS LONG
    t$ = Block$
    DO WHILE LEN(t$)
        p = INSTR(t$, CHR$(10))
        IF p = 0 THEN PRINT #FileNum, t$: EXIT DO
        PRINT #FileNum, LEFT$(t$, p - 1)
        t$ = MID$(t$, p + 1)
    LOOP
END SUB

'---------------------------------------------------------------------------------
FUNCTION OutsideQuotes%% (text$, position AS LONG)
    DIM quote%%
    DIM start AS LONG
    DIM i AS LONG

    start = _INSTRREV(position, text$, CHR$(10)) + 1
    quote%% = False
    FOR i = start TO position
        IF ASC(text$, i) = 34 THEN quote%% = NOT quote%%
        IF ASC(text$, i) = 10 THEN EXIT FOR
    NEXT
    OutsideQuotes%% = NOT quote%%
END FUNCTION

''' @brief _TRUE if a control in the preview belongs to a TabControl.
FUNCTION PreviewIsTabChild%% (i AS LONG)
    DIM j AS LONG
    IF LEN(PreviewParentIDS(i)) = 0 THEN EXIT FUNCTION
    FOR j = 1 TO UBOUND(PreviewControls)
        IF PreviewControls(j).ID > 0 _ANDALSO PreviewControls(j).Type = __UI_Type_TabControl _ANDALSO RTRIM$(PreviewControls(j).Name) = PreviewParentIDS(i) THEN
            PreviewIsTabChild = _TRUE
            EXIT FUNCTION
        END IF
    NEXT
END FUNCTION

''' @brief Applies a theme to the form in the preview and remembers it for the .frm file.
SUB SetPreviewTheme (themeName AS STRING)
    DIM b$
    PreviewTheme = themeName
    b$ = "SETTHEME>" + themeName + "<END>"
    Send Client, b$
    UpdateThemeMenu
END SUB

''' @brief Updates the bullets of the View > Theme menu items.
SUB UpdateThemeMenu
    DIM t AS STRING
    t = LCASE$(PreviewTheme)
    Control(ViewMenuThemeXP).Value = (t = "" OR t = "xp")
    Control(ViewMenuThemeLight).Value = (t = "light")
    Control(ViewMenuThemeDark).Value = (t = "dark")
    Control(ViewMenuThemeFile).Value = NOT (t = "" OR t = "xp" OR t = "light" OR t = "dark")
END SUB

''' @brief Opens the Theme Editor (with the form's theme file when it uses one) and waits for it to close.
SUB OpenThemeEditor
    DIM exe AS STRING, args AS STRING, t AS STRING

    $IF WIN THEN
        exe = "ThemeEditor.exe"
    $ELSE
        exe = "./ThemeEditor"
    $END IF

    IF NOT _FILEEXISTS(exe) THEN
        MessageBox "The Theme Editor was not found. Build it with the setup script for your OS (it is built together with the UiEditor).", UiEditorTitle$, MsgBox_OkOnly + MsgBox_Exclamation
        EXIT SUB
    END IF

    t = LCASE$(PreviewTheme)
    IF LEN(PreviewTheme) > 0 AND t <> "xp" AND t <> "light" AND t <> "dark" THEN
        IF _FILEEXISTS(PreviewTheme) THEN args = " " + CHR$(34) + PreviewTheme + CHR$(34)
    END IF

    'Wait for the Theme Editor to close; meanwhile the preview reloads the theme file whenever it is saved
    DIM b$
    b$ = "WATCHTHEME>" + MKI$(-1) + "<END>"
    Send Client, b$
    SHELL _HIDE exe + args
    b$ = "WATCHTHEME>" + MKI$(0) + "<END>"
    Send Client, b$
END SUB

FUNCTION PreviewName$ (i AS LONG)
    PreviewName$ = RTRIM$(__UI_TrimAt0$(PreviewControls(i).Name))
END FUNCTION

'The property of preview control i that's bound to the control named other$ ("" when not bound)
FUNCTION PreviewBoundProperty$ (i AS LONG, other$)
    DIM p AS LONG, n$, prop$
    p = 1
    DO WHILE p < LEN(PreviewBindings(i))
        n$ = MID$(PreviewBindings(i), p + 2, CVI(MID$(PreviewBindings(i), p, 2)))
        p = p + 2 + LEN(n$)
        prop$ = MID$(PreviewBindings(i), p + 2, CVI(MID$(PreviewBindings(i), p, 2)))
        p = p + 2 + LEN(prop$)
        IF n$ = other$ THEN PreviewBoundProperty$ = prop$: EXIT FUNCTION
    LOOP
END FUNCTION

'Anchor flags as code, e.g. "__UI_Anchor_Left OR __UI_Anchor_Right"
FUNCTION AnchorFlagsCode$ (Flags AS _BYTE)
    DIM a$
    IF (Flags AND __UI_Anchor_Left) THEN a$ = a$ + " OR __UI_Anchor_Left"
    IF (Flags AND __UI_Anchor_Top) THEN a$ = a$ + " OR __UI_Anchor_Top"
    IF (Flags AND __UI_Anchor_Right) THEN a$ = a$ + " OR __UI_Anchor_Right"
    IF (Flags AND __UI_Anchor_Bottom) THEN a$ = a$ + " OR __UI_Anchor_Bottom"
    AnchorFlagsCode$ = MID$(a$, 5)
END FUNCTION


'---------------------------------------------------------------------------------
'Anchor picker: a drawing of the selected control inside its parent, with a bar
'from each side of the control to the parent's edge. Lit bars are anchored edges;
'clicking a side of the drawing toggles that edge.

'The edge (__UI_Anchor_*) under the mouse, or 0 when it's over the control box or outside
FUNCTION AnchorPickerEdge&
    DIM mx AS SINGLE, my AS SINGLE, cx AS SINGLE, cy AS SINGLE, dx AS SINGLE, dy AS SINGLE
    IF __UI_HoveringID <> AnchorPicker OR Control(AnchorPicker).Hidden THEN EXIT FUNCTION
    mx = __UI_MouseLeft - Control(AnchorPicker).Left - Control(ControlToggles).Left
    my = __UI_MouseTop - Control(AnchorPicker).Top - Control(ControlToggles).Top
    cx = Control(AnchorPicker).Width / 2: cy = Control(AnchorPicker).Height / 2
    IF ABS(mx - cx) <= AnchorPickerBoxW / 2 AND ABS(my - cy) <= AnchorPickerBoxH / 2 THEN EXIT FUNCTION
    'Split the drawing along its diagonals: each quarter belongs to the side it touches
    dx = (mx - cx) / cx: dy = (my - cy) / cy
    IF ABS(dx) > ABS(dy) THEN
        IF dx < 0 THEN AnchorPickerEdge = __UI_Anchor_Left ELSE AnchorPickerEdge = __UI_Anchor_Right
    ELSE
        IF dy < 0 THEN AnchorPickerEdge = __UI_Anchor_Top ELSE AnchorPickerEdge = __UI_Anchor_Bottom
    END IF
END FUNCTION

'Anchors or releases one edge on every selected control
SUB ToggleAnchorEdge (Edge AS LONG)
    DIM Opposite AS LONG, b$, EdgeName$, OppositeName$
    IF Edge = 0 THEN EXIT SUB
    SELECT CASE Edge
        CASE __UI_Anchor_Left: Opposite = __UI_Anchor_Right
        CASE __UI_Anchor_Right: Opposite = __UI_Anchor_Left
        CASE __UI_Anchor_Top: Opposite = __UI_Anchor_Bottom
        CASE __UI_Anchor_Bottom: Opposite = __UI_Anchor_Top
    END SELECT
    IF (AnchorPickerFlags AND Edge) THEN
        IF (AnchorPickerFlags AND Opposite) = 0 THEN
            'A control always follows at least one side in each direction
            SELECT CASE Edge
                CASE __UI_Anchor_Left: EdgeName$ = "left": OppositeName$ = "right"
                CASE __UI_Anchor_Right: EdgeName$ = "right": OppositeName$ = "left"
                CASE __UI_Anchor_Top: EdgeName$ = "top": OppositeName$ = "bottom"
                CASE __UI_Anchor_Bottom: EdgeName$ = "bottom": OppositeName$ = "top"
            END SELECT
            Caption(StatusBar) = "To release the " + EdgeName$ + ", anchor the " + OppositeName$ + " first: a control always follows one of them."
            BlinkStatusBar = TIMER
            EXIT SUB
        END IF
        AnchorPickerFlags = AnchorPickerFlags AND NOT Edge
        b$ = MKI$(Edge) + MKI$(False)
    ELSE
        AnchorPickerFlags = AnchorPickerFlags OR Edge
        b$ = MKI$(Edge) + MKI$(True)
    END IF
    SendData b$, 49
    UpdateAnchorPicker
END SUB

'What the anchors do, in words
FUNCTION AnchorDescription$ (Flags AS LONG)
    DIM h AS LONG, v AS LONG, p$
    'h/v: 0 = stays, 1 = moves along, 2 = stretches
    IF (Flags AND __UI_Anchor_Right) THEN h = 1 - ((Flags AND __UI_Anchor_Left) <> 0)
    IF (Flags AND __UI_Anchor_Bottom) THEN v = 1 - ((Flags AND __UI_Anchor_Top) <> 0)

    p$ = "the form"
    IF TotalSelected > 0 _ANDALSO FirstSelected <= UBOUND(PreviewParentIDS) THEN
        IF LEN(PreviewParentIDS(FirstSelected)) THEN
            IF PreviewIsTabChild(FirstSelected) THEN p$ = "the tab control" ELSE p$ = "the frame"
        END IF
    END IF

    SELECT CASE h * 3 + v
        CASE 0: AnchorDescription$ = "Stays put when " + p$ + " is resized."
        CASE 1: AnchorDescription$ = "Sticks to the bottom of " + p$ + "."
        CASE 2: AnchorDescription$ = "Gets taller with " + p$ + "."
        CASE 3: AnchorDescription$ = "Sticks to the right side of " + p$ + "."
        CASE 4: AnchorDescription$ = "Sticks to the bottom-right corner of " + p$ + "."
        CASE 5: AnchorDescription$ = "Gets taller and sticks to the right of " + p$ + "."
        CASE 6: AnchorDescription$ = "Gets wider with " + p$ + "."
        CASE 7: AnchorDescription$ = "Gets wider and sticks to the bottom of " + p$ + "."
        CASE 8: AnchorDescription$ = "Grows with " + p$ + " in both directions."
    END SELECT
END FUNCTION

'Redraws the picker when what it shows has changed
SUB UpdateAnchorPicker
    STATIC LastFlags AS LONG, LastHover AS LONG, LastBack AS _UNSIGNED LONG, LastAccent AS _UNSIGNED LONG
    DIM Hover AS LONG, w AS LONG, h AS LONG, cx AS LONG, cy AS LONG
    DIM bl AS LONG, bt AS LONG, br AS LONG, bb AS LONG
    DIM Back AS _UNSIGNED LONG, Accent AS _UNSIGNED LONG, Faint AS _UNSIGNED LONG, BoxBack AS _UNSIGNED LONG

    Hover = AnchorPickerEdge
    Back = Control(ControlToggles).BackColor
    Accent = __UI_ThemeColor(__UI_ThemeColor_Accent)
    SetCaption AnchorInfoLB, AnchorDescription$(AnchorPickerFlags)

    IF Control(AnchorPicker).HelperCanvas = 0 THEN
        Control(AnchorPicker).HelperCanvas = _NEWIMAGE(Control(AnchorPicker).Width, Control(AnchorPicker).Height, 32)
    ELSEIF AnchorPickerFlags = LastFlags AND Hover = LastHover AND Back = LastBack AND Accent = LastAccent THEN
        EXIT SUB
    END IF
    LastFlags = AnchorPickerFlags: LastHover = Hover: LastBack = Back: LastAccent = Accent

    Faint = __UI_ThemeColor(__UI_ThemeColor_Border)
    BoxBack = __UI_ThemeColor(__UI_ThemeColor_InputBack)

    _DEST Control(AnchorPicker).HelperCanvas
    w = _WIDTH: h = _HEIGHT
    cx = w \ 2: cy = h \ 2
    bl = cx - AnchorPickerBoxW \ 2: br = bl + AnchorPickerBoxW - 1
    bt = cy - AnchorPickerBoxH \ 2: bb = bt + AnchorPickerBoxH - 1

    'The parent and the control
    LINE (0, 0)-(w - 1, h - 1), Back, BF
    LINE (0, 0)-(w - 1, h - 1), Faint, B
    LINE (bl, bt)-(br, bb), BoxBack, BF
    LINE (bl, bt)-(br, bb), Faint, B

    DrawAnchorBar 3, cy, bl - 2, cy, __UI_Anchor_Left, Hover, Accent, Faint
    DrawAnchorBar br + 2, cy, w - 4, cy, __UI_Anchor_Right, Hover, Accent, Faint
    DrawAnchorBar cx, 3, cx, bt - 2, __UI_Anchor_Top, Hover, Accent, Faint
    DrawAnchorBar cx, bb + 2, cx, h - 4, __UI_Anchor_Bottom, Hover, Accent, Faint

    _DEST 0
    Control(AnchorPicker).Redraw = True
END SUB

'One bar of the picker: solid and thick when anchored, dotted when not.
'The one under the mouse gets a soft band behind it, keeping its own look.
SUB DrawAnchorBar (x1 AS LONG, y1 AS LONG, x2 AS LONG, y2 AS LONG, Edge AS LONG, Hover AS LONG, Accent AS _UNSIGNED LONG, Faint AS _UNSIGNED LONG)
    DIM k AS LONG

    IF Hover = Edge THEN
        IF y1 = y2 THEN
            LINE (x1 - 2, y1 - 7)-(x2 + 2, y2 + 7), _RGBA32(_RED32(Accent), _GREEN32(Accent), _BLUE32(Accent), 45), BF
        ELSE
            LINE (x1 - 7, y1 - 2)-(x2 + 7, y2 + 2), _RGBA32(_RED32(Accent), _GREEN32(Accent), _BLUE32(Accent), 45), BF
        END IF
    END IF

    IF (AnchorPickerFlags AND Edge) THEN
        FOR k = -1 TO 1
            IF y1 = y2 THEN LINE (x1, y1 + k)-(x2, y2 + k), Accent ELSE LINE (x1 + k, y1)-(x2 + k, y2), Accent
        NEXT
        'A cap where the bar meets the parent's edge
        SELECT CASE Edge
            CASE __UI_Anchor_Left: LINE (x1, y1 - 5)-(x1 + 1, y1 + 5), Accent, BF
            CASE __UI_Anchor_Right: LINE (x2 - 1, y2 - 5)-(x2, y2 + 5), Accent, BF
            CASE __UI_Anchor_Top: LINE (x1 - 5, y1)-(x1 + 5, y1 + 1), Accent, BF
            CASE __UI_Anchor_Bottom: LINE (x2 - 5, y2 - 1)-(x2 + 5, y2), Accent, BF
        END SELECT
    ELSE
        LINE (x1, y1)-(x2, y2), Faint, , &HCCCC
    END IF
END SUB
