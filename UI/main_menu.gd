extends CanvasLayer


func _on_start_game_button_pressed() -> void:
	GameManager.is_game_on = true
	queue_free()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
