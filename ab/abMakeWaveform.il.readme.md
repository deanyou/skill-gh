# abMakeWaveform.il

## Purpose/Description
Creates waveforms for test and analysis purposes from function expressions or data lists. Supports both mathematical functions and explicit data points with flexible data type options.

## Function Signatures
```skill
abMakeWaveform(func xvalues @optional (yDataType 'double) xDataType)
abMakeWaveform((yvalues list) xvalues @optional (yDataType 'double) xDataType)
```

## Parameters
- `func` - Function object or symbol representing a mathematical function
- `yvalues` - List of y-values (when using list method)
- `xvalues` - List of x-axis values or range specification
- `yDataType` - Data type for y-axis ('double, 'single, etc.) (default: 'double)
- `xDataType` - Data type for x-axis (default: same as yDataType)

## Dependencies
- `drCreateEmptyWaveform()` - Waveform creation function
- `drCreateVec()` - Vector creation function
- `drPutWaveformXVec()`, `drPutWaveformYVec()` - Waveform data functions
- `linRg()` - Linear range generation function

## Return Values
- Returns waveform object that can be plotted or analyzed
- Compatible with OCEAN plotting functions

## Usage Examples
```skill
; Load the functions
load("ab/abMakeWaveform.il")

; Simple cosine waveform
wave1 = abMakeWaveform('cos linRg(1 100 1))
; Creates cosine waveform from x=1 to x=100

; Complex mathematical expression
wave2 = abMakeWaveform(lambda((x) x*sin(x)) linRg(-40 40 0.1))
; Creates x*sin(x) from -40 to 40 with 0.1 step

; From explicit data lists
yData = '(5 6 7)
xData = '(1 2 3)
wave3 = abMakeWaveform(yData xData)

; Custom data types
wave4 = abMakeWaveform('(1 -2 4) '("NOM" "SLOW" "FAST") 'double 'string)
; Bar graph with string labels

; Plot the waveform (in OCEAN)
plot(wave1)
```

## Method Specialization
The function uses SKILL's generic method system:

### Generic Method
- Takes function and applies it to each x-value
- Supports any mathematical function or lambda expression

### List Method  
- Takes explicit y-values and x-values
- Requires lists of equal length
- Validates list lengths before processing

## Notes/Special Considerations
- **Generic Functions**: Uses `defgeneric` for polymorphic behavior
- **Method Dispatch**: Automatically selects appropriate method based on first argument type
- **Data Types**: Supports various numeric types ('double, 'single) and string labels
- **OCEAN Integration**: Waveforms can be used directly with OCEAN plotting
- **Lambda Support**: Accepts lambda expressions for mathematical functions
- **String X-Axis**: Supports string x-axis for categorical data (bar graphs)
- **Author**: Created by A.D.Beckett from Cadence Design Systems Ltd.
- **Date**: Originally created July 14, 1999, modified December 10, 2007
- **Version**: SCCS version 1.4