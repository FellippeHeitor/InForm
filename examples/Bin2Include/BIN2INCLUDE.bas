': This program uses
': InForm - GUI library for QB64 - v1.5
': Fellippe Heitor, 2016-2023 - fellippe@qb64.org - @fellippeheitor
': https://github.com/FellippeHeitor/InForm
'-----------------------------------------------------------

$VERSIONINFO:CompanyName='SpriggsySpriggs'
$VERSIONINFO:FileDescription='Converts a binary file into an INCLUDE-able'
$VERSIONINFO:LegalCopyright='(c) 2019-2020 SpriggsySpriggs'
$VERSIONINFO:ProductName='BIN2INCLUDE'
$VERSIONINFO:InternalName='BIN2INCLUDE'
$VERSIONINFO:OriginalFilename='BIN2INCLUDE.exe'
$VERSIONINFO:Web='https://github.com/a740g/QB64-Museum/tree/main/SpriggsySpriggs/Bin2Include'
$VERSIONINFO:Comments='QB64-PE and InForm-PE port by a740g'
$VERSIONINFO:FILEVERSION#=2,6,0,0
$VERSIONINFO:PRODUCTVERSION#=2,6,0,0

OPTION _EXPLICIT

$EXEICON:'./BIN2INCLUDE.ico'

': Controls' IDs: ------------------------------------------------------------------
DIM SHARED BIN2INCLUDE AS LONG
DIM SHARED SelectedFileTB AS LONG
DIM SHARED OpenBT AS LONG
DIM SHARED SaveBT AS LONG
DIM SHARED CONVERTBT AS LONG
DIM SHARED OutputFileTB AS LONG
DIM SHARED ListBox1 AS LONG
DIM SHARED ClearLogBT AS LONG
DIM SHARED BIN2BASRB AS LONG
DIM SHARED PIC2MEMRB AS LONG
DIM SHARED ResetBT AS LONG

': External modules: ---------------------------------------------------------------
'$INCLUDE:'../../InForm/extensions/MessageBox.bi'
'$INCLUDE:'../../InForm/InForm.bi'
'$INCLUDE:'BIN2INCLUDE.frm'
'$INCLUDE:'../../InForm/xp.uitheme'
'$INCLUDE:'../../InForm/InForm.ui'
'$INCLUDE:'../../InForm/extensions/MessageBox.bas'

': Custom procedures: --------------------------------------------------------------
FUNCTION checkExt%% (OFile$)
    IF UCASE$(RIGHT$(OFile$,  4)) <> ".BMP" AND UCASE$(RIGHT$(OFile$,  4)) <> ".JPG" _
    AND UCASE$(RIGHT$(OFile$, 4)) <> ".PNG" AND UCASE$(RIGHT$(OFile$,  5)) <> ".JPEG" _
    AND UCASE$(RIGHT$(OFile$,  4)) <> ".GIF" THEN
        checkExt = FALSE
    ELSE
        checkExt = TRUE
    END IF
END FUNCTION

FUNCTION ReplaceString$ (a AS STRING, b AS STRING, c AS STRING)
    DIM j AS LONG: j = INSTR(a, b)
    DIM r AS STRING
    IF j > 0 THEN
        r = LEFT$(a, j - 1) + c + ReplaceString(RIGHT$(a, LEN(a) - j + 1 - LEN(b)), b, c)
    ELSE
        r = a
    END IF
    ReplaceString = r
END FUNCTION

FUNCTION StripDirectory$ (s AS STRING)
    DIM t AS STRING: t = MID$(s, _INSTRREV(s, "\") + 1)
    StripDirectory = t
END FUNCTION

FUNCTION E$ (BS AS STRING)
    DIM AS LONG t, b

    FOR t = LEN(BS) TO 1 STEP -1
        b = b * 256 + ASC(MID$(BS, t))
    NEXT

    DIM AS STRING a, g

    FOR t = 1 TO LEN(BS) + 1
        g = CHR$(48 + (b AND 63)): b = b \ 64
        IF g = "@" THEN g = "#"
        a = a + g
    NEXT

    E = a
END FUNCTION

SUB bin2bas (IN$, OUT$)
    OPEN IN$ FOR BINARY AS 1
    IF LOF(1) = 0 THEN
        CLOSE 1
    ELSE
        DIM INDATA$: INDATA$ = (INPUT$(LOF(1), 1))
        INDATA$ = _DEFLATE$(INDATA$)
        OPEN OUT$ FOR OUTPUT AS 2
        DIM Q$: Q$ = CHR$(34) 'quotation mark
        DIM inFunc$: inFunc$ = LEFT$(IN$, LEN(IN$) - 4)
        DIM i AS LONG
        FOR i = 32 TO 64
            IF INSTR(inFunc$, CHR$(i)) THEN
                inFunc$ = ReplaceString(inFunc$, CHR$(i), "")
            END IF
        NEXT
        FOR i = 91 TO 96
            IF INSTR(inFunc$, CHR$(i)) THEN
                IF i <> 92 THEN
                    inFunc$ = ReplaceString(inFunc$, CHR$(i), "")
                END IF
            END IF
        NEXT
        PRINT #2, "SUB __" + StripDirectory(inFunc$)
        PRINT #2, "IF NOT _FILEEXISTS(" + Q$ + StripDirectory(IN$) + Q$ + ") THEN"
        AddItem ListBox1, TIME$ + ": Opening file: " + IN$
        AddItem ListBox1, TIME$ + ": Processing file..."
        PRINT #2, "DIM A$:A$="; Q$;
        AddItem ListBox1, TIME$ + ": Converting lines..."
        DIM BC&: BC& = 1
        DO
            DIM a$: a$ = MID$(INDATA$, BC&, 3)
            BC& = BC& + 3
            DIM LL&: LL& = LL& + 4
            IF LL& = 60 THEN
                LL& = 0
                PRINT #2, E$(a$);
                PRINT #2, Q$
                PRINT #2, "A$=A$+"; Q$;
            ELSE
                PRINT #2, E$(a$);
            END IF
            IF LEN(INDATA$) - BC& < 3 THEN
                a$ = MID$(INDATA$, LEN(INDATA$) - BC&, 1)
                DIM B$: B$ = E$(a$)
                SELECT CASE LEN(B$)
                    CASE 0: a$ = Q$
                    CASE 1: a$ = "%%%" + B$ + Q$
                    CASE 2: a$ = "%%" + B$ + Q$
                    CASE 3: a$ = "%" + B$ + Q$
                END SELECT:
                PRINT #2, a$;
                EXIT DO
            END IF
        LOOP
        PRINT #2, ""
        AddItem ListBox1, TIME$ + ": DONE"
        AddItem ListBox1, TIME$ + ": Writing decoding function to file..."
        PRINT #2, "DIM btemp$,i&,B$,C%,F$,C$,j,t%,B&,X$,BASFILE$"
        PRINT #2, "FOR i&=1TO LEN(A$) STEP 4"
        PRINT #2, "B$=MID$(A$,i&,4)"
        PRINT #2, "IF INSTR(1,B$,"; Q$; "%"; Q$; ") THEN"
        PRINT #2, "FOR C%=1 TO LEN(B$)"
        PRINT #2, "F$=MID$(B$,C%,1)"
        PRINT #2, "IF F$<>"; Q$; "%"; Q$; "THEN C$=C$+F$"
        PRINT #2, "NEXT"
        PRINT #2, "B$=C$"
        PRINT #2, "END IF"
        PRINT #2, "FOR j=1 TO LEN(B$)"
        PRINT #2, "IF MID$(B$,j,1)="; Q$; "#"; Q$; " THEN"
        PRINT #2, "MID$(B$,j)="; Q$; "@"; Q$
        PRINT #2, "END IF"
        PRINT #2, "NEXT"
        PRINT #2, "FOR t%=LEN(B$) TO 1 STEP-1"
        PRINT #2, "B&=B&*64+ASC(MID$(B$,t%))-48"
        PRINT #2, "NEXT"
        PRINT #2, "X$="; Q$; Q$
        PRINT #2, "FOR t%=1 TO LEN(B$)-1"
        PRINT #2, "X$=X$+CHR$(B& AND 255)"
        PRINT #2, "B&=B&\256"
        PRINT #2, "NEXT"
        PRINT #2, "btemp$=btemp$+X$"
        PRINT #2, "NEXT"
        PRINT #2, "BASFILE$=_INFLATE$(btemp$,"; LTRIM$(STR$(LOF(1))); " )"
        PRINT #2, "DIM FF&: FF&=FREEFILE"
        PRINT #2, "OPEN "; Q$; StripDirectory(IN$); Q$; " FOR OUTPUT AS #FF&"
        PRINT #2, "PRINT #FF&, BASFILE$;"
        PRINT #2, "CLOSE #FF&"
        PRINT #2, "END IF"
        PRINT #2, "END SUB"
        CLOSE #1
        CLOSE #2
        AddItem ListBox1, TIME$ + ": DONE"
        AddItem ListBox1, TIME$ + ": File exported to " + OUT$
        ToolTip(ListBox1) = TIME$ + ": File exported to " + OUT$
        Text(SelectedFileTB) = ""
        Text(OutputFileTB) = ""
        Control(CONVERTBT).Disabled = TRUE
        Control(OpenBT).Disabled = TRUE
        Control(BIN2BASRB).Value = FALSE
        Control(PIC2MEMRB).Value = FALSE
    END IF
END SUB

SUB pic2mem (IN$, OUT$)
    AddItem ListBox1, TIME$ + ": Opening file: " + IN$
    AddItem ListBox1, TIME$ + ": Processing file..."

    'Load image file to screen mode
    DIM pic AS LONG: pic = _LOADIMAGE(IN$, 32)
    DIM m AS _MEM: m = _MEMIMAGE(pic)

    'Grab screen data
    DIM INDATA$: INDATA$ = SPACE$(m.SIZE)
    _MEMGET m, m.OFFSET, INDATA$
    'Compress it
    INDATA$ = _DEFLATE$(INDATA$)
    'get screen specs
    DIM AS LONG wid, hih
    wid = _WIDTH(pic): hih = _HEIGHT(pic)

    OPEN OUT$ FOR OUTPUT AS 2

    DIM Q$: Q$ = CHR$(34) 'quotation mark
    DIM inFunc$: inFunc$ = LEFT$(IN$, LEN(IN$) - 4)
    DIM AS LONG i
    FOR i = 32 TO 64
        IF INSTR(inFunc$, CHR$(i)) THEN
            inFunc$ = ReplaceString(inFunc$, CHR$(i), "")
        END IF
    NEXT
    FOR i = 91 TO 96
        IF INSTR(inFunc$, CHR$(i)) THEN
            IF i <> 92 THEN
                inFunc$ = ReplaceString(inFunc$, CHR$(i), "")
            END IF
        END IF
    NEXT
    PRINT #2, "FUNCTION __" + StripDirectory(inFunc$) + "&"
    PRINT #2, "DIM A$,btemp$,i&,B$,C%,F$,C$,j,t%,B&,X$"
    PRINT #2, "DIM v&:v&=_NEWIMAGE("; wid; ","; hih; ",32)"
    PRINT #2, "DIM m AS _MEM:m=_MEMIMAGE(v&)"
    PRINT #2, "A$="; Q$;

    DIM BC&: BC& = 1

    DO
        DIM a$: a$ = MID$(INDATA$, BC&, 3)
        BC& = BC& + 3
        DIM LL&: LL& = LL& + 4
        IF LL& = 60 THEN
            LL& = 0
            PRINT #2, E$(a$);: PRINT #2, Q$
            PRINT #2, "A$=A$+"; Q$;
        ELSE
            PRINT #2, E$(a$);
        END IF
        IF LEN(INDATA$) - BC& < 3 THEN
            a$ = MID$(INDATA$, LEN(INDATA$) - BC&, 1)
            DIM B$: B$ = E$(a$)
            SELECT CASE LEN(B$)
                CASE 0: a$ = Q$
                CASE 1: a$ = "%%%" + B$ + Q$
                CASE 2: a$ = "%%" + B$ + Q$
                CASE 3: a$ = "%" + B$ + Q$
            END SELECT: PRINT #2, a$;: EXIT DO
        END IF
    LOOP: PRINT #2, ""

    PRINT #2, "FOR i&=1TO LEN(A$) STEP 4"
    PRINT #2, "B$=MID$(A$,i&,4)"
    PRINT #2, "IF INSTR(1,B$,"; Q$; "%"; Q$; ") THEN"
    PRINT #2, "FOR C%=1 TO LEN(B$)"
    PRINT #2, "F$=MID$(B$,C%,1)"
    PRINT #2, "IF F$<>"; Q$; "%"; Q$; "THEN C$=C$+F$"
    PRINT #2, "NEXT"
    PRINT #2, "B$=C$"
    PRINT #2, "END IF"
    PRINT #2, "FOR j=1 TO LEN(B$)"
    PRINT #2, "IF MID$(B$,j,1)="; Q$; "#"; Q$; " THEN"
    PRINT #2, "MID$(B$,j)="; Q$; "@"; Q$
    PRINT #2, "END IF"
    PRINT #2, "NEXT"
    PRINT #2, "FOR t%=LEN(B$) TO 1 STEP-1"
    PRINT #2, "B&=B&*64+ASC(MID$(B$,t%))-48"
    PRINT #2, "NEXT"
    PRINT #2, "X$="; Q$; Q$
    PRINT #2, "FOR t%=1 TO LEN(B$)-1"
    PRINT #2, "X$=X$+CHR$(B& AND 255)"
    PRINT #2, "B&=B&\256"
    PRINT #2, "NEXT"
    PRINT #2, "btemp$=btemp$+X$"
    PRINT #2, "NEXT"
    PRINT #2, "btemp$=_INFLATE$(btemp$,m.SIZE)"
    PRINT #2, "_MEMPUT m,m.OFFSET,btemp$"
    PRINT #2, "_MEMFREE m"
    PRINT #2, "__" + StripDirectory(inFunc$) + "&=v&"
    PRINT #2, "END FUNCTION"

    CLOSE #2
    _MEMFREE m
    _FREEIMAGE pic

    AddItem ListBox1, TIME$ + ": Image converted to MEM successfully"
    AddItem ListBox1, TIME$ + ": File exported to " + OUT$
    ToolTip(ListBox1) = TIME$ + ": File exported to " + OUT$
    Text(SelectedFileTB) = ""
    Text(OutputFileTB) = ""
    Control(CONVERTBT).Disabled = TRUE
    Control(OpenBT).Disabled = TRUE
    Control(BIN2BASRB).Value = FALSE
    Control(PIC2MEMRB).Value = FALSE
END SUB

FUNCTION __opensmall&
    DIM v&
    DIM A$
    DIM btemp$
    DIM i&
    DIM B$
    DIM C%
    DIM F$
    DIM C$
    DIM j
    DIM t%
    DIM B&
    DIM X$
    v& = _NEWIMAGE(16, 16, 32)
    DIM m AS _MEM: m = _MEMIMAGE(v&)
    A$ = "haiHP1:6<GPhK34O7Xh[24W99XooS3\jDXng<#lD#3g>#\\4Yna5n^0a\#1j"
    A$ = A$ + "74FIlXoo0e>^1N`bS5moGPhf0R5Q82c`Vo?66P4V_MPhOCTn3HZ[1PHi0RO>"
    A$ = A$ + "96><APhU14c7#l59Am^EPHV1RiV18aeTRN_4#<_#moMCRjmY<PJh?XdEKQ8`"
    A$ = A$ + "K28^IPHa`GT1m600eW8R%%%0"
    FOR i& = 1 TO LEN(A$) STEP 4
        B$ = MID$(A$, i&, 4)
        IF INSTR(1, B$, "%") THEN
            FOR C% = 1 TO LEN(B$)
                F$ = MID$(B$, C%, 1)
                IF F$ <> "%" THEN C$ = C$ + F$
            NEXT
            B$ = C$
        END IF
        FOR j = 1 TO LEN(B$)
            IF MID$(B$, j, 1) = "#" THEN
                MID$(B$, j) = "@"
            END IF
        NEXT
        FOR t% = LEN(B$) TO 1 STEP -1
            B& = B& * 64 + ASC(MID$(B$, t%)) - 48
        NEXT
        X$ = ""
        FOR t% = 1 TO LEN(B$) - 1
            X$ = X$ + CHR$(B& AND 255)
            B& = B& \ 256
        NEXT
        btemp$ = btemp$ + X$
    NEXT
    btemp$ = _INFLATE$(btemp$, m.SIZE)
    _MEMPUT m, m.OFFSET, btemp$: _MEMFREE m
    __opensmall& = v&
END FUNCTION

FUNCTION __convert&
    DIM v&
    DIM A$
    DIM btemp$
    DIM i&
    DIM B$
    DIM C%
    DIM F$
    DIM C$
    DIM j
    DIM t%
    DIM B&
    DIM X$
    v& = _NEWIMAGE(16, 16, 32)
    DIM m AS _MEM: m = _MEMIMAGE(v&)
    A$ = "haIM#f6BC6557olUj3A#R44H98hDS4c\b:B]V:Jj23JiCBjl56FKfHVV6[Dc"
    A$ = A$ + "5R_lm\_F8dl;1Q8EFOaNA4[Xd4eLY=L[mBZK=leIcmfYcARAbcj2ohN_?Wko"
    A$ = A$ + "O?gkA_NQRd[G#E4#Bc=;7dYk2`2]E5h\MUBMgeEAJN[molNE0fKE1#WAM`PN"
    A$ = A$ + "`=gLILS=F4GK=Kh#3e?bOW81>?OF2T`2A0RAMX_lThlDm[kcgjX7?^aEFI1d"
    A$ = A$ + "U[i`16XGT7L=R4_o]_8H]UBUJBW0BcPikDBjdjn8P6J#V6ongPng;7fQ13M7"
    A$ = A$ + "V2;<QF8P^ZA;<CSbQ>DY1NUVc1CMSRTA0eFKNJ34`;jekJKc1O?hg2G?C5e3"
    A$ = A$ + "9;X?<2293?_VlH7PJeIGG`Pn#Onl8ba;7n3H^:^fCX<ZnGXlB:^h31bUO##Y"
    A$ = A$ + "b<^IX#1#onm:bQQGlFLL;^a?>[3L4Sf`QoZE\Wn72Y\Z8T`i;[\CdHX#1a01"
    A$ = A$ + "l;baSO6Ug\CLhY<Q_KRIaGo5Sh3jMP]j]DFe4988L4Mln8iXWnO3>YEghkoV"
    A$ = A$ + "U`>J[K3Q9jSOi>b?oh_;ng1kPO;LoPkY?\_1AS>F6oT9kKc1O?hgBlbZ_>9B"
    A$ = A$ + "f]VDCM?M69B<[26lk;^:>Vii5iH4SfahbGK300kR8V8A<IEIkcm;?h4fL9b1"
    A$ = A$ + "gCS=gJd=Fa758TmX\C2dVb1P9;9MXf37;\gD??4cI[^9[;i5WNnU4ihcVF0i"
    A$ = A$ + "jCOUC24m=CYW:MC:>=_6YIYAWB1`nbXbF]_R?L6W[:bahVMQLMcUW1HYR<Cj"
    A$ = A$ + "7EVeX418\#Pdm?ZXBkBMjLmP8k`jBo6ig2g?hNZA7[RLM>?MN`FEW1LXD:h\"
    A$ = A$ + "jL`W:;=YDnhfan?FCk<nLjno1EoFo1`f%%L2"
    FOR i& = 1 TO LEN(A$) STEP 4
        B$ = MID$(A$, i&, 4)
        IF INSTR(1, B$, "%") THEN
            FOR C% = 1 TO LEN(B$)
                F$ = MID$(B$, C%, 1)
                IF F$ <> "%" THEN C$ = C$ + F$
            NEXT
            B$ = C$
        END IF
        FOR j = 1 TO LEN(B$)
            IF MID$(B$, j, 1) = "#" THEN
                MID$(B$, j) = "@"
            END IF
        NEXT
        FOR t% = LEN(B$) TO 1 STEP -1
            B& = B& * 64 + ASC(MID$(B$, t%)) - 48
        NEXT
        X$ = ""
        FOR t% = 1 TO LEN(B$) - 1
            X$ = X$ + CHR$(B& AND 255)
            B& = B& \ 256
        NEXT
        btemp$ = btemp$ + X$
    NEXT
    btemp$ = _INFLATE$(btemp$, m.SIZE)
    _MEMPUT m, m.OFFSET, btemp$: _MEMFREE m
    __convert& = v&
END FUNCTION

FUNCTION __reset&
    DIM v&
    DIM A$
    DIM btemp$
    DIM i&
    DIM B$
    DIM C%
    DIM F$
    DIM C$
    DIM j
    DIM t%
    DIM B&
    DIM X$
    v& = _NEWIMAGE(16, 16, 32)
    DIM m AS _MEM: m = _MEMIMAGE(v&)
    A$ = "haiHP1J3`03<#1S<bXP<a4C:cHS=>;Pd6B<jc#3=D:PZO10a_08N30aM3D_["
    A$ = A$ + "58mS0Rg;#\LhB_VK^ib0Dnk3dNKAK]eV7dTVAPVCQP<GPbK;jj=d#3UIPbM9"
    A$ = A$ + "PbE0bRS^J1jnL6Xj^WeFK=_PhkP3>`2#ni3DM12TNoXK^05ki0MGRSVI>IPR"
    A$ = A$ + "g3<g5#fG6Tj0jnf3#jSPVnOQYVJZ4Xi6<1Xh?59eh6#lo1R_6#\bX[O#f5#k"
    A$ = A$ + "\NPH=19V:ZX2k05kGjYWNL3CM0]kT0:6oXkn19>#L3Pd?#ie0GjWD0Xkn9E0"
    A$ = A$ + "JQOTZM3>n3;Y?84P9Pj[8LUn1G0PZ=EPjIM4CjG\10Znh1Rc4HJ038Ag;A10"
    A$ = A$ + "0lQl%%h1"
    FOR i& = 1 TO LEN(A$) STEP 4
        B$ = MID$(A$, i&, 4)
        IF INSTR(1, B$, "%") THEN
            FOR C% = 1 TO LEN(B$)
                F$ = MID$(B$, C%, 1)
                IF F$ <> "%" THEN C$ = C$ + F$
            NEXT
            B$ = C$
        END IF
        FOR j = 1 TO LEN(B$)
            IF MID$(B$, j, 1) = "#" THEN
                MID$(B$, j) = "@"
            END IF
        NEXT
        FOR t% = LEN(B$) TO 1 STEP -1
            B& = B& * 64 + ASC(MID$(B$, t%)) - 48
        NEXT
        X$ = ""
        FOR t% = 1 TO LEN(B$) - 1
            X$ = X$ + CHR$(B& AND 255)
            B& = B& \ 256
        NEXT
        btemp$ = btemp$ + X$
    NEXT
    btemp$ = _INFLATE$(btemp$, m.SIZE)
    _MEMPUT m, m.OFFSET, btemp$: _MEMFREE m
    __reset& = v&
END FUNCTION

FUNCTION __deletesmall&
    DIM v&
    DIM A$
    DIM btemp$
    DIM i&
    DIM B$
    DIM C%
    DIM F$
    DIM C$
    DIM j
    DIM t%
    DIM B&
    DIM X$
    v& = _NEWIMAGE(16, 16, 32)
    DIM m AS _MEM: m = _MEMIMAGE(v&)
    A$ = "haiHP1D16JXQm04o7S=fhoS<6ZHMa010PDWEFI5_X;>8a0:g_aVN<b8Sj3Kf"
    A$ = A$ + "9^`PD;#md9Q\CL1PjFn5BjoG0=g68Al?ABon2e]A\jmo0MonP\K2TH#Y;28^"
    A$ = A$ + "#THG4d`XRQa6VJaQn1K74PmXjWfYo=1<^J34P=fdo[0:_iX;>j0C<a4[0VNk"
    A$ = A$ + "5HAon34oBR8_c;0UN5Vn04BU%%h1"
    FOR i& = 1 TO LEN(A$) STEP 4
        B$ = MID$(A$, i&, 4)
        IF INSTR(1, B$, "%") THEN
            FOR C% = 1 TO LEN(B$)
                F$ = MID$(B$, C%, 1)
                IF F$ <> "%" THEN C$ = C$ + F$
            NEXT
            B$ = C$
        END IF
        FOR j = 1 TO LEN(B$)
            IF MID$(B$, j, 1) = "#" THEN
                MID$(B$, j) = "@"
            END IF
        NEXT
        FOR t% = LEN(B$) TO 1 STEP -1
            B& = B& * 64 + ASC(MID$(B$, t%)) - 48
        NEXT
        X$ = ""
        FOR t% = 1 TO LEN(B$) - 1
            X$ = X$ + CHR$(B& AND 255)
            B& = B& \ 256
        NEXT
        btemp$ = btemp$ + X$
    NEXT
    btemp$ = _INFLATE$(btemp$, m.SIZE)
    _MEMPUT m, m.OFFSET, btemp$: _MEMFREE m
    __deletesmall& = v&
END FUNCTION

': Event procedures: ---------------------------------------------------------------
SUB __UI_BeforeInit
END SUB

SUB __UI_OnLoad
    Control(OpenBT).HelperCanvas = __opensmall&
    Control(CONVERTBT).HelperCanvas = __convert&
    Control(ResetBT).HelperCanvas = __reset&
    Control(ClearLogBT).HelperCanvas = __deletesmall&
    Control(OpenBT).Disabled = TRUE
    SetFrameRate 60
    _ACCEPTFILEDROP
    AddItem ListBox1, "Open a file above or drag and drop."
    AddItem ListBox1, "Select BIN2BAS to convert a binary file to BM or select PIC2MEM to convert an image to MEM."
    AddItem ListBox1, "To compile a file that is creating memory errors,"
    AddItem ListBox1, "consult the readme on https://github.com/SpriggsySpriggs/BIN2INCLUDE"
END SUB

SUB __UI_BeforeUpdateDisplay
    IF _TOTALDROPPEDFILES THEN
        DIM drop$: drop$ = _DROPPEDFILE
        IF _FILEEXISTS(drop$) THEN
            IF NOT checkExt(drop$) AND Control(PIC2MEMRB).Value = FALSE THEN
                Control(BIN2BASRB).Value = TRUE
                Control(PIC2MEMRB).Disabled = TRUE
                Text(SelectedFileTB) = drop$
                Text(OutputFileTB) = drop$ + ".BM"
                Control(CONVERTBT).Disabled = FALSE
            ELSEIF checkExt(drop$) AND Control(PIC2MEMRB).Value = TRUE THEN
                Control(BIN2BASRB).Disabled = TRUE
                Text(SelectedFileTB) = drop$
                Text(OutputFileTB) = drop$ + ".MEM"
                Control(CONVERTBT).Disabled = FALSE
            ELSEIF checkExt(drop$) = 0 AND Control(PIC2MEMRB).Value = TRUE THEN
                MessageBox "Unsupported file type for PIC2MEM", Caption(BIN2INCLUDE), MsgBox_Critical
                Control(BIN2BASRB).Disabled = FALSE
            END IF
        END IF
    END IF
END SUB

SUB __UI_BeforeUnload
END SUB

SUB __UI_Click (id AS LONG)
    SELECT CASE id
        CASE BIN2INCLUDE
        CASE SelectedFileTB
        CASE OpenBT
            IF Control(BIN2BASRB).Value = TRUE THEN
                _DELAY 0.2 ' delay a bit to allow InFrom to draw and refresh all comtrols before the modal dialog box takes over
                DIM oFile$: oFile$ = _OPENFILEDIALOG$(Caption(BIN2INCLUDE) + ": Open")
                Control(PIC2MEMRB).Disabled = TRUE
            ELSEIF Control(PIC2MEMRB).Value = TRUE THEN
                _DELAY 0.2 ' delay a bit to allow InFrom to draw and refresh all comtrols before the modal dialog box takes over
                oFile$ = _OPENFILEDIALOG$(Caption(BIN2INCLUDE) + ": Open", , "*.BMP|*.bmp|*.JPG|*.jpg|*.JPEG|*.jpeg|*.PNG|*.png|*.GIF|*.gif", "Supported image files")
                Control(BIN2BASRB).Disabled = TRUE
            END IF
            IF oFile$ <> "" THEN
                IF checkExt(oFile$) = 0 AND Control(PIC2MEMRB).Value = TRUE THEN
                    MessageBox "Unsupported file type for PIC2MEM", Caption(BIN2INCLUDE), MsgBox_Critical
                    Control(BIN2BASRB).Disabled = FALSE
                ELSEIF checkExt(oFile$) AND Control(PIC2MEMRB).Value = TRUE THEN
                    Control(CONVERTBT).Disabled = FALSE
                    Text(SelectedFileTB) = oFile$
                    Text(OutputFileTB) = oFile$ + ".MEM"
                ELSE
                    Control(CONVERTBT).Disabled = FALSE
                    Text(SelectedFileTB) = oFile$
                    Text(OutputFileTB) = oFile$ + ".BM"
                END IF
            ELSE
                Text(SelectedFileTB) = ""
                Text(OutputFileTB) = ""
                Control(BIN2BASRB).Disabled = FALSE
                Control(PIC2MEMRB).Disabled = FALSE
                Control(CONVERTBT).Disabled = TRUE
            END IF
        CASE CONVERTBT
            IF Control(BIN2BASRB).Value = TRUE THEN
                Caption(BIN2INCLUDE) = Caption(BIN2INCLUDE) + " - WORKING..."
                bin2bas Text(SelectedFileTB), Text(OutputFileTB)
                Control(PIC2MEMRB).Disabled = FALSE
                Caption(BIN2INCLUDE) = "BIN2INCLUDE"
            ELSEIF Control(PIC2MEMRB).Value = TRUE THEN
                Caption(BIN2INCLUDE) = Caption(BIN2INCLUDE) + " - WORKING..."
                pic2mem Text(SelectedFileTB), Text(OutputFileTB)
                Control(BIN2BASRB).Disabled = FALSE
                Caption(BIN2INCLUDE) = "BIN2INCLUDE"
            ELSE
                MessageBox "Select an option BIN2BAS or PIC2MEM first.", Caption(BIN2INCLUDE), MsgBox_Exclamation
            END IF
        CASE OutputFileTB
        CASE ListBox1
        CASE ClearLogBT
            ResetList ListBox1
        CASE ResetBT
            ResetScreen
    END SELECT
END SUB

SUB ResetScreen
    Text(SelectedFileTB) = ""
    Text(OutputFileTB) = ""
    Control(BIN2BASRB).Disabled = FALSE
    Control(PIC2MEMRB).Disabled = FALSE
    Control(CONVERTBT).Disabled = TRUE
    ToolTip(ListBox1) = ""
END SUB

SUB __UI_MouseEnter (id AS LONG)
    SELECT CASE id
        CASE BIN2INCLUDE
        CASE SelectedFileTB
        CASE OpenBT
        CASE CONVERTBT
        CASE SaveBT
        CASE OutputFileTB
        CASE ListBox1
    END SELECT
END SUB

SUB __UI_MouseLeave (id AS LONG)
    SELECT CASE id
        CASE BIN2INCLUDE
        CASE SelectedFileTB
        CASE OpenBT
        CASE CONVERTBT
        CASE SaveBT
        CASE OutputFileTB
        CASE ListBox1
    END SELECT
END SUB

SUB __UI_FocusIn (id AS LONG)
    SELECT CASE id
        CASE SelectedFileTB
        CASE OpenBT
        CASE CONVERTBT
        CASE SaveBT
        CASE OutputFileTB
        CASE ListBox1
    END SELECT
END SUB

SUB __UI_FocusOut (id AS LONG)
    SELECT CASE id
        CASE SelectedFileTB
        CASE OpenBT
        CASE CONVERTBT
        CASE SaveBT
        CASE OutputFileTB
        CASE ListBox1
    END SELECT
END SUB

SUB __UI_MouseDown (id AS LONG)
    SELECT CASE id
        CASE BIN2INCLUDE
        CASE SelectedFileTB
        CASE OpenBT
        CASE CONVERTBT
        CASE SaveBT
        CASE OutputFileTB
        CASE ListBox1
    END SELECT
END SUB

SUB __UI_MouseUp (id AS LONG)
    SELECT CASE id
        CASE BIN2INCLUDE
        CASE SelectedFileTB
        CASE OpenBT
        CASE CONVERTBT
        CASE SaveBT
        CASE OutputFileTB
        CASE ListBox1
    END SELECT
END SUB

SUB __UI_KeyPress (id AS LONG)
    SELECT CASE id
        CASE SelectedFileTB
        CASE OpenBT
        CASE CONVERTBT
        CASE OutputFileTB
        CASE ListBox1
    END SELECT
END SUB

SUB __UI_TextChanged (id AS LONG)
    SELECT CASE id
        CASE SelectedFileTB
        CASE OutputFileTB
    END SELECT
END SUB

SUB __UI_ValueChanged (id AS LONG)
    SELECT CASE id
        CASE ListBox1
        CASE BIN2BASRB
            Control(OpenBT).Disabled = FALSE
            _TITLE "BIN2INCLUDE - BIN2BAS"
        CASE PIC2MEMRB
            Control(OpenBT).Disabled = FALSE
            _TITLE "BIN2INCLUDE - PIC2MEM"
    END SELECT
END SUB

SUB __UI_FormResized
END SUB
