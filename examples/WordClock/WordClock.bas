': This program uses
': InForm - GUI library for QB64 - v1.0
': Fellippe Heitor, 2016-2019 - fellippe@qb64.org - @fellippeheitor
': https://github.com/FellippeHeitor/InForm
'-----------------------------------------------------------

OPTION _EXPLICIT

': Controls' IDs: ------------------------------------------------------------------
DIM SHARED WordClock AS LONG
DIM SHARED ITISLB AS LONG
DIM SHARED HALFLB AS LONG
DIM SHARED TENLB AS LONG
DIM SHARED QUARTERLB AS LONG
DIM SHARED TWENTYLB AS LONG
DIM SHARED FIVELB AS LONG
DIM SHARED MINUTESLB AS LONG
DIM SHARED TOLB AS LONG
DIM SHARED PASTLB AS LONG
DIM SHARED TWOLB AS LONG
DIM SHARED THREELB AS LONG
DIM SHARED ONELB AS LONG
DIM SHARED FOURLB AS LONG
DIM SHARED FIVELB2 AS LONG
DIM SHARED SIXLB AS LONG
DIM SHARED SEVENLB AS LONG
DIM SHARED EIGHTLB AS LONG
DIM SHARED NINELB AS LONG
DIM SHARED TENLB2 AS LONG
DIM SHARED ELEVENLB AS LONG
DIM SHARED TWELVELB AS LONG
DIM SHARED OCLOCKLB AS LONG
DIM SHARED BackDots AS LONG
DIM SHARED DotsLB AS LONG

DIM SHARED Word(1 TO 22) AS LONG

': External modules: ---------------------------------------------------------------
'$INCLUDE:'../../InForm/InForm.bi'
'$INCLUDE:'WordClock.frm'
'$INCLUDE:'../../InForm/InForm.ui'

': Event procedures: ---------------------------------------------------------------
SUB __UI_BeforeInit

END SUB

SUB __UI_OnLoad
    Word(1) = ITISLB
    Word(2) = HALFLB
    Word(3) = TENLB
    Word(4) = QUARTERLB
    Word(5) = TWENTYLB
    Word(6) = FIVELB
    Word(7) = MINUTESLB
    Word(8) = TOLB
    Word(9) = PASTLB
    Word(10) = TWOLB
    Word(11) = THREELB
    Word(12) = ONELB
    Word(13) = FOURLB
    Word(14) = FIVELB2
    Word(15) = SIXLB
    Word(16) = SEVENLB
    Word(17) = EIGHTLB
    Word(18) = NINELB
    Word(19) = TENLB2
    Word(20) = ELEVENLB
    Word(21) = TWELVELB
    Word(22) = OCLOCKLB
END SUB

SUB __UI_BeforeUpdateDisplay
    'This event occurs at approximately 30 frames per second.
    'You can change the update frequency by calling SetFrameRate DesiredRate%

    DIM i AS INTEGER, h AS INTEGER, m AS INTEGER
    DIM dots AS INTEGER
    STATIC prevH AS INTEGER, prevM AS INTEGER

    h = VAL(LEFT$(TIME$, 2))
    m = VAL(MID$(TIME$, 4, 2))

    IF h = prevH AND m = prevM THEN EXIT SUB

    prevH = h
    prevM = m
    switchOffAllWords

    switchOn ITISLB
    switchOn MINUTESLB
    SELECT CASE m
        CASE 0 TO 4
            switchOn OCLOCKLB
            switchOff MINUTESLB
            dots = m
        CASE 5 TO 9
            switchOn FIVELB
            switchOn PASTLB
            dots = m - 5
        CASE 10 TO 14
            switchOn TENLB
            switchOn PASTLB
            dots = m - 10
        CASE 15 TO 19
            switchOn QUARTERLB
            switchOff MINUTESLB
            switchOn PASTLB
            dots = m - 15
        CASE 20 TO 24
            switchOn TWENTYLB
            switchOn PASTLB
            dots = m - 20
        CASE 25 TO 29
            switchOn TWENTYLB
            switchOn FIVELB
            switchOn PASTLB
            dots = m - 25
        CASE 30 TO 34
            switchOn HALFLB
            switchOff MINUTESLB
            switchOn PASTLB
            dots = m - 30
        CASE 35 TO 39
            switchOn TWENTYLB
            switchOn FIVELB
            switchOn TOLB
            dots = m - 35
        CASE 40 TO 44
            switchOn TWENTYLB
            switchOn TOLB
            dots = m - 40
        CASE 45 TO 49
            switchOn QUARTERLB
            switchOff MINUTESLB
            switchOn TOLB
            dots = m - 45
        CASE 50 TO 54
            switchOn TENLB
            switchOn TOLB
            dots = m - 50
        CASE 55 TO 59
            switchOn FIVELB
            switchOn TOLB
            dots = m - 55
    END SELECT

    Caption(DotsLB) = ""
    FOR i = 1 TO dots
        Caption(DotsLB) = Caption(DotsLB) + "* "
    NEXT

    IF m >= 35 THEN
        h = h + 1
    END IF

    SELECT CASE h
        CASE 1, 13
            switchOn ONELB
        CASE 2, 14
            switchOn TWOLB
        CASE 3, 15
            switchOn THREELB
        CASE 4, 16
            switchOn FOURLB
        CASE 5, 17
            switchOn FIVELB2
        CASE 6, 18
            switchOn SIXLB
        CASE 7, 19
            switchOn SEVENLB
        CASE 8, 20
            switchOn EIGHTLB
        CASE 9, 21
            switchOn NINELB
        CASE 10, 22
            switchOn TENLB2
        CASE 11, 23
            switchOn ELEVENLB
        CASE 0, 12
            switchOn TWELVELB
    END SELECT
END SUB

SUB switchOffAllWords
    DIM i AS INTEGER
    FOR i = 1 TO UBOUND(Word)
        switchOff Word(i)
    NEXT
END SUB

SUB switchOn (this AS LONG)
    Control(this).ForeColor = _RGB32(111, 205, 0)
    Control(this).Redraw = TRUE
END SUB

SUB switchOff (this AS LONG)
    Control(this).ForeColor = _RGB32(0, 39, 0)
    Control(this).Redraw = TRUE
END SUB

SUB __UI_BeforeUnload
    'If you set __UI_UnloadSignal = False here you can
    'cancel the user's request to close.

END SUB

SUB __UI_Click (id AS LONG)
    SELECT CASE id
        CASE WordClock

        CASE ITISLB

        CASE HALFLB

        CASE TENLB

        CASE QUARTERLB

        CASE TWENTYLB

        CASE FIVELB

        CASE MINUTESLB

        CASE TOLB

        CASE PASTLB

        CASE TWOLB

        CASE THREELB

        CASE ONELB

        CASE FOURLB

        CASE FIVELB2

        CASE SIXLB

        CASE SEVENLB

        CASE EIGHTLB

        CASE NINELB

        CASE TENLB2

        CASE ELEVENLB

        CASE TWELVELB

        CASE OCLOCKLB

    END SELECT
END SUB

SUB __UI_MouseEnter (id AS LONG)
    SELECT CASE id
        CASE WordClock

        CASE ITISLB

        CASE HALFLB

        CASE TENLB

        CASE QUARTERLB

        CASE TWENTYLB

        CASE FIVELB

        CASE MINUTESLB

        CASE TOLB

        CASE PASTLB

        CASE TWOLB

        CASE THREELB

        CASE ONELB

        CASE FOURLB

        CASE FIVELB2

        CASE SIXLB

        CASE SEVENLB

        CASE EIGHTLB

        CASE NINELB

        CASE TENLB2

        CASE ELEVENLB

        CASE TWELVELB

        CASE OCLOCKLB

    END SELECT
END SUB

SUB __UI_MouseLeave (id AS LONG)
    SELECT CASE id
        CASE WordClock

        CASE ITISLB

        CASE HALFLB

        CASE TENLB

        CASE QUARTERLB

        CASE TWENTYLB

        CASE FIVELB

        CASE MINUTESLB

        CASE TOLB

        CASE PASTLB

        CASE TWOLB

        CASE THREELB

        CASE ONELB

        CASE FOURLB

        CASE FIVELB2

        CASE SIXLB

        CASE SEVENLB

        CASE EIGHTLB

        CASE NINELB

        CASE TENLB2

        CASE ELEVENLB

        CASE TWELVELB

        CASE OCLOCKLB

    END SELECT
END SUB

SUB __UI_FocusIn (id AS LONG)
    SELECT CASE id
    END SELECT
END SUB

SUB __UI_FocusOut (id AS LONG)
    'This event occurs right before a control loses focus.
    'To prevent a control from losing focus, set __UI_KeepFocus = True below.
    SELECT CASE id
    END SELECT
END SUB

SUB __UI_MouseDown (id AS LONG)
    SELECT CASE id
        CASE WordClock

        CASE ITISLB

        CASE HALFLB

        CASE TENLB

        CASE QUARTERLB

        CASE TWENTYLB

        CASE FIVELB

        CASE MINUTESLB

        CASE TOLB

        CASE PASTLB

        CASE TWOLB

        CASE THREELB

        CASE ONELB

        CASE FOURLB

        CASE FIVELB2

        CASE SIXLB

        CASE SEVENLB

        CASE EIGHTLB

        CASE NINELB

        CASE TENLB2

        CASE ELEVENLB

        CASE TWELVELB

        CASE OCLOCKLB

    END SELECT
END SUB

SUB __UI_MouseUp (id AS LONG)
    SELECT CASE id
        CASE WordClock

        CASE ITISLB

        CASE HALFLB

        CASE TENLB

        CASE QUARTERLB

        CASE TWENTYLB

        CASE FIVELB

        CASE MINUTESLB

        CASE TOLB

        CASE PASTLB

        CASE TWOLB

        CASE THREELB

        CASE ONELB

        CASE FOURLB

        CASE FIVELB2

        CASE SIXLB

        CASE SEVENLB

        CASE EIGHTLB

        CASE NINELB

        CASE TENLB2

        CASE ELEVENLB

        CASE TWELVELB

        CASE OCLOCKLB

    END SELECT
END SUB

SUB __UI_KeyPress (id AS LONG)
    'When this event is fired, __UI_KeyHit will contain the code of the key hit.
    'You can change it and even cancel it by making it = 0
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
