# addCell.il

## Purpose/Description
Comprehensive cell placement and wiring utilities for schematic design. Provides multiple functions to automatically place standard cells, create pin connections, and generate wire labels in Cadence schematics.

## Function Signatures
```skill
addCell(@optional (cells '("vdd" "gnd" "vdc" "noConn")) (cv t) (xy nil) (simp t) (lib nil))
addCells(@optional (cells '("XOR2_A" "XOR2_B")) (cv nil) (nets '(("A" "A1")("Q" "Q1")("B" "Q7"))) (dx 0.1) (xyext nil))
addCellw(@optional (cell "XOR2X2") (ios '("B1" "A1" "Q1")) (xyg 0:0) (cv geGetWindowCellView()) (dx 0.1) (rot "R0") (pp nil) (verb nil) (fixg t))
addCellw2(@optional (netline '(("DFX1" ("AA" t t "DD")) ("vdc") ("switch" nil))) (xyg 0:0) (cv geGetWindowCellView()) (dxl 0.1) (rot "R0") (verb nil) (dx 0.4))
addCellw3(@optional (netlines '((("vdc" ("gnd!" "vdd!")))) (xyg 0:0) (cv geGetWindowCellView()) (dxl 0.1) (rot "R0") (verb nil) (dx 0.4) (dy 0.0))
labelAtPt(termpt bBox @optional (dx 0.1) (cv geGetWindowCellView()) (font "euroStyle"))
```

## Parameters

### addCell()
- `cells` - List of cell names to place (default: power/ground cells)
- `cv` - Cell view context (default: current window)
- `xy` - Starting position (default: auto-calculated)
- `simp` - Simplification mode (default: t)
- `lib` - Library list for cell lookup (default: auto-search)

### addCellw()
- `cell` - Cell name to place
- `ios` - Pin names for connections (list or special symbols)
- `xyg` - Placement position
- `cv` - Target cell view
- `dx` - Wire label offset
- `rot` - Rotation orientation
- `pp` - Parameter list for parameterized cells
- `verb` - Verbose mode
- `fixg` - Grid alignment flag

## Dependencies
- `whereExistCell3` - Cell location finder
- `getInstTermPoint` - Terminal position extraction
- `angleBox`, `ibBox`, `mbBox` - Bounding box utilities
- Various schematic creation functions

## Return Values
- **addCell()**: List of created instances
- **addCellw()**: Created instance object  
- **addCellw2/3()**: List containing cell view and final position
- **labelAtPt()**: Creates wire with label

## Usage Examples
```skill
; Load the utilities
load("addCell.il")

; Add basic power/ground cells
addCell('("gnd" "vdc" "vdd" "noConn"))

; Add cells with specific libraries
addCell('("gnd" "noConn") t nil t '("analogLib" "basic"))

; Add single cell with pin connections
addCellw("XOR2X1" '("A_in" "B_in" "Q_out") 0:0)

; Add cell with automatic pin naming
addCellw("INVX1" '("AA" t) 0:-1)  ; 't' creates automatic noConn

; Add multiple cells in sequence
netline = '(("DFX1" ("AA" t t "DD")) ("vdc") ("switch" ("O" "i" "a")))
addCellw2(netline)

; Add multiple rows of cells
netlines = '((("vdc" ("gnd!" "vdd!"))) (("DFX1" ("AA" t t "DD")) ("vdc") ("switch" nil)))
addCellw3(netlines)
```

## Notes/Special Considerations
- **Grid Alignment**: Uses schematic snap spacing for proper alignment
- **Instance Naming**: Auto-generates unique instance names (I0, I1, I2...)
- **Pin Handling**: Supports various pin connection modes:
  - `t` = automatic noConn placement
  - `nil` = skip pin
  - String = specific net name
- **Library Search**: Automatically finds cells across multiple libraries
- **Orientation**: Supports rotation-based pin positioning
- **Wire Creation**: Automatically creates wires and labels for connections
- **Simulation Support**: Handles "_sim" suffixed cell names specially
- **Parameterized Cells**: Supports cells with parameters via `pp` argument