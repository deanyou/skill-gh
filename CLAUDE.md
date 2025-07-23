# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a SKILL function library for Cadence EDA tools. SKILL is Cadence's proprietary Lisp-like scripting language used for integrated circuit design automation. The library contains 100+ individual functions for schematic, layout, and design automation tasks.

## Architecture

### Core Design Patterns

**One Function Per File**: Each `.il` file typically contains a single main function with the same name as the file. This follows the `ineed` dependency loading pattern.

**Dependency Loading System**: Functions are loaded using:
```lisp
ineed('(functionName1 functionName2))  ; Load multiple functions
load("filename.il")                    ; Load single file
```

**Optional Parameters**: Extensive use of `@optional` parameters for function flexibility:
```lisp
defun(functionName(param1 @optional param2 param3)
  ; function body
)
```

### Directory Structure

- **Root (/)**: 100+ individual SKILL function files (.il)
- **ab/**: Additional SKILL functions and utilities  
- **PICMIC/**: Technology-specific functions
- **cnskill/**: Web-related SKILL utilities
- **example/**: Documentation with visual examples

### Key Infrastructure Files

- **menu.il**: Main menu system and entry point for Cadence integration
- **ineed.il**: Dependency loading system
- **Functions.il**: Core utility functions
- **emacs_ipcPipe.il**: Emacs-Cadence communication via named pipes
- **skillMode.el**: Emacs major mode for SKILL editing

## Development Setup

### Environment Setup
```bash
export SKILLDIR=$HOME/Skill
```

### Emacs Integration
1. Copy `skillMode.el` to `~/.emacs.d/`
2. Add to `~/.emacs`: `load("~/.emacs.d/skillMode.el")`
3. Add to `~/.cdsinit_personal`: `loadi(strcat(getShellEnvVar("SKILLDIR") "/menu.il"))`

### Function Categories

**Schematic Operations**: `schematic2symbol.il`, `array2sch.il`, `addCell.il`
**Layout Operations**: `generateAllPins.il`, `genBox.il`, `createPinLPP.il` 
**Development Tools**: `freeLCK.il`, `prettyPrint.il`, `whereIncludeCell.il`
**Geometry Utilities**: Bounding box manipulation, coordinate transformations

## Code Conventions

### File Headers
All files start with: `;; copyleft ebecheto`

### Naming Conventions
- Function files use descriptive names matching the function name
- Prefixes indicate functionality:
  - `ab*`: Analog/simulation related
  - `sch*`: Schematic-related  
  - `gen*`: Generation/creation functions

### Common SKILL Patterns
- **Let-binding**: `let((var1 val1) (var2 val2)) body)`
- **Conditional execution**: `when`, `unless`, `cond`
- **Error handling**: Basic checking with user feedback via `printf`
- **List operations**: Extensive use of `foreach`, `mapcar`, `append`

### Testing and Validation
- No formal test suite
- Functions tested through manual execution in Cadence environment
- Use `example/` directory files for testing complex workflows

## Key Integration Points

### Emacs-Cadence Communication
The `emacs_ipcPipe.il` and `skillMode.el` provide real-time bidirectional communication between Emacs and Virtuoso through named pipes at `/tmp/emacs_to_skill_pipe`.

### Menu System
Functions are integrated into Cadence through the custom menu system in `menu.il`, providing GUI access to library functions.

## Development Notes

- Functions should follow the optional parameter pattern for backward compatibility
- Use descriptive variable names and add comments for complex algorithms
- Maintain the one-function-per-file convention for modularity
- Test functions in actual Cadence environment before committing
- Document complex functions with examples in the `example/` directory