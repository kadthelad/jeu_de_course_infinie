extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager._update_game_ui.connect(update_ui)
	update_ui()


func update_ui() -> void:
	%CoinLabel.text = "Coins: " + str(GameManager.current_coins)
	%SpeedLabel.text = "Speed: " + str(int(GameManager.game_speed))
