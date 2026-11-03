'-----------------------------------------------------------------------------------------------------------------------
' User configurable timer library
' Copyright (c) 2026 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$INCLUDEONCE

'$INCLUDE:'Time.bi'

CONST TIMER_INVALID& = 0

''' @brief Timer type and storage.
TYPE __Timer
    active AS _BYTE ' is this timer active?
    paused AS _BYTE ' is this timer paused?
    oneShot AS _BYTE ' is this a one-shot timer?
    intervalTicks AS _UNSIGNED _INTEGER64 ' interval length, in ticks (1000 ticks = 1 second)
    lastTick AS _UNSIGNED _INTEGER64 ' last time we advanced this timer
    pausedTick AS _UNSIGNED _INTEGER64 ' time when the timer was paused
END TYPE

REDIM __timer(1 TO 1) AS __Timer
DIM __timerLastFree AS LONG

''' @brief Initializes or resets the timer library, releasing all active timers.
SUB Timer_Initialize
    SHARED __timer() AS __Timer
    SHARED __timerLastFree AS LONG

    REDIM __timer(1 TO 1) AS __Timer
    __timer(1).active = _FALSE
    __timerLastFree = 1
END SUB

''' @brief Checks if a timer handle is valid and currently active.
''' @param id Timer ID.
''' @return _TRUE if the timer exists and is active, _FALSE otherwise.
FUNCTION Timer_Exists%% (id AS LONG)
    SHARED __timer() AS __Timer

    IF id > TIMER_INVALID _ANDALSO id <= UBOUND(__timer) THEN
        Timer_Exists = __timer(id).active
    END IF
END FUNCTION

''' @brief Internal routine to allocate and initialize a timer slot.
''' @param intervalTicks Interval in ticks (milliseconds).
''' @param isOneShot _TRUE for a one-shot timer, _FALSE for periodic.
''' @return Timer ID (> 0), or 0 on failure.
FUNCTION __Timer_Allocate& (intervalTicks AS _UNSIGNED _INTEGER64, isOneShot AS _BYTE)
    SHARED __timer() AS __Timer
    SHARED __timerLastFree AS LONG

    IF __timerLastFree <= TIMER_INVALID THEN __timerLastFree = 1

    DIM timersUB AS LONG: timersUB = UBOUND(__timer)

    ' Find a free slot
    WHILE __timerLastFree <= timersUB _ANDALSO __timer(__timerLastFree).active
        __timerLastFree = __timerLastFree + 1
    WEND

    ' If no free slot, expand the array
    IF __timerLastFree > timersUB THEN
        REDIM _PRESERVE __timer(1 TO __timerLastFree) AS __Timer
    END IF

    DIM id AS LONG: id = __timerLastFree

    __timer(id).active = _TRUE
    __timer(id).paused = _FALSE
    __timer(id).oneShot = isOneShot
    __timer(id).intervalTicks = intervalTicks
    __timer(id).lastTick = Time_GetTicks
    __timer(id).pausedTick = 0

    ' Advance hint for next allocation
    __timerLastFree = __timerLastFree + 1

    __Timer_Allocate = id
END FUNCTION

''' @brief Creates a new periodic interval timer.
''' @param intervalTicks Interval in ticks (milliseconds).
''' @return Timer ID (> 0).
FUNCTION Timer_Create& (intervalTicks AS _UNSIGNED _INTEGER64)
    Timer_Create = __Timer_Allocate&(intervalTicks, _FALSE)
END FUNCTION

''' @brief Creates a new one-shot timer that automatically deactivates after firing once.
''' @param intervalTicks Interval in ticks (milliseconds).
''' @return Timer ID (> 0).
FUNCTION Timer_CreateOneShot& (intervalTicks AS _UNSIGNED _INTEGER64)
    Timer_CreateOneShot = __Timer_Allocate&(intervalTicks, _TRUE)
END FUNCTION

''' @brief Deletes an active timer and frees its resources.
''' @param id Timer ID.
SUB Timer_Delete (id AS LONG)
    SHARED __timer() AS __Timer
    SHARED __timerLastFree AS LONG

    IF Timer_Exists(id) THEN
        __timer(id).active = _FALSE
        __timer(id).paused = _FALSE
        IF id < __timerLastFree THEN __timerLastFree = id
    END IF
END SUB

''' @brief Resets the timer's elapsed time back to zero (current time) and unpauses it.
''' @param id Timer ID.
SUB Timer_Reset (id AS LONG)
    SHARED __timer() AS __Timer

    IF Timer_Exists(id) THEN
        __timer(id).lastTick = Time_GetTicks
        __timer(id).paused = _FALSE
    END IF
END SUB

''' @brief Gets the timer interval in ticks (milliseconds).
''' @param id Timer ID.
''' @return Interval in ticks.
FUNCTION Timer_GetInterval~&& (id AS LONG)
    SHARED __timer() AS __Timer

    IF Timer_Exists(id) THEN
        Timer_GetInterval = __timer(id).intervalTicks
    END IF
END FUNCTION

''' @brief Sets a new timer interval in ticks (milliseconds).
''' @param id Timer ID.
''' @param intervalTicks New interval in ticks.
SUB Timer_SetInterval (id AS LONG, intervalTicks AS _UNSIGNED _INTEGER64)
    SHARED __timer() AS __Timer

    IF Timer_Exists(id) THEN
        __timer(id).intervalTicks = intervalTicks
    END IF
END SUB

''' @brief Checks if a timer is configured as a one-shot timer.
''' @param id Timer ID.
''' @return _TRUE if one-shot, _FALSE if periodic.
FUNCTION Timer_IsOneShot%% (id AS LONG)
    SHARED __timer() AS __Timer

    IF Timer_Exists(id) THEN
        Timer_IsOneShot = __timer(id).oneShot
    END IF
END FUNCTION

''' @brief Sets whether a timer is one-shot.
''' @param id Timer ID.
''' @param isOneShot _TRUE for one-shot, _FALSE for periodic.
SUB Timer_SetOneShot (id AS LONG, isOneShot AS _BYTE)
    SHARED __timer() AS __Timer

    IF Timer_Exists(id) THEN
        __timer(id).oneShot = isOneShot
    END IF
END SUB

''' @brief Pauses a timer. The elapsed time within the current interval is preserved.
''' @param id Timer ID.
SUB Timer_Pause (id AS LONG)
    SHARED __timer() AS __Timer

    IF Timer_Exists(id) _ANDALSO _NEGATE __timer(id).paused THEN
        __timer(id).paused = _TRUE
        __timer(id).pausedTick = Time_GetTicks
    END IF
END SUB

''' @brief Resumes a paused timer, accurately preserving any remaining time.
''' @param id Timer ID.
SUB Timer_Resume (id AS LONG)
    SHARED __timer() AS __Timer

    IF Timer_Exists(id) _ANDALSO __timer(id).paused THEN
        __timer(id).paused = _FALSE
        __timer(id).lastTick = __timer(id).lastTick + (Time_GetTicks - __timer(id).pausedTick)
    END IF
END SUB

''' @brief Checks if a timer is currently paused.
''' @param id Timer ID.
''' @return _TRUE if paused, _FALSE otherwise.
FUNCTION Timer_IsPaused%% (id AS LONG)
    SHARED __timer() AS __Timer

    IF Timer_Exists(id) THEN
        Timer_IsPaused = __timer(id).paused
    END IF
END FUNCTION

''' @brief Returns the number of ticks elapsed in the current interval.
''' @param id Timer ID.
''' @return Elapsed ticks in the current interval.
FUNCTION Timer_GetElapsedTicks~&& (id AS LONG)
    SHARED __timer() AS __Timer

    IF Timer_Exists(id) THEN
        IF __timer(id).paused THEN
            Timer_GetElapsedTicks = __timer(id).pausedTick - __timer(id).lastTick
        ELSE
            DIM currentTicks AS _UNSIGNED _INTEGER64: currentTicks = Time_GetTicks
            IF currentTicks >= __timer(id).lastTick THEN
                Timer_GetElapsedTicks = currentTicks - __timer(id).lastTick
            END IF
        END IF
    END IF
END FUNCTION

''' @brief Returns the number of ticks remaining before the timer fires.
''' @param id Timer ID.
''' @return Remaining ticks until next fire, or 0 if elapsed / invalid.
FUNCTION Timer_GetRemainingTicks~&& (id AS LONG)
    SHARED __timer() AS __Timer

    IF Timer_Exists(id) THEN
        DIM elapsed AS _UNSIGNED _INTEGER64: elapsed = Timer_GetElapsedTicks(id)
        IF elapsed < __timer(id).intervalTicks THEN
            Timer_GetRemainingTicks = __timer(id).intervalTicks - elapsed
        END IF
    END IF
END FUNCTION

''' @brief Polls the timer to check if the interval has elapsed.
''' @param id Timer ID.
''' @return _TRUE if the interval has elapsed, _FALSE otherwise.
FUNCTION Timer_Poll%% (id AS LONG)
    SHARED __timer() AS __Timer
    SHARED __timerLastFree AS LONG

    IF Timer_Exists(id) _ANDALSO _NEGATE __timer(id).paused THEN
        DIM currentTicks AS _UNSIGNED _INTEGER64: currentTicks = Time_GetTicks
        DIM elapsedTicks AS _UNSIGNED _INTEGER64: elapsedTicks = currentTicks - __timer(id).lastTick

        IF elapsedTicks >= __timer(id).intervalTicks THEN
            IF __timer(id).oneShot THEN
                ' One-shot timers deactivate upon firing
                __timer(id).active = _FALSE
                IF id < __timerLastFree THEN __timerLastFree = id
            ELSE
                ' Periodic timers: advance lastTick.
                ' If lagging by more than 2 full intervals (e.g. window was dragged or app blocked),
                ' snap to current time to avoid a catch-up trigger storm.
                IF elapsedTicks >= (__timer(id).intervalTicks * 2) THEN
                    __timer(id).lastTick = currentTicks
                ELSE
                    __timer(id).lastTick = __timer(id).lastTick + __timer(id).intervalTicks
                END IF
            END IF
            Timer_Poll = _TRUE
        END IF
    END IF
END FUNCTION

''' @brief Calculates the number of ticks (milliseconds) for a given frequency in Hertz.
''' @param hertz Desired frequency in Hertz (> 0).
''' @return The number of ticks, or 0 if hertz <= 0.
FUNCTION Timer_GetTicksFromHertz~&& (hertz AS SINGLE)
    IF hertz > 0! THEN
        Timer_GetTicksFromHertz = TIME_TICKS_PER_SECOND / hertz
    END IF
END FUNCTION

''' @brief Calculates the frequency in Hertz for a given interval in ticks.
''' @param ticks Interval in ticks (> 0).
''' @return The frequency in Hertz, or 0 if ticks = 0.
FUNCTION Timer_GetHertzFromTicks! (ticks AS _UNSIGNED _INTEGER64)
    IF ticks > 0 THEN
        Timer_GetHertzFromTicks = TIME_TICKS_PER_SECOND / ticks
    END IF
END FUNCTION
