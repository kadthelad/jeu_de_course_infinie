class_name SpeedIncreaserEffect
extends ItemEffect
### Speed Increaser ItemEffect ###

var previous_speed := 0.0

func _init() -> void:
	effect_duration = 5

func use(player: Player, game_play_component: GamePlayComponent) -> void:
	game_play_component.game_speed_up_timer.stop()
	player.effect_timer.wait_time = effect_duration
	player.effect_timer.start()
	player.effect_timer.timeout.connect(_on_effect_out.bind(game_play_component))
	
	previous_speed = GameManager.game_speed
	GameManager.game_speed += 200

func _on_effect_out(game_play_component: GamePlayComponent) -> void:
	game_play_component.game_speed_up_timer.start()
	GameManager.game_speed = previous_speed
