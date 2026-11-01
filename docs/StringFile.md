# StringFile Library

The `StringFile` library provides a way to treat a standard `STRING` variable as a binary file, allowing for file I/O-like operations (reading, writing, seeking) directly in memory. This is useful for parsing or building data structures from files that have been loaded entirely into memory.

## Usage

To use the `StringFile` library, you need to include `StringFile.bi` in your project.

```vb
'$INCLUDE:"StringFile.bi"

DIM myData AS STRING
myData = "Hello" + CHR$(0) + MKI$(123) ' Some string and binary data

' Create a StringFile from the string
DIM sf AS StringFile
StringFile_Create sf, myData

' Read the string part
PRINT "String: "; StringFile_ReadString(sf, 6) ' Reads "Hello" + NUL

' Read the integer part
PRINT "Integer: "; StringFile_ReadInteger(sf)

' Check if we are at the end
IF StringFile_IsEOF(sf) THEN
    PRINT "End of file reached."
END IF
```

## API Reference

### Setup & File Operations

***

Initializes a `StringFile` object with a given string buffer.

**Parameters:**

* `stringFile`: The `StringFile` object to initialize.
* `buffer`: The `STRING` to use as the in-memory file.

```vb
SUB StringFile_Create (stringFile AS StringFile, buffer AS STRING)
```

***

Loads a file from disk into a `StringFile` object. The entire file content is read into the `buffer` field.

**Parameters:**

* `stringFile`: The `StringFile` object to load into.
* `fileName`: The path to the file to load.

**Returns:**
`_TRUE` if the file was loaded successfully, `_FALSE` otherwise.

```vb
FUNCTION StringFile_Load%% (stringFile AS StringFile, fileName AS STRING)
```

***

Saves the contents of the `StringFile`'s buffer to a file on disk.

**Parameters:**

* `stringFile`: The `StringFile` object to save.
* `fileName`: The path to the file to save to.
* `overwrite`: If set to `_FALSE`, the function will not overwrite an existing file.

**Returns:**
`_TRUE` if the file was saved successfully, `_FALSE` otherwise.

```vb
FUNCTION StringFile_Save%% (stringFile AS StringFile, fileName AS STRING, overwrite AS _BYTE)
```

***

Saves the contents of a `StringFile` object to a file on disk. This is a `SUB` version that does not return a value.

**Parameters:**

* `stringFile`: The `StringFile` object to save.
* `fileName`: The path to the file to save to.
* `overwrite`: If set to `_FALSE`, the function will not overwrite an existing file.

```vb
SUB StringFile_Save (stringFile AS StringFile, fileName AS STRING, overwrite AS _BYTE)
```

***

### Status & Navigation

***

Checks if the internal cursor has reached the end of the buffer.

**Parameters:**

* `stringFile`: The `StringFile` object to check.

**Returns:**
`_TRUE` if the cursor is at or beyond the end of the buffer, `_FALSE` otherwise.

```vb
FUNCTION StringFile_IsEOF%% (stringFile AS StringFile)
```

***

Gets the total size of the internal buffer in bytes.

**Parameters:**

* `stringFile`: The `StringFile` object.

**Returns:**
The size of the buffer.

```vb
FUNCTION StringFile_GetSize~%& (stringFile AS StringFile)
```

***

Gets the current position of the read/write cursor.

**Parameters:**

* `stringFile`: The `StringFile` object.

**Returns:**
The current zero-based cursor position.

```vb
FUNCTION StringFile_GetPosition~%& (stringFile AS StringFile)
```

***

Moves the read/write cursor to a new position.

**Parameters:**

* `stringFile`: The `StringFile` object.
* `position`: The new zero-based position for the cursor. It must be within the bounds of the buffer (from `0` to `LEN(buffer)`).

```vb
SUB StringFile_Seek (stringFile AS StringFile, position AS _UNSIGNED _OFFSET)
```

***

Resizes the internal buffer. If the new size is smaller, the buffer is truncated. If it's larger, the buffer is padded with `_CHR_NUL` characters.

**Parameters:**

* `stringFile`: The `StringFile` object.
* `newSize`: The desired new size of the buffer in bytes.

```vb
SUB StringFile_Resize (stringFile AS StringFile, newSize AS _UNSIGNED _OFFSET)
```

***

### Data Reading

***

Reads a sequence of bytes as a `STRING` from the current cursor position.

**Parameters:**

* `stringFile`: The `StringFile` object.
* `size`: The number of bytes to read.

**Returns:**
The `STRING` read from the buffer. If the requested size exceeds the remaining bytes, it returns only the available bytes.

```vb
FUNCTION StringFile_ReadString$ (stringFile AS StringFile, size AS _UNSIGNED _OFFSET)
```

***

Reads a single byte from the current cursor position.

**Parameters:**

* `stringFile`: The `StringFile` object.

**Returns:**
The `_UNSIGNED _BYTE` value.

```vb
FUNCTION StringFile_ReadByte~%% (stringFile AS StringFile)
```

***

Reads an `INTEGER` (2 bytes) from the current cursor position.

**Parameters:**

* `stringFile`: The `StringFile` object.

**Returns:**
The `_UNSIGNED INTEGER` value.

```vb
FUNCTION StringFile_ReadInteger~% (stringFile AS StringFile)
```

***

Reads a `LONG` (4 bytes) from the current cursor position.

**Parameters:**

* `stringFile`: The `StringFile` object.

**Returns:**
The `_UNSIGNED LONG` value.

```vb
FUNCTION StringFile_ReadLong~& (stringFile AS StringFile)
```

***

Reads a `SINGLE` (4 bytes) from the current cursor position.

**Parameters:**

* `stringFile`: The `StringFile` object.

**Returns:**
The `SINGLE` value.

```vb
FUNCTION StringFile_ReadSingle! (stringFile AS StringFile)
```

***

Reads an `_INTEGER64` (8 bytes) from the current cursor position.

**Parameters:**

* `stringFile`: The `StringFile` object.

**Returns:**
The `_UNSIGNED _INTEGER64` value.

```vb
FUNCTION StringFile_ReadInteger64~&& (stringFile AS StringFile)
```

***

Reads a `DOUBLE` (8 bytes) from the current cursor position.

**Parameters:**

* `stringFile`: The `StringFile` object.

**Returns:**
The `DOUBLE` value.

```vb
FUNCTION StringFile_ReadDouble# (stringFile AS StringFile)
```

***

### Data Writing

***

Writes a `STRING` to the buffer at the current cursor position. The buffer will automatically grow if needed.

**Parameters:**

* `stringFile`: The `StringFile` object.
* `src`: The `STRING` to write.

```vb
SUB StringFile_WriteString (stringFile AS StringFile, src AS STRING)
```

***

Writes a single byte to the buffer at the current cursor position.

**Parameters:**

* `stringFile`: The `StringFile` object.
* `src`: The `_UNSIGNED _BYTE` to write.

```vb
SUB StringFile_WriteByte (stringFile AS StringFile, src AS _UNSIGNED _BYTE)
```

***

Writes an `INTEGER` (2 bytes) to the buffer at the current cursor position.

**Parameters:**

* `stringFile`: The `StringFile` object.
* `src`: The `_UNSIGNED INTEGER` to write.

```vb
SUB StringFile_WriteInteger (stringFile AS StringFile, src AS _UNSIGNED INTEGER)
```

***

Writes a `LONG` (4 bytes) to the buffer at the current cursor position.

**Parameters:**

* `stringFile`: The `StringFile` object.
* `src`: The `_UNSIGNED LONG` to write.

```vb
SUB StringFile_WriteLong (stringFile AS StringFile, src AS _UNSIGNED LONG)
```

***

Writes a `SINGLE` (4 bytes) to the buffer at the current cursor position.

**Parameters:**

* `stringFile`: The `StringFile` object.
* `src`: The `SINGLE` to write.

```vb
SUB StringFile_WriteSingle (stringFile AS StringFile, src AS SINGLE)
```

***

Writes an `_INTEGER64` (8 bytes) to the buffer at the current cursor position.

**Parameters:**

* `stringFile`: The `StringFile` object.
* `src`: The `_UNSIGNED _INTEGER64` to write.

```vb
SUB StringFile_WriteInteger64 (stringFile AS StringFile, src AS _UNSIGNED _INTEGER64)
```

***

Writes a `DOUBLE` (8 bytes) to the buffer at the current cursor position.

**Parameters:**

* `stringFile`: The `StringFile` object.
* `src`: The `DOUBLE` to write.

```vb
SUB StringFile_WriteDouble (stringFile AS StringFile, src AS DOUBLE)
```
