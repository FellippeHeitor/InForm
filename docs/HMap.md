# HMap Library

The `HMap` library provides a generic hash map implementation. It allows you to store and retrieve values of different data types using string keys. The hash map automatically resizes itself as needed.

## Usage

To use the `HMap` library, include `HMap.bi` in your project.

```vb
'$INCLUDE:'HMap.bi'

' Declare a dynamic array of HMap
REDIM myMap(0) AS HMap

' Initialize the map
HMap_Initialize myMap()

' Set and get values
HMap_SetString myMap(), "name", "John Doe"
HMap_SetInteger myMap(), "age", 30

PRINT HMap_GetString(myMap(), "name")
PRINT HMap_GetInteger(myMap(), "age")

' Free the map
HMap_Free myMap()
```

## API Reference

### Initialization and Management

Initializes a new hash map.

```vb
SUB HMap_Initialize (map() AS HMap)
```

Removes all entries from the hash map, but keeps the allocated memory.

```vb
SUB HMap_Clear (map() AS HMap)
```

Frees all memory associated with the map.

```vb
SUB HMap_Free (map() AS HMap)
```

Returns `_TRUE` if the map has been initialized.

```vb
FUNCTION HMap_IsInitialized%% (map() AS HMap)
```

### Capacity and Size

Returns the current capacity of the map.

```vb
FUNCTION HMap_GetCapacity~%& (map() AS HMap)
```

Returns the number of entries in the map.

```vb
FUNCTION HMap_GetCount~%& (map() AS HMap)
```

### Entry Management

Deletes a key-value pair from the map. Returns `_TRUE` if the key was found and deleted.

```vb
FUNCTION HMap_Remove%% (map() AS HMap, k AS STRING)
```

Deletes a key-value pair from the map (SUB version, no return value).

```vb
SUB HMap_Remove (map() AS HMap, k AS STRING)
```

Checks if a key exists in the map. Returns `_TRUE` if found.

```vb
FUNCTION HMap_Contains%% (map() AS HMap, k AS STRING)
```

Returns the data type of the value associated with a key. See QBDS constants in `QBDS.bi`.

```vb
FUNCTION HMap_GetEntryDataType~%% (map() AS HMap, k AS STRING)
```

### Data Access

Sets a value for a key.

```vb
SUB HMap_SetString (map() AS HMap, k AS STRING, v AS STRING)
SUB HMap_SetByte (map() AS HMap, k AS STRING, v AS _BYTE)
SUB HMap_SetInteger (map() AS HMap, k AS STRING, v AS INTEGER)
SUB HMap_SetLong (map() AS HMap, k AS STRING, v AS LONG)
SUB HMap_SetInteger64 (map() AS HMap, k AS STRING, v AS _INTEGER64)
SUB HMap_SetSingle (map() AS HMap, k AS STRING, v AS SINGLE)
SUB HMap_SetDouble (map() AS HMap, k AS STRING, v AS DOUBLE)
```

Gets the value for a key.

```vb
FUNCTION HMap_GetString$ (map() AS HMap, k AS STRING)
FUNCTION HMap_GetByte%% (map() AS HMap, k AS STRING)
FUNCTION HMap_GetInteger% (map() AS HMap, k AS STRING)
FUNCTION HMap_GetLong& (map() AS HMap, k AS STRING)
FUNCTION HMap_GetInteger64&& (map() AS HMap, k AS STRING)
FUNCTION HMap_GetSingle! (map() AS HMap, k AS STRING)
FUNCTION HMap_GetDouble# (map() AS HMap, k AS STRING)
```

## UDT Support

To store and retrieve **UDTs** in the hash map, you need to write wrapper `SUB`s around the low‑level routines. These wrappers handle packing and unpacking the UDT into a raw string buffer.

```vb
''' @brief Retrieves the raw value string for a given key.
''' @param map The hash map to search.
''' @param k The key string to look up.
''' @return The associated value string, or an empty string if not found.
FUNCTION __HMap_Get$ (map() AS HMap, k AS STRING)

''' @brief Insert or update a key's value.
''' @param map The hash map to update.
''' @param k The key string.
''' @param v The raw value string to store (packed using MK$ helpers for numeric types).
''' @param dataType The data type constant for the value being stored.
SUB __HMap_Set (map() AS HMap, k AS STRING, v AS STRING, dataType AS _UNSIGNED _BYTE)
```

### Example

```vb
TYPE Student
    id     AS LONG
    nam    AS STRING * 50
    atten  AS LONG
    grade  AS LONG
END TYPE

' Store a Student UDT in the map
SUB HMap_SetStudent (map() AS HMap, k AS STRING, v AS Student)
    DIM buffer AS STRING: buffer = SPACE$(LEN(v))
    Memory_Copy _OFFSET(buffer), _OFFSET(v), LEN(v)
    __HMap_Set map(), k, buffer, QBDS_TYPE_UDT
END SUB

' Retrieve a Student UDT from the map
SUB HMap_GetStudent (map() AS HMap, k AS STRING, v AS Student)
    DIM buffer AS STRING: buffer = __HMap_Get(map(), k)
    Memory_Copy _OFFSET(v), _OFFSET(buffer), _MIN(LEN(v), LEN(buffer))
END SUB
```
