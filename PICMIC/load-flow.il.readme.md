# load-flow.il

## Purpose/Description
Main workflow orchestration script for PICMIC sensor design generation. Coordinates the execution of multiple specialized scripts to create complete sensor layouts, schematics, and analysis files.

## Function Signature
```skill
; Main execution script (no explicit function definition)
; Loads and executes multiple specialized PICMIC generation scripts
```

## Parameters
- Uses global variables and file paths for configuration
- `imadPositionFile` - Path to color/position data file
- `hexsCellName` - Name of hexagonal cell patterns to use

## Dependencies
Multiple specialized PICMIC scripts:
- `ABC_pexRect.il` - Hexagonal tricot rectangle generation
- `copyFlaten.il` - Cell flattening and merging
- `ROnb_xy.il` - Position to strip number mapping
- `imad_rand_vias9.il` - Random via generation and tetris patterns
- `imad_rand_plus_dummy.il` - Dummy cell generation
- `TOP_full.il` - Complete sensor area generation
- `countROcells.il` - Cell counting and analysis
- And many others for complete sensor design

## Workflow Sequence
1. **Initialization**: Load color position file (`~/testColorSpread.txt`)
2. **Base Patterns**: Generate hexagonal tricot patterns if needed
3. **Position Mapping**: Create RO number to position mapping tables
4. **Via Generation**: Create random via patterns and tetris structures
5. **Dummy Addition**: Add dummy cells to complete patterns
6. **Top-Level Assembly**: Generate complete sensor layouts
7. **Analysis**: Count cells and generate statistics
8. **Netlist Generation**: Create netlists and connection files
9. **Pin Generation**: Add pins and create schematics
10. **Final Assembly**: Create complete design hierarchy

## Key Generated Files
- `ROnb_xy.txt` - Position to strip number mapping
- `discri_0-6911.csv` - Discriminator netlist for Yue
- `YTAB_RO_YRB.csv` - Y-table for RO analysis
- `CTAB_RO_YRB.csv` - C-table for RO analysis
- `RO_X_Ys.csv` - RO position coordinates

## Global Variables
```skill
imadPositionFile = "~/testColorSpread.txt"  ; Color position data
hexsCellName = "hexTricotTJ_15_10_flat"     ; Base hexagon pattern
```

## Usage Examples
```skill
; Load and execute the complete PICMIC flow
load("PICMIC/load-flow.il")

; The script automatically executes upon loading
; No function calls needed - runs complete workflow

; To reload specific components manually:
; load("PICMIC/ABC_pexRect.il")
; load("PICMIC/ROnb_xy.il")
; load("PICMIC/imad_rand_vias9.il")
```

## Script Components

### Core Generation
- **ABC_pexRect.il**: Base hexagonal pixel generation
- **copyFlaten.il**: Cell merging and flattening
- **pavement.il**: Pattern tiling operations

### Analysis and Mapping
- **ROnb_xy.il**: Position coordinate mapping
- **countROcells.il**: Statistical cell counting
- **countRandomVias.il**: Via distribution analysis

### Assembly
- **TOP_full.il**: Complete sensor area assembly
- **TOP_4chip.il**: Multi-chip configurations
- **netlistGenerate.il**: Netlist generation

### Pin and Connection
- **tetris_dum_pins.il**: Pin generation for dummy cells
- **tetris_dum_schematic.il**: Schematic generation
- **rail_SW_sch.il**: Power rail schematics

## Notes/Special Considerations
- **Sequential Execution**: Scripts must run in specific order due to dependencies
- **File Dependencies**: Relies on external data files for position and color information
- **Memory Intensive**: Generates large layouts requiring substantial memory
- **Technology Specific**: Designed for PICMIC sensor technology
- **Manual Intervention**: Some steps require manual verification or adjustment
- **Comment Blocks**: Contains extensive commented sections for optional/manual steps
- **Workflow Management**: Coordinates complex multi-step design generation
- **Data Export**: Generates multiple output files for analysis and fabrication