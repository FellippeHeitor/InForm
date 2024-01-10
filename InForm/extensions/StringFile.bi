'-----------------------------------------------------------------------------------------------------------------------
' File I/O like routines for memory loaded files
' Copyright (c) 2024 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$IF STRINGFILE_BI = UNDEFINED THEN
    $LET STRINGFILE_BI = TRUE

    CONST __STRINGFILE_FALSE%% = 0%%, __STRINGFILE_TRUE%% = NOT __STRINGFILE_FALSE

    ' Simplified QB64-only memory-file
    TYPE StringFileType
        buffer AS STRING
        cursor AS _UNSIGNED LONG
    END TYPE

$END IF
