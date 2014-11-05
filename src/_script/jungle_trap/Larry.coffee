"use strict"
GameObject = require "../GameObject.coffee"
DirectionMode = require "../DirectionMode.coffee"
Direction = require "../Direction.coffee"
Platform = require "./Platform.coffee"

###
  Larry class
###
class Larry extends GameObject
  constructor: (game) ->
    super game, 12, 21
    @gameSystem.storeSprite "larry", "gfx/jungle_trap/larry.png",
                                                                @width, @height
    @frame = @direction = @speedY = 0
    @gameSystem.directionMode = DirectionMode.EIGHT_WAY
  
  tick: ->
    if @gameSystem.direction isnt null
      @frame++
      if @gameSystem.direction is Direction.RIGHT
        @x += 4
        @direction = 0
      if @gameSystem.direction is Direction.LEFT
        @x += -4
        @direction = -1
    if @gameSystem.buttons[0] and not @jumping
      @speedY = -8
      @jumping = true
    if @gameSystem.buttons[1] and not @platforming
      do @game.addPlatform
      @platforming = true
    if not @gameSystem.buttons[1]
      @platforming = false
    @speedY++
    @y += @speedY
    if @x < 0
      @x = 0
    if @y > @gameSystem.height
      @y = 0
    if @frame >= 8
      @frame = 0
    if @x > @game.panX + @gameSystem.width
      @game.panX += @gameSystem.width
    if @x < @game.panX
      @game.panX += -@gameSystem.width
  
  collideWith: (obj) ->
    if @detectCollision obj
      if obj instanceof Platform
        if @y > obj.y
          @top = obj.bottom
        else
          @jumping = false
          @bottom = obj.top
        @speedY = 0
  
  render: (timestamp) ->
    super
    @gameSystem.drawSprite "larry", @left, @top, @frame, @direction

module.exports = Larry
