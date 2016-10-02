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
    BackColor AS _UNSIGNED LONG
    ForeColor AS _UNSIGNED LONG
    BackStyle AS _BYTE
    BorderStyle AS _BYTE
    BorderColor AS _UNSIGNED LONG
    Value AS _FLOAT
    Min AS _FLOAT
    Max AS _FLOAT
    Resizable AS _BYTE
    Enabled AS _BYTE
END TYPE

REDIM SHARED __UI_Captions(1 TO 100) AS STRING
REDIM SHARED __UI_Texts(1 TO 100) AS STRING
REDIM SHARED __UI_Objects(1 TO 100) AS ObjectTYPE

DIM SHARED __UI_MouseX AS INTEGER, __UI_MouseY AS INTEGER
DIM SHARED __UI_MouseButton1 AS _BYTE, __UI_MouseButton2 AS _BYTE
DIM SHARED __UI_KeyHit AS LONG
DIM SHARED __UI_Focus AS LONG
DIM SHARED __UI_HoveringID AS LONG
DIM SHARED __UI_LastHoveringID AS LONG

'Object types:
CONST __UI_Type_Form = 1
CONST __UI_Type_Button = 2
CONST __UI_Type_Label = 3
CONST __UI_Type_TextBox = 4
CONST __UI_Type_CheckBox = 5
CONST __UI_Type_ComboBox = 6
CONST __UI_Type_Frame = 7
CONST __UI_Type_ListBox = 8
CONST __UI_Type_RadioButton = 9
CONST __UI_Type_Menu = 10

'BackStyles:
CONST __UI_Opaque = 0
CONST __UI_Transparent = -1

'Global constants
CONST __UI_True = -1
CONST __UI_False = 0

DIM NewID AS LONG, ParentID AS LONG

NewID = __UI_NewObject(__UI_Type_Form, 0)
__UI_Objects(NewID).Name = "Form1"
__UI_Objects(NewID).Width = 640
__UI_Objects(NewID).Height = 400
__UI_Objects(NewID).ForeColor = _RGB32(0, 0, 0)
__UI_Objects(NewID).BackColor = _RGB32(161, 161, 161)
__UI_Objects(NewID).Resizable = __UI_False
__UI_Objects(NewID).Enabled = __UI_True
__UI_SetCaption "Form1", "Hello, world!"

NewID = __UI_NewObject(__UI_Type_Button, 0)
__UI_Objects(NewID).Name = "Button1"
__UI_Objects(NewID).Top = 100
__UI_Objects(NewID).Left = 100
__UI_Objects(NewID).Width = 200
__UI_Objects(NewID).Height = 20
__UI_Objects(NewID).ForeColor = _RGB32(0, 0, 0)
__UI_Objects(NewID).Enabled = __UI_True
__UI_SetCaption "Button1", "Click me"

NewID = __UI_NewObject(__UI_Type_Button, 0)
__UI_Objects(NewID).Name = "Button2"
__UI_Objects(NewID).Top = 200
__UI_Objects(NewID).Left = 100
__UI_Objects(NewID).Width = 200
__UI_Objects(NewID).Height = 20
__UI_Objects(NewID).ForeColor = _RGB32(0, 0, 0)
__UI_Objects(NewID).Enabled = __UI_True
__UI_SetCaption "Button2", "Make resizable"

NewID = __UI_NewObject(__UI_Type_Label, 0)
__UI_Objects(NewID).Name = "Label1"
__UI_Objects(NewID).Top = 30
__UI_Objects(NewID).Left = 10
__UI_Objects(NewID).Width = 200
__UI_Objects(NewID).Height = 20
__UI_Objects(NewID).ForeColor = _RGB32(0, 0, 0)
__UI_Objects(NewID).BackColor = _RGB32(161, 161, 161)
__UI_Objects(NewID).Enabled = __UI_True
__UI_SetCaption "Label1", "Waiting for you to click"

NewID = __UI_NewObject(__UI_Type_Label, 0)
__UI_Objects(NewID).Name = "Label2"
__UI_Objects(NewID).Top = 230
__UI_Objects(NewID).Left = 30
__UI_Objects(NewID).Width = 200
__UI_Objects(NewID).Height = 20
__UI_Objects(NewID).ForeColor = _RGB32(0, 0, 0)
__UI_Objects(NewID).BackColor = _RGB32(161, 161, 161)
__UI_Objects(NewID).Enabled = __UI_True
__UI_SetCaption "Label2", "Resizable: OFF"

SCREEN _NEWIMAGE(__UI_Objects(__UI_GetID("Form1")).Width, __UI_Objects(__UI_GetID("Form1")).Height, 32)

'Main loop
DO
    __UI_UpdateDisplay
    _LIMIT 30
LOOP

'Event procedures: ---------------------------------------------------------------
'Generated at design time - code inside CASE statements to be added by programmer.
'---------------------------------------------------------------------------------
SUB __UI_Click (id AS LONG)
    SELECT CASE UCASE$(RTRIM$(__UI_Objects(id).Name))
        CASE "FORM1"

        CASE "BUTTON1"
            STATIC State AS _BYTE
            State = State + 1: IF State > 3 THEN State = 1
            SELECT CASE State
                CASE 1
                    __UI_Objects(__UI_GetID("Label1")).Enabled = __UI_True
                    __UI_Captions(__UI_GetID("Label1")) = "You clicked the button!"
                CASE 2
                    __UI_Captions(__UI_GetID("Label1")) = "Aren't you the clicker?"
                CASE 3
                    __UI_Objects(__UI_GetID("Label1")).Enabled = __UI_False
                    __UI_Captions(__UI_GetID("Label1")) = "Stop it."
            END SELECT
        CASE "BUTTON2"
            __UI_Objects(__UI_GetID("Form1")).Resizable = NOT __UI_Objects(__UI_GetID("Form1")).Resizable
            IF __UI_Objects(__UI_GetID("Form1")).Resizable THEN
                __UI_Captions(__UI_GetID("Label2")) = "Resizable:ON"
            ELSE
                __UI_Captions(__UI_GetID("Label2")) = "Resizable:OFF"
            END IF
        CASE "LABEL1"
            __UI_Captions(__UI_GetID("Label1")) = "I'm not a button..."
    END SELECT
END SUB

SUB __UI_MouseEnter (id AS LONG)
    SELECT CASE UCASE$(RTRIM$(__UI_Objects(id).Name))
        CASE "FORM1"

        CASE "BUTTON1"

        CASE "LABEL1"
            __UI_Objects(__UI_GetID("Label1")).ForeColor = _RGB32(255, 255, 255)
            __UI_Objects(__UI_GetID("Label1")).BackColor = _RGB32(127, 172, 127)
    END SELECT
END SUB

SUB __UI_MouseLeave (id AS LONG)
    SELECT CASE UCASE$(RTRIM$(__UI_Objects(id).Name))
        CASE "FORM1"

        CASE "BUTTON1"

        CASE "LABEL1"
            __UI_Objects(__UI_GetID("Label1")).ForeColor = _RGB32(0, 0, 0)
            __UI_Objects(__UI_GetID("Label1")).BackColor = _RGB32(161, 161, 161)
    END SELECT
END SUB

SUB __UI_FocusIn (id AS LONG)
    SELECT CASE UCASE$(RTRIM$(__UI_Objects(id).Name))
        CASE "FORM1"

        CASE "BUTTON1"

        CASE "LABEL1"

    END SELECT
END SUB

SUB __UI_FocusOut (id AS LONG)
    SELECT CASE UCASE$(RTRIM$(__UI_Objects(id).Name))
        CASE "FORM1"

        CASE "BUTTON1"

        CASE "LABEL1"

    END SELECT
END SUB

SUB __UI_MouseDown (id AS LONG)
    SELECT CASE UCASE$(RTRIM$(__UI_Objects(id).Name))
        CASE "FORM1"

        CASE "BUTTON1"

        CASE "LABEL1"

    END SELECT
END SUB

SUB __UI_MouseUp (id AS LONG)
    SELECT CASE UCASE$(RTRIM$(__UI_Objects(id).Name))
        CASE "FORM1"

        CASE "BUTTON1"

        CASE "LABEL1"

    END SELECT
END SUB

'---------------------------------------------------------------------------------
'Internal procedures: ------------------------------------------------------------
'---------------------------------------------------------------------------------
SUB __UI_ProcessInput
    DIM OldScreen&

    'Mouse input:
    WHILE _MOUSEINPUT
    WEND

    __UI_MouseX = _MOUSEX
    __UI_MouseY = _MOUSEY
    __UI_MouseButton1 = _MOUSEBUTTON(1)
    __UI_MouseButton2 = _MOUSEBUTTON(2)

    'Keyboard input:
    __UI_KeyHit = _KEYHIT

    'Resize event:
    IF _RESIZE AND __UI_Objects(__UI_GetID("Form1")).Resizable THEN
        __UI_Objects(__UI_GetID("Form1")).Width = _RESIZEWIDTH
        __UI_Objects(__UI_GetID("Form1")).Height = _RESIZEHEIGHT
        OldScreen& = _DEST
        SCREEN _NEWIMAGE(__UI_Objects(__UI_GetID("Form1")).Width, __UI_Objects(__UI_GetID("Form1")).Height, 32)
        _FREEIMAGE OldScreen&
    END IF
END SUB

'---------------------------------------------------------------------------------
SUB __UI_UpdateDisplay
    DIM i AS LONG, TempCaption$, TempColor~&
    STATIC __UI_CurrentTitle AS STRING

    __UI_ProcessInput

    'Update main window properties if needed
    IF __UI_CurrentTitle <> __UI_Captions(__UI_GetID("Form1")) THEN
        __UI_CurrentTitle = __UI_Captions(__UI_GetID("Form1"))
        _TITLE __UI_CurrentTitle
    END IF

    IF __UI_Objects(__UI_GetID("Form1")).Resizable THEN
        _RESIZE ON
    ELSE
        _RESIZE OFF
    END IF

    'Main window:
    COLOR __UI_Objects(__UI_GetID("Form1")).ForeColor, __UI_Objects(__UI_GetID("Form1")).BackColor
    CLS

    FOR i = 1 TO UBOUND(__UI_Objects)
        IF __UI_Objects(i).ID THEN
            'Hover detection
            IF __UI_MouseX >= __UI_Objects(i).Left AND _
               __UI_MouseX <= __UI_Objects(i).Left + __UI_Objects(i).Width - 1 AND _
               __UI_MouseY >= __UI_Objects(i).Top AND _
               __UI_MouseY <= __UI_Objects(i).Top +  __UI_Objects(i).Height - 1 THEN
                __UI_HoveringID = i
            END IF
        END IF
    NEXT

    FOR i = 1 TO UBOUND(__UI_Objects)
        IF __UI_Objects(i).ID THEN
            TempCaption$ = __UI_Captions(i)
            DO WHILE _PRINTWIDTH(TempCaption$) > __UI_Objects(i).Width
                TempCaption$ = MID$(TempCaption$, 1, LEN(TempCaption$) - 1)
            LOOP

            IF i = __UI_HoveringID THEN
                TempColor~& = __UI_Darken(__UI_Objects(__UI_GetID("Form1")).BackColor, 80)
            ELSE
                TempColor~& = __UI_Objects(__UI_GetID("Form1")).BackColor
            END IF

            SELECT CASE __UI_Objects(i).Type
                CASE __UI_Type_Button
                    LINE (__UI_Objects(i).Left, __UI_Objects(i).Top)-STEP(__UI_Objects(i).Width - 1, __UI_Objects(i).Height - 1), TempColor~&, BF

                    LINE (__UI_Objects(i).Left, __UI_Objects(i).Top)-STEP(__UI_Objects(i).Width - 1, __UI_Objects(i).Height - 1), __UI_Objects(i).ForeColor, B

                    COLOR __UI_Objects(i).ForeColor, TempColor~&
                    _PRINTMODE _FILLBACKGROUND
                    _PRINTSTRING (__UI_Objects(i).Left + (__UI_Objects(i).Width \ 2 - _PRINTWIDTH(TempCaption$) \ 2), __UI_Objects(i).Top + ((__UI_Objects(i).Height \ 2) - _FONTHEIGHT \ 2)), TempCaption$
                CASE __UI_Type_Label
                    IF __UI_Objects(i).BackStyle = __UI_Opaque THEN
                        _PRINTMODE _KEEPBACKGROUND
                        LINE (__UI_Objects(i).Left, __UI_Objects(i).Top)-STEP(__UI_Objects(i).Width - 1, __UI_Objects(i).Height - 1), __UI_Objects(i).BackColor, BF
                    ELSE
                        _PRINTMODE _FILLBACKGROUND
                    END IF

                    IF __UI_Objects(i).BorderStyle = __UI_True THEN
                        LINE (__UI_Objects(i).Left, __UI_Objects(i).Top)-STEP(__UI_Objects(i).Width - 1, __UI_Objects(i).Height - 1), __UI_Objects(i).BorderColor, B
                    END IF

                    COLOR __UI_Objects(i).ForeColor
                    _PRINTSTRING (__UI_Objects(i).Left + (__UI_Objects(i).Width \ 2 - _PRINTWIDTH(TempCaption$) \ 2), __UI_Objects(i).Top + ((__UI_Objects(i).Height \ 2) - _FONTHEIGHT \ 2)), TempCaption$
            END SELECT
        END IF
    NEXT

    __UI_EventDispatcher

    _DISPLAY
END SUB

SUB __UI_EventDispatcher
    STATIC __UI_MouseIsDown AS _BYTE, __UI_MouseDownOnID AS LONG
    STATIC __UI_MouseIsUp AS _BYTE, __UI_MouseUpOnID AS LONG
    STATIC __UI_LastMouseUp AS DOUBLE, __UI_LastMouseDown AS DOUBLE
    STATIC __UI_LastMouseClick AS DOUBLE

    IF __UI_HoveringID = 0 THEN EXIT SUB

    IF __UI_LastHoveringID <> __UI_HoveringID THEN
        IF __UI_LastHoveringID THEN __UI_MouseLeave __UI_LastHoveringID
        __UI_MouseEnter __UI_HoveringID
    END IF

    IF __UI_MouseButton1 THEN
        IF __UI_MouseIsUp THEN
            __UI_MouseIsUp = __UI_False
            __UI_MouseIsDown = __UI_True
            __UI_MouseDownOnID = __UI_HoveringID
            __UI_MouseDown __UI_HoveringID
            __UI_LastMouseDown = TIMER
        ELSE
            __UI_MouseIsDown = __UI_True
            __UI_MouseIsUp = __UI_False
            IF __UI_MouseDownOnID <> __UI_HoveringID AND __UI_MouseDownOnID > 0 THEN
                __UI_MouseUp __UI_MouseDownOnID
            ELSEIF __UI_MouseDownOnID = __UI_HoveringID THEN
                __UI_MouseDown __UI_MouseDownOnID
            END IF
        END IF
    ELSE
        IF __UI_MouseIsDown THEN
            __UI_MouseIsDown = __UI_False
            __UI_MouseIsUp = __UI_True
            __UI_MouseUpOnID = __UI_HoveringID
            __UI_MouseUp __UI_HoveringID
            __UI_LastMouseUp = TIMER
        ELSE
            __UI_MouseIsUp = __UI_True
            __UI_MouseIsDown = __UI_False
        END IF
    END IF

    IF __UI_MouseIsUp AND TIMER - __UI_LastMouseClick > .2 THEN
        IF __UI_MouseDownOnID = __UI_MouseUpOnID AND __UI_MouseUpOnID > 0 THEN
            __UI_Click __UI_MouseUpOnID
            __UI_LastMouseClick = TIMER
            __UI_MouseDownOnID = 0
            __UI_MouseUpOnID = 0
        END IF
    END IF

    __UI_LastHoveringID = __UI_HoveringID
END SUB

'---------------------------------------------------------------------------------
FUNCTION __UI_GetID (ObjectName$)
    DIM i AS LONG

    FOR i = 1 TO UBOUND(__UI_Objects)
        IF __UI_Objects(i).ID > 0 AND UCASE$(RTRIM$(__UI_Objects(i).Name)) = UCASE$(ObjectName$) THEN
            __UI_GetID = i
            EXIT FUNCTION
        END IF
    NEXT

    ERROR 5
END FUNCTION

'---------------------------------------------------------------------------------
FUNCTION __UI_NewObject (ObjType AS INTEGER, ParentID AS LONG)
    DIM NextSlot AS LONG, i AS LONG

    IF ObjType = __UI_Type_Form THEN
        'Make sure no other Form object exists, as Form is the main window
        FOR i = 1 TO UBOUND(__UI_Objects)
            IF __UI_Objects(i).Type = __UI_Type_Form THEN ERROR 5: EXIT FUNCTION
        NEXT
    END IF

    'Find an empty slot for the new object
    FOR NextSlot = 1 TO UBOUND(__UI_Objects)
        IF __UI_Objects(NextSlot).ID = __UI_False THEN EXIT FOR
    NEXT

    IF NextSlot > UBOUND(__UI_Objects) THEN
        'No empty slots. We must increase __UI_Objects() and its helper arrays
        REDIM _PRESERVE __UI_Objects(1 TO NextSlot + 99) AS ObjectTYPE
        REDIM _PRESERVE __UI_Captions(1 TO NextSlot + 99) AS STRING
        REDIM _PRESERVE __UI_Texts(1 TO NextSlot + 99) AS STRING
    END IF

    '__UI_DestroyObject __UI_Objects(NextSlot)
    __UI_Objects(NextSlot).ID = NextSlot
    __UI_Objects(NextSlot).ParentID = ParentID
    __UI_Objects(NextSlot).Type = ObjType
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

'---------------------------------------------------------------------------------
FUNCTION __UI_ParentID& (Object$)
    __UI_ParentID& = __UI_Objects(__UI_GetID(Object$)).ParentID
END FUNCTION

'---------------------------------------------------------------------------------
FUNCTION __UI_Type% (Object$)
    __UI_Type% = __UI_Objects(__UI_GetID(Object$)).ParentID
END FUNCTION

'---------------------------------------------------------------------------------
FUNCTION __UI_Name$ (ID)
    __UI_Name$ = RTRIM$(__UI_Objects(ID).Name)
END FUNCTION

'---------------------------------------------------------------------------------
FUNCTION __UI_Top% (Object$)
    __UI_Top% = __UI_Objects(__UI_GetID(Object$)).Top
END FUNCTION

'---------------------------------------------------------------------------------
FUNCTION __UI_Left% (Object$)
    __UI_Left% = __UI_Objects(__UI_GetID(Object$)).Left
END FUNCTION

'---------------------------------------------------------------------------------
FUNCTION __UI_Width% (Object$)
    __UI_Width% = __UI_Objects(__UI_GetID(Object$)).Width
END FUNCTION

'---------------------------------------------------------------------------------
FUNCTION __UI_Height% (Object$)
    __UI_Height% = __UI_Objects(__UI_GetID(Object$)).Height
END FUNCTION

'---------------------------------------------------------------------------------
FUNCTION __UI_BackColor~& (Object$)
    __UI_BackColor~& = __UI_Objects(__UI_GetID(Object$)).BackColor
END FUNCTION

'---------------------------------------------------------------------------------
FUNCTION __UI_ForeColor~& (Object$)
    __UI_ForeColor~& = __UI_Objects(__UI_GetID(Object$)).ForeColor
END FUNCTION

'---------------------------------------------------------------------------------
FUNCTION __UI_BackStyle%% (Object$)
    __UI_BackStyle%% = __UI_Objects(__UI_GetID(Object$)).BackStyle
END FUNCTION

'---------------------------------------------------------------------------------
FUNCTION __UI_Value## (Object$)
    __UI_Value## = __UI_Objects(__UI_GetID(Object$)).Value
END FUNCTION

'---------------------------------------------------------------------------------
FUNCTION __UI_Min## (Object$)
    __UI_Min## = __UI_Objects(__UI_GetID(Object$)).Min
END FUNCTION

'---------------------------------------------------------------------------------
FUNCTION __UI_Max## (Object$)
    __UI_Max## = __UI_Objects(__UI_GetID(Object$)).Max
END FUNCTION

'---------------------------------------------------------------------------------
FUNCTION __UI_Enabled%% (Object$)
    __UI_Enabled%% = __UI_Objects(__UI_GetID(Object$)).Enabled
END FUNCTION

'---------------------------------------------------------------------------------
FUNCTION __UI_Caption$ (Object$)
    __UI_Caption$ = __UI_Captions(__UI_GetID(Object$))
END FUNCTION

'---------------------------------------------------------------------------------
SUB __UI_SetCaption (Object$, NewCaption$)
    __UI_Captions(__UI_GetID(Object$)) = NewCaption$
END SUB

'---------------------------------------------------------------------------------
SUB __UI_SetText (Object$, NewText$)
    __UI_Texts(__UI_GetID(Object$)) = NewText$
END SUB

FUNCTION __UI_Darken~& (WhichColor~&, ByHowMuch%)
    __UI_Darken~& = _RGB32(_RED(WhichColor~&) * (ByHowMuch% / 100), _GREEN(WhichColor~&) * (ByHowMuch% / 100), _BLUE(WhichColor~&) * (ByHowMuch% / 100))
END FUNCTION