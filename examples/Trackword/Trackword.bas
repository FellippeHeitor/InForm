': Trackword Solver by QWERKEY (Richard Notley) 09-08-2018
': bplus created search algorithms
': This program uses
': InForm - GUI library for QB64 - Beta version 7
': Fellippe Heitor, 2016-2018 - fellippe@qb64.org - @fellippeheitor
': https://github.com/FellippeHeitor/InForm
'-----------------------------------------------------------

CONST noCells%% = 9, nSnakes& = 5128 'For HalfABC.rnd

DIM SHARED snakes$(nSnakes&), Entries&, theWord$, TrackWord$(noCells%%)
DIM SHARED Trackword AS LONG
DIM SHARED Frame1 AS LONG
DIM SHARED TrackwordSolverLB AS LONG
DIM SHARED ListBox1 AS LONG
DIM SHARED ListBox2 AS LONG
DIM SHARED WordsFoundLB AS LONG
DIM SHARED NineLetterWordsLB AS LONG
DIM SHARED SetPuzzleBT AS LONG
DIM SHARED TextBox1 AS LONG
DIM SHARED TextBox2 AS LONG
DIM SHARED TextBox3 AS LONG
DIM SHARED TextBox4 AS LONG
DIM SHARED TextBox5 AS LONG
DIM SHARED TextBox6 AS LONG
DIM SHARED TextBox7 AS LONG
DIM SHARED TextBox8 AS LONG
DIM SHARED TextBox9 AS LONG
DIM SHARED ExitBT AS LONG
DIM SHARED SolveBT AS LONG
DIM SHARED ClearBT AS LONG
DIM SHARED PictureBox1 AS LONG

'Load the dictionary here in order to get Entries& value
OPEN "dictionary.rnd" FOR RANDOM AS #1 LEN = 9
FIELD #1, 9 AS Lex$
Entries& = LOF(1) / 9
DIM SHARED words$(Entries&)
FOR D& = 1 TO Entries&
    GET #1, D&
    words$(D&) = RTRIM$(Lex$)
NEXT
CLOSE #1

RANDOMIZE (TIMER)
$EXEICON:'.\trackword.ico'
DATA 254,36541,652,12587,23698741,98523,458,56974,685
FOR M%% = 1 TO noCells%%: READ TrackWord$(M%%): NEXT M%%

': External modules: ---------------------------------------------------------------
'$INCLUDE:'../../InForm/InForm.bi'
'$INCLUDE:'Trackword.frm'
'$INCLUDE:'../../InForm/InForm.ui'

FUNCTION snake2word$ (snakey$)
    ' Use the dim shared theWord$ to translate snake number string to letters
    FOR i = 1 TO LEN(snakey$)
        b$ = b$ + MID$(theWord$, VAL(MID$(snakey$, i, 1)), 1)
    NEXT
    snake2word$ = b$
END FUNCTION

FUNCTION revword$ (I$)
    FOR M%% = 1 TO LEN(I$)
        J$ = J$ + MID$(I$, LEN(I$) + 1 - M%%, 1)
        revword$ = J$
    NEXT M%%
END FUNCTION

FUNCTION Located%% (S2$)
    'Proven to work in all circustances
    __Located%% = FALSE
    P0& = 1
    P100& = Entries&

    WHILE P0& <= P100& AND NOT __Located%%
        P50& = INT((P0& + P100&) / 2)
        IF S2$ = words$(P50&) THEN
            __Located%% = TRUE
        ELSEIF S2$ > words$(P50&) THEN
            P0& = P50& + 1
        ELSE
            P100& = P50& - 1
        END IF
    WEND

    Located = __Located%%
END FUNCTION

': Event procedures: ---------------------------------------------------------------
SUB __UI_BeforeInit
    'Trackword Confiuration File
    OPEN "HalfABC.rnd" FOR RANDOM AS #1 LEN = 9
    FIELD #1, 9 AS Snaky$
    FOR D& = 1 TO 5128
        GET #1, D&
        snakes$(D& - 1) = RTRIM$(Snaky$)
    NEXT D&
    CLOSE #1
END SUB

SUB __UI_OnLoad
    LoadImage Control(PictureBox1), "trackword.jpg"
    SetFocus TextBox1
END SUB

SUB __UI_BeforeUpdateDisplay
    'This event occurs at approximately 30 frames per second.
    'You can change the update frequency by calling SetFrameRate DesiredRate%
    '*** If a progress bar was displayed, we'd want it here,
    '*** along with the calculation code, sampled at the display rate.
END SUB

SUB __UI_BeforeUnload
    'If you set __UI_UnloadSignal = False here you can
    'cancel the user's request to close.
END SUB

SUB __UI_Click (id AS LONG)
    SELECT CASE id
        CASE Trackword

        CASE Frame1

        CASE TrackwordSolverLB

        CASE ListBox1

        CASE ListBox2

        CASE WordsFoundLB

        CASE NineLetterWordsLB

        CASE TextBox1

        CASE TextBox2

        CASE TextBox3

        CASE TextBox4

        CASE TextBox5

        CASE TextBox6

        CASE TextBox7

        CASE TextBox8

        CASE TextBox9

        CASE PictureBox1

        CASE SetPuzzleBT
            ' Generate a Trackword Puzzle
            Text(TextBox1) = ""
            Text(TextBox2) = ""
            Text(TextBox3) = ""
            Text(TextBox4) = ""
            Text(TextBox5) = ""
            Text(TextBox6) = ""
            Text(TextBox7) = ""
            Text(TextBox8) = ""
            Text(TextBox9) = ""
            ResetList ListBox1
            ResetList ListBox2
            Caption(WordsFoundLB) = "Words Found"
            'Search for 9-letter word & place in grid
            OPEN "dictionary.rnd" FOR RANDOM AS #1 LEN = 9
            FIELD #1, 9 AS Lex$
            NineLetters` = FALSE
            WHILE NOT NineLetters`
                Sel& = INT(Entries& * RND) + 1
                GET #1, Sel&
                OutWord$ = RTRIM$(Lex$)
                IF LEN(OutWord$) = 9 THEN NineLetters` = TRUE
            WEND
            CLOSE #1
            theWord$ = "*********"
            Posn%% = INT(9 * RND) + 1
            MID$(theWord$, Posn%%, 1) = LEFT$(OutWord$, 1)
            P%% = Posn%%
            M%% = 2
            WHILE M%% <= 9
                W2$ = ""
                FOR Q%% = 1 TO LEN(TrackWord$(P%%))
                    IF MID$(theWord$, VAL(MID$(TrackWord$(P%%), Q%%, 1)), 1) = "*" THEN W2$ = W2$ + MID$(TrackWord$(P%%), Q%%, 1)
                NEXT Q%%
                IF W2$ = "" THEN
                    'Start Again
                    theWord$ = "*********"
                    MID$(theWord$, Posn%%, 1) = LEFT$(OutWord$, 1)
                    P%% = Posn%%
                    M%% = 2
                ELSE
                    R%% = INT(LEN(W2$) * RND) + 1
                    P%% = VAL(MID$(W2$, R%%, 1))
                    MID$(theWord$, P%%, 1) = MID$(OutWord$, M%%, 1)
                    M%% = M%% + 1
                END IF
            WEND
            Text(TextBox1) = LEFT$(theWord$, 1)
            Text(TextBox2) = MID$(theWord$, 2, 1)
            Text(TextBox3) = MID$(theWord$, 3, 1)
            Text(TextBox4) = MID$(theWord$, 4, 1)
            Text(TextBox5) = MID$(theWord$, 5, 1)
            Text(TextBox6) = MID$(theWord$, 6, 1)
            Text(TextBox7) = MID$(theWord$, 7, 1)
            Text(TextBox8) = MID$(theWord$, 8, 1)
            Text(TextBox9) = RIGHT$(theWord$, 1)
            SetFocus SolveBT
        CASE ExitBT
            'Quit
            SYSTEM
        CASE SolveBT
            ' Solve
            ResetList ListBox1
            ResetList ListBox2
            Caption(WordsFoundLB) = "Words Found"
            NoAnswers% = 0
            NoNineLetters% = 0
            FullWord` = TRUE
            IF Text(TextBox1) = "" THEN
                FullWord` = FALSE
                SetFocus TextBox1
            ELSEIF Text(TextBox1) < "A" OR Text(TextBox1) > "Z" THEN
                FullWord` = FALSE
                SetFocus TextBox1
            ELSEIF Text(TextBox2) = "" THEN
                FullWord` = FALSE
                SetFocus TextBox2
            ELSEIF Text(TextBox2) < "A" OR Text(TextBox2) > "Z" THEN
                FullWord` = FALSE
                SetFocus TextBox2
            ELSEIF Text(TextBox3) = "" THEN
                FullWord` = FALSE
                SetFocus TextBox3
            ELSEIF Text(TextBox3) < "A" OR Text(TextBox3) > "Z" THEN
                FullWord` = FALSE
                SetFocus TextBox3
            ELSEIF Text(TextBox4) = "" THEN
                FullWord` = FALSE
                SetFocus TextBox4
            ELSEIF Text(TextBox4) < "A" OR Text(TextBox4) > "Z" THEN
                FullWord` = FALSE
                SetFocus TextBox4
            ELSEIF Text(TextBox5) = "" THEN
                FullWord` = FALSE
                SetFocus TextBox5
            ELSEIF Text(TextBox5) < "A" OR Text(TextBox5) > "Z" THEN
                FullWord` = FALSE
                SetFocus TextBox5
            ELSEIF Text(TextBox6) = "" THEN
                FullWord` = FALSE
                SetFocus TextBox6
            ELSEIF Text(TextBox6) < "A" OR Text(TextBox6) > "Z" THEN
                FullWord` = FALSE
                SetFocus TextBox6
            ELSEIF Text(TextBox7) = "" THEN
                FullWord` = FALSE
                SetFocus TextBox7
            ELSEIF Text(TextBox7) < "A" OR Text(TextBox7) > "Z" THEN
                FullWord` = FALSE
                SetFocus TextBox7
            ELSEIF Text(TextBox8) = "" THEN
                FullWord` = FALSE
                SetFocus TextBox8
            ELSEIF Text(TextBox8) < "A" OR Text(TextBox8) > "Z" THEN
                FullWord` = FALSE
                SetFocus TextBox8
            ELSEIF Text(TextBox9) = "" THEN
                FullWord` = FALSE
                SetFocus TextBox9
            ELSEIF Text(TextBox9) < "A" OR Text(TextBox9) > "Z" THEN
                FullWord` = FALSE
                SetFocus TextBox9
            END IF
            IF FullWord` THEN
                IF LEN(theWord$) < 9 THEN theWord$ = "*********"
                MID$(theWord$, 1, 1) = Text(TextBox1)
                MID$(theWord$, 2, 1) = Text(TextBox2)
                MID$(theWord$, 3, 1) = Text(TextBox3)
                MID$(theWord$, 4, 1) = Text(TextBox4)
                MID$(theWord$, 5, 1) = Text(TextBox5)
                MID$(theWord$, 6, 1) = Text(TextBox6)
                MID$(theWord$, 7, 1) = Text(TextBox7)
                MID$(theWord$, 8, 1) = Text(TextBox8)
                MID$(theWord$, 9, 1) = Text(TextBox9)
                OPEN "tanswers.rnd" FOR RANDOM AS #1 LEN = 9
                FIELD #1, 9 AS TWord$
                'Search Time Tweak Suggested by Fellippe
                TIMER(__UI_EventsTimer) OFF
                TIMER(__UI_RefreshTimer) OFF
                REDIM S1$(1)
                FOR D& = 0 TO nSnakes& - 1 'Go through all snake patterns
                    S1$(0) = snake2word$(snakes$(D&))
                    S1$(1) = revword$(S1$(0))
                    FOR M%% = 0 TO 1
                        IF Located%%(S1$(M%%)) THEN
                            IF NoAnswers% > 0 THEN
                                Present` = FALSE
                                Index% = 0
                                WHILE (NOT Present`) AND Index% <= NoAnswers%
                                    GET #1, Index% + 1
                                    IF RTRIM$(TWord$) = S1$(M%%) THEN Present` = TRUE
                                    Index% = Index% + 1
                                WEND
                                IF NOT Present` THEN
                                    NoAnswers% = NoAnswers% + 1
                                    LSET TWord$ = S1$(M%%)
                                    PUT #1, NoAnswers%
                                END IF
                            ELSE
                                NoAnswers% = NoAnswers% + 1
                                LSET TWord$ = S1$(M%%)
                                PUT #1, NoAnswers%
                            END IF
                        END IF
                    NEXT M%%
                NEXT D&
                ' Now order found words file
                Jump% = 1
                WHILE Jump% <= NoAnswers%: Jump% = Jump% * 2: WEND
                WHILE Jump% > 1
                    Jump% = (Jump% - 1) \ 2
                    Finished` = FALSE
                    WHILE NOT Finished`
                        Finished` = TRUE
                        FOR Upper% = 1 TO NoAnswers% - Jump%
                            Lower% = Upper% + Jump%
                            GET #1, Upper%: UWord$ = TWord$
                            GET #1, Lower%: LWord$ = TWord$
                            IF UWord$ > LWord$ THEN
                                LSET TWord$ = UWord$
                                PUT #1, Lower%
                                LSET TWord$ = LWord$
                                PUT #1, Upper%
                                Finished` = FALSE
                            END IF
                        NEXT Upper%
                    WEND
                WEND
                TIMER(__UI_EventsTimer) ON
                TIMER(__UI_RefreshTimer) ON
                FOR N1% = 1 TO NoAnswers%
                    GET #1, N1%
                    NewWord$ = RTRIM$(TWord$)
                    AddItem ListBox1, NewWord$
                    IF LEN(NewWord$) = 9 THEN AddItem ListBox2, NewWord$
                NEXT N1%
                CLOSE #1
                'Zero temporary random file
                OPEN "tanswers.rnd" FOR OUTPUT AS #1
                CLOSE #1
                Caption(WordsFoundLB) = LTRIM$(STR$(NoAnswers%)) + " Words Found"
            ELSE
                AA& = MessageBox("Incorrect Input", "", 0)
            END IF
        CASE ClearBT
            ' Reset
            theWord$ = ""
            Text(TextBox1) = ""
            Text(TextBox2) = ""
            Text(TextBox3) = ""
            Text(TextBox4) = ""
            Text(TextBox5) = ""
            Text(TextBox6) = ""
            Text(TextBox7) = ""
            Text(TextBox8) = ""
            Text(TextBox9) = ""
            ResetList ListBox1
            ResetList ListBox2
            Caption(WordsFoundLB) = "Words Found"
            SetFocus TextBox1
    END SELECT
END SUB

SUB __UI_MouseEnter (id AS LONG)
END SUB

SUB __UI_MouseLeave (id AS LONG)
END SUB

SUB __UI_FocusIn (id AS LONG)
END SUB

SUB __UI_FocusOut (id AS LONG)
    'This event occurs right before a control loses focus.
    'To prevent a control from losing focus, set __UI_KeepFocus = True below.
END SUB

SUB __UI_MouseDown (id AS LONG)
END SUB

SUB __UI_MouseUp (id AS LONG)
END SUB

SUB __UI_KeyPress (id AS LONG)
    'When this event is fired, __UI_KeyHit will contain the code of the key hit.
    'You can change it and even cancel it by making it = 0
END SUB

SUB __UI_TextChanged (id AS LONG)
    'Scan Input for Errors
    IF Text(id) <> "" THEN
        Text(id) = UCASE$(Text(id))
        IF Text(id) < "A" OR Text(id) > "Z" THEN
            Text(id) = ""
            AA& = MessageBox("Incorrect Input", "", 0)
        ELSE
            SELECT CASE id
                CASE TextBox1
                    SetFocus TextBox2
                CASE TextBox2
                    SetFocus TextBox3
                CASE TextBox3
                    SetFocus TextBox4
                CASE TextBox4
                    SetFocus TextBox5
                CASE TextBox5
                    SetFocus TextBox6
                CASE TextBox6
                    SetFocus TextBox7
                CASE TextBox7
                    SetFocus TextBox8
                CASE TextBox8
                    SetFocus TextBox9
                CASE TextBox9
                    IF Text(TextBox1) = "" THEN
                        SetFocus TextBox1
                    ELSEIF Text(TextBox2) = "" THEN
                        SetFocus TextBox2
                    ELSEIF Text(TextBox3) = "" THEN
                        SetFocus TextBox3
                    ELSEIF Text(TextBox4) = "" THEN
                        SetFocus TextBox4
                    ELSEIF Text(TextBox5) = "" THEN
                        SetFocus TextBox5
                    ELSEIF Text(TextBox6) = "" THEN
                        SetFocus TextBox6
                    ELSEIF Text(TextBox7) = "" THEN
                        SetFocus TextBox7
                    ELSEIF Text(TextBox8) = "" THEN
                        SetFocus TextBox8
                    ELSE
                        SetFocus SolveBT
                    END IF
            END SELECT
        END IF
    END IF
END SUB

SUB __UI_ValueChanged (id AS LONG)
END SUB

SUB __UI_FormResized
END SUB
