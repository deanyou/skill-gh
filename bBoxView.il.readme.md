# bBoxView.il

## Purpose/Description
Provides a comprehensive view of bounding box properties including height, width, area, and center coordinates. This utility function displays key geometric information in a user-friendly format.

## Function Signature
```skill
bBoxView(@optional (bBox css()~>bBox))
```

## Parameters
- `bBox` - Bounding box to analyze (default: current selected instance bounding box)

## Dependencies
- `centerBox()` - Center calculation function

## Return Values
Returns a list containing:
1. Height (floating point)
2. Width (floating point)  
3. Area formatted as string in mm² with "µ" suffix
4. Center coordinates as list (cx cy)

## Usage Examples
```skill
; Load the function
load("bBoxView.il")

; Analyze current selected instance
info = bBoxView()
; Result: (4.54 5.24 "23.79[mm**2]" (0.001 0.0))

; Analyze specific bounding box
bBox = '((-2.5 -1.0) (2.5 4.0))
info = bBoxView(bBox)
; Result: (5.0 5.0 "25.00[mm**2]" (0.0 1.5))

; Extract individual components
height = car(info)     ; 5.0
width = cadr(info)     ; 5.0  
area = caddr(info)     ; "25.00[mm**2]"
center = cadddr(info)  ; (0.0 1.5)

; Display information
printf("Dimensions: %g × %g\n" width height)
printf("Area: %s\n" area)
printf("Center: (%g, %g)\n" car(center) cadr(center))
```

## Output Format
```skill
; Return format: (height width area_string center_coordinates)
(4.54 5.24 "23.79[mm**2]" (0.001 0.0))
```

## Notes/Special Considerations
- **Area Units**: Area is calculated in square layout units then formatted with "µ" multiplier notation
- **Precision**: Area displayed with 2 decimal places
- **Center Calculation**: Uses `centerBox()` function for center coordinates
- **Current Context**: Defaults to current selected instance if no bBox provided
- **Format**: Provides both raw numbers and formatted strings
- **Unit Suffix**: Uses "[mm**2]" notation for area (assumes micron units)
- **Comprehensive**: Single function call provides all key bounding box metrics