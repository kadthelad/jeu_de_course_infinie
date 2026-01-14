extends Node3D

const PAUSE_MENU_UI := preload("res://UI/pause_menu.tscn")
const LIGHT_SPEED := 0.2

@onready var light: Node3D = %Light

@export var player: Player

func _ready() -> void:
	if player != null:
		GameManager.player = player
	else:
		PrintUtils.print_wrn("Player variable not assigned in Game node!")

func _process(delta: float) -> void:
	light.rotate_z(LIGHT_SPEED * delta)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("game_pause"): # PAUSE THE GAME
		GameManager.game_state = GameManager.GAME_STATES.PAUSED
		var pause_menu_instance := PAUSE_MENU_UI.instantiate()
		get_parent().add_child(pause_menu_instance)
