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

TYPE __UI_ControlTYPE
    ID AS LONG
    ParentID AS LONG
    Type AS INTEGER
    Name AS STRING * 256
    Top AS INTEGER
    Left AS INTEGER
    Width AS INTEGER
    Height AS INTEGER
    Canvas AS LONG
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
    ShowPercentage AS _BYTE
    InputViewStart AS LONG
    PreviousInputViewStart AS LONG
    LastVisibleItem AS INTEGER
    HasVScrollbar AS _BYTE
    VScrollbarButton2Top AS INTEGER
    VScrollbarButtonHeight AS INTEGER
    VScrollbarWidth AS INTEGER
    HoveringVScrollbarButton AS _BYTE
    ThumbHeight AS INTEGER
    ThumbTop AS INTEGER
    VScrollbarRatio AS SINGLE
    Cursor AS LONG
    PrevCursor AS LONG
    FieldArea AS LONG
    Selected AS _BYTE
    SelectionLength AS LONG
    SelectionStart AS LONG
    Resizable AS _BYTE
    CanDrag AS _BYTE
    CanHaveFocus AS _BYTE
    Enabled AS _BYTE
    Hidden AS _BYTE
    CenteredWindow AS _BYTE
    ControlState AS _BYTE
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
__UI_Fonts(2) = __UI_LoadFont("cyberbit.ttf", 14, "")

DIM SHARED __UI_MouseLeft AS INTEGER, __UI_MouseTop AS INTEGER
DIM SHARED __UI_MouseWheel AS INTEGER
DIM SHARED __UI_PrevMouseX AS INTEGER, __UI_PrevMouseY AS INTEGER
DIM SHARED __UI_MouseButton1 AS _BYTE, __UI_MouseButton2 AS _BYTE
DIM SHARED __UI_PrevMouseButton1 AS _BYTE, __UI_PrevMouseButton2 AS _BYTE
DIM SHARED __UI_PreviewTop AS INTEGER, __UI_PreviewLeft AS INTEGER
DIM SHARED __UI_MouseIsDown AS _BYTE, __UI_MouseDownOnID AS LONG
DIM SHARED __UI_KeyIsDown AS _BYTE, __UI_KeyDownOnID AS LONG
DIM SHARED __UI_ShiftIsDown AS _BYTE, __UI_CtrlIsDown AS _BYTE
DIM SHARED __UI_AltIsDown AS _BYTE
DIM SHARED __UI_LastMouseClick AS DOUBLE, __UI_MouseDownOnListBox AS DOUBLE
DIM SHARED __UI_DragX AS INTEGER, __UI_DragY AS INTEGER
DIM SHARED __UI_DefaultButtonID AS LONG
DIM SHARED __UI_KeyHit AS LONG
DIM SHARED __UI_Focus AS LONG
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
DIM SHARED __UI_FormID AS LONG

'Object types:
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
CONST __UI_Type_MultiLineTextBox = 11
CONST __UI_Type_MenuBar = 12
CONST __UI_Type_ContextMenu = 13

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
__UI_Controls(NewID).ForeColor = _RGB32(0, 0, 0)
__UI_Controls(NewID).BackColor = _RGB32(235, 233, 237)
__UI_Controls(NewID).Enabled = __UI_True
__UI_SetCaption "Form1", "Hello, world!"

NewID = __UI_NewControl(__UI_Type_Button, "Button1", 0, 0, 0)
__UI_Controls(NewID).Top = 100
__UI_Controls(NewID).Left = 100
__UI_Controls(NewID).Width = 200
__UI_Controls(NewID).Height = 20
__UI_Controls(NewID).ForeColor = _RGB32(255, 255, 255)
__UI_Controls(NewID).BackColor = _RGB32(105, 177, 94)
__UI_Controls(NewID).CanHaveFocus = __UI_True
__UI_Controls(NewID).Enabled = __UI_True
__UI_SetCaption "Button1", "Click me"

NewID = __UI_NewControl(__UI_Type_Button, "Button2", 0, 0, 0)
__UI_Controls(NewID).Top = 200
__UI_Controls(NewID).Left = 100
__UI_Controls(NewID).Width = 230
__UI_Controls(NewID).Height = 20
__UI_Controls(NewID).ForeColor = _RGB32(255, 255, 255)
__UI_Controls(NewID).BackColor = _RGB32(51, 152, 219)
__UI_Controls(NewID).CanHaveFocus = __UI_True
__UI_Controls(NewID).Enabled = __UI_True
__UI_SetCaption "Button2", "Detach ListBox from frame"

NewID = __UI_NewControl(__UI_Type_TextBox, "Textbox1", 0, 0, 0)
__UI_Controls(NewID).Top = 250
__UI_Controls(NewID).Left = 30
__UI_Controls(NewID).Width = 250
__UI_Controls(NewID).Height = 20
__UI_Controls(NewID).Font = 0
__UI_Controls(NewID).ForeColor = _RGB32(0, 0, 0)
__UI_Controls(NewID).BackColor = _RGB32(255, 255, 255)
__UI_Controls(NewID).HasBorder = __UI_True
__UI_Controls(NewID).BorderColor = _RGB32(0, 0, 0)
__UI_Controls(NewID).CanHaveFocus = __UI_True
__UI_Controls(NewID).Enabled = __UI_True
__UI_SetCaption "Textbox1", "Edit me"

NewID = __UI_NewControl(__UI_Type_Button, "AddItemBT", 0, 0, 0)
__UI_Controls(NewID).Top = 250
__UI_Controls(NewID).Left = 290
__UI_Controls(NewID).Width = 90
__UI_Controls(NewID).Height = 20
__UI_Controls(NewID).Font = 0
__UI_Controls(NewID).ForeColor = _RGB32(255, 255, 255)
__UI_Controls(NewID).BackColor = _RGB32(161, 61, 61)
__UI_Controls(NewID).HasBorder = __UI_True
__UI_Controls(NewID).BorderColor = _RGB32(0, 0, 0)
__UI_Controls(NewID).CanHaveFocus = __UI_True
__UI_Controls(NewID).Enabled = __UI_True
__UI_SetCaption "AddItemBT", "Add Item"

NewID = __UI_NewControl(__UI_Type_Button, "DragButton", 0, 0, 0)
__UI_Controls(NewID).Top = 300
__UI_Controls(NewID).Left = 100
__UI_Controls(NewID).Width = 200
__UI_Controls(NewID).Height = 20
__UI_Controls(NewID).ForeColor = _RGB32(255, 255, 255)
__UI_Controls(NewID).BackColor = _RGB32(188, 152, 116)
__UI_Controls(NewID).CanHaveFocus = __UI_True
__UI_Controls(NewID).Enabled = __UI_True
__UI_SetCaption "DragButton", "Make ListBox draggable"

NewID = __UI_NewControl(__UI_Type_Label, "Label1", 0, 0, 0)
__UI_Controls(NewID).Top = 30
__UI_Controls(NewID).Left = 10
__UI_Controls(NewID).Width = 400
__UI_Controls(NewID).Height = 20
__UI_Controls(NewID).Font = 2
__UI_Controls(NewID).ForeColor = _RGB32(238, 238, 200)
__UI_Controls(NewID).BackColor = _RGB32(33, 100, 78)
__UI_Controls(NewID).Align = __UI_Center
__UI_Controls(NewID).Enabled = __UI_True
__UI_SetCaption "Label1", "Waiting for you to click"

NewID = __UI_NewControl(__UI_Type_Label, "FocusLabel", 0, 0, 0)
__UI_Controls(NewID).Top = 55
__UI_Controls(NewID).Left = 10
__UI_Controls(NewID).Width = 400
__UI_Controls(NewID).Height = 20
__UI_Controls(NewID).ForeColor = _RGB32(0, 0, 0)
__UI_Controls(NewID).Enabled = __UI_True
__UI_SetCaption "FocusLabel", "No object has focus now"
__UI_Controls(NewID).Font = 1

NewID = __UI_NewControl(__UI_Type_Label, "HoverLabel", 0, 0, 0)
__UI_Controls(NewID).Top = 75
__UI_Controls(NewID).Left = 10
__UI_Controls(NewID).Width = 400
__UI_Controls(NewID).Height = 20
__UI_Controls(NewID).ForeColor = _RGB32(0, 0, 0)
__UI_Controls(NewID).Enabled = __UI_True
__UI_Controls(NewID).Font = 1

NewID = __UI_NewControl(__UI_Type_Label, "Label2", 0, 0, 0)
__UI_Controls(NewID).Top = 350
__UI_Controls(NewID).Left = 30
__UI_Controls(NewID).Width = 300
__UI_Controls(NewID).Height = 20
__UI_Controls(NewID).ForeColor = _RGB32(0, 0, 0)
__UI_Controls(NewID).BackStyle = __UI_Transparent
__UI_Controls(NewID).HasBorder = __UI_False
__UI_Controls(NewID).BorderColor = _RGB32(0, 0, 0)
__UI_Controls(NewID).Enabled = __UI_True

NewID = __UI_NewControl(__UI_Type_Frame, "Frame1", 230, 150, 0)
__UI_Controls(NewID).Top = 60
__UI_Controls(NewID).Left = 400
__UI_Controls(NewID).ForeColor = _RGB32(0, 0, 0)
__UI_Controls(NewID).BackColor = __UI_Controls(__UI_FormID).BackColor
__UI_Controls(NewID).HasBorder = __UI_True
__UI_Controls(NewID).BorderColor = _RGB32(0, 0, 0)
__UI_Controls(NewID).Enabled = __UI_True
__UI_SetCaption "Frame1", "Text box options + List"

NewID = __UI_NewControl(__UI_Type_RadioButton, "Option1", 0, 0, __UI_GetID("Frame1"))
__UI_Controls(NewID).Top = 15
__UI_Controls(NewID).Left = 15
__UI_Controls(NewID).Width = 110
__UI_Controls(NewID).Height = 10
__UI_Controls(NewID).ForeColor = _RGB32(0, 0, 0)
__UI_Controls(NewID).Enabled = __UI_True
__UI_Controls(NewID).Value = __UI_True
__UI_Controls(NewID).CanHaveFocus = __UI_True
__UI_SetCaption "Option1", "ALL CAPS"
__UI_Controls(NewID).Font = 2

NewID = __UI_NewControl(__UI_Type_RadioButton, "Option2", 0, 0, __UI_GetID("Frame1"))
__UI_Controls(NewID).Top = 40
__UI_Controls(NewID).Left = 15
__UI_Controls(NewID).Width = 110
__UI_Controls(NewID).Height = 10
__UI_Controls(NewID).ForeColor = _RGB32(0, 0, 0)
__UI_Controls(NewID).Enabled = __UI_True
__UI_Controls(NewID).CanHaveFocus = __UI_True
__UI_SetCaption "Option2", "Normal"
__UI_Controls(NewID).Font = 2

NewID = __UI_NewControl(__UI_Type_CheckBox, "Check1", 0, 0, __UI_GetID("Frame1"))
__UI_Controls(NewID).Top = 65
__UI_Controls(NewID).Left = 15
__UI_Controls(NewID).Width = 130
__UI_Controls(NewID).Height = 10
__UI_Controls(NewID).ForeColor = _RGB32(0, 0, 0)
__UI_Controls(NewID).Enabled = __UI_True
__UI_Controls(NewID).CanHaveFocus = __UI_True
__UI_SetCaption "Check1", "Allow numbers"
__UI_Controls(NewID).Font = 2

NewID = __UI_NewControl(__UI_Type_CheckBox, "Check2", 0, 0, __UI_GetID("Frame1"))
__UI_Controls(NewID).Top = 90
__UI_Controls(NewID).Left = 15
__UI_Controls(NewID).Width = 110
__UI_Controls(NewID).Height = 10
__UI_Controls(NewID).ForeColor = _RGB32(0, 0, 0)
__UI_Controls(NewID).Enabled = __UI_True
__UI_Controls(NewID).Value = __UI_True
__UI_Controls(NewID).CanHaveFocus = __UI_True
__UI_SetCaption "Check2", "Allow letters"
__UI_Controls(NewID).Font = 2

NewID = __UI_NewControl(__UI_Type_DropdownList, "ListBox1", 0, 0, __UI_GetID("Frame1"))
__UI_Controls(NewID).Top = 110
__UI_Controls(NewID).Left = 15
__UI_Controls(NewID).Width = 200
__UI_Controls(NewID).Height = 28
__UI_Controls(NewID).ForeColor = _RGB32(0, 0, 0)
__UI_Controls(NewID).BackColor = _RGB32(255, 255, 255)
__UI_Controls(NewID).SelectedForeColor = _RGB32(255, 255, 255)
__UI_Controls(NewID).SelectedBackColor = _RGB32(50, 116, 255)
__UI_Controls(NewID).HasBorder = __UI_True
__UI_Controls(NewID).BorderColor = _RGB32(0, 0, 0)
__UI_Controls(NewID).CanHaveFocus = __UI_True
__UI_Controls(NewID).Enabled = __UI_True
__UI_AddListBoxItem "ListBox1", "Type in the textbox"
__UI_AddListBoxItem "ListBox1", "to add items here"
DIM i AS INTEGER
FOR i = 3 TO 120
    __UI_AddListBoxItem "ListBox1", "Item" + STR$(i)
NEXT i
__UI_Controls(NewID).Value = 1

NewID = __UI_NewControl(__UI_Type_ProgressBar, "ProgressBar1", 0, 0, 0)
__UI_Controls(NewID).Top = 375
__UI_Controls(NewID).Left = 30
__UI_Controls(NewID).Width = 300
__UI_Controls(NewID).Height = 20
__UI_Controls(NewID).ForeColor = _RGB32(0, 128, 0)
__UI_Controls(NewID).BackColor = __UI_Controls(__UI_FormID).BackColor
__UI_Controls(NewID).HasBorder = __UI_True
__UI_Controls(NewID).BorderColor = _RGB32(0, 0, 0)
__UI_Controls(NewID).Font = 1
__UI_Controls(NewID).Min = 0
__UI_Controls(NewID).Max = 500
__UI_Controls(NewID).ShowPercentage = __UI_True
__UI_Controls(NewID).Height = 20
__UI_Controls(NewID).Enabled = __UI_True
__UI_SetCaption "ProgressBar1", "Ready"

NewID = __UI_NewControl(__UI_Type_Button, "StopBar", 0, 0, 0)
__UI_Controls(NewID).Top = 370
__UI_Controls(NewID).Left = 340
__UI_Controls(NewID).Width = 130
__UI_Controls(NewID).Height = 20
__UI_Controls(NewID).ForeColor = _RGB32(255, 255, 255)
__UI_Controls(NewID).BackColor = _RGB32(51, 152, 219)
__UI_Controls(NewID).CanHaveFocus = __UI_True
__UI_Controls(NewID).Enabled = __UI_True
__UI_SetCaption "StopBar", "Start task"

NewID = __UI_NewControl(__UI_Type_Button, "OkButton", 0, 0, 0)
__UI_Controls(NewID).Top = 370
__UI_Controls(NewID).Left = 550
__UI_Controls(NewID).Width = 70
__UI_Controls(NewID).Height = 20
__UI_Controls(NewID).ForeColor = _RGB32(255, 255, 255)
__UI_Controls(NewID).BackColor = _RGB32(51, 152, 219)
__UI_Controls(NewID).CanHaveFocus = __UI_True
__UI_Controls(NewID).Enabled = __UI_True
__UI_SetCaption "OkButton", "OK"
__UI_DefaultButtonID = NewID

'Main loop
DO
    IF __UI_Loaded = __UI_False THEN __UI_Load

    __UI_DoEvents
    _LIMIT 30
LOOP

'---------------------------------------------------------------------------------
SUB __UI_Load
    DIM i AS LONG
    SCREEN _NEWIMAGE(__UI_Controls(__UI_FormID).Width, __UI_Controls(__UI_FormID).Height, 32)
    DO UNTIL _SCREENEXISTS: _LIMIT 10: LOOP

    IF __UI_Controls(__UI_FormID).CenteredWindow THEN _SCREENMOVE _MIDDLE

    FOR i = 1 TO UBOUND(__UI_Controls)
        IF __UI_Controls(i).Type = __UI_Type_TextBox THEN
            IF _FONTWIDTH(__UI_Fonts(__UI_Controls(i).Font)) = 0 THEN __UI_Controls(i).Font = 0
            __UI_Controls(i).FieldArea = __UI_Controls(i).Width \ _FONTWIDTH(__UI_Fonts(__UI_Controls(i).Font)) - 1
        END IF
    NEXT

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
        CASE "FORM1"

        CASE "OKBUTTON"
            SYSTEM
        CASE "ADDITEMBT"
            IF LEN(__UI_Texts(__UI_GetID("TextBox1"))) THEN
                __UI_AddListBoxItem "ListBox1", __UI_Texts(__UI_GetID("TextBox1"))
                __UI_Texts(__UI_GetID("TextBox1")) = ""
                __UI_Controls(__UI_GetID("TextBox1")).Cursor = 0
                __UI_Controls(__UI_GetID("TextBox1")).Selected = __UI_False
                __UI_Focus = __UI_GetID("TextBox1")
            END IF
        CASE "BUTTON1"
            STATIC State AS _BYTE, TotalStops AS _BYTE
            State = State + 1: IF State > 3 THEN State = 1
            SELECT CASE State
                CASE 1
                    __UI_Controls(__UI_GetID("Label1")).Enabled = __UI_True
                    __UI_Captions(__UI_GetID("Label1")) = "You clicked the button!"
                CASE 2
                    __UI_Captions(__UI_GetID("Label1")) = "Aren't you the clicker? You'd better stop it"
                CASE 3
                    __UI_Controls(__UI_GetID("Label1")).Enabled = __UI_False
                    __UI_Captions(__UI_GetID("Label1")) = "Stop it."
                    IF TotalStops < 2 THEN
                        TotalStops = TotalStops + 1
                    ELSE
                        __UI_Controls(__UI_GetID("Button1")).Enabled = __UI_False
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
        CASE "STOPBAR"
            __UI_Controls(__UI_GetID("StopBar")).Enabled = __UI_False
            DIM i AS LONG
            __UI_SetCaption "Label2", "Performing task:"
            __UI_Controls(__UI_GetID("ProgressBar1")).Max = 300000
            __UI_SetCaption "ProgressBar1", "Counting to 300,000... \#"
            __UI_Controls(__UI_GetID("ProgressBar1")).Value = 0
            i = 0
            DO WHILE i < 300000
                i = i + 1
                __UI_Controls(__UI_GetID("ProgressBar1")).Value = i
                __UI_DoEvents
            LOOP
            __UI_SetCaption "Label2", "Idle."
            __UI_Controls(__UI_GetID("StopBar")).Enabled = __UI_True
            __UI_SetCaption "ProgressBar1", "Done."
        CASE "DRAGBUTTON"
            __UI_Controls(__UI_GetID("listbox1")).CanDrag = NOT __UI_Controls(__UI_GetID("listbox1")).CanDrag
            IF __UI_Controls(__UI_GetID("listbox1")).CanDrag THEN
                __UI_Captions(__UI_GetID("DragButton")) = "List is draggable"
            ELSE
                __UI_Captions(__UI_GetID("DragButton")) = "List is not draggable"
            END IF
        CASE "LABEL1"
            __UI_Captions(__UI_GetID("Label1")) = "I'm not a button..."
    END SELECT
END SUB

SUB __UI_MouseEnter (id AS LONG)
    SELECT CASE UCASE$(RTRIM$(__UI_Controls(id).Name))
        CASE "FORM1"

        CASE "BUTTON1"

        CASE "LABEL1"
            IF __UI_Controls(__UI_GetID("Label1")).Enabled THEN
                __UI_Controls(__UI_GetID("Label1")).BackColor = _RGB32(127, 172, 127)
            END IF
    END SELECT
END SUB

SUB __UI_MouseLeave (id AS LONG)
    SELECT CASE UCASE$(RTRIM$(__UI_Controls(id).Name))
        CASE "FORM1"

        CASE "BUTTON1"

        CASE "LABEL1"
            IF __UI_Controls(__UI_GetID("Label1")).Enabled THEN
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
    STATIC Iterations AS LONG, Pass AS LONG
    Iterations = Iterations + 1

    IF LEN(__UI_Texts(__UI_GetID("TextBox1"))) THEN
        __UI_Controls(__UI_GetID("AddItemBT")).Enabled = __UI_True
    ELSE
        __UI_Controls(__UI_GetID("AddItemBT")).Enabled = __UI_False
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
    END IF

    IF __UI_HoveringID THEN
        __UI_SetCaption "HoverLabel", "Hovering " + RTRIM$(__UI_Controls(__UI_HoveringID).Name)
    END IF

    IF __UI_IsDragging = __UI_False THEN
        IF __UI_Controls(__UI_Focus).Type = __UI_Type_TextBox THEN
            IF __UI_IsSelectingText THEN
                __UI_SetCaption "Label2", "Sel.Start=" + STR$(__UI_Controls(__UI_IsSelectingTextOnID).SelectionStart) + " Cursor=" + STR$(__UI_Controls(__UI_Focus).Cursor)
                __UI_SetCaption "HoverLabel", "Selected?" + STR$(__UI_Controls(__UI_IsSelectingTextOnID).Selected)
            ELSE
                __UI_SetCaption "Label2", "Editing text on " + RTRIM$(__UI_Controls(__UI_Focus).Name)
            END IF
        END IF
    ELSE
        __UI_SetCaption "Label2", "Dragging..." + STR$(__UI_PreviewLeft) + "," + STR$(__UI_PreviewTop)
    END IF
END SUB

SUB __UI_BeforeUnload
    IF __UI_MessageBox("Sure?", "Leaving UI", __UI_MsgBox_YesNo + __UI_MsgBox_Question) = __UI_MsgBox_No THEN
        __UI_UnloadSignal = __UI_False
    END IF
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

    'Mouse input:
    __UI_MouseWheel = 0
    WHILE _MOUSEINPUT
        __UI_MouseWheel = __UI_MouseWheel + _MOUSEWHEEL
    WEND

    IF __UI_MouseWheel THEN __UI_HasInput = __UI_True

    __UI_MouseLeft = _MOUSEX
    __UI_MouseTop = _MOUSEY
    __UI_MouseButton1 = _MOUSEBUTTON(1)
    __UI_MouseButton2 = _MOUSEBUTTON(2)

    IF __UI_PrevMouseX <> __UI_MouseLeft THEN _
        __UI_HasInput = __UI_True: __UI_PrevMouseX = __UI_MouseLeft
    IF __UI_PrevMouseY <> __UI_MouseTop THEN _
        __UI_HasInput = __UI_True: __UI_PrevMouseY = __UI_MouseTop
    IF __UI_PrevMouseButton1 <> __UI_MouseButton1 THEN
        __UI_HasInput = __UI_True: __UI_PrevMouseButton1 = __UI_MouseButton1
    ELSE
        IF __UI_MouseIsDown THEN __UI_HasInput = __UI_True
    END IF
    IF __UI_PrevMouseButton2 <> __UI_MouseButton2 THEN _
        __UI_HasInput = __UI_True: __UI_PrevMouseButton2 = __UI_MouseButton2

    'Hover detection
    FOR i = 1 TO UBOUND(__UI_Controls)
        IF __UI_Controls(i).ID THEN
            __UI_Controls(i).HoveringVScrollbarButton = 0
            IF __UI_Controls(i).ParentID THEN
                ContainerOffsetTop = __UI_Controls(__UI_Controls(i).ParentID).Top
                ContainerOffsetLeft = __UI_Controls(__UI_Controls(i).ParentID).Left
                'First make sure the mouse is inside the container:
                IF __UI_MouseLeft >= ContainerOffsetLeft AND _
                   __UI_MouseLeft <= ContainerOffsetLeft + __UI_Controls(__UI_Controls(i).ParentID).Width - 1 AND _
                   __UI_MouseTop >= ContainerOffsetTop AND _
                   __UI_MouseTop <= ContainerOffsetTop + __UI_Controls(__UI_Controls(i).ParentID).Height - 1 THEN
                    'We're in. Now check for individual control:
                    IF __UI_MouseLeft >= ContainerOffsetLeft + __UI_Controls(i).Left AND _
                       __UI_MouseLeft <= ContainerOffsetLeft + __UI_Controls(i).Left + __UI_Controls(i).Width - 1 AND _
                       __UI_MouseTop >= ContainerOffsetTop + __UI_Controls(i).Top AND _
                       __UI_MouseTop <= ContainerOffsetTop + __UI_Controls(i).Top +  __UI_Controls(i).Height - 1 THEN
                        __UI_HoveringID = i

                        IF __UI_Controls(i).HasVScrollbar AND __UI_IsDragging = __UI_False THEN
                            IF __UI_MouseLeft >= ContainerOffsetLeft + __UI_Controls(i).Left + __UI_Controls(i).Width - __UI_Controls(i).VScrollbarWidth THEN
                                IF __UI_MouseTop <= __UI_Controls(i).Top + ContainerOffsetTop + __UI_Controls(i).VScrollbarButtonHeight AND _
                                   __UI_DraggingThumb = __UI_False THEN
                                    'Hovering "up" button
                                    __UI_Controls(i).HoveringVScrollbarButton = 1
                                    __UI_Controls(i).PreviousInputViewStart = 0
                                ELSEIF __UI_MouseTop >= __UI_Controls(i).Top + ContainerOffsetTop + __UI_Controls(i).Height - __UI_Controls(i).VScrollbarButtonHeight AND _
                                       __UI_DraggingThumb = __UI_False THEN
                                    'Hovering "down" button
                                    __UI_Controls(i).HoveringVScrollbarButton = 2
                                    __UI_Controls(i).PreviousInputViewStart = 0
                                ELSEIF __UI_MouseTop >= ContainerOffsetTop + __UI_Controls(i).ThumbTop AND _
                                       __UI_MouseTop <= ContainerOffsetTop + __UI_Controls(i).ThumbTop + __UI_Controls(i).ThumbHeight THEN
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

                IF __UI_MouseLeft >= __UI_Controls(i).Left AND _
                   __UI_MouseLeft <= __UI_Controls(i).Left + __UI_Controls(i).Width - 1 AND _
                   __UI_MouseTop >= __UI_Controls(i).Top AND _
                   __UI_MouseTop <= __UI_Controls(i).Top +  __UI_Controls(i).Height - 1 THEN
                    __UI_HoveringID = i

                    IF __UI_Controls(i).HasVScrollbar AND __UI_IsDragging = __UI_False THEN
                        IF __UI_MouseLeft >= ContainerOffsetLeft + __UI_Controls(i).Left + __UI_Controls(i).Width - __UI_Controls(i).VScrollbarWidth THEN
                                IF __UI_MouseTop <= __UI_Controls(i).Top + ContainerOffsetTop + __UI_Controls(i).VScrollbarButtonHeight AND _
                                   __UI_DraggingThumb = __UI_False THEN
                                'Hovering "up" button
                                __UI_Controls(i).HoveringVScrollbarButton = 1
                                __UI_Controls(i).PreviousInputViewStart = 0
                                ELSEIF __UI_MouseTop >= __UI_Controls(i).Top + ContainerOffsetTop + __UI_Controls(i).Height - __UI_Controls(i).VScrollbarButtonHeight AND _
                                       __UI_DraggingThumb = __UI_False THEN
                                'Hovering "down" button
                                __UI_Controls(i).HoveringVScrollbarButton = 2
                                __UI_Controls(i).PreviousInputViewStart = 0
                                ELSEIF __UI_MouseTop >= ContainerOffsetTop + __UI_Controls(i).ThumbTop AND _
                                       __UI_MouseTop <= ContainerOffsetTop + __UI_Controls(i).ThumbTop + __UI_Controls(i).ThumbHeight THEN
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
    DIM i AS LONG, TempCaption$, TempColor~&
    DIM CaptionIndent AS INTEGER
    DIM ContainerOffsetLeft AS INTEGER, ContainerOffsetTop AS INTEGER

    DIM ControlState AS _BYTE '1 = Normal; 2 = Hover/focus; 3 = Mouse down; 4 = Disabled

    __UI_BeforeUpdateDisplay

    'Clear the main window:
    COLOR __UI_Controls(__UI_FormID).ForeColor, __UI_Controls(__UI_FormID).BackColor
    CLS

    'Clear frames canvases too:
    FOR i = 1 TO UBOUND(__UI_Controls)
        IF __UI_Controls(i).Type = __UI_Type_Frame THEN
            _DEST __UI_Controls(i).Canvas
            COLOR , __UI_Controls(i).BackColor
            CLS
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
            LINE (__UI_PreviewLeft - __UI_Controls(__UI_Controls(__UI_DraggingID).ParentID).Left, __UI_PreviewTop - __UI_Controls(__UI_Controls(__UI_DraggingID).ParentID).Top)-STEP(__UI_Controls(__UI_DraggingID).Width - 1, __UI_Controls(__UI_DraggingID).Height - 1), __UI_Darken(__UI_Controls(__UI_FormID).BackColor, 80), B
        ELSE
            FOR GridX = 0 TO __UI_Controls(__UI_FormID).Width STEP 10
                FOR GridY = 0 TO __UI_Controls(__UI_FormID).Height STEP 10
                    PSET (GridX, GridY), __UI_Controls(__UI_FormID).ForeColor
                NEXT
            NEXT
        END IF
        _DEST 0
        LINE (__UI_PreviewLeft, __UI_PreviewTop)-STEP(__UI_Controls(__UI_DraggingID).Width - 1, __UI_Controls(__UI_DraggingID).Height - 1), __UI_Darken(__UI_Controls(__UI_FormID).BackColor, 80), B
    END IF

    'Control drawing
    ContainerOffsetTop = 0
    ContainerOffsetLeft = 0
    FOR i = 1 TO UBOUND(__UI_Controls)
        IF __UI_Controls(i).ID THEN
            TempCaption$ = __UI_ClipText(__UI_Captions(i), __UI_Controls(i).Width)

            'Direct the drawing to the right canvas (main or container)
            IF __UI_Controls(i).ParentID THEN
                _DEST __UI_Controls(__UI_Controls(i).ParentID).Canvas
            ELSE
                _DEST 0
            END IF

            IF ((__UI_MouseIsDown AND i = __UI_MouseDownOnID) OR _
               (__UI_KeyIsDown AND i = __UI_KeyDownOnID AND __UI_KeyDownOnID = __UI_Focus)) AND _
               __UI_Controls(i).Enabled THEN
                ControlState = 3
            ELSEIF i = __UI_HoveringID AND __UI_Controls(i).Enabled THEN
                ControlState = 2
            ELSEIF __UI_Controls(i).Enabled = __UI_False THEN
                ControlState = 4
            ELSE
                ControlState = 1
            END IF

            IF __UI_Controls(i).Hidden = __UI_False THEN
                SELECT CASE __UI_Controls(i).Type
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

                        IF __UI_Controls(i).Selected THEN
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
                    _DEST 0
                    TempCaption$ = __UI_ClipText(" " + __UI_Captions(ThisParent) + " ", __UI_Controls(ThisParent).Width)

                    _FONT __UI_Fonts(__UI_Controls(ThisParent).Font)

                    IF __UI_Controls(ThisParent).Hidden = __UI_False THEN
                        IF __UI_Controls(ThisParent).BackStyle = __UI_Opaque THEN
                            _PRINTMODE _FILLBACKGROUND
                        ELSE
                            _PRINTMODE _KEEPBACKGROUND
                        END IF

                        IF __UI_Controls(ThisParent).BackStyle = __UI_Opaque THEN
                            __UI_DrawRectangle __UI_Controls(ThisParent).Left, __UI_Controls(ThisParent).Top, __UI_Controls(ThisParent).Width, __UI_Controls(ThisParent).Height, __UI_Controls(ThisParent).BackColor, __UI_Controls(ThisParent).BackColor, __UI_True
                        END IF

                        CaptionIndent = 0
                        IF __UI_Controls(ThisParent).HasBorder = __UI_True THEN CaptionIndent = 5

                        IF __UI_Controls(ThisParent).Enabled THEN
                            COLOR __UI_Controls(ThisParent).ForeColor, __UI_Controls(ThisParent).BackColor
                        ELSE
                            COLOR __UI_Darken(__UI_Controls(__UI_FormID).BackColor, 80), __UI_Controls(ThisParent).BackColor
                        END IF

                        _PUTIMAGE (__UI_Controls(ThisParent).Left + CaptionIndent, __UI_Controls(ThisParent).Top + CaptionIndent), __UI_Controls(ThisParent).Canvas, 0, (CaptionIndent, CaptionIndent)-(__UI_Controls(ThisParent).Width, __UI_Controls(ThisParent).Height)

                        IF __UI_Controls(ThisParent).HasBorder = __UI_True THEN
                            CaptionIndent = 5
                            __UI_DrawRectangle __UI_Controls(ThisParent).Left, __UI_Controls(ThisParent).Top, __UI_Controls(ThisParent).Width, __UI_Controls(ThisParent).Height, __UI_Controls(ThisParent).BorderColor, 0, __UI_False
                        END IF

                        SELECT CASE __UI_Controls(ThisParent).Align
                            CASE __UI_Left
                                _PRINTSTRING (__UI_Controls(ThisParent).Left + CaptionIndent, __UI_Controls(ThisParent).Top - _FONTHEIGHT \ 2), TempCaption$
                            CASE __UI_Center
                                _PRINTSTRING (__UI_Controls(ThisParent).Left + (__UI_Controls(ThisParent).Width \ 2 - _PRINTWIDTH(TempCaption$) \ 2), __UI_Controls(ThisParent).Top - _FONTHEIGHT \ 2), TempCaption$
                            CASE __UI_Right
                                _PRINTSTRING (__UI_Controls(ThisParent).Left + (__UI_Controls(ThisParent).Width - _PRINTWIDTH(TempCaption$)) - CaptionIndent, __UI_Controls(ThisParent).Top - _FONTHEIGHT \ 2), TempCaption$
                        END SELECT
                    END IF
                END IF
            END IF 'Has Parent
        END IF 'Valid ID
    NEXT

    IF TIMER - __UI_LastInputReceived > 2 THEN
        'Visually indicate that something is hogging the input routine
        LINE (0, 0)-STEP(_WIDTH, _HEIGHT), _RGBA32(0, 0, 0, 200), BF
        _FONT 16
        _PRINTMODE _KEEPBACKGROUND
        DIM NoInputMessage$
        NoInputMessage$ = "Please wait..."
        COLOR _RGB32(0, 0, 0)
        _PRINTSTRING (_WIDTH / 2 - _PRINTWIDTH(NoInputMessage$) / 2 + 1, _HEIGHT \ 2 - _FONTWIDTH + 1), NoInputMessage$
        COLOR _RGB32(255, 255, 255)
        _PRINTSTRING (_WIDTH / 2 - _PRINTWIDTH(NoInputMessage$) / 2, _HEIGHT \ 2 - _FONTWIDTH), NoInputMessage$
    END IF

    _DISPLAY
END SUB

'---------------------------------------------------------------------------------
FUNCTION __UI_Darken~& (WhichColor~&, ByHowMuch%)
    __UI_Darken~& = _RGB32(_RED(WhichColor~&) * (ByHowMuch% / 100), _GREEN(WhichColor~&) * (ByHowMuch% / 100), _BLUE(WhichColor~&) * (ByHowMuch% / 100))
END FUNCTION

SUB __UI_DrawRectangle (x1 AS SINGLE, y1 AS SINGLE, Width&, Height&, BorderColor~&, BackColor~&, Fill%%)
    'Rounded rectangles code adapted from stylin
    '(http://www.qb64.net/forum/index.php?topic=4168.msg42352#msg42352)
    'Rounded rectangles filling code provided courtesy of ___vincent

    DIM x2 AS SINGLE, y2 AS SINGLE
    DIM radius AS SINGLE, ul_radius AS SINGLE, ur_radius AS SINGLE
    DIM a AS SINGLE, b AS SINGLE, e AS SINGLE
    DIM ll_radius AS SINGLE, lr_radius AS SINGLE

    radius = 5
    ul_radius = radius
    ur_radius = radius
    ll_radius = radius
    lr_radius = radius

    x2 = x1 + Width& - 1
    y2 = y1 + Height& - 1

    IF (x2 < x1) THEN SWAP x1, x2
    IF (y2 < y1) THEN SWAP y1, y2

    DIM w AS SINGLE: w = x2 - x1 + 1
    DIM h AS SINGLE: h = y2 - y1 + 1

    IF Fill%% THEN
        LINE (x1, y1 + radius)-(x2, y2 - radius), BackColor~&, BF

        a = radius
        b = 0
        e = -a

        DO WHILE a >= b
            LINE (x1 + radius - b, y1 + radius - a)-(x2 - radius + b, y1 + radius - a), BackColor~&, BF
            LINE (x1 + radius - a, y1 + radius - b)-(x2 - radius + a, y1 + radius - b), BackColor~&, BF
            LINE (x1 + radius - b, y2 - radius + a)-(x2 - radius + b, y2 - radius + a), BackColor~&, BF
            LINE (x1 + radius - a, y2 - radius + b)-(x2 - radius + a, y2 - radius + b), BackColor~&, BF

            b = b + 1
            e = e + b + b
            IF e > 0 THEN
                a = a - 1
                e = e - a - a
            END IF
        LOOP
    END IF

    ' Top.
    LINE (x1 + ul_radius - 1, y1)-(x2 - ur_radius + 1, y1), BorderColor~&
    ' Bottom.
    LINE (x1 + ll_radius - 1, y2)-(x2 - lr_radius + 1, y2), BorderColor~&
    ' Left.
    LINE (x1, y1 + ul_radius - 1)-(x1, y2 - ll_radius + 1), BorderColor~&
    ' Right.
    LINE (x2, y1 + ur_radius - 1)-(x2, y2 - lr_radius + 1), BorderColor~&

    ' Upper-left.
    CIRCLE (x1 + ul_radius, y1 + ul_radius), ul_radius, BorderColor~&, _PI * 0.5, _PI, 1
    ' Upper-right.
    CIRCLE (x2 - ur_radius, y1 + ur_radius), ur_radius, BorderColor~&, 0.0, _PI * 0.5, 1
    ' Lower-left.
    CIRCLE (x1 + ll_radius, y2 - ll_radius), ll_radius, BorderColor~&, _PI, _PI * 1.5, 1
    ' Lower-right.
    CIRCLE (x2 - lr_radius, y2 - lr_radius), lr_radius, BorderColor~&, _PI * 1.5, 0.0, 1
END SUB

SUB __UI_EventDispatcher
    STATIC __UI_LastHoveringID AS LONG
    STATIC __UI_ThumbDragY AS INTEGER
    DIM i AS LONG
    DIM ContainerOffsetLeft AS INTEGER, ContainerOffsetTop AS INTEGER

    IF __UI_HoveringID = 0 THEN EXIT SUB

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

    IF __UI_Controls(__UI_HoveringID).CanDrag THEN
        _MOUSESHOW "link"
    ELSEIF __UI_Controls(__UI_HoveringID).Type = __UI_Type_TextBox THEN
        _MOUSESHOW "text"
    ELSE
        _MOUSESHOW "default"
    END IF

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

            IF __UI_Controls(__UI_FocusSearch).CanHaveFocus AND __UI_Controls(__UI_FocusSearch).Enabled THEN
                IF __UI_Focus THEN __UI_FocusOut __UI_Focus
                __UI_Focus = __UI_FocusSearch
                __UI_FocusIn __UI_Focus
                EXIT DO
            END IF
        LOOP
    END IF

    'Any visible dropdown lists will be destroyed when focus is lost
    IF __UI_ActiveDropdownList > 0 AND __UI_Focus <> __UI_ActiveDropdownList AND __UI_Focus <> __UI_ParentDropdownList THEN
        __UI_Focus = __UI_ParentDropdownList
        __UI_DestroyControl __UI_Controls(__UI_ActiveDropdownList)
        __UI_ActiveDropdownList = 0
        __UI_ParentDropdownList = 0
    END IF

    'MouseWheel
    IF __UI_MouseWheel THEN
        IF __UI_Controls(__UI_HoveringID).Type = __UI_Type_ListBox AND __UI_Controls(__UI_HoveringID).Enabled THEN
            __UI_Controls(__UI_HoveringID).InputViewStart = __UI_Controls(__UI_HoveringID).InputViewStart + __UI_MouseWheel
            IF __UI_Controls(__UI_HoveringID).InputViewStart + __UI_Controls(__UI_HoveringID).LastVisibleItem > __UI_Controls(__UI_HoveringID).Max THEN
                __UI_Controls(__UI_HoveringID).InputViewStart = __UI_Controls(__UI_HoveringID).Max - __UI_Controls(__UI_HoveringID).LastVisibleItem + 1
            END IF
        ELSEIF __UI_Controls(__UI_Focus).Type = __UI_Type_DropdownList AND __UI_Controls(__UI_Focus).Enabled THEN
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
            IF __UI_Controls(__UI_HoveringID).CanHaveFocus AND __UI_Controls(__UI_HoveringID).Enabled THEN
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
            IF __UI_Controls(__UI_HoveringID).Type = __UI_Type_TextBox AND __UI_Controls(__UI_HoveringID).Enabled THEN
                _FONT __UI_Fonts(__UI_Controls(__UI_HoveringID).Font)
                IF __UI_IsSelectingText = __UI_False THEN
                    __UI_Controls(__UI_HoveringID).Selected = __UI_False
                    __UI_SelectedText = ""
                    __UI_SelectionLength = 0
                    __UI_Controls(__UI_HoveringID).SelectionStart = ((__UI_MouseLeft - __UI_Controls(__UI_HoveringID).Left) / _FONTWIDTH) + (__UI_Controls(__UI_HoveringID).InputViewStart - 1)
                    __UI_Controls(__UI_HoveringID).Cursor = __UI_Controls(__UI_HoveringID).SelectionStart
                    IF __UI_Controls(__UI_HoveringID).SelectionStart > LEN(__UI_Texts(__UI_HoveringID)) THEN __UI_Controls(__UI_HoveringID).SelectionStart = LEN(__UI_Texts(__UI_HoveringID))
                    IF __UI_Controls(__UI_HoveringID).Cursor > LEN(__UI_Texts(__UI_HoveringID)) THEN __UI_Controls(__UI_HoveringID).Cursor = LEN(__UI_Texts(__UI_HoveringID))
                    __UI_IsSelectingText = __UI_True
                    __UI_IsSelectingTextOnID = __UI_HoveringID
                END IF
            ELSEIF __UI_Controls(__UI_HoveringID).Type = __UI_Type_ListBox AND __UI_Controls(__UI_HoveringID).Enabled THEN
                IF __UI_Controls(__UI_HoveringID).HoveringVScrollbarButton = 1 OR __UI_Controls(__UI_HoveringID).HoveringVScrollbarButton = 2 OR _
                   __UI_Controls(__UI_HoveringID).HoveringVScrollbarButton = 4 OR __UI_Controls(__UI_HoveringID).HoveringVScrollbarButton = 5 THEN
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
                            __UI_Controls(__UI_IsSelectingTextOnID).Selected = __UI_True
                        END IF
                    END IF
                END IF

                IF __UI_Controls(__UI_MouseDownOnID).HoveringVScrollbarButton = 1 AND TIMER - __UI_MouseDownOnListBox > .3 THEN
                    'Mousedown on "up" button
                    __UI_Controls(__UI_MouseDownOnID).InputViewStart = __UI_Controls(__UI_MouseDownOnID).InputViewStart - 1
                ELSEIF __UI_Controls(__UI_MouseDownOnID).HoveringVScrollbarButton = 2 AND TIMER - __UI_MouseDownOnListBox > .3 THEN
                    'Mousedown on "down" button
                    IF __UI_Controls(__UI_MouseDownOnID).InputViewStart + __UI_Controls(__UI_MouseDownOnID).LastVisibleItem <= __UI_Controls(__UI_MouseDownOnID).Max THEN
                        __UI_Controls(__UI_MouseDownOnID).InputViewStart = __UI_Controls(__UI_MouseDownOnID).InputViewStart + 1
                    END IF
                ELSEIF __UI_Controls(__UI_MouseDownOnID).HoveringVScrollbarButton = 4 AND TIMER - __UI_MouseDownOnListBox < .3 THEN
                    'Mousedown on "track" area above the thumb
                    __UI_Controls(__UI_MouseDownOnID).InputViewStart = __UI_Controls(__UI_MouseDownOnID).InputViewStart - (__UI_Controls(__UI_MouseDownOnID).LastVisibleItem - 1)
                ELSEIF __UI_Controls(__UI_MouseDownOnID).HoveringVScrollbarButton = 5 AND TIMER - __UI_MouseDownOnListBox < .3 THEN
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
            IF __UI_MouseDownOnID = __UI_HoveringID AND __UI_HoveringID > 0 THEN
                IF __UI_Controls(__UI_HoveringID).Enabled THEN
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
                                IF __UI_MouseTop >= __UI_Controls(__UI_HoveringID).Top + ContainerOffsetTop AND _
                                   __UI_MouseTop <= __UI_Controls(__UI_HoveringID).Top + ContainerOffsetTop + __UI_Controls(__UI_HoveringID).VScrollbarButtonHeight THEN
                                    'Click on "up" button
                                    __UI_Controls(__UI_HoveringID).InputViewStart = __UI_Controls(__UI_HoveringID).InputViewStart - 1
                                ELSEIF __UI_MouseTop >= __UI_Controls(__UI_HoveringID).VScrollbarButton2Top + ContainerOffsetTop THEN
                                    'Click on "down" button
                                    IF __UI_Controls(__UI_HoveringID).InputViewStart + __UI_Controls(__UI_HoveringID).LastVisibleItem <= __UI_Controls(__UI_HoveringID).Max THEN
                                        __UI_Controls(__UI_HoveringID).InputViewStart = __UI_Controls(__UI_HoveringID).InputViewStart + 1
                                    END IF
                                END IF
                            ELSE
                                DIM ThisItem%
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
                    __UI_Click __UI_HoveringID
                    __UI_LastMouseClick = TIMER
                    __UI_MouseDownOnID = 0
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
        IF __UI_MouseTop >= __UI_Controls(__UI_DraggingThumbOnID).Top + __UI_Controls(__UI_Controls(__UI_DraggingThumbOnID).ParentID).Top + __UI_Controls(__UI_DraggingThumbOnID).VScrollbarButtonHeight AND _
           __UI_MouseTop <= __UI_Controls(__UI_DraggingThumbOnID).Top + __UI_Controls(__UI_Controls(__UI_DraggingThumbOnID).ParentID).Top + __UI_Controls(__UI_DraggingThumbOnID).Height - __UI_Controls(__UI_DraggingThumbOnID).VScrollbarButtonHeight THEN
            __UI_Controls(__UI_DraggingThumbOnID).InputViewStart = __UI_Controls(__UI_DraggingThumbOnID).InputViewStart + ((__UI_MouseTop - __UI_ThumbDragY) / __UI_Controls(__UI_DraggingThumbOnID).VScrollbarRatio)
            IF __UI_Controls(__UI_DraggingThumbOnID).InputViewStart + __UI_Controls(__UI_DraggingThumbOnID).LastVisibleItem - 1 > __UI_Controls(__UI_DraggingThumbOnID).Max THEN _
               __UI_Controls(__UI_DraggingThumbOnID).InputViewStart = __UI_Controls(__UI_DraggingThumbOnID).Max - __UI_Controls(__UI_DraggingThumbOnID).LastVisibleItem + 1

            __UI_ThumbDragY = __UI_MouseTop
        END IF
    END IF

    'Keyboard handler
    IF __UI_KeyHit = 27 THEN __UI_Controls(__UI_HoveringID).Enabled = NOT __UI_Controls(__UI_HoveringID).Enabled

    IF __UI_KeyHit = 100303 OR __UI_KeyHit = 100304 THEN __UI_ShiftIsDown = __UI_True
    IF __UI_KeyHit = -100303 OR __UI_KeyHit = -100304 THEN __UI_ShiftIsDown = __UI_False
    IF __UI_KeyHit = 100305 OR __UI_KeyHit = 100306 THEN __UI_CtrlIsDown = __UI_True
    IF __UI_KeyHit = -100305 OR __UI_KeyHit = -100306 THEN __UI_CtrlIsDown = __UI_False
    IF __UI_KeyHit = 100307 OR __UI_KeyHit = 100308 THEN __UI_AltIsDown = __UI_True
    IF __UI_KeyHit = -100307 OR __UI_KeyHit = -100308 THEN __UI_AltIsDown = __UI_False

    IF __UI_Focus THEN
        __UI_KeyPress __UI_Focus

        'Enter activates the selected/default button, if any
        IF __UI_IsDragging = __UI_False AND _
            __UI_KeyHit = -13 AND _
            __UI_Controls(__UI_Focus).Enabled THEN
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
                CASE __UI_Type_Button, __UI_Type_RadioButton, __UI_Type_CheckBox
                    SELECT CASE __UI_KeyHit
                        CASE 32, -32
                            'Emulate mouse down/click
                            IF __UI_IsDragging = __UI_False AND _
                                __UI_KeyHit = 32 AND _
                                __UI_Controls(__UI_Focus).Enabled THEN
                                'Space bar down on a button
                                IF __UI_KeyIsDown = __UI_False AND __UI_KeyDownOnID = 0 THEN
                                    __UI_KeyDownOnID = __UI_Focus
                                    __UI_KeyIsDown = __UI_True
                                END IF
                            ELSEIF __UI_IsDragging = __UI_False AND _
                                __UI_KeyHit = -32 AND _
                                __UI_Controls(__UI_Focus).Enabled THEN
                                'Space bar released and a button has focus
                                IF __UI_KeyIsDown AND __UI_Focus = __UI_KeyDownOnID THEN
                                    IF __UI_Controls(__UI_KeyDownOnID).Type = __UI_Type_RadioButton THEN
                                        __UI_SetRadioButtonValue __UI_KeyDownOnID
                                    ELSEIF __UI_Controls(__UI_KeyDownOnID).Type = __UI_Type_CheckBox THEN
                                        __UI_Controls(__UI_KeyDownOnID).Value = NOT __UI_Controls(__UI_KeyDownOnID).Value
                                    END IF
                                    __UI_Click __UI_Focus
                                END IF
                                __UI_KeyDownOnID = 0
                                __UI_KeyIsDown = __UI_False
                            END IF
                        CASE 18432, 20480 'Up, down
                            IF (__UI_Controls(__UI_Focus).Type = __UI_Type_RadioButton OR _
                               __UI_Controls(__UI_Focus).Type = __UI_Type_CheckBox) THEN
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

                                    IF __UI_Controls(__UI_FocusSearch).CanHaveFocus AND _
                                       __UI_Controls(__UI_FocusSearch).Enabled AND _
                                       __UI_Controls(__UI_Focus).Type = __UI_Controls(__UI_FocusSearch).Type THEN
                                        __UI_FocusOut __UI_Focus
                                        __UI_Focus = __UI_FocusSearch
                                        __UI_FocusIn __UI_Focus
                                        IF __UI_Controls(__UI_FocusSearch).Type = __UI_Type_RadioButton THEN _
                                            __UI_SetRadioButtonValue __UI_Focus
                                        EXIT DO
                                    END IF
                                LOOP
                            END IF
                    END SELECT
                CASE __UI_Type_ListBox, __UI_Type_DropdownList
                    DIM ThisItemTop%, CaptionIndent AS INTEGER
                    IF __UI_Controls(__UI_Focus).Enabled THEN
                        _FONT __UI_Fonts(__UI_Controls(__UI_Focus).Font)
                        SELECT EVERYCASE __UI_KeyHit
                            CASE 32 TO 126 'Printable ASCII characters
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
                    IF __UI_Controls(__UI_Focus).Enabled THEN
                        SELECT CASE __UI_KeyHit
                            CASE 32 TO 126 'Printable ASCII characters
                                IF __UI_KeyHit = ASC("v") OR __UI_KeyHit = ASC("V") THEN 'Paste from clipboard (Ctrl+V)
                                    IF __UI_CtrlIsDown THEN
                                        Clip$ = _CLIPBOARD$
                                        FindLF& = INSTR(Clip$, CHR$(13))
                                        IF FindLF& > 0 THEN Clip$ = LEFT$(Clip$, FindLF& - 1)
                                        FindLF& = INSTR(Clip$, CHR$(10))
                                        IF FindLF& > 0 THEN Clip$ = LEFT$(Clip$, FindLF& - 1)
                                        IF LEN(RTRIM$(LTRIM$(Clip$))) > 0 THEN
                                            IF NOT __UI_Controls(__UI_Focus).Selected THEN
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
                                                __UI_Controls(__UI_Focus).Selected = __UI_False
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
                                        __UI_Controls(__UI_Focus).Selected = __UI_True
                                        __UI_KeyHit = 0
                                    END IF
                                END IF

                                IF __UI_KeyHit THEN
                                    IF NOT __UI_Controls(__UI_Focus).Selected THEN
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
                                        __UI_Controls(__UI_Focus).Selected = __UI_False
                                        __UI_SelectedText = ""
                                        __UI_SelectionLength = 0
                                        __UI_Controls(__UI_Focus).Cursor = s1 + 1
                                    END IF
                                END IF
                            CASE 8 'Backspace
                                IF LEN(__UI_Texts(__UI_Focus)) > 0 THEN
                                    IF NOT __UI_Controls(__UI_Focus).Selected THEN
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
                                    ELSE
                                        __UI_DeleteSelection
                                    END IF
                                END IF
                            CASE 21248 'Delete
                                IF NOT __UI_Controls(__UI_Focus).Selected THEN
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

                        __UI_CursorAdjustments
                    END IF
            END SELECT
        END IF
    ELSE
        'Enter activates the default button, if any
        IF __UI_IsDragging = __UI_False AND _
            __UI_KeyHit = -13 AND _
            __UI_DefaultButtonID > 0 THEN
            'Enter released and there is a default button
            __UI_Click __UI_DefaultButtonID
        END IF
    END IF

    __UI_LastHoveringID = __UI_HoveringID
END SUB

'---------------------------------------------------------------------------------
FUNCTION __UI_GetID (ObjectName$)
    DIM i AS LONG

    FOR i = 1 TO UBOUND(__UI_Controls)
        IF __UI_Controls(i).ID > 0 AND UCASE$(RTRIM$(__UI_Controls(i).Name)) = UCASE$(RTRIM$(ObjectName$)) THEN
            __UI_GetID = i
            EXIT FUNCTION
        END IF
    NEXT

    ERROR 5
END FUNCTION

'---------------------------------------------------------------------------------
FUNCTION __UI_NewControl (ObjType AS INTEGER, ObjName AS STRING, NewWidth AS INTEGER, NewHeight AS INTEGER, ParentID AS LONG)
    DIM NextSlot AS LONG, i AS LONG

    IF ObjType = __UI_Type_Form THEN
        'Make sure no other Form object exists, as Form is the main window
        FOR i = 1 TO UBOUND(__UI_Controls)
            IF __UI_Controls(i).Type = __UI_Type_Form THEN ERROR 5: EXIT FUNCTION
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
    __UI_Controls(NextSlot).Type = ObjType
    __UI_Controls(NextSlot).Name = ObjName
    __UI_Controls(NextSlot).Width = NewWidth
    __UI_Controls(NextSlot).Height = NewHeight
    IF __UI_Controls(NextSlot).Type = __UI_Type_Frame THEN
        __UI_Controls(NextSlot).Canvas = _NEWIMAGE(NewWidth, NewHeight, 32)
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
    END IF
    This.ID = 0
    This.ParentID = 0
    This.Type = 0
    This.Name = ""
    This.Top = 0
    This.Left = 0
    This.Width = 0
    This.Height = 0
    IF This.Canvas <> 0 THEN _FREEIMAGE This.Canvas: This.Canvas = 0
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
    This.Min = 0
    This.Max = 0
    This.ShowPercentage = __UI_False
    This.InputViewStart = 0
    This.LastVisibleItem = 0
    This.HasVScrollbar = __UI_False
    This.VScrollbarButton2Top = 0
    This.VScrollbarButtonHeight = 0
    This.VScrollbarWidth = 0
    This.HoveringVScrollbarButton = 0
    This.ThumbHeight = 0
    This.ThumbTop = 0
    This.VScrollbarRatio = 0
    This.Cursor = 0
    This.PrevCursor = 0
    This.FieldArea = 0
    This.Selected = __UI_False
    This.SelectionStart = 0
    This.Resizable = 0
    This.CanDrag = __UI_False
    This.CanHaveFocus = __UI_False
    This.Enabled = __UI_False
    This.Hidden = __UI_False
    This.CenteredWindow = __UI_False
END SUB

''---------------------------------------------------------------------------------
'FUNCTION __UI_ParentID& (Object$)
'    __UI_ParentID& = __UI_Controls(__UI_GetID(Object$)).ParentID
'END FUNCTION

''---------------------------------------------------------------------------------
'FUNCTION __UI_Type% (Object$)
'    __UI_Type% = __UI_Controls(__UI_GetID(Object$)).ParentID
'END FUNCTION

''---------------------------------------------------------------------------------
'FUNCTION __UI_Name$ (ID)
'    __UI_Name$ = RTRIM$(__UI_Controls(ID).Name)
'END FUNCTION

''---------------------------------------------------------------------------------
'FUNCTION __UI_Top% (Object$)
'    __UI_Top% = __UI_Controls(__UI_GetID(Object$)).Top
'END FUNCTION

''---------------------------------------------------------------------------------
'FUNCTION __UI_Left% (Object$)
'    __UI_Left% = __UI_Controls(__UI_GetID(Object$)).Left
'END FUNCTION

''---------------------------------------------------------------------------------
'FUNCTION __UI_Width% (Object$)
'    __UI_Width% = __UI_Controls(__UI_GetID(Object$)).Width
'END FUNCTION

''---------------------------------------------------------------------------------
'FUNCTION __UI_Height% (Object$)
'    __UI_Height% = __UI_Controls(__UI_GetID(Object$)).Height
'END FUNCTION

''---------------------------------------------------------------------------------
'FUNCTION __UI_BackColor~& (Object$)
'    __UI_BackColor~& = __UI_Controls(__UI_GetID(Object$)).BackColor
'END FUNCTION

''---------------------------------------------------------------------------------
'FUNCTION __UI_ForeColor~& (Object$)
'    __UI_ForeColor~& = __UI_Controls(__UI_GetID(Object$)).ForeColor
'END FUNCTION

''---------------------------------------------------------------------------------
'FUNCTION __UI_BackStyle%% (Object$)
'    __UI_BackStyle%% = __UI_Controls(__UI_GetID(Object$)).BackStyle
'END FUNCTION

''---------------------------------------------------------------------------------
'FUNCTION __UI_Value## (Object$)
'    __UI_Value## = __UI_Controls(__UI_GetID(Object$)).Value
'END FUNCTION

''---------------------------------------------------------------------------------
'FUNCTION __UI_Min## (Object$)
'    __UI_Min## = __UI_Controls(__UI_GetID(Object$)).Min
'END FUNCTION

''---------------------------------------------------------------------------------
'FUNCTION __UI_Max## (Object$)
'    __UI_Max## = __UI_Controls(__UI_GetID(Object$)).Max
'END FUNCTION

''---------------------------------------------------------------------------------
'FUNCTION __UI_Enabled%% (Object$)
'    __UI_Enabled%% = __UI_Controls(__UI_GetID(Object$)).Enabled
'END FUNCTION

''---------------------------------------------------------------------------------
'FUNCTION __UI_CanDrag%% (Object$)
'    __UI_CanDrag%% = __UI_Controls(__UI_GetID(Object$)).CanDrag
'END FUNCTION

''---------------------------------------------------------------------------------
'FUNCTION __UI_Caption$ (Object$)
'    __UI_Caption$ = __UI_Captions(__UI_GetID(Object$))
'END FUNCTION

'---------------------------------------------------------------------------------
SUB __UI_SetCaption (Object$, NewCaption$)
    __UI_Captions(__UI_GetID(Object$)) = NewCaption$
END SUB

'---------------------------------------------------------------------------------
SUB __UI_SetText (Object$, NewText$)
    __UI_Texts(__UI_GetID(Object$)) = NewText$
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
        IF __UI_Controls(i).Type = __UI_Type_RadioButton AND _
           __UI_Controls(i).ParentID = __UI_Controls(id).ParentID THEN
            __UI_Controls(i).Value = __UI_False
        END IF
    NEXT
    __UI_Controls(id).Value = __UI_True
END SUB

'---------------------------------------------------------------------------------
SUB __UI_CheckSelection (id)
    IF __UI_ShiftIsDown THEN
        IF NOT __UI_Controls(id).Selected THEN
            __UI_Controls(id).Selected = __UI_True
            __UI_Controls(id).SelectionStart = __UI_Controls(id).Cursor
        END IF
    ELSE
        __UI_Controls(id).Selected = __UI_False
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
    __UI_Controls(__UI_Focus).Selected = __UI_False
    __UI_SelectedText = ""
    __UI_SelectionLength = 0
    __UI_Controls(__UI_Focus).Cursor = s1
END SUB

'---------------------------------------------------------------------------------
SUB __UI_CursorAdjustments
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
    IF __UI_Controls(ThisID).Type <> __UI_Type_ListBox AND _
       __UI_Controls(ThisID).Type <> __UI_Type_DropdownList THEN ERROR 5: EXIT SUB

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
    IF __UI_Controls(id).Enabled THEN
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
        __UI_Controls(__UI_ActiveDropdownList).Enabled = __UI_True
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
SUB __UI_MakeHardwareImage (SoftwareImage AS LONG)
    'DIM TempCanvas AS LONG

    'TempCanvas = _COPYIMAGE(SoftwareImage, 33)
    '_FREEIMAGE SoftwareImage
    'SoftwareImage = TempCanvas
END SUB

'---------------------------------------------------------------------------------
SUB __UI_DrawButton (This AS __UI_ControlTYPE, ControlState AS _BYTE)
    'ControlState: 1 = Normal; 2 = Hover/focus; 3 = Mouse down; 4 = Disabled
    DIM TempColor~&, TempCaption$, HasShadow AS _BYTE
    DIM PrevDest AS LONG

    IF This.ControlState <> ControlState OR This.FocusState <> __UI_Focus OR __UI_Captions(This.ID) <> __UI_TempCaptions(This.ID) THEN
        'Last time we drew this control it had a different state/caption, so let's redraw it
        This.ControlState = ControlState
        This.FocusState = __UI_Focus
        __UI_TempCaptions(This.ID) = __UI_Captions(This.ID)

        IF This.Canvas <> 0 THEN
            _FREEIMAGE This.Canvas
        END IF

        This.Canvas = _NEWIMAGE(This.Width + 2, This.Height + 2, 32)

        PrevDest = _DEST
        _DEST This.Canvas
        _FONT __UI_Fonts(This.Font)
        CLS , _RGBA32(0, 0, 0, 0)
        TempCaption$ = __UI_ClipText(__UI_Captions(This.ID), This.Width)

        IF ControlState = 1 THEN
            TempColor~& = This.BackColor
        ELSEIF ControlState = 2 THEN
            TempColor~& = __UI_Darken(This.BackColor, 90)
        ELSEIF ControlState = 3 THEN
            TempColor~& = __UI_Darken(This.BackColor, 70)
        ELSEIF ControlState = 4 THEN
            TempColor~& = _RGB32(208, 213, 216)
        END IF

        'Shadow:
        IF ControlState <> 3 THEN
            __UI_DrawRectangle 2, 2, This.Width, This.Height, This.BorderColor, __UI_Darken(__UI_Controls(__UI_FormID).BackColor, 50), __UI_True
        END IF

        'Button:
        __UI_DrawRectangle 0, 0, This.Width, This.Height, This.BorderColor, TempColor~&, __UI_True

        'Caption:
        _PRINTMODE _KEEPBACKGROUND
        IF This.Enabled THEN
            IF (This.ID = __UI_DefaultButtonID AND This.ID <> __UI_Focus AND __UI_Controls(__UI_Focus).Type <> __UI_Type_Button) OR This.ID = __UI_Focus THEN
                COLOR __UI_Darken(__UI_Controls(__UI_FormID).BackColor, 20), TempColor~&
                _PRINTSTRING ((This.Width \ 2 - _PRINTWIDTH(TempCaption$) \ 2) + 1, ((This.Height \ 2) - _FONTHEIGHT \ 2) + 1), TempCaption$
            END IF
        END IF

        IF This.Enabled THEN
            COLOR This.ForeColor, TempColor~&
        ELSE
            COLOR __UI_Darken(__UI_Controls(__UI_FormID).BackColor, 80), TempColor~&
        END IF
        _PRINTSTRING ((This.Width \ 2 - _PRINTWIDTH(TempCaption$) \ 2), ((This.Height \ 2) - _FONTHEIGHT \ 2)), TempCaption$

        __UI_MakeHardwareImage This.Canvas
        _DEST PrevDest
    END IF

    _PUTIMAGE (This.Left, This.Top), This.Canvas
END SUB

'---------------------------------------------------------------------------------
SUB __UI_DrawLabel (This AS __UI_ControlTYPE, ControlState AS _BYTE)
    DIM PrevDest AS LONG
    DIM CaptionIndent AS INTEGER, TempCaption$

    IF This.ControlState <> ControlState OR __UI_Captions(This.ID) <> __UI_TempCaptions(This.ID) THEN
        'Last time we drew this control it had a different state/caption, so let's redraw it
        This.ControlState = ControlState
        __UI_TempCaptions(This.ID) = __UI_Captions(This.ID)

        IF This.Canvas <> 0 THEN
            _FREEIMAGE This.Canvas
        END IF

        This.Canvas = _NEWIMAGE(This.Width, This.Height, 32)

        PrevDest = _DEST
        _DEST This.Canvas
        _FONT __UI_Fonts(This.Font)
        CLS , _RGBA32(0, 0, 0, 0)

        IF This.HasBorder THEN CaptionIndent = 5 ELSE CaptionIndent = 0

        TempCaption$ = __UI_ClipText(__UI_Captions(This.ID), This.Width - CaptionIndent * 2)

        IF This.BackStyle = __UI_Opaque THEN
            _PRINTMODE _FILLBACKGROUND
            LINE (0, 0)-STEP(This.Width - 1, This.Height - 1), This.BackColor, BF
        ELSE
            _PRINTMODE _KEEPBACKGROUND
        END IF

        IF This.HasBorder THEN
            LINE (0, 0)-STEP(This.Width - 1, This.Height - 1), This.BorderColor, B
        END IF

        IF This.Enabled THEN
            COLOR This.ForeColor, This.BackColor
        ELSE
            COLOR __UI_Darken(__UI_Controls(__UI_FormID).BackColor, 80), This.BackColor
        END IF

        SELECT CASE This.Align
            CASE __UI_Left
                _PRINTSTRING (CaptionIndent, ((This.Height \ 2) - _FONTHEIGHT \ 2)), TempCaption$
            CASE __UI_Center
                _PRINTSTRING ((This.Width \ 2 - _PRINTWIDTH(TempCaption$) \ 2), ((This.Height \ 2) - _FONTHEIGHT \ 2)), TempCaption$
            CASE __UI_Right
                _PRINTSTRING ((This.Width - _PRINTWIDTH(TempCaption$)) - CaptionIndent, ((This.Height \ 2) - _FONTHEIGHT \ 2)), TempCaption$
        END SELECT

        __UI_MakeHardwareImage This.Canvas
        _DEST PrevDest
    END IF

    _PUTIMAGE (This.Left, This.Top), This.Canvas
END SUB

'---------------------------------------------------------------------------------
SUB __UI_DrawRadioButton (This AS __UI_ControlTYPE, ControlState AS _BYTE)
    DIM PrevDest AS LONG
    DIM CaptionIndent AS INTEGER, TempCaption$

    IF This.ControlState <> ControlState OR _
       This.FocusState <> __UI_Focus OR _
       __UI_Captions(This.ID) <> __UI_TempCaptions(This.ID) OR _
       This.Value <> This.PreviousValue THEN
        'Last time we drew this control it had a different state/caption, so let's redraw it
        This.ControlState = ControlState
        This.FocusState = __UI_Focus
        This.PreviousValue = This.Value
        __UI_TempCaptions(This.ID) = __UI_Captions(This.ID)

        IF This.Canvas <> 0 THEN
            _FREEIMAGE This.Canvas
        END IF

        This.Canvas = _NEWIMAGE(This.Width + 2, This.Height + 2, 32)

        PrevDest = _DEST
        _DEST This.Canvas
        _FONT __UI_Fonts(This.Font)
        CLS , _RGBA32(0, 0, 0, 0)

        '------
        IF This.BackStyle = __UI_Opaque THEN
            _PRINTMODE _FILLBACKGROUND
            LINE (0, 0)-STEP(This.Width - 1, This.Height - 1), This.BackColor, BF
        ELSE
            _PRINTMODE _KEEPBACKGROUND
        END IF

        DIM CircleDiameter AS INTEGER
        DIM i AS SINGLE

        CircleDiameter% = 10

        CIRCLE (CircleDiameter% / 3 + 2, CircleDiameter% / 3 + 2), CircleDiameter% / 2, _RGB32(0, 0, 0)

        IF This.Value THEN
            FOR i = CircleDiameter% / 3 TO 1 STEP -.1
                CIRCLE (CircleDiameter% / 3 + 2, CircleDiameter% / 3 + 2), i, _RGB32(0, 0, 0)
            NEXT
        END IF

        IF This.HasBorder THEN
            CaptionIndent = 5
            LINE (0, 0)-(This.Width - 1, This.Height - 1), This.BorderColor, B
        END IF

        CaptionIndent = CaptionIndent + CircleDiameter * 1.5
        TempCaption$ = __UI_ClipText(__UI_Captions(This.ID), This.Width - CaptionIndent * 2)

        IF __UI_Focus = This.ID THEN
            COLOR __UI_Darken(__UI_Controls(__UI_FormID).BackColor, 50), This.BackColor
            _PRINTSTRING (CaptionIndent + 1, ((This.Height \ 2) - _FONTHEIGHT \ 2) + 1), TempCaption$
        END IF

        IF This.Enabled THEN
            COLOR This.ForeColor, This.BackColor
        ELSE
            COLOR __UI_Darken(__UI_Controls(__UI_FormID).BackColor, 80), This.BackColor
        END IF
        _PRINTSTRING (CaptionIndent, ((This.Height \ 2) - _FONTHEIGHT \ 2)), TempCaption$
        '------

        __UI_MakeHardwareImage This.Canvas
        _DEST PrevDest
    END IF

    _PUTIMAGE (This.Left, This.Top), This.Canvas
END SUB

'---------------------------------------------------------------------------------
SUB __UI_DrawCheckBox (This AS __UI_ControlTYPE, ControlState AS _BYTE)
    DIM PrevDest AS LONG
    DIM CaptionIndent AS INTEGER, TempCaption$

    IF This.ControlState <> ControlState OR _
       This.FocusState <> __UI_Focus OR _
       __UI_Captions(This.ID) <> __UI_TempCaptions(This.ID) OR _
       This.Value <> This.PreviousValue THEN
        'Last time we drew this control it had a different state/caption, so let's redraw it
        This.ControlState = ControlState
        This.FocusState = __UI_Focus
        This.PreviousValue = This.Value
        __UI_TempCaptions(This.ID) = __UI_Captions(This.ID)

        IF This.Canvas <> 0 THEN
            _FREEIMAGE This.Canvas
        END IF

        This.Canvas = _NEWIMAGE(This.Width + 2, This.Height + 2, 32)

        PrevDest = _DEST
        _DEST This.Canvas
        _FONT __UI_Fonts(This.Font)
        CLS , _RGBA32(0, 0, 0, 0)

        '------
        IF This.BackStyle = __UI_Opaque THEN
            _PRINTMODE _FILLBACKGROUND
        ELSE
            _PRINTMODE _KEEPBACKGROUND
        END IF

        DIM i AS SINGLE, BoxSize%
        BoxSize% = 10

        LINE (0, 0)-STEP(BoxSize%, BoxSize%), _RGB32(0, 0, 0), B

        IF This.Value THEN
            LINE (0, 0)-STEP(BoxSize%, BoxSize%), _RGB32(0, 0, 0)
            LINE (0, BoxSize%)-STEP(BoxSize%, -BoxSize%), _RGB32(0, 0, 0)
        END IF

        CaptionIndent = 0
        IF This.BackStyle = __UI_Opaque THEN
            LINE (0, 0)-STEP(This.Width - 1, This.Height - 1), This.BackColor, BF
        END IF

        IF This.HasBorder = __UI_True THEN
            CaptionIndent = 5
            LINE (0, 0)-STEP(This.Width - 1, This.Height - 1), This.BorderColor, B
        END IF

        CaptionIndent = CaptionIndent + BoxSize% * 1.5
        TempCaption$ = __UI_ClipText(__UI_Captions(This.ID), This.Width - CaptionIndent * 2)

        IF __UI_Focus = This.ID THEN
            COLOR __UI_Darken(__UI_Controls(__UI_FormID).BackColor, 50), This.BackColor
            _PRINTSTRING (CaptionIndent + 1, ((This.Height \ 2) - _FONTHEIGHT \ 2) + 1), TempCaption$
        END IF

        IF This.Enabled THEN
            COLOR This.ForeColor, This.BackColor
        ELSE
            COLOR __UI_Darken(__UI_Controls(__UI_FormID).BackColor, 80), This.BackColor
        END IF

        _PRINTSTRING (CaptionIndent, ((This.Height \ 2) - _FONTHEIGHT \ 2)), TempCaption$
        '------

        __UI_MakeHardwareImage This.Canvas
        _DEST PrevDest
    END IF

    _PUTIMAGE (This.Left, This.Top), This.Canvas
END SUB

'---------------------------------------------------------------------------------
SUB __UI_DrawProgressBar (This AS __UI_ControlTYPE, ControlState)
    DIM PrevDest AS LONG
    DIM CaptionIndent AS INTEGER, TempCaption$

    IF This.ControlState <> ControlState OR _
       This.FocusState <> __UI_Focus OR _
       __UI_Captions(This.ID) <> __UI_TempCaptions(This.ID) OR _
       This.Value <> This.PreviousValue THEN
        'Last time we drew this control it had a different state/caption, so let's redraw it
        This.ControlState = ControlState
        This.FocusState = __UI_Focus
        This.PreviousValue = This.Value
        __UI_TempCaptions(This.ID) = __UI_Captions(This.ID)

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

        LINE (0, 0)-STEP(This.Width - 1, This.Height - 1), This.BackColor, BF

        IF This.Enabled THEN
            LINE (0, 0)-STEP(((This.Width - 1) / This.Max) * This.Value, This.Height - 1), This.ForeColor, BF
        ELSE
            LINE (0, 0)-STEP(((This.Width - 1) / This.Max) * This.Value, This.Height - 1), _RGBA32(0, 0, 0, 50), BF
        END IF

        IF This.HasBorder THEN
            LINE (0, 0)-STEP(This.Width - 1, This.Height - 1), This.BorderColor, B
        END IF

        IF This.ShowPercentage OR LEN(__UI_Captions(This.ID)) THEN
            DIM ProgressString$, ReplaceCode%
            ProgressString$ = LTRIM$(STR$(FIX((This.Value / This.Max) * 100))) + "%"
            IF LEN(__UI_Captions(This.ID)) THEN
                TempCaption$ = __UI_Captions(This.ID)
                ReplaceCode% = INSTR(TempCaption$, "\#")
                IF ReplaceCode% THEN
                    TempCaption$ = LEFT$(TempCaption$, ReplaceCode% - 1) + ProgressString$ + MID$(TempCaption$, ReplaceCode% + 2)
                END IF
                TempCaption$ = __UI_ClipText(TempCaption$, This.Width)
            ELSE
                TempCaption$ = ProgressString$
            END IF

            _PRINTMODE _KEEPBACKGROUND

            IF This.Enabled THEN
                COLOR This.BorderColor
            ELSE
                COLOR __UI_Darken(__UI_Controls(__UI_FormID).BackColor, 70)
            END IF

            IF _PRINTWIDTH(TempCaption$) < This.Width THEN
            _PRINTSTRING (This.Width / 2 - _PRINTWIDTH(TempCaption$) / 2, _
                          This.Height / 2 - _FONTHEIGHT / 2), _
                          TempCaption$
            END IF
        END IF
        '------

        __UI_MakeHardwareImage This.Canvas
        _DEST PrevDest
    END IF

    _PUTIMAGE (This.Left, This.Top), This.Canvas
END SUB

'---------------------------------------------------------------------------------
SUB __UI_DrawTextBox (This AS __UI_ControlTYPE, ControlState, ss1 AS LONG, ss2 AS LONG)
    DIM PrevDest AS LONG
    DIM CaptionIndent AS INTEGER, TempCaption$
    STATIC SetCursor#, cursorBlink%%

    IF This.ControlState <> ControlState OR _
       This.FocusState <> __UI_Focus OR _
       __UI_Captions(This.ID) <> __UI_TempCaptions(This.ID) OR _
       __UI_Texts(This.ID) <> __UI_TempTexts(This.ID) OR _
       TIMER - SetCursor# > .4 OR _
       __UI_SelectionLength <> This.SelectionLength OR _
       This.Cursor <> This.PrevCursor THEN
        'Last time we drew this control it had a different state/caption, so let's redraw it
        This.ControlState = ControlState
        This.FocusState = __UI_Focus
        __UI_TempCaptions(This.ID) = __UI_Captions(This.ID)
        __UI_TempTexts(This.ID) = __UI_Texts(This.ID)
        This.SelectionLength = __UI_SelectionLength
        This.PrevCursor = This.Cursor

        IF This.Canvas <> 0 THEN
            _FREEIMAGE This.Canvas
        END IF

        This.Canvas = _NEWIMAGE(This.Width + 2, This.Height + 2, 32)

        PrevDest = _DEST
        _DEST This.Canvas
        _FONT __UI_Fonts(This.Font)
        CLS , _RGBA32(0, 0, 0, 0)

        '------
        IF This.BackStyle = __UI_Opaque THEN
            _PRINTMODE _FILLBACKGROUND
        ELSE
            _PRINTMODE _KEEPBACKGROUND
        END IF

        IF (__UI_Focus = This.ID) AND This.Enabled THEN
            __UI_DrawRectangle 2, 2, This.Width, This.Height, This.BorderColor, __UI_Darken(__UI_Controls(__UI_FormID).BackColor, 50), __UI_True
        END IF

        TempCaption$ = __UI_ClipText(__UI_Captions(This.ID), This.Width - CaptionIndent * 2)
        CaptionIndent = 0
        IF This.BackStyle = __UI_Opaque THEN
            __UI_DrawRectangle 0, 0, This.Width, This.Height, This.BackColor, This.BackColor, __UI_True
        END IF

        IF This.HasBorder = __UI_True THEN
            CaptionIndent = 5
            __UI_DrawRectangle 0, 0, This.Width, This.Height, This.BorderColor, 0, __UI_False
        END IF

        IF This.Enabled AND LEN(__UI_Texts(This.ID)) THEN
            COLOR This.ForeColor, This.BackColor
        ELSE
            COLOR __UI_Darken(__UI_Controls(__UI_FormID).BackColor, 80), This.BackColor
        END IF

        IF LEN(__UI_Texts(This.ID)) THEN
            _PRINTSTRING (CaptionIndent, ((This.Height \ 2) - _FONTHEIGHT \ 2)), MID$(__UI_Texts(This.ID), This.InputViewStart, This.FieldArea)
        ELSE
            _PRINTSTRING (CaptionIndent, ((This.Height \ 2) - _FONTHEIGHT \ 2)), TempCaption$
        END IF

        IF This.Selected THEN
            LINE (CaptionIndent + ss1 * _FONTWIDTH, ((This.Height \ 2) - _FONTHEIGHT \ 2))-STEP(ss2 * _FONTWIDTH, _FONTHEIGHT), _RGBA32(0, 0, 0, 50), BF
        END IF

        IF __UI_Focus = This.ID AND This.Enabled THEN
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
        END IF
        '------

        __UI_MakeHardwareImage This.Canvas
        _DEST PrevDest
    END IF

    _PUTIMAGE (This.Left, This.Top), This.Canvas
END SUB

'---------------------------------------------------------------------------------
SUB __UI_DrawListBox (This AS __UI_ControlTYPE, ControlState)
    DIM PrevDest AS LONG
    DIM CaptionIndent AS INTEGER, TempCaption$
    STATIC SetCursor#, cursorBlink%%

    IF This.ControlState <> ControlState OR _
       This.FocusState <> __UI_Focus OR _
       This.PreviousValue <> This.Value OR _
       __UI_Texts(This.ID) <> __UI_TempTexts(This.ID) OR _
       This.PreviousInputViewStart <> This.InputViewStart THEN
        'Last time we drew this control it had a different state/caption, so let's redraw it
        This.ControlState = ControlState
        This.FocusState = __UI_Focus
        This.PreviousValue = This.Value
        This.PreviousInputViewStart = This.InputViewStart
        __UI_TempTexts(This.ID) = __UI_Texts(This.ID)

        IF This.Canvas <> 0 THEN
            _FREEIMAGE This.Canvas
        END IF

        This.Canvas = _NEWIMAGE(This.Width + 2, This.Height + 2, 32)

        PrevDest = _DEST
        _DEST This.Canvas
        _FONT __UI_Fonts(This.Font)
        CLS , _RGBA32(0, 0, 0, 0)

        '------
        _PRINTMODE _KEEPBACKGROUND

        IF This.BackStyle = __UI_Opaque THEN
            IF ((__UI_HoveringID = This.ID OR __UI_Focus = This.ID) AND This.Enabled) THEN
                __UI_DrawRectangle 2, 2, This.Width, This.Height, This.BorderColor, __UI_Darken(__UI_Controls(__UI_FormID).BackColor, 50), __UI_True
            END IF

            __UI_DrawRectangle 0, 0, This.Width, This.Height, This.BackColor, This.BackColor, __UI_True
        END IF

        CaptionIndent = 0
        IF This.HasBorder = __UI_True THEN
            CaptionIndent = 5
            __UI_DrawRectangle 0, 0, This.Width, This.Height, This.BorderColor, 0, __UI_False
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
                    TempCaption$ = __UI_ClipText(TempCaption$, This.Width - CaptionIndent * 2)

                    IF This.Enabled THEN
                        COLOR This.ForeColor, This.BackColor
                    ELSE
                        COLOR __UI_Darken(__UI_Controls(__UI_FormID).BackColor, 80), This.BackColor
                    END IF

                    IF ThisItem% = This.Value THEN
                        IF __UI_Focus = This.ID THEN
                            COLOR This.SelectedForeColor
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
                __UI_DrawVScrollBar This
            ELSE
                This.HasVScrollbar = __UI_False
            END IF
        END IF
        '------

        __UI_MakeHardwareImage This.Canvas
        _DEST PrevDest
    END IF

    _PUTIMAGE (This.Left, This.Top), This.Canvas
END SUB

'---------------------------------------------------------------------------------
SUB __UI_DrawVScrollBar (TempThis AS __UI_ControlTYPE)
    DIM CaptionIndent AS INTEGER
    DIM TrackHeight AS INTEGER, ThumbHeight AS INTEGER, ThumbTop AS INTEGER
    DIM Ratio AS SINGLE, ButtonsHeight AS INTEGER
    DIM This AS __UI_ControlTYPE

    This = TempThis

    IF This.Type = __UI_Type_ListBox THEN
        This.Min = 0
        This.Max = This.Max - This.LastVisibleItem
        This.Value = This.InputViewStart - 1
        This.Left = This.Width - 25
        This.Top = 0
        This.Width = 25
        This.ForeColor = _RGB32(61, 116, 255)
        This.HasBorder = __UI_True
        This.BorderColor = _RGB32(0, 0, 0)
    END IF

    _PRINTMODE _KEEPBACKGROUND

    'Draw the bar
    LINE (This.Left, _
          This.Top)-_
          STEP(This.Width - 1, _
          This.Height -1), This.BackColor, BF

    IF This.HasBorder THEN
        CaptionIndent = 4
        LINE (This.Left, _
              This.Top)-_
              STEP(This.Width - 1, _
              This.Height -1), This.BorderColor, B
    END IF

    'Draw buttons
    IF This.HoveringVScrollbarButton = 1 THEN
        LINE (This.Left, _
              This.Top)-_
              STEP(This.Width - 1, _
              _FONTHEIGHT + CaptionIndent * 2), __UI_Darken(This.BackColor, 80), BF
    END IF
    LINE (This.Left, _
          This.Top)-_
          STEP(This.Width - 1, _
          _FONTHEIGHT + CaptionIndent * 2), This.BorderColor, B

    IF This.HoveringVScrollbarButton = 2 THEN
        LINE (This.Left, _
              This.Top + This.Height - _FONTHEIGHT - CaptionIndent * 2 - 1)-_
              STEP(This.Width - 1, _
              _FONTHEIGHT + CaptionIndent * 2), __UI_Darken(This.BackColor, 80), BF
    END IF
    LINE (This.Left, _
          This.Top + This.Height - _FONTHEIGHT - CaptionIndent * 2 - 1)-_
          STEP(This.Width - 1, _
          _FONTHEIGHT + CaptionIndent * 2), This.BorderColor, B

    ButtonsHeight = (_FONTHEIGHT + CaptionIndent * 2) * 2

    COLOR This.BorderColor
    _PRINTSTRING (This.Left + This.Width \ 2 - _PRINTWIDTH(CHR$(24)) \ 2, This.Top + CaptionIndent), CHR$(24)
    _PRINTSTRING (This.Left + This.Width \ 2 - _PRINTWIDTH(CHR$(24)) \ 2, This.Top + This.Height - _FONTHEIGHT - CaptionIndent), CHR$(25)

    'Draw thumb
    TrackHeight = This.Height - ButtonsHeight - CaptionIndent - 1
    Ratio = (This.Max) / (This.Height + CaptionIndent - 1)
    ThumbHeight = TrackHeight - This.Height * Ratio
    IF ThumbHeight < 20 THEN ThumbHeight = 20
    IF ThumbHeight > TrackHeight THEN ThumbHeight = TrackHeight
    ThumbTop = This.Top + (TrackHeight - ThumbHeight) * (This.Value / This.Max)
    TempThis.ThumbTop = TempThis.Top + ThumbTop + ButtonsHeight / 2 '+ CaptionIndent / 2

    DIM DarkenLevel AS INTEGER
    DarkenLevel = 80
    IF __UI_DraggingThumb THEN DarkenLevel = 50
    IF This.HoveringVScrollbarButton = 3 OR __UI_DraggingThumb THEN
        LINE (This.Left + CaptionIndent / 2, _
              ThumbTop + ButtonsHeight / 2 + CaptionIndent / 2)-_
              STEP(This.Width - CaptionIndent - 1, _
              ThumbHeight), __UI_Darken(This.ForeColor, DarkenLevel), BF
    ELSE
        LINE (This.Left + CaptionIndent / 2, _
              ThumbTop + ButtonsHeight / 2 + CaptionIndent / 2)-_
              STEP(This.Width - CaptionIndent - 1, _
              ThumbHeight), This.ForeColor, BF
    END IF

    'Pass scrollbar parameters back to caller ID
    TempThis.VScrollbarButton2Top = TempThis.Top + This.Height - _FONTHEIGHT - CaptionIndent * 2 - 1
    TempThis.VScrollbarButtonHeight = _FONTHEIGHT + CaptionIndent * 2
    TempThis.VScrollbarWidth = 25
    TempThis.ThumbHeight = ThumbHeight
    TempThis.VScrollbarRatio = Ratio
END SUB

'---------------------------------------------------------------------------------
SUB __UI_DrawDropdownList (This AS __UI_ControlTYPE, ControlState)
    DIM PrevDest AS LONG
    DIM CaptionIndent AS INTEGER, TempCaption$
    STATIC SetCursor#, cursorBlink%%

    IF This.ControlState <> ControlState OR _
       This.FocusState <> __UI_Focus OR _
       This.PreviousValue <> This.Value OR _
       __UI_Texts(This.ID) <> __UI_TempTexts(This.ID) OR _
       This.PreviousInputViewStart <> This.InputViewStart THEN
        'Last time we drew this control it had a different state/caption, so let's redraw it
        This.ControlState = ControlState
        This.FocusState = __UI_Focus
        This.PreviousValue = This.Value
        This.PreviousInputViewStart = This.InputViewStart
        __UI_TempTexts(This.ID) = __UI_Texts(This.ID)

        IF This.Canvas <> 0 THEN
            _FREEIMAGE This.Canvas
        END IF

        This.Canvas = _NEWIMAGE(This.Width + 2, This.Height + 2, 32)

        PrevDest = _DEST
        _DEST This.Canvas
        _FONT __UI_Fonts(This.Font)
        CLS , _RGBA32(0, 0, 0, 0)

        '------
        _PRINTMODE _KEEPBACKGROUND

        IF This.BackStyle = __UI_Opaque THEN
            IF ((__UI_HoveringID = This.ID OR __UI_Focus = This.ID) AND This.Enabled) THEN
                __UI_DrawRectangle 2, 2, This.Width, This.Height, This.BorderColor, __UI_Darken(__UI_Controls(__UI_FormID).BackColor, 50), __UI_True
            END IF

            __UI_DrawRectangle 0, 0, This.Width, This.Height, This.BackColor, This.BackColor, __UI_True
        END IF

        CaptionIndent = 0
        IF This.HasBorder = __UI_True THEN
            CaptionIndent = 5
            __UI_DrawRectangle 0, 0, This.Width, This.Height, This.BorderColor, 0, __UI_False
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
                    ThisItemTop% = CaptionIndent

                    IF ThisItem% = This.Value AND __UI_Focus = This.ID THEN __UI_SelectedText = TempCaption$
                    TempCaption$ = __UI_ClipText(TempCaption$, This.Width - CaptionIndent * 2)

                    IF This.Enabled THEN
                        COLOR This.ForeColor, This.BackColor
                    ELSE
                        COLOR __UI_Darken(__UI_Controls(__UI_FormID).BackColor, 80), This.BackColor
                    END IF

                    IF __UI_Focus = This.ID THEN
                        COLOR This.SelectedForeColor
                        LINE (CaptionIndent, ThisItemTop%)-STEP(This.Width - CaptionIndent * 2, _FONTHEIGHT - 1), This.SelectedBackColor, BF
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

            'Draw "dropdown" button
            IF (This.ID = __UI_HoveringID OR This.ID = __UI_ParentDropdownList) AND This.Enabled THEN
                LINE (This.Width - 26, _
                      0)-_
                      STEP(25, _
                      This.Height - 1), __UI_Darken(This.BackColor, 80), BF
            ELSE
                LINE (This.Width - 26, _
                      0)-_
                      STEP(25, _
                      This.Height - 1), This.BackColor, BF
            END IF

            LINE (This.Width - 26, _
                  0)-_
                  STEP(25, _
                  This.Height - 1), This.BorderColor, B

            IF This.Enabled THEN
                COLOR This.ForeColor, This.BackColor
            ELSE
                COLOR __UI_Darken(__UI_Controls(__UI_FormID).BackColor, 80), This.BackColor
            END IF
            _PRINTSTRING (This.Width - (25 / 2) - _PRINTWIDTH(CHR$(24)) \ 2, This.Height - _FONTHEIGHT - CaptionIndent), CHR$(25)
        END IF
        '------

        __UI_MakeHardwareImage This.Canvas
        _DEST PrevDest
    END IF

    _PUTIMAGE (This.Left, This.Top), This.Canvas
END SUB

