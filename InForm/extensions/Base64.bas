'-----------------------------------------------------------------------------------------------------------------------
' Base64 Encoder and Decoder library
' Copyright (c) 2023 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$IF BASE64_BAS = UNDEFINED THEN
    $LET BASE64_BAS = TRUE

    '-------------------------------------------------------------------------------------------------------------------
    ' Test code for debugging the library
    '-------------------------------------------------------------------------------------------------------------------
    'DEFLNG A-Z
    'OPTION _EXPLICIT

    'CONST ITERATIONS = 1000000
    'CONST LOREM_IPSUM = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut " + _
    '    "labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip " + _
    '    "ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat " + _
    '    "nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

    'DIM encTxt AS STRING, decTxt AS STRING, i AS LONG, t AS DOUBLE

    'PRINT ITERATIONS; "iterations,"; LEN(LOREM_IPSUM); "bytes."

    'PRINT "Base64 encode..."

    't = TIMER
    'FOR i = 1 TO ITERATIONS
    '    encTxt = Base64_Encode(LOREM_IPSUM)
    'NEXT
    'PRINT USING "#####.##### seconds"; TIMER - t

    'PRINT "Base64 decode..."

    't = TIMER
    'FOR i = 1 TO ITERATIONS
    '    decTxt = Base64_Decode(encTxt)
    'NEXT
    'PRINT USING "#####.##### seconds"; TIMER - t

    'IF _STRCMP(decTxt, LOREM_IPSUM) = 0 THEN
    '    PRINT "Passed"
    'ELSE
    '    PRINT "Failed"
    'END IF

    'END
    '-------------------------------------------------------------------------------------------------------------------

    ' Converts a normal string or binary data to a base64 string
    FUNCTION Base64_Encode$ (s AS STRING)
        CONST BASE64_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

        DIM srcSize AS _UNSIGNED LONG: srcSize = LEN(s)
        DIM srcSize3rem AS _UNSIGNED LONG: srcSize3rem = srcSize MOD 3
        DIM srcSize3mul AS _UNSIGNED LONG: srcSize3mul = srcSize - srcSize3rem
        DIM buffer AS STRING: buffer = SPACE$(((srcSize + 2) \ 3) * 4) ' preallocate complete buffer
        DIM j AS _UNSIGNED LONG: j = 1

        DIM i AS _UNSIGNED LONG: FOR i = 1 TO srcSize3mul STEP 3
            DIM char1 AS _UNSIGNED _BYTE: char1 = ASC(s, i)
            DIM char2 AS _UNSIGNED _BYTE: char2 = ASC(s, i + 1)
            DIM char3 AS _UNSIGNED _BYTE: char3 = ASC(s, i + 2)

            ASC(buffer, j) = ASC(BASE64_CHARACTERS, 1 + (_SHR(char1, 2)))
            j = j + 1
            ASC(buffer, j) = ASC(BASE64_CHARACTERS, 1 + (_SHL((char1 AND 3), 4) OR _SHR(char2, 4)))
            j = j + 1
            ASC(buffer, j) = ASC(BASE64_CHARACTERS, 1 + (_SHL((char2 AND 15), 2) OR _SHR(char3, 6)))
            j = j + 1
            ASC(buffer, j) = ASC(BASE64_CHARACTERS, 1 + (char3 AND 63))
            j = j + 1
        NEXT i

        ' Add padding
        IF srcSize3rem > 0 THEN
            char1 = ASC(s, i)

            ASC(buffer, j) = ASC(BASE64_CHARACTERS, 1 + (_SHR(char1, 2)))
            j = j + 1

            IF srcSize3rem = 1 THEN
                ASC(buffer, j) = ASC(BASE64_CHARACTERS, 1 + (_SHL(char1 AND 3, 4)))
                j = j + 1
                ASC(buffer, j) = 61 ' "="
                j = j + 1
                ASC(buffer, j) = 61 ' "="
            ELSE ' srcSize3rem = 2
                char2 = ASC(s, i + 1)

                ASC(buffer, j) = ASC(BASE64_CHARACTERS, 1 + (_SHL((char1 AND 3), 4) OR _SHR(char2, 4)))
                j = j + 1
                ASC(buffer, j) = ASC(BASE64_CHARACTERS, 1 + (_SHL(char2 AND 15, 2)))
                j = j + 1
                ASC(buffer, j) = 61 ' "="
            END IF
        END IF

        Base64_Encode = buffer
    END FUNCTION


    ' Converts a base64 string to a normal string or binary data
    FUNCTION Base64_Decode$ (s AS STRING)
        DIM srcSize AS _UNSIGNED LONG: srcSize = LEN(s)
        DIM buffer AS STRING: buffer = SPACE$((srcSize \ 4) * 3) ' preallocate complete buffer
        DIM j AS _UNSIGNED LONG: j = 1
        DIM AS _UNSIGNED _BYTE index, char1, char2, char3, char4

        DIM i AS _UNSIGNED LONG: FOR i = 1 TO srcSize STEP 4
            index = ASC(s, i): GOSUB find_index: char1 = index
            index = ASC(s, i + 1): GOSUB find_index: char2 = index
            index = ASC(s, i + 2): GOSUB find_index: char3 = index
            index = ASC(s, i + 3): GOSUB find_index: char4 = index

            ASC(buffer, j) = _SHL(char1, 2) OR _SHR(char2, 4)
            j = j + 1
            ASC(buffer, j) = _SHL(char2 AND 15, 4) OR _SHR(char3, 2)
            j = j + 1
            ASC(buffer, j) = _SHL(char3 AND 3, 6) OR char4
            j = j + 1
        NEXT i

        ' Remove padding
        IF RIGHT$(s, 2) = "==" THEN
            buffer = LEFT$(buffer, LEN(buffer) - 2)
        ELSEIF RIGHT$(s, 1) = "=" THEN
            buffer = LEFT$(buffer, LEN(buffer) - 1)
        END IF

        Base64_Decode = buffer
        EXIT FUNCTION

        find_index:
        IF index >= 65 AND index <= 90 THEN
            index = index - 65
        ELSEIF index >= 97 AND index <= 122 THEN
            index = index - 97 + 26
        ELSEIF index >= 48 AND index <= 57 THEN
            index = index - 48 + 52
        ELSEIF index = 43 THEN
            index = 62
        ELSEIF index = 47 THEN
            index = 63
        END IF
        RETURN
    END FUNCTION


    ' This function loads a resource directly from a string variable or constant (like the ones made by Bin2Data)
    FUNCTION Base64_LoadResourceString$ (src AS STRING, ogSize AS _UNSIGNED LONG, isComp AS _BYTE)
        ' Decode the data
        DIM buffer AS STRING: buffer = Base64_Decode(src)

        ' Expand the data if needed
        IF isComp THEN buffer = _INFLATE$(buffer, ogSize)

        Base64_LoadResourceString = buffer
    END FUNCTION


    ' Loads a binary file encoded with Bin2Data
    ' Usage:
    '   1. Encode the binary file with Bin2Data
    '   2. Include the file or it's contents
    '   3. Load the file like so:
    '       Restore label_generated_by_bin2data
    '       Dim buffer As String
    '       buffer = LoadResource   ' buffer will now hold the contents of the file
    FUNCTION Base64_LoadResourceData$
        DIM ogSize AS _UNSIGNED LONG, resize AS _UNSIGNED LONG, isComp AS _BYTE
        READ ogSize, resize, isComp ' read the header

        DIM buffer AS STRING: buffer = SPACE$(resize) ' preallocate complete buffer

        ' Read the whole resource data
        DIM i AS _UNSIGNED LONG: DO WHILE i < resize
            DIM chunk AS STRING: READ chunk
            MID$(buffer, i + 1) = chunk
            i = i + LEN(chunk)
        LOOP

        ' Decode the data
        buffer = Base64_Decode(buffer)

        ' Expand the data if needed
        IF isComp THEN buffer = _INFLATE$(buffer, ogSize)

        Base64_LoadResourceData = buffer
    END FUNCTION

$END IF
