# DLLmklist.il

## Purpose/Description
Generates a delay-locked loop (DLL) structure from a pattern motif. Creates XOR gate arrays based on input patterns and organizes them with appropriate pin naming for DLL applications.

## Function Signature
```skill
DLLmklist(@optional (motif '("E" "F" "H" "I" "E" "F" "H" "I")) (libName 'ibm) (cellName nil))
```

## Parameters
- `motif` - List of pattern strings defining the DLL structure (default: alternating "E", "F", "H", "I" pattern)
- `libName` - Library name for cell generation (default: 'ibm)
- `cellName` - Name for the generated cell (default: auto-generated from motif)

## Dependencies
- `dllGenMotif()` - Function to generate XOR array from motif pattern
- `netMakeBus()` - Function to create bus nets with specified naming

## Return Values
Returns a list containing:
1. List containing the XOR array structure
2. Library name
3. Cell name 
4. Pin list with S and Q buses (reversed order)

```skill
; Return format:
(list(list(xors) libName cellName reverse(pins)))
```

## Usage Examples
```skill
; Load the function
load("DLLmklist.il")

; Generate DLL with default motif
dllResult = DLLmklist()

; Generate DLL with custom motif
customMotif = '("A" "B" "C" "D")
dllResult = DLLmklist(customMotif 'myLib "custom_dll")

; Generate DLL with specific library
dllResult = DLLmklist('("E" "F" "H" "I") 'CORELIB "my_dll_4bit")
```

## Notes/Special Considerations
- **Automatic Naming**: If `cellName` not provided, generates name as "d_" + concatenated motif strings
- **Bus Creation**: Creates S and Q buses with length equal to motif length
- **Pin Ordering**: Returns pins in reverse order (Q bus, then S bus)
- **Motif Dependency**: Assumes `dllGenMotif()` function exists and can process the given motif
- **XOR Structure**: Generates XOR gate arrays suitable for DLL phase detection
- **Library Symbols**: Uses symbolic library names (e.g., 'ibm) which must be valid
- **Bus Naming**: Uses underscore separators for bus bit naming (e.g., "S_0", "S_1", etc.)