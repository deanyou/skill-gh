;; copyleft ebecheto
;; pointInbBox.il - Check if a point is inside a bounding box
;; Usage: pointInbBox(point bbox) => t/nil

ineed('(bBoxHeight bBoxWidth))

defun(pointInbBox(point bbox @optional (tolerance 0.0))
  let((px py xMin yMin xMax yMax)
    ; Extract point coordinates
    px = xCoord(point)
    py = yCoord(point)
    
    ; Extract bounding box coordinates
    xMin = xCoord(car(bbox))
    yMin = yCoord(car(bbox))
    xMax = xCoord(cadr(bbox))
    yMax = yCoord(cadr(bbox))
    
    ; Ensure bbox coordinates are properly ordered (min < max)
    when(xMin > xMax
      let((temp xMin))
        xMin = xMax
        xMax = temp
      )
    )
    when(yMin > yMax
      let((temp yMin))
        yMin = yMax
        yMax = temp
      )
    )
    
    ; Apply tolerance for boundary checking
    xMin = xMin - tolerance
    yMin = yMin - tolerance
    xMax = xMax + tolerance
    yMax = yMax + tolerance
    
    ; Check if point is within bounds
    and(
      px >= xMin
      px <= xMax
      py >= yMin
      py <= yMax
    )
  )
)

; Enhanced version with edge detection
defun(pointOnbBoxEdge(point bbox @optional (tolerance 0.001))
  let((px py xMin yMin xMax yMax onEdge))
    ; Extract coordinates
    px = xCoord(point)
    py = yCoord(point)
    xMin = xCoord(car(bbox))
    yMin = yCoord(car(bbox))
    xMax = xCoord(cadr(bbox))
    yMax = yCoord(cadr(bbox))
    
    ; Ensure proper ordering
    when(xMin > xMax
      let((temp xMin))
        xMin = xMax
        xMax = temp
      )
    )
    when(yMin > yMax
      let((temp yMin))
        yMin = yMax
        yMax = temp
      )
    )
    
    ; Check if point is on any edge within tolerance
    onEdge = or(
      ; Left or right edge
      and(
        or(
          abs(px - xMin) <= tolerance
          abs(px - xMax) <= tolerance
        )
        py >= yMin - tolerance
        py <= yMax + tolerance
      )
      ; Top or bottom edge
      and(
        or(
          abs(py - yMin) <= tolerance
          abs(py - yMax) <= tolerance
        )
        px >= xMin - tolerance
        px <= xMax + tolerance
      )
    )
    onEdge
  )
)

; Check which quadrant of bbox the point is in
defun(pointbBoxQuadrant(point bbox)
  let((px py centerX centerY xMin yMin xMax yMax))
    px = xCoord(point)
    py = yCoord(point)
    xMin = xCoord(car(bbox))
    yMin = yCoord(car(bbox))
    xMax = xCoord(cadr(bbox))
    yMax = yCoord(cadr(bbox))
    
    centerX = (xMin + xMax) / 2.0
    centerY = (yMin + yMax) / 2.0
    
    cond(
      (and(px <= centerX py <= centerY) "SW") ; Southwest
      (and(px > centerX py <= centerY) "SE")  ; Southeast
      (and(px <= centerX py > centerY) "NW")  ; Northwest
      (and(px > centerX py > centerY) "NE")   ; Northeast
      (t "CENTER")
    )
  )
)

printf("pointInbBox(point bbox @optional (tolerance 0.0))\n")
printf("pointOnbBoxEdge(point bbox @optional (tolerance 0.001))\n")
printf("pointbBoxQuadrant(point bbox)\n")
printf("Examples:\n")
printf("  pointInbBox('(5 5) '((0 0) (10 10)))          => t\n")
printf("  pointInbBox('(15 5) '((0 0) (10 10)))         => nil\n")
printf("  pointOnbBoxEdge('(0 5) '((0 0) (10 10)) 0.1)  => t\n")
printf("  pointbBoxQuadrant('(3 3) '((0 0) (10 10)))    => \"SW\"\n")