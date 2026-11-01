'-----------------------------------------------------------------------------------------------------------------------
' Generic dynamic array library for QB64-PE
' Copyright (c) 2026 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$INCLUDEONCE

'$INCLUDE:'QBDS.bi'

''' @brief Primary data structure used by the Array library.
''' The user declares a dynamic array of this type and passes it to the Array_* functions.
''' The library stores internal metadata at array index 0; user entries begin at index 1.
''' Metadata (stored in element 0):
'''     - V: count of items (_MK$(_UNSIGNED _OFFSET, count))
'''     - T: QBDS_TYPE_RESERVED
TYPE Array
    V AS STRING
    T AS _UNSIGNED _BYTE
END TYPE

''' @brief Check whether the array has been initialized.
''' @param array The dynamic Array array to check.
''' @return _TRUE if initialized, otherwise _FALSE.
FUNCTION Array_IsInitialized%% (array() AS Array)
    Array_IsInitialized = LBOUND(array) = 0 _ANDALSO UBOUND(array) > 0 _ANDALSO array(0).T = QBDS_TYPE_RESERVED _ANDALSO LEN(array(0).V) = _SIZE_OF_OFFSET
END FUNCTION

''' @brief Initialize a dynamic array.
''' @param array The dynamic Array array to initialize.
SUB Array_Initialize (array() AS Array)
    REDIM array(0 TO __QBDS_ITEMS_MIN) AS Array
    array(0).T = QBDS_TYPE_RESERVED
    array(0).V = _MK$(_UNSIGNED _OFFSET, 0) ' Store count
END SUB

''' @brief Clear the array, but do not change the capacity.
''' @param array The array to clear.
SUB Array_Clear (array() AS Array)
    REDIM array(0 TO _MAX(__QBDS_ITEMS_MIN, UBOUND(array))) AS Array
    array(0).T = QBDS_TYPE_RESERVED
    array(0).V = _MK$(_UNSIGNED _OFFSET, 0) ' Reset count
END SUB

''' @brief Delete the array and free all associated memory.
''' @param array The array to free.
SUB Array_Free (array() AS Array)
    REDIM array(0) AS Array
END SUB

''' @brief Return the current capacity of the array.
''' @param array The array to query.
''' @return The total number of slots in the array.
FUNCTION Array_GetCapacity~%& (array() AS Array)
    Array_GetCapacity = UBOUND(array)
END FUNCTION

''' @brief Return the number of items currently stored in the array.
''' @param array The array to query.
''' @return The number of items.
FUNCTION Array_GetCount~%& (array() AS Array)
    Array_GetCount = _CV(_UNSIGNED _OFFSET, array(0).V)
END FUNCTION

''' @brief Returns the data type for the value at the specified index.
''' @param array The array to query.
''' @param index The 1-based index to check.
''' @return The data type constant (QBDS_TYPE_*) or 0 if index is invalid.
FUNCTION Array_GetElementDataType~%% (array() AS Array, index AS _UNSIGNED _OFFSET)
    IF index > 0 _ANDALSO index <= _CV(_UNSIGNED _OFFSET, array(0).V) THEN
        Array_GetElementDataType = array(index).T
    END IF
END FUNCTION

''' @brief Set the value at the specified index.
''' @param array The array to set.
''' @param index The 1-based index to set.
''' @param value The value to set.
''' @param dataType The data type constant for the value being stored.
SUB __Array_Set (array() AS Array, index AS _UNSIGNED _OFFSET, v AS STRING, dataType AS _UNSIGNED _BYTE)
    IF index < 1 _ORELSE index > _CV(_UNSIGNED _OFFSET, array(0).V) THEN
        ERROR _ERR_SUBSCRIPT_OUT_OF_RANGE
        EXIT SUB
    END IF
    array(index).V = v
    array(index).T = dataType
END SUB

''' @brief Get the value at the specified index.
''' @param array The array to get.
''' @param index The 1-based index to get.
''' @return The value at the specified index.
FUNCTION __Array_Get$ (array() AS Array, index AS _UNSIGNED _OFFSET)
    IF index < 1 OR index > _CV(_UNSIGNED _OFFSET, array(0).V) THEN
        ERROR _ERR_SUBSCRIPT_OUT_OF_RANGE
        EXIT FUNCTION
    END IF
    __Array_Get = array(index).V
END FUNCTION

''' @brief Add an item to the end of the array.
''' @param array The array to add to.
''' @param value The value to add.
''' @param dataType The data type constant for the value being stored.
SUB __Array_PushBack (array() AS Array, v AS STRING, dataType AS _UNSIGNED _BYTE)
    DIM count AS _UNSIGNED _OFFSET: count = 1 + _CV(_UNSIGNED _OFFSET, array(0).V)
    DIM capacity AS _UNSIGNED _OFFSET: capacity = UBOUND(array)

    IF count > capacity THEN
        REDIM _PRESERVE array(0 TO _MAX(__QBDS_ITEMS_MIN, _SHL(capacity, 1))) AS Array
    END IF

    array(count).T = dataType
    array(count).V = v

    array(0).V = _MK$(_UNSIGNED _OFFSET, count)
END SUB

''' @brief Remove the last item from the array.
''' @param array The array to remove from.
''' @return The value that was removed.
FUNCTION __Array_PopBack$ (array() AS Array)
    DIM count AS _UNSIGNED _OFFSET: count = _CV(_UNSIGNED _OFFSET, array(0).V)
    IF count THEN
        __Array_PopBack = array(count).V
        array(count).V = _STR_EMPTY

        array(0).V = _MK$(_UNSIGNED _OFFSET, count - 1)
    END IF
END FUNCTION

''' @brief Set the value at the specified index.
''' @param array The array to set.
''' @param index The 1-based index to set.
''' @param value The STRING value to set.
SUB Array_SetString (array() AS Array, index AS _UNSIGNED _OFFSET, v AS STRING)
    __Array_Set array(), index, v, QBDS_TYPE_STRING
END SUB

''' @brief Get the value at the specified index.
''' @param array The array to get.
''' @param index The 1-based index to get.
''' @return The STRING value at the specified index.
FUNCTION Array_GetString$ (array() AS Array, index AS _UNSIGNED _OFFSET)
    Array_GetString = __Array_Get(array(), index)
END FUNCTION

''' @brief Add an item to the end of the array.
''' @param array The array to add to.
''' @param value The STRING value to add.
SUB Array_PushBackString (array() AS Array, v AS STRING)
    __Array_PushBack array(), v, QBDS_TYPE_STRING
END SUB

''' @brief Remove the last item from the array.
''' @param array The array to remove from.
''' @return The STRING value that was removed.
FUNCTION Array_PopBackString$ (array() AS Array)
    Array_PopBackString = __Array_PopBack(array())
END FUNCTION

''' @brief Set the value at the specified index.
''' @param array The array to set.
''' @param index The 1-based index to set.
''' @param v The _BYTE value to set.
SUB Array_SetByte (array() AS Array, index AS _UNSIGNED _OFFSET, v AS _BYTE)
    __Array_Set array(), index, _MK$(_BYTE, v), QBDS_TYPE_BYTE
END SUB

''' @brief Get the value at the specified index.
''' @param array The array to get.
''' @param index The 1-based index to get.
''' @return The _BYTE value at the specified index.
FUNCTION Array_GetByte%% (array() AS Array, index AS _UNSIGNED _OFFSET)
    Array_GetByte = _CV(_BYTE, __Array_Get(array(), index))
END FUNCTION

''' @brief Add an item to the end of the array.
''' @param array The array to add to.
''' @param v The _BYTE value to add.
SUB Array_PushBackByte (array() AS Array, v AS _BYTE)
    __Array_PushBack array(), _MK$(_BYTE, v), QBDS_TYPE_BYTE
END SUB

''' @brief Remove the last item from the array.
''' @param array The array to remove from.
''' @return The _BYTE value that was removed.
FUNCTION Array_PopBackByte%% (array() AS Array)
    Array_PopBackByte = _CV(_BYTE, __Array_PopBack(array()))
END FUNCTION

''' @brief Set the value at the specified index.
''' @param array The array to set.
''' @param index The 1-based index to set.
''' @param v The INTEGER value to set.
SUB Array_SetInteger (array() AS Array, index AS _UNSIGNED _OFFSET, v AS INTEGER)
    __Array_Set array(), index, MKI$(v), QBDS_TYPE_INTEGER
END SUB

''' @brief Get the value at the specified index.
''' @param array The array to get.
''' @param index The 1-based index to get.
''' @return The INTEGER value at the specified index.
FUNCTION Array_GetInteger% (array() AS Array, index AS _UNSIGNED _OFFSET)
    Array_GetInteger = CVI(__Array_Get(array(), index))
END FUNCTION

''' @brief Add an item to the end of the array.
''' @param array The array to add to.
''' @param v The INTEGER value to add.
SUB Array_PushBackInteger (array() AS Array, v AS INTEGER)
    __Array_PushBack array(), MKI$(v), QBDS_TYPE_INTEGER
END SUB

''' @brief Remove the last item from the array.
''' @param array The array to remove from.
''' @return The INTEGER value that was removed.
FUNCTION Array_PopBackInteger% (array() AS Array)
    Array_PopBackInteger = CVI(__Array_PopBack(array()))
END FUNCTION

''' @brief Set the value at the specified index.
''' @param array The array to set.
''' @param index The 1-based index to set.
''' @param v The LONG value to set.
SUB Array_SetLong (array() AS Array, index AS _UNSIGNED _OFFSET, v AS LONG)
    __Array_Set array(), index, MKL$(v), QBDS_TYPE_LONG
END SUB

''' @brief Get the value at the specified index.
''' @param array The array to get.
''' @param index The 1-based index to get.
''' @return The LONG value at the specified index.
FUNCTION Array_GetLong& (array() AS Array, index AS _UNSIGNED _OFFSET)
    Array_GetLong = CVL(__Array_Get(array(), index))
END FUNCTION

''' @brief Add an item to the end of the array.
''' @param array The array to add to.
''' @param v The LONG value to add.
SUB Array_PushBackLong (array() AS Array, v AS LONG)
    __Array_PushBack array(), MKL$(v), QBDS_TYPE_LONG
END SUB

''' @brief Remove the last item from the array.
''' @param array The array to remove from.
''' @return The LONG value that was removed.
FUNCTION Array_PopBackLong& (array() AS Array)
    Array_PopBackLong = CVL(__Array_PopBack(array()))
END FUNCTION

''' @brief Set the value at the specified index.
''' @param array The array to set.
''' @param index The 1-based index to set.
''' @param v The _INTEGER64 value to set.
SUB Array_SetInteger64 (array() AS Array, index AS _UNSIGNED _OFFSET, v AS _INTEGER64)
    __Array_Set array(), index, _MK$(_INTEGER64, v), QBDS_TYPE_INTEGER64
END SUB

''' @brief Get the value at the specified index.
''' @param array The array to get.
''' @param index The 1-based index to get.
''' @return The _INTEGER64 value at the specified index.
FUNCTION Array_GetInteger64&& (array() AS Array, index AS _UNSIGNED _OFFSET)
    Array_GetInteger64 = _CV(_INTEGER64, __Array_Get(array(), index))
END FUNCTION

''' @brief Add an item to the end of the array.
''' @param array The array to add to.
''' @param v The _INTEGER64 value to add.
SUB Array_PushBackInteger64 (array() AS Array, v AS _INTEGER64)
    __Array_PushBack array(), _MK$(_INTEGER64, v), QBDS_TYPE_INTEGER64
END SUB

''' @brief Remove the last item from the array.
''' @param array The array to remove from.
''' @return The _INTEGER64 value that was removed.
FUNCTION Array_PopBackInteger64&& (array() AS Array)
    Array_PopBackInteger64 = _CV(_INTEGER64, __Array_PopBack(array()))
END FUNCTION

''' @brief Set the value at the specified index.
''' @param array The array to set.
''' @param index The 1-based index to set.
''' @param v The SINGLE value to set.
SUB Array_SetSingle (array() AS Array, index AS _UNSIGNED _OFFSET, v AS SINGLE)
    __Array_Set array(), index, MKS$(v), QBDS_TYPE_SINGLE
END SUB

''' @brief Get the value at the specified index.
''' @param array The array to get.
''' @param index The 1-based index to get.
''' @return The SINGLE value at the specified index.
FUNCTION Array_GetSingle! (array() AS Array, index AS _UNSIGNED _OFFSET)
    Array_GetSingle = CVS(__Array_Get(array(), index))
END FUNCTION

''' @brief Add an item to the end of the array.
''' @param array The array to add to.
''' @param v The SINGLE value to add.
SUB Array_PushBackSingle (array() AS Array, v AS SINGLE)
    __Array_PushBack array(), MKS$(v), QBDS_TYPE_SINGLE
END SUB

''' @brief Remove the last item from the array.
''' @param array The array to remove from.
''' @return The SINGLE value that was removed.
FUNCTION Array_PopBackSingle! (array() AS Array)
    Array_PopBackSingle = CVS(__Array_PopBack(array()))
END FUNCTION

''' @brief Set the value at the specified index.
''' @param array The array to set.
''' @param index The 1-based index to set.
''' @param v The DOUBLE value to set.
SUB Array_SetDouble (array() AS Array, index AS _UNSIGNED _OFFSET, v AS DOUBLE)
    __Array_Set array(), index, MKD$(v), QBDS_TYPE_DOUBLE
END SUB

''' @brief Get the value at the specified index.
''' @param array The array to get.
''' @param index The 1-based index to get.
''' @return The DOUBLE value at the specified index.
FUNCTION Array_GetDouble# (array() AS Array, index AS _UNSIGNED _OFFSET)
    Array_GetDouble = CVD(__Array_Get(array(), index))
END FUNCTION

''' @brief Add an item to the end of the array.
''' @param array The array to add to.
''' @param v The DOUBLE value to add.
SUB Array_PushBackDouble (array() AS Array, v AS DOUBLE)
    __Array_PushBack array(), MKD$(v), QBDS_TYPE_DOUBLE
END SUB

''' @brief Remove the last item from the array.
''' @param array The array to remove from.
''' @return The DOUBLE value that was removed.
FUNCTION Array_PopBackDouble# (array() AS Array)
    Array_PopBackDouble = CVD(__Array_PopBack(array()))
END FUNCTION
