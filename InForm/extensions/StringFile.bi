'-----------------------------------------------------------------------------------------------------------------------
' File I/O like routines for memory loaded files
' Copyright (c) 2023 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$IF STRINGFILE_BI = UNDEFINED THEN
    $LET STRINGFILE_BI = TRUE

    $IF INFORM_BI = UNDEFINED THEN
        DEFLNG A-Z
        OPTION _EXPLICIT

        CONST FALSE = 0, TRUE = NOT FALSE
    $END IF

    ' Simplified QB64-only memory-file
    TYPE StringFileType
        buffer AS STRING
        cursor AS _UNSIGNED LONG
    END TYPE

$END IF
