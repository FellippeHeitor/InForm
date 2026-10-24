'-----------------------------------------------------------------------------------------------------------------------
' InForm-PE Theme Editor
' Creates and edits theme files (.uitheme.ini) with a live preview.
' Copyright (c) 2026 Fellippe Heitor
'-----------------------------------------------------------------------------------------------------------------------

OPTION _EXPLICIT

$EXEICON:'./resources/InForm.ico'

': Controls' IDs: ------------------------------------------------------------------
DIM SHARED ThemeEditorForm AS LONG
DIM SHARED NameLB AS LONG
DIM SHARED NameTB AS LONG
DIM SHARED BaseLB AS LONG
DIM SHARED BaseDD AS LONG
DIM SHARED StyleLB AS LONG
DIM SHARED StyleDD AS LONG
DIM SHARED ColorsLB AS LONG
DIM SHARED RolesLB AS LONG
DIM SHARED HexLB AS LONG
DIM SHARED HexTB AS LONG
DIM SHARED SwatchLB AS LONG
DIM SHARED RLB AS LONG
DIM SHARED RTB AS LONG
DIM SHARED RValLB AS LONG
DIM SHARED GLB AS LONG
DIM SHARED GTB AS LONG
DIM SHARED GValLB AS LONG
DIM SHARED BLB AS LONG
DIM SHARED BTB AS LONG
DIM SHARED BValLB AS LONG
DIM SHARED RadiusLB AS LONG
DIM SHARED RadiusTB AS LONG
DIM SHARED RadiusValLB AS LONG
DIM SHARED ScrollLB AS LONG
DIM SHARED ScrollTB AS LONG
DIM SHARED ScrollValLB AS LONG
DIM SHARED PreviewLB AS LONG
DIM SHARED PvPrimaryBT AS LONG
DIM SHARED PvButtonBT AS LONG
DIM SHARED PvDisabledBT AS LONG
DIM SHARED PvCheckedCB AS LONG
DIM SHARED PvUncheckedCB AS LONG
DIM SHARED PvDisabledCB AS LONG
DIM SHARED PvFrame AS LONG
DIM SHARED PvTabs AS LONG
DIM SHARED PvRadio1RB AS LONG
DIM SHARED PvRadio2RB AS LONG
DIM SHARED PvToggleOnTS AS LONG
DIM SHARED PvToggleOffTS AS LONG
DIM SHARED PvTabCB AS LONG
DIM SHARED PvTabBT AS LONG
DIM SHARED PvTab2LB AS LONG
DIM SHARED PvTab3LB AS LONG
DIM SHARED PvTextTB AS LONG
DIM SHARED PvDropDD AS LONG
DIM SHARED PvDisabledLB AS LONG
DIM SHARED PvListLB AS LONG
DIM SHARED PvProgressPB AS LONG
DIM SHARED PvSliderTB AS LONG
DIM SHARED FileLB AS LONG
DIM SHARED NewBT AS LONG
DIM SHARED OpenBT AS LONG
DIM SHARED SaveBT AS LONG
DIM SHARED SaveAsBT AS LONG

': Editor state: -------------------------------------------------------------------
DIM SHARED CurrentFile AS STRING ' theme file being edited ("" = not saved yet)
DIM SHARED CurrentBase AS STRING ' built-in theme the file inherits from (xp, light or dark)
DIM SHARED CurrentRole AS LONG ' palette role selected in the list
DIM SHARED Modified AS _BYTE
DIM SHARED FileOnDisk AS STRING ' contents of CurrentFile when it was last opened or saved

': External modules: ---------------------------------------------------------------
'$INCLUDE:'InForm.bi'
'$INCLUDE:'ThemeEditor.frm'

': Helpers: ------------------------------------------------------------------------

''' @brief Color as RRGGBB, or RRGGBBAA when it isn't opaque.
FUNCTION ColorToHex$ (c AS _UNSIGNED LONG)
    DIM h AS STRING
    h = RIGHT$("00000000" + HEX$(c), 8) ' AARRGGBB
    IF LEFT$(h, 2) = "FF" THEN ColorToHex = MID$(h, 3) ELSE ColorToHex = MID$(h, 3) + LEFT$(h, 2)
END FUNCTION

''' @brief Built-in theme name for an item of the Base dropdown, and back.
FUNCTION BaseFromIndex$ (index AS LONG)
    SELECT CASE index
        CASE 1: BaseFromIndex = "xp"
        CASE 3: BaseFromIndex = "dark"
        CASE ELSE: BaseFromIndex = "light"
    END SELECT
END FUNCTION

FUNCTION IndexFromBase& (baseName AS STRING)
    SELECT CASE LCASE$(baseName)
        CASE "xp", "classic": IndexFromBase = 1
        CASE "dark": IndexFromBase = 3
        CASE ELSE: IndexFromBase = 2
    END SELECT
END FUNCTION

''' @brief Reads the palette and metrics of a built-in theme without changing the current one.
SUB GetBuiltinTheme (baseName AS STRING, colors() AS _UNSIGNED LONG, metrics AS __UI_ThemeTYPE)
    DIM savedTheme AS __UI_ThemeTYPE, savedColors(1 TO __UI_ThemeColor_Count) AS _UNSIGNED LONG
    DIM savedImages(1 TO __UI_ThemeImage_Count) AS STRING, i AS LONG

    savedTheme = __UI_Theme
    FOR i = 1 TO __UI_ThemeColor_Count: savedColors(i) = __UI_ThemeColor(i): NEXT
    FOR i = 1 TO __UI_ThemeImage_Count: savedImages(i) = __UI_ThemeImageFile(i): NEXT

    IF __UI_Theme_LoadBuiltin(baseName) THEN
        metrics = __UI_Theme
        FOR i = 1 TO __UI_ThemeColor_Count: colors(i) = __UI_ThemeColor(i): NEXT
    END IF

    __UI_Theme = savedTheme
    FOR i = 1 TO __UI_ThemeColor_Count: __UI_ThemeColor(i) = savedColors(i): NEXT
    FOR i = 1 TO __UI_ThemeImage_Count: __UI_ThemeImageFile(i) = savedImages(i): NEXT
END SUB

SUB UpdateTitle
    DIM t AS STRING
    IF LEN(CurrentFile) THEN t = CurrentFile ELSE t = "(not saved)"
    SetCaption FileLB, "File: " + t
    t = "Theme Editor - " + RTRIM$(__UI_Theme.Name)
    IF Modified THEN t = t + " *"
    SetCaption ThemeEditorForm, t
END SUB

SUB MarkModified
    Modified = True
    UpdateTitle
END SUB

''' @brief Shows a color in the picker (sliders, hex field and swatch).
SUB ShowColor (c AS _UNSIGNED LONG)
    Control(RTB).Value = _RED32(c)
    Control(GTB).Value = _GREEN32(c)
    Control(BTB).Value = _BLUE32(c)
    SetCaption RValLB, LTRIM$(STR$(_RED32(c)))
    SetCaption GValLB, LTRIM$(STR$(_GREEN32(c)))
    SetCaption BValLB, LTRIM$(STR$(_BLUE32(c)))
    Text(HexTB) = ColorToHex(c)
    Control(HexTB).Cursor = LEN(Text(HexTB))
    Control(SwatchLB).BackColor = _RGB32(_RED32(c), _GREEN32(c), _BLUE32(c))
    SetCaption SwatchLB, ""
    Control(SwatchLB).Redraw = True
END SUB

''' @brief Loads the selected role's color into the picker.
SUB ShowCurrentRole
    DIM c AS _UNSIGNED LONG
    c = GetThemeColor(CurrentRole)
    IF c = 0 _ANDALSO CurrentRole = __UI_ThemeColor_DisabledText THEN
        ' XP derives this color from the form color; show what is used
        ShowColor __UI_DisabledColor
        Text(HexTB) = ""
        SetCaption SwatchLB, "  automatic"
    ELSE
        ShowColor c
    END IF
END SUB

''' @brief Applies a new color to the selected role (no-op when it is already that color).
SUB ApplyColor (c AS _UNSIGNED LONG)
    IF CurrentRole < 1 THEN EXIT SUB
    IF c = GetThemeColor(CurrentRole) THEN EXIT SUB
    SetThemeColor CurrentRole, c
    ShowColor c
    MarkModified
END SUB

''' @brief Refreshes every editor field from the current theme.
SUB RefreshAll
    Text(NameTB) = RTRIM$(__UI_Theme.Name)
    Control(BaseDD).Value = IndexFromBase(CurrentBase)
    IF __UI_Theme.Style = __UI_ThemeStyle_Flat THEN Control(StyleDD).Value = 2 ELSE Control(StyleDD).Value = 1
    Control(RadiusTB).Value = __UI_Theme.CornerRadius
    SetCaption RadiusValLB, LTRIM$(STR$(__UI_Theme.CornerRadius))
    Control(ScrollTB).Value = __UI_Theme.ScrollbarWidth
    SetCaption ScrollValLB, LTRIM$(STR$(__UI_Theme.ScrollbarWidth))
    IF CurrentRole < 1 THEN CurrentRole = 1
    Control(RolesLB).Value = CurrentRole
    ShowCurrentRole
    UpdateTitle
END SUB

''' @brief Redraws everything after a metric or style change.
SUB ThemeMetricsChanged
    DIM i AS LONG
    __UI_Theme_ApplyMetrics
    __UI_Theme_FreeImages
    FOR i = 1 TO UBOUND(Control)
        Control(i).Redraw = True
    NEXT
    __UI_ForceRedraw = True
END SUB

SUB NewTheme (baseName AS STRING)
    SetTheme baseName
    CurrentBase = baseName
    CurrentFile = ""
    FileOnDisk = ""
    __UI_Theme.Name = "My theme"
    Modified = False
    RefreshAll
END SUB

SUB OpenThemeFile (fileName AS STRING)
    DIM b AS STRING
    SetTheme fileName
    IF GetTheme$ <> fileName THEN
        MessageBox "Could not load the theme file:\n" + fileName, "Theme Editor", MsgBox_OkOnly + MsgBox_Exclamation
        EXIT SUB
    END IF
    b = LCASE$(_TRIM$(Ini_ReadSetting(fileName, "Theme", "Base")))
    Ini_Release fileName
    IF LEN(b) = 0 THEN
        IF __UI_Theme.Style = __UI_ThemeStyle_Flat THEN b = "light" ELSE b = "xp"
    END IF
    CurrentBase = b
    CurrentFile = fileName
    FileOnDisk = __UI_Theme_ReadFile(fileName)
    Modified = False
    RefreshAll
END SUB

''' @brief Writes the theme. Only values that differ from the base theme are saved, so the file
''' keeps inheriting everything else.
SUB SaveThemeFile (fileName AS STRING)
    DIM baseColors(1 TO __UI_ThemeColor_Count) AS _UNSIGNED LONG, baseTheme AS __UI_ThemeTYPE
    DIM f AS LONG, i AS LONG, themeDir AS STRING, p AS LONG, imageFile AS STRING, imagesHeader AS _BYTE

    GetBuiltinTheme CurrentBase, baseColors(), baseTheme

    f = FREEFILE
    OPEN fileName FOR OUTPUT AS #f
    PRINT #f, "; InForm-PE theme file, made with the Theme Editor"
    PRINT #f, "; Values left out are inherited from the Base theme."
    PRINT #f,
    PRINT #f, "[Theme]"
    PRINT #f, "Name=" + RTRIM$(__UI_Theme.Name)
    PRINT #f, "Base=" + CurrentBase
    IF __UI_Theme.Style = __UI_ThemeStyle_Flat THEN PRINT #f, "Style=flat" ELSE PRINT #f, "Style=bitmap"

    PRINT #f,
    PRINT #f, "[Colors]"
    FOR i = 1 TO __UI_ThemeColor_Count
        IF __UI_ThemeColor(i) <> baseColors(i) _ANDALSO __UI_ThemeColor(i) <> 0 THEN
            PRINT #f, __UI_Theme_ItemAt(__UI_ThemeColorNames, i) + "=" + ColorToHex(__UI_ThemeColor(i))
        END IF
    NEXT

    PRINT #f,
    PRINT #f, "[Metrics]"
    IF __UI_Theme.CornerRadius <> baseTheme.CornerRadius THEN PRINT #f, "CornerRadius=" + LTRIM$(STR$(__UI_Theme.CornerRadius))
    IF __UI_Theme.ScrollbarWidth <> baseTheme.ScrollbarWidth THEN PRINT #f, "ScrollbarWidth=" + LTRIM$(STR$(__UI_Theme.ScrollbarWidth))
    IF __UI_Theme.ScrollbarButtonHeight <> baseTheme.ScrollbarButtonHeight THEN PRINT #f, "ScrollbarButtonHeight=" + LTRIM$(STR$(__UI_Theme.ScrollbarButtonHeight))
    IF __UI_Theme.MenuBarOffset <> baseTheme.MenuBarOffset THEN PRINT #f, "MenuBarOffset=" + LTRIM$(STR$(__UI_Theme.MenuBarOffset))
    IF __UI_Theme.MenuItemOffset <> baseTheme.MenuItemOffset THEN PRINT #f, "MenuItemOffset=" + LTRIM$(STR$(__UI_Theme.MenuItemOffset))
    IF __UI_Theme.DefaultCaptionIndent <> baseTheme.DefaultCaptionIndent THEN PRINT #f, "DefaultCaptionIndent=" + LTRIM$(STR$(__UI_Theme.DefaultCaptionIndent))

    ' Keep custom images of bitmap themes, relative to the new file when possible
    p = _INSTRREV(fileName, "/"): IF _INSTRREV(fileName, "\") > p THEN p = _INSTRREV(fileName, "\")
    IF p THEN themeDir = LEFT$(fileName, p)
    FOR i = 1 TO __UI_ThemeImage_Count
        imageFile = __UI_ThemeImageFile(i)
        IF LEN(imageFile) THEN
            IF NOT imagesHeader THEN
                PRINT #f,
                PRINT #f, "[Images]"
                imagesHeader = True
            END IF
            IF LEN(themeDir) _ANDALSO LEFT$(imageFile, LEN(themeDir)) = themeDir THEN imageFile = MID$(imageFile, LEN(themeDir) + 1)
            PRINT #f, __UI_Theme_ItemAt(__UI_ThemeImageNames, i) + "=" + imageFile
        END IF
    NEXT
    CLOSE #f

    CurrentFile = fileName
    FileOnDisk = __UI_Theme_ReadFile(fileName)
    __UI_Theme.Source = fileName
    Modified = False
    UpdateTitle
END SUB

SUB SaveAs
    DIM f AS STRING
    f = _SAVEFILEDIALOG$("Save theme", "my-theme.uitheme.ini", "*.ini|*.INI", "InForm theme files")
    IF LEN(f) THEN SaveThemeFile f
END SUB

''' @brief Asks to save pending changes. Returns _FALSE if the user cancelled.
FUNCTION ConfirmDiscard%%
    DIM answer AS LONG
    ConfirmDiscard = True
    IF NOT Modified THEN EXIT FUNCTION
    answer = MessageBox("Save changes to " + RTRIM$(__UI_Theme.Name) + "?", "Theme Editor", MsgBox_YesNoCancel + MsgBox_Question)
    IF answer = MsgBox_Cancel THEN
        ConfirmDiscard = False
    ELSEIF answer = MsgBox_Yes THEN
        IF LEN(CurrentFile) THEN SaveThemeFile CurrentFile ELSE SaveAs
        ConfirmDiscard = NOT Modified
    END IF
END FUNCTION

''' @brief Reloads the open theme file when another program changes it (checked once per second).
''' Asks first when there are unsaved changes.
SUB CheckFileOnDisk
    STATIC lastCheck AS DOUBLE
    DIM content AS STRING, answer AS LONG

    IF LEN(CurrentFile) = 0 THEN EXIT SUB
    IF ABS(TIMER(.001) - lastCheck) < 1 THEN EXIT SUB
    lastCheck = TIMER(.001)
    IF NOT _FILEEXISTS(CurrentFile) THEN EXIT SUB

    content = __UI_Theme_ReadFile(CurrentFile)
    IF content = FileOnDisk THEN EXIT SUB
    FileOnDisk = content ' don't ask again for this version

    IF Modified THEN
        answer = MessageBox("The theme file was changed by another program.\n\nReload it and lose your changes?", "Theme Editor", MsgBox_YesNo + MsgBox_Question)
        IF answer <> MsgBox_Yes THEN EXIT SUB
    END IF
    OpenThemeFile CurrentFile
END SUB

': Event procedures: ---------------------------------------------------------------
SUB __UI_BeforeInit
END SUB

SUB __UI_OnLoad
    DIM i AS LONG
    FOR i = 1 TO __UI_ThemeColor_Count
        AddItem RolesLB, __UI_Theme_ItemAt(__UI_ThemeColorNames, i)
    NEXT
    FOR i = 1 TO 20
        AddItem PvListLB, "List item" + STR$(i)
    NEXT
    Text(PvTextTB) = "Editable text"

    IF _COMMANDCOUNT > 0 _ANDALSO _FILEEXISTS(COMMAND$(1)) THEN
        OpenThemeFile COMMAND$(1)
    ELSE
        NewTheme "light"
    END IF
END SUB

SUB __UI_BeforeUpdateDisplay
    CheckFileOnDisk
END SUB

SUB __UI_BeforeUnload
    IF NOT ConfirmDiscard THEN __UI_UnloadSignal = False
END SUB

SUB __UI_Click (id AS LONG)
    DIM f AS STRING
    SELECT CASE id
        CASE NewBT
            IF ConfirmDiscard THEN NewTheme BaseFromIndex(Control(BaseDD).Value)
        CASE OpenBT
            IF ConfirmDiscard THEN
                f = _OPENFILEDIALOG$("Open theme", "", "*.ini|*.INI", "InForm theme files")
                IF LEN(f) THEN OpenThemeFile f
            END IF
        CASE SaveBT
            IF LEN(CurrentFile) THEN SaveThemeFile CurrentFile ELSE SaveAs
        CASE SaveAsBT
            SaveAs
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
    ' Show the normalized value when leaving the hex field
    IF id = HexTB THEN ShowCurrentRole
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
    DIM c AS _UNSIGNED LONG
    SELECT CASE id
        CASE HexTB
            IF __UI_Theme_ParseColor(Text(HexTB), c) THEN
                IF CurrentRole > 0 _ANDALSO c <> GetThemeColor(CurrentRole) THEN
                    SetThemeColor CurrentRole, c
                    Control(RTB).Value = _RED32(c): Control(GTB).Value = _GREEN32(c): Control(BTB).Value = _BLUE32(c)
                    SetCaption RValLB, LTRIM$(STR$(_RED32(c)))
                    SetCaption GValLB, LTRIM$(STR$(_GREEN32(c)))
                    SetCaption BValLB, LTRIM$(STR$(_BLUE32(c)))
                    Control(SwatchLB).BackColor = _RGB32(_RED32(c), _GREEN32(c), _BLUE32(c))
                    SetCaption SwatchLB, ""
                    MarkModified
                END IF
            END IF
        CASE NameTB
            IF Text(NameTB) <> RTRIM$(__UI_Theme.Name) THEN
                __UI_Theme.Name = Text(NameTB)
                MarkModified
            END IF
    END SELECT
END SUB

SUB __UI_ValueChanged (id AS LONG)
    DIM c AS _UNSIGNED LONG, newBase AS STRING, keepName AS STRING, newStyle AS _BYTE
    SELECT CASE id
        CASE RolesLB
            IF Control(RolesLB).Value > 0 _ANDALSO Control(RolesLB).Value <> CurrentRole THEN
                CurrentRole = Control(RolesLB).Value
                ShowCurrentRole
            END IF

        CASE RTB, GTB, BTB
            ' Slider changes also arrive after the picker is filled in code; ApplyColor ignores those
            c = _RGB32(Control(RTB).Value, Control(GTB).Value, Control(BTB).Value)
            SetCaption RValLB, LTRIM$(STR$(Control(RTB).Value))
            SetCaption GValLB, LTRIM$(STR$(Control(GTB).Value))
            SetCaption BValLB, LTRIM$(STR$(Control(BTB).Value))
            IF CurrentRole = __UI_ThemeColor_DisabledText _ANDALSO GetThemeColor(CurrentRole) = 0 _ANDALSO c = __UI_DisabledColor THEN EXIT SUB
            ApplyColor c

        CASE BaseDD
            newBase = BaseFromIndex(Control(BaseDD).Value)
            IF newBase <> CurrentBase THEN
                ' Starting over from another base theme; the name is kept
                keepName = RTRIM$(__UI_Theme.Name)
                SetTheme newBase
                __UI_Theme.Name = keepName
                CurrentBase = newBase
                MarkModified
                RefreshAll
            END IF

        CASE StyleDD
            IF Control(StyleDD).Value = 2 THEN newStyle = __UI_ThemeStyle_Flat ELSE newStyle = __UI_ThemeStyle_Bitmap
            IF newStyle <> __UI_Theme.Style THEN
                __UI_Theme.Style = newStyle
                ThemeMetricsChanged
                MarkModified
            END IF

        CASE RadiusTB
            SetCaption RadiusValLB, LTRIM$(STR$(Control(RadiusTB).Value))
            IF Control(RadiusTB).Value <> __UI_Theme.CornerRadius THEN
                __UI_Theme.CornerRadius = Control(RadiusTB).Value
                ThemeMetricsChanged
                MarkModified
            END IF

        CASE ScrollTB
            SetCaption ScrollValLB, LTRIM$(STR$(Control(ScrollTB).Value))
            IF Control(ScrollTB).Value <> __UI_Theme.ScrollbarWidth THEN
                __UI_Theme.ScrollbarWidth = Control(ScrollTB).Value
                __UI_Theme.ScrollbarButtonHeight = Control(ScrollTB).Value
                ThemeMetricsChanged
                MarkModified
            END IF

        CASE PvSliderTB
            Control(PvProgressPB).Value = Control(PvSliderTB).Value * 10
    END SELECT
END SUB

SUB __UI_FormResized
END SUB

'$INCLUDE:'InForm.ui'
