# Time Library

The `Time` library provides time-related utility functions, including a high-resolution timer and a frequency measurement tool.

## Usage

To use the `Time` library, you need to include `Time.bi` and `Time.bm` in your project.

```vb
'$INCLUDE:'Time.bi'

DIM startTicks AS _INTEGER64
startTicks = Time_GetTicks

' Some delay
SLEEP 2

DIM endTicks AS _INTEGER64
endTicks = Time_GetTicks

PRINT "Elapsed Milliseconds: "; endTicks - startTicks

DO
    ' Your game loop or other frequently called code

    PRINT "Hertz: "; Time_MeasureHertz
LOOP UNTIL _KEYHIT = _ASC_ESC

'$INCLUDE:'Time.bm'
```

## API Reference

### Timers

***

Retrieves the number of ticks since the application started. The resolution of the timer is 1 millisecond (1000 ticks per second).

**Returns:**
Number of ticks as an `_INTEGER64` integer.

```vb
FUNCTION Time_GetTicks~&&
```

***

### Measurement

***

Measures the number of times the function is called per second (Hertz). This is useful for performance monitoring and framerate counters.

**Returns:**
The number of calls per second as a `LONG` integer.

**Note:**
This function must be called continuously (e.g., inside a loop) to provide a meaningful value. It updates its return value once per second.

```vb
FUNCTION Time_MeasureHertz~&
```
