# bBoxHeight.il

## Purpose/Description
Calculates the height of a bounding box. This simple utility function extracts the vertical dimension from a bounding box structure.

## Function Signature
```skill
bBoxHeight(bBox)
```

## Parameters
- `bBox` - Bounding box as ((x0 y0) (x1 y1))

## Dependencies
- None (uses basic SKILL list operations)

## Return Values
- Returns the height as a floating-point number (y1 - y0)

## Usage Examples
```skill
; Load the function
load("bBoxHeight.il")

; Calculate height of bounding box
bBox = '((0.0 -2.5) (5.0 2.5))
height = bBoxHeight(bBox)
; Result: 5.0

; Get height of layout instance
inst = css()  ; current selected instance
height = bBoxHeight(inst~>bBox)
printf("Instance height: %g units\n" height)

; Use with various bounding boxes
cellBBox = cv~>bBox
cellHeight = bBoxHeight(cellBBox)

; Check if bounding box has zero height
if(bBoxHeight(someBBox) == 0.0
    printf("Warning: Zero height bounding box detected\n")
)
```

## Notes/Special Considerations
- **Simple Calculation**: Direct subtraction of y-coordinates (y1 - y0)
- **Sign Handling**: Works correctly regardless of bounding box orientation
- **Precision**: Returns exact floating-point difference
- **Common Usage**: Often paired with `bBoxWidth` for area calculations
- **Layout Integration**: Works with any Cadence bounding box format
- **Coordinate System**: Uses standard Cadence coordinate system
- **Performance**: Minimal overhead, direct coordinate access