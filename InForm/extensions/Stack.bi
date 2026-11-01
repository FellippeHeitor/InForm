'-----------------------------------------------------------------------------------------------------------------------
' Generic stack library for QB64-PE with support for multiple data types and dynamic resizing
' Copyright (c) 2026 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$INCLUDEONCE

'$INCLUDE:'QBDS.bi'

''' @brief Primary data structure used by the Stack library.
''' The user declares a dynamic array of this type and passes it to the Stack_* functions.
''' The library stores internal metadata at array index 0; user entries begin at index 1.
''' Metadata (stored in element 0):
'''     - V: count of items (_MK$(_UNSIGNED _OFFSET, count))
'''     - T: set to QBDS_TYPE_RESERVED
TYPE Stack
    V AS STRING ' value or metadata (count)
    T AS _UNSIGNED _BYTE ' data type of the value (0 = unused) or metadata (QBDS_TYPE_RESERVED)
END TYPE

''' @brief Check whether the stack has been initialized.
''' @param stack The dynamic Stack array to check.
''' @return _TRUE if initialized, otherwise _FALSE.
FUNCTION Stack_IsInitialized%% (stack() AS Stack)
    Stack_IsInitialized = LBOUND(stack) = 0 _ANDALSO UBOUND(stack) > 0 _ANDALSO stack(0).T = QBDS_TYPE_RESERVED _ANDALSO LEN(stack(0).V) = _SIZE_OF_OFFSET
END FUNCTION

''' @brief Initialize a stack (allocate initial table and reset metadata).
''' After this call the stack is ready for use; metadata is stored in element 0 and
''' user entries start at index 1.
''' @param stack The dynamic Stack array to initialize.
SUB Stack_Initialize (stack() AS Stack)
    REDIM stack(0 TO __QBDS_ITEMS_MIN) AS Stack
    stack(0).T = QBDS_TYPE_RESERVED
    stack(0).V = _MK$(_UNSIGNED _OFFSET, 0)
END SUB

''' @brief Clear the stack, but do not change the capacity.
''' @param stack The stack to clear.
SUB Stack_Clear (stack() AS Stack)
    REDIM stack(0 TO _MAX(__QBDS_ITEMS_MIN, UBOUND(stack))) AS Stack
    stack(0).T = QBDS_TYPE_RESERVED
    stack(0).V = _MK$(_UNSIGNED _OFFSET, 0)
END SUB

''' @brief Delete the stack and free all associated memory.
''' @param stack The stack to clear.
SUB Stack_Free (stack() AS Stack)
    REDIM stack(0) AS Stack
END SUB

''' @brief Return the current capacity of the stack.
''' @param stack The stack to query.
''' @return The total number of slots in the stack.
FUNCTION Stack_GetCapacity~%& (stack() AS Stack)
    Stack_GetCapacity = UBOUND(stack)
END FUNCTION

''' @brief Return the number of user entries currently stored in the stack.
''' @param stack The stack to query.
''' @return The number of unique items.
FUNCTION Stack_GetCount~%& (stack() AS Stack)
    Stack_GetCount = _CV(_UNSIGNED _OFFSET, stack(0).V)
END FUNCTION

''' @brief Returns the data type for the value at the top of the stack.
''' @param stack The stack to search.
''' @return The data type constant (QBDS_TYPE_*) or 0 if not found.
FUNCTION Stack_PeekElementDataType~%% (stack() AS Stack)
    DIM count AS _UNSIGNED _OFFSET: count = _CV(_UNSIGNED _OFFSET, stack(0).V)
    IF count THEN
        Stack_PeekElementDataType = stack(count).T
    END IF
END FUNCTION

''' @brief Pushes a value onto the top of the stack.
''' @param stack The stack to update.
''' @param v The raw value string to store (packed using MK$ helpers for numeric types).
''' @param dataType The data type constant for the value being stored.
SUB __Stack_Push (stack() AS Stack, v AS STRING, dataType AS _UNSIGNED _BYTE)
    DIM count AS _UNSIGNED _OFFSET: count = 1 + _CV(_UNSIGNED _OFFSET, stack(0).V)
    DIM capacity AS _UNSIGNED _OFFSET: capacity = UBOUND(stack)

    ' Resize if necessary
    IF count > capacity THEN
        REDIM _PRESERVE stack(0 TO _MAX(__QBDS_ITEMS_MIN, _SHL(capacity, 1))) AS Stack
    END IF

    ' Add new entry
    stack(count).T = dataType
    stack(count).V = v

    ' Update count
    stack(0).V = _MK$(_UNSIGNED _OFFSET, count)
END SUB

''' @brief Pops a value off the top of the stack and returns it.
''' @param stack The stack to update.
''' @return The value from the top of the stack.
FUNCTION __Stack_Pop$ (stack() AS Stack)
    DIM count AS _UNSIGNED _OFFSET: count = _CV(_UNSIGNED _OFFSET, stack(0).V)
    IF count THEN
        ' Save value and then purge it from the stack
        __Stack_Pop = stack(count).V
        stack(count).V = _STR_EMPTY

        ' Update count
        stack(0).V = _MK$(_UNSIGNED _OFFSET, count - 1)
    END IF
END FUNCTION

''' @brief Retrieves the value from the top of the stack without removing it.
''' @param stack The stack to search.
''' @return The associated value string, or an empty string if not found.
FUNCTION __Stack_Peek$ (stack() AS Stack)
    DIM count AS _UNSIGNED _OFFSET: count = _CV(_UNSIGNED _OFFSET, stack(0).V)
    IF count THEN
        __Stack_Peek = stack(count).V
    END IF
END FUNCTION

''' @brief Retrieves the value from the top of the stack without removing it.
''' @param stack The stack to search.
''' @return The associated value string, or an empty string if not found.
FUNCTION Stack_PeekString$ (stack() AS Stack)
    Stack_PeekString = __Stack_Peek(stack())
END FUNCTION

''' @brief Pushes a string onto the top of the stack.
''' @param stack The stack to update.
''' @param v The value string.
SUB Stack_PushString (stack() AS Stack, v AS STRING)
    __Stack_Push stack(), v, QBDS_TYPE_STRING
END SUB

''' @brief Pops a string off the top of the stack and returns it.
''' @param stack The stack to update.
''' @return The string from the top of the stack.
FUNCTION Stack_PopString$ (stack() AS Stack)
    Stack_PopString = __Stack_Pop(stack())
END FUNCTION

''' @brief Retrieves the value from the top of the stack without removing it.
''' @param stack The stack to search.
''' @return The associated _BYTE value.
FUNCTION Stack_PeekByte%% (stack() AS Stack)
    Stack_PeekByte = _CV(_BYTE, __Stack_Peek(stack()))
END FUNCTION

''' @brief Pushes a byte onto the top of the stack.
''' @param stack The stack to update.
''' @param v The value _BYTE.
SUB Stack_PushByte (stack() AS Stack, v AS _BYTE)
    __Stack_Push stack(), _MK$(_BYTE, v), QBDS_TYPE_BYTE
END SUB

''' @brief Pops a byte off the top of the stack and returns it.
''' @param stack The stack to update.
''' @return The byte from the top of the stack.
FUNCTION Stack_PopByte%% (stack() AS Stack)
    Stack_PopByte = _CV(_BYTE, __Stack_Pop(stack()))
END FUNCTION

''' @brief Retrieves the value from the top of the stack without removing it.
''' @param stack The stack to search.
''' @return The associated INTEGER value.
FUNCTION Stack_PeekInteger% (stack() AS Stack)
    Stack_PeekInteger = CVI(__Stack_Peek(stack()))
END FUNCTION

''' @brief Pushes an integer onto the top of the stack.
''' @param stack The stack to update.
''' @param v The value INTEGER.
SUB Stack_PushInteger (stack() AS Stack, v AS INTEGER)
    __Stack_Push stack(), MKI$(v), QBDS_TYPE_INTEGER
END SUB

''' @brief Pops an integer off the top of the stack and returns it.
''' @param stack The stack to update.
''' @return The integer from the top of the stack.
FUNCTION Stack_PopInteger% (stack() AS Stack)
    Stack_PopInteger = CVI(__Stack_Pop(stack()))
END FUNCTION

''' @brief Retrieves the value from the top of the stack without removing it.
''' @param stack The stack to search.
''' @return The associated LONG value.
FUNCTION Stack_PeekLong& (stack() AS Stack)
    Stack_PeekLong = CVL(__Stack_Peek(stack()))
END FUNCTION

''' @brief Pushes a long onto the top of the stack.
''' @param stack The stack to update.
''' @param v The value LONG.
SUB Stack_PushLong (stack() AS Stack, v AS LONG)
    __Stack_Push stack(), MKL$(v), QBDS_TYPE_LONG
END SUB

''' @brief Pops a long off the top of the stack and returns it.
''' @param stack The stack to update.
''' @return The long from the top of the stack.
FUNCTION Stack_PopLong& (stack() AS Stack)
    Stack_PopLong = CVL(__Stack_Pop(stack()))
END FUNCTION

''' @brief Retrieves the value from the top of the stack without removing it.
''' @param stack The stack to search.
''' @return The associated _INTEGER64 value.
FUNCTION Stack_PeekInteger64&& (stack() AS Stack)
    Stack_PeekInteger64 = _CV(_INTEGER64, __Stack_Peek(stack()))
END FUNCTION

''' @brief Pushes an integer64 onto the top of the stack.
''' @param stack The stack to update.
''' @param v The value _INTEGER64.
SUB Stack_PushInteger64 (stack() AS Stack, v AS _INTEGER64)
    __Stack_Push stack(), _MK$(_INTEGER64, v), QBDS_TYPE_INTEGER64
END SUB

''' @brief Pops an integer64 off the top of the stack and returns it.
''' @param stack The stack to update.
''' @return The integer64 from the top of the stack.
FUNCTION Stack_PopInteger64&& (stack() AS Stack)
    Stack_PopInteger64 = _CV(_INTEGER64, __Stack_Pop(stack()))
END FUNCTION

''' @brief Retrieves the value from the top of the stack without removing it.
''' @param stack The stack to search.
''' @return The associated SINGLE value.
FUNCTION Stack_PeekSingle! (stack() AS Stack)
    Stack_PeekSingle = CVS(__Stack_Peek(stack()))
END FUNCTION

''' @brief Pushes a single onto the top of the stack.
''' @param stack The stack to update.
''' @param v The value SINGLE.
SUB Stack_PushSingle (stack() AS Stack, v AS SINGLE)
    __Stack_Push stack(), MKS$(v), QBDS_TYPE_SINGLE
END SUB

''' @brief Pops a single off the top of the stack and returns it.
''' @param stack The stack to update.
''' @return The single from the top of the stack.
FUNCTION Stack_PopSingle! (stack() AS Stack)
    Stack_PopSingle = CVS(__Stack_Pop(stack()))
END FUNCTION

''' @brief Retrieves the value from the top of the stack without removing it.
''' @param stack The stack to search.
''' @return The associated DOUBLE value.
FUNCTION Stack_PeekDouble# (stack() AS Stack)
    Stack_PeekDouble = CVD(__Stack_Peek(stack()))
END FUNCTION

''' @brief Pushes a double onto the top of the stack.
''' @param stack The stack to update.
''' @param v The value DOUBLE.
SUB Stack_PushDouble (stack() AS Stack, v AS DOUBLE)
    __Stack_Push stack(), MKD$(v), QBDS_TYPE_DOUBLE
END SUB

''' @brief Pops a double off the top of the stack and returns it.
''' @param stack The stack to update.
''' @return The double from the top of the stack.
FUNCTION Stack_PopDouble# (stack() AS Stack)
    Stack_PopDouble = CVD(__Stack_Pop(stack()))
END FUNCTION
