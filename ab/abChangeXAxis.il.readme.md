# abChangeXAxis.il

## Purpose/Description
Changes the X-axis of a waveform to correspond to Y-values of another waveform, and provides functions for transposing X and Y axes. Includes calculator integration for interactive use.

## Function Signatures
```skill
abChangeXAxis(yVar xVar)
abTransposeXY(var)
abRegChangeXAxis()
abChangeXAxisCB()
```

## Parameters

### abChangeXAxis()
- `yVar` - Waveform whose Y-axis will become the new X-axis
- `xVar` - Waveform whose Y-values will be used as the new X-axis

### abTransposeXY()
- `var` - Waveform to transpose (swap X and Y axes)

## Dependencies
- Data representation functions: `drCreateEmptyWaveform`, `drGetWaveformXVec`, etc.
- Calculator integration functions for registration
- Family support functions: `famIsFamily`, `famMap`

## Return Values
- **abChangeXAxis()**: Returns new waveform with modified X-axis
- **abTransposeXY()**: Returns waveform with swapped X and Y axes
- **abRegChangeXAxis()**: Returns `t` when successfully registered

## Usage Examples
```skill
; Load the functions
load("ab/abChangeXAxis.il")

; Register in calculator (optional)
abRegChangeXAxis()

; Change X-axis using Y-values of second waveform
newWave = abChangeXAxis(yVar xVar)

; Transpose X and Y axes
transposed = abTransposeXY(originalWave)

; Phase noise analysis example (from comments)
pn = phaseNoise(1 "pss_fd" ?result "pnoise")
decade = log10(xval(pn))  ; Convert x-axis to log10 of frequency
pnVsDecade = abChangeXAxis(pn decade)  ; Phase noise vs decade
slope = deriv(pnVsDecade)  ; Slope in dB/decade
freqDec = cross(slope -28)  ; Find corner frequency
freq = 10**freqDec  ; Convert back to frequency
```

## Algorithm Details

### abChangeXAxis()
1. **Simple Case**: If both waveforms share the same X-axis, directly uses Y-values
2. **Interpolation Case**: If X-axes differ, uses `value()` function to interpolate
3. **Family Support**: Handles families using `famMap` for recursive processing

### abTransposeXY()
- Simply swaps the X and Y vectors of the waveform

## Calculator Integration
- `abRegChangeXAxis()`: Registers function as special calculator function
- `abChangeXAxisCB()`: Callback function for calculator interface
- Enables interactive use from Cadence calculator

## Notes/Special Considerations
- **Interpolation**: Automatically handles different X-axis scales through interpolation
- **Family Support**: Works with both individual waveforms and families
- **Phase Noise Analysis**: Particularly useful for analyzing slope changes in phase noise curves
- **Performance**: Optimized for cases where waveforms share same X-axis
- **Error Handling**: Provides clear error messages for unsupported data types
- **Author**: Created by A.D.Beckett from Cadence Design Systems Ltd.
- **Date**: Originally created May 25, 1999, modified May 21, 2002
- **Version**: SCCS version 1.3