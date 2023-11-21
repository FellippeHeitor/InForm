': This form was generated by
': InForm - GUI library for QB64 - v1.5
': Fellippe Heitor, 2016-2023 - fellippe@qb64.org - @fellippeheitor
': https://github.com/FellippeHeitor/InForm
'-----------------------------------------------------------
SUB __UI_LoadForm

    DIM __UI_NewID AS LONG, __UI_RegisterResult AS LONG

    __UI_NewID = __UI_NewControl(__UI_Type_Form, "DuckShoot", 1240, 800, 0, 0, 0)
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "Duck Shoot"
    Control(__UI_NewID).Font = SetFont("segoeui.ttf", 12)
    Control(__UI_NewID).HasBorder = False

    __UI_NewID = __UI_NewControl(__UI_Type_Frame, "OptionsFR", 120, 160, 1120, 640, 0)
    __UI_RegisterResult = 0
    Control(__UI_NewID).HasBorder = True
    Control(__UI_NewID).Value = 4
    Control(__UI_NewID).BorderSize = 1

    __UI_NewID = __UI_NewControl(__UI_Type_Frame, "GameLevelFR", 100, 174, 1130, 454, 0)
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "Game Level"
    Control(__UI_NewID).HasBorder = True
    Control(__UI_NewID).Value = 6
    Control(__UI_NewID).BorderSize = 1

    __UI_NewID = __UI_NewControl(__UI_Type_Frame, "AudioFR", 100, 80, 1130, 360, 0)
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "Audio"
    Control(__UI_NewID).HasBorder = True
    Control(__UI_NewID).Value = 2
    Control(__UI_NewID).BorderSize = 1

    __UI_NewID = __UI_NewControl(__UI_Type_Frame, "SetKeysFR", 177, 109, 510, 325, 0)
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "Set Keys"
    Control(__UI_NewID).HasBorder = True
    Control(__UI_NewID).Value = 4
    Control(__UI_NewID).BorderSize = 1

    __UI_NewID = __UI_NewControl(__UI_Type_Frame, "LeftHandKeysFR", 150, 180, 510, 456, 0)
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "Left Hand Keys"
    Control(__UI_NewID).HasBorder = True
    Control(__UI_NewID).Value = 5
    Control(__UI_NewID).BorderSize = 1

    __UI_NewID = __UI_NewControl(__UI_Type_Frame, "RightHandKeysFR", 140, 150, 763, 456, 0)
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "Right Hand Keys"
    Control(__UI_NewID).HasBorder = True
    Control(__UI_NewID).Value = 4
    Control(__UI_NewID).BorderSize = 1

    __UI_NewID = __UI_NewControl(__UI_Type_Frame, "SelectKeyFR", 164, 80, 763, 325, 0)
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "Select Key"
    Control(__UI_NewID).HasBorder = True
    Control(__UI_NewID).Value = 3
    Control(__UI_NewID).BorderSize = 1

    __UI_NewID = __UI_NewControl(__UI_Type_Button, "ExitBT", 80, 23, 20, 120, __UI_GetID("OptionsFR"))
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "Exit"
    Control(__UI_NewID).HasBorder = False
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_Button, "ResetBT", 80, 23, 20, 85, __UI_GetID("OptionsFR"))
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "Reset"
    Control(__UI_NewID).HasBorder = False
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_Button, "SetKeysBT", 80, 23, 20, 15, __UI_GetID("OptionsFR"))
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "Set Keys"
    Control(__UI_NewID).HasBorder = False
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_RadioButton, "Level1RB", 80, 23, 12, 15, __UI_GetID("GameLevelFR"))
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "Level 1"
    Control(__UI_NewID).HasBorder = False
    Control(__UI_NewID).Value = -1
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_RadioButton, "Level2RB", 80, 23, 12, 40, __UI_GetID("GameLevelFR"))
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "Level 2"
    Control(__UI_NewID).HasBorder = False
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_RadioButton, "Level3RB", 80, 23, 12, 65, __UI_GetID("GameLevelFR"))
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "Level 3"
    Control(__UI_NewID).HasBorder = False
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_RadioButton, "Level4RB", 80, 23, 12, 90, __UI_GetID("GameLevelFR"))
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "Level 4"
    Control(__UI_NewID).HasBorder = False
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_RadioButton, "Level5RB", 80, 23, 12, 115, __UI_GetID("GameLevelFR"))
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "Level 5"
    Control(__UI_NewID).HasBorder = False
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_RadioButton, "Level6RB", 80, 23, 12, 140, __UI_GetID("GameLevelFR"))
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "Level 6"
    Control(__UI_NewID).HasBorder = False
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_RadioButton, "AudioOffRB", 80, 23, 12, 15, __UI_GetID("AudioFR"))
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "Audio Off"
    Control(__UI_NewID).HasBorder = False
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_RadioButton, "AudioOnRB", 80, 23, 12, 40, __UI_GetID("AudioFR"))
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "Audio On"
    Control(__UI_NewID).HasBorder = False
    Control(__UI_NewID).Value = -1
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_Button, "RestartLevelBT", 80, 23, 20, 50, __UI_GetID("OptionsFR"))
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "Restart Level"
    Control(__UI_NewID).HasBorder = False
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_RadioButton, "SetLeftHandKeysRB", 134, 23, 15, 15, __UI_GetID("SetKeysFR"))
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "Set Left Hand Keys"
    Control(__UI_NewID).HasBorder = False
    Control(__UI_NewID).Value = -1
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_RadioButton, "SetRightHandKeysRB", 134, 23, 15, 45, __UI_GetID("SetKeysFR"))
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "Set Right Hand Keys"
    Control(__UI_NewID).HasBorder = False
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_RadioButton, "FarSightUpRB", 100, 23, 15, 15, __UI_GetID("RightHandKeysFR"))
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "Far Sight Up"
    Control(__UI_NewID).HasBorder = False
    Control(__UI_NewID).Value = -1
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_RadioButton, "FarSightLeftRB", 100, 23, 15, 45, __UI_GetID("RightHandKeysFR"))
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "Far Sight Left"
    Control(__UI_NewID).HasBorder = False
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_RadioButton, "FarSightRightRB", 110, 23, 15, 75, __UI_GetID("RightHandKeysFR"))
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "Far Sight Right"
    Control(__UI_NewID).HasBorder = False
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_RadioButton, "FarSightDownRB", 110, 23, 15, 105, __UI_GetID("RightHandKeysFR"))
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "Far Sight Down"
    Control(__UI_NewID).HasBorder = False
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_RadioButton, "NearSightUpRB", 110, 23, 15, 15, __UI_GetID("LeftHandKeysFR"))
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "Near Sight Up"
    Control(__UI_NewID).HasBorder = False
    Control(__UI_NewID).Value = -1
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_RadioButton, "NearSightLeftRB", 110, 23, 15, 45, __UI_GetID("LeftHandKeysFR"))
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "Near Sight Left"
    Control(__UI_NewID).HasBorder = False
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_RadioButton, "NearSightRightRB", 120, 23, 15, 75, __UI_GetID("LeftHandKeysFR"))
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "Near Sight Right"
    Control(__UI_NewID).HasBorder = False
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_RadioButton, "NearSightDownRB", 120, 23, 15, 105, __UI_GetID("LeftHandKeysFR"))
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "Near Sight Down"
    Control(__UI_NewID).HasBorder = False
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_RadioButton, "FireRB", 60, 23, 15, 135, __UI_GetID("LeftHandKeysFR"))
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "Fire"
    Control(__UI_NewID).HasBorder = False
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_DropdownList, "SelectKeyDD", 60, 23, 15, 45, __UI_GetID("SelectKeyFR"))
    __UI_RegisterResult = 0
    Control(__UI_NewID).Font = SetFont("segoeui.ttf", 14)
    Control(__UI_NewID).HasBorder = True
    Control(__UI_NewID).CanHaveFocus = True
    Control(__UI_NewID).BorderSize = 1

    __UI_NewID = __UI_NewControl(__UI_Type_Label, "SelectKeyLB", 140, 23, 15, 15, __UI_GetID("SelectKeyFR"))
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "Select Key (Currently w):"
    Control(__UI_NewID).HasBorder = False
    Control(__UI_NewID).VAlign = __UI_Middle

    __UI_NewID = __UI_NewControl(__UI_Type_Button, "DoneBT", 50, 23, 110, 75, __UI_GetID("SetKeysFR"))
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "Done"
    Control(__UI_NewID).HasBorder = False
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_Button, "SetBT", 50, 23, 98, 45, __UI_GetID("SelectKeyFR"))
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "Set"
    Control(__UI_NewID).HasBorder = False
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_Button, "DefaultBT", 70, 23, 20, 75, __UI_GetID("SetKeysFR"))
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "Default"
    Control(__UI_NewID).HasBorder = False
    Control(__UI_NewID).CanHaveFocus = True

END SUB

SUB __UI_AssignIDs
    DuckShoot = __UI_GetID("DuckShoot")
    OptionsFR = __UI_GetID("OptionsFR")
    GameLevelFR = __UI_GetID("GameLevelFR")
    AudioFR = __UI_GetID("AudioFR")
    SetKeysFR = __UI_GetID("SetKeysFR")
    LeftHandKeysFR = __UI_GetID("LeftHandKeysFR")
    RightHandKeysFR = __UI_GetID("RightHandKeysFR")
    SelectKeyFR = __UI_GetID("SelectKeyFR")
    ExitBT = __UI_GetID("ExitBT")
    ResetBT = __UI_GetID("ResetBT")
    SetKeysBT = __UI_GetID("SetKeysBT")
    Level1RB = __UI_GetID("Level1RB")
    Level2RB = __UI_GetID("Level2RB")
    Level3RB = __UI_GetID("Level3RB")
    Level4RB = __UI_GetID("Level4RB")
    Level5RB = __UI_GetID("Level5RB")
    Level6RB = __UI_GetID("Level6RB")
    AudioOffRB = __UI_GetID("AudioOffRB")
    AudioOnRB = __UI_GetID("AudioOnRB")
    RestartLevelBT = __UI_GetID("RestartLevelBT")
    SetLeftHandKeysRB = __UI_GetID("SetLeftHandKeysRB")
    SetRightHandKeysRB = __UI_GetID("SetRightHandKeysRB")
    FarSightUpRB = __UI_GetID("FarSightUpRB")
    FarSightLeftRB = __UI_GetID("FarSightLeftRB")
    FarSightRightRB = __UI_GetID("FarSightRightRB")
    FarSightDownRB = __UI_GetID("FarSightDownRB")
    NearSightUpRB = __UI_GetID("NearSightUpRB")
    NearSightLeftRB = __UI_GetID("NearSightLeftRB")
    NearSightRightRB = __UI_GetID("NearSightRightRB")
    NearSightDownRB = __UI_GetID("NearSightDownRB")
    FireRB = __UI_GetID("FireRB")
    SelectKeyDD = __UI_GetID("SelectKeyDD")
    SelectKeyLB = __UI_GetID("SelectKeyLB")
    DoneBT = __UI_GetID("DoneBT")
    SetBT = __UI_GetID("SetBT")
    DefaultBT = __UI_GetID("DefaultBT")
END SUB