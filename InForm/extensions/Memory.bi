'-----------------------------------------------------------------------------------------------------------------------
' Low-level memory manipulation functions
' Copyright (c) 2026 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$INCLUDEONCE

DECLARE CUSTOMTYPE LIBRARY
    SUB Memory_Copy ALIAS "memcpy" (BYVAL dst AS _UNSIGNED _OFFSET, BYVAL src AS _UNSIGNED _OFFSET, BYVAL bytes AS _UNSIGNED _OFFSET)
    SUB Memory_CopySafe ALIAS "memmove" (BYVAL dst AS _UNSIGNED _OFFSET, BYVAL src AS _UNSIGNED _OFFSET, BYVAL bytes AS _UNSIGNED _OFFSET)
END DECLARE

DECLARE LIBRARY
    FUNCTION Memory_SwapByte16~% ALIAS "__builtin_bswap16" (BYVAL x AS _UNSIGNED INTEGER)
    FUNCTION Memory_SwapByte32~& ALIAS "__builtin_bswap32" (BYVAL x AS _UNSIGNED LONG)
    FUNCTION Memory_SwapByte64~&& ALIAS "__builtin_bswap64" (BYVAL x AS _UNSIGNED _INTEGER64)
END DECLARE
