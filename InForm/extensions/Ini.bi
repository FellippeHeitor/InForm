'-----------------------------------------------------------------------------------------------------------------------
' INI Manager
' Copyright (c) 2024 Samuel Gomes
' Copyright (c) 2022 Fellippe Heitor
'-----------------------------------------------------------------------------------------------------------------------

$IF INI_BI = UNDEFINED THEN
    $LET INI_BI = TRUE

    ' TODO:
    ' We should put all of this stuff into a single state type and then have just a single global to avoid possible name collisions.
    ' INI routines without namespace like prefix should also be prefixed with the "Ini_" prefix

    'Global variables declaration
    DIM currentIniFileName$, LoadedFiles$
    DIM currentIniFileLOF AS _UNSIGNED LONG
    DIM IniWholeFile$
    DIM IniSectionData$
    DIM IniPosition AS _UNSIGNED LONG
    DIM IniNewFile$
    DIM IniLastSection$
    DIM IniLastKey$
    DIM IniLF$
    DIM IniDisableAutoCommit ' _BYTE?
    DIM IniCODE ' _BYTE?
    DIM IniAllowBasicComments ' _BYTE?
    DIM IniForceReload ' _BYTE?

$END IF
