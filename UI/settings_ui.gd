extends CanvasLayer

@onready var fullscreen_check_button: CheckButton = %FullscreenCheckButton
var settings_dict := {
	"screen_fullscreen":false,
	"sound_master":50,
	"sound_music":50,
	"sound_effects":50,
	"sound_voices":50,
}

func _ready() -> void:
	load_settings()

func load_settings() -> void:
	var saved_settings_dict = DataUtils.load_player_settings()
	if !(saved_settings_dict == null or saved_settings_dict == {}):
		settings_dict = saved_settings_dict
	
	# Load the settings
	# SOUND
	%MasterSlider.value = settings_dict["sound_master"]
	%MusicSlider.value = settings_dict["sound_music"]
	%EffectsSlider.value = settings_dict["sound_effects"]
	%VoicesSlider.value = settings_dict["sound_voices"]
	
	# SCREEN
	%FullscreenCheckButton.button_pressed = settings_dict["screen_fullscreen"]

func _on_fullscreen_check_button_pressed() -> void:
	settings_dict["screen_fullscreen"] = fullscreen_check_button.button_pressed
	if fullscreen_check_button.button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_back_button_pressed() -> void: # Quit settings
	# Save settings
	settings_dict["sound_master"] = %MasterSlider.value
	settings_dict["sound_music"] = %MusicSlider.value
	settings_dict["sound_effects"] = %EffectsSlider.value
	settings_dict["sound_voices"] = %VoicesSlider.value
	DataUtils.save_player_settings(settings_dict)
	
	# Clear
	queue_free()
