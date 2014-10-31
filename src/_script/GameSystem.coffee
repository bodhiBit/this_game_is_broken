Sprite = require "./Sprite.coffee"
DirectionMode = require "./DirectionMode.coffee"
Direction = require "./Direction.coffee"

###
  GameSystem class
###
class GameSystem
  Object.defineProperties @::,
    game:
      get: -> @_game
      set: (game) ->
        if @_game isnt game
          if @_game?
            @_game.gameSystem = null
          @_game = game
          @_game.gameSystem = @ if @_game?
        @_game
    TVwidth:
      get: -> @width+2*@_borderWidth
    TVheight:
      get: -> @height+2*@_borderHeight
    directionMode:
      get: -> @_directionMode
      set: (directionMode) -> @setDirectionMode directionMode
    direction:
      get: -> @_direction
      set: (direction) -> @changeDirection direction
    buttons:
      get: -> @_buttons
    g:
      get: -> @_g
  
  constructor: (@_TVcanvas, @width=320, @height=200, @TVenabled=true) ->
    @_TVg = @_TVcanvas.getContext "2d"
    @_borderWidth = @width / 64
    @_borderHeight = @height / 64
    @_scale = 1
    @_sweep = 0
    @_sprites = {}
    @directionMode = DirectionMode.EIGHT_WAY
    @_buttons = [false, false]
    
    @_canvas = document.createElement "canvas"
    @_g = @_canvas.getContext "2d"
    
    @_TVscanlineImg = new Image()
    @_TVborderImg = new Image()
    @_TVborderImg.onload = =>
      do @_onResize
      window.addEventListener "resize", @_onResize.bind @
      @_render = @_render.bind @
      requestAnimationFrame @_render
    @_TVborderImg.src = "gfx/tv_border.png"
    @_TVcanvas.addEventListener "touchend", @fullScreen
    document.addEventListener "keydown", @_onKeyDown.bind @
    document.addEventListener "keyup", @_onKeyUp.bind @
  
  fullScreen: ->
    do document.body.webkitRequestFullscreen
    screen.lockOrientation "landscape"
  
  storeSprite: (name, url, width=32, height=32) ->
    if not @_sprites[name]?
      @_sprites[name] = new Sprite url, @_scale, width, height
  
  clearAllSprite: ->
    @_sprites = {}
  
  drawSprite: (name, left, top, column=0, row=0) ->
    s = @_sprites[name]
    if s?
      g = @_g
      g.drawImage (s.getFrame column, row), left, top, s.width, s.height
  
  line: (x1, y1, x2, y2, color) ->
    # TODO implementation
  
  rect: (x1, y1, x2, y2, color) ->
    left = Math.round Math.min x1, x2
    top = Math.round Math.min y1, y2
    width = 1 + Math.round Math.abs x2 - x1
    height = 1 + Math.round Math.abs y2 - y1
    g = @_g
    if color?
      g.fillStyle = color
    g.fillRect left, top, width, height
  
  shuffleCells: (x1, y1, x2, y2, shifts=8) ->
    # TODO implementation
  
  setDirectionMode: (@_directionMode) ->
    @direction = null
  
  changeDirection: (direction) ->
    direction = Direction.nearest direction, @_directionMode
    if @_direction isnt direction
      @_direction = direction
      @game.gamepad @_direction, @_buttons if @game?
  
  isHeading: (direction, threshold=2) ->
    threshold >= Direction.compare @direction, direction
  
  pressButton: (index) ->
    if index < @_buttons.length and not @_buttons[index]
      @_buttons[index] = true
      @game.gamepad @_direction, @_buttons if @game?
  
  depressButton: (index) ->
    if index < @_buttons.length and @_buttons[index]
      @_buttons[index] = false
      @game.gamepad @_direction, @_buttons if @game?
  
  _render: (timestamp) ->
    @game.render timestamp if @game?
    
    g = @_TVg
    
    g.fillStyle = "#8a7bce"
    g.fillStyle = "#000"
    g.fillRect -@_borderWidth, -@_borderHeight, @TVwidth, @TVheight
    g.drawImage @_canvas, 0, 0, @width, @height
    if @TVenabled
      g.drawImage @_TVscanlineImg, -@_borderWidth, -@_borderHeight,
                                                            @TVwidth, @TVheight
      g.fillStyle = "rgba(0, 0, 0, .03125)"
      g.fillRect -@_borderWidth, @_sweep, @TVwidth, @TVheight/2
      @_sweep++
      if @_sweep > @TVheight
        @_sweep = -@TVheight/2 - @_borderHeight
    requestAnimationFrame @_render
    
  _onResize: ->
    g = @_TVg
    if @TVenabled
      TVwidth = 2*(@width + 2*@_borderWidth)
      TVheight = 2*(@height + 2*@_borderHeight)
      @_scale = 2
    else
      TVwidth = window.innerWidth
      TVheight = window.innerHeight
      if @height > @width
        TVwidth /= 2
      @_scale = 1
      while @_scale*@height < TVheight
        @_scale++
      @_scale-- if @_scale > 1
      @_borderWidth = Math.round (TVwidth/@_scale - @width) / 2
      @_borderHeight = Math.round (TVheight/@_scale - @height) / 2
    
    @_canvas.setAttribute "width", @width*@_scale
    @_canvas.setAttribute "height", @height*@_scale
    @_g.scale @_scale, @_scale
    @_TVcanvas.setAttribute "width", TVwidth
    @_TVcanvas.setAttribute "height", TVheight
    g.clearRect 0, 0, TVwidth, TVheight
    
    if @TVenabled
      g.drawImage @_TVborderImg, 0, 0, TVwidth, TVheight

      for y in [0...TVheight] by 2
        g.fillStyle = "rgba(0, 0, 0, .5)"
        g.fillRect 0, y, TVwidth, 1
        for x in [(-y/2)...TVwidth] by 2
          g.fillStyle = "rgba(0, 0, 0, .125)"
          g.fillRect x, y+1, 1, 1
      @_TVscanlineImg.src = do @_TVcanvas.toDataURL
    
    for name, sprite of @_sprites
      sprite.scale = @_scale
    
    g.scale @_scale, @_scale
    g.translate @_borderWidth, @_borderHeight
  
  _onKeyDown: (e) ->
    switch e.keyCode
      when 38 # Up
        switch @direction
          when Direction.LEFT, Direction.UP_LEFT
            @changeDirection Direction.UP_LEFT
          when Direction.RIGHT, Direction.UP_RIGHT
            @changeDirection Direction.UP_RIGHT
          else
            @changeDirection Direction.UP
      when 40 # Down
        switch @direction
          when Direction.LEFT, Direction.DOWN_LEFT
            @changeDirection Direction.DOWN_LEFT
          when Direction.RIGHT, Direction.DOWN_RIGHT
            @changeDirection Direction.DOWN_RIGHT
          else
            @changeDirection Direction.DOWN
      when 37 # Left
        switch @direction
          when Direction.UP, Direction.UP_LEFT
            @changeDirection Direction.UP_LEFT
          when Direction.DOWN, Direction.DOWN_LEFT
            @changeDirection Direction.DOWN_LEFT
          else
            @changeDirection Direction.LEFT
      when 39 # Right
        switch @direction
          when Direction.UP, Direction.UP_RIGHT
            @changeDirection Direction.UP_RIGHT
          when Direction.DOWN, Direction.DOWN_RIGHT
            @changeDirection Direction.DOWN_RIGHT
          else
            @changeDirection Direction.RIGHT
      when 88 # X
        @pressButton 0
      when 90 # Z
        @pressButton 1
      else
        console.log "Unassigned keyCode: #{e.keyCode}_"
  
  _onKeyUp: (e) ->
    switch e.keyCode
      when 38 # Up
        switch @direction
          when Direction.UP_LEFT
            @changeDirection Direction.LEFT
          when Direction.UP_RIGHT
            @changeDirection Direction.RIGHT
          when Direction.UP
            @changeDirection null
      when 40 # Down
        switch @direction
          when Direction.DOWN_LEFT
            @changeDirection Direction.LEFT
          when Direction.DOWN_RIGHT
            @changeDirection Direction.RIGHT
          when Direction.DOWN
            @changeDirection null
      when 37 # Left
        switch @direction
          when Direction.UP_LEFT
            @changeDirection Direction.UP
          when Direction.DOWN_LEFT
            @changeDirection Direction.DOWN
          when Direction.LEFT
            @changeDirection null
      when 39 # Right
        switch @direction
          when Direction.UP_RIGHT
            @changeDirection Direction.UP
          when Direction.DOWN_RIGHT
            @changeDirection Direction.DOWN
          when Direction.RIGHT
            @changeDirection null
      when 88 # X
        @depressButton 0
      when 90 # Z
        @depressButton 1
      else
        console.log "Unassigned keyCode: #{e.keyCode}-"

module.exports = GameSystem
