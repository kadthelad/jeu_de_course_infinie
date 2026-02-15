class_name CoinDoublerEffect
extends ItemEffect
### Coin Doubler ItemEffect ###

func _init() -> void:
	effect_duration = 10

func use(player: Player, game_play_component: GamePlayComponent) -> void:
	player.effect_timer.wait_time = effect_duration
	player.effect_timer.start()
	if !player.effect_timer.timeout.is_connected(_on_effect_out):
		player.effect_timer.timeout.connect(_on_effect_out.bind(player))
	
	player.coin_income_multiplier = 2.0

func _on_effect_out(player: Player) -> void:
	player.coin_income_multiplier = 1.0
