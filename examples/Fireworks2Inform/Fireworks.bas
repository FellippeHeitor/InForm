': This program uses
': InForm - GUI library for QB64 - v1.0
': Fellippe Heitor, 2016-2019 - fellippe@qb64.org - @fellippeheitor
': https://github.com/FellippeHeitor/InForm
'-----------------------------------------------------------

'Improved fireworks:
'    - Particles now leave a trail behind
'    - Round explosions (sin/cos been used...)
'    - Explosion sound effect.

Option _Explicit

Type Vector
    x As Single
    y As Single
End Type

Type Particle
    Pos As Vector
    Vel As Vector
    Acc As Vector
    Visible As _Byte
    Exploded As _Byte
    ExplosionStep As _Byte
    ExplosionMax As _Byte
    Color As _Unsigned Long
    Size As _Byte
End Type

ReDim Shared Firework(1 To 1) As Particle
ReDim Shared Boom(1 To UBound(Firework) * 2, 1) As Particle
Dim Shared Trail(1 To 20000) As Particle

Dim Shared StartPointLimit As Single, InitialVel As Single
Dim Shared Gravity As Vector, Pause As _Byte, distant As Long

InitialVel = -30
Gravity.y = .8
distant = _SndOpen("distant.wav")

Randomize Timer

': Controls' IDs: ------------------------------------------------------------------
Dim Shared Fireworks As Long
Dim Shared Canvas As Long
Dim Shared MaxFireworksLB As Long
Dim Shared MaxFireworksTrackBar As Long
Dim Shared MaxParticlesLB As Long
Dim Shared MaxParticlesTrackBar As Long
Dim Shared ShowTextCB As Long
Dim Shared YourTextHereTB As Long
Dim Shared HappyNewYearLB As Long

': External modules: ---------------------------------------------------------------
'$INCLUDE:'InForm\InForm.bi'
'$INCLUDE:'InForm\xp.uitheme'
'$INCLUDE:'Fireworks.frm'

': Event procedures: ---------------------------------------------------------------
Sub __UI_BeforeInit

End Sub

Sub __UI_OnLoad
    _Title "Baby, you're a firework"
    StartPointLimit = Control(Canvas).Height / 3
    Control(MaxFireworksTrackBar).Value = 20
    Control(MaxParticlesTrackBar).Value = 150
    ToolTip(MaxFireworksTrackBar) = "20"
    ToolTip(MaxParticlesTrackBar) = "150"
    ReDim _Preserve Firework(1 To Control(MaxFireworksTrackBar).Value) As Particle
    ReDim _Preserve Boom(1 To UBound(Firework) * 2, Control(MaxParticlesTrackBar).Value) As Particle
End Sub

Sub __UI_BeforeUpdateDisplay
    Static JustExploded As _Byte
    Static t As Integer, Initial As _Byte, InitialX As Integer, lastInitial#

    Dim As Long j, i, a
    Dim As _Unsigned Long thisColor

    _Dest Control(Canvas).HelperCanvas

    If JustExploded Then
        JustExploded = False
        Cls , _RGB32(0, 0, 50)
    Else
        Cls
    End If
    If _Ceil(Rnd * 20) < 2 Or (Initial = False And Timer - lastInitial# > .1) Then
        'Create a new particle
        For j = 1 To UBound(Firework)
            If Firework(j).Visible = False Then
                Firework(j).Vel.y = InitialVel
                Firework(j).Vel.x = 3 - _Ceil(Rnd * 6)
                If Initial = True Then
                    Firework(j).Pos.x = _Ceil(Rnd * Control(Canvas).Width)
                Else
                    Firework(j).Pos.x = InitialX * (Control(Canvas).Width / 15)
                    InitialX = InitialX + 1
                    lastInitial# = Timer
                    If InitialX > 15 Then Initial = True
                End If
                Firework(j).Pos.y = Control(Canvas).Height + _Ceil(Rnd * StartPointLimit)
                Firework(j).Visible = True
                Firework(j).Exploded = False
                Firework(j).ExplosionStep = 0
                Firework(j).Size = _Ceil(Rnd * 2)
                If Firework(j).Size = 1 Then
                    Firework(j).ExplosionMax = 9 + _Ceil(Rnd * 41)
                Else
                    Firework(j).ExplosionMax = 9 + _Ceil(Rnd * 71)
                End If
                Firework(j).ExplosionMax = 20 '0
                Exit For
            End If
        Next j
    End If

    'Show trail
    For i = 1 To UBound(Trail)
        If Not Pause Then Trail(i).Color = Darken(Trail(i).Color, 70)
        If Trail(i).Size = 1 Then
            PSet (Trail(i).Pos.x, Trail(i).Pos.y), Trail(i).Color
        Else
            PSet (Trail(i).Pos.x, Trail(i).Pos.y), Trail(i).Color
            PSet (Trail(i).Pos.x - 1, Trail(i).Pos.y), Trail(i).Color
            PSet (Trail(i).Pos.x + 1, Trail(i).Pos.y), Trail(i).Color
            PSet (Trail(i).Pos.x, Trail(i).Pos.y - 1), Trail(i).Color
            PSet (Trail(i).Pos.x, Trail(i).Pos.y + 1), Trail(i).Color
        End If
    Next i

    'Update and show particles
    For i = 1 To UBound(Firework)
        'Update trail particles

        If Firework(i).Visible = True And Firework(i).Exploded = False And Not Pause Then
            t = t + 1: If t > UBound(Trail) Then t = 1
            Trail(t).Pos.x = Firework(i).Pos.x
            Trail(t).Pos.y = Firework(i).Pos.y
            Trail(t).Color = _RGB32(255, 255, 255)

            'New position
            Firework(i).Vel.y = Firework(i).Vel.y + Gravity.y
            Firework(i).Pos.y = Firework(i).Pos.y + Firework(i).Vel.y
            Firework(i).Pos.x = Firework(i).Pos.x + Firework(i).Vel.x
        End If

        'Explode the particle if it reaches max height
        If Firework(i).Vel.y > 0 Then
            If Firework(i).Exploded = False Then
                Firework(i).Exploded = True
                JustExploded = True

                If Firework(1).Size = 1 Then
                    If distant Then _SndPlayCopy distant, .5
                Else
                    If distant Then _SndPlayCopy distant, 1
                End If

                thisColor~& = _RGB32(_Ceil(Rnd * 255), _Ceil(Rnd * 255), _Ceil(Rnd * 255))
                a = 0
                For j = 1 To UBound(Boom, 2)
                    Boom(i, j).Pos.x = Firework(i).Pos.x
                    Boom(i, j).Pos.y = Firework(i).Pos.y
                    Boom(i, j).Vel.y = Sin(a) * (Rnd * 10)
                    Boom(i, j).Vel.x = Cos(a) * (Rnd * 10)
                    a = a + 1
                    Boom(i, j).Color = thisColor~&

                    Boom(i * 2, j).Pos.x = Firework(i).Pos.x + 5
                    Boom(i * 2, j).Pos.y = Firework(i).Pos.y + 5
                    Boom(i * 2, j).Vel.y = Boom(i, j).Vel.y
                    Boom(i * 2, j).Vel.x = Boom(i, j).Vel.x
                    a = a + 1
                    Boom(i * 2, j).Color = thisColor~&
                Next
            End If
        End If

        'Show particle
        If Firework(i).Exploded = False Then
            If Firework(i).Size = 1 Then
                PSet (Firework(i).Pos.x, Firework(i).Pos.y), _RGB32(255, 255, 255)
            Else
                PSet (Firework(i).Pos.x, Firework(i).Pos.y), _RGB32(255, 255, 255)
                PSet (Firework(i).Pos.x - 1, Firework(i).Pos.y), _RGB32(255, 255, 255)
                PSet (Firework(i).Pos.x + 1, Firework(i).Pos.y), _RGB32(255, 255, 255)
                PSet (Firework(i).Pos.x, Firework(i).Pos.y - 1), _RGB32(255, 255, 255)
                PSet (Firework(i).Pos.x, Firework(i).Pos.y + 1), _RGB32(255, 255, 255)
            End If
        ElseIf Firework(i).Visible Then
            If Not Pause Then Firework(i).ExplosionStep = Firework(i).ExplosionStep + 1
            For j = 1 To UBound(Boom, 2)
                If Firework(i).Size = 1 Then
                    PSet (Boom(i, j).Pos.x, Boom(i, j).Pos.y), Boom(i, j).Color
                Else
                    PSet (Boom(i, j).Pos.x, Boom(i, j).Pos.y), Darken(Boom(i, j).Color, 100 - (Firework(i).ExplosionStep * 100) / Firework(i).ExplosionMax)
                    PSet (Boom(i, j).Pos.x - 1, Boom(i, j).Pos.y), Darken(Boom(i, j).Color, 100 - (Firework(i).ExplosionStep * 100) / Firework(i).ExplosionMax)
                    PSet (Boom(i, j).Pos.x + 1, Boom(i, j).Pos.y), Darken(Boom(i, j).Color, 100 - (Firework(i).ExplosionStep * 100) / Firework(i).ExplosionMax)
                    PSet (Boom(i, j).Pos.x, Boom(i, j).Pos.y - 1), Darken(Boom(i, j).Color, 100 - (Firework(i).ExplosionStep * 100) / Firework(i).ExplosionMax)
                    PSet (Boom(i, j).Pos.x, Boom(i, j).Pos.y + 1), Darken(Boom(i, j).Color, 100 - (Firework(i).ExplosionStep * 100) / Firework(i).ExplosionMax)
                End If
                If Not Pause Then
                    t = t + 1: If t > UBound(Trail) Then t = 1
                    Trail(t).Pos.x = Boom(i, j).Pos.x
                    Trail(t).Pos.y = Boom(i, j).Pos.y
                    Trail(t).Size = Boom(i, j).Size
                    Trail(t).Color = Darken(Boom(i, j).Color, 100 - (Firework(i).ExplosionStep * 100) / Firework(i).ExplosionMax)

                    t = t + 1: If t > UBound(Trail) Then t = 1
                    Trail(t).Pos.x = Boom(i * 2, j).Pos.x
                    Trail(t).Pos.y = Boom(i * 2, j).Pos.y
                    Trail(t).Size = Boom(i * 2, j).Size
                    Trail(t).Color = Darken(Boom(i * 2, j).Color, 150)

                    Boom(i, j).Vel.y = Boom(i, j).Vel.y + Gravity.y / 10
                    Boom(i, j).Pos.x = Boom(i, j).Pos.x + Boom(i, j).Vel.x '+ Firework(i).Vel.x
                    Boom(i, j).Pos.y = Boom(i, j).Pos.y + Boom(i, j).Vel.y
                    Boom(i * 2, j).Vel.y = Boom(i * 2, j).Vel.y + Gravity.y / 10
                    Boom(i * 2, j).Pos.x = Boom(i * 2, j).Pos.x + Boom(i * 2, j).Vel.x '+ Firework(i).Vel.x
                    Boom(i * 2, j).Pos.y = Boom(i * 2, j).Pos.y + Boom(i * 2, j).Vel.y
                End If
            Next
            If Firework(i).ExplosionStep > Firework(i).ExplosionMax Then Firework(i).Visible = False
        End If
    Next

    Control(HappyNewYearLB).Hidden = Not Control(ShowTextCB).Value

    _Dest 0
    Control(Canvas).PreviousValue = 0
End Sub

Sub __UI_BeforeUnload

End Sub

Sub __UI_Click (id As Long)
    Select Case id
        Case Fireworks

        Case Canvas
            Pause = Not Pause
            If Pause Then
                Caption(HappyNewYearLB) = "PAUSED"
            Else
                Caption(HappyNewYearLB) = Text(YourTextHereTB)
            End If
        Case MaxFireworksLB

        Case MaxFireworksTrackBar

        Case MaxParticlesLB

        Case MaxParticlesTrackBar

        Case ShowTextCB

        Case YourTextHereTB

        Case HappyNewYearLB

    End Select
End Sub

Sub __UI_MouseEnter (id As Long)
    Select Case id
        Case Fireworks

        Case Canvas

        Case MaxFireworksLB

        Case MaxFireworksTrackBar

        Case MaxParticlesLB

        Case MaxParticlesTrackBar

        Case ShowTextCB

        Case YourTextHereTB

        Case HappyNewYearLB

    End Select
End Sub

Sub __UI_MouseLeave (id As Long)
    Select Case id
        Case Fireworks

        Case Canvas

        Case MaxFireworksLB

        Case MaxFireworksTrackBar

        Case MaxParticlesLB

        Case MaxParticlesTrackBar

        Case ShowTextCB

        Case YourTextHereTB

        Case HappyNewYearLB

    End Select
End Sub

Sub __UI_FocusIn (id As Long)
    Select Case id
        Case MaxFireworksTrackBar

        Case MaxParticlesTrackBar

        Case ShowTextCB

        Case YourTextHereTB

    End Select
End Sub

Sub __UI_FocusOut (id As Long)
    Select Case id
        Case MaxFireworksTrackBar

        Case MaxParticlesTrackBar

        Case ShowTextCB

        Case YourTextHereTB

    End Select
End Sub

Sub __UI_MouseDown (id As Long)
    Select Case id
        Case Fireworks

        Case Canvas

        Case MaxFireworksLB

        Case MaxFireworksTrackBar

        Case MaxParticlesLB

        Case MaxParticlesTrackBar

        Case ShowTextCB

        Case YourTextHereTB

        Case HappyNewYearLB

    End Select
End Sub

Sub __UI_MouseUp (id As Long)
    Select Case id
        Case Fireworks

        Case Canvas

        Case MaxFireworksLB

        Case MaxFireworksTrackBar

        Case MaxParticlesLB

        Case MaxParticlesTrackBar

        Case ShowTextCB

        Case YourTextHereTB

        Case HappyNewYearLB

    End Select
End Sub

Sub __UI_KeyPress (id As Long)
    Select Case id
        Case MaxFireworksTrackBar

        Case MaxParticlesTrackBar

        Case ShowTextCB

        Case YourTextHereTB

    End Select
End Sub

Sub __UI_TextChanged (id As Long)
    Select Case id
        Case YourTextHereTB
            Caption(HappyNewYearLB) = Text(YourTextHereTB)
    End Select
End Sub

Sub __UI_ValueChanged (id As Long)
    Control(id).Value = Int(Control(id).Value)
    Select Case id
        Case MaxFireworksTrackBar
            ReDim _Preserve Firework(1 To Control(MaxFireworksTrackBar).Value) As Particle
            ToolTip(id) = Str$(Control(MaxFireworksTrackBar).Value)
        Case MaxParticlesTrackBar
            ReDim _Preserve Boom(1 To UBound(Firework) * 2, Control(MaxParticlesTrackBar).Value) As Particle
            ToolTip(id) = Str$(Control(MaxParticlesTrackBar).Value)
    End Select
End Sub

Sub __UI_FormResized
End Sub

'$INCLUDE:'InForm\InForm.ui'
