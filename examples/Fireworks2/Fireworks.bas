': This program uses
': InForm - GUI library for QB64 - v1.0
': Fellippe Heitor, 2016-2019 - fellippe@qb64.org - @fellippeheitor
': https://github.com/FellippeHeitor/InForm
'-----------------------------------------------------------

'Improved fireworks:
'    - Particles now leave a trail behind
'    - Round explosions (sin/cos been used...)
'    - Explosion sound effect.

OPTION _EXPLICIT

TYPE Vector
    x AS SINGLE
    y AS SINGLE
END TYPE

TYPE Particle
    Pos AS Vector
    Vel AS Vector
    Acc AS Vector
    Visible AS _BYTE
    Exploded AS _BYTE
    ExplosionStep AS _BYTE
    ExplosionMax AS _BYTE
    Color AS _UNSIGNED LONG
    Size AS _BYTE
END TYPE

REDIM SHARED Firework(1 TO 1) AS Particle
REDIM SHARED Boom(1 TO UBOUND(Firework) * 2, 1) AS Particle
DIM SHARED Trail(1 TO 20000) AS Particle

DIM SHARED StartPointLimit AS SINGLE, InitialVel AS SINGLE
DIM SHARED Gravity AS Vector, Pause AS _BYTE, distant AS LONG

InitialVel = -30
Gravity.y = .8
distant = _SNDOPEN("distant.wav")

RANDOMIZE TIMER

': Controls' IDs: ------------------------------------------------------------------
DIM SHARED BabyYoureAFirework AS LONG
DIM SHARED Canvas AS LONG
DIM SHARED MaxFireworksLB AS LONG
DIM SHARED MaxFireworksTrackBar AS LONG
DIM SHARED MaxParticlesLB AS LONG
DIM SHARED MaxParticlesTrackBar AS LONG
DIM SHARED ShowTextCB AS LONG
DIM SHARED YourTextHereTB AS LONG
DIM SHARED HappyNewYearLB AS LONG

': External modules: ---------------------------------------------------------------
'$INCLUDE:'../../InForm/InForm.bi'
'$INCLUDE:'Fireworks.frm'
'$INCLUDE:'../../InForm/InForm.ui'

': Event procedures: ---------------------------------------------------------------
SUB __UI_BeforeInit

END SUB

SUB __UI_OnLoad
    _TITLE "Baby, you're a firework"
    StartPointLimit = Control(Canvas).Height / 3
    Control(MaxFireworksTrackBar).Value = 20
    Control(MaxParticlesTrackBar).Value = 150
    ToolTip(MaxFireworksTrackBar) = "20"
    ToolTip(MaxParticlesTrackBar) = "150"
    REDIM _PRESERVE Firework(1 TO Control(MaxFireworksTrackBar).Value) AS Particle
    REDIM _PRESERVE Boom(1 TO UBOUND(Firework) * 2, Control(MaxParticlesTrackBar).Value) AS Particle
END SUB

SUB __UI_BeforeUpdateDisplay
    STATIC JustExploded AS _BYTE
    STATIC t AS INTEGER, Initial AS _BYTE, InitialX AS INTEGER, lastInitial#

    DIM AS LONG j, i, a
    DIM AS _UNSIGNED LONG thisColor

    _DEST Control(Canvas).HelperCanvas

    IF JustExploded THEN
        JustExploded = FALSE
        CLS , _RGB32(0, 0, 50)
    ELSE
        CLS
    END IF
    IF _CEIL(RND * 20) < 2 OR (Initial = FALSE AND TIMER - lastInitial# > .1) THEN
        'Create a new particle
        FOR j = 1 TO UBOUND(Firework)
            IF Firework(j).Visible = FALSE THEN
                Firework(j).Vel.y = InitialVel
                Firework(j).Vel.x = 3 - _CEIL(RND * 6)
                IF Initial = TRUE THEN
                    Firework(j).Pos.x = _CEIL(RND * Control(Canvas).Width)
                ELSE
                    Firework(j).Pos.x = InitialX * (Control(Canvas).Width / 15)
                    InitialX = InitialX + 1
                    lastInitial# = TIMER
                    IF InitialX > 15 THEN Initial = TRUE
                END IF
                Firework(j).Pos.y = Control(Canvas).Height + _CEIL(RND * StartPointLimit)
                Firework(j).Visible = TRUE
                Firework(j).Exploded = FALSE
                Firework(j).ExplosionStep = 0
                Firework(j).Size = _CEIL(RND * 2)
                IF Firework(j).Size = 1 THEN
                    Firework(j).ExplosionMax = 9 + _CEIL(RND * 41)
                ELSE
                    Firework(j).ExplosionMax = 9 + _CEIL(RND * 71)
                END IF
                Firework(j).ExplosionMax = 20 '0
                EXIT FOR
            END IF
        NEXT j
    END IF

    'Show trail
    FOR i = 1 TO UBOUND(Trail)
        IF NOT Pause THEN Trail(i).Color = Darken(Trail(i).Color, 70)
        IF Trail(i).Size = 1 THEN
            PSET (Trail(i).Pos.x, Trail(i).Pos.y), Trail(i).Color
        ELSE
            PSET (Trail(i).Pos.x, Trail(i).Pos.y), Trail(i).Color
            PSET (Trail(i).Pos.x - 1, Trail(i).Pos.y), Trail(i).Color
            PSET (Trail(i).Pos.x + 1, Trail(i).Pos.y), Trail(i).Color
            PSET (Trail(i).Pos.x, Trail(i).Pos.y - 1), Trail(i).Color
            PSET (Trail(i).Pos.x, Trail(i).Pos.y + 1), Trail(i).Color
        END IF
    NEXT i

    'Update and show particles
    FOR i = 1 TO UBOUND(Firework)
        'Update trail particles

        IF Firework(i).Visible = TRUE AND Firework(i).Exploded = FALSE AND NOT Pause THEN
            t = t + 1: IF t > UBOUND(Trail) THEN t = 1
            Trail(t).Pos.x = Firework(i).Pos.x
            Trail(t).Pos.y = Firework(i).Pos.y
            Trail(t).Color = _RGB32(255, 255, 255)

            'New position
            Firework(i).Vel.y = Firework(i).Vel.y + Gravity.y
            Firework(i).Pos.y = Firework(i).Pos.y + Firework(i).Vel.y
            Firework(i).Pos.x = Firework(i).Pos.x + Firework(i).Vel.x
        END IF

        'Explode the particle if it reaches max height
        IF Firework(i).Vel.y > 0 THEN
            IF Firework(i).Exploded = FALSE THEN
                Firework(i).Exploded = TRUE
                JustExploded = TRUE

                IF Firework(1).Size = 1 THEN
                    IF distant THEN _SNDPLAYCOPY distant, .5
                ELSE
                    IF distant THEN _SNDPLAYCOPY distant, 1
                END IF

                thisColor~& = _RGB32(_CEIL(RND * 255), _CEIL(RND * 255), _CEIL(RND * 255))
                a = 0
                FOR j = 1 TO UBOUND(Boom, 2)
                    Boom(i, j).Pos.x = Firework(i).Pos.x
                    Boom(i, j).Pos.y = Firework(i).Pos.y
                    Boom(i, j).Vel.y = SIN(a) * (RND * 10)
                    Boom(i, j).Vel.x = COS(a) * (RND * 10)
                    a = a + 1
                    Boom(i, j).Color = thisColor~&

                    Boom(i * 2, j).Pos.x = Firework(i).Pos.x + 5
                    Boom(i * 2, j).Pos.y = Firework(i).Pos.y + 5
                    Boom(i * 2, j).Vel.y = Boom(i, j).Vel.y
                    Boom(i * 2, j).Vel.x = Boom(i, j).Vel.x
                    a = a + 1
                    Boom(i * 2, j).Color = thisColor~&
                NEXT
            END IF
        END IF

        'Show particle
        IF Firework(i).Exploded = FALSE THEN
            IF Firework(i).Size = 1 THEN
                PSET (Firework(i).Pos.x, Firework(i).Pos.y), _RGB32(255, 255, 255)
            ELSE
                PSET (Firework(i).Pos.x, Firework(i).Pos.y), _RGB32(255, 255, 255)
                PSET (Firework(i).Pos.x - 1, Firework(i).Pos.y), _RGB32(255, 255, 255)
                PSET (Firework(i).Pos.x + 1, Firework(i).Pos.y), _RGB32(255, 255, 255)
                PSET (Firework(i).Pos.x, Firework(i).Pos.y - 1), _RGB32(255, 255, 255)
                PSET (Firework(i).Pos.x, Firework(i).Pos.y + 1), _RGB32(255, 255, 255)
            END IF
        ELSEIF Firework(i).Visible THEN
            IF NOT Pause THEN Firework(i).ExplosionStep = Firework(i).ExplosionStep + 1
            FOR j = 1 TO UBOUND(Boom, 2)
                IF Firework(i).Size = 1 THEN
                    PSET (Boom(i, j).Pos.x, Boom(i, j).Pos.y), Boom(i, j).Color
                ELSE
                    PSET (Boom(i, j).Pos.x, Boom(i, j).Pos.y), Darken(Boom(i, j).Color, 100 - (Firework(i).ExplosionStep * 100) / Firework(i).ExplosionMax)
                    PSET (Boom(i, j).Pos.x - 1, Boom(i, j).Pos.y), Darken(Boom(i, j).Color, 100 - (Firework(i).ExplosionStep * 100) / Firework(i).ExplosionMax)
                    PSET (Boom(i, j).Pos.x + 1, Boom(i, j).Pos.y), Darken(Boom(i, j).Color, 100 - (Firework(i).ExplosionStep * 100) / Firework(i).ExplosionMax)
                    PSET (Boom(i, j).Pos.x, Boom(i, j).Pos.y - 1), Darken(Boom(i, j).Color, 100 - (Firework(i).ExplosionStep * 100) / Firework(i).ExplosionMax)
                    PSET (Boom(i, j).Pos.x, Boom(i, j).Pos.y + 1), Darken(Boom(i, j).Color, 100 - (Firework(i).ExplosionStep * 100) / Firework(i).ExplosionMax)
                END IF
                IF NOT Pause THEN
                    t = t + 1: IF t > UBOUND(Trail) THEN t = 1
                    Trail(t).Pos.x = Boom(i, j).Pos.x
                    Trail(t).Pos.y = Boom(i, j).Pos.y
                    Trail(t).Size = Boom(i, j).Size
                    Trail(t).Color = Darken(Boom(i, j).Color, 100 - (Firework(i).ExplosionStep * 100) / Firework(i).ExplosionMax)

                    t = t + 1: IF t > UBOUND(Trail) THEN t = 1
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
                END IF
            NEXT
            IF Firework(i).ExplosionStep > Firework(i).ExplosionMax THEN Firework(i).Visible = FALSE
        END IF
    NEXT

    Control(HappyNewYearLB).Hidden = NOT Control(ShowTextCB).Value

    _DEST 0
    Control(Canvas).PreviousValue = 0
END SUB

SUB __UI_BeforeUnload

END SUB

SUB __UI_Click (id AS LONG)
    SELECT CASE id
        CASE BabyYoureAFirework

        CASE Canvas
            Pause = NOT Pause
            IF Pause THEN
                Caption(HappyNewYearLB) = "PAUSED"
            ELSE
                Caption(HappyNewYearLB) = Text(YourTextHereTB)
            END IF
        CASE MaxFireworksLB

        CASE MaxFireworksTrackBar

        CASE MaxParticlesLB

        CASE MaxParticlesTrackBar

        CASE ShowTextCB

        CASE YourTextHereTB

        CASE HappyNewYearLB

    END SELECT
END SUB

SUB __UI_MouseEnter (id AS LONG)
    SELECT CASE id
        CASE BabyYoureAFirework

        CASE Canvas

        CASE MaxFireworksLB

        CASE MaxFireworksTrackBar

        CASE MaxParticlesLB

        CASE MaxParticlesTrackBar

        CASE ShowTextCB

        CASE YourTextHereTB

        CASE HappyNewYearLB

    END SELECT
END SUB

SUB __UI_MouseLeave (id AS LONG)
    SELECT CASE id
        CASE BabyYoureAFirework

        CASE Canvas

        CASE MaxFireworksLB

        CASE MaxFireworksTrackBar

        CASE MaxParticlesLB

        CASE MaxParticlesTrackBar

        CASE ShowTextCB

        CASE YourTextHereTB

        CASE HappyNewYearLB

    END SELECT
END SUB

SUB __UI_FocusIn (id AS LONG)
    SELECT CASE id
        CASE MaxFireworksTrackBar

        CASE MaxParticlesTrackBar

        CASE ShowTextCB

        CASE YourTextHereTB

    END SELECT
END SUB

SUB __UI_FocusOut (id AS LONG)
    SELECT CASE id
        CASE MaxFireworksTrackBar

        CASE MaxParticlesTrackBar

        CASE ShowTextCB

        CASE YourTextHereTB

    END SELECT
END SUB

SUB __UI_MouseDown (id AS LONG)
    SELECT CASE id
        CASE BabyYoureAFirework

        CASE Canvas

        CASE MaxFireworksLB

        CASE MaxFireworksTrackBar

        CASE MaxParticlesLB

        CASE MaxParticlesTrackBar

        CASE ShowTextCB

        CASE YourTextHereTB

        CASE HappyNewYearLB

    END SELECT
END SUB

SUB __UI_MouseUp (id AS LONG)
    SELECT CASE id
        CASE BabyYoureAFirework

        CASE Canvas

        CASE MaxFireworksLB

        CASE MaxFireworksTrackBar

        CASE MaxParticlesLB

        CASE MaxParticlesTrackBar

        CASE ShowTextCB

        CASE YourTextHereTB

        CASE HappyNewYearLB

    END SELECT
END SUB

SUB __UI_KeyPress (id AS LONG)
    SELECT CASE id
        CASE MaxFireworksTrackBar

        CASE MaxParticlesTrackBar

        CASE ShowTextCB

        CASE YourTextHereTB

    END SELECT
END SUB

SUB __UI_TextChanged (id AS LONG)
    SELECT CASE id
        CASE YourTextHereTB
            Caption(HappyNewYearLB) = Text(YourTextHereTB)
    END SELECT
END SUB

SUB __UI_ValueChanged (id AS LONG)
    Control(id).Value = INT(Control(id).Value)
    SELECT CASE id
        CASE ShowTextCB

        CASE MaxFireworksTrackBar
            REDIM _PRESERVE Firework(1 TO Control(MaxFireworksTrackBar).Value) AS Particle
            ToolTip(id) = STR$(Control(MaxFireworksTrackBar).Value)
        CASE MaxParticlesTrackBar
            REDIM _PRESERVE Boom(1 TO UBOUND(Firework) * 2, Control(MaxParticlesTrackBar).Value) AS Particle
            ToolTip(id) = STR$(Control(MaxParticlesTrackBar).Value)
    END SELECT
END SUB

SUB __UI_FormResized
END SUB
