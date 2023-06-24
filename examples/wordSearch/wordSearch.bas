': This program uses
': InForm - GUI library for QB64 - v1.3
': Fellippe Heitor, 2016-2020 - fellippe@qb64.org - @fellippeheitor
': https://github.com/FellippeHeitor/InForm
'-----------------------------------------------------------

': Controls' IDs: ------------------------------------------------------------------
DIM SHARED WordSearch AS LONG
DIM SHARED FileToLoadLB AS LONG
DIM SHARED FileTB AS LONG
DIM SHARED LoadBT AS LONG
DIM SHARED ResultLB AS LONG
DIM SHARED WordToSearchLB AS LONG
DIM SHARED WordTB AS LONG
DIM SHARED SearchBT AS LONG
DIM SHARED ResultList AS LONG
DIM SHARED QUITBT AS LONG

DIM SHARED AS STRING contents, originalcontents


': External modules: ---------------------------------------------------------------
'$INCLUDE:'../../InForm/InForm.bi'
'$INCLUDE:'../../InForm/extensions/MessageBox.bi'
'$INCLUDE:'wordSearch.frm'

': Event procedures: ---------------------------------------------------------------
SUB __UI_BeforeInit
END SUB

SUB __UI_OnLoad
END SUB

SUB __UI_BeforeUpdateDisplay
    'This event occurs at approximately 30 frames per second.
    'You can change the update frequency by calling SetFrameRate DesiredRate%
    IF _FILEEXISTS(Text(FileTB)) THEN
        Control(LoadBT).Disabled = False
    ELSE
        Control(LoadBT).Disabled = True
    END IF

    IF LEN(Text(WordTB)) > 0 THEN
        Control(SearchBT).Disabled = False
    ELSE
        Control(SearchBT).Disabled = True
    END IF

END SUB

SUB __UI_BeforeUnload
    'If you set __UI_UnloadSignal = False here you can
    'cancel the user's request to close.

END SUB

SUB __UI_Click (id AS LONG)
    SELECT CASE id

        CASE WordSearch

        CASE FileToLoadLB

        CASE FileTB

        CASE ResultLB

        CASE WordToSearchLB

        CASE WordTB

        CASE ResultList

        CASE LoadBT
            IF _FILEEXISTS(Text(FileTB)) THEN
                DIM fh AS LONG
                fh = FREEFILE
                OPEN Text(FileTB) FOR BINARY AS #fh
                originalcontents = SPACE$(LOF(fh))
                GET #fh, 1, originalcontents
                CLOSE #fh
                contents = UCASE$(originalcontents)
                Caption(ResultLB) = "File: " + Text(FileTB) + " - loaded successfully."
            END IF

        CASE SearchBT
            IF LEN(contents) > 0 THEN
                ResetList ResultList
                count = 0
                word$ = UCASE$(Text(WordTB))
                i = INSTR(contents, word$)
                IF i = 0 THEN
                    Caption(ResultLB) = "Word: " + word$ + " - not found."
                ELSE
                    DO WHILE i > 0
                        count = count + 1
                        AddItem ResultList, STR$(count) + "..." + MID$(originalcontents, i - 10, 20 + LEN(word$)) + "..."
                        SetCaption ResultLB, "Total occurrences found so far: " + strFormat$(STR$(count), "###,###")
                        __UI_DoEvents
                        i = INSTR(i + 1, contents, word$)
                    LOOP
                END IF
            ELSE
                Caption(ResultLB) = "Variable contents is empty."
            END IF
            SetCaption ResultLB, "Search Completed - total occurrences found: " + strFormat$(STR$(count), "###,###")

        CASE QUITBT
            Answer = MessageBox("Are you sure you want to QUIT?", "", MsgBox_YesNo + MsgBox_Question)
            IF Answer = MsgBox_Yes THEN SYSTEM

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
END SUB

SUB __UI_ValueChanged (id AS LONG)
END SUB

SUB __UI_FormResized
END SUB


': User modules: ---------------------------------------------------------------


FUNCTION strFormat$ (text AS STRING, template AS STRING)
    '-----------------------------------------------------------------------------
    ' *** Return a formatted string to a variable
    '
    d = _DEST: s = _SOURCE
    n = _NEWIMAGE(80, 80, 0)
    _DEST n: _SOURCE n
    PRINT USING template; VAL(text)
    FOR i = 1 TO 79
        t$ = t$ + CHR$(SCREEN(1, i))
    NEXT
    IF LEFT$(t$, 1) = "%" THEN t$ = MID$(t$, 2)
    strFormat$ = _TRIM$(t$)
    _DEST d: _SOURCE s
    _FREEIMAGE n
END FUNCTION

'$INCLUDE:'../../InForm/InForm.ui'
'$INCLUDE:'../../InForm/xp.uitheme'
'$INCLUDE:'../../InForm/extensions/MessageBox.bas'
