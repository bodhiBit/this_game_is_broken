###
  Game class
###
class Game
  Object.defineProperties @::,
    gameSystem:
      get: -> @_gameSystem
      set: (gameSystem) ->
        if @_gameSystem isnt gameSystem
          oldGameSystem = @_gameSystem
          @_gameSystem = gameSystem
          if oldGameSystem?
            oldGameSystem.game = null
          if @_gameSystem?
            @_gameSystem.game = @
        return @_gameSystem
  
  constructor: (@gameSystem) ->
    # ABSTRACT
    @panX = @panY = 0
    @objects = []
    @_leftMostObject = 0
    @lached = false
  
  render: (timestamp) ->
    @lached = true
    i = 0
    while @_leftMostObject < @objects.length-1 and
                                        @objects[@_leftMostObject].right < @panX
      i = ++@_leftMostObject
    while @_leftMostObject > 0 and @objects[@_leftMostObject].right > @panX
      i = --@_leftMostObject
    while i < @objects.length and @objects[i].left < @panX + @gameSystem.width
      object = @objects[i]
      do object.tick
      if object.collideWith?
        j = @_leftMostObject
        while j < @objects.length and
                                    @objects[j].left < @panX + @gameSystem.width
          target = @objects[j]
          if object isnt target
            object.collideWith target
          j++
      i++
    @lached = false
    do @gameSystem.g.save
    @gameSystem.g.translate -@panX, -@panY
    i = @_leftMostObject
    while i < @objects.length and @objects[i].left < @panX + @gameSystem.width
      object = @objects[i]
      object.render timestamp
      # @gameSystem.g.fillStyle = "white"
      # @gameSystem.g.fillText "##{i}", object.x, object.y
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
    object.game = @
    @objects.sort @_objectComparator
  
  removeObject: (object) ->
    if -1 is @objects.indexOf object
      return @
    @objects.splice (@objects.indexOf object), 1
    object.game = null
    return @
  
  _objectComparator: (ob1, ob2) ->
    ob1.x - ob2.x

module.exports = Game
