extends Node

const VERSION := "0.1.0.alpha"
const DEBUG := true

var music_enable := true
var sound_enable := true

const RES_X := 360
const RES_Y := 240

# Almacenamiento de data temporal par el
# final de nivel
var store_iron_earned := 0
var store_titanium_earned := 0
var store_steel_earned := 0
var store_ruby_earned := 0

# Win or Lose?
enum Result {NONE, WIN, LOSE}
var result = Result.NONE