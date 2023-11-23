'-----------------------------------------------------------------------------------------------------------------------
' File I/O like routines for memory loaded files
' Copyright (c) 2023 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$IF STRINGFILE_BI = UNDEFINED THEN
    $LET STRINGFILE_BI = TRUE

    ' Simplified QB64-only memory-file
    TYPE StringFileType
        buffer AS STRING
        cursor AS _UNSIGNED LONG
    END TYPE

$END IF
