Direction = require "./Direction.coffee"

###
  DirectionMode enum
###
DirectionMode =
  UP_DOWN:    [Direction.UP, Direction.DOWN]
  LEFT_RIGHT: [Direction.LEFT, Direction.RIGHT]
  FOUR_WAY:   [Direction.UP, Direction.RIGHT, Direction.DOWN, Direction.LEFT]
  EIGHT_WAY:  [Direction.UP, Direction.UP_RIGHT, Direction.RIGHT, Direction.DOWN_RIGHT,
               Direction.DOWN, Direction.DOWN_LEFT, Direction.LEFT, Direction.UP_LEFT]
  DIAGONAL:   [Direction.UP_RIGHT, Direction.DOWN_RIGHT, Direction.DOWN_LEFT, Direction.UP_LEFT]
  

module.exports = DirectionMode
