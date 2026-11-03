'-----------------------------------------------------------------------------------------------------------------------
' A simple integer hash map library for QB64-PE with support for multiple data types and dynamic resizing
' Copyright (c) 2026 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$INCLUDEONCE

'$INCLUDE:'QBDS.bi'

''' @brief Primary data structure used by the HMap64 library.
''' The user declares a dynamic array of this type and passes it to the HMap64_* functions.
''' The library stores internal metadata at array index 0; user entries begin at index 1.
''' Metadata (stored in element 0):
'''     - K: count of items
'''     - V: unused
'''     - T: set to QBDS_TYPE_RESERVED
TYPE HMap64
    K AS _UNSIGNED _INTEGER64 ' key or metadata (count)
    V AS STRING ' value or metadata (unused)
    T AS _UNSIGNED _BYTE ' data type of the value (0 = unused) or metadata (QBDS_TYPE_RESERVED)
END TYPE

''' @brief Compute a simple integer hash and reduce it to an index.
''' @param k The integer to hash.
''' @param tableSize The hash map size (must be a power of 2).
''' @return The computed hash index in the range 1 to tableSize.
FUNCTION __HMap64_Hash~%& (k AS _UNSIGNED _INTEGER64, tableSize AS _UNSIGNED _OFFSET)
    __HMap64_Hash = 1 + (k AND (tableSize - 1))
END FUNCTION

''' @brief Check whether the hash map has been initialized.
''' @param map The dynamic HMap64 array to check.
''' @return _TRUE if initialized, otherwise _FALSE.
FUNCTION HMap64_IsInitialized%% (map() AS HMap64)
    HMap64_IsInitialized = LBOUND(map) = 0 _ANDALSO UBOUND(map) > 0 _ANDALSO map(0).T = QBDS_TYPE_RESERVED
END FUNCTION

''' @brief Initialize a hash map (allocate initial table and reset metadata).
''' @param map The dynamic HMap64 array to initialize.
SUB HMap64_Initialize (map() AS HMap64)
    REDIM map(0 TO __QBDS_ITEMS_MIN) AS HMap64 ' power of 2 initial size
    map(0).T = QBDS_TYPE_RESERVED ' mark as initialized
END SUB

''' @brief Clear the hash map, but do not change the capacity.
''' @param map The hash map to clear.
SUB HMap64_Clear (map() AS HMap64)
    REDIM map(0 TO _MAX(__QBDS_ITEMS_MIN, UBOUND(map))) AS HMap64
    map(0).T = QBDS_TYPE_RESERVED ' set to reserved
END SUB

''' @brief Delete the hash map and free all associated memory.
''' @param map The hash map to clear.
SUB HMap64_Free (map() AS HMap64)
    REDIM map(0) AS HMap64
END SUB

''' @brief Return the current capacity of the hash map.
''' @param map The hash map to query.
''' @return The total number of slots in the map.
FUNCTION HMap64_GetCapacity~%& (map() AS HMap64)
    HMap64_GetCapacity = UBOUND(map)
END FUNCTION

''' @brief Return the number of user entries currently stored in the map.
''' @param map The hash map to query.
''' @return The number of unique items.
FUNCTION HMap64_GetCount~%& (map() AS HMap64)
    HMap64_GetCount = map(0).K
END FUNCTION

''' @brief Resize the hash map and rehash all user entries.
''' @param map The dynamic HMap64 array to resize.
SUB __HMap64_ResizeAndRehash (map() AS HMap64)
    DIM oldSize AS _UNSIGNED _OFFSET: oldSize = UBOUND(map)

    ' Resize the array to double its size while preserving contents
    DIM newSize AS _UNSIGNED _OFFSET: newSize = _MAX(__QBDS_ITEMS_MIN, _SHL(oldSize, 1)) ' grow by power of 2
    REDIM _PRESERVE map(0 TO newSize) AS HMap64

    ' Rehash and swap all the elements
    DIM i AS _UNSIGNED _OFFSET: i = 1
    WHILE i <= oldSize
        IF map(i).T > QBDS_TYPE_DELETED THEN
            DIM idx AS _UNSIGNED _OFFSET: idx = __HMap64_Hash(map(i).K, newSize)
            SWAP map(i).T, map(idx).T
            SWAP map(i).V, map(idx).V
            SWAP map(i).K, map(idx).K
        END IF

        i = i + 1
    WEND
END SUB

''' @brief Delete a key-value pair by key and return whether it existed.
''' @param map The hash map to modify.
''' @param k The key to remove.
''' @return _TRUE if the key was removed, otherwise _FALSE.
FUNCTION HMap64_Remove%% (map() AS HMap64, k AS _UNSIGNED _INTEGER64)
    DIM arraySize AS _UNSIGNED _OFFSET: arraySize = UBOUND(map)
    DIM idx AS _UNSIGNED _OFFSET: idx = __HMap64_Hash(k, arraySize)

    IF idx <= arraySize _ANDALSO map(idx).T > QBDS_TYPE_DELETED _ANDALSO map(idx).K = k THEN
        map(idx).T = QBDS_TYPE_DELETED
        map(idx).V = _STR_EMPTY

        map(0).K = map(0).K - 1

        HMap64_Remove = _TRUE
    END IF
END FUNCTION

''' @brief Removes a key-value pair by key.
''' @param map The hash map to modify.
''' @param k The key to remove.
''' @return _TRUE if removed, _FALSE if not found.
SUB HMap64_Remove (map() AS HMap64, k AS _UNSIGNED _INTEGER64)
    DIM ignored AS _BYTE: ignored = HMap64_Remove(map(), k)
END SUB

''' @brief Checks if a key exists in the map.
''' @param map The hash map to search.
''' @param k The key to check.
''' @return _TRUE if present, _FALSE otherwise.
FUNCTION HMap64_Contains%% (map() AS HMap64, k AS _UNSIGNED _INTEGER64)
    DIM arraySize AS _UNSIGNED _OFFSET: arraySize = UBOUND(map)
    DIM idx AS _UNSIGNED _OFFSET: idx = __HMap64_Hash(k, arraySize)
    HMap64_Contains = idx <= arraySize _ANDALSO map(idx).T > QBDS_TYPE_DELETED _ANDALSO map(idx).K = k
END FUNCTION

''' @brief Return the stored data type for a key.
''' @param map The hash map to search.
''' @param k The key string to look up.
''' @return The associated data type constant (QBDS_TYPE_*), or 0 if not found.
FUNCTION HMap64_GetEntryDataType~%% (map() AS HMap64, k AS _UNSIGNED _INTEGER64)
    DIM arraySize AS _UNSIGNED _OFFSET: arraySize = UBOUND(map)
    DIM idx AS _UNSIGNED _OFFSET: idx = __HMap64_Hash(k, arraySize)
    IF idx <= arraySize _ANDALSO map(idx).T > QBDS_TYPE_DELETED _ANDALSO map(idx).K = k THEN
        HMap64_GetEntryDataType = map(idx).T
    END IF
END FUNCTION

''' @brief Updates an existing key or inserts it if not present.
''' @param map The hash map to update.
''' @param k The key.
''' @param v The value string.
''' @param dataType The data type constant for the value being stored.
SUB __HMap64_Set (map() AS HMap64, k AS _UNSIGNED _INTEGER64, v AS STRING, dataType AS _UNSIGNED _BYTE)
    DIM arraySize AS _UNSIGNED _OFFSET: arraySize = UBOUND(map)
    DIM idx AS _UNSIGNED _OFFSET: idx = __HMap64_Hash(k, arraySize)

    IF idx > arraySize THEN
        IF arraySize = 0 THEN
            HMap64_Initialize map()
        ELSE
            __HMap64_ResizeAndRehash map()
        END IF
        __HMap64_Set map(), k, v, dataType
    ELSE
        IF map(idx).T > QBDS_TYPE_DELETED THEN
            IF map(idx).K = k THEN
                map(idx).V = v
                map(idx).T = dataType
            ELSE
                __HMap64_ResizeAndRehash map()
                __HMap64_Set map(), k, v, dataType
            END IF
        ELSE
            map(idx).K = k
            map(idx).V = v
            map(idx).T = dataType
            map(0).K = map(0).K + 1
        END IF
    END IF
END SUB

''' @brief Retrieves the value for a given key.
''' @param map The hash map to search.
''' @param k The key to look up.
''' @return The associated value, or an empty string if not found.
FUNCTION __HMap64_Get$ (map() AS HMap64, k AS _UNSIGNED _INTEGER64)
    DIM arraySize AS _UNSIGNED _OFFSET: arraySize = UBOUND(map)
    DIM idx AS _UNSIGNED _OFFSET: idx = __HMap64_Hash(k, arraySize)
    IF idx <= arraySize _ANDALSO map(idx).T > QBDS_TYPE_DELETED _ANDALSO map(idx).K = k THEN __HMap64_Get = map(idx).V
END FUNCTION

''' @brief Retrieves the value for a given key.
''' @param map The hash map to search.
''' @param k The key to look up.
''' @return The associated value string, or an empty string if not found.
FUNCTION HMap64_GetString$ (map() AS HMap64, k AS _UNSIGNED _INTEGER64)
    HMap64_GetString = __HMap64_Get(map(), k)
END FUNCTION

''' @brief Updates an existing key or inserts it if not present.
''' @param map The hash map to update.
''' @param k The key.
''' @param v The value string.
SUB HMap64_SetString (map() AS HMap64, k AS _UNSIGNED _INTEGER64, v AS STRING)
    __HMap64_Set map(), k, v, QBDS_TYPE_STRING
END SUB

''' @brief Retrieves the value for a given key.
''' @param map The hash map to search.
''' @param k The key to look up.
''' @return The associated _BYTE value.
FUNCTION HMap64_GetByte%% (map() AS HMap64, k AS _UNSIGNED _INTEGER64)
    HMap64_GetByte = _CV(_BYTE, __HMap64_Get(map(), k))
END FUNCTION

''' @brief Updates an existing key or inserts it if not present.
''' @param map The hash map to update.
''' @param k The key.
''' @param v The value _BYTE.
SUB HMap64_SetByte (map() AS HMap64, k AS _UNSIGNED _INTEGER64, v AS _BYTE)
    __HMap64_Set map(), k, _MK$(_BYTE, v), QBDS_TYPE_BYTE
END SUB

''' @brief Retrieves the value for a given key.
''' @param map The hash map to search.
''' @param k The key to look up.
''' @return The associated INTEGER value.
FUNCTION HMap64_GetInteger% (map() AS HMap64, k AS _UNSIGNED _INTEGER64)
    HMap64_GetInteger = CVI(__HMap64_Get(map(), k))
END FUNCTION

''' @brief Updates an existing key or inserts it if not present.
''' @param map The hash map to update.
''' @param k The key.
''' @param v The value INTEGER.
SUB HMap64_SetInteger (map() AS HMap64, k AS _UNSIGNED _INTEGER64, v AS INTEGER)
    __HMap64_Set map(), k, MKI$(v), QBDS_TYPE_INTEGER
END SUB

''' @brief Retrieves the value for a given key.
''' @param map The hash map to search.
''' @param k The key to look up.
''' @return The associated LONG value.
FUNCTION HMap64_GetLong& (map() AS HMap64, k AS _UNSIGNED _INTEGER64)
    HMap64_GetLong = CVL(__HMap64_Get(map(), k))
END FUNCTION

''' @brief Updates an existing key or inserts it if not present.
''' @param map The hash map to update.
''' @param k The key.
''' @param v The value LONG.
SUB HMap64_SetLong (map() AS HMap64, k AS _UNSIGNED _INTEGER64, v AS LONG)
    __HMap64_Set map(), k, MKL$(v), QBDS_TYPE_LONG
END SUB

''' @brief Retrieves the value for a given key.
''' @param map The hash map to search.
''' @param k The key to look up.
''' @return The associated _INTEGER64 value.
FUNCTION HMap64_GetInteger64&& (map() AS HMap64, k AS _UNSIGNED _INTEGER64)
    HMap64_GetInteger64 = _CV(_INTEGER64, __HMap64_Get(map(), k))
END FUNCTION

''' @brief Updates an existing key or inserts it if not present.
''' @param map The hash map to update.
''' @param k The key.
''' @param v The value _INTEGER64.
SUB HMap64_SetInteger64 (map() AS HMap64, k AS _UNSIGNED _INTEGER64, v AS _INTEGER64)
    __HMap64_Set map(), k, _MK$(_INTEGER64, v), QBDS_TYPE_INTEGER64
END SUB

''' @brief Retrieves the value for a given key.
''' @param map The hash map to search.
''' @param k The key to look up.
''' @return The associated SINGLE value.
FUNCTION HMap64_GetSingle! (map() AS HMap64, k AS _UNSIGNED _INTEGER64)
    HMap64_GetSingle = CVS(__HMap64_Get(map(), k))
END FUNCTION

''' @brief Updates an existing key or inserts it if not present.
''' @param map The hash map to update.
''' @param k The key.
''' @param v The value SINGLE.
SUB HMap64_SetSingle (map() AS HMap64, k AS _UNSIGNED _INTEGER64, v AS SINGLE)
    __HMap64_Set map(), k, MKS$(v), QBDS_TYPE_SINGLE
END SUB

''' @brief Retrieves the value for a given key.
''' @param map The hash map to search.
''' @param k The key to look up.
''' @return The associated DOUBLE value.
FUNCTION HMap64_GetDouble# (map() AS HMap64, k AS _UNSIGNED _INTEGER64)
    HMap64_GetDouble = CVD(__HMap64_Get(map(), k))
END FUNCTION

''' @brief Updates an existing key or inserts it if not present.
''' @param map The hash map to update.
''' @param k The key.
''' @param v The value DOUBLE.
SUB HMap64_SetDouble (map() AS HMap64, k AS _UNSIGNED _INTEGER64, v AS DOUBLE)
    __HMap64_Set map(), k, MKD$(v), QBDS_TYPE_DOUBLE
END SUB
