': Fahrenheit-Celsius Converter by Qwerkey 16/05/20
': Images: pngimg.com
': This program uses
': InForm - GUI library for QB64 - v1.1
': Fellippe Heitor, 2016-2019 - fellippe@qb64.org - @fellippeheitor
': https://github.com/FellippeHeitor/InForm
'-----------------------------------------------------------

$ASSERTS

': Controls' IDs: ------------------------------------------------------------------
DIM SHARED FahrenheitToCelsius AS LONG
DIM SHARED ScaleFrame AS LONG
DIM SHARED FahrenheitPBox AS LONG
DIM SHARED CelsiusPBox AS LONG
DIM SHARED DispPB AS LONG
DIM SHARED BodyTempRB AS LONG
DIM SHARED RoomTempRB AS LONG
DIM SHARED FahrenheitTB AS LONG
DIM SHARED CelsiusTB AS LONG
DIM SHARED FahrenheitLB AS LONG
DIM SHARED CelsiusLB AS LONG
DIM SHARED FixTextBoxesTS AS LONG
DIM SHARED FixTextBoxesLB AS LONG
DIM SHARED ExitBT AS LONG
DIM SHARED PicUpdate%%, FSetTemp!, CSetTemp!
DIM SHARED InFahrenheit%%, InCelsius%%, TClicked%%, TempT!

CONST FPos% = 12, CPos% = 31, YPos% = 20, TFPos% = 28, TCPos% = 47, TYPos% = 38, ScaleMin% = 668
CONST TT% = 38, TB% = 668, FL% = 82, FR% = 106, CL% = 321, CR% = 345

': External modules: ---------------------------------------------------------------
'$INCLUDE:'../../InForm/InForm.bi'
'$INCLUDE:'Fahrenheit-Celsius.frm'

': Functions: ----------------------------------------------------------------------
FUNCTION FTOC! (T!, Deg%%)
    IF Deg%% THEN
        FTOC! = (T! - 32) * 5 / 9
    ELSE
        FTOC! = (T! * 9 / 5) + 32
    END IF
END FUNCTION

FUNCTION OnePlace! (Qty!)
    OnePlace! = CINT(10 * Qty!) / 10
END FUNCTION

FUNCTION IText$ (J!)
    __IText$ = LTRIM$(STR$(J!))
    IText$ = __IText$
    IF LEFT$(__IText$, 1) = "." THEN
        IText$ = "0" + __IText$
    ELSEIF LEFT$(__IText$, 2) = "-." THEN
        IText$ = "-0." + RIGHT$(__IText$, LEN(__IText$) - 2)
    END IF
END FUNCTION

': Event procedures: ---------------------------------------------------------------
SUB __UI_BeforeInit
END SUB

SUB __UI_OnLoad
    _SCREENMOVE 120, 5
END SUB

SUB __UI_BeforeUpdateDisplay
    'This event occurs at approximately 30 frames per second.
    'You can change the update frequency by calling SetFrameRate DesiredRate%
    STATIC InitDone%%, FThermometer&, TBase&, FLiquid&, CThermometer&, CLiquid&
    STATIC FT%, FB%, FS%, CT%, CB%, CS%, FTMax%, CTMax%, TD%, FTMin%, CTMin%, OldScale%%
    STATIC Pics&(), TRange!()

    IF NOT InitDone%% THEN
        ': Everything (except events)  is done in the __UI_BeforeUpdateDisplay SUB
        ': All initiations, image loading & manipulations are done once  here
        InitDone%% = True
        DIM Pics&(1, 4), TRange!(1, 3)
        ': Read temperature Ranges
        RESTORE temp_range
        FOR I1%% = 0 TO 1
            FOR J1%% = 0 TO 3
                READ TRange!(I1%%, J1%%)
            NEXT J1%%
        NEXT I1%%
        ': Load Images
        FOR J1%% = 0 TO 4
            Pics&(0, J1%%) = _LOADIMAGE("temp" + IText$(J1%%) + ".png", 32)
            _ASSERT Pics&(0, J1%%) < -1, "Failed to load temp" + IText$(J1%%) + ".png"
            Pics&(1, J1%%) = _LOADIMAGE("temp1" + IText$(J1%%) + ".png", 32)
            _ASSERT Pics&(1, J1%%) < -1, "Failed to load temp1" + IText$(J1%%) + ".png"
        NEXT J1%%
        ': _MEM processing to convert red into green for Celsius thermometer
        DIM CMem AS _MEM, COff AS _OFFSET
        FThermometer& = _LOADIMAGE("thermo.png", 32)
        _ASSERT FThermometer& < -1, "Failed to load thermo.png"
        TBase& = _LOADIMAGE("tbase.png", 32)
        _ASSERT TBase& < -1, "Failed to load tbase.png"
        FLiquid& = _LOADIMAGE("rbase.png", 32)
        _ASSERT FLiquid& < -1, "Failed to load rbase.png"
        CThermometer& = _LOADIMAGE("thermo.png", 32)
        _ASSERT CThermometer& < -1, "Failed to load thermo.png"
        CLiquid& = _LOADIMAGE("rbase.png", 32)
        _ASSERT CLiquid& < -1, "Failed to load rbase.png"
        CMem = _MEMIMAGE(CThermometer&)
        COff = 0
        WHILE COff < CMem.SIZE
            B1~%% = _MEMGET(CMem, CMem.OFFSET + COff + 1, _UNSIGNED _BYTE) 'Green
            B2~%% = _MEMGET(CMem, CMem.OFFSET + COff + 2, _UNSIGNED _BYTE) 'Red
            IF _MEMGET(CMem, CMem.OFFSET + COff + 3, _UNSIGNED _BYTE) <> 0 THEN 'Alpha
                IF B2~%% / B1~%% > 1.5 THEN
                    _MEMPUT CMem, CMem.OFFSET + COff + 1, B2~%% AS _UNSIGNED _BYTE 'Green
                    _MEMPUT CMem, CMem.OFFSET + COff + 2, B1~%% AS _UNSIGNED _BYTE 'Red
                END IF
            END IF
            COff = COff + 4
        WEND
        _MEMFREE CMem
        CMem = _MEMIMAGE(CLiquid&)
        COff = 0
        WHILE COff < CMem.SIZE
            B1~%% = _MEMGET(CMem, CMem.OFFSET + COff + 1, _UNSIGNED _BYTE) 'Green
            B2~%% = _MEMGET(CMem, CMem.OFFSET + COff + 2, _UNSIGNED _BYTE) 'Red
            IF _MEMGET(CMem, CMem.OFFSET + COff + 3, _UNSIGNED _BYTE) <> 0 THEN 'Alpha
                IF B2~%% / B1~%% > 1.5 THEN
                    _MEMPUT CMem, CMem.OFFSET + COff + 1, B2~%% AS _UNSIGNED _BYTE 'Green
                    _MEMPUT CMem, CMem.OFFSET + COff + 2, B1~%% AS _UNSIGNED _BYTE 'Red
                END IF
            END IF
            COff = COff + 4
        WEND
        _MEMFREE CMem
        ': Display thermometer images in picture boxes
        ': All images are software (,32)
        BeginDraw FahrenheitPBox
        'Drawing code goes here
        _PUTIMAGE (FPos%, YPos%), FThermometer&
        COLOR _RGB32(0, 0, 0), _RGB32(235, 233, 237)
        _PRINTSTRING (72, 20), CHR$(248) + "F"
        EndDraw FahrenheitPBox
        BeginDraw CelsiusPBox
        'Drawing code goes here
        _PUTIMAGE (CPos%, YPos%), CThermometer&
        COLOR _RGB32(0, 0, 0), _RGB32(235, 233, 237)
        _PRINTSTRING (10, 20), CHR$(248) + "C"
        EndDraw CelsiusPBox
    END IF
    ': New Scales
    IF Control(BodyTempRB).Value <> OldScale%% THEN
        OldScale%% = Control(BodyTempRB).Value
        IF OldScale%% THEN
            ': Body Temperature Scales
            FSetTemp! = 98.4
            CSetTemp! = OnePlace!(FTOC!(FSetTemp!, True))
            Text(FahrenheitTB) = IText$(FSetTemp!)
            Text(CelsiusTB) = IText$(CSetTemp!)
            FT% = 44
            FB% = 644
            FS% = 5
            CT% = 50
            CB% = 610
            CS% = 7
            FTMax% = 106
            CTMax% = 42
            TD% = 10
            FTMin% = FTMax% - (FB% - FT%) / (FS% * TD%)
            CTMin% = CTMax% - (CB% - CT%) / (CS% * TD%)
        ELSE
            ': Room Temperature Scales
            FT% = 70
            FB% = 590
            FS% = 2
            CT% = 60
            CB% = 620
            CS% = 4
            FTMax% = 220
            CTMax% = 100
            TD% = 1
            FTMin% = FTMax% - (FB% - FT%) / (FS% * TD%)
            CTMin% = CTMax% - (CB% - CT%) / (CS% * TD%)
        END IF
        ': Draw Scales
        BeginDraw FahrenheitPBox
        LINE (60, TT% - 1)-(100, TB% - 1), _RGB32(235, 233, 237), BF
        LINE (62, FT%)-(62, FB% + 1), _RGB32(0, 0, 0)
        LINE (63, FT%)-(63, FB% + 1), _RGB32(0, 0, 0)
        FOR N% = 0 TO (FB% - FT%) / FS%
            LINE (62, FT% + N% * FS%)-(67, FT% + N% * FS%), _RGB32(0, 0, 0)
            IF N% \ 5 = N% / 5 THEN
                LINE (62, FT% + N% * FS%)-(70, FT% + N% * FS%), _RGB32(0, 0, 0)
                IF N% \ 10 = N% / 10 THEN
                    LINE (62, FT% + 1 + N% * FS%)-(70, FT% + 1 + N% * FS%), _RGB32(0, 0, 0)
                    _PRINTSTRING (72, FT% - 6 + N% * FS%), IText$(FTMax% - N% / TD%)
                END IF
            END IF
        NEXT N%
        EndDraw FahrenheitPBox
        BeginDraw CelsiusPBox
        LINE (0, TT% - 1)-(39, TB% - 1), _RGB32(235, 233, 237), BF
        LINE (38, CT%)-(38, CB% + 1), _RGB32(0, 0, 0)
        LINE (37, CT%)-(37, CB% + 1), _RGB32(0, 0, 0)
        FOR N% = 0 TO (CB% - CT%) / CS%
            LINE (33, CT% + N% * CS%)-(38, CT% + N% * CS%), _RGB32(0, 0, 0)
            IF N% \ 5 = N% / 5 THEN
                LINE (30, CT% + N% * CS%)-(38, CT% + N% * CS%), _RGB32(0, 0, 0)
                IF N% \ 10 = N% / 10 THEN
                    LINE (30, CT% + 1 + N% * CS%)-(38, CT% + 1 + N% * CS%), _RGB32(0, 0, 0)
                    M% = CTMax% - N% / TD%
                    MS$ = IText$(M%)
                    IF M% > 0 AND M% < 100 THEN
                        MS$ = " " + MS$
                    ELSEIF M% = 0 THEN
                        MS$ = "  " + MS$
                    END IF
                    _PRINTSTRING (4, CT% - 6 + N% * CS%), MS$
                END IF
            END IF
        NEXT N%
        EndDraw CelsiusPBox
        PicUpdate%% = True
    END IF
    ': Poll Mouse
    LM% = __UI_MouseLeft
    TM% = __UI_MouseTop
    ': Look for position inside thermometer tubes and check Click
    IF LM% > 70 + TFPos% AND LM% < 70 + TFPos% + 24 AND TM% > FT% AND TM% < FB% THEN
        InFahrenheit%% = True
        TempT! = OnePlace!(FTMax% + ((TM% - FT%) * (FTMin% - FTMax%) / (FB% - FT%)))
        IF NOT TClicked%% THEN Text(FahrenheitTB) = IText$(TempT!)
    ELSEIF LM% > 290 + TCPos% AND LM% < 290 + TCPos% + 24 AND TM% > CT% AND TM% < CB% THEN
        InCelsius%% = True
        TempT! = OnePlace!(CTMax% + (TM% - CT%) * (CTMin% - CTMax%) / (CB% - CT%))
        IF NOT TClicked%% THEN Text(CelsiusTB) = IText$(TempT!)
    ELSE
        IF InFahrenheit%% AND NOT TClicked%% THEN
            Text(FahrenheitTB) = IText$(FSetTemp!)
        ELSEIF InCelsius%% AND NOT TClicked%% THEN
            Text(CelsiusTB) = IText$(CSetTemp!)
        END IF
        InFahrenheit%% = False
        InCelsius%% = False
        IF TClicked%% THEN TClicked%% = False
    END IF
    ': Update thermometers
    IF PicUpdate%% THEN
        PicUpdate%% = False
        YF% = FT% + (FSetTemp! - FTMax%) * (FB% - FT%) / (FTMin% - FTMax%)
        YC% = CT% + (CSetTemp! - CTMax%) * (CB% - CT%) / (CTMin% - CTMax%)
        BeginDraw FahrenheitPBox
        _PUTIMAGE (TFPos%, TYPos%), TBase&
        IF YF% >= FT% AND YF% <= FB% THEN _PUTIMAGE (TFPos%, YF%)-(TFPos% + 24, ScaleMin%), FLiquid&, , (0, 0)-(24, ScaleMin% - YF%)
        EndDraw FahrenheitPBox
        BeginDraw CelsiusPBox
        _PUTIMAGE (TCPos%, TYPos%), TBase&
        IF YC% >= CT% AND YC% <= CB% THEN _PUTIMAGE (TCPos%, YC%)-(TCPos% + 24, ScaleMin%), CLiquid&, , (0, 0)-(24, ScaleMin% - YC%)
        EndDraw CelsiusPBox
        ': If temperature outside thermometer scale do not display liquid column
        IF YF% < FT% OR YF% > FB% THEN YF% = ScaleMin%
        IF YC% < CT% OR YC% > CB% THEN YC% = ScaleMin%
        ': If fixed text boxes, set at default
        IF Control(FixTextBoxesTS).Value THEN
            YF% = 396
            YC% = 396
        END IF
        Control(FahrenheitTB).Top = YF% - 8
        Control(CelsiusTB).Top = YC% - 8
        Control(FahrenheitLB).Top = YF% - 8 - 23
        Control(CelsiusLB).Top = YC% - 8 - 23
        ': Display Image dependent upon temperature range
        BeginDraw DispPB
        LINE (0, 0)-(119, 199), _RGB32(235, 233, 237), BF
        IF Control(BodyTempRB).Value THEN
            SELECT CASE FSetTemp!
                CASE IS < TRange!(0, 0)
                    _PUTIMAGE , Pics&(0, 0)
                CASE TRange!(0, 0) TO TRange!(0, 1)
                    _PUTIMAGE , Pics&(0, 1)
                CASE TRange!(0, 1) TO TRange!(0, 2)
                    _PUTIMAGE , Pics&(0, 2)
                CASE TRange!(0, 2) TO TRange!(0, 3)
                    _PUTIMAGE , Pics&(0, 3)
                CASE IS > TRange!(0, 3)
                    _PUTIMAGE , Pics&(0, 4)
            END SELECT
        ELSE
            SELECT CASE CSetTemp!
                CASE IS < TRange!(1, 0)
                    _PUTIMAGE , Pics&(1, 0)
                CASE TRange!(1, 0) TO TRange!(1, 1)
                    _PUTIMAGE , Pics&(1, 1)
                CASE TRange!(1, 1) TO TRange!(1, 2)
                    _PUTIMAGE , Pics&(1, 2)
                CASE TRange!(1, 2) TO TRange!(1, 3)
                    _PUTIMAGE , Pics&(1, 3)
                CASE IS > TRange!(1, 3)
                    _PUTIMAGE , Pics&(1, 4)
            END SELECT
        END IF
        EndDraw DispPB
    END IF

    temp_range:
    DATA 96.4,97.4,99.4,100.4
    DATA -10,10,30,50
END SUB

SUB __UI_BeforeUnload
    'If you set __UI_UnloadSignal = False here you can
    'cancel the user's request to close.
END SUB

SUB __UI_Click (id AS LONG)
    SELECT CASE id
        CASE FahrenheitToCelsius

        CASE ScaleFrame

        CASE DispPB

        CASE BodyTempRB

        CASE RoomTempRB

        CASE FahrenheitTB

        CASE CelsiusTB

        CASE FahrenheitLB

        CASE CelsiusLB

        CASE FixTextBoxesLB

        CASE FahrenheitPBox
            ': Check for click in thermometer columns
            IF InFahrenheit%% AND NOT TClicked%% THEN
                TClicked%% = True
                FSetTemp! = OnePlace!(TempT!)
                Text(FahrenheitTB) = IText$(FSetTemp!)
                CSetTemp! = OnePlace!(FTOC!(FSetTemp!, True))
                Text(CelsiusTB) = IText$(CSetTemp!)
                PicUpdate%% = True
            END IF
        CASE CelsiusPBox
            ': Check for click in thermometer columns
            IF InCelsius%% AND NOT TClicked%% THEN
                TClicked%% = True
                CSetTemp! = OnePlace!(TempT!)
                Text(CelsiusTB) = IText$(CSetTemp!)
                FSetTemp! = OnePlace!(FTOC!(CSetTemp!, False))
                Text(FahrenheitTB) = IText$(FSetTemp!)
                PicUpdate%% = True
            END IF
        CASE FixTextBoxesTS
            ': Check for Toggle Switch Click
            PicUpdate%% = True
        CASE ExitBT
            ': Click Exit Button
            SYSTEM
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
    IF __UI_KeyHit = 27 THEN 'Esc key (only responds after a Click event has happened)
        SYSTEM
    ELSEIF __UI_KeyHit = 13 THEN 'CR
        SELECT CASE id
            CASE BodyTempRB

            CASE RoomTempRB

            CASE FixTextBoxesTS

            CASE FahrenheitTB
                ': Update Fahrenheit temperature & convert
                FSetTemp! = OnePlace!(VAL(Text(FahrenheitTB)))
                Text(FahrenheitTB) = IText$(FSetTemp!)
                CSetTemp! = OnePlace!(FTOC!(FSetTemp!, True))
                Text(CelsiusTB) = IText$(CSetTemp!)
                PicUpdate%% = True
            CASE CelsiusTB
                ': Update Celsius temperature & convert
                CSetTemp! = OnePlace!(VAL(Text(CelsiusTB)))
                Text(CelsiusTB) = IText$(CSetTemp!)
                FSetTemp! = OnePlace!(FTOC!(CSetTemp!, False))
                Text(FahrenheitTB) = IText$(FSetTemp!)
                PicUpdate%% = True
            CASE ExitBT
                SYSTEM 'Does this condition ever get met?
        END SELECT
    END IF
END SUB

SUB __UI_TextChanged (id AS LONG)
END SUB

SUB __UI_ValueChanged (id AS LONG)
END SUB

SUB __UI_FormResized
END SUB

'$INCLUDE:'../../InForm/InForm.ui'
'$INCLUDE:'../../InForm/xp.uitheme'
