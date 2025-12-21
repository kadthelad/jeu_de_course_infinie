extends Node

# UI
const MAIN_MENU_UI := preload("res://UI/main_menu.tscn")
const GAME_UI := preload("res://UI/game_ui.tscn")
# SCENES
const GAME_SCENE := preload("res://Maps/game.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_game()
	load_main_menu()
	
	# Tell every node that the game is not on
	GameManager.is_game_on = false
	GameManager._game_started.connect(_on_game_started)


func load_main_menu() -> void:
	var main_menu_instance := MAIN_MENU_UI.instantiate()
	add_child(main_menu_instance)

func load_game() -> void:
	var game_instance := GAME_SCENE.instantiate()
	add_child(game_instance)

func _on_game_started() -> void:
	var game_ui_instance := GAME_UI.instantiate()
	add_child(game_ui_instance)
