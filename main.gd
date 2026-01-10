class_name Main
extends Node

# Signals
signal _on_game_loaded

# UI
const MAIN_MENU_UI := preload("res://UI/main_menu.tscn")
const GAME_UI := preload("res://UI/game_ui.tscn")
# SCENES
const GAME_SCENE := preload("res://Maps/game.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Tell every node that the game is not on
	GameManager._game_state_changed.connect(_on_game_state_changed)
	GameManager.game_state = GameManager.GAME_STATES.ENDED

func load_main_menu() -> void:
	# Load the Main Menu UI
	var main_menu_instance := MAIN_MENU_UI.instantiate()
	add_child(main_menu_instance)
	# Load the game in the background
	var game_instance := GAME_SCENE.instantiate()
	add_child(game_instance)
	
	# Load the player's data
	DataUtils.load_player_data()
	_on_game_loaded.emit()

func _on_game_state_changed() -> void:
	# Start game
	if GameManager.game_state == GameManager.GAME_STATES.STARTED:
		var game_ui_instance := GAME_UI.instantiate()
		add_child(game_ui_instance)
	
	# End game
	elif GameManager.game_state == GameManager.GAME_STATES.ENDED:
		for child in get_children(): # Clean the scene
			child.queue_free()
		
		DataUtils.save_player_data() # Save player's data
		load_main_menu() # Go back to the main menu
