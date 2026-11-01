# Pathname Library

The `Pathname` library provides a comprehensive set of cross-platform functions for manipulating file paths and URLs. It simplifies common tasks such as parsing filenames, handling directory separators, and sanitizing path strings.

## Usage

To use the `Pathname` library, you need to include `Pathname.bi` in your project.

```vb
'$INCLUDE:"Pathname.bi"

DIM myPath AS STRING
myPath = "C:/Users/Test/document.txt"

PRINT "Original Path: "; myPath
PRINT "Is Absolute? "; Pathname_IsAbsolute(myPath)
PRINT "Fixed Separators: "; Pathname_FixDirectorySeparators(myPath)
PRINT "File Name: "; Pathname_GetFileName(myPath)
PRINT "Path: "; Pathname_GetPath(myPath)
PRINT "Has Extension? "; Pathname_HasFileExtension(myPath)
PRINT "Extension: "; Pathname_GetFileExtension(myPath)
PRINT "Without Extension: "; Pathname_RemoveFileExtension(myPath)
PRINT "Drive or Scheme: "; Pathname_GetDriveOrScheme(myPath)
PRINT "Sanitized: "; Pathname_Sanitize("bad/file?name*")
```

## API Reference

### Path Analysis

***

Checks if a path is absolute. An absolute path is one that starts from the root of the file system.

**Parameters:**

* `pathName`: The path to check.

**Returns:**
`_TRUE` if the path is absolute, `_FALSE` otherwise.

```vb
FUNCTION Pathname_IsAbsolute%% (pathName AS STRING)
```

***

Checks if a path or URL has a file extension.

**Parameters:**

* `pathOrURL`: The path or URL to check.

**Returns:**
`_TRUE` if the path or URL has a file extension, `_FALSE` otherwise.

```vb
FUNCTION Pathname_HasFileExtension%% (pathOrURL AS STRING)
```

***

### Path Manipulation

***

Adds a directory separator to the end of the path if it does not already have one.

**Parameters:**

* `pathName`: The path to modify.

**Returns:**
The modified path with a trailing directory separator.

```vb
FUNCTION Pathname_AddDirectorySeparator$ (pathName AS STRING)
```

***

Fixes the directory separators in a path to match the current operating system. On Windows, it converts `/` to `\`, and on other systems, it converts `\` to `/`.

**Parameters:**

* `pathName`: The path to fix.

**Returns:**
The path with corrected directory separators.

```vb
FUNCTION Pathname_FixDirectorySeparators$ (pathName AS STRING)
```

***

Makes a pathname legal by replacing illegal characters with an underscore (`_`).

**Parameters:**

* `fileName`: The pathname to sanitize.

**Returns:**
The sanitized pathname.

```vb
FUNCTION Pathname_Sanitize$ (fileName AS STRING)
```

***

### Path Parsing

***

Returns the filename portion from a file path or URL.

**Parameters:**

* `pathOrURL`: The path or URL from which to extract the filename.

**Returns:**
The filename portion of the path or URL.

```vb
FUNCTION Pathname_GetFileName$ (pathOrURL AS STRING)
```

***

Returns the path portion from a file path or URL, excluding the filename.

**Parameters:**

* `pathOrURL`: The path or URL from which to extract the path.

**Returns:**
The path portion of the path or URL.

```vb
FUNCTION Pathname_GetPath$ (pathOrURL AS STRING)
```

***

Gets the file extension from a path or URL.

**Parameters:**

* `pathOrURL`: The path or URL from which to get the file extension.

**Returns:**
The file extension, including the dot.

```vb
FUNCTION Pathname_GetFileExtension$ (pathOrURL AS STRING)
```

***

Removes the file extension from a path or URL.

**Parameters:**

* `pathOrURL`: The path or URL from which to remove the file extension.

**Returns:**
The path or URL with the file extension removed.

```vb
FUNCTION Pathname_RemoveFileExtension$ (pathOrURL AS STRING)
```

***

Returns the drive letter or URL scheme from a path or URL.

**Parameters:**

* `pathOrURL`: The path or URL to check.

**Returns:**
The drive letter (e.g., "C:") or URL scheme (e.g., "http:").

```vb
FUNCTION Pathname_GetDriveOrScheme$ (pathOrURL AS STRING)
```
