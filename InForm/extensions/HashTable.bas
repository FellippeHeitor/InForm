'-----------------------------------------------------------------------------------------------------------------------
' A simple hash table for integers and QB64 handles
' Copyright (c) 2023 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$IF HASHTABLE_BAS = UNDEFINED THEN
    $LET HASHTABLE_BAS = TRUE

    '$INCLUDE:'HashTable.bi'

    '-------------------------------------------------------------------------------------------------------------------
    ' Test code for debugging the library
    '-------------------------------------------------------------------------------------------------------------------
    'REDIM MyHashTable(0 TO 0) AS HashTableType

    'CONST TEST_LB = 1
    'CONST TEST_UB = 9999999

    'RANDOMIZE TIMER

    'DIM myarray(TEST_LB TO TEST_UB) AS LONG, t AS DOUBLE
    'DIM AS _UNSIGNED LONG k, i, x

    'FOR k = 1 TO 4
    '    PRINT "Add element to array..."
    '    t = TIMER
    '    FOR i = TEST_UB TO TEST_LB STEP -1
    '        myarray(i) = x
    '        x = x + 1
    '    NEXT
    '    PRINT USING "#####.##### seconds"; TIMER - t

    '    PRINT "Add element to hash table..."
    '    t = TIMER
    '    FOR i = TEST_UB TO TEST_LB STEP -1
    '        HashTable_InsertLong MyHashTable(), i, myarray(i)
    '    NEXT
    '    PRINT USING "#####.##### seconds"; TIMER - t

    '    PRINT "Read element from array..."
    '    t = TIMER
    '    FOR i = TEST_UB TO TEST_LB STEP -1
    '        x = myarray(i)
    '    NEXT
    '    PRINT USING "#####.##### seconds"; TIMER - t

    '    PRINT "Read element from hash table..."
    '    t = TIMER
    '    FOR i = TEST_UB TO TEST_LB STEP -1
    '        x = HashTable_LookupLong(MyHashTable(), i)
    '    NEXT
    '    PRINT USING "#####.##### seconds"; TIMER - t

    '    PRINT "Remove element from hash table..."
    '    t = TIMER
    '    FOR i = TEST_UB TO TEST_LB STEP -1
    '        HashTable_Remove MyHashTable(), i
    '    NEXT
    '    PRINT USING "#####.##### seconds"; TIMER - t
    'NEXT

    'FOR i = TEST_UB TO TEST_LB STEP -1
    '    LOCATE , 1: PRINT "Adding key"; i; "Size:"; UBOUND(MyHashTable) + 1;
    '    HashTable_InsertLong MyHashTable(), i, myarray(i)
    'NEXT
    'PRINT

    'FOR i = TEST_UB TO TEST_LB STEP -1
    '    LOCATE , 1: PRINT "Verifying key: "; i;
    '    IF HashTable_LookupLong(MyHashTable(), i) <> myarray(i) THEN
    '        PRINT "[fail] ";
    '        SLEEP 1
    '    ELSE
    '        PRINT "[pass] ";
    '    END IF
    'NEXT
    'PRINT

    'FOR i = TEST_UB TO TEST_LB STEP -1
    '    LOCATE , 1: PRINT "Removing key"; i; "Size:"; UBOUND(MyHashTable) + 1;
    '    HashTable_Remove MyHashTable(), i
    'NEXT
    'PRINT

    'HashTable_InsertLong MyHashTable(), 42, 666
    'HashTable_InsertLong MyHashTable(), 7, 123454321
    'HashTable_InsertLong MyHashTable(), 21, 69

    'PRINT "Value for key 42:"; HashTable_LookupLong(MyHashTable(), 42)
    'PRINT "Value for key 7:"; HashTable_LookupLong(MyHashTable(), 7)
    'PRINT "Value for key 21:"; HashTable_LookupLong(MyHashTable(), 21)

    'PRINT HashTable_IsKeyPresent(MyHashTable(), 100)

    'END
    '-------------------------------------------------------------------------------------------------------------------

    ' Simple hash function: k is the 32-bit key and l is the upper bound of the array
    FUNCTION __HashTable_GetHash~& (k AS _UNSIGNED LONG, l AS _UNSIGNED LONG)
        $CHECKING:OFF
        ' Actually this should be k MOD (l + 1)
        ' However, we can get away using AND because our arrays size always doubles in multiples of 2
        ' So, if l = 255, then (k MOD (l + 1)) = (k AND l)
        ' Another nice thing here is that we do not need to do the addition :)
        __HashTable_GetHash = k AND l
        $CHECKING:ON
    END FUNCTION


    ' Subroutine to resize and rehash the elements in a hash table
    SUB __HashTable_ResizeAndRehash (hashTable() AS HashTableType)
        DIM uB AS _UNSIGNED LONG: uB = UBOUND(hashTable)

        ' Resize the array to double its size while preserving contents
        DIM newUB AS _UNSIGNED LONG: newUB = _SHL(uB + 1, 1) - 1
        REDIM _PRESERVE hashTable(0 TO newUB) AS HashTableType

        ' Rehash and swap all the elements
        DIM i AS _UNSIGNED LONG: FOR i = 0 TO uB
            IF hashTable(i).U THEN SWAP hashTable(i), hashTable(__HashTable_GetHash(hashTable(i).K, newUB))
        NEXT i
    END SUB


    ' This returns an array index in hashTable where k can be inserted
    ' If there is a collision it will grow the array, re-hash and copy all elements
    FUNCTION __HashTable_GetInsertIndex& (hashTable() AS HashTableType, k AS _UNSIGNED LONG)
        DIM uB AS _UNSIGNED LONG: uB = UBOUND(hashTable)
        DIM idx AS _UNSIGNED LONG: idx = __HashTable_GetHash(k, uB)

        IF hashTable(idx).U THEN
            ' Used slot
            IF hashTable(idx).K = k THEN
                ' Duplicate key
                __HashTable_GetInsertIndex = __HASHTABLE_KEY_EXISTS
            ELSE
                ' Collision
                __HashTable_ResizeAndRehash hashTable()
                __HashTable_GetInsertIndex = __HashTable_GetInsertIndex(hashTable(), k)
            END IF
        ELSE
            ' Empty slot
            __HashTable_GetInsertIndex = idx
        END IF
    END FUNCTION


    ' This function returns the index from hashTable for the key k if k is in use
    FUNCTION __HashTable_GetLookupIndex& (hashTable() AS HashTableType, k AS _UNSIGNED LONG)
        DIM uB AS _UNSIGNED LONG: uB = UBOUND(hashTable)
        DIM idx AS _UNSIGNED LONG: idx = __HashTable_GetHash(k, uB)

        IF hashTable(idx).U THEN
            ' Used slot
            IF hashTable(idx).K = k THEN
                ' Key found
                __HashTable_GetLookupIndex = idx
            ELSE
                ' Unknown key
                __HashTable_GetLookupIndex = __HASHTABLE_KEY_UNAVAILABLE
            END IF
        ELSE
            ' Unknown key
            __HashTable_GetLookupIndex = __HASHTABLE_KEY_UNAVAILABLE
        END IF
    END FUNCTION


    ' Return TRUE if k is available in the hash table
    FUNCTION HashTable_IsKeyPresent%% (hashTable() AS HashTableType, k AS _UNSIGNED LONG)
        HashTable_IsKeyPresent = (__HashTable_GetLookupIndex(hashTable(), k) >= 0)
    END FUNCTION


    ' Remove an element from the hash table
    SUB HashTable_Remove (hashTable() AS HashTableType, k AS _UNSIGNED LONG)
        DIM idx AS LONG: idx = __HashTable_GetLookupIndex(hashTable(), k)

        IF idx >= 0 THEN
            hashTable(idx).U = FALSE
        ELSE
            ERROR 9
        END IF
    END SUB


    ' Inserts a long value in the table using a key
    SUB HashTable_InsertLong (hashTable() AS HashTableType, k AS _UNSIGNED LONG, v AS LONG)
        DIM idx AS LONG: idx = __HashTable_GetInsertIndex(hashTable(), k)

        IF idx >= 0 THEN
            hashTable(idx).U = TRUE
            hashTable(idx).K = k
            hashTable(idx).V = v
        ELSE
            ERROR 9
        END IF
    END SUB


    ' Returns the long value from the table using a key
    FUNCTION HashTable_LookupLong& (hashTable() AS HashTableType, k AS _UNSIGNED LONG)
        DIM idx AS LONG: idx = __HashTable_GetLookupIndex(hashTable(), k)

        IF idx >= 0 THEN
            HashTable_LookupLong = hashTable(idx).V
        ELSE
            ERROR 9
        END IF
    END FUNCTION

$END IF
