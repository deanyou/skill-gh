# abConcatWaveforms.il

## Purpose/Description
Concatenates multiple waveforms end-to-end to create a single continuous waveform. Useful for creating composite signals from multiple waveform segments.

## Function Signature
```skill
abConcatWaveforms(wave1 @rest waves)
```

## Parameters
- `wave1` - First waveform to concatenate
- `waves` - Additional waveforms to concatenate (variable number of arguments)

## Dependencies
- Data representation functions: `drIsWaveform`, `drVectorLength`, etc.
- Vector manipulation functions: `drCreateVec`, `drAddElem`, etc.
- Family support functions: `famIsFamily`, `famMap`

## Return Values
- Returns new waveform object containing concatenated data
- For families, returns concatenated family structure

## Usage Examples
```skill
; Load the function
load("ab/abConcatWaveforms.il")

; Concatenate two waveforms
combined = abConcatWaveforms(wave1 wave2)

; Create mirrored signal (flip + original)
mirrored = abConcatWaveforms(flip(sig) sig)

; Concatenate multiple waveforms
complete = abConcatWaveforms(part1 part2 part3 part4)

; Use with pulse sequences
pulseSeq = abConcatWaveforms(pulse1 pulse2 pulse3)

; Concatenate families (multi-dimensional data)
familyResult = abConcatWaveforms(family1 family2)
```

## Algorithm
1. **Length Calculation**: Determines total length of all input waveforms
2. **Vector Creation**: Creates new X and Y vectors with calculated total length
3. **Data Copying**: Iterates through each waveform and copies data elements
4. **Waveform Assembly**: Creates final waveform object from concatenated vectors

## Data Flow
```
wave1: [x1,x2,x3] [y1,y2,y3]
wave2: [x4,x5]    [y4,y5]
wave3: [x6,x7,x8] [y6,y7,y8]
       ↓
result: [x1,x2,x3,x4,x5,x6,x7,x8] [y1,y2,y3,y4,y5,y6,y7,y8]
```

## Notes/Special Considerations
- **No Overlap Checking**: Function does not validate X-axis continuity or overlaps
- **Data Type Preservation**: Uses same data types as first waveform for result
- **Memory Efficiency**: Creates single new waveform rather than modifying originals
- **Family Support**: Automatically handles families using recursive mapping
- **Vector Ordering**: Maintains order of input waveforms in output
- **Performance**: Efficient single-pass concatenation algorithm
- **X-Axis Warning**: Care should be taken if X-axes overlap as no interpolation is performed
- **Author**: Created by A.D.Beckett from Cadence Design Systems Ltd.
- **Date**: Created January 8, 2009
- **Version**: SCCS version 1.1