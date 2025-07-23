# Functions.il

## Purpose/Description
Provides quick debugging and utility commands for Cadence layout design. Contains helpful one-liners for common layout operations and system commands.

## Function Signature
```skill
; No explicit functions defined - contains command examples and utilities
```

## Parameters
- No formal parameters - contains example commands

## Dependencies
- Cadence layout editor functions
- System shell access

## Return Values
- Prints example commands to console
- No explicit return values

## Usage Examples
```skill
; Load the utility commands
load("Functions.il")

; The script will print useful commands:

; Create a line on text layer
dbCreateLine(geGetWindowCellView() list("text" "drawing1") list(-0.5:-100 100:-100))

; Make text layer valid for editing
leSetLayerValid('(("text" "drawing1")) t)

; Open a terminal window
system("xterm&")

; Print current directory path
cmd = sprintf(nil "echo cd %s" hiGetCurrentWindow()->cellView->fileName||"")
system(cmd)
```

## Notes/Special Considerations
- **Debug Utility**: Primarily for debugging and quick operations
- **Command Examples**: Provides ready-to-use command snippets
- **Text Layer**: Includes commands for working with text/drawing layers
- **System Integration**: Shows how to interact with system shell
- **Current Context**: Demonstrates accessing current cell view information
- **Terminal Access**: Provides method to open system terminal from Cadence
- **Path Information**: Shows how to extract and display current file paths