': This program uses
': InForm - GUI library for QB64 - v1.2
': Fellippe Heitor, 2016-2020 - fellippe@qb64.org - @fellippeheitor
': https://github.com/FellippeHeitor/InForm
'-----------------------------------------------------------

': Controls' IDs: ------------------------------------------------------------------
DIM SHARED Game AS LONG
DIM SHARED WELCOMELB AS LONG
DIM SHARED GAMELB AS LONG
DIM SHARED Frame1 AS LONG
DIM SHARED Choose1BT AS LONG
DIM SHARED Choose2BT AS LONG
DIM SHARED Choose3BT AS LONG
DIM SHARED ProgressBar1 AS LONG
DIM SHARED MoveFirstRB AS LONG
DIM SHARED MoveAfterRB AS LONG
DIM SHARED AtRandomRB AS LONG
DIM SHARED MessageLB AS LONG ' added for better output and starting help7

'---------------------- GLOBAL SHARED VARIABLES OF USER-----------
RANDOMIZE TIMER
CONST Player = 1, CPU = 2
DIM SHARED Total AS INTEGER, Turn AS INTEGER, Time AS SINGLE, Help AS STRING, WinTime AS SINGLE
Help = "Click on 21GAME to play. The winner is who gets 21 adding 1 or 2 or 3 to the actual sum. Good Luck!"
Turn = 0
Time = TIMER

': External modules: ---------------------------------------------------------------
'$INCLUDE:'../../InForm/InForm.bi'
'$INCLUDE:'21-game.frm'
'$INCLUDE:'../../InForm/InForm.ui'

'------------------- User's SUB/FUNCTIONs-----------------------
SUB chooseAI
    IF Total >= 21 THEN EXIT SUB
    IF Total < 16 THEN Total = Total + INT(RND * 2) + 1 ELSE IF Total = 16 THEN Total = Total + 1 ELSE Total = Total + (21 - Total)
END SUB

SUB ChangeColor
    Control(GAMELB).ForeColor = _RGB32(RND * 255, RND * 255, RND * 255, 255)
END SUB

': Event procedures: ---------------------------------------------------------------
SUB __UI_BeforeInit

END SUB

SUB __UI_OnLoad
    Control(Choose1BT).Disabled = True
    Control(Choose2BT).Disabled = True
    Control(Choose3BT).Disabled = True
    Control(ProgressBar1).Min = 0
    Control(ProgressBar1).Max = 21
    Control(ProgressBar1).Disabled = True
    Control(AtRandomRB).Value = -1
    Control(MoveFirstRB).Value = 0
    Control(MoveAfterRB).Value = 0
    SetCaption MessageLB, Help
    Total = 21
    WinTime = 100
END SUB

SUB __UI_BeforeUpdateDisplay
    'This event occurs at approximately 30 frames per second.
    'You can change the update frequency by calling SetFrameRate DesiredRate%
    STATIC sizes AS INTEGER
    ' it must adjourn the color of label
    IF (TIMER - Time) >= .5 THEN
        ChangeColor
        IF sizes < 26 THEN sizes = 26 ELSE sizes = 24
        Control(GAMELB).Font = SetFont("Segoeui.ttf", sizes)
        Time = TIMER
    END IF
    ' adjourn progression bar
    Control(ProgressBar1).Value = Total
    Caption(ProgressBar1) = _TRIM$(STR$(Total))
    SetCaption MessageLB, "Total " + STR$(Total)
    IF Total >= 21 THEN
        'game over
        Control(MoveFirstRB).Disabled = False
        Control(MoveAfterRB).Disabled = False
        Control(AtRandomRB).Disabled = False
        Control(Choose1BT).Disabled = True
        Control(Choose2BT).Disabled = True
        Control(Choose3BT).Disabled = True
        IF Turn = Player THEN
            Caption(GAMELB) = " YOU WIN! "
        ELSEIF Turn = CPU THEN
            Caption(GAMELB) = " AI WIN! "
        END IF
        IF WinTime = 0 THEN WinTime = TIMER

        IF 2.0 <= TIMER - WinTime THEN
            SetCaption MessageLB, Help
            WinTime = 100
            Caption(GAMELB) = " 21 GAME "
        END IF
    END IF


END SUB

SUB __UI_BeforeUnload
    'If you set __UI_UnloadSignal = False here you can
    'cancel the user's request to close.

END SUB

SUB __UI_Click (id AS LONG)
    SELECT CASE id
        CASE Game

        CASE WELCOMELB

        CASE GAMELB
            IF WinTime = 100 THEN
                ' here it activates control buttons to play
                IF Control(Choose1BT).Disabled = True THEN Control(Choose1BT).Disabled = False
                IF Control(Choose2BT).Disabled = True THEN Control(Choose2BT).Disabled = False
                IF Control(Choose3BT).Disabled = True THEN Control(Choose3BT).Disabled = False
                Total = 0 ' it starts again the game zeroing the variable
                Control(ProgressBar1).Value = Total
                ' Does who start first?
                IF Control(MoveFirstRB).Value = -1 THEN
                    Turn = Player
                ELSEIF Control(MoveAfterRB).Value = -1 THEN
                    Turn = CPU
                ELSEIF Control(AtRandomRB).Value = -1 THEN
                    Turn = INT(RND * 1) + 1
                END IF
                IF Control(MoveFirstRB).Disabled = False THEN
                    Control(MoveFirstRB).Disabled = True
                    Control(MoveAfterRB).Disabled = True
                    Control(AtRandomRB).Disabled = True
                END IF
                IF Turn = CPU THEN chooseAI: Turn = Player
                Caption(GAMELB) = " 21 GAME "
                WinTime = 0
            END IF
        CASE Frame1

        CASE Choose1BT
            IF Turn = Player THEN
                Total = Total + 1
                IF Total >= 21 THEN EXIT SUB
                Turn = CPU
                __UI_Delay .5
                chooseAI
                IF Total >= 21 THEN EXIT SUB
                Turn = Player
            END IF
        CASE Choose2BT
            IF Turn = Player THEN
                Total = Total + 2
                IF Total >= 21 THEN EXIT SUB
                Turn = CPU
                __UI_Delay .5
                chooseAI
                IF Total >= 21 THEN EXIT SUB
                Turn = Player
            END IF
        CASE Choose3BT
            IF Turn = Player THEN
                Total = Total + 3
                IF Total >= 21 THEN EXIT SUB
                Turn = CPU
                __UI_Delay .5
                chooseAI
                IF Total >= 21 THEN EXIT SUB
                Turn = Player
            END IF
        CASE ProgressBar1

        CASE MoveFirstRB

        CASE MoveAfterRB

        CASE AtRandomRB

    END SELECT
END SUB

SUB __UI_MouseEnter (id AS LONG)
    SELECT CASE id
        CASE Game

        CASE WELCOMELB

        CASE GAMELB

        CASE Frame1

        CASE Choose1BT

        CASE Choose2BT

        CASE Choose3BT

        CASE ProgressBar1

        CASE MoveFirstRB

        CASE MoveAfterRB

        CASE AtRandomRB

    END SELECT
END SUB

SUB __UI_MouseLeave (id AS LONG)
    SELECT CASE id
        CASE Game

        CASE WELCOMELB

        CASE GAMELB

        CASE Frame1

        CASE Choose1BT

        CASE Choose2BT

        CASE Choose3BT

        CASE ProgressBar1

        CASE MoveFirstRB

        CASE MoveAfterRB

        CASE AtRandomRB

    END SELECT
END SUB

SUB __UI_FocusIn (id AS LONG)
    SELECT CASE id
        CASE Choose1BT

        CASE Choose2BT

        CASE Choose3BT

        CASE MoveFirstRB

        CASE MoveAfterRB

        CASE AtRandomRB

    END SELECT
END SUB

SUB __UI_FocusOut (id AS LONG)
    'This event occurs right before a control loses focus.
    'To prevent a control from losing focus, set __UI_KeepFocus = True below.
    SELECT CASE id
        CASE Choose1BT

        CASE Choose2BT

        CASE Choose3BT

        CASE MoveFirstRB

        CASE MoveAfterRB

        CASE AtRandomRB

    END SELECT
END SUB

SUB __UI_MouseDown (id AS LONG)
    SELECT CASE id
        CASE Game

        CASE WELCOMELB

        CASE GAMELB

        CASE Frame1

        CASE Choose1BT

        CASE Choose2BT

        CASE Choose3BT

        CASE ProgressBar1

        CASE MoveFirstRB

        CASE MoveAfterRB

        CASE AtRandomRB

    END SELECT
END SUB

SUB __UI_MouseUp (id AS LONG)
    SELECT CASE id
        CASE Game

        CASE WELCOMELB

        CASE GAMELB

        CASE Frame1

        CASE Choose1BT

        CASE Choose2BT

        CASE Choose3BT

        CASE ProgressBar1

        CASE MoveFirstRB

        CASE MoveAfterRB

        CASE AtRandomRB

    END SELECT
END SUB

SUB __UI_KeyPress (id AS LONG)
    'When this event is fired, __UI_KeyHit will contain the code of the key hit.
    'You can change it and even cancel it by making it = 0
    SELECT CASE id
        CASE Choose1BT

        CASE Choose2BT

        CASE Choose3BT

        CASE MoveFirstRB

        CASE MoveAfterRB

        CASE AtRandomRB

    END SELECT
END SUB

SUB __UI_TextChanged (id AS LONG)
    SELECT CASE id
        CASE ELSE
    END SELECT
END SUB

SUB __UI_ValueChanged (id AS LONG)
    SELECT CASE id
        CASE MoveFirstRB

        CASE MoveAfterRB

        CASE AtRandomRB

    END SELECT
END SUB

SUB __UI_FormResized

END SUB
