'-----------------------------------------------------------------------------------------------------------------------
' Animated GIF Player library
' Copyright (c) 2023 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$IF GIFPLAY_BAS = UNDEFINED THEN
    $LET GIFPLAY_BAS = TRUE

    '$INCLUDE:'GIFPlay.bi'

    '-------------------------------------------------------------------------------------------------------------------
    ' Test code for debugging the library
    '-------------------------------------------------------------------------------------------------------------------
    '$RESIZE:SMOOTH
    '$CONSOLE

    'DEFLNG A-Z
    'OPTION _EXPLICIT
    'CONST FALSE = 0, TRUE = NOT FALSE

    'CONST GIF_ID = 1

    'DO
    '    DIM gifFileName AS STRING: gifFileName = _OPENFILEDIALOG$("Open GIF", , "*.gif|*.GIF|*.Gif", "GIF Files")
    '    IF LEN(gifFileName) = 0 THEN EXIT DO

    '    IF GIF_LoadFromFile(GIF_ID, gifFileName) THEN
    '        DIM surface AS LONG: surface = _NEWIMAGE(GIF_GetWidth(GIF_ID), GIF_GetHeight(GIF_ID), 32)
    '        SCREEN surface
    '        _ALLOWFULLSCREEN _SQUAREPIXELS , _SMOOTH

    '        GIF_Play GIF_ID

    '        DO
    '            DIM k AS LONG: k = _KEYHIT

    '            IF k = 32 THEN
    '                IF GIF_IsPlaying(GIF_ID) THEN GIF_Pause (GIF_ID) ELSE GIF_Play (GIF_ID)
    '            END IF

    '            CLS
    '            GIF_Draw GIF_ID
    '            _DISPLAY

    '            _LIMIT 30
    '        LOOP UNTIL k = 27

    '        SCREEN 0
    '        _FREEIMAGE surface
    '    END IF
    'LOOP

    'END
    '-------------------------------------------------------------------------------------------------------------------

    ' Opens a GIF file from a buffer in memory
    FUNCTION GIF_LoadFromMemory%% (Id AS LONG, buffer AS STRING)
        $IF INFORM_BI = DEFINED THEN
                IF Control(ID).Type <> __UI_Type_PictureBox THEN
                ERROR 5
                EXIT FUNCTION
                END IF
        $END IF

        DIM sf AS StringFileType

        StringFile_Create sf, buffer

        GIF_LoadFromMemory = __GIF_Load(Id, sf)
    END FUNCTION


    ' Opens a GIF file from a file on disk
    FUNCTION GIF_LoadFromFile%% (Id AS LONG, fileName AS STRING)
        $IF INFORM_BI = DEFINED THEN
                IF Control(ID).Type <> __UI_Type_PictureBox THEN
                ERROR 5
                EXIT FUNCTION
                END IF
        $END IF

        DIM sf AS StringFileType

        IF StringFile_Load(sf, fileName) THEN
            GIF_LoadFromFile = __GIF_Load(Id, sf)
        END IF
    END FUNCTION


    ' Free a GIF and all associated resources
    SUB GIF_Free (Id AS LONG)
        SHARED __GIFPlayHashTable() AS HashTableType
        SHARED __GIFPlay() AS __GIFPlayType
        SHARED __GIFPlayFrame() AS __GIFPlayFrameType
        SHARED __GIF_FirstFreeFrame AS LONG

        ' Get the slot we need to free
        DIM idx AS LONG: idx = HashTable_LookupLong(__GIFPlayHashTable(), Id)

        ' Walk the whole animation chain to free all the frames and associated data
        __GIFPlay(idx).frame = __GIFPlay(idx).firstFrame

        DO
            ' Free the image being held by the frame
            IF __GIFPlayFrame(__GIFPlay(idx).frame).image < -1 THEN
                _FREEIMAGE __GIFPlayFrame(__GIFPlay(idx).frame).image
                __GIFPlayFrame(__GIFPlay(idx).frame).image = 0
            END IF

            ' Mark the frame slot as unused so that it can be reused
            __GIFPlayFrame(__GIFPlay(idx).frame).isUsed = FALSE

            ' Note the lowest free frame
            IF __GIF_FirstFreeFrame > __GIFPlay(idx).frame THEN __GIF_FirstFreeFrame = __GIFPlay(idx).frame

            ' Move to the next frame
            __GIFPlay(idx).frame = __GIFPlayFrame(__GIFPlay(idx).frame).nextFrame
        LOOP UNTIL __GIFPlay(idx).frame = __GIFPlay(idx).firstFrame ' loop until we come back to the first frame

        ' Free the rendered image
        IF __GIFPlay(idx).image < -1 THEN
            _FREEIMAGE __GIFPlay(idx).image
            __GIFPlay(idx).image = 0
        END IF

        ' Free the saved rendered image
        IF __GIFPlay(idx).savedImage < -1 THEN
            _FREEIMAGE __GIFPlay(idx).savedImage
            __GIFPlay(idx).savedImage = 0
        END IF

        ' Finally mark the GIF slot as unused so that it can be reused
        __GIFPlay(idx).isUsed = FALSE

        ' Remove Id from the hash table
        HashTable_Remove __GIFPlayHashTable(), Id
    END SUB


    ' Returns the width of the animation in pixels
    FUNCTION GIF_GetWidth~& (Id AS LONG)
        SHARED __GIFPlayHashTable() AS HashTableType
        SHARED __GIFPlay() AS __GIFPlayType

        GIF_GetWidth = _WIDTH(__GIFPlay(HashTable_LookupLong(__GIFPlayHashTable(), Id)).image)
    END FUNCTION


    ' Returns the height of the animation in pixels
    FUNCTION GIF_GetHeight~& (Id AS LONG)
        SHARED __GIFPlayHashTable() AS HashTableType
        SHARED __GIFPlay() AS __GIFPlayType

        GIF_GetHeight = _HEIGHT(__GIFPlay(HashTable_LookupLong(__GIFPlayHashTable(), Id)).image)
    END FUNCTION


    ' Returns the number of currently playing frame
    FUNCTION GIF_GetFrameNumber~& (Id AS LONG)
        SHARED __GIFPlayHashTable() AS HashTableType
        SHARED __GIFPlay() AS __GIFPlayType

        GIF_GetFrameNumber = __GIFPlay(HashTable_LookupLong(__GIFPlayHashTable(), Id)).frameNumber
    END FUNCTION


    ' Returns the total frames in the GIF. If this is 1 then it is a static image
    FUNCTION GIF_GetTotalFrames~& (Id AS LONG)
        SHARED __GIFPlayHashTable() AS HashTableType
        SHARED __GIFPlay() AS __GIFPlayType

        GIF_GetTotalFrames = __GIFPlay(HashTable_LookupLong(__GIFPlayHashTable(), Id)).frameCount
    END FUNCTION


    ' Resume or starts playback
    SUB GIF_Play (Id AS LONG)
        SHARED __GIFPlayHashTable() AS HashTableType
        SHARED __GIFPlay() AS __GIFPlayType

        DIM idx AS LONG: idx = HashTable_LookupLong(__GIFPlayHashTable(), Id)

        __GIFPlay(idx).isPlaying = TRUE
        __GIFPlay(idx).lastTick = __GIF_GetTicks
    END SUB


    ' Pauses playback. That same frame is served as long as playback is paused
    SUB GIF_Pause (Id AS LONG)
        SHARED __GIFPlayHashTable() AS HashTableType
        SHARED __GIFPlay() AS __GIFPlayType

        __GIFPlay(HashTable_LookupLong(__GIFPlayHashTable(), Id)).isPlaying = FALSE
    END SUB


    ' Stops playing the GIF and resets the cursor to the first frame
    SUB GIF_Stop (Id AS LONG)
        SHARED __GIFPlayHashTable() AS HashTableType
        SHARED __GIFPlay() AS __GIFPlayType

        DIM idx AS LONG: idx = HashTable_LookupLong(__GIFPlayHashTable(), Id)

        __GIFPlay(idx).isPlaying = FALSE
        __GIFPlay(idx).frame = __GIFPlay(idx).firstFrame
        __GIFPlay(idx).frameNumber = 0
        __GIFPlay(idx).loopCounter = 0
    END SUB


    ' Return True if GIF is currently playing
    FUNCTION GIF_IsPlaying%% (Id AS LONG)
        SHARED __GIFPlayHashTable() AS HashTableType
        SHARED __GIFPlay() AS __GIFPlayType

        GIF_IsPlaying = __GIFPlay(HashTable_LookupLong(__GIFPlayHashTable(), Id)).isPlaying
    END FUNCTION


    ' This draws the current frame on the destination surface @ (0, 0) (stretching the frame if needed)
    ' This will also draw the overlay if the playback is stopped / paused
    SUB GIF_Draw (Id AS LONG)
        SHARED __GIFPlayHashTable() AS HashTableType
        SHARED __GIFPlay() AS __GIFPlayType

        $IF INFORM_BI = DEFINED THEN
                BeginDraw ID
        $END IF

        ' Get the rendered image handle
        DIM renderedFrame AS LONG: renderedFrame = GIF_GetFrame(Id)

        ' Blit the rendered frame
        _PUTIMAGE , renderedFrame

        DIM idx AS LONG: idx = HashTable_LookupLong(__GIFPlayHashTable(), Id)

        ' Render the overlay if needed
        IF NOT __GIFPlay(idx).isPlaying AND __GIFPlay(idx).overlayEnabled AND __GIFPlay(idx).frameCount > 1 THEN
            DIM overlayImage AS LONG: overlayImage = __GIF_GetOverlayImage

            _PUTIMAGE (_SHR(_WIDTH, 1) - _SHR(_WIDTH(overlayImage), 1), _SHR(_HEIGHT, 1) - _SHR(_HEIGHT(overlayImage), 1)), overlayImage
        END IF

        $IF INFORM_BI = DEFINED THEN
                EndDraw ID
        $END IF
    END SUB


    ' This returns the current rendered frame (QB64 image) to be played
    ' Playback is time sensitive so frames may be skipped or the last frame may be returned
    ' Use this if you want to do your own rendering
    ' Also do not free the image. The library will do that when it is no longer needed
    FUNCTION GIF_GetFrame& (Id AS LONG)
        SHARED __GIFPlayHashTable() AS HashTableType
        SHARED __GIFPlay() AS __GIFPlayType
        SHARED __GIFPlayFrame() AS __GIFPlayFrameType

        ' Cache the GIF index because we'll be using this a lot
        DIM idx AS LONG: idx = HashTable_LookupLong(__GIFPlayHashTable(), Id)

        ' Always return the rendered image handle (since this does not change during the GIFs lifetime)
        GIF_GetFrame = __GIFPlay(idx).image

        ' Exit if we are paused
        IF NOT __GIFPlay(idx).isPlaying THEN EXIT FUNCTION

        ' Exit if we finished a single or the specified number of loops
        IF __GIFPlay(idx).loops <> 0 AND (__GIFPlay(idx).loopCounter < 0 OR __GIFPlay(idx).loopCounter >= __GIFPlay(idx).loops) THEN EXIT FUNCTION

        ' Fetch and store the current tick
        DIM currentTick AS _UNSIGNED _INTEGER64: currentTick = __GIF_GetTicks

        ' Remember the last frame index
        DIM lastFrameRendered AS LONG: lastFrameRendered = __GIFPlay(idx).frame

        ' Walk through the animation chain and find the frame we have to render based on the tick we recorded the last time
        DO UNTIL currentTick < __GIFPlay(idx).lastTick + __GIFPlayFrame(__GIFPlay(idx).frame).duration
            ' Add the current frame duration to the lastTick so that we can do frame skips if needed
            __GIFPlay(idx).lastTick = __GIFPlay(idx).lastTick + __GIFPlayFrame(__GIFPlay(idx).frame).duration
            ' We cross the duration of the current frame, so move to the next one
            __GIFPlay(idx).frame = __GIFPlayFrame(__GIFPlay(idx).frame).nextFrame ' this should correctly loop back to the first frame
            ' Increment the frame counter and loop back to 0 if needed
            __GIFPlay(idx).frameNumber = __GIFPlay(idx).frameNumber + 1
            IF __GIFPlay(idx).frameNumber >= __GIFPlay(idx).frameCount THEN
                __GIFPlay(idx).frameNumber = 0
                __GIFPlay(idx).loopCounter = __GIFPlay(idx).loopCounter + 1

                IF __GIFPlay(idx).loops < 0 THEN __GIFPlay(idx).loopCounter = -1 ' single-shot animation
            END IF
        LOOP

        ' If the last frame rendered is the same as the current frame then just return the previously rendered frame image
        IF __GIFPlay(idx).frame = __GIFPlay(idx).lastFrameRendered THEN EXIT FUNCTION

        ' We now have the frame to display, so save the currentTick and update lastFrameRendered
        __GIFPlay(idx).lastTick = currentTick
        __GIFPlay(idx).lastFrameRendered = lastFrameRendered

        ' Take appropriate action based on the disposal method of the previous frame
        IF __GIFPlay(idx).frame = __GIFPlay(idx).firstFrame THEN
            ' If this is the first frame, then we do not have any previous disposal method
            CLS , __GIFPlay(idx).bgColor, __GIFPlay(idx).image ' clear the render image using the BG color
        ELSE
            SELECT CASE __GIFPlayFrame(__GIFPlayFrame(__GIFPlay(idx).frame).prevFrame).disposalMethod
                CASE 2 ' Restore to background color
                    CLS , __GIFPlay(idx).bgColor, __GIFPlay(idx).image
                    _CLEARCOLOR __GIFPlay(idx).bgColor, __GIFPlay(idx).image

                CASE 3 ' Restore to previous
                    IF __GIFPlay(idx).hasSavedImage THEN
                        ' Copy back the saved image and unset the flag
                        _PUTIMAGE , __GIFPlay(idx).savedImage, __GIFPlay(idx).image
                        __GIFPlay(idx).hasSavedImage = FALSE
                    END IF

                    ' All other disposal methods do not require any action
            END SELECT
        END IF

        ' If the current frame's disposal method is 3 (restore to previous) then save the current rendered frame and set the flag
        IF __GIFPlayFrame(__GIFPlay(idx).frame).disposalMethod = 3 THEN
            _PUTIMAGE , __GIFPlay(idx).image, __GIFPlay(idx).savedImage
            __GIFPlay(idx).hasSavedImage = TRUE
        END IF

        ' Render the frame at the correct (x, y) offset on the final image
        _PUTIMAGE (__GIFPlayFrame(__GIFPlay(idx).frame).L, __GIFPlayFrame(__GIFPlay(idx).frame).T), __GIFPlayFrame(__GIFPlay(idx).frame).image, __GIFPlay(idx).image
    END FUNCTION


    ' Returns the total runtime of the animation in ms
    FUNCTION GIF_GetTotalDuration~&& (Id AS LONG)
        SHARED __GIFPlayHashTable() AS HashTableType
        SHARED __GIFPlay() AS __GIFPlayType

        GIF_GetTotalDuration = __GIFPlay(HashTable_LookupLong(__GIFPlayHashTable(), Id)).duration
    END FUNCTION


    ' Returns the total runtime of the current frame in ms
    FUNCTION GIF_GetFrameDuration~&& (Id AS LONG)
        SHARED __GIFPlayHashTable() AS HashTableType
        SHARED __GIFPlay() AS __GIFPlayType
        SHARED __GIFPlayFrame() AS __GIFPlayFrameType

        GIF_GetFrameDuration = __GIFPlayFrame(__GIFPlay(HashTable_LookupLong(__GIFPlayHashTable(), Id)).frame).duration
    END FUNCTION


    ' Set the looping behavior
    SUB GIF_SetLoop (Id AS LONG, loops AS LONG)
        SHARED __GIFPlayHashTable() AS HashTableType
        SHARED __GIFPlay() AS __GIFPlayType

        __GIFPlay(HashTable_LookupLong(__GIFPlayHashTable(), Id)).loops = loops
    END SUB


    ' Sets the GIF overlay to enable / disable
    SUB GIF_EnableOverlay (Id AS LONG, isEnabled AS _BYTE)
        SHARED __GIFPlayHashTable() AS HashTableType
        SHARED __GIFPlay() AS __GIFPlayType

        __GIFPlay(HashTable_LookupLong(__GIFPlayHashTable(), Id)).overlayEnabled = isEnabled
    END SUB


    ' Returns TRUE if a GIF with Id is loaded
    FUNCTION GIF_IsLoaded%% (Id AS LONG)
        SHARED __GIFPlayHashTable() AS HashTableType

        GIF_IsLoaded = HashTable_IsKeyPresent(__GIFPlayHashTable(), Id)
    END FUNCTION


    ' Deinterlaces a raw GIF frame
    SUB __GIF_DeinterlaceFrameImage (bmp AS LONG)
        DIM W AS LONG: W = _WIDTH(bmp)
        DIM H AS LONG: H = _HEIGHT(bmp)
        DIM MX AS LONG: MX = W - 1
        DIM n AS LONG: n = _NEWIMAGE(W, H, 256)

        DIM AS LONG y, i

        WHILE y < H
            _PUTIMAGE (0, y), bmp, n, (0, i)-(MX, i)
            i = i + 1
            y = y + 8
        WEND

        y = 4
        WHILE y < H
            _PUTIMAGE (0, y), bmp, n, (0, i)-(MX, i)
            i = i + 1
            y = y + 8
        WEND

        y = 2
        WHILE y < H
            _PUTIMAGE (0, y), bmp, n, (0, i)-(MX, i)
            i = i + 1
            y = y + 4
        WEND

        y = 1
        WHILE y < H
            _PUTIMAGE (0, y), bmp, n, (0, i)-(MX, i)
            i = i + 1
            y = y + 2
        WEND

        _PUTIMAGE , n, bmp
        _FREEIMAGE n
    END SUB


    FUNCTION __GIF_ReadLZWCode& (sf AS StringFileType, buffer AS STRING, bitPos AS LONG, bitSize AS LONG)
        DIM AS LONG code, p: p = 1

        DIM i AS LONG: FOR i = 1 TO bitSize
            DIM bytePos AS LONG: bytePos = _SHR(bitPos, 3) AND 255

            IF bytePos = 0 THEN
                DIM dataLen AS LONG: dataLen = StringFile_ReadByte(sf)

                IF dataLen = 0 THEN
                    __GIF_ReadLZWCode = -1
                    EXIT FUNCTION
                END IF

                MID$(buffer, 257 - dataLen, dataLen) = StringFile_ReadString(sf, dataLen)

                bytePos = 256 - dataLen
                bitPos = _SHL(bytePos, 3)
            END IF

            IF ASC(buffer, 1 + bytePos) AND _SHL(1, bitPos AND 7) THEN code = code + p

            p = p + p
            bitPos = bitPos + 1
        NEXT i

        __GIF_ReadLZWCode = code
    END FUNCTION


    FUNCTION __GIF_DecodeLZW%% (sf AS StringFileType, bmpMem AS _MEM)
        TYPE __LZWCodeType
            c AS LONG
            prefix AS LONG
            length AS LONG
        END TYPE

        DIM codes(0 TO 4095) AS __LZWCodeType ' maximum bit size is 12

        DIM origBitSize AS LONG: origBitSize = StringFile_ReadByte(sf)
        DIM n AS LONG: n = 2 + _SHL(1, origBitSize)

        DIM i AS LONG: WHILE i < n
            codes(i).c = i
            codes(i).length = 0
            i = i + 1
        WEND

        DIM clearMarker AS LONG: clearMarker = n - 2
        DIM endMarker AS LONG: endMarker = n - 1

        DIM buffer AS STRING: buffer = SPACE$(256)
        DIM bitSize AS LONG: bitSize = origBitSize + 1
        DIM bitPos AS LONG

        ' Expect to read clear code as first code here
        DIM prev AS LONG: prev = __GIF_ReadLZWCode(sf, buffer, bitPos, bitSize)
        IF prev = -1 THEN EXIT FUNCTION

        DO
            DIM code AS LONG: code = __GIF_ReadLZWCode(sf, buffer, bitPos, bitSize)
            IF code = -1 THEN EXIT FUNCTION

            IF code = clearMarker THEN
                bitSize = origBitSize
                n = _SHL(1, bitSize) + 2
                bitSize = bitSize + 1
                prev = code
                _CONTINUE
            END IF

            IF code = endMarker THEN EXIT DO

            ' Known code: ok. Else: must be doubled char
            DIM c AS LONG: IF code < n THEN c = code ELSE c = prev

            ' Output the code
            DIM outPos AS LONG: outPos = outPos + codes(c).length

            i = 0
            DO
                _MEMPUT bmpMem, bmpMem.OFFSET + outPos - i, codes(c).c AS _UNSIGNED _BYTE

                IF codes(c).length <> 0 THEN
                    c = codes(c).prefix
                ELSE
                    EXIT DO
                END IF

                i = i + 1
            LOOP

            outPos = outPos + 1

            ' Unknown code -> must be double char
            IF code >= n THEN
                _MEMPUT bmpMem, bmpMem.OFFSET + outPos, codes(c).c AS _UNSIGNED _BYTE
                outPos = outPos + 1
            END IF

            ' Except after clear marker, build new code
            IF prev <> clearMarker THEN
                codes(n).prefix = prev
                codes(n).length = codes(prev).length + 1
                codes(n).c = codes(c).c
                n = n + 1
            END IF

            ' Out of bits? Increase
            IF _SHL(1, bitSize) = n THEN
                IF bitSize < 12 THEN bitSize = bitSize + 1
            END IF

            prev = code
        LOOP

        __GIF_DecodeLZW = TRUE
    END FUNCTION


    ' This applies the palette and transparency to a raw GIF frame image
    ' info - the GIF global and local frame data needed to prepare the frame image
    ' bmp - the raw frame image
    SUB __GIF_PrepareFrameImage (info AS __GIFFrameType, bmp AS LONG)
        ' Set the 8-bit image palette
        DIM AS LONG x, y
        IF info.localColors = 0 THEN
            ' No local palette, so use the global one
            WHILE y < info.globalColors
                x = y * 3
                _PALETTECOLOR y, _RGB32(ASC(info.globalPalette, x + 1), ASC(info.globalPalette, x + 2), ASC(info.globalPalette, x + 3)), bmp
                y = y + 1
            WEND
        ELSE
            ' Use the local palette
            WHILE y < info.localColors
                x = y * 3
                _PALETTECOLOR y, _RGB32(ASC(info.localPalette, x + 1), ASC(info.localPalette, x + 2), ASC(info.localPalette, x + 3)), bmp
                y = y + 1
            WEND
        END IF

        ' Set the transparent color
        IF info.transparentColor >= 0 THEN _CLEARCOLOR info.transparentColor, bmp
    END SUB


    ' This is an internal loading function common for both memory and file loaders
    FUNCTION __GIF_Load%% (Id AS LONG, sf AS StringFileType)
        SHARED __GIFPlayHashTable() AS HashTableType
        SHARED __GIFPlay() AS __GIFPlayType
        SHARED __GIFPlayFrame() AS __GIFPlayFrameType
        SHARED __GIF_FirstFreeFrame AS LONG

        ' Check if Id already exists and if so free it
        IF GIF_IsLoaded(Id) THEN GIF_Free Id

        ' Check if we can read the signature at a minimum
        IF StringFile_GetSize(sf) < 6 THEN EXIT FUNCTION

        ' Check the file signature before proceeding further
        DIM buffer AS STRING: buffer = StringFile_ReadString(sf, 6)
        IF buffer <> "GIF87a" AND buffer <> "GIF89a" THEN EXIT FUNCTION

        ' Ok, so it is a GIF. Allocate resources to load the rest of the file
        DIM idx AS LONG: FOR idx = 0 TO UBOUND(__GIFPlay)
            IF NOT __GIFPlay(idx).isUsed THEN EXIT FOR
        NEXT idx

        ' No free GIF slots?
        IF idx > UBOUND(__GIFPlay) THEN REDIM _PRESERVE __GIFPlay(0 TO idx) AS __GIFPlayType

        __GIFPlay(idx).isUsed = TRUE ' occupy the slot
        HashTable_InsertLong __GIFPlayHashTable(), Id, idx ' add it to the hash table

        ' Reset some stuff
        __GIFPlay(idx).firstFrame = -1
        __GIFPlay(idx).lastFrame = -1
        __GIFPlay(idx).frame = -1
        __GIFPlay(idx).frameCount = 0
        __GIFPlay(idx).frameNumber = 0
        __GIFPlay(idx).isPlaying = FALSE
        __GIFPlay(idx).loops = 0
        __GIFPlay(idx).loopCounter = 0
        __GIFPlay(idx).duration = 0
        __GIFPlay(idx).lastTick = 0
        __GIFPlay(idx).lastFrameRendered = -1
        __GIFPlay(idx).hasSavedImage = FALSE
        __GIFPlay(idx).overlayEnabled = TRUE

        ' Get width and height
        DIM W AS _UNSIGNED INTEGER: W = StringFile_ReadInteger(sf)
        DIM H AS _UNSIGNED INTEGER: H = StringFile_ReadInteger(sf)

        ' Create the 32bpp rendered image using the width and height we got above
        __GIFPlay(idx).image = _NEWIMAGE(W, H, 32)
        __GIFPlay(idx).savedImage = _NEWIMAGE(W, H, 32)
        IF __GIFPlay(idx).image >= -1 OR __GIFPlay(idx).savedImage >= -1 THEN GOTO gif_load_error

        DIM i AS _UNSIGNED _BYTE: i = StringFile_ReadByte(sf)

        DIM rawFrame AS __GIFFrameType
        rawFrame.globalPalette = STRING$(768, 0)
        rawFrame.localPalette = STRING$(768, 0)
        rawFrame.transparentColor = -1 ' no transparent color
        rawFrame.duration = 10 ' 0.1 seconds if no duration is specified (this behavior is from the erstwhile GIFPlay library)

        ' Global color table?
        IF _READBIT(i, 7) THEN rawFrame.globalColors = _SHL(1, ((i AND 7) + 1))

        ' Background color is only valid with a global palette
        __GIFPlay(idx).bgColor = StringFile_ReadByte(sf)

        ' Skip aspect ratio
        StringFile_Seek sf, StringFile_GetPosition(sf) + 1

        ' Read the global palette data
        IF rawFrame.globalColors > 0 THEN MID$(rawFrame.globalPalette, 1, 3 * rawFrame.globalColors) = StringFile_ReadString(sf, 3 * rawFrame.globalColors)

        DIM frameIdx AS LONG: frameIdx = -1

        DO
            i = StringFile_ReadByte(sf)

            SELECT CASE i
                CASE &H2C ' image descriptor
                    ' Look for a free slot from the last lowest freed index
                    FOR frameIdx = __GIF_FirstFreeFrame TO UBOUND(__GIFPlayFrame)
                        IF NOT __GIFPlayFrame(frameIdx).isUsed THEN
                            __GIF_FirstFreeFrame = frameIdx + 1
                            EXIT FOR
                        END IF
                    NEXT

                    IF frameIdx > UBOUND(__GIFPlayFrame) THEN
                        ' Search from the beginning
                        FOR frameIdx = 0 TO UBOUND(__GIFPlayFrame)
                            IF NOT __GIFPlayFrame(frameIdx).isUsed THEN EXIT FOR
                        NEXT
                    END IF

                    ' If still no free frame slot then allocate one
                    IF frameIdx > UBOUND(__GIFPlayFrame) THEN REDIM _PRESERVE __GIFPlayFrame(0 TO frameIdx) AS __GIFPlayFrameType

                    ' Occupy the slot
                    __GIFPlayFrame(frameIdx).isUsed = TRUE

                    ' Read frame size and offset
                    __GIFPlayFrame(frameIdx).L = StringFile_ReadInteger(sf)
                    __GIFPlayFrame(frameIdx).T = StringFile_ReadInteger(sf)
                    W = StringFile_ReadInteger(sf)
                    H = StringFile_ReadInteger(sf)

                    ' Create a raw frame image from the width and height we got above
                    __GIFPlayFrame(frameIdx).image = _NEWIMAGE(W, H, 256)
                    IF __GIFPlayFrame(frameIdx).image >= -1 THEN GOTO gif_load_error

                    i = StringFile_ReadByte(sf)

                    ' Local palette?
                    IF _READBIT(i, 7) THEN
                        rawFrame.localColors = _SHL(1, ((i AND 7) + 1))
                        MID$(rawFrame.localPalette, 1, 3 * rawFrame.localColors) = StringFile_ReadString(sf, 3 * rawFrame.localColors)
                    END IF

                    ' Decode the frame bitmap data
                    DIM mI AS _MEM: mI = _MEMIMAGE(__GIFPlayFrame(frameIdx).image)
                    IF mI.SIZE = 0 THEN GOTO gif_load_error

                    IF NOT __GIF_DecodeLZW(sf, mI) THEN
                        _MEMFREE mI
                        GOTO gif_load_error
                    END IF

                    _MEMFREE mI

                    ' De-interlace the bitmap if it is interlaced
                    IF _READBIT(i, 6) THEN __GIF_DeinterlaceFrameImage __GIFPlayFrame(frameIdx).image

                    ' Apply palette and transparency
                    __GIF_PrepareFrameImage rawFrame, __GIFPlayFrame(frameIdx).image

                    ' Update GIF properties
                    IF __GIFPlay(idx).firstFrame = -1 THEN
                        ' This is the first frame of the animation
                        __GIFPlay(idx).firstFrame = frameIdx
                        __GIFPlay(idx).frame = frameIdx ' the starting frame
                        __GIFPlayFrame(frameIdx).prevFrame = frameIdx ' make previous frame to point to this
                        __GIFPlayFrame(frameIdx).nextFrame = frameIdx ' make next frame to point to this
                    ELSE
                        ' This is not the first frame
                        __GIFPlayFrame(__GIFPlay(idx).firstFrame).prevFrame = frameIdx ' update first frame's previous frame
                        __GIFPlayFrame(__GIFPlay(idx).lastFrame).nextFrame = frameIdx ' udpate last frames's next frame
                        __GIFPlayFrame(frameIdx).prevFrame = __GIFPlay(idx).lastFrame ' previous frame is the last frame
                        __GIFPlayFrame(frameIdx).nextFrame = __GIFPlay(idx).firstFrame ' next frame is the the first frame

                    END IF
                    __GIFPlay(idx).lastFrame = frameIdx ' make the last frame to point to this
                    __GIFPlayFrame(frameIdx).disposalMethod = rawFrame.disposalMethod
                    __GIFPlayFrame(frameIdx).duration = rawFrame.duration * 10 ' convert to ticks (ms)
                    __GIFPlay(idx).duration = __GIFPlay(idx).duration + __GIFPlayFrame(frameIdx).duration ' add the frame duration to the global duration
                    __GIFPlay(idx).frameCount = __GIFPlay(idx).frameCount + 1

                    ' Prepare for next frame
                    rawFrame.localColors = 0
                    rawFrame.localPalette = STRING$(768, 0)
                    rawFrame.disposalMethod = 0
                    rawFrame.transparentColor = -1 ' no transparent color
                    rawFrame.duration = 10 ' 0.1 seconds if no duration is specified (this behavior is from the erstwhile GIFPlay library)

                CASE &H21 ' extension introducer
                    DIM j AS _UNSIGNED _BYTE: j = StringFile_ReadByte(sf) ' extension type
                    i = StringFile_ReadByte(sf) ' size

                    IF j = &HF9 THEN ' graphic control extension
                        ' Size must be 4
                        IF i <> 4 THEN GOTO gif_load_error

                        i = StringFile_ReadByte(sf)

                        rawFrame.disposalMethod = _SHR(i, 2) AND 7
                        rawFrame.duration = StringFile_ReadInteger(sf)

                        IF _READBIT(i, 0) THEN ' transparency?
                            rawFrame.transparentColor = StringFile_ReadByte(sf)
                        ELSE
                            StringFile_Seek sf, StringFile_GetPosition(sf) + 1
                        END IF

                        i = StringFile_ReadByte(sf) ' size
                    ELSEIF j = &HFF THEN ' application extension
                        IF i = 11 THEN
                            buffer = StringFile_ReadString(sf, 11)
                            i = StringFile_ReadByte(sf) ' size
                            IF _STRCMP(buffer, "NETSCAPE2.0") = 0 THEN
                                IF i = 3 THEN
                                    j = StringFile_ReadByte(sf)
                                    __GIFPlay(idx).loops = StringFile_ReadInteger(sf)
                                    IF j <> 1 THEN __GIFPlay(idx).loops = 0
                                    i = StringFile_ReadByte(sf) ' size
                                END IF
                            END IF
                        END IF
                    END IF

                    ' Possibly more blocks until terminator block (0)
                    WHILE i > 0
                        StringFile_Seek sf, StringFile_GetPosition(sf) + i
                        i = StringFile_ReadByte(sf)
                    WEND

                CASE &H3B ' GIF trailer
                    EXIT DO
            END SELECT
        LOOP WHILE NOT StringFile_IsEOF(sf)

        ' Bad / corrupt GIF?
        IF __GIFPlay(idx).frameCount = 0 THEN GOTO gif_load_error

        '__GIF_PrintDebugInfo idx

        ' Render the first frame and then pause
        __GIFPlay(idx).isPlaying = TRUE
        __GIFPlay(idx).lastTick = __GIF_GetTicks
        DIM dummy AS LONG: dummy = GIF_GetFrame(Id)
        __GIFPlay(idx).isPlaying = FALSE

        __GIF_Load = TRUE
        EXIT FUNCTION

        gif_load_error:
        GIF_Free Id ' use GIF_Free() to cleanup if we encountered any error
    END FUNCTION


    'SUB __GIF_PrintDebugInfo (index AS LONG)
    '    SHARED __GIFPlay() AS __GIFPlayType
    '    SHARED __GIFPlayFrame() AS __GIFPlayFrameType

    '    _ECHO "Dump for GIF:" + STR$(index) + CHR$(10)

    '    _ECHO "isUsed =" + STR$(__GIFPlay(index).isUsed)
    '    _ECHO "image =" + STR$(__GIFPlay(index).image)
    '    _ECHO "bgColor =" + STR$(__GIFPlay(index).bgColor)
    '    _ECHO "firstFrame =" + STR$(__GIFPlay(index).firstFrame)
    '    _ECHO "lastFrame =" + STR$(__GIFPlay(index).lastFrame)
    '    _ECHO "frame =" + STR$(__GIFPlay(index).frame)
    '    _ECHO "frameCount =" + STR$(__GIFPlay(index).frameCount)
    '    _ECHO "frameNumber =" + STR$(__GIFPlay(index).frameNumber)
    '    _ECHO "isPlaying =" + STR$(__GIFPlay(index).isPlaying)
    '    _ECHO "loops =" + STR$(__GIFPlay(index).loops)
    '    _ECHO "loopCounter =" + STR$(__GIFPlay(index).loopCounter)
    '    _ECHO "duration =" + STR$(__GIFPlay(index).duration)
    '    _ECHO "lastTick =" + STR$(__GIFPlay(index).lastTick)
    '    _ECHO "lastFrameRendered =" + STR$(__GIFPlay(index).lastFrameRendered)
    '    _ECHO "savedImage =" + STR$(__GIFPlay(index).savedImage)
    '    _ECHO "hasSavedImage =" + STR$(__GIFPlay(index).hasSavedImage)
    '    _ECHO "overlayEnabled =" + STR$(__GIFPlay(index).overlayEnabled)

    '    _ECHO CHR$(10) + "Walking animation chain..." + CHR$(10)

    '    DO
    '        _ECHO "Dump for frame:" + STR$(__GIFPlay(index).frame) + CHR$(10)

    '        _ECHO "isUsed =" + STR$(__GIFPlayFrame(__GIFPlay(index).frame).isUsed)
    '        _ECHO "prevFrame =" + STR$(__GIFPlayFrame(__GIFPlay(index).frame).prevFrame)
    '        _ECHO "nextFrame =" + STR$(__GIFPlayFrame(__GIFPlay(index).frame).nextFrame)
    '        _ECHO "image =" + STR$(__GIFPlayFrame(__GIFPlay(index).frame).image)
    '        _ECHO "L =" + STR$(__GIFPlayFrame(__GIFPlay(index).frame).L)
    '        _ECHO "T =" + STR$(__GIFPlayFrame(__GIFPlay(index).frame).T)
    '        _ECHO "disposalMethod =" + STR$(__GIFPlayFrame(__GIFPlay(index).frame).disposalMethod)
    '        _ECHO "duration =" + STR$(__GIFPlayFrame(__GIFPlay(index).frame).duration)

    '        _ECHO CHR$(10) + "Changing to next frame..."
    '        __GIFPlay(index).frame = __GIFPlayFrame(__GIFPlay(index).frame).nextFrame
    '    LOOP UNTIL __GIFPlay(index).frame = __GIFPlay(index).firstFrame
    'END SUB


    ' This gets the GIF overlay image (real loading only happens once)
    FUNCTION __GIF_GetOverlayImage&
        CONST SIZE_GIFOVERLAYIMAGE_BMP_16506~& = 16506~&
        CONST COMP_GIFOVERLAYIMAGE_BMP_16506%% = -1%%
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

        __GIF_GetOverlayImage = overlayImage
    END FUNCTION

    '$INCLUDE:'HashTable.bas'
    '$INCLUDE:'StringFile.bas'
    '$INCLUDE:'Base64.bas'

$END IF
