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


    FUNCTION LoadOverlayImage&
        CONST SIZE_GIFOVERLAYIMAGE_BMP_16506 = 16506
        CONST COMP_GIFOVERLAYIMAGE_BMP_16506 = -1
        CONST DATA_GIFOVERLAYIMAGE_BMP_16506 = _
                "eNpy8q1yYACDKiDOAWIHKGZkUGBgZsAF/kMQjDM4gRSgfbsGjt+I4jgexj+2YU57nd27H0Nl6htD6wkzJ31hqFyFWkMVZmZm5rzjMyjfzcwLvEKj" + _
                "tXTnFbyZjxn0O60WBBjDdVjDU/gAP0LwK77CW3gKa7gOY+B3c1k13Ic3ICm9gftQQ8h1BIt4GdInL2MRRxBKHcd1+BIyIF/iehzHYdWpmMXnkEPy" + _
                "OWZxKgZZV2AbEohtXI5B1Di+hQTmW4z3ub3fBQncXX04Hs7CKiQnVnFWhtkfh+TM4zgrgza/AsmplZTHwh2QnLszRT8vheA/LlyObyAF8Q0u9zjm" + _
                "tyEFs52wL5iFFNRsgrXMZ5CC+gwnY/JfBym462LW719BCu4rHIGtRUhJLNo+H29ASuINMxYMQ1JooIUOekYHLTQgFpromJ8V1NFGV7+HOiQjw9C6" + _
                "L0VumzlOB02TvWehhTZ6VoavwX3QehXixWz7ysrK7rPPPrsXmXJfc98zGdqoa8bNzc2/f++tt97a19dJ9/tPP/20H1EPPfSQ/o0mJAOvwdVFabK7" + _
                "bFHCeuSRR/ZMWxh4fuMiTBygzff+u9267XY/X3vttT33Nc3gyn08NTW1474fQP4J3ATx0LH7/eabbzbt24D7mUajEWmWQPLfhHXffT8yMrJjs6Nr" + _
                "+3k00LZZAsq/jqcgCbX+u+8/++yzfc2OOgR1bSNWgPmfwoe+bd/ljig93tGCOLrd/ctvwM4dPLyL7yAJ9Rxt+/Pz8ztmnzTRc1+PYirT/Ibna/AF" + _
                "5KD56Qc0f72v+ROU+V1J6JeM89v2Hy+A/Inav8mm45ht/7b/i9FBPZD2n0X/107ye0YnhP4vzfjnti3BuqShc0FdC7iPQxn/fOc/msX2ZTr/Qd2u" + _
                "be2cIaD5/3oW81/tByzl5vsRZecM2R//3ucJbsLYQdc/bnv/u8616wCX2635Isrse6eRYX6r67H+uRDiqYWeo/mSjE8cN6aPzm78i5mTxbkIrl5J" + _
                "8xroOlfHBbvmN+2iAwkg/6vQuhfixfRvCWj/KN7nv/x1Pc9/DfX5/GcD9ZTnP5Fp/zdkzn+/Xsrz39X1D63z8SWk4L7Eker6Z2mvfx9HXM2U+P4H" + _
                "HQu2IAVDJrIlq8uKd/8TmfxqrMT3v2ndBsm526v7X6v7n6v736vnH6rnX6rnnzI+HmYCeP5tBqeW8PnH63A8wOdfX4L0yUvm+ddQq4a78QokpVdw" + _
                "N2rIY+nz70tYxZN431x3/g7v40msYmlQz7//BcxY2A4="

        LoadOverlayImage = _LOADIMAGE(Base64_LoadResourceString(DATA_GIFOVERLAYIMAGE_BMP_16506, SIZE_GIFOVERLAYIMAGE_BMP_16506, COMP_GIFOVERLAYIMAGE_BMP_16506), 32, "memory")
    END FUNCTION

    '$INCLUDE:'Base64.bas'

$END IF
