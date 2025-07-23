# webCode2.il

## Purpose/Description
PCB layout void analysis tool that examines air gaps between voids and routing keepout areas. Analyzes geometric relationships between shapes on different layers to identify spacing violations or clearance issues.

## Function Signature
```skill
; Main processing loop (no explicit function definition)
; Processes all voids in ETCH/BOTTOM layer shapes
```

## Parameters
Global variables used:
- `AllVoids` - Collection of void objects to analyze
- `minimum_size_shape` - Minimum size threshold for void processing
- `add_value_list` - Expansion values for bounding box checking
- `keepout_layer` - Layer containing routing keepout areas
- `airgap_value` - Minimum required air gap distance
- `writeOutFile` - Output file handle for results

## Dependencies
- Allegro PCB functions: `axlDBAltOrigin`, `axlMXYSub`, `axlMXYAdd`
- Display functions: `axlVisibleDesign`, `axlVisibleLayer`, `axlShell`
- Selection functions: `axlGetSelSet`, `axlSingleSelectBox`, `axlClearSelSet`
- Measurement functions: `axlAirGap`
- Coordinate functions: `xCoord`, `yCoord`

## Algorithm Flow
1. **Void Iteration**: Processes each void in `AllVoids` collection
2. **Bounding Box Analysis**: Extracts void dimensions and coordinates
3. **Size Filtering**: Only processes voids exceeding minimum size threshold
4. **Search Area Definition**: Creates expanded bounding box around void
5. **Layer Visibility**: Sets up display for keepout layer analysis
6. **Object Selection**: Finds all shapes within expanded search area
7. **Air Gap Calculation**: Measures distance between void and found objects
8. **Results Output**: Writes air gap measurements and void coordinates to file

## Coordinate Processing
```skill
; Void bounding box extraction
void_bBox_x1 = xCoord(car(void_bBox))     ; Left edge
void_bBox_y1 = yCoord(car(void_bBox))     ; Bottom edge  
void_bBox_x2 = xCoord(lastelem(void_bBox)) ; Right edge
void_bBox_y2 = yCoord(lastelem(void_bBox)) ; Top edge

; Void size calculation
void_size_x = max(x1,x2) - min(x1,x2)
void_size_y = max(y1,y2) - min(y1,y2)
```

## Output Format
```
; Written to writeOutFile:
air_gap_value void_xy_coordinates
air_gap_value void_xy_coordinates
...
```

## Usage Examples
```skill
; Setup global variables before loading
minimum_size_shape = 5.0  ; Minimum void size (mils)
add_value_list = '(2.0 2.0)  ; Expansion values
keepout_layer = "ROUTE KEEPOUT/BOTTOM"
airgap_value = 3.0  ; Minimum air gap (mils)
writeOutFile = outfile("void_analysis.txt")

; Load and execute the analysis
load("cnskill/webCode2.il")

; Close output file when done
close(writeOutFile)
```

## Analysis Features
- **Size Filtering**: Only analyzes voids meeting minimum size criteria
- **Layer-Specific**: Focuses on ETCH/BOTTOM layer voids
- **Keepout Analysis**: Checks clearance to routing keepout areas
- **Geometric Expansion**: Uses expanded search areas for comprehensive checking
- **Visual Feedback**: Updates display during analysis
- **Comprehensive Coverage**: Analyzes all qualifying voids in design

## Notes/Special Considerations
- **PCB Specific**: Designed for Allegro PCB Editor environment
- **Layer Dependencies**: Requires specific layer naming conventions
- **Performance**: Processes all voids in design - may be time-intensive for large designs
- **Display Management**: Temporarily modifies layer visibility during processing
- **Measurement Accuracy**: Uses precise air gap calculations between geometric objects
- **File Output**: Results suitable for further analysis or DRC reporting
- **Memory Usage**: Processes one void at a time for memory efficiency
- **Commented Code**: Contains commented deletion logic for potential DRC violation fixes