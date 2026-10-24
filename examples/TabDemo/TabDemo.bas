': TabControl and themes demo for InForm-PE
': https://github.com/QB64-Phoenix-Edition/InForm-PE
'-----------------------------------------------------------

OPTION _EXPLICIT

': Controls' IDs: ------------------------------------------------------------------
DIM SHARED TabDemo AS LONG
DIM SHARED MainTabs AS LONG
DIM SHARED NameLB AS LONG
DIM SHARED NameTB AS LONG
DIM SHARED AutoSaveCB AS LONG
DIM SHARED SoundTS AS LONG
DIM SHARED SoundLB AS LONG
DIM SHARED VolumeTB AS LONG
DIM SHARED VolumePB AS LONG
DIM SHARED ThemeXPRB AS LONG
DIM SHARED ThemeLightRB AS LONG
DIM SHARED ThemeDarkRB AS LONG
DIM SHARED ThemeFileRB AS LONG
DIM SHARED AboutLB AS LONG
DIM SHARED StatusLB AS LONG
DIM SHARED CloseBT AS LONG

': External modules: ---------------------------------------------------------------
'$INCLUDE:'../../InForm/InForm.bi'
'$INCLUDE:'TabDemo.frm'

': Helpers: ------------------------------------------------------------------------
FUNCTION MidnightThemeFile$
    ' The demo can be run from the repository root or from its own folder
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
    Text(NameTB) = "InForm-PE"
END SUB

SUB __UI_BeforeUpdateDisplay
END SUB

SUB __UI_BeforeUnload
END SUB

SUB __UI_Click (id AS LONG)
    SELECT CASE id
        CASE CloseBT
            SYSTEM
        CASE ThemeXPRB
            SetTheme "xp"
        CASE ThemeLightRB
            SetTheme "light"
        CASE ThemeDarkRB
            SetTheme "dark"
        CASE ThemeFileRB
            SetTheme MidnightThemeFile
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
    SELECT CASE id
        CASE MainTabs
            SetCaption StatusLB, "Active tab: " + GetTabCaption(MainTabs, Control(MainTabs).Value)
        CASE VolumeTB
            Control(VolumePB).Value = Control(VolumeTB).Value * 10
    END SELECT
END SUB

SUB __UI_FormResized
END SUB

'$INCLUDE:'../../InForm/InForm.ui'
