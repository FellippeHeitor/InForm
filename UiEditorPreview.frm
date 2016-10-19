'InForm - GUI system for QB64
'Fellippe Heitor, 2016 - fellippe@qb64.org - @fellippeheitor
'Beta version 1
SUB __UI_LoadForm
    DIM __UI_NewID AS LONG

    __UI_NewID = __UI_NewControl(__UI_Type_Form, "Form1", 640, 400, 0, 0,0)
    __UI_Controls(__UI_NewID).CanResize = __UI_True
END SUB
