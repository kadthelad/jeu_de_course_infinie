class_name ObstacleRemoverEffect
extends ItemEffect
### Obstacle Remover ItemEffect ###

func _init() -> void:
	effect_duration = 1

func use(player: Player, game_play_component: GamePlayComponent) -> void:
	if !(game_play_component.obstacles.get_children().size() <= 0):
		for obstacle in game_play_component.obstacles.get_children():
			obstacle.queue_free()
	player.effect_timer.wait_time = effect_duration
	player.effect_timer.start()
