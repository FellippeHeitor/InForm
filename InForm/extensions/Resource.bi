'-----------------------------------------------------------------------------------------------------------------------
' Base64 resource loading library
' Copyright (c) 2026 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$INCLUDEONCE

''' @brief Loads a binary file encoded with Bin2Data (CONST).
''' @param src The base64 STRING containing the encoded data.
''' @param ogSize The original size of the data.
''' @param isComp Whether the data is compressed.
''' @return The normal STRING or binary data.
FUNCTION Resource_LoadBase64String$ (src AS STRING, ogSize AS _UNSIGNED LONG, isComp AS _BYTE)
    ' Decode the data
    DIM buffer AS STRING: buffer = _BASE64DECODE$(src)

    ' Expand the data if needed
    IF isComp THEN buffer = _INFLATE$(buffer, ogSize)

    Resource_LoadBase64String = buffer
END FUNCTION

''' @brief Loads a binary file encoded with Bin2Data (DATA).
''' Usage:
'''   1. Encode the binary file with Bin2Data.
'''   2. Include the file or its contents.
'''   3. Load the file like so:
'''       Restore label_generated_by_bin2data
'''       Dim buffer As String
'''       buffer = Resource_LoadBase64Data
''' @return The normal STRING or binary data.
FUNCTION Resource_LoadBase64Data$
    DIM ogSize AS _UNSIGNED LONG, datSize AS _UNSIGNED LONG, isComp AS _BYTE
    READ ogSize, datSize, isComp ' read the header

    DIM buffer AS STRING: buffer = SPACE$(datSize) ' preallocate complete buffer

    ' Read the whole resource data
    DIM i AS _UNSIGNED LONG: DO WHILE i < datSize
        DIM chunk AS STRING: READ chunk
        MID$(buffer, i + 1) = chunk
        i = i + LEN(chunk)
    LOOP

    ' Decode the data
    buffer = _BASE64DECODE$(buffer)

    ' Expand the data if needed
    IF isComp THEN buffer = _INFLATE$(buffer, ogSize)

    Resource_LoadBase64Data = buffer
END FUNCTION
