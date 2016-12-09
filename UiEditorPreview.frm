'InForm - GUI system for QB64 - Beta version 1
'Fellippe Heitor, 2016 - fellippe@qb64.org - @fellippeheitor
'-----------------------------------------------------------
SUB __UI_LoadForm
    DIM __UI_NewID AS LONG

    $RESIZE:ON
    _RESIZE OFF

    __UI_NewID = __UI_NewControl(__UI_Type_Form, "Form1", 300, 300, 0, 0,0)
    Control(__UI_NewID).Font = SetFont("segoeui.ttf", 12, "")
END SUB

SUB __UI_AssignIDs

END SUB

