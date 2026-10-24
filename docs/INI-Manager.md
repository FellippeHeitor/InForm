# INI Manager Library

The `INI Manager` library provides functionality for reading and writing [INI files](https://en.wikipedia.org/wiki/INI_file). INI files are a simple, human-readable format for storing configuration data.

## Usage

To use the `INI Manager` library in your project, you need to include `Ini.bi` and `Ini.bm`.

```vb
'$INCLUDE:'Ini.bi'

' Write a setting
Ini_WriteSetting "config.ini", "owner", "name", "John Doe"

' Read a setting
DIM name AS STRING
name = Ini_ReadSetting("config.ini", "owner", "name")
PRINT name ' Prints "John Doe"

'$INCLUDE:'Ini.bm'
```

## API Reference

### Reading Data

***

Reads a value from a specified section and key. To get all keys sequentially from the file, pass an empty string for `section$` and `key$`. To get all keys sequentially from a specific section, pass an empty string for `key$`.

**Parameters:**

* `file`: The file name to be parsed. To work with a single file, you only need to pass file$ in the first read operation.
* `section`: The `[section]` in the ini file where the `key` will be read from.
* `key`: The key in the file whose value you want to read.

**Returns:**
The value obtained from the file as a `STRING`.

```vb
FUNCTION Ini_ReadSetting$ (file$, section$, key$)
```

***

### Writing and Modifying Data

***

Writes a value to a specified section and key. If the key exists, it's updated. If it doesn't, it's created. New sections are created automatically.

**Parameters:**

* `file`: The file name to write to. Can handle multiple ini files at once. To work with a single file, you only need to pass `file` in the first write operation.
* `section`: The `[section]` in the ini file where the new `key` will be added.
* `key`: The unique identifier of the value you wish to store (multiple identical keys can exist across different sections).
* `value`: The value to be stored. Numeric values must be converted to strings with `STR$()` first.

```vb
SUB Ini_WriteSetting (file$, section$, key$, value$)
```

***

Deletes an entire section and all its keys from the INI file.

**Parameters:**

* `file`: The file name to write to.
* `section`: The `[section]` to delete.

```vb
SUB Ini_DeleteSection (file$, section$)
```

***

Deletes a specific key from a given section.

**Parameters:**

* `file`: The file name to write to.
* `section`: The `[section]` to where the `key` is located.
* `key`: The key to delete.

```vb
SUB Ini_DeleteKey (file$, section$, key$)
```

***

Moves a key from one section to another.

**Parameters:**

* `file`: The file name to write to.
* `section`: The `[section]` to where the `key` is located.
* `key`: The key to move.
* `newSection`: The new `[section]` where `key` must be moved to.

```vb
SUB Ini_MoveKey (file$, section$, key$, newSection$)
```

***

Sorts all keys within a specified section alphabetically.

**Parameters:**

* `file`: The file name to write to.
* `section`: The `[section]` to sort.

```vb
SUB Ini_SortSection (file$, section$)
```

***

### File Handling

***

Loads an INI file into memory. This is called automatically by `Ini_ReadSetting` and `Ini_WriteSetting`.

**Parameters:**

* `file`: The file name to load.

```vb
SUB Ini_Load (file$)
```

***

Closes the currently open INI file and commits any pending changes.

```vb
SUB Ini_Close
```

***

Closes a file's handle without writing anything. The next read loads the file from disk again. Use it after reading a file that other programs may change or overwrite.

**Parameters:**

* `file`: The INI file to release.

```vb
SUB Ini_Release (file$)
```

***

By default, the library will cache the file in memory to improve performance. Use this to force a reload of the file from disk on the next `Ini_Load` call.

**Parameters:**

* `state`: Set this to _TRUE to force a reload.

```vb
SUB Ini_SetForceReload (state%%)
```

***

### Information and Status

***

Returns a string describing the result or error code of the last operation.

**Returns:**
A string describing the result or error code of the last operation.

```vb
FUNCTION Ini_GetInfo$
```

***

Returns the numeric result or error code of the last operation.

**Returns:**
The numeric result or error code of the last operation.

```vb
FUNCTION Ini_GetCode&
```

***

Returns the last section that was read from or written to.

**Returns:**
The last section that was read from or written to.

```vb
FUNCTION Ini_GetLastSection$
```

***

Returns the last key that was read from or written to.

**Returns:**
The last key that was read from or written to.

```vb
FUNCTION Ini_GetLastKey$
```

***

Returns the next key in the current section. This is used for iterating through keys.

**Returns:**
The next key in the current section.

```vb
FUNCTION Ini_GetNextKey$
```

***

Returns the next section in the file. This is used for iterating through sections.

**Returns:**
The next section in the file.

```vb
FUNCTION Ini_GetNextSection$ (file$)
```

***

Returns the current section being processed. The value is cached and available by calling `Ini_GetLastSection`.

**Returns:**
The current section being processed.

```vb
FUNCTION Ini_GetCurrentSection$
```

***

### Constants

The `Ini_GetCode` function returns a numeric code indicating the result of the last operation. The following constants are defined in `Ini.bi` for interpreting these codes:

| Constant                                | Description                                |
| --------------------------------------  | -------------------------------------------|
| `INI_INFO_SUCCESS`                      | Operation successful                       |
| `INI_INFO_FILE_NOT_FOUND`               | ERROR: File not found                      |
| `INI_INFO_EMPTY_VALUE`                  | Empty value                                |
| `INI_INFO_KEY_NOT_FOUND`                | ERROR: Key not found                       |
| `INI_INFO_KEY_UPDATED`                  | Key updated                                |
| `INI_INFO_GLOBAL_KEY_CREATED`           | Global key created                         |
| `INI_INFO_KEY_CREATED_EXISTING_SECTION` | Key created in existing section            |
| `INI_INFO_NO_CHANGE_SAME_VALUE`         | No changes applied (same value)            |
| `INI_INFO_NEW_SECTION_KEY_CREATED`      | New section created; key created           |
| `INI_INFO_NO_MORE_KEYS`                 | No more keys                               |
| `INI_INFO_FILE_CREATED_KEY_ADDED`       | File created; new key added                |
| `INI_INFO_INVALID_KEY`                  | ERROR: Invalid key                         |
| `INI_INFO_SECTION_DELETED`              | Section deleted                            |
| `INI_INFO_SECTION_NOT_FOUND`            | ERROR: Section not found                   |
| `INI_INFO_INVALID_SECTION`              | ERROR: Invalid section                     |
| `INI_INFO_NEW_SECTION_KEY_MOVED`        | New section created; existing key moved    |
| `INI_INFO_EMPTY_FILE`                   | ERROR: Empty file                          |
| `INI_INFO_NO_FILE_OPEN`                 | ERROR: No file open                        |
| `INI_INFO_KEY_DELETED`                  | Key deleted                                |
| `INI_INFO_KEY_MOVED`                    | Key moved                                  |
| `INI_INFO_INVALID_FILENAME`             | ERROR: Invalid file name/path              |
| `INI_INFO_SECTION_SORTED`               | Section sorted                             |
| `INI_INFO_SECTION_ALREADY_SORTED`       | No changes applied; section already sorted |
| `INI_INFO_NO_MORE_SECTIONS`             | No more sections                           |
