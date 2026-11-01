'-----------------------------------------------------------------------------------------------------------------------
' Time related routines
' Copyright (c) 2026 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$INCLUDEONCE

CONST TIME_TICKS_PER_SECOND~&& = 1000

DECLARE LIBRARY
    ''' @brief Retrieves the number of ticks since the application started.
    ''' @return Number of ticks (1000 ticks = 1 second) as a 64-bit integer.
    FUNCTION Time_GetTicks~&& ALIAS "GetTicks"
END DECLARE

''' @brief Measures the number of times this function is called per second.
''' @return The number of calls per second.
FUNCTION Time_MeasureHertz~&
    STATIC AS _UNSIGNED LONG counter, finalHz
    STATIC lastMs AS _UNSIGNED _INTEGER64

    DIM currentMs AS _UNSIGNED _INTEGER64: currentMs = Time_GetTicks

    IF currentMs - lastMs >= TIME_TICKS_PER_SECOND THEN
        lastMs = currentMs
        finalHz = counter
        counter = 0
    END IF

    counter = counter + 1

    Time_MeasureHertz = finalHz
END FUNCTION
