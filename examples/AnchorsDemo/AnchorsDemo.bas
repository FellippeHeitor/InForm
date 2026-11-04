': Anchors demo for InForm-PE
': Copyright (c) 2026 Fellippe Heitor
': https://github.com/QB64-Phoenix-Edition/InForm-PE
'-----------------------------------------------------------

OPTION _EXPLICIT

': Controls' IDs: ------------------------------------------------------------------
DIM SHARED AnchorsDemo AS LONG
DIM SHARED SubjectLB AS LONG
DIM SHARED SubjectTB AS LONG
DIM SHARED NotesTB AS LONG
DIM SHARED OptionsFR AS LONG
DIM SHARED UrgentCB AS LONG
DIM SHARED PrivateCB AS LONG
DIM SHARED HintLB AS LONG
DIM SHARED StatusLB AS LONG
DIM SHARED OkBT AS LONG
DIM SHARED CancelBT AS LONG

': External modules: ---------------------------------------------------------------
'$INCLUDE:'../../InForm/InForm.bi'
'$INCLUDE:'AnchorsDemo.frm'

': Event procedures: ---------------------------------------------------------------
SUB __UI_BeforeInit
END SUB

SUB __UI_OnLoad
    ShowSize
END SUB

SUB __UI_BeforeUpdateDisplay
END SUB

SUB __UI_BeforeUnload
END SUB

SUB __UI_Click (id AS LONG)
    SELECT CASE id
        CASE OkBT, CancelBT
            SYSTEM
    END SELECT
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
    id = id
END SUB

SUB __UI_FormResized
    'Controls have already been moved by their anchors by now.
    'Keep the form from getting too small; this resizes it again, and the anchors follow.
    IF Control(AnchorsDemo).Width < 400 THEN Control(AnchorsDemo).Width = 400
    IF Control(AnchorsDemo).Height < 260 THEN Control(AnchorsDemo).Height = 260
    ShowSize
END SUB

SUB ShowSize
    SetCaption StatusLB, "Form size:" + STR$(Control(AnchorsDemo).Width) + " x" + STR$(Control(AnchorsDemo).Height)
END SUB

'$INCLUDE:'../../InForm/InForm.ui'
