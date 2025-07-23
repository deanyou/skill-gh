# CntUcnt.il

## Purpose/Description
Generates schematic circuits from symbolic expressions, converting combinatorial logic descriptions into schematic layouts. Contains functions to parse combinatorial logic expressions and automatically place standard cells, create pins, and connect nets.

## Function Signatures
```skill
parseCombi(lis @optional (args nil) (row nil) (verb t))
combiToSch(@optional (Ai nil) (cellname "parseCombi") (libname "LARZIC") (libStd "CORELIB") (split t) (ystep 0.48))
```

## Parameters

### parseCombi()
- `lis` - List containing symbolic logic expressions
- `args` - Optional argument list for parent-child relationships
- `row` - Optional row position (X:Y coordinates)
- `verb` - Verbose mode flag (default: t)

### combiToSch()
- `Ai` - Symbolic logic expression (default: NAND gate example)
- `cellname` - Name for generated schematic cell (default: "parseCombi")
- `libname` - Target library name (default: "LARZIC")
- `libStd` - Standard cell library (default: "CORELIB")
- `split` - Enable list splitting (default: t)
- `ystep` - Y-axis step size (default: 0.48)

## Dependencies
- Standard cell libraries (CORELIB, PRACTIC_32, cmos8rf)
- Layout functions: `bBoxWidth`, `bBoxHeight`, `getInstTermPoint`
- Schematic creation functions from Cadence

## Return Values
- `parseCombi()`: Returns processed list structure
- `combiToSch()`: Creates schematic cell view and opens it

## Usage Examples
```skill
; Load the functions
load("CntUcnt.il")

; Simple combinational logic
combi='NOR20(NOR20("IN" "OUT_0") "RC")
combiToSch(combi "newCellName" "LARZIC")

; Complex counter logic with flip-flops
combi='INV0(NAND20(INV0("reset!") DF1(NAND20(NAND20("CNT!" "Qi-1") NAND40(INV0("CNT!") "Qi-1" "Qi" "Qi+1")) "clk!")))
combiToSch(combi "ARST1" "LARZIC")

; Multi-bit counter array
A2='((NAND20 (NAND20 "CNT" "Q0") (NAND40 (INV0 "CNT") "Q0" "Q1" "Q2")) 
     (NAND20 (NAND20 "CNT" "Q1") (NAND40 (INV0 "CNT") "Q1" "Q2" "Q3")))
parseCombi(A2)
```

## Notes/Special Considerations
- **Symbolic Logic**: Uses LISP-like expressions for logic gates (NAND20, INV0, DF1, etc.)
- **Auto-routing**: Automatically creates wires between connected pins
- **Pin Management**: Handles input/output pin creation and naming
- **Standard Cells**: Supports various gate libraries (NAND, NOR, INV, flip-flops)
- **Hierarchical**: Supports nested logic expressions
- **Coordinate System**: Uses grid-based placement (0.0325 grid)
- **Rotation**: Supports component rotation (R0, R90, etc.)
- **Library Management**: Automatically selects writable libraries
- **Warning**: Code contains known bugs in flip-flop output handling as noted by author