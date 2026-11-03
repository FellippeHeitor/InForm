# Catch Library

The `Catch` library provides a minimalistic test framework for QB64-PE, inspired by Catch2 for C++. It allows you to write test cases and assertions to verify the correctness of your code.

## Usage

To use the `Catch` library, include `Catch.bi` in your project.

```vb
'$INCLUDE:'Catch.bi'

TEST_BEGIN_ALL

    TEST_CASE_BEGIN "My Test Case"

        TEST_CHECK 1 = 1, "This should pass"
        TEST_REQUIRE 2 > 1, "This is required"

    TEST_CASE_END

TEST_END_ALL
```

Runtime error handling is built-in and enabled by default, allowing your test program to exit cleanly if a runtime error occurs.

## API Reference

### Test Structure

Initializes the test framework. Must be called once at the beginning of your test program.

```vb
SUB TEST_BEGIN_ALL
```

Finalizes the test framework and prints the test results. Must be called once at the end of your test program.

```vb
SUB TEST_END_ALL
```

Begins a new test case with the given name.

```vb
SUB TEST_CASE_BEGIN (testName AS STRING)
```

Ends the current test case.

```vb
SUB TEST_CASE_END
```

### Assertions

Checks if the condition is `_TRUE`. If `_FALSE`, records a failure but continues the test case.

```vb
SUB TEST_CHECK (condition AS _INTEGER64, message AS STRING)
```

Same as `TEST_CHECK` but without a custom message.

```vb
SUB TEST_CHECK2 (condition AS _INTEGER64)
```

Checks if the condition is `_FALSE`. If `_TRUE`, records a failure but continues the test case.

```vb
SUB TEST_CHECK_FALSE (condition AS _INTEGER64, message AS STRING)
```

Same as `TEST_CHECK_FALSE` but without a custom message.

```vb
SUB TEST_CHECK_FALSE2 (condition AS _INTEGER64)
```

Requires the condition to be `_TRUE`. If `_FALSE`, records a failure and aborts the current test case.

```vb
SUB TEST_REQUIRE (condition AS _INTEGER64, message AS STRING)
```

Same as `TEST_REQUIRE` but without a custom message.

```vb
SUB TEST_REQUIRE2 (condition AS _INTEGER64)
```

Requires the condition to be `_FALSE`. If `_TRUE`, records a failure and aborts the current test case.

```vb
SUB TEST_REQUIRE_FALSE (condition AS _INTEGER64, message AS STRING)
```

Same as `TEST_REQUIRE_FALSE` but without a custom message.

```vb
SUB TEST_REQUIRE_FALSE2 (condition AS _INTEGER64)
```

### Control Functions

Returns `_TRUE` if the current test case has been aborted (due to a `TEST_REQUIRE` failure).

```vb
FUNCTION TEST_ABORTED%%
```

Enables or disables color output in the test results.

```vb
SUB TEST_ENABLE_COLOR (enable AS _INTEGER64)
```

Enables or disables automatic program exit after `TEST_END_ALL`.

```vb
SUB TEST_ENABLE_EXIT_ON_END (enable AS _INTEGER64)
```

Sets the random number generator seed.

```vb
SUB TEST_SET_RNG_SEED (rngSeed AS _UNSIGNED _INTEGER64)
```

### Preprocessor Variables

```vb
$LET TEST_STRICT = TRUE
```

Setting this to TRUE changes the default type to LONG and forces explicit variable declarations. This must be set before including `Catch.bi`.

```vb
$LET TEST_CONSOLE_ONLY = TRUE
```

Setting this to TRUE disables the QB64 graphics window. This must be set before including `Catch.bi`.
