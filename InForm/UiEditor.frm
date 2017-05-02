'InForm - GUI system for QB64 - Beta version 1
'Fellippe Heitor, 2016 - fellippe@qb64.org - @fellippeheitor
'-----------------------------------------------------------
SUB __UI_LoadForm

    DIM __UI_NewID AS LONG

    __UI_NewID = __UI_NewControl(__UI_Type_Form, "UiEditorForm", 598, 430, 0, 0, 0)
    SetCaption __UI_NewID, UiEditorTitle$
    $IF WIN THEN
        Control(__UI_NewID).Font = SetFont("segoeui.ttf", 12, "")
    $ELSE
        Control(__UI_NewID).Font = SetFont("InForm/resources/NotoMono-Regular.ttf", 12, "")
    $END IF

    __UI_NewID = __UI_NewControl(__UI_Type_MenuBar, "FileMenu", 44, 18, 8, 0, 0)
    SetCaption __UI_NewID, "&File"

    __UI_NewID = __UI_NewControl(__UI_Type_MenuBar, "EditMenu", 44, 18, 52, 0, 0)
    SetCaption __UI_NewID, "&Edit"

    __UI_NewID = __UI_NewControl(__UI_Type_MenuBar, "ViewMenu", 44, 18, 52, 0, 0)
    SetCaption __UI_NewID, "&View"

    __UI_NewID = __UI_NewControl(__UI_Type_MenuBar, "InsertMenu", 44, 18, 52, 0, 0)
    SetCaption __UI_NewID, "&Insert"

    __UI_NewID = __UI_NewControl(__UI_Type_MenuBar, "AlignMenu", 0, 0, 0, 0, 0)
    SetCaption __UI_NewID, "&Align"

    __UI_NewID = __UI_NewControl(__UI_Type_MenuBar, "OptionsMenu", 44, 18, 52, 0, 0)
    SetCaption __UI_NewID, "&Options"

    __UI_NewID = __UI_NewControl(__UI_Type_MenuBar, "HelpMenu", 44, 18, 545, 0, 0)
    SetCaption __UI_NewID, "&Help"
    Control(__UI_NewID).Align = __UI_Right

    __UI_NewID = __UI_NewControl(__UI_Type_Frame, "ToolBox", 62, 376, 30, 40, 0)
    Control(__UI_NewID).HasBorder = True

    __UI_NewID = __UI_NewControl(__UI_Type_Frame, "PropertiesFrame", 457, 186, 110, 40, 0)
    SetCaption __UI_NewID, "Control properties: Main form"
    Control(__UI_NewID).HasBorder = True

    __UI_NewID = __UI_NewControl(__UI_Type_Frame, "ColorMixer", 457, 175, 110, 240, 0)
    SetCaption __UI_NewID, "Color mixer"
    Control(__UI_NewID).HasBorder = True

    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "FileMenuNew", 91, 18, 0, 22, __UI_GetID("FileMenu"))
    SetCaption __UI_NewID, "&New"

    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "FileMenuOpen", 91, 18, 0, 22, __UI_GetID("FileMenu"))
    SetCaption __UI_NewID, "&Open...-"

    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "FileMenuSave", 91, 18, 0, 22, __UI_GetID("FileMenu"))
    SetCaption __UI_NewID, "&Save project"
    ToolTip(__UI_NewID) = "File names are automatically taken from your form's name property"

    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "FileMenuSaveFrm", 91, 18, 0, 22, __UI_GetID("FileMenu"))
    SetCaption __UI_NewID, "&Save form only-"
    ToolTip(__UI_NewID) = "File names are automatically taken from your form's name property" + CHR$(10) + _
                          "Only the .frm and .frmbin files will be updated."

    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "FileMenuExit", 56, 18, 0, 40, __UI_GetID("FileMenu"))
    SetCaption __UI_NewID, "E&xit"

    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "EditMenuUndo", 56, 18, 0, 40, __UI_GetID("EditMenu"))
    SetCaption __UI_NewID, "&Undo"

    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "EditMenuRedo", 56, 18, 0, 40, __UI_GetID("EditMenu"))
    SetCaption __UI_NewID, "&Redo-"

    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "EditMenuCP437", 56, 18, 0, 40, __UI_GetID("EditMenu"))
    SetCaption __UI_NewID, "Use code page &OEM-437"
    Control(__UI_NewID).Value = True

    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "EditMenuCP1252", 56, 18, 0, 40, __UI_GetID("EditMenu"))
    SetCaption __UI_NewID, "Use code page &Windows-1252-"

    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "EditMenuZOrdering", 56, 18, 0, 40, __UI_GetID("EditMenu"))
    SetCaption __UI_NewID, "&Z-Ordering"

    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "ViewMenuPreviewDetach", 56, 18, 0, 40, __UI_GetID("ViewMenu"))
    SetCaption __UI_NewID, "&Keep preview window attached"
    Control(__UI_NewID).Value = -1

    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "ViewMenuShowPositionAndSize", 56, 18, 0, 40, __UI_GetID("ViewMenu"))
    SetCaption __UI_NewID, "&Show position and size on the preview"
    Control(__UI_NewID).Value = -1

    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "ViewMenuPreview", 56, 18, 0, 40, __UI_GetID("ViewMenu"))
    SetCaption __UI_NewID, "&Open preview window-"

    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "ViewMenuLoadedFonts", 56, 18, 0, 40, __UI_GetID("ViewMenu"))
    SetCaption __UI_NewID, "&Loaded fonts"

    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "InsertMenuMenuBar", 0, 0, 0, 0, __UI_GetID("InsertMenu"))
    SetCaption __UI_NewID, "Menu &Bar"

    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "InsertMenuMenuItem", 0, 0, 0, 0, __UI_GetID("InsertMenu"))
    SetCaption __UI_NewID, "Menu &Item"
    Control(__UI_NewID).Disabled = True

    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "OptionsMenuSnapLines", 0, 0, 0, 0, __UI_GetID("AlignMenu"))
    SetCaption __UI_NewID, "&Snap to edges-"
    Control(__UI_NewID).Value = True
    ToolTip(__UI_NewID) = "Automatically snap control's edges to other controls, for easy aligning. Can be temporarily bypassed by holding Ctrl."


    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "AlignMenuAlignLeft", 0, 0, 0, 0, __UI_GetID("AlignMenu"))
    SetCaption __UI_NewID, "Align &Left"

    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "AlignMenuAlignRight", 0, 0, 0, 0, __UI_GetID("AlignMenu"))
    SetCaption __UI_NewID, "Align &Right"

    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "AlignMenuAlignTops", 0, 0, 0, 0, __UI_GetID("AlignMenu"))
    SetCaption __UI_NewID, "Align T&op"

    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "AlignMenuAlignBottoms", 0, 0, 0, 0, __UI_GetID("AlignMenu"))
    SetCaption __UI_NewID, "Align &Bottom-"

    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "AlignMenuAlignCentersV", 0, 0, 0, 0, __UI_GetID("AlignMenu"))
    SetCaption __UI_NewID, "Align cent&ers Vertically"

    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "AlignMenuAlignCentersH", 0, 0, 0, 0, __UI_GetID("AlignMenu"))
    SetCaption __UI_NewID, "Ali&gn centers Horizontally"

    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "AlignMenuAlignCenterV", 0, 0, 0, 0, __UI_GetID("AlignMenu"))
    SetCaption __UI_NewID, "Center &Vertically (group)"

    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "AlignMenuAlignCenterH", 0, 0, 0, 0, __UI_GetID("AlignMenu"))
    SetCaption __UI_NewID, "Center &Horizontally (group)-"

    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "AlignMenuDistributeV", 0, 0, 0, 0, __UI_GetID("AlignMenu"))
    SetCaption __UI_NewID, "Distribute Ver&tically"

    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "AlignMenuDistributeH", 0, 0, 0, 0, __UI_GetID("AlignMenu"))
    SetCaption __UI_NewID, "Distribute Hori&zontally"

    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "OptionsMenuAutoName", 0, 0, 0, 0, __UI_GetID("OptionsMenu"))
    $IF WIN THEN
        SetCaption __UI_NewID, "&Auto-name controls"
    $ELSE
        SetCaption __UI_NewID, "&Auto-name controls-"
    $END IF
    Control(__UI_NewID).Value = True
    ToolTip(__UI_NewID) = "Automatically set control names based on caption and type"
    
    $IF WIN THEN
    $ELSE
        __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "OptionsMenuSwapButtons", 0, 0, 0, 0, __UI_GetID("OptionsMenu"))
        SetCaption __UI_NewID, "&Swap mouse buttons"
    $END IF
    
    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "HelpMenuHelp", 0, 0, 0, 0, __UI_GetID("HelpMenu"))
    SetCaption __UI_NewID, "&What's all this?-"

    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "HelpMenuAbout", 0, 0, 0, 0, __UI_GetID("HelpMenu"))
    SetCaption __UI_NewID, "&About..."

    __UI_NewID = __UI_NewControl(__UI_Type_Button, "AddButton", 22, 22, 20, 26, __UI_GetID("ToolBox"))
    Control(__UI_NewID).CanHaveFocus = True
    ToolTip(__UI_NewID) = "New button"

    __UI_NewID = __UI_NewControl(__UI_Type_Button, "AddLabel", 22, 22, 20, 56, __UI_GetID("ToolBox"))
    Control(__UI_NewID).CanHaveFocus = True
    ToolTip(__UI_NewID) = "New label"

    __UI_NewID = __UI_NewControl(__UI_Type_Button, "AddTextBox", 22, 22, 20, 86, __UI_GetID("ToolBox"))
    Control(__UI_NewID).CanHaveFocus = True
    ToolTip(__UI_NewID) = "New text box"

    __UI_NewID = __UI_NewControl(__UI_Type_Button, "AddCheckBox", 22, 22, 20, 116, __UI_GetID("ToolBox"))
    Control(__UI_NewID).CanHaveFocus = True
    ToolTip(__UI_NewID) = "New check box"

    __UI_NewID = __UI_NewControl(__UI_Type_Button, "AddRadioButton", 22, 22, 20, 146, __UI_GetID("ToolBox"))
    Control(__UI_NewID).CanHaveFocus = True
    ToolTip(__UI_NewID) = "New radio button"

    __UI_NewID = __UI_NewControl(__UI_Type_Button, "AddListBox", 22, 22, 20, 176, __UI_GetID("ToolBox"))
    Control(__UI_NewID).CanHaveFocus = True
    ToolTip(__UI_NewID) = "New list box"

    __UI_NewID = __UI_NewControl(__UI_Type_Button, "AddDropdownList", 22, 22, 20, 206, __UI_GetID("ToolBox"))
    Control(__UI_NewID).CanHaveFocus = True
    ToolTip(__UI_NewID) = "New drop-down list box"

    __UI_NewID = __UI_NewControl(__UI_Type_Button, "AddTrackBar", 22, 22, 20, 236, __UI_GetID("ToolBox"))
    Control(__UI_NewID).CanHaveFocus = True
    ToolTip(__UI_NewID) = "New track bar/slider"

    __UI_NewID = __UI_NewControl(__UI_Type_Button, "AddProgressBar", 22, 22, 20, 266, __UI_GetID("ToolBox"))
    Control(__UI_NewID).CanHaveFocus = True
    ToolTip(__UI_NewID) = "New progress bar"

    __UI_NewID = __UI_NewControl(__UI_Type_Button, "AddPictureBox", 22, 22, 20, 296, __UI_GetID("ToolBox"))
    Control(__UI_NewID).CanHaveFocus = True
    ToolTip(__UI_NewID) = "New picture box"

    __UI_NewID = __UI_NewControl(__UI_Type_Button, "AddFrame", 22, 22, 20, 326, __UI_GetID("ToolBox"))
    Control(__UI_NewID).CanHaveFocus = True
    ToolTip(__UI_NewID) = "New frame"

    __UI_NewID = __UI_NewControl(__UI_Type_DropdownList, "PropertiesList", 174, 23, 20, 20, __UI_GetID("PropertiesFrame"))
    AddItem __UI_NewID, "Name"
    AddItem __UI_NewID, "Caption"
    AddItem __UI_NewID, "Text"
    AddItem __UI_NewID, "Top"
    AddItem __UI_NewID, "Left"
    AddItem __UI_NewID, "Width"
    AddItem __UI_NewID, "Height"
    AddItem __UI_NewID, "Font"
    AddItem __UI_NewID, "Tool tip"
    AddItem __UI_NewID, "Value"
    AddItem __UI_NewID, "Min"
    AddItem __UI_NewID, "Max"
    AddItem __UI_NewID, "Interval"
    AddItem __UI_NewID, "Padding (Left/Right)"
    Control(__UI_NewID).HasBorder = True
    Control(__UI_NewID).Value = 1
    Control(__UI_NewID).Max = 14
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_TextBox, "PropertyValue", 225, 23, 200, 20, __UI_GetID("PropertiesFrame"))
    Control(__UI_NewID).HasBorder = True
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_PictureBox, "PropertyUpdateStatus", 16, 16, 430, 23, __UI_GetID("PropertiesFrame"))
    Control(__UI_NewID).HasBorder = False
    Control(__UI_NewID).BackStyle = __UI_Transparent
    
    __UI_NewID = __UI_NewControl(__UI_Type_CheckBox, "Stretch", 150, 17, 22, 55, __UI_GetID("PropertiesFrame"))
    SetCaption __UI_NewID, "Stretch"
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_CheckBox, "HasBorder", 150, 17, 22, 75, __UI_GetID("PropertiesFrame"))
    SetCaption __UI_NewID, "Has border"
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_CheckBox, "ShowPercentage", 149, 17, 22, 95, __UI_GetID("PropertiesFrame"))
    SetCaption __UI_NewID, "Show percentage"
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_CheckBox, "PasswordMaskCB", 149, 17, 22, 115, __UI_GetID("PropertiesFrame"))
    SetCaption __UI_NewID, "Password mask"
    Control(__UI_NewID).CanHaveFocus = True
    
    __UI_NewID = __UI_NewControl(__UI_Type_CheckBox, "WordWrap", 115, 17, 182, 55, __UI_GetID("PropertiesFrame"))
    SetCaption __UI_NewID, "Word wrap"
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_CheckBox, "CanHaveFocus", 117, 17, 182, 75, __UI_GetID("PropertiesFrame"))
    SetCaption __UI_NewID, "Can have focus"
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_CheckBox, "Disabled", 105, 17, 182, 95, __UI_GetID("PropertiesFrame"))
    SetCaption __UI_NewID, "Disabled"
    Control(__UI_NewID).CanHaveFocus = True
    
    __UI_NewID = __UI_NewControl(__UI_Type_CheckBox, "Transparent", 105, 17, 182, 115, __UI_GetID("PropertiesFrame"))
    SetCaption __UI_NewID, "Transparent"
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_CheckBox, "Hidden", 110, 17, 329, 55, __UI_GetID("PropertiesFrame"))
    SetCaption __UI_NewID, "Hidden"
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_CheckBox, "CenteredWindow", 116, 17, 329, 75, __UI_GetID("PropertiesFrame"))
    SetCaption __UI_NewID, "Centered window"
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_CheckBox, "Resizable", 102, 17, 329, 95, __UI_GetID("PropertiesFrame"))
    SetCaption __UI_NewID, "Resizable"
    Control(__UI_NewID).CanHaveFocus = True
    
    __UI_NewID = __UI_NewControl(__UI_Type_Label, "Label1", 63, 20, 24, 151, __UI_GetID("PropertiesFrame"))
    SetCaption __UI_NewID, "Text align:"

    __UI_NewID = __UI_NewControl(__UI_Type_DropdownList, "AlignOptions", 102, 20, 102, 151, __UI_GetID("PropertiesFrame"))
    AddItem __UI_NewID, "Left"
    AddItem __UI_NewID, "Center"
    AddItem __UI_NewID, "Right"
    Control(__UI_NewID).HasBorder = True
    Control(__UI_NewID).Value = 1
    Control(__UI_NewID).Max = 3
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_Label, "VerticalAlignLB", 79, 20, 241, 151, __UI_GetID("PropertiesFrame"))
    SetCaption __UI_NewID, "Vertical align:"

    __UI_NewID = __UI_NewControl(__UI_Type_DropdownList, "VAlignOptions", 102, 20, 320, 151, __UI_GetID("PropertiesFrame"))
    AddItem __UI_NewID, "Top"
    AddItem __UI_NewID, "Middle"
    AddItem __UI_NewID, "Bottom"
    Control(__UI_NewID).HasBorder = True
    Control(__UI_NewID).Value = 1
    Control(__UI_NewID).Max = 3
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_DropdownList, "ColorPropertiesList", 161, 21, 10, 20, __UI_GetID("ColorMixer"))
    AddItem __UI_NewID, "ForeColor"
    AddItem __UI_NewID, "BackColor"
    AddItem __UI_NewID, "SelectedForeColor"
    AddItem __UI_NewID, "SelectedBackColor"
    AddItem __UI_NewID, "BorderColor"
    Control(__UI_NewID).HasBorder = True
    Control(__UI_NewID).Value = 1
    Control(__UI_NewID).Max = 5
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_PictureBox, "ColorPreview", 159, 115, 10, 51, __UI_GetID("ColorMixer"))
    Control(__UI_NewID).HasBorder = True

    __UI_NewID = __UI_NewControl(__UI_Type_TrackBar, "Red", 198, 40, 191, 17, __UI_GetID("ColorMixer"))
    Control(__UI_NewID).Max = 255
    Control(__UI_NewID).CanHaveFocus = True
    Control(__UI_NewID).Interval = 25

    __UI_NewID = __UI_NewControl(__UI_Type_TextBox, "RedValue", 36, 23, 400, 20, __UI_GetID("ColorMixer"))
    Control(__UI_NewID).BorderColor = _RGB32(255, 0, 0)
    Control(__UI_NewID).HasBorder = True
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_TrackBar, "Green", 198, 40, 191, 67, __UI_GetID("ColorMixer"))
    Control(__UI_NewID).Max = 255
    Control(__UI_NewID).CanHaveFocus = True
    Control(__UI_NewID).Interval = 25

    __UI_NewID = __UI_NewControl(__UI_Type_TextBox, "GreenValue", 36, 23, 400, 70, __UI_GetID("ColorMixer"))
    Control(__UI_NewID).BorderColor = _RGB32(0, 180, 0)
    Control(__UI_NewID).HasBorder = True
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_TrackBar, "Blue", 198, 40, 191, 117, __UI_GetID("ColorMixer"))
    Control(__UI_NewID).Max = 255
    Control(__UI_NewID).CanHaveFocus = True
    Control(__UI_NewID).Interval = 25

    __UI_NewID = __UI_NewControl(__UI_Type_TextBox, "BlueValue", 36, 23, 400, 120, __UI_GetID("ColorMixer"))
    Control(__UI_NewID).BorderColor = _RGB32(0, 0, 255)
    Control(__UI_NewID).HasBorder = True
    Control(__UI_NewID).CanHaveFocus = True

    '----------------------------------
    'Open dialog:
    '----------------------------------
    __UI_NewID = __UI_NewControl(__UI_Type_PictureBox, "DialogBG", 598, 430, -600, -500, 0)
    Control(__UI_NewID).BackColor = Darken(__UI_DefaultColor(__UI_Type_Form, 2), 105)
    
    __UI_NewID = __UI_NewControl(__UI_Type_Frame, "OpenFrame", 463, 289, -600, -500, 0)
    SetCaption __UI_NewID, "Open"
    Control(__UI_NewID).HasBorder = True
    Control(__UI_NewID).BackColor = Darken(__UI_DefaultColor(__UI_Type_Form, 2), 105)

    __UI_NewID = __UI_NewControl(__UI_Type_Label, "FileNameLB", 73, 23, 15, 16, __UI_GetID("OpenFrame"))
    SetCaption __UI_NewID, "File &name:"
    Control(__UI_NewID).BackStyle = __UI_Transparent

    __UI_NewID = __UI_NewControl(__UI_Type_TextBox, "FileNameTextBox", 363, 23, 89, 16, __UI_GetID("OpenFrame"))
    Control(__UI_NewID).HasBorder = True
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_Label, "PathLB", 437, 23, 15, 44, __UI_GetID("OpenFrame"))
    SetCaption __UI_NewID, "Path: C:\QB64"
    Control(__UI_NewID).BackStyle = __UI_Transparent

    __UI_NewID = __UI_NewControl(__UI_Type_Label, "FilesLB", 200, 23, 25, 75, __UI_GetID("OpenFrame"))
    SetCaption __UI_NewID, "&Files:"
    Control(__UI_NewID).BackStyle = __UI_Transparent

    __UI_NewID = __UI_NewControl(__UI_Type_ListBox, "FileList", 200, 150, 25, 99, __UI_GetID("OpenFrame"))
    Control(__UI_NewID).HasBorder = True
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_Label, "PathsLB", 200, 23, 242, 75, __UI_GetID("OpenFrame"))
    SetCaption __UI_NewID, "&Paths:"
    Control(__UI_NewID).BackStyle = __UI_Transparent

    __UI_NewID = __UI_NewControl(__UI_Type_ListBox, "DirList", 200, 150, 242, 99, __UI_GetID("OpenFrame"))
    Control(__UI_NewID).HasBorder = True
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_Button, "OpenBT", 80, 23, 274, 255, __UI_GetID("OpenFrame"))
    SetCaption __UI_NewID, "&Open"
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_Button, "CancelBT", 80, 23, 362, 255, __UI_GetID("OpenFrame"))
    SetCaption __UI_NewID, "&Cancel"
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_CheckBox, "ShowOnlyFrmbinFilesCB", 200, 23, 25, 255, __UI_GetID("OpenFrame"))
    SetCaption __UI_NewID, "Show only .frmbin files"
    Control(__UI_NewID).Value = -1
    Control(__UI_NewID).CanHaveFocus = True
    Control(__UI_NewID).BackStyle = __UI_Transparent
    
    '----------------------------------
    'Z-Ordering dialog:
    '----------------------------------
    __UI_NewID = __UI_NewControl(__UI_Type_Frame, "ZOrdering", 463, 289, -600, -500, 0)
    SetCaption __UI_NewID, "Z-Ordering"
    Control(__UI_NewID).HasBorder = True
    Control(__UI_NewID).BackColor = Darken(__UI_DefaultColor(__UI_Type_Form, 2), 105)

    __UI_NewID = __UI_NewControl(__UI_Type_ListBox, "ControlList", 379, 222, 25, 24, __UI_GetID("ZOrdering"))
    Control(__UI_NewID).HasBorder = True
    Control(__UI_NewID).CanHaveFocus = True
    Control(__UI_NewID).Font = SetFont("cour.ttf", 12, "monospace")

    __UI_NewID = __UI_NewControl(__UI_Type_Button, "UpBT", 40, 42, 413, 84, __UI_GetID("ZOrdering"))
    SetCaption __UI_NewID, "^"
    Control(__UI_NewID).Disabled = True

    __UI_NewID = __UI_NewControl(__UI_Type_Button, "DownBT", 40, 42, 413, 146, __UI_GetID("ZOrdering"))
    SetCaption __UI_NewID, "v"
    Control(__UI_NewID).Disabled = True

    __UI_NewID = __UI_NewControl(__UI_Type_Button, "CloseZOrderingBT", 80, 23, 192, 255, __UI_GetID("ZOrdering"))
    SetCaption __UI_NewID, "&Close"
    Control(__UI_NewID).CanHaveFocus = True

END SUB

SUB __UI_AssignIDs
    DialogBG = __UI_GetID("DialogBG")
    OpenFrame = __UI_GetID("OpenFrame")
    FileNameLB = __UI_GetID("FileNameLB")
    FileNameTextBox = __UI_GetID("FileNameTextBox")
    PathLB = __UI_GetID("PathLB")
    FilesLB = __UI_GetID("FilesLB")
    FileList = __UI_GetID("FileList")
    PathsLB = __UI_GetID("PathsLB")
    DirList = __UI_GetID("DirList")
    OpenBT = __UI_GetID("OpenBT")
    CancelBT = __UI_GetID("CancelBT")
    ShowOnlyFrmbinFilesCB = __UI_GetID("ShowOnlyFrmbinFilesCB")
    CloseZOrderingBT = __UI_GetID("CloseZOrderingBT")
    ZOrdering = __UI_GetID("ZOrdering")
    UpBT = __UI_GetID("UpBT")
    DownBT = __UI_GetID("DownBT")
    ControlList = __UI_GetID("ControlList")
    EditMenuUndo = __UI_GetID("EditMenuUndo")
    EditMenuRedo = __UI_GetID("EditMenuRedo")
    OptionsMenuSwapButtons = __UI_GetID("OptionsMenuSwapButtons")
END SUB
