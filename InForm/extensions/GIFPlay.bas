'#######################################################################################
'# Animated GIF decoder v1.0                                                           #
'# By Zom-B                                                                            #
'#                                                                                     #
'# https://qb64phoenix.com/qb64wiki/index.php/GIF_Images                               #
'#######################################################################################
'
' Adapted for use with InForm's PictureBox controls by @FellippeHeitor
'
' Fixed, refactored and enhanced by @a740g

$IF GIFPLAY_BAS = UNDEFINED THEN
    $LET GIFPLAY_BAS = TRUE

    '$INCLUDE:'GIFPlay.bi'

    SUB GIF_Update (ID AS LONG)
        SHARED __GIFData() AS __GIFDataType

        STATIC GifOverlay AS LONG

        DIM i AS LONG, newFrame AS LONG

        i = __GIF_GetIndex(ID)

        IF i = 0 THEN EXIT SUB

        IF GifOverlay = 0 THEN
            GifOverlay = __GIF_LoadOverlayImage
        END IF

        IF __GIFData(i).isPlaying OR __GIFData(i).lastFrameServed = 0 THEN
            IF __GIFData(i).lastFrameUpdate > 0 AND TIMER - __GIFData(i).lastFrameUpdate < __GIFData(i).lastFrameDelay THEN
                'Wait for the GIF's frame delay
            ELSE
                __GIFData(i).frame = __GIFData(i).frame + 1
                __GIFData(i).lastFrameServed = __GIFData(i).frame
                __GIFData(i).lastFrameUpdate = TIMER
            END IF
        END IF

        $IF INFORM_BI = DEFINED THEN
                BeginDraw ID
        $END IF

        newFrame = __GIF_GetFrame(i)
        IF newFrame THEN _PUTIMAGE , newFrame
        IF __GIFData(i).isPlaying = FALSE AND __GIFData(i).hideOverlay = FALSE AND __GIFData(i).totalFrames > 1 THEN
            _PUTIMAGE (_WIDTH / 2 - _WIDTH(GifOverlay) / 2, _HEIGHT / 2 - _HEIGHT(GifOverlay) / 2), GifOverlay
        END IF

        $IF INFORM_BI = DEFINED THEN
                EndDraw ID
        $END IF
    END SUB


    FUNCTION GIF_IsPlaying%% (ID AS LONG)
        SHARED __GIFData() AS __GIFDataType

        DIM i AS LONG: i = __GIF_GetIndex(ID)

        GIF_IsPlaying = __GIFData(i).isPlaying
    END FUNCTION


    FUNCTION GIF_GetWidth~% (ID AS LONG)
        SHARED __GIFData() AS __GIFDataType

        DIM i AS LONG: i = __GIF_GetIndex(ID)

        GIF_GetWidth = __GIFData(i).W
    END FUNCTION


    FUNCTION GIF_GetHeight~% (ID AS LONG)
        SHARED __GIFData() AS __GIFDataType

        DIM i AS LONG: i = __GIF_GetIndex(ID)

        GIF_GetHeight = __GIFData(i).H
    END FUNCTION


    FUNCTION GIF_GetTotalFrames~& (ID AS LONG)
        SHARED __GIFData() AS __GIFDataType

        DIM i AS LONG: i = __GIF_GetIndex(ID)
        GIF_GetTotalFrames = __GIFData(i).totalFrames
    END FUNCTION


    SUB GIF_HideOverlay (ID AS LONG)
        SHARED __GIFData() AS __GIFDataType

        DIM i AS LONG: i = __GIF_GetIndex(ID)

        __GIFData(i).hideOverlay = TRUE
    END SUB


    SUB GIF_Play (ID AS LONG)
        SHARED __GIFData() AS __GIFDataType

        DIM i AS LONG: i = __GIF_GetIndex(ID)

        __GIFData(i).isPlaying = TRUE
    END SUB


    SUB GIF_Pause (ID AS LONG)
        SHARED __GIFData() AS __GIFDataType

        DIM i AS LONG: i = __GIF_GetIndex(ID)

        __GIFData(i).isPlaying = FALSE
    END SUB


    SUB GIF_Stop (ID AS LONG)
        SHARED __GIFData() AS __GIFDataType

        DIM i AS LONG: i = __GIF_GetIndex(ID)

        __GIFData(i).isPlaying = FALSE
        __GIFData(i).frame = 1
    END SUB


    FUNCTION GIF_Open%% (ID AS LONG, filename$)
        SHARED __GIFData() AS __GIFDataType
        SHARED __GIFFrameData() AS __GIFFrameDataType
        SHARED __TotalGIFLoaded AS LONG, __TotalGIFFrames AS LONG

        DIM i AS LONG, Index AS LONG
        DIM byte~%%, palette$, delay~%

        $IF INFORM_BI = DEFINED THEN
                IF Control(ID).Type <> __UI_Type_PictureBox THEN ERROR 5: EXIT FUNCTION
        $END IF

        Index = __GIF_GetIndex(ID)

        IF Index = 0 THEN
            __TotalGIFLoaded = __TotalGIFLoaded + 1
            Index = __TotalGIFLoaded
            REDIM _PRESERVE __GIFData(1 TO __TotalGIFLoaded) AS __GIFDataType
        ELSE
            GIF_Close ID
        END IF

        __GIFData(Index).ID = ID
        __GIFData(Index).file = FREEFILE
        IF NOT _FILEEXISTS(filename$) THEN EXIT FUNCTION
        OPEN filename$ FOR BINARY AS __GIFData(Index).file

        GET __GIFData(Index).file, , __GIFData(Index).sigver
        GET __GIFData(Index).file, , __GIFData(Index).W
        GET __GIFData(Index).file, , __GIFData(Index).H
        GET __GIFData(Index).file, , byte~%%
        __GIFData(Index).bpp = (byte~%% AND 7) + 1
        __GIFData(Index).sortFlag = (byte~%% AND 8) > 0
        __GIFData(Index).colorRes = (byte~%% \ 16 AND 7) + 1
        __GIFData(Index).colorTableFlag = (byte~%% AND 128) > 0
        __GIFData(Index).numColors = 2 ^ __GIFData(Index).bpp
        GET __GIFData(Index).file, , __GIFData(Index).bgColor
        GET __GIFData(Index).file, , byte~%%
        IF byte~%% = 0 THEN __GIFData(Index).aspect = 0 ELSE __GIFData(Index).aspect = (byte~%% + 15) / 64

        IF __GIFData(Index).sigver <> "GIF87a" AND __GIFData(Index).sigver <> "GIF89a" THEN
            'Invalid version
            GOTO LoadError
        END IF

        IF NOT __GIFData(Index).colorTableFlag THEN
            'No Color Table
            GOTO LoadError
        END IF

        palette$ = SPACE$(3 * __GIFData(Index).numColors)
        GET __GIFData(Index).file, , palette$
        __GIFData(Index).pal = palette$
        DO
            GET __GIFData(Index).file, , byte~%%
            SELECT CASE byte~%%
                CASE &H2C ' Image Descriptor
                    __TotalGIFFrames = __TotalGIFFrames + 1
                    __GIFData(Index).totalFrames = __GIFData(Index).totalFrames + 1

                    IF __GIFData(Index).firstFrame = 0 THEN
                        __GIFData(Index).firstFrame = __TotalGIFFrames
                    END IF

                    IF __TotalGIFFrames > UBOUND(__GIFFrameData) THEN
                        REDIM _PRESERVE __GIFFrameData(0 TO __TotalGIFFrames * 2) AS __GIFFrameDataType
                    END IF

                    __GIFFrameData(__TotalGIFFrames).ID = ID
                    __GIFFrameData(__TotalGIFFrames).thisFrame = __GIFData(Index).totalFrames

                    GET __GIFData(Index).file, , __GIFFrameData(__TotalGIFFrames).L
                    GET __GIFData(Index).file, , __GIFFrameData(__TotalGIFFrames).T
                    GET __GIFData(Index).file, , __GIFFrameData(__TotalGIFFrames).W
                    GET __GIFData(Index).file, , __GIFFrameData(__TotalGIFFrames).H
                    GET __GIFData(Index).file, , byte~%%
                    __GIFFrameData(__TotalGIFFrames).localColorTableFlag = (byte~%% AND 128) > 0
                    __GIFFrameData(__TotalGIFFrames).interlacedFlag = (byte~%% AND 64) > 0
                    __GIFFrameData(__TotalGIFFrames).sortFlag = (byte~%% AND 32) > 0
                    __GIFFrameData(__TotalGIFFrames).palBPP = (byte~%% AND 7) + 1
                    __GIFFrameData(__TotalGIFFrames).addr = LOC(__GIFData(Index).file) + 1

                    IF __GIFFrameData(__TotalGIFFrames).localColorTableFlag THEN
                        SEEK __GIFData(Index).file, LOC(__GIFData(Index).file) + 3 * 2 ^ __GIFFrameData(__TotalGIFFrames).palBPP + 1
                    END IF
                    GET __GIFData(Index).file, , __GIFFrameData(__TotalGIFFrames).minimumCodeSize
                    IF __GIFFrameData(__TotalGIFFrames).disposalMethod > 2 THEN
                        'Unsupported disposalMethod
                        GOTO LoadError
                    END IF
                    __GIF_SkipBlocks __GIFData(Index).file
                CASE &H3B ' Trailer
                    EXIT DO
                CASE &H21 ' Extension Introducer
                    GET __GIFData(Index).file, , byte~%% ' Extension Label
                    SELECT CASE byte~%%
                        CASE &HFF, &HFE ' Application Extension, Comment Extension
                            __GIF_SkipBlocks __GIFData(Index).file
                        CASE &HF9
                            IF __TotalGIFFrames > UBOUND(__GIFFrameData) THEN
                                REDIM _PRESERVE __GIFFrameData(0 TO __TotalGIFFrames * 2) AS __GIFFrameDataType
                            END IF
                            __GIFFrameData(__TotalGIFFrames).ID = ID

                            GET __GIFData(Index).file, , byte~%% ' Block Size (always 4)
                            GET __GIFData(Index).file, , byte~%%
                            __GIFFrameData(__TotalGIFFrames).transparentFlag = (byte~%% AND 1) > 0
                            __GIFFrameData(__TotalGIFFrames).userInput = (byte~%% AND 2) > 0
                            __GIFFrameData(__TotalGIFFrames).disposalMethod = byte~%% \ 4 AND 7
                            GET __GIFData(Index).file, , delay~%
                            IF delay~% = 0 THEN __GIFFrameData(__TotalGIFFrames).delay = 0.1 ELSE __GIFFrameData(__TotalGIFFrames).delay = delay~% / 100
                            GET __GIFData(Index).file, , __GIFFrameData(__TotalGIFFrames).transColor
                            __GIF_SkipBlocks __GIFData(Index).file
                        CASE ELSE
                            'Unsupported extension Label
                            GOTO LoadError
                    END SELECT
                CASE ELSE
                    'Unsupported chunk
                    GOTO LoadError
            END SELECT
        LOOP

        REDIM _PRESERVE __GIFFrameData(0 TO __TotalGIFFrames) AS __GIFFrameDataType

        __GIFData(Index).isPlaying = FALSE
        GIF_Open = TRUE
        EXIT FUNCTION

        LoadError:
        __GIFData(Index).ID = 0
        CLOSE __GIFData(Index).file
        FOR i = 1 TO __TotalGIFFrames
            IF __GIFFrameData(i).ID = ID THEN
                __GIFFrameData(i).ID = 0
            END IF
        NEXT
    END FUNCTION


    FUNCTION __GIF_GetIndex& (ID AS LONG)
        SHARED __GIFData() AS __GIFDataType
        SHARED __TotalGIFLoaded AS LONG

        DIM i AS LONG: FOR i = 1 TO __TotalGIFLoaded
            IF __GIFData(i).ID = ID THEN
                __GIF_GetIndex = i
                EXIT FOR
            END IF
        NEXT i
    END FUNCTION


    SUB GIF_Close (ID AS LONG)
        SHARED __GIFData() AS __GIFDataType
        SHARED __GIFFrameData() AS __GIFFrameDataType

        DIM i AS LONG, Index AS LONG

        Index = __GIF_GetIndex(ID)

        IF Index = 0 THEN EXIT SUB

        FOR i = 0 TO UBOUND(__GIFFrameData)
            IF __GIFFrameData(i).ID = ID THEN
                __GIFFrameData(i).ID = 0
                IF __GIFFrameData(i).addr < -1 THEN
                    _FREEIMAGE __GIFFrameData(i).addr
                END IF
            END IF
        NEXT

        CLOSE __GIFData(Index).file
        __GIFData(Index).ID = 0
        __GIFData(Index).firstFrame = 0
    END SUB


    SUB __GIF_SkipBlocks (file AS INTEGER)
        DIM byte~%%
        DO
            GET file, , byte~%% ' Block Size
            SEEK file, LOC(file) + byte~%% + 1
        LOOP WHILE byte~%%
    END SUB


    FUNCTION __GIF_GetFrame& (Index AS LONG)
        SHARED __GIFData() AS __GIFDataType
        SHARED __GIFFrameData() AS __GIFFrameDataType

        DIM i AS LONG
        DIM frame AS LONG, previousFrame AS LONG
        DIM w AS INTEGER, h AS INTEGER
        DIM img&, actualFrame&
        DIM prevDest AS LONG

        IF __GIFData(Index).frame > __GIFData(Index).totalFrames THEN
            __GIFData(Index).frame = 1
        END IF

        FOR i = 1 TO UBOUND(__GIFFrameData)
            IF __GIFFrameData(i).ID = __GIFData(Index).ID AND __GIFFrameData(i).thisFrame = __GIFData(Index).frame THEN
                frame = i
                EXIT FOR
            ELSEIF __GIFFrameData(i).ID = __GIFData(Index).ID AND __GIFFrameData(i).thisFrame < __GIFData(Index).frame THEN
                previousFrame = i
            END IF
        NEXT

        __GIFData(Index).lastFrameDelay = __GIFFrameData(frame).delay - (__GIFFrameData(frame).delay / 10)

        IF __GIFFrameData(frame).addr > 0 THEN
            prevDest = _DEST
            w = __GIFFrameData(frame).W
            h = __GIFFrameData(frame).H
            img& = _NEWIMAGE(w, h, 256)
            actualFrame& = _NEWIMAGE(__GIFData(Index).W, __GIFData(Index).H, 256)

            _DEST img&
            __GIF_DecodeFrame __GIFData(Index), __GIFFrameData(frame)

            _DEST actualFrame&
            IF __GIFFrameData(frame).localColorTableFlag THEN
                _COPYPALETTE img&
            ELSE
                FOR i = 0 TO __GIFData(Index).numColors - 1
                    _PALETTECOLOR i, _RGB32(ASC(__GIFData(Index).pal, i * 3 + 1), ASC(__GIFData(Index).pal, i * 3 + 2), ASC(__GIFData(Index).pal, i * 3 + 3))
                NEXT
            END IF

            IF __GIFData(Index).frame > 1 THEN
                SELECT CASE __GIFFrameData(previousFrame).disposalMethod
                    CASE 0, 1
                        _PUTIMAGE , __GIFFrameData(previousFrame).addr
                    CASE 2
                        CLS , __GIFData(Index).bgColor
                        _CLEARCOLOR __GIFData(Index).bgColor
                END SELECT
            ELSE
                CLS , __GIFData(Index).bgColor
            END IF

            IF __GIFFrameData(frame).transparentFlag THEN
                _CLEARCOLOR __GIFFrameData(frame).transColor, img&
            END IF
            _PUTIMAGE (__GIFFrameData(frame).L, __GIFFrameData(frame).T), img&
            _FREEIMAGE img&

            __GIFFrameData(frame).addr = actualFrame&
            __GIFData(Index).loadedFrames = __GIFData(Index).loadedFrames + 1
            __GIFData(Index).isLoadComplete = (__GIFData(Index).loadedFrames = __GIFData(Index).totalFrames)
            _DEST prevDest
        END IF

        __GIF_GetFrame = __GIFFrameData(frame).addr
    END FUNCTION


    SUB __GIF_DecodeFrame (gifdata AS __GIFDataType, __GIfFRAMEDATA AS __GIFFrameDataType)
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

        IF __GIfFRAMEDATA.interlacedFlag THEN interlacedPass = 0: interlacedStep = 8
        bitPointer = 0
        blockSize = 0
        blockPointer = 0
        x = 0
        y = 0

        file = gifdata.file
        SEEK file, __GIfFRAMEDATA.addr

        IF __GIfFRAMEDATA.localColorTableFlag THEN
            palette$ = SPACE$(3 * 2 ^ __GIfFRAMEDATA.palBPP)
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
                IF x = __GIfFRAMEDATA.W THEN
                    x = 0
                    IF __GIfFRAMEDATA.interlacedFlag THEN
                        y = y + interlacedStep
                        IF y >= __GIfFRAMEDATA.H THEN
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


    FUNCTION __GIF_LoadOverlayImage&
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

        __GIF_LoadOverlayImage = _LOADIMAGE(Base64_LoadResourceString(DATA_GIFOVERLAYIMAGE_BMP_16506, SIZE_GIFOVERLAYIMAGE_BMP_16506, COMP_GIFOVERLAYIMAGE_BMP_16506), 32, "memory")
    END FUNCTION

    '$INCLUDE:'Base64.bas'

$END IF
