': This program uses
': InForm - GUI library for QB64 - Beta version 9
': Fellippe Heitor, 2016-2019 - fellippe@qb64.org - @fellippeheitor
': https://github.com/FellippeHeitor/InForm
'-----------------------------------------------------------

DEFLNG A-Z
OPTION _EXPLICIT

': Controls' IDs: ------------------------------------------------------------------
DIM SHARED DoneProgressBar AS LONG
DIM SHARED AboutButton AS LONG
DIM SHARED GIFPlaySample AS LONG
DIM SHARED GIFPictureBox AS LONG
DIM SHARED LoadButton AS LONG
DIM SHARED PlayButton AS LONG

': External modules: ---------------------------------------------------------------
'$INCLUDE:'../../InForm/extensions/GIFPlay.bi'
'$INCLUDE:'../../InForm/InForm.bi'
'$INCLUDE:'GIFPlaySample.frm'
'$INCLUDE:'../../InForm/InForm.ui'
'$INCLUDE:'../../InForm/extensions/GIFPlay.bas'

': Event procedures: ---------------------------------------------------------------
SUB __UI_BeforeInit
END SUB

SUB __UI_OnLoad
    Control(PlayButton).Disabled = TRUE
    Control(DoneProgressBar).Disabled = TRUE
END SUB

SUB __UI_BeforeUpdateDisplay
    IF GIF_IsLoaded(GIFPictureBox) THEN
        GIF_Draw GIFPictureBox
        Control(DoneProgressBar).Value = (GIF_GetElapsedTime(GIFPictureBox) / GIF_GetTotalDuration(GIFPictureBox)) * 100
    END IF
END SUB

SUB __UI_BeforeUnload
END SUB

SUB __UI_Click (id AS LONG)
    SELECT CASE id
        CASE DoneProgressBar

        CASE AboutButton
            MessageBox "GIFPlay library + InForm-PE demo." + STRING$(2, 10) + "Get it from https://github.com/a740g/InForm-PE", "About " + Caption(GIFPlaySample), MsgBox_OkOnly + MsgBox_Information

        CASE GIFPlaySample

        CASE LoadButton
            DIM fileName AS STRING: fileName = _OPENFILEDIALOG$(Caption(GIFPlaySample), , "*.gif|*.GIF|*.Gif", "GIF Files")

            IF LEN(fileName) > 0 THEN
                IF GIF_LoadFromFile(GIFPictureBox, fileName) THEN
                    ' Calculate picturebox width based on the aspect ratio of the GIF
                    Control(GIFPictureBox).Width = GIF_GetWidth(GIFPictureBox) / GIF_GetHeight(GIFPictureBox) * Control(GIFPictureBox).Height
                    Control(GIFPlaySample).Width = Control(GIFPictureBox).Width + Control(LoadButton).Width + 24
                    Control(DoneProgressBar).Width = Control(GIFPictureBox).Width

                    Control(DoneProgressBar).Disabled = FALSE

                    IF GIF_GetTotalFrames(GIFPictureBox) > 1 THEN
                        Control(PlayButton).Disabled = FALSE
                        Caption(PlayButton) = "Play"
                    ELSE
                        Control(PlayButton).Disabled = TRUE
                    END IF
                ELSE
                    Control(PlayButton).Disabled = TRUE
                    Control(DoneProgressBar).Disabled = TRUE
                    MessageBox fileName + " failed to load!", "", MsgBox_Exclamation
                END IF
            END IF

        CASE PlayButton
            IF GIF_IsPlaying(GIFPictureBox) THEN
                GIF_Pause GIFPictureBox
                Caption(PlayButton) = "Play"
            ELSE
                GIF_Play GIFPictureBox
                Caption(PlayButton) = "Pause"
            END IF

        CASE GIFPictureBox
            GIF_EnableOverlay GIFPictureBox, FALSE
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
