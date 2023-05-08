'#######################################################################################
'# Animated GIF decoder v1.0                                                           #
'# By Zom-B                                                                            #
'#                                                                                     #
'# http://www.qb64.org/wiki/GIF_Images                                                 #
'#######################################################################################
'Adapted for use with InForm's PictureBox controls by @FellippeHeitor

Type GIFDATA
    ID As Long
    file As Integer
    sigver As String * 6
    width As _Unsigned Integer
    height As _Unsigned Integer
    bpp As _Unsigned _Byte
    sortFlag As _Byte ' Unused
    colorRes As _Unsigned _Byte
    colorTableFlag As _Byte
    bgColor As _Unsigned _Byte
    aspect As Single ' Unused
    numColors As _Unsigned Integer
    palette As String * 768
    firstFrame As Long
    totalFrames As Long
    IsPlaying As _Byte
    Frame As Long
    LoadedFrames As Long
    GifLoadComplete As _Byte
    LastFrameServed As Long
    LastFrameUpdate As Single
    LastFrameDelay As Single
    HideOverlay As _Byte
End Type

Type FRAMEDATA
    ID As Long
    thisFrame As Long
    addr As Long
    left As _Unsigned Integer
    top As _Unsigned Integer
    width As _Unsigned Integer
    height As _Unsigned Integer
    localColorTableFlag As _Byte
    interlacedFlag As _Byte
    sortFlag As _Byte ' Unused
    palBPP As _Unsigned _Byte
    minimumCodeSize As _Unsigned _Byte
    transparentFlag As _Byte 'GIF89a-specific (animation) values
    userInput As _Byte ' Unused
    disposalMethod As _Unsigned _Byte
    delay As Single
    transColor As _Unsigned _Byte
End Type

ReDim Shared GifData(0) As GIFDATA
ReDim Shared GifFrameData(0) As FRAMEDATA
Dim Shared TotalGIFLoaded As Long, TotalGIFFrames As Long

