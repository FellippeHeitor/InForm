# HMap64 Library

The `HMap64` library provides a simple hash map implementation, using `_UNSIGNED _INTEGER64` keys. It supports storing various data types and automatically resizes itself as needed.

## Usage

To use the `HMap64` library, you need to include `HMap64.bi` in your project.

```vb
'$INCLUDE:'HMap64.bi'

' Declare a dynamic array of HMap64
REDIM myMap(0) AS HMap64

' Initialize the map
HMap64_Initialize myMap()

' Set and get values
HMap64_SetString myMap(), 25, "Apple"
HMap64_SetInteger myMap(), 100, 10

PRINT HMap64_GetString(myMap(), 25)
PRINT HMap64_GetInteger(myMap(), 100)

' Free the map
HMap64_Free myMap()
```

## API Reference

### Initialization and Management

Initializes a new hash map.

```vb
SUB HMap64_Initialize (map() AS HMap64)
```

Clears all entries from the hash map, but keeps its allocated capacity.

```vb
SUB HMap64_Clear (map() AS HMap64)
```

Frees all memory associated with the hash map.

```vb
SUB HMap64_Free (map() AS HMap64)
```

Returns `_TRUE` if the hash map has been initialized, `_FALSE` otherwise.

```vb
FUNCTION HMap64_IsInitialized%% (map() AS HMap64)
```

### Capacity and Size

Returns the current maximum number of entries the hash map can hold before resizing.

```vb
FUNCTION HMap64_GetCapacity~%& (map() AS HMap64)
```

Returns the number of entries currently in the hash map.

```vb
FUNCTION HMap64_GetCount~%& (map() AS HMap64)
```

### Entry Management

Deletes an entry by its key. Returns `_TRUE` if the key was found and deleted, `_FALSE` otherwise.

```vb
FUNCTION HMap64_Remove%% (map() AS HMap64, k AS _UNSIGNED _INTEGER64)
```

Deletes an entry by its key (SUB version, no return value).

```vb
SUB HMap64_Remove (map() AS HMap64, k AS _UNSIGNED _INTEGER64)
```

Checks if a key exists in the hash map. Returns `_TRUE` if the key exists, `_FALSE` otherwise.

```vb
FUNCTION HMap64_Contains%% (map() AS HMap64, k AS _UNSIGNED _INTEGER64)
```

Returns the data type of the value associated with a key.

```vb
FUNCTION HMap64_GetEntryDataType~%% (map() AS HMap64, k AS _UNSIGNED _INTEGER64)
```

### Data Access

Sets a value for a given key.

```vb
SUB HMap64_SetString (map() AS HMap64, k AS _UNSIGNED _INTEGER64, v AS STRING)
SUB HMap64_SetByte (map() AS HMap64, k AS _UNSIGNED _INTEGER64, v AS _BYTE)
SUB HMap64_SetInteger (map() AS HMap64, k AS _UNSIGNED _INTEGER64, v AS INTEGER)
SUB HMap64_SetLong (map() AS HMap64, k AS _UNSIGNED _INTEGER64, v AS LONG)
SUB HMap64_SetInteger64 (map() AS HMap64, k AS _UNSIGNED _INTEGER64, v AS _INTEGER64)
SUB HMap64_SetSingle (map() AS HMap64, k AS _UNSIGNED _INTEGER64, v AS SINGLE)
SUB HMap64_SetDouble (map() AS HMap64, k AS _UNSIGNED _INTEGER64, v AS DOUBLE)
```

Retrieves the value for a given key.

```vb
FUNCTION HMap64_GetString$ (map() AS HMap64, k AS _UNSIGNED _INTEGER64)
FUNCTION HMap64_GetByte%% (map() AS HMap64, k AS _UNSIGNED _INTEGER64)
FUNCTION HMap64_GetInteger% (map() AS HMap64, k AS _UNSIGNED _INTEGER64)
FUNCTION HMap64_GetLong& (map() AS HMap64, k AS _UNSIGNED _INTEGER64)
FUNCTION HMap64_GetInteger64&& (map() AS HMap64, k AS _UNSIGNED _INTEGER64)
FUNCTION HMap64_GetSingle! (map() AS HMap64, k AS _UNSIGNED _INTEGER64)
FUNCTION HMap64_GetDouble# (map() AS HMap64, k AS _UNSIGNED _INTEGER64)
```

## UDT Support

To store and retrieve **UDTs** in the hash map, you need to write wrapper `SUB`s around the low‑level routines. These wrappers handle packing and unpacking the UDT into a raw string buffer.

```vb
''' @brief Retrieves the value for a given key.
''' @param map The hash map to search.
''' @param k The key to look up.
''' @return The associated value, or an empty string if not found.
FUNCTION __HMap64_Get$ (map() AS HMap64, k AS _UNSIGNED _INTEGER64)

''' @brief Updates an existing key or inserts it if not present.
''' @param map The hash map to update.
''' @param k The key.
''' @param v The value string.
''' @param dataType The data type constant for the value being stored.
SUB __HMap64_Set (map() AS HMap64, k AS _UNSIGNED _INTEGER64, v AS STRING, dataType AS _UNSIGNED _BYTE)
```

### Example

```vb
TYPE Student
    id     AS LONG
    nam    AS STRING * 50
    atten  AS LONG
    grade  AS LONG
END TYPE

SUB HMap64_SetStudent (map() AS HMap64, k AS _UNSIGNED _INTEGER64, v AS Student)
    DIM buffer AS STRING: buffer = SPACE$(LEN(v))
    Memory_Copy _OFFSET(buffer), _OFFSET(v), LEN(v)
    __HMap64_Set map(), k, buffer, QBDS_TYPE_UDT
END SUB

SUB HMap64_GetStudent (map() AS HMap64, k AS _UNSIGNED _INTEGER64, v AS Student)
    DIM buffer AS STRING: buffer = __HMap64_Get(map(), k)
    Memory_Copy _OFFSET(v), _OFFSET(buffer), _MIN(LEN(v), LEN(buffer))
END SUB
```
