': Theme gallery: almost every InForm-PE control, in several states, with a theme switcher.
': https://github.com/QB64-Phoenix-Edition/InForm-PE
'-----------------------------------------------------------

OPTION _EXPLICIT

': Controls' IDs: ------------------------------------------------------------------
DIM SHARED ThemeGallery AS LONG
DIM SHARED Btn1 AS LONG
DIM SHARED Btn2 AS LONG
DIM SHARED Btn3 AS LONG
DIM SHARED Chk1 AS LONG
DIM SHARED Chk2 AS LONG
DIM SHARED Chk3 AS LONG
DIM SHARED Frame1 AS LONG
DIM SHARED Rad1 AS LONG
DIM SHARED Rad2 AS LONG
DIM SHARED Tog1 AS LONG
DIM SHARED Tog2 AS LONG
DIM SHARED Lbl1 AS LONG
DIM SHARED Text1 AS LONG
DIM SHARED Drop1 AS LONG
DIM SHARED Prog1 AS LONG
DIM SHARED List1 AS LONG
DIM SHARED Track1 AS LONG
DIM SHARED Track2 AS LONG
DIM SHARED Tabs1 AS LONG
DIM SHARED TabChk1 AS LONG
DIM SHARED TabBtn1 AS LONG
DIM SHARED TabLbl2 AS LONG
DIM SHARED TabLblAll AS LONG
DIM SHARED ThemeLB AS LONG
DIM SHARED ThemeDD AS LONG

': External modules: ---------------------------------------------------------------
'$INCLUDE:'../../InForm/InForm.bi'
'$INCLUDE:'ThemeGallery.frm'

': Helpers: ------------------------------------------------------------------------
FUNCTION MidnightThemeFile$
    ' The example can be run from the repository root or from its own folder
    IF _FILEEXISTS("InForm/themes/midnight.uitheme.ini") THEN
        MidnightThemeFile = "InForm/themes/midnight.uitheme.ini"
    ELSE
        MidnightThemeFile = "../../InForm/themes/midnight.uitheme.ini"
    END IF
END FUNCTION

': Event procedures: ---------------------------------------------------------------
SUB __UI_BeforeInit
END SUB

SUB __UI_OnLoad
    DIM i AS LONG
    FOR i = 1 TO 20
        AddItem List1, "List item" + STR$(i)
    NEXT
    AddItem Drop1, "Dropdown option"
    AddItem Drop1, "Second option"
    Control(Drop1).Value = 1
    Text(Text1) = "Editable text"
END SUB

SUB __UI_BeforeUpdateDisplay
END SUB

SUB __UI_BeforeUnload
END SUB

SUB __UI_Click (id AS LONG)
    id = id
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
    SELECT CASE id
        CASE ThemeDD
            SELECT CASE Control(ThemeDD).Value
                CASE 1: SetTheme "xp"
                CASE 2: SetTheme "light"
                CASE 3: SetTheme "dark"
                CASE 4: SetTheme MidnightThemeFile
            END SELECT
        CASE Track1
            Control(Prog1).Value = Control(Track1).Value * 10
    END SELECT
END SUB

SUB __UI_FormResized
END SUB

'$INCLUDE:'../../InForm/InForm.ui'
