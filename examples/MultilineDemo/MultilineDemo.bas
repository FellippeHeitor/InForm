': Multiline textbox demo for InForm-PE
': Copyright (c) 2026 Fellippe Heitor
': https://github.com/QB64-Phoenix-Edition/InForm-PE
'-----------------------------------------------------------

OPTION _EXPLICIT

': Controls' IDs: ------------------------------------------------------------------
DIM SHARED MultilineDemo AS LONG
DIM SHARED TitleLB AS LONG
DIM SHARED TitleTB AS LONG
DIM SHARED NotesTB AS LONG
DIM SHARED StatusLB AS LONG
DIM SHARED ClearBT AS LONG
DIM SHARED CloseBT AS LONG

': External modules: ---------------------------------------------------------------
'$INCLUDE:'../../InForm/InForm.bi'
'$INCLUDE:'MultilineDemo.frm'

': Event procedures: ---------------------------------------------------------------
SUB __UI_BeforeInit
END SUB

SUB __UI_OnLoad
    Text(NotesTB) = "Enter starts a new line; long lines wrap at word boundaries." + _CHR_LF + _CHR_LF + _
        "Try the arrow keys, Home/End, Page Up/Down, Shift to select, Ctrl+C/X/V, double-click to select a word, and the mouse wheel." + _CHR_LF + _CHR_LF + _
        "The scrollbar shows up once the text no longer fits."
END SUB

SUB __UI_BeforeUpdateDisplay
    DIM AS LONG lines, lineNumber
    lines = __UI_TBCountLines(NotesTB)
    lineNumber = __UI_TBLineFromPos(NotesTB, Control(NotesTB).Cursor)
    SetCaption StatusLB, "Line" + STR$(lineNumber) + " of" + STR$(lines) + ", " + _TOSTR$(LEN(Text(NotesTB))) + " characters"
END SUB

SUB __UI_BeforeUnload
END SUB

SUB __UI_Click (id AS LONG)
    SELECT CASE id
        CASE ClearBT
            Text(NotesTB) = ""
            Control(NotesTB).Cursor = 0
            Control(NotesTB).TextIsSelected = False
            SetFocus NotesTB
        CASE CloseBT
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
END SUB

'$INCLUDE:'../../InForm/InForm.ui'
