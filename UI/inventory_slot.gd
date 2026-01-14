class_name InventorySlot
extends Panel

@onready var image_texture_rect: TextureRect = %ImageTextureRect
@onready var number_label: Label = %NumberLabel
@onready var quantity_label: Label = %QuantityLabel
@onready var progress_bar: ProgressBar = %ProgressBar

@onready var player_effect_timer: Timer = %PlayerEffectTimer

func _process(delta: float) -> void:
	if !player_effect_timer.is_stopped():
		progress_bar.value = (1.0 - player_effect_timer.time_left / player_effect_timer.wait_time) * 100.0

func _on_player_effect_timer_timeout() -> void:
	progress_bar.value = 0
