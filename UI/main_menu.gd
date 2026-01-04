extends CanvasLayer

@onready var main : Main = get_parent() ## The parent is always main
@onready var purse_label: Label = %PurseLabel

func _ready() -> void:
	if main != null:
		main._on_game_loaded.connect(show_data)

func show_data() -> void:
	purse_label.text = tr("game_total_coins") + str(GameManager.coins_player_purse)

func _on_start_game_button_pressed() -> void:
	GameManager.game_state = GameManager.GAME_STATES.STARTED
	queue_free()

func _on_settings_button_pressed() -> void:
	var settings_ui_instance := SceneUtils.SETTINGS_UI_SCENE.instantiate()
	add_child(settings_ui_instance)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
