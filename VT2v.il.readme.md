# VT2v.il

## Purpose/Description
Converts Virtuoso hierarchical net names (VT format) to SPICE-compatible voltage node names. Transforms path-based net names with special character escaping for simulation compatibility.

## Function Signature
```skill
VT2v(@optional (nets "/I0/I17/I17/Ireg<9>/Q<10>"))
```

## Parameters
- `nets` - Single net name (string) or list of net names to convert

## Dependencies
- `parseString()` - SKILL string parsing function
- `buildString()` - SKILL string building function
- `strcat()` - String concatenation function
- `rexMatchp()` - Regular expression matching function

## Return Values
- Returns list of converted net names in SPICE format
- Handles hierarchical separators and bus notation

## Usage Examples
```skill
; Load the function
load("VT2v.il")

; Convert single hierarchical net
result1 = VT2v("/I0/FLUSH")
; Result: ("I0.FLUSH")

; Convert net with bus notation
result2 = VT2v("/I0/I17/I17/regIO<5>")
; Result: ("I0.I17.I17.regIO\\<5\\>")

; Convert complex hierarchical bus
result3 = VT2v("/I0/I17/I17/Ireg<9>/Q<10>")
; Result: ("I0.I17.I17.Ireg\\<9\\>.Q\\<10\\>")

; Convert multiple nets at once
nets = list("/I0/FLUSH" "/I0/I17/I17/regIO<5>" "/I0/I17/I17/Ireg<9>/Q<10>")
results = VT2v(nets)
; Result: ("I0.FLUSH" "I0.I17.I17.regIO\\<5\\>" "I0.I17.I17.Ireg\\<9\\>.Q\\<10\\>")

; Print converted names for simulation
Ccnt = '("/I0/I47/Q<1>" "/I0/I47/Q<2>" "/I0/I47/Q<3>" "/I0/I47/Q<4>" "/FLUSH_OUT")
foreach(mapcar c Ccnt printf("%s " car(VT2v(c))))
; Output: I0.I47.Q\<1\> I0.I47.Q\<2\> I0.I47.Q\<3\> I0.I47.Q\<4\> FLUSH_OUT
```

## Notes/Special Considerations
- **Hierarchical Conversion**: Replaces "/" separators with "."
- **Bus Escaping**: Escapes "<" and ">" characters with backslashes for SPICE compatibility
- **Input Flexibility**: Accepts both single strings and lists of strings
- **SPICE Format**: Output compatible with SPICE simulation tools
- **Special Characters**: Handles complex hierarchical names with array indices
- **Regex Handling**: Uses regular expressions to detect and handle bus endings
- **Simulation Ready**: Converts Virtuoso net names to simulator-compatible format