# abConvertComponentParams.il

## Purpose/Description
Comprehensive utility for converting component parameters in Cadence designs. Supports individual cell views, entire libraries, and hierarchical designs with configurable conversion rules.

## Function Signatures
```skill
abConvertComponentParams(configFile @optional (cellView (geGetEditCellView)) (check t))
abConvertComponentParamsForLib(libName viewName configFile @optional (check t))
abConvertComponentParamsHier(configFile @key (cellView (geGetEditCellView)) (viewList "schematic cmos.sch symbol") (stopList "symbol") (check t) (visited (makeTable 'visited nil)))
abReadConvertComponentParamsConfig(configFile)
abConvertComponentParamsPropMatch(inst propMatch)
```

## Parameters

### abConvertComponentParams()
- `configFile` - Configuration file path or configuration data structure
- `cellView` - Target cell view (default: current edit cell view)
- `check` - Perform schematic check after conversion (default: t)

### abConvertComponentParamsForLib()
- `libName` - Library name to process
- `viewName` - View name to process (e.g., "schematic")
- `configFile` - Configuration file or data
- `check` - Perform checks after conversion (default: t)

### abConvertComponentParamsHier()
- `configFile` - Configuration file or data
- `cellView` - Starting cell view for hierarchy traversal
- `viewList` - Views to process during traversal
- `stopList` - Views to stop traversal at
- `check` - Perform checks after conversion
- `visited` - Internal table for tracking visited cells

## Configuration File Format
```skill
; Configuration file contains conversion rules:
(
  (nil
   fromLib   "analogLib"        ; Source library (regex)
   fromCell  "nmos4"           ; Source cell (regex)
   fromView  "symbol"          ; Source view (default: "symbol")
   toLib     "newLib"          ; Target library
   toCell    "nmos4_new"       ; Target cell
   toView    "symbol"          ; Target view (default: "symbol")
   propMatch (("subtype" "xyz")) ; Property matching criteria
   matchFunction myMatchFunc    ; Custom matching function
   runCallbacks t              ; Invoke CDF callbacks
   params (                    ; Parameter conversions
     ("w" "width")            ; Simple rename
     ("l" "length" myConvFunc) ; Rename with conversion function
   )
   addProps (                  ; Properties to add
     ("isnoisy" t)
   )
  )
)
```

## Dependencies
- Database functions: `dbOpenCellViewByType`, `dbGetq`, etc.
- Regular expression functions: `rexMatchp`
- CDF callback functions: `abInvokeInstCdfCallbacks`

## Return Values
- **abConvertComponentParams()**: Returns `t` if changes were made, `nil` otherwise
- **abConvertComponentParamsForLib()**: Returns `t`
- **abConvertComponentParamsHier()**: Returns `t`

## Usage Examples
```skill
; Load the utility
load("ab/abConvertComponentParams.il")

; Convert current cell view
abConvertComponentParams("conv.config")

; Convert specific cell view without checking
abConvertComponentParams("conv.config" cellView nil)

; Convert entire library
abConvertComponentParamsForLib("myLib" "schematic" "conv.config")

; Convert design hierarchy
abConvertComponentParamsHier("conv.config")

; Convert hierarchy with custom settings
abConvertComponentParamsHier("conv.config" 
    ?cellView myCellView
    ?viewList "schematic schem2 symbol"
    ?stopList "symbol"
    ?check nil)

; Example conversion function
procedure(fixIt(inst parName val)
    printf("Fixing %s on %s\n" parName inst~>name)
    sprintf(nil "%n" evalstring(val)*2)  ; Double the value
)
```

## Configuration Rules
- **Regular Expressions**: Library, cell, and view names support anchored regex patterns
- **Property Matching**: Optional property-based filtering with regex values
- **Custom Functions**: Support for custom matching and conversion functions
- **Parameter Transformation**: Rename parameters with optional value conversion
- **Property Addition**: Add new properties to converted instances

## Notes/Special Considerations
- **Hierarchical Processing**: Handles complex design hierarchies with cycle detection
- **Pcell Support**: Skips parameterized cells appropriately
- **CDF Integration**: Optional CDF callback invocation after parameter changes
- **Regular Expressions**: Uses anchored patterns ("nmos" becomes "^nmos$")
- **Safety**: Checks for existing visits to prevent infinite loops
- **Flexibility**: Supports both file-based and direct configuration data
- **Error Handling**: Provides clear error messages for invalid configurations
- **Author**: Created by A.D.Beckett from Cadence Design Systems Ltd.
- **Date**: Originally created January 14, 2001, modified May 23, 2005
- **Version**: SCCS version 1.7