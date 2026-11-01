# Array Library

The `Array` library provides a generic dynamic array implementation. It supports storing various data types and automatically resizes itself as needed. Array index always beings at 1.

## Usage

To use the `Array` library, you need to include `Array.bi` in your project.

```vb
'$INCLUDE:'Array.bi'

' Declare a dynamic array of Array
REDIM arr(0) AS Array

' Initialize the array
Array_Initialize arr()

' Add some items
Array_PushBackString arr(), "Hello"
Array_PushBackInteger arr(), 42

' Access items
PRINT Array_GetString(arr(), 1) ' Prints `Hello`
PRINT Array_GetInteger(arr(), 2) ' Print `42`

' Get count
PRINT Array_GetCount(arr()) ' Print `2`

' Remove an item
DIM popped AS INTEGER
popped = Array_PopBackInteger(arr())
PRINT popped ' Prints 42
PRINT Array_GetCount(arr()) ' Prints `1`

' Clean up
Array_Free arr()
```

## API Reference

### Initialization and Management

Initializes a dynamic array.

```vb
SUB Array_Initialize (array() AS Array)
```

Deletes the array and frees all associated memory.

```vb
SUB Array_Free (array() AS Array)
```

Clears the array, but does not change the capacity.

```vb
SUB Array_Clear (array() AS Array)
```

Checks whether the array has been initialized.

```vb
FUNCTION Array_IsInitialized%% (array() AS Array)
```

### Capacity and Size

Returns the current capacity of the array.

```vb
FUNCTION Array_GetCapacity~%& (array() AS Array)
```

Returns the number of items currently stored in the array.

```vb
FUNCTION Array_GetCount~%& (array() AS Array)
```

### Data Access

Returns the data type for the value at the specified index. See QBDS constants in `QBDS.bi`.

```vb
FUNCTION Array_GetElementDataType~%% (array() AS Array, index AS _UNSIGNED _OFFSET)
```

Adds an element to the end of the array.

```vb
SUB Array_PushBackString (array() AS Array, v AS STRING)
SUB Array_PushBackByte (array() AS Array, v AS _BYTE)
SUB Array_PushBackInteger (array() AS Array, v AS INTEGER)
SUB Array_PushBackLong (array() AS Array, v AS LONG)
SUB Array_PushBackInteger64 (array() AS Array, v AS _INTEGER64)
SUB Array_PushBackSingle (array() AS Array, v AS SINGLE)
SUB Array_PushBackDouble (array() AS Array, v AS DOUBLE)
```

Removes the last element from the array and returns its value.

```vb
FUNCTION Array_PopBackString$ (array() AS Array)
FUNCTION Array_PopBackByte%% (array() AS Array)
FUNCTION Array_PopBackInteger% (array() AS Array)
FUNCTION Array_PopBackLong& (array() AS Array)
FUNCTION Array_PopBackInteger64&& (array() AS Array)
FUNCTION Array_PopBackSingle! (array() AS Array)
FUNCTION Array_PopBackDouble# (array() AS Array)
```

Sets the value at the specified index.

```vb
SUB Array_SetString (array() AS Array, index AS _UNSIGNED _OFFSET, v AS STRING)
SUB Array_SetByte (array() AS Array, index AS _UNSIGNED _OFFSET, v AS _BYTE)
SUB Array_SetInteger (array() AS Array, index AS _UNSIGNED _OFFSET, v AS INTEGER)
SUB Array_SetLong (array() AS Array, index AS _UNSIGNED _OFFSET, v AS LONG)
SUB Array_SetInteger64 (array() AS Array, index AS _UNSIGNED _OFFSET, v AS _INTEGER64)
SUB Array_SetSingle (array() AS Array, index AS _UNSIGNED _OFFSET, v AS SINGLE)
SUB Array_SetDouble (array() AS Array, index AS _UNSIGNED _OFFSET, v AS DOUBLE)
```

Gets the value at the specified index.

```vb
FUNCTION Array_GetString$ (array() AS Array, index AS _UNSIGNED _OFFSET)
FUNCTION Array_GetByte%% (array() AS Array, index AS _UNSIGNED _OFFSET)
FUNCTION Array_GetInteger% (array() AS Array, index AS _UNSIGNED _OFFSET)
FUNCTION Array_GetLong& (array() AS Array, index AS _UNSIGNED _OFFSET)
FUNCTION Array_GetInteger64&& (array() AS Array, index AS _UNSIGNED _OFFSET)
FUNCTION Array_GetSingle! (array() AS Array, index AS _UNSIGNED _OFFSET)
FUNCTION Array_GetDouble# (array() AS Array, index AS _UNSIGNED _OFFSET)
```

## UDT Support

To store and retrieve **UDTs** in the array, you need to write wrapper `SUB`s around the low‑level routines. These wrappers handle packing and unpacking the UDT into a raw string buffer.

```vb
''' @brief Set the value at the specified index.
''' @param array The array to set.
''' @param index The 1-based index to set.
''' @param value The value to set.
''' @param dataType The data type constant for the value being stored.
SUB __Array_Set (array() AS Array, index AS _UNSIGNED _OFFSET, v AS STRING, dataType AS _UNSIGNED _BYTE)

''' @brief Get the value at the specified index.
''' @param array The array to get.
''' @param index The 1-based index to get.
''' @return The value at the specified index.
FUNCTION __Array_Get$ (array() AS Array, index AS _UNSIGNED _OFFSET)

''' @brief Add an item to the end of the array.
''' @param array The array to add to.
''' @param value The value to add.
''' @param dataType The data type constant for the value being stored.
SUB __Array_PushBack (array() AS Array, v AS STRING, dataType AS _UNSIGNED _BYTE)

''' @brief Remove the last item from the array.
''' @param array The array to remove from.
''' @return The value that was removed.
FUNCTION __Array_PopBack$ (array() AS Array)
```

### Example

```vb
TYPE Student
    id     AS LONG
    nam    AS STRING * 50
    atten  AS LONG
    grade  AS LONG
END TYPE

SUB Array_SetStudent (arr() AS Array, index AS _UNSIGNED _OFFSET, v AS Student)
    DIM buffer AS STRING: buffer = SPACE$(LEN(v))
    Memory_Copy _OFFSET(buffer), _OFFSET(v), LEN(v)
    __Array_Set arr(), index, buffer, QBDS_TYPE_UDT
END SUB

SUB Array_GetStudent (arr() AS Array, index AS _UNSIGNED _OFFSET, v AS Student)
    DIM buffer AS STRING: buffer = __Array_Get(arr(), index)
    Memory_Copy _OFFSET(v), _OFFSET(buffer), _MIN(LEN(v), LEN(buffer))
END SUB

SUB Array_PushBackStudent (arr() AS Array, v AS Student)
    DIM buffer AS STRING: buffer = SPACE$(LEN(v))
    Memory_Copy _OFFSET(buffer), _OFFSET(v), LEN(v)
    __Array_PushBack arr(), buffer, QBDS_TYPE_UDT
END SUB

SUB Array_PopBackStudent (arr() AS Array, v AS Student)
    DIM buffer AS STRING: buffer = __Array_PopBack(arr())
    Memory_Copy _OFFSET(v), _OFFSET(buffer), _MIN(LEN(v), LEN(buffer))
END SUB
```
