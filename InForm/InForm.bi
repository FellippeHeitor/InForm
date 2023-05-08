'InForm - GUI library for QB64
'Fellippe Heitor, 2016-2019 - fellippe@qb64.org - @fellippeheitor
'
DECLARE LIBRARY
    FUNCTION __UI_GetPID ALIAS getpid ()
END DECLARE

DECLARE CUSTOMTYPE LIBRARY
    SUB __UI_MemCopy ALIAS memcpy (BYVAL dest AS _OFFSET, BYVAL source AS _OFFSET, BYVAL bytes AS LONG)
END DECLARE

$IF WIN THEN
    DECLARE LIBRARY
        FUNCTION GetSystemMetrics& (BYVAL WhichMetric&)
    END DECLARE

    CONST __UI_SM_SWAPBUTTON = 23
$END IF

$SCREENHIDE
_CONTROLCHR OFF

TYPE __UI_ControlTYPE
    ID AS LONG
    ParentID AS LONG
    PreviousParentID AS LONG
    ContextMenuID AS LONG
    Type AS INTEGER
    Name AS STRING * 40
    ParentName AS STRING * 40
    SubMenu AS _BYTE
    MenuPanelID AS LONG
    SourceControl AS LONG
    Top AS INTEGER
    Left AS INTEGER
    Width AS INTEGER
    Height AS INTEGER
    Canvas AS LONG
    HelperCanvas AS LONG
    TransparentColor AS _UNSIGNED LONG
    Stretch AS _BYTE
    PreviousStretch AS _BYTE
    Font AS INTEGER
    PreviousFont AS INTEGER
    BackColor AS _UNSIGNED LONG
    ForeColor AS _UNSIGNED LONG
    SelectedForeColor AS _UNSIGNED LONG
    SelectedBackColor AS _UNSIGNED LONG
    BackStyle AS _BYTE
    HasBorder AS _BYTE
    BorderSize AS INTEGER
    Padding AS INTEGER
    Encoding AS LONG
    Align AS _BYTE
    PrevAlign AS _BYTE
    VAlign AS _BYTE
    PrevVAlign AS _BYTE
    BorderColor AS _UNSIGNED LONG
    Value AS _FLOAT
    PreviousValue AS _FLOAT
    Min AS _FLOAT
    PrevMin AS _FLOAT
    Max AS _FLOAT
    PrevMax AS _FLOAT
    Interval AS _FLOAT
    PrevInterval AS _FLOAT
    MinInterval AS _FLOAT
    PrevMinInterval AS _FLOAT
    HotKey AS INTEGER
    HotKeyOffset AS INTEGER
    HotKeyPosition AS INTEGER
    ShowPercentage AS _BYTE
    AutoScroll AS _BYTE
    AutoSize AS _BYTE
    InputViewStart AS LONG
    PreviousInputViewStart AS LONG
    LastVisibleItem AS INTEGER
    ItemHeight AS INTEGER
    HasVScrollbar AS _BYTE
    VScrollbarButton2Top AS INTEGER
    HoveringVScrollbarButton AS _BYTE
    ThumbHeight AS INTEGER
    ThumbTop AS INTEGER
    VScrollbarRatio AS SINGLE
    Cursor AS LONG
    PasswordField AS _BYTE
    PrevCursor AS LONG
    FieldArea AS LONG
    PreviousFieldArea AS LONG
    TextIsSelected AS _BYTE
    BypassSelectOnFocus AS _BYTE
    Multiline AS _BYTE
    NumericOnly AS _BYTE
    FirstVisibleLine AS LONG
    PrevFirstVisibleLine AS LONG
    CurrentLine AS LONG
    PrevCurrentLine AS LONG
    VisibleCursor AS LONG
    PrevVisibleCursor AS LONG
    ControlIsSelected AS _BYTE
    LeftOffsetFromFirstSelected AS INTEGER
    TopOffsetFromFirstSelected AS INTEGER
    SelectionLength AS LONG
    SelectionStart AS LONG
    WordWrap AS _BYTE
    CanResize AS _BYTE
    CanHaveFocus AS _BYTE
    Disabled AS _BYTE
    Hidden AS _BYTE
    PreviouslyHidden AS _BYTE
    CenteredWindow AS _BYTE
    ControlState AS _BYTE
    ChildrenRedrawn AS _BYTE
    FocusState AS LONG
    LastChange AS SINGLE
    Redraw AS _BYTE
    BulletStyle AS _BYTE
    MenuItemGroup AS INTEGER
    KeyCombo AS LONG
    BoundTo AS LONG
    BoundProperty AS LONG
END TYPE

TYPE __UI_Types
    Name AS STRING * 16
    Count AS LONG
    TurnsInto AS INTEGER
    DefaultHeight AS INTEGER
    MinimumHeight AS INTEGER
    DefaultWidth AS INTEGER
    MinimumWidth AS INTEGER
    RestrictResize AS _BYTE
END TYPE

TYPE __UI_ThemeImagesType
    FileName AS STRING * 32
    Handle AS LONG
END TYPE

TYPE __UI_WordWrapHistoryType
    StringSlot AS LONG
    Width AS INTEGER
    LongestLine AS INTEGER
    Font AS LONG
    TotalLines AS INTEGER
END TYPE

TYPE __UI_KeyCombos
    Combo AS STRING * 14 '         "CTRL+SHIFT+F12"
    FriendlyCombo AS STRING * 14 ' "Ctrl+Shift+F12"
    ControlID AS LONG
END TYPE

REDIM SHARED Caption(0 TO 100) AS STRING
REDIM SHARED __UI_TempCaptions(0 TO 100) AS STRING
REDIM SHARED Text(0 TO 100) AS STRING
REDIM SHARED __UI_TempTexts(0 TO 100) AS STRING
REDIM SHARED Mask(0 TO 100) AS STRING
REDIM SHARED __UI_TempMask(0 TO 100) AS STRING
REDIM SHARED ToolTip(0 TO 100) AS STRING
REDIM SHARED __UI_TempTips(0 TO 100) AS STRING
REDIM SHARED Control(0 TO 100) AS __UI_ControlTYPE
REDIM SHARED ControlDrawOrder(0) AS LONG
REDIM SHARED __UI_ThemeImages(0 TO 100) AS __UI_ThemeImagesType
REDIM SHARED __UI_WordWrapHistoryTexts(0 TO 100) AS STRING
REDIM SHARED __UI_WordWrapHistoryResults(0 TO 100) AS STRING
REDIM SHARED __UI_WordWrapHistory(0 TO 100) AS __UI_WordWrapHistoryType
REDIM SHARED __UI_ThisLineChars(0) AS LONG, __UI_FocusedTextBoxChars(0) AS LONG
REDIM SHARED __UI_ActiveMenu(0 TO 100) AS LONG, __UI_ParentMenu(0 TO 100) AS LONG
REDIM SHARED __UI_KeyCombo(0 TO 100) AS __UI_KeyCombos

DIM SHARED __UI_TotalKeyCombos AS LONG, __UI_BypassKeyCombos AS _BYTE
DIM SHARED table1252$(0 TO 255), table437$(0 TO 255)
DIM SHARED __UI_MouseLeft AS INTEGER, __UI_MouseTop AS INTEGER
DIM SHARED __UI_MouseWheel AS INTEGER, __UI_MouseButtonsSwap AS _BYTE
DIM SHARED __UI_PrevMouseLeft AS INTEGER, __UI_PrevMouseTop AS INTEGER
DIM SHARED __UI_MouseButton1 AS _BYTE, __UI_MouseButton2 AS _BYTE
DIM SHARED __UI_MouseIsDown AS _BYTE, __UI_MouseDownOnID AS LONG
DIM SHARED __UI_Mouse2IsDown AS _BYTE, __UI_Mouse2DownOnID AS LONG
DIM SHARED __UI_PreviousMouseDownOnID AS LONG
DIM SHARED __UI_KeyIsDown AS _BYTE, __UI_KeyDownOnID AS LONG
DIM SHARED __UI_ShiftIsDown AS _BYTE, __UI_CtrlIsDown AS _BYTE
DIM SHARED __UI_AltIsDown AS _BYTE, __UI_ShowHotKeys AS _BYTE, __UI_AltCombo$
DIM SHARED __UI_LastMouseClick AS SINGLE, __UI_MouseDownOnScrollbar AS SINGLE
DIM SHARED __UI_DragX AS INTEGER, __UI_DragY AS INTEGER
DIM SHARED __UI_DefaultButtonID AS LONG
DIM SHARED __UI_KeyHit AS LONG, __UI_KeepFocus AS _BYTE
DIM SHARED __UI_Focus AS LONG, __UI_PreviousFocus AS LONG, __UI_KeyboardFocus AS _BYTE
DIM SHARED __UI_HoveringID AS LONG, __UI_LastHoveringID AS LONG, __UI_BelowHoveringID AS LONG
DIM SHARED __UI_IsDragging AS _BYTE, __UI_DraggingID AS LONG
DIM SHARED __UI_IsResizing AS _BYTE, __UI_ResizingID AS LONG
DIM SHARED __UI_ResizeHandleHover AS _BYTE
DIM SHARED __UI_IsSelectingText AS _BYTE, __UI_IsSelectingTextOnID AS LONG
DIM SHARED __UI_SelectedText AS STRING, __UI_SelectionLength AS LONG
DIM SHARED __UI_StateHasChanged AS _BYTE
DIM SHARED __UI_DraggingThumb AS _BYTE, __UI_ThumbDragTop AS INTEGER
DIM SHARED __UI_DraggingThumbOnID AS LONG
DIM SHARED __UI_HasInput AS _BYTE, __UI_ProcessInputTimer AS SINGLE
DIM SHARED __UI_UnloadSignal AS _BYTE, __UI_HasResized AS _BYTE
DIM SHARED __UI_ExitTriggered AS _BYTE
DIM SHARED __UI_Loaded AS _BYTE
DIM SHARED __UI_EventsTimer AS INTEGER, __UI_RefreshTimer AS INTEGER
DIM SHARED __UI_ActiveDropdownList AS LONG, __UI_ParentDropdownList AS LONG
DIM SHARED __UI_TotalActiveMenus AS LONG, __UI_ActiveMenuIsContextMenu AS _BYTE
DIM SHARED __UI_SubMenuDelay AS SINGLE, __UI_HoveringSubMenu AS _BYTE
DIM SHARED __UI_TopMenuBarItem AS LONG
DIM SHARED __UI_ActiveTipID AS LONG, __UI_TipTimer AS SINGLE, __UI_PreviousTipID AS LONG
DIM SHARED __UI_ActiveTipTop AS INTEGER, __UI_ActiveTipLeft AS INTEGER
DIM SHARED __UI_FormID AS LONG, __UI_HasMenuBar AS LONG
DIM SHARED __UI_ScrollbarWidth AS INTEGER, __UI_ScrollbarButtonHeight AS INTEGER
DIM SHARED __UI_MenuBarOffset AS INTEGER, __UI_MenuItemOffset AS INTEGER
DIM SHARED __UI_NewMenuBarTextLeft AS INTEGER, __UI_DefaultCaptionIndent AS INTEGER
DIM SHARED __UI_ForceRedraw AS _BYTE, __UI_AutoRefresh AS _BYTE
DIM SHARED __UI_CurrentTitle AS STRING
DIM SHARED __UI_DesignMode AS _BYTE, __UI_FirstSelectedID AS LONG
DIM SHARED __UI_WaitMessage AS STRING, __UI_TotalSelectedControls AS LONG
DIM SHARED __UI_WaitMessageHandle AS LONG, __UI_EditorMode AS _BYTE
DIM SHARED __UI_LastRenderedCharCount AS LONG
DIM SHARED __UI_SelectionRectangleTop AS INTEGER, __UI_SelectionRectangleLeft AS INTEGER
DIM SHARED __UI_SelectionRectangle AS _BYTE
DIM SHARED __UI_CantShowContextMenu AS _BYTE, __UI_ShowPositionAndSize AS _BYTE
DIM SHARED __UI_ShowInvisibleControls AS _BYTE, __UI_Snapped AS _BYTE
DIM SHARED __UI_SnappedByProximityX AS _BYTE, __UI_SnappedByProximityY AS _BYTE
DIM SHARED __UI_SnappedX AS INTEGER, __UI_SnappedY AS INTEGER
DIM SHARED __UI_SnappedXID AS LONG, __UI_SnappedYID AS LONG
DIM SHARED __UI_SnapLines AS _BYTE, __UI_SnapDistance AS INTEGER, __UI_SnapDistanceFromForm AS INTEGER
DIM SHARED __UI_FrameRate AS SINGLE, __UI_Font8Offset AS INTEGER, __UI_Font16Offset AS INTEGER
DIM SHARED __UI_ClipboardCheck$, __UI_MenuBarOffsetV AS INTEGER
DIM SHARED __UI_KeepScreenHidden AS _BYTE, __UI_MaxBorderSize AS INTEGER
DIM SHARED __UI_InternalContextMenus AS LONG, __UI_DidClick AS _BYTE
DIM SHARED __UI_ContextMenuSourceID AS LONG
DIM SHARED __UI_FKey(1 TO 12) AS LONG

'Control types: -----------------------------------------------
DIM SHARED __UI_Type(0 TO 18) AS __UI_Types
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

CONST False = 0, True = Not False

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

