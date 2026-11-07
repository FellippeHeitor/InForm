'-----------------------------------------------------------------------------------------------------------------------
' InForm SemVer (Major.Minor.Patch). This is included by the common header file
' Copyright (c) 2026 QB64 Phoenix Edition Team
' Copyright (c) 2022 Fellippe Heitor
'-----------------------------------------------------------------------------------------------------------------------

$INCLUDEONCE

CONST __UI_VersionMajor = "2"
CONST __UI_VersionMinor = "0"
CONST __UI_VersionPatch = "0"
CONST __UI_Version = __UI_VersionMajor + _CHR_FULLSTOP + __UI_VersionMinor + _CHR_FULLSTOP + __UI_VersionPatch

$IF INFORM_VERSION_RESOURCE = DEFINED AND INFORM_VERSION_RESOURCE = TRUE THEN
    $VERSIONINFO:FILEVERSION#=2,0,0,0
    $VERSIONINFO:PRODUCTVERSION#=2,0,0,0
$END IF
