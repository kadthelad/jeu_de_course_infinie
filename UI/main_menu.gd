extends CanvasLayer

@onready var main : Main = get_parent() ## The parent is always main
@onready var purse_label: Label = %PurseLabel

func _ready() -> void:
	if main != null:
		GameManager._update_game_ui.connect(update_ui)

func update_ui() -> void:
	purse_label.text = "%s: %s" % [tr("game_total_coins"), str(GameManager.coins_player_purse)]

func _on_start_game_button_pressed() -> void:
	GameManager.game_state = GameManager.GAME_STATES.STARTED
	queue_free()

func _on_settings_button_pressed() -> void:
	var settings_ui_instance := SceneUtils.SETTINGS_UI_SCENE.instantiate()
	add_child(settings_ui_instance)

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_shop_button_pressed() -> void:
	var shop_ui_instance := SceneUtils.SHOP_UI_SCENE.instantiate()
	main.add_child(shop_ui_instance)

func _on_inventory_button_pressed() -> void:
	var inventory_ui_instance := SceneUtils.INVENTORY_UI_SCENE.instantiate()
	main.add_child(inventory_ui_instance)
