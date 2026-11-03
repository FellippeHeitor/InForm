'-----------------------------------------------------------------------------------------------------------------------
' Pathname utility library
' Copyright (c) 2026 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$INCLUDEONCE

CONST PATHNAME_DIR_SEPARATOR_CODE_WIN~%% = _ASC_BACKSLASH
CONST PATHNAME_DIR_SEPARATOR_CODE_NIX~%% = _ASC_FORWARDSLASH
CONST PATHNAME_DIR_SEPARATOR_WIN = _CHR_BACKSLASH
CONST PATHNAME_DIR_SEPARATOR_NIX = _CHR_FORWARDSLASH

$IF WINDOWS THEN
    CONST PATHNAME_DIR_SEPARATOR_CODE~%% = PATHNAME_DIR_SEPARATOR_CODE_WIN
    CONST PATHNAME_DIR_SEPARATOR = PATHNAME_DIR_SEPARATOR_WIN
$ELSE
    CONST PATHNAME_DIR_SEPARATOR_CODE~%% = PATHNAME_DIR_SEPARATOR_CODE_NIX
    CONST PATHNAME_DIR_SEPARATOR = PATHNAME_DIR_SEPARATOR_NIX
$END IF

CONST PATHNAME_DIR_CURRENT = _CHR_FULLSTOP + PATHNAME_DIR_SEPARATOR
CONST PATHNAME_DIR_PARENT = _CHR_FULLSTOP + _CHR_FULLSTOP + PATHNAME_DIR_SEPARATOR

CONST PATHNAME_EXT_SEPARATOR_CODE~%% = _ASC_FULLSTOP
CONST PATHNAME_EXT_SEPARATOR = _CHR_FULLSTOP

CONST PATHNAME_SCHEME_TERMINATOR_CODE~%% = _ASC_COLON
CONST PATHNAME_SCHEME_TERMINATOR = _CHR_COLON

''' @brief Checks if a path is absolute.
''' @param pathName The path to check.
''' @return True if the path is absolute, False otherwise.
FUNCTION Pathname_IsAbsolute%% (pathName AS STRING)
    $IF WINDOWS THEN
        ' Either \ or / or x:\ or x:/
        IF LEN(pathName) > 2 THEN
            Pathname_IsAbsolute = (ASC(pathName, 1) = PATHNAME_DIR_SEPARATOR_CODE_WIN _ORELSE ASC(pathName, 1) = PATHNAME_DIR_SEPARATOR_CODE_NIX _ORELSE ASC(pathName, 3) = PATHNAME_DIR_SEPARATOR_CODE_WIN _ORELSE ASC(pathName, 3) = PATHNAME_DIR_SEPARATOR_CODE_NIX)
        ELSEIF LEN(pathName) > 0 THEN
            Pathname_IsAbsolute = (ASC(pathName, 1) = PATHNAME_DIR_SEPARATOR_CODE_WIN _ORELSE ASC(pathName, 1) = PATHNAME_DIR_SEPARATOR_CODE_NIX)
        END IF
    $ELSE
        ' /
        IF LEN(pathName) > 0 THEN
            Pathname_IsAbsolute = (PATHNAME_DIR_SEPARATOR_CODE = ASC(pathName, 1))
        END IF
    $END IF
END FUNCTION

''' @brief Adds a directory separator to the end of the path if needed.
''' @param pathName The path to fix.
''' @return The fixed path.
FUNCTION Pathname_AddDirectorySeparator$ (pathName AS STRING)
    $IF WINDOWS THEN
        IF LEN(pathName) > 0 THEN
            IF ASC(pathName, LEN(pathName)) <> PATHNAME_DIR_SEPARATOR_CODE_WIN _ANDALSO ASC(pathName, LEN(pathName)) <> PATHNAME_DIR_SEPARATOR_CODE_NIX THEN
                Pathname_AddDirectorySeparator = pathName + PATHNAME_DIR_SEPARATOR
                EXIT FUNCTION
            END IF
        END IF
    $ELSE
        IF LEN(pathName) > 0 THEN
            IF ASC(pathName, LEN(pathName)) <> PATHNAME_DIR_SEPARATOR_CODE THEN
                Pathname_AddDirectorySeparator = pathName + PATHNAME_DIR_SEPARATOR
                EXIT FUNCTION
            END IF
        END IF
    $END IF

    Pathname_AddDirectorySeparator = pathName
END FUNCTION

''' @brief Fixes the provided filename and path to use the correct path separator.
''' @param pathName The path to fix.
''' @return The fixed path.
FUNCTION Pathname_FixDirectorySeparators$ (pathName AS STRING)
    DIM i AS _UNSIGNED LONG, buffer AS STRING: buffer = pathName

    $IF WINDOWS THEN
        DO
            i = INSTR(i + 1, buffer, PATHNAME_DIR_SEPARATOR_NIX)
            IF i THEN ASC(buffer, i) = PATHNAME_DIR_SEPARATOR_CODE_WIN
        LOOP WHILE i
    $ELSE
        DO
            i = INSTR(i + 1, buffer, PATHNAME_DIR_SEPARATOR_WIN)
            IF i THEN ASC(buffer, i) = PATHNAME_DIR_SEPARATOR_CODE_NIX
        LOOP WHILE i
    $END IF

    Pathname_FixDirectorySeparators = buffer
END FUNCTION

''' @brief Returns the filename portion from a file path or URL.
''' @param pathOrURL The path or URL to get the filename from.
''' @return The filename portion of the path or URL
FUNCTION Pathname_GetFileName$ (pathOrURL AS STRING)
    DIM AS _UNSIGNED LONG i, j: j = LEN(pathOrURL)

    $IF WINDOWS THEN
        ' Retrieve the position of the first / or \ in the parameter from the
        i = j
        WHILE i > 0
            SELECT CASE ASC(pathOrURL, i)
                CASE PATHNAME_DIR_SEPARATOR_CODE_WIN, PATHNAME_DIR_SEPARATOR_CODE_NIX
                    EXIT WHILE
            END SELECT
            i = i - 1
        WEND
    $ELSE
        i = _INSTRREV(pathOrURL, PATHNAME_DIR_SEPARATOR)
    $END IF

    ' Return the full string if pathsep was not found
    IF i = 0 THEN
        Pathname_GetFileName = pathOrURL
    ELSE
        Pathname_GetFileName = RIGHT$(pathOrURL, j - i)
    END IF
END FUNCTION

''' @brief Returns the path portion from a file path or URL.
''' @param pathOrURL The path or URL to get the path from.
''' @return The path portion of the path or URL.
FUNCTION Pathname_GetPath$ (pathOrURL AS STRING)
    DIM i AS _UNSIGNED LONG

    $IF WINDOWS THEN
        i = LEN(pathOrURL)
        WHILE i > 0
            SELECT CASE ASC(pathOrURL, i)
                CASE PATHNAME_DIR_SEPARATOR_CODE_WIN, PATHNAME_DIR_SEPARATOR_CODE_NIX
                    EXIT WHILE
            END SELECT
            i = i - 1
        WEND
    $ELSE
        i = _INSTRREV(pathOrURL, PATHNAME_DIR_SEPARATOR)
    $END IF

    IF i <> 0 THEN Pathname_GetPath = LEFT$(pathOrURL, i)
END FUNCTION

''' @brief Checks if a path or URL has a file extension.
''' @param pathOrURL The path or URL to check.
''' @return True if the path or URL has a file extension, False otherwise
FUNCTION Pathname_HasFileExtension%% (pathOrURL AS STRING)
    DIM i AS _UNSIGNED LONG: i = LEN(pathOrURL)
    WHILE i > 0
        $IF WINDOWS THEN
            SELECT CASE ASC(pathOrURL, i)
                CASE PATHNAME_DIR_SEPARATOR_CODE_WIN, PATHNAME_DIR_SEPARATOR_CODE_NIX
                    EXIT WHILE

                CASE PATHNAME_EXT_SEPARATOR_CODE
                    Pathname_HasFileExtension = _TRUE
                    EXIT WHILE
            END SELECT
        $ELSE
            SELECT CASE ASC(pathOrURL, i)
                CASE PATHNAME_DIR_SEPARATOR_CODE
                    EXIT WHILE

                CASE PATHNAME_EXT_SEPARATOR_CODE
                    Pathname_HasFileExtension = _TRUE
                    EXIT WHILE
            END SELECT
        $END IF
        i = i - 1
    WEND
END FUNCTION

''' @brief Gets the file extension from a path or URL.
''' @param pathOrURL The path or URL to get the file extension from.
''' @return The file extension of the path or URL.
FUNCTION Pathname_GetFileExtension$ (pathOrURL AS STRING)
    DIM i AS _UNSIGNED LONG: i = LEN(pathOrURL)
    WHILE i > 0
        $IF WINDOWS THEN
            SELECT CASE ASC(pathOrURL, i)
                CASE PATHNAME_DIR_SEPARATOR_CODE_WIN, PATHNAME_DIR_SEPARATOR_CODE_NIX
                    EXIT WHILE

                CASE PATHNAME_EXT_SEPARATOR_CODE
                    Pathname_GetFileExtension = RIGHT$(pathOrURL, LEN(pathOrURL) - i + 1)
                    EXIT WHILE
            END SELECT
        $ELSE
            SELECT CASE ASC(pathOrURL, i)
                CASE PATHNAME_DIR_SEPARATOR_CODE
                    EXIT WHILE

                CASE PATHNAME_EXT_SEPARATOR_CODE
                    Pathname_GetFileExtension = RIGHT$(pathOrURL, LEN(pathOrURL) - i + 1)
                    EXIT WHILE
            END SELECT
        $END IF
        i = i - 1
    WEND
END FUNCTION

''' @brief Removes the file extension from a path or URL.
''' @param pathOrURL The path or URL to remove the file extension from.
''' @return The path or URL with the file extension removed.
FUNCTION Pathname_RemoveFileExtension$ (pathOrURL AS STRING)
    DIM i AS _UNSIGNED LONG: i = LEN(pathOrURL)
    WHILE i > 0
        $IF WINDOWS THEN
            SELECT CASE ASC(pathOrURL, i)
                CASE PATHNAME_DIR_SEPARATOR_CODE_WIN, PATHNAME_DIR_SEPARATOR_CODE_NIX
                    EXIT WHILE

                CASE PATHNAME_EXT_SEPARATOR_CODE
                    Pathname_RemoveFileExtension = LEFT$(pathOrURL, i - 1)
                    EXIT FUNCTION
            END SELECT
        $ELSE
            SELECT CASE ASC(pathOrURL, i)
                CASE PATHNAME_DIR_SEPARATOR_CODE
                    EXIT WHILE

                CASE PATHNAME_EXT_SEPARATOR_CODE
                    Pathname_RemoveFileExtension = LEFT$(pathOrURL, i - 1)
                    EXIT FUNCTION
            END SELECT
        $END IF
        i = i - 1
    WEND

    Pathname_RemoveFileExtension = pathOrURL
END FUNCTION

''' @brief Returns the drive or scheme portion of a path or URL.
''' @param pathOrURL The path or URL to get the drive or scheme from.
''' @return The drive or scheme portion of the path or URL.
FUNCTION Pathname_GetDriveOrScheme$ (pathOrURL AS STRING)
    DIM i AS _UNSIGNED LONG: i = INSTR(pathOrURL, PATHNAME_SCHEME_TERMINATOR)

    IF i <> 0 THEN Pathname_GetDriveOrScheme = LEFT$(pathOrURL, i)
END FUNCTION

''' @brief Makes a pathname legal by replacing illegal characters with an underscore.
''' @param fileName The pathname to sanitize.
''' @return The sanitized pathname.
FUNCTION Pathname_Sanitize$ (fileName AS STRING)
    DIM n AS _UNSIGNED LONG: n = LEN(fileName)
    IF n THEN
        DIM s AS STRING: s = SPACE$(n)
        DIM i AS _UNSIGNED LONG, c AS _UNSIGNED _BYTE

        FOR i = 1 TO n
            c = ASC(fileName, i)
            SELECT CASE c
                CASE IS < _ASC_SPACE, PATHNAME_DIR_SEPARATOR_CODE_WIN, PATHNAME_DIR_SEPARATOR_CODE_NIX, PATHNAME_SCHEME_TERMINATOR_CODE, _ASC_QUOTE, _ASC_ASTERISK, _ASC_LESSTHAN, _ASC_GREATERTHAN, _ASC_QUESTION, _ASC_VERTICALBAR
                    ASC(s, i) = _ASC_UNDERSCORE
                CASE ELSE
                    ASC(s, i) = c
            END SELECT
        NEXT

        Pathname_Sanitize = s
    END IF
END FUNCTION
