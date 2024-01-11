': Pelmanism Game by QWERKEY 2019-01-10
': Images from openclipart.org,clipartpng.com & pngimg.com
': Sounds from findsounds.com
': This program uses
': InForm - GUI library for QB64 - Beta version 8
': Fellippe Heitor, 2016-2018 - fellippe@qb64.org - @fellippeheitor
': https://github.com/FellippeHeitor/InForm
'-----------------------------------------------------------

': Controls' IDs: ------------------------------------------------------------------
DIM SHARED Pelmanism AS LONG
DIM SHARED ExitBT AS LONG
DIM SHARED NewGameBT AS LONG
DIM SHARED AudioFM AS LONG
DIM SHARED AudioOnRB AS LONG
DIM SHARED AudioOffRB AS LONG
DIM SHARED BestScoreLB AS LONG
DIM SHARED ScoreLB AS LONG
DIM SHARED PelmanismLB AS LONG
DIM SHARED SetSkillLevelLB AS LONG
DIM SHARED OneBT AS LONG
DIM SHARED TwoBT AS LONG
DIM SHARED ThreeBT AS LONG
DIM SHARED PairingsCompletedLB AS LONG

CONST NoObjectsLess1%% = 67
DIM SHARED BestScore%(2), GameLevel%%(2, 1), InPlay`, Level%%, FrameRate%, NoRemaining%%, Score%, DoNewGame`
DIM SHARED NosImg&(9, 1), Images&(NoObjectsLess1%%), ObverseImg&, Background&, Highlight&
DIM SHARED ValidMouse`, XX%%, YY%%, FirstV%%, FirstH%%, Flipping`, TurningBack`, FlipCount%%, Paused`, PCount%%, FirstGo`
REDIM SHARED Motion`(10, 6, 2), Choisi`(10, 6), Grid%%(10, 6)

': External modules: ---------------------------------------------------------------
'$INCLUDE:'../../InForm/InForm.bi'
'$INCLUDE:'Pelmanism.frm'
'$INCLUDE:'../../InForm/InForm.ui'

': Event procedures & Functions: ---------------------------------------------------------------
FUNCTION MakeHardware& (Img&)
    MakeHardware& = _COPYIMAGE(Img&, 33)
    _FREEIMAGE Img&
END FUNCTION

SUB __UI_BeforeInit
    RANDOMIZE (TIMER)
    $EXEICON:'.\Balloons.ico'
    RESTORE game_data
    FOR N%% = 0 TO 2
        FOR M%% = 0 TO 1
            READ GameLevel%%(N%%, M%%)
        NEXT M%%
    NEXT N%%
    'Create Images
    FOR N%% = 0 TO NoObjectsLess1%%
        READ Dum$
        Images&(N%%) = _LOADIMAGE(Dum$ + ".png", 33)
    NEXT N%%
    IF RND > 0.5 THEN
        ObverseImg& = _LOADIMAGE("Back1.png", 33)
    ELSE
        ObverseImg& = _LOADIMAGE("Back2.png", 33)
    END IF
    TempImg& = _NEWIMAGE(104, 104, 32)
    _DEST TempImg&
    COLOR _RGB32(0, 176, 0), _RGBA32(100, 100, 100, 0)
    CLS
    LINE (0, 0)-(103, 103), , B
    LINE (1, 1)-(102, 102), , B
    Highlight& = MakeHardware&(TempImg&)
    'Load/Set Initial Data
    IF _FILEEXISTS("pelman.dat") THEN
        OPEN "pelman.dat" FOR INPUT AS #1
        FOR N%% = 0 TO 2
            INPUT #1, BestScore%(N%%)
        NEXT N%%
        CLOSE #1
    END IF
    DoNewGame` = FALSE

    game_data:
    DATA 4,4
    DATA 6,6
    DATA 10,6
    DATA Bananas,Cherry,Carrots,Pepper,Tomato,Cat,Egg,Beer,Acorn,Feather,Squirrel,IcedBun,LightBulb,GoldCup
    DATA Parrot,LadyMouse,Mushrooms,Pineapple,Balloons,Rose,CloverLeaf,Goose,Raccoon,Raspberry,Violin,TeddyBear
    DATA Clock,Shoes,Wrench,Hammer,Computer,Matches,Diamond,WineGlass,Frog,Chimp,Apricot,RollsRoyce,Knight,Bee
    DATA Fish,IceCream,SnowFlake,XmasTree,Butterfly,Rainbow,Penguin,Fox,Hummingbird,Cashews,Tulips,Matryoshka
    DATA Lion,Apple,Hat,Heart,Key1,Ladybird,Strawberry,TV,Dog,Dolphin,Koala,Earth,Olives,Einstein,Plane,Flag
END SUB

SUB __UI_OnLoad
    Control(BestScoreLB).Top = 6
    Control(ScoreLB).Top = 100
    Control(PairingsCompletedLB).Top = 176
    CALL NouveauJeu
END SUB

SUB __UI_BeforeUpdateDisplay
    'This event occurs at approximately 30 frames per second.
    'You can change the update frequency by calling SetFrameRate DesiredRate%
    STATIC XPos%, YPos%
    IF InPlay` THEN
        _PUTIMAGE (0, 0), Background&
        IF ValidMouse` THEN _PUTIMAGE (5 + 107 * XX%%, 5 + 107 * YY%%), Highlight&
        FOR HorizPos%% = 1 TO GameLevel%%(Level%%, 0)
            FOR VertPos%% = 1 TO GameLevel%%(Level%%, 1)
                IF Motion`(HorizPos%%, VertPos%%, 2) THEN
                    'Turn back
                    IF Paused` THEN
                        _PUTIMAGE (107 * (HorizPos%% - 1) + 7, 107 * (VertPos%% - 1) + 7), Images&(Grid%%(HorizPos%%, VertPos%%)) 'Fronts
                        PCount%% = PCount%% + 1
                        IF PCount%% = 40 THEN
                            Paused` = FALSE
                            PCount%% = 0
                        END IF
                    ELSE
                        IF FlipCount%% = 0 THEN
                            XPos% = 107 * (HorizPos%% - 1) + 7
                            YPos% = 107 * (VertPos%% - 1) + 7
                        END IF
                        IF FlipCount%% < 50 THEN
                            _PUTIMAGE (FlipCount%% + XPos%, YPos%)-(XPos% + 100 - FlipCount%%, YPos% + 100), Images&(Grid%%(HorizPos%%, VertPos%%))
                        ELSE
                            _PUTIMAGE (XPos% + FlipCount%%, YPos%)-(XPos% + 100 - FlipCount%%, YPos% + 100), ObverseImg&
                        END IF
                        FlipCount%% = FlipCount%% + 2
                        IF FlipCount%% = 100 THEN
                            FlipCount%% = 0
                            Motion`(HorizPos%%, VertPos%%, 2) = FALSE
                            Motion`(HorizPos%%, VertPos%%, 0) = FALSE
                            IF HorizPos%% = FirstH%% AND VertPos%% = FirstV%% THEN
                                FrameRate% = 40
                                SetFrameRate FrameRate%
                                Flipping` = FALSE
                                TurningBack` = FALSE
                                FirstV%% = 50
                            ELSE
                                Motion`(FirstH%%, FirstV%%, 2) = TRUE
                            END IF
                        END IF
                    END IF
                ELSEIF Motion`(HorizPos%%, VertPos%%, 1) THEN
                    'Turn forward
                    IF FlipCount%% = 0 THEN
                        XPos% = 107 * (HorizPos%% - 1) + 7
                        YPos% = 107 * (VertPos%% - 1) + 7
                    END IF
                    IF FlipCount%% < 50 THEN
                        _PUTIMAGE (XPos% + 100 - FlipCount%%, YPos%)-(XPos% + FlipCount%%, YPos% + 100), ObverseImg&
                    ELSE
                        _PUTIMAGE (100 - FlipCount%% + XPos%, YPos%)-(XPos% + FlipCount%%, YPos% + 100), Images&(Grid%%(HorizPos%%, VertPos%%))
                    END IF
                    FlipCount%% = FlipCount%% + 2
                    IF FlipCount%% = 100 THEN
                        FlipCount%% = 0
                        Flipping` = FALSE
                        Motion`(HorizPos%%, VertPos%%, 1) = FALSE
                        Motion`(HorizPos%%, VertPos%%, 0) = TRUE
                        IF FirstGo` THEN
                            FirstGo` = FALSE
                        ELSE
                            FirstGo` = TRUE
                            IF Grid%%(HorizPos%%, VertPos%%) = Grid%%(FirstH%%, FirstV%%) THEN 'Matched pair
                                Choisi`(HorizPos%%, VertPos%%) = TRUE 'Registers that that grid position cannot be clicked any more
                                Choisi`(FirstH%%, FirstV%%) = TRUE
                                NoRemaining%% = NoRemaining%% - 2
                                IF NoRemaining%% = 0 THEN
                                    'Tah-dah sound (completed)
                                    IF Control(AudioOnRB).Value THEN _SNDPLAYFILE ("fanfare.mp3")
                                    Control(PairingsCompletedLB).Disabled = FALSE
                                    Control(PairingsCompletedLB).Hidden = FALSE
                                ELSE
                                    'Ching sound (match)
                                    IF Control(AudioOnRB).Value THEN _SNDPLAYFILE ("match3.mp3")
                                END IF
                            ELSE
                                'Initiate sequential turn back
                                FrameRate% = 60
                                SetFrameRate FrameRate%
                                Motion`(HorizPos%%, VertPos%%, 2) = TRUE
                                Flipping` = TRUE
                                TurningBack` = TRUE
                                Paused` = TRUE
                                PCount%% = 0
                                IF Control(AudioOnRB).Value THEN _SNDPLAYFILE ("nomatch1.mp3"), , 0.2
                            END IF
                            IF Score% < 99 THEN
                                Score% = Score% + 1
                                Caption(ScoreLB) = "Score:" + STR$(Score%)
                            END IF
                            IF NoRemaining%% = 0 THEN
                                'Pairings Completed
                                IF Score% < BestScore%(Level%%) OR BestScore%(Level%%) = 0 THEN
                                    BestScore%(Level%%) = Score%
                                    Caption(BestScoreLB) = "Best Score:  " + LTRIM$(STR$(BestScore%(Level%%)))
                                END IF
                            END IF
                        END IF
                    END IF
                ELSEIF Motion`(HorizPos%%, VertPos%%, 0) THEN
                    _PUTIMAGE (107 * (HorizPos%% - 1) + 7, 107 * (VertPos%% - 1) + 7), Images&(Grid%%(HorizPos%%, VertPos%%)) 'Fronts
                ELSE
                    _PUTIMAGE (107 * (HorizPos%% - 1) + 7, 107 * (VertPos%% - 1) + 7), ObverseImg& 'Backs
                END IF
            NEXT VertPos%%
        NEXT HorizPos%%
    END IF
END SUB

SUB __UI_BeforeUnload
    'If you set __UI_UnloadSignal = False here you can
    'cancel the user's request to close.
END SUB

SUB __UI_Click (id AS LONG)
    SELECT CASE id
        CASE AudioFM

        CASE AudioOnRB

        CASE AudioOffRB

        CASE BestScoreLB

        CASE ScoreLB

        CASE PelmanismLB

        CASE SetSkillLevelLB

        CASE PairingsCompletedLB

        CASE Pelmanism
            IF ValidMouse` THEN
                HorizPos%% = XX%% + 1
                VertPos%% = YY%% + 1
                IF Choisi`(HorizPos%%, VertPos%%) OR (FirstH%% = HorizPos%% AND FirstV%% = VertPos%%) THEN
                    'Do nothing
                ELSE
                    Motion`(HorizPos%%, VertPos%%, 1) = TRUE 'Set this cell turning
                    Flipping` = TRUE
                    IF FirstGo` THEN
                        FirstH%% = HorizPos%%
                        FirstV%% = VertPos%%
                    END IF
                END IF
            END IF
        CASE ExitBT
            IF InPlay` THEN
                InPlay` = FALSE
            ELSE
                CALL Finale
            END IF
        CASE NewGameBT
            DoNewGame` = TRUE
            InPlay` = FALSE
        CASE OneBT
            Level%% = 0
            CALL MakePairs
        CASE TwoBT
            Level%% = 1
            CALL MakePairs
        CASE ThreeBT
            Level%% = 2
            CALL MakePairs
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

SUB NouveauJeu
    DoNewGame` = FALSE
    _DELAY 0.1
    FrameRate% = 40
    SetFrameRate FrameRate%
    Control(__UI_FormID).Width = 310
    Control(__UI_FormID).Height = 360
    Control(PelmanismLB).Disabled = FALSE
    Control(PelmanismLB).Hidden = FALSE
    Control(SetSkillLevelLB).Disabled = FALSE
    Control(SetSkillLevelLB).Hidden = FALSE
    Control(OneBT).Disabled = FALSE
    Control(OneBT).Hidden = FALSE
    Control(TwoBT).Disabled = FALSE
    Control(TwoBT).Hidden = FALSE
    Control(ThreeBT).Disabled = FALSE
    Control(ThreeBT).Hidden = FALSE
    Control(NewGameBT).Disabled = TRUE
    Control(NewGameBT).Hidden = TRUE
    Control(AudioFM).Disabled = TRUE
    Control(AudioFM).Hidden = TRUE
    Control(BestScoreLB).Disabled = TRUE
    Control(BestScoreLB).Hidden = TRUE
    Control(ScoreLB).Disabled = TRUE
    Control(ScoreLB).Hidden = TRUE
    Control(PairingsCompletedLB).Disabled = TRUE
    Control(PairingsCompletedLB).Hidden = TRUE
    Control(ExitBT).Left = Control(__UI_FormID).Width - 96
    Control(ExitBT).Top = Control(__UI_FormID).Height - 39
    SetFocus ExitBT
END SUB

SUB Finale
    'Freeimages
    _FREEIMAGE ObverseImg&
    _FREEIMAGE Highlight&
    FOR N%% = 0 TO 9
        _FREEIMAGE NosImg&(N%%, 1)
        _FREEIMAGE NosImg&(N%%, 0)
    NEXT N%%
    _FREEIMAGE BestImg&
    FOR N%% = 0 TO NoObjectsLess1%%
        _FREEIMAGE Images&(N%%)
    NEXT N%%
    OPEN "pelman.dat" FOR OUTPUT AS #1
    FOR N%% = 0 TO 2
        PRINT #1, BestScore%(N%%)
    NEXT N%%
    CLOSE #1
    SYSTEM
END SUB

SUB MakePairs
    InPlay` = TRUE
    Score% = 0
    NoRemaining%% = GameLevel%%(Level%%, 0) * GameLevel%%(Level%%, 1)
    NoPairs%% = 0
    FirstV%% = 50
    ValidMouse` = FALSE
    Flipping` = FALSE
    TurningBack` = FALSE
    FlipCount%% = 0
    Paused` = FALSE
    PCount%% = 0
    FirstGo` = TRUE
    REDIM Motion`(10, 6, 2), Choisi`(10, 6), Grid%%(10, 6)
    REDIM Selected%%(30)
    RANDOMIZE (TIMER)
    WHILE NoRemaining%% > 0
        Vacant` = FALSE
        WHILE NOT Vacant`
            HorizPos%% = 1 + INT(GameLevel%%(Level%%, 0) * RND)
            VertPos%% = 1 + INT(GameLevel%%(Level%%, 1) * RND)
            IF Grid%%(HorizPos%%, VertPos%%) = 0 THEN Vacant` = TRUE
        WEND
        NewPair` = FALSE
        WHILE NOT NewPair`
            PairNo%% = 1 + INT(NoObjectsLess1%% * RND)
            PairsExists` = FALSE
            N%% = 1
            WHILE NOT PairsExists` AND N%% <= NoPairs%%
                IF PairNo%% = Selected%%(N%%) THEN PairsExists` = TRUE
                N%% = N%% + 1
            WEND
            IF NOT PairsExists` THEN NewPair` = TRUE
        WEND
        NoPairs%% = NoPairs%% + 1
        Selected%%(NoPairs%%) = PairNo%%
        Grid%%(HorizPos%%, VertPos%%) = PairNo%%
        Vacant` = FALSE
        WHILE NOT Vacant`
            HorizPos%% = 1 + INT(GameLevel%%(Level%%, 0) * RND): VertPos%% = 1 + INT(GameLevel%%(Level%%, 1) * RND)
            IF Grid%%(HorizPos%%, VertPos%%) = 0 THEN Vacant` = TRUE
        WEND
        Selected%%(NoPairs%%) = PairNo%%
        Grid%%(HorizPos%%, VertPos%%) = PairNo%%
        NoRemaining%% = NoRemaining%% - 2
    WEND
    NoRemaining%% = GameLevel%%(Level%%, 0) * GameLevel%%(Level%%, 1)
    Control(__UI_FormID).Width = 307 + (GameLevel%%(Level%%, 0) - 1) * 107
    Control(__UI_FormID).Height = 114 + (GameLevel%%(Level%%, 1) - 1) * 107
    Control(ExitBT).Left = Control(__UI_FormID).Width - 96
    Control(ExitBT).Top = Control(__UI_FormID).Height - 39
    Control(NewGameBT).Left = Control(__UI_FormID).Width - 96
    Control(NewGameBT).Top = Control(__UI_FormID).Height - 73
    Control(AudioFM).Left = Control(__UI_FormID).Width - 122
    Control(AudioFM).Top = Control(__UI_FormID).Height - 169
    Control(BestScoreLB).Left = Control(__UI_FormID).Width - 178
    Control(ScoreLB).Left = Control(__UI_FormID).Width - 178
    Control(PairingsCompletedLB).Left = Control(__UI_FormID).Width - 138
    Control(PelmanismLB).Disabled = TRUE
    Control(PelmanismLB).Hidden = TRUE
    Control(SetSkillLevelLB).Disabled = TRUE
    Control(SetSkillLevelLB).Hidden = TRUE
    Control(OneBT).Disabled = TRUE
    Control(OneBT).Hidden = TRUE
    Control(TwoBT).Disabled = TRUE
    Control(TwoBT).Hidden = TRUE
    Control(ThreeBT).Disabled = TRUE
    Control(ThreeBT).Hidden = TRUE
    Control(NewGameBT).Disabled = FALSE
    Control(NewGameBT).Hidden = FALSE
    Control(AudioFM).Disabled = FALSE
    Control(AudioFM).Hidden = FALSE
    Control(BestScoreLB).Disabled = FALSE
    Control(BestScoreLB).Hidden = FALSE
    Control(ScoreLB).Disabled = FALSE
    Control(ScoreLB).Hidden = FALSE
    IF BestScore%(Level%%) <> 0 THEN
        Caption(BestScoreLB) = "Best Score:" + STR$(BestScore%(Level%%))
    ELSE
        Caption(BestScoreLB) = "Best Score:"
    END IF
    Caption(ScoreLB) = "Score:"
    SetFocus ExitBT
    Blight& = _NEWIMAGE(110, 110, 32)
    _DEST Blight&
    COLOR _RGB32(255, 255, 255), _RGBA32(100, 100, 100, 0)
    CLS
    LINE (0, 0)-(109, 109), , B
    LINE (1, 1)-(108, 108), , B
    LINE (2, 2)-(107, 107), , B
    TempImg& = _NEWIMAGE(6 + (GameLevel%%(Level%%, 0)) * 107, 6 + (GameLevel%%(Level%%, 1)) * 107, 32)
    _DEST TempImg&
    COLOR _RGB32(255, 255, 255), _RGBA32(100, 100, 100, 0)
    CLS
    FOR N%% = 0 TO GameLevel%%(Level%%, 0) - 1
        FOR M%% = 0 TO GameLevel%%(Level%%, 1) - 1
            _PUTIMAGE (2 + N%% * 107, 2 + M%% * 107), Blight&
        NEXT M%%
    NEXT N%%
    LINE (4, 4)-(2 + GameLevel%%(Level%%, 0) * 107, 2 + GameLevel%%(Level%%, 1) * 107), , B
    Background& = MakeHardware&(TempImg&)
    _FREEIMAGE Blight&
    _DELAY 0.1
    WHILE InPlay`
        _LIMIT 2 * FrameRate%
        XMouse% = __UI_MouseLeft: YMouse% = __UI_MouseTop
        ValidMouse` = FALSE
        IF XMouse% > 7 AND XMouse% < (GameLevel%%(Level%%, 0)) * 107 AND YMouse% > 7 AND YMouse% < (GameLevel%%(Level%%, 1)) * 107 THEN
            IF NOT Flipping` THEN ValidMouse` = TRUE
            XX%% = (XMouse% - 7) \ 107
            YY%% = (YMouse% - 7) \ 107
        END IF
        K$ = INKEY$
        IF K$ <> "" THEN
            IF ASC(K$) = 27 THEN InPlay` = FALSE
        END IF
        K$ = ""
        __UI_DoEvents
    WEND
    _FREEIMAGE Background&
    IF DoNewGame` THEN
        CALL NouveauJeu
    ELSE
        CALL Finale
    END IF
END SUB
