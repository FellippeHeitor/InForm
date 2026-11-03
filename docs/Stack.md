# Stack Library

The `Stack` library provides a generic stack implementation. It supports storing various data types and automatically resizes itself as needed.

## Usage

To use the `Stack` library, you need to include `Stack.bi` in your project.

```vb
'$INCLUDE:'Stack.bi'

' Declare a dynamic array of Stack
REDIM myStack(0) AS Stack

' Initialize the stack
Stack_Initialize myStack()

' Push and pop values
Stack_PushString myStack(), "Hello"
Stack_PushString myStack(), "World"
Stack_PushInteger myStack(), 64

PRINT Stack_PopInteger(myStack()) ' Prints 64
PRINT Stack_PopString(myStack()) ' Prints "World"
PRINT Stack_PopString(myStack()) ' Prints "Hello"

' Free the stack
Stack_Free myStack()
```

## API Reference

### Initialization and Management

Initializes a new stack.

```vb
SUB Stack_Initialize (stack() AS Stack)
```

Clears all entries from the stack, but keeps its allocated capacity.

```vb
SUB Stack_Clear (stack() AS Stack)
```

Frees all memory associated with the stack.

```vb
SUB Stack_Free (stack() AS Stack)
```

Returns `_TRUE` if the stack has been initialized, `_FALSE` otherwise.

```vb
FUNCTION Stack_IsInitialized%% (stack() AS Stack)
```

### Capacity and Size

Returns the current maximum number of entries the stack can hold before resizing.

```vb
FUNCTION Stack_GetCapacity~%& (stack() AS Stack)
```

Returns the number of entries currently in the stack.

```vb
FUNCTION Stack_GetCount~%& (stack() AS Stack)
```

### Data Access

Returns the data type of the value at the top of the stack. See QBDS constants in `QBDS.bi`.

```vb
FUNCTION Stack_PeekElementDataType~%% (stack() AS Stack)
```

Retrieves the value from the top of the stack without removing it.

```vb
FUNCTION Stack_PeekString$ (stack() AS Stack)
FUNCTION Stack_PeekByte%% (stack() AS Stack)
FUNCTION Stack_PeekInteger% (stack() AS Stack)
FUNCTION Stack_PeekLong& (stack() AS Stack)
FUNCTION Stack_PeekInteger64&& (stack() AS Stack)
FUNCTION Stack_PeekSingle! (stack() AS Stack)
FUNCTION Stack_PeekDouble# (stack() AS Stack)
```

Pushes a value onto the top of the stack.

```vb
SUB Stack_PushString (stack() AS Stack, v AS STRING)
SUB Stack_PushByte (stack() AS Stack, v AS _BYTE)
SUB Stack_PushInteger (stack() AS Stack, v AS INTEGER)
SUB Stack_PushLong (stack() AS Stack, v AS LONG)
SUB Stack_PushInteger64 (stack() AS Stack, v AS _INTEGER64)
SUB Stack_PushSingle (stack() AS Stack, v AS SINGLE)
SUB Stack_PushDouble (stack() AS Stack, v AS DOUBLE)
```

Retrieves and removes a value from the top of the stack.

```vb
FUNCTION Stack_PopString$ (stack() AS Stack)
FUNCTION Stack_PopByte%% (stack() AS Stack)
FUNCTION Stack_PopInteger% (stack() AS Stack)
FUNCTION Stack_PopLong& (stack() AS Stack)
FUNCTION Stack_PopInteger64&& (stack() AS Stack)
FUNCTION Stack_PopSingle! (stack() AS Stack)
FUNCTION Stack_PopDouble# (stack() AS Stack)
```

## UDT Support

To store and retrieve **UDTs** in the stack, you need to write wrapper `SUB`s around the low‑level routines. These wrappers handle packing and unpacking the UDT into a raw string buffer.

```vb
''' @brief Retrieves the value from the top of the stack without removing it.
''' @param stack The stack to search.
''' @return The associated value string, or an empty string if not found.
FUNCTION __Stack_Peek$ (stack() AS Stack)

''' @brief Pushes a value onto the top of the stack.
''' @param stack The stack to update.
''' @param v The raw value string to store (packed using MK$ helpers for numeric types).
''' @param dataType The data type constant for the value being stored.
SUB __Stack_Push (stack() AS Stack, v AS STRING, dataType AS _UNSIGNED _BYTE)

''' @brief Pops a value off the top of the stack and returns it.
''' @param stack The stack to update.
''' @return The value from the top of the stack.
FUNCTION __Stack_Pop$ (stack() AS Stack)
```

### Example

```vb
TYPE Student
    id     AS LONG
    nam    AS STRING * 50
    atten  AS LONG
    grade  AS LONG
END TYPE

SUB Stack_PeekStudent (stack() AS Stack, s AS Student)
    DIM buffer AS STRING: buffer = __Stack_Peek(stack())
    Memory_Copy _OFFSET(s), _OFFSET(buffer), _MIN(LEN(s), LEN(buffer))
END SUB

SUB Stack_PushStudent (stack() AS Stack, s AS Student)
    DIM buffer AS STRING: buffer = SPACE$(LEN(s))
    Memory_Copy _OFFSET(buffer), _OFFSET(s), LEN(s)
    __Stack_Push stack(), buffer, QBDS_TYPE_UDT
END SUB

SUB Stack_PopStudent (stack() AS Stack, s AS Student)
    DIM buffer AS STRING: buffer = __Stack_Pop(stack())
    Memory_Copy _OFFSET(s), _OFFSET(buffer), _MIN(LEN(s), LEN(buffer))
END SUB
```
