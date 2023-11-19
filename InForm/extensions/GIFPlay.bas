'#######################################################################################
'# Animated GIF decoder v1.0                                                           #
'# By Zom-B                                                                            #
'#                                                                                     #
'# https://qb64phoenix.com/qb64wiki/index.php/GIF_Images                               #
'#######################################################################################
' Adapted for use with InForm's PictureBox controls by @FellippeHeitor
' Refactored by a740g to use include guards and conditional compiles

$IF GIFPLAY_BAS = UNDEFINED THEN
    $LET GIFPLAY_BAS = TRUE

    '$INCLUDE:'GIFPlay.bi'

    SUB UpdateGif (ID AS LONG)
        SHARED GIFData() AS GIFDATA

        STATIC GifOverlay AS LONG

        DIM i AS LONG, newFrame AS LONG

        i = GetGifIndex(ID)

        IF i = 0 THEN EXIT SUB

        IF GifOverlay = 0 THEN
            GifOverlay = LoadOverlayImage&
        END IF

        IF GIFData(i).IsPlaying OR GIFData(i).LastFrameServed = 0 THEN
            IF GIFData(i).LastFrameUpdate > 0 AND TIMER - GIFData(i).LastFrameUpdate < GIFData(i).LastFrameDelay THEN
                'Wait for the GIF's frame delay
            ELSE
                GIFData(i).Frame = GIFData(i).Frame + 1
                GIFData(i).LastFrameServed = GIFData(i).Frame
                GIFData(i).LastFrameUpdate = TIMER
            END IF
        END IF

        $IF INFORM_BI = DEFINED THEN
                BeginDraw ID
        $END IF

        newFrame = GetGifFrame&(i)
        IF newFrame THEN _PUTIMAGE , newFrame
        IF GIFData(i).IsPlaying = FALSE AND GIFData(i).HideOverlay = FALSE AND GIFData(i).totalFrames > 1 THEN
            _PUTIMAGE (_WIDTH / 2 - _WIDTH(GifOverlay) / 2, _HEIGHT / 2 - _HEIGHT(GifOverlay) / 2), GifOverlay
        END IF

        $IF INFORM_BI = DEFINED THEN
                EndDraw ID
        $END IF
    END SUB


    FUNCTION GifIsPlaying%% (ID AS LONG)
        SHARED GIFData() AS GIFDATA

        DIM i AS LONG: i = GetGifIndex(ID)

        GifIsPlaying = GIFData(i).IsPlaying
    END FUNCTION


    FUNCTION GifWidth% (ID AS LONG)
        SHARED GIFData() AS GIFDATA

        DIM i AS LONG: i = GetGifIndex(ID)

        GifWidth = GIFData(i).width
    END FUNCTION


    FUNCTION GifHeight% (ID AS LONG)
        SHARED GIFData() AS GIFDATA

        DIM i AS LONG: i = GetGifIndex(ID)

        GifHeight = GIFData(i).height
    END FUNCTION


    FUNCTION TotalFrames& (ID AS LONG)
        SHARED GIFData() AS GIFDATA

        DIM i AS LONG: i = GetGifIndex(ID)
        TotalFrames = GIFData(i).totalFrames
    END FUNCTION


    SUB HideGifOverlay (ID AS LONG)
        SHARED GIFData() AS GIFDATA

        DIM i AS LONG: i = GetGifIndex(ID)

        GIFData(i).HideOverlay = TRUE
    END SUB


    SUB PlayGif (ID AS LONG)
        SHARED GIFData() AS GIFDATA

        DIM i AS LONG: i = GetGifIndex(ID)

        GIFData(i).IsPlaying = TRUE
    END SUB


    SUB PauseGif (ID AS LONG)
        SHARED GIFData() AS GIFDATA

        DIM i AS LONG: i = GetGifIndex(ID)

        GIFData(i).IsPlaying = FALSE
    END SUB


    SUB StopGif (ID AS LONG)
        SHARED GIFData() AS GIFDATA

        DIM i AS LONG: i = GetGifIndex(ID)

        GIFData(i).IsPlaying = FALSE
        GIFData(i).Frame = 1
    END SUB


    FUNCTION OpenGif%% (ID AS LONG, filename$)
        SHARED GIFData() AS GIFDATA
        SHARED GIFFrameData() AS FRAMEDATA
        SHARED TotalGIFLoaded AS LONG, TotalGIFFrames AS LONG

        DIM i AS LONG, Index AS LONG
        DIM byte~%%, palette$, delay~%

        $IF INFORM_BI = DEFINED THEN
                IF Control(ID).Type <> __UI_Type_PictureBox THEN ERROR 5: EXIT FUNCTION
        $END IF

        Index = GetGifIndex&(ID)

        IF Index = 0 THEN
            TotalGIFLoaded = TotalGIFLoaded + 1
            Index = TotalGIFLoaded
            REDIM _PRESERVE GIFData(1 TO TotalGIFLoaded) AS GIFDATA
        ELSE
            CloseGif ID
        END IF

        GIFData(Index).ID = ID
        GIFData(Index).file = FREEFILE
        IF NOT _FILEEXISTS(filename$) THEN EXIT FUNCTION
        OPEN filename$ FOR BINARY AS GIFData(Index).file

        GET GIFData(Index).file, , GIFData(Index).sigver
        GET GIFData(Index).file, , GIFData(Index).width
        GET GIFData(Index).file, , GIFData(Index).height
        GET GIFData(Index).file, , byte~%%
        GIFData(Index).bpp = (byte~%% AND 7) + 1
        GIFData(Index).sortFlag = (byte~%% AND 8) > 0
        GIFData(Index).colorRes = (byte~%% \ 16 AND 7) + 1
        GIFData(Index).colorTableFlag = (byte~%% AND 128) > 0
        GIFData(Index).numColors = 2 ^ GIFData(Index).bpp
        GET GIFData(Index).file, , GIFData(Index).bgColor
        GET GIFData(Index).file, , byte~%%
        IF byte~%% = 0 THEN GIFData(Index).aspect = 0 ELSE GIFData(Index).aspect = (byte~%% + 15) / 64

        IF GIFData(Index).sigver <> "GIF87a" AND GIFData(Index).sigver <> "GIF89a" THEN
            'Invalid version
            GOTO LoadError
        END IF

        IF NOT GIFData(Index).colorTableFlag THEN
            'No Color Table
            GOTO LoadError
        END IF

        palette$ = SPACE$(3 * GIFData(Index).numColors)
        GET GIFData(Index).file, , palette$
        GIFData(Index).palette = palette$
        DO
            GET GIFData(Index).file, , byte~%%
            SELECT CASE byte~%%
                CASE &H2C ' Image Descriptor
                    TotalGIFFrames = TotalGIFFrames + 1
                    GIFData(Index).totalFrames = GIFData(Index).totalFrames + 1

                    IF GIFData(Index).firstFrame = 0 THEN
                        GIFData(Index).firstFrame = TotalGIFFrames
                    END IF

                    IF TotalGIFFrames > UBOUND(GIFFrameData) THEN
                        REDIM _PRESERVE GIFFrameData(0 TO TotalGIFFrames * 2) AS FRAMEDATA
                    END IF

                    GIFFrameData(TotalGIFFrames).ID = ID
                    GIFFrameData(TotalGIFFrames).thisFrame = GIFData(Index).totalFrames

                    GET GIFData(Index).file, , GIFFrameData(TotalGIFFrames).left
                    GET GIFData(Index).file, , GIFFrameData(TotalGIFFrames).top
                    GET GIFData(Index).file, , GIFFrameData(TotalGIFFrames).width
                    GET GIFData(Index).file, , GIFFrameData(TotalGIFFrames).height
                    GET GIFData(Index).file, , byte~%%
                    GIFFrameData(TotalGIFFrames).localColorTableFlag = (byte~%% AND 128) > 0
                    GIFFrameData(TotalGIFFrames).interlacedFlag = (byte~%% AND 64) > 0
                    GIFFrameData(TotalGIFFrames).sortFlag = (byte~%% AND 32) > 0
                    GIFFrameData(TotalGIFFrames).palBPP = (byte~%% AND 7) + 1
                    GIFFrameData(TotalGIFFrames).addr = LOC(GIFData(Index).file) + 1

                    IF GIFFrameData(TotalGIFFrames).localColorTableFlag THEN
                        SEEK GIFData(Index).file, LOC(GIFData(Index).file) + 3 * 2 ^ GIFFrameData(TotalGIFFrames).palBPP + 1
                    END IF
                    GET GIFData(Index).file, , GIFFrameData(TotalGIFFrames).minimumCodeSize
                    IF GIFFrameData(TotalGIFFrames).disposalMethod > 2 THEN
                        'Unsupported disposalMethod
                        GOTO LoadError
                    END IF
                    SkipGIFBlocks GIFData(Index).file
                CASE &H3B ' Trailer
                    EXIT DO
                CASE &H21 ' Extension Introducer
                    GET GIFData(Index).file, , byte~%% ' Extension Label
                    SELECT CASE byte~%%
                        CASE &HFF, &HFE ' Application Extension, Comment Extension
                            SkipGIFBlocks GIFData(Index).file
                        CASE &HF9
                            IF TotalGIFFrames > UBOUND(GIFFrameData) THEN
                                REDIM _PRESERVE GIFFrameData(0 TO TotalGIFFrames * 2) AS FRAMEDATA
                            END IF
                            GIFFrameData(TotalGIFFrames).ID = ID

                            GET GIFData(Index).file, , byte~%% ' Block Size (always 4)
                            GET GIFData(Index).file, , byte~%%
                            GIFFrameData(TotalGIFFrames).transparentFlag = (byte~%% AND 1) > 0
                            GIFFrameData(TotalGIFFrames).userInput = (byte~%% AND 2) > 0
                            GIFFrameData(TotalGIFFrames).disposalMethod = byte~%% \ 4 AND 7
                            GET GIFData(Index).file, , delay~%
                            IF delay~% = 0 THEN GIFFrameData(TotalGIFFrames).delay = 0.1 ELSE GIFFrameData(TotalGIFFrames).delay = delay~% / 100
                            GET GIFData(Index).file, , GIFFrameData(TotalGIFFrames).transColor
                            SkipGIFBlocks GIFData(Index).file
                        CASE ELSE
                            'Unsupported extension Label
                            GOTO LoadError
                    END SELECT
                CASE ELSE
                    'Unsupported chunk
                    GOTO LoadError
            END SELECT
        LOOP

        REDIM _PRESERVE GIFFrameData(0 TO TotalGIFFrames) AS FRAMEDATA

        GIFData(Index).IsPlaying = FALSE
        OpenGif = TRUE
        EXIT FUNCTION

        LoadError:
        GIFData(Index).ID = 0
        CLOSE GIFData(Index).file
        FOR i = 1 TO TotalGIFFrames
            IF GIFFrameData(i).ID = ID THEN
                GIFFrameData(i).ID = 0
            END IF
        NEXT
    END FUNCTION


    FUNCTION GetGifIndex& (ID AS LONG)
        SHARED GIFData() AS GIFDATA
        SHARED TotalGIFLoaded AS LONG

        DIM i AS LONG: FOR i = 1 TO TotalGIFLoaded
            IF GIFData(i).ID = ID THEN
                GetGifIndex = i
                EXIT FOR
            END IF
        NEXT i
    END FUNCTION


    SUB CloseGif (ID AS LONG)
        SHARED GIFData() AS GIFDATA
        SHARED GIFFrameData() AS FRAMEDATA

        DIM i AS LONG, Index AS LONG

        Index = GetGifIndex(ID)

        IF Index = 0 THEN EXIT SUB

        FOR i = 0 TO UBOUND(GIFFrameData)
            IF GIFFrameData(i).ID = ID THEN
                GIFFrameData(i).ID = 0
                IF GIFFrameData(i).addr < -1 THEN
                    _FREEIMAGE GIFFrameData(i).addr
                END IF
            END IF
        NEXT

        CLOSE GIFData(Index).file
        GIFData(Index).ID = 0
        GIFData(Index).firstFrame = 0
    END SUB


    SUB SkipGIFBlocks (file AS INTEGER)
        DIM byte~%%
        DO
            GET file, , byte~%% ' Block Size
            SEEK file, LOC(file) + byte~%% + 1
        LOOP WHILE byte~%%
    END SUB


    FUNCTION GetGifFrame& (Index AS LONG)
        SHARED GIFData() AS GIFDATA
        SHARED GIFFrameData() AS FRAMEDATA

        DIM i AS LONG
        DIM frame AS LONG, previousFrame AS LONG
        DIM w AS INTEGER, h AS INTEGER
        DIM img&, actualFrame&
        DIM prevDest AS LONG

        IF GIFData(Index).Frame > GIFData(Index).totalFrames THEN
            GIFData(Index).Frame = 1
        END IF

        FOR i = 1 TO UBOUND(GIFFrameData)
            IF GIFFrameData(i).ID = GIFData(Index).ID AND GIFFrameData(i).thisFrame = GIFData(Index).Frame THEN
                frame = i
                EXIT FOR
            ELSEIF GIFFrameData(i).ID = GIFData(Index).ID AND GIFFrameData(i).thisFrame < GIFData(Index).Frame THEN
                previousFrame = i
            END IF
        NEXT

        GIFData(Index).LastFrameDelay = GIFFrameData(frame).delay - (GIFFrameData(frame).delay / 10)

        IF GIFFrameData(frame).addr > 0 THEN
            prevDest = _DEST
            w = GIFFrameData(frame).width
            h = GIFFrameData(frame).height
            img& = _NEWIMAGE(w, h, 256)
            actualFrame& = _NEWIMAGE(GIFData(Index).width, GIFData(Index).height, 256)

            _DEST img&
            DecodeFrame GIFData(Index), GIFFrameData(frame)

            _DEST actualFrame&
            IF GIFFrameData(frame).localColorTableFlag THEN
                _COPYPALETTE img&
            ELSE
                FOR i = 0 TO GIFData(Index).numColors - 1
                    _PALETTECOLOR i, _RGB32(ASC(GIFData(Index).palette, i * 3 + 1), ASC(GIFData(Index).palette, i * 3 + 2), ASC(GIFData(Index).palette, i * 3 + 3))
                NEXT
            END IF

            IF GIFData(Index).Frame > 1 THEN
                SELECT CASE GIFFrameData(previousFrame).disposalMethod
                    CASE 0, 1
                        _PUTIMAGE , GIFFrameData(previousFrame).addr
                    CASE 2
                        CLS , GIFData(Index).bgColor
                        _CLEARCOLOR GIFData(Index).bgColor
                END SELECT
            ELSE
                CLS , GIFData(Index).bgColor
            END IF

            IF GIFFrameData(frame).transparentFlag THEN
                _CLEARCOLOR GIFFrameData(frame).transColor, img&
            END IF
            _PUTIMAGE (GIFFrameData(frame).left, GIFFrameData(frame).top), img&
            _FREEIMAGE img&

            GIFFrameData(frame).addr = actualFrame&
            GIFData(Index).LoadedFrames = GIFData(Index).LoadedFrames + 1
            GIFData(Index).GifLoadComplete = (GIFData(Index).LoadedFrames = GIFData(Index).totalFrames)
            _DEST prevDest
        END IF

        GetGifFrame& = GIFFrameData(frame).addr
    END FUNCTION


    SUB DecodeFrame (gifdata AS GIFDATA, GifFrameData AS FRAMEDATA)
        DIM byte AS _UNSIGNED _BYTE
        DIM prefix(4095), suffix(4095), colorStack(4095)
        DIM startCodeSize AS INTEGER, clearCode AS INTEGER
        DIM endCode AS INTEGER, minCode AS INTEGER, startMaxCode AS INTEGER
        DIM nvc AS INTEGER, codeSize AS INTEGER
        DIM maxCode AS INTEGER, bitPointer AS INTEGER, blockSize AS INTEGER
        DIM blockPointer AS INTEGER, x AS INTEGER, y AS INTEGER
        DIM palette$, i AS LONG, c&, stackPointer AS INTEGER
        DIM currentCode AS INTEGER, code AS INTEGER, lastColor AS INTEGER
        DIM oldCode AS INTEGER, WorkCode&, LastChar AS INTEGER
        DIM interlacedPass AS INTEGER, interlacedStep AS INTEGER
        DIM file AS INTEGER, a$, loopStart!

        startCodeSize = gifdata.bpp + 1
        clearCode = 2 ^ gifdata.bpp
        endCode = clearCode + 1
        minCode = endCode + 1
        startMaxCode = clearCode * 2 - 1
        nvc = minCode
        codeSize = startCodeSize
        maxCode = startMaxCode

        IF GifFrameData.interlacedFlag THEN interlacedPass = 0: interlacedStep = 8
        bitPointer = 0
        blockSize = 0
        blockPointer = 0
        x = 0
        y = 0

        file = gifdata.file
        SEEK file, GifFrameData.addr

        IF GifFrameData.localColorTableFlag THEN
            palette$ = SPACE$(3 * 2 ^ GifFrameData.palBPP)
            GET file, , palette$

            FOR i = 0 TO gifdata.numColors - 1
                c& = _RGB32(ASC(palette$, i * 3 + 1), ASC(palette$, i * 3 + 2), ASC(palette$, i * 3 + 3))
                _PALETTECOLOR i, c&
            NEXT
        END IF

        GET file, , byte ' minimumCodeSize

        loopStart! = TIMER
        DO
            IF TIMER - loopStart! > 2 THEN EXIT DO
            GOSUB GetCode
            stackPointer = 0
            IF code = clearCode THEN 'Reset & Draw next color direct
                nvc = minCode '           \
                codeSize = startCodeSize ' Preset default codes
                maxCode = startMaxCode '  /

                GOSUB GetCode
                currentCode = code

                lastColor = code
                colorStack(stackPointer) = lastColor
                stackPointer = 1
            ELSEIF code <> endCode THEN 'Draw direct color or colors from suffix
                currentCode = code
                IF currentCode = nvc THEN 'Take last color too
                    currentCode = oldCode
                    colorStack(stackPointer) = lastColor
                    stackPointer = stackPointer + 1
                END IF

                WHILE currentCode >= minCode 'Extract colors from suffix
                    colorStack(stackPointer) = suffix(currentCode)
                    stackPointer = stackPointer + 1
                    currentCode = prefix(currentCode) 'Next color from suffix is described in
                WEND '                                 the prefix, else prefix is the last col.

                lastColor = currentCode '              Last color is equal to the
                colorStack(stackPointer) = lastColor ' last known code (direct, or from
                stackPointer = stackPointer + 1 '      Prefix)
                suffix(nvc) = lastColor 'Automatically, update suffix
                prefix(nvc) = oldCode 'Code from the session before (for extracting from suffix)
                nvc = nvc + 1

                IF nvc > maxCode AND codeSize < 12 THEN
                    codeSize = codeSize + 1
                    maxCode = maxCode * 2 + 1
                END IF
            END IF

            FOR i = stackPointer - 1 TO 0 STEP -1
                PSET (x, y), colorStack(i)
                x = x + 1
                IF x = GifFrameData.width THEN
                    x = 0
                    IF GifFrameData.interlacedFlag THEN
                        y = y + interlacedStep
                        IF y >= GifFrameData.height THEN
                            SELECT CASE interlacedPass
                                CASE 0: interlacedPass = 1: y = 4
                                CASE 1: interlacedPass = 2: y = 2
                                CASE 2: interlacedPass = 3: y = 1
                            END SELECT
                            interlacedStep = 2 * y
                        END IF
                    ELSE
                        y = y + 1
                    END IF
                END IF
            NEXT

            oldCode = code
        LOOP UNTIL code = endCode
        GET file, , byte
        EXIT SUB

        GetCode:
        IF bitPointer = 0 THEN GOSUB ReadByteFromBlock: bitPointer = 8
        WorkCode& = LastChar \ (2 ^ (8 - bitPointer))
        WHILE codeSize > bitPointer
            GOSUB ReadByteFromBlock

            WorkCode& = WorkCode& OR LastChar * (2 ^ bitPointer)
            bitPointer = bitPointer + 8
        WEND
        bitPointer = bitPointer - codeSize
        code = WorkCode& AND maxCode
        RETURN

        ReadByteFromBlock:
        IF blockPointer = blockSize THEN
            GET file, , byte: blockSize = byte
            a$ = SPACE$(blockSize): GET file, , a$
            blockPointer = 0
        END IF
        blockPointer = blockPointer + 1
        LastChar = ASC(MID$(a$, blockPointer, 1))
        RETURN
    END SUB


    FUNCTION gifOverlayImage$
        DIM A$
        A$ = MKI$(64) + MKI$(64)
        A$ = A$ + "000000000000000000000000000000000000000000000000000000000000"
        A$ = A$ + "000000000000000000000000000000000000000000000000000000000000"
        A$ = A$ + "000000000000J000005000`M0000M20004<000`e0000V30008?000Pl0000"
        A$ = A$ + "V3000L=000@`0000M2000L70000D0000J000000000000000000000000000"
        A$ = A$ + "000000000000000000000000000000000000000000000000000000000000"
        A$ = A$ + "000000000000000000000000000000000000000000000000000000000000"
        A$ = A$ + "000000000000000000000000000000000000000000000000000000000000"
        A$ = A$ + "000000000000000000000000000000000000003000PQ0000<30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?0"
        A$ = A$ + "00Pl0000b30008?0000c0000620000300000000000000000000000000000"
        A$ = A$ + "000000000000000000000000000000000000000000000000000000000000"
        A$ = A$ + "000000000000000000000000000000000000000000000000000000000000"
        A$ = A$ + "000000000000000000000000000000000000000000000000000000000000"
        A$ = A$ + "00030000^1000X<000Pl0000b30008?000Pl0000b30008?000Pl0000b300"
        A$ = A$ + "08?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000"
        A$ = A$ + "b30008?000Pl0000:3000h60000300000000000000000000000000000000"
        A$ = A$ + "000000000000000000000000000000000000000000000000000000000000"
        A$ = A$ + "000000000000000000000000000000000000000000000000000000000000"
        A$ = A$ + "000000000000000000000000000000000l0000@N0000Q30008?000Pl0000"
        A$ = A$ + "b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?0"
        A$ = A$ + "00Pl0000Q3000T7000`30000000000000000000000000000000000000000"
        A$ = A$ + "000000000000000000000000000000000000000000000000000000000000"
        A$ = A$ + "000000000000000000000000000000000000000000000000000000000000"
        A$ = A$ + "000010000\5000`g0000b30008?000Pl0000b30008?000Pl0000b30008?0"
        A$ = A$ + "00Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b300"
        A$ = A$ + "08?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000"
        A$ = A$ + "O3000\5000@0000000000000000000000000000000000000000000000000"
        A$ = A$ + "000000000000000000000000000000000000000000000000000000000000"
        A$ = A$ + "0000000000000000000000000000000000000000R0000X;000Pl0000b300"
        A$ = A$ + "08?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000"
        A$ = A$ + "b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000j2000420"
        A$ = A$ + "000000000000000000000000000000000000000000000000000000000000"
        A$ = A$ + "000000000000000000000000000000000000000000000000000000000000"
        A$ = A$ + "0000000000000000A1000D>000Pl0000b30008?000Pl0000b30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?0"
        A$ = A$ + "00Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b300"
        A$ = A$ + "08?000Pl0000b30008?000Pl0000b30008?000@i0000A100000000000000"
        A$ = A$ + "000000000000000000000000000000000000000000000000000000000000"
        A$ = A$ + "0000000000000000000000000000000000000000000000@00000520008?0"
        A$ = A$ + "00Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b300"
        A$ = A$ + "08?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000"
        A$ = A$ + "b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000b30008?000@Q0000100000000000000000000000"
        A$ = A$ + "000000000000000000000000000000000000000000000000000000000000"
        A$ = A$ + "0000000000000000000000P10000M20008?000Pl0000b30008?000Pl0000"
        A$ = A$ + "b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?0"
        A$ = A$ + "00Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b300"
        A$ = A$ + "08?000Pl0000b3000d9000P1000000000000000000000000000000000000"
        A$ = A$ + "0000000000000000000000000000000000000000000000000000000000P1"
        A$ = A$ + "0000^20008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?0"
        A$ = A$ + "00Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b300"
        A$ = A$ + "08?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000"
        A$ = A$ + "b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl"
        A$ = A$ + "0000^2000H00000000000000000000000000000000000000000000000000"
        A$ = A$ + "0000000000000000000000000000000000@00000L20008?000Pl0000b300"
        A$ = A$ + "08?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000"
        A$ = A$ + "b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?0"
        A$ = A$ + "00Pl0000b30008?000Pl0000b30008?000Pl0000b30008?0000W00001000"
        A$ = A$ + "000000000000000000000000000000000000000000000000000000000000"
        A$ = A$ + "0000000000000000120008?000Pl0000b30008?000Pl0000b30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?0"
        A$ = A$ + "00Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b300"
        A$ = A$ + "08?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000"
        A$ = A$ + "b30008?000Pl0000b30008?000Pl0000b300088000000000000000000000"
        A$ = A$ + "0000000000000000000000000000000000000000000000000000@10008?0"
        A$ = A$ + "00Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b300"
        A$ = A$ + "08?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000"
        A$ = A$ + "b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?0"
        A$ = A$ + "00Pl0000b30008?000Pl0000A10000000000000000000000000000000000"
        A$ = A$ + "0000000000000000000000000000P0000@>000Pl0000b30008?000Pl0000"
        A$ = A$ + "b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?0"
        A$ = A$ + "00Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b300"
        A$ = A$ + "08?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000"
        A$ = A$ + "b3000@>00008000000000000000000000000000000000000000000000000"
        A$ = A$ + "000010000T;000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?0"
        A$ = A$ + "00Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b300"
        A$ = A$ + "08?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000"
        A$ = A$ + "b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000i2000400"
        A$ = A$ + "000000000000000000000000000000000000000000000\5000Pl0000b300"
        A$ = A$ + "08?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000"
        A$ = A$ + "b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?0"
        A$ = A$ + "00Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b300"
        A$ = A$ + "08?000Pl0000b30008?000Pl0000b30008?0000G00000000000000000000"
        A$ = A$ + "000000000000000000000l0000Pg0000b30008?000Pl0000b30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?0"
        A$ = A$ + "00Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b300"
        A$ = A$ + "08?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000"
        A$ = A$ + "b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000N3000l0000000000000000000000000000000000"
        A$ = A$ + "00@N0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b300"
        A$ = A$ + "08?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000"
        A$ = A$ + "b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?0"
        A$ = A$ + "00Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b300"
        A$ = A$ + "08?000@N000000000000000000000000000000`20000Q30008?000Pl0000"
        A$ = A$ + "b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?0"
        A$ = A$ + "00Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b300"
        A$ = A$ + "08?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000"
        A$ = A$ + "b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000Q3000`000000"
        A$ = A$ + "00000000000000000000^10008?000Pl0000b30008?000Pl0000b30008?0"
        A$ = A$ + "00Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b300"
        A$ = A$ + "08?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000"
        A$ = A$ + "b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?0"
        A$ = A$ + "00Pl0000b30008?000Pl0000b30008?000PK000000000000000000001000"
        A$ = A$ + "0l<000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000"
        A$ = A$ + "b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?0"
        A$ = A$ + "00Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b300"
        A$ = A$ + "08?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000"
        A$ = A$ + "b30008?000Pl0000@30004000000000000000L3000Pl0000b30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?0"
        A$ = A$ + "000m0000f3000P?000Pn0000j3000X?000Pn0000h3000@?000`l0000b300"
        A$ = A$ + "08?000Pl0000b30008?000@m0000h3000X?0000n0000f30008?000`l0000"
        A$ = A$ + "g3000T?000Pn0000j3000X?000Pn0000j3000X?000Pn0000j3000X?000Pn"
        A$ = A$ + "0000j3000P?000`l0000b30008?000Pl0000b30008?000Pl0000b30008?0"
        A$ = A$ + "00`=000000000000000R0000b30008?000Pl0000b30008?000Pl0000b300"
        A$ = A$ + "08?000Pl0000b30008?000Pl0000b3000D?0000n0000j3000X?000Pn0000"
        A$ = A$ + "j3000X?000Pn0000j3000X?000Pn0000i3000H?000Pl0000b30008?000@m"
        A$ = A$ + "0000j3000X?000Pn0000j3000X?000Pm0000g3000X?000Pn0000j3000X?0"
        A$ = A$ + "00Pn0000j3000X?000Pn0000j3000X?000Pn0000j3000X?000Pn0000i300"
        A$ = A$ + "08?000Pl0000b30008?000Pl0000b30008?000Pl00009200000000000000"
        A$ = A$ + "<30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl"
        A$ = A$ + "0000b3000H?000Pn0000jOb9WX?WLb9oNk]gnooooooooooooooooooooooZ"
        A$ = A$ + "[^JoniWOl3000X?000Pn0000h30008?000Pl0000g3000X?^hRKoooooo;]d"
        A$ = A$ + "Bk?000Pn0000h3000T?000PnZ[^jnooooooooooooooooooooooooooooooo"
        A$ = A$ + "oooooooooooooooooooooooooooo\a6Kk3000X?000@m0000b30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000b3000d<000000000K00008?000Pl0000b30008?0"
        A$ = A$ + "00Pl0000b30008?000Pl0000b30008?000Pl0000b3000H?000Pn0000j_jZ"
        A$ = A$ + "[foooooooooooooooooooooooooooooooooooooooooooooooo_dB;]oWLb9"
        A$ = A$ + "j3000X?000Pm0000b3000L?000PnhR;^mooooo_dB;]o0000j3000P?000@n"
        A$ = A$ + "0000j[^jZkoooooooooooooooooooooooooooooooooooooooooooooooooo"
        A$ = A$ + "oooooooooc6K\]?000Pn0000e30008?000Pl0000b30008?000Pl0000b300"
        A$ = A$ + "08?000Pl0000L000005000Pl0000b30008?000Pl0000b30008?000Pl0000"
        A$ = A$ + "b30008?000Pl0000b3000@?000Pn0000j;]dBkoooooooooooGLa5g_Oni7o"
        A$ = A$ + "0000j3000X?000PnIUEFk_jZ[foooooooooook]gNk?000Pn0000j3000@?0"
        A$ = A$ + "00`m0000jS;^hfooooooB;]dn3000X?0000n0000i3000X_jZ[^oooooogHS"
        A$ = A$ + "=b?000Pn0000j3000X?000Pn0000j3000X?000Pn0000j3000X?000Pn0000"
        A$ = A$ + "i30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b300085000@O"
        A$ = A$ + "0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?0"
        A$ = A$ + "000n0000jc9WLboooooooooooc6K\]?000Pn0000j3000X?000Pn0000j300"
        A$ = A$ + "0X?000PnIUEFkoooooooooooLb9Wl3000X?000Pm0000g3000X?^hRKooooo"
        A$ = A$ + "o;]dBk?000Pn0000h3000T?000PnZ[^jnoooooOS=f8o0000j3000X?000Pn"
        A$ = A$ + "0000j3000X?000Pn0000j3000X?000Pn0000h3000<?000Pl0000b30008?0"
        A$ = A$ + "00Pl0000b30008?000Pl0000b30008?000@O0000T20008?000Pl0000b300"
        A$ = A$ + "08?000Pl0000b30008?000Pl0000b30008?0000m0000jOb9WXoooooooooo"
        A$ = A$ + "ogHS=b?000Pn0000i3000H?000`l0000b30008?000@m0000h3000X?WLb9o"
        A$ = A$ + "oooook]gNk?000Pn0000h3000L?000PnhR;^mooooo_dB;]o0000j3000P?0"
        A$ = A$ + "00@n0000j[^jZkoooooo=fHSl3000X?000@m0000b30008?000Pl0000b300"
        A$ = A$ + "08?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000"
        A$ = A$ + "b30008?000Pl0000T20008<000Pl0000b30008?000Pl0000b30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000f3000X?WLb9oooooo[^jZk?000Pn0000j3000<?0"
        A$ = A$ + "00Pl0000b30008?000Pl0000b3000@?000PnWLb9jGLa5g?WLb9oWLb9j300"
        A$ = A$ + "0X?000`m0000jS;^hfooooooB;]dn3000X?0000n0000i3000X_jZ[^ooooo"
        A$ = A$ + "ogHS=b?000Pn0000e30008?000Pl0000b30008?000Pl0000b30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008<0"
        A$ = A$ + "00@f0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b300"
        A$ = A$ + "0P?000PnNk]gnooooo?WLb9o0000j3000L?000Pl0000b30008?000Pl0000"
        A$ = A$ + "b30008?000Pl0000h3000X?000Pn0000j3000X?0000n0000g3000X?^hRKo"
        A$ = A$ + "ooooo;]dBk?000Pn0000h3000T?000PnZ[^jnoooooOS=f8o0000j3000X?0"
        A$ = A$ + "00Pn0000j3000X?000Pn0000j3000P?000Pm0000b30008?000Pl0000b300"
        A$ = A$ + "08?000Pl0000b30008?000Pl0000b30008?000@e0000V30008?000Pl0000"
        A$ = A$ + "b30008?000Pl0000b30008?000Pl0000b30008?000@n0000jC?mdooooooo"
        A$ = A$ + "\a6Kk3000X?000@m0000b30008?000`l0000h3000X?000Pn0000j3000X?0"
        A$ = A$ + "00Pn0000j3000X?0000n0000c3000L?000PnhR;^mooooo_dB;]o0000j300"
        A$ = A$ + "0P?000@n0000j[^jZkoooooo=fHSl3000X?000Pn0000j3000X?000Pn0000"
        A$ = A$ + "j3000X?000Pn0000j3000H?000Pl0000b30008?000Pl0000b30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000P30008?000Pl0000b30008?000Pl0000b30008?0"
        A$ = A$ + "00Pl0000b30008?000Pl0000j3000Xooooooooooo?d@3]?000Pn0000c300"
        A$ = A$ + "08?000Pl0000i3000X?000Pn0000j3000X?000Pn0000j3000X?000Pn0000"
        A$ = A$ + "j3000X?000`m0000jS;^hfooooooB;]dn3000X?0000n0000i3000X_jZ[^o"
        A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooooooooooB;]dn3000X?0"
        A$ = A$ + "000n0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b300"
        A$ = A$ + "0`>000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000"
        A$ = A$ + "b3000X?000Pnooooooooooo@3=dn0000j3000<?000Pl0000e3000X?K\afn"
        A$ = A$ + "ooooooooooooooooooooooooooooooooooooogHS=b?000Pn0000g3000X?^"
        A$ = A$ + "hRKoooooo;]dBk?000Pn0000h3000T?000PnZ[^jnooooooooooooooooooo"
        A$ = A$ + "ooooooooooooooooooooooooooooo;]dBk?000Pn0000h30008?000Pl0000"
        A$ = A$ + "b30008?000Pl0000b30008?000Pl0000b30008?0000k0000V30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000b30008?000Pl0000b30008?000Pn0000jooooooo"
        A$ = A$ + "oooo\a6Kk3000X?000@m0000b3000D?000Pn\a6Kkooooooooooooooooooo"
        A$ = A$ + "ooooooooooooooooooOS=f8o0000j3000L?000PnhR;^mooooo_dB;]o0000"
        A$ = A$ + "j3000P?000@n0000j[^jZkoooooo=fHSl3000X?000Pn0000j3000X?000Pn"
        A$ = A$ + "0000j3000X?000Pn0000j3000H?000Pl0000b30008?000Pl0000b30008?0"
        A$ = A$ + "00Pl0000b30008?000Pl0000P3000T=000Pl0000b30008?000Pl0000b300"
        A$ = A$ + "08?000Pl0000b30008?000Pl0000h3000X_gNk]ooooooc9WLb?000Pn0000"
        A$ = A$ + "f30008?000Pl0000i3000X?000Pn0000j3000X?000Pn0000j[^jZkoooooo"
        A$ = A$ + "=fHSl3000X?000`m0000jS;^hfooooooB;]dn3000X?0000n0000i3000X_j"
        A$ = A$ + "Z[^oooooogHS=b?000Pn0000j3000X?000Pn0000j3000X?000Pn0000h300"
        A$ = A$ + "0H?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000"
        A$ = A$ + "b3000D=000P`0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl"
        A$ = A$ + "0000b3000H?000PnLb9Wlooooo_gNk]o0000j3000T?000`l0000b3000<?0"
        A$ = A$ + "000n0000j3000X?000Pn0000j3000X_jZ[^oooooogHS=b?000Pn0000g300"
        A$ = A$ + "0X?^hRKoooooo;]dBk?000Pn0000h3000T?000PnZ[^jnoooooOS=f8o0000"
        A$ = A$ + "j3000D?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000b30008?000Pl0000b30008?000P`0000T20008?0"
        A$ = A$ + "00Pl0000b30008?000Pl0000b30008?000Pl0000b30008?0000m0000j?d@"
        A$ = A$ + "3]oooooooooookWOna?000Pn0000i3000H?0000m0000b30008?0000m0000"
        A$ = A$ + "g3000T?000PnZ[^jnoooooOS=f8o0000j3000L?000PnhR;^mooooo_dB;]o"
        A$ = A$ + "0000j3000P?000@n0000j[^jZkoooooo=fHSl3000X?000@m0000b30008?0"
        A$ = A$ + "00Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b300"
        A$ = A$ + "08?000Pl0000b30008?000Pl0000T2000d7000Pl0000b30008?000Pl0000"
        A$ = A$ + "b30008?000Pl0000b30008?000Pl0000b3000P?000PnLb9Wlooooooooooo"
        A$ = A$ + "niWOl3000X?000Pn0000j3000X?000Pn0000j3000X?000PnniWOlC?mdooo"
        A$ = A$ + "oooo=fHSl3000X?000`m0000jS;^hfooooooB;]dn3000X?0000n0000i300"
        A$ = A$ + "0X_jZ[^oooooogHS=b?000Pn0000e30008?000Pl0000b30008?000Pl0000"
        A$ = A$ + "b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl"
        A$ = A$ + "0000b3000d7000PD0000b30008?000Pl0000b30008?000Pl0000b30008?0"
        A$ = A$ + "00Pl0000b30008?0000m0000j3000X?^hRKooooooooooo_dB;]oLb9Wl300"
        A$ = A$ + "0X?000Pn0000jOb9WX?WLb9oZ[^jnoooooooooooZ[^jnWEFI]?000Pn0000"
        A$ = A$ + "g3000X?^hRKoooooo;]dBk?000Pn0000h3000T?000PnZ[^jnoooooOS=f8o"
        A$ = A$ + "0000j3000D?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?0"
        A$ = A$ + "00Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000PD0000L000"
        A$ = A$ + "08?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000"
        A$ = A$ + "b3000D?000Pn0000jc9WLboooooooooooooooooooooooooooooooooooooo"
        A$ = A$ + "oooooooooooooooo[^jZm3000X?000Pn0000h3000L?000PnhR;^mooooo_d"
        A$ = A$ + "B;]o0000j3000P?000@n0000j[^jZkoooooo=fHSl3000X?000@m0000b300"
        A$ = A$ + "08?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000"
        A$ = A$ + "b30008?000Pl0000b30008?000Pl0000L000000000@c0000b30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000e3000X?0"
        A$ = A$ + "00Pn0000jc9WLbOa5GLooooooooooooooooooooooGLa5g?WLb9o0000j300"
        A$ = A$ + "0X?000Pn0000g3000<?000`m0000jS;^hfooooooB;]dn3000X?0000n0000"
        A$ = A$ + "i3000X_jZ[^oooooogHS=b?000Pn0000e30008?000Pl0000b30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?0"
        A$ = A$ + "00Pl0000>300000000000000920008?000Pl0000b30008?000Pl0000b300"
        A$ = A$ + "08?000Pl0000b30008?000Pl0000b30008?0000m0000h3000X?000Pn0000"
        A$ = A$ + "j3000X?000Pn0000j3000X?000Pn0000j3000X?0000n0000e30008?000Pl"
        A$ = A$ + "0000e3000X?000Pn0000j3000X?000Pn0000f3000L?000Pn0000j3000X?0"
        A$ = A$ + "00Pn0000j3000<?000Pl0000b30008?000Pl0000b30008?000Pl0000b300"
        A$ = A$ + "08?000Pl0000b30008?000Pl0000b30008?000Pl0000b3000T8000000000"
        A$ = A$ + "00000P3000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000b30008?0000m0000f3000P?000Pn0000j3000X?0"
        A$ = A$ + "00Pn0000h3000H?0000m0000b30008?000Pl0000b30008?000@m0000h300"
        A$ = A$ + "0X?0000n0000f30008?000`l0000g3000T?000Pn0000h3000<?000Pl0000"
        A$ = A$ + "b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000b30008?0000>00000000000000@00000@30008?0"
        A$ = A$ + "00Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b300"
        A$ = A$ + "08?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000"
        A$ = A$ + "b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?0"
        A$ = A$ + "00Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b300"
        A$ = A$ + "08?0000d0000100000000000000000000h6000Pl0000b30008?000Pl0000"
        A$ = A$ + "b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?0"
        A$ = A$ + "00Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b300"
        A$ = A$ + "08?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000"
        A$ = A$ + "b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000^10000000000"
        A$ = A$ + "00000000000000030000R30008?000Pl0000b30008?000Pl0000b30008?0"
        A$ = A$ + "00Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b300"
        A$ = A$ + "08?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000"
        A$ = A$ + "b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?0"
        A$ = A$ + "00Pl0000b30008?000Pl0000R3000`000000000000000000000000000000"
        A$ = A$ + "0T7000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000"
        A$ = A$ + "b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?0"
        A$ = A$ + "00Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b300"
        A$ = A$ + "08?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000"
        A$ = A$ + "b3000T700000000000000000000000000000000000`30000N30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?0"
        A$ = A$ + "00Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b300"
        A$ = A$ + "08?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000"
        A$ = A$ + "b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000b30008?000Pl0000b3000h=000@4000000000000"
        A$ = A$ + "00000000000000000000000000000`5000Pl0000b30008?000Pl0000b300"
        A$ = A$ + "08?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000"
        A$ = A$ + "b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?0"
        A$ = A$ + "00Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b300"
        A$ = A$ + "08?000Pl0000b30008?0000G000000000000000000000000000000000000"
        A$ = A$ + "0000000000@00000j20008?000Pl0000b30008?000Pl0000b30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?0"
        A$ = A$ + "00Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b300"
        A$ = A$ + "08?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000"
        A$ = A$ + "b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000P^"
        A$ = A$ + "000010000000000000000000000000000000000000000000000000000420"
        A$ = A$ + "000i0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b300"
        A$ = A$ + "08?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000"
        A$ = A$ + "b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?0"
        A$ = A$ + "00Pl0000b30008?000Pl0000b30008?0000i0000Q0000000000000000000"
        A$ = A$ + "00000000000000000000000000000000000000000000A10008?000Pl0000"
        A$ = A$ + "b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?0"
        A$ = A$ + "00Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b300"
        A$ = A$ + "08?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000"
        A$ = A$ + "b30008?000Pl0000A1000000000000000000000000000000000000000000"
        A$ = A$ + "000000000000000000000000000000`P0000b30008?000Pl0000b30008?0"
        A$ = A$ + "00Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b300"
        A$ = A$ + "08?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000"
        A$ = A$ + "b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl000042000000"
        A$ = A$ + "000000000000000000000000000000000000000000000000000000000000"
        A$ = A$ + "00000000000010000`9000Pl0000b30008?000Pl0000b30008?000Pl0000"
        A$ = A$ + "b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?0"
        A$ = A$ + "00Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b300"
        A$ = A$ + "08?000Pl0000b30008?000Pl0000L2000400000000000000000000000000"
        A$ = A$ + "0000000000000000000000000000000000000000000000000000000000P1"
        A$ = A$ + "0000^20008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?0"
        A$ = A$ + "00Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b300"
        A$ = A$ + "08?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000"
        A$ = A$ + "b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl"
        A$ = A$ + "0000^2000H00000000000000000000000000000000000000000000000000"
        A$ = A$ + "000000000000000000000000000000000000000000000H0000@W0000b300"
        A$ = A$ + "08?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000"
        A$ = A$ + "b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?0"
        A$ = A$ + "00Pl0000b30008?000Pl0000b30008?000Pl0000M2000H00000000000000"
        A$ = A$ + "000000000000000000000000000000000000000000000000000000000000"
        A$ = A$ + "0000000000000000000000000000000010000D8000Pl0000b30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?0"
        A$ = A$ + "00Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b300"
        A$ = A$ + "08?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000"
        A$ = A$ + "b30008?000Pl000052000400000000000000000000000000000000000000"
        A$ = A$ + "000000000000000000000000000000000000000000000000000000000000"
        A$ = A$ + "000000000000000000000000A1000D>000Pl0000b30008?000Pl0000b300"
        A$ = A$ + "08?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000"
        A$ = A$ + "b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000b30008?000Pl0000b30008?000@i0000A1000000"
        A$ = A$ + "000000000000000000000000000000000000000000000000000000000000"
        A$ = A$ + "000000000000000000000000000000000000000000000000000000000000"
        A$ = A$ + "0000000000P80000j20008?000Pl0000b30008?000Pl0000b30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?0"
        A$ = A$ + "00Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b300"
        A$ = A$ + "08?000Pl0000b30008?000P^0000Q0000000000000000000000000000000"
        A$ = A$ + "000000000000000000000000000000000000000000000000000000000000"
        A$ = A$ + "000000000000000000000000000000000000000000000000000000000400"
        A$ = A$ + "000G0000O30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b300"
        A$ = A$ + "08?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000"
        A$ = A$ + "b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b3000l=0000G"
        A$ = A$ + "000010000000000000000000000000000000000000000000000000000000"
        A$ = A$ + "000000000000000000000000000000000000000000000000000000000000"
        A$ = A$ + "0000000000000000000000000000000000000000000000000l0000@N0000"
        A$ = A$ + "Q30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?0"
        A$ = A$ + "00Pl0000b30008?000Pl0000Q3000X7000`3000000000000000000000000"
        A$ = A$ + "000000000000000000000000000000000000000000000000000000000000"
        A$ = A$ + "000000000000000000000000000000000000000000000000000000000000"
        A$ = A$ + "00000000000000000000000000000000000000000`0000PK0000;30008?0"
        A$ = A$ + "00Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b300"
        A$ = A$ + "08?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000`b0000"
        A$ = A$ + "^1000`000000000000000000000000000000000000000000000000000000"
        A$ = A$ + "000000000000000000000000000000000000000000000000000000000000"
        A$ = A$ + "000000000000000000000000000000000000000000000000000000000000"
        A$ = A$ + "000000000000000000000000000000000000000<0000920000=000Pl0000"
        A$ = A$ + "b30008?000Pl0000b30008?000Pl0000b30008?000Pl0000b30008?000Pl"
        A$ = A$ + "0000b30008?000Pl0000@3000T80000<0000000000000000000000000000"
        A$ = A$ + "000000000000000000000000000000000000000000000000000000000000"
        A$ = A$ + "000000000000000000000000000000000000000000000000000000000000"
        A$ = A$ + "000000000000000000000000000000000000000000000000000000000000"
        A$ = A$ + "000000000000000000000000000000000000J000005000@N0000N20008<0"
        A$ = A$ + "000f0000Y30008?000@k0000R30008=000P`0000N2000T70000D0000J000"
        A$ = A$ + "000000000000000000000000000000000000000000000000000000000000"
        A$ = A$ + "000000000000000000000000000000000000000000000000000000000000"
        A$ = A$ + "0000%%00"
        gifOverlayImage$ = A$
    END FUNCTION


    FUNCTION LoadOverlayImage&
        $IF INFORM_BI = UNDEFINED THEN
            DECLARE CUSTOMTYPE LIBRARY
                SUB __UI_MemCopy ALIAS memcpy (BYVAL dest AS _OFFSET, BYVAL source AS _OFFSET, BYVAL bytes AS LONG)
            END DECLARE
        $END IF

        DIM MemoryBlock AS _MEM, TempImage AS LONG
        DIM NewWidth AS INTEGER, NewHeight AS INTEGER, A$, BASFILE$

        A$ = gifOverlayImage$
        IF LEN(A$) = 0 THEN EXIT FUNCTION

        NewWidth = CVI(LEFT$(A$, 2))
        NewHeight = CVI(MID$(A$, 3, 2))
        A$ = MID$(A$, 5)

        BASFILE$ = gifUnpack$(A$)

        TempImage = _NEWIMAGE(NewWidth, NewHeight, 32)
        MemoryBlock = _MEMIMAGE(TempImage)

        __UI_MemCopy MemoryBlock.OFFSET, _OFFSET(BASFILE$), LEN(BASFILE$)
        _MEMFREE MemoryBlock

        LoadOverlayImage& = TempImage
    END FUNCTION


    FUNCTION gifUnpack$ (PackedData$)
        'Adapted from Dav's BIN2BAS
        'http://www.qbasicnews.com/dav/qb64.php
        DIM A$, i&, B$, C%, F$, C$, t%, B&, X$, btemp$

        A$ = PackedData$

        FOR i& = 1 TO LEN(A$) STEP 4
            B$ = MID$(A$, i&, 4)
            IF INSTR(1, B$, "%") THEN
                FOR C% = 1 TO LEN(B$)
                    F$ = MID$(B$, C%, 1)
                    IF F$ <> "%" THEN C$ = C$ + F$
                NEXT
                B$ = C$
            END IF
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

        gifUnpack$ = btemp$
    END FUNCTION

$END IF
