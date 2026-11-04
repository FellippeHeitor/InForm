'-----------------------------------------------------------------------------------------------------------------------
' InForm-PE PropertyGrid
' Copyright (c) 2026 Fellippe Heitor
'
' Turns a frame into a list of "label | value" rows, like the editor's Control properties panel.
' See InFormPropertyGrid.bm and docs/PropertyGrid.md.
'-----------------------------------------------------------------------------------------------------------------------

$INCLUDEONCE

'Row kinds
CONST __UI_PropertyGrid_Text%% = 1%%
CONST __UI_PropertyGrid_Integer%% = 2%%
CONST __UI_PropertyGrid_Float%% = 3%%
CONST __UI_PropertyGrid_Choice%% = 4%%
CONST __UI_PropertyGrid_Toggle%% = 5%%
CONST __UI_PropertyGrid_Button%% = 6%%
CONST __UI_PropertyGrid_Other%% = 7%% ' an adopted control that isn't a textbox: laid out, but not edited by the grid

'Row states (see PropertyGrid_RowState)
CONST __UI_PropertyGrid_Normal%% = 0%%
CONST __UI_PropertyGrid_Confirmed%% = 1%% ' the text in the box is the row's value
CONST __UI_PropertyGrid_Rejected%% = 2%% ' a value was entered, but the row ended up with another one

TYPE __UI_PropertyGridTYPE
    FrameID AS LONG
    RowLeft AS INTEGER
    FirstTop AS INTEGER
    RowSpacing AS INTEGER
    LabelWidth AS INTEGER
    NextTop AS INTEGER ' where a row added below the last visible one would go
    FocusRow AS LONG ' row whose textbox had focus during the last update
    ChangedRow AS LONG ' row that last fired __UI_ValueChanged
    LastFocusID AS LONG ' __UI_Focus at the last update, to notice a row getting focus
    ScrollY AS LONG ' pixels the rows are scrolled up by
    DrawnScrollY AS LONG ' ScrollY when the frame was last redrawn (frames keep a picture of themselves)
    MaxScrollY AS LONG ' 0 when every row fits
    ViewHeight AS LONG ' height of the area rows show in
    EnsureRow AS LONG ' a row to bring into view at the next layout
    'Scrollbar (drawn by __UI_DrawVScrollBar), in the frame's coordinates
    SbLeft AS INTEGER
    SbTop AS INTEGER
    SbHeight AS INTEGER
    TrackTop AS INTEGER ' the part between the arrow buttons
    TrackHeight AS INTEGER
    ThumbTop AS INTEGER
    ThumbHeight AS INTEGER
    HoverPart AS _BYTE ' part under the mouse: 1 = up button, 2 = down button, 3 = thumb, 4 = track above it, 5 = track below it
    PressPart AS _BYTE ' part the mouse button went down on (0 = none)
    Dragging AS _BYTE ' the thumb is being dragged
    GrabOffset AS INTEGER ' where the thumb was grabbed, from its top
    RepeatTime AS SINGLE ' when a held button or track scrolls again
END TYPE

TYPE __UI_PropertyGridRowTYPE
    Grid AS LONG
    Kind AS _BYTE
    LabelID AS LONG
    ControlID AS LONG
    Owned AS _BYTE ' the grid created the row's controls (and lays out their left and width)
    Shown AS _BYTE
    Floating AS _BYTE ' kept out of the stacking: the program places it
    Dirty AS _BYTE ' the text was edited since the last commit
    CommitTime AS SINGLE
    LastValue AS _FLOAT ' choice and toggle rows: the control's value at the last update
    ShrunkBy AS INTEGER ' adopted rows: how much narrower the control was made to leave room for the scrollbar
END TYPE

REDIM SHARED __UI_PropertyGrids(0) AS __UI_PropertyGridTYPE
REDIM SHARED __UI_PropertyGridRows(0) AS __UI_PropertyGridRowTYPE
REDIM SHARED __UI_PropertyGridKeys(0) AS STRING
REDIM SHARED __UI_PropertyGridValues(0) AS STRING
REDIM SHARED __UI_PropertyGridSeen(0) AS STRING ' text of a focused row's textbox at the last update
REDIM SHARED __UI_PropertyGridAttachedID(0) AS LONG
REDIM SHARED __UI_PropertyGridAttachedRow(0) AS LONG
REDIM SHARED __UI_PropertyGridAttachedShift(0) AS INTEGER ' how far left an attached control was moved for the scrollbar
REDIM SHARED __UI_PGMockScrollY(0) AS LONG ' designer: how far each frame's mock rows are scrolled, by control ID
CONST __UI_PG_MockFirstTop = 10, __UI_PG_MockSpacing = 22, __UI_PG_MockHeight = 23 ' designer: the default row layout
DIM SHARED __UI_PGThumbDragging AS _BYTE ' tells __UI_DrawVScrollBar a grid's thumb is being dragged
DIM SHARED __UI_TotalPropertyGrids AS LONG, __UI_TotalPropertyGridRows AS LONG
DIM SHARED __UI_TotalPropertyGridAttached AS LONG
