'-----------------------------------------------------------------------------------------------------------------------
' Animated GIF Player library
' Copyright (c) 2023 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$IF GIFPLAY_BI = UNDEFINED THEN
    $LET GIFPLAY_BI = TRUE

    ' TODO: remove this once done
    '$IF INFORM_BI = UNDEFINED THEN
    '    DEFLNG A-Z
    '    OPTION _EXPLICIT

    '    CONST FALSE = 0, TRUE = NOT FALSE
    '$END IF

    '$INCLUDE:'HashTable.bi'
    '$INCLUDE:'StringFile.bi'

    ' This is the master GIF type that holds info about a single GIF file
    TYPE __GIFPlayType
        W AS _UNSIGNED INTEGER ' GIF global width (this needs to be 16-bit)
        H AS _UNSIGNED INTEGER ' GIF global height (this needs to be 16-bit)
        bgColor AS _UNSIGNED _BYTE ' background color
        colors AS _UNSIGNED INTEGER ' total colors in the global palette
        pal AS STRING * 768 ' global palette - 256 colors * 3 components
        firstFrame AS LONG ' index of the first frame in the frame data array
        currentFrame AS LONG ' index of the current frame being played
        totalFrames AS LONG ' total number of frames counted while loading
        currentFrameNumber AS LONG ' this is simply the number of current frame since playback (re)started
        isPlaying AS _BYTE ' set to true if the GIF is currently playing
        direction AS _BYTE ' playback direction (-1 or +1)
        overlayEnabled AS _BYTE ' should the "GIF" overlay be shown / hidden when it is not playing
    END TYPE

    ' This is the a GIF frame type that holds info about an individual GIF frame
    TYPE __GIFPlayFrameType
        id AS LONG ' index to __GIFPlay that this frame belongs to (do we really need this?)
        image AS LONG ' QB64 image handle
        L AS _UNSIGNED INTEGER ' frame left (this needs to be 16-bit) (do we need these?)
        T AS _UNSIGNED INTEGER ' frame top (this needs to be 16-bit)
        W AS _UNSIGNED INTEGER ' frame width (this needs to be 16-bit)
        H AS _UNSIGNED INTEGER ' frame height (this needs to be 16-bit)
        prevFrame AS LONG ' previous frame (this will link back to the last frame if this is the first one)
        nextFrame AS LONG ' next frame (this will link back to the first frame if this is the last one)
        timeMs AS SINGLE ' frame time
    END TYPE

    ' This is used by temporary variables during the decoding step to store the raw data for a single frame
    TYPE __GIFBitmapType
        W AS LONG
        H AS LONG
        pixels AS STRING
    END TYPE

    REDIM __GIFPlayHashTable(0 TO 0) AS HashTableType ' shared hash table to keep user supplied IDs (the values here points to indexes in __GIFPlay)
    REDIM __GIFPlay(0 TO 0) AS __GIFPlayType ' main GIFPlay array - each array element is for a single GIF
    REDIM __GIFPlayFrame(0 TO 0) AS __GIFPlayFrameType ' shared GIF frame array - this holds GIF frame and frame information for all loaded GIFs

$END IF
