# Font Manager

The `FontMgr` library is a cross-platform helper for finding and retrieving information about system-installed fonts.

## Usage

To use the `FontMgr` library, you need to include `FontMgr.bi` in your project.

```vb
'$CONSOLE:ONLY

'$INCLUDE:'FontMgr.bi'

' This dynamic array will hold the file paths of all found fonts
REDIM fontFileList(0) AS STRING

' Build the list of fonts from standard system and user directories
IF FontMgr_BuildList(fontFileList()) > 0 THEN
    DIM i AS LONG
    FOR i = 1 TO UBOUND(fontFileList)
        ' A single font file (like a .ttc) can contain multiple fonts
        DIM fontCountInFile AS LONG
        fontCountInFile = FontMgr_GetCount(fontFileList(i))

        DIM j AS LONG
        FOR j = 0 TO fontCountInFile - 1
            DIM fontName AS STRING
            fontName = FontMgr_GetName(fontFileList(i), j, FONTMGR_NAME_FULL)
            PRINT fontName
        NEXT j
    NEXT i
ELSE
    PRINT "No fonts found or failed to build font list!"
END IF
```

## API Reference

### Font Discovery

***

Builds a list of available fonts from standard user and system font directories.

**Parameters:**

* `fontList()`: A dynamic `STRING` array that will be re-dimensioned and populated with the full file paths of all found fonts. The array is re-dimensioned from `0 TO totalCount`, and index 0 is intentionally an empty `STRING`.

**Returns:**
The total count of font files found.

```vb
FUNCTION FontMgr_BuildList~& (fontList() AS STRING)
```

***

Returns the number of fonts contained within a single font file. For `.ttf`, `.otf`, and bitmap fonts, this will be `1`. For TrueType Collections (`.ttc`), this can be greater than `1`.

**Parameters:**

* `filePath`: The path to the font file.

**Returns:**
The number of fonts in the file. Returns `0` for an invalid file path.

```vb
FUNCTION FontMgr_GetCount~& (filePath AS STRING)
```

***

### Font Information

***

Retrieves a specific name component from a font file.

**Parameters:**

* `filePath`: The path to the font file. Can be an empty string `""` to get the name of the built-in VGA font.
* `fontIndex`: The zero-based index of the font within the file. This is `0` for most files but can be higher for `.ttc` files.
* `nameId`: The name component to retrieve. See **Constants** below.

**Returns:**
The requested font name as a string. Returns an empty string if the name ID or font index is invalid for that font.

```vb
FUNCTION FontMgr_GetName$ (filePath AS STRING, fontIndex AS _UNSIGNED LONG, nameId AS _UNSIGNED _BYTE)
```

***

Probes a font file to determine its supported size range. This is most useful for bitmap fonts. For scalable fonts like TTF/OTF, it will return a default range of `8-255`.

**Parameters:**

* `filePath`: The path to the font file.
* `fontIndex`: The zero-based index of the font within the file.
* `outMinSize`: An `_UNSIGNED _BYTE` variable to receive the minimum supported size.
* `outMaxSize`: An `_UNSIGNED _BYTE` variable to receive the maximum supported size.

**Returns:**
`_TRUE` if a valid size range was found, `_FALSE` otherwise.

```vb
FUNCTION FontMgr_GetSizeRange%% (filePath AS STRING, fontIndex AS _UNSIGNED LONG, outMinSize AS _UNSIGNED _BYTE, outMaxSize AS _UNSIGNED _BYTE)
```

***

### Constants

***

The `nameId` parameter of the `FontMgr_GetName` function accepts the following constants (defined in `FontMgr.bi`):

| Constant | Description |
|-|-|
| `FONTMGR_NAME_COPYRIGHT` | Copyright notice |
| `FONTMGR_NAME_FAMILY` | Font Family name |
| `FONTMGR_NAME_STYLE` | Font Subfamily name |
| `FONTMGR_NAME_UNIQUE` | Unique font identifier |
| `FONTMGR_NAME_FULL` | Full font name |
| `FONTMGR_NAME_VERSION` | Version string |
| `FONTMGR_NAME_POSTSCRIPT` | Postscript name for the font |
| `FONTMGR_NAME_TRADEMARK` | Trademark |
| `FONTMGR_NAME_MANUFACTURER` | Manufacturer name |
| `FONTMGR_NAME_DESIGNER` | Name of the designer of the typeface |
| `FONTMGR_NAME_DESCRIPTION` | Description of the typeface |
| `FONTMGR_NAME_VENDOR_URL` | URL of font vendor |
| `FONTMGR_NAME_DESIGNER_URL` | URL of typeface designer |
| `FONTMGR_NAME_LICENSE_DESCRIPTION` | License description |
| `FONTMGR_NAME_LICENSE_INFO_URL` | License information URL |
| `FONTMGR_NAME_PREFERRED_FAMILY` | Preferred Family (Windows only) |
| `FONTMGR_NAME_PREFERRED_SUBFAMILY` | Preferred Subfamily (Windows only) |
| `FONTMGR_NAME_COMPATIBLE_FULL` | Compatible Full (Mac OS only) |
| `FONTMGR_NAME_SAMPLE_TEXT` | Sample text |
| `FONTMGR_NAME_POSTSCRIPT_CID` | PostScript CID findfont name |
