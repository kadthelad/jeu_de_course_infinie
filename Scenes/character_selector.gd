class_name CharacterSelector
extends Node3D

@onready var character_body_3d: CharacterBody3D = %CharacterBody3D
@onready var animation_player: AnimationPlayer = character_body_3d.find_child("CharacterAnimationPlayer")

var character_name_label: Label = null:
	set(value):
		character_name_label = value
		character_name_label.text = current_character.to_pascal_case()

var selection_anim = "selection"

var current_character := "ninja"

const CHARACTER_LIST := ["ninja"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Find the player's character and setup the appropriate animations
	if !animation_player.has_animation_library(current_character):
		current_character = "ninja" # Set player character to default character, ninja
	selection_anim = current_character+"/selection"
	animation_player.play(selection_anim)

func next_character(val: int) -> void:
	# Don't change character if not possible
	var current_index := CHARACTER_LIST.find(current_character)
	if current_index + val >= CHARACTER_LIST.size() or current_index + val < 0:
		return
	current_character = CHARACTER_LIST[current_index + val]
	if character_name_label != null:
		character_name_label.text = current_character.to_pascal_case()

func select_character() -> void:
	GameManager.player_character = current_character
	DataUtils.save_player_data("character")
