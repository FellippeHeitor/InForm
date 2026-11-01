'-----------------------------------------------------------------------------------------------------------------------
' Sorting algorithms library
' Copyright (c) 2025 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$INCLUDEONCE

''' @brief Sorts a string array (non-recursive QuickSort).
''' @param strArr() The array of strings to sort.
''' @param l The lower index of the array (inclusive).
''' @param u The upper index of the array (inclusive).
''' @param wantsAscending _TRUE = ascending, _FALSE = descending
''' @param caseSensitive _TRUE = case-sensitive, _FALSE = case-insensitive
''' @return Whether the array was changed (_TRUE or _FALSE)
FUNCTION Sort_StringArrayRange%% (strArr() AS STRING, l AS _INTEGER64, u AS _INTEGER64, wantsAscending AS _BYTE, caseSensitive AS _BYTE)
    IF l >= u THEN EXIT FUNCTION

    DIM n AS _INTEGER64: n = u - l + 1
    DIM AS _INTEGER64 top, stackL(0 TO n), stackU(0 TO n): stackL(0) = l: stackU(0) = u

    DIM AS _INTEGER64 i, j, l0, u0
    DIM AS _BYTE cmp, changed
    DIM pivot AS STRING

    WHILE top >= 0
        l0 = stackL(top)
        u0 = stackU(top)
        top = top - 1

        i = l0
        j = u0
        pivot = strArr((l0 + u0) \ 2)

        DO WHILE i <= j
            DO
                cmp = _IIF(caseSensitive, _STRCMP(strArr(i), pivot), _STRICMP(strArr(i), pivot))
                IF (wantsAscending _ANDALSO cmp < 0) _ORELSE (NOT wantsAscending _ANDALSO cmp > 0) THEN
                    i = i + 1
                ELSE
                    EXIT DO
                END IF
            LOOP

            DO
                cmp = _IIF(caseSensitive, _STRCMP(strArr(j), pivot), _STRICMP(strArr(j), pivot))
                IF (wantsAscending _ANDALSO cmp > 0) _ORELSE (NOT wantsAscending _ANDALSO cmp < 0) THEN
                    j = j - 1
                ELSE
                    EXIT DO
                END IF
            LOOP

            IF i <= j THEN
                cmp = _IIF(caseSensitive, _STRCMP(strArr(i), strArr(j)), _STRICMP(strArr(i), strArr(j)))
                IF cmp <> 0 THEN
                    SWAP strArr(i), strArr(j)
                    changed = _TRUE
                END IF
                i = i + 1
                j = j - 1
            END IF
        LOOP

        IF l0 < j THEN
            top = top + 1
            stackL(top) = l0
            stackU(top) = j
        END IF

        IF i < u0 THEN
            top = top + 1
            stackL(top) = i
            stackU(top) = u0
        END IF
    WEND

    Sort_StringArrayRange = changed
END FUNCTION

''' @brief Sorts a string array.
''' @param strArr() The array of strings to sort.
''' @return Whether the array was changed (_TRUE or _FALSE)
FUNCTION Sort_StringArray%% (strArr() AS STRING)
    Sort_StringArray = Sort_StringArrayRange(strArr(), LBOUND(strArr), UBOUND(strArr), _TRUE, _TRUE)
END FUNCTION

''' @brief Sorts a string array.
''' @param strArr() The array of strings to sort.
SUB Sort_StringArray (strArr() AS STRING)
    DIM ignored AS _BYTE: ignored = Sort_StringArrayRange(strArr(), LBOUND(strArr), UBOUND(strArr), _TRUE, _TRUE)
END SUB
