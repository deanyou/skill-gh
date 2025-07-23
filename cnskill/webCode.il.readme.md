# webCode.il

## Purpose/Description
Interactive component selection and programmable part addition utility for Concept HDL. Provides mouse-based component selection with automatic programmable part number assignment through a client-server architecture.

## Function Signatures
```skill
PrintMessages(msginfo msgtype)
DistanceSquared(point1 point2)
NearestComp(importHandle xy)
NearestPin(importHandle compPins xy)
NearestCompPin(importHandle xy)
addprogpart(event obj)
PrintPickedPin(EvObject HandleSymbol)
addprog()
csWaitForCnHandle(sleepHandle exitHandler)
addprogCallback(event usrArg)
ConceptExitHandler(handle)
cnCommands_addprogServer()
```

## Parameters

### PrintMessages()
- `msginfo` - Message information object
- `msgtype` - Type of messages to filter and print

### DistanceSquared()
- `point1`, `point2` - Two points to calculate distance between

### NearestComp()
- `importHandle` - Concept import handle
- `xy` - Mouse coordinates

### addprogpart()
- `event` - Event object containing user input
- `obj` - Object context (unused)

## Dependencies
- Concept HDL integration functions (`cn*` functions)
- Mouse and user input handling
- MPS (Message Passing System) functions
- String manipulation and formatting functions

## Return Values
- **DistanceSquared()**: Returns squared distance between points
- **NearestComp()**: Returns nearest component object
- **NearestCompPin()**: Returns list of (component, pin) pair
- **addprog()**: Initiates interactive component selection

## Usage Examples
```skill
; Load the server
load("cnskill/webCode.il")

; The server automatically starts and exports "addprogServer"
; User can then interact through Concept HDL interface

; Interactive usage:
; 1. User picks a component (calls addprog())
; 2. System finds nearest component and pin
; 3. User enters programmable part value
; 4. System creates property with the value

; Server functions are automatically registered
; No direct function calls needed for end users
```

## Client-Server Architecture
```
Concept HDL Client ←→ SKILL Server (addprogServer)
                   ↓
              Mouse Events
                   ↓
            Component Selection
                   ↓
           Property Creation
```

## Event Flow
1. **Component Selection**: User clicks on component
2. **Nearest Detection**: System finds closest component and pin
3. **Input Request**: Prompts user for programmable part number
4. **Property Creation**: Creates PROG_PART property with user value
5. **Visual Feedback**: Property displayed in yellow at component origin

## Property Creation
```skill
; Creates property template:
cnCreatePropTemplate(
    ?name "PROG_PART"
    ?value userInput
    ?color "YELLOW"
    ?attachXY componentOrigin
    ?visibility 1
    ?justification 0
    ?size 50
    ?angle 0
)
```

## Server Configuration
- **Service Name**: "addprogServer"
- **Version**: "1.0"
- **Session**: Uses default Concept session
- **Timeout**: 1200 seconds (20 minutes)
- **Exit Handler**: Automatic cleanup on termination

## Notes/Special Considerations
- **Interactive Design**: Requires user interaction through Concept HDL interface
- **Mouse Integration**: Uses precise mouse coordinate detection
- **Error Handling**: Includes timeout and connection error handling
- **Property Management**: Creates persistent component properties
- **Platform Specific**: Windows compatibility check included
- **Memory Management**: Proper handle cleanup and resource management
- **Real-time Response**: Immediate visual feedback for user actions
- **Concept Integration**: Deep integration with Concept HDL design environment