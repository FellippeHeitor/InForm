': DataGrid CSV demo for InForm-PE
': Copyright (c) 2026 Fellippe Heitor
': https://github.com/QB64-Phoenix-Edition/InForm-PE
'
': An inventory kept in inventory.csv, next to the program:
':   - DataGrid_LoadCSV fills the grid from the file; the header says which column each field goes to, so the
':     file's columns can be in any order, and the ones the grid doesn't have (Supplier) are left out.
':   - The first field of each line is the product's ID, kept as the row's tag.
':   - DataGrid_SaveCSV writes the rows back. The first time, when there's no file yet, the grid starts from
':     sample text with DataGrid_FromCSV.
':   - Copy and Paste use tab-separated text, which spreadsheets copy and paste too.
'-----------------------------------------------------------

OPTION _EXPLICIT

': Controls' IDs: ------------------------------------------------------------------
DIM SHARED DataGridCSVDemo AS LONG
DIM SHARED ListFrame AS LONG
DIM SHARED ReloadBT AS LONG
DIM SHARED SaveBT AS LONG
DIM SHARED AddBT AS LONG
DIM SHARED DeleteBT AS LONG
DIM SHARED CopyBT AS LONG
DIM SHARED PasteBT AS LONG
DIM SHARED StatusLB AS LONG

DIM SHARED Changed AS _BYTE ' the rows were changed since they were loaded or saved
DIM SHARED NextID AS LONG ' the ID the next new product gets

': Columns: ------------------------------------------------------------------------
CONST COL_PRODUCT = 1, COL_CATEGORY = 2, COL_STOCK = 3, COL_PRICE = 4, COL_ACTIVE = 5
CONST DATA_FILE = "inventory.csv"

': External modules: ---------------------------------------------------------------
'$INCLUDE:'../../InForm/InForm.bi'
'$INCLUDE:'DataGridCSVDemo.frm'

'Header + tags: the file starts with the captions, and each line with the product's ID
CONST FILE_OPTIONS = __UI_DataGrid_CSVHeader + __UI_DataGrid_CSVTags

': Helpers: ------------------------------------------------------------------------

''' What the grid starts with when there's no inventory.csv yet. Its columns are in another order than the
''' grid's, and Supplier isn't one of them.
FUNCTION SampleCSV$
    DIM s AS STRING, nl AS STRING
    nl = CHR$(10)
    s = "ID,Product,Price,Stock,Category,Active,Supplier" + nl
    s = s + "101,Claw hammer,12.5,14,Tools,yes,Acme" + nl
    s = s + "102," + CHR$(34) + "Screwdriver set, 6 pieces" + CHR$(34) + ",18.9,7,Tools,yes,Acme" + nl
    s = s + "103,Garden hose (15 m),24,3,Garden,yes,GreenCo" + nl
    s = s + "104,Pruning shears,16.75,0,Garden,no,GreenCo" + nl
    s = s + "105,Chef's knife,39.9,5,Kitchen,yes,Steelworks" + nl
    s = s + "106,Cutting board,11,12,Kitchen,yes,Woodland" + nl
    s = s + "107,Stapler,6.5,20,Office,yes,Paperhouse" + nl
    s = s + "108," + CHR$(34) + "A4 paper, 500 sheets" + CHR$(34) + ",5.2,40,Office,yes,Paperhouse" + nl
    s = s + "109,Desk lamp,22,2,Office,no,Brightline" + nl
    SampleCSV = s
END FUNCTION

SUB ShowTitle
    DIM t AS STRING
    t = "Inventory - " + DATA_FILE
    IF Changed THEN t = t + " *"
    SetCaption DataGridCSVDemo, t
END SUB

SUB SetStatus (text AS STRING)
    SetCaption StatusLB, text
END SUB

''' Gives an ID to every row that has none (rows pasted or added), after the highest one there.
SUB NumberRows
    DIM r AS LONG
    NextID = 1
    FOR r = 1 TO DataGrid_RowCount(ListFrame)
        IF VAL(DataGrid_RowTag(ListFrame, r)) >= NextID THEN NextID = VAL(DataGrid_RowTag(ListFrame, r)) + 1
    NEXT
    FOR r = 1 TO DataGrid_RowCount(ListFrame)
        IF LEN(DataGrid_RowTag(ListFrame, r)) = 0 THEN
            DataGrid_SetRowTag ListFrame, r, _TRIM$(STR$(NextID))
            NextID = NextID + 1
        END IF
    NEXT
END SUB

SUB LoadData
    DIM n AS LONG
    n = DataGrid_LoadCSV(ListFrame, DATA_FILE, FILE_OPTIONS)
    IF n = -1 THEN
        n = DataGrid_FromCSV(ListFrame, SampleCSV, FILE_OPTIONS)
        Changed = True
        SetStatus "There's no " + DATA_FILE + " yet: these are sample products. Save writes the file."
    ELSE
        Changed = False
        SetStatus "Loaded" + STR$(n) + " products from " + DATA_FILE + "."
    END IF
    NumberRows
    IF DataGrid_RowCount(ListFrame) > 0 THEN DataGrid_Select ListFrame, 1, COL_PRODUCT
    ShowTitle
END SUB

FUNCTION SaveData%%
    IF DataGrid_SaveCSV(ListFrame, DATA_FILE, FILE_OPTIONS) THEN
        Changed = False
        SetStatus "Saved" + STR$(DataGrid_RowCount(ListFrame)) + " products to " + DATA_FILE + "."
        SaveData = True
    ELSE
        MessageBox "Couldn't save " + DATA_FILE + ".", "", MsgBox_OkOnly + MsgBox_Exclamation
    END IF
    ShowTitle
END FUNCTION

''' _TRUE when the changes may be lost: there are none, or the user saved them or chose to leave them.
FUNCTION MayDiscard%%
    IF NOT Changed THEN MayDiscard = True: EXIT FUNCTION
    SELECT CASE MessageBox("Save the changes to " + DATA_FILE + "?", "", MsgBox_YesNoCancel + MsgBox_Question)
        CASE MsgBox_Yes: MayDiscard = SaveData
        CASE MsgBox_No: MayDiscard = True
    END SELECT
END FUNCTION

SUB PasteRows
    DIM clip AS STRING, firstLine AS STRING, options AS LONG, before AS LONG, n AS LONG
    clip = _CLIPBOARD$
    IF LEN(_TRIM$(clip)) = 0 THEN SetStatus "The clipboard has no text to paste.": EXIT SUB

    'Spreadsheets copy cells separated by tabs. When the first line has the captions (as Copy puts them), they
    'say which column each field goes to.
    options = __UI_DataGrid_CSVTab + __UI_DataGrid_CSVAppend
    firstLine = clip
    IF INSTR(firstLine, CHR$(10)) THEN firstLine = LEFT$(firstLine, INSTR(firstLine, CHR$(10)) - 1)
    IF INSTR(UCASE$(firstLine), "PRODUCT") THEN options = options + __UI_DataGrid_CSVHeader

    before = DataGrid_RowCount(ListFrame)
    n = DataGrid_FromCSV(ListFrame, clip, options)
    IF n <= 0 THEN SetStatus "Nothing to paste.": EXIT SUB
    NumberRows
    DataGrid_SelectRows ListFrame, before + 1, before + n
    Changed = True
    ShowTitle
    SetStatus "Pasted" + STR$(n) + " products."
END SUB

': Event procedures: ---------------------------------------------------------------
SUB __UI_BeforeInit
END SUB

SUB __UI_OnLoad
    DataGrid_AddTextColumn ListFrame, "Product", 0
    DataGrid_AddChoiceColumn ListFrame, "Category", 100, "Tools|Garden|Kitchen|Office"
    DataGrid_AddIntegerColumn ListFrame, "Stock", 60
    DataGrid_AddFloatColumn ListFrame, "Price", 70
    DataGrid_AddToggleColumn ListFrame, "Active", 60
    LoadData
END SUB

SUB __UI_BeforeUpdateDisplay
    Control(DeleteBT).Disabled = DataGrid_Row(ListFrame) = 0
    Control(SaveBT).Disabled = NOT Changed
END SUB

SUB __UI_BeforeUnload
    IF NOT MayDiscard THEN __UI_UnloadSignal = False
END SUB

SUB __UI_Click (id AS LONG)
    DIM r AS LONG
    SELECT CASE id
        CASE ReloadBT
            IF MayDiscard THEN LoadData
            SetFocus ListFrame
        CASE SaveBT
            IF SaveData THEN SetFocus ListFrame
        CASE AddBT
            r = DataGrid_InsertRow(ListFrame, DataGrid_Row(ListFrame) + 1, "New product|Tools|0|0|-1")
            DataGrid_SetRowTag ListFrame, r, _TRIM$(STR$(NextID))
            NextID = NextID + 1
            Changed = True
            ShowTitle
            DataGrid_Select ListFrame, r, COL_PRODUCT
            SetFocus ListFrame
            DataGrid_Edit ListFrame
        CASE DeleteBT
            DataGrid_RemoveSelection ListFrame
            Changed = True
            ShowTitle
            SetFocus ListFrame
        CASE CopyBT
            'Tab-separated text with the captions first, ready to paste into a spreadsheet (or back here)
            _CLIPBOARD$ = DataGrid_ToCSV(ListFrame, __UI_DataGrid_CSVHeader + __UI_DataGrid_CSVTab)
            SetStatus "Copied" + STR$(DataGrid_RowCount(ListFrame)) + " products. Paste them into a spreadsheet, or back here."
            SetFocus ListFrame
        CASE PasteBT
            PasteRows
            SetFocus ListFrame
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
    'Delete clears a cell; with several rows selected, it removes them
    IF id = ListFrame _ANDALSO __UI_KeyHit = _KEY_DELETE THEN
        IF DataGrid_SelectionLast(ListFrame) > DataGrid_SelectionFirst(ListFrame) THEN
            DataGrid_RemoveSelection ListFrame
            Changed = True
            ShowTitle
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
                'Another cell became current: the row's tag is the product's ID
                SetStatus "Product #" + DataGrid_RowTag(ListFrame, r) + ": " + DataGrid_Cell(ListFrame, r, COL_PRODUCT)
            ELSE
                IF DataGrid_ChangedColumn(ListFrame) = COL_STOCK _ANDALSO VAL(DataGrid_Cell(ListFrame, r, COL_STOCK)) < 0 THEN
                    DataGrid_SetCell ListFrame, r, COL_STOCK, "0"
                END IF
                Changed = True
                ShowTitle
                SetStatus "Changed product #" + DataGrid_RowTag(ListFrame, r) + "."
            END IF
    END SELECT
END SUB

SUB __UI_FormResized
END SUB

'$INCLUDE:'../../InForm/InForm.ui'
