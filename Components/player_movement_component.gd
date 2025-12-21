extends Node

## The parent MUST be the player
@onready var player: Player = get_parent()

## Will move to the up direction by default.
## First parameter can be set to false to make it go on a lower line.
func move_line(direction_up:=true) -> void:
	var direction := 1 if direction_up else -1
	var cast = player.top_shape_cast_2d if direction_up else player.bottom_shape_cast_2d
	
	# Attempt to change lines and do if possible
	if cast.is_colliding():
		return
	player.current_line_index = clampi(player.current_line_index-direction, 0, player.lines_array.size()-1)
	
	player.current_line_position = player.lines_array[player.current_line_index].global_position
	
	# Move the player to the new line
	var tween = get_tree().create_tween()
	tween.tween_property(player, "global_position", player.current_line_position, 0.1)
