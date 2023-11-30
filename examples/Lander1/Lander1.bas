'LanderInform1.bas for qb64 v1.1(last) B+ 2018-06-04 started from
'Lander 2018-06-04_1130AM.bas (after some bug fixes to OP)

' notes: Do not use _display or _delay in screen repaints!
' Do not remove empty subs for form events created by UiEditor.
' Due to very fast screen updates:
' I had to reduce gravity and speeds to 1/10th except thruster acceleration.
' I had to go back and change numbers for controls so just used the updated form file.
' Also modified crash report again.
' Added code to draw flash of thruster at same time as drawing rest of scene.

': This program uses
': InForm - GUI library for QB64 - Beta version 7
': Fellippe Heitor, 2016-2018 - fellippe@qb64.org - @fellippeheitor
': https://github.com/FellippeHeitor/InForm
'-----------------------------------------------------------

CONST xmax = 1190 'pbScene width, the picture box
CONST ymax = 600 'pbScene height
RANDOMIZE TIMER

CONST ns = 75 'number of stars

DIM SHARED pi, d2r 'maths
pi = _PI
d2r = pi / 180

'stars
DIM SHARED sx(ns), sy(ns), sr(ns), sc&(ns)
'terrain
DIM SHARED terraH(xmax), terraC(xmax)
'vehicle globals
DIM SHARED fuel, vda, speed, vx, vy, dx, dy, dg, dat, flashx, flashy

': Controls' IDs: ------------------------------------------------------------------
DIM SHARED LanderInform1 AS LONG
DIM SHARED lbMessage AS LONG
DIM SHARED Label2 AS LONG
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
'$INCLUDE:'Lander1.frm'
'$INCLUDE:'../../InForm/xp.uitheme'
'$INCLUDE:'../../InForm/InForm.ui'

': Event procedures: ---------------------------------------------------------------
SUB __UI_BeforeInit
    initialize
END SUB

SUB __UI_OnLoad

END SUB

SUB __UI_BeforeUpdateDisplay
    'This event occurs at approximately 30 frames per second.
    'You can change the update frequency by calling SetFrameRate DesiredRate%
    IF Caption(lbMessage) = "" THEN
        scene
        Caption(lbHor) = "Horizontal:" + STR$(INT(vx)) + "," + STR$(INT(dx))
        Caption(lbVert) = "  Vertical:" + STR$(INT(vy)) + "," + STR$(INT(dy))
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
                IF dy > 4 THEN crash$ = crash$ + "Came down too fast. "
                IF ABS(dx) > 4 THEN crash$ = crash$ + "Still moving hoizontally too fast. "
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
    makeStars
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
    BeginDraw pbScene
    rgb 0
    recf 0, 0, xmax, ymax
    FOR i = 0 TO ns
        COLOR sc&(i)
        fcirc sx(i), sy(i), sr(i)
    NEXT
    FOR i = 0 TO xmax
        rgb terraC(i) * 100 + terraC(i) * 10 + terraC(i)
        ln i, terraH(i), i, ymax
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
    rgb 333
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
    COLOR _RGB32(20, 0, 0)
    FOR i = 0 TO 5
        SELECT CASE i
            CASE 0, 5: r = 20
            CASE 2, 3: r = 15
            CASE 1, 4: r = 25
        END SELECT
        x1 = x4 + r * COS(i * pangle + rAngle)
        y1 = y4 + r * SIN(i * pangle + rAngle)
        IF i <> 0 THEN ln lx, ly, x1, y1
        lx = x1: ly = y1
    NEXT
    PAINT (x4, y4), _RGB(160, 120, 120), _RGB32(20, 0, 0)
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

SUB makeStars
    FOR i = 0 TO ns
        sx(i) = RND * xmax
        sy(i) = RND * ymax
        r = RND
        IF r < .8 THEN
            sr(i) = 1
        ELSEIF r < .95 THEN
            sr(i) = 2
        ELSE
            sr(i) = 3
        END IF
        sc&(i) = _RGB32(RND * 74 + 180, RND * 74 + 180, RND * 74 + 180)
    NEXT
END SUB

SUB makeTerra
    FOR x = 0 TO xmax
        IF x > 0 AND RND < 0.06 THEN
            xstop = min(xmax, x + 50)
            FOR lz = x TO xstop
                terraH(lz) = y
                c = INT(RND * 3) + 1
                terraC(lz) = c
            NEXT
            x = lz - 1
        ELSE
            xstop = min(xmax, x + RND * 25)
            IF RND < .5 THEN yd = 1 ELSE yd = -1
            yd = yd * RND * 2
            FOR xx = x TO xstop
                y = min(ymax, y + yd)
                y = max(y, ymax - 240)
                terraH(xx) = y
                c = INT(RND * 2) + 1
                terraC(xx) = c
            NEXT
            x = xx - 1
        END IF
    NEXT
END SUB
