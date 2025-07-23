# bBoxShrink.il

## Purpose/Description
Shrinks or expands a bounding box by a specified coefficient while maintaining the center position. This utility function is useful for creating margins, guards bands, or scaling operations.

## Function Signature
```skill
bBoxShrink(@optional (bBox css()~>bBox) (coef 0.5))
```

## Parameters
- `bBox` - Bounding box to shrink/expand (default: current selected instance bounding box)
- `coef` - Scaling coefficient (default: 0.5)
  - `coef < 1.0`: Shrinks the bounding box
  - `coef > 1.0`: Expands the bounding box
  - `coef = 1.0`: No change

## Dependencies
- `bBoxHeight`, `bBoxWidth` - Dimension calculation functions
- `centerBox` - Center calculation function (implied)

## Return Values
- Returns new bounding box as ((x0' y0') (x1' y1'))
- Center position remains unchanged
- Dimensions scaled by coefficient

## Usage Examples
```skill
; Load the function
load("bBoxShrink.il")

; Shrink current selected instance by 50%
newBBox = bBoxShrink()
; Uses default coefficient 0.5

; Shrink specific bounding box by 10%
bBox = '((-2.619 -2.27) (2.621 2.27))
shrunk = bBoxShrink(bBox 0.9)
; Result: 10% smaller bounding box

; Expand bounding box by 10%
expanded = bBoxShrink(bBox 1.1)
; Result: 10% larger bounding box

; Create guard band (10% shrink)
originalBBox = css()~>bBox
guardBBox = bBoxShrink(originalBBox 0.9)

; Extreme shrinking
tiny = bBoxShrink(bBox 0.1)
; Result: 10% of original size

; Verify center preservation
original = '((-5.0 -3.0) (5.0 3.0))
scaled = bBoxShrink(original 0.8)
; Center remains at (0.0 0.0)
```

## Mathematical Operation
For a bounding box with:
- Center: (cx, cy)
- Width: w, Height: h
- Coefficient: coef

New bounding box:
- x0' = cx - (w/2) × coef
- y0' = cy - (h/2) × coef  
- x1' = cx + (w/2) × coef
- y1' = cy + (h/2) × coef

## Notes/Special Considerations
- **Center Preservation**: Always maintains the center point of the original bounding box
- **Uniform Scaling**: Applies same coefficient to both width and height
- **Negative Values**: Can handle negative coefficients (creates inverted box)
- **Zero Coefficient**: coef=0 creates a point at the center
- **Default Context**: Uses current selected instance if no bBox provided
- **Layout Applications**: Useful for creating exclusion zones, guard bands, or scaled versions
- **Precision**: Maintains floating-point precision of calculations