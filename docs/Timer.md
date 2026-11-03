# Timer Library

The `Timer` library provides non-blocking, cooperative interval timers designed specifically for event-driven applications like InForm. It allows managing multiple independent periodic or one-shot timers with millisecond resolution, pause/resume capability, dynamic interval adjustment, and drift compensation without the re-entrancy risks associated with `ON TIMER` subroutines.

## Features

- **Cooperative & Thread-Safe**: Operates via non-blocking polling (`Timer_Poll`), typically inside InForm's `__UI_BeforeUpdateDisplay` or `__UI_BeforeCheckEvents` hooks, eliminating re-entrancy hazards while drawing.
- **Midnight-Safe**: Built on top of `Time_GetTicks`, avoiding the midnight rollover bug of QB64's `TIMER`.
- **Periodic & One-Shot**: Supports continuous periodic intervals as well as self-deactivating one-shot timers.
- **Accurate Pause & Resume**: Preserves elapsed time within an interval so resuming continues where it left off.
- **Lag Compensation**: Prevents "catch-up storms" if the application is frozen, dragged, or blocked.

## Usage

Include `Timer.bi` in your project:

```vb
'$INCLUDE:'InForm/extensions/Timer.bi'
```

### Basic Example (inside InForm)

```vb
' In form load or initialization:
DIM SHARED blinkTimer AS LONG
DIM SHARED clockTimer AS LONG
DIM SHARED autoHideTimer AS LONG

SUB __UI_OnLoad
    ' A 500 ms periodic timer (2 Hz)
    blinkTimer = Timer_Create(500)

    ' A 1000 ms (1 second) periodic timer
    clockTimer = Timer_Create(1000)

    ' A 5-second one-shot timer to auto-hide a banner
    autoHideTimer = Timer_CreateOneShot(5000)
END SUB

SUB __UI_BeforeUpdateDisplay
    ' Poll timers non-blockingly on every frame
    IF Timer_Poll(blinkTimer) THEN
        ' Toggle status indicator / LED
    END IF

    IF Timer_Poll(clockTimer) THEN
        ' Update status bar clock
        Caption(ClockLabel) = TIME$
    END IF

    IF Timer_Poll(autoHideTimer) THEN
        ' Auto-hide banner after 5 seconds
        Control(BannerPanel).Hidden = _TRUE
    END IF
END SUB
```

---

## API Reference

### Lifecycle & Management

---

#### `Timer_Create`

Creates a new periodic interval timer.

```vb
FUNCTION Timer_Create& (intervalTicks AS _UNSIGNED _INTEGER64)
```

- **Parameters:**
  - `intervalTicks`: Interval in milliseconds (1000 ticks = 1 second).
- **Returns:** A unique `LONG` timer handle (`> 0`).

---

#### `Timer_CreateOneShot`

Creates a one-shot timer that automatically deactivates itself after firing once.

```vb
FUNCTION Timer_CreateOneShot& (intervalTicks AS _UNSIGNED _INTEGER64)
```

- **Parameters:**
  - `intervalTicks`: Delay in milliseconds before firing.
- **Returns:** A unique `LONG` timer handle (`> 0`).

---

#### `Timer_Delete`

Deletes an active timer and frees its resources for reuse.

```vb
SUB Timer_Delete (id AS LONG)
```

- **Parameters:**
  - `id`: Timer handle to destroy.

---

#### `Timer_Reset`

Resets the timer's elapsed time back to zero (the current time) and unpauses it.

```vb
SUB Timer_Reset (id AS LONG)
```

---

#### `Timer_Initialize`

Re-initializes the timer system, resetting internal pools and deactivating all timers.

```vb
SUB Timer_Initialize
```

---

### Polling & Status

---

#### `Timer_Poll`

Checks if the timer interval has elapsed. If elapsed, advances the timer (or deactivates it if one-shot) and returns `_TRUE`.

```vb
FUNCTION Timer_Poll%% (id AS LONG)
```

- **Returns:** `_TRUE` (-1) if the interval has elapsed, `_FALSE` (0) otherwise.

---

#### `Timer_Exists`

Checks if a timer handle is valid and active.

```vb
FUNCTION Timer_Exists%% (id AS LONG)
```

- **Returns:** `_TRUE` if active, `_FALSE` if invalid or deleted.

---

#### `Timer_Pause`

Pauses an active timer. The time elapsed within the current interval is preserved.

```vb
SUB Timer_Pause (id AS LONG)
```

---

#### `Timer_Resume`

Resumes a paused timer, accurately preserving any remaining time until the next trigger.

```vb
SUB Timer_Resume (id AS LONG)
```

---

#### `Timer_IsPaused`

Checks if a timer is currently paused.

```vb
FUNCTION Timer_IsPaused%% (id AS LONG)
```

- **Returns:** `_TRUE` if paused, `_FALSE` if running or invalid.

---

### Configuration & Inspection

---

#### `Timer_GetInterval`

Returns the timer's current interval in ticks (milliseconds).

```vb
FUNCTION Timer_GetInterval~&& (id AS LONG)
```

---

#### `Timer_SetInterval`

Dynamically adjusts the timer's interval without resetting elapsed progress.

```vb
SUB Timer_SetInterval (id AS LONG, intervalTicks AS _UNSIGNED _INTEGER64)
```

---

#### `Timer_IsOneShot`

Checks if a timer is configured as a one-shot timer.

```vb
FUNCTION Timer_IsOneShot%% (id AS LONG)
```

---

#### `Timer_SetOneShot`

Configures whether a timer is one-shot (`_TRUE`) or periodic (`_FALSE`).

```vb
SUB Timer_SetOneShot (id AS LONG, isOneShot AS _BYTE)
```

---

#### `Timer_GetElapsedTicks`

Returns the number of milliseconds elapsed in the current interval.

```vb
FUNCTION Timer_GetElapsedTicks~&& (id AS LONG)
```

---

#### `Timer_GetRemainingTicks`

Returns the number of milliseconds remaining before the timer next fires.

```vb
FUNCTION Timer_GetRemainingTicks~&& (id AS LONG)
```

---

### Frequency Helpers

---

#### `Timer_GetTicksFromHertz`

Calculates the interval in ticks (milliseconds) corresponding to a given frequency in Hertz (Hz).

```vb
FUNCTION Timer_GetTicksFromHertz~&& (hertz AS SINGLE)
```

- **Example:** `Timer_GetTicksFromHertz(60)` returns `17` ms (~60 Hz).

---

#### `Timer_GetHertzFromTicks`

Calculates the frequency in Hertz (Hz) corresponding to a given interval in ticks.

```vb
FUNCTION Timer_GetHertzFromTicks! (ticks AS _UNSIGNED _INTEGER64)
```

- **Example:** `Timer_GetHertzFromTicks(20)` returns `50.0` Hz.
