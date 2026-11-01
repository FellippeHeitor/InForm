'-----------------------------------------------------------------------------------------------------------------------
' Common InForm-PE header
' Copyright (c) 2025 QB64 Phoenix Edition Team
' Copyright (c) 2022 Fellippe Heitor
'-----------------------------------------------------------------------------------------------------------------------

$IF VERSION < 4.2.0 THEN
    $ERROR 'This requires the latest version of QB64-PE from https://github.com/QB64-Phoenix-Edition/QB64pe/releases/latest'
$END IF

$INCLUDEONCE

'$INCLUDE:'InFormVersion.bi'
'$INCLUDE:'extensions/System.bi'
'$INCLUDE:'extensions/Memory.bi'
'$INCLUDE:'extensions/String.bi'
'$INCLUDE:'extensions/HMap64.bi'
'$INCLUDE:'extensions/Ini.bi'

CONST False%% = _FALSE, True%% = _TRUE

CONST __KEY_SPACE& = _ASC_SPACE
CONST __KEY_EXCLAMATION& = _ASC_EXCLAMATION
CONST __KEY_QUOTE& = _ASC_QUOTE
CONST __KEY_HASH& = _ASC_HASH
CONST __KEY_DOLLAR& = _ASC_DOLLAR
CONST __KEY_PERCENT& = _ASC_PERCENT
CONST __KEY_AMPERSAND& = _ASC_AMPERSAND
CONST __KEY_APOSTROPHE& = _ASC_APOSTROPHE
CONST __KEY_LEFTBRACKET& = _ASC_LEFTBRACKET
CONST __KEY_RIGHTBRACKET& = _ASC_RIGHTBRACKET
CONST __KEY_ASTERISK& = _ASC_ASTERISK
CONST __KEY_PLUS& = _ASC_PLUS
CONST __KEY_COMMA& = _ASC_COMMA
CONST __KEY_MINUS& = _ASC_MINUS
CONST __KEY_FULLSTOP& = _ASC_FULLSTOP
CONST __KEY_FORWARDSLASH& = _ASC_FORWARDSLASH
CONST __KEY_0& = __ASC_0
CONST __KEY_1& = __ASC_1
CONST __KEY_2& = __ASC_2
CONST __KEY_3& = __ASC_3
CONST __KEY_4& = __ASC_4
CONST __KEY_5& = __ASC_5
CONST __KEY_6& = __ASC_6
CONST __KEY_7& = __ASC_7
CONST __KEY_8& = __ASC_8
CONST __KEY_9& = __ASC_9
CONST __KEY_COLON& = _ASC_COLON
CONST __KEY_SEMICOLON& = _ASC_SEMICOLON
CONST __KEY_LESSTHAN& = _ASC_LESSTHAN
CONST __KEY_EQUAL& = _ASC_EQUAL
CONST __KEY_GREATERTHAN& = _ASC_GREATERTHAN
CONST __KEY_QUESTION& = _ASC_QUESTION
CONST __KEY_ATSIGN& = _ASC_ATSIGN
CONST __KEY_UPPER_A& = __ASC_UPPER_A
CONST __KEY_UPPER_B& = __ASC_UPPER_B
CONST __KEY_UPPER_C& = __ASC_UPPER_C
CONST __KEY_UPPER_D& = __ASC_UPPER_D
CONST __KEY_UPPER_E& = __ASC_UPPER_E
CONST __KEY_UPPER_F& = __ASC_UPPER_F
CONST __KEY_UPPER_G& = __ASC_UPPER_G
CONST __KEY_UPPER_H& = __ASC_UPPER_H
CONST __KEY_UPPER_I& = __ASC_UPPER_I
CONST __KEY_UPPER_J& = __ASC_UPPER_J
CONST __KEY_UPPER_K& = __ASC_UPPER_K
CONST __KEY_UPPER_L& = __ASC_UPPER_L
CONST __KEY_UPPER_M& = __ASC_UPPER_M
CONST __KEY_UPPER_N& = __ASC_UPPER_N
CONST __KEY_UPPER_O& = __ASC_UPPER_O
CONST __KEY_UPPER_P& = __ASC_UPPER_P
CONST __KEY_UPPER_Q& = __ASC_UPPER_Q
CONST __KEY_UPPER_R& = __ASC_UPPER_R
CONST __KEY_UPPER_S& = __ASC_UPPER_S
CONST __KEY_UPPER_T& = __ASC_UPPER_T
CONST __KEY_UPPER_U& = __ASC_UPPER_U
CONST __KEY_UPPER_V& = __ASC_UPPER_V
CONST __KEY_UPPER_W& = __ASC_UPPER_W
CONST __KEY_UPPER_X& = __ASC_UPPER_X
CONST __KEY_UPPER_Y& = __ASC_UPPER_Y
CONST __KEY_UPPER_Z& = __ASC_UPPER_Z
CONST __KEY_LEFTSQUAREBRACKET& = _ASC_LEFTSQUAREBRACKET
CONST __KEY_BACKSLASH& = _ASC_BACKSLASH
CONST __KEY_RIGHTSQUAREBRACKET& = _ASC_RIGHTSQUAREBRACKET
CONST __KEY_CARET& = _ASC_CARET
CONST __KEY_UNDERSCORE& = _ASC_UNDERSCORE
CONST __KEY_GRAVE& = _ASC_GRAVE
CONST __KEY_LOWER_A& = __ASC_LOWER_A
CONST __KEY_LOWER_B& = __ASC_LOWER_B
CONST __KEY_LOWER_C& = __ASC_LOWER_C
CONST __KEY_LOWER_D& = __ASC_LOWER_D
CONST __KEY_LOWER_E& = __ASC_LOWER_E
CONST __KEY_LOWER_F& = __ASC_LOWER_F
CONST __KEY_LOWER_G& = __ASC_LOWER_G
CONST __KEY_LOWER_H& = __ASC_LOWER_H
CONST __KEY_LOWER_I& = __ASC_LOWER_I
CONST __KEY_LOWER_J& = __ASC_LOWER_J
CONST __KEY_LOWER_K& = __ASC_LOWER_K
CONST __KEY_LOWER_L& = __ASC_LOWER_L
CONST __KEY_LOWER_M& = __ASC_LOWER_M
CONST __KEY_LOWER_N& = __ASC_LOWER_N
CONST __KEY_LOWER_O& = __ASC_LOWER_O
CONST __KEY_LOWER_P& = __ASC_LOWER_P
CONST __KEY_LOWER_Q& = __ASC_LOWER_Q
CONST __KEY_LOWER_R& = __ASC_LOWER_R
CONST __KEY_LOWER_S& = __ASC_LOWER_S
CONST __KEY_LOWER_T& = __ASC_LOWER_T
CONST __KEY_LOWER_U& = __ASC_LOWER_U
CONST __KEY_LOWER_V& = __ASC_LOWER_V
CONST __KEY_LOWER_W& = __ASC_LOWER_W
CONST __KEY_LOWER_X& = __ASC_LOWER_X
CONST __KEY_LOWER_Y& = __ASC_LOWER_Y
CONST __KEY_LOWER_Z& = __ASC_LOWER_Z
CONST __KEY_LEFTCURLYBRACKET& = _ASC_LEFTCURLYBRACKET
CONST __KEY_VERTICALBAR& = _ASC_VERTICALBAR
CONST __KEY_RIGHTCURLYBRACKET& = _ASC_RIGHTCURLYBRACKET
CONST __KEY_TILDE& = _ASC_TILDE

' InForm theme image IDs
CONST __INFORM_THEME_IMAGE_ARROWS~%% = 1~%%
CONST __INFORM_THEME_IMAGE_BUTTON~%% = 2~%%
CONST __INFORM_THEME_IMAGE_CHECKBOX~%% = 3~%%
CONST __INFORM_THEME_IMAGE_FRAME~%% = 4~%%
CONST __INFORM_THEME_IMAGE_MENUCHECKMARK~%% = 5~%%
CONST __INFORM_THEME_IMAGE_NOTFOUND~%% = 6~%%
CONST __INFORM_THEME_IMAGE_PROGRESSCHUNK~%% = 7~%%
CONST __INFORM_THEME_IMAGE_PROGRESSTRACK~%% = 8~%%
CONST __INFORM_THEME_IMAGE_RADIOBUTTON~%% = 9~%%
CONST __INFORM_THEME_IMAGE_SCROLLBUTTONS~%% = 10~%%
CONST __INFORM_THEME_IMAGE_SCROLLHBUTTONS~%% = 11~%%
CONST __INFORM_THEME_IMAGE_SCROLLHTHUMB~%% = 12~%%
CONST __INFORM_THEME_IMAGE_SCROLLHTRACK~%% = 13~%%
CONST __INFORM_THEME_IMAGE_SCROLLTHUMB~%% = 14~%%
CONST __INFORM_THEME_IMAGE_SCROLLTRACK~%% = 15~%%
CONST __INFORM_THEME_IMAGE_SLIDERDOWN~%% = 16~%%
CONST __INFORM_THEME_IMAGE_SLIDERTRACK~%% = 17~%%

' Default font list
CONST __INFORM_DEFAULT_FONTS = "segoeui.ttf?arial.ttf?Arial.ttf?Helvetica.ttc?Geneva.ttf?truetype/liberation/LiberationSans-Regular.ttf?TTF/arial.ttf?InForm/resources/NotoMono-Regular.ttf?cour.ttf?Courier.ttc"
CONST __INFORM_DEFAULT_FONTS_MONO = "cour.ttf?Courier New.ttf?truetype/liberation/LiberationMono-Regular.ttf?Monaco.ttf?Courier.ttc"

' Theme styles
CONST __UI_ThemeStyle_Bitmap%% = 0%% ' controls are drawn from theme bitmaps (e.g. the classic XP look)
CONST __UI_ThemeStyle_Flat%% = 1%% ' controls are drawn with primitives using the theme palette

' Theme color roles (index into __UI_ThemeColor())
CONST __UI_ThemeColor_WindowBack& = 1&
CONST __UI_ThemeColor_WindowText& = 2&
CONST __UI_ThemeColor_InputBack& = 3&
CONST __UI_ThemeColor_InputText& = 4&
CONST __UI_ThemeColor_ButtonFace& = 5&
CONST __UI_ThemeColor_ButtonText& = 6&
CONST __UI_ThemeColor_SelectedBack& = 7&
CONST __UI_ThemeColor_SelectedText& = 8&
CONST __UI_ThemeColor_Border& = 9&
CONST __UI_ThemeColor_Accent& = 10&
CONST __UI_ThemeColor_AccentText& = 11&
CONST __UI_ThemeColor_FocusRing& = 12&
CONST __UI_ThemeColor_Caret& = 13&
CONST __UI_ThemeColor_DisabledText& = 14& ' 0 = derive from the form's back color
CONST __UI_ThemeColor_TipBack& = 15&
CONST __UI_ThemeColor_TipText& = 16&
CONST __UI_ThemeColor_MenuBack& = 17&
CONST __UI_ThemeColor_TrackBack& = 18&
CONST __UI_ThemeColor_Count& = 18&
' Role names as used in theme files (same order as the constants above)
CONST __UI_ThemeColorNames = "WindowBack,WindowText,InputBack,InputText,ButtonFace,ButtonText,SelectedBack,SelectedText,Border,Accent,AccentText,FocusRing,Caret,DisabledText,TipBack,TipText,MenuBack,TrackBack"
' Image names as used in theme files (same order as the __INFORM_THEME_IMAGE_* constants)
CONST __UI_ThemeImageNames = "Arrows,Button,CheckBox,Frame,MenuCheckmark,NotFound,ProgressChunk,ProgressTrack,RadioButton,ScrollButtons,ScrollHButtons,ScrollHThumb,ScrollHTrack,ScrollThumb,ScrollTrack,SliderDown,SliderTrack"
CONST __UI_ThemeImage_Count~%% = 17~%%

'Control types:
CONST __UI_Type_Form%% = 1%%
CONST __UI_Type_Frame%% = 2%%
CONST __UI_Type_Button%% = 3%%
CONST __UI_Type_Label%% = 4%%
CONST __UI_Type_CheckBox%% = 5%%
CONST __UI_Type_RadioButton%% = 6%%
CONST __UI_Type_TextBox%% = 7%%
CONST __UI_Type_ProgressBar%% = 8%%
CONST __UI_Type_ListBox%% = 9%%
CONST __UI_Type_DropdownList%% = 10%%
CONST __UI_Type_MenuBar%% = 11%%
CONST __UI_Type_MenuItem%% = 12%%
CONST __UI_Type_MenuPanel%% = 13%%
CONST __UI_Type_PictureBox%% = 14%%
CONST __UI_Type_TrackBar%% = 15%%
CONST __UI_Type_ContextMenu%% = 16%%
CONST __UI_Type_Font%% = 17%%
CONST __UI_Type_ToggleSwitch%% = 18%%
CONST __UI_Type_TabControl%% = 19%%

'Back styles:
CONST __UI_Opaque%% = 0%%
CONST __UI_Transparent%% = -1%%

'Text alignment
CONST __UI_Left%% = 0%%
CONST __UI_Center%% = 1%%
CONST __UI_Right%% = 2%%
CONST __UI_Top%% = 0%%
CONST __UI_Middle%% = 1%%
CONST __UI_Bottom%% = 2%%

'Textbox controls
CONST __UI_NumericWithoutBounds%% = -1%%
CONST __UI_NumericWithBounds%% = 2%%

'BulletStyle
CONST __UI_CheckMark%% = 0%%
CONST __UI_Bullet%% = 1%%

'General constants
CONST __UI_ToolTipTimeOut! = 0.8!
CONST __UI_CantResizeV%% = 1%%
CONST __UI_CantResizeH%% = 2%%
CONST __UI_CantResize%% = 3%%

'Messagebox constants
CONST MsgBox_OkOnly& = 1&
CONST MsgBox_OkCancel& = 2&
CONST MsgBox_AbortRetryIgnore& = 4&
CONST MsgBox_YesNoCancel& = 8&
CONST MsgBox_YesNo& = 16&
CONST MsgBox_RetryCancel& = 32&
CONST MsgBox_CancelTryAgainContinue& = 64&

CONST MsgBox_Critical& = 128&
CONST MsgBox_Question& = 256&
CONST MsgBox_Exclamation& = 512&
CONST MsgBox_Information& = 1024&

CONST MsgBox_DefaultButton1& = 2048&
CONST MsgBox_DefaultButton2& = 4096&
CONST MsgBox_DefaultButton3& = 8192&
CONST MsgBox_Defaultbutton4& = 16384&

CONST MsgBox_AppModal& = 32768&
CONST MsgBox_SystemModal& = 65536&
CONST MsgBox_SetForeground& = 131072&

CONST MsgBox_Ok& = 1&
CONST MsgBox_Yes& = 2&
CONST MsgBox_No& = 3&
CONST MsgBox_Cancel& = 4&
CONST MsgBox_Abort& = 5&
CONST MsgBox_Retry& = 6&
CONST MsgBox_Ignore& = 7&
CONST MsgBox_TryAgain& = 8&
CONST MsgBox_Continue& = 9&

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
    IsCanvasHardware AS _BYTE
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
    Multiline AS _BYTE ' textbox takes several lines of text (Enter adds a line break; long lines wrap)
    NumericOnly AS _BYTE
    Searchable AS _BYTE ' dropdown list: typing while it's open filters its items
    Fuzzy AS _BYTE ' searchable dropdown list: letters of a word may have others in between; best matches first
    FirstVisibleLine AS LONG ' multiline textbox: topmost visual line shown (1-based)
    PrevFirstVisibleLine AS LONG
    CurrentLine AS LONG ' multiline textbox: visual line the cursor is on (1-based)
    PrevCurrentLine AS LONG
    VisibleCursor AS LONG ' textbox: cursor x position in pixels
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
    TabPage AS INTEGER ' tab a child of a TabControl belongs to (0 = all tabs)
    ChildCount AS LONG ' number of child controls (containers only)
    HoveringTab AS INTEGER ' tab under the mouse (TabControl only)
END TYPE

' Two control properties kept in sync (see __UI_Bind). Properties are
' __UI_PropertyEnum values.
TYPE __UI_BindingTYPE
    ID1 AS LONG
    Property1 AS LONG
    ID2 AS LONG
    Property2 AS LONG
    Inverted AS _BYTE ' values pass through NOT: non-zero becomes 0, and 0 becomes True
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

TYPE __UI_ThemeTYPE
    Name AS STRING ' display name
    Source AS STRING ' built-in theme name or theme file path, as passed to SetTheme
    Style AS _BYTE ' __UI_ThemeStyle_*
    ScrollbarWidth AS INTEGER
    ScrollbarButtonHeight AS INTEGER
    MenuBarOffset AS INTEGER
    MenuItemOffset AS INTEGER
    DefaultCaptionIndent AS INTEGER
    CornerRadius AS INTEGER
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
REDIM __UI_ThemeImages(0) AS HMap64
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
DIM SHARED __UI_IsDrawing AS _BYTE ' _TRUE while __UI_UpdateDisplay runs (input processing runs on another timer)
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

' Multiline textbox layout (see __UI_TBLayout). Holds the visual lines of one
' textbox at a time; offsets are 0-based positions into Text(id).
REDIM SHARED __UI_TBLineStart(1 TO 100) AS LONG ' where each visual line starts
REDIM SHARED __UI_TBLineLen(1 TO 100) AS LONG ' characters on the line, not counting a line break
DIM SHARED __UI_TBLineCount AS LONG
DIM SHARED __UI_TBNeedsScrollbar AS _BYTE
DIM SHARED __UI_TBLayoutID AS LONG, __UI_TBLayoutText AS STRING
DIM SHARED __UI_TBLayoutWidth AS LONG, __UI_TBLayoutHeight AS LONG, __UI_TBLayoutFont AS LONG
DIM SHARED __UI_TBLayoutBorder AS LONG, __UI_TBLayoutScrollbarWidth AS LONG
DIM SHARED __UI_TBKeepCaretX AS _BYTE ' Up/Down keep aiming at the same x (stored in .VisibleCursor)
' When set, pasting into a single-line textbox replaces line breaks with this text
' instead of keeping only the first line (UiEditor uses "\n")
DIM SHARED __UI_PasteLineBreakAs AS STRING

' Searchable dropdown lists (see __UI_FilterDropdownList). While one is open,
' the dropdown box shows the search text and the list shows only matching items.
DIM SHARED __UI_DropdownSearch AS STRING ' what has been typed so far
DIM SHARED __UI_DropdownSearchMap AS STRING

REDIM SHARED __UI_Bindings(1 TO 10) AS __UI_BindingTYPE
DIM SHARED __UI_TotalBindings AS LONG ' MKL$ of the dropdown's item number for each item shown

DIM SHARED __UI_Type(0 TO 19) AS __UI_Types

DIM SHARED __UI_Theme AS __UI_ThemeTYPE
DIM SHARED __UI_ThemeColor(1 TO __UI_ThemeColor_Count) AS _UNSIGNED LONG
DIM SHARED __UI_ThemeImageFile(1 TO __UI_ThemeImage_Count) AS STRING ' optional image files overriding the embedded bitmaps
