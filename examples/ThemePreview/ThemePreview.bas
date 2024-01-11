': This program uses
': InForm - GUI library for QB64 - Beta version 9
': Fellippe Heitor, 2016-2019 - fellippe@qb64.org - @fellippeheitor
': https://github.com/FellippeHeitor/InForm
'-----------------------------------------------------------

': Controls' IDs: ------------------------------------------------------------------
DIM SHARED ThemeImagePreview AS LONG
DIM SHARED FileLB AS LONG
DIM SHARED DropdownList1 AS LONG
DIM SHARED PictureBox1 AS LONG
DIM SHARED ContextMenu1 AS LONG
DIM SHARED ContextMenu1Copy AS LONG

': External modules: ---------------------------------------------------------------
'$INCLUDE:'../../InForm/InForm.bi'
'$INCLUDE:'ThemePreview.frm'
'$INCLUDE:'../../InForm/InForm.ui'

FUNCTION GetThemeImageId~%% (fileName AS STRING)
    SELECT CASE LCASE$(fileName)
        CASE "scrollhbuttons.bmp"
            GetThemeImageId = __INFORM_THEME_IMAGE_SCROLLHBUTTONS
        CASE "scrollhthumb.bmp"
            GetThemeImageId = __INFORM_THEME_IMAGE_SCROLLHTHUMB
        CASE "scrollhtrack.bmp"
            GetThemeImageId = __INFORM_THEME_IMAGE_SCROLLHTRACK
        CASE "menucheckmark.bmp"
            GetThemeImageId = __INFORM_THEME_IMAGE_MENUCHECKMARK
        CASE "slidertrack.png"
            GetThemeImageId = __INFORM_THEME_IMAGE_SLIDERTRACK
        CASE "frame.png"
            GetThemeImageId = __INFORM_THEME_IMAGE_FRAME
        CASE "arrows.png"
            GetThemeImageId = __INFORM_THEME_IMAGE_ARROWS
        CASE "scrolltrack.png"
            GetThemeImageId = __INFORM_THEME_IMAGE_SCROLLTRACK
        CASE "scrollthumb.png"
            GetThemeImageId = __INFORM_THEME_IMAGE_SCROLLTHUMB
        CASE "scrollbuttons.png"
            GetThemeImageId = __INFORM_THEME_IMAGE_SCROLLBUTTONS
        CASE "radiobutton.png"
            GetThemeImageId = __INFORM_THEME_IMAGE_RADIOBUTTON
        CASE "progresstrack.png"
            GetThemeImageId = __INFORM_THEME_IMAGE_PROGRESSTRACK
        CASE "progresschunk.png"
            GetThemeImageId = __INFORM_THEME_IMAGE_PROGRESSCHUNK
        CASE "button.png"
            GetThemeImageId = __INFORM_THEME_IMAGE_BUTTON
        CASE "checkbox.png"
            GetThemeImageId = __INFORM_THEME_IMAGE_CHECKBOX
        CASE "notfound.png"
            GetThemeImageId = __INFORM_THEME_IMAGE_NOTFOUND
        CASE "sliderdown.png"
            GetThemeImageId = __INFORM_THEME_IMAGE_SLIDERDOWN
        CASE ELSE
            ERROR 5
    END SELECT
END FUNCTION

': Event procedures: ---------------------------------------------------------------

SUB __UI_BeforeInit

END SUB

SUB __UI_OnLoad

END SUB

SUB __UI_BeforeUpdateDisplay
    'This event occurs at approximately 30 frames per second.
    'You can change the update frequency by calling SetFrameRate DesiredRate%

END SUB

SUB __UI_BeforeUnload
    'If you set __UI_UnloadSignal = False here you can
    'cancel the user's request to close.

END SUB

SUB __UI_Click (id AS LONG)
    SELECT CASE id
        CASE ThemeImagePreview

        CASE FileLB

        CASE DropdownList1

        CASE PictureBox1

        CASE ContextMenu1Copy
            _CLIPBOARDIMAGE = Control(PictureBox1).HelperCanvas
    END SELECT
END SUB

SUB __UI_MouseEnter (id AS LONG)
    SELECT CASE id
        CASE ThemeImagePreview

        CASE FileLB

        CASE DropdownList1

        CASE PictureBox1

        CASE ContextMenu1Copy

    END SELECT
END SUB

SUB __UI_MouseLeave (id AS LONG)
    SELECT CASE id
        CASE ThemeImagePreview

        CASE FileLB

        CASE DropdownList1

        CASE PictureBox1

        CASE ContextMenu1Copy

    END SELECT
END SUB

SUB __UI_FocusIn (id AS LONG)
    SELECT CASE id
        CASE DropdownList1

    END SELECT
END SUB

SUB __UI_FocusOut (id AS LONG)
    'This event occurs right before a control loses focus.
    'To prevent a control from losing focus, set __UI_KeepFocus = True below.
    SELECT CASE id
        CASE DropdownList1

    END SELECT
END SUB

SUB __UI_MouseDown (id AS LONG)
    SELECT CASE id
        CASE ThemeImagePreview

        CASE FileLB

        CASE DropdownList1

        CASE PictureBox1

        CASE ContextMenu1Copy

    END SELECT
END SUB

SUB __UI_MouseUp (id AS LONG)
    SELECT CASE id
        CASE ThemeImagePreview

        CASE FileLB

        CASE DropdownList1

        CASE PictureBox1

        CASE ContextMenu1Copy

    END SELECT
END SUB

SUB __UI_KeyPress (id AS LONG)
    'When this event is fired, __UI_KeyHit will contain the code of the key hit.
    'You can change it and even cancel it by making it = 0
    SELECT CASE id
        CASE DropdownList1

    END SELECT
END SUB

SUB __UI_TextChanged (id AS LONG)
    SELECT CASE id
        CASE ELSE
    END SELECT
END SUB

SUB __UI_ValueChanged (id AS LONG)
    SELECT CASE id
        CASE DropdownList1
            _FREEIMAGE Control(PictureBox1).HelperCanvas
            Control(PictureBox1).HelperCanvas = _COPYIMAGE(__UI_LoadThemeImage(GetThemeImageId(GetItem$(DropdownList1, Control(DropdownList1).Value))))
            Control(PictureBox1).Redraw = TRUE
    END SELECT
END SUB

SUB __UI_FormResized

END SUB
