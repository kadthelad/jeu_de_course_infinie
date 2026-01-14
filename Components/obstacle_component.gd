class_name Obstacle
extends Node

@onready var obstacles: Node3D = %Obstacles ## Contains all of the obstacles
@onready var coins: Node3D = %Coins ## Contains all of the coins

@onready var game_speed := GameManager.game_speed

var visible_on_screen_notifier := VisibleOnScreenNotifier3D.new()

func _ready() -> void:
	# Add the obstacle deletion logic
	visible_on_screen_notifier.screen_entered.connect(_on_screen_entered)
	add_child.call_deferred(visible_on_screen_notifier)
	GameManager._game_speed_changed.connect(_on_game_speed_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.position += (game_speed / 100 * delta) * Vector3.LEFT

func _on_game_speed_changed(new_speed) -> void:
	game_speed = new_speed

func _on_screen_entered() -> void:
	visible_on_screen_notifier.screen_exited.connect(_on_screen_exited)

func _on_screen_exited() -> void:
	destroy()

## This verifies and spawns all the obstacles on the lines at the right position for each obstacle.
## [br]
## The obstacle will be deleted if it can't spawn!
## This also handles the coins spawning
func spawn(game_play_component: GamePlayComponent) -> void:
	var lines_used := 1
	if obstacles != null: # this variable is only valid for large obstacles
		lines_used = obstacles.get_child_count()
	
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
		if coins != null:
			i = lines_array.find(selected_line)
			for coin : Node3D in coins.get_children():
				coin.global_position.z = lines_array[i].position.y
				i += 1
			# Randomize the apparition of coins, can have either:
			# - One line of coins
			# - No coins at all
			# - All lines of coins
			var random_value := randf()
			if random_value < 0.33: # One line of coins
				var kept_coins = coins.get_children().pick_random()
				for coin : Node3D in coins.get_children():
					if coin != kept_coins:
						coin.queue_free()
			elif random_value > 0.33 and random_value < 0.66: # No coins at all
				for coin : Node3D in coins.get_children():
					coin.queue_free()
			# Else, keep all of the coins
	else:
		self.global_position.y = lines_array[i].position.z

func destroy() -> void:
	queue_free()
