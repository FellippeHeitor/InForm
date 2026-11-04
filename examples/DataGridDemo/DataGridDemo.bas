': DataGrid demo for InForm-PE
': Copyright (c) 2026 Fellippe Heitor
': https://github.com/QB64-Phoenix-Edition/InForm-PE
'
': The "Shopping list" frame is a data grid: its columns and rows are added in __UI_OnLoad,
': and every change arrives in __UI_ValueChanged with the frame's ID.
'-----------------------------------------------------------

OPTION _EXPLICIT

': Controls' IDs: ------------------------------------------------------------------
DIM SHARED DataGridDemo AS LONG
DIM SHARED ListFrame AS LONG
DIM SHARED AddBT AS LONG
DIM SHARED DeleteBT AS LONG
DIM SHARED UpBT AS LONG
DIM SHARED DownBT AS LONG
DIM SHARED TotalLB AS LONG
DIM SHARED StatusLB AS LONG

': Columns: ------------------------------------------------------------------------
CONST COL_ITEM = 1, COL_AISLE = 2, COL_QTY = 3, COL_PRICE = 4, COL_GOT = 5

': External modules: ---------------------------------------------------------------
'$INCLUDE:'../../InForm/InForm.bi'
'$INCLUDE:'DataGridDemo.frm'

': Helpers: ------------------------------------------------------------------------
SUB ShowTotal
    DIM r AS LONG, total AS DOUBLE, remaining AS DOUBLE
    FOR r = 1 TO DataGrid_RowCount(ListFrame)
        total = total + VAL(DataGrid_Cell$(ListFrame, r, COL_QTY)) * VAL(DataGrid_Cell$(ListFrame, r, COL_PRICE))
        IF DataGrid_Cell$(ListFrame, r, COL_GOT) = "0" THEN remaining = remaining + VAL(DataGrid_Cell$(ListFrame, r, COL_QTY)) * VAL(DataGrid_Cell$(ListFrame, r, COL_PRICE))
    NEXT
    SetCaption TotalLB, "Total: " + _TRIM$(STR$(_ROUND(total * 100) / 100)) + " (left:" + STR$(_ROUND(remaining * 100) / 100) + ")"
END SUB

': Event procedures: ---------------------------------------------------------------
SUB __UI_BeforeInit
END SUB

SUB __UI_OnLoad
    DIM r AS LONG
    DataGrid_AddTextColumn ListFrame, "Item", 0
    DataGrid_AddChoiceColumn ListFrame, "Aisle", 100, "Produce|Bakery|Dairy|Pantry|Frozen"
    DataGrid_AddIntegerColumn ListFrame, "Qty", 50
    DataGrid_AddFloatColumn ListFrame, "Price", 70
    DataGrid_AddToggleColumn ListFrame, "Got it", 60

    r = DataGrid_AddRow(ListFrame, "Apples|Produce|6|0.5|-1")
    r = DataGrid_AddRow(ListFrame, "Sourdough loaf|Bakery|1|4.25|0")
    r = DataGrid_AddRow(ListFrame, "Milk|Dairy|2|1.1|-1")
    r = DataGrid_AddRow(ListFrame, "Rice|Pantry|1|2.8|0")
    r = DataGrid_AddRow(ListFrame, "Peas|Frozen|2|1.75|0")
    r = DataGrid_AddRow(ListFrame, "Cheddar|Dairy|1|3.9|0")
    r = DataGrid_AddRow(ListFrame, "Bananas|Produce|5|0.3|0")
    r = DataGrid_AddRow(ListFrame, "Olive oil|Pantry|1|7.5|0")
    r = DataGrid_AddRow(ListFrame, "Croissants|Bakery|4|1.2|0")
    DataGrid_Select ListFrame, 1, 1
    ShowTotal
END SUB

SUB __UI_BeforeUpdateDisplay
    'Shift with the arrow keys, Shift+click or dragging selects several rows
    Control(DeleteBT).Disabled = DataGrid_Row(ListFrame) = 0
    Control(UpBT).Disabled = DataGrid_SelectionFirst(ListFrame) <= 1
    Control(DownBT).Disabled = DataGrid_SelectionFirst(ListFrame) = 0 OR DataGrid_SelectionLast(ListFrame) >= DataGrid_RowCount(ListFrame)
END SUB

SUB __UI_BeforeUnload
END SUB

SUB __UI_Click (id AS LONG)
    DIM r AS LONG
    r = DataGrid_Row(ListFrame)
    SELECT CASE id
        CASE AddBT
            r = DataGrid_InsertRow(ListFrame, r + 1, "New item|Pantry|1")
            DataGrid_Select ListFrame, r, COL_ITEM
            SetFocus ListFrame
            DataGrid_Edit ListFrame
        CASE DeleteBT
            DataGrid_RemoveSelection ListFrame
            SetFocus ListFrame
        CASE UpBT
            DataGrid_MoveSelection ListFrame, -1
            SetFocus ListFrame
        CASE DownBT
            DataGrid_MoveSelection ListFrame, 1
            SetFocus ListFrame
    END SELECT
    ShowTotal
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
    'Delete clears a cell; with several rows selected, it removes them
    IF id = ListFrame _ANDALSO __UI_KeyHit = _KEY_DELETE THEN
        IF DataGrid_SelectionLast(ListFrame) > DataGrid_SelectionFirst(ListFrame) THEN
            DataGrid_RemoveSelection ListFrame
            ShowTotal
        END IF
    END IF
END SUB

SUB __UI_TextChanged (id AS LONG)
    id = id
END SUB

SUB __UI_ValueChanged (id AS LONG)
    DIM r AS LONG
    SELECT CASE id
        CASE ListFrame
            r = DataGrid_ChangedRow(ListFrame)
            IF DataGrid_ChangedColumn(ListFrame) = 0 THEN
                'Another cell became current
                SetCaption StatusLB, "Row" + STR$(r) + ": " + DataGrid_Cell$(ListFrame, r, COL_ITEM)
            ELSE
                IF DataGrid_ChangedColumn(ListFrame) = COL_QTY _ANDALSO VAL(DataGrid_Cell$(ListFrame, r, COL_QTY)) < 0 THEN
                    DataGrid_SetCell ListFrame, r, COL_QTY, "0"
                END IF
                SetCaption StatusLB, "Changed " + DataGrid_Cell$(ListFrame, r, COL_ITEM) + "."
                ShowTotal
            END IF
    END SELECT
END SUB

SUB __UI_FormResized
END SUB

'$INCLUDE:'../../InForm/InForm.ui'
