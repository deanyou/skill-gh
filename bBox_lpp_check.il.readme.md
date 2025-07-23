# bBox_lpp_check.il

## Purpose/Description
Checks if shapes with specific layer/purpose pairs (LPP) exist within a given bounding box region. This function is useful for design rule checking and layout validation.

## Function Signature
```skill
bBox_lpp_check(@optional (lpp '("METAL1" "pin")) (bBox css()~>bBox) (cv css()~>cellView) (debug nil))
```

## Parameters
- `lpp` - Layer/purpose pair to search for (default: '("METAL1" "pin"))
- `bBox` - Bounding box region to check (default: current selected instance)
- `cv` - Cell view to search in (default: current cell view)
- `debug` - Debug mode flag to return additional information (default: nil)

## Dependencies
- `pointInbBox` - Point-in-bounding-box check function

## Return Values
- **Normal mode**: Returns `t` if matching shapes found, `nil` otherwise
- **Debug mode**: Returns list of boolean check results for each shape

## Usage Examples
```skill
; Load the function
load("bBox_lpp_check.il")

; Check for METAL1 pins in current selected area
hasPin = bBox_lpp_check()
if(hasPin 
    printf("METAL1 pin found in selected area\n")
    printf("No METAL1 pin in selected area\n")
)

; Check specific layer/purpose in custom bounding box
bBox = '((-13.685 -4.005) (-13.455 -3.29))
hasMetal2 = bBox_lpp_check('("METAL2" "drawing") bBox)

; Debug mode to see all checks
lpp = '("METAL1" "pin")
bBox = '((-6.325 -4.41) (-6.115 -2.15))
checkResults = bBox_lpp_check(lpp bBox nil t)
printf("Check results: %L\n" checkResults)

; Check all instances in current cell view
foreach(mapcar inst geGetWindowCellView()~>instances
    result = bBox_lpp_check(inst~>lpp inst~>bBox geGetWindowCellView())
    when(result printf("Pin found in instance %s\n" inst~>name))
)

; Validation check (from usage comment)
unless(bBox_lpp_check() 
    printf("No pins here. OK?!\n")
)
```

## Algorithm
1. Filters cell view shapes to rectangles only
2. For each rectangle:
   - Checks if LPP matches the target LPP
   - Checks if shape's bounding box intersects with target bounding box
3. Returns true if any shape meets both criteria

## Notes/Special Considerations
- **Shape Types**: Only checks rectangular shapes (`objType=="rect"`)
- **Intersection Logic**: Uses `pointInbBox` for spatial checking
- **LPP Matching**: Requires exact layer/purpose pair match
- **Precision Issues**: Comments mention potential rounding issues with coordinate comparisons
- **Future Enhancement**: TODO comment suggests checking if center point is included
- **Design Rules**: Useful for verifying pin placement and layer compliance
- **Performance**: Iterates through all shapes in cell view
- **Debugging**: Debug mode provides detailed check results for troubleshooting