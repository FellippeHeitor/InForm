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
'$INCLUDE:'../InForm/extensions/Sort.bi'
'$INCLUDE:'../InForm/extensions/Stack.bi'
'$INCLUDE:'../InForm/extensions/String.bi'
'$INCLUDE:'../InForm/extensions/StringFile.bi'
'$INCLUDE:'../InForm/extensions/Timer.bi'

'$INCLUDE:'../InForm/InForm.bi'

'Counts the __UI_ValueChanged events fired while a test runs (see Test_PropertyGrid)
DIM SHARED TestValueChangedCount AS LONG, TestValueChangedID AS LONG

SUB __UI_BeforeInit
    TEST_BEGIN_ALL

    Test_Catch
    Test_Sort
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
    Test_DropdownSearch
    Test_ReorderableList
    Test_Anchors
    Test_InFormUIUnicodeUtils
    Test_Theme
    Test_TabControl
    Test_Timer
    Test_PropertyGrid
    Test_DataGrid
    Test_DataGridScrolling
    Test_DataGridDefinitions
    Test_DataGridCSV

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

SUB Test_Sort
    TEST_CASE_BEGIN "Algo: Basic Sort"
    DIM strArr(0 TO 4) AS STRING
    strArr(0) = "banana"
    strArr(1) = "apple"
    strArr(2) = "orange"
    strArr(3) = "pear"
    strArr(4) = "kiwi"
    TEST_REQUIRE Sort_StringArray(strArr()), "Algo_SortStringArray should return TRUE for an unsorted array"
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
    TEST_REQUIRE_FALSE Sort_StringArray(sortedArr()), "Algo_SortStringArray should return FALSE for a sorted array"
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
    TEST_REQUIRE Sort_StringArray(reverseArr()), "Algo_SortStringArray should return TRUE for a reverse-sorted array"
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
    TEST_REQUIRE Sort_StringArray(dupArr()), "Algo_SortStringArray should return TRUE for an array with duplicates"
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
    TEST_REQUIRE Sort_StringArray(emptyArr()), "Algo_SortStringArray should return TRUE for an array with empty strings"
    TEST_CHECK emptyArr(0) = "", "Sorted array with empty strings element 0"
    TEST_CHECK emptyArr(1) = "", "Sorted array with empty strings element 1"
    TEST_CHECK emptyArr(2) = "alpha", "Sorted array with empty strings element 2"
    TEST_CHECK emptyArr(3) = "beta", "Sorted array with empty strings element 3"
    TEST_CASE_END

    TEST_CASE_BEGIN "Algo: Single Element"
    DIM singleArr(0 TO 0) AS STRING
    singleArr(0) = "lonely"
    TEST_REQUIRE_FALSE Sort_StringArray(singleArr()), "Algo_SortStringArray should return FALSE for a single-element array"
    TEST_CHECK singleArr(0) = "lonely", "Single element array should remain unchanged"
    TEST_CASE_END

    TEST_CASE_BEGIN "Algo: Empty Array"
    DIM zeroArr(0) AS STRING
    TEST_REQUIRE_FALSE Sort_StringArray(zeroArr()), "Algo_SortStringArray should return FALSE for an empty array"
    TEST_CASE_END

    TEST_CASE_BEGIN "Algo: Sort Range"
    DIM rangeArr(0 TO 5) AS STRING
    rangeArr(0) = "z"
    rangeArr(1) = "e"
    rangeArr(2) = "d"
    rangeArr(3) = "c"
    rangeArr(4) = "b"
    rangeArr(5) = "a"
    TEST_REQUIRE Sort_StringArrayRange(rangeArr(), 1, 4, _TRUE, _TRUE), "Algo_SortStringArrayRange should return TRUE for an unsorted range"
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
    TEST_REQUIRE_FALSE Sort_StringArrayRange(sortedRangeArr(), 1, 2, _TRUE, _TRUE), "Algo_SortStringArrayRange should return FALSE for a sorted range"
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
    TEST_CHECK Sort_StringArray(numArr()), "Algo_SortStringArray should return TRUE for a reverse-sorted array"
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
    TEST_CASE_BEGIN "InFormUIHelpers: multiline textbox layout"

    'Built-in font 8 is 8 pixels per character; no border and no padding,
    'so an 80-pixel-wide box fits 10 characters per line
    DIM AS LONG tb, lineH, testImage, prevDest, prevIndent, prevScrollbar
    prevDest = _DEST
    testImage = _NEWIMAGE(320, 240, 32)
    _DEST testImage
    prevIndent = __UI_DefaultCaptionIndent: __UI_DefaultCaptionIndent = 0
    prevScrollbar = __UI_ScrollbarWidth: __UI_ScrollbarWidth = 16

    tb = __UI_NewControl(__UI_Type_TextBox, "TestMultilineTB", 80, 200, 0, 0, 0)
    Control(tb).Multiline = _TRUE
    Control(tb).Font = 8
    Control(tb).HasBorder = _FALSE
    lineH = __UI_TBLineHeight(tb)

    Text(tb) = ""
    TEST_CHECK __UI_TBCountLines(tb) = 1, "Empty text is one line"
    TEST_CHECK __UI_TBLineStart(1) = 0 _ANDALSO __UI_TBLineLen(1) = 0, "Empty line"

    Text(tb) = "hello world foo"
    TEST_CHECK __UI_TBCountLines(tb) = 2, "Wraps at a space"
    TEST_CHECK __UI_TBLineStart(1) = 0 _ANDALSO __UI_TBLineLen(1) = 6, "First line keeps its trailing space"
    TEST_CHECK __UI_TBLineStart(2) = 6 _ANDALSO __UI_TBLineLen(2) = 9, "Second line"
    TEST_CHECK_FALSE __UI_TBNeedsScrollbar, "Everything fits"
    TEST_CHECK __UI_TBLineFromPos(tb, 5) = 1, "Position on line 1"
    TEST_CHECK __UI_TBLineFromPos(tb, 6) = 2, "Wrap position belongs to the next line"
    TEST_CHECK __UI_TBLineFromPos(tb, 15) = 2, "End of text"
    TEST_CHECK __UI_TBLineEnd(tb, 1) = 5, "Wrapped line ends before its last space"
    TEST_CHECK __UI_TBLineEnd(tb, 2) = 15, "Last line ends at the end of the text"
    TEST_CHECK __UI_TBXFromPos(tb, 3) = 24, "x of position 3"
    TEST_CHECK __UI_TBXFromPos(tb, 8) = 16, "x on the second line"
    TEST_CHECK __UI_TBPosFromX(tb, 2, 17) = 8, "Closest position to x"
    TEST_CHECK __UI_TBPosFromX(tb, 1, 1000) = 5, "Past the end of a wrapped line"
    TEST_CHECK __UI_TBPosFromPoint(tb, 17, lineH + 1) = 8, "Point on line 2"
    TEST_CHECK __UI_TBPosFromPoint(tb, 0, -50) = 0, "Point above the text"
    TEST_CHECK __UI_TBPosFromPoint(tb, 1000, 1000) = 15, "Point below the text"

    Text(tb) = "ab" + _CHR_LF + _CHR_LF + "cd"
    TEST_CHECK __UI_TBCountLines(tb) = 3, "Line breaks, including an empty line"
    TEST_CHECK __UI_TBLineStart(2) = 3 _ANDALSO __UI_TBLineLen(2) = 0, "Empty middle line"
    TEST_CHECK __UI_TBLineStart(3) = 4 _ANDALSO __UI_TBLineLen(3) = 2, "Last line"
    TEST_CHECK __UI_TBLineFromPos(tb, 2) = 1, "Position before a line break"
    TEST_CHECK __UI_TBLineEnd(tb, 1) = 2, "Line ends at its line break"

    Text(tb) = "ab" + _CHR_LF
    TEST_CHECK __UI_TBCountLines(tb) = 2, "A final line break starts an empty line"
    TEST_CHECK __UI_TBLineFromPos(tb, 3) = 2, "Cursor after the final line break"

    Text(tb) = "abcdefghijklmnop"
    TEST_CHECK __UI_TBCountLines(tb) = 2, "A long word is split"
    TEST_CHECK __UI_TBLineLen(1) = 10 _ANDALSO __UI_TBLineStart(2) = 10, "Split where the box ends"

    TEST_CASE_END

    TEST_CASE_BEGIN "InFormUIHelpers: multiline textbox navigation"

    Text(tb) = "hello world foo"
    Control(tb).Cursor = 3
    __UI_TBKeepCaretX = _FALSE
    __UI_TBMoveLines tb, 1
    TEST_CHECK Control(tb).Cursor = 9, "Down keeps the column"
    __UI_TBMoveLines tb, -1
    TEST_CHECK Control(tb).Cursor = 3, "Up keeps the column"
    __UI_TBMoveLines tb, -1
    TEST_CHECK Control(tb).Cursor = 0, "Up on the first line goes to the start"
    __UI_TBKeepCaretX = _FALSE
    Control(tb).Cursor = 9
    __UI_TBMoveLines tb, 1
    TEST_CHECK Control(tb).Cursor = 15, "Down on the last line goes to the end"
    __UI_TBKeepCaretX = _FALSE

    'One visible line: the text needs a scrollbar and wraps narrower (8 characters)
    Control(tb).Height = lineH
    TEST_CHECK __UI_TBVisibleLines(tb) = 1, "One visible line"
    TEST_CHECK __UI_TBCountLines(tb) = 3, "Rewrapped beside the scrollbar"
    TEST_CHECK __UI_TBNeedsScrollbar, "Needs a scrollbar"
    TEST_CHECK __UI_TBLineStart(2) = 6 _ANDALSO __UI_TBLineStart(3) = 12, "Lines after rewrapping"

    __UI_TBScrollTo tb, 10
    TEST_CHECK Control(tb).FirstVisibleLine = 3, "Scrolling stops at the last line"
    __UI_TBScrollTo tb, -5
    TEST_CHECK Control(tb).FirstVisibleLine = 1, "Scrolling stops at the first line"
    Control(tb).Cursor = 13
    __UI_TBScrollToCaret tb
    TEST_CHECK Control(tb).FirstVisibleLine = 3 _ANDALSO Control(tb).CurrentLine = 3, "Scrolls to show the cursor"
    Control(tb).Cursor = 0
    __UI_TBScrollToCaret tb
    TEST_CHECK Control(tb).FirstVisibleLine = 1, "Scrolls back up"

    Text(tb) = "foo bar baz"
    TEST_CHECK __UI_TBWordStart(tb, 5) = 4, "Word start"
    TEST_CHECK __UI_TBWordEnd(tb, 5) = 8, "Word end includes the following space"
    TEST_CHECK __UI_TBWordEnd(tb, 9) = 11, "Last word"
    TEST_CHECK __UI_IsWordSeparator(Text(tb), 4), "Space separates words"
    TEST_CHECK_FALSE __UI_IsWordSeparator(Text(tb), 5), "Letter is part of a word"
    TEST_CHECK __UI_IsWordSeparator(_CHR_LF, 1), "Line break separates words"

    __UI_DestroyControl Control(tb)
    __UI_DefaultCaptionIndent = prevIndent
    __UI_ScrollbarWidth = prevScrollbar
    _DEST prevDest
    _FREEIMAGE testImage

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

SUB Test_DropdownSearch
    TEST_CASE_BEGIN "InFormUIHelpers: searchable dropdown list"

    TEST_CHECK __UI_MatchesSearch("Resistor 10k 1/4W", ""), "Empty search matches everything"
    TEST_CHECK __UI_MatchesSearch("Resistor 10k 1/4W", "   "), "Blank search matches everything"
    TEST_CHECK __UI_MatchesSearch("Resistor 10k 1/4W", "10k"), "One word"
    TEST_CHECK __UI_MatchesSearch("Resistor 10k 1/4W", "10K resist"), "Words in any order, any case"
    TEST_CHECK __UI_MatchesSearch("Resistor 10k 1/4W", "  res   1/4  "), "Extra spaces are ignored"
    TEST_CHECK NOT __UI_MatchesSearch("Resistor 10k 1/4W", "res 22k"), "Every word must match"
    TEST_CHECK NOT __UI_MatchesSearch("", "a"), "Empty item doesn't match a word"

    'The list needs a graphics surface to measure its font on
    DIM AS LONG dd, listID, testImage, prevDest
    prevDest = _DEST
    testImage = _NEWIMAGE(320, 240, 32)
    _DEST testImage

    dd = __UI_NewControl(__UI_Type_DropdownList, "TestSearchDD", 200, 23, 0, 0, 0)
    Control(dd).Font = 8
    Control(dd).Searchable = _TRUE
    AddItem dd, "Resistor 10k"
    AddItem dd, "Resistor 22k"
    AddItem dd, "Capacitor 10uF"
    AddItem dd, "Capacitor 22pF"
    Control(dd).Value = 4

    __UI_ActivateDropdownlist Control(dd)
    listID = __UI_ActiveDropdownList
    TEST_CHECK listID > 0, "List opens"
    TEST_CHECK Control(listID).Max = 4 _ANDALSO Control(listID).Value = 4, "Empty search shows every item, current one selected"

    __UI_DropdownSearch = "22"
    __UI_FilterDropdownList
    TEST_CHECK Control(listID).Max = 2, "Two items contain 22"
    TEST_CHECK Text(listID) = "Resistor 22k" + CHR$(10) + "Capacitor 22pF", "Filtered items keep their order"
    TEST_CHECK Control(listID).Value = 2, "Current item stays selected when shown"
    TEST_CHECK __UI_DropdownChosenItem(1) = 2 _ANDALSO __UI_DropdownChosenItem(2) = 4, "Shown items map back to the dropdown's items"

    __UI_DropdownSearch = "cap 10"
    __UI_FilterDropdownList
    TEST_CHECK Control(listID).Max = 1 _ANDALSO Text(listID) = "Capacitor 10uF", "Several words narrow the list"
    TEST_CHECK Control(listID).Value = 1, "First item selected when the current one is hidden"
    TEST_CHECK __UI_DropdownChosenItem(1) = 3, "Picks the right item"

    __UI_DropdownSearch = "inductor"
    __UI_FilterDropdownList
    TEST_CHECK Control(listID).Max = 0 _ANDALSO Control(listID).Value = 0, "No matches"
    TEST_CHECK __UI_DropdownChosenItem(0) = 4, "Nothing picked keeps the current item"

    'Fuzzy search
    TEST_CHECK __UI_SearchScore("Resistor 10k", "rs10", _FALSE) = 0, "Plain search needs the letters together"
    TEST_CHECK __UI_SearchScore("Resistor 10k", "rs10", _TRUE) > 0, "Fuzzy search takes letters in order"
    TEST_CHECK __UI_SearchScore("Resistor 10k", "01", _TRUE) = 0, "Fuzzy search keeps the letters' order"
    TEST_CHECK __UI_SearchScore("Capacitor 22pF ceramic", "cer 22p", _TRUE) > 0, "Fuzzy words in any order"
    TEST_CHECK __UI_SearchScore("Capacitor 22pF ceramic", "cer xyz", _TRUE) = 0, "Fuzzy: every word must match"
    TEST_CHECK __UI_SearchScore("Resistor", "res", _TRUE) > __UI_SearchScore("Resistor", "rst", _TRUE), "Letters together beat scattered ones"
    TEST_CHECK __UI_SearchScore("LED red", "red", _TRUE) > __UI_SearchScore("Shredder", "red", _TRUE), "Word starts beat the middle of a word"
    TEST_CHECK __UI_SearchScore("anything", "", _TRUE) > 0, "Empty fuzzy search matches everything"

    Control(dd).Fuzzy = _TRUE
    __UI_DropdownSearch = "cp"
    __UI_FilterDropdownList
    TEST_CHECK Control(listID).Max = 2, "Fuzzy finds both capacitors"
    __UI_DropdownSearch = "10"
    __UI_FilterDropdownList
    TEST_CHECK Text(listID) = "Resistor 10k" + CHR$(10) + "Capacitor 10uF", "Earlier hits come first"
    __UI_DropdownSearch = "pf"
    __UI_FilterDropdownList
    TEST_CHECK Text(listID) = "Capacitor 22pF" + CHR$(10) + "Capacitor 10uF", "Best match first, even when it's later in the list"
    TEST_CHECK Control(listID).Value = 1 _ANDALSO __UI_DropdownChosenItem(1) = 4, "Best match is selected and maps back"
    __UI_DropdownSearch = "zz"
    __UI_FilterDropdownList
    TEST_CHECK Control(listID).Max = 0, "Fuzzy: no matches"

    __UI_DestroyControl Control(listID)
    TEST_CHECK __UI_ActiveDropdownList = 0 _ANDALSO LEN(__UI_DropdownSearch) = 0 _ANDALSO LEN(__UI_DropdownSearchMap) = 0, "Closing clears the search"
    'Searchable and Fuzzy can be bound to another control's value
    DIM cb AS LONG
    cb = __UI_NewControl(__UI_Type_CheckBox, "TestSearchCB", 100, 20, 0, 40, 0)
    Control(dd).Searchable = _TRUE
    __UI_Bind cb, dd, "Value", "Searchable"
    TEST_CHECK Control(cb).Value <> _FALSE, "Binding starts from Searchable's current state"
    Control(dd).Searchable = _FALSE
    Control(cb).Value = _TRUE
    __UI_CheckBinding cb
    TEST_CHECK Control(dd).Searchable <> _FALSE, "Binding sets Searchable from a checkbox"
    Control(cb).Value = _FALSE
    __UI_CheckBinding cb
    TEST_CHECK Control(dd).Searchable = _FALSE, "Binding clears Searchable"
    __UI_Bind cb, dd, "Value", "Fuzzy"
    Control(cb).Value = 7 'Any non-zero value turns it on
    __UI_CheckBinding cb
    TEST_CHECK Control(dd).Fuzzy = _TRUE, "Binding sets Fuzzy"
    __UI_UnBind cb

    'A control can be bound to several others through different properties
    DIM cb2 AS LONG
    cb2 = __UI_NewControl(__UI_Type_CheckBox, "TestSearchCB2", 100, 20, 0, 70, 0)
    Control(cb).Value = _FALSE: Control(cb2).Value = _FALSE
    Control(dd).Disabled = _FALSE: Control(dd).Searchable = _FALSE
    __UI_Bind dd, cb, "Disabled", "Value"
    __UI_Bind dd, cb2, "Searchable", "Value"
    TEST_CHECK __UI_TotalBindings = 2, "Two bindings on one control"
    TEST_CHECK __UI_BoundPropertyName$(dd, cb) = "Disabled" _ANDALSO __UI_BoundPropertyName$(cb2, dd) = "Value", "Each binding keeps its own properties"
    Control(cb).Value = _TRUE
    __UI_CheckBinding cb
    TEST_CHECK Control(dd).Disabled <> _FALSE _ANDALSO Control(dd).Searchable = _FALSE, "First binding changes only its property"
    Control(cb2).Value = _TRUE
    __UI_CheckBinding cb2
    TEST_CHECK Control(dd).Searchable <> _FALSE, "Second binding works too"
    Control(dd).Disabled = _FALSE
    __UI_CheckBinding dd
    TEST_CHECK Control(cb).Value = _FALSE _ANDALSO Control(cb2).Value <> _FALSE, "Changes flow from the dropdown to each bound control"
    __UI_Bind dd, cb, "Hidden", "Value"
    TEST_CHECK __UI_TotalBindings = 2 _ANDALSO __UI_BoundPropertyName$(dd, cb) = "Hidden", "Binding the same two controls again replaces their binding"
    __UI_UnBindPair cb, dd
    TEST_CHECK __UI_TotalBindings = 1 _ANDALSO __UI_BindingIndex(dd, cb2) > 0, "Unbinding a pair keeps the other bindings"
    __UI_DestroyControl Control(cb2)
    TEST_CHECK __UI_TotalBindings = 0, "Destroying a control removes its bindings"

    'Inverted (NOT) bindings
    Control(cb).Value = _TRUE
    __UI_Bind dd, cb, "Disabled", "NOT Value"
    TEST_CHECK Control(dd).Disabled = _FALSE, "NOT: a checked box leaves the dropdown enabled"
    TEST_CHECK __UI_BoundPropertyName$(cb, dd) = "NOT Value" _ANDALSO __UI_BoundPropertyName$(dd, cb) = "Disabled", "NOT is kept with the property, as written"
    Control(cb).Value = _FALSE
    __UI_CheckBinding cb
    TEST_CHECK Control(dd).Disabled = _TRUE, "NOT: zero sets True"
    Control(cb).Value = 5
    __UI_CheckBinding cb
    TEST_CHECK Control(dd).Disabled = _FALSE, "NOT: any non-zero value sets zero"
    Control(dd).Disabled = _TRUE
    __UI_CheckBinding dd
    TEST_CHECK Control(cb).Value = _FALSE, "NOT works in both directions"
    __UI_Bind dd, cb, "NOT Disabled", "Value"
    TEST_CHECK __UI_Bindings(__UI_BindingIndex(dd, cb)).Inverted, "NOT can go on either property"
    __UI_Bind dd, cb, "NOT Disabled", "NOT Value"
    TEST_CHECK __UI_Bindings(__UI_BindingIndex(dd, cb)).Inverted = _FALSE, "NOT on both sides cancels out"
    __UI_UnBind dd

    __UI_DestroyControl Control(cb)

    __UI_DestroyControl Control(dd)

    _DEST prevDest
    _FREEIMAGE testImage

    TEST_CASE_END
END SUB

SUB Test_ReorderableList
    TEST_CASE_BEGIN "InFormUIHelpers: reorderable list box"

    DIM lb AS LONG
    lb = __UI_NewControl(__UI_Type_ListBox, "TestReorderLB", 200, 100, 0, 0, 0)
    AddItem lb, "A"
    AddItem lb, "B"
    AddItem lb, "C"
    AddItem lb, "D"
    Control(lb).Value = 2

    MoveItem lb, 1, 3
    TEST_CHECK Text(lb) = "B" + _CHR_LF + "C" + _CHR_LF + "A" + _CHR_LF + "D" + _CHR_LF, "Move down shifts the items in between up"
    TEST_CHECK Control(lb).Value = 1, "Selection follows its item when others move"

    MoveItem lb, 4, 1
    TEST_CHECK Text(lb) = "D" + _CHR_LF + "B" + _CHR_LF + "C" + _CHR_LF + "A" + _CHR_LF, "Move up shifts the items in between down"
    TEST_CHECK Control(lb).Value = 2, "Selection still on the same item"

    MoveItem lb, 2, 4
    TEST_CHECK GetItem(lb, 4) = "B" _ANDALSO Control(lb).Value = 4, "Moving the selected item keeps it selected"

    MoveItem lb, 0, 2
    MoveItem lb, 2, 5
    MoveItem lb, 3, 3
    TEST_CHECK Text(lb) = "D" + _CHR_LF + "C" + _CHR_LF + "A" + _CHR_LF + "B" + _CHR_LF _ANDALSO Control(lb).Max = 4, "Out-of-range and no-op moves change nothing"

    'Dropping into a gap: gap 1 is above the first item, gap 5 below the last
    Control(lb).Reorderable = _TRUE
    __UI_ReorderingID = lb: __UI_ReorderFrom = 1: __UI_ReorderGap = 5
    TEST_CHECK __UI_ReorderEnd, "Dropping below the last item moves it"
    TEST_CHECK GetItem(lb, 4) = "D" _ANDALSO Control(lb).Value = 4, "Dropped item ends up last and selected"
    TEST_CHECK __UI_ReorderingID = 0 _ANDALSO __UI_MovedItemFrom = 0 _ANDALSO __UI_MovedItemTo = 0, "Drag state is cleared after the drop"

    __UI_ReorderingID = lb: __UI_ReorderFrom = 4: __UI_ReorderGap = 1
    TEST_CHECK __UI_ReorderEnd _ANDALSO GetItem(lb, 1) = "D", "Dropping above the first item moves it first"

    __UI_ReorderingID = lb: __UI_ReorderFrom = 2: __UI_ReorderGap = 0
    TEST_CHECK NOT __UI_ReorderEnd, "No gap: nothing moves"

    __UI_DestroyControl Control(lb)

    TEST_CASE_END
END SUB

SUB Test_Anchors
    TEST_CASE_BEGIN "InFormUIHelpers: anchors"

    DIM l AS INTEGER, t AS INTEGER, w AS LONG, h AS LONG

    l = 10: t = 20: w = 100: h = 50
    __UI_AnchorOne 0, 30, 40, l, t, w, h
    TEST_CHECK l = 10 _ANDALSO t = 20 _ANDALSO w = 100 _ANDALSO h = 50, "Anchor 0 acts as left + top: nothing changes"

    __UI_AnchorOne __UI_Anchor_Right OR __UI_Anchor_Bottom, 30, 40, l, t, w, h
    TEST_CHECK l = 40 _ANDALSO t = 60 _ANDALSO w = 100 _ANDALSO h = 50, "Right + bottom: the control moves"

    __UI_AnchorOne __UI_Anchor_Left OR __UI_Anchor_Right OR __UI_Anchor_Top OR __UI_Anchor_Bottom, -30, -40, l, t, w, h
    TEST_CHECK l = 40 _ANDALSO t = 60 _ANDALSO w = 70 _ANDALSO h = 10, "All four edges: the control stretches"

    __UI_AnchorOne __UI_Anchor_Left OR __UI_Anchor_Right OR __UI_Anchor_Top OR __UI_Anchor_Bottom, -500, -500, l, t, w, h
    TEST_CHECK w = -430 _ANDALSO h = -490, "The size anchors aim for isn't clamped"

    DIM bt AS LONG, tb AS LONG, fr AS LONG, child AS LONG, fixed AS LONG
    bt = __UI_NewControl(__UI_Type_Button, "TestAnchorBT", 80, 23, 300, 200, 0)
    Control(bt).Anchor = __UI_Anchor_Right OR __UI_Anchor_Bottom
    tb = __UI_NewControl(__UI_Type_TextBox, "TestAnchorTB", 200, 23, 10, 10, 0)
    Control(tb).Anchor = __UI_Anchor_Left OR __UI_Anchor_Right OR __UI_Anchor_Top
    fr = __UI_NewControl(__UI_Type_Frame, "TestAnchorFR", 150, 100, 10, 50, 0)
    Control(fr).Anchor = __UI_Anchor_Left OR __UI_Anchor_Top OR __UI_Anchor_Bottom
    child = __UI_NewControl(__UI_Type_Button, "TestAnchorChild", 60, 23, 10, 60, fr)
    Control(child).Anchor = __UI_Anchor_Left OR __UI_Anchor_Bottom
    fixed = __UI_NewControl(__UI_Type_Label, "TestAnchorLB", 60, 20, 5, 5, 0)

    __UI_ApplyAnchors 50, 30
    TEST_CHECK Control(bt).Left = 350 _ANDALSO Control(bt).Top = 230 _ANDALSO Control(bt).Width = 80, "Bottom-right button follows the form's corner"
    TEST_CHECK Control(tb).Left = 10 _ANDALSO Control(tb).Width = 250 _ANDALSO Control(tb).Top = 10, "Left + right text box stretches"
    TEST_CHECK Control(fr).Height = 130 _ANDALSO Control(fr).Width = 150, "Frame stretches down only"
    TEST_CHECK Control(child).Top = 90 _ANDALSO Control(child).Left = 10, "Child follows its frame's bottom edge"
    TEST_CHECK Control(fixed).Left = 5 _ANDALSO Control(fixed).Top = 5 _ANDALSO Control(fixed).Width = 60, "Default anchor keeps the control in place"

    __UI_ApplyAnchors -50, -30
    TEST_CHECK Control(bt).Left = 300 _ANDALSO Control(tb).Width = 200 _ANDALSO Control(fr).Height = 100 _ANDALSO Control(child).Top = 60, "Shrinking back restores the design layout"

    'Shrink far past what fits, then grow back: sizes stop at 1 pixel but come back exactly
    __UI_ApplyAnchors -400, -300
    TEST_CHECK Control(tb).Width = 1 _ANDALSO Control(fr).Height = 1, "Shrinking too far stops at 1 pixel"
    __UI_ApplyAnchors 300, 200
    TEST_CHECK Control(tb).Width = 100 _ANDALSO Control(fr).Height = 1, "Growing part of the way back keeps the lost size in mind"
    __UI_ApplyAnchors 100, 100
    TEST_CHECK Control(tb).Width = 200 _ANDALSO Control(fr).Height = 100 _ANDALSO Control(child).Top = 60 _ANDALSO Control(bt).Left = 300, "Growing all the way back restores the design layout"

    'Changing a size in code is respected from then on
    Control(tb).Width = 150
    __UI_ApplyAnchors 10, 0
    TEST_CHECK Control(tb).Width = 160, "Anchors continue from a size set in code"

    __UI_DestroyControl Control(child)
    __UI_DestroyControl Control(fr)
    __UI_DestroyControl Control(bt)
    __UI_DestroyControl Control(tb)
    __UI_DestroyControl Control(fixed)

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

    Ini_Release "test.ini"
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

SUB Test_Timer
    TEST_CASE_BEGIN "Timer"

    Timer_Initialize

    ' Invalid handles should safely return false / 0
    TEST_CHECK_FALSE Timer_Exists(0), "Handle 0 should not exist"
    TEST_CHECK_FALSE Timer_Exists(-1), "Negative handle should not exist"
    TEST_CHECK_FALSE Timer_Exists(999), "Out of bounds handle should not exist"
    TEST_CHECK_FALSE Timer_Poll(0), "Poll on handle 0 should return false"
    TEST_CHECK_FALSE Timer_Poll(999), "Poll on out-of-bounds handle should return false"
    TEST_CHECK_FALSE Timer_IsPaused(0), "Handle 0 is not paused"
    TEST_CHECK Timer_GetInterval(0) = 0, "Handle 0 interval is 0"
    TEST_CHECK Timer_GetRemainingTicks(0) = 0, "Handle 0 remaining ticks is 0"

    ' Frequency conversion helpers
    TEST_CHECK Timer_GetTicksFromHertz(50) = 20, "50 Hz should be 20 ticks (1000/50)"
    TEST_CHECK Timer_GetTicksFromHertz(0) = 0, "0 Hz should return 0 ticks"
    TEST_CHECK Timer_GetTicksFromHertz(-10) = 0, "Negative Hz should return 0 ticks"
    TEST_CHECK Timer_GetHertzFromTicks(20) = 50!, "20 ticks should be 50 Hz"
    TEST_CHECK Timer_GetHertzFromTicks(0) = 0!, "0 ticks should return 0 Hz"

    ' Create periodic timer
    DIM t1 AS LONG: t1 = Timer_Create(100)
    TEST_REQUIRE t1 > 0, "Timer_Create should return handle > 0"
    TEST_CHECK Timer_Exists(t1), "Created timer should exist"
    TEST_CHECK Timer_GetInterval(t1) = 100, "Timer interval should be 100"
    TEST_CHECK_FALSE Timer_IsOneShot(t1), "Default timer should not be one-shot"
    TEST_CHECK_FALSE Timer_IsPaused(t1), "Timer should not be paused initially"

    ' Set interval
    Timer_SetInterval t1, 250
    TEST_CHECK Timer_GetInterval(t1) = 250, "Updated timer interval should be 250"

    ' Pause and resume
    Timer_Pause t1
    TEST_CHECK Timer_IsPaused(t1), "Timer should be paused after Timer_Pause"
    TEST_CHECK_FALSE Timer_Poll(t1), "Paused timer should not fire in Timer_Poll"

    Timer_Resume t1
    TEST_CHECK_FALSE Timer_IsPaused(t1), "Timer should not be paused after Timer_Resume"

    ' One-shot timer
    DIM tOne AS LONG: tOne = Timer_CreateOneShot(30)
    TEST_REQUIRE tOne > 0, "Timer_CreateOneShot should return handle > 0"
    TEST_CHECK Timer_Exists(tOne), "One-shot timer should exist"
    TEST_CHECK Timer_IsOneShot(tOne), "One-shot timer should be flagged as one-shot"

    ' Short delay to test polling and one-shot auto-deactivation
    _DELAY 0.05 ' 50 ms delay
    TEST_CHECK Timer_Poll(tOne), "One-shot timer should fire after interval elapsed"
    TEST_CHECK_FALSE Timer_Exists(tOne), "One-shot timer should automatically deactivate after firing"
    TEST_CHECK_FALSE Timer_Poll(tOne), "Deactivated one-shot timer should not fire again"

    ' Delete timer
    Timer_Delete t1
    TEST_CHECK_FALSE Timer_Exists(t1), "Deleted timer should not exist"
    TEST_CHECK_FALSE Timer_Poll(t1), "Deleted timer should not fire"

    ' Slot reuse
    DIM tReuse AS LONG: tReuse = Timer_Create(50)
    TEST_CHECK tReuse = t1, "Newly created timer should reuse deleted slot"
    Timer_Delete tReuse

    TEST_CASE_END
END SUB

''' @brief Gives a textbox focus the way the grid sees it: focus moves, then the screen updates.
SUB TestPGFocus (id AS LONG)
    __UI_Focus = id
    __UI_PropertyGridsUpdate
END SUB

''' @brief Presses Enter (13) or Esc (27) in the focused control, as far as the grid is concerned.
SUB TestPGKey (k AS LONG)
    __UI_KeyHit = k
    __UI_PropertyGridKey
    __UI_KeyHit = 0
END SUB

''' @brief Presses the mouse button on a control (the mouse is where __UI_MouseLeft/Top say), then lets the grids update.
SUB TestPGPress (id AS LONG)
    __UI_MouseIsDown = True
    __UI_MouseDownOnID = id
    __UI_PropertyGridMouseDown
    __UI_PropertyGridsUpdate
END SUB

SUB TestPGRelease
    __UI_MouseIsDown = False
    __UI_MouseDownOnID = 0
    __UI_PropertyGridsUpdate
END SUB

SUB Test_PropertyGrid
    DIM f AS LONG, f2 AS LONG, tb AS LONG, sz AS LONG, dd AS LONG, cb AS LONG, bt AS LONG, extra AS LONG
    DIM lbl AS LONG, own AS LONG, events AS LONG

    TEST_CASE_BEGIN "PropertyGrid: rows"

    f = __UI_NewControl(__UI_Type_Frame, "TestPG", 230, 300, 0, 0, 0)
    PropertyGrid_AddText f, "name", "Name"
    PropertyGrid_AddInteger f, "size", "Size"
    PropertyGrid_AddChoice f, "color", "Color", "Red|Green|Blue"
    PropertyGrid_AddToggle f, "on", "Turned on"
    PropertyGrid_AddButton f, "go", "Action", "Run"
    tb = PropertyGrid_Control(f, "name")
    sz = PropertyGrid_Control(f, "SIZE")
    dd = PropertyGrid_Control(f, "color")
    cb = PropertyGrid_Control(f, "on")
    bt = PropertyGrid_Control(f, "go")

    TEST_CHECK Control(tb).Type = __UI_Type_TextBox, "Text row has a textbox"
    TEST_CHECK Control(sz).Type = __UI_Type_TextBox, "Keys ignore case"
    TEST_CHECK Control(dd).Type = __UI_Type_DropdownList, "Choice row has a dropdown list"
    TEST_CHECK Control(cb).Type = __UI_Type_CheckBox, "Toggle row has a check box"
    TEST_CHECK Control(bt).Type = __UI_Type_Button, "Button row has a button"
    TEST_CHECK Control(tb).ParentID = f, "Row controls go in the frame"
    TEST_CHECK Caption(PropertyGrid_LabelControl(f, "name")) = "Name", "Label caption"
    TEST_CHECK PropertyGrid_LabelControl(f, "on") = 0, "Toggle rows have no label"
    TEST_CHECK Caption(cb) = "Turned on", "Toggle caption"
    TEST_CHECK GetItem(dd, 2) = "Green", "Choice items"
    TEST_CHECK PropertyGrid_Value(f, "color") = "1", "Choice starts on the first item"
    TEST_CHECK PropertyGrid_Value(f, "size") = "0", "Number rows start at 0"
    TEST_CHECK PropertyGrid_RowOf(bt) = "go", "Row of a control"
    TEST_CHECK PropertyGrid_RowOf(PropertyGrid_LabelControl(f, "name")) = "name", "Row of a label"
    TEST_CHECK PropertyGrid_GridOf(bt) = f, "Grid of a control"
    TEST_CHECK PropertyGrid_RowOf(f) = "", "A frame is no row"
    TEST_CHECK PropertyGrid_Control(f, "missing") = 0, "Missing row"
    TEST_CHECK PropertyGrid_Value(f, "missing") = "", "Missing row has no value"
    PropertyGrid_SetValue f, "missing", "x"

    TEST_CASE_END

    TEST_CASE_BEGIN "PropertyGrid: layout"

    PropertyGrid_Layout f
    TEST_CHECK Control(tb).Top = 10 _ANDALSO Control(sz).Top = 32 _ANDALSO Control(dd).Top = 54, "Rows are stacked"
    TEST_CHECK Control(cb).Top = 76 _ANDALSO Control(bt).Top = 98, "Rows are stacked to the end"
    TEST_CHECK PropertyGrid_NextTop(f) = 120, "Next top"
    TEST_CHECK Control(PropertyGrid_LabelControl(f, "name")).Left = 10 _ANDALSO Control(PropertyGrid_LabelControl(f, "name")).Width = 120, "Label column"
    TEST_CHECK Control(tb).Left = 129 _ANDALSO Control(tb).Width = 94, "Value column fills the frame"
    TEST_CHECK Control(cb).Left = 10 _ANDALSO Control(cb).Width = 213, "Toggles span both columns"

    PropertyGrid_ShowRow f, "size", False
    PropertyGrid_Layout f
    TEST_CHECK Control(sz).Hidden _ANDALSO Control(PropertyGrid_LabelControl(f, "size")).Hidden, "Hidden row"
    TEST_CHECK_FALSE PropertyGrid_RowShown(f, "size"), "Row reported hidden"
    TEST_CHECK Control(dd).Top = 32, "Rows close the gap"

    PropertyGrid_ShowOnly f, "name,go"
    PropertyGrid_Layout f
    TEST_CHECK Control(bt).Top = 32 _ANDALSO Control(dd).Hidden _ANDALSO Control(cb).Hidden, "Show only some rows"

    PropertyGrid_ShowAll f, True
    PropertyGrid_ShowRows f, "Name, size", False
    PropertyGrid_Layout f
    TEST_CHECK Control(tb).Hidden _ANDALSO Control(sz).Hidden _ANDALSO Control(dd).Top = 10, "Key lists can have spaces"
    PropertyGrid_ShowAll f, True

    PropertyGrid_SetFloating f, "size", True
    Control(sz).Top = 200
    PropertyGrid_Layout f
    TEST_CHECK Control(sz).Top = 200 _ANDALSO Control(dd).Top = 32, "Floating rows stay put"
    PropertyGrid_SetFloating f, "size", False

    PropertyGrid_SetLayout f, 5, 20, 30, 60
    PropertyGrid_Layout f
    TEST_CHECK Control(tb).Top = 20 _ANDALSO Control(sz).Top = 50 _ANDALSO Control(tb).Left = 64, "Custom layout"
    PropertyGrid_SetLayout f, 10, 10, 22, 120

    extra = __UI_NewControl(__UI_Type_Button, "TestPGExtra", 23, 23, 100, 0, f)
    PropertyGrid_AttachControl f, "color", extra
    PropertyGrid_Layout f
    TEST_CHECK Control(extra).Top = Control(dd).Top _ANDALSO Control(extra).Left = 100, "Attached control follows its row"
    PropertyGrid_ShowRow f, "color", False
    PropertyGrid_Layout f
    TEST_CHECK Control(extra).Hidden, "Attached control hides with its row"
    PropertyGrid_DetachControl extra
    PropertyGrid_ShowRow f, "color", True
    PropertyGrid_Layout f
    TEST_CHECK Control(extra).Hidden, "Detached control is left alone"

    PropertyGrid_SetLabel f, "name", "Title"
    TEST_CHECK Caption(PropertyGrid_LabelControl(f, "name")) = "Title", "Label changed"

    TEST_CASE_END

    TEST_CASE_BEGIN "PropertyGrid: editing"

    TestValueChangedCount = 0
    PropertyGrid_SetValue f, "name", "abc"
    TEST_CHECK Text(tb) = "abc", "Value shown in an unfocused box"
    Text(tb) = "stray"
    __UI_PropertyGridsUpdate
    TEST_CHECK Text(tb) = "abc", "Unfocused box keeps showing the value"

    TestPGFocus tb
    Text(tb) = "xyz"
    TestPGKey 13
    TEST_CHECK TestValueChangedCount = 1 _ANDALSO TestValueChangedID = f, "Enter fires the frame's event"
    TEST_CHECK PropertyGrid_ChangedRow(f) = "name" _ANDALSO PropertyGrid_Value(f, "name") = "xyz", "Committed value"
    TEST_CHECK Control(tb).TextIsSelected _ANDALSO Control(tb).Cursor = 3, "Text is selected after Enter"
    TestPGKey 13
    TEST_CHECK TestValueChangedCount = 1, "Enter again changes nothing"

    Text(tb) = "junk"
    TestPGKey 27
    TEST_CHECK Text(tb) = "xyz" _ANDALSO TestValueChangedCount = 1, "Esc puts the value back"

    TestPGFocus sz
    Text(sz) = "12.6"
    TestPGKey 13
    TEST_CHECK PropertyGrid_Value(f, "size") = "13" _ANDALSO Text(sz) = "13", "Integer rows round"
    __UI_PropertyGridsUpdate
    TEST_CHECK PropertyGrid_RowState(f, "size") = __UI_PropertyGrid_Confirmed, "Box shows the value"

    PropertyGrid_SetValue f, "size", "10"
    TEST_CHECK Text(sz) = "13", "Focused box keeps its text"
    __UI_PropertyGridsUpdate
    TEST_CHECK PropertyGrid_RowState(f, "size") = __UI_PropertyGrid_Normal, "Not rejected right after the commit"
    _DELAY .15
    __UI_PropertyGridsUpdate
    TEST_CHECK PropertyGrid_RowState(f, "size") = __UI_PropertyGrid_Rejected, "Rejected when the value differs"
    TestPGKey 27
    __UI_PropertyGridsUpdate
    TEST_CHECK Text(sz) = "10" _ANDALSO PropertyGrid_RowState(f, "size") = __UI_PropertyGrid_Confirmed, "Esc shows the value taken"

    events = TestValueChangedCount
    TestPGFocus tb
    Text(tb) = "typed"
    __UI_Focus = 0
    PropertyGrid_SetValue f, "name", "from code"
    TEST_CHECK Text(tb) = "typed", "Box that lost focus keeps its text until it's committed"
    __UI_PropertyGridsUpdate
    TEST_CHECK TestValueChangedCount = events + 1 _ANDALSO PropertyGrid_Value(f, "name") = "typed", "Leaving a box commits it"
    __UI_PropertyGridsUpdate
    TEST_CHECK TestValueChangedCount = events + 1, "Committed once"

    Text(tb) = "from a dialog"
    PropertyGrid_Commit f, "name"
    TEST_CHECK TestValueChangedCount = events + 2 _ANDALSO PropertyGrid_Value(f, "name") = "from a dialog", "Commit from code"

    TEST_CASE_END

    TEST_CASE_BEGIN "PropertyGrid: choices and toggles"

    events = TestValueChangedCount
    Control(dd).Value = 2
    __UI_PropertyGridsUpdate
    TEST_CHECK TestValueChangedCount = events + 1 _ANDALSO PropertyGrid_ChangedRow(f) = "color" _ANDALSO PropertyGrid_Value(f, "color") = "2", "Picking an item fires the event"
    PropertyGrid_SetValue f, "color", "3"
    __UI_PropertyGridsUpdate
    TEST_CHECK Control(dd).Value = 3 _ANDALSO TestValueChangedCount = events + 1, "Setting a value from code fires nothing"

    Control(cb).Value = True
    __UI_PropertyGridsUpdate
    TEST_CHECK TestValueChangedCount = events + 2 _ANDALSO PropertyGrid_Value(f, "on") = "-1", "Checking fires the event"
    PropertyGrid_SetValue f, "on", "0"
    TEST_CHECK Control(cb).Value = 0, "Unchecked from code"

    TEST_CASE_END

    TEST_CASE_BEGIN "PropertyGrid: adopted rows"

    f2 = __UI_NewControl(__UI_Type_Frame, "TestPG2", 300, 200, 0, 0, 0)
    lbl = __UI_NewControl(__UI_Type_Label, "TestPGOwnLB", 40, 23, 5, 0, f2)
    own = __UI_NewControl(__UI_Type_TextBox, "TestPGOwnTB", 70, 23, 50, 0, f2)
    Text(own) = "start"
    PropertyGrid_AdoptRow f2, "own", lbl, own
    PropertyGrid_AdoptRow f2, "list", 0, __UI_NewControl(__UI_Type_DropdownList, "TestPGOwnDD", 70, 23, 50, 0, f2)
    PropertyGrid_Layout f2
    TEST_CHECK PropertyGrid_Value(f2, "own") = "start", "Adopted textbox keeps its text as the value"
    TEST_CHECK Control(own).Left = 50 _ANDALSO Control(own).Width = 70 _ANDALSO Control(lbl).Left = 5, "Adopted controls keep left and width"
    TEST_CHECK Control(PropertyGrid_Control(f2, "list")).Top = 32, "Adopted rows are stacked"

    events = TestValueChangedCount
    TestPGFocus own
    Text(own) = "edited"
    TestPGKey 13
    TEST_CHECK TestValueChangedCount = events + 1 _ANDALSO TestValueChangedID = f2, "Adopted textbox commits"
    Control(PropertyGrid_Control(f2, "list")).Value = 1
    __UI_PropertyGridsUpdate
    TEST_CHECK TestValueChangedCount = events + 1, "Adopted dropdowns are left to the program"
    __UI_Focus = 0
    __UI_PropertyGridsUpdate

    TEST_CASE_END

    TEST_CASE_BEGIN "PropertyGrid: scrolling"

    DIM fs AS LONG, i AS LONG, rowTB(1 TO 6) AS LONG
    'Room for three rows: 100 high, rows from 10, 4 pixels at the bottom
    fs = __UI_NewControl(__UI_Type_Frame, "TestPGScroll", 200, 100, 0, 0, 0)
    FOR i = 1 TO 6
        PropertyGrid_AddText fs, "r" + LTRIM$(STR$(i)), "Row" + STR$(i)
        rowTB(i) = PropertyGrid_Control(fs, "r" + LTRIM$(STR$(i)))
    NEXT
    PropertyGrid_Layout fs
    TEST_CHECK Control(rowTB(1)).Top = 10 _ANDALSO Control(rowTB(4)).Top = 76, "Rows start unscrolled"

    'Six rows of 22 = 132 pixels in 86 (100 - 10 - 4): they scroll by up to 46 pixels
    TEST_CHECK __UI_PropertyGridWheel(fs, 1), "Wheel over the frame scrolls"
    TEST_CHECK Control(rowTB(1)).Top = -12 _ANDALSO Control(rowTB(2)).Top = 10, "A wheel notch scrolls a row"
    TEST_CHECK Control(PropertyGrid_LabelControl(fs, "r1")).Top = -12, "Its label goes too"
    TEST_CHECK_FALSE Control(rowTB(1)).Hidden, "Scrolled-out rows can still get focus"
    TEST_CHECK __UI_PropertyGridWheel(rowTB(3), 10), "Wheel over a row scrolls its grid"
    TEST_CHECK Control(rowTB(6)).Top = 74, "Scrolling stops when the last row shows"
    TEST_CHECK __UI_PropertyGridWheel(fs, -10), "Wheel back up"
    TEST_CHECK Control(rowTB(1)).Top = 10, "Back at the top"

    TestPGFocus rowTB(6)
    TEST_CHECK Control(rowTB(6)).Top = 74, "Focused row is scrolled into view"
    TestPGFocus rowTB(5)
    TEST_CHECK Control(rowTB(6)).Top = 74, "A row already in view doesn't scroll"
    TestPGFocus rowTB(1)
    TEST_CHECK Control(rowTB(1)).Top = 10, "Scrolled up just enough for a row above"
    PropertyGrid_ScrollTo fs, "r6"
    TEST_CHECK Control(rowTB(6)).Top = 74, "Scroll to a row below"
    PropertyGrid_ScrollTo fs, "r2"
    TEST_CHECK Control(rowTB(2)).Top = 10, "Scroll to a row above"
    __UI_Focus = 0
    __UI_PropertyGridsUpdate

    PropertyGrid_ShowRows fs, "r4,r5,r6", False
    PropertyGrid_Layout fs
    TEST_CHECK Control(rowTB(1)).Top = 10, "Scroll resets when everything fits"
    TEST_CHECK_FALSE __UI_PropertyGridWheel(fs, 1), "Nothing to scroll"
    PropertyGrid_ShowAll fs, True
    PropertyGrid_Layout fs

    'Rows end before the scrollbar while there is one
    DIM gs AS LONG, sbX AS LONG
    gs = __UI_PGFind(fs)
    TEST_CHECK Control(rowTB(1)).Left + Control(rowTB(1)).Width <= __UI_PropertyGrids(gs).SbLeft - 3, "Rows make room for the scrollbar"

    'The scrollbar, part by part (mouse coordinates are the form's)
    sbX = Control(fs).Left + __UI_PropertyGrids(gs).SbLeft + __UI_ScrollbarWidth \ 2
    __UI_HoveringID = fs
    __UI_MouseLeft = sbX
    __UI_MouseTop = Control(fs).Top + __UI_PropertyGrids(gs).SbTop + __UI_PropertyGrids(gs).SbHeight - 4
    TestPGPress fs
    TEST_CHECK Control(rowTB(1)).Top = -12 _ANDALSO Control(rowTB(2)).Top = 10, "Down button scrolls a row"
    TestPGRelease
    __UI_MouseTop = Control(fs).Top + __UI_PropertyGrids(gs).SbTop + 3
    TestPGPress fs
    TEST_CHECK Control(rowTB(1)).Top = 10, "Up button scrolls back"
    TestPGRelease

    __UI_MouseTop = Control(fs).Top + __UI_PropertyGrids(gs).TrackTop + __UI_PropertyGrids(gs).TrackHeight - 2
    TestPGPress fs
    TEST_CHECK Control(rowTB(6)).Top = 74, "Clicking the track below the thumb pages down"
    TestPGRelease
    __UI_MouseTop = Control(fs).Top + __UI_PropertyGrids(gs).TrackTop + 1
    TestPGPress fs
    TEST_CHECK Control(rowTB(1)).Top = 10, "Clicking the track above the thumb pages up"
    TestPGRelease

    'Dragging the thumb: it keeps the spot where it was grabbed
    __UI_MouseTop = Control(fs).Top + __UI_PropertyGrids(gs).ThumbTop + 2
    TestPGPress fs
    TEST_CHECK __UI_PropertyGrids(gs).Dragging, "Thumb grabbed"
    TEST_CHECK Control(rowTB(1)).Top = 10, "Grabbing doesn't scroll"
    'Every pixel the thumb moves scrolls the rows, not just whole rows
    DIM room AS LONG
    room = __UI_PropertyGrids(gs).TrackHeight - __UI_PropertyGrids(gs).ThumbHeight
    __UI_MouseTop = __UI_MouseTop + 1
    __UI_PropertyGridsUpdate
    TEST_CHECK Control(rowTB(1)).Top < 10 _ANDALSO Control(rowTB(1)).Top > 10 - 22, "A small drag scrolls part of a row"
    TEST_CHECK __UI_PropertyGrids(gs).ScrollY = _ROUND(46 / room), "Scrolled in proportion"
    'Frames keep a picture of themselves: scrolling has to ask for a new one
    Control(fs).Redraw = False
    __UI_MouseTop = __UI_MouseTop + 1
    __UI_PropertyGridsUpdate
    TEST_CHECK Control(fs).Redraw, "Dragging the thumb redraws the frame"
    Control(fs).Redraw = False
    __UI_PropertyGridsUpdate
    TEST_CHECK_FALSE Control(fs).Redraw, "Nothing redrawn while the thumb stays put"
    __UI_HoveringID = rowTB(2)
    __UI_MouseDownOnID = 0
    __UI_MouseTop = Control(fs).Top + 500
    __UI_PropertyGridsUpdate
    TEST_CHECK Control(rowTB(6)).Top = 74, "Thumb dragged to the bottom, even off the scrollbar"
    __UI_MouseTop = Control(fs).Top - 500
    __UI_PropertyGridsUpdate
    TEST_CHECK Control(rowTB(1)).Top = 10, "And back to the top"
    TestPGRelease
    __UI_MouseTop = Control(fs).Top + 500
    __UI_PropertyGridsUpdate
    TEST_CHECK Control(rowTB(1)).Top = 10, "Releasing the button ends the drag"

    'A drag that leaves the frame's area before the screen updates still counts
    '(the engine forgets which control was pressed as soon as the mouse moves onto another one)
    __UI_HoveringID = fs
    __UI_MouseLeft = sbX
    __UI_MouseTop = Control(fs).Top + __UI_PropertyGrids(gs).ThumbTop + 2
    __UI_MouseIsDown = True
    __UI_MouseDownOnID = fs
    __UI_PropertyGridMouseDown
    __UI_MouseDownOnID = 0
    __UI_HoveringID = rowTB(3)
    __UI_MouseTop = Control(fs).Top + 500
    __UI_PropertyGridsUpdate
    TEST_CHECK Control(rowTB(6)).Top = 74, "Quick drag still moves the thumb"
    TestPGRelease
    PropertyGrid_ScrollTo fs, "r1"

    'Pressing elsewhere in the frame doesn't touch the scrollbar
    __UI_HoveringID = fs
    __UI_MouseLeft = Control(fs).Left + 5
    __UI_MouseTop = Control(fs).Top + __UI_PropertyGrids(gs).SbTop + __UI_PropertyGrids(gs).SbHeight - 4
    TestPGPress fs
    TEST_CHECK Control(rowTB(1)).Top = 10, "Press away from the scrollbar"
    TestPGRelease
    __UI_HoveringID = 0

    dd = PropertyGrid_Control(f, "color")
    __UI_Focus = dd
    TEST_CHECK_FALSE __UI_PropertyGridWheel(dd, 1), "A focused dropdown keeps the wheel"
    __UI_Focus = 0
    __UI_PropertyGridsUpdate
    __UI_DestroyControl Control(fs)

    TEST_CASE_END

    TEST_CASE_BEGIN "PropertyGrid: adopted rows make room for the scrollbar"

    DIM fa AS LONG, a1 AS LONG, a2 AS LONG, a3 AS LONG, side AS LONG, leftOfIt AS LONG
    'Two rows fit: 60 high, rows from 10, 4 pixels at the bottom
    fa = __UI_NewControl(__UI_Type_Frame, "TestPGRoom", 200, 60, 0, 0, 0)
    a1 = __UI_NewControl(__UI_Type_TextBox, "TestPGRoom1", 100, 23, 50, 0, fa)
    a2 = __UI_NewControl(__UI_Type_TextBox, "TestPGRoom2", 145, 23, 50, 0, fa)
    a3 = __UI_NewControl(__UI_Type_TextBox, "TestPGRoom3", 145, 23, 50, 0, fa)
    side = __UI_NewControl(__UI_Type_Button, "TestPGRoomSide", 40, 23, 155, 0, fa)
    leftOfIt = __UI_NewControl(__UI_Type_Button, "TestPGRoomLeft", 23, 23, 25, 0, fa)
    PropertyGrid_AdoptRow fa, "one", 0, a1
    PropertyGrid_AttachControl fa, "one", side
    PropertyGrid_AttachControl fa, "one", leftOfIt
    PropertyGrid_AdoptRow fa, "two", 0, a2
    PropertyGrid_AdoptRow fa, "three", 0, a3
    PropertyGrid_Layout fa
    gs = __UI_PGFind(fa)
    TEST_CHECK __UI_PropertyGrids(gs).MaxScrollY > 0, "Three rows don't fit"
    TEST_CHECK Control(a2).Left = 50 _ANDALSO Control(a2).Left + Control(a2).Width <= __UI_PropertyGrids(gs).SbLeft - 3, "Wide control narrowed, left kept"
    TEST_CHECK Control(side).Left + Control(side).Width <= __UI_PropertyGrids(gs).SbLeft - 3, "Control attached to its right slides left"
    TEST_CHECK Control(a1).Width = 100 - (195 - (__UI_PropertyGrids(gs).SbLeft - 3)), "The row's control narrows by as much"
    TEST_CHECK Control(leftOfIt).Left = 25, "Control attached to its left stays"
    PropertyGrid_Layout fa
    TEST_CHECK Control(a2).Width = 145 - (195 - (__UI_PropertyGrids(gs).SbLeft - 3)), "Laying out again doesn't narrow it more"

    PropertyGrid_ShowRow fa, "three", False
    PropertyGrid_Layout fa
    TEST_CHECK __UI_PropertyGrids(gs).MaxScrollY = 0, "Two rows fit"
    TEST_CHECK Control(a2).Width = 145 _ANDALSO Control(a1).Width = 100 _ANDALSO Control(side).Left = 155, "Everything back as it was"

    PropertyGrid_ShowRow fa, "three", True
    PropertyGrid_Layout fa
    PropertyGrid_DetachControl side
    TEST_CHECK Control(side).Left = 155, "Detaching puts it back"
    __UI_DestroyControl Control(fa)

    TEST_CASE_END

    TEST_CASE_BEGIN "PropertyGrid: rows written in the designer"

    DIM fd AS LONG, pKey AS STRING, pKind AS _BYTE, pLabel AS STRING, pExtra AS STRING
    TEST_CHECK __UI_PGParseLine(" size | integer | Size ", pKey, pKind, pLabel, pExtra), "Line parsed"
    TEST_CHECK pKey = "size" _ANDALSO pKind = __UI_PropertyGrid_Integer _ANDALSO pLabel = "Size" _ANDALSO pExtra = "", "Key, kind and label, trimmed"
    TEST_CHECK __UI_PGParseLine("Nickname", pKey, pKind, pLabel, pExtra), "Label-only line parsed"
    TEST_CHECK pKey = "Nickname" _ANDALSO pKind = __UI_PropertyGrid_Text _ANDALSO pLabel = "Nickname", "Label-only line is a text row"
    TEST_CHECK __UI_PGParseLine("c|CHOICE|Color|Red,Green|extra", pKey, pKind, pLabel, pExtra), "Choice line parsed"
    TEST_CHECK pKind = __UI_PropertyGrid_Choice _ANDALSO pExtra = "Red,Green|extra", "Kinds ignore case; the last field takes the rest"
    TEST_CHECK __UI_PGParseLine("x|toggle", pKey, pKind, pLabel, pExtra) _ANDALSO pLabel = "x", "Missing label falls back to the key"
    TEST_CHECK_FALSE __UI_PGParseLine("   ", pKey, pKind, pLabel, pExtra), "Blank line skipped"

    fd = __UI_NewControl(__UI_Type_Frame, "TestPGDesigned", 230, 300, 0, 0, 0)
    'As saved in a .frm file (\10; line breaks) and typed in code (\n)
    Text(fd) = "size|integer|Size\10;color|choice|Color|Red,Green,Blue\n\nfilled|toggle|Filled" + CHR$(13) + CHR$(10) + "reset|button|Defaults|Reset\10;Notes"
    __UI_PropertyGridsFromForm
    TEST_CHECK Control(PropertyGrid_Control(fd, "size")).Type = __UI_Type_TextBox, "Integer row built"
    TEST_CHECK GetItem(PropertyGrid_Control(fd, "color"), 3) = "Blue", "Choice items built"
    TEST_CHECK Control(PropertyGrid_Control(fd, "filled")).Type = __UI_Type_CheckBox, "Toggle row built"
    TEST_CHECK Caption(PropertyGrid_Control(fd, "reset")) = "Reset", "Button caption"
    TEST_CHECK Caption(PropertyGrid_LabelControl(fd, "notes")) = "Notes", "Label-only row built"
    PropertyGrid_Layout fd
    TEST_CHECK Control(PropertyGrid_Control(fd, "filled")).Top = 54, "Blank lines leave no gap"
    pKey = STR$(PropertyGrid_Control(fd, "size"))
    __UI_PropertyGridsFromForm
    TEST_CHECK PropertyGrid_Control(fd, "size") = VAL(pKey), "Building twice changes nothing"
    __UI_DestroyControl Control(fd)

    'The last field is the starting value of text, number and toggle rows
    fd = __UI_NewControl(__UI_Type_Frame, "TestPGStart", 230, 300, 0, 0, 0)
    Text(fd) = "n|integer|N|4.6\nf|float|F|2.50\non|toggle|On|-1\noff|toggle|Off|0\nt|text|T|hello\nz|integer|Z"
    __UI_PropertyGridsFromForm
    TEST_CHECK PropertyGrid_Value(fd, "n") = "5" _ANDALSO Text(PropertyGrid_Control(fd, "n")) = "5", "An integer row starts rounded"
    TEST_CHECK PropertyGrid_Value(fd, "f") = "2.5", "A float row starts with its number"
    TEST_CHECK Control(PropertyGrid_Control(fd, "on")).Value <> 0 _ANDALSO Control(PropertyGrid_Control(fd, "off")).Value = 0, "A toggle starts checked when it isn't 0"
    TEST_CHECK PropertyGrid_Value(fd, "t") = "hello", "A text row starts with its text"
    TEST_CHECK PropertyGrid_Value(fd, "z") = "0", "Without a value, a number row starts at 0"
    __UI_DestroyControl Control(fd)

    TEST_CASE_END

    TEST_CASE_BEGIN "PropertyGrid: destroying controls"

    __UI_DestroyControl Control(sz)
    TEST_CHECK PropertyGrid_Control(f, "size") = 0, "Destroyed control's row is gone"
    PropertyGrid_Layout f
    TEST_CHECK Control(dd).Top = 32, "Other rows close the gap"

    __UI_DestroyControl Control(f)
    TEST_CHECK PropertyGrid_Control(f, "name") = 0, "Destroyed frame's rows are gone"
    TEST_CHECK PropertyGrid_GridOf(tb) = 0, "Its controls no longer belong to a grid"
    events = TestValueChangedCount
    Control(dd).Value = 1
    __UI_PropertyGridsUpdate
    TEST_CHECK TestValueChangedCount = events, "A forgotten grid fires nothing"

    TEST_CASE_END
END SUB

''' @brief Presses a key in the focused control, as far as data grids are concerned. Returns what's left of the key.
FUNCTION TestDGKey& (k AS LONG)
    __UI_KeyHit = k
    __UI_DataGridKey
    TestDGKey = __UI_KeyHit
    __UI_KeyHit = 0
END FUNCTION

''' @brief Presses and releases the mouse button at a point of a frame (in the frame's coordinates).
SUB TestDGClick (id AS LONG, x AS LONG, y AS LONG)
    __UI_MouseLeft = Control(id).Left + x
    __UI_MouseTop = Control(id).Top + y
    __UI_HoveringID = id
    __UI_Focus = id
    __UI_MouseIsDown = True
    __UI_MouseDownOnID = id
    __UI_DataGridMouseDown
    __UI_DataGridsUpdate
    __UI_MouseIsDown = False
    __UI_MouseDownOnID = 0
    __UI_DataGridsUpdate
END SUB

SUB Test_DataGrid
    DIM g AS LONG, r AS LONG, ed AS LONG, events AS LONG, i AS LONG, k AS LONG

    TEST_CASE_BEGIN "DataGrid: columns and rows"

    'No border and the default font: rows (and the header) are 24 high, rows start at 25
    g = __UI_NewControl(__UI_Type_Frame, "TestDG", 300, 100, 0, 0, 0)
    Control(g).HasBorder = False
    DataGrid_AddTextColumn g, "Name", 100
    DataGrid_AddChoiceColumn g, "Color", 80, "Red|Green|Blue"
    DataGrid_AddIntegerColumn g, "Size", 60
    DataGrid_AddToggleColumn g, "On", 0
    TEST_CHECK DataGrid_ColumnCount(g) = 4, "Four columns"
    TEST_CHECK Control(g).CanHaveFocus, "A grid can have focus"
    TEST_CHECK DataGrid_RowCount(g) = 0, "No rows yet"

    r = DataGrid_AddRow(g, "apple|Red|3|-1")
    TEST_CHECK r = 1, "First row"
    r = DataGrid_AddRow(g, "pear")
    TEST_CHECK r = 2, "Second row"
    TEST_CHECK DataGrid_Cell(g, 1, 1) = "apple" _ANDALSO DataGrid_Cell(g, 1, 4) = "-1", "Cells from a list"
    TEST_CHECK DataGrid_Cell(g, 2, 2) = "Red", "A choice starts on its first item"
    TEST_CHECK DataGrid_Cell(g, 2, 3) = "0" _ANDALSO DataGrid_Cell(g, 2, 4) = "0", "Numbers and toggles start at 0"
    r = DataGrid_InsertRow(g, 1, "fig|Blue|7|0")
    TEST_CHECK r = 1 _ANDALSO DataGrid_Cell(g, 1, 1) = "fig" _ANDALSO DataGrid_Cell(g, 2, 1) = "apple", "Insert before a row"
    DataGrid_SetCell g, 3, 1, "a|b"
    TEST_CHECK DataGrid_Cell(g, 3, 1) = "a|b", "A cell can hold anything set directly"
    TEST_CHECK DataGrid_Cell(g, 9, 1) = "" _ANDALSO DataGrid_Cell(g, 1, 9) = "", "Missing cells are empty"

    DataGrid_Select g, 2, 1
    TEST_CHECK DataGrid_Row(g) = 2 _ANDALSO DataGrid_Column(g) = 1, "Select a cell"
    DataGrid_MoveRow g, 2, 3
    TEST_CHECK DataGrid_Cell(g, 3, 1) = "apple" _ANDALSO DataGrid_Cell(g, 2, 1) = "a|b", "Move a row down"
    TEST_CHECK DataGrid_Row(g) = 3, "The current cell goes with its row"
    DataGrid_MoveRow g, 3, 1
    TEST_CHECK DataGrid_Cell(g, 1, 1) = "apple" _ANDALSO DataGrid_Cell(g, 2, 1) = "fig", "Move a row to the top"
    DataGrid_RemoveRow g, 1
    TEST_CHECK DataGrid_RowCount(g) = 2 _ANDALSO DataGrid_Cell(g, 1, 1) = "fig", "Remove a row"
    TEST_CHECK DataGrid_Row(g) = 1, "The current cell stays on the same row number"
    DataGrid_RemoveRow g, 2
    DataGrid_RemoveRow g, 1
    TEST_CHECK DataGrid_RowCount(g) = 0 _ANDALSO DataGrid_Row(g) = 0, "No rows, no current cell"
    r = DataGrid_AddRow(g, "kiwi")
    TEST_CHECK DataGrid_Cell(g, 1, 1) = "kiwi", "Places of removed rows are used again"
    DataGrid_Clear g
    TEST_CHECK DataGrid_RowCount(g) = 0, "Clear"

    TEST_CASE_END

    TEST_CASE_BEGIN "DataGrid: keyboard"

    FOR i = 1 TO 6
        r = DataGrid_AddRow(g, "row" + LTRIM$(STR$(i)) + "|Green|" + LTRIM$(STR$(i)) + "|0")
    NEXT
    __UI_Focus = g
    TestValueChangedCount = 0
    k = TestDGKey(_KEY_DOWN)
    TEST_CHECK DataGrid_Row(g) = 1 _ANDALSO DataGrid_Column(g) = 1, "The first key picks the first cell"
    TEST_CHECK TestValueChangedCount = 1 _ANDALSO TestValueChangedID = g, "Moving fires __UI_ValueChanged on the frame"
    TEST_CHECK DataGrid_ChangedColumn(g) = 0 _ANDALSO DataGrid_ChangedRow(g) = 1, "Column 0: the current cell moved"
    k = TestDGKey(_KEY_DOWN)
    k = TestDGKey(_KEY_RIGHT)
    TEST_CHECK DataGrid_Row(g) = 2 _ANDALSO DataGrid_Column(g) = 2, "Arrows move"
    TEST_CHECK k = _KEY_RIGHT, "Arrows still reach __UI_KeyPress"
    k = TestDGKey(_KEY_END)
    TEST_CHECK DataGrid_Column(g) = 4, "End goes to the last column"
    k = TestDGKey(_KEY_HOME)
    TEST_CHECK DataGrid_Column(g) = 1, "Home goes to the first column"
    k = TestDGKey(_KEY_PAGEDOWN)
    TEST_CHECK DataGrid_Row(g) = 4, "Page down moves by a page (3 rows show, so 2)"
    k = TestDGKey(_KEY_PAGEDOWN)
    k = TestDGKey(_KEY_PAGEDOWN)
    TEST_CHECK DataGrid_Row(g) = 6, "Not past the last row"
    __UI_DataGridsUpdate
    TEST_CHECK __UI_DataGrids(__UI_DGFind(g)).TopRow = 3, "The current row is scrolled into view"
    k = TestDGKey(_KEY_UP)
    TEST_CHECK __UI_DataGrids(__UI_DGFind(g)).TopRow = 3, "A row in view doesn't scroll"
    DataGrid_Select g, 1, 1
    TEST_CHECK __UI_DataGrids(__UI_DGFind(g)).TopRow = 0, "Selecting a row above scrolls up"

    'Tab goes from cell to cell, and out of the grid past the last one
    __UI_KeyHit = 9
    TEST_CHECK __UI_DataGridTab, "Tab moves to the next cell"
    TEST_CHECK DataGrid_Column(g) = 2, "Next cell"
    DataGrid_Select g, 6, 4
    TEST_CHECK_FALSE __UI_DataGridTab, "Tab on the last cell leaves the grid"
    __UI_KeyHit = 0

    TEST_CASE_END

    TEST_CASE_BEGIN "DataGrid: editing"

    DataGrid_Select g, 2, 1
    __UI_Focus = g
    TestValueChangedCount = 0
    k = TestDGKey(13)
    TEST_CHECK DataGrid_IsEditing(g), "Enter starts editing"
    ed = __UI_Focus
    TEST_CHECK Control(ed).Type = __UI_Type_TextBox _ANDALSO Control(ed).ParentID = g, "A box in the frame"
    TEST_CHECK DataGrid_GridOf(ed) = g _ANDALSO DataGrid_GridOf(g) = g, "The box belongs to the grid"
    TEST_CHECK Text(ed) = "row2" _ANDALSO Control(ed).TextIsSelected, "It holds the cell, selected"
    'Row 2 shows at the top (the grid was scrolled down to row 6, then up just enough for row 2)
    TEST_CHECK Control(ed).Top = 25 - 1 _ANDALSO Control(ed).Left = 0 _ANDALSO Control(ed).Width = 100 + 1, "It sits on the cell"
    TEST_CHECK TestDGKey(-13) = 0, "Releasing Enter doesn't click the default button"
    Text(ed) = "changed"
    k = TestDGKey(13)
    TEST_CHECK_FALSE DataGrid_IsEditing(g), "Enter ends editing"
    TEST_CHECK __UI_Focus = g _ANDALSO Control(ed).Hidden, "The grid has focus again"
    TEST_CHECK DataGrid_Cell(g, 2, 1) = "changed", "The new value is kept"
    TEST_CHECK TestValueChangedCount = 1 _ANDALSO DataGrid_ChangedRow(g) = 2 _ANDALSO DataGrid_ChangedColumn(g) = 1, "Its change fires __UI_ValueChanged"

    k = TestDGKey(13)
    Text(ed) = "dropped"
    k = TestDGKey(27)
    TEST_CHECK DataGrid_Cell(g, 2, 1) = "changed" _ANDALSO TestValueChangedCount = 1, "Esc puts the old value back"

    k = TestDGKey(ASC("x"))
    TEST_CHECK DataGrid_IsEditing(g) _ANDALSO Text(ed) = "x" _ANDALSO k = 0, "Typing starts editing with that key"
    __UI_Focus = 0
    __UI_DataGridsUpdate
    TEST_CHECK_FALSE DataGrid_IsEditing(g), "Leaving the box ends editing"
    TEST_CHECK DataGrid_Cell(g, 2, 1) = "x", "and keeps what was typed"

    __UI_Focus = g
    DataGrid_Select g, 2, 3
    k = TestDGKey(ASC("a"))
    TEST_CHECK_FALSE DataGrid_IsEditing(g), "Letters don't start editing a number"
    k = TestDGKey(ASC("4"))
    Text(ed) = "4.6"
    k = TestDGKey(_KEY_DOWN)
    TEST_CHECK DataGrid_Cell(g, 2, 3) = "5", "Integers are rounded"
    TEST_CHECK DataGrid_Row(g) = 3 _ANDALSO NOT DataGrid_IsEditing(g), "Down keeps the value and moves down"
    k = TestDGKey(_KEY_DELETE)
    TEST_CHECK DataGrid_Cell(g, 3, 3) = "0", "Delete clears a number to 0"

    DataGrid_Select g, 3, 4
    k = TestDGKey(32)
    TEST_CHECK DataGrid_Cell(g, 3, 4) = "-1", "Space checks a toggle"
    k = TestDGKey(32)
    TEST_CHECK DataGrid_Cell(g, 3, 4) = "0", "and unchecks it"

    DataGrid_Select g, 3, 2
    k = TestDGKey(ASC("b"))
    TEST_CHECK DataGrid_Cell(g, 3, 2) = "Blue", "A letter picks the next item starting with it"
    k = TestDGKey(ASC("r"))
    TEST_CHECK DataGrid_Cell(g, 3, 2) = "Red", "Another letter, another item"

    TEST_CASE_END

    TEST_CASE_BEGIN "DataGrid: mouse"

    __UI_Focus = g
    DataGrid_Select g, 1, 1
    __UI_DataGridsUpdate
    TestValueChangedCount = 0
    'Row 1 is at 25..48, column 3 at 181..240 (100 + 80 + 1)
    TestDGClick g, 200, 30
    TEST_CHECK DataGrid_Row(g) = 1 _ANDALSO DataGrid_Column(g) = 3, "A click picks a cell"
    TEST_CHECK_FALSE DataGrid_IsEditing(g), "but doesn't edit it"
    TestDGClick g, 200, 30
    TEST_CHECK DataGrid_IsEditing(g), "Clicking the current cell again edits it"
    TestDGClick g, 50, 55
    TEST_CHECK_FALSE DataGrid_IsEditing(g), "Clicking elsewhere ends editing"
    TEST_CHECK DataGrid_Row(g) = 2 _ANDALSO DataGrid_Column(g) = 1, "and picks that cell"
    TestDGClick g, 270, 55
    TEST_CHECK DataGrid_Cell(g, 2, 4) = "-1", "A click on a toggle flips it"
    TestDGClick g, 50, 10
    TEST_CHECK DataGrid_Row(g) = 2, "A click on the header doesn't move"

    'Six rows, three show: a scrollbar at the right
    TEST_CHECK __UI_DataGrids(__UI_DGFind(g)).MaxTopRow = 3, "Three rows don't fit"
    TEST_CHECK __UI_DataGridWheel(g, 1), "The wheel scrolls"
    TEST_CHECK __UI_DataGrids(__UI_DGFind(g)).TopRow = 3, "three rows a notch"
    Control(g).Redraw = False
    __UI_DataGridsUpdate
    TEST_CHECK Control(g).Redraw, "Scrolling redraws the frame"
    Control(g).Redraw = False
    __UI_DataGridsUpdate
    TEST_CHECK_FALSE Control(g).Redraw, "Nothing redrawn when nothing changed"
    TEST_CHECK __UI_DataGridWheel(g, -5), "Wheel back up"
    TEST_CHECK __UI_DataGrids(__UI_DGFind(g)).TopRow = 0, "Back at the top"
    TestDGClick g, 300 - 5, 100 - 8
    TEST_CHECK __UI_DataGrids(__UI_DGFind(g)).TopRow = 1, "The scrollbar's down button scrolls a row"

    TEST_CASE_END

    TEST_CASE_BEGIN "DataGrid: the row cut off at the bottom"

    'Rows 25..96 show whole; the next row starts at 97 and is cut off at 99
    DataGrid_Select g, 1, 1
    TEST_CHECK __UI_DataGrids(__UI_DGFind(g)).TopRow = 0, "Scrolled to the top"
    TestDGClick g, 50, 98
    TEST_CHECK DataGrid_Row(g) = 4, "A click on the row cut off picks it"
    TEST_CHECK __UI_DataGrids(__UI_DGFind(g)).TopRow = 1, "and scrolls it into full view"

    TEST_CASE_END

    TEST_CASE_BEGIN "DataGrid: selecting rows"

    __UI_Focus = g
    DataGrid_Select g, 2, 1
    TEST_CHECK DataGrid_SelectionFirst(g) = 2 _ANDALSO DataGrid_SelectionLast(g) = 2, "The current row is selected"
    __UI_ShiftIsDown = True
    k = TestDGKey(_KEY_DOWN)
    k = TestDGKey(_KEY_DOWN)
    __UI_ShiftIsDown = False
    TEST_CHECK DataGrid_Row(g) = 4, "Shift+Down moves the current cell"
    TEST_CHECK DataGrid_SelectionFirst(g) = 2 _ANDALSO DataGrid_SelectionLast(g) = 4, "and selects the rows on the way"
    TEST_CHECK DataGrid_RowSelected(g, 3) _ANDALSO NOT DataGrid_RowSelected(g, 5), "Rows in the range"
    k = TestDGKey(_KEY_DELETE)
    TEST_CHECK k = _KEY_DELETE _ANDALSO DataGrid_Cell(g, 4, 1) = "row4", "Delete with several rows selected is left to the program"
    k = TestDGKey(_KEY_UP)
    TEST_CHECK DataGrid_SelectionFirst(g) = 3 _ANDALSO DataGrid_SelectionLast(g) = 3, "Moving without Shift leaves one row selected"

    __UI_ShiftIsDown = True
    k = TestDGKey(_KEY_UP)
    __UI_ShiftIsDown = False
    TEST_CHECK DataGrid_SelectionFirst(g) = 2 _ANDALSO DataGrid_SelectionLast(g) = 3, "Selecting upwards"

    'Shift+click
    DataGrid_Select g, 1, 1
    __UI_DataGridsUpdate
    __UI_ShiftIsDown = True
    TestDGClick g, 50, 80
    __UI_ShiftIsDown = False
    TEST_CHECK DataGrid_Row(g) = 3 _ANDALSO DataGrid_SelectionFirst(g) = 1 _ANDALSO DataGrid_SelectionLast(g) = 3, "Shift+click selects a range"
    TEST_CHECK_FALSE DataGrid_IsEditing(g), "Shift+click doesn't edit"

    'Dragging from row 1 down to row 2
    __UI_MouseLeft = Control(g).Left + 50
    __UI_MouseTop = Control(g).Top + 30
    __UI_HoveringID = g
    __UI_MouseIsDown = True
    __UI_MouseDownOnID = g
    __UI_DataGridMouseDown
    __UI_DataGridsUpdate
    TEST_CHECK DataGrid_SelectionFirst(g) = 1 _ANDALSO DataGrid_SelectionLast(g) = 1, "A press picks one row"
    __UI_MouseTop = Control(g).Top + 55
    __UI_DataGridsUpdate
    TEST_CHECK DataGrid_Row(g) = 2 _ANDALSO DataGrid_SelectionFirst(g) = 1 _ANDALSO DataGrid_SelectionLast(g) = 2, "Dragging selects rows"
    __UI_MouseTop = Control(g).Top + 200
    __UI_DataGridsUpdate
    TEST_CHECK DataGrid_Row(g) = 4 _ANDALSO __UI_DataGrids(__UI_DGFind(g)).TopRow = 1, "Dragging below scrolls a row at a time"
    __UI_MouseIsDown = False
    __UI_MouseDownOnID = 0
    __UI_DataGridsUpdate
    TEST_CHECK_FALSE DataGrid_IsEditing(g), "A drag doesn't edit"

    'Moving and removing the selection
    DataGrid_SelectRows g, 2, 3
    TEST_CHECK DataGrid_Row(g) = 3 _ANDALSO DataGrid_SelectionFirst(g) = 2 _ANDALSO DataGrid_SelectionLast(g) = 3, "Select rows from code"
    DIM c1 AS STRING, c2 AS STRING, c3 AS STRING, rows AS LONG
    c1 = DataGrid_Cell(g, 1, 1): c2 = DataGrid_Cell(g, 2, 1): c3 = DataGrid_Cell(g, 3, 1)
    DataGrid_MoveSelection g, -1
    TEST_CHECK DataGrid_Cell(g, 1, 1) = c2 _ANDALSO DataGrid_Cell(g, 2, 1) = c3 _ANDALSO DataGrid_Cell(g, 3, 1) = c1, "Move the selected rows up"
    TEST_CHECK DataGrid_SelectionFirst(g) = 1 _ANDALSO DataGrid_SelectionLast(g) = 2 _ANDALSO DataGrid_Row(g) = 2, "They stay selected"
    DataGrid_MoveSelection g, -1
    TEST_CHECK DataGrid_Cell(g, 1, 1) = c2, "Not past the top"
    DataGrid_MoveSelection g, 1
    TEST_CHECK DataGrid_Cell(g, 1, 1) = c1 _ANDALSO DataGrid_Cell(g, 2, 1) = c2 _ANDALSO DataGrid_Cell(g, 3, 1) = c3, "and back down"
    rows = DataGrid_RowCount(g)
    DataGrid_RemoveSelection g
    TEST_CHECK DataGrid_RowCount(g) = rows - 2 _ANDALSO DataGrid_Cell(g, 1, 1) = c1, "Remove the selected rows"
    TEST_CHECK DataGrid_Row(g) = 2 _ANDALSO DataGrid_SelectionLast(g) = 2, "The row after them is current"

    TEST_CASE_END

    TEST_CASE_BEGIN "DataGrid: a cell's own kind"

    r = DataGrid_InsertRow(g, 1, "own")
    TEST_CHECK DataGrid_CellKind(g, 1, 1) = __UI_DataGrid_Text, "A cell has its column's kind"
    DataGrid_SetCellKind g, 1, 1, __UI_DataGrid_Toggle
    TEST_CHECK DataGrid_CellKind(g, 1, 1) = __UI_DataGrid_Toggle _ANDALSO DataGrid_CellKind(g, 2, 1) = __UI_DataGrid_Text, "until it gets one of its own"
    TEST_CHECK DataGrid_Cell(g, 1, 1) = "own", "Its value isn't changed"
    DataGrid_SetCell g, 1, 1, "0"
    DataGrid_Select g, 1, 1
    __UI_Focus = g
    events = TestValueChangedCount
    k = TestDGKey(32)
    TEST_CHECK DataGrid_Cell(g, 1, 1) = "-1" _ANDALSO NOT DataGrid_IsEditing(g), "Space flips it like a toggle column's"
    TEST_CHECK TestValueChangedCount = events + 1, "and fires __UI_ValueChanged"
    DataGrid_MoveRow g, 1, 2
    TEST_CHECK DataGrid_CellKind(g, 2, 1) = __UI_DataGrid_Toggle _ANDALSO DataGrid_CellKind(g, 1, 1) = __UI_DataGrid_Text, "The kind moves with its row"
    DataGrid_SetCellKind g, 2, 1, __UI_DataGrid_Integer
    DataGrid_Select g, 2, 1
    k = TestDGKey(ASC("4"))
    k = TestDGKey(ASC("."))
    k = TestDGKey(ASC("6"))
    Text(__UI_Focus) = "4.6"
    k = TestDGKey(13)
    TEST_CHECK DataGrid_Cell(g, 2, 1) = "5", "An integer cell rounds what's typed"
    DataGrid_SetCellKind g, 2, 1, 0
    TEST_CHECK DataGrid_CellKind(g, 2, 1) = __UI_DataGrid_Text, "0 gives it its column's kind back"
    DataGrid_RemoveRow g, 2
    r = DataGrid_AddRow(g, "new")
    TEST_CHECK DataGrid_CellKind(g, r, 1) = __UI_DataGrid_Text, "A new row in a reused place starts with its columns' kinds"
    DataGrid_RemoveRow g, r

    TEST_CASE_END

    TEST_CASE_BEGIN "DataGrid: destroying the frame"

    events = TestValueChangedCount
    __UI_DestroyControl Control(g)
    TEST_CHECK __UI_DGFind(g) = 0, "The grid goes with its frame"
    TEST_CHECK Control(ed).ID = 0, "and so does its box"
    __UI_DataGridsUpdate
    TEST_CHECK TestValueChangedCount = events, "A forgotten grid fires nothing"

    TEST_CASE_END
    __UI_Focus = 0
END SUB

SUB Test_DataGridScrolling
    DIM g AS LONG, r AS LONG, i AS LONG, k AS LONG, dg AS LONG, cols AS LONG, x AS LONG, y AS LONG

    TEST_CASE_BEGIN "DataGrid: sideways scrolling"

    'Four 80-pixel columns don't fit in 200 pixels
    g = __UI_NewControl(__UI_Type_Frame, "TestDGWide", 200, 150, 0, 0, 0)
    Control(g).HasBorder = False
    FOR i = 1 TO 4
        DataGrid_AddTextColumn g, "C" + LTRIM$(STR$(i)), 80
    NEXT
    r = DataGrid_AddRow(g, "a1|a2|a3|a4")
    r = DataGrid_AddRow(g, "b1|b2|b3|b4")
    dg = __UI_DGFind(g)
    __UI_DGMeasure dg
    TEST_CHECK __UI_DataGrids(dg).MaxLeftCol = 2, "Columns that don't fit scroll (two have to go for the last two to show)"
    TEST_CHECK __UI_DataGrids(dg).BodyBottom = __UI_DataGrids(dg).AreaBottom - __UI_ScrollbarWidth, "The horizontal scrollbar takes room from the rows"
    TEST_CHECK __UI_DataGrids(dg).LeftCol = 0, "Starts at the first column"

    DataGrid_Select g, 1, 4
    TEST_CHECK __UI_DataGrids(dg).LeftCol = 2, "Selecting a column out of view scrolls to it"
    TEST_CHECK __UI_DataGridCols(__UI_DGCol(dg, 4)).Right <= __UI_DGContentRight(dg), "and it shows whole"
    TEST_CHECK_FALSE __UI_DGColInView(dg, 1), "The first column is scrolled out"
    DataGrid_Select g, 1, 2
    TEST_CHECK __UI_DataGrids(dg).LeftCol = 1, "Going back left scrolls to the column"

    DataGrid_Select g, 1, 1
    __UI_Focus = g
    k = TestDGKey(_KEY_RIGHT)
    k = TestDGKey(_KEY_RIGHT)
    TEST_CHECK DataGrid_Column(g) = 3 _ANDALSO __UI_DataGrids(dg).LeftCol = 1, "Arrow keys scroll sideways"
    k = TestDGKey(_KEY_HOME)
    TEST_CHECK __UI_DataGrids(dg).LeftCol = 0, "Home scrolls back"

    'A click on the scrollbar's right button scrolls a column; the scrollbar isn't a cell
    __UI_DGMeasure dg
    x = __UI_DataGrids(dg).HbLeft + __UI_DataGrids(dg).HbWidth - 4
    y = __UI_DataGrids(dg).HbTop + 4
    TEST_CHECK __UI_DGHScrollbarPart(dg, x, y) = 2, "The right button is at the scrollbar's end"
    TestDGClick g, x, y
    TEST_CHECK __UI_DataGrids(dg).LeftCol = 1, "Clicking it scrolls a column"
    TEST_CHECK DataGrid_Row(g) = 1 _ANDALSO DataGrid_Column(g) = 1, "and doesn't move the current cell"
    TestDGClick g, __UI_DataGrids(dg).HbLeft + 3, y
    TEST_CHECK __UI_DataGrids(dg).LeftCol = 0, "The left button scrolls back"

    'The wheel scrolls sideways with Shift, or when every row fits
    TEST_CHECK __UI_DataGridWheel(g, 1), "The wheel scrolls"
    TEST_CHECK __UI_DataGrids(dg).LeftCol = 1, "sideways, when every row fits"
    FOR i = 1 TO 10
        r = DataGrid_AddRow(g, "")
    NEXT
    TEST_CHECK __UI_DataGridWheel(g, 1) _ANDALSO __UI_DataGrids(dg).LeftCol = 1 _ANDALSO __UI_DataGrids(dg).TopRow > 0, "With rows to scroll, the wheel scrolls them"
    __UI_ShiftIsDown = True
    TEST_CHECK __UI_DataGridWheel(g, -1) _ANDALSO __UI_DataGrids(dg).LeftCol = 0, "and Shift+wheel scrolls sideways"
    __UI_ShiftIsDown = False

    'Room enough: no sideways scrolling
    Control(g).Width = 400
    __UI_DGMeasure dg
    TEST_CHECK __UI_DataGrids(dg).MaxLeftCol = 0, "Columns that fit don't scroll"

    TEST_CASE_END

    TEST_CASE_BEGIN "DataGrid: removing columns and row tags"

    DataGrid_Clear g
    r = DataGrid_AddRow(g, "a1|a2|a3|a4")
    r = DataGrid_AddRow(g, "b1|b2|b3|b4")
    DataGrid_SetCellKind g, 1, 3, __UI_DataGrid_Toggle
    DataGrid_Select g, 2, 4
    cols = __UI_TotalDataGridCols
    DataGrid_RemoveColumn g, 2
    TEST_CHECK DataGrid_ColumnCount(g) = 3, "A column is removed"
    TEST_CHECK DataGrid_Cell(g, 1, 2) = "a3" _ANDALSO DataGrid_Cell(g, 2, 3) = "b4", "and its cells, in every row"
    TEST_CHECK DataGrid_CellKind(g, 1, 2) = __UI_DataGrid_Toggle, "A cell's own kind moves with it"
    TEST_CHECK DataGrid_Column(g) = 3, "The current cell stays on its column"
    DataGrid_AddTextColumn g, "New", 0
    TEST_CHECK __UI_TotalDataGridCols = cols, "A new column takes the removed one's place"
    TEST_CHECK DataGrid_Cell(g, 1, 4) = "", "and starts empty"

    TEST_CHECK DataGrid_RowTag(g, 1) = "", "Rows have no tag at first"
    DataGrid_SetRowTag g, 1, "first"
    DataGrid_MoveRow g, 1, 2
    TEST_CHECK DataGrid_RowTag(g, 2) = "first" _ANDALSO DataGrid_RowTag(g, 1) = "", "A tag moves with its row"
    DataGrid_RemoveRow g, 2
    r = DataGrid_AddRow(g, "")
    TEST_CHECK DataGrid_RowTag(g, r) = "", "A new row has no tag, even in a reused place"

    __UI_DestroyControl Control(g)
    TEST_CASE_END
    __UI_Focus = 0
END SUB

SUB Test_DataGridDefinitions
    DIM f AS LONG, f2 AS LONG, dg AS LONG

    TEST_CASE_BEGIN "DataGrid: grids written in the designer"

    TEST_CHECK __UI_IsDataGridDefinition("#columns\nName"), "A definition starts with #columns"
    TEST_CHECK __UI_IsDataGridDefinition(CHR$(10) + "  #Columns " + CHR$(10) + "Name"), "after blank lines, in any case"
    TEST_CHECK_FALSE __UI_IsDataGridDefinition("name|text|Name"), "Property grid rows aren't one"
    TEST_CHECK_FALSE __UI_IsDataGridDefinition(""), "Nor is empty text"

    f = __UI_NewControl(__UI_Type_Frame, "TestDGDef", 300, 150, 0, 0, 0)
    Text(f) = "#columns\nName|text|100\nColor|choice|80|Red,Green\nQty|integer\n#rows\napple|Green|3\n\npear\n\n"
    __UI_PropertyGridsFromForm
    TEST_CHECK __UI_PGFind(f) = 0, "A grid definition doesn't make property grid rows"
    __UI_DataGridsFromForm
    dg = __UI_DGFind(f)
    TEST_CHECK dg > 0, "The frame becomes a data grid when the program starts"
    TEST_CHECK Control(f).CanHaveFocus, "that can have focus"
    TEST_CHECK DataGrid_ColumnCount(f) = 3, "with its columns"
    TEST_CHECK __UI_DataGridColCaption(__UI_DGCol(dg, 2)) = "Color" _ANDALSO __UI_DataGridCols(__UI_DGCol(dg, 1)).Width = 100, "Captions and widths"
    TEST_CHECK DataGrid_CellKind(f, 1, 2) = __UI_DataGrid_Choice _ANDALSO __UI_DataGridColItems(__UI_DGCol(dg, 2)) = "Red|Green", "Kinds and items"
    TEST_CHECK __UI_DataGridCols(__UI_DGCol(dg, 3)).Width = 0 _ANDALSO DataGrid_CellKind(f, 1, 3) = __UI_DataGrid_Integer, "A width left out shares the room"
    TEST_CHECK DataGrid_RowCount(f) = 3, "and rows: a blank line between rows is a row, blank lines at the end aren't"
    TEST_CHECK DataGrid_Cell(f, 1, 2) = "Green" _ANDALSO DataGrid_Cell(f, 1, 3) = "3", "Cells"
    TEST_CHECK DataGrid_Cell(f, 3, 1) = "pear" _ANDALSO DataGrid_Cell(f, 3, 2) = "Red" _ANDALSO DataGrid_Cell(f, 3, 3) = "0", "Cells left out get their column's default"
    __UI_DestroyControl Control(f)

    'In the designer, the grid follows the frame's Text
    __UI_DesignMode = True
    f2 = __UI_NewControl(__UI_Type_Frame, "TestDGDesign", 300, 150, 0, 0, 0)
    Control(f2).CanHaveFocus = False
    Text(f2) = "#columns" + CHR$(10) + "A" + CHR$(10) + "B" + CHR$(10) + "#rows" + CHR$(10) + "1|2"
    __UI_DataGridsUpdate
    TEST_CHECK DataGrid_ColumnCount(f2) = 2 _ANDALSO DataGrid_RowCount(f2) = 1, "The designer shows the grid"
    TEST_CHECK_FALSE Control(f2).CanHaveFocus, "without changing the frame's settings"
    Text(f2) = Text(f2) + CHR$(10) + "3|4"
    __UI_DataGridsUpdate
    TEST_CHECK DataGrid_RowCount(f2) = 2 _ANDALSO DataGrid_Cell(f2, 2, 2) = "4", "A changed Text builds it again"
    Text(f2) = "key|text|Label"
    __UI_DataGridsUpdate
    TEST_CHECK __UI_DGFind(f2) = 0, "Text that isn't a grid definition puts the frame back"
    __UI_DestroyControl Control(f2)
    __UI_DesignMode = False

    TEST_CASE_END
END SUB

SUB Test_DataGridCSV
    DIM g AS LONG, g2 AS LONG, n AS LONG, csv AS STRING, nl AS STRING, f AS STRING

    TEST_CASE_BEGIN "DataGrid: CSV"
    nl = CHR$(13) + CHR$(10)

    g = __UI_NewControl(__UI_Type_Frame, "TestDGCSV", 300, 150, 0, 0, 0)
    DataGrid_AddTextColumn g, "Name", 0
    DataGrid_AddChoiceColumn g, "Color", 80, "Red|Green|Blue"
    DataGrid_AddIntegerColumn g, "Qty", 50
    DataGrid_AddToggleColumn g, "On", 40

    'Without a header, fields go to the columns in order
    n = DataGrid_FromCSV(g, "apple,Green,3,yes" + nl + nl + "pear" + CHR$(10) + "fig,Blue,2.6,0", 0)
    TEST_CHECK n = 3 _ANDALSO DataGrid_RowCount(g) = 3, "Rows from lines; blank lines are left out"
    TEST_CHECK DataGrid_Cell(g, 1, 1) = "apple" _ANDALSO DataGrid_Cell(g, 1, 2) = "Green" _ANDALSO DataGrid_Cell(g, 1, 4) = "-1", "Cells from fields; yes checks a toggle"
    TEST_CHECK DataGrid_Cell(g, 2, 2) = "Red" _ANDALSO DataGrid_Cell(g, 2, 3) = "0" _ANDALSO DataGrid_Cell(g, 2, 4) = "0", "Fields left out get their column's default"
    TEST_CHECK DataGrid_Cell(g, 3, 3) = "3", "Integers are rounded"

    'Quotes
    n = DataGrid_FromCSV(g, CHR$(34) + "Smith, J" + CHR$(34) + ",Red" + nl + CHR$(34) + "say " + CHR$(34) + CHR$(34) + "hi" + CHR$(34) + CHR$(34) + CHR$(34) + nl + CHR$(34) + "two" + CHR$(10) + "lines|x" + CHR$(34) + ",Blue", 0)
    TEST_CHECK n = 3, "Rows are replaced"
    TEST_CHECK DataGrid_Cell(g, 1, 1) = "Smith, J", "A field in quotes can hold the separator"
    TEST_CHECK DataGrid_Cell(g, 2, 1) = "say " + CHR$(34) + "hi" + CHR$(34), "and doubled quotes"
    TEST_CHECK DataGrid_Cell(g, 3, 1) = "two" + CHR$(10) + "lines|x" _ANDALSO DataGrid_Cell(g, 3, 2) = "Blue", "and line breaks and |"

    'Writing it back and reading it again gives the same cells
    csv = DataGrid_ToCSV(g, __UI_DataGrid_CSVHeader)
    TEST_CHECK LEFT$(csv, 18) = "Name,Color,Qty,On" + CHR$(13), "The header has the captions"
    TEST_CHECK INSTR(csv, CHR$(34) + "Smith, J" + CHR$(34) + ",Red,0,0" + nl) > 0, "Fields that need quotes get them"
    g2 = __UI_NewControl(__UI_Type_Frame, "TestDGCSV2", 300, 150, 0, 0, 0)
    n = DataGrid_FromCSV(g2, csv, __UI_DataGrid_CSVHeader)
    TEST_CHECK n = 3 _ANDALSO DataGrid_ColumnCount(g2) = 4, "A grid with no columns gets one per header field"
    TEST_CHECK __UI_DataGridColCaption(__UI_DGCol(__UI_DGFind(g2), 2)) = "Color", "named after it"
    TEST_CHECK DataGrid_Cell(g2, 2, 1) = DataGrid_Cell(g, 2, 1) _ANDALSO DataGrid_Cell(g2, 3, 1) = DataGrid_Cell(g, 3, 1), "The same cells come back"
    TEST_CHECK DataGrid_ToCSV(g2, __UI_DataGrid_CSVHeader) = csv, "and the same text"
    __UI_DestroyControl Control(g2)

    'With a header, fields go to the column with their caption
    n = DataGrid_FromCSV(g, "on;QTY;Extra;Name" + nl + "true;7;zzz;kiwi" + nl, __UI_DataGrid_CSVHeader + __UI_DataGrid_CSVSemicolon)
    TEST_CHECK n = 1 _ANDALSO DataGrid_Cell(g, 1, 1) = "kiwi" _ANDALSO DataGrid_Cell(g, 1, 3) = "7" _ANDALSO DataGrid_Cell(g, 1, 4) = "-1", "Columns found by caption, in any case"
    TEST_CHECK DataGrid_Cell(g, 1, 2) = "Red", "A column with no field gets its default"

    'Tags and appending
    n = DataGrid_FromCSV(g, "17" + CHR$(9) + "plum" + nl + "18" + CHR$(9) + "lime" + CHR$(9) + "Green", __UI_DataGrid_CSVTags + __UI_DataGrid_CSVTab + __UI_DataGrid_CSVAppend)
    TEST_CHECK n = 2 _ANDALSO DataGrid_RowCount(g) = 3, "Rows are added to the ones there"
    TEST_CHECK DataGrid_RowTag(g, 2) = "17" _ANDALSO DataGrid_Cell(g, 2, 1) = "plum" _ANDALSO DataGrid_RowTag(g, 3) = "18", "The first field is the row's tag"
    TEST_CHECK DataGrid_RowTag(g, 1) = "", "Rows not loaded keep no tag"
    csv = DataGrid_ToCSV(g, __UI_DataGrid_CSVTags + __UI_DataGrid_CSVHeader)
    TEST_CHECK LEFT$(csv, 22) = "Tag,Name,Color,Qty,On" + CHR$(13), "Tags are written first"
    TEST_CHECK INSTR(csv, nl + "18,lime,Green,0,0" + nl) > 0, "with their rows"

    'Files
    f = "test_datagrid_csv.tmp"
    TEST_CHECK DataGrid_SaveCSV(g, f, __UI_DataGrid_CSVHeader + __UI_DataGrid_CSVTags), "Save to a file"
    DataGrid_Clear g
    n = DataGrid_LoadCSV(g, f, __UI_DataGrid_CSVHeader + __UI_DataGrid_CSVTags)
    TEST_CHECK n = 3 _ANDALSO DataGrid_RowTag(g, 3) = "18" _ANDALSO DataGrid_Cell(g, 3, 1) = "lime", "and load it back"
    KILL f
    TEST_CHECK DataGrid_LoadCSV(g, f, 0) = -1 _ANDALSO DataGrid_RowCount(g) = 3, "A missing file loads nothing"
    TEST_CHECK DataGrid_FromCSV(g, CHR$(239) + CHR$(187) + CHR$(191) + "x", 0) = 1 _ANDALSO DataGrid_Cell(g, 1, 1) = "x", "A byte order mark is left out"
    TEST_CHECK DataGrid_FromCSV(g, "a,", 0) = 1 _ANDALSO DataGrid_Cell(g, 1, 2) = "", "An empty last field is a field (not the default)"
    __UI_DestroyControl Control(g)

    'Without a header or columns
    g = __UI_NewControl(__UI_Type_Frame, "TestDGCSV3", 300, 150, 0, 0, 0)
    n = DataGrid_FromCSV(g, "1,2,3", 0)
    TEST_CHECK n = 1 _ANDALSO DataGrid_ColumnCount(g) = 3 _ANDALSO __UI_DataGridColCaption(__UI_DGCol(__UI_DGFind(g), 3)) = "Column 3", "Columns named by number"
    __UI_DestroyControl Control(g)

    TEST_CASE_END
END SUB

SUB __UI_LoadForm: END SUB
SUB __UI_AssignIDs: END SUB
SUB __UI_OnLoad: END SUB
SUB __UI_BeforeUnload: END SUB
SUB __UI_BeforeUpdateDisplay: END SUB
SUB __UI_FormResized: END SUB
SUB __UI_ValueChanged (id AS LONG): TestValueChangedCount = TestValueChangedCount + 1: TestValueChangedID = id: END SUB
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
