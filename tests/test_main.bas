' InForm-PE test suite

$LET TEST_STRICT = TRUE
$LET TEST_CONSOLE_ONLY = TRUE

'$INCLUDE:'../InForm/extensions/Catch.bi'

'$INCLUDE:'../InForm/extensions/Array.bi'
'$INCLUDE:'../InForm/extensions/HMap.bi'
'$INCLUDE:'../InForm/extensions/HMap64.bi'
'$INCLUDE:'../InForm/extensions/HSet.bi'
'$INCLUDE:'../InForm/extensions/Ini.bi'
'$INCLUDE:'../InForm/extensions/LList.bi'
'$INCLUDE:'../InForm/extensions/Pathname.bi'
'$INCLUDE:'../InForm/extensions/Queue.bi'
'$INCLUDE:'../InForm/extensions/Stack.bi'
'$INCLUDE:'../InForm/extensions/String.bi'
'$INCLUDE:'../InForm/extensions/StringFile.bi'

'$INCLUDE:'../InForm/extensions/CatchError.bi'

'$INCLUDE:'../InForm/InForm.bi'

SUB __UI_BeforeInit
    TEST_BEGIN_ALL

    Test_Catch
    Test_Algo
    Test_Array
    Test_HMap
    Test_HMap64
    Test_HSet
    Test_LList
    Test_Pathname
    Test_Queue
    Test_Stack
    Test_String
    Test_StringFile
    Test_INI_Manager
    Test_InFormUIUtils
    Test_InFormUIHelpers
    Test_InFormUIUnicodeUtils
    Test_Theme
    Test_TabControl

    TEST_END_ALL
END SUB

SUB Test_Catch
    TEST_CASE_BEGIN "Catch"

    TEST_REQUIRE 2 * 3 = 6, "2 * 3 = 6"
    TEST_CHECK 1 + 1 = 2, "1 + 1 = 2"
    TEST_REQUIRE_FALSE 1 = 2, "1 = 2"
    TEST_CHECK_FALSE 3 = 4, "3 = 4"
    TEST_REQUIRE2 2 * 3 = 6
    TEST_CHECK2 10 / 2 = 5
    TEST_REQUIRE_FALSE2 1 = 2
    TEST_CHECK_FALSE2 3 = 4

    TEST_CASE_END
END SUB

SUB Test_Algo
    TEST_CASE_BEGIN "Algo: Basic Sort"
    DIM strArr(0 TO 4) AS STRING
    strArr(0) = "banana"
    strArr(1) = "apple"
    strArr(2) = "orange"
    strArr(3) = "pear"
    strArr(4) = "kiwi"
    TEST_REQUIRE Algo_SortStringArray(strArr()), "Algo_SortStringArray should return TRUE for an unsorted array"
    TEST_CHECK strArr(0) = "apple", "Sorted array element 0 should be 'apple'"
    TEST_CHECK strArr(1) = "banana", "Sorted array element 1 should be 'banana'"
    TEST_CHECK strArr(2) = "kiwi", "Sorted array element 2 should be 'kiwi'"
    TEST_CHECK strArr(3) = "orange", "Sorted array element 3 should be 'orange'"
    TEST_CHECK strArr(4) = "pear", "Sorted array element 4 should be 'pear'"
    TEST_CASE_END

    TEST_CASE_BEGIN "Algo: Already Sorted"
    DIM sortedArr(0 TO 2) AS STRING
    sortedArr(0) = "a"
    sortedArr(1) = "b"
    sortedArr(2) = "c"
    TEST_REQUIRE_FALSE Algo_SortStringArray(sortedArr()), "Algo_SortStringArray should return FALSE for a sorted array"
    TEST_CHECK sortedArr(0) = "a", "Array should remain unchanged"
    TEST_CHECK sortedArr(1) = "b", "Array should remain unchanged"
    TEST_CHECK sortedArr(2) = "c", "Array should remain unchanged"
    TEST_CASE_END

    TEST_CASE_BEGIN "Algo: Reverse Sorted"
    DIM reverseArr(0 TO 3) AS STRING
    reverseArr(0) = "zulu"
    reverseArr(1) = "yankee"
    reverseArr(2) = "x-ray"
    reverseArr(3) = "whiskey"
    TEST_REQUIRE Algo_SortStringArray(reverseArr()), "Algo_SortStringArray should return TRUE for a reverse-sorted array"
    TEST_CHECK reverseArr(0) = "whiskey", "Sorted array element 0 should be 'whiskey'"
    TEST_CHECK reverseArr(1) = "x-ray", "Sorted array element 1 should be 'x-ray'"
    TEST_CHECK reverseArr(2) = "yankee", "Sorted array element 2 should be 'yankee'"
    TEST_CHECK reverseArr(3) = "zulu", "Sorted array element 3 should be 'zulu'"
    TEST_CASE_END

    TEST_CASE_BEGIN "Algo: With Duplicates"
    DIM dupArr(0 TO 5) AS STRING
    dupArr(0) = "b"
    dupArr(1) = "a"
    dupArr(2) = "c"
    dupArr(3) = "b"
    dupArr(4) = "a"
    dupArr(5) = "c"
    TEST_REQUIRE Algo_SortStringArray(dupArr()), "Algo_SortStringArray should return TRUE for an array with duplicates"
    TEST_CHECK dupArr(0) = "a", "Sorted array with duplicates element 0"
    TEST_CHECK dupArr(1) = "a", "Sorted array with duplicates element 1"
    TEST_CHECK dupArr(2) = "b", "Sorted array with duplicates element 2"
    TEST_CHECK dupArr(3) = "b", "Sorted array with duplicates element 3"
    TEST_CHECK dupArr(4) = "c", "Sorted array with duplicates element 4"
    TEST_CHECK dupArr(5) = "c", "Sorted array with duplicates element 5"
    TEST_CASE_END

    TEST_CASE_BEGIN "Algo: With Empty Strings"
    DIM emptyArr(0 TO 3) AS STRING
    emptyArr(0) = "beta"
    emptyArr(1) = ""
    emptyArr(2) = "alpha"
    emptyArr(3) = ""
    TEST_REQUIRE Algo_SortStringArray(emptyArr()), "Algo_SortStringArray should return TRUE for an array with empty strings"
    TEST_CHECK emptyArr(0) = "", "Sorted array with empty strings element 0"
    TEST_CHECK emptyArr(1) = "", "Sorted array with empty strings element 1"
    TEST_CHECK emptyArr(2) = "alpha", "Sorted array with empty strings element 2"
    TEST_CHECK emptyArr(3) = "beta", "Sorted array with empty strings element 3"
    TEST_CASE_END

    TEST_CASE_BEGIN "Algo: Single Element"
    DIM singleArr(0 TO 0) AS STRING
    singleArr(0) = "lonely"
    TEST_REQUIRE_FALSE Algo_SortStringArray(singleArr()), "Algo_SortStringArray should return FALSE for a single-element array"
    TEST_CHECK singleArr(0) = "lonely", "Single element array should remain unchanged"
    TEST_CASE_END

    TEST_CASE_BEGIN "Algo: Empty Array"
    DIM zeroArr(0) AS STRING
    TEST_REQUIRE_FALSE Algo_SortStringArray(zeroArr()), "Algo_SortStringArray should return FALSE for an empty array"
    TEST_CASE_END

    TEST_CASE_BEGIN "Algo: Sort Range"
    DIM rangeArr(0 TO 5) AS STRING
    rangeArr(0) = "z"
    rangeArr(1) = "e"
    rangeArr(2) = "d"
    rangeArr(3) = "c"
    rangeArr(4) = "b"
    rangeArr(5) = "a"
    TEST_REQUIRE Algo_SortStringArrayRange(rangeArr(), 1, 4, _TRUE, _TRUE), "Algo_SortStringArrayRange should return TRUE for an unsorted range"
    TEST_CHECK rangeArr(0) = "z", "Element before range should be untouched"
    TEST_CHECK rangeArr(1) = "b", "Range should be sorted"
    TEST_CHECK rangeArr(2) = "c", "Range should be sorted"
    TEST_CHECK rangeArr(3) = "d", "Range should be sorted"
    TEST_CHECK rangeArr(4) = "e", "Range should be sorted"
    TEST_CHECK rangeArr(5) = "a", "Element after range should be untouched"
    TEST_CASE_END

    TEST_CASE_BEGIN "Algo: Sort Range (already sorted)"
    DIM sortedRangeArr(0 TO 3) AS STRING
    sortedRangeArr(0) = "a"
    sortedRangeArr(1) = "b"
    sortedRangeArr(2) = "c"
    sortedRangeArr(3) = "d"
    TEST_REQUIRE_FALSE Algo_SortStringArrayRange(sortedRangeArr(), 1, 2, _TRUE, _TRUE), "Algo_SortStringArrayRange should return FALSE for a sorted range"
    TEST_CHECK sortedRangeArr(0) = "a", "Array should remain unchanged"
    TEST_CHECK sortedRangeArr(1) = "b", "Array should remain unchanged"
    TEST_CHECK sortedRangeArr(2) = "c", "Array should remain unchanged"
    TEST_CHECK sortedRangeArr(3) = "d", "Array should remain unchanged"
    TEST_CASE_END

    CONST ALGO_PERF_COUNT = 1000000
    DIM numArr(0 TO ALGO_PERF_COUNT - 1) AS STRING
    DIM i AS LONG

    FOR i = 0 TO ALGO_PERF_COUNT - 1
        numArr(i) = RIGHT$("0000000" + _TOSTR$(ALGO_PERF_COUNT - i), 7)
    NEXT i

    TEST_CASE_BEGIN "Algo: Performance Sort (" + _TOSTR$(ALGO_PERF_COUNT) + " numbers)"
    TEST_CHECK Algo_SortStringArray(numArr()), "Algo_SortStringArray should return TRUE for a reverse-sorted array"
    TEST_CASE_END

    TEST_CASE_BEGIN "Algo: Performance Sort Verification (" + _TOSTR$(ALGO_PERF_COUNT) + " numbers)"
    FOR i = 0 TO ALGO_PERF_COUNT - 1
        TEST_CHECK VAL(numArr(i)) = i + 1, "Sorted array element " + _TOSTR$(i) + " should be '" + _TOSTR$(i + 1) + "'"
    NEXT i
    TEST_CASE_END
END SUB

SUB Test_Array
    TEST_CASE_BEGIN "Array: Initialization"

    REDIM arr(0) AS Array

    Array_Initialize arr()
    TEST_CHECK Array_IsInitialized(arr()), "Array should be initialized"
    TEST_CHECK Array_GetCount(arr()) = 0, "Initial count should be 0"
    TEST_CHECK Array_GetCapacity(arr()) > 0, "Initial capacity should be greater than 0"

    TEST_CASE_END

    '-----------------------------------------------------------------------------------------------------------------------

    TEST_CASE_BEGIN "Array: Basic String Operations"

    Array_PushBackString arr(), "Hello"
    TEST_CHECK Array_GetCount(arr()) = 1, "Count should be 1"
    TEST_CHECK Array_GetString(arr(), 1) = "Hello", "String value should be 'Hello'"
    TEST_CHECK Array_GetElementDataType(arr(), 1) = QBDS_TYPE_STRING, "Data type should be STRING"

    Array_PushBackString arr(), "World"
    TEST_CHECK Array_GetCount(arr()) = 2, "Count should be 2"
    TEST_CHECK Array_GetString(arr(), 2) = "World", "String value should be 'World'"

    Array_SetString arr(), 1, "Hi"
    TEST_CHECK Array_GetString(arr(), 1) = "Hi", "Set string should be 'Hi'"
    TEST_CHECK Array_GetCount(arr()) = 2, "Count should still be 2 after set"

    TEST_CHECK Array_PopBackString(arr()) = "World", "Popped value should be 'World'"
    TEST_CHECK Array_GetCount(arr()) = 1, "Count should be 1 after pop"

    TEST_CHECK Array_PopBackString(arr()) = "Hi", "Popped value should be 'Hi'"
    TEST_CHECK Array_GetCount(arr()) = 0, "Count should be 0 after pop"

    TEST_CASE_END

    '-----------------------------------------------------------------------------------------------------------------------

    TEST_CASE_BEGIN "Array: All Data Types"

    Array_Clear arr()

    Array_PushBackByte arr(), 127
    TEST_CHECK Array_GetByte(arr(), 1) = 127, "Byte value should be 127"
    TEST_CHECK Array_GetElementDataType(arr(), 1) = QBDS_TYPE_BYTE, "Data type should be BYTE"
    TEST_CHECK Array_PopBackByte(arr()) = 127, "Popped byte value should be 127"

    Array_PushBackInteger arr(), 32767
    TEST_CHECK Array_GetInteger(arr(), 1) = 32767, "Integer value should be 32767"
    TEST_CHECK Array_GetElementDataType(arr(), 1) = QBDS_TYPE_INTEGER, "Data type should be INTEGER"
    TEST_CHECK Array_PopBackInteger(arr()) = 32767, "Popped integer value should be 32767"

    Array_PushBackLong arr(), 2147483647
    TEST_CHECK Array_GetLong(arr(), 1) = 2147483647, "Long value should be 2147483647"
    TEST_CHECK Array_GetElementDataType(arr(), 1) = QBDS_TYPE_LONG, "Data type should be LONG"
    TEST_CHECK Array_PopBackLong(arr()) = 2147483647, "Popped long value should be 2147483647"

    Array_PushBackInteger64 arr(), 9223372036854775807~&&
    TEST_CHECK Array_GetInteger64(arr(), 1) = 9223372036854775807~&&, "Integer64 value should be max"
    TEST_CHECK Array_GetElementDataType(arr(), 1) = QBDS_TYPE_INTEGER64, "Data type should be INTEGER64"
    TEST_CHECK Array_PopBackInteger64(arr()) = 9223372036854775807~&&, "Popped integer64 value should be max"

    Array_PushBackSingle arr(), 1.2345!
    TEST_CHECK ABS(Array_GetSingle(arr(), 1) - 1.2345!) < 0.0001, "Single value should be approx 1.2345"
    TEST_CHECK Array_GetElementDataType(arr(), 1) = QBDS_TYPE_SINGLE, "Data type should be SINGLE"
    TEST_CHECK ABS(Array_PopBackSingle(arr()) - 1.2345!) < 0.0001, "Popped single value should be approx 1.2345"

    Array_PushBackDouble arr(), 1.23456789#
    TEST_CHECK ABS(Array_GetDouble(arr(), 1) - 1.23456789#) < 0.00000001, "Double value should be approx 1.23456789"
    TEST_CHECK Array_GetElementDataType(arr(), 1) = QBDS_TYPE_DOUBLE, "Data type should be DOUBLE"
    TEST_CHECK ABS(Array_PopBackDouble(arr()) - 1.23456789#) < 0.00000001, "Popped double value should be approx 1.23456789"

    TEST_CHECK Array_GetCount(arr()) = 0, "Count should be 0 after all pops"

    TEST_CASE_END

    '-----------------------------------------------------------------------------------------------------------------------

    TEST_CASE_BEGIN "Array: Capacity and Growth"

    Array_Clear arr()
    DIM initialCapacity AS LONG: initialCapacity = Array_GetCapacity(arr())

    DIM i AS LONG
    FOR i = 1 TO initialCapacity + 1
        Array_PushBackInteger arr(), i
    NEXT

    TEST_CHECK Array_GetCount(arr()) = initialCapacity + 1, "Count should be initialCapacity + 1"
    TEST_CHECK Array_GetCapacity(arr()) > initialCapacity, "Capacity should have grown"

    Array_Clear arr()
    TEST_CHECK Array_GetCount(arr()) = 0, "Count should be 0 after clear"
    TEST_CHECK Array_GetCapacity(arr()) > initialCapacity, "Capacity should remain the same after clear"

    TEST_CASE_END

    '-----------------------------------------------------------------------------------------------------------------------

    TEST_CASE_BEGIN "Array: Edge Cases"

    Array_Clear arr()
    TEST_CHECK Array_GetCount(arr()) = 0, "Count should be 0 after clearing an empty array"
    Array_PushBackString arr(), ""
    TEST_CHECK Array_GetCount(arr()) = 1, "Count should be 1 after pushing an empty string"
    TEST_CHECK Array_PopBackString(arr()) = "", "Popped value should be an empty string"

    Array_Free arr()
    TEST_CHECK_FALSE Array_IsInitialized(arr()), "Array should not be initialized after free"

    Array_Initialize arr()
    TEST_CHECK Array_IsInitialized(arr()), "Array should be initialized again"

    Array_Free arr()

    TEST_CASE_END

    '-----------------------------------------------------------------------------------------------------------------------

    CONST ARRAY_PERF_COUNT = 1000000

    Array_Initialize arr()

    TEST_CASE_BEGIN "Array: Performance Test - PushBack (" + _TOSTR$(ARRAY_PERF_COUNT) + " items)"
    FOR i = 1 TO ARRAY_PERF_COUNT
        Array_PushBackLong arr(), i
    NEXT
    TEST_CASE_END

    TEST_CASE_BEGIN "Array: Performance Test - GetCount after PushBack"
    TEST_CHECK Array_GetCount(arr()) = ARRAY_PERF_COUNT, "Count should be " + _TOSTR$(ARRAY_PERF_COUNT)
    TEST_CASE_END

    DIM v AS LONG

    TEST_CASE_BEGIN "Array: Performance Test - Get (" + _TOSTR$(ARRAY_PERF_COUNT) + " items)"
    FOR i = 1 TO ARRAY_PERF_COUNT
        v = Array_GetLong(arr(), i)
    NEXT
    TEST_CASE_END

    TEST_CASE_BEGIN "Array: Performance Test - Last value after Get"
    TEST_CHECK v = ARRAY_PERF_COUNT, "Last value should be " + _TOSTR$(ARRAY_PERF_COUNT)
    TEST_CASE_END

    TEST_CASE_BEGIN "Array: Performance Test - Set (" + _TOSTR$(ARRAY_PERF_COUNT) + " items)"
    FOR i = 1 TO ARRAY_PERF_COUNT
        Array_SetLong arr(), i, i + 1
    NEXT
    TEST_CASE_END

    TEST_CASE_BEGIN "Array: Performance Test - Last value after Set"
    TEST_CHECK Array_GetLong(arr(), ARRAY_PERF_COUNT) = ARRAY_PERF_COUNT + 1, "Last value should be " + _TOSTR$(ARRAY_PERF_COUNT + 1)
    TEST_CASE_END

    TEST_CASE_BEGIN "Array: Performance Test - PopBack (" + _TOSTR$(ARRAY_PERF_COUNT) + " items)"
    FOR i = 1 TO ARRAY_PERF_COUNT
        v = Array_PopBackLong(arr())
    NEXT
    TEST_CASE_END

    TEST_CASE_BEGIN "Array: Performance Test - GetCount after PopBack"
    TEST_CHECK Array_GetCount(arr()) = 0, "Count should be 0 after popping all items"
    TEST_CASE_END

    Array_Free arr()
END SUB

SUB Test_HMap
    TEST_CASE_BEGIN "HMap: Initialization"

    REDIM ht(0) AS HMap

    HMap_Initialize ht()
    TEST_CHECK HMap_GetCount(ht()) = 0, "Initial count should be 0"
    TEST_CHECK_FALSE HMap_Contains(ht(), "nonexistent"), "Nonexistent key should not exist"
    TEST_CHECK HMap_GetString(ht(), "nonexistent") = "", "Getting nonexistent key should return empty string"

    TEST_CASE_END

    '-----------------------------------------------------------------------------------------------------------------------

    TEST_CASE_BEGIN "HMap: Basic Integer Operations"

    HMap_SetInteger ht(), "test", 42
    TEST_CHECK HMap_GetInteger(ht(), "test") = 42, "Integer value should be 42"
    TEST_CHECK HMap_GetEntryDataType(ht(), "test") = QBDS_TYPE_INTEGER, "Data type should be INT"
    TEST_CHECK HMap_GetCount(ht()) = 1, "Count should be 1"
    TEST_CHECK HMap_Contains(ht(), "test"), "Key should exist"

    HMap_SetInteger ht(), "test", 100
    TEST_CHECK HMap_GetInteger(ht(), "test") = 100, "Updated integer value should be 100"
    TEST_CHECK HMap_GetCount(ht()) = 1, "Count should still be 1 after update"

    TEST_CHECK HMap_Remove(ht(), "test"), "Remove should succeed"
    TEST_CHECK_FALSE HMap_Contains(ht(), "test"), "Key should not exist after remove"
    TEST_CHECK HMap_GetCount(ht()) = 0, "Count should be 0 after remove"

    TEST_CASE_END

    '-----------------------------------------------------------------------------------------------------------------------

    TEST_CASE_BEGIN "HMap: Long Operations"

    HMap_SetLong ht(), "long", _LONG_MAX
    TEST_CHECK HMap_GetLong(ht(), "long") = _LONG_MAX, "Long value should be" + STR$(_LONG_MAX)
    TEST_CHECK HMap_GetEntryDataType(ht(), "long") = QBDS_TYPE_LONG, "Data type should be LONG"

    TEST_CASE_END

    '-----------------------------------------------------------------------------------------------------------------------

    TEST_CASE_BEGIN "HMap: Integer64 Operations"

    HMap_SetInteger64 ht(), "int64", _INTEGER64_MAX
    TEST_CHECK HMap_GetInteger64(ht(), "int64") = _INTEGER64_MAX, "Integer64 value should be" + STR$(_INTEGER64_MAX)
    TEST_CHECK HMap_GetEntryDataType(ht(), "int64") = QBDS_TYPE_INTEGER64, "Data type should be INTEGER64"

    TEST_CASE_END

    '-----------------------------------------------------------------------------------------------------------------------

    TEST_CASE_BEGIN "HMap: Single Operations"

    HMap_SetSingle ht(), "pi", 3.14!
    TEST_CHECK ABS(HMap_GetSingle(ht(), "pi") - 3.14!) < 0.0001, "Single value should be approximately 3.14"
    TEST_CHECK HMap_GetEntryDataType(ht(), "pi") = QBDS_TYPE_SINGLE, "Data type should be SINGLE"

    TEST_CASE_END

    '-----------------------------------------------------------------------------------------------------------------------

    TEST_CASE_BEGIN "HMap: Double Operations"

    HMap_SetDouble ht(), "e", 2.71828182845905D+00
    TEST_CHECK ABS(HMap_GetDouble(ht(), "e") - 2.71828182845905D+00) < 0.000000001D+00, "Double value should be approximately e"
    TEST_CHECK HMap_GetEntryDataType(ht(), "e") = QBDS_TYPE_DOUBLE, "Data type should be DOUBLE"

    TEST_CASE_END

    '-----------------------------------------------------------------------------------------------------------------------

    TEST_CASE_BEGIN "HMap: String Operations"

    HMap_SetString ht(), "hello", "world"
    TEST_CHECK HMap_GetString(ht(), "hello") = "world", "String value should be 'world'"
    TEST_CHECK HMap_GetEntryDataType(ht(), "hello") = QBDS_TYPE_STRING, "Data type should be STRING"

    TEST_CASE_END

    '-----------------------------------------------------------------------------------------------------------------------

    TEST_CASE_BEGIN "HMap: Multiple Items"

    DIM i AS _UNSIGNED LONG
    DIM currentCount AS LONG: currentCount = HMap_GetCount(ht())
    FOR i = 1 TO 100
        HMap_SetInteger ht(), "key" + _TOSTR$(i), i
    NEXT
    TEST_CHECK HMap_GetCount(ht()) = currentCount + 100, "Count should be " + STR$(currentCount + 100)

    FOR i = 1 TO 100
        TEST_CHECK HMap_GetInteger(ht(), "key" + _TOSTR$(i)) = i, "Value should match key"
    NEXT

    DIM capacity AS _UNSIGNED LONG: capacity = HMap_GetCapacity(ht())

    HMap_Clear ht()
    TEST_CHECK HMap_GetCount(ht()) = 0, "Count should be 0 after clear"
    TEST_CHECK_FALSE HMap_Contains(ht(), "key1"), "No keys should exist after clear"
    TEST_CHECK HMap_GetCapacity(ht()) = capacity, "Capacity should remain the same after clear"

    TEST_CASE_END

    '-----------------------------------------------------------------------------------------------------------------------

    TEST_CASE_BEGIN "HMap: Multiple Hash Maps"

    REDIM students(0) AS HMap ' Student ID -> Name
    REDIM grades(0) AS HMap ' Student ID -> Grade
    REDIM attendance(0) AS HMap ' Student ID -> Days Present

    HMap_Initialize students()
    HMap_Initialize grades()
    HMap_Initialize attendance()

    HMap_SetString students(), "101", "John Smith"
    HMap_SetString students(), "102", "Jane Doe"
    HMap_SetString students(), "103", "Bob Wilson"

    HMap_SetInteger grades(), "101", 85
    HMap_SetInteger grades(), "102", 92
    HMap_SetInteger grades(), "103", 78

    HMap_SetInteger attendance(), "101", 45
    HMap_SetInteger attendance(), "102", 50
    HMap_SetInteger attendance(), "103", 48

    TEST_CHECK HMap_GetCount(students()) = 3, "Students table should have 3 entries"
    TEST_CHECK HMap_GetCount(grades()) = 3, "Grades table should have 3 entries"
    TEST_CHECK HMap_GetCount(attendance()) = 3, "Attendance table should have 3 entries"

    TEST_CHECK HMap_GetString(students(), "102") = "Jane Doe", "Should find Jane Doe"
    TEST_CHECK HMap_GetInteger(grades(), "102") = 92, "Jane's grade should be 92"
    TEST_CHECK HMap_GetInteger(attendance(), "102") = 50, "Jane's attendance should be 50"

    TEST_CHECK HMap_Remove(students(), "101"), "Remove should succeed"
    TEST_CHECK HMap_GetCount(students()) = 2, "Students table should have 2 entries after remove"
    TEST_CHECK HMap_GetCount(grades()) = 3, "Grades table should still have 3 entries"
    TEST_CHECK HMap_GetCount(attendance()) = 3, "Attendance table should still have 3 entries"
    TEST_CHECK HMap_GetInteger(grades(), "101") = 85, "Removed student's grade should still exist"

    HMap_Clear students()
    HMap_Clear grades()
    HMap_Clear attendance()

    TEST_CASE_END

    '-----------------------------------------------------------------------------------------------------------------------

    CONST PERF_TEST_KEY_COUNT = 1000000

    REDIM testTable(0) AS HMap
    DIM keyStr AS STRING
    DIM valueStr AS STRING
    DIM perfTestIndex AS LONG

    HMap_Initialize testTable()

    TEST_CASE_BEGIN "HMap: Performance Test: Insert (" + _TOSTR$(PERF_TEST_KEY_COUNT) + " items)"

    FOR perfTestIndex = 1 TO PERF_TEST_KEY_COUNT
        keyStr = "key" + _TOSTR$(perfTestIndex)
        valueStr = "value" + _TOSTR$(perfTestIndex)
        HMap_SetString testTable(), keyStr, valueStr
    NEXT

    TEST_CASE_END

    HMap_Clear testTable()

    TEST_CASE_BEGIN "HMap: Performance Test: Insert after Clear (" + _TOSTR$(PERF_TEST_KEY_COUNT) + " items)"

    FOR perfTestIndex = 1 TO PERF_TEST_KEY_COUNT
        keyStr = "key" + _TOSTR$(perfTestIndex)
        valueStr = "value" + _TOSTR$(perfTestIndex)
        HMap_SetString testTable(), keyStr, valueStr
    NEXT

    TEST_CASE_END

    TEST_CASE_BEGIN "HMap: Performance Test: GetCount after Insert"
    TEST_CHECK HMap_GetCount(testTable()) = PERF_TEST_KEY_COUNT, "Should have " + _TOSTR$(PERF_TEST_KEY_COUNT) + " items"
    TEST_CASE_END

    TEST_CASE_BEGIN "HMap: Performance Test: Get (" + _TOSTR$(PERF_TEST_KEY_COUNT) + " items)"

    FOR perfTestIndex = 1 TO PERF_TEST_KEY_COUNT
        keyStr = "key" + _TOSTR$(perfTestIndex)
        valueStr = HMap_GetString(testTable(), keyStr)
    NEXT

    TEST_CASE_END

    TEST_CASE_BEGIN "HMap: Performance Test: Last key & value pair after Insert"
    TEST_CHECK HMap_GetString(testTable(), keyStr) = "value" + _TOSTR$(PERF_TEST_KEY_COUNT), "The last value should be value" + _TOSTR$(PERF_TEST_KEY_COUNT)
    TEST_CASE_END

    TEST_CASE_BEGIN "HMap: Performance Test: Set (" + _TOSTR$(PERF_TEST_KEY_COUNT) + " items)"

    FOR perfTestIndex = 1 TO PERF_TEST_KEY_COUNT
        keyStr = "key" + _TOSTR$(perfTestIndex)
        valueStr = "value" + _TOSTR$(perfTestIndex + 33)
        HMap_SetString testTable(), keyStr, valueStr
    NEXT

    TEST_CASE_END

    TEST_CASE_BEGIN "HMap: Performance Test: Last key & value pair after Update"
    TEST_CHECK HMap_GetString(testTable(), keyStr) = "value" + _TOSTR$(PERF_TEST_KEY_COUNT + 33), "The last value should be value" + _TOSTR$(PERF_TEST_KEY_COUNT + 33)
    TEST_CASE_END

    TEST_CASE_BEGIN "HMap: Performance Test: Mixed Insert & Remove (" + _TOSTR$(PERF_TEST_KEY_COUNT) + " items)"

    FOR perfTestIndex = 1 TO PERF_TEST_KEY_COUNT
        IF perfTestIndex AND 1 THEN
            keyStr = "newkey" + _TOSTR$(perfTestIndex)
            HMap_SetString testTable(), keyStr, "new value"
        ELSE
            keyStr = "key" + _TOSTR$(perfTestIndex)
            HMap_Remove testTable(), keyStr
        END IF
    NEXT

    TEST_CASE_END

    TEST_CASE_BEGIN "HMap: Performance Test: GetCount after mixed Insert & Remove"
    TEST_CHECK HMap_GetCount(testTable()) = PERF_TEST_KEY_COUNT, "Should have " + _TOSTR$(PERF_TEST_KEY_COUNT) + " items"
    HMap_Free testTable()
    TEST_CHECK_FALSE HMap_IsInitialized(testTable()), "Should return _FALSE after HMap_Free"
    TEST_CASE_END

    '-----------------------------------------------------------------------------------------------------------------------

    TEST_CASE_BEGIN "HMap: Edge Cases"

    HMap_SetString ht(), _STR_EMPTY, "empty"
    TEST_CHECK HMap_GetCount(ht()) = 1, "Count should be 1"
    TEST_CHECK HMap_Contains(ht(), _STR_EMPTY), "Key should exist"

    HMap_SetString ht(), STRING$(256, "A"), "test"
    TEST_CHECK HMap_GetCount(ht()) = 2, "Count should be 2"
    TEST_CHECK HMap_Contains(ht(), STRING$(256, "A")), "Key should exist"

    TEST_CHECK_FALSE HMap_Contains(ht(), "nonexistent"), "Exists with nonexistent key should return false"

    TEST_CASE_END

    '-----------------------------------------------------------------------------------------------------------------------

    TEST_CASE_BEGIN "HMap: Collisions"

    HMap_Clear ht()

    ' These are known to cause collisions when used with FNV-1a hash
    DIM AS STRING collisionKeys(1 TO 10)
    collisionKeys(1) = "8yn0iYCKYHlIj4-BwPqk": collisionKeys(2) = "GReLUrM4wMqfg9yzV3KQ"
    collisionKeys(3) = "gMPflVXtwGDXbIhP73TX": collisionKeys(4) = "LtHf1prlU1bCeYZEdqWf"
    collisionKeys(5) = "pFuM83THhM-Qw8FI5FKo": collisionKeys(6) = ".jPx7rOtTDteKAwvfOEo"
    collisionKeys(7) = "7mohtcOFVz": collisionKeys(8) = "c1E51sSEyx"
    collisionKeys(9) = "6a5x-VbtXk": collisionKeys(10) = "f_2k7GG-4v"

    FOR i = 1 TO 10
        HMap_SetString ht(), collisionKeys(i), "value" + _TOSTR$(i)
    NEXT

    TEST_CHECK HMap_GetCount(ht()) = 10, "Should have 10 items after collision insertions"

    FOR i = 1 TO 10
        TEST_CHECK HMap_GetString(ht(), collisionKeys(i)) = "value" + _TOSTR$(i), "Collision values should be retrievable"
    NEXT

    HMap_Remove ht(), collisionKeys(3)
    HMap_Remove ht(), collisionKeys(7)

    TEST_CHECK HMap_GetCount(ht()) = 8, "Should have 8 items after deleting from collision chain"
    TEST_CHECK_FALSE HMap_Contains(ht(), collisionKeys(3)), "Removed collision item should not exist"
    TEST_CHECK HMap_GetString(ht(), collisionKeys(4)) = "value4", "Remaining collision items should be intact"

    TEST_CASE_END

    '-----------------------------------------------------------------------------------------------------------------------

    TEST_CASE_BEGIN "HMap: Cleanup"

    HMap_Clear ht()
    TEST_CHECK HMap_GetCount(ht()) = 0, "Count should be 0 after clear"

    TEST_CASE_END

    '-----------------------------------------------------------------------------------------------------------------------

    TEST_CASE_BEGIN "HMap: Free"

    HMap_Free ht()
    TEST_CHECK_FALSE HMap_IsInitialized(ht()), "Should return _FALSE after HMap_Free"

    TEST_CASE_END
END SUB

SUB Test_HMap64
    TEST_CASE_BEGIN "HMap64: Basic Operations"

    REDIM intMap(0) AS HMap64

    HMap64_Initialize intMap()
    TEST_CHECK HMap64_GetCount(intMap()) = 0, "Initial count should be 0"
    TEST_CHECK_FALSE HMap64_Contains(intMap(), 123456), "Nonexistent key should not exist"
    TEST_CHECK HMap64_GetString(intMap(), 123456) = "", "Getting nonexistent key should return empty string"

    HMap64_SetString intMap(), &HDEADBEEFCAFEBABE~&&, "test"
    TEST_CHECK HMap64_GetString(intMap(), &HDEADBEEFCAFEBABE~&&) = "test", "String value should be test"
    TEST_CHECK HMap64_GetEntryDataType(intMap(), &HDEADBEEFCAFEBABE~&&) = QBDS_TYPE_STRING, "Data type should be STRING"

    HMap64_SetByte intMap(), 42~&&, 123~%%
    TEST_CHECK HMap64_GetByte(intMap(), 42~&&) = 123~%%, "Byte value should be 123"
    TEST_CHECK HMap64_GetEntryDataType(intMap(), 42~&&) = QBDS_TYPE_BYTE, "Data type should be BYTE"

    HMap64_SetInteger intMap(), 1~&&, 12345%
    TEST_CHECK HMap64_GetInteger(intMap(), 1~&&) = 12345%, "Integer value should be 12345"
    TEST_CHECK HMap64_GetEntryDataType(intMap(), 1~&&) = QBDS_TYPE_INTEGER, "Data type should be INTEGER"

    HMap64_SetLong intMap(), 2~&&, 123456&
    TEST_CHECK HMap64_GetLong(intMap(), 2~&&) = 123456&, "Long value should be 123456"
    TEST_CHECK HMap64_GetEntryDataType(intMap(), 2~&&) = QBDS_TYPE_LONG, "Data type should be LONG"

    HMap64_SetInteger64 intMap(), 3~&&, _INTEGER64_MAX
    TEST_CHECK HMap64_GetInteger64(intMap(), 3~&&) = _INTEGER64_MAX, "Integer64 value should be _INTEGER64_MAX"
    TEST_CHECK HMap64_GetEntryDataType(intMap(), 3~&&) = QBDS_TYPE_INTEGER64, "Data type should be INTEGER64"

    HMap64_SetSingle intMap(), 4~&&, 3.14159!
    TEST_CHECK ABS(HMap64_GetSingle(intMap(), 4~&&) - 3.14159!) < 0.0001, "Single value should be approximately 3.14159"
    TEST_CHECK HMap64_GetEntryDataType(intMap(), 4~&&) = QBDS_TYPE_SINGLE, "Data type should be SINGLE"

    HMap64_SetDouble intMap(), 5~&&, 2.71828182845905D+00
    TEST_CHECK ABS(HMap64_GetDouble(intMap(), 5~&&) - 2.71828182845905D+00) < 0.000000001D+00, "Double value should be approximately e"
    TEST_CHECK HMap64_GetEntryDataType(intMap(), 5~&&) = QBDS_TYPE_DOUBLE, "Data type should be DOUBLE"

    TEST_CHECK HMap64_GetCount(intMap()) = 7, "Total count should be 7"

    TEST_CHECK HMap64_Remove(intMap(), 42~&&), "Remove should succeed"
    TEST_CHECK_FALSE HMap64_Contains(intMap(), 42~&&), "Key should not exist after remove"
    TEST_CHECK HMap64_GetCount(intMap()) = 6, "Count should be 6 after delete"

    HMap64_SetString intMap(), &HDEADBEEFCAFEBABE~&&, "updated"
    TEST_CHECK HMap64_GetString(intMap(), &HDEADBEEFCAFEBABE~&&) = "updated", "String value should be updated"
    TEST_CHECK HMap64_GetCount(intMap()) = 6, "Count should still be 6 after update"

    HMap64_Clear intMap()
    TEST_CHECK HMap64_GetCount(intMap()) = 0, "Count should be 0 after clear"
    TEST_CHECK_FALSE HMap64_Contains(intMap(), 1~&&), "No keys should exist after clear"

    HMap64_Free intMap()
    TEST_CHECK_FALSE HMap64_IsInitialized(intMap()), "Should return _FALSE after HMap64_Free"

    TEST_CASE_END

    '-----------------------------------------------------------------------------------------------------------------------

    CONST PERF_TEST_KEY_COUNT64 = 1000000

    REDIM testTable64(0) AS HMap64
    DIM key64 AS _UNSIGNED _INTEGER64
    DIM valueStr64 AS STRING
    DIM perfTestIndex64 AS LONG

    HMap64_Initialize testTable64()

    TEST_CASE_BEGIN "HMap64: Performance Test: Insert (" + _TOSTR$(PERF_TEST_KEY_COUNT64) + " items)"

    FOR perfTestIndex64 = 1 TO PERF_TEST_KEY_COUNT64
        key64 = perfTestIndex64
        valueStr64 = "value" + _TOSTR$(perfTestIndex64)
        HMap64_SetString testTable64(), key64, valueStr64
    NEXT

    TEST_CASE_END

    TEST_CASE_BEGIN "HMap64: Performance Test: GetCount after Insert"
    TEST_CHECK HMap64_GetCount(testTable64()) = PERF_TEST_KEY_COUNT64, "Should have " + _TOSTR$(PERF_TEST_KEY_COUNT64) + " items"
    TEST_CASE_END

    TEST_CASE_BEGIN "HMap64: Performance Test: Get (" + _TOSTR$(PERF_TEST_KEY_COUNT64) + " items)"

    FOR perfTestIndex64 = 1 TO PERF_TEST_KEY_COUNT64
        key64 = perfTestIndex64
        valueStr64 = HMap64_GetString(testTable64(), key64)
    NEXT

    TEST_CASE_END

    TEST_CASE_BEGIN "HMap64: Performance Test: Last key & value pair after Insert"
    TEST_CHECK HMap64_GetString(testTable64(), key64) = "value" + _TOSTR$(PERF_TEST_KEY_COUNT64), "The last value should be value" + _TOSTR$(PERF_TEST_KEY_COUNT64)
    TEST_CASE_END

    TEST_CASE_BEGIN "HMap64: Performance Test: Set (" + _TOSTR$(PERF_TEST_KEY_COUNT64) + " items)"

    FOR perfTestIndex64 = 1 TO PERF_TEST_KEY_COUNT64
        key64 = perfTestIndex64
        valueStr64 = "value" + _TOSTR$(perfTestIndex64 + 33)
        HMap64_SetString testTable64(), key64, valueStr64
    NEXT

    TEST_CASE_END

    TEST_CASE_BEGIN "HMap64: Performance Test: Last key & value pair after Update"
    TEST_CHECK HMap64_GetString(testTable64(), key64) = "value" + _TOSTR$(PERF_TEST_KEY_COUNT64 + 33), "The last value should be value" + _TOSTR$(PERF_TEST_KEY_COUNT64 + 33)
    TEST_CASE_END

    TEST_CASE_BEGIN "HMap64: Performance Test: Mixed Insert & Remove (" + _TOSTR$(PERF_TEST_KEY_COUNT64) + " items)"

    FOR perfTestIndex64 = 1 TO PERF_TEST_KEY_COUNT64
        IF perfTestIndex64 AND 1 THEN
            key64 = PERF_TEST_KEY_COUNT64 + perfTestIndex64
            HMap64_SetString testTable64(), key64, "new value"
        ELSE
            key64 = perfTestIndex64
            HMap64_Remove testTable64(), key64
        END IF
    NEXT

    TEST_CASE_END

    TEST_CASE_BEGIN "HMap64: Performance Test: GetCount after mixed Insert & Remove"
    TEST_CHECK HMap64_GetCount(testTable64()) = PERF_TEST_KEY_COUNT64, "Should have " + _TOSTR$(PERF_TEST_KEY_COUNT64) + " items"
    HMap64_Free testTable64()
    TEST_CHECK_FALSE HMap64_IsInitialized(testTable64()), "Should return _FALSE after HMap64_Free"
    TEST_CASE_END

    '-----------------------------------------------------------------------------------------------------------------------

    TEST_CASE_BEGIN "HMap64: Edge Cases"

    HMap64_Initialize intMap()

    HMap64_SetString intMap(), 0, "zero"
    TEST_CHECK HMap64_GetString(intMap(), 0) = "zero", "Should handle key 0"
    TEST_CHECK HMap64_GetCount(intMap()) = 1, "Count should be 1"

    HMap64_Remove intMap(), 0
    TEST_CHECK_FALSE HMap64_Contains(intMap(), 0), "Should be able to remove key 0"
    TEST_CHECK HMap64_GetCount(intMap()) = 0, "Count should be 0"

    HMap64_Free intMap()

    TEST_CASE_END
END SUB

SUB Test_HSet
    TEST_CASE_BEGIN "HSet: Initialization and Basic Operations"
    REDIM mySet(0) AS HSet
    HSet_Initialize mySet()
    TEST_CHECK HSet_GetCount(mySet()) = 0, "Set count should be 0"
    HSet_AddString mySet(), "Apple"
    HSet_AddString mySet(), "Banana"
    HSet_AddString mySet(), "Apple" ' Add duplicate
    TEST_CHECK HSet_GetCount(mySet()) = 2, "Set count should be 2"
    TEST_CHECK HSet_ContainsString(mySet(), "Apple"), "Set should contain 'Apple'"
    TEST_CHECK HSet_ContainsString(mySet(), "Banana"), "Set should contain 'Banana'"
    TEST_CHECK_FALSE HSet_ContainsString(mySet(), "Cherry"), "Set should not contain 'Cherry'"
    TEST_CHECK HSet_RemoveString(mySet(), "Apple"), "Removing 'Apple' should succeed"
    TEST_CHECK HSet_GetCount(mySet()) = 1, "Set count should be 1 after remove"
    TEST_CHECK_FALSE HSet_ContainsString(mySet(), "Apple"), "Set should not contain 'Apple' after removal"
    HSet_Free mySet()
    TEST_CASE_END

    '-----------------------------------------------------------------------------------------------------------------------

    TEST_CASE_BEGIN "HSet: All Data Types"
    HSet_Initialize mySet()

    HSet_AddByte mySet(), 127
    TEST_CHECK HSet_ContainsByte(mySet(), 127), "Set should contain byte 127"
    TEST_CHECK HSet_GetCount(mySet()) = 1, "Set count should be 1"
    HSet_AddByte mySet(), 127
    TEST_CHECK HSet_GetCount(mySet()) = 1, "Set count should still be 1"
    TEST_CHECK HSet_RemoveByte(mySet(), 127), "Removing byte 127 should succeed"
    TEST_CHECK_FALSE HSet_ContainsByte(mySet(), 127), "Set should not contain byte 127"

    HSet_AddInteger mySet(), -32768
    TEST_CHECK HSet_ContainsInteger(mySet(), -32768), "Set should contain integer -32768"
    TEST_CHECK HSet_RemoveInteger(mySet(), -32768), "Removing integer -32768 should succeed"

    HSet_AddLong mySet(), 2147483647
    TEST_CHECK HSet_ContainsLong(mySet(), 2147483647), "Set should contain long 2147483647"
    TEST_CHECK HSet_RemoveLong(mySet(), 2147483647), "Removing long 2147483647 should succeed"

    HSet_AddInteger64 mySet(), 9223372036854775807~&&
    TEST_CHECK HSet_ContainsInteger64(mySet(), 9223372036854775807~&&), "Set should contain int64 max"
    TEST_CHECK HSet_RemoveInteger64(mySet(), 9223372036854775807~&&), "Removing int64 max should succeed"

    HSet_AddSingle mySet(), 3.14!
    TEST_CHECK HSet_ContainsSingle(mySet(), 3.14!), "Set should contain single 3.14"
    TEST_CHECK HSet_RemoveSingle(mySet(), 3.14!), "Removing single 3.14 should succeed"

    HSet_AddDouble mySet(), 2.71828182845905D+00
    TEST_CHECK HSet_ContainsDouble(mySet(), 2.71828182845905D+00), "Set should contain double e"
    TEST_CHECK HSet_RemoveDouble(mySet(), 2.71828182845905D+00), "Removing double e should succeed"

    TEST_CHECK HSet_GetCount(mySet()) = 0, "Set should be empty"
    HSet_Free mySet()
    TEST_CASE_END

    '-----------------------------------------------------------------------------------------------------------------------

    TEST_CASE_BEGIN "HSet: Edge Cases"
    HSet_Initialize mySet()

    ' Empty string
    HSet_AddString mySet(), ""
    TEST_CHECK HSet_ContainsString(mySet(), ""), "Set should contain empty string"
    TEST_CHECK HSet_GetCount(mySet()) = 1, "Set count should be 1"
    TEST_CHECK HSet_RemoveString(mySet(), ""), "Removing empty string should succeed"
    TEST_CHECK HSet_GetCount(mySet()) = 0, "Set count should be 0"

    ' Long string
    DIM longString AS STRING: longString = STRING$(1000, "A")
    HSet_AddString mySet(), longString
    TEST_CHECK HSet_ContainsString(mySet(), longString), "Set should contain long string"
    TEST_CHECK HSet_RemoveString(mySet(), longString), "Removing long string should succeed"

    ' Clear and re-add
    HSet_AddString mySet(), "A"
    HSet_Clear mySet()
    TEST_CHECK HSet_GetCount(mySet()) = 0, "Set count should be 0 after clear"
    TEST_CHECK_FALSE HSet_ContainsString(mySet(), "A"), "Set should not contain 'A' after clear"
    HSet_AddString mySet(), "B"
    TEST_CHECK HSet_ContainsString(mySet(), "B"), "Set should contain 'B' after re-adding"
    TEST_CHECK HSet_GetCount(mySet()) = 1, "Set count should be 1"

    HSet_Free mySet()
    TEST_CASE_END

    '-----------------------------------------------------------------------------------------------------------------------

    ' These are known to cause collisions when used with FNV-1a hash
    DIM AS STRING collisionKeys(1 TO 10)
    collisionKeys(1) = "8yn0iYCKYHlIj4-BwPqk": collisionKeys(2) = "GReLUrM4wMqfg9yzV3KQ"
    collisionKeys(3) = "gMPflVXtwGDXbIhP73TX": collisionKeys(4) = "LtHf1prlU1bCeYZEdqWf"
    collisionKeys(5) = "pFuM83THhM-Qw8FI5FKo": collisionKeys(6) = ".jPx7rOtTDteKAwvfOEo"
    collisionKeys(7) = "7mohtcOFVz": collisionKeys(8) = "c1E51sSEyx"
    collisionKeys(9) = "6a5x-VbtXk": collisionKeys(10) = "f_2k7GG-4v"

    TEST_CASE_BEGIN "HSet: Collisions"
    HSet_Initialize mySet()

    DIM i AS LONG
    FOR i = 1 TO 10
        HSet_AddString mySet(), collisionKeys(i)
    NEXT

    TEST_CHECK HSet_GetCount(mySet()) = 10, "Set should have 10 items after collision insertions"

    FOR i = 1 TO 10
        TEST_CHECK HSet_ContainsString(mySet(), collisionKeys(i)), "Collision values should exist"
    NEXT

    HSet_RemoveString mySet(), collisionKeys(3)
    TEST_CHECK HSet_GetCount(mySet()) = 9, "Should have 9 items after deleting from collision chain"
    TEST_CHECK_FALSE HSet_ContainsString(mySet(), collisionKeys(3)), "Removed collision item should not exist"
    TEST_CHECK HSet_ContainsString(mySet(), collisionKeys(4)), "Remaining collision items should be intact"

    HSet_Free mySet()
    TEST_CASE_END

    '-----------------------------------------------------------------------------------------------------------------------

    CONST HSET_PERF_COUNT = 1000000
    DIM perfSetIndex AS LONG
    HSet_Initialize mySet()

    TEST_CASE_BEGIN "HSet: Performance Test: Add (" + _TOSTR$(HSET_PERF_COUNT) + " items)"
    FOR perfSetIndex = 1 TO HSET_PERF_COUNT
        HSet_AddLong mySet(), perfSetIndex
    NEXT
    TEST_CASE_END

    TEST_CASE_BEGIN "HSet: Performance Test: GetCount"
    TEST_CHECK HSet_GetCount(mySet()) = HSET_PERF_COUNT, "Set count should be " + _TOSTR$(HSET_PERF_COUNT)
    TEST_CASE_END

    TEST_CASE_BEGIN "HSet: Performance Test: Contains (" + _TOSTR$(HSET_PERF_COUNT) + " items)"
    FOR perfSetIndex = 1 TO HSET_PERF_COUNT
        TEST_CHECK HSet_ContainsLong(mySet(), perfSetIndex), "Should contain item " + _TOSTR$(perfSetIndex)
    NEXT
    TEST_CASE_END

    TEST_CASE_BEGIN "HSet: Performance Test: Remove (" + _TOSTR$(HSET_PERF_COUNT) + " items)"
    FOR perfSetIndex = 1 TO HSET_PERF_COUNT
        TEST_CHECK HSet_RemoveLong(mySet(), perfSetIndex), "Should remove item " + _TOSTR$(perfSetIndex)
    NEXT
    TEST_CASE_END

    TEST_CASE_BEGIN "HSet: Performance Test: GetCount after Remove"
    TEST_CHECK HSet_GetCount(mySet()) = 0, "Set count should be 0 after removal"
    TEST_CASE_END

    HSet_Free mySet()
END SUB

SUB Test_LList
    TEST_CASE_BEGIN "LList: Initialization"

    REDIM l(0) AS LList

    LList_Initialize l()
    TEST_CHECK LList_GetCount(l()) = 0, "Initial count should be 0"
    TEST_CHECK LList_GetCapacity(l()) > 1, "Capacity should be more than 1"

    TEST_CASE_END

    '-----------------------------------------------------------------------------------------------------------------------

    TEST_CASE_BEGIN "LList: Basic String Operations"

    LList_PushBackString l(), "Hello"
    TEST_CHECK LList_GetCount(l()) = 1, "Count should be 1"
    TEST_CHECK LList_GetString(l(), LList_GetBackNode(l())) = "Hello", "String value should be Hello"

    LList_PushFrontString l(), "World"
    TEST_CHECK LList_GetCount(l()) = 2, "Count should be 2"
    TEST_CHECK LList_GetString(l(), LList_GetFrontNode(l())) = "World", "String value should be World"

    TEST_CHECK LList_PopBackString(l()) = "Hello", "Popped value should be Hello"
    TEST_CHECK LList_GetCount(l()) = 1, "Count should be 1"

    TEST_CHECK LList_PopFrontString(l()) = "World", "Popped value should be World"
    TEST_CHECK LList_GetCount(l()) = 0, "Count should be 0"

    LList_Clear l()
    TEST_CHECK LList_GetCount(l()) = 0, "Count should be 0 after clear"

    TEST_CASE_END

    '-----------------------------------------------------------------------------------------------------------------------

    TEST_CASE_BEGIN "LList: Insert and Delete"

    LList_Clear l()

    LList_PushBackString l(), "A"
    LList_PushBackString l(), "B"
    LList_PushBackString l(), "C"

    TEST_CHECK LList_GetCount(l()) = 3, "Count should be 3"
    TEST_CHECK LList_GetString(l(), LList_GetFrontNode(l())) = "A", "Value at front should be A"
    TEST_CHECK LList_GetString(l(), LList_GetNextNode(l(), LList_GetFrontNode(l()))) = "B", "Value after front should be B"
    TEST_CHECK LList_GetString(l(), LList_GetPreviousNode(l(), LList_GetBackNode(l()))) = "B", "Value before back should be B"
    TEST_CHECK LList_GetString(l(), LList_GetBackNode(l())) = "C", "Value at back should be C"

    LList_RemoveNode l(), LList_GetNextNode(l(), LList_GetFrontNode(l()))
    TEST_CHECK LList_GetCount(l()) = 2, "Count should be 2"
    TEST_CHECK LList_GetString(l(), LList_GetFrontNode(l())) = "A", "Value at front should be A"
    TEST_CHECK LList_GetString(l(), LList_GetBackNode(l())) = "C", "Value at back should be C"

    LList_RemoveNode l(), LList_GetFrontNode(l())
    TEST_CHECK LList_GetCount(l()) = 1, "Count should be 1"
    TEST_CHECK LList_GetString(l(), LList_GetFrontNode(l())) = "C", "Value at front should be C"
    TEST_CHECK LList_GetString(l(), LList_GetBackNode(l())) = "C", "Value at back should be C"

    LList_RemoveNode l(), LList_GetBackNode(l())
    TEST_CHECK LList_GetCount(l()) = 0, "Count should be 0"

    LList_Clear l()

    TEST_CASE_END

    '-----------------------------------------------------------------------------------------------------------------------

    TEST_CASE_BEGIN "LList: Circular List"

    LList_Clear l()

    LList_PushBackString l(), "A"
    LList_PushBackString l(), "B"
    LList_PushBackString l(), "C"

    LList_MakeCircular l(), _TRUE

    TEST_CHECK LList_IsCircular(l()), "List should be circular"

    DIM head AS _UNSIGNED _OFFSET: head = LList_GetFrontNode(l())
    DIM tail AS _UNSIGNED _OFFSET: tail = LList_GetBackNode(l())

    TEST_CHECK LList_GetNextNode(l(), tail) = head, "Tail should point to head"
    TEST_CHECK LList_GetPreviousNode(l(), head) = tail, "Head should point to tail"

    LList_MakeCircular l(), _FALSE

    TEST_CHECK_FALSE LList_IsCircular(l()), "List should not be circular"

    TEST_CHECK LList_GetNextNode(l(), tail) = 0, "Tail should point to null"
    TEST_CHECK LList_GetPreviousNode(l(), head) = 0, "Head should point to null"

    LList_Clear l()

    TEST_CASE_END

    '-----------------------------------------------------------------------------------------------------------------------

    TEST_CASE_BEGIN "LList: All Data Types"

    LList_Clear l()

    LList_PushBackByte l(), 127
    TEST_CHECK LList_GetByte(l(), LList_GetBackNode(l())) = 127, "Byte value should be 127"
    TEST_CHECK LList_PopFrontByte(l()) = 127, "Popped byte value should be 127"

    LList_PushBackInteger l(), 32767
    TEST_CHECK LList_GetInteger(l(), LList_GetBackNode(l())) = 32767, "Integer value should be 32767"
    TEST_CHECK LList_PopFrontInteger(l()) = 32767, "Popped integer value should be 32767"

    LList_PushBackLong l(), 2147483647
    TEST_CHECK LList_GetLong(l(), LList_GetBackNode(l())) = 2147483647, "Long value should be 2147483647"
    TEST_CHECK LList_PopFrontLong(l()) = 2147483647, "Popped long value should be 2147483647"

    LList_PushBackInteger64 l(), 9223372036854775807~&&
    TEST_CHECK LList_GetInteger64(l(), LList_GetBackNode(l())) = 9223372036854775807~&&, "Integer64 value should be max"
    TEST_CHECK LList_PopFrontInteger64(l()) = 9223372036854775807~&&, "Popped integer64 value should be max"

    LList_PushBackSingle l(), 1.2345!
    TEST_CHECK ABS(LList_GetSingle(l(), LList_GetBackNode(l())) - 1.2345!) < 0.0001, "Single value should be approx 1.2345"
    TEST_CHECK ABS(LList_PopFrontSingle(l()) - 1.2345!) < 0.0001, "Popped single value should be approx 1.2345"

    LList_PushBackDouble l(), 1.23456789#
    TEST_CHECK ABS(LList_GetDouble(l(), LList_GetBackNode(l())) - 1.23456789#) < 0.00000001, "Double value should be approx 1.23456789"
    TEST_CHECK ABS(LList_PopFrontDouble(l()) - 1.23456789#) < 0.00000001, "Popped double value should be approx 1.23456789"

    TEST_CHECK LList_GetCount(l()) = 0, "Count should be 0 after all pops"

    LList_Clear l()

    TEST_CASE_END

    '-----------------------------------------------------------------------------------------------------------------------

    TEST_CASE_BEGIN "LList: Edge Cases"

    LList_Clear l()

    LList_Clear l()
    TEST_CHECK LList_GetCount(l()) = 0, "Count should be 0 after clearing an empty list"

    LList_Free l()
    TEST_CHECK_FALSE LList_IsInitialized(l()), "List should not be initialized after free"

    LList_Initialize l()

    LList_PushBackString l(), "first"
    LList_InsertAfterString l(), LList_GetFrontNode(l()), "second"
    TEST_CHECK LList_GetCount(l()) = 2, "Count should be 2 after insert"
    TEST_CHECK LList_GetString(l(), LList_GetBackNode(l())) = "second", "Second element should be 'second'"
    TEST_CHECK LList_GetString(l(), LList_GetFrontNode(l())) = "first", "First element should still be 'first'"

    LList_Clear l()

    TEST_CASE_END

    '-----------------------------------------------------------------------------------------------------------------------

    CONST LL_PERF_COUNT = 1000000

    LList_Clear l()
    DIM i AS LONG

    TEST_CASE_BEGIN "LList: Performance Test - PushBack (" + _TOSTR$(LL_PERF_COUNT) + " items)"
    FOR i = 1 TO LL_PERF_COUNT
        LList_PushBackInteger64 l(), i
    NEXT
    TEST_CHECK LList_GetCount(l()) = LL_PERF_COUNT, "Count should be " + _TOSTR$(LL_PERF_COUNT)
    TEST_CASE_END

    TEST_CASE_BEGIN "LList: Performance Test - Forward Iteration"
    DIM currentNode AS _UNSIGNED _OFFSET: currentNode = LList_GetFrontNode(l())
    DIM currentVal AS _UNSIGNED LONG: currentVal = 1
    WHILE currentNode <> 0
        TEST_CHECK LList_GetInteger64(l(), currentNode) = currentVal, "Value should be " + _TOSTR$(currentVal)
        currentNode = LList_GetNextNode(l(), currentNode)
        currentVal = currentVal + 1
    WEND
    TEST_CASE_END

    DIM v AS _UNSIGNED LONG

    TEST_CASE_BEGIN "LList: Performance Test - PopFront (" + _TOSTR$(LL_PERF_COUNT) + " items)"
    FOR i = 1 TO LL_PERF_COUNT
        v = LList_PopFrontInteger64(l())
    NEXT
    TEST_CHECK LList_GetCount(l()) = 0, "Count should be 0 after popping all items"
    TEST_CASE_END

    TEST_CASE_BEGIN "LList: Performance Test - PushFront (" + _TOSTR$(LL_PERF_COUNT) + " items)"
    LList_Clear l()
    FOR i = 1 TO LL_PERF_COUNT
        LList_PushFrontInteger64 l(), i
    NEXT
    TEST_CHECK LList_GetCount(l()) = LL_PERF_COUNT, "Count should be " + _TOSTR$(LL_PERF_COUNT)
    TEST_CASE_END

    TEST_CASE_BEGIN "LList: Performance Test - Backward Iteration"
    currentNode = LList_GetBackNode(l())
    currentVal = 1
    WHILE currentNode <> 0
        TEST_CHECK LList_GetInteger64(l(), currentNode) = currentVal, "Value should be " + _TOSTR$(currentVal)
        currentNode = LList_GetPreviousNode(l(), currentNode)
        currentVal = currentVal + 1
    WEND
    TEST_CASE_END

    TEST_CASE_BEGIN "LList: Performance Test - PopBack (" + _TOSTR$(LL_PERF_COUNT) + " items)"
    FOR i = 1 TO LL_PERF_COUNT
        v = LList_PopBackInteger64(l())
    NEXT
    TEST_CHECK LList_GetCount(l()) = 0, "Count should be 0 after popping all items"
    TEST_CASE_END

    LList_Free l()
END SUB

SUB Test_Queue
    TEST_CASE_BEGIN "Queue: Initialization"

    REDIM q(0) AS Queue

    Queue_Initialize q()
    TEST_CHECK Queue_IsInitialized(q()), "Queue should be initialized"
    TEST_CHECK Queue_GetCount(q()) = 0, "Initial count should be 0"
    TEST_CHECK Queue_GetCapacity(q()) > 0, "Initial capacity should be greater than 0"

    TEST_CASE_END

    '-----------------------------------------------------------------------------------------------------------------------

    TEST_CASE_BEGIN "Queue: All Data Types"

    Queue_Clear q()

    Queue_EnqueueByte q(), 127
    TEST_CHECK Queue_PeekByte(q()) = 127, "Byte value should be 127"
    TEST_CHECK Queue_PeekElementDataType(q()) = QBDS_TYPE_BYTE, "Data type should be BYTE"
    TEST_CHECK Queue_DequeueByte(q()) = 127, "Dequeued byte value should be 127"

    Queue_EnqueueInteger q(), 32767
    TEST_CHECK Queue_PeekInteger(q()) = 32767, "Integer value should be 32767"
    TEST_CHECK Queue_PeekElementDataType(q()) = QBDS_TYPE_INTEGER, "Data type should be INTEGER"
    TEST_CHECK Queue_DequeueInteger(q()) = 32767, "Dequeued integer value should be 32767"

    Queue_EnqueueLong q(), 2147483647
    TEST_CHECK Queue_PeekLong(q()) = 2147483647, "Long value should be 2147483647"
    TEST_CHECK Queue_PeekElementDataType(q()) = QBDS_TYPE_LONG, "Data type should be LONG"
    TEST_CHECK Queue_DequeueLong(q()) = 2147483647, "Dequeued long value should be 2147483647"

    Queue_EnqueueInteger64 q(), 9223372036854775807~&&
    TEST_CHECK Queue_PeekInteger64(q()) = 9223372036854775807~&&, "Integer64 value should be max"
    TEST_CHECK Queue_PeekElementDataType(q()) = QBDS_TYPE_INTEGER64, "Data type should be INTEGER64"
    TEST_CHECK Queue_DequeueInteger64(q()) = 9223372036854775807~&&, "Dequeued integer64 value should be max"

    Queue_EnqueueSingle q(), 1.2345!
    TEST_CHECK ABS(Queue_PeekSingle(q()) - 1.2345!) < 0.0001, "Single value should be approx 1.2345"
    TEST_CHECK Queue_PeekElementDataType(q()) = QBDS_TYPE_SINGLE, "Data type should be SINGLE"
    TEST_CHECK ABS(Queue_DequeueSingle(q()) - 1.2345!) < 0.0001, "Dequeued single value should be approx 1.2345"

    Queue_EnqueueDouble q(), 1.23456789#
    TEST_CHECK ABS(Queue_PeekDouble(q()) - 1.23456789#) < 0.00000001, "Double value should be approx 1.23456789"
    TEST_CHECK Queue_PeekElementDataType(q()) = QBDS_TYPE_DOUBLE, "Data type should be DOUBLE"
    TEST_CHECK ABS(Queue_DequeueDouble(q()) - 1.23456789#) < 0.00000001, "Dequeued double value should be approx 1.23456789"

    Queue_EnqueueString q(), "hello"
    TEST_CHECK Queue_PeekString(q()) = "hello", "String value should be 'hello'"
    TEST_CHECK Queue_PeekElementDataType(q()) = QBDS_TYPE_STRING, "Data type should be STRING"
    TEST_CHECK Queue_DequeueString(q()) = "hello", "Dequeued string value should be 'hello'"

    TEST_CHECK Queue_GetCount(q()) = 0, "Count should be 0 after all dequeues"

    TEST_CASE_END

    '-----------------------------------------------------------------------------------------------------------------------

    TEST_CASE_BEGIN "Queue: Growth and Wrapping"

    Queue_Clear q()
    DIM initialCapacity AS LONG: initialCapacity = Queue_GetCapacity(q())

    DIM i AS LONG
    FOR i = 1 TO initialCapacity
        Queue_EnqueueInteger q(), i
    NEXT

    TEST_CHECK Queue_GetCount(q()) = initialCapacity, "Queue should be full"

    Queue_EnqueueInteger q(), initialCapacity + 1
    TEST_CHECK Queue_GetCapacity(q()) > initialCapacity, "Capacity should have grown"
    TEST_CHECK Queue_GetCount(q()) = initialCapacity + 1, "Count should be initialCapacity + 1"

    FOR i = 1 TO initialCapacity + 1
        TEST_CHECK Queue_DequeueInteger(q()) = i, "Value should be " + _TOSTR$(i)
    NEXT

    Queue_Clear q()
    FOR i = 1 TO initialCapacity
        Queue_EnqueueInteger q(), i
    NEXT

    FOR i = 1 TO initialCapacity / 2
        TEST_CHECK Queue_DequeueInteger(q()) = i, "Dequeued value should be " + _TOSTR$(i)
    NEXT
    FOR i = 1 TO initialCapacity / 2
        Queue_EnqueueInteger q(), initialCapacity + i
    NEXT

    TEST_CHECK Queue_GetCount(q()) = initialCapacity, "Count should be back to initialCapacity"

    FOR i = (initialCapacity / 2) + 1 TO initialCapacity + (initialCapacity / 2)
        TEST_CHECK Queue_DequeueInteger(q()) = i, "Dequeued value should be " + _TOSTR$(i)
    NEXT

    TEST_CHECK Queue_GetCount(q()) = 0, "Queue should be empty"

    TEST_CASE_END

    '-----------------------------------------------------------------------------------------------------------------------

    TEST_CASE_BEGIN "Queue: Edge Cases"

    Queue_Clear q()
    TEST_CHECK Queue_GetCount(q()) = 0, "Count should be 0 after clearing an empty queue"
    Queue_EnqueueString q(), ""
    TEST_CHECK Queue_GetCount(q()) = 1, "Count should be 1 after enqueueing an empty string"
    TEST_CHECK Queue_DequeueString(q()) = "", "Dequeued value should be an empty string"

    Queue_Free q()
    TEST_CHECK_FALSE Queue_IsInitialized(q()), "Queue should not be initialized after free"

    Queue_Initialize q()
    TEST_CHECK Queue_IsInitialized(q()), "Queue should be initialized again"

    Queue_Free q()

    TEST_CASE_END

    '-----------------------------------------------------------------------------------------------------------------------

    CONST QUEUE_PERF_COUNT = 1000000

    Queue_Initialize q()

    TEST_CASE_BEGIN "Queue: Performance Test - Enqueue (" + _TOSTR$(QUEUE_PERF_COUNT) + " items)"
    FOR i = 1 TO QUEUE_PERF_COUNT
        Queue_EnqueueLong q(), i
    NEXT
    TEST_CASE_END

    TEST_CASE_BEGIN "Queue: Performance Test - GetCount after Enqueue"
    TEST_CHECK Queue_GetCount(q()) = QUEUE_PERF_COUNT, "Count should be " + _TOSTR$(QUEUE_PERF_COUNT)
    TEST_CASE_END

    DIM v AS LONG

    TEST_CASE_BEGIN "Queue: Performance Test - Dequeue (" + _TOSTR$(QUEUE_PERF_COUNT) + " items)"
    FOR i = 1 TO QUEUE_PERF_COUNT
        v = Queue_DequeueLong(q())
    NEXT
    TEST_CASE_END

    TEST_CASE_BEGIN "Queue: Performance Test - Last value after Dequeue"
    TEST_CHECK v = QUEUE_PERF_COUNT, "Last value should be " + _TOSTR$(QUEUE_PERF_COUNT)
    TEST_CASE_END

    TEST_CASE_BEGIN "Queue: Performance Test - GetCount after Dequeue"
    TEST_CHECK Queue_GetCount(q()) = 0, "Count should be 0 after dequeuing all items"
    TEST_CASE_END

    Queue_Free q()
END SUB

SUB Test_Stack
    TEST_CASE_BEGIN "Stack: Initialization"

    REDIM s(0) AS Stack

    Stack_Initialize s()
    TEST_CHECK Stack_GetCount(s()) = 0, "Initial count should be 0"

    TEST_CASE_END

    '-----------------------------------------------------------------------------------------------------------------------

    TEST_CASE_BEGIN "Stack: Basic Integer Operations"

    Stack_PushInteger s(), 42
    TEST_CHECK Stack_PeekInteger(s()) = 42, "Integer value should be 42"
    TEST_CHECK Stack_PeekElementDataType(s()) = QBDS_TYPE_INTEGER, "Data type should be INT"
    TEST_CHECK Stack_GetCount(s()) = 1, "Count should be 1"

    Stack_PushInteger s(), 100
    TEST_CHECK Stack_PeekInteger(s()) = 100, "Pushed integer value should be 100"
    TEST_CHECK Stack_GetCount(s()) = 2, "Count should be 2 after update"

    TEST_CHECK Stack_PopInteger(s()) = 100, "Popped integer should be 100"
    TEST_CHECK Stack_GetCount(s()) = 1, "Count should be 1 after pop"

    TEST_CHECK Stack_PopInteger(s()) = 42, "Popped integer should be 42"
    TEST_CHECK Stack_GetCount(s()) = 0, "Count should be 0 after pop"

    Stack_Clear s()
    TEST_CHECK Stack_GetCount(s()) = 0, "Count should be 0 after clear"

    TEST_CASE_END

    '-----------------------------------------------------------------------------------------------------------------------

    TEST_CASE_BEGIN "Stack: All Data Types"

    Stack_Clear s()

    Stack_PushString s(), "hello"
    TEST_CHECK Stack_PeekString(s()) = "hello", "String value should be 'hello'"
    TEST_CHECK Stack_PopString(s()) = "hello", "Popped string value should be 'hello'"

    Stack_PushByte s(), 127
    TEST_CHECK Stack_PeekByte(s()) = 127, "Byte value should be 127"
    TEST_CHECK Stack_PopByte(s()) = 127, "Popped byte value should be 127"

    Stack_PushLong s(), -2147483648
    TEST_CHECK Stack_PeekLong(s()) = -2147483648, "Long value should be min"
    TEST_CHECK Stack_PopLong(s()) = -2147483648, "Popped long value should be min"

    Stack_PushInteger64 s(), -9223372036854775808~&&
    TEST_CHECK Stack_PeekInteger64(s()) = -9223372036854775808~&&, "Integer64 value should be min"
    TEST_CHECK Stack_PopInteger64(s()) = -9223372036854775808~&&, "Popped integer64 value should be min"

    Stack_PushSingle s(), -1.2345!
    TEST_CHECK ABS(Stack_PeekSingle(s()) - -1.2345!) < 0.0001, "Single value should be approx -1.2345"
    TEST_CHECK ABS(Stack_PopSingle(s()) - -1.2345!) < 0.0001, "Popped single value should be approx -1.2345"

    Stack_PushDouble s(), -1.23456789#
    TEST_CHECK ABS(Stack_PeekDouble(s()) - -1.23456789#) < 0.00000001, "Double value should be approx -1.23456789"
    TEST_CHECK ABS(Stack_PopDouble(s()) - -1.23456789#) < 0.00000001, "Popped double value should be approx -1.23456789"

    TEST_CHECK Stack_GetCount(s()) = 0, "Count should be 0 after all pops"

    Stack_Clear s()

    TEST_CASE_END

    '-----------------------------------------------------------------------------------------------------------------------

    TEST_CASE_BEGIN "Stack: Edge Cases"

    Stack_Clear s()
    TEST_CHECK Stack_GetCount(s()) = 0, "Count should be 0 after clearing an empty stack"
    Stack_PushString s(), ""
    TEST_CHECK Stack_GetCount(s()) = 1, "Count should be 1 after pushing an empty string"
    TEST_CHECK Stack_PopString(s()) = "", "Popped value should be an empty string"

    Stack_Free s()
    TEST_CHECK_FALSE Stack_IsInitialized(s()), "Stack should not be initialized after free"

    Stack_Initialize s()
    TEST_CHECK Stack_IsInitialized(s()), "Stack should be initialized"

    TEST_CASE_END

    '-----------------------------------------------------------------------------------------------------------------------

    CONST STACK_PERF_COUNT = 1000000

    Stack_Clear s()
    DIM i AS LONG

    TEST_CASE_BEGIN "Stack: Performance Test - Push (" + _TOSTR$(STACK_PERF_COUNT) + " items)"
    FOR i = 1 TO STACK_PERF_COUNT
        Stack_PushInteger64 s(), i
    NEXT
    TEST_CHECK Stack_GetCount(s()) = STACK_PERF_COUNT, "Count should be " + _TOSTR$(STACK_PERF_COUNT)
    TEST_CASE_END

    TEST_CASE_BEGIN "Stack: Performance Test - Pop (" + _TOSTR$(STACK_PERF_COUNT) + " items)"
    FOR i = STACK_PERF_COUNT TO 1 STEP -1
        TEST_CHECK Stack_PopInteger64(s()) = i, "Popped value should be " + _TOSTR$(i)
    NEXT
    TEST_CHECK Stack_GetCount(s()) = 0, "Count should be 0 after popping all items"
    TEST_CASE_END

    Stack_Free s()
END SUB

SUB Test_String
    TEST_CASE_BEGIN "String: Case Conversion"

    TEST_CHECK Asc_ToLowercase(__ASC_UPPER_A) = __ASC_LOWER_A, "Asc_ToLowercase('A') should be 'a'"
    TEST_CHECK Asc_ToLowercase(__ASC_LOWER_A) = __ASC_LOWER_A, "Asc_ToLowercase('a') should be 'a'"
    TEST_CHECK Asc_ToLowercase(__ASC_0) = __ASC_0, "Asc_ToLowercase('0') should be '0'"

    TEST_CHECK Asc_ToUppercase(__ASC_LOWER_B) = __ASC_UPPER_B, "Asc_ToUppercase('b') should be 'B'"
    TEST_CHECK Asc_ToUppercase(__ASC_UPPER_B) = __ASC_UPPER_B, "Asc_ToUppercase('B') should be 'B'"
    TEST_CHECK Asc_ToUppercase(__ASC_1) = __ASC_1, "Asc_ToUppercase('1') should be '1'"

    TEST_CASE_END

    TEST_CASE_BEGIN "String: Character Checks"

    TEST_CHECK Asc_IsAlphanumeric(__ASC_UPPER_C), "Asc_IsAlphanumeric('C')"
    TEST_CHECK Asc_IsAlphanumeric(__ASC_LOWER_D), "Asc_IsAlphanumeric('d')"
    TEST_CHECK Asc_IsAlphanumeric(__ASC_2), "Asc_IsAlphanumeric('2')"
    TEST_CHECK_FALSE Asc_IsAlphanumeric(ASC("!")), "NOT Asc_IsAlphanumeric('!')"

    TEST_CHECK Asc_IsAlphabetic(__ASC_UPPER_E), "Asc_IsAlphabetic('E')"
    TEST_CHECK Asc_IsAlphabetic(__ASC_LOWER_F), "Asc_IsAlphabetic('f')"
    TEST_CHECK_FALSE Asc_IsAlphabetic(__ASC_3), "NOT Asc_IsAlphabetic('3')"

    TEST_CHECK Asc_IsLowercase(__ASC_LOWER_G), "Asc_IsLowercase('g')"
    TEST_CHECK_FALSE Asc_IsLowercase(__ASC_UPPER_H), "NOT Asc_IsLowercase('H')"
    TEST_CHECK_FALSE Asc_IsLowercase(__ASC_4), "NOT Asc_IsLowercase('4')"

    TEST_CHECK Asc_IsUppercase(__ASC_UPPER_I), "Asc_IsUppercase('I')"
    TEST_CHECK_FALSE Asc_IsUppercase(__ASC_LOWER_J), "NOT Asc_IsUppercase('j')"
    TEST_CHECK_FALSE Asc_IsUppercase(__ASC_5), "NOT Asc_IsUppercase('5')"

    TEST_CHECK Asc_IsDecimalDigit(__ASC_6), "Asc_IsDecimalDigit('6')"
    TEST_CHECK_FALSE Asc_IsDecimalDigit(__ASC_UPPER_A), "NOT Asc_IsDecimalDigit('A')"

    TEST_CHECK Asc_IsHexadecimalDigit(__ASC_7), "Asc_IsHexadecimalDigit('7')"
    TEST_CHECK Asc_IsHexadecimalDigit(__ASC_UPPER_F), "Asc_IsHexadecimalDigit('F')"
    TEST_CHECK Asc_IsHexadecimalDigit(__ASC_LOWER_A), "Asc_IsHexadecimalDigit('a')"
    TEST_CHECK_FALSE Asc_IsHexadecimalDigit(__ASC_UPPER_G), "NOT Asc_IsHexadecimalDigit('G')"

    TEST_CHECK Asc_IsOctalDigit(__ASC_7), "Asc_IsOctalDigit('7')"
    TEST_CHECK_FALSE Asc_IsOctalDigit(__ASC_8), "NOT Asc_IsOctalDigit('8')"

    TEST_CHECK Asc_IsBinaryDigit(__ASC_0), "Asc_IsBinaryDigit('0')"
    TEST_CHECK Asc_IsBinaryDigit(__ASC_1), "Asc_IsBinaryDigit('1')"
    TEST_CHECK_FALSE Asc_IsBinaryDigit(__ASC_2), "NOT Asc_IsBinaryDigit('2')"

    TEST_CHECK Asc_IsControlCharacter(ASC(_CHR_NUL)), "Asc_IsControlCharacter(NUL)"
    TEST_CHECK Asc_IsControlCharacter(ASC(_CHR_DEL)), "Asc_IsControlCharacter(DEL)"
    TEST_CHECK_FALSE Asc_IsControlCharacter(ASC(" ")), "NOT Asc_IsControlCharacter(' ')"

    TEST_CHECK Asc_IsWhitespace(ASC(" ")), "Asc_IsWhitespace(' ')"
    TEST_CHECK Asc_IsWhitespace(ASC(_CHR_HT)), "Asc_IsWhitespace(HT)"
    TEST_CHECK Asc_IsWhitespace(ASC(_CHR_LF)), "Asc_IsWhitespace(LF)"
    TEST_CHECK_FALSE Asc_IsWhitespace(ASC("a")), "NOT Asc_IsWhitespace('a')"

    TEST_CHECK Asc_IsBlank(ASC(" ")), "Asc_IsBlank(' ')"
    TEST_CHECK Asc_IsBlank(ASC(_CHR_HT)), "Asc_IsBlank(HT)"
    TEST_CHECK_FALSE Asc_IsBlank(ASC(_CHR_LF)), "NOT Asc_IsBlank(LF)"

    TEST_CHECK Asc_IsPunctuation(ASC("!")), "Asc_IsPunctuation('!')"
    TEST_CHECK Asc_IsPunctuation(ASC(".")), "Asc_IsPunctuation('.')"
    TEST_CHECK Asc_IsPunctuation(ASC("?")), "Asc_IsPunctuation('?')"
    TEST_CHECK_FALSE Asc_IsPunctuation(ASC("a")), "NOT Asc_IsPunctuation('a')"
    TEST_CHECK_FALSE Asc_IsPunctuation(ASC("1")), "NOT Asc_IsPunctuation('1')"

    TEST_CASE_END

    TEST_CASE_BEGIN "String: C-String Conversion"

    TEST_CHECK String_ToBStr("Hello" + _CHR_NUL + "World") = "Hello", "String_ToBStr should truncate at NUL"
    TEST_CHECK String_ToBStr("NoNulHere") = "NoNulHere", "String_ToBStr should handle strings without NUL"
    TEST_CHECK String_ToCStr("Hello") = "Hello" + _CHR_NUL, "String_ToCStr should append NUL"

    TEST_CASE_END

    TEST_CASE_BEGIN "String: Formatting"

    TEST_CHECK String_FormatString("s='%s'", "test") = "s='test'", "String_FormatString"
    TEST_CHECK String_FormatLong("d=%d", 123) = "d=123", "String_FormatLong"
    TEST_CHECK String_FormatInteger64("i64=%lld", -123456789012345~&&) = "i64=-123456789012345", "String_FormatInteger64"
    TEST_CHECK String_FormatSingle("f=%.2f", 3.14159) = "f=3.14", "String_FormatSingle"
    TEST_CHECK String_FormatDouble("d=%.5f", 2.718281828) = "d=2.71828", "String_FormatDouble"

    TEST_CASE_END
END SUB

SUB Test_Pathname
    TEST_CASE_BEGIN "Pathname"

    $IF WINDOWS THEN
        TEST_CHECK Pathname_IsAbsolute("C:/Windows"), "Pathname_IsAbsolute('C:/Windows')"
        TEST_CHECK Pathname_IsAbsolute("/Windows"), "Pathname_IsAbsolute('/Windows')"
    $ELSE
        TEST_CHECK Pathname_IsAbsolute("/Windows"), "Pathname_IsAbsolute('/Windows')"
    $END IF

    TEST_CHECK_FALSE Pathname_IsAbsolute("Windows"), "Pathname_IsAbsolute('Windows')"
    TEST_CHECK_FALSE Pathname_IsAbsolute(""), "Pathname_IsAbsolute('')"

    $IF WINDOWS THEN
        TEST_CHECK Pathname_AddDirectorySeparator("Windows") = "Windows\", "Pathname_AddDirectorySeparator('Windows')"
    $ELSE
        TEST_CHECK Pathname_AddDirectorySeparator("Windows") = "Windows/", "Pathname_AddDirectorySeparator('Windows')"
    $END IF

    TEST_CHECK Pathname_AddDirectorySeparator("Windows/") = "Windows/", "Pathname_AddDirectorySeparator('Windows/')"
    TEST_CHECK Pathname_AddDirectorySeparator("") = "", "Pathname_AddDirectorySeparator('')"

    $IF WINDOWS THEN
        TEST_CHECK Pathname_FixDirectorySeparators("C:/Windows\\") = "C:\Windows\\", "Pathname_FixDirectorySeparators('C:/Windows\\')"
    $ELSE
        TEST_CHECK Pathname_FixDirectorySeparators("C:/Windows\\") = "C:/Windows//", "Pathname_FixDirectorySeparators('C:/Windows\\')"
    $END IF

    TEST_CHECK Pathname_FixDirectorySeparators("Windows") = "Windows", "Pathname_FixDirectorySeparators('Windows')"
    TEST_CHECK Pathname_FixDirectorySeparators("") = "", "Pathname_FixDirectorySeparators('')"

    TEST_CHECK Pathname_GetFileName("C:\\foo/bar.ext") = "bar.ext", "Pathname_GetFileName('C:\\foo/bar.ext')"
    TEST_CHECK Pathname_GetFileName("bar.ext") = "bar.ext", "Pathname_GetFileName('bar.ext')"
    TEST_CHECK Pathname_GetFileName("") = "", "Pathname_GetFileName('')"

    TEST_CHECK Pathname_GetPath("C:\\foo/bar.ext") = "C:\\foo/", "Pathname_GetPath('C:\\foo/bar.ext')"

    $IF WINDOWS THEN
        TEST_CHECK Pathname_GetPath("\\bar.ext") = "\\", "Pathname_GetPath('\\bar.ext')"
    $ELSE
        TEST_CHECK Pathname_GetPath("//bar.ext") = "//", "Pathname_GetPath('//bar.ext')"
    $END IF

    TEST_CHECK Pathname_GetPath("") = "", "Pathname_GetPath('')"

    TEST_CHECK Pathname_HasFileExtension("C:\\foo/bar.ext"), "Pathname_HasFileExtension('C:\\foo/bar.ext')"
    TEST_CHECK_FALSE Pathname_HasFileExtension("bar.ext/"), "Pathname_HasFileExtension('bar.ext/')"
    TEST_CHECK_FALSE Pathname_HasFileExtension(""), "Pathname_HasFileExtension('')"

    TEST_CHECK Pathname_GetFileExtension("C:\\foo/bar.ext") = ".ext", "Pathname_GetFileExtension('C:\\foo/bar.ext')"
    TEST_CHECK Pathname_GetFileExtension("bar.ext/") = "", "Pathname_GetFileExtension('bar.ext/')"
    TEST_CHECK Pathname_GetFileExtension("") = "", "Pathname_GetFileExtension('')"

    TEST_CHECK Pathname_RemoveFileExtension("C:\\foo/bar.ext") = "C:\\foo/bar", "Pathname_RemoveFileExtension('C:\\foo/bar.ext')"
    TEST_CHECK Pathname_RemoveFileExtension("bar.ext/") = "bar.ext/", "Pathname_RemoveFileExtension('bar.ext/')"
    TEST_CHECK Pathname_RemoveFileExtension("") = "", "Pathname_RemoveFileExtension('')"

    TEST_CHECK Pathname_GetDriveOrScheme("https://www.github.com/") = "https:", "Pathname_GetDriveOrScheme('https://www.github.com/')"
    TEST_CHECK Pathname_GetDriveOrScheme("C:\\Windows\\") = "C:", "Pathname_GetDriveOrScheme('C:\\Windows\\')"
    TEST_CHECK Pathname_GetDriveOrScheme("") = "", "Pathname_GetDriveOrScheme('')"

    TEST_CHECK Pathname_Sanitize("<abracadabra.txt/>") = "_abracadabra.txt__", "Pathname_Sanitize('<abracadabra.txt/>')"
    TEST_CHECK Pathname_Sanitize("") = "", "Pathname_Sanitize('')"

    TEST_CASE_END
END SUB

SUB Test_StringFile
    TEST_CASE_BEGIN "StringFile"

    DIM sf AS StringFile
    StringFile_Create sf, "This_is_a_test_buffer."
    TEST_CHECK LEN(sf.buffer) = 22, "LEN(sf.buffer) = 22"
    TEST_CHECK sf.cursor = 0, "sf.cursor = 0"
    TEST_CHECK StringFile_GetPosition(sf) = 0, "StringFile_GetPosition(sf) = 0"
    TEST_CHECK StringFile_ReadString(sf, 22) = "This_is_a_test_buffer.", "StringFile_ReadString(sf, 22)"
    TEST_CHECK StringFile_GetPosition(sf) = 22, "StringFile_GetPosition(sf) = 22"
    TEST_CHECK StringFile_IsEOF(sf), "StringFile_IsEOF(sf)"
    TEST_CHECK LEN(sf.buffer) = 22, "LEN(sf.buffer) = 22"
    TEST_CHECK sf.cursor = 22, "sf.cursor = 22"
    StringFile_Seek sf, StringFile_GetPosition(sf) - 1
    StringFile_WriteString sf, "! Now adding some more text."
    TEST_CHECK StringFile_GetPosition(sf) = 49, "StringFile_GetPosition(sf) = 49"
    TEST_CHECK StringFile_IsEOF(sf), "StringFile_IsEOF(sf)"
    TEST_CHECK LEN(sf.buffer) = 49, "LEN(sf.buffer) = 49"
    TEST_CHECK sf.cursor = 49, "sf.cursor = 49"
    StringFile_Seek sf, 0
    TEST_CHECK StringFile_GetPosition(sf) = 0, "StringFile_GetPosition(sf) = 0"
    TEST_CHECK_FALSE StringFile_IsEOF(sf), "NOT StringFile_IsEOF(sf)"
    TEST_CHECK LEN(sf.buffer) = 49, "LEN(sf.buffer) = 49"
    TEST_CHECK sf.cursor = 0, "sf.cursor = 0"
    TEST_CHECK StringFile_ReadString(sf, 49) = "This_is_a_test_buffer! Now adding some more text.", "StringFile_ReadString(sf, 49)"
    TEST_CHECK StringFile_GetPosition(sf) = 49, "StringFile_GetPosition(sf) = 49"
    TEST_CHECK StringFile_IsEOF(sf), "StringFile_IsEOF(sf)"
    TEST_CHECK LEN(sf.buffer) = 49, "LEN(sf.buffer) = 49"
    TEST_CHECK sf.cursor = 49, "sf.cursor = 49"
    StringFile_Seek sf, 0
    TEST_CHECK CHR$(StringFile_ReadByte(sf)) = "T", "CHR$(StringFile_ReadByte(sf)) = T"
    TEST_CHECK LEN(sf.buffer) = 49, "LEN(sf.buffer) = 49"
    TEST_CHECK sf.cursor = 1, "sf.cursor = 1"
    StringFile_WriteString sf, "XX"
    TEST_CHECK LEN(sf.buffer) = 49, "LEN(sf.buffer) = 49"
    TEST_CHECK sf.cursor = 3, "sf.cursor = 3"
    TEST_CHECK CHR$(StringFile_ReadByte(sf)) = "s", "CHR$(StringFile_ReadByte(sf)) = s"
    StringFile_Seek sf, 0
    TEST_CHECK StringFile_ReadString(sf, 49) = "TXXs_is_a_test_buffer! Now adding some more text.", "StringFile_ReadString(sf, 49)"
    TEST_CHECK StringFile_GetPosition(sf) = 49, "StringFile_GetPosition(sf) = 49"
    TEST_CHECK StringFile_IsEOF(sf), "StringFile_IsEOF(sf)"
    TEST_CHECK LEN(sf.buffer) = 49, "LEN(sf.buffer) = 49"
    TEST_CHECK sf.cursor = 49, "sf.cursor = 49"
    StringFile_Seek sf, 0
    StringFile_WriteInteger sf, 420
    StringFile_Seek sf, 0
    TEST_CHECK StringFile_ReadInteger(sf) = 420, "StringFile_ReadInteger(sf) = 420"
    TEST_CHECK LEN(sf.buffer) = 49, "LEN(sf.buffer) = 49"
    StringFile_Seek sf, 0
    StringFile_WriteByte sf, 255
    StringFile_Seek sf, 0
    TEST_CHECK StringFile_ReadByte(sf) = 255, "StringFile_ReadByte(sf) = 255"
    TEST_CHECK LEN(sf.buffer) = 49, "LEN(sf.buffer) = 49"
    StringFile_Seek sf, 0
    StringFile_WriteLong sf, 192000
    StringFile_Seek sf, 0
    TEST_CHECK StringFile_ReadLong(sf) = 192000, "StringFile_ReadLong(sf) = 192000"
    TEST_CHECK LEN(sf.buffer) = 49, "LEN(sf.buffer) = 49"
    StringFile_Seek sf, 0
    StringFile_WriteSingle sf, 752.334
    StringFile_Seek sf, 0
    TEST_CHECK StringFile_ReadSingle(sf) = 752.334, "StringFile_ReadSingle(sf) = 752.334"
    TEST_CHECK LEN(sf.buffer) = 49, "LEN(sf.buffer) = 49"
    StringFile_Seek sf, 0
    StringFile_WriteDouble sf, 23232323.242423424#
    StringFile_Seek sf, 0
    TEST_CHECK StringFile_ReadDouble(sf) = 23232323.242423424#, "StringFile_ReadDouble(sf) = 23232323.242423424#"
    TEST_CHECK LEN(sf.buffer) = 49, "LEN(sf.buffer) = 49"
    StringFile_Seek sf, 0
    StringFile_WriteInteger64 sf, 9999999999999999&&
    StringFile_Seek sf, 0
    TEST_CHECK StringFile_ReadInteger64(sf) = 9999999999999999&&, "StringFile_ReadInteger64(sf) = 9999999999999999&&"
    TEST_CHECK LEN(sf.buffer) = 49, "LEN(sf.buffer) = 49"

    TEST_CASE_END
END SUB

SUB Test_InFormUIUtils
    TEST_CASE_BEGIN "InFormUIUtils: Darken"

    TEST_CHECK Darken(0, 0) = &HFF000000~&, "Darken(0, 0) = &HFF000000~&"
    TEST_CHECK Darken(&HFFFFFFFF~&, 0) = &HFF000000~&, "Darken(&HFFFFFFFF~&, 0) = &HFF000000~&"
    TEST_CHECK Darken(&HFFFFFFFF~&, 50) = &HFF808080~&, "Darken(&HFFFFFFFF~&, 50) = &HFF808080~&"
    TEST_CHECK Darken(&HFFFFFFFF~&, 100) = &HFFFFFFFF~&, "Darken(&HFFFFFFFF~&, 100) = &HFFFFFFFF~&"
    TEST_CHECK Darken(&HFF123456~&, 50) = &HFF091A2B~&, "Darken(&HFF123456~&, 50) = &HFF091A2B~&"

    TEST_CASE_END

    TEST_CASE_BEGIN "InFormUIUtils: IsNumber"

    TEST_CHECK IsNumber("123"), "IsNumber('123')"
    TEST_CHECK IsNumber("-123"), "IsNumber('-123')"
    TEST_CHECK IsNumber("123.123"), "IsNumber('123.123')"
    TEST_CHECK IsNumber("-123.123"), "IsNumber('-123.123')"
    TEST_CHECK IsNumber("0"), "IsNumber('0')"
    TEST_CHECK IsNumber("0.0"), "IsNumber('0.0')"
    TEST_CHECK IsNumber(".123"), "IsNumber('.123')"
    TEST_CHECK IsNumber("-.123"), "IsNumber('-.123')"
    TEST_CHECK_FALSE IsNumber("abc"), "IsNumber('abc')"
    TEST_CHECK_FALSE IsNumber("123abc"), "IsNumber('123abc')"
    TEST_CHECK_FALSE IsNumber(""), "IsNumber('')"
    TEST_CHECK_FALSE IsNumber("-"), "IsNumber('-')"
    TEST_CHECK_FALSE IsNumber("."), "IsNumber('.')"
    TEST_CHECK_FALSE IsNumber("192.168.1.1"), "IsNumber('192.168.1.1')"

    TEST_CASE_END

    TEST_CASE_BEGIN "InFormUIUtils: Replace"

    DIM changes AS LONG

    TEST_CHECK Replace("", "x", "y", _TRUE, changes) = "", "Empty source string"
    TEST_CHECK changes = 0, "No replacements expected"

    TEST_CHECK Replace("abc", "", "x", _TRUE, changes) = "abc", "Empty target string"
    TEST_CHECK changes = 0, "No replacements expected"

    TEST_CHECK Replace("abcabc", "b", "", _TRUE, changes) = "acac", "Remove 'b' from string"
    TEST_CHECK changes = 2, "Two replacements"

    TEST_CHECK Replace("Hello World", "world", "Universe", _TRUE, changes) = "Hello World", "No match due to case"
    TEST_CHECK changes = 0, "No replacements"

    TEST_CHECK Replace("Hello World", "xyz", "Universe", _FALSE, changes) = "Hello World", "No match at all"
    TEST_CHECK changes = 0, "No replacements"

    TEST_CHECK Replace("Hello World", "World", "Universe", _TRUE, changes) = "Hello Universe", "Single match"
    TEST_CHECK changes = 1, "One replacement"

    TEST_CHECK Replace("Hello World", "world", "Universe", _FALSE, changes) = "Hello Universe", "Single match (case-insensitive)"
    TEST_CHECK changes = 1, "One replacement"

    TEST_CHECK Replace("abcabcabc", "abc", "x", _TRUE, changes) = "xxx", "Multiple matches"
    TEST_CHECK changes = 3, "Three replacements"

    TEST_CHECK Replace("aaaa", "aa", "x", _TRUE, changes) = "xx", "Overlapping match"
    TEST_CHECK changes = 2, "Two replacements"

    TEST_CHECK Replace("abc", "b", "BIGGER", _TRUE, changes) = "aBIGGERc", "Longer replacement"
    TEST_CHECK changes = 1, "One replacement"

    TEST_CHECK Replace("abc", "bc", "x", _TRUE, changes) = "ax", "Shorter replacement"
    TEST_CHECK changes = 1, "One replacement"

    TEST_CHECK Replace("a\\b\\c", "\b", "X", _TRUE, changes) = "a\\b\\c", "Escape rule: skip replacement"
    TEST_CHECK changes = 0, "No replacements"

    TEST_CHECK Replace("a\b\c", "\b", "X", _TRUE, changes) = "aX\c", "Escape rule: single match"
    TEST_CHECK changes = 1, "One replacement"

    TEST_CHECK Replace("abc", "abc", "xyz", _TRUE, changes) = "xyz", "Whole string replaced"
    TEST_CHECK changes = 1, "One replacement"

    TEST_CHECK Replace("abcde", "abc", "X", _TRUE, changes) = "Xde", "Prefix match"
    TEST_CHECK changes = 1, "One replacement"

    TEST_CHECK Replace("abcde", "de", "X", _TRUE, changes) = "abcX", "Suffix match"
    TEST_CHECK changes = 1, "One replacement"

    TEST_CHECK Replace("abcde", "cd", "X", _TRUE, changes) = "abXe", "Middle match"
    TEST_CHECK changes = 1, "One replacement"

    TEST_CHECK Replace("abcABCabc", "abc", "X", _FALSE, changes) = "XXX", "Case-insensitive multiple"
    TEST_CHECK changes = 3, "Three replacements"

    TEST_CHECK Replace("abcABCabc", "abc", "X", _TRUE, changes) = "XABCX", "Case-sensitive partial"
    TEST_CHECK changes = 2, "Two replacements"

    TEST_CASE_END
END SUB

SUB Test_InFormUIHelpers
    TEST_CASE_BEGIN "InFormUIHelpers: __UI_CountLines"

    TEST_CHECK __UI_CountLines(0) = 0, "Empty string"
    Text(0) = _CHR_LF
    TEST_CHECK __UI_CountLines(0) = 1, "One line"
    Text(0) = "Line 1" + _CHR_LF + "Line 2" + _CHR_LF + "Line 3"
    TEST_CHECK __UI_CountLines(0) = 3, "Three lines"
    Text(0) = "Line 1" + _CHR_LF + "Line 2" + _CHR_LF + "Line 3" + _CHR_LF
    TEST_CHECK __UI_CountLines(0) = 3, "Three lines"
    Text(0) = _CHR_LF + "Line 1" + _CHR_LF + "Line 2" + _CHR_LF + "Line 3"
    TEST_CHECK __UI_CountLines(0) = 4, "Four lines"

    TEST_CASE_END

    TEST_CASE_BEGIN "InFormUIHelpers: __UI_GetTextBoxLine"

    DIM startPos AS LONG

    Text(0) = _CHR_LF + "Line 1" + _CHR_LF + "Line 2" + _CHR_LF + "Line 3"

    TEST_CHECK __UI_GetTextBoxLine(0, 0, startPos) = "", "Empty string"
    TEST_CHECK startPos = 0, "Expected 0"

    TEST_CHECK __UI_GetTextBoxLine(0, 1, startPos) = Text(0), "Complete string"
    TEST_CHECK startPos = 1, "Expected 1"

    TEST_CHECK __UI_GetTextBoxLine(0, 2, startPos) = "", "Empty string"
    TEST_CHECK startPos = 0, "Expected 0"

    Control(0).Multiline = _TRUE

    TEST_CHECK __UI_GetTextBoxLine(0, 0, startPos) = "", "Empty string"
    TEST_CHECK startPos = 0, "Expected 0"

    TEST_CHECK __UI_GetTextBoxLine(0, 1, startPos) = "", "Empty line"
    TEST_CHECK startPos = 1, "Expected 1"

    TEST_CHECK __UI_GetTextBoxLine(0, 2, startPos) = "Line 1", "Line 1"
    TEST_CHECK startPos = 2, "Expected 2"

    TEST_CHECK __UI_GetTextBoxLine(0, 3, startPos) = "Line 2", "Line 2"
    TEST_CHECK startPos = 9, "Expected 9"

    TEST_CHECK __UI_GetTextBoxLine(0, 4, startPos) = "Line 3", "Line 3"
    TEST_CHECK startPos = 16, "Expected 16"

    TEST_CHECK __UI_GetTextBoxLine(0, 5, startPos) = "", "Empty string"
    TEST_CHECK startPos = 0, "Expected 0"

    TEST_CASE_END

    TEST_CASE_BEGIN "InFormUIHelpers: __UI_TrimAt0"

    TEST_CHECK __UI_TrimAt0("hello" + _CHR_NUL + "world") = "hello", "Expected 'hello'"

    TEST_CASE_END

    TEST_CASE_BEGIN "InFormUIHelpers: RawText$ and __UI_EmptyMask$"

    Mask(0) = ""
    Text(0) = "plaintext"
    TEST_CHECK RawText$(0) = "plaintext", "RawText$ returns full text when no mask"

    Mask(0) = "00-00"
    Text(0) = "12-34"
    TEST_CHECK RawText$(0) = "1234", "RawText$ should return placeholder characters concatenated"

    Mask(0) = "00-00"
    Text(0) = "__-5_"
    TEST_CHECK RawText$(0) = "  5 ", "RawText$ should convert underscores to spaces for empty placeholders"

    Mask(0) = "00-00"
    TEST_CHECK __UI_EmptyMask$(0) = "__-__", "__UI_EmptyMask$ should produce placeholder underscores"

    TEST_CASE_END

    TEST_CASE_BEGIN "InFormUIHelpers: RawText$ additional cases"

    Mask(0) = "9#0#"
    Text(0) = "1a2b"
    TEST_CHECK RawText$(0) = "1a2b", "RawText$ should return characters for placeholder positions (including non-digits)"

    Mask(0) = "0000"
    Text(0) = "12"
    TEST_CHECK RawText$(0) = "12", "RawText$ should return only existing placeholder characters when Text is shorter than mask"

    Mask(0) = "(000) 000-0000"
    Text(0) = "(123) 456-7890"
    TEST_CHECK RawText$(0) = "1234567890", "RawText$ should extract digits into a contiguous string for phone mask"

    Mask(0) = "ABC"
    TEST_CHECK __UI_EmptyMask$(0) = "ABC", "__UI_EmptyMask$ should return literal mask when no placeholders"

    Mask(0) = ""
    TEST_CHECK __UI_EmptyMask$(0) = "", "__UI_EmptyMask$ should return empty string when mask is empty"

    TEST_CASE_END

    TEST_CASE_BEGIN "InFormUIHelpers: 1-char RawText$ and __UI_EmptyMask$"

    Mask(0) = "0"
    Text(0) = "5"
    TEST_CHECK RawText$(0) = "5", "RawText$ should return single placeholder digit"

    Mask(0) = "0"
    Text(0) = "_"
    TEST_CHECK RawText$(0) = " ", "RawText$ should convert single underscore to space"

    Mask(0) = "0"
    TEST_CHECK __UI_EmptyMask$(0) = "_", "__UI_EmptyMask$ should return single underscore for single placeholder"

    Mask(0) = ""
    TEST_CHECK __UI_EmptyMask$(0) = "", "__UI_EmptyMask$ should return empty string for empty mask"

    TEST_CASE_END

    TEST_CASE_BEGIN "InFormUIHelpers: RestoreCHR$"

    TEST_CHECK RestoreCHR$("Hello\65;World") = "HelloAWorld", "RestoreCHR$ should convert \65; to 'A'"

    TEST_CHECK RestoreCHR$("\65;\66;\67;") = CHR$(65) + CHR$(66) + CHR$(67), "Multiple numeric escapes converted"

    TEST_CHECK RestoreCHR$("\\65;") = "\65;", "Double backslash should collapse to single backslash and leave number unprocessed"

    DIM tmp$: tmp$ = "X\6a;Y"
    TEST_CHECK RestoreCHR$(tmp$) = tmp$, "Malformed numeric escape should be left untouched"
    TEST_CHECK tmp$ = "X\6a;Y", "Malformed numeric escape should be left untouched"

    TEST_CHECK ASC(RestoreCHR$("\0;"), 1) = 0, "RestoreCHR$ should produce CHR$(0) for \0;"
    TEST_CHECK ASC(RestoreCHR$("\65;"), 1) = 65, "RestoreCHR$ should produce CHR$(65) for \65;"

    TEST_CASE_END
END SUB

SUB Test_InFormUIUnicodeUtils
    TEST_CASE_BEGIN "InFormUIUnicodeUtils: FromCP437"

    TEST_CHECK FromCP437("Hello, World!") = "Hello, World!", "Expected 'Hello, World!'"

    TEST_CASE_END

    TEST_CASE_BEGIN "InFormUIUnicodeUtils: FromCP1252"

    TEST_CHECK FromCP1252("Hello, world!") = "Hello, world!", "Expected 'Hello, world!'"

    TEST_CASE_END

    DIM textLen AS LONG: textLen = 64
    DIM iterations AS LONG: iterations = 65536

    DIM i AS LONG, text AS STRING, result AS STRING

    text = SPACE$(textLen)

    FOR i = 1 TO textLen
        ASC(text, i) = RND * 256
    NEXT i

    TEST_CASE_BEGIN "InFormUIUnicodeUtils: FromCP437 performance," + STR$(textLen) + " characters" + STR$(iterations) + " iterations"

    FOR i = 1 TO iterations
        result = FromCP437(text)
    NEXT i

    TEST_CASE_END

    TEST_CASE_BEGIN "InFormUIUnicodeUtils: FromCP1252 performance," + STR$(textLen) + " characters" + STR$(iterations) + " iterations"

    FOR i = 1 TO iterations
        result = FromCP1252(text)
    NEXT i

    TEST_CASE_END

    textLen = 65536
    iterations = 64

    text = SPACE$(textLen)

    FOR i = 1 TO textLen
        ASC(text, i) = RND * 256
    NEXT i

    TEST_CASE_BEGIN "InFormUIUnicodeUtils: FromCP437 performance," + STR$(textLen) + " characters" + STR$(iterations) + " iterations"

    FOR i = 1 TO iterations
        result = FromCP437(text)
    NEXT i

    TEST_CASE_END

    TEST_CASE_BEGIN "InFormUIUnicodeUtils: FromCP1252 performance," + STR$(textLen) + " characters" + STR$(iterations) + " iterations"

    FOR i = 1 TO iterations
        result = FromCP1252(text)
    NEXT i

    TEST_CASE_END
END SUB

SUB Test_INI_Manager
    TEST_CASE_BEGIN "INI-Manager"

    DIM i AS LONG: i = FREEFILE
    OPEN "test.ini" FOR OUTPUT AS #i
    PRINT #i, "[Section1]"
    PRINT #i, "Key1=Value1"
    PRINT #i, "Key2=Value2"
    PRINT #i,
    PRINT #i, "[Section2]"
    PRINT #i, "Key3=Value3";
    CLOSE #i

    Ini_WriteSetting "test.ini", "Section1", "Key1", "NewValue1"
    TEST_CHECK Ini_GetCode = INI_INFO_KEY_UPDATED, "Ini_WriteSetting should update an existing key"
    TEST_CHECK Ini_ReadSetting("", "Section1", "Key1") = "NewValue1", "Ini_ReadSetting should return the new value"

    Ini_WriteSetting "", "Section1", "NewKey", "NewValue"
    TEST_CHECK Ini_GetCode = INI_INFO_KEY_CREATED_EXISTING_SECTION, "Ini_WriteSetting should create a new key in an existing section"
    TEST_CHECK Ini_ReadSetting("", "Section1", "NewKey") = "NewValue", "Ini_ReadSetting should return the new value"

    Ini_WriteSetting "", "NewSection", "NewKey", "NewValue"
    TEST_CHECK Ini_GetCode = INI_INFO_NEW_SECTION_KEY_CREATED, "Ini_WriteSetting should create a new section and key"
    TEST_CHECK Ini_ReadSetting("", "NewSection", "NewKey") = "NewValue", "Ini_ReadSetting should return the new value"

    TEST_CHECK Ini_ReadSetting("", "Section1", "Key2") = "Value2", "Ini_ReadSetting should return the correct value"
    TEST_CHECK Ini_GetCode = INI_INFO_SUCCESS, "Ini_GetCode should be success"
    TEST_CHECK Ini_ReadSetting("", "Section2", "Key3") = "Value3", "Ini_ReadSetting should return the correct value"

    DIM value AS STRING
    Ini_DeleteKey "", "Section1", "NewKey"
    TEST_CHECK Ini_GetCode = INI_INFO_KEY_DELETED, "Ini_DeleteKey should delete a key"
    value = Ini_ReadSetting("", "Section1", "NewKey")
    TEST_CHECK Ini_GetCode = INI_INFO_KEY_NOT_FOUND, "Ini_ReadSetting should not find the deleted key"

    Ini_DeleteSection "", "NewSection"
    TEST_CHECK Ini_GetCode = INI_INFO_SECTION_DELETED, "Ini_DeleteSection should delete a section"
    value = Ini_ReadSetting("", "NewSection", "NewKey")
    TEST_CHECK Ini_GetCode = INI_INFO_SECTION_NOT_FOUND, "Ini_ReadSetting should not find the deleted section"

    Ini_WriteSetting "", "Section2", "A_Key", "A_Value"
    Ini_SortSection "", "Section2"
    TEST_CHECK Ini_GetCode = INI_INFO_SECTION_SORTED, "Ini_SortSection should sort the section"
    value = Ini_ReadSetting("", "Section2", "")
    TEST_CHECK Ini_GetLastKey = "A_Key", "First key in sorted section should be A_Key"
    value = Ini_ReadSetting("", "Section2", "")
    TEST_CHECK Ini_GetLastKey = "Key3", "Second key in sorted section should be Key3"

    Ini_MoveKey "", "Section2", "A_Key", "Section1"
    TEST_CHECK Ini_GetCode = INI_INFO_KEY_MOVED, "Ini_MoveKey should move the key"
    value = Ini_ReadSetting("", "Section2", "A_Key")
    TEST_CHECK Ini_GetCode = INI_INFO_KEY_NOT_FOUND, "Ini_ReadSetting should not find the moved key in the old section"
    TEST_CHECK Ini_ReadSetting("", "Section1", "A_Key") = "A_Value", "Ini_ReadSetting should find the moved key in the new section"

    KILL "test.ini"

    TEST_CASE_END

    TEST_CASE_BEGIN "INI_Manager: Ini_Release"

    DIM releaseFile AS LONG
    releaseFile = FREEFILE
    OPEN "release.ini" FOR OUTPUT AS #releaseFile
    PRINT #releaseFile, "[S]"
    PRINT #releaseFile, "K=first"
    CLOSE #releaseFile

    TEST_CHECK Ini_ReadSetting("release.ini", "S", "K") = "first", "Value is read"
    Ini_Release "release.ini"
    Ini_Release "release.ini" ' releasing twice is harmless

    releaseFile = FREEFILE
    OPEN "release.ini" FOR OUTPUT AS #releaseFile
    PRINT #releaseFile, "[S]"
    PRINT #releaseFile, "K=second"
    CLOSE #releaseFile

    TEST_CHECK Ini_ReadSetting("release.ini", "S", "K") = "second", "Released file is read from disk again"
    Ini_Release "release.ini"
    KILL "release.ini"

    TEST_CASE_END
END SUB

SUB Test_Theme
    DIM c AS _UNSIGNED LONG

    TEST_CASE_BEGIN "Theme: __UI_Theme_ParseColor"

    TEST_CHECK __UI_Theme_ParseColor("FF8000", c), "RRGGBB"
    TEST_CHECK c = _RGB32(255, 128, 0), "RRGGBB value"
    TEST_CHECK __UI_Theme_ParseColor("#ff8000", c), "#rrggbb"
    TEST_CHECK c = _RGB32(255, 128, 0), "#rrggbb value"
    TEST_CHECK __UI_Theme_ParseColor("10203040", c), "RRGGBBAA"
    TEST_CHECK c = _RGBA32(16, 32, 48, 64), "RRGGBBAA value"
    TEST_CHECK __UI_Theme_ParseColor(" 255, 128, 0 ", c), "R,G,B"
    TEST_CHECK c = _RGB32(255, 128, 0), "R,G,B value"
    TEST_CHECK __UI_Theme_ParseColor("1,2,3,4", c), "R,G,B,A"
    TEST_CHECK c = _RGBA32(1, 2, 3, 4), "R,G,B,A value"
    TEST_CHECK_FALSE __UI_Theme_ParseColor("", c), "Empty"
    TEST_CHECK_FALSE __UI_Theme_ParseColor("GG0000", c), "Bad hex digit"
    TEST_CHECK_FALSE __UI_Theme_ParseColor("12345", c), "Bad hex length"
    TEST_CHECK_FALSE __UI_Theme_ParseColor("1,2", c), "Too few components"
    TEST_CHECK_FALSE __UI_Theme_ParseColor("300,0,0", c), "Component out of range"
    TEST_CHECK_FALSE __UI_Theme_ParseColor("1,2,3,4,5", c), "Too many components"

    TEST_CASE_END

    TEST_CASE_BEGIN "Theme: built-in themes"

    SetTheme "dark"
    TEST_CHECK GetTheme$ = "dark", "GetTheme$ returns the theme set"
    TEST_CHECK __UI_Theme.Style = __UI_ThemeStyle_Flat, "Dark is a flat theme"
    TEST_CHECK GetThemeColor(__UI_ThemeColor_WindowBack) = _RGB32(32, 32, 32), "Dark window color"
    TEST_CHECK __UI_DefaultColor(__UI_Type_TextBox, 2) = GetThemeColor(__UI_ThemeColor_InputBack), "Text boxes use the input back color"
    TEST_CHECK __UI_ScrollbarWidth = __UI_Theme.ScrollbarWidth, "Metrics are applied"

    SetTheme "this-theme-does-not-exist.ini"
    TEST_CHECK GetTheme$ = "dark", "An invalid theme keeps the current one"
    TEST_CHECK GetThemeColor(__UI_ThemeColor_WindowBack) = _RGB32(32, 32, 32), "Palette is kept after an invalid theme"

    SetTheme "XP"
    TEST_CHECK __UI_Theme.Style = __UI_ThemeStyle_Bitmap, "XP is a bitmap theme"
    TEST_CHECK __UI_DefaultColor(__UI_Type_Form, 2) = _RGB32(235, 233, 237), "XP form color is unchanged"
    TEST_CHECK __UI_DefaultColor(__UI_Type_Form, 6) = _RGB32(255, 255, 225), "XP tool tip color is unchanged"

    TEST_CASE_END

    TEST_CASE_BEGIN "Theme: theme files"

    DIM f AS LONG: f = FREEFILE
    OPEN "theme_test.ini" FOR OUTPUT AS #f
    PRINT #f, "[Theme]"
    PRINT #f, "Name=Test theme"
    PRINT #f, "Base=dark"
    PRINT #f, "[Colors]"
    PRINT #f, "Accent=112233"
    PRINT #f, "Border=" + CHR$(34) + "#445566" + CHR$(34)
    PRINT #f, "Caret=not a color"
    PRINT #f, "FocusRing=0A0B0C   ; inline comment"
    PRINT #f, "; Accent=FFFFFF (commented out)"
    PRINT #f, "[Metrics]"
    PRINT #f, "CornerRadius=7"
    CLOSE #f

    SetTheme "theme_test.ini"
    TEST_CHECK GetTheme$ = "theme_test.ini", "Theme file is loaded"
    TEST_CHECK RTRIM$(__UI_Theme.Name) = "Test theme", "Name is read"
    TEST_CHECK __UI_Theme.Style = __UI_ThemeStyle_Flat, "Style is inherited from the base"
    TEST_CHECK GetThemeColor(__UI_ThemeColor_Accent) = _RGB32(17, 34, 51), "Color without #"
    TEST_CHECK GetThemeColor(__UI_ThemeColor_Border) = _RGB32(68, 85, 102), "Quoted color with #"
    TEST_CHECK GetThemeColor(__UI_ThemeColor_Caret) = _RGB32(240, 240, 240), "Invalid color keeps the base value"
    TEST_CHECK GetThemeColor(__UI_ThemeColor_FocusRing) = _RGB32(10, 11, 12), "Color with a comment"
    TEST_CHECK GetThemeColor(__UI_ThemeColor_WindowBack) = _RGB32(32, 32, 32), "Missing color is inherited"
    TEST_CHECK __UI_Theme.CornerRadius = 7, "Metric is read"

    ' The file is not kept open, and changes are picked up when the theme is set again
    f = FREEFILE
    OPEN "theme_test.ini" FOR OUTPUT AS #f
    PRINT #f, "[Theme]"
    PRINT #f, "Base=dark"
    PRINT #f, "[Colors]"
    PRINT #f, "Accent=AABBCC"
    CLOSE #f
    SetTheme "theme_test.ini"
    TEST_CHECK GetThemeColor(__UI_ThemeColor_Accent) = _RGB32(170, 187, 204), "Changed file is read again"

    KILL "theme_test.ini"
    SetTheme "xp"

    TEST_CASE_END

    TEST_CASE_BEGIN "Theme: switching keeps custom colors"

    DIM b1 AS LONG, b2 AS LONG
    b1 = __UI_NewControl(__UI_Type_Button, "ThemeTestButton1", 80, 23, 0, 0, 0)
    b2 = __UI_NewControl(__UI_Type_Button, "ThemeTestButton2", 80, 23, 0, 0, 0)
    Control(b2).ForeColor = _RGB32(255, 0, 0)

    SetTheme "dark"
    TEST_CHECK Control(b1).ForeColor = GetThemeColor(__UI_ThemeColor_ButtonText), "Default color follows the theme"
    TEST_CHECK Control(b1).BorderColor = GetThemeColor(__UI_ThemeColor_Border), "Default border follows the theme"
    TEST_CHECK Control(b2).ForeColor = _RGB32(255, 0, 0), "Custom color is kept"

    SetThemeColor __UI_ThemeColor_Border, _RGB32(1, 2, 3)
    TEST_CHECK Control(b1).BorderColor = _RGB32(1, 2, 3), "SetThemeColor updates controls"

    SetTheme "xp"
    TEST_CHECK Control(b1).ForeColor = _RGB32(0, 0, 0), "Back to XP"
    TEST_CHECK Control(b2).ForeColor = _RGB32(255, 0, 0), "Custom color is still kept"

    __UI_DestroyControl Control(b1)
    __UI_DestroyControl Control(b2)

    TEST_CASE_END
END SUB

SUB Test_TabControl
    DIM t AS LONG, c1 AS LONG, c2 AS LONG, c3 AS LONG

    TEST_CASE_BEGIN "TabControl: tabs"

    t = __UI_NewControl(__UI_Type_TabControl, "TestTabs", 200, 120, 0, 0, 0)
    TEST_CHECK __UI_IsContainer(Control(t).Type), "TabControl is a container"
    TEST_CHECK __UI_IsContainer(__UI_Type_Frame), "Frame is a container"
    TEST_CHECK_FALSE __UI_IsContainer(__UI_Type_Button), "Button is not a container"
    TEST_CHECK GetTabCount(t) = 0, "No tabs yet"

    AddTab t, "One"
    AddTab t, "Two"
    AddTab t, "Three"
    TEST_CHECK GetTabCount(t) = 3, "Three tabs"
    TEST_CHECK Control(t).Value = 1, "First tab is active"
    TEST_CHECK GetTabCaption(t, 2) = "Two", "Caption of tab 2"
    TEST_CHECK GetTabCaption(t, 4) = "", "Caption of a missing tab"

    SetTabCaption t, 2, "Second"
    TEST_CHECK GetTabCaption(t, 2) = "Second", "Caption changed"

    DIM tabX AS INTEGER, tabW AS INTEGER, strip AS INTEGER
    strip = __UI_TabStripHeight(t)
    __UI_TabMetrics t, 2, tabX, tabW
    TEST_CHECK tabX > 2 _ANDALSO tabW > 20, "Tab 2 comes after tab 1"
    TEST_CHECK __UI_TabAtPoint(t, 3, strip \ 2) = 1, "Point on tab 1"
    TEST_CHECK __UI_TabAtPoint(t, tabX + tabW \ 2, strip \ 2) = 2, "Point on tab 2"
    TEST_CHECK __UI_TabAtPoint(t, tabX + tabW \ 2, strip + 5) = 0, "Point below the strip"
    TEST_CHECK __UI_TabAtPoint(t, 199, strip \ 2) = 0, "Point right of the last tab"

    SetActiveTab t, 3
    TEST_CHECK Control(t).Value = 3, "Tab 3 is active"
    SetActiveTab t, 9
    TEST_CHECK Control(t).Value = 3, "Invalid tab is ignored"
    SetActiveTab t, 1

    TEST_CASE_END

    TEST_CASE_BEGIN "TabControl: pages"

    c1 = __UI_NewControl(__UI_Type_Button, "TestTabChild1", 80, 23, 10, 40, t)
    c2 = __UI_NewControl(__UI_Type_Button, "TestTabChild2", 80, 23, 10, 40, t)
    c3 = __UI_NewControl(__UI_Type_Label, "TestTabChild3", 80, 23, 10, 80, t)
    TEST_CHECK Control(c1).TabPage = 1, "New child goes to the active tab"
    SetControlTab c2, 2
    SetControlTab c3, 0

    TEST_CHECK_FALSE __UI_IsOnHiddenTab(c1), "Child on active tab is visible"
    TEST_CHECK __UI_IsOnHiddenTab(c2), "Child on another tab is hidden"
    TEST_CHECK_FALSE __UI_IsOnHiddenTab(c3), "Child on every tab is visible"
    TEST_CHECK_FALSE __UI_IsOnHiddenTab(t), "TabControl itself is never on a tab"

    SetActiveTab t, 2
    TEST_CHECK __UI_IsOnHiddenTab(c1), "Tab 1 child hidden after switching"
    TEST_CHECK_FALSE __UI_IsOnHiddenTab(c2), "Tab 2 child visible after switching"
    TEST_CHECK_FALSE __UI_IsOnHiddenTab(c3), "Every-tab child still visible"

    TEST_CASE_END

    TEST_CASE_BEGIN "TabControl: removing tabs"

    RemoveTab t, 1
    TEST_CHECK GetTabCount(t) = 2, "Two tabs left"
    TEST_CHECK GetTabCaption(t, 1) = "Second", "Remaining tabs shift"
    TEST_CHECK Control(t).Value = 1, "Active tab follows its tab"
    TEST_CHECK Control(c1).Hidden, "Child of the removed tab is hidden"
    TEST_CHECK Control(c2).TabPage = 1, "Child of a later tab moves back"
    TEST_CHECK_FALSE __UI_IsOnHiddenTab(c2), "Moved child is still on the active tab"

    RemoveTab t, 2
    RemoveTab t, 1
    TEST_CHECK GetTabCount(t) = 0, "No tabs left"
    TEST_CHECK Control(t).Value = 0, "No active tab"

    __UI_DestroyControl Control(c1)
    __UI_DestroyControl Control(c2)
    __UI_DestroyControl Control(c3)
    __UI_DestroyControl Control(t)

    TEST_CASE_END
END SUB

SUB __UI_LoadForm: END SUB
SUB __UI_AssignIDs: END SUB
SUB __UI_OnLoad: END SUB
SUB __UI_BeforeUnload: END SUB
SUB __UI_BeforeUpdateDisplay: END SUB
SUB __UI_FormResized: END SUB
SUB __UI_ValueChanged (id AS LONG): id = id: END SUB
SUB __UI_TextChanged (id AS LONG): id = id: END SUB
SUB __UI_MouseEnter (id AS LONG): id = id: END SUB
SUB __UI_MouseLeave (id AS LONG): id = id: END SUB
SUB __UI_FocusIn (id AS LONG): id = id: END SUB
SUB __UI_FocusOut (id AS LONG): id = id: END SUB
SUB __UI_KeyPress (id AS LONG): id = id: END SUB
SUB __UI_MouseDown (id AS LONG): id = id: END SUB
SUB __UI_MouseUp (id AS LONG): id = id: END SUB
SUB __UI_Click (id AS LONG): id = id: END SUB

'$INCLUDE:'../InForm/InForm.ui'

'$INCLUDE:'../InForm/extensions/StringFile.bm'
'$INCLUDE:'../InForm/extensions/String.bm'
'$INCLUDE:'../InForm/extensions/Stack.bm'
'$INCLUDE:'../InForm/extensions/Queue.bm'
'$INCLUDE:'../InForm/extensions/Pathname.bm'
'$INCLUDE:'../InForm/extensions/LList.bm'
'$INCLUDE:'../InForm/extensions/Ini.bm'
'$INCLUDE:'../InForm/extensions/HSet.bm'
'$INCLUDE:'../InForm/extensions/HMap64.bm'
'$INCLUDE:'../InForm/extensions/HMap.bm'
'$INCLUDE:'../InForm/extensions/Array.bm'
'$INCLUDE:'../InForm/extensions/Algo.bm'

'$INCLUDE:'../InForm/extensions/Catch.bm'
