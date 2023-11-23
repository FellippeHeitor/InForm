': This program uses
': InForm - GUI library for QB64 - Beta version 9
': Fellippe Heitor, 2016-2019 - fellippe@qb64.org - @fellippeheitor
': https://github.com/FellippeHeitor/InForm
'-----------------------------------------------------------

DEFLNG A-Z
OPTION _EXPLICIT

': Controls' IDs: ------------------------------------------------------------------
DIM SHARED gifplaySample AS LONG
DIM SHARED PictureBox1 AS LONG
DIM SHARED LoadBT AS LONG
DIM SHARED PlayBT AS LONG

': External modules: ---------------------------------------------------------------
'$INCLUDE:'../../InForm/extensions/GIFPlay.bi'
'$INCLUDE:'../../InForm/InForm.bi'
'$INCLUDE:'../../InForm/extensions/MessageBox.bi'
'$INCLUDE:'GIFPlaySample.frm'

': Event procedures: ---------------------------------------------------------------
SUB __UI_BeforeInit
END SUB

SUB __UI_OnLoad
    Control(PlayBT).Disabled = True
END SUB

SUB __UI_BeforeUpdateDisplay
    GIF_Draw PictureBox1, True
END SUB

SUB __UI_BeforeUnload
END SUB

SUB __UI_Click (id AS LONG)
    SELECT CASE id
        CASE gifplaySample

        CASE LoadBT
            DIM fileName AS STRING: fileName = _OPENFILEDIALOG$(Caption(gifplaySample), , "*.gif|*.GIF|*.Gif", "GIF Files")

            IF LEN(fileName) > 0 THEN
                IF GIF_LoadFromFile(PictureBox1, fileName) THEN

                    Control(PlayBT).Disabled = False

                    IF GIF_GetTotalFrames(PictureBox1) > 1 THEN
                        Caption(PlayBT) = "Play"
                    ELSE
                        Control(PlayBT).Disabled = True
                    END IF
                ELSE
                    Control(PlayBT).Disabled = True
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
            GIF_EnableOverlay PictureBox1, False
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
'$INCLUDE:'../../InForm/extensions/GIFPlay.bas'
'$INCLUDE:'../../InForm/extensions/MessageBox.bas'
