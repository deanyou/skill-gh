# abDumpWaveform.il

## Purpose/Description
Comprehensive waveform export utilities supporting multiple output formats including ASCII, sampled data, multi-variable files, and PSF (Parametric Simulation Format) files.

## Function Signatures
```skill
abDumpWaveform(wave fileName @optional (format "%g %g\n"))
abDumpWaveformSplit(wave fileName @optional (format "%g %g\n") (split 2**31-512))
abDumpFamily(family fileNamePrefix @optional (format "%g %g\n"))
abDumpWaveforms(fileName @key (format "%g") (separator " ") @rest waves)
abDumpSampledWaveform(wave samplePoints fileName @optional (format "%g %g\n"))
abDumpWaveformsToAsciiPSF(fileName @rest waves)
abDumpWaveformsToBinPSF(rawdir @rest waves)
```

## Parameters

### abDumpWaveform()
- `wave` - Waveform object to export
- `fileName` - Output file name
- `format` - Printf format string (default: "%g %g\n")

### abDumpWaveformSplit()
- `split` - File size limit in bytes (default: 2GB-512 bytes)

### abDumpSampledWaveform()
- `samplePoints` - List of X-values to sample at

### abDumpWaveforms()
- `format` - Format for each value (default: "%g")
- `separator` - Column separator (default: " ")
- `waves` - Multiple waveforms with same X-axis

## Dependencies
- File I/O functions: `outfile`, `fprintf`, `close`
- Waveform functions: `drGetWaveformXVec`, `drGetWaveformYVec`
- System functions for PSF conversion

## Return Values
- Most functions return `nil` (side effect functions)
- File output is the primary result

## Usage Examples
```skill
; Load the utilities
load("ab/abDumpWaveform.il")

; Basic waveform dump
abDumpWaveform(VT("/c") "data_c.out")

; Exponential format
abDumpWaveform(VT("/c") "data_c.out" "%e %e\n")

; Split large files
abDumpWaveformSplit(VT("/large_signal") "big_data.out")

; Sampled output with custom points
samplePts = linRg(0.01 0.05 0.005)
abDumpSampledWaveform(VT("/c") samplePts "sampled_c.out")

; Multi-variable output
abDumpWaveforms("data.out" VT("/c") VT("/z") VT("/a"))

; CSV format with custom separator
abDumpWaveforms("data.csv" VT("/c") VT("/z") VT("/a") 
    ?format "%-10g" ?separator ",")

; Export family to multiple files
abDumpFamily(VT("/family_signal") "family_data")

; Generate PSF files
abDumpWaveformsToBinPSF("rawdir" VT("/c") VT("/z"))
```

## Output Formats

### ASCII Text
```
# Standard format (X Y pairs)
1.0e-12 0.0
2.0e-12 0.5
3.0e-12 1.0
```

### Multi-Variable
```
# Time-based with multiple signals
1.0e-12 0.0 0.5 1.0
2.0e-12 0.1 0.6 1.1
3.0e-12 0.2 0.7 1.2
```

### PSF Binary
- Creates raw directory with PSF files
- Compatible with Cadence simulation tools
- Includes proper headers and metadata

## File Management
- **Split Files**: Automatically splits large files to avoid 2GB limit
- **Family Export**: Creates separate files for each family member
- **Directory Creation**: Automatically creates directories for PSF output
- **Naming**: Sanitizes file names for family exports

## Notes/Special Considerations
- **Performance**: Optimized for large waveforms with efficient memory usage
- **Format Flexibility**: Supports custom printf format strings
- **PSF Support**: Full PSF ASCII and binary format support
- **Family Handling**: Automatically processes waveform families
- **Size Limits**: Handles file size limitations with automatic splitting
- **Interpolation**: Uses `value()` function for sampling at arbitrary points
- **Multi-Variable**: Requires same X-axis for all waveforms (no interpolation)
- **Author**: Created by A.D.Beckett from Cadence Design Systems Ltd.
- **Date**: Originally created October 23, 1997, modified January 31, 2005
- **Version**: SCCS version 1.6