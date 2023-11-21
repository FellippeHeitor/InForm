'-----------------------------------------------------------------------------------------------------------------------
' Animated GIF Player library
' Copyright (c) 2023 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$IF GIFPLAY_BI = UNDEFINED THEN
    $LET GIFPLAY_BI = TRUE

    $IF INFORM_BI = UNDEFINED THEN
        DEFLNG A-Z
        OPTION _EXPLICIT

        CONST FALSE = 0, TRUE = NOT FALSE
    $END IF

    '$INCLUDE:'HashTable.bi'
    '$INCLUDE:'StringFile.bi'

    TYPE __GIFPlayType
        id AS LONG ' handle supplied by the user (do we need this?)
        W AS _UNSIGNED INTEGER ' GIF global width (this needs to be 16-bit)
        H AS _UNSIGNED INTEGER ' GIF global height (this needs to be 16-bit)
        bgColor AS _UNSIGNED _BYTE ' background color
        pal AS STRING * 768 ' global palette - 256 colors * 3 components
        frame AS LONG ' index of the first frame in the frame data array
        frames AS LONG ' total frames in the animation
        hideOverlay AS _BYTE ' should the "GIF" overlay be hidden when it is not playing
    END TYPE

    TYPE __GIFPlayFrameType
        id AS LONG ' which GIF handle does this belong to?
        image AS LONG ' QB64 image handle
        L AS _UNSIGNED INTEGER ' frame left (this needs to be 16-bit) (do we need these?)
        T AS _UNSIGNED INTEGER ' frame top (this needs to be 16-bit)
        W AS _UNSIGNED INTEGER ' frame width (this needs to be 16-bit)
        H AS _UNSIGNED INTEGER ' frame height (this needs to be 16-bit)
        pre AS LONG ' previous frame (this will link back to the last frame if this is the first one)
        nxt AS LONG ' next frame (this will link back to the first frame if this is the last one)
        delayMs AS SINGLE ' frame delay time
        direction AS _BYTE ' playback direction
    END TYPE

    REDIM __GIFPlayHashTable(0 TO 0) AS HashTableType
    REDIM __GIFPlay(0 TO 0) AS __GIFPlayType
    REDIM __GIFPlayFrame(0 TO 0) AS __GIFPlayFrameType
$END IF
