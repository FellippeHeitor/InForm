': This program uses
': InForm - GUI library for QB64 - Beta version 9
': Fellippe Heitor, 2016-2019 - fellippe@qb64.org - @fellippeheitor
': https://github.com/FellippeHeitor/InForm
'-----------------------------------------------------------

': Controls' IDs: ------------------------------------------------------------------
Dim Shared gifplaySample As Long
Dim Shared PictureBox1 As Long
Dim Shared LoadBT As Long
Dim Shared PlayBT As Long

': External modules: ---------------------------------------------------------------
'$INCLUDE:'gifplay.bi'
'$INCLUDE:'..\InForm.bi'
'$INCLUDE:'..\xp.uitheme'
'$INCLUDE:'gifplaySample.frm'
'$INCLUDE:'gifplay.bm'

': Event procedures: ---------------------------------------------------------------
SUB __UI_BeforeInit

END SUB

SUB __UI_OnLoad
    Control(PlayBT).Disabled = True
END SUB

SUB __UI_BeforeUpdateDisplay
    UpdateGif PictureBox1
END SUB

SUB __UI_BeforeUnload
END SUB

SUB __UI_Click (id AS LONG)
    SELECT CASE id
        CASE LoadBT
            'file 'globe.gif' comes from:
            'https://en.wikipedia.org/wiki/GIF#/media/File:Rotating_earth_(large).gif
            IF OpenGif(PictureBox1, "globe.gif") THEN
                Control(PlayBT).Disabled = False
                IF TotalFrames(PictureBox1) > 1 THEN
                    Caption(PlayBT) = "Play"
                ELSE
                    Caption(PlayBT) = "Static gif"
                    Control(PlayBT).Disabled = True
                END IF
                Caption(LoadBT) = "globe.gif loaded"
                Control(LoadBT).Disabled = True
            ELSE
                Answer = MessageBox("File 'globe.gif' could not be found.", "", MsgBox_Exclamation + MsgBox_OkOnly)
            END IF
        CASE PlayBT
            IF GifIsPlaying(PictureBox1) THEN
                PauseGif PictureBox1
                Caption(PlayBT) = "Play"
            ELSE
                PlayGif PictureBox1
                Caption(PlayBT) = "Pause"
            END IF
        CASE PictureBox1
            HideGifOverlay PictureBox1
    END SELECT
END SUB

SUB __UI_MouseEnter (id AS LONG)
END SUB

SUB __UI_MouseLeave (id AS LONG)
END SUB

SUB __UI_FocusIn (id AS LONG)
END SUB

SUB __UI_FocusOut (id AS LONG)
END SUB

SUB __UI_MouseDown (id AS LONG)
END SUB

SUB __UI_MouseUp (id AS LONG)
END SUB

SUB __UI_KeyPress (id AS LONG)
END SUB

SUB __UI_TextChanged (id AS LONG)
END SUB

SUB __UI_ValueChanged (id AS LONG)
END SUB

SUB __UI_FormResized
END SUB

'$INCLUDE:'..\InForm.ui'

