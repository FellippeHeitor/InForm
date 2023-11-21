'-----------------------------------------------------------------------------------------------------------------------
' A simple hash table for integers and QB64 handles
' Copyright (c) 2023 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$IF HASHTABLE_BI = UNDEFINED THEN
    $LET HASHTABLE_BI = TRUE

    $IF INFORM_BI = UNDEFINED THEN
        DEFLNG A-Z
        OPTION _EXPLICIT

        CONST FALSE = 0, TRUE = NOT FALSE
    $END IF

    CONST __HASHTABLE_KEY_EXISTS = -1
    CONST __HASHTABLE_KEY_UNAVAILABLE = -2

    ' Hash table entry type
    TYPE HashTableType
        U AS _BYTE ' used?
        K AS _UNSIGNED LONG ' key
        V AS LONG ' value
        ' <- add other value types here and then write wrappers
        ' around __HashTable_GetInsertIndex() & __HashTable_GetLookupIndex()
    END TYPE

$END IF
