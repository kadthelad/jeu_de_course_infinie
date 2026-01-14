extends Node

# Constants
const MAX_GAME_SPEED := 900
const DEFAULT_GAME_SPEED := 500.0

# Game
enum GAME_STATES {
	STARTED,
	ENDED,
	PAUSED,
	RUNNING,
}
signal _game_state_changed
signal _game_speed_changed

signal _update_game_ui

var game_state := GAME_STATES.ENDED: ## This tracks the game's current state
	set(value):
		game_state = value
		_game_state_changed.emit()

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
var player: Player = null

var current_coins := 0: ## The amount of coins the player has in-game
	set(value):
		current_coins = value
		_update_game_ui.emit()

var coins_player_purse := 0: ## The amount of coins the player has in total
	set(value):
		coins_player_purse = value
		_update_game_ui.emit()

var player_inventory: Dictionary[GameItem, int] = {}

var player_hotbar: Array[GameItem] = [null, null, null]

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
