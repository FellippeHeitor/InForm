': Duck Shoot Game by Qwerkey 09/07/19
': Images and Sounds from: findsounds.com, freesfx.go.uk, paperpull.com, pngimg.com, clker.com
': This program uses
': InForm - GUI library for QB64 - Beta version 8
': Fellippe Heitor, 2016-2018 - fellippe@qb64.org - @fellippeheitor
': https://github.com/FellippeHeitor/InForm
'-----------------------------------------------------------

': Controls' IDs & Constants: ------------------------------------------------------
CONST XScreen% = 1240, YScreen% = 800, FrameRate% = 120
CONST HalfWidth% = 100, HalfHeight% = 91, BendRad% = 150, XWidth% = 275
CONST Spacing! = 51.19, BoltX% = 143, BoltY% = 95, AimStep! = 0.1, PosStep! = 0.5
CONST RForce! = 0.0005, BulletSpeed! = 5, BallRad%% = 2, ZTargetDist% = 200
CONST GoldX% = XScreen% / 2, GoldY% = YScreen% - BendRad% - 2 * HalfHeight% + BoltY%
CONST MaxDev% = 30, CanFire% = 2 * FrameRate%, FSight% = 5, NSight% = 15
CONST TRand! = 0.99972, AtNextLevel% = 4 * FrameRate%

DIM SHARED DuckShoot AS LONG
DIM SHARED OptionsFR AS LONG
DIM SHARED GameLevelFR AS LONG
DIM SHARED AudioFR AS LONG
DIM SHARED SetKeysFR AS LONG
DIM SHARED LeftHandKeysFR AS LONG
DIM SHARED RightHandKeysFR AS LONG
DIM SHARED SelectKeyFR AS LONG
DIM SHARED ExitBT AS LONG
DIM SHARED ResetBT AS LONG
DIM SHARED SetKeysBT AS LONG
DIM SHARED Level1RB AS LONG
DIM SHARED Level2RB AS LONG
DIM SHARED Level3RB AS LONG
DIM SHARED Level4RB AS LONG
DIM SHARED Level5RB AS LONG
DIM SHARED Level6RB AS LONG
DIM SHARED AudioOffRB AS LONG
DIM SHARED AudioOnRB AS LONG
DIM SHARED RestartLevelBT AS LONG
DIM SHARED SetLeftHandKeysRB AS LONG
DIM SHARED SetRightHandKeysRB AS LONG
DIM SHARED FarSightUpRB AS LONG
DIM SHARED FarSightLeftRB AS LONG
DIM SHARED FarSightRightRB AS LONG
DIM SHARED FarSightDownRB AS LONG
DIM SHARED NearSightUpRB AS LONG
DIM SHARED NearSightLeftRB AS LONG
DIM SHARED NearSightRightRB AS LONG
DIM SHARED NearSightDownRB AS LONG
DIM SHARED FireRB AS LONG
DIM SHARED SelectKeyDD AS LONG
DIM SHARED SelectKeyLB AS LONG
DIM SHARED DoneBT AS LONG
DIM SHARED SetBT AS LONG
DIM SHARED DefaultBT AS LONG
DIM SHARED AllTheFunoftheFair&, AtGameStart%%, GameLevel%%, ReachedLevel%%
DIM SHARED Target!(5, 2), KeyCode%(8), KeyCodeDef%(8), Parameters!(7, 16)
DIM SHARED Dux%%, DuckCount%, StartGame%%, NoShots%, Ready%%, QuackInit%%
DIM SHARED SideBarFlag%%, SideBarIn%%, AwardAnim%, Fired%%, Shrink%
DIM SHARED SpiralAngle!, KeysList$, XF!, YF!, XN!, YN!, XGun!, YGun!

': External modules: ---------------------------------------------------------------
'$INCLUDE:'../../InForm/InForm.bi'
'$INCLUDE:'Duck Shoot.frm'
'$INCLUDE:'../../InForm/xp.uitheme'
'$INCLUDE:'../../InForm/InForm.ui'

': Event procedures & Functions: ---------------------------------------------------

FUNCTION HardwareImage& (ImageName&)
    HardwareImage& = _COPYIMAGE(ImageName&, 33)
    _FREEIMAGE ImageName&
END FUNCTION

FUNCTION SelKey$ (I%%)
    SelKey$ = CHR$(KeyCode%(I%%))
END FUNCTION

SUB __UI_BeforeInit
    $EXEICON:'.\helloducky.ico'
    AtGameStart%% = TRUE
    StartGame%% = TRUE
    SideBarIn%% = TRUE
    KeysList$ = "abcdefghijklmnopqrstuvwxyz#',./;[\]"
    'Parameters!() Data Input
    RESTORE level_data
    FOR N%% = 1 TO 7
        FOR M%% = 0 TO 16
            READ Parameters!(N%%, M%%)
        NEXT M%%
    NEXT N%%
    FOR N%% = 1 TO 7
        FOR M%% = 9 TO 10
            Parameters!(N%%, M%%) = 2 * _PI / (Parameters!(N%%, M%%) * FrameRate%)
        NEXT M%%
        FOR M%% = 13 TO 14
            Parameters!(N%%, M%%) = 2 * _PI / (Parameters!(N%%, M%%) * FrameRate%)
        NEXT M%%
    NEXT N%%
    FOR N%% = 0 TO 8
        READ KeyCodeDef%(N%%)
    NEXT N%%
    'Initialise
    IF _FILEEXISTS("ducks.cfg") THEN
        OPEN "ducks.cfg" FOR INPUT AS #1
        FOR N%% = 0 TO 8
            INPUT #1, KeyCode%(N%%)
        NEXT N%%
        INPUT #1, ReachedLevel%%
        CLOSE #1
    ELSE
        CALL DefKeys
        ReachedLevel%% = 1
    END IF
    GameLevel%% = ReachedLevel%%
    IF ReachedLevel%% = 7 THEN
        SideBarFlag%% = TRUE
    ELSE
        SideBarFlag%% = FALSE
    END IF
    AllTheFunoftheFair& = _SNDOPEN("funfair.mp3")
    _SNDLOOP AllTheFunoftheFair&
    RANDOMIZE (TIMER)
    Target!(0, 0) = 2
    Target!(0, 1) = 2 * XWidth% - 20
    Target!(1, 0) = 2
    Target!(1, 1) = 2 * XWidth% - 20 - 2 * HalfWidth% - Spacing!
    Target!(2, 0) = 2
    Target!(2, 1) = 2 * XWidth% - 20 - 4 * HalfWidth% - 2 * Spacing!
    Target!(3, 0) = 1
    Target!(3, 1) = 0.64382
    Target!(4, 0) = 0
    Target!(4, 1) = 4.738
    Target!(5, 0) = 3
    Target!(5, 1) = 0.9617 + _PI / 2
    SpiralAngle! = 2.6
    AwardAnim% = 0

    level_data:
    'Set parameters (Level 7 data as dummy):
    ' Parameters!(GameLevel%%,14)
    '0 DuckSpeed!
    '1 BoltRad%
    '2 Lambda!
    '3 VDash!
    '4 VDoubleDash!
    '5 Gravity!
    '6 AimAlign!
    '7 XDevMax% / 8 XDevMin%
    '9 O0Max! / 10 O0Min!
    '11 YDevMax% / 12 YDevMin%
    '13 O1Max! / 14 O1Min!
    '15 Spiral spin rate
    '16 Required Shots
    DATA 0.25,30,1000000,0.02,0.002,0.02,0.01,50,5,60,100,30,5,60,100,0,10
    DATA 0.4,30,8500,0.02,0.003,0.03,0.02,60,5,50,100,35,5,50,100,0,20
    DATA 0.5,25,2800,0.025,0.004,0.04,0.03,80,10,40,80,40,10,40,80,0,20
    DATA 0.65,25,2170,0.03,0.006,0.06,0.06,100,15,30,70,50,10,30,70,0,20
    DATA 0.8,25,1450,0.04,0.01,0.08,0.075,120,20,25,60,60,20,20,60,0.005,25
    'Level 6 is LUDICROUS (& not part of normal game)
    'Level 7 (dummy) parameters same as Level 5
    DATA 1.25,22,910,0.05,0.01,0.1,0.1,140,30,20,45,90,30,20,45,0.008,30
    DATA 0.8,25,1450,0.04,0.008,0.08,0.075,120,20,25,60,60,20,20,60,0.005,25
    'Default Keys
    DATA 119,122,97,100,112,46,108,39,115
END SUB

SUB __UI_OnLoad
    _SCREENMOVE 50, 5
    Control(SetKeysFR).Left = GoldX% - 200
    Control(SetKeysFR).Top = 250
    Control(SelectKeyFR).Left = GoldX% + 30
    Control(SelectKeyFR).Top = 250
    Control(LeftHandKeysFR).Left = GoldX% - 200
    Control(LeftHandKeysFR).Top = 400
    Control(RightHandKeysFR).Left = GoldX% + 30
    Control(RightHandKeysFR).Top = 400
    CALL DispSetKeys((TRUE))
    CALL DispLHKeys((TRUE))
    CALL DispRHKeys((TRUE))
    Control(GameLevelFR).Disabled = TRUE
    CALL ButtonLock((TRUE))
    Control(AudioOnRB).Disabled = FALSE
    Control(AudioOffRB).Disabled = FALSE
    Control(ResetBT).Disabled = FALSE
    Caption(ResetBT) = "Start"
    SetFocus ResetBT
    CALL WriteList(0)
    SELECT CASE GameLevel%%
        CASE 1
            SetRadioButtonValue Level1RB
        CASE 2
            SetRadioButtonValue Level2RB
        CASE 3
            SetRadioButtonValue Level3RB
        CASE 4
            SetRadioButtonValue Level4RB
        CASE 5, 7
            SetRadioButtonValue Level5RB
    END SELECT
END SUB

SUB __UI_BeforeUpdateDisplay
    'This event occurs at approximately 30 frames per second.
    'You can change the update frequency by calling SetFrameRate DesiredRate%
    STATIC SideBar%, HereAgain%%, Curtains&, Spiral&, Numerals&(), XErr%%, Opto&, S1&, S2&
    STATIC Slug&, WonLevel&, ImReady&, DispLevel&, ShotsTot&, Success&, Award&, GoldenShot&
    STATIC Targ1&, Pigeon&, Quacker&
    IF NOT HereAgain%% THEN 'Load Images
        HereAgain%% = TRUE
        SideBar% = 1120
        XErr%% = -2
        DIM Numerals&(10)
        Opto& = _LOADIMAGE("OptionsFR.png", 33)
        TempImg& = _NEWIMAGE(2 * FSight% + 1, 2 * FSight% + 1, 32)
        _DEST TempImg&
        CIRCLE (FSight%, FSight%), FSight%, _RGB32(0, 150, 30)
        LINE (FSight% - 3, FSight%)-(FSight% + 3, FSight%), _RGB32(0, 150, 30)
        LINE (FSight%, FSight% - 3)-(FSight%, FSight% + 3), _RGB32(0, 150, 30)
        S1& = HardwareImage&(TempImg&)
        TempImg& = _NEWIMAGE(2 * NSight% + 1, 2 * NSight% + 1, 32)
        _DEST TempImg&
        CIRCLE (NSight%, NSight%), NSight%, _RGB32(0, 255, 0)
        LINE (NSight% - 5, NSight%)-(NSight% + 5, NSight%), _RGB32(0, 255, 0)
        LINE (NSight%, NSight% - 5)-(NSight%, NSight% + 5), _RGB32(0, 255, 0)
        S2& = HardwareImage&(TempImg&)
        TempImg& = _NEWIMAGE(2 * BallRad%% + 1, 2 * BallRad%% + 1, 32)
        _DEST TempImg&
        CIRCLE (BallRad%%, BallRad%%), BallRad%%, _RGB32(212, 175, 55)
        PAINT (BallRad%%, BallRad%%), _RGB32(212, 175, 55)
        Slug& = HardwareImage&(TempImg&)
        CurtainsTemp& = _LOADIMAGE("curtains.png", 32)
        TempImg& = _NEWIMAGE(XScreen%, YScreen%, 32)
        _DEST TempImg&
        COLOR _RGB32(0, 0, 255), _RGBA32(80, 80, 80, 0)
        CLS
        _PUTIMAGE , CurtainsTemp&
        Font& = _LOADFONT("cyberbit.ttf", 60, "bold")
        _FONT Font&
        _PRINTSTRING (GoldX% - 233, 14), "QB64 Duck Shoot"
        _FONT 16
        _FREEFONT Font&
        _FREEIMAGE CurtainsTemp&
        Curtains& = HardwareImage&(TempImg&)
        Spiral& = _LOADIMAGE("spiral.png", 33)
        TempImg& = _NEWIMAGE(320, 120, 32)
        _DEST TempImg&
        COLOR _RGB32(150, 150, 80), _RGB32(80, 80, 80)
        CLS
        LINE (0, 0)-(319, 119), , B
        LINE (1, 1)-(318, 118), , B
        LINE (2, 2)-(317, 117), , B
        Font& = _LOADFONT("cyberbit.ttf", 34, "bold")
        _FONT Font&
        _PRINTSTRING (38, 16), "Congratulations!"
        _PRINTSTRING (12, 68), "You Win This Level"
        _FONT 16
        _FREEFONT Font&
        WonLevel& = HardwareImage&(TempImg&)
        TempImg& = _NEWIMAGE(74, 30, 32)
        _DEST TempImg&
        COLOR _RGB32(150, 150, 80), _RGB32(80, 80, 80)
        CLS
        LINE (0, 0)-(73, 29), , B
        LINE (1, 1)-(72, 28), , B
        LINE (2, 2)-(71, 27), , B
        Font& = _LOADFONT("cyberbit.ttf", 20, "bold")
        _FONT Font&
        _PRINTSTRING (10, 4), "Ready"
        _FONT 16
        _FREEFONT Font&
        ImReady& = HardwareImage&(TempImg&)
        TempImg& = _NEWIMAGE(290, 122, 32)
        _DEST TempImg&
        COLOR _RGB32(150, 150, 80), _RGB32(80, 80, 80)
        CLS
        LINE (0, 0)-(289, 121), , B
        LINE (1, 1)-(288, 120), , B
        LINE (2, 2)-(287, 119), , B
        Font& = _LOADFONT("cyberbit.ttf", 40, "bold")
        _FONT Font&
        _PRINTSTRING (10, 14), "Game Level:"
        _FONT 16
        _FREEFONT Font&
        Font& = _LOADFONT("cyberbit.ttf", 30, "bold")
        _FONT Font&
        _PRINTSTRING (10, 70), "Shots Required:"
        _FONT 16
        _FREEFONT Font&
        DispLevel& = HardwareImage&(TempImg&)
        TempImg& = _NEWIMAGE(220, 160, 32)
        _DEST TempImg&
        COLOR _RGB32(150, 150, 80), _RGB32(80, 80, 80)
        CLS
        LINE (0, 0)-(219, 159), , B
        LINE (1, 1)-(218, 158), , B
        LINE (2, 2)-(217, 157), , B
        Font& = _LOADFONT("cyberbit.ttf", 40, "bold")
        _FONT Font&
        _PRINTSTRING (14, 10), "Number of"
        _PRINTSTRING (60, 56), "Shots"
        _FONT 16
        _FREEFONT Font&
        ShotsTot& = HardwareImage&(TempImg&)
        TempImg& = _NEWIMAGE(220, 160, 32)
        _DEST TempImg&
        COLOR _RGB32(150, 150, 80), _RGB32(80, 80, 80)
        CLS
        LINE (0, 0)-(219, 159), , B
        LINE (1, 1)-(218, 158), , B
        LINE (2, 2)-(217, 157), , B
        Font& = _LOADFONT("cyberbit.ttf", 40, "bold")
        _FONT Font&
        _PRINTSTRING (42, 10), "Success"
        _PRINTSTRING (68, 56), "Rate"
        _FONT 16
        _FREEFONT Font&
        Success& = HardwareImage&(TempImg&)
        FOR N%% = 0 TO 9
            TempImg& = _NEWIMAGE(34, 62, 32)
            _DEST TempImg&
            COLOR _RGB32(150, 150, 80), _RGB32(80, 80, 80)
            CLS
            F& = _LOADFONT("cyberbit.ttf", 50)
            _FONT F&
            _PRINTSTRING (4, 6), LTRIM$(STR$(N%%))
            _FONT 16
            _FREEFONT F&
            Numerals&(N%%) = HardwareImage&(TempImg&)
        NEXT N%%
        TempImg& = _NEWIMAGE(46, 62, 32)
        _DEST TempImg&
        COLOR _RGB32(150, 150, 80), _RGB32(80, 80, 80)
        CLS
        F& = _LOADFONT("cyberbit.ttf", 50)
        _FONT F&
        _PRINTSTRING (2, 6), "%"
        _FONT 16
        _FREEFONT F&
        Numerals&(10) = HardwareImage&(TempImg&)
        AwardTemp& = _LOADIMAGE("medalimg.png", 32)
        TempImg& = _NEWIMAGE(192, 192, 32)
        _DEST TempImg&
        COLOR _RGBA32(150, 150, 80, 90), _RGBA32(80, 80, 80, 0)
        CLS
        _PUTIMAGE , AwardTemp&
        _FREEIMAGE AwardTemp&
        F& = _LOADFONT("cyberbit.ttf", 26)
        _FONT F&
        _PRINTSTRING (74, 114), "QB"
        _PRINTSTRING (80, 140), "64"
        _FONT 16
        _FREEFONT F&
        Award& = HardwareImage&(TempImg&)
        TempImg& = _NEWIMAGE(220, 130, 32)
        _DEST TempImg&
        COLOR _RGB32(150, 150, 80), _RGB32(80, 80, 80)
        CLS
        LINE (0, 0)-(219, 129), , B
        LINE (1, 1)-(218, 128), , B
        LINE (2, 2)-(217, 127), , B
        Font& = _LOADFONT("cyberbit.ttf", 40, "bold")
        _FONT Font&
        _PRINTSTRING (58, 16), "Game"
        _PRINTSTRING (14, 68), "Completed"
        _FONT 16
        _FREEFONT Font&
        GoldenShot& = HardwareImage&(TempImg&)
        Targ1& = _LOADIMAGE("target.png", 32)
        Pigeon& = _LOADIMAGE("pigeon1.png", 32)
    END IF
    IF QuackInit%% THEN
        QuackInit%% = FALSE
        TempImg& = _NEWIMAGE(2 * HalfWidth% + 1, 2 * HalfHeight% + 1, 32)
        _DEST TempImg&
        _PUTIMAGE , Pigeon&
        _PUTIMAGE (BoltX% - Parameters!(GameLevel%%, 1), BoltY% - Parameters!(GameLevel%%, 1))-(BoltX% + Parameters!(GameLevel%%, 1), BoltY% + Parameters!(GameLevel%%, 1)), Targ1&
        Quacker& = HardwareImage&(TempImg&)
    END IF
    CALL Rotor(-720, -720, X1!, Y1!, SpiralAngle!)
    CALL Rotor(720, -720, X2!, Y2!, SpiralAngle!)
    CALL Rotor(-720, 720, X3!, Y3!, SpiralAngle!)
    CALL Rotor(720, 720, X4!, Y4!, SpiralAngle!)
    _MAPTRIANGLE (0, 0)-(1440, 0)-(0, 1440), Spiral& TO(X1! + GoldX%, Y1! + YScreen% / 2)-(X2! + GoldX%, Y2! + YScreen% / 2)-(X3! + GoldX%, Y3! + YScreen% / 2)
    _MAPTRIANGLE (1440, 1440)-(0, 1440)-(1440, 0), Spiral& TO(X4! + GoldX%, Y4! + YScreen% / 2)-(X3! + GoldX%, Y3! + YScreen% / 2)-(X2! + GoldX%, Y2! + YScreen% / 2)
    IF NOT AtGameStart%% THEN
        FOR N%% = 0 TO 5
            SELECT CASE Target!(N%%, 0)
                CASE 0
                    X1! = GoldX% - XWidth% - BendRad% - 2 * HalfHeight%
                    Y1! = YScreen% - 1
                    X2! = X1!
                    Y2! = CINT(YScreen% - 1 - Target!(N%%, 1))
                    X3! = GoldX% - XWidth% - BendRad%
                    Y3! = Y1!
                    X4! = X3!
                    Y4! = Y2!
                    _MAPTRIANGLE (2 * HalfWidth% - Target!(N%%, 1), 0)-(2 * HalfWidth%, 0)-(2 * HalfWidth% - Target!(N%%, 1), 2 * HalfHeight%), Quacker& TO(X1!, Y1!)-(X2!, Y2!)-(X3!, Y3!)
                    _MAPTRIANGLE (2 * HalfWidth%, 2 * HalfHeight%)-(2 * HalfWidth% - Target!(N%%, 1), 2 * HalfHeight%)-(2 * HalfWidth%, 0), Quacker& TO(X4!, Y4!)-(X3!, Y3!)-(X2!, Y2!)
                CASE 1
                    CALL Rotor(0, BendRad% + HalfHeight%, XCentre!, YCentre!, _PI / 2 - Target!(N%%, 1))
                    CALL Rotor(-HalfWidth%, HalfHeight%, X1!, Y1!, _PI / 2 - Target!(N%%, 1))
                    CALL Rotor(HalfWidth%, HalfHeight%, X2!, Y2!, _PI / 2 - Target!(N%%, 1))
                    CALL Rotor(-HalfWidth%, -HalfHeight%, X3!, Y3!, _PI / 2 - Target!(N%%, 1))
                    CALL Rotor(HalfWidth%, -HalfHeight%, X4!, Y4!, _PI / 2 - Target!(N%%, 1))
                    X1! = CINT(GoldX% - XWidth% + (X1! + XCentre!))
                    Y1! = CINT(YScreen% - (Y1! + YCentre!))
                    X2! = CINT(GoldX% - XWidth% + (X2! + XCentre!))
                    Y2! = CINT(YScreen% - (Y2! + YCentre!))
                    X3! = CINT(GoldX% - XWidth% + (X3! + XCentre!))
                    Y3! = CINT(YScreen% - (Y3! + YCentre!))
                    X4! = CINT(GoldX% - XWidth% + (X4! + XCentre!))
                    Y4! = CINT(YScreen% - (Y4! + YCentre!))
                    _MAPTRIANGLE (0, 0)-(2 * HalfWidth%, 0)-(0, 2 * HalfHeight%), Quacker& TO(X1!, Y1!)-(X2!, Y2!)-(X3!, Y3!)
                    _MAPTRIANGLE (2 * HalfWidth%, 2 * HalfHeight%)-(0, 2 * HalfHeight%)-(2 * HalfWidth%, 0), Quacker& TO(X4!, Y4!)-(X3!, Y3!)-(X2!, Y2!)
                CASE 2
                    SELECT CASE Target!(N%%, 2)
                        CASE 1
                            'fall over
                            _PUTIMAGE (CINT(GoldX% - XWidth% - HalfWidth% + Target!(N%%, 1)), YScreen% - BendRad% - Shrink%)-(CINT(GoldX% - XWidth% - HalfWidth% + Target!(N%%, 1) + 2 * HalfWidth%), YScreen% - BendRad%), Quacker&
                        CASE 0
                            _PUTIMAGE (CINT(GoldX% - XWidth% - HalfWidth% + Target!(N%%, 1)), YScreen% - BendRad% - 2 * HalfHeight%), Quacker&
                    END SELECT
                CASE 3
                    CALL Rotor(0, BendRad% + HalfHeight%, XCentre!, YCentre!, _PI / 2 - Target!(N%%, 1))
                    CALL Rotor(-HalfWidth%, HalfHeight%, X1!, Y1!, _PI / 2 - Target!(N%%, 1))
                    CALL Rotor(HalfWidth%, HalfHeight%, X2!, Y2!, _PI / 2 - Target!(N%%, 1))
                    CALL Rotor(-HalfWidth%, -HalfHeight%, X3!, Y3!, _PI / 2 - Target!(N%%, 1))
                    CALL Rotor(HalfWidth%, -HalfHeight%, X4!, Y4!, _PI / 2 - Target!(N%%, 1))
                    X1! = CINT(GoldX% + XWidth% + X1! + XCentre!)
                    Y1! = CINT(YScreen% - (Y1! + YCentre!))
                    X2! = CINT(GoldX% + XWidth% + X2! + XCentre!)
                    Y2! = CINT(YScreen% - (Y2! + YCentre!))
                    X3! = CINT(GoldX% + XWidth% + X3! + XCentre!)
                    Y3! = CINT(YScreen% - (Y3! + YCentre!))
                    X4! = CINT(GoldX% + XWidth% + X4! + XCentre!)
                    Y4! = CINT(YScreen% - (Y4! + YCentre!))
                    IF Target!(N%%, 2) = 0 THEN
                        _MAPTRIANGLE (0, 0)-(2 * HalfWidth%, 0)-(0, 2 * HalfHeight%), Quacker& TO(X1!, Y1!)-(X2!, Y2!)-(X3!, Y3!)
                        _MAPTRIANGLE (2 * HalfWidth%, 2 * HalfHeight%)-(0, 2 * HalfHeight%)-(2 * HalfWidth%, 0), Quacker& TO(X4!, Y4!)-(X3!, Y3!)-(X2!, Y2!)
                    END IF
                CASE ELSE
                    IF Target!(N%%, 2) = 0 THEN
                        X1! = GoldX% + XWidth% + BendRad% + 2 * HalfHeight%
                        Y1! = CINT(YScreen% - 1 - HalfWidth% + Target!(N%%, 1))
                        X2! = X1!
                        Y2! = YScreen% - 1
                        X3! = GoldX% + XWidth% + BendRad%
                        Y3! = Y1!
                        X4! = X3!
                        Y4! = Y2!
                        _MAPTRIANGLE (0, 0)-(HalfWidth% - Target!(N%%, 1), 0)-(0, 2 * HalfHeight%), Quacker& TO(X1!, Y1!)-(X2!, Y2!)-(X3!, Y3!)
                        _MAPTRIANGLE (HalfWidth% - Target!(N%%, 1), 2 * HalfHeight%)-(0, 2 * HalfHeight%)-(HalfWidth% - Target!(N%%, 1), 0), Quacker& TO(X4!, Y4!)-(X3!, Y3!)-(X2!, Y2!)
                    END IF
            END SELECT
        NEXT N%%
        IF GameLevel%% <= 6 THEN
            IF Ready%% THEN
                _PUTIMAGE (XF! - FSight%, YF! - FSight%), S1&
                _PUTIMAGE (XN! - NSight%, YN! - NSight%), S2&
                IF Fired%% THEN _PUTIMAGE (XGun! - BallRad%%, YGun! - BallRad%%), Slug&
                _PUTIMAGE (475, 95), DispLevel&
                _PUTIMAGE (722, 98), Numerals&(GameLevel%%)
                IF GameLevel%% <= 5 THEN 'Display number of shots required (Always >= 10 and <= 99)
                    Tens%% = (Parameters!(GameLevel%%, 16)) \ 10
                    Units%% = Parameters!(GameLevel%%, 16) MOD 10
                    _PUTIMAGE (722 - 28, 152), Numerals&(Tens%%)
                    _PUTIMAGE (722, 152), Numerals&(Units%%)
                END IF
                _PUTIMAGE (GoldX% - 260, 260), ShotsTot&
                IF NoShots% >= 100 THEN 'Display number of shots
                    NShift% = 0
                ELSEIF NoShots% >= 10 THEN
                    NShift% = 16
                ELSE
                    NShift% = 32
                END IF
                Hundreds%% = NoShots% \ 100
                Tens%% = (NoShots% - (NoShots% \ 100) * 100) \ 10
                Units%% = NoShots% MOD 10
                IF Hundreds%% > 0 THEN _PUTIMAGE (GoldX% - 198 - NShift%, 352), Numerals&(Hundreds%%)
                IF Tens%% OR Hundreds%% > 0 THEN _PUTIMAGE (GoldX% - 166 - NShift%, 352), Numerals&(Tens%%)
                _PUTIMAGE (GoldX% - 134 - NShift%, 352), Numerals&(Units%%)
                _PUTIMAGE (GoldX% + 40, 260), Success&
                IF NoShots% > 0 THEN 'Display percentage success
                    PerCent%% = CINT(100 * DuckCount% / NoShots%)
                    IF PerCent%% >= 100 THEN
                        NShift% = 0
                    ELSEIF PerCent%% >= 10 THEN
                        NShift% = 16
                    ELSE
                        NShift% = 32
                    END IF
                    Hundreds%% = PerCent%% \ 100
                    Tens%% = (PerCent%% - (PerCent%% \ 100) * 100) \ 10
                    Units%% = PerCent%% MOD 10
                    IF Hundreds%% > 0 THEN _PUTIMAGE (GoldX% + 78 - NShift%, 352), Numerals&(Hundreds%%)
                    IF Tens%% > 0 OR Hundreds%% > 0 THEN _PUTIMAGE (GoldX% + 110 - NShift%, 352), Numerals&(Tens%%)
                    _PUTIMAGE (GoldX% + 142 - NShift%, 352), Numerals&(Units%%)
                    _PUTIMAGE (GoldX% + 170 - NShift%, 352), Numerals&(10)
                END IF
                _PUTIMAGE (GoldX% - 37, YScreen% - 50), ImReady&
            ELSE
                _PUTIMAGE (GoldX% - 160, 180), WonLevel&
            END IF
        ELSE
            _PUTIMAGE (GoldX% - 96, CINT(AwardAnim% / 4) + 66 - 192), Award&
            IF AwardAnim% = 4 * 192 THEN _PUTIMAGE (GoldX% - 110, 280), GoldenShot&
        END IF
    END IF
    _PUTIMAGE , Curtains&
    XMouse% = __UI_MouseLeft: YMouse% = __UI_MouseTop
    IF SideBar% < XScreen% THEN _PUTIMAGE (SideBar% + XErr%%, 336), Opto& 'Display sidebar
    IF AtGameStart%% THEN
        'Do nothing
    ELSEIF XMouse% > 1120 AND YMouse% > 340 THEN
        IF SideBar% > 1120 THEN
            SideBar% = SideBar% - 5
            Control(GameLevelFR).Left = Control(GameLevelFR).Left - 5
            Control(AudioFR).Left = Control(AudioFR).Left - 5
            Control(OptionsFR).Left = Control(OptionsFR).Left - 5
            IF SideBar% = 1120 THEN
                SideBarIn%% = TRUE
                Control(GameLevelFR).Disabled = FALSE
                Control(AudioFR).Disabled = FALSE
                Control(OptionsFR).Disabled = FALSE
                Control(ExitBT).Disabled = FALSE
                Control(AudioOnRB).Disabled = FALSE
                Control(AudioOffRB).Disabled = FALSE
                IF NOT SideBarFlag%% THEN CALL ButtonLock((FALSE))
            END IF
        END IF
    ELSE
        IF SideBar% < XScreen% THEN
            IF SideBar% = 1120 THEN
                SideBarIn%% = FALSE
                Control(GameLevelFR).Disabled = TRUE
                Control(AudioFR).Disabled = TRUE
                Control(OptionsFR).Disabled = TRUE
                Control(ExitBT).Disabled = TRUE
                Control(AudioOnRB).Disabled = TRUE
                Control(AudioOffRB).Disabled = TRUE
                CALL ButtonLock((TRUE))
            END IF
            SideBar% = SideBar% + 5
            Control(GameLevelFR).Left = Control(GameLevelFR).Left + 5
            Control(AudioFR).Left = Control(AudioFR).Left + 5
            Control(OptionsFR).Left = Control(OptionsFR).Left + 5
        END IF
    END IF
END SUB

SUB __UI_Click (id AS LONG)
    STATIC HaveSet%%
    SELECT CASE id
        CASE DuckShoot

        CASE OptionsFR

        CASE GameLevelFR

        CASE AudioFR

        CASE SetKeysFR

        CASE LeftHandKeysFR

        CASE RightHandKeysFR

        CASE SelectKeyFR

        CASE SelectKeyDD

        CASE SelectKeyLB

        CASE ExitBT
            IF AtGameStart%% THEN
                IF HaveSet%% THEN CALL WeAreDone
                SYSTEM
            ELSE
                Dux%% = FALSE
                StartGame%% = FALSE
            END IF
        CASE ResetBT
            IF AtGameStart%% THEN
                AtGameStart%% = FALSE
                Caption(ResetBT) = "Reset"
                Control(GameLevelFR).Disabled = FALSE
                Control(AudioFR).Disabled = FALSE
                Control(AudioOnRB).Disabled = FALSE
                Control(AudioOffRB).Disabled = FALSE
                Control(SetKeysBT).Disabled = TRUE
                CALL ButtonLock((FALSE))
                Ready%% = TRUE
                CALL MadameZora
            ELSE
                'Reset to level 1 & reset parameters
                Dux%% = FALSE
                ReachedLevel%% = 1
                GameLevel%% = ReachedLevel%%
                Control(Level6RB).Disabled = TRUE
                SetRadioButtonValue Level1RB
            END IF
        CASE RestartLevelBT
            NoShots% = 0
            DuckCount% = 0
            FOR N%% = 0 TO 5
                Target!(N%%, 2) = 0
            NEXT N%%
        CASE Level1RB
            IF GameLevel%% <> 1 THEN
                GameLevel%% = 1
                Dux%% = FALSE
            END IF
        CASE Level2RB
            IF GameLevel%% <> 2 THEN
                GameLevel%% = 2
                Dux%% = FALSE
            END IF
        CASE Level3RB
            IF GameLevel%% <> 3 THEN
                GameLevel%% = 3
                Dux%% = FALSE
            END IF
        CASE Level4RB
            IF GameLevel%% <> 4 THEN
                GameLevel%% = 4
                Dux%% = FALSE
            END IF
        CASE Level5RB
            IF GameLevel%% <> 5 THEN
                GameLevel%% = 5
                Dux%% = FALSE
            END IF
        CASE Level6RB
            IF GameLevel%% <> 6 THEN
                GameLevel%% = 6
                Dux%% = FALSE
            END IF
        CASE AudioOffRB
            _SNDSTOP AllTheFunoftheFair&
        CASE AudioOnRB
            _SNDLOOP AllTheFunoftheFair&
        CASE SetKeysBT
            Control(ResetBT).Disabled = TRUE
            Control(SetKeysBT).Disabled = TRUE
            CALL DispSetKeys((FALSE))
            CALL DispLHKeys((FALSE))
            CALL DispRHKeys((TRUE))
        CASE DoneBT
            CALL DispSetKeys((TRUE))
            CALL DispLHKeys((TRUE))
            CALL DispRHKeys((TRUE))
            Control(ResetBT).Disabled = FALSE
            Control(SetKeysBT).Disabled = FALSE
            SetFocus ResetBT
        CASE SetLeftHandKeysRB
            CALL DispLHKeys((FALSE))
            CALL DispRHKeys((TRUE))
            SetRadioButtonValue NearSightUpRB
            CALL KeyList(0)
        CASE SetRightHandKeysRB
            CALL DispLHKeys((TRUE))
            CALL DispRHKeys((FALSE))
            SetRadioButtonValue FarSightUpRB
            CALL KeyList(4)
        CASE NearSightUpRB
            CALL KeyList(0)
        CASE NearSightLeftRB
            CALL KeyList(2)
        CASE NearSightRightRB
            CALL KeyList(3)
        CASE NearSightDownRB
            CALL KeyList(1)
        CASE FireRB
            CALL KeyList(8)
        CASE FarSightUpRB
            CALL KeyList(4)
        CASE FarSightLeftRB
            CALL KeyList(6)
        CASE FarSightRightRB
            CALL KeyList(7)
        CASE FarSightDownRB
            CALL KeyList(5)
        CASE SetBT
            TheItem%% = Control(SelectKeyDD).Value
            IF TheItem%% > 0 THEN
                HaveSet%% = TRUE
                IF Control(SetLeftHandKeysRB).Value THEN
                    IF Control(NearSightUpRB).Value THEN
                        KeyCode%(0) = ASC(GetItem$(SelectKeyDD, TheItem%%))
                    ELSEIF Control(NearSightLeftRB).Value THEN
                        KeyCode%(2) = ASC(GetItem$(SelectKeyDD, TheItem%%))
                    ELSEIF Control(NearSightRightRB).Value THEN
                        KeyCode%(3) = ASC(GetItem$(SelectKeyDD, TheItem%%))
                    ELSEIF Control(NearSightDownRB).Value THEN
                        KeyCode%(1) = ASC(GetItem$(SelectKeyDD, TheItem%%))
                    ELSE
                        KeyCode%(8) = ASC(GetItem$(SelectKeyDD, TheItem%%))
                    END IF
                ELSE
                    IF Control(FarSightUpRB).Value THEN
                        KeyCode%(4) = ASC(GetItem$(SelectKeyDD, TheItem%%))
                    ELSEIF Control(FarSightLeftRB).Value THEN
                        KeyCode%(6) = ASC(GetItem$(SelectKeyDD, TheItem%%))
                    ELSEIF Control(FarSightRightRB).Value THEN
                        KeyCode%(7) = ASC(GetItem$(SelectKeyDD, TheItem%%))
                    ELSE
                        KeyCode%(5) = ASC(GetItem$(SelectKeyDD, TheItem%%))
                    END IF
                END IF
            END IF
        CASE DefaultBT
            CALL DefKeys
    END SELECT
END SUB

SUB __UI_BeforeUnload
    'If you set __UI_UnloadSignal = False here you can
    'cancel the user's request to close.
END SUB

SUB __UI_MouseEnter (id AS LONG)
END SUB

SUB __UI_MouseLeave (id AS LONG)
END SUB

SUB __UI_FocusIn (id AS LONG)
END SUB

SUB __UI_FocusOut (id AS LONG)
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

SUB ButtonLock (OnOff%%)
    Control(ResetBT).Disabled = OnOff%%
    Control(RestartLevelBT).Disabled = OnOff%%
    Control(AudioOnRB).Disabled = OnOff%%
    Control(AudioOffRB).Disabled = OnOff%%
    Control(Level1RB).Disabled = OnOff%%
    Control(Level2RB).Disabled = OnOff%%
    Control(Level3RB).Disabled = OnOff%%
    Control(Level4RB).Disabled = OnOff%%
    Control(Level5RB).Disabled = OnOff%%
    IF OnOff%% THEN
        Control(Level6RB).Disabled = TRUE
    ELSEIF GameLevel%% = 6 OR GameLevel%% = 7 THEN
        Control(Level6RB).Disabled = FALSE
    END IF
END SUB

SUB DispSetKeys (OnOff%%)
    Control(SetKeysFR).Disabled = OnOff%%
    Control(SetLeftHandKeysRB).Disabled = OnOff%%
    Control(SetRightHandKeysRB).Disabled = OnOff%%
    Control(DoneBT).Disabled = OnOff%%
    Control(SelectKeyFR).Disabled = OnOff%%
    Control(SelectKeyDD).Disabled = OnOff%%
    Control(SelectKeyLB).Disabled = OnOff%%
    Control(SetBT).Disabled = OnOff%%
    Control(SetKeysFR).Hidden = OnOff%%
    Control(SetLeftHandKeysRB).Hidden = OnOff%%
    Control(SetRightHandKeysRB).Hidden = OnOff%%
    Control(DoneBT).Hidden = OnOff%%
    Control(SelectKeyFR).Hidden = OnOff%%
    Control(SelectKeyDD).Hidden = OnOff%%
    Control(SelectKeyLB).Hidden = OnOff%%
    Control(SetBT).Hidden = OnOff%%
END SUB

SUB DispLHKeys (OnOff%%)
    IF NOT OnOff%% THEN
        Control(RightHandKeysFR).Left = GoldX% + 30
        Control(LeftHandKeysFR).Left = GoldX% - 200
    ELSE
        Control(LeftHandKeysFR).Left = GoldX% - 400
        Control(RightHandKeysFR).Left = GoldX% - 200
    END IF
    Control(LeftHandKeysFR).Disabled = OnOff%%
    Control(NearSightUpRB).Disabled = OnOff%%
    Control(NearSightLeftRB).Disabled = OnOff%%
    Control(NearSightRightRB).Disabled = OnOff%%
    Control(NearSightDownRB).Disabled = OnOff%%
    Control(FireRB).Disabled = OnOff%%
    Control(LeftHandKeysFR).Hidden = OnOff%%
    Control(NearSightUpRB).Hidden = OnOff%%
    Control(NearSightLeftRB).Hidden = OnOff%%
    Control(NearSightRightRB).Hidden = OnOff%%
    Control(NearSightDownRB).Hidden = OnOff%%
    Control(FireRB).Hidden = OnOff%%
END SUB

SUB DispRHKeys (OnOff%%)
    Control(RightHandKeysFR).Disabled = OnOff%%
    Control(FarSightUpRB).Disabled = OnOff%%
    Control(FarSightLeftRB).Disabled = OnOff%%
    Control(FarSightRightRB).Disabled = OnOff%%
    Control(FarSightDownRB).Disabled = OnOff%%
    Control(RightHandKeysFR).Hidden = OnOff%%
    Control(FarSightUpRB).Hidden = OnOff%%
    Control(FarSightLeftRB).Hidden = OnOff%%
    Control(FarSightRightRB).Hidden = OnOff%%
    Control(FarSightDownRB).Hidden = OnOff%%
END SUB

SUB KeyList (I%%)
    CALL WriteList(I%%)
    Caption(SelectKeyLB) = "Select Key (Currently " + SelKey$(I%%) + "):"
END SUB

SUB WriteList (Ix%%)
    ResetList SelectKeyDD
    FOR N%% = 1 TO LEN(KeysList$)
        IF MID$(KeysList$, N%%, 1) <> SelKey$(Ix%%) THEN AddItem SelectKeyDD, MID$(KeysList$, N%%, 1)
    NEXT N%%
END SUB

SUB DefKeys
    FOR N%% = 0 TO 8
        KeyCode%(N%%) = KeyCodeDef%(N%%)
    NEXT N%%
END SUB

SUB MadameZora
    WHILE StartGame%%
        CALL InitParams(X0Step!, Y0Step!, O0Step!, O1Step!, Omega!, X0!, Omega0!, Y0!, Omega1!)
        XN! = GoldX% + 2 * Parameters!(GameLevel%%, 7) * (RND - 0.5)
        YN! = GoldY% + 2 * Parameters!(GameLevel%%, 11) * (RND - 0.5)
        VYN! = Parameters!(GameLevel%%, 3) * RND 'Always a tendency to drop
        Alpha! = 2 * _PI * (RND - 0.5)
        RFD! = MaxDev% * RND
        XFD! = RFD! * COS(Alpha!)
        YFD! = RFD! * SIN(Alpha!)
        VXF! = Parameters!(GameLevel%%, 4) * (RND - 0.5)
        VYF! = Parameters!(GameLevel%%, 4) * RND 'Always a tendency to drop
        XF! = XN! + XFD!
        YF! = YN! + YFD!
        XFprev! = XF!
        YFprev! = YF!
        Count0% = 0
        Count1% = 0
        XNDev! = X0! * SIN(Omega0! * Count0%)
        YNDev! = Y0! * SIN(Omega1! * Count1%)
        XNprev! = XNDev!
        YNprev! = YNDev!
        FireCount% = CanFire%
        Fired%% = FALSE
        NoShots% = 0
        DuckCount% = 0
        WhatLevel% = AtNextLevel%
        Dux%% = TRUE
        WHILE Dux%%
            _LIMIT FrameRate%
            IF Parameters!(GameLevel%%, 15) > 0 THEN 'Rotate Spiral
                SpiralAngle! = SpiralAngle! + Parameters!(GameLevel%%, 15)
                IF SpiralAngle! > _PI THEN SpiralAngle! = SpiralAngle! - 2 * _PI
            END IF
            FOR N%% = 0 TO 5 'Calculate target parameters
                SELECT CASE Target!(N%%, 0)
                    CASE 0
                        Target!(N%%, 1) = Target!(N%%, 1) + Parameters!(GameLevel%%, 0)
                        IF Target!(N%%, 1) >= HalfWidth% THEN
                            Target!(N%%, 0) = 1
                            Target!(N%%, 1) = 0
                        END IF
                    CASE 1
                        Target!(N%%, 1) = Target!(N%%, 1) + Omega!
                        IF Target!(N%%, 1) >= _PI / 2 THEN
                            Target!(N%%, 0) = 2
                            Target!(N%%, 1) = 0
                            IF N%% = 0 THEN 'This constantly and imperceptively re-adjusts spacings to set value
                                Target!(5, 1) = 2 * HalfWidth% + Spacing!
                            ELSE
                                Target!(N%% - 1, 1) = 2 * HalfWidth% + Spacing!
                            END IF
                        END IF
                    CASE 2
                        IF Target!(N%%, 2) = 1 THEN
                            'fall over
                            Shrink% = Shrink% - 2.5
                            IF Shrink% <= 2 THEN Target!(N%%, 2) = 2
                        END IF
                        Target!(N%%, 1) = Target!(N%%, 1) + Parameters!(GameLevel%%, 0)
                        IF Target!(N%%, 1) >= 2 * XWidth% THEN
                            Target!(N%%, 0) = 3
                            Target!(N%%, 1) = _PI / 2
                        END IF
                    CASE 3
                        Target!(N%%, 1) = Target!(N%%, 1) + Omega!
                        IF Target!(N%%, 1) >= _PI THEN
                            Target!(N%%, 0) = 4
                            Target!(N%%, 1) = 0
                        END IF
                    CASE ELSE
                        Target!(N%%, 1) = Target!(N%%, 1) + Parameters!(GameLevel%%, 0)
                        IF Target!(N%%, 1) >= HalfWidth% THEN
                            Target!(N%%, 0) = 0
                            Target!(N%%, 1) = 0
                            Target!(N%%, 2) = 0
                            IF N%% = 5 THEN
                                RANDOMIZE (TIMER)
                                VYN! = Parameters!(GameLevel%%, 3) * RND
                                VXF! = Parameters!(GameLevel%%, 4) * (RND - 0.5)
                                VYF! = Parameters!(GameLevel%%, 4) * RND
                            END IF
                        END IF
                END SELECT
            NEXT N%%
            __UI_DoEvents
            IF GameLevel%% <= 6 THEN 'Calculate Rifle Parameters
                Count0% = Count0% + 1
                IF Omega0! * Count0% > _PI THEN Count0% = CINT(-_PI / Omega0!)
                Count1% = Count1% + 1
                IF Omega1! * Count1% > _PI THEN Count1% = CINT(-_PI / Omega1!)
                XF! = XN! + XFD!
                YF! = YN! + YFD!
                XFDelta! = XF! - XFprev!
                YFDelta! = YF! - YFprev!
                XFprev! = XF!
                YFprev! = YF!
                XN! = XN! + RForce! * (GoldX% - XN!) + XNDelta! 'VXN! is zero
                YN! = YN! + RForce! * (GoldY% - YN!) + VYN! + YNDelta!
                XFD! = XFD! + VXF!
                YFD! = YFD! + VYF!
                XNDev! = X0! * SIN(Omega0! * Count0%)
                XNDelta! = XNDev! - XNprev!
                XNprev! = XNDev!
                IF XUp%% THEN
                    X0! = X0! + X0Step!
                    IF RND > TRand! OR X0! > Parameters!(GameLevel%%, 7) THEN XUp%% = FALSE
                ELSE
                    X0! = X0! - X0Step!
                    IF RND > TRand! OR X0! < Parameters!(GameLevel%%, 8) THEN XUp%% = TRUE
                END IF
                IF O0Up%% THEN
                    Omega0! = Omega0! + O0Step!
                    IF RND > TRand! OR Omega0! > Parameters!(GameLevel%%, 9) THEN O0Up%% = FALSE
                ELSE
                    Omega0! = Omega0! - O0Step!
                    IF RND > TRand! OR Omega0! < Parameters!(GameLevel%%, 10) THEN O0Up%% = TRUE
                END IF
                YNDev! = Y0! * SIN(Omega1! * Count1%)
                YNDelta! = YNDev! - YNprev!
                YNprev! = YNDev!
                IF YUp%% THEN
                    Y0! = Y0! + Y0Step!
                    IF RND > TRand! OR Y0! > Parameters!(GameLevel%%, 11) THEN YUp%% = FALSE
                ELSE
                    Y0! = Y0! - Y0Step!
                    IF RND > TRand! OR Y0! < Parameters!(GameLevel%%, 12) THEN YUp%% = TRUE
                END IF
                IF O1Up%% THEN
                    Omega1! = Omega1! + O1Step!
                    IF RND > TRand! OR Omega1! > Parameters!(GameLevel%%, 13) THEN O1Up%% = FALSE
                ELSE
                    Omega1! = Omega1! - O1Step!
                    IF RND > TRand! OR Omega1! < Parameters!(GameLevel%%, 14) THEN O1Up%% = TRUE
                END IF
            ELSE
                IF AwardAnim% = 0 THEN _SNDPLAYFILE "fanfare.mp3"
                IF AwardAnim% < 4 * 192 THEN
                    AwardAnim% = AwardAnim% + 1
                ELSEIF SideBarFlag%% THEN
                    IF SideBarIn%% THEN CALL ButtonLock((FALSE))
                    SideBarFlag%% = FALSE
                END IF
            END IF
            IF _KEYDOWN(27) THEN
                Dux%% = FALSE
                StartGame%% = FALSE
            ELSEIF GameLevel%% <= 6 AND Ready%% THEN
                IF _KEYDOWN(KeyCode%(0)) THEN YN! = YN! - PosStep! 'Up (Default w)
                IF _KEYDOWN(KeyCode%(1)) THEN YN! = YN! + PosStep! 'Down (Default z)
                IF _KEYDOWN(KeyCode%(2)) THEN XN! = XN! - PosStep! 'Left (Default a)
                IF _KEYDOWN(KeyCode%(3)) THEN XN! = XN! + PosStep! 'Right (Default d)
                IF _KEYDOWN(KeyCode%(4)) THEN YFD! = YFD! - AimStep! 'Aim Up (Default p)
                IF _KEYDOWN(KeyCode%(5)) THEN YFD! = YFD! + AimStep! 'Aim Down (Default .)
                IF _KEYDOWN(KeyCode%(6)) THEN XFD! = XFD! - AimStep! 'Aim Left (Default l)
                IF _KEYDOWN(KeyCode%(7)) THEN XFD! = XFD! + AimStep! 'Aim Right (Default ')
                IF _KEYDOWN(KeyCode%(8)) AND FireCount% = CanFire% THEN 'Fire (Default s)
                    _SNDPLAYFILE "22handgun.mp3"
                    FireCount% = 0
                    Fired%% = TRUE
                    ZGun! = 0
                    XGun! = XF!
                    YGun! = YF!
                    IF NoShots% < 999 THEN NoShots% = NoShots% + 1 'Will Not Display > 999 shots
                    Hundreds%% = NoShots% \ 100
                    Tens%% = (NoShots% - (NoShots% \ 100) * 100) \ 10
                    Units%% = NoShots% MOD 10
                    AimDevX! = XN! - XF!
                    AimDevY! = YN! - YF!
                END IF
            END IF
            IF GameLevel%% <= 6 THEN
                IF XN! - GoldX% > Parameters!(GameLevel%%, 7) THEN
                    XN! = GoldX% + Parameters!(GameLevel%%, 7)
                ELSEIF XN! - GoldX% < -Parameters!(GameLevel%%, 7) THEN
                    XN! = GoldX% - Parameters!(GameLevel%%, 7)
                END IF
                IF YN! - GoldY% > Parameters!(GameLevel%%, 11) THEN
                    YN! = GoldY% + Parameters!(GameLevel%%, 11)
                ELSEIF YN! - GoldY% < -Parameters!(GameLevel%%, 11) THEN
                    YN! = GoldY% - Parameters!(GameLevel%%, 11)
                END IF
                RFD! = SQR(XFD! * XFD! + YFD! * YFD!)
                Alpha! = _ATAN2(YFD!, XFD!)
                IF RFD! > MaxDev% THEN 'Tends to move towards set direction
                    YFD! = MaxDev% * SIN(Alpha!)
                    XFD! = MaxDev% * COS(Alpha!)
                END IF
                IF FireCount% < CanFire% THEN FireCount% = FireCount% + 1
                IF Fired%% THEN
                    ZGun! = ZGun! - BulletSpeed!
                    XGun! = XGun! + XFDelta! + Parameters!(GameLevel%%, 6) * AimDevX! * (ZGun! / ZTargetDist%)
                    YGun! = YGun! + YFDelta! + Parameters!(GameLevel%%, 6) * AimDevY! * (ZGun! / ZTargetDist%) + Parameters!(GameLevel%%, 5)
                    IF ZGun! < -ZTargetDist% THEN 'Only if going along
                        IF XGun! > GoldX% - XWidth% + 73 AND XGun! < GoldX% + XWidth% - 73 THEN
                            N%% = 0
                            WHILE N%% <= 5
                                XB! = GoldX% - XWidth% - HalfWidth% + Target!(N%%, 1) + BoltX% - XGun!
                                YB! = YScreen% - BendRad% - 2 * HalfHeight% + BoltY% - YGun!
                                RB! = XB! * XB! + YB! * YB!
                                IF RB! <= Parameters!(GameLevel%%, 1) * Parameters!(GameLevel%%, 1) AND Target!(N%%, 2) = 0 THEN
                                    P! = EXP(-RB! / Parameters!(GameLevel%%, 2))
                                    IF RND < P! THEN
                                        _SNDPLAYFILE "fallover1.mp3"
                                        Shrink% = 2 * HalfHeight%
                                        Target!(N%%, 2) = 1 '0 not hit, 1 hit (falling), 2 hit (fallen)
                                        DuckCount% = DuckCount% + 1
                                        IF NoShots% >= Parameters!(GameLevel%%, 16) AND (DuckCount% / NoShots%) >= 0.9 AND GameLevel%% = ReachedLevel%% THEN
                                            NoShots% = 0
                                            DuckCount% = 0
                                            WhatLevel% = 0
                                            Ready%% = FALSE
                                            Control(AudioFR).Disabled = TRUE
                                            Control(GameLevelFR).Disabled = TRUE
                                            CALL ButtonLock((TRUE))
                                            SideBarFlag%% = TRUE
                                        END IF
                                        N%% = 6
                                    ELSE
                                        N%% = N%% + 1
                                    END IF
                                ELSE
                                    N%% = N%% + 1
                                END IF
                            WEND
                        END IF
                        Fired%% = FALSE
                    END IF
                END IF
                IF WhatLevel% < AtNextLevel% THEN
                    WhatLevel% = WhatLevel% + 1
                    IF WhatLevel% = FrameRate% THEN
                        _SNDPLAYFILE "tada.mp3"
                    ELSEIF WhatLevel% = AtNextLevel% THEN 'This will happen after target has fallen over
                        IF GameLevel%% <= 4 THEN
                            SELECT CASE GameLevel%%
                                CASE 1
                                    SetRadioButtonValue Level2RB
                                CASE 2
                                    SetRadioButtonValue Level3RB
                                CASE 3
                                    SetRadioButtonValue Level4RB
                                CASE ELSE
                                    SetRadioButtonValue Level5RB
                            END SELECT
                            ReachedLevel%% = ReachedLevel%% + 1
                        ELSE
                            ReachedLevel%% = 7
                            Control(Level6RB).Disabled = FALSE
                        END IF
                        GameLevel%% = ReachedLevel%%
                        CALL InitParams(X0Step!, Y0Step!, O0Step!, O1Step!, Omega!, X0!, Omega0!, Y0!, Omega1!)
                        Ready%% = TRUE
                        IF SideBarIn%% THEN CALL ButtonLock((FALSE))
                        SideBarFlag%% = FALSE
                    END IF
                END IF
            END IF
        WEND
    WEND
    _SNDCLOSE AllTheFunoftheFair&
    _FREEIMAGE Quacker&
    CALL WeAreDone
    SYSTEM
END SUB

SUB Rotor (XIn!, YIn!, XOut!, YOut!, Theta!)
    XOut! = XIn! * COS(Theta!) - YIn! * SIN(Theta!)
    YOut! = XIn! * SIN(Theta!) + YIn! * COS(Theta!)
END SUB

SUB InitParams (X00Step!, Y00Step!, O00Step!, O10Step!, Mega!, X00!, Omega00!, Y00!, Omega10!)
    QuackInit%% = TRUE
    X00Step! = (Parameters!(GameLevel%%, 7) - Parameters!(GameLevel%%, 8)) / (15 * FrameRate%)
    Y00Step! = (Parameters!(GameLevel%%, 11) - Parameters!(GameLevel%%, 12)) / (15 * FrameRate%)
    O00Step! = (Parameters!(GameLevel%%, 9) - Parameters!(GameLevel%%, 10)) / (30 * FrameRate%)
    O10Step! = (Parameters!(GameLevel%%, 13) - Parameters!(GameLevel%%, 14)) / (30 * FrameRate%)
    Mega! = Parameters!(GameLevel%%, 0) / (BendRad% + HalfHeight%)
    X00! = (Parameters!(GameLevel%%, 7) - Parameters!(GameLevel%%, 8)) * RND + Parameters!(GameLevel%%, 8)
    Omega00! = (Parameters!(GameLevel%%, 9) - Parameters!(GameLevel%%, 10)) * RND + Parameters!(GameLevel%%, 10)
    Y00! = (Parameters!(GameLevel%%, 11) - Parameters!(GameLevel%%, 12)) * RND + Parameters!(GameLevel%%, 12)
    Omega10! = (Parameters!(GameLevel%%, 13) - Parameters!(GameLevel%%, 14)) * RND + Parameters!(GameLevel%%, 14)
    FOR N%% = 0 TO 5
        Target!(N%%, 2) = 0
    NEXT N%%
END SUB

SUB WeAreDone
    OPEN "ducks.cfg" FOR OUTPUT AS #1
    FOR N%% = 0 TO 8
        PRINT #1, KeyCode%(N%%)
    NEXT N%%
    PRINT #1, ReachedLevel%%
    CLOSE #1
END SUB
