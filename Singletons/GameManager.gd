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

var large_obstacles: Array[PackedScene] = []
var small_obstacles: Array[PackedScene] = []
var obstacles_ready := false ## So you can't start a game without having all the obstacles loaded in already


# Script
func _ready() -> void:
	# Add existing obstacles in the arrays
	var dir_access := DirAccess.open(OBSTACLES_PATH)
	if dir_access:
		#PrintUtils.print_dbg("Obstacles folder found! Searching for large and small obstacles...")
		# Add the large obstacles
		var current_obstacle_type_path := OBSTACLES_PATH + "Large/"
		dir_access = DirAccess.open(current_obstacle_type_path)
		if dir_access:
			#PrintUtils.print_dbg("Large Obstacles folder found! Adding large obstacles to list...")
			for file in dir_access.get_files():
				large_obstacles.append(load(current_obstacle_type_path + file))
		# Add the small obstacles
		current_obstacle_type_path = OBSTACLES_PATH + "Small/"
		dir_access = DirAccess.open(current_obstacle_type_path)
		if dir_access:
			#PrintUtils.print_dbg("Small Obstacles folder found! Adding large obstacles to list...")
			for file in dir_access.get_files():
				small_obstacles.append(load(current_obstacle_type_path + file))
		# Obstacles are ready!
		obstacles_ready = true
	# ======================================================================== #
	
