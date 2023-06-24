': This program uses
': InForm - GUI library for QB64 - v1.5
': Fellippe Heitor, 2016-2023 - fellippe@qb64.org - @fellippeheitor
': https://github.com/FellippeHeitor/InForm
'-----------------------------------------------------------

OPTION _EXPLICIT

TYPE WaveformType
    active AS LONG
    waveform AS LONG
    note AS LONG
    length AS LONG
    lengthType AS LONG
    tempo AS LONG
    volume AS LONG
    volRamp AS LONG
END TYPE

DIM SHARED Waveform(1 TO 5) AS WaveformType, currentWaveform AS LONG, currentControl AS LONG

': Controls' IDs: ------------------------------------------------------------------
DIM SHARED PlayFXDesigner AS LONG
DIM SHARED Waveforms AS LONG
DIM SHARED ConfigureWaveform AS LONG
DIM SHARED PlayFX AS LONG
DIM SHARED Waveform1TB AS LONG
DIM SHARED Waveform2TB AS LONG
DIM SHARED Waveform3TB AS LONG
DIM SHARED Waveform4TB AS LONG
DIM SHARED Waveform5TB AS LONG
DIM SHARED WaveformLB AS LONG
DIM SHARED WaveformSlider AS LONG
DIM SHARED WaveformNameLB AS LONG
DIM SHARED NoteLB AS LONG
DIM SHARED NoteSlider AS LONG
DIM SHARED LengthLB AS LONG
DIM SHARED LengthSlider AS LONG
DIM SHARED LengthEffectsDL AS LONG
DIM SHARED TempoLB AS LONG
DIM SHARED TempoSlider AS LONG
DIM SHARED VolumeLB AS LONG
DIM SHARED VolumeSlider AS LONG
DIM SHARED VolRampLB AS LONG
DIM SHARED VolRampSlider AS LONG
DIM SHARED PlayFXTB AS LONG
DIM SHARED PlayBT AS LONG

': External modules: ---------------------------------------------------------------
'$INCLUDE:'../../InForm/InForm.bi'
'$INCLUDE:'PlayFX.frm'

': Custom procedures: --------------------------------------------------------------
FUNCTION IsDifferentWaveform%% (w1 AS WaveformType, w2 AS WaveformType)
    IsDifferentWaveform = w1.waveform <> w2.waveform OR w1.note <> w2.note OR w1.length <> w2.length OR w1.lengthType <> w2.lengthType OR w1.tempo <> w2.tempo OR w1.volume <> w2.volume OR w1.volRamp <> w2.volRamp
END FUNCTION

SUB SetConfigControls (id AS LONG, curCtrl AS LONG)
    Control(WaveformSlider).Value = Waveform(id).waveform
    Control(NoteSlider).Value = Waveform(id).note
    Control(LengthSlider).Value = Waveform(id).length
    Control(LengthEffectsDL).Value = Waveform(id).lengthType
    Control(TempoSlider).Value = Waveform(id).tempo
    Control(VolumeSlider).Value = Waveform(id).volume
    Control(VolRampSlider).Value = Waveform(id).volRamp

    currentWaveform = id
    currentControl = curCtrl
END SUB

SUB ClearWaveform (id AS LONG)
    Waveform(id).active = False ' set not in use
    Waveform(id).waveform = 3 ' triangle
    Waveform(id).note = 42 ' half-way through the scale
    Waveform(id).length = 4 ' quarter
    Waveform(id).lengthType = 1 ' normal
    Waveform(id).tempo = 120 ' 120
    Waveform(id).volume = 100 ' max
    Waveform(id).volRamp = 10 ' 10 ms
END SUB

SUB MakePlayString
    DIM s AS STRING

    IF Waveform(currentWaveform).active THEN
        s = "T" + LTRIM$(STR$(Waveform(currentWaveform).tempo)) + "L" + LTRIM$(STR$(Waveform(currentWaveform).length))

        SELECT CASE Waveform(currentWaveform).lengthType
            CASE 1
                s = s + "MN"

            CASE 2
                s = s + "ML"

            CASE 3
                s = s + "MS"
        END SELECT

        s = s + "V" + LTRIM$(STR$(Waveform(currentWaveform).volume)) + "Q" + LTRIM$(STR$(Waveform(currentWaveform).volRamp))
        s = s + "@" + LTRIM$(STR$(Waveform(currentWaveform).waveform)) + "N" + LTRIM$(STR$(Waveform(currentWaveform).note))
    END IF

    Text(currentControl) = s
END SUB

SUB MakePlayFXString
    Text(PlayFXTB) = "MB"

    IF Text(Waveform1TB) <> "" THEN
        Text(PlayFXTB) = Text(PlayFXTB) + Text(Waveform1TB)
    END IF

    IF Text(Waveform2TB) <> "" THEN
        Text(PlayFXTB) = Text(PlayFXTB) + "," + Text(Waveform2TB)
    END IF

    IF Text(Waveform3TB) <> "" THEN
        Text(PlayFXTB) = Text(PlayFXTB) + "," + Text(Waveform3TB)
    END IF

    IF Text(Waveform4TB) <> "" THEN
        Text(PlayFXTB) = Text(PlayFXTB) + "," + Text(Waveform4TB)
    END IF

    IF Text(Waveform5TB) <> "" THEN
        Text(PlayFXTB) = Text(PlayFXTB) + "," + Text(Waveform5TB)
    END IF
END SUB

': Event procedures: ---------------------------------------------------------------
SUB __UI_BeforeInit

END SUB

SUB __UI_OnLoad
    DIM i AS LONG
    FOR i = 1 TO 5
        ClearWaveform i
    NEXT

    SetConfigControls 1, Waveform1TB
    SetFocus Waveform1TB
END SUB

SUB __UI_BeforeUpdateDisplay
    'This event occurs at approximately 60 frames per second.
    'You can change the update frequency by calling SetFrameRate DesiredRate%

END SUB

SUB __UI_BeforeUnload
    'If you set __UI_UnloadSignal = False here you can
    'cancel the user's request to close.

END SUB

SUB __UI_Click (id AS LONG)
    SELECT CASE id
        CASE PlayFX

        CASE PlayFXTB

        CASE PlayBT
            PLAY Text(PlayFXTB)

        CASE WaveformSlider

        CASE WaveformNameLB

        CASE NoteSlider

        CASE LengthSlider

        CASE LengthEffectsDL

        CASE TempoSlider

        CASE VolumeSlider

        CASE NoteLB

        CASE LengthLB

        CASE TempoLB

        CASE VolumeLB

        CASE WaveformLB

        CASE PlayFXDesigner

        CASE Waveforms

        CASE Waveform1TB

        CASE Waveform2TB

        CASE Waveform3TB

        CASE Waveform4TB

        CASE Waveform5TB

        CASE ConfigureWaveform

    END SELECT
END SUB

SUB __UI_MouseEnter (id AS LONG)
    SELECT CASE id
        CASE PlayFX

        CASE PlayFXTB

        CASE PlayBT

        CASE WaveformSlider

        CASE WaveformNameLB

        CASE NoteSlider

        CASE LengthSlider

        CASE LengthEffectsDL

        CASE TempoSlider

        CASE VolumeSlider

        CASE NoteLB

        CASE LengthLB

        CASE TempoLB

        CASE VolumeLB

        CASE WaveformLB

        CASE PlayFXDesigner

        CASE Waveforms

        CASE Waveform1TB

        CASE Waveform2TB

        CASE Waveform3TB

        CASE Waveform4TB

        CASE Waveform5TB

        CASE ConfigureWaveform

    END SELECT
END SUB

SUB __UI_MouseLeave (id AS LONG)
    SELECT CASE id
        CASE PlayFX

        CASE PlayFXTB

        CASE PlayBT

        CASE WaveformSlider

        CASE WaveformNameLB

        CASE NoteSlider

        CASE LengthSlider

        CASE LengthEffectsDL

        CASE TempoSlider

        CASE VolumeSlider

        CASE NoteLB

        CASE LengthLB

        CASE TempoLB

        CASE VolumeLB

        CASE WaveformLB

        CASE PlayFXDesigner

        CASE Waveforms

        CASE Waveform1TB

        CASE Waveform2TB

        CASE Waveform3TB

        CASE Waveform4TB

        CASE Waveform5TB

        CASE ConfigureWaveform

    END SELECT
END SUB

SUB __UI_FocusIn (id AS LONG)
    SELECT CASE id
        CASE PlayFXTB

        CASE PlayBT

        CASE WaveformSlider

        CASE NoteSlider

        CASE LengthSlider

        CASE LengthEffectsDL

        CASE TempoSlider

        CASE VolumeSlider

        CASE Waveform1TB
            SetConfigControls 1, Waveform1TB

        CASE Waveform2TB
            SetConfigControls 2, Waveform2TB

        CASE Waveform3TB
            SetConfigControls 3, Waveform3TB

        CASE Waveform4TB
            SetConfigControls 4, Waveform4TB

        CASE Waveform5TB
            SetConfigControls 5, Waveform5TB

    END SELECT
END SUB

SUB __UI_FocusOut (id AS LONG)
    'This event occurs right before a control loses focus.
    'To prevent a control from losing focus, set __UI_KeepFocus = True below.
    SELECT CASE id
        CASE PlayFXTB

        CASE PlayBT

        CASE WaveformSlider

        CASE NoteSlider

        CASE LengthSlider

        CASE LengthEffectsDL

        CASE TempoSlider

        CASE VolumeSlider

        CASE Waveform1TB

        CASE Waveform2TB

        CASE Waveform3TB

        CASE Waveform4TB

        CASE Waveform5TB

    END SELECT
END SUB

SUB __UI_MouseDown (id AS LONG)
    SELECT CASE id
        CASE PlayFX

        CASE PlayFXTB

        CASE PlayBT

        CASE WaveformSlider

        CASE WaveformNameLB

        CASE NoteSlider

        CASE LengthSlider

        CASE LengthEffectsDL

        CASE TempoSlider

        CASE VolumeSlider

        CASE NoteLB

        CASE LengthLB

        CASE TempoLB

        CASE VolumeLB

        CASE WaveformLB

        CASE PlayFXDesigner

        CASE Waveforms

        CASE Waveform1TB

        CASE Waveform2TB

        CASE Waveform3TB

        CASE Waveform4TB

        CASE Waveform5TB

        CASE ConfigureWaveform

    END SELECT
END SUB

SUB __UI_MouseUp (id AS LONG)
    SELECT CASE id
        CASE PlayFX

        CASE PlayFXTB

        CASE PlayBT

        CASE WaveformSlider

        CASE WaveformNameLB

        CASE NoteSlider

        CASE LengthSlider

        CASE LengthEffectsDL

        CASE TempoSlider

        CASE VolumeSlider

        CASE NoteLB

        CASE LengthLB

        CASE TempoLB

        CASE VolumeLB

        CASE WaveformLB

        CASE PlayFXDesigner

        CASE Waveforms

        CASE Waveform1TB

        CASE Waveform2TB

        CASE Waveform3TB

        CASE Waveform4TB

        CASE Waveform5TB

        CASE ConfigureWaveform

    END SELECT
END SUB

SUB __UI_KeyPress (id AS LONG)
    'When this event is fired, __UI_KeyHit will contain the code of the key hit.
    'You can change it and even cancel it by making it = 0
    SELECT CASE id
        CASE PlayFXTB

        CASE PlayBT

        CASE WaveformSlider

        CASE NoteSlider

        CASE LengthSlider

        CASE LengthEffectsDL

        CASE TempoSlider

        CASE VolumeSlider

        CASE Waveform1TB

        CASE Waveform2TB

        CASE Waveform3TB

        CASE Waveform4TB

        CASE Waveform5TB

    END SELECT
END SUB

SUB __UI_TextChanged (id AS LONG)
    SELECT CASE id
        CASE PlayFXTB

        CASE Waveform1TB
            IF Text(id) = "" THEN
                ClearWaveform 1
                SetConfigControls 1, Waveform1TB
            END IF

        CASE Waveform2TB
            IF Text(id) = "" THEN
                ClearWaveform 2
                SetConfigControls 2, Waveform2TB
            END IF

        CASE Waveform3TB
            IF Text(id) = "" THEN
                ClearWaveform 3
                SetConfigControls 3, Waveform3TB
            END IF

        CASE Waveform4TB
            IF Text(id) = "" THEN
                ClearWaveform 4
                SetConfigControls 4, Waveform4TB
            END IF

        CASE Waveform5TB
            IF Text(id) = "" THEN
                ClearWaveform 5
                SetConfigControls 5, Waveform5TB
            END IF

    END SELECT
END SUB

SUB __UI_ValueChanged (id AS LONG)
    SELECT CASE id
        CASE WaveformSlider
            SELECT CASE Control(id).Value
                CASE 1
                    SetCaption WaveformNameLB, "Square"

                CASE 2
                    SetCaption WaveformNameLB, "Sawtooth"

                CASE 3
                    SetCaption WaveformNameLB, "Triangle"

                CASE 4
                    SetCaption WaveformNameLB, "Sine"

                CASE 5
                    SetCaption WaveformNameLB, "Noise"
            END SELECT

        CASE NoteSlider

        CASE LengthSlider

        CASE LengthEffectsDL

        CASE TempoSlider

        CASE VolumeSlider

        CASE VolRampSlider

    END SELECT

    DIM temp AS WaveformType
    temp.waveform = Control(WaveformSlider).Value
    temp.note = Control(NoteSlider).Value
    temp.length = Control(LengthSlider).Value
    temp.lengthType = Control(LengthEffectsDL).Value
    temp.tempo = Control(TempoSlider).Value
    temp.volume = Control(VolumeSlider).Value
    temp.volRamp = Control(VolRampSlider).Value

    IF IsDifferentWaveform(temp, Waveform(currentWaveform)) THEN
        Waveform(currentWaveform) = temp
        Waveform(currentWaveform).active = True
    END IF

    MakePlayString
    MakePlayFXString
END SUB

SUB __UI_FormResized

END SUB

'$INCLUDE:'../../InForm/InForm.ui'
'$INCLUDE:'../../InForm/xp.uitheme'
