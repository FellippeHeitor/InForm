'-----------------------------------------------------------------------------------------------------------------------
' Generic hash set library for QB64-PE
' Copyright (c) 2026 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$INCLUDEONCE

'$INCLUDE:'QBDS.bi'

''' @brief Primary data structure used by the HSet library.
''' The user declares a dynamic array of this type and passes it to the HSet_* functions.
''' The library stores internal metadata at array index 0; user entries begin at index 1.
''' Metadata (stored in element 0):
'''     - V: count of items (_MK$(_UNSIGNED _OFFSET, count))
'''     - T: QBDS_TYPE_RESERVED
TYPE HSet
    V AS STRING
    T AS _UNSIGNED _BYTE
END TYPE

''' @brief Check whether the set has been initialized.
''' @param set The dynamic set array to check.
''' @return _TRUE if initialized, otherwise _FALSE.
FUNCTION HSet_IsInitialized%% (set() AS HSet)
    HSet_IsInitialized = LBOUND(set) = 0 _ANDALSO UBOUND(set) > 0 _ANDALSO set(0).T = QBDS_TYPE_RESERVED _ANDALSO LEN(set(0).V) = _SIZE_OF_OFFSET
END FUNCTION

''' @brief Initialize a set.
''' @param set The dynamic set array to initialize.
SUB HSet_Initialize (set() AS HSet)
    REDIM set(0 TO __QBDS_ITEMS_MIN) AS HSet
    set(0).T = QBDS_TYPE_RESERVED
    set(0).V = _MK$(_UNSIGNED _OFFSET, 0) ' Store count
END SUB

''' @brief Clear the set, but do not change the capacity.
''' @param set The set to clear.
SUB HSet_Clear (set() AS HSet)
    REDIM set(0 TO _MAX(__QBDS_ITEMS_MIN, UBOUND(set))) AS HSet
    set(0).V = _MK$(_UNSIGNED _OFFSET, 0) ' Reset count
    set(0).T = QBDS_TYPE_RESERVED
END SUB

''' @brief Delete the set and free all associated memory.
''' @param set The set to free.
SUB HSet_Free (set() AS HSet)
    REDIM set(0) AS HSet
END SUB

''' @brief Return the current capacity of the set's underlying array.
''' @param set The set to query.
''' @return The total number of slots in the set.
FUNCTION HSet_GetCapacity~%& (set() AS HSet)
    HSet_GetCapacity = UBOUND(set)
END FUNCTION

''' @brief Return the number of items currently stored in the set.
''' @param set The set to query.
''' @return The number of items.
FUNCTION HSet_GetCount~%& (set() AS HSet)
    HSet_GetCount = _CV(_UNSIGNED _OFFSET, set(0).V)
END FUNCTION

''' @brief Resize the set and rehash all user entries.
''' @param set The dynamic set array to resize.
SUB __HSet_ResizeAndRehash (set() AS HSet)
    DIM oldCapacity AS _UNSIGNED _OFFSET: oldCapacity = UBOUND(set)
    DIM tempSet(0 TO oldCapacity) AS HSet

    ' Make a copy of the old set
    DIM i AS _UNSIGNED _OFFSET
    WHILE i <= oldCapacity
        tempSet(i).V = set(i).V
        tempSet(i).T = set(i).T
        i = i + 1
    WEND

    DIM newCapacity AS _UNSIGNED _OFFSET: newCapacity = _MAX(__QBDS_ITEMS_MIN, _SHL(oldCapacity, 1)) ' Grow by power of 2
    DIM newMask AS _UNSIGNED _OFFSET: newMask = newCapacity - 1
    REDIM set(0 TO newCapacity) AS HSet

    ' Copy metadata
    set(0).V = tempSet(0).V
    set(0).T = tempSet(0).T

    DIM AS _UNSIGNED _OFFSET hash, probeIndex, j

    i = 1
    WHILE i <= oldCapacity
        IF tempSet(i).T > QBDS_TYPE_DELETED THEN
            hash = QBDS_Hash(tempSet(i).V) AND newMask

            j = 0
            WHILE j < newCapacity
                probeIndex = 1 + (hash + j) AND newMask

                IF set(probeIndex).T = QBDS_TYPE_NONE THEN
                    set(probeIndex).T = tempSet(i).T
                    set(probeIndex).V = tempSet(i).V
                    EXIT WHILE
                END IF

                j = j + 1
            WEND

            IF j >= newCapacity THEN
                ERROR _ERR_INTERNAL_ERROR
                EXIT SUB
            END IF
        END IF

        i = i + 1
    WEND
END SUB

''' @brief Find a value in the set.
''' @param set The set to search.
''' @param v The value to find.
''' @return The index of the value in the set, or 0 if not found.
FUNCTION __HSet_Find~%& (set() AS HSet, v AS STRING)
    DIM capacity AS _UNSIGNED _OFFSET: capacity = UBOUND(set)
    DIM mask AS _UNSIGNED _OFFSET: mask = capacity - 1
    DIM hash AS _UNSIGNED _OFFSET: hash = QBDS_Hash(v) AND mask
    DIM AS _UNSIGNED _OFFSET i, probeIndex

    WHILE i < capacity
        probeIndex = 1 + (hash + i) AND mask ' + 1 for metadata

        DIM currentType AS _UNSIGNED _BYTE: currentType = set(probeIndex).T

        IF currentType = QBDS_TYPE_NONE THEN
            EXIT WHILE ' end of probe chain, value not found
        ELSEIF currentType <> QBDS_TYPE_DELETED _ANDALSO set(probeIndex).V = v THEN
            __HSet_Find = probeIndex
            EXIT WHILE ' value found
        END IF

        i = i + 1
    WEND
END FUNCTION

''' @brief Add a value to the set.
''' @param set The set to add to.
''' @param v The value to add.
''' @param dataType The type of the value.
SUB __HSet_Add (set() AS HSet, v AS STRING, dataType AS _UNSIGNED _BYTE)
    DIM capacity AS _UNSIGNED _OFFSET: capacity = UBOUND(set)
    DIM mask AS _UNSIGNED _OFFSET: mask = capacity - 1
    DIM hash AS _UNSIGNED _OFFSET: hash = QBDS_Hash(v) AND mask
    DIM AS _UNSIGNED _OFFSET i, probeIndex, entryCount, insertSlot

    WHILE i < capacity
        probeIndex = 1 + (hash + i) AND mask ' + 1 for metadata
        DIM currentType AS _UNSIGNED _BYTE: currentType = set(probeIndex).T

        IF currentType = QBDS_TYPE_NONE THEN
            IF insertSlot = 0 THEN insertSlot = probeIndex
            EXIT WHILE ' End of probe chain
        ELSEIF currentType = QBDS_TYPE_DELETED THEN
            IF insertSlot = 0 THEN insertSlot = probeIndex
        ELSE ' Slot is active
            IF set(probeIndex).V = v THEN
                ' Value already exists. Update the type and exit
                set(probeIndex).T = dataType
                EXIT SUB
            END IF
        END IF

        i = i + 1 ' try the next one
    WEND

    ' If we are here, the value does not exist, so insert it
    IF insertSlot = 0 THEN
        ' This should not happen if resize logic is correct
        ERROR _ERR_INTERNAL_ERROR
        EXIT SUB
    END IF

    set(insertSlot).T = dataType
    set(insertSlot).V = v

    ' Increase count
    entryCount = _CV(_UNSIGNED _OFFSET, set(0).V) + 1
    set(0).V = _MK$(_UNSIGNED _OFFSET, entryCount)

    ' Check if we need to resize the table before we exit
    IF entryCount >= (capacity - _SHR(capacity, 2)) THEN
        ' Triggers when the entry count is 75% or more of the table size
        __HSet_ResizeAndRehash set()
    END IF
END SUB

''' @brief Remove a value from the set.
''' @param set The set to remove from.
''' @param v The value to remove.
''' @return True if the value was removed, false otherwise.
FUNCTION __HSet_Remove%% (set() AS HSet, v AS STRING)
    DIM slot AS _UNSIGNED _OFFSET: slot = __HSet_Find(set(), v)
    IF slot THEN
        set(slot).T = QBDS_TYPE_DELETED
        set(slot).V = _STR_EMPTY

        set(0).V = _MK$(_UNSIGNED _OFFSET, _CV(_UNSIGNED _OFFSET, set(0).V) - 1)

        __HSet_Remove = _TRUE
    END IF
END FUNCTION

''' @brief Check if a value exists in the set.
''' @param set The set to check.
''' @param v The value to check.
''' @return True if the value exists, false otherwise.
FUNCTION __HSet_Contains%% (set() AS HSet, v AS STRING)
    __HSet_Contains = __HSet_Find(set(), v) <> 0
END FUNCTION

''' @brief Add a string to the set.
''' @param set The set to add to.
''' @param v The string to add.
SUB HSet_AddString (set() AS HSet, v AS STRING)
    __HSet_Add set(), v, QBDS_TYPE_STRING
END SUB

''' @brief Check if a string exists in the set.
''' @param set The set to check.
''' @param v The string to check.
FUNCTION HSet_ContainsString%% (set() AS HSet, v AS STRING)
    HSet_ContainsString = __HSet_Contains(set(), v)
END FUNCTION

''' @brief Remove a string from the set.
''' @param set The set to remove from.
''' @param v The string to remove.
''' @return True if the string was removed, false otherwise.
FUNCTION HSet_RemoveString%% (set() AS HSet, v AS STRING)
    HSet_RemoveString = __HSet_Remove(set(), v)
END FUNCTION

''' @brief Remove a string from the set.
''' @param set The set to remove from.
''' @param v The string to remove.
SUB HSet_RemoveString (set() AS HSet, v AS STRING)
    DIM ignored AS _BYTE: ignored = __HSet_Remove(set(), v)
END SUB

''' @brief Add a byte to the set.
''' @param set The set to add to.
''' @param v The byte to add.
SUB HSet_AddByte (set() AS HSet, v AS _BYTE)
    __HSet_Add set(), _MK$(_BYTE, v), QBDS_TYPE_BYTE
END SUB

''' @brief Check if a byte exists in the set.
''' @param set The set to check.
''' @param v The byte to check.
FUNCTION HSet_ContainsByte%% (set() AS HSet, v AS _BYTE)
    HSet_ContainsByte = __HSet_Contains(set(), _MK$(_BYTE, v))
END FUNCTION

''' @brief Remove a byte from the set.
''' @param set The set to remove from.
''' @param v The byte to remove.
FUNCTION HSet_RemoveByte%% (set() AS HSet, v AS _BYTE)
    HSet_RemoveByte = __HSet_Remove(set(), _MK$(_BYTE, v))
END FUNCTION

''' @brief Remove a byte from the set.
''' @param set The set to remove from.
''' @param v The byte to remove.
SUB HSet_RemoveByte (set() AS HSet, v AS _BYTE)
    DIM ignored AS _BYTE: ignored = __HSet_Remove(set(), _MK$(_BYTE, v))
END SUB

''' @brief Add an integer to the set.
''' @param set The set to add to.
''' @param v The integer to add.
SUB HSet_AddInteger (set() AS HSet, v AS INTEGER)
    __HSet_Add set(), MKI$(v), QBDS_TYPE_INTEGER
END SUB

''' @brief Check if an integer exists in the set.
''' @param set The set to check.
''' @param v The integer to check.
FUNCTION HSet_ContainsInteger%% (set() AS HSet, v AS INTEGER)
    HSet_ContainsInteger = __HSet_Contains(set(), MKI$(v))
END FUNCTION

''' @brief Remove an integer from the set.
''' @param set The set to remove from.
''' @param v The integer to remove.
FUNCTION HSet_RemoveInteger%% (set() AS HSet, v AS INTEGER)
    HSet_RemoveInteger = __HSet_Remove(set(), MKI$(v))
END FUNCTION

''' @brief Remove an integer from the set.
''' @param set The set to remove from.
''' @param v The integer to remove.
SUB HSet_RemoveInteger (set() AS HSet, v AS INTEGER)
    DIM ignored AS _BYTE: ignored = __HSet_Remove(set(), MKI$(v))
END SUB

''' @brief Add a long to the set.
''' @param set The set to add to.
''' @param v The long to add.
SUB HSet_AddLong (set() AS HSet, v AS LONG)
    __HSet_Add set(), MKL$(v), QBDS_TYPE_LONG
END SUB

''' @brief Check if a long exists in the set.
''' @param set The set to check.
''' @param v The long to check.
FUNCTION HSet_ContainsLong%% (set() AS HSet, v AS LONG)
    HSet_ContainsLong = __HSet_Contains(set(), MKL$(v))
END FUNCTION

''' @brief Remove a long from the set.
''' @param set The set to remove from.
''' @param v The long to remove.
FUNCTION HSet_RemoveLong%% (set() AS HSet, v AS LONG)
    HSet_RemoveLong = __HSet_Remove(set(), MKL$(v))
END FUNCTION

''' @brief Remove a long from the set.
''' @param set The set to remove from.
''' @param v The long to remove.
SUB HSet_RemoveLong (set() AS HSet, v AS LONG)
    DIM ignored AS _BYTE: ignored = __HSet_Remove(set(), MKL$(v))
END SUB

''' @brief Add an integer64 to the set.
''' @param set The set to add to.
''' @param v The integer64 to add.
SUB HSet_AddInteger64 (set() AS HSet, v AS _INTEGER64)
    __HSet_Add set(), _MK$(_INTEGER64, v), QBDS_TYPE_INTEGER64
END SUB

''' @brief Check if an integer64 exists in the set.
''' @param set The set to check.
''' @param v The integer64 to check.
FUNCTION HSet_ContainsInteger64%% (set() AS HSet, v AS _INTEGER64)
    HSet_ContainsInteger64 = __HSet_Contains(set(), _MK$(_INTEGER64, v))
END FUNCTION

''' @brief Remove an integer64 from the set.
''' @param set The set to remove from.
''' @param v The integer64 to remove.
FUNCTION HSet_RemoveInteger64%% (set() AS HSet, v AS _INTEGER64)
    HSet_RemoveInteger64 = __HSet_Remove(set(), _MK$(_INTEGER64, v))
END FUNCTION

''' @brief Remove an integer64 from the set.
''' @param set The set to remove from.
''' @param v The integer64 to remove.
SUB HSet_RemoveInteger64 (set() AS HSet, v AS _INTEGER64)
    DIM ignored AS _BYTE: ignored = __HSet_Remove(set(), _MK$(_INTEGER64, v))
END SUB

''' @brief Add a single to the set.
''' @param set The set to add to.
''' @param v The single to add.
SUB HSet_AddSingle (set() AS HSet, v AS SINGLE)
    __HSet_Add set(), MKS$(v), QBDS_TYPE_SINGLE
END SUB

''' @brief Check if a single exists in the set.
''' @param set The set to check.
''' @param v The single to check.
FUNCTION HSet_ContainsSingle%% (set() AS HSet, v AS SINGLE)
    HSet_ContainsSingle = __HSet_Contains(set(), MKS$(v))
END FUNCTION

''' @brief Remove a single from the set.
''' @param set The set to remove from.
''' @param v The single to remove.
FUNCTION HSet_RemoveSingle%% (set() AS HSet, v AS SINGLE)
    HSet_RemoveSingle = __HSet_Remove(set(), MKS$(v))
END FUNCTION

''' @brief Remove a single from the set.
''' @param set The set to remove from.
''' @param v The single to remove.
SUB HSet_RemoveSingle (set() AS HSet, v AS SINGLE)
    DIM ignored AS _BYTE: ignored = __HSet_Remove(set(), MKS$(v))
END SUB

''' @brief Add a double to the set.
''' @param set The set to add to.
''' @param v The double to add.
SUB HSet_AddDouble (set() AS HSet, v AS DOUBLE)
    __HSet_Add set(), MKD$(v), QBDS_TYPE_DOUBLE
END SUB

''' @brief Check if a double exists in the set.
''' @param set The set to check.
''' @param v The double to check.
FUNCTION HSet_ContainsDouble%% (set() AS HSet, v AS DOUBLE)
    HSet_ContainsDouble = __HSet_Contains(set(), MKD$(v))
END FUNCTION

''' @brief Remove a double from the set.
''' @param set The set to remove from.
''' @param v The double to remove.
FUNCTION HSet_RemoveDouble%% (set() AS HSet, v AS DOUBLE)
    HSet_RemoveDouble = __HSet_Remove(set(), MKD$(v))
END FUNCTION

''' @brief Remove a double from the set.
''' @param set The set to remove from.
''' @param v The double to remove.
SUB HSet_RemoveDouble (set() AS HSet, v AS DOUBLE)
    DIM ignored AS _BYTE: ignored = __HSet_Remove(set(), MKD$(v))
END SUB
