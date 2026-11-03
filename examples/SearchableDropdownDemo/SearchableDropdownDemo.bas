': Searchable dropdown list demo for InForm-PE
': Copyright (c) 2026 Fellippe Heitor
': https://github.com/QB64-Phoenix-Edition/InForm-PE
'-----------------------------------------------------------

OPTION _EXPLICIT

': Controls' IDs: ------------------------------------------------------------------
DIM SHARED SearchableDropdownDemo AS LONG
DIM SHARED HelpLB AS LONG
DIM SHARED PartLB AS LONG
DIM SHARED PartsDD AS LONG
DIM SHARED PlainLB AS LONG
DIM SHARED PlainDD AS LONG
DIM SHARED ChosenLB AS LONG
DIM SHARED FuzzyCB AS LONG
DIM SHARED CloseBT AS LONG

': External modules: ---------------------------------------------------------------
'$INCLUDE:'../../InForm/InForm.bi'
'$INCLUDE:'SearchableDropdownDemo.frm'

': Event procedures: ---------------------------------------------------------------
SUB __UI_BeforeInit
END SUB

SUB __UI_OnLoad
    DIM part$

    RESTORE Parts
    DO
        READ part$
        IF part$ = "*" THEN EXIT DO
        AddItem PartsDD, part$
        AddItem PlainDD, part$
    LOOP
    Control(PartsDD).Value = 1
    Control(PlainDD).Value = 1
    ShowChoice PartsDD
    EXIT SUB

    Parts:
    DATA "Resistor 10k 1/4W","Resistor 22k 1/4W","Resistor 4.7k 1/2W","Resistor 100R 1W"
    DATA "Capacitor 10uF 25V electrolytic","Capacitor 100nF ceramic","Capacitor 22pF ceramic","Capacitor 470uF 16V electrolytic"
    DATA "Diode 1N4148 signal","Diode 1N4007 rectifier","LED red 5mm","LED green 5mm","LED blue 3mm"
    DATA "Transistor BC547 NPN","Transistor BC557 PNP","MOSFET IRF540N","Voltage regulator 7805 5V","Voltage regulator LM317 adjustable"
    DATA "Op-amp LM358 dual","Timer NE555","Crystal 16MHz","Push button 6mm","Potentiometer 10k linear","Potentiometer 100k log"
    DATA "*"
END SUB

SUB ShowChoice (id AS LONG)
    IF Control(id).Value > 0 THEN
        SetCaption ChosenLB, "Chosen: " + GetItem$(id, Control(id).Value)
    ELSE
        SetCaption ChosenLB, "Nothing chosen"
    END IF
END SUB

SUB __UI_BeforeUpdateDisplay
END SUB

SUB __UI_BeforeUnload
END SUB

SUB __UI_Click (id AS LONG)
    SELECT CASE id
        CASE FuzzyCB
            'Letters of each word may have others in between; best matches come first
            Control(PartsDD).Fuzzy = Control(FuzzyCB).Value
        CASE CloseBT
            SYSTEM
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
    id = id
END SUB

SUB __UI_TextChanged (id AS LONG)
    id = id
END SUB

SUB __UI_ValueChanged (id AS LONG)
    SELECT CASE id
        CASE PartsDD, PlainDD
            ShowChoice id
    END SELECT
END SUB

SUB __UI_FormResized
END SUB

'$INCLUDE:'../../InForm/InForm.ui'
