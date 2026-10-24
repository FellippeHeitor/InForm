'-----------------------------------------------------------------------------------------------------------------------
' Time related routines
' Copyright (c) 2025 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$INCLUDEONCE

CONST TIME_TICKS_PER_SECOND~&& = 1000

DECLARE LIBRARY
    ''' @brief Retrieves the number of ticks since the application started.
    ''' @return Number of ticks (1000 ticks = 1 second) as a 64-bit integer.
    FUNCTION Time_GetTicks~&& ALIAS "GetTicks"
END DECLARE
