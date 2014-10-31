"use strict"

###
  GameObject class
###
class GameObject
  Object.defineProperties @::,
    game:
      get: -> @_game
      set: (game) ->
        if @_game is game
          return @_game
        if @_game?
          @_game.removeObject @
        @_game = game
        if @_game?
          @_game.addObject @
    gameSystem:
      get: -> if @game? then @game.gameSystem else null
    left:
      get: -> @x - @anchorX
      set: (left) -> @x = left + @anchorX
    top:
      get: -> @y - @anchorY
      set: (top) -> @y = top + @anchorY
    right:
      get: -> @x + @width - @anchorX
      set: (right) -> @x = right - @width + @anchorX
    bottom:
      get: -> @y + @height - @anchorY
      set: (bottom) -> @y = bottom - @height + @anchorY
  
  constructor: (@game, @width, @height) ->
    @anchorX = Math.round @width / 2
    @anchorY = Math.round @height / 2
    @x = @y = 32
    @pending = {}
  
  tick: ->
    # ABSTRACT
  
  render: (timestamp) ->
    for key, val of @pending
      @[key] = val
    # ABSTRACT

module.exports = GameObject
