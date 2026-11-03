# HSet Library

The `HSet` library provides a generic hash set implementation. It supports storing various data types and automatically resizes itself as needed.

## Usage

To use the `HSet` library, you need to include `HSet.bi` in your project.

```vb
'$INCLUDE:'HSet.bi'

' Declare a dynamic array of HSet
REDIM mySet(0) AS HSet

' Initialize the set
HSet_Initialize mySet()

' Add some items
HSet_AddString mySet(), "Apple"
HSet_AddString mySet(), "Banana"
HSet_AddInteger mySet(), 42

' Check for items
PRINT HSet_ContainsString(mySet(), "Apple") ' Prints -1
PRINT HSet_ContainsInteger(mySet(), 123)    ' Prints 0

' Get count
PRINT HSet_GetCount(mySet()) ' Prints 3

' Remove an item
HSet_RemoveString mySet(), "Banana"
PRINT HSet_GetCount(mySet()) ' Prints 2
PRINT HSet_ContainsString(mySet(), "Banana") ' Prints 0 (False)

' Clean up
HSet_Free mySet()
```

## API Reference

### Initialization and Management

Initializes a hash set.

```vb
SUB HSet_Initialize (set() AS HSet)
```

Deletes the set and frees all associated memory.

```vb
SUB HSet_Free (set() AS HSet)
```

Clears the set, but does not change the capacity.

```vb
SUB HSet_Clear (set() AS HSet)
```

Checks whether the set has been initialized.

```vb
FUNCTION HSet_IsInitialized%% (set() AS HSet)
```

### Capacity and Size

Returns the current capacity of the set.

```vb
FUNCTION HSet_GetCapacity~%& (set() AS HSet)
```

Returns the number of items currently stored in the set.

```vb
FUNCTION HSet_GetCount~%& (set() AS HSet)
```

### Data Operations

Adds a value to the set.

```vb
SUB HSet_AddString (set() AS HSet, v AS STRING)
SUB HSet_AddByte (set() AS HSet, v AS _BYTE)
SUB HSet_AddInteger (set() AS HSet, v AS INTEGER)
SUB HSet_AddLong (set() AS HSet, v AS LONG)
SUB HSet_AddInteger64 (set() AS HSet, v AS _INTEGER64)
SUB HSet_AddSingle (set() AS HSet, v AS SINGLE)
SUB HSet_AddDouble (set() AS HSet, v AS DOUBLE)
```

Checks if a value exists in the set.

```vb
FUNCTION HSet_ContainsString%% (set() AS HSet, v AS STRING)
FUNCTION HSet_ContainsByte%% (set() AS HSet, v AS _BYTE)
FUNCTION HSet_ContainsInteger%% (set() AS HSet, v AS INTEGER)
FUNCTION HSet_ContainsLong%% (set() AS HSet, v AS LONG)
FUNCTION HSet_ContainsInteger64%% (set() AS HSet, v AS _INTEGER64)
FUNCTION HSet_ContainsSingle%% (set() AS HSet, v AS SINGLE)
FUNCTION HSet_ContainsDouble%% (set() AS HSet, v AS DOUBLE)
```

Removes a value from the set.

```vb
FUNCTION HSet_RemoveString%% (set() AS HSet, v AS STRING)
FUNCTION HSet_RemoveByte%% (set() AS HSet, v AS _BYTE)
FUNCTION HSet_RemoveInteger%% (set() AS HSet, v AS INTEGER)
FUNCTION HSet_RemoveLong%% (set() AS HSet, v AS LONG)
FUNCTION HSet_RemoveInteger64%% (set() AS HSet, v AS _INTEGER64)
FUNCTION HSet_RemoveSingle%% (set() AS HSet, v AS SINGLE)
FUNCTION HSet_RemoveDouble%% (set() AS HSet, v AS DOUBLE)
SUB HSet_RemoveString (set() AS HSet, v AS STRING)
SUB HSet_RemoveByte (set() AS HSet, v AS _BYTE)
SUB HSet_RemoveInteger (set() AS HSet, v AS INTEGER)
SUB HSet_RemoveLong (set() AS HSet, v AS LONG)
SUB HSet_RemoveInteger64 (set() AS HSet, v AS _INTEGER64)
SUB HSet_RemoveSingle (set() AS HSet, v AS SINGLE)
SUB HSet_RemoveDouble (set() AS HSet, v AS DOUBLE)
```

## UDT Support

To store **UDTs** in the set, you need to write wrapper `SUB`s around the low‑level routines. These wrappers handle packing the UDT into a raw string buffer.

```vb
''' @brief Add a value to the set.
''' @param set The set to add to.
''' @param v The value to add.
''' @param dataType The type of the value.
SUB __HSet_Add (set() AS HSet, v AS STRING, dataType AS _UNSIGNED _BYTE)

''' @brief Check if a value exists in the set.
''' @param set The set to check.
''' @param v The value to check.
''' @return True if the value exists, false otherwise.
FUNCTION __HSet_Contains%% (set() AS HSet, v AS STRING)

''' @brief Remove a value from the set.
''' @param set The set to remove from.
''' @param v The value to remove.
''' @return True if the value was removed, false otherwise.
FUNCTION __HSet_Remove%% (set() AS HSet, v AS STRING)
```

### Example

```vb
TYPE Student
    id     AS LONG
    nam    AS STRING * 50
END TYPE

SUB HSet_AddStudent (set() AS HSet, v AS Student)
    DIM buffer AS STRING: buffer = SPACE$(LEN(v))
    Memory_Copy _OFFSET(buffer), _OFFSET(v), LEN(v)
    __HSet_Add set(), buffer, QBDS_TYPE_UDT
END SUB

FUNCTION HSet_ContainsStudent%% (set() AS HSet, v AS Student)
    DIM buffer AS STRING: buffer = SPACE$(LEN(v))
    Memory_Copy _OFFSET(buffer), _OFFSET(v), LEN(v)
    HSet_ContainsStudent = __HSet_Contains(set(), buffer)
END FUNCTION

SUB HSet_RemoveStudent (set() AS HSet, v AS Student)
    DIM buffer AS STRING: buffer = SPACE$(LEN(v))
    Memory_Copy _OFFSET(buffer), _OFFSET(v), LEN(v)
    DIM ignored AS _BYTE: ignored = __HSet_Remove(set(), buffer)
END SUB
```
