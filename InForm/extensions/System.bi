'-----------------------------------------------------------------------------------------------------------------------
' Low-level OS and process functions
' Copyright (c) 2026 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$INCLUDEONCE

DECLARE LIBRARY
    ''' @brief Retrieves the current process ID.
    ''' @return The process ID as a 32-bit integer.
    FUNCTION System_GetProcessID& ALIAS "getpid"
END DECLARE
