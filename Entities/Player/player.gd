class_name Player
extends Node2D

# Constants
const JUMP_VELOCITY = -400.0

# Exports
@export var ground: Node2D ## ground is supposed to have "Line1", "Line2", ... as children.

# Onready
@onready var player_movement_component: Node = $PlayerMovementComponent

@onready var character_body_2d: CharacterBody2D = $CharacterBody2D
@onready var standing_collison_shape_2d: CollisionShape2D = %StandingCollisonShape2D
@onready var sliding_collison_shape_2d: CollisionShape2D = %SlidingCollisonShape2D
@onready var sliding_timer: Timer = %SlidingTimer
@onready var top_shape_cast_2d: ShapeCast2D = %TopShapeCast2D
@onready var bottom_shape_cast_2d: ShapeCast2D = %BottomShapeCast2D

# Variables
var lines_array: Array[Marker2D] = []
var current_line_index: int
var current_line_position: Vector2

var is_on_ground := false
var is_jumping := false
var is_sliding := false


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
	GameManager._game_started.connect(_on_game_started)
	GameManager._game_ended.connect(_on_game_ended)

## This replaces the is_on_floor() method.
## In this game, the player does not walk nor move at all except for jumping.
## But also the player stays in place on a marker (which is a line)
## This also verifies if the player is stepping on an obstacle
func is_on_line() -> bool:
	# Verification
	if current_line_position == null:
		return true
	
	if is_on_ground:
		return is_on_ground
	
	if character_body_2d.global_position.y - global_position.y <= 1:
		return false
	return true

func _physics_process(delta: float) -> void:
	character_body_2d.global_position.x = 0
	# Add the gravity.
	if not is_on_line():
		character_body_2d.velocity += character_body_2d.get_gravity() * delta
	else:
		character_body_2d.velocity = Vector2.ZERO
	
	# Handle jump.
	if is_jumping and is_on_line():
		character_body_2d.velocity.y = JUMP_VELOCITY
	is_jumping = false
	character_body_2d.move_and_slide()

# Other conections
func _on_game_started() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT

func _on_game_ended() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED

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
	standing_collison_shape_2d.set_deferred("disabled", is_sliding)
	sliding_collison_shape_2d.set_deferred("disabled", !is_sliding)
	sliding_timer.start()

func _on_sliding_timer_timeout() -> void:
	is_sliding = false
	
	# Setup collisions
	standing_collison_shape_2d.set_deferred("disabled", is_sliding)
	sliding_collison_shape_2d.set_deferred("disabled", !is_sliding)
