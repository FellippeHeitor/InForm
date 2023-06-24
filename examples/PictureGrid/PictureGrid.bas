': Picture Grid Program by QWERKEY 2019-01-14
': This program uses
': InForm - GUI library for QB64 - Beta version 8
': Fellippe Heitor, 2016-2018 - fellippe@qb64.org - @fellippeheitor
': https://github.com/FellippeHeitor/InForm
'-----------------------------------------------------------

': Controls' IDs: ------------------------------------------------------------------
DIM SHARED PictureGrid AS LONG
DIM SHARED PictureGridLB AS LONG
DIM SHARED SetSkillLevelLB AS LONG
DIM SHARED OneBT AS LONG
DIM SHARED TwoBT AS LONG
DIM SHARED ThreeBT AS LONG
DIM SHARED ExitBT AS LONG
DIM SHARED NewGameBT AS LONG
CONST ScreenWidth% = 408, ScreenHeight%% = 600
REDIM SHARED RowCol%%(2, 1), Grid%%(2, 2)
DIM SHARED Portraits$(2), UsedImage&, PictureWidth%, PictureHeight%, FrameRate%, Highlight&
DIM SHARED Horiz%%, Vert%%, InPlay`, Level%%, MoveIt%%, ValidSquare`

': External modules: ---------------------------------------------------------------
'$INCLUDE:'../../InForm/InForm.bi'
'$INCLUDE:'PictureGrid.frm'

': Event procedures & Functions: ---------------------------------------------------------------
FUNCTION MakeHardware& (Img&)
    MakeHardware& = _COPYIMAGE(Img&, 33)
    _FREEIMAGE Img&
END FUNCTION

SUB __UI_BeforeInit
    RANDOMIZE (TIMER)
    _TITLE "Picture Grid"
    $EXEICON:'.\Vincent.ico'
    RESTORE game_data
    FOR N%% = 0 TO 2
        FOR M%% = 0 TO 1
            READ RowCol%%(N%%, M%%)
        NEXT M%%
    NEXT N%%
    FOR N%% = 0 TO 2
        READ Portraits$(N%%)
    NEXT N%%
    FrameRate% = 30
    InPlay` = False

    game_data:
    DATA 2,3
    DATA 3,4
    DATA 4,6
    DATA "Gioconda","Vincent","DNA"
END SUB

SUB __UI_OnLoad
    Control(NewGameBT).Disabled = True
    Control(NewGameBT).Hidden = True
    CALL JeuNouveau
    SetFrameRate FrameRate%
END SUB

SUB __UI_BeforeUpdateDisplay
    'This event occurs at approximately 30 frames per second.
    'You can change the update frequency by calling SetFrameRate DesiredRate%
    IF InPlay` THEN
        _PUTIMAGE (ScreenWidth% + 10, 0), UsedImage&
        FOR N%% = 1 TO RowCol%%(Level%%, 0)
            FOR M%% = 1 TO RowCol%%(Level%%, 1)
                Occ%% = Grid%%(N%%, M%%)
                IF Occ%% <> 0 THEN
                    Row%% = (Occ%% - 1) MOD RowCol%%(Level%%, 1) '+ 1
                    Col%% = ((Occ%% - 1) \ RowCol%%(Level%%, 1)) '+ 1
                    _PUTIMAGE (2 + (N%% - 1) * ScreenWidth% / RowCol%%(Level%%, 0), 2 + (M%% - 1) * ScreenHeight%% / RowCol%%(Level%%, 1))-(N%% * ScreenWidth% / RowCol%%(Level%%, 0) - 2, M%% * ScreenHeight%% / RowCol%%(Level%%, 1) - 2), UsedImage&, , (Col%% * PictureWidth% \ RowCol%%(Level%%, 0), Row%% * PictureHeight% \ RowCol%%(Level%%, 1))-((Col%% + 1) * PictureWidth% \ RowCol%%(Level%%, 0), (Row%% + 1) * PictureHeight% \ RowCol%%(Level%%, 1))
                END IF
            NEXT M%%
        NEXT N%%
        IF ValidSquare` THEN _PUTIMAGE (2 + (Horiz%% - 1) * ScreenWidth% / RowCol%%(Level%%, 0), 2 + (Vert%% - 1) * ScreenHeight% / RowCol%%(Level%%, 1)), Highlight& '!!!TBF
    END IF
END SUB

SUB __UI_BeforeUnload
    'If you set __UI_UnloadSignal = False here you can
    'cancel the user's request to close.
END SUB

SUB __UI_Click (id AS LONG)
    SELECT CASE id
        CASE PictureGridLB

        CASE SetSkillLevelLB

        CASE PictureGrid
            IF ValidSquare` THEN
                SELECT CASE MoveIt%%
                    CASE 1
                        Grid%%(Horiz%% + 1, Vert%%) = Grid%%(Horiz%%, Vert%%)
                        bytPlace%% = Grid%%(Horiz%%, Vert%%)
                        Grid%%(Horiz%%, Vert%%) = 0
                        bytRow%% = (bytPlace%% - 1) MOD RowCol%%(Level%%, 1)
                        bytCol%% = ((bytPlace%% - 1) \ RowCol%%(Level%%, 1))
                    CASE 2
                        Grid%%(Horiz%%, Vert%% + 1) = Grid%%(Horiz%%, Vert%%)
                        bytPlace%% = Grid%%(Horiz%%, Vert%%)
                        Grid%%(Horiz%%, Vert%%) = 0
                        bytRow%% = (bytPlace%% - 1) MOD RowCol%%(Level%%, 1)
                        bytCol%% = ((bytPlace%% - 1) \ RowCol%%(Level%%, 1))
                    CASE 3
                        Grid%%(Horiz%% - 1, Vert%%) = Grid%%(Horiz%%, Vert%%)
                        bytPlace%% = Grid%%(Horiz%%, Vert%%)
                        Grid%%(Horiz%%, Vert%%) = 0
                        bytRow%% = (bytPlace%% - 1) MOD RowCol%%(Level%%, 1)
                        bytCol%% = ((bytPlace%% - 1) \ RowCol%%(Level%%, 1))
                    CASE 4
                        Grid%%(Horiz%%, Vert%% - 1) = Grid%%(Horiz%%, Vert%%)
                        bytPlace%% = Grid%%(Horiz%%, Vert%%)
                        Grid%%(Horiz%%, Vert%%) = 0
                        bytRow%% = (bytPlace%% - 1) MOD RowCol%%(Level%%, 1)
                        bytCol%% = ((bytPlace%% - 1) \ RowCol%%(Level%%, 1))
                END SELECT
            END IF
        CASE OneBT
            Level%% = 0
            CALL Slider
        CASE TwoBT
            Level%% = 1
            CALL Slider
        CASE ThreeBT
            Level%% = 2
            CALL Slider
        CASE ExitBT
            SYSTEM
        CASE NewGameBT
            InPlay` = False
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

SUB JeuNouveau
    Control(__UI_FormID).Width = 310
    Control(__UI_FormID).Height = 360
    Control(PictureGridLB).Disabled = False
    Control(PictureGridLB).Hidden = False
    Control(SetSkillLevelLB).Disabled = False
    Control(SetSkillLevelLB).Hidden = False
    Control(OneBT).Disabled = False
    Control(OneBT).Hidden = False
    Control(TwoBT).Disabled = False
    Control(TwoBT).Hidden = False
    Control(ThreeBT).Disabled = False
    Control(ThreeBT).Hidden = False
    Control(NewGameBT).Disabled = True
    Control(NewGameBT).Hidden = True
    Control(ExitBT).Top = Control(__UI_FormID).Height - 39
    Control(ExitBT).Left = Control(__UI_FormID).Width - 96
    SetFocus ExitBT
END SUB

SUB Slider
    Control(__UI_FormID).Width = (2 * ScreenWidth%) + 10
    Control(__UI_FormID).Height = ScreenHeight%
    Control(PictureGridLB).Disabled = True
    Control(PictureGridLB).Hidden = True
    Control(SetSkillLevelLB).Disabled = True
    Control(SetSkillLevelLB).Hidden = True
    Control(OneBT).Disabled = True
    Control(OneBT).Hidden = True
    Control(TwoBT).Disabled = True
    Control(TwoBT).Hidden = True
    Control(ThreeBT).Disabled = True
    Control(ThreeBT).Hidden = True
    Control(ExitBT).Top = Control(__UI_FormID).Height - 39
    Control(ExitBT).Left = Control(__UI_FormID).Width - 96
    Control(NewGameBT).Top = Control(__UI_FormID).Height - 73
    Control(NewGameBT).Left = Control(__UI_FormID).Width - 96
    SetFocus ExitBT
    REDIM Grid%%(RowCol%%(Level%%, 0) + 1, RowCol%%(Level%%, 1) + 1) ' 1 extra dimension per side
    UsedImage& = _LOADIMAGE(Portraits$(INT(3 * RND)) + ".png", 33)
    PictureWidth% = _WIDTH(UsedImage&)
    PictureHeight% = _HEIGHT(UsedImage&)
    C%% = 1
    FOR N%% = 1 TO RowCol%%(Level%%, 0)
        FOR M%% = 1 TO RowCol%%(Level%%, 1)
            Grid%%(N%%, M%%) = C%%
            C%% = C%% + 1
        NEXT M%%
    NEXT N%%
    Grid%%(RowCol%%(Level%%, 0), RowCol%%(Level%%, 1)) = 0
    U%% = RowCol%%(Level%%, 0): V%% = RowCol%%(Level%%, 1)
    C%% = 0
    DO UNTIL C%% >= 100 AND Grid%%(1, 1) = 0
        R14%% = 1 + INT(4 * RND)
        IF R14%% = 1 AND V%% - 1 > 0 THEN 'move space up 1
            Grid%%(U%%, V%%) = Grid%%(U%%, V%% - 1)
            V%% = V%% - 1
            Grid%%(U%%, V%%) = 0
            C%% = C%% + 1
        ELSEIF R14%% = 2 AND U%% + 1 <= RowCol%%(Level%%, 0) THEN 'move space right 1
            Grid%%(U%%, V%%) = Grid%%(U%% + 1, V%%)
            U%% = U%% + 1
            Grid%%(U%%, V%%) = 0
            C%% = C%% + 1
        ELSEIF R14%% = 3 AND V%% + 1 <= RowCol%%(Level%%, 1) THEN 'move space down 1
            Grid%%(U%%, V%%) = Grid%%(U%%, V%% + 1)
            V%% = V%% + 1
            Grid%%(U%%, V%%) = 0
            C%% = C%% + 1
        ELSEIF R14%% = 4 AND U%% - 1 > 0 THEN 'move space right 1
            Grid%%(U%%, V%%) = Grid%%(U%% - 1, V%%)
            U%% = U%% - 1
            Grid%%(U%%, V%%) = 0
            C%% = C%% + 1
        END IF
    LOOP
    TempImg& = _NEWIMAGE(ScreenWidth% / RowCol%%(Level%%, 0) - 3, ScreenHeight%% / RowCol%%(Level%%, 1) - 3, 32)
    _DEST TempImg&
    COLOR _RGB32(0, 176, 0), _RGBA32(100, 100, 100, 0)
    CLS
    LINE (0, 0)-(ScreenWidth% / RowCol%%(Level%%, 0) - 4, ScreenHeight%% / RowCol%%(Level%%, 1) - 4), , B
    LINE (1, 1)-(ScreenWidth% / RowCol%%(Level%%, 0) - 5, ScreenHeight%% / RowCol%%(Level%%, 1) - 5), , B
    Highlight& = MakeHardware&(TempImg&)
    ValidSquare` = False
    InPlay` = True
    IsComplete` = False
    WHILE InPlay`
        _LIMIT 2 * FrameRate%
        XMouse% = __UI_MouseLeft
        YMouse% = __UI_MouseTop
        ValidSquare` = False
        IF NOT IsComplete` THEN
            Horiz%% = 1 + ((XMouse% - 3) \ (ScreenWidth% / RowCol%%(Level%%, 0)))
            Vert%% = 1 + ((YMouse% - 3) \ (ScreenHeight%% / RowCol%%(Level%%, 1)))
            ModHoriz% = ((XMouse% - 3) MOD (ScreenWidth% / RowCol%%(Level%%, 0)))
            ModVert% = ((YMouse% - 3) MOD (ScreenHeight%% / RowCol%%(Level%%, 1)))
            IF XMouse% < ScreenWidth% - 3 AND XMouse% > 3 AND YMouse% < ScreenHeight%% - 3 AND YMouse% > 3 THEN
                IF Grid%%(Horiz%%, Vert%%) <> 0 THEN
                    IF ModHoriz% < ScreenWidth% / RowCol%%(Level%%, 0) - 6 AND ModVert% < ScreenHeight%% / RowCol%%(Level%%, 1) - 6 THEN
                        IF Grid%%(Horiz%% + 1, Vert%%) = 0 AND Horiz%% + 1 <= RowCol%%(Level%%, 0) THEN
                            MoveIt%% = 1
                            ValidSquare` = True
                        ELSEIF Grid%%(Horiz%%, Vert%% + 1) = 0 AND Vert%% + 1 <= RowCol%%(Level%%, 1) THEN
                            MoveIt%% = 2
                            ValidSquare` = True
                        ELSEIF Grid%%(Horiz%% - 1, Vert%%) = 0 AND Horiz%% - 1 > 0 THEN
                            MoveIt%% = 3
                            ValidSquare` = True
                        ELSEIF Grid%%(Horiz%%, Vert%% - 1) = 0 AND Vert%% - 1 > 0 THEN
                            MoveIt%% = 4
                            ValidSquare` = True
                        END IF
                    END IF
                END IF
            END IF
            AllCorrect` = True
            N%% = 1: M%% = 1
            WHILE AllCorrect` AND (M%% + RowCol%%(Level%%, 1) * (N%% - 1)) < RowCol%%(Level%%, 0) * RowCol%%(Level%%, 1)
                IF Grid%%(N%%, M%%) <> M%% + RowCol%%(Level%%, 1) * (N%% - 1) THEN
                    AllCorrect` = False
                ELSE
                    M%% = M%% + 1
                    IF M%% > RowCol%%(Level%%, 1) THEN
                        M%% = 1
                        N%% = N%% + 1
                    END IF
                END IF
            WEND
            IF AllCorrect` THEN
                _SNDPLAYFILE ("fanfare.mp3")
                Control(NewGameBT).Disabled = False
                Control(NewGameBT).Hidden = False
                IsComplete` = True
                SetFocus NewGameBT
            END IF
        END IF
        K$ = INKEY$
        IF K$ <> "" THEN
            IF ASC(K$) = 27 THEN SYSTEM
        END IF
        K$ = ""
        __UI_DoEvents
    WEND
    ValidSquare` = False
    _FREEIMAGE Highlight&
    CALL JeuNouveau
END SUB

'$INCLUDE:'../../InForm/InForm.ui'
'$INCLUDE:'../../InForm/xp.uitheme'
