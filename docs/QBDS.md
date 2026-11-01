# **QBDS**

`QBDS` is a collection of **generic data structure libraries**. It provides containers such as queues, lists, stacks, maps, and more.

## Libraries

* [**Array**](./Array.md): Dynamic array with resizing.
* [**HMap**](./HMap.md): Generic hash map.
* [**HMap64**](./HMap64.md): Hash map optimized for 64-bit keys.
* [**HSet**](./HSet.md): Generic hash set.
* [**LList**](./LList.md): Doubly linked list.
* [**Queue**](./Queue.md): FIFO queue.
* [**Stack**](./Stack.md): LIFO stack.

## QBDS.bi

The `QBDS.bi` file defines some **common constants and routines** shared across all `QBDS` libraries.

### Constants

These constants identify the type of data stored in a container:

| Constant              | Description                             |
| --------------------- | --------------------------------------- |
| `QBDS_TYPE_NONE`      | Unused entry                            |
| `QBDS_TYPE_RESERVED`  | Metadata entry                          |
| `QBDS_TYPE_DELETED`   | Deleted entry (tombstone)               |
| `QBDS_TYPE_STRING`    | Variable-length string                  |
| `QBDS_TYPE_BYTE`      | 8-bit integer                           |
| `QBDS_TYPE_INTEGER`   | 16-bit integer                          |
| `QBDS_TYPE_LONG`      | 32-bit integer                          |
| `QBDS_TYPE_INTEGER64` | 64-bit integer                          |
| `QBDS_TYPE_SINGLE`    | 32-bit floating-point number            |
| `QBDS_TYPE_DOUBLE`    | 64-bit floating-point number            |
| `QBDS_TYPE_UDT`       | User-defined data types (10–255)        |

## API Reference

Computes a 64-bit FNV-1a hash for the STRING `k`.

```vb
FUNCTION QBDS_Hash~&& (k AS STRING)
```
