class_name PlayerInputComponent
extends Node

# Movement signals
signal move_upper_line
signal move_lower_line
signal jump
signal slide

# Hotbar signals
signal use_item

func _input(event: InputEvent) -> void:
	# == Game inputs ==
	# Movement inputs
	if event.is_action_pressed("game_up"):
		move_upper_line.emit()
	if event.is_action_pressed("game_down"):
		move_lower_line.emit()
	if event.is_action_pressed("game_jump"):
		jump.emit()
	if event.is_action_pressed("game_slide"):
		slide.emit()
	
	# Hotbar inputs
	if event.is_action_pressed("game_hotbar_1"):
		use_item.emit(0)
	if event.is_action_pressed("game_hotbar_2"):
		use_item.emit(1)
	if event.is_action_pressed("game_hotbar_3"):
		use_item.emit(2)
