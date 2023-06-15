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

Option _Explicit

': Program constants: -------------------------------------------------------------------------------------------------

Const EQUATE = 0
Const ADDITION = 1
Const SUBTRACTION = 2
Const MULTIPLICATION = 3
Const DIVISION = 4

': Controls' IDs: -----------------------------------------------------------------------------------------------------

Dim Shared Calculator As Long
Dim Shared frmResults As Long
Dim Shared mnuEdit As Long
Dim Shared mnuHelp As Long
Dim Shared butMC As Long
Dim Shared butMR As Long
Dim Shared butMS As Long
Dim Shared butMplus As Long
Dim Shared butMminus As Long
Dim Shared butBS As Long
Dim Shared butCE As Long
Dim Shared butC As Long
Dim Shared butSign As Long
Dim Shared butSQR As Long
Dim Shared but7 As Long
Dim Shared but8 As Long
Dim Shared but9 As Long
Dim Shared butDivide As Long
Dim Shared butPercent As Long
Dim Shared but4 As Long
Dim Shared but5 As Long
Dim Shared but6 As Long
Dim Shared butMultiply As Long
Dim Shared butReciprocate As Long
Dim Shared but1 As Long
Dim Shared but2 As Long
Dim Shared but3 As Long
Dim Shared butSubtract As Long
Dim Shared but0 As Long
Dim Shared butPoint As Long
Dim Shared butAdd As Long
Dim Shared butEqual As Long
Dim Shared mnuCopy As Long
Dim Shared mnuPaste As Long
Dim Shared mnuAbout As Long
Dim Shared lblAnswer As Long
Dim Shared lblMemory As Long
Dim Shared lblHistory As Long

': Program variables: -------------------------------------------------------------------------------------------------

Dim Shared operand$ '                       current operand
Dim Shared history$ '                       calculation history
Dim Shared operand1 As Double '             first operand enetered
Dim Shared operand2 As Double '             second operand entered
Dim Shared operator As Integer '            current operator selected
Dim Shared operator$(4)
Dim Shared previousoperator As Integer '    previous operator saved
Dim Shared resetoperand As Integer '        True when operand entry needs reset
Dim Shared memory As Double '               value stored in memory
Dim Shared nohistory As Integer

': External modules: --------------------------------------------------------------------------------------------------
'$INCLUDE:'InForm\InForm.bi'
'$INCLUDE:'Calculator.frm'

': Program procedures: ------------------------------------------------------------------------------------------------

'----------------------------------------------------------------------------------------------------------------------
Sub ALERT () '                                                                                                  ALERT()
    '------------------------------------------------------------------------------------------------------------------

    Dim i As Long

    Play "MBQ0" ' play in the background and disable volume ramping

    For i = 800 To 2000 Step 100
        Sound i, .2
    Next
    For i = 2000 To 50 Step -100
        Sound i, .2
    Next

End Sub

'----------------------------------------------------------------------------------------------------------------------
Function CLEAN$ (n As Double) '                                                                                CLEAN$()
    '------------------------------------------------------------------------------------------------------------------

    ' Return number (n) as a string with no leading/trailing spaces
    ' Add leading zero if necessary

    Dim c$ ' n converted to a clean string

    c$ = LTrim$(RTrim$(Str$(n))) '                                      create clean string
    If Asc(c$, 1) = 46 Then '                                           first character a decimal point?
        c$ = "0" + c$ '                                                 yes, add leading zero
    ElseIf Asc(c$, 1) = 45 And Asc(c$, 2) = 46 Then '                   no, minus sign then decimal point?
        c$ = "-0" + Right$(c$, Len(c$) - 1) '                           yes, add leading zero
    End If
    CLEAN$ = c$ '                                                       return cleaned string

End Function

'----------------------------------------------------------------------------------------------------------------------
Sub UPDATEOPERAND (n$) '                                                                                UPDATEOPERAND()
    '------------------------------------------------------------------------------------------------------------------

    ' Add user entries to operand
    ' Keep operand to a max length of 16 numbers (not including decimal point)
    ' Reset user operand input as needed
    ' Keep leading zero for decimal values between one and negative one

    Dim olen As Integer ' operand length

    If resetoperand Then '                                              new operand input?
        operand$ = "" '                                                 yes, reset operand
        resetoperand = False '                                          reset trigger
    End If
    If n$ = "." Then '                                                  adding decimal point?
        If InStr(operand$, ".") = 0 Then '                              yes, already a decimal point?
            If operand$ = "" Then '                                     no, has operand been reset?
                n$ = "0." '                                             yes, add leading zero
            End If
        Else '                                                          yes, decimal point exists
            n$ = "" '                                                   ignore user request for decimal point
        End If
    End If
    operand$ = operand$ + n$ '                                          update operand with user entry
    olen = Len(operand$) '                                              get length of operand
    If InStr(operand$, ".") > 0 Then olen = olen - 1 '                  don't count decimal point if preset
    If olen > 16 Then operand$ = Left$(operand$, Len(operand$) - 1) '   keep operand within 16 number limit

End Sub

'----------------------------------------------------------------------------------------------------------------------
Sub CALCULATE () '                                                                                          CALCULATE()
    '------------------------------------------------------------------------------------------------------------------

    ' Calculate operand values based on operator previously used
    ' Store result back into current operand

    Select Case previousoperator '                                      which operator to use?
        Case ADDITION '                                                 add the operands
            operand$ = CLEAN$(operand1 + operand2) '                    perform clculation
        Case SUBTRACTION '                                              subtract the operands
            operand$ = CLEAN$(operand1 - operand2) '                    perform calculation
        Case MULTIPLICATION '                                           multiply the operands
            operand$ = CLEAN$(operand1 * operand2) '                    perform calculation
        Case DIVISION '                                                 divide the operands
            If operand2 = 0 Then '                                      dividing by zero?
                ALERT '                                                 get user's attention
                operand$ = "Can't divide by zero!" '                    yes, not in this universe!
            Else '                                                      no, physics is safe for now
                operand$ = CLEAN$(operand1 / operand2) '                perform calculation
            End If
    End Select

End Sub

'----------------------------------------------------------------------------------------------------------------------
Sub COMMITOPERAND () '                                                                                  COMMITOPERAND()
    '------------------------------------------------------------------------------------------------------------------

    ' Get value of current operand
    ' Calculate operands if necessary
    ' Save current operand value
    ' Remember the operator that invoked this routine

    operand2 = Val(operand$) '                                          store value of current operand
    If previousoperator Then '                                          previous operator selected?
        CALCULATE '                                                     yes, calculate
    End If
    operand1 = Val(operand$) '                                          move current total to previous value
    previousoperator = operator '                                       move current operator to previous operator
    resetoperand = True '                                               trigger an operand reset

End Sub

'----------------------------------------------------------------------------------------------------------------------
Sub SCANKEYBOARD () '                                                                                    SCANKEYBOARD()
    '------------------------------------------------------------------------------------------------------------------

    ' Scan the keyboard for user keystrokes
    ' Invoke the appropriate button for the desired key

    Dim k$ ' key pressed by user
    Dim ctrl As Integer

    k$ = InKey$ '                                                       look for a key press
    If k$ <> "" Then '                                                  was a key pressed?
        Select Case k$ '                                                yes, which one?
            Case "0" '                                                  zero key pressed
                __UI_Click (but0) '                                     manually click the zero button
            Case "1" '                                                  etc..
                __UI_Click (but1) '                                     etc..
            Case "2"
                __UI_Click (but2)
            Case "3"
                __UI_Click (but3)
            Case "4"
                __UI_Click (but4)
            Case "5"
                __UI_Click (but5)
            Case "6"
                __UI_Click (but6)
            Case "7"
                __UI_Click (but7)
            Case "8"
                __UI_Click (but8)
            Case "9"
                __UI_Click (but9)
            Case "."
                __UI_Click (butPoint)
            Case "+"
                __UI_Click (butAdd)
            Case "-"
                __UI_Click (butSubtract)
            Case "*"
                __UI_Click (butMultiply)
            Case "/"
                __UI_Click (butDivide)
            Case "%"
                __UI_Click (butPercent)
            Case "=", Chr$(13) '                                        treat ENTER and = the same
                __UI_Click (butEqual)
            Case Chr$(8) '                                              backspace key pressed
                __UI_Click (butBS)

            Case "c", "C" '                                             CTRL-C copy
                ctrl = _KeyDown(100305) Or _KeyDown(100306)
                If ctrl Then Beep

                ' Will need to investigate how to capture CTRL-C and CTRL-V
                ' Neither the code above or below works

            Case "v", "V" '                                             CTRL-V paste
                If __UI_CtrlIsDown Then '                               is CTRL key presses?

                    Beep

                End If

        End Select
    End If

End Sub

'----------------------------------------------------------------------------------------------------------------------
Sub ADDHISTORY (h$) '                                                                                      ADDHISTORY()
    '------------------------------------------------------------------------------------------------------------------

    If nohistory Then
        nohistory = False
    Else
        history$ = history$ + h$
    End If

End Sub

'----------------------------------------------------------------------------------------------------------------------

': Event procedures: --------------------------------------------------------------------------------------------------

Sub __UI_BeforeInit

End Sub

Sub __UI_OnLoad

    operator$(1) = " + " ' define operator strings
    operator$(2) = " - "
    operator$(3) = " * "
    operator$(4) = " / "

End Sub

Sub __UI_BeforeUpdateDisplay
    'This event occurs at approximately 30 frames per second.
    'You can change the update frequency by calling SetFrameRate DesiredRate%

    Dim answer$ ' current operand displayed

    SCANKEYBOARD '                                                      process keys pressed by user

    Caption(lblHistory) = history$ + operator$(operator) '              update history display

    answer$ = operand$ '                                                copy operand
    If answer$ = "" Then answer$ = "0" '                                set to zero if empty

    Caption(lblAnswer) = answer$ '                                      display current operand

    If memory Then '                                                    does memory have value?
        Caption(lblMemory) = "M" '                                      yes, apply screen indication
    Else '                                                              no
        Caption(lblMemory) = "" '                                       remove screen indication
    End If

End Sub

Sub __UI_BeforeUnload
    'If you set __UI_UnloadSignal = False here you can
    'cancel the user's request to close.

End Sub

Sub __UI_Click (id As Long)
    Select Case id
        Case Calculator

        Case frmResults

        Case mnuEdit

        Case mnuHelp

            ': memory buttons: ----------------------------------------------------------------------------------------

        Case butMC '                                                    memory clear clicked
            memory = 0 '                                                reset memory value

        Case butMR '                                                    memory recall clicked
            If memory Then '                                            memory available?
                operand$ = CLEAN$(memory) '                             Yes, make it the current operand
                resetoperand = True '                                   trigger an operand reset
            End If

        Case butMS '                                                    memory store clicked
            memory = Val(operand$) '                                    overwrite memory with current operand
            resetoperand = True '                                       trigger an operand reset

        Case butMplus '                                                 memory addition clicked
            memory = memory + Val(operand$) '                           add current operand to memory
            resetoperand = True '                                       trigger an operand reset

        Case butMminus '                                                memory subtraction clicked
            memory = memory - Val(operand$) '                           subtract current operand from memory
            resetoperand = True '                                       trigger an operand reset

            ': clear buttons: -----------------------------------------------------------------------------------------

        Case butCE '                                                    clear entry clicked
            operand$ = "" '                                             reset current operand

        Case butC '                                                     clear clicked
            operand1 = 0 '                                              initialize all values
            operand2 = 0
            operator = 0
            previousoperator = 0
            operand$ = ""
            history$ = ""

        Case butBS '                                                    backspace clicked
            If Len(operand$) Then '                                     characters in operand?
                operand$ = Left$(operand$, Len(operand$) - 1) '         yes, remove right-most character
            End If

            ': calculation buttons: -----------------------------------------------------------------------------------

        Case butReciprocate '                                           reciprocate clicked
            If Val(operand$) Then '                                     dividing by zero?

                ADDHISTORY (operator$(previousoperator) + "Reciproc(" + operand$ + ")")
                nohistory = True '                                      skip operand history next time
                operator = EQUATE

                operand$ = CLEAN$(1 / Val(operand$)) '                  no, calculate reciprocate
            Else '                                                      yes, physics will collapse!
                ALERT '                                                 get user's attention
                operand$ = "Can't divide by zero!" '                    report error to user
            End If
            resetoperand = True '                                       trigger an operand reset

        Case butSQR '                                                   square root clicked
            If Val(operand$) >= 0 Then '                                positive value?

                ADDHISTORY (operator$(previousoperator) + "SQRT(" + operand$ + ")")
                nohistory = True '                                      skip operand history next time
                operator = EQUATE

                operand$ = CLEAN$(Sqr(Val(operand$))) '                 yes, calculate square root
            Else '                                                      no, value is negative
                ALERT '                                                 get user's attention
                operand$ = "Invalid input!" '                           nice try buddy
            End If
            resetoperand = True '                                       trigger an operand reset

        Case butPercent '                                               percent clicked
            operand$ = CLEAN$(operand1 * Val(operand$) / 100) '         calculate percentage of previous operand
            resetoperand = True

        Case butSign '                                                  sign clicked
            If Val(operand$) Then '                                     value equal to zero?
                operand$ = CLEAN$(-Val(operand$)) '                     no, reverse sign of operand
            End If

            ': number buttons: ----------------------------------------------------------------------------------------

        Case but0 '                                                     zero clicked
            If Val(operand$) Or InStr(operand$, ".") Then '             ok to add a zero?
                UPDATEOPERAND ("0") '                                   yes, append zero
            End If

        Case but1 '                                                     one clicked
            UPDATEOPERAND ("1") '                                       append one

        Case but2 '                                                     etc..
            UPDATEOPERAND ("2") '                                       etc..

        Case but3
            UPDATEOPERAND ("3")

        Case but4
            UPDATEOPERAND ("4")

        Case but5
            UPDATEOPERAND ("5")

        Case but6
            UPDATEOPERAND ("6")

        Case but7
            UPDATEOPERAND ("7")

        Case but8
            UPDATEOPERAND ("8")

        Case but9
            UPDATEOPERAND ("9")

        Case butPoint
            UPDATEOPERAND (".")

            ': operator buttons: --------------------------------------------------------------------------------------

        Case butDivide '                                                divide clicked

            ADDHISTORY (operator$(previousoperator) + operand$)

            operator = DIVISION '                                       remember operator selected
            COMMITOPERAND '                                             save operand

        Case butMultiply '                                              multiply clicked

            ADDHISTORY (operator$(previousoperator) + operand$)

            operator = MULTIPLICATION '                                 remember operator selected
            COMMITOPERAND '                                             save operand

        Case butSubtract '                                              subtract clicked

            ADDHISTORY (operator$(previousoperator) + operand$)

            operator = SUBTRACTION '                                    remember operator selected
            COMMITOPERAND '                                             save operand

        Case butAdd '                                                   addition clicked

            ADDHISTORY (operator$(previousoperator) + operand$)

            operator = ADDITION '                                       remember operator selected
            COMMITOPERAND '                                             save operand

        Case butEqual '                                                 equal clicked

            history$ = ""
            operator = EQUATE '                                         remember operator selected
            COMMITOPERAND '                                             save operand
            previousoperator = 0


        Case mnuCopy

        Case mnuPaste

        Case mnuAbout
            _Delay 0.2: _MessageBox "Calculator", "InForm Calculator 1.0", "info"

        Case lblAnswer

        Case lblMemory

        Case lblHistory

    End Select
End Sub

Sub __UI_MouseEnter (id As Long)
    Select Case id
        Case Calculator

        Case frmResults

        Case mnuEdit

        Case mnuHelp

        Case butMC

        Case butMR

        Case butMS

        Case butMplus

        Case butMminus

        Case butBS

        Case butCE

        Case butC

        Case butSign

        Case butSQR

        Case but7

        Case but8

        Case but9

        Case butDivide

        Case butPercent

        Case but4

        Case but5

        Case but6

        Case butMultiply

        Case butReciprocate

        Case but1

        Case but2

        Case but3

        Case butSubtract

        Case but0

        Case butPoint

        Case butAdd

        Case butEqual

        Case mnuCopy

        Case mnuPaste

        Case mnuAbout

        Case lblAnswer

        Case lblMemory

        Case lblHistory

    End Select
End Sub

Sub __UI_MouseLeave (id As Long)
    Select Case id
        Case Calculator

        Case frmResults

        Case mnuEdit

        Case mnuHelp

        Case butMC

        Case butMR

        Case butMS

        Case butMplus

        Case butMminus

        Case butBS

        Case butCE

        Case butC

        Case butSign

        Case butSQR

        Case but7

        Case but8

        Case but9

        Case butDivide

        Case butPercent

        Case but4

        Case but5

        Case but6

        Case butMultiply

        Case butReciprocate

        Case but1

        Case but2

        Case but3

        Case butSubtract

        Case but0

        Case butPoint

        Case butAdd

        Case butEqual

        Case mnuCopy

        Case mnuPaste

        Case mnuAbout

        Case lblAnswer

        Case lblMemory

        Case lblHistory

    End Select
End Sub

Sub __UI_FocusIn (id As Long)
    Select Case id
        Case butMC

        Case butMR

        Case butMS

        Case butMplus

        Case butMminus

        Case butBS

        Case butCE

        Case butC

        Case butSign

        Case butSQR

        Case but7

        Case but8

        Case but9

        Case butDivide

        Case butPercent

        Case but4

        Case but5

        Case but6

        Case butMultiply

        Case butReciprocate

        Case but1

        Case but2

        Case but3

        Case butSubtract

        Case but0

        Case butPoint

        Case butAdd

        Case butEqual

    End Select
End Sub

Sub __UI_FocusOut (id As Long)
    'This event occurs right before a control loses focus.
    'To prevent a control from losing focus, set __UI_KeepFocus = True below.
    Select Case id
        Case butMC

        Case butMR

        Case butMS

        Case butMplus

        Case butMminus

        Case butBS

        Case butCE

        Case butC

        Case butSign

        Case butSQR

        Case but7

        Case but8

        Case but9

        Case butDivide

        Case butPercent

        Case but4

        Case but5

        Case but6

        Case butMultiply

        Case butReciprocate

        Case but1

        Case but2

        Case but3

        Case butSubtract

        Case but0

        Case butPoint

        Case butAdd

        Case butEqual

    End Select
End Sub

Sub __UI_MouseDown (id As Long)
    Select Case id
        Case Calculator

        Case frmResults

        Case mnuEdit

        Case mnuHelp

        Case butMC

        Case butMR

        Case butMS

        Case butMplus

        Case butMminus

        Case butBS

        Case butCE

        Case butC

        Case butSign

        Case butSQR

        Case but7

        Case but8

        Case but9

        Case butDivide

        Case butPercent

        Case but4

        Case but5

        Case but6

        Case butMultiply

        Case butReciprocate

        Case but1

        Case but2

        Case but3

        Case butSubtract

        Case but0

        Case butPoint

        Case butAdd

        Case butEqual

        Case mnuCopy

        Case mnuPaste

        Case mnuAbout

        Case lblAnswer

        Case lblMemory

        Case lblHistory

    End Select
End Sub

Sub __UI_MouseUp (id As Long)
    Select Case id
        Case Calculator

        Case frmResults

        Case mnuEdit

        Case mnuHelp

        Case butMC

        Case butMR

        Case butMS

        Case butMplus

        Case butMminus

        Case butBS

        Case butCE

        Case butC

        Case butSign

        Case butSQR

        Case but7

        Case but8

        Case but9

        Case butDivide

        Case butPercent

        Case but4

        Case but5

        Case but6

        Case butMultiply

        Case butReciprocate

        Case but1

        Case but2

        Case but3

        Case butSubtract

        Case but0

        Case butPoint

        Case butAdd

        Case butEqual

        Case mnuCopy

        Case mnuPaste

        Case mnuAbout

        Case lblAnswer

        Case lblMemory

        Case lblHistory

    End Select
End Sub

Sub __UI_KeyPress (id As Long)
    'When this event is fired, __UI_KeyHit will contain the code of the key hit.
    'You can change it and even cancel it by making it = 0

    Select Case id
        Case butMC

        Case butMR

        Case butMS

        Case butMplus

        Case butMminus

        Case butBS

        Case butCE

        Case butC

        Case butSign

        Case butSQR

        Case but7

        Case but8

        Case but9

        Case butDivide

        Case butPercent

        Case but4

        Case but5

        Case but6

        Case butMultiply

        Case butReciprocate

        Case but1

        Case but2

        Case but3

        Case butSubtract

        Case but0

        Case butPoint

        Case butAdd

        Case butEqual

    End Select
End Sub

Sub __UI_TextChanged (id As Long)
    Select Case id
    End Select
End Sub

Sub __UI_ValueChanged (id As Long)
    Select Case id
    End Select
End Sub

Sub __UI_FormResized

End Sub

'$INCLUDE:'InForm\InForm.ui'
'$INCLUDE:'InForm\xp.uitheme'

