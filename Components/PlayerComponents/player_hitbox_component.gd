extends Node

## The parent MUST be the player
@onready var player: Player = get_parent()

# Hitbox detection (lose the game)
func _on_hitbox_area_entered(area: Area3D) -> void:
	if area.is_in_group("Obstacles"):
		GameManager.game_speed = GameManager.DEFAULT_GAME_SPEED
		GameManager.game_state = GameManager.GAME_STATES.ENDED
		print("Game Over!")

# Detect ground (step on obstacles)
func _on_ground_detector_area_entered(area: Area3D) -> void:
	if area.is_in_group("Obstacles"):
		player.is_on_ground = true

func _on_ground_detector_area_exited(area: Area3D) -> void:
	if area.is_in_group("Obstacles"):
		player.is_on_ground = false


func _on_interact_box_area_entered(area: Area3D) -> void:
	if area.is_in_group("Collectibles"):
		if area.is_in_group("Coin"):
			GameManager.current_coins += 1
		area.queue_free()
