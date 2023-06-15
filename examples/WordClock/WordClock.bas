': This program uses
': InForm - GUI library for QB64 - v1.0
': Fellippe Heitor, 2016-2019 - fellippe@qb64.org - @fellippeheitor
': https://github.com/FellippeHeitor/InForm
'-----------------------------------------------------------

Option _Explicit

': Controls' IDs: ------------------------------------------------------------------
Dim Shared WordClock As Long
Dim Shared ITISLB As Long
Dim Shared HALFLB As Long
Dim Shared TENLB As Long
Dim Shared QUARTERLB As Long
Dim Shared TWENTYLB As Long
Dim Shared FIVELB As Long
Dim Shared MINUTESLB As Long
Dim Shared TOLB As Long
Dim Shared PASTLB As Long
Dim Shared TWOLB As Long
Dim Shared THREELB As Long
Dim Shared ONELB As Long
Dim Shared FOURLB As Long
Dim Shared FIVELB2 As Long
Dim Shared SIXLB As Long
Dim Shared SEVENLB As Long
Dim Shared EIGHTLB As Long
Dim Shared NINELB As Long
Dim Shared TENLB2 As Long
Dim Shared ELEVENLB As Long
Dim Shared TWELVELB As Long
Dim Shared OCLOCKLB As Long
Dim Shared DotsLB As Long
Dim Shared BackDots As Long

Dim Shared Word(1 To 22) As Long

': External modules: ---------------------------------------------------------------
'$INCLUDE:'InForm\InForm.bi'
'$INCLUDE:'WordClock.frm'

': Event procedures: ---------------------------------------------------------------
Sub __UI_BeforeInit

End Sub

Sub __UI_OnLoad
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
End Sub

Sub __UI_BeforeUpdateDisplay
    'This event occurs at approximately 30 frames per second.
    'You can change the update frequency by calling SetFrameRate DesiredRate%

    Dim i As Integer, h As Integer, m As Integer
    Dim dots As Integer
    Static prevH As Integer, prevM As Integer

    h = Val(Left$(Time$, 2))
    m = Val(Mid$(Time$, 4, 2))

    If h = prevH And m = prevM Then Exit Sub

    prevH = h
    prevM = m
    switchOffAllWords

    switchOn ITISLB
    switchOn MINUTESLB
    Select Case m
        Case 0 To 4
            switchOn OCLOCKLB
            switchOff MINUTESLB
            dots = m
        Case 5 To 9
            switchOn FIVELB
            switchOn PASTLB
            dots = m - 5
        Case 10 To 14
            switchOn TENLB
            switchOn PASTLB
            dots = m - 10
        Case 15 To 19
            switchOn QUARTERLB
            switchOff MINUTESLB
            switchOn PASTLB
            dots = m - 15
        Case 20 To 24
            switchOn TWENTYLB
            switchOn PASTLB
            dots = m - 20
        Case 25 To 29
            switchOn TWENTYLB
            switchOn FIVELB
            switchOn PASTLB
            dots = m - 25
        Case 30 To 34
            switchOn HALFLB
            switchOff MINUTESLB
            switchOn PASTLB
            dots = m - 30
        Case 35 To 39
            switchOn TWENTYLB
            switchOn FIVELB
            switchOn TOLB
            dots = m - 35
        Case 40 To 44
            switchOn TWENTYLB
            switchOn TOLB
            dots = m - 40
        Case 45 To 49
            switchOn QUARTERLB
            switchOff MINUTESLB
            switchOn TOLB
            dots = m - 45
        Case 50 To 54
            switchOn TENLB
            switchOn TOLB
            dots = m - 50
        Case 55 To 59
            switchOn FIVELB
            switchOn TOLB
            dots = m - 55
    End Select

    Caption(DotsLB) = ""
    For i = 1 To dots
        Caption(DotsLB) = Caption(DotsLB) + "* "
    Next

    If m >= 35 Then
        h = h + 1
    End If

    Select Case h
        Case 1, 13
            switchOn ONELB
        Case 2, 14
            switchOn TWOLB
        Case 3, 15
            switchOn THREELB
        Case 4, 16
            switchOn FOURLB
        Case 5, 17
            switchOn FIVELB2
        Case 6, 18
            switchOn SIXLB
        Case 7, 19
            switchOn SEVENLB
        Case 8, 20
            switchOn EIGHTLB
        Case 9, 21
            switchOn NINELB
        Case 10, 22
            switchOn TENLB2
        Case 11, 23
            switchOn ELEVENLB
        Case 0, 12
            switchOn TWELVELB
    End Select
End Sub

Sub switchOffAllWords
    Dim i As Integer
    For i = 1 To UBound(Word)
        switchOff Word(i)
    Next
End Sub

Sub switchOn (this As Long)
    Control(this).ForeColor = _RGB32(111, 205, 0)
    Control(this).Redraw = True
End Sub

Sub switchOff (this As Long)
    Control(this).ForeColor = _RGB32(0, 39, 0)
    Control(this).Redraw = True
End Sub

Sub __UI_BeforeUnload
    'If you set __UI_UnloadSignal = False here you can
    'cancel the user's request to close.

End Sub

Sub __UI_Click (id As Long)
    Select Case id
        Case WordClock

        Case ITISLB

        Case HALFLB

        Case TENLB

        Case QUARTERLB

        Case TWENTYLB

        Case FIVELB

        Case MINUTESLB

        Case TOLB

        Case PASTLB

        Case TWOLB

        Case THREELB

        Case ONELB

        Case FOURLB

        Case FIVELB2

        Case SIXLB

        Case SEVENLB

        Case EIGHTLB

        Case NINELB

        Case TENLB2

        Case ELEVENLB

        Case TWELVELB

        Case OCLOCKLB

    End Select
End Sub

Sub __UI_MouseEnter (id As Long)
    Select Case id
        Case WordClock

        Case ITISLB

        Case HALFLB

        Case TENLB

        Case QUARTERLB

        Case TWENTYLB

        Case FIVELB

        Case MINUTESLB

        Case TOLB

        Case PASTLB

        Case TWOLB

        Case THREELB

        Case ONELB

        Case FOURLB

        Case FIVELB2

        Case SIXLB

        Case SEVENLB

        Case EIGHTLB

        Case NINELB

        Case TENLB2

        Case ELEVENLB

        Case TWELVELB

        Case OCLOCKLB

    End Select
End Sub

Sub __UI_MouseLeave (id As Long)
    Select Case id
        Case WordClock

        Case ITISLB

        Case HALFLB

        Case TENLB

        Case QUARTERLB

        Case TWENTYLB

        Case FIVELB

        Case MINUTESLB

        Case TOLB

        Case PASTLB

        Case TWOLB

        Case THREELB

        Case ONELB

        Case FOURLB

        Case FIVELB2

        Case SIXLB

        Case SEVENLB

        Case EIGHTLB

        Case NINELB

        Case TENLB2

        Case ELEVENLB

        Case TWELVELB

        Case OCLOCKLB

    End Select
End Sub

Sub __UI_FocusIn (id As Long)
    Select Case id
    End Select
End Sub

Sub __UI_FocusOut (id As Long)
    'This event occurs right before a control loses focus.
    'To prevent a control from losing focus, set __UI_KeepFocus = True below.
    Select Case id
    End Select
End Sub

Sub __UI_MouseDown (id As Long)
    Select Case id
        Case WordClock

        Case ITISLB

        Case HALFLB

        Case TENLB

        Case QUARTERLB

        Case TWENTYLB

        Case FIVELB

        Case MINUTESLB

        Case TOLB

        Case PASTLB

        Case TWOLB

        Case THREELB

        Case ONELB

        Case FOURLB

        Case FIVELB2

        Case SIXLB

        Case SEVENLB

        Case EIGHTLB

        Case NINELB

        Case TENLB2

        Case ELEVENLB

        Case TWELVELB

        Case OCLOCKLB

    End Select
End Sub

Sub __UI_MouseUp (id As Long)
    Select Case id
        Case WordClock

        Case ITISLB

        Case HALFLB

        Case TENLB

        Case QUARTERLB

        Case TWENTYLB

        Case FIVELB

        Case MINUTESLB

        Case TOLB

        Case PASTLB

        Case TWOLB

        Case THREELB

        Case ONELB

        Case FOURLB

        Case FIVELB2

        Case SIXLB

        Case SEVENLB

        Case EIGHTLB

        Case NINELB

        Case TENLB2

        Case ELEVENLB

        Case TWELVELB

        Case OCLOCKLB

    End Select
End Sub

Sub __UI_KeyPress (id As Long)
    'When this event is fired, __UI_KeyHit will contain the code of the key hit.
    'You can change it and even cancel it by making it = 0
    Select Case id
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
