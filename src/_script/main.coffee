"use strict"
GameSystem = require "./GameSystem.coffee"
TestGame = require "./test/TestGame.coffee"

###
 main.coffee
 Main script for this_game_is_broken
###
Element::requestFullscreen ?=
  Element::msRequestFullscreen or
  Element::mozRequestFullScreen or
  Element::webkitRequestFullscreen
if Screen?
  Screen::lockOrientation ?=
    Screen::mozLockOrientation or
    Screen::webkitLockOrientation
window.requestAnimationFrame ?= window.webkitRequestAnimationFrame

TVcanvas = document.getElementsByTagName("canvas")[0]

gameSystem = new GameSystem TVcanvas, 320, 200, true
game = new TestGame gameSystem
gameSystem.game = game
