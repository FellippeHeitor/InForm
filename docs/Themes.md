# Themes

InForm-PE draws every control using the current **theme**: a palette of colors, a few metrics (scroll bar width, corner radius, ...) and a drawing style.

There are two drawing styles:

- **Bitmap**: controls are drawn from small images. This is the classic Windows XP look and the default.
- **Flat**: controls are drawn from the palette, with antialiased rounded corners. Any color can be changed, so this style supports dark themes and custom accent colors. The default button is filled with the accent color, text fields show an accent bar when focused, and tabs use a minimal style with an accent marker under the active tab.

## Built-in themes

| Name    | Style  | Description                                  |
|---------|--------|----------------------------------------------|
| `xp`    | Bitmap | The classic look. Used when no theme is set. |
| `light` | Flat   | Light gray window, blue accent.              |
| `dark`  | Flat   | Dark gray window, blue accent.               |

## Choosing a theme

In the designer, use **View > Theme**. The choice is saved in the `.frm` file as a `SetTheme` line right after the form is created:

```vb
__UI_NewID = __UI_NewControl(__UI_Type_Form, "MyForm", 400, 300, 0, 0, 0)
SetTheme "dark"
```

You can also switch themes at run time, for example from a menu or a button:

```vb
SUB __UI_Click (id AS LONG)
    SELECT CASE id
        CASE DarkModeBT
            SetTheme "dark"
        CASE LightModeBT
            SetTheme "light"
    END SELECT
END SUB
```

Controls whose colors you never changed follow the new theme. Colors you set yourself (in the designer or in code) are kept.

If a theme can't be loaded (for example, a missing file), the current theme stays active.

## Theme Editor

`ThemeEditor` (built next to `UiEditor` by the setup scripts) creates and edits theme files with a live preview:

- Pick a base theme and style, then select a color role and change it with the R/G/B sliders or a hex value.
- Adjust the corner radius and the scroll bar width.
- The whole window, including a panel with every control type, shows the theme as you edit it.
- **Save** writes only the values that differ from the base theme, so the file keeps inheriting the rest.

You can also open a theme directly: `ThemeEditor my-theme.uitheme.ini`.

## Theme files

A theme file is an INI file. Every value is optional: anything left out is inherited from the built-in theme named by `Base`.

```ini
[Theme]
Name=Midnight
Base=dark      ; xp, light or dark (defaults to light for Style=flat, xp otherwise)
Style=flat     ; flat or bitmap

[Colors]
WindowBack=141826
Accent=7C5CFF
FocusRing=B7A6FF

[Metrics]
CornerRadius=6
ScrollbarWidth=12
ScrollbarButtonHeight=12

[Images]       ; bitmap style only; paths are relative to the theme file
Button=my-button.png
```

Load it with its path:

```vb
SetTheme "themes/midnight.uitheme.ini"
```

A complete example is in [`InForm/themes/midnight.uitheme.ini`](../InForm/themes/midnight.uitheme.ini).

### Colors

Colors can be written as `RRGGBB`, `RRGGBBAA` or `R,G,B[,A]`. In INI files `#` starts a comment, so if you prefer `#RRGGBB` put it in quotes: `Accent="#7C5CFF"`.

| Role           | Used for                                                                |
|----------------|-------------------------------------------------------------------------|
| `WindowBack`   | Form and default control background                                     |
| `WindowText`   | Default text color                                                      |
| `InputBack`    | Text boxes, list boxes, drop-down lists, check boxes and radio buttons |
| `InputText`    | Text inside input controls                                              |
| `ButtonFace`   | Button surface (flat style)                                             |
| `ButtonText`   | Button captions                                                         |
| `SelectedBack` | Selected items and text; checked boxes, progress and toggle fill        |
| `SelectedText` | Text on top of `SelectedBack`                                           |
| `Border`       | Control borders                                                         |
| `Accent`       | Default button outline, active tab marker, hovered boxes, track bars    |
| `AccentText`   | Text and check marks on top of `Accent`                                 |
| `FocusRing`    | Keyboard focus outline                                                  |
| `Caret`        | Text cursor                                                             |
| `DisabledText` | Captions of disabled controls                                           |
| `TipBack`      | Tool tip background                                                     |
| `TipText`      | Tool tip text                                                           |
| `MenuBack`     | Menu panels                                                             |
| `TrackBack`    | Empty part of scroll bars, progress bars and track bars                 |

### Metrics

| Key                     | Meaning                                    |
|-------------------------|--------------------------------------------|
| `ScrollbarWidth`        | Width of vertical scroll bars              |
| `ScrollbarButtonHeight` | Height of the scroll bar arrow buttons     |
| `MenuBarOffset`         | Left padding of menu bar captions          |
| `MenuItemOffset`        | Left padding of menu item captions         |
| `DefaultCaptionIndent`  | Padding between borders and captions       |
| `CornerRadius`          | Corner radius of flat controls (0 = square) |

### Images

Bitmap themes can replace any of the built-in images: `Arrows`, `Button`, `CheckBox`, `Frame`, `MenuCheckmark`, `NotFound`, `ProgressChunk`, `ProgressTrack`, `RadioButton`, `ScrollButtons`, `ScrollHButtons`, `ScrollHThumb`, `ScrollHTrack`, `ScrollThumb`, `ScrollTrack`, `SliderDown` and `SliderTrack`. The new image must use the same layout as the original (the `ThemePreview` example shows them).

## API reference

```vb
SUB SetTheme (themeName AS STRING)
```

Switches to a built-in theme (`"xp"`, `"light"` or `"dark"`) or loads a theme file.

```vb
FUNCTION GetTheme$
```

Returns the name or path last passed to `SetTheme` (`"xp"` by default).

```vb
FUNCTION GetThemeColor~& (role AS LONG)
SUB SetThemeColor (role AS LONG, c AS _UNSIGNED LONG)
```

Read or change one palette color. `role` is one of the `__UI_ThemeColor_*` constants (for example `__UI_ThemeColor_Accent`). `SetThemeColor` updates every control that uses that color by default.
