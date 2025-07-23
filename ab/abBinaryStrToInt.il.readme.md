# abBinaryStrToInt.il

## Purpose/Description
Provides functions to convert between binary strings and integers using bit field operations. This utility enables conversion of binary representations to numeric values and vice versa.

## Function Signatures
```skill
abBinaryStrToInt(str)
abIntToBinaryStr(val @optional (bits 32))
```

## Parameters

### abBinaryStrToInt()
- `str` - Binary string containing only '1' and '0' characters

### abIntToBinaryStr()
- `val` - Integer value to convert to binary string
- `bits` - Width of resulting binary string (default: 32)

## Dependencies
- `setqbitfield1()` - SKILL bit field manipulation function
- `bitfield1()` - SKILL bit field extraction function
- `onep()` - SKILL predicate for testing if value equals 1

## Return Values
- **abBinaryStrToInt()**: Returns integer representation of binary string
- **abIntToBinaryStr()**: Returns binary string representation of integer

## Usage Examples
```skill
; Load the functions
load("ab/abBinaryStrToInt.il")

; Convert binary string to integer
result = abBinaryStrToInt("1011")
; Result: 11

; Convert integer to binary string
binary = abIntToBinaryStr(11 4)
; Result: "1011"

; Convert larger binary number
result = abBinaryStrToInt("11110000")
; Result: 240

; Convert with custom bit width
binary = abIntToBinaryStr(240 8)
; Result: "11110000"

; Full 32-bit conversion
binary = abIntToBinaryStr(42)
; Result: "00000000000000000000000000101010"

; Error handling examples
; abBinaryStrToInt("1102")  ; Error: illegal character
; abBinaryStrToInt(string of 33+ bits)  ; Error: too many bits
```

## Algorithm Details

### abBinaryStrToInt()
1. Validates string length (≤32 bits)
2. Iterates through each character
3. Uses `setqbitfield1()` to set corresponding bit
4. Validates each character is '0' or '1'

### abIntToBinaryStr()
1. Validates bit width (≤32 bits)
2. Iterates through each bit position
3. Uses `bitfield1()` to extract bit value
4. Builds string from most significant to least significant bit

## Notes/Special Considerations
- **Bit Limit**: Maximum 32 bits supported for both functions
- **Error Handling**: Provides clear error messages for invalid input
- **Character Validation**: Strict validation of binary string characters
- **Bit Ordering**: Most significant bit first in string representation
- **Padding**: `abIntToBinaryStr()` pads with leading zeros to specified width
- **Author**: Created by A.D.Beckett from Cadence Design Systems Ltd.
- **Date**: Originally created February 11, 2011
- **SCCS Info**: Version controlled with SCCS system