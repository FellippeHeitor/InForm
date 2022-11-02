OPTION _EXPLICIT
OPTION _EXPLICITARRAY

$ExeIcon:'.\resources\InForm.ico'

'Controls: --------------------------------------------------------------------
'Main form
Dim Shared UiEditor As Long
Dim Shared StatusBar As Long

'Menus
Dim Shared FileMenu As Long, EditMenu As Long, ViewMenu As Long
Dim Shared InsertMenu As Long, AlignMenu As Long, OptionsMenu As Long
Dim Shared HelpMenu As Long, FontSwitchMenu As Long

'Frames
Dim Shared Toolbox As Long, ColorMixer As Long
Dim Shared OpenFrame As Long, ZOrdering As Long
Dim Shared ControlProperties As Long, ControlToggles As Long
Dim Shared SetControlBinding As Long

'Menu items
Dim Shared FileMenuNew As Long, FileMenuOpen As Long
Dim Shared FileMenuSave As Long, FileMenuSaveAs As Long
Dim Shared FileMenuExit As Long

Dim Shared FileMenuRecent As Long
Dim Shared FileMenuRecent1 As Long
Dim Shared FileMenuRecent2 As Long
Dim Shared FileMenuRecent3 As Long
Dim Shared FileMenuRecent4 As Long
Dim Shared FileMenuRecent5 As Long
Dim Shared FileMenuRecent6 As Long
Dim Shared FileMenuRecent7 As Long
Dim Shared FileMenuRecent8 As Long
Dim Shared FileMenuRecent9 As Long

Dim Shared EditMenuUndo As Long, EditMenuRedo As Long, EditMenuCut As Long
Dim Shared EditMenuCopy As Long, EditMenuPaste As Long
Dim Shared EditMenuDelete As Long, EditMenuSelectAll As Long
Dim Shared EditMenuCP437 As Long, EditMenuCP1252 As Long
Dim Shared EditMenuConvertType As Long, EditMenuSetDefaultButton As Long
Dim Shared EditMenuRestoreDimensions As Long, EditMenuBindControls As Long
Dim Shared EditMenuAllowMinMax As Long, EditMenuZOrdering As Long

Dim Shared ViewMenuPreviewDetach As Long
Dim Shared ViewMenuShowPositionAndSize As Long
Dim Shared ViewMenuShowInvisibleControls As Long
Dim Shared ViewMenuPreview As Long, ViewMenuLoadedFonts As Long

Dim Shared InsertMenuMenuBar As Long, InsertMenuContextMenu As Long
Dim Shared InsertMenuMenuItem As Long

Dim Shared OptionsMenuSnapLines As Long
Dim Shared AlignMenuAlignLeft As Long
Dim Shared AlignMenuAlignRight As Long
Dim Shared AlignMenuAlignTops As Long
Dim Shared AlignMenuAlignBottoms As Long
Dim Shared AlignMenuAlignCentersV As Long
Dim Shared AlignMenuAlignCentersH As Long
Dim Shared AlignMenuAlignCenterV As Long
Dim Shared AlignMenuAlignCenterH As Long
Dim Shared AlignMenuDistributeV As Long
Dim Shared AlignMenuDistributeH As Long

Dim Shared OptionsMenuAutoName As Long, OptionsMenuSwapButtons As Long

Dim Shared HelpMenuHelp As Long, HelpMenuAbout As Long

Dim Shared FontSwitchMenuSwitch As Long

'Toolbox buttons
Dim Shared AddButton As Long, AddLabel As Long
Dim Shared AddTextBox As Long, AddNumericBox As Long
Dim Shared AddCheckBox As Long, AddRadioButton As Long
Dim Shared AddListBox As Long, AddDropdownList As Long
Dim Shared AddTrackBar As Long, AddProgressBar As Long
Dim Shared AddPictureBox As Long, AddFrame As Long
Dim Shared AddToggleSwitch As Long

'Control toggles
Dim Shared Stretch As Long, HasBorder As Long
Dim Shared ShowPercentage As Long, PasswordMaskCB As Long
Dim Shared WordWrap As Long, CanHaveFocus As Long
Dim Shared Disabled As Long, Transparent As Long
Dim Shared Hidden As Long, CenteredWindow As Long
Dim Shared Resizable As Long, AutoScroll As Long
Dim Shared AutoSize As Long, SizeTB As Long
Dim Shared HideTicks As Long, AutoPlayGif As Long
Dim Shared AddGifExtensionToggle As Long

'Open/Save dialog
Dim Shared DialogBG As Long, FileNameLB As Long
Dim Shared FileNameTextBox As Long, PathLB As Long
Dim Shared FilesLB As Long, FileList As Long
Dim Shared PathsLB As Long, DirList As Long
Dim Shared OpenBT As Long, SaveBT As Long, CancelBT As Long
Dim Shared ShowOnlyFrmbinFilesCB As Long, SaveFrmOnlyCB As Long

'Z-ordering dialog
Dim Shared ControlList As Long, UpBT As Long
Dim Shared DownBT As Long, CloseZOrderingBT As Long

'Set binding dialog
Dim Shared SourceControlLB As Long
Dim Shared SourceControlNameLB As Long
Dim Shared TargetControlLB As Long
Dim Shared TargetControlNameLB As Long
'DIM SHARED SwapBT AS LONG
Dim Shared SourcePropertyLB As Long
Dim Shared SourcePropertyList As Long
Dim Shared TargetPropertyLB As Long
Dim Shared TargetPropertyList As Long
Dim Shared BindBT As Long
Dim Shared CancelBindBT As Long

'Properties
Dim Shared TextAlignLB As Long, AlignOptions As Long
Dim Shared VerticalAlignLB As Long, VAlignOptions As Long
Dim Shared ColorPropertiesList As Long, ColorPreview As Long
Dim Shared Red As Long, RedValue As Long
Dim Shared Green As Long, GreenValue As Long
Dim Shared Blue As Long, BlueValue As Long
Dim Shared NameLB As Long, CaptionLB As Long
Dim Shared TextLB As Long, TopLB As Long
Dim Shared LeftLB As Long, WidthLB As Long
Dim Shared HeightLB As Long, FontLB As Long
Dim Shared TooltipLB As Long, ValueLB As Long
Dim Shared MinLB As Long, MaxLB As Long
Dim Shared IntervalLB As Long, MinIntervalLB As Long
Dim Shared PaddingLeftrightLB As Long, NameTB As Long
Dim Shared CaptionTB As Long, TextTB As Long
Dim Shared TopTB As Long, LeftTB As Long
Dim Shared WidthTB As Long, HeightTB As Long
Dim Shared FontTB As Long, TooltipTB As Long
Dim Shared ValueTB As Long, MinTB As Long
Dim Shared MaxTB As Long, IntervalTB As Long
Dim Shared MinIntervalTB As Long, PaddingTB As Long
Dim Shared MaskTB As Long, MaskLB As Long
Dim Shared BulletOptions As Long, BulletOptionsLB As Long
Dim Shared BooleanLB As Long, BooleanOptions As Long
Dim Shared FontListLB As Long, FontList As Long, FontSizeList
Dim Shared PasteListBT As Long, ContextMenuLB As Long
Dim Shared ContextMenuControlsList As Long
Dim Shared KeyboardComboLB As Long, KeyboardComboBT As Long
'------------------------------------------------------------------------------

'Other shared variables:
Dim Shared UiPreviewPID As Long, TotalSelected As Long, FirstSelected As Long
Dim Shared PreviewFormID As Long, PreviewSelectionRectangle As Integer
Dim Shared PreviewAttached As _Byte, AutoNameControls As _Byte
Dim Shared LastKeyPress As Double
Dim Shared UiEditorTitle$, Edited As _Byte, ZOrderingDialogOpen As _Byte
Dim Shared OpenDialogOpen As _Byte
Dim Shared PropertySent As _Byte, RevertEdit As _Byte, OldColor As _Unsigned Long
Dim Shared ColorPreviewWord$, BlinkStatusBar As Single, StatusBarBackColor As _Unsigned Long
Dim Shared InstanceHost As Long, InstanceClient As Long
Dim Shared HostPort As String, Host As Long, Client As Long
Dim Shared Stream$, FormDataReceived As _Byte, LastFormData$
Dim Shared prevScreenX As Integer, prevScreenY As Integer
Dim Shared UndoPointer As Integer, TotalUndoImages As Integer
Dim Shared totalBytesSent As _Unsigned _Integer64
Dim Shared RecentMenuItem(1 To 9) As Long, RecentListBuilt As _Byte
Dim Shared LoadedWithGifExtension As _Byte, AddGifExtension As _Byte
Dim Shared TotalGifLoaded As Long, SetBindingDialogOpen As _Byte
Dim Shared InitialControlSet As String
DIM SHARED Answer AS LONG

Type newInputBox
    ID As Long
    LabelID As Long
    Signal As Integer
    LastEdited As Single
    DataType As Integer
    Sent As _Byte
End Type

Const DT_Text = 1
Const DT_Integer = 2
Const DT_Float = 3

ReDim Shared PreviewCaptions(0) As String
ReDim Shared PreviewTexts(0) As String
ReDim Shared PreviewMasks(0) As String
ReDim Shared PreviewTips(0) As String
ReDim Shared PreviewFonts(0) As String
ReDim Shared PreviewActualFonts(0) As String
ReDim Shared PreviewControls(0) As __UI_ControlTYPE
ReDim Shared PreviewParentIDS(0) As String
ReDim Shared PreviewContextMenu(0) As String
ReDim Shared PreviewBoundTo(0) As String
ReDim Shared PreviewBoundProperty(0) As String
ReDim Shared PreviewKeyCombos(0) As String
ReDim Shared PreviewAnimatedGif(0) As _Byte
ReDim Shared PreviewAutoPlayGif(0) As _Byte
ReDim Shared zOrderIDs(0) As Long
ReDim Shared InputBox(1 To 100) As newInputBox
ReDim Shared Toggles(1 To 100) As Long
ReDim Shared InputBoxText(1 To 100) As String
Dim Shared PreviewDefaultButtonID As Long

Dim Shared HasFontList As _Byte, ShowFontList As _Byte
Dim Shared AttemptToShowFontList As _Byte, BypassShowFontList As _Byte
Dim Shared TotalFontsFound As Long
ReDim Shared FontFile(0) As String

DIM SHARED AS STRING QB64_EXE, QB64_DISPLAY

$If WIN Then
    Const PathSep$ = "\"
    IF _FILEEXISTS(".." + PathSep$ + "qb64pe.exe") THEN
        QB64_EXE = "qb64pe.exe"
        QB64_DISPLAY = "QB64/PE"
    ELSEIF _FILEEXISTS(".." + PathSep$ + "qb64.exe") THEN
        QB64_EXE = "qb64.exe"
        QB64_DISPLAY = "QB64"
    ELSE
        Answer = MessageBox("InForm aborted - Neither qb64pe.exe or qb64.exe executable found.", "", MsgBox_Ok + MsgBox_Critical)
        SYSTEM 1
    END IF
$Else
    CONST PathSep$ = "/"
    IF _FILEEXISTS(".." + PathSep$ + "qb64pe") THEN
        QB64_EXE = "qb64pe"
        QB64_DISPLAY = "QB64/PE"
    ELSEIF _FILEEXISTS(".." + PathSep$ + "qb64") THEN
        QB64_EXE = "qb64"
        QB64_DISPLAY = "QB64"
    ELSE
        Answer = MessageBox("InForm aborted - Neither qb64pe or qb64 executable found.", "", MsgBox_Ok + MsgBox_Critical)
        SYSTEM 1
    END IF
$End If

Dim Shared CurrentPath$, ThisFileName$

'CheckPreviewTimer = _FREETIMER
'ON TIMER(CheckPreviewTimer, .003) CheckPreview

UiEditorTitle$ = "InForm Designer"

$If WIN Then
    Declare Dynamic Library "kernel32"
        Function OpenProcess& (ByVal dwDesiredAccess As Long, Byval bInheritHandle As Long, Byval dwProcessId As Long)
        Function CloseHandle& (ByVal hObject As Long)
        Function GetExitCodeProcess& (ByVal hProcess As Long, lpExitCode As Long)
    End Declare

    Declare Dynamic Library "user32"
        Function SetForegroundWindow& (ByVal hWnd As Long)
    End Declare

    ''Registry routines taken from the Wiki: http://www.qb64.org/wiki/Windows_Libraries#Registered_Fonts
    ''Code courtesy of Michael Calkins
    ''winreg.h
    Const HKEY_CLASSES_ROOT = &H80000000~&
    Const HKEY_CURRENT_USER = &H80000001~&
    Const HKEY_LOCAL_MACHINE = &H80000002~&
    Const HKEY_USERS = &H80000003~&
    Const HKEY_PERFORMANCE_DATA = &H80000004~&
    Const HKEY_CURRENT_CONFIG = &H80000005~&
    Const HKEY_DYN_DATA = &H80000006~&
    Const REG_OPTION_VOLATILE = 1
    Const REG_OPTION_NON_VOLATILE = 0
    Const REG_CREATED_NEW_KEY = 1
    Const REG_OPENED_EXISTING_KEY = 2

    ''http://msdn.microsoft.com/en-us/library/ms724884(v=VS.85).aspx
    Const REG_NONE = 0
    Const REG_SZ = 1
    Const REG_EXPAND_SZ = 2
    Const REG_BINARY = 3
    Const REG_DWORD_LITTLE_ENDIAN = 4
    Const REG_DWORD = 4
    Const REG_DWORD_BIG_ENDIAN = 5
    Const REG_LINK = 6
    Const REG_MULTI_SZ = 7
    Const REG_RESOURCE_LIST = 8
    Const REG_FULL_RESOURCE_DESCRIPTOR = 9
    Const REG_RESOURCE_REQUIREMENTS_LIST = 10
    Const REG_QWORD_LITTLE_ENDIAN = 11
    Const REG_QWORD = 11
    Const REG_NOTIFY_CHANGE_NAME = 1
    Const REG_NOTIFY_CHANGE_ATTRIBUTES = 2
    Const REG_NOTIFY_CHANGE_LAST_SET = 4
    Const REG_NOTIFY_CHANGE_SECURITY = 8

    ''http://msdn.microsoft.com/en-us/library/ms724878(v=VS.85).aspx
    Const KEY_ALL_ACCESS = &HF003F&
    Const KEY_CREATE_LINK = &H0020&
    Const KEY_CREATE_SUB_KEY = &H0004&
    Const KEY_ENUMERATE_SUB_KEYS = &H0008&
    Const KEY_EXECUTE = &H20019&
    Const KEY_NOTIFY = &H0010&
    Const KEY_QUERY_VALUE = &H0001&
    Const KEY_READ = &H20019&
    Const KEY_SET_VALUE = &H0002&
    Const KEY_WOW64_32KEY = &H0200&
    Const KEY_WOW64_64KEY = &H0100&
    Const KEY_WRITE = &H20006&

    ''winerror.h
    ''http://msdn.microsoft.com/en-us/library/ms681382(v=VS.85).aspx
    Const ERROR_SUCCESS = 0
    Const ERROR_FILE_NOT_FOUND = &H2&
    Const ERROR_INVALID_HANDLE = &H6&
    Const ERROR_MORE_DATA = &HEA&
    Const ERROR_NO_MORE_ITEMS = &H103&

    Declare Dynamic Library "advapi32"
        Function RegOpenKeyExA& (ByVal hKey As _Offset, Byval lpSubKey As _Offset, Byval ulOptions As _Unsigned Long, Byval samDesired As _Unsigned Long, Byval phkResult As _Offset)
        Function RegCloseKey& (ByVal hKey As _Offset)
        Function RegEnumValueA& (ByVal hKey As _Offset, Byval dwIndex As _Unsigned Long, Byval lpValueName As _Offset, Byval lpcchValueName As _Offset, Byval lpReserved As _Offset, Byval lpType As _Offset, Byval lpData As _Offset, Byval lpcbData As _Offset)
    End Declare
$Else
        DECLARE LIBRARY
        FUNCTION PROCESS_CLOSED& ALIAS kill (BYVAL pid AS INTEGER, BYVAL signal AS INTEGER)
        END DECLARE
$End If

'$include:'ini.bi'
'$include:'InForm.bi'
'$include:'xp.uitheme'
'$include:'UiEditor.frm'
'$include:'ini.bm'
'$include:'extensions/download.bas'

'Event procedures: ---------------------------------------------------------------
Sub __UI_Click (id As Long)
    Dim Answer As _Byte, Dummy As Long, b$
    Static LastClick#, LastClickedID As Long

    SendSignal -8

    Select EveryCase id
        Case AlignMenuAlignLeft: Dummy = 201
        Case AlignMenuAlignRight: Dummy = 202
        Case AlignMenuAlignTops: Dummy = 203
        Case AlignMenuAlignBottoms: Dummy = 204
        Case AlignMenuAlignCentersV: Dummy = 205
        Case AlignMenuAlignCentersH: Dummy = 206
        Case AlignMenuAlignCenterV: Dummy = 207
        Case AlignMenuAlignCenterH: Dummy = 208
        Case AlignMenuDistributeV: Dummy = 209
        Case AlignMenuDistributeH: Dummy = 210
        CASE AlignMenuAlignLeft, AlignMenuAlignRight, AlignMenuAlignTops, _
             AlignMenuAlignBottoms, AlignMenuAlignCentersV, AlignMenuAlignCentersH, _
             AlignMenuAlignCenterV, AlignMenuAlignCenterH, AlignMenuDistributeV, _
             AlignMenuDistributeH
            b$ = MKI$(0)
            SendData b$, Dummy
        Case OptionsMenuAutoName
            AutoNameControls = Not AutoNameControls
            Control(id).Value = AutoNameControls
            SaveSettings
        Case EditMenuConvertType
            b$ = MKI$(0)
            SendData b$, 225
        Case EditMenuSetDefaultButton
            SendSignal -6
        Case EditMenuRestoreDimensions
            SendSignal -7
        Case OptionsMenuSwapButtons
            __UI_MouseButtonsSwap = Not __UI_MouseButtonsSwap
            Control(id).Value = __UI_MouseButtonsSwap
            SaveSettings
        Case OptionsMenuSnapLines
            __UI_SnapLines = Not __UI_SnapLines
            Control(id).Value = __UI_SnapLines
            SaveSettings
        Case InsertMenuMenuBar
            b$ = "NEWCONTROL>" + MKI$(__UI_Type_MenuBar) + "<END>"
            Send Client, b$
        Case InsertMenuMenuItem
            b$ = "NEWCONTROL>" + MKI$(__UI_Type_MenuItem) + "<END>"
            Send Client, b$
        Case InsertMenuContextMenu
            b$ = "NEWCONTROL>" + MKI$(__UI_Type_ContextMenu) + "<END>"
            Send Client, b$
        Case ViewMenuPreviewDetach
            PreviewAttached = Not PreviewAttached
            Control(id).Value = PreviewAttached
            SaveSettings
        Case AddButton: Dummy = __UI_Type_Button
        Case AddLabel: Dummy = __UI_Type_Label
        Case AddTextBox: Dummy = __UI_Type_TextBox
        Case AddCheckBox: Dummy = __UI_Type_CheckBox
        Case AddRadioButton: Dummy = __UI_Type_RadioButton
        Case AddListBox: Dummy = __UI_Type_ListBox
        Case AddDropdownList: Dummy = __UI_Type_DropdownList
        Case AddTrackBar: Dummy = __UI_Type_TrackBar
        Case AddProgressBar: Dummy = __UI_Type_ProgressBar
        Case AddPictureBox: Dummy = __UI_Type_PictureBox
        Case AddFrame: Dummy = __UI_Type_Frame
        Case AddToggleSwitch: Dummy = __UI_Type_ToggleSwitch
        CASE AddButton, AddLabel, AddTextBox, AddCheckBox, _
             AddRadioButton, AddListBox, AddDropdownList, _
             AddTrackBar, AddProgressBar, AddPictureBox, AddFrame, _
             AddToggleSwitch
            b$ = "NEWCONTROL>" + MKI$(Dummy) + "<END>"
            Send Client, b$
        Case AddNumericBox
            b$ = MKI$(0)
            SendData b$, 222
        Case Stretch
            b$ = MKI$(Control(id).Value)
            SendData b$, 14
        Case HasBorder
            b$ = MKI$(Control(id).Value)
            SendData b$, 15
        Case Transparent
            b$ = MKI$(Control(Transparent).Value)
            SendData b$, 28
        Case ShowPercentage
            b$ = MKI$(Control(id).Value)
            SendData b$, 16
        Case WordWrap
            b$ = MKI$(Control(id).Value)
            SendData b$, 17

            'Also: disable autosize
            If Control(id).Value Then
                b$ = MKI$(0)
                SendData b$, 39
            End If
        Case CanHaveFocus
            b$ = MKI$(Control(id).Value)
            SendData b$, 18
        Case ColorPreview
            _Clipboard$ = ColorPreviewWord$
        Case Disabled
            b$ = MKI$(Control(id).Value)
            SendData b$, 19
        Case Hidden
            b$ = MKI$(Control(id).Value)
            SendData b$, 20
        Case CenteredWindow
            b$ = MKI$(Control(id).Value)
            SendData b$, 21
        Case Resizable
            b$ = MKI$(Control(id).Value)
            SendData b$, 29
        Case PasswordMaskCB
            b$ = MKI$(Control(id).Value)
            SendData b$, 33
        Case AutoScroll
            b$ = MKI$(Control(id).Value)
            SendData b$, 38
        Case AutoSize
            b$ = MKI$(Control(id).Value)
            SendData b$, 39
        Case HideTicks
            b$ = MKI$(Control(id).Value)
            SendData b$, 42
        Case AutoPlayGif
            b$ = MKI$(Control(id).Value)
            SendData b$, 44
        Case AddGifExtensionToggle
            If Control(AddGifExtensionToggle).Value = False And TotalGifLoaded > 0 Then
                Answer = MessageBox("Removing the GIF extension will load the existing animations as static frames. Proceed?", "", MsgBox_YesNo + MsgBox_Question)
                If Answer = MsgBox_No Then
                    Control(AddGifExtensionToggle).Value = True
                Else
                    b$ = "PAUSEALLGIF>" + "<END>"
                    Send Client, b$
                End If
            End If
        Case ViewMenuPreview
            $If WIN Then
                Shell _DontWait ".\UiEditorPreview.exe " + HostPort
            $Else
                    SHELL _DONTWAIT "./UiEditorPreview " + HostPort
            $End If
        Case ViewMenuLoadedFonts
            Dim Temp$
            Temp$ = "These fonts are currently in use in your form:" + Chr$(10)
            For Dummy = 1 To UBound(PreviewFonts)
                If Len(PreviewFonts(Dummy)) Then
                    Temp$ = Temp$ + Chr$(10)
                    Temp$ = Temp$ + PreviewFonts(Dummy)
                End If
            Next
            If Len(Temp$) Then
                Answer = MessageBox(Temp$, "Loaded fonts", MsgBox_OkOnly + MsgBox_Information)
            Else
                Answer = MessageBox("There are no fonts loaded.", "", MsgBox_OkOnly + MsgBox_Critical)
            End If
        Case FileMenuNew
            If Edited Then
                $If WIN Then
                    Answer = MessageBox("Save the current form?", "", MsgBox_YesNoCancel + MsgBox_Question)
                $Else
                        Answer = MessageBox("Save the current form?", "", MsgBox_YesNo + MsgBox_Question)
                $End If
                If Answer = MsgBox_Cancel Then
                    Exit Sub
                ElseIf Answer = MsgBox_Yes Then
                    SaveForm False, False
                End If
            End If

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
        Case FileMenuSave
            If Len(ThisFileName$) Then
                SaveForm True, False
            Else
                GoTo SaveAs
            End If
        Case FileMenuSaveAs
            SaveAs:
            'Refresh the file list control's contents
            Dim TotalFiles%
            If CurrentPath$ = "" Then CurrentPath$ = _StartDir$
            Text(FileList) = idezfilelist$(CurrentPath$, Control(ShowOnlyFrmbinFilesCB).Value + 1, 1, TotalFiles%)
            Control(FileList).Max = TotalFiles%
            Control(FileList).LastVisibleItem = 0 'Reset it so it's recalculated

            Control(DialogBG).Left = 0: Control(DialogBG).Top = 0
            Control(OpenFrame).Left = 18: Control(OpenFrame).Top = 40
            Caption(OpenFrame) = "Save as"
            Control(SaveBT).Hidden = False
            Control(OpenBT).Hidden = True
            Control(SaveFrmOnlyCB).Hidden = False
            Control(ShowOnlyFrmbinFilesCB).Hidden = True
            Control(SaveFrmOnlyCB).Value = False
            OpenDialogOpen = True
            Caption(StatusBar) = "Specify the name under which to save the current form..."
            __UI_Focus = FileNameTextBox
            If Len(ThisFileName$) Then
                Text(FileNameTextBox) = ThisFileName$
            Else
                Text(FileNameTextBox) = ""
            End If
            If Len(Text(FileNameTextBox)) Then
                Control(FileNameTextBox).SelectionStart = 0
                Control(FileNameTextBox).Cursor = Len(Text(FileNameTextBox))
                Control(FileNameTextBox).TextIsSelected = True
            End If
            __UI_ForceRedraw = True
        Case SaveBT
            SaveFile:
            If OpenDialogOpen Then
                Dim FileToOpen$, FreeFileNum As Integer
                FileToOpen$ = CurrentPath$ + PathSep$ + Text(FileNameTextBox)
                ThisFileName$ = LTrim$(RTrim$(Text(FileNameTextBox)))
                If ThisFileName$ = "" Then Exit Sub
                If UCase$(Right$(ThisFileName$, 4)) <> ".FRM" Then
                    ThisFileName$ = ThisFileName$ + ".frm"
                End If
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
                SaveForm True, Control(SaveFrmOnlyCB).Value
            End If
        Case HelpMenuAbout
            Dim isBeta$
            If __UI_VersionIsBeta Then isBeta$ = " Beta Version" Else isBeta$ = ""
			Answer = MessageBox("InForm GUI for QB64 - Created by Fellippe Heitor (2016-2021)\n\n" + UiEditorTitle$ + " " + __UI_Version + " (build" + Str$(__UI_VersionNumber) + isBeta$ + ")\nby George McGinn (gbytes58@gmail.com)\n   Samuel Gomes\n\nGitHub: https://github.com/a740g/InForm\n\nContact: gbytes58@gmail.com", "About", MsgBox_OkOnly + MsgBox_Information)
        Case HelpMenuHelp
            Answer = MessageBox("Design a form and export the resulting code to generate an event-driven QB64 program.", "What's all this?", MsgBox_OkOnly + MsgBox_Information)
        Case FileMenuExit
            If Edited Then
                $If WIN Then
                    Answer = MessageBox("Save the current form before leaving?", "", MsgBox_YesNoCancel + MsgBox_Question)
                $Else
                        Answer = MessageBox("Save the current form before leaving?", "", MsgBox_YesNo + MsgBox_Question)
                $End If
                If Answer = MsgBox_Cancel Then
                    Exit Sub
                ElseIf Answer = MsgBox_Yes Then
                    SaveForm False, False
                End If
            End If
            $IF WIN THEN 
    	        IF _FileExists("..\UiEditorPreview.frmbin") THEN Kill "..\UiEditorPreview.frmbin"            
            $ELSE 
			    IF _FileExists("UiEditorPreview.frmbin") Then Kill "UiEditorPreview.frmbin"
            $END IF
            System
        Case EditMenuZOrdering
            'Fill the list:
            Caption(StatusBar) = "Editing z-ordering/tab ordering"
            Dim j As Long, i As Long
            Static Moving As _Byte
            ReDim _Preserve zOrderIDs(1 To UBound(PreviewControls)) As Long
            ReloadZList:
            ResetList ControlList
            For i = 1 To UBound(PreviewControls)
                Select Case PreviewControls(i).Type
                    Case 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 14, 15, 18
                        j = j + 1
                        zOrderIDs(j) = i
                        AddItem ControlList, __UI_Type(PreviewControls(i).Type).Name + RTrim$(PreviewControls(i).Name)
                End Select
            Next
            If Moving Then Return
            Control(DialogBG).Left = 0: Control(DialogBG).Top = 0
            Control(ZOrdering).Left = 18: Control(ZOrdering).Top = 40
            __UI_Focus = ControlList
            ZOrderingDialogOpen = True
        Case EditMenuBindControls
            'Get controls' names and bound properties
            Dim CurrentSource$
            j = 0
            For i = 1 To UBound(PreviewControls)
                If PreviewControls(i).ControlIsSelected Then
                    j = j + 1
                    If j = 1 Then
                        Caption(SourceControlNameLB) = RTrim$(PreviewControls(i).Name)
                        CurrentSource$ = PreviewBoundTo(i)
                        If Len(PreviewBoundProperty(i)) = 0 Then
                            Dummy = SelectItem(SourcePropertyList, "Value")
                        Else
                            Dummy = SelectItem(SourcePropertyList, PreviewBoundProperty(i))
                        End If
                    End If
                    If j = 2 Then
                        Caption(TargetControlNameLB) = RTrim$(PreviewControls(i).Name)
                        If Len(PreviewBoundProperty(i)) = 0 Then
                            Dummy = SelectItem(TargetPropertyList, "Value")
                        Else
                            Dummy = SelectItem(TargetPropertyList, PreviewBoundProperty(i))
                        End If
                        Exit For
                    End If
                End If
            Next

            If CurrentSource$ = Caption(TargetControlNameLB) Then
                Caption(BindBT) = "Rebind"
                Caption(CancelBindBT) = "Unbind"
            Else
                Caption(BindBT) = "Bind"
                Caption(CancelBindBT) = "Cancel"
            End If

            Caption(StatusBar) = "Defining control bindings"
            Control(DialogBG).Left = 0: Control(DialogBG).Top = 0
            Control(SetControlBinding).Left = 83: Control(SetControlBinding).Top = 169
            __UI_Focus = SourcePropertyList
            SetBindingDialogOpen = True
        'CASE SwapBT
            '    SWAP Caption(SourceControlNameLB), Caption(TargetControlNameLB)
            '    SWAP Control(SourcePropertyList).Value, Control(TargetPropertyList).Value
        Case BindBT
            Control(DialogBG).Left = -600: Control(DialogBG).Top = -600
            Control(SetControlBinding).Left = -600: Control(SetControlBinding).Top = -600
            SetBindingDialogOpen = False
            b$ = "BINDCONTROLS>"
            b$ = b$ + MKL$(Len(Caption(SourceControlNameLB))) + Caption(SourceControlNameLB)
            b$ = b$ + MKL$(Len(Caption(TargetControlNameLB))) + Caption(TargetControlNameLB)
            b$ = b$ + MKL$(Len(GetItem(SourcePropertyList, Control(SourcePropertyList).Value)))
            b$ = b$ + GetItem(SourcePropertyList, Control(SourcePropertyList).Value)
            b$ = b$ + MKL$(Len(GetItem(TargetPropertyList, Control(TargetPropertyList).Value)))
            b$ = b$ + GetItem(TargetPropertyList, Control(TargetPropertyList).Value)
            b$ = b$ + "<END>"
            Send Client, b$
        Case CancelBindBT
            Control(DialogBG).Left = -600: Control(DialogBG).Top = -600
            Control(SetControlBinding).Left = -600: Control(SetControlBinding).Top = -600
            SetBindingDialogOpen = False
            If Caption(CancelBindBT) = "Unbind" Then
                b$ = "UNBINDCONTROLS>"
                b$ = b$ + Caption(SourceControlNameLB)
                b$ = b$ + "<END>"
                Send Client, b$
            End If
        Case CloseZOrderingBT
            Caption(StatusBar) = "Ready."
            Control(DialogBG).Left = -600: Control(DialogBG).Top = -600
            Control(ZOrdering).Left = -600: Control(ZOrdering).Top = -600
            __UI_Focus = 0
            ZOrderingDialogOpen = False
        Case UpBT
            Dim PrevListValue As Long
            PrevListValue = Control(ControlList).Value
            b$ = MKL$(zOrderIDs(Control(ControlList).Value)) + MKL$(zOrderIDs(Control(ControlList).Value - 1))
            SendData b$, 211
            _Delay .1
            Moving = True: GoSub ReloadZList
            Moving = False
            Control(ControlList).Value = PrevListValue - 1
            __UI_Focus = ControlList
            __UI_ValueChanged ControlList
        Case DownBT
            PrevListValue = Control(ControlList).Value
            b$ = MKL$(zOrderIDs(Control(ControlList).Value)) + MKL$(zOrderIDs(Control(ControlList).Value + 1))
            SendData b$, 212
            _Delay .1
            Moving = True: GoSub ReloadZList
            Moving = False
            Control(ControlList).Value = PrevListValue + 1
            __UI_Focus = ControlList
            __UI_ValueChanged ControlList
        Case FileMenuOpen
            If Edited Then
                $If WIN Then
                    Answer = MessageBox("Save the current form?", "", MsgBox_YesNoCancel + MsgBox_Question)
                $Else
                        Answer = MessageBox("Save the current form?", "", MsgBox_YesNo + MsgBox_Question)
                $End If
                If Answer = MsgBox_Cancel Then
                    Exit Sub
                ElseIf Answer = MsgBox_Yes Then
                    SaveForm False, False
                End If
            End If

            'Hide the preview
            SendSignal -2

            'Refresh the file list control's contents
            If CurrentPath$ = "" Then CurrentPath$ = _StartDir$
            Text(FileList) = idezfilelist$(CurrentPath$, Control(ShowOnlyFrmbinFilesCB).Value + 1, 1, TotalFiles%)
            Control(FileList).Max = TotalFiles%
            Control(FileList).LastVisibleItem = 0 'Reset it so it's recalculated

            Control(DialogBG).Left = 0: Control(DialogBG).Top = 0
            Control(OpenFrame).Left = 18: Control(OpenFrame).Top = 40
            Caption(OpenFrame) = "Open"
            Control(SaveBT).Hidden = True
            Control(OpenBT).Hidden = False
            Control(SaveFrmOnlyCB).Hidden = True
            Control(ShowOnlyFrmbinFilesCB).Hidden = False
            OpenDialogOpen = True
            Caption(StatusBar) = "Select a form file to load..."
            __UI_Focus = FileNameTextBox
            If Len(Text(FileNameTextBox)) > 0 Then
                Control(FileNameTextBox).SelectionStart = 0
                Control(FileNameTextBox).Cursor = Len(Text(FileNameTextBox))
                Control(FileNameTextBox).TextIsSelected = True
            End If
            __UI_ForceRedraw = True
        Case CancelBT
            Text(FileNameTextBox) = ""
            Control(DialogBG).Left = -600: Control(DialogBG).Top = -600
            Control(OpenFrame).Left = -600: Control(OpenFrame).Top = -600
            OpenDialogOpen = False
            Caption(StatusBar) = "Ready."
            'Show the preview
            SendSignal -3

            __UI_Focus = 0
            __UI_ForceRedraw = True
        CASE FileMenuRecent1, FileMenuRecent2, FileMenuRecent3, _
             FileMenuRecent4, FileMenuRecent5, FileMenuRecent6, _
             FileMenuRecent7, FileMenuRecent8, FileMenuRecent9
            Dim RecentToOpen$
            RecentToOpen$ = ToolTip(id)
            If _FileExists(RecentToOpen$) Then
                If InStr(RecentToOpen$, "/") > 0 Or InStr(RecentToOpen$, "\") > 0 Then
                    For i = Len(RecentToOpen$) To 1 Step -1
                        If Asc(RecentToOpen$, i) = 92 Or Asc(RecentToOpen$, i) = 47 Then
                            CurrentPath$ = Left$(RecentToOpen$, i - 1)
                            RecentToOpen$ = Mid$(RecentToOpen$, i + 1)
                            Exit For
                        End If
                    Next
                End If

                If Edited Then
                    $If WIN Then
                        Answer = MessageBox("Save the current form?", "", MsgBox_YesNoCancel + MsgBox_Question)
                    $Else
                            Answer = MessageBox("Save the current form?", "", MsgBox_YesNo + MsgBox_Question)
                    $End If
                    If Answer = MsgBox_Cancel Then
                        Exit Sub
                    ElseIf Answer = MsgBox_Yes Then
                        SaveForm False, False
                    End If
                End If

                Text(FileNameTextBox) = RecentToOpen$
                OpenDialogOpen = True
                __UI_Click OpenBT
            Else
                Answer = MessageBox("File not found.", "", MsgBox_OkOnly + MsgBox_Critical)
                RemoveFromRecentList RecentToOpen$
            End If
        Case OpenBT
            OpenFile:
            If OpenDialogOpen Then
                FileToOpen$ = CurrentPath$ + PathSep$ + Text(FileNameTextBox)
                If _FileExists(FileToOpen$) Then
                    LoadedWithGifExtension = False
                    If _FileExists(Left$(FileToOpen$, Len(FileToOpen$) - 4) + ".bas") Then
                        FreeFileNum = FreeFile
                        Open Left$(FileToOpen$, Len(FileToOpen$) - 4) + ".bas" For Binary As #FreeFileNum
                        b$ = Space$(LOF(FreeFileNum))
                        Get #FreeFileNum, 1, b$
                        Close #FreeFileNum
                        If InStr(b$, Chr$(10) + "'$INCLUDE:'InForm\extensions\gifplay.bm'") > 0 Then
                            LoadedWithGifExtension = True
                        End If
                    End If

                    AddToRecentList FileToOpen$
                    ThisFileName$ = Text(FileNameTextBox)

                    'Send open command
                    If LoadedWithGifExtension = False Then
                        LoadedWithGifExtension = 1 'Set to 1 to check whether a loaded file already had the gif extension
                        Control(AddGifExtensionToggle).Value = False
                    Else
                        Control(AddGifExtensionToggle).Value = True
                    End If
                    AddGifExtension = False
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
                    OpenDialogOpen = False
                    Caption(StatusBar) = "Ready."
                    __UI_Focus = 0
                    Edited = False
                    LastFormData$ = ""
                    Stream$ = ""
                    FormDataReceived = False
                    InitialControlSet = ""
                Else
                    Answer = MessageBox("File not found.", "", MsgBox_OkOnly + MsgBox_Critical)
                    Control(FileList).Value = 0
                End If
            End If
        Case FileList
            Text(FileNameTextBox) = GetItem(FileList, Control(FileList).Value)
            Control(DirList).Value = 0
            If Control(FileList).HoveringVScrollbarButton = 0 And LastClickedID = id And Timer - LastClick# < .3 Then 'Double click
                If Len(Text(FileNameTextBox)) > 0 Then
                    If Caption(OpenFrame) = "Open" Then
                        GoTo OpenFile
                    Else
                        GoTo SaveFile
                    End If
                End If
            End If
        Case DirList
            Text(FileNameTextBox) = GetItem(DirList, Control(DirList).Value)
            Control(FileList).Value = 0
            If LastClickedID = id And Timer - LastClick# < .3 Then 'Double click
                CurrentPath$ = idezchangepath(CurrentPath$, Text(FileNameTextBox))
                Caption(PathLB) = "Path: " + CurrentPath$
                Text(DirList) = idezpathlist$(CurrentPath$, TotalFiles%)
                Control(DirList).Max = TotalFiles%
                Control(DirList).LastVisibleItem = 0 'Reset it so it's recalculated
                Control(DirList).Value = 0
                GoTo ReloadList
            End If
        Case ShowOnlyFrmbinFilesCB
            ReloadList:
            Text(FileList) = idezfilelist$(CurrentPath$, Control(ShowOnlyFrmbinFilesCB).Value + 1, 1, TotalFiles%)
            Control(FileList).Max = TotalFiles%
            Control(FileList).FirstVisibleLine = 1
            Control(FileList).InputViewStart = 1
            Control(FileList).Value = 0
            Control(FileList).LastVisibleItem = 0 'Reset it so it's recalculated
        Case EditMenuUndo
            SendSignal 214
        Case EditMenuRedo
            SendSignal 215
        Case EditMenuCopy
            b$ = MKI$(0)
            SendData b$, 217
        Case EditMenuPaste
            b$ = MKI$(0)
            SendData b$, 218
        Case EditMenuCut
            b$ = MKI$(0)
            SendData b$, 219
        Case EditMenuDelete
            b$ = MKI$(0)
            SendData b$, 220
        Case EditMenuSelectAll
            b$ = MKI$(0)
            SendData b$, 221
        Case EditMenuAllowMinMax
            b$ = MKI$(0)
            SendData b$, 223
        Case EditMenuCP437
            b$ = MKL$(437)
            SendData b$, 34 'Encoding
        Case EditMenuCP1252
            b$ = MKL$(1252)
            SendData b$, 34 'Encoding
        Case ViewMenuShowPositionAndSize
            __UI_ShowPositionAndSize = Not __UI_ShowPositionAndSize
            Control(id).Value = __UI_ShowPositionAndSize
            SaveSettings
        Case ViewMenuShowInvisibleControls
            __UI_ShowInvisibleControls = Not __UI_ShowInvisibleControls
            Control(id).Value = __UI_ShowInvisibleControls
            SaveSettings
        Case FontSwitchMenuSwitch, FontLB, FontListLB
            AttemptToShowFontList = (ShowFontList = False Or BypassShowFontList = True)
            ShowFontList = Not ShowFontList
            If id <> FontSwitchMenuSwitch Then __UI_MouseEnter FontLB
            SaveSettings
            __UI_ForceRedraw = True
        Case PasteListBT
            Dim Clip$
            Clip$ = _Clipboard$
            Clip$ = Replace$(Clip$, Chr$(13) + Chr$(10), Chr$(10), 0, 0)
            Clip$ = Replace$(Clip$, Chr$(10), "\n", 0, 0)

            If PreviewControls(FirstSelected).Type = __UI_Type_ListBox Or PreviewControls(FirstSelected).Type = __UI_Type_DropdownList Then
                Dummy = TextTB
            ElseIf (PreviewControls(FirstSelected).Type = __UI_Type_Label And PreviewControls(FirstSelected).WordWrap = True) Then
                Dummy = CaptionTB
            End If

            Text(Dummy) = Clip$
            __UI_Focus = Dummy
            Control(Dummy).Cursor = Len(Text(Dummy))
            Control(Dummy).TextIsSelected = False
        Case KeyboardComboBT
            __UI_BypassKeyCombos = True
            Caption(KeyboardComboBT) = Chr$(7) + " hit a key combo... (ESC to clear)"
            ToolTip(KeyboardComboBT) = "Press a key combination to assign to the selected control"
    End Select

    LastClickedID = id
    LastClick# = Timer
    If Caption(StatusBar) = "" Then Caption(StatusBar) = "Ready."
End Sub

Sub __UI_MouseEnter (id As Long)
    Select Case id
        Case FileMenuNew
            Caption(StatusBar) = "Creates a new project."
        Case FileMenuOpen
            Caption(StatusBar) = "Loads an existing project from disk."
        Case FileMenuExit
            Caption(StatusBar) = "Exits the editor."
        Case FileMenuSave
            Caption(StatusBar) = "Saves the current project to disk."
        Case FileMenuSaveAs
            Caption(StatusBar) = "Saves a copy of the current project to disk."
        Case EditMenuUndo
            Caption(StatusBar) = "Undoes the last edit."
        Case EditMenuRedo
            Caption(StatusBar) = "Redoes the last undone edit."
        Case EditMenuCut
            Caption(StatusBar) = "Removes the selected controls and copies them to the Clipboard."
        Case EditMenuCopy
            Caption(StatusBar) = "Copies the selected controls to the Clipboard."
        Case EditMenuPaste
            Caption(StatusBar) = "Inserts controls previously cut or copied from the Clipboard."
        Case EditMenuDelete
            Caption(StatusBar) = "Removes the selected controls."
        Case EditMenuSelectAll
            Caption(StatusBar) = "Selects all controls."
        Case EditMenuCP437
            Caption(StatusBar) = "Applies code page 437 to the current form."
        Case EditMenuCP1252
            Caption(StatusBar) = "Applies code page 1252 to the current form."
        Case EditMenuConvertType
            Caption(StatusBar) = "Converts this control's type into another similar in functionality."
        Case EditMenuSetDefaultButton
            Caption(StatusBar) = "Makes the currently selected button the default button."
        Case EditMenuRestoreDimensions
            Caption(StatusBar) = "Makes this control have the same dimensions as the loaded image."
        Case EditMenuAllowMinMax
            Caption(StatusBar) = "Enables and validates the .Min and .Max properties for NumericTextBox controls."
        Case EditMenuZOrdering
            Caption(StatusBar) = "Allows you to change tab-order/z-ordering of controls."
        Case ViewMenuPreviewDetach
            Caption(StatusBar) = "Toggles whether the preview form will be moved with the editor."
        Case ViewMenuShowPositionAndSize
            Caption(StatusBar) = "Toggles whether size and position indicators will be shown in the preview."
        Case ViewMenuShowInvisibleControls
            Caption(StatusBar) = "Show or hide invisible controls and binding indicators in the preview dialog."
        Case ViewMenuPreview
            Caption(StatusBar) = "Launches the preview window in case it's been closed accidentaly."
        Case ViewMenuLoadedFonts
            Caption(StatusBar) = "Shows a list of all fonts in use in the current form."
        Case InsertMenuMenuBar
            Caption(StatusBar) = "Inserts a new MenuBar control."
        Case InsertMenuMenuItem
            Caption(StatusBar) = "Inserts a new MenuItem control in the currently selected menu panel."
        Case OptionsMenuSnapLines
            Caption(StatusBar) = "Toggles whether controls edges are automatically snapped to others."
        Case OptionsMenuAutoName
            Caption(StatusBar) = "Automatically sets control names based on caption and type"
        Case OptionsMenuSwapButtons
            Caption(StatusBar) = "Toggles left/right mouse buttons."
        Case FontLB, FontListLB
            Control(FontLB).BackColor = Darken(__UI_DefaultColor(__UI_Type_Form, 2), 90)
            Control(FontListLB).BackColor = Darken(__UI_DefaultColor(__UI_Type_Form, 2), 90)
            Caption(FontLB) = "Font (toggle)"
            Caption(FontListLB) = "Font (toggle)"
        Case Else
            If Control(id).Type = __UI_Type_MenuItem Or Control(id).Type = __UI_Type_MenuBar Then
                Caption(StatusBar) = ""
            End If
    End Select
End Sub

Sub __UI_MouseLeave (id As Long)
    Select Case id
        Case FontLB, FontListLB
            Control(FontLB).BackColor = __UI_DefaultColor(__UI_Type_Form, 2)
            Control(FontListLB).BackColor = __UI_DefaultColor(__UI_Type_Form, 2)
            Caption(FontLB) = "Font"
            Caption(FontListLB) = "Font"
    End Select
End Sub

Sub __UI_FocusIn (id As Long)
    Select Case id
        Case NameTB, CaptionTB, TextTB, MaskTB, TopTB, LeftTB, WidthTB, HeightTB, FontTB, TooltipTB, ValueTB, MinTB, MaxTB, IntervalTB, PaddingTB, MinIntervalTB, SizeTB
            Dim ThisInputBox As Long
            ThisInputBox = GetInputBoxFromID(id)
            InputBoxText(ThisInputBox) = Text(id)
            InputBox(ThisInputBox).Sent = False
            Caption(StatusBar) = "Editing property"
        Case FileNameTextBox
            If OpenDialogOpen = False Then __UI_Focus = AddButton
        Case ControlList
            If OpenDialogOpen Then __UI_Focus = FileNameTextBox
        Case BlueValue
            If OpenDialogOpen Then __UI_Focus = CancelBT
        Case CloseZOrderingBT
            If ZOrderingDialogOpen = False Then __UI_Focus = BlueValue
        Case AddButton
            If ZOrderingDialogOpen Then __UI_Focus = ControlList
        Case CancelBT
            If ZOrderingDialogOpen Then __UI_Focus = CloseZOrderingBT
        Case KeyboardComboBT
            __UI_BypassKeyCombos = True
            Caption(KeyboardComboBT) = Chr$(7) + " hit a key combo... (ESC to clear)"
            ToolTip(KeyboardComboBT) = "Press a key combination to assign to the selected control"
    End Select
End Sub

Sub __UI_FocusOut (id As Long)
    Select Case id
        Case NameTB, CaptionTB, TextTB, MaskTB, TopTB, LeftTB, WidthTB, HeightTB, FontTB, TooltipTB, ValueTB, MinTB, MaxTB, IntervalTB, PaddingTB, MinIntervalTB, SizeTB
            ConfirmEdits id
        Case KeyboardComboBT
            __UI_BypassKeyCombos = False
            Caption(KeyboardComboBT) = "Click to assign"
    End Select
End Sub

Sub __UI_MouseDown (id As Long)
    Select Case id
        Case Red, Green, Blue
            Caption(StatusBar) = "Color picker active. Release to apply the new values..."
            Select Case Control(ColorPropertiesList).Value
                Case 1
                    OldColor = PreviewControls(FirstSelected).ForeColor
                    If OldColor = 0 Then OldColor = PreviewControls(PreviewFormID).ForeColor
                    If OldColor = 0 Then OldColor = __UI_DefaultColor(__UI_Type_Form, 1)
                Case 2
                    OldColor = PreviewControls(FirstSelected).BackColor
                    If OldColor = 0 Then OldColor = PreviewControls(PreviewFormID).BackColor
                    If OldColor = 0 Then OldColor = __UI_DefaultColor(__UI_Type_Form, 2)
                Case 3
                    OldColor = PreviewControls(FirstSelected).SelectedForeColor
                    If OldColor = 0 Then OldColor = PreviewControls(PreviewFormID).SelectedForeColor
                    If OldColor = 0 Then OldColor = __UI_DefaultColor(__UI_Type_Form, 3)
                Case 4
                    OldColor = PreviewControls(FirstSelected).SelectedBackColor
                    If OldColor = 0 Then OldColor = PreviewControls(PreviewFormID).SelectedBackColor
                    If OldColor = 0 Then OldColor = __UI_DefaultColor(__UI_Type_Form, 4)
                Case 5
                    OldColor = PreviewControls(FirstSelected).BorderColor
                    If OldColor = 0 Then OldColor = PreviewControls(PreviewFormID).BorderColor
                    If OldColor = 0 Then OldColor = __UI_DefaultColor(__UI_Type_Form, 5)
            End Select
    End Select
End Sub

Sub __UI_MouseUp (id As Long)
    Select Case id
        Case Red, Green, Blue
            'Compose a new color and send it to the preview
            SendNewRGB
            Caption(StatusBar) = "Color changed."
    End Select
End Sub

Sub AddToRecentList (FileName$)
    Dim i As Long, j As Long, b$

    'Check if this FileName$ is already in the list; if so, delete it.
    For i = 1 To 9
        b$ = ReadSetting("InForm.ini", "Recent Projects", Str$(i))
        If b$ = FileName$ Then
            For j = i + 1 To 9
                b$ = ReadSetting("InForm.ini", "Recent Projects", Str$(j))
                WriteSetting "InForm.ini", "Recent Projects", Str$(j - 1), b$
            Next
            Exit For
        End If
    Next

    'Make room for FileName$ by shifting existing list by one;
    '1 is the most recent, 9 is the oldest;
    For i = 8 To 1 Step -1
        b$ = ReadSetting("InForm.ini", "Recent Projects", Str$(i))
        WriteSetting "InForm.ini", "Recent Projects", Str$(i + 1), b$
    Next

    WriteSetting "InForm.ini", "Recent Projects", "1", FileName$
    RecentListBuilt = False
End Sub

Sub RemoveFromRecentList (FileName$)
    Dim i As Long, j As Long, b$

    'Check if this FileName$ is already in the list; if so, delete it.
    For i = 1 To 9
        b$ = ReadSetting("InForm.ini", "Recent Projects", Str$(i))
        If b$ = FileName$ Then
            For j = i + 1 To 9
                b$ = ReadSetting("InForm.ini", "Recent Projects", Str$(j))
                WriteSetting "InForm.ini", "Recent Projects", Str$(j - 1), b$
            Next
            WriteSetting "InForm.ini", "Recent Projects", "9", ""
            Exit For
        End If
    Next
    RecentListBuilt = False
End Sub


Sub SendNewRGB
    Dim b$, NewColor As _Unsigned Long
    NewColor = _RGB32(Control(Red).Value, Control(Green).Value, Control(Blue).Value)
    b$ = _MK$(_Unsigned Long, NewColor)
    SendData b$, Control(ColorPropertiesList).Value + 22
End Sub

Function PropertyFullySelected%% (id As Long)
    PropertyFullySelected%% = Control(id).TextIsSelected AND _
                              Control(id).SelectionStart = 0 AND _
                              Control(id).Cursor = LEN(Text(id))
End Function

Sub SelectPropertyFully (id As Long)
    Control(id).TextIsSelected = True
    Control(id).SelectionStart = 0
    Control(id).Cursor = Len(Text(id))
End Sub

Sub SelectFontInList (FontSetup$)
    Dim i As Long, thisFile$, thisSize%

    If FontSetup$ = "" Then Exit Sub

    thisFile$ = UCase$(Left$(FontSetup$, InStr(FontSetup$, ",") - 1))
    thisSize% = Val(Mid$(FontSetup$, InStr(FontSetup$, ",") + 1))

    ResetList FontSizeList
    For i = 8 To 120
        AddItem FontSizeList, LTrim$(Str$(i))
    Next
    i = SelectItem(FontSizeList, LTrim$(Str$(thisSize%)))

    If Len(thisFile$) > 0 Then
        For i = 1 To UBound(FontFile)
            If UCase$(Right$(FontFile(i), Len(thisFile$))) = thisFile$ Then
                Control(FontList).Value = i
                BypassShowFontList = False
                AttemptToShowFontList = False
                Exit Sub
            End If
        Next
    Else
        If thisSize% > 8 Then thisSize% = 16 Else thisSize% = 8
        ResetList FontSizeList
        AddItem FontSizeList, "8"
        AddItem FontSizeList, "16"
        i = SelectItem(FontSizeList, LTrim$(Str$(thisSize%)))
        Control(FontList).Value = 1 'Built-in VGA font
        BypassShowFontList = False
        AttemptToShowFontList = False
        Exit Sub
    End If

    'If this line is reached, the currently open form
    'uses a non-system font. In that case we must
    'disable the list.
    BypassShowFontList = True
    If AttemptToShowFontList Then
        AttemptToShowFontList = False
        i = MessageBox("The current font isn't a system font.\nReset this control to the built-in font?", "", MsgBox_YesNo + MsgBox_Question)
        If i = MsgBox_Yes Then
            thisFile$ = ",16"
            thisFile$ = MKL$(Len(thisFile$)) + thisFile$
            SendData thisFile$, 8
            BypassShowFontList = False
            ShowFontList = True
        End If
    End If
End Sub

Sub LoseFocus
    If __UI_TotalActiveMenus > 0 Then __UI_CloseAllMenus
    If __UI_ActiveDropdownList > 0 Then __UI_DestroyControl Control(__UI_ActiveDropdownList)
    If __UI_Focus > 0 Then __UI_FocusOut __UI_Focus
    __UI_Focus = 0
    __UI_ForceRedraw = True
End Sub

Sub __UI_BeforeUpdateDisplay
    Dim b$
    Dim i As Long, j As Long, Answer As _Byte
    Dim incomingData$, Signal$
    Dim thisData$, thisCommand$
    Static OriginalImageWidth As Integer, OriginalImageHeight As Integer
    Static PrevFirstSelected As Long, PreviewHasMenuActive As Integer
    Static ThisControlTurnsInto As Integer
    Static LastChange As Single

    If Timer - BlinkStatusBar < 1 Then
        If Timer - LastChange > .2 Then
            If Control(StatusBar).BackColor = StatusBarBackColor Then
                Control(StatusBar).BackColor = _RGB32(222, 194, 127)
            Else
                Control(StatusBar).BackColor = StatusBarBackColor
            End If
            Control(StatusBar).Redraw = True
            LastChange = Timer
        End If
    Else
        Control(StatusBar).BackColor = StatusBarBackColor
        Control(StatusBar).Redraw = True
    End If

    If __UI_BypassKeyCombos Then
        'Blink KeyCombo button
        If Timer - LastChange > .4 Then
            If Control(KeyboardComboBT).ForeColor = __UI_DefaultColor(__UI_Type_Button, 1) Then
                Control(KeyboardComboBT).ForeColor = _RGB32(255, 0, 0)
            Else
                Control(KeyboardComboBT).ForeColor = __UI_DefaultColor(__UI_Type_Button, 1)
            End If
            Control(KeyboardComboBT).Redraw = True
            LastChange = Timer
        End If
    Else
        Control(KeyboardComboBT).ForeColor = __UI_DefaultColor(__UI_Type_Button, 1)
        Control(KeyboardComboBT).Redraw = True
    End If

    If OpenDialogOpen Then
        If Len(RTrim$(LTrim$(Text(FileNameTextBox)))) = 0 Then
            Control(OpenBT).Disabled = True
            Control(SaveBT).Disabled = True
        Else
            Control(OpenBT).Disabled = False
            Control(SaveBT).Disabled = False
        End If
    End If

    If RecentListBuilt = False Then
        'Build list of recent projects
        RecentListBuilt = True
        For i = 1 To 9
            b$ = ReadSetting("InForm.ini", "Recent Projects", Str$(i))
            If Len(b$) Then
                ToolTip(RecentMenuItem(i)) = b$
                If InStr(b$, PathSep$) > 0 Then
                    For j = Len(b$) To 1 Step -1
                        If Mid$(b$, j, 1) = PathSep$ Then
                            SetCaption RecentMenuItem(i), "&" + LTrim$(Str$(i)) + " " + Mid$(b$, j + 1)
                            Exit For
                        End If
                    Next
                Else
                    SetCaption RecentMenuItem(i), "&" + LTrim$(Str$(i)) + " " + b$
                End If
                Control(RecentMenuItem(i)).Disabled = False
                Control(RecentMenuItem(i)).Hidden = False
            Else
                If i = 1 Then
                    SetCaption RecentMenuItem(i), "No recent projects"
                    ToolTip(RecentMenuItem(i)) = ""
                    Control(RecentMenuItem(i)).Disabled = True
                Else
                    Control(RecentMenuItem(i)).Hidden = True
                End If
            End If
        Next
    End If

    If __UI_Focus = 0 Then
        If Caption(StatusBar) = "" Then Caption(StatusBar) = "Ready."
    End If

    IF __UI_MouseDownOnID = Red OR __UI_MouseDownOnID = Green OR __UI_MouseDownOnID = Blue OR _
       __UI_PreviousMouseDownOnID = Red OR __UI_PreviousMouseDownOnID = Green OR __UI_PreviousMouseDownOnID = Blue THEN

        Select Case __UI_MouseDownOnID + __UI_PreviousMouseDownOnID
            Case Red
                Text(RedValue) = LTrim$(Str$(Fix(Control(Red).Value)))
            Case Green
                Text(GreenValue) = LTrim$(Str$(Fix(Control(Green).Value)))
            Case Blue
                Text(BlueValue) = LTrim$(Str$(Fix(Control(Blue).Value)))
        End Select

        'Compose a new color and preview it
        Dim NewColor As _Unsigned Long
        NewColor = _RGB32(Control(Red).Value, Control(Green).Value, Control(Blue).Value)
        QuickColorPreview NewColor
    End If

    'Check if another instance was launched and is passing
    'parameters:
    Static BringToFront As _Byte, InstanceStream$
    If InstanceClient Then
        If BringToFront = False Then
            $If WIN Then
                i = SetForegroundWindow&(_WindowHandle)
            $End If
            BringToFront = True
        End If

        Get #InstanceClient, , incomingData$
        InstanceStream$ = InstanceStream$ + incomingData$

        If InStr(InstanceStream$, "<END>") Then
            If Left$(InstanceStream$, 12) = "NEWINSTANCE>" Then
                InstanceStream$ = Mid$(InstanceStream$, 13)
                InstanceStream$ = Left$(InstanceStream$, InStr(InstanceStream$, "<END>") - 1)
                If _FileExists(InstanceStream$) Then
                    LoadNewInstanceForm:
                    If InStr(InstanceStream$, "/") > 0 Or InStr(InstanceStream$, "\") > 0 Then
                        For i = Len(InstanceStream$) To 1 Step -1
                            If Asc(InstanceStream$, i) = 92 Or Asc(InstanceStream$, i) = 47 Then
                                CurrentPath$ = Left$(InstanceStream$, i - 1)
                                InstanceStream$ = Mid$(InstanceStream$, i + 1)
                                Exit For
                            End If
                        Next
                    End If

                    If Edited Then
                        $If WIN Then
                            Answer = MessageBox("Save the current form?", "", MsgBox_YesNoCancel + MsgBox_Question)
                        $Else
                                Answer = MessageBox("Save the current form?", "", MsgBox_YesNo + MsgBox_Question)
                        $End If
                        If Answer = MsgBox_Cancel Then
                            Close InstanceClient
                            InstanceClient = 0
                            Exit Sub
                        ElseIf Answer = MsgBox_Yes Then
                            SaveForm False, False
                        End If
                    End If

                    Text(FileNameTextBox) = InstanceStream$
                    OpenDialogOpen = True
                    __UI_Click OpenBT
                End If
            End If
            Close InstanceClient
            InstanceClient = 0
        End If
    Else
        InstanceClient = _OpenConnection(InstanceHost)
        BringToFront = False
        InstanceStream$ = ""
    End If

    'Check if a form file was dropped onto the Editor for loading
    For i = 1 To _TotalDroppedFiles
        If _FileExists(_DroppedFile(i)) Then
            InstanceStream$ = _DroppedFile(i)
            _FinishDrop
            GoTo LoadNewInstanceForm
        End If
    Next

    CheckPreview

    Get #Client, , incomingData$
    Stream$ = Stream$ + incomingData$
    'STATIC bytesIn~&&, refreshes~&
    'refreshes~& = refreshes~& + 1
    'bytesIn~&& = bytesIn~&& + LEN(incomingData$)
    'Caption(StatusBar) = "Received:" + STR$(bytesIn~&&) + " bytes | Sent:" + STR$(totalBytesSent) + " bytes"

    $If WIN Then
        If PreviewAttached Then
            If prevScreenX <> _ScreenX Or prevScreenY <> _ScreenY Then
                prevScreenX = _ScreenX
                prevScreenY = _ScreenY
                b$ = "WINDOWPOSITION>" + MKI$(_ScreenX) + MKI$(_ScreenY) + "<END>"
                Send Client, b$
            End If
        Else
            If prevScreenX <> -32001 Or prevScreenY <> -32001 Then
                prevScreenX = -32001
                prevScreenY = -32001
                b$ = "WINDOWPOSITION>" + MKI$(-32001) + MKI$(-32001) + "<END>"
                Send Client, b$
            End If
        End If
    $Else
            IF PreviewAttached = True THEN
            PreviewAttached = False
            SaveSettings
            END IF
            Control(ViewMenuPreviewDetach).Disabled = True
            Control(ViewMenuPreviewDetach).Value = False
    $End If

    Static prevAutoName As _Byte, prevMouseSwap As _Byte
    Static prevShowPos As _Byte, prevSnapLines As _Byte
    Static prevShowInvisible As _Byte, SignalsFirstSent As _Byte

    If prevAutoName <> AutoNameControls Or SignalsFirstSent = False Then
        prevAutoName = AutoNameControls
        b$ = "AUTONAME>" + MKI$(AutoNameControls) + "<END>"
        Send Client, b$
    End If

    If prevMouseSwap <> __UI_MouseButtonsSwap Or SignalsFirstSent = False Then
        prevMouseSwap = __UI_MouseButtonsSwap
        b$ = "MOUSESWAP>" + MKI$(__UI_MouseButtonsSwap) + "<END>"
        Send Client, b$
    End If

    If prevShowPos <> __UI_ShowPositionAndSize Or SignalsFirstSent = False Then
        prevShowPos = __UI_ShowPositionAndSize
        b$ = "SHOWPOSSIZE>" + MKI$(__UI_ShowPositionAndSize) + "<END>"
        Send Client, b$
    End If

    If prevShowInvisible <> __UI_ShowInvisibleControls Or SignalsFirstSent = False Then
        prevShowInvisible = __UI_ShowInvisibleControls
        b$ = "SHOWINVISIBLECONTROLS>" + MKI$(__UI_ShowInvisibleControls) + "<END>"
        Send Client, b$
    End If

    If prevSnapLines <> __UI_SnapLines Or SignalsFirstSent = False Then
        prevSnapLines = __UI_SnapLines
        b$ = "SNAPLINES>" + MKI$(__UI_SnapLines) + "<END>"
        Send Client, b$
    End If
    SignalsFirstSent = True

    Do While InStr(Stream$, "<END>") > 0
        thisData$ = Left$(Stream$, InStr(Stream$, "<END>") - 1)
        Stream$ = Mid$(Stream$, InStr(Stream$, "<END>") + 5)
        thisCommand$ = Left$(thisData$, InStr(thisData$, ">") - 1)
        thisData$ = Mid$(thisData$, Len(thisCommand$) + 2)
        Select Case UCase$(thisCommand$)
            Case "TOTALSELECTEDCONTROLS"
                TotalSelected = CVL(thisData$)
                If SetBindingDialogOpen Then
                    Caption(CancelBindBT) = "Cancel"
                    __UI_Click CancelBindBT
                End If
            Case "FORMID"
                PreviewFormID = CVL(thisData$)
            Case "FIRSTSELECTED"
                FirstSelected = CVL(thisData$)
                If SetBindingDialogOpen Then
                    Caption(CancelBindBT) = "Cancel"
                    __UI_Click CancelBindBT
                End If
            Case "DEFAULTBUTTONID"
                PreviewDefaultButtonID = CVL(thisData$)
            Case "SHOWINVISIBLECONTROLS"
                __UI_ShowInvisibleControls = CVI(thisData$)
                Control(ViewMenuShowInvisibleControls).Value = __UI_ShowInvisibleControls
            Case "CONTROLRENAMED"
                If Len(InitialControlSet) Then
                    Dim insertionPoint As Long, endPoint
                    insertionPoint = InStr(InitialControlSet, Chr$(10) + Left$(thisData$, InStr(thisData$, Chr$(10))))
                    If insertionPoint Then
                        endPoint = InStr(insertionPoint + 1, InitialControlSet, Chr$(10))
                        InitialControlSet = Left$(InitialControlSet, endPoint - 1) + Chr$(11) + Mid$(thisData$, InStr(thisData$, Chr$(10)) + 1) + Mid$(InitialControlSet, endPoint)
                    Else
                        'not found... maybe renamed previously in this session?
                        insertionPoint = InStr(InitialControlSet, Chr$(11) + Left$(thisData$, InStr(thisData$, Chr$(10)) - 1) + Chr$(10))
                        If insertionPoint Then
                            insertionPoint = InStr(insertionPoint, InitialControlSet, Chr$(11))
                            endPoint = InStr(insertionPoint + 1, InitialControlSet, Chr$(10))
                            InitialControlSet = Left$(InitialControlSet, insertionPoint) + Mid$(thisData$, InStr(thisData$, Chr$(10)) + 1) + Mid$(InitialControlSet, endPoint)
                        End If
                    End If
                End If
            Case "SHOWBINDCONTROLDIALOG"
                __UI_Click EditMenuBindControls
            Case "ORIGINALIMAGEWIDTH"
                OriginalImageWidth = CVI(thisData$)
            Case "ORIGINALIMAGEHEIGHT"
                OriginalImageHeight = CVI(thisData$)
            Case "TURNSINTO"
                ThisControlTurnsInto = CVI(thisData$)
            Case "SELECTIONRECTANGLE"
                PreviewSelectionRectangle = CVI(thisData$)
                LoseFocus
            Case "MENUPANELACTIVE"
                PreviewHasMenuActive = CVI(thisData$)
            Case "SIGNAL"
                Signal$ = Signal$ + thisData$
            Case "FORMDATA"
                LastFormData$ = thisData$
                LoadPreview
                If Not FormDataReceived Then
                    FormDataReceived = True
                Else
                    Edited = True
                    If __UI_Focus > 0 Then
                        If PropertySent Then PropertySent = False Else LoseFocus
                    End If
                End If
            Case "UNDOPOINTER"
                UndoPointer = CVI(thisData$)
            Case "TOTALUNDOIMAGES"
                TotalUndoImages = CVI(thisData$)
        End Select
    Loop

    If Not FormDataReceived Then Exit Sub

    If InitialControlSet = "" Then
        InitialControlSet = Chr$(1)
        For i = 1 To UBound(PreviewControls)
            If PreviewControls(i).ID > 0 And PreviewControls(i).Type <> __UI_Type_Font And PreviewControls(i).Type <> __UI_Type_MenuPanel Then
                InitialControlSet = InitialControlSet + Chr$(10) + RTrim$(PreviewControls(i).Name) + Chr$(10)
            End If
        Next
    End If

    Control(EditMenuRestoreDimensions).Disabled = True
    SetCaption EditMenuRestoreDimensions, "Restore &image dimensions"
    If TotalSelected = 1 And PreviewControls(FirstSelected).Type = __UI_Type_PictureBox And OriginalImageWidth > 0 And OriginalImageHeight > 0 Then
        IF PreviewControls(FirstSelected).Height - (PreviewControls(FirstSelected).BorderSize * ABS(PreviewControls(FirstSelected).HasBorder)) <> OriginalImageHeight OR _
           PreviewControls(FirstSelected).Width - (PreviewControls(FirstSelected).BorderSize * ABS(PreviewControls(FirstSelected).HasBorder)) <> OriginalImageWidth THEN
            Control(EditMenuRestoreDimensions).Disabled = False
            SetCaption EditMenuRestoreDimensions, "Restore &image dimensions (" + LTrim$(Str$(OriginalImageWidth)) + "x" + LTrim$(Str$(OriginalImageHeight)) + ")"
        End If
    End If

    If ThisControlTurnsInto > 0 Then
        Control(EditMenuConvertType).Disabled = False
        SetCaption EditMenuConvertType, "Co&nvert to " + RTrim$(__UI_Type(ThisControlTurnsInto).Name)
    ElseIf ThisControlTurnsInto = -1 Then
        'Offer to turn text to numeric-only TextBox
        Control(EditMenuConvertType).Disabled = False
        SetCaption EditMenuConvertType, "Co&nvert to NumericTextBox"
    ElseIf ThisControlTurnsInto = -2 Then
        'Offer to turn numeric-only to text TextBox
        Control(EditMenuConvertType).Disabled = False
        SetCaption EditMenuConvertType, "Co&nvert to TextBox"
    Else
        Control(EditMenuConvertType).Disabled = True
        SetCaption EditMenuConvertType, "Co&nvert type"
    End If

    Do While Len(Signal$)
        'signals -1 and -3 deprecated for now
        b$ = Left$(Signal$, 2)
        Signal$ = Mid$(Signal$, 3)
        If CVI(b$) = -2 Then
            'User attempted to right-click a control but the preview
            'form is smaller than the menu panel. In such case the "Align"
            'menu is shown in the editor.
            If ZOrderingDialogOpen Then __UI_Click CloseZOrderingBT
            __UI_ActivateMenu Control(AlignMenu), False
            __UI_ForceRedraw = True
        ElseIf CVI(b$) = -4 Then
            'User attempted to load an icon file that couldn't be previewed
            Answer = MessageBox("Icon couldn't be previewed. Make sure it's a valid icon file.", "", MsgBox_OkOnly + MsgBox_Exclamation)
        ElseIf CVI(b$) = -5 Then
            'Context menu was successfully shown on the preview
            If __UI_TotalActiveMenus > 0 Then __UI_CloseAllMenus
            __UI_Focus = 0
            __UI_ForceRedraw = True
        ElseIf CVI(b$) = -6 Then
            'User attempted to load an invalid icon file
            Answer = MessageBox("Only .ico files are accepted.", "", MsgBox_OkOnly + MsgBox_Exclamation)
        ElseIf CVI(b$) = -7 Then
            'A new empty form has just been created or a file has just finished loading from disk
            Edited = False
        ElseIf CVI(b$) = -9 Then
            'User attempted to close the preview form
            __UI_Click FileMenuNew
            Exit Sub
        End If
    Loop

    If PrevFirstSelected <> FirstSelected Then
        LoseFocus
        PrevFirstSelected = FirstSelected
        __UI_ForceRedraw = True
        If ZOrderingDialogOpen And FirstSelected <> PreviewFormID Then
            For j = 1 To UBound(zOrderIDs)
                If zOrderIDs(j) = FirstSelected Then Control(ControlList).Value = j: __UI_ValueChanged ControlList: Exit For
            Next
        End If
    End If

    If Len(ThisFileName$) Then
        Caption(__UI_FormID) = UiEditorTitle$ + " - " + ThisFileName$
    Else
        If Len(RTrim$(__UI_TrimAt0$(PreviewControls(PreviewFormID).Name))) > 0 Then
            Caption(__UI_FormID) = UiEditorTitle$ + " - Untitled.frm"
        End If
    End If

    If Edited Then
        If Right$(Caption(__UI_FormID), 1) <> "*" Then Caption(__UI_FormID) = Caption(__UI_FormID) + "*"
    End If

    'Ctrl+Z? Ctrl+Y?
    Control(EditMenuUndo).Disabled = True
    Control(EditMenuRedo).Disabled = True
    If UndoPointer > 0 Then Control(EditMenuUndo).Disabled = False
    If UndoPointer < TotalUndoImages Then Control(EditMenuRedo).Disabled = False

    If (__UI_KeyHit = Asc("z") Or __UI_KeyHit = Asc("Z")) And __UI_CtrlIsDown Then
        SendSignal 214
    ElseIf (__UI_KeyHit = Asc("y") Or __UI_KeyHit = Asc("Y")) And __UI_CtrlIsDown Then
        SendSignal 215
    End If

    'Make ZOrdering menu enabled/disabled according to control list
    Control(EditMenuZOrdering).Disabled = True
    For i = 1 To UBound(PreviewControls)
        Select Case PreviewControls(i).Type
            Case 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 14, 15, 18
                j = j + 1
                If j > 1 Then
                    Control(EditMenuZOrdering).Disabled = False
                    Exit For
                End If
        End Select
    Next

    Control(EditMenuCP1252).Value = False
    Control(EditMenuCP437).Value = False
    Control(FontSwitchMenuSwitch).Value = ShowFontList
    If BypassShowFontList Then
        Control(FontSwitchMenuSwitch).Disabled = True
    Else
        Control(FontSwitchMenuSwitch).Disabled = False
    End If
    Select Case PreviewControls(PreviewFormID).Encoding
        Case 0, 437
            Control(EditMenuCP437).Value = True
        Case 1252
            Control(EditMenuCP1252).Value = True
    End Select

    If PreviewHasMenuActive Then
        Control(InsertMenuMenuItem).Disabled = False
    Else
        Control(InsertMenuMenuItem).Disabled = True
    End If

    Control(EditMenuSetDefaultButton).Disabled = True
    Control(EditMenuSetDefaultButton).Value = False
    Control(EditMenuBindControls).Disabled = True
    Control(EditMenuAllowMinMax).Disabled = True
    Control(EditMenuAllowMinMax).Value = False
    If InStr(LCase$(PreviewControls(PreviewFormID).Name), "form") = 0 Then
        Caption(ControlProperties) = "Control properties (Form):"
    Else
        Caption(ControlProperties) = "Control properties:"
    End If
    Caption(AlignMenuAlignCenterV) = "Center Vertically (group)"
    Caption(AlignMenuAlignCenterH) = "Center Horizontally (group)-"

    Control(EditMenuPaste).Disabled = True
    If Left$(_Clipboard$, Len(__UI_ClipboardCheck$)) = __UI_ClipboardCheck$ Then
        Control(EditMenuPaste).Disabled = False
    End If

    If TotalSelected = 0 Then
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

    ElseIf TotalSelected = 1 Then
        If FirstSelected > 0 And FirstSelected <= UBound(PreviewControls) Then
            Control(EditMenuCut).Disabled = False
            Control(EditMenuCopy).Disabled = False
            Control(EditMenuDelete).Disabled = False

            If InStr(LCase$(PreviewControls(FirstSelected).Name), LCase$(RTrim$(__UI_Type(PreviewControls(FirstSelected).Type).Name))) = 0 Then
                Caption(ControlProperties) = "Control properties (Type = " + RTrim$(__UI_Type(PreviewControls(FirstSelected).Type).Name) + "):"
            Else
                Caption(ControlProperties) = "Control properties:"
            End If
            Control(AlignMenuAlignLeft).Disabled = True
            Control(AlignMenuAlignRight).Disabled = True
            Control(AlignMenuAlignTops).Disabled = True
            Control(AlignMenuAlignBottoms).Disabled = True
            If PreviewControls(FirstSelected).Type <> __UI_Type_MenuBar And PreviewControls(FirstSelected).Type <> __UI_Type_MenuItem Then
                Control(AlignMenuAlignCenterV).Disabled = False
                Control(AlignMenuAlignCenterH).Disabled = False
                Caption(AlignMenuAlignCenterV) = "Center Vertically"
                Caption(AlignMenuAlignCenterH) = "Center Horizontally-"
            Else
                Control(AlignMenuAlignCenterV).Disabled = True
                Control(AlignMenuAlignCenterH).Disabled = True
            End If
            Control(AlignMenuAlignCentersV).Disabled = True
            Control(AlignMenuAlignCentersH).Disabled = True
            Control(AlignMenuDistributeV).Disabled = True
            Control(AlignMenuDistributeH).Disabled = True

            If PreviewControls(FirstSelected).Type = __UI_Type_Button Then
                Control(EditMenuSetDefaultButton).Disabled = False
                If PreviewDefaultButtonID <> FirstSelected Then
                    Control(EditMenuSetDefaultButton).Value = False
                Else
                    Control(EditMenuSetDefaultButton).Value = True
                End If
            ElseIf PreviewControls(FirstSelected).Type = __UI_Type_TextBox Then
                If PreviewControls(FirstSelected).NumericOnly = True Then
                    Control(EditMenuAllowMinMax).Disabled = False
                    Control(EditMenuAllowMinMax).Value = False
                    If InStr(PreviewControls(FirstSelected).Name, "NumericTextBox") = 0 Then Caption(ControlProperties) = "Control properties (Type = NumericTextBox):"
                ElseIf PreviewControls(FirstSelected).NumericOnly = __UI_NumericWithBounds Then
                    Control(EditMenuAllowMinMax).Disabled = False
                    Control(EditMenuAllowMinMax).Value = True
                    If InStr(PreviewControls(FirstSelected).Name, "NumericTextBox") = 0 Then Caption(ControlProperties) = "Control properties (Type = NumericTextBox):"
                End If
            End If
        End If
    ElseIf TotalSelected = 2 Then
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
    Else
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
    End If

    If FirstSelected = 0 Then FirstSelected = PreviewFormID

    For i = 1 To UBound(InputBox)
        Control(InputBox(i).ID).Disabled = False
        Control(InputBox(i).ID).Hidden = False
        Control(InputBox(i).LabelID).Hidden = False
        If __UI_Focus = InputBox(i).ID Then
            Control(InputBox(i).ID).Height = 22
            Control(InputBox(i).ID).BorderColor = _RGB32(0, 0, 0)
            Control(InputBox(i).ID).BorderSize = 2
        Else
            Control(InputBox(i).ID).Height = 23
            Control(InputBox(i).ID).BorderColor = __UI_DefaultColor(__UI_Type_TextBox, 5)
            Control(InputBox(i).ID).BorderSize = 1
        End If
    Next
    Control(FontSizeList).Hidden = True

    For i = 1 To UBound(Toggles)
        Control(Toggles(i)).Disabled = True
        Control(Toggles(i)).Hidden = False
    Next

    Dim ShadeOfGreen As _Unsigned Long, ShadeOfRed As _Unsigned Long
    ShadeOfGreen = _RGB32(28, 150, 50)
    ShadeOfRed = _RGB32(233, 44, 0)

    Const PropertyUpdateDelay = .1

    If FirstSelected > 0 Then
        Dim ThisInputBox As Long
        ThisInputBox = GetInputBoxFromID(__UI_Focus)

        If __UI_Focus <> NameTB Or (__UI_Focus = NameTB And RevertEdit = True) Then
            Text(NameTB) = RTrim$(PreviewControls(FirstSelected).Name)
            If (__UI_Focus = NameTB And RevertEdit = True) Then RevertEdit = False: SelectPropertyFully __UI_Focus
        ElseIf __UI_Focus = NameTB Then
            If PropertyFullySelected(NameTB) Then
                If Text(NameTB) = RTrim$(PreviewControls(FirstSelected).Name) Then
                    Control(__UI_Focus).BorderColor = ShadeOfGreen
                Else
                    If Timer - InputBox(ThisInputBox).LastEdited < PropertyUpdateDelay Then
                        Control(__UI_Focus).BorderColor = __UI_DefaultColor(__UI_Type_TextBox, 5)
                    Else
                        Control(__UI_Focus).BorderColor = ShadeOfRed
                    End If
                End If
            End If
        End If
        If __UI_Focus <> CaptionTB Or (__UI_Focus = CaptionTB And RevertEdit = True) Then
            Text(CaptionTB) = Replace(__UI_TrimAt0$(PreviewCaptions(FirstSelected)), Chr$(10), "\n", False, 0)
            If (__UI_Focus = CaptionTB And RevertEdit = True) Then RevertEdit = False: SelectPropertyFully __UI_Focus
        ElseIf __UI_Focus = CaptionTB Then
            If PropertyFullySelected(CaptionTB) Then
                If Text(CaptionTB) = Replace(__UI_TrimAt0$(PreviewCaptions(FirstSelected)), Chr$(10), "\n", False, 0) Then
                    Control(__UI_Focus).BorderColor = ShadeOfGreen
                Else
                    If Timer - InputBox(ThisInputBox).LastEdited < PropertyUpdateDelay Then
                        Control(__UI_Focus).BorderColor = __UI_DefaultColor(__UI_Type_TextBox, 5)
                    Else
                        Control(__UI_Focus).BorderColor = ShadeOfRed
                    End If
                End If
            End If
        End If
        If __UI_Focus <> TextTB Or (__UI_Focus = TextTB And RevertEdit = True) Then
            If PreviewControls(FirstSelected).Type = __UI_Type_ListBox Or PreviewControls(FirstSelected).Type = __UI_Type_DropdownList Then
                Text(TextTB) = Replace(PreviewTexts(FirstSelected), Chr$(10), "\n", False, 0)
            Else
                Text(TextTB) = PreviewTexts(FirstSelected)
                If Len(PreviewMasks(FirstSelected)) > 0 And PreviewControls(FirstSelected).Type = __UI_Type_TextBox Then
                    Mask(TextTB) = PreviewMasks(FirstSelected)
                Else
                    Mask(TextTB) = ""
                End If
            End If
            If (__UI_Focus = TextTB And RevertEdit = True) Then RevertEdit = False: SelectPropertyFully __UI_Focus
        ElseIf __UI_Focus = TextTB Then
            Control(TextTB).NumericOnly = PreviewControls(FirstSelected).NumericOnly
            If PropertyFullySelected(TextTB) Then
                IF ((PreviewControls(FirstSelected).Type = __UI_Type_ListBox OR PreviewControls(FirstSelected).Type = __UI_Type_DropdownList) AND Text(TextTB) = Replace(PreviewTexts(FirstSelected), CHR$(13), "\n", False, 0)) OR _
                   ((PreviewControls(FirstSelected).Type <> __UI_Type_ListBox AND PreviewControls(FirstSelected).Type <> __UI_Type_DropdownList) AND Text(TextTB) = PreviewTexts(FirstSelected)) THEN
                    Control(__UI_Focus).BorderColor = ShadeOfGreen
                Else
                    If Timer - InputBox(ThisInputBox).LastEdited < PropertyUpdateDelay Then
                        Control(__UI_Focus).BorderColor = __UI_DefaultColor(__UI_Type_TextBox, 5)
                    Else
                        Control(__UI_Focus).BorderColor = ShadeOfRed
                    End If
                End If
            End If
        End If
        If __UI_Focus <> MaskTB Or (__UI_Focus = MaskTB And RevertEdit = True) Then
            Text(MaskTB) = PreviewMasks(FirstSelected)
            If (__UI_Focus = MaskTB And RevertEdit = True) Then RevertEdit = False: SelectPropertyFully __UI_Focus
        ElseIf __UI_Focus = MaskTB Then
            If PropertyFullySelected(MaskTB) Then
                If Text(MaskTB) = PreviewMasks(FirstSelected) Then
                    Control(__UI_Focus).BorderColor = ShadeOfGreen
                Else
                    If Timer - InputBox(ThisInputBox).LastEdited < PropertyUpdateDelay Then
                        Control(__UI_Focus).BorderColor = __UI_DefaultColor(__UI_Type_TextBox, 5)
                    Else
                        Control(__UI_Focus).BorderColor = ShadeOfRed
                    End If
                End If
            End If
        End If
        If __UI_Focus <> TopTB Or (__UI_Focus = TopTB And RevertEdit = True) Then
            Text(TopTB) = LTrim$(Str$(PreviewControls(FirstSelected).Top))
            If (__UI_Focus = TopTB And RevertEdit = True) Then RevertEdit = False: SelectPropertyFully __UI_Focus
        ElseIf __UI_Focus = TopTB Then
            If PropertyFullySelected(TopTB) Then
                If Text(TopTB) = LTrim$(Str$(PreviewControls(FirstSelected).Top)) Then
                    Control(__UI_Focus).BorderColor = ShadeOfGreen
                Else
                    If Timer - InputBox(ThisInputBox).LastEdited < PropertyUpdateDelay Then
                        Control(__UI_Focus).BorderColor = __UI_DefaultColor(__UI_Type_TextBox, 5)
                    Else
                        Control(__UI_Focus).BorderColor = ShadeOfRed
                    End If
                End If
            End If
        End If
        If __UI_Focus <> LeftTB Or (__UI_Focus = LeftTB And RevertEdit = True) Then
            Text(LeftTB) = LTrim$(Str$(PreviewControls(FirstSelected).Left))
            If (__UI_Focus = LeftTB And RevertEdit = True) Then RevertEdit = False: SelectPropertyFully __UI_Focus
        ElseIf __UI_Focus = LeftTB Then
            If PropertyFullySelected(LeftTB) Then
                If Text(LeftTB) = LTrim$(Str$(PreviewControls(FirstSelected).Left)) Then
                    Control(__UI_Focus).BorderColor = ShadeOfGreen
                Else
                    If Timer - InputBox(ThisInputBox).LastEdited < PropertyUpdateDelay Then
                        Control(__UI_Focus).BorderColor = __UI_DefaultColor(__UI_Type_TextBox, 5)
                    Else
                        Control(__UI_Focus).BorderColor = ShadeOfRed
                    End If
                End If
            End If
        End If
        If __UI_Focus <> WidthTB Or (__UI_Focus = WidthTB And RevertEdit = True) Then
            Text(WidthTB) = LTrim$(Str$(PreviewControls(FirstSelected).Width))
            If (__UI_Focus = WidthTB And RevertEdit = True) Then RevertEdit = False: SelectPropertyFully __UI_Focus
        ElseIf __UI_Focus = WidthTB Then
            If PropertyFullySelected(WidthTB) Then
                If Text(WidthTB) = LTrim$(Str$(PreviewControls(FirstSelected).Width)) Then
                    Control(__UI_Focus).BorderColor = ShadeOfGreen
                Else
                    If Timer - InputBox(ThisInputBox).LastEdited < PropertyUpdateDelay Then
                        Control(__UI_Focus).BorderColor = __UI_DefaultColor(__UI_Type_TextBox, 5)
                    Else
                        Control(__UI_Focus).BorderColor = ShadeOfRed
                    End If
                End If
            End If
        End If
        If __UI_Focus <> HeightTB Or (__UI_Focus = HeightTB And RevertEdit = True) Then
            Text(HeightTB) = LTrim$(Str$(PreviewControls(FirstSelected).Height))
            If (__UI_Focus = HeightTB And RevertEdit = True) Then RevertEdit = False: SelectPropertyFully __UI_Focus
        ElseIf __UI_Focus = HeightTB Then
            If PropertyFullySelected(HeightTB) Then
                If Text(HeightTB) = LTrim$(Str$(PreviewControls(FirstSelected).Height)) Then
                    Control(__UI_Focus).BorderColor = ShadeOfGreen
                Else
                    If Timer - InputBox(ThisInputBox).LastEdited < PropertyUpdateDelay Then
                        Control(__UI_Focus).BorderColor = __UI_DefaultColor(__UI_Type_TextBox, 5)
                    Else
                        Control(__UI_Focus).BorderColor = ShadeOfRed
                    End If
                End If
            End If
        End If
        If __UI_Focus <> FontTB Or (__UI_Focus = FontTB And RevertEdit = True) Then
            If Len(PreviewFonts(FirstSelected)) > 0 Then
                Text(FontTB) = PreviewFonts(FirstSelected)
            Else
                Text(FontTB) = PreviewFonts(PreviewFormID)
            End If
            If (__UI_Focus = FontTB And RevertEdit = True) Then RevertEdit = False: SelectPropertyFully __UI_Focus
        ElseIf __UI_Focus = FontTB Then
            If PropertyFullySelected(FontTB) Then
                If Text(FontTB) = PreviewFonts(FirstSelected) Or Text(FontTB) = PreviewFonts(PreviewFormID) Then
                    Control(__UI_Focus).BorderColor = ShadeOfGreen
                Else
                    If Timer - InputBox(ThisInputBox).LastEdited < PropertyUpdateDelay Then
                        Control(__UI_Focus).BorderColor = __UI_DefaultColor(__UI_Type_TextBox, 5)
                    Else
                        Control(__UI_Focus).BorderColor = ShadeOfRed
                    End If
                End If
            End If
        End If
        If Len(PreviewFonts(FirstSelected)) > 0 Then
            SelectFontInList PreviewActualFonts(FirstSelected)
        Else
            SelectFontInList PreviewActualFonts(PreviewFormID)
        End If
        If __UI_Focus <> TooltipTB Or (__UI_Focus = TooltipTB And RevertEdit = True) Then
            Text(TooltipTB) = Replace(PreviewTips(FirstSelected), Chr$(10), "\n", False, 0)
            If (__UI_Focus = TooltipTB And RevertEdit = True) Then RevertEdit = False: SelectPropertyFully __UI_Focus
        ElseIf __UI_Focus = TooltipTB Then
            If PropertyFullySelected(FontTB) Then
                If Text(TooltipTB) = Replace(PreviewTips(FirstSelected), Chr$(10), "\n", False, 0) Then
                    Control(__UI_Focus).BorderColor = ShadeOfGreen
                Else
                    If Timer - InputBox(ThisInputBox).LastEdited < PropertyUpdateDelay Then
                        Control(__UI_Focus).BorderColor = __UI_DefaultColor(__UI_Type_TextBox, 5)
                    Else
                        Control(__UI_Focus).BorderColor = ShadeOfRed
                    End If
                End If
            End If
        End If
        If __UI_Focus <> ValueTB Or (__UI_Focus = ValueTB And RevertEdit = True) Then
            Text(ValueTB) = LTrim$(Str$(PreviewControls(FirstSelected).Value))
            If (__UI_Focus = ValueTB And RevertEdit = True) Then RevertEdit = False: SelectPropertyFully __UI_Focus
        ElseIf __UI_Focus = ValueTB Then
            If PropertyFullySelected(ValueTB) Then
                If Text(ValueTB) = LTrim$(Str$(PreviewControls(FirstSelected).Value)) Then
                    Control(__UI_Focus).BorderColor = ShadeOfGreen
                Else
                    If Timer - InputBox(ThisInputBox).LastEdited < PropertyUpdateDelay Then
                        Control(__UI_Focus).BorderColor = __UI_DefaultColor(__UI_Type_TextBox, 5)
                    Else
                        Control(__UI_Focus).BorderColor = ShadeOfRed
                    End If
                End If
            End If
        End If
        If __UI_Focus <> MinTB Or (__UI_Focus = MinTB And RevertEdit = True) Then
            Text(MinTB) = LTrim$(Str$(PreviewControls(FirstSelected).Min))
            If (__UI_Focus = MinTB And RevertEdit = True) Then RevertEdit = False: SelectPropertyFully __UI_Focus
        ElseIf __UI_Focus = MinTB Then
            If PropertyFullySelected(MinTB) Then
                If Text(MinTB) = LTrim$(Str$(PreviewControls(FirstSelected).Min)) Then
                    Control(__UI_Focus).BorderColor = ShadeOfGreen
                Else
                    If Timer - InputBox(ThisInputBox).LastEdited < PropertyUpdateDelay Then
                        Control(__UI_Focus).BorderColor = __UI_DefaultColor(__UI_Type_TextBox, 5)
                    Else
                        Control(__UI_Focus).BorderColor = ShadeOfRed
                    End If
                End If
            End If
        End If
        If __UI_Focus <> MaxTB Or (__UI_Focus = MaxTB And RevertEdit = True) Then
            Text(MaxTB) = LTrim$(Str$(PreviewControls(FirstSelected).Max))
            If (__UI_Focus = MaxTB And RevertEdit = True) Then RevertEdit = False: SelectPropertyFully __UI_Focus
        ElseIf __UI_Focus = MaxTB Then
            If PropertyFullySelected(MaxTB) Then
                If Text(MaxTB) = LTrim$(Str$(PreviewControls(FirstSelected).Max)) Then
                    Control(__UI_Focus).BorderColor = ShadeOfGreen
                Else
                    If Timer - InputBox(ThisInputBox).LastEdited < PropertyUpdateDelay Then
                        Control(__UI_Focus).BorderColor = __UI_DefaultColor(__UI_Type_TextBox, 5)
                    Else
                        Control(__UI_Focus).BorderColor = ShadeOfRed
                    End If
                End If
            End If
        End If
        If __UI_Focus <> IntervalTB Or (__UI_Focus = IntervalTB And RevertEdit = True) Then
            Text(IntervalTB) = LTrim$(Str$(PreviewControls(FirstSelected).Interval))
            If (__UI_Focus = IntervalTB And RevertEdit = True) Then RevertEdit = False: SelectPropertyFully __UI_Focus
        ElseIf __UI_Focus = IntervalTB Then
            If PropertyFullySelected(IntervalTB) Then
                If Text(IntervalTB) = LTrim$(Str$(PreviewControls(FirstSelected).Interval)) Then
                    Control(__UI_Focus).BorderColor = ShadeOfGreen
                Else
                    If Timer - InputBox(ThisInputBox).LastEdited < PropertyUpdateDelay Then
                        Control(__UI_Focus).BorderColor = __UI_DefaultColor(__UI_Type_TextBox, 5)
                    Else
                        Control(__UI_Focus).BorderColor = ShadeOfRed
                    End If
                End If
            End If
        End If
        If __UI_Focus <> MinIntervalTB Or (__UI_Focus = MinIntervalTB And RevertEdit = True) Then
            Text(MinIntervalTB) = LTrim$(Str$(PreviewControls(FirstSelected).MinInterval))
        ElseIf __UI_Focus = MinIntervalTB Then
            If PropertyFullySelected(MinIntervalTB) Then
                If Text(MinIntervalTB) = LTrim$(Str$(PreviewControls(FirstSelected).MinInterval)) Then
                    Control(__UI_Focus).BorderColor = ShadeOfGreen
                Else
                    If Timer - InputBox(ThisInputBox).LastEdited < PropertyUpdateDelay Then
                        Control(__UI_Focus).BorderColor = __UI_DefaultColor(__UI_Type_TextBox, 5)
                    Else
                        Control(__UI_Focus).BorderColor = ShadeOfRed
                    End If
                End If
            End If
        End If
        If __UI_Focus <> PaddingTB Or (__UI_Focus = PaddingTB And RevertEdit = True) Then
            Text(PaddingTB) = LTrim$(Str$(PreviewControls(FirstSelected).Padding))
            If (__UI_Focus = PaddingTB And RevertEdit = True) Then RevertEdit = False: SelectPropertyFully __UI_Focus
        ElseIf __UI_Focus = PaddingTB Then
            If PropertyFullySelected(PaddingTB) Then
                If Text(PaddingTB) = LTrim$(Str$(PreviewControls(FirstSelected).Padding)) Then
                    Control(__UI_Focus).BorderColor = ShadeOfGreen
                Else
                    If Timer - InputBox(ThisInputBox).LastEdited < PropertyUpdateDelay Then
                        Control(__UI_Focus).BorderColor = __UI_DefaultColor(__UI_Type_TextBox, 5)
                    Else
                        Control(__UI_Focus).BorderColor = ShadeOfRed
                    End If
                End If
            End If
        End If
        If __UI_Focus <> SizeTB Or (__UI_Focus = SizeTB And RevertEdit = True) Then
            Text(SizeTB) = LTrim$(Str$(PreviewControls(FirstSelected).BorderSize))
            If (__UI_Focus = SizeTB And RevertEdit = True) Then RevertEdit = False: SelectPropertyFully __UI_Focus
        ElseIf __UI_Focus = SizeTB Then
            If PropertyFullySelected(SizeTB) Then
                If Text(SizeTB) = LTrim$(Str$(PreviewControls(FirstSelected).BorderSize)) Then
                    Control(__UI_Focus).BorderColor = ShadeOfGreen
                Else
                    If Timer - InputBox(ThisInputBox).LastEdited < PropertyUpdateDelay Then
                        Control(__UI_Focus).BorderColor = __UI_DefaultColor(__UI_Type_TextBox, 5)
                    Else
                        Control(__UI_Focus).BorderColor = ShadeOfRed
                    End If
                End If
            End If
        End If
    End If

    Control(TextTB).Max = 0
    Control(TextTB).Min = 0
    If PreviewControls(FirstSelected).Type = __UI_Type_TextBox And __UI_Focus = TextTB Then
        Control(TextTB).Max = PreviewControls(FirstSelected).Max
        Control(TextTB).Min = PreviewControls(FirstSelected).Min
    End If

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
    Control(BooleanOptions).Value = Abs(PreviewControls(FirstSelected).Value <> 0) + 1
    Control(AlignOptions).Value = PreviewControls(FirstSelected).Align + 1
    Control(VAlignOptions).Value = PreviewControls(FirstSelected).VAlign + 1
    Control(BulletOptions).Value = PreviewControls(FirstSelected).BulletStyle + 1
    Control(Transparent).Value = PreviewControls(FirstSelected).BackStyle
    Control(Resizable).Value = PreviewControls(FirstSelected).CanResize
    Control(AutoScroll).Value = PreviewControls(FirstSelected).AutoScroll
    Control(AutoSize).Value = PreviewControls(FirstSelected).AutoSize
    Control(HideTicks).Value = (PreviewControls(FirstSelected).Height = __UI_Type(__UI_Type_TrackBar).MinimumHeight)
    Control(AutoPlayGif).Value = PreviewAutoPlayGif(FirstSelected)

    If Len(PreviewContextMenu(FirstSelected)) Then
        Dim ItemFound As _Byte
        ItemFound = SelectItem(ContextMenuControlsList, PreviewContextMenu(FirstSelected))
    Else
        Control(ContextMenuControlsList).Value = 1
    End If
    If __UI_BypassKeyCombos = False Then
        If TotalSelected = 1 And Len(PreviewKeyCombos(FirstSelected)) Then
            Caption(KeyboardComboBT) = PreviewKeyCombos(FirstSelected)
        Else
            Caption(KeyboardComboBT) = "Click to assign"
        End If
    End If

    Static ShowInvalidValueWarning As _Byte
    If Control(__UI_Focus).BorderColor = ShadeOfRed Then
        If ShowInvalidValueWarning = False Then
            ShowInvalidValueWarning = True
            Caption(StatusBar) = "Invalid value; ESC for previous or adjusted value"
            BlinkStatusBar = Timer
        End If
    Else
        ShowInvalidValueWarning = False
    End If

    'Disable properties that don't apply
    Control(AlignOptions).Disabled = True
    Control(BooleanOptions).Disabled = True
    Control(VAlignOptions).Disabled = True
    Control(BulletOptions).Disabled = True
    Caption(TextLB) = "Text"
    Caption(ValueLB) = "Value"
    Caption(MaxLB) = "Max"
    Control(SizeTB).Disabled = True
    Control(SizeTB).Hidden = True
    If TotalSelected > 0 Then
        Select EveryCase PreviewControls(FirstSelected).Type
            Case __UI_Type_ToggleSwitch
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
            Case __UI_Type_MenuBar, __UI_Type_MenuItem
                Control(Disabled).Disabled = False
                Control(Hidden).Disabled = False
            Case __UI_Type_MenuBar
                'Check if this is the last menu bar item so that Align options can be enabled
                For i = UBound(PreviewControls) To 1 Step -1
                    If PreviewControls(i).ID > 0 And PreviewControls(i).Type = __UI_Type_MenuBar Then
                        Exit For
                    End If
                Next
                If i = FirstSelected Then
                    Control(AlignOptions).Disabled = False
                End If

                For i = 1 To UBound(InputBox)
                    Select Case InputBox(i).ID
                        Case NameTB, CaptionTB, TooltipTB, AlignOptions
                            Control(InputBox(i).ID).Disabled = False
                        Case Else
                            Control(InputBox(i).ID).Disabled = True
                    End Select
                Next
            Case __UI_Type_ContextMenu
                For i = 1 To UBound(InputBox)
                    Select Case InputBox(i).ID
                        Case NameTB
                            Control(InputBox(i).ID).Disabled = False
                        Case Else
                            Control(InputBox(i).ID).Disabled = True
                    End Select
                Next
            Case __UI_Type_MenuItem
                For i = 1 To UBound(InputBox)
                    Select Case InputBox(i).ID
                        Case NameTB, CaptionTB, TextTB, TooltipTB, BulletOptions, BooleanOptions, KeyboardComboBT
                            Control(InputBox(i).ID).Disabled = False
                        Case Else
                            Control(InputBox(i).ID).Disabled = True
                    End Select
                Next
            Case __UI_Type_PictureBox
                Caption(TextLB) = "Image file"
                Control(AlignOptions).Disabled = False
                Control(VAlignOptions).Disabled = False
                Control(Stretch).Disabled = False
                Control(Transparent).Disabled = False
                If PreviewAnimatedGif(FirstSelected) Then
                    Control(AutoPlayGif).Disabled = False
                End If
                For i = 1 To UBound(InputBox)
                    Select Case InputBox(i).ID
                        Case NameTB, TextTB, TopTB, LeftTB, WidthTB, HeightTB, TooltipTB, AlignOptions, VAlignOptions
                            Control(InputBox(i).ID).Disabled = False
                        Case Else
                            Control(InputBox(i).ID).Disabled = True
                    End Select
                Next
            Case __UI_Type_Label
                Control(Transparent).Disabled = False
                Control(AutoSize).Disabled = False
                For i = 1 To UBound(InputBox)
                    Select Case InputBox(i).ID
                        Case NameTB, CaptionTB, TopTB, LeftTB, WidthTB, HeightTB, FontTB, TooltipTB, PaddingTB, AlignOptions, VAlignOptions, FontList
                            Control(InputBox(i).ID).Disabled = False
                        Case Else
                            Control(InputBox(i).ID).Disabled = True
                    End Select
                Next
            Case __UI_Type_Frame
                Control(Transparent).Disabled = True
                For i = 1 To UBound(InputBox)
                    Select Case InputBox(i).ID
                        Case NameTB, CaptionTB, TopTB, LeftTB, WidthTB, HeightTB, FontTB, TooltipTB, FontList
                            Control(InputBox(i).ID).Disabled = False
                        Case Else
                            Control(InputBox(i).ID).Disabled = True
                    End Select
                Next
            Case __UI_Type_TextBox
                Static PreviousNumericState As _Byte
                Control(Transparent).Disabled = False
                Control(PasswordMaskCB).Disabled = (PreviewControls(FirstSelected).NumericOnly <> False)
                If PreviousNumericState <> PreviewControls(FirstSelected).NumericOnly Then
                    PreviousNumericState = PreviewControls(FirstSelected).NumericOnly
                    __UI_ForceRedraw = True
                End If
                If PreviewControls(FirstSelected).NumericOnly = True Then
                    For i = 1 To UBound(InputBox)
                        Select Case InputBox(i).ID
                            Case ValueTB, MinTB, MaxTB, MaskTB, IntervalTB, PaddingTB, AlignOptions, VAlignOptions, MinIntervalTB, BulletOptions, BooleanOptions, KeyboardComboBT
                                Control(InputBox(i).ID).Disabled = True
                            Case Else
                                Control(InputBox(i).ID).Disabled = False
                        End Select
                    Next
                ElseIf PreviewControls(FirstSelected).NumericOnly = __UI_NumericWithBounds Then
                    For i = 1 To UBound(InputBox)
                        Select Case InputBox(i).ID
                            Case ValueTB, MaskTB, IntervalTB, PaddingTB, AlignOptions, VAlignOptions, MinIntervalTB, BulletOptions, BooleanOptions, KeyboardComboBT
                                Control(InputBox(i).ID).Disabled = True
                            Case Else
                                Control(InputBox(i).ID).Disabled = False
                        End Select
                    Next
                Else
                    Caption(MaxLB) = "Max length"
                    For i = 1 To UBound(InputBox)
                        Select Case InputBox(i).ID
                            Case ValueTB, MinTB, IntervalTB, PaddingTB, AlignOptions, VAlignOptions, MinIntervalTB, BulletOptions, BooleanOptions, KeyboardComboBT
                                Control(InputBox(i).ID).Disabled = True
                            Case Else
                                Control(InputBox(i).ID).Disabled = False
                        End Select
                    Next
                End If
            Case __UI_Type_Button, __UI_Type_MenuItem
                Caption(TextLB) = "Image file"
            Case __UI_Type_Button
                For i = 1 To UBound(InputBox)
                    Select Case InputBox(i).ID
                        Case ValueTB, MinTB, MaxTB, IntervalTB, PaddingTB, MaskTB, AlignOptions, VAlignOptions, MinIntervalTB, BulletOptions, BooleanOptions
                            Control(InputBox(i).ID).Disabled = True
                        Case Else
                            Control(InputBox(i).ID).Disabled = False
                    End Select
                Next
            Case __UI_Type_CheckBox, __UI_Type_RadioButton
                Control(Transparent).Disabled = False
                For i = 1 To UBound(InputBox)
                    Select Case InputBox(i).ID
                        Case TextTB, MinTB, MaxTB, IntervalTB, PaddingTB, MaskTB, AlignOptions, VAlignOptions, MinIntervalTB, BulletOptions, ValueTB
                            Control(InputBox(i).ID).Disabled = True
                        Case Else
                            Control(InputBox(i).ID).Disabled = False
                    End Select
                Next
            Case __UI_Type_ToggleSwitch
                Control(Transparent).Disabled = True
                For i = 1 To UBound(InputBox)
                    Select Case InputBox(i).ID
                        Case WidthTB, HeightTB, TextTB, MinTB, MaxTB, IntervalTB, PaddingTB, MaskTB, AlignOptions, VAlignOptions, MinIntervalTB, BulletOptions, ValueTB, FontTB, FontList
                            Control(InputBox(i).ID).Disabled = True
                        Case Else
                            Control(InputBox(i).ID).Disabled = False
                    End Select
                Next
            Case __UI_Type_ProgressBar
                For i = 1 To UBound(InputBox)
                    Select Case InputBox(i).ID
                        Case TextTB, IntervalTB, PaddingTB, MaskTB, AlignOptions, VAlignOptions, MinIntervalTB, BulletOptions, BooleanOptions, KeyboardComboBT
                            Control(InputBox(i).ID).Disabled = True
                        Case Else
                            Control(InputBox(i).ID).Disabled = False
                    End Select
                Next
            Case __UI_Type_TrackBar
                Control(HideTicks).Disabled = False
                For i = 1 To UBound(InputBox)
                    Select Case InputBox(i).ID
                        Case CaptionTB, TextTB, FontTB, PaddingTB, MaskTB, AlignOptions, VAlignOptions, BulletOptions, BooleanOptions, FontList, KeyboardComboBT
                            Control(InputBox(i).ID).Disabled = True
                        Case Else
                            Control(InputBox(i).ID).Disabled = False
                    End Select
                Next
            Case __UI_Type_ListBox, __UI_Type_DropdownList
                Caption(TextLB) = "List items"
                Caption(ValueLB) = "Selected item"
                Control(Transparent).Disabled = False
                For i = 1 To UBound(InputBox)
                    Select Case InputBox(i).ID
                        Case CaptionTB, MinTB, MaxTB, IntervalTB, PaddingTB, MaskTB, AlignOptions, VAlignOptions, MinIntervalTB, BulletOptions, BooleanOptions, KeyboardComboBT
                            Control(InputBox(i).ID).Disabled = True
                        Case Else
                            Control(InputBox(i).ID).Disabled = False
                    End Select
                Next
            Case __UI_Type_ListBox
                Control(AutoScroll).Disabled = False
            Case __UI_Type_Frame, __UI_Type_Label, __UI_Type_TextBox, __UI_Type_ListBox, __UI_Type_DropdownList, __UI_Type_PictureBox
                Control(HasBorder).Disabled = False
            Case __UI_Type_ProgressBar
                Control(ShowPercentage).Disabled = False
            Case __UI_Type_Label
                Control(WordWrap).Disabled = False
            Case __UI_Type_Button, __UI_Type_CheckBox, __UI_Type_RadioButton, __UI_Type_TextBox, __UI_Type_ListBox, __UI_Type_DropdownList, __UI_Type_TrackBar
                Control(CanHaveFocus).Disabled = False
            Case __UI_Type_Button, __UI_Type_CheckBox, __UI_Type_RadioButton, __UI_Type_TextBox, __UI_Type_ListBox, __UI_Type_DropdownList, __UI_Type_TrackBar, __UI_Type_Label, __UI_Type_ProgressBar
                Control(Disabled).Disabled = False
            Case __UI_Type_Frame, __UI_Type_Button, __UI_Type_CheckBox, __UI_Type_RadioButton, __UI_Type_TextBox, __UI_Type_ListBox, __UI_Type_DropdownList, __UI_Type_TrackBar, __UI_Type_Label, __UI_Type_ProgressBar, __UI_Type_PictureBox
                Control(Hidden).Disabled = False
            Case __UI_Type_Label
                Control(AlignOptions).Disabled = False
                Control(VAlignOptions).Disabled = False
        End Select
    Else
        'Properties relative to the form
        Control(CenteredWindow).Disabled = False
        Control(Resizable).Disabled = False
        Control(AddGifExtensionToggle).Disabled = False
        Caption(TextLB) = "Icon file"

        For i = 1 To UBound(InputBox)
            Select Case InputBox(i).ID
                Case NameTB, CaptionTB, TextTB, WidthTB, HeightTB, FontTB, FontList
                    Control(InputBox(i).ID).Disabled = False
                Case Else
                    Control(InputBox(i).ID).Disabled = True
            End Select
        Next
    End If

    If TotalSelected > 1 Then Control(NameTB).Disabled = True

    If HasFontList And (ShowFontList = True And BypassShowFontList = False) Then
        Control(FontTB).Disabled = True
    Else
        Control(FontList).Disabled = True
    End If

    IF PreviewControls(FirstSelected).Type = __UI_Type_ContextMenu OR _
       PreviewControls(FirstSelected).Type = __UI_Type_MenuBar OR _
        PreviewControls(FirstSelected).Type = __UI_Type_MenuItem THEN
        Control(ContextMenuControlsList).Disabled = True
    Else
        Control(ContextMenuControlsList).Disabled = False
    End If

    Dim LastTopForInputBox As Integer
    LastTopForInputBox = -12
    Const TopIncrementForInputBox = 22
    For i = 1 To UBound(InputBox)
        'Exception for SizeTB:
        If InputBox(i).ID = SizeTB Then _Continue

        If Control(InputBox(i).ID).Disabled Then
            Control(InputBox(i).ID).Hidden = True
            Control(InputBox(i).LabelID).Hidden = True
        Else
            LastTopForInputBox = LastTopForInputBox + TopIncrementForInputBox
            Control(InputBox(i).ID).Top = LastTopForInputBox
            Control(InputBox(i).LabelID).Top = LastTopForInputBox
        End If
    Next

    LastTopForInputBox = -12
    For i = 1 To UBound(Toggles)
        If Control(Toggles(i)).Disabled Then
            Control(Toggles(i)).Hidden = True
        Else
            LastTopForInputBox = LastTopForInputBox + TopIncrementForInputBox
            Control(Toggles(i)).Top = LastTopForInputBox
        End If
    Next

    'Custom cases
    Control(AutoPlayGif).Disabled = Not Control(AddGifExtensionToggle).Value
    Control(AutoSize).Disabled = Control(WordWrap).Value
    If Control(HasBorder).Value = True And PreviewControls(FirstSelected).Type <> __UI_Type_Frame Then
        Control(SizeTB).Disabled = False
        Control(SizeTB).Hidden = False
        Control(SizeTB).Height = 22
        Control(SizeTB).Top = Control(HasBorder).Top
        Caption(HasBorder) = "Has border     Size"
    End If

    Control(FontSizeList).Disabled = Control(FontList).Disabled
    Control(FontSizeList).Hidden = Control(FontList).Hidden
    Control(FontSizeList).Top = Control(FontList).Top
    Control(PasteListBT).Hidden = True

    If PreviewControls(FirstSelected).Type = __UI_Type_ListBox Or PreviewControls(FirstSelected).Type = __UI_Type_DropdownList Then
        If InStr(_Clipboard$, Chr$(10)) Then
            Control(PasteListBT).Top = Control(TextTB).Top
            Control(PasteListBT).Hidden = False
        End If
    ElseIf (PreviewControls(FirstSelected).Type = __UI_Type_Label And PreviewControls(FirstSelected).WordWrap = True) Then
        If InStr(_Clipboard$, Chr$(10)) Then
            Control(PasteListBT).Top = Control(CaptionTB).Top
            Control(PasteListBT).Hidden = False
        End If
    End If

    'Update the color mixer
    Dim ThisColor As _Unsigned Long, ThisBackColor As _Unsigned Long

    Select EveryCase Control(ColorPropertiesList).Value
        Case 0
            Control(ColorPropertiesList).Value = 1
        Case Is > 5
            Control(ColorPropertiesList).Value = 5
        Case 1, 2 'ForeColor, BackColor
            ThisColor = PreviewControls(FirstSelected).ForeColor
            If ThisColor = 0 Then ThisColor = PreviewControls(PreviewFormID).ForeColor
            If ThisColor = 0 Then ThisColor = __UI_DefaultColor(__UI_Type_Form, 1)
            ThisBackColor = PreviewControls(FirstSelected).BackColor
            If ThisBackColor = 0 Then ThisBackColor = PreviewControls(PreviewFormID).BackColor
            If ThisBackColor = 0 Then ThisBackColor = __UI_DefaultColor(__UI_Type_Form, 2)
        Case 3, 4 'SelectedForeColor, SelectedBackColor
            ThisColor = PreviewControls(FirstSelected).SelectedForeColor
            If ThisColor = 0 Then ThisColor = PreviewControls(PreviewFormID).SelectedForeColor
            If ThisColor = 0 Then ThisColor = __UI_DefaultColor(__UI_Type_Form, 3)
            ThisBackColor = PreviewControls(FirstSelected).SelectedBackColor
            If ThisBackColor = 0 Then ThisBackColor = PreviewControls(PreviewFormID).SelectedBackColor
            If ThisBackColor = 0 Then ThisBackColor = __UI_DefaultColor(__UI_Type_Form, 4)
        Case 5 'BorderColor
            ThisColor = PreviewControls(FirstSelected).BorderColor
            If ThisColor = 0 Then ThisColor = PreviewControls(PreviewFormID).BorderColor
            If ThisColor = 0 Then ThisColor = __UI_DefaultColor(__UI_Type_Form, 5)
            ThisBackColor = PreviewControls(FirstSelected).BackColor
            If ThisBackColor = 0 Then ThisBackColor = PreviewControls(PreviewFormID).BackColor
            If ThisBackColor = 0 Then ThisBackColor = __UI_DefaultColor(__UI_Type_Form, 2)
        Case 1, 3, 5
            If __UI_Focus <> Red And __UI_Focus <> RedValue Then
                Control(Red).Value = _Red32(ThisColor)
                Text(RedValue) = LTrim$(Str$(Control(Red).Value))
            End If
            If __UI_Focus <> Green And __UI_Focus <> GreenValue Then
                Control(Green).Value = _Green32(ThisColor)
                Text(GreenValue) = LTrim$(Str$(Control(Green).Value))
            End If
            If __UI_Focus <> Blue And __UI_Focus <> BlueValue Then
                Control(Blue).Value = _Blue32(ThisColor)
                Text(BlueValue) = LTrim$(Str$(Control(Blue).Value))
            End If
        Case 2, 4
            If __UI_Focus <> Red And __UI_Focus <> RedValue Then
                Control(Red).Value = _Red32(ThisBackColor)
                Text(RedValue) = LTrim$(Str$(Control(Red).Value))
            End If
            If __UI_Focus <> Green And __UI_Focus <> GreenValue Then
                Control(Green).Value = _Green32(ThisBackColor)
                Text(GreenValue) = LTrim$(Str$(Control(Green).Value))
            End If
            If __UI_Focus <> Blue And __UI_Focus <> BlueValue Then
                Control(Blue).Value = _Blue32(ThisBackColor)
                Text(BlueValue) = LTrim$(Str$(Control(Blue).Value))
            End If
    End Select

    If Control(ColorPreview).HelperCanvas = 0 Then
        Control(ColorPreview).HelperCanvas = _NewImage(Control(ColorPreview).Width, Control(ColorPreview).Height, 32)
    End If

    Static PrevPreviewForeColor As _Unsigned Long, PrevPreviewBackColor As _Unsigned Long
    Static PrevColorPropertiesListValue As _Byte
    If PrevPreviewForeColor <> ThisColor Or PrevPreviewBackColor <> ThisBackColor Or PrevColorPropertiesListValue <> Control(ColorPropertiesList).Value Then
        PrevPreviewForeColor = ThisColor
        PrevPreviewBackColor = ThisBackColor
        PrevColorPropertiesListValue = Control(ColorPropertiesList).Value
        UpdateColorPreview Control(ColorPropertiesList).Value, ThisColor, ThisBackColor
    End If
End Sub

Sub __UI_BeforeUnload
    Dim Answer As _Byte
    If Edited Then
        $If WIN Then
            Answer = MessageBox("Save the current form before leaving?", "", MsgBox_YesNoCancel + MsgBox_Question)
        $Else
                Answer = MessageBox("Save the current form before leaving?", "", MsgBox_YesNo + MsgBox_Question)
        $End If
        If Answer = MsgBox_Cancel Then
            __UI_UnloadSignal = False
        ElseIf Answer = MsgBox_Yes Then
            If ThisFileName$ = "" Then
                ThisFileName$ = "untitled"
            End If
            SaveForm False, False
        End If
    End If
    SaveSettings
End Sub

Sub SaveSettings
    Dim value$

    If _DirExists("InForm") = 0 Then Exit Sub

    If PreviewAttached Then value$ = "True" Else value$ = "False"
    WriteSetting "InForm.ini", "InForm Settings", "Keep preview window attached", value$

    If AutoNameControls Then value$ = "True" Else value$ = "False"
    WriteSetting "InForm.ini", "InForm Settings", "Auto-name controls", value$

    If __UI_SnapLines Then value$ = "True" Else value$ = "False"
    WriteSetting "InForm.ini", "InForm Settings", "Snap to edges", value$

    If __UI_ShowPositionAndSize Then value$ = "True" Else value$ = "False"
    WriteSetting "InForm.ini", "InForm Settings", "Show position and size", value$

    If __UI_ShowInvisibleControls Then value$ = "True" Else value$ = "False"
    WriteSetting "InForm.ini", "InForm Settings", "Show invisible controls", value$

    value$ = "False"  													' *** Removing the checking for update function 
    WriteSetting "InForm.ini", "InForm Settings", "Check for updates", value$

   value$ = "False"  													' *** Removing the checking for update function
    WriteSetting "InForm.ini", "InForm Settings", "Receive development updates", value$

    If ShowFontList Then value$ = "True" Else value$ = "False"
    WriteSetting "InForm.ini", "InForm Settings", "Show font list", value$

    $If WIN Then
    $Else
        IF __UI_MouseButtonsSwap THEN value$ = "True" ELSE value$ = "False"
        WriteSetting "InForm.ini", "InForm Settings", "Swap mouse buttons", value$
    $End If
End Sub

Sub __UI_BeforeInit
    __UI_KeepScreenHidden = True
    __UI_EditorMode = True
End Sub

Sub __UI_FormResized
End Sub

Sub Handshake
    'Handshake: each module sends the other their PID:

    Dim b$, i As Integer

    Stream$ = "" 'clear buffer

    b$ = "EDITORPID>" + MKL$(__UI_GetPID) + "<END>"
    Send Client, b$

    $If WIN Then
        Const TIMEOUT = 10
    $Else
            CONST TIMEOUT = 120
    $End If

    Dim start!, incomingData$, thisData$
    start! = Timer
    Do
        incomingData$ = ""
        Get #Client, , incomingData$
        Stream$ = Stream$ + incomingData$
        If InStr(Stream$, "<END>") Then
            thisData$ = Left$(Stream$, InStr(Stream$, "<END>") - 1)
            Stream$ = Mid$(Stream$, Len(thisData$) + 6)
            If Left$(thisData$, 11) = "PREVIEWPID>" Then
                UiPreviewPID = CVL(Mid$(thisData$, 12))
            End If
            Exit Do
        End If
    Loop Until Timer - start! > TIMEOUT

    If UiPreviewPID = 0 Then
        i = MessageBox("UiEditorPreview component not found or failed to load.", "UiEditor", MsgBox_OkOnly + MsgBox_Critical)
        System
    End If
End Sub

Sub __UI_OnLoad
    Dim i As Long, b$
    Dim prevDest As Long

    b$ = "Starting..."
    GoSub ShowMessage

    'Load splash image:
    Dim tempIcon As Long
    tempIcon = _LoadImage("resources/Application-icon-128.png", 32)

    GoSub ShowMessage

    b$ = "Opening communication port (click 'unblock' if your Operating System asks)..."
    GoSub ShowMessage
    Dim HostAttempts As Integer
    Do
        HostAttempts = HostAttempts + 1
        InstanceHost = _OpenHost("TCP/IP:60680") '60680 = #ED08, as the functionality was implemented in Beta 8 of the EDitor ;-)
    Loop Until InstanceHost <> 0 Or HostAttempts > 1000

    If InstanceHost = 0 Then
        'There is probably another instance of InForm Designer running.
        '(i) attempt to communicate and pass parameters and
        '(ii) bring it to the front.

        HostAttempts = 0
        Do
            HostAttempts = HostAttempts + 1
            Host = _OpenClient("TCP/IP:60680:localhost")
        Loop Until Host <> 0 Or HostAttempts > 1000

        If Host Then
            b$ = "NEWINSTANCE>" + Command$ + "<END>"
            Send Host, b$
            _Delay 1
            Close Host
        End If
        System
    End If

    _ScreenShow
    _Icon

    Randomize Timer
    HostAttempts = 0
    Do
        HostAttempts = HostAttempts + 1
        HostPort = LTrim$(Str$(Int(Rnd * 5000 + 60000)))
        Host = _OpenHost("TCP/IP:" + HostPort)
    Loop Until Host <> 0 Or HostAttempts > 1000

    If Host = 0 Then
        Dim Answer As _Byte
        Answer = MessageBox("Unable to open communication port.", "", MsgBox_OkOnly + MsgBox_Critical)
        System
    End If

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

    Dim FileToOpen$, FreeFileNum As Integer

    b$ = "Reading settings..."
    GoSub ShowMessage

    If _DirExists("InForm") = 0 Then MkDir "InForm"

    Dim value$
    value$ = ReadSetting("InForm.ini", "InForm Settings", "Keep preview window attached")
    If Len(value$) Then
        PreviewAttached = (value$ = "True")
    Else
        WriteSetting "InForm.ini", "InForm Settings", "Keep preview window attached", "True"
        PreviewAttached = True
    End If

    value$ = ReadSetting("InForm.ini", "InForm Settings", "Auto-name controls")
    If Len(value$) Then
        AutoNameControls = (value$ = "True")
    Else
        WriteSetting "InForm.ini", "InForm Settings", "Auto-name controls", "True"
        AutoNameControls = True
    End If

    value$ = ReadSetting("InForm.ini", "InForm Settings", "Snap to edges")
    If Len(value$) Then
        __UI_SnapLines = (value$ = "True")
    Else
        WriteSetting "InForm.ini", "InForm Settings", "Snap to edges", "True"
        __UI_SnapLines = True
    End If

    value$ = ReadSetting("InForm.ini", "InForm Settings", "Show position and size")
    If Len(value$) Then
        __UI_ShowPositionAndSize = (value$ = "True")
    Else
        WriteSetting "InForm.ini", "InForm Settings", "Show position and size", "True"
        __UI_ShowPositionAndSize = True
    End If

    value$ = ReadSetting("InForm.ini", "InForm Settings", "Show invisible controls")
    If Len(value$) Then
        __UI_ShowInvisibleControls = (value$ = "True")
    Else
        WriteSetting "InForm.ini", "InForm Settings", "Show invisible controls", "True"
        __UI_ShowInvisibleControls = True
    End If

    value$ = ReadSetting("InForm.ini", "InForm Settings", "Show font list")
    If Len(value$) Then
        ShowFontList = (value$ = "True")
    Else
        WriteSetting "InForm.ini", "InForm Settings", "Show font list", "True"
        ShowFontList = True
    End If

    $If WIN Then
    $Else
        value$ = ReadSetting("InForm.ini", "InForm Settings", "Swap mouse buttons")
        __UI_MouseButtonsSwap = (value$ = "True")
        Control(OptionsMenuSwapButtons).Value = __UI_MouseButtonsSwap
    $End If

    Control(ViewMenuPreviewDetach).Value = PreviewAttached
    Control(OptionsMenuAutoName).Value = AutoNameControls
    Control(OptionsMenuSnapLines).Value = __UI_SnapLines
    Control(ViewMenuShowPositionAndSize).Value = __UI_ShowPositionAndSize
    Control(ViewMenuShowInvisibleControls).Value = __UI_ShowInvisibleControls

    If _FileExists("UiEditorPreview.frmbin") Then Kill "UiEditorPreview.frmbin"

    b$ = "Parsing command line..."
    GoSub ShowMessage

    If _FileExists(Command$) Then
        Select Case LCase$(Right$(Command$, 4))
            Case ".bas"
                'Does this .bas $include a .frm?
                FreeFileNum = FreeFile
                Dim uB$
                Open Command$ For Binary As #FreeFileNum
                b$ = Space$(LOF(FreeFileNum))
                Get #FreeFileNum, 1, b$
                Seek #FreeFileNum, 1
                If InStr(b$, Chr$(10) + "'$INCLUDE:'InForm\extensions\gifplay.bm'") > 0 Then
                    LoadedWithGifExtension = True
                End If
                Do
                    If EOF(FreeFileNum) Then Exit Do
                    Line Input #FreeFileNum, b$
                    b$ = LTrim$(RTrim$(b$))
                    uB$ = UCase$(b$)
                    IF (LEFT$(b$, 1) = "'" OR LEFT$(uB$, 4) = "REM ") AND _
                    INSTR(uB$, "$INCLUDE") > 0 THEN
                        Dim FirstMark As Integer, SecondMark As Integer
                        FirstMark = InStr(InStr(uB$, "$INCLUDE") + 8, uB$, "'")
                        If FirstMark > 0 Then
                            SecondMark = InStr(FirstMark + 1, uB$, "'")
                            If SecondMark > 0 Then
                                uB$ = Mid$(uB$, FirstMark + 1, SecondMark - FirstMark - 1)
                                If Right$(uB$, 4) = ".FRM" Then
                                    FileToOpen$ = Mid$(b$, FirstMark + 1, SecondMark - FirstMark - 1)

                                    If InStr(Command$, "/") > 0 Or InStr(Command$, "\") > 0 Then
                                        For i = Len(Command$) To 1 Step -1
                                            If Asc(Command$, i) = 92 Or Asc(Command$, i) = 47 Then
                                                FileToOpen$ = Left$(Command$, i - 1) + PathSep$ + FileToOpen$
                                                Exit For
                                            End If
                                        Next
                                    End If

                                    Exit Do
                                End If
                            End If
                        End If
                    End If
                Loop
                Close #FreeFileNum
            Case Else
                If LCase$(Right$(Command$, 7)) = ".frmbin" Or LCase$(Right$(Command$, 4)) = ".frm" Then
                    FileToOpen$ = Command$
                    If _FileExists(Left$(FileToOpen$, Len(FileToOpen$) - 4) + ".bas") Then
                        FreeFileNum = FreeFile
                        Open Left$(FileToOpen$, Len(FileToOpen$) - 4) + ".bas" For Binary As #FreeFileNum
                        b$ = Space$(LOF(FreeFileNum))
                        Get #FreeFileNum, 1, b$
                        Close #FreeFileNum
                        If InStr(b$, Chr$(10) + "'$INCLUDE:'InForm\extensions\gifplay.bm'") > 0 Then
                            LoadedWithGifExtension = True
                        End If
                    End If
                End If
        End Select

        If Len(FileToOpen$) > 0 Then
            If InStr(FileToOpen$, "/") > 0 Or InStr(FileToOpen$, "\") > 0 Then
                For i = Len(FileToOpen$) To 1 Step -1
                    If Asc(FileToOpen$, i) = 92 Or Asc(FileToOpen$, i) = 47 Then
                        CurrentPath$ = Left$(FileToOpen$, i - 1)
                        ThisFileName$ = Mid$(FileToOpen$, i + 1)
                        Exit For
                    End If
                Next
            Else
                ThisFileName$ = FileToOpen$
            End If
            FreeFileNum = FreeFile
            Open FileToOpen$ For Binary As #FreeFileNum
            b$ = Space$(LOF(FreeFileNum))
            Get #FreeFileNum, 1, b$
            Close #FreeFileNum

            Open "UiEditorPreview.frmbin" For Binary As #FreeFileNum
            Put #FreeFileNum, 1, b$
            Close #FreeFileNum
            If LoadedWithGifExtension = False Then
                LoadedWithGifExtension = 1 'Query whether this file contains the gif extension
                Control(AddGifExtensionToggle).Value = False
            Else
                Control(AddGifExtensionToggle).Value = True
            End If
            AddToRecentList FileToOpen$
        End If
    End If

    b$ = "Checking Preview component..."
    GOSUB ShowMessage
    $IF WIN THEN              
		IF _FileExists("UiEditorPreview.exe") = 0 THEN GOTO UiEditorPreviewNotFound
    $ELSE
        IF _FILEEXISTS("UiEditorPreview") = 0 THEN GOTO UiEditorPreviewNotFound
    $END IF

    b$ = "Reading directory..."
    GoSub ShowMessage
    'Fill "open dialog" listboxes:
    '-------------------------------------------------
    Dim TotalFiles%
    If CurrentPath$ = "" Then CurrentPath$ = _StartDir$
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
    GoSub ShowMessage
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

    ReDim _Preserve InputBox(1 To i) As newInputBox
    ReDim InputBoxText(1 To i) As String

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
    ReDim _Preserve Toggles(1 To i) As Long

    ToolTip(FontTB) = "Multiple fonts can be specified by separating them with a question mark (?)." + Chr$(10) + "The first font that can be found/loaded is used."
    ToolTip(FontList) = "System fonts may not be available in all computers. To specify a local font file, right-click 'Font' to the left of this list and disable 'Show system fonts list'."
    ToolTip(ColorPreview) = "Click to copy the current color's hex value to the clipboard."
    ToolTip(KeyboardComboBT) = "Click to assign a key combination to the selected control"

    StatusBarBackColor = Darken(__UI_DefaultColor(__UI_Type_Form, 2), 90)
    Control(StatusBar).BackColor = StatusBarBackColor

    For i = 1 To 9
        RecentMenuItem(i) = __UI_GetID("FileMenuRecent" + LTrim$(Str$(i)))
    Next

    b$ = "Loading images..."
    GoSub ShowMessage

    'Load toolbox images:
    Dim CommControls As Long
    CommControls = LoadEditorImage("commoncontrols.bmp")
    __UI_ClearColor CommControls, 0, 0

    i = 0
    Control(AddButton).HelperCanvas = _NewImage(16, 16, 32)
    i = i + 1: _PutImage (0, 0), CommControls, Control(AddButton).HelperCanvas, (0, i * 16 - 16)-Step(15, 15)
    Control(AddLabel).HelperCanvas = _NewImage(16, 16, 32)
    i = i + 1: _PutImage (0, 0), CommControls, Control(AddLabel).HelperCanvas, (0, i * 16 - 16)-Step(15, 15)
    Control(AddTextBox).HelperCanvas = _NewImage(16, 16, 32)
    i = i + 1: _PutImage (0, 0), CommControls, Control(AddTextBox).HelperCanvas, (0, i * 16 - 16)-Step(15, 15)
    Control(AddCheckBox).HelperCanvas = _NewImage(16, 16, 32)
    i = i + 1: _PutImage (0, 0), CommControls, Control(AddCheckBox).HelperCanvas, (0, i * 16 - 16)-Step(15, 15)
    Control(AddRadioButton).HelperCanvas = _NewImage(16, 16, 32)
    i = i + 1: _PutImage (0, 0), CommControls, Control(AddRadioButton).HelperCanvas, (0, i * 16 - 16)-Step(15, 15)
    Control(AddListBox).HelperCanvas = _NewImage(16, 16, 32)
    i = i + 1: _PutImage (0, 0), CommControls, Control(AddListBox).HelperCanvas, (0, i * 16 - 16)-Step(15, 15)
    Control(AddDropdownList).HelperCanvas = _NewImage(16, 16, 32)
    i = i + 1: _PutImage (0, 0), CommControls, Control(AddDropdownList).HelperCanvas, (0, i * 16 - 16)-Step(15, 15)
    Control(AddTrackBar).HelperCanvas = _NewImage(16, 16, 32)
    i = i + 1: _PutImage (0, 0), CommControls, Control(AddTrackBar).HelperCanvas, (0, i * 16 - 16)-Step(15, 15)
    Control(AddProgressBar).HelperCanvas = _NewImage(16, 16, 32)
    i = i + 1: _PutImage (0, 0), CommControls, Control(AddProgressBar).HelperCanvas, (0, i * 16 - 16)-Step(15, 15)
    Control(AddPictureBox).HelperCanvas = _NewImage(16, 16, 32)
    i = i + 1: _PutImage (0, 0), CommControls, Control(AddPictureBox).HelperCanvas, (0, i * 16 - 16)-Step(15, 15)
    Control(AddFrame).HelperCanvas = _NewImage(16, 16, 32)
    i = i + 1: _PutImage (0, 0), CommControls, Control(AddFrame).HelperCanvas, (0, i * 16 - 16)-Step(15, 15)

    'Draw ToggleSwitch icon
    prevDest = _Dest
    Control(AddToggleSwitch).HelperCanvas = _NewImage(16, 16, 32)
    _Dest Control(AddToggleSwitch).HelperCanvas
    Line (2, 4)-(13, 11), _RGB32(0, 128, 255), BF
    Line (2, 4)-(13, 11), _RGB32(170, 170, 170), B
    Line (8, 6)-(11, 9), _RGB32(255, 255, 255), BF

    'Draw AddNumericBox icon
    Control(AddNumericBox).HelperCanvas = _NewImage(16, 16, 32)
    _Dest Control(AddNumericBox).HelperCanvas
    _Font 8
    Line (1, 3)-(15, 13), _RGB32(255, 255, 255), BF
    Line (1, 3)-(15, 13), _RGB32(132, 165, 189), B
    Color _RGB32(55, 55, 55), _RGBA32(0, 0, 0, 0)
    __UI_PrintString 5, 3, "#"

    'Draw PasteListBT icon
    Control(PasteListBT).HelperCanvas = _NewImage(17, 17, 32)
    _Dest Control(PasteListBT).HelperCanvas
    _Font 16
    For i = 4 To 15 Step 4
        Line (3, i)-Step(_Width - 6, 1), _RGB32(122, 122, 122), BF
    Next

    'Import Align menu icons from InForm.ui
    Control(AlignMenuAlignLeft).HelperCanvas = Control(__UI_GetID("__UI_PreviewMenuAlignLeft")).HelperCanvas
    Control(AlignMenuAlignRight).HelperCanvas = Control(__UI_GetID("__UI_PreviewMenuAlignRight")).HelperCanvas
    Control(AlignMenuAlignTops).HelperCanvas = Control(__UI_GetID("__UI_PreviewMenuAlignTops")).HelperCanvas
    Control(AlignMenuAlignBottoms).HelperCanvas = Control(__UI_GetID("__UI_PreviewMenuAlignBottoms")).HelperCanvas
    Control(AlignMenuAlignCentersV).HelperCanvas = Control(__UI_GetID("__UI_PreviewMenuAlignCentersV")).HelperCanvas
    Control(AlignMenuAlignCentersH).HelperCanvas = Control(__UI_GetID("__UI_PreviewMenuAlignCentersH")).HelperCanvas

    _Dest prevDest

    Control(FileMenuSave).HelperCanvas = LoadEditorImage("disk.png")

    _FreeImage CommControls

    b$ = "Launching Preview component..."
    GoSub ShowMessage
    $If WIN Then
        Shell _DontWait ".\UiEditorPreview.exe " + HostPort
    $Else
            SHELL _DONTWAIT "./UiEditorPreview " + HostPort
    $End If

    b$ = "Connecting to preview component..."
    GoSub ShowMessage
    Do
        Client = _OpenConnection(Host)
        If Client Then Exit Do
        If _Exit Then System 'Can't force user to wait...
        _Display
        _Limit 15
    Loop

    b$ = "Connected! Handshaking..."
    GoSub ShowMessage
    Handshake

    __UI_RefreshMenuBar
    __UI_ForceRedraw = True
    _FreeImage tempIcon

    _AcceptFileDrop

    Exit Sub
    UiEditorPreviewNotFound:
    i = MessageBox("UiEditorPreview component not found or failed to load.", "UiEditor", MsgBox_OkOnly + MsgBox_Critical)
    System

    ShowMessage:
    Dim PreserveDestMessage As Long
    PreserveDestMessage = _Dest
    _Dest 0
    _Font Control(__UI_FormID).Font
    If tempIcon < -1 Then
        Cls , _RGB32(255, 255, 255)
        _PutImage (_Width / 2 - _Width(tempIcon) / 2, _Height / 2 - _Height(tempIcon) / 2), tempIcon
        Color __UI_DefaultColor(__UI_Type_Form, 1), _RGBA32(0, 0, 0, 0)
        __UI_PrintString _Width \ 2 - _PrintWidth(b$) \ 2, _Height / 2 + _Height(tempIcon) / 2 + _FontHeight, b$
        _Display
    Else
        Cls , __UI_DefaultColor(__UI_Type_Form, 2)
        Color __UI_DefaultColor(__UI_Type_Form, 1), _RGBA32(0, 0, 0, 0)
        __UI_PrintString _Width \ 2 - _PrintWidth(b$) \ 2, _Height \ 2 - _FontHeight \ 2, b$
    End If
    _Display
    _Dest PreserveDestMessage
    Return
End Sub

Sub __UI_KeyPress (id As Long)
    Dim i As Long
    LastKeyPress = Timer
    Select EveryCase id
        Case RedValue, GreenValue, BlueValue
            Dim TempID As Long
            If __UI_KeyHit = 18432 Then
                If Val(Text(id)) < 255 Then
                    Text(id) = LTrim$(Str$(Val(Text(id)) + 1))
                End If
                SelectPropertyFully id
                TempID = __UI_GetID(Left$(UCase$(RTrim$(Control(id).Name)), Len(UCase$(RTrim$(Control(id).Name))) - 5))
                Control(TempID).Value = Val(Text(id))
                SendNewRGB
            ElseIf __UI_KeyHit = 20480 Then
                If Val(Text(id)) > 0 Then
                    Text(id) = LTrim$(Str$(Val(Text(id)) - 1))
                End If
                SelectPropertyFully id
                TempID = __UI_GetID(Left$(UCase$(RTrim$(Control(id).Name)), Len(UCase$(RTrim$(Control(id).Name))) - 5))
                Control(TempID).Value = Val(Text(id))
                SendNewRGB
            ElseIf __UI_KeyHit = 13 Then
                TempID = __UI_GetID(Left$(UCase$(RTrim$(Control(id).Name)), Len(UCase$(RTrim$(Control(id).Name))) - 5))
                Control(TempID).Value = Val(Text(id))
                SendNewRGB
                SelectPropertyFully id
            End If
            Caption(StatusBar) = "Color changed."
        Case FileNameTextBox
            If OpenDialogOpen Then
                If __UI_KeyHit = 27 Then
                    __UI_KeyHit = 0
                    __UI_Click CancelBT
                ElseIf __UI_KeyHit = 13 Then
                    __UI_KeyHit = 0
                    If Caption(OpenFrame) = "Open" Then
                        __UI_Click OpenBT
                    Else
                        __UI_Click SaveBT
                    End If
                ElseIf __UI_KeyHit = 18432 Or __UI_KeyHit = 20480 Then
                    If Control(FileList).Max > 0 Then __UI_Focus = FileList
                Else
                    If Control(FileList).Max > 0 Then
                        Select Case __UI_KeyHit
                            Case 48 To 57, 65 To 90, 97 To 122 'Alphanumeric
                                If Caption(OpenFrame) = "Open" Then
                                    __UI_ListBoxSearchItem Control(FileList)
                                End If
                        End Select
                    End If
                End If
            End If
        Case FileList, DirList, CancelBT, OpenBT, SaveBT, ShowOnlyFrmbinFilesCB, SaveFrmOnlyCB
            If __UI_KeyHit = 27 Then
                __UI_Click CancelBT
            End If
        Case FileList
            If __UI_KeyHit = 13 Then
                __UI_KeyHit = 0
                If Caption(OpenFrame) = "Open" Then
                    __UI_Click OpenBT
                Else
                    __UI_Click SaveBT
                End If
            End If
        Case ControlList, UpBT, DownBT, CloseZOrderingBT
            If __UI_KeyHit = 27 Then
                __UI_Click CloseZOrderingBT
            End If
        Case NameTB, CaptionTB, TextTB, MaskTB, TopTB, LeftTB, WidthTB, HeightTB, FontTB, TooltipTB, ValueTB, MinTB, MaxTB, IntervalTB, PaddingTB, MinIntervalTB, SizeTB
            If __UI_KeyHit = 13 Then
                'Send the preview the new property value
                ConfirmEdits id
            ElseIf __UI_KeyHit = 32 Then
                If id = NameTB Then
                    __UI_KeyHit = 0
                    Caption(StatusBar) = "Control names cannot contain spaces"
                    BlinkStatusBar = Timer
                Else
                    InputBox(GetInputBoxFromID(id)).Sent = False
                    Send Client, "LOCKCONTROLS><END>"
                End If
            ElseIf __UI_KeyHit = 27 Then
                RevertEdit = True
                Caption(StatusBar) = "Previous property value restored."
            Else
                InputBox(GetInputBoxFromID(id)).Sent = False
                Send Client, "LOCKCONTROLS><END>"
            End If
        Case KeyboardComboBT
            Dim Combo$
            If __UI_CtrlIsDown Then Combo$ = "Ctrl+"
            If __UI_ShiftIsDown Then Combo$ = Combo$ + "Shift+"
            Select Case __UI_KeyHit
                Case 27
                    __UI_Focus = 0
                    __UI_BypassKeyCombos = False
                    ToolTip(KeyboardComboBT) = "Click to assign a key combination to the selected control"
                    SendData MKI$(0), 43
                    __UI_ForceRedraw = True
                CASE __UI_FKey(1), __UI_FKey(2), __UI_FKey(3), __UI_FKey(4), __UI_FKey(5), __UI_FKey(6), _
                     __UI_FKey(7), __UI_FKey(8), __UI_FKey(9), __UI_FKey(10), __UI_FKey(11), __UI_FKey(12)
                    For i = 1 To 12
                        If __UI_FKey(i) = __UI_KeyHit Then
                            Combo$ = Combo$ + "F" + LTrim$(Str$(i))
                            SendData MKI$(Len(Combo$)) + Combo$, 43
                            __UI_Focus = 0
                            __UI_BypassKeyCombos = False
                            ToolTip(KeyboardComboBT) = "Click to assign a key combination to the selected control"
                            __UI_ForceRedraw = True
                            Exit For
                        End If
                    Next
                Case 65 To 90, 97 To 122 'Alphanumeric
                    Combo$ = Combo$ + UCase$(Chr$(__UI_KeyHit))
                    If InStr(Combo$, "Ctrl+") > 0 Then
                        SendData MKI$(Len(Combo$)) + Combo$, 43
                        __UI_Focus = 0
                        __UI_BypassKeyCombos = False
                        ToolTip(KeyboardComboBT) = "Click to assign a key combination to the selected control"
                        __UI_ForceRedraw = True
                    End If
            End Select
    End Select
End Sub

Sub ConfirmEdits (id As Long)
    Dim b$, TempValue As Long

    IF InputBoxText(GetInputBoxFromID(id)) <> Text(id) AND _
       InputBox(GetInputBoxFromID(id)).Sent = False THEN
        Select Case InputBox(GetInputBoxFromID(id)).DataType
            Case DT_Text
                b$ = MKL$(Len(Text(id))) + Text(id)
            Case DT_Integer
                b$ = MKI$(Val(Text(id)))
            Case DT_Float
                b$ = _MK$(_Float, Val(Text(id)))
        End Select
        TempValue = GetPropertySignal(id)
        SendData b$, TempValue
        PropertySent = True
        Text(id) = RestoreCHR(Text(id))
        SelectPropertyFully id
        InputBoxText(GetInputBoxFromID(id)) = Text(id)
        InputBox(GetInputBoxFromID(id)).LastEdited = Timer
        InputBox(GetInputBoxFromID(id)).Sent = True
        Caption(StatusBar) = "Ready."
    End If
End Sub

Function GetPropertySignal& (id As Long)
    Dim i As Long
    For i = 1 To UBound(InputBox)
        If InputBox(i).ID = id Then GetPropertySignal& = InputBox(i).Signal: Exit Function
    Next
End Function

Function GetInputBoxFromID& (id As Long)
    Dim i As Long
    For i = 1 To UBound(InputBox)
        If InputBox(i).ID = id Then GetInputBoxFromID& = i: Exit Function
    Next
End Function

Sub __UI_TextChanged (id As Long)
    Select Case id
        Case RedValue, GreenValue, BlueValue
            Dim TempID As Long
            TempID = __UI_GetID(Left$(UCase$(RTrim$(Control(id).Name)), Len(UCase$(RTrim$(Control(id).Name))) - 5))
            Control(TempID).Value = Val(Text(id))
        Case FileNameTextBox
            PreselectFile
    End Select
End Sub

Sub __UI_ValueChanged (id As Long)
    If __UI_StateHasChanged Then Exit Sub 'skip values changed programmatically

    Dim b$, i As Long
    Select EveryCase id
        Case AlignOptions
            If __UI_Focus <> id Then Exit Sub
            b$ = MKI$(Control(AlignOptions).Value - 1)
            SendData b$, 22
            PropertySent = True
        Case VAlignOptions
            If __UI_Focus <> id Then Exit Sub
            b$ = MKI$(Control(VAlignOptions).Value - 1)
            SendData b$, 32
            PropertySent = True
        Case BulletOptions
            If __UI_Focus <> id Then Exit Sub
            b$ = MKI$(Control(BulletOptions).Value - 1)
            SendData b$, 37
            PropertySent = True
        Case BooleanOptions
            b$ = _MK$(_Float, -(Control(BooleanOptions).Value - 1))
            SendData b$, GetPropertySignal(BooleanOptions)
            PropertySent = True
        Case ContextMenuControlsList
            i = Control(ContextMenuControlsList).Value
            If i > 1 Then
                b$ = GetItem(ContextMenuControlsList, i)
                b$ = MKI$(Len(b$)) + b$
            Else
                b$ = MKI$(0)
            End If
            SendData b$, 41
        Case FontList, FontSizeList
            b$ = FontFile(Control(FontList).Value) + "," + GetItem$(FontSizeList, Control(FontSizeList).Value)
            b$ = MKL$(Len(b$)) + b$
            SendData b$, 8
            PropertySent = True
        Case Red
            Text(RedValue) = LTrim$(Str$(Control(Red).Value))
        Case Green
            Text(GreenValue) = LTrim$(Str$(Control(Green).Value))
        Case Blue
            Text(BlueValue) = LTrim$(Str$(Control(Blue).Value))
        Case ControlList
            Control(UpBT).Disabled = False
            Control(DownBT).Disabled = False
            If Control(ControlList).Value = 1 Then
                Control(UpBT).Disabled = True
            ElseIf Control(ControlList).Value = 0 Then
                Control(UpBT).Disabled = True
                Control(DownBT).Disabled = True
            ElseIf Control(ControlList).Value = Control(ControlList).Max Then
                Control(DownBT).Disabled = True
            End If
            If Control(ControlList).Value > 0 Then
                b$ = MKL$(zOrderIDs(Control(ControlList).Value))
            Else
                b$ = MKL$(0)
            End If
            SendData b$, 213
        Case FileList
            Text(FileNameTextBox) = GetItem(FileList, Control(FileList).Value)
        Case NameTB, CaptionTB, TextTB, MaskTB, TopTB, LeftTB, WidthTB, HeightTB, FontTB, TooltipTB, ValueTB, MinTB, MaxTB, IntervalTB, PaddingTB, MinIntervalTB, SizeTB
            Send Client, "LOCKCONTROLS><END>"
    End Select
End Sub

Sub PreselectFile
    Dim b$
    b$ = GetItem(FileList, Control(FileList).Value)
    If LCase$(Text(FileNameTextBox)) = LCase$(Left$(b$, Len(Text(FileNameTextBox)))) Then
        Text(FileNameTextBox) = Text(FileNameTextBox) + Mid$(b$, Len(Text(FileNameTextBox)) + 1)
        Control(FileNameTextBox).TextIsSelected = True
        Control(FileNameTextBox).SelectionStart = Len(Text(FileNameTextBox))
    End If
End Sub

Function EditorImageData$ (FileName$)
    Dim A$

    Select Case LCase$(FileName$)
        Case "disk.png"
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
        Case "commoncontrols.bmp"
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
    End Select

    EditorImageData$ = A$
End Function

'---------------------------------------------------------------------------------
Function LoadEditorImage& (FileName$)
    Dim MemoryBlock As _MEM, TempImage As Long
    Dim NewWidth As Integer, NewHeight As Integer, A$, BASFILE$

    A$ = EditorImageData$(FileName$)
    If Len(A$) = 0 Then Exit Function

    NewWidth = CVI(Left$(A$, 2))
    NewHeight = CVI(Mid$(A$, 3, 2))
    A$ = Mid$(A$, 5)

    BASFILE$ = Unpack$(A$)

    TempImage = _NewImage(NewWidth, NewHeight, 32)
    MemoryBlock = _MemImage(TempImage)

    __UI_MemCopy MemoryBlock.OFFSET, _Offset(BASFILE$), Len(BASFILE$)
    _MemFree MemoryBlock

    LoadEditorImage& = TempImage
End Function

Function Unpack$ (PackedData$)
    'Adapted from Dav's BIN2BAS
    'http://www.qbasicnews.com/dav/qb64.php
    Dim A$, i&, B$, C%, F$, C$, t%, B&, X$, btemp$

    A$ = PackedData$

    For i& = 1 To Len(A$) Step 4: B$ = Mid$(A$, i&, 4)
        If InStr(1, B$, "%") Then
            For C% = 1 To Len(B$): F$ = Mid$(B$, C%, 1)
                If F$ <> "%" Then C$ = C$ + F$
            Next: B$ = C$
            End If: For t% = Len(B$) To 1 Step -1
            B& = B& * 64 + Asc(Mid$(B$, t%)) - 48
            Next: X$ = "": For t% = 1 To Len(B$) - 1
            X$ = X$ + Chr$(B& And 255): B& = B& \ 256
    Next: btemp$ = btemp$ + X$: Next

    Unpack$ = btemp$
End Function

Function ReadSequential$ (Txt$, Bytes%)
    ReadSequential$ = Left$(Txt$, Bytes%)
    Txt$ = Mid$(Txt$, Bytes% + 1)
End Function

Sub LoadPreview
    Dim b$, __UI_EOF As _Byte, Answer As _Byte
    Dim NewType As Integer, NewWidth As Integer, NewHeight As Integer
    Dim NewLeft As Integer, NewTop As Integer, NewName As String
    Dim NewParentID As String, FloatValue As _Float, Dummy As Long
    Dim FormData$
    Static PrevTotalGifLoaded As Long

    Timer(__UI_EventsTimer) Off
    Timer(__UI_RefreshTimer) Off

    FormData$ = LastFormData$

    AddGifExtension = False
    TotalGifLoaded = 0
    If LoadedWithGifExtension = 1 Then PrevTotalGifLoaded = 0

    b$ = ReadSequential$(FormData$, 4)

    ReDim PreviewCaptions(0 To CVL(b$)) As String
    ReDim PreviewTexts(0 To CVL(b$)) As String
    ReDim PreviewMasks(0 To CVL(b$)) As String
    ReDim PreviewTips(0 To CVL(b$)) As String
    ReDim PreviewFonts(0 To CVL(b$)) As String
    ReDim PreviewActualFonts(0 To CVL(b$)) As String
    ReDim PreviewControls(0 To CVL(b$)) As __UI_ControlTYPE
    ReDim PreviewParentIDS(0 To CVL(b$)) As String
    ReDim PreviewContextMenu(0 To CVL(b$)) As String
    ReDim PreviewBoundTo(0 To CVL(b$)) As String
    ReDim PreviewBoundProperty(0 To CVL(b$)) As String
    ReDim PreviewKeyCombos(0 To CVL(b$)) As String
    ReDim PreviewAnimatedGif(0 To CVL(b$)) As _Byte
    ReDim PreviewAutoPlayGif(0 To CVL(b$)) As _Byte

    ResetList ContextMenuControlsList
    AddItem ContextMenuControlsList, "(none)"

    b$ = ReadSequential$(FormData$, 2)
    If CVI(b$) <> -1 Then GoTo LoadError
    Do
        b$ = ReadSequential$(FormData$, 4)
        Dummy = CVL(b$)
        If Dummy <= 0 Or Dummy > UBound(PreviewControls) Then Exit Do 'Corrupted exchange file.
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
        If CVI(b$) > 0 Then
            NewParentID = ReadSequential$(FormData$, CVI(b$))
        Else
            NewParentID = ""
        End If

        If NewType = __UI_Type_ContextMenu Then
            AddItem ContextMenuControlsList, NewName
        End If

        PreviewControls(Dummy).ID = Dummy
        PreviewParentIDS(Dummy) = RTrim$(NewParentID)
        PreviewControls(Dummy).Type = NewType
        PreviewControls(Dummy).Name = NewName
        PreviewControls(Dummy).Width = NewWidth
        PreviewControls(Dummy).Height = NewHeight
        PreviewControls(Dummy).Left = NewLeft
        PreviewControls(Dummy).Top = NewTop

        Do 'read properties
            b$ = ReadSequential$(FormData$, 2)
            Select Case CVI(b$)
                Case -2 'Caption
                    b$ = ReadSequential$(FormData$, 4)
                    b$ = ReadSequential$(FormData$, CVL(b$))
                    PreviewCaptions(Dummy) = b$
                Case -3 'Text
                    b$ = ReadSequential$(FormData$, 4)
                    b$ = ReadSequential$(FormData$, CVL(b$))
                    PreviewTexts(Dummy) = b$
                Case -4 'Stretch
                    PreviewControls(Dummy).Stretch = True
                Case -5 'Font
                    Dim FontSetup$
                    Dim NewFontSize$
                    b$ = ReadSequential$(FormData$, 2)
                    FontSetup$ = ReadSequential$(FormData$, CVI(b$))
                    PreviewFonts(Dummy) = FontSetup$
                    NewFontSize$ = Mid$(FontSetup$, InStr(FontSetup$, ","))
                    b$ = ReadSequential$(FormData$, 2)
                    FontSetup$ = ReadSequential$(FormData$, CVI(b$))
                    PreviewActualFonts(Dummy) = FontSetup$ + NewFontSize$
                Case -6 'ForeColor
                    b$ = ReadSequential$(FormData$, 4)
                    PreviewControls(Dummy).ForeColor = _CV(_Unsigned Long, b$)
                Case -7 'BackColor
                    b$ = ReadSequential$(FormData$, 4)
                    PreviewControls(Dummy).BackColor = _CV(_Unsigned Long, b$)
                Case -8 'SelectedForeColor
                    b$ = ReadSequential$(FormData$, 4)
                    PreviewControls(Dummy).SelectedForeColor = _CV(_Unsigned Long, b$)
                Case -9 'SelectedBackColor
                    b$ = ReadSequential$(FormData$, 4)
                    PreviewControls(Dummy).SelectedBackColor = _CV(_Unsigned Long, b$)
                Case -10 'BorderColor
                    b$ = ReadSequential$(FormData$, 4)
                    PreviewControls(Dummy).BorderColor = _CV(_Unsigned Long, b$)
                Case -11
                    PreviewControls(Dummy).BackStyle = __UI_Transparent
                Case -12
                    PreviewControls(Dummy).HasBorder = True
                Case -13
                    b$ = ReadSequential$(FormData$, 1)
                    PreviewControls(Dummy).Align = _CV(_Byte, b$)
                Case -14
                    b$ = ReadSequential$(FormData$, Len(FloatValue))
                    PreviewControls(Dummy).Value = _CV(_Float, b$)
                Case -15
                    b$ = ReadSequential$(FormData$, Len(FloatValue))
                    PreviewControls(Dummy).Min = _CV(_Float, b$)
                Case -16
                    b$ = ReadSequential$(FormData$, Len(FloatValue))
                    PreviewControls(Dummy).Max = _CV(_Float, b$)
                Case -19
                    PreviewControls(Dummy).ShowPercentage = True
                Case -20
                    PreviewControls(Dummy).CanHaveFocus = True
                Case -21
                    PreviewControls(Dummy).Disabled = True
                Case -22
                    PreviewControls(Dummy).Hidden = True
                Case -23
                    PreviewControls(Dummy).CenteredWindow = True
                Case -24 'Tips
                    b$ = ReadSequential$(FormData$, 4)
                    b$ = ReadSequential$(FormData$, CVL(b$))
                    PreviewTips(Dummy) = b$
                Case -25 'ContextMenu
                    b$ = ReadSequential$(FormData$, 2)
                    b$ = ReadSequential$(FormData$, CVI(b$))
                    PreviewContextMenu(Dummy) = b$
                Case -26
                    b$ = ReadSequential$(FormData$, Len(FloatValue))
                    PreviewControls(Dummy).Interval = _CV(_Float, b$)
                Case -27
                    PreviewControls(Dummy).WordWrap = True
                Case -29
                    PreviewControls(Dummy).CanResize = True
                Case -31
                    b$ = ReadSequential$(FormData$, 2)
                    PreviewControls(Dummy).Padding = CVI(b$)
                Case -32
                    b$ = ReadSequential$(FormData$, 1)
                    PreviewControls(Dummy).VAlign = _CV(_Byte, b$)
                Case -33
                    PreviewControls(Dummy).PasswordField = True
                Case -34
                    b$ = ReadSequential$(FormData$, 4)
                    PreviewControls(Dummy).Encoding = CVL(b$)
                Case -35
                    PreviewDefaultButtonID = Dummy
                Case -36 'Mask
                    b$ = ReadSequential$(FormData$, 4)
                    b$ = ReadSequential$(FormData$, CVL(b$))
                    PreviewMasks(Dummy) = b$
                Case -37
                    b$ = ReadSequential$(FormData$, Len(FloatValue))
                    PreviewControls(Dummy).MinInterval = _CV(_Float, b$)
                Case -38
                    PreviewControls(Dummy).NumericOnly = True
                Case -39
                    PreviewControls(Dummy).NumericOnly = __UI_NumericWithBounds
                Case -40
                    PreviewControls(Dummy).BulletStyle = __UI_Bullet
                Case -41
                    PreviewControls(Dummy).AutoScroll = True
                Case -42
                    PreviewControls(Dummy).AutoSize = True
                Case -43
                    b$ = ReadSequential$(FormData$, 2)
                    PreviewControls(Dummy).BorderSize = CVI(b$)
                Case -44 'Key combo
                    b$ = ReadSequential$(FormData$, 2)
                    b$ = ReadSequential$(FormData$, CVI(b$))
                    PreviewKeyCombos(Dummy) = b$
                Case -45 'Animated Gif
                    PreviewAnimatedGif(Dummy) = True
                    TotalGifLoaded = TotalGifLoaded + 1
                    AddGifExtension = True
                    If LoadedWithGifExtension = 1 Then
                        LoadedWithGifExtension = True
                        Control(AddGifExtensionToggle).Value = True
                    End If
                Case -46 'Auto-play Gif
                    PreviewAutoPlayGif(Dummy) = True
                Case -47 'ControlIsSelected
                    PreviewControls(Dummy).ControlIsSelected = True
                Case -48 'BoundTo
                    b$ = ReadSequential$(FormData$, 2)
                    b$ = ReadSequential$(FormData$, CVI(b$))
                    PreviewBoundTo(Dummy) = b$
                    b$ = ReadSequential$(FormData$, 2)
                    b$ = ReadSequential$(FormData$, CVI(b$))
                    PreviewBoundProperty(Dummy) = b$
                Case -1 'new control
                    Exit Do
                Case -1024
                    __UI_EOF = True
                    Exit Do
                Case Else
                    Exit Do
            End Select
        Loop
    Loop Until __UI_EOF
    LoadError:
    Timer(__UI_EventsTimer) On
    Timer(__UI_RefreshTimer) On
    If LoadedWithGifExtension = 1 Then LoadedWithGifExtension = False
    If PrevTotalGifLoaded <> TotalGifLoaded Then
        If PrevTotalGifLoaded = 0 And LoadedWithGifExtension = False Then
            Answer = MessageBox("You loaded an animated GIF file.\nDo you want to include the GIF extension?", "", MsgBox_YesNo + MsgBox_Question)
            If Answer = MsgBox_Yes Then
                Control(AddGifExtensionToggle).Value = True
            Else
                b$ = "PAUSEALLGIF>" + "<END>"
                Send Client, b$
                Control(AddGifExtensionToggle).Value = False
            End If
        End If
        PrevTotalGifLoaded = TotalGifLoaded
    End If
End Sub

Sub SendData (b$, Property As Integer)
    'IF PreviewSelectionRectangle THEN EXIT SUB
    b$ = "PROPERTY>" + MKI$(Property) + b$ + "<END>"
    Send Client, b$
End Sub

Sub Send (channel As Long, b$)
    totalBytesSent = totalBytesSent + Len(b$)
    Put #channel, , b$
End Sub

Sub SendSignal (Value As Integer)
    Dim b$
    b$ = "SIGNAL>" + MKI$(Value) + "<END>"
    Send Client, b$
End Sub

Sub UpdateColorPreview (Attribute As _Byte, ForeColor As _Unsigned Long, BackColor As _Unsigned Long)
    _Dest Control(ColorPreview).HelperCanvas
    _Font Control(ColorPreview).Font
    If Attribute = 5 Then
        Cls , BackColor
        Line (20, 20)-Step(_Width - 41, _Height - 41), ForeColor, B
        Line (21, 21)-Step(_Width - 43, _Height - 43), ForeColor, B
        ColorPreviewWord$ = "#" + Mid$(Hex$(ForeColor), 3)
        Color ForeColor, BackColor
        __UI_PrintString _Width \ 2 - _PrintWidth(ColorPreviewWord$) \ 2, _Height \ 2 - _FontHeight \ 2, ColorPreviewWord$
    Else
        Cls , BackColor
        Color ForeColor, BackColor
        Select Case Attribute
            Case 1, 3
                ColorPreviewWord$ = "FG: #" + Mid$(Hex$(ForeColor), 3)
            Case 2, 4
                ColorPreviewWord$ = "BG: #" + Mid$(Hex$(BackColor), 3)
        End Select
        __UI_PrintString _Width \ 2 - _PrintWidth(ColorPreviewWord$) \ 2, _Height \ 2 - _FontHeight \ 2, ColorPreviewWord$
        ColorPreviewWord$ = Mid$(ColorPreviewWord$, 5)
    End If
    _Dest 0
    Control(ColorPreview).Redraw = True 'Force update
End Sub

Sub QuickColorPreview (ThisColor As _Unsigned Long)
    _Dest Control(ColorPreview).HelperCanvas
    Cls , __UI_DefaultColor(__UI_Type_Form, 2)
    Line (0, 0)-Step(_Width, _Height / 2), ThisColor, BF
    Line (0, _Height / 2)-Step(_Width, _Height / 2), OldColor, BF
    _Dest 0
    Control(ColorPreview).Redraw = True 'Force update
End Sub

Sub CheckPreview
    'Check if the preview window is still alive
    Dim b$

    If OpenDialogOpen Then Exit Sub

    $If WIN Then
        Dim hnd&, b&, c&, ExitCode&
        If UiPreviewPID > 0 Then
            hnd& = OpenProcess(&H400, 0, UiPreviewPID)
            b& = GetExitCodeProcess(hnd&, ExitCode&)
            c& = CloseHandle(hnd&)
            If b& = 1 And ExitCode& = 259 Then
                'Preview is active.
                Control(ViewMenuPreview).Disabled = True
            Else
                'Preview was closed.

                Timer(__UI_EventsTimer) Off

                __UI_WaitMessage = "Reloading preview window..."
                UiPreviewPID = 0
                __UI_ProcessInputTimer = 0 'Make the "Please wait" message show up immediataly

                Close Client
                Client = 0

                __UI_UpdateDisplay

                Shell _DontWait ".\UiEditorPreview.exe " + HostPort

                Do
                    Client = _OpenConnection(Host)
                    If Client Then Exit Do
                    If _Exit Then System 'Can't force user to wait...
                    _Display
                    _Limit 15
                Loop

                Handshake

                If Len(LastFormData$) Then
                    b$ = "RESTORECRASH>" + LastFormData$ + "<END>"
                    Send Client, b$
                    prevScreenX = -1
                    prevScreenY = -1
                    UndoPointer = 0
                    TotalUndoImages = 0
                End If

                Timer(__UI_EventsTimer) On
            End If
        End If
    $Else
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

            SHELL _DONTWAIT "./UiEditorPreview " + HostPort

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
    $End If
End Sub

Sub SaveForm (ExitToQB64 As _Byte, SaveOnlyFrm As _Byte)
    Dim BaseOutputFileName As String, j As Long
    Dim TextFileNum As Integer, Answer As _Byte, b$, i As Long
    Dim a$, FontSetup$, FindSep As Integer, NewFontFile As String
    Dim Dummy As Long, BackupFile$
    Dim PreserveBackup As _Byte, BackupCode$
    Dim tempThisFileName$

    tempThisFileName$ = ThisFileName$
    If UCase$(Right$(tempThisFileName$, 4)) = ".FRM" Or UCase$(Right$(tempThisFileName$, 4)) = ".BAS" Then
        tempThisFileName$ = Left$(tempThisFileName$, Len(tempThisFileName$) - 4)
    End If

    BaseOutputFileName = CurrentPath$ + PathSep$ + tempThisFileName$

    If (_FileExists(BaseOutputFileName + ".bas") And SaveOnlyFrm = False) And _FileExists(BaseOutputFileName + ".frm") Then
        b$ = "These files will be overwritten:" + Chr$(10) + "    "
        b$ = b$ + tempThisFileName$ + ".bas" + Chr$(10) + "    "
        b$ = b$ + tempThisFileName$ + ".frm" + Chr$(10)
        b$ = b$ + "Proceed?"
    ElseIf (_FileExists(BaseOutputFileName + ".bas") And SaveOnlyFrm = False) And _FileExists(BaseOutputFileName + ".frm") = 0 Then
        b$ = "'" + tempThisFileName$ + ".bas" + "' will be overwritten." + Chr$(10)
        b$ = b$ + "Proceed?"
    ElseIf _FileExists(BaseOutputFileName + ".frm") Then
        b$ = "'" + tempThisFileName$ + ".frm" + "' will be overwritten." + Chr$(10)
        b$ = b$ + "Proceed?"
    End If

    If Len(b$) > 0 Then
        Answer = MessageBox(b$, "", MsgBox_YesNo + MsgBox_Question)
        If Answer = MsgBox_No Then Exit Sub
    End If

    AddGifExtension = Control(AddGifExtensionToggle).Value

    If (AddGifExtension Or Control(AddGifExtensionToggle).Value) And LoadedWithGifExtension = False And TotalGifLoaded = 0 Then
        Answer = MessageBox("Are you sure you want to include the GIF extension?\n(no animated GIFs have been added to this form)", "", MsgBox_YesNo + MsgBox_Question)
        AddGifExtension = (Answer = MsgBox_Yes)
    End If

    AddToRecentList BaseOutputFileName + ".frm"

    'Backup existing files
    For i = 1 To 2
        If i = 1 Then
            If SaveOnlyFrm Then
                _Continue
            Else
                BackupFile$ = BaseOutputFileName + ".bas"
            End If
        End If
        If i = 2 Then BackupFile$ = BaseOutputFileName + ".frm"

        If _FileExists(BackupFile$) Then
            TextFileNum = FreeFile
            Open BackupFile$ For Binary As #TextFileNum
            b$ = Space$(LOF(TextFileNum))
            Get #TextFileNum, 1, b$
            Close #TextFileNum

            TextFileNum = FreeFile
            Open BackupFile$ + "-backup" For Output As #TextFileNum: Close #TextFileNum
            Open BackupFile$ + "-backup" For Binary As #TextFileNum
            Put #TextFileNum, 1, b$
            Close #TextFileNum

            If i = 1 Then
                BackupCode$ = Replace$(b$, Chr$(13) + Chr$(10), Chr$(10), 0, 0)
                PreserveBackup = True
            End If
        End If
    Next

    '.FRM file
    TextFileNum = FreeFile
    Open BaseOutputFileName + ".frm" For Output As #TextFileNum
    Print #TextFileNum, "': This form was generated by"
    Print #TextFileNum, "': InForm - GUI library for QB64 - "; __UI_Version
    Print #TextFileNum, "': Fellippe Heitor, " + __UI_CopyrightSpan + " - fellippe@qb64.org - @fellippeheitor"
    Print #TextFileNum, "': https://github.com/FellippeHeitor/InForm"
    Print #TextFileNum, "'-----------------------------------------------------------"
    Print #TextFileNum, "SUB __UI_LoadForm"
    Print #TextFileNum,
    If Len(PreviewTexts(PreviewFormID)) > 0 Then
        Print #TextFileNum, "    $EXEICON:'" + PreviewTexts(PreviewFormID) + "'"
    End If
    If PreviewControls(PreviewFormID).CanResize Then
        Print #TextFileNum, "    $RESIZE:ON"
    End If
    Print #TextFileNum, "    DIM __UI_NewID AS LONG, __UI_RegisterResult AS LONG"
    Print #TextFileNum,

    'First pass is for the main form and containers (frames and menubars).
    'Second pass is for the rest of controls.
    'Controls named __UI_+anything are ignored, as they are automatically created.
    Dim ThisPass As _Byte, AddContextMenuToForm As String
    For ThisPass = 1 To 2
        For i = 1 To UBound(PreviewControls)
            If PreviewControls(i).ID > 0 And PreviewControls(i).Type <> __UI_Type_MenuPanel And PreviewControls(i).Type <> __UI_Type_Font And Len(RTrim$(PreviewControls(i).Name)) > 0 Then
                If UCase$(Left$(PreviewControls(i).Name, 5)) = "__UI_" Then GoTo EndOfThisPass 'Internal controls
                a$ = "    __UI_NewID = __UI_NewControl("
                Select Case PreviewControls(i).Type
                    Case __UI_Type_Form: a$ = a$ + "__UI_Type_Form, ": If ThisPass = 2 Then GoTo EndOfThisPass
                    Case __UI_Type_Frame: a$ = a$ + "__UI_Type_Frame, ": If ThisPass = 2 Then GoTo EndOfThisPass
                    Case __UI_Type_Button: a$ = a$ + "__UI_Type_Button, ": If ThisPass = 1 Then GoTo EndOfThisPass
                    Case __UI_Type_Label: a$ = a$ + "__UI_Type_Label, ": If ThisPass = 1 Then GoTo EndOfThisPass
                    Case __UI_Type_CheckBox: a$ = a$ + "__UI_Type_CheckBox, ": If ThisPass = 1 Then GoTo EndOfThisPass
                    Case __UI_Type_RadioButton: a$ = a$ + "__UI_Type_RadioButton, ": If ThisPass = 1 Then GoTo EndOfThisPass
                    Case __UI_Type_TextBox: a$ = a$ + "__UI_Type_TextBox, ": If ThisPass = 1 Then GoTo EndOfThisPass
                    Case __UI_Type_ProgressBar: a$ = a$ + "__UI_Type_ProgressBar, ": If ThisPass = 1 Then GoTo EndOfThisPass
                    Case __UI_Type_ListBox: a$ = a$ + "__UI_Type_ListBox, ": If ThisPass = 1 Then GoTo EndOfThisPass
                    Case __UI_Type_DropdownList: a$ = a$ + "__UI_Type_DropdownList, ": If ThisPass = 1 Then GoTo EndOfThisPass
                    Case __UI_Type_MenuBar: a$ = a$ + "__UI_Type_MenuBar, ": If ThisPass = 2 Then GoTo EndOfThisPass
                    Case __UI_Type_MenuItem: a$ = a$ + "__UI_Type_MenuItem, ": If ThisPass = 1 Then GoTo EndOfThisPass
                    Case __UI_Type_PictureBox: a$ = a$ + "__UI_Type_PictureBox, ": If ThisPass = 1 Then GoTo EndOfThisPass
                    Case __UI_Type_TrackBar: a$ = a$ + "__UI_Type_TrackBar, ": If ThisPass = 1 Then GoTo EndOfThisPass
                    Case __UI_Type_ContextMenu: a$ = a$ + "__UI_Type_ContextMenu, ": If ThisPass = 2 Then GoTo EndOfThisPass
                    Case __UI_Type_ToggleSwitch: a$ = a$ + "__UI_Type_ToggleSwitch, ": If ThisPass = 1 Then GoTo EndOfThisPass
                End Select
                a$ = a$ + Chr$(34) + RTrim$(PreviewControls(i).Name) + Chr$(34) + ","
                a$ = a$ + Str$(PreviewControls(i).Width) + ","
                a$ = a$ + Str$(PreviewControls(i).Height) + ","
                a$ = a$ + Str$(PreviewControls(i).Left) + ","
                a$ = a$ + Str$(PreviewControls(i).Top) + ","
                If Len(PreviewParentIDS(i)) > 0 Then
                    a$ = a$ + " __UI_GetID(" + Chr$(34) + PreviewParentIDS(i) + Chr$(34) + "))"
                Else
                    a$ = a$ + " 0)"
                End If
                Print #TextFileNum, a$
                Print #TextFileNum, "    __UI_RegisterResult = 0"

                If PreviewControls(i).Type = __UI_Type_ContextMenu Then
                    Print #TextFileNum,
                    If Len(AddContextMenuToForm) > 0 And RTrim$(PreviewControls(i).Name) = AddContextMenuToForm Then
                        Print #TextFileNum, "    Control(__UI_FormID).ContextMenuID = __UI_GetID(" + Chr$(34) + AddContextMenuToForm + Chr$(34) + ")"
                        Print #TextFileNum,
                        AddContextMenuToForm = ""
                    End If
                    _Continue
                End If

                If PreviewDefaultButtonID = i Then
                    Print #TextFileNum, "    __UI_DefaultButtonID = __UI_NewID"
                End If

                If Len(PreviewCaptions(i)) > 0 Then
                    Select Case PreviewControls(i).Type
                        CASE __UI_Type_Form, __UI_Type_Frame, __UI_Type_Button, _
                             __UI_Type_Label, __UI_Type_CheckBox, __UI_Type_RadioButton, _
                             __UI_Type_TextBox, __UI_Type_ProgressBar, __UI_Type_MenuBar, _
                             __UI_Type_MenuItem
                            a$ = "    SetCaption __UI_NewID, " + SpecialCharsToEscapeCode$(PreviewCaptions(i))
                            Print #TextFileNum, a$
                    End Select
                End If

                If Len(PreviewTips(i)) > 0 Then
                    a$ = "    ToolTip(__UI_NewID) = " + SpecialCharsToEscapeCode$(PreviewTips(i))
                    Print #TextFileNum, a$
                End If

                If Len(PreviewTexts(i)) > 0 Then
                    Select Case PreviewControls(i).Type
                        Case __UI_Type_ListBox, __UI_Type_DropdownList
                            Dim TempCaption$, TempText$, ThisItem%
                            Dim findLF&

                            TempText$ = PreviewTexts(i)
                            ThisItem% = 0
                            Do While Len(TempText$)
                                ThisItem% = ThisItem% + 1
                                findLF& = InStr(TempText$, Chr$(10))
                                If findLF& Then
                                    TempCaption$ = Left$(TempText$, findLF& - 1)
                                    TempText$ = Mid$(TempText$, findLF& + 1)
                                Else
                                    TempCaption$ = TempText$
                                    TempText$ = ""
                                End If
                                a$ = "    AddItem __UI_NewID, " + Chr$(34) + TempCaption$ + Chr$(34)
                                Print #TextFileNum, a$
                            Loop
                        Case __UI_Type_PictureBox, __UI_Type_Button, __UI_Type_MenuItem
                            If AddGifExtension And PreviewAnimatedGif(i) Then
                                a$ = "    __UI_RegisterResult = OpenGif(__UI_NewID, " + Chr$(34) + PreviewTexts(i) + Chr$(34) + ")"
                            Else
                                a$ = "    LoadImage Control(__UI_NewID), " + Chr$(34) + PreviewTexts(i) + Chr$(34)
                            End If
                            Print #TextFileNum, a$

                            If AddGifExtension And PreviewAutoPlayGif(i) Then
                                a$ = "    IF __UI_RegisterResult THEN PlayGif __UI_NewID"
                                Print #TextFileNum, a$
                            End If
                        Case Else
                            If PreviewControls(i).Type = __UI_Type_TextBox And PreviewControls(i).NumericOnly <> 0 Then
                                'skip saving Text() for NumericTextBox controls
                            Else
                                a$ = "    Text(__UI_NewID) = " + SpecialCharsToEscapeCode$(PreviewTexts(i))
                                Print #TextFileNum, a$
                            End If
                    End Select
                End If
                If Len(PreviewMasks(i)) > 0 Then
                    a$ = "    Mask(__UI_NewID) = " + SpecialCharsToEscapeCode$(PreviewMasks(i))
                    Print #TextFileNum, a$
                End If
                If PreviewControls(i).TransparentColor > 0 Then
                    Print #TextFileNum, "    __UI_ClearColor Control(__UI_NewID).HelperCanvas, " + LTrim$(Str$(PreviewControls(i).TransparentColor)) + ", -1"
                End If
                If PreviewControls(i).Stretch = True Then
                    Print #TextFileNum, "    Control(__UI_NewID).Stretch = True"
                End If
                'Fonts
                If Len(PreviewFonts(i)) > 0 Then
                    FontSetup$ = PreviewFonts(i)

                    'Parse FontSetup$ into Font variables
                    FindSep = InStr(FontSetup$, ",")
                    NewFontFile = Left$(FontSetup$, FindSep - 1)
                    FontSetup$ = Mid$(FontSetup$, FindSep + 1)

                    FontSetup$ = "SetFont(" + Chr$(34) + NewFontFile + Chr$(34) + ", " + FontSetup$ + ")"
                    Print #TextFileNum, "    Control(__UI_NewID).Font = " + FontSetup$
                End If
                'Colors are saved only if they differ from the theme's defaults
                If PreviewControls(i).ForeColor > 0 And PreviewControls(i).ForeColor <> __UI_DefaultColor(PreviewControls(i).Type, 1) Then
                    Print #TextFileNum, "    Control(__UI_NewID).ForeColor = _RGB32(" + LTrim$(Str$(_Red32(PreviewControls(i).ForeColor))) + ", " + LTrim$(Str$(_Green32(PreviewControls(i).ForeColor))) + ", " + LTrim$(Str$(_Blue32(PreviewControls(i).ForeColor))) + ")"
                End If
                If PreviewControls(i).BackColor > 0 And PreviewControls(i).BackColor <> __UI_DefaultColor(PreviewControls(i).Type, 2) Then
                    Print #TextFileNum, "    Control(__UI_NewID).BackColor = _RGB32(" + LTrim$(Str$(_Red32(PreviewControls(i).BackColor))) + ", " + LTrim$(Str$(_Green32(PreviewControls(i).BackColor))) + ", " + LTrim$(Str$(_Blue32(PreviewControls(i).BackColor))) + ")"
                End If
                If PreviewControls(i).SelectedForeColor > 0 And PreviewControls(i).SelectedForeColor <> __UI_DefaultColor(PreviewControls(i).Type, 3) Then
                    Print #TextFileNum, "    Control(__UI_NewID).SelectedForeColor = _RGB32(" + LTrim$(Str$(_Red32(PreviewControls(i).SelectedForeColor))) + ", " + LTrim$(Str$(_Green32(PreviewControls(i).SelectedForeColor))) + ", " + LTrim$(Str$(_Blue32(PreviewControls(i).SelectedForeColor))) + ")"
                End If
                If PreviewControls(i).SelectedBackColor > 0 And PreviewControls(i).SelectedBackColor <> __UI_DefaultColor(PreviewControls(i).Type, 4) Then
                    Print #TextFileNum, "    Control(__UI_NewID).SelectedBackColor = _RGB32(" + LTrim$(Str$(_Red32(PreviewControls(i).SelectedBackColor))) + ", " + LTrim$(Str$(_Green32(PreviewControls(i).SelectedBackColor))) + ", " + LTrim$(Str$(_Blue32(PreviewControls(i).SelectedBackColor))) + ")"
                End If
                If PreviewControls(i).BorderColor > 0 And PreviewControls(i).BorderColor <> __UI_DefaultColor(PreviewControls(i).Type, 5) Then
                    Print #TextFileNum, "    Control(__UI_NewID).BorderColor = _RGB32(" + LTrim$(Str$(_Red32(PreviewControls(i).BorderColor))) + ", " + LTrim$(Str$(_Green32(PreviewControls(i).BorderColor))) + ", " + LTrim$(Str$(_Blue32(PreviewControls(i).BorderColor))) + ")"
                End If
                If PreviewControls(i).BackStyle = __UI_Transparent Then
                    Print #TextFileNum, "    Control(__UI_NewID).BackStyle = __UI_Transparent"
                End If
                If PreviewControls(i).HasBorder Then
                    Print #TextFileNum, "    Control(__UI_NewID).HasBorder = True"
                Else
                    Print #TextFileNum, "    Control(__UI_NewID).HasBorder = False"
                End If
                If PreviewControls(i).Align = __UI_Center Then
                    Print #TextFileNum, "    Control(__UI_NewID).Align = __UI_Center"
                ElseIf PreviewControls(i).Align = __UI_Right Then
                    Print #TextFileNum, "    Control(__UI_NewID).Align = __UI_Right"
                End If
                If PreviewControls(i).VAlign = __UI_Middle Then
                    Print #TextFileNum, "    Control(__UI_NewID).VAlign = __UI_Middle"
                ElseIf PreviewControls(i).VAlign = __UI_Bottom Then
                    Print #TextFileNum, "    Control(__UI_NewID).VAlign = __UI_Bottom"
                End If
                If PreviewControls(i).PasswordField = True And PreviewControls(i).Type = __UI_Type_TextBox Then
                    Print #TextFileNum, "    Control(__UI_NewID).PasswordField = True"
                End If
                If PreviewControls(i).Value <> 0 Then
                    Print #TextFileNum, "    Control(__UI_NewID).Value = " + LTrim$(Str$(PreviewControls(i).Value))
                End If
                If PreviewControls(i).Min <> 0 Then
                    Print #TextFileNum, "    Control(__UI_NewID).Min = " + LTrim$(Str$(PreviewControls(i).Min))
                End If
                If PreviewControls(i).Max <> 0 Then
                    IF PreviewControls(i).Type <> __UI_Type_ListBox AND _
                    PreviewControls(i).Type <>  __UI_Type_DropdownList THEN
                        Print #TextFileNum, "    Control(__UI_NewID).Max = " + LTrim$(Str$(PreviewControls(i).Max))
                    End If
                End If
                If PreviewControls(i).ShowPercentage Then
                    Print #TextFileNum, "    Control(__UI_NewID).ShowPercentage = True"
                End If
                If PreviewControls(i).CanHaveFocus Then
                    Print #TextFileNum, "    Control(__UI_NewID).CanHaveFocus = True"
                End If
                If PreviewControls(i).Disabled Then
                    Print #TextFileNum, "    Control(__UI_NewID).Disabled = True"
                End If
                If PreviewControls(i).Hidden Then
                    Print #TextFileNum, "    Control(__UI_NewID).Hidden = True"
                End If
                If PreviewControls(i).CenteredWindow Then
                    Print #TextFileNum, "    Control(__UI_NewID).CenteredWindow = True"
                End If
                If Len(PreviewContextMenu(i)) Then
                    If PreviewControls(i).Type = __UI_Type_Form Then
                        AddContextMenuToForm = PreviewContextMenu(i)
                    Else
                        Print #TextFileNum, "    Control(__UI_NewID).ContextMenuID = __UI_GetID(" + Chr$(34) + PreviewContextMenu(i) + Chr$(34) + ")"
                    End If
                End If
                If Len(PreviewKeyCombos(i)) Then
                    Print #TextFileNum, "    __UI_RegisterResult = RegisterKeyCombo(" + Chr$(34) + PreviewKeyCombos(i) + Chr$(34) + ", __UI_NewID)"
                End If
                If PreviewControls(i).Interval Then
                    Print #TextFileNum, "    Control(__UI_NewID).Interval = " + LTrim$(Str$(PreviewControls(i).Interval))
                End If
                If PreviewControls(i).MinInterval Then
                    Print #TextFileNum, "    Control(__UI_NewID).MinInterval = " + LTrim$(Str$(PreviewControls(i).MinInterval))
                End If
                If PreviewControls(i).WordWrap Then
                    Print #TextFileNum, "    Control(__UI_NewID).WordWrap = True"
                End If
                If PreviewControls(i).CanResize And PreviewControls(i).Type = __UI_Type_Form Then
                    Print #TextFileNum, "    Control(__UI_NewID).CanResize = True"
                End If
                If PreviewControls(i).Padding > 0 Then
                    Print #TextFileNum, "    Control(__UI_NewID).Padding = " + LTrim$(Str$(PreviewControls(i).Padding))
                End If
                If PreviewControls(i).BorderSize > 0 Then
                    Print #TextFileNum, "    Control(__UI_NewID).BorderSize = " + LTrim$(Str$(PreviewControls(i).BorderSize))
                End If
                If PreviewControls(i).Encoding > 0 Then
                    Print #TextFileNum, "    Control(__UI_NewID).Encoding = " + LTrim$(Str$(PreviewControls(i).Encoding))
                End If
                If PreviewControls(i).NumericOnly = True Then
                    Print #TextFileNum, "    Control(__UI_NewID).NumericOnly = True"
                ElseIf PreviewControls(i).NumericOnly = __UI_NumericWithBounds Then
                    Print #TextFileNum, "    Control(__UI_NewID).NumericOnly = __UI_NumericWithBounds"
                End If
                If PreviewControls(i).BulletStyle > 0 Then
                    Select Case PreviewControls(i).BulletStyle
                        Case __UI_Bullet
                            Print #TextFileNum, "    Control(__UI_NewID).BulletStyle = __UI_Bullet"
                    End Select
                End If
                If PreviewControls(i).AutoScroll Then
                    Print #TextFileNum, "    Control(__UI_NewID).AutoScroll = True"
                End If
                If PreviewControls(i).AutoSize Then
                    Print #TextFileNum, "    Control(__UI_NewID).AutoSize = True"
                End If
                Print #TextFileNum,
            End If
            EndOfThisPass:
        Next
    Next ThisPass

    'Save control bindings
    Dim BindingsSection As _Byte
    Dim BindingDone(0 To UBound(PreviewControls)) As _Byte
    For i = 1 To UBound(PreviewControls)
        If Len(PreviewBoundTo(i)) > 0 And BindingDone(i) = False Then
            If BindingsSection = False Then
                Print #TextFileNum, "    'Control bindings:"
                BindingsSection = True
            End If
            BindingDone(i) = True
            Print #TextFileNum, "    __UI_Bind __UI_GetID(" + Chr$(34);
            Print #TextFileNum, RTrim$(__UI_TrimAt0$(PreviewControls(i).Name)) + Chr$(34) + "), ";
            Print #TextFileNum, "__UI_GetID(" + Chr$(34);
            Print #TextFileNum, PreviewBoundTo(i) + Chr$(34) + "), ";
            Print #TextFileNum, Chr$(34) + PreviewBoundProperty(i) + Chr$(34) + ", ";
            For j = 1 To UBound(PreviewControls)
                If PreviewBoundTo(j) = RTrim$(__UI_TrimAt0$(PreviewControls(i).Name)) Then
                    BindingDone(j) = True
                    Print #TextFileNum, Chr$(34) + PreviewBoundProperty(j) + Chr$(34)
                    Exit For
                End If
            Next
        End If
    Next

    Print #TextFileNum, "END SUB"
    Print #TextFileNum,
    Print #TextFileNum, "SUB __UI_AssignIDs"
    For i = 1 To UBound(PreviewControls)
        If PreviewControls(i).ID > 0 And PreviewControls(i).Type <> __UI_Type_Font And PreviewControls(i).Type <> __UI_Type_MenuPanel Then
            Print #TextFileNum, "    " + RTrim$(__UI_TrimAt0$(PreviewControls(i).Name)) + " = __UI_GetID(" + Chr$(34) + RTrim$(__UI_TrimAt0$(PreviewControls(i).Name)) + Chr$(34) + ")"
        End If
    Next
    Print #TextFileNum, "END SUB"
    Close #TextFileNum

    '.BAS file
    If Not SaveOnlyFrm Then
        If PreserveBackup Then
            Dim insertionPoint As Long, endPoint As Long, firstCASE As Long
            Dim insertionPoint2 As Long, endPoint2 As Long
            Dim temp$, thisBlock$, addedItems$, indenting As Long
            Dim checkConditionResult As _Byte, controlToRemove$, found As _Byte
            Dim charSep$

            charSep$ = " =<>+-/\^:;,*()'" + Chr$(10)

            'Check which controls got removed/renamed since this form was loaded
            If Len(InitialControlSet) Then
                insertionPoint2 = InStr(InitialControlSet, Chr$(10))
                Do
                    endPoint2 = InStr(insertionPoint2 + 1, InitialControlSet, Chr$(10))
                    thisBlock$ = Mid$(InitialControlSet, insertionPoint2 + 1, endPoint2 - insertionPoint2 - 1)
                    temp$ = thisBlock$
                    controlToRemove$ = ""

                    If InStr(temp$, Chr$(11)) Then
                        'control was in the initial state but got renamed
                        controlToRemove$ = Left$(temp$, InStr(temp$, Chr$(11)) - 1)
                        temp$ = Mid$(temp$, InStr(temp$, Chr$(11)) + 1)
                    Else
                        controlToRemove$ = temp$
                    End If

                    found = False
                    For i = 1 To UBound(PreviewControls)
                        If PreviewControls(i).ID > 0 And PreviewControls(i).Type <> __UI_Type_Font And PreviewControls(i).Type <> __UI_Type_MenuPanel Then
                            If LCase$(RTrim$(PreviewControls(i).Name)) = LCase$(temp$) Then
                                found = True
                                Exit For
                            End If
                        End If
                    Next

                    If found Then
                        If InStr(thisBlock$, Chr$(11)) Then
                            'controlToRemove$ was in the initial state but got renamed to temp$
                            insertionPoint = InStr(BackupCode$, controlToRemove$)
                            Do While insertionPoint > 0
                                found = True
                                If OutsideQuotes(BackupCode$, insertionPoint) Then
                                    a$ = Mid$(BackupCode$, insertionPoint - 1, 1)
                                    b$ = Mid$(BackupCode$, insertionPoint + Len(controlToRemove$), 1)
                                    If Len(a$) > 0 And InStr(charSep$, a$) = 0 Then found = False
                                    If Len(b$) > 0 And InStr(charSep$, b$) = 0 Then found = False
                                    If found Then
                                        BackupCode$ = Left$(BackupCode$, insertionPoint - 1) + temp$ + Mid$(BackupCode$, insertionPoint + Len(controlToRemove$))
                                    End If
                                End If
                                insertionPoint = InStr(insertionPoint + 1, BackupCode$, controlToRemove$)
                            Loop
                        End If
                    Else
                        'comment next controlToRemove$ occurrences, since the control no longer exists
                        insertionPoint = InStr(BackupCode$, controlToRemove$)
                        Do While insertionPoint > 0
                            found = True
                            Color 8: Print insertionPoint, Mid$(BackupCode$, insertionPoint, 30)
                            If OutsideQuotes(BackupCode$, insertionPoint) Then
                                a$ = Mid$(BackupCode$, insertionPoint - 1, 1)
                                b$ = Mid$(BackupCode$, insertionPoint + Len(controlToRemove$), 1)
                                If Len(a$) > 0 And InStr(charSep$, a$) = 0 Then found = False
                                If Len(b$) > 0 And InStr(charSep$, b$) = 0 Then found = False
                                If found Then
                                    endPoint = InStr(insertionPoint, BackupCode$, Chr$(10))
                                    If endPoint = 0 Then endPoint = Len(BackupCode$)
                                    temp$ = " '<-- " + Chr$(34) + controlToRemove$ + Chr$(34) + " deleted from Form on " + Date$
                                    BackupCode$ = Left$(BackupCode$, endPoint - 1) + temp$ + Mid$(BackupCode$, endPoint)
                                    Color 14: Print insertionPoint, Mid$(BackupCode$, insertionPoint, 30)
                                End If
                            End If
                            Sleep
                            insertionPoint = InStr(insertionPoint + 1, BackupCode$, controlToRemove$)
                        Loop
                    End If

                    insertionPoint2 = endPoint2 + 1
                Loop While insertionPoint2 < Len(InitialControlSet)
            End If

            'Find insertion points in BackupCode$ for eventual new controls
            '1- Controls' IDs
            addedItems$ = ""
            For i = 1 To UBound(PreviewControls)
                If PreviewControls(i).ID > 0 And PreviewControls(i).Type <> __UI_Type_Font And PreviewControls(i).Type <> __UI_Type_MenuPanel Then
                    temp$ = "DIM SHARED " + RTrim$(__UI_TrimAt0$(PreviewControls(i).Name)) + " AS LONG"
                    If InStr(BackupCode$, temp$) = 0 Then
                        addedItems$ = addedItems$ + temp$ + Chr$(10)
                    End If
                End If
            Next

            insertionPoint = InStr(BackupCode$, "DIM SHARED ")
            If Len(addedItems$) Then
                BackupCode$ = Left$(BackupCode$, insertionPoint - 1) + addedItems$ + Mid$(BackupCode$, insertionPoint)
            End If

            '2- Remove "control deleted" comments, if any has been readded.
            For i = 1 To UBound(PreviewControls)
                If PreviewControls(i).ID > 0 And PreviewControls(i).Type <> __UI_Type_Font And PreviewControls(i).Type <> __UI_Type_MenuPanel Then
                    temp$ = " '<-- " + Chr$(34) + RTrim$(__UI_TrimAt0$(PreviewControls(i).Name)) + Chr$(34) + " deleted from Form on"
                    insertionPoint = InStr(BackupCode$, temp$)
                    Do While insertionPoint > 0
                        endPoint = InStr(insertionPoint, BackupCode$, Chr$(10))
                        BackupCode$ = Left$(BackupCode$, insertionPoint - 1) + Mid$(BackupCode$, endPoint)
                        insertionPoint = InStr(BackupCode$, temp$)
                    Loop
                End If
            Next

            '3- Even procedures
            For i = 4 To 13
                Select EveryCase i
                    Case 4: temp$ = "SUB __UI_Click (id AS LONG)"
                    Case 5: temp$ = "SUB __UI_MouseEnter (id AS LONG)"
                    Case 6: temp$ = "SUB __UI_MouseLeave (id AS LONG)"
                    Case 7: temp$ = "SUB __UI_FocusIn (id AS LONG)"
                    Case 8: temp$ = "SUB __UI_FocusOut (id AS LONG)"
                    Case 9: temp$ = "SUB __UI_MouseDown (id AS LONG)"
                    Case 10: temp$ = "SUB __UI_MouseUp (id AS LONG)"
                    Case 11: temp$ = "SUB __UI_KeyPress (id AS LONG)"
                    Case 12: temp$ = "SUB __UI_TextChanged (id AS LONG)"
                    Case 13: temp$ = "SUB __UI_ValueChanged (id AS LONG)"

                    Case 4 To 13
                        insertionPoint = InStr(BackupCode$, temp$)
                        endPoint = InStr(insertionPoint, BackupCode$, "END SUB" + Chr$(10)) + 8
                        thisBlock$ = Mid$(BackupCode$, insertionPoint, endPoint - insertionPoint)

                        If InStr(thisBlock$, "SELECT CASE id") Then
                            firstCASE = InStr(thisBlock$, "    CASE ")
                            If firstCASE Then
                                firstCASE = _InStrRev(firstCASE, thisBlock$, Chr$(10))
                                indenting = InStr(firstCASE, thisBlock$, "CASE ") - firstCASE - 1
                            Else
                                indenting = 8
                                firstCASE = _InStrRev(InStr(thisBlock$, "END SELECT"), thisBlock$, Chr$(10))
                            End If
                            addedItems$ = ""
                            For Dummy = 1 To UBound(PreviewControls)
                                GoSub checkCondition
                                If checkConditionResult Then
                                    IF INSTR(thisBlock$, " CASE " + RTRIM$(PreviewControls(Dummy).Name) + CHR$(10)) = 0 AND _
                                       INSTR(thisBlock$, " CASE " + RTRIM$(PreviewControls(Dummy).Name) + " '<-- " + CHR$(34) + RTRIM$(PreviewControls(Dummy).Name) + CHR$(34) + " deleted from Form on ") = 0 THEN
                                        addedItems$ = addedItems$ + Space$(indenting) + "CASE " + RTrim$(PreviewControls(Dummy).Name) + Chr$(10) + Chr$(10)
                                    ElseIf InStr(thisBlock$, " CASE " + RTrim$(PreviewControls(Dummy).Name) + " '<-- " + Chr$(34) + RTrim$(PreviewControls(Dummy).Name) + Chr$(34) + " deleted from Form on ") > 0 Then
                                        thisBlock$ = LEFT$(thisBlock$, INSTR(thisBlock$, " CASE " + RTRIM$(PreviewControls(Dummy).Name) + _
                                        " '<-- " + CHR$(34)) + 5 + LEN(RTRIM$(PreviewControls(Dummy).Name))) + _
                                        MID$(thisBlock$, INSTR(INSTR(thisBlock$, " CASE " + RTRIM$(PreviewControls(Dummy).Name) + _
                                        " '<-- " + CHR$(34) + RTRIM$(PreviewControls(Dummy).Name) + CHR$(34) + _
                                        " deleted from Form on "), thisBlock$, CHR$(10)))
                                    End If
                                End If
                            Next

                            If Len(addedItems$) Then
                                thisBlock$ = Left$(thisBlock$, firstCASE) + addedItems$ + Mid$(thisBlock$, firstCASE + 1)
                            End If

                            BackupCode$ = Left$(BackupCode$, insertionPoint - 1) + thisBlock$ + Mid$(BackupCode$, endPoint)
                        End If
                End Select
            Next

            Open BaseOutputFileName + ".bas" For Output As #TextFileNum: Close #TextFileNum
            Open BaseOutputFileName + ".bas" For Binary As #TextFileNum
            Put #TextFileNum, , BackupCode$
        Else
            Open BaseOutputFileName + ".bas" For Output As #TextFileNum
            Print #TextFileNum, "': This program uses"
            Print #TextFileNum, "': InForm - GUI library for QB64 - "; __UI_Version
            Print #TextFileNum, "': Fellippe Heitor, " + __UI_CopyrightSpan + " - fellippe@qb64.org - @fellippeheitor"
            Print #TextFileNum, "': https://github.com/FellippeHeitor/InForm"
            Print #TextFileNum, "'-----------------------------------------------------------"
            Print #TextFileNum,
            Print #TextFileNum, "': Controls' IDs: ------------------------------------------------------------------"
            For i = 1 To UBound(PreviewControls)
                If PreviewControls(i).ID > 0 And PreviewControls(i).Type <> __UI_Type_Font And PreviewControls(i).Type <> __UI_Type_MenuPanel Then
                    Print #TextFileNum, "DIM SHARED " + RTrim$(__UI_TrimAt0$(PreviewControls(i).Name)) + " AS LONG"
                End If
            Next
            Print #TextFileNum,
            Print #TextFileNum, "': External modules: ---------------------------------------------------------------"
            If AddGifExtension Then
                Print #TextFileNum, "'$INCLUDE:'InForm\extensions\gifplay.bi'"
            End If
            Print #TextFileNum, "'$INCLUDE:'InForm\InForm.bi'"
            Print #TextFileNum, "'$INCLUDE:'InForm\xp.uitheme'"
            Print #TextFileNum, "'$INCLUDE:'" + Mid$(BaseOutputFileName, Len(CurrentPath$) + 2) + ".frm'"
            If AddGifExtension Then
                Print #TextFileNum, "'$INCLUDE:'InForm\extensions\gifplay.bm'"
            End If
            Print #TextFileNum,
            Print #TextFileNum, "': Event procedures: ---------------------------------------------------------------"
            For i = 0 To 14
                Select EveryCase i
                    Case 0: Print #TextFileNum, "SUB __UI_BeforeInit"
                    Case 1: Print #TextFileNum, "SUB __UI_OnLoad"
                    Case 2
                        Print #TextFileNum, "SUB __UI_BeforeUpdateDisplay"
                        Print #TextFileNum, "    'This event occurs at approximately 60 frames per second."
                        Print #TextFileNum, "    'You can change the update frequency by calling SetFrameRate DesiredRate%"
                    Case 3
                        Print #TextFileNum, "SUB __UI_BeforeUnload"
                        Print #TextFileNum, "    'If you set __UI_UnloadSignal = False here you can"
                        Print #TextFileNum, "    'cancel the user's request to close."
                    Case 4: Print #TextFileNum, "SUB __UI_Click (id AS LONG)"
                    Case 5: Print #TextFileNum, "SUB __UI_MouseEnter (id AS LONG)"
                    Case 6: Print #TextFileNum, "SUB __UI_MouseLeave (id AS LONG)"
                    Case 7: Print #TextFileNum, "SUB __UI_FocusIn (id AS LONG)"
                    Case 8
                        Print #TextFileNum, "SUB __UI_FocusOut (id AS LONG)"
                        Print #TextFileNum, "    'This event occurs right before a control loses focus."
                        Print #TextFileNum, "    'To prevent a control from losing focus, set __UI_KeepFocus = True below."
                    Case 9: Print #TextFileNum, "SUB __UI_MouseDown (id AS LONG)"
                    Case 10: Print #TextFileNum, "SUB __UI_MouseUp (id AS LONG)"
                    Case 11
                        Print #TextFileNum, "SUB __UI_KeyPress (id AS LONG)"
                        Print #TextFileNum, "    'When this event is fired, __UI_KeyHit will contain the code of the key hit."
                        Print #TextFileNum, "    'You can change it and even cancel it by making it = 0"
                    Case 12: Print #TextFileNum, "SUB __UI_TextChanged (id AS LONG)"
                    Case 13: Print #TextFileNum, "SUB __UI_ValueChanged (id AS LONG)"
                    Case 14: Print #TextFileNum, "SUB __UI_FormResized"

                    Case 0, 3, 14
                        Print #TextFileNum,

                    Case 1
                        If PreviewDefaultButtonID > 0 Then
                            Print #TextFileNum, "    __UI_DefaultButtonID = " + RTrim$(__UI_TrimAt0$(PreviewControls(PreviewDefaultButtonID).Name))
                        Else
                            Print #TextFileNum,
                        End If

                    Case 2
                        If AddGifExtension = True And TotalGifLoaded > 0 Then
                            Print #TextFileNum,
                            Print #TextFileNum, "    'The lines below ensure your GIFs will display properly;"
                            Print #TextFileNum, "    'Please refer to the documentation in 'extensions/README - gifplay.txt'"
                            For Dummy = 1 To UBound(PreviewControls)
                                If PreviewAnimatedGif(Dummy) Then
                                    Print #TextFileNum, "    UpdateGif " + RTrim$(PreviewControls(Dummy).Name)
                                End If
                            Next
                        Else
                            Print #TextFileNum,
                        End If

                    Case 4 To 6, 9, 10 'All controls except for Menu panels, and internal context menus
                        Print #TextFileNum, "    SELECT CASE id"
                        For Dummy = 1 To UBound(PreviewControls)
                            If PreviewControls(Dummy).ID > 0 And PreviewControls(Dummy).Type <> __UI_Type_Font And PreviewControls(Dummy).Type <> __UI_Type_ContextMenu Then
                                Print #TextFileNum, "        CASE " + RTrim$(PreviewControls(Dummy).Name)
                                Print #TextFileNum,
                            End If
                        Next
                        Print #TextFileNum, "    END SELECT"

                    Case 7, 8, 11 'Controls that can have focus only
                        Print #TextFileNum, "    SELECT CASE id"
                        For Dummy = 1 To UBound(PreviewControls)
                            If PreviewControls(Dummy).ID > 0 And PreviewControls(Dummy).CanHaveFocus Then
                                Print #TextFileNum, "        CASE " + RTrim$(PreviewControls(Dummy).Name)
                                Print #TextFileNum,
                            End If
                        Next
                        Print #TextFileNum, "    END SELECT"

                    Case 12 'Text boxes
                        Print #TextFileNum, "    SELECT CASE id"
                        For Dummy = 1 To UBound(PreviewControls)
                            If PreviewControls(Dummy).ID > 0 And (PreviewControls(Dummy).Type = __UI_Type_TextBox) Then
                                Print #TextFileNum, "        CASE " + RTrim$(PreviewControls(Dummy).Name)
                                Print #TextFileNum,
                            End If
                        Next
                        Print #TextFileNum, "    END SELECT"

                    Case 13 'Dropdown list, List box, Track bar, ToggleSwitch, CheckBox
                        Print #TextFileNum, "    SELECT CASE id"
                        For Dummy = 1 To UBound(PreviewControls)
                            If PreviewControls(Dummy).ID > 0 And (PreviewControls(Dummy).Type = __UI_Type_ListBox Or PreviewControls(Dummy).Type = __UI_Type_DropdownList Or PreviewControls(Dummy).Type = __UI_Type_TrackBar Or PreviewControls(Dummy).Type = __UI_Type_ToggleSwitch Or PreviewControls(Dummy).Type = __UI_Type_CheckBox Or PreviewControls(Dummy).Type = __UI_Type_RadioButton) Then
                                Print #TextFileNum, "        CASE " + RTrim$(PreviewControls(Dummy).Name)
                                Print #TextFileNum,
                            End If
                        Next
                        Print #TextFileNum, "    END SELECT"
                End Select
                Print #TextFileNum, "END SUB"
                Print #TextFileNum,
            Next
        End If
        Print #TextFileNum, "'$INCLUDE:'InForm\InForm.ui'"
        Close #TextFileNum
    End If

    AddToRecentList BaseOutputFileName + ".frm"

    b$ = "Exporting successful. Files output:" + Chr$(10)
    If Not SaveOnlyFrm Then b$ = b$ + "    " + Mid$(BaseOutputFileName, Len(CurrentPath$) + 2) + ".bas" + Chr$(10)
    b$ = b$ + "    " + Mid$(BaseOutputFileName, Len(CurrentPath$) + 2) + ".frm"

    If ExitToQB64 And Not SaveOnlyFrm Then
        IF _FILEEXISTS(".." + PathSep$ + QB64_EXE) THEN
            b$ = b$ + Chr$(10) + Chr$(10) + "Exit to " + QB64_DISPLAY + "?"
            Answer = MessageBox(b$, "", MsgBox_YesNo + MsgBox_Question)
            If Answer = MsgBox_No Then Edited = False:EXIT SUB
    	    IF _FileExists("UiEditorPreview.frmbin") THEN Kill "UiEditorPreview.frmbin"            
            $IF WIN THEN 
    	        IF _FileExists("..\UiEditorPreview.frmbin") THEN Kill "..\UiEditorPreview.frmbin"            
                Shell _DontWait ".." + PathSep$ +  QB64_EXE + " " + QuotedFilename$(BaseOutputFileName + ".bas")
            $ELSE 
                SHELL _DONTWAIT ".." + PathSep$ +   + QB64_EXE + "  " + QuotedFilename$(BaseOutputFileName + ".bas")
            $END IF
            System
        ELSE
            b$ = b$ + Chr$(10) + Chr$(10) + "Close the editor?"
            Answer = MessageBox(b$, "", MsgBox_YesNo + MsgBox_Question)
            If Answer = MsgBox_No Then Edited = False: EXIT SUB
        END IF 
    Else
        Answer = MessageBox(b$, "", MsgBox_OkOnly + MsgBox_Information)
        Edited = False
    End If

    Exit Sub

    checkCondition:
    checkConditionResult = False
    Select Case i
        Case 4 To 6, 9, 10 'All controls except for Menu panels, and internal context menus
            If PreviewControls(Dummy).ID > 0 And PreviewControls(Dummy).Type <> __UI_Type_Font And PreviewControls(Dummy).Type <> __UI_Type_ContextMenu Then
                checkConditionResult = True
            End If

        Case 7, 8, 11 'Controls that can have focus only
            If PreviewControls(Dummy).ID > 0 And PreviewControls(Dummy).CanHaveFocus Then
                checkConditionResult = True
            End If

        Case 12 'Text boxes
            If PreviewControls(Dummy).ID > 0 And (PreviewControls(Dummy).Type = __UI_Type_TextBox) Then
                checkConditionResult = True
            End If

        Case 13 'Dropdown list, List box, Track bar, ToggleSwitch, CheckBox
            If PreviewControls(Dummy).ID > 0 And (PreviewControls(Dummy).Type = __UI_Type_ListBox Or PreviewControls(Dummy).Type = __UI_Type_DropdownList Or PreviewControls(Dummy).Type = __UI_Type_TrackBar Or PreviewControls(Dummy).Type = __UI_Type_ToggleSwitch Or PreviewControls(Dummy).Type = __UI_Type_CheckBox Or PreviewControls(Dummy).Type = __UI_Type_RadioButton) Then
                checkConditionResult = True
            End If
    End Select
    Return

End Sub

$If WIN Then
    Sub LoadFontList
        Dim hKey As _Offset
        Dim Ky As _Offset
        Dim SubKey As String
        Dim Value As String
        Dim bData As String
        Dim dwType As _Unsigned Long
        Dim numBytes As _Unsigned Long
        Dim numTchars As _Unsigned Long
        Dim l As Long
        Dim dwIndex As _Unsigned Long

        hKey = hKey 'no warnings on my watch
        Ky = HKEY_LOCAL_MACHINE
        SubKey = "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" + Chr$(0)
        Value = Space$(261) 'ANSI Value name limit 260 chars + 1 null
        bData = Space$(&H7FFF) 'arbitrary

        HasFontList = True
        AddItem FontList, "Built-in VGA font"
        TotalFontsFound = 1

        l = RegOpenKeyExA(Ky, _Offset(SubKey), 0, KEY_READ, _Offset(hKey))
        If l Then
            'HasFontList = False
            Exit Sub
        Else
            dwIndex = 0
            Do
                numBytes = Len(bData)
                numTchars = Len(Value)
                l = RegEnumValueA(hKey, dwIndex, _Offset(Value), _Offset(numTchars), 0, _Offset(dwType), _Offset(bData), _Offset(numBytes))
                If l Then
                    If l <> ERROR_NO_MORE_ITEMS Then
                        'HasFontList = False
                        Exit Sub
                    End If
                    Exit Do
                Else
                    If UCase$(Right$(formatData(dwType, numBytes, bData), 4)) = ".TTF" Or UCase$(Right$(formatData(dwType, numBytes, bData), 4)) = ".OTF" Then
                        TotalFontsFound = TotalFontsFound + 1
                        If TotalFontsFound > UBound(FontFile) Then
                            ReDim _Preserve FontFile(TotalFontsFound) As String
                        End If
                        Dim tempName$
                        tempName$ = Left$(Value, numTchars)
                        If Right$(tempName$, 11) = " (TrueType)" Then
                            tempName$ = Left$(tempName$, Len(tempName$) - 11)
                        End If
                        AddItem FontList, tempName$
                        FontFile(TotalFontsFound) = formatData(dwType, numBytes, bData)
                    End If
                End If
                dwIndex = dwIndex + 1
            Loop
            l = RegCloseKey(hKey)
        End If

        For l = 8 To 120
            AddItem FontSizeList, LTrim$(Str$(l))
        Next
    End Sub

    Function whatType$ (dwType As _Unsigned Long)
        Select Case dwType
            Case REG_SZ: whatType = "REG_SZ"
            Case REG_EXPAND_SZ: whatType = "REG_EXPAND_SZ"
            Case REG_BINARY: whatType = "REG_BINARY"
            Case REG_DWORD: whatType = "REG_DWORD"
            Case REG_DWORD_BIG_ENDIAN: whatType = "REG_DWORD_BIG_ENDIAN"
            Case REG_LINK: whatType = "REG_LINK"
            Case REG_MULTI_SZ: whatType = "REG_MULTI_SZ"
            Case REG_RESOURCE_LIST: whatType = "REG_RESOURCE_LIST"
            Case REG_FULL_RESOURCE_DESCRIPTOR: whatType = "REG_FULL_RESOURCE_DESCRIPTOR"
            Case REG_RESOURCE_REQUIREMENTS_LIST: whatType = "REG_RESOURCE_REQUIREMENTS_LIST"
            Case REG_QWORD: whatType = "REG_QWORD"
            Case Else: whatType = "unknown"
        End Select
    End Function

    Function whatKey$ (hKey As _Offset)
        hKey = hKey 'the lengths I'll go not to have warnings....
        Select Case hKey
            Case HKEY_CLASSES_ROOT: whatKey = "HKEY_CLASSES_ROOT"
            Case HKEY_CURRENT_USER: whatKey = "HKEY_CURRENT_USER"
            Case HKEY_LOCAL_MACHINE: whatKey = "HKEY_LOCAL_MACHINE"
            Case HKEY_USERS: whatKey = "HKEY_USERS"
            Case HKEY_PERFORMANCE_DATA: whatKey = "HKEY_PERFORMANCE_DATA"
            Case HKEY_CURRENT_CONFIG: whatKey = "HKEY_CURRENT_CONFIG"
            Case HKEY_DYN_DATA: whatKey = "HKEY_DYN_DATA"
        End Select
    End Function

    Function formatData$ (dwType As _Unsigned Long, numBytes As _Unsigned Long, bData As String)
        Dim t As String
        Dim ul As _Unsigned Long
        Dim b As _Unsigned _Byte
        Select Case dwType
            Case REG_SZ, REG_EXPAND_SZ, REG_MULTI_SZ
                formatData = Left$(bData, numBytes - 1)
            Case REG_DWORD
                t = LCase$(Hex$(CVL(Left$(bData, 4))))
                formatData = "0x" + String$(8 - Len(t), &H30) + t
            Case Else
                If numBytes Then
                    b = Asc(Left$(bData, 1))
                    If b < &H10 Then
                        t = t + "0" + LCase$(Hex$(b))
                    Else
                        t = t + LCase$(Hex$(b))
                    End If
                End If
                For ul = 2 To numBytes
                    b = Asc(Mid$(bData, ul, 1))
                    If b < &H10 Then
                        t = t + " 0" + LCase$(Hex$(b))
                    Else
                        t = t + " " + LCase$(Hex$(b))
                    End If
                Next
                formatData = t
        End Select
    End Function
$Else
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
$End If

'FUNCTION idezfilelist$ and idezpathlist$ (and helper functions) were
'adapted from ide_methods.bas (QB64):
Function idezfilelist$ (path$, method, depth%, TotalFound As Integer) 'method0=*.frm and *.frmbin, method1=*.*
    Dim sep As String * 1, filelist$, a$, dummy%
    sep = Chr$(10)

    TotalFound = 0
    dummy% = depth%
    $If WIN Then
        Open "opendlgfiles.dat" For Output As #150: Close #150
        If method = 0 Then Shell _Hide "dir /b /ON /A-D " + QuotedFilename$(path$) + "\*.frm >opendlgfiles.dat"
        If method = 1 Then Shell _Hide "dir /b /ON /A-D " + QuotedFilename$(path$) + "\*.* >opendlgfiles.dat"
        filelist$ = ""
        Open "opendlgfiles.dat" For Input As #150
        Do Until EOF(150)
            Line Input #150, a$
            If Len(a$) Then 'skip blank entries
                If filelist$ = "" Then filelist$ = a$ Else filelist$ = filelist$ + sep + a$
                TotalFound = TotalFound + 1
            End If
        Loop
        Close #150
        Kill "opendlgfiles.dat"
        idezfilelist$ = filelist$
        Exit Function
    $Else
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
    $End If
End Function

Function idezpathlist$ (path$, TotalFound%)
    Dim sep As String * 1, a$, pathlist$, c As Integer, x As Integer, b$
    Dim i As Integer
    sep = Chr$(10)

    TotalFound% = 0
    $If WIN Then
        Open "opendlgfiles.dat" For Output As #150: Close #150
        a$ = "": If Right$(path$, 1) = ":" Then a$ = "\" 'use a \ after a drive letter
        Shell _Hide "dir /b /ON /AD " + QuotedFilename$(path$ + a$) + " >opendlgfiles.dat"
        pathlist$ = ""
        Open "opendlgfiles.dat" For Input As #150
        Do Until EOF(150)
            Line Input #150, a$
            If pathlist$ = "" Then pathlist$ = a$ Else pathlist$ = pathlist$ + sep + a$
            TotalFound% = TotalFound% + 1
        Loop
        Close #150
        Kill "opendlgfiles.dat"
        'count instances of / or \
        c = 0
        For x = 1 To Len(path$)
            b$ = Mid$(path$, x, 1)
            If b$ = PathSep$ Then c = c + 1
        Next
        If c >= 1 Then
            If Len(pathlist$) Then pathlist$ = ".." + sep + pathlist$ Else pathlist$ = ".."
            TotalFound% = TotalFound% + 1
        End If
        'add drive paths
        For i = 0 To 25
            If Len(pathlist$) Then pathlist$ = pathlist$ + sep
            pathlist$ = pathlist$ + Chr$(65 + i) + ":"
            TotalFound% = TotalFound% + 1
        Next
        idezpathlist$ = pathlist$
        Exit Function
    $Else
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
    $End If
End Function

Function idezchangepath$ (path$, newpath$)
    Dim x As Integer, a$

    idezchangepath$ = path$ 'default (for unsuccessful cases)

    $If WIN Then
        'go back a path
        If newpath$ = ".." Then
            For x = Len(path$) To 1 Step -1
                a$ = Mid$(path$, x, 1)
                If a$ = "\" Then
                    idezchangepath$ = Left$(path$, x - 1)
                    Exit For
                End If
            Next
            Exit Function
        End If
        'change drive
        If Len(newpath$) = 2 And Right$(newpath$, 1) = ":" Then
            idezchangepath$ = newpath$
            Exit Function
        End If
        idezchangepath$ = path$ + "\" + newpath$
        Exit Function
    $Else
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
    $End If

End Function

Function QuotedFilename$ (f$)
    $If WIN Then
        QuotedFilename$ = Chr$(34) + f$ + Chr$(34)
    $Else
            QuotedFilename$ = "'" + f$ + "'"
    $End If
End Function

'---------------------------------------------------------------------------------
Function SpecialCharsToEscapeCode$ (Text$)
    Dim i As Long, Temp$

    Temp$ = Chr$(34)
    For i = 1 To Len(Text$)
        If Asc(Text$, i) < 32 Or Asc(Text$, i) = 34 Or Asc(Text$, i) = 92 Then
            Temp$ = Temp$ + "\" + LTrim$(Str$(Asc(Text$, i))) + ";"
        Else
            Temp$ = Temp$ + Mid$(Text$, i, 1)
        End If
    Next
    SpecialCharsToEscapeCode$ = Temp$ + Chr$(34)
End Function

'---------------------------------------------------------------------------------
Function OutsideQuotes%% (text$, position As Long)
    Dim quote%%
    Dim start As Long
    Dim i As Long

    start = _InStrRev(position, text$, Chr$(10)) + 1
    quote%% = False
    For i = start To position
        If Asc(text$, i) = 34 Then quote%% = Not quote%%
        If Asc(text$, i) = 10 Then Exit For
    Next
    OutsideQuotes%% = Not quote%%
End Function

'$include:'InForm.ui'

