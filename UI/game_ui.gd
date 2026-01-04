extends CanvasLayer

@onready var coin_label: Label = %CoinLabel
@onready var speed_label: Label = %SpeedLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager._update_game_ui.connect(update_ui)
	update_ui()


func update_ui() -> void:
	coin_label.text = tr("game_coins") + str(GameManager.current_coins)
	speed_label.text = tr("game_speed") + str(int(GameManager.game_speed))
