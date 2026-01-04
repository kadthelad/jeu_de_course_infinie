class_name DataUtils
extends Resource

const PLAYER_SAVE_FILE := "user://player_data.json"
const PLAYER_SETTINGS_FILE := "user://player_settings.json"

static func load_player_data() -> void:
	var player_data = JsonUtils.read_json_file(PLAYER_SAVE_FILE)
	# Load the data
	if player_data != {}:
		GameManager.coins_player_purse = player_data["coins"]

static func save_player_data() -> void:
	# Put the data in a dictionary
	var player_data := {}
	player_data["coins"] = GameManager.coins_player_purse
	
	JsonUtils.write_json_file(PLAYER_SAVE_FILE, player_data)

static func load_player_settings() -> Dictionary:
	return JsonUtils.read_json_file(PLAYER_SETTINGS_FILE)

static func save_player_settings(settings_dict: Dictionary) -> void:
	JsonUtils.write_json_file(PLAYER_SETTINGS_FILE, settings_dict)
