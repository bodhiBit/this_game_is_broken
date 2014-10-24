###
  Game class
###
class Game
  Object.defineProperties @::,
    gameSystem:
      get: -> @_gameSystem
      set: (gameSystem) ->
        if @_gameSystem isnt gameSystem
          if @_gameSystem?
            @_gameSystem.game = null
          @_gameSystem = gameSystem
          @_gameSystem.game = @ if @_gameSystem?
        @_gameSystem
  
  constructor: (@gameSystem) ->
    # ABSTRACT
  
  render: (timestamp) ->
    # ABSTRACT
  
  gamepad: (direction, buttons) ->
    # ABSTRACT

module.exports = Game
