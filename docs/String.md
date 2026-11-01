# String Library

The `String` library provides a collection of utility functions for string manipulation, character classification, and formatted output.

## Usage

To use the `String` library, include `String.bi` in your project.

```vb
'$INCLUDE:'String.bi'

DIM charCode AS _UNSIGNED _BYTE
charCode = ASC("A")
IF Asc_IsUppercase(charCode) THEN
    PRINT "Character is uppercase."
END IF

PRINT CHR$(Asc_ToLowercase(charCode)) ' Prints "a"

DIM formattedString AS STRING
formattedString = String_FormatString("Name: %s", "John")
PRINT formattedString ' Prints "Name: John"

DIM formattedNumber AS STRING
formattedNumber = String_FormatLong("Value: %d", 123)
PRINT formattedNumber ' Prints "Value: 123"
```

## API Reference

### Character Functions

***

Converts a character's ASCII value to its lowercase equivalent.

**Parameters:**

* `c`: The `_UNSIGNED _BYTE` ASCII code of the character.

**Returns:**
The ASCII code of the lowercase character.

```vb
FUNCTION Asc_ToLowercase~%% (c AS _UNSIGNED _BYTE)
```

***

Converts a character's ASCII value to its uppercase equivalent.

**Parameters:**

* `c`: The `_UNSIGNED _BYTE` ASCII code of the character.

**Returns:**
The ASCII code of the uppercase character.

```vb
FUNCTION Asc_ToUppercase~%% (c AS _UNSIGNED _BYTE)
```

***

Checks if a character is alphanumeric (a-z, A-Z, 0-9).

**Parameters:**

* `c`: The `_UNSIGNED _BYTE` ASCII code of the character.

**Returns:**
`_TRUE` if the character is alphanumeric, `_FALSE` otherwise.

```vb
FUNCTION Asc_IsAlphanumeric%% (c AS _UNSIGNED _BYTE)
```

***

Checks if a character is alphabetic (a-z, A-Z).

**Parameters:**

* `c`: The `_UNSIGNED _BYTE` ASCII code of the character.

**Returns:**
`_TRUE` if the character is alphabetic, `_FALSE` otherwise.

```vb
FUNCTION Asc_IsAlphabetic%% (c AS _UNSIGNED _BYTE)
```

***

Checks if a character is lowercase (a-z).

**Parameters:**

* `c`: The `_UNSIGNED _BYTE` ASCII code of the character.

**Returns:**
`_TRUE` if the character is lowercase, `_FALSE` otherwise.

```vb
FUNCTION Asc_IsLowercase%% (c AS _UNSIGNED _BYTE)
```

***

Checks if a character is uppercase (A-Z).

**Parameters:**

* `c`: The `_UNSIGNED _BYTE` ASCII code of the character.

**Returns:**
`_TRUE` if the character is uppercase, `_FALSE` otherwise.

```vb
FUNCTION Asc_IsUppercase%% (c AS _UNSIGNED _BYTE)
```

***

Checks if a character is a decimal digit (0-9).

**Parameters:**

* `c`: The `_UNSIGNED _BYTE` ASCII code of the character.

**Returns:**
`_TRUE` if the character is a digit, `_FALSE` otherwise.

```vb
FUNCTION Asc_IsDecimalDigit%% (c AS _UNSIGNED _BYTE)
```

***

Checks if a character is a hexadecimal digit (0-9, a-f, A-F).

**Parameters:**

* `c`: The `_UNSIGNED _BYTE` ASCII code of the character.

**Returns:**
`_TRUE` if the character is a hexadecimal digit, `_FALSE` otherwise.

```vb
FUNCTION Asc_IsHexadecimalDigit%% (c AS _UNSIGNED _BYTE)
```

***

Checks if a character is an octal digit (0-7).

**Parameters:**

* `c`: The `_UNSIGNED _BYTE` ASCII code of the character.

**Returns:**
`_TRUE` if the character is an octal digit, `_FALSE` otherwise.

```vb
FUNCTION Asc_IsOctalDigit%% (c AS _UNSIGNED _BYTE)
```

***

Checks if a character is a binary digit (0 or 1).

**Parameters:**

* `c`: The `_UNSIGNED _BYTE` ASCII code of the character.

**Returns:**
`_TRUE` if the character is a binary digit, `_FALSE` otherwise.

```vb
FUNCTION Asc_IsBinaryDigit%% (c AS _UNSIGNED _BYTE)
```

***

Checks if a character is a control character.

**Parameters:**

* `c`: The `_UNSIGNED _BYTE` ASCII code of the character.

**Returns:**
`_TRUE` if the character is a control character, `_FALSE` otherwise.

```vb
FUNCTION Asc_IsControlCharacter%% (c AS _UNSIGNED _BYTE)
```

***

Checks if a character is whitespace.

**Parameters:**

* `c`: The `_UNSIGNED _BYTE` ASCII code of the character.

**Returns:**
`_TRUE` if the character is whitespace, `_FALSE` otherwise.

```vb
FUNCTION Asc_IsWhitespace%% (c AS _UNSIGNED _BYTE)
```

***

Checks if a character is blank (space or horizontal tab).

**Parameters:**

* `c`: The `_UNSIGNED _BYTE` ASCII code of the character.

**Returns:**
`_TRUE` if the character is blank, `_FALSE` otherwise.

```vb
FUNCTION Asc_IsBlank%% (c AS _UNSIGNED _BYTE)
```

***

Checks if a character is punctuation.

**Parameters:**

* `c`: The `_UNSIGNED _BYTE` ASCII code of the character.

**Returns:**
`_TRUE` if the character is punctuation, `_FALSE` otherwise.

```vb
FUNCTION Asc_IsPunctuation%% (c AS _UNSIGNED _BYTE)
```

***

### String Conversion

***

Converts a C-style null-terminated string to a standard BASIC string.

**Parameters:**

* `s`: The C-style `STRING` to convert.

**Returns:**
The converted BASIC `STRING`.

```vb
FUNCTION String_ToBStr$ (s AS STRING)
```

***

Converts a standard BASIC string to a C-style null-terminated string.

**Parameters:**

* `s`: The BASIC `STRING` to convert.

**Returns:**
The converted C-style `STRING`.

```vb
FUNCTION String_ToCStr$ (s AS STRING)
```

***

### String Formatting

***

Formats a string with a `STRING` argument.

**Parameters:**

* `fmtStr`: The format string (e.g., "Name: %s").
* `s`: The `STRING` argument.

**Returns:**
The formatted string.

```vb
FUNCTION String_FormatString$ (fmtStr AS STRING, s AS STRING)
```

***

Formats a string with a `LONG` integer argument.

**Parameters:**

* `fmtStr`: The format string (e.g., "Value: %d").
* `n`: The `LONG` argument.

**Returns:**
The formatted string.

```vb
FUNCTION String_FormatLong$ (fmtStr AS STRING, n AS LONG)
```

***

Formats a string with an `_INTEGER64` argument.

**Parameters:**

* `fmtStr`: The format string (e.g., "Value: %lld").
* `n`: The `_INTEGER64` argument.

**Returns:**
The formatted string.

```vb
FUNCTION String_FormatInteger64$ (fmtStr AS STRING, n AS _INTEGER64)
```

***

Formats a string with a `SINGLE` floating-point argument.

**Parameters:**

* `fmtStr`: The format string (e.g., "Value: %f").
* `f`: The `SINGLE` argument.

**Returns:**
The formatted string.

```vb
FUNCTION String_FormatSingle$ (fmtStr AS STRING, f AS SINGLE)
```

***

Formats a string with a `DOUBLE` floating-point argument.

**Parameters:**

* `fmtStr`: The format string (e.g., "Value: %f").
* `d`: The `DOUBLE` argument.

**Returns:**
The formatted string.

```vb
FUNCTION String_FormatDouble$ (fmtStr AS STRING, d AS DOUBLE)
```
