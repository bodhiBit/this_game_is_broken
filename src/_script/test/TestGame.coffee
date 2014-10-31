Game = require "../Game.coffee"
Direction = require "../Direction.coffee"
DirectionMode = require "../DirectionMode.coffee"
Hipster = require "./Hipster.coffee"

###
  TestGame class
###
class TestGame extends Game
  constructor: ->
    super
    @gameSystem.storeSprite "superbat", "gfx/test/superbat.png", 320, 200
    @frameSkip = 0
    @addObject new Hipster @
  
  render: (timestamp) ->
    @frameSkip = (@frameSkip + 1) % 4
    if @frameSkip isnt 0
      return
    @gameSystem.drawSprite "superbat", 0, 0
    super
    
  gamepad: (direction, buttons) ->
    super
    switch direction
      when Direction.UP
        console.log "going up!"
      when Direction.DOWN
        console.log "going down!"
      when Direction.LEFT
        console.log "going left!"
        @hipsterRow = -1
      when Direction.RIGHT
        console.log "going right!"
        @hipsterRow = 0
      when Direction.UP_LEFT
        console.log "going up and to the left!"
        @hipsterRow = -1
      when Direction.UP_RIGHT
        console.log "going up and to the right!"
        @hipsterRow = 0
      when Direction.DOWN_LEFT
        console.log "going down and to the left!"
        @hipsterRow = -1
      when Direction.DOWN_RIGHT
        console.log "going down and to the right!"
        @hipsterRow = 0
      else
        console.log "not going anywhere..."
    # ABSTRACT

module.exports = TestGame
