': This program uses
': InForm - GUI library for QB64 - v1.0
': Fellippe Heitor, 2016-2019 - fellippe@qb64.org - @fellippeheitor
': https://github.com/FellippeHeitor/InForm
'-----------------------------------------------------------

OPTION _EXPLICIT

': Controls' IDs: ------------------------------------------------------------------
DIM SHARED Stopwatch AS LONG
DIM SHARED TimeLB AS LONG
DIM SHARED StartBT AS LONG
DIM SHARED LapBT AS LONG
DIM SHARED StopBT AS LONG
DIM SHARED ListBox1 AS LONG

DIM SHARED start AS SINGLE, Running AS _BYTE
DIM SHARED second AS INTEGER, minute AS INTEGER, hour AS INTEGER
DIM SHARED elapsed AS SINGLE

': External modules: ---------------------------------------------------------------
'$INCLUDE:'../../InForm/InForm.bi'
'$INCLUDE:'Stopwatch.frm'
'$INCLUDE:'../../InForm/InForm.ui'

': Event procedures: ---------------------------------------------------------------
SUB __UI_BeforeInit

END SUB

SUB __UI_OnLoad
    __UI_DefaultButtonID = StartBT
END SUB

SUB __UI_BeforeUpdateDisplay
    IF Running THEN
        DIM theTime$

        elapsed = TIMER - start
        IF elapsed >= 1 THEN
            second = second + 1
            elapsed = elapsed - 1
            start = start + 1
            IF second >= 60 THEN
                second = second - 60
                minute = minute + 1
                IF minute >= 60 THEN
                    minute = minute - 60
                    hour = hour + 1
                END IF
            END IF
        END IF

        DIM hour$: hour$ = RIGHT$("00" + LTRIM$(STR$(hour)), 2)
        DIM min$: min$ = RIGHT$("00" + LTRIM$(STR$(minute)), 2)
        DIM sec$: sec$ = RIGHT$("00" + LTRIM$(STR$(second)), 2)
        DIM elapsed$: elapsed$ = MID$(STR$(elapsed), INSTR(STR$(elapsed), ".") + 1) + "000"

        theTime$ = hour$ + ":" + min$ + ":" + sec$ + "," + LEFT$(elapsed$, 3)

        Caption(TimeLB) = theTime$
    END IF
END SUB

SUB __UI_BeforeUnload
END SUB

SUB __UI_Click (id AS LONG)
    SELECT CASE id
        CASE Stopwatch

        CASE TimeLB

        CASE StartBT
            IF Running THEN
                Caption(id) = "Start"
                Running = FALSE
                Control(StopBT).Disabled = FALSE
                Control(LapBT).Disabled = TRUE
            ELSE
                Caption(id) = "Pause"
                start = TIMER - elapsed
                Running = TRUE
                Control(StopBT).Disabled = TRUE
                Control(LapBT).Disabled = FALSE
            END IF
        CASE LapBT
            AddItem ListBox1, Caption(TimeLB)
        CASE StopBT
            second = 0
            minute = 0
            hour = 0
            elapsed = 0
            Caption(TimeLB) = "00:00:00,000"
            ResetList ListBox1
        CASE ListBox1

    END SELECT
END SUB

SUB __UI_MouseEnter (id AS LONG)
    SELECT CASE id
        CASE Stopwatch

        CASE TimeLB

        CASE StartBT

        CASE LapBT

        CASE StopBT

        CASE ListBox1

    END SELECT
END SUB

SUB __UI_MouseLeave (id AS LONG)
    SELECT CASE id
        CASE Stopwatch

        CASE TimeLB

        CASE StartBT

        CASE LapBT

        CASE StopBT

        CASE ListBox1

    END SELECT
END SUB

SUB __UI_FocusIn (id AS LONG)
    SELECT CASE id
        CASE StartBT

        CASE LapBT

        CASE StopBT

        CASE ListBox1

    END SELECT
END SUB

SUB __UI_FocusOut (id AS LONG)
    SELECT CASE id
        CASE StartBT

        CASE LapBT

        CASE StopBT

        CASE ListBox1

    END SELECT
END SUB

SUB __UI_MouseDown (id AS LONG)
    SELECT CASE id
        CASE Stopwatch

        CASE TimeLB

        CASE StartBT

        CASE LapBT

        CASE StopBT

        CASE ListBox1

    END SELECT
END SUB

SUB __UI_MouseUp (id AS LONG)
    SELECT CASE id
        CASE Stopwatch

        CASE TimeLB

        CASE StartBT

        CASE LapBT

        CASE StopBT

        CASE ListBox1

    END SELECT
END SUB

SUB __UI_KeyPress (id AS LONG)
    SELECT CASE id
        CASE StartBT

        CASE LapBT

        CASE StopBT

        CASE ListBox1

    END SELECT
END SUB

SUB __UI_TextChanged (id AS LONG)
    SELECT CASE id
    END SELECT
END SUB

SUB __UI_ValueChanged (id AS LONG)
    SELECT CASE id
        CASE ListBox1

    END SELECT
END SUB

SUB __UI_FormResized

END SUB
