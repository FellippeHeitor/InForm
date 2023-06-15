': This program uses
': InForm - GUI library for QB64 - v1.0
': Fellippe Heitor, 2016-2019 - fellippe@qb64.org - @fellippeheitor
': https://github.com/FellippeHeitor/InForm
'-----------------------------------------------------------

Option _Explicit

': Controls' IDs: ------------------------------------------------------------------
Dim Shared Stopwatch As Long
Dim Shared TimeLB As Long
Dim Shared StartBT As Long
Dim Shared LapBT As Long
Dim Shared StopBT As Long
Dim Shared ListBox1 As Long

Dim Shared start As Single, Running As _Byte
Dim Shared second As Integer, minute As Integer, hour As Integer
Dim Shared elapsed As Single

': External modules: ---------------------------------------------------------------
'$INCLUDE:'InForm\InForm.bi'
'$INCLUDE:'Stopwatch.frm'

': Event procedures: ---------------------------------------------------------------
Sub __UI_BeforeInit

End Sub

Sub __UI_OnLoad
    __UI_DefaultButtonID = StartBT
End Sub

Sub __UI_BeforeUpdateDisplay
    If Running Then
        Dim theTime$

        elapsed = Timer - start
        If elapsed >= 1 Then
            second = second + 1
            elapsed = elapsed - 1
            start = start + 1
            If second >= 60 Then
                second = second - 60
                minute = minute + 1
                If minute >= 60 Then
                    minute = minute - 60
                    hour = hour + 1
                End If
            End If
        End If

        Dim hour$: hour$ = Right$("00" + LTrim$(Str$(hour)), 2)
        Dim min$: min$ = Right$("00" + LTrim$(Str$(minute)), 2)
        Dim sec$: sec$ = Right$("00" + LTrim$(Str$(second)), 2)
        Dim elapsed$: elapsed$ = Mid$(Str$(elapsed), InStr(Str$(elapsed), ".") + 1) + "000"

        theTime$ = hour$ + ":" + min$ + ":" + sec$ + "," + Left$(elapsed$, 3)

        Caption(TimeLB) = theTime$
    End If
End Sub

Sub __UI_BeforeUnload
End Sub

Sub __UI_Click (id As Long)
    Select Case id
        Case Stopwatch

        Case TimeLB

        Case StartBT
            If Running Then
                Caption(id) = "Start"
                Running = False
                Control(StopBT).Disabled = False
                Control(LapBT).Disabled = True
            Else
                Caption(id) = "Pause"
                start = Timer - elapsed
                Running = True
                Control(StopBT).Disabled = True
                Control(LapBT).Disabled = False
            End If
        Case LapBT
            AddItem ListBox1, Caption(TimeLB)
        Case StopBT
            second = 0
            minute = 0
            hour = 0
            elapsed = 0
            Caption(TimeLB) = "00:00:00,000"
            ResetList ListBox1
        Case ListBox1

    End Select
End Sub

Sub __UI_MouseEnter (id As Long)
    Select Case id
        Case Stopwatch

        Case TimeLB

        Case StartBT

        Case LapBT

        Case StopBT

        Case ListBox1

    End Select
End Sub

Sub __UI_MouseLeave (id As Long)
    Select Case id
        Case Stopwatch

        Case TimeLB

        Case StartBT

        Case LapBT

        Case StopBT

        Case ListBox1

    End Select
End Sub

Sub __UI_FocusIn (id As Long)
    Select Case id
        Case StartBT

        Case LapBT

        Case StopBT

        Case ListBox1

    End Select
End Sub

Sub __UI_FocusOut (id As Long)
    Select Case id
        Case StartBT

        Case LapBT

        Case StopBT

        Case ListBox1

    End Select
End Sub

Sub __UI_MouseDown (id As Long)
    Select Case id
        Case Stopwatch

        Case TimeLB

        Case StartBT

        Case LapBT

        Case StopBT

        Case ListBox1

    End Select
End Sub

Sub __UI_MouseUp (id As Long)
    Select Case id
        Case Stopwatch

        Case TimeLB

        Case StartBT

        Case LapBT

        Case StopBT

        Case ListBox1

    End Select
End Sub

Sub __UI_KeyPress (id As Long)
    Select Case id
        Case StartBT

        Case LapBT

        Case StopBT

        Case ListBox1

    End Select
End Sub

Sub __UI_TextChanged (id As Long)
    Select Case id
    End Select
End Sub

Sub __UI_ValueChanged (id As Long)
    Select Case id
        Case ListBox1

    End Select
End Sub

Sub __UI_FormResized

End Sub

'$INCLUDE:'InForm\InForm.ui'
'$INCLUDE:'InForm\xp.uitheme'
