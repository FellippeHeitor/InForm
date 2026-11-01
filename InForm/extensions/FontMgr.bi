'-----------------------------------------------------------------------------------------------------------------------
' Cross-platform TrueType / OpenType font helper library
' Copyright (c) 2026 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$INCLUDEONCE

'$INCLUDE:'Memory.bi'
'$INCLUDE:'Pathname.bi'
'$INCLUDE:'Sort.bi'

CONST __FONTMGR_PROBE_SIZE_MIN~%% = 8~% ' minimum font height that can be reported
CONST __FONTMGR_PROBE_SIZE_MAX~%% = 120~%% ' maximum font height that can be reported
CONST __FONTMGR_PLATFORM_ID_UNI~% = 0~%
CONST __FONTMGR_PLATFORM_ID_MAC~% = 1~%
CONST __FONTMGR_PLATFORM_ID_WIN~% = 3~%
CONST __FONTMGR_LANGUAGE_ID_UNI~% = 0~% ' unicode
CONST __FONTMGR_LANGUAGE_ID_MAC~% = 0~% ' mac english
CONST __FONTMGR_LANGUAGE_ID_WIN~% = 1033~% ' Windows en-us

' Bunch of nameIDs that can be passed to FontMgr_GetName()
' Note that the font may not contain all of these
CONST FONTMGR_NAME_COPYRIGHT~%% = 0~%%
CONST FONTMGR_NAME_FAMILY~%% = 1~%%
CONST FONTMGR_NAME_STYLE~%% = 2~%%
CONST FONTMGR_NAME_UNIQUE~%% = 3~%%
CONST FONTMGR_NAME_FULL~%% = 4~%%
CONST FONTMGR_NAME_VERSION~%% = 5~%%
CONST FONTMGR_NAME_POSTSCRIPT~%% = 6~%%
CONST FONTMGR_NAME_TRADEMARK~%% = 7~%%
CONST FONTMGR_NAME_MANUFACTURER~%% = 8~%%
CONST FONTMGR_NAME_DESIGNER~%% = 9~%%
CONST FONTMGR_NAME_DESCRIPTION~%% = 10~%%
CONST FONTMGR_NAME_VENDOR_URL~%% = 11~%%
CONST FONTMGR_NAME_DESIGNER_URL~%% = 12~%%
CONST FONTMGR_NAME_LICENSE_DESCRIPTION~%% = 13~%%
CONST FONTMGR_NAME_LICENSE_INFO_URL~%% = 14~%%
CONST FONTMGR_NAME_PREFERRED_FAMILY~%% = 16~%%
CONST FONTMGR_NAME_PREFERRED_SUBFAMILY~%% = 17~%%
CONST FONTMGR_NAME_COMPATIBLE_FULL~%% = 18~%%
CONST FONTMGR_NAME_SAMPLE_TEXT~%% = 19~%%
CONST FONTMGR_NAME_POSTSCRIPT_CID~%% = 20~%%

TYPE __FontMgr_TTCHeaderType
    szTag AS STRING * 4
    uMajorVersion AS _UNSIGNED INTEGER
    uMinorVersion AS _UNSIGNED INTEGER
    uNumFonts AS _UNSIGNED LONG
END TYPE

TYPE __FontMgr_TTOffsetTableType
    uMajorVersion AS _UNSIGNED INTEGER
    uMinorVersion AS _UNSIGNED INTEGER
    uNumOfTables AS _UNSIGNED INTEGER
    uSearchRange AS _UNSIGNED INTEGER
    uEntrySelector AS _UNSIGNED INTEGER
    uRangeShift AS _UNSIGNED INTEGER
END TYPE

TYPE __FontMgr_TTTableDirectoryType
    szTag AS STRING * 4
    uCheckSum AS _UNSIGNED LONG
    uOffset AS _UNSIGNED LONG
    uLength AS _UNSIGNED LONG
END TYPE

TYPE __FontMgr_TTNameTableHeaderType
    uFSelector AS _UNSIGNED INTEGER
    uNRCount AS _UNSIGNED INTEGER
    uStorageOffset AS _UNSIGNED INTEGER
END TYPE

TYPE __FontMgr_TTNameRecordType
    uPlatformID AS _UNSIGNED INTEGER
    uEncodingID AS _UNSIGNED INTEGER
    uLanguageID AS _UNSIGNED INTEGER
    uNameID AS _UNSIGNED INTEGER
    uStringLength AS _UNSIGNED INTEGER
    uStringOffset AS _UNSIGNED INTEGER
END TYPE

'-----------------------------------------------------------------------------------------------------------------------
' Test code for debugging the library
'-----------------------------------------------------------------------------------------------------------------------
'$DEBUG
'$CONSOLE:ONLY
'_DEFINE A-Z AS LONG
'OPTION _EXPLICIT

'REDIM fl(0) AS STRING

'IF FontMgr_BuildList(fl()) > 0 THEN
'    DIM i AS _UNSIGNED LONG
'    FOR i = 1 TO UBOUND(fl)
'        DIM count AS _UNSIGNED LONG: count = FontMgr_GetCount(fl(i))

'        DIM j AS _UNSIGNED LONG
'        FOR j = 0 TO count - 1
'            DIM fontName AS STRING: fontName = FontMgr_GetName(fl(i), j, FONTMGR_NAME_FULL)

'            PRINT i; "-"; j; ": "; fl(i); " ("; fontName; ")";

'            DIM AS _UNSIGNED _BYTE L, U
'            IF FontMgr_GetSizeRange(fl(i), j, L, U) THEN
'                PRINT " [ Size range:"; L; "-"; U; "]"
'            ELSE
'                PRINT
'            END IF
'        NEXT j
'    NEXT i
'ELSE
'    PRINT "Failed to build font list!"
'END IF

'END
'-----------------------------------------------------------------------------------------------------------------------

''' @brief Builds an array of fonts from that are available in the host OS (user installed + system installed).
''' @param fontList This a dynamic string array. The function will re-dimension fontList starting from 1.
''' @return The count of fonts found.
FUNCTION FontMgr_BuildList~& (fontList() AS STRING)
    ' dirStack is a stack of directories that we'll need to traverse
    REDIM dirStack(0 TO 0) AS STRING

    ' Add the user font directory to the stack
    dirStack(0) = _DIR$("USERFONT")

    ' Check if a user font directory even exists
    IF dirStack(0) <> _DIR$("HOME") THEN
        ' It does exists. So, make a spot for the system font directory
        REDIM _PRESERVE dirStack(0 TO 1) AS STRING
    END IF

    ' Add the system font directory to the stack
    ' This may overwrite the user font directory in the stack based on the check above
    dirStack(UBOUND(dirStack)) = _DIR$("FONT")

    ' This keeps the total count of fonts that we found and is returned to the caller
    DIM fontCount AS _UNSIGNED LONG

    ' Add a placeholder for the internal VGA font
    fontCount = 1
    REDIM FontFile(1 TO 1) AS STRING
    FontFile(1) = _STR_EMPTY

    ' Keep reading the directories unless we have exhausted everything in the stack
    WHILE LEN(dirStack(UBOUND(dirStack))) > 0
        ' Get the directory at the top of the stack
        DIM directory AS STRING: directory = dirStack(UBOUND(dirStack))

        ' Pop the directory
        IF UBOUND(dirStack) > 0 THEN
            REDIM _PRESERVE dirStack(0 TO UBOUND(dirStack) - 1) AS STRING
        ELSE
            dirStack(0) = _STR_EMPTY ' clear the last directory
        END IF

        ' Start getting the entries from the directory
        DIM entry AS STRING: entry = _FILES$(directory)

        DO
            IF entry <> PATHNAME_DIR_CURRENT _ANDALSO entry <> PATHNAME_DIR_PARENT _ANDALSO RIGHT$(entry, 1) = PATHNAME_DIR_SEPARATOR THEN
                ' If the entry is a legit directory, then push it to the stack
                IF LEN(dirStack(0)) > 0 THEN
                    REDIM _PRESERVE dirStack(0 TO UBOUND(dirStack) + 1) AS STRING
                    dirStack(UBOUND(dirStack)) = directory + entry
                ELSE
                    dirStack(0) = directory + entry ' this then becomes the only directory in the stack
                END IF
            ELSE
                SELECT CASE LCASE$(Pathname_GetFileExtension(entry))
                    ' Add the entry to the fontList() array if it is a legit font file name
                    ' TODO: .fon support is not implemented. See comments in other functions
                    CASE ".ttf", ".ttc", ".otf", ".fnt", ".pcf", ".bdf" ' , ".fon"
                        ' Grow the fontList array and add the complete font pathname to it
                        fontCount = fontCount + 1
                        REDIM _PRESERVE fontList(1 TO fontCount) AS STRING
                        fontList(fontCount) = directory + entry
                END SELECT
            END IF

            entry = _FILES$
        LOOP WHILE LEN(entry) > 0
    WEND

    ' Sort the array (else it looks really ugly)
    IF fontCount > 1 THEN Sort_StringArray fontList()

    FontMgr_BuildList = fontCount
END FUNCTION

''' @brief Returns the font name by directly probing a true-type font file.
''' Adapted from https://www.codeproject.com/articles/2293/retrieving-font-name-from-ttf-file.
''' QB64-PE port and TTC support by a740g.
''' Note that this has just enough code to fetch the font name and is by no means a complete TTF / TTC parser.
''' @param filePath This the font file path name.
''' @param fontIndex This is the font index inside a TTC and it is always zero based. Must be 0 for TTF & OTF.
''' @param nameId The component needed from the font's name table.
''' @return The name of the font. Invalid filePath or fontIndex will return an empty string.
FUNCTION FontMgr_GetName$ (filePath AS STRING, fontIndex AS _UNSIGNED LONG, nameId AS _UNSIGNED _BYTE)
    IF LEN(filePath) = 0 _ANDALSO fontIndex = 0 THEN
        ' VGA font special-case
        FontMgr_GetName = "Built-in VGA font"
    ELSEIF _FILEEXISTS(filePath) THEN
        ' Only proceed if the font file exists

        ' Check for non-ttf fonts and simply return the file name without the extension
        ' TODO: This is a ugly and needs a proper implementation (possibly a QB64-PE internal one ;)
        SELECT CASE LCASE$(Pathname_GetFileExtension(filePath))
            ' TODO: .fon support is not implemented. See comments in other functions
            CASE ".fnt", ".pcf", ".bdf" ', ".fon"
                IF fontIndex = 0 THEN
                    SELECT CASE nameId
                        CASE FONTMGR_NAME_FAMILY, FONTMGR_NAME_FULL, FONTMGR_NAME_PREFERRED_FAMILY, FONTMGR_NAME_COMPATIBLE_FULL
                            FontMgr_GetName = Pathname_RemoveFileExtension(Pathname_GetFileName(filePath))
                    END SELECT
                END IF
                EXIT FUNCTION
        END SELECT

        DIM f AS LONG: f = FREEFILE
        OPEN filePath FOR BINARY ACCESS READ AS f

        ' Attempt to read the TTC header
        DIM ttcHeader AS __FontMgr_TTCHeaderType
        GET f, , ttcHeader

        IF ttcHeader.szTag = "ttcf" THEN ' TTC format
            ttcHeader.uNumFonts = Memory_SwapByte32(ttcHeader.uNumFonts)

            IF fontIndex >= ttcHeader.uNumFonts THEN
                CLOSE f
                EXIT FUNCTION ' out of range
            END IF

            DIM fontBaseOffset AS _UNSIGNED LONG
            GET f, 1 + LEN(ttcHeader) + (fontIndex * _SIZE_OF_LONG), fontBaseOffset
            fontBaseOffset = Memory_SwapByte32(fontBaseOffset)
        ELSEIF fontIndex > 0 THEN
            CLOSE f
            EXIT FUNCTION ' not TTC format
        END IF

        ' If this is not a TTC, then fontBaseOffset will be set to zero. So, no harm done
        SEEK f, 1 + fontBaseOffset

        ' Read the first main table header
        DIM ttOffsetTable AS __FontMgr_TTOffsetTableType
        GET f, , ttOffsetTable
        ttOffsetTable.uMajorVersion = Memory_SwapByte16(ttOffsetTable.uMajorVersion)
        ttOffsetTable.uMinorVersion = Memory_SwapByte16(ttOffsetTable.uMinorVersion)

        ' Check is this is a true type font and the version is 1.0
        IF ttOffsetTable.uMajorVersion <> 1 _ORELSE ttOffsetTable.uMinorVersion <> 0 THEN EXIT FUNCTION

        ttOffsetTable.uNumOfTables = Memory_SwapByte16(ttOffsetTable.uNumOfTables)

        DIM i AS _UNSIGNED LONG
        WHILE i < ttOffsetTable.uNumOfTables
            DIM tblDir AS __FontMgr_TTTableDirectoryType
            GET f, , tblDir

            IF tblDir.szTag = "name" THEN
                ' We have found the name table header, now we get the length and offset of name record
                tblDir.uLength = Memory_SwapByte32(tblDir.uLength)
                tblDir.uOffset = Memory_SwapByte32(tblDir.uOffset)

                DIM ttNTHeader AS __FontMgr_TTNameTableHeaderType
                GET f, 1 + tblDir.uOffset, ttNTHeader
                ttNTHeader.uNRCount = Memory_SwapByte16(ttNTHeader.uNRCount)
                ttNTHeader.uStorageOffset = Memory_SwapByte16(ttNTHeader.uStorageOffset)

                DIM j AS _UNSIGNED LONG: j = 0
                DO WHILE j < ttNTHeader.uNRCount
                    DIM ttRecord AS __FontMgr_TTNameRecordType
                    GET f, , ttRecord
                    ttRecord.uNameID = Memory_SwapByte16(ttRecord.uNameID)
                    ttRecord.uLanguageID = Memory_SwapByte16(ttRecord.uLanguageID)
                    ttRecord.uPlatformID = Memory_SwapByte16(ttRecord.uPlatformID)

                    ' 1 specifies font name, this could be modified to get other info
                    ' mac and unicode platform id should be 0 for english
                    IF ttRecord.uNameID = nameId THEN
                        IF (ttRecord.uPlatformID = __FONTMGR_PLATFORM_ID_UNI _ANDALSO ttRecord.uLanguageID = __FONTMGR_LANGUAGE_ID_UNI) _ORELSE (ttRecord.uPlatformID = __FONTMGR_PLATFORM_ID_MAC _ANDALSO ttRecord.uLanguageID = __FONTMGR_LANGUAGE_ID_MAC) _ORELSE (ttRecord.uPlatformID = __FONTMGR_PLATFORM_ID_WIN _ANDALSO ttRecord.uLanguageID = __FONTMGR_LANGUAGE_ID_WIN) THEN
                            ttRecord.uStringLength = Memory_SwapByte16(ttRecord.uStringLength)
                            ttRecord.uStringOffset = Memory_SwapByte16(ttRecord.uStringOffset)

                            DIM nPos AS _UNSIGNED LONG: nPos = LOC(f) ' save current file position

                            IF ttRecord.uStringLength > 0 THEN
                                DIM nameBuffer AS STRING: nameBuffer = SPACE$(ttRecord.uStringLength)
                                GET f, 1 + tblDir.uOffset + ttRecord.uStringOffset + ttNTHeader.uStorageOffset, nameBuffer

                                EXIT WHILE ' break from the outer while loop
                            END IF

                            SEEK f, nPos ' search more
                        END IF
                    END IF

                    j = j + 1
                LOOP
            END IF

            i = i + 1
        WEND

        CLOSE f

        ' Get rid of null characters if the name is in unicode format
        DIM sanitizedName AS STRING
        FOR i = 1 TO LEN(nameBuffer)
            DIM char AS _UNSIGNED _BYTE: char = ASC(nameBuffer, i)
            IF char > 0 THEN sanitizedName = sanitizedName + CHR$(char)
        NEXT

        FontMgr_GetName = _TRIM$(sanitizedName)
    END IF
END FUNCTION

''' @brief Returns the number of fonts in a collection (TTC).
''' @param filePath This the font file path name.
''' @return 1 or more for valid font files. 0 for invalid font files.
FUNCTION FontMgr_GetCount~& (filePath AS STRING)
    IF LEN(filePath) = 0 THEN
        ' VGA font special-case
        FontMgr_GetCount = 1
    ELSEIF _FILEEXISTS(filePath) THEN
        ' Check for non-ttf fonts and simply return 1
        ' TODO: This is a ugly and needs a proper implementation (possibly a QB64-PE internal one ;)
        DIM extension AS STRING: extension = LCASE$(Pathname_GetFileExtension(filePath))
        SELECT CASE extension
            ' TODO: .fon files are muti-font resource files and should be handled correctly
            ' NOTE: Some .otf font have a ttc header but contains bogus
            CASE ".fnt", ".pcf", ".bdf", ".otf" ', ".fon"
                FontMgr_GetCount = 1
                EXIT FUNCTION
        END SELECT

        DIM f AS LONG: f = FREEFILE
        OPEN filePath FOR BINARY ACCESS READ AS f

        DIM ttcHeader AS __FontMgr_TTCHeaderType
        GET f, , ttcHeader

        IF ttcHeader.szTag = "ttcf" THEN ' TTC format
            FontMgr_GetCount = Memory_SwapByte32(ttcHeader.uNumFonts)
            CLOSE f
            EXIT FUNCTION
        END IF

        SEEK f, 1

        DIM ttOffsetTable AS __FontMgr_TTOffsetTableType
        GET f, , ttOffsetTable
        ttOffsetTable.uMajorVersion = Memory_SwapByte16(ttOffsetTable.uMajorVersion)
        ttOffsetTable.uMinorVersion = Memory_SwapByte16(ttOffsetTable.uMinorVersion)

        IF ttOffsetTable.uMajorVersion = 1 _ANDALSO ttOffsetTable.uMinorVersion = 0 _ANDALSO extension = ".ttf" THEN ' also do a file extension check (.otf checked above)
            FontMgr_GetCount = 1 ' regular TTF
        END IF

        CLOSE f
    END IF
END FUNCTION

''' @brief Probes and returns the supported font size range (useful for bitmap fonts).
''' @param filePath This the font file path name.
''' @param fontIndex This is the font index inside a TTC and it is always zero based. Must be 0 for TTF & OTF.
''' @param outMinSize [OUT] The minimum size supported by the font.
''' @param outMaxSize [OUT] The maximum size supported by the font.
''' @return True if a valid size range was probed.
FUNCTION FontMgr_GetSizeRange%% (filePath AS STRING, fontIndex AS _UNSIGNED LONG, outMinSize AS _UNSIGNED _BYTE, outMaxSize AS _UNSIGNED _BYTE)
    IF LEN(filePath) = 0 _ANDALSO fontIndex = 0 THEN
        ' VGA font special-case
        ' This is not really a range and the caller is expected to do special handling for the internal VGA font
        outMinSize = __FONTMGR_PROBE_SIZE_MIN
        outMaxSize = 16

        FontMgr_GetSizeRange = _TRUE
    ELSEIF _FILEEXISTS(filePath) THEN
        ' There is no point doing this for scalable fonts
        ' Just set the min and max and exit
        SELECT CASE LCASE$(Pathname_GetFileExtension(filePath))
            CASE ".ttf", ".ttc", ".otf"
                outMinSize = __FONTMGR_PROBE_SIZE_MIN
                outMaxSize = __FONTMGR_PROBE_SIZE_MAX

                FontMgr_GetSizeRange = _TRUE
                EXIT FUNCTION
        END SELECT

        DIM AS _UNSIGNED _BYTE minSize, maxSize
        minSize = __FONTMGR_PROBE_SIZE_MAX + 1 ' set this to an impossible positive value

        DIM i AS LONG
        ' I've seen some crazy short bitmap fonts. So, we'll go with 3 here
        FOR i = 3 TO __FONTMGR_PROBE_SIZE_MAX
            ' Attempt to load the font
            DIM fontHandle AS LONG: fontHandle = _LOADFONT(filePath, i, , fontIndex)

            IF fontHandle > 0 THEN
                ' Record the min and max sizes if the font loaded successfully
                IF minSize > i THEN minSize = i
                IF maxSize < i THEN maxSize = i

                _FREEFONT fontHandle ' free the font
            END IF
        NEXT i

        IF minSize <= maxSize THEN
            ' Only signal success if at least one font size was successfully probed
            outMinSize = minSize
            outMaxSize = maxSize

            FontMgr_GetSizeRange = _TRUE
        END IF
    END IF
END FUNCTION
