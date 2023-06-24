': Gravitational Simulation Program by Qwerkey 09/09/18 - updated 09/05/19, 04/04/20
': This program uses:
': InForm - GUI library for QB64 - Beta version 8
': Fellippe Heitor, 2016-2018 - fellippe@qb64.org - @fellippeheitor
': https://github.com/FellippeHeitor/InForm
'-----------------------------------------------------------

': This program calculates the Newtonian Gravitational forces between particles with initial data set by User
': Newtonian mechnanics is used to calculate all susbequent positions in time
': A persepective view is displayed of the paths of the particles
': It is assumed that all bodies are zero size (point paticles) indepenedent of body mass

': Controls' IDs: ------------------------------------------------------------------
DIM SHARED GravitationSimulation AS LONG
DIM SHARED SimulationTypeFR AS LONG
DIM SHARED HowManyBodiesFR AS LONG
DIM SHARED GravitationalCollapseFR AS LONG
DIM SHARED GravitationalConstantFR AS LONG
DIM SHARED BodyDataFR AS LONG
DIM SHARED StepTimeFR AS LONG
DIM SHARED CollisionsFR AS LONG
DIM SHARED CollisionDistanceFR AS LONG
DIM SHARED ViewingAngleFR AS LONG
DIM SHARED ZoomFR AS LONG
DIM SHARED SimulationLimitTypeFR AS LONG
DIM SHARED SimulationLimitTimeFR AS LONG
DIM SHARED SimulationLimitCyclesFR AS LONG
DIM SHARED ElapsedTimeFR AS LONG
DIM SHARED EnergyFR AS LONG
DIM SHARED PictureBox1 AS LONG
DIM SHARED ExitBT AS LONG
DIM SHARED PauseBT AS LONG
DIM SHARED ExecuteBT AS LONG
DIM SHARED SolarSystemRB AS LONG
DIM SHARED BodyManualRB AS LONG
DIM SHARED GravitationalCollapseRB AS LONG
DIM SHARED LoadFromFileRB AS LONG
DIM SHARED DemonstrationRB AS LONG
DIM SHARED GravitationalConstantLB AS LONG
DIM SHARED GravitationalConstantTB AS LONG
DIM SHARED HowManyBodiesLB AS LONG
DIM SHARED HowManyBodiesTB AS LONG
DIM SHARED BodyLB AS LONG
DIM SHARED MassLB AS LONG
DIM SHARED xPositionLB AS LONG
DIM SHARED yPositionLB AS LONG
DIM SHARED zPositionLB AS LONG
DIM SHARED xVelocityLB AS LONG
DIM SHARED yVelocityLB AS LONG
DIM SHARED zVelocityLB AS LONG
DIM SHARED Body1LB AS LONG
DIM SHARED BodyMass1TB AS LONG
DIM SHARED XPosition1TB AS LONG
DIM SHARED YPosition1TB AS LONG
DIM SHARED ZPosition1TB AS LONG
DIM SHARED XVelocity1TB AS LONG
DIM SHARED YVelocity1TB AS LONG
DIM SHARED ZVelocity1TB AS LONG
DIM SHARED Body2LB AS LONG
DIM SHARED BodyMass2TB AS LONG
DIM SHARED XPosition2TB AS LONG
DIM SHARED YPosition2TB AS LONG
DIM SHARED ZPosition2TB AS LONG
DIM SHARED XVelocity2TB AS LONG
DIM SHARED YVelocity2TB AS LONG
DIM SHARED ZVelocity2TB AS LONG
DIM SHARED Body3LB AS LONG
DIM SHARED BodyMass3TB AS LONG
DIM SHARED XPosition3TB AS LONG
DIM SHARED YPosition3TB AS LONG
DIM SHARED ZPosition3TB AS LONG
DIM SHARED XVelocity3TB AS LONG
DIM SHARED YVelocity3TB AS LONG
DIM SHARED ZVelocity3TB AS LONG
DIM SHARED Body4LB AS LONG
DIM SHARED BodyMass4TB AS LONG
DIM SHARED XPosition4TB AS LONG
DIM SHARED YPosition4TB AS LONG
DIM SHARED ZPosition4TB AS LONG
DIM SHARED XVelocity4TB AS LONG
DIM SHARED YVelocity4TB AS LONG
DIM SHARED ZVelocity4TB AS LONG
DIM SHARED Body5LB AS LONG
DIM SHARED BodyMass5TB AS LONG
DIM SHARED XPosition5TB AS LONG
DIM SHARED YPosition5TB AS LONG
DIM SHARED ZPosition5TB AS LONG
DIM SHARED XVelocity5TB AS LONG
DIM SHARED YVelocity5TB AS LONG
DIM SHARED ZVelocity5TB AS LONG
DIM SHARED Body6LB AS LONG
DIM SHARED BodyMass6TB AS LONG
DIM SHARED XPosition6TB AS LONG
DIM SHARED YPosition6TB AS LONG
DIM SHARED ZPosition6TB AS LONG
DIM SHARED XVelocity6TB AS LONG
DIM SHARED YVelocity6TB AS LONG
DIM SHARED ZVelocity6TB AS LONG
DIM SHARED Body7LB AS LONG
DIM SHARED BodyMass7TB AS LONG
DIM SHARED XPosition7TB AS LONG
DIM SHARED YPosition7TB AS LONG
DIM SHARED ZPosition7TB AS LONG
DIM SHARED XVelocity7TB AS LONG
DIM SHARED YVelocity7TB AS LONG
DIM SHARED ZVelocity7TB AS LONG
DIM SHARED Body8LB AS LONG
DIM SHARED BodyMass8TB AS LONG
DIM SHARED XPosition8TB AS LONG
DIM SHARED YPosition8TB AS LONG
DIM SHARED ZPosition8TB AS LONG
DIM SHARED XVelocity8TB AS LONG
DIM SHARED YVelocity8TB AS LONG
DIM SHARED ZVelocity8TB AS LONG
DIM SHARED Body9LB AS LONG
DIM SHARED BodyMass9TB AS LONG
DIM SHARED XPosition9TB AS LONG
DIM SHARED YPosition9TB AS LONG
DIM SHARED ZPosition9TB AS LONG
DIM SHARED XVelocity9TB AS LONG
DIM SHARED YVelocity9TB AS LONG
DIM SHARED ZVelocity9TB AS LONG
DIM SHARED Body10LB AS LONG
DIM SHARED BodyMass10TB AS LONG
DIM SHARED XPosition10TB AS LONG
DIM SHARED YPosition10TB AS LONG
DIM SHARED ZPosition10TB AS LONG
DIM SHARED XVelocity10TB AS LONG
DIM SHARED YVelocity10TB AS LONG
DIM SHARED ZVelocity10TB AS LONG
DIM SHARED Body11LB AS LONG
DIM SHARED BodyMass11TB AS LONG
DIM SHARED XPosition11TB AS LONG
DIM SHARED YPosition11TB AS LONG
DIM SHARED ZPosition11TB AS LONG
DIM SHARED XVelocity11TB AS LONG
DIM SHARED YVelocity11TB AS LONG
DIM SHARED ZVelocity11TB AS LONG
DIM SHARED NumberOfBodiesLB AS LONG
DIM SHARED NumberOfBodiesTB AS LONG
DIM SHARED MaximumMassLB AS LONG
DIM SHARED MaximumMassTB AS LONG
DIM SHARED MaximumDistanceLB AS LONG
DIM SHARED MaximumDistanceTB AS LONG
DIM SHARED MaximumSpeedLB AS LONG
DIM SHARED MaximumSpeedTB AS LONG
DIM SHARED StepTimeLB AS LONG
DIM SHARED StepTimeSecTB AS LONG
DIM SHARED CollisionDistanceLB AS LONG
DIM SHARED CollisionDistanceTB AS LONG
DIM SHARED AllowCollisionsCB AS LONG
DIM SHARED AllowComputertoSetCB AS LONG
DIM SHARED toSetValuesLB AS LONG
DIM SHARED ProgressBar1 AS LONG
DIM SHARED ViewingTrackBar AS LONG
DIM SHARED ZeroDegLB AS LONG
DIM SHARED Minus180LB AS LONG
DIM SHARED Plus180LB AS LONG
DIM SHARED TimeLimitRB AS LONG
DIM SHARED CyclesLimitRB AS LONG
DIM SHARED NumberofMinutesLB AS LONG
DIM SHARED NumberofMinutesTB AS LONG
DIM SHARED NumberofHoursLB AS LONG
DIM SHARED NumberofHoursTB AS LONG
DIM SHARED NumberofCyclesTB AS LONG
DIM SHARED NumberofCyclesLB AS LONG
DIM SHARED StepTimeMinTB AS LONG
DIM SHARED StepTimeHrTB AS LONG
DIM SHARED StepTimeHrLB AS LONG
DIM SHARED StepTimeMinsLB AS LONG
DIM SHARED StepTimeSecsLB AS LONG
DIM SHARED ElapsedTime1TB AS LONG
DIM SHARED ElapsedTime2TB AS LONG
DIM SHARED ElapsedTime1LB AS LONG
DIM SHARED ElapsedTime2LB AS LONG
DIM SHARED SolarSystemLB AS LONG
DIM SHARED ManualInputLB AS LONG
DIM SHARED GravitationalCollapseLB AS LONG
DIM SHARED LoadFromFileLB AS LONG
DIM SHARED ElapsedTimeLB AS LONG
DIM SHARED DemonstrationLB AS LONG
DIM SHARED ResetBT AS LONG
DIM SHARED EnergyLB AS LONG
DIM SHARED EnergyTB AS LONG
DIM SHARED DemoLabel1LB AS LONG
DIM SHARED TraceBT AS LONG
DIM SHARED ClearBT AS LONG
DIM SHARED DemoLabel2LB AS LONG
DIM SHARED ZoomInBT AS LONG
DIM SHARED ZoomOutBT AS LONG
DIM SHARED DoCalc%%, ViewingAngle!, Zoom!, CosAng!, SinAng!, Gravity!, Collided%%, Coalesce!, EFrameClick%%
DIM SHARED Deltav#(2), Deltad#(511, 2), Spectrum~&(511), Galaxy#(511, 9), NoBodiesLess1%
DIM SHARED Deltat&, StartCalc!, NoCycles&, TimeLimit!, CyclesLimit&, Pop&, StartEnergy!, ControlIndex&(101)
DIM SHARED TotSecs&, TotMins&, TotHrs&, TotDays&, TotYears&, Paused%%, Update%%
DIM SHARED PlanetAnim%%, Trace%%, Wipe%%, UpArrow%%, DownArrow%%, EndArrow%%, ArrowTop%, ArrowLeft%
CONST FrameRate% = 30, Persp& = -8000, Origin& = -16000, Uscreen% = 1400, Vscreen% = 830 'Uscreen%/Vscreen% same as PictureBox1

': External modules: ---------------------------------------------------------------
'$INCLUDE:'../../InForm/InForm.bi'
'$INCLUDE:'../../InForm/extensions/MessageBox.bi'
'$INCLUDE:'GravitationSimulation.frm'
'$INCLUDE:'democode.bas'

': Event Procedures & Functions: ----------------------------------------------------
FUNCTION RedGreenBlue~& ' Randomly set colour of body
    TooDim%% = True
    WHILE TooDim%%
        Red% = INT(256 * RND)
        Green% = INT(256 * RND)
        Blue% = INT(256 * RND)
        IF Red% + Green% + Blue% > 254 THEN
            RedGreenBlue~& = _RGB32(Red%, Green%, Blue%)
            TooDim%% = False
        END IF
    WEND
END FUNCTION

FUNCTION MakeText$ (Num!) 'Convert number to text
    MakeText$ = LTRIM$(STR$(Num!))
END FUNCTION

FUNCTION Minus1$ (Text$) 'Remove negative numbers or blank
    IF Text$ = "" OR VAL(Text$) <= 0 THEN
        Minus1$ = "0"
    ELSE
        Minus1$ = Text$
    END IF
END FUNCTION

FUNCTION Energy! 'Calculate Total Energy (Gravitational + Kinetic)
    Erg! = 0
    IF Galaxy#(0, 0) <> 0 THEN
        FOR I% = 0 TO NoBodiesLess1%
            Erg! = Erg! + (Galaxy#(I%, 0) * ((Galaxy#(I%, 4) * Galaxy#(I%, 4)) + (Galaxy#(I%, 5) * Galaxy#(I%, 5)) + (Galaxy#(I%, 6) * Galaxy#(I%, 6))) / 2.0E+32)
        NEXT I%
        FOR I% = 0 TO NoBodiesLess1%
            FOR J% = (I% + 1) TO NoBodiesLess1%
                Erg! = Erg! - (Galaxy#(I%, 0) * Galaxy#(J%, 0) * Gravity!) / (1.0E+32 * ((Galaxy#(J%, 1) - Galaxy#(I%, 1)) ^ 2 + (Galaxy#(J%, 2) - Galaxy#(I%, 2)) ^ 2 + (Galaxy#(J%, 3) - Galaxy#(I%, 3)) ^ 2) ^ 0.5)
            NEXT J%
        NEXT I%
    END IF
    Energy! = Erg!
END FUNCTION

FUNCTION DispEnery$ 'Calculate and display energy deviation from start energy
    P1! = (Energy! - StartEnergy!) / StartEnergy!
    P2! = ABS(100 * P1!)
    IF Energy! = 0 THEN
        D2$ = "0"
    ELSEIF P2! > 900 THEN
        D2$ = ">900%"
    ELSEIF P2! >= 100 THEN
        P3% = CINT(P2!)
        D2$ = "+" + MakeText$(P3%) + "%"
    ELSEIF P2! >= 10 THEN
        P3% = CINT(10 * P2!)
        P4! = P3% / 10
        IF P1! > 0 THEN
            D2$ = "+" + MakeText$(P4!) + "%"
        ELSE
            D2$ = "-" + MakeText$(P4!) + "%"
        END IF
    ELSEIF P2! >= 1 THEN
        P3% = CINT(100 * P2!)
        P4! = P3% / 100
        IF P1! > 0 THEN
            D2$ = "+" + MakeText$(P4!) + "%"
        ELSE
            D2$ = "-" + MakeText$(P4!) + "%"
        END IF
    ELSEIF P2! < 0.005 THEN
        D2$ = "+0%"
    ELSE
        P3% = CINT(1000 * P2!)
        P4! = P3% / 1000
        IF P1! > 0 THEN
            D2$ = "+" + MakeText$(P4!) + "%"
        ELSE
            D2$ = "-" + MakeText$(P4!) + "%"
        END IF
    END IF
    DispEnery$ = D2$
END FUNCTION

': InForm Subroutines: ---------------------------------------------------------------

SUB __UI_BeforeInit
    $EXEICON:'.\newton.ico' 'Can't be moved to DIM Shared start region
    DoCalc%% = False
    Paused%% = False
    Trace%% = True
    RANDOMIZE (TIMER)
    Pop& = _SNDOPEN("pop.mp3")
    NoBodiesLess1% = 11
    StartEnergy! = 1
    ViewingAngle! = -.1570787
END SUB

SUB __UI_OnLoad
    _SCREENMOVE 0, 0
    Control(GravitationalCollapseFR).Hidden = True
    Control(HowManyBodiesFR).Hidden = True
    Control(BodyDataFR).Hidden = True
    Control(CollisionsFR).Hidden = True
    Control(CollisionDistanceFR).Hidden = True
    Control(SimulationLimitCyclesFR).Hidden = True
    Control(ManualInputLB).Hidden = True
    Control(ManualInputLB).Top = 10
    Control(GravitationalCollapseLB).Hidden = True
    Control(GravitationalCollapseLB).Top = 10
    Control(LoadFromFileLB).Hidden = True
    Control(LoadFromFileLB).Top = 10
    Control(DemonstrationLB).Hidden = True
    Control(DemonstrationLB).Top = 10
    Control(DemoLabel1LB).Hidden = True
    Control(DemoLabel2LB).Hidden = True
    Control(ViewingTrackBar).Value = ViewingAngle! * 180 / _PI
    Control(ZoomInBT).Disabled = True
    Control(ZoomOutBT).Disabled = True
    SetFocus ExecuteBT
    SetFrameRate FrameRate%
    CALL SetCtrlIndex
END SUB

SUB __UI_BeforeUpdateDisplay
    'This event occurs at approximately 30 frames per second.
    'You can change the update frequency by calling SetFrameRate DesiredRate%
    STATIC FrameCount%, InitDone%%, ArrayReady%%, LocalArray!(), PlanetCount%, PlanetStop%, Planets&()
    IF NOT InitDone%% THEN
        InitDone%% = True
        PlanetStop% = FrameRate% * 4 '4s animation
        PlanetCount% = 0
        DIM LocalArray!(511, 1), Planets&(14)
        Planets&(0) = _LOADIMAGE("The Sun.png", 32)
        Planets&(1) = _LOADIMAGE("Mercury.png", 32)
        Planets&(2) = _LOADIMAGE("Venus.png", 32)
        Planets&(3) = _LOADIMAGE("The Earth.png", 32)
        Planets&(4) = _LOADIMAGE("Mars.png", 32)
        Planets&(5) = _LOADIMAGE("Jupiter.png", 32)
        Planets&(6) = _LOADIMAGE("Saturn.png", 32)
        Planets&(7) = _LOADIMAGE("Uranus.png", 32)
        Planets&(8) = _LOADIMAGE("Neptune.png", 32)
        Planets&(9) = _LOADIMAGE("Pluto.png", 32)
        Planets&(10) = _LOADIMAGE("The Moon.png", 32)
        Planets&(11) = _LOADIMAGE("satellite2.png", 32)
        Planets&(12) = _NEWIMAGE(100, 100, 32)
        _DEST Planets&(12)
        COLOR _RGB32(0, 0, 0), _RGB32(0, 0, 0)
        CLS
        Planets&(13) = _LOADIMAGE("UpArrow.png", 32)
        Planets&(14) = _LOADIMAGE("DownArrow.png", 32)
    END IF
    IF (FrameCount% MOD FrameRate% = 0 OR Collided%%) AND DoCalc%% AND NOT Paused%% THEN
        'Do once every 1s
        FOR N% = 0 TO NoBodiesLess1%
            LocalArray!(N%, 0) = N%
            LocalArray!(N%, 1) = Galaxy#(N%, 3)
        NEXT N%
        IF NoBodiesLess1% > 1 THEN
            Jump% = 1
            WHILE Jump% <= NoBodiesLess1%: Jump% = Jump% * 2: WEND
            WHILE Jump% > 1
                Jump% = (Jump% - 1) \ 2
                Finis%% = False
                WHILE NOT Finis%%
                    Finis%% = True
                    FOR Upper% = 0 TO NoBodiesLess1% - Jump%
                        Lower% = Upper% + Jump%
                        IF LocalArray!(Upper%, 1) > LocalArray!(Lower%, 1) THEN
                            SWAP LocalArray!(Upper%, 0), LocalArray!(Lower%, 0)
                            SWAP LocalArray!(Upper%, 1), LocalArray!(Lower%, 1)
                            Finis%% = False
                        END IF
                    NEXT Upper%
                WEND
            WEND
        ELSE
            IF LocalArray!(0, 1) > LocalArray!(1, 1) THEN
                SWAP LocalArray!(0, 0), LocalArray!(1, 0)
                SWAP LocalArray!(0, 1), LocalArray!(1, 1)
            END IF
        END IF
        ' Then element 0 has z- order & keep for display
        ArrayReady%% = True
        IF Collided%% THEN
            _SNDPLAY Pop&
            Collided%% = False
        END IF
        'Update data from displays
        IF Update%% THEN
            Gravity! = VAL(Text(GravitationalConstantTB))
            CALL SetStep
            Update%% = False
        END IF
        IF FrameCount% >= FrameRate% * 3 THEN
            'Every 3s - Energy, Centre of Mass, Elaspsed Time Display
            CALL UpdateDisp
            FrameCount% = 0
        END IF
    END IF
    FrameCount% = FrameCount% + 1
    'Only do this once LocalArray!() has been written to above
    IF ArrayReady%% AND DoCalc%% AND NOT Paused%% THEN
        IF StartCalc! > TIMER THEN StartCalc! = StartCalc! - 86400
        IF Control(TimeLimitRB).Value THEN
            Control(ProgressBar1).Value = 100 * (TIMER - StartCalc!) / TimeLimit!
        ELSE
            Control(ProgressBar1).Value = 100 * NoCycles& / CyclesLimit&
        END IF
        BeginDraw PictureBox1
        IF NOT Trace%% OR Wipe%% THEN
            CLS
            Wipe%% = False
        END IF
        FOR N% = 0 TO NoBodiesLess1%
            'Convert x-,y-,z- into u-,v- (in absence of _MAPTRIANGLE(3D)
            CALL ToDisp((Galaxy#(LocalArray!(N%, 0), 1)), (Galaxy#(LocalArray!(N%, 0), 2)), (Galaxy#(LocalArray!(N%, 0), 3)), U%, V%, C1%%)
            'FIO Print to temp file has proven they are in order from lowest to highest
            IF U% >= 0 AND U% <= Uscreen% AND V% >= 0 AND V% <= Vscreen% THEN CIRCLE (U%, V%), C1%%, Spectrum~&(LocalArray!(N%, 0)) 'Display point if within screen boundary
        NEXT N%
        'Planet Animation
        IF PlanetAnim%% <> -1 THEN
            CALL ToDisp((Galaxy#(PlanetAnim%%, 1)), (Galaxy#(PlanetAnim%%, 2)), (Galaxy#(PlanetAnim%%, 3)), U%, V%, C1%%)
            'Display blanking image beforehand so as not to leave trail
            _PUTIMAGE (Uscreen% / 2 - 50 + (PlanetCount% - 1) * (U% - (Uscreen% / 2 - 50)) / PlanetStop%, 100 + (PlanetCount% - 1) * (V% - 100) / PlanetStop%)-(Uscreen% / 2 + 50 + (PlanetCount% - 1) * (U% - (Uscreen% / 2 + 50)) / PlanetStop%, 200 + (PlanetCount% - 1) * (V% - 200) / PlanetStop%), Planets&(12)
            _PUTIMAGE (Uscreen% / 2 - 50 + PlanetCount% * (U% - (Uscreen% / 2 - 50)) / PlanetStop%, 100 + PlanetCount% * (V% - 100) / PlanetStop%)-(Uscreen% / 2 + 50 + PlanetCount% * (U% - (Uscreen% / 2 + 50)) / PlanetStop%, 200 + PlanetCount% * (V% - 200) / PlanetStop%), Planets&(PlanetAnim%%)
            PlanetCount% = PlanetCount% + 1
            IF PlanetCount% = PlanetStop% THEN
                PlanetCount% = 0
                PlanetAnim%% = -1
            END IF
        END IF
        IF EndArrow%% THEN
            _PUTIMAGE (ArrowLeft%, ArrowTop%)-(ArrowLeft% + 32, ArrowTop% + 32), Planets&(12)
            EndArrow%% = False
            UpArrow%% = False
            DownArrow%% = False
        ELSEIF UpArrow%% THEN
            _PUTIMAGE (ArrowLeft%, ArrowTop%), Planets&(13)
        ELSEIF DownArrow%% THEN
            _PUTIMAGE (ArrowLeft%, ArrowTop%), Planets&(14)
        END IF
        EndDraw PictureBox1
    END IF
END SUB

SUB __UI_BeforeUnload
    'If you set __UI_UnloadSignal = False here you can
    'cancel the user's request to close.
END SUB

SUB __UI_Click (id AS LONG)
    STATIC Paws!
    SELECT CASE id
        CASE GravitationSimulation

        CASE SimulationTypeFR

        CASE HowManyBodiesFR

        CASE GravitationalCollapseFR

        CASE GravitationalConstantFR

        CASE BodyDataFR

        CASE StepTimeFR

        CASE CollisionsFR

        CASE CollisionDistanceFR

        CASE ViewingAngleFR

        CASE ZoomFR

        CASE SimulationLimitTypeFR

        CASE SimulationLimitTimeFR

        CASE SimulationLimitCyclesFR

        CASE ElapsedTimeFR

        CASE EnergyFR

        CASE PictureBox1

        CASE GravitationalConstantLB

        CASE GravitationalConstantTB

        CASE HowManyBodiesLB

        CASE HowManyBodiesTB

        CASE BodyLB

        CASE MassLB

        CASE xPositionLB

        CASE yPositionLB

        CASE zPositionLB

        CASE xVelocityLB

        CASE yVelocityLB

        CASE zVelocityLB

        CASE Body1LB

        CASE BodyMass1TB

        CASE XPosition1TB

        CASE YPosition1TB

        CASE ZPosition1TB

        CASE XVelocity1TB

        CASE YVelocity1TB

        CASE ZVelocity1TB

        CASE Body2LB

        CASE BodyMass2TB

        CASE XPosition2TB

        CASE YPosition2TB

        CASE ZPosition2TB

        CASE XVelocity2TB

        CASE YVelocity2TB

        CASE ZVelocity2TB

        CASE Body3LB

        CASE BodyMass3TB

        CASE XPosition3TB

        CASE YPosition3TB

        CASE ZPosition3TB

        CASE XVelocity3TB

        CASE YVelocity3TB

        CASE ZVelocity3TB

        CASE Body4LB

        CASE BodyMass4TB

        CASE XPosition4TB

        CASE YPosition4TB

        CASE ZPosition4TB

        CASE XVelocity4TB

        CASE YVelocity4TB

        CASE ZVelocity4TB

        CASE Body5LB

        CASE BodyMass5TB

        CASE XPosition5TB

        CASE YPosition5TB

        CASE ZPosition5TB

        CASE XVelocity5TB

        CASE YVelocity5TB

        CASE ZVelocity5TB

        CASE Body6LB

        CASE BodyMass6TB

        CASE XPosition6TB

        CASE YPosition6TB

        CASE ZPosition6TB

        CASE XVelocity6TB

        CASE YVelocity6TB

        CASE ZVelocity6TB

        CASE Body7LB

        CASE BodyMass7TB

        CASE XPosition7TB

        CASE YPosition7TB

        CASE ZPosition7TB

        CASE XVelocity7TB

        CASE YVelocity7TB

        CASE ZVelocity7TB

        CASE Body8LB

        CASE BodyMass8TB

        CASE XPosition8TB

        CASE YPosition8TB

        CASE ZPosition8TB

        CASE XVelocity8TB

        CASE YVelocity8TB

        CASE ZVelocity8TB

        CASE Body9LB

        CASE BodyMass9TB

        CASE XPosition9TB

        CASE YPosition9TB

        CASE ZPosition9TB

        CASE XVelocity9TB

        CASE YVelocity9TB

        CASE ZVelocity9TB

        CASE Body10LB

        CASE BodyMass10TB

        CASE XPosition10TB

        CASE YPosition10TB

        CASE ZPosition10TB

        CASE XVelocity10TB

        CASE YVelocity10TB

        CASE ZVelocity10TB

        CASE Body11LB

        CASE BodyMass11TB

        CASE XPosition11TB

        CASE YPosition11TB

        CASE ZPosition11TB

        CASE XVelocity11TB

        CASE YVelocity11TB

        CASE ZVelocity11TB

        CASE NumberOfBodiesLB

        CASE NumberOfBodiesTB

        CASE MaximumMassLB

        CASE MaximumMassTB

        CASE MaximumDistanceLB

        CASE MaximumDistanceTB

        CASE MaximumSpeedLB

        CASE MaximumSpeedTB

        CASE StepTimeLB

        CASE StepTimeSecTB

        CASE CollisionDistanceLB

        CASE CollisionDistanceTB

        CASE toSetValuesLB

        CASE ProgressBar1

        CASE ViewingTrackBar

        CASE ZeroDegLB

        CASE Minus180LB

        CASE Plus180LB

        CASE NumberofMinutesLB

        CASE NumberofMinutesTB

        CASE NumberofHoursLB

        CASE NumberofHoursTB

        CASE NumberofCyclesTB

        CASE NumberofCyclesLB

        CASE StepTimeMinTB

        CASE StepTimeHrTB

        CASE StepTimeHrLB

        CASE StepTimeMinsLB

        CASE StepTimeSecsLB

        CASE ElapsedTime1TB

        CASE ElapsedTime2TB

        CASE ElapsedTime1LB

        CASE ElapsedTime2LB

        CASE SolarSystemLB

        CASE ManualInputLB

        CASE GravitationalCollapseLB

        CASE LoadFromFileLB

        CASE ElapsedTimeLB

        CASE DemonstrationLB

        CASE EnergyTB

        CASE DemoLabel1LB

        CASE DemoLabel2LB

        CASE EnergyLB
            IF EFrameClick%% THEN
                EFrameClick%% = False
                Caption(EnergyLB) = "Energy"
                Text(EnergyTB) = DispEnery$
            ELSE
                EFrameClick%% = True ' Doesn't get updated in set-up
                Caption(EnergyLB) = "Bodies"
                Text(EnergyTB) = MakeText$(NoBodiesLess1% + 1)
            END IF
        CASE TimeLimitRB
            Control(SimulationLimitCyclesFR).Hidden = True
            Control(SimulationLimitTimeFR).Hidden = False
        CASE CyclesLimitRB
            Control(SimulationLimitTimeFR).Hidden = True
            Control(SimulationLimitCyclesFR).Hidden = False
        CASE ZoomInBT
            IF DoCalc%% THEN CALL Zoomer((True))
        CASE ZoomOutBT
            IF DoCalc%% THEN CALL Zoomer((False))
        CASE AllowCollisionsCB
            IF Control(AllowCollisionsCB).Value THEN
                Control(CollisionDistanceFR).Hidden = False
            ELSE
                Control(CollisionDistanceFR).Hidden = True
            END IF
        CASE AllowComputertoSetCB
            IF Control(AllowComputertoSetCB).Value THEN
                Control(CollisionDistanceTB).Disabled = True
                Control(BodyDataFR).Hidden = True
                Text(StepTimeSecTB) = "10"
            ELSE
                Control(CollisionDistanceTB).Disabled = False
                Control(BodyDataFR).Hidden = False
                Text(StepTimeSecTB) = "1"
            END IF
        CASE ExitBT
            _SNDCLOSE Pop&
            SYSTEM
        CASE ResetBT
            CALL Refresh(1)
            Control(SimulationTypeFR).Hidden = False
            Control(ResetBT).Disabled = True
            Control(PauseBT).Disabled = True
            Caption(PauseBT) = "Pause"
            Control(TraceBT).Disabled = True
            Control(ClearBT).Disabled = True
            Control(DemoLabel1LB).Hidden = True
            Control(DemoLabel2LB).Hidden = True
            Control(ZoomInBT).Disabled = True
            Control(ZoomOutBT).Disabled = True
            Trace%% = True
            Wipe%% = False
            SetRadioButtonValue SolarSystemRB
            Control(ProgressBar1).Value = 0
            Text(HowManyBodiesTB) = "11"
            FOR M% = 1 TO 11
                FOR K% = 8 * M% - 7 TO 8 * M%
                    Text(ControlIndex&(K%)) = ""
                    IF M% >= 3 THEN Control(ControlIndex&(K%)).Hidden = False
                NEXT K%
            NEXT M%
            BeginDraw PictureBox1
            CLS
            EndDraw PictureBox1
        CASE PauseBT
            IF NOT DoCalc%% THEN
                NoCycles& = 0
                StartCalc! = TIMER
                Caption(PauseBT) = "Pause"
                Caption(ExecuteBT) = "Stop"
                DoCalc%% = True
                Control(ExecuteBT).Disabled = False
                Control(ResetBT).Disabled = True
                Control(TraceBT).Disabled = False
                IF Trace%% THEN Control(ClearBT).Disabled = False
                CALL Execute
            ELSEIF NOT Paused%% THEN
                CALL UpdateDisp
                Caption(PauseBT) = "Resume"
                Control(ExecuteBT).Disabled = True
                Control(TraceBT).Disabled = True
                Control(ClearBT).Disabled = True
                Paused%% = True
                Paws! = TIMER
            ELSE
                Caption(PauseBT) = "Pause"
                Control(ExecuteBT).Disabled = False
                IF NOT Control(DemonstrationRB).Value THEN
                    Control(TraceBT).Disabled = False
                    IF Trace%% THEN Control(ClearBT).Disabled = False
                END IF
                Paused%% = False
                IF Paws! > TIMER THEN Paws! = Paws! - 86400
                StartCalc! = StartCalc! + TIMER - Paws!
                CALL Execute
            END IF
        CASE TraceBT
            IF Trace%% THEN
                Trace%% = False
                Control(ClearBT).Disabled = True
                Caption(TraceBT) = "Trace"
            ELSE
                Trace%% = True
                Control(ClearBT).Disabled = False
                Caption(TraceBT) = "Spot"
            END IF
        CASE ClearBT
            Wipe%% = True
        CASE ExecuteBT
            'Check for valid input data
            IF DoCalc%% THEN
                Control(PauseBT).Disabled = True
                CALL ThisIsAnExParrot
            ELSE
                IF Control(SolarSystemRB).Value OR Control(DemonstrationRB).Value THEN
                    CALL SolarFill
                ELSEIF Control(BodyManualRB).Value THEN
                    CALL BodyManualFill
                ELSEIF Control(GravitationalCollapseRB).Value THEN
                    CALL CollapseFill
                ELSE ' Check for file, load data & execute
                    IF _FILEEXISTS("mbpfile.dat") THEN
                        DoCalc%% = True
                    ELSE
                        AA& = MessageBox("You Have Not Completed a Run", "", 0)
                    END IF
                END IF
            END IF
            IF DoCalc%% THEN
                PlanetAnim%% = -1
                Control(SimulationTypeFR).Hidden = True
                Control(AllowCollisionsCB).Disabled = True
                Control(CollisionDistanceFR).Disabled = True
                Control(SimulationLimitTypeFR).Hidden = True
                Control(SimulationLimitTimeFR).Hidden = True
                Control(SimulationLimitCyclesFR).Hidden = True
                Control(CollisionsFR).Hidden = True
                Control(BodyDataFR).Hidden = True
                Control(CollisionDistanceFR).Top = 52
                Control(CollisionDistanceFR).Left = 10
                Control(CollisionDistanceTB).Disabled = True
                IF Control(AllowCollisionsCB).Value THEN
                    Control(CollisionDistanceFR).Hidden = False
                ELSE
                    Control(CollisionDistanceFR).Hidden = True
                END IF
                IF NOT Control(DemonstrationRB).Value THEN
                    Control(TraceBT).Disabled = False
                    Control(ClearBT).Disabled = False
                    Control(ZoomInBT).Disabled = False
                    Control(ZoomOutBT).Disabled = False
                    Control(LoadFromFileRB).Disabled = True
                END IF
                Control(PauseBT).Disabled = False
                Caption(ExecuteBT) = "Stop"
                Caption(PauseBT) = "Pause"
                Gravity! = VAL(Text(GravitationalConstantTB))
                CALL SetStep
                CosAng! = COS(ViewingAngle!)
                SinAng! = SIN(ViewingAngle!)
                Coalesce! = 1000000 * VAL(Text(CollisionDistanceTB)) * VAL(Text(CollisionDistanceTB))
                Collided%% = False
                TimeLimit! = 60 * VAL(Text(NumberofMinutesTB)) + 3600 * VAL(Text(NumberofHoursTB))
                CyclesLimit& = VAL(Text(NumberofCyclesTB))
                NoCycles& = 0
                StartCalc! = TIMER
                IF NOT Control(LoadFromFileRB).Value THEN StartEnergy! = Energy!
                BeginDraw PictureBox1
                CLS
                EndDraw PictureBox1
                CALL Execute
            END IF
        CASE SolarSystemRB
            CALL Refresh(1)
        CASE BodyManualRB
            CALL Refresh(2)
            IF Control(AllowComputertoSetCB).Value THEN
                Text(StepTimeSecTB) = "10"
            ELSE
                Control(BodyDataFR).Hidden = False
            END IF
        CASE GravitationalCollapseRB
            CALL Refresh(3)
        CASE LoadFromFileRB
            CALL Refresh(1)
            Control(SolarSystemLB).Hidden = True
            Control(LoadFromFileLB).Hidden = False
            IF _FILEEXISTS("mbpfile.dat") THEN
                OPEN "mbpfile.dat" FOR INPUT AS #1
                INPUT #1, Dum1!
                IF Dum1! <> 0 THEN
                    Control(CollisionDistanceFR).Hidden = False
                    Text(CollisionDistanceTB) = MakeText$((SQR(Dum1!) / 1000))
                    Control(AllowCollisionsCB).Value = True
                END IF
                INPUT #1, Text(StepTimeSecTB), Text(StepTimeMinTB), Text(StepTimeHrTB)
                INPUT #1, Dum1!, Text(NumberofMinutesTB), Text(NumberofHoursTB), Text(NumberofCyclesTB)
                IF Dum1! THEN
                    SetRadioButtonValue TimeLimitRB
                ELSE
                    SetRadioButtonValue CyclesLimitRB
                END IF
                INPUT #1, Text(GravitationalConstantTB), Zoom!, ViewingAngle!
                Control(ViewingTrackBar).Value = ViewingAngle! * 180 / _PI
                INPUT #1, NoBodiesLess1%, StartEnergy!, TotSecs&, TotMins&, TotHrs&, TotDays&, TotYears&
                CALL ElapsedTime
                N% = 0
                WHILE NOT EOF(1)
                    INPUT #1, Galaxy#(N%, 0), Galaxy#(N%, 1), Galaxy#(N%, 2), Galaxy#(N%, 3), Galaxy#(N%, 4), Galaxy#(N%, 5), Galaxy#(N%, 6)
                    IF N% <= 11 THEN
                        INPUT #1, Spectrum~&(N%)
                    ELSE
                        Spectrum~&(N%) = RedGreenBlue~&
                    END IF
                    N% = N% + 1
                WEND
                CLOSE #1
                Gravity! = VAL(Text(GravitationalConstantTB))
                Text(EnergyTB) = DispEnery$
            END IF
        CASE DemonstrationRB
            CALL Refresh(4)
    END SELECT
END SUB

SUB __UI_MouseEnter (id AS LONG)
    SELECT CASE id
        CASE GravitationSimulation

        CASE SimulationTypeFR

        CASE HowManyBodiesFR

        CASE GravitationalCollapseFR

        CASE GravitationalConstantFR

        CASE BodyDataFR

        CASE StepTimeFR

        CASE CollisionsFR

        CASE CollisionDistanceFR

        CASE ViewingAngleFR

        CASE ZoomFR

        CASE SimulationLimitTypeFR

        CASE SimulationLimitTimeFR

        CASE SimulationLimitCyclesFR

        CASE ElapsedTimeFR

        CASE EnergyFR

        CASE PictureBox1

        CASE ExitBT

        CASE PauseBT

        CASE ExecuteBT

        CASE SolarSystemRB

        CASE BodyManualRB

        CASE GravitationalCollapseRB

        CASE LoadFromFileRB

        CASE DemonstrationRB

        CASE GravitationalConstantLB

        CASE GravitationalConstantTB

        CASE HowManyBodiesLB

        CASE HowManyBodiesTB

        CASE BodyLB

        CASE MassLB

        CASE xPositionLB

        CASE yPositionLB

        CASE zPositionLB

        CASE xVelocityLB

        CASE yVelocityLB

        CASE zVelocityLB

        CASE Body1LB

        CASE BodyMass1TB

        CASE XPosition1TB

        CASE YPosition1TB

        CASE ZPosition1TB

        CASE XVelocity1TB

        CASE YVelocity1TB

        CASE ZVelocity1TB

        CASE Body2LB

        CASE BodyMass2TB

        CASE XPosition2TB

        CASE YPosition2TB

        CASE ZPosition2TB

        CASE XVelocity2TB

        CASE YVelocity2TB

        CASE ZVelocity2TB

        CASE Body3LB

        CASE BodyMass3TB

        CASE XPosition3TB

        CASE YPosition3TB

        CASE ZPosition3TB

        CASE XVelocity3TB

        CASE YVelocity3TB

        CASE ZVelocity3TB

        CASE Body4LB

        CASE BodyMass4TB

        CASE XPosition4TB

        CASE YPosition4TB

        CASE ZPosition4TB

        CASE XVelocity4TB

        CASE YVelocity4TB

        CASE ZVelocity4TB

        CASE Body5LB

        CASE BodyMass5TB

        CASE XPosition5TB

        CASE YPosition5TB

        CASE ZPosition5TB

        CASE XVelocity5TB

        CASE YVelocity5TB

        CASE ZVelocity5TB

        CASE Body6LB

        CASE BodyMass6TB

        CASE XPosition6TB

        CASE YPosition6TB

        CASE ZPosition6TB

        CASE XVelocity6TB

        CASE YVelocity6TB

        CASE ZVelocity6TB

        CASE Body7LB

        CASE BodyMass7TB

        CASE XPosition7TB

        CASE YPosition7TB

        CASE ZPosition7TB

        CASE XVelocity7TB

        CASE YVelocity7TB

        CASE ZVelocity7TB

        CASE Body8LB

        CASE BodyMass8TB

        CASE XPosition8TB

        CASE YPosition8TB

        CASE ZPosition8TB

        CASE XVelocity8TB

        CASE YVelocity8TB

        CASE ZVelocity8TB

        CASE Body9LB

        CASE BodyMass9TB

        CASE XPosition9TB

        CASE YPosition9TB

        CASE ZPosition9TB

        CASE XVelocity9TB

        CASE YVelocity9TB

        CASE ZVelocity9TB

        CASE Body10LB

        CASE BodyMass10TB

        CASE XPosition10TB

        CASE YPosition10TB

        CASE ZPosition10TB

        CASE XVelocity10TB

        CASE YVelocity10TB

        CASE ZVelocity10TB

        CASE Body11LB

        CASE BodyMass11TB

        CASE XPosition11TB

        CASE YPosition11TB

        CASE ZPosition11TB

        CASE XVelocity11TB

        CASE YVelocity11TB

        CASE ZVelocity11TB

        CASE NumberOfBodiesLB

        CASE NumberOfBodiesTB

        CASE MaximumMassLB

        CASE MaximumMassTB

        CASE MaximumDistanceLB

        CASE MaximumDistanceTB

        CASE MaximumSpeedLB

        CASE MaximumSpeedTB

        CASE StepTimeLB

        CASE StepTimeSecTB

        CASE CollisionDistanceLB

        CASE CollisionDistanceTB

        CASE AllowCollisionsCB

        CASE AllowComputertoSetCB

        CASE toSetValuesLB

        CASE ProgressBar1

        CASE ViewingTrackBar

        CASE ZeroDegLB

        CASE Minus180LB

        CASE Plus180LB

        CASE TimeLimitRB

        CASE CyclesLimitRB

        CASE NumberofMinutesLB

        CASE NumberofMinutesTB

        CASE NumberofHoursLB

        CASE NumberofHoursTB

        CASE NumberofCyclesTB

        CASE NumberofCyclesLB

        CASE StepTimeMinTB

        CASE StepTimeHrTB

        CASE StepTimeHrLB

        CASE StepTimeMinsLB

        CASE StepTimeSecsLB

        CASE ElapsedTime1TB

        CASE ElapsedTime2TB

        CASE ElapsedTime1LB

        CASE ElapsedTime2LB

        CASE SolarSystemLB

        CASE ManualInputLB

        CASE GravitationalCollapseLB

        CASE LoadFromFileLB

        CASE ElapsedTimeLB

        CASE DemonstrationLB

        CASE ResetBT

        CASE EnergyLB

        CASE EnergyTB

        CASE DemoLabel1LB

        CASE TraceBT

        CASE ClearBT

        CASE DemoLabel2LB

        CASE ZoomInBT

        CASE ZoomOutBT

    END SELECT
END SUB

SUB __UI_MouseLeave (id AS LONG)
    SELECT CASE id
        CASE GravitationSimulation

        CASE SimulationTypeFR

        CASE HowManyBodiesFR

        CASE GravitationalCollapseFR

        CASE GravitationalConstantFR

        CASE BodyDataFR

        CASE StepTimeFR

        CASE CollisionsFR

        CASE CollisionDistanceFR

        CASE ViewingAngleFR

        CASE ZoomFR

        CASE SimulationLimitTypeFR

        CASE SimulationLimitTimeFR

        CASE SimulationLimitCyclesFR

        CASE ElapsedTimeFR

        CASE EnergyFR

        CASE PictureBox1

        CASE ExitBT

        CASE PauseBT

        CASE ExecuteBT

        CASE SolarSystemRB

        CASE BodyManualRB

        CASE GravitationalCollapseRB

        CASE LoadFromFileRB

        CASE DemonstrationRB

        CASE GravitationalConstantLB

        CASE GravitationalConstantTB

        CASE HowManyBodiesLB

        CASE HowManyBodiesTB

        CASE BodyLB

        CASE MassLB

        CASE xPositionLB

        CASE yPositionLB

        CASE zPositionLB

        CASE xVelocityLB

        CASE yVelocityLB

        CASE zVelocityLB

        CASE Body1LB

        CASE BodyMass1TB

        CASE XPosition1TB

        CASE YPosition1TB

        CASE ZPosition1TB

        CASE XVelocity1TB

        CASE YVelocity1TB

        CASE ZVelocity1TB

        CASE Body2LB

        CASE BodyMass2TB

        CASE XPosition2TB

        CASE YPosition2TB

        CASE ZPosition2TB

        CASE XVelocity2TB

        CASE YVelocity2TB

        CASE ZVelocity2TB

        CASE Body3LB

        CASE BodyMass3TB

        CASE XPosition3TB

        CASE YPosition3TB

        CASE ZPosition3TB

        CASE XVelocity3TB

        CASE YVelocity3TB

        CASE ZVelocity3TB

        CASE Body4LB

        CASE BodyMass4TB

        CASE XPosition4TB

        CASE YPosition4TB

        CASE ZPosition4TB

        CASE XVelocity4TB

        CASE YVelocity4TB

        CASE ZVelocity4TB

        CASE Body5LB

        CASE BodyMass5TB

        CASE XPosition5TB

        CASE YPosition5TB

        CASE ZPosition5TB

        CASE XVelocity5TB

        CASE YVelocity5TB

        CASE ZVelocity5TB

        CASE Body6LB

        CASE BodyMass6TB

        CASE XPosition6TB

        CASE YPosition6TB

        CASE ZPosition6TB

        CASE XVelocity6TB

        CASE YVelocity6TB

        CASE ZVelocity6TB

        CASE Body7LB

        CASE BodyMass7TB

        CASE XPosition7TB

        CASE YPosition7TB

        CASE ZPosition7TB

        CASE XVelocity7TB

        CASE YVelocity7TB

        CASE ZVelocity7TB

        CASE Body8LB

        CASE BodyMass8TB

        CASE XPosition8TB

        CASE YPosition8TB

        CASE ZPosition8TB

        CASE XVelocity8TB

        CASE YVelocity8TB

        CASE ZVelocity8TB

        CASE Body9LB

        CASE BodyMass9TB

        CASE XPosition9TB

        CASE YPosition9TB

        CASE ZPosition9TB

        CASE XVelocity9TB

        CASE YVelocity9TB

        CASE ZVelocity9TB

        CASE Body10LB

        CASE BodyMass10TB

        CASE XPosition10TB

        CASE YPosition10TB

        CASE ZPosition10TB

        CASE XVelocity10TB

        CASE YVelocity10TB

        CASE ZVelocity10TB

        CASE Body11LB

        CASE BodyMass11TB

        CASE XPosition11TB

        CASE YPosition11TB

        CASE ZPosition11TB

        CASE XVelocity11TB

        CASE YVelocity11TB

        CASE ZVelocity11TB

        CASE NumberOfBodiesLB

        CASE NumberOfBodiesTB

        CASE MaximumMassLB

        CASE MaximumMassTB

        CASE MaximumDistanceLB

        CASE MaximumDistanceTB

        CASE MaximumSpeedLB

        CASE MaximumSpeedTB

        CASE StepTimeLB

        CASE StepTimeSecTB

        CASE CollisionDistanceLB

        CASE CollisionDistanceTB

        CASE AllowCollisionsCB

        CASE AllowComputertoSetCB

        CASE toSetValuesLB

        CASE ProgressBar1

        CASE ViewingTrackBar

        CASE ZeroDegLB

        CASE Minus180LB

        CASE Plus180LB

        CASE TimeLimitRB

        CASE CyclesLimitRB

        CASE NumberofMinutesLB

        CASE NumberofMinutesTB

        CASE NumberofHoursLB

        CASE NumberofHoursTB

        CASE NumberofCyclesTB

        CASE NumberofCyclesLB

        CASE StepTimeMinTB

        CASE StepTimeHrTB

        CASE StepTimeHrLB

        CASE StepTimeMinsLB

        CASE StepTimeSecsLB

        CASE ElapsedTime1TB

        CASE ElapsedTime2TB

        CASE ElapsedTime1LB

        CASE ElapsedTime2LB

        CASE SolarSystemLB

        CASE ManualInputLB

        CASE GravitationalCollapseLB

        CASE LoadFromFileLB

        CASE ElapsedTimeLB

        CASE DemonstrationLB

        CASE ResetBT

        CASE EnergyLB

        CASE EnergyTB

        CASE DemoLabel1LB

        CASE TraceBT

        CASE ClearBT

        CASE DemoLabel2LB

        CASE ZoomInBT

        CASE ZoomOutBT

    END SELECT
END SUB

SUB __UI_FocusIn (id AS LONG)
    SELECT CASE id
        CASE ExitBT

        CASE PauseBT

        CASE ExecuteBT

        CASE SolarSystemRB

        CASE BodyManualRB

        CASE GravitationalCollapseRB

        CASE LoadFromFileRB

        CASE DemonstrationRB

        CASE GravitationalConstantTB

        CASE HowManyBodiesTB

        CASE BodyMass1TB

        CASE XPosition1TB

        CASE YPosition1TB

        CASE ZPosition1TB

        CASE XVelocity1TB

        CASE YVelocity1TB

        CASE ZVelocity1TB

        CASE BodyMass2TB

        CASE XPosition2TB

        CASE YPosition2TB

        CASE ZPosition2TB

        CASE XVelocity2TB

        CASE YVelocity2TB

        CASE ZVelocity2TB

        CASE BodyMass3TB

        CASE XPosition3TB

        CASE YPosition3TB

        CASE ZPosition3TB

        CASE XVelocity3TB

        CASE YVelocity3TB

        CASE ZVelocity3TB

        CASE BodyMass4TB

        CASE XPosition4TB

        CASE YPosition4TB

        CASE ZPosition4TB

        CASE XVelocity4TB

        CASE YVelocity4TB

        CASE ZVelocity4TB

        CASE BodyMass5TB

        CASE XPosition5TB

        CASE YPosition5TB

        CASE ZPosition5TB

        CASE XVelocity5TB

        CASE YVelocity5TB

        CASE ZVelocity5TB

        CASE BodyMass6TB

        CASE XPosition6TB

        CASE YPosition6TB

        CASE ZPosition6TB

        CASE XVelocity6TB

        CASE YVelocity6TB

        CASE ZVelocity6TB

        CASE BodyMass7TB

        CASE XPosition7TB

        CASE YPosition7TB

        CASE ZPosition7TB

        CASE XVelocity7TB

        CASE YVelocity7TB

        CASE ZVelocity7TB

        CASE BodyMass8TB

        CASE XPosition8TB

        CASE YPosition8TB

        CASE ZPosition8TB

        CASE XVelocity8TB

        CASE YVelocity8TB

        CASE ZVelocity8TB

        CASE BodyMass9TB

        CASE XPosition9TB

        CASE YPosition9TB

        CASE ZPosition9TB

        CASE XVelocity9TB

        CASE YVelocity9TB

        CASE ZVelocity9TB

        CASE BodyMass10TB

        CASE XPosition10TB

        CASE YPosition10TB

        CASE ZPosition10TB

        CASE XVelocity10TB

        CASE YVelocity10TB

        CASE ZVelocity10TB

        CASE BodyMass11TB

        CASE XPosition11TB

        CASE YPosition11TB

        CASE ZPosition11TB

        CASE XVelocity11TB

        CASE YVelocity11TB

        CASE ZVelocity11TB

        CASE NumberOfBodiesTB

        CASE MaximumMassTB

        CASE MaximumDistanceTB

        CASE MaximumSpeedTB

        CASE StepTimeSecTB

        CASE CollisionDistanceTB

        CASE AllowCollisionsCB

        CASE AllowComputertoSetCB

        CASE ViewingTrackBar

        CASE TimeLimitRB

        CASE CyclesLimitRB

        CASE NumberofMinutesTB

        CASE NumberofHoursTB

        CASE NumberofCyclesTB

        CASE StepTimeMinTB

        CASE StepTimeHrTB

        CASE ElapsedTime1TB

        CASE ElapsedTime2TB

        CASE ResetBT

        CASE EnergyTB

        CASE TraceBT

        CASE ClearBT

        CASE ZoomInBT

        CASE ZoomOutBT

    END SELECT
END SUB

SUB __UI_FocusOut (id AS LONG)
    'This event occurs right before a control loses focus.
    'To prevent a control from losing focus, set __UI_KeepFocus = True below.
    SELECT CASE id
        CASE ExitBT

        CASE PauseBT

        CASE ExecuteBT

        CASE SolarSystemRB

        CASE BodyManualRB

        CASE GravitationalCollapseRB

        CASE LoadFromFileRB

        CASE DemonstrationRB

        CASE GravitationalConstantTB

        CASE HowManyBodiesTB

        CASE BodyMass1TB

        CASE XPosition1TB

        CASE YPosition1TB

        CASE ZPosition1TB

        CASE XVelocity1TB

        CASE YVelocity1TB

        CASE ZVelocity1TB

        CASE BodyMass2TB

        CASE XPosition2TB

        CASE YPosition2TB

        CASE ZPosition2TB

        CASE XVelocity2TB

        CASE YVelocity2TB

        CASE ZVelocity2TB

        CASE BodyMass3TB

        CASE XPosition3TB

        CASE YPosition3TB

        CASE ZPosition3TB

        CASE XVelocity3TB

        CASE YVelocity3TB

        CASE ZVelocity3TB

        CASE BodyMass4TB

        CASE XPosition4TB

        CASE YPosition4TB

        CASE ZPosition4TB

        CASE XVelocity4TB

        CASE YVelocity4TB

        CASE ZVelocity4TB

        CASE BodyMass5TB

        CASE XPosition5TB

        CASE YPosition5TB

        CASE ZPosition5TB

        CASE XVelocity5TB

        CASE YVelocity5TB

        CASE ZVelocity5TB

        CASE BodyMass6TB

        CASE XPosition6TB

        CASE YPosition6TB

        CASE ZPosition6TB

        CASE XVelocity6TB

        CASE YVelocity6TB

        CASE ZVelocity6TB

        CASE BodyMass7TB

        CASE XPosition7TB

        CASE YPosition7TB

        CASE ZPosition7TB

        CASE XVelocity7TB

        CASE YVelocity7TB

        CASE ZVelocity7TB

        CASE BodyMass8TB

        CASE XPosition8TB

        CASE YPosition8TB

        CASE ZPosition8TB

        CASE XVelocity8TB

        CASE YVelocity8TB

        CASE ZVelocity8TB

        CASE BodyMass9TB

        CASE XPosition9TB

        CASE YPosition9TB

        CASE ZPosition9TB

        CASE XVelocity9TB

        CASE YVelocity9TB

        CASE ZVelocity9TB

        CASE BodyMass10TB

        CASE XPosition10TB

        CASE YPosition10TB

        CASE ZPosition10TB

        CASE XVelocity10TB

        CASE YVelocity10TB

        CASE ZVelocity10TB

        CASE BodyMass11TB

        CASE XPosition11TB

        CASE YPosition11TB

        CASE ZPosition11TB

        CASE XVelocity11TB

        CASE YVelocity11TB

        CASE ZVelocity11TB

        CASE NumberOfBodiesTB

        CASE MaximumMassTB

        CASE MaximumDistanceTB

        CASE MaximumSpeedTB

        CASE StepTimeSecTB

        CASE CollisionDistanceTB

        CASE AllowCollisionsCB

        CASE AllowComputertoSetCB

        CASE ViewingTrackBar

        CASE TimeLimitRB

        CASE CyclesLimitRB

        CASE NumberofMinutesTB

        CASE NumberofHoursTB

        CASE NumberofCyclesTB

        CASE StepTimeMinTB

        CASE StepTimeHrTB

        CASE ElapsedTime1TB

        CASE ElapsedTime2TB

        CASE ResetBT

        CASE EnergyTB

        CASE TraceBT

        CASE ClearBT

        CASE ZoomInBT

        CASE ZoomOutBT

    END SELECT
END SUB

SUB __UI_MouseDown (id AS LONG)
    SELECT CASE id
        CASE GravitationSimulation

        CASE SimulationTypeFR

        CASE HowManyBodiesFR

        CASE GravitationalCollapseFR

        CASE GravitationalConstantFR

        CASE BodyDataFR

        CASE StepTimeFR

        CASE CollisionsFR

        CASE CollisionDistanceFR

        CASE ViewingAngleFR

        CASE ZoomFR

        CASE SimulationLimitTypeFR

        CASE SimulationLimitTimeFR

        CASE SimulationLimitCyclesFR

        CASE ElapsedTimeFR

        CASE EnergyFR

        CASE PictureBox1

        CASE ExitBT

        CASE PauseBT

        CASE ExecuteBT

        CASE SolarSystemRB

        CASE BodyManualRB

        CASE GravitationalCollapseRB

        CASE LoadFromFileRB

        CASE DemonstrationRB

        CASE GravitationalConstantLB

        CASE GravitationalConstantTB

        CASE HowManyBodiesLB

        CASE HowManyBodiesTB

        CASE BodyLB

        CASE MassLB

        CASE xPositionLB

        CASE yPositionLB

        CASE zPositionLB

        CASE xVelocityLB

        CASE yVelocityLB

        CASE zVelocityLB

        CASE Body1LB

        CASE BodyMass1TB

        CASE XPosition1TB

        CASE YPosition1TB

        CASE ZPosition1TB

        CASE XVelocity1TB

        CASE YVelocity1TB

        CASE ZVelocity1TB

        CASE Body2LB

        CASE BodyMass2TB

        CASE XPosition2TB

        CASE YPosition2TB

        CASE ZPosition2TB

        CASE XVelocity2TB

        CASE YVelocity2TB

        CASE ZVelocity2TB

        CASE Body3LB

        CASE BodyMass3TB

        CASE XPosition3TB

        CASE YPosition3TB

        CASE ZPosition3TB

        CASE XVelocity3TB

        CASE YVelocity3TB

        CASE ZVelocity3TB

        CASE Body4LB

        CASE BodyMass4TB

        CASE XPosition4TB

        CASE YPosition4TB

        CASE ZPosition4TB

        CASE XVelocity4TB

        CASE YVelocity4TB

        CASE ZVelocity4TB

        CASE Body5LB

        CASE BodyMass5TB

        CASE XPosition5TB

        CASE YPosition5TB

        CASE ZPosition5TB

        CASE XVelocity5TB

        CASE YVelocity5TB

        CASE ZVelocity5TB

        CASE Body6LB

        CASE BodyMass6TB

        CASE XPosition6TB

        CASE YPosition6TB

        CASE ZPosition6TB

        CASE XVelocity6TB

        CASE YVelocity6TB

        CASE ZVelocity6TB

        CASE Body7LB

        CASE BodyMass7TB

        CASE XPosition7TB

        CASE YPosition7TB

        CASE ZPosition7TB

        CASE XVelocity7TB

        CASE YVelocity7TB

        CASE ZVelocity7TB

        CASE Body8LB

        CASE BodyMass8TB

        CASE XPosition8TB

        CASE YPosition8TB

        CASE ZPosition8TB

        CASE XVelocity8TB

        CASE YVelocity8TB

        CASE ZVelocity8TB

        CASE Body9LB

        CASE BodyMass9TB

        CASE XPosition9TB

        CASE YPosition9TB

        CASE ZPosition9TB

        CASE XVelocity9TB

        CASE YVelocity9TB

        CASE ZVelocity9TB

        CASE Body10LB

        CASE BodyMass10TB

        CASE XPosition10TB

        CASE YPosition10TB

        CASE ZPosition10TB

        CASE XVelocity10TB

        CASE YVelocity10TB

        CASE ZVelocity10TB

        CASE Body11LB

        CASE BodyMass11TB

        CASE XPosition11TB

        CASE YPosition11TB

        CASE ZPosition11TB

        CASE XVelocity11TB

        CASE YVelocity11TB

        CASE ZVelocity11TB

        CASE NumberOfBodiesLB

        CASE NumberOfBodiesTB

        CASE MaximumMassLB

        CASE MaximumMassTB

        CASE MaximumDistanceLB

        CASE MaximumDistanceTB

        CASE MaximumSpeedLB

        CASE MaximumSpeedTB

        CASE StepTimeLB

        CASE StepTimeSecTB

        CASE CollisionDistanceLB

        CASE CollisionDistanceTB

        CASE AllowCollisionsCB

        CASE AllowComputertoSetCB

        CASE toSetValuesLB

        CASE ProgressBar1

        CASE ViewingTrackBar

        CASE ZeroDegLB

        CASE Minus180LB

        CASE Plus180LB

        CASE TimeLimitRB

        CASE CyclesLimitRB

        CASE NumberofMinutesLB

        CASE NumberofMinutesTB

        CASE NumberofHoursLB

        CASE NumberofHoursTB

        CASE NumberofCyclesTB

        CASE NumberofCyclesLB

        CASE StepTimeMinTB

        CASE StepTimeHrTB

        CASE StepTimeHrLB

        CASE StepTimeMinsLB

        CASE StepTimeSecsLB

        CASE ElapsedTime1TB

        CASE ElapsedTime2TB

        CASE ElapsedTime1LB

        CASE ElapsedTime2LB

        CASE SolarSystemLB

        CASE ManualInputLB

        CASE GravitationalCollapseLB

        CASE LoadFromFileLB

        CASE ElapsedTimeLB

        CASE DemonstrationLB

        CASE ResetBT

        CASE EnergyLB

        CASE EnergyTB

        CASE DemoLabel1LB

        CASE TraceBT

        CASE ClearBT

        CASE DemoLabel2LB

        CASE ZoomInBT

        CASE ZoomOutBT

    END SELECT
END SUB

SUB __UI_MouseUp (id AS LONG)
    SELECT CASE id
        CASE GravitationSimulation

        CASE SimulationTypeFR

        CASE HowManyBodiesFR

        CASE GravitationalCollapseFR

        CASE GravitationalConstantFR

        CASE BodyDataFR

        CASE StepTimeFR

        CASE CollisionsFR

        CASE CollisionDistanceFR

        CASE ViewingAngleFR

        CASE ZoomFR

        CASE SimulationLimitTypeFR

        CASE SimulationLimitTimeFR

        CASE SimulationLimitCyclesFR

        CASE ElapsedTimeFR

        CASE EnergyFR

        CASE PictureBox1

        CASE ExitBT

        CASE PauseBT

        CASE ExecuteBT

        CASE SolarSystemRB

        CASE BodyManualRB

        CASE GravitationalCollapseRB

        CASE LoadFromFileRB

        CASE DemonstrationRB

        CASE GravitationalConstantLB

        CASE GravitationalConstantTB

        CASE HowManyBodiesLB

        CASE HowManyBodiesTB

        CASE BodyLB

        CASE MassLB

        CASE xPositionLB

        CASE yPositionLB

        CASE zPositionLB

        CASE xVelocityLB

        CASE yVelocityLB

        CASE zVelocityLB

        CASE Body1LB

        CASE BodyMass1TB

        CASE XPosition1TB

        CASE YPosition1TB

        CASE ZPosition1TB

        CASE XVelocity1TB

        CASE YVelocity1TB

        CASE ZVelocity1TB

        CASE Body2LB

        CASE BodyMass2TB

        CASE XPosition2TB

        CASE YPosition2TB

        CASE ZPosition2TB

        CASE XVelocity2TB

        CASE YVelocity2TB

        CASE ZVelocity2TB

        CASE Body3LB

        CASE BodyMass3TB

        CASE XPosition3TB

        CASE YPosition3TB

        CASE ZPosition3TB

        CASE XVelocity3TB

        CASE YVelocity3TB

        CASE ZVelocity3TB

        CASE Body4LB

        CASE BodyMass4TB

        CASE XPosition4TB

        CASE YPosition4TB

        CASE ZPosition4TB

        CASE XVelocity4TB

        CASE YVelocity4TB

        CASE ZVelocity4TB

        CASE Body5LB

        CASE BodyMass5TB

        CASE XPosition5TB

        CASE YPosition5TB

        CASE ZPosition5TB

        CASE XVelocity5TB

        CASE YVelocity5TB

        CASE ZVelocity5TB

        CASE Body6LB

        CASE BodyMass6TB

        CASE XPosition6TB

        CASE YPosition6TB

        CASE ZPosition6TB

        CASE XVelocity6TB

        CASE YVelocity6TB

        CASE ZVelocity6TB

        CASE Body7LB

        CASE BodyMass7TB

        CASE XPosition7TB

        CASE YPosition7TB

        CASE ZPosition7TB

        CASE XVelocity7TB

        CASE YVelocity7TB

        CASE ZVelocity7TB

        CASE Body8LB

        CASE BodyMass8TB

        CASE XPosition8TB

        CASE YPosition8TB

        CASE ZPosition8TB

        CASE XVelocity8TB

        CASE YVelocity8TB

        CASE ZVelocity8TB

        CASE Body9LB

        CASE BodyMass9TB

        CASE XPosition9TB

        CASE YPosition9TB

        CASE ZPosition9TB

        CASE XVelocity9TB

        CASE YVelocity9TB

        CASE ZVelocity9TB

        CASE Body10LB

        CASE BodyMass10TB

        CASE XPosition10TB

        CASE YPosition10TB

        CASE ZPosition10TB

        CASE XVelocity10TB

        CASE YVelocity10TB

        CASE ZVelocity10TB

        CASE Body11LB

        CASE BodyMass11TB

        CASE XPosition11TB

        CASE YPosition11TB

        CASE ZPosition11TB

        CASE XVelocity11TB

        CASE YVelocity11TB

        CASE ZVelocity11TB

        CASE NumberOfBodiesLB

        CASE NumberOfBodiesTB

        CASE MaximumMassLB

        CASE MaximumMassTB

        CASE MaximumDistanceLB

        CASE MaximumDistanceTB

        CASE MaximumSpeedLB

        CASE MaximumSpeedTB

        CASE StepTimeLB

        CASE StepTimeSecTB

        CASE CollisionDistanceLB

        CASE CollisionDistanceTB

        CASE AllowCollisionsCB

        CASE AllowComputertoSetCB

        CASE toSetValuesLB

        CASE ProgressBar1

        CASE ViewingTrackBar

        CASE ZeroDegLB

        CASE Minus180LB

        CASE Plus180LB

        CASE TimeLimitRB

        CASE CyclesLimitRB

        CASE NumberofMinutesLB

        CASE NumberofMinutesTB

        CASE NumberofHoursLB

        CASE NumberofHoursTB

        CASE NumberofCyclesTB

        CASE NumberofCyclesLB

        CASE StepTimeMinTB

        CASE StepTimeHrTB

        CASE StepTimeHrLB

        CASE StepTimeMinsLB

        CASE StepTimeSecsLB

        CASE ElapsedTime1TB

        CASE ElapsedTime2TB

        CASE ElapsedTime1LB

        CASE ElapsedTime2LB

        CASE SolarSystemLB

        CASE ManualInputLB

        CASE GravitationalCollapseLB

        CASE LoadFromFileLB

        CASE ElapsedTimeLB

        CASE DemonstrationLB

        CASE ResetBT

        CASE EnergyLB

        CASE EnergyTB

        CASE DemoLabel1LB

        CASE TraceBT

        CASE ClearBT

        CASE DemoLabel2LB

        CASE ZoomInBT

        CASE ZoomOutBT

    END SELECT
END SUB

SUB __UI_KeyPress (id AS LONG)
    'When this event is fired, __UI_KeyHit will contain the code of the key hit.
    'You can change it and even cancel it by making it = 0
    IF __UI_KeyHit = 27 AND NOT Paused%% THEN 'Esc key
        IF DoCalc%% THEN
            'CALL UpdateDisp
            Control(PauseBT).Disabled = True
            CALL ThisIsAnExParrot
        ELSE
            SYSTEM
        END IF
    ELSEIF __UI_KeyHit = 13 THEN 'CR
        CtrlIndex% = 1
        AtIndex%% = False
        WHILE NOT AtIndex%%
            IF ControlIndex&(CtrlIndex%) = id THEN
                AtIndex%% = True
            ELSE
                CtrlIndex% = CtrlIndex% + 1
            END IF
        WEND
        SELECT CASE CtrlIndex% 'id
            CASE 89 'HowManyBodiesTB
                IF VAL(Text(id)) >= 2 AND VAL(Text(id)) <= 11 THEN
                    Control(BodyDataFR).Hidden = False
                    Index% = VAL(Text(id))
                    FOR M% = 3 TO 11
                        IF Index% < M% THEN
                            FOR K% = 8 * M% - 7 TO 8 * M%
                                Control(ControlIndex&(K%)).Hidden = True
                            NEXT K%
                        ELSE
                            FOR K% = 8 * M% - 7 TO 8 * M%
                                Control(ControlIndex&(K%)).Hidden = False
                            NEXT K%
                        END IF
                    NEXT M%
                    SetFocus BodyMass1TB 'NB SetFocus changes the value of id
                ELSE
                    AA& = MessageBox("Value From 2 to 11 Required", "", 0)
                END IF
            CASE 2, 10, 18, 26, 34, 42, 50, 58, 66, 74, 82 'BodyMass1TB, BodyMass2TB, BodyMass3TB, BodyMass4TB, BodyMass5TB, BodyMass6TB, BodyMass7TB, BodyMass8TB, BodyMass9TB, BodyMass10TB, BodyMass11TB
                IF VAL(Text(id)) <= 5E31 AND VAL(Text(id)) > 0 THEN
                    SetFocus ControlIndex&(CtrlIndex% + 1)
                ELSE
                    AA& = MessageBox("Value < 5E31 Required", "", 0)
                END IF
            CASE 3 TO 5, 11 TO 13, 19 TO 21, 27 TO 29, 35 TO 37, 43 TO 45, 51 TO 53, 59 TO 61, 67 TO 69, 75 TO 77, 83 TO 85 'XPosition1TB ,YPosition1TB, ZPosition1TB et cetera
                IF VAL(Text(id)) >= -5E14 AND VAL(Text(id)) <= 5E14 THEN
                    SetFocus ControlIndex&(CtrlIndex% + 1)
                ELSE
                    AA& = MessageBox("Value From -5E14 To 5E14 Required", "", 0)
                END IF
            CASE 6 TO 8, 14 TO 16, 22 TO 24, 30 TO 32, 38 TO 40, 46 TO 48, 54 TO 56, 62 TO 64, 70 TO 72, 78 TO 80, 86 TO 88 'XVelocity1TB ,YVelocity1TB, ZVelocity1TB et cetera
                IF VAL(Text(id)) >= -50000 AND VAL(Text(id)) <= 50000 THEN
                    IF CtrlIndex% = 88 THEN
                        'Do nothing
                    ELSEIF CtrlIndex% MOD 8 = 0 THEN
                        SetFocus ControlIndex&(CtrlIndex% + 2)
                    ELSE
                        SetFocus ControlIndex&(CtrlIndex% + 1)
                    END IF
                ELSE
                    AA& = MessageBox("Value From -50000 To 50000 Required", "", 0)
                END IF
            CASE 90 'NumberOfBodiesTB
                IF VAL(Text(id)) >= 3 AND VAL(Text(id)) <= 512 THEN
                    SetFocus MaximumMassTB
                ELSE
                    AA& = MessageBox("Value From 3 To 512 Required", "", 0)
                END IF
            CASE 91 'MaximumMassTB
                IF VAL(Text(id)) <= 3E26 AND VAL(Text(id)) > 0 THEN
                    SetFocus MaximumDistanceTB
                ELSE
                    AA& = MessageBox("Value Below 3E26 Required", "", 0)
                END IF
            CASE 92 'MaximumDistanceTB
                Text(id) = Minus1$(Text(id))
                IF VAL(Text(id)) <= 5E14 THEN
                    SetFocus MaximumSpeedTB
                ELSE
                    AA& = MessageBox("Value Below 5E14 Required", "", 0)
                END IF
            CASE 93 'MaximumSpeedTB
                Text(id) = Minus1$(Text(id))
                IF VAL(Text(id)) <= 500 THEN
                    'Do nothing
                ELSE
                    AA& = MessageBox("Value Below 500 Required", "", 0)
                END IF
            CASE 94 TO 97 'GravitationalConstantTB, StepTimeHrTB, StepTimeMinTB, StepTimeSecTB
                'For these and next case, convert any negative or blank entries to zero
                Text(id) = Minus1$(Text(id))
                Update%% = True
            CASE 98 TO 101 'CollisionDistanceTB, NumberofMinutesTB, NumberofHoursTB, NumberofCyclesTB
                Text(id) = Minus1$(Text(id))
        END SELECT
    END IF
END SUB

SUB __UI_TextChanged (id AS LONG)
    SELECT CASE id
        CASE GravitationalConstantTB

        CASE HowManyBodiesTB

        CASE BodyMass1TB

        CASE XPosition1TB

        CASE YPosition1TB

        CASE ZPosition1TB

        CASE XVelocity1TB

        CASE YVelocity1TB

        CASE ZVelocity1TB

        CASE BodyMass2TB

        CASE XPosition2TB

        CASE YPosition2TB

        CASE ZPosition2TB

        CASE XVelocity2TB

        CASE YVelocity2TB

        CASE ZVelocity2TB

        CASE BodyMass3TB

        CASE XPosition3TB

        CASE YPosition3TB

        CASE ZPosition3TB

        CASE XVelocity3TB

        CASE YVelocity3TB

        CASE ZVelocity3TB

        CASE BodyMass4TB

        CASE XPosition4TB

        CASE YPosition4TB

        CASE ZPosition4TB

        CASE XVelocity4TB

        CASE YVelocity4TB

        CASE ZVelocity4TB

        CASE BodyMass5TB

        CASE XPosition5TB

        CASE YPosition5TB

        CASE ZPosition5TB

        CASE XVelocity5TB

        CASE YVelocity5TB

        CASE ZVelocity5TB

        CASE BodyMass6TB

        CASE XPosition6TB

        CASE YPosition6TB

        CASE ZPosition6TB

        CASE XVelocity6TB

        CASE YVelocity6TB

        CASE ZVelocity6TB

        CASE BodyMass7TB

        CASE XPosition7TB

        CASE YPosition7TB

        CASE ZPosition7TB

        CASE XVelocity7TB

        CASE YVelocity7TB

        CASE ZVelocity7TB

        CASE BodyMass8TB

        CASE XPosition8TB

        CASE YPosition8TB

        CASE ZPosition8TB

        CASE XVelocity8TB

        CASE YVelocity8TB

        CASE ZVelocity8TB

        CASE BodyMass9TB

        CASE XPosition9TB

        CASE YPosition9TB

        CASE ZPosition9TB

        CASE XVelocity9TB

        CASE YVelocity9TB

        CASE ZVelocity9TB

        CASE BodyMass10TB

        CASE XPosition10TB

        CASE YPosition10TB

        CASE ZPosition10TB

        CASE XVelocity10TB

        CASE YVelocity10TB

        CASE ZVelocity10TB

        CASE BodyMass11TB

        CASE XPosition11TB

        CASE YPosition11TB

        CASE ZPosition11TB

        CASE XVelocity11TB

        CASE YVelocity11TB

        CASE ZVelocity11TB

        CASE NumberOfBodiesTB

        CASE MaximumMassTB

        CASE MaximumDistanceTB

        CASE MaximumSpeedTB

        CASE StepTimeSecTB

        CASE CollisionDistanceTB

        CASE NumberofMinutesTB

        CASE NumberofHoursTB

        CASE NumberofCyclesTB

        CASE StepTimeMinTB

        CASE StepTimeHrTB

        CASE ElapsedTime1TB

        CASE ElapsedTime2TB

        CASE EnergyTB

    END SELECT
END SUB

SUB __UI_ValueChanged (id AS LONG)
    SELECT CASE id
        CASE SolarSystemRB

        CASE BodyManualRB

        CASE GravitationalCollapseRB

        CASE LoadFromFileRB

        CASE DemonstrationRB

        CASE AllowCollisionsCB

        CASE AllowComputertoSetCB

        CASE TimeLimitRB

        CASE CyclesLimitRB

        CASE ViewingTrackBar
            ViewingAngle! = Control(ViewingTrackBar).Value * _PI / 180
            CosAng! = COS(ViewingAngle!)
            SinAng! = SIN(ViewingAngle!)
            BeginDraw PictureBox1
            CLS
            EndDraw PictureBox1
    END SELECT
END SUB

SUB __UI_FormResized
END SUB

': Additional Subroutines ----------------------------------------------------------------------

SUB UpdateDisp ' Update data displays
    IF NOT Control(SolarSystemRB).Value THEN CALL CentreOfMass 'Could make exception for demo as well (not implemented)
    IF NOT EFrameClick%% THEN
        Text(EnergyTB) = DispEnery$
    ELSE
        Text(EnergyTB) = MakeText$(NoBodiesLess1% + 1)
    END IF
    CALL ElapsedTime
END SUB

SUB SetCtrlIndex ' Assign index values to all controls
    ControlIndex&(1) = Body1LB: ControlIndex&(2) = BodyMass1TB
    ControlIndex&(3) = XPosition1TB: ControlIndex&(4) = YPosition1TB: ControlIndex&(5) = ZPosition1TB
    ControlIndex&(6) = XVelocity1TB: ControlIndex&(7) = YVelocity1TB: ControlIndex&(8) = ZVelocity1TB
    ControlIndex&(9) = Body2LB: ControlIndex&(10) = BodyMass2TB
    ControlIndex&(11) = XPosition2TB: ControlIndex&(12) = YPosition2TB: ControlIndex&(13) = ZPosition2TB
    ControlIndex&(14) = XVelocity2TB: ControlIndex&(15) = YVelocity2TB: ControlIndex&(16) = ZVelocity2TB
    ControlIndex&(17) = Body3LB: ControlIndex&(18) = BodyMass3TB
    ControlIndex&(19) = XPosition3TB: ControlIndex&(20) = YPosition3TB: ControlIndex&(21) = ZPosition3TB
    ControlIndex&(22) = XVelocity3TB: ControlIndex&(23) = YVelocity3TB: ControlIndex&(24) = ZVelocity3TB
    ControlIndex&(25) = Body4LB: ControlIndex&(26) = BodyMass4TB
    ControlIndex&(27) = XPosition4TB: ControlIndex&(28) = YPosition4TB: ControlIndex&(29) = ZPosition4TB
    ControlIndex&(30) = XVelocity4TB: ControlIndex&(31) = YVelocity4TB: ControlIndex&(32) = ZVelocity4TB
    ControlIndex&(33) = Body5LB: ControlIndex&(34) = BodyMass5TB
    ControlIndex&(35) = XPosition5TB: ControlIndex&(36) = YPosition5TB: ControlIndex&(37) = ZPosition5TB
    ControlIndex&(38) = XVelocity5TB: ControlIndex&(39) = YVelocity5TB: ControlIndex&(40) = ZVelocity5TB
    ControlIndex&(41) = Body6LB: ControlIndex&(42) = BodyMass6TB
    ControlIndex&(43) = XPosition6TB: ControlIndex&(44) = YPosition6TB: ControlIndex&(45) = ZPosition6TB
    ControlIndex&(46) = XVelocity6TB: ControlIndex&(47) = YVelocity6TB: ControlIndex&(48) = ZVelocity6TB
    ControlIndex&(49) = Body7LB: ControlIndex&(50) = BodyMass7TB
    ControlIndex&(51) = XPosition7TB: ControlIndex&(52) = YPosition7TB: ControlIndex&(53) = ZPosition7TB
    ControlIndex&(54) = XVelocity7TB: ControlIndex&(55) = YVelocity7TB: ControlIndex&(56) = ZVelocity7TB
    ControlIndex&(57) = Body8LB: ControlIndex&(58) = BodyMass8TB
    ControlIndex&(59) = XPosition8TB: ControlIndex&(60) = YPosition8TB: ControlIndex&(61) = ZPosition8TB
    ControlIndex&(62) = XVelocity8TB: ControlIndex&(63) = YVelocity8TB: ControlIndex&(64) = ZVelocity8TB
    ControlIndex&(65) = Body9LB: ControlIndex&(66) = BodyMass9TB
    ControlIndex&(67) = XPosition9TB: ControlIndex&(68) = YPosition9TB: ControlIndex&(69) = ZPosition9TB
    ControlIndex&(70) = XVelocity9TB: ControlIndex&(71) = YVelocity9TB: ControlIndex&(72) = ZVelocity9TB
    ControlIndex&(73) = Body10LB: ControlIndex&(74) = BodyMass10TB
    ControlIndex&(75) = XPosition10TB: ControlIndex&(76) = YPosition10TB: ControlIndex&(77) = ZPosition10TB
    ControlIndex&(78) = XVelocity10TB: ControlIndex&(79) = YVelocity10TB: ControlIndex&(80) = ZVelocity10TB
    ControlIndex&(81) = Body11LB: ControlIndex&(82) = BodyMass11TB
    ControlIndex&(83) = XPosition11TB: ControlIndex&(84) = YPosition11TB: ControlIndex&(85) = ZPosition11TB
    ControlIndex&(86) = XVelocity11TB: ControlIndex&(87) = YVelocity11TB: ControlIndex&(88) = ZVelocity11TB
    ControlIndex&(89) = HowManyBodiesTB: ControlIndex&(90) = NumberOfBodiesTB
    ControlIndex&(91) = MaximumMassTB: ControlIndex&(92) = MaximumDistanceTB: ControlIndex&(93) = MaximumSpeedTB
    ControlIndex&(94) = GravitationalConstantTB
    ControlIndex&(95) = StepTimeHrTB: ControlIndex&(96) = StepTimeMinTB: ControlIndex&(97) = StepTimeSecTB
    ControlIndex&(98) = CollisionDistanceTB
    ControlIndex&(99) = NumberofMinutesTB: ControlIndex&(100) = NumberofHoursTB: ControlIndex&(101) = NumberofCyclesTB
END SUB

SUB SetStep ' Convert Simulation Step into seconds
    Deltat& = 3600 * VAL(Text(StepTimeHrTB)) + 60 * VAL(Text(StepTimeMinTB)) + VAL(Text(StepTimeSecTB))
    IF Deltat& = 0 THEN
        Deltat& = 1
        Text(StepTimeSecTB) = "1"
    END IF
END SUB

SUB Zoomer (Z%%) ' Zoom in or out
    IF Z%% THEN
        Zoom! = Zoom! / SQR(2)
    ELSE
        Zoom! = Zoom! * SQR(2)
    END IF
    BeginDraw PictureBox1
    CLS
    EndDraw PictureBox1
END SUB

SUB Refresh (IJ%) ' Set Control values dependent upon input data
    IF IJ% = 4 THEN
        Control(SimulationLimitTypeFR).Hidden = True
        Control(SimulationLimitTimeFR).Hidden = True
        Control(ViewingTrackBar).Disabled = True
        Control(GravitationalConstantTB).Disabled = True
        Control(StepTimeSecTB).Disabled = True
        Control(StepTimeMinTB).Disabled = True
        Control(StepTimeHrTB).Disabled = True
        Control(DemonstrationLB).Hidden = False
        SetRadioButtonValue CyclesLimitRB
        NoBodiesLess1% = 10
        Text(StepTimeSecTB) = "10"
        Text(StepTimeHrTB) = "0"
        Text(NumberofCyclesTB) = "625000"
        Text(GravitationalConstantTB) = "6.67385E-11"
        SetFocus ExecuteBT
    ELSE
        Control(SimulationLimitTypeFR).Hidden = False
        Control(SimulationLimitTimeFR).Hidden = False
        Control(ViewingTrackBar).Disabled = False
        Control(GravitationalConstantTB).Disabled = False
        Control(StepTimeSecTB).Disabled = False
        Control(StepTimeMinTB).Disabled = False
        Control(StepTimeHrTB).Disabled = False
        Control(DemonstrationLB).Hidden = True
        SetRadioButtonValue TimeLimitRB
        Text(NumberofCyclesTB) = "100000"
    END IF
    IF IJ% = 3 OR IJ% = 2 THEN
        Control(CollisionsFR).Hidden = False
        Control(CollisionDistanceFR).Hidden = False
        ViewingAngle! = 0
    ELSE
        Control(CollisionsFR).Hidden = True
        Control(CollisionDistanceFR).Hidden = True
        ViewingAngle! = -.1570787
    END IF
    IF IJ% = 3 THEN
        Control(GravitationalCollapseFR).Hidden = False
        Control(GravitationalCollapseLB).Hidden = False
        Control(AllowCollisionsCB).Value = True
        NoBodiesLess1% = VAL(Text(NumberOfBodiesTB)) - 1
        Text(StepTimeSecTB) = "0"
        Text(StepTimeHrTB) = "24"
        Text(NumberofMinutesTB) = "0"
        Text(NumberofHoursTB) = "1"
        Text(GravitationalConstantTB) = "6.67385E-11"
        SetFocus NumberOfBodiesTB
    ELSE
        Control(GravitationalCollapseFR).Hidden = True
        Control(GravitationalCollapseLB).Hidden = True
        Control(AllowCollisionsCB).Value = False 'Default for all except Collapse will be no collisions
        Text(NumberofMinutesTB) = "10"
        Text(NumberofHoursTB) = "0"
    END IF
    IF IJ% = 2 THEN
        Control(HowManyBodiesFR).Hidden = False
        Control(AllowCollisionsCB).Disabled = False
        Control(ManualInputLB).Hidden = False
        NoBodiesLess1% = VAL(Text(HowManyBodiesTB)) - 1
        Text(StepTimeSecTB) = "1"
        Text(StepTimeHrTB) = "0"
        SetFocus HowManyBodiesTB
    ELSE
        Control(HowManyBodiesFR).Hidden = True
        Control(AllowCollisionsCB).Disabled = True
        Control(ManualInputLB).Hidden = True
    END IF
    IF IJ% = 1 THEN
        Control(SolarSystemLB).Hidden = False
        NoBodiesLess1% = 11
        Text(StepTimeSecTB) = "0"
        Text(StepTimeHrTB) = "1"
        Text(GravitationalConstantTB) = "6.67385E-11"
        Control(ExecuteBT).Disabled = False
        SetFocus ExecuteBT
    ELSE
        Control(SolarSystemLB).Hidden = True
    END IF
    Control(SimulationLimitCyclesFR).Hidden = True
    Control(BodyDataFR).Hidden = True
    Control(LoadFromFileLB).Hidden = True
    Text(CollisionDistanceTB) = "1E6"
    Text(StepTimeMinTB) = "0"
    Control(ViewingTrackBar).Value = ViewingAngle! * 180 / _PI
    EFrameClick%% = False
    Caption(EnergyLB) = "Energy"
    Text(EnergyTB) = "0"
    CALL ZeroTime
END SUB

SUB CentreOfMass 'Centre of mass adjustment & zero net momentums
    TotMass# = 0
    MRx# = 0: MRy# = 0: MRz# = 0
    Px# = 0: Py# = 0: Pz# = 0
    FOR N% = 0 TO NoBodiesLess1%
        TotMass# = TotMass# + Galaxy#(N%, 0)
        MRx# = MRx# + Galaxy#(N%, 1) * Galaxy#(N%, 0)
        MRy# = MRy# + Galaxy#(N%, 2) * Galaxy#(N%, 0)
        MRz# = MRz# + Galaxy#(N%, 3) * Galaxy#(N%, 0)
        Px# = Galaxy#(N%, 0) * Galaxy#(N%, 4) + Px#
        Py# = Galaxy#(N%, 0) * Galaxy#(N%, 5) + Py#
        Pz# = Galaxy#(N%, 0) * Galaxy#(N%, 6) + Pz#
    NEXT N%
    FOR N% = 0 TO NoBodiesLess1%
        Galaxy#(N%, 1) = Galaxy#(N%, 1) - (MRx# / TotMass#)
        Galaxy#(N%, 2) = Galaxy#(N%, 2) - (MRy# / TotMass#)
        Galaxy#(N%, 3) = Galaxy#(N%, 3) - (MRz# / TotMass#)
        Galaxy#(N%, 4) = Galaxy#(N%, 4) - (Px# / TotMass#)
        Galaxy#(N%, 5) = Galaxy#(N%, 5) - (Py# / TotMass#)
        Galaxy#(N%, 6) = Galaxy#(N%, 6) - (Pz# / TotMass#)
    NEXT N%
END SUB

SUB ToDisp (Xin!, Yin!, Zin!, Udim%, Vdim%, CSize%%) ' Convert x-, y-, z- into screen positions (_MAPTRIANGLE(3D) not available)
    'x- from Left to Right, y- from Bottom to Top, z- from Into to Out Of screen
    'Directions are as in input.  Order of calculation array (galaxy()) not in x-,y-,z-
    Z! = Zin! / Zoom!: X! = Xin! / Zoom!: Y! = -Yin! / Zoom!
    'Rotate before perspective around x-axis
    Y0! = Y!
    Y! = Y! * CosAng! - Z! * SinAng!
    Z! = Z! * CosAng! + SinAng! * Y0!
    'Transform for perspective view
    Z1! = Z! + Origin&
    IF Z1! < -1.0E-20 THEN 'Display only points in front of view and avoid divide by zero
        Udim% = CINT((Uscreen% / 2) + (X! * Persp& / Z1!))
        Vdim% = CINT((Vscreen% / 2) + (Y! * Persp& / Z1!))
        C! = (2 * Z!) / Vscreen%
        IF C! > 8 THEN 'Next lines required to prevent integer out of range
            CSize%% = 11
        ELSEIF C! < -3 THEN
            CSize%% = 0
        ELSE
            CSize%% = 3 + CINT(C!)
        END IF
    ELSE
        Udim% = -1
    END IF
END SUB

SUB ElapsedTime 'Set Elapsed Time Labels
    STATIC DispYears%%, DispDays%%, DispHours%%
    IF TotYears& >= 1 THEN
        IF NOT DispYears%% THEN
            Caption(ElapsedTime1LB) = "Years"
            Caption(ElapsedTime2LB) = "Days"
            DispYears%% = True
        END IF
        Text(ElapsedTime1TB) = MakeText$(TotYears&)
        Text(ElapsedTime2TB) = MakeText$(TotDays&)
    ELSEIF TotDays& >= 1 THEN
        IF NOT DispDays%% THEN
            Caption(ElapsedTime1LB) = "Days"
            Caption(ElapsedTime2LB) = "Hrs"
            DispDays%% = True
        END IF
        Text(ElapsedTime1TB) = MakeText$(TotDays&)
        Text(ElapsedTime2TB) = MakeText$(TotHrs&)
    ELSEIF TotHrs& >= 1 THEN
        IF NOT DispHours%% THEN
            Caption(ElapsedTime1LB) = "Hours"
            Caption(ElapsedTime2LB) = "Mins"
            DispHours%% = True
        END IF
        Text(ElapsedTime1TB) = MakeText$(TotHrs&)
        Text(ElapsedTime2TB) = MakeText$(TotMins&)
    ELSE
        Text(ElapsedTime1TB) = MakeText$(TotMins&)
        Text(ElapsedTime2TB) = MakeText$(TotSecs&)
    END IF
    IF NOT DoCalc%% THEN
        DispYears%% = False: DispDays%% = False: DispHours%% = False
    END IF
END SUB

SUB ZeroTime 'Set simulation time to zero
    TotSecs& = 0: TotMins& = 0: TotHrs& = 0: TotDays& = 0: TotYears& = 0
    CALL ElapsedTime
    Caption(ElapsedTime1LB) = "Minutes"
    Caption(ElapsedTime2LB) = "Secs"
END SUB

SUB Execute 'Do the simulation
    WHILE DoCalc%% AND NOT Paused%%
        IF Control(DemonstrationRB).Value THEN _LIMIT 2500
        IF Control(AllowCollisionsCB).Value THEN 'Calculate Collisions
            I% = 0
            WHILE I% <= NoBodiesLess1% - 1
                J% = (I% + 1)
                WHILE J% <= NoBodiesLess1%
                    IF (((Galaxy#(J%, 1) - Galaxy#(I%, 1)) ^ 2 + (Galaxy#(J%, 2) - Galaxy#(I%, 2)) ^ 2 + (Galaxy#(J%, 3) - Galaxy#(I%, 3)) ^ 2) < Coalesce!) THEN
                        Collided%% = True
                        CombMass# = Galaxy#(I%, 0) + Galaxy#(J%, 0)
                        FOR K% = 1 TO 3
                            Galaxy#(I%, 3 + K%) = (((Galaxy#(J%, 3 + K%) * Galaxy#(J%, 0)) + (Galaxy#(I%, 3 + K%) * Galaxy#(I%, 0))) / CombMass#)
                            Galaxy#(I%, K%) = ((Galaxy#(J%, K%) * Galaxy#(J%, 0)) + (Galaxy#(I%, K%) * Galaxy#(I%, 0))) / CombMass#
                        NEXT K%
                        'Remove absorbed bodies from display
                        IF J% < NoBodiesLess1% THEN
                            FOR J1% = J% TO NoBodiesLess1% - 1
                                FOR K% = 0 TO 6
                                    Galaxy#(J1%, K%) = Galaxy#(J1% + 1, K%)
                                NEXT K%
                                Spectrum~&(J1%) = Spectrum~&(J1% + 1)
                            NEXT J1%
                        END IF
                        NoBodiesLess1% = NoBodiesLess1% - 1
                        Galaxy#(I%, 0) = CombMass#
                    ELSE
                        J% = J% + 1
                    END IF
                WEND
                I% = I% + 1
            WEND
        END IF
        FOR I% = 0 TO NoBodiesLess1% 'This and next FOR/NEXT adjust to half-distance in gravitation calc - required to conserve energy
            FOR K% = 0 TO 2: Deltav#(K%) = 0: NEXT K%
            FOR J% = 0 TO NoBodiesLess1%
                IF I% <> J% THEN
                    Rij# = (Galaxy#(J%, 0)) / (((Galaxy#(J%, 1) - Galaxy#(I%, 1)) ^ 2 + (Galaxy#(J%, 2) - Galaxy#(I%, 2)) ^ 2 + (Galaxy#(J%, 3) - Galaxy#(I%, 3)) ^ 2) ^ 1.5)
                    FOR K% = 0 TO 2
                        Deltav#(K%) = Deltav#(K%) + (Rij# * (Galaxy#(J%, K% + 1) - Galaxy#(I%, K% + 1)))
                    NEXT K%
                END IF
            NEXT J%
            FOR K% = 0 TO 2
                Deltav#(K%) = Deltav#(K%) * Deltat& * Gravity! / 2
                Deltad#(I%, K%) = Deltat& * (Galaxy#(I%, 4 + K%) + (Deltav#(K%) / 2)) / 2
                Galaxy#(I%, 7 + K%) = Galaxy#(I%, 1 + K%) + Deltad#(I%, K%)
            NEXT K%
        NEXT I%
        FOR I% = 0 TO NoBodiesLess1% 'FIO This and next FOR/NEXT calculate the gravitational attractions between all bodies
            FOR K% = 0 TO 2
                Deltav#(K%) = 0
            NEXT K%
            FOR J% = 0 TO NoBodiesLess1%
                IF I% <> J% THEN
                    Rij# = (Galaxy#(J%, 0)) / (((Galaxy#(J%, 7) - Galaxy#(I%, 7)) ^ 2 + (Galaxy#(J%, 8) - Galaxy#(I%, 8)) ^ 2 + (Galaxy#(J%, 9) - Galaxy#(I%, 9)) ^ 2) ^ 1.5)
                    FOR K% = 0 TO 2
                        Deltav#(K%) = Deltav#(K%) + (Rij# * (Galaxy#(J%, K% + 7) - Galaxy#(I%, K% + 7)))
                    NEXT K%
                END IF
            NEXT J%
            FOR K% = 0 TO 2
                Deltav#(K%) = Deltav#(K%) * Deltat& * Gravity!
                Deltad#(I%, K%) = Deltat& * (Galaxy#(I%, 4 + K%) + (Deltav#(K%) / 2))
                Galaxy#(I%, 4 + K%) = Galaxy#(I%, 4 + K%) + Deltav#(K%)
            NEXT K%
        NEXT I%
        intNoDisplayed% = 0
        FOR I% = 0 TO NoBodiesLess1%
            FOR K% = 0 TO 2
                Galaxy#(I%, 1 + K%) = Galaxy#(I%, 1 + K%) + Deltad#(I%, K%)
            NEXT K%
        NEXT I%
        IF Control(DemonstrationRB).Value THEN CALL DemoRoutine ' This routine is contained in democode.bas
        NoCycles& = NoCycles& + 1
        TotSecs& = Deltat& + TotSecs&
        CarryMins& = TotSecs& \ 60
        TotSecs& = TotSecs& MOD 60
        TotMins& = TotMins& + CarryMins&
        CarryHrs& = TotMins& \ 60
        TotMins& = TotMins& MOD 60
        TotHrs& = TotHrs& + CarryHrs&
        CarryDays& = TotHrs& \ 24
        TotHrs& = TotHrs& MOD 24
        TotDays& = TotDays& + CarryDays&
        IF TotYears& MOD 4 = 0 THEN
            CarryYears& = TotDays& \ 366
            TotDays& = TotDays& MOD 366
            TotYears& = TotYears& + CarryYears&
        ELSE
            CarryYears& = TotDays& \ 365
            TotDays& = TotDays& MOD 365
            TotYears& = TotYears& + CarryYears&
        END IF
        ' The following checks for simulation reaching end (as opposed to being stopped by Execute Button)
        IF Control(TimeLimitRB).Value THEN
            IF TIMER > StartCalc! + TimeLimit! THEN
                CALL ThisIsAnExParrot
                Caption(PauseBT) = "Continue"
            END IF
        ELSEIF NoCycles& > CyclesLimit& THEN
            Caption(PauseBT) = "Continue"
            CALL ThisIsAnExParrot
        END IF
        __UI_DoEvents
    WEND
END SUB

SUB ThisIsAnExParrot 'Complete Simulation
    CALL UpdateDisp
    DoCalc%% = False
    Caption(ExecuteBT) = "Execute"
    Control(ExecuteBT).Disabled = True
    Control(ResetBT).Disabled = False
    Control(ClearBT).Disabled = True
    Control(TraceBT).Disabled = True
    Control(ProgressBar1).Value = 100
    Control(CollisionDistanceFR).Top = 368
    Control(CollisionDistanceFR).Left = 150
    Control(CollisionDistanceFR).Hidden = True
    Control(CollisionDistanceTB).Disabled = False
    IF Control(DemonstrationRB).Value THEN
        Control(PauseBT).Disabled = True
    ELSE
        OPEN "mbpfile.dat" FOR OUTPUT AS #1
        IF Control(AllowCollisionsCB).Value THEN
            WRITE #1, Coalesce!
        ELSE
            WRITE #1, False
        END IF
        WRITE #1, Text(StepTimeSecTB), Text(StepTimeMinTB), Text(StepTimeHrTB)
        WRITE #1, Control(TimeLimitRB).Value, Text(NumberofMinutesTB), Text(NumberofHoursTB), Text(NumberofCyclesTB)
        WRITE #1, Text(GravitationalConstantTB), Zoom!, ViewingAngle!
        WRITE #1, NoBodiesLess1%, StartEnergy!, TotSecs&, TotMins&, TotHrs&, TotDays&, TotYears&
        FOR I% = 0 TO NoBodiesLess1%
            WRITE #1, Galaxy#(I%, 0), Galaxy#(I%, 1), Galaxy#(I%, 2), Galaxy#(I%, 3), Galaxy#(I%, 4), Galaxy#(I%, 5), Galaxy#(I%, 6)
            IF I% <= 11 THEN
                PRINT #1, Spectrum~&(I%)
            END IF
        NEXT I%
        CLOSE #1
    END IF
    IF Control(AllowCollisionsCB).Value THEN Control(CollisionDistanceFR).Disabled = False
    SetFocus ResetBT
END SUB

SUB SolarFill ' Define 12-body Solar System. Earth with man-made satellite, or Jupiter with Elara
    DoCalc%% = True
    ViewingAngle! = -.1570787
    'The Sun
    Galaxy#(0, 0) = 1.98892D+30
    Galaxy#(0, 3) = -45060184.4135256 'JPL x-
    Galaxy#(0, 1) = -380053430.1588 'JPL y-
    Galaxy#(0, 2) = -9547814.61930877 'JPL z-
    Galaxy#(0, 6) = 10.9331590936 'JPL vx-
    Galaxy#(0, 4) = 0.4928152448 'JPL vy-
    Galaxy#(0, 5) = -0.2479066749 'JPL vz-
    Spectrum~&(0) = _RGB(255, 255, 0)
    'Mercury
    Galaxy#(1, 0) = 3.5845D+23
    Galaxy#(1, 3) = -59131303477.6583
    Galaxy#(1, 1) = -11212867533.1628
    Galaxy#(1, 2) = 4526603016.0395
    Galaxy#(1, 6) = -1328.6289174688
    Galaxy#(1, 4) = -45819.162419675
    Galaxy#(1, 5) = -3621.0957936921
    Spectrum~&(1) = _RGB(187, 197, 250)
    'Venus
    Galaxy#(2, 0) = 4.8988D+24
    Galaxy#(2, 3) = -55419994071.3706
    Galaxy#(2, 1) = 91640324648.6316
    Galaxy#(2, 2) = 4447206426.83417
    Galaxy#(2, 6) = -30114.9717683551
    Galaxy#(2, 4) = -18251.8608385596
    Galaxy#(2, 5) = 1488.3046966862
    Spectrum~&(2) = _RGB(255, 165, 50)
    'The Earth
    Galaxy#(3, 0) = 5.9742D+24
    Galaxy#(3, 3) = -36171689178.6047
    Galaxy#(3, 1) = -147845249378.241
    Galaxy#(3, 2) = -4877316.79803054
    Galaxy#(3, 6) = 28470.366606139
    Galaxy#(3, 4) = -7204.9068182243
    Galaxy#(3, 5) = 1.0117834275
    Spectrum~&(3) = _RGB(0, 0, 255)
    'The Moon
    Galaxy#(10, 0) = 7.36D+22
    Galaxy#(10, 3) = -35958075763.303
    Galaxy#(10, 1) = -147502805517.55
    Galaxy#(10, 2) = -12243921.1369571
    Galaxy#(10, 6) = 27655.4229032262
    Galaxy#(10, 4) = -6672.4762717713
    Galaxy#(10, 5) = -86.5562299173
    Spectrum~&(10) = _RGB(220, 220, 192)
    'Earth's Man-made Satellite
    EscVel! = 15915
    Rad1! = 6371000
    Phi! = 0.031831 * 2 * _PI
    Galaxy#(11, 0) = 10.0
    Galaxy#(11, 3) = Galaxy#(3, 3) - Rad1! * COS(Phi!)
    Galaxy#(11, 1) = Galaxy#(3, 1) - Rad1! * SIN(Phi!)
    Galaxy#(11, 2) = Galaxy#(3, 2)
    Galaxy#(11, 6) = Galaxy#(3, 6) + EscVel! * SIN(Phi!)
    Galaxy#(11, 4) = Galaxy#(3, 4) - EscVel! * COS(Phi!)
    Galaxy#(11, 5) = Galaxy#(3, 5)
    Spectrum~&(11) = _RGB(255, 223, 0)
    'Mars
    Galaxy#(4, 0) = 6.4191D+23
    Galaxy#(4, 3) = 122763896894.594
    Galaxy#(4, 1) = 185152754686.098
    Galaxy#(4, 2) = 862386139.161169
    Galaxy#(4, 6) = -19273.3930693473
    Galaxy#(4, 4) = 15435.1398442985
    Galaxy#(4, 5) = 796.5931456433
    Spectrum~&(4) = _RGB(255, 0, 0)
    'Jupiter
    Galaxy#(5, 0) = 1.8991D+27
    Galaxy#(5, 3) = 36484689294.5762
    Galaxy#(5, 1) = 764156963896.202
    Galaxy#(5, 2) = -4002216230.61248
    Galaxy#(5, 6) = -13209.6151190183
    Galaxy#(5, 4) = 1244.4387325709
    Galaxy#(5, 5) = 290.3999934594
    Spectrum~&(5) = _RGB(255, 182, 193)
    ' Jupiter's moon Elara
    IF Control(SolarSystemRB).Value THEN
        PosElara! = 11740000000 ' Data from Wiki mean
        VelElara! = 3375 ' Adjusted to give Elara 16.5 orbits around Jupiter per 1 Jupiter year (3270 from Wiki mean)
        JupiterXY! = SQR((Galaxy#(5, 3) * Galaxy#(5, 3)) + (Galaxy#(5, 1) * Galaxy#(5, 1)))
        Xtra! = SQR((PosElara! * PosElara!) - (Galaxy#(5, 2) * Galaxy#(5, 2)))
        ElaraAangle! = 26.63 * 2 * _PI / 360
        Galaxy#(11, 0) = 8.7E17
        Galaxy#(11, 3) = Galaxy#(5, 3) + (Xtra! * Galaxy#(5, 3) / JupiterXY!)
        Galaxy#(11, 1) = Galaxy#(5, 1) + (Xtra! * Galaxy#(5, 1) / JupiterXY!)
        Galaxy#(11, 2) = 0
        Galaxy#(11, 6) = Galaxy#(5, 6) + (VelElara! * COS(ElaraAangle!))
        Galaxy#(11, 4) = Galaxy#(5, 4)
        Galaxy#(11, 5) = Galaxy#(5, 5) - (VelElara! * SIN(ElaraAangle!))
        Spectrum~&(11) = _RGB(90, 120, 120)
        Zoom! = 3.55E+09
    ELSE
        Zoom! = 78444659
    END IF
    'Saturn
    Galaxy#(6, 0) = 5.6862D+26
    Galaxy#(6, 3) = -1137743472628.19
    Galaxy#(6, 1) = -930563690137.757
    Galaxy#(6, 2) = 61459493361.0232
    Galaxy#(6, 6) = 5590.9655899386
    Galaxy#(6, 4) = -7501.9867646014
    Galaxy#(6, 5) = -91.4835216719
    Spectrum~&(6) = _RGB(172, 172, 172)
    'Uranus
    Galaxy#(7, 0) = 8.6805D+25
    Galaxy#(7, 3) = 2961538003304.16
    Galaxy#(7, 1) = 471730863175.125
    Galaxy#(7, 2) = -36615721753.4685
    Galaxy#(7, 6) = -1121.0490875954
    Galaxy#(7, 4) = 6407.8614841672
    Galaxy#(7, 5) = 38.2499782588
    Spectrum~&(7) = _RGB(153, 196, 230)
    'Neptune
    Galaxy#(8, 0) = 1.0248D+26
    Galaxy#(8, 3) = 4006519954859.65
    Galaxy#(8, 1) = -2017262499546.22
    Galaxy#(8, 2) = -50791394238.2755
    Galaxy#(8, 6) = 2408.858286494
    Galaxy#(8, 4) = 4886.7736426957
    Galaxy#(8, 5) = -156.7770669814
    Spectrum~&(8) = _RGB(65, 105, 225)
    'Pluto (OK, it's not really a planet)
    Galaxy#(9, 0) = 1.195D+22
    Galaxy#(9, 3) = 838244550232.439
    Galaxy#(9, 1) = -4774476349254.01
    Galaxy#(9, 2) = 268428350752.508
    Galaxy#(9, 6) = 5472.2373687464
    Galaxy#(9, 4) = -146.4051347173
    Galaxy#(9, 5) = -1581.3440525726
    Spectrum~&(9) = _RGB(219, 112, 147)
END SUB

SUB BodyManualFill 'Manual Input Data
    IF NOT Control(BodyDataFR).Hidden THEN
        'Manual data entry
        DoCalc%% = True
        IF VAL(Text(HowManyBodiesTB)) < 2 OR VAL(Text(HowManyBodiesTB)) > 11 THEN
            DoCalc%% = False
            AA& = MessageBox("From 2 to 11 Bodies Required", "", 0)
            SetFocus HowManyBodiesTB
        END IF
        IF DoCalc%% THEN
            FOR M% = 2 TO 8 * VAL(Text(HowManyBodiesTB))
                Index% = M% MOD 8
                IF Text(ControlIndex&(M%)) = "" THEN Text(ControlIndex&(M%)) = "0"
                SELECT CASE Index%
                    CASE 2
                        IF VAL(Text(ControlIndex&(M%))) > 5E31 OR VAL(Text(ControlIndex&(M%))) <= 0 THEN
                            DoCalc%% = False
                            AA& = MessageBox("Body Mass Greater Than Zero and Less Than 5E31 Required", "", 0)
                            SetFocus ControlIndex&(M%)
                        END IF
                    CASE 3 TO 5
                        IF VAL(Text(ControlIndex&(M%))) < -5E14 OR VAL(Text(ControlIndex&(M%))) > 5E14 THEN
                            DoCalc%% = False
                            AA& = MessageBox("Body Distance From -5E14 To 5E14 Required", "", 0)
                            SetFocus ControlIndex&(M%)
                        END IF
                    CASE 0, 6, 7
                        IF VAL(Text(ControlIndex&(M%))) < -50000 OR VAL(Text(ControlIndex&(M%))) > 50000 THEN
                            DoCalc%% = False
                            AA& = MessageBox("Body Velocity From -50000 To 50000 Required", "", 0)
                            SetFocus ControlIndex&(M%)
                        END IF
                END SELECT
            NEXT M%
        END IF
        IF DoCalc%% THEN
            'Set Initial Conditions
            NoBodiesLess1% = VAL(Text(HowManyBodiesTB)) - 1
            FOR N% = 0 TO NoBodiesLess1%
                FOR K% = 0 TO 6
                    Galaxy#(N%, K%) = VAL(Text(ControlIndex&((N% * 8) + 2 + K%)))
                    'Previous version has a Select Case, but no longer required.  inputs kept in calculation x-,y-,z- order
                    IF K% >= 1 AND K% <= 3 THEN Galaxy#(N%, K%) = 1000 * Galaxy#(N%, K%)
                NEXT K%
                Spectrum~&(N%) = RedGreenBlue~&
            NEXT N%
            Control(BodyDataFR).Hidden = True
            Control(HowManyBodiesFR).Hidden = True
            CALL CentreOfMass
            Zoom! = 0
            FOR N% = 0 TO NoBodiesLess1%
                Zoom! = Zoom! + SQR(Galaxy#(N%, 1) * Galaxy#(N%, 1) + Galaxy#(N%, 2) * Galaxy#(N%, 2) + Galaxy#(N%, 3) * Galaxy#(N%, 3))
            NEXT N%
            Zoom! = 0.01 * Zoom! / (NoBodiesLess1% + 1)
        END IF
    ELSEIF Control(AllowComputertoSetCB).Value THEN
        ' Computer sets data
        DoCalc%% = True
        Control(HowManyBodiesFR).Hidden = True
        NoBodiesLess1% = VAL(Text(HowManyBodiesTB)) - 1
        TotMass! = 0: Zoom! = 0 'Zoom! =  Calculated Mean distance
        FOR N% = 0 TO NoBodiesLess1%
            Spectrum~&(N%) = RedGreenBlue~&
            Galaxy#(N%, 0) = RND * 3E26
            TotMass! = TotMass! + Galaxy#(N%, 0)
            FOR K% = 1 TO 3
                Galaxy#(N%, K%) = (0.5 - RND) * 1E10 'Distances in m
                Zoom! = Zoom! + SQR(Galaxy#(N%, K%) * Galaxy#(N%, K%))
            NEXT K%
        NEXT N%
        Zoom! = Zoom! / (NoBodiesLess1% + 1)
        OrbitalVel! = SQR(VAL(Text(GravitationalConstantTB)) * TotMass! / Zoom!)
        FOR N% = 0 TO NoBodiesLess1%
            FOR K% = 4 TO 6
                Galaxy#(N%, K%) = 0.3 * (0.5 - RND) * OrbitalVel!
            NEXT K%
        NEXT N%
        Text(CollisionDistanceTB) = MakeText$(Zoom! / 100000) ' Collision distance in km
        Zoom! = 0.001 * Zoom!
        CALL CentreOfMass
    ELSE
        AA& = MessageBox("Please Enter Number of Bodies", "", 0)
        SetFocus HowManyBodiesTB
    END IF
END SUB

SUB CollapseFill ' Up to 512 bodies collapsing under gravity
    DoCalc%% = True
    IF VAL(Text(NumberOfBodiesTB)) < 12 OR VAL(Text(NumberOfBodiesTB)) > 512 THEN
        DoCalc%% = False
        AA& = MessageBox("Number of Bodies From 12 To 512 Required", "", 0)
        SetFocus NumberOfBodiesTB
    ELSEIF VAL(Text(MaximumMassTB)) > 3E26 OR Text(MaximumMassTB) = "" THEN
        DoCalc%% = False
        AA& = MessageBox("Maximum Mass Below 3E26 Required", "", 0)
    ELSEIF VAL(Text(MaximumDistanceTB)) > 5E14 OR Text(MaximumDistanceTB) = "" THEN
        DoCalc%% = False
        AA& = MessageBox("Maximum Distance Below 5E14 Required", "", 0)
        SetFocus MaximumDistanceTB
    ELSEIF VAL(Text(MaximumSpeedTB)) > 500 OR Text(MaximumSpeedTB) = "" THEN
        DoCalc%% = False
        AA& = MessageBox("Maximum Speed Below 500 Required", "", 0)
        SetFocus MaximumSpeedTB
    END IF
    IF DoCalc%% THEN
        Control(GravitationalCollapseFR).Hidden = True
        NoBodiesLess1% = VAL(Text(NumberOfBodiesTB)) - 1
        'Fill Array
        Zoom! = 0
        MaxSpeed! = VAL(Text(MaximumSpeedTB))
        RANDOMIZE (TIMER)
        FOR N% = 0 TO NoBodiesLess1%
            Galaxy#(N%, 0) = 5.0E+22 + (VAL(Text(MaximumMassTB)) * RND)
            Galaxy#(N%, 4) = MaxSpeed! * (0.5 - RND)
            Galaxy#(N%, 5) = MaxSpeed! * (0.5 - RND)
            Galaxy#(N%, 6) = MaxSpeed! * (0.5 - RND)
            Rad2! = 1000 * VAL(Text(MaximumDistanceTB)) 'Input value in km
            InsideSphere%% = False
            WHILE NOT InsideSphere%%
                FOR K% = 1 TO 3
                    Galaxy#(N%, K%) = (0.5 - RND) * 2 * Rad2!
                NEXT K%
                IF SQR(Galaxy#(N%, 1) * Galaxy#(N%, 1) + Galaxy#(N%, 2) * Galaxy#(N%, 2) + Galaxy#(N%, 3) * Galaxy#(N%, 3)) <= Rad2! THEN InsideSphere%% = True
            WEND
            Spectrum~&(N%) = RedGreenBlue~&
            Zoom! = Zoom! + SQR(Galaxy#(N%, 1) * Galaxy#(N%, 1) + Galaxy#(N%, 2) * Galaxy#(N%, 2) + Galaxy#(N%, 3) * Galaxy#(N%, 3))
        NEXT N%
        Zoom! = 0.001 * Zoom! / (NoBodiesLess1% + 1)
        CALL CentreOfMass
    END IF
END SUB

'$INCLUDE:'../../InForm/InForm.ui'
'$INCLUDE:'../../InForm/xp.uitheme'
'$INCLUDE:'../../InForm/extensions/MessageBox.bas'
