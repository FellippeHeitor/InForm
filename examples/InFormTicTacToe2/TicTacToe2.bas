': This program uses
': InForm - GUI library for QB64 - v1.0
': Fellippe Heitor, 2016-2019 - fellippe@qb64.org - @fellippeheitor
': https://github.com/FellippeHeitor/InForm
'-----------------------------------------------------------

Option _Explicit

Dim Shared ThisTurn As _Byte

': Controls' IDs: ------------------------------------------------------------------
Dim Shared TicTacToe2 As Long
Dim Shared Button1 As Long
Dim Shared Button2 As Long
Dim Shared Button3 As Long
Dim Shared Button4 As Long
Dim Shared Button5 As Long
Dim Shared Button6 As Long
Dim Shared Button7 As Long
Dim Shared Button8 As Long
Dim Shared Button9 As Long

': External modules: ---------------------------------------------------------------
'$INCLUDE:'InForm\InForm.bi'
'$INCLUDE:'TicTacToe2.frm'

': Custom functions: ---------------------------------------------------------------
Sub MessageBox (message As String, caption As String, icon As String)
    _Delay 0.2 ' delay a bit to allow InFrom to draw and refresh all comtrols before the modal dialog box takes over
    _MessageBox caption, message, icon
End Sub

': Event procedures: ---------------------------------------------------------------
Sub __UI_BeforeInit

End Sub

Sub __UI_OnLoad
    ThisTurn = 1
End Sub

Sub __UI_BeforeUpdateDisplay

End Sub

Sub __UI_BeforeUnload

End Sub

Sub __UI_Click (id As Long)
    If Control(id).Type = __UI_Type_Label Then
        If Control(id).Value = 0 Then
            Control(id).Value = ThisTurn
            If ThisTurn = 1 Then
                Caption(id) = "X": ThisTurn = 2
                Control(id).ForeColor = _RGB32(255, 255, 255)
                Control(id).BackColor = _RGB32(200, 0, 0)
            Else
                Caption(id) = "O": ThisTurn = 1
                Control(id).BackColor = _RGB32(0, 200, 0)
            End If
            CheckVictory
        End If
    End If
End Sub

Sub CheckVictory
    Dim Winner As _Byte

    If Control(Button1).Value = Control(Button2).Value And Control(Button2).Value = Control(Button3).Value Then
        Winner = Control(Button1).Value
    ElseIf Control(Button4).Value = Control(Button5).Value And Control(Button5).Value = Control(Button6).Value Then
        Winner = Control(Button4).Value
    ElseIf Control(Button7).Value = Control(Button8).Value And Control(Button8).Value = Control(Button9).Value Then
        Winner = Control(Button7).Value
    ElseIf Control(Button1).Value = Control(Button4).Value And Control(Button4).Value = Control(Button7).Value Then
        Winner = Control(Button1).Value
    ElseIf Control(Button2).Value = Control(Button5).Value And Control(Button5).Value = Control(Button8).Value Then
        Winner = Control(Button2).Value
    ElseIf Control(Button3).Value = Control(Button6).Value And Control(Button6).Value = Control(Button9).Value Then
        Winner = Control(Button3).Value
    ElseIf Control(Button1).Value = Control(Button5).Value And Control(Button5).Value = Control(Button9).Value Then
        Winner = Control(Button1).Value
    ElseIf Control(Button7).Value = Control(Button5).Value And Control(Button5).Value = Control(Button3).Value Then
        Winner = Control(Button7).Value
    End If

    If Winner > 0 Then
        MessageBox "Player" + Str$(Winner) + " won!", "Tic Tac Toe", "info"
        System
    End If
End Sub

Sub __UI_MouseEnter (id As Long)
    If Control(id).Type = __UI_Type_Label Then
        If Control(id).Value = 0 Then
            Control(id).BackColor = _RGB32(44, 94, 128)
        End If
    End If
End Sub

Sub __UI_MouseLeave (id As Long)
    If Control(id).Type = __UI_Type_Label Then
        If Control(id).Value = 0 Then
            Control(id).BackColor = _RGB32(127, 170, 255)
        End If
    End If
End Sub

Sub __UI_FocusIn (id As Long)
    Select Case id
    End Select
End Sub

Sub __UI_FocusOut (id As Long)
    Select Case id
    End Select
End Sub

Sub __UI_MouseDown (id As Long)
    Select Case id
        Case TicTacToe2

        Case Button1

        Case Button2

        Case Button3

        Case Button4

        Case Button5

        Case Button6

        Case Button7

        Case Button8

        Case Button9

    End Select
End Sub

Sub __UI_MouseUp (id As Long)
    Select Case id
        Case TicTacToe2

        Case Button1

        Case Button2

        Case Button3

        Case Button4

        Case Button5

        Case Button6

        Case Button7

        Case Button8

        Case Button9

    End Select
End Sub

Sub __UI_KeyPress (id As Long)
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
