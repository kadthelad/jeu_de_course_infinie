extends Node3D

const LIGHT_SPEED := 0.2

@onready var light: Node3D = %Light

func _process(delta: float) -> void:
	light.rotate_z(LIGHT_SPEED * delta)
