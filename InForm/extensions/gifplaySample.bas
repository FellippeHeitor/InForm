': This program uses
': InForm - GUI library for QB64 - Beta version 9
': Fellippe Heitor, 2016-2019 - fellippe@qb64.org - @fellippeheitor
': https://github.com/FellippeHeitor/InForm
'-----------------------------------------------------------

': Controls' IDs: ------------------------------------------------------------------
Dim Shared gifplaySample As Long
Dim Shared PictureBox1 As Long
Dim Shared LoadBT As Long
Dim Shared PlayBT As Long

': External modules: ---------------------------------------------------------------
'$INCLUDE:'gifplay.bi'
'$INCLUDE:'..\InForm.bi'
'$INCLUDE:'..\xp.uitheme'
'$INCLUDE:'gifplaySample.frm'
'$INCLUDE:'gifplay.bm'

': Event procedures: ---------------------------------------------------------------
Sub __UI_BeforeInit

End Sub

Sub __UI_OnLoad
    Control(PlayBT).Disabled = True
End Sub

Sub __UI_BeforeUpdateDisplay
    UpdateGif PictureBox1
End Sub

Sub __UI_BeforeUnload
End Sub

Sub __UI_Click (id As Long)
    Select Case id
        Case LoadBT
            'file 'globe.gif' comes from:
            'https://en.wikipedia.org/wiki/GIF#/media/File:Rotating_earth_(large).gif
            If OpenGif(PictureBox1, "globe.gif") Then
                Control(PlayBT).Disabled = False
                If TotalFrames(PictureBox1) > 1 Then
                    Caption(PlayBT) = "Play"
                Else
                    Caption(PlayBT) = "Static gif"
                    Control(PlayBT).Disabled = True
                End If
                Caption(LoadBT) = "globe.gif loaded"
                Control(LoadBT).Disabled = True
            Else
                _MessageBox "GIFPlay Sample", "File 'globe.gif' could not be found.", "error"
            End If
        Case PlayBT
            If GifIsPlaying(PictureBox1) Then
                PauseGif PictureBox1
                Caption(PlayBT) = "Play"
            Else
                PlayGif PictureBox1
                Caption(PlayBT) = "Pause"
            End If
        Case PictureBox1
            HideGifOverlay PictureBox1
    End Select
End Sub

Sub __UI_MouseEnter (id As Long)
End Sub

Sub __UI_MouseLeave (id As Long)
End Sub

Sub __UI_FocusIn (id As Long)
End Sub

Sub __UI_FocusOut (id As Long)
End Sub

Sub __UI_MouseDown (id As Long)
End Sub

Sub __UI_MouseUp (id As Long)
End Sub

Sub __UI_KeyPress (id As Long)
End Sub

Sub __UI_TextChanged (id As Long)
End Sub

Sub __UI_ValueChanged (id As Long)
End Sub

Sub __UI_FormResized
End Sub

'$INCLUDE:'..\InForm.ui'

