class_name ItemEffect
extends Resource

var effect_duration := 1.0

func use(player: Player, game_play_component: GamePlayComponent) -> void:
	PrintUtils.print_wrn("ItemEffect.use() is not set to do anything!")
