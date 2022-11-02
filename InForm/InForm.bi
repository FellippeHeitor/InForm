'InForm - GUI library for QB64
'Fellippe Heitor, 2016-2019 - fellippe@qb64.org - @fellippeheitor
'

Declare Library
    Function __UI_GetPID Alias getpid ()
End Declare

Declare CustomType Library
    Sub __UI_MemCopy Alias memcpy (ByVal dest As _Offset, Byval source As _Offset, Byval bytes As Long)
End Declare

Declare Library "./InForm/falcon"
    Sub uprint_extra (ByVal x&, Byval y&, Byval chars%&, Byval length%&, Byval kern&, Byval do_render&, txt_width&, Byval charpos%&, charcount&, Byval colour~&, Byval max_width&)
    Function uprint (ByVal x&, Byval y&, chars$, Byval txt_len&, Byval colour~&, Byval max_width&)
    Function uprintwidth (chars$, Byval txt_len&, Byval max_width&)
    Function uheight& ()
    Function falcon_uspacing& Alias uspacing ()
    Function uascension& ()
End Declare

$If WIN Then
    Declare Library
    Function __UI_MB& Alias MessageBox (ByVal ignore&, message$, title$, Byval type&)
    Function GetSystemMetrics& (ByVal WhichMetric&)
    End Declare

    Const __UI_SM_SWAPBUTTON = 23
$Else
    DECLARE LIBRARY ""
        FUNCTION __UI_MB& ALIAS MessageBox (BYVAL ignore&, message$, title$, BYVAL type&)
    END DECLARE
$End If

$ScreenHide
_ControlChr Off

Type __UI_ControlTYPE
    ID As Long
    ParentID As Long
    PreviousParentID As Long
    ContextMenuID As Long
    Type As Integer
    Name As String * 40
    ParentName As String * 40
    SubMenu As _Byte
    MenuPanelID As Long
    SourceControl As Long
    Top As Integer
    Left As Integer
    Width As Integer
    Height As Integer
    Canvas As Long
    HelperCanvas As Long
    TransparentColor As _Unsigned Long
    Stretch As _Byte
    PreviousStretch As _Byte
    Font As Integer
    PreviousFont As Integer
    BackColor As _Unsigned Long
    ForeColor As _Unsigned Long
    SelectedForeColor As _Unsigned Long
    SelectedBackColor As _Unsigned Long
    BackStyle As _Byte
    HasBorder As _Byte
    BorderSize As Integer
    Padding As Integer
    Encoding As Long
    Align As _Byte
    PrevAlign As _Byte
    VAlign As _Byte
    PrevVAlign As _Byte
    BorderColor As _Unsigned Long
    Value As _Float
    PreviousValue As _Float
    Min As _Float
    PrevMin As _Float
    Max As _Float
    PrevMax As _Float
    Interval As _Float
    PrevInterval As _Float
    MinInterval As _Float
    PrevMinInterval As _Float
    HotKey As Integer
    HotKeyOffset As Integer
    HotKeyPosition As Integer
    ShowPercentage As _Byte
    AutoScroll As _Byte
    AutoSize As _Byte
    InputViewStart As Long
    PreviousInputViewStart As Long
    LastVisibleItem As Integer
    ItemHeight As Integer
    HasVScrollbar As _Byte
    VScrollbarButton2Top As Integer
    HoveringVScrollbarButton As _Byte
    ThumbHeight As Integer
    ThumbTop As Integer
    VScrollbarRatio As Single
    Cursor As Long
    PasswordField As _Byte
    PrevCursor As Long
    FieldArea As Long
    PreviousFieldArea As Long
    TextIsSelected As _Byte
    BypassSelectOnFocus As _Byte
    Multiline As _Byte
    NumericOnly As _Byte
    FirstVisibleLine As Long
    PrevFirstVisibleLine As Long
    CurrentLine As Long
    PrevCurrentLine As Long
    VisibleCursor As Long
    PrevVisibleCursor As Long
    ControlIsSelected As _Byte
    LeftOffsetFromFirstSelected As Integer
    TopOffsetFromFirstSelected As Integer
    SelectionLength As Long
    SelectionStart As Long
    WordWrap As _Byte
    CanResize As _Byte
    CanHaveFocus As _Byte
    Disabled As _Byte
    Hidden As _Byte
    PreviouslyHidden As _Byte
    CenteredWindow As _Byte
    ControlState As _Byte
    ChildrenRedrawn As _Byte
    FocusState As Long
    LastChange As Single
    Redraw As _Byte
    BulletStyle As _Byte
    MenuItemGroup As Integer
    KeyCombo As Long
    BoundTo As Long
    BoundProperty As Long
End Type

Type __UI_Types
    Name As String * 16
    Count As Long
    TurnsInto As Integer
    DefaultHeight As Integer
    MinimumHeight As Integer
    DefaultWidth As Integer
    MinimumWidth As Integer
    RestrictResize As _Byte
End Type

Type __UI_ThemeImagesType
    FileName As String * 32
    Handle As Long
End Type

Type __UI_WordWrapHistoryType
    StringSlot As Long
    Width As Integer
    LongestLine As Integer
    Font As Long
    TotalLines As Integer
End Type

Type __UI_KeyCombos
    Combo As String * 14 '         "CTRL+SHIFT+F12"
    FriendlyCombo As String * 14 ' "Ctrl+Shift+F12"
    ControlID As Long
End Type

ReDim Shared Caption(0 To 100) As String
ReDim Shared __UI_TempCaptions(0 To 100) As String
ReDim Shared Text(0 To 100) As String
ReDim Shared __UI_TempTexts(0 To 100) As String
ReDim Shared Mask(0 To 100) As String
ReDim Shared __UI_TempMask(0 To 100) As String
ReDim Shared ToolTip(0 To 100) As String
ReDim Shared __UI_TempTips(0 To 100) As String
ReDim Shared Control(0 To 100) As __UI_ControlTYPE
ReDim Shared ControlDrawOrder(0) As Long
ReDim Shared __UI_ThemeImages(0 To 100) As __UI_ThemeImagesType
ReDim Shared __UI_WordWrapHistoryTexts(0 To 100) As String
ReDim Shared __UI_WordWrapHistoryResults(0 To 100) As String
ReDim Shared __UI_WordWrapHistory(0 To 100) As __UI_WordWrapHistoryType
ReDim Shared __UI_ThisLineChars(0) As Long, __UI_FocusedTextBoxChars(0) As Long
ReDim Shared __UI_ActiveMenu(0 To 100) As Long, __UI_ParentMenu(0 To 100) As Long
ReDim Shared __UI_KeyCombo(0 To 100) As __UI_KeyCombos

Dim Shared __UI_TotalKeyCombos As Long, __UI_BypassKeyCombos As _Byte
Dim Shared table1252$(0 To 255), table437$(0 To 255)
Dim Shared __UI_MouseLeft As Integer, __UI_MouseTop As Integer
Dim Shared __UI_MouseWheel As Integer, __UI_MouseButtonsSwap As _Byte
Dim Shared __UI_PrevMouseLeft As Integer, __UI_PrevMouseTop As Integer
Dim Shared __UI_MouseButton1 As _Byte, __UI_MouseButton2 As _Byte
Dim Shared __UI_MouseIsDown As _Byte, __UI_MouseDownOnID As Long
Dim Shared __UI_Mouse2IsDown As _Byte, __UI_Mouse2DownOnID As Long
Dim Shared __UI_PreviousMouseDownOnID As Long
Dim Shared __UI_KeyIsDown As _Byte, __UI_KeyDownOnID As Long
Dim Shared __UI_ShiftIsDown As _Byte, __UI_CtrlIsDown As _Byte
Dim Shared __UI_AltIsDown As _Byte, __UI_ShowHotKeys As _Byte, __UI_AltCombo$
Dim Shared __UI_LastMouseClick As Single, __UI_MouseDownOnScrollbar As Single
Dim Shared __UI_DragX As Integer, __UI_DragY As Integer
Dim Shared __UI_DefaultButtonID As Long
Dim Shared __UI_KeyHit As Long, __UI_KeepFocus As _Byte
Dim Shared __UI_Focus As Long, __UI_PreviousFocus As Long, __UI_KeyboardFocus As _Byte
Dim Shared __UI_HoveringID As Long, __UI_LastHoveringID As Long, __UI_BelowHoveringID As Long
Dim Shared __UI_IsDragging As _Byte, __UI_DraggingID As Long
Dim Shared __UI_IsResizing As _Byte, __UI_ResizingID As Long
Dim Shared __UI_ResizeHandleHover As _Byte
Dim Shared __UI_IsSelectingText As _Byte, __UI_IsSelectingTextOnID As Long
Dim Shared __UI_SelectedText As String, __UI_SelectionLength As Long
Dim Shared __UI_StateHasChanged As _Byte
Dim Shared __UI_DraggingThumb As _Byte, __UI_ThumbDragTop As Integer
Dim Shared __UI_DraggingThumbOnID As Long
Dim Shared __UI_HasInput As _Byte, __UI_ProcessInputTimer As Single
Dim Shared __UI_UnloadSignal As _Byte, __UI_HasResized As _Byte
Dim Shared __UI_ExitTriggered As _Byte
Dim Shared __UI_Loaded As _Byte
Dim Shared __UI_EventsTimer As Integer, __UI_RefreshTimer As Integer
Dim Shared __UI_ActiveDropdownList As Long, __UI_ParentDropdownList As Long
Dim Shared __UI_TotalActiveMenus As Long, __UI_ActiveMenuIsContextMenu As _Byte
Dim Shared __UI_SubMenuDelay As Single, __UI_HoveringSubMenu As _Byte
Dim Shared __UI_TopMenuBarItem As Long
Dim Shared __UI_ActiveTipID As Long, __UI_TipTimer As Single, __UI_PreviousTipID As Long
Dim Shared __UI_ActiveTipTop As Integer, __UI_ActiveTipLeft As Integer
Dim Shared __UI_FormID As Long, __UI_HasMenuBar As Long
Dim Shared __UI_ScrollbarWidth As Integer, __UI_ScrollbarButtonHeight As Integer
Dim Shared __UI_MenuBarOffset As Integer, __UI_MenuItemOffset As Integer
Dim Shared __UI_NewMenuBarTextLeft As Integer, __UI_DefaultCaptionIndent As Integer
Dim Shared __UI_ForceRedraw As _Byte, __UI_AutoRefresh As _Byte
Dim Shared __UI_CurrentTitle As String
Dim Shared __UI_DesignMode As _Byte, __UI_FirstSelectedID As Long
Dim Shared __UI_WaitMessage As String, __UI_TotalSelectedControls As Long
Dim Shared __UI_WaitMessageHandle As Long, __UI_EditorMode As _Byte
Dim Shared __UI_LastRenderedLineWidth As Long, __UI_LastRenderedCharCount As Long
Dim Shared __UI_SelectionRectangleTop As Integer, __UI_SelectionRectangleLeft As Integer
Dim Shared __UI_SelectionRectangle As _Byte
Dim Shared __UI_CantShowContextMenu As _Byte, __UI_ShowPositionAndSize As _Byte
Dim Shared __UI_ShowInvisibleControls As _Byte, __UI_Snapped As _Byte
Dim Shared __UI_SnappedByProximityX As _Byte, __UI_SnappedByProximityY As _Byte
Dim Shared __UI_SnappedX As Integer, __UI_SnappedY As Integer
Dim Shared __UI_SnappedXID As Long, __UI_SnappedYID As Long
Dim Shared __UI_SnapLines As _Byte, __UI_SnapDistance As Integer, __UI_SnapDistanceFromForm As Integer
Dim Shared __UI_FrameRate As Single, __UI_Font8Offset As Integer, __UI_Font16Offset As Integer
Dim Shared __UI_ClipboardCheck$, __UI_MenuBarOffsetV As Integer
Dim Shared __UI_KeepScreenHidden As _Byte, __UI_MaxBorderSize As Integer
Dim Shared __UI_InternalContextMenus As Long, __UI_DidClick As _Byte
Dim Shared __UI_ContextMenuSourceID As Long
Dim Shared __UI_FKey(1 To 12) As Long

'Control types: -----------------------------------------------
Dim Shared __UI_Type(0 To 18) As __UI_Types
__UI_Type(__UI_Type_Form).Name = "Form"

__UI_Type(__UI_Type_Frame).Name = "Frame"
__UI_Type(__UI_Type_Frame).DefaultWidth = 230
__UI_Type(__UI_Type_Frame).DefaultHeight = 150

__UI_Type(__UI_Type_Button).Name = "Button"
__UI_Type(__UI_Type_Button).DefaultWidth = 80
__UI_Type(__UI_Type_Button).DefaultHeight = 23

__UI_Type(__UI_Type_Label).Name = "Label"
__UI_Type(__UI_Type_Label).DefaultWidth = 150
__UI_Type(__UI_Type_Label).DefaultHeight = 23

__UI_Type(__UI_Type_CheckBox).Name = "CheckBox"
__UI_Type(__UI_Type_CheckBox).DefaultWidth = 150
__UI_Type(__UI_Type_CheckBox).DefaultHeight = 23
__UI_Type(__UI_Type_CheckBox).TurnsInto = __UI_Type_ToggleSwitch

__UI_Type(__UI_Type_RadioButton).Name = "RadioButton"
__UI_Type(__UI_Type_RadioButton).DefaultWidth = 150
__UI_Type(__UI_Type_RadioButton).DefaultHeight = 23

__UI_Type(__UI_Type_TextBox).Name = "TextBox"
__UI_Type(__UI_Type_TextBox).DefaultWidth = 120
__UI_Type(__UI_Type_TextBox).DefaultHeight = 23

__UI_Type(__UI_Type_ProgressBar).Name = "ProgressBar"
__UI_Type(__UI_Type_ProgressBar).DefaultWidth = 300
__UI_Type(__UI_Type_ProgressBar).DefaultHeight = 23

__UI_Type(__UI_Type_ListBox).Name = "ListBox"
__UI_Type(__UI_Type_ListBox).DefaultWidth = 200
__UI_Type(__UI_Type_ListBox).DefaultHeight = 200
__UI_Type(__UI_Type_ListBox).TurnsInto = __UI_Type_DropdownList

__UI_Type(__UI_Type_DropdownList).Name = "DropdownList"
__UI_Type(__UI_Type_DropdownList).DefaultWidth = 200
__UI_Type(__UI_Type_DropdownList).DefaultHeight = 23
__UI_Type(__UI_Type_DropdownList).TurnsInto = __UI_Type_ListBox

__UI_Type(__UI_Type_MenuBar).Name = "MenuBar"
__UI_Type(__UI_Type_MenuBar).TurnsInto = __UI_Type_ContextMenu
__UI_Type(__UI_Type_MenuBar).RestrictResize = __UI_CantResizeV

__UI_Type(__UI_Type_MenuItem).Name = "MenuItem"
__UI_Type(__UI_Type_MenuItem).RestrictResize = __UI_CantResizeV

__UI_Type(__UI_Type_MenuPanel).Name = "MenuPanel"

__UI_Type(__UI_Type_PictureBox).Name = "PictureBox"
__UI_Type(__UI_Type_PictureBox).DefaultWidth = 230
__UI_Type(__UI_Type_PictureBox).DefaultHeight = 150

__UI_Type(__UI_Type_TrackBar).Name = "TrackBar"
__UI_Type(__UI_Type_TrackBar).DefaultWidth = 300
__UI_Type(__UI_Type_TrackBar).DefaultHeight = 40
__UI_Type(__UI_Type_TrackBar).MinimumHeight = 30
__UI_Type(__UI_Type_TrackBar).RestrictResize = __UI_CantResizeV

__UI_Type(__UI_Type_ContextMenu).Name = "ContextMenu"
__UI_Type(__UI_Type_ContextMenu).TurnsInto = __UI_Type_MenuBar
__UI_Type(__UI_Type_ContextMenu).RestrictResize = __UI_CantResize
__UI_Type(__UI_Type_ContextMenu).DefaultWidth = 22
__UI_Type(__UI_Type_ContextMenu).DefaultHeight = 22

__UI_Type(__UI_Type_Font).Name = "Font"

__UI_Type(__UI_Type_ToggleSwitch).Name = "ToggleSwitch"
__UI_Type(__UI_Type_ToggleSwitch).DefaultWidth = 40
__UI_Type(__UI_Type_ToggleSwitch).DefaultHeight = 17
__UI_Type(__UI_Type_ToggleSwitch).TurnsInto = __UI_Type_CheckBox
__UI_Type(__UI_Type_ToggleSwitch).RestrictResize = __UI_CantResize
'--------------------------------------------------------------

__UI_RestoreFKeys

CONST True = -1, False = 0
'$INCLUDE:'InFormVersion.bas'
__UI_SubMenuDelay = .4
__UI_SnapDistance = 5
__UI_SnapDistanceFromForm = 10
__UI_MaxBorderSize = 10
__UI_Font8Offset = 5
__UI_Font16Offset = 3
__UI_ClipboardCheck$ = "InForm" + STRING$(2, 10) + "BEGIN CONTROL DATA" + CHR$(10) + STRING$(60, 45) + CHR$(10)

__UI_ThemeSetup
__UI_InternalMenus
__UI_LoadForm

__UI_Init

'Main loop
DO
    _LIMIT 1
LOOP

SYSTEM
__UI_ErrorHandler:
RESUME NEXT

