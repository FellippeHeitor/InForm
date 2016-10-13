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

TYPE __UI_Types
    Name AS STRING * 16
    Count AS LONG
END TYPE

TYPE __UI_ThemeImagesType
    FileName AS STRING * 32
    Handle AS LONG
END TYPE

REDIM SHARED __UI_Captions(1 TO 100) AS STRING
REDIM SHARED __UI_TempCaptions(1 TO 100) AS STRING
REDIM SHARED __UI_Texts(1 TO 100) AS STRING
REDIM SHARED __UI_TempTexts(1 TO 100) AS STRING
REDIM SHARED __UI_Controls(0 TO 100) AS __UI_ControlTYPE
REDIM SHARED __UI_ThemeImages(0 TO 100) AS __UI_ThemeImagesType

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
DIM SHARED __UI_Type(0 TO 15) AS __UI_Types
CONST __UI_Type_Form = 1: __UI_Type(1).Name = "Form"
CONST __UI_Type_Frame = 2: __UI_Type(2).Name = "Frame"
CONST __UI_Type_Button = 3: __UI_Type(3).Name = "Button"
CONST __UI_Type_Label = 4: __UI_Type(4).Name = "Label"
CONST __UI_Type_CheckBox = 5: __UI_Type(5).Name = "CheckBox"
CONST __UI_Type_RadioButton = 6: __UI_Type(6).Name = "RadioButton"
CONST __UI_Type_TextBox = 7: __UI_Type(7).Name = "TextBox"
CONST __UI_Type_ProgressBar = 8: __UI_Type(8).Name = "ProgressBar"
CONST __UI_Type_ListBox = 9: __UI_Type(9).Name = "ListBox"
CONST __UI_Type_DropdownList = 10: __UI_Type(10).Name = "DropdownList"
CONST __UI_Type_MenuBar = 11: __UI_Type(11).Name = "MenuBar"
CONST __UI_Type_MenuItem = 12: __UI_Type(12).Name = "MenuItem"
CONST __UI_Type_MenuPanel = 13: __UI_Type(13).Name = "MenuPanel"
CONST __UI_Type_PictureBox = 14: __UI_Type(14).Name = "PictureBox"
CONST __UI_Type_MultiLineTextBox = 15: __UI_Type(15).Name = "MultiLineTextBox"

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

NewID = __UI_NewControl(__UI_Type_PictureBox, "PictureBox1", 230, 150, 400, 215, 0)
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

    SELECT CASE UCASE$(RTRIM$(__UI_Controls(id).Name))
        CASE "STRETCHBT"
            __UI_Controls(__UI_GetID("PictureBox1")).Stretch = NOT __UI_Controls(__UI_GetID("PictureBox1")).Stretch
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
                FOR i = 1 TO UBOUND(__UI_Controls)
                    __UI_DestroyControl __UI_Controls(i)
                NEXT

                b$ = SPACE$(4): GET #1, , b$

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
                    IF __UI_Controls(i).Stretch THEN
                        PRINT #1, "__UI_Controls(__UI_NewID).Stretch = __UI_True"
                        b$ = MKI$(-4)
                        PUT #2, , b$
                    END IF
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
            Dummy = __UI_NewControl(__UI_Type_Button, "", 80, 23, 0, 0, 0)
            __UI_Controls(Dummy).CanDrag = __UI_True
            __UI_SetCaption __UI_Controls(Dummy).Name, RTRIM$(__UI_Controls(Dummy).Name)
        CASE "ADDLABEL"
            Dummy = __UI_NewControl(__UI_Type_Label, "", 80, 23, 0, 0, 0)
            __UI_Controls(Dummy).CanDrag = __UI_True
            __UI_SetCaption __UI_Controls(Dummy).Name, RTRIM$(__UI_Controls(Dummy).Name)
        CASE "ADDTEXTBOX"
            Dummy = __UI_NewControl(__UI_Type_TextBox, "", 120, 23, 0, 0, 0)
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
    'STATIC Pass AS LONG

    'DIM textboxID AS LONG
    'textboxID = __UI_GetID("TextBox1")
    '__UI_DefaultButtonID = __UI_GetID("okbutton")
    'IF LEN(__UI_Texts(textboxID)) > 0 THEN
    '    __UI_Controls(__UI_GetID("AddItemBT")).Disabled = __UI_False
    '    IF __UI_Focus = textboxID THEN __UI_DefaultButtonID = __UI_GetID("AddItemBT")
    'ELSE
    '    __UI_Controls(__UI_GetID("AddItemBT")).Disabled = __UI_True
    'END IF

    'IF __UI_Focus THEN
    '    __UI_SetCaption "FocusLabel", "Focus is on " + RTRIM$(__UI_Controls(__UI_Focus).Name)
    '    IF LEN(__UI_SelectedText) THEN
    '        __UI_SetCaption "FocusLabel", "Selected text: " + __UI_SelectedText
    '    END IF
    'ELSE
    '    __UI_SetCaption "FocusLabel", "No control has focus now"
    'END IF

    'IF __UI_HoveringID THEN
    '    __UI_SetCaption "HoverLabel", "(" + STR$(__UI_MouseTop) + "," + STR$(__UI_MouseLeft) + ") Hovering " + RTRIM$(__UI_Controls(__UI_HoveringID).Name) + " (" + RTRIM$(__UI_Type(__UI_Controls(__UI_HoveringID).Type).Name) + " count:" + STR$(__UI_Type(__UI_Controls(__UI_HoveringID).Type).Count) + ")"
    'END IF

    'IF __UI_IsDragging = __UI_False THEN
    '    IF __UI_Controls(__UI_Focus).Type = __UI_Type_TextBox THEN
    '        IF __UI_IsSelectingText THEN
    '            __UI_SetCaption "Label2", "Sel.Start=" + STR$(__UI_Controls(__UI_IsSelectingTextOnID).SelectionStart) + " Cursor=" + STR$(__UI_Controls(__UI_Focus).Cursor)
    '            __UI_SetCaption "HoverLabel", "Selected?" + STR$(__UI_Controls(__UI_IsSelectingTextOnID).TextIsSelected)
    '        ELSE
    '            __UI_SetCaption "Label2", "Editing text on " + RTRIM$(__UI_Controls(__UI_Focus).Name)
    '        END IF
    '    ELSE
    '        IF __UI_MouseIsDown AND __UI_MouseDownOnID > 0 THEN
    '            __UI_SetCaption "Label2", "MouseDownOnID=" + RTRIM$(__UI_Controls(__UI_MouseDownOnID).Name)
    '        ELSEIF __UI_MouseIsDown THEN
    '            __UI_SetCaption "Label2", "HoveringID <> ID originally clicked"
    '        ELSE
    '            __UI_SetCaption "Label2", "Idle."
    '        END IF
    '    END IF
    'ELSE
    '    __UI_SetCaption "Label2", "Dragging..." + STR$(__UI_PreviewLeft) + "," + STR$(__UI_PreviewTop)
    'END IF
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
                    __UI_DrawPictureBox __UI_Controls(i), ControlState
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
    IF __UI_LastHoveringID <> __UI_HoveringID OR __UI_HoveringID = __UI_ActiveDropdownList THEN
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
                    __UI_MouseDownOnID = 0
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

    IF ControlType = 0 THEN EXIT SUB

    IF ControlType = __UI_Type_Form THEN
        'Make sure only one Form exists, as it must be unique
        IF __UI_Type(__UI_Type_Form).Count > 0 THEN ERROR 5: EXIT FUNCTION
    END IF

    'Increase the global count of controls of this type
    __UI_Type(ControlType).Count = __UI_Type(ControlType).Count + 1
    IF ControlName = "" THEN ControlName = RTRIM$(__UI_Type(ControlType).Name) + LTRIM$(STR$(__UI_Type(ControlType).Count))

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
    IF This.ID > 0 THEN
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

        __UI_Type(This.Type).Count = __UI_Type(This.Type).Count - 1
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
        IF NotFoundImage = 0 THEN NotFoundImage = __UI_LoadThemeImage("notfound.png")

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
FUNCTION __UI_LoadThemeImage& (FileName$)
    'Contains portions of Dav's BIN2BAS
    'http://www.qbasicnews.com/dav/qb64.php

    DIM A$, i&, B$, C%, F$, C$, t%, B&, X$, btemp$, BASFILE$
    DIM MemoryBlock AS _MEM, TempImage AS LONG, NextSlot AS LONG
    DIM NewWidth AS INTEGER, NewHeight AS INTEGER

    'Check if this FileName$ has already been loaded
    FOR NextSlot = 1 TO UBOUND(__UI_ThemeImages)
        IF UCASE$(RTRIM$(__UI_ThemeImages(NextSlot).FileName)) = UCASE$(FileName$) THEN
            __UI_LoadThemeImage& = __UI_ThemeImages(NextSlot).Handle
            EXIT FUNCTION
        ELSEIF RTRIM$(__UI_ThemeImages(NextSlot).FileName) = "" THEN
            'Found an empty slot
        END IF
    NEXT

    A$ = __UI_ImageData$(FileName$)
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

    IF NextSlot > UBOUND(__UI_ThemeImages) THEN
        'No empty slots. We must increase __UI_ThemeImages()
        REDIM _PRESERVE __UI_ThemeImages(1 TO NextSlot + 99) AS __UI_ThemeImagesType
    END IF
    __UI_ThemeImages(NextSlot).FileName = FileName$
    __UI_ThemeImages(NextSlot).Handle = TempImage

    __UI_LoadThemeImage& = TempImage
END FUNCTION

'---------------------------------------------------------------------------------
FUNCTION __UI_ImageData$ (File$)
    'Data generated using Dav's BIN2BAS
    'http://www.qbasicnews.com/dav/qb64.php
    DIM A$

    SELECT CASE LCASE$(File$)
        CASE "frame.png"
            A$ = MKI$(22) + MKI$(20) 'Width, Height
            A$ = A$ + "o3`ooo?0ooOfEKmoIG]eoWMeFoOfEKmoIG]eoWMeFoOfEKmoIG]eoWMeFoOfEKmoIG]eoWMeFoOfEKmoIG]eoWMeFoOfEKmoIG]e"
            A$ = A$ + "ooKdAooo0looo3`ooo?0ooOfEKmoIG]eoo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0"
            A$ = A$ + "oooo0looo3`ooo?0oo?aC?moIG]eoo?0ooOfEKmoIG]eoo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo"
            A$ = A$ + "0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooGldCoOfEKmoIG]eoo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0loo"
            A$ = A$ + "o3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo6MdoWMeFooo0looo3`ooo?0oooo0looo3`o"
            A$ = A$ + "oo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooWMeFoOfEKmoo3`ooo?0"
            A$ = A$ + "oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0ooOf"
            A$ = A$ + "EKmoIG]eoo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0loo"
            A$ = A$ + "o3`ooo?0oooo0looIG]eoWMeFooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`o"
            A$ = A$ + "oo?0oooo0looo3`ooo?0oooo0looo3`ooWMeFoOfEKmoo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0"
            A$ = A$ + "oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0ooOfEKmoIG]eoo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo"
            A$ = A$ + "0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looIG]eoWMeFooo0looo3`ooo?0oooo0loo"
            A$ = A$ + "o3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooWMeFoOfEKmoo3`o"
            A$ = A$ + "oo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0"
            A$ = A$ + "ooOfEKmoIG]eoo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo"
            A$ = A$ + "0looo3`ooo?0oooo0looIG]eoWMeFooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0loo"
            A$ = A$ + "o3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooWMeFoOfEKmoo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`o"
            A$ = A$ + "oo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0ooOfEKmoIG]eoo?0oooo0looo3`ooo?0oooo0looo3`ooo?0"
            A$ = A$ + "oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looIG]eoWMeFooo0looo3`ooo?0oooo"
            A$ = A$ + "0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`oooKdAoOfEKmo"
            A$ = A$ + "IG]eoo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`o"
            A$ = A$ + "oGldCoOfEKmoo3`ooWMeFoOfEKmoo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0"
            A$ = A$ + "oooo0looo3`ooCldCoOfEKmoo3`ooo?0oooo0looIG]eoWMeFoOfEKmoIG]eoWMeFoOfEKmoIG]eoWMeFoOfEKmoIG]eoWMeFoOf"
            A$ = A$ + "EKmoIG]eoWMeFoOfEKmoIG]eoWMeFoo_A7moo3`ooo?0%oo?"
        CASE "arrows.png"
            A$ = MKI$(9) + MKI$(144)
            A$ = A$ + "o3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`oo?7IKmoo0looo3`ooo?0oooo0looo3`o"
            A$ = A$ + "oo?0oooo0loocAfFo?7IKmoLT]eoo3`ooo?0oooo0looo3`ooo?0oooLT]eocAfFo?7IKmoLT]eocAfFoo?0oooo0looo3`oo?7I"
            A$ = A$ + "KmoLT]eocAfFoo?0oooLT]eocAfFo?7IKmoo0loocAfFo?7IKmoLT]eoo3`ooo?0oooo0loocAfFo?7IKmoLT]eoo3`oo?7IKmoo"
            A$ = A$ + "0looo3`ooo?0oooo0looo3`oo?7IKmoo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0loo"
            A$ = A$ + "o3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`o"
            A$ = A$ + "oChN[moo0looo3`ooo?0oooo0looo3`ooo?0oooo0loo4^gJoChN[m?Qk]foo3`ooo?0oooo0looo3`ooo?0oo?Qk]fo4^gJoChN"
            A$ = A$ + "[m?Qk]fo4^gJoo?0oooo0looo3`ooChN[m?Qk]fo4^gJoo?0oo?Qk]fo4^gJoChN[moo0loo4^gJoChN[m?Qk]foo3`ooo?0oooo"
            A$ = A$ + "0loo4^gJoChN[m?Qk]foo3`ooChN[moo0looo3`ooo?0oooo0looo3`ooChN[moo0looo3`ooo?0oooo0looo3`ooo?0oooo0loo"
            A$ = A$ + "o3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`o"
            A$ = A$ + "oo?0oooo0looo3`ooo?0oooo0looo3`ooChN[moo0looo3`ooo?0oooo0looo3`ooo?0oooo0loo4^gJoChN[m?Qk]foo3`ooo?0"
            A$ = A$ + "oooo0looo3`ooo?0oo?Qk]fo4^gJoChN[m?Qk]fo4^gJoo?0oooo0looo3`ooChN[m?Qk]fo4^gJoo?0oo?Qk]fo4^gJoChN[moo"
            A$ = A$ + "0loo4^gJoChN[m?Qk]foo3`ooo?0oooo0loo4^gJoChN[m?Qk]foo3`ooChN[moo0looo3`ooo?0oooo0looo3`ooChN[moo0loo"
            A$ = A$ + "o3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`o"
            A$ = A$ + "oo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`oo?nbgnoo0looo3`ooo?0oooo0looo3`ooo?0"
            A$ = A$ + "oooo0looS_l]o?nbgnoh;Okoo3`ooo?0oooo0looo3`ooo?0oooh;OkoS_l]o?nbgnoh;OkoS_l]oo?0oooo0looo3`oo?nbgnoh"
            A$ = A$ + ";OkoS_l]oo?0oooh;OkoS_l]o?nbgnoo0looS_l]o?nbgnoh;Okoo3`ooo?0oooo0looS_l]o?nbgnoh;Okoo3`oo?nbgnoo0loo"
            A$ = A$ + "o3`ooo?0oooo0looo3`oo?nbgnoo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`o"
            A$ = A$ + "oo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0"
            A$ = A$ + "oooo0looo3`ooo?0oooo0looo3`oo?7IKmoo0looo3`ooo?0oooo0looo3`oo?7IKmoo0loocAfFo?7IKmoLT]eoo3`ooo?0oooo"
            A$ = A$ + "0loocAfFo?7IKmoLT]eoo3`oo?7IKmoLT]eocAfFoo?0oooLT]eocAfFo?7IKmoo0looo3`ooo?0oooLT]eocAfFo?7IKmoLT]eo"
            A$ = A$ + "cAfFoo?0oooo0looo3`ooo?0oooo0loocAfFo?7IKmoLT]eoo3`ooo?0oooo0looo3`ooo?0oooo0looo3`oo?7IKmoo0looo3`o"
            A$ = A$ + "oo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0"
            A$ = A$ + "oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooChN[moo0looo3`ooo?0oooo0looo3`ooChN[moo"
            A$ = A$ + "0loo4^gJoChN[m?Qk]foo3`ooo?0oooo0loo4^gJoChN[m?Qk]foo3`ooChN[m?Qk]fo4^gJoo?0oo?Qk]fo4^gJoChN[moo0loo"
            A$ = A$ + "o3`ooo?0oo?Qk]fo4^gJoChN[m?Qk]fo4^gJoo?0oooo0looo3`ooo?0oooo0loo4^gJoChN[m?Qk]foo3`ooo?0oooo0looo3`o"
            A$ = A$ + "oo?0oooo0looo3`ooChN[moo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0"
            A$ = A$ + "oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooChN[moo"
            A$ = A$ + "0looo3`ooo?0oooo0looo3`ooChN[moo0loo4^gJoChN[m?Qk]foo3`ooo?0oooo0loo4^gJoChN[m?Qk]foo3`ooChN[m?Qk]fo"
            A$ = A$ + "4^gJoo?0oo?Qk]fo4^gJoChN[moo0looo3`ooo?0oo?Qk]fo4^gJoChN[m?Qk]fo4^gJoo?0oooo0looo3`ooo?0oooo0loo4^gJ"
            A$ = A$ + "oChN[m?Qk]foo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooChN[moo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0"
            A$ = A$ + "oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo"
            A$ = A$ + "0looo3`ooo?0oooo0looo3`oo?nbgnoo0looo3`ooo?0oooo0looo3`oo?nbgnoo0looS_l]o?nbgnoh;Okoo3`ooo?0oooo0loo"
            A$ = A$ + "S_l]o?nbgnoh;Okoo3`oo?nbgnoh;OkoS_l]oo?0oooh;OkoS_l]o?nbgnoo0looo3`ooo?0oooh;OkoS_l]o?nbgnoh;OkoS_l]"
            A$ = A$ + "oo?0oooo0looo3`ooo?0oooo0looS_l]o?nbgnoh;Okoo3`ooo?0oooo0looo3`ooo?0oooo0looo3`oo?nbgnoo0looo3`ooo?0"
            A$ = A$ + "oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`oo?7IKmoo0looo3`ooo?0oooo"
            A$ = A$ + "0looo3`ooo?0oooo0loocAfFo?7IKmoLT]eoo3`ooo?0oooo0looo3`ooo?0oooLT]eocAfFo?7IKmoo0looo3`ooo?0oooo0loo"
            A$ = A$ + "o3`oo?7IKmoLT]eocAfFoo?0oooo0looo3`ooo?0oooo0loocAfFo?7IKmoLT]eoo3`ooo?0oooo0looo3`ooo?0oooo0looo3`o"
            A$ = A$ + "o?7IKmoLT]eocAfFoo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooLT]eocAfFo?7IKmoo0looo3`ooo?0oooo0looo3`ooo?0"
            A$ = A$ + "oooo0loocAfFo?7IKmoLT]eoo3`ooo?0oooo0looo3`ooo?0oooo0looo3`oo?7IKmoo0looo3`ooo?0oooo0looo3`ooo?0oooo"
            A$ = A$ + "0looo3`ooChN[moo0looo3`ooo?0oooo0looo3`ooo?0oooo0loo4^gJoChN[m?Qk]foo3`ooo?0oooo0looo3`ooo?0oo?Qk]fo"
            A$ = A$ + "4^gJoChN[moo0looo3`ooo?0oooo0looo3`ooChN[m?Qk]fo4^gJoo?0oooo0looo3`ooo?0oooo0loo4^gJoChN[m?Qk]foo3`o"
            A$ = A$ + "oo?0oooo0looo3`ooo?0oooo0looo3`ooChN[m?Qk]fo4^gJoo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oo?Qk]fo4^gJoChN"
            A$ = A$ + "[moo0looo3`ooo?0oooo0looo3`ooo?0oooo0loo4^gJoChN[m?Qk]foo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooChN[moo"
            A$ = A$ + "0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooChN[moo0looo3`ooo?0oooo0looo3`ooo?0oooo0loo4^gJoChN[m?Qk]fo"
            A$ = A$ + "o3`ooo?0oooo0looo3`ooo?0oo?Qk]fo4^gJoChN[moo0looo3`ooo?0oooo0looo3`ooChN[m?Qk]fo4^gJoo?0oooo0looo3`o"
            A$ = A$ + "oo?0oooo0loo4^gJoChN[m?Qk]foo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooChN[m?Qk]fo4^gJoo?0oooo0looo3`ooo?0"
            A$ = A$ + "oooo0looo3`ooo?0oo?Qk]fo4^gJoChN[moo0looo3`ooo?0oooo0looo3`ooo?0oooo0loo4^gJoChN[m?Qk]foo3`ooo?0oooo"
            A$ = A$ + "0looo3`ooo?0oooo0looo3`ooChN[moo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`oo?nbgnoo0looo3`ooo?0oooo0loo"
            A$ = A$ + "o3`ooo?0oooo0looS_l]o?nbgnoh;Okoo3`ooo?0oooo0looo3`ooo?0oooh;OkoS_l]o?nbgnoo0looo3`ooo?0oooo0looo3`o"
            A$ = A$ + "o?nbgnoh;OkoS_l]oo?0oooo0looo3`ooo?0oooo0looS_l]o?nbgnoh;Okoo3`ooo?0oooo0looo3`ooo?0oooo0looo3`oo?nb"
            A$ = A$ + "gnoh;OkoS_l]oo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooh;OkoS_l]o?nbgnoo0looo3`ooo?0oooo0looo3`ooo?0oooo"
            A$ = A$ + "0looS_l]o?nbgnoh;Okoo3`ooo?0oooo0looo3`ooo?0oooo0looo3`oo?nbgnoo0looo3`ooo?0oooo0looo3`ooo?0oooo0loo"
            A$ = A$ + "cAfFoo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooLT]eocAfFo?7IKmoo0looo3`ooo?0oooo0looo3`ooo?0oooo0loocAfF"
            A$ = A$ + "o?7IKmoLT]eoo3`ooo?0oooo0looo3`ooo?0oooo0looo3`oo?7IKmoLT]eocAfFoo?0oooo0looo3`ooo?0oooo0looo3`ooo?0"
            A$ = A$ + "oooLT]eocAfFo?7IKmoo0looo3`ooo?0oooo0looo3`oo?7IKmoLT]eocAfFoo?0oooo0looo3`ooo?0oooo0loocAfFo?7IKmoL"
            A$ = A$ + "T]eoo3`ooo?0oooo0looo3`ooo?0oooLT]eocAfFo?7IKmoo0looo3`ooo?0oooo0looo3`ooo?0oooo0loocAfFoo?0oooo0loo"
            A$ = A$ + "o3`ooo?0oooo0looo3`ooo?0oooo0loo4^gJoo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oo?Qk]fo4^gJoChN[moo0looo3`o"
            A$ = A$ + "oo?0oooo0looo3`ooo?0oooo0loo4^gJoChN[m?Qk]foo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooChN[m?Qk]fo4^gJoo?0"
            A$ = A$ + "oooo0looo3`ooo?0oooo0looo3`ooo?0oo?Qk]fo4^gJoChN[moo0looo3`ooo?0oooo0looo3`ooChN[m?Qk]fo4^gJoo?0oooo"
            A$ = A$ + "0looo3`ooo?0oooo0loo4^gJoChN[m?Qk]foo3`ooo?0oooo0looo3`ooo?0oo?Qk]fo4^gJoChN[moo0looo3`ooo?0oooo0loo"
            A$ = A$ + "o3`ooo?0oooo0loo4^gJoo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0loo4^gJoo?0oooo0looo3`ooo?0oooo0looo3`o"
            A$ = A$ + "oo?0oo?Qk]fo4^gJoChN[moo0looo3`ooo?0oooo0looo3`ooo?0oooo0loo4^gJoChN[m?Qk]foo3`ooo?0oooo0looo3`ooo?0"
            A$ = A$ + "oooo0looo3`ooChN[m?Qk]fo4^gJoo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oo?Qk]fo4^gJoChN[moo0looo3`ooo?0oooo"
            A$ = A$ + "0looo3`ooChN[m?Qk]fo4^gJoo?0oooo0looo3`ooo?0oooo0loo4^gJoChN[m?Qk]foo3`ooo?0oooo0looo3`ooo?0oo?Qk]fo"
            A$ = A$ + "4^gJoChN[moo0looo3`ooo?0oooo0looo3`ooo?0oooo0loo4^gJoo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looS_l]"
            A$ = A$ + "oo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooh;OkoS_l]o?nbgnoo0looo3`ooo?0oooo0looo3`ooo?0oooo0looS_l]o?nb"
            A$ = A$ + "gnoh;Okoo3`ooo?0oooo0looo3`ooo?0oooo0looo3`oo?nbgnoh;OkoS_l]oo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooh"
            A$ = A$ + ";OkoS_l]o?nbgnoo0looo3`ooo?0oooo0looo3`oo?nbgnoh;OkoS_l]oo?0oooo0looo3`ooo?0oooo0looS_l]o?nbgnoh;Oko"
            A$ = A$ + "o3`ooo?0oooo0looo3`ooo?0oooh;OkoS_l]o?nbgnoo0looo3`ooo?0oooo0looo3`ooo?0oooo0looS_l]oo?0oooo0looo3`o"
            A$ = A$ + "oo?0oooo0loo%%%0"
        CASE "scrolltrack.png"
            A$ = MKI$(17) + MKI$(68)
            A$ = A$ + "oW>foookTooo`Gnoo3OiooOlWooobWnooC?koo_m_ooog;oooS?mooOnfoooiKooo[omooonioookWooo_OnooOjHoooYSmooo>i"
            A$ = A$ + "oo?lUooo`Gnoo7oioo_lYooodcnooKokooombooohCoooW_mooOnfooojOooo_OnooonioookWoooW>fooOjHooo_Cnoo3Oioo?l"
            A$ = A$ + "UoooaOnoo;Ojoo?m\ooofonooO_loo?ndoooiKoooW_moo_ngoookWooo_OnooonioooYSmooW>foookTooo`Gnoo3OiooOlWooo"
            A$ = A$ + "bWnooC?koo_m_ooog;oooS?mooOnfoooiKooo[omooonioookWooo_OnooOjHoooYSmooo>ioo?lUooo`Gnoo7oioo_lYooodcno"
            A$ = A$ + "oKokooombooohCoooW_mooOnfooojOooo_OnooonioookWoooW>fooOjHooo_Cnoo3Oioo?lUoooaOnoo;Ojoo?m\ooofonooO_l"
            A$ = A$ + "oo?ndoooiKoooW_moo_ngoookWooo_OnooonioooYSmooW>foookTooo`Gnoo3OiooOlWooobWnooC?koo_m_ooog;oooS?mooOn"
            A$ = A$ + "foooiKooo[omooonioookWooo_OnooOjHoooYSmooo>ioo?lUooo`Gnoo7oioo_lYooodcnooKokooombooohCoooW_mooOnfooo"
            A$ = A$ + "jOooo_OnooonioookWoooW>fooOjHooo_Cnoo3Oioo?lUoooaOnoo;Ojoo?m\ooofonooO_loo?ndoooiKoooW_moo_ngoookWoo"
            A$ = A$ + "o_OnooonioooYSmooW>foookTooo`Gnoo3OiooOlWooobWnooC?koo_m_ooog;oooS?mooOnfoooiKooo[omooonioookWooo_On"
            A$ = A$ + "ooOjHoooYSmooo>ioo?lUooo`Gnoo7oioo_lYooodcnooKokooombooohCoooW_mooOnfooojOooo_OnooonioookWoooW>fooOj"
            A$ = A$ + "Hooo_Cnoo3Oioo?lUoooaOnoo;Ojoo?m\ooofonooO_loo?ndoooiKoooW_moo_ngoookWooo_OnooonioooYSmooW>foookTooo"
            A$ = A$ + "`Gnoo3OiooOlWooobWnooC?koo_m_ooog;oooS?mooOnfoooiKooo[omooonioookWooo_OnooOjHoooYSmooo>ioo?lUooo`Gno"
            A$ = A$ + "o7oioo_lYooodcnooKokooombooohCoooW_mooOnfooojOooo_OnooonioookWoooW>fooOjHooo_Cnoo3Oioo?lUoooaOnoo;Oj"
            A$ = A$ + "oo?m\ooofonooO_loo?ndoooiKoooW_moo_ngoookWooo_OnooonioooYSmooW>foookTooo`Gnoo3OiooOlWooobWnooC?koo_m"
            A$ = A$ + "_ooog;oooS?mooOnfoooiKooo[omooonioookWooo_OnooOjHoooYSmooo>ioo?lUooo`Gnoo7oioo_lYooodcnooKokooombooo"
            A$ = A$ + "hCoooW_mooOnfooojOooo_OnooonioookWoooW>fooOjHooo_Cnoo3Oioo?lUoooaOnoo;Ojoo?m\ooofonooO_loo?ndoooiKoo"
            A$ = A$ + "oW_moo_ngoookWooo_OnooonioooYSmooW>foookTooo`Gnoo3OiooOlWooobWnooC?koo_m_ooog;oooS?mooOnfoooiKooo[om"
            A$ = A$ + "ooonioookWooo_OnooOjHoooYSmooo>ioo?lUooo`Gnoo7oioo_lYooodcnooKokooombooohCoooW_mooOnfooojOooo_Onooon"
            A$ = A$ + "ioookWoooW>fooOjHooo_Cnoo3Oioo?lUoooaOnoo;Ojoo?m\ooofonooO_loo?ndoooiKoooW_moo_ngoookWooo_Onoooniooo"
            A$ = A$ + "YSmooW>foookTooo`Gnoo3OiooOlWooobWnooC?koo_m_ooog;oooS?mooOnfoooiKooo[omooonioookWooo_OnooOjHoooYSmo"
            A$ = A$ + "oo>ioo?lUooo`Gnoo7oioo_lYooodcnooKokooombooohCoooW_mooOnfooojOooo_OnooonioookWoooW>fooOjHooo_Cnoo3Oi"
            A$ = A$ + "oo?lUoooaOnoo;Ojoo?m\ooofonooO_loo?ndoooiKoooW_moo_ngoookWooo_OnooonioooYSmooW>foookTooo`Gnoo3OiooOl"
            A$ = A$ + "WooobWnooC?koo_m_ooog;oooS?mooOnfoooiKooo[omooonioookWooo_OnooOjHoooYSmooo>ioo?lUooo`Gnoo7oioo_lYooo"
            A$ = A$ + "dcnooKokooombooohCoooW_mooOnfooojOooo_OnooonioookWoooW>fooOjHooo_Cnoo3Oioo?lUoooaOnoo;Ojoo?m\ooofono"
            A$ = A$ + "oO_loo?ndoooiKoooW_moo_ngoookWooo_OnooonioooYSmooW>foookTooo`Gnoo3OiooOlWooobWnooC?koo_m_ooog;oooS?m"
            A$ = A$ + "ooOnfoooiKooo[omooonioookWooo_OnooOjHoooYSmooo>ioo?lUooo`Gnoo7oioo_lYooodcnooKokooombooohCoooW_mooOn"
            A$ = A$ + "fooojOooo_OnooonioookWoooW>fooOjHooo_Cnoo3Oioo?lUoooaOnoo;Ojoo?m\ooofonooO_loo?ndoooiKoooW_moo_ngooo"
            A$ = A$ + "kWooo_OnooonioooYSmooW>foookTooo`Gnoo3OiooOlWooobWnooC?koo_m_ooog;oooS?mooOnfoooiKooo[omooonioookWoo"
            A$ = A$ + "o_OnooOjHoooYSmooo>ioo?lUooo`Gnoo7oioo_lYooodcnooKokooombooohCoooW_mooOnfooojOooo_OnooonioookWoooW>f"
            A$ = A$ + "ooOjHooo_Cnoo3Oioo?lUoooaOnoo;Ojoo?m\ooofonooO_loo?ndoooiKoooW_moo_ngoookWooo_OnooonioooYSmooW>foook"
            A$ = A$ + "Tooo`Gnoo3OiooOlWooobWnooC?koo_m_ooog;oooS?mooOnfoooiKooo[omooonioookWooo_OnooOjHo?h8Ckob[]aoC?g8o?m"
            A$ = A$ + "LSloh3>coWOh=oooW?mooW>foookRoooaOnoo?_jooolZoooeknooO_looombooog;ooPS<]o3>bdn_lJKlodc=boC?g8o?nPclo"
            A$ = A$ + "i7NcoooiCoooYSmooo^hooOlWoooc[noo?_jooOm^ooog;oooO_looombo?h8CkoPS<]o;_f6o?mLSlodc=boS?h<oOnQglooOnd"
            A$ = A$ + "ooOjHooo_;noo7oiooolZoooc[nooG_kooombooog;oooO_lo3>bdn?h8Ckob[]aoC?g8o?mLSloh3>coWOh=oooW?mooW>foook"
            A$ = A$ + "RoooaOnoo?_jooolZoooeknooO_looombooog;ooPS<]o3>bdn_lJKlodc=boC?g8o?nPcloi7NcoooiCoooYSmooo^hooOlWooo"
            A$ = A$ + "c[noo?_jooOm^ooog;oooO_looombo?h8CkoPS<]o;_f6o?mLSlodc=boS?h<oOnQglooOndooOjHooo_;noo7oiooolZoooc[no"
            A$ = A$ + "oG_kooombooog;oooO_lo3>bdn?h8Ckob[]aoC?g8o?mLSloh3>coWOh=oooW?mooW>foookRoooaOnoo?_jooolZoooeknooO_l"
            A$ = A$ + "ooombooog;ooPS<]o3>bdn_lJKlodc=boC?g8o?nPcloi7NcoooiCoooYSmooo^hooOlWoooc[noo?_jooOm^ooog;oooO_looom"
            A$ = A$ + "bo?h8CkoPS<]o;_f6o?mLSlodc=boS?h<oOnQglooOndooOjHooo_;noo7oiooolZoooc[nooG_kooombooog;oooO_lo3>bdn?h"
            A$ = A$ + "8Ckob[]aoC?g8o?mLSloh3>coWOh=oooW?mooW>foookRoooaOnoo?_jooolZoooeknooO_looombooog;ooPS<]o3>bdn_lJKlo"
            A$ = A$ + "dc=boC?g8o?nPcloi7NcoooiCoooYSmooo^hooOlWoooc[noo?_jooOm^ooog;oooO_looombo?h8CkoPS<]o;_f6o?mLSlodc=b"
            A$ = A$ + "oS?h<oOnQglooOndooOjHooo_;noo7oiooolZoooc[nooG_kooombooog;oooO_lo3>bdn?h8Ckob[]aoC?g8o?mLSloh3>coWOh"
            A$ = A$ + "=oooW?mooW>foookRoooaOnoo?_jooolZoooeknooO_looombooog;ooPS<]o3>bdn_lJKlodc=boC?g8o?nPcloi7NcoooiCooo"
            A$ = A$ + "YSmooo^hooOlWoooc[noo?_jooOm^ooog;oooO_looombo?h8CkoPS<]o;_f6o?mLSlodc=boS?h<oOnQglooOndooOjHooo_;no"
            A$ = A$ + "o7oiooolZoooc[nooG_kooombooog;oooO_lo3>bdn?h8Ckob[]aoC?g8o?mLSloh3>coWOh=oooW?mooW>foookRoooaOnoo?_j"
            A$ = A$ + "ooolZoooeknooO_looombooog;ooPS<]o3>bdn_lJKlodc=boC?g8o?nPcloi7NcoooiCoooYSmooo^hooOlWoooc[noo?_jooOm"
            A$ = A$ + "^ooog;oooO_looombo?h8CkookNhooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_Onoooniooo"
            A$ = A$ + "kWooo_Onoo_kQooo^7noo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWoo"
            A$ = A$ + "okNhoo_kQoookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_Onoooniooo^7nookNh"
            A$ = A$ + "ooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_Onoo_kQooo^7noo_Onooon"
            A$ = A$ + "ioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWoookNhoo_kQoookWooo_Onoooniooo"
            A$ = A$ + "kWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_Onoooniooo^7nookNhooonioookWooo_OnooonioookWoo"
            A$ = A$ + "o_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_Onoo_kQooo^7noo_OnooonioookWooo_OnooonioookWooo_On"
            A$ = A$ + "ooonioookWooo_OnooonioookWooo_OnooonioookWoookNhoo_kQoookWooo_OnooonioookWooo_OnooonioookWooo_Onooon"
            A$ = A$ + "ioookWooo_OnooonioookWooo_Onoooniooo^7nookNhooonioookWooo_OnooonioookWooo_OnooonioookWooo_Onoooniooo"
            A$ = A$ + "kWooo_OnooonioookWooo_Onoo_kQooo^7noo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWoo"
            A$ = A$ + "o_OnooonioookWoookNhoo_kQoookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_On"
            A$ = A$ + "oooniooo^7nookNhooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_Onoo_k"
            A$ = A$ + "Qooo^7noo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWoookNhoo_kQooo"
            A$ = A$ + "kWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_Onoooniooo^7nookNhooonioookWoo"
            A$ = A$ + "o_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_Onoo_kQooo^7noo_OnooonioookWooo_On"
            A$ = A$ + "ooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWoookNh%%o3"
        CASE "scrollthumb.png"
            A$ = MKI$(15) + MKI$(88)
            A$ = A$ + "okNhooOoloO[E6hoC_kYo?m^WnodkNjoC_kYo3=^TnodkNjoC_kYo?m^WnodkNjoC_kYogJU1noo^7nookNho7KV5n_lJKlooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooooooooooo;_f6oO\IFhookNho7KV5noooooooO_loookRooo_;noocNgoooi"
            A$ = A$ + "CoomO_loaWMao_ndonOjAgkoZ;]_ooooooO\IFhookNho7KV5noooooooO_loookRooo_;noo_>gok_iBoomO_loaWMao_ndonOj"
            A$ = A$ + "AgkoZ;]_ooooooO\IFhookNho7KV5noooooooO_loookRooo_;noo_>gok_iBoomO_loaWMaoc>e0oOjAgkoZ;]_ooooooO\IFho"
            A$ = A$ + "okNho7KV5noooooooO_loookRooo_;noocNgoooiCo?nPcloaWMao_ndonOjAgkoZ;]_ooooooO\IFhookNho7KV5noooooooO_l"
            A$ = A$ + "oookRooo_;noo_>gok_iBo?nPcloaWMao_ndonOjAgkoZ;]_ooooooO\IFhookNho7KV5noooooooO_loookRooo_;noo_>gok_i"
            A$ = A$ + "Bo?nPcloaWMaoc>e0oOjAgkoZ;]_ooooooO\IFhookNho7KV5noooooooO_loookRooo_;noo_>gok_iBo?nPcloaWMao_ndonOj"
            A$ = A$ + "AgkoZ;]_ooooooO\IFhookNho7KV5noooooooO_loookRooo_;noo_>goooiCoomO_loaWMaoc>e0oOjAgkoZ;]_ooooooO\IFho"
            A$ = A$ + "okNho7KV5noooooooO_loookRooo_;noocNgoooiCoomO_loaWMao_ndonOjAgkoZ;]_ooooooO\IFhookNho7KV5noooooooO_l"
            A$ = A$ + "oookRooo_;noo_>gok_iBoomO_loaWMao_ndonOjAgkoZ;]_ooooooO\IFhookNho7KV5noooooooO_loookRooo_;noo_>gok_i"
            A$ = A$ + "BoomO_loaWMaoc>e0oOjAgkoZ;]_ooooooO\IFhookNho7KV5noooooooO_loookRooo_;noocNgoooiCo?nPcloaWMao_ndonOj"
            A$ = A$ + "AgkoZ;]_ooooooO\IFhookNho7KV5noooooooO_loookRooo_;noo_>gok_iBo?nPcloaWMao_ndonOjAgkoZ;]_ooooooO\IFho"
            A$ = A$ + "okNho7KV5noooooooO_loookRooo_;noo_>gok_iBo?nPcloaWMaoc>e0oOjAgkoZ;]_ooooooO\IFhookNho7KV5noooooooO_l"
            A$ = A$ + "oookRooo_;noo_>gok_iBo?nPcloaWMao_ndonOjAgkoZ;]_ooooooO\IFhookNho7KV5noooooooO_loookRooo_;noo_>goooi"
            A$ = A$ + "CoomO_loaWMaoc>e0oOjAgkoZ;]_ooooooO\IFhookNho7KV5noooooooO_loookRooo_;noo_>gok_iBoomO_loaWMao_ndonOj"
            A$ = A$ + "AgkoZ;]_ooooooO\IFhookNho7KV5noooooooO_loookRooo_;noo_>goooiCo?nPcloaWMao_ndonOjAgkoZ;]_ooooooO\IFho"
            A$ = A$ + "okNho7KV5nOnQglo]GM`ogNe1oOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1oOkE7lo]GM`oWOh=oO\IFhookNhoo?lUo?Z@bgoj:ZS"
            A$ = A$ + "o[[X>n_^Rjhoj:ZSo[[X>n_^Rjhoj:ZSo[[X>n_^Rjhok>jSo_jTomoo^7nooo>ioomacn_OV9eonIVDokWIBm_OV9eonIVDokWI"
            A$ = A$ + "Bm_OV9eonIVDokWIBm_OV9eonIVDokWIBmog7?kooo>iokWIBm_lJKlooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooo;_f6o_OV9eooo>iokWIBmoooooook_ooo_m_ooobWnooo^hoo?jGoOnQglo`S=ao[^dnnoi?_koY7M_oooooo_OV9eo"
            A$ = A$ + "oo>iokWIBmoooooook_ooo_m_ooobWnooo^hoooiEo?nPclo`S=ao[^dnnoi?_koY7M_oooooo_OV9eooo>iokWIBmoooooook_o"
            A$ = A$ + "oo_m_ooobWnooo^hoo?jGo?nPclo`S=ao[^dnnoi?_koY7M_oooooo_OV9eooo>iokWIBmoooooook_ooo_m_ooobWnooo^hoo?j"
            A$ = A$ + "GoOnQgloaWMao[^dnnoi?_koY7M_oooooo_OV9eooo>iokWIBmoooooook_ooo_m_ooobWnooo^hoooiEoOnQglo`S=ao[^dnnoi"
            A$ = A$ + "?_koY7M_oooooo_OV9eooo>iokWIBmoooooook_oooOm^ooobWnooo^hoooiEoOnQglo`S=aoWNdmnoi?_koY7M_oooooo_OV9eo"
            A$ = A$ + "oo>iokWIBmoooooook_oooOm^ooobWnooo>ioo?jGoOnQglo`S=aoWNdmnoi?_koY7M_oooooo_OV9eooo>iokWIBmoooooook_o"
            A$ = A$ + "ooOm^ooobWnooo^hoooiEo?nPclo`S=ao[^dnnoi?_koY7M_oooooo_OV9eooo>iokWIBmoooooook_oooOm^ooobWnooo^hoo?j"
            A$ = A$ + "Go?nPclo`S=aoWNdmnoi?_koY7M_oooooo_OV9eooo>iokWIBmoooooook_oooOm^ooobWnooo>ioo?jGo?nPclo`S=ao[^dnnoi"
            A$ = A$ + "?_koY7M_oooooo_OV9eooo>iokWIBmoooooook_ooo_m_ooobWnooo^hoo?jGo?nPclo`S=ao[^dnnoi?_koY7M_oooooo_OV9eo"
            A$ = A$ + "oo>iokWIBmoooooook_ooo_m_ooobWnooo^hoo?jGoOnQgloaWMao[^dnnoi?_koY7M_oooooo_OV9eooo>iokWIBmoooooook_o"
            A$ = A$ + "oo_m_ooobWnooo^hoooiEoOnQglo`S=ao[^dnnoi?_koY7M_oooooo_OV9eooo>iokWIBmoooooook_ooo_m_ooobWnooo^hoooi"
            A$ = A$ + "EoOnQglo`S=aoWNdmnoi?_koY7M_oooooo_OV9eooo>iokWIBmoooooook_ooo_m_ooobWnooo>ioo?jGoOnQglo`S=aoWNdmnoi"
            A$ = A$ + "?_koY7M_oooooo_OV9eooo>iokWIBmoooooook_oooOm^ooobWnooo^hoooiEo?nPclo`S=ao[^dnnoi?_koY7M_oooooo_OV9eo"
            A$ = A$ + "oo>iokWIBmoooooook_ooo_m_ooobWnooo^hoo?jGo?nPclo`S=aoWNdmnoi?_koY7M_oooooo_OV9eooo>iokWIBmoooooook_o"
            A$ = A$ + "oo_m_ooobWnooo>ioo?jGo?nPclo`S=ao[^dnnoi?_koY7M_oooooo_OV9eooo>iokWIBmomO_lo`S=ao3?f4o?lHClo`S=ao3?f"
            A$ = A$ + "4o?lHClo`S=ao3?f4o?lHClo`S=aoOog;o_OV9eooo>ioomacn_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBm_O"
            A$ = A$ + "V9eonIVDokWIBmog7?kookNhooOolo_H:IcoRYT=o;VBfl_H:IcoRYT=o;VBfl_H:IcoRYT=o;VBfl_H:IcoRYT=o;VBfloo^7no"
            A$ = A$ + "okNho;VBfl?mLSlooooooooooooooooooooooooooooooooooooooooooooooooooooooC?g8o_H:IcookNho;VBflooooooS_l]"
            A$ = A$ + "oS>dlnOjAgko`S=aoc?i@ooo]omoo;Ojooomaoool_oooooooooooo_H:IcookNho;VBflooooooS_l]oS>dlnOjAgko`S=ao_oh"
            A$ = A$ + "?ooo]omoo;Ojooombooomcoooooooooooo_H:IcookNho;VBflooooooS_l]oS>dlnOjAgko`S=aoc?i@ooo]omoo;Ojooomaooo"
            A$ = A$ + "mcoooooooooooo_H:IcookNho;VBflooooooS_l]oS>dln?j@ckoaWMaoc?i@ooo]omoo;Ojooombooomcoooooooooooo_H:Ico"
            A$ = A$ + "okNho;VBflooooooS_l]oS>dlnOjAgkoaWMaoc?i@ooo]omoo;Ojooomaooomcoooooooooooo_H:IcookNho;VBflooooooS_l]"
            A$ = A$ + "oS>dln?j@cko`S=aoc?i@ooo]omoo;Ojooomaooomcoooooooooooo_H:IcookNho;VBflooooooS_l]oS>dln?j@cko`S=aoc?i"
            A$ = A$ + "@ooo^7noo;Ojooomaooomcoooooooooooo_H:IcookNho;VBflooooooS_l]oS>dlnOjAgko`S=ao_oh?ooo]omoo;Ojooomaooo"
            A$ = A$ + "mcoooooooooooo_H:IcookNho;VBflooooooS_l]oS>dln?j@cko`S=aoc?i@ooo]omoo;Ojooomaooomcoooooooooooo_H:Ico"
            A$ = A$ + "okNho;VBflooooooS_l]oS>dlnOjAgko`S=aoc?i@ooo^7noo;Ojooomaooomcoooooooooooo_H:IcookNho;VBflooooooS_l]"
            A$ = A$ + "oS>dlnOjAgko`S=aoc?i@ooo]omoo;Ojooombooomcoooooooooooo_H:IcookNho;VBflooooooS_l]oS>dln?j@ckoaWMaoc?i"
            A$ = A$ + "@ooo]omoo;Ojooomaooomcoooooooooooo_H:IcookNho;VBflooooooS_l]oS>dlnOjAgkoaWMaoc?i@ooo]omoo;Ojooomaooo"
            A$ = A$ + "mcoooooooooooo_H:IcookNho;VBflooooooS_l]oS>dln?j@cko`S=aoc?i@ooo]omoo;Ojooomaooomcoooooooooooo_H:Ico"
            A$ = A$ + "okNho;VBflooooooS_l]oS>dln?j@cko`S=aoc?i@ooo^7noo;Ojooomaooomcoooooooooooo_H:IcookNho;VBflooooooS_l]"
            A$ = A$ + "oS>dlnOjAgko`S=ao_oh?ooo]omoo;Ojooomaooomcoooooooooooo_H:IcookNho;VBflooooooS_l]oS>dln?j@cko`S=aoc?i"
            A$ = A$ + "@ooo]omoo;Ojooomaooomcoooooooooooo_H:IcookNho;VBfl?cd2joS_l]oS>dlnOjAgko`S=aoc?i@ooo^7noo;Ojooomaooo"
            A$ = A$ + "mcoooooooc<]Pn_H:IcookNho;VBfl_H:Ico<C;Xoc<]Pn?cd2jo<C;Xoc<]Pn?cd2jo<C;Xoc<]Pn?cd2jo<C;Xo;VBfl_H:Ico"
            A$ = A$ + "okNhoo_jJo_H:IcoRYT=o;VBfl_H:IcoRYT=o;VBfl_H:IcoRYT=o;VBfl_H:IcoRYT=o;VBflooZ[moogngoooniooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooo\gmoogngoooooooog7ooo7oioo_kQooo\gmoo[^fooOj"
            A$ = A$ + "HoooWGmooONeok_iBo?oT3moo?_jooooooooXOmoogngooooooooaOnooOOlooOm^oooc[noo;OjooOlWoooaOnoo7oioo_kQooo"
            A$ = A$ + "[cmonK^doooooo_lJKloogngoooooo_oV;mooo>ioo?lUooo`Gnooo>ioookTooo^7noo_>gooOjHoooYSmonK^doooooo_h:Kko"
            A$ = A$ + "ogngooooooooWGmoo3OiooOlWooo`Gnooo>ioo_kQooo]omoo_>goo_jJoooZ[mooOndoooooo_h:KkoogngooooooooW?moo3Oi"
            A$ = A$ + "oo?lUooo`Gnooo>ioo_kQooo^7noo_>goo_jJoooYSmonK^doooooo_h:Kkoogngoooooo_oV;mooo>ioo?lUooo`Gnooo>ioook"
            A$ = A$ + "Tooo^7noo_>gooOjHoooYSmonK^doooooo_h:KkoogngooooooooWGmoo3OiooOlWooo`Gnooo>ioo_kQooo]omoo_>goo_jJooo"
            A$ = A$ + "Z[mooOndoooooo_h:KkoogngooooooooW?moo3Oioo?lUooo`Gnooo>ioo_kQooo^7noo_>goo_jJoooYSmonK^doooooo_h:Kko"
            A$ = A$ + "ogngoooooo_oV;mooo>ioo?lUooo`Gnooo>ioookTooo^7noo_>gooOjHoooYSmonK^doooooo_h:KkoogngooooooooWGmoo3Oi"
            A$ = A$ + "ooOlWooo`Gnooo>ioo_kQooo]omoo_>goo_jJoooZ[mooOndoooooo_h:KkoogngooooooooW?moo3Oioo?lUooo`Gnooo>ioo_k"
            A$ = A$ + "Qooo^7noo_>goo_jJoooYSmonK^doooooo_h:Kkoogngoooooo_oV;mooo>ioo?lUooo`Gnooo>ioookTooo^7noo_>gooOjHooo"
            A$ = A$ + "YSmonK^doooooo_h:KkoogngooooooooWGmoo3OiooOlWooo`Gnooo>ioo_kQooo]omoo_>goo_jJoooZ[mooOndoooooo_h:Kko"
            A$ = A$ + "ogngooooooooWGmoo3Oioo?lUooo`Gnooo>ioo_kQooo^7noo_>goo_jJoooYSmonK^doooooo_h:KkoogngooooooooWGmooo>i"
            A$ = A$ + "oo?lUooo`Gnooo>ioookTooo^7noo_>gooOjHoooYSmonK^doooooo_h:KkoogngooooooooYSmoo3OiooOlWooo`Gnooo>ioo_k"
            A$ = A$ + "Qooo]omoo_>goo_jJoooZ[mooOndoooooo_h:KkoogngooooooooZ[moo3Oioo?lUooo`Gnooo>ioo_kQooo^7noo_>goo_jJooo"
            A$ = A$ + "YSmonK^doooooo_h:KkoogngooooooooZ[mooo>ioo?lUooo`Gnooo>ioookTooo^7noo_>gooOjHoooYSmonK^doooooo_h:Kko"
            A$ = A$ + "ogngoooooooobWnomGNdok_iBo_oV;monK^dok_iBo_oV;monK^dogOiAoonSoloo7oiooooooojCokoogngoOncknoooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooooooooooo3?f4ooo\gmoogngooolZooh;OkoK?l[o[]`^nOf1gjoI7L[oWM`"
            A$ = A$ + "]n_f2kjoJ;\[o_m`_nOg57koVk\^ooOm^ooo\gmo%%%0"
        CASE "scrollbuttons.png"
            A$ = MKI$(17) + MKI$(136)
            A$ = A$ + "okNhoC?g8o?[D2hoAWKYo3=^Tn?dhBjo@S;Yo3=^Tn?dhBjo@S;Yo3=^Tn?dhBjo@S;Yo3=^Tnocg>joY6IOoC?g8ooo^7noaVIQ"
            A$ = A$ + "o;_f6ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo_lJKloaVIQoo_kQoO\IFhooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooO\IFhookNho7KV5noooooooconoo?okooo"
            A$ = A$ + "l_oooconoo?okoool_oooconoo?okoool_oooconoo?okoool_ooooooo7KV5noo^7noaVIQooooooooeknooG_kooOm^oooekno"
            A$ = A$ + "oG_kooOm^oooeknooG_kooOm^oooeknooG_kooOm^oooooooaVIQoo_kQoO\IFhooooooookRooo_;nooo^hoookRooo_;nocAfF"
            A$ = A$ + "oookRooo_;nooo^hoookRooo_;nooo^hooooooO\IFhookNho7KV5noooooooOndoooiCoooW?mooOndo?7IKmoLT]eocAfFoooi"
            A$ = A$ + "CoooW?mooOndoooiCoooW?moooooo7KV5noo^7noaVIQoooooo_mN[lofk]boK_g:ooLT]eocAfFo?7IKmoLT]eocAfFoK_g:o_m"
            A$ = A$ + "N[lofk]boK_g:oooooooaVIQoo_kQoO\IFhooooook^e2o_kF;locAfFo?7IKmoLT]eo^K]`o?7IKmoLT]eocAfFok^e2o_kF;lo"
            A$ = A$ + "^K]`ooooooO\IFhookNho7KV5nooooooY7M_o?7IKmoLT]eocAfFoWNdmnOjAgkoY7M_o?7IKmoLT]eocAfFoWNdmnOjAgkooooo"
            A$ = A$ + "o7KV5noo^7noaVIQoooooo?j@ckoX3=_o?7IKm?j@ckoX3=_oS>dln?j@ckoX3=_o?7IKm?j@ckoX3=_oS>dlnooooooaVIQoo_k"
            A$ = A$ + "QoO\IFhooooooS>dln?j@ckoX3=_oS>dln?j@ckoX3=_oS>dln?j@ckoX3=_oS>dln?j@ckoX3=_ooooooO\IFhookNho7KV5noo"
            A$ = A$ + "ooooX3=_oS>dln?j@ckoX3=_oS>dln?j@ckoX3=_oS>dln?j@ckoX3=_oS>dln?j@ckoooooo7KV5noo^7noaVIQoooooo?j@cko"
            A$ = A$ + "X3=_oS>dln?j@ckoX3=_oS>dln?j@ckoX3=_oS>dln?j@ckoX3=_oS>dlnooooooaVIQoo_kQoO\IFhooooooS>dln?j@ckoX3=_"
            A$ = A$ + "oS>dln?j@ckoX3=_oS>dln?j@ckoX3=_oS>dln?j@ckoX3=_ooooooO\IFhookNho7KV5nOnQglofk]boK_g:o_mN[lofk]boK_g"
            A$ = A$ + ":o_mN[lofk]boK_g:o_mN[lofk]boK_g:o_mN[loi7Nco7KV5noo^7nooo^hoS:Tlm_^Rjhoj:ZSo[[X>n_^Rjhoj:ZSo[[X>n_^"
            A$ = A$ + "Rjhoj:ZSo[[X>n_^Rjhoj:ZSo[[X>noY?^gooSneoo_kQo?mLSlonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eo"
            A$ = A$ + "nIVDokWIBm_OV9eonIVDokWIBm?mLSlookNhokWIBm_lJKlooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooob[]aokWIBmoo^7nonIVDoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooonIVDoo_kQo_OV9eooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo_O"
            A$ = A$ + "V9eookNhokWIBmoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooookWIBmoo^7no"
            A$ = A$ + "nIVDoooooooooooooooooooooooooooooooooChN[moooooooooooooooooooooooooooooooooooooonIVDoo_kQo_OV9eooooo"
            A$ = A$ + "ooonioookWooo_Onooonio?Qk]fo4^gJoChN[mookWooo_OnooonioookWooo_Onoooooo_OV9eookNhokWIBmooooooo7oiooOl"
            A$ = A$ + "WoooaOno4^gJoChN[m?Qk]fo4^gJoChN[mooaOnoo7oiooOlWoooaOnooooookWIBmoo^7nonIVDooooooooW?mooOndoChN[m?Q"
            A$ = A$ + "k]fo4^gJoooiCo?Qk]fo4^gJoChN[mooW?mooOndoooiCooooooonIVDoo_kQo_OV9eooooooGOg9o?Qk]fo4^gJoChN[mOmMWlo"
            A$ = A$ + "egMboGOg9o?Qk]fo4^gJoChN[mOmMWloegMboooooo_OV9eookNhokWIBmoooooo_Om`oone3o?Qk]fo_Om`oone3ookG?lo_Om`"
            A$ = A$ + "oone3o?Qk]fo_Om`oone3ookG?looooookWIBmoo^7nonIVDooooooOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe"
            A$ = A$ + "1oOkE7lo]GM`ogNe1ooooooonIVDoo_kQo_OV9eoooooogNe1oOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1oOk"
            A$ = A$ + "E7lo]GM`oooooo_OV9eookNhokWIBmoooooo]GM`ogNe1oOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1oOkE7lo"
            A$ = A$ + "oooookWIBmoo^7nonIVDooooooOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1ooooooonIVD"
            A$ = A$ + "oo_kQo_OV9eoi7NcoK_g:o_mN[lofk]boK_g:o_mN[lofk]boK_g:o_mN[lofk]boK_g:o_mN[lofk]boWOh=o_OV9eookNhoook"
            A$ = A$ + "Ro_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDoo?jGooo^7noX3=_okWIBm_O"
            A$ = A$ + "V9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eoI7L[oo_kQo_OV9eodc=booombooog;oo"
            A$ = A$ + "oO_looombooog;oooO_looombooog;oooO_looombooog;oooO_loC?g8o_OV9eookNhokWIBmooooooOOl\oomacnog7?koOOl\"
            A$ = A$ + "oomacnog7?koOOl\oomacnog7?koOOl\oomacnog7?kooooookWIBmoo^7nonIVDoooooookG?lo_Om`oone3ookG?lo_Om`oone"
            A$ = A$ + "3ookG?lo_Om`oone3ookG?lo_Om`oone3ooooooonIVDoo_kQo_OV9eooooook_iBo_nRkloj;^co[_h>o_nRkloj;^co_oh?oon"
            A$ = A$ + "Solok?ncok_iBo_oV;monK^doooooo_OV9eookNhokWIBmooooooo;Ojoo_kQooo^7nookNhoo_kQo?Qk]fooo^hoookRooo`Gno"
            A$ = A$ + "o;Ojoo_lYooobWnooooookWIBmoo^7nonIVDooooooooooooog?oooOolooomcoo4^gJoChN[m?Qk]fook_ooo_onooonkoooooo"
            A$ = A$ + "oooooooooooonIVDoo_kQo_OV9eooooooooooooooooooooooChN[m?Qk]fo4^gJoChN[m?Qk]fooooooooooooooooooooooooo"
            A$ = A$ + "oo_OV9eookNhokWIBmoooooooooooooooo?Qk]fo4^gJoChN[moooooo4^gJoChN[m?Qk]fooooooooooooooooooooookWIBmoo"
            A$ = A$ + "^7nonIVDoooooooooooo4^gJoChN[m?Qk]fooooooooooooooooo4^gJoChN[m?Qk]fooooooooooooooooonIVDoo_kQo_OV9eo"
            A$ = A$ + "oooooooooooooooo4^gJoooooooooooooooooooooooooooo4^gJoooooooooooooooooooooo_OV9eookNhokWIBmoooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooookWIBmoo^7nonIVDoooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooonIVDoo_kQo_OV9eooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooo_OV9eookNhokWIBm?cd2jooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooo<C;XokWIBmoo^7nonIVDokWIBm?cd2jo<C;Xoc<]Pn?cd2jo<C;Xoc<]Pn?cd2jo<C;X"
            A$ = A$ + "oc<]Pn?cd2jo<C;Xoc<]Pn_OV9eonIVDoo_kQo?f0cjonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWI"
            A$ = A$ + "Bm_OV9eonIVDokWIBm_djJjookNhoo?okooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooOkOooo^7noooooooomboooaOnooo^hooOkOooo\gmoo_>gooOjHoooYSmooSneoo?jGoooWGmonK^dooolZooooooo"
            A$ = A$ + "oOndoo_kQoooooooo7oiooombooofonoo?_joo_lYoooaOnoo7oiooOlWooo`Gnooo>ioookRooo]omooONeooooooOnQglookNh"
            A$ = A$ + "oooooooo_;nooKokooOm^ooobWnoo7oiooOlWooo`Gnooo>ioookTooo_;nookNhooOkOoooWGmoooooo7Of5ooo^7noooooooOk"
            A$ = A$ + "Ooooc[noo;OjooOlWooo`Gnoo3Oioo?lUooo^7noogngooOkOooo]omoogngoo?jGooooooo\C=`oo_kQoooooooo_>gooOlWooo"
            A$ = A$ + "aOnoo7oioo?lUooo`GnoS_l]ooOkOooo]omoogngooOkOooo]omooSneoooooo?j@ckookNhoooooooo[cmoo7oiooOlWooo`Gno"
            A$ = A$ + "o3Oio?nbgnoh;OkoS_l]ooOkOooo\gmoogngoo?kMoooXOmooooooK^cjnoo^7noooooooOjHooo`Gnoo7oiooOlWooh;OkoS_l]"
            A$ = A$ + "o?nbgnoh;OkoS_l]oo?kMooo\gmoocNgoo?jGoooooooUgL^oo_kQooooooooSneoo?lUooo`GnoS_l]o?nbgnoh;OkookNho?nb"
            A$ = A$ + "gnoh;OkoS_l]oo?kMooo[cmooONeooooooOi=WkookNhooooooooWGmooo>io?nbgnoh;OkoS_l]oookTooo_;noogngo?nbgnoh"
            A$ = A$ + ";OkoS_l]ooojLoooWGmooooooGNcinoo^7nooooooooiEooo_;nooo>io?nbgnoo_Cnooo^hoookRooo]omoo_>go?nbgnoo[cmo"
            A$ = A$ + "o[^foooiEoooooooUgL^oo_kQooooooooOndoo_kQooo_;nooo^hoookRooo_;nookNhooOkOooo\gmoo_>goo_jJoooYSmooOnd"
            A$ = A$ + "ooooooOi=WkookNhooooooooW?moogngoo_kQooo^7nookNhoo_kQooo]omoocNgoo?kMooo[cmoo[^foo?jGo_oV;mooooooGNc"
            A$ = A$ + "inoo^7nooooooc?i@ooo[cmoocNgooOkOooo]omoocNgoo?kMooo[cmoo[^fooOjHoooXOmooONeogOiAoooooooUgL^oo_kQooo"
            A$ = A$ + "ooooo;OjoooiCoooWGmooONeoooiEoooWGmooONeoooiEoooWGmooOndoooiCoOoU7moo7oiooooooojCokookNhoc?i@ooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooodc=booOkOooo^7noo?_jo3?f4oOi=WkoR[\]"
            A$ = A$ + "ok]abnOg57koMGL\ogMaanOg57koMGL\ogMaanOg57koOOl\oWNdmnoofonoogngoo_kQo?mLSlo\B9Po7M^Un?dhBjo@S;Yo3=^"
            A$ = A$ + "Tn?dhBjo@S;Yo3=^Tn?dhBjo@S;Yo3=^Tn?dhBjo?OkXoWJTmm?mLSlookNho7KV5n_lJKlooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooob[]ao7KV5noo^7noaVIQoooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooaVIQoo_kQoO\IFhooooooo?okoool_oooconoo?okoool_oooconoo?okoool_ooocon"
            A$ = A$ + "oo?okoool_oooconooooooO\IFhookNho7KV5noooooooG_kooOm^oooeknooG_kooOm^oooeknooG_kooOm^oooeknooG_kooOm"
            A$ = A$ + "^oooeknoooooo7KV5noo^7noaVIQoooooooo_;nooo^hoookRooo_;nooo^hoookRooo_;nooo^hoookRooo_;nooo^hoookRooo"
            A$ = A$ + "ooooaVIQoo_kQoO\IFhooooooooiCoooW?mocAfFoooiCoooW?mooOndoooiCoooW?mocAfFoooiCoooW?mooOndooooooO\IFho"
            A$ = A$ + "okNho7KV5noooooofk]bo?7IKmoLT]eocAfFoK_g:o_mN[lofk]bo?7IKmoLT]eocAfFoK_g:o_mN[loooooo7KV5noo^7noaVIQ"
            A$ = A$ + "oooooo_kF;lo^K]`o?7IKmoLT]eocAfFok^e2ooLT]eocAfFo?7IKm_kF;lo^K]`ok^e2oooooooaVIQoo_kQoO\IFhooooooWNd"
            A$ = A$ + "mnOjAgkoY7M_o?7IKmoLT]eocAfFo?7IKmoLT]eoY7M_oWNdmnOjAgkoY7M_ooooooO\IFhookNho7KV5nooooooX3=_oS>dln?j"
            A$ = A$ + "@ckoX3=_o?7IKmoLT]eocAfFoS>dln?j@ckoX3=_oS>dln?j@ckoooooo7KV5noo^7noaVIQoooooo?j@ckoX3=_oS>dln?j@cko"
            A$ = A$ + "X3=_o?7IKm?j@ckoX3=_oS>dln?j@ckoX3=_oS>dlnooooooaVIQoo_kQoO\IFhooooooS>dln?j@ckoX3=_oS>dln?j@ckoX3=_"
            A$ = A$ + "oS>dln?j@ckoX3=_oS>dln?j@ckoX3=_ooooooO\IFhookNho7KV5nooooooX3=_oS>dln?j@ckoX3=_oS>dln?j@ckoX3=_oS>d"
            A$ = A$ + "ln?j@ckoX3=_oS>dln?j@ckoooooo7KV5noo^7noaVIQoooooo?j@ckoX3=_oS>dln?j@ckoX3=_oS>dln?j@ckoX3=_oS>dln?j"
            A$ = A$ + "@ckoX3=_oS>dlnooooooaVIQoo_kQoO\IFhoi7NcoK_g:o_mN[lofk]boK_g:o_mN[lofk]boK_g:o_mN[lofk]boK_g:o_mN[lo"
            A$ = A$ + "fk]boWOh=oO\IFhookNhoookRo?Z@bgoj:ZSo[[X>n_^Rjhoj:ZSo[[X>n_^Rjhoj:ZSo[[X>n_^Rjhoj:ZSo[[X>n_^RjhoWnhN"
            A$ = A$ + "oo?jGooo^7nodc=bokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eodc=boo_k"
            A$ = A$ + "Qo_OV9eob[]aooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo;_f6o_OV9eookNhokWIBmoo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooookWIBmoo^7nonIVDoooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooonIVDoo_kQo_OV9eooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooo_OV9eookNhokWIBmoooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooookWIBmoo^7nonIVDooooooookWooo_OnoChN[mookWooo_Onoooniooo"
            A$ = A$ + "kWooo_OnoChN[mookWooo_OnoooniooooooonIVDoo_kQo_OV9eoooooooOlWo?Qk]fo4^gJoChN[mooaOnoo7oiooOlWo?Qk]fo"
            A$ = A$ + "4^gJoChN[mooaOnoo7oioooooo_OV9eookNhokWIBmoooooooOndoooiCo?Qk]fo4^gJoChN[mooW?mo4^gJoChN[m?Qk]fooOnd"
            A$ = A$ + "oooiCoooW?mooooookWIBmoo^7nonIVDooooooOmMWloegMboGOg9o?Qk]fo4^gJoChN[m?Qk]fo4^gJoGOg9oOmMWloegMboGOg"
            A$ = A$ + "9ooooooonIVDoo_kQo_OV9eooooooone3ookG?lo_Om`oone3o?Qk]fo4^gJoChN[mokG?lo_Om`oone3ookG?lo_Om`oooooo_O"
            A$ = A$ + "V9eookNhokWIBmoooooo]GM`ogNe1oOkE7lo]GM`ogNe1o?Qk]fo]GM`ogNe1oOkE7lo]GM`ogNe1oOkE7looooookWIBmoo^7no"
            A$ = A$ + "nIVDooooooOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1ooooooonIVDoo_kQo_OV9eooooo"
            A$ = A$ + "ogNe1oOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1oOkE7lo]GM`oooooo_OV9eookNhokWIBmoooooo]GM`ogNe"
            A$ = A$ + "1oOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1oOkE7looooookWIBmoo^7nonIVDoWOh=o_mN[lofk]boK_g:o_m"
            A$ = A$ + "N[lofk]boK_g:o_mN[lofk]boK_g:o_mN[lofk]boK_g:oOnQglonIVDoo_kQooo_;nonIVDokWIBm_OV9eonIVDokWIBm_OV9eo"
            A$ = A$ + "nIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBmooXOmookNhoS>dln_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVD"
            A$ = A$ + "okWIBm_OV9eonIVDokWIBm_OV9eonIVDoWM`]noo^7nonIVDoC?g8ooog;oooO_looombooog;oooO_looombooog;oooO_looom"
            A$ = A$ + "booog;oooO_looombo?mLSlonIVDoo_kQo_OV9eooooooomacnog7?koOOl\oomacnog7?koOOl\oomacnog7?koOOl\oomacnog"
            A$ = A$ + "7?koOOl\oooooo_OV9eookNhokWIBmoooooo_Om`oone3ookG?lo_Om`oone3ookG?lo_Om`oone3ookG?lo_Om`oone3ookG?lo"
            A$ = A$ + "oooookWIBmoo^7nonIVDoooooo_oV;moj;^co[_h>o_nRkloj;^co[_h>oonSolok?nco_oh?o_oV;monK^dok_iBooooooonIVD"
            A$ = A$ + "oo_kQo_OV9eooooooo_lYooo^7nookNhoo_kQooo^7nookNhoookRooo_;noo3Oioo_lYooobWnoo;Ojoooooo_OV9eookNhokWI"
            A$ = A$ + "BmooooooooooooOolo?Qk]foog?oooOolooomcoook_ooo_ono?Qk]fook_ooooooooooooooooookWIBmoo^7nonIVDoooooooo"
            A$ = A$ + "oooo4^gJoChN[m?Qk]fooooooooooooooooo4^gJoChN[m?Qk]fooooooooooooooooonIVDoo_kQo_OV9eooooooooooooooooo"
            A$ = A$ + "4^gJoChN[m?Qk]fooooooChN[m?Qk]fo4^gJoooooooooooooooooooooo_OV9eookNhokWIBmoooooooooooooooooooooo4^gJ"
            A$ = A$ + "oChN[m?Qk]fo4^gJoChN[moooooooooooooooooooooooooookWIBmoo^7nonIVDoooooooooooooooooooooooooooo4^gJoChN"
            A$ = A$ + "[m?Qk]fooooooooooooooooooooooooooooooooonIVDoo_kQo_OV9eooooooooooooooooooooooooooooooooo4^gJoooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooo_OV9eookNhokWIBmoooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooookWIBmoo^7nonIVDoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooonIVDoo_kQo_OV9eo<C;Xoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooc<]"
            A$ = A$ + "Pn_OV9eookNhokWIBm_OV9eo<C;Xoc<]Pn?cd2jo<C;Xoc<]Pn?cd2jo<C;Xoc<]Pn?cd2jo<C;Xoc<]Pn?cd2jonIVDokWIBmoo"
            A$ = A$ + "^7noH3<[okWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eoB[[Yoo_kQoool_oo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo]omookNhoooooooog;ooo7oi"
            A$ = A$ + "oookRooo]omoocNgooojLoooYSmooW>foo?jGoooXOmooONeok_iBoooc[nooooooooiCooo^7noooooooOlWooog;oooKokoool"
            A$ = A$ + "ZooobWnoo7oiooOlWoooaOnoo3OioookTooo_;noogngoooiEoooooooi7Ncoo_kQooooooooo^hoo_m_oooeknoo;OjooOlWooo"
            A$ = A$ + "aOnoo3OioookTooo_Cnooo^hoo_kQooo]omooONeooooooOlIGlookNhoooooooo]omoo?_joo_lYoooaOnoo3Oioo?lUooo`Gno"
            A$ = A$ + "okNhooOkOooo]omoogngooOkOoooXOmooooooc>e0ooo^7noooooooojLoooaOnoo7oiooOlWooo`Gnoo3Oioo?lUooo]omoogng"
            A$ = A$ + "ooOkOooo]omoogngoo?jGoooooooX3=_oo_kQoooooooo_>gooOlWoooaOnoS_l]oo?lUooo`GnoogngooOkOooo]omoS_l]ooOk"
            A$ = A$ + "Oooo\gmooSneoooooo_i>[kookNhooooooooYSmoo3Oio?nbgnoh;OkoS_l]oo_kQooo^7noocNgo?nbgnoh;OkoS_l]oo?kMooo"
            A$ = A$ + "XOmooooooGNcinoo^7nooooooo?jGooo`Gnoo3Oio?nbgnoh;OkoS_l]oo_kQooh;OkoS_l]o?nbgnoo\gmoo_>goooiEooooooo"
            A$ = A$ + "UgL^oo_kQooooooooONeoookTooo_Cnooo>io?nbgnoh;OkoS_l]o?nbgnoh;OkoocNgoo?kMooo[cmooONeooooooOi=WkookNh"
            A$ = A$ + "ooooooooWGmooo^hoookTooo_Cnooo>io?nbgnoh;OkoS_l]ooojLooo[cmoo_>goo_jJoooWGmooooooGNcinoo^7nooooooooi"
            A$ = A$ + "Cooo^7nooo^hoookRooo_;nooo^ho?nbgnoo]omoocNgooojLoooZ[mooW>foooiCoooooooUgL^oo_kQooooooooOndooOkOooo"
            A$ = A$ + "^7nookNhoo_kQooo^7noogngoo?kMooo\gmoo_>goo_jJoooXOmonK^dooooooOi=WkookNhoooooo?oT3moo_>goo?kMooo]omo"
            A$ = A$ + "ogngoo?kMooo\gmoo_>goo_jJoooYSmooSneoooiEoOoU7mooooooGNcinoo^7nooooooo_lYoooW?mooONeoooiEoooWGmooONe"
            A$ = A$ + "oooiEoooWGmooONeoooiCoooW?momGNdooOlWooooooo[?m_oo_kQo?oT3mooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooC?g8ooo]omookNhooolZo?lHCloUgL^o;^bfn_g6;koMGL\ogMaanOg57koMGL\ogMaanOg"
            A$ = A$ + "57koMGL\oomacnOjAgkooKokooOk%Oo?"
        CASE "radiobutton.png"
            A$ = MKI$(13) + MKI$(104)
            A$ = A$ + "oooo0looo3`ooo?00657J0HDLl5PAaA]0657e3HDLD;PAaaG0657Jlooo3`ooo?0oooo0looo30PAaQ00657<1HDLTOX6Bfo1OkY"
            A$ = A$ + "o[=gJo_aj^joVV8Jo3HDLT?PAa1C06572looo3`ooo?00657<YYNEmo_eJjoK3>hok]hRo_hUGnoUS>joW>k\oOc1;koQ6hFo3HD"
            A$ = A$ + "L`dooo?00657J0HDLTo_eJjoK3>hok]hRo_hUGnoUS>joW>k\o?k_ono_7Olo3=aen?PAaAn0657J0HDLlEX6BfoK3>hok]hRo_h"
            A$ = A$ + "UGnoUS>joW>k\o?k_ono_7Olo7olco?meGoo\nXKo3HDLl5PAaA]1OkYok]hRo_hUGnoUS>joW>k\o?k_ono_7Olo7olco?meGoo"
            A$ = A$ + "fOomoG=bin?PAaA]0657e[=gJo_hUGnoUS>joW>k\o?k_ono_7Olo7olco?meGoofOomoSOnioOmd;oo0657e3HDLD[aj^joUS>j"
            A$ = A$ + "oW>k\o?k_ono_7Olo7olco?meGoofOomoSOnio_nk_ooH_<_o3HDLD;PAaaGVV8JoW>k\o?k_ono_7Olo7olco?meGoofOomoSOn"
            A$ = A$ + "io_nk_oolgOoooJT`m?PAaaG0657J0HDLTOc1;ko_7Olo7olco?meGoofOomoSOnio_nk_oolgOooW=cln?PAaAn0657Jlooo30P"
            A$ = A$ + "Aa1CQ6hFo3=aen?meGoofOomoSOnio_nk_oolgOooW=cln_Y52fo0657<mooo3`ooo?0065720HDL`4PAaAn\nXKoG=binOmd;oo"
            A$ = A$ + "H_<_ooJT`m?PAaAn0657<1HDL8`ooo?0oooo0looo3`ooo?00657J0HDLl5PAaA]0657e3HDLD;PAaaG0657Jlooo3`ooo?0oooo"
            A$ = A$ + "0looo3`ooo?0oooo00HDLX1PAaaG0657e2HDLD?PAaA]0657O1HDLXaooo?0oooo0looo3`ooo?0065720HDL`4PAaAn@R8LoCY]"
            A$ = A$ + "ln?SDCoo3n:_ooGP_m?PAaAn0657<1HDL8`ooo?0oooo00HDL`DTn1foOV;_ocigno?SIgoo4JMoocgdlo?M@cooaQZ^oO7MNm?P"
            A$ = A$ + "Aa1Coooo00HDLX1PAaAnOV;_ocigno?VL_ooc>nmoOMkbo?[PKook5]no?6bkoOISZko0657i3HDLX1PAaaG@R8Locigno?VL_oo"
            A$ = A$ + "Jk^loomkaoog_7ooOoNloSMkboOK;WooD9\nogVN_m?PAaaG0657eBY]ln?SIgooc>nmoomkaoog_7ooOoNloomkaoog_7ooLVMm"
            A$ = A$ + "ok4`jo?FNVko0657e2HDLD?SDCoo4JMooOMkboog_7ooOoNloomkaoog_7ooOoNloCmjbo?BmVoo5M;lo3HDLD?PAaA]3n:_ocgd"
            A$ = A$ + "lo?[PKooOoNloomkaoog_7ooOoNloomkaooUGGoo3]Kno7eVin?PAaA]0657OmGP_m?M@cook5]noSMkboog_7ooOoNloomkaooe"
            A$ = A$ + "\7ooI9<nokC^io_Igifo0657O1HDLX1PAaAnaQZ^o?6bkoOK;WooLVMmoCmjbooUGGooI9<nokC^io_CIVko0657i3HDLXaooo?0"
            A$ = A$ + "0657<M7MNmOISZkoD9\nok4`jo?BmVoo3]KnokC^io_CIVkoZmVGo3HDL`dooo?0oooo00HDL80PAa1C0657igVN_m?FNVko5M;l"
            A$ = A$ + "o7eVin_Igifo0657i3HDL`4PAaQ0oooo0looo3`ooo?0oooo00HDLX1PAaaG0657e2HDLD?PAaA]0657O1HDLXaooo?0oooo0loo"
            A$ = A$ + "o3`ooo?0oooo0looo30PAaQ60657O1HDLD;PAaAm0657e2HDLl5PAaQ6oooo0looo3`ooo?0oooo00HDL80PAa1C0657i3YMDm?X"
            A$ = A$ + "IZho_N[]oK:XAn_Umaeo0657i3HDL`4PAaQ0oooo0looo30PAa1C<f6BokiU7nO[gNkoa^;_oKK`1oo^6Olo0cLco7;[MnOUhAeo"
            A$ = A$ + "0657<mooo30PAaQ60657ikiU7nO[gNkoa^;_oKK`1oo^6Olo0cLcoGLdBo?bEOmof:;Yo3HDLT?PAaQ60657O1YMDmO[gNkoa^;_"
            A$ = A$ + "oKK`1oo^6Olo0cLcoGLdBo?bEOmo<[mfooLgOooW7Jfo0657O1HDLD;XIZhoa^;_oKK`1oo^6Olo0cLcoGLdBo?bEOmo<[mfooLg"
            A$ = A$ + "OoodQ?nomZkZo3HDLD;PAaAm_N[]oKK`1oo^6Olo0cLcoGLdBo?bEOmo<[mfooLgOoodQ?noFG^ioK]hRo?PAaAm0657eJ:XAno^"
            A$ = A$ + "6Olo0cLcoGLdBo?bEOmo<[mfooLgOoodQ?noFG^ioW=jZoO`n2ko0657e2HDLlUUmaeo0cLcoGLdBo?bEOmo<[mfooLgOoodQ?no"
            A$ = A$ + "FG^ioW=jZoof[gnoS^hJo3HDLl5PAaQ60657i7;[Mn?bEOmo<[mfooLgOoodQ?noFG^ioW=jZoof[gno23\\o3HDLT?PAaQ6oooo"
            A$ = A$ + "00HDL`DUhAeof:;YooLgOoodQ?noFG^ioW=jZoof[gno23\\oc9PKm?PAa1Coooo0looo30PAaQ00657<1HDLToW7JfomZkZoK]h"
            A$ = A$ + "RoO`n2koS^hJo3HDLT?PAa1C06572looo3`ooo?0oooo0looo30PAaQ60657O1HDLD;PAaAm0657e2HDLl5PAaQ6oooo0looo3`o"
            A$ = A$ + "oo?0oooo0looo3`ooo?09G\aJTLa6oEb5KL]9G\aeWLa6GKb5KlG9G\aJlooo3`ooo?0oooo0looo3@b5K\09G\a<ULa6_Jb5KlH"
            A$ = A$ + "9G\aXTLa6G@b5K<:9G\aSULa6_Jb5K<C9G\a2looo3`ooo?09G\a<ULa6CGb5Kl0oooo0looo3`ooo?0oooo0looo3@b5Kl09G\a"
            A$ = A$ + "dULa6cdooo?09G\aJTLa6_Jb5Kl0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0TLa6?@b5KlZ9G\aJTLa6oEb5KlHoooo0loo"
            A$ = A$ + "o3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?09G\aSULa6oEb5KL]9G\aXlooo3`ooo?0oooo0looo3`ooo?0oooo0looo3`o"
            A$ = A$ + "oo?0oooo0TLa6SBb5KL]9G\aeWLa6G`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3@b5KL19G\aeWLa6GKb5K<:"
            A$ = A$ + "oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?09G\aXTLa6GKb5KlG9G\aSmooo3`ooo?0oooo0looo3`ooo?0oooo"
            A$ = A$ + "0looo3`ooo?0oooo0TLa6?Fb5KlG9G\aJTLa6_Jb5Kl0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0TLa6?@b5KlZ9G\aJloo"
            A$ = A$ + "o3@b5K<C9G\adULa6?`ooo?0oooo0looo3`ooo?0oooo0TLa6?@b5K<M9G\a<mooo3`ooo?09G\a2TLa6cDb5KlZ9G\aSULa6SBb"
            A$ = A$ + "5KL19G\aXTLa6?Fb5KlZ9G\a<ULa6;`ooo?0oooo0looo3`ooo?09G\aJTLa6oEb5KL]9G\aeWLa6GKb5KlG9G\aJlooo3`ooo?0"
            A$ = A$ + "oooo0looo3`ooo?0oooo00HDLX1PAaaG0657e2HDLD?PAaA]0657O1HDLXaooo?0oooo0looo3`ooo?0065720HDL`4PAaAnSNXI"
            A$ = A$ + "oG\^[nogQomo8k[[oOjRYm?PAaAn0657<1HDL8`ooo?0oooo00HDL`4WlMeo3WKZo7NiUoohWOnoV[^joW>k\o?k_ono??l\o;JP"
            A$ = A$ + "Lm?PAa1Coooo00HDLX1PAaAn3WKZo7NiUoohWOnoV[^joW>k\o?k_ono_7Olo7olco_d5Kko0657i3HDLX1PAaaGSNXIo7NiUooh"
            A$ = A$ + "WOnoNS^hoK:gYn_BofdoN:=XoK^kXooleGoofOomog:T^m?PAaaG0657eF\^[nohWOnoV[^joK:gYnODEGeoo<l@oK2ZYl?V<[io"
            A$ = A$ + "fOomoSOnio_e9[ko0657e2HDLDogQomoV[^joW>k\o_Bofdoo<\@oGC^hlO8Q6boSHY9oSOnioOnj[oofGolo3HDLD?PAaA]8k[["
            A$ = A$ + "oW>k\o?k_onoN:=XoO2ZZl?8R:bo@8i4oO9bHnOnj[ookc?ooWmbln?PAaA]0657OMjRYm?k_ono_7OloK^kXo?V<[ioTH99oOIb"
            A$ = A$ + "HnOkcknokc?oogOomoo[A2go0657O1HDLX1PAaAn??l\o7olcooleGoofOomoSOnioOnj[ookc?oogOomoOf<cko0657i3HDLXao"
            A$ = A$ + "oo?00657<9JPLm_d5KkofOomoSOnioOnj[ookc?oogOomoOf<ckoVF8Ho3HDL`dooo?0oooo00HDL80PAa1C0657ig:T^m_e9[ko"
            A$ = A$ + "fGoloWmblno[A2go0657i3HDL`4PAaQ0oooo0looo3`ooo?0oooo00HDLX1PAaaG0657e2HDLD?PAaA]0657O1HDLXaooo?0oooo"
            A$ = A$ + "0looo3`ooo?0oooo0looo30PAaQ60657O1HDLD;PAaAm0657e2HDLl5PAaQ6oooo0looo3`ooo?0oooo00HDL80PAa1C0657i39R"
            A$ = A$ + "`m?Ufbko<B=mo?h[lnoO1nfo0657i3HDL`4PAaQ0oooo0looo30PAa1CAj7HooI^ln?WOkoo<VMooCXemo?OCcood1=oo77ZjnoM"
            A$ = A$ + "dieo0657<mooo30PAaQ60657ioI^ln?WOkooHbmno?khgooe];oo\2^mo_GdjooH8_ooU=Z^o3HDLT?PAaQ60657O19R`m?WOkoo"
            A$ = A$ + "Hbmno;=kYo?XNcjo8mKCoCIdPn_cXOno]]LnoCU`joOKjmfo0657O1HDLD;Ufbko<VMoo?khgo?XNcjoAEMEooc`3m_9XVbo<R<V"
            A$ = A$ + "ocIfeo_C0[ooHiI^o3HDLD;PAaAm<B=moCXemooe];oo8mKCooc`2mO=iRcoQ4J8o3BUUl?e[;oo8eKnoGd]`o?PAaAm0657e>h["
            A$ = A$ + "ln?OCcoo\2^moCIdPno9XZboP8Z8o3QTCl?R2?ioGNMmo?d^ioODKVko0657e2HDLleO1nfod1=oo_Gdjo_cXOno<V<Vo7BUSl?R"
            A$ = A$ + "3?io=K^ioWU`ho_?iVooVMWKo3HDLl5PAaQ60657i77ZjnoH8_oo]]LnocIfeo?e[;ooGNMmoWU`ho_?iVoo>UI^o3HDLT?PAaQ6"
            A$ = A$ + "oooo00HDL`dMdieoU=Z^oCU`jo_C0[oo8eKno?d^io_?iVoo>UI^o[fKNm?PAa1Coooo0looo30PAaQ00657<1HDLTOKjmfoHiI^"
            A$ = A$ + "oGd]`oODKVkoVMWKo3HDLT?PAa1C06572looo3`ooo?0oooo0looo30PAaQ60657O1HDLD;PAaAm0657e2HDLl5PAaQ6oooo0loo"
            A$ = A$ + "o3`ooo?0oooo0looo3`ooo?00657J0HDLl5PAaA]0657e3HDLD;PAaaG0657Jlooo3`ooo?0oooo0looo30PAaQ00657<1HDLT?T"
            A$ = A$ + "fAeoPVYRooj]fn_YP6ioFf7Go3HDLT?PAa1C06572looo3`ooo?00657<aHK8m_WGNho]Nk]o7k^ln_]17lokJlao3<c=oO\\fio"
            A$ = A$ + "ER7Eo3HDL`dooo?00657J0HDLT_WGNho]Nk]o7k^ln_]17lokJlao3<c=oOaA;mo8GmeoK[\Tn?PAaAn0657J0HDLl5TfAeo]Nk]"
            A$ = A$ + "o7k^ln?\1_ko:FlToGd^9m?Qofhoo6Mcoc\fKoocMomoONXIo3HDLl5PAaA]PVYRo7k^ln_]17lo:FlTo7EeEmo?3?doVPJ:o3h^"
            A$ = A$ + ";nocMomoC7nhog[^[n?PAaA]0657eoj]fn_]17lokJlaoGd^9mo?3;doeT;>o7BXQlo7C>boC7nhoKMiVo_eR;no0657e3HDLD[Y"
            A$ = A$ + "P6iokJlao3<c=oOQofhoWPZ:o3RXRl?4B>ao0Z[RoKMiVoOfX[no1k;\o3HDLD;PAaaGFf7Go3<c=oOaA;moo6Mco38_;n?8C6bo"
            A$ = A$ + "0Z[RoclgKoOfX[noK_Nko?jR[m?PAaaG0657J0HDLTO\\fio8Gmeoc\fKoocMomoC7nhoKMiVoOfX[noK_Nko;<`bn?PAaAn0657"
            A$ = A$ + "Jlooo30PAa1CER7EoK[\TnocMomoC7nhoKMiVoOfX[noK_Nko;<`bn?W0^eo0657<mooo3`ooo?0065720HDL`4PAaAnONXIog[^"
            A$ = A$ + "[n_eR;no1k;\o?jR[m?PAaAn0657<1HDL8`ooo?0oooo0looo3`ooo?00657J0HDLl5PAaA]0657e3HDLD;PAaaG0657Jlooo3`o"
            A$ = A$ + "oo?0oooo0looo3`ooo?0oooo0TLa6[Ab5KlG9G\aeVLa6GOb5KL]9G\aOULa6[aooo?0oooo0looo3`ooo?09G\a2TLa6cDb5KlZ"
            A$ = A$ + "9G\aSULa6SBb5KL19G\aXTLa6?Fb5KlZ9G\a<ULa6;`ooo?0oooo0TLa6cDb5K<M9G\a3looo3`ooo?0oooo0looo3`ooo?09G\a"
            A$ = A$ + "3TLa6CGb5K<Coooo0TLa6[Ab5KlZ9G\a3looo3`ooo?0oooo0looo3`ooo?0oooo0looo3@b5Kl09G\a[VLa6[Ab5KlG9G\aSmoo"
            A$ = A$ + "o3`ooo?09G\ahTLa63Jb5K<l9G\aPVLa6Scooo?0oooo0TLa6?Fb5KlG9G\aeVLa6Sbooo?0oooo0TLa63Jb5Klo9G\aoWLa6oOb"
            A$ = A$ + "5K<Xoooo0looo3@b5K<:9G\aeVLa6GOb5KL1oooo0looo3@b5K<l9G\aoWLa6oOb5Klo9G\a`oooo3`ooo?09G\a5TLa6GOb5KL]"
            A$ = A$ + "9G\aXlooo3`ooo?09G\aPVLa6oOb5Klo9G\aoWLa63jooo?0oooo0TLa6SBb5KL]9G\aOULa6?fooo?0oooo0TLa6SCb5K<X9G\a"
            A$ = A$ + "`WLa63Jb5K<>oooo0looo3@b5KlH9G\aOULa6[Ab5KlZ9G\a3looo3`ooo?0oooo0looo3`ooo?0oooo0looo3@b5Kl09G\a[VLa"
            A$ = A$ + "6[aooo?09G\a<ULa6CGb5Kl0oooo0looo3`ooo?0oooo0looo3@b5Kl09G\adULa6cdooo?0oooo0TLa6;@b5K<C9G\a[VLa6?Fb"
            A$ = A$ + "5K<:9G\a5TLa6SBb5KlH9G\a[VLa6cDb5K\0oooo0looo3`ooo?0oooo0TLa6[Ab5KlG9G\aeVLa6GOb5KL]9G\aOULa6[aooo?0"
            A$ = A$ + "oooo0loo%o30"
        CASE "progresstrack.png"
            A$ = MKI$(9) + MKI$(19)
            A$ = A$ + "oooooOjZ\nOOnmgoXQ6JoS6JXm?JXQfoXQ6JoS6JXmok_onoV^:[oOgMgm__njkonj[_ok[_nn__njkonj[_oS6JXmo\c>komigO"
            A$ = A$ + "ok[_nn__njko_onkoonk_ook_ono_onkok[_nnOP16hoXQ6Jok[_nnok_ono_onkoooooooooooo_onkoonk_o?JXQfoXQ6Jok[_"
            A$ = A$ + "nnok_onoooooooooooonk_oooooooonk_o?JXQfoXQ6Jok[_nnok_onoooooooooooonk_oooooooonk_o?JXQfoXQ6Jok[_nnok"
            A$ = A$ + "_onooooooooooo?nhSoooooooonk_o?JXQfoXQ6Jok[_nnok_onoooooooooooOmeGoooooooonk_o?JXQfoXQ6Jok[_nnok_ono"
            A$ = A$ + "ooooooooooolc?oooooooonk_o?JXQfoXQ6Jok[_nnok_onooooooooooo?l`3oooooooonk_o?JXQfoXQ6Jok[_nnok_onooooo"
            A$ = A$ + "oooooook_onooooooonk_o?JXQfoXQ6Jok[_nnok_onooooooooooo_lb;oooooooonk_o?JXQfoXQ6Jok[_nnok_onooooooooo"
            A$ = A$ + "ooOmeGoooooooonk_o?JXQfoXQ6Jok[_nnok_onooooooooooo?nhSoooooooonk_o?JXQfoXQ6Jok[_nnok_onooooooooooo_n"
            A$ = A$ + "j[oooooooonk_o?JXQfoXQ6Jok[_nnok_onoooooooooooonk_oooooooonk_o?JXQfomigOok[_nnok_ono_onkoooooooooooo"
            A$ = A$ + "_onkoonk_oOOnmgoW^:[oOgMgmok_ono_onkoonk_ook_ono_onkoOgMgm_Y[bjooooooKjZ\nOOnmgoXQ6JoS6JXm?JXQfomigO"
            A$ = A$ + "oOjZ\noooooo%%%0"
        CASE "progresschunk.png"
            A$ = MKI$(10) + MKI$(12)
            A$ = A$ + ">=X5okdPFl_C3Jao>=X5okdPFl_C3Jao>=X5okdPFl_C3Jao>=X5ok:eVn_[DOjo^BmYok:eWn_[DOjo^BmYok:eWn_[DOjo^BmY"
            A$ = A$ + "ok:eWnoP3cgo3><Oo?h`lmoP3cgo3><Oo?h`lmoP3cgo4>LOoCh`mmoP3cgoZmkIo[f_Wm_JoNfoZmkIo[f_Wm_JoNfo[m;Jo[f_"
            A$ = A$ + "Xm_JoRfo[m;Jo;V_MmoHnjeoSm[Go?f_NmoHojeoTm[GoCf_Om?IoneoTmkGoCf_Om_HnfeoRiKGo;V_Mm_HnfeoRiKGo;V_Mm_H"
            A$ = A$ + "nfeoRiKGo;V_Mm_Hnfeo7ml>oOdckloA@_co71m>oODdkloAA_co75=?oSDdll?BAcco85=?oOBfHlo9ISaoWT=6oOBfHlo9JOao"
            A$ = A$ + "WXm5oORfGlo9JOaoWXm5oORfGl_=V3bofH>8oKSiPl_=V3bofD>8oKCiPlo=V3bogH>8oOSiPlo=V3bo\\N7ocbjMl?;[gao\\N7"
            A$ = A$ + "ocbjMl?;[gao\\N7ocRjMl?;[kao\\^7ok1jEl_7XGaoNPN5ok1jEl_7XGaoNPN5okAjEl_7YGaoNTN5okAjEl_C3Jao>=X5okdP"
            A$ = A$ + "Fl_C3Jao>=X5okdPFl_C3Jao>=X5okdPFl_C3Jao%%%0"
        CASE "button.png"
            A$ = MKI$(18) + MKI$(105)
            A$ = A$ + ":O;ZoKiLDmoPAibo2nd:o;hC[l_P?]bo2nd:o;hC[l_P?]bo2nd:o;hC[l_P?]bo2nd:o;hC[l_P?]bo36E;o;9K;m_bgRjoCfVC"
            A$ = A$ + "oCKTkm?kPKmo\k=eoc^gEo?kNGmo\kMeoc^gEo?kNGmo\kMeoc^gEo?kNGmo\kMeoc^gEo?kNCmo\3^eoCKTkmoT]ido36e;oG?j"
            A$ = A$ + "OoookSooogOnooOoiooomWooogOnooOoiooomWooogOnooOoiooomWooogOnooOoiooomWooo_?noG?jOooPAmbo22E;o7?hGooo"
            A$ = A$ + "m_oooSoloo?ncoooh?oooSoloo?ncoooh?oooSoloo?ncoooh?oooSoloo?ncoooh?ooogono7?hGo_P@ebo22E;o3OgBooolWoo"
            A$ = A$ + "nkOook_omo_ongoonkOook_omo_ongoonkOook_omo_ongoonkOook_omo_ongooocOno3OgBo_P@ebo22E;ognf?o_ojSoomgon"
            A$ = A$ + "ogOokoOom_oomgonogOokoOom_oomgonogOokoOom_oomgonogOokoOom_oon[?nognf?o_P@ebo22E;o_ne;oOoiKoolc?noc?o"
            A$ = A$ + "ho?olSoolc?noc?oho?olSoolc?noc?oho?olSoolc?noc?oho?olSoomW_mo_ne;o_P@ebo22E;oS>e7o?ohGooj[?mo[_ndo_n"
            A$ = A$ + "jCooj[?mo[_ndo_njCooj[?mo[_ndo_njCooj[?mo[_ndo_njCoolSOmoS>e7o_P@ebo22E;oONd4oonf?ooiSOloW?naoOnh7oo"
            A$ = A$ + "iSOloW?naoOnh7ooiSOloW?naoOnh7ooiSOloW?naoOnh7ookKoloONd4o_P@ebo22E;oC^c1o_ne;oogCOkoO?m]oomdgnogCOk"
            A$ = A$ + "oO?m]oomdgnogCOkoO?m]oomdgnogCOkoO?m]oomdgnojG_loC^c1o_P@ebo22E;o7>bhnom`gnoe7OjoGOlYoOmaWnoe7OjoGOl"
            A$ = A$ + "YoOmaWnoe7OjoGOlYoOmaWnoe7OjoGOlYoOmaWnog3Oko7>bhn_P@ebo22E;oc=``nol\Onoc_nho?ojSool[?noc_nho?ojSool"
            A$ = A$ + "[?noc_nho?ojSool[?noc_nho?ojSool[?noccnioc=``n_P@ebo22E;o[M_\nOlZCno[c=do_>g@oojL3mo[c=do_>g@oojL3mo"
            A$ = A$ + "[c=do_>g@oojL3mo[c=do_>g@oojL3moa[>io[M_\n_P@ebo22E;oO]^Xn?lX;noWGmaoONe7ooiEOloWGmaoONe7ooiEOloWGma"
            A$ = A$ + "oONe7ooiEOloWGmaoONe7ooiEOlo`S^hoO]^Xn_P@ebo22E;oGM]Sn_kUkmoRoL`o;nc1o_h?7loRoL`o;nc1o_h?7loRoL`o;nc"
            A$ = A$ + "1o_h?7loRoL`o;nc1o_h?7lo^G^goGM]Sn_P@ebo22E;o?m\PnOkScmoN[l^ok]bkn_g:_koN[l^ok]bkn_g:_koN[l^ok]bkn_g"
            A$ = A$ + ":_koN[l^ok]bkn_g:_ko]?>go?m\Pn_P@ebo22E;o;M\LnojQWmoH;L\oS]`an?f27koH;L\oS]`an?f27koH;L\oS]`an?f27ko"
            A$ = A$ + "H;L\oS]`an?f27ko[7Nfo;M\Ln_P@ebo22E;o7][Hn_jQWmoCgkZo?M_[nodm^joCgkZo?M_[nodm^joCgkZo?M_[nodm^joCgkZ"
            A$ = A$ + "o?M_[nodm^joZ7Nfo7][Hn_P@ebo36e;o7M[Hn?iGglo?S[Yoo<^VnochJjo?S[Yoo<^VnochJjo?S[Yoo<^VnochJjo?S[Yoo<^"
            A$ = A$ + "VnochJjoTOMco7M[HnoPAmbo?JFAoS:OOm?cW2io=S:Tog<Z@nOcX2io=S:Tog<Z@nOcX2io=S:Tog<Z@nOcX2io=S:Tog<Z@nOc"
            A$ = A$ + "X2io<O:ToS:OOm?TXMdo:O;ZoKILBmoPAmbo22E;o;8D]l_P@ebo22E;o;8D]l_P@ebo22E;o;8D]l_P@ebo22E;o;8D]l_P@ebo"
            A$ = A$ + "36U;o?9K;m_bgRjo:O;ZoKiLDmoPAibo2nd:o;hC[l_P?]bo2nd:o;hC[l_P?]bo2nd:o;hC[l_P?]bo2nd:o;hC[l_P?]bo36E;"
            A$ = A$ + "o;9K;m_bgRjoCfVCoCKTkmOXXGooQRNmo7:jeoOXXGooQRNmo7:jeoOXXGooQRNmo7:jeoOXXGooQRNmo7:jeoOXXGooQRNmoCKT"
            A$ = A$ + "kmoT]ido36e;o7:jeoOXXGoo6nlkoKhc_o_Q?ono6nlkoKhc_o_Q?ono6nlkoKhc_o_Q?ono6nlkoKhc_o_Q?onoQRNmo7:jeooP"
            A$ = A$ + "Ambo22E;o7:jeoOXXGoonkOook_omo_ongoonkOook_omo_ongoonkOook_omo_ongoonkOook_omo_ongooQRNmo7:jeo_P@ebo"
            A$ = A$ + "22E;oc9idoOXXGoonkOook_omo_ongoonkOook_omo_ongoonkOook_omo_ongoonkOook_omo_ongooQRNmoc9ido_P@ebo22E;"
            A$ = A$ + "oKYgco_WVCoomgonogOokoOom_oomgonogOokoOom_oomgonogOokoOom_oomgonogOokoOom_ooNJ>moKYgco_P@ebo22E;okhe"
            A$ = A$ + "aooVSCoolc?noc?oho?olSoolc?noc?oho?olSoolc?noc?oho?olSoolc?noc?oho?olSooK>>mokheao_P@ebo22E;oKhc_ooU"
            A$ = A$ + "O?ooj[?mo[_ndo_njCooj[?mo[_ndo_njCooj[?mo[_ndo_njCooj[?mo[_ndo_njCooGnmloKhc_o_P@ebo22E;ogga]ooTK;oo"
            A$ = A$ + "iSOloW?naoOnh7ooiSOloW?naoOnh7ooiSOloW?naoOnh7ooiSOloW?naoOnh7ooC^]locga]o_P@ebo22E;o?W_[ooSG7oogCOk"
            A$ = A$ + "oO?m]oomdgnogCOkoO?m]oomdgnogCOkoO?m]oomdgnogCOkoO?m]oomdgno?NMlo?g_[o_P@ebo22E;oSF]Yo_RC3ooe7OjoGOl"
            A$ = A$ + "YoOmaWnoe7OjoGOlYoOmaWnoe7OjoGOlYoOmaWnoe7OjoGOlYoOmaWno:>=loWF]Xo_P@ebo22E;okeZWo?Q>onoc_nho?ojSool"
            A$ = A$ + "[?noc_nho?ojSool[?noc_nho?ojSool[?noc_nho?ojSool[?no4jlkok5[Wo_P@ebo22E;oCUXUooQ:kno[c=do_>g@oojL3mo"
            A$ = A$ + "[c=do_>g@oojL3mo[c=do_>g@oojL3mo[c=do_>g@oojL3mo6Z\koCeXTo_P@ebo22E;o[TVRoON5gnoWGmaoONe7ooiEOloWGma"
            A$ = A$ + "oONe7ooiEOloWGmaoONe7ooiEOloWGmaoONe7ooiEOlojELko[TVRo_P@ebo22E;o7DTPoOKo^noRoL`o;nc1o_h?7loRoL`o;nc"
            A$ = A$ + "1o_h?7loRoL`o;nc1o_h?7loRoL`o;nc1o_h?7lo]mkjo;TTPo_P@ebo22E;oWSRNo_HjVnoN[l^ok]bkn_g:_koN[l^ok]bkn_g"
            A$ = A$ + ":_koN[l^ok]bkn_g:_koN[l^ok]bkn_g:_koQYKjoSSRNo_P@ebo22E;o7cPMooEeRnoH;L\oS]`an?f27koH;L\oS]`an?f27ko"
            A$ = A$ + "H;L\oS]`an?f27koH;L\oS]`an?f27koGEkio7cPLo_P@ebo22E;o_ROKoOCbNnoCgkZo?M_[nodm^joCgkZo?M_[nodm^joCgkZ"
            A$ = A$ + "o?M_[nodm^joCgkZo?M_[nodm^jo=9kio_BOKo_P@ebo36e;oKBNJoOAZJnoPQKlok5^ao?Hh6ooPQKlo36^ao?Hh6ooPQKlo36^"
            A$ = A$ + "ao?Hh6ooPQKlo36^ao?Hh6oo5YZioKBNJooPAmbo?JFAoS:OOm_9iYmoVTWfoKBNJo_9iYmoVTWfoKBNJo_9iYmoVTWfoKBNJo_9"
            A$ = A$ + "iYmoVTWfoKBNJo_9iYmoVTWfoS:OOm?TXMdo:O;ZoKILBmoPAmbo22E;o;8D]l_P@ebo22E;o;8D]l_P@ebo22E;o;8D]l_P@ebo"
            A$ = A$ + "22E;o;8D]l_P@ebo36U;o?9K;m_bgRjo:O;ZoKiLDmoPAibo2nd:o;hC[l_P?]bo2nd:o;hC[l_P?]bo2nd:o;hC[l_P?]bo2nd:"
            A$ = A$ + "o;hC[l_P?]bo36E;o;9K;m_bgRjoCfVCoCKTkm?kPKmo\k=eoc^gEo?kNGmo\kMeoc^gEo?kNGmo\kMeoc^gEo?kNGmo\kMeoc^g"
            A$ = A$ + "Eo?kNCmo\3^eoCKTkmoT]ido36e;o[[TgmO^ANgoj:iMo[[Tgm_^BNgoj:iMo[[Tgm_^BNgoj:iMo[[Tgm_^BNgoj:iMo[[Tgm_^"
            A$ = A$ + "BNgoi6iMoc[W8noPAmbo22E;o[[TgmochJjo?S[Yoo<^VnochJjo?S[Yoo<^VnochJjo?S[Yoo<^VnochJjo?S[Yoo<^VnochJjo"
            A$ = A$ + "?S[Yoc;W5n_P@ebo22E;o[[Tgmodm^joCgkZo?M_[nodm^joCgkZo?M_[nodm^joCgkZo?M_[nodm^joCgkZo?M_[nodm^joCgkZ"
            A$ = A$ + "o_[V3n_P@ebo22E;o[[Tgm?f27koH;L\oS]`an?f27koH;L\oS]`an?f27koH;L\oS]`an?f27koH;L\oS]`an?f27koH;L\o[kU"
            A$ = A$ + "om_P@ebo22E;o[[Tgm_g:_koN[l^ok]bkn_g:_koN[l^ok]bkn_g:_koN[l^ok]bkn_g:_koN[l^ok]bkn_g:_koN[l^o[KUlm_P"
            A$ = A$ + "@ebo22E;o[[Tgm_h?7loRoL`o;nc1o_h?7loRoL`o;nc1o_h?7loRoL`o;nc1o_h?7loRoL`o;nc1o_h?7loRoL`o[kTim_P@ebo"
            A$ = A$ + "22E;o[[TgmoiEOloWGmaoONe7ooiEOloWGmaoONe7ooiEOloWGmaoONe7ooiEOloWGmaoONe7ooiEOloWGmaoWKTgm_P@ebo22E;"
            A$ = A$ + "o[[TgmojL3mo[c=do_>g@oojL3mo[c=do_>g@oojL3mo[c=do_>g@oojL3mo[c=do_>g@oojL3mo[c=doWKTgm_P@ebo22E;o[[T"
            A$ = A$ + "gmol[?noc_nho?ojSool[?noc_nho?ojSool[?noc_nho?ojSool[?noc_nho?ojSool[?noc_nhoWKTgm_P@ebo22E;o[[TgmOm"
            A$ = A$ + "aWnoe7OjoGOlYoOmaWnoe7OjoGOlYoOmaWnoe7OjoGOlYoOmaWnoe7OjoGOlYoOmaWnoe7OjoWKTgm_P@ebo22E;o[[Tgmomdgno"
            A$ = A$ + "gCOkoO?m]oomdgnogCOkoO?m]oomdgnogCOkoO?m]oomdgnogCOkoO?m]oomdgnogCOkoWKTgm_P@ebo22E;o[[TgmOnh7ooiSOl"
            A$ = A$ + "oW?naoOnh7ooiSOloW?naoOnh7ooiSOloW?naoOnh7ooiSOloW?naoOnh7ooiSOloWKTgm_P@ebo22E;o[[Tgm_njCooj[?mo[_n"
            A$ = A$ + "do_njCooj[?mo[_ndo_njCooj[?mo[_ndo_njCooj[?mo[_ndo_njCooj[?moWKTgm_P@ebo22E;o[[Tgm?olSoolc?noc?oho?o"
            A$ = A$ + "lSoolc?noc?oho?olSoolc?noc?oho?olSoolc?noc?oho?olSoolc?noWKTgm_P@ebo22E;o[[TgmOom_oomgonogOokoOom_oo"
            A$ = A$ + "mgonogOokoOom_oomgonogOokoOom_oomgonogOokoOom_oomgonoWKTgm_P@ebo22E;o[[Tgm_ongoonkOook_omo_ongoonkOo"
            A$ = A$ + "ok_omo_ongoonkOook_omo_ongoonkOook_omo_ongoonkOooWKTgm_P@ebo36e;o[[Tgmooh?oooSoloo?ncoooh?oooSoloo?n"
            A$ = A$ + "coooh?oooSoloo?ncoooh?oooSoloo?ncoooh?oooSoloWKTgmoPAmbo?JFAoS:OOmoomWooogOnooOoiooomWooogOnooOoiooo"
            A$ = A$ + "mWooogOnooOoiooomWooogOnooOoiooomWooogOnokILBm?TXMdo:O;ZoKILBmoPAmbo22E;o;8D]l_P@ebo22E;o;8D]l_P@ebo"
            A$ = A$ + "22E;o;8D]l_P@ebo22E;o;8D]l_P@ebo36U;oG9L@m_bgRjo^W>ioWLa6oOb5Klo9G\aoWLa6oOb5Klo9G\aoWLa6oOb5Klo9G\a"
            A$ = A$ + "oWLa6oOb5Klo9G\aoWLa6oOb5Klo9G\aoWLa6o_kYCno9G\aoooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooOb5Klo9G\aoooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooOb5Klo9G\aoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooOb5Klo9G\aoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooOb5Klo9G\aoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooOb5Klo9G\aoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooOb5Klo9G\aoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooOb5Klo9G\aoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooOb5Klo9G\aoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooOb5Klo9G\aooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooOb"
            A$ = A$ + "5Klo9G\aooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooOb5Klo"
            A$ = A$ + "9G\aooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooOb5Klo9G\a"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooOb5Klo9G\aoooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooOb5Klo9G\aoooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooOb5Klo9G\aoooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooOb5Klo9G\aoooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooOb5Klo9G\aoooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooOb5Klo9G\aoooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooOb5Klo^W>ioWLa6oOb5Klo9G\aoWLa6oOb5Klo"
            A$ = A$ + "9G\aoWLa6oOb5Klo9G\aoWLa6oOb5Klo9G\aoWLa6oOb5Klo9G\aoWLa6o_kYCno:O;Zo3[E]l?\Febo`JE;o3[E]l?\Febo`JE;"
            A$ = A$ + "o3[E]l?\Febo`JE;o3[E]l?\Febo`JE;o3[E]l?\Febo`JE;o3[E]l_bgRjo`JE;o?[ORm_jkjgoZ3lRo[>`;n_j0_hoZ3lRo[>`"
            A$ = A$ + ";n_j0_hoZ3lRo[>`;n_j0_hoZ3lRo[>`;n_j0_hoZ_[Oo?[ORmoT]ido`JE;oWMXam?hi>joPWkXo3N^Sn?hi>joPWkXo3N^Sn?h"
            A$ = A$ + "i>joPWkXo3N^Sn?hi>joPWkXo3N^Sn?hi>joPWkXoWMXam?\Febo`JE;o[mXdm?hkNjooSoloo?ncoooh?oooSoloo?ncoooh?oo"
            A$ = A$ + "oSoloo?ncoooh?oooSoloo?ncoooh?ooP_kYo[mXdm?\Febo`JE;oWMXbm?hh6jonkOook_omo_ongoonkOook_omo_ongoonkOo"
            A$ = A$ + "ok_omo_ongoonkOook_omo_ongooPSKXoWMXbm?\Febo`JE;oS=X`m?gefiomgonogOokoOom_oomgonogOokoOom_oomgonogOo"
            A$ = A$ + "koOom_oomgonogOokoOom_ooLG[WoS=X`m?\Febo`JE;oO]W^mOfaViolc?noc?oho?olSoolc?noc?oho?olSoolc?noc?oho?o"
            A$ = A$ + "lSoolc?noc?oho?olSooI7KVoO]W^m?\Febo`JE;oKMW\m_e]Fioj[?mo[_ndo_njCooj[?mo[_ndo_njCooj[?mo[_ndo_njCoo"
            A$ = A$ + "j[?mo[_ndo_njCooFg:UoKMW\m?\Febo`JE;oGmV[mOeZ:ioiSOloW?naoOnh7ooiSOloW?naoOnh7ooiSOloW?naoOnh7ooiSOl"
            A$ = A$ + "oW?naoOnh7ooE[JToGmV[m?\Febo`JE;oC]VYmOdVjhogCOkoO?m]oomdgnogCOkoO?m]oomdgnogCOkoO?m]oomdgnogCOkoO?m"
            A$ = A$ + "]oomdgnoAOZSoC]VYm?\Febo`JE;o;mUUm_cP>hoe7OjoGOlYoOmaWnoe7OjoGOlYoOmaWnoe7OjoGOlYoOmaWnoe7OjoGOlYoOm"
            A$ = A$ + "aWno>3jPo;mUUm?\Febo`JE;o3mTQm?bGZgoc_nho?ojSool[?noc_nho?ojSool[?noc_nho?ojSool[?noc_nho?ojSool[?no"
            A$ = A$ + "8OYNo3mTQm?\Febo`JE;oo\TOm_aCFgo[c=do_>g@oojL3mo[c=do_>g@oojL3mo[c=do_>g@oojL3mo[c=do_>g@oojL3mo6?YM"
            A$ = A$ + "oo\TOm?\Febo`JE;og<TMmo`?6goWGmaoONe7ooiEOloWGmaoONe7ooiEOloWGmaoONe7ooiEOloWGmaoONe7ooiEOlo3oHLog<T"
            A$ = A$ + "Mm?\Febo`JE;oc\SKm?`9^foRoL`o;nc1o_h?7loRoL`o;nc1o_h?7loRoL`o;nc1o_h?7loRoL`o;nc1o_h?7lo0[hJoc\SKm?\"
            A$ = A$ + "Febo`JE;o_LSIm__7NfoN[l^ok]bkn_g:_koN[l^ok]bkn_g:_koN[l^ok]bkn_g:_koN[l^ok]bkn_g:_konNhIo_LSIm?\Febo"
            A$ = A$ + "`JE;o_<SGmO_6>foH;L\oS]`an?f27koH;L\oS]`an?f27koH;L\oS]`an?f27koH;L\oS]`an?f27komJhHo_<SGm?\Febo`JE;"
            A$ = A$ + "o[\REm?_2jeoCgkZo?M_[nodm^joCgkZo?M_[nodm^joCgkZo?M_[nodm^joCgkZo?M_[nodm^jol:XGo[\REm?\Febo`JE;o3kH"
            A$ = A$ + "glO\]mcomJ8IocKPNm?_1jeol6XGocKPNm?_1jeol6XGocKPNm?_1jeol6XGocKPNmO_6BfogFGAo3kHgl?\Febo`JE;o;;IilO\"
            A$ = A$ + "]mcoaff?o7KKolO\]mcoaff?o7KKolO\]mcoaff?o7KKolO\]mcoaff?o7KKolO\]mcoaff?o;KIkl?\Febo:O;Zo3[E]l?\Febo"
            A$ = A$ + "`JE;o3[E]l?\Febo`JE;o3[E]l?\Febo`JE;o3[E]l?\Febo`JE;o3[E]l?\Febo`JE;o3[E]l_bgRjo%%%0"
        CASE "checkbox.png"
            A$ = MKI$(13) + MKI$(104)
            A$ = A$ + "0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLloeLcmoGc=goO=gLoOfNkmoK3>h"
            A$ = A$ + "ok]hRo_hUGnoUS>joW>k\o?k_ono_7Olo3HDLl?PAaaoGc=goO=gLoOfNkmoK3>hok]hRo_hUGnoUS>joW>k\o?k_ono_7Olo7ol"
            A$ = A$ + "co?PAaao0657oO=gLoOfNkmoK3>hok]hRo_hUGnoUS>joW>k\o?k_ono_7Olo7olco?meGoo0657o3HDLlOfNkmoK3>hok]hRo_h"
            A$ = A$ + "UGnoUS>joW>k\o?k_ono_7Olo7olco?meGoofOomo3HDLl?PAaaoK3>hok]hRo_hUGnoUS>joW>k\o?k_ono_7Olo7olco?meGoo"
            A$ = A$ + "fOomoSOnio?PAaao0657ok]hRo_hUGnoUS>joW>k\o?k_ono_7Olo7olco?meGoofOomoSOnio_nk_oo0657o3HDLl_hUGnoUS>j"
            A$ = A$ + "oW>k\o?k_ono_7Olo7olco?meGoofOomoSOnio_nk_oolgOoo3HDLl?PAaaoUS>joW>k\o?k_ono_7Olo7olco?meGoofOomoSOn"
            A$ = A$ + "io_nk_oolgOook_ono?PAaao0657oW>k\o?k_ono_7Olo7olco?meGoofOomoSOnio_nk_oolgOook_onooooooo0657o3HDLl?k"
            A$ = A$ + "_ono_7Olo7olco?meGoofOomoSOnio_nk_oolgOook_onoooooooooooo3HDLl?PAaao_7Olo7olco?meGoofOomoSOnio_nk_oo"
            A$ = A$ + "lgOook_onooooooooooooooooo?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657"
            A$ = A$ + "o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao?3oooKLkoo_^Yooo\B^oocig"
            A$ = A$ + "no?SIgoo4JMoocgdlo?M@coo[alno?6bko?PAaao0657oKLkoo_^Yooo\B^oocigno?SIgoo4JMoocgdlo?M@coo[alno?6bko_F"
            A$ = A$ + "5[oo0657o3HDLl_^Yooo\B^oo?niWoohWOnoSOnio?niWoohWOnoSOnio?niWo_F5[ooD9\no3HDLl?PAaao\B^oocignoohWOno"
            A$ = A$ + "SOnio?niWoohWOnoSOnio?niWoohWOnoD9\nok4`jo?PAaao0657ocigno?SIgooSOnio?niWoohWOnoSOnio?niWoohWOnoSOni"
            A$ = A$ + "ok4`jo?BmVoo0657o3HDLl?SIgoo4JMoo?niWoohWOnoSOnio?niWoohWOnoSOnio?niWo?BmVoo3]Kno3HDLl?PAaao4JMoocgd"
            A$ = A$ + "loohWOnoSOnio?niWoohWOnoSOnio?niWoohWOno3]KnokC^io?PAaao0657ocgdlo?M@cooSOnio?niWoohWOnoSOnio?niWooh"
            A$ = A$ + "WOnoSOniokC^io_>gVoo0657o3HDLl?M@coo[alno?niWoohWOnoSOnio?niWoohWOnoSOnio?niWo_>gVoofH;no3HDLl?PAaao"
            A$ = A$ + "[alno?6bko_F5[ooD9\nok4`jo?BmVoo3]KnokC^io_>gVoofH;no?3]ho?PAaao0657o?6bko_F5[ooD9\nok4`jo?BmVoo3]Kn"
            A$ = A$ + "okC^io_>gVoofH;no?3]ho?<cRoo0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HD"
            A$ = A$ + "Ll?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657oO:\`noY`2koW2;\o[j\cnO["
            A$ = A$ + "gNkoa^;_oKK`1oo^6Olo0cLcoGLdBo?bEOmo0657o3HDLloY`2koW2;\o[j\cnO[gNkoa^;_oKK`1oo^6Olo0cLcoGLdBo?bEOmo"
            A$ = A$ + "<[mfo3HDLl?PAaaoW2;\o[j\cnO[gNkoa^;_oKK`1oo^6Olo0cLcoGLdBo?bEOmo<[mfooLgOo?PAaao0657o[j\cnO[gNkoa^;_"
            A$ = A$ + "oKK`1oo^6Olo0cLcoGLdBo?bEOmo<[mfooLgOoodQ?no0657o3HDLlO[gNkoa^;_oKK`1oo^6Olo0cLcoGLdBo?bEOmo<[mfooLg"
            A$ = A$ + "OoodQ?noFG^io3HDLl?PAaaoa^;_oKK`1oo^6Olo0cLcoGLdBo?bEOmo<[mfooLgOoodQ?noFG^ioW=jZo?PAaao0657oKK`1oo^"
            A$ = A$ + "6Olo0cLcoGLdBo?bEOmo<[mfooLgOoodQ?noFG^ioW=jZoof[gno0657o3HDLlo^6Olo0cLcoGLdBo?bEOmo<[mfooLgOoodQ?no"
            A$ = A$ + "FG^ioW=jZoof[gnoMgnko3HDLl?PAaao0cLcoGLdBo?bEOmo<[mfooLgOoodQ?noFG^ioW=jZoof[gnoMgnkoomkao?PAaao0657"
            A$ = A$ + "oGLdBo?bEOmo<[mfooLgOoodQ?noFG^ioW=jZoof[gnoMgnkoomkaoog_7oo0657o3HDLl?bEOmo<[mfooLgOoodQ?noFG^ioW=j"
            A$ = A$ + "Zoof[gnoMgnkoomkaoog_7ooOoNlo3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?P"
            A$ = A$ + "Aaao9G\aoWLa6oOb5Klo9G\aoWLa6oOb5Klo9G\aoWLa6oOb5Klo9G\aoWLa6oOb5Klo9G\aoWLa6ooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooWLa6oOb5Klooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooOb5Klo9G\aoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo9G\aoWLa6ooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooWLa6oOb5Klooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooOb5Klo9G\aoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo9G\aoWLa6ooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooWLa6oOb5Klooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooOb5Klo9G\aoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo9G\aoWLa"
            A$ = A$ + "6ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooWLa6oOb5Klooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooOb5Klo9G\aoWLa6oOb5Klo9G\aoWLa6oOb5Klo9G\aoWLa6oOb5Klo9G\aoWLa6oOb5Klo"
            A$ = A$ + "9G\ao3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaaoM;^hog]hRoOgR;noO?nh"
            A$ = A$ + "o7NiUoohWOnoV[^joW>k\o?k_ono_7Olo7olco?PAaao0657og]hRoOgR;noO?nho7NiUoohWOnoV[^joW>k\o?k_ono_7Olo7ol"
            A$ = A$ + "cooleGoo0657o3HDLlOgR;noO?nho7NiUoohWOnoV[^joW>k\o?k_ono_7Olo7BXQloleGoofOomo3HDLl?PAaaoO?nho7NiUooh"
            A$ = A$ + "WOnoV[^joW>k\o?k_ono_7Olo7BXQlO8Q6bofOomoSOnio?PAaao0657o7NiUoohWOnoQ4J8oW>k\o?k_ono_7Olo7BXQlO8Q6bo"
            A$ = A$ + "Q4J8oSOnioOnj[oo0657o3HDLlohWOnoV[^jo7BXQlO8Q6bo_7Olo7BXQlO8Q6boQ4J8oSOnioOnj[ookc?oo3HDLl?PAaaoV[^j"
            A$ = A$ + "oW>k\oO8Q6boQ4J8o7BXQlO8Q6boQ4J8oSOnioOnj[ookc?oogOomo?PAaao0657oW>k\o?k_ono_7Olo7BXQlO8Q6boQ4J8oSOn"
            A$ = A$ + "ioOnj[ookc?oogOomo_onkoo0657o3HDLl?k_ono_7Olo7olcooleGooQ4J8oSOnioOnj[ookc?oogOomo_onkooooooo3HDLl?P"
            A$ = A$ + "Aaao_7Olo7olcooleGoofOomoSOnioOnj[ookc?oogOomo_onkoooooooooooo?PAaao0657o7olcooleGoofOomoSOnioOnj[oo"
            A$ = A$ + "kc?oogOomo_onkoooooooooooooooooo0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657"
            A$ = A$ + "o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657oo<loo_a]ooojVnooc:i"
            A$ = A$ + "no?WOkoo<VMooW8fmoOUKgooGbMooOXelo_J:_oo0657o3HDLl_a]ooojVnooc:ino?WOkoo<VMooW8fmoOUKgoo\>NooK[imo_X"
            A$ = A$ + "Ngooj1mno3HDLl?PAaaomZnoocKjnoOmgOoodK_mo??mdo?mfKoogS?noW_njoO8Q6bo^>Noo3Xdko?PAaao0657ocKjno?a\koo"
            A$ = A$ + "i[_noO?nho?mfKoogS?noW_njoO8Q6boQ4J8o_JhmooN@_oo0657o3HDLlO]Wkoo7c^oo7BXQlOnj[oogS?noW_njoO8Q6boQ4J8"
            A$ = A$ + "o7BXQl?ZPgoogilno3HDLl?PAaaoY>^oo?ljnoO8Q6boQ4J8oW_njoO8Q6boQ4J8o7BXQlOnj[ooBRmnoO6bjo?PAaao0657o?:h"
            A$ = A$ + "noo_YkooQ4J8o7BXQlO8Q6boQ4J8o7BXQlOnj[oogS?noO6bjo_AlVoo0657o3HDLlOUKgoo\>NooW_njoO8Q6boQ4J8o7BXQlOn"
            A$ = A$ + "j[oogS?noC_mfo_AlVoojLKno3HDLl?PAaaoj9=ooOXeloomhSooi[_no7BXQlOnj[oogS?noC_mfooldCoojLKnoKS]ho?PAaao"
            A$ = A$ + "0657o_6cko_J:_ooj1mnoWiflo?ZPgooBRmnoO6bjo_AlVoojLKnoKS]hoo<dRoo0657o3HDLloH8_ooJE\no_Eajo?L<_oogiln"
            A$ = A$ + "oO6bjo_AlVoojLKnoKS]hoo<dRoo`<;no3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HD"
            A$ = A$ + "Ll?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLloY`2koW2;\oO:\`n_Z"
            A$ = A$ + "c>ko]Nk]o7k^ln_]17lokJlao3<c=oOaA;mo8Gmeo3HDLl?PAaaoW2;\oO:\`n_Zc>ko]Nk]o7k^ln_]17lokJlao3<c=oOaA;mo"
            A$ = A$ + "8Gmeoc\fKo?PAaao0657oO:\`n_Zc>ko]Nk]o7k^ln_]17lokJlao3<c=oOaA;moJH87oc\fKoocMomo0657o3HDLl_Zc>ko]Nk]"
            A$ = A$ + "o7k^ln_]17lokJlao3<c=oOaA;moJH87o[QRLlocMomoC7nho3HDLl?PAaao]Nk]o7k^ln?6jUaokJlao3<c=oOaA;moJH87o[QR"
            A$ = A$ + "Llo6<faoC7nhoKMiVo?PAaao0657o7k^ln_]17loHdW6oWAPKlOaA;moJH87o[QRLlo6<faoC7nhoKMiVoOfX[no0657o3HDLl_]"
            A$ = A$ + "17lokJlaoWAPKlO64^aoJH87o[QRLlo6<faoC7nhoKMiVoOfX[noK_Nko3HDLl?PAaaokJlao3<c=oOaA;moJH87o[QRLlo6<fao"
            A$ = A$ + "C7nhoKMiVoOfX[noK_NkogMk_o?PAaao0657o3<c=oOaA;mo8Gmeoc\fKoo6<faoC7nhoKMiVoOfX[noK_NkogMk_oog_7oo0657"
            A$ = A$ + "o3HDLlOaA;mo8Gmeoc\fKoocMomoC7nhoKMiVoOfX[noK_NkogMk_oog_7ooOoNlo3HDLl?PAaao8Gmeoc\fKoocMomoC7nhoKMi"
            A$ = A$ + "VoOfX[noK_NkogMk_oog_7ooOoNloomkao?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?P"
            A$ = A$ + "Aaao0657oWLa6oOb5Klo9G\aoWLa6oOb5Klo9G\aoWLa6oOb5Klo9G\aoWLa6oOb5Klo9G\aoWLa6oOb5Klooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooooOb5Klo9G\aoooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooo9G\aoWLa6ooooooooooooooooooooooooooooooooooooooooooooWLa6ooooooooooooWLa6oOb5Klooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooWLa6oOb5KloooooooooooOb5Klo9G\aoooooooooooo9G\aoooooooooooooooooWLa6oOb"
            A$ = A$ + "5Klo9G\aoooooooooooo9G\aoWLa6ooooooooooooWLa6oOb5KlooooooWLa6oOb5Klo9G\aoooooooooooooooooWLa6oOb5Klo"
            A$ = A$ + "ooooooooooOb5Klo9G\aoWLa6oOb5Klo9G\aooooooooooooooooooooooOb5Klo9G\aoooooooooooooooooWLa6oOb5Klo9G\a"
            A$ = A$ + "oooooooooooooooooooooooooooo9G\aoWLa6ooooooooooooooooooooooo9G\aoooooooooooooooooooooooooooooooooWLa"
            A$ = A$ + "6oOb5KloooooooooooooooooooooooooooooooooooooooooooooooooooooooooooOb5Klo9G\aoooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooo9G\aoWLa6oOb5Klo9G\aoWLa6oOb5Klo9G\aoWLa6oOb5Klo9G\aoWLa6oOb5Klo"
            A$ = A$ + "9G\aoWLa%6o?"
        CASE "notfound.png"
            A$ = MKI$(40) + MKI$(48)
            A$ = A$ + "S=fHnS6JXM?JXQfmXQ6JgS6JXM?JXQfmXQ6JgS6JXM?JXQfmXQ6JgS6JXM?JXQfmXQ6JgS6JXM?JXQfmXQ6JgS6JXM?JXQfmXQ6J"
            A$ = A$ + "gS6JXM?JXQfmXQ6JgS6JXM?JXQfmXQ6JgS6JXM?JXQfmVIVIkWFJYi4000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000XVJZIoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooooooooooooooooooo7GLam?L`1glUEFI>100000000000000000000000000"
            A$ = A$ + "00000000000000000000000000PJZYVmoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo?MdAgoTC>io37L`9oIWMFC00000000"
            A$ = A$ + "0000000000000000000000000000000000000000ZYVJfooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooodA7Mo[_njo?jXSno"
            A$ = A$ + "`17LbGFIUa4000000000000000000000000000000000000000000XVJZIoooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooC7M"
            A$ = A$ + "dm_nj[oooooooOniWo?L`1WlUEFI<1000000000000000000000000000000000000PJZYVmoooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooo?MdAgoj[_nooooooooooooWOnio37L`5?ITAFA00000000000000000000000000000000ZYVJfooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooodA7Mo[_njooooooooooooooooooiWOno`17LaGFIUA400000000000000000000000000XVJZIoo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooC7Mdm_nj[oooooooooooooooooooooooOniWo?L`17lS=fH3100000000000000"
            A$ = A$ + "000000PJZYVmoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooo?MdAgoj[_nooooooooooooooooooooooooooooWOnioofK_5?I"
            A$ = A$ + "TAV@0000000000000000ZYVJfooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooodA7Mo[_njooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooohS?no^iVKb;VHR540000000000XVJZIoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooC7Mdm_nj[oooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooo;^hRo_K^iVlR9VH110000PJZYVmoooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo?MdAgoj[_n"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooooooR;^hokVK^9?ITA6@ZYVJfooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooomgOogFK]mOK]efo]eFKogFK]mOK]efo]eFKogFK]mOK]efo]eFKogFK]moJ[]foVIVIj[VJZIoooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo[VJZI_JZYVmoooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooo_mfKooQ7Nho7NhQoOhQ7noQ7Nho7NhQoOhQ7noQ7Nho7NhQoOhQ7noQ7Nho7NhQoOh"
            A$ = A$ + "Q7noQ7Nho7NhQoOhQ7noQ7Nho7NhQoOhQ7noQ7Nho7NhQo_mfKoooooooooooooooooooooooooooooooooooooooooooo_JZYVm"
            A$ = A$ + "ZYVJfoooooooooooooooooooooooooooooooooooooooooooFK]eoWK^in_b:[lo:[\bo[\b:o_b:[lo:[\bo[\b:o_b:[lo:[\b"
            A$ = A$ + "o[\b:o_b:[lo:[\bo[\b:o_b:[lo:[\bo[\b:o_b:[lo:[\bo[\b:oO^iVkoFK]eoooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooZYVJf[VJZIoooooooooooooooooooooooooooooooooooooooooooK]eFo_eFKmooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooFK]eoK]eFooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooo[VJZI_JZYVmoooooooooooooooooooooooooooooooooooooooooo_eFKmoFK]eoooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooK]eFo_eFKmooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooo_JZYVmZYVJfoooooooooooooooooooooooooooooooooooooooooooFK]eoK]eFooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo_eFKmo"
            A$ = A$ + "FK]eooooooooooooooooooooooooooooooooooooooooooooZYVJf[VJZIoooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oK]eFo_eFKmooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooFK]eoK]eFoooooooooooooooooooooooooooooooooooooooooooo[VJZI_JZYVmoooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooo_eFKmoFK]eoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooK]eFo_eFKmooooooooooooooooooooooooooooooooooooooooooo_JZYVmZYVJfooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooFK]eoK]eFooooooooooooooooo_lbgooc=WkoC=ejooooooooooooooooooooooooooooooo"
            A$ = A$ + "oo?eD[ooc=Wko;_lmooooooooooooooooo_eFKmoFK]eooooooooooooooooooooooooooooooooooooooooooooZYVJf[VJZIoo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooK]eFo_eFKmooooooooooooooooo5G<no300PoO5E<noB;]noooooooooooo"
            A$ = A$ + "oooooooooo_dB[ooEDaho300PoOa5SooooooooooooooooooFK]eoK]eFooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "o[VJZI_JZYVmoooooooooooooooooooooooooooooooooooooooooo_eFKmoFK]eoooooooooooooooooooooooNkmno000hoGA5"
            A$ = A$ + "SoodC[ooooooooooooodC[ooEDaho300PooNkmnooooooooooooooooooooooK]eFo_eFKmooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooo_JZYVmZYVJfoooooooooooooooooooooooooooooooooooooooooooFK]eoK]eFooooooooooooooooooooooo"
            A$ = A$ + "oooooc7O_o?000noEDaho?mdjooeG[ooHPaho300Po?Mdinooooooooooooooooooooooooooo_eFKmoFK]eoooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooZYVJf[VJZIoooooooooooooooooooooooooooooooooooooooooooK]eFo_eFKmooooooooo"
            A$ = A$ + "ooooooooooooooooooooooook]gko300Poo4C8noEDaho300PooLcinoooooooooooooooooooooooooooooooooFK]eoK]eFooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooo[VJZI_JZYVmoooooooooooooooooooooooooooooooooooooooooo_eFKmo"
            A$ = A$ + "FK]eoooooooooooooooooooooooooooooooooooooooIWano000ho300PooGOanooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oK]eFo_eFKmooooooooooooooooooooooooooooooooooooooooooo_JZYVmZYVJfooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooFK]eoK]eFoooooooooooooooooooooooooooooooooOfI[ooJXaho300Po?000noFHahoC=ejooooooooooooooooooo"
            A$ = A$ + "oooooooooooooo_eFKmoFK]eooooooooooooooooooooooooooooooooooooooooooooZYVJf[VJZIoooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooK]eFo_eFKmoooooooooooooooooooooooooooOfI[ooJXaho300Po?L`inoiUgko300Poo5G<noEG]n"
            A$ = A$ + "ooooooooooooooooooooooooooooFK]eoK]eFoooooooooooooooooooooooooooooooooooooooooooo[VJZI_JZYVmoooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooo_eFKmoFK]eoooooooooooooooooooooo_fJ[ooJXaho300Po?L`inooooooooooo?N"
            A$ = A$ + "hmno000hoOa5SoOeE[oooooooooooooooooooooooK]eFo_eFKmooooooooooooooooooooooooooooooooooooooooooo_JZYVm"
            A$ = A$ + "ZYVJfoooooooooooooooooooooooooooooooooooooooooooFK]eoK]eFooooooooooooooooo?jXcooJXaho300PooK_enooooo"
            A$ = A$ + "ooooooooooooooooo37L^o?000noJXahoOnilooooooooooooooooo_eFKmoFK]eoooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooZYVJf[VJZIoooooooooooooooooooooooooooooooooooooooooooK]eFo_eFKmoooooooooooooooooA7MnoG@1Qo?L"
            A$ = A$ + "`inonkoooooooooooooooooooooooo_onoooa5WkoG@1Qo?d@WooooooooooooooooooFK]eoK]eFooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooo[VJZI_JZYVmoooooooooooooooooooooooooooooooooooooooooo_eFKmoFK]eoooooooooooooooo"
            A$ = A$ + "oooooo_mfkoooooooooooooooooooooooooooooooooooooooooooo_mfkoooooooooooooooooooooooK]eFo_eFKmooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooo_JZYVmZYVJfoooooooooooooooooooooooooooooooooooooooooooFK]eoK]eFooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo_eFKmo"
            A$ = A$ + "FK]eooooooooooooooooooooooooooooooooooooooooooooZYVJf[VJZIoooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oK]eFo_eFKmooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooFK]eoK]eFoooooooooooooooooooooooooooooooooooooooooooo[VJZI_JZYVmoooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooo_eFKmoFK]eoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooK]eFo_eFKmooooooooooooooooooooooooooooooooooooooooooo_JZYVmZYVJfooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooFK]eoK]eFooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooo_eFKmoFK]eooooooooooooooooooooooooooooooooooooooooooooZYVJf[VJZIoo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooK]eFo?d@3moc?olo?olcoolc?ooc?olo?olcoolc?ooc?olo?olcoolc?oo"
            A$ = A$ + "c?olo?olcoolc?ooc?olo?olcoolc?ooc?olo?olcoolc?oo@3=doK]eFooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "o[VJZI_JZYVmoooooooooooooooooooooooooooooooooooooooooo_hR;nohR;^oS;^hn?^hRkohR;^oS;^hn?^hRkohR;^oS;^"
            A$ = A$ + "hn?^hRkohR;^oS;^hn?^hRkohR;^oS;^hn?^hRkohR;^oS;^hn?^hRkohR;^oS;^hn_hR;nooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooo_JZYVmZYVJfooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooZYVJf[VJZIoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooo[VJZI_JZYVmoooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooo_JZYVmZYVJfooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooZYVJf[VJZIoooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo[VJZI_JZYVmoooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo_JZYVm"
            A$ = A$ + "ZYVJfooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooZYVJf[VJZIoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooo[VJZIoHS=VoXQ6JgS6JXM?JXQfmXQ6JgS6JXM?JXQfmXQ6JgS6JXM?JXQfmXQ6JgS6JXM?JXQfmXQ6J"
            A$ = A$ + "gS6JXM?JXQfmXQ6JgS6JXM?JXQfmXQ6JgS6JXM?JXQfmXQ6JgS6JXM?JXQfmXQ6JgS6JXM?JXQfmXQ6JgS6JXM?JXQfmXQ6JgS6J"
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

    STATIC ControlImage AS LONG
    CONST ButtonHeight = 21
    CONST ButtonWidth = 18

    IF ControlImage = 0 THEN ControlImage = __UI_LoadThemeImage("button.png")

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

    STATIC ControlImage AS LONG
    CONST ImageHeight = 13
    CONST ImageWidth = 13

    IF ControlImage = 0 THEN ControlImage = __UI_LoadThemeImage("radiobutton.png")

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

    STATIC ControlImage AS LONG
    CONST ImageHeight = 13
    CONST ImageWidth = 13

    IF ControlImage = 0 THEN ControlImage = __UI_LoadThemeImage("checkbox.png")

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

    IF ControlImage_Chunk = 0 THEN ControlImage_Chunk = __UI_LoadThemeImage("progresschunk.png")
    IF ControlImage_Track = 0 THEN ControlImage_Track = __UI_LoadThemeImage("progresstrack.png")

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
        'Back
        _PUTIMAGE (5, 4)-STEP(This.Width - 9, This.Height - 8), ControlImage_Track, , (5, 4)-STEP(0, 11)

        'Left side
        _PUTIMAGE (0, 0), ControlImage_Track, , (0, 0)-(4, 4) 'top corner
        _PUTIMAGE (0, This.Height - 3), ControlImage_Track, , (0, 16)-STEP(3, 2) 'bottom corner
        _PUTIMAGE (0, 4)-(4, This.Height - 4), ControlImage_Track, , (0, 4)-STEP(4, 11) 'vertical stretch

        'Right side
        _PUTIMAGE (This.Width - 4, 0), ControlImage_Track, , (6, 0)-STEP(2, 3) 'top corner
        _PUTIMAGE (This.Width - 4, This.Height - 3), ControlImage_Track, , (6, 16)-STEP(2, 3) 'bottom corner
        _PUTIMAGE (This.Width - 4, 4)-STEP(2, This.Height - 8), ControlImage_Track, , (6, 4)-STEP(2, 11) 'vertical stretch

        'Top
        _PUTIMAGE (4, 0)-STEP(This.Width - 9, 3), ControlImage_Track, , (4, 0)-STEP(1, 3)

        'Bottom
        _PUTIMAGE (4, This.Height - 3)-STEP(This.Width - 9, 2), ControlImage_Track, , (4, 16)-STEP(1, 2)

        'Draw progress
        IF This.Value THEN
            _PUTIMAGE (4, 3)-STEP(((This.Width - 9) / This.Max) * This.Value, This.Height - 7), ControlImage_Chunk
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
                _PRINTSTRING (This.Width \ 2 - _PRINTWIDTH(TempCaption$) \ 2, This.Height \ 2 - _FONTHEIGHT \ 2 + 1), TempCaption$
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

        This.Canvas = _NEWIMAGE(This.Width, This.Height, 32)

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
        CaptionIndent = ABS(This.HasBorder) * 5

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

                    IF ThisItem% = This.Value AND __UI_Focus = This.ID THEN __UI_Captions(This.ID) = TempCaption$

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

            IF This.HasBorder = __UI_True THEN
                LINE (0, 0)-STEP(This.Width - 1, This.Height - 1), This.BorderColor, B
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
    CONST ImageHeight_Button = 17
    CONST ImageWidth_Button = 17
    CONST ImageHeight_Thumb = 22
    CONST ImageWidth_Thumb = 15

    IF ControlImage_Button = 0 THEN ControlImage_Button = __UI_LoadThemeImage("scrollbuttons.png")
    IF ControlImage_Track = 0 THEN ControlImage_Track = __UI_LoadThemeImage("scrolltrack.png")
    IF ControlImage_Thumb = 0 THEN ControlImage_Thumb = __UI_LoadThemeImage("scrollthumb.png")

    This = TempThis

    IF This.Type = __UI_Type_ListBox THEN
        This.Min = 0
        This.Max = This.Max - This.LastVisibleItem
        This.Value = This.InputViewStart - 1
        This.Left = This.Width - __UI_ScrollbarWidth - 1
        This.Top = 1
        This.Height = This.Height - 1
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

    STATIC ControlImage AS LONG
    STATIC ControlImage_Arrow AS LONG
    CONST ButtonHeight = 21
    CONST ButtonWidth = 18
    CONST ArrowWidth = 9
    CONST ArrowHeight = 9

    IF ControlImage = 0 THEN ControlImage = __UI_LoadThemeImage("button.png")
    IF ControlImage_Arrow = 0 THEN
        ControlImage_Arrow = __UI_LoadThemeImage("arrows.png")
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

                    IF ThisItem% = This.Value AND __UI_Focus = This.ID THEN __UI_Captions(This.ID) = TempCaption$

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

    STATIC ControlImage AS LONG

    IF ControlImage = 0 THEN
        ControlImage = __UI_LoadThemeImage("frame.png")
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
SUB __UI_DrawPictureBox (This AS __UI_ControlTYPE, ControlState AS _BYTE)
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

