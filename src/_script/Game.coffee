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
          if @_gameSystem?
            @_gameSystem.game = @
        return @_gameSystem
  
  constructor: (@gameSystem) ->
    # ABSTRACT
    @panX = @panY = 0
    @objects = []
    @_leftMostObject = 0
  
  render: (timestamp) ->
    i = 0
    while @_leftMostObject < @objects.length-1 and
                                            @objects[@_leftMostObject].x < @panX
      i = ++@_leftMostObject
    while @_leftMostObject > 0 and @objects[@_leftMostObject].x > @panX
      i = --@_leftMostObject
    while i < @objects.length and @objects[i].x < @panX + @gameSystem.width
      object = @objects[i]
      do object.tick
      if object.collideWith?
        j = @_leftMostObject
        while j < @objects.length and @objects[j].x < @panX + @gameSystem.width
          target = @objects[j]
          if object isnt target
            object.collideWith target
          j++
      i++
    do @gameSystem.g.save
    @gameSystem.g.translate -@panX, -@panY
    i = @_leftMostObject
    while i < @objects.length and @objects[i].x < @panX + @gameSystem.width
      object = @objects[i]
      object.render timestamp
      if i > 0 and object.x < @objects[i-1].x
        @objects[i] = @objects[i-1]
        @objects[i-1] = object
      i++
    do @gameSystem.g.restore
  
  gamepad: (direction, buttons) ->
    # ABSTRACT
  
  addObject: (object) ->
    if -1 isnt @objects.indexOf object
      return @
    @objects.push object
    @objects.sort @_objectComparator
    object.game = @
  
  removeObject: (object) ->
    if -1 is @objects.indexOf object
      return @
    @objects.splice (@objects.indexOf object), 1
    object.game = null
    return @
  
  _objectComparator: (ob1, ob2) ->
    ob1.x - ob2.x

module.exports = Game
