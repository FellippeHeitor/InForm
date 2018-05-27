': This form was generated by
': InForm - GUI library for QB64 - Beta version 7
': Fellippe Heitor, 2016-2018 - fellippe@qb64.org - @fellippeheitor
': https://github.com/FellippeHeitor/InForm
'-----------------------------------------------------------
SUB __UI_LoadForm

    $EXEICON:'./../resources/updater.ico'

    DIM __UI_NewID AS LONG

    __UI_NewID = __UI_NewControl(__UI_Type_Form, "InFormSetup", 500, 425, 0, 0, 0)
    SetCaption __UI_NewID, "InForm Setup"
    Control(__UI_NewID).Stretch = False
    Control(__UI_NewID).Font = SetFont("segoeui.ttf?arial.ttf?/Library/Fonts/Arial.ttf?/usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf?/usr/share/fonts/TTF/arial.ttf?InForm/resources/NotoMono-Regular.ttf?cour.ttf", 12)
    Control(__UI_NewID).CenteredWindow = True

    __UI_NewID = __UI_NewControl(__UI_Type_PictureBox, "PictureBox2", 500, 150, 0, 0, 0)
    Control(__UI_NewID).Stretch = True
    Control(__UI_NewID).BackColor = _RGB32(255, 255, 255)
    Control(__UI_NewID).Align = __UI_Center
    Control(__UI_NewID).VAlign = __UI_Middle

    __UI_NewID = __UI_NewControl(__UI_Type_PictureBox, "InFormresourcesApplicationicon128PX", 128, 128, 10, 11, 0)
    Control(__UI_NewID).Stretch = True
    Control(__UI_NewID).BackStyle = __UI_Transparent
    Control(__UI_NewID).Align = __UI_Center
    Control(__UI_NewID).VAlign = __UI_Middle

    __UI_NewID = __UI_NewControl(__UI_Type_Label, "InFormLB", 258, 90, 199, 22, 0)
    SetCaption __UI_NewID, "InForm"
    Control(__UI_NewID).Stretch = False
    Control(__UI_NewID).Font = SetFont("segoeui.ttf?arial.ttf?/Library/Fonts/Arial.ttf?/usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf?/usr/share/fonts/TTF/arial.ttf?InForm/resources/NotoMono-Regular.ttf?cour.ttf", 72)
    Control(__UI_NewID).BackStyle = __UI_Transparent
    Control(__UI_NewID).VAlign = __UI_Middle

    __UI_NewID = __UI_NewControl(__UI_Type_Label, "forQB64LB", 152, 43, 305, 88, 0)
    SetCaption __UI_NewID, "for QB64"
    Control(__UI_NewID).Stretch = False
    Control(__UI_NewID).Font = SetFont("segoeui.ttf?arial.ttf?/Library/Fonts/Arial.ttf?/usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf?/usr/share/fonts/TTF/arial.ttf?InForm/resources/NotoMono-Regular.ttf?cour.ttf", 32)
    Control(__UI_NewID).BackStyle = __UI_Transparent
    Control(__UI_NewID).VAlign = __UI_Middle

    __UI_NewID = __UI_NewControl(__UI_Type_ListBox, "ListBox1", 480, 224, 10, 159, 0)
    Control(__UI_NewID).Stretch = False
    Control(__UI_NewID).HasBorder = True
    Control(__UI_NewID).CanHaveFocus = True
    Control(__UI_NewID).AutoScroll = True
    
    __UI_NewID = __UI_NewControl(__UI_Type_Button, "RetryBT", 80, 23, 10, 392, 0)
    SetCaption __UI_NewID, "&Retry"
    Control(__UI_NewID).Stretch = False
    Control(__UI_NewID).CanHaveFocus = True
    Control(__UI_NewID).Hidden = True

    __UI_NewID = __UI_NewControl(__UI_Type_Button, "CancelBT", 80, 23, 410, 392, 0)
    SetCaption __UI_NewID, "&Cancel"
    Control(__UI_NewID).Stretch = False
    Control(__UI_NewID).CanHaveFocus = True

    __UI_NewID = __UI_NewControl(__UI_Type_PictureBox, "ActivityIndicator", 266, 32, 117, 388, 0)
    Control(__UI_NewID).Stretch = True
    Control(__UI_NewID).Align = __UI_Center
    Control(__UI_NewID).VAlign = __UI_Middle

END SUB

SUB __UI_AssignIDs
    InFormSetup = __UI_GetID("InFormSetup")
    PictureBox2 = __UI_GetID("PictureBox2")
    InFormresourcesApplicationicon128PX = __UI_GetID("InFormresourcesApplicationicon128PX")
    InFormLB = __UI_GetID("InFormLB")
    forQB64LB = __UI_GetID("forQB64LB")
    ListBox1 = __UI_GetID("ListBox1")
    RetryBT = __UI_GetID("RetryBT")
    CancelBT = __UI_GetID("CancelBT")
    ActivityIndicator = __UI_GetID("ActivityIndicator")
END SUB