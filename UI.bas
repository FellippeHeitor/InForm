OPTION _EXPLICIT

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
    HWCanvas AS LONG
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
REDIM SHARED __UI_MenubarItems(0) AS __UI_ControlTYPE

DIM SHARED __UI_Fonts(2) AS LONG
__UI_Fonts(0) = 16
__UI_Fonts(1) = 8
__UI_Fonts(2) = __UI_LoadFont("arial.ttf", 14, "")

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
DIM SHARED __UI_DraggingThumb AS _BYTE
DIM SHARED __UI_DraggingThumbOnID AS LONG
DIM SHARED __UI_HasInput AS _BYTE, __UI_LastInputReceived AS DOUBLE
DIM SHARED __UI_UnloadSignal AS _BYTE
DIM SHARED __UI_ExitTriggered AS _BYTE
DIM SHARED __UI_Loaded AS _BYTE
DIM SHARED __UI_RefreshTimer AS INTEGER
DIM SHARED __UI_ActiveDropdownList AS LONG, __UI_ParentDropdownList AS LONG
DIM SHARED __UI_FormID AS LONG, __UI_MenuBarID AS LONG
DIM SHARED __UI_ScrollbarWidth AS INTEGER
DIM SHARED __UI_ScrollbarButtonHeight AS INTEGER
DIM SHARED __UI_ForceRedraw AS _BYTE

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
CONST __UI_Type_MenuPanel = 12
CONST __UI_Type_MultiLineTextBox = 13

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

NewID = __UI_NewControl(__UI_Type_Form, "Form1", 640, 400, 0)
__UI_Controls(__UI_FormID).Font = 2
__UI_SetCaption "Form1", "Hello, world!"

NewID = __UI_NewControl(__UI_Type_MenuBar, "MenuBar1", 0, 0, 0)
__UI_SetText "MenuBar1", "&File\&Edit\&View\\&Help"

NewID = __UI_NewControl(__UI_Type_Button, "Button1", 0, 0, 0)
__UI_Controls(NewID).Top = 100
__UI_Controls(NewID).Left = 230
__UI_Controls(NewID).Width = 73
__UI_Controls(NewID).Height = 21
__UI_Controls(NewID).CanHaveFocus = __UI_True
__UI_SetCaption "Button1", "&Click me"

NewID = __UI_NewControl(__UI_Type_Button, "Button2", 0, 0, 0)
__UI_Controls(NewID).Top = 200
__UI_Controls(NewID).Left = 100
__UI_Controls(NewID).Width = 230
__UI_Controls(NewID).Height = 23
__UI_Controls(NewID).CanHaveFocus = __UI_True
__UI_SetCaption "Button2", "Detach ListBox from frame"

NewID = __UI_NewControl(__UI_Type_Label, "TBLabel", 0, 0, 0)
__UI_Controls(NewID).Top = 230
__UI_Controls(NewID).Left = 30
__UI_Controls(NewID).Width = 150
__UI_Controls(NewID).Height = 20
__UI_SetCaption "TBLabel", "&Add items to the list:"

NewID = __UI_NewControl(__UI_Type_TextBox, "Textbox1", 0, 0, 0)
__UI_Controls(NewID).Top = 250
__UI_Controls(NewID).Left = 30
__UI_Controls(NewID).Width = 250
__UI_Controls(NewID).Height = 23
__UI_Controls(NewID).CanHaveFocus = __UI_True
__UI_Controls(NewID).Font = 3
__UI_SetCaption "Textbox1", "Edit me"

NewID = __UI_NewControl(__UI_Type_Button, "AddItemBT", 0, 0, 0)
__UI_Controls(NewID).Top = 250
__UI_Controls(NewID).Left = 290
__UI_Controls(NewID).Width = 90
__UI_Controls(NewID).Height = 23
__UI_Controls(NewID).CanHaveFocus = __UI_True
__UI_SetCaption "AddItemBT", "Add Item"

NewID = __UI_NewControl(__UI_Type_Button, "DragButton", 0, 0, 0)
__UI_Controls(NewID).Top = 300
__UI_Controls(NewID).Left = 100
__UI_Controls(NewID).Width = 200
__UI_Controls(NewID).Height = 23
__UI_Controls(NewID).CanHaveFocus = __UI_True
__UI_SetCaption "DragButton", "Make ListBox draggable"

NewID = __UI_NewControl(__UI_Type_Label, "Label1", 0, 0, 0)
__UI_Controls(NewID).Top = 30
__UI_Controls(NewID).Left = 10
__UI_Controls(NewID).Width = 400
__UI_Controls(NewID).Height = 20
__UI_Controls(NewID).ForeColor = _RGB32(238, 238, 200)
__UI_Controls(NewID).BackColor = _RGB32(33, 100, 78)
__UI_Controls(NewID).Align = __UI_Center
__UI_SetCaption "Label1", "Waiting for you to click"

NewID = __UI_NewControl(__UI_Type_Label, "FocusLabel", 0, 0, 0)
__UI_Controls(NewID).Top = 55
__UI_Controls(NewID).Left = 10
__UI_Controls(NewID).Width = 400
__UI_Controls(NewID).Height = 20
__UI_SetCaption "FocusLabel", "No control has focus now"

NewID = __UI_NewControl(__UI_Type_Label, "HoverLabel", 0, 0, 0)
__UI_Controls(NewID).Top = 75
__UI_Controls(NewID).Left = 10
__UI_Controls(NewID).Width = 400
__UI_Controls(NewID).Height = 20

NewID = __UI_NewControl(__UI_Type_Label, "Label2", 0, 0, 0)
__UI_Controls(NewID).Top = 350
__UI_Controls(NewID).Left = 30
__UI_Controls(NewID).Width = 300
__UI_Controls(NewID).Height = 20
__UI_Controls(NewID).BackStyle = __UI_Transparent

NewID = __UI_NewControl(__UI_Type_Frame, "Frame1", 230, 150, 0)
__UI_Controls(NewID).Top = 60
__UI_Controls(NewID).Left = 400
__UI_SetCaption "Frame1", "&Text box options + List"

NewID = __UI_NewControl(__UI_Type_RadioButton, "Option1", 0, 0, __UI_GetID("Frame1"))
__UI_Controls(NewID).Top = 15
__UI_Controls(NewID).Left = 15
__UI_Controls(NewID).Width = 130
__UI_Controls(NewID).Height = 17
__UI_Controls(NewID).Value = __UI_True
__UI_Controls(NewID).CanHaveFocus = __UI_True
__UI_SetCaption "Option1", "A&LL CAPS"

NewID = __UI_NewControl(__UI_Type_RadioButton, "Option2", 0, 0, __UI_GetID("Frame1"))
__UI_Controls(NewID).Top = 40
__UI_Controls(NewID).Left = 15
__UI_Controls(NewID).Width = 110
__UI_Controls(NewID).Height = 17
__UI_Controls(NewID).CanHaveFocus = __UI_True
__UI_SetCaption "Option2", "&Normal"

NewID = __UI_NewControl(__UI_Type_CheckBox, "Check1", 0, 0, __UI_GetID("Frame1"))
__UI_Controls(NewID).Top = 65
__UI_Controls(NewID).Left = 15
__UI_Controls(NewID).Width = 150
__UI_Controls(NewID).Height = 17
__UI_Controls(NewID).CanHaveFocus = __UI_True
__UI_SetCaption "Check1", "Allow n&umbers"

NewID = __UI_NewControl(__UI_Type_CheckBox, "Check2", 0, 0, __UI_GetID("Frame1"))
__UI_Controls(NewID).Top = 90
__UI_Controls(NewID).Left = 15
__UI_Controls(NewID).Width = 150
__UI_Controls(NewID).Height = 17
__UI_Controls(NewID).Value = __UI_True
__UI_Controls(NewID).CanHaveFocus = __UI_True
__UI_SetCaption "Check2", "Allow l&etters"

NewID = __UI_NewControl(__UI_Type_DropdownList, "ListBox1", 0, 0, __UI_GetID("Frame1"))
__UI_Controls(NewID).Top = 110
__UI_Controls(NewID).Left = 15
__UI_Controls(NewID).Width = 200
__UI_Controls(NewID).Height = 25
__UI_Controls(NewID).CanHaveFocus = __UI_True
__UI_AddListBoxItem "ListBox1", "Type in the textbox"
__UI_AddListBoxItem "ListBox1", "to add items here"
DIM i AS INTEGER
FOR i = 3 TO 120
    __UI_AddListBoxItem "ListBox1", "Item" + STR$(i)
NEXT i
__UI_Controls(NewID).Value = 1

NewID = __UI_NewControl(__UI_Type_ProgressBar, "ProgressBar1", 0, 0, 0)
__UI_Controls(NewID).Top = 370
__UI_Controls(NewID).Left = 30
__UI_Controls(NewID).Width = 300
__UI_Controls(NewID).Height = 23
__UI_Controls(NewID).ShowPercentage = __UI_True
__UI_SetCaption "ProgressBar1", "Ready"

NewID = __UI_NewControl(__UI_Type_Button, "STARTTASK", 0, 0, 0)
__UI_Controls(NewID).Top = 370
__UI_Controls(NewID).Left = 340
__UI_Controls(NewID).Width = 130
__UI_Controls(NewID).Height = 23
__UI_Controls(NewID).CanHaveFocus = __UI_True
__UI_SetCaption "STARTTASK", "Start task"

NewID = __UI_NewControl(__UI_Type_Button, "OkButton", 0, 0, 0)
__UI_Controls(NewID).Top = 370
__UI_Controls(NewID).Left = 550
__UI_Controls(NewID).Width = 70
__UI_Controls(NewID).Height = 23
__UI_Controls(NewID).CanHaveFocus = __UI_True
__UI_SetCaption "OkButton", "OK"
__UI_DefaultButtonID = NewID

'Main loop
DO
    IF __UI_Loaded = __UI_False THEN __UI_Load

    __UI_DoEvents
    _LIMIT 120
LOOP

'---------------------------------------------------------------------------------
SUB __UI_Load
    DIM i AS LONG
    SCREEN _NEWIMAGE(__UI_Controls(__UI_FormID).Width, __UI_Controls(__UI_FormID).Height, 32)
    DO UNTIL _SCREENEXISTS: _LIMIT 10: LOOP

    IF __UI_Controls(__UI_FormID).CenteredWindow THEN _SCREENMOVE _MIDDLE

    'Create main window hardware bg:
    _DEST __UI_Controls(__UI_FormID).Canvas
    COLOR __UI_Controls(__UI_FormID).ForeColor, __UI_Controls(__UI_FormID).BackColor
    CLS
    _DEST 0
    __UI_MakeHardwareImageFromCanvas __UI_Controls(__UI_FormID)

    _DISPLAYORDER _HARDWARE
    _DISPLAY

    'Make sure all textboxes have fixed width fonts;
    'Make sure all controls reference predeclared fonts;
    FOR i = 1 TO UBOUND(__UI_Controls)
        IF __UI_Controls(i).Font > UBOUND(__UI_Fonts) THEN __UI_Controls(i).Font = 0
        IF __UI_Controls(i).Type = __UI_Type_TextBox THEN
            IF _FONTWIDTH(__UI_Fonts(__UI_Controls(i).Font)) = 0 THEN __UI_Controls(i).Font = 0
            __UI_Controls(i).FieldArea = __UI_Controls(i).Width \ _FONTWIDTH(__UI_Fonts(__UI_Controls(i).Font)) - 1
        END IF
    NEXT

    __UI_ThemeSetup

    __UI_RefreshTimer = _FREETIMER
    ON TIMER(__UI_RefreshTimer, .03) __UI_UpdateDisplay
    TIMER(__UI_RefreshTimer) ON

    __UI_Loaded = __UI_True
    __UI_OnLoad
END SUB

'Event procedures: ---------------------------------------------------------------
'Generated at design time - code inside CASE statements to be added by programmer.
'---------------------------------------------------------------------------------
SUB __UI_Click (id AS LONG)
    SELECT CASE UCASE$(RTRIM$(__UI_Controls(id).Name))
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
            DIM i AS LONG, pbid AS LONG
            STATIC RunningTask AS _BYTE

            IF RunningTask THEN
                RunningTask = __UI_False
                EXIT SUB
            END IF

            RunningTask = __UI_True
            __UI_SetCaption "Label2", "Performing task:"
            __UI_Controls(__UI_GetID("ProgressBar1")).Max = 1000000
            __UI_SetCaption "starttask", "Stop task"
            __UI_SetCaption "ProgressBar1", "Counting to 1,000,000... \#"
            __UI_Controls(__UI_GetID("ProgressBar1")).Value = 0
            i = 0
            pbid = __UI_GetID("ProgressBar1")
            DO WHILE i < 1000000
                i = i + 1
                __UI_Controls(pbid).Value = i
                __UI_DoEvents
                IF NOT RunningTask THEN EXIT DO
            LOOP
            RunningTask = __UI_False
            __UI_SetCaption "Label2", "Idle."
            __UI_Controls(__UI_GetID("STARTTASK")).Disabled = __UI_False
            IF i < 1000000 THEN
                __UI_SetCaption "ProgressBar1", "Interrupted."
            ELSE
                __UI_SetCaption "ProgressBar1", "Done."
            END IF
            __UI_SetCaption "starttask", "Start task"
        CASE "DRAGBUTTON"
            __UI_Controls(__UI_GetID("listbox1")).CanDrag = NOT __UI_Controls(__UI_GetID("listbox1")).CanDrag
            IF __UI_Controls(__UI_GetID("listbox1")).CanDrag THEN
                __UI_Captions(__UI_GetID("DragButton")) = "List is draggable"
            ELSE
                __UI_Captions(__UI_GetID("DragButton")) = "List is not draggable"
            END IF
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
    DIM OldScreen&, OldFont&, i AS LONG
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
            IF __UI_Controls(i).ID THEN
                __UI_Controls(i).HoveringVScrollbarButton = 0
                IF __UI_Controls(i).ParentID THEN
                    ContainerOffsetTop = __UI_Controls(__UI_Controls(i).ParentID).Top
                    ContainerOffsetLeft = __UI_Controls(__UI_Controls(i).ParentID).Left
                    'First make sure the mouse is inside the container:
                    IF __UI_MouseLeft >= ContainerOffsetLeft AND __UI_MouseLeft <= ContainerOffsetLeft + __UI_Controls(__UI_Controls(i).ParentID).Width - 1 AND __UI_MouseTop >= ContainerOffsetTop AND __UI_MouseTop <= ContainerOffsetTop + __UI_Controls(__UI_Controls(i).ParentID).Height - 1 THEN
                        'We're in. Now check for individual control:
                        IF __UI_MouseLeft >= ContainerOffsetLeft + __UI_Controls(i).Left AND __UI_MouseLeft <= ContainerOffsetLeft + __UI_Controls(i).Left + __UI_Controls(i).Width - 1 AND __UI_MouseTop >= ContainerOffsetTop + __UI_Controls(i).Top AND __UI_MouseTop <= ContainerOffsetTop + __UI_Controls(i).Top + __UI_Controls(i).Height - 1 THEN
                            TempHover = i
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
                        TempHover = i

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
        __UI_HoveringID = TempHover

        IF __UI_Controls(__UI_HoveringID).Type = __UI_Type_MenuBar THEN
            'Detect which menu item is being hovered
            DIM CheckMenu AS INTEGER
            _FONT __UI_Fonts(__UI_Controls(__UI_HoveringID).Font)
            FOR CheckMenu = 1 TO UBOUND(__UI_MenuBarItems)
                IF __UI_MouseLeft >= __UI_MenubarItems(CheckMenu).Left AND __UI_MouseLeft <= __UI_MenubarItems(CheckMenu).Left + __UI_MenubarItems(CheckMenu).Width THEN
                    __UI_Controls(__UI_HoveringID).Value = CheckMenu
                    EXIT FOR
                END IF
            NEXT
            IF CheckMenu = UBOUND(__UI_MenuBarItems) + 1 THEN __UI_Controls(__UI_HoveringID).Value = 0
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
        OldFont& = _FONT
        SCREEN _NEWIMAGE(__UI_Controls(__UI_FormID).Width, __UI_Controls(__UI_FormID).Height, 32)
        IF LEN(__UI_CurrentTitle) THEN _TITLE __UI_CurrentTitle
        _FONT OldFont&
        _FREEIMAGE OldScreen&
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

    __UI_BeforeUpdateDisplay

    'Clear frames canvases and count its children:
    FOR i = 1 TO UBOUND(__UI_Controls)
        IF __UI_Controls(i).Type = __UI_Type_Frame THEN
            __UI_Controls(i).Value = 0 'Reset children counter
            _DEST __UI_Controls(i).Canvas
            COLOR , __UI_Controls(i).BackColor
            CLS
        ELSE
            IF __UI_Controls(i).ParentID THEN
                'Increase container's children controls counter
                __UI_Controls(__UI_Controls(i).ParentID).Value = __UI_Controls(__UI_Controls(i).ParentID).Value + 1
            END IF
        END IF
    NEXT

    _DEST 0

    IF __UI_IsDragging AND NOT (_KEYDOWN(100305) OR _KEYDOWN(100306)) THEN
        'Draw the alignment grid
        DIM GridX AS INTEGER, GridY AS INTEGER

        IF __UI_Controls(__UI_DraggingID).ParentID THEN
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
        _DEST 0
        __UI_MakeHardwareImageFromCanvas __UI_Controls(__UI_FormID)
    END IF

    'Control drawing
    FOR i = 1 TO UBOUND(__UI_Controls)
        IF __UI_Controls(i).ID > 0 AND NOT __UI_Controls(i).Hidden THEN
            'Direct the drawing to the appropriate canvas (main or container)
            IF __UI_Controls(i).ParentID THEN
                _DEST __UI_Controls(__UI_Controls(i).ParentID).Canvas
            ELSE
                _DEST 0
            END IF

            IF ((__UI_MouseIsDown AND i = __UI_MouseDownOnID) OR (__UI_KeyIsDown AND i = __UI_KeyDownOnID AND __UI_KeyDownOnID = __UI_Focus)) AND NOT __UI_Controls(i).Disabled THEN
                ControlState = 3
            ELSEIF i = __UI_HoveringID AND NOT __UI_Controls(i).Disabled THEN
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
            END SELECT
        END IF

        IF __UI_Controls(i).ParentID THEN
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
            LINE (0, 0)-STEP(_WIDTH, _HEIGHT), _RGBA32(0, 0, 0, 200), BF
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
        _PUTIMAGE , WaitMessage
    END IF

    _DISPLAY
END SUB

'---------------------------------------------------------------------------------
FUNCTION __UI_Darken~& (WhichColor~&, ByHowMuch%)
    __UI_Darken~& = _RGB32(_RED(WhichColor~&) * (ByHowMuch% / 100), _GREEN(WhichColor~&) * (ByHowMuch% / 100), _BLUE(WhichColor~&) * (ByHowMuch% / 100))
END FUNCTION

SUB __UI_EventDispatcher
    STATIC __UI_LastHoveringID AS LONG
    STATIC __UI_ThumbDragY AS INTEGER
    STATIC __UI_LastMouseIconSet AS _BYTE
    DIM i AS LONG, ThisItem%
    DIM ContainerOffsetLeft AS INTEGER, ContainerOffsetTop AS INTEGER

    IF __UI_HoveringID = 0 AND __UI_Focus = 0 THEN EXIT SUB

    IF __UI_Controls(__UI_HoveringID).ParentID THEN
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

    'MouseEnter, MouseLeave
    IF __UI_LastHoveringID <> __UI_HoveringID THEN
        IF __UI_LastHoveringID THEN __UI_MouseLeave __UI_LastHoveringID
        __UI_MouseEnter __UI_HoveringID
    END IF

    'Hover actions
    IF NOT __UI_DraggingThumb AND __UI_HoveringID = __UI_ActiveDropdownList AND __UI_Controls(__UI_HoveringID).HoveringVScrollbarButton = 0 THEN
        'Dropdown list items are preselected when hovered
        ThisItem% = ((__UI_MouseTop - (ContainerOffsetTop + __UI_Controls(__UI_HoveringID).Top)) \ _FONTHEIGHT(__UI_Fonts(__UI_Controls(__UI_HoveringID).Font))) + __UI_Controls(__UI_HoveringID).InputViewStart
        IF ThisItem% >= __UI_Controls(__UI_HoveringID).Min AND ThisItem% <= __UI_Controls(__UI_HoveringID).Max THEN
            __UI_Controls(__UI_HoveringID).Value = ThisItem%
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
                'Full circle. No objects can have focus
                EXIT DO
            END IF

            IF __UI_Controls(__UI_FocusSearch).CanHaveFocus AND NOT __UI_Controls(__UI_FocusSearch).Disabled THEN
                IF __UI_Focus THEN __UI_FocusOut __UI_Focus
                __UI_Focus = __UI_FocusSearch
                __UI_FocusIn __UI_Focus
                EXIT DO
            END IF
        LOOP
    END IF

    'Any visible dropdown lists will be destroyed when focus is lost
    IF __UI_ActiveDropdownList > 0 AND ((__UI_Focus <> __UI_ActiveDropdownList AND __UI_Focus <> __UI_ParentDropdownList) OR __UI_KeyHit = 27) THEN
        __UI_Focus = __UI_ParentDropdownList
        __UI_DestroyControl __UI_Controls(__UI_ActiveDropdownList)
        __UI_ActiveDropdownList = 0
        __UI_ParentDropdownList = 0
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
        IF __UI_MouseIsDown = __UI_False THEN
            IF __UI_Controls(__UI_HoveringID).CanHaveFocus AND NOT __UI_Controls(__UI_HoveringID).Disabled THEN
                IF __UI_Focus THEN __UI_FocusOut __UI_Focus
                __UI_Focus = __UI_HoveringID
                __UI_FocusIn __UI_Focus
            ELSEIF __UI_Controls(__UI_HoveringID).Type = __UI_Type_Form THEN
                IF __UI_Focus THEN __UI_FocusOut __UI_Focus
                __UI_Focus = 0
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
                IF __UI_IsSelectingText = __UI_False THEN
                    __UI_Controls(__UI_HoveringID).TextIsSelected = __UI_False
                    __UI_SelectedText = ""
                    __UI_SelectionLength = 0
                    __UI_Controls(__UI_HoveringID).SelectionStart = ((__UI_MouseLeft - __UI_Controls(__UI_HoveringID).Left) / _FONTWIDTH) + (__UI_Controls(__UI_HoveringID).InputViewStart - 1)
                    __UI_Controls(__UI_HoveringID).Cursor = __UI_Controls(__UI_HoveringID).SelectionStart
                    IF __UI_Controls(__UI_HoveringID).SelectionStart > LEN(__UI_Texts(__UI_HoveringID)) THEN __UI_Controls(__UI_HoveringID).SelectionStart = LEN(__UI_Texts(__UI_HoveringID))
                    IF __UI_Controls(__UI_HoveringID).Cursor > LEN(__UI_Texts(__UI_HoveringID)) THEN __UI_Controls(__UI_HoveringID).Cursor = LEN(__UI_Texts(__UI_HoveringID))
                    __UI_IsSelectingText = __UI_True
                    __UI_IsSelectingTextOnID = __UI_HoveringID
                END IF
            ELSEIF __UI_Controls(__UI_HoveringID).Type = __UI_Type_ListBox AND NOT __UI_Controls(__UI_HoveringID).Disabled THEN
                IF __UI_Controls(__UI_HoveringID).HoveringVScrollbarButton = 1 OR __UI_Controls(__UI_HoveringID).HoveringVScrollbarButton = 2 OR __UI_Controls(__UI_HoveringID).HoveringVScrollbarButton = 4 OR __UI_Controls(__UI_HoveringID).HoveringVScrollbarButton = 5 THEN
                    __UI_MouseDownOnListBox = TIMER
                ELSEIF __UI_Controls(__UI_HoveringID).HoveringVScrollbarButton = 3 THEN
                    IF NOT __UI_DraggingThumb THEN
                        __UI_DraggingThumb = __UI_True
                        __UI_ThumbDragY = __UI_MouseTop
                        __UI_DraggingThumbOnID = __UI_HoveringID
                    END IF
                END IF
            END IF
            __UI_MouseDown __UI_HoveringID
        ELSE
            IF __UI_MouseDownOnID <> __UI_HoveringID AND __UI_MouseDownOnID > 0 THEN
                __UI_MouseDownOnID = 0
            ELSE
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
                END IF
            END IF
        END IF
    ELSE
        IF __UI_MouseIsDown THEN
            IF __UI_IsDragging THEN
                __UI_EndDrag __UI_DraggingID
                __UI_IsDragging = __UI_False
                'Snap the previously dragged object to the grid (unless Ctrl is down):
                IF __UI_Controls(__UI_DraggingID).ParentID THEN
                    __UI_PreviewTop = __UI_PreviewTop - __UI_Controls(__UI_Controls(__UI_DraggingID).ParentID).Top
                    __UI_PreviewLeft = __UI_PreviewLeft - __UI_Controls(__UI_Controls(__UI_DraggingID).ParentID).Left
                END IF
                __UI_Controls(__UI_DraggingID).Top = __UI_PreviewTop
                __UI_Controls(__UI_DraggingID).Left = __UI_PreviewLeft
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
                                'Textbox has a vertical scrollbar and it's been clicked
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
                                    __UI_ActiveDropdownList = 0
                                    __UI_ParentDropdownList = 0
                                END IF
                            END IF
                        CASE __UI_Type_DropdownList
                            IF __UI_ActiveDropdownList = 0 THEN
                                __UI_ActivateDropdownlist __UI_HoveringID
                            ELSE
                                __UI_DestroyControl __UI_Controls(__UI_ActiveDropdownList)
                                __UI_ActiveDropdownList = 0
                                __UI_ParentDropdownList = 0
                            END IF
                    END SELECT
                    __UI_LastMouseClick = TIMER
                    __UI_MouseDownOnID = 0
                    __UI_Click __UI_HoveringID
                END IF
            END IF
            __UI_IsSelectingText = __UI_False
            __UI_IsSelectingTextOnID = 0
            __UI_MouseIsDown = __UI_False
            __UI_MouseUp __UI_HoveringID
        END IF
    END IF

    'Drag update
    IF __UI_IsDragging AND __UI_DraggingID > 0 THEN
        __UI_Controls(__UI_DraggingID).Top = __UI_Controls(__UI_DraggingID).Top + (__UI_MouseTop - __UI_DragY)
        __UI_DragY = __UI_MouseTop

        __UI_Controls(__UI_DraggingID).Left = __UI_Controls(__UI_DraggingID).Left + (__UI_MouseLeft - __UI_DragX)
        __UI_DragX = __UI_MouseLeft

        'Draw preview rectangle to show where the object will be snapped
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

        IF __UI_Controls(__UI_DraggingID).ParentID THEN
            __UI_PreviewTop = __UI_PreviewTop + __UI_Controls(__UI_Controls(__UI_DraggingID).ParentID).Top
            __UI_PreviewLeft = __UI_PreviewLeft + __UI_Controls(__UI_Controls(__UI_DraggingID).ParentID).Left
        END IF
    END IF
    IF __UI_DraggingThumb = __UI_True THEN
        IF __UI_MouseTop >= __UI_Controls(__UI_DraggingThumbOnID).Top + __UI_Controls(__UI_Controls(__UI_DraggingThumbOnID).ParentID).Top + __UI_ScrollbarButtonHeight AND __UI_MouseTop <= __UI_Controls(__UI_DraggingThumbOnID).Top + __UI_Controls(__UI_Controls(__UI_DraggingThumbOnID).ParentID).Top + __UI_Controls(__UI_DraggingThumbOnID).Height - __UI_ScrollbarButtonHeight THEN
            __UI_Controls(__UI_DraggingThumbOnID).InputViewStart = __UI_Controls(__UI_DraggingThumbOnID).InputViewStart + ((__UI_MouseTop - __UI_ThumbDragY) / __UI_Controls(__UI_DraggingThumbOnID).VScrollbarRatio)
            IF __UI_Controls(__UI_DraggingThumbOnID).InputViewStart + __UI_Controls(__UI_DraggingThumbOnID).LastVisibleItem - 1 > __UI_Controls(__UI_DraggingThumbOnID).Max THEN __UI_Controls(__UI_DraggingThumbOnID).InputViewStart = __UI_Controls(__UI_DraggingThumbOnID).Max - __UI_Controls(__UI_DraggingThumbOnID).LastVisibleItem + 1

            __UI_ThumbDragY = __UI_MouseTop
        END IF
    END IF

    'Keyboard handler
    'IF __UI_KeyHit = 27 THEN __UI_Controls(__UI_HoveringID).Disabled = NOT __UI_Controls(__UI_HoveringID).Disabled

    IF __UI_KeyHit = 100303 OR __UI_KeyHit = 100304 THEN __UI_ShiftIsDown = __UI_True
    IF __UI_KeyHit = -100303 OR __UI_KeyHit = -100304 THEN __UI_ShiftIsDown = __UI_False
    IF __UI_KeyHit = 100305 OR __UI_KeyHit = 100306 THEN __UI_CtrlIsDown = __UI_True
    IF __UI_KeyHit = -100305 OR __UI_KeyHit = -100306 THEN __UI_CtrlIsDown = __UI_False
    IF __UI_KeyHit = 100307 OR __UI_KeyHit = 100308 THEN __UI_AltIsDown = __UI_True
    IF __UI_KeyHit = -100307 OR __UI_KeyHit = -100308 THEN __UI_AltIsDown = __UI_False

    IF __UI_AltIsDown AND __UI_Focus = __UI_MenuBarID THEN
        __UI_Focus = __UI_PreviousFocus
        __UI_AltIsDown = __UI_False
    END IF

    IF __UI_AltIsDown THEN
        IF NOT __UI_ShowHotKeys THEN
            __UI_ShowHotKeys = __UI_True
            __UI_ForceRedraw = __UI_True 'Trigger a global redraw
        END IF

        SELECT CASE __UI_KeyHit
            CASE 48 TO 57, 65 TO 90, 97 TO 122 'Alphanumeric
                DIM j AS LONG

                __UI_AltCombo$ = __UI_AltCombo$ + CHR$(__UI_KeyHit)

                IF __UI_KeyHit >= 97 THEN __UI_KeyHit = __UI_KeyHit - 32 'Turn to capitals
                IF __UI_MenuBarID > 0 THEN
                    'Search for a matching hot key in menu bar items
                    FOR i = 1 TO UBOUND(__UI_MenubarItems)
                        IF __UI_MenubarItems(i).HotKey = __UI_KeyHit AND NOT __UI_MenubarItems(i).Disabled THEN
                            __UI_PreviousFocus = __UI_Focus
                            __UI_Focus = __UI_MenuBarID
                            __UI_Controls(__UI_MenuBarID).Value = i
                            __UI_KeyHit = 0
                            EXIT FOR
                        END IF
                    NEXT
                END IF 'Has menu bar

                IF __UI_KeyHit > 0 THEN
                    'Search for a matching hot key in controls
                    FOR i = 1 TO UBOUND(__UI_Controls)
                        IF __UI_Controls(i).HotKey = __UI_KeyHit AND NOT __UI_Controls(i).Disabled THEN
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
                IF __UI_MenuBarID > 0 THEN
                    __UI_PreviousFocus = __UI_Focus
                    __UI_Focus = __UI_MenuBarID
                    __UI_Controls(__UI_MenuBarID).Value = 1
                END IF
            END IF
        END IF
    END IF

    IF __UI_Focus AND __UI_KeyHit <> 0 THEN
        __UI_KeyPress __UI_Focus

        'Enter activates the selected/default button, if any
        IF __UI_IsDragging = __UI_False AND __UI_KeyHit = -13 AND NOT __UI_Controls(__UI_Focus).Disabled THEN
            'Enter released and there is a default button
            IF __UI_Controls(__UI_Focus).Type = __UI_Type_Button THEN
                __UI_Click __UI_Focus
            ELSEIF __UI_Controls(__UI_Focus).Type = __UI_Type_ListBox AND __UI_Focus = __UI_ActiveDropdownList THEN
                __UI_Focus = __UI_ParentDropdownList
                __UI_Controls(__UI_ParentDropdownList).Value = __UI_Controls(__UI_ActiveDropdownList).Value
                __UI_DestroyControl __UI_Controls(__UI_ActiveDropdownList)
                __UI_ActiveDropdownList = 0
                __UI_ParentDropdownList = 0
            ELSEIF __UI_Focus <> __UI_DefaultButtonID AND __UI_DefaultButtonID > 0 THEN
                __UI_Click __UI_DefaultButtonID
            END IF
        ELSE
            SELECT CASE __UI_Controls(__UI_Focus).Type
                CASE __UI_Type_MenuBar
                    SELECT CASE __UI_KeyHit
                        CASE 13 'Enter
                            __UI_Focus = __UI_PreviousFocus
                        CASE 27 'Esc
                            __UI_Focus = __UI_PreviousFocus
                        CASE 19200 'Left
                            __UI_Controls(__UI_Focus).Value = (__UI_Controls(__UI_Focus).Value + __UI_Controls(__UI_Focus).Max - 2) MOD __UI_Controls(__UI_Focus).Max + 1
                        CASE 19712 'Right
                            __UI_Controls(__UI_Focus).Value = __UI_Controls(__UI_Focus).Value MOD __UI_Controls(__UI_Focus).Max + 1
                        CASE 18432, 20480 'Up, down
                            __UI_Focus = __UI_PreviousFocus
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
                                        'Full circle. No similar objects can have focus
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
                                        __UI_ActivateDropdownlist __UI_Focus
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
    ELSEIF __UI_KeyHit > 0 THEN 'No control has focus
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
FUNCTION __UI_NewControl (ObjType AS INTEGER, ObjName AS STRING, NewWidth AS INTEGER, NewHeight AS INTEGER, ParentID AS LONG)
    DIM NextSlot AS LONG, i AS LONG

    IF ObjType = __UI_Type_Form OR ObjType = __UI_Type_MenuBar THEN
        'Make sure only one Form and MenuBar exist, as these must be unique
        FOR i = 1 TO UBOUND(__UI_Controls)
            IF __UI_Controls(i).Type = ObjType THEN ERROR 5: EXIT FUNCTION
        NEXT
    END IF

    'Make sure this ObjName is unique:
    FOR i = 1 TO UBOUND(__UI_Controls)
        IF __UI_Controls(i).ID > 0 AND UCASE$(RTRIM$(__UI_Controls(i).Name)) = UCASE$(RTRIM$(ObjName)) THEN ERROR 5: EXIT FUNCTION
    NEXT

    'Find an empty slot for the new object
    FOR NextSlot = 1 TO UBOUND(__UI_Controls)
        IF __UI_Controls(NextSlot).ID = __UI_False THEN EXIT FOR
    NEXT

    IF NextSlot > UBOUND(__UI_Controls) THEN
        'No empty slots. We must increase __UI_Controls() and its helper arrays
        REDIM _PRESERVE __UI_Controls(0 TO NextSlot + 99) AS __UI_ControlTYPE
        REDIM _PRESERVE __UI_Captions(1 TO NextSlot + 99) AS STRING
        REDIM _PRESERVE __UI_TempCaptions(1 TO NextSlot + 99) AS STRING
        REDIM _PRESERVE __UI_Texts(1 TO NextSlot + 99) AS STRING
        REDIM _PRESERVE __UI_TempTexts(1 TO NextSlot + 99) AS STRING
    END IF

    __UI_DestroyControl __UI_Controls(NextSlot) 'This control is inactive but may still retain properties
    __UI_Controls(NextSlot).ID = NextSlot
    __UI_Controls(NextSlot).ParentID = ParentID
    IF (ObjType <> __UI_Type_Form AND ParentID = 0) THEN
        'Inherit main form's font
        __UI_Controls(NextSlot).Font = __UI_Controls(__UI_FormID).Font
    ELSEIF (ObjType <> __UI_Type_Frame AND ParentID > 0) THEN
        'Inherit container's font
        __UI_Controls(NextSlot).Font = __UI_Controls(ParentID).Font
    END IF
    __UI_Controls(NextSlot).Type = ObjType
    __UI_Controls(NextSlot).Name = ObjName
    __UI_Controls(NextSlot).Width = NewWidth
    __UI_Controls(NextSlot).Height = NewHeight
    IF ObjType = __UI_Type_MenuBar THEN
        __UI_Controls(NextSlot).Width = __UI_Controls(__UI_FormID).Width
        __UI_Controls(NextSlot).Height = _FONTHEIGHT(__UI_Fonts(__UI_Controls(__UI_FormID).Font)) * 1.5
        __UI_MenuBarID = NextSlot
    ELSEIF ObjType = __UI_Type_Frame OR ObjType = __UI_Type_Form THEN
        __UI_Controls(NextSlot).Canvas = _NEWIMAGE(NewWidth, NewHeight, 32)
    END IF
    __UI_Controls(NextSlot).ForeColor = __UI_DefaultColor(ObjType, 1)
    __UI_Controls(NextSlot).BackColor = __UI_DefaultColor(ObjType, 2)
    __UI_Controls(NextSlot).SelectedForeColor = __UI_DefaultColor(ObjType, 3)
    __UI_Controls(NextSlot).SelectedBackColor = __UI_DefaultColor(ObjType, 4)
    __UI_Controls(NextSlot).BorderColor = __UI_DefaultColor(ObjType, 5)

    IF ObjType = __UI_Type_TextBox OR ObjType = __UI_Type_Frame OR ObjType = __UI_Type_ListBox OR ObjType = __UI_Type_DropdownList THEN
        __UI_Controls(NextSlot).HasBorder = __UI_True
    END IF

    IF ObjType = __UI_Type_Form THEN __UI_FormID = NextSlot

    __UI_NewControl = NextSlot
END FUNCTION

'---------------------------------------------------------------------------------
SUB __UI_DestroyControl (This AS __UI_ControlTYPE)
    IF This.ID THEN
        __UI_Captions(This.ID) = ""
        __UI_TempCaptions(This.ID) = ""
        __UI_Texts(This.ID) = ""
        __UI_TempTexts(This.ID) = ""

        IF This.Type = __UI_Type_MenuBar THEN __UI_MenuBarID = 0
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
    IF This.HWCanvas <> 0 THEN _FREEIMAGE This.HWCanvas: This.HWCanvas = 0
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
    DIM PrevFont AS LONG, TempCanvas AS LONG, PrevDest AS LONG

    ThisID = __UI_GetID(Control$)

    NewCaption$ = TempCaption$

    FindSep% = INSTR(NewCaption$, "&")
    IF FindSep% > 0 AND FindSep% < LEN(NewCaption$) THEN
        IF __UI_MenuBarID > 0 THEN
            'Check if this hot key isn't already assigned to a menu bar item
            FOR i = 1 TO UBOUND(__UI_MenubarItems)
                IF __UI_MenubarItems(i).HotKey > 0 THEN
                    UsedList$ = UsedList$ + CHR$(__UI_MenubarItems(i).HotKey)
                END IF
            NEXT
        END IF

        FOR i = 1 TO UBOUND(__UI_Controls)
            'Check if this hot key isn't already assigned to another control
            IF __UI_Controls(i).HotKey > 0 THEN
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
    DIM ThisID AS LONG

    ThisID = __UI_GetID(Control$)

    __UI_Texts(ThisID) = NewText$

    IF __UI_Controls(ThisID).Type = __UI_Type_MenuBar THEN
        'Parse menu items into __UI_MenuBarItems()
        DIM TempCaption$, TempText$, FindSep%, ThisItem%, NextIsLast AS _BYTE
        DIM PrevFont AS LONG, PrevDest AS LONG, TempCanvas AS LONG, ItemOffset%

        PrevFont = _FONT

        IF _PIXELSIZE = 0 THEN
            'Temporarily create a 32bit screen for proper font handling, in case
            'we're still at form setup (SCREEN 0)
            TempCanvas = _NEWIMAGE(10, 10, 32)
            PrevDest = _DEST
            _DEST TempCanvas
        END IF

        _FONT __UI_Fonts(__UI_Controls(ThisID).Font)

        IF _FONTWIDTH THEN ItemOffset% = _PRINTWIDTH("__") ELSE ItemOffset% = _PRINTWIDTH("_")
        TempText$ = NewText$
        ThisItem% = 0
        DO WHILE LEN(TempText$)
            FindSep% = INSTR(TempText$, "\")
            IF FindSep% THEN
                TempCaption$ = LEFT$(TempText$, FindSep% - 1)
                TempText$ = MID$(TempText$, FindSep% + 1)
            ELSE
                TempCaption$ = TempText$
                TempText$ = ""
            END IF
            IF LEN(TempCaption$) THEN
                ThisItem% = ThisItem% + 1
                REDIM _PRESERVE __UI_MenubarItems(1 TO ThisItem%) AS __UI_ControlTYPE
                FindSep% = INSTR(TempCaption$, "&")
                IF FindSep% > 0 AND FindSep% < LEN(TempCaption$) THEN
                    TempCaption$ = LEFT$(TempCaption$, FindSep% - 1) + MID$(TempCaption$, FindSep% + 1)
                    __UI_MenubarItems(ThisItem%).HotKeyOffset = _PRINTWIDTH(LEFT$(TempCaption$, FindSep% - 1))
                    __UI_MenubarItems(ThisItem%).HotKey = ASC(UCASE$(TempCaption$), FindSep%)
                ELSE
                    __UI_MenubarItems(ThisItem%).HotKey = 0
                END IF
                __UI_MenubarItems(ThisItem%).Name = TempCaption$
                __UI_MenubarItems(ThisItem%).Width = ItemOffset% + _PRINTWIDTH(TempCaption$) + ItemOffset%
                IF NextIsLast THEN
                    __UI_MenubarItems(ThisItem%).Align = __UI_Right
                    __UI_MenubarItems(ThisItem%).Left = (__UI_Controls(__UI_FormID).Width - __UI_MenubarItems(ThisItem%).Width) - ItemOffset%
                    __UI_Controls(ThisID).Max = ThisItem%
                    EXIT DO
                ELSE
                    __UI_MenubarItems(ThisItem%).Align = __UI_Left
                    IF ThisItem% > 1 THEN
                        __UI_MenubarItems(ThisItem%).Left = __UI_MenubarItems(ThisItem% - 1).Left + __UI_MenubarItems(ThisItem% - 1).Width
                    ELSE
                        __UI_MenubarItems(ThisItem%).Left = ItemOffset%
                    END IF
                END IF
            ELSE
                NextIsLast = __UI_True
            END IF
        LOOP
        IF TempCanvas <> 0 THEN
            _DEST PrevDest
            _FREEIMAGE TempCanvas
        END IF
        _FONT PrevFont
    END IF
END SUB

'---------------------------------------------------------------------------------
FUNCTION __UI_LoadFont& (FontFile$, Size%, Parameters$)
    DIM Handle&
    Handle& = _LOADFONT(FontFile$, Size%, Parameters$)
    IF Handle& <= 0 THEN Handle& = 16
    __UI_LoadFont& = Handle&
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
SUB __UI_ActivateDropdownlist (id)
    IF NOT __UI_Controls(id).Disabled THEN
        __UI_ParentDropdownList = id
        __UI_ActiveDropdownList = __UI_NewControl(__UI_Type_ListBox, RTRIM$(__UI_Controls(id).Name) + CHR$(1) + "DropdownList", 0, 0, 0)
        __UI_Texts(__UI_ActiveDropdownList) = __UI_Texts(id)
        __UI_Controls(__UI_ActiveDropdownList).Left = __UI_Controls(id).Left + __UI_Controls(__UI_Controls(id).ParentID).Left
        __UI_Controls(__UI_ActiveDropdownList).Width = __UI_Controls(id).Width
        __UI_Controls(__UI_ActiveDropdownList).Top = __UI_Controls(id).Top + __UI_Controls(id).Height + __UI_Controls(__UI_Controls(id).ParentID).Top
        __UI_Controls(__UI_ActiveDropdownList).Height = _FONTHEIGHT(__UI_Fonts(__UI_Controls(id).Font)) * 10.5
        IF __UI_Controls(__UI_ActiveDropdownList).Top + __UI_Controls(__UI_ActiveDropdownList).Height > _HEIGHT THEN
            __UI_Controls(__UI_ActiveDropdownList).Top = _HEIGHT - __UI_Controls(__UI_ActiveDropdownList).Height
        END IF
        __UI_Controls(__UI_ActiveDropdownList).Max = __UI_Controls(id).Max
        __UI_Controls(__UI_ActiveDropdownList).Value = __UI_Controls(id).Value
        __UI_Controls(__UI_ActiveDropdownList).ForeColor = __UI_Controls(id).ForeColor
        __UI_Controls(__UI_ActiveDropdownList).BackColor = __UI_Controls(id).BackColor
        __UI_Controls(__UI_ActiveDropdownList).SelectedForeColor = __UI_Controls(id).SelectedForeColor
        __UI_Controls(__UI_ActiveDropdownList).SelectedBackColor = __UI_Controls(id).SelectedBackColor
        __UI_Controls(__UI_ActiveDropdownList).Font = __UI_Controls(id).Font
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
        _FREEIMAGE This.Canvas
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

    IF This.ControlState <> ControlState OR This.FocusState <> (__UI_Focus = This.ID) OR __UI_Captions(This.ID) <> __UI_TempCaptions(This.ID) OR This.PreviousParentID <> This.ParentID OR __UI_ForceRedraw THEN
        'Last time this control was drawn it had a different state/caption, so it'll be redrawn
        This.ControlState = ControlState
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

        TempControlState = ControlState
        IF TempControlState = 1 THEN
            IF (This.ID = __UI_DefaultButtonID AND This.ID <> __UI_Focus AND __UI_Controls(__UI_Focus).Type <> __UI_Type_Button) OR This.ID = __UI_Focus THEN
                TempControlState = 5
            END IF
        END IF

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

        IF __UI_Focus = This.ID THEN
            LINE (CaptionIndent - 1, 0)-STEP(This.Width - CaptionIndent - 1, This.Height - 1), _RGB32(0, 0, 0), B , 21845
        END IF

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

        IF __UI_Focus = This.ID THEN
            LINE (CaptionIndent - 1, 0)-STEP(This.Width - CaptionIndent - 1, This.Height - 1), _RGB32(0, 0, 0), B , 21845
        END IF

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
    STATIC SetCursor#, cursorBlink%%

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
                            LINE (CaptionIndent, ThisItemTop%)-STEP(This.Width - CaptionIndent * 2, _FONTHEIGHT - 1), This.SelectedBackColor, BF
                        ELSE
                            LINE (CaptionIndent, ThisItemTop%)-STEP(This.Width - CaptionIndent * 2, _FONTHEIGHT - 1), _RGBA32(0, 0, 0, 50), BF
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
    STATIC SetCursor#, cursorBlink%%

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
                    ThisItemTop% = This.Height \ 2 - _FONTHEIGHT \ 2

                    IF ThisItem% = This.Value AND __UI_Focus = This.ID THEN __UI_SelectedText = TempCaption$

                    IF NOT This.Disabled THEN
                        COLOR This.ForeColor, This.BackColor
                    ELSE
                        COLOR __UI_Darken(__UI_Controls(__UI_FormID).BackColor, 80), This.BackColor
                    END IF

                    IF __UI_Focus = This.ID THEN
                        COLOR This.SelectedForeColor, This.SelectedBackColor
                        LINE (CaptionIndent, 4)-STEP(This.Width - CaptionIndent * 2, This.Height - 9), This.SelectedBackColor, BF
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
            IF __UI_ActiveDropdownList > 0 AND __UI_ParentDropdownList = This.ID THEN
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

    IF This.ChildrenRedrawn OR __UI_Captions(This.ID) <> __UI_TempCaptions(This.ID) OR This.HWCanvas = 0 OR (__UI_IsDragging AND __UI_Controls(__UI_DraggingID).ParentID = This.ID) OR This.Value <> This.PreviousValue OR __UI_ForceRedraw THEN
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

        IF This.HWCanvas <> 0 THEN _FREEIMAGE This.HWCanvas
        This.HWCanvas = _COPYIMAGE(TempCanvas, 33)
        _FREEIMAGE TempCanvas
        _DEST 0
    END IF

    _PUTIMAGE (This.Left, This.Top - _FONTHEIGHT(__UI_Fonts(This.Font)) \ 2), This.HWCanvas
END SUB

SUB __UI_DrawMenuBar (This AS __UI_ControlTYPE, ControlState AS _BYTE)
    DIM PrevDest AS LONG, CaptionIndent AS INTEGER, TempCaption$
    STATIC PrevAltState

    IF __UI_AltIsDown <> PrevAltState OR This.FocusState <> (__UI_Focus = This.ID) OR This.Value <> This.PreviousValue OR This.ControlState <> ControlState OR __UI_Texts(This.ID) <> __UI_TempTexts(This.ID) THEN
        'Last time this control was drawn it had a different state/caption, so it'll be redrawn
        This.ControlState = ControlState
        This.PreviousValue = This.Value
        PrevAltState = __UI_AltIsDown
        __UI_TempTexts(This.ID) = __UI_Texts(This.ID)
        This.FocusState = (__UI_Focus = This.ID)

        IF This.Canvas <> 0 THEN
            _FREEIMAGE This.Canvas
        END IF

        This.Canvas = _NEWIMAGE(__UI_Controls(__UI_FormID).Width, _FONTHEIGHT(__UI_Fonts(This.Font)) * 1.5, 32)
        This.Width = __UI_Controls(__UI_FormID).Width

        PrevDest = _DEST
        _DEST This.Canvas
        _FONT __UI_Fonts(This.Font)
        CLS , _RGBA32(0, 0, 0, 0)

        '---
        DIM ItemOffset%
        IF _FONTWIDTH THEN ItemOffset% = _PRINTWIDTH("__") ELSE ItemOffset% = _PRINTWIDTH("_")

        LINE (0, 0)-STEP(This.Width - 1, This.Height - 1), This.BackColor, BF
        _PRINTMODE _KEEPBACKGROUND

        DIM i AS INTEGER, c AS _UNSIGNED LONG
        FOR i = 1 TO UBOUND(__UI_MenuBarItems)
            TempCaption$ = RTRIM$(__UI_MenubarItems(i).Name)

            IF This.Value = i AND (__UI_HoveringID = This.ID OR __UI_Focus = This.ID) THEN
                LINE (__UI_MenubarItems(i).Left, 0)-STEP(__UI_MenubarItems(i).Width, This.Height - 1), This.SelectedBackColor, BF
                c = This.SelectedForeColor
            ELSE
                c = This.ForeColor
            END IF

            COLOR c

            _PRINTSTRING (__UI_MenubarItems(i).Left + ItemOffset%, ((This.Height \ 2) - _FONTHEIGHT \ 2)), TempCaption$
            IF __UI_MenubarItems(i).HotKey > 0 AND __UI_AltIsDown THEN
                'Has "hot-key"
                LINE (ItemOffset% + __UI_MenubarItems(i).Left + __UI_MenubarItems(i).HotKeyOffset, ((This.Height \ 2) + _FONTHEIGHT \ 2) - 1)-STEP(_PRINTWIDTH(CHR$(__UI_MenubarItems(i).HotKey)) - 1, 0), c
            END IF
        NEXT

        LINE (0, This.Height - 1)-STEP(This.Width, 0), __UI_Darken(__UI_Controls(__UI_FormID).BackColor, 80)
        '---

        __UI_MakeHardwareImageFromCanvas This
        _DEST PrevDest
    END IF

    _PUTIMAGE (This.Left, This.Top), This.Canvas
END SUB
