class_name Player
extends Node3D

# Constants
const JUMP_VELOCITY := 8.0
const WEIGHT := 1.75
const PLAYER_FEET_POSITION := Vector3(0, -1, 0)

# Exports
@export var ground: Node3D ## ground is supposed to have "Line1", "Line2", ... as children.

# Onready
@onready var player_movement_component: Node = $PlayerMovementComponent

@onready var character_body_3d: CharacterBody3D = $CharacterBody3D
@onready var standing_collison_shape_3d: CollisionShape3D = %StandingCollisonShape3D
@onready var sliding_collison_shape_3d: CollisionShape3D = %SlidingCollisonShape3D
@onready var sliding_timer: Timer = %SlidingTimer
@onready var side_obstacle_detector: Area3D = %SideObstacleDetector
@onready var running_gpu_particles_3d: GPUParticles3D = %RunningGPUParticles3D

# Variables
var lines_array: Array[Marker3D] = []
var current_line_index: int
var current_line_position: Vector3
var moving_direction := true

var is_on_ground := false
var is_jumping := false
var is_sliding := false
var is_moving := false

func _ready() -> void:
	# Verifications
	if ground == null:
		PrintUtils.print_err("The ground variable is not set in Player on map " +
		get_parent().name + "! The game cannot start.")
		return
	
	# Setup
	# Get all the lines the player will be running on
	if ground.get_children().size() <= 0:
		PrintUtils.print_err("The ground variable in Player has no children. The game cannot start.")
		return
	
	lines_array.append_array(ground.get_children())
	# Set the player on the middle line
	current_line_index = roundi(lines_array.size()/2)
	var middle_line_position := lines_array[current_line_index].global_position
	global_position = middle_line_position
	current_line_position = middle_line_position
	
	# Signal connections
	GameManager._game_state_changed.connect(_on_game_state_changed)

## This replaces the is_on_floor() method.
## In this game, the player does not walk nor move at all except for jumping.
## But also the player stays in place on a marker (which is a line)
## This also verifies if the player is stepping on an obstacle
func is_on_line() -> bool:
	# Verification
	if current_line_position == null:
		return true
	
	# If only the player is already on ground, return true
	if is_on_ground:
		running_gpu_particles_3d.global_position = character_body_3d.global_position + PLAYER_FEET_POSITION
		return is_on_ground
	running_gpu_particles_3d.position = PLAYER_FEET_POSITION
	# Else, check if the player is on the line
	if character_body_3d.global_position.y - global_position.y > 0.01:
		return false
	return true

func _physics_process(delta: float) -> void:
	character_body_3d.global_position.x = 0
	# Add the gravity.
	if not is_on_line():
		character_body_3d.velocity += character_body_3d.get_gravity() * delta * WEIGHT
		running_gpu_particles_3d.emitting = false
	else:
		character_body_3d.velocity = Vector3.ZERO
		running_gpu_particles_3d.emitting = true
	
	# Handle jump.
	if is_jumping and is_on_line():
		character_body_3d.velocity.y = JUMP_VELOCITY
	is_jumping = false
	character_body_3d.move_and_slide()

# Other conections
func _on_game_state_changed() -> void:
	match GameManager.game_state:
		GameManager.GAME_STATES.STARTED: # Game started
			process_mode = Node.PROCESS_MODE_INHERIT
		GameManager.GAME_STATES.ENDED: # Game ended
			call_deferred("set_process_mode", Node.PROCESS_MODE_DISABLED) # Deferred to remove an error when game over

# Player Input Component
func _on_player_input_component_move_upper_line() -> void:
	player_movement_component.move_line(true)

func _on_player_input_component_move_lower_line() -> void:
	player_movement_component.move_line(false)

func _on_player_input_component_jump() -> void:
	is_jumping = true

func _on_player_input_component_slide() -> void:
	if is_sliding:
		return
	is_sliding = true
	
	# Setup collisions
	standing_collison_shape_3d.set_deferred("disabled", is_sliding)
	sliding_collison_shape_3d.set_deferred("disabled", !is_sliding)
	sliding_timer.start()

func _on_sliding_timer_timeout() -> void:
	is_sliding = false
	
	# Setup collisions
	standing_collison_shape_3d.set_deferred("disabled", is_sliding)
	sliding_collison_shape_3d.set_deferred("disabled", !is_sliding)
