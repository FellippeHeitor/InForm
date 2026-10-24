'-----------------------------------------------------------------------------------------------------------------------
' User configurable timer library
' Copyright (c) 2025 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$INCLUDEONCE

'$INCLUDE:'Time.bi'

''' @brief Timer type and storage.
TYPE __Timer
    active AS _BYTE ' is this timer active?
    paused AS _BYTE ' is this timer paused?
    intervalTicks AS _UNSIGNED _INTEGER64 ' interval length, in ticks
    lastTick AS _UNSIGNED _INTEGER64 ' last time we advanced this timer
    pausedTick AS _UNSIGNED _INTEGER64 ' time when the timer was paused
END TYPE

REDIM __timer(0) AS __Timer, __timerLastFree AS _UNSIGNED _OFFSET
