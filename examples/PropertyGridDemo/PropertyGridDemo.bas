': PropertyGrid demo for InForm-PE
': Copyright (c) 2026 Fellippe Heitor
': https://github.com/QB64-Phoenix-Edition/InForm-PE
'
': The "Shape" frame is a property grid: its rows are created in __UI_OnLoad,
': and every change arrives in __UI_ValueChanged with the frame's ID.
'-----------------------------------------------------------

OPTION _EXPLICIT

': Controls' IDs: ------------------------------------------------------------------
DIM SHARED PropertyGridDemo AS LONG
DIM SHARED Canvas AS LONG
DIM SHARED ShapeFrame AS LONG
DIM SHARED StatusLB AS LONG

': External modules: ---------------------------------------------------------------
'$INCLUDE:'../../InForm/InForm.bi'
'$INCLUDE:'PropertyGridDemo.frm'

': Helpers: ------------------------------------------------------------------------
SUB ResetShape
    PropertyGrid_SetValue ShapeFrame, "label", "Hello"
    PropertyGrid_SetValue ShapeFrame, "shape", "1"
    PropertyGrid_SetValue ShapeFrame, "size", "120"
    PropertyGrid_SetValue ShapeFrame, "color", "3"
    PropertyGrid_SetValue ShapeFrame, "filled", "-1"
    PropertyGrid_SetValue ShapeFrame, "outline", "3"
    PropertyGrid_ShowRow ShapeFrame, "outline", False
END SUB

SUB DrawShape
    DIM s AS LONG, t AS LONG, i AS LONG, cx AS LONG, cy AS LONG, c AS _UNSIGNED LONG, label AS STRING

    s = VAL(PropertyGrid_Value$(ShapeFrame, "size"))
    t = VAL(PropertyGrid_Value$(ShapeFrame, "outline"))
    label = PropertyGrid_Value$(ShapeFrame, "label")
    SELECT CASE VAL(PropertyGrid_Value$(ShapeFrame, "color"))
        CASE 1: c = _RGB32(220, 50, 47)
        CASE 2: c = _RGB32(60, 160, 70)
        CASE 3: c = _RGB32(40, 110, 210)
        CASE ELSE: c = _RGB32(240, 140, 30)
    END SELECT

    BeginDraw Canvas
    CLS , _RGB32(250, 250, 250)
    cx = _WIDTH \ 2: cy = _HEIGHT \ 2
    IF PropertyGrid_Value$(ShapeFrame, "filled") <> "0" THEN t = s \ 2
    FOR i = 0 TO t - 1
        SELECT CASE VAL(PropertyGrid_Value$(ShapeFrame, "shape"))
            CASE 1: CIRCLE (cx, cy), s \ 2 - i, c
            CASE 2: LINE (cx - s \ 2 + i, cy - s \ 2 + i)-(cx + s \ 2 - i, cy + s \ 2 - i), c, B
            CASE 3
                LINE (cx, cy - s \ 2 + i)-(cx + s \ 2 - i, cy + s \ 2 - i), c
                LINE -(cx - s \ 2 + i, cy + s \ 2 - i), c
                LINE -(cx, cy - s \ 2 + i), c
        END SELECT
    NEXT
    COLOR _RGB32(40, 40, 40), _RGBA32(0, 0, 0, 0)
    _PRINTSTRING (cx - _PRINTWIDTH(label) \ 2, _HEIGHT - 24), label
    EndDraw Canvas
END SUB

': Event procedures: ---------------------------------------------------------------
SUB __UI_BeforeInit
END SUB

SUB __UI_OnLoad
    'Rows are stacked in the order they're added
    PropertyGrid_SetLayout ShapeFrame, 10, 10, 26, 80
    PropertyGrid_AddText ShapeFrame, "label", "Label"
    PropertyGrid_AddChoice ShapeFrame, "shape", "Shape", "Circle|Square|Triangle"
    PropertyGrid_AddInteger ShapeFrame, "size", "Size"
    PropertyGrid_AddChoice ShapeFrame, "color", "Color", "Red|Green|Blue|Orange"
    PropertyGrid_AddToggle ShapeFrame, "filled", "Filled"
    PropertyGrid_AddInteger ShapeFrame, "outline", "Outline"
    PropertyGrid_AddButton ShapeFrame, "reset", "Defaults", "Reset"
    ToolTip(PropertyGrid_Control(ShapeFrame, "size")) = "From 10 to 200"

    ResetShape
    DrawShape
END SUB

SUB __UI_BeforeUpdateDisplay
END SUB

SUB __UI_BeforeUnload
END SUB

SUB __UI_Click (id AS LONG)
    IF PropertyGrid_RowOf$(id) = "reset" THEN
        ResetShape
        DrawShape
        SetCaption StatusLB, "Back to the defaults."
    END IF
END SUB

SUB __UI_MouseEnter (id AS LONG)
    id = id
END SUB

SUB __UI_MouseLeave (id AS LONG)
    id = id
END SUB

SUB __UI_FocusIn (id AS LONG)
    id = id
END SUB

SUB __UI_FocusOut (id AS LONG)
    id = id
END SUB

SUB __UI_MouseDown (id AS LONG)
    id = id
END SUB

SUB __UI_MouseUp (id AS LONG)
    id = id
END SUB

SUB __UI_KeyPress (id AS LONG)
    id = id
END SUB

SUB __UI_TextChanged (id AS LONG)
    id = id
END SUB

SUB __UI_ValueChanged (id AS LONG)
    DIM n AS LONG
    SELECT CASE id
        CASE ShapeFrame
            SELECT CASE PropertyGrid_ChangedRow$(ShapeFrame)
                CASE "size"
                    'Keep the size in range. While the box still has focus, its red border
                    'shows that the value typed was not taken; Esc shows the one that was.
                    n = VAL(PropertyGrid_Value$(ShapeFrame, "size"))
                    IF n < 10 OR n > 200 THEN
                        IF n < 10 THEN n = 10 ELSE n = 200
                        PropertyGrid_SetValue ShapeFrame, "size", LTRIM$(STR$(n))
                        SetCaption StatusLB, "Size must be from 10 to 200; it was set to" + STR$(n) + "."
                    ELSE
                        SetCaption StatusLB, "Size changed."
                    END IF
                CASE "outline"
                    n = VAL(PropertyGrid_Value$(ShapeFrame, "outline"))
                    IF n < 1 THEN PropertyGrid_SetValue ShapeFrame, "outline", "1"
                CASE "filled"
                    'The outline width only matters when the shape isn't filled
                    PropertyGrid_ShowRow ShapeFrame, "outline", PropertyGrid_Value$(ShapeFrame, "filled") = "0"
                CASE ELSE
                    SetCaption StatusLB, "Changed: " + PropertyGrid_ChangedRow$(ShapeFrame)
            END SELECT
            DrawShape
    END SELECT
END SUB

SUB __UI_FormResized
END SUB

'$INCLUDE:'../../InForm/InForm.ui'
