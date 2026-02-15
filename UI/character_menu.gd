extends CanvasLayer

@onready var character_selector: CharacterSelector = %CharacterSelector

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	character_selector.character_name_label = %CharacterNameLabel
	%PreviousButton.connect("pressed", character_selector.next_character.bind(-1))
	%NextButton.connect("pressed", character_selector.next_character.bind(1))
	%SelectButton.connect("pressed", character_selector.select_character)


func _on_back_button_pressed() -> void:
	queue_free()
