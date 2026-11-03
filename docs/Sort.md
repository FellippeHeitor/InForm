# Sort Library

The `Sort` library provides sorting algorithms.

## Usage

To use the `Sort` library, you need to include `Sort.bi` in your project.

```vb
'$INCLUDE:'Sort.bi'

DIM names(1 TO 5) AS STRING
names(1) = "John"
names(2) = "jane"
names(3) = "Peter"
names(4) = "sue"
names(5) = "pete"

Sort_StringArray names()

DIM i AS LONG
FOR i = LBOUND(names) TO UBOUND(names)
    PRINT names(i)
NEXT

IF Sort_StringArrayRange(names(), 2, 4, _FALSE, _FALSE) THEN
    PRINT "Array was changed"
END IF

FOR i = LBOUND(names) TO UBOUND(names)
    PRINT names(i)
NEXT
```

## API Reference

### Sorting

***

Sorts a string array using a non-recursive QuickSort algorithm.

**Parameters:**

* `strArr()`: The array of strings to sort.
* `l`: The lower index of the range to sort (inclusive).
* `u`: The upper index of the range to sort (inclusive).
* `wantsAscending`: `_TRUE` for ascending order, `_FALSE` for descending order.
* `caseSensitive`: `_TRUE` for case-sensitive comparison, `_FALSE` for case-insensitive comparison.

**Returns:**
`_TRUE` if the array was modified, `_FALSE` otherwise.

```vb
FUNCTION Sort_StringArrayRange%% (strArr() AS STRING, l AS _INTEGER64, u AS _INTEGER64, wantsAscending AS _BYTE, caseSensitive AS _BYTE)
```

***

A convenience function that sorts the entire string array in ascending, case-sensitive order.

**Parameters:**

* `strArr()`: The array of strings to sort.

**Returns:**
`_TRUE` if the array was modified, `_FALSE` otherwise.

```vb
FUNCTION Sort_StringArray%% (strArr() AS STRING)
```

***

A convenience SUB that sorts the entire string array in ascending, case-sensitive order.

**Parameters:**

* `strArr()`: The array of strings to sort.

```vb
SUB Sort_StringArray (strArr() AS STRING)
```
