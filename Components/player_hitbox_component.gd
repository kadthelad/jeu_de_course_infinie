extends Node

## The parent MUST be the player
@onready var player: Player = get_parent()

# Hitbox detection (lose the game)
func _on_hitbox_area_entered(area: Area2D) -> void:
	if area is Obstacle:
		GameManager.game_speed = 0
		GameManager.is_game_on = false
		print("Game Over!")

# Detect ground (step on obstacles)
func _on_ground_detector_area_entered(area: Area2D) -> void:
	if area is Obstacle:
		player.is_on_ground = true

func _on_ground_detector_area_exited(area: Area2D) -> void:
	if area is Obstacle:
		player.is_on_ground = false
