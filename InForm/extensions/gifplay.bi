'#######################################################################################
'# Animated GIF decoder v1.0                                                           #
'# By Zom-B                                                                            #
'#                                                                                     #
'# http://www.qb64.org/wiki/GIF_Images                                                 #
'#######################################################################################
'Adapted for use with InForm's PictureBox controls by @FellippeHeitor

TYPE GIFDATA
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

TYPE FRAMEDATA
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

REDIM SHARED GifData(0) AS GIFDATA
REDIM SHARED GifFrameData(0) AS FRAMEDATA
DIM SHARED TotalGIFLoaded AS LONG, TotalGIFFrames AS LONG
