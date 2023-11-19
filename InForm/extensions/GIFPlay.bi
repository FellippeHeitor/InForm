'#######################################################################################
'# Animated GIF decoder v1.0                                                           #
'# By Zom-B                                                                            #
'#                                                                                     #
'# http://www.qb64.org/wiki/GIF_Images                                                 #
'#######################################################################################
'Adapted for use with InForm's PictureBox controls by @FellippeHeitor

$IF GIFPLAY_BI = UNDEFINED THEN
    $LET GIFPLAY_BI = TRUE

    $IF INFORM_BI = UNDEFINED THEN
        OPTION _EXPLICIT

        CONST FALSE = 0, TRUE = NOT FALSE
    $END IF

    TYPE __GIFDataType
        ID AS LONG
        file AS INTEGER
        sigver AS STRING * 6
        width AS _UNSIGNED INTEGER
        height AS _UNSIGNED INTEGER
        bpp AS _UNSIGNED _BYTE
        sortFlag AS _BYTE ' Unused
        colorRes AS _UNSIGNED _BYTE
        colorTableFlag AS _BYTE
        bgColor AS _UNSIGNED _BYTE
        aspect AS SINGLE ' Unused
        numColors AS _UNSIGNED INTEGER
        palette AS STRING * 768
        firstFrame AS LONG
        totalFrames AS LONG
        IsPlaying AS _BYTE
        Frame AS LONG
        LoadedFrames AS LONG
        GifLoadComplete AS _BYTE
        LastFrameServed AS LONG
        LastFrameUpdate AS SINGLE
        LastFrameDelay AS SINGLE
        HideOverlay AS _BYTE
    END TYPE

    TYPE __GIFFrameDataType
        ID AS LONG
        thisFrame AS LONG
        addr AS LONG
        left AS _UNSIGNED INTEGER
        top AS _UNSIGNED INTEGER
        width AS _UNSIGNED INTEGER
        height AS _UNSIGNED INTEGER
        localColorTableFlag AS _BYTE
        interlacedFlag AS _BYTE
        sortFlag AS _BYTE ' Unused
        palBPP AS _UNSIGNED _BYTE
        minimumCodeSize AS _UNSIGNED _BYTE
        transparentFlag AS _BYTE 'GIF89a-specific (animation) values
        userInput AS _BYTE ' Unused
        disposalMethod AS _UNSIGNED _BYTE
        delay AS SINGLE
        transColor AS _UNSIGNED _BYTE
    END TYPE

    REDIM __GIFData(1 TO 1) AS __GIFDataType
    REDIM __GIFFrameData(0 TO 0) AS __GIFFrameDataType
    DIM __TotalGIFLoaded AS LONG, __TotalGIFFrames AS LONG

$END IF
