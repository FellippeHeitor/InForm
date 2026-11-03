'-----------------------------------------------------------------------------------------------------------------------
' Generic list library for QB64-PE with support for multiple data types and dynamic resizing
' Copyright (c) 2026 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$INCLUDEONCE

'$INCLUDE:'QBDS.bi'

''' @brief Primary data structure used by the LList library.
''' The user declares a dynamic array of this type and passes it to the LList_* functions.
''' The library stores internal metadata at array index 0; user entries begin at index 1.
''' Metadata (stored in element 0):
'''     - p: head node index
'''     - n: tail node index
'''     - V: packed count + last free index (_MK$(_UNSIGNED _OFFSET, count) + _MK$(_UNSIGNED _OFFSET, lastFree))
'''     - T: QBDS_TYPE_RESERVED
TYPE LList
    p AS _UNSIGNED _OFFSET ' index of previous entry
    n AS _UNSIGNED _OFFSET ' index of next entry
    V AS STRING ' value
    T AS _UNSIGNED _BYTE ' data type of the value (0 = unused)
END TYPE

''' @brief Check whether the list has been initialized.
''' @param lst The dynamic List array to check.
''' @return _TRUE if initialized, otherwise _FALSE.
FUNCTION LList_IsInitialized%% (lst() AS LList)
    LList_IsInitialized = LBOUND(lst) = 0 _ANDALSO UBOUND(lst) > 0 _ANDALSO lst(0).T = QBDS_TYPE_RESERVED _ANDALSO LEN(lst(0).V) = _SIZE_OF_OFFSET * 2
END FUNCTION

''' @brief Initialize a list (allocate initial table and reset metadata).
''' After this call the list is ready for use; metadata is stored in element 0 and
''' user entries start at index 1.
''' @param lst The dynamic List array to initialize.
SUB LList_Initialize (lst() AS LList)
    REDIM lst(0 TO __QBDS_ITEMS_MIN) AS LList ' power of 2 initial size
    lst(0).V = _MK$(_UNSIGNED _OFFSET, 0) + _MK$(_UNSIGNED _OFFSET, 1) ' reset count to zero, last free index to 1
    lst(0).T = QBDS_TYPE_RESERVED ' set to reserved
END SUB

''' @brief Clear the list, but do not change the capacity.
''' @param lst The list to clear.
SUB LList_Clear (lst() AS LList)
    REDIM lst(0 TO _MAX(__QBDS_ITEMS_MIN, UBOUND(lst))) AS LList
    lst(0).V = _MK$(_UNSIGNED _OFFSET, 0) + _MK$(_UNSIGNED _OFFSET, 1) ' reset count to zero, last free index to 1
    lst(0).T = QBDS_TYPE_RESERVED ' set to reserved
END SUB

''' @brief Delete the list and free all associated memory.
''' @param lst The list to clear.
SUB LList_Free (lst() AS LList)
    REDIM lst(0) AS LList
END SUB

''' @brief Return the current capacity of the list.
''' @param lst The list to query.
''' @return The total number of slots in the list.
FUNCTION LList_GetCapacity~%& (lst() AS LList)
    LList_GetCapacity = UBOUND(lst)
END FUNCTION

''' @brief Return the number of user entries currently stored in the list.
''' @param lst The list to query.
''' @return The number of unique items.
FUNCTION LList_GetCount~%& (lst() AS LList)
    LList_GetCount = _CV(_UNSIGNED _OFFSET, LEFT$(lst(0).V, _SIZE_OF_OFFSET))
END FUNCTION

''' @brief Returns the data type for the given node.
''' @param lst The list to search.
''' @param node The node to get the data type for.
''' @return The data type constant (QBDS_TYPE_*) or 0 if not found.
FUNCTION LList_GetNodeDataType~%% (lst() AS LList, node AS _UNSIGNED _OFFSET)
    IF node > 0 _ANDALSO node <= UBOUND(lst) _ANDALSO lst(node).T > QBDS_TYPE_DELETED THEN
        LList_GetNodeDataType = lst(node).T
    END IF
END FUNCTION

''' @brief Returns _TRUE if the list is circularly linked, otherwise _FALSE.
''' @param lst The list to query.
''' @return _TRUE if circular, otherwise _FALSE.
FUNCTION LList_IsCircular%% (lst() AS LList)
    DIM head AS _UNSIGNED _OFFSET: head = lst(0).p
    DIM tail AS _UNSIGNED _OFFSET: tail = lst(0).n
    LList_IsCircular = head _ANDALSO tail _ANDALSO lst(head).p = tail _ANDALSO lst(tail).n = head
END FUNCTION

''' @brief Enable or disable circular linking.
''' @param lst The list to update.
''' @param isCircular _TRUE to enable circular linking, _FALSE to disable.
SUB LList_MakeCircular (lst() AS LList, isCircular AS _BYTE)
    DIM head AS _UNSIGNED _OFFSET: head = lst(0).p
    DIM tail AS _UNSIGNED _OFFSET: tail = lst(0).n
    IF head _ANDALSO tail THEN
        IF isCircular THEN
            lst(head).p = tail
            lst(tail).n = head
        ELSE
            lst(head).p = 0
            lst(tail).n = 0
        END IF
    END IF
END SUB

''' @brief Get the index of the front (head) node.
''' @param lst The list to query.
''' @return The index of the front node, or 0 if the list is empty.
FUNCTION LList_GetFrontNode~%& (lst() AS LList)
    LList_GetFrontNode = lst(0).p
END FUNCTION

''' @brief Get the index of the back (tail) node.
''' @param lst The list to query.
''' @return The index of the back node, or 0 if the list is empty.
FUNCTION LList_GetBackNode~%& (lst() AS LList)
    LList_GetBackNode = lst(0).n
END FUNCTION

''' @brief Get the index of the next node.
''' @param lst The list to query.
''' @param node The node to get the next node for.
''' @return The index of the next node, or 0 if the node is not found.
FUNCTION LList_GetNextNode~%& (lst() AS LList, node AS _UNSIGNED _OFFSET)
    IF node > 0 _ANDALSO node <= UBOUND(lst) _ANDALSO lst(node).T > QBDS_TYPE_DELETED THEN
        LList_GetNextNode = lst(node).n
    END IF
END FUNCTION

''' @brief Get the index of the previous node.
''' @param lst The list to query.
''' @param node The node to get the previous node for.
''' @return The index of the previous node, or 0 if the node is not found.
FUNCTION LList_GetPreviousNode~%& (lst() AS LList, node AS _UNSIGNED _OFFSET)
    IF node > 0 _ANDALSO node <= UBOUND(lst) _ANDALSO lst(node).T > QBDS_TYPE_DELETED THEN
        LList_GetPreviousNode = lst(node).p
    END IF
END FUNCTION

''' @brief Deletes the specified node from the list.
''' @param lst The list to update.
''' @param node The node to delete.
''' @return _TRUE if the node was deleted, otherwise _FALSE.
FUNCTION LList_RemoveNode%% (lst() AS LList, node AS _UNSIGNED _OFFSET)
    IF node > 0 _ANDALSO node <= UBOUND(lst) _ANDALSO lst(node).T > QBDS_TYPE_DELETED THEN
        DIM count AS _UNSIGNED _OFFSET: count = _CV(_UNSIGNED _OFFSET, LEFT$(lst(0).V, _SIZE_OF_OFFSET))
        IF count = 1 THEN
            ' List becomes empty
            lst(0).p = 0
            lst(0).n = 0
        ELSE
            ' Read metadata
            DIM head AS _UNSIGNED _OFFSET: head = lst(0).p
            DIM tail AS _UNSIGNED _OFFSET: tail = lst(0).n

            ' Detect circularity before we change anything
            DIM wasCircular AS _BYTE: wasCircular = head _ANDALSO tail _ANDALSO lst(head).p = tail _ANDALSO lst(tail).n = head

            ' Cache neighbors
            DIM prevNode AS _UNSIGNED _OFFSET: prevNode = lst(node).p
            DIM nextNode AS _UNSIGNED _OFFSET: nextNode = lst(node).n

            ' Unlink neighbors
            IF prevNode THEN lst(prevNode).n = nextNode
            IF nextNode THEN lst(nextNode).p = prevNode

            ' Update head/tail if we're deleting one of them
            IF node = lst(0).p THEN lst(0).p = nextNode
            IF node = lst(0).n THEN lst(0).n = prevNode

            ' If it was circular and list not empty now, restore circularity
            IF wasCircular THEN
                head = lst(0).p
                tail = lst(0).n
                IF head _ANDALSO tail THEN
                    lst(head).p = tail
                    lst(tail).n = head
                END IF
            END IF
        END IF

        ' Clear the removed node and mark tombstone
        lst(node).p = 0
        lst(node).n = 0
        lst(node).T = QBDS_TYPE_DELETED
        lst(node).V = _STR_EMPTY

        ' Update count
        MID$(lst(0).V, 1, _SIZE_OF_OFFSET) = _MK$(_UNSIGNED _OFFSET, count - 1)

        IF node < _CV(_UNSIGNED _OFFSET, RIGHT$(lst(0).V, _SIZE_OF_OFFSET)) THEN
            ' Note lowest free index
            MID$(lst(0).V, _SIZE_OF_OFFSET + 1, _SIZE_OF_OFFSET) = _MK$(_UNSIGNED _OFFSET, node)
        END IF

        LList_RemoveNode = _TRUE
    END IF
END FUNCTION

''' @brief Deletes the specified node from the list.
''' @param lst The list to update.
''' @param node The index of the node to delete.
SUB LList_RemoveNode (lst() AS LList, node AS _UNSIGNED _OFFSET)
    DIM ignored AS _BYTE: ignored = LList_RemoveNode(lst(), node)
END SUB

''' @brief Checks whether the specified node exists in the list.
''' @param lst The list to query.
''' @param node The node to check.
''' @return _TRUE if the node exists, otherwise _FALSE.
FUNCTION LList_NodeExists%% (lst() AS LList, node AS _UNSIGNED _OFFSET)
    LList_NodeExists = node > 0 _ANDALSO node <= UBOUND(lst) _ANDALSO lst(node).T > QBDS_TYPE_DELETED
END FUNCTION

''' @brief Swaps the values of two nodes in the list.
''' @param lst The list to update.
''' @param nodeA The first node to swap.
''' @param nodeB The second node to swap.
SUB LList_SwapNodeValues (lst() AS LList, nodeA AS _UNSIGNED _OFFSET, nodeB AS _UNSIGNED _OFFSET)
    IF nodeA > 0 _ANDALSO nodeA <= UBOUND(lst) _ANDALSO lst(nodeA).T > QBDS_TYPE_DELETED _ANDALSO nodeB > 0 _ANDALSO nodeB <= UBOUND(lst) _ANDALSO lst(nodeB).T > QBDS_TYPE_DELETED THEN
        DIM tempV AS STRING: tempV = lst(nodeA).V
        DIM tempT AS _UNSIGNED _BYTE: tempT = lst(nodeA).T

        lst(nodeA).V = lst(nodeB).V
        lst(nodeA).T = lst(nodeB).T

        lst(nodeB).V = tempV
        lst(nodeB).T = tempT
    ELSE
        ERROR _ERR_SUBSCRIPT_OUT_OF_RANGE
    END IF
END SUB

''' @brief Allocates a new node and returns its index.
''' @param lst The list to update.
''' @return The index of the new node.
FUNCTION __LList_AllocateNewNode~%& (lst() AS LList)
    ' Cache the count and capacity in case we need to resize
    DIM count AS _UNSIGNED _OFFSET: count = _CV(_UNSIGNED _OFFSET, LEFT$(lst(0).V, _SIZE_OF_OFFSET))
    DIM capacity AS _UNSIGNED _OFFSET: capacity = UBOUND(lst)

    IF count >= capacity THEN
        ' Resize the list container array
        capacity = _MAX(__QBDS_ITEMS_MIN, _SHL(capacity, 1))
        REDIM _PRESERVE lst(0 TO capacity) AS LList
    END IF

    ' Cache the lowest free index
    DIM newNode AS _UNSIGNED _OFFSET: newNode = _MAX(1, _CV(_UNSIGNED _OFFSET, RIGHT$(lst(0).V, _SIZE_OF_OFFSET)))

    ' Find the index where we can insert the new node
    WHILE newNode <= capacity _ANDALSO lst(newNode).T > QBDS_TYPE_DELETED
        newNode = newNode + 1
    WEND

    IF newNode > capacity THEN
        ' This should never happen
        ERROR _ERR_INTERNAL_ERROR
        EXIT FUNCTION
    END IF

    ' Update the count and lowest free index
    MID$(lst(0).V, 1, _SIZE_OF_OFFSET) = _MK$(_UNSIGNED _OFFSET, count + 1)
    MID$(lst(0).V, _SIZE_OF_OFFSET + 1, _SIZE_OF_OFFSET) = _MK$(_UNSIGNED _OFFSET, newNode + 1)

    __LList_AllocateNewNode = newNode
END FUNCTION

''' @brief Inserts an element at the specified node's position.
''' This shifts existing elements to the right in the order they are linked.
''' @param lst The list to update.
''' @param node The index to insert the item at.
''' @param v The raw value string to store (packed using MK$ helpers for numeric types).
''' @param dataType The data type constant for the value being stored.
SUB __LList_InsertBefore (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS STRING, dataType AS _UNSIGNED _BYTE)
    IF node < 1 _ORELSE node > UBOUND(lst) _ORELSE lst(node).T <= QBDS_TYPE_DELETED THEN
        ' Throw an error if the node is not valid
        ERROR _ERR_SUBSCRIPT_OUT_OF_RANGE
        EXIT SUB
    END IF

    DIM newNode AS _UNSIGNED _OFFSET: newNode = __LList_AllocateNewNode(lst())
    IF newNode = 0 THEN
        ' This should never happen
        ERROR _ERR_INTERNAL_ERROR
        EXIT SUB
    END IF

    ' Wire links before node
    DIM prev AS _UNSIGNED _OFFSET: prev = lst(node).p
    lst(newNode).p = prev
    lst(newNode).n = node
    lst(node).p = newNode

    ' If previous exists, fix its next
    IF prev THEN lst(prev).n = newNode

    ' If we inserted before head, move head
    IF node = lst(0).p THEN lst(0).p = newNode

    ' Set payload
    lst(newNode).V = v
    lst(newNode).T = dataType
END SUB

''' @brief Inserts an element at the specified node's position.
''' This shifts existing elements to the left in the order they are linked.
''' @param lst The list to update.
''' @param node The index to insert the item at.
''' @param v The raw value string to store (packed using MK$ helpers for numeric types).
''' @param dataType The data type constant for the value being stored.
SUB __LList_InsertAfter (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS STRING, dataType AS _UNSIGNED _BYTE)
    IF node < 1 _ORELSE node > UBOUND(lst) _ORELSE lst(node).T <= QBDS_TYPE_DELETED THEN
        ' Throw an error if the node is not valid
        ERROR _ERR_SUBSCRIPT_OUT_OF_RANGE
        EXIT SUB
    END IF

    ' Allocate new node
    DIM newNode AS _UNSIGNED _OFFSET: newNode = __LList_AllocateNewNode(lst())
    IF newNode = 0 THEN
        ' This should never happen
        ERROR _ERR_INTERNAL_ERROR
        EXIT SUB
    END IF

    ' Wire links after node
    DIM oldNext AS _UNSIGNED _OFFSET: oldNext = lst(node).n
    lst(newNode).p = node
    lst(newNode).n = oldNext
    lst(node).n = newNode

    ' Fix next node's prev if it exists
    IF oldNext THEN lst(oldNext).p = newNode

    ' Update tail if we inserted after the tail
    IF node = lst(0).n THEN lst(0).n = newNode

    ' Set payload
    lst(newNode).V = v
    lst(newNode).T = dataType
END SUB

''' @brief Inserts an element to the beginning of the list.
''' @param lst The list to update.
''' @param v The raw value string to store (packed using MK$ helpers for numeric types).
''' @param dataType The data type constant for the value being stored.
SUB __LList_PushFront (lst() AS LList, v AS STRING, dataType AS _UNSIGNED _BYTE)
    DIM count AS _UNSIGNED _OFFSET: count = _CV(_UNSIGNED _OFFSET, LEFT$(lst(0).V, _SIZE_OF_OFFSET))
    IF count THEN
        ' Insert before current head
        __LList_InsertBefore lst(), (lst(0).p), v, dataType ' pass node by value
    ELSE
        ' Create first node
        DIM newNode AS _UNSIGNED _OFFSET: newNode = __LList_AllocateNewNode(lst())
        IF newNode = 0 THEN
            ' This should never happen
            ERROR _ERR_INTERNAL_ERROR
            EXIT SUB
        END IF

        ' Set as head and tail
        lst(0).p = newNode
        lst(0).n = newNode

        ' Clear previous and next
        lst(newNode).p = 0
        lst(newNode).n = 0

        ' Set payload
        lst(newNode).V = v
        lst(newNode).T = dataType
    END IF
END SUB

''' @brief Adds an element to the end of the list.
''' @param lst The list to update.
''' @param v The raw value string to store (packed using MK$ helpers for numeric types).
''' @param dataType The data type constant for the value being stored.
SUB __LList_PushBack (lst() AS LList, v AS STRING, dataType AS _UNSIGNED _BYTE)
    DIM count AS _UNSIGNED _OFFSET: count = _CV(_UNSIGNED _OFFSET, LEFT$(lst(0).V, _SIZE_OF_OFFSET))
    IF count THEN
        ' Insert after current tail
        __LList_InsertAfter lst(), (lst(0).n), v, dataType ' pass node by value
    ELSE
        ' Create first node
        DIM newNode AS _UNSIGNED _OFFSET: newNode = __LList_AllocateNewNode(lst())
        IF newNode = 0 THEN
            ' This should never happen
            ERROR _ERR_INTERNAL_ERROR
            EXIT SUB
        END IF

        ' Set as head and tail
        lst(0).p = newNode
        lst(0).n = newNode

        ' Clear previous and next
        lst(newNode).p = 0
        lst(newNode).n = 0

        ' Set payload
        lst(newNode).V = v
        lst(newNode).T = dataType
    END IF
END SUB

''' @brief Inserts an element before the specified node's position.
''' @param lst The list to update.
''' @param node The index to insert the item at.
''' @param v The string value to store.
SUB LList_InsertBeforeString (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS STRING)
    __LList_InsertBefore lst(), node, v, QBDS_TYPE_STRING
END SUB

''' @brief Inserts an element after the specified node's position.
''' @param lst The list to update.
''' @param node The index to insert the item at.
''' @param v The string value to store.
SUB LList_InsertAfterString (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS STRING)
    __LList_InsertAfter lst(), node, v, QBDS_TYPE_STRING
END SUB

''' @brief Adds an element to the beginning of the list.
''' @param lst The list to update.
''' @param v The string value to store.
SUB LList_PushFrontString (lst() AS LList, v AS STRING)
    __LList_PushFront lst(), v, QBDS_TYPE_STRING
END SUB

''' @brief Adds an element to the end of the list.
''' @param lst The list to update.
''' @param v The string value to store.
SUB LList_PushBackString (lst() AS LList, v AS STRING)
    __LList_PushBack lst(), v, QBDS_TYPE_STRING
END SUB

''' @brief Inserts an element before the specified node's position.
''' @param lst The list to update.
''' @param node The index to insert the item at.
''' @param v The byte value to store.
SUB LList_InsertBeforeByte (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS _BYTE)
    __LList_InsertBefore lst(), node, _MK$(_BYTE, v), QBDS_TYPE_BYTE
END SUB

''' @brief Inserts an element after the specified node's position.
''' @param lst The list to update.
''' @param node The index to insert the item at.
''' @param v The byte value to store.
SUB LList_InsertAfterByte (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS _BYTE)
    __LList_InsertAfter lst(), node, _MK$(_BYTE, v), QBDS_TYPE_BYTE
END SUB

''' @brief Adds an element to the beginning of the list.
''' @param lst The list to update.
''' @param v The byte value to store.
SUB LList_PushFrontByte (lst() AS LList, v AS _BYTE)
    __LList_PushFront lst(), _MK$(_BYTE, v), QBDS_TYPE_BYTE
END SUB

''' @brief Adds an element to the end of the list.
''' @param lst The list to update.
''' @param v The byte value to store.
SUB LList_PushBackByte (lst() AS LList, v AS _BYTE)
    __LList_PushBack lst(), _MK$(_BYTE, v), QBDS_TYPE_BYTE
END SUB

''' @brief Inserts an element before the specified node's position.
''' @param lst The list to update.
''' @param node The index to insert the item at.
''' @param v The integer value to store.
SUB LList_InsertBeforeInteger (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS INTEGER)
    __LList_InsertBefore lst(), node, MKI$(v), QBDS_TYPE_INTEGER
END SUB

''' @brief Inserts an element after the specified node's position.
''' @param lst The list to update.
''' @param node The index to insert the item at.
''' @param v The integer value to store.
SUB LList_InsertAfterInteger (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS INTEGER)
    __LList_InsertAfter lst(), node, MKI$(v), QBDS_TYPE_INTEGER
END SUB

''' @brief Adds an element to the beginning of the list.
''' @param lst The list to update.
''' @param v The integer value to store.
SUB LList_PushFrontInteger (lst() AS LList, v AS INTEGER)
    __LList_PushFront lst(), MKI$(v), QBDS_TYPE_INTEGER
END SUB

''' @brief Adds an element to the end of the list.
''' @param lst The list to update.
''' @param v The integer value to store.
SUB LList_PushBackInteger (lst() AS LList, v AS INTEGER)
    __LList_PushBack lst(), MKI$(v), QBDS_TYPE_INTEGER
END SUB

''' @brief Inserts an element before the specified node's position.
''' @param lst The list to update.
''' @param node The index to insert the item at.
''' @param v The long value to store.
SUB LList_InsertBeforeLong (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS LONG)
    __LList_InsertBefore lst(), node, MKL$(v), QBDS_TYPE_LONG
END SUB

''' @brief Inserts an element after the specified node's position.
''' @param lst The list to update.
''' @param node The index to insert the item at.
''' @param v The long value to store.
SUB LList_InsertAfterLong (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS LONG)
    __LList_InsertAfter lst(), node, MKL$(v), QBDS_TYPE_LONG
END SUB

''' @brief Adds an element to the beginning of the list.
''' @param lst The list to update.
''' @param v The long value to store.
SUB LList_PushFrontLong (lst() AS LList, v AS LONG)
    __LList_PushFront lst(), MKL$(v), QBDS_TYPE_LONG
END SUB

''' @brief Adds an element to the end of the list.
''' @param lst The list to update.
''' @param v The long value to store.
SUB LList_PushBackLong (lst() AS LList, v AS LONG)
    __LList_PushBack lst(), MKL$(v), QBDS_TYPE_LONG
END SUB

''' @brief Inserts an element before the specified node's position.
''' @param lst The list to update.
''' @param node The index to insert the item at.
''' @param v The integer64 value to store.
SUB LList_InsertBeforeInteger64 (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS _INTEGER64)
    __LList_InsertBefore lst(), node, _MK$(_INTEGER64, v), QBDS_TYPE_INTEGER64
END SUB

''' @brief Inserts an element after the specified node's position.
''' @param lst The list to update.
''' @param node The index to insert the item at.
''' @param v The integer64 value to store.
SUB LList_InsertAfterInteger64 (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS _INTEGER64)
    __LList_InsertAfter lst(), node, _MK$(_INTEGER64, v), QBDS_TYPE_INTEGER64
END SUB

''' @brief Adds an element to the beginning of the list.
''' @param lst The list to update.
''' @param v The integer64 value to store.
SUB LList_PushFrontInteger64 (lst() AS LList, v AS _INTEGER64)
    __LList_PushFront lst(), _MK$(_INTEGER64, v), QBDS_TYPE_INTEGER64
END SUB

''' @brief Adds an element to the end of the list.
''' @param lst The list to update.
''' @param v The integer64 value to store.
SUB LList_PushBackInteger64 (lst() AS LList, v AS _INTEGER64)
    __LList_PushBack lst(), _MK$(_INTEGER64, v), QBDS_TYPE_INTEGER64
END SUB

''' @brief Inserts an element before the specified node's position.
''' @param lst The list to update.
''' @param node The index to insert the item at.
''' @param v The single value to store.
SUB LList_InsertBeforeSingle (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS SINGLE)
    __LList_InsertBefore lst(), node, MKS$(v), QBDS_TYPE_SINGLE
END SUB

''' @brief Inserts an element after the specified node's position.
''' @param lst The list to update.
''' @param node The index to insert the item at.
''' @param v The single value to store.
SUB LList_InsertAfterSingle (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS SINGLE)
    __LList_InsertAfter lst(), node, MKS$(v), QBDS_TYPE_SINGLE
END SUB

''' @brief Adds an element to the beginning of the list.
''' @param lst The list to update.
''' @param v The single value to store.
SUB LList_PushFrontSingle (lst() AS LList, v AS SINGLE)
    __LList_PushFront lst(), MKS$(v), QBDS_TYPE_SINGLE
END SUB

''' @brief Adds an element to the end of the list.
''' @param lst The list to update.
''' @param v The single value to store.
SUB LList_PushBackSingle (lst() AS LList, v AS SINGLE)
    __LList_PushBack lst(), MKS$(v), QBDS_TYPE_SINGLE
END SUB

''' @brief Inserts an element before the specified node's position.
''' @param lst The list to update.
''' @param node The index to insert the item at.
''' @param v The double value to store.
SUB LList_InsertBeforeDouble (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS DOUBLE)
    __LList_InsertBefore lst(), node, MKD$(v), QBDS_TYPE_DOUBLE
END SUB

''' @brief Inserts an element after the specified node's position.
''' @param lst The list to update.
''' @param node The index to insert the item at.
''' @param v The double value to store.
SUB LList_InsertAfterDouble (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS DOUBLE)
    __LList_InsertAfter lst(), node, MKD$(v), QBDS_TYPE_DOUBLE
END SUB

''' @brief Adds an element to the beginning of the list.
''' @param lst The list to update.
''' @param v The double value to store.
SUB LList_PushFrontDouble (lst() AS LList, v AS DOUBLE)
    __LList_PushFront lst(), MKD$(v), QBDS_TYPE_DOUBLE
END SUB

''' @brief Adds an element to the end of the list.
''' @param lst The list to update.
''' @param v The double value to store.
SUB LList_PushBackDouble (lst() AS LList, v AS DOUBLE)
    __LList_PushBack lst(), MKD$(v), QBDS_TYPE_DOUBLE
END SUB

''' @brief Sets the value for a given node.
''' @param lst The list to update.
''' @param node The node to set the value for.
''' @param v The raw value string to set.
''' @param t The data type constant for the value being set.
SUB __LList_Set (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS STRING, t AS _UNSIGNED _OFFSET)
    IF node < 1 _ORELSE node > UBOUND(lst) _ORELSE lst(node).T <= QBDS_TYPE_DELETED THEN
        ' Throw an error if the node is not valid
        ERROR _ERR_SUBSCRIPT_OUT_OF_RANGE
        EXIT SUB
    END IF

    lst(node).V = v
    lst(node).T = t
END SUB

''' @brief Retrieves the value for a given node.
''' @param lst The list to search.
''' @param node The node to get the value for.
''' @return The associated raw value string, or an empty string if not found.
FUNCTION __LList_Get$ (lst() AS LList, node AS _UNSIGNED _OFFSET)
    IF node < 1 _ORELSE node > UBOUND(lst) _ORELSE lst(node).T <= QBDS_TYPE_DELETED THEN
        ' Throw an error if the node is not valid
        ERROR _ERR_SUBSCRIPT_OUT_OF_RANGE
        EXIT FUNCTION
    END IF

    __LList_Get = lst(node).V
END FUNCTION

''' @brief Retrieves the value for a given node.
''' @param lst The list to search.
''' @param node The node to get the value for.
''' @return The associated string value, or an empty string if not found.
FUNCTION LList_GetString$ (lst() AS LList, node AS _UNSIGNED _OFFSET)
    LList_GetString = __LList_Get(lst(), node)
END FUNCTION

''' @brief Sets the value for a given node.
''' @param lst The list to update.
''' @param node The node to set the value for.
''' @param v The string value to set.
SUB LList_SetString (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS STRING)
    __LList_Set lst(), node, v, QBDS_TYPE_STRING
END SUB

''' @brief Retrieves the value for a given node.
''' @param lst The list to search.
''' @param node The node to get the value for.
''' @return The associated byte value, or 0 if not found.
FUNCTION LList_GetByte%% (lst() AS LList, node AS _UNSIGNED _OFFSET)
    LList_GetByte = _CV(_BYTE, __LList_Get(lst(), node))
END FUNCTION

''' @brief Sets the value for a given node.
''' @param lst The list to update.
''' @param node The node to set the value for.
''' @param v The byte value to set.
SUB LList_SetByte (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS _BYTE)
    __LList_Set lst(), node, _MK$(_BYTE, v), QBDS_TYPE_BYTE
END SUB

''' @brief Retrieves the value for a given node.
''' @param lst The list to search.
''' @param node The node to get the value for.
''' @return The associated integer value, or 0 if not found.
FUNCTION LList_GetInteger% (lst() AS LList, node AS _UNSIGNED _OFFSET)
    LList_GetInteger = CVI(__LList_Get(lst(), node))
END FUNCTION

''' @brief Sets the value for a given node.
''' @param lst The list to update.
''' @param node The node to set the value for.
''' @param v The integer value to set.
SUB LList_SetInteger (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS INTEGER)
    __LList_Set lst(), node, MKI$(v), QBDS_TYPE_INTEGER
END SUB

''' @brief Retrieves the value for a given node.
''' @param lst The list to search.
''' @param node The node to get the value for.
''' @return The associated long value, or 0 if not found.
FUNCTION LList_GetLong& (lst() AS LList, node AS _UNSIGNED _OFFSET)
    LList_GetLong = CVL(__LList_Get(lst(), node))
END FUNCTION

''' @brief Sets the value for a given node.
''' @param lst The list to update.
''' @param node The node to set the value for.
''' @param v The long value to set.
SUB LList_SetLong (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS LONG)
    __LList_Set lst(), node, MKL$(v), QBDS_TYPE_LONG
END SUB

''' @brief Retrieves the value for a given node.
''' @param lst The list to search.
''' @param node The node to get the value for.
''' @return The associated integer64 value, or 0 if not found.
FUNCTION LList_GetInteger64&& (lst() AS LList, node AS _UNSIGNED _OFFSET)
    LList_GetInteger64 = _CV(_INTEGER64, __LList_Get(lst(), node))
END FUNCTION

''' @brief Sets the value for a given node.
''' @param lst The list to update.
''' @param node The node to set the value for.
''' @param v The integer64 value to set.
SUB LList_SetInteger64 (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS _INTEGER64)
    __LList_Set lst(), node, _MK$(_INTEGER64, v), QBDS_TYPE_INTEGER64
END SUB

''' @brief Retrieves the value for a given node.
''' @param lst The list to search.
''' @param node The node to get the value for.
''' @return The associated single value, or 0 if not found.
FUNCTION LList_GetSingle! (lst() AS LList, node AS _UNSIGNED _OFFSET)
    LList_GetSingle = CVS(__LList_Get(lst(), node))
END FUNCTION

''' @brief Sets the value for a given node.
''' @param lst The list to update.
''' @param node The node to set the value for.
''' @param v The single value to set.
SUB LList_SetSingle (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS SINGLE)
    __LList_Set lst(), node, MKS$(v), QBDS_TYPE_SINGLE
END SUB

''' @brief Retrieves the value for a given node.
''' @param lst The list to search.
''' @param node The node to get the value for.
''' @return The associated double value, or 0 if not found.
FUNCTION LList_GetDouble# (lst() AS LList, node AS _UNSIGNED _OFFSET)
    LList_GetDouble = CVD(__LList_Get(lst(), node))
END FUNCTION

''' @brief Sets the value for a given node.
''' @param lst The list to update.
''' @param node The node to set the value for.
''' @param v The double value to set.
SUB LList_SetDouble (lst() AS LList, node AS _UNSIGNED _OFFSET, v AS DOUBLE)
    __LList_Set lst(), node, MKD$(v), QBDS_TYPE_DOUBLE
END SUB

''' @brief Retrieves the value from the front of the list and removes it.
''' @param lst The list to search.
''' @return The associated string value, or an empty string if not found.
FUNCTION LList_PopFrontString$ (lst() AS LList)
    DIM node AS _UNSIGNED _OFFSET: node = LList_GetFrontNode(lst())
    LList_PopFrontString = LList_GetString(lst(), node)
    LList_RemoveNode lst(), node
END FUNCTION

''' @brief Retrieves the value from the back of the list and removes it.
''' @param lst The list to search.
''' @return The associated string value, or an empty string if not found.
FUNCTION LList_PopBackString$ (lst() AS LList)
    DIM node AS _UNSIGNED _OFFSET: node = LList_GetBackNode(lst())
    LList_PopBackString = LList_GetString(lst(), node)
    LList_RemoveNode lst(), node
END FUNCTION

''' @brief Retrieves the value from the front of the list and removes it.
''' @param lst The list to search.
''' @return The associated byte value, or 0 if not found.
FUNCTION LList_PopFrontByte%% (lst() AS LList)
    DIM node AS _UNSIGNED _OFFSET: node = LList_GetFrontNode(lst())
    LList_PopFrontByte = LList_GetByte(lst(), node)
    LList_RemoveNode lst(), node
END FUNCTION

''' @brief Retrieves the value from the back of the list and removes it.
''' @param lst The list to search.
''' @return The associated byte value, or 0 if not found.
FUNCTION LList_PopBackByte%% (lst() AS LList)
    DIM node AS _UNSIGNED _OFFSET: node = LList_GetBackNode(lst())
    LList_PopBackByte = LList_GetByte(lst(), node)
    LList_RemoveNode lst(), node
END FUNCTION

''' @brief Retrieves the value from the front of the list and removes it.
''' @param lst The list to search.
''' @return The associated integer value, or 0 if not found.
FUNCTION LList_PopFrontInteger% (lst() AS LList)
    DIM node AS _UNSIGNED _OFFSET: node = LList_GetFrontNode(lst())
    LList_PopFrontInteger = LList_GetInteger(lst(), node)
    LList_RemoveNode lst(), node
END FUNCTION

''' @brief Retrieves the value from the back of the list and removes it.
''' @param lst The list to search.
''' @return The associated integer value, or 0 if not found.
FUNCTION LList_PopBackInteger% (lst() AS LList)
    DIM node AS _UNSIGNED _OFFSET: node = LList_GetBackNode(lst())
    LList_PopBackInteger = LList_GetInteger(lst(), node)
    LList_RemoveNode lst(), node
END FUNCTION

''' @brief Retrieves the value from the front of the list and removes it.
''' @param lst The list to search.
''' @return The associated long value, or 0 if not found.
FUNCTION LList_PopFrontLong& (lst() AS LList)
    DIM node AS _UNSIGNED _OFFSET: node = LList_GetFrontNode(lst())
    LList_PopFrontLong = LList_GetLong(lst(), node)
    LList_RemoveNode lst(), node
END FUNCTION

''' @brief Retrieves the value from the back of the list and removes it.
''' @param lst The list to search.
''' @return The associated long value, or 0 if not found.
FUNCTION LList_PopBackLong& (lst() AS LList)
    DIM node AS _UNSIGNED _OFFSET: node = LList_GetBackNode(lst())
    LList_PopBackLong = LList_GetLong(lst(), node)
    LList_RemoveNode lst(), node
END FUNCTION

''' @brief Retrieves the value from the front of the list and removes it.
''' @param lst The list to search.
''' @return The associated integer64 value, or 0 if not found.
FUNCTION LList_PopFrontInteger64&& (lst() AS LList)
    DIM node AS _UNSIGNED _OFFSET: node = LList_GetFrontNode(lst())
    LList_PopFrontInteger64 = LList_GetInteger64(lst(), node)
    LList_RemoveNode lst(), node
END FUNCTION

''' @brief Retrieves the value from the back of the list and removes it.
''' @param lst The list to search.
''' @return The associated integer64 value, or 0 if not found.
FUNCTION LList_PopBackInteger64&& (lst() AS LList)
    DIM node AS _UNSIGNED _OFFSET: node = LList_GetBackNode(lst())
    LList_PopBackInteger64 = LList_GetInteger64(lst(), node)
    LList_RemoveNode lst(), node
END FUNCTION

''' @brief Retrieves the value from the front of the list and removes it.
''' @param lst The list to search.
''' @return The associated single value, or 0 if not found.
FUNCTION LList_PopFrontSingle! (lst() AS LList)
    DIM node AS _UNSIGNED _OFFSET: node = LList_GetFrontNode(lst())
    LList_PopFrontSingle = LList_GetSingle(lst(), node)
    LList_RemoveNode lst(), node
END FUNCTION

''' @brief Retrieves the value from the back of the list and removes it.
''' @param lst The list to search.
''' @return The associated single value, or 0 if not found.
FUNCTION LList_PopBackSingle! (lst() AS LList)
    DIM node AS _UNSIGNED _OFFSET: node = LList_GetBackNode(lst())
    LList_PopBackSingle = LList_GetSingle(lst(), node)
    LList_RemoveNode lst(), node
END FUNCTION

''' @brief Retrieves the value from the front of the list and removes it.
''' @param lst The list to search.
''' @return The associated double value, or 0 if not found.
FUNCTION LList_PopFrontDouble# (lst() AS LList)
    DIM node AS _UNSIGNED _OFFSET: node = LList_GetFrontNode(lst())
    LList_PopFrontDouble = LList_GetDouble(lst(), node)
    LList_RemoveNode lst(), node
END FUNCTION

''' @brief Retrieves the value from the back of the list and removes it.
''' @param lst The list to search.
''' @return The associated double value, or 0 if not found.
FUNCTION LList_PopBackDouble# (lst() AS LList)
    DIM node AS _UNSIGNED _OFFSET: node = LList_GetBackNode(lst())
    LList_PopBackDouble = LList_GetDouble(lst(), node)
    LList_RemoveNode lst(), node
END FUNCTION
