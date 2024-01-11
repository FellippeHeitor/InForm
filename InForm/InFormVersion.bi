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

    ' This is only added when the file is included from UiEditor.bas
    $IF UIEDITOR_BAS = DEFINED THEN
            $VERSIONINFO:CompanyName='Samuel Gomes, George McGinn, Fellippe Heitor'
            $VERSIONINFO:FileDescription='InForm-PE Form Designer executable'
            $VERSIONINFO:InternalName='UiEditor'
            $VERSIONINFO:LegalCopyright='Copyright (c) 2024 Samuel Gomes, George McGinn, Fellippe Heitor'
            $VERSIONINFO:LegalTrademarks='All trademarks are property of their respective owners'
            $VERSIONINFO:OriginalFilename='UiEditor.exe'
            $VERSIONINFO:ProductName='InForm-PE Form Designer'
            $VERSIONINFO:Web='https://github.com/a740g/InForm-PE'
            $VERSIONINFO:Comments='https://github.com/a740g/InForm-PE'
            $VERSIONINFO:FILEVERSION#=1,5,3,0
            $VERSIONINFO:PRODUCTVERSION#=1,5,3,0
    $END IF
$END IF
