extends Node

## The parent MUST be the player
@onready var player: Player = get_parent()
@onready var hitbox: Area3D = %Hitbox

# Hitbox detection (lose the game)
func _on_hitbox_area_entered(area: Area3D) -> void:
	if area.is_in_group("Obstacles"):
		GameManager.game_speed = GameManager.DEFAULT_GAME_SPEED
		GameManager.game_state = GameManager.GAME_STATES.ENDED

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
			GameManager.current_coins += int(1 * player.coin_income_multiplier)
		area.queue_free()


func _on_side_obstacle_detector_area_entered(area: Area3D) -> void:
	if player.is_moving:
		if area.is_in_group("Obstacles"):
			# Go back to previous line if line change is impossible
			hitbox.monitoring = false
			player.player_movement_component.move_line(!player.moving_direction)
			# Put a cooldown so the player doesn't die as it collides with the side of the obstacle
			var damage_cooldown_timer := Timer.new()
			add_child(damage_cooldown_timer)
			damage_cooldown_timer.start()
			await damage_cooldown_timer.timeout
			hitbox.monitoring = true
