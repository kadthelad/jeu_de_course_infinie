extends Node

# Constants
const MAX_GAME_SPEED := 900
const DEFAULT_GAME_SPEED := 500.0

# Game
signal _game_started
signal _game_ended
signal _game_speed_changed

signal _update_game_ui

var is_game_on := false: ## This tracks if the game is started or not
	set(value):
		is_game_on = value
		if value: # GAME STARTED
			_game_started.emit()
		else: # GAME ENDED
			game_speed = DEFAULT_GAME_SPEED
			coins_player_purse += current_coins # Add the coins to the player's purse
			_game_ended.emit()

var game_speed := DEFAULT_GAME_SPEED:
	set(value):
		if value < MAX_GAME_SPEED:
			game_speed = value
			_game_speed_changed.emit(value)
			_update_game_ui.emit()

# Obstacles
const OBSTACLES_PATH := "res://Entities/Obstacles/"

var obstacles_array: Array[PackedScene] = []
var obstacles_ready := false ## So you can't start a game without having all the obstacles loaded in already

# Player
var current_coins := 0:
	set(value):
		current_coins = value
		_update_game_ui.emit()

var coins_player_purse := 0

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
