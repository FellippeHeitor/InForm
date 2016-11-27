'InForm - GUI system for QB64 - Beta version 1
'Fellippe Heitor, 2016 - fellippe@qb64.org - @fellippeheitor
'-----------------------------------------------------------
SUB __UI_LoadForm
    DIM __UI_NewID AS LONG

    __UI_NewID = __UI_NewControl(__UI_Type_Form, "Form1", 640, 400, 0, 0,0)
    __UI_Controls(__UI_NewID).Font = __UI_Font("segoeui.ttf", 12, "")
END SUB
