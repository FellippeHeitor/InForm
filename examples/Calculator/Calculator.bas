':  ____ ____ ____ ____ ____ ____ ____ ____ ____ ____
': ||C |||A |||L |||C |||U |||L |||A |||T |||O |||R ||
': ||__|||__|||__|||__|||__|||__|||__|||__|||__|||__||
': |/__\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|
':
': QB64 Calculator V1.0
': Terry Ritchie - 08/29/18
':
': Built as a clone of the Windows 7 standard calculator
': An exersize in getting to know the InForm library
':
': This program uses
': InForm - GUI library for QB64 - Beta version 7
': Fellippe Heitor, 2016-2018 - fellippe@qb64.org - @fellippeheitor
': https://github.com/FellippeHeitor/InForm
'----------------------------------------------------------------------------------------------------------------------

OPTION _EXPLICIT

': Program constants: -------------------------------------------------------------------------------------------------

CONST EQUATE = 0
CONST ADDITION = 1
CONST SUBTRACTION = 2
CONST MULTIPLICATION = 3
CONST DIVISION = 4

': Controls' IDs: -----------------------------------------------------------------------------------------------------

DIM SHARED Calculator AS LONG
DIM SHARED frmResults AS LONG
DIM SHARED mnuEdit AS LONG
DIM SHARED mnuHelp AS LONG
DIM SHARED butMC AS LONG
DIM SHARED butMR AS LONG
DIM SHARED butMS AS LONG
DIM SHARED butMplus AS LONG
DIM SHARED butMminus AS LONG
DIM SHARED butBS AS LONG
DIM SHARED butCE AS LONG
DIM SHARED butC AS LONG
DIM SHARED butSign AS LONG
DIM SHARED butSQR AS LONG
DIM SHARED but7 AS LONG
DIM SHARED but8 AS LONG
DIM SHARED but9 AS LONG
DIM SHARED butDivide AS LONG
DIM SHARED butPercent AS LONG
DIM SHARED but4 AS LONG
DIM SHARED but5 AS LONG
DIM SHARED but6 AS LONG
DIM SHARED butMultiply AS LONG
DIM SHARED butReciprocate AS LONG
DIM SHARED but1 AS LONG
DIM SHARED but2 AS LONG
DIM SHARED but3 AS LONG
DIM SHARED butSubtract AS LONG
DIM SHARED but0 AS LONG
DIM SHARED butPoint AS LONG
DIM SHARED butAdd AS LONG
DIM SHARED butEqual AS LONG
DIM SHARED mnuCopy AS LONG
DIM SHARED mnuPaste AS LONG
DIM SHARED mnuAbout AS LONG
DIM SHARED lblAnswer AS LONG
DIM SHARED lblMemory AS LONG
DIM SHARED lblHistory AS LONG

': Program variables: -------------------------------------------------------------------------------------------------

DIM SHARED operand$ '                       current operand
DIM SHARED history$ '                       calculation history
DIM SHARED operand1 AS DOUBLE '             first operand enetered
DIM SHARED operand2 AS DOUBLE '             second operand entered
DIM SHARED operator AS INTEGER '            current operator selected
DIM SHARED operator$(4)
DIM SHARED previousoperator AS INTEGER '    previous operator saved
DIM SHARED resetoperand AS INTEGER '        True when operand entry needs reset
DIM SHARED memory AS DOUBLE '               value stored in memory
DIM SHARED nohistory AS INTEGER

': External modules: --------------------------------------------------------------------------------------------------
'$INCLUDE:'../../InForm/InForm.bi'
'$INCLUDE:'Calculator.frm'

': Program procedures: ------------------------------------------------------------------------------------------------

'----------------------------------------------------------------------------------------------------------------------
SUB ALERT () '                                                                                                  ALERT()
    '------------------------------------------------------------------------------------------------------------------

    DIM i AS LONG

    PLAY "MBQ0" ' play in the background and disable volume ramping

    FOR i = 800 TO 2000 STEP 100
        SOUND i, .2
    NEXT
    FOR i = 2000 TO 50 STEP -100
        SOUND i, .2
    NEXT

END SUB

'----------------------------------------------------------------------------------------------------------------------
FUNCTION CLEAN$ (n AS DOUBLE) '                                                                                CLEAN$()
    '------------------------------------------------------------------------------------------------------------------

    ' Return number (n) as a string with no leading/trailing spaces
    ' Add leading zero if necessary

    DIM c$ ' n converted to a clean string

    c$ = LTRIM$(RTRIM$(STR$(n))) '                                      create clean string
    IF ASC(c$, 1) = 46 THEN '                                           first character a decimal point?
        c$ = "0" + c$ '                                                 yes, add leading zero
    ELSEIF ASC(c$, 1) = 45 AND ASC(c$, 2) = 46 THEN '                   no, minus sign then decimal point?
        c$ = "-0" + RIGHT$(c$, LEN(c$) - 1) '                           yes, add leading zero
    END IF
    CLEAN$ = c$ '                                                       return cleaned string

END FUNCTION

'----------------------------------------------------------------------------------------------------------------------
SUB UPDATEOPERAND (n$) '                                                                                UPDATEOPERAND()
    '------------------------------------------------------------------------------------------------------------------

    ' Add user entries to operand
    ' Keep operand to a max length of 16 numbers (not including decimal point)
    ' Reset user operand input as needed
    ' Keep leading zero for decimal values between one and negative one

    DIM olen AS INTEGER ' operand length

    IF resetoperand THEN '                                              new operand input?
        operand$ = "" '                                                 yes, reset operand
        resetoperand = False '                                          reset trigger
    END IF
    IF n$ = "." THEN '                                                  adding decimal point?
        IF INSTR(operand$, ".") = 0 THEN '                              yes, already a decimal point?
            IF operand$ = "" THEN '                                     no, has operand been reset?
                n$ = "0." '                                             yes, add leading zero
            END IF
        ELSE '                                                          yes, decimal point exists
            n$ = "" '                                                   ignore user request for decimal point
        END IF
    END IF
    operand$ = operand$ + n$ '                                          update operand with user entry
    olen = LEN(operand$) '                                              get length of operand
    IF INSTR(operand$, ".") > 0 THEN olen = olen - 1 '                  don't count decimal point if preset
    IF olen > 16 THEN operand$ = LEFT$(operand$, LEN(operand$) - 1) '   keep operand within 16 number limit

END SUB

'----------------------------------------------------------------------------------------------------------------------
SUB CALCULATE () '                                                                                          CALCULATE()
    '------------------------------------------------------------------------------------------------------------------

    ' Calculate operand values based on operator previously used
    ' Store result back into current operand

    SELECT CASE previousoperator '                                      which operator to use?
        CASE ADDITION '                                                 add the operands
            operand$ = CLEAN$(operand1 + operand2) '                    perform clculation
        CASE SUBTRACTION '                                              subtract the operands
            operand$ = CLEAN$(operand1 - operand2) '                    perform calculation
        CASE MULTIPLICATION '                                           multiply the operands
            operand$ = CLEAN$(operand1 * operand2) '                    perform calculation
        CASE DIVISION '                                                 divide the operands
            IF operand2 = 0 THEN '                                      dividing by zero?
                ALERT '                                                 get user's attention
                operand$ = "Can't divide by zero!" '                    yes, not in this universe!
            ELSE '                                                      no, physics is safe for now
                operand$ = CLEAN$(operand1 / operand2) '                perform calculation
            END IF
    END SELECT

END SUB

'----------------------------------------------------------------------------------------------------------------------
SUB COMMITOPERAND () '                                                                                  COMMITOPERAND()
    '------------------------------------------------------------------------------------------------------------------

    ' Get value of current operand
    ' Calculate operands if necessary
    ' Save current operand value
    ' Remember the operator that invoked this routine

    operand2 = VAL(operand$) '                                          store value of current operand
    IF previousoperator THEN '                                          previous operator selected?
        CALCULATE '                                                     yes, calculate
    END IF
    operand1 = VAL(operand$) '                                          move current total to previous value
    previousoperator = operator '                                       move current operator to previous operator
    resetoperand = True '                                               trigger an operand reset

END SUB

'----------------------------------------------------------------------------------------------------------------------
SUB SCANKEYBOARD () '                                                                                    SCANKEYBOARD()
    '------------------------------------------------------------------------------------------------------------------

    ' Scan the keyboard for user keystrokes
    ' Invoke the appropriate button for the desired key

    DIM k$ ' key pressed by user
    DIM ctrl AS INTEGER

    k$ = INKEY$ '                                                       look for a key press
    IF k$ <> "" THEN '                                                  was a key pressed?
        SELECT CASE k$ '                                                yes, which one?
            CASE "0" '                                                  zero key pressed
                __UI_Click (but0) '                                     manually click the zero button
            CASE "1" '                                                  etc..
                __UI_Click (but1) '                                     etc..
            CASE "2"
                __UI_Click (but2)
            CASE "3"
                __UI_Click (but3)
            CASE "4"
                __UI_Click (but4)
            CASE "5"
                __UI_Click (but5)
            CASE "6"
                __UI_Click (but6)
            CASE "7"
                __UI_Click (but7)
            CASE "8"
                __UI_Click (but8)
            CASE "9"
                __UI_Click (but9)
            CASE "."
                __UI_Click (butPoint)
            CASE "+"
                __UI_Click (butAdd)
            CASE "-"
                __UI_Click (butSubtract)
            CASE "*"
                __UI_Click (butMultiply)
            CASE "/"
                __UI_Click (butDivide)
            CASE "%"
                __UI_Click (butPercent)
            CASE "=", CHR$(13) '                                        treat ENTER and = the same
                __UI_Click (butEqual)
            CASE CHR$(8) '                                              backspace key pressed
                __UI_Click (butBS)

            CASE "c", "C" '                                             CTRL-C copy
                ctrl = _KEYDOWN(100305) OR _KEYDOWN(100306)
                IF ctrl THEN BEEP

                ' Will need to investigate how to capture CTRL-C and CTRL-V
                ' Neither the code above or below works

            CASE "v", "V" '                                             CTRL-V paste
                IF __UI_CtrlIsDown THEN '                               is CTRL key presses?

                    BEEP

                END IF

        END SELECT
    END IF

END SUB

'----------------------------------------------------------------------------------------------------------------------
SUB ADDHISTORY (h$) '                                                                                      ADDHISTORY()
    '------------------------------------------------------------------------------------------------------------------

    IF nohistory THEN
        nohistory = False
    ELSE
        history$ = history$ + h$
    END IF

END SUB

'----------------------------------------------------------------------------------------------------------------------

': Event procedures: --------------------------------------------------------------------------------------------------

SUB __UI_BeforeInit

END SUB

SUB __UI_OnLoad

    operator$(1) = " + " ' define operator strings
    operator$(2) = " - "
    operator$(3) = " * "
    operator$(4) = " / "

END SUB

SUB __UI_BeforeUpdateDisplay
    'This event occurs at approximately 30 frames per second.
    'You can change the update frequency by calling SetFrameRate DesiredRate%

    DIM answer$ ' current operand displayed

    SCANKEYBOARD '                                                      process keys pressed by user

    Caption(lblHistory) = history$ + operator$(operator) '              update history display

    answer$ = operand$ '                                                copy operand
    IF answer$ = "" THEN answer$ = "0" '                                set to zero if empty

    Caption(lblAnswer) = answer$ '                                      display current operand

    IF memory THEN '                                                    does memory have value?
        Caption(lblMemory) = "M" '                                      yes, apply screen indication
    ELSE '                                                              no
        Caption(lblMemory) = "" '                                       remove screen indication
    END IF

END SUB

SUB __UI_BeforeUnload
    'If you set __UI_UnloadSignal = False here you can
    'cancel the user's request to close.

END SUB

SUB __UI_Click (id AS LONG)
    SELECT CASE id
        CASE Calculator

        CASE frmResults

        CASE mnuEdit

        CASE mnuHelp

            ': memory buttons: ----------------------------------------------------------------------------------------

        CASE butMC '                                                    memory clear clicked
            memory = 0 '                                                reset memory value

        CASE butMR '                                                    memory recall clicked
            IF memory THEN '                                            memory available?
                operand$ = CLEAN$(memory) '                             Yes, make it the current operand
                resetoperand = True '                                   trigger an operand reset
            END IF

        CASE butMS '                                                    memory store clicked
            memory = VAL(operand$) '                                    overwrite memory with current operand
            resetoperand = True '                                       trigger an operand reset

        CASE butMplus '                                                 memory addition clicked
            memory = memory + VAL(operand$) '                           add current operand to memory
            resetoperand = True '                                       trigger an operand reset

        CASE butMminus '                                                memory subtraction clicked
            memory = memory - VAL(operand$) '                           subtract current operand from memory
            resetoperand = True '                                       trigger an operand reset

            ': clear buttons: -----------------------------------------------------------------------------------------

        CASE butCE '                                                    clear entry clicked
            operand$ = "" '                                             reset current operand

        CASE butC '                                                     clear clicked
            operand1 = 0 '                                              initialize all values
            operand2 = 0
            operator = 0
            previousoperator = 0
            operand$ = ""
            history$ = ""

        CASE butBS '                                                    backspace clicked
            IF LEN(operand$) THEN '                                     characters in operand?
                operand$ = LEFT$(operand$, LEN(operand$) - 1) '         yes, remove right-most character
            END IF

            ': calculation buttons: -----------------------------------------------------------------------------------

        CASE butReciprocate '                                           reciprocate clicked
            IF VAL(operand$) THEN '                                     dividing by zero?

                ADDHISTORY (operator$(previousoperator) + "Reciproc(" + operand$ + ")")
                nohistory = True '                                      skip operand history next time
                operator = EQUATE

                operand$ = CLEAN$(1 / VAL(operand$)) '                  no, calculate reciprocate
            ELSE '                                                      yes, physics will collapse!
                ALERT '                                                 get user's attention
                operand$ = "Can't divide by zero!" '                    report error to user
            END IF
            resetoperand = True '                                       trigger an operand reset

        CASE butSQR '                                                   square root clicked
            IF VAL(operand$) >= 0 THEN '                                positive value?

                ADDHISTORY (operator$(previousoperator) + "SQRT(" + operand$ + ")")
                nohistory = True '                                      skip operand history next time
                operator = EQUATE

                operand$ = CLEAN$(SQR(VAL(operand$))) '                 yes, calculate square root
            ELSE '                                                      no, value is negative
                ALERT '                                                 get user's attention
                operand$ = "Invalid input!" '                           nice try buddy
            END IF
            resetoperand = True '                                       trigger an operand reset

        CASE butPercent '                                               percent clicked
            operand$ = CLEAN$(operand1 * VAL(operand$) / 100) '         calculate percentage of previous operand
            resetoperand = True

        CASE butSign '                                                  sign clicked
            IF VAL(operand$) THEN '                                     value equal to zero?
                operand$ = CLEAN$(-VAL(operand$)) '                     no, reverse sign of operand
            END IF

            ': number buttons: ----------------------------------------------------------------------------------------

        CASE but0 '                                                     zero clicked
            IF VAL(operand$) OR INSTR(operand$, ".") THEN '             ok to add a zero?
                UPDATEOPERAND ("0") '                                   yes, append zero
            END IF

        CASE but1 '                                                     one clicked
            UPDATEOPERAND ("1") '                                       append one

        CASE but2 '                                                     etc..
            UPDATEOPERAND ("2") '                                       etc..

        CASE but3
            UPDATEOPERAND ("3")

        CASE but4
            UPDATEOPERAND ("4")

        CASE but5
            UPDATEOPERAND ("5")

        CASE but6
            UPDATEOPERAND ("6")

        CASE but7
            UPDATEOPERAND ("7")

        CASE but8
            UPDATEOPERAND ("8")

        CASE but9
            UPDATEOPERAND ("9")

        CASE butPoint
            UPDATEOPERAND (".")

            ': operator buttons: --------------------------------------------------------------------------------------

        CASE butDivide '                                                divide clicked

            ADDHISTORY (operator$(previousoperator) + operand$)

            operator = DIVISION '                                       remember operator selected
            COMMITOPERAND '                                             save operand

        CASE butMultiply '                                              multiply clicked

            ADDHISTORY (operator$(previousoperator) + operand$)

            operator = MULTIPLICATION '                                 remember operator selected
            COMMITOPERAND '                                             save operand

        CASE butSubtract '                                              subtract clicked

            ADDHISTORY (operator$(previousoperator) + operand$)

            operator = SUBTRACTION '                                    remember operator selected
            COMMITOPERAND '                                             save operand

        CASE butAdd '                                                   addition clicked

            ADDHISTORY (operator$(previousoperator) + operand$)

            operator = ADDITION '                                       remember operator selected
            COMMITOPERAND '                                             save operand

        CASE butEqual '                                                 equal clicked

            history$ = ""
            operator = EQUATE '                                         remember operator selected
            COMMITOPERAND '                                             save operand
            previousoperator = 0


        CASE mnuCopy

        CASE mnuPaste

        CASE mnuAbout
            _DELAY 0.2: _MESSAGEBOX "Calculator", "InForm Calculator 1.0", "info"

        CASE lblAnswer

        CASE lblMemory

        CASE lblHistory

    END SELECT
END SUB

SUB __UI_MouseEnter (id AS LONG)
    SELECT CASE id
        CASE Calculator

        CASE frmResults

        CASE mnuEdit

        CASE mnuHelp

        CASE butMC

        CASE butMR

        CASE butMS

        CASE butMplus

        CASE butMminus

        CASE butBS

        CASE butCE

        CASE butC

        CASE butSign

        CASE butSQR

        CASE but7

        CASE but8

        CASE but9

        CASE butDivide

        CASE butPercent

        CASE but4

        CASE but5

        CASE but6

        CASE butMultiply

        CASE butReciprocate

        CASE but1

        CASE but2

        CASE but3

        CASE butSubtract

        CASE but0

        CASE butPoint

        CASE butAdd

        CASE butEqual

        CASE mnuCopy

        CASE mnuPaste

        CASE mnuAbout

        CASE lblAnswer

        CASE lblMemory

        CASE lblHistory

    END SELECT
END SUB

SUB __UI_MouseLeave (id AS LONG)
    SELECT CASE id
        CASE Calculator

        CASE frmResults

        CASE mnuEdit

        CASE mnuHelp

        CASE butMC

        CASE butMR

        CASE butMS

        CASE butMplus

        CASE butMminus

        CASE butBS

        CASE butCE

        CASE butC

        CASE butSign

        CASE butSQR

        CASE but7

        CASE but8

        CASE but9

        CASE butDivide

        CASE butPercent

        CASE but4

        CASE but5

        CASE but6

        CASE butMultiply

        CASE butReciprocate

        CASE but1

        CASE but2

        CASE but3

        CASE butSubtract

        CASE but0

        CASE butPoint

        CASE butAdd

        CASE butEqual

        CASE mnuCopy

        CASE mnuPaste

        CASE mnuAbout

        CASE lblAnswer

        CASE lblMemory

        CASE lblHistory

    END SELECT
END SUB

SUB __UI_FocusIn (id AS LONG)
    SELECT CASE id
        CASE butMC

        CASE butMR

        CASE butMS

        CASE butMplus

        CASE butMminus

        CASE butBS

        CASE butCE

        CASE butC

        CASE butSign

        CASE butSQR

        CASE but7

        CASE but8

        CASE but9

        CASE butDivide

        CASE butPercent

        CASE but4

        CASE but5

        CASE but6

        CASE butMultiply

        CASE butReciprocate

        CASE but1

        CASE but2

        CASE but3

        CASE butSubtract

        CASE but0

        CASE butPoint

        CASE butAdd

        CASE butEqual

    END SELECT
END SUB

SUB __UI_FocusOut (id AS LONG)
    'This event occurs right before a control loses focus.
    'To prevent a control from losing focus, set __UI_KeepFocus = True below.
    SELECT CASE id
        CASE butMC

        CASE butMR

        CASE butMS

        CASE butMplus

        CASE butMminus

        CASE butBS

        CASE butCE

        CASE butC

        CASE butSign

        CASE butSQR

        CASE but7

        CASE but8

        CASE but9

        CASE butDivide

        CASE butPercent

        CASE but4

        CASE but5

        CASE but6

        CASE butMultiply

        CASE butReciprocate

        CASE but1

        CASE but2

        CASE but3

        CASE butSubtract

        CASE but0

        CASE butPoint

        CASE butAdd

        CASE butEqual

    END SELECT
END SUB

SUB __UI_MouseDown (id AS LONG)
    SELECT CASE id
        CASE Calculator

        CASE frmResults

        CASE mnuEdit

        CASE mnuHelp

        CASE butMC

        CASE butMR

        CASE butMS

        CASE butMplus

        CASE butMminus

        CASE butBS

        CASE butCE

        CASE butC

        CASE butSign

        CASE butSQR

        CASE but7

        CASE but8

        CASE but9

        CASE butDivide

        CASE butPercent

        CASE but4

        CASE but5

        CASE but6

        CASE butMultiply

        CASE butReciprocate

        CASE but1

        CASE but2

        CASE but3

        CASE butSubtract

        CASE but0

        CASE butPoint

        CASE butAdd

        CASE butEqual

        CASE mnuCopy

        CASE mnuPaste

        CASE mnuAbout

        CASE lblAnswer

        CASE lblMemory

        CASE lblHistory

    END SELECT
END SUB

SUB __UI_MouseUp (id AS LONG)
    SELECT CASE id
        CASE Calculator

        CASE frmResults

        CASE mnuEdit

        CASE mnuHelp

        CASE butMC

        CASE butMR

        CASE butMS

        CASE butMplus

        CASE butMminus

        CASE butBS

        CASE butCE

        CASE butC

        CASE butSign

        CASE butSQR

        CASE but7

        CASE but8

        CASE but9

        CASE butDivide

        CASE butPercent

        CASE but4

        CASE but5

        CASE but6

        CASE butMultiply

        CASE butReciprocate

        CASE but1

        CASE but2

        CASE but3

        CASE butSubtract

        CASE but0

        CASE butPoint

        CASE butAdd

        CASE butEqual

        CASE mnuCopy

        CASE mnuPaste

        CASE mnuAbout

        CASE lblAnswer

        CASE lblMemory

        CASE lblHistory

    END SELECT
END SUB

SUB __UI_KeyPress (id AS LONG)
    'When this event is fired, __UI_KeyHit will contain the code of the key hit.
    'You can change it and even cancel it by making it = 0

    SELECT CASE id
        CASE butMC

        CASE butMR

        CASE butMS

        CASE butMplus

        CASE butMminus

        CASE butBS

        CASE butCE

        CASE butC

        CASE butSign

        CASE butSQR

        CASE but7

        CASE but8

        CASE but9

        CASE butDivide

        CASE butPercent

        CASE but4

        CASE but5

        CASE but6

        CASE butMultiply

        CASE butReciprocate

        CASE but1

        CASE but2

        CASE but3

        CASE butSubtract

        CASE but0

        CASE butPoint

        CASE butAdd

        CASE butEqual

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

'$INCLUDE:'../../InForm/InForm.ui'
'$INCLUDE:'../../InForm/xp.uitheme'
