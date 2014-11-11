"use strict"
Game = require "../Game.coffee"
Paddle = require "./Paddle.coffee"
Ball = require "./Ball.coffee"
JungleGame = require "../jungle_trap/JungleGame.coffee"

###
  PingGame class
###
class PingGame extends Game
  constructor: ->
    super
    @gameSystem.storeSprite "ping_bg", "gfx/ping/background.gif", 320, 200
    @gameSystem.storeSprite "ping_digits", "gfx/ping/digits.gif", 26, 46
    @leftScore = @rightScore = 0
    @leftPaddle   = new Paddle @, 32, false
    @rightPaddle  = new Paddle @, 320 - 32, true
    @ball = new Ball @
  
  render: ->
    @gameSystem.drawSprite "ping_bg", 0, 0
    @gameSystem.drawSprite "ping_digits", 117, 7, @leftScore,  0
    @gameSystem.drawSprite "ping_digits", 177, 7, @rightScore, 0
    super
    if @leftScore is 10 or @rightScore is 10
      gs = @gameSystem
      gs.game = null
      setTimeout ->
        new JungleGame gs
      , 1000

module.exports = PingGame
