OPTION _EXPLICIT

$RESIZE:ON
_RESIZE OFF

TYPE ObjectTYPE
    ID AS LONG
    ParentID AS LONG
    Type AS INTEGER
    Name AS STRING * 256
    Top AS INTEGER
    Left AS INTEGER
    Width AS INTEGER
    Height AS INTEGER
    Font AS INTEGER
    BackColor AS _UNSIGNED LONG
    ForeColor AS _UNSIGNED LONG
    BackStyle AS _BYTE
    HasBorder AS _BYTE
    Align AS _BYTE
    BorderColor AS _UNSIGNED LONG
    Value AS _FLOAT
    Min AS _FLOAT
    Max AS _FLOAT
    ShowPercentage AS _BYTE
    InputViewStart AS LONG
    Cursor AS LONG
    PrevCursor AS LONG
    FieldArea AS LONG
    Selected AS _BYTE
    SelectionStart AS LONG
    Resizable AS _BYTE
    CanDrag AS _BYTE
    CanHaveFocus AS _BYTE
    Enabled AS _BYTE
END TYPE

REDIM SHARED __UI_Captions(1 TO 100) AS STRING
REDIM SHARED __UI_Texts(1 TO 100) AS STRING
REDIM SHARED __UI_Controls(0 TO 100) AS ObjectTYPE

DIM SHARED __UI_Fonts(2) AS LONG
__UI_Fonts(0) = 16
__UI_Fonts(1) = 8
__UI_Fonts(2) = __UI_LoadFont("cyberbit.ttf", 14, "")

DIM SHARED __UI_MouseX AS INTEGER, __UI_MouseY AS INTEGER
DIM SHARED __UI_PrevMouseX AS INTEGER, __UI_PrevMouseY AS INTEGER
DIM SHARED __UI_MouseButton1 AS _BYTE, __UI_MouseButton2 AS _BYTE
DIM SHARED __UI_PrevMouseButton1 AS _BYTE, __UI_PrevMouseButton2 AS _BYTE
DIM SHARED __UI_PreviewTop AS INTEGER, __UI_PreviewLeft AS INTEGER
DIM SHARED __UI_MouseIsDown AS _BYTE, __UI_MouseDownOnID AS LONG
DIM SHARED __UI_KeyIsDown AS _BYTE, __UI_KeyDownOnID AS LONG
DIM SHARED __UI_ShiftIsDown AS _BYTE, __UI_CtrlIsDown AS _BYTE
DIM SHARED __UI_AltIsDown AS _BYTE
DIM SHARED __UI_LastMouseClick AS DOUBLE
DIM SHARED __UI_DragX AS INTEGER, __UI_DragY AS INTEGER
DIM SHARED __UI_DefaultButtonID AS LONG
DIM SHARED __UI_KeyHit AS LONG
DIM SHARED __UI_Focus AS LONG
DIM SHARED __UI_HoveringID AS LONG
DIM SHARED __UI_IsDragging AS _BYTE, __UI_DraggingID AS LONG
DIM SHARED __UI_IsSelectingText AS _BYTE, __UI_IsSelectingTextOnID AS LONG
DIM SHARED __UI_SelectedText AS STRING
DIM SHARED __UI_HasInput AS _BYTE
DIM SHARED __UI_UnloadSignal AS _BYTE
DIM SHARED __UI_ExitTriggered AS _BYTE
DIM SHARED __UI_Loaded AS _BYTE
DIM SHARED __UI_FirstDisplay AS _BYTE
DIM SHARED __UI_RefreshTimer AS INTEGER

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
CONST __UI_Type_ComboBox = 10
CONST __UI_Type_MultiLineTextBox = 11
CONST __UI_Type_Menu = 12
CONST __UI_Type_HScrollBar = 13
CONST __UI_Type_VScrollBar = 14

'Back styles:
CONST __UI_Opaque = 0
CONST __UI_Transparent = -1

'Text alignment
CONST __UI_Left = 0
CONST __UI_Center = 1
CONST __UI_Right = 2

'Global constants
CONST __UI_True = -1
CONST __UI_False = 0

DIM NewID AS LONG, ParentID AS LONG

NewID = __UI_NewObject(__UI_Type_Form, "Form1", 0)
__UI_Controls(NewID).Width = 640
__UI_Controls(NewID).Height = 400
__UI_Controls(NewID).ForeColor = _RGB32(0, 0, 0)
__UI_Controls(NewID).BackColor = _RGB32(235, 233, 237)
__UI_Controls(NewID).Enabled = __UI_True
__UI_SetCaption "Form1", "Hello, world!"

NewID = __UI_NewObject(__UI_Type_Button, "Button1", 0)
__UI_Controls(NewID).Top = 100
__UI_Controls(NewID).Left = 100
__UI_Controls(NewID).Width = 200
__UI_Controls(NewID).Height = 20
__UI_Controls(NewID).ForeColor = _RGB32(255, 255, 255)
__UI_Controls(NewID).BackColor = _RGB32(105, 177, 94)
__UI_Controls(NewID).CanHaveFocus = __UI_True
__UI_Controls(NewID).Enabled = __UI_True
__UI_SetCaption "Button1", "Click me"

NewID = __UI_NewObject(__UI_Type_Button, "Button2", 0)
__UI_Controls(NewID).Top = 200
__UI_Controls(NewID).Left = 100
__UI_Controls(NewID).Width = 200
__UI_Controls(NewID).Height = 20
__UI_Controls(NewID).ForeColor = _RGB32(255, 255, 255)
__UI_Controls(NewID).BackColor = _RGB32(51, 152, 219)
__UI_Controls(NewID).CanHaveFocus = __UI_True
__UI_Controls(NewID).Enabled = __UI_True
__UI_SetCaption "Button2", "Make this form resizable"

NewID = __UI_NewObject(__UI_Type_TextBox, "Textbox1", 0)
__UI_Controls(NewID).Top = 250
__UI_Controls(NewID).Left = 30
__UI_Controls(NewID).Width = 300
__UI_Controls(NewID).Height = 20
__UI_Controls(NewID).Font = 0
__UI_Controls(NewID).ForeColor = _RGB32(0, 0, 0)
__UI_Controls(NewID).BackColor = _RGB32(255, 255, 255)
__UI_Controls(NewID).HasBorder = __UI_True
__UI_Controls(NewID).BorderColor = _RGB32(0, 0, 0)
__UI_Controls(NewID).CanHaveFocus = __UI_True
__UI_Controls(NewID).Enabled = __UI_True
__UI_SetCaption "Textbox1", "Edit me"

NewID = __UI_NewObject(__UI_Type_Button, "DragButton", 0)
__UI_Controls(NewID).Top = 300
__UI_Controls(NewID).Left = 100
__UI_Controls(NewID).Width = 200
__UI_Controls(NewID).Height = 20
__UI_Controls(NewID).ForeColor = _RGB32(255, 255, 255)
__UI_Controls(NewID).BackColor = _RGB32(188, 152, 116)
__UI_Controls(NewID).CanHaveFocus = __UI_True
__UI_Controls(NewID).Enabled = __UI_True
__UI_SetCaption "DragButton", "Make frame draggable"

NewID = __UI_NewObject(__UI_Type_ListBox, "ListBox1", 0)
__UI_Controls(NewID).Top = 160
__UI_Controls(NewID).Left = 350
__UI_Controls(NewID).Width = 200
__UI_Controls(NewID).Height = 200
__UI_Controls(NewID).ForeColor = _RGB32(0, 0, 0)
__UI_Controls(NewID).BackColor = _RGB32(255, 255, 255)
__UI_Controls(NewID).HasBorder = __UI_True
__UI_Controls(NewID).BorderColor = _RGB32(0, 0, 0)
__UI_Controls(NewID).CanHaveFocus = __UI_True
__UI_Controls(NewID).Enabled = __UI_True
__UI_AddListBoxItem "ListBox1", "Australia"
__UI_AddListBoxItem "ListBox1", "Brazil"
__UI_AddListBoxItem "ListBox1", "USA"
__UI_Controls(NewID).Value = 1

NewID = __UI_NewObject(__UI_Type_Label, "Label1", 0)
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

NewID = __UI_NewObject(__UI_Type_Label, "FocusLabel", 0)
__UI_Controls(NewID).Top = 55
__UI_Controls(NewID).Left = 10
__UI_Controls(NewID).Width = 400
__UI_Controls(NewID).Height = 20
__UI_Controls(NewID).ForeColor = _RGB32(0, 0, 0)
__UI_Controls(NewID).Enabled = __UI_True
__UI_SetCaption "FocusLabel", "No object has focus now"
__UI_Controls(NewID).Font = 1

NewID = __UI_NewObject(__UI_Type_Label, "HoverLabel", 0)
__UI_Controls(NewID).Top = 75
__UI_Controls(NewID).Left = 10
__UI_Controls(NewID).Width = 400
__UI_Controls(NewID).Height = 20
__UI_Controls(NewID).ForeColor = _RGB32(0, 0, 0)
__UI_Controls(NewID).Enabled = __UI_True
__UI_Controls(NewID).Font = 1

NewID = __UI_NewObject(__UI_Type_Label, "Label2", 0)
__UI_Controls(NewID).Top = 350
__UI_Controls(NewID).Left = 30
__UI_Controls(NewID).Width = 300
__UI_Controls(NewID).Height = 20
__UI_Controls(NewID).ForeColor = _RGB32(0, 0, 0)
__UI_Controls(NewID).BackStyle = __UI_Transparent
__UI_Controls(NewID).HasBorder = __UI_False
__UI_Controls(NewID).BorderColor = _RGB32(0, 0, 0)
__UI_Controls(NewID).Enabled = __UI_True

NewID = __UI_NewObject(__UI_Type_Frame, "Frame1", 0)
__UI_Controls(NewID).Top = 30
__UI_Controls(NewID).Left = 430
__UI_Controls(NewID).Width = 200
__UI_Controls(NewID).Height = 110
__UI_Controls(NewID).ForeColor = _RGB32(0, 0, 0)
__UI_Controls(NewID).BackColor = __UI_Controls(__UI_GetID("Form1")).BackColor
__UI_Controls(NewID).HasBorder = __UI_True
__UI_Controls(NewID).BorderColor = _RGB32(0, 0, 0)
__UI_Controls(NewID).Enabled = __UI_True
__UI_SetCaption "Frame1", "A cute container"

NewID = __UI_NewObject(__UI_Type_RadioButton, "Option1", __UI_GetID("Frame1"))
__UI_Controls(NewID).Top = 15
__UI_Controls(NewID).Left = 15
__UI_Controls(NewID).Width = 110
__UI_Controls(NewID).Height = 10
__UI_Controls(NewID).ForeColor = _RGB32(0, 0, 0)
__UI_Controls(NewID).Enabled = __UI_True
__UI_Controls(NewID).Value = __UI_True
__UI_Controls(NewID).CanHaveFocus = __UI_True
__UI_SetCaption "Option1", "Option 1"
__UI_Controls(NewID).Font = 2

NewID = __UI_NewObject(__UI_Type_RadioButton, "Option2", __UI_GetID("Frame1"))
__UI_Controls(NewID).Top = 40
__UI_Controls(NewID).Left = 15
__UI_Controls(NewID).Width = 110
__UI_Controls(NewID).Height = 10
__UI_Controls(NewID).ForeColor = _RGB32(0, 0, 0)
__UI_Controls(NewID).Enabled = __UI_True
__UI_Controls(NewID).CanHaveFocus = __UI_True
__UI_SetCaption "Option2", "Option 2"
__UI_Controls(NewID).Font = 2

NewID = __UI_NewObject(__UI_Type_CheckBox, "Check1", __UI_GetID("Frame1"))
__UI_Controls(NewID).Top = 65
__UI_Controls(NewID).Left = 15
__UI_Controls(NewID).Width = 110
__UI_Controls(NewID).Height = 10
__UI_Controls(NewID).ForeColor = _RGB32(0, 0, 0)
__UI_Controls(NewID).Enabled = __UI_True
__UI_Controls(NewID).CanHaveFocus = __UI_True
__UI_SetCaption "Check1", "Checkbox 1"
__UI_Controls(NewID).Font = 2

NewID = __UI_NewObject(__UI_Type_CheckBox, "Check2", __UI_GetID("Frame1"))
__UI_Controls(NewID).Top = 90
__UI_Controls(NewID).Left = 15
__UI_Controls(NewID).Width = 110
__UI_Controls(NewID).Height = 10
__UI_Controls(NewID).ForeColor = _RGB32(0, 0, 0)
__UI_Controls(NewID).Enabled = __UI_True
__UI_Controls(NewID).Value = __UI_True
__UI_Controls(NewID).CanHaveFocus = __UI_True
__UI_SetCaption "Check2", "Checkbox 2"
__UI_Controls(NewID).Font = 2

NewID = __UI_NewObject(__UI_Type_ProgressBar, "ProgressBar1", 0)
__UI_Controls(NewID).Top = 375
__UI_Controls(NewID).Left = 30
__UI_Controls(NewID).Width = 300
__UI_Controls(NewID).Height = 20
__UI_Controls(NewID).ForeColor = _RGB32(0, 128, 0)
__UI_Controls(NewID).BackColor = __UI_Controls(__UI_GetID("Form1")).BackColor
__UI_Controls(NewID).HasBorder = __UI_True
__UI_Controls(NewID).BorderColor = _RGB32(0, 0, 0)
__UI_Controls(NewID).Font = 1
__UI_Controls(NewID).Min = 0
__UI_Controls(NewID).Max = 500
__UI_Controls(NewID).ShowPercentage = __UI_True
__UI_Controls(NewID).Height = 20
__UI_Controls(NewID).Enabled = __UI_True
'__UI_SetCaption "ProgressBar1", "Performing task"

NewID = __UI_NewObject(__UI_Type_Button, "OkButton", 0)
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

    __UI_ProcessInput
    IF __UI_HasInput OR __UI_FirstDisplay = __UI_False THEN
        __UI_FirstDisplay = __UI_True
        __UI_EventDispatcher
    END IF
    _LIMIT 30
LOOP

'---------------------------------------------------------------------------------
SUB __UI_Load
    DIM i AS LONG
    SCREEN _NEWIMAGE(__UI_Controls(__UI_GetID("Form1")).Width, __UI_Controls(__UI_GetID("Form1")).Height, 32)
    DO UNTIL _SCREENEXISTS: _LIMIT 10: LOOP

    FOR i = 1 TO UBOUND(__UI_Controls)
        IF __UI_Controls(i).ParentID THEN
            IF __UI_Controls(i).Width + __UI_Controls(i).Left > __UI_Controls(__UI_Controls(i).ParentID).Width THEN
                __UI_Controls(i).Width = __UI_Controls(__UI_Controls(i).ParentID).Width - __UI_Controls(i).Left
            END IF
        END IF

        IF __UI_Controls(i).Type = __UI_Type_TextBox THEN
            IF _FONTWIDTH(__UI_Fonts(__UI_Controls(i).Font)) = 0 THEN __UI_Controls(i).Font = 0
            __UI_Controls(i).FieldArea = __UI_Controls(i).Width \ _FONTWIDTH(__UI_Fonts(__UI_Controls(i).Font))
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
            __UI_Controls(__UI_GetID("Form1")).Resizable = NOT __UI_Controls(__UI_GetID("Form1")).Resizable
            IF __UI_Controls(__UI_GetID("Form1")).Resizable THEN
                __UI_Captions(__UI_GetID("Button2")) = "Form is resizable"
            ELSE
                __UI_Captions(__UI_GetID("Button2")) = "Form is not resizable"
            END IF
        CASE "DRAGBUTTON"
            __UI_Controls(__UI_GetID("frame1")).CanDrag = NOT __UI_Controls(__UI_GetID("frame1")).CanDrag
            IF __UI_Controls(__UI_GetID("frame1")).CanDrag THEN
                __UI_Captions(__UI_GetID("DragButton")) = "Frame is draggable"
            ELSE
                __UI_Captions(__UI_GetID("DragButton")) = "Frame is not draggable"
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
    STATIC Iterations AS LONG
    Iterations = Iterations + 1

    __UI_Controls(__UI_GetID("ProgressBar1")).Value = Iterations
    IF __UI_Controls(__UI_GetID("ProgressBar1")).Value > __UI_Controls(__UI_GetID("ProgressBar1")).Max THEN
        __UI_Controls(__UI_GetID("ProgressBar1")).Value = __UI_Controls(__UI_GetID("ProgressBar1")).Max
    END IF

    IF __UI_Focus THEN
        __UI_SetCaption "FocusLabel", "Focus is on " + RTRIM$(__UI_Controls(__UI_Focus).Name)
        IF LEN(__UI_SelectedText) THEN
            __UI_SetCaption "FocusLabel", "Selected text: " + __UI_SelectedText
        ELSEIF __UI_Focus = __UI_GetID("ListBox1") THEN
            __UI_SetCaption "FocusLabel", "Selected item: " + STR$(__UI_Controls(__UI_Focus).Value)
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
        ELSE
            __UI_SetCaption "Label2", "Screen repainted" + STR$(Iterations) + " times."
        END IF
    ELSE
        __UI_SetCaption "Label2", "Dragging..." + STR$(__UI_PreviewLeft) + "," + STR$(__UI_PreviewTop)
    END IF
END SUB

SUB __UI_BeforeUnload
    'STATIC it
    'it = it + 1
    'IF it < 3 THEN __UI_UnloadSignal = __UI_False
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

'---------------------------------------------------------------------------------
'Internal procedures: ------------------------------------------------------------
'---------------------------------------------------------------------------------
SUB __UI_ProcessInput
    DIM OldScreen&, OldFont&
    STATIC __UI_CurrentTitle AS STRING
    STATIC __UI_CurrentResizeStatus AS _BYTE

    __UI_HasInput = __UI_False

    __UI_ExitTriggered = _EXIT
    IF __UI_ExitTriggered AND 1 THEN __UI_ExitTriggered = __UI_True: __UI_HasInput = __UI_True

    'Mouse input:
    WHILE _MOUSEINPUT
    WEND

    __UI_MouseX = _MOUSEX
    __UI_MouseY = _MOUSEY
    __UI_MouseButton1 = _MOUSEBUTTON(1)
    __UI_MouseButton2 = _MOUSEBUTTON(2)

    IF __UI_PrevMouseX <> __UI_MouseX THEN _
        __UI_HasInput = __UI_True: __UI_PrevMouseX = __UI_MouseX
    IF __UI_PrevMouseY <> __UI_MouseY THEN _
        __UI_HasInput = __UI_True: __UI_PrevMouseY = __UI_MouseY
    IF __UI_PrevMouseButton1 <> __UI_MouseButton1 THEN _
        __UI_HasInput = __UI_True: __UI_PrevMouseButton1 = __UI_MouseButton1
    IF __UI_PrevMouseButton2 <> __UI_MouseButton2 THEN _
        __UI_HasInput = __UI_True: __UI_PrevMouseButton2 = __UI_MouseButton2

    'Keyboard input:
    __UI_KeyHit = _KEYHIT
    IF __UI_KeyHit THEN __UI_HasInput = __UI_True

    'Resize event:
    '1- Triggered programatically:
    IF __UI_Controls(__UI_GetID("Form1")).Resizable <> __UI_CurrentResizeStatus THEN
        __UI_CurrentResizeStatus = __UI_Controls(__UI_GetID("Form1")).Resizable
        IF __UI_CurrentResizeStatus THEN
            _RESIZE ON
        ELSE
            _RESIZE OFF
        END IF
    END IF

    '2- Triggered by manually resizing:
    IF _RESIZE AND __UI_Controls(__UI_GetID("Form1")).Resizable THEN
        __UI_Controls(__UI_GetID("Form1")).Width = _RESIZEWIDTH
        __UI_Controls(__UI_GetID("Form1")).Height = _RESIZEHEIGHT
        OldScreen& = _DEST
        OldFont& = _FONT
        SCREEN _NEWIMAGE(__UI_Controls(__UI_GetID("Form1")).Width, __UI_Controls(__UI_GetID("Form1")).Height, 32)
        IF LEN(__UI_CurrentTitle) THEN _TITLE __UI_CurrentTitle
        _FONT OldFont&
        _FREEIMAGE OldScreen&
        __UI_HasInput = __UI_True
    END IF

    'Update main window title if needed
    IF __UI_CurrentTitle <> __UI_Captions(__UI_GetID("Form1")) THEN
        __UI_CurrentTitle = __UI_Captions(__UI_GetID("Form1"))
        _TITLE __UI_CurrentTitle
        __UI_HasInput = __UI_True
    END IF
END SUB

'---------------------------------------------------------------------------------
SUB __UI_UpdateDisplay
    DIM i AS LONG, TempCaption$, TempColor~&
    DIM CaptionIndent AS INTEGER
    DIM ContainerOffsetLeft AS INTEGER, ContainerOffsetTop AS INTEGER

    __UI_BeforeUpdateDisplay

    'Main window:
    COLOR __UI_Controls(__UI_GetID("Form1")).ForeColor, __UI_Controls(__UI_GetID("Form1")).BackColor
    CLS

    IF __UI_IsDragging AND NOT (_KEYDOWN(100305) OR _KEYDOWN(100306)) THEN
        'Draw the alignment grid
        DIM GridX AS INTEGER, GridY AS INTEGER

        FOR GridX = 0 TO __UI_Controls(__UI_GetID("Form1")).Width STEP 10
            FOR GridY = 0 TO __UI_Controls(__UI_GetID("Form1")).Height STEP 10
                PSET (GridX, GridY), __UI_Controls(__UI_GetID("Form1")).ForeColor
            NEXT
        NEXT

        LINE (__UI_PreviewLeft, __UI_PreviewTop)-STEP(__UI_Controls(__UI_DraggingID).Width - 1, __UI_Controls(__UI_DraggingID).Height - 1), __UI_Darken(__UI_Controls(__UI_GetID("Form1")).BackColor, 80), B
    END IF

    'Hover detection
    FOR i = 1 TO UBOUND(__UI_Controls)
        IF __UI_Controls(i).ID THEN
            IF __UI_Controls(i).ParentID THEN
                ContainerOffsetTop = __UI_Controls(__UI_Controls(i).ParentID).Top
                ContainerOffsetLeft = __UI_Controls(__UI_Controls(i).ParentID).Left
            ELSE
                ContainerOffsetTop = 0
                ContainerOffsetLeft = 0
            END IF

            IF __UI_MouseX >= ContainerOffsetLeft + __UI_Controls(i).Left AND _
               __UI_MouseX <= ContainerOffsetLeft + __UI_Controls(i).Left + __UI_Controls(i).Width - 1 AND _
               __UI_MouseY >= ContainerOffsetTop + __UI_Controls(i).Top AND _
               __UI_MouseY <= ContainerOffsetTop + __UI_Controls(i).Top +  __UI_Controls(i).Height - 1 THEN
                __UI_HoveringID = i
            END IF
        END IF
    NEXT

    FOR i = 1 TO UBOUND(__UI_Controls)
        IF __UI_Controls(i).ID THEN
            _FONT __UI_Fonts(__UI_Controls(i).Font)

            TempCaption$ = __UI_Captions(i)
            DO WHILE _PRINTWIDTH(TempCaption$) > __UI_Controls(i).Width
                TempCaption$ = MID$(TempCaption$, 1, LEN(TempCaption$) - 1)
            LOOP

            IF __UI_Controls(i).ParentID THEN
                ContainerOffsetTop = __UI_Controls(__UI_Controls(i).ParentID).Top
                ContainerOffsetLeft = __UI_Controls(__UI_Controls(i).ParentID).Left
            ELSE
                ContainerOffsetTop = 0
                ContainerOffsetLeft = 0
            END IF

            SELECT CASE __UI_Controls(i).Type
                CASE __UI_Type_Button
                    IF ((__UI_MouseIsDown AND i = __UI_MouseDownOnID) OR _
                       (__UI_KeyIsDown AND i = __UI_KeyDownOnID AND __UI_KeyDownOnID = __UI_Focus)) AND _
                       __UI_Controls(i).Enabled THEN
                        TempColor~& = __UI_Darken(__UI_Controls(i).BackColor, 70)
                    ELSEIF i = __UI_HoveringID AND __UI_Controls(i).Enabled THEN
                        TempColor~& = __UI_Darken(__UI_Controls(i).BackColor, 90)
                    ELSEIF __UI_Controls(i).Enabled = __UI_False THEN
                        TempColor~& = _RGB32(208, 213, 216)
                    ELSE
                        TempColor~& = __UI_Controls(i).BackColor
                    END IF

                    IF ((__UI_HoveringID = i OR __UI_Focus = i) AND _
                        __UI_Controls(i).Enabled AND __UI_MouseDownOnID <> i AND _
                        __UI_KeyDownOnID <> i) OR _
                        (__UI_DefaultButtonID = i AND __UI_Controls(__UI_Focus).Type <> __UI_Type_Button) THEN
                        __UI_DrawRectangle __UI_Controls(i).Left + 2, __UI_Controls(i).Top + 2, __UI_Controls(i).Width, __UI_Controls(i).Height, __UI_Controls(i).BorderColor, __UI_Darken(__UI_Controls(__UI_GetID("Form1")).BackColor, 50), __UI_True
                    END IF

                    __UI_DrawRectangle ContainerOffsetLeft + __UI_Controls(i).Left, ContainerOffsetTop + __UI_Controls(i).Top, __UI_Controls(i).Width, __UI_Controls(i).Height, __UI_Controls(i).BorderColor, TempColor~&, __UI_True

                    IF __UI_Controls(i).Enabled THEN
                        COLOR __UI_Controls(i).ForeColor, TempColor~&
                    ELSE
                        COLOR __UI_Darken(__UI_Controls(__UI_GetID("Form1")).BackColor, 80), TempColor~&
                    END IF

                    _PRINTMODE _FILLBACKGROUND
                    _PRINTSTRING (ContainerOffsetLeft + __UI_Controls(i).Left + (__UI_Controls(i).Width \ 2 - _PRINTWIDTH(TempCaption$) \ 2), ContainerOffsetTop + __UI_Controls(i).Top + ((__UI_Controls(i).Height \ 2) - _FONTHEIGHT \ 2)), TempCaption$
                CASE __UI_Type_Label
                    IF __UI_Controls(i).BackStyle = __UI_Opaque THEN
                        _PRINTMODE _FILLBACKGROUND
                    ELSE
                        _PRINTMODE _KEEPBACKGROUND
                    END IF

                    CaptionIndent = 0
                    IF __UI_Controls(i).BackStyle = __UI_Opaque THEN
                        __UI_DrawRectangle ContainerOffsetLeft + __UI_Controls(i).Left, ContainerOffsetTop + __UI_Controls(i).Top, __UI_Controls(i).Width, __UI_Controls(i).Height, __UI_Controls(i).BackColor, __UI_Controls(i).BackColor, __UI_True
                    END IF

                    IF __UI_Controls(i).HasBorder = __UI_True THEN
                        CaptionIndent = 5
                        __UI_DrawRectangle ContainerOffsetLeft + __UI_Controls(i).Left, ContainerOffsetTop + __UI_Controls(i).Top, __UI_Controls(i).Width, __UI_Controls(i).Height, __UI_Controls(i).BorderColor, TempColor~&, __UI_False
                    END IF

                    IF __UI_Controls(i).Enabled THEN
                        COLOR __UI_Controls(i).ForeColor, __UI_Controls(i).BackColor
                    ELSE
                        COLOR __UI_Darken(__UI_Controls(__UI_GetID("Form1")).BackColor, 80), __UI_Controls(i).BackColor
                    END IF

                    SELECT CASE __UI_Controls(i).Align
                        CASE __UI_Left
                            _PRINTSTRING (ContainerOffsetLeft + __UI_Controls(i).Left + CaptionIndent, ContainerOffsetTop + __UI_Controls(i).Top + ((__UI_Controls(i).Height \ 2) - _FONTHEIGHT \ 2)), TempCaption$
                        CASE __UI_Center
                            _PRINTSTRING (ContainerOffsetLeft + __UI_Controls(i).Left + (__UI_Controls(i).Width \ 2 - _PRINTWIDTH(TempCaption$) \ 2), ContainerOffsetTop + __UI_Controls(i).Top + ((__UI_Controls(i).Height \ 2) - _FONTHEIGHT \ 2)), TempCaption$
                        CASE __UI_Right
                            _PRINTSTRING (ContainerOffsetLeft + __UI_Controls(i).Left + (__UI_Controls(i).Width - _PRINTWIDTH(TempCaption$)) - CaptionIndent, ContainerOffsetTop + __UI_Controls(i).Top + ((__UI_Controls(i).Height \ 2) - _FONTHEIGHT \ 2)), TempCaption$
                    END SELECT
                CASE __UI_Type_Frame
                    IF __UI_Controls(i).BackStyle = __UI_Opaque THEN
                        _PRINTMODE _FILLBACKGROUND
                    ELSE
                        _PRINTMODE _KEEPBACKGROUND
                    END IF

                    IF __UI_Controls(i).BackStyle = __UI_Opaque THEN
                        __UI_DrawRectangle __UI_Controls(i).Left, __UI_Controls(i).Top, __UI_Controls(i).Width, __UI_Controls(i).Height, __UI_Controls(i).BackColor, __UI_Controls(i).BackColor, __UI_True
                    END IF

                    CaptionIndent = 0
                    IF __UI_Controls(i).HasBorder = __UI_True THEN
                        CaptionIndent = 5
                        __UI_DrawRectangle __UI_Controls(i).Left, __UI_Controls(i).Top, __UI_Controls(i).Width, __UI_Controls(i).Height, __UI_Controls(i).BorderColor, TempColor~&, __UI_False
                    END IF

                    IF __UI_Controls(i).Enabled THEN
                        COLOR __UI_Controls(i).ForeColor, __UI_Controls(i).BackColor
                    ELSE
                        COLOR __UI_Darken(__UI_Controls(__UI_GetID("Form1")).BackColor, 80), __UI_Controls(i).BackColor
                    END IF

                    SELECT CASE __UI_Controls(i).Align
                        CASE __UI_Left
                            _PRINTSTRING (__UI_Controls(i).Left + CaptionIndent, __UI_Controls(i).Top - _FONTHEIGHT \ 2), TempCaption$
                        CASE __UI_Center
                            _PRINTSTRING (__UI_Controls(i).Left + (__UI_Controls(i).Width \ 2 - _PRINTWIDTH(TempCaption$) \ 2), __UI_Controls(i).Top - _FONTHEIGHT \ 2), TempCaption$
                        CASE __UI_Right
                            _PRINTSTRING (__UI_Controls(i).Left + (__UI_Controls(i).Width - _PRINTWIDTH(TempCaption$)) - CaptionIndent, __UI_Controls(i).Top - _FONTHEIGHT \ 2), TempCaption$
                    END SELECT
                CASE __UI_Type_RadioButton
                    IF __UI_Controls(i).BackStyle = __UI_Opaque THEN
                        _PRINTMODE _FILLBACKGROUND
                    ELSE
                        _PRINTMODE _KEEPBACKGROUND
                    END IF

                    DIM CircleDiameter AS INTEGER
                    __UI_DrawRadioButton __UI_Controls(i).Value, _
                                         ContainerOffsetLeft + __UI_Controls(i).Left, _
                                         ContainerOffsetTop + __UI_Controls(i).Top + __UI_Controls(i).Height \ 2, _
                                         CircleDiameter

                    CaptionIndent = 0
                    IF __UI_Controls(i).BackStyle = __UI_Opaque THEN
                        __UI_DrawRectangle ContainerOffsetLeft + __UI_Controls(i).Left, ContainerOffsetTop + __UI_Controls(i).Top, __UI_Controls(i).Width, __UI_Controls(i).Height, __UI_Controls(i).BackColor, __UI_Controls(i).BackColor, __UI_True
                    END IF

                    IF __UI_Controls(i).HasBorder = __UI_True THEN
                        CaptionIndent = 5
                        __UI_DrawRectangle ContainerOffsetLeft + __UI_Controls(i).Left, ContainerOffsetTop + __UI_Controls(i).Top, __UI_Controls(i).Width, __UI_Controls(i).Height, __UI_Controls(i).BorderColor, TempColor~&, __UI_False
                    END IF

                    CaptionIndent = CaptionIndent + CircleDiameter * 1.5

                    IF __UI_Controls(i).Enabled THEN
                        COLOR __UI_Controls(i).ForeColor, __UI_Controls(i).BackColor
                    ELSE
                        COLOR __UI_Darken(__UI_Controls(__UI_GetID("Form1")).BackColor, 80), __UI_Controls(i).BackColor
                    END IF

                    _PRINTSTRING (ContainerOffsetLeft + __UI_Controls(i).Left + CaptionIndent, ContainerOffsetTop + __UI_Controls(i).Top + ((__UI_Controls(i).Height \ 2) - _FONTHEIGHT \ 2)), TempCaption$
                    IF __UI_Focus = i THEN
                        LINE (ContainerOffsetLeft + __UI_Controls(i).Left + CaptionIndent - 2, ContainerOffsetTop + __UI_Controls(i).Top + ((__UI_Controls(i).Height \ 2) - _FONTHEIGHT \ 2) - 2)-STEP(_PRINTWIDTH(TempCaption$) + 4, _FONTHEIGHT + 4), __UI_Darken(__UI_Controls(i).BackColor, 70), B , 63
                    END IF
                CASE __UI_Type_CheckBox
                    IF __UI_Controls(i).BackStyle = __UI_Opaque THEN
                        _PRINTMODE _FILLBACKGROUND
                    ELSE
                        _PRINTMODE _KEEPBACKGROUND
                    END IF

                    DIM CheckBoxSize AS INTEGER
                    __UI_DrawCheckBox    __UI_Controls(i).Value, _
                                         ContainerOffsetLeft + __UI_Controls(i).Left, _
                                         ContainerOffsetTop + __UI_Controls(i).Top + __UI_Controls(i).Height \ 2, _
                                         CheckBoxSize

                    CaptionIndent = 0
                    IF __UI_Controls(i).BackStyle = __UI_Opaque THEN
                        __UI_DrawRectangle ContainerOffsetLeft + __UI_Controls(i).Left, ContainerOffsetTop + __UI_Controls(i).Top, __UI_Controls(i).Width, __UI_Controls(i).Height, __UI_Controls(i).BackColor, __UI_Controls(i).BackColor, __UI_True
                    END IF

                    IF __UI_Controls(i).HasBorder = __UI_True THEN
                        CaptionIndent = 5
                        __UI_DrawRectangle ContainerOffsetLeft + __UI_Controls(i).Left, ContainerOffsetTop + __UI_Controls(i).Top, __UI_Controls(i).Width, __UI_Controls(i).Height, __UI_Controls(i).BorderColor, TempColor~&, __UI_False
                    END IF

                    CaptionIndent = CaptionIndent + CheckBoxSize * 1.5

                    IF __UI_Controls(i).Enabled THEN
                        COLOR __UI_Controls(i).ForeColor, __UI_Controls(i).BackColor
                    ELSE
                        COLOR __UI_Darken(__UI_Controls(__UI_GetID("Form1")).BackColor, 80), __UI_Controls(i).BackColor
                    END IF

                    _PRINTSTRING (ContainerOffsetLeft + __UI_Controls(i).Left + CaptionIndent, ContainerOffsetTop + __UI_Controls(i).Top + ((__UI_Controls(i).Height \ 2) - _FONTHEIGHT \ 2)), TempCaption$
                    IF __UI_Focus = i THEN
                        LINE (ContainerOffsetLeft + __UI_Controls(i).Left + CaptionIndent - 2, ContainerOffsetTop + __UI_Controls(i).Top + ((__UI_Controls(i).Height \ 2) - _FONTHEIGHT \ 2) - 2)-STEP(_PRINTWIDTH(TempCaption$) + 4, _FONTHEIGHT + 4), __UI_Darken(__UI_Controls(i).BackColor, 70), B , 63
                    END IF
                CASE __UI_Type_TextBox
                    IF __UI_Controls(i).InputViewStart = 0 THEN __UI_Controls(i).InputViewStart = 1

                    IF __UI_Controls(i).BackStyle = __UI_Opaque THEN
                        _PRINTMODE _FILLBACKGROUND
                    ELSE
                        _PRINTMODE _KEEPBACKGROUND
                    END IF

                    IF (__UI_HoveringID = i OR __UI_Focus = i) AND _
                        __UI_Controls(i).Enabled THEN
                        __UI_DrawRectangle ContainerOffsetLeft + __UI_Controls(i).Left + 2, ContainerOffsetTop + __UI_Controls(i).Top + 2, __UI_Controls(i).Width, __UI_Controls(i).Height, __UI_Controls(i).BorderColor, __UI_Darken(__UI_Controls(__UI_GetID("Form1")).BackColor, 50), __UI_True
                    END IF

                    CaptionIndent = 0
                    IF __UI_Controls(i).BackStyle = __UI_Opaque THEN
                        __UI_DrawRectangle ContainerOffsetLeft + __UI_Controls(i).Left, ContainerOffsetTop + __UI_Controls(i).Top, __UI_Controls(i).Width, __UI_Controls(i).Height, __UI_Controls(i).BackColor, __UI_Controls(i).BackColor, __UI_True
                    END IF

                    IF __UI_Controls(i).HasBorder = __UI_True THEN
                        CaptionIndent = 5
                        __UI_DrawRectangle ContainerOffsetLeft + __UI_Controls(i).Left, ContainerOffsetTop + __UI_Controls(i).Top, __UI_Controls(i).Width, __UI_Controls(i).Height, __UI_Controls(i).BorderColor, TempColor~&, __UI_False
                    END IF

                    IF __UI_Controls(i).Enabled AND LEN(__UI_Texts(i)) THEN
                        COLOR __UI_Controls(i).ForeColor, __UI_Controls(i).BackColor
                    ELSE
                        COLOR __UI_Darken(__UI_Controls(__UI_GetID("Form1")).BackColor, 80), __UI_Controls(i).BackColor
                    END IF

                    IF LEN(__UI_Texts(i)) THEN
                        _PRINTSTRING (ContainerOffsetLeft + __UI_Controls(i).Left + CaptionIndent, ContainerOffsetTop + __UI_Controls(i).Top + ((__UI_Controls(i).Height \ 2) - _FONTHEIGHT \ 2)), MID$(__UI_Texts(i), __UI_Controls(i).InputViewStart, __UI_Controls(i).FieldArea)
                    ELSE
                        _PRINTSTRING (ContainerOffsetLeft + __UI_Controls(i).Left + CaptionIndent, ContainerOffsetTop + __UI_Controls(i).Top + ((__UI_Controls(i).Height \ 2) - _FONTHEIGHT \ 2)), TempCaption$
                    END IF

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

                        LINE (ContainerOffsetLeft + __UI_Controls(i).Left + CaptionIndent + ss1 * _FONTWIDTH, ContainerOffsetTop + __UI_Controls(i).Top + ((__UI_Controls(i).Height \ 2) - _FONTHEIGHT \ 2))-STEP(ss2 * _FONTWIDTH, _FONTHEIGHT), _RGBA32(0, 0, 0, 50), BF
                    END IF

                    IF __UI_Focus = i THEN
                        STATIC SetCursor#, cursorBlink%%
                        IF TIMER - SetCursor# > .4 THEN
                            SetCursor# = TIMER
                            cursorBlink%% = NOT cursorBlink%%
                        END IF
                        IF cursorBlink%% THEN
                            LINE (ContainerOffsetLeft + __UI_Controls(i).Left + CaptionIndent + (__UI_Controls(i).Cursor - (__UI_Controls(i).InputViewStart - 1)) * _FONTWIDTH, ContainerOffsetTop + __UI_Controls(i).Top + ((__UI_Controls(i).Height \ 2) - _FONTHEIGHT \ 2))-STEP(0, _FONTHEIGHT), _RGB32(0, 0, 0)
                        END IF
                    END IF
                CASE __UI_Type_ProgressBar
                    __UI_DrawProgressBar __UI_Controls(i)
                CASE __UI_Type_ListBox
                    IF __UI_Controls(i).InputViewStart = 0 THEN __UI_Controls(i).InputViewStart = 1

                    IF __UI_Controls(i).BackStyle = __UI_Opaque THEN
                        _PRINTMODE _FILLBACKGROUND
                    ELSE
                        _PRINTMODE _KEEPBACKGROUND
                    END IF

                    CaptionIndent = 0
                    IF __UI_Controls(i).BackStyle = __UI_Opaque THEN
                        __UI_DrawRectangle ContainerOffsetLeft + __UI_Controls(i).Left, ContainerOffsetTop + __UI_Controls(i).Top, __UI_Controls(i).Width, __UI_Controls(i).Height, __UI_Controls(i).BackColor, __UI_Controls(i).BackColor, __UI_True
                    END IF

                    IF __UI_Controls(i).HasBorder = __UI_True THEN
                        CaptionIndent = 5
                        __UI_DrawRectangle ContainerOffsetLeft + __UI_Controls(i).Left, ContainerOffsetTop + __UI_Controls(i).Top, __UI_Controls(i).Width, __UI_Controls(i).Height, __UI_Controls(i).BorderColor, TempColor~&, __UI_False
                    END IF

                    IF __UI_Controls(i).Enabled THEN
                        COLOR __UI_Controls(i).ForeColor, __UI_Controls(i).BackColor
                    ELSE
                        COLOR __UI_Darken(__UI_Controls(__UI_GetID("Form1")).BackColor, 80), __UI_Controls(i).BackColor
                    END IF

                    IF LEN(__UI_Texts(i)) THEN
                        DIM TempText$, FindLF&, ThisItem%, ThisItemTop%

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
                            IF ThisItem% >= __UI_Controls(i).InputViewStart THEN
                                ThisItemTop% = __UI_Controls(i).Top + (ThisItem% - __UI_Controls(i).InputViewStart) * _FONTHEIGHT - _FONTHEIGHT + CaptionIndent
                                IF ThisItemTop% + _FONTHEIGHT > __UI_Controls(i).Top + __UI_Controls(i).Height THEN EXIT DO
                                DO WHILE _PRINTWIDTH(TempCaption$) > __UI_Controls(i).Width
                                    TempCaption$ = MID$(TempCaption$, 1, LEN(TempCaption$) - 1)
                                LOOP

                                SELECT CASE __UI_Controls(i).Align
                                    CASE __UI_Left
                                        _PRINTSTRING (ContainerOffsetLeft + __UI_Controls(i).Left + CaptionIndent, ContainerOffsetTop + ThisItemTop%), TempCaption$
                                    CASE __UI_Center
                                        _PRINTSTRING (ContainerOffsetLeft + __UI_Controls(i).Left + (__UI_Controls(i).Width \ 2 - _PRINTWIDTH(TempCaption$) \ 2), ContainerOffsetTop + ThisItemTop%), TempCaption$
                                    CASE __UI_Right
                                        _PRINTSTRING (ContainerOffsetLeft + __UI_Controls(i).Left + (__UI_Controls(i).Width - _PRINTWIDTH(TempCaption$)) - CaptionIndent, ContainerOffsetTop + ThisItemTop%), TempCaption$
                                END SELECT

                                IF ThisItem% = __UI_Controls(i).Value THEN
                                    LINE (ContainerOffsetLeft + __UI_Controls(i).Left + CaptionIndent, ContainerOffsetTop + ThisItemTop% + _FONTHEIGHT)-STEP(__UI_Controls(i).Width - CaptionIndent * 2, _FONTHEIGHT), _RGBA32(0, 0, 0, 50), BF
                                END IF
                            END IF
                        LOOP
                    END IF
            END SELECT
        END IF
    NEXT

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
    DIM i AS LONG

    IF __UI_HoveringID = 0 THEN EXIT SUB

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

    IF __UI_Controls(__UI_HoveringID).CanDrag THEN _MOUSESHOW "link" ELSE _MOUSESHOW "default"

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

    'MouseDown, MouseUp, BeginDrag
    IF __UI_MouseButton1 THEN
        IF __UI_MouseIsDown = __UI_False THEN
            IF __UI_Controls(__UI_HoveringID).CanHaveFocus AND __UI_Controls(__UI_HoveringID).Enabled THEN __UI_Focus = __UI_HoveringID
            __UI_MouseIsDown = __UI_True
            __UI_MouseDownOnID = __UI_HoveringID
            IF __UI_Controls(__UI_HoveringID).CanDrag THEN
                IF __UI_IsDragging = __UI_False THEN
                    __UI_IsDragging = __UI_True
                    __UI_DraggingID = __UI_HoveringID
                    __UI_BeginDrag __UI_DraggingID
                    __UI_DragY = __UI_MouseY
                    __UI_DragX = __UI_MouseX
                END IF
            END IF
            IF __UI_Controls(__UI_HoveringID).Type = __UI_Type_TextBox THEN
                _FONT __UI_Fonts(__UI_Controls(__UI_HoveringID).Font)
                IF __UI_IsSelectingText = __UI_False THEN
                    __UI_Controls(__UI_HoveringID).Selected = __UI_False
                    __UI_SelectedText = ""
                    __UI_Controls(__UI_HoveringID).SelectionStart = ((__UI_MouseX - __UI_Controls(__UI_HoveringID).Left) / _FONTWIDTH) + (__UI_Controls(__UI_HoveringID).InputViewStart - 1)
                    __UI_Controls(__UI_HoveringID).Cursor = __UI_Controls(__UI_HoveringID).SelectionStart
                    IF __UI_Controls(__UI_HoveringID).SelectionStart > LEN(__UI_Texts(__UI_HoveringID)) THEN __UI_Controls(__UI_HoveringID).SelectionStart = LEN(__UI_Texts(__UI_HoveringID))
                    IF __UI_Controls(__UI_HoveringID).Cursor > LEN(__UI_Texts(__UI_HoveringID)) THEN __UI_Controls(__UI_HoveringID).Cursor = LEN(__UI_Texts(__UI_HoveringID))
                    __UI_IsSelectingText = __UI_True
                    __UI_IsSelectingTextOnID = __UI_HoveringID
                END IF
            END IF
            __UI_MouseDown __UI_HoveringID
        ELSE
            IF __UI_MouseDownOnID <> __UI_HoveringID AND __UI_MouseDownOnID > 0 THEN
                __UI_MouseDownOnID = 0
            ELSE
                IF __UI_IsSelectingText THEN
                    _FONT __UI_Fonts(__UI_Controls(__UI_IsSelectingTextOnID).Font)
                    IF __UI_MouseX <= __UI_Controls(__UI_IsSelectingTextOnID).Left AND __UI_Controls(__UI_IsSelectingTextOnID).InputViewStart > 1 THEN
                        __UI_Controls(__UI_IsSelectingTextOnID).InputViewStart = __UI_Controls(__UI_IsSelectingTextOnID).InputViewStart - 1
                        __UI_Controls(__UI_IsSelectingTextOnID).Cursor = __UI_Controls(__UI_IsSelectingTextOnID).InputViewStart
                    ELSE
                        __UI_Controls(__UI_IsSelectingTextOnID).Cursor = ((__UI_MouseX - __UI_Controls(__UI_IsSelectingTextOnID).Left) / _FONTWIDTH) + (__UI_Controls(__UI_IsSelectingTextOnID).InputViewStart - 1)
                        IF __UI_Controls(__UI_IsSelectingTextOnID).Cursor < 0 THEN __UI_Controls(__UI_IsSelectingTextOnID).Cursor = 0
                        IF __UI_Controls(__UI_IsSelectingTextOnID).Cursor > LEN(__UI_Texts(__UI_IsSelectingTextOnID)) THEN __UI_Controls(__UI_IsSelectingTextOnID).Cursor = LEN(__UI_Texts(__UI_IsSelectingTextOnID))
                        IF __UI_Controls(__UI_IsSelectingTextOnID).Cursor <> __UI_Controls(__UI_IsSelectingTextOnID).SelectionStart THEN
                            __UI_Controls(__UI_IsSelectingTextOnID).Selected = __UI_True
                        END IF
                    END IF
                END IF
            END IF
        END IF
    ELSE
        IF __UI_MouseIsDown THEN
            IF __UI_IsDragging THEN
                __UI_EndDrag __UI_DraggingID
                __UI_IsDragging = __UI_False
                'Snap the previously dragged object to the grid (unless Ctrl is down):
                __UI_Controls(__UI_DraggingID).Top = __UI_PreviewTop
                __UI_Controls(__UI_DraggingID).Left = __UI_PreviewLeft
                __UI_DraggingID = 0
            END IF

            'Click
            IF TIMER - __UI_LastMouseClick > .2 THEN
                IF __UI_MouseDownOnID = __UI_HoveringID AND __UI_HoveringID > 0 THEN
                    IF __UI_Controls(__UI_HoveringID).Enabled THEN
                        SELECT CASE __UI_Controls(__UI_HoveringID).Type
                            CASE __UI_Type_RadioButton
                                __UI_SetRadioButtonValue __UI_HoveringID
                            CASE __UI_Type_CheckBox
                                __UI_Controls(__UI_HoveringID).Value = NOT __UI_Controls(__UI_HoveringID).Value
                            CASE __UI_Type_TextBox
                                _FONT __UI_Fonts(__UI_Controls(__UI_HoveringID).Font)
                                __UI_Controls(__UI_HoveringID).Cursor = ((__UI_MouseX - __UI_Controls(__UI_HoveringID).Left) / _FONTWIDTH) + (__UI_Controls(__UI_HoveringID).InputViewStart - 1)
                                IF __UI_Controls(__UI_HoveringID).Cursor > LEN(__UI_Texts(__UI_HoveringID)) THEN __UI_Controls(__UI_HoveringID).Cursor = LEN(__UI_Texts(__UI_HoveringID))
                                __UI_IsSelectingText = __UI_False
                                __UI_IsSelectingTextOnID = 0
                        END SELECT
                        __UI_Click __UI_HoveringID
                        __UI_LastMouseClick = TIMER
                        __UI_MouseDownOnID = 0
                    END IF
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
        __UI_Controls(__UI_DraggingID).Top = __UI_Controls(__UI_DraggingID).Top + (__UI_MouseY - __UI_DragY)
        __UI_DragY = __UI_MouseY

        __UI_Controls(__UI_DraggingID).Left = __UI_Controls(__UI_DraggingID).Left + (__UI_MouseX - __UI_DragX)
        __UI_DragX = __UI_MouseX

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
    END IF

    'Keyboard handler
    IF __UI_KeyHit = 100303 OR __UI_KeyHit = 100304 THEN __UI_ShiftIsDown = __UI_True
    IF __UI_KeyHit = -100303 OR __UI_KeyHit = -100304 THEN __UI_ShiftIsDown = __UI_False
    IF __UI_KeyHit = 100305 OR __UI_KeyHit = 100306 THEN __UI_CtrlIsDown = __UI_True
    IF __UI_KeyHit = -100305 OR __UI_KeyHit = -100306 THEN __UI_CtrlIsDown = __UI_False
    IF __UI_KeyHit = 100307 OR __UI_KeyHit = 100308 THEN __UI_AltIsDown = __UI_True
    IF __UI_KeyHit = -100307 OR __UI_KeyHit = -100308 THEN __UI_AltIsDown = __UI_False

    IF __UI_Focus THEN
        'Enter activates the selected/default button, if any
        IF __UI_IsDragging = __UI_False AND _
            __UI_KeyHit = -13 AND _
            __UI_Controls(__UI_Focus).Enabled THEN
            'Enter released and there is a default button
            IF __UI_Controls(__UI_Focus).Type = __UI_Type_Button THEN
                __UI_Click __UI_Focus
            ELSEIF __UI_Focus <> __UI_DefaultButtonID AND __UI_DefaultButtonID > 0 THEN
                __UI_Click __UI_DefaultButtonID
            END IF
        ELSE
            SELECT CASE __UI_Controls(__UI_Focus).Type
                CASE __UI_Type_Button, __UI_Type_RadioButton, __UI_Type_CheckBox
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
                CASE __UI_Type_ListBox
                    SELECT CASE __UI_KeyHit
                        CASE 18432 'Up
                            IF __UI_Controls(__UI_Focus).Value > 1 THEN _
                                __UI_Controls(__UI_Focus).Value = __UI_Controls(__UI_Focus).Value - 1
                        CASE 20480 'Down
                            IF __UI_Controls(__UI_Focus).Value < __UI_Controls(__UI_Focus).Max THEN _
                                __UI_Controls(__UI_Focus).Value = __UI_Controls(__UI_Focus).Value + 1
                    END SELECT
                CASE __UI_Type_TextBox
                    DIM Clip$, FindLF&
                    DIM s1 AS LONG, s2 AS LONG
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
        IF __UI_Controls(i).ID > 0 AND UCASE$(RTRIM$(__UI_Controls(i).Name)) = UCASE$(ObjectName$) THEN
            __UI_GetID = i
            EXIT FUNCTION
        END IF
    NEXT

    ERROR 5
END FUNCTION

'---------------------------------------------------------------------------------
FUNCTION __UI_NewObject (ObjType AS INTEGER, ObjName AS STRING, ParentID AS LONG)
    DIM NextSlot AS LONG, i AS LONG

    IF ObjType = __UI_Type_Form THEN
        'Make sure no other Form object exists, as Form is the main window
        FOR i = 1 TO UBOUND(__UI_Controls)
            IF __UI_Controls(i).Type = __UI_Type_Form THEN ERROR 5: EXIT FUNCTION
        NEXT
    END IF

    'Make sure this ObjName is unique:
    FOR i = 1 TO UBOUND(__UI_Controls)
        IF UCASE$(RTRIM$(__UI_Controls(i).Name)) = UCASE$(RTRIM$(ObjName)) THEN ERROR 5: EXIT FUNCTION
    NEXT

    'Find an empty slot for the new object
    FOR NextSlot = 1 TO UBOUND(__UI_Controls)
        IF __UI_Controls(NextSlot).ID = __UI_False THEN EXIT FOR
    NEXT

    IF NextSlot > UBOUND(__UI_Controls) THEN
        'No empty slots. We must increase __UI_Controls() and its helper arrays
        REDIM _PRESERVE __UI_Controls(0 TO NextSlot + 99) AS ObjectTYPE
        REDIM _PRESERVE __UI_Captions(1 TO NextSlot + 99) AS STRING
        REDIM _PRESERVE __UI_Texts(1 TO NextSlot + 99) AS STRING
    END IF

    '__UI_DestroyObject __UI_Controls(NextSlot)
    __UI_Controls(NextSlot).ID = NextSlot
    __UI_Controls(NextSlot).ParentID = ParentID
    __UI_Controls(NextSlot).Type = ObjType
    __UI_Controls(NextSlot).Name = ObjName
    __UI_NewObject = NextSlot
END FUNCTION

'---------------------------------------------------------------------------------
'SUB __UI_DestroyObject (__UI_EmptyObject AS ObjectTYPE)
'    __UI_EmptyObject.ID = 0
'    __UI_EmptyObject.ParentID = 0
'    __UI_EmptyObject.Type = 0
'    __UI_EmptyObject.Name = ""
'    __UI_EmptyObject.Top = 0
'    __UI_EmptyObject.Left = 0
'    __UI_EmptyObject.Width = 0
'    __UI_EmptyObject.Height = 0
'    __UI_EmptyObject.BackColor = 0
'    __UI_EmptyObject.ForeColor = 0
'    __UI_EmptyObject.BackStyle = 0
'    __UI_EmptyObject.Value = 0
'    __UI_EmptyObject.Min = 0
'    __UI_EmptyObject.Max = 0
'    __UI_EmptyObject.Enabled = 0
'    __UI_EmptyObject.Event.Click = 0
'    __UI_EmptyObject.Event.DoubleClick = 0
'    __UI_EmptyObject.Event.Hover = 0
'    __UI_EmptyObject.Event.FocusIn = 0
'    __UI_EmptyObject.Event.FocusOut = 0
'    __UI_EmptyObject.Event.Load = 0
'    __UI_EmptyObject.Event.Unload = 0
'    __UI_EmptyObject.Event.Error = 0
'    __UI_EmptyObject.Event.MouseDown = 0
'    __UI_EmptyObject.Event.MouseUp = 0
'    __UI_EmptyObject.Event.Wheel = 0
'    __UI_EmptyObject.Event.KeyHit = 0
'END SUB

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
SUB __UI_DrawRadioButton (Checked%%, Left&, Top&, CircleDiameter%)
    DIM i AS SINGLE
    CircleDiameter% = 10

    CIRCLE (Left& + CircleDiameter% / 3, Top&), CircleDiameter% / 2, _RGB32(0, 0, 0)

    IF Checked%% THEN
        FOR i = CircleDiameter% / 3 TO 1 STEP -.1
            CIRCLE (Left& + CircleDiameter% / 3, Top&), i, _RGB32(0, 0, 0)
        NEXT
    END IF
END SUB

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
SUB __UI_DrawCheckBox (Checked%%, Left&, Top&, BoxSize%)
    DIM i AS SINGLE
    BoxSize% = 10

    LINE (Left&, Top& - BoxSize% / 2)-STEP(BoxSize%, BoxSize%), _RGB32(0, 0, 0), B

    IF Checked%% THEN
        LINE (Left&, Top& - BoxSize% / 2)-STEP(BoxSize%, BoxSize%), _RGB32(0, 0, 0)
        LINE (Left&, Top& + BoxSize% / 2)-STEP(BoxSize%, -BoxSize%), _RGB32(0, 0, 0)
    END IF
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
    __UI_Controls(__UI_Focus).Cursor = s1
END SUB

'---------------------------------------------------------------------------------
SUB __UI_CursorAdjustments
    IF __UI_Controls(__UI_Focus).Cursor > __UI_Controls(__UI_Focus).PrevCursor THEN
        IF __UI_Controls(__UI_Focus).Cursor - __UI_Controls(__UI_Focus).InputViewStart + 2 > __UI_Controls(__UI_Focus).FieldArea THEN __UI_Controls(__UI_Focus).InputViewStart = (__UI_Controls(__UI_Focus).Cursor - __UI_Controls(__UI_Focus).FieldArea) + 2
    ELSEIF __UI_Controls(__UI_Focus).Cursor < __UI_Controls(__UI_Focus).PrevCursor THEN
        IF __UI_Controls(__UI_Focus).Cursor < __UI_Controls(__UI_Focus).InputViewStart - 1 THEN __UI_Controls(__UI_Focus).InputViewStart = __UI_Controls(__UI_Focus).Cursor
    END IF
    __UI_Controls(__UI_Focus).PrevCursor = __UI_Controls(__UI_Focus).Cursor
    IF __UI_Controls(__UI_Focus).InputViewStart < 1 THEN __UI_Controls(__UI_Focus).InputViewStart = 1
END SUB

'---------------------------------------------------------------------------------
SUB __UI_DrawProgressBar (ProgressBar AS ObjectTYPE)
    DIM ContainerOffsetLeft AS INTEGER, ContainerOffsetTop AS INTEGER
    DIM DisplayValue AS _FLOAT

    IF ProgressBar.Value > ProgressBar.Max THEN ERROR 5

    IF ProgressBar.ParentID THEN
        ContainerOffsetTop = __UI_Controls(ProgressBar.ParentID).Top
        ContainerOffsetLeft = __UI_Controls(ProgressBar.ParentID).Left
    END IF

    LINE (ContainerOffsetLeft + ProgressBar.Left, _
          ContainerOffsetTop + ProgressBar.Top)-_
          STEP(ProgressBar.Width - 1, _
          ProgressBar.Height -1), ProgressBar.BackColor, BF

    LINE (ContainerOffsetLeft + ProgressBar.Left, _
          ContainerOffsetTop + ProgressBar.Top)-_
          STEP(((ProgressBar.Width - 1) / ProgressBar.Max) * ProgressBar.Value, _
          ProgressBar.Height -1), ProgressBar.ForeColor, BF

    IF ProgressBar.HasBorder THEN
        LINE (ContainerOffsetLeft + ProgressBar.Left, _
              ContainerOffsetTop + ProgressBar.Top)-_
              STEP(ProgressBar.Width - 1, _
              ProgressBar.Height -1), ProgressBar.BorderColor, B
    END IF

    IF ProgressBar.ShowPercentage OR LEN(__UI_Captions(ProgressBar.ID)) THEN
        DIM ProgressString$
        ProgressString$ = LTRIM$(STR$(FIX((ProgressBar.Value / ProgressBar.Max) * 100))) + "%"
        IF LEN(__UI_Captions(ProgressBar.ID)) THEN
            ProgressString$ = __UI_Captions(ProgressBar.ID)
            DO WHILE _PRINTWIDTH(ProgressString$) > ProgressBar.Width
                ProgressString$ = MID$(ProgressString$, 1, LEN(ProgressString$) - 1)
            LOOP
        END IF
        _FONT __UI_Fonts(ProgressBar.Font)
        _PRINTMODE _KEEPBACKGROUND
        COLOR ProgressBar.BorderColor
        IF _PRINTWIDTH(ProgressString$) < ProgressBar.Width THEN
            _PRINTSTRING (ContainerOffsetLeft + ProgressBar.Left + ProgressBar.Width / 2 - _PRINTWIDTH(ProgressString$) / 2, _
                          ContainerOffsetTop + ProgressBar.Top + ProgressBar.Height / 2 - _FONTHEIGHT / 2), _
                          ProgressString$
        END IF
    END IF
END SUB

'---------------------------------------------------------------------------------
SUB __UI_AddListBoxItem (WhichListBox$, Item$)
    DIM ThisID AS LONG

    ThisID = __UI_GetID(WhichListBox$)
    IF __UI_Controls(ThisID).Type <> __UI_Type_ListBox THEN ERROR 5: EXIT SUB

    __UI_Texts(ThisID) = __UI_Texts(ThisID) + CHR$(13) + Item$
    __UI_Controls(ThisID).Max = __UI_Controls(ThisID).Max + 1
END SUB
