# bBoxWidth.il

## Purpose/Description
Calculates the width of a bounding box. This simple utility function extracts the horizontal dimension from a bounding box structure.

## Function Signature
```skill
bBoxWidth(bBox)
```

## Parameters
- `bBox` - Bounding box as ((x0 y0) (x1 y1))

## Dependencies
- None (uses basic SKILL list operations)

## Return Values
- Returns the width as a floating-point number (x1 - x0)

## Usage Examples
```skill
; Load the function
load("bBoxWidth.il")

; Calculate width of bounding box
bBox = '((-2.5 0.0) (2.5 5.0))
width = bBoxWidth(bBox)
; Result: 5.0

; Get width of layout instance
inst = css()  ; current selected instance
width = bBoxWidth(inst~>bBox)
printf("Instance width: %g units\n" width)

; Use with current selected instance (from comments)
bBox = css()~>bBox  ; e.g., ((-2.619 -2.27) (2.621 2.27))
width = bBoxWidth(bBox)  ; Result: 5.24

; Check if bounding box has zero width
if(bBoxWidth(someBBox) == 0.0
    printf("Warning: Zero width bounding box detected\n")
)

; Combined with other dimension functions
height = bBoxHeight(bBox)
area = bBoxWidth(bBox) * height
```

## Notes/Special Considerations
- **Simple Calculation**: Direct subtraction of x-coordinates (x1 - x0)
- **Sign Handling**: Works correctly regardless of bounding box orientation
- **Precision**: Returns exact floating-point difference
- **Common Usage**: Often paired with `bBoxHeight` for area calculations
- **Layout Integration**: Works with any Cadence bounding box format
- **Example Values**: Comments show real usage with coordinate values
- **Performance**: Minimal overhead, direct coordinate access
- **Coordinate System**: Uses standard Cadence coordinate system