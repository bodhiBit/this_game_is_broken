"use strict"

###
  GameObject class
###
class GameObject
  Object.defineProperties @::,
    game:
      get: -> @_game
      set: (game) ->
        @pending ?= {}
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
    x:
      get: ->
        if @pending.x? and not @game.latched
          @_x = @pending.x
          @pending.x = undefined
        @_x
      set: (x) ->
        if @game? and @game.latched
          @pending.x = Math.round x
        else
          @_x = Math.round x
    y:
      get: ->
        if @pending.y? and not @game.latched
          @_y = @pending.y
          @pending.y = undefined
        @_y
      set: (y) ->
        if @game? and @game.latched
          @pending.y = Math.round y
        else
          @_y = Math.round y
    width:
      get: ->
        if @pending.width? and not @game.latched
          @_width = @pending.width
          @pending.width = undefined
        @_width
      set: (width) ->
        if @game? and @game.latched
          @pending.width = Math.round width
        else
          @_width = Math.round width
    height:
      get: ->
        if @pending.height? and not @game.latched
          @_height = @pending.height
          @pending.height = undefined
        @_height
      set: (height) ->
        if @game? and @game.latched
          @pending.height = Math.round height
        else
          @_height = Math.round height
  
  constructor: (game, @width=32, @height=32, @x=32, @y=32) ->
    @pending ?= {}
    @anchorX ?= Math.round @width / 2
    @anchorY ?= Math.round @height / 2
    @game = game
  
  tick: ->
    # ABSTRACT
  
  render: (timestamp) ->
    # ABSTRACT
  
  
  detectCollision: (obj) ->
    if obj is @
      false
    else
      xMin1 = @.left
      xMax1 = @.right
      yMin1 = @.top
      yMax1 = @.bottom
      xMin2 = obj.left
      xMax2 = obj.right
      yMin2 = obj.top
      yMax2 = obj.bottom
      
      @_rangeOverlap(xMin1, xMax1, xMin2, xMax2) and
      @_rangeOverlap yMin1, yMax1, yMin2, yMax2
    
  _rangeOverlap: (min1, max1, min2, max2) ->
    max1 >= min2 and max2 >= min1
  
module.exports = GameObject
