###
  Sprite class
###
class Sprite
  Object.defineProperties @::,
    scale:
      get: -> @_scale
      set: (scale) ->
        if @_scale isnt scale
          @_scale = scale
          @_frames = []
          @_mirrorFrames = []
        @_scale
  
  constructor: (src, @scale, @width, @height) ->
    @srcimg = new Image()
    @_frames = []
    @_mirrorFrames = []
    canvas = document.createElement "canvas"
    g = canvas.getContext "2d"
    @srcimg.onload = =>
      @_frames = []
      @_mirrorFrames = []
      @columns = Math.round @srcimg.width / @width
      @rows = Math.round @srcimg.height / @height
      canvas.setAttribute "width", @srcimg.width
      canvas.setAttribute "height", @srcimg.height
      g.drawImage @srcimg, 0, 0
      @imgdata = g.getImageData 0, 0, @srcimg.width, @srcimg.height
      if @onload?
        do @onload
    @srcimg.src = src
  
  getFrame: (column=0, row=0) ->
    if row < 0
      frames = @_mirrorFrames
      row += @rows
    else
      frames = @_frames
    i = (row * @columns + column)
    if not frames[i]?
      canvas = document.createElement "canvas"
      canvas.setAttribute "width", @width*@scale
      canvas.setAttribute "height", @height*@scale
      g = canvas.getContext "2d"
      g.scale @scale, @scale
      left = column*@width
      top = row*@height
      for y in [top...@height+top]
        for x in [left...@width+left]
          if frames is @_mirrorFrames
            g.fillStyle = @_pget (left+@width-1) - (x-left), y
          else
            g.fillStyle = @_pget x, y
          g.fillRect x-left, y-top, 1, 1
      frames[i] = canvas
    frames[i]
  
  _pget: (x, y) ->
    x = x % @srcimg.width
    y = y % @srcimg.height
    i = (y * @srcimg.width + x) * 4
    color = "rgba("
    color += @imgdata.data[i+0] + ","
    color += @imgdata.data[i+1] + ","
    color += @imgdata.data[i+2] + ","
    color += (@imgdata.data[i+3]/255) + ")"
    color

module.exports = Sprite
