OPTION _EXPLICIT

DECLARE CUSTOMTYPE LIBRARY
    SUB __UI_MemCopy ALIAS memcpy (BYVAL dest AS _OFFSET, BYVAL source AS _OFFSET, BYVAL bytes AS LONG)
END DECLARE

$IF WIN THEN
    DECLARE LIBRARY
        FUNCTION __UI_MB& ALIAS MessageBox (BYVAL ignore&, message$, title$, BYVAL type&)
    END DECLARE
$ELSE
    DECLARE LIBRARY ""
    FUNCTION __UI_MB& ALIAS MessageBox (BYVAL ignore&, message$, title$, BYVAL type&)
    END DECLARE
$END IF

$RESIZE:ON
_RESIZE OFF

_CONTROLCHR OFF

TYPE __UI_ControlTYPE
    ID AS LONG
    ParentID AS LONG
    PreviousParentID AS LONG
    Type AS INTEGER
    Name AS STRING * 256
    Top AS INTEGER
    Left AS INTEGER
    Width AS INTEGER
    Height AS INTEGER
    Canvas AS LONG
    HelperCanvas AS LONG
    Stretch AS _BYTE
    PreviousStretch AS _BYTE
    Font AS INTEGER
    BackColor AS _UNSIGNED LONG
    ForeColor AS _UNSIGNED LONG
    SelectedForeColor AS _UNSIGNED LONG
    SelectedBackColor AS _UNSIGNED LONG
    BackStyle AS _BYTE
    HasBorder AS _BYTE
    Align AS _BYTE
    BorderColor AS _UNSIGNED LONG
    Value AS _FLOAT
    PreviousValue AS _FLOAT
    Min AS _FLOAT
    Max AS _FLOAT
    HotKey AS INTEGER
    HotKeyOffset AS INTEGER
    ShowPercentage AS _BYTE
    InputViewStart AS LONG
    PreviousInputViewStart AS LONG
    LastVisibleItem AS INTEGER
    HasVScrollbar AS _BYTE
    VScrollbarButton2Top AS INTEGER
    HoveringVScrollbarButton AS _BYTE
    ThumbHeight AS INTEGER
    ThumbTop AS INTEGER
    VScrollbarRatio AS SINGLE
    Cursor AS LONG
    PrevCursor AS LONG
    FieldArea AS LONG
    TextIsSelected AS _BYTE
    ControlIsSelected AS _BYTE
    SelectionLength AS LONG
    SelectionStart AS LONG
    Resizable AS _BYTE
    CanDrag AS _BYTE
    CanHaveFocus AS _BYTE
    Disabled AS _BYTE
    Hidden AS _BYTE
    CenteredWindow AS _BYTE
    ControlState AS _BYTE
    ChildrenRedrawn AS _BYTE
    FocusState AS LONG
END TYPE

REDIM SHARED __UI_Captions(1 TO 100) AS STRING
REDIM SHARED __UI_TempCaptions(1 TO 100) AS STRING
REDIM SHARED __UI_Texts(1 TO 100) AS STRING
REDIM SHARED __UI_TempTexts(1 TO 100) AS STRING
REDIM SHARED __UI_Controls(0 TO 100) AS __UI_ControlTYPE

DIM SHARED __UI_Fonts(2) AS LONG
__UI_Fonts(0) = 16
__UI_Fonts(1) = 8
__UI_Fonts(2) = __UI_LoadFont("arial.ttf", 12, "")

DIM SHARED __UI_MouseLeft AS INTEGER, __UI_MouseTop AS INTEGER
DIM SHARED __UI_MouseWheel AS INTEGER
DIM SHARED __UI_PrevMouseLeft AS INTEGER, __UI_PrevMouseTop AS INTEGER
DIM SHARED __UI_MouseButton1 AS _BYTE, __UI_MouseButton2 AS _BYTE
DIM SHARED __UI_PreviewTop AS INTEGER, __UI_PreviewLeft AS INTEGER
DIM SHARED __UI_MouseIsDown AS _BYTE, __UI_MouseDownOnID AS LONG
DIM SHARED __UI_KeyIsDown AS _BYTE, __UI_KeyDownOnID AS LONG
DIM SHARED __UI_ShiftIsDown AS _BYTE, __UI_CtrlIsDown AS _BYTE
DIM SHARED __UI_AltIsDown AS _BYTE, __UI_ShowHotKeys AS _BYTE, __UI_AltCombo$
DIM SHARED __UI_LastMouseClick AS DOUBLE, __UI_MouseDownOnListBox AS DOUBLE
DIM SHARED __UI_DragX AS INTEGER, __UI_DragY AS INTEGER
DIM SHARED __UI_DefaultButtonID AS LONG
DIM SHARED __UI_KeyHit AS LONG
DIM SHARED __UI_Focus AS LONG, __UI_PreviousFocus AS LONG
DIM SHARED __UI_HoveringID AS LONG
DIM SHARED __UI_IsDragging AS _BYTE, __UI_DraggingID AS LONG
DIM SHARED __UI_IsSelectingText AS _BYTE, __UI_IsSelectingTextOnID AS LONG
DIM SHARED __UI_SelectedText AS STRING, __UI_SelectionLength AS LONG
DIM SHARED __UI_DraggingThumb AS _BYTE, __UI_ThumbDragTop AS INTEGER
DIM SHARED __UI_DraggingThumbOnID AS LONG
DIM SHARED __UI_HasInput AS _BYTE, __UI_LastInputReceived AS DOUBLE
DIM SHARED __UI_UnloadSignal AS _BYTE
DIM SHARED __UI_ExitTriggered AS _BYTE
DIM SHARED __UI_Loaded AS _BYTE
DIM SHARED __UI_EventsTimer AS INTEGER, __UI_RefreshTimer AS INTEGER
DIM SHARED __UI_ActiveDropdownList AS LONG, __UI_ParentDropdownList AS LONG
DIM SHARED __UI_ActiveMenu AS LONG, __UI_ParentMenu AS LONG
DIM SHARED __UI_FormID AS LONG, __UI_HasMenuBar AS LONG
DIM SHARED __UI_ScrollbarWidth AS INTEGER
DIM SHARED __UI_ScrollbarButtonHeight AS INTEGER
DIM SHARED __UI_ForceRedraw AS _BYTE, __UI_AutoRefresh AS _BYTE

'Control types:
CONST __UI_Type_Form = 1
CONST __UI_Type_Frame = 2
CONST __UI_Type_Button = 3
CONST __UI_Type_Label = 4
CONST __UI_Type_CheckBox = 5
CONST __UI_Type_RadioButton = 6
CONST __UI_Type_TextBox = 7
CONST __UI_Type_ProgressBar = 8
CONST __UI_Type_ListBox = 9
CONST __UI_Type_DropdownList = 10
CONST __UI_Type_MenuBar = 11
CONST __UI_Type_MenuItem = 12
CONST __UI_Type_MenuPanel = 13
CONST __UI_Type_PictureBox = 14
CONST __UI_Type_MultiLineTextBox = 15

'Back styles:
CONST __UI_Opaque = 0
CONST __UI_Transparent = -1

'Text alignment
CONST __UI_Left = 0
CONST __UI_Center = 1
CONST __UI_Right = 2

'Messagebox constants
CONST __UI_MsgBox_OkOnly = 0
CONST __UI_MsgBox_OkCancel = 1
CONST __UI_MsgBox_AbortRetryIgnore = 2
CONST __UI_MsgBox_YesNoCancel = 3
CONST __UI_MsgBox_YesNo = 4
CONST __UI_MsgBox_RetryCancel = 5
CONST __UI_MsgBox_CancelTryagainContinue = 6

CONST __UI_MsgBox_Critical = 16
CONST __UI_MsgBox_Question = 32
CONST __UI_MsgBox_Exclamation = 48
CONST __UI_MsgBox_Information = 64

CONST __UI_MsgBox_DefaultButton1 = 0
CONST __UI_MsgBox_DefaultButton2 = 256
CONST __UI_MsgBox_DefaultButton3 = 512
CONST __UI_MsgBox_Defaultbutton4 = 768

CONST __UI_MsgBox_AppModal = 0
CONST __UI_MsgBox_SystemModal = 4096
CONST __UI_MsgBox_SetForeground = 65536

CONST __UI_MsgBox_Ok = 1
CONST __UI_MsgBox_Cancel = 2
CONST __UI_MsgBox_Abort = 3
CONST __UI_MsgBox_Retry = 4
CONST __UI_MsgBox_Ignore = 5
CONST __UI_MsgBox_Yes = 6
CONST __UI_MsgBox_No = 7
CONST __UI_MsgBox_Tryagain = 10
CONST __UI_MsgBox_Continue = 11

'Global constants
CONST __UI_True = -1
CONST __UI_False = 0

DIM NewID AS LONG

NewID = __UI_NewControl(__UI_Type_Form, "Form1", 800, 600, 0, 0, 0)
__UI_Controls(__UI_FormID).Font = 2

__UI_SetCaption "Form1", "Hello, world!"

NewID = __UI_NewControl(__UI_Type_MenuBar, "FileMenu", 0, 0, 0, 0, 0)
__UI_SetCaption "FileMenu", "&File"

NewID = __UI_NewControl(__UI_Type_MenuBar, "EditMenu", 0, 0, 0, 0, 0)
__UI_SetCaption "EditMenu", "&Edit"

NewID = __UI_NewControl(__UI_Type_MenuBar, "ControlsMenu", 0, 0, 0, 0, 0)
__UI_SetCaption "ControlsMenu", "Add &control"

NewID = __UI_NewControl(__UI_Type_MenuBar, "HelpMenu", 0, 0, 0, 0, 0)
__UI_Controls(NewID).Align = __UI_Right
__UI_SetCaption "HelpMenu", "&Help"

NewID = __UI_NewControl(__UI_Type_MenuItem, "FileMenuLoad", 0, 0, 0, 0, __UI_GetID("FileMenu"))
__UI_SetCaption "FileMenuLoad", "&Load form.frmbin"

NewID = __UI_NewControl(__UI_Type_MenuItem, "FileMenuSave", 0, 0, 0, 0, __UI_GetID("FileMenu"))
__UI_SetCaption "FileMenuSave", "&Save form"

NewID = __UI_NewControl(__UI_Type_MenuItem, "FileMenuExit", 0, 0, 0, 0, __UI_GetID("FileMenu"))
__UI_SetCaption "FileMenuExit", "E&xit"

NewID = __UI_NewControl(__UI_Type_MenuItem, "EditMenuPrefs", 0, 0, 0, 0, __UI_GetID("EditMenu"))
__UI_SetCaption "EditMenuPrefs", "&Preferences"
__UI_Controls(NewID).Disabled = __UI_True

NewID = __UI_NewControl(__UI_Type_MenuItem, "HelpMenuHelp", 0, 0, 0, 0, __UI_GetID("HelpMenu"))
__UI_SetCaption "HelpMenuHelp", "&What's all this?"

NewID = __UI_NewControl(__UI_Type_MenuItem, "HelpMenuAbout", 0, 0, 0, 0, __UI_GetID("HelpMenu"))
__UI_SetCaption "HelpMenuAbout", "&About..."

NewID = __UI_NewControl(__UI_Type_MenuItem, "AddButton", 0, 0, 0, 0, __UI_GetID("ControlsMenu"))
__UI_SetCaption "AddButton", "New button"

NewID = __UI_NewControl(__UI_Type_MenuItem, "AddLabel", 0, 0, 0, 0, __UI_GetID("ControlsMenu"))
__UI_SetCaption "AddLabel", "New label"

NewID = __UI_NewControl(__UI_Type_MenuItem, "AddTextBox", 0, 0, 0, 0, __UI_GetID("ControlsMenu"))
__UI_SetCaption "AddTextBox", "New text box"

NewID = __UI_NewControl(__UI_Type_Button, "Button1", 73, 21, 230, 100, 0)
__UI_SetCaption "Button1", "Click &me"

NewID = __UI_NewControl(__UI_Type_Button, "StretchBT", 230, 23, 100, 150, 0)
__UI_SetCaption "StretchBT", "Toggle 'Stretch'"

NewID = __UI_NewControl(__UI_Type_Button, "Button2", 230, 23, 100, 200, 0)
__UI_SetCaption "Button2", "Detach ListBox from frame"

NewID = __UI_NewControl(__UI_Type_Label, "TBLabel", 200, 20, 30, 230, 0)
__UI_SetCaption "TBLabel", "&Add items to the list:"

NewID = __UI_NewControl(__UI_Type_TextBox, "Textbox1", 250, 23, 30, 250, 0)
__UI_SetCaption "Textbox1", "Edit me"

NewID = __UI_NewControl(__UI_Type_Button, "AddItemBT", 90, 23, 290, 250, 0)
__UI_SetCaption "AddItemBT", "Add Item"

NewID = __UI_NewControl(__UI_Type_Label, "DragLabel", 400, 20, 10, 300, 0)
__UI_SetCaption "DragLabel", "Make controls draggable by pressing F2 while hovering them"

NewID = __UI_NewControl(__UI_Type_Label, "Label1", 400, 20, 10, 30, 0)
__UI_Controls(NewID).ForeColor = _RGB32(238, 238, 200)
__UI_Controls(NewID).BackColor = _RGB32(33, 100, 78)
__UI_Controls(NewID).Align = __UI_Center
__UI_SetCaption "Label1", "Waiting for you to click"

NewID = __UI_NewControl(__UI_Type_Label, "FocusLabel", 400, 20, 10, 55, 0)
__UI_SetCaption "FocusLabel", "No control has focus now"

NewID = __UI_NewControl(__UI_Type_Label, "HoverLabel", 400, 20, 10, 75, 0)

NewID = __UI_NewControl(__UI_Type_Label, "Label2", 300, 20, 30, 350, 0)
__UI_Controls(NewID).BackStyle = __UI_Transparent

NewID = __UI_NewControl(__UI_Type_Frame, "Frame1", 230, 150, 400, 60, 0)
__UI_SetCaption "Frame1", "&Text box options + List"

NewID = __UI_NewControl(__UI_Type_RadioButton, "Option1", 130, 17, 15, 15, __UI_GetID("Frame1"))
__UI_Controls(NewID).Value = __UI_True
__UI_SetCaption "Option1", "A&LL CAPS"

NewID = __UI_NewControl(__UI_Type_RadioButton, "Option2", 110, 17, 15, 40, __UI_GetID("Frame1"))
__UI_SetCaption "Option2", "&Normal"

NewID = __UI_NewControl(__UI_Type_CheckBox, "Check1", 150, 17, 15, 65, __UI_GetID("Frame1"))
__UI_SetCaption "Check1", "Allow n&umbers"

NewID = __UI_NewControl(__UI_Type_CheckBox, "Check2", 150, 17, 15, 90, __UI_GetID("Frame1"))
__UI_Controls(NewID).Value = __UI_True
__UI_SetCaption "Check2", "Allo&w letters"

NewID = __UI_NewControl(__UI_Type_DropdownList, "ListBox1", 200, 23, 15, 110, __UI_GetID("Frame1"))
__UI_AddListBoxItem "ListBox1", "Type in the textbox"
__UI_AddListBoxItem "ListBox1", "to add items here"
DIM i AS INTEGER
FOR i = 3 TO 120
    __UI_AddListBoxItem "ListBox1", "Item" + STR$(i)
NEXT i
__UI_Controls(NewID).Value = 1

NewID = __UI_NewControl(__UI_Type_ProgressBar, "ProgressBar1", 300, 23, 20, 370, 0)
__UI_Controls(NewID).ShowPercentage = __UI_True
__UI_SetCaption "ProgressBar1", "Ready"

NewID = __UI_NewControl(__UI_Type_Button, "STARTTASK", 130, 23, 340, 370, 0)
__UI_SetCaption "STARTTASK", "Start task"

NewID = __UI_NewControl(__UI_Type_PictureBox, "QB64Logo", 230, 150, 400, 215, 0)
__UI_LoadImage __UI_Controls(NewID), "test.png"

NewID = __UI_NewControl(__UI_Type_Button, "OkButton", 70, 23, 550, 370, 0)
__UI_SetCaption "OkButton", "OK"
__UI_DefaultButtonID = NewID

__UI_Init

'Main loop
DO
    _LIMIT 1
LOOP

'---------------------------------------------------------------------------------
SUB __UI_Init
    DIM i AS LONG
    SCREEN _NEWIMAGE(__UI_Controls(__UI_FormID).Width, __UI_Controls(__UI_FormID).Height, 32)
    DO UNTIL _SCREENEXISTS: _LIMIT 10: LOOP

    IF __UI_Controls(__UI_FormID).CenteredWindow THEN _SCREENMOVE _MIDDLE

    _DISPLAYORDER _HARDWARE
    _DISPLAY

    'Make sure all controls reference predeclared fonts;
    FOR i = 1 TO UBOUND(__UI_Controls)
        IF __UI_Controls(i).Font > UBOUND(__UI_Fonts) THEN __UI_Controls(i).Font = 0
    NEXT

    __UI_ThemeSetup

    __UI_EventsTimer = _FREETIMER
    __UI_RefreshTimer = _FREETIMER
    ON TIMER(__UI_EventsTimer, .008) __UI_DoEvents
    ON TIMER(__UI_RefreshTimer, .03) __UI_UpdateDisplay
    TIMER(__UI_EventsTimer) ON
    TIMER(__UI_RefreshTimer) ON

    __UI_AutoRefresh = __UI_True
    __UI_Loaded = __UI_True
    __UI_OnLoad
END SUB

'Event procedures: ---------------------------------------------------------------
'Generated at design time - code inside CASE statements to be added by programmer.
'---------------------------------------------------------------------------------
SUB __UI_Click (id AS LONG)
    DIM Answer AS _BYTE, Dummy AS LONG
    STATIC nextbutton AS LONG, nextlabel AS LONG, nexttb AS LONG

    IF nextbutton = 0 THEN nextbutton = 10
    IF nextlabel = 0 THEN nextlabel = 10
    IF nexttb = 0 THEN nexttb = 10

    SELECT CASE UCASE$(RTRIM$(__UI_Controls(id).Name))
        CASE "STRETCHBT"
            __UI_Controls(__UI_GetID("QB64Logo")).Stretch = NOT __UI_Controls(__UI_GetID("QB64Logo")).Stretch
        CASE "FILEMENULOAD"
            DIM a$, b$, i AS LONG
            DIM NewType AS INTEGER, NewWidth AS INTEGER, NewHeight AS INTEGER
            DIM NewLeft AS INTEGER, NewTop AS INTEGER, NewName AS STRING
            DIM NewParentID AS LONG, FloatValue AS _FLOAT

            IF _FILEEXISTS("form.frmbin") = 0 THEN
                Answer = __UI_MessageBox("UI", "File form.frmbin not found.", __UI_MsgBox_OkOnly + __UI_MsgBox_Critical)
            ELSE
                OPEN "form.frmbin" FOR BINARY AS #1
                b$ = SPACE$(2): GET #1, 1, b$
                IF b$ <> "UI" THEN
                    GOTO LoadError
                    EXIT SUB
                END IF

                __UI_AutoRefresh = __UI_False
                b$ = SPACE$(4): GET #1, , b$

                FOR i = 1 TO UBOUND(__UI_Controls)
                    IF __UI_Controls(i).Canvas <> 0 THEN _FREEIMAGE __UI_Controls(i).Canvas
                    IF __UI_Controls(i).HelperCanvas <> 0 THEN _FREEIMAGE __UI_Controls(i).HelperCanvas
                NEXT

                REDIM __UI_Captions(1 TO CVL(b$)) AS STRING
                REDIM __UI_TempCaptions(1 TO CVL(b$)) AS STRING
                REDIM __UI_Texts(1 TO CVL(b$)) AS STRING
                REDIM __UI_TempTexts(1 TO CVL(b$)) AS STRING
                REDIM __UI_Controls(0 TO CVL(b$)) AS __UI_ControlTYPE
                b$ = SPACE$(2): GET #1, , b$
                IF CVI(b$) <> -1 THEN GOTO LoadError
                DO
                    b$ = SPACE$(2): GET #1, , b$
                    NewType = CVI(b$)
                    b$ = SPACE$(2): GET #1, , b$
                    b$ = SPACE$(CVI(b$)): GET #1, , b$
                    NewName = b$
                    b$ = SPACE$(2): GET #1, , b$
                    NewWidth = CVI(b$)
                    b$ = SPACE$(2): GET #1, , b$
                    NewHeight = CVI(b$)
                    b$ = SPACE$(2): GET #1, , b$
                    NewLeft = CVI(b$)
                    b$ = SPACE$(2): GET #1, , b$
                    NewTop = CVI(b$)
                    b$ = SPACE$(4): GET #1, , b$
                    NewParentID = CVL(b$)

                    Dummy = __UI_NewControl(NewType, NewName, NewWidth, NewHeight, NewLeft, NewTop, NewParentID)

                    DO 'read properties
                        b$ = SPACE$(2): GET #1, , b$
                        SELECT CASE CVI(b$)
                            CASE -2 'Caption
                                b$ = SPACE$(4): GET #1, , b$
                                b$ = SPACE$(CVL(b$))
                                GET #1, , b$
                                __UI_Captions(Dummy) = b$
                            CASE -3 'Text
                                b$ = SPACE$(4): GET #1, , b$
                                b$ = SPACE$(CVL(b$))
                                GET #1, , b$
                                __UI_Texts(Dummy) = b$
                                IF __UI_Controls(Dummy).Type = __UI_Type_PictureBox THEN
                                    __UI_LoadImage __UI_Controls(Dummy), __UI_Texts(Dummy)
                                END IF
                            CASE -4 'Stretch
                                __UI_Controls(Dummy).Stretch = __UI_True
                            CASE -5 'Font
                                b$ = SPACE$(2): GET #1, , b$
                                __UI_Controls(Dummy).Font = CVI(b$)
                            CASE -6 'ForeColor
                                b$ = SPACE$(4): GET #1, , b$
                                __UI_Controls(Dummy).ForeColor = _CV(_UNSIGNED LONG, b$)
                            CASE -7 'BackColor
                                b$ = SPACE$(4): GET #1, , b$
                                __UI_Controls(Dummy).BackColor = _CV(_UNSIGNED LONG, b$)
                            CASE -8 'SelectedForeColor
                                b$ = SPACE$(4): GET #1, , b$
                                __UI_Controls(Dummy).SelectedForeColor = _CV(_UNSIGNED LONG, b$)
                            CASE -9 'SelectedBackColor
                                b$ = SPACE$(4): GET #1, , b$
                                __UI_Controls(Dummy).SelectedBackColor = _CV(_UNSIGNED LONG, b$)
                            CASE -10 'BorderColor
                                b$ = SPACE$(4): GET #1, , b$
                                __UI_Controls(Dummy).BorderColor = _CV(_UNSIGNED LONG, b$)
                            CASE -11
                                __UI_Controls(Dummy).BackStyle = __UI_Transparent
                            CASE -12
                                __UI_Controls(Dummy).HasBorder = __UI_True
                            CASE -13
                                b$ = SPACE$(1): GET #1, , b$
                                __UI_Controls(Dummy).Align = _CV(_BYTE, b$)
                            CASE -14
                                b$ = SPACE$(LEN(FloatValue)): GET #1, , b$
                                __UI_Controls(Dummy).Value = _CV(_FLOAT, b$)
                            CASE -15
                                b$ = SPACE$(LEN(FloatValue)): GET #1, , b$
                                __UI_Controls(Dummy).Min = _CV(_FLOAT, b$)
                            CASE -16
                                b$ = SPACE$(LEN(FloatValue)): GET #1, , b$
                                __UI_Controls(Dummy).Max = _CV(_FLOAT, b$)
                            CASE -17
                                b$ = SPACE$(2): GET #1, , b$
                                __UI_Controls(Dummy).HotKey = CVI(b$)
                            CASE -18
                                b$ = SPACE$(2): GET #1, , b$
                                __UI_Controls(Dummy).HotKeyOffset = CVI(b$)
                            CASE -19
                                __UI_Controls(Dummy).ShowPercentage = __UI_True
                            CASE -20
                                __UI_Controls(Dummy).CanHaveFocus = __UI_True
                            CASE -21
                                __UI_Controls(Dummy).Disabled = __UI_True
                            CASE -22
                                __UI_Controls(Dummy).Hidden = __UI_True
                            CASE -23
                                __UI_Controls(Dummy).CenteredWindow = __UI_True
                            CASE ELSE
                                EXIT DO
                        END SELECT
                    LOOP
                LOOP UNTIL EOF(1)
                CLOSE #1
                __UI_AutoRefresh = __UI_True
                EXIT SUB

                LoadError:
                __UI_AutoRefresh = __UI_True
                Answer = __UI_MessageBox("UI", "File form.frmbin is not valid.", __UI_MsgBox_OkOnly + __UI_MsgBox_Critical)
                CLOSE #1
            END IF
        CASE "FILEMENUSAVE"
            OPEN "form.frm" FOR OUTPUT AS #1
            OPEN "form.frmbin" FOR BINARY AS #2
            PRINT #1, "UI form, beta version"
            PRINT #1, "DIM __UI_NewID AS LONG"
            PRINT #1,
            b$ = "UI"
            PUT #2, 1, b$
            b$ = MKL$(UBOUND(__UI_Controls))
            PUT #2, , b$
            FOR i = 1 TO UBOUND(__UI_Controls)
                IF __UI_Controls(i).ID > 0 AND __UI_Controls(i).Type <> __UI_Type_MenuPanel AND LEN(RTRIM$(__UI_Controls(i).Name)) > 0 THEN
                    a$ = "__UI_NewID = __UI_NewControl("
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
                    END SELECT
                    a$ = a$ + CHR$(34) + RTRIM$(__UI_Controls(i).Name) + CHR$(34) + ","
                    a$ = a$ + STR$(__UI_Controls(i).Width) + ","
                    a$ = a$ + STR$(__UI_Controls(i).Height) + ","
                    a$ = a$ + STR$(__UI_Controls(i).Left) + ","
                    a$ = a$ + STR$(__UI_Controls(i).Top) + ","
                    a$ = a$ + STR$(__UI_Controls(i).ParentID) + ")"
                    PRINT #1, a$
                    b$ = MKI$(-1) + MKI$(__UI_Controls(i).Type) '-1 indicates a new control
                    b$ = b$ + MKI$(LEN(RTRIM$(__UI_Controls(i).Name)))
                    b$ = b$ + RTRIM$(__UI_Controls(i).Name)
                    b$ = b$ + MKI$(__UI_Controls(i).Width) + MKI$(__UI_Controls(i).Height) + MKI$(__UI_Controls(i).Left) + MKI$(__UI_Controls(i).Top) + MKL$(__UI_Controls(i).ParentID)
                    PUT #2, , b$

                    IF LEN(__UI_Captions(i)) > 0 THEN
                        a$ = "__UI_SetCaption " + CHR$(34) + RTRIM$(__UI_Controls(i).Name) + CHR$(34) + ", " + __UI_SpecialCharsToCHR$(__UI_Captions(i))
                        b$ = MKI$(-2) + MKL$(LEN(__UI_Captions(i))) '-2 indicates a caption
                        PUT #2, , b$
                        PUT #2, , __UI_Captions(i)
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
                                    a$ = "__UI_AddListBoxItem " + CHR$(34) + RTRIM$(__UI_Controls(i).Name) + CHR$(34) + ", " + CHR$(34) + TempCaption$ + CHR$(34)
                                    PRINT #1, a$
                                LOOP
                            CASE __UI_Type_PictureBox
                                a$ = "__UI_LoadImage __UI_Controls(__UI_NewID), " + CHR$(34) + __UI_Texts(i) + CHR$(34)
                                PRINT #1, a$
                            CASE ELSE
                                a$ = "__UI_SetText " + CHR$(34) + RTRIM$(__UI_Controls(i).Name) + CHR$(34) + ", " + __UI_SpecialCharsToCHR$(__UI_Captions(i))
                                PRINT #1, a$
                        END SELECT
                        b$ = MKI$(-3) + MKL$(LEN(__UI_Texts(i))) '-3 indicates a text
                        PUT #2, , b$
                        PUT #2, , __UI_Texts(i)
                    END IF
                    IF __UI_Controls(i).Stretch THEN PRINT #1, "__UI_Controls(__UI_NewID).Stretch = __UI_True"
                    b$ = MKI$(-4)
                    PUT #2, , b$
                    'Inheritable properties won't be saved if they are the same as the parent's
                    IF __UI_Controls(i).Type = __UI_Type_Form THEN
                        PRINT #1, "__UI_Controls(__UI_NewID).Font =" + STR$(__UI_Controls(i).Font)
                        b$ = MKI$(-5) + MKI$(__UI_Controls(i).Font)
                        PUT #2, , b$
                    ELSE
                        IF __UI_Controls(i).ParentID > 0 THEN
                            IF __UI_Controls(i).Font > 0 AND __UI_Controls(i).Font <> __UI_Controls(__UI_Controls(i).ParentID).Font THEN
                                PRINT #1, "__UI_Controls(__UI_NewID).Font =" + STR$(__UI_Controls(i).Font)
                                b$ = MKI$(-5) + MKI$(__UI_Controls(i).Font)
                                PUT #2, , b$
                            END IF
                        ELSE
                            IF __UI_Controls(i).Font > 0 AND __UI_Controls(i).Font <> __UI_Controls(__UI_FormID).Font THEN
                                PRINT #1, "__UI_Controls(__UI_NewID).Font =" + STR$(__UI_Controls(i).Font)
                                b$ = MKI$(-5) + MKI$(__UI_Controls(i).Font)
                                PUT #2, , b$
                            END IF
                        END IF
                    END IF
                    'Colors are saved only if they differ from the theme's defaults
                    IF __UI_Controls(i).ForeColor <> __UI_DefaultColor(__UI_Controls(i).Type, 1) THEN
                        PRINT #1, "__UI_Controls(__UI_NewID).ForeColor = _RGB32(" + LTRIM$(STR$(_RED32(__UI_Controls(i).ForeColor))) + ", " + LTRIM$(STR$(_GREEN32(__UI_Controls(i).ForeColor))) + ", " + LTRIM$(STR$(_BLUE32(__UI_Controls(i).ForeColor))) + ")"
                        b$ = MKI$(-6) + _MK$(_UNSIGNED LONG, __UI_Controls(i).ForeColor)
                        PUT #2, , b$
                    END IF
                    IF __UI_Controls(i).BackColor <> __UI_DefaultColor(__UI_Controls(i).Type, 2) THEN
                        PRINT #1, "__UI_Controls(__UI_NewID).BackColor = _RGB32(" + LTRIM$(STR$(_RED32(__UI_Controls(i).BackColor))) + ", " + LTRIM$(STR$(_GREEN32(__UI_Controls(i).BackColor))) + ", " + LTRIM$(STR$(_BLUE32(__UI_Controls(i).BackColor))) + ")"
                        b$ = MKI$(-7) + _MK$(_UNSIGNED LONG, __UI_Controls(i).BackColor)
                        PUT #2, , b$
                    END IF
                    IF __UI_Controls(i).SelectedForeColor <> __UI_DefaultColor(__UI_Controls(i).Type, 3) THEN
                        PRINT #1, "__UI_Controls(__UI_NewID).SelectedForeColor = _RGB32(" + LTRIM$(STR$(_RED32(__UI_Controls(i).SelectedForeColor))) + ", " + LTRIM$(STR$(_GREEN32(__UI_Controls(i).SelectedForeColor))) + ", " + LTRIM$(STR$(_BLUE32(__UI_Controls(i).SelectedForeColor))) + ")"
                        b$ = MKI$(-8) + _MK$(_UNSIGNED LONG, __UI_Controls(i).SelectedForeColor)
                        PUT #2, , b$
                    END IF
                    IF __UI_Controls(i).SelectedBackColor <> __UI_DefaultColor(__UI_Controls(i).Type, 4) THEN
                        PRINT #1, "__UI_Controls(__UI_NewID).SelectedBackColor = _RGB32(" + LTRIM$(STR$(_RED32(__UI_Controls(i).SelectedBackColor))) + ", " + LTRIM$(STR$(_GREEN32(__UI_Controls(i).SelectedBackColor))) + ", " + LTRIM$(STR$(_BLUE32(__UI_Controls(i).SelectedBackColor))) + ")"
                        b$ = MKI$(-9) + _MK$(_UNSIGNED LONG, __UI_Controls(i).SelectedBackColor)
                        PUT #2, , b$
                    END IF
                    IF __UI_Controls(i).BorderColor <> __UI_DefaultColor(__UI_Controls(i).Type, 5) THEN
                        PRINT #1, "__UI_Controls(__UI_NewID).BorderColor = _RGB32(" + LTRIM$(STR$(_RED32(__UI_Controls(i).BorderColor))) + ", " + LTRIM$(STR$(_GREEN32(__UI_Controls(i).BorderColor))) + ", " + LTRIM$(STR$(_BLUE32(__UI_Controls(i).BorderColor))) + ")"
                        b$ = MKI$(-10) + _MK$(_UNSIGNED LONG, __UI_Controls(i).BorderColor)
                        PUT #2, , b$
                    END IF
                    IF __UI_Controls(i).BackStyle = __UI_Transparent THEN
                        PRINT #1, "__UI_Controls(__UI_NewID).BackStyle = __UI_Transparent"
                        b$ = MKI$(-11): PUT #2, , b$
                    END IF
                    IF __UI_Controls(i).HasBorder THEN
                        PRINT #1, "__UI_Controls(__UI_NewID).HasBorder = __UI_True"
                        b$ = MKI$(-12): PUT #2, , b$
                    END IF
                    IF __UI_Controls(i).Align = __UI_Center THEN
                        PRINT #1, "__UI_Controls(__UI_NewID).Align = __UI_Center"
                        b$ = MKI$(-13) + _MK$(_BYTE, __UI_Controls(i).Align): PUT #2, , b$
                    ELSEIF __UI_Controls(i).Align = __UI_Right THEN
                        PRINT #1, "__UI_Controls(__UI_NewID).Align = __UI_Right"
                        b$ = MKI$(-13) + _MK$(_BYTE, __UI_Controls(i).Align): PUT #2, , b$
                    END IF
                    IF __UI_Controls(i).Value <> 0 THEN
                        PRINT #1, "__UI_Controls(__UI_NewID).Value = " + LTRIM$(STR$(__UI_Controls(i).Value))
                        b$ = MKI$(-14) + _MK$(_FLOAT, __UI_Controls(i).Value): PUT #2, , b$
                    END IF
                    IF __UI_Controls(i).Min <> 0 THEN
                        PRINT #1, "__UI_Controls(__UI_NewID).Min = " + LTRIM$(STR$(__UI_Controls(i).Min))
                        b$ = MKI$(-15) + _MK$(_FLOAT, __UI_Controls(i).Min): PUT #2, , b$
                    END IF
                    IF __UI_Controls(i).Max <> 0 THEN
                        PRINT #1, "__UI_Controls(__UI_NewID).Max = " + LTRIM$(STR$(__UI_Controls(i).Max))
                        b$ = MKI$(-16) + _MK$(_FLOAT, __UI_Controls(i).Max): PUT #2, , b$
                    END IF
                    IF __UI_Controls(i).HotKey <> 0 THEN
                        PRINT #1, "__UI_Controls(__UI_NewID).HotKey = " + LTRIM$(STR$(__UI_Controls(i).HotKey))
                        b$ = MKI$(-17) + MKI$(__UI_Controls(i).HotKey): PUT #2, , b$
                    END IF
                    IF __UI_Controls(i).HotKeyOffset <> 0 THEN
                        PRINT #1, "__UI_Controls(__UI_NewID).HotKeyOffset = " + LTRIM$(STR$(__UI_Controls(i).HotKeyOffset))
                        b$ = MKI$(-18) + MKI$(__UI_Controls(i).HotKeyOffset): PUT #2, , b$
                    END IF
                    IF __UI_Controls(i).ShowPercentage THEN
                        PRINT #1, "__UI_Controls(__UI_NewID).ShowPercentage = __UI_True"
                        b$ = MKI$(-19): PUT #2, , b$
                    END IF
                    IF __UI_Controls(i).CanHaveFocus THEN
                        PRINT #1, "__UI_Controls(__UI_NewID).CanHaveFocus = __UI_True"
                        b$ = MKI$(-20): PUT #2, , b$
                    END IF
                    IF __UI_Controls(i).Disabled THEN
                        PRINT #1, "__UI_Controls(__UI_NewID).Disabled = __UI_True"
                        b$ = MKI$(-21): PUT #2, , b$
                    END IF
                    IF __UI_Controls(i).Hidden THEN
                        PRINT #1, "__UI_Controls(__UI_NewID).Hidden = __UI_True"
                        b$ = MKI$(-22): PUT #2, , b$
                    END IF
                    IF __UI_Controls(i).CenteredWindow THEN
                        PRINT #1, "__UI_Controls(__UI_NewID).CenteredWindow = __UI_True"
                        b$ = MKI$(-23): PUT #2, , b$
                    END IF
                    PRINT #1,
                END IF
            NEXT
            b$ = MKI$(-1024): PUT #2, , b$ 'end of file
            CLOSE #1, #2
        CASE "ADDBUTTON"
            nextbutton = nextbutton + 1
            Dummy = __UI_NewControl(__UI_Type_Button, "Button" + LTRIM$(STR$(nextbutton)), 60, 23, 0, 0, 0)
            __UI_Controls(Dummy).CanDrag = __UI_True
            __UI_SetCaption __UI_Controls(Dummy).Name, RTRIM$(__UI_Controls(Dummy).Name)
        CASE "ADDLABEL"
            nextlabel = nextlabel + 1
            Dummy = __UI_NewControl(__UI_Type_Label, "Label" + LTRIM$(STR$(nextlabel)), 60, 23, 0, 0, 0)
            __UI_Controls(Dummy).CanDrag = __UI_True
            __UI_SetCaption __UI_Controls(Dummy).Name, RTRIM$(__UI_Controls(Dummy).Name)
        CASE "ADDTEXTBOX"
            nexttb = nexttb + 1
            Dummy = __UI_NewControl(__UI_Type_TextBox, "TextBox" + LTRIM$(STR$(nexttb)), 100, 23, 0, 0, 0)
            IF _FONTWIDTH(__UI_Fonts(__UI_Controls(Dummy).Font)) = 0 THEN __UI_Controls(Dummy).Font = 0
            __UI_Controls(Dummy).CanDrag = __UI_True
            __UI_Controls(Dummy).FieldArea = __UI_Controls(Dummy).Width \ _FONTWIDTH(__UI_Fonts(__UI_Controls(Dummy).Font)) - 1
            __UI_SetCaption __UI_Controls(Dummy).Name, RTRIM$(__UI_Controls(Dummy).Name)
        CASE "HELPMENUABOUT"
            Answer = __UI_MessageBox("UI", "UI beta" + CHR$(10) + "by Fellippe Heitor" + CHR$(10) + CHR$(10) + "Twitter: @fellippeheitor" + CHR$(10) + "e-mail: fellippe@qb64.org", __UI_MsgBox_OkOnly + __UI_MsgBox_Information)
        CASE "HELPMENUHELP"
            Answer = __UI_MessageBox("What's all this?", "This will soon become a GUI editor, which will allow an event-driven approach to programs written in QB64.", __UI_MsgBox_OkOnly + __UI_MsgBox_Information)
        CASE "FILEMENUEXIT"
            SYSTEM
        CASE "OKBUTTON"
            SYSTEM
        CASE "ADDITEMBT"
            IF LEN(__UI_Texts(__UI_GetID("TextBox1"))) THEN
                __UI_AddListBoxItem "ListBox1", __UI_Texts(__UI_GetID("TextBox1"))
                __UI_Texts(__UI_GetID("TextBox1")) = ""
                __UI_Controls(__UI_GetID("TextBox1")).Cursor = 0
                __UI_Controls(__UI_GetID("TextBox1")).TextIsSelected = __UI_False
                __UI_Focus = __UI_GetID("TextBox1")
            END IF
        CASE "BUTTON1"
            STATIC State AS _BYTE, TotalStops AS _BYTE
            State = State + 1: IF State > 3 THEN State = 1
            SELECT CASE State
                CASE 1
                    __UI_Controls(__UI_GetID("Label1")).Disabled = __UI_False
                    __UI_Captions(__UI_GetID("Label1")) = "You clicked the button!"
                CASE 2
                    __UI_Captions(__UI_GetID("Label1")) = "Aren't you the clicker? You'd better stop it"
                CASE 3
                    __UI_Controls(__UI_GetID("Label1")).Disabled = __UI_True
                    __UI_Captions(__UI_GetID("Label1")) = "Stop it."
                    IF TotalStops < 2 THEN
                        TotalStops = TotalStops + 1
                    ELSE
                        __UI_Controls(__UI_GetID("Button1")).Disabled = __UI_True
                        __UI_Captions(__UI_GetID("Label1")) = "I told you to stop it."
                    END IF
            END SELECT
        CASE "BUTTON2"
            IF __UI_Controls(__UI_GetID("listbox1")).ParentID THEN
                __UI_Controls(__UI_GetID("listbox1")).ParentID = 0
                __UI_Controls(__UI_GetID("listbox1")).Left = __UI_Controls(__UI_GetID("listbox1")).Left + __UI_Controls(__UI_GetID("Frame1")).Left
                __UI_Controls(__UI_GetID("listbox1")).Top = __UI_Controls(__UI_GetID("listbox1")).Top + __UI_Controls(__UI_GetID("Frame1")).Top
                __UI_Captions(__UI_GetID("Button2")) = "Move ListBox into frame"
            ELSE
                __UI_Controls(__UI_GetID("listbox1")).ParentID = __UI_GetID("Frame1")
                __UI_Controls(__UI_GetID("listbox1")).Left = __UI_Controls(__UI_GetID("listbox1")).Left - __UI_Controls(__UI_GetID("Frame1")).Left
                __UI_Controls(__UI_GetID("listbox1")).Top = __UI_Controls(__UI_GetID("listbox1")).Top - __UI_Controls(__UI_GetID("Frame1")).Top
                __UI_Captions(__UI_GetID("Button2")) = "Move ListBox out of frame"
            END IF
        CASE "STARTTASK"
            DIM pbid AS LONG
            STATIC RunningTask AS _BYTE

            IF RunningTask THEN
                RunningTask = __UI_False
                EXIT SUB
            END IF

            RunningTask = __UI_True
            __UI_SetCaption "Label2", "Performing task:"
            __UI_Controls(__UI_GetID("ProgressBar1")).Max = 100
            __UI_SetCaption "starttask", "Stop task"
            __UI_SetCaption "ProgressBar1", "Counting to 100... \#"
            __UI_Controls(__UI_GetID("ProgressBar1")).Value = 0
            i = 0
            pbid = __UI_GetID("ProgressBar1")
            DO WHILE i < 100
                i = i + 1
                __UI_Controls(pbid).Value = i
                IF NOT RunningTask THEN EXIT DO
                __UI_DoEvents
                _LIMIT 20
            LOOP
            RunningTask = __UI_False
            __UI_SetCaption "Label2", "Idle."
            __UI_Controls(__UI_GetID("STARTTASK")).Disabled = __UI_False
            IF i < 100 THEN
                __UI_SetCaption "ProgressBar1", "Interrupted."
            ELSE
                __UI_SetCaption "ProgressBar1", "Done."
            END IF
            __UI_SetCaption "starttask", "Start task"
        CASE "LABEL1"
            __UI_Captions(__UI_GetID("Label1")) = "I'm not a button..."
        CASE "OPTION1", "OPTION2", "CHECK1", "CHECK2"
            __UI_Focus = __UI_GetID("textbox1")
    END SELECT
END SUB

SUB __UI_MouseEnter (id AS LONG)
    SELECT CASE UCASE$(RTRIM$(__UI_Controls(id).Name))
        CASE "FORM1"

        CASE "BUTTON1"

        CASE "LABEL1"
            IF NOT __UI_Controls(__UI_GetID("Label1")).Disabled THEN
                __UI_Controls(__UI_GetID("Label1")).BackColor = _RGB32(127, 172, 127)
            END IF
    END SELECT
END SUB

SUB __UI_MouseLeave (id AS LONG)
    SELECT CASE UCASE$(RTRIM$(__UI_Controls(id).Name))
        CASE "FORM1"

        CASE "BUTTON1"

        CASE "LABEL1"
            IF NOT __UI_Controls(__UI_GetID("Label1")).Disabled THEN
                __UI_Controls(__UI_GetID("Label1")).BackColor = _RGB32(33, 100, 78)
            END IF
    END SELECT
END SUB

SUB __UI_FocusIn (id AS LONG)
    SELECT CASE UCASE$(RTRIM$(__UI_Controls(id).Name))
        CASE "FORM1"

        CASE "BUTTON1"

        CASE "LABEL1"

    END SELECT
END SUB

SUB __UI_FocusOut (id AS LONG)
    SELECT CASE UCASE$(RTRIM$(__UI_Controls(id).Name))
        CASE "FORM1"

        CASE "BUTTON1"

        CASE "LABEL1"

    END SELECT
END SUB

SUB __UI_MouseDown (id AS LONG)
    SELECT CASE UCASE$(RTRIM$(__UI_Controls(id).Name))
        CASE "FORM1"

        CASE "BUTTON1"

        CASE "LABEL1"

    END SELECT
END SUB

SUB __UI_MouseUp (id AS LONG)
    SELECT CASE UCASE$(RTRIM$(__UI_Controls(id).Name))
        CASE "FORM1"

        CASE "BUTTON1"

        CASE "LABEL1"

    END SELECT
END SUB

SUB __UI_BeforeUpdateDisplay
    STATIC Pass AS LONG

    IF LEN(__UI_Texts(__UI_GetID("TextBox1"))) THEN
        __UI_Controls(__UI_GetID("AddItemBT")).Disabled = __UI_False
    ELSE
        __UI_Controls(__UI_GetID("AddItemBT")).Disabled = __UI_True
    END IF

    IF __UI_Focus = __UI_GetID("TextBox1") THEN
        __UI_DefaultButtonID = __UI_GetID("AddItemBT")
    ELSE
        __UI_DefaultButtonID = __UI_GetID("okbutton")
    END IF

    IF __UI_Focus THEN
        __UI_SetCaption "FocusLabel", "Focus is on " + RTRIM$(__UI_Controls(__UI_Focus).Name)
        IF LEN(__UI_SelectedText) THEN
            __UI_SetCaption "FocusLabel", "Selected text: " + __UI_SelectedText
        END IF
        IF __UI_Focus = __UI_GetID("ListBox1") THEN
            __UI_SetCaption "FocusLabel", "__UI_ActiveDropdownList=" + STR$(__UI_ActiveDropdownList)
        END IF
    ELSE
        __UI_SetCaption "FocusLabel", "No control has focus now"
    END IF

    IF __UI_HoveringID THEN
        __UI_SetCaption "HoverLabel", "(" + STR$(__UI_MouseTop) + "," + STR$(__UI_MouseLeft) + ") Hovering " + RTRIM$(__UI_Controls(__UI_HoveringID).Name)
        IF __UI_Controls(__UI_HoveringID).Type = __UI_Type_MenuBar AND __UI_Controls(__UI_HoveringID).Value > 0 THEN
            __UI_Captions(__UI_GetID("hoverlabel")) = __UI_Captions(__UI_GetID("hoverlabel")) + "." + LTRIM$(STR$(__UI_Controls(__UI_HoveringID).Value))
        END IF
    END IF

    IF __UI_IsDragging = __UI_False THEN
        IF __UI_Controls(__UI_Focus).Type = __UI_Type_TextBox THEN
            IF __UI_IsSelectingText THEN
                __UI_SetCaption "Label2", "Sel.Start=" + STR$(__UI_Controls(__UI_IsSelectingTextOnID).SelectionStart) + " Cursor=" + STR$(__UI_Controls(__UI_Focus).Cursor)
                __UI_SetCaption "HoverLabel", "Selected?" + STR$(__UI_Controls(__UI_IsSelectingTextOnID).TextIsSelected)
            ELSE
                __UI_SetCaption "Label2", "Editing text on " + RTRIM$(__UI_Controls(__UI_Focus).Name)
            END IF
        ELSE
            IF __UI_MouseIsDown AND __UI_MouseDownOnID > 0 THEN
                __UI_SetCaption "Label2", "MouseDownOnID=" + RTRIM$(__UI_Controls(__UI_MouseDownOnID).Name)
            ELSEIF __UI_MouseIsDown THEN
                __UI_SetCaption "Label2", "HoveringID <> ID originally clicked"
            ELSE
                __UI_SetCaption "Label2", "Idle."
            END IF
        END IF
    ELSE
        __UI_SetCaption "Label2", "Dragging..." + STR$(__UI_PreviewLeft) + "," + STR$(__UI_PreviewTop)
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

END SUB

SUB __UI_BeginDrag (id AS LONG)
    SELECT CASE UCASE$(RTRIM$(__UI_Controls(id).Name))
        CASE "FORM1"

        CASE "BUTTON1"

        CASE "LABEL1"

        CASE "LABEL2"
    END SELECT
END SUB

SUB __UI_EndDrag (id AS LONG)
    SELECT CASE UCASE$(RTRIM$(__UI_Controls(id).Name))
        CASE "FORM1"

        CASE "BUTTON1"

        CASE "LABEL1"

        CASE "LABEL2"
    END SELECT
END SUB

SUB __UI_KeyPress (id AS LONG)
    SELECT CASE UCASE$(RTRIM$(__UI_Controls(id).Name))
        CASE "FORM1"

        CASE "BUTTON1"

        CASE "LABEL1"

        CASE "LABEL2"

        CASE "TEXTBOX1"
            SELECT CASE __UI_KeyHit
                CASE 48 TO 57
                    'Accept numbers?
                    IF __UI_Controls(__UI_GetID("check1")).Value = 0 THEN __UI_KeyHit = 0
                CASE 65 TO 90, 97 TO 122
                    'Accept letters?
                    IF __UI_Controls(__UI_GetID("option1")).Value THEN __UI_KeyHit = ASC(UCASE$(CHR$(__UI_KeyHit)))
                    IF __UI_Controls(__UI_GetID("check2")).Value = 0 THEN __UI_KeyHit = 0
            END SELECT
    END SELECT
END SUB

'---------------------------------------------------------------------------------
'Internal procedures: ------------------------------------------------------------
'---------------------------------------------------------------------------------
SUB __UI_ProcessInput
    DIM OldScreen&, i AS LONG
    DIM ContainerOffsetTop AS INTEGER, ContainerOffsetLeft AS INTEGER
    STATIC __UI_CurrentTitle AS STRING
    STATIC __UI_CurrentResizeStatus AS _BYTE

    __UI_HasInput = __UI_False

    __UI_ExitTriggered = _EXIT
    IF __UI_ExitTriggered AND 1 THEN __UI_ExitTriggered = __UI_True: __UI_HasInput = __UI_True

    'Mouse input (optimization kindly provided by Luke Ceddia):
    __UI_MouseWheel = 0
    IF __UI_MouseIsDown THEN __UI_HasInput = __UI_True
    IF _MOUSEINPUT THEN
        __UI_HasInput = __UI_True
        __UI_MouseWheel = __UI_MouseWheel + _MOUSEWHEEL
        IF _MOUSEBUTTON(1) = __UI_MouseButton1 AND _MOUSEBUTTON(2) = __UI_MouseButton2 THEN
            DO WHILE _MOUSEINPUT
                __UI_MouseWheel = __UI_MouseWheel + _MOUSEWHEEL
                IF NOT (_MOUSEBUTTON(1) = __UI_MouseButton1 AND _MOUSEBUTTON(2) = __UI_MouseButton2) THEN EXIT DO
            LOOP
        END IF
        __UI_MouseButton1 = _MOUSEBUTTON(1)
        __UI_MouseButton2 = _MOUSEBUTTON(2)
        __UI_MouseLeft = _MOUSEX
        __UI_MouseTop = _MOUSEY
    END IF

    'Hover detection
    IF __UI_PrevMouseLeft <> __UI_MouseLeft OR __UI_PrevMouseTop <> __UI_MouseTop THEN
        __UI_PrevMouseLeft = __UI_MouseLeft
        __UI_PrevMouseTop = __UI_MouseTop
        DIM TempHover AS LONG
        FOR i = 1 TO UBOUND(__UI_Controls)
            IF __UI_Controls(i).ID AND __UI_Controls(i).Type <> __UI_Type_MenuItem THEN
                __UI_Controls(i).HoveringVScrollbarButton = 0
                IF __UI_Controls(i).ParentID > 0 THEN
                    ContainerOffsetTop = __UI_Controls(__UI_Controls(i).ParentID).Top
                    ContainerOffsetLeft = __UI_Controls(__UI_Controls(i).ParentID).Left
                    'First make sure the mouse is inside the container:
                    IF __UI_MouseLeft >= ContainerOffsetLeft AND __UI_MouseLeft <= ContainerOffsetLeft + __UI_Controls(__UI_Controls(i).ParentID).Width - 1 AND __UI_MouseTop >= ContainerOffsetTop AND __UI_MouseTop <= ContainerOffsetTop + __UI_Controls(__UI_Controls(i).ParentID).Height - 1 THEN
                        'We're in. Now check for individual control:
                        IF __UI_MouseLeft >= ContainerOffsetLeft + __UI_Controls(i).Left AND __UI_MouseLeft <= ContainerOffsetLeft + __UI_Controls(i).Left + __UI_Controls(i).Width - 1 AND __UI_MouseTop >= ContainerOffsetTop + __UI_Controls(i).Top AND __UI_MouseTop <= ContainerOffsetTop + __UI_Controls(i).Top + __UI_Controls(i).Height - 1 THEN
                            TempHover = __UI_Controls(i).ID
                            IF __UI_Controls(i).HasVScrollbar AND __UI_IsDragging = __UI_False THEN
                                IF __UI_MouseLeft >= ContainerOffsetLeft + __UI_Controls(i).Left + __UI_Controls(i).Width - __UI_ScrollbarWidth THEN
                                    IF __UI_MouseTop <= __UI_Controls(i).Top + ContainerOffsetTop + __UI_ScrollbarButtonHeight AND __UI_DraggingThumb = __UI_False THEN
                                        'Hovering "up" button
                                        __UI_Controls(i).HoveringVScrollbarButton = 1
                                        __UI_Controls(i).PreviousInputViewStart = 0
                                    ELSEIF __UI_MouseTop >= __UI_Controls(i).Top + ContainerOffsetTop + __UI_Controls(i).Height - __UI_ScrollbarButtonHeight AND __UI_DraggingThumb = __UI_False THEN
                                        'Hovering "down" button
                                        __UI_Controls(i).HoveringVScrollbarButton = 2
                                        __UI_Controls(i).PreviousInputViewStart = 0
                                    ELSEIF __UI_MouseTop >= ContainerOffsetTop + __UI_Controls(i).ThumbTop AND __UI_MouseTop <= ContainerOffsetTop + __UI_Controls(i).ThumbTop + __UI_Controls(i).ThumbHeight THEN
                                        'Hovering the thumb
                                        __UI_Controls(i).HoveringVScrollbarButton = 3
                                        __UI_Controls(i).PreviousInputViewStart = 0
                                    ELSE
                                        'Hovering the track
                                        IF __UI_MouseTop < ContainerOffsetTop + __UI_Controls(i).ThumbTop THEN
                                            'Above the thumb
                                            __UI_Controls(i).HoveringVScrollbarButton = 4
                                        ELSE
                                            'Below the thumb
                                            __UI_Controls(i).HoveringVScrollbarButton = 5
                                        END IF
                                        __UI_Controls(i).PreviousInputViewStart = 0
                                    END IF
                                END IF
                            END IF
                        END IF
                    END IF
                ELSE
                    ContainerOffsetTop = 0
                    ContainerOffsetLeft = 0

                    IF __UI_MouseLeft >= __UI_Controls(i).Left AND __UI_MouseLeft <= __UI_Controls(i).Left + __UI_Controls(i).Width - 1 AND __UI_MouseTop >= __UI_Controls(i).Top AND __UI_MouseTop <= __UI_Controls(i).Top + __UI_Controls(i).Height - 1 THEN
                        TempHover = __UI_Controls(i).ID

                        IF __UI_Controls(i).HasVScrollbar AND __UI_IsDragging = __UI_False THEN
                            IF __UI_MouseLeft >= ContainerOffsetLeft + __UI_Controls(i).Left + __UI_Controls(i).Width - __UI_ScrollbarWidth THEN
                                IF __UI_MouseTop <= __UI_Controls(i).Top + ContainerOffsetTop + __UI_ScrollbarButtonHeight AND __UI_DraggingThumb = __UI_False THEN
                                    'Hovering "up" button
                                    __UI_Controls(i).HoveringVScrollbarButton = 1
                                    __UI_Controls(i).PreviousInputViewStart = 0
                                ELSEIF __UI_MouseTop >= __UI_Controls(i).Top + ContainerOffsetTop + __UI_Controls(i).Height - __UI_ScrollbarButtonHeight AND __UI_DraggingThumb = __UI_False THEN
                                    'Hovering "down" button
                                    __UI_Controls(i).HoveringVScrollbarButton = 2
                                    __UI_Controls(i).PreviousInputViewStart = 0
                                ELSEIF __UI_MouseTop >= ContainerOffsetTop + __UI_Controls(i).ThumbTop AND __UI_MouseTop <= ContainerOffsetTop + __UI_Controls(i).ThumbTop + __UI_Controls(i).ThumbHeight THEN
                                    'Hovering the thumb
                                    __UI_Controls(i).HoveringVScrollbarButton = 3
                                    __UI_Controls(i).PreviousInputViewStart = 0
                                ELSE
                                    'Hovering the track
                                    IF __UI_MouseTop < ContainerOffsetTop + __UI_Controls(i).ThumbTop THEN
                                        'Above the thumb
                                        __UI_Controls(i).HoveringVScrollbarButton = 4
                                        __UI_Controls(i).PreviousInputViewStart = 0
                                    ELSE
                                        'Below the thumb
                                        __UI_Controls(i).HoveringVScrollbarButton = 5
                                        __UI_Controls(i).PreviousInputViewStart = 0
                                    END IF
                                END IF
                            END IF
                        END IF
                    END IF
                END IF
            END IF
        NEXT

        IF __UI_ActiveMenu > 0 THEN
            IF __UI_Controls(TempHover).Type = __UI_Type_MenuPanel THEN
                'For an active menu, we'll detect individual menu items being hovered
                _FONT __UI_Fonts(__UI_Controls(TempHover).Font)
                FOR i = 1 TO UBOUND(__UI_Controls)
                    IF __UI_Controls(i).ParentID = __UI_ParentMenu THEN
                        IF __UI_MouseTop >= __UI_Controls(__UI_ActiveMenu).Top + __UI_Controls(i).Top AND __UI_MouseTop <= __UI_Controls(__UI_ActiveMenu).Top + __UI_Controls(i).Top + __UI_Controls(i).Height - 1 THEN
                            TempHover = __UI_Controls(i).ID
                            __UI_Focus = __UI_Controls(i).ID
                            __UI_Controls(__UI_ActiveMenu).Value = __UI_Focus
                            EXIT FOR 'as no menu items will overlap
                        END IF
                    END IF
                NEXT
            END IF
        END IF

        __UI_HoveringID = TempHover

        IF __UI_Controls(__UI_Focus).Type = __UI_Type_MenuBar AND __UI_Controls(__UI_HoveringID).Type = __UI_Type_MenuBar THEN
            IF __UI_ActiveMenu = 0 THEN
                __UI_Focus = __UI_HoveringID
            END IF
        ELSEIF __UI_Controls(__UI_Focus).Type = __UI_Type_MenuPanel AND __UI_Controls(__UI_HoveringID).Type = __UI_Type_MenuBar THEN
            IF __UI_ParentMenu <> __UI_HoveringID AND NOT __UI_Controls(__UI_HoveringID).Disabled THEN
                __UI_ActivateMenu __UI_Controls(__UI_HoveringID), __UI_False
                __UI_ForceRedraw = __UI_True
            ELSEIF __UI_Controls(__UI_HoveringID).Disabled THEN
                __UI_DestroyControl __UI_Controls(__UI_ActiveMenu)
                __UI_Focus = __UI_HoveringID
            END IF
        END IF
    END IF

    'Keyboard input:
    __UI_KeyHit = _KEYHIT
    IF __UI_KeyHit THEN __UI_HasInput = __UI_True

    'Resize event:
    '1- Triggered programatically:
    IF __UI_Controls(__UI_FormID).Resizable <> __UI_CurrentResizeStatus THEN
        __UI_CurrentResizeStatus = __UI_Controls(__UI_FormID).Resizable
        IF __UI_CurrentResizeStatus THEN
            _RESIZE ON
        ELSE
            _RESIZE OFF
        END IF
    END IF

    '2- Triggered by manually resizing:
    IF _RESIZE AND __UI_Controls(__UI_FormID).Resizable THEN
        __UI_Controls(__UI_FormID).Width = _RESIZEWIDTH
        __UI_Controls(__UI_FormID).Height = _RESIZEHEIGHT
        OldScreen& = _DEST
        SCREEN _NEWIMAGE(__UI_Controls(__UI_FormID).Width, __UI_Controls(__UI_FormID).Height, 32)
        _FREEIMAGE OldScreen&
        IF LEN(__UI_CurrentTitle) THEN _TITLE __UI_CurrentTitle
        __UI_HasInput = __UI_True
    END IF

    'Update main window title if needed
    IF __UI_CurrentTitle <> __UI_Captions(__UI_FormID) THEN
        __UI_CurrentTitle = __UI_Captions(__UI_FormID)
        _TITLE __UI_CurrentTitle
        __UI_HasInput = __UI_True
    END IF

    __UI_LastInputReceived = TIMER
END SUB

'---------------------------------------------------------------------------------
SUB __UI_UpdateDisplay
    STATIC GridDrawn AS _BYTE
    DIM i AS LONG, TempCaption$, TempColor~&
    DIM CaptionIndent AS INTEGER
    DIM ContainerOffsetLeft AS INTEGER, ContainerOffsetTop AS INTEGER
    DIM ControlState AS _BYTE '1 = Normal; 2 = Hover/focus; 3 = Mouse down; 4 = Disabled;

    IF __UI_AutoRefresh = __UI_False THEN EXIT SUB

    __UI_BeforeUpdateDisplay

    'Clear frames canvases and count its children:
    FOR i = 1 TO UBOUND(__UI_Controls)
        IF __UI_Controls(i).Type = __UI_Type_Frame THEN
            __UI_Controls(i).Value = 0 'Reset children counter
            _DEST __UI_Controls(i).Canvas
            COLOR , __UI_Controls(i).BackColor
            CLS
        ELSE
            IF __UI_Controls(i).ParentID > 0 AND __UI_Controls(i).Type <> __UI_Type_MenuItem THEN
                'Increase container's children controls counter
                __UI_Controls(__UI_Controls(i).ParentID).Value = __UI_Controls(__UI_Controls(i).ParentID).Value + 1
            END IF
        END IF
    NEXT

    _DEST 0

    IF __UI_IsDragging AND NOT (_KEYDOWN(100305) OR _KEYDOWN(100306)) THEN
        'Draw the alignment grid
        DIM GridX AS INTEGER, GridY AS INTEGER

        IF __UI_Controls(__UI_DraggingID).ParentID > 0 AND __UI_Controls(__UI_DraggingID).Type <> __UI_Type_MenuItem THEN
            _DEST __UI_Controls(__UI_Controls(__UI_DraggingID).ParentID).Canvas
            FOR GridX = 0 TO __UI_Controls(__UI_Controls(__UI_DraggingID).ParentID).Width STEP 10
                FOR GridY = 0 TO __UI_Controls(__UI_Controls(__UI_DraggingID).ParentID).Height STEP 10
                    PSET (GridX, GridY), __UI_Controls(__UI_Controls(__UI_DraggingID).ParentID).ForeColor
                NEXT
            NEXT
        ELSE
            IF NOT GridDrawn THEN
                'Draw grid onto main window's canvas
                GridDrawn = __UI_True
                'Free the hardware bg image:
                _FREEIMAGE __UI_Controls(__UI_FormID).Canvas
                'Create a new software one:
                __UI_Controls(__UI_FormID).Canvas = _NEWIMAGE(__UI_Controls(__UI_FormID).Width, __UI_Controls(__UI_FormID).Height, 32)
                'Draw on it:
                _DEST __UI_Controls(__UI_FormID).Canvas
                COLOR __UI_Controls(__UI_FormID).ForeColor, __UI_Controls(__UI_FormID).BackColor
                CLS
                FOR GridX = 0 TO __UI_Controls(__UI_FormID).Width STEP 10
                    FOR GridY = 0 TO __UI_Controls(__UI_FormID).Height STEP 10
                        PSET (GridX, GridY), __UI_Controls(__UI_FormID).ForeColor
                    NEXT
                NEXT
                'Make it a hardware version of itself:
                _DEST 0
                __UI_MakeHardwareImageFromCanvas __UI_Controls(__UI_FormID)
            END IF
        END IF
        _DEST 0
    ELSE
        IF GridDrawn THEN
            'Restore main window hardware bg
            GridDrawn = __UI_False
            'Free the hardware bg image:
            _FREEIMAGE __UI_Controls(__UI_FormID).Canvas
            'Create a new software one:
            __UI_Controls(__UI_FormID).Canvas = _NEWIMAGE(__UI_Controls(__UI_FormID).Width, __UI_Controls(__UI_FormID).Height, 32)
            'Draw on it:
            _DEST __UI_Controls(__UI_FormID).Canvas
            COLOR __UI_Controls(__UI_FormID).ForeColor, __UI_Controls(__UI_FormID).BackColor
            CLS
            IF __UI_HasMenuBar THEN
                LINE (0, _FONTHEIGHT(__UI_Fonts(__UI_Controls(__UI_FormID).Font)) * 1.5 + 1)-STEP(__UI_Controls(__UI_FormID).Width - 1, 0), __UI_Darken(__UI_Controls(__UI_FormID).BackColor, 80)
                LINE (0, _FONTHEIGHT(__UI_Fonts(__UI_Controls(__UI_FormID).Font)) * 1.5 + 2)-STEP(__UI_Controls(__UI_FormID).Width - 1, 0), __UI_Darken(__UI_Controls(__UI_FormID).BackColor, 120)
            END IF
            _DEST 0
            __UI_MakeHardwareImageFromCanvas __UI_Controls(__UI_FormID)
        END IF
    END IF

    'Control drawing
    FOR i = 1 TO UBOUND(__UI_Controls)
        IF __UI_Controls(i).ID > 0 AND NOT __UI_Controls(i).Hidden THEN
            'Direct the drawing to the appropriate canvas (main or container)
            IF __UI_Controls(i).ParentID > 0 AND __UI_Controls(i).Type <> __UI_Type_MenuItem THEN
                _DEST __UI_Controls(__UI_Controls(i).ParentID).Canvas
            ELSE
                _DEST 0
            END IF

            IF ((__UI_MouseIsDown AND i = __UI_MouseDownOnID) OR (__UI_KeyIsDown AND i = __UI_KeyDownOnID AND __UI_KeyDownOnID = __UI_Focus)) AND NOT __UI_Controls(i).Disabled THEN
                ControlState = 3
            ELSEIF (i = __UI_HoveringID AND __UI_Controls(i).Type = __UI_Type_MenuBar) THEN
                ControlState = 2
            ELSEIF (i = __UI_HoveringID AND __UI_Controls(i).Type <> __UI_Type_MenuBar AND NOT __UI_Controls(i).Disabled) THEN
                ControlState = 2
            ELSEIF __UI_Controls(i).Disabled THEN
                ControlState = 4
            ELSE
                ControlState = 1
            END IF

            SELECT CASE __UI_Controls(i).Type
                CASE __UI_Type_Form
                    'Main window:
                    _PUTIMAGE (0, 0), __UI_Controls(i).Canvas, 0
                CASE __UI_Type_Button
                    'Buttons
                    __UI_DrawButton __UI_Controls(i), ControlState
                CASE __UI_Type_Label
                    'Labels
                    __UI_DrawLabel __UI_Controls(i), ControlState
                CASE __UI_Type_RadioButton
                    'Radio buttons
                    __UI_DrawRadioButton __UI_Controls(i), ControlState
                CASE __UI_Type_CheckBox
                    'Check boxes
                    __UI_DrawCheckBox __UI_Controls(i), ControlState
                CASE __UI_Type_ProgressBar
                    'Progress bars
                    __UI_DrawProgressBar __UI_Controls(i), ControlState
                CASE __UI_Type_TextBox
                    'Text boxes
                    IF __UI_Controls(i).InputViewStart = 0 THEN __UI_Controls(i).InputViewStart = 1

                    IF __UI_Controls(i).TextIsSelected THEN
                        DIM s1 AS LONG, s2 AS LONG
                        DIM ss1 AS LONG, ss2 AS LONG

                        s1 = __UI_Controls(i).SelectionStart
                        s2 = __UI_Controls(i).Cursor
                        IF s1 > s2 THEN
                            SWAP s1, s2
                            IF __UI_Controls(i).InputViewStart > 1 THEN
                                ss1 = s1 - __UI_Controls(i).InputViewStart + 1
                            ELSE
                                ss1 = s1
                            END IF
                            ss2 = s2 - s1
                            IF ss1 + ss2 > __UI_Controls(__UI_Focus).FieldArea THEN ss2 = __UI_Controls(__UI_Focus).FieldArea - ss1
                        ELSE
                            ss1 = s1
                            ss2 = s2 - s1
                            IF ss1 < __UI_Controls(i).InputViewStart THEN ss1 = 0: ss2 = s2 - __UI_Controls(i).InputViewStart + 1
                            IF ss1 > __UI_Controls(i).InputViewStart THEN ss1 = ss1 - __UI_Controls(i).InputViewStart + 1: ss2 = s2 - s1
                        END IF

                        __UI_SelectedText = MID$(__UI_Texts(i), s1 + 1, s2 - s1)
                        __UI_SelectionLength = LEN(__UI_SelectedText)
                    END IF

                    __UI_DrawTextBox __UI_Controls(i), ControlState, ss1, ss2
                CASE __UI_Type_ListBox
                    'List boxes
                    IF __UI_Controls(i).InputViewStart <= 0 THEN __UI_Controls(i).InputViewStart = 1

                    __UI_DrawListBox __UI_Controls(i), ControlState
                CASE __UI_Type_DropdownList
                    'Dropdown lists
                    IF __UI_Controls(i).Value = 0 THEN __UI_Controls(i).Value = 1

                    __UI_DrawDropdownList __UI_Controls(i), ControlState
                CASE __UI_Type_MenuBar
                    __UI_DrawMenuBar __UI_Controls(i), ControlState
                CASE __UI_Type_PictureBox
                    __ui_DrawPictureBox __UI_Controls(i), ControlState
            END SELECT
        END IF

        IF __UI_Controls(i).ParentID > 0 AND __UI_Controls(i).Type <> __UI_Type_MenuItem THEN
            'Check if no more controls will be drawn in this frame so it can be drawn too
            DIM CheckChildControls AS LONG, NoMoreChildren AS _BYTE, ThisParent AS LONG

            ThisParent = __UI_Controls(i).ParentID
            NoMoreChildren = __UI_True
            FOR CheckChildControls = i + 1 TO UBOUND(__UI_Controls)
                IF __UI_Controls(CheckChildControls).ParentID = ThisParent THEN
                    NoMoreChildren = __UI_False
                    EXIT FOR
                END IF
            NEXT

            IF NoMoreChildren THEN
                'Draw frame
                __UI_DrawFrame __UI_Controls(ThisParent)
            END IF
        END IF
    NEXT

    IF __UI_ActiveMenu > 0 THEN
        __UI_DrawMenuPanel __UI_Controls(__UI_ActiveMenu), ControlState
    END IF

    __UI_ForceRedraw = __UI_False

    STATIC WaitMessage AS LONG, WaitMessageSetup AS _BYTE
    DIM PrevDest AS LONG, NoInputMessage$
    IF TIMER - __UI_LastInputReceived > 2 THEN
        'Visually indicate that something is hogging the input routine
        IF WaitMessage = 0 THEN
            WaitMessage = _NEWIMAGE(_WIDTH(0), _HEIGHT(0), 32)
        ELSEIF _WIDTH(WaitMessage) <> _WIDTH(0) OR _HEIGHT(WaitMessage) <> _HEIGHT(0) THEN
            _FREEIMAGE WaitMessage
            WaitMessage = _NEWIMAGE(_WIDTH(0), _HEIGHT(0), 32)
        END IF

        IF WaitMessageSetup = __UI_False THEN
            WaitMessageSetup = __UI_True
            PrevDest = _DEST
            _DEST WaitMessage
            LINE (0, 0)-STEP(_WIDTH, _HEIGHT), _RGBA32(0, 0, 0, 170), BF
            _FONT 16
            _PRINTMODE _KEEPBACKGROUND
            NoInputMessage$ = "Please wait..."
            COLOR _RGB32(0, 0, 0)
            _PRINTSTRING (_WIDTH / 2 - _PRINTWIDTH(NoInputMessage$) / 2 + 1, _HEIGHT \ 2 - _FONTWIDTH + 1), NoInputMessage$
            COLOR _RGB32(255, 255, 255)
            _PRINTSTRING (_WIDTH / 2 - _PRINTWIDTH(NoInputMessage$) / 2, _HEIGHT \ 2 - _FONTWIDTH), NoInputMessage$
            _DEST PrevDest
            __UI_MakeHardwareImage WaitMessage
        END IF
        IF _EXIT THEN SYSTEM 'Can't force user to wait...
        _PUTIMAGE , WaitMessage
    END IF

    _DISPLAY
END SUB

'---------------------------------------------------------------------------------
FUNCTION __UI_Darken~& (WhichColor~&, ByHowMuch%)
    __UI_Darken~& = _RGB32(_RED32(WhichColor~&) * (ByHowMuch% / 100), _GREEN32(WhichColor~&) * (ByHowMuch% / 100), _BLUE32(WhichColor~&) * (ByHowMuch% / 100))
END FUNCTION

SUB __UI_EventDispatcher
    STATIC __UI_LastHoveringID AS LONG
    STATIC __UI_LastMouseIconSet AS _BYTE
    STATIC __UI_PreviousMouseDownOnID AS LONG
    STATIC __UI_JustOpenedMenu AS _BYTE
    DIM i AS LONG, ThisItem%
    DIM ContainerOffsetLeft AS INTEGER, ContainerOffsetTop AS INTEGER

    IF __UI_HoveringID = 0 AND __UI_Focus = 0 THEN EXIT SUB

    IF __UI_Controls(__UI_HoveringID).ParentID > 0 AND __UI_Controls(__UI_HoveringID).Type <> __UI_Type_MenuItem THEN
        ContainerOffsetLeft = __UI_Controls(__UI_Controls(__UI_HoveringID).ParentID).Left
        ContainerOffsetTop = __UI_Controls(__UI_Controls(__UI_HoveringID).ParentID).Top
    END IF

    $IF WIN THEN
        'Alt+F4 - Windows
        IF ((_KEYDOWN(100308) OR _KEYDOWN(100307)) AND __UI_KeyHit = -15872) OR __UI_ExitTriggered THEN
            __UI_UnloadSignal = __UI_True
            __UI_BeforeUnload
            IF __UI_UnloadSignal THEN SYSTEM
        END IF
    $ELSE
        IF __UI_ExitTriggered THEN
        __UI_UnloadSignal = __UI_True
        __UI_BeforeUnload
        IF __UI_UnloadSignal THEN SYSTEM
        END IF
    $END IF

    'Hover actions
    IF __UI_LastHoveringID <> __UI_HoveringID THEN
        'MouseEnter, MouseLeave
        IF __UI_LastHoveringID THEN __UI_MouseLeave __UI_LastHoveringID
        __UI_MouseEnter __UI_HoveringID

        STATIC LastMouseLeft AS INTEGER
        IF NOT __UI_DraggingThumb AND __UI_HoveringID = __UI_ActiveDropdownList AND __UI_Controls(__UI_HoveringID).HoveringVScrollbarButton = 0 THEN
            'Dropdown list items are preselected when hovered
            ThisItem% = ((__UI_MouseTop - (ContainerOffsetTop + __UI_Controls(__UI_HoveringID).Top)) \ _FONTHEIGHT(__UI_Fonts(__UI_Controls(__UI_HoveringID).Font))) + __UI_Controls(__UI_HoveringID).InputViewStart
            IF ThisItem% >= __UI_Controls(__UI_HoveringID).Min AND ThisItem% <= __UI_Controls(__UI_HoveringID).Max THEN
                __UI_Controls(__UI_HoveringID).Value = ThisItem%
            END IF
        ELSEIF __UI_Controls(__UI_HoveringID).Type = __UI_Type_MenuBar AND LastMouseLeft <> __UI_MouseLeft THEN
            LastMouseLeft = __UI_MouseLeft
            IF __UI_ActiveMenu > 0 AND __UI_ParentMenu <> __UI_Controls(__UI_HoveringID).ID AND __UI_ParentMenu > 0 THEN
                __UI_ActivateMenu __UI_Controls(__UI_HoveringID), __UI_False
                __UI_ForceRedraw = __UI_True
            END IF
        END IF

        IF __UI_Controls(__UI_Focus).Type = __UI_Type_MenuItem AND __UI_Controls(__UI_HoveringID).Type <> __UI_Type_MenuItem THEN
            __UI_Focus = __UI_ActiveMenu
        END IF
    END IF

    $IF WIN OR MAC THEN
        IF __UI_Controls(__UI_HoveringID).CanDrag THEN
            IF __UI_LastMouseIconSet <> 1 THEN
                __UI_LastMouseIconSet = 1
                _MOUSESHOW "link"
            END IF
        ELSEIF __UI_Controls(__UI_HoveringID).Type = __UI_Type_TextBox THEN
            IF __UI_LastMouseIconSet <> 2 THEN
                __UI_LastMouseIconSet = 2
                _MOUSESHOW "text"
            END IF
        ELSE
            IF __UI_LastMouseIconSet <> 0 THEN
                __UI_LastMouseIconSet = 0
                _MOUSESHOW "default"
            END IF
        END IF
    $END IF

    'FocusIn, FocusOut
    IF __UI_KeyHit = 9 AND __UI_IsDragging = __UI_False THEN 'TAB
        DIM __UI_FocusSearch AS LONG
        __UI_FocusSearch = __UI_Focus
        DO
            IF _KEYDOWN(100304) OR _KEYDOWN(100303) THEN
                __UI_FocusSearch = (__UI_FocusSearch + UBOUND(__UI_Controls) - 2) MOD UBOUND(__UI_Controls) + 1
            ELSE
                __UI_FocusSearch = __UI_FocusSearch MOD UBOUND(__UI_Controls) + 1
            END IF
            IF __UI_FocusSearch = __UI_Focus THEN
                'Full circle. No controls can have focus
                EXIT DO
            END IF

            IF __UI_Controls(__UI_FocusSearch).CanHaveFocus AND NOT __UI_Controls(__UI_FocusSearch).Disabled THEN
                IF __UI_Focus <> __UI_FocusSearch THEN __UI_FocusOut __UI_Focus
                __UI_Focus = __UI_FocusSearch
                __UI_FocusIn __UI_Focus
                EXIT DO
            END IF
        LOOP
    END IF

    'Any visible dropdown lists/menus will be destroyed when focus is lost
    IF __UI_ActiveDropdownList > 0 AND ((__UI_Focus <> __UI_ActiveDropdownList AND __UI_Focus <> __UI_ParentDropdownList) OR __UI_KeyHit = 27) THEN
        __UI_Focus = __UI_ParentDropdownList
        __UI_DestroyControl __UI_Controls(__UI_ActiveDropdownList)
        __UI_KeyHit = 0
    ELSEIF __UI_ActiveMenu > 0 AND (__UI_Focus <> __UI_ActiveMenu AND __UI_Focus <> __UI_ParentMenu) THEN
        IF __UI_Controls(__UI_Focus).Type <> __UI_Type_MenuItem THEN
            __UI_DestroyControl __UI_Controls(__UI_ActiveMenu)
            __UI_ForceRedraw = __UI_True
        END IF
    END IF

    'MouseWheel
    IF __UI_MouseWheel THEN
        IF (__UI_Controls(__UI_HoveringID).Type = __UI_Type_ListBox AND NOT __UI_Controls(__UI_HoveringID).Disabled) THEN
            __UI_Controls(__UI_HoveringID).InputViewStart = __UI_Controls(__UI_HoveringID).InputViewStart + __UI_MouseWheel
            IF __UI_Controls(__UI_HoveringID).InputViewStart + __UI_Controls(__UI_HoveringID).LastVisibleItem > __UI_Controls(__UI_HoveringID).Max THEN
                __UI_Controls(__UI_HoveringID).InputViewStart = __UI_Controls(__UI_HoveringID).Max - __UI_Controls(__UI_HoveringID).LastVisibleItem + 1
            END IF
        ELSEIF (__UI_ActiveDropdownList > 0 AND __UI_Focus = __UI_ActiveDropdownList AND __UI_ParentDropdownList = __UI_HoveringID) THEN
            __UI_Controls(__UI_ActiveDropdownList).InputViewStart = __UI_Controls(__UI_ActiveDropdownList).InputViewStart + __UI_MouseWheel
            IF __UI_Controls(__UI_ActiveDropdownList).InputViewStart + __UI_Controls(__UI_ActiveDropdownList).LastVisibleItem > __UI_Controls(__UI_ActiveDropdownList).Max THEN
                __UI_Controls(__UI_ActiveDropdownList).InputViewStart = __UI_Controls(__UI_ActiveDropdownList).Max - __UI_Controls(__UI_ActiveDropdownList).LastVisibleItem + 1
            END IF
        ELSEIF (__UI_Controls(__UI_Focus).Type = __UI_Type_DropdownList AND NOT __UI_Controls(__UI_Focus).Disabled) THEN
            __UI_Controls(__UI_Focus).Value = __UI_Controls(__UI_Focus).Value + __UI_MouseWheel
            IF __UI_Controls(__UI_Focus).Value < 1 THEN __UI_Controls(__UI_Focus).Value = 1
            IF __UI_Controls(__UI_Focus).Value > __UI_Controls(__UI_Focus).Max THEN __UI_Controls(__UI_Focus).Value = __UI_Controls(__UI_Focus).Max
        END IF
    END IF

    'MouseDown, MouseUp, BeginDrag
    IF __UI_MouseButton2 THEN
        'IF __UI_Controls(__UI_HoveringID).Type = __UI_Type_ListBox THEN
        '    DIM ItemToRemove AS INTEGER
        '    ItemToRemove = ((__UI_MouseTop - (ContainerOffsetTop + __UI_Controls(__UI_HoveringID).Top)) \ _FONTHEIGHT(__UI_Fonts(__UI_Controls(__UI_HoveringID).Font))) + __UI_Controls(__UI_HoveringID).InputViewStart
        '    IF ItemToRemove <= __UI_Controls(__UI_HoveringID).Max THEN
        '        IF __UI_Controls(__UI_HoveringID).InputViewStart + __UI_Controls(__UI_HoveringID).LastVisibleItem > __UI_Controls(__UI_HoveringID).Max THEN __UI_Controls(__UI_HoveringID).InputViewStart = __UI_Controls(__UI_HoveringID).InputViewStart - 1
        '        __UI_RemoveListBoxItem __UI_Controls(__UI_HoveringID).Name, ItemToRemove
        '    END IF
        'END IF
        '__UI_DestroyControl __UI_Controls(__UI_HoveringID)
        'EXIT SUB
    END IF

    IF __UI_MouseButton1 THEN
        'Mouse button is first pressed
        IF __UI_MouseIsDown = __UI_False THEN
            IF __UI_Controls(__UI_HoveringID).CanHaveFocus AND NOT __UI_Controls(__UI_HoveringID).Disabled THEN
                IF __UI_Focus <> __UI_HoveringID THEN
                    __UI_FocusOut __UI_Focus
                    __UI_Focus = __UI_HoveringID
                    __UI_FocusIn __UI_Focus
                END IF
            ELSE
                IF __UI_Controls(__UI_HoveringID).Type = __UI_Type_MenuBar AND __UI_ActiveMenu > 0 AND __UI_HoveringID = __UI_ParentMenu THEN
                    __UI_Focus = __UI_PreviousFocus
                ELSEIF __UI_Controls(__UI_HoveringID).Type = __UI_Type_MenuBar AND __UI_ActiveMenu = 0 THEN
                    __UI_ActivateMenu __UI_Controls(__UI_HoveringID), __UI_False
                    __UI_JustOpenedMenu = __UI_True
                ELSEIF __UI_Controls(__UI_HoveringID).Type = __UI_Type_MenuItem THEN
                    'Do nothing until mouseup (click)
                ELSE
                    IF __UI_Focus > 0 THEN __UI_FocusOut __UI_Focus
                    __UI_Focus = 0
                END IF
            END IF
            __UI_MouseIsDown = __UI_True
            __UI_MouseDownOnID = __UI_HoveringID
            IF __UI_Controls(__UI_HoveringID).CanDrag THEN
                IF __UI_IsDragging = __UI_False THEN
                    __UI_IsDragging = __UI_True
                    __UI_DraggingID = __UI_HoveringID
                    __UI_BeginDrag __UI_DraggingID
                    __UI_DragY = __UI_MouseTop
                    __UI_DragX = __UI_MouseLeft
                END IF
            END IF
            IF __UI_Controls(__UI_HoveringID).Type = __UI_Type_TextBox AND NOT __UI_Controls(__UI_HoveringID).Disabled THEN
                _FONT __UI_Fonts(__UI_Controls(__UI_HoveringID).Font)
                __UI_Controls(__UI_HoveringID).TextIsSelected = __UI_False
                __UI_SelectedText = ""
                __UI_SelectionLength = 0
                __UI_Controls(__UI_HoveringID).SelectionStart = ((__UI_MouseLeft - __UI_Controls(__UI_HoveringID).Left) / _FONTWIDTH) + (__UI_Controls(__UI_HoveringID).InputViewStart - 1)
                __UI_Controls(__UI_HoveringID).Cursor = __UI_Controls(__UI_HoveringID).SelectionStart
                IF __UI_Controls(__UI_HoveringID).SelectionStart > LEN(__UI_Texts(__UI_HoveringID)) THEN __UI_Controls(__UI_HoveringID).SelectionStart = LEN(__UI_Texts(__UI_HoveringID))
                IF __UI_Controls(__UI_HoveringID).Cursor > LEN(__UI_Texts(__UI_HoveringID)) THEN __UI_Controls(__UI_HoveringID).Cursor = LEN(__UI_Texts(__UI_HoveringID))
                __UI_IsSelectingText = __UI_True
                __UI_IsSelectingTextOnID = __UI_HoveringID
            ELSEIF __UI_Controls(__UI_HoveringID).Type = __UI_Type_ListBox AND NOT __UI_Controls(__UI_HoveringID).Disabled THEN
                IF __UI_Controls(__UI_HoveringID).HoveringVScrollbarButton = 1 OR __UI_Controls(__UI_HoveringID).HoveringVScrollbarButton = 2 OR __UI_Controls(__UI_HoveringID).HoveringVScrollbarButton = 4 OR __UI_Controls(__UI_HoveringID).HoveringVScrollbarButton = 5 THEN
                    __UI_MouseDownOnListBox = TIMER
                ELSEIF __UI_Controls(__UI_HoveringID).HoveringVScrollbarButton = 3 THEN
                    IF NOT __UI_DraggingThumb THEN
                        __UI_DraggingThumb = __UI_True
                        __UI_ThumbDragTop = __UI_MouseTop
                        __UI_DraggingThumbOnID = __UI_HoveringID
                    END IF
                END IF
            END IF
            __UI_MouseDown __UI_HoveringID
        ELSE
            'Mouse button is still pressed
            IF __UI_MouseDownOnID <> __UI_HoveringID AND __UI_MouseDownOnID > 0 THEN
                IF __UI_Controls(__UI_HoveringID).Type = __UI_Type_MenuItem OR __UI_Controls(__UI_HoveringID).Type = __UI_Type_MenuPanel OR __UI_Controls(__UI_HoveringID).Type = __UI_Type_MenuBar THEN
                    __UI_MouseDownOnID = __UI_HoveringID
                ELSE
                    __UI_PreviousMouseDownOnID = __UI_MouseDownOnID
                    __UI_MouseDownOnID = 0
                END IF
            ELSEIF __UI_HoveringID = __UI_PreviousMouseDownOnID AND __UI_PreviousMouseDownOnID > 0 THEN
                __UI_MouseDownOnID = __UI_PreviousMouseDownOnID
                __UI_PreviousMouseDownOnID = 0
            ELSEIF __UI_MouseDownOnID = __UI_HoveringID THEN
                IF __UI_IsSelectingText THEN
                    _FONT __UI_Fonts(__UI_Controls(__UI_IsSelectingTextOnID).Font)
                    IF __UI_MouseLeft <= __UI_Controls(__UI_IsSelectingTextOnID).Left AND __UI_Controls(__UI_IsSelectingTextOnID).InputViewStart > 1 THEN
                        __UI_Controls(__UI_IsSelectingTextOnID).InputViewStart = __UI_Controls(__UI_IsSelectingTextOnID).InputViewStart - 1
                        __UI_Controls(__UI_IsSelectingTextOnID).Cursor = __UI_Controls(__UI_IsSelectingTextOnID).InputViewStart
                    ELSE
                        __UI_Controls(__UI_IsSelectingTextOnID).Cursor = ((__UI_MouseLeft - __UI_Controls(__UI_IsSelectingTextOnID).Left) / _FONTWIDTH) + (__UI_Controls(__UI_IsSelectingTextOnID).InputViewStart - 1)
                        IF __UI_Controls(__UI_IsSelectingTextOnID).Cursor < 0 THEN __UI_Controls(__UI_IsSelectingTextOnID).Cursor = 0
                        IF __UI_Controls(__UI_IsSelectingTextOnID).Cursor > LEN(__UI_Texts(__UI_IsSelectingTextOnID)) THEN __UI_Controls(__UI_IsSelectingTextOnID).Cursor = LEN(__UI_Texts(__UI_IsSelectingTextOnID))
                        IF __UI_Controls(__UI_IsSelectingTextOnID).Cursor <> __UI_Controls(__UI_IsSelectingTextOnID).SelectionStart THEN
                            __UI_Controls(__UI_IsSelectingTextOnID).TextIsSelected = __UI_True
                        END IF
                    END IF
                END IF

                IF NOT __UI_Controls(__UI_MouseDownOnID).Disabled AND __UI_Controls(__UI_MouseDownOnID).HoveringVScrollbarButton = 1 AND TIMER - __UI_MouseDownOnListBox > .3 THEN
                    'Mousedown on "up" button
                    __UI_Controls(__UI_MouseDownOnID).InputViewStart = __UI_Controls(__UI_MouseDownOnID).InputViewStart - 1
                ELSEIF NOT __UI_Controls(__UI_MouseDownOnID).Disabled AND __UI_Controls(__UI_MouseDownOnID).HoveringVScrollbarButton = 2 AND TIMER - __UI_MouseDownOnListBox > .3 THEN
                    'Mousedown on "down" button
                    IF __UI_Controls(__UI_MouseDownOnID).InputViewStart + __UI_Controls(__UI_MouseDownOnID).LastVisibleItem <= __UI_Controls(__UI_MouseDownOnID).Max THEN
                        __UI_Controls(__UI_MouseDownOnID).InputViewStart = __UI_Controls(__UI_MouseDownOnID).InputViewStart + 1
                    END IF
                ELSEIF NOT __UI_Controls(__UI_MouseDownOnID).Disabled AND __UI_Controls(__UI_MouseDownOnID).HoveringVScrollbarButton = 4 AND TIMER - __UI_MouseDownOnListBox < .3 THEN
                    'Mousedown on "track" area above the thumb
                    __UI_Controls(__UI_MouseDownOnID).InputViewStart = __UI_Controls(__UI_MouseDownOnID).InputViewStart - (__UI_Controls(__UI_MouseDownOnID).LastVisibleItem - 1)
                ELSEIF NOT __UI_Controls(__UI_MouseDownOnID).Disabled AND __UI_Controls(__UI_MouseDownOnID).HoveringVScrollbarButton = 5 AND TIMER - __UI_MouseDownOnListBox < .3 THEN
                    'Mousedown on "track" area below the thumb
                    __UI_Controls(__UI_MouseDownOnID).InputViewStart = __UI_Controls(__UI_MouseDownOnID).InputViewStart + (__UI_Controls(__UI_MouseDownOnID).LastVisibleItem - 1)
                    IF __UI_Controls(__UI_MouseDownOnID).InputViewStart > __UI_Controls(__UI_MouseDownOnID).Max - __UI_Controls(__UI_MouseDownOnID).LastVisibleItem - 1 THEN
                        __UI_Controls(__UI_MouseDownOnID).InputViewStart = __UI_Controls(__UI_MouseDownOnID).Max - __UI_Controls(__UI_MouseDownOnID).LastVisibleItem - 1
                    END IF
                END IF
            END IF
        END IF
    ELSE
        'Mouse button is released
        IF __UI_MouseIsDown THEN
            IF __UI_IsDragging THEN
                __UI_EndDrag __UI_DraggingID
                __UI_IsDragging = __UI_False
                'Snap the previously dragged control to the grid (unless Ctrl is down):
                IF __UI_Controls(__UI_DraggingID).ParentID > 0 AND __UI_Controls(__UI_DraggingID).Type <> __UI_Type_MenuItem THEN
                    __UI_PreviewTop = __UI_PreviewTop - __UI_Controls(__UI_Controls(__UI_DraggingID).ParentID).Top
                    __UI_PreviewLeft = __UI_PreviewLeft - __UI_Controls(__UI_Controls(__UI_DraggingID).ParentID).Left
                END IF
                __UI_Controls(__UI_DraggingID).Top = __UI_PreviewTop
                __UI_Controls(__UI_DraggingID).Left = __UI_PreviewLeft
                __UI_Controls(__UI_DraggingID).CanDrag = __UI_False
                __UI_DraggingID = 0
            END IF
            IF __UI_DraggingThumb THEN
                __UI_DraggingThumb = __UI_False
                __UI_DraggingThumbOnID = 0
            END IF

            'Click
            IF NOT __UI_Controls(__UI_HoveringID).CanDrag AND __UI_MouseDownOnID = __UI_HoveringID AND __UI_HoveringID > 0 THEN
                IF NOT __UI_Controls(__UI_HoveringID).Disabled THEN
                    SELECT CASE __UI_Controls(__UI_HoveringID).Type
                        CASE __UI_Type_RadioButton
                            __UI_SetRadioButtonValue __UI_HoveringID
                        CASE __UI_Type_CheckBox
                            __UI_Controls(__UI_HoveringID).Value = NOT __UI_Controls(__UI_HoveringID).Value
                        CASE __UI_Type_TextBox
                            _FONT __UI_Fonts(__UI_Controls(__UI_HoveringID).Font)
                            __UI_Controls(__UI_HoveringID).Cursor = ((__UI_MouseLeft - __UI_Controls(__UI_HoveringID).Left) / _FONTWIDTH) + (__UI_Controls(__UI_HoveringID).InputViewStart - 1)
                            IF __UI_Controls(__UI_HoveringID).Cursor > LEN(__UI_Texts(__UI_HoveringID)) THEN __UI_Controls(__UI_HoveringID).Cursor = LEN(__UI_Texts(__UI_HoveringID))
                        CASE __UI_Type_ListBox
                            IF __UI_Controls(__UI_HoveringID).HasVScrollbar AND __UI_MouseLeft >= __UI_Controls(__UI_HoveringID).Left + __UI_Controls(__UI_HoveringID).Width - 25 + ContainerOffsetLeft THEN
                                'Listbox has a vertical scrollbar and it's been clicked
                                IF __UI_MouseTop >= __UI_Controls(__UI_HoveringID).Top + ContainerOffsetTop AND NOT __UI_Controls(__UI_HoveringID).Disabled AND __UI_MouseTop <= __UI_Controls(__UI_HoveringID).Top + ContainerOffsetTop + __UI_ScrollbarButtonHeight THEN
                                    'Click on "up" button
                                    __UI_Controls(__UI_HoveringID).InputViewStart = __UI_Controls(__UI_HoveringID).InputViewStart - 1
                                ELSEIF __UI_MouseTop >= __UI_Controls(__UI_HoveringID).VScrollbarButton2Top + ContainerOffsetTop AND NOT __UI_Controls(__UI_HoveringID).Disabled THEN
                                    'Click on "down" button
                                    IF __UI_Controls(__UI_HoveringID).InputViewStart + __UI_Controls(__UI_HoveringID).LastVisibleItem <= __UI_Controls(__UI_HoveringID).Max THEN
                                        __UI_Controls(__UI_HoveringID).InputViewStart = __UI_Controls(__UI_HoveringID).InputViewStart + 1
                                    END IF
                                END IF
                            ELSE
                                ThisItem% = ((__UI_MouseTop - (ContainerOffsetTop + __UI_Controls(__UI_HoveringID).Top)) \ _FONTHEIGHT(__UI_Fonts(__UI_Controls(__UI_HoveringID).Font))) + __UI_Controls(__UI_HoveringID).InputViewStart
                                IF ThisItem% >= __UI_Controls(__UI_HoveringID).Min AND ThisItem% <= __UI_Controls(__UI_HoveringID).Max THEN
                                    __UI_Controls(__UI_HoveringID).Value = ThisItem%
                                ELSE
                                    __UI_Controls(__UI_HoveringID).Value = 0
                                END IF

                                IF __UI_HoveringID = __UI_ActiveDropdownList THEN
                                    __UI_Focus = __UI_ParentDropdownList
                                    __UI_Controls(__UI_ParentDropdownList).Value = __UI_Controls(__UI_ActiveDropdownList).Value
                                    __UI_DestroyControl __UI_Controls(__UI_ActiveDropdownList)
                                END IF
                            END IF
                        CASE __UI_Type_DropdownList
                            IF __UI_ActiveDropdownList = 0 THEN
                                __UI_ActivateDropdownlist __UI_Controls(__UI_HoveringID)
                            ELSE
                                __UI_DestroyControl __UI_Controls(__UI_ActiveDropdownList)
                            END IF
                        CASE __UI_Type_MenuBar
                            IF __UI_ActiveMenu > 0 AND NOT __UI_JustOpenedMenu THEN
                                __UI_Focus = __UI_PreviousFocus
                            END IF
                        CASE __UI_Type_MenuItem
                            __UI_Focus = __UI_PreviousFocus
                            __UI_DestroyControl __UI_Controls(__UI_ActiveMenu)
                            __UI_ForceRedraw = __UI_True
                    END SELECT
                    __UI_LastMouseClick = TIMER
                    __UI_JustOpenedMenu = __UI_False
                    __UI_MouseDownOnID = 0
                    __UI_Click __UI_HoveringID
                ELSE
                    IF __UI_ActiveMenu > 0 THEN
                        __UI_DestroyControl __UI_Controls(__UI_ActiveMenu)
                        __UI_Focus = __UI_PreviousFocus
                        __UI_ForceRedraw = __UI_True
                    END IF
                END IF
            ELSEIF __UI_MouseDownOnID = 0 THEN
                IF __UI_ActiveMenu > 0 THEN
                    __UI_DestroyControl __UI_Controls(__UI_ActiveMenu)
                    __UI_Focus = __UI_PreviousFocus
                    __UI_ForceRedraw = __UI_True
                END IF
            END IF
            __UI_IsSelectingText = __UI_False
            __UI_IsSelectingTextOnID = 0
            __UI_MouseIsDown = __UI_False
            IF __UI_HoveringID = __UI_MouseDownOnID AND __UI_MouseDownOnID > 0 THEN
                __UI_MouseDownOnID = 0
                __UI_MouseUp __UI_HoveringID
            END IF
            __UI_MouseDownOnID = 0
            __UI_PreviousMouseDownOnID = 0
        END IF
    END IF

    'Drag update
    IF __UI_IsDragging AND __UI_DraggingID > 0 THEN
        __UI_Controls(__UI_DraggingID).Top = __UI_Controls(__UI_DraggingID).Top + (__UI_MouseTop - __UI_DragY)
        __UI_DragY = __UI_MouseTop

        __UI_Controls(__UI_DraggingID).Left = __UI_Controls(__UI_DraggingID).Left + (__UI_MouseLeft - __UI_DragX)
        __UI_DragX = __UI_MouseLeft

        '(Ctrl overrides snapping):
        IF _KEYDOWN(100305) OR _KEYDOWN(100306) THEN
            __UI_PreviewTop = __UI_Controls(__UI_DraggingID).Top
            __UI_PreviewLeft = __UI_Controls(__UI_DraggingID).Left
        ELSE
            __UI_PreviewTop = __UI_Controls(__UI_DraggingID).Top
            DO UNTIL __UI_PreviewTop MOD 10 = 0
                __UI_PreviewTop = __UI_PreviewTop - 1
            LOOP
            IF ABS(__UI_PreviewTop - __UI_Controls(__UI_DraggingID).Top) > 5 THEN
                __UI_PreviewTop = __UI_Controls(__UI_DraggingID).Top
                DO UNTIL __UI_PreviewTop MOD 10 = 0
                    __UI_PreviewTop = __UI_PreviewTop + 1
                LOOP
            END IF
            __UI_PreviewLeft = __UI_Controls(__UI_DraggingID).Left
            DO UNTIL __UI_PreviewLeft MOD 10 = 0
                __UI_PreviewLeft = __UI_PreviewLeft - 1
            LOOP
            IF ABS(__UI_PreviewLeft - __UI_Controls(__UI_DraggingID).Left) > 5 THEN
                __UI_PreviewLeft = __UI_Controls(__UI_DraggingID).Left
                DO UNTIL __UI_PreviewLeft MOD 10 = 0
                    __UI_PreviewLeft = __UI_PreviewLeft + 1
                LOOP
            END IF
        END IF

        IF __UI_Controls(__UI_DraggingID).ParentID > 0 AND __UI_Controls(__UI_DraggingID).Type <> __UI_Type_MenuItem THEN
            __UI_PreviewTop = __UI_PreviewTop + __UI_Controls(__UI_Controls(__UI_DraggingID).ParentID).Top
            __UI_PreviewLeft = __UI_PreviewLeft + __UI_Controls(__UI_Controls(__UI_DraggingID).ParentID).Left
        END IF
    END IF
    IF __UI_DraggingThumb = __UI_True THEN
        IF __UI_MouseTop >= __UI_Controls(__UI_DraggingThumbOnID).Top + __UI_Controls(__UI_Controls(__UI_DraggingThumbOnID).ParentID).Top + __UI_ScrollbarButtonHeight AND __UI_MouseTop <= __UI_Controls(__UI_DraggingThumbOnID).Top + __UI_Controls(__UI_Controls(__UI_DraggingThumbOnID).ParentID).Top + __UI_Controls(__UI_DraggingThumbOnID).Height - __UI_ScrollbarButtonHeight THEN
            'Dragging in the track area
            __UI_Controls(__UI_DraggingThumbOnID).InputViewStart = __UI_Controls(__UI_DraggingThumbOnID).InputViewStart + ((__UI_MouseTop - __UI_ThumbDragTop) * __UI_Controls(__UI_DraggingThumbOnID).VScrollbarRatio)
            IF __UI_Controls(__UI_DraggingThumbOnID).InputViewStart + __UI_Controls(__UI_DraggingThumbOnID).LastVisibleItem - 1 > __UI_Controls(__UI_DraggingThumbOnID).Max THEN __UI_Controls(__UI_DraggingThumbOnID).InputViewStart = __UI_Controls(__UI_DraggingThumbOnID).Max - __UI_Controls(__UI_DraggingThumbOnID).LastVisibleItem + 1
            __UI_ThumbDragTop = __UI_MouseTop

        ELSEIF __UI_MouseTop < __UI_Controls(__UI_DraggingThumbOnID).Top + __UI_Controls(__UI_Controls(__UI_DraggingThumbOnID).ParentID).Top + __UI_ScrollbarButtonHeight THEN
            'Dragging above the track area
            __UI_Controls(__UI_DraggingThumbOnID).InputViewStart = 1
        ELSEIF __UI_MouseTop > __UI_Controls(__UI_DraggingThumbOnID).Top + __UI_Controls(__UI_Controls(__UI_DraggingThumbOnID).ParentID).Top + __UI_Controls(__UI_DraggingThumbOnID).Height - __UI_ScrollbarButtonHeight THEN
            'Dragging below the track area
            __UI_Controls(__UI_DraggingThumbOnID).InputViewStart = __UI_Controls(__UI_DraggingThumbOnID).Max - __UI_Controls(__UI_DraggingThumbOnID).LastVisibleItem + 1
        END IF
    END IF

    'Keyboard handler
    IF __UI_KeyHit = 15360 THEN 'F2
        __UI_Controls(__UI_HoveringID).CanDrag = NOT __UI_Controls(__UI_HoveringID).CanDrag
    END IF

    'Modifiers (Ctrl, Alt, Shift):
    IF __UI_KeyHit = 100303 OR __UI_KeyHit = 100304 THEN __UI_ShiftIsDown = __UI_True
    IF __UI_KeyHit = -100303 OR __UI_KeyHit = -100304 THEN __UI_ShiftIsDown = __UI_False
    IF __UI_KeyHit = 100305 OR __UI_KeyHit = 100306 THEN __UI_CtrlIsDown = __UI_True
    IF __UI_KeyHit = -100305 OR __UI_KeyHit = -100306 THEN __UI_CtrlIsDown = __UI_False
    IF __UI_KeyHit = 100307 OR __UI_KeyHit = 100308 THEN __UI_AltIsDown = __UI_True
    IF __UI_KeyHit = -100307 OR __UI_KeyHit = -100308 THEN __UI_AltIsDown = __UI_False

    'Alt:
    IF __UI_AltIsDown AND __UI_Controls(__UI_Focus).Type = __UI_Type_MenuBar THEN
        __UI_Focus = __UI_PreviousFocus
        __UI_AltIsDown = __UI_False
    ELSEIF __UI_AltIsDown AND __UI_ActiveMenu > 0 THEN
        __UI_Focus = __UI_PreviousFocus
        __UI_DestroyControl __UI_Controls(__UI_ActiveMenu)
        __UI_ForceRedraw = __UI_True
        __UI_KeyHit = 0
        __UI_AltIsDown = __UI_False
    ELSEIF __UI_AltIsDown THEN
        IF NOT __UI_ShowHotKeys THEN
            __UI_ShowHotKeys = __UI_True
            __UI_ForceRedraw = __UI_True 'Trigger a global redraw
        END IF

        SELECT CASE __UI_KeyHit
            CASE 48 TO 57, 65 TO 90, 97 TO 122 'Alphanumeric
                DIM j AS LONG

                __UI_AltCombo$ = __UI_AltCombo$ + CHR$(__UI_KeyHit)

                IF __UI_KeyHit >= 97 THEN __UI_KeyHit = __UI_KeyHit - 32 'Turn to capitals

                IF __UI_KeyHit > 0 THEN
                    'Search for a matching hot key in controls
                    FOR i = 1 TO UBOUND(__UI_Controls)
                        IF __UI_Controls(i).HotKey = __UI_KeyHit AND NOT __UI_Controls(i).Disabled AND __UI_Controls(i).Type <> __UI_Type_MenuItem THEN
                            SELECT CASE __UI_Controls(i).Type
                                CASE __UI_Type_Button
                                    IF __UI_Controls(i).CanHaveFocus THEN __UI_Focus = __UI_Controls(i).ID
                                    __UI_Click __UI_Controls(i).ID
                                CASE __UI_Type_RadioButton
                                    IF __UI_Controls(i).CanHaveFocus THEN __UI_Focus = __UI_Controls(i).ID
                                    __UI_SetRadioButtonValue __UI_Controls(i).ID
                                    __UI_Click __UI_Controls(i).ID
                                CASE __UI_Type_CheckBox
                                    IF __UI_Controls(i).CanHaveFocus THEN __UI_Focus = __UI_Controls(i).ID
                                    __UI_Controls(i).Value = NOT __UI_Controls(i).Value
                                    __UI_Click __UI_Controls(i).ID
                                CASE __UI_Type_Frame
                                    'Find the first children in this frame that can have focus
                                    FOR j = i + 1 TO UBOUND(__UI_Controls)
                                        IF __UI_Controls(j).ParentID = __UI_Controls(i).ID AND __UI_Controls(j).CanHaveFocus AND NOT __UI_Controls(j).Disabled THEN
                                            __UI_Focus = __UI_Controls(j).ID
                                            EXIT FOR
                                        END IF
                                    NEXT
                                CASE __UI_Type_Label
                                    'Find the next control in the same container that can have focus
                                    FOR j = i + 1 TO UBOUND(__UI_Controls)
                                        IF __UI_Controls(j).ParentID = __UI_Controls(i).ParentID AND __UI_Controls(j).CanHaveFocus AND NOT __UI_Controls(j).Disabled THEN
                                            __UI_Focus = __UI_Controls(j).ID
                                            EXIT FOR
                                        END IF
                                    NEXT
                                CASE __UI_Type_MenuBar
                                    IF __UI_ActiveMenu = 0 THEN
                                        __UI_PreviousFocus = __UI_Focus
                                        __UI_ActivateMenu __UI_Controls(i), __UI_True
                                        __UI_ForceRedraw = __UI_True
                                        __UI_Controls(__UI_ActiveMenu).Value = __UI_Focus
                                        __UI_KeyHit = 0
                                        __UI_AltIsDown = __UI_False
                                    END IF
                            END SELECT
                            EXIT FOR
                        END IF
                    NEXT
                END IF
        END SELECT
        __UI_KeyHit = 0
    ELSE
        IF __UI_ShowHotKeys THEN
            __UI_ShowHotKeys = __UI_False
            __UI_ForceRedraw = __UI_True 'Trigger a global redraw

            IF LEN(__UI_AltCombo$) THEN
                'Numeric keypresses with alt pressed are converted into the proper ASCII character
                'and inserted into the active textbox, if any.
                IF VAL(__UI_AltCombo$) >= 32 AND VAL(__UI_AltCombo$) <= 254 THEN
                    __UI_KeyHit = VAL(__UI_AltCombo$)
                END IF
                __UI_AltCombo$ = ""
            ELSE
                'Alt was released with no key having been pressed in the meantime,
                'so the menubar will be activated, if it exists
                IF __UI_HasMenuBar THEN
                    __UI_PreviousFocus = __UI_Focus
                    __UI_Focus = __UI_FirstMenuBarControl
                END IF
            END IF
        END IF
    END IF

    IF __UI_Focus AND __UI_KeyHit <> 0 THEN
        __UI_KeyPress __UI_Focus

        'Enter activates the selected/default button, if any
        IF __UI_IsDragging = __UI_False AND __UI_KeyHit = -13 AND NOT __UI_Controls(__UI_Focus).Disabled THEN
            IF __UI_Controls(__UI_Focus).Type = __UI_Type_Button OR __UI_Controls(__UI_Focus).Type = __UI_Type_MenuItem THEN
                i = __UI_Focus
                IF __UI_Controls(__UI_Focus).Type = __UI_Type_MenuItem THEN
                    __UI_Focus = __UI_PreviousFocus
                    __UI_DestroyControl __UI_Controls(__UI_ActiveMenu)
                    __UI_ForceRedraw = __UI_True
                    __UI_KeyHit = 0
                END IF
                __UI_Click i
            ELSEIF __UI_Controls(__UI_Focus).Type = __UI_Type_ListBox AND __UI_Focus = __UI_ActiveDropdownList THEN
                __UI_Focus = __UI_ParentDropdownList
                __UI_Controls(__UI_ParentDropdownList).Value = __UI_Controls(__UI_ActiveDropdownList).Value
                __UI_DestroyControl __UI_Controls(__UI_ActiveDropdownList)
            ELSEIF __UI_Controls(__UI_Focus).Type = __UI_Type_MenuBar THEN
                __UI_ActivateMenu __UI_Controls(__UI_Focus), __UI_True
            ELSEIF __UI_Focus <> __UI_DefaultButtonID AND __UI_DefaultButtonID > 0 THEN
                __UI_Click __UI_DefaultButtonID
            END IF
        ELSE
            SELECT CASE __UI_Controls(__UI_Focus).Type
                CASE __UI_Type_MenuBar
                    SELECT CASE __UI_KeyHit
                        CASE 48 TO 57, 65 TO 90, 97 TO 122 'Alphanumeric
                            IF __UI_KeyHit >= 97 THEN __UI_KeyHit = __UI_KeyHit - 32 'Turn to capitals
                            'Search for a matching hot key in menu bar items
                            FOR i = 1 TO UBOUND(__UI_Controls)
                                IF __UI_Controls(i).HotKey = __UI_KeyHit AND NOT __UI_Controls(i).Disabled AND __UI_Controls(i).Type = __UI_Type_MenuBar THEN
                                    IF __UI_ActiveMenu = 0 THEN
                                        __UI_ActivateMenu __UI_Controls(i), __UI_True
                                        __UI_Controls(__UI_ActiveMenu).Value = __UI_Focus
                                        __UI_ForceRedraw = __UI_True
                                        __UI_KeyHit = 0
                                    END IF
                                    EXIT FOR
                                END IF
                            NEXT
                        CASE 27 'Esc
                            __UI_Focus = __UI_PreviousFocus
                            __UI_KeyHit = 0
                        CASE 19200 'Left
                            __UI_Focus = __UI_PreviousMenuBarControl(__UI_Focus)
                        CASE 19712 'Right
                            __UI_Focus = __UI_NextMenuBarControl(__UI_Focus)
                        CASE 18432, 20480 'Up, down
                            __UI_ActivateMenu __UI_Controls(__UI_Focus), __UI_True
                            __UI_KeyHit = 0
                    END SELECT
                CASE __UI_Type_MenuPanel, __UI_Type_MenuItem
                    SELECT CASE __UI_KeyHit
                        CASE 48 TO 57, 65 TO 90, 97 TO 122 'Alphanumeric
                            IF __UI_KeyHit >= 97 THEN __UI_KeyHit = __UI_KeyHit - 32 'Turn to capitals
                            'Search for a matching hot key in menu bar items
                            FOR i = 1 TO UBOUND(__UI_Controls)
                                IF __UI_Controls(i).HotKey = __UI_KeyHit AND NOT __UI_Controls(i).Disabled AND __UI_Controls(i).Type = __UI_Type_MenuItem AND __UI_Controls(i).ParentID = __UI_ParentMenu THEN
                                    __UI_Focus = __UI_PreviousFocus
                                    __UI_DestroyControl __UI_Controls(__UI_ActiveMenu)
                                    __UI_ForceRedraw = __UI_True
                                    __UI_KeyHit = 0
                                    __UI_Click i
                                    EXIT FOR
                                END IF
                            NEXT
                        CASE 27 'Esc
                            __UI_Focus = __UI_ParentMenu
                            __UI_DestroyControl __UI_Controls(__UI_ActiveMenu)
                            __UI_KeyHit = 0
                        CASE 19200 'Left
                            __UI_ActivateMenu __UI_Controls(__UI_PreviousMenuBarControl(__UI_ParentMenu)), __UI_True
                            __UI_ForceRedraw = __UI_True
                            __UI_KeyHit = 0
                        CASE 19712 'Right
                            __UI_ActivateMenu __UI_Controls(__UI_NextMenuBarControl(__UI_ParentMenu)), __UI_True
                            __UI_ForceRedraw = __UI_True
                            __UI_KeyHit = 0
                        CASE 18432 'Up
                            __UI_Focus = __UI_PreviousMenuItem(__UI_Focus)
                            __UI_Controls(__UI_ActiveMenu).Value = __UI_Controls(__UI_Focus).ID
                        CASE 20480 'Down
                            __UI_Focus = __UI_NextMenuItem(__UI_Focus)
                            __UI_Controls(__UI_ActiveMenu).Value = __UI_Controls(__UI_Focus).ID
                    END SELECT
                CASE __UI_Type_Button, __UI_Type_RadioButton, __UI_Type_CheckBox
                    SELECT CASE __UI_KeyHit
                        CASE 32
                            'Emulate mouse down/click
                            IF __UI_IsDragging = __UI_False AND NOT __UI_Controls(__UI_Focus).Disabled THEN
                                'Space bar down on a button
                                IF __UI_KeyIsDown = __UI_False AND __UI_KeyDownOnID = 0 THEN
                                    __UI_KeyDownOnID = __UI_Focus
                                    __UI_KeyIsDown = __UI_True
                                END IF
                            END IF
                        CASE -32
                            IF __UI_IsDragging = __UI_False AND NOT __UI_Controls(__UI_Focus).Disabled THEN
                                'Space bar released and a button has focus
                                IF __UI_KeyIsDown AND __UI_Focus = __UI_KeyDownOnID THEN
                                    IF __UI_Controls(__UI_KeyDownOnID).Type = __UI_Type_RadioButton THEN
                                        __UI_SetRadioButtonValue __UI_KeyDownOnID
                                    ELSEIF __UI_Controls(__UI_KeyDownOnID).Type = __UI_Type_CheckBox THEN
                                        __UI_Controls(__UI_KeyDownOnID).Value = NOT __UI_Controls(__UI_KeyDownOnID).Value
                                    END IF
                                    __UI_KeyDownOnID = 0
                                    __UI_KeyIsDown = __UI_False
                                    __UI_Click __UI_Focus
                                END IF
                            END IF
                        CASE 18432, 20480 'Up, down
                            IF (__UI_Controls(__UI_Focus).Type = __UI_Type_RadioButton OR __UI_Controls(__UI_Focus).Type = __UI_Type_CheckBox) THEN
                                __UI_FocusSearch = __UI_Focus
                                DO
                                    IF _KEYDOWN(100304) OR _KEYDOWN(100303) THEN
                                        __UI_FocusSearch = (__UI_FocusSearch + UBOUND(__UI_Controls) - 2) MOD UBOUND(__UI_Controls) + 1
                                    ELSE
                                        __UI_FocusSearch = __UI_FocusSearch MOD UBOUND(__UI_Controls) + 1
                                    END IF

                                    IF __UI_FocusSearch = __UI_Focus THEN
                                        'Full circle. No similar control can have focus
                                        EXIT DO
                                    END IF

                                    IF __UI_Controls(__UI_FocusSearch).CanHaveFocus AND NOT __UI_Controls(__UI_FocusSearch).Disabled AND __UI_Controls(__UI_Focus).Type = __UI_Controls(__UI_FocusSearch).Type THEN
                                        __UI_FocusOut __UI_Focus
                                        __UI_Focus = __UI_FocusSearch
                                        __UI_FocusIn __UI_Focus
                                        IF __UI_Controls(__UI_FocusSearch).Type = __UI_Type_RadioButton THEN __UI_SetRadioButtonValue __UI_Focus
                                        EXIT DO
                                    END IF
                                LOOP
                            END IF
                    END SELECT
                CASE __UI_Type_ListBox, __UI_Type_DropdownList
                    DIM ThisItemTop%, CaptionIndent AS INTEGER
                    IF NOT __UI_Controls(__UI_Focus).Disabled THEN
                        _FONT __UI_Fonts(__UI_Controls(__UI_Focus).Font)
                        SELECT EVERYCASE __UI_KeyHit
                            CASE 32 TO 254 'Printable ASCII characters
                                DIM CurrentItem%
                                CurrentItem% = __UI_Controls(__UI_Focus).Value
                                __UI_ListBoxSearchItem __UI_Controls(__UI_Focus)
                                IF CurrentItem% <> __UI_Controls(__UI_Focus).Value THEN
                                    'Adjust view:
                                    IF __UI_Controls(__UI_Focus).Value < __UI_Controls(__UI_Focus).InputViewStart THEN
                                        __UI_Controls(__UI_Focus).InputViewStart = __UI_Controls(__UI_Focus).Value
                                    ELSEIF __UI_Controls(__UI_Focus).Value > __UI_Controls(__UI_Focus).InputViewStart + __UI_Controls(__UI_Focus).LastVisibleItem - 1 THEN
                                        __UI_Controls(__UI_Focus).InputViewStart = __UI_Controls(__UI_Focus).Value - __UI_Controls(__UI_Focus).LastVisibleItem + 1
                                    END IF
                                END IF
                            CASE 18432 'Up
                                IF __UI_Controls(__UI_Focus).Value > 1 THEN
                                    __UI_Controls(__UI_Focus).Value = __UI_Controls(__UI_Focus).Value - 1
                                END IF
                            CASE 20480 'Down
                                IF __UI_AltIsDown THEN
                                    IF __UI_Controls(__UI_Focus).Type = __UI_Type_DropdownList THEN
                                        __UI_ActivateDropdownlist __UI_Controls(__UI_Focus)
                                    END IF
                                ELSE
                                    IF __UI_Controls(__UI_Focus).Value < __UI_Controls(__UI_Focus).Max THEN
                                        __UI_Controls(__UI_Focus).Value = __UI_Controls(__UI_Focus).Value + 1
                                    END IF
                                END IF
                            CASE 18688 'Page up
                                __UI_Controls(__UI_Focus).Value = __UI_Controls(__UI_Focus).Value - __UI_Controls(__UI_Focus).LastVisibleItem
                                IF __UI_Controls(__UI_Focus).Value < 1 THEN __UI_Controls(__UI_Focus).Value = 1
                            CASE 20736 'Page down
                                IF __UI_Controls(__UI_Focus).Value < __UI_Controls(__UI_Focus).Max - __UI_Controls(__UI_Focus).LastVisibleItem THEN
                                    __UI_Controls(__UI_Focus).Value = __UI_Controls(__UI_Focus).Value + __UI_Controls(__UI_Focus).LastVisibleItem - 1
                                ELSE
                                    __UI_Controls(__UI_Focus).Value = __UI_Controls(__UI_Focus).Max
                                END IF
                            CASE 18176 'Home
                                __UI_Controls(__UI_Focus).Value = 1
                            CASE 20224 'End
                                __UI_Controls(__UI_Focus).Value = __UI_Controls(__UI_Focus).Max
                            CASE 18432, 20480, 18688, 20736, 18176, 20224
                                'Adjust view:
                                IF __UI_Controls(__UI_Focus).Value < __UI_Controls(__UI_Focus).InputViewStart THEN
                                    __UI_Controls(__UI_Focus).InputViewStart = __UI_Controls(__UI_Focus).Value
                                ELSEIF __UI_Controls(__UI_Focus).Value > __UI_Controls(__UI_Focus).InputViewStart + __UI_Controls(__UI_Focus).LastVisibleItem - 1 THEN
                                    __UI_Controls(__UI_Focus).InputViewStart = __UI_Controls(__UI_Focus).Value - __UI_Controls(__UI_Focus).LastVisibleItem + 1
                                END IF
                        END SELECT
                    END IF
                CASE __UI_Type_TextBox
                    DIM Clip$, FindLF&
                    DIM s1 AS LONG, s2 AS LONG
                    IF NOT __UI_Controls(__UI_Focus).Disabled THEN
                        SELECT CASE __UI_KeyHit
                            CASE 32 TO 254 'Printable ASCII characters
                                IF __UI_KeyHit = ASC("v") OR __UI_KeyHit = ASC("V") THEN 'Paste from clipboard (Ctrl+V)
                                    IF __UI_CtrlIsDown THEN
                                        Clip$ = _CLIPBOARD$
                                        FindLF& = INSTR(Clip$, CHR$(13))
                                        IF FindLF& > 0 THEN Clip$ = LEFT$(Clip$, FindLF& - 1)
                                        FindLF& = INSTR(Clip$, CHR$(10))
                                        IF FindLF& > 0 THEN Clip$ = LEFT$(Clip$, FindLF& - 1)
                                        IF LEN(RTRIM$(LTRIM$(Clip$))) > 0 THEN
                                            IF NOT __UI_Controls(__UI_Focus).TextIsSelected THEN
                                                IF __UI_Controls(__UI_Focus).Cursor = LEN(__UI_Texts(__UI_Focus)) THEN
                                                    __UI_Texts(__UI_Focus) = __UI_Texts(__UI_Focus) + Clip$
                                                    __UI_Controls(__UI_Focus).Cursor = LEN(__UI_Texts(__UI_Focus))
                                                ELSE
                                                    __UI_Texts(__UI_Focus) = LEFT$(__UI_Texts(__UI_Focus), __UI_Controls(__UI_Focus).Cursor) + Clip$ + MID$(__UI_Texts(__UI_Focus), __UI_Controls(__UI_Focus).Cursor + 1)
                                                    __UI_Controls(__UI_Focus).Cursor = __UI_Controls(__UI_Focus).Cursor + LEN(Clip$)
                                                END IF
                                            ELSE
                                                s1 = __UI_Controls(__UI_Focus).SelectionStart
                                                s2 = __UI_Controls(__UI_Focus).Cursor
                                                IF s1 > s2 THEN SWAP s1, s2
                                                __UI_Texts(__UI_Focus) = LEFT$(__UI_Texts(__UI_Focus), s1) + Clip$ + MID$(__UI_Texts(__UI_Focus), s2 + 1)
                                                __UI_Controls(__UI_Focus).Cursor = s1 + LEN(Clip$)
                                                __UI_Controls(__UI_Focus).TextIsSelected = __UI_False
                                                __UI_SelectedText = ""
                                                __UI_SelectionLength = 0
                                            END IF
                                        END IF
                                        __UI_KeyHit = 0
                                    END IF
                                ELSEIF __UI_KeyHit = ASC("c") OR __UI_KeyHit = ASC("C") THEN 'Copy selection to clipboard (Ctrl+C)
                                    IF __UI_CtrlIsDown THEN
                                        _CLIPBOARD$ = __UI_SelectedText
                                        __UI_KeyHit = 0
                                    END IF
                                ELSEIF __UI_KeyHit = ASC("x") OR __UI_KeyHit = ASC("X") THEN 'Cut selection to clipboard (Ctrl+X)
                                    IF __UI_CtrlIsDown THEN
                                        _CLIPBOARD$ = __UI_SelectedText
                                        __UI_DeleteSelection
                                        __UI_KeyHit = 0
                                    END IF
                                ELSEIF __UI_KeyHit = ASC("a") OR __UI_KeyHit = ASC("A") THEN 'Select all text (Ctrl+A)
                                    IF __UI_CtrlIsDown THEN
                                        __UI_Controls(__UI_Focus).Cursor = LEN(__UI_Texts(__UI_Focus))
                                        __UI_Controls(__UI_Focus).SelectionStart = 0
                                        __UI_Controls(__UI_Focus).TextIsSelected = __UI_True
                                        __UI_KeyHit = 0
                                    END IF
                                END IF

                                IF __UI_KeyHit THEN
                                    IF NOT __UI_Controls(__UI_Focus).TextIsSelected THEN
                                        IF __UI_Controls(__UI_Focus).Cursor = LEN(__UI_Texts(__UI_Focus)) THEN
                                            __UI_Texts(__UI_Focus) = __UI_Texts(__UI_Focus) + CHR$(__UI_KeyHit)
                                            __UI_Controls(__UI_Focus).Cursor = __UI_Controls(__UI_Focus).Cursor + 1
                                        ELSE
                                            __UI_Texts(__UI_Focus) = LEFT$(__UI_Texts(__UI_Focus), __UI_Controls(__UI_Focus).Cursor) + CHR$(__UI_KeyHit) + MID$(__UI_Texts(__UI_Focus), __UI_Controls(__UI_Focus).Cursor + 1)
                                            __UI_Controls(__UI_Focus).Cursor = __UI_Controls(__UI_Focus).Cursor + 1
                                        END IF
                                    ELSE
                                        s1 = __UI_Controls(__UI_Focus).SelectionStart
                                        s2 = __UI_Controls(__UI_Focus).Cursor
                                        IF s1 > s2 THEN SWAP s1, s2
                                        __UI_Texts(__UI_Focus) = LEFT$(__UI_Texts(__UI_Focus), s1) + CHR$(__UI_KeyHit) + MID$(__UI_Texts(__UI_Focus), s2 + 1)
                                        __UI_Controls(__UI_Focus).TextIsSelected = __UI_False
                                        __UI_SelectedText = ""
                                        __UI_SelectionLength = 0
                                        __UI_Controls(__UI_Focus).Cursor = s1 + 1
                                    END IF
                                END IF
                            CASE 8 'Backspace
                                IF LEN(__UI_Texts(__UI_Focus)) > 0 THEN
                                    IF NOT __UI_Controls(__UI_Focus).TextIsSelected THEN
                                        IF __UI_Controls(__UI_Focus).Cursor = LEN(__UI_Texts(__UI_Focus)) THEN
                                            __UI_Texts(__UI_Focus) = LEFT$(__UI_Texts(__UI_Focus), LEN(__UI_Texts(__UI_Focus)) - 1)
                                            __UI_Controls(__UI_Focus).Cursor = __UI_Controls(__UI_Focus).Cursor - 1
                                        ELSEIF __UI_Controls(__UI_Focus).Cursor > 1 THEN
                                            __UI_Texts(__UI_Focus) = LEFT$(__UI_Texts(__UI_Focus), __UI_Controls(__UI_Focus).Cursor - 1) + MID$(__UI_Texts(__UI_Focus), __UI_Controls(__UI_Focus).Cursor + 1)
                                            __UI_Controls(__UI_Focus).Cursor = __UI_Controls(__UI_Focus).Cursor - 1
                                        ELSEIF __UI_Controls(__UI_Focus).Cursor = 1 THEN
                                            __UI_Texts(__UI_Focus) = RIGHT$(__UI_Texts(__UI_Focus), LEN(__UI_Texts(__UI_Focus)) - 1)
                                            __UI_Controls(__UI_Focus).Cursor = __UI_Controls(__UI_Focus).Cursor - 1
                                        END IF

                                        IF __UI_Controls(__UI_Focus).Cursor + 1 = __UI_Controls(__UI_Focus).InputViewStart THEN
                                            __UI_Controls(__UI_Focus).InputViewStart = __UI_Controls(__UI_Focus).InputViewStart - __UI_Controls(__UI_Focus).FieldArea / 2
                                        END IF
                                    ELSE
                                        __UI_DeleteSelection
                                    END IF
                                END IF
                            CASE 21248 'Delete
                                IF NOT __UI_Controls(__UI_Focus).TextIsSelected THEN
                                    IF LEN(__UI_Texts(__UI_Focus)) > 0 THEN
                                        IF __UI_Controls(__UI_Focus).Cursor = 0 THEN
                                            __UI_Texts(__UI_Focus) = RIGHT$(__UI_Texts(__UI_Focus), LEN(__UI_Texts(__UI_Focus)) - 1)
                                        ELSEIF __UI_Controls(__UI_Focus).Cursor > 0 AND __UI_Controls(__UI_Focus).Cursor <= LEN(__UI_Texts(__UI_Focus)) - 1 THEN
                                            __UI_Texts(__UI_Focus) = LEFT$(__UI_Texts(__UI_Focus), __UI_Controls(__UI_Focus).Cursor) + MID$(__UI_Texts(__UI_Focus), __UI_Controls(__UI_Focus).Cursor + 2)
                                        END IF
                                    END IF
                                ELSE
                                    __UI_DeleteSelection
                                END IF
                            CASE 19200 'Left arrow key
                                __UI_CheckSelection __UI_Focus
                                IF __UI_Controls(__UI_Focus).Cursor > 0 THEN __UI_Controls(__UI_Focus).Cursor = __UI_Controls(__UI_Focus).Cursor - 1
                            CASE 19712 'Right arrow key
                                __UI_CheckSelection __UI_Focus
                                IF __UI_Controls(__UI_Focus).Cursor < LEN(__UI_Texts(__UI_Focus)) THEN __UI_Controls(__UI_Focus).Cursor = __UI_Controls(__UI_Focus).Cursor + 1
                            CASE 18176 'Home
                                __UI_CheckSelection __UI_Focus
                                __UI_Controls(__UI_Focus).Cursor = 0
                            CASE 20224 'End
                                __UI_CheckSelection __UI_Focus
                                __UI_Controls(__UI_Focus).Cursor = LEN(__UI_Texts(__UI_Focus))
                        END SELECT
                    END IF
            END SELECT
        END IF
    ELSEIF __UI_KeyHit <> 0 THEN 'No control has focus
        'Enter activates the default button, if any
        IF __UI_IsDragging = __UI_False AND __UI_KeyHit = -13 AND __UI_DefaultButtonID > 0 THEN
            'Enter released and there is a default button
            __UI_Click __UI_DefaultButtonID
        END IF
    END IF

    __UI_LastHoveringID = __UI_HoveringID
END SUB

'---------------------------------------------------------------------------------
FUNCTION __UI_GetID (ControlName$)
    DIM i AS LONG, ControlSearch$

    ControlSearch$ = UCASE$(RTRIM$(ControlName$))

    FOR i = 1 TO UBOUND(__UI_Controls)
        IF __UI_Controls(i).ID > 0 AND UCASE$(RTRIM$(__UI_Controls(i).Name)) = ControlSearch$ THEN
            __UI_GetID = i
            EXIT FUNCTION
        END IF
    NEXT
END FUNCTION

'---------------------------------------------------------------------------------
FUNCTION __UI_NewControl (ControlType AS INTEGER, ControlName AS STRING, NewWidth AS INTEGER, NewHeight AS INTEGER, NewLeft AS INTEGER, NewTop AS INTEGER, ParentID AS LONG)
    DIM NextSlot AS LONG, i AS LONG

    IF ControlType = 0 OR ControlName = "" THEN EXIT SUB

    IF ControlType = __UI_Type_Form THEN
        'Make sure only one Form exists, as it must be unique
        FOR i = 1 TO UBOUND(__UI_Controls)
            IF __UI_Controls(i).Type = ControlType THEN ERROR 5: EXIT FUNCTION
        NEXT
    END IF

    'Make sure this ControlName is unique:
    FOR i = 1 TO UBOUND(__UI_Controls)
        IF __UI_Controls(i).ID > 0 AND UCASE$(RTRIM$(__UI_Controls(i).Name)) = UCASE$(RTRIM$(ControlName)) THEN ERROR 5: EXIT FUNCTION
    NEXT

    'Find an empty slot for the new control
    FOR NextSlot = 1 TO UBOUND(__UI_Controls)
        IF __UI_Controls(NextSlot).ID = 0 THEN EXIT FOR
    NEXT

    IF NextSlot > UBOUND(__UI_Controls) THEN
        'No empty slots. We must increase __UI_Controls() and its helper arrays
        REDIM _PRESERVE __UI_Controls(0 TO NextSlot + 99) AS __UI_ControlTYPE
        REDIM _PRESERVE __UI_Captions(1 TO NextSlot + 99) AS STRING
        REDIM _PRESERVE __UI_TempCaptions(1 TO NextSlot + 99) AS STRING
        REDIM _PRESERVE __UI_Texts(1 TO NextSlot + 99) AS STRING
        REDIM _PRESERVE __UI_TempTexts(1 TO NextSlot + 99) AS STRING
    END IF

    IF ControlType = __UI_Type_Form THEN __UI_FormID = NextSlot

    __UI_DestroyControl __UI_Controls(NextSlot) 'This control is inactive but may still retain properties
    __UI_Controls(NextSlot).ID = NextSlot
    __UI_Controls(NextSlot).ParentID = ParentID
    IF (ControlType <> __UI_Type_Form AND ParentID = 0) THEN
        'Inherit main form's font
        __UI_Controls(NextSlot).Font = __UI_Controls(__UI_FormID).Font
    ELSEIF (ControlType <> __UI_Type_Frame AND ParentID > 0) THEN
        'Inherit container's font
        __UI_Controls(NextSlot).Font = __UI_Controls(ParentID).Font
    END IF
    __UI_Controls(NextSlot).Type = ControlType
    __UI_Controls(NextSlot).Name = ControlName
    __UI_Controls(NextSlot).Width = NewWidth
    __UI_Controls(NextSlot).Height = NewHeight
    __UI_Controls(NextSlot).Left = NewLeft
    __UI_Controls(NextSlot).Top = NewTop
    __UI_Controls(NextSlot).ForeColor = __UI_DefaultColor(ControlType, 1)
    __UI_Controls(NextSlot).BackColor = __UI_DefaultColor(ControlType, 2)
    __UI_Controls(NextSlot).SelectedForeColor = __UI_DefaultColor(ControlType, 3)
    __UI_Controls(NextSlot).SelectedBackColor = __UI_DefaultColor(ControlType, 4)
    __UI_Controls(NextSlot).BorderColor = __UI_DefaultColor(ControlType, 5)

    IF ControlType = __UI_Type_MenuBar THEN
        __UI_Controls(NextSlot).Height = _FONTHEIGHT(__UI_Fonts(__UI_Controls(__UI_FormID).Font)) * 1.5
        IF __UI_HasMenuBar = __UI_False THEN
            __UI_HasMenuBar = __UI_True
            'Add menubar div to main form's canvas
            IF __UI_Controls(__UI_FormID).Canvas <> 0 THEN _FREEIMAGE __UI_Controls(__UI_FormID).Canvas
            __UI_Controls(__UI_FormID).Canvas = _NEWIMAGE(__UI_Controls(__UI_FormID).Width, __UI_Controls(__UI_FormID).Height, 32)
            _DEST __UI_Controls(__UI_FormID).Canvas
            COLOR __UI_Controls(__UI_FormID).ForeColor, __UI_Controls(__UI_FormID).BackColor
            CLS
            LINE (0, _FONTHEIGHT(__UI_Fonts(__UI_Controls(__UI_FormID).Font)) * 1.5 + 1)-STEP(__UI_Controls(__UI_FormID).Width - 1, 0), __UI_Darken(__UI_Controls(__UI_FormID).BackColor, 80)
            LINE (0, _FONTHEIGHT(__UI_Fonts(__UI_Controls(__UI_FormID).Font)) * 1.5 + 2)-STEP(__UI_Controls(__UI_FormID).Width - 1, 0), __UI_Darken(__UI_Controls(__UI_FormID).BackColor, 120)
            _DEST 0
            __UI_MakeHardwareImageFromCanvas __UI_Controls(__UI_FormID)
        END IF
    ELSEIF ControlType = __UI_Type_TextBox OR ControlType = __UI_Type_Button OR ControlType = __UI_Type_CheckBox OR ControlType = __UI_Type_RadioButton OR ControlType = __UI_Type_ListBox OR ControlType = __UI_Type_DropdownList THEN
        __UI_Controls(NextSlot).CanHaveFocus = __UI_True
    ELSEIF ControlType = __UI_Type_Frame THEN
        __UI_Controls(NextSlot).Canvas = _NEWIMAGE(NewWidth, NewHeight, 32)
    ELSEIF ControlType = __UI_Type_Form THEN
        'Create main window hardware bg:
        __UI_Controls(__UI_FormID).Canvas = _NEWIMAGE(NewWidth, NewHeight, 32)
        _DEST __UI_Controls(__UI_FormID).Canvas
        COLOR __UI_Controls(__UI_FormID).ForeColor, __UI_Controls(__UI_FormID).BackColor
        CLS
        _DEST 0
        __UI_MakeHardwareImageFromCanvas __UI_Controls(__UI_FormID)
    END IF

    IF ControlType = __UI_Type_PictureBox OR ControlType = __UI_Type_TextBox OR ControlType = __UI_Type_Frame OR ControlType = __UI_Type_ListBox OR ControlType = __UI_Type_DropdownList THEN
        __UI_Controls(NextSlot).HasBorder = __UI_True
    END IF

    __UI_NewControl = NextSlot
END FUNCTION

'---------------------------------------------------------------------------------
SUB __UI_DestroyControl (This AS __UI_ControlTYPE)
    IF This.ID THEN
        __UI_Captions(This.ID) = ""
        __UI_TempCaptions(This.ID) = ""
        __UI_Texts(This.ID) = ""
        __UI_TempTexts(This.ID) = ""

        IF This.Type = __UI_Type_MenuBar THEN
            __UI_HasMenuBar = (__UI_FirstMenuBarControl > 0)
        ELSEIF This.Type = __UI_Type_ListBox THEN
            IF __UI_ActiveDropdownList = This.ID THEN
                __UI_ActiveDropdownList = 0
                __UI_ParentDropdownList = 0
            END IF
        ELSEIF This.Type = __UI_Type_MenuPanel THEN
            IF __UI_ActiveMenu = This.ID THEN
                __UI_ActiveMenu = 0
                __UI_ParentMenu = 0
            END IF
        END IF
    END IF
    This.ID = 0
    This.ParentID = 0
    This.PreviousParentID = 0
    This.Type = 0
    This.Name = ""
    This.Top = 0
    This.Left = 0
    This.Width = 0
    This.Height = 0
    IF This.Canvas <> 0 THEN _FREEIMAGE This.Canvas: This.Canvas = 0
    IF This.HelperCanvas <> 0 THEN _FREEIMAGE This.HelperCanvas: This.HelperCanvas = 0
    This.Font = 0
    This.BackColor = 0
    This.ForeColor = 0
    This.SelectedForeColor = 0
    This.SelectedBackColor = 0
    This.BackStyle = 0
    This.HasBorder = __UI_False
    This.Align = 0
    This.BorderColor = 0
    This.Value = 0
    This.PreviousValue = 0
    This.Min = 0
    This.Max = 0
    This.ShowPercentage = __UI_False
    This.InputViewStart = 0
    This.PreviousInputViewStart = 0
    This.LastVisibleItem = 0
    This.HasVScrollbar = __UI_False
    This.VScrollbarButton2Top = 0
    This.HoveringVScrollbarButton = 0
    This.ThumbHeight = 0
    This.ThumbTop = 0
    This.VScrollbarRatio = 0
    This.Cursor = 0
    This.PrevCursor = 0
    This.FieldArea = 0
    This.TextIsSelected = __UI_False
    This.ControlIsSelected = __UI_False
    This.SelectionLength = 0
    This.SelectionStart = 0
    This.Resizable = 0
    This.CanDrag = __UI_False
    This.CanHaveFocus = __UI_False
    This.Disabled = __UI_False
    This.Hidden = __UI_False
    This.CenteredWindow = __UI_False
    This.ControlState = 0
    This.ChildrenRedrawn = __UI_False
    This.FocusState = 0
END SUB

'---------------------------------------------------------------------------------
SUB __UI_SetCaption (Control$, TempCaption$)
    DIM i AS LONG, FindSep%, ThisID AS LONG, NewCaption$, UsedList$, TempKey AS _UNSIGNED _BYTE
    DIM PrevFont AS LONG, TempCanvas AS LONG, PrevDest AS LONG, ItemOffset AS INTEGER

    ThisID = __UI_GetID(Control$)

    NewCaption$ = TempCaption$

    FindSep% = INSTR(NewCaption$, "&")
    IF FindSep% > 0 AND FindSep% < LEN(NewCaption$) THEN
        FOR i = 1 TO UBOUND(__UI_Controls)
            'Check if this hot key isn't already assigned to another control
            IF __UI_Controls(i).HotKey > 0 AND __UI_Controls(i).Type <> __UI_Type_MenuItem THEN
                UsedList$ = UsedList$ + CHR$(__UI_Controls(i).HotKey)
            END IF
        NEXT

        NewCaption$ = LEFT$(NewCaption$, FindSep% - 1) + MID$(NewCaption$, FindSep% + 1)
        TempKey = ASC(UCASE$(NewCaption$), FindSep%)
        IF INSTR(UsedList$, CHR$(TempKey)) = 0 THEN
            __UI_Controls(ThisID).HotKey = TempKey

            PrevFont = _FONT

            IF _PIXELSIZE = 0 THEN
                'Temporarily create a 32bit screen for proper font handling, in case
                'we're still at form setup (SCREEN 0)
                TempCanvas = _NEWIMAGE(10, 10, 32)
                PrevDest = _DEST
                _DEST TempCanvas
            END IF

            _FONT __UI_Fonts(__UI_Controls(ThisID).Font)
            __UI_Controls(ThisID).HotKeyOffset = _PRINTWIDTH(LEFT$(NewCaption$, FindSep% - 1))

            IF TempCanvas <> 0 THEN
                _DEST PrevDest
                _FREEIMAGE TempCanvas
            END IF
            _FONT PrevFont
        ELSE
            __UI_Controls(ThisID).HotKey = 0
        END IF
    ELSE
        __UI_Controls(ThisID).HotKey = 0
    END IF

    __UI_Captions(ThisID) = NewCaption$
END SUB

'---------------------------------------------------------------------------------
SUB __UI_SetText (Control$, NewText$)
    __UI_Texts(__UI_GetID(Control$)) = NewText$
END SUB

'---------------------------------------------------------------------------------
FUNCTION __UI_LoadFont& (FontFile$, Size%, Parameters$)
    DIM Handle&
    Handle& = _LOADFONT(FontFile$, Size%, Parameters$)
    IF Handle& <= 0 THEN Handle& = 16
    __UI_LoadFont& = Handle&
END FUNCTION

'---------------------------------------------------------------------------------
SUB __UI_LoadImage (This AS __UI_ControlTYPE, File$)
    DIM PrevDest AS LONG, ErrorMessage$
    STATIC NotFoundImage AS LONG

    IF This.HelperCanvas <> 0 THEN _FREEIMAGE This.HelperCanvas

    IF This.Type = __UI_Type_PictureBox THEN
        __UI_Texts(This.ID) = File$
    END IF

    IF _FILEEXISTS(File$) THEN
        This.HelperCanvas = _LOADIMAGE(File$, 32)
        IF This.HelperCanvas = -1 THEN ErrorMessage$ = "Unable to load file:"
    ELSE
        ErrorMessage$ = "Missing image file:"
    END IF

    IF LEN(ErrorMessage$) THEN
        IF NotFoundImage = 0 THEN NotFoundImage = __UI_LoadImageFromCode("notfound.png")

        PrevDest = _DEST
        This.HelperCanvas = _NEWIMAGE(This.Width, This.Height, 32)
        _DEST This.HelperCanvas
        _PRINTMODE _KEEPBACKGROUND
        _FONT __UI_Fonts(This.Font)
        CLS , _RGBA32(0, 0, 0, 0)
        'Place the "missing" icon
        _PUTIMAGE (This.Width / 2 - _WIDTH(NotFoundImage) / 2, This.Height / 2 - _HEIGHT(NotFoundImage) / 2), NotFoundImage

        COLOR This.ForeColor
        _PRINTSTRING (5, 5), ErrorMessage$
        _PRINTSTRING (5, 5 + _FONTHEIGHT), File$
        _DEST PrevDest
    END IF
END SUB

'---------------------------------------------------------------------------------
FUNCTION __UI_LoadImageFromCode& (FileName$)
    'Contains portions of Dav's BIN2BAS
    'http://www.qbasicnews.com/dav/qb64.php

    DIM A$, i&, B$, C%, F$, C$, t%, B&, X$, btemp$, BASFILE$
    DIM MemoryBlock AS _MEM, TempImage AS LONG
    DIM NewWidth AS INTEGER, NewHeight AS INTEGER

    A$ = __UI_ImageData$(FileName$)
    IF LEN(A$) = 0 THEN ERROR 5: EXIT SUB

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
    __UI_LoadImageFromCode& = TempImage
END FUNCTION

'---------------------------------------------------------------------------------
FUNCTION __UI_ImageData$ (File$)
    DIM A$

    SELECT CASE LCASE$(File$)
        CASE "notfound.png"
            A$ = MKI$(40) + MKI$(48) 'Width, Height
            A$ = A$ + "S=fHnS6JXM?JXQfmXQ6JgS6JXM?JXQfmXQ6JgS6JXM?JXQfmXQ6JgS6JXM?J"
            A$ = A$ + "XQfmXQ6JgS6JXM?JXQfmXQ6JgS6JXM?JXQfmXQ6JgS6JXM?JXQfmXQ6JgS6J"
            A$ = A$ + "XM?JXQfmXQ6JgS6JXM?JXQfmVIVIkWFJYi40000000000000000000000000"
            A$ = A$ + "000000000000000000000000000000000XVJZIoooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooooooooooooooooooo7GL"
            A$ = A$ + "am?L`1glUEFI>10000000000000000000000000000000000000000000000"
            A$ = A$ + "000000PJZYVmoooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooo?MdAgoTC>io37L`9oIWMFC00000000"
            A$ = A$ + "0000000000000000000000000000000000000000ZYVJfooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooodA7Mo[_njo?jXSno`17LbGFIUa400000000000000000000000000000"
            A$ = A$ + "0000000000000XVJZIoooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooC7Mdm_nj[oooooooOniWo?L"
            A$ = A$ + "`1WlUEFI<1000000000000000000000000000000000000PJZYVmoooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooo?MdAgoj[_nooooooooooooWOnio37L`5?ITAFA000000000000"
            A$ = A$ + "00000000000000000000ZYVJfooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooodA7Mo[_njooooooo"
            A$ = A$ + "oooooooooooiWOno`17LaGFIUA400000000000000000000000000XVJZIoo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooC7Mdm_nj[oooooooooooooooooooooooOniWo?L`17l"
            A$ = A$ + "S=fH3100000000000000000000PJZYVmoooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooo?MdAgoj[_n"
            A$ = A$ + "ooooooooooooooooooooooooooooWOnioofK_5?ITAV@0000000000000000"
            A$ = A$ + "ZYVJfooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooodA7Mo[_njooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooohS?no^iVKb;VHR540000000000XVJZIoooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooC7M"
            A$ = A$ + "dm_nj[ooooooooooooooooooooooooooooooooooooooo;^hRo_K^iVlR9VH"
            A$ = A$ + "110000PJZYVmoooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooo?MdAgoj[_noooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooR;^hokVK^9?ITA6@ZYVJfooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooomgOogFK]mOK]efo]eFKogFK]mOK]efo]eFKogFK]mOK]efo]eFKogFK"
            A$ = A$ + "]moJ[]foVIVIj[VJZIoooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooo[VJZI_JZYVmoooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooo_mfKooQ7Nho7NhQoOhQ7noQ7Nh"
            A$ = A$ + "o7NhQoOhQ7noQ7Nho7NhQoOhQ7noQ7Nho7NhQoOhQ7noQ7Nho7NhQoOhQ7no"
            A$ = A$ + "Q7Nho7NhQoOhQ7noQ7Nho7NhQo_mfKoooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooo_JZYVmZYVJfooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooFK]eoWK^in_b:[lo:[\bo[\b:o_b:[lo:[\bo[\b:o_b:[lo:[\b"
            A$ = A$ + "o[\b:o_b:[lo:[\bo[\b:o_b:[lo:[\bo[\b:o_b:[lo:[\bo[\b:oO^iVko"
            A$ = A$ + "FK]eooooooooooooooooooooooooooooooooooooooooooooZYVJf[VJZIoo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooK]eFo_eFKmooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooFK]eoK]eFooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooo[VJZI_JZYVmoooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooo_eFKmoFK]eoooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oK]eFo_eFKmooooooooooooooooooooooooooooooooooooooooooo_JZYVm"
            A$ = A$ + "ZYVJfoooooooooooooooooooooooooooooooooooooooooooFK]eoK]eFooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooo_eFKmoFK]eoooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooZYVJf[VJZIoooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooK]eFo_eFKmooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooFK]eoK]eFooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "o[VJZI_JZYVmoooooooooooooooooooooooooooooooooooooooooo_eFKmo"
            A$ = A$ + "FK]eoooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooK]eFo_eFKmooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooo_JZYVmZYVJfooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooFK]eoK]eFooooooooooooooooo_lbgoo"
            A$ = A$ + "c=WkoC=ejooooooooooooooooooooooooooooooooo?eD[ooc=Wko;_lmooo"
            A$ = A$ + "oooooooooooooo_eFKmoFK]eoooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooZYVJf[VJZIoooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oK]eFo_eFKmooooooooooooooooo5G<no300PoO5E<noB;]noooooooooooo"
            A$ = A$ + "oooooooooo_dB[ooEDaho300PoOa5SooooooooooooooooooFK]eoK]eFooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooo[VJZI_JZYVmoooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooo_eFKmoFK]eoooooooooooooooo"
            A$ = A$ + "oooooooNkmno000hoGA5SoodC[ooooooooooooodC[ooEDaho300PooNkmno"
            A$ = A$ + "oooooooooooooooooooooK]eFo_eFKmooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooo_JZYVmZYVJfooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooFK]eoK]eFooooooooooooooooooooooooooooc7O_o?000noEDah"
            A$ = A$ + "o?mdjooeG[ooHPaho300Po?Mdinooooooooooooooooooooooooooo_eFKmo"
            A$ = A$ + "FK]eooooooooooooooooooooooooooooooooooooooooooooZYVJf[VJZIoo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooK]eFo_eFKmooooooooo"
            A$ = A$ + "ooooooooooooooooooooooook]gko300Poo4C8noEDaho300PooLcinooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooFK]eoK]eFooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooo[VJZI_JZYVmoooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooo_eFKmoFK]eoooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooIWano000ho300PooGOanooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oK]eFo_eFKmooooooooooooooooooooooooooooooooooooooooooo_JZYVm"
            A$ = A$ + "ZYVJfoooooooooooooooooooooooooooooooooooooooooooFK]eoK]eFooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooOfI[ooJXaho300Po?000noFHahoC=e"
            A$ = A$ + "jooooooooooooooooooooooooooooooooo_eFKmoFK]eoooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooZYVJf[VJZIoooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooK]eFo_eFKmoooooooooooooooooooooooooooOf"
            A$ = A$ + "I[ooJXaho300Po?L`inoiUgko300Poo5G<noEG]noooooooooooooooooooo"
            A$ = A$ + "ooooooooFK]eoK]eFooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "o[VJZI_JZYVmoooooooooooooooooooooooooooooooooooooooooo_eFKmo"
            A$ = A$ + "FK]eoooooooooooooooooooooo_fJ[ooJXaho300Po?L`inooooooooooo?N"
            A$ = A$ + "hmno000hoOa5SoOeE[oooooooooooooooooooooooK]eFo_eFKmooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooo_JZYVmZYVJfooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooFK]eoK]eFooooooooooooooooo?jXcoo"
            A$ = A$ + "JXaho300PooK_enoooooooooooooooooooooo37L^o?000noJXahoOnilooo"
            A$ = A$ + "oooooooooooooo_eFKmoFK]eoooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooZYVJf[VJZIoooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oK]eFo_eFKmoooooooooooooooooA7MnoG@1Qo?L`inonkoooooooooooooo"
            A$ = A$ + "oooooooooo_onoooa5WkoG@1Qo?d@WooooooooooooooooooFK]eoK]eFooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooo[VJZI_JZYVmoooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooo_eFKmoFK]eoooooooooooooooo"
            A$ = A$ + "oooooo_mfkoooooooooooooooooooooooooooooooooooooooooooo_mfkoo"
            A$ = A$ + "oooooooooooooooooooooK]eFo_eFKmooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooo_JZYVmZYVJfooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooFK]eoK]eFooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooo_eFKmo"
            A$ = A$ + "FK]eooooooooooooooooooooooooooooooooooooooooooooZYVJf[VJZIoo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooK]eFo_eFKmooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooFK]eoK]eFooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooo[VJZI_JZYVmoooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooo_eFKmoFK]eoooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oK]eFo_eFKmooooooooooooooooooooooooooooooooooooooooooo_JZYVm"
            A$ = A$ + "ZYVJfoooooooooooooooooooooooooooooooooooooooooooFK]eoK]eFooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooo_eFKmoFK]eoooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooZYVJf[VJZIoooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooK]eFo?d@3moc?olo?olcoolc?ooc?olo?olcool"
            A$ = A$ + "c?ooc?olo?olcoolc?ooc?olo?olcoolc?ooc?olo?olcoolc?ooc?olo?ol"
            A$ = A$ + "coolc?oo@3=doK]eFooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "o[VJZI_JZYVmoooooooooooooooooooooooooooooooooooooooooo_hR;no"
            A$ = A$ + "hR;^oS;^hn?^hRkohR;^oS;^hn?^hRkohR;^oS;^hn?^hRkohR;^oS;^hn?^"
            A$ = A$ + "hRkohR;^oS;^hn?^hRkohR;^oS;^hn?^hRkohR;^oS;^hn_hR;nooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooo_JZYVmZYVJfooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooZYVJf[VJZIoooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooo[VJZI_JZYVmoooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooo_JZYVmZYVJfooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooooooooooZYVJf[VJZIoo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooo[VJZI_JZYVmoooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooo_JZYVm"
            A$ = A$ + "ZYVJfooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooZYVJf[VJZIoooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "o[VJZIoHS=VoXQ6JgS6JXM?JXQfmXQ6JgS6JXM?JXQfmXQ6JgS6JXM?JXQfm"
            A$ = A$ + "XQ6JgS6JXM?JXQfmXQ6JgS6JXM?JXQfmXQ6JgS6JXM?JXQfmXQ6JgS6JXM?J"
            A$ = A$ + "XQfmXQ6JgS6JXM?JXQfmXQ6JgS6JXM?JXQfmXQ6JgS6JXM?JXQfmXQ6JgS6J"
            A$ = A$ + "XM?JXQfmXQ6JgS6JXM?JXQfmXQ6JgS6JXMoHS=Vo%%%0"
    END SELECT
    __UI_ImageData$ = A$
END FUNCTION

'---------------------------------------------------------------------------------
FUNCTION __UI_SpecialCharsToCHR$ (Text$)
    DIM i AS LONG, Temp$

    Temp$ = CHR$(34)
    FOR i = 1 TO LEN(Text$)
        IF ASC(Text$, i) < 32 THEN
            Temp$ = Temp$ + CHR$(34) + " + CHR$(" + LTRIM$(STR$(ASC(Text$, i))) + ") + " + CHR$(34)
        ELSE
            Temp$ = Temp$ + MID$(Text$, i, 1)
        END IF
    NEXT
    __UI_SpecialCharsToCHR$ = Temp$ + CHR$(34)
END FUNCTION

'---------------------------------------------------------------------------------
SUB __UI_SetRadioButtonValue (id)
    'Radio buttons will change value of others in the same group
    DIM i AS LONG

    FOR i = 1 TO UBOUND(__UI_Controls)
        IF __UI_Controls(i).Type = __UI_Type_RadioButton AND __UI_Controls(i).ParentID = __UI_Controls(id).ParentID THEN
            __UI_Controls(i).Value = __UI_False
        END IF
    NEXT
    __UI_Controls(id).Value = __UI_True
END SUB

'---------------------------------------------------------------------------------
SUB __UI_CheckSelection (id)
    IF __UI_ShiftIsDown THEN
        IF NOT __UI_Controls(id).TextIsSelected THEN
            __UI_Controls(id).TextIsSelected = __UI_True
            __UI_Controls(id).SelectionStart = __UI_Controls(id).Cursor
        END IF
    ELSE
        __UI_Controls(id).TextIsSelected = __UI_False
        __UI_SelectedText = ""
        __UI_SelectionLength = 0
    END IF
END SUB

'---------------------------------------------------------------------------------
SUB __UI_DeleteSelection
    DIM s1 AS LONG, s2 AS LONG
    s1 = __UI_Controls(__UI_Focus).SelectionStart
    s2 = __UI_Controls(__UI_Focus).Cursor
    IF s1 > s2 THEN SWAP s1, s2
    __UI_Texts(__UI_Focus) = LEFT$(__UI_Texts(__UI_Focus), s1) + MID$(__UI_Texts(__UI_Focus), s2 + 1)
    __UI_Controls(__UI_Focus).TextIsSelected = __UI_False
    __UI_SelectedText = ""
    __UI_SelectionLength = 0
    __UI_Controls(__UI_Focus).Cursor = s1
END SUB

'---------------------------------------------------------------------------------
SUB __UI_CursorAdjustments
    IF __UI_Controls(__UI_Focus).Cursor > LEN(__UI_Texts(__UI_Focus)) THEN __UI_Controls(__UI_Focus).Cursor = LEN(__UI_Texts(__UI_Focus))
    IF __UI_Controls(__UI_Focus).Cursor > __UI_Controls(__UI_Focus).PrevCursor THEN
        IF __UI_Controls(__UI_Focus).Cursor - __UI_Controls(__UI_Focus).InputViewStart + 2 > __UI_Controls(__UI_Focus).FieldArea THEN __UI_Controls(__UI_Focus).InputViewStart = (__UI_Controls(__UI_Focus).Cursor - __UI_Controls(__UI_Focus).FieldArea) + 2
    ELSEIF __UI_Controls(__UI_Focus).Cursor < __UI_Controls(__UI_Focus).PrevCursor THEN
        IF __UI_Controls(__UI_Focus).Cursor < __UI_Controls(__UI_Focus).InputViewStart - 1 THEN __UI_Controls(__UI_Focus).InputViewStart = __UI_Controls(__UI_Focus).Cursor
    END IF
    IF __UI_Controls(__UI_Focus).InputViewStart < 1 THEN __UI_Controls(__UI_Focus).InputViewStart = 1
END SUB

'---------------------------------------------------------------------------------
SUB __UI_AddListBoxItem (WhichListBox$, Item$)
    DIM ThisID AS LONG

    ThisID = __UI_GetID(WhichListBox$)
    IF __UI_Controls(ThisID).Type <> __UI_Type_ListBox AND __UI_Controls(ThisID).Type <> __UI_Type_DropdownList THEN ERROR 5: EXIT SUB

    __UI_Texts(ThisID) = __UI_Texts(ThisID) + Item$ + CHR$(13)
    __UI_Controls(ThisID).Max = __UI_Controls(ThisID).Max + 1
    __UI_Controls(ThisID).LastVisibleItem = 0 'Reset this var so it'll be recalculated
END SUB

'---------------------------------------------------------------------------------
SUB __UI_RemoveListBoxItem (WhichListBox$, ItemToRemove AS INTEGER)
    DIM This AS __UI_ControlTYPE, TempText$, ThisItem%, FindLF&, TempCaption$

    This = __UI_Controls(__UI_GetID(WhichListBox$))
    IF This.Type <> __UI_Type_ListBox THEN ERROR 5: EXIT SUB

    IF ItemToRemove > This.Max THEN ERROR 5: EXIT SUB

    TempText$ = __UI_Texts(This.ID)
    __UI_Texts(This.ID) = ""

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

        IF ThisItem% <> ItemToRemove THEN __UI_Texts(This.ID) = __UI_Texts(This.ID) + TempCaption$ + CHR$(13)
    LOOP

    This.Max = This.Max - 1
    This.LastVisibleItem = 0 'Reset this var so it'll be recalculated
    IF This.Value = ItemToRemove THEN
        This.Value = 0
    ELSEIF This.Value > ItemToRemove THEN
        This.Value = This.Value - 1
    END IF

    __UI_Controls(This.ID) = This
END SUB

'---------------------------------------------------------------------------------
SUB __UI_ListBoxSearchItem (This AS __UI_ControlTYPE)
    STATIC SearchPattern$, LastListKeyHit AS DOUBLE
    DIM ThisItem%, FindLF&, TempCaption$, TempText$
    DIM ListItems$(1 TO This.Max)

    TempText$ = __UI_Texts(This.ID)
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

        ListItems$(ThisItem%) = TempCaption$
    LOOP

    IF TIMER - LastListKeyHit < 1 THEN
        SearchPattern$ = SearchPattern$ + UCASE$(CHR$(__UI_KeyHit))
        ThisItem% = This.Value
    ELSE
        SearchPattern$ = UCASE$(CHR$(__UI_KeyHit))
        ThisItem% = This.Value + 1
        IF ThisItem% > This.Max THEN ThisItem% = 1
    END IF

    DO
        IF UCASE$(LEFT$(ListItems$(ThisItem%), LEN(SearchPattern$))) = SearchPattern$ THEN
            This.Value = ThisItem%
            EXIT DO
        END IF
        ThisItem% = ThisItem% + 1
        IF ThisItem% > This.Max THEN ThisItem% = 1
        IF ThisItem% = This.Value THEN EXIT DO
    LOOP

    LastListKeyHit = TIMER
END SUB

'---------------------------------------------------------------------------------
FUNCTION __UI_ClipText$ (Text AS STRING, Width AS INTEGER)

    'TO DO: ADAPT THIS FUNCTION SO IT'LL USE THE CONTROL'S FONT
    '(OR DROP IT ALTOGETHER)

    DIM ClipTextLen, Temp$
    IF _PRINTWIDTH(Text) > Width THEN
        IF _FONTWIDTH = 0 THEN
            ClipTextLen = Width \ _PRINTWIDTH("_")
            DO
                IF _PRINTWIDTH(LEFT$(Temp$, ClipTextLen)) < Width THEN
                    __UI_ClipText$ = LEFT$(Text, ClipTextLen - 1)
                    EXIT FUNCTION
                END IF
                ClipTextLen = ClipTextLen - 1
            LOOP
        ELSE
            ClipTextLen = Width \ _FONTWIDTH
            __UI_ClipText$ = LEFT$(Text, ClipTextLen - 1)
        END IF
    ELSE
        __UI_ClipText$ = Text
    END IF
END FUNCTION

'---------------------------------------------------------------------------------
FUNCTION __UI_MessageBox& (Message$, Title$, Setup AS LONG)
    _DELAY .1 'So the interface can redraw before the messagebox kicks in
    $IF WIN THEN
        __UI_MessageBox& = __UI_MB(0, Title$ + CHR$(0), Message$ + CHR$(0), Setup)
    $ELSE
        IF (Setup AND 4) THEN
        __UI_MessageBox& = __UI_MB(0, Title$ + CHR$(0), Message$ + CHR$(0), 4)
        ELSE
        __UI_MessageBox& = __UI_MB(0, Title$ + CHR$(0), Message$ + CHR$(0), 0)
        END IF
    $END IF
END FUNCTION

'---------------------------------------------------------------------------------
SUB __UI_ActivateDropdownlist (This AS __UI_ControlTYPE)
    IF NOT This.Disabled THEN
        __UI_ParentDropdownList = This.ID
        __UI_ActiveDropdownList = __UI_NewControl(__UI_Type_ListBox, RTRIM$(This.Name) + CHR$(254) + "DropdownList", 0, 0, 0, 0, 0)
        __UI_Texts(__UI_ActiveDropdownList) = __UI_Texts(This.ID)
        __UI_Controls(__UI_ActiveDropdownList).Left = This.Left + __UI_Controls(This.ParentID).Left
        __UI_Controls(__UI_ActiveDropdownList).Width = This.Width
        __UI_Controls(__UI_ActiveDropdownList).Top = This.Top + This.Height + __UI_Controls(This.ParentID).Top

        'Make up to 10 items visible:
        __UI_Controls(__UI_ActiveDropdownList).Height = _FONTHEIGHT(__UI_Fonts(This.Font)) * 10.5

        IF __UI_Controls(__UI_ActiveDropdownList).Top + __UI_Controls(__UI_ActiveDropdownList).Height > _HEIGHT THEN
            __UI_Controls(__UI_ActiveDropdownList).Top = _HEIGHT - __UI_Controls(__UI_ActiveDropdownList).Height
        END IF
        __UI_Controls(__UI_ActiveDropdownList).Max = This.Max
        __UI_Controls(__UI_ActiveDropdownList).Value = This.Value
        __UI_Controls(__UI_ActiveDropdownList).ForeColor = This.ForeColor
        __UI_Controls(__UI_ActiveDropdownList).BackColor = This.BackColor
        __UI_Controls(__UI_ActiveDropdownList).SelectedForeColor = This.SelectedForeColor
        __UI_Controls(__UI_ActiveDropdownList).SelectedBackColor = This.SelectedBackColor
        __UI_Controls(__UI_ActiveDropdownList).Font = This.Font
        __UI_Controls(__UI_ActiveDropdownList).HasBorder = __UI_True
        __UI_Controls(__UI_ActiveDropdownList).BorderColor = _RGB32(0, 0, 0)
        __UI_Controls(__UI_ActiveDropdownList).CanHaveFocus = __UI_True
        __UI_Controls(__UI_ActiveDropdownList).InputViewStart = 1
        __UI_Controls(__UI_ActiveDropdownList).LastVisibleItem = 10
        __UI_Focus = __UI_ActiveDropdownList

        'Adjust view:
        IF __UI_Controls(__UI_Focus).Value < __UI_Controls(__UI_Focus).InputViewStart THEN
            __UI_Controls(__UI_Focus).InputViewStart = __UI_Controls(__UI_Focus).Value
        ELSEIF __UI_Controls(__UI_Focus).Value > __UI_Controls(__UI_Focus).InputViewStart + __UI_Controls(__UI_Focus).LastVisibleItem - 1 THEN
            __UI_Controls(__UI_Focus).InputViewStart = __UI_Controls(__UI_Focus).Value - __UI_Controls(__UI_Focus).LastVisibleItem + 1
        END IF
    END IF
END SUB

'---------------------------------------------------------------------------------
SUB __UI_ActivateMenu (This AS __UI_ControlTYPE, SelectFirstItem AS _BYTE)
    DIM i AS LONG, ItemOffset AS INTEGER, TotalItems AS INTEGER, ItemHeight AS INTEGER

    IF NOT This.Disabled THEN
        IF __UI_ActiveMenu > 0 THEN __UI_DestroyControl __UI_Controls(__UI_ActiveMenu)
        __UI_ActiveMenu = __UI_NewControl(__UI_Type_MenuPanel, RTRIM$(This.Name) + CHR$(254) + "Panel", 0, 0, 0, 0, 0)
        IF __UI_ActiveMenu = 0 THEN EXIT SUB
        __UI_ParentMenu = This.ID
        __UI_Controls(__UI_ActiveMenu).Left = This.Left
        __UI_Controls(__UI_ActiveMenu).Font = This.Font

        _FONT __UI_Fonts(This.Font)
        IF _PRINTWIDTH("W") <> _PRINTWIDTH("I") THEN ItemOffset = _PRINTWIDTH("____") ELSE ItemOffset = _PRINTWIDTH("__")

        'Calculate panel's width and position the menu items
        __UI_Controls(__UI_ActiveMenu).Width = 120

        ItemHeight = _FONTHEIGHT * 1.5
        __UI_Controls(__UI_ActiveMenu).Top = _FONTHEIGHT * 1.5
        __UI_Controls(__UI_ActiveMenu).Height = _FONTHEIGHT * .3
        FOR i = 1 TO UBOUND(__UI_Controls)
            IF __UI_Controls(i).ParentID = This.ID AND NOT __UI_Controls(i).Hidden THEN
                TotalItems = TotalItems + 1
                __UI_Controls(i).Width = ItemOffset * 2 + _PRINTWIDTH(__UI_Captions(i))
                IF __UI_Controls(__UI_ActiveMenu).Width < __UI_Controls(i).Width THEN
                    __UI_Controls(__UI_ActiveMenu).Width = __UI_Controls(i).Width
                END IF

                'Reposition menu items:
                __UI_Controls(i).Top = __UI_Controls(__UI_ActiveMenu).Height
                __UI_Controls(i).Height = ItemHeight

                'Grow the panel:
                __UI_Controls(__UI_ActiveMenu).Height = __UI_Controls(__UI_ActiveMenu).Height + ItemHeight
            END IF
        NEXT

        __UI_Controls(__UI_ActiveMenu).Height = __UI_Controls(__UI_ActiveMenu).Height + _FONTHEIGHT * .3

        IF __UI_Controls(__UI_ActiveMenu).Left + __UI_Controls(__UI_ActiveMenu).Width > _WIDTH THEN
            __UI_Controls(__UI_ActiveMenu).Left = _WIDTH - __UI_Controls(__UI_ActiveMenu).Width - 5
        END IF

        IF SelectFirstItem THEN
            __UI_Focus = __UI_NextMenuItem(0)
        ELSE
            __UI_Focus = __UI_ActiveMenu
        END IF
    END IF
END SUB

'---------------------------------------------------------------------------------
SUB __UI_DoEvents
    __UI_ProcessInput
    IF __UI_HasInput THEN
        __UI_EventDispatcher
    END IF
END SUB

'---------------------------------------------------------------------------------
SUB __UI_MakeHardwareImageFromCanvas (This AS __UI_ControlTYPE)
    DIM TempCanvas AS LONG

    'Convert to hardware images only those that aren't contained in a frame
    IF This.ParentID = 0 THEN
        TempCanvas = _COPYIMAGE(This.Canvas, 33)
        IF This.Canvas < -1 THEN _FREEIMAGE This.Canvas
        This.Canvas = TempCanvas
    END IF
END SUB

'---------------------------------------------------------------------------------
SUB __UI_MakeHardwareImage (This AS LONG)
    DIM TempCanvas AS LONG

    TempCanvas = _COPYIMAGE(This, 33)
    _FREEIMAGE This
    This = TempCanvas
END SUB

'---------------------------------------------------------------------------------
FUNCTION __UI_FirstMenuBarControl
    DIM i AS LONG
    FOR i = 1 TO UBOUND(__UI_Controls)
        IF __UI_Controls(i).ID > 0 AND __UI_Controls(i).Type = __UI_Type_MenuBar AND NOT __UI_Controls(i).Hidden THEN
            __UI_FirstMenuBarControl = i
            EXIT FUNCTION
        END IF
    NEXT
END FUNCTION

'---------------------------------------------------------------------------------
FUNCTION __UI_NextMenuBarControl (CurrentMenuBarControl)
    DIM i AS LONG
    i = CurrentMenuBarControl
    DO
        i = i + 1
        IF i > UBOUND(__UI_Controls) THEN i = 1
        IF i = CurrentMenuBarControl THEN EXIT DO
        IF __UI_Controls(i).Type = __UI_Type_MenuBar AND NOT __UI_Controls(i).Hidden AND NOT __UI_Controls(i).Disabled THEN
            EXIT DO
        END IF
    LOOP
    __UI_NextMenuBarControl = i
END FUNCTION

'---------------------------------------------------------------------------------
FUNCTION __UI_PreviousMenuBarControl (CurrentMenuBarControl)
    DIM i AS LONG
    i = CurrentMenuBarControl
    DO
        i = i - 1
        IF i < 1 THEN i = UBOUND(__UI_Controls)
        IF i = CurrentMenuBarControl THEN EXIT DO
        IF __UI_Controls(i).Type = __UI_Type_MenuBar AND NOT __UI_Controls(i).Hidden AND NOT __UI_Controls(i).Disabled THEN
            EXIT DO
        END IF
    LOOP
    __UI_PreviousMenuBarControl = i
END FUNCTION

'---------------------------------------------------------------------------------
FUNCTION __UI_NextMenuItem (CurrentMenuItemControl)
    DIM i AS LONG
    i = CurrentMenuItemControl
    DO
        i = i + 1
        IF i > UBOUND(__UI_Controls) THEN i = 1
        IF i = CurrentMenuItemControl THEN EXIT DO
        IF __UI_Controls(i).Type = __UI_Type_MenuItem AND NOT __UI_Controls(i).Hidden AND __UI_Controls(i).ParentID = __UI_ParentMenu THEN
            EXIT DO
        END IF
    LOOP
    __UI_NextMenuItem = i
END FUNCTION

'---------------------------------------------------------------------------------
FUNCTION __UI_PreviousMenuItem (CurrentMenuItemControl)
    DIM i AS LONG
    i = CurrentMenuItemControl
    DO
        i = i - 1
        IF i < 1 THEN i = UBOUND(__UI_Controls)
        IF i = CurrentMenuItemControl THEN EXIT DO
        IF __UI_Controls(i).Type = __UI_Type_MenuItem AND NOT __UI_Controls(i).Hidden AND __UI_Controls(i).ParentID = __UI_ParentMenu THEN
            EXIT DO
        END IF
    LOOP
    __UI_PreviousMenuItem = i
END FUNCTION

'---------------------------------------------------------------------------------
SUB __UI_RefreshMenuBar
    'Calculate menu items' .Left and .Width
    DIM LeftOffset AS INTEGER, ItemOffset AS INTEGER, i AS LONG
    DIM TotalItems AS INTEGER, LastMenuItem AS LONG

    _FONT __UI_Fonts(__UI_Controls(__UI_FormID).Font)
    IF _PRINTWIDTH("W") <> _PRINTWIDTH("I") THEN ItemOffset = _PRINTWIDTH("__") ELSE ItemOffset = _PRINTWIDTH("__")

    FOR i = 1 TO UBOUND(__UI_Controls)
        IF __UI_Controls(i).ID > 0 THEN
            IF __UI_Controls(i).Type = __UI_Type_MenuBar AND NOT __UI_Controls(i).Hidden THEN
                TotalItems = TotalItems + 1
                IF TotalItems = 1 THEN
                    LeftOffset = ItemOffset
                ELSE
                    LeftOffset = LeftOffset + __UI_Controls(LastMenuItem).Width
                END IF
                __UI_Controls(i).Width = ItemOffset + _PRINTWIDTH(__UI_Captions(i)) + ItemOffset
                IF __UI_Controls(i).Align = __UI_Left THEN
                    __UI_Controls(i).Left = LeftOffset
                ELSE
                    __UI_Controls(i).Left = __UI_Controls(__UI_FormID).Width - 1 - ItemOffset - __UI_Controls(i).Width
                END IF
                LastMenuItem = i
            END IF
        END IF
    NEXT
END SUB

'---------------------------------------------------------------------------------
'*** XP ***
'UI theme mimicking Windows XP's controls style
'Images located under xp.files\
'Uses hardware images.
'---------------------------------------------------------------------------------
SUB __UI_ThemeSetup
    'Metrics
    __UI_ScrollbarWidth = 17
    __UI_ScrollbarButtonHeight = 17
END SUB

'---------------------------------------------------------------------------------
FUNCTION __UI_DefaultColor~& (ControlType AS _BYTE, Attribute AS _BYTE)
    DIM Colors(1 TO 5) AS _UNSIGNED LONG

    '.ForeColor
    Colors(1) = _RGB32(0, 0, 0)
    '.BackColor
    Colors(2) = _RGB32(235, 233, 237)
    '.SelectedForeColor
    Colors(3) = _RGB32(255, 255, 255)
    '.SelectedBackColor
    Colors(4) = _RGB32(78, 150, 216)
    '.BorderColor
    Colors(5) = _RGB32(167, 166, 170)

    'Specific cases:
    SELECT CASE ControlType
        CASE __UI_Type_TextBox, __UI_Type_ListBox, __UI_Type_DropdownList
            Colors(2) = _RGB32(255, 255, 255)
    END SELECT

    __UI_DefaultColor~& = Colors(Attribute)
END FUNCTION

'---------------------------------------------------------------------------------
SUB __UI_DrawButton (This AS __UI_ControlTYPE, ControlState AS _BYTE)
    'ControlState: 1 = Normal; 2 = Hover/focus; 3 = Mouse down; 4 = Disabled
    DIM TempColor~&, TempCaption$, HasShadow AS _BYTE
    DIM PrevDest AS LONG, TempControlState AS _BYTE

    STATIC ControlImage AS LONG, Initialized AS _BYTE
    CONST ButtonHeight = 21
    CONST ButtonWidth = 18

    IF ControlImage = 0 THEN
        IF Initialized THEN ERROR 5: EXIT SUB
        Initialized = __UI_True
        ControlImage = _LOADIMAGE("xp.files\button.png", 32)
        IF ControlImage = -1 THEN ERROR 5: ControlImage = 0: EXIT SUB
    END IF

    TempControlState = ControlState
    IF TempControlState = 1 THEN
        IF (This.ID = __UI_DefaultButtonID AND This.ID <> __UI_Focus AND __UI_Controls(__UI_Focus).Type <> __UI_Type_Button) OR This.ID = __UI_Focus THEN
            TempControlState = 5
        END IF
    END IF

    IF This.ControlState <> TempControlState OR This.FocusState <> (__UI_Focus = This.ID) OR __UI_Captions(This.ID) <> __UI_TempCaptions(This.ID) OR This.PreviousParentID <> This.ParentID OR __UI_ForceRedraw THEN
        'Last time this control was drawn it had a different state/caption, so it'll be redrawn
        This.ControlState = TempControlState
        This.FocusState = __UI_Focus = This.ID
        __UI_TempCaptions(This.ID) = __UI_Captions(This.ID)
        This.PreviousParentID = This.ParentID
        IF This.ParentID THEN __UI_Controls(This.ParentID).ChildrenRedrawn = __UI_True

        IF This.Canvas <> 0 THEN
            _FREEIMAGE This.Canvas
        END IF

        This.Canvas = _NEWIMAGE(This.Width, This.Height, 32)

        PrevDest = _DEST
        _DEST This.Canvas
        _FONT __UI_Fonts(This.Font)
        CLS , _RGBA32(0, 0, 0, 0)
        TempCaption$ = __UI_Captions(This.ID)

        'Back surface
        _PUTIMAGE (0, 3)-(This.Width - 1, This.Height - 4), ControlImage, , (3, TempControlState * ButtonHeight - ButtonHeight + 3)-STEP(11, ButtonHeight - 7)

        'Top and bottom edges
        _PUTIMAGE (3, 0)-STEP(This.Width - 6, 3), ControlImage, , (3, TempControlState * ButtonHeight - ButtonHeight)-STEP(11, 3)
        _PUTIMAGE (3, This.Height - 3)-STEP(This.Width - 6, 3), ControlImage, , (3, TempControlState * ButtonHeight - ButtonHeight + 18)-STEP(11, 3)

        'Left edges and corners:
        _PUTIMAGE (0, 2)-STEP(2, This.Height - 4), ControlImage, , (0, TempControlState * ButtonHeight - ButtonHeight + 2)-STEP(2, ButtonHeight - 6)
        _PUTIMAGE (0, 0), ControlImage, , (0, TempControlState * ButtonHeight - ButtonHeight)-STEP(2, 2)
        _PUTIMAGE (0, This.Height - 3), ControlImage, , (0, TempControlState * ButtonHeight - 3)-STEP(2, 2)

        'Right edges and corners:
        _PUTIMAGE (This.Width - 3, 2)-STEP(2, This.Height - 4), ControlImage, , (ButtonWidth - 3, TempControlState * ButtonHeight - ButtonHeight + 2)-STEP(2, ButtonHeight - 6)
        _PUTIMAGE (This.Width - 2, 0), ControlImage, , (ButtonWidth - 2, TempControlState * ButtonHeight - ButtonHeight)-STEP(2, 2)
        _PUTIMAGE (This.Width - 3, This.Height - 3), ControlImage, , (ButtonWidth - 3, TempControlState * ButtonHeight - 3)-STEP(2, 2)

        'Caption:
        _PRINTMODE _KEEPBACKGROUND
        IF NOT This.Disabled THEN
            COLOR This.ForeColor, TempColor~&
        ELSE
            COLOR __UI_Darken(__UI_Controls(__UI_FormID).BackColor, 80), TempColor~&
        END IF
        _PRINTSTRING ((This.Width \ 2 - _PRINTWIDTH(TempCaption$) \ 2), ((This.Height \ 2) - _FONTHEIGHT \ 2) + 2), TempCaption$

        'Hot key:
        IF This.HotKey > 0 AND __UI_ShowHotKeys AND NOT This.Disabled THEN
            LINE ((This.Width \ 2 - _PRINTWIDTH(TempCaption$) \ 2) + This.HotKeyOffset, ((This.Height \ 2) + _FONTHEIGHT \ 2) + 1)-STEP(_PRINTWIDTH(CHR$(This.HotKey)) - 1, 0), This.ForeColor
        END IF

        'Focus outline:
        IF __UI_Focus = This.ID THEN
            LINE (2, 2)-STEP(This.Width - 5, This.Height - 5), _RGB32(0, 0, 0), B , 21845
        END IF

        __UI_MakeHardwareImageFromCanvas This
        _DEST PrevDest
    END IF

    _PUTIMAGE (This.Left, This.Top), This.Canvas
END SUB

'---------------------------------------------------------------------------------
SUB __UI_DrawLabel (This AS __UI_ControlTYPE, ControlState AS _BYTE)
    DIM PrevDest AS LONG
    DIM CaptionIndent AS INTEGER, TempCaption$

    IF This.ControlState <> ControlState OR __UI_Captions(This.ID) <> __UI_TempCaptions(This.ID) OR This.PreviousParentID <> This.ParentID OR __UI_ForceRedraw THEN
        'Last time this control was drawn it had a different state/caption, so it'll be redrawn
        This.ControlState = ControlState
        __UI_TempCaptions(This.ID) = __UI_Captions(This.ID)
        IF This.ParentID THEN __UI_Controls(This.ParentID).ChildrenRedrawn = __UI_True
        This.PreviousParentID = This.ParentID

        IF This.Canvas <> 0 THEN
            _FREEIMAGE This.Canvas
        END IF

        This.Canvas = _NEWIMAGE(This.Width, This.Height, 32)

        PrevDest = _DEST
        _DEST This.Canvas
        _FONT __UI_Fonts(This.Font)

        IF This.HasBorder THEN CaptionIndent = 5 ELSE CaptionIndent = 0

        TempCaption$ = __UI_Captions(This.ID)

        IF This.BackStyle = __UI_Opaque THEN
            _PRINTMODE _FILLBACKGROUND
            CLS , This.BackColor
        ELSE
            CLS , _RGBA32(0, 0, 0, 0)
            _PRINTMODE _KEEPBACKGROUND
        END IF

        IF This.HasBorder THEN
            LINE (0, 0)-STEP(This.Width - 1, This.Height - 1), This.BorderColor, B
        END IF

        IF NOT This.Disabled THEN
            COLOR This.ForeColor, This.BackColor
        ELSE
            COLOR __UI_Darken(__UI_Controls(__UI_FormID).BackColor, 80), This.BackColor
        END IF

        'Caption:
        DIM CaptionLeft AS INTEGER

        SELECT CASE This.Align
            CASE __UI_Left
                CaptionLeft = CaptionIndent
            CASE __UI_Center
                CaptionLeft = (This.Width \ 2 - _PRINTWIDTH(TempCaption$) \ 2)
            CASE __UI_Right
                CaptionLeft = (This.Width - _PRINTWIDTH(TempCaption$)) - CaptionIndent
        END SELECT

        _PRINTSTRING (CaptionLeft, ((This.Height \ 2) - _FONTHEIGHT \ 2)), TempCaption$

        'Hot key:
        IF This.HotKey > 0 AND __UI_ShowHotKeys AND NOT This.Disabled THEN
            LINE (CaptionLeft + This.HotKeyOffset, ((This.Height \ 2) + _FONTHEIGHT \ 2))-STEP(_PRINTWIDTH(CHR$(This.HotKey)) - 1, 0), This.ForeColor
        END IF

        __UI_MakeHardwareImageFromCanvas This
        _DEST PrevDest
    END IF

    _PUTIMAGE (This.Left, This.Top), This.Canvas
END SUB

'---------------------------------------------------------------------------------
SUB __UI_DrawRadioButton (This AS __UI_ControlTYPE, ControlState AS _BYTE)
    DIM PrevDest AS LONG
    DIM CaptionIndent AS INTEGER, TempCaption$

    STATIC ControlImage AS LONG, Initialized AS _BYTE
    CONST ImageHeight = 13
    CONST ImageWidth = 13

    IF ControlImage = 0 THEN
        IF Initialized THEN ERROR 5: EXIT SUB
        Initialized = __UI_True
        ControlImage = _LOADIMAGE("xp.files\radiobutton.png", 32)
        IF ControlImage = -1 THEN ERROR 5: ControlImage = 0: EXIT SUB
    END IF

    IF This.ControlState <> ControlState OR This.FocusState <> (__UI_Focus = This.ID) OR __UI_Captions(This.ID) <> __UI_TempCaptions(This.ID) OR This.Value <> This.PreviousValue OR This.PreviousParentID <> This.ParentID OR __UI_ForceRedraw THEN
        'Last time this control was drawn it had a different state/caption, so it'll be redrawn
        This.ControlState = ControlState
        This.FocusState = __UI_Focus = This.ID
        This.PreviousValue = This.Value
        __UI_TempCaptions(This.ID) = __UI_Captions(This.ID)
        IF This.ParentID THEN __UI_Controls(This.ParentID).ChildrenRedrawn = __UI_True
        This.PreviousParentID = This.ParentID

        IF This.Canvas <> 0 THEN
            _FREEIMAGE This.Canvas
        END IF

        IF This.Height < ImageHeight THEN This.Height = ImageHeight
        This.Canvas = _NEWIMAGE(This.Width + 1, This.Height + 1, 32)

        PrevDest = _DEST
        _DEST This.Canvas
        _FONT __UI_Fonts(This.Font)

        '------
        IF This.BackStyle = __UI_Opaque THEN
            _PRINTMODE _FILLBACKGROUND
            CLS , This.BackColor
        ELSE
            CLS , _RGBA32(0, 0, 0, 0)
            _PRINTMODE _KEEPBACKGROUND
        END IF

        DIM i AS SINGLE, BoxSize%
        BoxSize% = 10

        CaptionIndent = 0
        IF This.HasBorder = __UI_True THEN
            CaptionIndent = 5
            LINE (0, 0)-STEP(This.Width - 1, This.Height - 1), This.BorderColor, B
        END IF

        IF This.Value THEN ControlState = ControlState + 4
        _PUTIMAGE (0, This.Height \ 2 - (ImageHeight \ 2))-STEP(ImageWidth - 1, ImageHeight - 1), ControlImage, , (0, ControlState * ImageHeight - ImageHeight)-STEP(12, 12)

        CaptionIndent = CaptionIndent + ImageWidth * 1.5
        TempCaption$ = __UI_Captions(This.ID)

        IF NOT This.Disabled THEN
            COLOR This.ForeColor, This.BackColor
        ELSE
            COLOR __UI_Darken(__UI_Controls(__UI_FormID).BackColor, 80), This.BackColor
        END IF

        _PRINTSTRING (CaptionIndent, ((This.Height \ 2) - _FONTHEIGHT \ 2) + 1), TempCaption$

        'Hot key:
        IF This.HotKey > 0 AND __UI_ShowHotKeys AND NOT This.Disabled THEN
            LINE (CaptionIndent + This.HotKeyOffset, ((This.Height \ 2) + _FONTHEIGHT \ 2))-STEP(_PRINTWIDTH(CHR$(This.HotKey)) - 1, 0), This.ForeColor
        END IF

        'Focus outline
        IF __UI_Focus = This.ID THEN
            LINE (CaptionIndent - 1, 0)-STEP(This.Width - CaptionIndent - 1, This.Height - 1), _RGB32(0, 0, 0), B , 21845
        END IF

        '------

        __UI_MakeHardwareImageFromCanvas This
        _DEST PrevDest
    END IF

    _PUTIMAGE (This.Left, This.Top), This.Canvas
END SUB

'---------------------------------------------------------------------------------
SUB __UI_DrawCheckBox (This AS __UI_ControlTYPE, ControlState AS _BYTE)
    DIM PrevDest AS LONG
    DIM CaptionIndent AS INTEGER, TempCaption$

    STATIC ControlImage AS LONG, Initialized AS _BYTE
    CONST ImageHeight = 13
    CONST ImageWidth = 13

    IF ControlImage = 0 THEN
        IF Initialized THEN ERROR 5: EXIT SUB
        Initialized = __UI_True
        ControlImage = _LOADIMAGE("xp.files\checkbox.png", 32)
        IF ControlImage = -1 THEN ERROR 5: ControlImage = 0: EXIT SUB
    END IF

    IF This.ControlState <> ControlState OR This.FocusState <> (__UI_Focus = This.ID) OR __UI_Captions(This.ID) <> __UI_TempCaptions(This.ID) OR This.Value <> This.PreviousValue OR This.PreviousParentID <> This.ParentID OR __UI_ForceRedraw THEN
        'Last time this control was drawn it had a different state/caption, so it'll be redrawn
        This.ControlState = ControlState
        This.FocusState = __UI_Focus = This.ID
        This.PreviousValue = This.Value
        __UI_TempCaptions(This.ID) = __UI_Captions(This.ID)
        IF This.ParentID THEN __UI_Controls(This.ParentID).ChildrenRedrawn = __UI_True
        This.PreviousParentID = This.ParentID

        IF This.Canvas <> 0 THEN
            _FREEIMAGE This.Canvas
        END IF

        IF This.Height < ImageHeight THEN This.Height = ImageHeight
        This.Canvas = _NEWIMAGE(This.Width + 2, This.Height + 2, 32)

        PrevDest = _DEST
        _DEST This.Canvas
        _FONT __UI_Fonts(This.Font)

        '------
        IF This.BackStyle = __UI_Opaque THEN
            _PRINTMODE _FILLBACKGROUND
            CLS , This.BackColor
        ELSE
            CLS , _RGBA32(0, 0, 0, 0)
            _PRINTMODE _KEEPBACKGROUND
        END IF

        DIM i AS SINGLE, BoxSize%
        BoxSize% = 10

        CaptionIndent = 0

        IF This.Value THEN ControlState = ControlState + 4
        _PUTIMAGE (0, This.Height \ 2 - (ImageHeight \ 2))-STEP(ImageWidth - 1, ImageHeight - 1), ControlImage, , (0, ControlState * ImageHeight - ImageHeight)-STEP(ImageWidth - 1, ImageHeight - 1)

        CaptionIndent = CaptionIndent + ImageWidth * 1.5
        TempCaption$ = __UI_Captions(This.ID)

        IF NOT This.Disabled THEN
            COLOR This.ForeColor, This.BackColor
        ELSE
            COLOR __UI_Darken(__UI_Controls(__UI_FormID).BackColor, 80), This.BackColor
        END IF

        _PRINTSTRING (CaptionIndent, ((This.Height \ 2) - _FONTHEIGHT \ 2) + 1), TempCaption$

        'Hot key:
        IF This.HotKey > 0 AND __UI_ShowHotKeys AND NOT This.Disabled THEN
            LINE (CaptionIndent + This.HotKeyOffset, ((This.Height \ 2) + _FONTHEIGHT \ 2))-STEP(_PRINTWIDTH(CHR$(This.HotKey)) - 1, 0), This.ForeColor
        END IF

        'Focus outline
        IF __UI_Focus = This.ID THEN
            LINE (CaptionIndent - 1, 0)-STEP(This.Width - CaptionIndent - 1, This.Height - 1), _RGB32(0, 0, 0), B , 21845
        END IF
        '------

        __UI_MakeHardwareImageFromCanvas This
        _DEST PrevDest
    END IF

    _PUTIMAGE (This.Left, This.Top), This.Canvas
END SUB

'---------------------------------------------------------------------------------
SUB __UI_DrawProgressBar (This AS __UI_ControlTYPE, ControlState)
    DIM PrevDest AS LONG
    DIM CaptionIndent AS INTEGER, TempCaption$

    STATIC ControlImage_Track AS LONG, ControlImage_Chunk AS LONG
    STATIC Initialized AS _BYTE

    IF ControlImage_Track = 0 OR ControlImage_Chunk = 0 THEN
        IF Initialized THEN ERROR 5: EXIT SUB
        Initialized = __UI_True

        ControlImage_Track = _LOADIMAGE("xp.files\progresstrack.png", 32)
        IF ControlImage_Track = -1 THEN ERROR 5: ControlImage_Track = 0: EXIT SUB

        ControlImage_Chunk = _LOADIMAGE("xp.files\progresschunk.png", 32)
        IF ControlImage_Chunk = -1 THEN ERROR 5: ControlImage_Chunk = 0: EXIT SUB
    END IF

    IF This.ControlState <> ControlState OR This.FocusState <> (__UI_Focus = This.ID) OR __UI_Captions(This.ID) <> __UI_TempCaptions(This.ID) OR This.Value <> This.PreviousValue OR This.PreviousParentID <> This.ParentID OR __UI_ForceRedraw THEN
        'Last time this control was drawn it had a different state/caption, so it'll be redrawn
        This.ControlState = ControlState
        This.FocusState = __UI_Focus = This.ID
        This.PreviousValue = This.Value
        __UI_TempCaptions(This.ID) = __UI_Captions(This.ID)
        IF This.ParentID THEN __UI_Controls(This.ParentID).ChildrenRedrawn = __UI_True
        This.PreviousParentID = This.ParentID

        IF This.Canvas <> 0 THEN
            _FREEIMAGE This.Canvas
        END IF

        This.Canvas = _NEWIMAGE(This.Width, This.Height, 32)

        PrevDest = _DEST
        _DEST This.Canvas
        _FONT __UI_Fonts(This.Font)
        CLS , _RGBA32(0, 0, 0, 0)

        '------
        DIM DisplayValue AS _FLOAT

        IF This.Value > This.Max THEN ERROR 5

        'Draw track
        _PUTIMAGE (0, 0)-STEP(This.Width - 3, This.Height - 1), ControlImage_Track, , (5, 0)-(5, 19)
        _PUTIMAGE (0, 0)-STEP(4, This.Height - 1), ControlImage_Track, , (0, 0)-STEP(4, 19)
        _PUTIMAGE (This.Width - 4, 0)-STEP(2, This.Height - 1), ControlImage_Track, , (6, 0)-STEP(2, 19)

        'Draw progress
        IF This.Value THEN
            _PUTIMAGE (4, 4)-STEP(((This.Width - 9) / This.Max) * This.Value, This.Height - 9), ControlImage_Chunk
        END IF

        IF This.ShowPercentage AND LEN(__UI_Captions(This.ID)) > 0 THEN
            DIM ProgressString$, ReplaceCode%
            ProgressString$ = LTRIM$(STR$(FIX((This.Value / This.Max) * 100))) + "%"
            IF LEN(__UI_Captions(This.ID)) THEN
                TempCaption$ = __UI_Captions(This.ID)
                ReplaceCode% = INSTR(TempCaption$, "\#")
                IF ReplaceCode% THEN
                    TempCaption$ = LEFT$(TempCaption$, ReplaceCode% - 1) + ProgressString$ + MID$(TempCaption$, ReplaceCode% + 2)
                END IF
                TempCaption$ = TempCaption$
            ELSE
                TempCaption$ = ProgressString$
            END IF

            _PRINTMODE _KEEPBACKGROUND

            IF NOT This.Disabled THEN
                COLOR This.ForeColor
            ELSE
                COLOR __UI_Darken(__UI_Controls(__UI_FormID).BackColor, 70)
            END IF

            IF _PRINTWIDTH(TempCaption$) < This.Width THEN
                _PRINTSTRING (This.Width / 2 - _PRINTWIDTH(TempCaption$) / 2, This.Height / 2 - _FONTHEIGHT / 2), TempCaption$
            END IF
        END IF
        '------

        __UI_MakeHardwareImageFromCanvas This
        _DEST PrevDest
    END IF

    _PUTIMAGE (This.Left, This.Top), This.Canvas
END SUB

'---------------------------------------------------------------------------------
SUB __UI_DrawTextBox (This AS __UI_ControlTYPE, ControlState, ss1 AS LONG, ss2 AS LONG)
    DIM PrevDest AS LONG
    DIM CaptionIndent AS INTEGER, TempCaption$
    STATIC SetCursor#, cursorBlink%%

    IF __UI_Focus = This.ID THEN __UI_CursorAdjustments

    IF This.Type = __UI_Type_TextBox THEN
        'Make sure textboxes have fixed width fonts and a proper FieldArea property
        IF _FONTWIDTH(__UI_Fonts(This.Font)) = 0 THEN This.Font = 0
        This.FieldArea = This.Width \ _FONTWIDTH(__UI_Fonts(This.Font)) - 1
    END IF

    IF This.ControlState <> ControlState OR _
        This.FocusState <> (__UI_Focus = This.ID) OR _
        __UI_Captions(This.ID) <> __UI_TempCaptions(This.ID) OR _
        __UI_Texts(This.ID) <> __UI_TempTexts(This.ID) OR _
        (TIMER - SetCursor# > .4 AND __UI_Focus = This.ID) OR _
        (__UI_SelectionLength <> This.SelectionLength AND __UI_Focus = This.ID) OR _
        This.Cursor <> This.PrevCursor OR This.PreviousParentID <> This.ParentID OR _
        __UI_ForceRedraw THEN
        'Last time this control was drawn it had a different state/caption, so it'll be redrawn
        This.ControlState = ControlState
        This.FocusState = __UI_Focus = This.ID
        __UI_TempCaptions(This.ID) = __UI_Captions(This.ID)
        __UI_TempTexts(This.ID) = __UI_Texts(This.ID)
        This.SelectionLength = __UI_SelectionLength
        This.PrevCursor = This.Cursor
        IF This.ParentID THEN __UI_Controls(This.ParentID).ChildrenRedrawn = __UI_True
        This.PreviousParentID = This.ParentID

        IF This.Canvas <> 0 THEN
            _FREEIMAGE This.Canvas
        END IF

        This.Canvas = _NEWIMAGE(This.Width, This.Height, 32)

        PrevDest = _DEST
        _DEST This.Canvas
        _FONT __UI_Fonts(This.Font)

        '------
        _PRINTMODE _KEEPBACKGROUND
        CLS , This.BackColor

        TempCaption$ = __UI_Captions(This.ID)
        CaptionIndent = 0

        IF This.HasBorder THEN
            CaptionIndent = 5
            LINE (0, 0)-STEP(This.Width - 1, This.Height - 1), This.BorderColor, B
        END IF

        IF NOT This.Disabled AND LEN(__UI_Texts(This.ID)) THEN
            COLOR This.ForeColor, This.BackColor
        ELSE
            COLOR __UI_Darken(__UI_Controls(__UI_FormID).BackColor, 80), This.BackColor
        END IF

        IF __UI_Focus = This.ID AND NOT This.Disabled THEN
            IF LEN(__UI_Texts(This.ID)) THEN
                _PRINTSTRING (CaptionIndent, ((This.Height \ 2) - _FONTHEIGHT \ 2)), MID$(__UI_Texts(This.ID), This.InputViewStart, This.FieldArea)
            ELSE
                _PRINTSTRING (CaptionIndent, ((This.Height \ 2) - _FONTHEIGHT \ 2)), TempCaption$
            END IF

            IF This.TextIsSelected THEN
                STATIC c AS _UNSIGNED LONG
                IF c = 0 THEN
                    c = _RGBA32(_RED32(This.SelectedBackColor), _GREEN32(This.SelectedBackColor), _BLUE32(This.SelectedBackColor), 50)
                END IF
                LINE (CaptionIndent + ss1 * _FONTWIDTH, ((This.Height \ 2) - _FONTHEIGHT \ 2))-STEP(ss2 * _FONTWIDTH, _FONTHEIGHT), c, BF
            END IF

            IF TIMER - SetCursor# > .4 THEN
                SetCursor# = TIMER
                cursorBlink%% = NOT cursorBlink%%
            ELSEIF TIMER - __UI_LastInputReceived < .1 THEN
                SetCursor# = TIMER
                cursorBlink%% = __UI_True
            END IF
            IF cursorBlink%% THEN
                LINE (CaptionIndent + (This.Cursor - (This.InputViewStart - 1)) * _FONTWIDTH, ((This.Height \ 2) - _FONTHEIGHT \ 2))-STEP(0, _FONTHEIGHT), _RGB32(0, 0, 0)
            END IF
        ELSE
            IF LEN(__UI_Texts(This.ID)) THEN
                _PRINTSTRING (CaptionIndent, ((This.Height \ 2) - _FONTHEIGHT \ 2)), MID$(__UI_Texts(This.ID), 1, This.FieldArea)
            ELSE
                _PRINTSTRING (CaptionIndent, ((This.Height \ 2) - _FONTHEIGHT \ 2)), TempCaption$
            END IF
        END IF
        '------

        __UI_MakeHardwareImageFromCanvas This
        _DEST PrevDest
    END IF

    _PUTIMAGE (This.Left, This.Top), This.Canvas
END SUB

'---------------------------------------------------------------------------------
SUB __UI_DrawListBox (This AS __UI_ControlTYPE, ControlState)
    DIM PrevDest AS LONG
    DIM CaptionIndent AS INTEGER, TempCaption$

    IF This.ControlState <> ControlState OR This.FocusState <> (__UI_Focus = This.ID) OR This.PreviousValue <> This.Value OR __UI_Texts(This.ID) <> __UI_TempTexts(This.ID) OR This.PreviousInputViewStart <> This.InputViewStart OR This.PreviousParentID <> This.ParentID OR __UI_ForceRedraw THEN
        'Last time this control was drawn it had a different state/caption, so it'll be redrawn
        This.ControlState = ControlState
        This.FocusState = __UI_Focus = This.ID
        This.PreviousValue = This.Value
        This.PreviousInputViewStart = This.InputViewStart
        __UI_TempTexts(This.ID) = __UI_Texts(This.ID)
        IF This.ParentID THEN __UI_Controls(This.ParentID).ChildrenRedrawn = __UI_True
        This.PreviousParentID = This.ParentID

        IF This.Canvas <> 0 THEN
            _FREEIMAGE This.Canvas
        END IF

        This.Canvas = _NEWIMAGE(This.Width + 2, This.Height + 2, 32)

        PrevDest = _DEST
        _DEST This.Canvas
        _FONT __UI_Fonts(This.Font)

        '------
        _PRINTMODE _KEEPBACKGROUND

        IF This.BackStyle = __UI_Opaque THEN
            CLS , This.BackColor
        ELSE
            CLS , _RGBA32(0, 0, 0, 0)
        END IF

        CaptionIndent = 0
        IF This.HasBorder = __UI_True THEN
            CaptionIndent = 5
            LINE (0, 0)-STEP(This.Width - 1, This.Height - 1), This.BorderColor, B
        END IF

        IF LEN(__UI_Texts(This.ID)) THEN
            DIM TempText$, FindLF&, ThisItem%, ThisItemTop%
            DIM LastVisibleItem AS INTEGER

            TempText$ = __UI_Texts(This.ID)
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
                IF ThisItem% >= This.InputViewStart THEN
                    ThisItemTop% = ((ThisItem% - This.InputViewStart + 1) * _FONTHEIGHT - _FONTHEIGHT) + CaptionIndent
                    IF ThisItemTop% + _FONTHEIGHT > This.Height THEN EXIT DO
                    LastVisibleItem = LastVisibleItem + 1

                    IF ThisItem% = This.Value AND __UI_Focus = This.ID THEN __UI_SelectedText = TempCaption$

                    IF NOT This.Disabled THEN
                        COLOR This.ForeColor, This.BackColor
                    ELSE
                        COLOR __UI_Darken(__UI_Controls(__UI_FormID).BackColor, 80), This.BackColor
                    END IF

                    IF ThisItem% = This.Value THEN
                        IF __UI_Focus = This.ID THEN
                            COLOR This.SelectedForeColor, This.SelectedBackColor
                            LINE (CaptionIndent, ThisItemTop% - 1)-STEP(This.Width - CaptionIndent * 2, _FONTHEIGHT), This.SelectedBackColor, BF
                        ELSE
                            LINE (CaptionIndent, ThisItemTop% - 1)-STEP(This.Width - CaptionIndent * 2, _FONTHEIGHT), _RGBA32(0, 0, 0, 50), BF
                        END IF
                    END IF

                    SELECT CASE This.Align
                        CASE __UI_Left
                            _PRINTSTRING (CaptionIndent * 2, ThisItemTop%), TempCaption$
                        CASE __UI_Center
                            _PRINTSTRING ((This.Width \ 2 - _PRINTWIDTH(TempCaption$) \ 2), ThisItemTop%), TempCaption$
                        CASE __UI_Right
                            _PRINTSTRING ((This.Width - _PRINTWIDTH(TempCaption$)) - CaptionIndent, ThisItemTop%), TempCaption$
                    END SELECT
                END IF
            LOOP
            IF This.LastVisibleItem = 0 THEN This.LastVisibleItem = LastVisibleItem
            IF This.Max > This.LastVisibleItem THEN
                This.HasVScrollbar = __UI_True
                __UI_DrawVScrollBar This, ControlState
            ELSE
                This.HasVScrollbar = __UI_False
            END IF
        END IF
        '------

        __UI_MakeHardwareImageFromCanvas This
        _DEST PrevDest
    END IF

    _PUTIMAGE (This.Left, This.Top), This.Canvas
END SUB

'---------------------------------------------------------------------------------
SUB __UI_DrawVScrollBar (TempThis AS __UI_ControlTYPE, ControlState AS _BYTE)
    DIM TrackHeight AS INTEGER, ThumbHeight AS INTEGER, ThumbTop AS INTEGER
    DIM Ratio AS SINGLE
    DIM This AS __UI_ControlTYPE

    STATIC ControlImage_Button AS LONG, ControlImage_Track AS LONG
    STATIC ControlImage_Thumb AS LONG
    STATIC Initialized AS _BYTE
    CONST ImageHeight_Button = 17
    CONST ImageWidth_Button = 17
    CONST ImageHeight_Thumb = 22
    CONST ImageWidth_Thumb = 15

    IF ControlImage_Button = 0 OR ControlImage_Track = 0 OR ControlImage_Thumb = 0 THEN
        IF Initialized THEN ERROR 5: EXIT SUB
        Initialized = __UI_True

        ControlImage_Button = _LOADIMAGE("xp.files\scrollbuttons.png", 32)
        IF ControlImage_Button = -1 THEN ERROR 5: ControlImage_Button = 0: EXIT SUB

        ControlImage_Track = _LOADIMAGE("xp.files\scrolltrack.png", 32)
        IF ControlImage_Track = -1 THEN ERROR 5: ControlImage_Track = 0: EXIT SUB

        ControlImage_Thumb = _LOADIMAGE("xp.files\scrollthumb.png", 32)
        IF ControlImage_Thumb = -1 THEN ERROR 5: ControlImage_Thumb = 0: EXIT SUB
    END IF

    This = TempThis

    IF This.Type = __UI_Type_ListBox THEN
        This.Min = 0
        This.Max = This.Max - This.LastVisibleItem
        This.Value = This.InputViewStart - 1
        This.Left = This.Width - __UI_ScrollbarWidth
        This.Top = 0
        This.Width = __UI_ScrollbarWidth
        This.ForeColor = _RGB32(61, 116, 255)
        This.HasBorder = __UI_True
        This.BorderColor = _RGB32(0, 0, 0)
    END IF

    'Scrollbar measurements:
    TrackHeight = This.Height - __UI_ScrollbarButtonHeight * 2 - 1
    Ratio = (This.Max) / TrackHeight
    ThumbHeight = TrackHeight - This.Height * Ratio
    IF ThumbHeight < 20 THEN ThumbHeight = 20
    IF ThumbHeight > TrackHeight THEN ThumbHeight = TrackHeight
    ThumbTop = This.Top + (TrackHeight - ThumbHeight) * (This.Value / This.Max)
    TempThis.ThumbTop = TempThis.Top + ThumbTop + __UI_ScrollbarButtonHeight

    _PRINTMODE _KEEPBACKGROUND

    'Draw the bar
    IF NOT This.Disabled THEN
        _PUTIMAGE (This.Left, This.Top)-STEP(ImageWidth_Button - 1, This.Height - 1), ControlImage_Track, , (0, 1 * ImageHeight_Button - ImageHeight_Button)-STEP(ImageWidth_Button - 1, ImageHeight_Button - 1)
    ELSE
        _PUTIMAGE (This.Left, This.Top)-STEP(ImageWidth_Button - 1, This.Height - 1), ControlImage_Track, , (0, 4 * ImageHeight_Button - ImageHeight_Button)-STEP(ImageWidth_Button - 1, ImageHeight_Button - 1)
    END IF

    'Mousedown on the track:
    IF __UI_MouseDownOnID = This.ID AND This.HoveringVScrollbarButton = 4 AND __UI_DraggingThumb = __UI_False THEN
        'Above the thumb
        _PUTIMAGE (This.Left, This.Top)-STEP(ImageWidth_Button - 1, ThumbTop + ThumbHeight + __UI_ScrollbarButtonHeight - 1), ControlImage_Track, , (0, 3 * ImageHeight_Button - ImageHeight_Button)-STEP(ImageWidth_Button - 1, ImageHeight_Button - 1)
    ELSEIF __UI_MouseDownOnID = This.ID AND This.HoveringVScrollbarButton = 5 AND __UI_DraggingThumb = __UI_False THEN
        'Below the thumb
        _PUTIMAGE (This.Left, This.Top + ThumbTop + __UI_ScrollbarButtonHeight)-STEP(ImageWidth_Button - 1, This.Height - (This.Top + ThumbTop + __UI_ScrollbarButtonHeight) - 1), ControlImage_Track, , (0, 3 * ImageHeight_Button - ImageHeight_Button)-STEP(ImageWidth_Button - 1, ImageHeight_Button - 1)
    END IF

    'Draw buttons
    IF This.HoveringVScrollbarButton = 1 AND __UI_MouseDownOnID = This.ID THEN
        _PUTIMAGE (This.Left, This.Top)-STEP(ImageWidth_Button - 1, ImageHeight_Button - 1), ControlImage_Button, , (0, 3 * ImageHeight_Button - ImageHeight_Button)-STEP(ImageWidth_Button - 1, ImageHeight_Button - 1)
    ELSEIF This.HoveringVScrollbarButton = 1 THEN
        _PUTIMAGE (This.Left, This.Top)-STEP(ImageWidth_Button - 1, ImageHeight_Button - 1), ControlImage_Button, , (0, 2 * ImageHeight_Button - ImageHeight_Button)-STEP(ImageWidth_Button - 1, ImageHeight_Button - 1)
    ELSE
        _PUTIMAGE (This.Left, This.Top)-STEP(ImageWidth_Button - 1, ImageHeight_Button - 1), ControlImage_Button, , (0, 1 * ImageHeight_Button - ImageHeight_Button)-STEP(ImageWidth_Button - 1, ImageHeight_Button - 1)
    END IF

    IF This.HoveringVScrollbarButton = 2 AND __UI_MouseDownOnID = This.ID THEN
        _PUTIMAGE (This.Left, This.Top + This.Height - ImageHeight_Button - 1)-STEP(ImageWidth_Button - 1, ImageHeight_Button - 1), ControlImage_Button, , (0, 7 * ImageHeight_Button - ImageHeight_Button)-STEP(ImageWidth_Button - 1, ImageHeight_Button - 1)
    ELSEIF This.HoveringVScrollbarButton = 2 THEN
        _PUTIMAGE (This.Left, This.Top + This.Height - ImageHeight_Button - 1)-STEP(ImageWidth_Button - 1, ImageHeight_Button - 1), ControlImage_Button, , (0, 6 * ImageHeight_Button - ImageHeight_Button)-STEP(ImageWidth_Button - 1, ImageHeight_Button - 1)
    ELSE
        _PUTIMAGE (This.Left, This.Top + This.Height - ImageHeight_Button - 1)-STEP(ImageWidth_Button - 1, ImageHeight_Button - 1), ControlImage_Button, , (0, 5 * ImageHeight_Button - ImageHeight_Button)-STEP(ImageWidth_Button - 1, ImageHeight_Button - 1)
    END IF

    'Draw thumb
    IF __UI_DraggingThumb = __UI_True THEN
        _PUTIMAGE (This.Left + 1, ThumbTop + __UI_ScrollbarButtonHeight)-STEP(ImageWidth_Thumb - 2, ThumbHeight - 1), ControlImage_Thumb, , (0, 3 * ImageHeight_Thumb - ImageHeight_Thumb + 2)-STEP(ImageWidth_Thumb - 1, ImageHeight_Thumb - 5)
        _PUTIMAGE (This.Left + 1, ThumbTop + __UI_ScrollbarButtonHeight)-STEP(ImageWidth_Thumb - 2, 1), ControlImage_Thumb, , (0, 3 * ImageHeight_Thumb - ImageHeight_Thumb)-STEP(ImageWidth_Thumb - 1, 1)
        _PUTIMAGE (This.Left + 1, ThumbTop + __UI_ScrollbarButtonHeight + ThumbHeight - 2)-STEP(ImageWidth_Thumb - 2, 1), ControlImage_Thumb, , (0, 3 * ImageHeight_Thumb - 4)-STEP(ImageWidth_Thumb - 1, 3)
    ELSEIF This.HoveringVScrollbarButton = 3 AND __UI_DraggingThumb = __UI_False THEN
        _PUTIMAGE (This.Left + 1, ThumbTop + __UI_ScrollbarButtonHeight)-STEP(ImageWidth_Thumb - 2, ThumbHeight - 1), ControlImage_Thumb, , (0, 2 * ImageHeight_Thumb - ImageHeight_Thumb + 2)-STEP(ImageWidth_Thumb - 1, ImageHeight_Thumb - 5)
        _PUTIMAGE (This.Left + 1, ThumbTop + __UI_ScrollbarButtonHeight)-STEP(ImageWidth_Thumb - 2, 1), ControlImage_Thumb, , (0, 2 * ImageHeight_Thumb - ImageHeight_Thumb)-STEP(ImageWidth_Thumb - 1, 1)
        _PUTIMAGE (This.Left + 1, ThumbTop + __UI_ScrollbarButtonHeight + ThumbHeight - 2)-STEP(ImageWidth_Thumb - 2, 1), ControlImage_Thumb, , (0, 2 * ImageHeight_Thumb - 4)-STEP(ImageWidth_Thumb - 1, 3)
    ELSE
        _PUTIMAGE (This.Left + 1, ThumbTop + __UI_ScrollbarButtonHeight)-STEP(ImageWidth_Thumb - 2, ThumbHeight - 1), ControlImage_Thumb, , (0, 1 * ImageHeight_Thumb - ImageHeight_Thumb + 2)-STEP(ImageWidth_Thumb - 1, ImageHeight_Thumb - 5)
        _PUTIMAGE (This.Left + 1, ThumbTop + __UI_ScrollbarButtonHeight)-STEP(ImageWidth_Thumb - 2, 1), ControlImage_Thumb, , (0, 1 * ImageHeight_Thumb - ImageHeight_Thumb)-STEP(ImageWidth_Thumb - 1, 1)
        _PUTIMAGE (This.Left + 1, ThumbTop + __UI_ScrollbarButtonHeight + ThumbHeight - 2)-STEP(ImageWidth_Thumb - 2, 1), ControlImage_Thumb, , (0, 1 * ImageHeight_Thumb - 4)-STEP(ImageWidth_Thumb - 1, 3)
    END IF

    'Pass scrollbar parameters back to caller ID
    TempThis.VScrollbarButton2Top = This.Top + This.Height - ImageHeight_Button - 1
    TempThis.ThumbHeight = ThumbHeight
    TempThis.VScrollbarRatio = Ratio
END SUB

'---------------------------------------------------------------------------------
SUB __UI_DrawDropdownList (This AS __UI_ControlTYPE, ControlState)
    DIM PrevDest AS LONG
    DIM CaptionIndent AS INTEGER, TempCaption$

    STATIC ControlImage AS LONG, Initialized AS _BYTE
    STATIC ControlImage_Arrow AS LONG
    CONST ButtonHeight = 21
    CONST ButtonWidth = 18
    CONST ArrowWidth = 9
    CONST ArrowHeight = 9

    IF ControlImage = 0 OR ControlImage_Arrow = 0 THEN
        IF Initialized THEN ERROR 5: EXIT SUB
        Initialized = __UI_True

        ControlImage = _LOADIMAGE("xp.files\button.png", 32)
        IF ControlImage = -1 THEN ERROR 5: ControlImage = 0: EXIT SUB

        ControlImage_Arrow = _LOADIMAGE("xp.files\arrows.png", 32)
        IF ControlImage_Arrow = -1 THEN ERROR 5: ControlImage_Arrow = 0: EXIT SUB
        _SOURCE ControlImage_Arrow
        _CLEARCOLOR POINT(0, 0), ControlImage_Arrow
        _SOURCE 0
    END IF

    IF This.ControlState <> ControlState OR _
        This.FocusState <> (__UI_Focus = This.ID) OR _
        This.PreviousValue <> This.Value OR _
        __UI_Texts(This.ID) <> __UI_TempTexts(This.ID) OR _
        This.PreviousInputViewStart <> This.InputViewStart OR _
        This.PreviousParentID <> This.ParentID OR _
        __UI_ForceRedraw THEN
        'Last time this control was drawn it had a different state/caption, so it'll be redrawn
        This.ControlState = ControlState
        This.FocusState = __UI_Focus = This.ID
        This.PreviousValue = This.Value
        This.PreviousInputViewStart = This.InputViewStart
        __UI_TempTexts(This.ID) = __UI_Texts(This.ID)
        IF This.ParentID THEN __UI_Controls(This.ParentID).ChildrenRedrawn = __UI_True
        This.PreviousParentID = This.ParentID

        IF This.Canvas <> 0 THEN
            _FREEIMAGE This.Canvas
        END IF

        This.Canvas = _NEWIMAGE(This.Width, This.Height, 32)

        PrevDest = _DEST
        _DEST This.Canvas
        _FONT __UI_Fonts(This.Font)

        '------
        IF This.BackStyle = __UI_Opaque THEN
            _PRINTMODE _FILLBACKGROUND
            CLS , This.BackColor
        ELSE
            CLS , _RGBA32(0, 0, 0, 0)
            _PRINTMODE _KEEPBACKGROUND
        END IF

        CaptionIndent = 0
        IF This.HasBorder = __UI_True THEN
            CaptionIndent = 5
            LINE (0, 0)-STEP(This.Width - 1, This.Height - 1), This.BorderColor, B
        END IF

        DIM TempText$, ThisItem%, FindLF&, ThisItemTop%

        IF LEN(__UI_Texts(This.ID)) THEN
            TempText$ = __UI_Texts(This.ID)
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
                IF ThisItem% = This.Value THEN
                    ThisItemTop% = This.Height \ 2 - _FONTHEIGHT \ 2 + 1

                    IF ThisItem% = This.Value AND __UI_Focus = This.ID THEN __UI_SelectedText = TempCaption$

                    IF NOT This.Disabled THEN
                        COLOR This.ForeColor, This.BackColor
                    ELSE
                        COLOR __UI_Darken(__UI_Controls(__UI_FormID).BackColor, 80), This.BackColor
                    END IF

                    IF __UI_Focus = This.ID THEN
                        COLOR This.SelectedForeColor, This.SelectedBackColor
                        LINE (CaptionIndent, 3)-STEP(This.Width - CaptionIndent * 2, This.Height - 7), This.SelectedBackColor, BF
                    END IF

                    SELECT CASE This.Align
                        CASE __UI_Left
                            _PRINTSTRING (CaptionIndent * 2, ThisItemTop%), TempCaption$
                        CASE __UI_Center
                            _PRINTSTRING ((This.Width \ 2 - _PRINTWIDTH(TempCaption$) \ 2), ThisItemTop%), TempCaption$
                        CASE __UI_Right
                            _PRINTSTRING ((This.Width - _PRINTWIDTH(TempCaption$)) - CaptionIndent, ThisItemTop%), TempCaption$
                    END SELECT
                    EXIT DO
                END IF
            LOOP

            'Draw "dropdown" button
            DIM DropdownState AS _BYTE
            IF __UI_ActiveMenu > 0 AND __UI_ParentDropdownList = This.ID THEN
                DropdownState = 3
            ELSEIF (This.ID = __UI_HoveringID OR This.ID = __UI_ParentDropdownList) AND NOT This.Disabled THEN
                DropdownState = 2
            ELSEIF This.Disabled = __UI_True THEN
                DropdownState = 4
            ELSE
                DropdownState = 1
            END IF

            'Back surface
            _PUTIMAGE (This.Width - (__UI_ScrollbarWidth + 2), 3)-(This.Width - 1, This.Height - 4), ControlImage, , (3, DropdownState * ButtonHeight - ButtonHeight + 3)-STEP(11, ButtonHeight - 7)

            'Top and bottom edges
            _PUTIMAGE (This.Width - (__UI_ScrollbarWidth + 1), 0)-STEP(__UI_ScrollbarWidth - 2, 3), ControlImage, , (3, DropdownState * ButtonHeight - ButtonHeight)-STEP(11, 3)
            _PUTIMAGE (This.Width - (__UI_ScrollbarWidth + 1), This.Height - 3)-STEP(__UI_ScrollbarWidth - 2, 3), ControlImage, , (3, DropdownState * ButtonHeight - ButtonHeight + 18)-STEP(11, 3)

            'Left edges and corners:
            _PUTIMAGE (This.Width - (__UI_ScrollbarWidth + 2), 2)-STEP(2, This.Height - 4), ControlImage, , (0, DropdownState * ButtonHeight - ButtonHeight + 2)-STEP(2, ButtonHeight - 6)
            _PUTIMAGE (This.Width - (__UI_ScrollbarWidth + 2), 0), ControlImage, , (0, DropdownState * ButtonHeight - ButtonHeight)-STEP(2, 2)
            _PUTIMAGE (This.Width - (__UI_ScrollbarWidth + 2), This.Height - 3), ControlImage, , (0, DropdownState * ButtonHeight - 3)-STEP(2, 2)

            ''Right edges and corners:
            _PUTIMAGE (This.Width - 3, 2)-STEP(2, This.Height - 4), ControlImage, , (ButtonWidth - 3, DropdownState * ButtonHeight - ButtonHeight + 2)-STEP(2, ButtonHeight - 6)
            _PUTIMAGE (This.Width - 2, 0), ControlImage, , (ButtonWidth - 2, DropdownState * ButtonHeight - ButtonHeight)-STEP(2, 2)
            _PUTIMAGE (This.Width - 3, This.Height - 3), ControlImage, , (ButtonWidth - 3, DropdownState * ButtonHeight - 3)-STEP(2, 2)

            'Arrow
            _PUTIMAGE (This.Width - 1 - (__UI_ScrollbarWidth / 2) - ArrowWidth / 2, This.Height / 2 - ArrowHeight / 2), ControlImage_Arrow, , (0, (DropdownState + 4) * ArrowHeight - ArrowHeight)-STEP(ArrowWidth - 1, ArrowHeight - 1)
        END IF
        '------

        __UI_MakeHardwareImageFromCanvas This
        _DEST PrevDest
    END IF

    _PUTIMAGE (This.Left, This.Top), This.Canvas
END SUB

'---------------------------------------------------------------------------------
SUB __UI_DrawFrame (This AS __UI_ControlTYPE)
    DIM TempCaption$, CaptionIndent AS INTEGER
    DIM TempCanvas AS LONG, HWTempCanvas AS LONG

    STATIC ControlImage AS LONG, Initialized AS _BYTE

    IF ControlImage = 0 THEN
        IF Initialized THEN ERROR 5: EXIT SUB
        Initialized = __UI_True
        ControlImage = _LOADIMAGE("xp.files\frame.png", 32)
        IF ControlImage = -1 THEN ERROR 5: ControlImage = 0: EXIT SUB
        _SOURCE ControlImage
        _CLEARCOLOR POINT(0, 0), ControlImage
        _SOURCE 0
    END IF

    IF This.ChildrenRedrawn OR __UI_Captions(This.ID) <> __UI_TempCaptions(This.ID) OR This.HelperCanvas = 0 OR (__UI_IsDragging AND __UI_Controls(__UI_DraggingID).ParentID = This.ID) OR This.Value <> This.PreviousValue OR __UI_ForceRedraw THEN
        'Last time we drew this frame its children had different images
        This.ChildrenRedrawn = __UI_False
        This.PreviousValue = This.Value
        __UI_TempCaptions(This.ID) = __UI_Captions(This.ID)

        TempCanvas = _NEWIMAGE(This.Width, This.Height + _FONTHEIGHT(__UI_Fonts(This.Font)) \ 2, 32)

        _DEST TempCanvas
        _FONT __UI_Fonts(This.Font)

        '------
        TempCaption$ = " " + __UI_Captions(This.ID) + " "

        _FONT __UI_Fonts(This.Font)

        IF This.Hidden = __UI_False THEN
            IF This.BackStyle = __UI_Opaque THEN
                _PRINTMODE _FILLBACKGROUND
                CLS , This.BackColor
            ELSE
                CLS , _RGBA32(0, 0, 0, 0)
                _PRINTMODE _KEEPBACKGROUND
            END IF

            CaptionIndent = 0
            IF This.HasBorder THEN CaptionIndent = 5

            IF NOT This.Disabled THEN
                COLOR This.ForeColor, This.BackColor
            ELSE
                COLOR __UI_Darken(__UI_Controls(__UI_FormID).BackColor, 80), This.BackColor
            END IF

            'This.Canvas holds the children controls' images
            _PUTIMAGE (CaptionIndent, CaptionIndent + _FONTHEIGHT(__UI_Fonts(This.Font)) \ 2), This.Canvas, TempCanvas, (CaptionIndent, CaptionIndent)-(This.Width, This.Height)

            IF This.HasBorder THEN
                'LINE (0, _FONTHEIGHT(__UI_Fonts(This.Font)) \ 2)-STEP(This.Width - 1, This.Height - 1), This.BorderColor, B
                'Four corners;
                _PUTIMAGE (0, _FONTHEIGHT(__UI_Fonts(This.Font)) \ 2), ControlImage, , (0, 0)-STEP(2, 2)
                _PUTIMAGE (This.Width - 3, _FONTHEIGHT(__UI_Fonts(This.Font)) \ 2), ControlImage, , (19, 0)-STEP(2, 2)
                _PUTIMAGE (0, This.Height + _FONTHEIGHT(__UI_Fonts(This.Font)) \ 2 - 3), ControlImage, , (0, 17)-STEP(2, 2)
                _PUTIMAGE (This.Width - 3, This.Height + _FONTHEIGHT(__UI_Fonts(This.Font)) \ 2 - 3), ControlImage, , (19, 17)-STEP(2, 2)

                'Two vertical lines
                _PUTIMAGE (0, _FONTHEIGHT(__UI_Fonts(This.Font)) \ 2 + 2)-(0, This.Height + _FONTHEIGHT(__UI_Fonts(This.Font)) \ 2 - 4), ControlImage, , (0, 3)-(0, 16)
                _PUTIMAGE (This.Width - 1, _FONTHEIGHT(__UI_Fonts(This.Font)) \ 2 + 2)-(This.Width - 1, This.Height + _FONTHEIGHT(__UI_Fonts(This.Font)) \ 2 - 4), ControlImage, , (0, 3)-(0, 16)

                'Two horizontal lines
                _PUTIMAGE (3, _FONTHEIGHT(__UI_Fonts(This.Font)) \ 2)-STEP(This.Width - 6, 0), ControlImage, , (3, 0)-STEP(15, 0)
                _PUTIMAGE (3, This.Height + _FONTHEIGHT(__UI_Fonts(This.Font)) \ 2 - 1)-STEP(This.Width - 6, 0), ControlImage, , (3, 0)-STEP(15, 0)
            END IF

            DIM CaptionLeft AS INTEGER

            SELECT CASE This.Align
                CASE __UI_Left
                    CaptionLeft = CaptionIndent
                CASE __UI_Center
                    CaptionLeft = (This.Width \ 2 - _PRINTWIDTH(TempCaption$) \ 2)
                CASE __UI_Right
                    CaptionLeft = (This.Width - _PRINTWIDTH(TempCaption$)) - CaptionIndent
            END SELECT

            _PRINTSTRING (CaptionLeft, 0), TempCaption$

            'Hot key:
            IF This.HotKey > 0 AND __UI_ShowHotKeys AND NOT This.Disabled THEN
                LINE (CaptionLeft + _PRINTWIDTH(" ") + This.HotKeyOffset, 0 + _FONTHEIGHT)-STEP(_PRINTWIDTH(CHR$(This.HotKey)) - 1, 0), This.ForeColor
            END IF
        END IF
        '------

        IF This.HelperCanvas <> 0 THEN _FREEIMAGE This.HelperCanvas
        This.HelperCanvas = _COPYIMAGE(TempCanvas, 33)
        _FREEIMAGE TempCanvas
        _DEST 0
    END IF

    _PUTIMAGE (This.Left, This.Top - _FONTHEIGHT(__UI_Fonts(This.Font)) \ 2), This.HelperCanvas
END SUB

'---------------------------------------------------------------------------------
SUB __UI_DrawMenuBar (This AS __UI_ControlTYPE, ControlState AS _BYTE)
    DIM PrevDest AS LONG, CaptionIndent AS INTEGER, TempCaption$

    IF This.FocusState <> (__UI_Focus = This.ID) OR This.Value <> This.PreviousValue OR This.ControlState <> ControlState OR __UI_Captions(This.ID) <> __UI_TempCaptions(This.ID) OR __UI_ForceRedraw THEN
        'Last time this control was drawn it had a different state/caption, so it'll be redrawn
        This.ControlState = ControlState
        This.PreviousValue = This.Value

        IF __UI_Captions(This.ID) <> __UI_TempCaptions(This.ID) THEN
            __UI_RefreshMenuBar
        END IF

        __UI_TempCaptions(This.ID) = __UI_Captions(This.ID)
        This.FocusState = (__UI_Focus = This.ID)

        IF This.Canvas <> 0 THEN
            _FREEIMAGE This.Canvas
        END IF

        This.Canvas = _NEWIMAGE(This.Width, This.Height, 32)

        PrevDest = _DEST
        _DEST This.Canvas
        _FONT __UI_Fonts(This.Font)

        '---
        DIM ItemOffset%
        IF _PRINTWIDTH("W") <> _PRINTWIDTH("I") THEN ItemOffset% = _PRINTWIDTH("__") ELSE ItemOffset% = _PRINTWIDTH("__")

        CLS , This.BackColor
        _PRINTMODE _KEEPBACKGROUND

        DIM i AS INTEGER, c AS _UNSIGNED LONG
        TempCaption$ = __UI_Captions(This.ID)

        IF __UI_Focus = This.ID OR _
           (__UI_ParentMenu = This.ID AND (__UI_Controls(__UI_Focus).Type = __UI_Type_MenuPanel OR __UI_Controls(__UI_Focus).Type = __UI_Type_MenuItem)) OR _
           (__UI_HoveringID = This.ID AND (__UI_Controls(__UI_Focus).Type <> __UI_Type_MenuPanel AND __UI_Controls(__UI_Focus).Type <> __UI_Type_MenuBar AND __UI_Controls(__UI_Focus).Type <> __UI_Type_MenuItem)) THEN
            LINE (0, 0)-STEP(This.Width - 1, This.Height - 1), This.SelectedBackColor, BF
            c = This.SelectedForeColor
        ELSE
            c = This.ForeColor
        END IF

        IF This.Disabled THEN
            c = __UI_Darken(__UI_Controls(__UI_FormID).BackColor, 80)
        END IF

        COLOR c

        _PRINTSTRING (ItemOffset%, ((This.Height \ 2) - _FONTHEIGHT \ 2)), TempCaption$
        IF This.HotKey > 0 AND (__UI_AltIsDown OR __UI_Controls(__UI_Focus).Type = __UI_Type_MenuBar) THEN
            'Has "hot-key"
            LINE (ItemOffset% + This.HotKeyOffset, ((This.Height \ 2) + _FONTHEIGHT \ 2) - 1)-STEP(_PRINTWIDTH(CHR$(This.HotKey)) - 1, 0), c
        END IF
        '---

        __UI_MakeHardwareImageFromCanvas This
        _DEST PrevDest
    END IF

    _PUTIMAGE (This.Left, This.Top), This.Canvas
END SUB

'---------------------------------------------------------------------------------
SUB __UI_DrawMenuPanel (This AS __UI_ControlTYPE, ControlState AS _BYTE)
    DIM PrevDest AS LONG, CaptionIndent AS INTEGER, TempCaption$

    IF This.Value <> This.PreviousValue OR This.FocusState <> (__UI_Focus = This.ID) OR This.ControlState <> ControlState OR __UI_ForceRedraw THEN
        'Last time this control was drawn it had a different state/caption, so it'll be redrawn
        This.FocusState = (__UI_Focus = This.ID)
        This.ControlState = ControlState
        This.PreviousValue = This.Value

        IF This.Canvas <> 0 THEN
            _FREEIMAGE This.Canvas
        END IF

        This.Canvas = _NEWIMAGE(This.Width + 5, This.Height + 5, 32)

        PrevDest = _DEST
        _DEST This.Canvas
        _FONT __UI_Fonts(This.Font)

        '---
        DIM ItemOffset AS INTEGER
        IF _PRINTWIDTH("W") <> _PRINTWIDTH("I") THEN ItemOffset = _PRINTWIDTH("____") ELSE ItemOffset = _PRINTWIDTH("__")

        COLOR , _RGBA32(0, 0, 0, 0)
        CLS
        _PRINTMODE _KEEPBACKGROUND

        'White panel:
        __UI_ShadowBox 0, 0, This.Width - 1, This.Height - 1, _RGB32(255, 255, 255), 40, 5
        LINE (0, 0)-STEP(This.Width - 1, This.Height - 1), This.BorderColor, B

        DIM i AS LONG, c AS _UNSIGNED LONG
        FOR i = 1 TO UBOUND(__UI_Controls)
            IF __UI_Controls(i).Type = __UI_Type_MenuItem AND NOT __UI_Controls(i).Hidden AND __UI_Controls(i).ParentID = __UI_ParentMenu THEN
                TempCaption$ = __UI_Captions(i)

                IF __UI_Focus = i OR (__UI_HoveringID = i AND __UI_Focus = i) THEN
                    LINE (3, __UI_Controls(i).Top)-STEP(This.Width - 7, __UI_Controls(i).Height - 1), This.SelectedBackColor, BF
                    c = This.SelectedForeColor
                ELSE
                    c = This.ForeColor
                END IF

                IF __UI_Controls(i).Disabled THEN
                    c = __UI_Darken(__UI_Controls(__UI_FormID).BackColor, 80)
                END IF

                COLOR c

                _PRINTSTRING (__UI_Controls(i).Left + ItemOffset, __UI_Controls(i).Top + __UI_Controls(i).Height \ 2 - _FONTHEIGHT \ 2), TempCaption$

                IF __UI_Controls(i).HotKey > 0 THEN
                    'Has "hot-key"
                    LINE (__UI_Controls(i).Left + ItemOffset + __UI_Controls(i).HotKeyOffset, __UI_Controls(i).Top + __UI_Controls(i).Height \ 2 + _FONTHEIGHT \ 2 - 1)-STEP(_PRINTWIDTH(CHR$(__UI_Controls(i).HotKey)) - 1, 0), c
                END IF
            END IF
        NEXT
        '---

        __UI_MakeHardwareImageFromCanvas This
        _DEST PrevDest
    END IF

    _PUTIMAGE (This.Left, This.Top), This.Canvas
END SUB

'---------------------------------------------------------------------------------
SUB __ui_DrawPictureBox (This AS __UI_ControlTYPE, ControlState AS _BYTE)
    DIM PrevDest AS LONG
    DIM CaptionIndent AS INTEGER, TempCaption$

    IF This.Stretch <> This.PreviousStretch OR This.PreviousValue <> This.HelperCanvas OR This.ControlState <> ControlState OR This.PreviousParentID <> This.ParentID OR __UI_ForceRedraw THEN
        'Last time this control was drawn it had a different state/caption, so it'll be redrawn
        This.ControlState = ControlState
        IF This.ParentID THEN __UI_Controls(This.ParentID).ChildrenRedrawn = __UI_True
        This.PreviousParentID = This.ParentID
        This.PreviousValue = This.HelperCanvas
        This.PreviousStretch = This.Stretch

        IF This.Canvas <> 0 THEN
            _FREEIMAGE This.Canvas
        END IF

        This.Canvas = _NEWIMAGE(This.Width, This.Height, 32)

        PrevDest = _DEST
        _DEST This.Canvas
        '------
        IF This.BackStyle = __UI_Opaque THEN
            CLS , This.BackColor
        ELSE
            CLS , _RGBA32(0, 0, 0, 0)
        END IF

        IF This.Stretch THEN
            _PUTIMAGE (0, 0)-(This.Width - 1, This.Height - 1), This.HelperCanvas, This.Canvas
        ELSE
            _PUTIMAGE (0, 0), This.HelperCanvas, This.Canvas
        END IF

        IF This.HasBorder = __UI_True THEN
            LINE (0, 0)-STEP(This.Width - 1, This.Height - 1), This.BorderColor, B
        END IF
        '------

        __UI_MakeHardwareImageFromCanvas This
        _DEST PrevDest
    END IF

    _PUTIMAGE (This.Left, This.Top), This.Canvas
END SUB

'---------------------------------------------------------------------------------
SUB __UI_ShadowBox (b.X AS INTEGER, b.Y AS INTEGER, b.W AS INTEGER, b.H AS INTEGER, C AS LONG, shadow.Level AS INTEGER, shadow.Size AS INTEGER)
    DIM i AS INTEGER

    FOR i = 1 TO shadow.Size
        LINE (b.X + i, b.Y + i)-STEP(b.W, b.H), _RGBA32(0, 0, 0, shadow.Level - (shadow.Level / shadow.Size) * i), BF
    NEXT i

    LINE (b.X, b.Y)-STEP(b.W, b.H), C, BF
END SUB

