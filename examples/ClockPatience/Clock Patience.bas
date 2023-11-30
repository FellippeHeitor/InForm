': Clock Patience (extra animations) by QWERKEY 2019-01-30 (updated 2019-03-16)
': Version with card pick-up and placement animation
': Images from pngimg.com, all-free-download.com, openclipart.org
': This program uses
': InForm - GUI library for QB64 - Beta version 8
': Fellippe Heitor, 2016-2018 - fellippe@qb64.org - @fellippeheitor
': https://github.com/FellippeHeitor/InForm
'-----------------------------------------------------------

': Controls' IDs: ------------------------------------------------------------------
DIM SHARED ClockPatience AS LONG
DIM SHARED ExitBT AS LONG
DIM SHARED NewGameBT AS LONG
CONST Offset%% = 7, Pi! = 3.141592, Hours! = -Pi! / 6, ZOffset! = -398, XImage% = 182, YImage% = 252
CONST Halfwidth%% = 50, Halfheight%% = Halfwidth%% * YImage% / XImage%, Radius% = 320, Tucked%% = 7
DIM SHARED CardsImg&(51), Obverse&, RedHighlight&, GreenHighlight&, GameOver&, GameWon&, XM%, YM%
DIM SHARED PickedUp%%, PickedHour%%, PickedCard%%, CanPutDown%%, Orient!, Orient0!, OldHour%%
DIM SHARED Anime1%%, Anime2%%, DoPickUp%%, TurnOver%%, GreenValid%%, RedValid%%, Cards%%(51)
DIM SHARED DoPatience%%, Stock%%, IsComplete%%, GotOut%%, Positions!(4, 12, 1, 4), Phi!(12)
REDIM SHARED Clock%%(12, 4, 2)

': External modules: ---------------------------------------------------------------
'$INCLUDE:'../../InForm/InForm.bi'
'$INCLUDE:'Clock Patience.frm'
'$INCLUDE:'../../InForm/xp.uitheme'
'$INCLUDE:'../../InForm/InForm.ui'

': Event procedures: ---------------------------------------------------------------
SUB __UI_BeforeInit
    $EXEICON:'.\clubs.ico'
    DoPatience%% = FALSE
    Anime1%% = 31
    Anime2%% = 43
    'Set Data
    FOR N%% = 0 TO 6
        Phi!(N%%) = N%% * Hours!
    NEXT N%%
    FOR N%% = 7 TO 11
        Phi!(N%%) = (N%% - 12) * Hours!
    NEXT N%%
    FOR S%% = 0 TO 4
        Positions!(S%%, 0, 0, 4) = 0
        Positions!(S%%, 0, 1, 4) = Radius% - Tucked%% * S%%
        Positions!(S%%, 0, 0, 3) = Positions!(S%%, 0, 0, 4) + Halfwidth%%
        Positions!(S%%, 0, 1, 3) = Positions!(S%%, 0, 1, 4) - Halfheight%%
        Positions!(S%%, 0, 0, 2) = Positions!(S%%, 0, 0, 4) - Halfwidth%%
        Positions!(S%%, 0, 1, 2) = Positions!(S%%, 0, 1, 4) - Halfheight%%
        Positions!(S%%, 0, 0, 1) = Positions!(S%%, 0, 0, 4) + Halfwidth%%
        Positions!(S%%, 0, 1, 1) = Positions!(S%%, 0, 1, 4) + Halfheight%%
        Positions!(S%%, 0, 0, 0) = Positions!(S%%, 0, 0, 4) - Halfwidth%%
        Positions!(S%%, 0, 1, 0) = Positions!(S%%, 0, 1, 4) + Halfheight%%
    NEXT S%%
    FOR S%% = 0 TO 4
        FOR N%% = 1 TO 11
            FOR M%% = 0 TO 4
                CALL Angle((Positions!(S%%, 0, 0, M%%)), (Positions!(S%%, 0, 1, M%%)), Positions!(S%%, N%%, 0, M%%), Positions!(S%%, N%%, 1, M%%), (Phi!(N%%)))
            NEXT M%%
        NEXT N%%
    NEXT S%%
    FOR S%% = 0 TO 4
        Positions!(S%%, 12, 0, 0) = Tucked%% * (3 - S%%) - Halfwidth%%
        Positions!(S%%, 12, 1, 0) = Halfheight%%
        Positions!(S%%, 12, 0, 1) = Positions!(S%%, 12, 0, 0) + 2 * Halfwidth%%
        Positions!(S%%, 12, 1, 1) = Halfheight%%
        Positions!(S%%, 12, 0, 2) = Tucked%% * (3 - S%%) - Halfwidth%%
        Positions!(S%%, 12, 1, 2) = -Halfheight%%
        Positions!(S%%, 12, 0, 3) = Positions!(S%%, 12, 0, 2) + 2 * Halfwidth%%
        Positions!(S%%, 12, 1, 3) = -Halfheight%%
        Positions!(S%%, 12, 0, 4) = Tucked%% * (3 - S%%)
        Positions!(S%%, 12, 1, 4) = 0
    NEXT S%%
    'Images
    playingcards& = _LOADIMAGE("pack of cards.png", 32)
    Corner& = _NEWIMAGE(33, 33, 32)
    _DEST Corner&
    COLOR _RGB32(247, 247, 247), _RGBA32(100, 100, 100, 0)
    CIRCLE (16, 16), 16
    PAINT (16, 16)
    CIRCLE (16, 16), 16, _RGB32(204, 119, 34)
    FOR N%% = 0 TO 51
        R1%% = N%% \ 13
        C1%% = N%% MOD 13
        R2%% = R1%% \ 2
        C2%% = R1%% MOD 2
        R3%% = C1%% \ 5
        C3%% = C1%% MOD 5
        TempImg& = _NEWIMAGE(XImage%, YImage%, 32)
        _DEST TempImg&
        COLOR _RGB32(247, 247, 247), _RGBA32(100, 100, 100, 0)
        _PUTIMAGE (0, 0), Corner&
        _PUTIMAGE (0, YImage% - 33), Corner&
        _PUTIMAGE (XImage% - 33, 0), Corner&
        _PUTIMAGE (XImage% - 33, YImage% - 33), Corner&
        LINE (16, 0)-(XImage% - 17, YImage% - 1), , BF
        LINE (0, 16)-(XImage% - 1, YImage% - 17), , BF
        LINE (16, 0)-(XImage% - 17, 0), _RGB32(204, 119, 34)
        LINE (16, YImage% - 1)-(XImage% - 17, YImage% - 1), _RGB32(204, 119, 34)
        LINE (0, 16)-(0, YImage% - 17), _RGB32(204, 119, 34)
        LINE (XImage% - 1, 16)-(XImage% - 1, YImage% - 17), _RGB32(204, 119, 34)
        X1! = 7 + 203 * C3%% + 996 * C2%%
        X2! = 167 + X1!
        Y1! = 13 + 267 * R3%% + 786 * R2%%
        Y2! = Y1! + 222
        _PUTIMAGE (6, 14)-(XImage% - 7, YImage% - 15), playingcards&, , (7 + 203 * C3%% + 996 * C2%%, Y1!)-(X2!, Y2!)
        IF N%% = 23 THEN
            F& = _LOADFONT("cyberbit.ttf", 14)
            _FONT F&
            COLOR _RGB32(226, 226, 226)
            Q1$ = "PVDQJDX"
            FOR M%% = 1 TO 7
                Q2$ = Q2$ + CHR$(ASC(MID$(Q1$, M%%, 1)) + 1)
            NEXT M%%
            _PRINTSTRING (XImage% - 110, YImage% - 20), Q2$
            _FONT 16
            _FREEFONT F&
        END IF
        CardsImg&(N%%) = _COPYIMAGE(TempImg&, 33)
        _FREEIMAGE TempImg&
    NEXT N%%
    _FREEIMAGE Corner&
    Corner& = _NEWIMAGE(33, 33, 32)
    _DEST Corner&
    COLOR _RGB32(200, 200, 247), _RGBA32(100, 100, 100, 0)
    CIRCLE (16, 16), 16
    PAINT (16, 16)
    CIRCLE (16, 16), 16, _RGB32(204, 119, 34)
    TempImg& = _NEWIMAGE(XImage%, YImage%, 32)
    _DEST TempImg&
    COLOR _RGB32(200, 200, 247)
    _PUTIMAGE (0, 0), Corner&
    _PUTIMAGE (0, YImage% - 33), Corner&
    _PUTIMAGE (XImage% - 33, 0), Corner&
    _PUTIMAGE (XImage% - 33, YImage% - 33), Corner&
    LINE (16, 0)-(XImage% - 17, YImage% - 1), , BF
    LINE (0, 16)-(XImage% - 1, YImage% - 17), , BF
    LINE (16, 0)-(XImage% - 17, 0), _RGB32(204, 119, 34)
    LINE (16, YImage% - 1)-(XImage% - 17, YImage% - 1), _RGB32(204, 119, 34)
    LINE (0, 16)-(0, YImage% - 17), _RGB32(204, 119, 34)
    LINE (XImage% - 1, 16)-(XImage% - 1, YImage% - 17), _RGB32(204, 119, 34)
    C3%% = 4
    C2%% = 0
    R3%% = 2
    R2%% = 0
    X1! = 7 + 203 * C3%% + 996 * C2%%
    X2! = 167 + X1!
    Y1! = 13 + 267 * R3%% + 786 * R2%%
    Y2! = Y1! + 222
    _PUTIMAGE (14, 14)-(XImage% - 15, YImage% - 15), playingcards&, , (14 + 203 * C3%% + 996 * C2%%, Y1!)-(X2! - 4, Y2!)
    Obverse& = _COPYIMAGE(TempImg&, 33)
    _FREEIMAGE TempImg&
    _FREEIMAGE Corner&
    _FREEIMAGE playingcards&
    TempImg& = _NEWIMAGE(81, 81, 32)
    _DEST TempImg&
    COLOR _RGB32(200, 0, 0)
    CIRCLE (40, 40), 40
    CIRCLE (40, 40), 39
    CIRCLE (40, 40), 38
    RedHighlight& = _COPYIMAGE(TempImg&, 33)
    _FREEIMAGE TempImg&
    TempImg& = _NEWIMAGE(81, 81, 32)
    _DEST TempImg&
    COLOR _RGB32(0, 200, 0)
    CIRCLE (40, 40), 40
    CIRCLE (40, 40), 39
    CIRCLE (40, 40), 38
    GreenHighlight& = _COPYIMAGE(TempImg&, 33)
    _FREEIMAGE TempImg&
    TempImg& = _NEWIMAGE(340, 80, 32)
    _DEST TempImg&
    COLOR _RGB32(0, 80, 32), _RGBA32(100, 100, 100, 0)
    F& = _LOADFONT("cyberbit.ttf", 70)
    _FONT F&
    _PRINTSTRING (5, 5), "Game End"
    _FONT 16
    _FREEFONT F&
    GameOver& = _COPYIMAGE(TempImg&, 33)
    _FREEIMAGE TempImg&
    TempImg& = _NEWIMAGE(356, 80, 32)
    _DEST TempImg&
    COLOR _RGB32(0, 80, 32), _RGBA32(100, 100, 100, 0)
    F& = _LOADFONT("cyberbit.ttf", 70)
    _FONT F&
    _PRINTSTRING (5, 5), "Completed"
    _FONT 16
    _FREEFONT F&
    GameWon& = _COPYIMAGE(TempImg&, 33)
    _FREEIMAGE TempImg&
    FOR N%% = 0 TO 51
        Cards%%(N%%) = N%% + 1 'Cards%%() values adjusted to 1 - 13: then value 0 is empty
    NEXT N%%
    FOR N%% = 1 TO 4
        CALL Shuffle(Cards%%())
    NEXT N%%
END SUB

SUB __UI_OnLoad
    _SCREENMOVE 50, 0
    Caption(NewGameBT) = "Deal"
    SetFocus NewGameBT
END SUB

SUB __UI_BeforeUpdateDisplay
    'This event occurs at approximately 30 frames per second.
    'You can change the update frequency by calling SetFrameRate DesiredRate%
    STATIC Count%, InitDone%%, Grandad&, XStart%, YStart%
    IF NOT InitDone%% THEN
        InitDone%% = TRUE
        XStart% = -120
        YStart% = 0
        Grandad& = _LOADIMAGE("Clock1.png", 33)
    END IF
    IF NOT DoPatience%% THEN
        _PUTIMAGE (201, 10), Grandad&
    ELSE
        IF GreenValid%% THEN
            _MAPTRIANGLE (0, 0)-(80, 0)-(0, 80), GreenHighlight& TO(Positions!(4, PickedHour%%, 0, 4) - 40, Positions!(4, PickedHour%%, 1, 4) + 40, ZOffset!)-(Positions!(4, PickedHour%%, 0, 4) + 40, Positions!(4, PickedHour%%, 1, 4) + 40, ZOffset!)-(Positions!(4, PickedHour%%, 0, 4) - 40, Positions!(4, PickedHour%%, 1, 4) - 40, ZOffset!)
            _MAPTRIANGLE (80, 80)-(0, 80)-(80, 0), GreenHighlight& TO(Positions!(4, PickedHour%%, 0, 4) + 40, Positions!(4, PickedHour%%, 1, 4) + -40, ZOffset!)-(Positions!(4, PickedHour%%, 0, 4) - 40, Positions!(4, PickedHour%%, 1, 4) - 40, ZOffset!)-(Positions!(4, PickedHour%%, 0, 4) + 40, Positions!(4, PickedHour%%, 1, 4) + 40, ZOffset!)
        ELSEIF RedValid%% THEN
            _MAPTRIANGLE (0, 0)-(80, 0)-(0, 80), RedHighlight& TO(Positions!(4, PickedHour%%, 0, 4) - 40, Positions!(4, PickedHour%%, 1, 4) + 40, ZOffset!)-(Positions!(4, PickedHour%%, 0, 4) + 40, Positions!(4, PickedHour%%, 1, 4) + 40, ZOffset!)-(Positions!(4, PickedHour%%, 0, 4) - 40, Positions!(4, PickedHour%%, 1, 4) - 40, ZOffset!)
            _MAPTRIANGLE (80, 80)-(0, 80)-(80, 0), RedHighlight& TO(Positions!(4, PickedHour%%, 0, 4) + 40, Positions!(4, PickedHour%%, 1, 4) + -40, ZOffset!)-(Positions!(4, PickedHour%%, 0, 4) - 40, Positions!(4, PickedHour%%, 1, 4) - 40, ZOffset!)-(Positions!(4, PickedHour%%, 0, 4) + 40, Positions!(4, PickedHour%%, 1, 4) + 40, ZOffset!)
        END IF
        IF Anime1%% < 31 THEN
            'Display turning-over
            IF OldHour%% = 12 THEN
                IF Anime1%% > 15 THEN
                    Xtent! = 2 * Halfwidth%% * (Anime1%% - 15) / 15
                    X0! = Positions!(4, OldHour%%, 0, 0)
                    Y0! = Positions!(4, OldHour%%, 1, 0)
                    Z0! = 0.7 * SQR((4 * Halfwidth%% * Halfwidth%%) - (Xtent! * Xtent!))
                    X1! = Positions!(4, OldHour%%, 0, 0) + Xtent!
                    Y1! = Positions!(4, OldHour%%, 1, 0)
                    Z1! = 0
                    X2! = Positions!(4, OldHour%%, 0, 2)
                    Y2! = Positions!(4, OldHour%%, 1, 2)
                    Z2! = 0.7 * SQR((4 * Halfwidth%% * Halfwidth%%) - (Xtent! * Xtent!))
                    X3! = Positions!(4, OldHour%%, 0, 2) + Xtent!
                    Y3! = Positions!(4, OldHour%%, 1, 2)
                    Z3! = 0
                    _MAPTRIANGLE (0, 0)-(XImage% - 1, 0)-(0, YImage% - 1), CardsImg&(PickedCard%% - 1) TO(X0!, Y0!, Z0! + ZOffset!)-(X1!, Y1!, Z1! + ZOffset!)-(X2!, Y2!, Z2! + ZOffset!)
                    _MAPTRIANGLE (XImage% - 1, YImage% - 1)-(0, YImage% - 1)-(XImage% - 1, 0), CardsImg&(PickedCard%% - 1) TO(X3!, Y3!, Z3! + ZOffset!)-(X2!, Y2!, Z2! + ZOffset!)-(X1!, Y1!, Z1! + ZOffset!)
                ELSE
                    Psi! = Anime1%% * Pi! / (2 * 15)
                    X0! = Positions!(4, OldHour%%, 0, 0)
                    Y0! = Positions!(4, OldHour%%, 1, 0)
                    Z0! = 0
                    X1! = X0! + 2 * Halfwidth%% * COS(Psi!)
                    Y1! = Y0!
                    Z1! = 0.7 * 2 * Halfwidth%% * SIN(Psi!)
                    X2! = Positions!(4, OldHour%%, 0, 2)
                    Y2! = Positions!(4, OldHour%%, 1, 2)
                    Z2! = 0
                    X3! = X2! + 2 * Halfwidth%% * COS(Psi!)
                    Y3! = Y2!
                    Z3! = 0.7 * 2 * Halfwidth%% * SIN(Psi!)
                    _MAPTRIANGLE (0, 0)-(XImage% - 1, 0)-(0, YImage% - 1), Obverse& TO(X0!, Y0!, Z0! + ZOffset!)-(X1!, Y1!, Z1! + ZOffset!)-(X2!, Y2!, Z2! + ZOffset!)
                    _MAPTRIANGLE (XImage% - 1, YImage% - 1)-(0, YImage% - 1)-(XImage% - 1, 0), Obverse& TO(X3!, Y3!, Z3! + ZOffset!)-(X2!, Y2!, Z2! + ZOffset!)-(X1!, Y1!, Z1! + ZOffset!)
                END IF
            ELSE
                IF Anime1%% > 15 THEN
                    Xtent! = 2 * Halfwidth%% * (Anime1%% - 15) / 15
                    XA! = Positions!(4, 0, 0, 0)
                    YA! = Positions!(4, 0, 1, 0)
                    Z0! = 0.7 * SQR((4 * Halfwidth%% * Halfwidth%%) - (Xtent! * Xtent!))
                    XB! = Positions!(4, 0, 0, 0) + Xtent!
                    YB! = Positions!(4, 0, 1, 0)
                    Z1! = 0
                    XC! = Positions!(4, 0, 0, 2)
                    YC! = Positions!(4, 0, 1, 2)
                    Z2! = 0.7 * SQR((4 * Halfwidth%% * Halfwidth%%) - (Xtent! * Xtent!))
                    XD! = Positions!(4, 0, 0, 2) + Xtent!
                    YD! = Positions!(4, 0, 1, 2)
                    Z3! = 0
                    CALL Angle((XA!), (YA!), X0!, Y0!, Orient0!)
                    CALL Angle((XB!), (YB!), X1!, Y1!, Orient0!)
                    CALL Angle((XC!), (YC!), X2!, Y2!, Orient0!)
                    CALL Angle((XD!), (YD!), X3!, Y3!, Orient0!)
                    _MAPTRIANGLE (0, 0)-(XImage% - 1, 0)-(0, YImage% - 1), CardsImg&(PickedCard%% - 1) TO(X0!, Y0!, Z0! + ZOffset!)-(X1!, Y1!, Z1! + ZOffset!)-(X2!, Y2!, Z2! + ZOffset!)
                    _MAPTRIANGLE (XImage% - 1, YImage% - 1)-(0, YImage% - 1)-(XImage% - 1, 0), CardsImg&(PickedCard%% - 1) TO(X3!, Y3!, Z3! + ZOffset!)-(X2!, Y2!, Z2! + ZOffset!)-(X1!, Y1!, Z1! + ZOffset!)
                ELSE
                    Psi! = Anime1%% * Pi! / (2 * 15)
                    XA! = Positions!(4, 0, 0, 0)
                    YA! = Positions!(4, 0, 1, 0)
                    Z0! = 0
                    XB! = XA! + 2 * Halfwidth%% * COS(Psi!)
                    YB! = YA!
                    Z1! = 0.7 * 2 * Halfwidth%% * SIN(Psi!)
                    XC! = Positions!(4, 0, 0, 2)
                    YC! = Positions!(4, 0, 1, 2)
                    Z2! = 0
                    XD! = XC! + 2 * Halfwidth%% * COS(Psi!)
                    YD! = YC!
                    Z3! = 0.7 * 2 * Halfwidth%% * SIN(Psi!)
                    CALL Angle((XA!), (YA!), X0!, Y0!, Orient0!)
                    CALL Angle((XB!), (YB!), X1!, Y1!, Orient0!)
                    CALL Angle((XC!), (YC!), X2!, Y2!, Orient0!)
                    CALL Angle((XD!), (YD!), X3!, Y3!, Orient0!)
                    _MAPTRIANGLE (0, 0)-(XImage% - 1, 0)-(0, YImage% - 1), Obverse& TO(X0!, Y0!, Z0! + ZOffset!)-(X1!, Y1!, Z1! + ZOffset!)-(X2!, Y2!, Z2! + ZOffset!)
                    _MAPTRIANGLE (XImage% - 1, YImage% - 1)-(0, YImage% - 1)-(XImage% - 1, 0), Obverse& TO(X3!, Y3!, Z3! + ZOffset!)-(X2!, Y2!, Z2! + ZOffset!)-(X1!, Y1!, Z1! + ZOffset!)
                END IF
            END IF
            Anime1%% = Anime1%% + 1
            IF Anime1%% = 31 THEN
                TurnOver%% = FALSE
                Clock%%(PickedHour%%, 4, 0) = PickedCard%%
                Clock%%(PickedHour%%, 4, 1) = TRUE 'Temporary until picked up
            END IF
        ELSEIF Anime2%% < 43 THEN
            'Display Tucking-in
            IF PickedHour%% = 12 THEN
                'Horizontal for Kings
                IF Anime2%% > 22 THEN
                    Xdelta% = Positions!(1, PickedHour%%, 0, 1) - Positions!(4, PickedHour%%, 0, 0) + Tucked%%
                    X0! = Positions!(4, PickedHour%%, 0, 0) + Xdelta% * (45 - Anime2%%) / 23
                    Y0! = Positions!(4, PickedHour%%, 1, 0)
                    X1! = Positions!(4, PickedHour%%, 0, 1) + Xdelta% * (45 - Anime2%%) / 23
                    Y1! = Positions!(4, PickedHour%%, 1, 1)
                    X2! = Positions!(4, PickedHour%%, 0, 2) + Xdelta% * (45 - Anime2%%) / 23
                    Y2! = Positions!(4, PickedHour%%, 1, 2)
                    X3! = Positions!(4, PickedHour%%, 0, 3) + Xdelta% * (45 - Anime2%%) / 23
                    Y3! = Positions!(4, PickedHour%%, 1, 3)
                    Zpos! = -0.5
                    _MAPTRIANGLE (0, 0)-(XImage% - 1, 0)-(0, YImage% - 1), CardsImg&(PickedCard%% - 1) TO(X0!, Y0!, Zpos! + ZOffset!)-(X1!, Y1!, Zpos! + ZOffset!)-(X2!, Y2!, Zpos! + ZOffset!)
                    _MAPTRIANGLE (XImage% - 1, YImage% - 1)-(0, YImage% - 1)-(XImage% - 1, 0), CardsImg&(PickedCard%% - 1) TO(X3!, Y3!, Zpos! + ZOffset!)-(X2!, Y2!, Zpos! + ZOffset!)-(X1!, Y1!, Zpos! + ZOffset!)
                ELSE
                    Xdelta% = Positions!(1, PickedHour%%, 0, 1) - Positions!(4, PickedHour%%, 0, 0) + Tucked%%
                    X0! = Positions!(4, PickedHour%%, 0, 0) + Xdelta% * Anime2%% / 22
                    Y0! = Positions!(4, PickedHour%%, 1, 0)
                    X1! = Positions!(4, PickedHour%%, 0, 1) + Xdelta% * Anime2%% / 22
                    Y1! = Positions!(4, PickedHour%%, 1, 1)
                    X2! = Positions!(4, PickedHour%%, 0, 2) + Xdelta% * Anime2%% / 22
                    Y2! = Positions!(4, PickedHour%%, 1, 2)
                    X3! = Positions!(4, PickedHour%%, 0, 3) + Xdelta% * Anime2%% / 22
                    Y3! = Positions!(4, PickedHour%%, 1, 3)
                    Zpos! = 0.5
                    _MAPTRIANGLE (0, 0)-(XImage% - 1, 0)-(0, YImage% - 1), CardsImg&(PickedCard%% - 1) TO(X0!, Y0!, Zpos! + ZOffset!)-(X1!, Y1!, Zpos! + ZOffset!)-(X2!, Y2!, Zpos! + ZOffset!)
                    _MAPTRIANGLE (XImage% - 1, YImage% - 1)-(0, YImage% - 1)-(XImage% - 1, 0), CardsImg&(PickedCard%% - 1) TO(X3!, Y3!, Zpos! + ZOffset!)-(X2!, Y2!, Zpos! + ZOffset!)-(X1!, Y1!, Zpos! + ZOffset!)
                END IF
            ELSE
                'Vertical for others
                IF Anime2%% > 22 THEN
                    Ydelta% = Positions!(0, 0, 1, 0) - Positions!(4, 0, 1, 2) + Tucked%%
                    XA! = Positions!(4, 0, 0, 0)
                    YA! = Positions!(4, 0, 1, 0) + Ydelta% * (45 - Anime2%%) / 23
                    XB! = Positions!(4, 0, 0, 1)
                    YB! = Positions!(4, 0, 1, 1) + Ydelta% * (45 - Anime2%%) / 23
                    XC! = Positions!(4, 0, 0, 2)
                    YC! = Positions!(4, 0, 1, 2) + Ydelta% * (45 - Anime2%%) / 23
                    XD! = Positions!(4, 0, 0, 3)
                    YD! = Positions!(4, 0, 1, 3) + Ydelta% * (45 - Anime2%%) / 23
                    CALL Angle((XA!), (YA!), X0!, Y0!, Orient!)
                    CALL Angle((XB!), (YB!), X1!, Y1!, Orient!)
                    CALL Angle((XC!), (YC!), X2!, Y2!, Orient!)
                    CALL Angle((XD!), (YD!), X3!, Y3!, Orient!)
                    Zpos! = -0.5
                    _MAPTRIANGLE (0, 0)-(XImage% - 1, 0)-(0, YImage% - 1), CardsImg&(PickedCard%% - 1) TO(X0!, Y0!, Zpos! + ZOffset!)-(X1!, Y1!, Zpos! + ZOffset!)-(X2!, Y2!, Zpos! + ZOffset!)
                    _MAPTRIANGLE (XImage% - 1, YImage% - 1)-(0, YImage% - 1)-(XImage% - 1, 0), CardsImg&(PickedCard%% - 1) TO(X3!, Y3!, Zpos! + ZOffset!)-(X2!, Y2!, Zpos! + ZOffset!)-(X1!, Y1!, Zpos! + ZOffset!)
                ELSE
                    Ydelta% = Positions!(0, 0, 1, 0) - Positions!(4, 0, 1, 2) + Tucked%%
                    XA! = Positions!(4, 0, 0, 0)
                    YA! = Positions!(4, 0, 1, 0) + Ydelta% * Anime2%% / 22
                    XB! = Positions!(4, 0, 0, 1)
                    YB! = Positions!(4, 0, 1, 1) + Ydelta% * Anime2%% / 22
                    XC! = Positions!(4, 0, 0, 2)
                    YC! = Positions!(4, 0, 1, 2) + Ydelta% * Anime2%% / 22
                    XD! = Positions!(4, 0, 0, 3)
                    YD! = Positions!(4, 0, 1, 3) + Ydelta% * Anime2%% / 22
                    CALL Angle((XA!), (YA!), X0!, Y0!, Orient!)
                    CALL Angle((XB!), (YB!), X1!, Y1!, Orient!)
                    CALL Angle((XC!), (YC!), X2!, Y2!, Orient!)
                    CALL Angle((XD!), (YD!), X3!, Y3!, Orient!)
                    Zpos! = 0.5
                    _MAPTRIANGLE (0, 0)-(XImage% - 1, 0)-(0, YImage% - 1), CardsImg&(PickedCard%% - 1) TO(X0!, Y0!, Zpos! + ZOffset!)-(X1!, Y1!, Zpos! + ZOffset!)-(X2!, Y2!, Zpos! + ZOffset!)
                    _MAPTRIANGLE (XImage% - 1, YImage% - 1)-(0, YImage% - 1)-(XImage% - 1, 0), CardsImg&(PickedCard%% - 1) TO(X3!, Y3!, Zpos! + ZOffset!)-(X2!, Y2!, Zpos! + ZOffset!)-(X1!, Y1!, Zpos! + ZOffset!)
                END IF
            END IF
            Anime2%% = Anime2%% + 1
            IF Anime2%% = 43 THEN CanPutDown%% = TRUE
        ELSEIF PickedUp%% THEN
            'Display picked-up card
            IF __UI_MouseLeft > 680 AND __UI_MouseTop > 738 THEN
                'Do Nothing
            ELSE
                CALL Angle(-Halfwidth%%, Halfheight%, X0!, Y0!, Orient!)
                CALL Angle(Halfwidth%%, Halfheight%, X1!, Y1!, Orient!)
                CALL Angle(-Halfwidth%%, -Halfheight%, X2!, Y2!, Orient!)
                CALL Angle(Halfwidth%%, -Halfheight%, X3!, Y3!, Orient!)
                X0! = X0! + XM%
                Y0! = Y0! + YM%
                X1! = X1! + XM%
                Y1! = Y1! + YM%
                X2! = X2! + XM%
                Y2! = Y2! + YM%
                X3! = X3! + XM%
                Y3! = Y3! + YM%
                _MAPTRIANGLE (0, 0)-(XImage% - 1, 0)-(0, YImage% - 1), CardsImg&(PickedCard%% - 1) TO(X0!, Y0!, ZOffset!)-(X1!, Y1!, ZOffset!)-(X2!, Y2!, ZOffset!)
                _MAPTRIANGLE (XImage% - 1, YImage% - 1)-(0, YImage% - 1)-(XImage% - 1, 0), CardsImg&(PickedCard%% - 1) TO(X3!, Y3!, ZOffset!)-(X2!, Y2!, ZOffset!)-(X1!, Y1!, ZOffset!)
            END IF
        END IF
        'Display Piles
        FOR S%% = 4 TO 0 STEP -1 'Maptriangle order is backwards
            FOR N%% = 0 TO 12
                IF Clock%%(N%%, S%%, 0) <> 0 THEN
                    IF Clock%%(N%%, S%%, 1) THEN
                        _MAPTRIANGLE (0, 0)-(XImage% - 1, 0)-(0, YImage% - 1), CardsImg&(Clock%%(N%%, S%%, 0) - 1) TO(Positions!(S%%, N%%, 0, 0), Positions!(S%%, N%%, 1, 0), ZOffset!)-(Positions!(S%%, N%%, 0, 1), Positions!(S%%, N%%, 1, 1), ZOffset!)-(Positions!(S%%, N%%, 0, 2), Positions!(S%%, N%%, 1, 2), ZOffset!)
                        _MAPTRIANGLE (XImage% - 1, YImage% - 1)-(0, YImage% - 1)-(XImage% - 1, 0), CardsImg&(Clock%%(N%%, S%%, 0) - 1) TO(Positions!(S%%, N%%, 0, 3), Positions!(S%%, N%%, 1, 3), ZOffset!)-(Positions!(S%%, N%%, 0, 2), Positions!(S%%, N%%, 1, 2), ZOffset!)-(Positions!(S%%, N%%, 0, 1), Positions!(S%%, N%%, 1, 1), ZOffset!)
                    ELSE
                        _MAPTRIANGLE (0, 0)-(XImage% - 1, 0)-(0, YImage% - 1), Obverse& TO(Positions!(S%%, N%%, 0, 0), Positions!(S%%, N%%, 1, 0), ZOffset!)-(Positions!(S%%, N%%, 0, 1), Positions!(S%%, N%%, 1, 1), ZOffset!)-(Positions!(S%%, N%%, 0, 2), Positions!(S%%, N%%, 1, 2), ZOffset!)
                        _MAPTRIANGLE (XImage% - 1, YImage% - 1)-(0, YImage% - 1)-(XImage% - 1, 0), Obverse& TO(Positions!(S%%, N%%, 0, 3), Positions!(S%%, N%%, 1, 3), ZOffset!)-(Positions!(S%%, N%%, 0, 2), Positions!(S%%, N%%, 1, 2), ZOffset!)-(Positions!(S%%, N%%, 0, 1), Positions!(S%%, N%%, 1, 1), ZOffset!)
                    END IF
                END IF
            NEXT N%%
        NEXT S%%
        IF Stock%% > 0 THEN
            'Display Stock
            IF Stock%% > 1 THEN
                _MAPTRIANGLE (0, 0)-(XImage% - 1, 0)-(0, YImage% - 1), Obverse& TO(XStart% - Halfwidth%%, YStart% + Halfheight%%, ZOffset!)-(XStart% + Halfwidth%%, YStart% + Halfheight%%, ZOffset!)-(XStart% - Halfwidth%%, YStart% - Halfheight%%, ZOffset!)
                _MAPTRIANGLE (XImage% - 1, YImage% - 1)-(0, YImage% - 1)-(XImage% - 1, 0), Obverse& TO(XStart% + Halfwidth%%, YStart% - Halfheight%%, ZOffset!)-(XStart% - Halfwidth%%, YStart% - Halfheight%%, ZOffset!)-(XStart% + Halfwidth%%, YStart% + Halfheight%%, ZOffset!)
            END IF
            IF Stock%% > 10 THEN
                _MAPTRIANGLE (0, 0)-(XImage% - 1, 0)-(0, YImage% - 1), Obverse& TO(XStart% - Halfwidth%%, YStart% + Halfheight%% - 1, ZOffset!)-(XStart% + Halfwidth%%, YStart% + Halfheight%% - 1, ZOffset!)-(XStart% - Halfwidth%%, YStart% - Halfheight%% - 1, ZOffset!)
                _MAPTRIANGLE (XImage% - 1, YImage% - 1)-(0, YImage% - 1)-(XImage% - 1, 0), Obverse& TO(XStart% + Halfwidth%%, YStart% - Halfheight%% - 1, ZOffset!)-(XStart% - Halfwidth%%, YStart% - Halfheight%% - 1, ZOffset!)-(XStart% + Halfwidth%%, YStart% + Halfheight%% - 1, ZOffset!)
            END IF
            IF Stock%% > 20 THEN
                _MAPTRIANGLE (0, 0)-(XImage% - 1, 0)-(0, YImage% - 1), Obverse& TO(XStart% - Halfwidth%%, YStart% + Halfheight%% - 2, ZOffset!)-(XStart% + Halfwidth%%, YStart% + Halfheight%% - 2, ZOffset!)-(XStart% - Halfwidth%%, YStart% - Halfheight%% - 2, ZOffset!)
                _MAPTRIANGLE (XImage% - 1, YImage% - 1)-(0, YImage% - 1)-(XImage% - 1, 0), Obverse& TO(XStart% + Halfwidth%%, YStart% - Halfheight%% - 2, ZOffset!)-(XStart% - Halfwidth%%, YStart% - Halfheight%% - 2, ZOffset!)-(XStart% + Halfwidth%%, YStart% + Halfheight%% - 2, ZOffset!)
            END IF
            IF Stock%% > 30 THEN
                _MAPTRIANGLE (0, 0)-(XImage% - 1, 0)-(0, YImage% - 1), Obverse& TO(XStart% - Halfwidth%%, YStart% + Halfheight%% - 3, ZOffset!)-(XStart% + Halfwidth%%, YStart% + Halfheight%% - 3, ZOffset!)-(XStart% - Halfwidth%%, YStart% - Halfheight%% - 3, ZOffset!)
                _MAPTRIANGLE (XImage% - 1, YImage% - 1)-(0, YImage% - 1)-(XImage% - 1, 0), Obverse& TO(XStart% + Halfwidth%%, YStart% - Halfheight%% - 3, ZOffset!)-(XStart% - Halfwidth%%, YStart% - Halfheight%% - 3, ZOffset!)-(XStart% + Halfwidth%%, YStart% + Halfheight%% - 3, ZOffset!)
            END IF
            IF Stock%% > 41 THEN
                _MAPTRIANGLE (0, 0)-(XImage% - 1, 0)-(0, YImage% - 1), Obverse& TO(XStart% - Halfwidth%%, YStart% + Halfheight%% - 4, ZOffset!)-(XStart% + Halfwidth%%, YStart% + Halfheight%% - 4, ZOffset!)-(XStart% - Halfwidth%%, YStart% - Halfheight%% - 4, ZOffset!)
                _MAPTRIANGLE (XImage% - 1, YImage% - 1)-(0, YImage% - 1)-(XImage% - 1, 0), Obverse& TO(XStart% + Halfwidth%%, YStart% - Halfheight%% - 4, ZOffset!)-(XStart% - Halfwidth%%, YStart% - Halfheight%% - 4, ZOffset!)-(XStart% + Halfwidth%%, YStart% + Halfheight%% - 4, ZOffset!)
            END IF
            'Display dealt card
            S%% = (52 - Stock%%) \ 13
            N%% = (52 - Stock%%) MOD 13
            Count% = Count% + 1
            Zpos! = 50 * SIN(Pi! * Count% / 15)
            ActualAngle! = Phi!(N%%) * Count% / 15
            XPos! = XStart% + (Positions!(S%%, N%%, 0, 4) - XStart%) * Count% / 15
            YPos! = YStart% + (Positions!(S%%, N%%, 1, 4) - YStart%) * Count% / 15
            CALL Angle((-Halfwidth%%), (Halfheight%%), X0!, Y0!, (ActualAngle!))
            CALL Angle((Halfwidth%%), (Halfheight%%), X1!, Y1!, (ActualAngle!))
            CALL Angle((-Halfwidth%%), (-Halfheight%%), X2!, Y2!, (ActualAngle!))
            CALL Angle((Halfwidth%%), (-Halfheight%%), X3!, Y3!, (ActualAngle!))
            X0! = XPos! + X0!
            Y0! = YPos! + Y0!
            X1! = XPos! + X1!
            Y1! = YPos! + Y1!
            X2! = XPos! + X2!
            Y2! = YPos! + Y2!
            X3! = XPos! + X3!
            Y3! = YPos! + Y3!
            _MAPTRIANGLE (0, 0)-(XImage% - 1, 0)-(0, YImage% - 1), Obverse& TO(X0!, Y0!, Zpos! + ZOffset!)-(X1!, Y1!, Zpos! + ZOffset!)-(X2!, Y2!, Zpos! + ZOffset!)
            _MAPTRIANGLE (XImage% - 1, YImage% - 1)-(0, YImage% - 1)-(XImage% - 1, 0), Obverse& TO(X3!, Y3!, Zpos! + ZOffset!)-(X2!, Y2!, Zpos! + ZOffset!)-(X1!, Y1!, Zpos! + ZOffset!)
            IF Count% = 15 THEN
                Count% = 0
                Clock%%((52 - Stock%%) MOD 13, 1 + ((52 - Stock%%) \ 13), 0) = Clock%%((52 - Stock%%) MOD 13, 1 + ((52 - Stock%%) \ 13), 2)
                Stock%% = Stock%% - 1
            END IF
        END IF
        IF IsComplete%% THEN
            _PUTIMAGE (230, 246), GameOver&
            IF GotOut%% THEN _PUTIMAGE (222, 490), GameWon&
        END IF
    END IF
END SUB

SUB __UI_BeforeUnload
    'If you set __UI_UnloadSignal = False here you can
    'cancel the user's request to close.
END SUB

SUB __UI_Click (id AS LONG)
    SELECT CASE id
        CASE ClockPatience
            IF GreenValid%% THEN
                DoPickUp%% = TRUE
            ELSEIF RedValid%% THEN
                Anime2%% = 0
            END IF
        CASE ExitBT
            SYSTEM
        CASE NewGameBT
            IF NOT DoPatience%% THEN
                Control(NewGameBT).Disabled = TRUE
                Control(NewGameBT).Hidden = TRUE
                Caption(NewGameBT) = "New Game"
                SetFocus ExitBT
                CALL Patience
            ELSE
                DoPatience%% = FALSE
                Caption(NewGameBT) = "Deal"
            END IF
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

SUB Angle (Xin!, Yin!, Xout!, Yout!, Theta!)
    Xout! = Xin! * COS(Theta!) - Yin! * SIN(Theta!)
    Yout! = Xin! * SIN(Theta!) + Yin! * COS(Theta!)
END SUB

SUB Patience
    RANDOMIZE (TIMER)
    BadDeal%% = TRUE
    WHILE BadDeal%%
        REDIM Clock%%(12, 4, 2)
        CALL Shuffle(Cards%%())
        'Deal Sim
        FOR N%% = 0 TO 51
            S%% = N%% \ 13
            R%% = N%% MOD 13
            Clock%%(R%%, S%% + 1, 2) = Cards%%(N%%)
        NEXT N%%
        BadDeal%% = FALSE
        FOR M%% = 0 TO 12 'Cards are in S 1 to 4
            IF Clock%%(M%%, 1, 2) MOD 13 = Clock%%(M%%, 2, 2) MOD 13 AND Clock%%(M%%, 1, 2) MOD 13 = Clock%%(M%%, 3, 2) MOD 13 AND Clock%%(M%%, 1, 2) MOD 13 = Clock%%(M%%, 4, 2) MOD 13 THEN BadDeal%% = TRUE
        NEXT M%%
    WEND
    Stock%% = 52
    Anime1%% = 31
    Anime2%% = 43
    TurnOver%% = TRUE
    DoPickUp%% = FALSE
    PickedUp%% = FALSE
    PickedCard%% = 0
    PickedHour%% = 12
    CanPutDown%% = FALSE
    IsComplete%% = FALSE
    DoPatience%% = TRUE
    HangOn%% = TRUE
    HangStop%% = 50
    HCount%% = 0
    WHILE DoPatience%%
        _LIMIT 60
        GreenValid%% = FALSE
        RedValid%% = FALSE
        IF Stock%% = 0 AND HangOn%% THEN
            HCount%% = HCount%% + 1
            IF HCount%% = HangStop%% THEN
                HangOn%% = FALSE
                HCount%% = 0
                HangStop%% = 20
            END IF
        END IF
        IF Stock%% = 0 AND NOT IsComplete%% AND Anime1%% = 31 AND Anime2%% = 43 AND NOT HangOn%% THEN
            'In _MAPTRIANGLE3D, all distances relative to centre of screen
            XM% = __UI_MouseLeft - _WIDTH / 2
            YM% = _HEIGHT / 2 - __UI_MouseTop
            IF TurnOver%% THEN
                Orient0! = Phi!(PickedHour%%) 'Start orientation is from where the card is taken
                PickedCard%% = Clock%%(PickedHour%%, 4, 0) 'From 1 to 52
                Clock%%(PickedHour%%, 4, 0) = 0
                OldHour%% = PickedHour%%
                Anime1%% = 0
            ELSEIF NOT DoPickUp%% AND NOT PickedUp%% THEN
                IF SQR((Positions!(4, PickedHour%%, 0, 4) - XM%) * (Positions!(4, PickedHour%%, 0, 4) - XM%) + (Positions!(4, PickedHour%%, 1, 4) - YM%) * (Positions!(4, PickedHour%%, 1, 4) - YM%)) < 40 THEN GreenValid%% = TRUE
            ELSEIF DoPickUp%% THEN
                IF PickedHour%% = 12 THEN
                    FOR R%% = 4 TO 2 STEP -1
                        Clock%%(PickedHour%%, R%%, 0) = Clock%%(PickedHour%%, R%% - 1, 0)
                        Clock%%(PickedHour%%, R%%, 1) = Clock%%(PickedHour%%, R%% - 1, 1)
                    NEXT R%%
                    Clock%%(PickedHour%%, 1, 0) = 0
                ELSE
                    FOR R%% = 4 TO 1 STEP -1
                        Clock%%(PickedHour%%, R%%, 0) = Clock%%(PickedHour%%, R%% - 1, 0)
                        Clock%%(PickedHour%%, R%%, 1) = Clock%%(PickedHour%%, R%% - 1, 1)
                    NEXT R%%
                    Clock%%(PickedHour%%, 0, 0) = 0
                END IF
                PickedHour%% = PickedCard%% MOD 13
                IF PickedHour%% = 0 THEN
                    PickedHour%% = 12
                ELSEIF PickedHour%% = 12 THEN
                    PickedHour%% = 0
                END IF
                Orient1! = Phi!(PickedHour%%)
                PickedUp%% = TRUE
                DoPickUp%% = FALSE
            ELSEIF PickedUp%% THEN
                IF SQR((Positions!(4, PickedHour%%, 0, 4) - XM%) * (Positions!(4, PickedHour%%, 0, 4) - XM%) + (Positions!(4, PickedHour%%, 1, 4) - YM%) * (Positions!(4, PickedHour%%, 1, 4) - YM%)) < 40 THEN
                    IF NOT CanPutDown%% THEN RedValid%% = TRUE
                    Orient! = Orient1!
                ELSEIF SQR((Positions!(4, OldHour%%, 0, 4) - XM%) * (Positions!(4, OldHour%%, 0, 4) - XM%) + (Positions!(4, OldHour%%, 1, 4) - YM%) * (Positions!(4, OldHour%%, 1, 4) - YM%)) < 40 THEN
                    Orient! = Orient0!
                ELSE
                    Orient! = 0
                END IF
                IF CanPutDown%% THEN
                    CanPutDown%% = FALSE
                    PickedUp%% = FALSE
                    HangOn%% = TRUE
                    IF PickedHour%% = 12 THEN
                        Clock%%(PickedHour%%, 1, 0) = PickedCard%%
                        Clock%%(PickedHour%%, 1, 1) = TRUE
                    ELSE
                        Clock%%(PickedHour%%, 0, 0) = PickedCard%%
                        Clock%%(PickedHour%%, 0, 1) = TRUE
                    END IF
                    PickedCard%% = 0
                    IF Clock%%(12, 4, 1) AND Clock%%(12, 1, 0) <> 0 THEN 'Game Finished
                        IsComplete%% = TRUE
                        Control(NewGameBT).Disabled = FALSE
                        Control(NewGameBT).Hidden = FALSE
                        SetFocus NewGameBT
                        GotOut%% = TRUE
                        M%% = 0
                        WHILE M%% <= 11 AND GotOut%%
                            IF NOT Clock%%(M%%, 4, 1) THEN GotOut%% = FALSE
                            M%% = M%% + 1
                        WEND
                    END IF
                    IF NOT IsComplete%% THEN TurnOver%% = TRUE
                END IF
            END IF
        END IF
        __UI_DoEvents
    WEND
END SUB

SUB Shuffle (Pack%%()) 'Fisher Yates or Knuth shuffle
    FOR S%% = 51 TO 1 STEP -1
        R%% = INT(RND * S%%) '+ 1
        SWAP Pack%%(R%%), Pack%%(S%%)
    NEXT S%%
END SUB
