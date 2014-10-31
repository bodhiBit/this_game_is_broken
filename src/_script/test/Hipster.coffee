"use strict"
GameObject = require "../GameObject.coffee"
Direction = require "../Direction.coffee"
DirectionMode = require "../DirectionMode.coffee"

###
  Hipster class
###
class Hipster extends GameObject
  constructor: (@game) ->
    super @game, 16, 32
    @gameSystem.storeSprite "hipster", "gfx/test/hipster_walk.gif", 16, 32
    @frame = @direction = 0
    @gameSystem.directionMode = DirectionMode.EIGHT_WAY
  
  tick: ->
    if @gameSystem.direction isnt null
      @frame++
      if @gameSystem.direction is Direction.RIGHT
        console.log "RIGHT!"
        @pending.x = @x + 2
        @direction = 0
      if @gameSystem.direction is Direction.LEFT
        console.log "LEFT!"
        @pending.x = @x - 2
        @direction = -1
      if @gameSystem.direction is Direction.UP
        console.log "UP!"
        @pending.y = @y - 4
      if @gameSystem.direction is Direction.DOWN
        console.log "DOWN!"
        @pending.y = @y + 4
    if @x < -32
      @pending.x = @gameSystem.width
    if @x > @gameSystem.width
      @pending.x = -32
    if @frame >= 8
      @frame = 0
  
  render: (timestamp) ->
    super
    @gameSystem.drawSprite "hipster", @left, @top, @frame, @direction

module.exports = Hipster
