extends Node

signal move_upper_line
signal move_lower_line
signal jump
signal slide

func _input(event: InputEvent) -> void:
	# Game inputs
	if event.is_action_pressed("game_up"):
		move_upper_line.emit()
	
	if event.is_action_pressed("game_down"):
		move_lower_line.emit()
	
	if event.is_action_pressed("game_jump"):
		jump.emit()
	
	if event.is_action_pressed("game_slide"):
		slide.emit()
