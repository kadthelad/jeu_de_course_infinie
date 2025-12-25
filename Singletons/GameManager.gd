extends Node

# Game
signal _game_started
signal _game_ended
signal _game_speed_changed

var is_game_on := false: ## This tracks if the game is started or not
	set(value):
		if value:
			_game_started.emit()
		else:
			_game_ended.emit()

var game_speed := 500.0:
	set(value):
		_game_speed_changed.emit(value)

# Obstacles
const OBSTACLES_PATH := "res://Entities/Obstacles/"

var obstacles_array: Array[PackedScene] = []
var obstacles_ready := false ## So you can't start a game without having all the obstacles loaded in already


# Script
func _ready() -> void:
	# Add existing obstacles in obstacles_array
	var dir_access := DirAccess.open(OBSTACLES_PATH)
	if dir_access:
		#PrintUtils.print_dbg("Obstacles folder found! Searching for obstacles...")
		for file in dir_access.get_files():
			obstacles_array.append(load(OBSTACLES_PATH + file))
		# Obstacles are ready!
		#PrintUtils.print_dbg("Obstacles ready!...")
		obstacles_ready = true
	# ======================================================================== #
	
