': Mahjong Program by Qwerkey (Richard Notley) 20/09/18 - updated 03/07/20
': This program uses
': InForm - GUI library for QB64 - v1.1
': Fellippe Heitor, 2016-2019 - fellippe@qb64.org - @fellippeheitor
': https://github.com/FellippeHeitor/InForm
': Images from openclipart.org, clker.com, clipartbest.com, clipartkid.com, wpclipart.com, wikipedia, kisspng.com
': Sound Effects from freesfx.co.uk
'-----------------------------------------------------------

DIM SHARED QB64Mahjong AS LONG
DIM SHARED ExitBT AS LONG
DIM SHARED ScoreLB AS LONG
DIM SHARED HighScoreLB AS LONG
DIM SHARED NumberOfTilesLB AS LONG
DIM SHARED Label1LB AS LONG
DIM SHARED NewGameBT AS LONG
DIM SHARED SaveGameBT AS LONG
DIM SHARED ScoringLB AS LONG
DIM SHARED HighScoringLB AS LONG
DIM SHARED TilesRemainingLB AS LONG
DIM SHARED UndoBT AS LONG
DIM SHARED StillBT AS LONG
DIM SHARED Frame1 AS LONG

DIM SHARED Mahjong%(5, 16, 8), Template`(5, 15, 8) 'From Into to Out-Of Screen, Left-to-Right, Top-to-Bottom
DIM SHARED ImType%%(144), TilePic%%(144), ImPos%%(144, 2), MatchComp%%(40), TileSave%(72, 1)
DIM SHARED Innit%%, Score%, HighScore%, TilesRem%, FromSave%%, MahPlay%%, WorldStop%%, CanUndo%%
DIM SHARED Counter&, PrevType%%, Blink%%, MatchesNone%%, EIndex%%, NoHov%, NoSel%, XMouse%, YMouse%
DIM SHARED HoverImg&, SimilarImg&, SelectImg&, EarthIm&, TileIm&(42), BackImg&, Blossom&, Borders&
CONST ScreenX% = 700, ScreenY% = 700, XStep% = 40, YStep% = 57, XOffset% = 5, YOffset% = 5
CONST XOrigin% = 40, YOrigin% = 40, YHalfTile% = 30, XHalfTile% = 20, FrameRate% = 30

': External modules: ---------------------------------------------------------------
'$INCLUDE:'../../InForm/InForm.bi'
'$INCLUDE:'QB64Mahjong.frm'
'$INCLUDE:'MakeBaize.bas'
'$INCLUDE:'QB64Logo.bas'

': Event procedures & Functions: ---------------------------------------------------

FUNCTION HardwareImage& (ImageName&)
    HardwareImage& = _COPYIMAGE(ImageName&, 33)
    _FREEIMAGE ImageName&
END FUNCTION

FUNCTION SetText$ (T%)
    SetText$ = LTRIM$(STR$(T%))
END FUNCTION

SUB __UI_BeforeInit
    RANDOMIZE (TIMER)
    $EXEICON:'.\QB64Mahjong.ico'
    Innit%% = True
    'Set Positions Template
    FOR S%% = 4 TO 11 '64
        FOR R%% = 1 TO 8
            Template`(1, S%%, R%%) = True
        NEXT R%%
    NEXT S%%
    FOR S%% = 2 TO 3 '8
        FOR R%% = 1 TO 8 STEP 7
            Template`(1, S%%, R%%) = True
            Template`(1, S%% + 10, R%%) = True
        NEXT R%%
    NEXT S%%
    FOR S%% = 3 TO 12 STEP 9 '8
        FOR R%% = 3 TO 6
            Template`(1, S%%, R%%) = True
        NEXT R%%
    NEXT S%%
    FOR S%% = 2 TO 13 STEP 11 '4
        FOR R%% = 4 TO 5
            Template`(1, S%%, R%%) = True
        NEXT R%%
    NEXT S%%
    FOR S%% = 5 TO 10 '36
        FOR R%% = 2 TO 7
            Template`(2, S%%, R%%) = True
        NEXT R%%
    NEXT S%%
    FOR S%% = 6 TO 9 '16
        FOR R%% = 3 TO 6
            Template`(3, S%%, R%%) = True
        NEXT R%%
    NEXT S%%
    FOR S%% = 7 TO 8 '4
        FOR R%% = 4 TO 5
            Template`(4, S%%, R%%) = True
        NEXT R%%
    NEXT S%%
    Template`(1, 1, 4) = True '4 'FIO 4.5 really
    Template`(1, 14, 4) = True 'FIO 4.5 really
    Template`(1, 15, 4) = True 'FIO 4.5 really
    Template`(5, 7, 4) = True 'FIO 7.5, 4.5 really
    'Images - all images are hardware accelerated
    'Most images are used only in  __UI_BeforeUpdateDisplay and therefore could be local and static
    'But images are Shared instead
    CALL MakeBaize(TempImg&)
    BackImg& = HardwareImage&(TempImg&)
    TempImg& = _NEWIMAGE(45, 62, 32)
    _DEST TempImg&
    COLOR _RGB(0, 0, 220), _RGBA(10, 10, 10, 50)
    CLS
    HoverImg& = HardwareImage&(TempImg&)
    TempImg& = _NEWIMAGE(38, 55, 32)
    _DEST TempImg&
    COLOR _RGBA(0, 150, 0, 200), _RGBA(100, 100, 100, 0)
    CLS
    LINE (0, 0)-(37, 54), , B
    LINE (1, 1)-(36, 53), , B
    LINE (2, 2)-(35, 52), , B
    SimilarImg& = HardwareImage&(TempImg&)
    TempImg& = _NEWIMAGE(38, 55, 32)
    _DEST TempImg&
    COLOR _RGBA(180, 0, 0, 180), _RGBA(100, 100, 100, 0)
    CLS
    LINE (0, 0)-(37, 54), , B
    LINE (1, 1)-(36, 53), , B
    LINE (2, 2)-(35, 52), , B
    SelectImg& = HardwareImage&(TempImg&)
    TempImg& = _NEWIMAGE(494, 574, 32)
    _DEST TempImg&
    COLOR _RGB(230, 230, 230), _RGBA(100, 100, 100, 0)
    CLS
    LINE (369, 0)-(460, 0)
    LINE (369, 0)-(369, 46)
    LINE (460, 0)-(460, 46)
    LINE (369, 46)-(384, 46)
    LINE (445, 46)-(460, 46)
    LINE (384, 46)-(384, 91)
    LINE (445, 46)-(445, 91)
    LINE (384, 91)-(445, 91)
    LINE (339, 230)-(493, 230)
    LINE (339, 230)-(339, 276)
    LINE (493, 230)-(493, 276)
    LINE (339, 276)-(384, 276)
    LINE (445, 276)-(493, 276)
    LINE (384, 276)-(384, 321)
    LINE (445, 276)-(445, 321)
    LINE (384, 321)-(445, 321)
    LINE (0, 490)-(308, 490)
    LINE (0, 490)-(0, 528)
    LINE (308, 490)-(308, 528)
    LINE (0, 528)-(123, 528)
    LINE (185, 528)-(308, 528)
    LINE (123, 528)-(123, 573)
    LINE (185, 528)-(185, 573)
    LINE (123, 573)-(185, 573)
    Borders& = HardwareImage&(TempImg&)
    EarthIm& = _LOADIMAGE("Earth.png", 33)
    Blossom& = _LOADIMAGE("Plum Blossom.png", 33)
    'Character Tiles
    FOR N% = 1 TO 9
        TileIm&(N%) = _LOADIMAGE("K" + LTRIM$(STR$(N%)) + ".png", 33)
    NEXT N%
    FOR N% = 1 TO 36
        S%% = 1 + CINT((N% - 1) \ 4)
        ImType%%(N%) = S%%
        TilePic%%(N%) = S%%
    NEXT N%
    'Bamboo Tiles
    FOR N% = 10 TO 18
        S%% = N% - 9
        TileIm&(N%) = _LOADIMAGE("B" + LTRIM$(STR$(S%%)) + ".png", 33)
    NEXT N%
    FOR N% = 37 TO 72
        S%% = 1 + CINT((N% - 37) \ 4)
        ImType%%(N%) = S%% + 9
        TilePic%%(N%) = S%% + 9
    NEXT N%
    'Planet Tiles
    FOR N% = 19 TO 27
        S%% = N% - 18
        TileIm&(N%) = _LOADIMAGE("C" + LTRIM$(STR$(S%%)) + ".png", 33)
    NEXT N%
    FOR N% = 73 TO 108
        S%% = 1 + CINT((N% - 73) \ 4)
        ImType%%(N%) = S%% + 18
        TilePic%%(N%) = S%% + 18
    NEXT N%
    'QB64 Tiles
    FOR N% = 28 TO 30
        S%% = N% - 27
        TileIm&(N%) = _LOADIMAGE("D" + LTRIM$(STR$(S%%)) + ".png", 33)
    NEXT N%
    FOR N% = 109 TO 120
        S%% = 1 + CINT((N% - 109) \ 4)
        ImType%%(N%) = S%% + 27
        TilePic%%(N%) = S%% + 27
    NEXT N%
    'Wind Tiles
    FOR N% = 31 TO 34
        S%% = N% - 30
        TileIm&(N%) = _LOADIMAGE("W" + LTRIM$(STR$(S%%)) + ".png", 33)
    NEXT N%
    FOR N% = 121 TO 136
        S%% = 1 + CINT((N% - 121) \ 4)
        ImType%%(N%) = S%% + 30
        TilePic%%(N%) = S%% + 30
    NEXT N%
    'Flower Tiles
    FOR N% = 35 TO 38
        S%% = N% - 34
        TileIm&(N%) = _LOADIMAGE("F" + LTRIM$(STR$(S%%)) + ".png", 33)
    NEXT N%
    FOR N% = 137 TO 140
        S%% = N% - 136
        ImType%%(N%) = 35
        TilePic%%(N%) = S%% + 34
    NEXT N%
    'Nucleotide Tiles
    FOR N% = 39 TO 42
        S%% = N% - 38
        TileIm&(N%) = _LOADIMAGE("S" + LTRIM$(STR$(S%%)) + ".png", 33)
    NEXT N%
    FOR N% = 141 TO 144
        S%% = N% - 140
        ImType%%(N%) = 36
        TilePic%%(N%) = S%% + 38
    NEXT N%
    'Load data
    FromSave%% = False
    IF _FILEEXISTS("mahjong.cfg") THEN
        OPEN "mahjong.cfg" FOR INPUT AS #1
        INPUT #1, HighScore%
        INPUT #1, TilesRem%
        IF TilesRem% <> 144 THEN
            FromSave%% = True
            'Input saved data
            INPUT #1, Score%
            INPUT #1, Counter&
            FOR U%% = 1 TO 15
                FOR V%% = 1 TO 8
                    FOR W%% = 1 TO 5
                        INPUT #1, Mahjong%(W%%, U%%, V%%)
                    NEXT W%%
                NEXT V%%
            NEXT U%%
            FOR N% = 1 TO 144
                INPUT #1, ImPos%%(N%, 0), ImPos%%(N%, 1), ImPos%%(N%, 2)
            NEXT N%
            FOR N% = 1 TO 72 - (TilesRem% / 2)
                INPUT #1, TileSave%(N%, 1), TileSave%(N%, 0)
            NEXT N%
            PrevType%% = ImType%%(TileSave%(72 - (TilesRem% / 2), 1))
        END IF
        CLOSE #1
    END IF
END SUB

SUB __UI_OnLoad
    _SCREENMOVE 100, 50
    Caption(ExitBT) = "Start"
    Control(ScoreLB).Hidden = True
    Control(ScoringLB).Hidden = True
    Control(HighScoreLB).Hidden = True
    Control(HighScoringLB).Hidden = True
    Control(NumberOfTilesLB).Hidden = True
    Control(TilesRemainingLB).Hidden = True
    Control(NewGameBT).Disabled = True
    Control(SaveGameBT).Disabled = True
    Control(UndoBT).Disabled = True
    Control(StillBT).Disabled = True
    SetFrameRate FrameRate%
    SetFocus ExitBT
END SUB

SUB __UI_BeforeUpdateDisplay
    'This event occurs at approximately 30 frames per second.
    'You can change the update frequency by calling SetFrameRate DesiredRate%
    _PUTIMAGE (0, 0), BackImg&
    IF Innit%% OR TilesRem% = 0 THEN
        _PUTIMAGE (0, 5), Blossom&
    ELSEIF TilesRem% <> 0 THEN
        'Display In-Play Tiles and Look for Mouse Hover/Select/Match
        NoHov% = 0
        Matches%% = False
        MatchCount% = 0
        'Layer 1R
        FOR S%% = 15 TO 14 STEP -1
            M% = Mahjong%(1, S%%, 4)
            IF M% <> 0 THEN
                X1% = ((S%% - 1) * XStep%) + XOrigin%
                Y1% = (3 * YStep%) + YOrigin% + YHalfTile%
                _PUTIMAGE (X1%, Y1%), TileIm&(TilePic%%(M%))
                IF M% >= 81 AND M% <= 84 THEN _PUTIMAGE (X1% + 7, Y1% + 18), EarthIm&, , (EIndex%% * 35, 0)-((EIndex%% * 35) + 34, 34)
                IF Mahjong%(1, S%% + 1, 4) = 0 THEN
                    MatchCount% = 1 'Don't need to count for two RHS end tiles on level 1
                    MatchComp%%(MatchCount%) = ImType%%(M%)
                    IF M% = NoSel% THEN 'Selected
                        _PUTIMAGE (X1% + 6, Y1% + 1), SelectImg&
                    ELSEIF ImType%%(NoSel%) = ImType%%(M%) AND Blink%% THEN 'Matches Selected
                        _PUTIMAGE (X1% + 6, Y1% + 1), SimilarImg&
                    END IF
                    IF XMouse% <= X1% + XStep% + 2 AND XMouse% >= X1% + XOffset% + 3 AND YMouse% >= Y1% + 3 AND YMouse% <= Y1% + YStep% - 3 THEN
                        NoHov% = M%
                        _PUTIMAGE (X1%, Y1%), HoverImg&
                    END IF
                END IF
            END IF
        NEXT S%%
        'Layers 1 -4 Look for Hover
        FOR W%% = 1 TO 4
            UHov% = XMouse% - XOrigin% + XStep% - (XOffset% * W%%)
            VHov% = YMouse% - YOrigin% + YStep% + (YOffset% * (W%% - 1))
            S%% = UHov% \ XStep%
            URem%% = UHov% MOD XStep%
            R%% = VHov% \ YStep%
            VRem%% = VHov% MOD YStep%
            IF S%% >= 2 AND S%% <= 13 AND R%% >= 1 AND R%% <= 8 THEN
                'Check for Available AND Not Blocked
                M% = Mahjong%(W%%, S%%, R%%)
                IF M% <> 0 AND URem%% >= 3 AND URem%% <= XStep% - 3 AND VRem%% >= 3 AND VRem%% <= YStep% - 3 THEN
                    IF Mahjong%(W%% + 1, S%%, R%%) = 0 AND (Mahjong%(W%%, S%% + 1, R%%) = 0 OR Mahjong%(W%%, S%% - 1, R%%) = 0) THEN NoHov% = M%
                END IF
            END IF
        NEXT W%%
        'Layers 1 -4
        FOR W%% = 1 TO 4
            IF W%% = 1 THEN
                UFactor%% = -1
            ELSE
                UFactor%% = W%%
            END IF
            FOR S%% = 12 - UFactor%% TO 3 + UFactor%% STEP -1
                FOR R%% = W%% TO 9 - W%%
                    M% = Mahjong%(W%%, S%%, R%%)
                    IF M% <> 0 THEN
                        X1% = ((S%% - 1) * XStep%) + XOrigin% + (XOffset% * (W%% - 1))
                        Y1% = ((R%% - 1) * YStep%) + YOrigin% - (YOffset% * (W%% - 1))
                        _PUTIMAGE (X1%, Y1%), TileIm&(TilePic%%(M%))
                        IF M% >= 81 AND M% <= 84 THEN _PUTIMAGE (X1% + 7, Y1% + 18), EarthIm&, , (EIndex%% * 35, 0)-((EIndex%% * 35) + 34, 34)
                        IF Mahjong%(W%% + 1, S%%, R%%) = 0 AND (Mahjong%(W%%, S%% + 1, R%%) = 0 OR Mahjong%(W%%, S%% - 1, R%%) = 0) THEN
                            MatchCount% = MatchCount% + 1
                            IF MatchCount% > 1 THEN
                                MatchIndex% = 1
                                WHILE NOT Matches%% AND MatchIndex% <= MatchCount% - 1
                                    IF ImType%%(M%) = MatchComp%%(MatchIndex%) THEN Matches%% = True
                                    MatchIndex% = MatchIndex% + 1
                                WEND
                            END IF
                            MatchComp%%(MatchCount%) = ImType%%(M%)
                            IF M% = NoSel% THEN 'Selected
                                _PUTIMAGE (X1% + 6, Y1% + 1), SelectImg&
                            ELSEIF ImType%%(NoSel%) = ImType%%(M%) AND Blink%% THEN 'Matches Selected
                                _PUTIMAGE (X1% + 6, Y1% + 1), SimilarImg&
                            END IF
                            IF NoHov% = M% THEN _PUTIMAGE (X1%, Y1%), HoverImg&
                        END IF
                    END IF
                NEXT R%%
            NEXT S%%
        NEXT W%%
        'Layer 1L
        M% = Mahjong%(1, 1, 4)
        IF M% <> 0 THEN
            X1% = XOrigin%
            Y1% = (3 * YStep%) + YOrigin% + YHalfTile%
            _PUTIMAGE (X1%, Y1%), TileIm&(TilePic%%(M%))
            IF M% >= 81 AND M% <= 84 THEN _PUTIMAGE (X1% + 7, Y1% + 18), EarthIm&, , (EIndex%% * 35, 0)-((EIndex%% * 35) + 34, 34)
            MatchCount% = MatchCount% + 1
            IF MatchCount% > 1 THEN
                MatchIndex% = 1
                WHILE NOT Matches%% AND MatchIndex% <= MatchCount% - 1
                    IF ImType%%(M%) = MatchComp%%(MatchIndex%) THEN Matches%% = True
                    MatchIndex% = MatchIndex% + 1
                WEND
            END IF
            MatchComp%%(MatchCount%) = ImType%%(M%)
            IF M% = NoSel% THEN 'Selected
                _PUTIMAGE (X1% + 6, Y1% + 1), SelectImg&
            ELSEIF ImType%%(NoSel%) = ImType%%(M%) AND Blink%% THEN 'Matches Selected
                _PUTIMAGE (X1% + 6, Y1% + 1), SimilarImg&
            END IF
            IF XMouse% <= X1% + XStep% + 2 AND XMouse% >= X1% + XOffset% + 3 AND YMouse% >= Y1% + 3 AND YMouse% <= Y1% + YStep% - 3 THEN
                _PUTIMAGE (X1%, Y1%), HoverImg&
                NoHov% = M%
            END IF
        END IF
        'Layer 5
        M% = Mahjong%(5, 7, 4)
        IF M% <> 0 THEN
            X1% = (6 * XStep%) + XOrigin% + (4 * XOffset%) + XHalfTile%
            Y1% = (3 * YStep%) + YOrigin% - (4 * YOffset%) + YHalfTile%
            _PUTIMAGE (X1%, Y1%), TileIm&(TilePic%%(M%))
            IF M% >= 81 AND M% <= 84 THEN _PUTIMAGE (X1% + 7, Y1% + 18), EarthIm&, , (EIndex%% * 35, 0)-((EIndex%% * 35) + 34, 34)
            MatchCount% = MatchCount% + 1
            IF MatchCount% > 1 THEN
                MatchIndex% = 1
                WHILE NOT Matches%% AND MatchIndex% <= MatchCount% - 1
                    IF ImType%%(M%) = MatchComp%%(MatchIndex%) THEN Matches%% = True
                    MatchIndex% = MatchIndex% + 1
                WEND
            END IF
            MatchComp%%(MatchCount%) = ImType%%(M%)
            IF M% = NoSel% THEN 'Selected
                _PUTIMAGE (X1% + 6, Y1% + 1), SelectImg&
            ELSEIF ImType%%(NoSel%) = ImType%%(M%) AND Blink%% THEN 'Matches Selected
                _PUTIMAGE (X1% + 6, Y1% + 1), SimilarImg&
            END IF
            IF XMouse% <= X1% + XStep% + 2 AND XMouse% >= X1% + XOffset% + 3 AND YMouse% >= Y1% + 3 AND YMouse% <= Y1% + YStep% - 3 THEN
                _PUTIMAGE (X1%, Y1%), HoverImg&
                NoHov% = M%
            END IF
        END IF
        _PUTIMAGE (197 - 1, 110 - 1), Borders&
        IF NOT Matches%% AND MahPlay%% THEN MatchesNone%% = True
    END IF
END SUB

SUB __UI_BeforeUnload
    'If you set __UI_UnloadSignal = False here you can
    'cancel the user's request to close.
END SUB

SUB __UI_Click (id AS LONG)
    SELECT CASE id
        CASE Frame1

        CASE ScoreLB

        CASE HighScoreLB

        CASE NumberOfTilesLB

        CASE Label1LB

        CASE ScoringLB

        CASE HighScoringLB

        CASE TilesRemainingLB

        CASE QB64Mahjong
            IF NoHov% <> 0 AND MahPlay%% THEN
                IF NoSel% = 0 THEN
                    'First Tile Selected
                    NoSel% = NoHov%
                    Control(UndoBT).Disabled = False
                ELSE
                    'Second Tile Selected
                    IF NoSel% <> NoHov% THEN
                        'Check for Same Image Yype
                        IF ImType%%(NoSel%) = ImType%%(NoHov%) THEN
                            'Matched Pair - Remove Tiles
                            Mahjong%(ImPos%%(NoSel%, 0), ImPos%%(NoSel%, 1), ImPos%%(NoSel%, 2)) = 0
                            Mahjong%(ImPos%%(NoHov%, 0), ImPos%%(NoHov%, 1), ImPos%%(NoHov%, 2)) = 0
                            'Special condition for top layer & left/right edges (offest tiles)
                            IF ImPos%%(NoSel%, 0) = 5 OR ImPos%%(NoHov%, 0) = 5 THEN
                                Mahjong%(5, 7, 5) = 0
                                Mahjong%(5, 8, 5) = 0
                                Mahjong%(5, 8, 4) = 0
                            END IF
                            IF ImPos%%(NoSel%, 1) = 14 OR ImPos%%(NoHov%, 1) = 14 THEN
                                Mahjong%(1, 14, 5) = 0
                            END IF
                            IF ImPos%%(NoSel%, 1) = 1 OR ImPos%%(NoHov%, 1) = 1 THEN
                                Mahjong%(1, 1, 5) = 0
                            END IF
                            TileSave%(73 - (TilesRem% / 2), 1) = NoSel%
                            TileSave%(73 - (TilesRem% / 2), 0) = NoHov%
                            TilesRem% = TilesRem% - 2
                            Score% = Score% + 3
                            Caption(TilesRemainingLB) = SetText$(TilesRem%)
                            Caption(ScoringLB) = SetText$(Score%)
                            Control(NewGameBT).Disabled = False
                            IF TilesRem% > 0 THEN
                                Control(SaveGameBT).Disabled = False
                                Control(UndoBT).Disabled = False
                            ELSE
                                Control(SaveGameBT).Disabled = True
                                Control(UndoBT).Disabled = True
                                Caption(Label1LB) = "Congratulations"
                                Control(Label1LB).Hidden = False
                                Control(StillBT).Disabled = True
                            END IF
                            IF ImType%%(NoSel%) = PrevType%% THEN
                                Score% = Score% + 6
                                Caption(ScoringLB) = SetText$(Score%)
                            END IF
                            PrevType%% = ImType%%(NoSel%)
                        ELSE 'Not a Match
                            _SNDPLAYFILE "Beep.ogg", 2, 0.5
                        END IF
                    END IF
                    NoSel% = 0
                    IF TilesRem% = 144 THEN Control(UndoBT).Disabled = True
                END IF
            END IF
        CASE UndoBT
            IF TilesRem% > 0 THEN
                IF TilesRem% < 144 AND CanUndo%% AND NoSel% = 0 THEN
                    'Undo
                    _SNDPLAYFILE "Undo.ogg", 1, 0.6
                    One% = TileSave%(72 - (TilesRem% / 2), 1)
                    Nought% = TileSave%(72 - (TilesRem% / 2), 0)
                    Mahjong%(ImPos%%(One%, 0), ImPos%%(One%, 1), ImPos%%(One%, 2)) = One%
                    Mahjong%(ImPos%%(Nought%, 0), ImPos%%(Nought%, 1), ImPos%%(Nought%, 2)) = Nought%
                    IF ImPos%%(One%, 0) = 5 OR ImPos%%(Nought%, 0) = 5 THEN
                        Mahjong%(5, 7, 5) = 145
                        Mahjong%(5, 8, 5) = 145
                        Mahjong%(5, 8, 4) = 145
                    END IF
                    IF ImPos%%(One%, 1) = 14 OR ImPos%%(Nought%, 1) = 14 THEN
                        Mahjong%(1, 14, 5) = 145
                    END IF
                    IF ImPos%%(One%, 1) = 1 OR ImPos%%(Nought%, 1) = 1 THEN
                        Mahjong%(1, 1, 5) = 145
                    END IF
                    TilesRem% = TilesRem% + 2
                    Score% = Score% - 3
                    Caption(TilesRemainingLB) = SetText$(TilesRem%)
                    Caption(ScoringLB) = SetText$(Score%)
                    IF TilesRem% < 144 THEN
                        Control(SaveGameBT).Disabled = False
                    ELSE
                        Control(SaveGameBT).Disabled = True
                    END IF
                    PrevType%% = ImType%%(TileSave%(72 - (TilesRem% / 2), 1))
                    IF ImType%%(One%) = PrevType%% THEN
                        Score% = Score% - 6
                        Caption(ScoringLB) = SetText$(Score%)
                    END IF
                    MatchesNone%% = False
                    Control(Label1LB).Hidden = True
                    CanUndo%% = False
                END IF
                NoSel% = 0 ' Undo also removes selection
                IF TilesRem% = 144 THEN Control(UndoBT).Disabled = True
            END IF
        CASE ExitBT
            IF Innit%% THEN
                CALL DoMahjong
            ELSE
                MahPlay%% = False
                Innit%% = True
                TilesRem% = 144 ' Prevents Save at Exit
            END IF
        CASE NewGameBT
            MahPlay%% = False
        CASE SaveGameBT
            MahPlay%% = False
            Innit%% = True
            IF TilesRem% = 0 THEN TilesRem% = 144 ' Prevents Save at Exit
        CASE StillBT
            IF WorldStop%% THEN
                Caption(StillBT) = "Still"
                WorldStop%% = False
            ELSE
                Caption(StillBT) = "Spin"
                WorldStop%% = True
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

SUB DoMahjong
    _SNDPLAYFILE "chrysanthemum.ogg", 4, 0.6
    Caption(ExitBT) = "Exit"
    Control(ScoreLB).Hidden = False
    Control(ScoringLB).Hidden = False
    Control(HighScoreLB).Hidden = False
    Control(HighScoringLB).Hidden = False
    Control(NumberOfTilesLB).Hidden = False
    Control(TilesRemainingLB).Hidden = False
    Innit%% = False
    WHILE NOT Innit%%
        'Initial Values
        IF NOT FromSave%% THEN
            'Empty Grid
            FOR U%% = 1 TO 15
                FOR V%% = 1 TO 8
                    FOR W%% = 1 TO 5
                        Mahjong%(W%%, U%%, V%%) = 0
                    NEXT W%%
                NEXT V%%
            NEXT U%%
            'Randomly Fill Grid
            FOR N% = 1 TO 144
                Empty%% = True
                WHILE Empty%%
                    URnd%% = 1 + INT(15 * RND)
                    VRnd%% = 1 + INT(8 * RND)
                    WRnd%% = 1 + INT(5 * RND)
                    IF Mahjong%(WRnd%%, URnd%%, VRnd%%) = 0 AND Template`(WRnd%%, URnd%%, VRnd%%) THEN
                        Mahjong%(WRnd%%, URnd%%, VRnd%%) = N%
                        ImPos%%(N%, 0) = WRnd%%
                        ImPos%%(N%, 1) = URnd%%
                        ImPos%%(N%, 2) = VRnd%%
                        Empty%% = False
                    END IF
                WEND
            NEXT N%
            Mahjong%(1, 1, 5) = 145
            Mahjong%(1, 14, 5) = 145
            Mahjong%(5, 7, 5) = 145
            Mahjong%(5, 8, 4) = 145
            Mahjong%(5, 8, 5) = 145
            TilesRem% = 144
            Score% = 0
            Counter& = 0
            PrevType%% = 0
        END IF
        MahPlay%% = True
        NoSel% = 0
        NoHov% = 0
        MatchesNone%% = False
        MatchBeeped%% = False
        ECount%% = 0
        EIndex%% = 0
        BCount%% = 0
        Blink%% = True
        CanUndo%% = True
        UCount%% = 0
        WorldStop%% = False
        Control(NewGameBT).Disabled = True
        Control(SaveGameBT).Disabled = True
        Control(StillBT).Disabled = False
        IF FromSave%% THEN
            FromSave%% = False
            Control(UndoBT).Disabled = False
        ELSE
            Control(UndoBT).Disabled = True
        END IF
        Control(Label1LB).Hidden = True
        Caption(Label1LB) = "No Matches Available"
        Caption(ScoringLB) = SetText$(Score%)
        Caption(HighScoringLB) = SetText$(HighScore%)
        Caption(TilesRemainingLB) = SetText$(TilesRem%)
        WHILE MahPlay%%
            _LIMIT 2 * FrameRate%
            XMouse% = __UI_MouseLeft: YMouse% = __UI_MouseTop
            IF MatchesNone%% THEN
                IF NOT MatchBeeped%% THEN
                    _SNDPLAYFILE "NoMatch.ogg", 3, 0.8
                    MatchBeeped%% = True
                    Control(Label1LB).Hidden = False
                END IF
            ELSE
                MatchBeeped%% = False
            END IF
            IF WorldStop%% THEN
                EIndex%% = 8
            ELSE
                ECount%% = ECount%% + 1
                IF ECount%% = 12 THEN
                    ECount%% = 0
                    EIndex%% = EIndex%% + 1
                    IF EIndex%% > 11 THEN EIndex%% = 0
                END IF
            END IF
            BCount%% = BCount%% + 1
            IF Blink%% AND BCount%% = 40 THEN
                BCount%% = 0
                Blink%% = False
            ELSEIF NOT Blink%% AND BCount%% = 10 THEN
                BCount%% = 0
                Blink%% = True
            END IF
            IF NOT CanUndo%% THEN UCount%% = UCount%% + 1
            IF UCount%% = 32 THEN
                CanUndo%% = True
                UCount%% = 0
            END IF
            'Following is to adjust score for time in game
            Counter& = Counter& + 1
            IF Counter& > 33000 AND TilesRem% > 0 THEN
                IF Counter& / 1800 = Counter& \ 1800 THEN
                    IF Score% > 100 THEN
                        Score% = Score% - 1
                        Caption(ScoringLB) = SetText$(Score%)
                    END IF
                END IF
            END IF
            k1$ = INKEY$
            IF k1$ <> "" THEN
                IF ASC(k1$) = 27 THEN
                    MahPlay%% = False
                    Innit%% = True
                    TilesRem% = 144
                END IF
            END IF
            __UI_DoEvents
        WEND
        IF Score% > HighScore% THEN HighScore% = Score%
    WEND
    'Free images
    FOR N% = 1 TO 42
        _FREEIMAGE TileIm&(N%)
    NEXT N%
    _FREEIMAGE HoverImg&
    _FREEIMAGE SelectImg&
    _FREEIMAGE SimilarImg&
    _FREEIMAGE EarthIm&
    _FREEIMAGE BackImg&
    _FREEIMAGE Blossom&
    _FREEIMAGE Borders&
    'Write Data
    OPEN "mahjong.cfg" FOR OUTPUT AS #1
    PRINT #1, HighScore%
    PRINT #1, TilesRem%
    IF TilesRem% < 144 THEN
        'Print Save data
        PRINT #1, Score%
        PRINT #1, Counter&
        FOR U%% = 1 TO 15
            FOR V%% = 1 TO 8
                FOR W%% = 1 TO 5
                    PRINT #1, Mahjong%(W%%, U%%, V%%),
                NEXT W%%
                PRINT #1, ""
            NEXT V%%
        NEXT U%%
        FOR N% = 1 TO 144
            PRINT #1, ImPos%%(N%, 0), ImPos%%(N%, 1), ImPos%%(N%, 2)
        NEXT N%
        FOR N% = 1 TO 72 - (TilesRem% / 2)
            PRINT #1, TileSave%(N%, 1), TileSave%(N%, 0)
        NEXT N%
    END IF
    CLOSE #1
    SYSTEM
END SUB

'$INCLUDE:'../../InForm/InForm.ui'
'$INCLUDE:'../../InForm/xp.uitheme'
