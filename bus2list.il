;; copyleft ebecheto
;; bus2list.il - Convert bus notation to list of signal names
;; Usage: bus2list("signal<0:3>") => ("signal<0>" "signal<1>" "signal<2>" "signal<3>")

defun(bus2list(busName @optional (reverse nil))
  let((baseName startIdx endIdx indices result)
    cond(
      ; Handle bus notation like "signal<0:3>" or "signal<3:0>"
      (rexMatchp("<\\([0-9]+\\):\\([0-9]+\\)>" busName)
        baseName = rexReplace(busName "<\\([0-9]+\\):\\([0-9]+\\)>" "" 0)
        startIdx = atoi(rexReplace(busName ".*<\\([0-9]+\\):.*" "\\1" 0))
        endIdx = atoi(rexReplace(busName ".*:\\([0-9]+\\)>.*" "\\1" 0))
        
        ; Create index list in proper order
        if(startIdx <= endIdx
          then indices = range(startIdx endIdx)
          else indices = reverse(range(endIdx startIdx))
        )
        
        ; Generate signal names
        result = foreach(mapcar idx indices
          sprintf(nil "%s<%d>" baseName idx)
        )
        
        ; Apply reverse if requested
        when(reverse result = reverse(result))
        result
      )
      
      ; Handle single bit like "signal<5>"
      (rexMatchp("<[0-9]+>" busName)
        list(busName)
      )
      
      ; Handle non-bus signal names
      (t
        list(busName)
      )
    )
  )
)

; Helper function to create range of integers
defun(range(start end)
  let((result i))
    result = nil
    for(i start end
      result = append1(result i)
    )
    result
  )
)

printf("bus2list(busName @optional (reverse nil))\n")
printf("Examples:\n")
printf("  bus2list(\"data<0:7>\")     => (\"data<0>\" \"data<1>\" ... \"data<7>\")\n")
printf("  bus2list(\"addr<15:0>\")   => (\"addr<15>\" \"addr<14>\" ... \"addr<0>\")\n")
printf("  bus2list(\"clk\")          => (\"clk\")\n")
printf("  bus2list(\"enable<3>\")    => (\"enable<3>\")\n")