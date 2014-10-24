###
  Direction enum
###
i = 0
Direction =
  UP_RIGHT:{i:i++}
  RIGHT:{i:i++}
  DOWN_RIGHT:{i:i++}
  DOWN:{i:i++}
  DOWN_LEFT:{i:i++}
  LEFT:{i:i++}
  UP_LEFT:{i:i++}
  UP:{i:i++}
  
  compare: (direction1, direction2) ->
    diff = Math.abs direction1.i - direction2.i
    if diff > 4
      diff = 8 - diff
    diff
  
  nearest: (direction, directionMode) ->
    if not direction?
      null
    else
      bestMatch = null
      bestMatchDiff = 100
      for dir in directionMode
        diff = @compare direction, dir
        if diff < bestMatchDiff
          bestMatch = dir
          bestMatchDiff = diff
        else if diff is bestMatchDiff
          bestMatch = null
          bestMatchDiff = 1
      bestMatch

module.exports = Direction
