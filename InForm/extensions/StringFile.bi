'-----------------------------------------------------------------------------------------------------------------------
' File I/O like routines for memory loaded files
' Copyright (c) 2026 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$INCLUDEONCE

'$INCLUDE:'Memory.bi'

' A StringFile represents a file loaded in memory as a STRING buffer and a cursor to read and write from it.
' Unlike BASIC file I/O, StringFiles are zero-based.
' Since it uses a STRING as a backing buffer, no explicit memory management (i.e. freeing) is required.
TYPE StringFile
    buffer AS STRING
    cursor AS _UNSIGNED _OFFSET
END TYPE

''' @brief Initializes a StringFile object with the given buffer.
SUB StringFile_Create (stringFile AS StringFile, buffer AS STRING)
    stringFile.buffer = buffer
    stringFile.cursor = 0
END SUB

''' @brief Loads a file from disk into a StringFile object.
''' @return _TRUE if the file was loaded successfully, _FALSE otherwise.
FUNCTION StringFile_Load%% (stringFile AS StringFile, fileName AS STRING)
    IF _FILEEXISTS(fileName) THEN
        stringFile.buffer = _READFILE$(fileName)
        stringFile.cursor = 0

        StringFile_Load = _TRUE
    END IF
END FUNCTION

''' @brief Saves the contents of a StringFile object to a file on disk.
''' @param overwrite If _FALSE and the file already exists, the function will not overwrite it.
''' @return _TRUE if the file was saved successfully, _FALSE otherwise.
FUNCTION StringFile_Save%% (stringFile AS StringFile, fileName AS STRING, overwrite AS _BYTE)
    IF _FILEEXISTS(fileName) _ANDALSO NOT overwrite THEN EXIT FUNCTION

    _WRITEFILE fileName, stringFile.buffer

    StringFile_Save = _TRUE
END FUNCTION

''' @brief Saves the contents of a StringFile object to a file on disk.
''' @param overwrite If _FALSE and the file already exists, the function will not overwrite it.
SUB StringFile_Save (stringFile AS StringFile, fileName AS STRING, overwrite AS _BYTE)
    DIM ignored AS _BYTE: ignored = StringFile_Save(stringFile, fileName, overwrite)
END SUB

''' @brief Checks if the cursor is at the end of the file.
''' @return _TRUE if at EOF, _FALSE otherwise.
FUNCTION StringFile_IsEOF%% (stringFile AS StringFile)
    StringFile_IsEOF = (stringFile.cursor >= LEN(stringFile.buffer))
END FUNCTION

''' @brief Gets the size of the file in bytes.
''' @return Size of the file in bytes.
FUNCTION StringFile_GetSize~%& (stringFile AS StringFile)
    StringFile_GetSize = LEN(stringFile.buffer)
END FUNCTION

''' @brief Gets the current read/write cursor position.
''' @return Current cursor position.
FUNCTION StringFile_GetPosition~%& (stringFile AS StringFile)
    StringFile_GetPosition = stringFile.cursor
END FUNCTION

''' @brief Seeks to a position in the file.
''' @param position Position to seek to. Must be less than or equal to the file size.
SUB StringFile_Seek (stringFile AS StringFile, position AS _UNSIGNED _OFFSET)
    IF position <= LEN(stringFile.buffer) THEN ' allow seeking to EOF position
        stringFile.cursor = position
    ELSE
        ERROR _ERR_ILLEGAL_FUNCTION_CALL
    END IF
END SUB

''' @brief Resizes the file to the new size.
''' If the new size is larger than the current size, the file is expanded and the new bytes are filled with zeroes.
''' If the new size is smaller than the current size, the file is truncated and the cursor is repositioned to the EOF if it was beyond the new size.
''' @param newSize New size of the file in bytes.
SUB StringFile_Resize (stringFile AS StringFile, newSize AS _UNSIGNED _OFFSET)
    DIM AS _UNSIGNED _OFFSET curSize: curSize = LEN(stringFile.buffer)

    IF newSize > curSize THEN
        stringFile.buffer = stringFile.buffer + STRING$(newSize - curSize, _ASC_NUL)
    ELSEIF newSize < curSize THEN
        stringFile.buffer = LEFT$(stringFile.buffer, newSize)
        IF stringFile.cursor > newSize THEN stringFile.cursor = newSize ' reposition cursor to EOF position
    END IF
END SUB

''' @brief Reads a string of a given size from the file.
''' @param size Number of bytes to read.
''' @return The string read from the file.
FUNCTION StringFile_ReadString$ (stringFile AS StringFile, size AS _UNSIGNED _OFFSET)
    IF size > 0 THEN ' reading 0 bytes will simply do nothing
        IF stringFile.cursor < LEN(stringFile.buffer) THEN ' we'll allow partial string reads but check if we have anything to read at all
            DIM dst AS STRING: dst = MID$(stringFile.buffer, stringFile.cursor + 1, size)

            stringFile.cursor = stringFile.cursor + LEN(dst) ' increment cursor by size bytes

            StringFile_ReadString = dst
        ELSE ' not enough bytes to read
            ERROR _ERR_ILLEGAL_FUNCTION_CALL
        END IF
    END IF
END FUNCTION

''' @brief Writes a string to the file.
''' @param src The string to write.
SUB StringFile_WriteString (stringFile AS StringFile, src AS STRING)
    DIM srcSize AS _UNSIGNED _OFFSET: srcSize = LEN(src)

    IF srcSize > 0 THEN ' writing 0 bytes will simply do nothing
        DIM curSize AS _UNSIGNED _OFFSET: curSize = LEN(stringFile.buffer)

        ' Grow the buffer if needed
        IF stringFile.cursor + srcSize >= curSize THEN stringFile.buffer = stringFile.buffer + STRING$(stringFile.cursor + srcSize - curSize, _ASC_NUL)

        MID$(stringFile.buffer, stringFile.cursor + 1, srcSize) = src
        stringFile.cursor = stringFile.cursor + srcSize ' this puts the cursor right after the last position written
    END IF
END SUB

''' @brief Reads a byte from the file.
''' @return The byte read from the file.
FUNCTION StringFile_ReadByte~%% (stringFile AS StringFile)
    IF stringFile.cursor + _SIZE_OF_BYTE <= LEN(stringFile.buffer) THEN ' check if we really have the amount of bytes to read
        StringFile_ReadByte = ASC(stringFile.buffer, stringFile.cursor + 1) ' read the data
        stringFile.cursor = stringFile.cursor + _SIZE_OF_BYTE ' this puts the cursor right after the last position read
    ELSE ' not enough bytes to read
        ERROR _ERR_ILLEGAL_FUNCTION_CALL
    END IF
END FUNCTION

''' @brief Writes a byte to the file.
''' @param src The byte to write.
SUB StringFile_WriteByte (stringFile AS StringFile, src AS _UNSIGNED _BYTE)
    DIM curSize AS _UNSIGNED _OFFSET: curSize = LEN(stringFile.buffer)

    ' Grow the buffer if needed
    IF stringFile.cursor + _SIZE_OF_BYTE >= curSize THEN stringFile.buffer = stringFile.buffer + STRING$(stringFile.cursor + _SIZE_OF_BYTE - curSize, _ASC_NUL)

    ASC(stringFile.buffer, stringFile.cursor + 1) = src ' write the data
    stringFile.cursor = stringFile.cursor + _SIZE_OF_BYTE ' this puts the cursor right after the last position written
END SUB

''' @brief Reads an integer from the file.
''' @return The integer read from the file.
FUNCTION StringFile_ReadInteger~% (stringFile AS StringFile)
    IF stringFile.cursor + _SIZE_OF_INTEGER <= LEN(stringFile.buffer) THEN ' check if we really have the amount of bytes to read
        StringFile_ReadInteger = CVI(MID$(stringFile.buffer, stringFile.cursor + 1, _SIZE_OF_INTEGER)) ' read the data
        stringFile.cursor = stringFile.cursor + _SIZE_OF_INTEGER ' this puts the cursor right after the last position read
    ELSE ' not enough bytes to read
        ERROR _ERR_ILLEGAL_FUNCTION_CALL
    END IF
END FUNCTION

''' @brief Writes an integer to the file.
''' @param src The integer to write.
SUB StringFile_WriteInteger (stringFile AS StringFile, src AS _UNSIGNED INTEGER)
    DIM curSize AS _UNSIGNED _OFFSET: curSize = LEN(stringFile.buffer)

    ' Grow the buffer if needed
    IF stringFile.cursor + _SIZE_OF_INTEGER >= curSize THEN stringFile.buffer = stringFile.buffer + STRING$(stringFile.cursor + _SIZE_OF_INTEGER - curSize, _ASC_NUL)

    MID$(stringFile.buffer, stringFile.cursor + 1, _SIZE_OF_INTEGER) = MKI$(src) ' write the data
    stringFile.cursor = stringFile.cursor + _SIZE_OF_INTEGER ' this puts the cursor right after the last position written
END SUB

''' @brief Reads a long from the file.
''' @return The long read from the file.
FUNCTION StringFile_ReadLong~& (stringFile AS StringFile)
    IF stringFile.cursor + _SIZE_OF_LONG <= LEN(stringFile.buffer) THEN ' check if we really have the amount of bytes to read
        StringFile_ReadLong = CVL(MID$(stringFile.buffer, stringFile.cursor + 1, _SIZE_OF_LONG)) ' read the data
        stringFile.cursor = stringFile.cursor + _SIZE_OF_LONG ' this puts the cursor right after the last position read
    ELSE ' not enough bytes to read
        ERROR _ERR_ILLEGAL_FUNCTION_CALL
    END IF
END FUNCTION

''' @brief Writes a long to the file.
''' @param src The long to write.
SUB StringFile_WriteLong (stringFile AS StringFile, src AS _UNSIGNED LONG)
    DIM curSize AS _UNSIGNED _OFFSET: curSize = LEN(stringFile.buffer)

    ' Grow the buffer if needed
    IF stringFile.cursor + _SIZE_OF_LONG >= curSize THEN stringFile.buffer = stringFile.buffer + STRING$(stringFile.cursor + _SIZE_OF_LONG - curSize, _ASC_NUL)

    MID$(stringFile.buffer, stringFile.cursor + 1, _SIZE_OF_LONG) = MKL$(src) ' write the data
    stringFile.cursor = stringFile.cursor + _SIZE_OF_LONG ' this puts the cursor right after the last position written
END SUB

''' @brief Reads a single from the file.
''' @return The single read from the file.
FUNCTION StringFile_ReadSingle! (stringFile AS StringFile)
    IF stringFile.cursor + _SIZE_OF_SINGLE <= LEN(stringFile.buffer) THEN ' check if we really have the amount of bytes to read
        StringFile_ReadSingle = CVS(MID$(stringFile.buffer, stringFile.cursor + 1, _SIZE_OF_SINGLE)) ' read the data
        stringFile.cursor = stringFile.cursor + _SIZE_OF_SINGLE ' this puts the cursor right after the last position read
    ELSE ' not enough bytes to read
        ERROR _ERR_ILLEGAL_FUNCTION_CALL
    END IF
END FUNCTION

''' @brief Writes a single to the file.
''' @param src The single to write.
SUB StringFile_WriteSingle (stringFile AS StringFile, src AS SINGLE)
    DIM curSize AS _UNSIGNED _OFFSET: curSize = LEN(stringFile.buffer)

    ' Grow the buffer if needed
    IF stringFile.cursor + _SIZE_OF_SINGLE >= curSize THEN stringFile.buffer = stringFile.buffer + STRING$(stringFile.cursor + _SIZE_OF_SINGLE - curSize, _ASC_NUL)

    MID$(stringFile.buffer, stringFile.cursor + 1, _SIZE_OF_SINGLE) = MKS$(src) ' write the data
    stringFile.cursor = stringFile.cursor + _SIZE_OF_SINGLE ' this puts the cursor right after the last position written
END SUB

''' @brief Reads an integer64 from the file.
''' @return The integer64 read from the file.
FUNCTION StringFile_ReadInteger64~&& (stringFile AS StringFile)
    IF stringFile.cursor + _SIZE_OF_INTEGER64 <= LEN(stringFile.buffer) THEN ' check if we really have the amount of bytes to read
        StringFile_ReadInteger64 = _CV(_UNSIGNED _INTEGER64, MID$(stringFile.buffer, stringFile.cursor + 1, _SIZE_OF_INTEGER64)) ' read the data
        stringFile.cursor = stringFile.cursor + _SIZE_OF_INTEGER64 ' this puts the cursor right after the last position read
    ELSE ' not enough bytes to read
        ERROR _ERR_ILLEGAL_FUNCTION_CALL
    END IF
END FUNCTION

''' @brief Writes an integer64 to the file.
''' @param src The integer64 to write.
SUB StringFile_WriteInteger64 (stringFile AS StringFile, src AS _UNSIGNED _INTEGER64)
    DIM curSize AS _UNSIGNED _OFFSET: curSize = LEN(stringFile.buffer)

    ' Grow the buffer if needed
    IF stringFile.cursor + _SIZE_OF_INTEGER64 >= curSize THEN stringFile.buffer = stringFile.buffer + STRING$(stringFile.cursor + _SIZE_OF_INTEGER64 - curSize, _ASC_NUL)

    MID$(stringFile.buffer, stringFile.cursor + 1, _SIZE_OF_INTEGER64) = _MK$(_UNSIGNED _INTEGER64, src) ' write the data
    stringFile.cursor = stringFile.cursor + _SIZE_OF_INTEGER64 ' this puts the cursor right after the last position written
END SUB

''' @brief Reads a double from the file.
''' @return The double read from the file.
FUNCTION StringFile_ReadDouble# (stringFile AS StringFile)
    IF stringFile.cursor + _SIZE_OF_DOUBLE <= LEN(stringFile.buffer) THEN ' check if we really have the amount of bytes to read
        StringFile_ReadDouble = CVD(MID$(stringFile.buffer, stringFile.cursor + 1, _SIZE_OF_DOUBLE)) ' read the data
        stringFile.cursor = stringFile.cursor + _SIZE_OF_DOUBLE ' this puts the cursor right after the last position read
    ELSE ' not enough bytes to read
        ERROR _ERR_ILLEGAL_FUNCTION_CALL
    END IF
END FUNCTION

''' @brief Writes a double to the file.
''' @param src The double to write.
SUB StringFile_WriteDouble (stringFile AS StringFile, src AS DOUBLE)
    DIM curSize AS _UNSIGNED _OFFSET: curSize = LEN(stringFile.buffer)

    ' Grow the buffer if needed
    IF stringFile.cursor + _SIZE_OF_DOUBLE >= curSize THEN stringFile.buffer = stringFile.buffer + STRING$(stringFile.cursor + _SIZE_OF_DOUBLE - curSize, _ASC_NUL)

    MID$(stringFile.buffer, stringFile.cursor + 1, _SIZE_OF_DOUBLE) = MKD$(src) ' write the data
    stringFile.cursor = stringFile.cursor + _SIZE_OF_DOUBLE ' this puts the cursor right after the last position written
END SUB
