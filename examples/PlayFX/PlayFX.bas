': This program uses
': InForm - GUI library for QB64 - v1.5
': Fellippe Heitor, 2016-2023 - fellippe@qb64.org - @fellippeheitor
': https://github.com/FellippeHeitor/InForm
'-----------------------------------------------------------

Option _Explicit

Type WaveformType
    active As Long
    waveform As Long
    note As Long
    length As Long
    lengthType As Long
    tempo As Long
    volume As Long
    volRamp As Long
End Type

Dim Shared Waveform(1 To 5) As WaveformType, currentWaveform As Long, currentControl As Long

': Controls' IDs: ------------------------------------------------------------------
Dim Shared PlayFXDesigner As Long
Dim Shared Waveforms As Long
Dim Shared ConfigureWaveform As Long
Dim Shared PlayFX As Long
Dim Shared Waveform1TB As Long
Dim Shared Waveform2TB As Long
Dim Shared Waveform3TB As Long
Dim Shared Waveform4TB As Long
Dim Shared Waveform5TB As Long
Dim Shared WaveformLB As Long
Dim Shared WaveformSlider As Long
Dim Shared WaveformNameLB As Long
Dim Shared NoteLB As Long
Dim Shared NoteSlider As Long
Dim Shared LengthLB As Long
Dim Shared LengthSlider As Long
Dim Shared LengthEffectsDL As Long
Dim Shared TempoLB As Long
Dim Shared TempoSlider As Long
Dim Shared VolumeLB As Long
Dim Shared VolumeSlider As Long
Dim Shared VolRampLB As Long
Dim Shared VolRampSlider As Long
Dim Shared PlayFXTB As Long
Dim Shared PlayBT As Long

': External modules: ---------------------------------------------------------------
'$INCLUDE:'InForm\InForm.bi'
'$INCLUDE:'InForm\xp.uitheme'
'$INCLUDE:'PlayFX.frm'

': Custom procedures: --------------------------------------------------------------
Function IsDifferentWaveform%% (w1 As WaveformType, w2 As WaveformType)
    IsDifferentWaveform = w1.waveform <> w2.waveform Or w1.note <> w2.note Or w1.length <> w2.length Or w1.lengthType <> w2.lengthType Or w1.tempo <> w2.tempo Or w1.volume <> w2.volume Or w1.volRamp <> w2.volRamp
End Function

Sub SetConfigControls (id As Long, curCtrl As Long)
    Control(WaveformSlider).Value = Waveform(id).waveform
    Control(NoteSlider).Value = Waveform(id).note
    Control(LengthSlider).Value = Waveform(id).length
    Control(LengthEffectsDL).Value = Waveform(id).lengthType
    Control(TempoSlider).Value = Waveform(id).tempo
    Control(VolumeSlider).Value = Waveform(id).volume
    Control(VolRampSlider).Value = Waveform(id).volRamp

    currentWaveform = id
    currentControl = curCtrl
End Sub

Sub ClearWaveform (id As Long)
    Waveform(id).active = False ' set not in use
    Waveform(id).waveform = 3 ' triangle
    Waveform(id).note = 42 ' half-way through the scale
    Waveform(id).length = 4 ' quarter
    Waveform(id).lengthType = 1 ' normal
    Waveform(id).tempo = 120 ' 120
    Waveform(id).volume = 100 ' max
    Waveform(id).volRamp = 10 ' 10 ms
End Sub

Sub MakePlayString
    Dim s As String

    If Waveform(currentWaveform).active Then
        s = "T" + LTrim$(Str$(Waveform(currentWaveform).tempo)) + "L" + LTrim$(Str$(Waveform(currentWaveform).length))

        Select Case Waveform(currentWaveform).lengthType
            Case 1
                s = s + "MN"

            Case 2
                s = s + "ML"

            Case 3
                s = s + "MS"
        End Select

        s = s + "V" + LTrim$(Str$(Waveform(currentWaveform).volume)) + "Q" + LTrim$(Str$(Waveform(currentWaveform).volRamp))
        s = s + "@" + LTrim$(Str$(Waveform(currentWaveform).waveform)) + "N" + LTrim$(Str$(Waveform(currentWaveform).note))
    End If

    Text(currentControl) = s
End Sub

Sub MakePlayFXString
    Text(PlayFXTB) = "MB"

    If Text(Waveform1TB) <> "" Then
        Text(PlayFXTB) = Text(PlayFXTB) + Text(Waveform1TB)
    End If

    If Text(Waveform2TB) <> "" Then
        Text(PlayFXTB) = Text(PlayFXTB) + "," + Text(Waveform2TB)
    End If

    If Text(Waveform3TB) <> "" Then
        Text(PlayFXTB) = Text(PlayFXTB) + "," + Text(Waveform3TB)
    End If

    If Text(Waveform4TB) <> "" Then
        Text(PlayFXTB) = Text(PlayFXTB) + "," + Text(Waveform4TB)
    End If

    If Text(Waveform5TB) <> "" Then
        Text(PlayFXTB) = Text(PlayFXTB) + "," + Text(Waveform5TB)
    End If
End Sub

': Event procedures: ---------------------------------------------------------------
Sub __UI_BeforeInit

End Sub

Sub __UI_OnLoad
    Dim i As Long
    For i = 1 To 5
        ClearWaveform i
    Next

    SetConfigControls 1, Waveform1TB
    SetFocus Waveform1TB
End Sub

Sub __UI_BeforeUpdateDisplay
    'This event occurs at approximately 60 frames per second.
    'You can change the update frequency by calling SetFrameRate DesiredRate%

End Sub

Sub __UI_BeforeUnload
    'If you set __UI_UnloadSignal = False here you can
    'cancel the user's request to close.

End Sub

Sub __UI_Click (id As Long)
    Select Case id
        Case PlayFX

        Case PlayFXTB

        Case PlayBT
            Play Text(PlayFXTB)

        Case WaveformSlider

        Case WaveformNameLB

        Case NoteSlider

        Case LengthSlider

        Case LengthEffectsDL

        Case TempoSlider

        Case VolumeSlider

        Case NoteLB

        Case LengthLB

        Case TempoLB

        Case VolumeLB

        Case WaveformLB

        Case PlayFXDesigner

        Case Waveforms

        Case Waveform1TB

        Case Waveform2TB

        Case Waveform3TB

        Case Waveform4TB

        Case Waveform5TB

        Case ConfigureWaveform

    End Select
End Sub

Sub __UI_MouseEnter (id As Long)
    Select Case id
        Case PlayFX

        Case PlayFXTB

        Case PlayBT

        Case WaveformSlider

        Case WaveformNameLB

        Case NoteSlider

        Case LengthSlider

        Case LengthEffectsDL

        Case TempoSlider

        Case VolumeSlider

        Case NoteLB

        Case LengthLB

        Case TempoLB

        Case VolumeLB

        Case WaveformLB

        Case PlayFXDesigner

        Case Waveforms

        Case Waveform1TB

        Case Waveform2TB

        Case Waveform3TB

        Case Waveform4TB

        Case Waveform5TB

        Case ConfigureWaveform

    End Select
End Sub

Sub __UI_MouseLeave (id As Long)
    Select Case id
        Case PlayFX

        Case PlayFXTB

        Case PlayBT

        Case WaveformSlider

        Case WaveformNameLB

        Case NoteSlider

        Case LengthSlider

        Case LengthEffectsDL

        Case TempoSlider

        Case VolumeSlider

        Case NoteLB

        Case LengthLB

        Case TempoLB

        Case VolumeLB

        Case WaveformLB

        Case PlayFXDesigner

        Case Waveforms

        Case Waveform1TB

        Case Waveform2TB

        Case Waveform3TB

        Case Waveform4TB

        Case Waveform5TB

        Case ConfigureWaveform

    End Select
End Sub

Sub __UI_FocusIn (id As Long)
    Select Case id
        Case PlayFXTB

        Case PlayBT

        Case WaveformSlider

        Case NoteSlider

        Case LengthSlider

        Case LengthEffectsDL

        Case TempoSlider

        Case VolumeSlider

        Case Waveform1TB
            SetConfigControls 1, Waveform1TB

        Case Waveform2TB
            SetConfigControls 2, Waveform2TB

        Case Waveform3TB
            SetConfigControls 3, Waveform3TB

        Case Waveform4TB
            SetConfigControls 4, Waveform4TB

        Case Waveform5TB
            SetConfigControls 5, Waveform5TB

    End Select
End Sub

Sub __UI_FocusOut (id As Long)
    'This event occurs right before a control loses focus.
    'To prevent a control from losing focus, set __UI_KeepFocus = True below.
    Select Case id
        Case PlayFXTB

        Case PlayBT

        Case WaveformSlider

        Case NoteSlider

        Case LengthSlider

        Case LengthEffectsDL

        Case TempoSlider

        Case VolumeSlider

        Case Waveform1TB

        Case Waveform2TB

        Case Waveform3TB

        Case Waveform4TB

        Case Waveform5TB

    End Select
End Sub

Sub __UI_MouseDown (id As Long)
    Select Case id
        Case PlayFX

        Case PlayFXTB

        Case PlayBT

        Case WaveformSlider

        Case WaveformNameLB

        Case NoteSlider

        Case LengthSlider

        Case LengthEffectsDL

        Case TempoSlider

        Case VolumeSlider

        Case NoteLB

        Case LengthLB

        Case TempoLB

        Case VolumeLB

        Case WaveformLB

        Case PlayFXDesigner

        Case Waveforms

        Case Waveform1TB

        Case Waveform2TB

        Case Waveform3TB

        Case Waveform4TB

        Case Waveform5TB

        Case ConfigureWaveform

    End Select
End Sub

Sub __UI_MouseUp (id As Long)
    Select Case id
        Case PlayFX

        Case PlayFXTB

        Case PlayBT

        Case WaveformSlider

        Case WaveformNameLB

        Case NoteSlider

        Case LengthSlider

        Case LengthEffectsDL

        Case TempoSlider

        Case VolumeSlider

        Case NoteLB

        Case LengthLB

        Case TempoLB

        Case VolumeLB

        Case WaveformLB

        Case PlayFXDesigner

        Case Waveforms

        Case Waveform1TB

        Case Waveform2TB

        Case Waveform3TB

        Case Waveform4TB

        Case Waveform5TB

        Case ConfigureWaveform

    End Select
End Sub

Sub __UI_KeyPress (id As Long)
    'When this event is fired, __UI_KeyHit will contain the code of the key hit.
    'You can change it and even cancel it by making it = 0
    Select Case id
        Case PlayFXTB

        Case PlayBT

        Case WaveformSlider

        Case NoteSlider

        Case LengthSlider

        Case LengthEffectsDL

        Case TempoSlider

        Case VolumeSlider

        Case Waveform1TB

        Case Waveform2TB

        Case Waveform3TB

        Case Waveform4TB

        Case Waveform5TB

    End Select
End Sub

Sub __UI_TextChanged (id As Long)
    Select Case id
        Case PlayFXTB

        Case Waveform1TB
            If Text(id) = "" Then
                ClearWaveform 1
                SetConfigControls 1, Waveform1TB
            End If

        Case Waveform2TB
            If Text(id) = "" Then
                ClearWaveform 2
                SetConfigControls 2, Waveform2TB
            End If

        Case Waveform3TB
            If Text(id) = "" Then
                ClearWaveform 3
                SetConfigControls 3, Waveform3TB
            End If

        Case Waveform4TB
            If Text(id) = "" Then
                ClearWaveform 4
                SetConfigControls 4, Waveform4TB
            End If

        Case Waveform5TB
            If Text(id) = "" Then
                ClearWaveform 5
                SetConfigControls 5, Waveform5TB
            End If

    End Select
End Sub

Sub __UI_ValueChanged (id As Long)
    Select Case id
        Case WaveformSlider
            Select Case Control(id).Value
                Case 1
                    SetCaption WaveformNameLB, "Square"

                Case 2
                    SetCaption WaveformNameLB, "Sawtooth"

                Case 3
                    SetCaption WaveformNameLB, "Triangle"

                Case 4
                    SetCaption WaveformNameLB, "Sine"

                Case 5
                    SetCaption WaveformNameLB, "Noise"
            End Select

        Case NoteSlider

        Case LengthSlider

        Case LengthEffectsDL

        Case TempoSlider

        Case VolumeSlider

        Case VolRampSlider

    End Select

    Dim temp As WaveformType
    temp.waveform = Control(WaveformSlider).Value
    temp.note = Control(NoteSlider).Value
    temp.length = Control(LengthSlider).Value
    temp.lengthType = Control(LengthEffectsDL).Value
    temp.tempo = Control(TempoSlider).Value
    temp.volume = Control(VolumeSlider).Value
    temp.volRamp = Control(VolRampSlider).Value

    If IsDifferentWaveform(temp, Waveform(currentWaveform)) Then
        Waveform(currentWaveform) = temp
        Waveform(currentWaveform).active = True
    End If

    MakePlayString
    MakePlayFXString
End Sub

Sub __UI_FormResized

End Sub

'$INCLUDE:'InForm\InForm.ui'
