extends Node

# Exports
@export var player: Player ## Player Scene...

# Constants
const GAME_SPEED_UP_RATE := 10

func _ready() -> void:
	# Verifications
	if player == null:
		PrintUtils.print_err("The player variable is not set in GamePlayComponent on map " +
		get_parent().name + "! The game cannot start.")
		return
	
	# Setup GameManager
	GameManager._game_state_changed.connect(_on_game_state_changed)

func _on_obstacle_spawn_timer_timeout() -> void:
	if player.lines_array == null:
		return
	var instanciated_obstacle: Node3D = GameManager.obstacles_array.pick_random().instantiate()
	add_child(instanciated_obstacle)
	instanciated_obstacle.global_position += Vector3(16, -1, 0)

func _on_game_state_changed() -> void:
	match GameManager.game_state:
		GameManager.GAME_STATES.STARTED: # Game started
			%GameSpeedUpTimer.start()
			%ObstacleSpawnTimer.start()
		GameManager.GAME_STATES.ENDED: # Game ended
			%GameSpeedUpTimer.stop()
			%ObstacleSpawnTimer.stop()
			GameManager.current_coins = 0
		GameManager.GAME_STATES.PAUSED:
			get_parent().process_mode = Node.PROCESS_MODE_DISABLED
		GameManager.GAME_STATES.RUNNING:
			get_parent().process_mode = Node.PROCESS_MODE_INHERIT


func _on_game_speed_up_timer_timeout() -> void:
	GameManager.game_speed += GAME_SPEED_UP_RATE
