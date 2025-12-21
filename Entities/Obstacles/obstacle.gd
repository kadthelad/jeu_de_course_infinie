class_name Obstacle
extends Area2D

@onready var game_speed := GameManager.game_speed

func _ready() -> void:
	var visible_on_screen_notifier := VisibleOnScreenNotifier2D.new()
	visible_on_screen_notifier.screen_exited.connect(_on_screen_exited)
	add_child(visible_on_screen_notifier)
	GameManager._game_speed_changed.connect(_on_game_speed_changed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += (game_speed * delta) * Vector2.LEFT

func _on_game_speed_changed(new_speed) -> void:
	game_speed = new_speed

func _on_screen_exited() -> void:
	queue_free()
