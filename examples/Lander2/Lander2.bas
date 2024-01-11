' Lander_Inform2.bas for QB 1.1(last before 1.2 number change) B+ started 2018-06-05

'LanderInform1.bas for qb64 v1.1(last) B+ 2018-06-04 started from
'Lander 2018-06-04_1130AM.bas (after some bug fixes to OP)

' notes: Do not use _display or _delay in screen repaints!
' Do not remove empty subs for form events created by UiEditor.
' Due to very fast screen updates:
' I had to reduce gravity and speeds to 1/10th except thruster acceleration.
' I had to go back and change numbers for controls so just used the updated form file.
' Also modified crash report again.
' Added code to draw flash of thruster at same time as drawing rest of scene.

' Apparently image files have to be located at root where the UiEditor.exe resides.
' To load into form at design time.

' Lander_Inform2 started 2018-06-05
' + use Johnno's Stars.png for pbScene stars background, remove star making
' + use terraH for creating a black silhoette of land profile color line at top
' + installed landing lights and adjust colors
' + 4 bases for landing are separated fairly evenly across screen
' + arrow keys will work after click a button one time, even after Restart
' + Horizontal and vertical speeds can now see beyond deciaml point
' + New crash numbers for speeds: abs(1.5) for horizontal and 1.5 max for vertical.
' + Added Image Files for buttons by Johnno,
' - Even with the shrink property set to True,
'  and the buttons designed to fit precisely don't! :(


': This program uses
': InForm - GUI library for QB64 - Beta version 7
': Fellippe Heitor, 2016-2018 - fellippe@qb64.org - @fellippeheitor
': https://github.com/FellippeHeitor/InForm
'-----------------------------------------------------------

CONST xmax = 1190 'pbScene width, the picture box
CONST ymax = 600 'pbScene height
RANDOMIZE TIMER

DIM SHARED Lander_Inform2 AS LONG
DIM SHARED pi, d2r 'maths
pi = _PI
d2r = pi / 180

'stars
DIM SHARED stars&

'terrain
DIM SHARED terraH(xmax)
'vehicle globals
DIM SHARED fuel, vda, speed, vx, vy, dx, dy, dg, dat, flashx, flashy, lc

': Controls' IDs: ------------------------------------------------------------------
DIM SHARED LanderInform1 AS LONG
DIM SHARED lbMessage AS LONG
DIM SHARED lbVert AS LONG
DIM SHARED lbHor AS LONG
DIM SHARED bRotLeft AS LONG
DIM SHARED bThrust AS LONG
DIM SHARED bRotRight AS LONG
DIM SHARED bRestart AS LONG
DIM SHARED barFuel AS LONG
DIM SHARED pbScene AS LONG

': External modules: ---------------------------------------------------------------
'$INCLUDE:'../../InForm/InForm.bi'
'$INCLUDE:'Lander2.frm'
'$INCLUDE:'../../InForm/InForm.ui'

': Event procedures: ---------------------------------------------------------------
SUB __UI_BeforeInit
    initialize
END SUB

SUB __UI_OnLoad
    stars& = _LOADIMAGE("stars.png")
    'LoadImage Control(bRotLeft), "left.png"
    'LoadImage Control(bRotRight), "right.png"
    'LoadImage Control(bThrust), "thrust.png"
    'LoadImage Control(bRestart), "restart.png"
END SUB

SUB __UI_BeforeUpdateDisplay
    'This event occurs at approximately 30 frames per second.
    'You can change the update frequency by calling SetFrameRate DesiredRate%
    IF Caption(lbMessage) = "" THEN
        scene
        lc = (lc + 1) MOD 6
        Caption(lbHor) = "Horizontal speed:" + dec2$(dx)
        Caption(lbVert) = "  Vertical speed:" + dec2$(dy)
        Control(barFuel).Value = fuel

        'vehicle falls faster and faster, because gravity effects the vertical speed
        dy = dy + dg 'speed up falling due to gravity acceleration

        'new position = last postion plus the horizontal and vertical changes from momentum
        vx = vx + dx
        vy = vy + dy

        IF vx < 30 OR vx > xmax - 30 OR vy < -50 THEN 'edit keep Lander legs inside boundries of terraH()
            Caption(lbMessage) = "You have drifted off screen."
        END IF

        IF vy > terraH(vx) OR fuel <= 0 THEN
            crash$ = ""
            fp = 0
            IF fuel <= 0 THEN
                crash$ = crash$ + "You ran out of fuel. ": fp = 1
            ELSE
                IF vda <> 270 THEN crash$ = crash$ + "Vehicle not upright. "
                IF dy > 1.5 THEN crash$ = crash$ + "Came down too fast. "
                IF ABS(dx) > 1.5 THEN crash$ = crash$ + "Still moving hoizontally too fast. "
                IF terraH(vx - 10) <> terraH(vx + 10) THEN crash$ = crash$ + "Did not land on level site. "
            END IF
            IF crash$ <> "" THEN
                IF fp THEN
                    Caption(lbMessage) = crash$
                ELSE
                    Caption(lbMessage) = "You crashed because: " + crash$
                END IF
            ELSE
                Caption(lbMessage) = "Nice job! Successful landing!"
            END IF
        END IF
    ELSE
        'actvate restart
        Control(bRestart).Hidden = FALSE
        Control(bRestart).Disabled = FALSE
    END IF 'if no message about ending landing

END SUB

SUB __UI_BeforeUnload
    'If you set __UI_UnloadSignal = False here you can
    'cancel the user's request to close.

END SUB

SUB __UI_Click (id AS LONG)
    SELECT CASE id
        CASE Lander_Inform2

        CASE LanderInform1

        CASE lbMessage

        CASE Label2

        CASE lbVert

        CASE lbHor

        CASE bRotLeft
            moveLeft
        CASE bThrust
            moveUp
        CASE bRotRight
            moveRight
        CASE bRestart
            initialize
            Caption(lbMessage) = "" 'this line would not work in initialize at start of program
        CASE barFuel

        CASE pbScene

    END SELECT
END SUB

SUB __UI_MouseEnter (id AS LONG)
    SELECT CASE id
        CASE Lander_Inform2

        CASE LanderInform1

        CASE lbMessage

        CASE Label2

        CASE lbVert

        CASE lbHor

        CASE bRotLeft

        CASE bThrust

        CASE bRotRight

        CASE bRestart

        CASE barFuel

        CASE pbScene

    END SELECT
END SUB

SUB __UI_MouseLeave (id AS LONG)
    SELECT CASE id
        CASE Lander_Inform2

        CASE LanderInform1

        CASE lbMessage

        CASE Label2

        CASE lbVert

        CASE lbHor

        CASE bRotLeft

        CASE bThrust

        CASE bRotRight

        CASE bRestart

        CASE barFuel

        CASE pbScene

    END SELECT
END SUB

SUB __UI_FocusIn (id AS LONG)
    SELECT CASE id
        CASE bRotLeft

        CASE bThrust

        CASE bRotRight

        CASE bRestart

    END SELECT
END SUB

SUB __UI_FocusOut (id AS LONG)
    'This event occurs right before a control loses focus.
    'To prevent a control from losing focus, set __UI_KeepFocus = True below.
    SELECT CASE id
        CASE bRotLeft

        CASE bThrust

        CASE bRotRight

        CASE bRestart

    END SELECT
END SUB

SUB __UI_MouseDown (id AS LONG)
    SELECT CASE id
        CASE Lander_Inform2

        CASE LanderInform1

        CASE lbMessage

        CASE Label2

        CASE lbVert

        CASE lbHor

        CASE bRotLeft

        CASE bThrust

        CASE bRotRight

        CASE bRestart

        CASE barFuel

        CASE pbScene

    END SELECT
END SUB

SUB __UI_MouseUp (id AS LONG)
    SELECT CASE id
        CASE Lander_Inform2

        CASE LanderInform1

        CASE lbMessage

        CASE Label2

        CASE lbVert

        CASE lbHor

        CASE bRotLeft

        CASE bThrust

        CASE bRotRight

        CASE bRestart

        CASE barFuel

        CASE pbScene

    END SELECT
END SUB

SUB __UI_KeyPress (id AS LONG)
    'When this event is fired, __UI_KeyHit will contain the code of the key hit.
    'You can change it and even cancel it by making it = 0

    'Caption(lbMessage) = STR$(__UI_KeyHit) 'see what the numbers are
    SELECT CASE __UI_KeyHit
        CASE -19200: moveLeft
        CASE -19712: moveRight
        CASE -18432: moveUp
    END SELECT

    SELECT CASE id
        CASE bRotLeft

        CASE bThrust

        CASE bRotRight

        CASE bRestart

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

'subify the initial sequence to start a new game
SUB initialize
    'makeStars
    makeTerra
    fuel = 500 'this is the space vehicle's fuel

    'vda is vehicle degree angle = orientation of the vehicle, mainly it's thrusters
    vda = 0 'the vehicle is traveling right across screen due East = 0 degrees = 0 Radians
    speed = .6 'this is the speed the vehicle is moving in the vda direction
    vx = 50 'this is current x position of vehicle
    vy = 30 'this is current y position of vehicle

    'd stands for delta with stands for change dx = change in x, dy = change in y
    'dg is change due to gravity (vertical)
    'dat is change of acceleration due to thrust
    dx = speed * COS(d2r * vda) 'this is the horizontal x change on screen due to speed and angle
    dy = speed * SIN(d2r * vda) 'this is the vertical y change on screen due to speed and angle
    dg = .01 'this is the constant acceleration gravity applies to the vehicle
    dat = .5 'this is burst of acceleration a thrust or reverse thrust will apply to speed and angle
    Control(bRestart).Hidden = TRUE
    Control(bRestart).Disabled = TRUE
END SUB

'================================================ from Lander 2018-06-04
SUB scene
    'should now have Johnno's stars.png file for background
    BeginDraw pbScene
    _SOURCE stars&
    _PUTIMAGE
    rgb 0 'all black terrain as silohette
    FOR i = 0 TO xmax
        'rgb terraC(i) * 100 + terraC(i) * 10 + terraC(i)
        rgb 201
        pst i, terraH(i)
        rgb 0
        ln i, terraH(i) + 1, i, ymax
    NEXT
    IF flashx OR flashy THEN
        rgb 990
        fcirc flashx, flashy, 8
        flashx = 0
        flashy = 0
    END IF
    Lander vx, vy, d2r * vda
    EndDraw pbScene
END SUB
'                              arrow + esc key
SUB moveUp
    'here is the vertical and horizontal change from a burst of fuel for thrust
    thrustx = dat * COS(d2r * vda)
    thrusty = dat * SIN(d2r * vda)

    'now change the horizontal and vertical momentums from the thrust
    dx = dx + thrustx
    dy = dy + thrusty

    'get flash point before change position
    flashx = vx
    flashy = vy

    'update the position
    vx = vx + dx
    vy = vy + dy

    'the thrust cost fuel
    fuel = fuel - 10
END SUB

SUB moveLeft
    flashx = vx + 10 * COS(d2r * vda + .5 * pi)
    flashy = vy + 10 * SIN(d2r * vda + .5 * pi)
    vda = vda - 22.5
    IF vda < -0.01 THEN vda = 360
    fuel = fuel - 10
END SUB

SUB moveRight
    flashx = vx + 10 * COS(d2r * vda - .5 * pi)
    flashy = vy + 10 * SIN(d2r * vda - .5 * pi)
    vda = vda + 22.5
    IF vda > 337.51 THEN vda = 0
    fuel = fuel - 10
END SUB

SUB Lander (x0, y0, rAngle) 'rebuilt from ground up literally!
    'x0, y0 are at the base of the lander, the rocket will point rAngle up when landing
    rgb 221
    x1 = x0 + 10 * COS(rAngle - .5 * pi)
    y1 = y0 + 10 * SIN(rAngle - .5 * pi)
    x2 = x0 + 10 * COS(rAngle + .5 * pi)
    y2 = y0 + 10 * SIN(rAngle + .5 * pi)
    x3 = x0 + 10 * COS(rAngle)
    y3 = y0 + 10 * SIN(rAngle)
    x4 = x0 + 25 * COS(rAngle)
    y4 = y0 + 25 * SIN(rAngle)
    'legs/fins
    ln x3, y3, x1, y1
    ln x3, y3, x2, y2
    ln x4, y4, x1, y1
    ln x4, y4, x2, y2
    pangle = 2 * pi / 5
    rgb 211
    FOR i = 0 TO 5
        SELECT CASE i
            CASE 0, 5: r = 20
            CASE 2, 3: r = 15
            CASE 1, 4: r = 25
        END SELECT
        x1 = x4 + r * COS(i * pangle + rAngle)
        y1 = y4 + r * SIN(i * pangle + rAngle)
        IF i = 1 THEN sx = x1: sy = y1
        IF i = 4 THEN tx = x1: ty = y1
        IF i <> 0 THEN ln lx, ly, x1, y1
        lx = x1: ly = y1
    NEXT
    PAINT (x4, y4), _RGB(80, 60, 60), _RGB32(59, 31, 31)
    'let there be lights
    d6 = (((sy - ty) ^ 2 + (sx - tx) ^ 2) ^ .5) / 30
    da = _ATAN2(ty - sy, tx - sx)
    FOR i = 0 TO 30
        IF i MOD 6 = lc THEN
            rgb 500
            fcirc sx + i * d6 * COS(da), sy + i * d6 * SIN(da), 4
            rgb 60
            fcirc sx + i * d6 * COS(da), sy + i * d6 * SIN(da), 2
            rgb 99
            fcirc sx + i * d6 * COS(da), sy + i * d6 * SIN(da), 1
        END IF
    NEXT
END SUB

SUB pst (x, y)
    PSET (x, y)
END SUB

SUB ln (x1, y1, x2, y2)
    LINE (x1, y1)-(x2, y2)
END SUB

SUB rec (x1, y1, x2, y2)
    LINE (x1, y1)-(x2, y2), , B
END SUB

SUB recf (x1, y1, x2, y2)
    LINE (x1, y1)-(x2, y2), , BF
END SUB

SUB rgb (n) ' New (even less typing!) New Color System 1000 colors with up to 3 digits
    s3$ = RIGHT$("000" + LTRIM$(STR$(n)), 3)
    r = VAL(MID$(s3$, 1, 1)): IF r THEN r = 28 * r + 3
    g = VAL(MID$(s3$, 2, 1)): IF g THEN g = 28 * g + 3
    b = VAL(MID$(s3$, 3, 1)): IF b THEN b = 28 * b + 3
    COLOR _RGB32(r, g, b)
END SUB

'Steve McNeil's  copied from his forum   note: Radius is too common a name
SUB fcirc (CX AS LONG, CY AS LONG, R AS LONG)
    DIM subRadius AS LONG, RadiusError AS LONG
    DIM X AS LONG, Y AS LONG

    subRadius = ABS(R)
    RadiusError = -subRadius
    X = subRadius
    Y = 0

    IF subRadius = 0 THEN PSET (CX, CY): EXIT SUB

    ' Draw the middle span here so we don't draw it twice in the main loop,
    ' which would be a problem with blending turned on.
    LINE (CX - X, CY)-(CX + X, CY), , BF

    WHILE X > Y
        RadiusError = RadiusError + Y * 2 + 1
        IF RadiusError >= 0 THEN
            IF X <> Y + 1 THEN
                LINE (CX - Y, CY - X)-(CX + Y, CY - X), , BF
                LINE (CX - Y, CY + X)-(CX + Y, CY + X), , BF
            END IF
            X = X - 1
            RadiusError = RadiusError - X * 2
        END IF
        Y = Y + 1
        LINE (CX - X, CY - Y)-(CX + X, CY - Y), , BF
        LINE (CX - X, CY + Y)-(CX + X, CY + Y), , BF
    WEND
END SUB

FUNCTION min (a, b)
    IF a > b THEN min = b ELSE min = a
END FUNCTION

FUNCTION max (a, b)
    IF a > b THEN max = a ELSE max = b
END FUNCTION

SUB makeTerra
    'make 4 bases
    REDIM abase(4)
    dbase = xmax / 4
    FOR b = 0 TO 3
        abase(b) = INT(b * dbase + .5 * dbase + rdir * .2 * dbase)
    NEXT
    bi = 0
    x = 0
    WHILE x <= xmax
        IF x = abase(bi) THEN
            xstop = min(xmax, x + 50)
            FOR lz = x TO xstop
                terraH(lz) = y
            NEXT
            x = lz - 1
            bi = bi + 1
        ELSE
            IF bi > 3 THEN top = xmax ELSE top = abase(bi) - 1
            xstop = min(top, x + RND * 25)
            yd = rdir * (RND * 2 + .25)
            FOR xx = x TO xstop
                y = min(ymax - 5, y + yd)
                y = max(y, ymax - 240)
                terraH(xx) = y
            NEXT
            x = xx - 1
        END IF
        x = x + 1
    WEND
END SUB

FUNCTION rdir
    IF RND < .5 THEN rdir = -1 ELSE rdir = 1
END FUNCTION

FUNCTION dec2$ (rn)
    s$ = STR$(rn)
    dot = INSTR(s$, ".")
    IF dot THEN
        dec2$ = MID$(s$ + "00", 1, dot + 2)
    ELSE
        dec2$ = s$ + ".00"
    END IF
END FUNCTION
