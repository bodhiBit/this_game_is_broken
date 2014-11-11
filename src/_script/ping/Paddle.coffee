"use strict"
GameObject = require "../GameObject.coffee"
Direction = require "../Direction.coffee"

###
  Paddle class
###
class Paddle extends GameObject
  constructor: (game, x, @ai) ->
    super game, 8, 48, x, 100
    @speedY = 0
    @maxSpeed = 2
  
  tick: ->
    if @ai
      if (@game.ball.x < @x and @game.ball.speedX > 0) or
                                  (@game.ball.x > @x and @game.ball.speedX < 0)
        if @game.ball.y < @y
          @speedY = -@maxSpeed
        else
          @speedY = @maxSpeed
      else
        @speedY = 0
    else
      if @gameSystem.direction is Direction.UP
        @speedY = -@maxSpeed
      else if @gameSystem.direction is Direction.DOWN
        @speedY = @maxSpeed
      else
        @speedY = 0
        
    @y += @speedY

  render: ->
    @gameSystem.rect @left, @top, @width, @height, "white"

module.exports = Paddle
