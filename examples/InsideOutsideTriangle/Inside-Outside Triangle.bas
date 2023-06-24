': Find if Cursor is Inside or Outside of a Drawn Triangle by Qwerkey 20/06/20
': After problem set by STxAxTIC
': This program uses
': InForm - GUI library for QB64 - v1.1
': Fellippe Heitor, 2016-2019 - fellippe@qb64.org - @fellippeheitor
': https://github.com/FellippeHeitor/InForm
'-----------------------------------------------------------

': Controls' IDs: ------------------------------------------------------------------
DIM SHARED InsideOutsideTriangle AS LONG
DIM SHARED PictureBox1 AS LONG
DIM SHARED XLB AS LONG
DIM SHARED YLB AS LONG
DIM SHARED Pos1LB AS LONG
DIM SHARED Pos2LB AS LONG
DIM SHARED Pos3LB AS LONG
DIM SHARED X1LB AS LONG
DIM SHARED Y1LB AS LONG
DIM SHARED X2LB AS LONG
DIM SHARED Y2LB AS LONG
DIM SHARED X3LB AS LONG
DIM SHARED Y3LB AS LONG
DIM SHARED ExitBT AS LONG
DIM SHARED RestartBT AS LONG
DIM SHARED InsideOutsideLB AS LONG
DIM SHARED ClickFrame AS LONG
DIM SHARED Click1LB AS LONG
DIM SHARED Click2LB AS LONG
DIM SHARED PictureBox2 AS LONG
DIM SHARED CXLB AS LONG
DIM SHARED CYLB AS LONG

CONST SmallErr# = 1E-11 'Need SmallErr to check sum is close to zero (would be exactly zero if no calculation errors)
DIM SHARED ClickCount%, Vertices%(3, 1), A#, B#, C#, XMouse%, YMouse%

': External modules: ---------------------------------------------------------------
'$INCLUDE:'../../InForm/InForm.bi'
'$INCLUDE:'Inside-Outside Triangle.frm'

': Functions: ---------------------------------------------------------------------
FUNCTION SideLength# (X1#, Y1#, X2#, Y2#)
    'Calculates Side Length from Vertices
    SideLength# = SQR((X1# - X2#) * (X1# - X2#) + (Y1# - Y2#) * (Y1# - Y2#))
END FUNCTION

FUNCTION Angle# (L1#, L2#, L3#)
    'Derives vertex angle from 3 sides and rule of cosines
    Angle# = _ACOS(((L2# * L2#) + (L3# * L3#) - (L1# * L1#)) / (2 * L2# * L3#))
END FUNCTION

FUNCTION AtCorner%%
    'This function avoids trig divide by zero difficulty at triangle corners
    IF (Vertices%(3, 0) = Vertices%(0, 0) AND Vertices%(3, 1) = Vertices%(0, 1)) OR (Vertices%(3, 0) = Vertices%(1, 0) AND Vertices%(3, 1) = Vertices%(1, 1)) OR (Vertices%(3, 0) = Vertices%(2, 0) AND Vertices%(3, 1) = Vertices%(2, 1)) THEN
        AtCorner%% = True
    ELSE
        AtCorner%% = False
    END IF
END FUNCTION

FUNCTION InPicture%%
    'True if cursor is in PictureBox1
    IF XMouse% > 0 AND XMouse% < 650 AND YMouse% > 0 AND YMouse% < 540 THEN
        InPicture%% = True
    ELSE
        InPicture%% = False
    END IF
END FUNCTION

': Event procedures: ---------------------------------------------------------------
SUB __UI_BeforeInit
    A# = 1
    B# = 1
    C# = 1
    FOR N%% = 0 TO 2
        FOR M%% = 0 TO 1
            Vertices%(N%%, M%%) = 1
        NEXT M%%
    NEXT N%%
END SUB

SUB __UI_OnLoad
    Control(InsideOutsideLB).Hidden = True
    BeginDraw PictureBox1
    'Drawing code goes here
    COLOR _RGB32(0, 0, 0), _RGB32(255, 255, 255)
    CLS
    EndDraw PictureBox1
    BeginDraw PictureBox2
    _PUTIMAGE , _LOADIMAGE("cursor.png", 32)
    EndDraw PictureBox2
END SUB

SUB __UI_BeforeUpdateDisplay
    'This event occurs at approximately 30 frames per second.
    'You can change the update frequency by calling SetFrameRate DesiredRate%
    XMouse% = __UI_MouseLeft - 10
    YMouse% = __UI_MouseTop - 10
    IF InPicture%% THEN
        Vertices%(3, 0) = XMouse%
        Vertices%(3, 1) = YMouse%
        IF NOT AtCorner%% THEN
            'Calculate side lengths of triangle formed with cursor position and triangle vertices
            D# = SideLength#(Vertices%(3, 0), Vertices%(3, 1), Vertices%(1, 0), Vertices%(1, 1))
            E# = SideLength#(Vertices%(3, 0), Vertices%(3, 1), Vertices%(2, 0), Vertices%(2, 1))
            F# = SideLength#(Vertices%(3, 0), Vertices%(3, 1), Vertices%(0, 0), Vertices%(0, 1))
            AlphaDash# = Angle#(A#, E#, F#)
            BetaDash# = Angle#(B#, D#, F#)
            GammaDash# = Angle#(C#, D#, E#)
            IF ABS(AlphaDash# + BetaDash# + GammaDash# - _PI(2)) < SmallErr# THEN
                Caption(InsideOutsideLB) = "INSIDE"
            ELSE
                Caption(InsideOutsideLB) = "OUTSIDE"
            END IF
        END IF
        Caption(CXLB) = LTRIM$(STR$(Vertices%(3, 0)))
        Caption(CYLB) = LTRIM$(STR$(Vertices%(3, 1)))
    ELSE
        Caption(CXLB) = ""
        Caption(CYLB) = ""
    END IF
END SUB

SUB __UI_BeforeUnload
    'If you set __UI_UnloadSignal = False here you can
    'cancel the user's request to close.
END SUB

SUB __UI_Click (id AS LONG)
    SELECT CASE id
        CASE InsideOutsideTriangle

        CASE ClickFrame

        CASE XLB

        CASE YLB

        CASE Pos1LB

        CASE Pos2LB

        CASE Pos3LB

        CASE X1LB

        CASE Y1LB

        CASE X2LB

        CASE Y2LB

        CASE X3LB

        CASE Y3LB

        CASE InsideOutsideLB

        CASE Click1LB

        CASE Click2LB

        CASE PictureBox2

        CASE CXLB

        CASE CYLB

        CASE PictureBox1
            'Define Positions of Triangle Vertices
            IF InPicture%% THEN
                SELECT CASE ClickCount%
                    CASE 0
                        Vertices%(0, 0) = XMouse%
                        Vertices%(0, 1) = YMouse%
                        Caption(X1LB) = LTRIM$(STR$(XMouse%))
                        Caption(Y1LB) = LTRIM$(STR$(YMouse%))
                        ClickCount% = ClickCount% + 1
                        BeginDraw PictureBox1
                        LINE (Vertices%(0, 0) - 2, Vertices%(0, 1))-(Vertices%(0, 0) + 2, Vertices%(0, 1)) ', _RGB32(255, 255, 255), BF
                        LINE (Vertices%(0, 0), Vertices%(0, 1) - 2)-(Vertices%(0, 0), Vertices%(0, 1) + 2)
                        EndDraw PictureBox1
                        Caption(Click2LB) = "Vertex 2"
                    CASE 1
                        Vertices%(1, 0) = XMouse%
                        Vertices%(1, 1) = YMouse%
                        Caption(X2LB) = LTRIM$(STR$(XMouse%))
                        Caption(Y2LB) = LTRIM$(STR$(YMouse%))
                        ClickCount% = ClickCount% + 1
                        BeginDraw PictureBox1
                        LINE (Vertices%(1, 0) - 2, Vertices%(1, 1))-(Vertices%(1, 0) + 2, Vertices%(1, 1))
                        LINE (Vertices%(1, 0), Vertices%(1, 1) - 2)-(Vertices%(1, 0), Vertices%(1, 1) + 2)
                        LINE (Vertices%(0, 0), Vertices%(0, 1))-(Vertices%(1, 0), Vertices%(1, 1))
                        EndDraw PictureBox1
                        Caption(Click2LB) = "Vertex 3"
                    CASE 2
                        Vertices%(2, 0) = XMouse%
                        Vertices%(2, 1) = YMouse%
                        Caption(X3LB) = LTRIM$(STR$(XMouse%))
                        Caption(Y3LB) = LTRIM$(STR$(YMouse%))
                        ClickCount% = ClickCount% + 1
                        BeginDraw PictureBox1
                        LINE (Vertices%(2, 0) - 2, Vertices%(2, 1))-(Vertices%(2, 0) + 2, Vertices%(2, 1))
                        LINE (Vertices%(2, 0), Vertices%(2, 1) - 2)-(Vertices%(2, 0), Vertices%(2, 1) + 2)
                        LINE (Vertices%(1, 0), Vertices%(1, 1))-(Vertices%(2, 0), Vertices%(2, 1))
                        LINE (Vertices%(2, 0), Vertices%(2, 1))-(Vertices%(0, 0), Vertices%(0, 1))
                        EndDraw PictureBox1
                        Caption(Click1LB) = "Move Cursor"
                        Caption(Click2LB) = "Around"
                        Control(InsideOutsideLB).Hidden = False
                        'Triangle Side Lengths
                        A# = SideLength#(Vertices%(0, 0), Vertices%(0, 1), Vertices%(2, 0), Vertices%(2, 1))
                        B# = SideLength#(Vertices%(1, 0), Vertices%(1, 1), Vertices%(0, 0), Vertices%(0, 1))
                        C# = SideLength#(Vertices%(2, 0), Vertices%(2, 1), Vertices%(1, 0), Vertices%(1, 1))
                END SELECT
            END IF
        CASE ExitBT
            SYSTEM
        CASE RestartBT
            ClickCount% = 0
            BeginDraw PictureBox1
            COLOR _RGB32(0, 0, 0), _RGB32(255, 255, 255)
            CLS
            EndDraw PictureBox1
            Caption(X1LB) = ""
            Caption(Y1LB) = ""
            Caption(X2LB) = ""
            Caption(Y2LB) = ""
            Caption(X3LB) = ""
            Caption(Y3LB) = ""
            Control(InsideOutsideLB).Hidden = True
            Caption(Click1LB) = "Click To Set"
            Caption(Click2LB) = "Vertex 1"
    END SELECT
END SUB

SUB __UI_MouseEnter (id AS LONG)
END SUB

SUB __UI_MouseLeave (id AS LONG)
END SUB

SUB __UI_FocusIn (id AS LONG)
END SUB

SUB __UI_FocusOut (id AS LONG)
    'This event occurs right before a control loses focus.
    'To prevent a control from losing focus, set __UI_KeepFocus = True below.
END SUB

SUB __UI_MouseDown (id AS LONG)
END SUB

SUB __UI_MouseUp (id AS LONG)
END SUB

SUB __UI_KeyPress (id AS LONG)
    'When this event is fired, __UI_KeyHit will contain the code of the key hit.
    'You can change it and even cancel it by making it = 0
END SUB

SUB __UI_TextChanged (id AS LONG)
END SUB

SUB __UI_ValueChanged (id AS LONG)
END SUB

SUB __UI_FormResized
END SUB

'$INCLUDE:'../../InForm/InForm.ui'
'$INCLUDE:'../../InForm/xp.uitheme'
