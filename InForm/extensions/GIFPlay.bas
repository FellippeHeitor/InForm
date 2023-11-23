'-----------------------------------------------------------------------------------------------------------------------
' Animated GIF Player library
' Copyright (c) 2023 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$IF GIFPLAY_BAS = UNDEFINED THEN
    $LET GIFPLAY_BAS = TRUE

    '$INCLUDE:'GIFPlay.bi'

    ' This is an internal loading function common for both memory and file loaders
    FUNCTION __GIF_Load%% (Id AS LONG, sf AS StringFileType)
    END FUNCTION

    ' Opens a GIF file from a buffer in memory
    FUNCTION GIF_LoadFromMemory%% (Id AS LONG, buffer AS STRING)
        _MESSAGEBOX , "GIF_LoadFromMemory%%"

        DIM sf AS StringFileType

        StringFile_Create sf, buffer

        GIF_LoadFromMemory = __GIF_Load(Id, sf)
    END FUNCTION


    ' Opens a GIF file from a file on disk
    FUNCTION GIF_LoadFromFile%% (Id AS LONG, fileName AS STRING)
        _MESSAGEBOX STR$(Id), "GIF_LoadFromFile%%"

        DIM sf AS StringFileType

        IF StringFile_Load(sf, fileName) THEN
            GIF_LoadFromFile = __GIF_Load(Id, sf)
        END IF
    END FUNCTION


    ' Free a GIF and all associated resources
    SUB GIF_Free (Id AS LONG)
        _MESSAGEBOX STR$(Id), "GIF_Free"
    END SUB


    ' Returns the width of the animation in pixels
    FUNCTION GIF_GetWidth~% (Id AS LONG)
        _MESSAGEBOX STR$(Id), "GIF_LoadFromFile%%"

        SHARED __GIFPlayHashTable() AS HashTableType
        SHARED __GIFPlay() AS __GIFPlayType

        GIF_GetWidth = __GIFPlay(HashTable_LookupLong(__GIFPlayHashTable(), Id)).W
    END FUNCTION


    ' Returns the height of the animation in pixels
    FUNCTION GIF_GetHeight~% (Id AS LONG)
        _MESSAGEBOX STR$(Id), "GIF_GetHeight~%"

        SHARED __GIFPlayHashTable() AS HashTableType
        SHARED __GIFPlay() AS __GIFPlayType

        GIF_GetHeight = __GIFPlay(HashTable_LookupLong(__GIFPlayHashTable(), Id)).H
    END FUNCTION


    ' Returns the number of currently playing frame
    FUNCTION GIF_GetCurrentFrame~& (Id AS LONG)
        _MESSAGEBOX STR$(Id), "GIF_GetCurrentFrame~&"

        SHARED __GIFPlayHashTable() AS HashTableType
        SHARED __GIFPlay() AS __GIFPlayType

        GIF_GetCurrentFrame = __GIFPlay(HashTable_LookupLong(__GIFPlayHashTable(), Id)).currentFrameNumber
    END FUNCTION


    ' Returns the total frames in the GIF. If this is 1 then it is a static image
    FUNCTION GIF_GetTotalFrames~& (Id AS LONG)
        _MESSAGEBOX STR$(Id), "GIF_GetTotalFrames~&"

        SHARED __GIFPlayHashTable() AS HashTableType
        SHARED __GIFPlay() AS __GIFPlayType

        GIF_GetTotalFrames = __GIFPlay(HashTable_LookupLong(__GIFPlayHashTable(), Id)).totalFrames
    END FUNCTION


    ' Sets the playback direction. direction should be -1 or 1
    SUB GIF_SetPlaybackDirection (Id AS LONG, direction AS _BYTE)
        _MESSAGEBOX STR$(Id), "GIF_SetPlaybackDirection"

        SHARED __GIFPlayHashTable() AS HashTableType
        SHARED __GIFPlay() AS __GIFPlayType

        IF direction <> 0 THEN __GIFPlay(HashTable_LookupLong(__GIFPlayHashTable(), Id)).direction = SGN(direction)
    END SUB


    ' Gets the current playback direction. This can be -1 or 1
    FUNCTION GIF_GetPlaybackDirection%% (Id AS LONG)
        _MESSAGEBOX STR$(Id), "GIF_GetPlaybackDirection%%"

        SHARED __GIFPlayHashTable() AS HashTableType
        SHARED __GIFPlay() AS __GIFPlayType

        GIF_GetPlaybackDirection = __GIFPlay(HashTable_LookupLong(__GIFPlayHashTable(), Id)).direction
    END FUNCTION


    ' Resume or starts playback
    SUB GIF_Play (Id AS LONG)
        _MESSAGEBOX STR$(Id), "GIF_Play"

        SHARED __GIFPlayHashTable() AS HashTableType
        SHARED __GIFPlay() AS __GIFPlayType

        __GIFPlay(HashTable_LookupLong(__GIFPlayHashTable(), Id)).isPlaying = TRUE
    END SUB


    ' Pauses playback. That same frame is served as long as playback is paused
    SUB GIF_Pause (Id AS LONG)
        _MESSAGEBOX STR$(Id), "GIF_Pause"

        SHARED __GIFPlayHashTable() AS HashTableType
        SHARED __GIFPlay() AS __GIFPlayType

        __GIFPlay(HashTable_LookupLong(__GIFPlayHashTable(), Id)).isPlaying = FALSE
    END SUB


    ' Stops playing the GIF and resets the cursor to the first frame
    SUB GIF_Stop (Id AS LONG)
        _MESSAGEBOX STR$(Id), "GIF_Stop"

        SHARED __GIFPlayHashTable() AS HashTableType
        SHARED __GIFPlay() AS __GIFPlayType

        DIM idx AS LONG: idx = HashTable_LookupLong(__GIFPlayHashTable(), Id)

        __GIFPlay(idx).isPlaying = FALSE
        __GIFPlay(idx).currentFrame = __GIFPlay(idx).firstFrame
    END SUB


    ' Return True if GIF is currently playing
    FUNCTION GIF_IsPlaying%% (Id AS LONG)
        _MESSAGEBOX STR$(Id), "GIF_IsPlaying%%"

        SHARED __GIFPlayHashTable() AS HashTableType
        SHARED __GIFPlay() AS __GIFPlayType

        GIF_IsPlaying = __GIFPlay(HashTable_LookupLong(__GIFPlayHashTable(), Id)).isPlaying
    END FUNCTION


    ' This draws the current frame on the destination surface @ (0, 0) (stretching the frame if needed)
    ' This will also draw the overlay if the playback is stopped / paused
    SUB GIF_Draw (Id AS LONG, shouldStretch AS _BYTE)
        ' TODO
    END SUB


    ' This draws the current frame at the specified x, y location on the destination surface (preserving aspect ratio)
    ' This will also draw the overlay if the playback is stopped / paused
    SUB GIF_DrawAt (Id AS LONG, x AS LONG, y AS LONG)
        _MESSAGEBOX STR$(Id), "GIF_DrawAt"
    END SUB


    ' This returns the current frame (QB64 image) to be played
    ' Playback is time sensitive so frames may be skipped or the last frame maybe returned
    ' Only use this if you want to do your own rendering
    ' Also do not free the image. The library will do that when it is no longer needed
    FUNCTION GIF_GetFrame& (Id AS LONG)
        _MESSAGEBOX STR$(Id), "GIF_GetFrame&"
    END FUNCTION


    ' Sets the GIF overlay to enable / disable
    SUB GIF_EnableOverlay (Id AS LONG, isEnabled AS _BYTE)
        _MESSAGEBOX STR$(Id), "GIF_EnableOverlay"

        SHARED __GIFPlayHashTable() AS HashTableType
        SHARED __GIFPlay() AS __GIFPlayType

        __GIFPlay(HashTable_LookupLong(__GIFPlayHashTable(), Id)).overlayEnabled = isEnabled
    END SUB


    ' Returns TRUE if a GIF with Id is loaded
    FUNCTION GIF_IsLoaded%% (Id AS LONG)
        SHARED __GIFPlayHashTable() AS HashTableType

        GIF_IsLoaded = HashTable_IsKeyPresent(__GIFPlayHashTable(), Id)
    END FUNCTION


    SUB __GIF_CreateBitmap (bmp AS __GIFBitmapType, w AS LONG, h AS LONG)
        bmp.W = w
        bmp.H = h
        bmp.pixels = STRING$(w * h, 0)
    END SUB


    SUB __GIF_BlitBitmap (src AS __GIFBitmapType, dst AS __GIFBitmapType, srcX AS LONG, srcY AS LONG, dstX AS LONG, dstY AS LONG, bW AS LONG, bH AS LONG)
        IF bW <= 0 OR bH <= 0 THEN EXIT SUB

        DIM AS LONG w, xs, xd: w = bW: xs = srcX: xd = dstX
        DIM AS LONG h, ys, yd: h = bH: ys = srcY: yd = dstY

        IF xs < 0 THEN
            w = w + xs
            xd = xd - xs
            xs = 0
        END IF
        IF ys < 0 THEN
            h = h + ys
            yd = yd - ys
            ys = 0
        END IF

        IF xs + w > src.W THEN w = src.W - xs
        IF ys + h > src.H THEN h = src.H - ys

        IF xd < 0 THEN
            w = w + xd
            xs = xs - xd
            xd = 0
        END IF
        IF yd < 0 THEN
            h = h + yd
            ys = ys - yd
            yd = 0
        END IF

        IF xd + w > dst.W THEN w = dst.W - xd
        IF yd + h > dst.H THEN h = dst.H - yd

        IF w <= 0 OR h <= 0 THEN EXIT SUB

        DIM ps AS LONG: ps = 1 + ys * src.W
        DIM pd AS LONG: pd = 1 + yd * dst.W
        DIM i AS LONG: FOR i = 1 TO h
            MID$(dst.pixels, pd + xd, w) = MID$(src.pixels, ps + xs, w)
            ps = ps + src.W
            pd = pd + dst.W
        NEXT i
    END SUB


    FUNCTION __GIF_ReadLZWCode& (sf AS StringFileType, buffer AS STRING, bitPos AS LONG, bitSize AS LONG)
        DIM code AS LONG, p AS LONG: p = 1

        DIM i AS LONG: FOR i = 1 TO bitSize
            DIM bytePos AS LONG: bytePos = _SHR(bitPos, 3) AND 255

            IF bytePos = 0 THEN
                DIM dataLen AS LONG: dataLen = StringFile_ReadByte(sf)

                IF dataLen = 0 THEN
                    __GIF_ReadLZWCode = -1
                    EXIT FUNCTION
                END IF

                MID$(buffer, 257 - dataLen) = StringFile_ReadString(sf, dataLen)

                bytePos = 256 - dataLen
                bitPos = _SHL(bytePos, 3)
            END IF

            IF ASC(buffer, 1 + bytePos) AND _SHL(1, (bitPos AND 7)) THEN code = code + p

            p = p + p
            bitPos = bitPos + 1
        NEXT i

        __GIF_ReadLZWCode = code
    END FUNCTION


    FUNCTION __GIF_DecodeLZW& (sf AS StringFileType, bmp AS __GIFBitmapType)
        TYPE __LZWCodeType
            prefix AS LONG
            c AS LONG
            ln AS LONG
        END TYPE

        DIM codes(0 TO 4095) AS __LZWCodeType

        DIM origBitSize AS LONG: origBitSize = StringFile_ReadByte(sf)
        DIM n AS LONG: n = 2 + _SHL(1, origBitSize)

        DIM i AS LONG: WHILE i < n
            codes(i).c = i
            codes(i).ln = 0
            i = i + 1
        WEND

        DIM clearMarker AS LONG: clearMarker = n - 2
        DIM endMarker AS LONG: endMarker = n - 1

        DIM buffer AS STRING: buffer = SPACE$(256)
        DIM bitSize AS LONG: bitSize = origBitSize + 1
        DIM bitPos AS LONG

        DIM prev AS LONG: prev = __GIF_ReadLZWCode(sf, buffer, bitPos, bitSize)
        IF prev = -1 THEN
            __GIF_DecodeLZW = -1
            EXIT FUNCTION
        END IF

        DO
            DIM code AS LONG: code = __GIF_ReadLZWCode(sf, buffer, bitPos, bitSize)
            IF code = -1 THEN
                __GIF_DecodeLZW = -1
                EXIT FUNCTION
            END IF

            IF code = clearMarker THEN
                bitSize = origBitSize
                n = _SHL(1, bitSize)
                n = n + 2
                bitSize = bitSize + 1
                prev = code
                _CONTINUE
            END IF

            IF code = endMarker THEN EXIT DO

            DIM c AS LONG: IF code < n THEN c = code ELSE c = prev

            DIM outPos AS LONG: outPos = outPos + codes(c).ln
            i = 0

            DO
                ASC(bmp.pixels, 1 + outPos - i) = codes(c).c

                IF codes(c).ln THEN
                    c = codes(c).prefix
                ELSE
                    EXIT DO
                END IF

                i = i + 1
            LOOP

            outPos = outPos + 1

            IF code >= n THEN
                ASC(bmp.pixels, 1 + outPos) = codes(c).c
                outPos = outPos + 1
            END IF

            IF prev <> clearMarker THEN
                codes(n).prefix = prev
                codes(n).ln = codes(prev).ln + 1
                codes(n).c = codes(c).c
                n = n + 1
            END IF

            IF _SHL(1, bitSize) = n THEN
                IF bitSize < 12 THEN bitSize = bitSize + 1
            END IF

            prev = code
        LOOP
    END FUNCTION


    ' This load the GIF overload image
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

        STATIC overlayImage AS LONG

        ' Only do this once
        IF overlayImage = 0 THEN
            overlayImage = _LOADIMAGE(Base64_LoadResourceString(DATA_GIFOVERLAYIMAGE_BMP_16506, SIZE_GIFOVERLAYIMAGE_BMP_16506, COMP_GIFOVERLAYIMAGE_BMP_16506), 32, "memory")
        END IF

        __GIF_LoadOverlayImage = overlayImage
    END FUNCTION

    '$INCLUDE:'HashTable.bas'
    '$INCLUDE:'StringFile.bas'
    '$INCLUDE:'Base64.bas'

$END IF
