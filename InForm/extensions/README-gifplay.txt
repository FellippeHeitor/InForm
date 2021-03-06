Animated GIF decoder v1.0
By Zom-B
http://www.qb64.org/wiki/GIF_Images

Adapted for use with InForm's PictureBox controls by @FellippeHeitor

* Usage instructions:
Your form must contain a PictureBox control that'll serve as a container for
the GIF file you'll load with this library.

In the "External modules" section of the .bas file generated by InForm,
$INCLUDE both gifplay.bi and gifplay.bm. The first must come before the
line that includes InForm.ui and the second must come after that, as in
the sample below:

        ': External modules: --------------------------------
        '$INCLUDE:'InForm\extensions\gifplay.bi'
        '$INCLUDE:'InForm\InForm.ui'
        '$INCLUDE:'InForm\xp.uitheme'
        '$INCLUDE:'gifplaySample.frm'
        '$INCLUDE:'InForm\extensions\gifplay.bm'

* Methods:

    - FUNCTION OpenGif(ID, file$)
    
    OpenGif is a function that takes a PictureBox control ID and a GIF
    file name and returns True if loading the animation is successful.
    
    - FUNCTION TotalFrames(ID AS LONG)

    TotalFrames returns the total number of frames in a loaded gif.
    If not an animated GIF, returns 1.

    - SUB UpdateGif(ID)
    
    UpdateGif must be called from within the __UI_BeforeUpdateDisplay event.
    That's where the frames will be updated in your PictureBox control.
    
    - FUNCTION IsPlaying(ID)
    
    Returns True is the PictureBox control contains a GIF that's currently
    being played.
    
    - SUB PlayGif(ID), SUB PauseGif(ID), SUB StopGif(ID)
    Starts, pauses or stops playback of a GIF file loaded into the specified
    PictureBox control.
    
    - SUB CloseGif(ID)
    Closes the GIF file loaded in the specified PictureBox control and frees
    the memory used by the frame data buffer attached to it.
