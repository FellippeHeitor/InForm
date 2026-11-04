# DataGrid

A **DataGrid** turns a frame into a table: a row of column headers, rows of cells under it, and a current cell you can move around and edit in place. The designer's **Property grid rows** dialog is one.

The grid takes care of the parts that are tedious to write by hand:

- One cell is current. Click a cell, or move with the arrow keys, **Home**/**End** (with **Ctrl** for the first/last row), **Page Up**/**Page Down** and **Tab**/**Shift+Tab**. Past the last cell, **Tab** leaves the grid.
- To edit a cell, click it again, press **Enter** or **F2**, or just start typing. **Enter** (or leaving the cell) keeps the new value, **Esc** puts back the old one, and **Up**/**Down** keep it and move to the next row.
- Choice cells open a list (**Space**, **Enter** or a second click), and typing a letter picks the next item that starts with it. Toggle cells flip with a click or **Space**. **Delete** clears a cell.
- Whole rows can be selected as a range: **Shift** with Up/Down/Page Up/Page Down (or **Ctrl+Shift+Home/End**), **Shift+click**, or dragging over rows (past the top or bottom of the table, the grid scrolls). Cells aren't selected one by one: a range is for removing or moving rows.
- When the rows don't fit, a scrollbar appears on the right, the same as a list box's, and the mouse wheel scrolls the grid. The row below the last whole one shows cut off, and scrolls into full view when it's clicked or edited.
- When the columns don't fit, a scrollbar appears at the bottom and the grid scrolls sideways a whole column at a time. Moving to a column out of view (arrow keys, **Tab**, a click on one cut off at the right) scrolls to it. **Shift**+wheel scrolls sideways, and so does the wheel alone when every row fits.
- Every change arrives in one place: `__UI_ValueChanged`, with the frame's ID.

## Quick start

Click **Data grid** in the designer's toolbox and set up its columns and rows there (see [In the designer](#in-the-designer)), or put a frame on your form and add columns and rows to it in `__UI_OnLoad`:

```vb
SUB __UI_OnLoad
    DataGrid_AddTextColumn ListFrame, "Item", 0 ' 0: takes the room the other columns leave
    DataGrid_AddChoiceColumn ListFrame, "Aisle", 100, "Produce|Bakery|Dairy"
    DataGrid_AddIntegerColumn ListFrame, "Qty", 50
    DataGrid_AddToggleColumn ListFrame, "Got it", 60

    r = DataGrid_AddRow(ListFrame, "Apples|Produce|6|-1")
    r = DataGrid_AddRow(ListFrame, "Milk|Dairy|2")
END SUB

SUB __UI_ValueChanged (id AS LONG)
    SELECT CASE id
        CASE ListFrame
            r = DataGrid_ChangedRow(ListFrame)
            IF DataGrid_ChangedColumn(ListFrame) = 0 THEN
                'Another cell became current
            ELSE
                'A cell was changed
                PRINT DataGrid_Cell$(ListFrame, r, DataGrid_ChangedColumn(ListFrame))
            END IF
    END SELECT
END SUB
```

Rows and columns are numbered from 1, in the order they show. Every cell holds text: use `VAL()` to read numbers.

The `DataGridDemo` example shows a complete form, with buttons to add, delete and move rows (one or a selected range).

## Columns

| Add with | Cells hold | Edited with |
|---|---|---|
| `DataGrid_AddTextColumn` | any text | a text box |
| `DataGrid_AddIntegerColumn` | a whole number, rounded when kept | a text box for numbers |
| `DataGrid_AddFloatColumn` | a number | a text box for numbers |
| `DataGrid_AddChoiceColumn` | the chosen item's text (items separated by `\|`) | a dropdown list |
| `DataGrid_AddToggleColumn` | `"-1"` when checked, `"0"` when not | a click or Space |

Numbers are shown on the right of their cells.

A column's width is in pixels. Columns with a width of `0` share the room the others leave, and the last column always reaches the right edge. When there's less than 30 pixels each for them, or the columns with a width don't fit, the grid scrolls sideways (see above).

## In the designer

The toolbox's **Data grid** button adds a frame that is a data grid, with two text columns to start with. The preview draws it as it will look, and the mouse wheel scrolls it.

Its properties have two buttons:

- **Columns** opens a table with one line per column: its caption, kind (text, integer, float, choice or toggle), width in pixels (`0` shares the room left) and, for a choice, its items separated by commas. Moving or deleting a column moves or removes its cells in every row.
- **Rows** opens a table with the grid's own columns, holding the rows the grid has when the program starts. Double-clicking the frame in the preview opens it too (or Columns, while the grid has none).

Both work like the property grid's rows table (see [PropertyGrid](PropertyGrid.md#in-the-designer)): edit cells in place, add, delete and move lines with the buttons, undo with **Ctrl+Z**/**Ctrl+Y**, and watch the preview change as you go. **OK** keeps the changes as one step you can undo in the designer; **Cancel** (or Esc) puts the grid back as it was. While the table is open, the preview is dimmed and can't be edited.

The grid is kept in the frame's Text:

```text
#columns
Item|text|0
Aisle|choice|100|Produce,Bakery,Dairy
Qty|integer|50
Got it|toggle|60
#rows
Apples|Produce|6|-1
Milk|Dairy|2
```

- Each line after `#columns` is a column: `caption|kind|width|items`. A kind left out is text, and a width left out is `0`.
- Each line after `#rows` is a row, with its cells separated by `|`. Cells left out get their column's default. A blank line between rows is a row of defaults; blank lines at the end are left out.
- Cells written here can't contain `|` or line breaks. Your code can put them in a cell with `DataGrid_SetCell`.

When the program starts, the grid is built before `__UI_OnLoad` runs, so your code can add rows or change cells there. When you save the form, the exported `.bas` explains the grid in `__UI_OnLoad`, and `__UI_ValueChanged` gets a `CASE` for the frame with one `CASE` per column.

## Events

The grid fires `__UI_ValueChanged` with the frame's ID when:

- the user changes a cell: `DataGrid_ChangedRow` and `DataGrid_ChangedColumn` say which one.
- the user makes another cell current: `DataGrid_ChangedRow` is its row and `DataGrid_ChangedColumn` is `0`.

Changes made by your code (`DataGrid_SetCell`, `DataGrid_Select`...) don't fire it.

Arrow keys and the other keys the grid doesn't use still reach `__UI_KeyPress` with the frame's ID, so you can add your own (for example, **Insert** to add a row).

While a cell is edited, the grid puts a text box or a dropdown list of its own on top of the cell. They're in the frame, and they fire their own events, which you can ignore. `DataGrid_GridOf` tells them apart:

```vb
IF DataGrid_GridOf(id) = ListFrame THEN EXIT SUB
```

## Loading and saving data

A grid can be filled from CSV (comma-separated values), the format spreadsheets and most databases export, and saved back to it:

```vb
SUB __UI_OnLoad
    n = DataGrid_LoadCSV(ListFrame, "groceries.csv", __UI_DataGrid_CSVHeader)
    IF n = -1 THEN MessageBox "groceries.csv wasn't found.", "", MsgBox_Exclamation
END SUB

SUB __UI_Click (id AS LONG)
    SELECT CASE id
        CASE SaveBT
            IF NOT DataGrid_SaveCSV(ListFrame, "groceries.csv", __UI_DataGrid_CSVHeader) THEN MessageBox "Couldn't save.", "", MsgBox_Exclamation
    END SELECT
END SUB
```

The options are added together:

| Option | Loading | Saving |
|---|---|---|
| `__UI_DataGrid_CSVHeader` | The first line holds captions: each field goes to the column with its caption (in any case), in whatever order the file has them. Fields with no column are left out, and columns with no field get their default. | The captions are written first. |
| `__UI_DataGrid_CSVTags` | Each line's first field is its row's tag (see `DataGrid_SetRowTag`), for example a record's ID. | Each row's tag is written first (its caption is `Tag`). |
| `__UI_DataGrid_CSVAppend` | The rows are added to the ones the grid has. Without it, they replace them. | |
| `__UI_DataGrid_CSVSemicolon` | Fields are separated by `;` (as spreadsheets save them where the decimal mark is a comma). | Same. |
| `__UI_DataGrid_CSVTab` | Fields are separated by tabs. | Same. |

- Without a header, fields go to the columns in order.
- A grid with no columns gets a text column for each field: named after the header, or `Column 1`, `Column 2`... without one. So a plain frame can show any CSV file.
- Fields in quotes can hold the separator, line breaks, `|` and quotes (written twice: `""`). A UTF-8 byte order mark at the start is left out, and so are blank lines.
- Numbers are read with `VAL` (integers are rounded). A toggle is checked by `-1`, `1`, `true`, `yes`, `y`, `x` or `on`, in any case, and saved as `-1` or `0`.
- Saving keeps what's being typed in a cell first, writes lines ending in CR+LF, and replaces the file.
- Loading doesn't fire `__UI_ValueChanged`.

The `DataGridCSVDemo` example keeps an inventory in a CSV file, with product IDs as row tags, and copies and pastes rows to and from spreadsheets.

The same text can come from (or go to) anywhere else, such as a database query, a web request or the clipboard, with `DataGrid_FromCSV` and `DataGrid_ToCSV$`:

```vb
n = DataGrid_FromCSV(ListFrame, _CLIPBOARD$, __UI_DataGrid_CSVTab) ' cells copied from a spreadsheet
_CLIPBOARD$ = DataGrid_ToCSV(ListFrame, __UI_DataGrid_CSVTab + __UI_DataGrid_CSVHeader)
```

To keep a source up to date as the user edits, rather than saving it all at once, load the rows with their IDs as tags and write each change back in `__UI_ValueChanged`:

```vb
SUB __UI_ValueChanged (id AS LONG)
    SELECT CASE id
        CASE ListFrame
            r = DataGrid_ChangedRow(ListFrame)
            c = DataGrid_ChangedColumn(ListFrame)
            IF c > 0 THEN UpdateRecord DataGrid_RowTag(ListFrame, r), c, DataGrid_Cell(ListFrame, r, c) ' your own SUB
    END SELECT
END SUB
```

## API reference

```vb
SUB DataGrid_AddTextColumn (frameID AS LONG, columnCaption AS STRING, columnWidth AS INTEGER)
SUB DataGrid_AddIntegerColumn (frameID AS LONG, columnCaption AS STRING, columnWidth AS INTEGER)
SUB DataGrid_AddFloatColumn (frameID AS LONG, columnCaption AS STRING, columnWidth AS INTEGER)
SUB DataGrid_AddChoiceColumn (frameID AS LONG, columnCaption AS STRING, columnWidth AS INTEGER, itemList AS STRING)
SUB DataGrid_AddToggleColumn (frameID AS LONG, columnCaption AS STRING, columnWidth AS INTEGER)
FUNCTION DataGrid_ColumnCount& (frameID AS LONG)
```

Add a column to the right of the others. The first column makes the frame a grid (`DataGrid_Attach` does only that).

```vb
SUB DataGrid_SetColumnWidth (frameID AS LONG, columnNumber AS LONG, columnWidth AS INTEGER)
SUB DataGrid_SetColumnCaption (frameID AS LONG, columnNumber AS LONG, columnCaption AS STRING)
SUB DataGrid_SetColumnItems (frameID AS LONG, columnNumber AS LONG, itemList AS STRING)
```

Change a column. New items for a choice column don't change the cells.

```vb
SUB DataGrid_RemoveColumn (frameID AS LONG, columnNumber AS LONG)
```

Remove a column and its cells from every row. The columns to its right move one place left.

```vb
FUNCTION DataGrid_AddRow& (frameID AS LONG, cellList AS STRING)
FUNCTION DataGrid_InsertRow& (frameID AS LONG, beforeRow AS LONG, cellList AS STRING)
SUB DataGrid_RemoveRow (frameID AS LONG, rowNumber AS LONG)
SUB DataGrid_MoveRow (frameID AS LONG, rowNumber AS LONG, toRow AS LONG)
SUB DataGrid_Clear (frameID AS LONG)
FUNCTION DataGrid_RowCount& (frameID AS LONG)
```

Add a row at the end or before another, and get its number back. `cellList` has the cells separated by `|`. Cells left out get their column's default: empty text, `0`, unchecked, or a choice's first item. A cell that has to hold `|` can be set with `DataGrid_SetCell`.

`DataGrid_MoveRow` moves a row so it becomes row `toRow`, and the current cell goes along with it. After `DataGrid_RemoveRow`, the current cell stays on the same row number. `DataGrid_Clear` removes every row and keeps the columns.

```vb
SUB DataGrid_SetRowTag (frameID AS LONG, rowNumber AS LONG, rowTag AS STRING)
FUNCTION DataGrid_RowTag$ (frameID AS LONG, rowNumber AS LONG)
```

Keep a value of your own with a row, for example a record's ID. It isn't shown, and it stays with its row when rows are moved. New rows start with no tag (`""`).

```vb
FUNCTION DataGrid_Cell$ (frameID AS LONG, rowNumber AS LONG, columnNumber AS LONG)
SUB DataGrid_SetCell (frameID AS LONG, rowNumber AS LONG, columnNumber AS LONG, cellValue AS STRING)
```

Read or set a cell.

```vb
SUB DataGrid_SetCellKind (frameID AS LONG, rowNumber AS LONG, columnNumber AS LONG, cellKind AS _BYTE)
FUNCTION DataGrid_CellKind%% (frameID AS LONG, rowNumber AS LONG, columnNumber AS LONG)
```

Give one cell a kind of its own, different from its column's: `__UI_DataGrid_Text`, `__UI_DataGrid_Integer`, `__UI_DataGrid_Float`, `__UI_DataGrid_Choice` (with the column's items) or `__UI_DataGrid_Toggle`. Pass `0` to give it its column's kind back. The cell's value isn't changed. A check box or number in a column of another kind sits at the left, like the text around it. The kind stays with the row when rows are moved. `DataGrid_CellKind` returns the kind a cell has.

```vb
FUNCTION DataGrid_Row& (frameID AS LONG)
FUNCTION DataGrid_Column& (frameID AS LONG)
SUB DataGrid_Select (frameID AS LONG, rowNumber AS LONG, columnNumber AS LONG)
```

The current cell (`0` when there is none), and making a cell current. The grid scrolls to show it.

```vb
FUNCTION DataGrid_ChangedRow& (frameID AS LONG)
FUNCTION DataGrid_ChangedColumn& (frameID AS LONG)
```

What fired `__UI_ValueChanged` (see [Events](#events)).

```vb
FUNCTION DataGrid_SelectionFirst& (frameID AS LONG)
FUNCTION DataGrid_SelectionLast& (frameID AS LONG)
FUNCTION DataGrid_RowSelected%% (frameID AS LONG, rowNumber AS LONG)
SUB DataGrid_SelectRows (frameID AS LONG, fromRow AS LONG, toRow AS LONG)
SUB DataGrid_MoveSelection (frameID AS LONG, byRows AS LONG)
SUB DataGrid_RemoveSelection (frameID AS LONG)
```

The selected rows: the current row alone, or a range selected with Shift or by dragging. `DataGrid_SelectRows` selects a range from code (the current cell goes to `toRow`). `DataGrid_MoveSelection` moves the selected rows up (`-1`) or down (`1`) one place and keeps them selected, and `DataGrid_RemoveSelection` removes them. Moving the current cell without Shift leaves only its row selected.

With several rows selected, **Delete** doesn't clear a cell: it goes on to `__UI_KeyPress`, so your program can remove the rows:

```vb
SUB __UI_KeyPress (id AS LONG)
    IF id = ListFrame _ANDALSO __UI_KeyHit = _KEY_DELETE THEN
        IF DataGrid_SelectionLast(ListFrame) > DataGrid_SelectionFirst(ListFrame) THEN DataGrid_RemoveSelection ListFrame
    END IF
END SUB
```

```vb
SUB DataGrid_Edit (frameID AS LONG)
SUB DataGrid_StopEditing (frameID AS LONG)
FUNCTION DataGrid_IsEditing%% (frameID AS LONG)
```

Start editing the current cell as if Enter had been pressed, for example right after adding a row. `DataGrid_StopEditing` keeps what was typed, which is useful before reading the cells (for example, when an OK button is clicked while a cell is being edited).

```vb
FUNCTION DataGrid_GridOf& (controlID AS LONG)
```

The frame a control belongs to: the frame itself, or the box or list that edits its cells. `0` for any other control.

```vb
FUNCTION DataGrid_LoadCSV& (frameID AS LONG, fileName AS STRING, csvOptions AS LONG)
FUNCTION DataGrid_FromCSV& (frameID AS LONG, csvText AS STRING, csvOptions AS LONG)
FUNCTION DataGrid_SaveCSV%% (frameID AS LONG, fileName AS STRING, csvOptions AS LONG)
FUNCTION DataGrid_ToCSV$ (frameID AS LONG, csvOptions AS LONG)
```

Load rows from a CSV file or text, and get back how many were added (`-1` when the file doesn't exist or `frameID` isn't a frame). Save the rows to a file (`_FALSE` when `frameID` isn't a grid), or get them as text. See [Loading and saving data](#loading-and-saving-data) for the options.
