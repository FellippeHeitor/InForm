'-----------------------------------------------------------------------------------------------------------------------
' Generic circular queue library for QB64-PE
' Copyright (c) 2026 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$INCLUDEONCE

'$INCLUDE:'QBDS.bi'

''' @brief Primary data structure used by the Queue library.
''' The user declares a dynamic array of this type and passes it to the Queue_* functions.
''' The library stores internal metadata at array index 0; user entries begin at index 1.
''' The queue is implemented as a ring buffer with a head and a tail pointer.
''' When the queue is full, the capacity is automatically doubled and the queue is unwrapped.
''' Metadata (stored in element 0):
'''     - V: packed count, head, and tail (_MK$(_UNSIGNED _OFFSET, count) + _MK$(_UNSIGNED _OFFSET, head) + _MK$(_UNSIGNED _OFFSET, tail))
'''     - T: QBDS_TYPE_RESERVED
TYPE Queue
    V AS STRING
    T AS _UNSIGNED _BYTE
END TYPE

''' @brief Check whether the queue has been initialized.
''' @param q The dynamic Queue array to check.
''' @return _TRUE if initialized, otherwise _FALSE.
FUNCTION Queue_IsInitialized%% (q() AS Queue)
    Queue_IsInitialized = LBOUND(q) = 0 _ANDALSO UBOUND(q) > 0 _ANDALSO q(0).T = QBDS_TYPE_RESERVED _ANDALSO LEN(q(0).V) = _SIZE_OF_OFFSET * 3
END FUNCTION

''' @brief Initialize a queue.
''' @param q The dynamic Queue array to initialize.
SUB Queue_Initialize (q() AS Queue)
    REDIM q(0 TO __QBDS_ITEMS_MIN) AS Queue
    q(0).T = QBDS_TYPE_RESERVED
    q(0).V = _MK$(_UNSIGNED _OFFSET, 0) + _MK$(_UNSIGNED _OFFSET, 1) + _MK$(_UNSIGNED _OFFSET, 1)
END SUB

''' @brief Clear the queue, but do not change the capacity.
''' @param q The queue to clear.
SUB Queue_Clear (q() AS Queue)
    REDIM q(0 TO _MAX(__QBDS_ITEMS_MIN, UBOUND(q))) AS Queue
    q(0).T = QBDS_TYPE_RESERVED
    q(0).V = _MK$(_UNSIGNED _OFFSET, 0) + _MK$(_UNSIGNED _OFFSET, 1) + _MK$(_UNSIGNED _OFFSET, 1)
END SUB

''' @brief Delete the queue and free all associated memory.
''' @param q The queue to free.
SUB Queue_Free (q() AS Queue)
    REDIM q(0) AS Queue
END SUB

''' @brief Return the current capacity of the queue.
''' @param q The queue to query.
''' @return The total number of slots in the queue.
FUNCTION Queue_GetCapacity~%& (q() AS Queue)
    Queue_GetCapacity = UBOUND(q)
END FUNCTION

''' @brief Return the number of items currently stored in the queue.
''' @param q The queue to query.
''' @return The number of items.
FUNCTION Queue_GetCount~%& (q() AS Queue)
    Queue_GetCount = _CV(_UNSIGNED _OFFSET, LEFT$(q(0).V, _SIZE_OF_OFFSET))
END FUNCTION

''' @brief Returns the data type for the value at the front of the queue.
''' @param q The queue to query.
''' @return The data type constant (QBDS_TYPE_*) or 0 if queue is empty.
FUNCTION Queue_PeekElementDataType~%% (q() AS Queue)
    IF _CV(_UNSIGNED _OFFSET, LEFT$(q(0).V, _SIZE_OF_OFFSET)) THEN
        Queue_PeekElementDataType = q(_CV(_UNSIGNED _OFFSET, MID$(q(0).V, _SIZE_OF_OFFSET + 1, _SIZE_OF_OFFSET))).T
    END IF
END FUNCTION

''' @brief Enqueue a value into the queue.
''' @param q The queue to enqueue into.
''' @param v The value to enqueue.
''' @param dataType The data type of the value.
SUB __Queue_Enqueue (q() AS Queue, v AS STRING, dataType AS _UNSIGNED _BYTE)
    DIM count AS _UNSIGNED _OFFSET: count = 1 + _CV(_UNSIGNED _OFFSET, LEFT$(q(0).V, _SIZE_OF_OFFSET))
    DIM head AS _UNSIGNED _OFFSET: head = _CV(_UNSIGNED _OFFSET, MID$(q(0).V, _SIZE_OF_OFFSET + 1, _SIZE_OF_OFFSET))
    DIM tail AS _UNSIGNED _OFFSET: tail = _CV(_UNSIGNED _OFFSET, RIGHT$(q(0).V, _SIZE_OF_OFFSET))
    DIM capacity AS _UNSIGNED _OFFSET: capacity = UBOUND(q)

    IF count > capacity THEN
        ' Resize the container array
        capacity = _MAX(__QBDS_ITEMS_MIN, _SHL(capacity, 1)) ' Grow by a factor of 2
        REDIM _PRESERVE q(0 TO capacity) AS Queue

        ' Unwrap the queue. This should now fit the new capacity since we doubled it.
        ' We will also adjust the tail while we're at it.
        tail = count
        DIM i AS _UNSIGNED _OFFSET: i = 1
        WHILE i < head
            q(tail).V = q(i).V
            q(tail).T = q(i).T

            q(i).V = _STR_EMPTY
            q(i).T = QBDS_TYPE_DELETED

            i = i + 1
            tail = tail + 1
        WEND
    END IF

    ' Store the value
    q(tail).V = v
    q(tail).T = dataType

    ' Increment the tail and wrap around if necessary
    tail = (tail AND (capacity - 1)) + 1

    ' Update the metadata
    MID$(q(0).V, 1, _SIZE_OF_OFFSET) = _MK$(_UNSIGNED _OFFSET, count)
    MID$(q(0).V, 2 * _SIZE_OF_OFFSET + 1, _SIZE_OF_OFFSET) = _MK$(_UNSIGNED _OFFSET, tail)
END SUB

''' @brief Dequeue a value from the queue.
''' @param q The queue to dequeue from.
''' @return The dequeued value.
FUNCTION __Queue_Dequeue$ (q() AS Queue)
    DIM count AS _UNSIGNED _OFFSET: count = _CV(_UNSIGNED _OFFSET, LEFT$(q(0).V, _SIZE_OF_OFFSET))
    IF count THEN
        ' Only dequeue if there are items in the queue
        DIM head AS _UNSIGNED _OFFSET: head = _CV(_UNSIGNED _OFFSET, MID$(q(0).V, _SIZE_OF_OFFSET + 1, _SIZE_OF_OFFSET))

        ' Fetch the value and then mark it as deleted
        __Queue_Dequeue = q(head).V
        q(head).V = _STR_EMPTY
        q(head).T = QBDS_TYPE_DELETED

        ' Increment the head and wrap around if necessary
        head = (head AND (UBOUND(q) - 1)) + 1
        count = count - 1

        ' Update the metadata
        MID$(q(0).V, 1, _SIZE_OF_OFFSET) = _MK$(_UNSIGNED _OFFSET, count)
        MID$(q(0).V, _SIZE_OF_OFFSET + 1, _SIZE_OF_OFFSET) = _MK$(_UNSIGNED _OFFSET, head)
    END IF
END FUNCTION

''' @brief Peek at the value at the front of the queue.
''' @param q The queue to peek at.
''' @return The value at the front of the queue.
FUNCTION __Queue_Peek$ (q() AS Queue)
    IF _CV(_UNSIGNED _OFFSET, LEFT$(q(0).V, _SIZE_OF_OFFSET)) THEN
        __Queue_Peek = q(_CV(_UNSIGNED _OFFSET, MID$(q(0).V, _SIZE_OF_OFFSET + 1, _SIZE_OF_OFFSET))).V
    END IF
END FUNCTION

''' @brief Enqueue a string into the queue.
''' @param q The queue to enqueue into.
''' @param v The string value to enqueue.
SUB Queue_EnqueueString (q() AS Queue, v AS STRING)
    __Queue_Enqueue q(), v, QBDS_TYPE_STRING
END SUB

''' @brief Dequeue a string from the queue.
''' @param q The queue to dequeue from.
''' @return The dequeued string.
FUNCTION Queue_DequeueString$ (q() AS Queue)
    Queue_DequeueString = __Queue_Dequeue(q())
END FUNCTION

''' @brief Peek at the string at the front of the queue.
''' @param q The queue to peek at.
''' @return The string at the front of the queue.
FUNCTION Queue_PeekString$ (q() AS Queue)
    Queue_PeekString = __Queue_Peek(q())
END FUNCTION

''' @brief Enqueue a byte into the queue.
''' @param q The queue to enqueue into.
''' @param v The byte value to enqueue.
SUB Queue_EnqueueByte (q() AS Queue, v AS _BYTE)
    __Queue_Enqueue q(), _MK$(_BYTE, v), QBDS_TYPE_BYTE
END SUB

''' @brief Dequeue a byte from the queue.
''' @param q The queue to dequeue from.
''' @return The dequeued byte.
FUNCTION Queue_DequeueByte%% (q() AS Queue)
    Queue_DequeueByte = _CV(_BYTE, __Queue_Dequeue(q()))
END FUNCTION

''' @brief Peek at the byte at the front of the queue.
''' @param q The queue to peek at.
''' @return The byte at the front of the queue.
FUNCTION Queue_PeekByte%% (q() AS Queue)
    Queue_PeekByte = _CV(_BYTE, __Queue_Peek(q()))
END FUNCTION

''' @brief Enqueue an integer into the queue.
''' @param q The queue to enqueue into.
''' @param v The integer value to enqueue.
SUB Queue_EnqueueInteger (q() AS Queue, v AS INTEGER)
    __Queue_Enqueue q(), MKI$(v), QBDS_TYPE_INTEGER
END SUB

''' @brief Dequeue an integer from the queue.
''' @param q The queue to dequeue from.
''' @return The dequeued integer.
FUNCTION Queue_DequeueInteger% (q() AS Queue)
    Queue_DequeueInteger = CVI(__Queue_Dequeue(q()))
END FUNCTION

''' @brief Peek at the integer at the front of the queue.
''' @param q The queue to peek at.
''' @return The integer at the front of the queue.
FUNCTION Queue_PeekInteger% (q() AS Queue)
    Queue_PeekInteger = CVI(__Queue_Peek(q()))
END FUNCTION

''' @brief Enqueue a long integer into the queue.
''' @param q The queue to enqueue into.
''' @param v The long integer value to enqueue.
SUB Queue_EnqueueLong (q() AS Queue, v AS LONG)
    __Queue_Enqueue q(), MKL$(v), QBDS_TYPE_LONG
END SUB

''' @brief Dequeue a long integer from the queue.
''' @param q The queue to dequeue from.
''' @return The dequeued long integer.
FUNCTION Queue_DequeueLong& (q() AS Queue)
    Queue_DequeueLong = CVL(__Queue_Dequeue(q()))
END FUNCTION

''' @brief Peek at the long integer at the front of the queue.
''' @param q The queue to peek at.
''' @return The long integer at the front of the queue.
FUNCTION Queue_PeekLong& (q() AS Queue)
    Queue_PeekLong = CVL(__Queue_Peek(q()))
END FUNCTION

''' @brief Enqueue a 64-bit integer into the queue.
''' @param q The queue to enqueue into.
''' @param v The 64-bit integer value to enqueue.
SUB Queue_EnqueueInteger64 (q() AS Queue, v AS _INTEGER64)
    __Queue_Enqueue q(), _MK$(_INTEGER64, v), QBDS_TYPE_INTEGER64
END SUB

''' @brief Dequeue a 64-bit integer from the queue.
''' @param q The queue to dequeue from.
''' @return The dequeued 64-bit integer.
FUNCTION Queue_DequeueInteger64&& (q() AS Queue)
    Queue_DequeueInteger64 = _CV(_INTEGER64, __Queue_Dequeue(q()))
END FUNCTION

''' @brief Peek at the 64-bit integer at the front of the queue.
''' @param q The queue to peek at.
''' @return The 64-bit integer at the front of the queue.
FUNCTION Queue_PeekInteger64&& (q() AS Queue)
    Queue_PeekInteger64 = _CV(_INTEGER64, __Queue_Peek(q()))
END FUNCTION

''' @brief Enqueue a single-precision floating-point number into the queue.
''' @param q The queue to enqueue into.
''' @param v The single-precision floating-point value to enqueue.
SUB Queue_EnqueueSingle (q() AS Queue, v AS SINGLE)
    __Queue_Enqueue q(), MKS$(v), QBDS_TYPE_SINGLE
END SUB

''' @brief Dequeue a single-precision floating-point number from the queue.
''' @param q The queue to dequeue from.
''' @return The dequeued single-precision floating-point number.
FUNCTION Queue_DequeueSingle! (q() AS Queue)
    Queue_DequeueSingle = CVS(__Queue_Dequeue(q()))
END FUNCTION

''' @brief Peek at the single-precision floating-point number at the front of the queue.
''' @param q The queue to peek at.
''' @return The single-precision floating-point number at the front of the queue.
FUNCTION Queue_PeekSingle! (q() AS Queue)
    Queue_PeekSingle = CVS(__Queue_Peek(q()))
END FUNCTION

''' @brief Enqueue a double-precision floating-point number into the queue.
''' @param q The queue to enqueue into.
''' @param v The double-precision floating-point value to enqueue.
SUB Queue_EnqueueDouble (q() AS Queue, v AS DOUBLE)
    __Queue_Enqueue q(), MKD$(v), QBDS_TYPE_DOUBLE
END SUB

''' @brief Dequeue a double-precision floating-point number from the queue.
''' @param q The queue to dequeue from.
''' @return The dequeued double-precision floating-point number.
FUNCTION Queue_DequeueDouble# (q() AS Queue)
    Queue_DequeueDouble = CVD(__Queue_Dequeue(q()))
END FUNCTION

''' @brief Peek at the double-precision floating-point number at the front of the queue.
''' @param q The queue to peek at.
''' @return The double-precision floating-point number at the front of the queue.
FUNCTION Queue_PeekDouble# (q() AS Queue)
    Queue_PeekDouble = CVD(__Queue_Peek(q()))
END FUNCTION
