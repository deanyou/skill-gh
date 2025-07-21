;; copyleft ebecheto
;; lay2schName.il - Convert layout name format to schematic name format
;; Reverse operation of sch2layName

defun(lay2schName(@optional (layName "|MULT(0)"))
  let((stripped baseName indexPart result))
    ; Remove leading "|" if present
    stripped = if(rexMatchp("^\\|" layName)
                  then rexReplace(layName "^\\|" "" 0)
                  else layName
                )
    
    cond(
      ; Handle format like "MULT(0)" -> "MULT<0>"
      (rexMatchp("\\([^(]+\\)(\\([^)]+\\))" stripped)
        baseName = rexReplace(stripped "\\([^(]+\\)(.*" "\\1" 0)
        indexPart = rexReplace(stripped ".*\\(\\([^)]+\\)\\)" "\\1" 0)
        result = sprintf(nil "%s<%s>" baseName indexPart)
      )
      
      ; Handle simple names like "I0" -> "I0" (no change needed)
      (t
        result = stripped
      )
    )
    result
  )
)

; Convert list of layout names to schematic names
defun(lay2schNameList(layNameList)
  foreach(mapcar layName layNameList
    lay2schName(layName)
  )
)

; Enhanced version with error checking
defun(lay2schNameSafe(layName @optional (defaultName nil))
  let((result))
    when(not(stringp(layName))
      printf("Warning: lay2schName expects string input, got %L\n" layName)
      return(or(defaultName ""))
    )
    
    result = lay2schName(layName)
    
    ; Validate result
    unless(stringp(result)
      printf("Warning: lay2schName conversion failed for %s\n" layName)
      result = or(defaultName layName)
    )
    
    result
  )
)

printf("lay2schName(@optional (layName \"|MULT(0)\"))\n")
printf("lay2schNameList(layNameList)\n")
printf("lay2schNameSafe(layName @optional (defaultName nil))\n")
printf("Examples:\n")
printf("  lay2schName(\"|MULT(0)\")     => \"MULT<0>\"\n")
printf("  lay2schName(\"|MULT(4)\")     => \"MULT<4>\"\n")
printf("  lay2schName(\"|I0\")          => \"I0\"\n")
printf("  lay2schName(\"DATA(7)\")      => \"DATA<7>\"\n")