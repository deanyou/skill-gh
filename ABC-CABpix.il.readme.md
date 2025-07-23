# ABC-CABpix.il

## Purpose/Description
Creates hexagonal pixel arrays in a tricot (knitted) pattern for PICMIC sensor applications. This function generates ABC pixels with modified pin naming scheme compared to ABCpix.il, specifically designed for CAB (Column-Address-Bus) configurations.

## Function Signature
```skill
; Main execution script (no explicit function definition)
; Uses parameters: NX, NY, pitch, library settings
```

## Parameters
- `NX` - Number of pixels in X direction (horizontal)
- `NY` - Number of pixels in Y direction (vertical) 
- `pitch` - Spacing between hexagonal pixels (default: 5)
- `lib` - Target library name (default: "picmic0_ebecheto")
- `minTOP` - Minimum TOP layer spacing (default: 0.46)
- `pw` - Wire width for interconnecting layers (default: 1)

## Dependencies
Required functions loaded via `ineed()`:
- `CreateVias` - Creates via stacks between metal layers
- `createHexagon` - Generates hexagonal shapes
- `bBoxShrink` - Shrinks bounding boxes
- `textDisplay2label` - Converts text displays to labels
- `createPinLPP` - Creates pins on specific layer/purpose pairs

## Return Values
- Creates a new cell view with hexagonal pixel array
- Opens the created cell view in layout editor
- Generates pins with ABC naming pattern

## Usage Examples
```skill
; Load and execute the script
load("ABC-CABpix.il")

; The script will create a cell named "hexTricot_NX-NY" 
; where NX and NY are the configured dimensions
```

## Notes/Special Considerations
- **Pixel Configuration**: Creates 2 Mega-pixel arrays (approximately 2,077,200 pixels)
- **Metal Layers**: Uses M3, M4, M5 with corresponding vias M4_M3_S, M5_M4_S, ML_M5_S
- **Pin Naming**: 
  - A pins: `A_<col*2+pair>`
  - B pins: `B_<col-row>`  
  - C pins: `C_<col+row>` (differs from ABCpix.il)
- **Hexagonal Layout**: Uses tricot pattern with specific geometric calculations
- **Technology**: Designed for PICMIC sensor technology with specific design rules
- **Critical Difference**: Pin C formula includes `pair` parameter unlike ABCpix.il