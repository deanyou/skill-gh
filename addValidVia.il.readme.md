# addValidVia.il

## Purpose/Description
Adds a via definition to the valid via list in the current constraint group. This utility enables new via types for interconnection routing in Virtuoso Layout Suite.

## Function Signature
```skill
addValidVia(@optional (cv nil) (viaDefinition "M1_PO"))
```

## Parameters
- `cv` - Cell view context (optional, defaults to current window cell view)
- `viaDefinition` - Name of the via definition to add (default: "M1_PO")

## Dependencies
- `envGetVal()` - Environment variable access
- `techGetTechFile()` - Technology file access
- `cstFindConstraintGroupIn()` - Constraint group finder
- Virtuoso Layout Suite constraint system

## Return Values
- No explicit return value
- Side effect: Modifies the valid via list in the constraint group

## Usage Examples
```skill
; Load the function
load("addValidVia.il")

; Add M1_PO via to valid list (default)
addValidVia()

; Add specific via definition
addValidVia(nil "M2_M1")

; Add via for specific cell view
cv = dbOpenCellViewByType("myLib" "myCell" "layout")
addValidVia(cv "CUSTOM_VIA")

; Add multiple vias
viaList = '("M1_PO" "M2_M1" "M3_M2" "M4_M3")
foreach(via viaList
    addValidVia(nil via)
)
```

## Notes/Special Considerations
- **Constraint Groups**: Works with the current "wireConstraintGroup" environment setting
- **Default Group**: Uses "virtuosoDefaultSetup" as the default constraint group
- **Via Validation**: Only adds via if not already in the valid list
- **Technology Context**: Requires valid technology file context
- **Routing Integration**: Added vias become available for automatic routing
- **Duplicates**: Safely handles adding vias that already exist in the list
- **Based On**: Inspired by Virtuoso Layout Suite FAQ solutions
- **M1_PO**: Default via connects Metal1 to Polysilicon layers