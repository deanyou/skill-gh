# bitString2hexa.il

## Purpose/Description
Converts binary string representations to hexadecimal format. Processes binary strings in 8-bit chunks and converts each chunk to a 2-digit hexadecimal value.

## Function Signature
```skill
bitString2hexa(@optional (bitstr "10111000111011100011") (noquote nil))
```

## Parameters
- `bitstr` - Binary string to convert (default: "10111000111011100011")
- `noquote` - If `t`, prints hex values without quotes (default: nil)

## Dependencies
- `abBinaryStrToInt` - Binary string to integer conversion function

## Return Values
- Returns list of hexadecimal strings (2-digit format)
- If `noquote` is `t`, also prints values to console

## Usage Examples
```skill
; Load the function  
load("bitString2hexa.il")

; Convert default binary string
hex = bitString2hexa()
; Result: ("2e" "e3")  ; from "10111000111011100011"

; Convert custom binary string
binary = "1011100011"
hex = bitString2hexa(binary)
; Result: ("03" "8e")  ; padded to 8-bit boundaries

; Print without quotes
bitString2hexa("10111000111011100011" t)
; Console output: 2e e3
; Return value: ("2e" "e3")

; Combine two binary strings
combined = strcat("1011100011" "1011100011") 
hex = bitString2hexa(combined t)
; Console output: e3 8e e3
; Return value: ("e3" "8e" "e3")

; Convert to full hex string
hex = bitString2hexa()
fullHex = apply('strcat cons("0x" hex))
; Result: "0x2ee3"

; Convert hex to decimal
hex = "0x0b8ee3"
decimal = sprintf(nil "%d" evalstring(hex))
; Result: "757475"
```

## Algorithm
1. Reverses the input bit string
2. Processes in 8-bit chunks from right to left
3. Pads incomplete chunks with empty strings
4. Converts each 8-bit chunk to integer using `abBinaryStrToInt`
5. Formats as 2-digit hexadecimal using `sprintf`
6. Returns reversed list for correct order

## Notes/Special Considerations
- **Chunk Processing**: Processes binary string in 8-bit (byte) chunks
- **Padding**: Automatically handles strings not divisible by 8
- **Format**: Always returns 2-digit hex values (e.g., "0a" not "a")
- **Bit Order**: Processes from least significant to most significant bit
- **Console Output**: Optional printing mode for direct display
- **Integration**: Designed to work with other binary/hex utilities
- **Example Values**: Default example demonstrates 20-bit to hex conversion
- **Endianness**: Handles bit order correctly for standard hex representation