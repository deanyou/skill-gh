# areaBox.il

## Purpose/Description
Calculates the area of a bounding box and provides utilities for fixing zero-width/height bounding boxes. Useful for geometric calculations and layout validation.

## Function Signatures
```skill
areaBox(bBox)
fixZeroBox(bBox @optional (step 0.25) (grid nil))
```

## Parameters

### areaBox()
- `bBox` - Bounding box as ((x0 y0) (x1 y1))

### fixZeroBox()
- `bBox` - Bounding box that may have zero width or height
- `step` - Step size for expansion (default: 0.25)
- `grid` - Grid size for alignment (default: 0.0625)

## Dependencies
- `xCoord()`, `yCoord()` - Coordinate extraction functions
- `lowerLeft()`, `upperRight()` - Bounding box utilities

## Return Values
- **areaBox()**: Returns area as floating point number (width × height)
- **fixZeroBox()**: Returns corrected bounding box with non-zero dimensions

## Usage Examples
```skill
; Load the functions
load("areaBox.il")

; Calculate area of bounding box
bBox = '((0.0 0.0) (5.0 3.0))
area = areaBox(bBox)
; Result: 15.0

; Fix zero-width bounding box
zeroBBox = '((-0.5625 -0.875) (-0.5625 0.0))
fixedBBox = fixZeroBox(zeroBBox)
; Result: ((-0.5625 -0.875) (-0.625 0.0))

; Fix with custom step and grid
fixedBBox = fixZeroBox(zeroBBox 0.5 0.125)
; Grid-aligned expansion

; Area calculation for layout objects
inst = css()  ; current selected instance
area = areaBox(inst~>bBox)
printf("Instance area: %g square units\n" area)
```

## Notes/Special Considerations
- **Area Calculation**: Simple multiplication of width × height
- **Zero Dimension Handling**: `fixZeroBox` addresses zero-width or zero-height boxes
- **Grid Alignment**: Uses schematic snap spacing (0.0625) for proper alignment
- **Step Expansion**: Adds `step` value to zero dimension and rounds to grid
- **Coordinate System**: Works with Cadence coordinate system
- **Layout Validation**: Useful for checking degenerate bounding boxes
- **Alternative Implementation**: Comments show previous ratio-based approach
- **Precision**: Uses exact coordinate calculations