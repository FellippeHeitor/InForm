# Queue Library

The `Queue` library provides a generic queue implementation. It supports storing various data types and automatically resizes itself as needed.

## Usage

To use the `Queue` library, you need to include `Queue.bi` in your project.

```vb
'$INCLUDE:'Queue.bi'

' Declare a dynamic array of Queue
REDIM myQueue(0) AS Queue

' Initialize the queue
Queue_Initialize myQueue()

' Enqueue and dequeue values
Queue_EnqueueString myQueue(), "Hello"
Queue_EnqueueString myQueue(), "World"
Queue_EnqueueInteger myQueue(), 64

PRINT Queue_DequeueString(myQueue()) ' Prints "Hello"
PRINT Queue_DequeueString(myQueue()) ' Prints "World"
PRINT Queue_DequeueInteger(myQueue()) ' Prints 64

' Free the queue
Queue_Free myQueue()
```

## API Reference

### Initialization and Management

Initializes a new queue.

```vb
SUB Queue_Initialize (q() AS Queue)
```

Clears all entries from the queue, but keeps its allocated capacity.

```vb
SUB Queue_Clear (q() AS Queue)
```

Frees all memory associated with the queue.

```vb
SUB Queue_Free (q() AS Queue)
```

Returns `_TRUE` if the queue has been initialized, `_FALSE` otherwise.

```vb
FUNCTION Queue_IsInitialized%% (q() AS Queue)
```

### Capacity and Size

Returns the current maximum number of entries the queue can hold before resizing.

```vb
FUNCTION Queue_GetCapacity~%& (q() AS Queue)
```

Returns the number of entries currently in the queue.

```vb
FUNCTION Queue_GetCount~%& (q() AS Queue)
```

### Data Access

Returns the data type of the value at the front of the queue. See QBDS constants in `QBDS.bi`.

```vb
FUNCTION Queue_PeekElementDataType~%% (q() AS Queue)
```

Retrieves the value from the front of the queue without removing it.

```vb
FUNCTION Queue_PeekString$ (q() AS Queue)
FUNCTION Queue_PeekByte%% (q() AS Queue)
FUNCTION Queue_PeekInteger% (q() AS Queue)
FUNCTION Queue_PeekLong& (q() AS Queue)
FUNCTION Queue_PeekInteger64&& (q() AS Queue)
FUNCTION Queue_PeekSingle! (q() AS Queue)
FUNCTION Queue_PeekDouble# (q() AS Queue)
```

Adds a value to the back of the queue.

```vb
SUB Queue_EnqueueString (q() AS Queue, v AS STRING)
SUB Queue_EnqueueByte (q() AS Queue, v AS _BYTE)
SUB Queue_EnqueueInteger (q() AS Queue, v AS INTEGER)
SUB Queue_EnqueueLong (q() AS Queue, v AS LONG)
SUB Queue_EnqueueInteger64 (q() AS Queue, v AS _INTEGER64)
SUB Queue_EnqueueSingle (q() AS Queue, v AS SINGLE)
SUB Queue_EnqueueDouble (q() AS Queue, v AS DOUBLE)
```

Retrieves and removes a value from the front of the queue.

```vb
FUNCTION Queue_DequeueString$ (q() AS Queue)
FUNCTION Queue_DequeueByte%% (q() AS Queue)
FUNCTION Queue_DequeueInteger% (q() AS Queue)
FUNCTION Queue_DequeueLong& (q() AS Queue)
FUNCTION Queue_DequeueInteger64&& (q() AS Queue)
FUNCTION Queue_DequeueSingle! (q() AS Queue)
FUNCTION Queue_DequeueDouble# (q() AS Queue)
```

## UDT Support

To store and retrieve **UDTs** in the queue, you need to write wrapper `SUB`s around the low‑level routines. These wrappers handle packing and unpacking the UDT into a raw string buffer.

```vb
''' @brief Retrieves the value from the front of the queue without removing it.
''' @param q The queue to search.
''' @return The associated value string, or an empty string if not found.
FUNCTION __Queue_Peek$ (q() AS Queue)

''' @brief Adds a value to the back of the queue.
''' @param q The queue to update.
''' @param v The raw value string to store (packed using MK$ helpers for numeric types).
''' @param dataType The data type constant for the value being stored.
SUB __Queue_Enqueue (q() AS Queue, v AS STRING, dataType AS _UNSIGNED _BYTE)

''' @brief Retrieves and removes a value from the front of the queue.
''' @param q The queue to update.
''' @return The value from the front of the queue.
FUNCTION __Queue_Dequeue$ (q() AS Queue)
```

### Example

```vb
TYPE Student
    id     AS LONG
    nam    AS STRING * 50
    atten  AS LONG
    grade  AS LONG
END TYPE

SUB Queue_PeekStudent (q() AS Queue, s AS Student)
    DIM buffer AS STRING: buffer = __Queue_Peek(q())
    Memory_Copy _OFFSET(s), _OFFSET(buffer), _MIN(LEN(s), LEN(buffer))
END SUB

SUB Queue_EnqueueStudent (q() AS Queue, s AS Student)
    DIM buffer AS STRING: buffer = SPACE$(LEN(s))
    Memory_Copy _OFFSET(buffer), _OFFSET(s), LEN(s)
    __Queue_Enqueue q(), buffer, QBDS_TYPE_UDT
END SUB

SUB Queue_DequeueStudent (q() AS Queue, s AS Student)
    DIM buffer AS STRING: buffer = __Queue_Dequeue(q())
    Memory_Copy _OFFSET(s), _OFFSET(buffer), _MIN(LEN(s), LEN(buffer))
END SUB
```
