SUB DemoRoutine
    STATIC ByJupiter%%, DemoText$(), N%, T$
    IF N% = 0 THEN
        DIM DemoText$(27)
        OPEN "demodat.dat" FOR INPUT AS #1
        WHILE NOT EOF(1)
            INPUT #1, DemoText$(N%)
            N% = N% + 1
        WEND
        CLOSE #1
    END IF
    SELECT CASE NoCycles&
        CASE 10000
            T$ = DemoText$(0)
            Caption(DemoLabel1LB) = T$
            Breadth% = LEN(T$)
            ByJupiter%% = 0
            CALL ToDisp((Galaxy#(ByJupiter%%, 1)), (Galaxy#(ByJupiter%%, 2)), (Galaxy#(ByJupiter%%, 3)), U%, V%, C2%%)
            Control(DemoLabel1LB).Width = 9.2 * Breadth%
            Control(DemoLabel1LB).Left = U% - 4.6 * Breadth%
            Control(DemoLabel1LB).Top = V% + 20
            Control(DemoLabel1LB).Hidden = False
        CASE 12000
            PlanetAnim%% = ByJupiter%%
        CASE 25000
            Control(DemoLabel1LB).Hidden = True
        CASE 30000
            T$ = DemoText$(1)
            Caption(DemoLabel1LB) = T$
            Control(DemoLabel1LB).Width = 9.2 * LEN(T$)
            Control(DemoLabel1LB).Left = (Uscreen% - 9.2 * LEN(T$)) / 2
            Control(DemoLabel1LB).Top = 120
            Control(DemoLabel1LB).Hidden = False
        CASE 32000
            ByJupiter%% = 1
            PlanetAnim%% = ByJupiter%%
        CASE 45000
            ByJupiter%% = 2
            CALL ToDisp((Galaxy#(ByJupiter%%, 1)), (Galaxy#(ByJupiter%%, 2)), (Galaxy#(ByJupiter%%, 3)), U%, V%, C2%%)
            T$ = DemoText$(2)
            Breadth% = LEN(T$)
            Caption(DemoLabel2LB) = T$
            Control(DemoLabel2LB).Width = 9.2 * Breadth%
            Control(DemoLabel2LB).Left = U% - 4.6 * Breadth%
            Control(DemoLabel2LB).Top = V% + 20
            Control(DemoLabel2LB).Hidden = False
        CASE 47500
            Control(DemoLabel1LB).Hidden = True
            PlanetAnim%% = ByJupiter%%
        CASE 60000
            Control(DemoLabel2LB).Hidden = True
        CASE 65000
            T$ = DemoText$(3)
            UpArrow%% = True
            ArrowTop% = 68: ArrowLeft% = 970
            Caption(DemoLabel1LB) = T$
            Control(DemoLabel1LB).Width = 9.2 * LEN(T$)
            Control(DemoLabel1LB).Left = ArrowLeft% - 9.2 * LEN(T$)
            Control(DemoLabel1LB).Top = ArrowTop%
            Control(DemoLabel1LB).Hidden = False
        CASE 67500
            CALL Zoomer((False))
            Control(ZoomOutCB).Value = True
        CASE 67700
            Control(ZoomOutCB).Value = False
        CASE 70000
            CALL Zoomer((False))
            Control(ZoomOutCB).Value = True
        CASE 70200
            Control(ZoomOutCB).Value = False
        CASE 72500
            CALL Zoomer((False))
            Control(ZoomOutCB).Value = True
        CASE 72700
            Control(ZoomOutCB).Value = False
        CASE 75000
            Control(DemoLabel1LB).Hidden = True
            EndArrow%% = True
        CASE 77500
            T$ = DemoText$(4)
            Caption(DemoLabel1LB) = T$
            ByJupiter%% = 3
            Control(DemoLabel1LB).Width = 9.2 * LEN(T$)
            Control(DemoLabel1LB).Left = (Uscreen% - 9.2 * LEN(T$)) / 2
            Control(DemoLabel1LB).Top = 100
            Control(DemoLabel1LB).Hidden = False
        CASE 82500
            PlanetAnim%% = ByJupiter%%
        CASE 97500
            ByJupiter%% = 10
            CALL ToDisp((Galaxy#(ByJupiter%%, 1)), (Galaxy#(ByJupiter%%, 2)), (Galaxy#(ByJupiter%%, 3)), U%, V%, C2%%)
            T$ = DemoText$(5)
            Caption(DemoLabel2LB) = T$
            Control(DemoLabel2LB).Width = 9.2 * LEN(T$)
            Control(DemoLabel2LB).Left = (Uscreen% - 9.2 * LEN(T$)) / 2
            Control(DemoLabel2LB).Top = 140
            Control(DemoLabel2LB).Hidden = False
            PlanetAnim%% = ByJupiter%%
        CASE 110000
            ByJupiter%% = 3
            CALL ToDisp((Galaxy#(ByJupiter%%, 1)), (Galaxy#(ByJupiter%%, 2)), (Galaxy#(ByJupiter%%, 3)), U%, V%, C2%%)
            Control(DemoLabel2LB).Hidden = True
            T$ = DemoText$(6)
            Caption(DemoLabel1LB) = T$
            Control(DemoLabel1LB).Width = 9.2 * LEN(T$)
            Control(DemoLabel1LB).Left = (U% - 4.6 * LEN(T$))
            Control(DemoLabel1LB).Top = V% + 20
        CASE 117500
            Control(DemoLabel1LB).Hidden = True
        CASE 120000
            ByJupiter%% = 4
            CALL ToDisp((Galaxy#(ByJupiter%%, 1)), (Galaxy#(ByJupiter%%, 2)), (Galaxy#(ByJupiter%%, 3)), U%, V%, C2%%)
            T$ = DemoText$(7)
            Caption(DemoLabel1LB) = T$
            Control(DemoLabel1LB).Width = 9.2 * LEN(T$)
            Control(DemoLabel1LB).Left = (U% - 4.6 * LEN(T$))
            Control(DemoLabel1LB).Top = V% + 20
            Control(DemoLabel1LB).Hidden = False
        CASE 122500
            PlanetAnim%% = ByJupiter%%
        CASE 130000
            Control(DemoLabel1LB).Hidden = True
        CASE 132500
            T$ = DemoText$(8)
            Caption(DemoLabel1LB) = T$
            Control(DemoLabel1LB).Width = 9.2 * LEN(T$)
            Control(DemoLabel1LB).Left = (Uscreen% - 9.2 * LEN(T$)) / 2
            Control(DemoLabel1LB).Top = 100
            Control(DemoLabel1LB).Hidden = False
            T$ = DemoText$(9)
            Caption(DemoLabel2LB) = T$
            Control(DemoLabel2LB).Width = 9.2 * LEN(T$)
            Control(DemoLabel2LB).Left = (Uscreen% - 9.2 * LEN(T$)) / 2
            Control(DemoLabel2LB).Top = 140
            Control(DemoLabel2LB).Hidden = False
        CASE 140000
            T$ = DemoText$(10)
            Caption(DemoLabel2LB) = T$
            Control(DemoLabel2LB).Width = 9.2 * LEN(T$)
            Control(DemoLabel2LB).Left = (Uscreen% - 9.2 * LEN(T$)) / 2
            Control(DemoLabel2LB).Top = 140
            Control(DemoLabel2LB).Hidden = False
        CASE 147500
        Control(DemoLabel1LB).Hidden = True
        Control(DemoLabel2LB).Hidden = True
        CASE 152500
            T$ = DemoText$(11)
            Caption(DemoLabel1LB) = T$
            UpArrow%% = True
            ArrowTop% = 84: ArrowLeft% = 520
            Control(DemoLabel1LB).Width = 9.2 * LEN(T$)
            Control(DemoLabel1LB).Left = ArrowLeft% + 32
            Control(DemoLabel1LB).Top = ArrowTop%
            Control(DemoLabel1LB).Hidden = False
        CASE 155000
            Text(StepTimeMinTB) = "5": Text(StepTimeSecTB) = "0"
            CALL SetStep
        CASE 162500
            Control(DemoLabel1LB).Hidden = True
            EndArrow%% = True
        CASE 175000
            T$ = DemoText$(12)
            Caption(DemoLabel1LB) = T$
            Control(DemoLabel1LB).Width = 9.2 * LEN(T$)
            Control(DemoLabel1LB).Left = (Uscreen% - 9.2 * LEN(T$)) / 2
            Control(DemoLabel1LB).Top = 180
            Control(DemoLabel1LB).Hidden = False
        CASE 190000
            UpArrow%% = True
            ArrowTop% = 100: ArrowLeft% = 1200
            T$ = DemoText$(13)
            Caption(DemoLabel2LB) = T$
            Control(DemoLabel2LB).Width = 9.2 * LEN(T$)
            Control(DemoLabel2LB).Left = ArrowLeft% - 9.2 * LEN(T$)
            Control(DemoLabel2LB).Top = ArrowTop%
            Control(DemoLabel2LB).Hidden = False
        CASE 195000
            ViewingAngle! = -0.25*_PI
            Control(ViewingTrackBar).Value = ViewingAngle! * 180 / _PI
        CASE 197500
            EndArrow%% = True
            Control(DemoLabel2LB).Hidden = True
        CASE 200000
            ViewingAngle! = -0.5*_PI
            Control(ViewingTrackBar).Value = ViewingAngle! * 180 / _PI
            UpArrow%% = True
            ArrowTop% = 100: ArrowLeft% = 1150
            Control(DemoLabel2LB).Left = ArrowLeft% - 9.2 * LEN(T$)
            Control(DemoLabel2LB).Top = ArrowTop%
            Control(DemoLabel2LB).Hidden = False
        CASE 205000
            Control(DemoLabel1LB).Hidden = True
            Control(DemoLabel2LB).Hidden = True
            EndArrow%% = True
        CASE 207500
            T$ = DemoText$(14)
            Caption(DemoLabel1LB) = T$
            Control(DemoLabel1LB).Width = 9.2 * LEN(T$)
            Control(DemoLabel1LB).Left = (Uscreen% - 9.2 * LEN(T$)) / 2
            Control(DemoLabel1LB).Top = 600
            Control(DemoLabel1LB).Hidden = False
        CASE 237500
            Control(DemoLabel1LB).Hidden = True
        CASE 250000
            T$ = DemoText$(15)
            Caption(DemoLabel1LB) = T$
            Control(DemoLabel1LB).Width = 9.2 * LEN(T$)
            Control(DemoLabel1LB).Left = (Uscreen% - 9.2 * LEN(T$)) / 2
            Control(DemoLabel1LB).Top = 140
            Control(DemoLabel1LB).Hidden = False
        CASE 255000
            ViewingAngle! = -.1570787
            Control(ViewingTrackBar).Value = ViewingAngle! * 180 / _PI
            CALL Zoomer((False))
            Zoom! = 5.960449E+08
        CASE 262500
            ByJupiter%% = 5
            CALL ToDisp((Galaxy#(ByJupiter%%, 1)), (Galaxy#(ByJupiter%%, 2)), (Galaxy#(ByJupiter%%, 3)), U%, V%, C2%%)
            T$ = DemoText$(16)
            Caption(DemoLabel1LB) = T$
            Control(DemoLabel1LB).Width = 9.2 * LEN(T$)
            Control(DemoLabel1LB).Left = (U% - 4.6 * LEN(T$))
            Control(DemoLabel1LB).Top = V% + 20
        CASE 265000
            PlanetAnim%% = ByJupiter%%
        CASE 275000
            Control(DemoLabel1LB).Hidden = True
        CASE 280000
            T$ = DemoText$(17)
            Caption(DemoLabel1LB) = T$
            Control(DemoLabel1LB).Width = 9.2 * LEN(T$)
            Control(DemoLabel1LB).Left = (Uscreen% - 9.2 * LEN(T$)) / 2
            Control(DemoLabel1LB).Top = 140
            Control(DemoLabel1LB).Hidden = False
            Text(StepTimeMinTB) = "2": Text(StepTimeSecTB) = "0"
            CALL SetStep
        CASE 285000
            DownArrow%% = True
            ArrowTop% = 730: ArrowLeft% = 210
            T$ = DemoText$(18)
            Caption(DemoLabel2LB) = T$
            Control(DemoLabel2LB).Width = 9.2 * LEN(T$)
            Control(DemoLabel2LB).Left = ArrowLeft% - 4.6 * LEN(T$) + 16
            Control(DemoLabel2LB).Top = ArrowTop% - 32
            Control(DemoLabel2LB).Hidden = False
        CASE 290000
            Trace%% = False
            Caption(TraceBT) = "Trace"
        CASE 297500
            EndArrow%% = True
            Control(DemoLabel1LB).Hidden = True
            Control(DemoLabel2LB).Hidden = True
        CASE 302500
            DownArrow%% = True
            ArrowTop% = 730: ArrowLeft% = 210
            T$ = DemoText$(19)
            Caption(DemoLabel2LB) = T$
            Control(DemoLabel2LB).Width = 9.2 * LEN(T$)
            Control(DemoLabel2LB).Left = ArrowLeft% - 4.6 * LEN(T$) + 16
            Control(DemoLabel2LB).Top = ArrowTop% - 32
            Control(DemoLabel2LB).Hidden = False
        CASE 305000
            Trace%% = True
            Caption(TraceBT) = "Spot"
        CASE 310000
            EndArrow%% = True
            Control(DemoLabel2LB).Hidden = True
            Text(StepTimeMinTB) = "5": Text(StepTimeSecTB) = "0"
            CALL SetStep
        CASE 330000
            UpArrow%% = True
            ArrowTop% = 84: ArrowLeft% = 620
            T$ = DemoText$(20)
            Caption(DemoLabel2LB) = T$
            Control(DemoLabel2LB).Width = 9.2 * LEN(T$)
            Control(DemoLabel2LB).Left = ArrowLeft% + 32
            Control(DemoLabel2LB).Top = ArrowTop%
            Control(DemoLabel2LB).Hidden = False
        CASE 332500
            EFrameClick%% = True
            Caption(EnergyLB) = "Bodies"
            Text(EnergyTB) = MakeText$(NoBodiesLess1% + 1)
        CASE 350000
            EndArrow%% = True
            Control(DemoLabel2LB).Hidden = True
        CASE 360000
            T$ = DemoText$(21)
            Caption(DemoLabel1LB) = T$
            Control(DemoLabel1LB).Width = 9.2 * LEN(T$)
            Control(DemoLabel1LB).Left = (Uscreen% - 9.2 * LEN(T$)) / 2
            Control(DemoLabel1LB).Top = 140
            Control(DemoLabel1LB).Hidden = False
        CASE 366596
            ByJupiter%% = 11
            PlanetAnim%% = ByJupiter%%
        CASE 376596
        'The Earth
        Galaxy#(3, 3) = -36171689178.6047
        Galaxy#(3, 1) = -147845249378.241
        Galaxy#(3, 2) = -4877316.79803054
        Galaxy#(3, 6) = 28470.366606139
        Galaxy#(3, 4) = -7204.9068182243
        Galaxy#(3, 5) = 1.0117834275
        'The Moon
        Galaxy#(10, 3) = -35958075763.303
        Galaxy#(10, 1) = -147502805517.55
        Galaxy#(10, 2) = -12243921.1369571
        Galaxy#(10, 6) = 27655.4229032262
        Galaxy#(10, 4) = -6672.4762717713
        Galaxy#(10, 5) = -86.5562299173
        Text(StepTimeMinTB) = "0": Text(StepTimeSecTB) = "1"
        CALL SetStep
        NoBodiesLess1% = 11
        CASE 377500
            T$ = DemoText$(22)
            Caption(DemoLabel2LB) = T$
            Control(DemoLabel2LB).Width = 9.2 * LEN(T$)
            Control(DemoLabel2LB).Left = (Uscreen% - 9.2 * LEN(T$)) / 2
            Control(DemoLabel2LB).Top = 140
            Control(DemoLabel2LB).Hidden = False
            T$ = DemoText$(23)
            Caption(DemoLabel1LB) = T$
            Control(DemoLabel1LB).Width = 9.2 * LEN(T$)
            Control(DemoLabel1LB).Left = (Uscreen% - 9.2 * LEN(T$)) / 2
            Control(DemoLabel1LB).Top = 180
            Control(DemoLabel1LB).Hidden = False
        CASE 390000
            Text(StepTimeMinTB) = "0": Text(StepTimeSecTB) = "8"
            CALL SetStep
        CASE 397500
            Text(StepTimeMinTB) = "0": Text(StepTimeSecTB) = "30"
        CALL SetStep
            Control(DemoLabel1LB).Hidden = True
            Control(DemoLabel2LB).Hidden = True
        CASE 405000
            Text(StepTimeHrTB) = "0": Text(StepTimeMinTB) = "30": Text(StepTimeSecTB) = "0"
            CALL SetStep
        CASE 480000
            DownArrow%% = True
            ArrowTop% = 730: ArrowLeft% = 270
            T$ = DemoText$(24)
            Caption(DemoLabel2LB) = T$
            Control(DemoLabel2LB).Width = 9.2 * LEN(T$)
            Control(DemoLabel2LB).Left = ArrowLeft% - 4.6 * LEN(T$) + 16
            Control(DemoLabel2LB).Top = ArrowTop% - 32
            Control(DemoLabel2LB).Hidden = False
        CASE 485000
            Wipe%% = True
        CASE 488500
            Control(DemoLabel2LB).Hidden = True
            EndArrow%% = True
        CASE 555000
            ByJupiter%% = 5
            CALL ToDisp((Galaxy#(ByJupiter%%, 1)), (Galaxy#(ByJupiter%%, 2)), (Galaxy#(ByJupiter%%, 3)), U%, V%, C2%%)
            T$ = DemoText$(25)
            Caption(DemoLabel2LB) = T$
            Control(DemoLabel2LB).Width = 9.2 * LEN(T$)
            Control(DemoLabel2LB).Left = (Uscreen% / 2) + 200
            Control(DemoLabel2LB).Top = V% + 30
            Control(DemoLabel2LB).Hidden = False
        CASE 567500
            Control(DemoLabel2LB).Hidden = True
        CASE 575000
            ByJupiter%% = 6
            CALL ToDisp((Galaxy#(ByJupiter%%, 1)), (Galaxy#(ByJupiter%%, 2)), (Galaxy#(ByJupiter%%, 3)), U%, V%, C2%%)
            T$ = DemoText$(26)
            Caption(DemoLabel1LB) = T$
            Control(DemoLabel1LB).Width = 9.2 * LEN(T$)
            Control(DemoLabel1LB).Left = U% - 4.6 * LEN(T$)
            Control(DemoLabel1LB).Top = V% + 20
            Control(DemoLabel1LB).Hidden = False
        CASE 582500
            Control(DemoLabel1LB).Hidden = True
        CASE 612500
            T$ = DemoText$(27)
            Caption(DemoLabel1LB) = T$
            Control(DemoLabel1LB).Width = 9.2 * LEN(T$)
            Control(DemoLabel1LB).Left = (Uscreen% / 2) - 4.6 * LEN(T$)
            Control(DemoLabel1LB).Top = (Vscreen% / 2) - 16
            Control(DemoLabel1LB).Hidden = False
    END SELECT
END SUB
