# PropertyGrid

A **PropertyGrid** turns a frame into a list of rows, each with a label on the left and a box, list, check box or button on the right. The designer's **Control properties** panel is one.

The grid takes care of the parts that are tedious to write by hand:

- Rows are stacked from the top of the frame. Hide a row and the ones below move up to close the gap.
- When the rows don't fit, a scrollbar appears on the frame's right edge, the same as a list box's. Rows get narrower to make room for it, and controls you attached to the right of a row slide left. The grid then scrolls with the scrollbar's buttons, track and thumb, with the mouse wheel anywhere over the grid, or by tabbing to a row that's out of view.
- In a text row, **Enter** (or leaving the box) commits what was typed and **Esc** puts back the row's value.
- While a box has focus, its border turns **green** when the text is the row's value, and **red** when a value was entered but the row ended up with another one (for example, your code kept it in range).
- Every change arrives in one place: `__UI_ValueChanged`, with the frame's ID.

## Quick start

Put a frame on your form in the designer, then add rows to it in `__UI_OnLoad`:

```vb
SUB __UI_OnLoad
    PropertyGrid_AddText ShapeFrame, "label", "Label"
    PropertyGrid_AddChoice ShapeFrame, "shape", "Shape", "Circle|Square|Triangle"
    PropertyGrid_AddInteger ShapeFrame, "size", "Size"
    PropertyGrid_AddToggle ShapeFrame, "filled", "Filled"
    PropertyGrid_AddButton ShapeFrame, "reset", "Defaults", "Reset"

    PropertyGrid_SetValue ShapeFrame, "size", "120"
END SUB

SUB __UI_ValueChanged (id AS LONG)
    SELECT CASE id
        CASE ShapeFrame
            SELECT CASE PropertyGrid_ChangedRow$(ShapeFrame)
                CASE "size"
                    IF VAL(PropertyGrid_Value$(ShapeFrame, "size")) > 200 THEN
                        PropertyGrid_SetValue ShapeFrame, "size", "200" ' the box turns red
                    END IF
                CASE "filled"
                    PropertyGrid_ShowRow ShapeFrame, "outline", PropertyGrid_Value$(ShapeFrame, "filled") = "0"
            END SELECT
    END SELECT
END SUB
```

Each row has a **key** (`"size"` above). Keys are used to read, set, show and hide rows, and they ignore case.

The `PropertyGridDemo` example shows a complete form.

## In the designer

Any frame can be a property grid without writing code to build it. The quickest way is the toolbox's **Property grid** button: it adds a frame called `PropertyGrid1` with two sample rows (a text box and an integer box). Double-click it to change them.

To turn a frame of your own into a property grid:

1. Add a frame to your form.
2. Right-click the frame and pick **Add property** and then a kind of row (text box, integer box, number box, choice, toggle or button). Each row is added with a key that isn't used yet (`text1`, `choice2`...), and the frame keeps its size: rows that don't fit get a scrollbar, which you can scroll with the mouse wheel.
   To change the rows, double-click the frame in the preview, or click the **Rows** button in its properties. It opens a table with one line per row and columns for the key, kind, label and items or value (see [DataGrid](DataGrid.md)). Edit the cells in place, use the buttons to go to the first, previous, next or last row and to add, delete or move rows (Shift or dragging selects several), and press **Ctrl+Z**/**Ctrl+Y** to undo or redo changes in the table. The preview shows the rows as you change them. **OK** keeps the changes as one step you can undo in the designer; **Cancel** (or Esc) puts the rows back as they were.
3. The designer draws the rows the way they will look. When the program starts, they become real rows, before `__UI_OnLoad` runs.

The rows are kept in the frame's Text, one per line, as `key|kind|label|extra`:

```text
label|text|Label
size|integer|Size|120
color|choice|Color|Red,Green,Blue
filled|toggle|Filled|-1
reset|button|Defaults|Reset
Notes
```

- **kind** is `text`, `integer`, `float`, `choice`, `toggle` or `button`. Leave it out for a text row.
- **extra** is a choice's items, separated by commas, a button's caption, or the starting value of a text, integer, float or toggle row (a toggle starts checked when it isn't `0`). In the designer's table, a toggle row's value is a check box.
- A line with only a label (`Notes` above) makes a text row whose key is that label.

Then use the rows from code exactly as below, for example `PropertyGrid_SetValue ShapeFrame, "size", "120"` in `__UI_OnLoad`.

When you save the form, the exported `.bas` explains the grid where you'll need it:

- `__UI_OnLoad` gets a comment about setting starting values.
- `__UI_ValueChanged` gets a `CASE` for the frame with a `SELECT CASE PropertyGrid_ChangedRow$(...)` that has one `CASE` per row and a comment on reading its value.
- `__UI_Click` gets a `SELECT CASE PropertyGrid_RowOf$(id)` for the grid's buttons.

A frame that becomes a grid after the `.bas` was first exported gets its `__UI_ValueChanged` block added to your code the next time you save. Your existing code is left as it is.

## Rows

| Add with | Control | Value |
| --- | --- | --- |
| `PropertyGrid_AddText` | text box | the text |
| `PropertyGrid_AddInteger` | text box for numbers | the number, rounded when committed |
| `PropertyGrid_AddFloat` | text box for numbers | the number |
| `PropertyGrid_AddChoice` | dropdown list (items separated by `\|`) | the chosen item's number, from 1 |
| `PropertyGrid_AddToggle` | check box, with no label column | `"-1"` when checked, `"0"` when not |
| `PropertyGrid_AddButton` | button | none: clicks go to `__UI_Click` |

Values are always strings. Use `VAL()` to read numbers.

The grid fires `__UI_ValueChanged` with the frame's ID when a text row is committed with a new value, or when a choice or toggle row changes. The control itself also fires its own event, which you can ignore.

To tell which row a button (or any row control) belongs to, use `PropertyGrid_RowOf$`:

```vb
SUB __UI_Click (id AS LONG)
    IF PropertyGrid_RowOf$(id) = "reset" THEN ResetShape
END SUB
```

## Using controls you placed in the designer

Instead of letting the grid create a row, you can hand it a label and a control the form already has. Their left and width are kept, and only their top changes when rows are stacked. A text box gets the grid's editing. Any other control is stacked, shown and hidden, but your code handles its events as usual.

```vb
PropertyGrid_AdoptRow SettingsFrame, "name", NameLB, NameTB
PropertyGrid_AdoptRow SettingsFrame, "theme", ThemeLB, ThemeList
PropertyGrid_AttachControl SettingsFrame, "name", BrowseBT ' a small button that stays on that row
```

The designer builds its own **Control properties** panel this way.

## API reference

```vb
SUB PropertyGrid_SetLayout (frameID AS LONG, rowLeft AS INTEGER, firstTop AS INTEGER, rowSpacing AS INTEGER, labelWidth AS INTEGER)
```

Where rows go. The defaults are `10, 10, 22, 120`. A row taller than the spacing takes the room it needs.

```vb
SUB PropertyGrid_AddText (frameID AS LONG, rowKey AS STRING, rowLabel AS STRING)
SUB PropertyGrid_AddInteger (frameID AS LONG, rowKey AS STRING, rowLabel AS STRING)
SUB PropertyGrid_AddFloat (frameID AS LONG, rowKey AS STRING, rowLabel AS STRING)
SUB PropertyGrid_AddChoice (frameID AS LONG, rowKey AS STRING, rowLabel AS STRING, itemList AS STRING)
SUB PropertyGrid_AddToggle (frameID AS LONG, rowKey AS STRING, rowCaption AS STRING)
SUB PropertyGrid_AddButton (frameID AS LONG, rowKey AS STRING, rowLabel AS STRING, rowCaption AS STRING)
SUB PropertyGrid_AdoptRow (frameID AS LONG, rowKey AS STRING, labelID AS LONG, controlID AS LONG)
```

Add a row below the others. `labelID` can be `0` for a row with no label.

```vb
SUB PropertyGrid_SetValue (frameID AS LONG, rowKey AS STRING, newValue AS STRING)
FUNCTION PropertyGrid_Value$ (frameID AS LONG, rowKey AS STRING)
SUB PropertyGrid_Commit (frameID AS LONG, rowKey AS STRING)
```

Set or read a row's value. A box that has focus keeps what's being typed. `PropertyGrid_Value$` returns the last committed text, not the text being typed. `PropertyGrid_Commit` commits a text row as if Enter had been pressed, which is useful after your code fills the box itself (for example, from a file dialog).

```vb
FUNCTION PropertyGrid_ChangedRow$ (frameID AS LONG)
```

The key of the row that just fired `__UI_ValueChanged`.

```vb
SUB PropertyGrid_ShowRow (frameID AS LONG, rowKey AS STRING, isShown AS _BYTE)
SUB PropertyGrid_ShowRows (frameID AS LONG, keyList AS STRING, isShown AS _BYTE)
SUB PropertyGrid_ShowAll (frameID AS LONG, isShown AS _BYTE)
SUB PropertyGrid_ShowOnly (frameID AS LONG, keyList AS STRING)
FUNCTION PropertyGrid_RowShown%% (frameID AS LONG, rowKey AS STRING)
```

Show and hide rows. Lists are comma-separated keys, like `"top,left,width,height"`.

```vb
SUB PropertyGrid_SetLabel (frameID AS LONG, rowKey AS STRING, rowLabel AS STRING)
SUB PropertyGrid_SetFloating (frameID AS LONG, rowKey AS STRING, isFloating AS _BYTE)
SUB PropertyGrid_AttachControl (frameID AS LONG, rowKey AS STRING, controlID AS LONG)
SUB PropertyGrid_DetachControl (controlID AS LONG)
```

Change a row's label (a toggle's caption). Leave a row out of the stacking so you can place it yourself (it is still shown and hidden by the grid). Keep another control on a row's line.

```vb
FUNCTION PropertyGrid_Control& (frameID AS LONG, rowKey AS STRING)
FUNCTION PropertyGrid_LabelControl& (frameID AS LONG, rowKey AS STRING)
FUNCTION PropertyGrid_RowOf$ (controlID AS LONG)
FUNCTION PropertyGrid_GridOf& (controlID AS LONG)
```

Go from a row to its controls and back, for example to set a tooltip:

```vb
ToolTip(PropertyGrid_Control(ShapeFrame, "size")) = "From 10 to 200"
```

```vb
FUNCTION PropertyGrid_RowState%% (frameID AS LONG, rowKey AS STRING)
```

What a focused text row's border shows: `__UI_PropertyGrid_Normal`, `__UI_PropertyGrid_Confirmed` (green) or `__UI_PropertyGrid_Rejected` (red).

```vb
SUB PropertyGrid_ScrollTo (frameID AS LONG, rowKey AS STRING)
```

Scrolls the grid so a row is in view.

```vb
SUB PropertyGrid_Layout (frameID AS LONG)
FUNCTION PropertyGrid_NextTop% (frameID AS LONG)
```

Rows are stacked on every screen update. Call `PropertyGrid_Layout` to stack them right away, for example to read a row's position after showing or hiding some. `PropertyGrid_NextTop` is the top of the space below the last shown row, which is handy for placing other controls under the grid.
