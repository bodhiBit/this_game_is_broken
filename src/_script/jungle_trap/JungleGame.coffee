"use strict"
Game = require "../Game.coffee"
Larry = require "./Larry.coffee"
Platform = require "./Platform.coffee"

###
  JungleGame class
###
class JungleGame extends Game
  constructor: (@gameSystem) ->
    super
    @gameSystem.storeSprite "jungle_bg", "gfx/jungle_trap/jungle_bg.png",
                                                                        320, 200
    @frameSkip = 0
    @hero = new Larry @
    @lastPlatform = new Platform @, 100, 8, 32, 50 + 100 * do Math.random
  
  render: (timestamp) ->
    @frameSkip = (@frameSkip + 1) % 4
    if @frameSkip isnt 0
      return
    if @lastPlatform.left < @panX + @gameSystem.width
      do @addPlatform
    @gameSystem.drawSprite "jungle_bg", 0, 0
    super
  
  gamepad: (direction, buttons) ->
    # ABSTRACT
  
  addPlatform: ->
    @lastPlatform = new Platform @, 32, 8,
                                @lastPlatform.x + 32, 50 + 100 * do Math.random

module.exports = JungleGame
