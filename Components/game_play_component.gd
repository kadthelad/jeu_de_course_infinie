extends Node

# Exports
@export var player: Player ## Player Scene...

func _ready() -> void:
	# Verifications
	if player == null:
		PrintUtils.print_err("The player variable is not set in GamePlayComponent on map " +
		get_parent().name + "! The game cannot start.")
		return
	
	# Setup GameManager
	GameManager._game_ended.connect(_on_game_ended)
	GameManager._game_started.connect(_on_game_started)

func _on_obstacle_spawn_timer_timeout() -> void:
	if player.lines_array == null:
		return
	var random_line: Marker3D = player.lines_array.pick_random()
	var instanciated_obstacle: Node3D = GameManager.small_obstacles.pick_random().instantiate()
	add_child(instanciated_obstacle)
	instanciated_obstacle.global_position = random_line.global_position + Vector3(6, 0, 0)

func _on_game_ended() -> void:
	%ObstacleSpawnTimer.stop()

func _on_game_started() -> void:
	%ObstacleSpawnTimer.start()
