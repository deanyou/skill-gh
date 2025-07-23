# a2s.il

## Purpose/Description
Converts any data type to string representation. This utility function converts all elements in a list to strings, handling both string and non-string data types uniformly.

## Function Signature
```skill
a2s(r)
```

## Parameters
- `r` - List containing mixed data types to be converted to strings

## Dependencies
- `sprintf()` - SKILL string formatting function
- `stringp()` - SKILL string type checking function

## Return Values
- Returns a list where all elements are converted to string representation
- Preserves list structure and order

## Usage Examples
```skill
; Load the function
load("a2s.il")

; Convert mixed data types to strings
r = '(1 62 "Red" 840 1)
result = a2s(r)
; Result: ("1" "62" "Red" "840" "1")

; Convert symbols and numbers
mixed = '(L 1 "3" _)
result = a2s(mixed)
; Result: ("L" "1" "3" "_")

; Handle various data types
data = '(3.14 'symbol "already_string" 42)
result = a2s(data)
; Result: ("3.14" "symbol" "already_string" "42")
```

## Notes/Special Considerations
- **Data Type Handling**: Preserves strings as-is, converts other types using `sprintf`
- **List Processing**: Works on entire lists, not individual elements
- **Deprecated Note**: Author mentions this function may be replaced ("TOREMOVE!")
- **Original Intent**: Originally designed for use with `mapcar` on individual elements
- **Format Preservation**: Uses `%L` format specifier for non-string conversion
- **Type Safety**: Checks if element is already a string before conversion