# angleBox.il

## Purpose/Description
Determines the angular quadrant of a point relative to a bounding box center. Provides geometric analysis functions for positioning and orientation calculations in layout design.

## Function Signatures
```skill
angleSectionr(XY @optional (teta acos(-1)/2))
angleBox(XY bBox)
angleBoxg(@optional (inst css()))
centerBox(bBox)
```

## Parameters

### angleSectionr()
- `XY` - Point coordinates as list (x y)
- `teta` - Angular threshold (default: π/2 radians = 90°)

### angleBox()
- `XY` - Point coordinates to analyze
- `bBox` - Bounding box as ((x0 y0) (x1 y1))

### angleBoxg()
- `inst` - Instance object (default: current selected instance)

## Dependencies
- `ibBox` - Instance bounding box function
- `getInstTermPoint` - Terminal position extraction
- Mathematical functions: `atan`, `acos`

## Return Values
- **angleSectionr()**: Integer 0-3 representing quadrant
- **angleBox()**: Integer 0-3 representing quadrant relative to bBox
- **angleBoxg()**: List of (quadrant terminalName coordinates) for all terminals
- **centerBox()**: Center point coordinates (width height)

## Quadrant System
```
\ 2 / 
 \ /  
3 X 1 
 / \  
/ 0 \ 
```
- 0: Bottom (South)
- 1: Right (East)  
- 2: Top (North)
- 3: Left (West)

## Usage Examples
```skill
; Load the functions
load("angleBox.il")

; Analyze point relative to bounding box
bBox = '((0.0 -1.125) (0.5 0.0))
point = '(0.5 -1.125)
quadrant = angleBox(point bBox)
; Result: 0 (bottom/south)

; Get center of bounding box
center = centerBox(bBox)
; Result: (0.5 1.125) ; width and height

; Analyze all terminals of an instance
inst = css()  ; current selected instance
terminalQuadrants = angleBoxg(inst)
; Result: ((0 "S<0>" (0.5 -1.125)) (3 "Q<0>" (0.0 -1.125)) ...)

; Direct angular analysis
relativePoint = '(-0.25 0.5625)
quadrant = angleSectionr(relativePoint)
; Result: 2 (top/north)
```

## Notes/Special Considerations
- **Coordinate System**: Uses Cadence layout coordinate system
- **Angular Calculation**: Uses atan2-like logic for proper quadrant determination
- **Edge Cases**: Handles points on axes appropriately
- **Geometric Logic**: Useful for automatic pin labeling and wire routing
- **Instance Analysis**: `angleBoxg()` provides complete terminal orientation analysis
- **Mathematical Precision**: Uses exact pi calculations with `acos(-1)`
- **Integration**: Often used with `addCell` functions for automatic pin placement