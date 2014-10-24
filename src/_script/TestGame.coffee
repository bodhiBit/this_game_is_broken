Game = require "./Game.coffee"
Direction = require "./Direction.coffee"
DirectionMode = require "./DirectionMode.coffee"

###
  TestGame class
###
class TestGame extends Game
  constructor: ->
    super
    @gameSystem.storeSprite "superbat", "gfx/superbat.png", 160, 200
    @gameSystem.storeSprite "supermario", "gfx/NES_Super_Mario_Bros.png", 256, 224
    @gameSystem.storeSprite "hipster", "gfx/hipster_walk.gif", 16, 32
    @hipsterX = 0
    @hipsterY = 0
    @hipsterFrame = 0
    @hipsterRow = 0
    @frameSkip = 0
    @gameSystem.directionMode = DirectionMode.EIGHT_WAY
  
  render: (timestamp) ->
    super
    @frameSkip = (@frameSkip + 1) % 4
    if @frameSkip isnt 0
      return
    c = "hsl(#{ 360 * do Math.random }, 50%, 50%)"
    x = @gameSystem.width * do Math.random
    y = @gameSystem.height * do Math.random
    @gameSystem.rect x - 50, y - 50, x + 50, y + 50, c
    @gameSystem.drawSprite "supermario", 0, -8
    @gameSystem.drawSprite "hipster", @hipsterX, @hipsterY, @hipsterFrame, @hipsterRow
    if @gameSystem.direction isnt null
      @hipsterFrame++
      if @gameSystem.isHeading Direction.RIGHT
        @hipsterX++
      if @gameSystem.isHeading Direction.LEFT
        @hipsterX--
      if @gameSystem.isHeading Direction.UP
        @hipsterY -= 2
      if @gameSystem.isHeading Direction.DOWN
        @hipsterY += 2
    if @hipsterX < -32
      @hipsterX = @gameSystem.width
    if @hipsterX > @gameSystem.width
      @hipsterX = -32
    if @hipsterFrame >= 8
      @hipsterFrame = 0
    
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
