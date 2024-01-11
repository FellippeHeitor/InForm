'-----------------------------------------------------------------------------------------------------------------------
' INI Manager
' Copyright (c) 2024 Samuel Gomes
' Copyright (c) 2022 Fellippe Heitor
'-----------------------------------------------------------------------------------------------------------------------

$IF INI_BI = UNDEFINED THEN
    $LET INI_BI = TRUE

    ' TODO:
    ' We should put all of this stuff into a single state type and then have just a single global to avoid possible name collisions.
    '   That should also let us make the library load multiple INI files at the same time like the GIFPlayer library.
    ' INI routines without namespace like prefix should also be prefixed with the "Ini_" prefix.

    'Global variables declaration
    DIM currentIniFileName AS STRING
    DIM LoadedFiles AS STRING
    DIM currentIniFileLOF AS _UNSIGNED LONG
    DIM IniWholeFile AS STRING
    DIM IniSectionData AS STRING
    DIM IniPosition AS _UNSIGNED LONG
    DIM IniNewFile AS STRING
    DIM IniLastSection AS STRING
    DIM IniLastKey AS STRING
    DIM IniLF AS STRING
    DIM IniDisableAutoCommit AS _BYTE
    DIM IniCODE AS LONG
    DIM IniAllowBasicComments AS _BYTE
    DIM IniForceReload AS _BYTE

$END IF
