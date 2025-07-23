# boundaries.il

## Purpose/Description
Aligns selected instances based on their prBoundary (process boundary) definitions. This function sorts instances by their boundary positions and moves them to align properly in layout designs.

## Function Signature
```skill
prBoundaryAlign(@optional (insts nil))
```

## Parameters
- `insts` - List of instances to align (default: current selected set)

## Dependencies
- `bBoxWidth`, `bBoxHeight` - Dimension calculation functions
- `prBoundInstList2Move` - Function to move instances based on boundaries

## Return Values
- No explicit return value
- Side effect: Moves instances to aligned positions

## Usage Examples
```skill
; Load the function
load("boundaries.il")

; Align currently selected instances
prBoundaryAlign()

; Align specific list of instances
instances = geGetWindowCellView()~>instances
prBoundaryAlign(instances)

; Select instances and align
; (manually select instances in layout)
geGetSelectedSet()  ; verify selection
prBoundaryAlign()   ; align selected instances
```

## Algorithm
1. **Extract Boundaries**: For each instance:
   - Gets instance position and transformation
   - Extracts prBoundary bounding box from master
   - Transforms boundary to global coordinates

2. **Sort Instances**: 
   - Creates sort list with position coordinates
   - Sorts by X-coordinate (or Y-coordinate based on HV flag)
   - Uses `lessp` for ascending order

3. **Move Instances**: 
   - Calls `prBoundInstList2Move` with sorted list
   - Aligns instances based on boundary positions

## Data Structures
```skill
; prBs format: list of (transformedBoundary instanceObject)
; list2sort format: list of (sortKey (boundary instance))
; sorted format: sorted list by position coordinate
```

## Notes/Special Considerations
- **Process Boundaries**: Uses `prBoundary` rather than regular bounding box
- **Transformation Handling**: Properly handles instance transformations and mosaic arrays
- **Parent Relationships**: Warning about instances with parent properties - moving one may move others
- **Precision Issues**: TODO note about potential precision limitations (only 1 digit after decimal)
- **Coordinate System**: HV flag determines sort direction (X vs Y alignment)
- **Cadence Integration**: Addresses issues where standard Cadence Align function may not work properly
- **Safety Check**: Should verify no parent relationships exist in selection before alignment
- **Sort Direction**: Currently hardcoded to sort by X-coordinate (HV=t)