class_name GamePlayComponent
extends Node

# Exports
@export var player: Player

# Constants
const GAME_SPEED_UP_RATE := 10

# Onready
@onready var obstacle_spawn_timer: Timer = %ObstacleSpawnTimer
@onready var game_speed_up_timer: Timer = %GameSpeedUpTimer
@onready var obstacles: Node3D = %Obstacles

func _ready() -> void:
	# Verifications
	if player == null:
		PrintUtils.print_err("The player variable is not set in GamePlayComponent on map " +
		get_parent().name + "! The game cannot start.")
		return
	
	# Setup GameManager
	GameManager._game_state_changed.connect(_on_game_state_changed)
	
	# Connect the player's hotbar inputs
	await player.tree_entered
	player.player_input_component.use_item.connect(use_item)

func _on_obstacle_spawn_timer_timeout() -> void:
	if player.lines_array == null:
		return
	var instanciated_obstacle: Node3D = GameManager.obstacles_array.pick_random().instantiate()
	obstacles.add_child(instanciated_obstacle)
	instanciated_obstacle.spawn(self)
	instanciated_obstacle.global_position += Vector3(16, -1, 0)

func _on_game_state_changed() -> void:
	match GameManager.game_state:
		GameManager.GAME_STATES.STARTED: # Game started
			game_speed_up_timer.start()
			obstacle_spawn_timer.start()
			GameManager.current_coins = 0
			get_parent().process_mode = Node.PROCESS_MODE_INHERIT
		GameManager.GAME_STATES.ENDED: # Game ended
			game_speed_up_timer.stop()
			obstacle_spawn_timer.stop()
			GameManager.coins_player_purse += GameManager.current_coins
		GameManager.GAME_STATES.PAUSED: # Game paused
			get_parent().process_mode = Node.PROCESS_MODE_DISABLED
		GameManager.GAME_STATES.RUNNING: # Game running
			get_parent().process_mode = Node.PROCESS_MODE_INHERIT


func _on_game_speed_up_timer_timeout() -> void:
	GameManager.game_speed += GAME_SPEED_UP_RATE

func use_item(hotbar_nb) -> void:
	if player.effect_timer.is_stopped():
		if GameManager.player_hotbar[hotbar_nb] != null:
			GameManager.player_hotbar[hotbar_nb].effect.use(player, self)
