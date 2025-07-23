# CreateVias.il

## Purpose/Description
Creates multiple via stacks at a specified location in a layout cell view. This utility function simplifies the process of creating vertical connections between multiple metal layers.

## Function Signature
```skill
CreateVias(via321 X Y @optional (cv nil) (xCon 0.5) (yCon 0.5))
```

## Parameters
- `via321` - List of via definition objects (typically from `techFindViaDefByName`)
- `X` - X coordinate for via placement
- `Y` - Y coordinate for via placement  
- `cv` - Cell view object (optional, defaults to current window cell view)
- `xCon` - X contact size (optional, default: 0.5) - *Note: currently unused*
- `yCon` - Y contact size (optional, default: 0.5) - *Note: currently unused*

## Dependencies
- Cadence layout database functions (`dbCreateVia`)
- Current cell view context if `cv` not provided

## Return Values
- Creates via instances in the specified cell view
- No explicit return value (side effect function)

## Usage Examples
```skill
; Load the function
load("CreateVias.il")

; Get current cell view and technology
cv = geGetWindowCellView()
tech = techGetTechFile(cv)

; Define via types for a 3-layer stack
viaNames = list("M4_M3_S" "M5_M4_S" "ML_M5_S")
vias = foreach(mapcar v viaNames techFindViaDefByName(tech v))

; Create vias at origin
CreateVias(vias 0 0)

; Create vias at specific location with explicit cell view
CreateVias(vias 10.5 20.3 cv)

; Use with subset of vias (e.g., only upper layers)
CreateVias(nthcdr(1 vias) 5 5)  ; Skip first via, use remaining
```

## Notes/Special Considerations
- **Via Stacking**: Creates all vias in the list at the same X,Y location
- **Technology Dependent**: Via names must exist in the current technology file
- **Layer Order**: Via list typically ordered from bottom to top layers
- **Rotation**: All vias created with "R0" orientation
- **Error Handling**: No explicit error checking for invalid via definitions
- **Contact Parameters**: `xCon` and `yCon` parameters are defined but not currently used in implementation
- **Coordinate System**: Uses layout database units (typically microns)