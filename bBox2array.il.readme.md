# bBox2array.il

## Purpose/Description
Converts a bounding box into an array of four corner points. This utility function transforms the compact bounding box representation into explicit corner coordinates for polygon creation or geometric operations.

## Function Signature
```skill
bBox2array(@optional (bBox list(0:0 1:1)))
```

## Parameters
- `bBox` - Bounding box as ((x0 y0) (x1 y1)) (default: ((0 0) (1 1)))

## Dependencies
- Basic SKILL list operations

## Return Values
- Returns list of four corner points in counterclockwise order:
  - Bottom-left: (x0 y0)
  - Top-left: (x0 y1)  
  - Top-right: (x1 y1)
  - Bottom-right: (x1 y0)

## Usage Examples
```skill
; Load the function
load("bBox2array.il")

; Convert default bounding box
corners = bBox2array()
; Result: ((0 0) (0 1) (1 1) (1 0))

; Convert custom bounding box
bBox = '((-5.0 -3.0) (5.0 3.0))
corners = bBox2array(bBox)  
; Result: ((-5.0 -3.0) (-5.0 3.0) (5.0 3.0) (5.0 -3.0))

; Use with layout objects
inst = css()  ; current selected instance
corners = bBox2array(inst~>bBox)

; Create polygon from bounding box
bBox = list(0:140-58.24 50:58.24)
pts = bBox2array(bBox)
; Result: ((0 81.76) (0 58.24) (50 58.24) (50 81.76))

; Use for shape creation
rodCreatePolygon(cv layer pts)
```

## Notes/Special Considerations
- **Point Order**: Returns points in counterclockwise order starting from bottom-left
- **Coordinate Extraction**: Uses standard bounding box format ((x0 y0) (x1 y1))
- **Polygon Creation**: Output format suitable for polygon/shape creation functions
- **Layout Integration**: Works directly with Cadence bounding box objects
- **Simple Utility**: Straightforward coordinate transformation
- **Memory Efficient**: Creates new list without modifying input
- **Standard Format**: Compatible with other geometric functions in the toolkit