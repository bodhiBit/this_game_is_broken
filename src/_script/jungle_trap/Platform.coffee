"use strict"
GameObject = require "../GameObject.coffee"

###
  Platform class
###
class Platform extends GameObject
  constructor: ->
    super
    hue = 360 * do Math.random
    @color = "hsl(#{hue}, 50%, 50%)"
  
  render: (timestamp) ->
    @gameSystem.rect @left, @top, @width, @height, @color

module.exports = Platform
