'-----------------------------------------------------------------------------------------------------------------------
' Animated GIF Player library
' Copyright (c) 2023 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$IF GIFPLAY_BI = UNDEFINED THEN
    $LET GIFPLAY_BI = TRUE

    '$INCLUDE:'HashTable.bi'
    '$INCLUDE:'StringFile.bi'

    ' This is the master animation type that holds info about a complete animation
    TYPE __GIFPlayType
        isUsed AS _BYTE ' is this slot being used (this is only here to assist slot allocation)
        isReady AS _BYTE ' this is set if the GIF is fully loaded (helps fix issues with InForm-PE TIMERs)
        image AS LONG ' the rendered 32bpp frame image
        bgColor AS _UNSIGNED _BYTE ' background color
        firstFrame AS LONG ' index of the first frame in the frame data array
        lastFrame AS LONG ' index of the last frame in the frame data array
        frame AS LONG ' index of the current frame being played
        frameCount AS _UNSIGNED LONG ' total number of frames counted while loading
        frameNumber AS _UNSIGNED LONG ' this is simply the number of current frame since playback (re)started
        isPlaying AS _BYTE ' set to true if the animation is currently playing
        loops AS LONG ' -1 = no, 0 = forever, n = that many times
        loopCounter AS _UNSIGNED LONG ' this counts the number of loops
        duration AS _UNSIGNED _INTEGER64 ' total duration in ticks (ms)
        lastTick AS _UNSIGNED _INTEGER64 ' the tick recorded when the last frame was played
        lastFrameRendered AS LONG ' index of the last frame that was rendered
        savedImage AS LONG ' copy of the current frame when disposal method 3 (restore to previous) is encountered
        hasSavedImage AS _BYTE ' set to true if we have a valid saved frame
        overlayEnabled AS _BYTE ' should the "GIF" overlay be shown / hidden when it is not playing
    END TYPE

    ' This type holds information for a single animation frame
    TYPE __GIFPlayFrameType
        isUsed AS _BYTE ' is this frame slot being used?
        prevFrame AS LONG ' previous frame (this will link back to the last frame if this is the first one)
        nextFrame AS LONG ' next frame (this will link back to the first frame if this is the last one)
        image AS LONG ' QB64 image handle
        L AS _UNSIGNED INTEGER ' frame left (x offset)
        T AS _UNSIGNED INTEGER ' frame top (y offset)
        disposalMethod AS _UNSIGNED _BYTE ' 0 = don't care, 1 = keep, 2 = background, 3 = previous
        duration AS _UNSIGNED _INTEGER64 ' frame duration in ticks (ms)
    END TYPE

    ' This is an internal type that defines whatever is needed (except the pixel info) from a raw GIF frame data to construct a QB64 image
    TYPE __GIFFrameType
        globalColors AS _UNSIGNED INTEGER ' total colors in the global palette
        globalPalette AS STRING * 768 ' global palette - 256 colors * 3 components
        localColors AS _UNSIGNED INTEGER ' total colors in the local frame palette
        localPalette AS STRING * 768 ' local frame palette - 256 colors * 3 components
        disposalMethod AS _UNSIGNED _BYTE ' 0 = don't care, 1 = keep, 2 = background, 3 = previous
        transparentColor AS INTEGER ' transparent color for this frame (< 0 means none)
        duration AS _UNSIGNED INTEGER ' raw duration data in 1/100th seconds
    END TYPE

    ' GetTicks returns the number of "ticks" (ms) since the program started execution where 1000 "ticks" (ms) = 1 second
    DECLARE LIBRARY
        FUNCTION __GIF_GetTicks~&& ALIAS "GetTicks"
    END DECLARE

    REDIM __GIFPlayHashTable(0 TO 0) AS HashTableType ' shared hash table to keep user supplied IDs (the values here points to indexes in __GIFPlay)
    REDIM __GIFPlay(0 TO 0) AS __GIFPlayType ' main GIFPlay array - each array element is for a single GIF
    REDIM __GIFPlayFrame(0 TO 0) AS __GIFPlayFrameType ' shared GIF frame array - this holds GIF frame and frame information for all loaded GIFs
    DIM __GIF_FirstFreeFrame AS LONG ' index of the lowest free frame in __GIFPlayFrame

$END IF
