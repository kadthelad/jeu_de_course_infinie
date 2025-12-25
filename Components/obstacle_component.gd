class_name Obstacle
extends Node

@export var obstacles: Node3D = null ## Contains all of the obstacles

@onready var game_speed := GameManager.game_speed
@onready var parent := get_parent() ## The obstacle node

func _ready() -> void:
	# Add the obstacle deletion logic
	var visible_on_screen_notifier := VisibleOnScreenNotifier3D.new()
	visible_on_screen_notifier.screen_exited.connect(_on_screen_exited)
	
	# Spawn the obstacles on the lines, if possible
	spawn()
	parent.add_child.call_deferred(visible_on_screen_notifier)
	GameManager._game_speed_changed.connect(_on_game_speed_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	parent.position += (game_speed / 100 * delta) * Vector3.LEFT

func _on_game_speed_changed(new_speed) -> void:
	game_speed = new_speed

func _on_screen_exited() -> void:
	destroy()

## This verifies and spawns all the obstacles on the lines at the right position for each obstacle.
## [br]
## The obstacle will be deleted if it can't spawn!
func spawn() -> void:
	var lines_used := 1
	if obstacles != null: # this variable is only valid for large obstacles
		lines_used = obstacles.get_child_count()
	
	# Add the lines detection logic
	# [NOTE] The obstacle's parent should be the game_play_component Node
	# if it is the game_play_component Node, it SHOULD have a player variable.
	var game_play_component := parent.get_parent()
	if game_play_component == null:
		PrintUtils.print_err("game_play_component is not found on obstacle " + parent.name + "!")
		destroy()
		return
	
	# We get the lines that the player registered
	var lines_array: Array[Marker3D] = game_play_component.player.lines_array
	# Verify if we got enough lines, if not, delete this obstacle.
	if lines_used > lines_array.size():
		destroy()
		return
	
	# Find the lines we can use
	var selected_line: Marker3D = lines_array.pick_random()
	while !(lines_array.size() - lines_array.find(selected_line) >= lines_used):
		selected_line = lines_array.pick_random()
	
	# Place the obstacles on those lines
	var i := lines_array.find(selected_line)
	if obstacles != null:
		for obstacle : Node3D in obstacles.get_children():
			obstacle.global_position.z = lines_array[i].position.y
			i += 1
	else:
		parent.global_position.y = lines_array[i].position.y

func destroy() -> void:
	parent.queue_free()
