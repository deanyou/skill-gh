# MyUnique.il

## Purpose/Description
Removes duplicate elements from a list while preserving order. This is a custom implementation of a unique function that tracks seen elements using a hash table for efficient duplicate detection.

## Function Signature
```skill
MyUnique(lst)
```

## Parameters
- `lst` - Input list that may contain duplicate elements

## Dependencies
- `makeTable()` - Cadence SKILL hash table function
- `setof()` - SKILL filtering function

## Return Values
- Returns a new list with duplicate elements removed
- Preserves the order of first occurrence of each element

## Usage Examples
```skill
; Load the function
load("MyUnique.il")

; Remove duplicates from a simple list
numbers = '(1 2 3 2 4 3 5)
unique_numbers = MyUnique(numbers)
; Result: (1 2 3 4 5)

; Remove duplicates from a string list
names = '("alice" "bob" "charlie" "alice" "david" "bob")
unique_names = MyUnique(names)
; Result: ("alice" "bob" "charlie" "david")

; Works with mixed data types
mixed = '(1 "hello" 2.5 1 "world" 2.5 "hello")
unique_mixed = MyUnique(mixed)
; Result: (1 "hello" 2.5 "world")

; Empty list handling
empty_result = MyUnique('())
; Result: ()
```

## Notes/Special Considerations
- **Performance**: Uses hash table for O(1) lookup, making it efficient for large lists
- **Order Preservation**: Maintains the order of first occurrence
- **Memory Usage**: Creates a hash table that grows with unique elements
- **Data Types**: Works with any SKILL data types (numbers, strings, symbols, lists)
- **Hash Table**: Uses 'seen as the table name with nil default value
- **Algorithm**: Implements filter-based approach using `setof` with hash table lookup
- **Thread Safety**: Not thread-safe due to shared hash table
- **Source**: Based on Cadence Community forums discussion for removing duplicates