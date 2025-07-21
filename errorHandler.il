;; copyleft ebecheto
;; errorHandler.il - Standardized error handling for SKILL functions
;; Provides consistent error reporting, logging, and recovery mechanisms

; Global error configuration
global(skillErrorConfig)
skillErrorConfig = list(
  'logToFile t
  'logFile "/tmp/skill_errors.log"  
  'showTimestamp t
  'colorOutput t
  'verboseMode nil
)

; Main error handler function
defun(skillError(message @optional (level "ERROR") (context nil) (recovery nil))
  let((timestamp colorCode resetCode logMsg))
    
    ; Generate timestamp if enabled
    timestamp = when(getf(skillErrorConfig 'showTimestamp)
      sprintf(nil "[%s] " getCurrentTime("iso"))
    )
    
    ; Set color codes for terminal output
    when(getf(skillErrorConfig 'colorOutput)
      case(level
        ("ERROR"   colorCode = "\033[31m" resetCode = "\033[0m") ; Red
        ("WARNING" colorCode = "\033[33m" resetCode = "\033[0m") ; Yellow  
        ("INFO"    colorCode = "\033[36m" resetCode = "\033[0m") ; Cyan
        ("DEBUG"   colorCode = "\033[37m" resetCode = "\033[0m") ; White
        (t         colorCode = "" resetCode = "")
      )
    )
    
    ; Format the message
    logMsg = sprintf(nil "%s%s%s: %s%s%s" 
      colorCode or(timestamp "") level 
      message resetCode
      if(context sprintf(nil " [Context: %s]" context) "")
    )
    
    ; Output the message
    case(level
      ("ERROR"
        printf("❌ %s\n" logMsg)
        when(recovery printf("💡 Recovery: %s\n" recovery))
      )
      ("WARNING"
        printf("⚠️  %s\n" logMsg)
      )
      ("INFO"  
        printf("ℹ️  %s\n" logMsg)
      )
      ("DEBUG"
        when(getf(skillErrorConfig 'verboseMode)
          printf("🐛 %s\n" logMsg)
        )
      )
    )
    
    ; Log to file if enabled
    when(getf(skillErrorConfig 'logToFile)
      skillLogToFile(logMsg level context)
    )
    
    ; Return appropriate value based on level
    case(level
      ("ERROR" error(message))  ; Throw error for ERROR level
      (t nil)                   ; Return nil for other levels
    )
  )
)

; File logging function
defun(skillLogToFile(message level context)
  let((logFile fp timestamp))
    logFile = getf(skillErrorConfig 'logFile)
    
    ; Ensure log directory exists
    when(not(isDir(dirName(logFile))))
      system(sprintf(nil "mkdir -p %s" dirName(logFile)))
    )
    
    ; Write to log file
    fp = outfile(logFile "a")  ; Append mode
    when(fp
      timestamp = getCurrentTime("iso")
      fprintf(fp "%s [%s] %s %s\n" 
        timestamp level message 
        if(context sprintf(nil "[%s]" context) "")
      )
      close(fp)
    )
  )
)

; Configuration functions
defun(skillErrorSetConfig(key value)
  skillErrorConfig = putf(skillErrorConfig key value)
  printf("Error handler config updated: %s = %L\n" key value)
)

defun(skillErrorGetConfig(key)
  getf(skillErrorConfig key)
)

; Convenience wrapper functions  
defun(skillWarning(message @optional (context nil))
  skillError(message "WARNING" context)
)

defun(skillInfo(message @optional (context nil))
  skillError(message "INFO" context)
)

defun(skillDebug(message @optional (context nil))
  skillError(message "DEBUG" context)
)

; Safe function execution with error handling
defun(skillSafeExec(func args @optional (onError nil) (context nil))
  let((result))
    errset(
      result = apply(func args)
      ; If we get here, execution was successful
      result
    )
    ; Error occurred
    skillError(
      sprintf(nil "Function %s failed with args: %L" func args)
      "ERROR" 
      context
      onError
    )
    ; Return nil or execute recovery function
    when(onError apply(onError list()))
    nil
  )
)

; Parameter validation helpers
defun(skillValidateParam(param paramName expectedType @optional (allowNil nil))
  let((actualType isValid))
    actualType = type(param)
    
    cond(
      ; Check for nil when not allowed
      (and(null(param)) not(allowNil))
        skillError(
          sprintf(nil "Parameter '%s' cannot be nil" paramName)
          "ERROR"
          sprintf(nil "Expected: %s, Got: nil" expectedType)
        )
      )
      
      ; Check type mismatch (skip if param is nil and nil is allowed)
      (and(not(null(param))) not(eq(actualType expectedType)))
        skillError(
          sprintf(nil "Parameter '%s' has wrong type" paramName)
          "ERROR"  
          sprintf(nil "Expected: %s, Got: %s" expectedType actualType)
        )
      )
      
      ; Validation passed
      (t isValid = t)
    )
    isValid
  )
)

; Function to clear error log
defun(skillClearErrorLog()
  let((logFile))
    logFile = getf(skillErrorConfig 'logFile)
    when(isFile(logFile)
      deleteFile(logFile)
      skillInfo("Error log cleared")
    )
  )
)

; Helper to get current time in various formats
defun(getCurrentTime(@optional (format "iso"))
  let((timeStr))
    case(format
      ("iso" 
        timeStr = system("date '+%Y-%m-%d %H:%M:%S'")
        ; Remove newline
        rexReplace(timeStr "\n$" "" 0)
      )
      ("timestamp"
        system("date '+%s'")
      )
      (t
        system("date")
      )
    )
  )
)

printf("errorHandler.il loaded - Standardized error handling system\n")
printf("Functions available:\n")
printf("  skillError(message @optional level context recovery)\n")
printf("  skillWarning(message @optional context)\n")
printf("  skillInfo(message @optional context)\n")  
printf("  skillDebug(message @optional context)\n")
printf("  skillSafeExec(func args @optional onError context)\n")
printf("  skillValidateParam(param paramName expectedType @optional allowNil)\n")
printf("  skillErrorSetConfig(key value)\n")
printf("  skillClearErrorLog()\n")
printf("Configuration: %L\n" skillErrorConfig)