# MPP.il

## Purpose/Description
Defines Multiple Path Patterns (MPP) templates for advanced layout routing in Cadence. Creates sophisticated routing structures with master paths, offset subpaths, enclosure subpaths, and subrectangles for complex interconnect designs.

## Function Signature
```skill
; Main execution script that defines multiple MPP templates
; Uses leDefineMPPTemplate() function calls
```

## Parameters
Each MPP template uses various parameters including:
- `?techId` - Technology file reference
- `?name` - Template name identifier
- `?layer` - Primary layer definition
- `?width` - Path width
- `?choppable` - Whether path can be chopped
- `?endType` - End termination style ("flush", "truncate")
- `?justification` - Alignment ("center", "left", "right")
- `?offset` - Position offset
- `?offsetSubPath` - List of offset parallel paths
- `?encSubPath` - List of enclosure paths
- `?subRect` - List of subrectangles

## Dependencies
- Technology file access functions
- `leDefineMPPTemplate()` - Cadence layout editor function
- Current cell view for technology context

## Return Values
- Defines multiple MPP templates in the technology
- Templates become available for layout routing

## Usage Examples
```skill
; Load and execute to define all templates
load("MPP.il")

; Templates defined include:
; - "template1": Basic MPP with MET1 master path
; - "Template2": Complex MPP with multiple layers
; - "gnd3strip": Ground strip with 3 metal layers
; - "gndM1", "gndM2": Ground patterns for specific metals
; - "diff_cont": Diffusion contact pattern
; - "viaP1C": Poly1 to contact via
; - And many more specialized patterns
```

## Defined Templates

### Basic Templates
- **template1**: Simple MET1 path with pin access
- **Template2**: Complex multi-layer with NPLUS, DIFF, MET4

### Ground/Power Templates  
- **gnd3strip**: 3-strip ground pattern for MET3
- **gnd2strip**: 2-strip ground pattern for MET3
- **gndM1**, **gndM2**: Metal-specific ground patterns
- **gndM2_3R**: 3-row MET2 ground pattern

### Via Templates
- **viaP1C**: Poly1 to contact via stack
- **stack_P1C_VIA1**: Combined poly contact and VIA1
- **mpp_VIA1**: Simple VIA1 pattern

### Specialized Templates
- **diff_cont**: Diffusion contact with MET1 enclosure
- **pdiff_subCont**: P-diffusion with substrate contacts
- **M4_Wide**: Wide MET4 patterns
- **M4_7R**: 7-row MET4 structure

## Notes/Special Considerations
- **Technology Dependent**: Requires valid technology file context
- **Layer Definitions**: Uses technology-specific layer names (MET1, MET2, DIFF, etc.)
- **Complex Routing**: Enables sophisticated multi-layer routing patterns
- **Manufacturing Rules**: Templates encode design rule compliance
- **Reusable**: Templates can be applied to multiple routing instances
- **Performance**: Pre-defined templates improve routing consistency
- **Documentation**: Each template includes detailed parameter specifications