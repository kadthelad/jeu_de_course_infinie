extends CanvasLayer


func _on_continue_button_pressed() -> void:
	GameManager.game_state = GameManager.GAME_STATES.RUNNING
	queue_free()


func _on_settings_button_pressed() -> void:
	var settings_ui_instance := SceneUtils.SETTINGS_UI_SCENE.instantiate()
	get_parent().add_child(settings_ui_instance)


func _on_main_menu_button_pressed() -> void:
	GameManager.game_state = GameManager.GAME_STATES.ENDED


func _on_quit_button_pressed() -> void:
	get_tree().root.queue_free()
