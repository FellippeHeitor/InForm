'-----------------------------------------------------------------------------------------------------------------------
' InForm SemVer (Major.Minor.Patch). This is included by the common header file
' Copyright (c) 2024 Samuel Gomes
' Copyright (c) 2022 Fellippe Heitor
'-----------------------------------------------------------------------------------------------------------------------

$IF INFORMVERSION_BI = UNDEFINED THEN
    $LET INFORMVERSION_BI = TRUE

    CONST __UI_VersionMajor = "1"
    CONST __UI_VersionMinor = "5"
    CONST __UI_VersionPatch = "3"
    CONST __UI_Version = __UI_VersionMajor + "." + __UI_VersionMinor + "." + __UI_VersionPatch

$END IF
