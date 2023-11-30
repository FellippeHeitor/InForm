': This program uses
': InForm - GUI library for QB64 - Beta version 9
': Fellippe Heitor, 2016-2019 - fellippe@qb64.org - @fellippeheitor
': https://github.com/FellippeHeitor/InForm
'-----------------------------------------------------------

DEFLNG A-Z
OPTION _EXPLICIT

': Controls' IDs: ------------------------------------------------------------------
DIM SHARED AboutBT AS LONG
DIM SHARED gifplaySample AS LONG
DIM SHARED PictureBox1 AS LONG
DIM SHARED LoadBT AS LONG
DIM SHARED PlayBT AS LONG

': External modules: ---------------------------------------------------------------
'$INCLUDE:'../../InForm/extensions/GIFPlay.bi'
'$INCLUDE:'../../InForm/extensions/MessageBox.bi'
'$INCLUDE:'../../InForm/InForm.bi'
'$INCLUDE:'GIFPlaySample.frm'

': Event procedures: ---------------------------------------------------------------
SUB __UI_BeforeInit
END SUB

SUB __UI_OnLoad
    Control(PlayBT).Disabled = TRUE
END SUB

SUB __UI_BeforeUpdateDisplay
    IF GIF_IsLoaded(PictureBox1) THEN GIF_Draw PictureBox1
END SUB

SUB __UI_BeforeUnload
END SUB

SUB __UI_Click (id AS LONG)
    SELECT CASE id
        CASE AboutBT
            MessageBox "GIFPlay library + InForm-PE demo." + STRING$(2, 10) + "Get it from https://github.com/a740g/InForm-PE", "About " + Caption(gifplaySample), MsgBox_OkOnly + MsgBox_Information

        CASE gifplaySample

        CASE LoadBT
            DIM fileName AS STRING: fileName = _OPENFILEDIALOG$(Caption(gifplaySample), , "*.gif|*.GIF|*.Gif", "GIF Files")

            IF LEN(fileName) > 0 THEN
                IF GIF_LoadFromFile(PictureBox1, fileName) THEN
                    ' Calculate picturebox width based on the aspect ratio of the GIF
                    Control(PictureBox1).Width = GIF_GetWidth(PictureBox1) / GIF_GetHeight(PictureBox1) * Control(PictureBox1).Height
                    Control(gifplaySample).Width = Control(PictureBox1).Width + Control(LoadBT).Width + 24

                    Control(PlayBT).Disabled = FALSE

                    IF GIF_GetTotalFrames(PictureBox1) > 1 THEN
                        Caption(PlayBT) = "Play"
                    ELSE
                        Control(PlayBT).Disabled = TRUE
                    END IF
                ELSE
                    Control(PlayBT).Disabled = TRUE
                    MessageBox fileName + " failed to load!", "", MsgBox_Exclamation
                END IF
            END IF

        CASE PlayBT
            IF GIF_IsPlaying(PictureBox1) THEN
                GIF_Pause PictureBox1
                Caption(PlayBT) = "Play"
            ELSE
                GIF_Play PictureBox1
                Caption(PlayBT) = "Pause"
            END IF

        CASE PictureBox1
            GIF_EnableOverlay PictureBox1, FALSE
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

'$INCLUDE:'../../InForm/InForm.ui'
'$INCLUDE:'../../InForm/xp.uitheme'
'$INCLUDE:'../../InForm/extensions/MessageBox.bas'
'$INCLUDE:'../../InForm/extensions/GIFPlay.bas'
