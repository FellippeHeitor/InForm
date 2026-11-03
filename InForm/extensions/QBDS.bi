'-----------------------------------------------------------------------------------------------------------------------
' Data structures library for QB64-PE
' Copyright (c) 2026 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$INCLUDEONCE

'$INCLUDE:'Memory.bi'

' Data type constants
CONST QBDS_TYPE_NONE~%% = 0~%% ' unused
CONST QBDS_TYPE_RESERVED~%% = 1~%% ' metadata
CONST QBDS_TYPE_DELETED~%% = 2~%% ' tombstone
CONST QBDS_TYPE_STRING~%% = 3~%% ' variable length string
CONST QBDS_TYPE_BYTE~%% = 4~%% ' 8-bit integer
CONST QBDS_TYPE_INTEGER~%% = 5~%% ' 16-bit integer
CONST QBDS_TYPE_LONG~%% = 6~%% ' 32-bit integer
CONST QBDS_TYPE_INTEGER64~%% = 7~%% ' 64-bit integer
CONST QBDS_TYPE_SINGLE~%% = 8~%% ' 32-bit floating point number
CONST QBDS_TYPE_DOUBLE~%% = 9~%% ' 64-bit floating point number
CONST QBDS_TYPE_UDT~%% = 10~%% ' user-define data types (QBDS_TYPE_UDT .. 255)

CONST __QBDS_ITEMS_MIN = 16 ' must be a power of 2

''' @brief Compute a 64-bit FNV-1a hash.
''' @param k The string to hash.
''' @return The computed hash.
FUNCTION QBDS_Hash~&& (k AS STRING)
    DIM hash AS _UNSIGNED _INTEGER64: hash = &HCBF29CE484222325~&&
    DIM keyLength AS _UNSIGNED _OFFSET: keyLength = LEN(k)
    DIM i AS _UNSIGNED _INTEGER64: i = 1

    WHILE i <= keyLength
        hash = (hash XOR ASC(k, i)) * &H100000001B3~&&
        i = i + 1
    WEND

    QBDS_Hash = hash
END FUNCTION
