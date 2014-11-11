"use strict"
GameObject = require "../GameObject.coffee"

###
  Ball class
###
class Ball extends GameObject
  constructor: (game) ->
    super game, 8, 8
    do @reset
  
  tick: ->
    if @speedX is 0 and @speedY is 0 and @gameSystem.buttons[0]
      rnd = do Math.random
      @speedX = if rnd > .5 then 2 else -2
      @speedY = -2 + 4 * do Math.random
      
    
    @x += @speedX
    @y += @speedY
    
    if @x < 0
      @game.rightScore++
      do @reset
    else if @x > @gameSystem.width
      @game.leftScore++
      do @reset
    
    if @y < 0
      @speedY = Math.abs @speedY
    else if @y > @gameSystem.height
      @speedY = 0 - Math.abs @speedY
  
  collideWith: (obj) ->
    if @detectCollision obj
      if obj.x < @gameSystem.width / 2
        @speedX = Math.abs @speedX
        @speedY += obj.speedY
      else
        @speedX = 0 - Math.abs @speedX
        @speedY += obj.speedY
  
  render: ->
    @gameSystem.rect @left, @top, @width, @height, "white"
  
  reset: ->
    @x = @gameSystem.width / 2
    @y = @gameSystem.height / 2
    @speedX = @speedY = 0
    

module.exports = Ball
