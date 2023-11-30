': This program uses
': InForm - GUI library for QB64 - v1.0
': Fellippe Heitor, 2016-2019 - fellippe@qb64.org - @fellippeheitor
': https://github.com/FellippeHeitor/InForm
'-----------------------------------------------------------

OPTION _EXPLICIT

DIM SHARED ThisTurn AS _BYTE

': Controls' IDs: ------------------------------------------------------------------
DIM SHARED TicTacToe2 AS LONG
DIM SHARED Button1 AS LONG
DIM SHARED Button2 AS LONG
DIM SHARED Button3 AS LONG
DIM SHARED Button4 AS LONG
DIM SHARED Button5 AS LONG
DIM SHARED Button6 AS LONG
DIM SHARED Button7 AS LONG
DIM SHARED Button8 AS LONG
DIM SHARED Button9 AS LONG

': External modules: ---------------------------------------------------------------
'$INCLUDE:'../../InForm/extensions/MessageBox.bi'
'$INCLUDE:'../../InForm/InForm.bi'
'$INCLUDE:'TicTacToe2.frm'
'$INCLUDE:'../../InForm/xp.uitheme'
'$INCLUDE:'../../InForm/InForm.ui'
'$INCLUDE:'../../InForm/extensions/MessageBox.bas'

': Event procedures: ---------------------------------------------------------------
SUB __UI_BeforeInit

END SUB

SUB __UI_OnLoad
    ThisTurn = 1
END SUB

SUB __UI_BeforeUpdateDisplay

END SUB

SUB __UI_BeforeUnload

END SUB

SUB __UI_Click (id AS LONG)
    IF Control(id).Type = __UI_Type_Label THEN
        IF Control(id).Value = 0 THEN
            Control(id).Value = ThisTurn
            IF ThisTurn = 1 THEN
                Caption(id) = "X": ThisTurn = 2
                Control(id).ForeColor = _RGB32(255, 255, 255)
                Control(id).BackColor = _RGB32(200, 0, 0)
            ELSE
                Caption(id) = "O": ThisTurn = 1
                Control(id).BackColor = _RGB32(0, 200, 0)
            END IF
            CheckVictory
        END IF
    END IF
END SUB

SUB CheckVictory
    DIM Winner AS _BYTE

    IF Control(Button1).Value = Control(Button2).Value AND Control(Button2).Value = Control(Button3).Value THEN
        Winner = Control(Button1).Value
    ELSEIF Control(Button4).Value = Control(Button5).Value AND Control(Button5).Value = Control(Button6).Value THEN
        Winner = Control(Button4).Value
    ELSEIF Control(Button7).Value = Control(Button8).Value AND Control(Button8).Value = Control(Button9).Value THEN
        Winner = Control(Button7).Value
    ELSEIF Control(Button1).Value = Control(Button4).Value AND Control(Button4).Value = Control(Button7).Value THEN
        Winner = Control(Button1).Value
    ELSEIF Control(Button2).Value = Control(Button5).Value AND Control(Button5).Value = Control(Button8).Value THEN
        Winner = Control(Button2).Value
    ELSEIF Control(Button3).Value = Control(Button6).Value AND Control(Button6).Value = Control(Button9).Value THEN
        Winner = Control(Button3).Value
    ELSEIF Control(Button1).Value = Control(Button5).Value AND Control(Button5).Value = Control(Button9).Value THEN
        Winner = Control(Button1).Value
    ELSEIF Control(Button7).Value = Control(Button5).Value AND Control(Button5).Value = Control(Button3).Value THEN
        Winner = Control(Button7).Value
    END IF

    IF Winner > 0 THEN
        MessageBox "Player" + STR$(Winner) + " won!", "Tic Tac Toe", MsgBox_OkOnly + MsgBox_Information
        SYSTEM
    END IF
END SUB

SUB __UI_MouseEnter (id AS LONG)
    IF Control(id).Type = __UI_Type_Label THEN
        IF Control(id).Value = 0 THEN
            Control(id).BackColor = _RGB32(44, 94, 128)
        END IF
    END IF
END SUB

SUB __UI_MouseLeave (id AS LONG)
    IF Control(id).Type = __UI_Type_Label THEN
        IF Control(id).Value = 0 THEN
            Control(id).BackColor = _RGB32(127, 170, 255)
        END IF
    END IF
END SUB

SUB __UI_FocusIn (id AS LONG)
    SELECT CASE id
    END SELECT
END SUB

SUB __UI_FocusOut (id AS LONG)
    SELECT CASE id
    END SELECT
END SUB

SUB __UI_MouseDown (id AS LONG)
    SELECT CASE id
        CASE TicTacToe2

        CASE Button1

        CASE Button2

        CASE Button3

        CASE Button4

        CASE Button5

        CASE Button6

        CASE Button7

        CASE Button8

        CASE Button9

    END SELECT
END SUB

SUB __UI_MouseUp (id AS LONG)
    SELECT CASE id
        CASE TicTacToe2

        CASE Button1

        CASE Button2

        CASE Button3

        CASE Button4

        CASE Button5

        CASE Button6

        CASE Button7

        CASE Button8

        CASE Button9

    END SELECT
END SUB

SUB __UI_KeyPress (id AS LONG)
    SELECT CASE id
    END SELECT
END SUB

SUB __UI_TextChanged (id AS LONG)
    SELECT CASE id
    END SELECT
END SUB

SUB __UI_ValueChanged (id AS LONG)
    SELECT CASE id
    END SELECT
END SUB

SUB __UI_FormResized
END SUB
