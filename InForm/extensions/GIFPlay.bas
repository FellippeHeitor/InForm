'-----------------------------------------------------------------------------------------------------------------------
' Animated GIF Player library
' Copyright (c) 2023 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$IF GIFPLAY_BAS = UNDEFINED THEN
    $LET GIFPLAY_BAS = TRUE

    '$INCLUDE:'GIFPlay.bi'

    FUNCTION GIF_OpenFile%% (Id AS LONG, fileName AS STRING)
    END FUNCTION


    FUNCTION GIF_OpenMemory%% (Id AS LONG, buffer AS STRING)
    END FUNCTION


    SUB GIF_Close (Id AS LONG)
    END SUB


    FUNCTION GIF_GetHeight~% (Id AS LONG)
    END FUNCTION


    FUNCTION GIF_GetWidth~% (Id AS LONG)
    END FUNCTION


    FUNCTION GIF_GetCurrentFrame~& (Id AS LONG)
    END FUNCTION


    FUNCTION GIF_GetTotalFrames~& (Id AS LONG)
    END FUNCTION


    SUB GIF_SetPlaybackDirection (Id AS LONG, direction AS _BYTE)
    END SUB


    FUNCTION GIF_GetPlaybackDirection%% (Id AS LONG)
    END FUNCTION


    SUB GIF_Play (Id AS LONG)
    END SUB


    SUB GIF_Pause (Id AS LONG)
    END SUB


    SUB GIF_Stop (Id AS LONG)
    END SUB


    FUNCTION GIF_IsPlaying%% (Id AS LONG)
    END FUNCTION


    SUB GIF_Draw (Id AS LONG)
    END SUB


    SUB GIF_DrawPro (Id AS LONG, x AS LONG, y AS LONG)
    END SUB


    FUNCTION GIF_GetFrame& (Id AS LONG)
    END FUNCTION


    SUB GIF_EnableOverlay (Id AS LONG, isEnabled AS _BYTE)
    END SUB


    ' Returns the __GIFPlay index of a loaded GIF using it's ID
    ' TODO: Fix line in UiEditorPreview: IF GIF_GetIndex(i) > 0 THEN
    FUNCTION GIF_GetIndex~& (Id AS LONG)
    END FUNCTION

    '$INCLUDE:'HashTable.bas'
    '$INCLUDE:'StringFile.bas'
    '$INCLUDE:'Base64.bas'

$END IF
