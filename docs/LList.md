# LList Library

The `LList` library provides a generic doubly-linked list implementation. It supports storing various data types and automatically resizes itself as needed.

## Usage

To use the `LList` library, you need to include `LList.bi` in your project.

```vb
'$INCLUDE:'LList.bi'

' Declare a dynamic array of LList
REDIM myList(0) AS LList

' Initialize the list
LList_Initialize myList()

' Add elements
LList_PushBackString myList(), "Hello"
LList_PushFrontString myList(), "World"

' Iterate through the list
DIM node AS _UNSIGNED _OFFSET: node = LList_GetFrontNode(myList())
WHILE node
    PRINT LList_GetString(myList(), node)

    node = LList_GetNextNode(myList(), node) ' Move to the next node
WEND

' Free the list
LList_Free myList()
```

## API Reference

### Initialization and Management

Initializes a new list.

```vb
SUB LList_Initialize (lst() AS LList)
```

Clears all entries from the list, but keeps its allocated capacity.

```vb
SUB LList_Clear (lst() AS LList)
```

Frees all memory associated with the list.

```vb
SUB LList_Free (lst() AS LList)
```

Returns `_TRUE` if the list has been initialized, `_FALSE` otherwise.

```vb
FUNCTION LList_IsInitialized%% (lst() AS LList)
```

### Capacity and Size

Returns the current maximum number of entries the list can hold before resizing.

```vb
FUNCTION LList_GetCapacity~%& (lst() AS LList)
```

Returns the number of entries currently in the list.

```vb
FUNCTION LList_GetCount~%& (lst() AS LList)
```

### Node Management

Returns the index of the first node in the list.

```vb
FUNCTION LList_GetFrontNode~%& (lst() AS LList)
```

Returns the index of the last node in the list.

```vb
FUNCTION LList_GetBackNode~%& (lst() AS LList)
```

Returns the index of the node after the given node.

```vb
FUNCTION LList_GetNextNode~%& (lst() AS LList, node AS _UNSIGNED _OFFSET)
```

Returns the index of the node before the given node.

```vb
FUNCTION LList_GetPreviousNode~%& (lst() AS LList, node AS _UNSIGNED _OFFSET)
```

Deletes a node from the list. Returns `_TRUE` if the node was deleted, `_FALSE` otherwise.

```vb
FUNCTION LList_RemoveNode%% (lst() AS LList, node AS _UNSIGNED _OFFSET)
```

Deletes a node from the list (SUB version, no return value).

```vb
SUB LList_RemoveNode (lst() AS LList, node AS _UNSIGNED _OFFSET)
```

Checks if a node exists in the list. Returns `_TRUE` if the node exists, `_FALSE` otherwise.

```vb
FUNCTION LList_NodeExists%% (lst() AS LList, node AS _UNSIGNED _OFFSET)
```

Returns the data type of the value associated with a node.

```vb
FUNCTION LList_GetNodeDataType~%% (lst() AS LList, node AS _UNSIGNED _OFFSET)
```

Swaps the values of two nodes in the list.

```vb
SUB LList_SwapNodeValues (lst() AS LList, nodeA AS _UNSIGNED _OFFSET, nodeB AS _UNSIGNED _OFFSET)
```

### Circular List

Returns `_TRUE` if the list is circular, `_FALSE` otherwise.

```vb
FUNCTION LList_IsCircular%% (lst() AS LList)
```

Sets whether the list is circular.

```vb
SUB LList_MakeCircular (lst() AS LList, isCircular AS _BYTE)
```

### Data Access

Retrieves the value for a given node.

```vb
FUNCTION LList_GetString$ (lst() AS LList, node AS _UNSIGNED _OFFSET)
FUNCTION LList_GetByte%% (lst() AS LList, node AS _UNSIGNED _OFFSET)
FUNCTION LList_GetInteger% (lst() AS LList, node AS _UNSIGNED _OFFSET)
FUNCTION LList_GetLong& (lst() AS LList, node AS _UNSIGNED _OFFSET)
FUNCTION LList_GetInteger64&& (lst() AS LList, node AS _UNSIGNED _OFFSET)
FUNCTION LList_GetSingle! (lst() AS LList, node AS _UNSIGNED _OFFSET)
FUNCTION LList_GetDouble# (lst() AS LList, node AS _UNSIGNED _OFFSET)
```

Sets the value for a given node.

```vb
SUB LList_SetString (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS STRING)
SUB LList_SetByte (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS _BYTE)
SUB LList_SetInteger (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS INTEGER)
SUB LList_SetLong (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS LONG)
SUB LList_SetInteger64 (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS _INTEGER64)
SUB LList_SetSingle (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS SINGLE)
SUB LList_SetDouble (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS DOUBLE)
```

Inserts a value before the given node.

```vb
SUB LList_InsertBeforeString (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS STRING)
SUB LList_InsertBeforeByte (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS _BYTE)
SUB LList_InsertBeforeInteger (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS INTEGER)
SUB LList_InsertBeforeLong (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS LONG)
SUB LList_InsertBeforeInteger64 (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS _INTEGER64)
SUB LList_InsertBeforeSingle (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS SINGLE)
SUB LList_InsertBeforeDouble (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS DOUBLE)
```

Inserts a value after the given node.

```vb
SUB LList_InsertAfterString (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS STRING)
SUB LList_InsertAfterByte (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS _BYTE)
SUB LList_InsertAfterInteger (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS INTEGER)
SUB LList_InsertAfterLong (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS LONG)
SUB LList_InsertAfterInteger64 (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS _INTEGER64)
SUB LList_InsertAfterSingle (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS SINGLE)
SUB LList_InsertAfterDouble (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS DOUBLE)
```

Adds a value to the beginning of the list.

```vb
SUB LList_PushFrontString (lst() AS LList, v AS STRING)
SUB LList_PushFrontByte (lst() AS LList, v AS _BYTE)
SUB LList_PushFrontInteger (lst() AS LList, v AS INTEGER)
SUB LList_PushFrontLong (lst() AS LList, v AS LONG)
SUB LList_PushFrontInteger64 (lst() AS LList, v AS _INTEGER64)
SUB LList_PushFrontSingle (lst() AS LList, v AS SINGLE)
SUB LList_PushFrontDouble (lst() AS LList, v AS DOUBLE)
```

Adds a value to the end of the list.

```vb
SUB LList_PushBackString (lst() AS LList, v AS STRING)
SUB LList_PushBackByte (lst() AS LList, v AS _BYTE)
SUB LList_PushBackInteger (lst() AS LList, v AS INTEGER)
SUB LList_PushBackLong (lst() AS LList, v AS LONG)
SUB LList_PushBackInteger64 (lst() AS LList, v AS _INTEGER64)
SUB LList_PushBackSingle (lst() AS LList, v AS SINGLE)
SUB LList_PushBackDouble (lst() AS LList, v AS DOUBLE)
```

Retrieves and removes a value from the front of the list.

```vb
FUNCTION LList_PopFrontString$ (lst() AS LList)
FUNCTION LList_PopFrontByte%% (lst() AS LList)
FUNCTION LList_PopFrontInteger% (lst() AS LList)
FUNCTION LList_PopFrontLong& (lst() AS LList)
FUNCTION LList_PopFrontInteger64&& (lst() AS LList)
FUNCTION LList_PopFrontSingle! (lst() AS LList)
FUNCTION LList_PopFrontDouble# (lst() AS LList)
```

Retrieves and removes a value from the back of the list.

```vb
FUNCTION LList_PopBackString$ (lst() AS LList)
FUNCTION LList_PopBackByte%% (lst() AS LList)
FUNCTION LList_PopBackInteger% (lst() AS LList)
FUNCTION LList_PopBackLong& (lst() AS LList)
FUNCTION LList_PopBackInteger64&& (lst() AS LList)
FUNCTION LList_PopBackSingle! (lst() AS LList)
FUNCTION LList_PopBackDouble# (lst() AS LList)
```

## UDT Support

To store and retrieve **UDTs** in the list, you need to write wrapper `SUB`s around the low‑level and public routines. These wrappers handle packing and unpacking the UDT into a raw string buffer.

```vb
''' @brief Sets the value for a given node.
''' @param lst The list to update.
''' @param node The node to set the value for.
''' @param v The raw value string to set.
''' @param t The data type constant for the value being set.
SUB __LList_Set (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS STRING, t AS _UNSIGNED _OFFSET)

''' @brief Retrieves the value for a given node.
''' @param lst The list to search.
''' @param node The node to get the value for.
''' @return The associated raw value string, or an empty string if not found.
FUNCTION __LList_Get$ (lst() AS LList, node AS _UNSIGNED _OFFSET)

''' @brief Inserts an element at the specified node's position.
''' This shifts existing elements to the right in the order they are linked.
''' @param lst The list to update.
''' @param node The index to insert the item at.
''' @param v The raw value string to store (packed using MK$ helpers for numeric types).
''' @param dataType The data type constant for the value being stored.
SUB __LList_InsertBefore (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS STRING, dataType AS _UNSIGNED _BYTE)

''' @brief Inserts an element at the specified node's position.
''' This shifts existing elements to the left in the order they are linked.
''' @param lst The list to update.
''' @param node The index to insert the item at.
''' @param v The raw value string to store (packed using MK$ helpers for numeric types).
''' @param dataType The data type constant for the value being stored.
SUB __LList_InsertAfter (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS STRING, dataType AS _UNSIGNED _BYTE)

''' @brief Inserts an element to the beginning of the list.
''' @param lst The list to update.
''' @param v The raw value string to store (packed using MK$ helpers for numeric types).
''' @param dataType The data type constant for the value being stored.
SUB __LList_PushFront (lst() AS LList, v AS STRING, dataType AS _UNSIGNED _BYTE)

''' @brief Adds an element to the end of the list.
''' @param lst The list to update.
''' @param v The raw value string to store (packed using MK$ helpers for numeric types).
''' @param dataType The data type constant for the value being stored.
SUB __LList_PushBack (lst() AS LList, v AS STRING, dataType AS _UNSIGNED _BYTE)
```

### Example

```vb
TYPE Person
    nam AS STRING * 50
    age AS _UNSIGNED _BYTE
END TYPE

SUB LList_GetPerson (lst() AS LList, node AS _UNSIGNED _OFFSET, p AS Person)
    DIM buffer AS STRING: buffer = __LList_Get(lst(), node)
    Memory_Copy _OFFSET(p), _OFFSET(buffer), _MIN(LEN(p), LEN(buffer))
END SUB

SUB LList_SetPerson (lst() AS LList, node AS _UNSIGNED _OFFSET, p AS Person)
    DIM buffer AS STRING: buffer = SPACE$(LEN(p))
    Memory_Copy _OFFSET(buffer), _OFFSET(p), LEN(p)
    __LList_Set lst(), node, buffer, QBDS_TYPE_UDT
END SUB

SUB LList_InsertBeforePerson (lst() AS LList, node AS _UNSIGNED _OFFSET, p AS Person)
    DIM buffer AS STRING: buffer = SPACE$(LEN(p))
    Memory_Copy _OFFSET(buffer), _OFFSET(p), LEN(p)
    __LList_InsertBefore lst(), node, buffer, QBDS_TYPE_UDT
END SUB

SUB LList_InsertAfterPerson (lst() AS LList, node AS _UNSIGNED _OFFSET, p AS Person)
    DIM buffer AS STRING: buffer = SPACE$(LEN(p))
    Memory_Copy _OFFSET(buffer), _OFFSET(p), LEN(p)
    __LList_InsertAfter lst(), node, buffer, QBDS_TYPE_UDT
END SUB

SUB LList_PushFrontPerson (lst() AS LList, p AS Person)
    DIM buffer AS STRING: buffer = SPACE$(LEN(p))
    Memory_Copy _OFFSET(buffer), _OFFSET(p), LEN(p)
    __LList_PushFront lst(), buffer, QBDS_TYPE_UDT
END SUB

SUB LList_PushBackPerson (lst() AS LList, p AS Person)
    DIM buffer AS STRING: buffer = SPACE$(LEN(p))
    Memory_Copy _OFFSET(buffer), _OFFSET(p), LEN(p)
    __LList_PushBack lst(), buffer, QBDS_TYPE_UDT
END SUB

SUB LList_PopFrontPerson (lst() AS LList, p AS Person)
    DIM node AS _UNSIGNED _OFFSET: node = LList_GetFrontNode(lst())
    DIM buffer AS STRING: buffer = __LList_Get(lst(), node)
    Memory_Copy _OFFSET(p), _OFFSET(buffer), _MIN(LEN(p), LEN(buffer))
    LList_RemoveNode lst(), node
END SUB

SUB LList_PopBackPerson (lst() AS LList, p AS Person)
    DIM node AS _UNSIGNED _OFFSET: node = LList_GetBackNode(lst())
    DIM buffer AS STRING: buffer = __LList_Get(lst(), node)
    Memory_Copy _OFFSET(p), _OFFSET(buffer), _MIN(LEN(p), LEN(buffer))
    LList_RemoveNode lst(), node
END SUB
```
